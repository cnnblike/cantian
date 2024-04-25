--
-- gs_plsql
-- testing oracle example
--
drop table if exists employees;
CREATE TABLE employees
(
employee_id number,
salary number,
job_id           varchar2(32),
last_name        varchar2(32),
first_name       varchar2(32),
commission_pct   number
);

insert into employees values(110, 1001, 'AF', 'jom','ZHANG',2.5);
insert into employees values(102, 1002, 'BF', 'back','ZHANG',2);
insert into employees values(103, 1003, 'BF',  'tom','ZHANG',3);
commit;

set serveroutput on;

--Example 4-6 Simple CASE Statement

DECLARE
  grade CHAR(1);
BEGIN
  grade := 'B';

  CASE grade
    WHEN 'A' THEN dbe_output.print_line('Excellent');
    WHEN 'B' THEN dbe_output.print_line('Very Good');
    WHEN 'C' THEN dbe_output.print_line('Good');
    WHEN 'D' THEN dbe_output.print_line('Fair');
    WHEN 'F' THEN dbe_output.print_line('Poor');
    ELSE dbe_output.print_line('No such grade');
  END CASE;
END;
/

--Example 4-7 Searched CASE Statement

DECLARE
  grade CHAR(1);
BEGIN
  grade := 'B';
  
  CASE
    WHEN grade = 'A' THEN dbe_output.print_line('Excellent');
    WHEN grade = 'B' THEN dbe_output.print_line('Very Good');
    WHEN grade = 'C' THEN dbe_output.print_line('Good');
    WHEN grade = 'D' THEN dbe_output.print_line('Fair');
    WHEN grade = 'F' THEN dbe_output.print_line('Poor');
    ELSE dbe_output.print_line('No such grade');
  END CASE;
END;
/

--Example 4-8 EXCEPTION Instead of ELSE Clause in CASE Statement

DECLARE
  grade CHAR(1);
BEGIN
  grade := 'B';
  
  CASE
    WHEN grade = 'A' THEN dbe_output.print_line('Excellent');
    WHEN grade = 'B' THEN dbe_output.print_line('Very Good');
    WHEN grade = 'C' THEN dbe_output.print_line('Good');
    WHEN grade = 'D' THEN dbe_output.print_line('Fair');
    WHEN grade = 'F' THEN dbe_output.print_line('Poor');
  END CASE;
EXCEPTION
  WHEN CASE_NOT_FOUND THEN
    dbe_output.print_line('No such grade');
END;
/

--Example 4-15 FOR LOOP Statements
BEGIN
  dbe_output.print_line ('lower_bound < upper_bound');
 
  FOR i IN 1..3 LOOP
    dbe_output.print_line (i);
  END LOOP;
 
  dbe_output.print_line ('lower_bound = upper_bound');
 
  FOR i IN 2..2 LOOP
    dbe_output.print_line (i);
  END LOOP;
 
  dbe_output.print_line ('lower_bound > upper_bound');
 
  FOR i IN 3..1 LOOP
    dbe_output.print_line (i);
  END LOOP;
END;
/


--Example 4-16 Reverse FOR LOOP Statements
BEGIN
  dbe_output.print_line ('upper_bound > lower_bound');
 
  FOR i IN REVERSE 1..3 LOOP
    dbe_output.print_line (i);
  END LOOP;
 
  dbe_output.print_line ('upper_bound = lower_bound');
 
  FOR i IN REVERSE 2..2 LOOP
    dbe_output.print_line (i);
  END LOOP;
 
  dbe_output.print_line ('upper_bound < lower_bound');
 
  FOR i IN REVERSE 3..1 LOOP
    dbe_output.print_line (i);
  END LOOP;
END;
/
 
--Example 4-17 Simulating STEP Clause in FOR LOOP Statement
DECLARE
  step  PLS_INTEGER := 5;
BEGIN
  FOR i IN 1..3 LOOP
    dbe_output.print_line (i*step);
  END LOOP;
END;
/

--Example 4-18 FOR LOOP Statement Tries to Change Index Value
BEGIN
  FOR i IN 1..3 LOOP
    IF i < 3 THEN
      dbe_output.print_line (TO_CHAR(i));
    ELSE
      i := 2;
    END IF;
  END LOOP;
END;
/
 
--Example 4-19 Outside Statement References FOR LOOP Statement Index
BEGIN
  FOR i IN 1..3 LOOP
    dbe_output.print_line ('Inside loop, i is ' || TO_CHAR(i));
  END LOOP;
  
  dbe_output.print_line ('Outside loop, i is ' || TO_CHAR(i));
END;
/

--Example 4-20 FOR LOOP Statement Index with Same Name as Variable
DECLARE
  i NUMBER := 5;
BEGIN
  FOR i IN 1..3 LOOP
    dbe_output.print_line ('Inside loop, i is ' || TO_CHAR(i));
  END LOOP;
  
  dbe_output.print_line ('Outside loop, i is ' || TO_CHAR(i));
END;
/
 
-- Example 4-21 FOR LOOP Statement References Variable with Same Name as Index
--expect success
<<main>>  -- Label block.
DECLARE
  i NUMBER := 5;
BEGIN
  FOR i IN 1..3 LOOP
    dbe_output.print_line (
      'local: ' || TO_CHAR(i) || ', global: ' ||
      TO_CHAR(main.i)  -- Qualify reference with block label.
    );
  END LOOP;
END main;
/

--expect success
<<main>>  -- Label block.
DECLARE
  i NUMBER := 5;
BEGIN
  FOR i IN 1..3 LOOP
    dbe_output.print_line (
      'local: ' || TO_CHAR(i) || ', global: ' ||
      TO_CHAR(main.i)  -- Qualify reference with block label.
    );
  END LOOP;
END;
/

--expect error
create or replace procedure proc_test is
<<main>>  -- Label block.
DECLARE
  i NUMBER := 5;
BEGIN
  FOR i IN 1..3 LOOP
    dbe_output.print_line (
      'local: ' || TO_CHAR(i) || ', global: ' ||
      TO_CHAR(main.i)  -- Qualify reference with block label.
    );
  END LOOP;
