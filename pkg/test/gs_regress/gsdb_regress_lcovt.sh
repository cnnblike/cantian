Instance=gs_lcovt_all
rm -f ./sql/${Instance}.sql
touch ./sql/${Instance}.sql
while read -r line
do
	line=${line#*:[ ]}
	line=${line%%[-[:space:]]}  # %%[-[:space:] --> remove unprint char from tail
	# echo $sqlfile
	if [ ${#line} -lt 3 ]; then
		continue
	fi
	sqlfile="./sql/"${line}".sql"
	echo  $sqlfile
	echo "select 'Begin "${sqlfile}"' from sys_dummy;"  >> ./sql/${Instance}.sql
	cat $sqlfile  >> ./sql/${Instance}.sql
	echo   >> ./sql/${Instance}.sql
	echo "select 'END  "${sqlfile}"' from sys_dummy;"  >> ./sql/${Instance}.sql
	echo   >> ./sql/${Instance}.sql
	echo   >> ./sql/${Instance}.sql
done  < gs_schedule
# cat $(ls -1 ./sql/*.sql | sort -fd) > ./sql/${Instance}.sql

rm -f  gs_regress.tmp
touch  gs_regress.tmp
echo spool ./results/gs_lcovt_all.out  >> gs_regress.tmp
echo @./sql/gs_lcovt_all.sql           >> gs_regress.tmp
echo spool off;                        >> gs_regress.tmp
echo exit                              >> gs_regress.tmp
cat gs_regress.tmp
../../bin/ctsql sys/sys@127.0.0.1:1611  <  gs_regress.tmp
#./gs_regress --bindir=../../bin/ctsql --host=127.0.0.1 --port=1611 --schedule=./gs_schedule_lcovt
