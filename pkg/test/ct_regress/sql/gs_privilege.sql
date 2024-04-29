conn / as sysdba
drop user if exists user1 cascade;
create user USER1 identified by Root1234;
grant connect to USER1;
SELECT USER_ID FROM ADM_USERS where username = 'SYS';
ALTER SESSION SET CURRENT_SCHEMA=USER1;
SELECT USERNAME FROM ADM_USERS where username = 'SYS';
conn USER1/Root1234@127.0.0.1:1611
SELECT USER_ID FROM ADM_USERS where username = 'SYS';
SELECT USERNAME FROM ADM_USERS where username = 'SYS';
conn / as sysdba
drop user if exists user1 cascade;
conn / as sysdba 
drop user if exists u_tc_security_trigger_001 cascade;
drop user if exists u_dba cascade;
drop table if exists t1;
drop function if exists get_spacename_by_id;
create table t1(id int);
create user u_tc_security_trigger_001 identified by Changeme123;
grant create session,create table,create trigger,CREATE SYNONYM,CREATE PUBLIC SYNONYM to u_tc_security_trigger_001;
create user u_dba identified by Changeme123;
grant create session,create table,create trigger,CREATE SYNONYM,CREATE PUBLIC SYNONYM  to u_dba;
create table u_dba.t1(id int);
grant all on sys.t1 to u_tc_security_trigger_001;
conn u_tc_security_trigger_001/Changeme123@127.0.0.1:1611
drop table if exists t1;
drop table if exists t2;
create table t1(id int);
create table t2(id int);
insert into t1 values(1),(2),(3),(4);
commit;
drop SYNONYm if exists dba_s1 ;
drop SYNONYm if exists dba_s2 ;
drop SYNONYm if exists sys_s1 ;
drop SYNONYm if exists sys_s2 ;
CREATE OR REPLACE SYNONYM dba_s1 for u_dba.t1;
CREATE OR REPLACE SYNONYM dba_s2 for u_dba.t2;
CREATE OR REPLACE SYNONYM sys_s1 for sys.t1;
CREATE OR REPLACE SYNONYM sys_s2 for sys.t2;
create or replace trigger trig2 before delete or update or insert on sys_s1
begin
    dbe_output.print_line('trigger done');
end;
/
conn / as sysdba 
grant create any trigger to u_tc_security_trigger_001;
conn u_tc_security_trigger_001/Changeme123@127.0.0.1:1611
create or replace trigger trig2 before delete or update or insert on sys_s1
begin
    dbe_output.print_line('trigger done');
end;
/
insert into  sys.t1 values(10);
commit;
select * from sys.t1;
conn / as sysdba 
insert into  sys.t1 values(10);
commit;
select * from sys.t1;
conn / as sysdba 
drop user if exists u_tc_security_trigger_001 cascade;
drop user if exists u_dba cascade;
drop table if exists t1;
conn / as sysdba
drop user if exists regress_z1 cascade;
create user regress_z1 identified by Cantian_234;
grant dba to regress_z1; 
drop user if exists regress_z2 cascade;
create user regress_z2 identified by Cantian_234;
grant dba to regress_z2;
conn regress_z1/Cantian_234@127.0.0.1:1611
create or replace package pk_z1
is
function aaa_f1 return int;
procedure   aaa_p1;
end;
/
create or replace package body pk_z1
is
function aaa_f1 return int
is
        V1 int:=10 ;
                begin
                        null;
                        return V1;
                end;

 procedure aaa_p1
 is
 V1 int:=9;
        begin
                select count(1) into V1 from dual;
                 dbe_output.print_line(V1);
        end;
end;
/
drop package if exists pk_z1;
create or replace package pk_z1  
is  
function aaa_f1 return int; 
procedure   aaa_p1; 
end; 
/
create or replace package body pk_z1 
is 
function aaa_f1 return int
is 
 V1 int:=10 ;
 begin
 null;
return V1;
end;
procedure aaa_p1
 is
 V1 int:=9;
 begin
 select count(1) into V1 from dual;
 dbe_output.print_line(V1);
end;
end; 
/
conn regress_z2/Cantian_234@127.0.0.1:1611
create or replace package pk_z1
is
function aaa_f1 return int;
procedure   aaa_p1;
end;
/
create or replace package body pk_z1
is
function aaa_f1 return int
is
        V1 int:=10 ;
                begin
                        null;
                        return V1;
                end;

 procedure aaa_p1
 is
 V1 int:=9;
        begin
                select count(1) into V1 from dual;
                 dbe_output.print_line(V1);
        end;
end;
/
conn regress_z1/Cantian_234@127.0.0.1:1611
SELECT OWNER, OBJECT_NAME, PACKAGE_NAME FROM DB_ARGUMENTS K WHERE K.IN_OUT = 'OUT' AND K.DATA_LEVEL = 0 and OBJECT_NAME = 'AAA_F1' order by owner;
conn / as sysdba
drop user if exists regress_z1 cascade;
drop user if exists regress_z2 cascade;
--TRIGGER
conn / as sysdba 
drop user if exists c##testuser cascade;
create user c##testuser identified by Cantian_234;
grant connect, create any trigger to c##testuser;
grant execute on DBE_DIAGNOSE to c##testuser;
drop user if exists c##testuser_good cascade;
create user C##TESTUSER_GOOD identified by Cantian_234;
grant connect, create table , create trigger to c##testuser_good;
conn c##testuser_good/Cantian_234@127.0.0.1:1611
drop table if exists t_enable_triggers;
create table t_enable_triggers(f1 int, f2 int);
CREATE OR REPLACE TRIGGER TRIG_ENABLE_TRIGGERS1 BEFORE INSERT OR UPDATE OR DELETE ON t_enable_triggers
BEGIN
	dbe_output.print_line('BEFORE t_enable_triggers');
END;
/
conn c##testuser/Cantian_234@127.0.0.1:1611
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'TRIG_ENABLE_TRIGGERS1', 'T');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'TRIG_ENABLE_TRIGGERS1', 'TRIGGER');
conn / as sysdba
revoke create any trigger from c##testuser;
conn c##testuser/Cantian_234@127.0.0.1:1611
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'TRIG_ENABLE_TRIGGERS1', 'T');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'TRIG_ENABLE_TRIGGERS1', 'TRIGGER');
--PROCEDURE
conn / as sysdba 
drop user if exists c##testuser cascade;
create user c##testuser identified by Cantian_234;
grant connect, execute any procedure to c##testuser;
grant execute on DBE_DIAGNOSE to c##testuser;
drop user if exists c##testuser_good cascade;
create user C##TESTUSER_GOOD identified by Cantian_234;
grant connect, create table , create PROCEDURE to c##testuser_good;
conn c##testuser_good/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE PROCEDURE PLSQL_Zenith_Test_004(param1 out varchar2)
IS
    tmp varchar2(20) :='12345678';
Begin
    dbe_output.print_line('OUT PUT RESULT:'||param1);
end PLSQL_ZENITH_TEST_004;
/
conn c##testuser/Cantian_234@127.0.0.1:1611
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'P');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'PROCEDURE');
conn / as sysdba
revoke execute any procedure from c##testuser;
conn c##testuser/Cantian_234@127.0.0.1:1611
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'P');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'PROCEDURE');
conn / as sysdba
grant execute on C##TESTUSER_GOOD.PLSQL_ZENITH_TEST_004 to c##testuser;
conn c##testuser/Cantian_234@127.0.0.1:1611
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'P');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'PROCEDURE');
conn / as sysdba
revoke execute on C##TESTUSER_GOOD.PLSQL_ZENITH_TEST_004 from c##testuser;
conn c##testuser/Cantian_234@127.0.0.1:1611
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'P');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'PROCEDURE');
--FUNCTION
conn / as sysdba 
drop user if exists c##testuser cascade;
create user c##testuser identified by Cantian_234;
grant connect, execute any procedure to c##testuser;
grant execute on DBE_DIAGNOSE to c##testuser;
drop user if exists c##testuser_good cascade;
create user C##TESTUSER_GOOD identified by Cantian_234;
grant connect, create table , create PROCEDURE to c##testuser_good;
conn c##testuser_good/Cantian_234@127.0.0.1:1611

CREATE OR REPLACE FUNCTION PLSQL_ZENITH_TEST_004 return varchar2
IS
 cunt int := 0;
 Begin
 select count(*) into cunt from dual;
 dbe_output.print_line(cunt);
 IF SQL % FOUND
  then
 return cunt;
 end if;
 End PLSQL_ZENITH_TEST_004;