END main;
/

 
--Example 4-22 Nested FOR LOOP Statements with Same Index Name
BEGIN
  <<outer_loop>>
  FOR i IN 1..3 LOOP
    <<inner_loop>>
    FOR i IN 1..3 LOOP
      IF outer_loop.i = 2 THEN
        dbe_output.print_line
          ('outer: ' || TO_CHAR(outer_loop.i) || ' inner: '
           || TO_CHAR(inner_loop.i));
      END IF;
    END LOOP inner_loop;
  END LOOP outer_loop;
END;
/

--Example 4-23 FOR LOOP Statement Bounds
DECLARE
  first  INTEGER := 1;
  last   INTEGER := 10;
  high   INTEGER := 100;
  low    INTEGER := 12;
BEGIN
  -- Bounds are numeric literals:
  FOR j IN -5..5 LOOP
    NULL;
  END LOOP;
 
  -- Bounds are numeric variables:
  FOR k IN REVERSE first..last LOOP
    NULL;
  END LOOP;
 
 -- Lower bound is numeric literal,
 -- Upper bound is numeric expression:
  FOR step IN 0..(TRUNC(high/low) * 2) LOOP
    NULL;
  END LOOP;
END;
/

--Example 4-24 Specifying FOR LOOP Statement Bounds at Run Time
DROP TABLE if exists temp;
CREATE TABLE temp (
  emp_no      NUMBER,
  email_addr  VARCHAR2(50)
);
 
DECLARE
  emp_count  NUMBER;
BEGIN
  SELECT COUNT(employee_id) INTO emp_count
  FROM employees;
  
  FOR i IN 1..emp_count LOOP
    INSERT INTO temp (emp_no, email_addr)
    VALUES(i, 'to be added later');
  END LOOP;
END;
/

select * from temp;

--Example 4-25 EXIT WHEN Statement in FOR LOOP Statement
DECLARE
  v_employees employees%ROWTYPE;
  CURSOR c1 is SELECT * FROM employees;
BEGIN
  OPEN c1;
  -- Fetch entire row into v_employees record:
  FOR i IN 1..10 LOOP
    FETCH c1 INTO v_employees;
    EXIT WHEN c1%NOTFOUND;
    -- Process data here
  END LOOP;
  CLOSE c1;
END;
/

--Example 4-26 EXIT WHEN Statement in Inner FOR LOOP Statement

DECLARE
  v_employees employees%ROWTYPE;
  CURSOR c1 is SELECT * FROM employees;
BEGIN
  OPEN c1;
  
  -- Fetch entire row into v_employees record:
  <<outer_loop>>
  FOR i IN 1..10 LOOP
    -- Process data here
    FOR j IN 1..10 LOOP
      FETCH c1 INTO v_employees;
      EXIT outer_loop WHEN c1%NOTFOUND;
      -- Process data here
    END LOOP;
  END LOOP outer_loop;
 
  CLOSE c1;
END;
/

--Example 4-27 CONTINUE WHEN Statement in Inner FOR LOOP Statement

DECLARE
  v_employees employees%ROWTYPE;
  CURSOR c1 is SELECT * FROM employees;
BEGIN
  OPEN c1;
  
  -- Fetch entire row into v_employees record:
  <<outer_loop>>
  FOR i IN 1..10 LOOP
    -- Process data here
    FOR j IN 1..10 LOOP
      FETCH c1 INTO v_employees;
      CONTINUE outer_loop WHEN c1%NOTFOUND;
      -- Process data here
    END LOOP;
  END LOOP outer_loop;
 
  CLOSE c1;
END;
/

--test case when
--add 2018/07/09
--Example 3-2 Printing BOOLEAN Values
drop PROCEDURE if exists print_boolean;
CREATE PROCEDURE print_boolean (b BOOLEAN)
AS
BEGIN
  dbe_output.print_line (
    CASE
      WHEN b IS NULL THEN 'Unknown'
      WHEN b THEN 'Yes'
      WHEN NOT b THEN 'No'
    END
  );
END;
/
BEGIN
  print_boolean(TRUE);
  print_boolean(FALSE);
  print_boolean(NULL);
END;
/

drop PROCEDURE print_boolean;

--Example 4-6 Simple CASE Statement
DECLARE
  grade CHAR(1);
BEGIN
  grade := 'B';

  CASE grade
    WHEN 'A' THEN dbe_output.print_line('Excellent');
    WHEN 'B' THEN dbe_output.print_line('Very Good');
    WHEN 'C' THEN dbe_output.print_line('Good');
    WHEN 'D' THEN dbe_output.print_line('Fair');
    WHEN 'F' THEN dbe_output.print_line('Poor');
    ELSE dbe_output.print_line('No such grade');
  END CASE;
END;
/

--test case ..end;
--expect error
DECLARE
  grade CHAR(1);
BEGIN
  grade := 'B';

  CASE grade
    WHEN 'A' THEN dbe_output.print_line('Excellent');
    WHEN 'B' THEN dbe_output.print_line('Very Good');
    WHEN 'C' THEN dbe_output.print_line('Good');
    WHEN 'D' THEN dbe_output.print_line('Fair');
    WHEN 'F' THEN dbe_output.print_line('Poor');
    ELSE dbe_output.print_line('No such grade');
  END;
END;
/

--Example 4-7 Searched CASE Statement
DECLARE
  grade CHAR(1);
BEGIN
  grade := 'B';
  
  CASE
    WHEN grade = 'A' THEN dbe_output.print_line('Excellent');
    WHEN grade = 'B' THEN dbe_output.print_line('Very Good');
    WHEN grade = 'C' THEN dbe_output.print_line('Good');
    WHEN grade = 'D' THEN dbe_output.print_line('Fair');
    WHEN grade = 'F' THEN dbe_output.print_line('Poor');
    ELSE dbe_output.print_line('No such grade');
  END CASE;
END;
/
 
--Example 4-8 EXCEPTION Instead of ELSE Clause in CASE Statement

DECLARE
  grade CHAR(1);
BEGIN
  grade := 'E';
  
  CASE
    WHEN grade = 'A' THEN dbe_output.print_line('Excellent');
    WHEN grade = 'B' THEN dbe_output.print_line('Very Good');
    WHEN grade = 'C' THEN dbe_output.print_line('Good');
    WHEN grade = 'D' THEN dbe_output.print_line('Fair');
    WHEN grade = 'F' THEN dbe_output.print_line('Poor');
  END CASE;
EXCEPTION
  WHEN CASE_NOT_FOUND THEN
    dbe_output.print_line('No such grade');
END;
/

