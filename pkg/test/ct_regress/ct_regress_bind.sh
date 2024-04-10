#/bin/sh

echo "******************** BEGIN: CTSQL parameter binding test ********************"
ctsql_prog=../../bin/ctsql
ctsql_url=sys/sys@127.0.0.1:1611

cat ./sql/gs_cmd_bind.sql | ${ctsql_prog} ${ctsql_url}  > cmd_bind.log
diff -w -B "./expected/gs_cmd_bind.out" "./results/gs_cmd_bind.out" > "./results/gs_cmd_bind.out.diff"

if [ $? -eq 0 ];then
   echo "    gs_cmd_bind             :  OK"
else
   echo "    gs_cmd_bind             :  FAILED"
fi
echo "********************* END: CTSQL parameter binding test *********************"