/
conn c##testuser/Cantian_234@127.0.0.1:1611
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'F');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'FUNCTION');
conn / as sysdba
revoke execute any procedure from c##testuser;
conn c##testuser/Cantian_234@127.0.0.1:1611
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'F');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'FUNCTION');
conn / as sysdba
grant execute on C##TESTUSER_GOOD.PLSQL_ZENITH_TEST_004 to c##testuser;
conn c##testuser/Cantian_234@127.0.0.1:1611
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'F');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'FUNCTION');
conn / as sysdba
revoke execute on C##TESTUSER_GOOD.PLSQL_ZENITH_TEST_004 from c##testuser;
conn c##testuser/Cantian_234@127.0.0.1:1611
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'F');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'FUNCTION');
--TYPE
conn / as sysdba 
drop user if exists c##testuser cascade;
create user c##testuser identified by Cantian_234;
grant connect, execute any type to c##testuser;
grant execute on DBE_DIAGNOSE to c##testuser;
drop user if exists c##testuser_good cascade;
create user C##TESTUSER_GOOD identified by Cantian_234;
grant connect, create table , create type to c##testuser_good;
conn c##testuser_good/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE TYPE PLSQL_ZENITH_TEST_004 FORCE AS OBJECT
( month int,
  month1 int
);
/
conn c##testuser/Cantian_234@127.0.0.1:1611
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'Y');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'O');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'TYPE');
conn / as sysdba
revoke execute any type from c##testuser;
conn c##testuser/Cantian_234@127.0.0.1:1611
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'Y');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'O');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'TYPE');
conn / as sysdba
grant execute on C##TESTUSER_GOOD.PLSQL_ZENITH_TEST_004 to c##testuser;
conn c##testuser/Cantian_234@127.0.0.1:1611
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'Y');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'O');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'TYPE');
conn / as sysdba
revoke execute on C##TESTUSER_GOOD.PLSQL_ZENITH_TEST_004 from c##testuser;
conn c##testuser/Cantian_234@127.0.0.1:1611
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'Y');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'O');
select DBE_DIAGNOSE.has_obj_privs('C##TESTUSER', 'C##TESTUSER_GOOD', 'PLSQL_ZENITH_TEST_004', 'TYPE');
conn / as sysdba 
drop user if exists c##testuser cascade;
drop user if exists c##testuser_good cascade;
conn / as sysdba
drop user if exists AAA cascade;
create user AAA identified by Cantian_234;
grant connect , create table,create sequence, CREATE ANY DIRECTORY  to AAA;
drop user if exists bbb cascade;
create user bbb identified by Cantian_234;
grant connect , create table,create sequence, CREATE ANY DIRECTORY  to bbb;
drop user if exists ccc cascade;
create user ccc identified by Cantian_234;
grant connect , create table,create sequence, CREATE ANY DIRECTORY  to ccc;
drop user if exists ddd cascade;
create user ddd identified by Cantian_234;
grant connect , create table,create sequence, CREATE ANY DIRECTORY  to ddd;
drop user if exists eee cascade;
create user eee identified by Cantian_234;
grant connect , create table,create sequence, CREATE ANY DIRECTORY  to eee;
create or replace directory test_dir as '/home/regress/CantianKernel/pkg/test/ct_regress/data';
grant read on directory test_dir to aaa  with grant option;
conn aaa/Cantian_234@127.0.0.1:1611
grant read on directory test_dir to bbb  with grant option;
conn bbb/Cantian_234@127.0.0.1:1611
grant read on directory test_dir to ccc  with grant option;
conn ccc/Cantian_234@127.0.0.1:1611
grant read on directory test_dir to ddd  with grant option;
conn ddd/Cantian_234@127.0.0.1:1611
grant read on directory test_dir to eee  with grant option;
conn / as sysdba 
select * from dba_tab_privs where OBJECT_NAME = 'TEST_DIR' ORDER BY GRANTEE;
revoke read on directory test_dir from aaa;
select * from dba_tab_privs where OBJECT_NAME = 'TEST_DIR' ORDER BY GRANTEE;
conn / as sysdba
drop user if exists AAA cascade;
create user AAA identified by Cantian_234;
grant connect , create table,create sequence, CREATE ANY DIRECTORY  to AAA;
drop user if exists bbb cascade;
create user bbb identified by Cantian_234;
grant connect , create table,create sequence, CREATE ANY DIRECTORY  to bbb;
drop user if exists ccc cascade;
create user ccc identified by Cantian_234;
grant connect , create table,create sequence, CREATE ANY DIRECTORY  to ccc;
drop user if exists ddd cascade;
create user ddd identified by Cantian_234;
grant connect , create table,create sequence, CREATE ANY DIRECTORY  to ddd;
drop user if exists eee cascade;
create user eee identified by Cantian_234;
grant connect , create table,create sequence, CREATE ANY DIRECTORY  to eee;
create or replace directory test_dir as '/home/regress/CantianKernel/pkg/test/ct_regress/data';
grant read on directory test_dir to aaa  with grant option;
conn aaa/Cantian_234@127.0.0.1:1611
grant read on directory test_dir to bbb  with grant option;
conn bbb/Cantian_234@127.0.0.1:1611
grant read on directory test_dir to ccc  with grant option;
conn ccc/Cantian_234@127.0.0.1:1611
grant read on directory test_dir to ddd  with grant option;
conn ddd/Cantian_234@127.0.0.1:1611
grant read on directory test_dir to eee  with grant option;
conn / as sysdba 
select * from dba_tab_privs where OBJECT_NAME = 'TEST_DIR' ORDER BY GRANTEE;
drop directory test_dir;
select * from dba_tab_privs where OBJECT_NAME = 'TEST_DIR' ORDER BY GRANTEE;
drop user if exists AAA cascade;
drop user if exists bbb cascade;
drop user if exists ccc cascade;
drop user if exists ddd cascade;
drop user if exists eee cascade;
conn / as sysdba 
drop user if exists dbatest1 cascade;
drop user if exists dbatest2 cascade;
drop user if exists dbatest3 cascade;
drop user if exists dbatest4 cascade;
drop user if exists dbatest5 cascade;
drop user if exists dbatest6 cascade;
drop user if exists dbatest7 cascade;
drop user if exists dbatest8 cascade;
drop user if exists dbatest9 cascade;
drop user if exists dbatest10 cascade;
create user dbatest1 identified by Cantian_234;
create user dbatest2 identified by Cantian_234;
create user dbatest3 identified by Cantian_234;
create user dbatest4 identified by Cantian_234;
create user dbatest5 identified by Cantian_234;
create user dbatest6 identified by Cantian_234;
create user dbatest7 identified by Cantian_234;
create user dbatest8 identified by Cantian_234;
create user dbatest9 identified by Cantian_234;
create user dbatest10 identified by Cantian_234;
grant connect to dbatest1;
grant connect to dbatest2;
grant connect to dbatest3;
grant connect to dbatest4;
grant connect to dbatest5;
grant connect ,create role to dbatest6;
grant connect ,create role to dbatest7;
grant connect ,create role to dbatest8;
grant connect to dbatest9;
grant connect to dbatest10;
drop table if exists sys_tab_table1;
create table sys_tab_table1(id int);
grant select on sys.sys_tab_table1 to dbatest1 with grant option;
conn dbatest1/Cantian_234@127.0.0.1:1611
grant select on sys.sys_tab_table1 to dbatest2 with grant option;
conn dbatest2/Cantian_234@127.0.0.1:1611
grant select on sys.sys_tab_table1 to dbatest3 with grant option;
conn dbatest3/Cantian_234@127.0.0.1:1611
grant select on sys.sys_tab_table1 to dbatest4 with grant option;
conn dbatest4/Cantian_234@127.0.0.1:1611
grant select on sys.sys_tab_table1 to dbatest5 with grant option;
conn dbatest5/Cantian_234@127.0.0.1:1611
grant select on sys.sys_tab_table1 to dbatest6 with grant option;
conn dbatest6/Cantian_234@127.0.0.1:1611
grant select on sys.sys_tab_table1 to dbatest7 with grant option;
conn dbatest7/Cantian_234@127.0.0.1:1611
grant select on sys.sys_tab_table1 to dbatest8 with grant option;
conn dbatest8/Cantian_234@127.0.0.1:1611
select * from sys.sys_tab_table1;
conn / as sysdba 
drop user if exists dbatest1 cascade;
conn dbatest8/Cantian_234@127.0.0.1:1611
select * from sys.sys_tab_table1;
conn / as sysdba 
drop user if exists dbatest1 cascade;
drop user if exists dbatest2 cascade;
drop user if exists dbatest3 cascade;
drop user if exists dbatest4 cascade;
drop user if exists dbatest5 cascade;
drop user if exists dbatest6 cascade;
drop user if exists dbatest7 cascade;
drop user if exists dbatest8 cascade;
drop user if exists dbatest9 cascade;
drop user if exists dbatest10 cascade;
conn / as sysdba
drop user if exists dbatest1 cascade;
drop user if exists dbatest2 cascade;
drop user if exists dbatest3 cascade;
create user dbatest1 identified by Cantian_234;
create user dbatest2 identified by Cantian_234;
create user dbatest3 identified by Cantian_234;
grant connect,create role to dbatest1;
grant connect,create role to dbatest2;
grant connect,create role to dbatest3;
drop table if exists sys_tab_table1;
create table sys_tab_table1(id int);
grant select on sys.sys_tab_table1 to dbatest1 with grant option;
conn dbatest1/Cantian_234@127.0.0.1:1611
create role TEST_ROLE11111111111 ;
grant select on sys.sys_tab_table1 to TEST_ROLE11111111111;
grant TEST_ROLE11111111111 to dbatest2;
conn dbatest2/Cantian_234@127.0.0.1:1611
select * from sys.sys_tab_table1;
conn / as sysdba 
select * from dba_tab_privs where grantee = 'TEST_ROLE11111111111';
drop user if exists dbatest1 cascade;
select * from dba_tab_privs where grantee = 'TEST_ROLE11111111111';
conn dbatest2/Cantian_234@127.0.0.1:1611
select * from sys.sys_tab_table1;
conn / as sysdba
drop role TEST_ROLE11111111111;
conn / as sysdba
drop user if exists dbatest1 cascade;
drop user if exists dbatest2 cascade;
drop user if exists dbatest3 cascade;
create user dbatest1 identified by Cantian_234;
create user dbatest2 identified by Cantian_234;
create user dbatest3 identified by Cantian_234;
grant connect,create role to dbatest1;
grant connect,create role to dbatest2;
grant connect,create role to dbatest3;
drop table if exists sys_tab_table1;
create table sys_tab_table1(id int);
grant select on sys.sys_tab_table1 to dbatest1 with grant option;
conn dbatest1/Cantian_234@127.0.0.1:1611
create role TEST_ROLE2222222222 ;
grant select on sys.sys_tab_table1 to TEST_ROLE2222222222;
grant select on sys.sys_tab_table1 to dbatest2 with grant option;
conn dbatest2/Cantian_234@127.0.0.1:1611
select * from sys.sys_tab_table1;
conn / as sysdba 
select * from dba_tab_privs where grantee = 'TEST_ROLE2222222222';
select * from dba_tab_privs where grantee = 'DBATEST2';
drop user if exists dbatest1 cascade;
select * from dba_tab_privs where grantee = 'TEST_ROLE2222222222';
select * from dba_tab_privs where grantee = 'DBATEST2';
conn dbatest2/Cantian_234@127.0.0.1:1611
select * from sys.sys_tab_table1;
conn / as sysdba
drop role TEST_ROLE2222222222;
conn / as sysdba 
drop user if exists dbatest1 cascade;
drop user if exists dbatest2 cascade;
drop user if exists dbatest3 cascade;
drop user if exists dbatest4 cascade;
drop user if exists dbatest5 cascade;
drop user if exists dbatest6 cascade;
drop user if exists dbatest7 cascade;
drop user if exists dbatest8 cascade;
drop user if exists dbatest9 cascade;
drop user if exists dbatest10 cascade;
create user dbatest1 identified by Cantian_234;
create user dbatest2 identified by Cantian_234;
create user dbatest3 identified by Cantian_234;
create user dbatest4 identified by Cantian_234;
create user dbatest5 identified by Cantian_234;
create user dbatest6 identified by Cantian_234;
create user dbatest7 identified by Cantian_234;
create user dbatest8 identified by Cantian_234;
create user dbatest9 identified by Cantian_234;
create user dbatest10 identified by Cantian_234;
grant connect to dbatest1;
grant connect to dbatest2;
grant connect to dbatest3;
grant connect to dbatest4;
grant connect to dbatest5;
grant connect ,create role to dbatest6;
grant connect ,create role to dbatest7;
grant connect ,create role to dbatest8;
grant connect to dbatest9;
grant connect to dbatest10;
drop table if exists sys_tab_table1;
create table sys_tab_table1(id int);
grant select on sys.sys_tab_table1 to dbatest1 with grant option;
conn dbatest1/Cantian_234@127.0.0.1:1611
grant select on sys.sys_tab_table1 to dbatest2 with grant option;
conn dbatest2/Cantian_234@127.0.0.1:1611
grant select on sys.sys_tab_table1 to dbatest3 with grant option;
conn dbatest3/Cantian_234@127.0.0.1:1611
grant select on sys.sys_tab_table1 to dbatest4 with grant option;
conn dbatest4/Cantian_234@127.0.0.1:1611
grant select on sys.sys_tab_table1 to dbatest5 with grant option;
conn dbatest5/Cantian_234@127.0.0.1:1611
grant select on sys.sys_tab_table1 to dbatest6 with grant option;
conn dbatest6/Cantian_234@127.0.0.1:1611
create role test_role6;
grant select on sys.sys_tab_table1 to test_role6;
grant select on sys.sys_tab_table1 to dbatest7 with grant option;
grant test_role6 to dbatest10;
conn dbatest7/Cantian_234@127.0.0.1:1611
create role test_role7;
grant select on sys.sys_tab_table1 to test_role7;
grant test_role7 to dbatest9;
grant select on sys.sys_tab_table1 to dbatest8 with grant option;
conn dbatest8/Cantian_234@127.0.0.1:1611
select * from sys.sys_tab_table1;
conn dbatest9/Cantian_234@127.0.0.1:1611
select * from sys.sys_tab_table1;
conn dbatest10/Cantian_234@127.0.0.1:1611
select * from sys.sys_tab_table1;
conn / as sysdba 
drop user if exists dbatest1 cascade;
conn dbatest8/Cantian_234@127.0.0.1:1611
select * from sys.sys_tab_table1;
conn dbatest9/Cantian_234@127.0.0.1:1611
select * from sys.sys_tab_table1;
conn dbatest10/Cantian_234@127.0.0.1:1611
select * from sys.sys_tab_table1;
conn / as sysdba 
drop role test_role6;
drop role test_role7;
drop user if exists dbatest1 cascade;
drop user if exists dbatest2 cascade;
drop user if exists dbatest3 cascade;
drop user if exists dbatest4 cascade;
drop user if exists dbatest5 cascade;
drop user if exists dbatest6 cascade;
drop user if exists dbatest7 cascade;
drop user if exists dbatest8 cascade;
drop user if exists dbatest9 cascade;
drop user if exists dbatest10 cascade;
conn / as sysdba
alter system set ENABLE_ACCESS_DC=FALSE;
drop user if exists test_use_1000 cascade;
create user test_use_1000 identified by Cantian_234;
grant connect,select any table to test_use_1000;
conn test_use_1000/Cantian_234@127.0.0.1:1611
select * from sys.ssssss;
conn / as sysdba
drop user if exists test_use_1000 cascade;
create user test_use_1000 identified by Cantian_234;
grant connect,select any dictionary to test_use_1000;
conn test_use_1000/Cantian_234@127.0.0.1:1611
select * from sys.ssssss;
conn / as sysdba
alter system set ENABLE_ACCESS_DC = TRUE;
drop user if exists test_use_1000 cascade;
conn / as  sysdba
drop user if exists c##core_user cascade;
create user c##core_user identified by Cantian_234;
grant connect ,create table , create view to c##core_user;
drop user if exists c##core_user1 cascade;
create user c##core_user1 identified by Cantian_234;
grant connect ,create table , create view to c##core_user1;
drop table if exists table_core1;
create table table_core1(id int);
conn  c##core_user1/Cantian_234@127.0.0.1:1611
create table table_core1(id int);
conn  c##core_user/Cantian_234@127.0.0.1:1611
create table table_core1(id int);
create table inset_as_select_tab(id int);
create table inset_as_select_tab1(id int);
select id from sys.table_core1;
select id from c##core_user.table_core1;
select id from c##core_user1.table_core1;
create table tab_as_ddm as  select * from sys.sys_ddm;
create view view_as_ddm as  select * from sys.sys_ddm;
insert into inset_as_select_tab  select * from sys.table_core1;
conn / as sysdba 
grant select any dictionary to c##core_user;
conn  c##core_user/Cantian_234@127.0.0.1:1611
select id from c##core_user1.table_core1;
select id from sys.table_core1;
create table tab_as_ddm1 as  select * from sys.sys_ddm;
create view view_as_ddm1 as  select * from sys.sys_ddm;
insert into inset_as_select_tab1  select * from sys.table_core1;
conn / as sysdba 
revoke select any dictionary from c##core_user;
alter system set ENABLE_ACCESS_DC = false ;
grant select any table to c##core_user;
conn  c##core_user/Cantian_234@127.0.0.1:1611
select id from c##core_user1.table_core1;
select id from sys.table_core1;
conn / as sysdba 
alter system set ENABLE_ACCESS_DC = TRUE ;
grant select any table to c##core_user;
conn  c##core_user/Cantian_234@127.0.0.1:1611
select id from c##core_user1.table_core1;
select id from sys.table_core1;
conn / as  sysdba
drop user if exists c##core_user cascade;
drop user if exists c##core_user1 cascade;
conn / as  sysdba
alter system set ENABLE_ACCESS_DC = false ;
drop user if exists c##core_user cascade;
create user c##core_user identified by Cantian_234;
grant connect ,create table , create view to c##core_user;
drop table if exists table_core1;
create table table_core1(id int);
select name from sys.sys_users where name = 'C##CORE_USER';
conn  c##core_user/Cantian_234@127.0.0.1:1611
select id from sys.table_core1;
select name from sys.sys_users where name = 'C##CORE_USER';
conn / as  sysdba
grant select any table to c##core_user;
conn  c##core_user/Cantian_234@127.0.0.1:1611
select id from sys.table_core1;
select name from sys.sys_users where name = 'C##CORE_USER';
conn / as  sysdba
alter system set ENABLE_ACCESS_DC  = true;
conn  c##core_user/Cantian_234@127.0.0.1:1611
select id from sys.table_core1;
select name from sys.sys_users where name = 'C##CORE_USER'; 
conn / as  sysdba
revoke select any table from c##core_user;
grant select any dictionary to c##core_user;
conn  c##core_user/Cantian_234@127.0.0.1:1611
select id from sys.table_core1;
select name from sys.sys_users where name = 'C##CORE_USER';
conn / as  sysdba
revoke select any dictionary from c##core_user;
grant select on table_core1 to c##core_user;
grant select on sys_users to c##core_user;
conn  c##core_user/Cantian_234@127.0.0.1:1611
select id from sys.table_core1;
select name from sys.sys_users where name = 'C##CORE_USER';
conn / as  sysdba
drop user if exists c##core_user cascade;
conn / as sysdba
drop user if exists view_for_sys_obj cascade; 
create user view_for_sys_obj identified by Cantian_234;
grant create view ,connect to view_for_sys_obj;
alter system set  ENABLE_ACCESS_DC = FALSE;
conn view_for_sys_obj/Cantian_234@127.0.0.1:1611
create or replace view sysob as select object_name  from all_objects O, DB_TABLES D where D.TABLE_NAME = O.OBJECT_NAME;
conn / as sysdba 
alter system set  ENABLE_ACCESS_DC = TRUE;
drop user if exists view_for_sys_obj cascade;
CONN / AS SYSDBA 
DROP ROLE DBA;
DROP ROLE STATISTICS;
DROP USER IF EXISTS SYSN_USER1 CASCADE;
DROP USER IF EXISTS SYN_CC CASCADE;
CREATE USER SYSN_USER1 IDENTIFIED BY USER102_USER;
CREATE USER SYN_CC IDENTIFIED BY USER102_USER;
GRANT CONNECT, GRANT ANY ROLE  TO SYSN_USER1;
CONN SYSN_USER1/USER102_USER@127.0.0.1:1611
GRANT RESOURCE,DBA,CONNECT TO SYSN_USER1;
GRANT RESOURCE,DBA,CONNECT TO SYN_CC;
CONN / AS SYSDBA 
SELECT * FROM ADM_ROLE_PRIVS WHERE GRANTEE = 'SYSN_USER1';
SELECT * FROM ADM_ROLE_PRIVS WHERE GRANTEE = 'SYN_CC';
DROP USER IF EXISTS SYSN_USER1 CASCADE;
DROP USER IF EXISTS SYN_CC CASCADE;
CREATE USER SYSN_USER1 IDENTIFIED BY USER102_USER;
CREATE USER SYN_CC IDENTIFIED BY USER102_USER;
GRANT CONNECT, GRANT ANY ROLE, GRANT ANY PRIVILEGE   TO SYSN_USER1;
CONN SYSN_USER1/USER102_USER@127.0.0.1:1611
GRANT RESOURCE,DBA,CONNECT TO SYSN_USER1;
GRANT RESOURCE,DBA,CONNECT TO SYN_CC;
CONN / AS SYSDBA 
SELECT * FROM ADM_ROLE_PRIVS WHERE GRANTEE = 'SYSN_USER1';
SELECT * FROM ADM_ROLE_PRIVS WHERE GRANTEE = 'SYN_CC';
DROP USER IF EXISTS SYSN_USER1 CASCADE;
DROP USER IF EXISTS SYN_CC CASCADE;
CONN / AS SYSDBA 
DROP USER IF EXISTS SYSN_USER1 CASCADE;
DROP USER IF EXISTS SYN_CC CASCADE;
CREATE USER SYSN_USER1 IDENTIFIED BY USER102_USER;
GRANT CREATE SYNONYM, CREATE PUBLIC SYNONYM, CREATE ANY SYNONYM TO SYSN_USER1;
GRANT CREATE TABLE, CONNECT TO SYSN_USER1;
CONN SYSN_USER1/USER102_USER@127.0.0.1:1611
CREATE TABLE SYSN_USER1_T1(ID INT);
CREATE OR REPLACE SYNONYM SYN_CC.T1 FOR SYSN_USER1_T1;
CONN / AS SYSDBA
CREATE USER SYN_CC IDENTIFIED BY USER102_USER;
GRANT CONNECT ,SELECT ANY TABLE TO SYN_CC;
CONN SYSN_USER1/USER102_USER@127.0.0.1:1611
CREATE OR REPLACE SYNONYM SYN_CC.SYNT1 FOR SYSN_USER1_T1;
CONN SYN_CC/USER102_USER@127.0.0.1:1611
SELECT * FROM SYNT1;
CONN / AS  SYSDBA
REVOKE CREATE ANY SYNONYM FROM SYSN_USER1;
DROP SYNONYM SYN_CC.SYNT1;
CONN SYSN_USER1/USER102_USER@127.0.0.1:1611
CREATE OR REPLACE SYNONYM SYN_CC.SYNT1 FOR SYSN_USER1_T1;
CONN / AS SYSDBA 
DROP USER IF EXISTS SYSN_USER1 CASCADE;
DROP USER IF EXISTS SYN_CC CASCADE;
CONN / AS SYSDBA 
ALTER SYSTEM SET ENABLE_ACCESS_DC = TRUE;
DROP USER IF EXISTS SELECT_ANY_TABLE_USER CASCADE;
DROP TABLE IF EXISTS SYS_T1;
CREATE TABLE SYS_T1(ID INT);
CREATE USER SELECT_ANY_TABLE_USER IDENTIFIED BY SELECT_ANY_TABLE_USER102_SELECT_ANY_TABLE_USER;
GRANT SELECT ANY TABLE ,CREATE VIEW ,CONNECT TO SELECT_ANY_TABLE_USER;
CONN SELECT_ANY_TABLE_USER/SELECT_ANY_TABLE_USER102_SELECT_ANY_TABLE_USER@127.0.0.1:1611
CREATE VIEW VIEW1 AS SELECT * FROM SYS.SYS_T1;
CREATE VIEW VIEW2 AS SELECT * FROM SYS.SYS_AUDIT;
CONN / AS SYSDBA 
ALTER SYSTEM SET ENABLE_ACCESS_DC = FALSE;
DROP USER IF EXISTS SELECT_ANY_TABLE_USER CASCADE;
DROP TABLE IF EXISTS SYS_T1;
CREATE TABLE SYS_T1(ID INT);
CREATE USER SELECT_ANY_TABLE_USER IDENTIFIED BY SELECT_ANY_TABLE_USER102_SELECT_ANY_TABLE_USER;
GRANT SELECT ANY TABLE ,CREATE VIEW ,CONNECT TO SELECT_ANY_TABLE_USER; 
CONN SELECT_ANY_TABLE_USER/SELECT_ANY_TABLE_USER102_SELECT_ANY_TABLE_USER@127.0.0.1:1611
CREATE VIEW VIEW1 AS SELECT * FROM SYS.SYS_T1;
CREATE VIEW VIEW2 AS SELECT * FROM SYS.SYS_AUDIT;
CONN / AS SYSDBA 
GRANT SELECT ON SYS_T1 TO SELECT_ANY_TABLE_USER;
GRANT SELECT ON SYS_AUDIT TO SELECT_ANY_TABLE_USER;
CONN / AS SYSDBA 
ALTER SYSTEM SET ENABLE_ACCESS_DC = FALSE; 
CONN SELECT_ANY_TABLE_USER/SELECT_ANY_TABLE_USER102_SELECT_ANY_TABLE_USER@127.0.0.1:1611
CREATE VIEW VIEW1 AS SELECT * FROM SYS.SYS_T1;
CREATE VIEW VIEW2 AS SELECT * FROM SYS.SYS_AUDIT;
CONN / AS SYSDBA 
ALTER SYSTEM SET ENABLE_ACCESS_DC = TRUE;
DROP USER IF EXISTS SELECT_ANY_TABLE_USER CASCADE;
DROP TABLE IF EXISTS SYS_T1;
CONN / AS  SYSDBA 
DROP USER IF EXISTS SELECT_ANY_TABLE_USER CASCADE;
CREATE USER SELECT_ANY_TABLE_USER IDENTIFIED BY CANTIAN_234;
GRANT DBA , CONNECT TO SELECT_ANY_TABLE_USER;
CONN SELECT_ANY_TABLE_USER/CANTIAN_234@127.0.0.1:1611
SELECT ID, NAME  FROM SYS.SYS_TABLES WHERE NAME='SYS_TABLES';
SELECT ID, NAME  FROM SYS.SYS_USERS WHERE ID=0;
CONN / AS SYSDBA
REVOKE DBA FROM SELECT_ANY_TABLE_USER;
CONN SELECT_ANY_TABLE_USER/CANTIAN_234@127.0.0.1:1611
SELECT ID, NAME  FROM SYS.SYS_TABLES WHERE NAME='SYS_TABLES';
SELECT ID, NAME  FROM SYS.SYS_USERS WHERE ID=0;
CONN / AS SYSDBA
GRANT SELECT ON SYS.SYS_TABLES TO SELECT_ANY_TABLE_USER;
GRANT SELECT ON SYS.SYS_USERS TO SELECT_ANY_TABLE_USER;
CONN SELECT_ANY_TABLE_USER/CANTIAN_234@127.0.0.1:1611
SELECT ID, NAME  FROM SYS.SYS_TABLES WHERE NAME='SYS_TABLES';
SELECT ID, NAME  FROM SYS.SYS_USERS WHERE ID=0;
CONN / AS SYSDBA
REVOKE SELECT ON SYS.SYS_TABLES FROM SELECT_ANY_TABLE_USER;
REVOKE SELECT ON SYS.SYS_USERS FROM SELECT_ANY_TABLE_USER;
CONN SELECT_ANY_TABLE_USER/CANTIAN_234@127.0.0.1:1611
SELECT ID, NAME  FROM SYS.SYS_TABLES WHERE NAME='SYS_TABLES';
SELECT ID, NAME  FROM SYS.SYS_USERS WHERE ID=0;
CONN / AS SYSDBA
ALTER SYSTEM SET ENABLE_ACCESS_DC = FALSE;
GRANT SELECT ANY TABLE TO SELECT_ANY_TABLE_USER;
CONN SELECT_ANY_TABLE_USER/CANTIAN_234@127.0.0.1:1611
SELECT ID, NAME  FROM SYS.SYS_TABLES WHERE NAME='SYS_TABLES';
SELECT ID, NAME  FROM SYS.SYS_USERS WHERE ID=0;
CONN / AS SYSDBA
ALTER SYSTEM SET ENABLE_ACCESS_DC = TRUE;
GRANT SELECT ANY TABLE TO SELECT_ANY_TABLE_USER;
CONN SELECT_ANY_TABLE_USER/CANTIAN_234@127.0.0.1:1611
SELECT ID, NAME  FROM SYS.SYS_TABLES WHERE NAME='SYS_TABLES';
SELECT ID, NAME  FROM SYS.SYS_USERS WHERE ID=0;
CONN / AS SYSDBA
DROP USER SELECT_ANY_TABLE_USER;
conn / as sysdba
drop user if exists cao1 cascade;
drop user if exists cao2 cascade;
create user cao1 identified by Cantian_234;
grant create session,create procedure to cao1;
create user cao2 identified by Cantian_234;
grant create session to cao2;
conn cao1/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE PROCEDURE cao1_1()
IS
    tmp varchar2(20) :='12345678';
begin
 dbe_output.print_line('OUT PUT RESULT:'||tmp);
end cao1_1;
/
grant execute on cao1_1 to cao2;
conn cao2/Cantian_234@127.0.0.1:1611
call cao1.cao1_1;
conn cao1/Cantian_234@127.0.0.1:1611
drop procedure cao1_1;
CREATE OR REPLACE PROCEDURE cao1_1()
IS
    tmp varchar2(20) :='12345678';
begin
 dbe_output.print_line('OUT PUT RESULT:'||tmp);
end cao1_1;
/
conn  cao2/Cantian_234@127.0.0.1:1611
call cao1.cao1_1;
conn cao1/Cantian_234@127.0.0.1:1611
grant execute on cao1_1 to cao2;
conn  cao2/Cantian_234@127.0.0.1:1611
call cao1.cao1_1;
conn / as sysdba
drop user if exists cao1 cascade;
drop user if exists cao2 cascade;
create user cao1 identified by Cantian_234;
grant create session,create procedure,create trigger,create table to cao1;
create user cao2 identified by Cantian_234;
grant create session to cao2;
conn cao1/Cantian_234@127.0.0.1:1611
drop table if exists t_enable_triggers;
create table t_enable_triggers(f1 int, f2 int);
CREATE OR REPLACE TRIGGER trig_enable_triggers1 BEFORE INSERT OR UPDATE OR DELETE ON t_enable_triggers
BEGIN
	dbe_output.print_line('BEFORE t_enable_triggers');
