conn / as sysdba
create  profile test_pwd_profile limit
SESSIONS_PER_USER      UNLIMITED
FAILED_LOGIN_ATTEMPTS  100
PASSWORD_LIFE_TIME     1800
PASSWORD_REUSE_TIME    UNLIMITED
PASSWORD_REUSE_MAX     UNLIMITED
PASSWORD_LOCK_TIME     1
PASSWORD_GRACE_TIME    7;
drop user if exists test_dba1 cascade;
drop user if exists test_user1 cascade;
drop user if exists test_user2 cascade;
drop user if exists test_dba2 cascade;
drop user if exists test_user3 cascade;
create user  test_dba1  identified by Cantian_234 profile test_pwd_profile;
create user  test_user1 identified by Cantian_234 profile test_pwd_profile;
create user  test_user2 identified by Cantian_234 profile test_pwd_profile;
create user  test_dba2  identified by Cantian_234 profile test_pwd_profile;
create user  test_user3 identified by Cantian_234 profile test_pwd_profile;
grant dba to test_dba1;
grant dba to test_dba2;
grant connect, alter user to test_user1;
grant connect, alter user to test_user2;
grant connect to test_user3;
alter user test_dba2 identified by Root_123 replace Cantian_234;
alter user test_dba2 identified by Cantian_234;
conn test_dba1/Cantian_234@127.0.0.1:1611
alter user test_dba2 identified by Root_123 replace Cantian_234;
alter user test_dba2 identified by Cantian_234;
alter user test_dba1 identified by Root_123;
alter user test_dba1 identified by Root_123 replace Cantian_234;
conn test_user1/Cantian_234@127.0.0.1:1611
alter user test_user2 identified by Root_123 replace Cantian_234;
alter user test_user2 identified by Cantian_234;
alter user test_user3 identified by Root_123 replace Cantian_234;
alter user test_user3 identified by Cantian_234;
alter user test_user1 identified by Root_123;
alter user test_user1 identified by Root_123 replace Cantian_234;
conn / as sysdba 
drop user if exists test_dba1 cascade;
drop user if exists test_user1 cascade;
drop user if exists test_user2 cascade;
drop user if exists test_dba2 cascade;
drop user if exists test_user3 cascade;
drop profile test_pwd_profile;
CONN / AS SYSDBA
alter system set ENABLE_SYSDBA_REMOTE_LOGIN = TRUE;
DROP USER IF EXISTS USER_SYSDBA CASCADE; 
CREATE USER USER_SYSDBA IDENTIFIED BY CANTIAN_234;
GRANT CONNECT , SYSDBA TO USER_SYSDBA;
CONN USER_SYSDBA/CANTIAN_234@127.0.0.1:1611 AS SYSDBA
SELECT  USER;
ALTER USER SYS ACCOUNT LOCK;
CONN USER_SYSDBA/CANTIAN_234@127.0.0.1:1611
ALTER USER SYS ACCOUNT UNLOCK;
SELECT  USER;
CONN USER_SYSDBA/CANTIAN_234@127.0.0.1:1611 AS SYSDBA
alter system set ENABLE_SYSDBA_REMOTE_LOGIN = FALSE;
CONN / AS SYSDBA
ALTER USER SYS ACCOUNT UNLOCK;
DROP USER USER_SYSDBA CASCADE;
--DTS2019031909797
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists cao cascade;
create user  cao  identified by ";Cantian234";
create user  cao  identified by ';Cantian234';
create user  cao  identified by `;Cantian234`;
create user  cao  identified by Cantian_234;
alter user cao identified by ';bao102_bao' replace Cantian_234;
create role cao_role identified by ';bao102_bao';
create database dbg_database user sys identified by ';bao102_bao';
drop user if exists cao cascade;
CREATE USER DROP_TEST_01 IDENTIFIED BY TEst1234;
--SELECT ID, NAME FROM SYS_USERS ORDER BY ID;
DROP USER DROP_TEST_01;
DROP USER IF EXISTS DROP_TEST_01;
--SELECT ID, NAME FROM DROP_TEST_01 ORDER BY ID;

CREATE USER DROP_TEST_02 IDENTIFIED BY TEst1234;
--SELECT ID, NAME FROM SYS_USERS ORDER BY ID;
DROP USER IF EXISTS DROP_TEST_02;
DROP USER DROP_TEST_02;
--SELECT ID, NAME FROM SYS_USERS ORDER BY ID;

-- CREATE ROLE USE THE SAME NAME WITH USERS
CREATE USER DROP_TEST_03 IDENTIFIED BY TEst1234;
CREATE ROLE DROP_TEST_03 IDENTIFIED BY TEst1234;

DROP USER IF EXISTS DROP_TEST_03;
CREATE ROLE DROP_TEST_03 IDENTIFIED BY TEst1234;
DROP ROLE DROP_TEST_03;

-- CREATE USER USE THE SAME NAME WITH ROLE
CREATE ROLE DROP_TEST_04 IDENTIFIED BY TEst1234;
CREATE USER DROP_TEST_04 IDENTIFIED BY TEst1234;

