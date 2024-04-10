cp ../../bin/ct_regress .
cp ../../bin/ctconn_demo .
cp ../../bin/ctsql     .
chmod u+x ct_regress
chmod u+x ctconn_demo
rm -rf ./results/*
rm -rf ${CTDB_HOME}/cumu_*.bak*
rm -rf ${CTDB_HOME}/cantiandb_*.bak*
export CTSQL_SSL_QUIET=TRUE
# ct_schedule_debug  is the debug version for current daac code pass, some cases have been deleted.
# ./ct_regress --bindir=../../bin/ctsql --host=127.0.0.1 --port=1611 --schedule=./ct_schedule_debug
./ct_regress --bindir=../../bin/ctsql --host=10.0.10.1 --port=1611 --schedule=./ct_schedule
# ./ctconn_demo