--Example 4-9 Basic LOOP Statement with EXIT Statement
DECLARE
  x NUMBER := 0;
BEGIN
  LOOP
    dbe_output.print_line ('Inside loop:  x = ' || TO_CHAR(x));
    x := x + 1;
    IF x > 3 THEN
      EXIT;
    END IF;
  END LOOP;
  -- After EXIT, control resumes here
  dbe_output.print_line(' After loop:  x = ' || TO_CHAR(x));
END;
/

--Example 4-10 Basic LOOP Statement with EXIT WHEN Statement
DECLARE
  x NUMBER := 0;
BEGIN
  LOOP
    dbe_output.print_line('Inside loop:  x = ' || TO_CHAR(x));
    x := x + 1;  -- prevents infinite loop
    EXIT WHEN x > 3;
  END LOOP;
  -- After EXIT statement, control resumes here
  dbe_output.print_line('After loop:  x = ' || TO_CHAR(x));
END;
/
 
 
--Example 4-11 Nested, Labeled Basic LOOP Statements with EXIT WHEN Statements
DECLARE
  s  INTEGER := 0;
  i  INTEGER := 0;
  j  INTEGER;
BEGIN
  <<outer_loop>>
  LOOP
    i := i + 1;
    j := 0;
    <<inner_loop>>
    LOOP
      j := j + 1;
      s := s + i * j; -- Sum several products
      EXIT inner_loop WHEN (j > 5);
      EXIT outer_loop WHEN ((i * j) > 15);
    END LOOP inner_loop;
  END LOOP outer_loop;
  dbe_output.print_line
    ('The sum of products equals: ' || TO_CHAR(s));
END;
/

--Example 4-12 Nested, Unabeled Basic LOOP Statements with EXIT WHEN Statements
DECLARE
  i INTEGER := 0;
  j INTEGER := 0;
 
BEGIN
  LOOP
    i := i + 1;
    dbe_output.print_line ('i = ' || i);
    
    LOOP
      j := j + 1;
      dbe_output.print_line ('j = ' || j);
      EXIT WHEN (j > 3);
    END LOOP;
 
    dbe_output.print_line ('Exited inner loop');
 
    EXIT WHEN (i > 2);
  END LOOP;
 
  dbe_output.print_line ('Exited outer loop');
END;
/ 

--Example 4-13 CONTINUE Statement in Basic LOOP Statement
DECLARE
  x NUMBER := 0;
BEGIN
  LOOP -- After CONTINUE statement, control resumes here
    dbe_output.print_line ('Inside loop:  x = ' || TO_CHAR(x));
    x := x + 1;
    IF x < 3 THEN
      CONTINUE;
    END IF;
    dbe_output.print_line
      ('Inside loop, after CONTINUE:  x = ' || TO_CHAR(x));
    EXIT WHEN x = 5;
  END LOOP;
 
  dbe_output.print_line (' After loop:  x = ' || TO_CHAR(x));
END;
/

--Example 4-15 FOR LOOP Statements
BEGIN
  dbe_output.print_line ('lower_bound < upper_bound');
 
  FOR i IN 1..3 LOOP
    dbe_output.print_line (i);
  END LOOP;
 
  dbe_output.print_line ('lower_bound = upper_bound');
 
  FOR i IN 2..2 LOOP
    dbe_output.print_line (i);
  END LOOP;
 
  dbe_output.print_line ('lower_bound > upper_bound');
 
  FOR i IN 3..1 LOOP
    dbe_output.print_line (i);
  END LOOP;
END;
/

--Example 4-16 Reverse FOR LOOP Statements
BEGIN
  dbe_output.print_line ('upper_bound > lower_bound');
 
  FOR i IN REVERSE 1..3 LOOP
    dbe_output.print_line (i);
  END LOOP;
 
  dbe_output.print_line ('upper_bound = lower_bound');
 
  FOR i IN REVERSE 2..2 LOOP
    dbe_output.print_line (i);
  END LOOP;
 
  dbe_output.print_line ('upper_bound < lower_bound');
 
  FOR i IN REVERSE 3..1 LOOP
    dbe_output.print_line (i);
  END LOOP;
END;
/
 
--Example 4-17 Simulating STEP Clause in FOR LOOP Statement
DECLARE
  step  PLS_INTEGER := 5;
BEGIN
  FOR i IN 1..3 LOOP
    dbe_output.print_line (i*step);
  END LOOP;
END;
/

--Example 4-18 FOR LOOP Statement Tries to Change Index Value
BEGIN
  FOR i IN 1..3 LOOP
    IF i < 3 THEN
      dbe_output.print_line (TO_CHAR(i));
    ELSE
      i := 2;
    END IF;
  END LOOP;
END;
/

--Example 4-19 Outside Statement References FOR LOOP Statement Index
BEGIN
  FOR i IN 1..3 LOOP
    dbe_output.print_line ('Inside loop, i is ' || TO_CHAR(i));
  END LOOP;
  
  dbe_output.print_line ('Outside loop, i is ' || TO_CHAR(i));
END;
/

--Example 4-20 FOR LOOP Statement Index with Same Name as Variable
DECLARE
  i NUMBER := 5;
BEGIN
  FOR i IN 1..3 LOOP
    dbe_output.print_line ('Inside loop, i is ' || TO_CHAR(i));
  END LOOP;
  
  dbe_output.print_line ('Outside loop, i is ' || TO_CHAR(i));
END;
/

--Example 4-21 FOR LOOP Statement References Variable with Same Name as Index
<<main>>  -- Label block.
DECLARE
  i NUMBER := 5;
BEGIN
  FOR i IN 1..3 LOOP
    dbe_output.print_line (
      'local: ' || TO_CHAR(i) || ', global: ' ||
      TO_CHAR(main.i)  -- Qualify reference with block label.
    );
  END LOOP;
END main;
/ 

--Example 4-22 Nested FOR LOOP Statements with Same Index Name
BEGIN
  <<outer_loop>>
  FOR i IN 1..3 LOOP
    <<inner_loop>>
    FOR i IN 1..3 LOOP
      IF outer_loop.i = 2 THEN
        dbe_output.print_line
          ('outer: ' || TO_CHAR(outer_loop.i) || ' inner: '
           || TO_CHAR(inner_loop.i));
      END IF;
    END LOOP inner_loop;
  END LOOP outer_loop;
END;
/

