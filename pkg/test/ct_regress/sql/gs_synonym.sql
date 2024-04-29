conn / as sysdba 
drop user if exists test_uu cascade;
create user test_uu identified by Cantian_234;
grant dba to test_uu;
conn test_uu/Cantian_234@127.0.0.1:1611
DROP TABLE IF EXISTS USER_FUNC_TEMP;
CREATE TABLE USER_FUNC_TEMP(ID INT);
INSERT INTO USER_FUNC_TEMP VALUES(1);
commit;
CREATE OR REPLACE FUNCTION USER_FUNC_QUERY_TEMP(a INT) RETURN INT
  AS
    c INT;
    d INT;
  BEGIN
    c := a;
    SELECT ID INTO d FROM USER_FUNC_TEMP WHERE ROWNUM = c;
    RETURN d;
END USER_FUNC_QUERY_TEMP;
/
create synonym fff for USER_FUNC_QUERY_TEMP;
conn / as sysdba 
drop user if exists test_uu cascade;
create user test_uu identified by Cantian_234;
grant dba to test_uu;
conn test_uu/Cantian_234@127.0.0.1:1611
DROP TABLE IF EXISTS USER_FUNC_TEMP;
CREATE TABLE USER_FUNC_TEMP(ID INT);
INSERT INTO USER_FUNC_TEMP VALUES(1);
commit;
CREATE OR REPLACE FUNCTION USER_FUNC_QUERY_TEMP(a INT) RETURN INT
  AS
    c INT;
    d INT;
  BEGIN
    c := a;
    SELECT ID INTO d FROM USER_FUNC_TEMP WHERE ROWNUM = c;
    RETURN d;
END USER_FUNC_QUERY_TEMP;
/
create synonym fff for USER_FUNC_QUERY_TEMP;
conn / as sysdba 
drop user if exists test_uu cascade;
conn / as sysdba
create user test identified by Cantian_234;
grant dba to test;
alter session set current_schema = test;
drop user test;
select SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA');
alter session set current_schema = sys;
--TEST SYNONYM
create table t1 (fd int);
create view v1 as select 1 from dual;
create public synonym s_t1 for test.t1;
create public synonym s_t1 for t1; 
create public synonym s_t1 for v1;
create or replace public synonym s_t1 for v1;
create or replace public synonym s_t1 for t1;

create user dw_12334 identified by 'a2345678#$_';
create public synonym dw_12334.s_v1 for v1;
create public synonym s_v1 for v1;
create public synonym s_s1 for s_v1;

select * from dba_synonyms where SYNONYM_NAME in ('S_T1', 'S_V1');

select * from s_t1;
select * from s_v1;

drop table if exists t1;
select * from s_t1;

drop view v1;
select * from s_v1;

create table t1 (fd int);
create view v1 as select * from t1;
select * from s_t1;
select * from s_v1;

alter table t1 add fd2 varchar(20);
select * from s_t1;
select * from s_v1;

drop public SYNONYM if exists s_tt2 FORCE;
drop public SYNONYM if exists s_v1 FORCE;
drop public SYNONYM s_v1 FORCE;
drop public SYNONYM if exists s_t1 FORCE;
drop public SYNONYM s_t1 FORCE;

select * from dba_synonyms where SYNONYM_NAME in ('S_T1', 'S_V1');

create table t2 (fd int, fd2 VARCHAR(20));
create view v2 as select * from t2, s_t1 where t2.fd = s_t1.fd;
create public synonym s_t1 for t1;
drop table if exists t1;
create view v2 as select * from t2, s_t1 where t2.fd = s_t1.fd;
create table t1 (fd int);
create view v2 as select t2.fd as t2_fd, t2.fd2, s_t1.fd as t1_fd from t2, s_t1 where t2.fd = s_t1.fd;

insert into t2 values(1, 't2_1');
insert into t2 values(2, 't2_2');
insert into t1 values(1, 't1');
select * from v2;

drop table if exists t1;
select * from v2;

create table t1 (fd int);
insert into t1 values(1);
select * from v2;
select * from v2;

drop public SYNONYM if exists s_t1 FORCE;
select * from v2;

