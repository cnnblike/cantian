conn / as sysdba

drop user if exists inherit_user cascade;
drop user if exists inherit_user2 cascade;
drop user if exists inherit_user4 cascade;
drop user if exists inherit_user5 cascade;

--new user has INHERIT PRIVILEGES on himself to PUBLIC
ALTER SYSTEM SET AUTO_INHERIT_USER = ON;
create user inherit_user identified by Cantian_234;
create user inherit_user2 identified by Cantian_234;
create user inherit_user4 identified by Cantian_234;
create user inherit_user5 identified by Cantian_234;
ALTER SYSTEM SET AUTO_INHERIT_USER = OFF;
grant create session to inherit_user, inherit_user2, inherit_user4, inherit_user5;
select * from dba_tab_privs where PRIVILEGE='INHERIT PRIVILEGES' and object_name like 'INHERIT_USER%';

drop procedure if exists inherit_user2.procedure_002;
CREATE OR REPLACE PROCEDURE inherit_user2.procedure_002(a in int) IS
b int;
BEGIN
  b:= a * a * 3;
   dbe_output.print_line(b);
END;
/
grant execute on inherit_user2.procedure_002 to inherit_user5;
conn inherit_user5/Cantian_234@127.0.0.1:1611
set serveroutput on;
call inherit_user2.procedure_002(2);

conn / as sysdba
revoke INHERIT PRIVILEGES on User inherit_user5 from public;
select * from dba_tab_privs where PRIVILEGE='INHERIT PRIVILEGES' and object_name like 'INHERIT_USER%';
conn inherit_user5/Cantian_234@127.0.0.1:1611
call inherit_user2.procedure_002(3);

--INHERIT ANY PRIVILEGES
conn / as sysdba
select * from dba_sys_privs where grantee = 'SYS' and privilege='INHERIT ANY PRIVILEGES';
select * from dba_sys_privs where grantee = 'DBA' and privilege='INHERIT ANY PRIVILEGES';
grant INHERIT ANY PRIVILEGES to inherit_user5;
conn inherit_user5/Cantian_234@127.0.0.1:1611
call inherit_user2.procedure_002(3);  --error
select * from my_sys_privs;

conn / as sysdba
grant INHERIT ANY PRIVILEGES to inherit_user2;
conn inherit_user5/Cantian_234@127.0.0.1:1611
call inherit_user2.procedure_002(3);

------------INHERIT PRIVILEGES 
conn / as sysdba
revoke INHERIT ANY PRIVILEGES from inherit_user2, inherit_user5;
grant INHERIT PRIVILEGES on USER inherit_user5 to inherit_user2;
conn inherit_user5/Cantian_234@127.0.0.1:1611
call inherit_user2.procedure_002(4);
conn inherit_user2/Cantian_234@127.0.0.1:1611
select * from my_tab_privs;

------------role
conn / as sysdba
create role c##role1_inhe;
grant INHERIT ANY PRIVILEGES to c##role1_inhe;
grant INHERIT PRIVILEGES on USER inherit_user5 to c##role1_inhe; --error
drop role c##role1_inhe;

---------grant any object privilege
conn inherit_user4/Cantian_234@127.0.0.1:1611
grant INHERIT PRIVILEGES on USER inherit_user4 to inherit_user5;
grant INHERIT PRIVILEGES on USER inherit_user to inherit_user5;  --error
revoke INHERIT PRIVILEGES on USER inherit_user5 from inherit_user2;   --error
conn / as sysdba
grant grant any object privilege to inherit_user4;
conn inherit_user4/Cantian_234@127.0.0.1:1611
grant INHERIT PRIVILEGES on USER inherit_user to inherit_user5; 
revoke INHERIT PRIVILEGES on USER inherit_user5 from inherit_user2;
grant INHERIT PRIVILEGES on USER sys to inherit_user5;  --error

----grammar
conn / as sysdba
grant INHERIT PRIVILEGES on USER inherit_user to inherit_user4 , inherit_user2;
select * from dba_tab_privs where PRIVILEGE='INHERIT PRIVILEGES' and object_name like 'INHERIT_USER';
revoke INHERIT PRIVILEGES on USER inherit_user from inherit_user4, inherit_user2;
select * from dba_tab_privs where PRIVILEGE='INHERIT PRIVILEGES' and object_name like 'INHERIT_USER';
revoke INHERIT PRIVILEGES on User inherit_user from public;
grant INHERIT PRIVILEGES on USER sys to inherit_user5;
revoke INHERIT PRIVILEGES on USER sys from inherit_user5;

grant INHERIT PRIVILEGES on USER public to inherit_user4; --error
grant INHERIT PRIVILEGES on USER inherit_user, inherit_user2 to inherit_user4; --error
grant INHERIT PRIVILEGES on inherit_user5 to inherit_user; --error
grant INHERIT PRIVILEGES on USER inherit_user, USER inherit_user2 to inherit_user4; --error
grant INHERIT PRIVILEGES on USER inherit_user to inherit_user4 with grant option;  --error
create table inherit_user.tab1(id int);
grant select on USER inherit_user.tab1 to inherit_user4; --error
grant INHERIT PRIVILEGES on USER inherit_user.tab1 to inherit_user4; --error

