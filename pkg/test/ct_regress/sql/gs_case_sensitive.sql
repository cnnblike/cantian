DROP TRIGGER IF EXISTS TRIG_OBJECTID;
DROP PROCEDURE IF EXISTS PROC_OBJECTID;
DROP FUNCTION IF EXISTS FUNC_OBJECTID;
DROP TABLE IF EXISTS T_TEMP_OBJECTID;
DROP VIEW IF EXISTS V_OBJECTID;
DROP TABLE IF EXISTS T_OBJECTID;

--make name case sensitive
alter system set upper_case_table_names = false;
alter system set use_native_datatype = true;
--restart db
--shutdown immediate;
--startup;
--conn sys/Huawei@123@127.0.0.1:1611

--table & columns
drop table if exists cs_t1;
drop table if exists CS_T1;
create table cs_t1(f1 int, F1 int);
create table CS_T1(f2 int, F2 int);

SELECT COUNT(1) FROM SYS_TABLES WHERE NAME = 'cs_t1';
SELECT COUNT(1) FROM SYS_TABLES WHERE NAME = 'CS_T1';
SELECT COUNT(1) FROM SYS_TABLES WHERE NAME = 'CS_t1';

--dml
insert into cs_t1(f1,F1) values(1,2),(3,4);
select f1,F1 from cs_t1;
update cs_t1 set f1=2,F1=3 where F1=4;
insert into CS_T1(f2,F2) values(1,2),(3,4);
select f1,f2 from cs_t1 INNER JOIN CS_T1 on f1=f2; 
MERGE INTO cs_t1 using CS_T1 on(cs_t1.f1 = CS_T1.f2) 
  when matched then update set cs_t1.F1 = CS_T1.F2
  when not matched then insert (f1,F1) values(CS_T1.f2, CS_T1.F2);
delete from cs_t1 where f1 = 1;
commit;

--index
alter table cs_t1 add constraint pk_cs_t1 primary key(f1);
create index idx_cs_t1 on cs_t1(F1);
alter table CS_T1 add constraint PK_CS_T1 primary key(f2); 
create index IDX_CS_T1 on CS_T1(F2);
alter table CS_T1 drop constraint PK_CS_T1;
create index idx_CS_T1 ON CS_T1(f2);

--view
drop view if exists v_cs_t1;
drop view if exists V_CS_T1;
create view v_cs_t1(v_f1, V_F1) as select f1,F1 from cs_t1;
select * from v_cs_t1;
create view V_CS_T1(v_f2, V_F2) AS SELECT f2, F2 From CS_T1;
select * from V_CS_T1;
UPDATE CS_T1 SET F2 = f2+1, f2 = F2 - 2;
select * from V_CS_T1;
commit;

drop table if exists cs_t1;
drop table if exists CS_T1;
drop view if exists v_cs_t1;
drop view if exists V_CS_T1;

--tablespace

--procedures
set serveroutput on;
CREATE OR REPLACE PROCEDURE Zenith_Test_001
AS
Begin
  dbe_output.print_line('Hello Zenith');
end Zenith_Test_001;
/
call Zenith_Test_001;
call ZENITH_TEST_001;

CREATE OR REPLACE PROCEDURE ZENITH_TEST_001
AS
Begin
  dbe_output.print_line('HELLO ZENITH');
end ZENITH_TEST_001;
/
call ZENITH_TEST_001;

DROP PROCEDURE IF EXISTS Zenith_Test_001;
DROP PROCEDURE IF EXISTS ZENITH_TEST_001;

drop table if exists emp_test;
create table emp_test(empno number,ename varchar2(100),job varchar2(100), sal number);
insert into emp_test values(1,'wanghaifeng','doctor1',10000);

--succ
CREATE OR REPLACE PROCEDURE syscur(sys_cur OUT SYS_REFCURSOR) 
IS 
C1 SYS_REFCURSOR; 
BEGIN 
OPEN C1 FOR
    SELECT empno,ename FROM emp_test  where empno=1 ORDER BY empno; 
sys_cur := C1; 
END; 
/