drop table if exists t1;
drop table if exists t2;
drop view if exists v1;
drop view if exists v2;
drop public SYNONYM if exists s_t1 FORCE;
drop public SYNONYM if exists s_v1 FORCE;
drop user dw_12334 CASCADE;

drop user if exists test_synonym_1 cascade;
drop user if exists test_synonym_2 cascade;
create user test_synonym_1 identified by Root1234;
create user test_synonym_2 identified by Root1234;
grant CREATE SESSION, CREATE ANY TABLE, DROP ANY TABLE to test_synonym_1;
CONNECT test_synonym_1/Root1234@127.0.0.1:1611
CREATE TABLE T1 (FD_INT INT);
CREATE SYNONYM S_T1 FOR T1;--FAILED
CREATE SYNONYM test_synonym_2.S_T1 FOR T1;--FAILED
CREATE PUBLIC SYNONYM S_T1 FOR T1;--FAILED
CONNECT sys/Huawei@123@127.0.0.1:1611
grant CREATE SYNONYM to test_synonym_1;
CONNECT test_synonym_1/Root1234@127.0.0.1:1611
CREATE SYNONYM S_T1 FOR T1;
SELECT * FROM T1;
CREATE SYNONYM test_synonym_2.S_T1 FOR T1;--FAILED
CREATE PUBLIC SYNONYM S_T1 FOR T1;--FAILED
CONNECT sys/Huawei@123@127.0.0.1:1611
grant CREATE PUBLIC SYNONYM to test_synonym_1;
CONNECT test_synonym_1/Root1234@127.0.0.1:1611
CREATE SYNONYM S_T1 FOR T1;--FAILED
CREATE SYNONYM test_synonym_2.S_T1 FOR T1;--FAILED
CREATE PUBLIC SYNONYM S_T1 FOR T1;
SELECT * FROM T1;
SELECT * FROM "PUBLIC".S_T1;
CONNECT sys/Huawei@123@127.0.0.1:1611
grant CREATE ANY SYNONYM to test_synonym_1;
CONNECT test_synonym_1/Root1234@127.0.0.1:1611
CREATE SYNONYM S_T1 FOR T1;--FAILED
CREATE SYNONYM test_synonym_2.S_T1 FOR T1;
CREATE PUBLIC SYNONYM S_T1 FOR T1;--FAILED
SELECT * FROM T1;
SELECT * FROM "PUBLIC".S_T1;
SELECT * FROM test_synonym_2.S_T1;
DROP public SYNONYM S_T1;--FAILED
DROP SYNONYM S_T1;--FAILED
DROP SYNONYM test_synonym_2.S_T1;--FAILED
CONNECT sys/Huawei@123@127.0.0.1:1611
grant DROP PUBLIC SYNONYM to test_synonym_1;
CONNECT test_synonym_1/Root1234@127.0.0.1:1611
DROP public SYNONYM S_T1;
DROP SYNONYM S_T1;--FAILED
DROP SYNONYM test_synonym_2.S_T1;--FAILED
CREATE TABLE T2 (FD_INT INT, FD_VARCHAR VARCHAR(100));
CREATE PUBLIC SYNONYM S_T1 FOR T2;
SELECT * FROM T1;
SELECT * FROM "PUBLIC".S_T1;
SELECT * FROM test_synonym_2.S_T1;
CONNECT sys/Huawei@123@127.0.0.1:1611
grant DROP ANY SYNONYM to test_synonym_1;
CONNECT test_synonym_1/Root1234@127.0.0.1:1611
DROP public SYNONYM S_T1;
DROP SYNONYM S_T1;
DROP SYNONYM test_synonym_2.S_T1;
drop table t1;
drop table t2;
CONNECT sys/Huawei@123@127.0.0.1:1611
drop user if exists test_synonym_1 cascade;
drop user if exists test_synonym_2 cascade;