END;
/
CREATE OR REPLACE TRIGGER trig_enable_triggers2 AFTER INSERT OR UPDATE OR DELETE ON t_enable_triggers
BEGIN
	dbe_output.print_line('AFTER t_enable_triggers');
END;
/
insert into t_enable_triggers values(1, 2);
update t_enable_triggers set f2=3;
grant execute on trig_enable_triggers1 to cao2; //non support
grant insert on t_enable_triggers to cao2;
grant update on t_enable_triggers to cao2;
conn / as sysdba
select grantee, OBJECT_NAME, PRIVILEGE from adm_tab_privs where grantee = 'CAO2' and OBJECT_NAME = 'T_ENABLE_TRIGGERS';
conn cao1/Cantian_234@127.0.0.1:1611
drop trigger trig_enable_triggers1;
drop trigger trig_enable_triggers2;
drop table if exists t_enable_triggers;
conn / as sysdba
drop user if exists cao1 cascade;
drop user if exists cao2 cascade;
create user cao1 identified by Cantian_234;
grant create session,create procedure to cao1;
create user cao2 identified by Cantian_234;
grant create session to cao2;
conn cao1/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE PACKAGE cao1_1
IS
FUNCTION MYF RETURN INT;
PROCEDURE MYP;
END;
/
CREATE OR REPLACE PACKAGE BODY cao1_1
IS
FUNCTION MYF RETURN INT
IS
d int;
BEGIN
select 10 into d from dual;
RETURN d;
END;
PROCEDURE MYP IS
v_sql1 varchar(1023);
BEGIN
for i in (select OBJECT_NAME from all_objects where OBJECT_ID<5 and object_type not in ('INDEX'))loop
dbe_output.print_line(i.OBJECT_NAME);
end loop;
END;
END;
/
grant execute on cao1_1 to cao2;
conn cao2/Cantian_234@127.0.0.1:1611
call cao1.cao1_1.MYP;
select cao1.cao1_1.MYF();
conn cao1/Cantian_234@127.0.0.1:1611
drop package cao1_1;
CREATE OR REPLACE PACKAGE cao1_1
IS
FUNCTION MYF RETURN INT;
PROCEDURE MYP;
END;
/
CREATE OR REPLACE PACKAGE BODY cao1_1
IS
FUNCTION MYF RETURN INT
IS
d int;
BEGIN
select 10 into d from dual;
RETURN d;
END;
PROCEDURE MYP IS
v_sql1 varchar(1023);
BEGIN
for i in (select OBJECT_NAME from all_objects where OBJECT_ID<5 and object_type not in ('INDEX'))loop
dbe_output.print_line(i.OBJECT_NAME);
end loop;
END;
END;
/
conn  cao2/Cantian_234@127.0.0.1:1611
call   cao1.cao1_1.MYP;
select   cao1.cao1_1.MYF();
conn / as sysdba
drop user if exists cao1 cascade;
drop user if exists cao2 cascade;
conn / as sysdba
drop user if exists user1 cascade;
CREATE USER USER1 IDENTIFIED BY Cantian_234;
GRANT create session to USER1;
conn user1/Cantian_234@127.0.0.1:1611
EXECUTE USER3.procedure1;
select USER3.FUNCTION1(1);
conn / as sysdba
drop user if exists user1 cascade;
conn / as sysdba
drop user if exists user1 cascade;
drop user if exists user23 cascade;
CREATE USER USER1 IDENTIFIED BY Cantian_234;
GRANT create session to USER1;
conn user1/Cantian_234@127.0.0.1:1611
TRUNCATE TABLE USER23.TB_T1;
REPLACE INTO USER23.TB_T1(COL1) VALUES('TEST2');
conn / as sysdba
drop user if exists user1 cascade;
drop user if exists user23 cascade;
conn / as  sysdba
drop user if exists cao cascade ; 
drop user if exists cao1 cascade ;
drop user if exists cao2 cascade ;
create user cao identified by cao102_cao;
create user cao1 identified by cao102_cao;
create user cao2 identified by cao102_cao;
grant connect ,select any table ,create view to cao;
grant connect ,select any table ,create view to cao1;
grant connect ,select any table ,create view to cao2;
create table cao2.t1 (id int);
insert into cao2.t1 values (10);
conn  cao/cao102_cao@127.0.0.1:1611
create view view1 as select * from cao2.t1;
select * from cao.view1;
conn  cao1/cao102_cao@127.0.0.1:1611
select * from cao.view1;
conn / as sysdba
select * from cao.view1; 
revoke select any table from cao;
select * from cao.view1;
conn  cao/cao102_cao@127.0.0.1:1611
select * from view1;
conn  cao1/cao102_cao@127.0.0.1:1611
select * from cao.view1;
conn / as sysdba 
grant select any table to cao;
conn  cao/cao102_cao@127.0.0.1:1611
select * from view1;
conn  cao1/cao102_cao@127.0.0.1:1611
select * from cao.view1;
conn / as  sysdba
drop user if exists cao cascade ; 
drop user if exists cao1 cascade ;
drop user if exists cao2 cascade ;
conn / as sysdba 
drop user if exists cao cascade;
drop user if exists cao1 cascade;
drop user if exists cao2 cascade;
create user cao identified by cao102_cao;
create user cao1 identified by cao102_cao;
create user cao2 identified by cao102_cao;
grant connect , create table  to cao;
conn cao/cao102_cao@127.0.0.1:1611
create table tt (id int);
grant  select on tt to cao1;
grant  select on cao1.tt to cao2;
grant  select on cao1.tt to cao3;
grant  connect to cao3;
conn / as sysdba 
drop user if exists cao cascade;
drop user if exists cao1 cascade;
drop user if exists cao2 cascade;
conn / as  sysdba 
CREATE USER cao1 IDENTIFIED BY Cantian_234;
GRANT create session to cao1;
CONN cao1/Cantian_234@127.0.0.1:1611
DROP TABLE USER3.TB_T1;
DROP VIEW USER3.VIEW_T1;
drop role hello;
alter user helllo account unlock;
conn / as  sysdba 
DROP USER if exists cao1 cascade;
conn / as sysdba
drop user if exists cao cascade;
create user cao identified by cao102_cao;
grant connect , create table to cao;
conn cao/cao102_cao@127.0.0.1:1611
select * from dv_transactions;
select * from dv_all_trans;
select * from dv_global_transactions;
create table cao_t1 as select * from dv_global_transactions;
conn / as sysdba
grant select any table to cao;
conn cao/cao102_cao@127.0.0.1:1611
create table cao_t1 as select * from dv_global_transactions;
conn / as sysdba
drop user if exists cao cascade;
conn / as sysdba
drop user if exists B1 cascade;
drop user if exists A1 cascade;
create user B1 identified by Cantian_234;
create user A1 identified by Cantian_234;
grant connect,create any table,CREATE ANY PROCEDURE to B1;
grant alter session,connect to A1;
conn B1/Cantian_234@127.0.0.1:1611
drop table sections;
CREATE  TABLE sections
(
  section_id   NUMBER(4) not null,
  section_name VARCHAR2(30),
  manager_id   NUMBER(6),
  place_id     NUMBER(4)
) ;
insert into  sections (section_id, section_name, manager_id, place_id) values (10, 'Administration', 200, 1700);
select * from sections;
commit;
conn A1/Cantian_234@127.0.0.1:1611
select * from B1.sections;
ALTER SESSION  set  current_schema = B1;
select * from sections;
conn / as sysdba
drop user if exists B1 cascade;
drop user if exists A1 cascade;
conn / as sysdba
drop user if exists B cascade;
create user B identified by Cantian_234;
grant all to B;
drop user if exists A cascade;
create user A identified by Cantian_234;
grant connect to A;
conn B/Cantian_234@127.0.0.1:1611
CREATE SEQUENCE seq_auto_extend START WITH 10 MAXVALUE 200 INCREMENT BY 2 CYCLE;
conn / as sysdba
grant select on B.sections_view to A;
conn A/Cantian_234@127.0.0.1:1611
select B.seq_auto_extend.nextval from dual;
conn B/Cantian_234@127.0.0.1:1611
DROP SEQUENCE IF EXISTS B.seq_auto_extend;
conn A/Cantian_234@127.0.0.1:1611
select B.seq_auto_extend.nextval from dual;
conn / as sysdba
grant select any sequence to A;
conn A/Cantian_234@127.0.0.1:1611
select B.seq_auto_extend.nextval from dual;
conn / as sysdba
drop user if exists A cascade;
drop user if exists B cascade;
conn / as sysdba
drop user if exists cao2 cascade;
drop user if exists cao1 cascade;
create user cao2 identified by Cantian_234;
create user cao1 identified by Cantian_234;
grant connect,create any table to cao2;
grant connect to cao1;
conn  cao1/Cantian_234@127.0.0.1:1611
create table cao2.t1(id int);
conn / as sysdba
grant connect,create any table to cao1;
conn  cao1/Cantian_234@127.0.0.1:1611
create table cao2.t1(id int);
conn / as sysdba
revoke create any table from cao1;
conn  cao1/Cantian_234@127.0.0.1:1611
create table cao2.t1(id int);
conn  cao2/Cantian_234@127.0.0.1:1611
drop table cao2.t1;
conn  cao1/Cantian_234@127.0.0.1:1611
create table cao2.t1(id int);
select * from cao2.t1;
drop table cao2.t1;
insert into cao2.t1 values (10);
delete from cao2.t1;
alter table cao2.t1 add column name char(10) ;
conn / as sysdba
grant create any table to cao1;
grant select any table to cao1;
grant drop any table to cao1;
grant insert any table to cao1;
grant delete any table to cao1;
grant alter any table to cao1;
conn  cao1/Cantian_234@127.0.0.1:1611
select * from cao2.t1;
drop table cao2.t1;
insert into cao2.t1 values (10);
delete from cao2.t1;
alter table cao2.t1 add column name char(10) ;
create table cao2.t1(id int);
select * from cao2.t1;
insert into cao2.t1 values (10);
delete from cao2.t1;
alter table cao2.t1 add column name char(10) ;
drop table cao2.t1;
create table cao2.t1(id int);
create index if not exists cao2.inxt1 on cao2.t1(id);
create index  cao2.inxt1 on cao2.t1(id);
drop index if exists cao2.inxt1 on cao2.t1;
drop index  cao2.inxt1 on cao2.t1;
alter index cao2.inxt1 on cao2.t1 rebuild online;
conn / as sysdba
revoke create any table from cao1;
revoke select any table from cao1;
revoke drop any table from cao1;
revoke insert any table from cao1;
revoke delete any table from cao1;
revoke alter any table from cao1;
grant create any index to cao1;
grant drop any index to cao1;
grant alter any index to cao1;
conn  cao1/Cantian_234@127.0.0.1:1611
drop index if exists cao2.inxt1 on cao2.t1;
drop index  cao2.inxt1 on cao2.t1;
alter index cao2.inxt1 on cao2.t1 rebuild online;
create index if not exists cao2.inxt1 on cao2.t1(id);
create index  cao2.inxt1 on cao2.t1(id);
conn / as sysdba
revoke create any index from cao1;
revoke drop any index from cao1;
revoke alter any index from cao1;
conn  cao1/Cantian_234@127.0.0.1:1611
create index if not exists cao2.inxt1 on cao2.t1(id);
create index  cao2.inxt1 on cao2.t1(id);
drop index if exists cao2.inxt1 on cao2.t1;
drop index  cao2.inxt1 on cao2.t1;
alter index cao2.inxt1 on cao2.t1 rebuild online;
create sequence cao2.sq;
drop   sequence cao2.sq;
alter  sequence cao2.sq  cycle;
conn / as sysdba
grant create any sequence to cao1;
grant drop any sequence to cao1;
grant alter any sequence to cao1;
conn  cao1/Cantian_234@127.0.0.1:1611
drop   sequence cao2.sq;
alter  sequence cao2.sq  cycle;
create sequence cao2.sq;
drop   sequence cao2.sq;
alter  sequence cao2.sq  cycle;
conn / as sysdba
drop table cao2.t1;
grant select on cao2.t1 to cao1;
conn  cao1/Cantian_234@127.0.0.1:1611
create synonym cao2.hello0 for cao2.t1;
create synonym hello1 for cao2.t1;
drop synonym cao2.hello0;
drop synonym hello1;
COMMENT ON COLUMN cao2.training.staff_id  IS 'id of staffs taking training courses';
conn / as sysdba
drop user if exists cao2 cascade;
drop user if exists cao1 cascade;
conn / as sysdba
create user cao7 identified by Cantian_234;
grant create session to cao7;
conn cao7/Cantian_234@127.0.0.1:1611
SELECT DBE_DIAGNOSE.DBA_IND_POS('2,3,1,0,4','4') from dual;
conn / as sysdba
grant EXECUTE ON sys.DBE_DIAGNOSE to cao7;
conn cao7/Cantian_234@127.0.0.1:1611
SELECT DBE_DIAGNOSE.DBA_IND_POS('2,3,1,0,4','4')     from dual;
conn / as sysdba
revoke  EXECUTE ON sys.DBE_DIAGNOSE from  cao7;
conn cao7/Cantian_234@127.0.0.1:1611
SELECT DBE_DIAGNOSE.DBA_IND_POS('2,3,1,0,4','4')     from dual;
conn / as sysdba
grant EXECUTE ON sys.DBE_DIAGNOSE to cao7;
conn cao7/Cantian_234@127.0.0.1:1611
SELECT DBE_DIAGNOSE.DBA_IND_POS('2,3,1,0,4','4')     from dual;
conn / as sysdba
drop user cao7 cascade;
create user cao7 identified by Cantian_234;
grant create session to cao7;
conn cao7/Cantian_234@127.0.0.1:1611
SELECT DBE_DIAGNOSE.DBA_IND_POS('2,3,1,0,4','4')     from dual;
conn / as sysdba
drop user cao7 cascade;
conn / as sysdba
create user user1 identified by Changeme_123;
grant connect to user1;
create table table_sys(name varchar(10),id int);
insert into table_sys values('cao',10);
grant create any trigger to user1;
grant create any table to user1;
CREATE OR REPLACE TRIGGER t_trigger BEFORE UPDATE ON sys.table_sys FOR EACH ROW AS
BEGIN
    dbe_output.print_line('BEFORE table_sys');
END;
/
CREATE OR REPLACE TRIGGER user1.t_trigger BEFORE UPDATE ON sys.table_sys FOR EACH ROW AS
BEGIN
    dbe_output.print_line('BEFORE table_sys');
END;
/
conn user1/Changeme_123@127.0.0.1:1611
CREATE OR REPLACE TRIGGER t_trigger BEFORE UPDATE ON sys.table_sys FOR EACH ROW AS
BEGIN
    dbe_output.print_line('BEFORE table_sys');
END;
/
CREATE OR REPLACE TRIGGER sys.t_trigger BEFORE UPDATE ON sys.table_sys FOR EACH ROW AS
BEGIN
    dbe_output.print_line('BEFORE table_sys');
END;
/
create table u_t1(name varchar(10),id int);
insert into u_t1 values('cao',10);
CREATE OR REPLACE TRIGGER sys.t_trigger1 BEFORE UPDATE ON u_t1 FOR EACH ROW AS
BEGIN
    dbe_output.print_line('BEFORE table_sys');
END;
/
CREATE OR REPLACE TRIGGER t_trigger1 BEFORE UPDATE ON u_t1 FOR EACH ROW AS
BEGIN
    dbe_output.print_line('BEFORE table_sys');
END;
/
CREATE OR REPLACE TRIGGER t_trigger1 BEFORE UPDATE ON sys.table_sys FOR EACH ROW AS
BEGIN
    dbe_output.print_line('BEFORE table_sys');
END;
/
select name from  all_source where name like '%TRIGG%';
drop table u_t1;
conn / as sysdba
update table_sys set name='aa';
drop table table_sys;
drop user user1 cascade;
conn / as sysdba
create user cao7 identified by Cantian_234;
grant create session to cao7;       
conn cao7/Cantian_234@127.0.0.1:1611
SELECT DBE_DIAGNOSE.DBA_IND_POS('2,3,1,0,4','4') from dual;     
conn / as sysdba
SELECT DBE_DIAGNOSE.DBA_IND_POS('2,3,1,0,4','4')  from dual;
create user cao6 identified by Cantian_234;
grant create session to cao6;
grant dba to cao6;
conn cao6/Cantian_234@127.0.0.1:1611
SELECT DBE_DIAGNOSE.DBA_IND_POS('2,3,1,0,4','4')   from dual;
grant EXECUTE ON sys.DBE_DIAGNOSE to cao7;
conn / as sysdba
revoke dba from cao6;
grant EXECUTE ON DBE_DIAGNOSE to cao6;
conn cao6/Cantian_234@127.0.0.1:1611
SELECT DBE_DIAGNOSE.DBA_IND_POS('2,3,1,0,4','4')     from dual;
conn / as sysdba
drop user cao6 cascade;
drop user cao7 cascade;
conn sys/Huawei@123@127.0.0.1:1611
create user cao identified by cao102_cao;
grant dba  to cao;
conn cao/cao102_cao@127.0.0.1:1611
SELECT OWNER FROM sys.dba_tables order by OWNER limit 1;
create table pri_t1 (id int,name char);
create view view_pri_t1 as select id  from pri_t1;
insert into pri_t1 values (10, 'd');
create public synonym syn_view_pri_t1 for cao.view_pri_t1;
select * from syn_view_pri_t1;
select * from cao.view_pri_t1;
select id  from (select * from pri_t1 );
drop public synonym syn_view_pri_t1;
drop view view_pri_t1;
drop table pri_t1;
conn sys/Huawei@123@127.0.0.1:1611
drop user cao cascade;
conn sys/Huawei@123@127.0.0.1:1611
create user cao1 identified by cao102_cao;
grant connect ,create any table ,create any view  to cao1;
create  view abc as select DBE_DIAGNOSE.dba_user_name(0) from dual;
create  view cao1.abc as select DBE_DIAGNOSE.dba_user_name(0) from dual;
select owner,table_name,table_id from all_tables where table_name='SYS_TABLES';
select DBE_DIAGNOSE.dba_user_name(0) from dual;
select DBE_DIAGNOSE.dba_space_name(0) from dual;
conn cao1/cao102_cao@127.0.0.1:1611
select * from cao1.abc;
select * from sys.abc;
select DBE_DIAGNOSE.dba_user_name(0) from dual;
select DBE_DIAGNOSE.dba_space_name(0) from dual;
create  view abc as select DBE_DIAGNOSE.dba_user_name(0) from dual; 
conn sys/Huawei@123@127.0.0.1:1611
drop user cao1 cascade;
drop view abc;
conn sys/Huawei@123@127.0.0.1:1611
create table table_sys(name varchar(50));
CREATE OR REPLACE TRIGGER TRIGGER_sys
   after delete
   ON table_sys
   FOR EACH ROW
BEGIN
   INSERT INTO table_sys(name)
       VALUES(:new.name);