drop user inherit_user cascade;
drop user inherit_user2 cascade;
drop user inherit_user4 cascade;
drop user inherit_user5 cascade;
select * from dba_tab_privs where PRIVILEGE='INHERIT PRIVILEGES' and object_name like 'INHERIT_USER%';


-- test trigger
conn / as sysdba
ALTER SYSTEM SET AUTO_INHERIT_USER = ON;
drop user if exists normal_user cascade;
create user normal_user identified by Cantian_234;
grant connect, create table, insert any table, create view, create any trigger to normal_user;

drop user if exists test_user cascade;
create user test_user identified by Cantian_234;
grant connect, create table, insert any table, create view, create any trigger to test_user;

drop user if exists top_user cascade;
create user top_user identified by Cantian_234;
grant dba to top_user;
ALTER SYSTEM SET AUTO_INHERIT_USER = OFF;
conn normal_user/Cantian_234@127.0.0.1:1611
create table test_table(user_id int, value_id int);
insert into test_table values(1, 1);
insert into test_table values(2, 2);
insert into test_table values(3, 3);
insert into test_table values(4, 4);
commit;
select * from test_table order by user_id;

conn test_user/Cantian_234@127.0.0.1:1611
create table test(i int);

CREATE OR REPLACE TRIGGER TEST_TRIG AFTER INSERT ON test
FOR EACH ROW
BEGIN
    UPDATE normal_user.test_table SET user_id = 0;
END;
/
insert into test values(1); 

conn top_user/Cantian_234@127.0.0.1:1611
REVOKE INHERIT PRIVILEGES ON USER top_user FROM PUBLIC;
insert into test_user.test values(2); 
select * from normal_user.test_table order by user_id;
GRANT INHERIT PRIVILEGES ON USER top_user TO public;

conn / as sysdba
grant UPDATE on normal_user.test_table to test_user;

conn top_user/Cantian_234@127.0.0.1:1611
insert into test_user.test values(2);
select * from normal_user.test_table order by user_id;
set serveroutput off;

conn / as sysdba
ALTER SYSTEM SET AUTO_INHERIT_USER = ON;
drop user normal_user cascade;
drop user test_user cascade;
drop user top_user cascade;
create user super_grantor identified by Cantian_234;
create user grantor1 identified by Cantian_234;
create user grantor2 identified by Cantian_234;
create user grantor3 identified by Cantian_234;
create user grantee1 identified by Cantian_234;
create user grantee2 identified by Cantian_234;
create user grantee3 identified by Cantian_234;
GRANT INHERIT PRIVILEGES ON USER super_grantor TO grantor1;
GRANT INHERIT PRIVILEGES ON USER super_grantor TO grantor2;
GRANT INHERIT PRIVILEGES ON USER super_grantor TO grantor3;
GRANT INHERIT PRIVILEGES ON USER grantor1 TO grantee1;
GRANT INHERIT PRIVILEGES ON USER grantor1 TO grantee2;
GRANT INHERIT PRIVILEGES ON USER grantor1 TO grantee3;
GRANT INHERIT PRIVILEGES ON USER grantor2 TO grantee1;
GRANT INHERIT PRIVILEGES ON USER grantor2 TO grantee2;
GRANT INHERIT PRIVILEGES ON USER grantor2 TO grantee3;
GRANT INHERIT PRIVILEGES ON USER grantor3 TO grantee1;
GRANT INHERIT PRIVILEGES ON USER grantor3 TO grantee2;
GRANT INHERIT PRIVILEGES ON USER grantor3 TO grantee3;
drop user grantor1 cascade;
drop user grantor2 cascade;
drop user grantor3 cascade;
create user grantor1 identified by Cantian_234;
create user grantor2 identified by Cantian_234;
create user grantor3 identified by Cantian_234;
GRANT INHERIT PRIVILEGES ON USER super_grantor TO grantor1;
GRANT INHERIT PRIVILEGES ON USER super_grantor TO grantor2;
GRANT INHERIT PRIVILEGES ON USER super_grantor TO grantor3;
GRANT INHERIT PRIVILEGES ON USER grantor1 TO grantee1;
GRANT INHERIT PRIVILEGES ON USER grantor2 TO grantee2;
GRANT INHERIT PRIVILEGES ON USER grantor3 TO grantee3;
drop user super_grantor cascade;
drop user grantor1 cascade;
drop user grantor2 cascade;
drop user grantor3 cascade;
drop user grantee1 cascade;
drop user grantee2 cascade;
drop user grantee3 cascade;

