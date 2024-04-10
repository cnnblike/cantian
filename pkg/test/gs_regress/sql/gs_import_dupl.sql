create user imp_user1 identified by Huawei#123;
grant create session,alter session,create any table, alter any table, drop any table,select any table, insert any table, update any table, delete any table to imp_user1; 
create user imp_user2 identified by Huawei#123;
grant create session,alter session,create any table, alter any table, drop any table,select any table, insert any table, update any table, delete any table to imp_user2; 
create user imp_user3 identified by Huawei#123;
grant create session,alter session,create any table, alter any table, drop any table,select any table, insert any table, update any table, delete any table to imp_user3; 

conn imp_user1/Huawei#123@127.0.0.1:1611
drop table if exists USR1_T1;
create  table USR1_T1(id integer,num integer); 
insert into USR1_T1(id,num) values(1,111);
insert into USR1_T1(id,num) values(2,222);

drop table if exists USR1_T2;
create  table USR1_T2(id integer,num integer); 
insert into USR1_T2(id,num) values(1,111);
insert into USR1_T2(id,num) values(2,222);

drop table if exists USR1_T3;
create  table USR1_T3(id integer,num integer); 
insert into USR1_T3(id,num) values(1,111);
insert into USR1_T3(id,num) values(2,222);

drop table if exists TABLESPACE;
create  table TABLESPACE(id integer,TABLESPACE integer); 
insert into TABLESPACE(id,TABLESPACE) values(1,111);
commit;

conn imp_user2/Huawei#123@127.0.0.1:1611
drop table if exists USR2_T1;
create  table USR2_T1(id integer,num integer); 
insert into USR2_T1(id,num) values(1,111);
insert into USR2_T1(id,num) values(2,222);

drop table if exists USR2_T2;
create  table USR2_T2(id integer,num integer); 
insert into USR2_T2(id,num) values(1,111);
insert into USR2_T2(id,num) values(2,222);

drop table if exists USR2_T3;
create  table USR2_T3(id integer,num integer); 
insert into USR2_T3(id,num) values(1,111);
insert into USR2_T3(id,num) values(2,222);

conn imp_user3/Huawei#123@127.0.0.1:1611
drop table if exists USR3_T1;
create  table USR3_T1(id integer,num integer); 
insert into USR3_T1(id,num) values(1,111);
insert into USR3_T1(id,num) values(2,222);

drop table if exists USR3_T2;
create  table USR3_T2(id integer,num integer); 
insert into USR3_T2(id,num) values(1,111);
insert into USR3_T2(id,num) values(2,222);

drop table if exists USR3_T3;
create  table USR3_T3(id integer,num integer); 
insert into USR3_T3(id,num) values(1,111);
insert into USR3_T3(id,num) values(2,222);

--get import data
conn sys/sys@127.0.0.1:1611
exp users=imp_user1,imp_user2,imp_user3 file="improtdata.dmp" log="improtlog.log";

--validation import
conn imp_user1/Huawei#123@127.0.0.1:1611
drop table if exists USR1_T1;
drop table if exists USR1_T2;
drop table if exists USR1_T3;
drop table if exists TABLESPACE;
conn imp_user2/Huawei#123@127.0.0.1:1611
drop table if exists USR2_T1;
drop table if exists USR2_T2;
drop table if exists USR2_T3;
conn imp_user3/Huawei#123@127.0.0.1:1611
drop table if exists USR3_T1;
drop table if exists USR3_T2;
drop table if exists USR3_T3;

conn imp_user2/Huawei#123@127.0.0.1:1611
imp users=imp_user1 file="improtdata.dmp" log="improtlog.log" show=y feedback=100;
select * from USR1_T1;
select * from USR2_T1;
imp tables=USR1_T1 file="improtdata.dmp" log="improtlog.log" show=y feedback=100;
select * from USR1_T1;
select * from USR2_T1;
imp tables=USR2_T1,USR2_T2 file="improtdata.dmp" log="improtlog.log" show=y feedback=100;
select * from USR1_T1;
select * from USR2_T1;
select * from USR2_T2;
select * from USR2_T3;
imp tables=% file="improtdata.dmp" log="improtlog.log" show=y feedback=100;
select * from USR1_T1;
select * from USR2_T1;
select * from USR2_T2;
select * from USR2_T3;
select * from USR3_T1;