--fail_by_table_not_exists
CREATE OR REPLACE PROCEDURE syscur_1(sys_cur OUT SYS_REFCURSOR) 
IS 
C1 SYS_REFCURSOR; 
BEGIN 
OPEN C1 FOR
    SELECT empno,ename FROM EMP_test  where empno=1 ORDER BY empno; 
sys_cur := C1; 
END; 
/
--fail_by_col_not_exists
CREATE OR REPLACE PROCEDURE syscur_2(sys_cur OUT SYS_REFCURSOR) 
IS 
C1 SYS_REFCURSOR; 
BEGIN 
OPEN C1 FOR
    SELECT EMPNO,ename FROM emp_test  where empno=1 ORDER BY empno; 
sys_cur := C1; 
END; 
/

--succ
DECLARE
  cv SYS_REFCURSOR;
  v_sal   emp_test.sal%type;
  v_sal_mul     emp_test.sal%type;
  factor   integer :=2;
BEGIN
    open cv for
          select sal,sal*factor from emp_test where job like '%1' and sal < 13000 order by sal;
    loop
    fetch cv into v_sal,v_sal_mul;
    exit when cv%notfound;
    dbe_output.print_line('factor ='||factor||';');
    dbe_output.print_line('sal ='||v_sal||';');
    dbe_output.print_line('sal_mul ='||v_sal_mul||';');
    factor :=factor+1;

  END LOOP;
  close cv;
end;
/
--failed_by_tab_not_exists
DECLARE
  cv SYS_REFCURSOR;
  v_sal   EMP_test.sal%type;
  v_sal_mul     emp_test.sal%type;
  factor   integer :=2;
BEGIN
    open cv for
          select sal,sal*factor from emp_test where job like '%1' and sal < 13000 order by sal;
    loop
    fetch cv into v_sal,v_sal_mul;
    exit when cv%notfound;
    dbe_output.print_line('factor ='||factor||';');
    dbe_output.print_line('sal ='||v_sal||';');
    dbe_output.print_line('sal_mul ='||v_sal_mul||';');
    factor :=factor+1;

  END LOOP;
  close cv;
end;
/
--failed_by_col_not_exists
DECLARE
  cv SYS_REFCURSOR;
  v_sal   emp_test.SAL%type;
  v_sal_mul     emp_test.sal%type;
  factor   integer :=2;
BEGIN
    open cv for
          select sal,sal*factor from emp_test where job like '%1' and sal < 13000 order by sal;
    loop
    fetch cv into v_sal,v_sal_mul;
    exit when cv%notfound;
    dbe_output.print_line('factor ='||factor||';');
    dbe_output.print_line('sal ='||v_sal||';');
    dbe_output.print_line('sal_mul ='||v_sal_mul||';');
    factor :=factor+1;

  END LOOP;
  close cv;
end;
/

set serveroutput off;

DROP PROCEDURE syscur;
DROP PROCEDURE syscur_1;
DROP PROCEDURE syscur_2;
drop table if exists emp_test;

--triggers
drop table if exists T_TRIG_1;
drop table if exists T_TRIG_2;
drop table if exists T_TRIG_3;
CREATE TABLE T_TRIG_1 (F_INT1 INT, F_INT2 INT, F_CHAR1 CHAR(16), F_DATE DATE);
CREATE TABLE T_TRIG_2 (F_INT1 INT, F_INT2 INT, F_CHAR1 CHAR(16), F_DATE DATE);
CREATE TABLE T_TRIG_3 (F_INT1 INT, F_INT2 INT, F_CHAR1 CHAR(16), F_DATE DATE);


--:new or :old.col case sensitive
CREATE OR REPLACE TRIGGER trig_BEFORE_STMT BEFORE INSERT OR UPDATE OF F_INT1 ON T_TRIG_1
FOR EACH ROW
BEGIN
  INSERT INTO T_TRIG_2 VALUES(:old.F_INT2, :NEW.f_int1, :old.F_CHAR1,:NEW.F_DATE);
END;
/

