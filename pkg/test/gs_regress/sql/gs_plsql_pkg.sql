--
-- USER DEFINED PACKAGE
--
set serveroutput on;
create table tt1_t(a int);
insert into tt1_t values(10);
commit;
drop user if exists liu_test_compile_schema cascade;
create user liu_test_compile_schema identified by Lh00420062;
grant dba to liu_test_compile_schema;
conn liu_test_compile_schema/Lh00420062@127.0.0.1:1611
CREATE OR REPLACE PACKAGE DD
IS
FUNCTION MYF RETURN INT;
END;
/

CREATE OR REPLACE PACKAGE BODY DD
IS
FUNCTION MYF RETURN INT
IS
V1 INT := 10;
BEGIN
select a into v1 from sys.tt1_t;
RETURN V1;
END;
END;
/
create or replace function myf1 return int
is
a1 int;
begin
a1 := dd.myf();
end;
/

conn sys/Huawei@123@127.0.0.1:1611
drop table tt1_t;
call dbe_util.compile_schema('liu_test_compile_schema',false);
drop user if exists liu_test_compile_schema cascade;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_plsql_pkg cascade;
create user gs_plsql_pkg identified by Lh00420062;
grant all privileges to gs_plsql_pkg;
conn gs_plsql_pkg/Lh00420062@127.0.0.1:1611

create or replace package AAAA1 
AS 
FUNCTION max(ID INT,id2 out int ) RETURN INT;
END;
/
CREATE OR REPLACE package BODY AAAA1
AS 
FUNCTION max(ID INT,id2 out int) RETURN INT
AS 
A INT;
BEGIN
A := 1;
RETURN A;
END;
END;
/
create or replace package AAAA2 
AS 
FUNCTION A2(ID INT) RETURN INT;
END;
/
create or replace package BODY  AAAA2 
AS 
FUNCTION A2(ID INT) RETURN INT
AS
A INT;
b int;
BEGIN
A :=AAAA1.max(1,b);
RETURN A ;
END;
END;
/
create or replace package AAAA1 
AS 
FUNCTION A1(ID INT) RETURN INT;
END;
/

CREATE OR REPLACE package BODY AAAA1
AS 
FUNCTION A1(ID INT) RETURN INT
AS
A INT;
BEGIN
A :=AAAA2.A2(1);
RETURN A;
END;
END;
/

select AAAA1.A1(1) from dual;
select AAAA2.A2(1) from dual;

create or replace package AAAA2 
AS 
FUNCTION A2(ID INT) RETURN INT;
END;
/
create or replace package BODY AAAA2 
AS 
FUNCTION A2(ID INT) RETURN INT
AS
A INT;
BEGIN
A :=AAAA1.A1(1);
RETURN A ;
END;
END;
/

create or replace package AAAA1 
AS 
FUNCTION max(ID INT,id2 out int ) RETURN INT;
END;
/
CREATE OR REPLACE package BODY AAAA1
AS 
FUNCTION max(ID INT,id2 out int) RETURN INT
AS 
A INT;
BEGIN
A :=1;
RETURN A;
END;
END;
/
create or replace package AAAA2 
AS 
FUNCTION A2(ID INT) RETURN INT;
END;
/
create or replace package BODY  AAAA2 
AS 
FUNCTION A2(ID INT) RETURN INT
AS
A INT;
b int;
BEGIN
A :=AAAA1.max(1,b);
RETURN A ;
END;
END;
/
create or replace package AAAA1 
AS 
FUNCTION A1(ID INT) RETURN INT;
END;
/
CREATE OR REPLACE package BODY AAAA1
AS 
A INT;
FUNCTION A1(ID INT) RETURN INT
AS
BEGIN
A :=AAAA2.A2(1);
RETURN A;
END;
END;
/
create or replace package AAAA2 
AS 
FUNCTION A2(ID INT) RETURN INT;
END;
/
create or replace package BODY AAAA2 
AS 
FUNCTION A2(ID INT) RETURN INT
AS
A INT;
BEGIN
A :=AAAA1.A1(1);
RETURN A ;
END;
END;
/
select AAAA1.A1(1) from dual;
select AAAA2.A2(1) from dual;
conn sys/Huawei@123@127.0.0.1:1611
drop user gs_plsql_pkg cascade;
drop table if exists pkg_t1;
create table pkg_t1 (f1 int, f2 int);
insert into pkg_t1(f1, f2) values (1, 2);
insert into pkg_t1(f1, f2) values (2, 3);
commit;

drop package if exists test_pkg1;

--test case 1: create package without package body
--expect success with warning
CREATE PACKAGE test_pkg1
IS

FUNCTION fun1
(cnum IN char1)
RETURN NUMBER;

procedure proc1(a in int);

END test_pkg1;
/

--expect success
drop package if exists test_pkg1;
CREATE PACKAGE test_pkg1
IS

FUNCTION fun1
(cnum IN char)
RETURN NUMBER;

END test_pkg1;
/

--expect success with warning
drop package if exists test_pkg1;
CREATE PACKAGE test_pkg1
IS

FUNCTION fun1(cnum IN char)
RETURN NUMBER

;

FUNCTION fun1
(cnum IN int)
RETURN NUMBER;

END test_pkg1;
/

--expect success with warning
drop package if exists test_pkg1;
CREATE PACKAGE test_pkg1
IS

FUNCTION fun1(cnum IN char)
RETURN NUMBER

;

procedure fun1(a in int);

END test_pkg1;
/



--expect success  with warning
drop package if exists test_pkg1;
CREATE PACKAGE test_pkg1
IS

v_int int;

FUNCTION fun1
(cnum IN char)
RETURN NUMBER;

END test_pkg1;
/

--expect error
CREATE PACKAGE test_pkg1
IS

FUNCTION fun1
(cnum IN char)
RETURN NUMBER;

END test_pkg1;
/

--test case2: create or replace package without package body
--expect success with warning
CREATE OR REPLACE PACKAGE test_pkg1
IS

FUNCTION fun1
(cnum IN char)
RETURN NUMBER;

FUNCTION fun2
RETURN NUMBER
IS;

procedure proc1(a in int);

END test_pkg1;
/

--expect error:Package or function TEST_PKG1 is in an invalid state
select test_pkg1.fun1('a') from dual;
--expect invalid
select object_name, object_type,status from my_objects where object_name='TEST_PKG1' order by object_type;

--expect success without warning
CREATE OR REPLACE PACKAGE test_pkg1
IS

FUNCTION fun1
(cnum IN char)
RETURN NUMBER
;

FUNCTION fun2
RETURN NUMBER;

procedure proc1(a in int)
;

END test_pkg1;
/

--expect error
select test_pkg1.fun1('a') from dual;
select test_pkg1.fun5('a') from dual;
--expect valid
select object_name, object_type,status from my_objects where object_name='TEST_PKG1' order by object_type;
drop package test_pkg1;

--Creating SERIALLY_REUSABLE Packages
--expect success with warning
CREATE OR REPLACE PACKAGE BODILESS_PKG IS
  PRAGMA SERIALLY_REUSABLE;
  n NUMBER := 5;
END;
/

--expect success with warning
CREATE OR REPLACE PACKAGE BODILESS_PKG IS
  n NUMBER := 5;