DROP ROLE DROP_TEST_04;
CREATE USER DROP_TEST_04 IDENTIFIED BY TEst1234;
DROP USER DROP_TEST_04;

-- Password with @ 
DROP USER IF EXISTS PFA_TEST_USER_1;
CREATE USER PFA_TEST_USER_1 IDENTIFIED BY 'ABCD@123@2';

DROP USER IF EXISTS PFA_TEST_USER_2;
CREATE USER PFA_TEST_USER_2 IDENTIFIED BY 'sys/sys@127.0.0.1:1611';

grant create session to PFA_TEST_USER_1;
grant create session to PFA_TEST_USER_2;

conn PFA_TEST_USER_1/ABCD@123@2@127.0.0.1:1611
conn PFA_TEST_USER_2/sys/sys@127.0.0.1:1611@127.0.0.1:1611
conn sys/Huawei@123@127.0.0.1:1611
conn @127.0.0.1:1611
conn sys/2@127.0.0.1:1611
conn sys/Huawei@123@127.0.0.1:
conn sys/Huawei@123@127.0.0.1:00000000000000000000000000000000000000000001611
conn sys/Huawei@123@127.0.0.1:-00000000000000000000000000000000000000000001611
conn sys/Huawei@123@127.0.0.1:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001611
conn sys/Huawei@123@127.0.0.1:000000000001o11
conn sys/Huawei@123@127.0.0.1:1611
conn /sys@127.0.0.1:000000000001611
conn /
conn
conn ggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg/sys@127.0.0.1:000000000001611
conn gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg/suuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuys@127.0.0.1:000000000001611

-- this following SQL can not be executed, as the connection has been colsed
select * from dual;

conn sys/Huawei@123@127.0.0.1:1611

create user sys identified by Root12345;
create database cantiandb user user_1 identified by Root1234;

create database cantiandb abc;

-- create database control file error
create database cantiandb user SYS identified by Changeme_123 character set utf8 CONTROLFILE ('/home/acmareal/cantiandb/data/cntl1'wrong, '/home/acmareal/cantiandb/data/cntl2', '/home/acmareal/cantiandb/data/cntl3');
create database cantiandb user SYS identified by Changeme_123 character set utf8 CONTROLFILE abc;
create database cantiandb user SYS identified by Changeme_123 character set utf8 CONTROLFILE (/home/acmareal/cantiandb/data/cntl1);
create database cantiandb user SYS identified by Changeme_123 character set utf8 CONTROLFILE ('/home/acmareal/cantiandb/data/cntl1') CONTROLFILE ('/home/acmareal/cantiandb/data/cntl1');

-- create database charset error
create database cantiandb user SYS identified by Changeme_123 character set utf8 character set utf8;
create database cantiandb user SYS identified by Changeme_123 character;
create database cantiandb user SYS identified by Changeme_123 character set;

-- create database logfile block size error
create database cantiandb user SYS identified by Changeme_123 LOGFILE ('/home/acmareal/cantiandb/data/log1' size 256M blocksize);
create database cantiandb user SYS identified by Changeme_123 LOGFILE ('/home/acmareal/cantiandb/data/log1' size 256M blocksize 4);
create database cantiandb user SYS identified by Changeme_123 LOGFILE ('/home/acmareal/cantiandb/data/log1' size 256M) LOGFILE ('/home/acmareal/cantiandb/data/log1' size 256M);
create database cantiandb user SYS identified by Changeme_123 LOGFILE ('/home/acmareal/cantiandb/data/log1' size 256M a'/home/acmareal/cantiandb/data/log2' size 256M, '/home/acmareal/cantiandb/data/log3' size 256M);

-- create database data file error
create database cantiandb user SYS identified by system tablespace DATAFILE '/home/acmareal/cantiandb/data/system' size 1M;
create database cantiandb user SYS identified by Changeme_123 system tablespace DATAFILE '/home/acmareal/cantiandb/data/system' size 100000000M;
create database cantiandb user SYS identified by Changeme_123 system tablespace DATAFILE '/home/acmareal/cantiandb/data/system' size 128M ALL IN MEMORY LOGFILE ('/home/acmareal/cantiandb/data/log1' size 256M blocksize);
create database cantiandb user SYS identified by Changeme_123 system tablespace DATAFILE '/home/acmareal/cantiandb/data/system' size 128M ALL IN MEMORY user SYS;

-- create database table space error
create database cantiandb user SYS identified by Changeme_123 system tablespace DATAFILE '/home/acmareal/cantiandb/data/system' size 128M system tablespace DATAFILE '/home/acmareal/cantiandb/data/system' size 128M;

-- create database default user error
create database cantiandb user SYS identified by Changeme_123 user SYS identified by Changeme_123;
create database cantiandb user;
create database cantiandb user SYS;
create database cantiandb user SYS abc;
create database cantiandb user SYS identified abc;
create database cantiandb user SYS identified by;

