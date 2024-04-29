drop user if exists liu_dependency cascade;
create user liu_dependency identified by Cantian_234;
grant dba to liu_dependency;
conn liu_dependency/Cantian_234@127.0.0.1:1611

select d_name,d_type#,p_name,p_type# from sys.sys_dependencies where d_owner# in (select user_id from dv_me) order by 1,2,3;
select name,status from sys.sys_procs where user# in (select user_id from dv_me) order by 1;

create user liu_dependency identified by Cantian_234;
grant dba to liu_dependency;

conn liu_dependency/Cantian_234@127.0.0.1:1611
create table dep_t1(a int);
insert into dep_t1 values(10);
create table dep_t2(a int);
insert into dep_t2 values(10);

create or replace procedure procA is
tmp int;
begin
select a into tmp from dep_t1;
select a into tmp from dep_t2;
end;
/

create or replace procedure procB is
tmp int;
begin
select a into tmp from dep_t1;
select a into tmp from dep_t2;
procA();
end;
/

create or replace procedure procC is
tmp int;
begin
select a into tmp from dep_t1;
select a into tmp from dep_t2;
procA();
procB();
end;
/

create or replace procedure procD is
tmp int;
begin
select a into tmp from dep_t1;
select a into tmp from dep_t2;
procA();
procB();
procC();
end;
/

create or replace procedure procE is
tmp int;
begin
select a into tmp from dep_t1;
select a into tmp from dep_t2;
procA();
procB();
procC();
procD();
end;
/

create or replace procedure procF is
tmp int;
begin
select a into tmp from dep_t1;
select a into tmp from dep_t2;
procA();
procB();
procC();
procD();
procE();
end;
/
alter table dep_t1 add column b int;
select d_name,d_type#,p_name,p_type# from sys.sys_dependencies where d_owner# in (select user_id from dv_me) order by 1,2,3;
select name,status from sys.sys_procs where user# in (select user_id from dv_me) order by 1;

call procF;
select name,status from sys.sys_procs where user# in (select user_id from dv_me) order by 1;
call procE;
select name,status from sys.sys_procs where user# in (select user_id from dv_me) order by 1;

--END
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists liu_dependency cascade;

--DTS202104290PCME4P1H00 START
CONN / AS SYSDBA
DROP USER IF EXISTS DTS202104290PCME4P1H00_U1;
CREATE USER DTS202104290PCME4P1H00_U1 IDENTIFIED BY Cantian_234;
GRANT DBA TO DTS202104290PCME4P1H00_U1;
CONN DTS202104290PCME4P1H00_U1/Cantian_234@127.0.0.1:1611
CREATE TABLE DTS202104290PCME4P1H00_T1(C1 INT);
CREATE OR REPLACE SYNONYM DTS202104290PCME4P1H00_SYN1 FOR DTS202104290PCME4P1H00_T1;
CREATE OR REPLACE VIEW DTS202104290PCME4P1H00_V1 AS SELECT * FROM DTS202104290PCME4P1H00_T1;
CREATE OR REPLACE PUBLIC SYNONYM DTS202104290PCME4P1H00_PUB_SYN1 FOR DTS202104290PCME4P1H00_T1;
CREATE OR REPLACE TYPE DTS202104290PCME4P1H00_TYPE1 IS TABLE OF DTS202104290PCME4P1H00_T1%ROWTYPE;
/
CREATE OR REPLACE TYPE DTS202104290PCME4P1H00_TYPE2 IS TABLE OF DTS202104290PCME4P1H00_T1.C1%TYPE;
/
CREATE OR REPLACE TYPE DTS202104290PCME4P1H00_TYPE3 IS TABLE OF DTS202104290PCME4P1H00_PUB_SYN1%ROWTYPE;
/
CREATE OR REPLACE TYPE DTS202104290PCME4P1H00_TYPE4 IS TABLE OF DTS202104290PCME4P1H00_PUB_SYN1.C1%TYPE;
/
CREATE OR REPLACE PROCEDURE DTS202104290PCME4P1H00_PROC1(C1 INT) IS
 V1 DTS202104290PCME4P1H00_T1%ROWTYPE;
 V2 DTS202104290PCME4P1H00_PUB_SYN1%ROWTYPE;
BEGIN
 NULL;
END;
/
CREATE OR REPLACE PROCEDURE DTS202104290PCME4P1H00_PROC2(C1 INT) IS
 V1 DTS202104290PCME4P1H00_V1%ROWTYPE;
 V2 DTS202104290PCME4P1H00_PUB_SYN1.C1%TYPE;
BEGIN
 NULL;
END;
/
CREATE OR REPLACE PROCEDURE DTS202104290PCME4P1H00_PROC3(C1 INT) IS
 V1 DTS202104290PCME4P1H00_SYN1%ROWTYPE;
BEGIN
 NULL;
END;
/
CREATE OR REPLACE PROCEDURE DTS202104290PCME4P1H00_PROC4(C1 INT) IS
 V1 DTS202104290PCME4P1H00_TYPE1;
 V2 DTS202104290PCME4P1H00_TYPE3;
BEGIN
 NULL;
END;
/
CREATE OR REPLACE PROCEDURE DTS202104290PCME4P1H00_PROC5(C1 INT) IS
 V1 DTS202104290PCME4P1H00_TYPE2;
 V2 DTS202104290PCME4P1H00_TYPE4;
BEGIN
 NULL;
END;
/
SELECT NAME,TYPE,REFERENCED_NAME,REFERENCED_TYPE FROM MY_DEPENDENCIES WHERE NAME LIKE '%DTS202104290PCME4P1H00%' ORDER BY NAME, REFERENCED_NAME;
SELECT OBJECT_NAME,STATUS FROM MY_OBJECTS WHERE OBJECT_NAME LIKE '%DTS202104290PCME4P1H00%' ORDER BY OBJECT_NAME;
DROP TABLE DTS202104290PCME4P1H00_T1;
SELECT OBJECT_NAME,STATUS FROM MY_OBJECTS WHERE OBJECT_NAME LIKE '%DTS202104290PCME4P1H00%' ORDER BY OBJECT_NAME;
CONN / AS SYSDBA
DROP USER IF EXISTS DTS202104290PCME4P1H00_U1 CASCADE;
--DTS202104290PCME4P1H00 END