--Example 4-23 FOR LOOP Statement Bounds
DECLARE
  first  INTEGER := 1;
  last   INTEGER := 10;
  high   INTEGER := 100;
  low    INTEGER := 12;
BEGIN
  -- Bounds are numeric literals:
  FOR j IN -5..5 LOOP
    NULL;
  END LOOP;
 
  -- Bounds are numeric variables:
  FOR k IN REVERSE first..last LOOP
    NULL;
  END LOOP;
 
 -- Lower bound is numeric literal,
 -- Upper bound is numeric expression:
  FOR step IN 0..(TRUNC(high/low) * 2) LOOP
    NULL;
  END LOOP;
END;
/

--Example 4-24 Specifying FOR LOOP Statement Bounds at Run Time
DROP TABLE if exists temp;
CREATE TABLE temp (
  emp_no      NUMBER,
  email_addr  VARCHAR2(50)
);

 
DECLARE
  emp_count  NUMBER;
BEGIN
  SELECT COUNT(employee_id) INTO emp_count
  FROM employees;
  
  FOR i IN 1..emp_count LOOP
    INSERT INTO temp (emp_no, email_addr)
    VALUES(i, 'to be added later');
	dbe_output.print_line('LOOP:' || i);
  END LOOP;
END;
/

--Example 4-25 EXIT WHEN Statement in FOR LOOP Statement
DECLARE
  v_employees employees%ROWTYPE;
  CURSOR c1 is SELECT * FROM employees;
BEGIN
  OPEN c1;
  -- Fetch entire row into v_employees record:
  FOR i IN 1..10 LOOP
    FETCH c1 INTO v_employees;
	dbe_output.print_line('LOOP:' || i);
    EXIT WHEN c1%NOTFOUND;
    -- Process data here
  END LOOP;
  CLOSE c1;
END;
/

--Example 4-26 EXIT WHEN Statement in Inner FOR LOOP Statement
DECLARE
  v_employees employees%ROWTYPE;
  CURSOR c1 is SELECT * FROM employees;
BEGIN
  OPEN c1;
  
  -- Fetch entire row into v_employees record:
  <<outer_loop>>
  FOR i IN 1..10 LOOP
    -- Process data here
    FOR j IN 1..10 LOOP
      FETCH c1 INTO v_employees;
	  dbe_output.print_line('LOOP:' || i);
      EXIT outer_loop WHEN c1%NOTFOUND;
      -- Process data here
    END LOOP;
  END LOOP outer_loop;
 
  CLOSE c1;
END;
/

--Example 4-27 CONTINUE WHEN Statement in Inner FOR LOOP Statement
DECLARE
  v_employees employees%ROWTYPE;
  CURSOR c1 is SELECT * FROM employees;
BEGIN
  OPEN c1;
  
  -- Fetch entire row into v_employees record:
  <<outer_loop>>
  FOR i IN 1..10 LOOP
    -- Process data here
    FOR j IN 1..10 LOOP
      FETCH c1 INTO v_employees;
	  dbe_output.print_line('LOOP:' || j);
      CONTINUE outer_loop WHEN c1%NOTFOUND;
      -- Process data here
    END LOOP;
  END LOOP outer_loop;
 
  CLOSE c1;
END;
/

--Example 4-28 WHILE LOOP Statements
DECLARE
  done  BOOLEAN := FALSE;
BEGIN
  WHILE done LOOP
    dbe_output.print_line ('This line does not print.');
    done := TRUE;  -- This assignment is not made.
  END LOOP;

  WHILE NOT done LOOP
    dbe_output.print_line ('Hello, world!');
    done := TRUE;
  END LOOP;
END;
/

--Example 4-29 GOTO Statement
DECLARE
  p  VARCHAR2(30);
  n  INTEGER := 37;
BEGIN
  FOR j in 2..ROUND(SQRT(n)) LOOP
    IF n % j = 0 THEN
      p := ' is not a prime number';
      GOTO print_now;
    END IF;
  END LOOP;

  p := ' is a prime number';
 
  <<print_now>>
  dbe_output.print_line(TO_CHAR(n) || p);
END;
/

--Example 4-30 Incorrect Label Placement
--expect error
DECLARE
  done  BOOLEAN;
BEGIN
  FOR i IN 1..50 LOOP
    IF done THEN
       GOTO end_loop;
    END IF;
    <<end_loop>>
  END LOOP;
END;
/

--Example 4-31 GOTO Statement Goes to Labeled NULL Statement
DECLARE
  done  BOOLEAN;
BEGIN
  FOR i IN 1..50 LOOP
    IF done THEN
      GOTO end_loop;
    END IF;
    <<end_loop>>
    NULL;
  END LOOP;
END;
/  



--Example 4-32 GOTO Statement Transfers Control to Enclosing Block
DECLARE
  v_last_name  VARCHAR2(25);
  v_emp_id     NUMBER(6) := 120;
BEGIN
  <<get_name>>
  SELECT last_name INTO v_last_name
  FROM employees
  WHERE employee_id = v_emp_id;
  
  BEGIN
    dbe_output.print_line (v_last_name);
    v_emp_id := v_emp_id + 5;
 
    IF v_emp_id < 120 THEN
      GOTO get_name;
    END IF;
  END;
END;
/

--Example 4-33 GOTO Statement Cannot Transfer Control into IF Statement
--expect success
DECLARE
  valid BOOLEAN := TRUE;
BEGIN
  GOTO update_row;
  
  IF valid THEN
  <<update_row>>
    NULL;
  END IF;
END;
/

--Example 4-34 NULL Statement Showing No Action
DECLARE
  v_job_id  VARCHAR2(10);
   v_emp_id  NUMBER(6) := 110;
BEGIN
  SELECT job_id INTO v_job_id
  FROM employees
  WHERE employee_id = v_emp_id;
  
  IF v_job_id = 'SA_REP' THEN
    UPDATE employees
    SET commission_pct = commission_pct * 1.2;
  ELSE
    NULL;  -- Employee is not a sales rep
  END IF;
END;
/

--Example 4-35 NULL Statement as Placeholder During Subprogram Creation
CREATE OR REPLACE PROCEDURE award_bonus (
  emp_id NUMBER,
  bonus NUMBER
)  AS
BEGIN    -- Executable part starts here
  NULL;  -- Placeholder
  -- (raises "unreachable code" if warnings enabled)