create tablespace TMP_TBLSPC datafile 'tmp1' size 128M;
create user;
create user table;
create user USER_TEST_001 identified by Root12345 default tablespace TMP_TBLSPC;
create user USER_TEST_002 identified by Root12345 default tablespace TMP_TBLSPC temporary tablespace SWAP_00;

create user USER_TEST_003 identified by Root12345 default tablespace TMP_TBLSPC temporary tablespace TMP_TBLSPC default tablespace TMP_TBLSPC;
create user USER_TEST_004 identified by Root12345 default tablespace TMP_TBLSPC temporary tablespace TMP_TBLSPC temporary tablespace TMP_TBLSPC;

create user USER_TEST_005 identified by Root12345 password no_expire;
create user USER_TEST_005 identified by Root12345 password expire password expire;
create user USER_TEST_005 identified by Root12345 password expire;
create user USER_TEST_006 identified by Root12345 account abc;
create user USER_TEST_006 identified by Root12345 account lock account lock;
create user USER_TEST_006 identified by Root12345 default abc;
create user USER_TEST_006 identified by Root12345 default tablespace;

alter user USER_TEST_005 password expire;
alter user USER_TEST_005 identified by;
alter user USER_TEST_005 identified by ,Root1234;
alter user USER_TEST_005 identified by 'Root12345';
alter user USER_TEST_005 identified by 'Root12345' replace root23454 identified by 'Root12345' replace root23454;
alter user USER_TEST_005 identified abc;
alter user USER_TEST_005 identified by 'Root12345' replace ,Root1234;
alter user USER_TEST_005 abc;

conn / as sysdba
drop user if abc USER_TEST_001 cascade;
drop user USER_TEST_001 cascade;
drop user USER_TEST_002 cascade;
drop user USER_TEST_005 cascade;

create temporary abc;
create or fja;
create or replace public abc;
create public abc;
create global abc;
create global TEMPORARY abc;
create database link abc;

create role ,fjds123;
drop role;
drop role ,fjds123;
drop role abc1234 not_end;

create role F$#_FVT_CREATE_ROLE_PASSWORD_9 identified by 'Gauussabcd=';
create role CREATE_USER_PASSWORD_002 identified by 'Gs~!@#$%^&*()-_=+\|[{}];:",<.>/? ';
drop role F$#_FVT_CREATE_ROLE_PASSWORD_9;
drop role CREATE_USER_PASSWORD_002;

create sequence SEQ_TEST_001 increment abc;
create sequence SEQ_TEST_001 start;
create sequence SEQ_TEST_001 cache 1 nocache;

drop sequence if exists SEQ_TEST_001;
drop sequence if exists SEQ_TEST_002;
drop user if exists test_seq_user_001;
create sequence SEQ_TEST_001 start with 100 increment by 2 cache 99999;
create sequence SEQ_TEST_002 start with 100 increment by 2 cache 99999;
create user test_seq_user_001 identified by Root1234;
grant create session to test_seq_user_001;
create sequence test_seq_user_001.SEQ_TEST_001 start with 100 increment by 2 cache 99999;
create sequence test_seq_user_001.SEQ_TEST_002 start with 100 increment by 2 cache 99999;

select * from all_sequences where SEQUENCE_NAME in ('SEQ_TEST_001', 'SEQ_TEST_002') order by SEQUENCE_OWNER, SEQUENCE_NAME;

conn test_seq_user_001/Root1234@127.0.0.1:1611
select * from user_sequences order by SEQUENCE_NAME;

conn sys/Huawei@123@127.0.0.1:1611
drop sequence if exists SEQ_TEST_001;
drop sequence if exists SEQ_TEST_002;
drop user test_seq_user_001 cascade;

create user USER_TEST_001 identified by Root1234;
create user USER_TEST_002 identified by Root1234;

alter user USER_TEST_001 account lock;
alter user USER_TEST_002 password expire;

drop user USER_TEST_001;
drop user USER_TEST_002;

create user user_test_proc_001 identified by Root1234;
create or replace procedure user_test_proc_001.test_proc_001
as
   sqlstr varchar2(2000);
begin
   sqlstr := 'create table user_test_proc_001.tab_001 (id int)';
   execute immediate sqlstr;
end;
/

select name from SYS_PROCS where name = UPPER('test_proc_001');
drop user user_test_proc_001;
drop user user_test_proc_001 cascade;
select name from SYS_PROCS where name = UPPER('test_proc_001');

-- test 'ALTER SESSION set current_schema=schema' feature
connect / as sysdba
create user USER_TEST_001 identified by Root1234;
create user USER_TEST_002 identified by Root1234;
create user USER_TEST_003 identified by Root1234;

grant connect, resource to USER_TEST_001, USER_TEST_002, USER_TEST_003;
grant select on v$session to USER_TEST_001;
grant drop user, create any table, create any sequence, create any view, create any synonym to USER_TEST_001;
grant create any procedure, create any trigger to USER_TEST_001;
grant insert any table to USER_TEST_001;
grant alter session to USER_TEST_001;

create table USER_TEST_001.u_table_001 (f1 int, f2 varchar2(30));
create table USER_TEST_002.u_table_001 (f1 int, f2 varchar2(30));
create table USER_TEST_003.u_table_001 (f1 int, f2 varchar2(30));

