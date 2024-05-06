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
done  < ct_schedule
# cat $(ls -1 ./sql/*.sql | sort -fd) > ./sql/${Instance}.sql

rm -f  ct_regress.tmp
touch  ct_regress.tmp
echo spool ./results/gs_lcovt_all.out  >> ct_regress.tmp
echo @./sql/gs_lcovt_all.sql           >> ct_regress.tmp
echo spool off;                        >> ct_regress.tmp
echo exit                              >> ct_regress.tmp
cat ct_regress.tmp
../../bin/ctsql sys/sys@127.0.0.1:1611  <  ct_regress.tmp
#./ct_regress --bindir=../../bin/ctsql --host=127.0.0.1 --port=1611 --schedule=./ct_schedule_lcovt
