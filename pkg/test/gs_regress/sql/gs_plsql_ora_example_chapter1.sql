--test orcle pl/sql example 
--URL: https://docs.oracle.com/cd/B28359_01/appdev.111/b28370/overview.htm#g12979

set serveroutput on;

--prepare table
drop table if exists employees;
CREATE TABLE employees
(
employee_id      number,
salary           number,
job_id           varchar2(32),
last_name        varchar2(32),
first_name       varchar2(32),
commission_pct   number,
hire_date        date,
manager_id       number
);

insert into employees values(1,1000,'PU_CLERK','zhang','san',500,'2017-5-4',10);
insert into employees values(2,2000,'SH_CLERK','li','si',1000,'2017-5-5',10);
insert into employees values(100,3000,'ST_CLERK','liu','xing',2000,'2017-5-6',10);
insert into employees values(115,2000,'SH_CLERK','lll','si',1000,'2017-5-5',10);
insert into employees values(120,4000,'ST_CLERK','wang',',xing',4000,'2018-5-6',10);
select * from employees;

--Example 1-1 PL/SQL Block Structure

DECLARE    -- Declarative part (optional)
  -- Declarations of local types, variables, & subprograms

BEGIN      -- Executable part (required)
  -- Statements (which can use items declared in declarative part)

EXCEPTION -- Exception-handling part (optional)
  -- Exception handlers for exceptions raised in executable part]
END;
/

--Example 1-2 PL/SQL Variable Declarations

DECLARE
    part_number       NUMBER(6);     -- SQL data type
    part_name         VARCHAR2(20);  -- SQL data type
    in_stock          BOOLEAN;       -- PL/SQL-only data type
    part_price        NUMBER(6,2);   -- SQL data type
    part_description  VARCHAR2(50);  -- SQL data type
  BEGIN
    NULL;
  END;
  /
 

--Example 1-3 Assigning Values to Variables with the Assignment Operator

DECLARE  -- You can assign values here
  wages          NUMBER;
  hours_worked   NUMBER := 40;
  hourly_salary  NUMBER := 22.50;
  bonus          NUMBER := 150;
  country        VARCHAR2(128);
  counter        NUMBER := 0;
  done           BOOLEAN;
  valid_id       BOOLEAN;
  emp_rec1       employees%ROWTYPE;
  emp_rec2       employees%ROWTYPE;
  TYPE commissions IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
  comm_tab       commissions;

BEGIN  -- You can assign values here too
   wages := (hours_worked * hourly_salary) + bonus;
   country := 'France';
   country := UPPER('Canada');
   done := (counter > 100);
   valid_id := TRUE;
   emp_rec1.first_name := 'Antonio';
   emp_rec1.last_name := 'Ortiz';
   emp_rec1 := emp_rec2;
   comm_tab(5) := 20000 * 0.15;
END;
/
 
 
 --Example 1-4 Using SELECT INTO to Assign Values to Variables

DECLARE
  bonus   NUMBER(8,2);
  emp_id  NUMBER(6) := 100;
BEGIN
  SELECT salary * 0.10 INTO bonus
    FROM employees
      WHERE employee_id = emp_id;
END;
/
  
  
  
--Example 1-5 Assigning Values to Variables as Parameters of a Subprogram

create or replace PROCEDURE adjust_salary (
  emp_id      NUMBER,
  sal IN  OUT NUMBER
) IS
  emp_job  VARCHAR2(10);
  avg_sal  NUMBER(8,2);
BEGIN
  SELECT job_id INTO emp_job
    FROM employees
      WHERE employee_id = emp_id;

  SELECT AVG(salary) INTO avg_sal
    FROM employees
      WHERE job_id = emp_job;

  dbe_output.print_line ('The average salary for '
                        || emp_job
                        || ' employees: '
                        || TO_CHAR(avg_sal)
                       );

  sal := (sal + avg_sal)/2;
END;
/

DECLARE
new_sal  NUMBER(8,2);
emp_id   NUMBER(6) := 126;
  BEGIN
    SELECT AVG(salary) INTO new_sal
      FROM employees;
    dbe_output.print_line ('The average salary for all employees: '
                          || TO_CHAR(new_sal)
                         );
  
    adjust_salary(emp_id, new_sal);
  END;
  /
 
