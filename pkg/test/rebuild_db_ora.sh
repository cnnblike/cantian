#!/bin/sh


cantian_ip="127.0.0.1"
cantian_port="1611"
sys_user_passwd='mHmNxBvw7Uu7LtSvrUIy8NY9womwIuJG9vAlMl0+zNifU7x5TnIz5UOqmkozbTyW'

CTSQLTest_HOME=$(dirname $(readlink -f $0))
gserver_bin=${CTSQLTest_HOME}/../bin/Win32/Debug/cantiand.exe
ctsql_bin=${CTSQLTest_HOME}/../bin/Win32/Debug/ctsql.exe
code_path=${CTSQLTest_HOME}/../../
build_path=${CTSQLTest_HOME}/../../build/
bin_path=${CTSQLTest_HOME}/../bin
vpp_win32_path=${CTSQLTest_HOME}/../library/platform/aes/lib/Windows/32/debug
export CTSQL_SSL_QUIET=TRUE
MACHINE="WIN"

ls ${gserver_bin}

if [ $? -ne 0 ]; then
	MACHINE="LINUX"
	gserver_bin=${code_path}/output/bin/cantiand
	ctsql_bin=${code_path}/output/bin/ctsql
fi

copy_vpp_library()
{
	if [ "$MACHINE" = "WIN" ]; then
		cd ${CTSQLTest_HOME}
		mkdir -p ${bin_path}
		if [ ! -e libipsi_crypto.dll ]; then
			cp ${vpp_win32_path}/* ${bin_path}
		fi
	fi
}

kill_cantiandb()
{
	if [ "$MACHINE" = "LINUX" ]; then
		pkill -9 cantiand
		sleep 2
	else
		ps ux | grep "cantiand" | grep -v "grep" | awk '{print $1}' | xargs kill -9
	fi
}

build_code()
{
	ls ${gserver_bin}
	if [ $? -ne 0 ];then
		if [ "$MACHINE" = "LINUX" ]; then
			kill_cantiandb
			cd ${build_path}
			sh Makefile.sh test >/dev/null 2>&1
			if [ $? -ne 0 ]; then
				echo "Error: failed to build CantianKernel!"
				exit 1
			fi
		else
			echo "Error: has no gserver file, please build manully by Visual Studio!"
			exit 1
		fi
	fi
	
}

init_gsdb_home()
{
	kill_cantiandb
	echo "1. init gsdb_home directory"
	if [ "${CTDB_HOME}" = "" ]; then
		echo "Error: CTDB_HOME is NULL"
		exit 1
	fi
	
	cd $CTDB_HOME
	rm -rf admin  archive_log  cfg  data  log dbs
	if [ $? -ne 0 ]; then
		echo "Error: can not delete ${CTDB_HOME} directory"
		exit 1
	fi
	
	cp -r ${code_path}/pkg/admin ${CTDB_HOME}
	mkdir -p cfg
	mkdir -p data
	mkdir -p log
	cp -r ${code_path}/pkg/test/gs_regress/ssl ${CTDB_HOME}/cfg
	chmod 600 ${CTDB_HOME}/cfg/ssl/*.pem
	cd cfg
	touch cantiand.ini
	echo "LSNR_ADDR = ${cantian_ip}" >>cantiand.ini
	echo "LSNR_PORT = ${cantian_port}" >>cantiand.ini
	echo "USE_NATIVE_DATATYPE = TRUE" >>cantiand.ini
	echo "SSL_CA = ${CTDB_HOME}/cfg/ssl/ca.pem" >>ssl.ini
	echo "SSL_CERT = ${CTDB_HOME}/cfg/ssl/server-cert.pem" >>ssl.ini
	echo "SSL_KEY = ${CTDB_HOME}/cfg/ssl/server-key.pem" >>ssl.ini
	echo "SSL_VERIFY_PEER = FALSE" >>ssl.ini
	echo "IFILE = ssl.ini" >>cantiand.ini
	echo "_SYS_PASSWORD = ${sys_user_passwd}" >>cantiand.ini
	echo "MAX_COLUMN_COUNT = 4096" >>cantiand.ini
	echo "LOCAL_TEMPORARY_TABLE_ENABLED=TRUE" >>cantiand.ini
	echo AUTO_INHERIT_USER = ON >> ${CTDB_HOME}/cfg/cantiand.ini
	if [ "$MACHINE" = "LINUX" ]; then
		echo "SHARED_POOL_SIZE = 512M" >>cantiand.ini
		echo "SESSIONS = 1200" >>cantiand.ini
	fi
}

rebuild_database()
{
	echo "2. rebuild cantian database"
	cd ${CTSQLTest_HOME}
	nohup ${gserver_bin} nomount & 
	if [ $? -ne 0 ]; then
		echo "Error: start gserver nomount failed!"
		exit 1
	fi
	sleep 10
	
	echo "create database cantian LOGFILE ('?/data/log1' size 512M, '?/data/log2' size 512M, '?/data/log3' size 512M) undo tablespace DATAFILE '?/data/undo' size 512M autoextend on next 32M ARCHIVELOG;" | ${ctsql_bin} sys/sys@${cantian_ip}:${cantian_port}
	
	if [ $? -ne 0 ];then 
		kill_cantiandb
		echo "Error: create database failed!"
		exit 1
	fi

	echo "create databse successfully!"
    
    ${ctsql_bin} sys/sys@${cantian_ip}:${cantian_port} -f "ora-dialect.sql" > /dev/null
    if [ $? -ne 0 ];then 
		kill_cantiandb
		echo "install ora-dialect failed!"
		exit 1
	fi
    echo "install ora-dialect successfully!"
    kill_cantiandb
}

copy_vpp_library
build_code
init_gsdb_home
rebuild_database