END;
/
create user tri_user1 identified by Changeme_123;
grant ALTER ANY TRIGGER to tri_user1;
grant create session to tri_user1;
conn tri_user1/Changeme_123@127.0.0.1:1611
alter TRIGGER sys.TRIGGER_sys disable;
conn sys/Huawei@123@127.0.0.1:1611
drop user tri_user1 cascade;
drop TRIGGER TRIGGER_sys;
drop table table_sys;
conn / as sysdba
create user cao_1 identified by Cantian_234;
grant create session,create table to cao_1;
create user cao_2 identified by Cantian_234;
grant create session,GRANT ANY OBJECT PRIVILEGE to cao_2;
create user cao_3 identified by Cantian_234;
grant create session,create table to cao_3;
conn cao_1/Cantian_234@127.0.0.1:1611
create table caot_1(id int);
insert into caot_1 values(10);
commit;
conn cao_2/Cantian_234@127.0.0.1:1611
grant select on cao_1.caot_1 to cao_3;
grant select on cao_1.caot_1 to cao_2;
select * from cao_1.caot_1;
conn cao_3/Cantian_234@127.0.0.1:1611
select * from cao_1.caot_1;
conn / as sysdba
drop user cao_1 cascade;
drop user cao_2 cascade;
drop user cao_3 cascade;
--DTS2019020108501
create user jie_1 identified by Cantian_234;
grant create session,CREATE ANY TABLE to jie_1;
create user jie_2 identified by Cantian_234;
grant create session,CREATE ANY TABLE,CREATE ANY TRIGGER to jie_2;
create user jie_3 identified by Cantian_234;
grant create session,CREATE ANY TABLE to jie_3;
create user jie_4 identified by Cantian_234;
grant create session,CREATE ANY TABLE to jie_4;
 
conn jie_1/Cantian_234@127.0.0.1:1611
create table jiet_1(id int);
insert into jiet_1 values (10);
grant insert on jiet_1 to jie_2;
conn jie_2/Cantian_234@127.0.0.1:1611
create table jiet_2(id int);
insert into jiet_2 values (20);
grant insert on jiet_2 to jie_3;
 create table jiet_2_1(id int);
insert into jiet_2_1 values (30);
grant insert on jiet_2_1 to jie_3;
CREATE OR REPLACE TRIGGER TRIGGER_jie_2_2
   after insert
   ON jiet_2
   FOR EACH ROW
BEGIN
   INSERT INTO jiet_2_1(id)
       VALUES(100);
END;
/ 
conn jie_3/Cantian_234@127.0.0.1:1611
insert into jie_2.jiet_2 values (300); 
commit;  
conn jie_4/Cantian_234@127.0.0.1:1611
insert into jie_2.jiet_2 values (400);
commit;
conn jie_2/Cantian_234@127.0.0.1:1611
select * from jiet_2;
select * from jiet_2_1;
conn sys/Huawei@123@127.0.0.1:1611
drop user jie_1 cascade; 
drop user jie_2 cascade; 
drop user jie_3 cascade; 
drop user jie_4 cascade;
--DTS2019020205034
conn / as sysdba
create user cao_seq1 identified by Cantian_234;
grant create session,create any SEQUENCE to cao_seq1;
conn cao_seq1/Cantian_234@127.0.0.1:1611
create sequence alter_seq1 MAXVALUE 100 INCREMENT BY 1 START WITH 1 CACHE 20;
ALTER SEQUENCE alter_seq1 MAXVALUE 10000 INCREMENT BY 4 CYCLE;
conn / as sysdba
drop user cao_seq1 cascade;
--DTS2019010204140
conn / as sysdba
create user bigcao identified by Cantian_234;
grant create session,create table,ALTER ANY TABLE,DROP ANY TABLE,FLASHBACK ANY TABLE,LOCK ANY TABLE,SELECT ANY TABLE,COMMENT ANY TABLE,UPDATE ANY TABLE,INSERT ANY TABLE,DELETE ANY TABLE,EXECUTE ANY PROCEDURE to bigcao;
create or replace PROCEDURE PROCEDURE_0121 is
begin
null;
end;
/
create table privi_bigtab(name varchar(2048));
insert into privi_bigtab values('xiaoming');
select name from sys.privi_bigtab;
ALTER TABLE privi_bigtab MODIFY(name CONSTRAINT namefeikong NOT NULL);
create table privi_hua(id int);
grant  select on privi_hua to bigcao;
grant delete on privi_hua to bigcao;
grant update on privi_hua to bigcao;
grant insert on privi_hua to bigcao;
conn bigcao/Cantian_234@127.0.0.1:1611
--privilege for one object
select * from sys.privi_hua;
insert into sys.privi_hua values(10);
exec sys.PROCEDURE_0121;
update  sys.privi_hua set id =20 where id=10;
select * from sys.privi_hua;
--privilege for any object
insert into sys.privi_bigtab values('xiaozhang');
update sys.privi_bigtab set name='xiaoyu' where name='xiaoming';
delete from sys.privi_bigtab;
LOCK TABLE sys.privi_bigtab IN SHARE MODE;
LOCK TABLE sys.privi_bigtab IN EXCLUSIVE MODE;
conn / as sysdba
drop user bigcao CASCADE;
drop table privi_bigtab;
drop table privi_hua;
---procedure        
conn / as sysdba 
create user zzy identified by zzy102_zzy  ;              
grant connect to zzy;
grant create any table to zzy;
grant create public synonym to zzy;
grant create any synonym to zzy;
grant drop any procedure to zzy;
grant drop public synonym to zzy;
grant create any table to zzy;
grant drop any table to zzy;
create table test_tab1 (id int);
create public synonym pub_test_syn for test_tab1;
create synonym  pub_test_syn1 for test_tab1;

conn zzy/zzy102_zzy@127.0.0.1:1611 
drop public synonym pub_test_syn;-----keyi 
drop synonym sys.pub_test_syn1;-----bukeyi
create table test_tab2(id int);
create public synonym pub_test_syn3 for test_tab2;--keyi
create synonym sys.pub_test_syn4 for test_tab2;--bukeyi
drop public synonym pub_test_syn3;
drop table test_tab2;
conn / as sysdba
drop synonym sys.pub_test_syn1;
drop table test_tab1;
---procedure
conn / as sysdba
grant create any procedure to zzy;
grant drop any procedure to zzy;
drop table if exists plsql_t1;
create table plsql_t1 (f1 int, f2 varchar(100));
insert into plsql_t1 values (1, 'a'), (2, 'b'), (3, 'c');
commit;
create or replace procedure plsql_p1()
as
a int := 10;
c4 SYS_REFCURSOR;
begin
open c4 for select * from plsql_t1 where f1 < a order by f1;
dbe_sql.return_cursor(c4);
end;
/
conn zzy/zzy102_zzy@127.0.0.1:1611
drop procedure sys.plsql_p1;
drop table if exists plsql_t2;
create table plsql_t2 (f1 int, f2 varchar(100));
insert into plsql_t2 values (1, 'a'), (2, 'b'), (3, 'c');
commit;
create procedure sys.plsql_p2()
as
a int := 10;
c4 SYS_REFCURSOR;
begin
open c4 for select * from plsql_t2 where f1 < a order by f1;
dbe_sql.return_cursor(c4);
end;
/
drop table plsql_t2;
conn / as sysdba
drop procedure sys.plsql_p1;
drop table plsql_t1;
---trigger
conn / as sysdba
grant create any trigger to zzy;
grant drop any trigger to zzy;
create table tri_tab1(id int );
create table tri_tab2(id int );
CREATE OR REPLACE TRIGGER TRIG_BEFORE_INSERT
 BEFORE INSERT ON tri_tab1 
 BEGIN 
 INSERT INTO tri_tab2 VALUES(7);
 END;
 /
INSERT INTO tri_tab1 VALUES(2); 
select * from  tri_tab1;
select * from  tri_tab2;
conn zzy/zzy102_zzy@127.0.0.1:1611
create table tri_tab11(id int );
create table tri_tab21(id int );
drop TRIGGER sys.TRIG_BEFORE_INSERT;
CREATE OR REPLACE TRIGGER sys.TRIG_BEFORE_INSERT1
 BEFORE INSERT ON zzy.tri_tab11 
 BEGIN 
 INSERT INTO zzy.tri_tab21 VALUES(7);
 END;
 /
INSERT INTO tri_tab11 VALUES(2); 
select * from  tri_tab11;
select * from  tri_tab21;
drop table tri_tab11;
drop table tri_tab21;
conn / as sysdba
drop table tri_tab1;
drop table tri_tab2;
drop TRIGGER sys.TRIG_BEFORE_INSERT;
-----FUNCTION
conn / as sysdba
grant create any FUNCTION to zzy;
grant drop any FUNCTION to zzy;
DROP TABLE IF EXISTS PLSQL_T_PROC_1;
CREATE TABLE PLSQL_T_PROC_1 (F_INT1 INT);
CREATE OR REPLACE FUNCTION PLSQL_Zenith_Test_Sysdate return varchar2
IS
 cunt int := 0;
 Begin
 select count(*) into cunt from dual;
 dbe_output.print_line(cunt);
 IF SQL % FOUND
  then
 return cunt;
 end if;
 End PLSQL_Zenith_Test_Sysdate;
/


conn zzy/zzy102_zzy@127.0.0.1:1611
drop FUNCTION sys.PLSQL_Zenith_Test_Sysdate;
CREATE OR REPLACE FUNCTION sys.PLSQL_Zenith_Test_Sysdate1 return varchar2
IS
 cunt int := 0;
 Begin
 select count(*) into cunt from dual;
 dbe_output.print_line(cunt);
 IF SQL % FOUND
  then
 return cunt;
 end if;
 End PLSQL_Zenith_Test_Sysdate1;
/
conn / as sysdba
drop table PLSQL_T_PROC_1;
drop FUNCTION sys.PLSQL_Zenith_Test_Sysdate;
drop user zzy cascade;
-- TESTCASE: ROLE & SYSTEM PRIVILEGES

-- create users
create user user_priv_test_0 identified by Root12345;
create user user_priv_test_1 identified by Root12345;
create user user_priv_test_2 identified by Root12345;
create user user_priv_test_3 identified by Root12345;

-- create roles
create role role_priv_test_0 identified by Root12345;
create role role_priv_test_1 identified by Root12345;
create role role_priv_test_2 identified by Root12345;
create role role_priv_test_3 identified by Root12345;
create role role_priv_test_4 identified by Root12345;
create role role_priv_test_5 identified by Root12345;
create role role_priv_test_6 identified by Root12345;

-- duplicated name test
create user role_priv_test_0 identified by Root12345;
create user user_priv_test_0 identified by Root12345;
create role user_priv_test_0 identified by Root12345;
create role role_priv_test_0 identified by Root12345;

-- test: privileges test
create table user_priv_test_1.table_priv_test_1 (id int);

-- create session
grant create session to user_priv_test_0;
connect user_priv_test_0/Root12345@127.0.0.1:1611

-- create/drop user
create user user_priv_test_4 identified by Root12345;
drop user user_priv_test_4;

-- create/drop role
create role role_priv_test_7 identified by Root12345;
drop role role_priv_test_7;

-- alter system 
alter system kill session '999,0';

-- lock table
lock table user_priv_test_1.table_priv_test_1 in share mode;

-- create/drop table
create table table_priv_test_2 (id int);
drop table table_priv_test_2;

-- create/drop index
create index user_priv_test_1.IX_PRIV_TEST_1 ON user_priv_test_1.table_priv_test_1 (id);
drop index user_priv_test_1.IX_PRIV_TEST_1 ON user_priv_test_1.table_priv_test_1;

-- create/drop/alter sequence
create sequence PRIV_SEQ_0;
drop sequence PRIV_SEQ_0;
alter sequence PRIV_SEQ_0 start with 1;

-- create/drop view
create view PIRV_TEST_VIEW_0 as select * from SYS.SYS_INDEXES;
drop view PIRV_TEST_VIEW_0;

-- create/drop synonym
create public synonym PRIV_TEST_SYNONYM_1 for SYS.SYS_TABLES;
drop public synonym if exists PRIV_TEST_SYNONYM_1 FORCE;

-- TODO: flashback/truncate/purge

-- grant the privileges and check again
connect sys/Huawei@123@127.0.0.1:1611
grant create user, create role, create table to user_priv_test_0;
grant alter system to user_priv_test_0;
grant lock any table to user_priv_test_0;
grant drop any table to user_priv_test_0;
grant drop any index to user_priv_test_0;
grant drop user to user_priv_test_0;
grant create sequence to user_priv_test_0;
grant create view to user_priv_test_0;
grant create public synonym, drop public synonym to user_priv_test_0;

-- test again:
connect user_priv_test_0/Root12345@127.0.0.1:1611

-- create/drop user
create user user_priv_test_4 identified by Root12345;
drop user user_priv_test_4;

-- create/drop role
create role role_priv_test_7 identified by Root12345;
drop role role_priv_test_7;

-- alter system 
alter system kill session '999,0';

-- lock table
lock table user_priv_test_1.table_priv_test_1 in share mode;

-- create/drop table
create table table_priv_test_2 (id int);
drop table table_priv_test_2;

-- create/drop index
create index user_priv_test_1.IX_PRIV_TEST_1 ON user_priv_test_1.table_priv_test_1 (id);
drop index user_priv_test_1.IX_PRIV_TEST_1 ON user_priv_test_1.table_priv_test_1;

-- create/drop/alter sequence
create sequence PRIV_SEQ_0;
alter sequence PRIV_SEQ_0 start with 1;
drop sequence PRIV_SEQ_0;

-- create/drop view
create view PIRV_TEST_VIEW_0 as select * from SYS.SYS_INDEXES;
drop view PIRV_TEST_VIEW_0;

-- create/drop synonym
create public synonym PRIV_TEST_SYNONYM_1 for SYS.SYS_TABLES;
drop public synonym if exists PRIV_TEST_SYNONYM_1 FORCE;

-- grant role to user
connect sys/Huawei@123@127.0.0.1:1611
grant create any table to role_priv_test_1;
grant create any index to role_priv_test_1;

-- grant role to role (grant role circle check)
grant role_priv_test_1 to role_priv_test_3;
grant role_priv_test_2 to role_priv_test_3;
grant role_priv_test_3 to role_priv_test_4;
grant role_priv_test_3 to role_priv_test_5;
grant role_priv_test_3 to user_priv_test_1;
grant role_priv_test_5 to role_priv_test_6;
grant role_priv_test_1 to user_priv_test_3;

-- role circle check
grant role_priv_test_5 to role_priv_test_1;
grant role_priv_test_5 to role_priv_test_5;

-- check data:
select ID, NAME, DATA_SPACE#, TEMP_SPACE# from SYS_USERS order by ID;
select ID, OWNER_UID, NAME from SYS_ROLES order by ID;
select * from SYS_PRIVS order by GRANTEE_ID, GRANTEE_TYPE, PRIVILEGE;
select * from SYS_USER_ROLES order by GRANTEE_ID, GRANTEE_TYPE, GRANTED_ROLE_ID;

-- revoke role from role
revoke role_priv_test_5 from role_priv_test_6;

-- revoke role from user
revoke role_priv_test_1 from user_priv_test_3;

revoke create session from user_priv_test_0;

-- revoke system privileges from role
revoke create any table, create any index from role_priv_test_1;

-- check data
select ID, NAME, DATA_SPACE#, TEMP_SPACE# from SYS_USERS order by ID;
select ID, OWNER_UID, NAME from SYS_ROLES order by ID;
select * from SYS_PRIVS order by GRANTEE_ID, GRANTEE_TYPE, PRIVILEGE;
select * from SYS_USER_ROLES order by GRANTEE_ID, GRANTEE_TYPE, GRANTED_ROLE_ID;

drop role role_priv_test_3;

-- check data
select ID, NAME, DATA_SPACE#, TEMP_SPACE# from SYS_USERS order by ID;
select ID, OWNER_UID, NAME from SYS_ROLES order by ID;
select * from SYS_PRIVS order by GRANTEE_ID, GRANTEE_TYPE, PRIVILEGE;
select * from SYS_USER_ROLES order by GRANTEE_ID, GRANTEE_TYPE, GRANTED_ROLE_ID;

-- error check:
-- grant wrong privileges/role to user/role
grant privileges not exist to user_priv_test_3;
grant privileges not exist to role_priv_test_4;

-- grant privileges/role to wrong user/role
grant DROP ANY TABLE to user_not_exist;
grant DROP ANY TABLE to role_not_exist;

-- revoke wrong/not granted privileges/role from user/role
revoke DROP TABLESPACE from user_priv_test_3;
revoke DROP PROFILE from role_priv_test_3;

-- revoke privileges/role from wrong user/role
revoke DROP TABLESPACE from user_not_exist;
revoke DROP PROFILE from role_not_exist;

-- drop all users/roles
drop user USER_PRIV_TEST_0 cascade;
drop user USER_PRIV_TEST_1 cascade;
drop user USER_PRIV_TEST_2 cascade;
drop user USER_PRIV_TEST_3 cascade;

drop role ROLE_PRIV_TEST_0;
drop role ROLE_PRIV_TEST_1;
drop role ROLE_PRIV_TEST_2;
drop role ROLE_PRIV_TEST_3;
drop role ROLE_PRIV_TEST_4;
drop role ROLE_PRIV_TEST_5;
drop role ROLE_PRIV_TEST_6;

-- check data
select ID, NAME, DATA_SPACE#, TEMP_SPACE# from SYS_USERS order by ID;
select ID, OWNER_UID, NAME from SYS_ROLES order by ID;
select * from SYS_PRIVS order by GRANTEE_ID, GRANTEE_TYPE, PRIVILEGE;
select * from SYS_USER_ROLES order by GRANTEE_ID, GRANTEE_TYPE, GRANTED_ROLE_ID;

--dba role
create user user_priv_test_5 identified by Root12345;
grant dba to user_priv_test_5;
select * from SYS_USER_ROLES order by GRANTEE_ID, GRANTEE_TYPE, GRANTED_ROLE_ID;
revoke dba from user_priv_test_5;
select * from SYS_USER_ROLES order by GRANTEE_ID, GRANTEE_TYPE, GRANTED_ROLE_ID;
drop user user_priv_test_5 cascade;

-- grant all privileges
create user user_priv_test_6 identified by Root12345;
grant all privileges to user_priv_test_6;
grant all to user_priv_test_6;
select * from SYS_PRIVS order by GRANTEE_ID, GRANTEE_TYPE, PRIVILEGE;
revoke create session, create table from user_priv_test_6;
select * from SYS_PRIVS order by GRANTEE_ID, GRANTEE_TYPE, PRIVILEGE;
revoke all privileges from user_priv_test_6;
revoke all from user_priv_test_6;
select * from SYS_PRIVS order by GRANTEE_ID, GRANTEE_TYPE, PRIVILEGE;
drop user user_priv_test_6 cascade;

-- test create role sql
create role ROLE_TEST_001 abc;
create role ROLE_TEST_001 not identified;
create role ROLE_TEST_002 identified by 'Root12345';
drop role ROLE_TEST_001;
drop role ROLE_TEST_002;

-- test exception routine
create user USER_TEST_001 identified by Root12345;
create user USER_TEST_002 identified by Root12345;
grant create table, create table to USER_TEST_001;
grant all privileges, create table to USER_TEST_001;
grant dba to USER_TEST_001, USER_TEST_001;
grant to USER_TEST_001;
grant dba to USER_TEST_001 with;
grant dba to USER_TEST_001 with admin;
grant dba to USER_TEST_001 with admin option;
grant dba to USER_TEST_001 with admin option more;
grant create table, create any table to sys, USER_TEST_001 USER_TEST_002;
grant create table, create any table to sys,,USER_TEST_001;
grant create table, create any table to sys, USER_TEST_001;
grant create table, create any table to;
revoke create any table from USER_TEST_001 USER_TEST_002;
revoke create any table from USER_TEST_001,,USER_TEST_002;
grant create any table to USER_TEST_002;
revoke create any table from USER_TEST_001, USER_TEST_002;
revoke create any table from ;
revoke create any table from USER_TEST_001, USER_TEST_002 cascade;