--DTS202104290QOJZZP1300 START change to correct user to check system priv
DROP USER IF EXISTS DTS202104290QOJZZP1300_U1 CASCADE;
DROP USER IF EXISTS DTS202104290QOJZZP1300_U2 CASCADE;
CREATE USER DTS202104290QOJZZP1300_U1 IDENTIFIED BY Cantian_234;
CREATE USER DTS202104290QOJZZP1300_U2 IDENTIFIED BY Cantian_234;
CREATE OR REPLACE PROCEDURE DTS202104290QOJZZP1300_U1.PROC1(V1 INT) IS --succeed
BEGIN
 NULL;
END;
/
CREATE OR REPLACE PROCEDURE DTS202104290QOJZZP1300_U1.PROC2(V1 INT) IS --succeed
BEGIN
 DTS202104290QOJZZP1300_U1.PROC1(V1);
END;
/
CREATE OR REPLACE PROCEDURE DTS202104290QOJZZP1300_U2.PROC1(V1 INT) IS --PLC-01001 Permissions were insufficient
BEGIN
 DTS202104290QOJZZP1300_U1.PROC1(V1);
END;
/
GRANT EXECUTE ON DTS202104290QOJZZP1300_U1.PROC1 TO DTS202104290QOJZZP1300_U2;
CREATE OR REPLACE PROCEDURE DTS202104290QOJZZP1300_U2.PROC1(V1 INT) IS --succeed
BEGIN
 DTS202104290QOJZZP1300_U1.PROC1(V1);
END;
/
REVOKE EXECUTE ON DTS202104290QOJZZP1300_U1.PROC1 FROM DTS202104290QOJZZP1300_U2;
CREATE OR REPLACE PROCEDURE DTS202104290QOJZZP1300_U2.PROC1(V1 INT) IS --PLC-01001 Permissions were insufficient
BEGIN
 DTS202104290QOJZZP1300_U1.PROC1(V1);
END;
/
GRANT EXECUTE ANY PROCEDURE TO DTS202104290QOJZZP1300_U2;
CREATE OR REPLACE PROCEDURE DTS202104290QOJZZP1300_U2.PROC1(V1 INT) IS --succeed
BEGIN
 DTS202104290QOJZZP1300_U1.PROC1(V1);
END;
/
REVOKE EXECUTE ANY PROCEDURE FROM DTS202104290QOJZZP1300_U2;
CREATE OR REPLACE PROCEDURE DTS202104290QOJZZP1300_U2.PROC1(V1 INT) IS --PLC-01001 Permissions were insufficient
BEGIN
 DTS202104290QOJZZP1300_U1.PROC1(V1);
END;
/
DROP USER IF EXISTS DTS202104290QOJZZP1300_U1 CASCADE;
DROP USER IF EXISTS DTS202104290QOJZZP1300_U2 CASCADE;

CREATE USER DTS202104290QOJZZP1300_U1 IDENTIFIED BY Cantian_234;
GRANT CONNECT TO DTS202104290QOJZZP1300_U1;
CREATE OR REPLACE PROCEDURE DTS202104290QOJZZP1300_U1.PROC1(V1 INT) IS --succeed
BEGIN
 NULL;
END;
/

CREATE OR REPLACE PROCEDURE DTS202104290QOJZZP1300_PROC1(V1 INT) IS --succeed
BEGIN
 DTS202104290QOJZZP1300_U1.PROC1(V1);
END;
/

GRANT EXECUTE ON DTS202104290QOJZZP1300_PROC1 TO DTS202104290QOJZZP1300_U1;
CONN DTS202104290QOJZZP1300_U1/Cantian_234@127.0.0.1:1611
CALL DTS202104290QOJZZP1300_U1.PROC1(1); --succeed
CALL SYS.DTS202104290QOJZZP1300_PROC1(1); --succeed

CONN / AS SYSDBA
DROP USER IF EXISTS DTS202104290QOJZZP1300_U1 CASCADE;
DROP PROCEDURE DTS202104290QOJZZP1300_PROC1;
--DTS202104290QOJZZP1300 END

conn / as sysdba
alter system set auto_inherit_user = off;

drop user if exists inherit_test_user cascade;
create user inherit_test_user identified by Cantian_234;
grant resource, connect to inherit_test_user;
create or replace procedure inherit_test_user.test_inherit(i int) as 
begin
    dbe_output.print_line(i);
end;
/

drop user if exists dba_test_user cascade;
create user dba_test_user identified by Cantian_234;
grant dba to dba_test_user;
conn dba_test_user/Cantian_234@127.0.0.1:1611
call inherit_test_user.test_inherit(2);
create or replace procedure test_print(i int) as 
begin
    dbe_output.print_line(i);
end;
/

create or replace public synonym test_public_syn for test_print;
call test_public_syn(2);

conn / as sysdba
drop user if exists inherit_test_user cascade;
drop user if exists dba_test_user cascade;
alter system set auto_inherit_user = ON;