drop procedure adjust_salary;


  
--Example 1-6 Using %ROWTYPE with an Explicit Cursor
DECLARE
  CURSOR c1 IS
    SELECT last_name, salary, hire_date, job_id
      FROM employees
        WHERE employee_id = 120;

   employee_rec c1%ROWTYPE;

BEGIN
  OPEN c1;
  FETCH c1 INTO employee_rec;
  dbe_output.print_line('Employee name: ' || employee_rec.last_name);
  CLOSE c1;
END;
/
  
  
--Example 1-7 Using a PL/SQL Collection Type

DECLARE
  TYPE staff_list IS TABLE OF employees.employee_id%TYPE;
  staff  staff_list;
  lname  employees.last_name%TYPE;
  fname  employees.first_name%TYPE;
BEGIN
  staff := staff_list(100, 114, 115, 120, 122);

  FOR i IN staff.FIRST..staff.LAST LOOP
    SELECT last_name, first_name INTO lname, fname
      FROM employees
        WHERE employees.employee_id = staff(i);

     dbe_output.print_line (TO_CHAR(staff(i))
                           || ': '
                           || lname
                           || ', '
                           || fname
                          );
  END LOOP;
END;
/
 
 
 
--Example 1-8 Declaring a Record Type

DECLARE
  TYPE timerec IS RECORD (
    hours   SMALLINT,
    minutes SMALLINT
  );

  TYPE meeting_type IS RECORD (
    date_held  DATE,
    duration   timerec,  -- nested record
    location   VARCHAR2(20),
    purpose    VARCHAR2(50)
  );

BEGIN
  NULL;
END;
/

--Example 1-9 Defining an Object Type

CREATE OR REPLACE TYPE bank_account AS OBJECT (
  acct_number NUMBER(5),
  balance     NUMBER,
  status      VARCHAR2(10),

  MEMBER PROCEDURE open
    (SELF IN OUT NOCOPY bank_account,
     amount IN NUMBER),

  MEMBER PROCEDURE close
    (SELF IN OUT NOCOPY bank_account,
     num IN NUMBER,
     amount OUT NUMBER),

  MEMBER PROCEDURE deposit
    (SELF IN OUT NOCOPY bank_account,
     num IN NUMBER,
     amount IN NUMBER),

  MEMBER PROCEDURE withdraw
    (SELF IN OUT NOCOPY bank_account,
     num IN NUMBER,
     amount IN NUMBER),

  MEMBER FUNCTION curr_bal (num IN NUMBER) RETURN NUMBER
);
/

--Example 1-10 Using the IF-THEN-ELSE and CASE Statement for Conditional Control

 DECLARE
    jobid      employees.job_id%TYPE;
    empid      employees.employee_id%TYPE := 115;
    sal        employees.salary%TYPE;
    sal_raise  NUMBER(3,2);
 BEGIN
   SELECT job_id, salary INTO jobid, sal
     FROM employees
       WHERE employee_id = empid;
 
   CASE
     WHEN jobid = 'PU_CLERK' THEN
       IF sal < 3000 THEN
         sal_raise := .12;
       ELSE
         sal_raise := .09;
       END IF;
 
     WHEN jobid = 'SH_CLERK' THEN
       IF sal < 4000 THEN
         sal_raise := .11;
       ELSE
         sal_raise := .08;
       END IF;
 
     WHEN jobid = 'ST_CLERK' THEN
       IF sal < 3500 THEN
         sal_raise := .10;
       ELSE
         sal_raise := .07;
       END IF;
 
     ELSE
       BEGIN
         dbe_output.print_line('No raise for this job: ' || jobid);
       END;
    END CASE;
 
    UPDATE employees
      SET salary = salary + salary * sal_raise
        WHERE employee_id = empid;
 END;
 /
 
 
--Example 1-11 Using the FOR-LOOP
drop table if exists sqr_root_sum;
CREATE TABLE sqr_root_sum (
  num NUMBER,
  sq_root NUMBER(6,2),
  sqr NUMBER,
  sum_sqrs NUMBER
);
DECLARE
   s  INTEGER;
