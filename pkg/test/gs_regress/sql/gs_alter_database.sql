alter database set standby database to maximize availability;
alter database set standby database to maximize performance;
alter database archivelog;
alter database datafile 'user' online;
alter database datafile 'user' offline;
alter database datafile 'user' resize 64M;
alter database datafile 'system' resize 64M;
alter database datafile 'system' resize 256M;
alter database datafile 'user' autoextend off;
alter database datafile 'user' autoextend on;
alter database datafile 'user' autoextend on next 10M maxsize 128M;
alter database datafile 'user' resize 256M;
alter database datafile 'zhangsan', 'user' resize 100M;
alter database datafile 'user', 'zhangsan' resize 100M;
alter database datafile 'zhangsan', 3 resize 100M;
alter database datafile 3, 'zhangsan' resize 100M;
alter database datafile 100, 3 resize 100M;
alter database datafile 3, 100 resize 100M;
alter database set standby database to maximize default;
alter database set not_standby;
alter database set standby not_database;
alter database set standby database not_to;
alter database set standby database to not_maximize;
alter database register;
alter database register NOT_PHYSICAL;
alter database register PHYSICAL NOT_LOGFILE;
alter database register PHYSICAL LOGFILE invalidfilename;
alter database register PHYSICAL LOGFILE 'filename' not_end;
alter database register PHYSICAL LOGFILE 'filename';
alter database convert;
alter database convert not_to;
alter database convert to not_physical;
alter database convert to physical not_standby;
alter database convert to physical standby not_end;
alter session;
alter session not_set;
alter session set;
alter session set COMMIT_WAIT_LOGGING !a; 
alter session set COMMIT_WAIT_LOGGING = a;
alter session set COMMIT_MODE !a; 
alter session set COMMIT_MODE = a;
alter session set COMMIT_MODE = 'abc';
alter database recover;
alter database recover automatic;
alter database recover to; 
alter database recover unexpected;
alter database clear logfile 1000;
alter database open restrict force ignore logs;
alter database open force ignore logs;
recover database until cancel;
comment in abc;
create table TEST_TABLE_001 (id int) system 129;
create table TEST_TABLE_001 (id int) system 64;
create table TEST_TABLE_001 (id int) system 1023;
create table TEST_TABLE_001 (id int) system 1536;
create table TEST_TABLE_001 (id int) system 1024 system 1025;
create table TEST_TABLE_001 (id int);
create index IX_TAB_001 on TEST_TABLE_001 (id) initrans 233 initrans 233;
create index IX_TAB_001 on TEST_TABLE_001 (id) tablespace aaa tablespace bbb;
drop table if exists TEST_TABLE_001;

create table TEST_TABLE_002 (id int) pctfree 12 pctfree 12;
create table TEST_TABLE_002 (id int) pctfree 7;
create table TEST_TABLE_002 (id int) pctfree 81;
create table TEST_TABLE_003 (id int, id char);
create table TEST_TABLE_003 (id serial default 10);
create table TEST_TABLE_003 (id serial default 10 on update 12);
create table TEST_TABLE_003 (id int default 10 on update 122222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222);
create table TEST_TABLE_004 (id int) partition by range (id) (partition "abc" values less than (100) tablespace users initrans 200 pctfree 79);
create table TEST_TABLE_005 (id int) partition by range (id) (partition "abc" values less than (100) undo);
drop table if exists TEST_TABLE_002;
drop table if exists TEST_TABLE_003;
drop table if exists TEST_TABLE_004;
drop table if exists TEST_TABLE_005;
-- lock table
create table TEST_TABLE_001 (id int);
lock table TEST_TABLE_001 in shard mode nowait;
commit;
lock table TEST_TABLE_001 in shard mode wait -1;
lock table TEST_TABLE_001 in shard mode wait 1;
select sleep(3);
commit;
lock table TEST_TABLE_001 in shard mode wait 0;
commit;
drop table TEST_TABLE_001

