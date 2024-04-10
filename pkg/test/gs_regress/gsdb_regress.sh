cp ../../bin/gs_regress .
cp ../../bin/ctconn_demo .
cp ../../bin/ctsql     .
chmod u+x gs_regress
chmod u+x ctconn_demo
rm -rf ./results/*
rm -rf ${CTDB_HOME}/cumu_*.bak*
rm -rf ${CTDB_HOME}/cantiandb_*.bak*
export CTSQL_SSL_QUIET=TRUE
./gs_regress --bindir=../../bin/ctsql --host=127.0.0.1 --port=1611 --schedule=./gs_schedule
if [ $? -eq 0 ];then
   echo "    gs_regress        :  OK"
   echo "********************* END: gs_regress *********************"
else
   echo "    gs_regress        :  FAILED"
   echo "********************* END: gs_regress *********************"
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