BEGIN
  FOR i in 1..100 LOOP
    s := (i * (i + 1) * (2*i +1)) / 6;  -- sum of squares

    INSERT INTO sqr_root_sum
      VALUES (i, SQRT(i), i*i, s );
  END LOOP;
END;
/
drop table if exists sqr_root_sum;

--Example 1-12 Using WHILE-LOOP for Control
drop table if exists temp_20181220_whileloop;
CREATE TABLE temp_20181220_whileloop (
  tempid   NUMBER(6),
  tempsal  NUMBER(8,2),
  tempname VARCHAR2(25)
);

DECLARE
  sal             employees.salary%TYPE := 0;
  mgr_id          employees.manager_id%TYPE;
  lname           employees.last_name%TYPE;
  starting_empid  employees.employee_id%TYPE := 120;

BEGIN
   SELECT manager_id INTO mgr_id
     FROM employees
       WHERE employee_id = starting_empid;

   WHILE sal <= 15000 LOOP
     SELECT salary, manager_id, last_name INTO sal, mgr_id, lname
       FROM employees
         WHERE employee_id = mgr_id;
   END LOOP;

   INSERT INTO temp_20181220_whileloop
      VALUES (NULL, sal, lname);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    INSERT INTO temp_20181220_whileloop VALUES (NULL, NULL, 'Not found');
END;
/
drop table if exists temp_20181220_whileloop;


--Example 1-13 Using the EXIT-WHEN Statement

CREATE TABLE temp_20181220_exitwhen (
  tempid   NUMBER(6),
  tempsal  NUMBER(8,2),
  tempname VARCHAR2(25)
);

DECLARE
  total    NUMBER(9) := 0;
  counter  NUMBER(6) := 0;
BEGIN
  LOOP
    counter := counter + 1;
    total   := total + counter * counter;
    EXIT WHEN total > 25000;
  END LOOP;

  dbe_output.print_line ('Counter: '
                        || TO_CHAR(counter)
                        || ' Total: '
                        || TO_CHAR(total)
                       );
END;
/
drop table if exists temp_20181220_exitwhen;



--Example 1-14 Using the GOTO Statement

DECLARE
  total    NUMBER(9) := 0;
  counter  NUMBER(6) := 0;
BEGIN
  <<calc_total>>
  counter := counter + 1;
  total := total + counter * counter;

  IF total > 25000 THEN
    GOTO print_total;
  ELSE
    GOTO calc_total;
  END IF;

  <<print_total>>
  dbe_output.print_line
    ('Counter: ' || TO_CHAR(counter) || ' Total: ' || TO_CHAR(total));
END;
/



--Example 1-15 PL/SQL Procedure   
-- error: not support creating a inner PROCEDURE 
DECLARE
  in_string   VARCHAR2(100) := 'Test string';
  out_string  VARCHAR2(200);

  PROCEDURE double (
    original    IN  VARCHAR2,
    new_string  OUT VARCHAR2
  ) AS
  BEGIN
    new_string := original || original;
  END;

BEGIN
  dbe_output.print_line ('in_string: ' || in_string);
  double (in_string, out_string);
  dbe_output.print_line ('out_string: ' || out_string);
END;
/



--Example 1-16 Creating a Standalone PL/SQL Procedure

CREATE OR REPLACE PROCEDURE award_bonus (
  emp_id NUMBER, bonus NUMBER) AS
  commission    REAL;
  comm_missing  EXCEPTION;
BEGIN
  SELECT commission_pct / 100 INTO commission
    FROM employees
      WHERE employee_id = emp_id;

  IF commission IS NULL THEN
    RAISE comm_missing;
  ELSE
    UPDATE employees
      SET salary = salary + bonus*commission
        WHERE employee_id = emp_id;
  END IF;
EXCEPTION
  WHEN comm_missing THEN
    dbe_output.print_line
      ('This employee does not receive a commission.');
    commission := 0;
  WHEN OTHERS THEN
    NULL;
END award_bonus;
/
 
 

 --Example 1-17 Invoking a Standalone Procedure from SQL*Plus

-- Invoke standalone procedure with CALL statement
CALL award_bonus(179, 1000);
-- Invoke standalone procedure from within block

