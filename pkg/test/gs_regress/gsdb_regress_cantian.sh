#!/bin/bash

install_dir=$1
sys_passwd=$2
gs_schedule_list=$3

ctsql=${install_dir}/bin/ctsql

rm -rf ./results/*
rm -rf ${install_dir}/cumu_*.bak*
rm -rf ${install_dir}/cantiandb_*.bak*
export CTSQL_SSL_QUIET=TRUE
./gs_regress --bindir=${ctsql} --user=sys/${sys_passwd} --host=127.0.0.1 --port=1611 --inputdir=./sql/ --outputdir=./results/ --expectdir=./expected/ --schedule=./${gs_schedule_list}
if [ $? -eq 0 ];then
   echo "    gs_regress        :  OK"
   echo "********************* END: gs_regress *********************"
else
   echo "    gs_regress        :  FAILED"
   echo "********************* END: gs_regress *********************"
fi