--update of col case sensitive
CREATE OR REPLACE TRIGGER trig_BEFORE_STMT BEFORE INSERT OR UPDATE OF f_int1 ON T_TRIG_1
FOR EACH ROW
BEGIN
  INSERT INTO T_TRIG_2 VALUES(:old.F_INT2, :NEW.F_INT1, :old.F_CHAR1,:NEW.F_DATE);
END;
/

-- on table case sensitive
CREATE OR REPLACE TRIGGER trig_BEFORE_STMT BEFORE INSERT OR UPDATE OF F_INT1 ON t_trig_1
FOR EACH ROW
BEGIN
  INSERT INTO T_TRIG_2 VALUES(:old.F_INT2, :NEW.F_INT1, :old.F_CHAR1,:NEW.F_DATE);
END;
/

--trigger name 
CREATE OR REPLACE TRIGGER trig_BEFORE_STMT BEFORE INSERT OR UPDATE OF F_INT1 ON T_TRIG_1
FOR EACH ROW
BEGIN
  INSERT INTO T_TRIG_2 VALUES(:old.F_INT2, :NEW.F_INT1, :old.F_CHAR1,:NEW.F_DATE);
END;
/

CREATE OR REPLACE TRIGGER TRIG_BEFORE_STMT BEFORE INSERT OR UPDATE OF F_INT1 ON T_TRIG_1
FOR EACH ROW
BEGIN
  INSERT INTO T_TRIG_3 VALUES(:NEW.F_INT1, :OLD.F_INT2, :OLD.F_CHAR1,:NEW.F_DATE);
END;
/

INSERT INTO T_TRIG_1 VALUES(1,2,'A','2017-12-11 14:08:00');
INSERT INTO T_TRIG_1 VALUES(3,4,'C','2017-12-12 16:08:00');
INSERT INTO T_TRIG_1 VALUES(1,3,'A','2017-12-11 14:18:00');
INSERT INTO T_TRIG_1 VALUES(2,3,'B','2017-12-11 16:08:00');
SELECT * FROM T_TRIG_1 ORDER BY F_INT1,F_INT2,F_CHAR1,F_DATE;
SELECT * FROM T_TRIG_2 ORDER BY F_INT1,F_INT2,F_CHAR1,F_DATE;
SELECT * FROM T_TRIG_3 ORDER BY F_INT1,F_INT2,F_CHAR1,F_DATE;

DROP TRIGGER IF EXISTS TRIG_BEFORE_STMT;
DROP TRIGGER IF EXISTS trig_BEFORE_STMT;
DROP TABLE T_TRIG_1;
DROP TABLE T_TRIG_2;
DROP TABLE T_TRIG_3;

--user defined functions
CREATE OR REPLACE FUNCTION Zenith_Test_HW return varchar2
IS
 cunt varchar2(20);
 Begin
 select 'Hello' into cunt from DUAL;
 dbe_output.print_line(cunt);
 IF SQL % FOUND
  then
 return cunt;
 end if;
 End Zenith_Test_HW;
/

CREATE OR REPLACE FUNCTION ZENITH_TEST_HW return varchar2
IS
 cunt varchar2(20);
 Begin
 select 'World' into cunt from DUAL;
 dbe_output.print_line(cunt);
 IF SQL % FOUND
  then
 return cunt;
 end if;
 End ZENITH_TEST_HW;
/

--select
select Zenith_Test_HW(),ZENITH_TEST_HW() from DUAL;

DROP FUNCTION Zenith_Test_HW;
DROP FUNCTION ZENITH_TEST_HW;

--sequence
drop sequence if exists seqtext;
drop sequence if exists SEQTEXT;
create sequence seqtext start with 1 increment by 1 minvalue 1 maxvalue 100000000000 cache 100 nocycle;
create sequence SEQTEXT start with 1 increment by 1 minvalue 1 maxvalue 100000000000 cache 100 nocycle;
select seqtext.nextval, SEQTEXT.NEXTVAL FROM DUAL;
select seqtext.currval, SEQTEXT.CURRVAL FROM DUAL;