BEGIN
  award_bonus(179, 10000);
END;
/

drop procedure award_bonus;
 
 
 
 
--Example 1-18 Creating a Trigger
drop table if exists emp_audit_createTrigger;
CREATE TABLE emp_audit_createTrigger (
  emp_audit_id  NUMBER(6),
  up_date       DATE,
  new_sal       NUMBER(8,2),
  old_sal       NUMBER(8,2)
);

CREATE OR REPLACE TRIGGER audit_sal
  AFTER UPDATE OF salary
    ON employees
      FOR EACH ROW
BEGIN
  INSERT INTO emp_audit_createTrigger
    VALUES(:old.employee_id, SYSDATE, :new.salary, :old.salary);
END;
/
 
 drop table if exists emp_audit_createTrigger;
 drop TRIGGER audit_sal;

--Example 1-19 Creating a Package and Package Body
-- error: not support Package specification:

CREATE OR REPLACE PACKAGE emp_actions AS
  PROCEDURE hire_employee (
    employee_id     NUMBER,
    last_name       VARCHAR2,
    first_name      VARCHAR2,
    email           VARCHAR2,
    phone_number    VARCHAR2,
    hire_date       DATE,
    job_id          VARCHAR2,
    salary          NUMBER,
    commission_pct  NUMBER,
    manager_id      NUMBER,
    department_id   NUMBER
  );

  PROCEDURE fire_employee (emp_id NUMBER);

  FUNCTION num_above_salary (emp_id NUMBER) RETURN NUMBER;
END emp_actions;
/
-- Package body:
CREATE OR REPLACE PACKAGE BODY emp_actions AS
  -- Code for procedure hire_employee:
  PROCEDURE hire_employee (
    employee_id     NUMBER,
    last_name       VARCHAR2,
    first_name      VARCHAR2,
    email           VARCHAR2,
    phone_number    VARCHAR2,
    hire_date       DATE,
    job_id          VARCHAR2,
    salary          NUMBER,
    commission_pct  NUMBER,
    manager_id      NUMBER,
    department_id   NUMBER
  ) IS
  BEGIN
    INSERT INTO employees
      VALUES (employee_id,
              last_name,
              first_name,
              email,
              phone_number,
              hire_date,
              job_id,
              salary,
              commission_pct,
              manager_id,
              department_id);
  END hire_employee;

  -- Code for procedure fire_employee:
  PROCEDURE fire_employee (emp_id NUMBER) IS
  BEGIN
    DELETE FROM employees
      WHERE employee_id = emp_id;
  END fire_employee;
  -- Code for function num_above_salary:

  FUNCTION num_above_salary (emp_id NUMBER) RETURN NUMBER IS
    emp_sal NUMBER(8,2);
    num_count NUMBER;
  BEGIN
    SELECT salary INTO emp_sal
      FROM employees
        WHERE employee_id = emp_id;

    SELECT COUNT(*) INTO num_count
      FROM employees
        WHERE salary > emp_sal;

    RETURN num_count;
  END num_above_salary;
END emp_actions;
/
 

--Example 1-20 Invoking a Procedure in a Package
--error, same as Example 1-19
CALL emp_actions.hire_employee (300, 'Belden', 'Enrique',
  'EBELDEN', '555.111.2222',
  '31-AUG-04', 'AC_MGR', 9000,
  .1, 101, 110);
BEGIN
  dbe_output.print_line
    ('Number of employees with higher salary: ' ||
      TO_CHAR(emp_actions.num_above_salary(120)));

  emp_actions.fire_employee(300);
END;
/



--Example 1-21 Processing Query Results in a LOOP
BEGIN
  FOR someone IN (SELECT * FROM employees WHERE employee_id < 120)
  LOOP
    dbe_output.print_line('First name = ' || someone.first_name ||
                         ', Last name = ' || someone.last_name);
  END LOOP;
END;
/

--TO the end
select * from employees;
drop table if exists employees;

