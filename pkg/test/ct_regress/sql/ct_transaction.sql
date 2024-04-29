--TEST transaction

drop table if exists test_t1;

create table test_t1(f1 int);
insert into test_t1 values(1);prepare transaction '1.abababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababab.abababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababab';
select length(global_tran_id),length(branch_id) from SYS_PENDING_TRANS where format_id=1;
select length(global_tran_id),length(branch_id) from DV_GLOBAL_TRANSACTIONS where format_id=1;
commit prepared '1.abababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababab.abababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababab';
select * from test_t1 order by f1;
select * from SYS_PENDING_TRANS where format_id=1;
select * from DV_GLOBAL_TRANSACTIONS where format_id=1;

insert into test_t1 values(2);prepare transaction '1.ab.cd';
rollback prepared '1.ab.cd';
select * from test_t1 order by f1;
select * from SYS_PENDING_TRANS where global_tran_id = '1.ab.cd';

drop table test_t1;


drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;
drop table if exists t5;
drop table if exists t6;
drop table if exists t7;
drop table if exists t8;
drop table if exists t9;
drop table if exists t10;
drop table if exists t11;
drop table if exists t12;



create table t1(c1 int);
create table t2(c1 int);
create table t3(c1 int);
create table t4(c1 int);
create table t5(c1 int);
create table t6(c1 int);
create table t7(c1 int);
create table t8(c1 int);
create table t9(c1 int);
create table t10(c1 int);
create table t11(c1 int);
create table t12(c1 int);


insert into t1 values(1);
insert into t2 values(1);
insert into t3 values(1);
insert into t4 values(1);
insert into t5 values(1);
insert into t6 values(1);
insert into t7 values(1);
insert into t8 values(1);
insert into t9 values(1);
insert into t10 values(1);
insert into t11 values(1);
insert into t12 values(1);
select FORMAT_ID,GLOBAL_TRAN_ID,BRANCH_ID from sys_pending_trans;
select FORMAT_ID,GLOBAL_TRAN_ID,BRANCH_ID from dv_global_transactions;
prepare transaction '4052000.00095D5D650000006A24000063B6.3D00';
select FORMAT_ID,GLOBAL_TRAN_ID,BRANCH_ID from sys_pending_trans;
select FORMAT_ID,GLOBAL_TRAN_ID,BRANCH_ID from dv_global_transactions;
commit prepared '4052000.00095D5D650000006A24000063B6.3D00';
select FORMAT_ID,GLOBAL_TRAN_ID,BRANCH_ID from sys_pending_trans;
select FORMAT_ID,GLOBAL_TRAN_ID,BRANCH_ID from dv_global_transactions;
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;
drop table if exists t5;
drop table if exists t6;
drop table if exists t7;
drop table if exists t8;
drop table if exists t9;
drop table if exists t10;
drop table if exists t11;
drop table if exists t12;

Alter system set LOCAL_TEMPORARY_TABLE_ENABLED = true;
create temporary table #transaction_stored_anonymous_temp_tabl_014(c1 int, c2 bigint not null);
delete from #transaction_stored_anonymous_temp_tabl_014 where c2>200 and c2<800;
prepare transaction '2076.accabe.000014';
commit prepared '2076.accabe.000014';
drop table if exists #transaction_stored_anonymous_temp_tabl_014;
Alter system set LOCAL_TEMPORARY_TABLE_ENABLED = false;