--object_id()
DROP VIEW IF EXISTS v_objectid;
DROP TABLE IF EXISTS t_objectid;
DROP TABLE IF EXISTS t_temp_objectid;
CREATE TABLE t_objectid (col1 INTEGER NOT NULL, col2 VARCHAR(32));
CREATE TABLE t_temp_objectid (col1 INTEGER NOT NULL, col2 VARCHAR(32));
CREATE USER tempuser IDENTIFIED BY Asdf1234;
CREATE VIEW v_objectid AS SELECT col1 FROM t_objectid;

INSERT  INTO t_temp_objectid VALUES (1, 't_objectid');
COMMIT;

SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('t_objectid') AND OBJECT_TYPE='TABLE';  --1 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('T_OBJECTID') AND OBJECT_TYPE='TABLE';  --0 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID IN (SELECT OBJECT_ID(col2, 'table') AS id FROM t_temp_objectid WHERE col2 = 't_objectid') AND OBJECT_TYPE='TABLE'; --1 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('SYS_TABLES','TABLE') AND OBJECT_TYPE='TABLE';  --1 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('sys_tables','TABLE') AND OBJECT_TYPE='TABLE';  --0 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('SYS_TABLES','TABLE','tempuser') AND OBJECT_TYPE='TABLE';  --0 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('SYS_TABLES','TABLE','sys') AND OBJECT_TYPE='TABLE';  --1 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('t_temp_objectid') AND OBJECT_TYPE='TABLE'; --1 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('T_TEMP_OBJECTID') AND OBJECT_TYPE='TABLE'; --0 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('v_objectid', 'view') AND OBJECT_TYPE='VIEW'; --1 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('V_OBJECTID', 'view') AND OBJECT_TYPE='VIEW'; --0 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID(TRIM('  t_objectid  '), 'TABLE') AND OBJECT_TYPE='TABLE';  --1 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID(TRIM('  T_OBJECTID  '), 'TABLE') AND OBJECT_TYPE='TABLE';  --0 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID IN (SELECT OBJECT_ID(TRIM(col2), 'TABLE', 'sys') FROM t_temp_objectid WHERE col1=1) AND OBJECT_TYPE='TABLE';  --1 row found
SELECT  OBJECT_NAME FROM DB_OBJECTS WHERE OBJECT_ID=OBJECT_ID('DV_DATABASE', 'DYNAMIC VIEW') AND OBJECT_TYPE='DYNAMIC VIEW';  --1 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('dv_database', 'DYNAMIC VIEW') AND OBJECT_TYPE='DYNAMIC VIEW';  --0 row found

CREATE OR REPLACE TRIGGER trig_objectid
BEFORE INSERT OR UPDATE OF col1 OR DELETE ON t_objectid
BEGIN
  INSERT INTO t_temp_objectid VALUES(100,'triggered');
END;
/

CREATE PROCEDURE proc_objectid(param1 out varchar2)
IS
    tmp varchar2(20) :='12345678';
begin
 param1:=param1||tmp;
end proc_objectid;
/

CREATE FUNCTION case_func_objectid(A varchar)
RETURN varchar
AS
BEGIN
   if (case_func_objectid(A) = 'ab') then
   	return A;
   else
   	return case_func_objectid(A);
   end if; 
END;
/

SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('trig_objectid', 'trigger') AND OBJECT_TYPE='TRIGGER'; --1 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('TRIG_OBJECTID', 'trigger') AND OBJECT_TYPE='TRIGGER'; --0 row found
SELECT  NAME FROM SYS_PROCS WHERE OBJ# = OBJECT_ID('trig_objectid', 'trigger') AND SCN2DATE(ORG_SCN) IN (SELECT CREATED FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('trig_objectid', 'trigger') AND OBJECT_TYPE='TRIGGER'); --1 row found
SELECT  NAME FROM SYS_PROCS WHERE OBJ# = OBJECT_ID('TRIG_OBJECTID', 'trigger') AND SCN2DATE(ORG_SCN) IN (SELECT CREATED FROM ALL_OBJECTS WHERE OBJECT_ID=OBJECT_ID('trig_objectid', 'trigger') AND OBJECT_TYPE='TRIGGER'); --0 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('proc_objectid', 'procedure') AND OBJECT_TYPE='PROCEDURE'; --1 row found
SELECT  OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('PROC_OBJECTID', 'procedure') AND OBJECT_TYPE='PROCEDURE'; --0 row found