--DTS2019011607612
drop table if exists trigger8_bingfa_Tab_001;
create table trigger8_bingfa_Tab_001(id int primary key,sal number(10,2),name varchar(100),text clob default 'test',c_time date,m_time datetime);
insert into trigger8_bingfa_Tab_001 values(1,123.11,'test','lob',sysdate,sysdate);
insert into trigger8_bingfa_Tab_001 values(19,123.11,'test','lob',sysdate,sysdate);
insert into trigger8_bingfa_Tab_001 values(100,123.11,'test','lob',sysdate,sysdate);
create or replace procedure  FVT_FUNCTION_DDL_002_Proc_01 is
a varchar(10);
begin
select 'abc' into a from dual;
update trigger8_bingfa_Tab_001 set text = a;
end;
/
create or replace procedure  FVT_FUNCTION_DDL_002_Proc_02 is
a varchar(10);
begin
for i in 1..5
loop
sys.FVT_FUNCTION_DDL_002_Proc_01;
end loop;
end;
/
exec FVT_FUNCTION_DDL_002_Proc_02;

drop table if exists FVT_FUNCTION_DML_004_T_03;
create table FVT_FUNCTION_DML_004_T_03(id int,name varchar2(100));
drop user if exists FVT_FUNCTION_DML_004_U_01 cascade;
create user FVT_FUNCTION_DML_004_U_01 identified by password_123;

GRANT INSERT ON sys.FVT_FUNCTION_DML_004_T_03 TO FVT_FUNCTION_DML_004_U_01;
create or replace function  FVT_FUNCTION_DML_004_U_01.FVT_FUNCTION_DML_004_V_03 return int
is 
a int := 0;
begin
for i in  1..5
loop
insert into sys.FVT_FUNCTION_DML_004_T_03 values(2,'commit');
a := a+1;
end loop;
return a;
end;
/
select FVT_FUNCTION_DML_004_U_01.FVT_FUNCTION_DML_004_V_03;
--DTS2019011711418 
drop table if exists FVT_FUNCTION_DML_006_T;
drop table if exists FVT_FUNCTION_DML_006_T_02;
drop table if exists FVT_FUNCTION_DML_006_T_03;
create table FVT_FUNCTION_DML_006_T(id int,name varchar2(100));
create table FVT_FUNCTION_DML_006_T_02(id int ,name varchar2(100));
create table FVT_FUNCTION_DML_006_T_03(id int ,name varchar2(100));
insert into FVT_FUNCTION_DML_006_T values(30,'commit');
insert into FVT_FUNCTION_DML_006_T values(10,'commit');
insert into FVT_FUNCTION_DML_006_T_02 values(30,'commit');
insert into FVT_FUNCTION_DML_006_T_03 values(30,'commit');
create or replace function  FVT_FUNCTION_DML_006_V_03 return int
is 
a int := 0;
begin
for i in  1..5
loop
insert into sys.FVT_FUNCTION_DML_006_T_02 values(2,'commit');
a := a+1;
end loop;
return a;
end;
/
merge into FVT_FUNCTION_DML_006_T_02 t2 using  FVT_FUNCTION_DML_006_T t1 on (t2.id = t1.id) when  matched then update set t2.name = 'update' when not matched then insert(id,name) values (FVT_FUNCTION_DML_006_V_03(),'not matched');   
merge into FVT_FUNCTION_DML_006_T_02 t2 using  FVT_FUNCTION_DML_006_T t1 on (t2.id = t1.id) when  matched then update set t2.name = 'update' when not matched then insert(id,name) values (FVT_FUNCTION_DML_006_V_03,'not matched'); 
select * from FVT_FUNCTION_DML_006_T_02;
select * from FVT_FUNCTION_DML_006_T; 

insert into FVT_FUNCTION_DML_006_T_02 values(111,'commit');
select * from FVT_FUNCTION_DML_006_T; 
select * from FVT_FUNCTION_DML_006_T_02;
select * from FVT_FUNCTION_DML_006_T_03;
merge into FVT_FUNCTION_DML_006_T_03 t3 using  FVT_FUNCTION_DML_006_T_02 t2 on (t3.id = t2.id) when  matched then update set t3.name = 'update' when not matched then insert(id,name) values (FVT_FUNCTION_DML_006_V_03,'not matched');   
merge into FVT_FUNCTION_DML_006_T_03 t3 using  FVT_FUNCTION_DML_006_T_02 t2 on (t3.id = t2.id) when  matched then update set t3.name = 'update' when not matched then insert(id,name) values (FVT_FUNCTION_DML_006_V_03(),'not matched');
--DTS2019011204222
drop table if exists test_a;
drop table if exists test_b;
drop table if exists test1;