--DTS2018073105444
drop table if exists sysview_all_trg_tbl_017;
create table sysview_all_trg_tbl_017(c_id int not null,c_first varchar2(40),c_since date,c_end timestamp,c_text clob,c_data blob);
insert into sysview_all_trg_tbl_017 values(1,'c_fisrtaaa',to_date('2018-07-28 14:22:59','yyyy-mm-dd hh24:mi:ss'),to_timestamp('2018-07-28 14:22:59.012345','yyyy-mm-dd hh24:mi:ss.ff6'),'abcdefghijklmnABCDEFGHIGKLMN','12345678900abcdef9087654321fedcba');
insert into sysview_all_trg_tbl_017 values(2,'c_fisrtbbb',to_date('2018-07-28 14:22:59','yyyy-mm-dd hh24:mi:ss'),to_timestamp('2018-07-28 14:22:59.012345','yyyy-mm-dd hh24:mi:ss.ff6'),'abcdefghijklmnABCDEFGHIGKLMN','12345678900abcdef9087654321fedcba');
insert into sysview_all_trg_tbl_017 values(3,'c_fisrtbbb',to_date('2018-07-28 14:22:59','yyyy-mm-dd hh24:mi:ss'),to_timestamp('2018-07-28 14:22:59.012345','yyyy-mm-dd hh24:mi:ss.ff6'),'abcdefghijklmnABCDEFGHIGKLMN','12345678900abcdef9087654321fedcba');
commit;
create user all_triggers_017 identified by Cantian_234;
grant create session to all_triggers_017;
grant select ,update,insert,delete on sysview_all_trg_tbl_017 to all_triggers_017 with grant option;
grant create any view to all_triggers_017 with admin option;
conn all_triggers_017/Cantian_234@127.0.0.1:1611
create or replace view all_triggers as select * from sys.sysview_all_trg_tbl_017;
select c_id,c_first from all_triggers order by 1,2;
conn / as sysdba
select count(*) from SYS_VIEWS where name=upper('all_triggers') order by 1;
drop user all_triggers_017 cascade;
drop table sysview_all_trg_tbl_017;

drop user if exists USER_TEST cascade;
CREATE USER USER_TEST IDENTIFIED BY Root1234;
grant dba to USER_TEST;
connect USER_TEST/Root1234@127.0.0.1:1611
DROP TABLE IF EXISTS TEST;
DROP TABLE IF EXISTS TEST_REF;
DROP VIEW IF EXISTS V_TEST;
create table TEST(FD_INT INT, FD_VARCHAR VARCHAR(100), FD_BIGINT BIGINT);
create table TEST_REF(FD_BIGINT BIGINT PRIMARY KEY);
create view  V_TEST AS SELECT * FROM TEST;
DROP SYNONYM IF EXISTS S_TEST;
DROP SYNONYM IF EXISTS S_V_TEST;
DROP SYNONYM IF EXISTS S_TEST_REF;
create SYNONYM S_TEST FOR TEST;
create SYNONYM S_V_TEST FOR V_TEST;
create SYNONYM S_TEST_REF FOR TEST_REF;
CREATE TABLE IF NOT EXISTS S_TEST (FD_CLOB CLOB, FD_DATE DATE);
CREATE INDEX I_S_TEST ON S_TEST (FD_INT);
ALTER TABLE S_TEST ADD COLUMN FD_CLOB CLOB;
ALTER TABLE S_TEST ADD constraint REF_FD  FOREIGN KEY (FD_BIGINT) REFERENCES S_TEST_REF (FD_BIGINT);
ALTER TABLE S_TEST RENAME TO S_TEST_REF;
DROP TABLE S_TEST;
TRUNCATE TABLE S_TEST;
FLASHBACK TABLE S_TEST TO BEFORE DROP;
LOCK TABLE S_TEST IN SHARE MODE NOWAIT;
DROP VIEW S_V_TEST;
CREATE OR REPLACE VIEW S_V_TEST AS SELECT * FROM DUAL;
ANALYZE TABLE S_V_TEST COMPUTE  STATISTICS;
conn / as sysdba
select sleep(1);
drop user USER_TEST cascade;