revoke dba from USER_TEST_001;
grant create session to USER_TEST_001;
conn USER_TEST_001/Root12345@127.0.0.1:1611
create table USER_TEST_001.tab001 (id int);
lock table tab001 in share mode;
conn sys/Huawei@123@127.0.0.1:1611

grant create any index to USER_TEST_001;
grant create any index to USER_TEST_001;
grant create any index to USER_TEST_001 with admin option;

grant dba to USER_TEST_001;
grant dba to USER_TEST_001;
grant dba to USER_TEST_001 with admin option;

create role ROLE_TEST_001;
grant create any index to ROLE_TEST_001;
grant create any index to ROLE_TEST_001;
grant create any index to ROLE_TEST_001 with admin option;

create role ROLE_TEST_002;
grant ROLE_TEST_001 to ROLE_TEST_002;
grant ROLE_TEST_001 to ROLE_TEST_002;
grant ROLE_TEST_001 to ROLE_TEST_002 with admin option;

grant all privileges to ROLE_TEST_001;
revoke all privileges from ROLE_TEST_001;

grant all privileges to USER_TEST_001;
revoke all privileges from USER_TEST_001;

create role ROLE_TEST_003;
revoke ROLE_TEST_003 from USER_TEST_001;
revoke ROLE_TEST_003 from ROLE_TEST_002;

drop user USER_TEST_001 cascade;
drop user USER_TEST_002 cascade;
drop role ROLE_TEST_001;
drop role ROLE_TEST_002;
drop role ROLE_TEST_003;

create user USER_TEST_001 identified by Root12345;
create user USER_TEST_002 identified by Root12345;
create role ROLE_TEST_001;
create role ROLE_TEST_002;

grant create session to USER_TEST_001;
grant ROLE_TEST_002 to USER_TEST_001 with admin option;

-- check grant privilege
conn USER_TEST_001/Root12345@127.0.0.1:1611
grant create table to USER_TEST_002;
conn sys/Huawei@123@127.0.0.1:1611
grant create table to USER_TEST_001 with admin option;
conn USER_TEST_001/Root12345@127.0.0.1:1611
grant create table to USER_TEST_002;

-- check drop role privilege
drop role ROLE_TEST_001;
drop role ROLE_TEST_002;

conn sys/Huawei@123@127.0.0.1:1611
select ID, OWNER_UID, NAME from SYS_ROLES order by ID;

drop user USER_TEST_001 cascade;
drop user USER_TEST_002 cascade;
drop role ROLE_TEST_001;
drop role ROLE_TEST_002;

-- object privilege test case
create user obj_test_user_001 identified by Root1234;
create user obj_test_user_002 identified by Root1234;
create user obj_test_user_003 identified by Root1234;
create user obj_test_user_004 identified by Root1234;

create role obj_test_role_001;
create role obj_test_role_002;
create role obj_test_role_003;
create role obj_test_role_004;

create table obj_test_user_001.tab_001 (id int);
insert into obj_test_user_001.tab_001 values (1);

create table obj_test_user_002.tab_002 (id int);
insert into obj_test_user_002.tab_002 values (2);

create table obj_test_user_003.tab_003 (id int);
insert into obj_test_user_003.tab_003 values (3);

grant create session to obj_test_user_001;
grant create session to obj_test_user_002;
grant create session to obj_test_user_003;
grant create session to obj_test_user_004;
-- 1. select on table/view/sequence to user
-- 1.1 table
conn obj_test_user_002/Root1234@127.0.0.1:1611
select * from tab_002;
select * from obj_test_user_001.tab_001;
select * from (select * from obj_test_user_001.tab_001);

conn sys/Huawei@123@127.0.0.1:1611
grant select on obj_test_user_001.tab_001 to obj_test_user_002;
conn obj_test_user_002/Root1234@127.0.0.1:1611
select * from obj_test_user_001.tab_001;
select * from (select * from obj_test_user_001.tab_001);

conn obj_test_user_001/Root1234@127.0.0.1:1611
revoke select on tab_001 from obj_test_user_002;
conn obj_test_user_002/Root1234@127.0.0.1:1611
select * from obj_test_user_001.tab_001;

conn sys/Huawei@123@127.0.0.1:1611

--1.2 view
grant select on obj_test_user_003.tab_003 to obj_test_user_001;
create view obj_test_user_001.view_001 as select * from obj_test_user_003.tab_003;

conn obj_test_user_002/Root1234@127.0.0.1:1611
select * from obj_test_user_001.view_001;

conn sys/Huawei@123@127.0.0.1:1611
grant select on obj_test_user_001.view_001 to obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
select * from obj_test_user_001.view_001;

conn sys/Huawei@123@127.0.0.1:1611
revoke select on obj_test_user_001.view_001 from obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
select * from obj_test_user_001.view_001;

conn sys/Huawei@123@127.0.0.1:1611
grant select on obj_test_user_001.view_001 to obj_test_user_002;
revoke select on obj_test_user_003.tab_003 from obj_test_user_001;

conn obj_test_user_002/Root1234@127.0.0.1:1611
select * from obj_test_user_001.view_001;

conn sys/Huawei@123@127.0.0.1:1611
grant read on obj_test_user_003.tab_003 to obj_test_user_001;

conn obj_test_user_002/Root1234@127.0.0.1:1611
select * from obj_test_user_001.view_001;

conn sys/Huawei@123@127.0.0.1:1611
revoke select on obj_test_user_001.view_001 from obj_test_user_002;
revoke read on obj_test_user_003.tab_003 from obj_test_user_001;

conn obj_test_user_002/Root1234@127.0.0.1:1611
select * from obj_test_user_001.view_001;

conn sys/Huawei@123@127.0.0.1:1611
select * from obj_test_user_001.view_001;

grant read any table to obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
select * from obj_test_user_001.view_001;

conn sys/Huawei@123@127.0.0.1:1611
revoke read any table from obj_test_user_002;
grant read on obj_test_user_001.view_001 to obj_test_user_002;
create or replace public synonym USER_PUBLIC_VIEW for obj_test_user_001.view_001;

conn obj_test_user_002/Root1234@127.0.0.1:1611
select * from USER_PUBLIC_VIEW;

conn sys/Huawei@123@127.0.0.1:1611
revoke read on obj_test_user_001.view_001 from obj_test_user_002;

--1.3 sequence
create sequence obj_test_user_001.seq_001 start with 100;

conn obj_test_user_002/Root1234@127.0.0.1:1611
select obj_test_user_001.seq_001.nextval from dual;
select obj_test_user_001.seq_001.currval from dual;

conn obj_test_user_001/Root1234@127.0.0.1:1611
grant select on obj_test_user_001.seq_001 to obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
select obj_test_user_001.seq_001.nextval from dual;
select obj_test_user_001.seq_001.currval from dual;

conn obj_test_user_001/Root1234@127.0.0.1:1611
revoke select on obj_test_user_001.seq_001 from obj_test_user_002;

-- 2. insert on table
conn sys/Huawei@123@127.0.0.1:1611
grant insert on obj_test_user_001.tab_001 to obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
insert into obj_test_user_001.tab_001 values (2);

conn sys/Huawei@123@127.0.0.1:1611
revoke insert on obj_test_user_001.tab_001 from obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
insert into obj_test_user_001.tab_001 values (3);

conn sys/Huawei@123@127.0.0.1:1611
grant insert any table to obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
insert into obj_test_user_001.tab_001 values (3);

conn sys/Huawei@123@127.0.0.1:1611
revoke insert any table from obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
insert into obj_test_user_001.tab_001 values (3);

-- 3. update on table
conn sys/Huawei@123@127.0.0.1:1611
grant update on obj_test_user_001.tab_001 to obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
update obj_test_user_001.tab_001 set id=12 where id=2;

conn sys/Huawei@123@127.0.0.1:1611
revoke update on obj_test_user_001.tab_001 from obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
update obj_test_user_001.tab_001 set id=13 where id=3;

conn sys/Huawei@123@127.0.0.1:1611
grant update any table to obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
update obj_test_user_001.tab_001 set id=11 where id=1;

conn sys/Huawei@123@127.0.0.1:1611
revoke update any table from obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
update obj_test_user_001.tab_001 set id=13 where id=3;


-- 4. delete on table
conn sys/Huawei@123@127.0.0.1:1611
grant delete on obj_test_user_001.tab_001 to obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
delete from obj_test_user_001.tab_001 where id=12;

conn sys/Huawei@123@127.0.0.1:1611
revoke delete on obj_test_user_001.tab_001 from obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
delete from obj_test_user_001.tab_001 where id=13;

conn sys/Huawei@123@127.0.0.1:1611
grant delete any table to obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
delete from obj_test_user_001.tab_001 where id=13;

conn sys/Huawei@123@127.0.0.1:1611
revoke delete any table from obj_test_user_002;

conn obj_test_user_002/Root1234@127.0.0.1:1611
delete from obj_test_user_001.tab_001;

-- 5. merge on table
conn sys/Huawei@123@127.0.0.1:1611
grant select on obj_test_user_003.tab_003 to obj_test_user_001;
grant update, insert on obj_test_user_002.tab_002 to obj_test_user_001;

conn obj_test_user_001/Root1234@127.0.0.1:1611
merge into obj_test_user_002.tab_002 using obj_test_user_001.tab_001 on (1=1) when matched then update set id=200 when not matched then insert (id) values (1000);

conn sys/Huawei@123@127.0.0.1:1611
revoke update, insert on obj_test_user_002.tab_002 from obj_test_user_001;

conn obj_test_user_001/Root1234@127.0.0.1:1611
merge into obj_test_user_002.tab_002 using obj_test_user_001.tab_001 on (1=1) when matched then update set id=200 when not matched then insert (id) values (1000);

conn sys/Huawei@123@127.0.0.1:1611
grant update, insert on obj_test_user_002.tab_002 to obj_test_user_001;
revoke select on obj_test_user_003.tab_003 from obj_test_user_001;

conn obj_test_user_001/Root1234@127.0.0.1:1611
merge into obj_test_user_002.tab_002 using obj_test_user_001.tab_001 on (1=1) when matched then update set id=200 when not matched then insert (id) values (1000);

conn sys/Huawei@123@127.0.0.1:1611
revoke update, insert on obj_test_user_002.tab_002 from obj_test_user_001;
revoke select on obj_test_user_003.tab_003 from obj_test_user_001;

-- 6. test grant/revoke operation
create table test_tab_sys_001 (id int);
create table test_tab_sys_002 (id int);
create view test_view_sys as select * from sys.test_tab_sys_001;
create sequence test_seq_sys_001 start with 1000;

grant select, update, insert, delete on test_tab_sys_001 to obj_test_role_001, obj_test_user_004;
grant select, update, insert, delete on test_tab_sys_002 to obj_test_role_001, obj_test_user_004;
grant select, alter on test_seq_sys_001 to obj_test_role_001, obj_test_user_004;
grant all privileges on test_view_sys to obj_test_role_001, obj_test_user_004;

grant obj_test_role_001 to obj_test_user_001, obj_test_role_002, obj_test_role_003;
grant obj_test_role_002 to obj_test_user_002, obj_test_role_004;
grant obj_test_role_003 to obj_test_user_003;

select * from DBA_TAB_PRIVS where GRANTEE like 'OBJ_TEST%' order by GRANTEE, OWNER, OBJECT_NAME, OBJECT_TYPE, PRIVILEGE;
select * from DBA_ROLE_PRIVS order by GRANTEE, GRANTED_ROLE;

conn obj_test_user_004/Root1234@127.0.0.1:1611
select * from USER_TAB_PRIVS order by GRANTEE, OWNER, OBJECT_NAME, OBJECT_TYPE, PRIVILEGE;

conn obj_test_user_002/Root1234@127.0.0.1:1611
insert into sys.test_tab_sys_001 values (10000);
select * from sys.test_tab_sys_001;
select * from sys.test_view_sys;
update sys.test_tab_sys_001 set id=20000;
delete from sys.test_tab_sys_001;
select sys.test_seq_sys_001.currval from dual;
select sys.test_seq_sys_001.nextval from dual;
alter sequence sys.test_seq_sys_001 increment by 2;

conn sys/Huawei@123@127.0.0.1:1611
revoke select, update, insert, delete on test_tab_sys_001 from obj_test_role_001;
revoke all privileges on test_tab_sys_001 from obj_test_role_001;
revoke select on test_view_sys from obj_test_role_001;
revoke all privileges on test_view_sys from obj_test_role_001;
revoke select, alter on test_seq_sys_001 from obj_test_role_001;

conn obj_test_user_002/Root1234@127.0.0.1:1611
insert into sys.test_tab_sys_001 values (10000);
select * from sys.test_tab_sys_001;
select * from sys.test_view_sys;
update sys.test_tab_sys_001 set id=20000;
delete from sys.test_tab_sys_001;
select sys.test_seq_sys_001.currval from dual;
select sys.test_seq_sys_001.nextval from dual;
alter sequence sys.test_seq_sys_001 increment by 2;

conn sys/Huawei@123@127.0.0.1:1611
drop user obj_test_user_004 cascade;
drop role obj_test_role_003;

select * from DBA_TAB_PRIVS where GRANTEE like 'OBJ_TEST%' order by GRANTEE, OWNER, OBJECT_NAME, OBJECT_TYPE, PRIVILEGE;
select * from DBA_ROLE_PRIVS order by GRANTEE, GRANTED_ROLE;

drop table test_tab_sys_001 purge;
drop table test_tab_sys_002;
drop view test_view_sys;
drop sequence test_seq_sys_001;

select * from DBA_TAB_PRIVS where GRANTEE like 'OBJ_TEST%' order by GRANTEE, OWNER, OBJECT_NAME, OBJECT_TYPE, PRIVILEGE;
select * from DBA_ROLE_PRIVS order by GRANTEE, GRANTED_ROLE;

-- 7. privileges to grant/revoke operation
--7.1 grant owned object to others
create table obj_test_user_001.grant_test_tab_001 (id int);
create table obj_test_user_002.grant_test_tab_002 (id int);

conn obj_test_user_001/Root1234@127.0.0.1:1611
grant select on obj_test_user_001.grant_test_tab_001 to obj_test_user_003;

--7.2 has grant any object privilege ?
grant select on obj_test_user_002.grant_test_tab_002 to obj_test_user_003;
conn sys/Huawei@123@127.0.0.1:1611
grant grant any object privilege to obj_test_user_001;

conn obj_test_user_001/Root1234@127.0.0.1:1611
grant select on obj_test_user_002.grant_test_tab_002 to obj_test_user_003;

conn sys/Huawei@123@127.0.0.1:1611
revoke grant any object privilege from obj_test_user_001;

--7.3 has granted object privilege with grant option ?
conn obj_test_user_002/Root1234@127.0.0.1:1611
grant select on obj_test_user_002.grant_test_tab_002 to obj_test_user_001 with grant option;

conn obj_test_user_001/Root1234@127.0.0.1:1611
grant select on obj_test_user_002.grant_test_tab_002 to obj_test_user_003;

--7.4 check grant/revoke all privileges 
grant all privileges on obj_test_user_002.grant_test_tab_002 to obj_test_user_003;

conn obj_test_user_002/Root1234@127.0.0.1:1611
grant all privileges on obj_test_user_002.grant_test_tab_002 to obj_test_user_001 with grant option;

conn obj_test_user_001/Root1234@127.0.0.1:1611
grant all privileges on obj_test_user_002.grant_test_tab_002 to obj_test_user_003;

-- 8. check alter password privilege
alter user obj_test_user_002 identified by root_new_1234 replace Root1234;
alter user obj_test_user_001 identified by root_new_1234 replace Root1234;

-- 9. check alter user to other's user
conn obj_test_user_001/root_new_1234@127.0.0.1:1611
alter user obj_test_user_002 identified by root_new_1234 replace Root1234;
alter user obj_test_user_002 PASSWORD EXPIRE;
alter user obj_test_user_002 ACCOUNT  LOCK;
alter user obj_test_user_002 ACCOUNT  UNLOCK;

conn sys/Huawei@123@127.0.0.1:1611
alter user obj_test_user_002 identified by root_new_1234 replace Root1234;
alter user obj_test_user_002 identified by Root1234 replace root_new_1234;
alter user obj_test_user_002 ACCOUNT  LOCK;
alter user obj_test_user_002 ACCOUNT  UNLOCK;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists obj_test_user_001 cascade;
drop user if exists obj_test_user_002 cascade;
drop user if exists obj_test_user_003 cascade;
drop user if exists obj_test_user_004 cascade;

drop role obj_test_role_001;
drop role obj_test_role_002;
drop role obj_test_role_003;
drop role obj_test_role_004;

select * from DBA_TAB_PRIVS where GRANTEE like 'OBJ_TEST%' order by GRANTEE, OWNER, OBJECT_NAME, OBJECT_TYPE, PRIVILEGE;
select * from DBA_ROLE_PRIVS order by GRANTEE, GRANTED_ROLE;

-- trigger & procedure

--1. user A create a trigger T (in schema A) on table C (C in Schema A) : CREATE TRIGGER
drop user if exists user_a cascade;
drop user if exists user_b cascade;
drop user if exists user_1 cascade;
drop user if exists user_2 cascade;

create user user_a identified by Root1234;
grant create session to user_a;
grant create table to user_a;
connect user_a/Root1234@127.0.0.1:1611
create table tbl_a (f1 int, f2 varchar(30));

-- create trigger failed: need create trigger privilege
create or replace trigger tr_a
    before insert
    on tbl_a
    for each row
    begin
        select 1 into :new.f2 from dual;
    end;
/
conn / as sysdba
grant create trigger to user_a;
connect user_a/Root1234@127.0.0.1:1611

create or replace trigger tr_a
    before insert
    on tbl_a
    for each row
    begin
        select 1 into :new.f2 from dual;
    end;
/


--2. user A create a trigger T (in schema A) on table C (C in Schema B) : CREATE ANY TRIGGER
conn / as sysdba
create user user_b identified by Root1234;
create table user_b.tbl_b (f1 int, f2 varchar(30));
connect user_a/Root1234@127.0.0.1:1611

-- create trigger failed: need create any trigger privilege
create or replace trigger tr_a_02
    before insert
    on user_b.tbl_b
    for each row
    begin
        select 1 into :new.f2 from dual;
    end;
/

conn / as sysdba
grant create any trigger to user_a;

connect user_a/Root1234@127.0.0.1:1611

-- create trigger succeed
create or replace trigger tr_a_02
    before insert
    on user_b.tbl_b
    for each row
    begin
        select 1 into :new.f2 from dual;
    end;
/

-- 3. user A create a trigger T (in schema B) on table C (C in Schema A) : CREATE ANY TRIGGER
conn / as sysdba
revoke create any trigger from user_a;

connect user_a/Root1234@127.0.0.1:1611

-- create trigger failed: need create any trigger privilege
create or replace trigger user_b.tr_b_01
    before insert
    on user_a.tbl_a
    for each row
    begin
        select 1 into :new.f2 from dual;
    end;
/

conn / as sysdba
grant create any trigger to user_a;

connect user_a/Root1234@127.0.0.1:1611
-- create trigger succeed
create or replace trigger user_b.tr_b_01
    before insert
    on user_a.tbl_a
    for each row
    begin
        select 1 into :new.f2 from dual;
    end;
/

-- 4. user A create a trigger T (in schema B) on table C (C in Schema B) : CREATE ANY TRIGGER
conn / as sysdba
revoke create any trigger from user_a;

connect user_a/Root1234@127.0.0.1:1611