END;
/
select object_name, object_type,status from my_objects where object_name='BODILESS_PKG' order by object_type;
drop package BODILESS_PKG;


--test case 3: create package body without package
drop package body if exists test_pkg2;
drop package if exists test_pkg2;
--expect success with warning
CREATE PACKAGE BODY test_pkg2
IS

FUNCTION fun1
(cnum IN char)
RETURN NUMBER
AS
avger NUMBER;
BEGIN
SELECT count(*) INTO avger FROM dual;
RETURN(avger);
END fun2;

procedure proc1(a in int)
AS
avger NUMBER;
BEGIN
update pkg_t1 set f2 = a;
END proc1;

END test_pkg2;
/

--expect error
CREATE PACKAGE BODY test_pkg2
IS

FUNCTION fun1
(cnum IN char)
RETURN NUMBER
AS
avger NUMBER;
BEGIN
SELECT count(*) INTO avger FROM dual;
RETURN(avger);
END fun2;

END test_pkg2;
/


--expect success with warning
CREATE OR REPLACE PACKAGE BODY test_pkg2
IS

FUNCTION fun1
(cnum IN char)
RETURN NUMBER
AS
avger NUMBER;
BEGIN
SELECT count(*) INTO avger FROM dual;
RETURN(avger);
END fun2;

END test_pkg2;
/

--expect invalid
select object_name, object_type,status from my_objects where object_name='TEST_PKG2' order by object_type;

--expect error
select test_pkg2.fun1('a') from dual; 

drop package body test_pkg2;


--test case4: create package body after specification with warning
drop package TEST_EXAMPLE_PKG3;
--step1:create package with warning
CREATE OR REPLACE PACKAGE TEST_EXAMPLE_PKG3
IS

FUNCTION fun1
(cnum IN char)
RETURN NUMBER;

FUNCTION fun2
RETURN NUMBER
IS;

procedure proc1(a in int1);

END test_example_pkg3;
/

--step2: create package body
CREATE PACKAGE BODY TEST_EXAMPLE_PKG3
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
update pkg_t1 set f2 = a;
END proc1;

FUNCTION fun2
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END fun2;

END TEST_EXAMPLE_PKG3;
/

--step3: invoke
select TEST_EXAMPLE_PKG3.fun1('a') from dual;
select TEST_EXAMPLE_PKG3.fun2() from dual;
select TEST_EXAMPLE_PKG3.fun2 from dual;
exec TEST_EXAMPLE_PKG3.proc1(1);
select TEST_EXAMPLE_PKG3.fun3() from dual;

--expect invalid
select object_name, object_type,status from my_objects where object_name='TEST_EXAMPLE_PKG3' order by object_type;
drop package body TEST_EXAMPLE_PKG3;
select object_name, object_type,status from my_objects where object_name='TEST_EXAMPLE_PKG3' order by object_type;

CREATE PACKAGE BODY TEST_EXAMPLE_PKG3
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

END TEST_EXAMPLE_PKG3;
/

drop package TEST_EXAMPLE_PKG3;
select object_name, object_type,status from my_objects where object_name='TEST_EXAMPLE_PKG3' order by object_type;

--test case5: create package body after specification without warning
drop package BODY if exists TEST_EXAMPLE_PKG4;
drop package if exists TEST_EXAMPLE_PKG4;
--step1:create package without warning
CREATE OR REPLACE PACKAGE TEST_EXAMPLE_PKG4
IS

FUNCTION fun1
(cnum IN char)
RETURN NUMBER;

FUNCTION fun2
RETURN NUMBER;

procedure proc1(a in int default 3);

END;
/

--step2: create package body with warning
CREATE OR REPLACE PACKAGE BODY TEST_EXAMPLE_PKG4
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

procedure proc1(a in int default 3)
AS
avger NUMBER;
BEGIN
update pkg_t1 set f21 = a;
END proc1;

FUNCTION fun2
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END fun2;

END;
/

--create package body with warning
CREATE OR REPLACE PACKAGE BODY TEST_EXAMPLE_PKG4
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

procedure proc1(a in int default 3)
AS
avger NUMBER;
BEGIN
update pkg_t1 set f2 = a;
END;

FUNCTION fun2
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END fun3;

END;
/

--step3: invoke
--ORA-04063: package body "C##XIEYUBO.TEST_EXAMPLE_PKG4" has error
select TEST_EXAMPLE_PKG4.fun1('a') from dual;
select TEST_EXAMPLE_PKG4.fun2() from dual;
select TEST_EXAMPLE_PKG4.fun2 from dual;
exec TEST_EXAMPLE_PKG4.proc1(1);
select TEST_EXAMPLE_PKG4.fun3() from dual;

select object_name, object_type,status from my_objects where object_name='TEST_EXAMPLE_PKG4' order by object_type;
drop package BODY TEST_EXAMPLE_PKG4;
select object_name, object_type,status from my_objects where object_name='TEST_EXAMPLE_PKG4' order by object_type;

--step4: create package body with warning (default value not the same with specification)
CREATE OR REPLACE PACKAGE BODY TEST_EXAMPLE_PKG4
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

procedure proc1(a in int default 2)
AS
avger NUMBER;
BEGIN
update pkg_t1 set f2 = a;
END;

FUNCTION fun2
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END;

FUNCTION fun3
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END fun3;

END;
/

--step5: create package body without warning
CREATE OR REPLACE PACKAGE BODY TEST_EXAMPLE_PKG4
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

procedure proc1(a in int default 3)
AS
avger NUMBER;
BEGIN
update pkg_t1 set f2 = a;
END;

FUNCTION fun2
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END;

--FUNCTION fun3
--RETURN NUMBER
--AS
--avger NUMBER;
--BEGIN
--avger := 3;
--return avger;
--END fun3;

END;
/

--check arguments
SELECT * FROM SYS_PROC_ARGS WHERE PACKAGE='TEST_EXAMPLE_PKG4' ORDER BY OBJECT_NAME,PROC_SEQ, SEQUENCE;
SELECT * FROM DB_ARGUMENTS WHERE PACKAGE_NAME='TEST_EXAMPLE_PKG4' ORDER BY OBJECT_NAME,SUBPROGRAM_ID,SEQUENCE;
SELECT * FROM ADM_ARGUMENTS WHERE PACKAGE_NAME='TEST_EXAMPLE_PKG4' ORDER BY OBJECT_NAME,SUBPROGRAM_ID,SEQUENCE;
SELECT * FROM MY_ARGUMENTS WHERE PACKAGE_NAME='TEST_EXAMPLE_PKG4' ORDER BY OBJECT_NAME,SUBPROGRAM_ID,SEQUENCE;

--step5: invoke
select TEST_EXAMPLE_PKG4.fun1('a') from dual;
select TEST_EXAMPLE_PKG4.fun2() from dual;
select TEST_EXAMPLE_PKG4.fun2 from dual;
exec TEST_EXAMPLE_PKG4.proc1(1);
--expect error
select TEST_EXAMPLE_PKG4.fun3() from dual;

select object_name, object_type,status from my_objects where object_name='TEST_EXAMPLE_PKG4' order by object_type;
drop package TEST_EXAMPLE_PKG4;
select object_name, object_type,status from my_objects where object_name='TEST_EXAMPLE_PKG4' order by object_type;

