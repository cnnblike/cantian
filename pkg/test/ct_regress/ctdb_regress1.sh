PORT=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:" |head -n 1`
rm -rf ./results/*
rm -rf ${CTDB_HOME}/cumu_*.bak*
rm -rf ${CTDB_HOME}/cantiandb_*.bak*
export CTSQL_SSL_QUIET=TRUE
./ct_regress --bindir=../../bin/ctsql --host=${PORT} --port=1612 --schedule=./ct_schedule_debug
# ./ct_regress --bindir=../../bin/ctsql --host=127.0.0.1 --port=1611 --schedule=./ct_schedule