SELECT  NAME FROM SYS_PROCS WHERE OBJ# = OBJECT_ID('proc_objectid', 'procedure') AND SCN2DATE(ORG_SCN) IN (SELECT CREATED FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('proc_objectid', 'procedure') AND OBJECT_TYPE='PROCEDURE'); --1 row found
SELECT  NAME FROM SYS_PROCS WHERE OBJ# = OBJECT_ID('PROC_OBJECTID', 'procedure') AND SCN2DATE(ORG_SCN) IN (SELECT CREATED FROM ALL_OBJECTS WHERE OBJECT_ID=OBJECT_ID('proc_objectid', 'procedure') AND OBJECT_TYPE='PROCEDURE'); --0 row found
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('case_func_objectid', 'function') AND OBJECT_TYPE='FUNCTION'; --1 row found
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('CASE_FUNC_OBJECTID', 'function') AND OBJECT_TYPE='FUNCTION'; --0 row found

SELECT NAME FROM SYS_PROCS WHERE OBJ# = OBJECT_ID('case_func_objectid', 'function') AND SCN2DATE(ORG_SCN) IN (SELECT CREATED FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('case_func_objectid', 'function') AND OBJECT_TYPE='FUNCTION'); --1 row found
SELECT NAME FROM SYS_PROCS WHERE OBJ# = OBJECT_ID('CASE_FUNC_OBJECTID', 'function') AND SCN2DATE(ORG_SCN) IN (SELECT CREATED FROM ALL_OBJECTS WHERE OBJECT_ID=OBJECT_ID('case_func_objectid', 'function') AND OBJECT_TYPE='FUNCTION'); --0 row found

DROP TRIGGER trig_objectid;
DROP PROCEDURE proc_objectid;
DROP FUNCTION case_func_objectid;
DROP USER tempuser CASCADE;
DROP TABLE t_temp_objectid;
DROP VIEW v_objectid;
DROP TABLE t_objectid;

--user defined function
create user testuser identified by 'Cantian_234';
grant connect,resource,dba to testuser;

CREATE OR REPLACE FUNCTION testuser.Zenith_Test_HW return varchar2
IS
 cunt varchar2(20);
 Begin
 select 'Hello' into cunt from DUAL;
 dbe_output.print_line(cunt);
 IF SQL % FOUND
  then
 return cunt;
 end if;
 End Zenith_Test_HW;
/
select  TestUser.Zenith_Test_HW() from DUAL;

CREATE OR REPLACE PROCEDURE testuser.Zenith_Test_001
AS
Begin
  dbe_output.print_line('Hello Zenith');
end Zenith_Test_001;
/
call  TestUser.Zenith_Test_001;

drop user testuser cascade;

--DTS2018101005381
drop user if exists cs_user1;
drop user if exists cs_user2;
create tablespace SPC_test_1 datafile 'spc_file_1' size 50m reuse;
create user cs_user1 identified by 'Changeme_123' default tablespace spc_test_1;--error
create user cs_user2 identified by 'Changeme_123' default tablespace SPC_test_1;--succ
drop user if exists cs_user1;
drop user if exists cs_user2;
alter tablespace SPC_test_1 rename to SPC_test_2;
drop tablespace SPC_test_2 including contents and datafiles;