--DTS2018051601318
ALTER DATABASE DATAFILE  '/home/test/CTDB/dn3/data/user' OFFLINE ;
ALTER DATABASE DATAFILE  '/home/test/CTDB/dn3/data/user' OFFLINE FOR DROP;
ALTER DATABASE DATAFILE  '/home/test/CTDB/dn3/data/user' ONLINE;
ALTER DATABASE DATAFILE  '/home/test/CTDB/dn3/data/user' RESIZE 1000000;

--"ALTER DATABASE DATAFILE" syntax check
ALTER DATABASE DATAFILE  '/home/test/CTDB/dn3/data/user' "CANTIANDB";
ALTER DATABASE DATAFILE  '/home/test/CTDB/dn3/data/user' DATABASE;
ALTER DATABASE DATAFILE  '/home/test/CTDB/dn3/data/user', AUTOEXTEND ON NEXT 10M;
ALTER DATABASE DATAFILE  '/home/test/CTDB/dn3/data/user', "ABCD" AUTOEXTEND ON NEXT 10M;
ALTER DATABASE DATAFILE  '/home/test/CTDB/dn3/data/user' AUTOEXTEND ON NEXT 10241024102410241024102410241024;
ALTER DATABASE DATAFILE  '/home/test/CTDB/dn3/data/user' AUTOEXTEND ON NEXT -1;
ALTER DATABASE DATAFILE  '/home/test/CTDB/dn3/data/user' AUTOEXTEND OFF NEXT 10M;
ALTER DATABASE DATAFILE  0,1, /* comment */2,3,4,5,6,7,8 AUTOEXTEND /* comment */ON NEXT 1M MAXSIZE UNLIMITED;
ALTER DATABASE DATAFILE  1,2 AUTOEXTEND OFF;
ALTER DATABASE DATAFILE  1,2,1 AUTOEXTEND OFF;  --syntax error
ALTER DATABASE DATAFILE 0 AUTOEXTEND ON NEXT 1M MAXSIZE 10G;
ALTER DATABASE DATAFILE 0 AUTOEXTEND ON MAXSIZE 10G;
ALTER DATABASE DATAFILE 'undo' AUTOEXTEND ON MAXSIZE 32G;
ALTER DATABASE DATAFILE 'TEMP' AUTOEXTEND ON NEXT 64M MAXSIZE 9T;  --syntax error (maxsize too large for temp)
ALTER DATABASE DATAFILE 'TEMP' AUTOEXTEND ON NEXT 64M MAXSIZE 8T;
ALTER DATABASE DATAFILE 'TEMP','undo' AUTOEXTEND ON NEXT 64M MAXSIZE 16G;

--DTS2018051601277
ALTER DATABASE REGISTER PHYSICAL LOGFILE '/home/yq/CTDB/dn3/data/log1';
--DTS2018051601075
ALTER DATABASE RECOVER;
ALTER DATABASE RECOVER AUTOMATIC;
--DTS2018051600861
ALTER DATABASE  BEGIN;
ALTER DATABASE  END;
ALTER DATABASE  START; 
ALTER DATABASE  STOP; 
ALTER DATABASE  ABORT; 
ALTER DATABASE  MOVE;

alter database delete archivelog all force;
conn sys/Huawei@123@127.0.0.1:1611
create user cao1 identified by cao102_cao; 
create user cao2 identified by cao102_cao;
grant connect ,create any table ,create any view  to cao1;
grant connect ,create any table ,create any view  to cao2;
create table t1(id int);
create table cao1.t1(id int,name varchar(10));
create table cao2.t1(id int,name varchar(10),sco int);
insert into t1 values(100);
insert into cao1.t1 values(10,'cao1');
insert into cao2.t1 values(20,'cao2',90);
commit;
select * from t1;
alter session set current_schema=cao1;
select * from t1;
alter session set current_schema=cao2;
select * from t1;
drop user cao1 cascade;
drop user cao2 cascade;
alter database switch logfile; 
alter database clear logfile 5 d;