END award_bonus;
/ 


--Example 4-36 NULL Statement in ELSE Clause of Simple CASE Statement
CREATE OR REPLACE PROCEDURE print_grade (
  grade CHAR
)  AS
BEGIN
  CASE grade
    WHEN 'A' THEN dbe_output.print_line('Excellent');
    WHEN 'B' THEN dbe_output.print_line('Very Good');
    WHEN 'C' THEN dbe_output.print_line('Good');
    WHEN 'D' THEN dbe_output.print_line('Fair');
    WHEN 'F' THEN dbe_output.print_line('Poor');
    ELSE NULL;
  END CASE;
END;
/
BEGIN
  print_grade('A');
  print_grade('S');
END;
/

--Example 6-18 Implicit Cursor FOR LOOP Statement
BEGIN
  FOR item IN (
    SELECT last_name, job_id
    FROM employees
  )
  LOOP
    dbe_output.print_line
      ('Name = ' || item.last_name || ', Job = ' || item.job_id);
  END LOOP;
END;
/

--Example 6-19 Explicit Cursor FOR LOOP Statement

DECLARE
  CURSOR c1 IS
    SELECT last_name, job_id FROM employees;
BEGIN
  FOR item IN c1
  LOOP
    dbe_output.print_line
      ('Name = ' || item.last_name || ', Job = ' || item.job_id);
  END LOOP;
END;
/

--Example 6-20 Passing Parameters to Explicit Cursor FOR LOOP Statement
DECLARE
  CURSOR c1 (job VARCHAR2, max_wage NUMBER) IS
    SELECT * FROM employees
    WHERE job_id = job
    AND salary > max_wage;
BEGIN
  FOR person IN c1('AF', 0)
  LOOP
     -- process data record
    dbe_output.print_line (
      'Name = ' || person.last_name || ', salary = ' ||
      person.salary || ', Job Id = ' || person.job_id
    );
  END LOOP;
END;
/

--Example 6-21 Cursor FOR Loop References Virtual Columns
BEGIN
  FOR item IN (
    SELECT first_name || ' ' || last_name AS full_name,
           salary * 10                    AS dream_salary 
    FROM employees
    WHERE ROWNUM <= 5
    ORDER BY dream_salary DESC, last_name ASC
  ) LOOP
    dbe_output.print_line
      (item.full_name || ' dreams of making ' || item.dream_salary);
  END LOOP;
END;
/


--dynamic sql execute need change schema.
--begin
create user whf001 identified by Whf00174302;
grant dba to whf001;
conn whf001/Whf00174302@127.0.0.1:1611
drop table if exists test;
create table test(a int);
create or replace procedure xxxx(a1 int)
as
a varchar2(100);
begin
 a := 'select * from test';
 execute immediate a;
end;
/
call xxxx(1);
conn sys/Huawei@123@127.0.0.1:1611
call whf001.xxxx(1);
drop table whf001.test;
drop procedure whf001.xxxx;
--purge recyclebin;
--select sleep(1);
--drop user whf001 cascade;
--end

set autocommit on
drop table if exists plsql_ora_test;
create table plsql_ora_test(a int);

create or replace procedure plsql_ora_test_x1
is
begin
insert into plsql_ora_test values(1);
insert into plsql_ora_test values(1);
insert into plsql_ora_test values(1);
insert into plsql_ora_test values(1);
end;
/

create or replace procedure plsql_ora_test_x2
is
begin
insert into plsql_ora_test values('asdfsdf');
end;
/

create or replace procedure plsql_ora_test_x3
is
begin
plsql_ora_test_x1();
plsql_ora_test_x2();
end;
/
exec plsql_ora_test_x3;
select count(*) from plsql_ora_test;

create or replace procedure plsql_ora_test_x3
is
begin
plsql_ora_test_x1();
end;
/
exec plsql_ora_test_x3;
rollback;
select count(*) from plsql_ora_test;

set autocommit off
----test anonymous soft-parse

declare
a varchar(20);
begin
select 'soft-parse' into a from dual;
end;
/

declare
cursor a is select 'soft-parse-cursor' from dual;
b varchar(20);
begin
open a;
fetch a into b;
close a;
end;
/

declare
b int;
begin
for i in (select 'soft-parse-inloop' from dual) loop
    null;
end loop;
end;
/


declare
cursor a is select 'soft-parse-cursor-loop' from dual;
b int;
begin
for i in a loop
    null;
end loop;
end;
/

declare
cursor a is select 'soft-parse-cursor' from dual;
begin
null;
end;
/

declare
cursor a is select 'soft-parse-cursor' from dual;
begin
open a;
end;
/

create or replace procedure soft_parse_proc_test
is
cursor a is select 'soft-parse-cursor' from dual;
begin
null;
end;
/
exec soft_parse_proc_test();
call soft_parse_proc_test();
--DTS2018091106833
declare
  v_int int;
begin
    if('true')
    then
        dbe_output.print_line('The condition is true');
    end if;
end;
/
declare
  v_int int;
begin
    if('false')
    then
        dbe_output.print_line('The condition is false');
    end if;
end;
/
--DTS2018092807688
drop table if exists t_expression_base;
create table t_expression_base(f1 int, f2 int);
insert into t_expression_base values(1,100);
insert into t_expression_base values(2,1000);
commit;

create or replace procedure sp_expression_00002(v_PlanID in number)
as 
    v_Temp_1 number(10, 0);
begin
    v_Temp_1 :=10000;
    insert into t_expression_base(f1, f2) select f1,SUM(v_Temp_1+f1+f2) from t_expression_base group by f1;
end;
/
--DTS2018092708071
declare
v_num number;
begin
select 
1+2*2  +a1  into v_num from dual;
dbe_output.print_line(v_num);
end;
/
--
create table if not exists t_P_BTSESN_A4(PLANID NUMBER(10), CMENEID NUMBER(10),BTSID NUMBER(10), MAINDEVTAB VARCHAR(96), BAKDEVTAB VARCHAR(96), OMBEARBOARD NUMBER(3));
create table if not exists t_D_BTSESN_A4(SAVEPOINTID NUMBER(10), OPERTYPE NUMBER(3),PLANID NUMBER(10), CMENEID NUMBER(10),BTSID NUMBER(10),MAINDEVTAB VARCHAR(96),BAKDEVTAB VARCHAR(96), OMBEARBOARD NUMBER(3), LOGUPTID VARCHAR(383), NBI_RECID NUMBER(10), ISGENMML NUMBER(3));
create or replace function M_BTS_BTSTYPE__NG(v_EnumValue in number) return number
is
    v_Result number(10, 0);