--test case6: create package after package body
--step1: create package body with warning
CREATE OR REPLACE PACKAGE BODY TEST_EXAMPLE_PKG5
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
update pkg_t1 set f2 = a;
END;

FUNCTION fun2
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END;

FUNCTION fun3
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END fun3;

END TEST_EXAMPLE_PKG5;
/

--step2:create package with warning
CREATE OR REPLACE PACKAGE TEST_EXAMPLE_PKG5
IS

FUNCTION fun1
(cnum IN char)
RETURN NUMBER;

FUNCTION fun2
RETURN NUMBER;

procedure proc1(a in int1);

END TEST_EXAMPLE_PKG5;
/

--step3: invoke
--expect error
select TEST_EXAMPLE_PKG5.fun1('a') from dual;
select TEST_EXAMPLE_PKG5.fun2() from dual;
select TEST_EXAMPLE_PKG5.fun2 from dual;
exec TEST_EXAMPLE_PKG5.proc1(1);
select TEST_EXAMPLE_PKG5.fun3() from dual;

select object_name, object_type,status from my_objects where object_name='TEST_EXAMPLE_PKG5' order by object_type;

--step4:create package without warning
CREATE OR REPLACE PACKAGE TEST_EXAMPLE_PKG5
IS

FUNCTION fun1
(cnum IN char)
RETURN NUMBER;

FUNCTION fun2
RETURN NUMBER;

procedure proc1(a in int);

END TEST_EXAMPLE_PKG5;
/

select object_name, object_type,status from my_objects where object_name='TEST_EXAMPLE_PKG5' order by object_type;

--step5: invoke
--expect success
select TEST_EXAMPLE_PKG5.fun1('a') from dual;
select TEST_EXAMPLE_PKG5.fun2() from dual;
select TEST_EXAMPLE_PKG5.fun2 from dual;
exec TEST_EXAMPLE_PKG5.proc1(1);
--expect error
select TEST_EXAMPLE_PKG5.fun3() from dual;

--expect valid
select object_name, object_type,status from my_objects where object_name='TEST_EXAMPLE_PKG5' order by object_type;
drop package TEST_EXAMPLE_PKG5;

--test case7: package name cannot the same with func/proc1 name
drop package body if exists TEST_SAME_NAME_FUN;
drop package if exists TEST_SAME_NAME_FUN;
drop function if exists TEST_SAME_NAME_FUN;

create or replace FUNCTION TEST_SAME_NAME_FUN
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END TEST_SAME_NAME_FUN;
/

--expect error
CREATE OR REPLACE PACKAGE TEST_SAME_NAME_FUN
IS

FUNCTION fun1
(cnum IN char)
RETURN NUMBER;

FUNCTION fun2
RETURN NUMBER;

procedure proc1(a in int);

END TEST_SAME_NAME_FUN;
/


--test case8: package body name can the same with func/proc1 name
--create package body with warning
CREATE OR REPLACE PACKAGE BODY TEST_SAME_NAME_FUN
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

END TEST_SAME_NAME_FUN;
/

drop package body if exists TEST_SAME_NAME_FUN;
drop function if exists TEST_SAME_NAME_FUN;

--test case9: pacakge name is the same with username
--step1:
drop user if exists TEST_SAME_NAME_FUN cascade;
drop PACKAGE if exists TEST_SAME_NAME_FUN;
create user TEST_SAME_NAME_FUN identified by root_1234;
grant dba to TEST_SAME_NAME_FUN;

create or replace FUNCTION TEST_SAME_NAME_FUN.fun2
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 5;
return avger;
END fun2;
/

select TEST_SAME_NAME_FUN.fun2 from dual;

--step2:
CREATE OR REPLACE PACKAGE TEST_SAME_NAME_FUN
IS

FUNCTION fun2
RETURN NUMBER;


END TEST_SAME_NAME_FUN;
/

CREATE OR REPLACE PACKAGE BODY TEST_SAME_NAME_FUN
IS

FUNCTION fun2
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END;

END TEST_SAME_NAME_FUN;
/

select TEST_SAME_NAME_FUN.fun2() from dual;
select TEST_SAME_NAME_FUN.fun2 from dual;

drop function if exists TEST_SAME_NAME_FUN.fun2;
drop PACKAGE if exists TEST_SAME_NAME_FUN;

--test case10: package name cannot be the same with built-in package name
--expect error
CREATE OR REPLACE PACKAGE DBE_STATS
IS

FUNCTION fun1
(cnum IN char)
RETURN NUMBER;

FUNCTION fun2
RETURN NUMBER;

procedure proc1(a in int);

END DBE_STATS;
/

--expect error
CREATE OR REPLACE PACKAGE BODY DBE_STATS
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

END DBE_STATS;
/

--test case11: creating a package with the same name under the user is not supported
--expect error
CREATE OR REPLACE PACKAGE SYS
IS
procedure proc1(a in int);

END SYS;
/

--expect error
CREATE OR REPLACE PACKAGE BODY SYS
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

END SYS;
/

--test case12: test recompile

drop package if exists TEST_PACKAGE;

CREATE OR REPLACE PACKAGE BODY test_package
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
update pkg_t1 set f2 = a;
END proc1;

FUNCTION fun2
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END fun2;

END test_package;
/


CREATE OR REPLACE PACKAGE test_package
IS

FUNCTION fun1
(cnum IN char)
RETURN NUMBER;

FUNCTION fun2
RETURN NUMBER;

procedure proc1(a in int);

END test_package;
/
--unsupport
alter package test_package compile body;

select object_name, object_type,status from my_objects where object_name='TEST_PACKAGE' order by object_type;

drop package if exists test_package;

--test case13: name incasensetive
--step1: test pacakge and pacakge body name
CREATE OR REPLACE PACKAGE "pl_pkg13"
IS
procedure proc1(a in int);

FUNCTION fun1
(cnum IN char)
RETURN NUMBER;

END "pl_pkg13";
/

CREATE OR REPLACE PACKAGE `ds_test` AS
  procedure proc1;
END `ds_test`;
/

CREATE OR REPLACE PACKAGE 'pkg_test' AS
  procedure proc1;
END 'pkg_test';
/

CREATE OR REPLACE PACKAGE BODY "pl_pkg13"
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

END "pl_pkg13";
/

CREATE OR REPLACE PACKAGE BODY `ds_test` AS
FUNCTION fun1
(cnum IN char)
RETURN NUMBER
AS
avger NUMBER;
BEGIN
SELECT count(*) INTO avger FROM dual;
RETURN(avger);
END fun1;

procedure proc1
AS
avger NUMBER;
BEGIN
avger :=1;
END proc1;
END `ds_test`;
/

CREATE OR REPLACE PACKAGE BODY 'pkg_test' AS
  FUNCTION fun1
(cnum IN char)
RETURN NUMBER
AS
avger NUMBER;
BEGIN
SELECT count(*) INTO avger FROM dual;
RETURN(avger);
END fun1;

END 'pkg_test';
/

select object_name, object_type,status from my_objects where object_name in ('pl_pkg13','ds_test', 'pkg_test') order by object_name,object_type;

--step 2: test replace 
--expect success
CREATE OR REPLACE PACKAGE "pl_pkg13"
IS
procedure proc1(a in int);

FUNCTION fun2
RETURN NUMBER;