--SYNONYM FOR FUNCTION
drop user if exists SYN_TEST1 cascade;
CREATE USER SYN_TEST1 IDENTIFIED BY Root1234;
grant dba to SYN_TEST1;
connect SYN_TEST1/Root1234@127.0.0.1:1611
--FIRST ONLY HAS FUNCTION
create or replace function obj_01( a int)
return int
as 
i int default 0;
begin
   i := a * 10 + a;
   return i;
end;
/
create or replace synonym syn_01 for obj_01;
select obj_01(1);
select syn_01(1);

--THEN CREATE TABLE
CREATE TABLE IF NOT EXISTS  obj_01(id int);
insert into obj_01 values(1);
commit;
select obj_01(1);
select * from obj_01;
select syn_01(1);
select * from syn_01;

---FIRST ONLY HAS TABLE
CREATE TABLE IF NOT EXISTS  obj_02(id int);
insert into obj_02 values(1);
commit;
create or replace synonym syn_02 for obj_02;
select * from obj_02;
select * from syn_02;

--THEN CREATE TABLE
create or replace function obj_02( a int)
return int
as 
i int default 0;
begin
   i := a * 10 + a;
   return i;
end;
/
select obj_02(1);
select * from obj_02;
select syn_02(1);
select * from syn_02;

--BOTH HAVE FUNCTION AND TABLE
create or replace function obj_03( a int)
return int
as 
i int default 0;
begin
   i := a * 10 + a;
   return i;
end;
/
CREATE TABLE IF NOT EXISTS  obj_03(id int);
insert into obj_03 values(1);
commit;
create or replace synonym syn_03 for obj_03;
select obj_03(1);
select * from obj_03;
select syn_03(1);
select * from syn_03;

create or replace function syn_dep_func_01 return int
is
A int;
begin
select id into A  from syn_03 limit 1;
return A;
end;
/
select OBJECT_TYPE, STATUS from user_objects where OBJECT_NAME='SYN_DEP_FUNC_01';
drop synonym syn_03;
select OBJECT_TYPE, STATUS from user_objects where OBJECT_NAME='SYN_DEP_FUNC_01';

create or replace function func99(a int) return int
as
b int;
begin
	b:=a;
	return b;
end;
/
create or replace synonym syn_99 for func99;
create or replace procedure proc_99(c int)
as
d int;
begin
	d:=syn_99(c);
end;
/
drop synonym syn_99;
select OBJECT_NAME,OBJECT_TYPE,STATUS from user_objects where OBJECT_NAME='PROC_99';

create or replace synonym syn_99 for func99;
select OBJECT_NAME,OBJECT_TYPE,STATUS from user_objects where OBJECT_NAME='PROC_99';
begin
	DBE_UTIL.COMPILE_SCHEMA('SYN_TEST1',false);
end;
/
select OBJECT_NAME,OBJECT_TYPE,STATUS from user_objects where OBJECT_NAME='PROC_99';

create or replace synonym func99 for func99;
conn / as sysdba
select sleep(1);
drop user SYN_TEST1 cascade;

DROP USER if exists C##USER1 CASCADE;
CREATE USER C##USER1 IDENTIFIED BY Zzw199209;
GRANT DBA TO C##USER1;
ALTER SESSION SET CURRENT_SCHEMA=C##USER1;
CREATE TABLE T1(C1 INT);
INSERT INTO T1 VALUES(12333);
CREATE VIEW V1 AS SELECT * FROM T1;
CREATE PUBLIC SYNONYM ST1 FOR T1;
CREATE PUBLIC SYNONYM SV1 FOR V1;
SELECT * FROM ST1;
SELECT * FROM SV1;
ALTER SESSION SET CURRENT_SCHEMA=SYS;
SELECT * FROM ST1;
SELECT * FROM SV1;
DROP USER C##USER1 CASCADE;
DROP PUBLIC SYNONYM ST1;
DROP PUBLIC SYNONYM SV1;

conn / as sysdba
drop user if exists test_syn cascade;
create user test_syn identified by Cantian_234;
grant dba to test_syn;
conn test_syn/Cantian_234@127.0.0.1:1611