-- create trigger failed: need create any trigger privilege
create or replace trigger user_b.tr_b_01
    before insert
    on user_b.tbl_b
    for each row
    begin
        select 1 into :new.f2 from dual;
    end;
/

conn / as sysdba
grant create any trigger to user_a;

connect user_a/Root1234@127.0.0.1:1611

-- create trigger succeed
create or replace trigger user_b.tr_b_02
    before insert
    on user_b.tbl_b
    for each row
    begin
        select 1 into :new.f2 from dual;
    end;
/

-- failed, invalid name
create or replace trigger user_b.a@432^%*~!<>
    before insert
    on user_b.tbl_b
    for each row
    begin
        select 1 into :new.f2 from dual;
    end;
/

-- 5 procedure
connect / as sysdba
create user user1 identified by Root1234;
grant create session, create table to user1;
connect user1/Root1234@127.0.0.1:1611

-- failed
create or replace procedure pro_a
as
	v_tblName varchar2(30);
begin
	v_tblName := 'abc';
	dbe_output.print_line(to_char(sysdate,'yyyy-mm-dd HH24:MI:SS') || '>>process table:' || v_tblName || ' end');
end;
/

conn / as sysdba
grant create procedure to user1;
connect user1/Root1234@127.0.0.1:1611
-- succeed
create or replace procedure pro_a
as
	v_tblName varchar2(30);
begin
	v_tblName := 'abc';
	dbe_output.print_line(to_char(sysdate,'yyyy-mm-dd HH24:MI:SS') || '>>process table:' || v_tblName || ' end');
end;
/

conn / as sysdba
revoke create procedure from user1;
connect user1/Root1234@127.0.0.1:1611
-- failed
create or replace procedure pro_a
as
	v_tblName varchar2(30);
begin
	v_tblName := 'abc';
	dbe_output.print_line(to_char(sysdate,'yyyy-mm-dd HH24:MI:SS') || '>>process table:' || v_tblName || ' end');
end;
/

-- create any procedure
connect / as sysdba
create user user2 identified by Root1234;
conn user1/Root1234@127.0.0.1:1611

-- failed
create or replace procedure user2.pro_a
as
	v_tblName varchar2(30);
begin
	v_tblName := 'abc';
	dbe_output.print_line(to_char(sysdate,'yyyy-mm-dd HH24:MI:SS') || '>>process table:' || v_tblName || ' end');
end;
/

conn / as sysdba
grant create procedure to user1;
conn user1/Root1234@127.0.0.1:1611
-- failed
create or replace procedure user2.pro_a
as
	v_tblName varchar2(30);
begin
	v_tblName := 'abc';
	dbe_output.print_line(to_char(sysdate,'yyyy-mm-dd HH24:MI:SS') || '>>process table:' || v_tblName || ' end');
end;
/

conn / as sysdba
grant create any procedure to user1;
conn user1/Root1234@127.0.0.1:1611
-- succeed
create or replace procedure user2.pro_a
as
	v_tblName varchar2(30);
begin
	v_tblName := 'abc';
	dbe_output.print_line(to_char(sysdate,'yyyy-mm-dd HH24:MI:SS') || '>>process table:' || v_tblName || ' end');
end;
/

conn / as sysdba
revoke create any procedure from user1;
conn user1/Root1234@127.0.0.1:1611
-- failed
create or replace procedure user2.pro_a
as
	v_tblName varchar2(30);
begin
	v_tblName := 'abc';
	dbe_output.print_line(to_char(sysdate,'yyyy-mm-dd HH24:MI:SS') || '>>process table:' || v_tblName || ' end');
end;
/

-- check drop procedure privileges
drop procedure pro_a; -- succeed
drop procedure user2.pro_a; -- failed

connect / as sysdba
grant drop any procedure to user1;
drop procedure user2.pro_a; -- succeed

-- check drop trigger privileges
connect user_a/Root1234@127.0.0.1:1611
drop trigger user_a.tr_a;    -- succeed
drop trigger user_a.tr_a_02; -- succeed
drop trigger user_b.tr_b_01; -- failed

connect / as sysdba
grant drop any trigger to user_a;
connect user_a/Root1234@127.0.0.1:1611
drop trigger user_b.tr_b_01; -- succeed

conn / as sysdba
drop user user1 cascade;
drop user user2 cascade;
drop user user_a cascade;
drop user user_b cascade;

-- check with grant option
-- 1. create user and table
create user user1 identified by 'cantian_234';
create user user2 identified by 'cantian_234';
create user user3 identified by 'cantian_234';
grant create session, create table to user1, user2, user3;

connect user1/cantian_234@127.0.0.1:1611
drop table if exists all_type_tb;
create table all_type_tb(id int, c_varchar varchar(10));
insert into all_type_tb values(1,'xian');
commit;

-- 2. grant to user2 without grant option
connect user1/cantian_234@127.0.0.1:1611
grant select on user1.all_type_tb to user2;

-- 3. grant to user2 with grant option
connect user1/cantian_234@127.0.0.1:1611
grant select on user1.all_type_tb to user2 with grant option;

-- 4. grant to user3, expect succeed.
connect user2/cantian_234@127.0.0.1:1611
grant select on user1.all_type_tb to user3;

connect / as sysdba
drop user user1 cascade;
drop user user2 cascade;
drop user user3 cascade;

-- check whether the privilege type is allowed for the object
connect sys/Huawei@123@127.0.0.1:1611
create user user1 identified by 'cantian_234';
create user user2 identified by 'cantian_234';
grant create session, create sequence, create view, create table to user1, user2;

connect user1/cantian_234@127.0.0.1:1611

drop table if exists all_type_tb purge;
create table all_type_tb (
  id int,
  c_varchar varchar(10)
);

drop view if exists all_type_tb_v;
create view all_type_tb_v as select * from dual;

create sequence WGO_SEQ MINVALUE 1 MAXVALUE 9223372036854775807;

-- execute is not allowed for table
grant execute on all_type_tb to user2 with grant option;

-- execute/alter/index is not allowed for view
grant execute on all_type_tb_v to user2 with grant option;
grant alter   on all_type_tb_v to user2 with grant option;
grant index   on all_type_tb_v to user2 with grant option;

-- execute/index/update/delete/read/references is not allowed for sequence
grant execute on user1.WGO_SEQ to user2 with grant option;
grant index on user1.WGO_SEQ to user2 with grant option;
grant update on user1.WGO_SEQ to user2 with grant option;
grant delete on user1.WGO_SEQ to user2 with grant option;
grant read on user1.WGO_SEQ to user2 with grant option;
grant references on user1.WGO_SEQ to user2 with grant option;

connect sys/Huawei@123@127.0.0.1:1611
drop user user1 cascade;
drop user user2 cascade;

-- check grant role to user/role
create user user1 identified by cantian_234;
create user user2 identified by cantian_234;
grant create session, create sequence, create table to user1, user2;

connect user1/cantian_234@127.0.0.1:1611
create sequence WGO_SEQ MINVALUE 1 MAXVALUE 9223372036854775807;
create table t_001 (id int);
grant select, alter on user1.WGO_SEQ to user2 with grant option;
grant select, insert on t_001 to user2;
insert into t_001 values (100);

connect user2/cantian_234@127.0.0.1:1611
select user1.WGO_SEQ.nextval from dual;
insert into user1.t_001 values (200);
select * from user1.t_001;

connect sys/Huawei@123@127.0.0.1:1611
grant connect, resource to public;

connect user2/cantian_234@127.0.0.1:1611
select user1.WGO_SEQ.nextval from dual;
insert into user1.t_001 values (200);
select * from user1.t_001;

connect user1/cantian_234@127.0.0.1:1611
drop sequence WGO_SEQ;

connect sys/Huawei@123@127.0.0.1:1611
create role role_001;
grant delete on user1.t_001 to user2;
grant role_001 to user2;

connect user2/cantian_234@127.0.0.1:1611
delete from user1.t_001;
select * from user1.t_001;

connect sys/Huawei@123@127.0.0.1:1611
drop user user1 cascade;
drop user user2 cascade;
drop role role_001;
revoke connect, resource from public;

-- grant execute on user1.procedure/function/package to user2;
create user user_a identified by Root1234;
create user user_b identified by Root1234;

grant connect, create procedure, create table to user_a;
grant connect, create table to user_b;

conn user_a/Root1234@127.0.0.1:1611
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
 End;
/

CREATE OR REPLACE PROCEDURE Zenith_Test_004(param1 out varchar2)
IS
    tmp varchar2(20) :='12345678';
begin
 param1:=param1||tmp;
end Zenith_Test_004;
/

-- grant invalid privilege on procedure/function, failed.
grant select on Zenith_Test_Sysdate to user_b;
grant insert on Zenith_Test_Sysdate to user_b;
grant update on Zenith_Test_Sysdate to user_b;
grant delete on Zenith_Test_Sysdate to user_b;
grant references on Zenith_Test_Sysdate to user_b;
grant index on Zenith_Test_Sysdate to user_b;
grant read on Zenith_Test_Sysdate to user_b;

grant select on Zenith_Test_004 to user_b;
grant insert on Zenith_Test_004 to user_b;
grant update on Zenith_Test_004 to user_b;
grant delete on Zenith_Test_004 to user_b;
grant references on Zenith_Test_004 to user_b;
grant index on Zenith_Test_004 to user_b;
grant read on Zenith_Test_004 to user_b;

-- grant execute to user
grant execute on Zenith_Test_Sysdate to user_b;  -- succeed
grant all on Zenith_Test_004 to user_b;  -- succeed

conn user_b/Root1234@127.0.0.1:1611
select * from user_tab_privs order by OBJECT_NAME; -- 2 rows

select user_a.Zenith_Test_Sysdate() from dual;

Declare
    v_char1 char(9) :='A';
begin
    user_a.Zenith_Test_004(v_char1);
    dbe_output.print_line('OUT PUT RESULT:'||v_char1);
end;
/

conn user_a/Root1234@127.0.0.1:1611
revoke execute on Zenith_Test_Sysdate from user_b; -- succeed
revoke all on Zenith_Test_004 from user_b;  -- succeed

conn user_b/Root1234@127.0.0.1:1611
select * from user_tab_privs order by OBJECT_NAME; -- 0 rows
-- no privilege
select user_a.Zenith_Test_Sysdate() from dual;

Declare
    v_char1 char(9) :='A';
begin
    user_a.Zenith_Test_004(v_char1);
    dbe_output.print_line('OUT PUT RESULT:'||v_char1);
end;
/

conn / as sysdba

-- test truncate table privilege
drop table if exists user_b.test_truncate_tab;
create table user_b.test_truncate_tab(f1 int, f2 varchar2(30));
create synonym user_a.truncate_tab_syn for user_b.test_truncate_tab;
insert into user_b.test_truncate_tab values (1, 'wangzherongyao');

conn user_a/Root1234@127.0.0.1:1611
truncate table truncate_tab_syn; -- no privilege

conn / as sysdba
grant drop any table to user_a;

conn user_a/Root1234@127.0.0.1:1611
truncate table truncate_tab_syn; -- succeed

conn / as sysdba
select * from user_b.test_truncate_tab; -- 0 rows

conn user_a/Root1234@127.0.0.1:1611
create or replace procedure sp1
as
begin
 dbe_output.print_line('test');
end;
/

exec sp1;
grant all on sp1 to user_b;

conn user_b/Root1234@127.0.0.1:1611
select * from user_tab_privs;
exec sp1;  -- error
exec user_a.sp1;

conn user_a/Root1234@127.0.0.1:1611
create table user_a_tab(id int not null);
create table user_a_tab_1(id int not null);
alter table user_a_tab add constraint pk_1 primary key (id);
alter table user_a_tab_1 add constraint fk_2 foreign key (id) references user_a.user_a_tab(id); -- succeed

conn user_b/Root1234@127.0.0.1:1611
create table user_b_tab(id int not null);
create table user_b_tab_1(id int not null);
alter table user_b_tab_1 add constraint pk_2 primary key (id);
alter table user_b_tab add constraint fk_1 foreign key (id) references user_a.user_a_tab(id); -- failed

conn user_a/Root1234@127.0.0.1:1611
grant references on user_a_tab to user_b;

conn user_b/Root1234@127.0.0.1:1611
alter table user_b_tab add constraint fk_1 foreign key (id) references user_a.user_a_tab(id); -- succeed

conn / as sysdba
alter table user_a.user_a_tab_1 add constraint fk_3 foreign key (id) references user_b.user_b_tab_1(id); -- failed, user_a has no references privilege on user_b.user_b_tab_1

drop user user_a cascade;
drop user user_b cascade;

create user whf identified by Whf00174302;
create or replace procedure whf.ccc(a int, b int)
as
begin
null;
end;
/
drop user whf cascade;

create user whf identified by Whf00174302;
create or replace procedure whf.ccc(a int, b int)
as
begin
null;
end;
/
drop user whf cascade;

-- test grant/revoke privilege from self.
drop user if exists c_00218870 cascade;
create user c_00218870 identified by Root1234;
create table c_00218870.tab_001 (f1 int);
grant connect, create table to c_00218870 with admin option;

grant delete on c_00218870.tab_001 to c_00218870;  -- succeed
revoke delete on c_00218870.tab_001 from c_00218870; -- failed

conn c_00218870/Root1234@127.0.0.1:1611
--revoke object privilege
grant delete on c_00218870.tab_001 to c_00218870;  -- succeed
revoke delete on c_00218870.tab_001 from c_00218870; -- failed
revoke all privileges on c_00218870.tab_001 from c_00218870; -- failed

--revoke system privilege
revoke create table from c_00218870; -- succeed
create table tab_002 (f1 int);  -- failed

conn / as sysdba
drop user c_00218870 cascade;

-- test: check drop any index / drop any sequence privilege
create user session_schema_001 identified by Cantian_234;
grant create session, alter session to session_schema_001;

-- create table
drop table if exists test_001 purge;
create table test_001(i int);
create index test_001_index on test_001(i);
insert into test_001 values(1);

-- create sequence
drop sequence if exists seq_001;
create sequence seq_001 start with 1000;

conn session_schema_001/Cantian_234@127.0.0.1:1611
alter session set current_schema=sys;

drop index  test_001_index on test_001; -- no privilege
drop sequence seq_001;      -- no privilege

conn / as sysdba
grant drop any index, drop any sequence to session_schema_001;

conn session_schema_001/Cantian_234@127.0.0.1:1611
alter session set current_schema=sys;
drop index  test_001_index on test_001; 
drop sequence seq_001;      

conn / as sysdba
drop table test_001 purge;

-- test : synonym
drop table if exists test_schema_001 purge;
create table test_schema_001(i int);
insert into test_schema_001 values(1);

create or replace public synonym test_schema_sy for test_schema_001;
grant select on test_schema_sy to session_schema_001; -- succeed

conn session_schema_001/Cantian_234@127.0.0.1:1611
select * from sys.test_schema_001;  -- 1 row

conn / as sysdba
drop table test_schema_001 purge;
drop public synonym test_schema_sy force;

-- test : add/enable check constraint
grant create any table, alter any table to session_schema_001;

conn session_schema_001/Cantian_234@127.0.0.1:1611
alter session set current_schema=sys;
create table test_zlj(i int);
alter table test_zlj add constraint test_zlj_con check(i<10); 

conn / as sysdba
drop table test_zlj purge;
drop user session_schema_001 cascade;

-- test : can not revoke system privilege from SYS and DBA
revoke create session from sys; -- failed
revoke create session from DBA; -- failed
create user user_priv_revoke identified by Root1234;
grant all to user_priv_revoke;
conn user_priv_revoke/Root1234@127.0.0.1:1611
revoke create session from sys; -- failed
revoke create session from DBA; -- failed
create table tab_001 (f1 int);
grant all on tab_001 to sys;
revoke all on tab_001 from sys;
revoke select on tab_001 from sys;

conn / as sysdba


--test : cascading recycling of permissions
connect sys/Huawei@123@127.0.0.1:1611
drop user if exists myuser_crp1;
drop user if exists myuser_crp2;
drop user if exists myuser_crp3;
drop table if exists mytable_crp;
create  user myuser_crp1 identified by Mypwd123;
create  user myuser_crp2 identified by Mypwd123;
create  user myuser_crp3 identified by Mypwd123;
grant create session to myuser_crp1,myuser_crp2,myuser_crp3;
create table mytable_crp(id int);
grant select,insert on mytable_crp to myuser_crp1 with grant option;
conn myuser_crp1/Mypwd123@127.0.0.1:1611
select * from sys.mytable_crp;
grant select,insert on sys.mytable_crp to myuser_crp2 with grant option;
conn myuser_crp2/Mypwd123@127.0.0.1:1611
select * from sys.mytable_crp;
grant select,insert on sys.mytable_crp to myuser_crp3;
connect sys/Huawei@123@127.0.0.1:1611
revoke select on sys.mytable_crp from myuser_crp1;
conn myuser_crp1/Mypwd123@127.0.0.1:1611
select * from sys.mytable_crp;
conn myuser_crp2/Mypwd123@127.0.0.1:1611
select * from sys.mytable_crp;
conn myuser_crp3/Mypwd123@127.0.0.1:1611
select * from sys.mytable_crp;
connect sys/Huawei@123@127.0.0.1:1611
drop user myuser_crp1;
conn myuser_crp2/Mypwd123@127.0.0.1:1611
insert into sys.mytable_crp values(1);
conn myuser_crp3/Mypwd123@127.0.0.1:1611
insert into sys.mytable_crp values(1);
conn / as sysdba
drop table mytable_crp;
drop user myuser_crp2;
drop user myuser_crp3;

-- test : if add new privilege items.
-- WARNING: if you add a new privilege in sys_privs_id, you should also add it for the views. otherwise 'UNKOWN' will be presented.
-- DBA_SYS_PRIVS
-- ALL_USER_SYS_PRIVS
-- ROLE_SYS_PRIVS
-- USER_SYS_PRIVS
select count(*) from dba_sys_privs where privilege='UNKOWN'; -- expect 0 row
grant UNDER ANY VIEW, UNLIMITED TABLESPACE, UPDATE ANY TABLE to user_priv_revoke; -- expect succeed
drop user user_priv_revoke cascade;

-- test : user granted DBA role can alter user's password
create user alter_passwd_user_1 identified by Cantian_234;
create user alter_passwd_user_2 identified by Cantian_234;

grant create session to alter_passwd_user_1;
grant create session to alter_passwd_user_2;
conn alter_passwd_user_1/Cantian_234@127.0.0.1:1611
alter user alter_passwd_user_2 identified by Cantian_123 replace Cantian_234; -- failed, insufficient privilege

conn / as sysdba
grant dba to alter_passwd_user_1;

conn alter_passwd_user_1/Cantian_234@127.0.0.1:1611
alter user alter_passwd_user_2 identified by Cantian_123 replace Cantian_234; -- succeed

-- succeed
conn alter_passwd_user_2/Cantian_123@127.0.0.1:1611

conn / as sysdba
revoke dba from alter_passwd_user_1;
conn alter_passwd_user_1/Cantian_234@127.0.0.1:1611
alter user alter_passwd_user_2 identified by Cantian_123 replace Cantian_234; -- failed, insufficient privilege

conn / as sysdba
drop user alter_passwd_user_2;
drop user alter_passwd_user_1;

--DTS2018110601533
conn / as sysdba
create user DTS2018110601533 identified by 'Changeme_123';
grant create session to DTS2018110601533;
grant create any table to DTS2018110601533;
conn DTS2018110601533/Changeme_123@127.0.0.1:1611
create table test2018110601533(result VARCHAR(2048));
insert into test2018110601533 values('zhangsan');
truncate table test2018110601533;
conn / as sysdba
drop user DTS2018110601533 cascade;