begin
    v_Result := 0;
    begin
        select 1 into v_Result from dual where (v_EnumValue in  (20, 21, 22, 17, 18, 19, 30, 23, 24)) and rownum <= 1;
    exception
        when no_data_found then
            null;
    end;
    return v_Result;
end;
/
insert into t_P_BTSESN_A4 (planid) values(1);
insert into t_D_BTSESN_A4 (planid) values(1);
commit;
select * from t_P_BTSESN_A4 a join t_D_BTSESN_A4 b on 0 = M_BTS_BTSTYPE__NG(b.OPERTYPE);

--DTS2018100910219 
drop user if exists user9 cascade;
create user user9 identified by cantian_234;
grant all to user9;
conn user9/cantian_234@127.0.0.1:1611
DROP table if exists t_prd_009;
create table t_prd_009(id int,name varchar2(20));
drop sequence if exists s_t_prd_009;
create sequence s_t_prd_009 INCREMENT by 1 start with 10 nocycle NOCACHE;
select user9.s_t_prd_009.NEXTVAL ,user9.s_t_prd_009.CURRVAL from dual;
create or replace procedure p_t_prd_009_mid(
  v_id    in  int
  ) AS
  v_sql VARCHAR2(2000);
BEGIN
        insert into t_prd_009 values(user9.s_t_prd_009.NEXTVAL,'HW'||user9.s_t_prd_009.NEXTVAL);
        commit;
        dbe_output.print_line(user9.s_t_prd_009.NEXTVAL);
END p_t_prd_009_mid;
/
set serveroutput on;
call p_t_prd_009_mid(5);

CREATE OR REPLACE FUNCTION F1 RETURN varchar IS
 A varchar(100) ;
 BEGIN
	 declare
	 B NUMERIC(6,4);
	 begin
	 B := 20.2345;
	 SELECT B INTO A FROM dual;
	 RETURN A;
	 end;
 END F1;
 /
select f1();

create or replace procedure p1(f1 in int)
is 
v_refcur2 SYS_REFCURSOR;
i decimal := 12567890123456;
begin
open v_refcur2 for select i from dual;
dbe_sql.return_cursor(v_refcur2);
end;
/
call p1(1);
create or replace procedure p2(f1 in int, f2 in int) 
is 
v_refcur2 SYS_REFCURSOR;
begin
for i in 1..2
loop
open v_refcur2 for select i from dual;
dbe_sql.return_cursor(v_refcur2); 
end loop;
end;
/
call p2(1,2);

--DTS2018111610061 
drop table if exists emp;
create table emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
insert into emp values(1,'zhansi','doctor1',10000),(2,'lisiabc','doctor2',10000),(123,'zhangwu123','doctor3',10000);
insert into emp values(10,'abc','worker',9000);
insert into emp values(716,'ZHANGSAN','leader',20000);
set serveroutput on;
declare
a emp%rowtype;
cursor mycursor is  select * from emp;
begin
open mycursor;
loop
if  mycursor%isopen  then  dbe_output.print_line('open');
fetch mycursor into a;
end if;
exit when  mycursor%notfound;
dbe_output.print_line('a is:'||a);
dbe_output.print_line(mycursor%rowcount);
end loop;
end;
/
--DTS2018111410787
drop table if exists FVT_PROC_CLOB_007_T_01;
create table FVT_PROC_CLOB_007_T_01 (a int,b varchar(100),c clob,name char(10) );
insert into FVT_PROC_CLOB_007_T_01 values(1,'apple','I like apple','jims');
create or replace procedure FVT_PROC_CLOB_007_P_02 (c1 clob ) 
is 
v_clob clob;
begin
update FVT_PROC_CLOB_007_T_01 set c = c || c1 where name like 'j%';
select c into v_clob from FVT_PROC_CLOB_007_T_01 ;
dbe_output.print_line('v_clob is:' ||v_clob);
commit ;
end;
/
call FVT_PROC_CLOB_007_P_02('and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i likeand i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i likef],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like');
call FVT_PROC_CLOB_007_P_02('and i like %!aaadffsffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i likeand i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i likef],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like %!aaadffsfdffdaafdfafdsfhajdfjlsfjlslfjlsfldlfjlsfjldjfljlafepru[rfjg;sjfeorpjus;reopruospjfsdjf],and i like');

--DTS2018121006433 
drop table if exists p_r_tbl;
create table p_r_tbl(f1 int);
insert into p_r_tbl values(1);

create or replace procedure p_r1(a int) 
as
x int;
begin
select f1 into x from p_r_tbl;
dbe_output.print_line(a);
end;
/
create or replace procedure p_r2(a int) 
as
begin
p_r1(a);
end;
/
create or replace procedure p_r3(a int) 
as
begin
p_r2(a);
end;
/
create or replace procedure p_r4(a int) 
as
begin
p_r3(a);
end;
/
create or replace procedure p_r5(a int) 
as
begin
p_r4(a);
end;
/
create or replace procedure p_r6(a int) 
as
begin
p_r5(a);
end;
/
create or replace procedure p_r7(a int) 
as
begin
p_r6(a);
end;
/
create or replace procedure p_r8(a int) 
as
begin
p_r7(a);
end;
/
drop table if exists p_r_tbl;
create table p_r_tbl(f1 int, f2 int);
insert into p_r_tbl values(1,2);
call p_r8(1);

--DTS2018122205593
drop table if exists mtba;
create table mtba(x timestamp);
insert into mtba values(systimestamp);
insert into mtba values(systimestamp-100);
insert into mtba values(systimestamp+100);
CREATE OR REPLACE FUNCTION datediff(msg1 in date, msg2 in date) return int
AS
BEGIN
  return msg1 - msg2;
END;
/

CREATE OR REPLACE PROCEDURE mk_del2(msg in varchar) AS
BEGIN
  delete from mtba where rowid in (select a.rowid from mtba a where datediff(a.x, sysdate) > 1);
END;
/

call mk_del2('1234');
select count(*) from mtba;