drop table if exists SYN_TAB_001;
create table SYN_TAB_001 (a int,b clob);
--建表的同义词
drop synonym if exists SYN_TAB_SYN_001;
create or replace synonym SYN_TAB_SYN_001 for SYN_TAB_001;
--建视图
drop view if exists SYN_VIEW_001;
create or replace view SYN_VIEW_001 as select * from SYN_TAB_SYN_001;
--建视图的同义词
create or replace synonym SYN_VIEW_SYN_001 for SYN_VIEW_001;
--建自定义函数
create or replace function SYN_FUN_001(c int)return number
as
        d int;
begin
        select count(*) into d from SYN_VIEW_SYN_001 where a=c;
        return d;
end;
/
--建自定义函数同义词
drop synonym if exists SYN_FUN_SYN_001;
create or replace synonym SYN_FUN_SYN_001 for SYN_FUN_001;
--建存储过程
create or replace procedure SYN_PROC_001(a int)
as
c number;
begin
        c:=SYN_FUN_SYN_001(a);
end;
/
-- 建立存储过程同名词
drop synonym if exists SYN_PROC_SYN_001;
create or replace synonym SYN_PROC_SYN_001 for SYN_PROC_001;

-- 建立自定义包
CREATE OR REPLACE PACKAGE SYN_PAK_001
IS
FUNCTION fun_1(a int)RETURN NUMBER;
PROCEDURE proc1(a int);
END SYN_PAK_001;
/

CREATE OR REPLACE PACKAGE BODY SYN_PAK_001
IS

FUNCTION fun_1(a int) RETURN NUMBER
AS
avger NUMBER;
BEGIN
    SYN_PROC_SYN_001(a);
    avger := 3;
return avger;
END;

PROCEDURE proc1(a int)
AS
res int;
BEGIN
    res := fun_1(a);
END;

END SYN_PAK_001;
/

drop synonym if exists SYN_PAG_SYN_001;
create or replace synonym SYN_PAG_SYN_001 for SYN_PAK_001;


create or replace function SYN_FUN_002(c int)return number
as
begin
    return SYN_PAG_SYN_001.fun_1(c);
end;
/


create or replace procedure SYN_PROC_002(a int)
as
c number;
begin
        c:=SYN_FUN_002(a);
        SYN_PAG_SYN_001.proc1(a);
end;
/

select OBJECT_NAME,OBJECT_TYPE,STATUS from MY_OBJECTS where OBJECT_NAME like 'SYN_%' order by OBJECT_NAME,OBJECT_TYPE;
select name, type, REFERENCED_NAME, REFERENCED_TYPE from MY_DEPENDENCIES order by name, type, REFERENCED_NAME;
drop table SYN_TAB_001;
select OBJECT_NAME,OBJECT_TYPE,STATUS from MY_OBJECTS where OBJECT_NAME like 'SYN_%' order by OBJECT_NAME,OBJECT_TYPE;

conn / as sysdba
drop user if exists test_syn cascade;
create user test_syn identified by Cantian_234;
grant dba to test_syn;

conn test_syn/Cantian_234@127.0.0.1:1611
-- 创建表
drop table if exists SYN_TAB_001;
create table SYN_TAB_001 (a int, b varchar(10));

-- 创建表的同义词
drop synonym if exists SYN_TAB_SYN_001;
create or replace synonym SYN_TAB_SYN_001 for SYN_TAB_001;

-- 创建自定义类型
create or replace type SYN_TYPE_001 is table of SYN_TAB_SYN_001%rowtype;
/
-- 创建自定义类型同义词
create or replace synonym SYN_TYPE_SYN_001 for SYN_TYPE_001;

-- 创建存储过程
create or replace procedure SYN_proc_001(a int, b varchar) as
var SYN_TAB_SYN_001%rowtype;
type_var SYN_TYPE_SYN_001;
begin
    var.a := a;
    var.b := b;
    type_var := SYN_TYPE_SYN_001(var);
    dbe_output.print_line(type_var(1).a);
    dbe_output.print_line(type_var(1).b);
end;
/

drop synonym if exists SYN_PROC_SYN_001;
-- 创建存储过程同名词
create or replace synonym SYN_PROC_SYN_001 for SYN_proc_001;