--DTS2018110106116
create user DTS2018110106116 identified by 'Changeme_123';
grant create session, on commit refresh, create table to DTS2018110106116;
select * from dba_sys_privs where grantee = 'DTS2018110106116' order by privilege;
revoke create session, on commit refresh, create table from DTS2018110106116;
select * from dba_sys_privs where grantee = 'DTS2018110106116' order by privilege;
grant abc on commit refresh to DTS2018110106116; -- failed
grant on commit refrexxx to DTS2018110106116; -- failed
grant on commit refresh abc to DTS2018110106116; -- failed
grant on commit refresh to DTS2018110106116; -- succeed
revoke on commit refresh from DTS2018110106116; -- succeed
grant select on sys.SYS_TABLES to DTS2018110106116; -- succeed
revoke select on sys.SYS_TABLES from DTS2018110106116; -- succeed
drop user DTS2018110106116;

--DTS2018111203122
create user DTS2018111203122 identified by Changeme_123;
grant create session to DTS2018111203122;
grant select, update, insert, alter, delete on sys.SYS_PROFILE to DTS2018111203122 with grant option;
conn DTS2018111203122/Changeme_123@127.0.0.1:1611
revoke select, update, insert, alter, delete on sys.SYS_PROFILE from sys; -- failed
grant select, update, insert, alter, delete on sys.SYS_PROFILE to sys; -- succeed
revoke select, update, insert, alter, delete on sys.SYS_PROFILE from sys; -- failed
conn / as sysdba
drop user DTS2018111203122;

-- test: create view. DTS2018120606854
create user test_cr_view_001 identified by Root1234;
create user test_cr_view_002 identified by Root1234;
grant create view, create session to test_cr_view_001, test_cr_view_002;
grant select any table to test_cr_view_002;

create table test_cr_view_002.tab_001(f1 int);
grant select on sys.SYS_TABLES to test_cr_view_002;
create view test_cr_view_002.view_001 as select * from sys.SYS_TABLES;
grant SELECT on test_cr_view_002.view_001 to test_cr_view_001;
revoke select any table from test_cr_view_002;
revoke select on sys.SYS_TABLES from test_cr_view_002;
conn test_cr_view_001/Root1234@127.0.0.1:1611
-- should has the privilege to create a view based on SYS's public objects
create or replace view sysobjects as
select object_name as name, object_name as id, CREATED as crdate, owner,
case object_type when 'TABLE' then 'U'
                 when 'VIEW' then 'V'
                 when 'TRIGGER' then 'TR'
                 when 'PROCEDURE' then 'P'
                 else 'D' end as type
from all_objects where instr(',SEQUENCE,PROCEDURE,TRIGGER,TABLE,VIEW,FUNCTION,',','||object_type||',')>0
/

-- no privilege, because test_cr_view_001 has no SELECT privilege of test_cr_view_002.tab_001
create view test_no_pri_001 as select * from test_cr_view_002.tab_001;

-- no privilege, because test_cr_view_002 has no SELECT privilege of SYS.SYS_TABLES
create view test_no_pri_002 as select * from test_cr_view_002.view_001;

conn / as sysdba
drop user test_cr_view_001 cascade;
drop user test_cr_view_002 cascade;

-- DTS2018120406187
drop role DBA;

-- 	DTS2018120309726
drop user if exists user1;
drop user if exists user2;
create user user1 identified by Changeme_123;
create user user2 identified by Changeme_123;
create table user1.tab_001(f1 int);

grant select on user1.tab_001 to user2;
grant create session to user1.user2;
conn user1/Changeme_123@127.0.0.1:1611
conn user2/Changeme_123@127.0.0.1:1611

conn / as sysdba
grant create session to user1, user2;
revoke create session from user1.user2;
revoke create session from user1, user2;
revoke select on user1.tab_001 from user2;
drop user user1 cascade;
drop user user2 cascade;

-- DTS2018120309012
create user " ";
create user " " identified by Cantian_123;
create user "123&" identified by Cantian_123;
create user "123|" identified by Cantian_123;
create user "123;" identified by Cantian_123;
create user "123`" identified by Cantian_123;
create user "123$" identified by Cantian_123;
create user "123&" identified by Cantian_123;
create user "123>" identified by Cantian_123;
create user "123<" identified by Cantian_123;
create user "123\"" identified by Cantian_123;
create user "123'" identified by Cantian_123;
create user "123!" identified by Cantian_123;

create role " ";
create role " " identified by Cantian_123;
create role "123&" identified by Cantian_123;
create role "123|" identified by Cantian_123;
create role "123;" identified by Cantian_123;
create role "123`" identified by Cantian_123;
create role "123$" identified by Cantian_123;
create role "123&" identified by Cantian_123;
create role "123>" identified by Cantian_123;
create role "123<" identified by Cantian_123;
create role "123\"" identified by Cantian_123;
create role "123'" identified by Cantian_123;
create role "123!" identified by Cantian_123;
conn sys/Huawei@123@127.0.0.1:1611
create user cjb01 identified by cao102_cao;
create user cjb02 identified by cao102_cao;
grant connect to cjb01;
grant connect to cjb02;
grant create any table to cjb01;
grant create any table to cjb02;
conn cjb01/cao102_cao@127.0.0.1:1611
create table cjb02.test (id int);
create table sys.test01 (id int);
conn sys/Huawei@123@127.0.0.1:1611
create table cjb02.test1 (id int); 
create user cjb001 identified by hello_123;
grant connect to cjb001;
grant create table to cjb001;
grant create any view to cjb001;
grant drop any table to cjb001;
conn cjb001/hello_123@127.0.0.1:1611
create table bigbao(id int);
insert into bigbao values (1);
commit;
create or replace view sys.DBA_TABLES as select * from bigbao;
drop view SYS.USER_TAB_PARTITIONS ;
conn sys/Huawei@123@127.0.0.1:1611
drop user cjb001 cascade;
drop user cjb01 cascade;
drop user cjb02 cascade;

-- DTS2018122010672
create user user11220_1 identified by Cantian_234;
grant create session,create table to user11220_1;
create user user11220_2 identified by Cantian_234;
create user user11220_3 identified by Cantian_234;
grant create session to user11220_2, user11220_3;

conn user11220_1/Cantian_234@127.0.0.1:1611
create table user11220_1_1(ID int);
grant select on user11220_1_1 to user11220_2, user11220_3;

conn user11220_2/Cantian_234@127.0.0.1:1611
select ID from user11220_1.user11220_1_1;

conn user11220_1/Cantian_234@127.0.0.1:1611
alter table user11220_1_1 rename to user11220_1_abcd;

-- has privilege
conn user11220_2/Cantian_234@127.0.0.1:1611
select ID from user11220_1.user11220_1_abcd;

-- has privilege
conn user11220_3/Cantian_234@127.0.0.1:1611
select ID from user11220_1.user11220_1_abcd;

conn sys/Huawei@123@127.0.0.1:1611
drop user user11220_1 cascade;
drop user user11220_2 cascade;
drop user user11220_3 cascade;

-- DTS2019010504482	
drop user if exists FVT_Security_Penetration_Testing_150_1 cascade;
create user FVT_Security_Penetration_Testing_150_1 identified by Cantian_234;

drop user if exists FVT_Security_Penetration_Testing_150_2 cascade;
create user FVT_Security_Penetration_Testing_150_2 identified by Cantian_234;

grant all to FVT_Security_Penetration_Testing_150_1;
grant connect to FVT_Security_Penetration_Testing_150_2;
grant CREATE TABLE to FVT_Security_Penetration_Testing_150_2;
grant CREATE VIEW to FVT_Security_Penetration_Testing_150_2;

conn FVT_Security_Penetration_Testing_150_1/Cantian_234@127.0.0.1:1611
DROP TABLE IF EXISTS FVT_Security_Penetration_Testing_150_table1;
CREATE TABLE FVT_Security_Penetration_Testing_150_table1(staff_id INT PRIMARY KEY, privilege_name VARCHAR(64) NOT NULL, privilege_description VARCHAR(64), privilege_approver VARCHAR(10));
-- expect succeed
CREATE OR REPLACE VIEW FVT_Security_Penetration_Testing_150_view1 AS SELECT staff_id, privilege_name from FVT_Security_Penetration_Testing_150_table1;

conn FVT_Security_Penetration_Testing_150_2/Cantian_234@127.0.0.1:1611
-- expect failed
CREATE TABLE FVT_Security_Penetration_Testing_150_table2 as select * from FVT_Security_Penetration_Testing_150_1.FVT_Security_Penetration_Testing_150_view1;
DROP TABLE IF EXISTS FVT_Security_Penetration_Testing_150_table2;
CREATE TABLE FVT_Security_Penetration_Testing_150_table2 as select * from FVT_Security_Penetration_Testing_150_1.FVT_Security_Penetration_Testing_150_table1;

conn sys/Huawei@123@127.0.0.1:1611
drop user FVT_Security_Penetration_Testing_150_1 cascade;
drop user FVT_Security_Penetration_Testing_150_2 cascade;

--DTS2019010802802,DTS2019011504629
select * from ROLE_SYS_PRIVS order by ROLE, PRIVILEGE;
create user DTS2019010802802 identified by Root1234;
grant connect to DTS2019010802802;
grant select on DBA_SYS_PRIVS to DTS2019010802802;
create role role_test_0001;
grant create table to role_test_0001;

conn DTS2019010802802/Root1234@127.0.0.1:1611
select * from ROLE_SYS_PRIVS order by ROLE, PRIVILEGE; -- connect only
select * from DBA_SYS_PRIVS where grantee = 'ROLE_TEST_0001'; -- 1 row, include ROLE_TEST_0001

conn sys/Huawei@123@127.0.0.1:1611
grant dba to DTS2019010802802;
conn DTS2019010802802/Root1234@127.0.0.1:1611
select * from ROLE_SYS_PRIVS order by ROLE, PRIVILEGE; -- all roles;

conn sys/Huawei@123@127.0.0.1:1611
drop user DTS2019010802802;
drop role role_test_0001;

-- ST1224-530 : system package privilege check
create user package_check identified by Root1234;
grant create session to package_check;
grant resource to package_check;

conn package_check/Root1234@127.0.0.1:1611

-- create job procedure
create or replace procedure job_package_check_t
as
  cnt int;
begin
 select count(1) into cnt from dual;
 commit;
end job_package_check_t;
/

-- submit the job, expect failed, no privileges
declare
 jobno number;
begin
 DBE_TASK.SUBMIT(jobno,'begin job_package_check_t();end;', sysdate, 'sysdate+0.5/24/60');
 commit;
end;
/

conn sys/Huawei@123@127.0.0.1:1611
grant execute on DBE_TASK to package_check;

conn package_check/Root1234@127.0.0.1:1611

-- submit the job, expect succeed
declare
 jobno number;
begin
 DBE_TASK.SUBMIT(jobno,'begin job_package_check_t();end;', sysdate + 1/24, 'sysdate+0.5/24/60');
 commit;
end;
/

-- common user has privilege to execute DBE_OUTPUT package function.
exec dbe_output.print_line('abc');

conn sys/Huawei@123@127.0.0.1:1611
revoke execute on DBE_TASK from package_check;
grant dba to package_check;

conn package_check/Root1234@127.0.0.1:1611

declare
 jobno int;
begin
 select job into jobno from all_jobs where what='begin job_package_check_t();end;';
--expect success 
 DBE_TASK.CANCEL(jobno);
 commit;
end;
/

conn sys/Huawei@123@127.0.0.1:1611
drop user package_check cascade;

-- DTS2019040109911
create user FVT_Security_User_privilege_146_1 identified by Cantian_234;
grant create session,CREATE ANY TABLE,create any PROCEDURE to FVT_Security_User_privilege_146_1;

create user FVT_Security_User_privilege_146_2 identified by Cantian_234;
grant create session,EXECUTE ANY PROCEDURE to FVT_Security_User_privilege_146_2;

conn FVT_Security_User_privilege_146_1/Cantian_234@127.0.0.1:1611
create table FVT_Security_User_privilege_146_1(ID int,name varchar(50));
create table FVT_Security_User_privilege_146_2.FVT_Security_User_privilege_146_2(ID int,name varchar(50));
create or replace procedure procedure_FVT_Security_User_privilege_146_1 is
    v_sql varchar(1023);
begin
    v_sql := 'insert into FVT_Security_User_privilege_146_1 values(100,''xiaoming'')';
    execute immediate v_sql;
    commit;
end procedure_FVT_Security_User_privilege_146_1;
/

create or replace procedure procedure_FVT_Security_User_privilege_146_1_1  is
begin
    insert into FVT_Security_User_privilege_146_1 values(100,'xiaoxiao');
    commit;
end procedure_FVT_Security_User_privilege_146_1_1;
/

conn FVT_Security_User_privilege_146_2/Cantian_234@127.0.0.1:1611
exec FVT_Security_User_privilege_146_1.procedure_FVT_Security_User_privilege_146_1;
exec FVT_Security_User_privilege_146_1.procedure_FVT_Security_User_privilege_146_1_1;

conn sys/Huawei@123@127.0.0.1:1611
drop user FVT_Security_User_privilege_146_1 cascade;
drop user FVT_Security_User_privilege_146_2 cascade;

-- DTS2019041012706
create user grant_max_user identified by Root1234;
create role grant_max_role;

declare
    tab_cnt int;
    v_sql varchar(1023);
begin
    for tab_cnt in 1 .. 2049 loop
        v_sql := 'drop table if exists table_' || tab_cnt;
        execute immediate v_sql;
        v_sql := 'create table table_' || tab_cnt || '(f1 int)';
        execute immediate v_sql;
    end loop;
end;
/

declare
    grant_num int;
    v_sql varchar(1023);
begin
    for grant_num in 1 .. 2049 loop
        v_sql := 'grant all on table_' || grant_num || ' to grant_max_user';
        execute immediate v_sql;
    end loop;
end;
/

declare
    grant_num int;
    v_sql varchar(1023);
begin
    for grant_num in 1 .. 2049 loop
        v_sql := 'grant all on table_' || grant_num || ' to grant_max_role';
        execute immediate v_sql;
    end loop;
end;
/

declare
    tab_cnt int;
    v_sql varchar(1023);
begin
    for tab_cnt in 1 .. 2049 loop
        v_sql := 'drop table table_' || tab_cnt;
        execute immediate v_sql;
    end loop;
end;
/

drop user grant_max_user cascade;
drop role grant_max_role;

--DTSxxx
conn / as sysdba
CREATE USER FVT_Security_User_privilege_235 IDENTIFIED BY Cantian_235;
GRANT create session TO FVT_Security_User_privilege_235;
create global temporary table sys_table_FVT_Security_User_privilege_235(id int, name varchar(2048));
grant all on sys_table_FVT_Security_User_privilege_235 to FVT_Security_User_privilege_235;

conn FVT_Security_User_privilege_235/Cantian_235@127.0.0.1:1611
create index index_FVT_Security_User_privilege_235 ON sys.sys_table_FVT_Security_User_privilege_235(name ASC) ONLINE;
alter table sys.sys_table_FVT_Security_User_privilege_235 add constraint pk_FVT_Security_User_privilege_235 primary key(name);

conn / as sysdba
grant DBA TO FVT_Security_User_privilege_235;
conn FVT_Security_User_privilege_235/Cantian_235@127.0.0.1:1611
create index index_FVT_Security_User_privilege_235 ON sys.sys_table_FVT_Security_User_privilege_235(name ASC) ONLINE;
alter table sys.sys_table_FVT_Security_User_privilege_235 add constraint pk_FVT_Security_User_privilege_235 primary key(name);

--
conn / as sysdba
CREATE USER FVT_Security_User_privilege_236_1 IDENTIFIED BY Cantian_234;
GRANT create session TO FVT_Security_User_privilege_236_1;
create table table_sys_FVT_Security_User_privilege_236(id int, name varchar(2048));
grant all on table_sys_FVT_Security_User_privilege_236 to FVT_Security_User_privilege_236_1;

conn FVT_Security_User_privilege_236_1/Cantian_234@127.0.0.1:1611
create index index_FVT_Security_User_privilege_236_1 ON sys.table_sys_FVT_Security_User_privilege_236(name ASC) ONLINE;
alter table sys.table_sys_FVT_Security_User_privilege_236 MODIFY(name CONSTRAINT namefeikong NOT NULL);

conn / as sysdba
grant DBA to FVT_Security_User_privilege_236_1;

conn FVT_Security_User_privilege_236_1/Cantian_234@127.0.0.1:1611
create index index_FVT_Security_User_privilege_236_1 ON sys.table_sys_FVT_Security_User_privilege_236(name ASC) ONLINE;
create index index_FVT_Security_User_privilege_236_2 ON sys.table_sys_FVT_Security_User_privilege_236(id ASC) ONLINE;
alter table sys.table_sys_FVT_Security_User_privilege_236 MODIFY(name CONSTRAINT namefeikong NOT NULL);
conn / as sysdba
drop user FVT_Security_User_privilege_235 cascade;
drop user FVT_Security_User_privilege_236_1 cascade;

--DTS2019051407967
conn / as sysdba
create user u_replace identified by Cantian_234;
grant create session,create table to u_replace;
create user u_replace1 identified by Cantian_234;
grant create session,create table to u_replace1;
grant insert any table to u_replace1;
grant delete any table to u_replace1;

conn u_replace/Cantian_234@127.0.0.1:1611
create table tbl_rep_008(
id int ,
col_char1 varchar(30),
col_char2 varchar(40),
col_char3 varchar(40)
);
alter table tbl_rep_008 add constraint pk_001 primary key(id ,col_char1);

conn u_replace1/Cantian_234@127.0.0.1:1611
replace into u_replace.tbl_rep_008 set id = 1,col_char1 ='a',col_char2='b',col_char3='ABCDEFG';
insert into u_replace.tbl_rep_008 values(1,2,3,4);

conn / as sysdba
drop user u_replace cascade;
drop user u_replace1 cascade;

conn / as sysdba
create user test_dv identified by test_1234;
grant create session to test_dv;
connect test_dv/test_1234@127.0.0.1:1611
select * from V$FREE_SPACE;
select * from V$HA_SYNC_INFO;
select * from V$HBA;
select * from V$INSTANCE;
select * from V$JOBS_RUNNING;
select * from DV_FREE_SPACE;
select * from DV_HA_SYNC_INFO;
select * from DV_HBA;
select * from DV_INSTANCE;
select * from DV_RUNNING_JOBS;
conn / as sysdba
drop user test_dv cascade;
conn / as sysdba
drop table if exists test_t_001;
drop user if exists cao;
create user cao identified by cao102_cao;
grant connect to cao;
create table test_t_001(id int);
conn cao/cao102_cao@127.0.0.1:1611
select * from sys.test_t_001;
select * from sys.test_t_002;
select * from test_t_001;
conn / as sysdba 
drop table if exists test_t_001;
drop user if exists cao cascade;

-- DTS2019082010529
create user li_user1 identified by cantian_123;
grant create session to li_user1;
grant dba to li_user1;
conn li_user1/cantian_123@127.0.0.1:1611
alter system set ENABLE_SYS_REMOTE_LOGIN = true;
conn / as sysdba
drop user li_user1;

-- DTS2019090612564
create user z_user1 identified by Cantian_234;
grant connect to z_user1;
grant dba to z_user1;
create table z_user1.references_t1 (id int, name varchar(20) unique);
create table references_t1(id int,name varchar(20) references  z_user1.references_t1(name));
conn z_user1/Cantian_234@127.0.0.1:1611
grant references on z_user1.references_t1 to sys;
conn / as sysdba
create table references_t1(id int,name varchar(20) references  z_user1.references_t1(name));
drop table references_t1;
conn z_user1/Cantian_234@127.0.0.1:1611
revoke references on z_user1.references_t1 from sys;
conn / as sysdba
create table references_t1(id int,name varchar(20) references  z_user1.references_t1(name));
drop user z_user1 cascade;