--DTS2018120703423
conn sys/Huawei@123@127.0.0.1:1611
--DTS2019041010374 
--make name case insensitive
alter system set upper_case_table_names = false;
--DTS2019041010374 
drop table if exists test_part_t1;
create table test_part_t1(f1 int, f2 real, f3 number, f4 char(300), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f1)
(
PARTITION p1 values less than(10),
PARTITION p2 values less than(20),
PARTITION p3 values less than(30),
PARTITION p4 values less than(MAXVALUE)
);
create index idx_t1_1 on test_part_t1(f2,f3) local;
create index idx_t1_2 on test_part_t1(f4,f5) local;
insert into test_part_t1 values(5, 15, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'),to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(6, 16, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'),to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(5, 15, 28, 'abcde', 'abcde', to_date('2018/01/24', 'YYYY/MM/DD'),to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(6, 16, 29, '161', '291', to_date('2018/01/24', 'YYYY/MM/DD'),to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
commit;
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','test_part_t1');
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','test_part_t1', 'idx_t1_1');
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','TEST_PART_T1');
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','TEST_PART_T1','IDX_T1_2');
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','test_part_t1','idx_t1_2');
select * from table(dba_analyze_table('sys','test_part_t1'));
select * from table(dba_analyze_table('SYS','TEST_PART_T1'));
select * from table(dba_analyze_table('SYS','test_part_t1'));
drop table if exists test_part_t1;

alter system set upper_case_table_names = true;
drop table if exists test_part_t1;
drop view if exists v_test_part_t1;
create table test_part_t1(f1 int, f2 real, f3 number, f4 char(300), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f1)
(
PARTITION p1 values less than(10),
PARTITION p2 values less than(20),
PARTITION p3 values less than(30),
PARTITION p4 values less than(MAXVALUE)
);
create index idx_t1_1 on test_part_t1(f2,f3) local;
create index idx_t1_2 on test_part_t1(f4,f5) local;
insert into test_part_t1 values(5, 15, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'),to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(6, 16, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'),to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(5, 15, 28, 'abcde', 'abcde', to_date('2018/01/24', 'YYYY/MM/DD'),to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(6, 16, 29, '161', '291', to_date('2018/01/24', 'YYYY/MM/DD'),to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
commit;
create view v_test_part_t1 as select * from test_part_t1;
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','test_part_t1');
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','TEST_PART_T1');
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','TEST_PART_T1','IDX_T1_2');
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'sys','test_PART_T1','IDX_t1_2');
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','TEST_PART_T1','IDX_T1_2');
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','test_part_t1','idx_t1_2');
select * from table(dba_analyze_table('sys','test_part_t1'));
select * from table(dba_analyze_table('SYS','TEST_PART_T1'));
drop table if exists test_part_t1;
drop view if exists v_test_part_t1;

drop table if exists tbl_dq_chk;
create table tbl_dq_chk(a int, "b" varchar(20));
drop table if exists tbl_dq_mrg;
create table tbl_dq_mrg(a int, "b" varchar(20));

begin
  merge into tbl_dq_mrg v2 using (select a from tbl_dq_chk) v1 on (v1.a = v2.a) when matched then update set v2."b" = upper(to_char(v1.a));
  dbe_output.print_line('OK');
end;
/


--test package name
--beign
alter system set upper_case_table_names = false;
CREATE OR REPLACE PACKAGE pl_pkg_name_case1
IS
procedure proc1(a in int);

FUNCTION fun1
(cnum IN char)
RETURN NUMBER;

END pl_pkg_name_case1;
/

CREATE OR REPLACE PACKAGE BODY pl_pkg_name_case1
IS
FUNCTION fun1
(cnum IN char)
RETURN NUMBER
AS
avger NUMBER;
BEGIN
SELECT count(*) INTO avger FROM dual;
RETURN(avger);
END fun1;

procedure proc1(a in int)
AS
avger NUMBER;
BEGIN
avger :=1;
END proc1;

END pl_pkg_name_case1;
/

SELECT OBJECT_NAME, OBJECT_TYPE,STATUS FROM MY_OBJECTS WHERE OBJECT_NAME IN ('pl_pkg_name_case1') ORDER BY OBJECT_NAME,OBJECT_TYPE;

select pl_pkg_name_case1.fun1('a') from dual;
select PL_PKG_NAME_CASE1.fun1('a') from dual;
select pl_pkg_name_case1.FUN1('a') from dual;
select PL_PKG_NAME_CASE1.FUN1('a') from dual;

begin
	pl_pkg_name_case1.proc1(1);
end;	
/

drop PACKAGE pl_pkg_name_case1;
--end


alter system set upper_case_table_names = true;
create user "test1" identified by Cantian_234;
grant create session to "test1";
grant create table to "test1";
conn test1/Cantian_234@127.0.0.1:1611
create table "tab%"(id int);
conn / as sysdba
create user "test2" identified by Cantian_234;
grant create session to "test2";
conn test1/Cantian_234@127.0.0.1:1611
grant select on "tab%" to "test2";
conn test2/Cantian_234@127.0.0.1:1611
select * from "test1"."tab%";
conn sys/Huawei@123@127.0.0.1:1611
drop user "test1" cascade;
drop user "test2" cascade;

alter system SET UPPER_CASE_TABLE_NAMES = false;
drop table if exists upper_name_false_2_jdd;
create table upper_name_false_2_jdd (a int,A INT,b int);
alter table upper_name_false_2_jdd add constraint cc check(a is not null);
alter table upper_name_false_2_jdd add constraint CC check(A is not null);
alter table upper_name_false_2_jdd add constraint DD check(B is not null);
alter table upper_name_false_2_jdd add constraint DD check(b is not null);

alter table upper_name_false_2_jdd drop constraint cc;
alter table upper_name_false_2_jdd drop constraint CC;
alter table upper_name_false_2_jdd drop constraint DD;
alter system set upper_case_table_names = true;
drop table if exists upper_name_false_2_jdd;

alter system SET UPPER_CASE_TABLE_NAMES = false;
drop function if exists test_f1;
create function test_f1(a int) return int
IS
Begin
return a*-1;
End;
/

drop function if exists TEST_F1;
create function TEST_F1(a int) return int
IS
Begin
return a*6;
End;
/

drop table if exists upper_name_false_2_jdd;
create table upper_name_false_2_jdd (id int, a int default 123,A INT default TEST_F1(2), b int default test_f1(2));
insert into upper_name_false_2_jdd(id) values (1);
select * from upper_name_false_2_jdd;
alter system set upper_case_table_names = true;
drop table if exists upper_name_false_2_jdd;
drop function if exists test_f1;
drop function if exists TEST_F1;

alter system SET UPPER_CASE_TABLE_NAMES = false;
DROP TABLE if exists returning_clasu_in_func_test;
CREATE TABLE returning_clasu_in_func_test(id int NOT NULL, a varchar(100) default '111', A varchar(100) default '222');

drop index if exists xxx_json_test_idx on returning_clasu_in_func_test;
drop index if exists xxx_json_test_idx_1 on returning_clasu_in_func_test;
truncate table returning_clasu_in_func_test;

create unique index xxx_json_test_idx on returning_clasu_in_func_test(UPPER(a));
create unique index xxx_json_test_idx_1 on returning_clasu_in_func_test(upper(A));

insert into returning_clasu_in_func_test(id) values(1);
insert into returning_clasu_in_func_test(id, a) values(1, 'dfs');
insert into returning_clasu_in_func_test(id, A) values(1, 'dsdsd');
select * from returning_clasu_in_func_test;
alter system SET UPPER_CASE_TABLE_NAMES = true;
drop index if exists xxx_json_test_idx on returning_clasu_in_func_test;
drop index if exists xxx_json_test_idx_1 on returning_clasu_in_func_test;
DROP TABLE if exists returning_clasu_in_func_test;

--DTS2019080210078
create or replace package pack1 is
function f2 return number;
end;
/
create or replace package body pack1 is
function f2 return number 
as
a number;
begin
a:= 1;
return(a);
end f2;
end pack1;
/
select object_name,object_type from all_procedures where object_name='PACK1';
select object_name,object_type from dba_procedures where object_name='PACK1';
select object_name,object_type from user_procedures where object_name='PACK1';
select object_name,object_type from adm_procedures where object_name='PACK1';
select object_name,object_type from db_procedures where object_name='PACK1';
select object_name,object_type from my_procedures where object_name='PACK1';
drop package if exists pack1;