grant select on USER_TEST_002.u_table_001 to USER_TEST_001;

create sequence USER_TEST_001.u_seq_001 start with 10;
create sequence USER_TEST_002.u_seq_001 start with 100;

-- 1. set a schema that not exists
conn USER_TEST_001/Root1234@127.0.0.1:1611
select user_name, curr_schema from sys.v$me;

alter session set current_schema=abc; -- failed
select user_name, curr_schema from sys.v$me;

-- 2. drop a user after set the user as a session's current schema
alter session set current_schema=user_test_003; -- succeed
select user_name, curr_schema from sys.v$me;

select * from u_table_001;
drop user user_test_003 cascade;
select * from u_table_001; -- can not find the schema

-- the setting is not changed
select user_name, curr_schema from sys.v$me;

-- 3. check if the current_schema setting has taken effects
alter session set current_schema=USER_TEST_001;
insert into u_table_001 values (1, '111');
select u_seq_001.nextval from dual;

alter session set current_schema=USER_TEST_002;
insert into u_table_001 values (1, '111');
select user_name, curr_schema from sys.v$me;
select USERNAME, curr_schema from sys.v$session where type='USER' and USERNAME='USER_TEST_001';

select * from user_test_001.u_table_001; -- (1, '111') 1 row
select * from user_test_002.u_table_001; -- (1, '111') 1 row
select u_seq_001.nextval from dual; -- no privilege

-- create table
create table u_table_002 (id int, name varchar2(30)); -- in schema USER_TEST_002
insert into u_table_002 values (1, 'zhusimaji');
select * from user_test_001.u_table_002; -- not found
select * from user_test_002.u_table_002; -- 1 row

-- create sequence
create sequence u_seq_002 start with 1000; -- in schema USER_TEST_002
select user_test_001.u_seq_002.nextval from dual;
select user_test_002.u_seq_002.nextval from dual;

-- create view
create view u_view_001 as select * from u_table_002;
select * from user_test_001.u_view_001;
select * from user_test_002.u_view_001;

-- create synonym
create synonym u_syn_001 for user_test_002.u_table_002;
select * from u_syn_001;  -- no privilege

-- create procedure/function/trigger
CREATE OR REPLACE FUNCTION Zenith_Test_Sysdate return varchar2
IS
 cunt int := 0;
 Begin
 select count(*) into cunt from dual;
 dbe_output.print_line(cunt);
 IF SQL % FOUND
  then
 return cunt;
 end if;
 End Zenith_Test_Sysdate;
/

select Zenith_Test_Sysdate() from dual;

create or replace trigger u_trig_001
    before insert
    on u_table_001
    for each row
    begin
        select 1 into :new.f2 from dual;
    end;
/

CREATE OR REPLACE PROCEDURE Zenith_Test_004(param1 out varchar2)
IS
    tmp varchar2(20) :='12345678';
begin
 param1:=param1||tmp;
end Zenith_Test_004;
/

conn sys/Huawei@123@127.0.0.1:1611
select NAME, TRIG_TABLE_USER, TRIG_TABLE from SYS_PROCS where user# = (select id from SYS_USERS where name = 'USER_TEST_002') order by NAME;

revoke create any procedure, create any trigger from USER_TEST_001;
revoke select on user_test_002.u_table_001 from user_test_001;

-- 4. check the privileges of current user to access the objects in current schema
conn USER_TEST_001/Root1234@127.0.0.1:1611
alter session set current_schema=user_test_002;

select * from u_table_001;  -- no privilege

conn user_test_002/Root1234@127.0.0.1:1611
select user_name, curr_schema from sys.v$me;
grant select on u_table_001 to user_test_001;

select * from u_table_001; -- 1 rows: (1, '111')

insert into u_table_001 values (1, '333');
select * from u_table_001 order by f2; -- 2 rows: (1, '1'), (1, '111') changed by the trigger
commit;

conn user_test_001/Root1234@127.0.0.1:1611
alter session set current_schema=USER_TEST_002;
select * from u_table_001 order by f2;  -- 2 rows: (1, '1'), (1, '111')

-- no privileges to create procedure/function/trigger in current schema
CREATE OR REPLACE FUNCTION Zenith_Test_Sysdate return varchar2
IS
 cunt int := 0;
 Begin
 select count(*) into cunt from dual;
 dbe_output.print_line(cunt);
 IF SQL % FOUND
  then
 return cunt;
 end if;
 End Zenith_Test_Sysdate;
/

select Zenith_Test_Sysdate() from dual;

create or replace trigger u_trig_001
    before insert
    on u_table_001
    for each row
    begin
        select 1 into :new.f2 from dual;
    end;
/

CREATE OR REPLACE PROCEDURE Zenith_Test_004(param1 out varchar2)
IS
    tmp varchar2(20) :='12345678';
begin
 param1:=param1||tmp;
end Zenith_Test_004;
/

-- 5. describe + table/view name : use current user's object if the schema name is not specified.
desc u_table_002
desc user_test_002.u_table_002