-- DTS2019092113391
create user test_user1 identified by Cantian_234;
create user test_user2 identified by Cantian_234;
grant dba to test_user1;
grant connect to test_user2;
create table test_user1.t1(id int);
create procedure test_user1.t1           
IS 
BEGIN
	dbe_output.print_line('Hello');
END;
/  
grant execute on test_user1.t1 to test_user2;
grant execute on procedure test_user1.t1 to test_user2;
revoke execute on test_user1.t1 from test_user2;
revoke execute on procedure test_user1.t1 from test_user2;
drop user test_user1 cascade;
drop user test_user2 cascade;

-- DTS2019102503576
create table test_read_any_table(id int);
create user user_test_read_any_table identified by Cantian_234;
grant connect,read any table to user_test_read_any_table;
conn user_test_read_any_table/Cantian_234@127.0.0.1:1611
select username,privilege from user_sys_privs;
select owner,table_name from all_tables where table_name = 'TEST_READ_ANY_TABLE'; 
conn / as sysdba
drop user user_test_read_any_table cascade;
drop table test_read_any_table;

-- DTS2019082201839
create user ch_u1 identified by cantian_123;
grant create session to ch_u1;
grant alter system to ch_u1;
conn ch_u1/cantian_123@127.0.0.1:1611
alter system set _SYS_PASSWORD='mHmNxBvw7Uu7LtSvrUIy8NY9womwIuJG9vAlMl0+zNifU7x5TnIz5UOqmkozbTyW' scope=both;
conn / as sysdba
create user ch_u2 identified by cantian_123;
grant dba to ch_u2;
conn ch_u2/cantian_123@127.0.0.1:1611
alter system set _SYS_PASSWORD='mHmNxBvw7Uu7LtSvrUIy8NY9womwIuJG9vAlMl0+zNifU7x5TnIz5UOqmkozbTyW' scope=both;
conn / as sysdba
drop user ch_u1;
drop user ch_u2;
CONN / AS  SYSDBA 
DROP USER IF EXISTS "   TABUSER";
DROP USER IF EXISTS `   TABUSER1`;
CREATE USER "   TABUSER" IDENTIFIED BY  GUASS_234;
CREATE USER `   TABUSER1` IDENTIFIED BY  GUASS_234;
GRANT CONNECT TO "   TABUSER", `   TABUSER1`;
SELECT * FROM ADM_ROLE_PRIVS WHERE GRANTEE = 'TABUSER';
SELECT * FROM ADM_ROLE_PRIVS WHERE GRANTEE = 'TABUSER1';
REVOKE CONNECT FROM "   TABUSER", `   TABUSER1`;
SELECT * FROM ADM_ROLE_PRIVS WHERE GRANTEE = 'TABUSER';
SELECT * FROM ADM_ROLE_PRIVS WHERE GRANTEE = 'TABUSER1';
DROP USER IF EXISTS "   TABUSER";
DROP USER IF EXISTS `   TABUSER1`;
conn / as sysdba
begin
FOR i IN 1..3000 LOOP
EXECUTE IMMEDIATE 'drop table if exists t225' || i;
EXECUTE IMMEDIATE 'create   table t225'||i|| '(id int)' ;
end loop;
end;
/
drop user if exists PRIV_EXTEND_USER1 cascade;
create user PRIV_EXTEND_USER1 identified by Cantian_234;
CREATE OR REPLACE PROCEDURE obj_privs_extend_test1(param1 in int)
IS
begin
 FOR i IN 1..param1 LOOP
 EXECUTE IMMEDIATE 'grant  SELECT,INSERT,DELETE,UPDATE,INDEX,ALTER,REFERENCES on t225'||i|| ' to PRIV_EXTEND_USER1';
 END LOOP;
end obj_privs_extend_test1;
/
CREATE OR REPLACE PROCEDURE revoke_obj_privs_extend_test1(param1 in int)
IS
begin
 FOR i IN 1..param1 LOOP
 EXECUTE IMMEDIATE 'revoke  SELECT,INSERT,DELETE,UPDATE,INDEX,ALTER,REFERENCES on t225'||i|| ' from PRIV_EXTEND_USER1';
 END LOOP;
end revoke_obj_privs_extend_test1;
/
call obj_privs_extend_test1(3000);
select count(*) from SYS_OBJECT_PRIVS,SYS_USERS where SYS_USERS.ID = SYS_OBJECT_PRIVS.GRANTEE and SYS_USERS.NAME='PRIV_EXTEND_USER1';
call revoke_obj_privs_extend_test1(2000);
select count(*) from SYS_OBJECT_PRIVS,SYS_USERS where SYS_USERS.ID = SYS_OBJECT_PRIVS.GRANTEE and SYS_USERS.NAME='PRIV_EXTEND_USER1';
drop user PRIV_EXTEND_USER1 cascade;
select count(*) from SYS_OBJECT_PRIVS,SYS_USERS where SYS_USERS.ID = SYS_OBJECT_PRIVS.GRANTEE and SYS_USERS.NAME='PRIV_EXTEND_USER1';
create user PRIV_EXTEND_USER1 identified by Cantian_234;
select count(*) from SYS_OBJECT_PRIVS,SYS_USERS where SYS_USERS.ID = SYS_OBJECT_PRIVS.GRANTEE and SYS_USERS.NAME='PRIV_EXTEND_USER1';
drop user PRIV_EXTEND_USER1 cascade;
begin
FOR i IN 1..3000 LOOP
EXECUTE IMMEDIATE 'drop table t225'||i ;
end loop;
end;
/
conn / as sysdba 
drop table if exists ADM_DEPENDENCIES_024_Tab_02;
drop synonym if exists ADM_DEPENDENCIES_024_Syn_02;
create table  ADM_DEPENDENCIES_024_Tab_02(id  int,name varchar(100),ctime date);
create synonym ADM_DEPENDENCIES_024_Syn_02 for ADM_DEPENDENCIES_024_Tab_02;
drop table ADM_DEPENDENCIES_024_Tab_02;
drop user if exists MY_DEPENDENCIES_035_Usr_01 cascade;
create user MY_DEPENDENCIES_035_Usr_01 identified by Cantian_234;
grant create session,create view to MY_DEPENDENCIES_035_Usr_01;
connect  MY_DEPENDENCIES_035_Usr_01/Cantian_234@127.0.0.1:1611
create view MY_DEPENDENCIES_035_View_01 as select * from my_dependencies where name in (select a.OBJECT_NAME from  my_objects  a left outer join db_objects b on a.OBJECT_ID = b.OBJECT_ID);
select NAME, REFERENCED_NAME from MY_DEPENDENCIES_035_View_01 where name ='MY_DEPENDENCIES_035_VIEW_01' order by REFERENCED_NAME;
conn / as sysdba 
drop table if exists ADM_DEPENDENCIES_024_Tab_02;
drop synonym if exists ADM_DEPENDENCIES_024_Syn_02;
drop user if exists MY_DEPENDENCIES_035_Usr_01 cascade;
conn / as sysdba 
drop user if exists  hello_user cascade;
drop user if exists  test_user cascade;
drop user if exists  test_user1 cascade;
create user hello_user identified by Cantian_234;
create user test_user identified by Cantian_234;
create user test_user1 identified by Cantian_234;
grant dba to hello_user;
grant connect to test_user;
grant connect to test_user1;
conn hello_user/Cantian_234@127.0.0.1:1611
create table object1 (id int);
CREATE OR REPLACE PROCEDURE object1()
IS
    tmp varchar2(20) :='12345678';
Begin
    dbe_output.print_line('OUT PUT RESULT:'||tmp);
end object1;
/
grant select on table object1 to test_user with grant option;
grant execute on PROCEDURE object1 to test_user with grant option;
conn test_user/Cantian_234@127.0.0.1:1611
select * from hello_user.object1;
call hello_user.object1;
grant select on table hello_user.object1 to test_user1 with grant option;
grant execute on PROCEDURE hello_user.object1 to test_user1 with grant option;
conn test_user1/Cantian_234@127.0.0.1:1611
select * from hello_user.object1;
call hello_user.object1;
conn hello_user/Cantian_234@127.0.0.1:1611
alter table object1 rename to new_object1;
conn test_user/Cantian_234@127.0.0.1:1611
select * from hello_user.new_object1;
call hello_user.object1;
conn test_user1/Cantian_234@127.0.0.1:1611
select * from hello_user.new_object1;
call hello_user.object1;
conn hello_user/Cantian_234@127.0.0.1:1611
revoke select on table new_object1 from test_user;
conn test_user1/Cantian_234@127.0.0.1:1611
select * from hello_user.new_object1;
call hello_user.object1;
conn test_user/Cantian_234@127.0.0.1:1611
select * from hello_user.new_object1;
call hello_user.object1;
conn hello_user/Cantian_234@127.0.0.1:1611
revoke execute on PROCEDURE object1 from test_user;
conn test_user/Cantian_234@127.0.0.1:1611
select * from hello_user.new_object1;
call hello_user.object1;
conn test_user1/Cantian_234@127.0.0.1:1611
select * from hello_user.new_object1;
call hello_user.object1;
conn / as sysdba 
drop user if exists  hello_user cascade;
drop user if exists  test_user cascade;
drop user if exists  test_user1 cascade;

CONN / AS SYSDBA
DROP USER IF EXISTS GRANT_TEST1;
CREATE USER GRANT_TEST1 IDENTIFIED BY Cantian_123456;
GRANT CONNECT TO GRANT_TEST1;
DROP TABLE IF EXISTS GRANT_T1;
DROP TABLE IF EXISTS GRANT_T2;
CREATE TABLE GRANT_T1(C1 INT);
CREATE TABLE GRANT_T2(C1 INT);
INSERT INTO GRANT_T1 VALUES(1);
INSERT INTO GRANT_T2 VALUES(2);
COMMIT;

CONN GRANT_TEST1/Cantian_123456@127.0.0.1:1611
SELECT * FROM SYS.GRANT_T1;

CONN / AS SYSDBA
CREATE OR REPLACE PUBLIC SYNONYM GRANT_SYN1 FOR GRANT_T1;
CREATE OR REPLACE PUBLIC SYNONYM GRANT_SYN2 FOR GRANT_T2;
DROP USER IF EXISTS USER_NOT_EXIST;
GRANT SELECT ON USER_NOT_EXIST.GRANT_SYN1 TO GRANT_TEST1;
GRANT SELECT ON "PUBLIC".GRANT_SYN2 TO GRANT_TEST1;
CONN GRANT_TEST1/Cantian_123456@127.0.0.1:1611
SELECT * FROM SYS.GRANT_T1;
SELECT * FROM SYS.GRANT_T2;

CONN / AS SYSDBA
GRANT SELECT ON GRANT_SYN1 TO GRANT_TEST1;
CONN GRANT_TEST1/Cantian_123456@127.0.0.1:1611
SELECT * FROM SYS.GRANT_T1;

CONN / AS SYSDBA
DROP USER GRANT_TEST1 CASCADE;
DROP TABLE GRANT_T1;
DROP TABLE GRANT_T2;
DROP PUBLIC SYNONYM GRANT_SYN1;
DROP PUBLIC SYNONYM GRANT_SYN2;

--DTS20210507048OSDP1N00 START
--1.check priv before execute trigger
CONN / AS SYSDBA
DROP USER IF EXISTS DTS20210507048OSDP1N00_U1 CASCADE;
DROP USER IF EXISTS DTS20210507048OSDP1N00_U2 CASCADE;
CREATE USER DTS20210507048OSDP1N00_U1 IDENTIFIED BY Cantian_234;
CREATE USER DTS20210507048OSDP1N00_U2 IDENTIFIED BY Cantian_234;
GRANT CONNECT TO DTS20210507048OSDP1N00_U1;
CREATE TABLE DTS20210507048OSDP1N00_U1.T1(C1 INT);
CREATE OR REPLACE PROCEDURE DTS20210507048OSDP1N00_U2.PROC1(V1 INT) IS
BEGIN
 NULL;
END;
/
GRANT EXECUTE ON DTS20210507048OSDP1N00_U2.PROC1 TO DTS20210507048OSDP1N00_U1;
CREATE OR REPLACE TRIGGER DTS20210507048OSDP1N00_U1.TRIG1 AFTER INSERT ON DTS20210507048OSDP1N00_U1.T1 IS
BEGIN
 DTS20210507048OSDP1N00_U2.PROC1(1);
END;
/
CREATE TABLE DTS20210507048OSDP1N00_U1.T2(C1 INT);
CREATE TABLE DTS20210507048OSDP1N00_U2.T2(C1 INT);
GRANT INSERT ON DTS20210507048OSDP1N00_U2.T2 TO DTS20210507048OSDP1N00_U1;
CREATE OR REPLACE TRIGGER DTS20210507048OSDP1N00_U1.TRIG2 AFTER INSERT ON DTS20210507048OSDP1N00_U1.T2 IS
BEGIN
 INSERT INTO DTS20210507048OSDP1N00_U2.T2 VALUES(1);
END;
/
INSERT INTO DTS20210507048OSDP1N00_U1.T1 VALUES(1);
INSERT INTO DTS20210507048OSDP1N00_U1.T2 VALUES(1);
COMMIT;
REVOKE EXECUTE ON DTS20210507048OSDP1N00_U2.PROC1 FROM DTS20210507048OSDP1N00_U1;
REVOKE INSERT ON DTS20210507048OSDP1N00_U2.T2 FROM DTS20210507048OSDP1N00_U1;
CONN DTS20210507048OSDP1N00_U1/Cantian_234@127.0.0.1:1611
INSERT INTO T1 VALUES(1);--expected:CT-01001, Permissions were insufficient
UPDATE T1 SET C1=2;
DELETE FROM T1;--succeed
COMMIT;
INSERT INTO T2 VALUES(1);--expected:CT-01001, Permissions were insufficient

--2.check priv after pl open dc in execute.such as open package body dc
CONN / AS SYSDBA
CREATE OR REPLACE PROCEDURE DTS20210507048OSDP1N00_U2.PROC1(V1 INT) IS
BEGIN
 NULL;
END;
/
GRANT EXECUTE ON DTS20210507048OSDP1N00_U2.PROC1 TO DTS20210507048OSDP1N00_U1;
CREATE OR REPLACE PACKAGE DTS20210507048OSDP1N00_U1.PKG1 IS
 PROCEDURE P1(V1 INT);
END;
/
CREATE OR REPLACE PACKAGE BODY DTS20210507048OSDP1N00_U1.PKG1 IS
 PROCEDURE P1(V1 INT) IS
 BEGIN
  DTS20210507048OSDP1N00_U2.PROC1(V1);
 END;
END;
/
CALL DTS20210507048OSDP1N00_U1.PKG1.P1(1);
REVOKE EXECUTE ON DTS20210507048OSDP1N00_U2.PROC1 FROM DTS20210507048OSDP1N00_U1;
CONN DTS20210507048OSDP1N00_U1/Cantian_234@127.0.0.1:1611
CALL DTS20210507048OSDP1N00_U1.PKG1.P1(1);--expected:CT-01001, Permissions were insufficient


CONN / AS SYSDBA
DROP USER IF EXISTS DTS20210507048OSDP1N00_U1 CASCADE;
DROP USER IF EXISTS DTS20210507048OSDP1N00_U2 CASCADE;
--DTS20210507048OSDP1N00 END

--SERIAL_LASTVAL
DROP TABLE IF EXISTS TABLE_LAST;
CREATE TABLE TABLE_LAST (staff_id INT AUTO_INCREMENT  primary key ,section_id INT,max_salary NUMBER(10,2)) AUTO_INCREMENT 1000;
SELECT SERIAL_LASTVAL('SYS','TABLE_LAST');

drop user if exists USER_LAST cascade;
create user USER_LAST identified by Anti2850;
grant connect to USER_LAST;
conn USER_LAST/Anti2850@127.0.0.1:1611
select SERIAL_LASTVAL('SYS','TABLE_LAST'); --error
select SERIAL_LASTVAL('SYS','USER$'); --error
select SERIAL_LASTVAL('USER1','USER$'); --error
select SERIAL_LASTVAL('USER_LAST','USER_1');

conn / as sysdba
grant select on sys.TABLE_LAST to USER_LAST;
conn USER_LAST/Anti2850@127.0.0.1:1611
select SERIAL_LASTVAL('SYS','TABLE_LAST');
select SERIAL_LASTVAL('SYS','USER_T'); --error

conn / as sysdba
revoke select on sys.TABLE_LAST from USER_LAST;
conn USER_LAST/Anti2850@127.0.0.1:1611
select SERIAL_LASTVAL('SYS','TABLE_LAST'); --error

conn / as sysdba
grant select any table to USER_LAST;
conn USER_LAST/Anti2850@127.0.0.1:1611
select SERIAL_LASTVAL('SYS','TABLE_LAST');
select SERIAL_LASTVAL('SYS','USER_T'); --error

conn / as sysdba
revoke select any table from USER_LAST;
conn USER_LAST/Anti2850@127.0.0.1:1611
select SERIAL_LASTVAL('SYS','TABLE_LAST');  --error

conn / as sysdba
CREATE TABLE USER_LAST.TABLE_LAST1 (staff_id INT AUTO_INCREMENT  primary key ,section_id INT,max_salary NUMBER(10,2)) AUTO_INCREMENT 1100;
CREATE TABLE USER_LAST.TABLE_LAST2 (staff_id INT);
conn USER_LAST/Anti2850@127.0.0.1:1611
select SERIAL_LASTVAL('USER_LAST','TABLE_LAST1');
select SERIAL_LASTVAL('USER_LAST','TABLE_LAST2');
select SERIAL_LASTVAL('USER_LAST','TABLE_LAST3');

CONN / AS SYSDBA
DROP USER IF EXISTS USER_LAST CASCADE;
DROP TABLE IF EXISTS TABLE_LAST;
--SERIAL_LASTVAL END
--20210830
drop tenant if exists tent_1 cascade;
CREATE TENANT tent_1  TABLESPACES (users);
alter session set tenant=tent_1;
drop user if exists tpcc_1 cascade;
create user tpcc_1 identified by Cantian_234;
grant create session to tpcc_1;
grant create table to tpcc_1;
grant DROP ANY TABLE to tpcc_1;
grant EXECUTE ON DBE_SPM to tpcc_1;
grant INSERT ANY TABLE to tpcc_1;
grant select on DV_SQL_PLAN to tpcc_1;
grant select on DV_SQLS to tpcc_1;
drop table if exists T_SPM_1;
CREATE TABLE T_SPM_1(ID INT PRIMARY KEY, C_NUMBER NUMBER, C_CHAR CHAR(10), C_VCHAR VARCHAR(200));
INSERT INTO T_SPM_1 VALUES(1, 1000, 'TEST', 'TEST');
drop tenant if exists tent_2 cascade;
CREATE TENANT tent_2  TABLESPACES (users);
alter session set tenant=tent_2;
drop user if exists tpcc_2 cascade;
create user tpcc_2 identified by Cantian_234;
grant create session to tpcc_2;
grant create table to tpcc_2;
grant DROP ANY TABLE to tpcc_2;
grant EXECUTE ON DBE_SPM to tpcc_2;
grant INSERT ANY TABLE to tpcc_2;
grant select on DV_SQL_PLAN to tpcc_2;
grant select on DV_SQLS to tpcc_2;
alter session set tenant=tent_2;
grant select on tpcc_1.T_SPM_1 to tpcc_2;