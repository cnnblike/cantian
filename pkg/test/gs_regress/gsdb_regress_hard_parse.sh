cp ../../bin/gs_regress .
cp ../../bin/ctconn_demo .
cp ../../bin/ctsql     .
mkdir expected_bak
cp ./expected/* ./expected_bak/
rm -rf ./expected/*
cp ./expected_hard_parse/* ./expected/
chmod u+x gs_regress
chmod u+x ctconn_demo
rm -rf ./results/*
rm -rf ${CTDB_HOME}/cumu_*.bak*
rm -rf ${CTDB_HOME}/cantiandb_*.bak*
export CTSQL_SSL_QUIET=TRUE
./gs_regress --bindir=../../bin/ctsql --host=127.0.0.1 --port=1611 --schedule=./gs_schedule_hard_parse
rm -rf ./expected/*
cp ./expected_bak/* ./expected/
rm -rf ./expected_bak