create table test1(a int, b int);

begin
	for i in 1..100 loop
		insert into test1(a, b)values(i, i);
	end loop; 
	
	commit;
end;
/

create table test_a(a int, b int);
insert into test_a(a, b)values(1, 1);
insert into test_a(a, b)values(2, 1);
insert into test_a(a, b)values(3, 1);
commit;

create table test_b(a int, b int);
insert into test_b(a, b)values(97, 1);
insert into test_b(a, b)values(98, 1);
insert into test_b(a, b)values(99, 1);
commit;

create or replace procedure test_p1
as
cursor cur_PHYCHID is select a from test1 where exists (select 1 from test_a  where test_a.a=test1.a) 
or exists (select 1 from test_b  where test_b.a=test1.a);
var_a    int;
str      varchar(256);
cnt      int;
begin
    cnt := 0;
    open cur_PHYCHID;
    fetch cur_PHYCHID into var_a;
    while cur_PHYCHID%found loop
    cnt := cnt + 1;
    dbe_stats.collect_table_stats('SYS','test_a');
    dbe_stats.collect_table_stats('SYS','test_b');
    
    fetch cur_PHYCHID into var_a;        
    end loop;
    
    dbe_output.print_line(cnt);
end;
/
exec test_p1;
--TRUNCATE TABLE
drop table if exists test_a;
drop table if exists test_b;
drop table if exists test1;

create table test1(a int, b int);

begin
	for i in 1..100 loop
		insert into test1(a, b)values(i, i);
	end loop; 
	
	commit;
end;
/

create table test_a(a int, b int);
insert into test_a(a, b)values(1, 1);
insert into test_a(a, b)values(2, 1);
insert into test_a(a, b)values(3, 1);
commit;

create table test_b(a int, b int);
insert into test_b(a, b)values(97, 1);
insert into test_b(a, b)values(98, 1);
insert into test_b(a, b)values(99, 1);
commit;
create or replace procedure test_p1
as
cursor cur_PHYCHID is select a from test1 where exists (select 1 from test_a  where test_a.a=test1.a) 
or exists (select 1 from test_b  where test_b.a=test1.a);
var_a    int;
str      varchar(256);
cnt      int;
begin
    cnt := 0;
    open cur_PHYCHID;
    fetch cur_PHYCHID into var_a;
    while cur_PHYCHID%found loop
    cnt := cnt + 1;
    str := 'truncate table test_a';
    execute immediate str;    
    str := 'truncate table test_b';
    execute immediate str;
    
    fetch cur_PHYCHID into var_a;
    end loop;
    
    dbe_output.print_line(cnt);
end;
/
exec test_p1;
--DROP TABLE
drop table if exists test_a;
drop table if exists test_b;
drop table if exists test1;

create table test1(a int, b int);

begin
	for i in 1..100 loop
		insert into test1(a, b)values(i, i);
	end loop; 
	
	commit;
end;
/

create table test_a(a int, b int);
insert into test_a(a, b)values(1, 1);
insert into test_a(a, b)values(2, 1);
insert into test_a(a, b)values(3, 1);
commit;

create table test_b(a int, b int);
insert into test_b(a, b)values(97, 1);
insert into test_b(a, b)values(98, 1);
insert into test_b(a, b)values(99, 1);
commit;
create or replace procedure test_p1
as
cursor cur_PHYCHID is select a from test1 where exists (select 1 from test_a  where test_a.a=test1.a) 
or exists (select 1 from test_b  where test_b.a=test1.a);
var_a    int;
str      varchar(256);
cnt      int;
begin
    cnt := 0;
    open cur_PHYCHID;
    fetch cur_PHYCHID into var_a;
    while cur_PHYCHID%found loop
    cnt := cnt + 1;
    str := 'drop table if exists test_a';
    execute immediate str;
    str := 'drop table if exists test_b';
    execute immediate str;
    
    fetch cur_PHYCHID into var_a;
    end loop;
    
    dbe_output.print_line(cnt);