END "pl_pkg13";
/

CREATE OR REPLACE PACKAGE BODY "pl_pkg13"
IS
FUNCTION fun2
RETURN NUMBER
AS
avger NUMBER;
BEGIN
SELECT count(*) INTO avger FROM dual;
avger := avger + 100;
RETURN(avger);
END fun2;

procedure proc1(a in int)
AS
avger NUMBER;
BEGIN
avger :=1;
	dbe_output.print_line('PROC1');
END proc1;

END "pl_pkg13";
/
select object_name, object_type,status from my_objects where object_name in ('pl_pkg13','ds_test', 'pkg_test') order by object_name,object_type;

--step3: test call
select "pl_pkg13".fun2() from dual;
select "pl_pkg13".fun2 from dual;
select pl_pkg13.fun2 from dual;
select "pl_pkg13".fun1('a') from dual;
select sys."pl_pkg13".fun2() from dual;

begin
	"pl_pkg13".proc1(1);
end;	
/

begin
	pl_pkg13.proc1(1);
end;	
/

begin
	`pl_pkg13`.proc1(1);
end;	
/

drop package "pl_pkg13";

--step4: test pacakge and pacakge body name, and test call
CREATE OR REPLACE PACKAGE `ds_test` AS
FUNCTION `fun13_1`
RETURN NUMBER;

procedure `proc13`(a in int);
END `ds_test`;
/

CREATE OR REPLACE PACKAGE BODY `ds_test` AS
FUNCTION `fun13_1`
RETURN NUMBER
AS
avger NUMBER;
BEGIN
SELECT count(*) INTO avger FROM dual;
RETURN(avger);
END;

procedure `proc13`(a in int)
AS
avger NUMBER;
BEGIN
SELECT count(*) INTO avger FROM dual;
END;

END `ds_test`;
/

select object_name, object_type,status from my_objects where object_name in ('pl_pkg13','ds_test', 'pkg_test') order by object_name,object_type;

select `ds_test`.`fun13_1`() from dual;
select `ds_test`.`fun13_1` from dual;
select ds_test.`fun13_1` from dual;
select ds_test.fun13_1 from dual;
select ds_test.fun13_1() from dual;

begin
`ds_test`.`proc13`(1);
end;
/

begin
ds_test.`proc13`(1);
end;
/

begin
ds_test.proc13(1);
end;
/

drop PACKAGE `ds_test`;

--step5: test procedure and function name, and test call
CREATE OR REPLACE PACKAGE test_PKG_1 AS
FUNCTION `fun13_1`
RETURN NUMBER;

procedure `proc13`(a in int);
END test_PKG_1;
/

CREATE OR REPLACE PACKAGE BODY test_PKG_1 AS
FUNCTION `fun13_1`
RETURN NUMBER
AS
avger NUMBER;
BEGIN
SELECT count(*) INTO avger FROM dual;
RETURN(avger);
END;

procedure `proc13`(a in int)
AS
avger NUMBER;
BEGIN
SELECT count(*) INTO avger FROM dual;
END;

END test_PKG_1;
/

select object_name, object_type,status from my_objects where object_name in ('TEST_PKG_1') order by object_name,object_type;

select test_PKG_1.`fun13_1`() from dual;
select test_PKG_1.`fun13_1` from dual;
select test_PKG_1.`FUN13_1` from dual;
select test_PKG_1.fun13_1 from dual;
select test_PKG_1.fun13_1() from dual;

begin
test_PKG_1.`proc13`(1);
end;
/

begin
test_PKG_1.proc13(1);
end;
/

drop PACKAGE if exists test_PKG_1;

--test case14: test dependencies(1)
DROP TABLE IF EXISTS T_PKG_T1;
DROP TABLE IF EXISTS T_PKG_T2;
CREATE TABLE T_PKG_T1(F1 INT, F2 VARCHAR2(20));
CREATE TABLE T_PKG_T2(F1 INT, F2 VARCHAR2(20));
create or replace view PKG_V13 as select * from T_PKG_T2;

create or replace procedure T_PKG_P1(a int, b varchar2)
as
c int := 1;
d int := 2;
begin
  insert into T_PKG_T1 values(a,b);
  commit;
end;
/

create or replace function TEST_FUN13
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
select count(*) into avger from PKG_V13;
return avger;
END TEST_FUN13;
/

CREATE OR REPLACE PACKAGE TEST_PKG13
IS

procedure proc13(a in int);

END TEST_PKG13;
/


CREATE OR REPLACE PACKAGE BODY TEST_PKG13
IS

procedure proc13(a in int)
AS
avger NUMBER;
BEGIN
avger := TEST_FUN13;
T_PKG_P1(1, 'a');
update T_PKG_T1 set f2 = 1;
END;

END TEST_PKG13;
/
--expect 3 rows
SELECT * FROM MY_DEPENDENCIES WHERE NAME='TEST_PKG13' ORDER BY NAME, REFERENCED_NAME;
drop package if exists TEST_PKG13;
--expect 0 rows
SELECT * FROM MY_DEPENDENCIES WHERE NAME='TEST_PKG13' ORDER BY NAME, REFERENCED_NAME;

CREATE OR REPLACE PACKAGE TEST_PKG13
IS

FUNCTION fun13_1
(cnum IN char)
RETURN NUMBER;

FUNCTION fun13_2
RETURN NUMBER;

procedure proc13(a in int);

END TEST_PKG13;
/


CREATE OR REPLACE PACKAGE BODY TEST_PKG13
IS

procedure proc13(a in int)
AS
avger NUMBER;
BEGIN
avger := TEST_FUN13;
T_PKG_P1(1, 'a');
update T_PKG_T1 set f2 = 1;
END;

END TEST_PKG13;
/

--expect 3 rows
SELECT * FROM MY_DEPENDENCIES WHERE NAME='TEST_PKG13' ORDER BY NAME, REFERENCED_NAME;

CREATE OR REPLACE PACKAGE BODY TEST_PKG13
IS

FUNCTION fun13_1
(cnum IN char)
RETURN NUMBER
AS
avger NUMBER;
BEGIN
SELECT count(*) INTO avger FROM dual;
SELECT count(*) INTO avger FROM PKG_V13;
RETURN(avger);
END fun13_1;

procedure proc13(a in int)
AS
avger NUMBER;
BEGIN
avger := TEST_FUN13;
T_PKG_P1(1, 'a');
update T_PKG_T1 set f2 = 1;
END;

FUNCTION fun13_2
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END;

FUNCTION fun13_3
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
update T_PKG_T2 set f2 = 1;
return avger;
END fun13_3;

END TEST_PKG13;
/

select TEST_PKG13.FUN13_3() from T_PKG_T1;
select TEST_PKG13.FUN13_2() from T_PKG_T1;

--expect 6 rows
SELECT * FROM MY_DEPENDENCIES WHERE NAME='TEST_PKG13' ORDER BY NAME, REFERENCED_NAME;

--expect success
select TEST_PKG13.FUN13_1('a') from T_PKG_T1;

--expect success
CREATE OR REPLACE PACKAGE TEST_PKG13
IS

FUNCTION fun13_1
(cnum IN char)
RETURN NUMBER;

FUNCTION fun13_2
RETURN NUMBER;

procedure proc13(a in int);

FUNCTION fun13_4
RETURN NUMBER;