-- 创建自定义包
CREATE OR REPLACE PACKAGE SYN_PAK_001
IS
PROCEDURE proc1(a int, b varchar);
END SYN_PAK_001;
/

CREATE OR REPLACE PACKAGE BODY SYN_PAK_001
IS

PROCEDURE proc1(a int, b varchar)
AS
BEGIN
   SYN_PROC_SYN_001(a, b);
END;

END SYN_PAK_001;
/

-- 创建自定义包同义词
drop synonym if exists SYN_PAG_SYN_001;
create or replace synonym SYN_PAG_SYN_001 for SYN_PAK_001;

call SYN_PAG_SYN_001.proc1(2, 'aab');

select OBJECT_NAME,OBJECT_TYPE,STATUS from MY_OBJECTS where OBJECT_NAME like 'SYN_%' order by OBJECT_NAME,OBJECT_TYPE;
select name, type, REFERENCED_NAME, REFERENCED_TYPE from MY_DEPENDENCIES order by name, type, REFERENCED_NAME;
drop type SYN_TYPE_001;
select OBJECT_NAME,OBJECT_TYPE,STATUS from MY_OBJECTS where OBJECT_NAME like 'SYN_%' order by OBJECT_NAME,OBJECT_TYPE;


--- 同义词功能测试
-- 存储过程同名词
create or replace procedure proc_test_001(i int)
as
begin
    dbe_output.print_line(i);
end;
/

create or replace synonym test_syn_proc for proc_test_001;

call test_syn_proc(1);

create or replace procedure proc_test_001(i int)
as
begin
    dbe_output.print_line(i * 2);
end;
/

call test_syn_proc(1);

create or replace procedure proc_test_002(i int)
as
begin
    dbe_output.print_line(i * 3);
end;
/

create or replace synonym test_syn_proc for proc_test_002;
call test_syn_proc(1);

-- 同名词和存储过程递归测试
create or replace procedure proc_test_002(i int)
as
begin
    dbe_output.print_line(i * 3);
end;
/

create or replace synonym test_syn_proc for proc_test_002;
call test_syn_proc(1);


create or replace procedure proc_test_002(i int)
as
begin
    dbe_output.print_line(i);
    if (i > 0) then
        test_syn_proc(i - 1);
    end if;
end;
/

call test_syn_proc(3);


-- 包的同名词测试
CREATE OR REPLACE PACKAGE SYN_PAK_001
IS
PROCEDURE proc1(a int, b varchar);
END SYN_PAK_001;
/

CREATE OR REPLACE PACKAGE BODY SYN_PAK_001
IS

PROCEDURE proc1(a int, b varchar)
AS
BEGIN
   dbe_output.print_line(a);
   dbe_output.print_line(b);
END;

END SYN_PAK_001;
/

create or replace synonym test_syn_pak for SYN_PAK_001;

call test_syn_pak.proc1(2, 'a');

CREATE OR REPLACE PACKAGE BODY SYN_PAK_001
IS

PROCEDURE proc1(a int)
AS
BEGIN
   dbe_output.print_line(a);
END;

END SYN_PAK_001;
/

call test_syn_pak.proc1(2, 'a');

CREATE OR REPLACE PACKAGE SYN_PAK_001
IS
PROCEDURE proc1(a int);
END SYN_PAK_001;
/

call test_syn_pak.proc1(2);

-- 高级包测试
create or replace synonym dbms_output for sys.dbe_output;

create or replace procedure proc_test_002(i int)
as
begin
    dbms_output.print_line(i * 3);
end;
/

call proc_test_002(2);

-- type 同名词测试

CREATE OR REPLACE TYPE TYPE_DAY FORCE AS OBJECT
( day NUMBER
);
/

create or replace synonym syn_type_day for TYPE_DAY;

CREATE OR REPLACE TYPE TYPE_MONTH FORCE AS OBJECT
( month NUMBER,
  day syn_type_day
);
/

create or replace synonym SYN_TYPE_MONTH for TYPE_MONTH;

CREATE OR REPLACE TYPE TYPE_DAY FORCE AS OBJECT
( year NUMBER,
  month SYN_TYPE_MONTH
);
/