imp users=imp_user1 file="improtdata.dmp" log="improtlog.log";
select * from USR1_T1;
select * from USR2_T1;
imp tables=USR1_T1 file="improtdata.dmp" log="improtlog.log";
select * from USR1_T1;
select * from USR2_T1;
imp tables=USR2_T1,USR2_T2 file="improtdata.dmp" log="improtlog.log";
select * from USR1_T1;
select * from USR2_T1;
select * from USR2_T2;
select * from USR2_T3;
drop table if exists USR2_T1;
drop table if exists USR2_T2;
drop table if exists USR2_T3;
imp tables=% file="improtdata.dmp" log="improtlog.log";
select * from USR1_T1;
select * from USR2_T1;
select * from USR2_T2;
select * from USR2_T3;
select * from USR3_T1;
drop table if exists USR2_T1;
drop table if exists USR2_T2;
drop table if exists USR2_T3;

conn sys/sys@127.0.0.1:1611
imp users=imp_user2,imp_user3 file="improtdata.dmp" log="improtlog.log" show=y feedback=100;
conn imp_user1/Huawei#123@127.0.0.1:1611
select * from USR1_T1;
conn imp_user2/Huawei#123@127.0.0.1:1611
select * from USR2_T2;
conn imp_user3/Huawei#123@127.0.0.1:1611
select * from USR3_T3;

conn sys/sys@127.0.0.1:1611
imp users=imp_user2,imp_user3 file="improtdata.dmp" log="improtlog.log";
conn imp_user1/Huawei#123@127.0.0.1:1611
select * from USR1_T1;
conn imp_user2/Huawei#123@127.0.0.1:1611
select * from USR2_T2;
conn imp_user3/Huawei#123@127.0.0.1:1611
select * from USR3_T3;

--TSET PARAM CONTENTS AND IGNORE
conn imp_user1/Huawei#123@127.0.0.1:1611
drop table if exists USR1_T1;
drop table if exists USR1_T2;
drop table if exists USR1_T3;
conn imp_user2/Huawei#123@127.0.0.1:1611
drop table if exists USR2_T1;
drop table if exists USR2_T2;
drop table if exists USR2_T3;
conn imp_user3/Huawei#123@127.0.0.1:1611
drop table if exists USR3_T1;
drop table if exists USR3_T2;
drop table if exists USR3_T3;

conn imp_user1/Huawei#123@127.0.0.1:1611
imp tables=% file="improtdata.dmp" log="improtlog.log" content=METADATA_ONLY;
select * from USR1_T1;
select * from USR1_T2;
select * from USR1_T3;
conn imp_user2/Huawei#123@127.0.0.1:1611
create  table USR2_T1(id integer,num integer,extend varchar(8)); 
imp tables=% file="improtdata.dmp" log="improtlog.log" content=DATA_ONLY;
select * from USR2_T1;
select * from USR2_T2;
imp tables=% file="improtdata.dmp" log="improtlog.log" content=DATA_ONLY ignore=Y;
select * from USR2_T1;
select * from USR2_T2;
conn imp_user3/Huawei#123@127.0.0.1:1611
imp tables=USR3_T1,USR3_T2 file="improtdata.dmp" log="improtlog.log" content=ALL;
select * from USR3_T1;
select * from USR3_T2;