END TEST_PKG13;
/

--expect error
select TEST_PKG13.FUN13_1('a') from T_PKG_T1;
select TEST_PKG13.FUN13_4('a') from T_PKG_T1;
--test case15: test dependencies(2)
--expect success
CREATE OR REPLACE PACKAGE TEST_PKG13
IS

FUNCTION fun13_1
(cnum IN char)
RETURN NUMBER;

FUNCTION fun13_2
RETURN NUMBER;

procedure proc13(a in int);

END TEST_PKG13;
/

create or replace view T_PKG_V15_1 as select TEST_PKG13.FUN13_1('a') from T_PKG_T1;
create or replace view T_PKG_V15_2 as select TEST_PKG13.fun13_2 from dual;
create or replace view T_PKG_V15_3 as select TEST_PKG13.fun13_2() from dual;

--expect 6 row
SELECT * FROM MY_DEPENDENCIES WHERE NAME like 'T_PKG_V15%' ORDER BY NAME, REFERENCED_NAME;

create or replace procedure T_PKG_P15(a int, b varchar2)
as
c int := 1;
d int := 2;
begin
  insert into T_PKG_T1 values(TEST_PKG13.FUN13_1('a'),TEST_PKG13.fun13_2);
  commit;
end;
/

create or replace function T_PKG_F15
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
select TEST_PKG13.fun13_2() into avger from PKG_V13;
return avger;
END;
/

SELECT * FROM MY_DEPENDENCIES WHERE NAME like 'T_PKG_%15' ORDER BY NAME, REFERENCED_NAME;
select OBJECT_NAME,OBJECT_TYPE,STATUS from my_objects where object_name in ('T_PKG_F15','T_PKG_P15','TEST_PKG13', 'PKG_V13') order by object_name, object_type;

drop table if exists T_PKG_T1;
select OBJECT_NAME,OBJECT_TYPE,STATUS from my_objects where object_name in ('T_PKG_F15','T_PKG_P15','TEST_PKG13', 'PKG_V13') order by object_name, object_type;

drop table if exists T_PKG_T2;
drop view if exists PKG_V13;
drop package if exists TEST_PKG13;
drop procedure if exists T_PKG_P15;
drop function if exists T_PKG_F15;
drop user if exists TEST_SAME_NAME_FUN cascade;

---------------------------------------------------------------
--test case 16: test privilage
drop user if exists TEST_PKG_USER1 cascade;
create user TEST_PKG_USER1 identified by root_1234;
grant create session, create table to TEST_PKG_USER1;

--CREATE SYS  package ,expect success
CREATE OR REPLACE PACKAGE SYS_PKG_1
IS

FUNCTION fun_1
RETURN NUMBER;

END SYS_PKG_1;
/

CREATE OR REPLACE PACKAGE BODY SYS_PKG_1
IS

FUNCTION fun_1
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END;

END SYS_PKG_1;
/

--(0) create procedure privilage can create package
conn TEST_PKG_USER1/root_1234@127.0.0.1:1611

--expect error
CREATE OR REPLACE PACKAGE TEST_PKG_USER1.TEST_PKG_16_1
IS

FUNCTION fun_2
RETURN NUMBER;

END TEST_PKG_16_1;
/

conn sys/Huawei@123@127.0.0.1:1611
grant create procedure to TEST_PKG_USER1;
conn TEST_PKG_USER1/root_1234@127.0.0.1:1611

--expect success
CREATE OR REPLACE PACKAGE TEST_PKG_USER1.TEST_PKG_16_1
IS

FUNCTION fun_2
RETURN NUMBER;

END TEST_PKG_16_1;
/

CREATE OR REPLACE PACKAGE BODY TEST_PKG_USER1.TEST_PKG_16_1
IS

FUNCTION fun_2
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END;

END TEST_PKG_16_1;
/

select TEST_PKG_USER1.TEST_PKG_16_1.fun_2() from dual;
select TEST_PKG_16_1.fun_2() from dual;

--(1)sys can modify and execute the package of other user
conn sys/Huawei@123@127.0.0.1:1611
select TEST_PKG_USER1.TEST_PKG_16_1.fun_2() from dual;
drop package TEST_PKG_USER1.TEST_PKG_16_1;

--(2)user can call the grant pacakge of other user
--expect success
CREATE OR REPLACE PACKAGE TEST_PKG_USER1.TEST_PKG_16_1
IS

FUNCTION fun_2
RETURN NUMBER;

END TEST_PKG_16_1;
/

CREATE OR REPLACE PACKAGE BODY TEST_PKG_USER1.TEST_PKG_16_1
IS

FUNCTION fun_2
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END;

END TEST_PKG_16_1;
/

drop user if exists TEST_PKG_USER2 cascade;
create user TEST_PKG_USER2 identified by root_1234;
grant create session, create table to TEST_PKG_USER2;
conn TEST_PKG_USER2/root_1234@127.0.0.1:1611
--expect error
select TEST_PKG_USER1.TEST_PKG_16_1.fun_2() from dual;

conn TEST_PKG_USER1/root_1234@127.0.0.1:1611
grant execute on TEST_PKG_16_1 to TEST_PKG_USER2;

conn TEST_PKG_USER2/root_1234@127.0.0.1:1611
--expect success
select TEST_PKG_USER1.TEST_PKG_16_1.fun_2() from dual;

--(3)user with sys privilage (execute any procedure) can call the package of other user, excepte sys
conn TEST_PKG_USER1/root_1234@127.0.0.1:1611
revoke execute on TEST_PKG_16_1 from TEST_PKG_USER2;

conn TEST_PKG_USER2/root_1234@127.0.0.1:1611
--expect error
select TEST_PKG_USER1.TEST_PKG_16_1.fun_2() from dual;

conn sys/Huawei@123@127.0.0.1:1611
grant execute any procedure to TEST_PKG_USER2;

conn TEST_PKG_USER2/root_1234@127.0.0.1:1611
--expect success
select TEST_PKG_USER1.TEST_PKG_16_1.fun_2() from dual;
--expect error(the privilage of execute any procedure cannot call the package of sys.)
select sys.SYS_PKG_1.fun_1() from dual;

--(4)dba can call all package, excepte sys
conn sys/Huawei@123@127.0.0.1:1611
revoke execute any procedure from TEST_PKG_USER2;
conn TEST_PKG_USER2/root_1234@127.0.0.1:1611
--expect error
select TEST_PKG_USER1.TEST_PKG_16_1.fun_2() from dual;
--expect error
select sys.SYS_PKG_1.fun_1() from dual;

conn sys/Huawei@123@127.0.0.1:1611
grant dba to TEST_PKG_USER2;
conn TEST_PKG_USER2/root_1234@127.0.0.1:1611
--expect success
select TEST_PKG_USER1.TEST_PKG_16_1.fun_2() from dual;
--expect error
select sys.SYS_PKG_1.fun_1() from dual;

--(5)any user cannot drop the package of sys
conn sys/Huawei@123@127.0.0.1:1611
grant execute on SYS_PKG_1 to TEST_PKG_USER1;
grant execute on SYS_PKG_1 to TEST_PKG_USER2;