-- 6. clean
conn / as sysdba
drop user user_test_001 cascade;
drop user user_test_002 cascade;
drop tablespace TMP_TBLSPC;

drop user if exists test;
create user test identified by Root1234;
alter user test identified by Root12345;
grant create session, alter user to test;
connect test/Root12345@127.0.0.1:1611
alter user test identified by Root1234;
alter user test identified by Root54321 replace Root1234;
connect test/Root54321@127.0.0.1:1611
connect / as sysdba
alter user test identified by Root123456 replace Root123;
alter user test identified by Root123456 replace Root54321;
drop user test cascade;

--test the spid in v$session and v$me
SELECT DECODE(S.SPID, 0, 'INVALID', 'VALID') FROM V$SESSION S, V$ME M WHERE M.SID=S.SID;         --VALID expected
SELECT DECODE(S.SPID, M.SPID, 'EQUAL', 'INEQUAL') FROM V$SESSION S, V$ME M WHERE M.SID=S.SID;  --EQUAL expected
SELECT DECODE(COUNT(DISTINCT SPID), COUNT(SPID), 'NO DUPLICATE', 'DUPLICATE EXISTS') AS COL FROM V$SESSION WHERE SPID <> 0;  --NO DUPLICATE expected


declare
    role_cnt int;
    sqlstr varchar(64);
begin
    select count(*) into role_cnt from SYS_ROLES;
    for i in 1..(1024 - role_cnt) loop
        sqlstr := 'create role role_test_' || i ;
        execute immediate sqlstr;
    end loop;
end;
/

create role abc;  -- failed

declare
    role_cnt int;
    sqlstr varchar(64);
begin
    select count(*) into role_cnt from SYS_ROLES where name like 'ROLE_TEST_%';
    for i in 1..role_cnt loop
        sqlstr := 'drop role role_test_' || i ;
        execute immediate sqlstr;
    end loop;
end;
/

select count(*) from SYS_ROLES;

-- test : alter session set current_schema in procedure DTS2018081701021
create user c##session_schema_001 identified by Root1234;

set serveroutput on