--TSET PARAM FULL
conn imp_user1/Huawei#123@127.0.0.1:1611
drop table if exists USR1_T1;
drop table if exists USR1_T2;
drop table if exists USR1_T3;
conn imp_user2/Huawei#123@127.0.0.1:1611
drop table if exists USR2_T1;
drop table if exists USR2_T2;
drop table if exists USR2_T3;
conn imp_user3/Huawei#123@127.0.0.1:1611
drop table if exists USR3_T1;
drop table if exists USR3_T2;
drop table if exists USR3_T3;
conn sys/sys@127.0.0.1:1611
imp file="improtdata.dmp" log="improtlog.log" FULL=Y;
conn imp_user1/Huawei#123@127.0.0.1:1611
select * from USR1_T1;
conn imp_user2/Huawei#123@127.0.0.1:1611
select * from USR2_T1;
conn imp_user3/Huawei#123@127.0.0.1:1611
select * from USR3_T1;

--TSET PARAM REMAP_TABLESPACE
conn sys/sys@127.0.0.1:1611
SELECT TABLE_NAME,TABLESPACE_NAME FROM ALL_TABLES WHERE TABLE_NAME IN('USR1_T1','USR1_T2','USR1_T3','TABLESPACE');
conn imp_user1/Huawei#123@127.0.0.1:1611
drop table if exists USR1_T1;
drop table if exists USR1_T2;
drop table if exists USR1_T3;
imp tables=USR1_T1,USR1_T2,USR1_T3 file="improtdata.dmp" log="improtlog.log" REMAP_TABLESPACE=USERS:IMPUSERS,TEMP:IMPTEMP,USERS:IMPUSERS2;
imp tables=USR1_T1,USR1_T2,USR1_T3 file="improtdata.dmp" log="improtlog.log" REMAP_TABLESPACE=USERS:IMPUSERS;
conn sys/sys@127.0.0.1:1611
CREATE TABLESPACE IMPUSERS DATAFILE 'impusers' SIZE 1G;
conn imp_user1/Huawei#123@127.0.0.1:1611
imp tables=USR1_T1,USR1_T2,USR1_T3,TABLESPACE file="improtdata.dmp" log="improtlog.log" REMAP_TABLESPACE=USERS:IMPUSERS,"INTEGER":IMPUSERS;
conn sys/sys@127.0.0.1:1611
SELECT TABLE_NAME,TABLESPACE_NAME FROM ALL_TABLES WHERE TABLE_NAME IN('USR1_T1','USR1_T2','USR1_T3','TABLESPACE');
DESC imp_user1.TABLESPACE;
DROP TABLESPACE impusers INCLUDING CONTENTS AND DATAFILES;

--TEST IMPORT REMAP_SCHEMA
conn sys/sys@127.0.0.1:1611
create user imp_user4 identified by Huawei#123;
grant create session, create any table, alter any table, drop any table,select any table, insert any table, update any table, delete any table to imp_user4; 
create user imp_user5 identified by Huawei#123;
grant create session, create any table, alter any table, drop any table,select any table, insert any table, update any table, delete any table to imp_user5; 

conn imp_user4/Huawei#123@127.0.0.1:1611
drop table if exists IMP_T1;
create  table IMP_T1(id integer,num integer); 
insert into IMP_T1(id,num) values(1,111);
insert into IMP_T1(id,num) values(2,222);

drop table if exists IMP_T2;
create  table IMP_T2(id integer,num integer); 
insert into IMP_T2(id,num) values(1,111);
insert into IMP_T2(id,num) values(2,222);

conn imp_user5/Huawei#123@127.0.0.1:1611
drop table if exists IMP_T1;
create  table IMP_T1(id integer,num integer); 
insert into IMP_T1(id,num) values(1,111);
insert into IMP_T1(id,num) values(2,222);

drop table if exists IMP_T2;
create  table IMP_T2(id integer,num integer); 
insert into IMP_T2(id,num) values(1,111);
insert into IMP_T2(id,num) values(2,222);

conn sys/sys@127.0.0.1:1611
exp users=imp_user4,imp_user5 file="improt_remap.dmp" log="improtlog.log";

imp file="improt_remap.dmp" log="improtlog.log" remap_schema=imp_user4:imp_user5;
conn imp_user5/Huawei#123@127.0.0.1:1611
select * from IMP_T1;