--expect select success,drop error
conn TEST_PKG_USER1/root_1234@127.0.0.1:1611
select sys.SYS_PKG_1.fun_1() from dual;
drop package sys.SYS_PKG_1;
conn TEST_PKG_USER2/root_1234@127.0.0.1:1611
select sys.SYS_PKG_1.fun_1() from dual;
drop package sys.SYS_PKG_1;

conn sys/Huawei@123@127.0.0.1:1611
grant drop any procedure to TEST_PKG_USER1;
grant drop any procedure to TEST_PKG_USER2;
--expect drop error(drop any procedure privilage cannot drop sys's pacakge)
conn TEST_PKG_USER1/root_1234@127.0.0.1:1611
drop package sys.SYS_PKG_1;
conn TEST_PKG_USER2/root_1234@127.0.0.1:1611
drop package sys.SYS_PKG_1;

--(6) package without body can grant to other user
conn sys/Huawei@123@127.0.0.1:1611
CREATE OR REPLACE PACKAGE SYS_PKG_2
IS

FUNCTION fun_1
RETURN NUMBER;

END SYS_PKG_2;
/

--expect success
grant execute on SYS_PKG_2 to TEST_PKG_USER1;

--(7)package body without specification can not grant to other user
CREATE OR REPLACE PACKAGE BODY SYS_PKG_3
IS

FUNCTION fun_1
RETURN NUMBER
AS
avger NUMBER;
BEGIN
avger := 3;
return avger;
END;

END SYS_PKG_3;
/

--expect error
grant execute on SYS_PKG_3 to TEST_PKG_USER1;
--(8)package specification with error can  grant to other user
CREATE OR REPLACE PACKAGE SYS_PKG_4
IS

FUNCTION fun_1
RETURN NUMBER IS;

END SYS_PKG_4;
/

--expect success
grant execute on SYS_PKG_4 to TEST_PKG_USER1;

conn TEST_PKG_USER1/root_1234@127.0.0.1:1611
select sys.SYS_PKG_4.fun_1() from dual;

--clean
conn sys/Huawei@123@127.0.0.1:1611
drop package if exists SYS_PKG_1;
drop package if exists SYS_PKG_2;
drop package if exists SYS_PKG_3;
drop package if exists SYS_PKG_4;

--TEST default valued
--step1.expect success
CREATE OR REPLACE PACKAGE TEST_PKG_DEF
IS

FUNCTION TEST_PKG_DEF_Fun
(cnum IN char default 'aaaa')
RETURN NUMBER;

procedure TEST_PKG_DEF_Proc(a in int default 3);

END;
/

--step2.expect error
Create Or Replace Package Body TEST_PKG_DEF
Is

Function TEST_PKG_DEF_Fun
(Cnum In Char default 'aaaabb')
Return Number
As
Avger Number;
Begin
Select Count(*) Into Avger From Dual;
Return(Avger);
End;

Procedure TEST_PKG_DEF_Proc(A In Int default 3)
As
Avger Number;
Begin
Avger := 3;
End;

End;
/

--step3.expect error
Create Or Replace Package Body TEST_PKG_DEF
Is

Function TEST_PKG_DEF_Fun
(Cnum In Char default 'aaaa')
Return Number
As
Avger Number;
Begin
Select Count(*) Into Avger From Dual;
Return(Avger);
End;

Procedure TEST_PKG_DEF_Proc(A In Int default 4)
As
Avger Number;
Begin
Avger := 3;
End;

End;
/

--step4.expect success
Create Or Replace Package Body TEST_PKG_DEF
Is

Function TEST_PKG_DEF_Fun
(Cnum In Char default 'aaaa')
Return Number
As
Avger Number;
Begin
Select Count(*) Into Avger From Dual;
Return(Avger);
End;

Procedure TEST_PKG_DEF_Proc(A In Int default 3)
As
Avger Number;
Begin
Avger := 3;
End;

End;
/

--check arguments
SELECT * FROM SYS_PROC_ARGS WHERE PACKAGE='TEST_PKG_DEF' ORDER BY OBJECT_NAME,PROC_SEQ, SEQUENCE;
SELECT * FROM DB_ARGUMENTS WHERE PACKAGE_NAME='TEST_PKG_DEF' ORDER BY OBJECT_NAME,SUBPROGRAM_ID,SEQUENCE;
SELECT * FROM ADM_ARGUMENTS WHERE PACKAGE_NAME='TEST_PKG_DEF' ORDER BY OBJECT_NAME,SUBPROGRAM_ID,SEQUENCE;
SELECT * FROM MY_ARGUMENTS WHERE PACKAGE_NAME='TEST_PKG_DEF' ORDER BY OBJECT_NAME,SUBPROGRAM_ID,SEQUENCE;

drop package if exists TEST_PKG_DEF;

--TEST ARGUMENT NAME
CREATE OR REPLACE PACKAGE TEST_PKG_INNER_PROC
IS

FUNCTION abs
(cnum IN number)
RETURN NUMBER;

END;
/

--expect error
Create Or Replace Package Body TEST_PKG_INNER_PROC
Is

Function abs(A In number) Return Number
As
Avger Number;
Begin
Avger := 3;
return Avger;
End;

End;
/

--TEST inner procedure
CREATE OR REPLACE PACKAGE TEST_PKG_INNER_PROC
IS

FUNCTION TEST_PKG_Fun
(cnum IN char)
RETURN NUMBER;

procedure TEST_PKG_Proc(a in int);

END;
/


Create Or Replace Package Body TEST_PKG_INNER_PROC
Is

Function abs(A In Int) Return Number
As
Avger Number;
Begin
Avger := 3;
return Avger;
End;

Function TEST_PKG_Fun
(Cnum In Char)
Return Number
As
Avger Number;
Begin
Select Count(*) Into Avger From Dual;
Avger := abs(-1);
Return(Avger);
End;


Procedure TEST_PKG_Proc(A In Int)
As
Avger Number;
Begin
Avger := 5;
End;

End;
/

--expect 3
select TEST_PKG_INNER_PROC.TEST_PKG_Fun('a') from dual;

Create Or Replace Package Body TEST_PKG_INNER_PROC
Is

Function TEST_PKG_Fun
(Cnum In Char)
Return Number
As
Avger Number;
Begin
Select Count(*) Into Avger From Dual;
Avger := abs(-1);
Return(Avger);
End;


Procedure TEST_PKG_Proc(A In Int)
As
Avger Number;
Begin
Avger := 5;
End;

End;
/

--expect 1
select TEST_PKG_INNER_PROC.TEST_PKG_Fun('a') from dual;


--test case:inner proc calls inner proc
--begin
CREATE OR REPLACE PACKAGE PKG_INNER_PROC_1
IS

FUNCTION PKG_Fun (cnum IN int) RETURN NUMBER;

procedure PKG_Proc(a in int);

END;
/

--expect success
Create Or Replace Package Body PKG_INNER_PROC_1
Is

Function PKG_Fun
(Cnum In int)
Return Number
As
Avger Number;
Begin
Select Count(*) Into Avger From Dual;
Avger := abs(-1);
Return(Avger);
End;

Procedure PKG_Proc(A In Int)
As
	Avger Number;
Begin
	Avger := PKG_INNER_PROC_1.PKG_Fun(A);
	dbe_output.print_line(Avger);
End;

End;
/

--expect 1
exec PKG_INNER_PROC_1.PKG_Proc(1);

--expect success
Create Or Replace Package Body PKG_INNER_PROC_1
Is

Function PKG_Fun
(Cnum In int)
Return Number
As
Avger Number;
Begin
Select Count(*) Into Avger From Dual;
Avger := abs(-1);
Return(Avger);
End;

Procedure PKG_Proc(A In Int)
As
	Avger Number;
Begin
	Avger := PKG_Fun(A);
	dbe_output.print_line(Avger);
End;

End;
/

SELECT * FROM MY_DEPENDENCIES WHERE NAME = 'PKG_INNER_PROC_1' ORDER BY NAME, REFERENCED_NAME;

--expect 1
exec PKG_INNER_PROC_1.PKG_Proc(1);

--expect success
Create Or Replace Package Body PKG_INNER_PROC_1
Is

Procedure PKG_Proc(A In Int)
As
	Avger Number;
Begin
	Avger := PKG_INNER_PROC_1.PKG_Fun(A);
	dbe_output.print_line(Avger);
End;

Function PKG_Fun
(Cnum In int)
Return Number
As
Avger Number;
Begin
Select Count(*) Into Avger From Dual;
Avger := abs(-1);
Return(Avger);
End;

End;
/

--expect 1
exec PKG_INNER_PROC_1.PKG_Proc(1);

drop package PKG_INNER_PROC_1;
--end

-------------------------------------------------------------
--test case : test soft parse
--begin
drop table if exists pkg_inner_t1;
create table pkg_inner_t1 (f1 int);

CREATE OR REPLACE PACKAGE PKG_INNER_PROC_2
IS

FUNCTION PKG_Fun (cnum IN int) RETURN NUMBER;
FUNCTION PKG_Fun1 (cnum IN int) RETURN NUMBER;

procedure PKG_Proc(a in int);

END;
/

--expect success
Create Or Replace Package Body PKG_INNER_PROC_2
Is

Function PKG_Fun
(Cnum In int)
Return Number
As
Avger Number;
Begin
Select Count(*) Into Avger From dual;
Avger := abs(-1);
Return(Avger);
End;

Function PKG_Fun1
(Cnum In int)
Return Number
As
Avger Number;
Begin
Select Count(*) Into Avger From pkg_inner_t1;
Avger := abs(-1);
Return(Avger);
End;

Procedure PKG_Proc(A In Int)
As
	Avger Number;
Begin
	Avger := PKG_Fun(A);
	dbe_output.print_line(Avger);
	--sleep(20);
	Avger := PKG_Fun(A)+1;
	dbe_output.print_line(Avger);
End;

End;
/
SELECT * FROM MY_DEPENDENCIES WHERE NAME = 'PKG_INNER_PROC_2' ORDER BY NAME, REFERENCED_NAME;

--expect 1 2
exec PKG_INNER_PROC_2.PKG_Proc(1);

drop table pkg_inner_t1;

--expect error
exec PKG_INNER_PROC_2.PKG_Proc(1);
--end

--test case: test recursive call DTS2019072409072
drop user if exists user_pkg cascade;
create user user_pkg identified by Cantian_234;
grant all privileges to user_pkg;


create or replace package user_pkg.pack_yf_11 is
procedure proc_yf_11;
procedure proc_yf_011;
end;
/

--expect success
create or replace package body user_pkg.pack_yf_11 is 

procedure proc_yf_11 is 
a number;
begin
a:=1;
dbe_output.print_line(a); 
user_pkg.pack_yf_11.proc_yf_11();
end proc_yf_11;

procedure proc_yf_011 is
b number;
begin 
b:=1;
dbe_output.print_line(b);

end proc_yf_011;
end user_pkg.pack_yf_11;
/
--end

--teset case: test load entity modify dependencies
create or replace package pack_yf_17 is
function func_yf_17_1 return number;
end;
/
create or replace package body pack_yf_17 is
function func_yf_17_1 return number is 
a number;
begin
a:=4;
return a;
end func_yf_17_1;
end pack_yf_17;
/

create or replace package pack_yf_017 is 
function func_yf_17_2 return varchar2;
end;
/
create or replace package body pack_yf_017 is
function func_yf_17_2 return varchar2 is
b varchar2(20);
c number;
begin
b:='ss';
select pack_yf_17.func_yf_17_1 into c from dual;
return b;
end func_yf_17_2;
end pack_yf_017;
/
select owner,status,object_type from all_objects where OBJECT_NAME=upper('pack_yf_017') order by object_type;

drop package pack_yf_17;
create or replace package pack_yf_17 is
function func_yf_17_1 return number;
end;
/
create or replace package body pack_yf_17 is
function func_yf_17_1 return number is 
a number;
begin
a:=4;
return a;
end func_yf_17_1;
end pack_yf_17;
/
select owner,status,object_type from all_objects where OBJECT_NAME=upper('pack_yf_017') order by object_type;

select pack_yf_017.func_yf_17_2 from dual;
select owner,status,object_type from all_objects where OBJECT_NAME=upper('pack_yf_017') order by object_type;
drop package pack_yf_17;

select owner,status,object_type from all_objects where OBJECT_NAME=upper('pack_yf_017') order by object_type;
drop package pack_yf_017;
--end
--test case:
conn sys/Huawei@123@127.0.0.1:1611
DROP USER IF EXISTS PACKAGE_001 CASCADE;
create user PACKAGE_001 identified by Cantian_234;
grant all  PRIVILEGES to PACKAGE_001;
conn PACKAGE_001/Cantian_234@127.0.0.1:1611
create or replace package dd
as 
function dd(id int) return int;
end;
/

create or replace package body dd
as 
function dd(id int) return int
as 
a int;
begin
a :=1;
return a ;
end;
end;
/
conn sys/Huawei@123@127.0.0.1:1611
DROP USER IF EXISTS PACKAGE_002 CASCADE;
create user PACKAGE_002 identified by Cantian_234;
grant all  PRIVILEGES to PACKAGE_002;
conn PACKAGE_002/Cantian_234@127.0.0.1:1611
create or replace package dd
as 
function dd(id int) return int;
end;
/

create or replace package body dd
as 
function dd(id int) return int
as 
a int;
begin
a :=PACKAGE_001.dd.dd(1);
return a ;
end;
end;
/

--expect 1
select dd.dd(1) from dual;

conn PACKAGE_001/Cantian_234@127.0.0.1:1611
create or replace package body dd
as 
function dd(id int) return int
as 
a int;
begin
a :=2;
return a ;
end;
end;
/

conn PACKAGE_002/Cantian_234@127.0.0.1:1611

--expect 2
select dd.dd(1) from dual;

conn sys/Huawei@123@127.0.0.1:1611
DROP USER IF EXISTS PACKAGE_001 CASCADE;
create user PACKAGE_001 identified by Cantian_234;
grant all  PRIVILEGES to PACKAGE_001;
conn PACKAGE_001/Cantian_234@127.0.0.1:1611
create or replace package dd
as 
function dd(id int) return int;
end;
/

create or replace package body dd
as 
function dd(id int) return int
as 
a int;
begin
a :=1;
return a ;
end;
end;
/

DROP USER IF EXISTS PACKAGE_002 CASCADE;
create user PACKAGE_002 identified by Cantian_234;
grant all  PRIVILEGES to PACKAGE_002;
conn PACKAGE_002/Cantian_234@127.0.0.1:1611
create or replace package dd
as 
function dd(id int) return int;
end;
/

create or replace package body dd
as 
function dd(id int) return int
as 
a int;
begin
a :=PACKAGE_001.dd.dd(1);
return a ;
end;
end;
/

--expect 1
select dd.dd(1) from dual;


conn PACKAGE_001/Cantian_234@127.0.0.1:1611

create or replace package body dd
as 
function dd(id int) return int
as 
a int;
begin
a :=2;
return a ;
end;
end;
/

conn PACKAGE_002/Cantian_234@127.0.0.1:1611

--expect 2
select dd.dd(1) from dual;
conn sys/Huawei@123@127.0.0.1:1611
--end

--DTS2019080206592
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
select dv_pl_manager.name,dv_pl_manager.type from dv_pl_manager where name='PACK1' order by dv_pl_manager.type;
drop package pack1;

-- package test1
create or replace type varray01 force is varray(4) of int;
/
create or replace type obj01 force is object(a varray01, b int);
/
DROP PACKAGE if exists PAK1;
CREATE OR REPLACE PACKAGE PAK1
IS
 FUNCTION fun1 RETURN int;
 PROCEDURE pro1;
END;
/
CREATE OR REPLACE PACKAGE BODY PAK1
IS
 FUNCTION fun1 RETURN int
IS
 var1 int;
 a varray01:=varray01(1,2,3);
 BEGIN
  var1 :=a(3);
  return var1;
 END;
PROCEDURE pro1 IS
 V1 INT;
 BEGIN
  V1:= fun1;
  dbe_output.print_line(V1);
 END;
END;
/
CALL PAK1.pro1;
-- package test2
DROP PACKAGE PAK1;
CREATE OR REPLACE PACKAGE PAK1
IS
 FUNCTION fun1 RETURN varray01;
 PROCEDURE pro1;
END;
/
CREATE OR REPLACE PACKAGE BODY PAK1
IS
 FUNCTION fun1 RETURN varray01
IS
 var1 varray01:=varray01(1,2,3);
 BEGIN
  return var1;
 END;
PROCEDURE pro1 IS
 V1 varray01;
 BEGIN
  V1:= fun1;
  dbe_output.print_line('count'||V1.count);
  for i in 1..V1.count loop
  dbe_output.print_line(V1(i));
  end loop;
 END;
END;
/
CALL PAK1.pro1;
-- package test3
DROP PACKAGE PAK1;
CREATE OR REPLACE PACKAGE PAK1
IS
 FUNCTION fun1 RETURN obj01;
 PROCEDURE pro1;
END;
/
CREATE OR REPLACE PACKAGE BODY PAK1
IS
 FUNCTION fun1 RETURN obj01
IS
 var1 obj01;
 BEGIN
 var1:=obj01(varray01('',null,null),null);
  return var1;
 END;
PROCEDURE pro1 IS
 V1 obj01;
 BEGIN
  V1:= fun1;
  for i in 1..V1.a.count loop
  dbe_output.print_line(V1.a(i));
  end loop;
 END;
END;
/
exec PAK1.pro1;
-- package test4
DROP PACKAGE PAK1;
CREATE OR REPLACE PACKAGE PAK1
IS
 FUNCTION fun1(a varray01) RETURN int;
 PROCEDURE pro1;
END;
/
CREATE OR REPLACE PACKAGE BODY PAK1
IS
 FUNCTION fun1(a varray01) RETURN int
IS
 var1 int;
 BEGIN
  var1 :=a.count;
  return var1;
 END;
PROCEDURE pro1 IS
 V1 INT;
 V2 varray01:=varray01(null,'',null);
 BEGIN
  V1:= fun1(V2);
  dbe_output.print_line(V1);
 END;
END;
/
exec PAK1.pro1;
-- package test5
DROP PACKAGE PAK1;
CREATE OR REPLACE PACKAGE PAK1
IS
 FUNCTION fun1(a varray01) RETURN obj01;
 PROCEDURE pro1;
END;
/
CREATE OR REPLACE PACKAGE BODY PAK1
IS
 FUNCTION fun1(a varray01) RETURN obj01
IS
  var3 obj01:=obj01(a,1);
 BEGIN
  return var3;
 END;
PROCEDURE pro1 IS
 V1 obj01;
 V2 varray01:=varray01(1,'',null);
 BEGIN
  V1:= fun1(V2);
  dbe_output.print_line(V1.a(1));
 END;
END;
/
exec PAK1.pro1;
-- package test6  expect error
DROP PACKAGE PAK1;
CREATE OR REPLACE PACKAGE PAK1
IS
 FUNCTION fun1(a varray01) RETURN varray01;
 PROCEDURE pro1;
END;
/
CREATE OR REPLACE PACKAGE BODY PAK1
IS
 FUNCTION fun1(a varray01) RETURN varray01
IS
 V3 varray01;
 BEGIN
  V3 :=a;
  return V3;
 END;
PROCEDURE pro1 IS
 V2 varray01;
 BEGIN
   V2:=fun1(V2);
  dbe_output.print_line(V2.count);
 END;
END;
/
exec PAK1.pro1;
-- package test7
DROP PACKAGE PAK1;
CREATE OR REPLACE PACKAGE PAK1
IS
 FUNCTION fun1(a obj01) RETURN obj01;
 PROCEDURE pro1;
END;
/
CREATE OR REPLACE PACKAGE BODY PAK1
IS
 FUNCTION fun1(a obj01) RETURN obj01
IS
  var3 obj01;
 BEGIN
  var3 :=a;
  return var3;
 END;
PROCEDURE pro1 IS
 V1 varray01:=varray01(1,'',null);
 V2 obj01:=obj01(V1,null);
 V3 obj01;
 BEGIN
  V3:= fun1(V2);
  dbe_output.print_line(V3.a(1));
 END;
END;
/
exec PAK1.pro1;

drop type if exists nest_table;
drop package if exists test_package;
CREATE OR REPLACE TYPE nest_table IS TABLE OF Integer;
/

CREATE OR REPLACE PACKAGE test_package
IS
PROCEDURE print_nest (nest nest_table);
END;
/

CREATE OR REPLACE PACKAGE BODY test_package
IS
PROCEDURE print_nest (nest nest_table) IS
  i NUMBER;
BEGIN
  i := nest.FIRST();
  IF i IS NULL THEN
    dbe_output.print_line('nest is empty');
  ELSE
    WHILE i IS NOT NULL LOOP
      dbe_output.print_line('nest(' || i || ') = ' || nest(i));
      i := nest.NEXT(i);
    END LOOP;
  END IF;
    dbe_output.print_line('---');
END print_nest;
END;
/

CREATE OR REPLACE TYPE nest_table IS TABLE OF Integer;
/

DECLARE
  nest nest_table := nest_table(11, 22, 33, 44, 55, 66);
BEGIN
  test_package.print_nest(nest);
  nest.TRIM; -- Trim last element
  test_package.print_nest(nest);
  nest.DELETE(4); -- Delete fourth element
  test_package.print_nest(nest);
  nest.TRIM(2); -- Trim last two elements
  test_package.print_nest(nest);
END;
/
drop type if exists nest_table;
drop package if exists test_package;

set serveroutput off;