--DTS2018122611702 
drop table if exists  FVT_PRO_TAB_001;
create table FVT_PRO_TAB_001
(
    id int,
    name varchar2(10),
    time date,
    age number
);
insert into FVT_PRO_TAB_001 values('1','feng',to_date('2018','yyyy'),25);
insert into FVT_PRO_TAB_001 values('2','li',to_date('2017','yyyy'),24);
insert into FVT_PRO_TAB_001 values('3','wang',to_date('2016','yyyy'),23);
insert into FVT_PRO_TAB_001 values('4','zhang',to_date('2015','yyyy'),22);
commit; 

create or replace procedure proc_for_in_loop6 as
a int :=0;
b int :=0;
str varchar2(100);
begin 
 str := 'select name   from FVT_PRO_TAB_001  order by 1 limit 1  ';
 for i in 1.. 3     
  loop
  dbe_output.print_line('out I='||i);
    a :=a+1;  
   if a/2+ a + length(a) -2 < 5
   then 
   --execute immediate str using out str;
   dbe_output.print_line(str) ;
    for i in 1.. 4    
    loop
    if b< 2 then 
    dbe_output.print_line('in I='||i);
    dbe_output.print_line('b='||b) ;
    b :=b+1;
    dbe_output.print_line('into goto');    
    else 
    dbe_output.print_line('b='||b) ;
    dbe_output.print_line('no into goto');
    exit;
    end if;
    end loop;
    else 
   dbe_output.print_line('........end if 1 ') ;
   --exit;
   end if ;  
  end loop;
end;
/
call proc_for_in_loop6;
create or replace procedure proc_for_in_loop5 as
a int :=0;
b int :=0;
str varchar2(100);
begin 
 str := 'select name   from FVT_PRO_TAB_001  order by 1 limit 1  ';
 for i in 1.. 3     
  loop
  dbe_output.print_line('out I='||i);
    a :=a+1;  
   if a/2+ a + length(a) -2 < 5
   then 
   --execute immediate str using out str;
   dbe_output.print_line(str) ;
    for i in 1.. 4    
    loop
    if b< 2 then 
    dbe_output.print_line('in I='||i);
    dbe_output.print_line('b='||b) ;
    b :=b+1;
    dbe_output.print_line('into goto');    
    else 
    dbe_output.print_line('b='||b) ;
    dbe_output.print_line('no into goto');
    exit;
	if true then
	   dbe_output.print_line('true') ;
	elsif true then
	   dbe_output.print_line('fake') ;
	else
	   dbe_output.print_line('false') ;
    end if;
	null;
	end if;
    end loop;
    else 
    dbe_output.print_line('........end if 1 ') ;
   --exit;
   end if ;  
   dbe_output.print_line('is it right break?') ;
  end loop;
end;
/
call proc_for_in_loop5;
--expected error
create or replace procedure proc_for_in_loop4 as
a int :=0;
b int :=0;
str varchar2(100);
begin 
 str := 'select name   from FVT_PRO_TAB_001  order by 1 limit 1  ';
 for i in 1.. 3     
  loop
  dbe_output.print_line('out I='||i);
    a :=a+1;  
   if a/2+ a + length(a) -2 < 5
   then 
   --execute immediate str using out str;
   dbe_output.print_line(str) ;
    for i in 1.. 4    
    loop
    if b< 2 then 
    dbe_output.print_line('in I='||i);
    dbe_output.print_line('b='||b) ;
    b :=b+1;
    dbe_output.print_line('into goto');    
    else 
    dbe_output.print_line('b='||b) ;
    dbe_output.print_line('no into goto');
    exit;
	if true then
	   dbe_output.print_line('true') ;
	elsif true then
	   dbe_output.print_line('fake') ;
	end if;
	else
	   dbe_output.print_line('false') ;
    end if;
    end loop;
    else 
    dbe_output.print_line('........end if 1 ') ;
   --exit;
   end if ;  
   dbe_output.print_line('is it right break?') ;
  end loop;
end;
/
call proc_for_in_loop4;
create or replace procedure proc_for_in_loop3 as
a int :=0;
b int :=0;
str varchar2(100);
begin 
 str := 'select name   from FVT_PRO_TAB_001  order by 1 limit 1  ';
 if true then
    <<lable1>>
    dbe_output.print_line('true');
 end if;
 for i in 1.. 3     
  loop
  dbe_output.print_line('out I='||i);
    a :=a+1;  
   if a/2+ a + length(a) -2 < 5
   then 
   --execute immediate str using out str;
   dbe_output.print_line(str) ;
    for i in 1.. 4    
    loop
    if b< 2 then 
    dbe_output.print_line('in I='||i);
    dbe_output.print_line('b='||b) ;
    b :=b+1;
    dbe_output.print_line('into goto');    
    else 
    dbe_output.print_line('b='||b) ;
    dbe_output.print_line('no into goto');
    goto lable1;
	if true then
	   dbe_output.print_line('true') ;
	elsif true then
	   dbe_output.print_line('fake') ;
	else
	   dbe_output.print_line('false') ;
    end if;
	end if;
    end loop;
    else 
    dbe_output.print_line('........end if 1 ') ;
   --exit;
   end if ;  
   dbe_output.print_line('is it right break?') ;
  end loop;
end;
/
call proc_for_in_loop3;
create or replace procedure proc_for_in_loop2 as
a int :=0;
b int :=0;
str varchar2(100);
begin 
 str := 'select name   from FVT_PRO_TAB_001  order by 1 limit 1  ';
 if true then    
    dbe_output.print_line('true');
 end if;
 for i in 1.. 3     
  loop
    dbe_output.print_line('out I='||i);
    a :=a+1;  
	if true then
    <<lable1>>
	if a/2+ a + length(a) -2 < 5
    then 
   --execute immediate str using out str;  
   dbe_output.print_line(str) ;
    for i in 1.. 4    
    loop
    if b< 2 then 
    dbe_output.print_line('in I='||i);
    dbe_output.print_line('b='||b) ;
    b :=b+1;
    dbe_output.print_line('into goto');    
    else 
    dbe_output.print_line('b='||b) ;
    dbe_output.print_line('no into goto');
	a := 10000;
    goto lable1;
	if true then
	   dbe_output.print_line('true') ;
	elsif true then
	   dbe_output.print_line('fake') ;
	else
	   dbe_output.print_line('false') ;
    end if;
	end if;
    end loop;
    else 
    dbe_output.print_line('........end if 1 ') ;
   --exit;
   end if ;  
   dbe_output.print_line('is it right break?') ;
   end if;
  end loop;