--DTS202104290KSRIEP1E00
DROP PROCEDURE IF EXISTS proc_synonym_001;
CREATE OR REPLACE PROCEDURE proc_synonym_001(param1 IN VARCHAR2,param2 IN VARCHAR2)
IS
BEGIN 
DBE_OUTPUT.PRINT_LINE('Hello Cantian100 OLTP:'||param1||','||param2);
END proc_synonym_001;
/

--自定义函数
DROP TABLE IF EXISTS func_synonym_002;
CREATE TABLE func_synonym_002(ID INT);
INSERT INTO func_synonym_002 VALUES(1);
commit;
CREATE OR REPLACE FUNCTION func_synonym_003(a INT) RETURN INT
AS
c INT;
d INT;
BEGIN
c := a;
SELECT ID INTO d FROM func_synonym_002 WHERE ROWNUM = c;
RETURN d;
END func_synonym_003;
/
SELECT * FROM func_synonym_002 WHERE func_synonym_003(1) = 1;


--创建自定义高级包proc_synonym_004的定义。
DROP PACKAGE IF EXISTS pack_synonym_004;
CREATE OR REPLACE PACKAGE pack_synonym_004
IS
FUNCTION MYF RETURN INT;
PROCEDURE MYP;
END;
/
CREATE OR REPLACE PACKAGE BODY pack_synonym_004
IS
FUNCTION MYF RETURN INT
IS
V1 INT := 10;
BEGIN
NULL;
RETURN V1;
END;
PROCEDURE MYP IS
V1 INT;
BEGIN
SELECT MYF INTO V1 FROM SYS_DUMMY;
DBE_OUTPUT.PRINT_LINE(V1);
END;
END;
/
CALL pack_synonym_004.MYP;

CREATE OR REPLACE TYPE type_synonym_006 IS object(
name varchar(20),
city varchar(20)
);
/

--记录类型嵌套集合类型
CREATE OR REPLACE TYPE type_synonym_009 IS VARRAY(20) OF varchar(10);
/

create OR REPLACE synonym SVP_PROC_SYNONYM_002 for proc_synonym_001;
create or replace public synonym svpps_proc_synonym_002 for proc_synonym_001;
create or replace synonym svp_func1_synonym_003 for func_synonym_003;
create or replace public synonym svpps_func_synonym_003 for func_synonym_003;
create or replace synonym svp_type1_synonym_006 for type_synonym_006;
create or replace public synonym svpps_type1_synonym_009 for type_synonym_009;
create or replace synonym svp_DBE_OUTPUT for SYS.DBE_OUTPUT;
create or replace public synonym svpps_DBE_OUTPUT for SYS.DBE_OUTPUT;
create or replace synonym svp_pack_synonym_004 for pack_synonym_004;
create or replace public synonym svpps_pack_synonym_004 for pack_synonym_004;
select * from DB_SYNONYMS where SYNONYM_NAME like 'SVP%' order by SYNONYM_NAME;
DROP PROCEDURE IF EXISTS proc_synonym_001;
DROP TABLE IF EXISTS func_synonym_002;
drop FUNCTION IF EXISTS func_synonym_003;
DROP PACKAGE IF EXISTS pack_synonym_004;
DROP TYPE IF EXISTS type_synonym_006;
DROP TYPE IF EXISTS type_synonym_009;
drop synonym IF EXISTS SVP_PROC_SYNONYM_002;
drop synonym IF EXISTS svp_func1_synonym_003;
drop synonym IF EXISTS svp_type1_synonym_006;
drop synonym IF EXISTS svp_DBE_OUTPUT;
drop synonym IF EXISTS svp_pack_synonym_004;
drop public synonym IF EXISTS svpps_proc_synonym_002;
drop public synonym IF EXISTS svpps_func_synonym_003;
drop public synonym IF EXISTS svpps_type1_synonym_009;
drop public synonym IF EXISTS svpps_DBE_OUTPUT;
drop public synonym IF EXISTS svpps_pack_synonym_004;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists test_syn cascade;