cp ../../bin/ct_regress .
cp ../../bin/ctconn_demo .
cp ../../bin/ctsql     .
chmod u+x ct_regress
chmod u+x ctconn_demo
rm -rf ./results/*
rm -rf ${CTDB_HOME}/cumu_*.bak*
rm -rf ${CTDB_HOME}/cantiandb_*.bak*
export CTSQL_SSL_QUIET=TRUE
./ct_regress --bindir=../../bin/ctsql --host=127.0.0.1 --port=1611 --schedule=./ct_schedule
if [ $? -eq 0 ];then
   echo "    ct_regress        :  OK"
   echo "********************* END: ct_regress *********************"
else
   echo "    ct_regress        :  FAILED"
   echo "********************* END: ct_regress *********************"
fi

./ctconn_demo
if [ $? -eq 0 ];then
   echo "    ctconn_demo        :  OK"
   echo "********************* END: ctconn_demo *********************"
   exit 0
else
   echo "    ctconn_demo        :  FAILED"
   echo "********************* END: ctconn_demo *********************"
   exit 1
fi