create or replace function sys_session_schema_fun_003_1(n number, oneT char, twoT char, threeT char) return number
is
v_sql char(128);
v_sna NUMBER(10, 0);
begin
  if (n = 1) then
    dbe_output.print_line(oneT ||'---->'|| threeT);
  else
    v_sql:='call sys_session_schema_pro_003_1(' || to_char(n - 1) || ', '''||oneT||''','''||threeT||''','''||twoT||''')';
    EXECUTE IMMEDIATE v_sql;
    dbe_output.print_line(oneT ||'---->'|| threeT);
    
    execute immediate 'alter session set current_schema=c##session_schema_001';

    v_sql:='call sys_session_schema_pro_003_1('||to_char(n - 1)||','''||twoT||''','''||oneT||''','''||threeT||''')';
    EXECUTE IMMEDIATE v_sql;
  end if;
  return 0;
end;
/

create or replace procedure sys_session_schema_pro_003_1(n int,a varchar2,b varchar2,c varchar2)
as
v_tmp int;
v_n int :=n;
v_a varchar2(40) :=a;
v_b varchar2(40) :=b;
v_c varchar2(40) :=c;
begin
    if(1=v_n)
    then
        dbe_output.print_line(v_a||'---->'||v_c);
    else
        v_tmp:=sys_session_schema_fun_003_1(v_n-1,v_a,v_c,v_b);
        dbe_output.print_line(v_a||'---->'||v_c);
        v_tmp:=sys_session_schema_fun_003_1(v_n-1,v_b,v_a,v_c);
    end if;
end;
/

select sys_session_schema_fun_003_1(3,'oneT','twoT','threeT') from dual;
select curr_schema from v$me; -- current schema should be changed to 'c##session_schema_001'

alter session set current_schema=SYS;
select curr_schema from v$me; -- current schema should be changed to 'SYS'

set serveroutput off
drop user c##session_schema_001;

-- test drop user that not exists 
drop user if exists user_not_exists;
\! ctsql user_not_exists/Root1234@127.0.0.1:1611 -c 'select 1';
\! ctsql user_not_exists/Root1234@127.0.0.1:1611 -c 'select 1';
\! ctsql user_not_exists/Root1234@127.0.0.1:1611 -c 'select 1';
\! ctsql user_not_exists/Root1234@127.0.0.1:1611 -c 'select 1';
\! ctsql / as sysdba -c 'drop user user_not_exists cascade';

connect / as sysdba

CREATE USER myuser IDENTIFIED BY myuserpwd1;
CREATE USER myusertest IDENTIFIED BY tsetresuym;

DROP USER IF EXISTS myuser;
CREATE USER myuser IDENTIFIED BY Gs_12345;
grant create session to myuser;
connect myuser/Gs_12345@127.0.0.1:1611
ALTER USER myuser IDENTIFIED BY Gs_12346 REPLACE Gs_12345;
ALTER USER myuser IDENTIFIED BY Gs_123ab REPLACE Gs_12345;
connect / as sysdba
DROP USER myuser;

-- test public user 
conn public/Changeme_123@127.0.0.1:1611 -- fail
connect / as sysdba
create user publicdba identified by Changeme_123;
grant create session to publicdba;
conn publicdba/Changeme_123@127.0.0.1:1611  -- succeed
conn / as sysdba -- succeed
drop user publicdba;

-- test drop user after drop a role
drop user if exists test_user_obj_001;
create user test_user_obj_001 identified by cantian_234;
create table test_user_obj_001.tab_001 (id int);
grant connect, resource to test_user_obj_001;

create user test_user_obj_002 identified by cantian_234;
create user test_user_obj_003 identified by cantian_234;
create role test_role_obj_001;
create role test_role_obj_002;

conn test_user_obj_001/cantian_234@127.0.0.1:1611
grant select on test_user_obj_001.tab_001 to test_user_obj_002, test_user_obj_003, test_role_obj_001, test_role_obj_002;
revoke select on test_user_obj_001.tab_001 from test_role_obj_002;
revoke select on test_user_obj_001.tab_001 from test_user_obj_003;

conn / as sysdba
drop role test_role_obj_001;
drop role test_role_obj_002;
drop user test_user_obj_002;
drop user test_user_obj_003;
drop user test_user_obj_001 cascade;

-- DTS2018111403174
create user id_reuse_test_01 identified by cantian_234;
grant create session, create role, create table to id_reuse_test_01;
conn id_reuse_test_01/cantian_234@127.0.0.1:1611
create role id_reuse_role_01;
grant select any table to id_reuse_role_01;
create table tab_001 (f1 int);

conn / as sysdba
drop user id_reuse_test_01 cascade;

select OWNER_UID from SYS_ROLES where name = upper('id_reuse_role_01'); -- role's owner uid changed to 0;
create user id_reuse_test_02 identified by cantian_234; -- uid reuse
grant create session to id_reuse_test_02;

conn id_reuse_test_02/cantian_234@127.0.0.1:1611
grant id_reuse_role_01 to id_reuse_test_02; -- failed, no privilege
drop role id_reuse_role_01; -- failed, no privilege

conn / as sysdba
drop user id_reuse_test_02 cascade;
drop role id_reuse_role_01;

--DTS2018112709220
create user DTS2018112709220 identified by cantian_234;
create user DTS_test_001 identified by cantian_234;
grant create session to DTS2018112709220;

conn DTS2018112709220/cantian_234@127.0.0.1:1611
alter user DTS2018112709220 identified by Cantian_123; -- failed

conn / as sysdba
grant dba to DTS2018112709220;
conn DTS2018112709220/Cantian_123@127.0.0.1:1611
alter user DTS2018112709220 identified by Cantian_123; -- failed
alter user DTS2018112709220 identified by Cantian_123 replace Cantian_123; -- succeed
alter user DTS_test_001 identified by Cantian_123; -- succeed

conn / as sysdba
grant dba to DTS_test_001;
conn DTS2018112709220/Cantian_123@127.0.0.1:1611
alter user DTS_test_001 identified by Cantian_456;
alter user DTS_test_001 identified by Huawei_123 replace Cantian_456;

conn / as sysdba
revoke dba from DTS2018112709220;
conn DTS2018112709220/Cantian_123@127.0.0.1:1611
alter user DTS2018112709220 identified by Root1234 replace Cantian_123 default tablespace SYSTEM; -- failed, no privilege

conn / as sysdba
drop user DTS2018112709220;
drop user DTS_test_001;

-- DTS2019091601669
create user DTS2019091601669 identified by Cantian_234;
create table DTS2019091601669.t1 (id int, name varchar(20));
select name from db_dependencies where referenced_owner='DTS2019091601669';
create view DTS2019091601669_v1 as select * from DTS2019091601669.t1;
select name from db_dependencies where referenced_owner='DTS2019091601669';
drop user DTS2019091601669 cascade;
select name from db_dependencies where referenced_owner='DTS2019091601669';

-- DTS2019101805435
conn / as sysdba
create role test_drop_sys_role;
create user test_drop_sys_role_user1 identified by Cantian_234;
grant drop any role, connect to test_drop_sys_role_user1;
conn test_drop_sys_role_user1/Cantian_234@127.0.0.1:1611
drop role test_drop_sys_role;
conn / as sysdba
drop user test_drop_sys_role_user1 cascade;
drop role test_drop_sys_role;

-- DTS2019102209078
conn / as sysdba
create user test_role1 identified by Cantian_234;
alter session set current_schema=test_role1;
create role role_schema;
select a.username,r.name from sys.roles$ r,all_users a where r.owner_uid = a.user_id and r.name = 'ROLE_SCHEMA';
conn / as sysdba
drop user test_role1 cascade;
drop role role_schema;

-- DTS2018120304015  DTS2018120304015
drop user if exists  "B--B";
drop user if exists  "B%B";
drop user if exists  "B/B";
drop user if exists  "BB";
create user "B--B" identified by Changme_123;
create user "BB" identified by Changme_123;
create user "B%B" identified by Changme_123;
create user "B/B" identified by Changme_123;
grant connect to "B--B";
grant connect to "B%B";
grant connect to "B/B";
grant connect to "BB";

conn "B--B"/Changme_123@127.0.0.1:1611
conn "B%B"/Changme_123@127.0.0.1:1611
conn "B/B"/Changme_123@127.0.0.1:1611
conn 'B--B'/Changme_123@127.0.0.1:1611
conn 'B%B'/Changme_123@127.0.0.1:1611
conn 'B/B'/Changme_123@127.0.0.1:1611

-- DTS2019112612773 DTS2019112008819
conn / as sysdba
create user c##user_test_zzc identified by Cantian_234;
create user c##user_normal_zzc identified by Cantian_234;
create user c##user_dba_zzc identified by Cantian_234;
grant connect to c##user_test_zzc;
grant dba to c##user_dba_zzc;
conn c##user_test_zzc/Cantian_234@127.0.0.1:1611  -- ordinary users without alter user permissions
alter user c##user_test_zzc account lock;
alter user c##user_test_zzc identified by Cantian_123 replace Cantian_234;
alter user c##user_normal_zzc account lock;
alter user c##user_normal_zzc identified by Cantian_123 replace Cantian_234;
alter user c##user_dba_zzc account lock;
alter user c##user_dba_zzc identified by Cantian_123 replace Cantian_234;
alter user sys account lock;
alter user sys identified by Cantian_123 replace Cantian_234;
conn / as sysdba
grant alter user to c##user_test_zzc;
conn c##user_test_zzc/Cantian_123@127.0.0.1:1611  --ordinary user with alter user permissions
select * from user_sys_privs;
alter user c##user_test_zzc account lock;
alter user c##user_test_zzc identified by Cantian_234 replace Cantian_123;
alter user c##user_normal_zzc account lock;
alter user c##user_normal_zzc identified by Cantian_123 replace Cantian_234;
alter user c##user_dba_zzc account lock;
alter user c##user_dba_zzc identified by Cantian_123 replace Cantian_234;
alter user sys account lock;
alter user sys identified by Cantian_123 replace Cantian_234;
conn / as sysdba
create user c##user_dbatest_zzc identified by Cantian_234;
grant dba to c##user_dbatest_zzc;
conn c##user_dbatest_zzc/Cantian_234@127.0.0.1:1611  --dba role user
alter user c##user_dbatest_zzc account lock;
alter user c##user_dbatest_zzc identified by Cantian_123 replace Cantian_234;
alter user c##user_normal_zzc account lock;
alter user c##user_normal_zzc identified by Cantian_234 replace Cantian_123;
alter user c##user_dba_zzc account lock;
alter user c##user_dba_zzc identified by Cantian_123 replace Cantian_234;
alter user sys account lock;
alter user sys identified by Cantian_123 replace Cantian_234;
conn / as sysdba  -- sys user
alter user c##user_normal_zzc account lock;
alter user c##user_normal_zzc identified by Cantian_123 replace Cantian_234;
alter user c##user_dba_zzc account lock;
alter user c##user_dba_zzc identified by Cantian_456 replace Cantian_123;
alter user sys account unlock;
drop user c##user_test_zzc cascade;
drop user c##user_normal_zzc cascade;
drop user c##user_dba_zzc cascade;
drop user c##user_dbatest_zzc cascade;

-- error conn with " '
conn / as sysdba
conn ""/Changme_123@127.0.0.1:1611

conn / as sysdba
conn ''@127.0.0.1:1611

conn / as sysdba
conn ''BB/Changme_123@127.0.0.1:1611

conn / as sysdba
conn "BB/Changme_123@127.0.0.1:1611"

conn / as sysdba
conn "B-B"Changme_123@127.0.0.1:1611

conn / as sysdba
conn "B-B"/@127.0.0.1:1611

conn / as sysdba
drop user "B--B";
drop user "B%B";
drop user "B/B";
drop user "BB";

create user DTS2019041210933 identified by test_1234 password expire;
alter user DTS2019041210933 identified by test_12345 password expire account unlock;
select ACCOUNT_STATUS from dba_users where username = 'DTS2019041210933';
drop user  DTS2019041210933 cascade;

--test of create permanent user 
conn sys/Huawei@123@127.0.0.1:1611
CREATE USER test_user1 IDENTIFIED BY Cantian_234 PERMANENT;
CREATE USER test_2 IDENTIFIED BY Cantian_234;
CREATE USER test_3 IDENTIFIED BY Cantian_234;
GRANT DBA TO test_2;
conn test_2/Cantian_234@127.0.0.1:1611
CREATE USER test_user2 IDENTIFIED BY Cantian_234 PERMANENT;
ALTER USER test_user1 IDENTIFIED BY Huawei_123 REPLACE Cantian_234;
DROP USER test_user1;
drop user test_3;
conn sys/Huawei@123@127.0.0.1:1611
DROP USER test_user1;
CREATE USER test_user1 IDENTIFIED BY Cantian_234 PERMANENT PERMANENT;
CREATE USER test_user1 IDENTIFIED BY Cantian_234 PERMANENT;
SELECT USERNAME, ACCOUNT_STATUS FROM DBA_USERS WHERE USERNAME = 'TEST_USER1';
DROP USER test_user1;
DROP USER test_2;

create user pang identified by Root12345 temporary tablespace TEMP2;
drop user if exists pang cascade;

drop user if exists nologging_user_test cascade;
create user nologging_user_test identified by Cantian_234;
create table nologging_user_test.nologging_table(i int) nologging;
drop user nologging_user_test cascade;

--DTS2019122314705
conn sys/Huawei@123@127.0.0.1:1611 as sysd
conn sys/Huawei@123@127.0.0.1:1611 -D abc
conn sys/Huawei@123@127.0.0.1:1611 as sysdba -D abc
conn sys/Huawei@123@127.0.0.1:1611 as sysdba as sysdba

conn / as sysdba
drop user if exists user_test cascade;
drop user if exists user_test1 cascade;

--parameter: ENABLE_PASSWORD_CIPHER
select * from dv_parameters where name = 'ENABLE_PASSWORD_CIPHER';
alter system set ENABLE_PASSWORD_CIPHER=false;
select * from dv_parameters where name = 'ENABLE_PASSWORD_CIPHER';
create user user_test identified by v6DYfQUAECeYeY3EG ENCRYPTED;
alter system set ENABLE_PASSWORD_CIPHER=true;
select * from dv_parameters where name = 'ENABLE_PASSWORD_CIPHER';
create user user_test identified by v6DYfQUAECeYeY3EG ENCRYPTED;
drop user if exists user_test cascade;

--default profile
create user user_test identified by Cantian_2;
create user user_test identified by Cantian_234;
grant dba to user_test;
create profile pro_test limit PASSWORD_MIN_LEN 10;
conn user_test/Cantian_234@127.0.0.1:1611
--pro_test
alter user user_test identified by Cantian_123 profile pro_test;
alter user user_test profile pro_test;
alter user user_test identified by Cantian_123;
alter user user_test identified by Cantian_1234;
create user user_test1 identified by Cantian_123 profile pro_test;
create user user_test1 identified by Cantian_1234 profile pro_test;
conn / as sysdba
drop user if exists user_test cascade;
drop user if exists user_test1 cascade;
drop profile pro_test;

--20201021
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists user_DTS2019013103017 cascade;
create user user_DTS2019013103017 identified by Cantian_234;
grant create session to user_DTS2019013103017;
conn user_DTS2019013103017/Cantian_234@127.0.0.1:1611
wsr list;

--DTS202105170NR65VP1G00 START
CONN / AS SYSDBA
ALTER SYSTEM SET AUDIT_LEVEL=255;
ALTER SYSTEM SET AUDIT_TRAIL_MODE=DB;
DROP USER IF EXISTS DTS202105170NR65VP1G00_USER1 CASCADE;
CREATE USER DTS202105170NR65VP1G00_USER1 IDENTIFIED BY Cantian_234;
ALTER USER DTS202105170NR65VP1G00_USER1 IDENTIFIED BY Cantian_123;
CREATE OR REPLACE PROCEDURE DTS202105170NR65VP1G00_P1(V1 INT) IS
BEGIN
 EXECUTE IMMEDIATE 'CREATE USER DTS202105170NR65VP1G00_USER2 IDENTIFIED BY Cantian_234;';
END;
/
SELECT SQLTEXT FROM SYS_AUDIT WHERE SQLTEXT LIKE '%DTS202105170NR65VP1G00%' ORDER BY SQLTEXT;
ALTER SYSTEM SET AUDIT_TRAIL_MODE=FILE;
DROP USER IF EXISTS DTS202105170NR65VP1G00_USER1 CASCADE;
DROP PROCEDURE IF EXISTS DTS202105170NR65VP1G00_P1;
--DTS202105170NR65VP1G00 END

conn / as sysdba
create user user_test1 identified by Cantian_234;
grant dba to user_test1;
create user user_test2 identified by Cantian_234;
grant connect, alter user to user_test2;
create user user_test3 identified by Cantian_234;
grant connect to user_test3;

alter system set replace_password_verify = false;
show parameter replace_password_verify;
conn user_test3/Cantian_234@127.0.0.1:1611
alter user user_test3 identified by Cantian_123;   --success
alter user user_test3 identified by Cantian_234 replace Cantian_123;   --success

conn / as sysdba
alter system set replace_password_verify = true;
conn user_test3/Cantian_234@127.0.0.1:1611
alter user user_test3 identified by Cantian_123;   --error
alter user user_test3 identified by Cantian_123 replace Cantian_234;   --success

conn user_test1/Cantian_234@127.0.0.1:1611
alter user user_test3 identified by Cantian_123;   --success

conn user_test2/Cantian_123@127.0.0.1:1611
alter user user_test3 identified by Cantian_123;   --success

conn / as sysdba
alter system set replace_password_verify = false;
drop user user_test1 cascade;
drop user user_test2 cascade;
drop user user_test3 cascade;