end;
/

exec test_p1;
--DTS2019030609743
drop table if exists FVT_AUTOCOMMIT_PROC_005_Tab1;
create table FVT_AUTOCOMMIT_PROC_005_Tab1(id1 int, id2 int, id3 int, c_v1 varchar(4000),c_v2 varchar(4000),c_v3 varchar2(4000));

CREATE OR REPLACE PROCEDURE FVT_AUTOCOMMIT_PROC_005_P1(f1 int,f2 int,f3 int,f4 varchar,f5 varchar,f6 varchar2)
AS
BEGIN
insert into FVT_AUTOCOMMIT_PROC_005_Tab1 values(f1,f2,f3,f4,f5,f6);
END;
/
exec FVT_AUTOCOMMIT_PROC_005_P1(1, '1', 1,null,@#$Af'','?SFDsf');
--
drop table if exists test_part_t1;
create table test_part_t1(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)PARTITION BY RANGE(f1)( PARTITION p1 values less than(10), PARTITION p2 values less than(20), PARTITION p3 values less than(30), PARTITION p4 values less than(MAXVALUE));
create index idx_test_part_t1_1 on test_part_t1(f2,f3);
create index idx_test_part_t1_2 on test_part_t1(f4,f5) local;
insert into test_part_t1 values(5, 15, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(6, 16, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','TEST_PART_T1');
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_LOBSIZE(0,'SYS','TEST_PART_T1');
select DBE_DIAGNOSE.DBA_PARTITIONED_TABSIZE(0,'SYS','TEST_PART_T1');
drop table if exists test_part_t1;

DROP TABLE if exists env_prepare_t;
CREATE TABLE env_prepare_t(ID INT, NAME VARCHAR(64));

declare
v1 NUMBER;
v2 VARCHAR(20);
v3 INT;
v4 INT;
TYPE xxx IS RECORD( a INT, b INT, c env_prepare_t%ROWTYPE);
BEGIN
  DECLARE
  TYPE yyy IS RECORD( a INT, b INT, c xxx);
  v5 yyy;
  BEGIN
    v5.a := 1;
    v5.b := 2;
    v5.c.c.id := 3;
    dbe_output.print_line('v5.a:'||v5.a);
    dbe_output.print_line('v5.b:'||v5.b);
    dbe_output.print_line('v5.c.c.id:'||v5.c.c.id);
  END;
END;
/

DROP TABLE env_prepare_t;
CREATE TABLE env_prepare_t(ID INT, NAME VARCHAR(64));
INSERT INTO env_prepare_t VALUES(0, '');
INSERT INTO env_prepare_t VALUES(1, 'zyc');
COMMIT;

declare
TYPE xxx IS RECORD( a INT, b VARCHAR(64));
BEGIN
  DECLARE
  TYPE yyy IS RECORD( a INT, b INT, c xxx);
  v5 yyy;
  BEGIN
    SELECT * INTO v5.c FROM env_prepare_t WHERE id = 1;
    dbe_output.print_line('v5.c.b:'||v5.c.b);
  END;
END;
/

BEGIN
  DECLARE
  TYPE yyy IS RECORD( a INT, b VARCHAR(64));
  v5 yyy;
  BEGIN
    SELECT * INTO v5 FROM env_prepare_t WHERE id = 1;
    dbe_output.print_line('v5.b:'||v5.b);
  END;
END;
/

declare
v1 NUMBER;
v2 VARCHAR(64);
v3 INT;
v4 INT;
TYPE xxx IS RECORD( a INT, b VARCHAR(64));
BEGIN
  DECLARE
  v5 zzz;
  v6 xxx;
  BEGIN
    SELECT * INTO v6 FROM env_prepare_t WHERE id = 1;
    dbe_output.print_line('v6.b:'||v6.b);
  END;
END;
/

declare
v1 NUMBER;
v2 VARCHAR(20);
v3 INT;
v4 INT;
TYPE xxx IS RECORD( a INT, b INT);
BEGIN
  <<block1>>
  DECLARE
  TYPE xxx IS RECORD( a INT, b INT, c INT);
  v5 block1.xxx;
  BEGIN
    v5.a := 1;
    v5.b := 2;
    v5.c := 3;
    dbe_output.print_line('v5.a:'||v5.a);
    dbe_output.print_line('v5.b:'||v5.b);
    dbe_output.print_line('v5.c:'||v5.c);
  END;
end;
/

declare
v1 NUMBER;
v2 VARCHAR(20);
v3 INT;
v4 INT;
TYPE yyy IS RECORD( a INT, b INT);
BEGIN
  <<block1>>
  DECLARE
  TYPE xxx IS RECORD( a INT, b INT);
  v5 yyy;
  BEGIN
    block1.v5.a := 1;
    block1.v5.b := 2;
    dbe_output.print_line('v5.a:'||v5.a);
    dbe_output.print_line('v5.b:'||v5.b);
  END;
end;
/

drop table if exists forcursor_t;
create table forcursor_t(a int);
insert into forcursor_t values(1);
commit;

declare
b int := 1;
c int;
begin
for i in (select a from forcursor_t) loop
    select b into c from dual;
    dbe_output.print_line(c);
end loop;
end;
/

declare
 a sys_refcursor;
 b int;
begin
  b := 1;
  open a for 'select :1 from dual' using b;
  dbe_sql.return_cursor(a);
end;
/

declare
 a sys_refcursor;
 b int;
begin
  b := 1;
  open a for 'select :1,:1 from dual' using b;
  dbe_sql.return_cursor(a);
end;
/

declare
 a sys_refcursor;
 b int;
begin
  b := 1;
  open a for 'select :1,:2 from dual' using b, 2*b+1;
  dbe_sql.return_cursor(a);
end;
/

declare
 a sys_refcursor;
 b int;
begin
  b := 1;
  open a for 'select :1,:2 from dual' using in b, in 2*b+1;
  dbe_sql.return_cursor(a);
end;
/
----expected error
declare
 a sys_refcursor;
 b int;
begin
  b := 1;
  open a for 'select :1,:2 from dual' using out b, in 2*b+1;
  dbe_sql.return_cursor(a);
end;
/
declare
 a sys_refcursor;
 b int;
begin
  b := 1;
  open a for 'select :1,:2 from dual' using in out b, in 2*b+1;
  dbe_sql.return_cursor(a);
end;
/
declare
 a sys_refcursor;
 b int;
 c int;
begin
  b := 1;
  open a for 'select :1 into :2 from dual' using in b, out c;
  dbe_sql.return_cursor(a);
end;
/

declare
 a sys_refcursor;
 b int;
 c int;
begin
  b := 1;
  open a for 'select :1 from dual' using in b, in c;
  dbe_sql.return_cursor(a);
end;
/ 

declare
 a sys_refcursor;
 b int;
begin
  b := 1;
  open a for 'begin select :1 from dual; end' using in b;
  dbe_sql.return_cursor(a);
end;
/
declare
 a sys_refcursor;
 b int;
 c varchar(200);
begin
  b := 1;
  c := 'select :1 from dual';
  open a for c using in b;
  dbe_sql.return_cursor(a);
end;
/
declare
 a sys_refcursor;
 b int;
 c varchar(200);
begin
  b := 1;
  c := 'select 1 from dual';
  open a for c using in b;
  dbe_sql.return_cursor(a);
end;
/
declare
 a sys_refcursor;
 b int;
begin
  b := 1;
  open a for (select 1 from dual) using in out b;
  dbe_sql.return_cursor(a);
end;
/

declare
 a sys_refcursor;
 b int;
begin
  b := 1;
  open a for (select ?,? from dual) using in out b, in 2*b+1;
  dbe_sql.return_cursor(a);
end;
/

declare
 a sys_refcursor;
 b int;
begin
  b := 1;
  open a for (select 1 from dual) using in out b;
  dbe_sql.return_cursor(a);
end;
/
declare
 a sys_refcursor;
 b int;
begin
  b := 1;
  open a for 'select :1,:2 from dual' using in b;
  dbe_sql.return_cursor(a);
end;
/

declare
 a sys_refcursor;
 b int;
begin
  b := 1;
  open a for 'select :1 from dual' using b;
  b := 2;
  dbe_sql.return_cursor(a);
end;
/

set serveroutput off;