drop user if exists test_remap_tables;
create user test_remap_tables identified by Test_123456;
grant dba to test_remap_tables;
conn test_remap_tables/Test_123456@127.0.0.1:1611

-- test bin mode single thread remap_tables, include metadata,data
drop table if exists t1;
drop table if exists t2;
create table t1 (c int);
alter table t1 add constraint t1_pkk primary key(c);
insert into t1 values(1),(2),(10);
commit;
exp tables=t1 remap_tables=t1:t2 filetype=bin file="./data/exp_remap_tables.dmp";
drop table if exists t1;
drop table if exists t2;
imp full = y filetype=bin file="./data/exp_remap_tables.dmp";
select * from t1;
select * from t2;
insert into t2 values(1);

-- test txt mode single thread remap_tables, include metadata,data
drop table if exists t1;
drop table if exists t2;
create table t1 (c int);
alter table t1 add constraint t1_pkk primary key(c);
insert into t1 values(1),(2),(10);
commit;
exp tables=t1 remap_tables=t1:t2 file="./data/exp_remap_tables.dmp";
drop table if exists t1;
drop table if exists t2;
imp full = y file="./data/exp_remap_tables.dmp";
select * from t1;
select * from t2;
insert into t2 values(1);

-- test bin mode multi thread remap_tables, include metadata,data
drop table if exists t1;
drop table if exists t2;
create table t1 (c int);
alter table t1 add constraint t1_pkk primary key(c);
insert into t1 values(1),(2),(10);
commit;
exp tables=t1 remap_tables=t1:t2 filetype=bin parallel = 2 file="./data/exp_remap_tables.dmp";
drop table if exists t1;
drop table if exists t2;
imp full = y filetype=bin file="./data/exp_remap_tables.dmp";
select * from t1;
select * from t2;
insert into t2 values(1);

-- test txt mode multi thread remap_tables, include metadata,data
drop table if exists t1;
drop table if exists t2;
create table t1 (c int);
alter table t1 add constraint t1_pkk primary key(c);
insert into t1 values(1),(2),(10);
commit;
exp tables=t1 remap_tables=t1:t2 parallel = 2 file="./data/exp_remap_tables.dmp";
drop table if exists t1;
drop table if exists t2;
imp full = y file="./data/exp_remap_tables.dmp";
select * from t1;
select * from t2;
insert into t2 values(1);