end;
/
call proc_for_in_loop2;
create or replace procedure proc_for_in_loop1 as
a int :=0;
b int :=0;
str varchar2(100);
begin 
 str := 'select name   from FVT_PRO_TAB_001  order by 1 limit 1  ';
 if true then    
    dbe_output.print_line('true');
 end if;
 for i in 1.. 3     
  loop
    dbe_output.print_line('out I='||i);
    a :=a+1;  
	if true then

	if a/2+ a + length(a) -2 < 5
    then 
   --execute immediate str using out str;  
   dbe_output.print_line(str) ;
    for i in 1.. 4    
    loop
    if b< 2 then 
    dbe_output.print_line('in I='||i);
    dbe_output.print_line('b='||b) ;
    b :=b+1;
    dbe_output.print_line('into goto');    
    else 
    dbe_output.print_line('b='||b) ;
    dbe_output.print_line('no into goto');
	a := 10000;
    goto lable1;
	if true then
	   dbe_output.print_line('true') ;
	elsif true then
	   dbe_output.print_line('fake') ;
	else
	   dbe_output.print_line('false') ;
    end if;
	end if;
    end loop;
    else 
    dbe_output.print_line('........end if 1 ') ;
   --exit;
   end if ;  
   <<lable1>>
   dbe_output.print_line('is it right break?') ;
   end if;
  end loop;
end;
/
call proc_for_in_loop1;

--
drop table if exists  FVT_PRO_TAB_001;
create table FVT_PRO_TAB_001
(
    id int,
    name varchar2(10),
    time date,
    age number
);
insert into FVT_PRO_TAB_001 values('1','feng',to_date('2018','yyyy'),25);
insert into FVT_PRO_TAB_001 values('2','li',to_date('2017','yyyy'),24);
insert into FVT_PRO_TAB_001 values('3','wang',to_date('2016','yyyy'),23);
insert into FVT_PRO_TAB_001 values('4','zhang',to_date('2015','yyyy'),22);
commit; 
create or replace procedure proc_for_in_loop7 as 
str varchar2(10) :='m';
str1 varchar2(100) :='a';
begin 
for i  in  1.. 3
    loop
        case str 
        when 'a' then select name into str1 from FVT_PRO_TAB_001 where age=22;
        dbe_output.print_line('str1='||str);        
        when b then select name into str1 from FVT_PRO_TAB_001 where age=23;
        dbe_output.print_line('str2='||str);
        when c then select name into str1 from FVT_PRO_TAB_001 where age=24;
        dbe_output.print_line('str3='||str);
        when d then select name into str1 from FVT_PRO_TAB_001 where age=25;
        dbe_output.print_line('str4='||str);
        else str :=str1;
        dbe_output.print_line('str5='||str);
        end case;
    end loop;
end;
/

create or replace procedure xxx_p1() as
begin
null;
end;
/
begin xxx_p1; end;
/

call xxx_p1;
exec xxx_p1;

create or replace procedure xxx_p2() as
begin
xxx_p1;
end;
/
begin xxx_p2; end;
/
call xxx_p2;
exec xxx_p2;

create or replace function xxx_f1() return int as
begin
return 1;
end;
/
select xxx_f1;
select xxx_f1+1;

create or replace function xxx_f2() return int as
 a int;
begin
 a := xxx_f1;
 dbe_output.print_line(a);
 select xxx_f1 into a from dual;
 dbe_output.print_line(a);
 
 a := xxx_f1 + 1;
 dbe_output.print_line(a);
 select xxx_f1 + 1 into a from dual;
 dbe_output.print_line(a);
 return a;
end;
/

select xxx_f2 + 1;

drop table if exists xxx_t;
create table xxx_t(a int);
select xxx_f2 from dual;
select xxx_f2 from xxx_t;
select xxx_f2 + a from xxx_t;
insert into xxx_t values(1);
select a from xxx_t where a = xxx_f2;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists job_schema_001 cascade;
create user job_schema_001 identified by Cantian_234;
grant dba to job_schema_001;
grant sysdba to job_schema_001;
grant create session to job_schema_001;

conn job_schema_001/Cantian_234@127.0.0.1:1611

drop table if exists FVT_FUNCTION_DDL_001_T;
drop table if exists FVT_FUNCTION_DDL_001_T_02;
create table FVT_FUNCTION_DDL_001_T(id int,name varchar2(100));
create table FVT_FUNCTION_DDL_001_T_02(id int,name varchar2(100));
create or replace function FVT_FUNCTION_DDL_001_Fun return int
is
a int := 0;
begin
for i in 1..5
loop
insert into FVT_FUNCTION_DDL_001_T values(30,'commit');
commit;
insert into FVT_FUNCTION_DDL_001_T values(3,'rollback');
rollback;
a := a+1;
end loop;
return a;
end;
/
insert into FVT_FUNCTION_DDL_001_T values (FVT_FUNCTION_DDL_001_Fun(),'function');
insert into FVT_FUNCTION_DDL_001_T_02 values (FVT_FUNCTION_DDL_001_Fun(),'function');
select * from FVT_FUNCTION_DDL_001_T;
select * from FVT_FUNCTION_DDL_001_T_02;
commit ;
select * from FVT_FUNCTION_DDL_001_T_02;

conn sys/Huawei@123@127.0.0.1:1611
begin 
insert into job_schema_001.FVT_FUNCTION_DDL_001_T values (job_schema_001.FVT_FUNCTION_DDL_001_Fun(),'function');
end;
/
begin 
insert into job_schema_001.FVT_FUNCTION_DDL_001_T values (job_schema_001.FVT_FUNCTION_DDL_001_Fun,'function');
end;
/
drop user whf001 cascade;

declare
ct SYS_REFCURSOR;
cursor idx is select 1 from dual;
a int;
b int;
begin
  open ct for select 1 from dual;
  if ct%found then
    a := 1;
  else
    a := 0;
  end if;
  dbe_output.print_line(a);

  fetch ct into b;
  if ct%found then
    a := 1;
  else
    a := 0;
  end if;
  dbe_output.print_line(a);

  open ct for select 1 from dual;
  if ct%found then
    a := 1;
  else
    a := 0;
  end if;
  dbe_output.print_line(a);
end;
/

set serveroutput off;