set serveroutput on;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_plsql_hash_table cascade;
create user gs_plsql_hash_table identified by Cantian_234;
grant all privileges to gs_plsql_hash_table;
conn gs_plsql_hash_table/Cantian_234@127.0.0.1:1611

declare
       type ListType is table of int index by integer;
       p_idList ListType;
        p_key int;
begin
       DBE_OUTPUT.PRINT_LINE('ok');
end;
/

declare
       type ListType is table of int index by integer;
       p_idList ListType:=ListType(1,2);
        p_key int;
begin
       DBE_OUTPUT.PRINT_LINE('ok');
end;
/

--delete
DECLARE
    TYPE aa_type_str IS TABLE OF INTEGER INDEX BY VARCHAR2(10);
    p_key aa_type_str;
    i VARCHAR2(10);
    BEGIN
        p_key('M') := 13;
        p_key('Z') := 26;
        p_key('C') := 3;

        i := p_key.FIRST;
        IF i IS NULL THEN
            DBE_OUTPUT.PRINT_LINE('p_key is empty');
        ELSE
            WHILE i IS NOT NULL LOOP
                DBE_OUTPUT.PRINT('p_key.(' || i || ') = ' || p_key(i));
                i := p_key.NEXT(i);
            END LOOP;
        END IF;
        DBE_OUTPUT.PRINT_LINE('------');

        p_key.DELETE;
        i := p_key.FIRST;
        IF i IS NULL THEN
            DBE_OUTPUT.PRINT_LINE('p_key is empty');
        ELSE
            WHILE i IS NOT NULL LOOP
                DBE_OUTPUT.PRINT('p_key.(' || i || ') = ' || p_key(i));
                i := p_key.NEXT(i);
            END LOOP;
        END IF;
        DBE_OUTPUT.PRINT_LINE('------');

        p_key('M') := 13;
        p_key('Z') := 260;
        p_key('C') := 30;
        p_key('W') := 23;
        p_key('J') := 10;
        p_key('N') := 14;
        p_key('P') := 16;
        p_key('W') := 23;
        p_key('J') := 10;
        i := p_key.FIRST;
        IF i IS NULL THEN
            DBE_OUTPUT.PRINT_LINE('p_key is empty');
        ELSE
            WHILE i IS NOT NULL LOOP
                DBE_OUTPUT.PRINT('p_key.(' || i || ') = ' || p_key(i));
                i := p_key.NEXT(i);
            END LOOP;
        END IF;
        DBE_OUTPUT.PRINT_LINE('------');


        p_key.DELETE('C');
        i := p_key.FIRST;
        IF i IS NULL THEN
            DBE_OUTPUT.PRINT_LINE('p_key is empty');
        ELSE
            WHILE i IS NOT NULL LOOP
                DBE_OUTPUT.PRINT('p_key.(' || i || ') = ' || p_key(i));
                i := p_key.NEXT(i);
            END LOOP;
        END IF;
        DBE_OUTPUT.PRINT_LINE('------');

        p_key.DELETE('N','W');
        i := p_key.FIRST;
        IF i IS NULL THEN
            DBE_OUTPUT.PRINT_LINE('p_key is empty');
        ELSE
            WHILE i IS NOT NULL LOOP
                DBE_OUTPUT.PRINT('p_key.(' || i || ') = ' || p_key(i));
                i := p_key.NEXT(i);
            END LOOP;
        END IF;
        DBE_OUTPUT.PRINT_LINE('------');


        p_key.DELETE('Z','M');
        i := p_key.FIRST;
        IF i IS NULL THEN
            DBE_OUTPUT.PRINT_LINE('p_key is empty');
        ELSE
            WHILE i IS NOT NULL LOOP
                DBE_OUTPUT.PRINT('p_key.(' || i || ') = ' || p_key(i));
                i := p_key.NEXT(i);
            END LOOP;
        END IF;
        DBE_OUTPUT.PRINT_LINE('------');

    END;
/

--array error
set serveroutput on;

declare
       type ListType is table of int[10] index by integer;
       p_idList ListType;
        p_key int;
begin
       DBE_OUTPUT.PRINT_LINE('ok');
end;
/

--test null
declare
       type ListType is table of int index by binary_integer;
       p_idList ListType;
        p_key int;
begin
       if p_idList is null then
       DBE_OUTPUT.PRINT_LINE('null ');
       else
       DBE_OUTPUT.PRINT_LINE('ok' );
       end if;
       DBE_OUTPUT.PRINT_LINE('count: ' || p_idList.count);
end;
/

declare
       type ListType is table of int index by binary_integer;
       p_idList ListType;
begin
       DBE_OUTPUT.PRINT_LINE('count: ' || p_idList.count);
       DBE_OUTPUT.PRINT_LINE('count: ' || p_idList.limit);
       DBE_OUTPUT.PRINT_LINE('p_idList.first: ' ||p_idList.first);
       DBE_OUTPUT.PRINT_LINE('p_idList.last: ' ||p_idList.last);
       DBE_OUTPUT.PRINT_LINE('p_idList.exists(2): ' ||p_idList.exists(2));
       DBE_OUTPUT.PRINT_LINE('p_idList.prior(2): ' ||p_idList.prior(2));
       DBE_OUTPUT.PRINT_LINE('p_idList.next(2): ' ||p_idList.next(2));
       p_idList.delete(2);
       p_idList.delete(3, 5);
       p_idList.delete;
       DBE_OUTPUT.PRINT_LINE('count: ' || p_idList.count);
end;
/

--count limit first last
declare
       type ListType is table of int index by binary_integer;
       p_idList ListType;
        p_key int;
begin
       p_idList(4):=3;
       p_idList(6):=7;
       p_idList(1):=9;
       p_key := p_idList.first;
       DBE_OUTPUT.PRINT_LINE('count: ' || p_idList.count);
       DBE_OUTPUT.PRINT_LINE('p_idList.first: ' || p_key);
       p_key := p_idList.limit;
       DBE_OUTPUT.PRINT_LINE('p_idList.limit: ' || p_key);
       p_key := p_idList.last;
       DBE_OUTPUT.PRINT_LINE('p_idList.last: ' || p_key);
end;
/

--exists prior next
declare
       type ListType is table of int index by binary_integer;
       p_idList ListType;
begin
       p_idList(1):=1;
       p_idList(3):=1;
       if p_idList.exists(1) then
       DBE_OUTPUT.PRINT_LINE('prior: '||p_idList.prior(1));
       DBE_OUTPUT.PRINT_LINE('next: '||p_idList.next(1));
       else
       DBE_OUTPUT.PRINT_LINE('no' );
       end if;
       DBE_OUTPUT.PRINT_LINE('count: ' || p_idList.count);
end;
/

--argument null test
declare
       type ListType is table of int index by varchar(5);
       p_idList ListType;
begin
       p_idList('a'):=1;
       p_idList('b'):=1;
       if p_idList.exists(null) then
       DBE_OUTPUT.PRINT_LINE('prior: '||p_idList.prior(1));
       else
       DBE_OUTPUT.PRINT_LINE('no' );
       DBE_OUTPUT.PRINT_LINE('prior: '||p_idList.prior(null));
       DBE_OUTPUT.PRINT_LINE('next: '||p_idList.next(null));
       end if;
       DBE_OUTPUT.PRINT_LINE('count: ' || p_idList.count);
end;
/

--extend error
declare
       type ListType is table of varchar(10) index by binary_integer;
        p_key ListType;
begin
       p_key.extend;
       DBE_OUTPUT.PRINT_LINE('count: ' || p_key.count);
end;
/

--trim error
declare
       type ListType is table of varchar(10) index by binary_integer;
        p_key ListType;
        i binary_integer;
begin
       p_key.trim;
       DBE_OUTPUT.PRINT_LINE('count: ' || p_key.count);
end;
/

--cover
declare
       type ListType is table of varchar(10) index by binary_integer;
       p_key ListType;
begin
       p_key(2) := 1;
       p_key(2) := 2;
       DBE_OUTPUT.PRINT_LINE('p_key(2): '||p_key(2));
       DBE_OUTPUT.PRINT_LINE('count: '||p_key.count);
end;
/

--no data found
declare
       type ListType is table of varchar(10) index by binary_integer;
       p_key ListType;
begin
       DBE_OUTPUT.PRINT_LINE(p_key(2));
end;
/

--clone
set serveroutput on;
declare
       type ListType is table of int index by binary_integer;
        p_key ListType;
        new_key ListType;
begin
       p_key(2):= 2;
       new_key:=p_key;
       p_key(1) := 1;
       DBE_OUTPUT.PRINT_LINE('first: ' || new_key.first);
       DBE_OUTPUT.PRINT_LINE('first: ' || p_key.first);
end;
/

--error
declare
       type ListType is table of varchar(10) index by binary_integer;
       type tableType is table of varchar(10) index by binary_integer;
        p_key ListType;
        new_key tableType;
begin
       p_key(2):= 2;
       new_key:=p_key;
       DBE_OUTPUT.PRINT_LINE('first: ' || new_key.first);
end;
/

declare
       type ListType is table of int index by binary_integer;
       p_key ListType;
begin
       p_key('aa') := 1;
       p_key(1) := 2;
       DBE_OUTPUT.PRINT_LINE('ok '|| p_key.first);
end;
/

--select into
drop table if exists test_table1;
create table test_table1(id int,name varchar(10));
insert into test_table1 values(1, 'ss');
insert into test_table1 values(2, 'sd');
insert into test_table1 values(3, 'as');
insert into test_table1 values(4, 'As');
commit;
declare
       type ListType is table of int index by varchar(10);
        p_key ListType;
        i test_table1.name%type;
        j int;
begin
       for j in 1..4
       loop
       select name into i from test_table1 where id = j;
       select id into p_key(i) from test_table1 where name = i;
       end loop;
       i := p_key.FIRST;
       WHILE i IS NOT NULL LOOP
       DBE_OUTPUT.PRINT_LINE
       ('index: ' || i || ' is ' || p_key(i));
       i := p_key.NEXT(i);
       END LOOP;
end;
/

--error
drop table if exists test_table2;
create table test_table2(id float,name varchar(10));
insert into test_table2 values(1.1, 'ss');
insert into test_table2 values(2.2, 'sd');
commit;
declare
       type ListType is table of int index by test_table2.id%type;
        p_key ListType;
begin
  DBE_OUTPUT.PRINT_LINE('ok ');
end;
/
drop table test_table2;

--%type
declare
       type ListType is table of int index by test_table1.name%type;
       p_key ListType;
begin
       p_key('bb') := 1;
       p_key('aa') := 1;
       DBE_OUTPUT.PRINT_LINE('ok '|| p_key.first);
end;
/

--error
declare
       type ListType is table of int index by test_table1%rowtype;
        p_key ListType;
        i test_table1.name%type;
        j int;
begin
  DBE_OUTPUT.PRINT_LINE('ok ');
end;
/

--bulk collect
declare
       type ListType is table of varchar(10) index by binary_integer;
        p_key ListType;
        i binary_integer;
begin
       p_key(2):= 'AA';
       p_key(8):= 'ww';
       DBE_OUTPUT.PRINT_LINE('count: ' || p_key.count);
       select name bulk collect into p_key from test_table1 where id>4;
       DBE_OUTPUT.PRINT_LINE('count: ' || p_key.count);
       select name bulk collect into p_key from test_table1;
       DBE_OUTPUT.PRINT_LINE('count: ' || p_key.count);
       i := p_key.FIRST;
       WHILE i IS NOT NULL LOOP
       DBE_OUTPUT.PRINT_LINE
       ('index: ' || i || ' is ' || p_key(i));
       i := p_key.NEXT(i);
       END LOOP;
end;
/

declare
       type ListType is table of varchar(10) index by varchar(10);
        p_key ListType;
        i binary_integer;
begin
       select name bulk collect into p_key from test_table1;
       DBE_OUTPUT.PRINT_LINE('count: ' || p_key.count);
end;
/
drop table test_table1;

--error
create or replace TYPE my_aa IS TABLE OF int INDEX BY binary_INTEGER;
/
drop type if exists my_aa;

declare
       type ListType is table of int index by number(10);
        p_key ListType;
begin
p_key(1):=1;
end;
/

declare
       type ListType is table of int index by clob;
        p_key ListType;
begin
p_key('a'):=1;
end;
/

declare
       type ListType is table of int index by char(10);
       p_key ListType;
begin
p_key('a'):=1;
end;
/

CREATE OR REPLACE PACKAGE My_Types IS
TYPE My_AA IS TABLE OF VARCHAR2(20) INDEX BY INTEGER;
FUNCTION Init_My_AA RETURN My_AA;
END My_Types;
/
drop package if exists My_Types;

--order
declare
       type ListType is table of int index by varchar(10);
        p_key ListType;
begin
       p_key('A') := 2;
       p_key('a') := 1;
       p_key('!') := 5;
       DBE_OUTPUT.PRINT_LINE('p_key.first: ' || p_key.first);
       DBE_OUTPUT.PRINT_LINE('p_key.first: ' || p_key(p_key.first));
       DBE_OUTPUT.PRINT_LINE('count: ' || p_key.count);
end;
/

declare
       type ListType is table of int index by binary_integer;
        p_key ListType;
begin
       p_key(1) := 2;
       p_key(-1) := 1;
       p_key(0) := 5;
       DBE_OUTPUT.PRINT_LINE('p_key.first: ' || p_key.first);
       DBE_OUTPUT.PRINT_LINE('p_key.first: ' || p_key(p_key.first));
       DBE_OUTPUT.PRINT_LINE('count: ' || p_key.count);
end;
/

--internal
drop procedure if exists procedure_002;
CREATE OR REPLACE PROCEDURE procedure_002(a in int, b out int) IS
  TYPE my_aa IS TABLE OF int INDEX BY INTEGER;
  p_key my_aa;
  i int;
BEGIN
  p_key(1):= 2;
  p_key(4):= 6;
  i:=p_key.last;
  DBE_OUTPUT.PRINT_LINE(i);
  b:= a * i * 3;
END;
/
DECLARE
a int;
b int;
BEGIN
 a := 2;
 procedure_002(a, b);
 dbe_output.print_line(b);
END;
/
drop procedure procedure_002;

drop function if exists function_002;
drop type if exists my_aa;
CREATE OR REPLACE FUNCTION function_002 (a my_aa) RETURN INT
  AS
  TYPE my_aa IS TABLE OF int INDEX BY INTEGER;
  p_key my_aa;
  i int;
  b int;
BEGIN
  p_key(1):= 2;
  p_key(4):= 6;
  i:=p_key.last;
  DBE_OUTPUT.PRINT_LINE(i);
  b:= a * i * 3;
  RETURN b;
END;
/
drop function if exists function_002;

--null
declare
       type ListType is table of int index by binary_integer;
       p_idList ListType;
        p_key int;
begin
       p_idList(1):=null;
       DBE_OUTPUT.PRINT_LINE('count: ' || p_idList.count);
       DBE_OUTPUT.PRINT_LINE('value: ' || p_idList(1));
end;
/

--error
declare
       type ListType is table of int index by binary_integer;
       p_idList ListType;
        p_key int;
begin
       p_idList(null):=1;
       DBE_OUTPUT.PRINT_LINE('count: ' || p_idList.count);
end;
/

--cursor
DROP TABLE IF EXISTS EMPLOYEES_UDT;
CREATE TABLE EMPLOYEES_UDT
   (EMPLOYEE_ID NUMBER(6,0),
    FIRST_NAME VARCHAR2(20),
    LAST_NAME VARCHAR2(25) CONSTRAINT "EMP_LAST_NAME_NN" NOT NULL,
    EMAIL VARCHAR2(25) CONSTRAINT "EMP_EMAIL_NN" NOT NULL,
    PHONE_NUMBER VARCHAR2(20),
    HIRE_DATE DATE CONSTRAINT "EMP_HIRE_DATE_NN" NOT NULL,
    JOB_ID VARCHAR2(10) CONSTRAINT "EMP_JOB_NN" NOT NULL,
    SALARY NUMBER(8,2),
    COMMISSION_PCT NUMBER(2,2),
    MANAGER_ID NUMBER(6,0),
    DEPARTMENT_ID NUMBER(4,0)
   );
insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (198, 'Donald', 'OConnell', 'DOCONNEL', '650.507.9833', to_date('21-06-1999', 'dd-mm-yyyy'), 'SH_CLERK', 2600.00, null, 124, 50);
insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (199, 'Douglas', 'Grant', 'DGRANT', '650.507.9844', to_date('13-01-2000', 'dd-mm-yyyy'), 'SH_CLERK', 2600.00, null, 124, 50);
insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', to_date('17-09-1987', 'dd-mm-yyyy'), 'AD_ASST', 4400.00, null, 101, 10);
insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (201, 'Michael', 'Hartstein', 'MHARTSTE', '515.123.5555', to_date('17-02-1996', 'dd-mm-yyyy'), 'MK_MAN', 13000.00, null, 100, 20);
insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (202, 'Pat', 'Fay', 'PFAY', '603.123.6666', to_date('17-08-1997', 'dd-mm-yyyy'), 'MK_REP', 6000.00, null, 201, 20);
insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (203, 'Susan', 'Mavris', 'SMAVRIS', '515.123.7777', to_date('07-06-1994', 'dd-mm-yyyy'), 'SH_CLERK', 6500.00, null, 101, 40);
insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (204, 'Hermann', 'Baer', 'HBAER', '515.123.8888', to_date('07-06-1994', 'dd-mm-yyyy'), 'PR_REP', 10000.00, null, 101, 70);
insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (205, 'Shelley', 'Higgins', 'SHIGGINS', '515.123.8080', to_date('07-06-1994', 'dd-mm-yyyy'), 'SH_CLERK', 12000.00, null, 101, 110);
insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (206, 'William', 'Gietz', 'WGIETZ', '515.123.8181', to_date('07-06-1994', 'dd-mm-yyyy'), 'AC_ACCOUNT', 8300.00, null, 205, 110);
commit;
DROP TABLE IF EXISTS JOBS;
CREATE TABLE JOBS
(    JOB_ID VARCHAR2(10),
    JOB_TITLE VARCHAR2(35) CONSTRAINT "JOB_TITLE_NN" NOT NULL,
    MIN_SALARY NUMBER(6,0),
    MAX_SALARY NUMBER(6,0),
    CONSTRAINT "JOB_ID_PK" PRIMARY KEY ("JOB_ID")
   );
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('AC_MGR', 'Accounting Manager', 8200, 16000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('AC_ACCOUNT', 'Public Accountant', 4200, 9000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('SA_MAN', 'Sales Manager', 10000, 20000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('SA_REP', 'Sales Representative', 6000, 12000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('ST_MAN', 'Stock Manager', 5500, 8500);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('ST_CLERK', 'Stock Clerk', 2000, 5000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('SH_CLERK', 'Shipping Clerk', 2500, 5500);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('IT_PROG', 'Programmer', 4000, 10000);
commit;

DECLARE
 TYPE empcurtyp IS REF CURSOR;
 TYPE namelist IS TABLE OF VARCHAR(25) index by binary_integer;
 TYPE sallist IS TABLE OF NUMBER(8, 2) index by binary_integer;
 emp_cv empcurtyp;
 names  namelist;
 sals   sallist;
BEGIN
 OPEN emp_cv FOR
  SELECT last_name, salary
    FROM EMPLOYEES_UDT
   WHERE job_id = 'SH_CLERK'
   ORDER BY salary DESC;
 FETCH emp_cv BULK COLLECT
 INTO names, sals;
 CLOSE emp_cv;
 FOR i IN names.FIRST .. names.LAST LOOP
  DBE_OUTPUT.PRINT_LINE('Name = ' || names(i) || ', salary = ' || sals(i));
 END LOOP;
END;
/

DECLARE
 CURSOR c1 IS
  SELECT last_name, job_id
    FROM EMPLOYEES_UDT
   WHERE REGEXP_LIKE(job_id, 'S[HT]_CLERK')
   ORDER BY last_name;
 lastname EMPLOYEES_UDT.last_name%TYPE; -- variable for last_name
 jobid    EMPLOYEES_UDT.job_id%TYPE; -- variable for job_id
 CURSOR c2 IS
  SELECT *
    FROM EMPLOYEES_UDT
   WHERE REGEXP_LIKE(job_id, '[ACADFIMKSA]_M[ANGR]')
   ORDER BY job_id;
  TYPE namelist IS TABLE OF EMPLOYEES_UDT%ROWTYPE INDEX BY PLS_INTEGER;
   v_EMPLOYEES_UDT namelist;
BEGIN
 OPEN c1;
 LOOP
  FETCH c1
  INTO lastname, jobid;
  EXIT WHEN c1%NOTFOUND;
  DBE_OUTPUT.PRINT_LINE(RPAD(lastname, 15, ' ') || jobid);
 END LOOP;
 CLOSE c1;
 DBE_OUTPUT.PRINT_LINE('NEXT LOOP:');
 OPEN c2;
 LOOP
  FETCH c2
  INTO v_EMPLOYEES_UDT(1);
  EXIT WHEN c2%NOTFOUND;
  DBE_OUTPUT.PRINT_LINE(RPAD(v_EMPLOYEES_UDT(1).last_name, 25, ' ') ||
                       v_EMPLOYEES_UDT(1).job_id);
 END LOOP;
 CLOSE c2;
END;
/

DECLARE
 CURSOR c IS
  SELECT e.job_id, j.job_title
    FROM EMPLOYEES_UDT e, jobs j
   WHERE e.job_id = j.job_id
     AND e.manager_id = 100
   ORDER BY last_name;
 TYPE namelist IS TABLE OF c%ROWTYPE INDEX BY PLS_INTEGER;
 job1 namelist;
 i int :=1;
BEGIN
 OPEN c;
 LOOP
 FETCH c INTO job1(i);
  EXIT WHEN c%NOTFOUND;
 DBE_OUTPUT.PRINT_LINE(job1(i).job_title || ' (' || job1(i).job_id || ')');
 i:=i+1;
 end loop;
 CLOSE c;
END;
/

DECLARE
  x varchar(100) := 'SH_CLERK';
  y integer;
  query VARCHAR2(4000) := 'SELECT first_name, last_name, hire_date
    FROM EMPLOYEES_UDT
   WHERE job_id = :x and rownum <= :y
   ORDER BY hire_date';
  var_s1 EMPLOYEES_UDT.first_name%type;
  var_s2 EMPLOYEES_UDT.last_name%type;
  var_s3 EMPLOYEES_UDT.hire_date%type;
  cursor cv IS
  SELECT first_name, last_name, hire_date
    FROM EMPLOYEES_UDT
   WHERE job_id = 'ST_MAN'
   ORDER BY hire_date;
   var_rec cv%rowtype;
   TYPE c_r IS TABLE OF cv%rowtype INDEX BY PLS_INTEGER;
   var_c_r c_r;
   type c_1 is table of EMPLOYEES_UDT.first_name%type INDEX BY PLS_INTEGER;
   type c_2 is table of EMPLOYEES_UDT.last_name%type INDEX BY PLS_INTEGER;
   type c_3 is table of EMPLOYEES_UDT.hire_date%type INDEX BY PLS_INTEGER;
   var_c_1 c_1;
   var_c_2 c_2;
   var_c_3 c_3;

BEGIN
  EXECUTE IMMEDIATE query INTO var_s1, var_s2, var_s3 USING x, 1;
  DBE_OUTPUT.PRINT_LINE('------------------------------------');
  DBE_OUTPUT.PRINT_LINE('Employee first_name = ' || var_s1 || ' last_name = ' || var_s2 || ' hire_date =' || var_s3);
  EXECUTE IMMEDIATE query INTO var_rec USING x, 1;
  DBE_OUTPUT.PRINT_LINE('Employee first_name = ' || var_rec.first_name || ' last_name = ' || var_rec.last_name || ' hire_date =' || var_rec.hire_date);
  DBE_OUTPUT.PRINT_LINE('------------------------------------');
  EXECUTE IMMEDIATE query BULK COLLECT INTO var_c_r USING x, 10;
  FOR i IN 1 .. var_c_r.COUNT LOOP
   DBE_OUTPUT.PRINT_LINE('Employee first_name: ' || var_c_r(i).first_name || ' Employee last_name: '|| var_c_r(i).last_name|| ' Employee hire_date: '|| var_c_r(i).hire_date);
  END LOOP;
  DBE_OUTPUT.PRINT_LINE('------------------------------------');

  EXECUTE IMMEDIATE query BULK COLLECT INTO var_c_1, var_c_2, var_c_3 USING x, 100000000;
  FOR i IN 1 .. var_c_1.COUNT LOOP
   DBE_OUTPUT.PRINT_LINE('Employee first_name: ' || var_c_1(i) || ' Employee last_name: '|| var_c_2(i)|| ' Employee hire_date: '|| var_c_3(i));
  END LOOP;
END;
/

drop table if exists t_objects;
create table t_objects as select * from EMPLOYEES_UDT limit 5;
declare
  type nt_object is table of t_objects%rowtype index by binary_integer;
  vnt_object_bulk nt_object;
  vnt_object      nt_object;
  c_big_number    number := power(2, 31);
  l_start_time    number;
  cursor cur_object is
    select * from t_objects;
begin
  dbe_output.print_line('========BULK COLLECT LIMIT==========');
  l_start_time := dbe_util.get_date_time;
  open cur_object;
  loop
    fetch cur_object bulk collect
      into vnt_object_bulk;
      dbe_output.print_line('========'||vnt_object_bulk.count||'==========');
    dbe_output.print_line('========'||1||': '||vnt_object_bulk(1).EMPLOYEE_ID||'==========');
    for i in vnt_object_bulk.first .. vnt_object_bulk.last loop
      vnt_object(i) := vnt_object_bulk(i);
      dbe_output.print_line('========'||i||': '||vnt_object(i).last_name||'==========');
    end loop;
    exit when cur_object%notfound;
  end loop;
  close cur_object;
end;
/
drop table t_objects;
--returning
DROP TABLE if exists test_returning_bulkinto;
create table test_returning_bulkinto (a VARCHAR2(10), b VARCHAR2(10), c VARCHAR2(10));
insert into test_returning_bulkinto values ('a','a','a');
insert into test_returning_bulkinto values ('a','a','a');
insert into test_returning_bulkinto values ('a','b','a');
insert into test_returning_bulkinto values ('a','b','a');
commit;
DECLARE
   TYPE emp_rec_type IS RECORD
   (
     ra      test_returning_bulkinto.a%TYPE,
     rb      test_returning_bulkinto.b%TYPE,
     rc   test_returning_bulkinto.c%TYPE
   );
   TYPE nested_emp_type1 IS TABLE OF emp_rec_type index by binary_integer;
   emp_tab   nested_emp_type1;
begin
  update test_returning_bulkinto set a='b' where a='a' returning a,b,c bulk collect into emp_tab;
  dbe_output.print_line('emp_tab');
  for i in 1..emp_tab.count loop
  dbe_output.print_line(emp_tab(i).ra||' '||emp_tab(i).rb||' '||emp_tab(i).rc);
  end loop;
end;
/
DROP TABLE test_returning_bulkinto;

drop table if exists t_user;
create table t_user(userid number,phone varchar2(11));
declare
type array_number is table of number(20) INDEX BY PLS_INTEGER;
  numarr_result array_number;
  v_count number;
begin
numarr_result(1):=1;
numarr_result(2):=numarr_result(1);
numarr_result(3):=numarr_result(1);
  delete from t_user where userid = 1
   returning userid bulk collect into  numarr_result;
  dbe_output.print_line('numarr_result count:' ||numarr_result.count);
end;
/
drop table t_user;

-------------direct assignment series
declare
       type t_table1 is table of int index by Binary_Integer;
       type ListType is table of t_table1 index by Binary_Integer;
        p_key ListType;
begin
       p_key(2)(3):=11;
       DBE_OUTPUT.PRINT_LINE(p_key(2)(3));
end;
/

declare
Type RecType11 Is Record
(
  a int,
  b int
);
       type ListType is table of RecType11 index by Binary_Integer;
        p_key ListType;
begin
       p_key(2).a:=3;
       DBE_OUTPUT.PRINT_LINE(p_key(2).a);
end;
/

declare
type ListType is table of int index by Binary_Integer;
Type RecType11 Is Record
(
  a ListType,
  b int
);
CC RecType11;
begin
       CC.a(1) := 3;
       DBE_OUTPUT.PRINT_LINE(CC.a(1));
end;
/

declare
type ListType is record(
c int,
d int
);
Type RecType11 Is Record
(
  a ListType,
  b int
);
CC RecType11;
begin
       CC.a.c := 3;
       DBE_OUTPUT.PRINT_LINE(CC.a.c);
end;
/

drop table if exists t_422311;
create table t_422311(EMPNO int, b varchar(100));
insert into t_422311 values(123, 'test422311');
insert into t_422311 values(234, 'test1123224');
commit;
Declare
Type RecType Is Record
(
  rno t_422311.EMPNO%type,
  rname t_422311.b%type
);
Type TabType Is Table Of RecType Index By Binary_Integer;
MyTab TabType;
vN Number;
Begin
vN := 1;
For varR In (Select * From t_422311 Order By EMPNO ASC)
Loop
  MyTab(vN).rno  := varR.EMPNO;
  MyTab(vN).rname := varR.b;
  DBE_OUTPUT.PRINT_LINE(vN ||'   '||MyTab(vN).rno||'   '||MyTab(vN).rname);
  vN := vN + 1;
End Loop;
vN := MyTab.First;
DBE_OUTPUT.PRINT_LINE(vN ||'   '||MyTab(vN).rno||'   '||MyTab(vN).rname);
For varR In vN..MyTab.count
Loop
  DBE_OUTPUT.PRINT_LINE(vN ||'   '||MyTab(vN).rno||'   '||MyTab(vN).rname);
  vN := vN + 1;
End Loop;
End;
/

--error
Declare
Type RecType Is Record
(
  rno t_422311.EMPNO%type,
  rname t_422311.b%type
);
Type TabType Is Table Of RecType Index By Binary_Integer;
MyTab TabType;
vN Number;
Begin
vN := null;
For varR In (Select * From t_422311 Order By EMPNO ASC)
Loop
  MyTab(vN).rno  := varR.EMPNO;
  MyTab(vN).rname := varR.b;
  DBE_OUTPUT.PRINT_LINE(vN ||'   '||MyTab(vN).rno||'   '||MyTab(vN).rname);
  vN := vN + 1;
End Loop;
End;
/

Declare
Type RecType Is Record
(
  rno t_422311.EMPNO%type,
  rname t_422311.b%type
);
Type TabType Is Table Of RecType Index By varchar(5);
MyTab TabType;
Begin
For varR In (Select * From t_422311 Order By EMPNO ASC)
Loop
  MyTab('test422311').rno  := varR.EMPNO;
  MyTab('test422311').rname := varR.b;
End Loop;
End;
/
drop table t_422311;

declare
       type t_table1 is varray(10) of int;
       type ListType is table of t_table1 index by Binary_Integer;
        p_key ListType;
begin
       p_key(2)(1):=11;
       DBE_OUTPUT.PRINT_LINE(p_key(2)(1));
end;
/

create or replace type t_table22 is object(
a int,
b int
);
/
declare
       type ListType is table of t_table22 index by Binary_Integer;
        p_key ListType;
begin
       p_key(2).a:=3;
       DBE_OUTPUT.PRINT_LINE(p_key(2).a);
end;
/
drop type t_table22;

declare
Type RecType11 Is Record
(
  a int,
  b int
);
CC RecType11;
       type ListType is table of RecType11 index by Binary_Integer;
        p_key ListType;
begin
       DBE_OUTPUT.PRINT_LINE(p_key(1).a);
end;
/

declare
type ListType is table of int index by Binary_Integer;
Type RecType11 Is Record
(
  a ListType,
  b int
);
CC RecType11;
begin
       DBE_OUTPUT.PRINT_LINE(CC.a(1));
end;
/

------------boundary test series and pls_integer and string atatype
declare
   type ListType is table of string(10) index by pls_integer;
   p_key ListType;
begin
   p_key(1):= '221sssssssss';
   DBE_OUTPUT.PRINT_LINE('index: ' ||1 || ' is ' || p_key(1));
end;
/

declare
   type ListType is table of binary(10) index by pls_integer;
   p_key ListType;
begin
   p_key(1):= 101111111111;
   DBE_OUTPUT.PRINT_LINE
       ('index: ' ||1 || ' is ' || p_key(1));
end;
/

declare
   type ListType is table of pls_integer index by string(10);
   p_key ListType;
begin
   p_key('221sssssssss'):= 1;
end;
/

declare
       type ListType is table of pls_integer index by string(32767);
       p_key ListType;
begin
       DBE_OUTPUT.PRINT_LINE('ok '|| p_key.first);
end;
/

declare
       type ListType is table of pls_integer index by string(32768);
       p_key ListType;
begin
       DBE_OUTPUT.PRINT_LINE('ok '|| p_key.first);
end;
/


declare
       type ListType is table of pls_integer index by pls_integer;
       p_key ListType;
begin
       p_key(1):=2147483648;
       DBE_OUTPUT.PRINT_LINE('ok '|| p_key.first);
end;
/

declare
       type ListType is table of pls_integer index by pls_integer;
       p_key ListType;
begin
       p_key(1):=-2147483648;
       DBE_OUTPUT.PRINT_LINE('ok '|| p_key.first);
end;
/

declare
       type ListType is table of pls_integer index by pls_integer;
       p_key ListType;
begin
       p_key(2147483648):=21;
       DBE_OUTPUT.PRINT_LINE('ok '|| p_key.first);
end;
/

declare
       type ListType is table of pls_integer index by pls_integer;
       p_key ListType;
begin
       p_key(-2147483648):=-2147483648;
       DBE_OUTPUT.PRINT_LINE('ok '|| p_key.first);
end;
/

--variant
declare
p_1 pls_integer;
p_2 string(10);
begin
p_1 := 1234567;
p_2 := '7654321';
DBE_OUTPUT.PRINT_LINE('p_1: ' || p_1);
DBE_OUTPUT.PRINT_LINE('p_2: ' || p_2);
end;
/

--only in plsql
drop table if exists intest;
create table intest(id pls_integer); --error
create table intest(id string(2));  --error

--can use to local varry\nested table\hash table\record
declare
type ListType is varray(10) of pls_integer;
cc ListType := ListType(1);
begin
       DBE_OUTPUT.PRINT_LINE(cc(1));
end;
/

declare
type ListType is table of string(10);
cc ListType := ListType('ss');
begin
       DBE_OUTPUT.PRINT_LINE(cc(1));
end;
/

declare
type qwer is record (a pls_integer, b string(3));
v qwer;
begin
v.a:=123;
v.b:='321';
DBE_OUTPUT.PRINT_LINE(v.a);
DBE_OUTPUT.PRINT_LINE(v.b);
end;
/

--error
create or replace type ccdd is object(
x pls_integer,
y int
);
/
create or replace type ccdd is varray(5) of pls_integer;
/
create or replace type ccdd is table of string(10);
/
drop type if exists ccdd;

--can used to procedure and function
create or replace procedure p_test(p_1 string, p_2 in pls_integer) as
v_s varchar2(10);
v_i int;
begin
v_s:=(p_1 || 'ddddddd');
v_i:=p_2 + 3;
dbe_output.print_line(v_s);
dbe_output.print_line(v_i);
end;
/
call p_test('100',200);
drop procedure p_test;

drop function if exists function_002;
CREATE OR REPLACE FUNCTION function_002 (a in string, b pls_integer, d out string) RETURN pls_integer
  AS
    c pls_integer;
  BEGIN
       c := b * 4 + 5;
       d:= (a || 'ddrrttt');
       dbe_output.print_line(c);
       dbe_output.print_line(d);
  RETURN c;
END;
/
DECLARE
a string(10);
b pls_integer;
c pls_integer;
d string(15);
BEGIN
 a := 'dddd';
 b := 3;
 c := function_002(a, b, d);
END;
/
drop function function_002;

--hash table%type
set serveroutput on;
declare
       type t_table1 is table of int index by Binary_Integer;
       p_key t_table1;
       c p_key%type; --same as t_table1
begin
       p_key(2):=11;
       c:=p_key;
       DBE_OUTPUT.PRINT_LINE(c(2));
end;
/

---------------------delete test series
declare
       type t_table1 is table of int index by Binary_Integer;
       p_key t_table1;
       i Binary_Integer;
begin
       p_key(2):=11;
       p_key(3):=3;
       p_key(1):=3;
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete;
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(2);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       DBE_OUTPUT.PRINT_LINE(p_key.first || p_key.last);
end;
/

declare
       type t_table1 is table of int index by Binary_Integer;
       p_key t_table1;
       i Binary_Integer;
begin
       p_key(2):=11;
       p_key(2):=18;
       p_key(3):=null; --element is null
       p_key(1):=3;
       p_key(1):=3;
       p_key(5):=11;
       p_key(6):=12;
       p_key(7):=3;
       i := p_key.FIRST;
       WHILE i IS NOT NULL LOOP
       DBE_OUTPUT.PRINT_LINE
       ('index: ' || i || ' is ' || p_key(i));
       i := p_key.NEXT(i);
       end loop;
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(2);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(8);  --delete no assign index
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(3, 5);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete;
       DBE_OUTPUT.PRINT_LINE(p_key.count);
end;
/

--delete and exists
declare
       type t_table1 is table of int index by Binary_Integer;
       p_key t_table1;
       i Binary_Integer;
begin
       p_key(2):=11;
       p_key(3):=3;
       p_key(1):=3;
       p_key(-1):=3;
       p_key(-3):=3;
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(2, 5);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       if p_key.exists(3) then
         DBE_OUTPUT.PRINT_LINE('yes');
       else
         DBE_OUTPUT.PRINT_LINE('no');
       end if;
end;
/

--delete and first or last
declare
       type t_table1 is table of int index by Binary_Integer;
       p_key t_table1;
       i Binary_Integer;
begin
       p_key(2):=11;
       p_key(3):=3;
       p_key(1):=3;
       p_key(-1):=3;
       p_key(-3):=3;
       p_key(5):=3;
       DBE_OUTPUT.PRINT_LINE(p_key.first || '  ' || p_key.count);
       p_key.delete(p_key.first);
       DBE_OUTPUT.PRINT_LINE(p_key.first || '  ' || p_key.count);
       p_key.delete(p_key.last);
       DBE_OUTPUT.PRINT_LINE(p_key.last || '  ' || p_key.count);
       p_key.delete(p_key.first, 2);
       DBE_OUTPUT.PRINT_LINE(p_key.first || '  ' || p_key.count);
       p_key.delete(3, p_key.last);
       DBE_OUTPUT.PRINT_LINE(p_key.first || '  ' || p_key.count);
end;
/

--delete and prior or next
declare
       type t_table1 is table of int index by Binary_Integer;
       p_key t_table1;
       i Binary_Integer;
begin
       p_key(2):=11;
       p_key(3):=3;
       p_key(1):=3;
       p_key(-1):=3;
       p_key(-3):=3;
       p_key(5):=3;
       DBE_OUTPUT.PRINT_LINE(p_key.first || '  ' || p_key.count);
       DBE_OUTPUT.PRINT_LINE(p_key.prior(-1) || '  ' || p_key.count);
       p_key.delete(p_key.prior(-1));
       DBE_OUTPUT.PRINT_LINE(p_key.first || '  ' || p_key.count);
       DBE_OUTPUT.PRINT_LINE(p_key.prior(-1) || '  ' || p_key.count);
       p_key.delete(p_key.next(3));
       DBE_OUTPUT.PRINT_LINE(p_key.last || '  ' || p_key.count);
       DBE_OUTPUT.PRINT_LINE(p_key.next(3) || '  ' || p_key.count);
       p_key.delete(p_key.prior(-1), 2);
       DBE_OUTPUT.PRINT_LINE(p_key.first || '  ' || p_key.count);
       p_key.delete(3, p_key.next(3));
       DBE_OUTPUT.PRINT_LINE(p_key.first || '  ' || p_key.count);
end;
/

--convert index
declare
       type t_table1 is table of int index by Binary_Integer;
       p_key t_table1;
       i Binary_Integer;
begin
       p_key(2):=11;
       p_key(2):=12;
       p_key(3):=3;
       p_key(1):=3;
       p_key(5):=11;
       p_key(6):=12;
       p_key(7):=3;
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(2.2);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(2.4);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(2.8);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(3.2, 5.6);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       i := p_key.FIRST;
       WHILE i IS NOT NULL LOOP
       DBE_OUTPUT.PRINT_LINE
       ('index: ' || i || ' is ' || p_key(i));
       i := p_key.NEXT(i);
       end loop;
end;
/

--delete null index and start > end
set serveroutput on;
declare
       type t_table1 is table of int index by Binary_Integer;
       p_key t_table1;
       i Binary_Integer;
begin
       p_key(2):=11;
       p_key(2):=12;
       p_key(3):=3;
       p_key(1):=3;
       p_key(5):=11;
       p_key(6):=12;
       p_key(7):=3;
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(null);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(null, 2);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(3, null);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(7, 5);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(6, 50);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       i := p_key.FIRST;
       WHILE i IS NOT NULL LOOP
       DBE_OUTPUT.PRINT_LINE
       ('index: ' || i || ' is ' || p_key(i));
       i := p_key.NEXT(i);
       end loop;
end;
/

--delete index length exceed
declare
       type t_table1 is table of int index by varchar(5);
       p_key t_table1;
       i varchar(10);
begin
       p_key('a'):=11;
       p_key('ab'):=12;
       p_key('va'):=3;
       p_key('za'):=3;
       p_key('da'):=11;
       p_key('dva'):=12;
       p_key('opt'):=3;
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete('ab');
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete('scccccs'); --exceed length, delete 0 element
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete('scccccs', 'dva');
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       i := p_key.FIRST;
       WHILE i IS NOT NULL LOOP
       DBE_OUTPUT.PRINT_LINE
       ('index: ' || i || ' is ' || p_key(i));
       i := p_key.NEXT(i);
       end loop;
       p_key.delete('dva', 'scccccs');--delete 2 elements success
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       i := p_key.FIRST;
       WHILE i IS NOT NULL LOOP
       DBE_OUTPUT.PRINT_LINE
       ('index: ' || i || ' is ' || p_key(i));
       i := p_key.NEXT(i);
       end loop;
end;
/

--error
declare
       type t_table1 is table of int index by Binary_Integer;
	   p_key t_table1;
	   i Binary_Integer;
begin
       p_key(2):=11;
       p_key(3):=3;
       p_key(1):=3;
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(2, 2147483650); --out range
       DBE_OUTPUT.PRINT_LINE(p_key.count);
end;
/

-----------nested delete test
--nested table
create or replace type t_table is table of int;
/
declare
       cs t_table:=t_table(8, 2);
       type ListType is table of t_table index by pls_integer;
        p_key ListType;
begin
       p_key(3):=cs;
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       DBE_OUTPUT.PRINT_LINE(cs(2));
       DBE_OUTPUT.PRINT_LINE(p_key(3)(2));
       p_key.delete(3);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       DBE_OUTPUT.PRINT_LINE(cs(2));
       DBE_OUTPUT.PRINT_LINE(p_key(3)(2));--error
end;
/
drop type t_table;

declare
       type ListType is table of int index by string(10);
       type t_table is table of ListType;
       cs t_table:=t_table();
begin
       cs.extend(5);
       DBE_OUTPUT.PRINT_LINE(cs(7)('a'));--error
end;
/

declare
       type ListType is table of int index by varchar(10);
       type t_table is table of ListType;
       cs t_table:=t_table();
begin
       cs.extend(5);
       DBE_OUTPUT.PRINT_LINE(cs(4)('a'));--error
end;
/

declare
       type ListType is table of int index by varchar(10);
       type t_table is table of ListType;
       cs t_table:=t_table();
begin
       cs.extend(5);
       cs(4)('a'):=4;
       cs(3)('a'):=3;
       DBE_OUTPUT.PRINT_LINE(cs(4)('a'));
       DBE_OUTPUT.PRINT_LINE(cs(3)('a'));
end;
/

declare
       type ListType is table of int index by varchar(10);
       aa ListType;
       type t_table is table of ListType;
       cs t_table:=t_table(aa);
begin
       cs.extend(5, 1);
       cs(4)('a'):=4;
       cs(3)('a'):=3;
       DBE_OUTPUT.PRINT_LINE(cs(4)('a'));
       DBE_OUTPUT.PRINT_LINE(cs(3)('a'));
end;
/

declare
       type ListType is table of int index by varchar(10);
       type t_table is varray(10) of ListType;
       cs t_table:=t_table();
begin
       cs.extend(5);
       cs(4)('a'):=4;
       cs(3)('a'):=3;
       DBE_OUTPUT.PRINT_LINE(cs(4)('a'));
       DBE_OUTPUT.PRINT_LINE(cs(3)('a'));
end;
/

declare
       type ListType is table of int index by string(10);
       p_key ListType;
       p_list ListType;
       type t_table is table of ListType;
       cs t_table:=t_table();
begin
       p_key('sd'):=3;
       p_key('aa'):=1;
       p_list('ws'):=2;
       p_list('rr'):=5;
       p_list('tr'):=6;
       cs.extend(5);
       cs(1):=p_key;
       cs(2):=p_key;
       cs(3):=p_list;
       cs(4):=p_list;
       DBE_OUTPUT.PRINT_LINE(cs.count);
       DBE_OUTPUT.PRINT_LINE(cs(4)('rr'));
       cs.delete(3, 4);
       DBE_OUTPUT.PRINT_LINE(cs.count);
       DBE_OUTPUT.PRINT_LINE(p_list('rr'));
       DBE_OUTPUT.PRINT_LINE(cs(4)('rr'));--ERROR
end;
/

--varray
create or replace type t_table1 is varray(10) of int;
/
declare
       cc t_table1:=t_table1(3, 2);
       type ListType is table of t_table1 index by pls_integer;
       p_key ListType;
begin
       p_key(2):=t_table1(1, 2);
       p_key(-1):=cc;
       DBE_OUTPUT.PRINT_LINE(p_key(-1)(1));
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       DBE_OUTPUT.PRINT_LINE(cc(1));
       cc.delete;
       p_key.delete(-4, 0);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       DBE_OUTPUT.PRINT_LINE(p_key(-1)(1));
end;
/
drop type t_table1;

declare
       type t_table3 is table of int index by pls_integer;
       cc t_table3;
       type ListType is varray(10) of t_table3;
        p_key ListType:=ListType();
begin
       cc(2) := 2;
       p_key:=ListType(cc,cc,cc,cc,cc);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete;
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       DBE_OUTPUT.PRINT_LINE(cc(2));
end;
/

--object
create or replace type t_table2 is object(
a int,
b int
);
/
declare
       cc t_table2:=t_table2(1, 2);
       dd t_table2:=t_table2(4, 5);
       type ListType is table of t_table2 index by pls_integer;
        p_key ListType;
begin
       p_key(2):=cc;
       p_key(-1):=t_table2(1, 2);
       DBE_OUTPUT.PRINT_LINE(p_key(-1).a);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(-4, 0);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       DBE_OUTPUT.PRINT_LINE(p_key(-1).a);
end;
/
drop type t_table2;

--record
declare
        Type RecType11 Is Record
        (
        a int,
        b int
        );
        cc RecType11;
       type ListType is table of RecType11 index by pls_integer;
        p_key ListType;
begin
       cc.a := 3;
       p_key(2):=cc;
       p_key(-1):=cc;
       DBE_OUTPUT.PRINT_LINE(p_key(-1).a);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       p_key.delete(-4, 0);
       DBE_OUTPUT.PRINT_LINE(p_key.count);
       DBE_OUTPUT.PRINT_LINE(p_key(-1).a);
end;
/

declare
       type t_table3 is table of int index by pls_integer;
       cc t_table3;
       type ListType is record(
         aa t_table3,
         bb t_table3
       );
        p_key ListType;
        p_2 ListType;
begin
       cc(2) := 2;
       p_key.aa:=cc;
       cc(2) :=3;
       p_key.bb := cc;
       p_2 := p_key;
       DBE_OUTPUT.PRINT_LINE(p_key.aa(2));
       DBE_OUTPUT.PRINT_LINE(p_key.bb(2));
       DBE_OUTPUT.PRINT_LINE(cc(2));
       DBE_OUTPUT.PRINT_LINE(p_2.aa(2));
       DBE_OUTPUT.PRINT_LINE(p_2.bb(2));
       cc.delete;
       DBE_OUTPUT.PRINT_LINE(p_key.aa(2));
end;
/

--%rowtype
drop table if exists test_table1;
create table test_table1(id int,name varchar(10));
insert into test_table1 values(1, 'ss');
insert into test_table1 values(2, 'sd');
insert into test_table1 values(3, 'as');
insert into test_table1 values(4, 'As');
commit;

declare
       cv SYS_REFCURSOR;
       t_row test_table1%rowtype;
       type ListType is table of test_table1%rowtype index by pls_integer;
        p_key ListType;
begin
       open cv for select * from test_table1;
       loop
         fetch cv into t_row;
         EXIT WHEN cv%NOTFOUND;
         p_key(t_row.id):=t_row;
         DBE_OUTPUT.PRINT_LINE(p_key(t_row.id).name);
       end loop;
       p_key.delete(3);
       DBE_OUTPUT.PRINT_LINE(p_key(3).name);
end;
/

--hash table
declare
       type t_table3 is table of int index by pls_integer;
       cc t_table3;
       type ListType is table of t_table3 index by pls_integer;
        p_key ListType;
begin
       cc(2) := 2;
       cc(3):= 4;
       cc(4):=5;
       cc.delete(3);
       p_key(2):=cc;
       p_key(3):=cc;
       p_key.delete(3);
       DBE_OUTPUT.PRINT_LINE(p_key(2)(4));
       DBE_OUTPUT.PRINT_LINE(p_key(2)(3));
end;
/

------------coverage use cases--error
declare
       type t_table1 is table of int index by pls_integer;
       p_key t_table1;
begin
       p_key.delete(1,2,3);
end;
/

declare
       type t_table1 is table of int index by pls_integer;
       p_key t_table1;
begin
       p_key.first(1);
end;
/

declare
       type t_table1 is table of int index by pls_integer;
       p_key t_table1;
begin
       p_key.last(1);
end;
/

declare
       type t_table1 is table of int index by pls_integer;
       p_key t_table1;
begin
       p_key.prior;
end;
/

declare
       type t_table1 is table of int index by Binary_Integer;
       p_key t_table1;
begin
       p_key.next;
end;
/

declare
       type t_table1 is table of int index by Binary_Integer;
       p_key t_table1;
begin
       DBE_OUTPUT.PRINT_LINE(p_key.count(1));
end;
/

declare
       type t_table1 is table of int index by Binary_Integer;
       p_key t_table1;
begin
       DBE_OUTPUT.PRINT_LINE(p_key.limit(1));
end;
/

declare
       type ListType is table of pls_integer;
       type t_table is table of pls_integer index by ListType;
begin
       DBE_OUTPUT.PRINT_LINE('sd');
end;
/

--------expression and hash table
--error
declare
       type ListType is table of varchar(10) index by binary_integer;
        p_key ListType;
        p_new ListType;
begin
       p_key(2):= 'aa';
       p_new(2):= 'aa';
       if p_key = p_new then
       DBE_OUTPUT.PRINT_LINE('4exists');
       end if;
end;
/

declare
       type ListType is table of varchar(10) index by binary_integer;
        p_key ListType;
        i int := 0;
begin
       p_key(2):= 'aa';
       i := (p_key = p_key);
       DBE_OUTPUT.PRINT_LINE(i);
end;
/

declare
       type t_table3 is table of int index by pls_integer;
       cc t_table3;
       type ListType is table of t_table3 index by pls_integer;
        p_key ListType;
begin
       cc(2) := 2;
       cc(3):= 4;
       p_key(2):=cc+8;
       p_key(3):=cc;
       DBE_OUTPUT.PRINT_LINE(p_key(2)(2));
       DBE_OUTPUT.PRINT_LINE(p_key(2)(3));
end;
/

declare
       type t_table3 is table of int index by int;
       cc t_table3;
begin
       select id into cc(1) from (select * from dual order by cc); --pl_verify_expr_param_node
       DBE_OUTPUT.PRINT_LINE(cc(1));
end;
/

declare
       type t_table3 is table of int index by int;
       cc t_table3;
       type t_trr is table of t_table3;
       pt t_trr:=t_trr();
begin
       pt.extend;
       select id into pt from (select * from dual order by pt); --pl_verify_expr_param_node
       DBE_OUTPUT.PRINT_LINE(pt(1));
end;
/
drop table if exists test_table1;

-- A assign to A
set serveroutput on;
declare
       type ListType is table of varchar(10) index by binary_integer;
        p_key ListType;
begin
       p_key(2):= 'aa';
       p_key(8):= 'ww';
       p_key := p_key;
       DBE_OUTPUT.PRINT_LINE('prior: '||p_key.prior(10));
       DBE_OUTPUT.PRINT_LINE('next: '||p_key.next(10));
end;
/
--error
DECLARE
  type ccc is table of int index by pls_integer;
  target2 ccc DEFAULT 1;
BEGIN
  DBE_OUTPUT.PRINT_LINE(target2(1));
END;
/

DECLARE
 TYPE ORG_TABLE_TYPE IS TABLE OF VARCHAR2(25) INDEX BY BINARY_INTEGER;
 V_ORG_TABLE ORG_TABLE_TYPE:= '2';
BEGIN
 DBE_OUTPUT.PRINT_LINE('ok');
END;
/

DECLARE
  type ccc is table of int index by pls_integer;
  dd ccc;
  dd(1):=2;
BEGIN
  DBE_OUTPUT.PRINT_LINE(dd(1));
END;
/

DECLARE
  type ccc is table of int index by pls_integer;
  dd ccc;
  type xxx is table of int index by pls_integer;
  target2 xxx := dd;
BEGIN
  dd(1):=9;
END;
/

DECLARE
  type ccc is table of int index by pls_integer;
  dd ccc;
  target2 ccc DEFAULT dd;
BEGIN
  dd(1):=9;
  DBE_OUTPUT.PRINT_LINE(target2(1));
END;
/

DECLARE
  type ccc is table of int index by pls_integer;
  dd ccc;
  target2 ccc := dd;
BEGIN
  dd(1):=9;
  target2 := dd;
  DBE_OUTPUT.PRINT_LINE(target2(1));
END;
/

--ref cursor as type member, error
declare
type c_t1 is ref cursor;
type ccc is table of c_t1 index by pls_integer;
begin
    dbe_output.print_line(' error ');
end;
/

declare
type c_t1 is ref cursor;
type ccc is table of int index by c_t1;
begin
    dbe_output.print_line(' error ');
end;
/

declare
type c_t1 is ref cursor;
type ccc is table of c_t1;
begin
    dbe_output.print_line(' error ');
end;
/

declare
type c_t1 is ref cursor;
type ccc is varray(10) of c_t1;
begin
    dbe_output.print_line(' error ');
end;
/

declare
type c_t1 is ref cursor;
type t_record2 is record
(
    c c_t1,
    d sys_refcursor
   );
begin
    dbe_output.print_line(' error ');
end;
/

declare
type ccc is table of sys_refcursor index by pls_integer;
begin
    dbe_output.print_line(' error ');
end;
/

--bind parameter
drop table if exists t112;
create table t112(f1 int, name varchar(10), address varchar(10));
set serveroutput on;
create or replace procedure testjob is
type nesttb is table of t112%rowtype index by pls_integer;
v1 nesttb;
v2 integer := 1;
v3 integer := 10;
v4 nesttb;
cursor v_cur is select * from t112;
begin
for i in v2..v3 loop
insert into t112 values (i,'aa','bb');
select * bulk collect into v1 from t112 where f1 = i;
end loop;
DBE_OUTPUT.PRINT_LINE(v1.count);
open v_cur;
loop
fetch v_cur bulk collect into v1;
DBE_OUTPUT.PRINT_LINE(v1.count);
for i in v1.first .. v1.last loop
execute immediate 'select * from t112 where f1 = :1' bulk collect into v4 using in i;
end loop;
exit when v_cur%notfound;
end loop;
close v_cur;
for i in v4.first .. v4.last loop
DBE_OUTPUT.PRINT_LINE(v4(i).f1);
end loop;
end ;
/
call testjob();
drop table t112;
drop procedure testjob;

-- expression for table type
drop table if exists coll_tbl1;
create table coll_tbl1(a1 int);
insert into coll_tbl1 values(1);
commit;
declare
 TYPE C1 IS TABLE OF INTEGER index by pls_integer;
 var_C1 C1;
 a int;
begin
var_C1(1):=123;
 select a1 + var_C1(1) into a from coll_tbl1 order by a1;
 dbe_output.print_line(a);
 select a1 + var_C1(1) into a from coll_tbl1 order by a1 + var_C1(1);
 dbe_output.print_line(a);
 select a1 + var_C1(1) into a from coll_tbl1 order by var_C1(1);
 dbe_output.print_line(a);
end;
/
declare
 TYPE C1 IS TABLE OF INTEGER index by pls_integer;
 var_C1 C1;
 a int;
begin
var_C1(1):=123;
var_c1(2):=234;
var_c1(3):=345;
 select a1 + var_C1(1) into a from coll_tbl1 order by var_C1;
 dbe_output.print_line(a);
end;
/
declare
 TYPE C1 IS TABLE OF INTEGER index by pls_integer;
 var_C1 C1;
 a int;
begin
var_C1(1):=123;
var_c1(2):=234;
var_c1(3):=345;
 select a1 + var_C1(1) into a from coll_tbl1 group by var_C1(1); -- raise error
end;
/
declare
 TYPE C1 IS TABLE OF INTEGER index by pls_integer;
 var_C1 C1;
 a int;
begin
var_C1(1):=123;
var_c1(2):=234;
var_c1(3):=345;
 select a1 + var_C1(1) into a from coll_tbl1 group by var_C1;  -- raise error
end;
/
drop table coll_tbl1;

-- only hash table element can be compared
Declare
 TYPE C2 IS TABLE OF INTEGER index by pls_integer;
    EmpRec1  c2;
    EmpRec2  c2;
Begin
    EmpRec1(3):=7369;
    EmpRec1(4):=800;
    EmpRec1(0):=10;
    EmpRec1(7):=100;
    EmpRec2 := EmpRec1;
    if EmpRec1(3) <= EmpRec2(3) then
       DBE_OUTPUT.PRINT_LINE('CantianDB');
    end if;
    if EmpRec2(7) is not null then
       DBE_OUTPUT.PRINT_LINE('Huawei');
    end if;
End;
/
Declare
 TYPE C2 IS TABLE OF INTEGER index by pls_integer;
    EmpRec1  c2;
    EmpRec2  c2;
Begin
    EmpRec1(3):=7369;
    EmpRec1(4):=800;
    EmpRec1(0):=10;
    EmpRec1(7):=100;
    EmpRec2 := EmpRec1;
    if EmpRec2 is not null then
       DBE_OUTPUT.PRINT_LINE('Huawei');
    end if;
    if EmpRec1 <= EmpRec2 then --error
       DBE_OUTPUT.PRINT_LINE('CantianDB');
    end if;
End;
/

DECLARE
TYPE TABLE_TYPE_SET_NULL IS TABLE OF VARCHAR(10) Index By Binary_Integer;
 v1 TABLE_TYPE_SET_NULL;
BEGIN
v1(1):='ABC';
v1(2):='def';
 DBE_OUTPUT.PRINT_LINE(v1(1));
 DBE_OUTPUT.PRINT_LINE(v1(2));
 v1 := null;  --error
 DBE_OUTPUT.PRINT_LINE(v1(1));
END;
/

drop table if exists test_t1;
create table test_t1(f1 varchar(30));
create or replace type test_type_varchar5 is VARRAY(5) of varchar2(10);
/
--test cast func 1st arg
DECLARE
    type test_type_varchar7 is table of varchar2(20) index by pls_integer;
    i_n1 test_type_varchar7;
BEGIN
    i_n1(1):='aaa';
    i_n1(2):='www';
    insert into test_t1 select * from table(cast(i_n1 as test_type_varchar5));
END;
/

--test cast func 2nd arg
DECLARE
    i_n1 test_type_varchar5;
    type test_type_varchar7 is table of varchar2(20) index by pls_integer;
    i_n2 test_type_varchar7;
BEGIN
    i_n1 :=test_type_varchar5('abc','dge');
    insert into test_t1 select * from table(cast(i_n1 as test_type_varchar7));
END;
/

DECLARE
    type test_type_varchar7 is table of varchar2(20) index by pls_integer;
    i_n1 test_type_varchar7;
BEGIN
    i_n1(1):='aaa';
    i_n1(2):='www';
    insert into test_t1 select * from table(cast(i_n1(1) as test_type_varchar5));
END;
/
drop type test_type_varchar5 force;
drop table test_t1 purge;

-- DATA_TYP_USING_REPLACE attr using, replace DATA_TYP_USING_REPLACE success
CREATE OR REPLACE TYPE DATA_TYP_USING_REPLACE FORCE AS OBJECT
( year NUMBER
);
/
create or replace function FVT_FUN_01_01(id int) return int
is
 count_row int := 0;
 kkk DATA_TYP_USING_REPLACE;
begin
 kkk := DATA_TYP_USING_REPLACE(2);
 DBE_OUTPUT.PRINT_LINE(kkk.year);
 execute immediate 'declare TYPE DATA_TYP_USING_REPLACE IS TABLE OF INT INDEX BY PLS_INTEGER; xxx DATA_TYP_USING_REPLACE; begin xxx(1) := '||	id || '; xxx(2) := ' || (id * 2)|| '; DBE_OUTPUT.PRINT_LINE(xxx(1)); DBE_OUTPUT.PRINT_LINE(xxx(2)); end;';
 return count_row;
end;
/
declare
a int;
begin
 a := FVT_FUN_01_01(3);
end;
/
drop function FVT_FUN_01_01;

create or replace function FVT_FUN_01_02(id int) return int
is
 count_row int := 0;
begin
 execute immediate 'declare TYPE DATA_TYP_USING_REPLACE IS TABLE OF INT INDEX BY PLS_INTEGER; xxx DATA_TYP_USING_REPLACE; begin xxx(1) := :1 ; xxx(2) := :2; DBE_OUTPUT.PRINT_LINE(xxx(1)); DBE_OUTPUT.PRINT_LINE(xxx(2)); end;' using id, (id*2);
 return count_row;
end;
/
declare
a int;
begin
 a := FVT_FUN_01_02(3);
end;
/
drop function FVT_FUN_01_02;
drop type if exists DATA_TYP_USING_REPLACE;

drop TYPE if exists c_v_s force;
drop TYPE if exists c_n_s force;
drop TYPE if exists c_n_v force;
drop TYPE if exists c_v_n force;
drop TYPE if exists r_s_s force;
drop TYPE if exists r_s_r_n_v force;
drop TYPE if exists c_v_r force;
drop TYPE if exists c_n_r force;
create type c_v_s is varray(3) of varchar(100);
/
create type c_n_s is table of number;
/
create type c_n_v is table of c_v_s;
/
create type c_v_n is varray(3) of c_n_s;
/
create type r_s_s FORCE AS OBJECT(a int, b int);
/
create type r_s_r_n_v FORCE AS OBJECT(a int, b r_s_s, c c_n_v, d c_v_n);
/
create type c_n_r is table of r_s_r_n_v;
/

DECLARE
    type c_v_r is table of r_s_r_n_v index by pls_integer;
    type l_r_s_s is record(a int, b int);
    type l_r_s_r_n_v is record(a int, b l_r_s_s, c c_v_r, d c_n_r);
    type l_c_v_r is varray(3) of l_r_s_r_n_v;
    type l_c_n_r is table of l_r_s_r_n_v index by pls_integer;

    v1 c_v_s := c_v_s(123, 456, 789);
    v2 c_n_s := c_n_s(123, 456, 789);
    v3 c_n_v := c_n_v(v1, c_v_s(111, 222, 333));
    v4 c_v_n := c_v_n(v2, c_n_s(111, 222, 333));
    v5 r_s_s := r_s_s(1,1);

    v6 r_s_r_n_v := r_s_r_n_v(1, v5, v3, v4);
    v61 r_s_r_n_v;
    v7 c_v_r;
    v8 c_n_r := c_n_r(v6, v6, v6);

    v11 l_r_s_s;
    v12 l_r_s_r_n_v;
    v121 l_r_s_r_n_v;
    v13 l_c_v_r := l_c_v_r();
    v14 l_c_n_r;

BEGIN
    v7(1):= v6;
    v7(2):= v6;
    if v11.a is NULL then
      dbe_output.PRINT_LINE('v11.a' ||' is null');
    end if;
    v11.b := 3;
    if v11.b is not NULL then
      dbe_output.PRINT_LINE('v11.b = ' || v11.b ||' is not null');
    end if;
    v11:=null;
    if v11.b is NULL then
      dbe_output.PRINT_LINE('v11.b' ||' is null');
    end if;

    -- local record assign
    if v12.b.b is NULL then
      dbe_output.PRINT_LINE('v12.b.b' ||' is null');
    end if;

    v12.b.a:=3;
    if v12.b.a is not NULL then
      dbe_output.PRINT_LINE('v12.b.a = ' || v12.b.a ||' is not null');
    end if;

    if v12.c is NULL then
      dbe_output.PRINT_LINE('v12.c' ||' is null');
    end if;
    v12.c := v7;
    v12.d := v8;
    v121:= v12;
    v12 := null;
    if v12.b.b is NULL then
      dbe_output.PRINT_LINE('v12.b.b' ||' is null');
    end if;

    if v12.c is NULL then
      dbe_output.PRINT_LINE('v12.c' ||' is null');
    end if;

    -- object record assign
    v61 := v6;
    v6 :=null;
    if v6 is NULL then
      dbe_output.PRINT_LINE('v6' ||' is null');
    end if;

    dbe_output.PRINT_LINE('v61.a = ' || v61.a);
    dbe_output.PRINT_LINE('v61.b.a = ' || v61.a);
    dbe_output.PRINT_LINE('v61.c(1)(1) = ' || v61.c(1)(1));
    dbe_output.PRINT_LINE('v61.d(1)(2) = ' || v61.d(1)(2));

    -- collection assign, record and object is same
    v13.extend();
    v13(1):= v121;
    v13 := null;

    v14(1):= v121;
    v14(1).a := 100;
    v14(1).b.a := 100;
    v14(1).b.b := 100;
    dbe_output.PRINT_LINE('v14(1).a = ' || v121.a);
    dbe_output.PRINT_LINE('v14(1).b.a = ' || v121.b.a);
    dbe_output.PRINT_LINE('v14(1).b.b = ' || v121.b.b);
    v14 := null;
    dbe_output.PRINT_LINE('v121.a = ' || v121.a);
    dbe_output.PRINT_LINE('v121.b.a = ' || v121.b.a);
    dbe_output.PRINT_LINE('v121.b.b = ' || v121.b.b);

END;
/
drop type c_v_s FORCE;
drop type c_n_s FORCE;
drop type c_n_v FORCE;
drop type c_v_n FORCE;
drop type r_s_s FORCE;
drop type r_s_r_n_v FORCE;
drop type c_n_r FORCE;

--index is not exists    prior and next
DECLARE
 TYPE Arr_Type IS table OF NUMBER index by pls_integer;
 v_Numbers Arr_Type;
BEGIN
 v_Numbers(1) := 10;
 v_Numbers(2) := 20;
 v_Numbers(3) := 30;
 v_Numbers(4) := 40;
 DBE_OUTPUT.PRINT_LINE(NVL(v_Numbers.prior(0), 1));
 DBE_OUTPUT.PRINT_LINE(NVL(v_Numbers.prior(5), 1));
 DBE_OUTPUT.PRINT_LINE(NVL(v_Numbers.next(5), 1));
 DBE_OUTPUT.PRINT_LINE(NVL(v_Numbers.prior(v_Numbers.first()), 1));
 DBE_OUTPUT.PRINT_LINE(NVL(v_Numbers.next(v_Numbers.last()), 1));
 DBE_OUTPUT.PRINT_LINE(NVL(v_Numbers.prior(3400), 1));
 DBE_OUTPUT.PRINT_LINE(NVL(v_Numbers.next(3400), 1));
END;
/

DECLARE
 TYPE nt_Type IS table OF NUMBER index by pls_integer;
 v_Numbers nt_Type;
BEGIN
 v_Numbers(1) := 10;
 v_Numbers(2) := 20;
 v_Numbers(3) := 30;
 v_Numbers(4) := 40;
 v_Numbers.delete(4);
 v_Numbers.delete(1);
 v_Numbers(3) := null;
 DBE_OUTPUT.PRINT_LINE(v_Numbers.prior(0));
 DBE_OUTPUT.PRINT_LINE(v_Numbers.prior(5));
 DBE_OUTPUT.PRINT_LINE(v_Numbers.next(5));
 DBE_OUTPUT.PRINT_LINE(v_Numbers.next(-1));
 DBE_OUTPUT.PRINT_LINE(v_Numbers.next(1));
 DBE_OUTPUT.PRINT_LINE(v_Numbers.prior(3400));
 DBE_OUTPUT.PRINT_LINE(v_Numbers.next(0));
END;
/

DECLARE
TYPE t1 IS VARRAY(10) OF INTEGER; -- varray of integer
va t1 := t1(2,3,5);
vb t1 := t1(55,6,73);
vc t1 := t1(2,4);
TYPE nt1 IS table OF t1 index by pls_integer; -- varray of varray of integer
nva nt1;
i INTEGER;
j INTEGER;
BEGIN
nva(1) := va;
nva(2) := vb;
nva(3) := vc;
nva(4) := va;
i := nva(2)(3);
DBE_OUTPUT.PRINT_LINE('i = ' || i);
nva(3) := t1(56, 32);
nva(4) := t1(45,43,67,43345);
nva(4)(4) := 1;
nva(4).EXTEND;
nva(4)(5) := 909;
FOR i IN 1 .. nva.COUNT() LOOP
    DBE_OUTPUT.PRINT_LINE('----------------------------');
    FOR j IN 1 .. nva(i).COUNT() LOOP
        DBE_OUTPUT.PRINT_LINE('nva('|| i || ') = ' || nva(i)(j));
    END LOOP;
 END LOOP;
END;
/

DECLARE
  TYPE tb IS TABLE OF VARCHAR2(20) index by pls_integer;
  vtb tb;
  TYPE ntb IS TABLE OF tb index by pls_integer;
  vntn ntb;
BEGIN
  vtb(1):=3;
  vtb(2):=4;
  vntn(1):=vtb;
  vntn(2) := vntn(1);
  vntn.DELETE(1);
  vntn(2).DELETE(1);
  DBE_OUTPUT.PRINT_LINE(vntn.count);
  DBE_OUTPUT.PRINT_LINE(vtb.count);
  DBE_OUTPUT.PRINT_LINE(vntn(2).count);
END;
/

--Inserting %ROWTYPE Record into hash Table (Right)
DROP TABLE if exists plch_departure;
CREATE TABLE plch_departure (destination VARCHAR2(100),departure_time VARCHAR2(20),delay NUMBER(10));
DECLARE
dep_rec plch_departure%rowtype;
type plc is table of plch_departure%rowtype index by pls_integer;
ccc plc;
BEGIN
dep_rec.destination := 'X';
dep_rec.departure_time := '0000-00-00';
dep_rec.delay := 1500;
ccc(1):=dep_rec;
INSERT INTO plch_departure (destination, departure_time, delay)
VALUES (ccc(1).destination, ccc(1).departure_time, ccc(1).delay);
END;
/
select * from plch_departure;
DROP TABLE plch_departure;

--test default
DROP TABLE if exists t1;
create table t1 (a int);
DECLARE
  TYPE name_rec IS RECORD (
    first t1.a%TYPE DEFAULT 1
  );
  target name_rec;
    TYPE name_rec2 IS RECORD (
    rec2 t1%ROWTYPE DEFAULT target
  );
  dd name_rec2;
  type ccc is table of name_rec2 index by pls_integer;
  target2 ccc;
    target3 t1%ROWTYPE DEFAULT target;
BEGIN
 target2(1):=dd;
  DBE_OUTPUT.PRINT_LINE ('target2: ' || target2(1).rec2.a);
  DBE_OUTPUT.PRINT_LINE ('target3: ' || target3.a);
END;
/

--test default
create or replace type vv1 is varray(4) of varchar2(15);
/
DECLARE
  TYPE name_rec1 IS RECORD (
    rec1 t1.a%TYPE DEFAULT 1,
    rec1_2 int DEFAULT 2
  );
  target1 name_rec1;
  TYPE name_rec2 IS RECORD (
    rec2 t1%ROWTYPE DEFAULT target1
  );
  target2 name_rec2;
  v_def_1 vv1 := vv1('aaaa');
  TYPE name_rec3 IS RECORD (
    rec3 name_rec2 DEFAULT target2,
    rec3_2 vv1 DEFAULT v_def_1,
    rec3_3 int DEFAULT 1
  );
  v_def_2 vv1 := vv1('bbbb');
  target3 name_rec3;
  TYPE name_rec4 IS RECORD (
    rec4 name_rec3 DEFAULT target3,
    rec4_2 vv1 DEFAULT v_def_2,
    rec4_3 int DEFAULT 1
  );
  target4 name_rec4;
  TYPE name_rec5 IS RECORD (
    rec5 name_rec4 DEFAULT target4
  );
  target5 name_rec5;
  type ccc is table of name_rec5 index by pls_integer;
  we ccc;
BEGIN
  we(1):=target5;
  DBE_OUTPUT.PRINT_LINE ('DEFAULT: ' || we(1).rec5.rec4.rec3.rec2.a);
END;
/
drop type vv1 force;
DROP TABLE t1;

--expression
declare
TYPE zzz IS TABLE OF int INDEX BY PLS_INTEGER;
c_r zzz;
c1_r zzz;
begin
  select c_r + 2 into c1_r from dual;
end;
/

declare
TYPE zzz IS TABLE OF int INDEX BY PLS_INTEGER;
type yyy is record(r zzz);
c_r yyy;
c1_r zzz;
begin
  select c_r.r * 2 into c1_r from dual;
end;
/

declare
  TYPE varray1 IS table OF clob INDEX BY PLS_INTEGER;
  var1 varray1;
begin
    var1(1):='null';
    var1(3):='';
    var1(2):=null;
    dbe_output.print_line('var1(2):' || var1(2) || '  var1(1):' || var1(1) ||'  var1(3):' ||var1(3));
end;
/

declare
TYPE for_type_null IS TABLE OF varchar(100) index by pls_integer;
  nt for_type_null;
BEGIN
for i in nt.first..nt.last loop --error
dbe_output.print_line(1);
end loop;
end;
/

--fetch cursor into hash table & record
DECLARE--hstb.record
 CURSOR c2 IS
  SELECT *
    FROM EMPLOYEES_UDT
   WHERE REGEXP_LIKE(job_id, '[ACADFIMKSA]_M[ANGR]')
   ORDER BY job_id;
  TYPE namelist IS TABLE OF EMPLOYEES_UDT%ROWTYPE INDEX BY varchar(10);
   v_EMPLOYEES_UDT namelist;
   cc EMPLOYEES_UDT%ROWTYPE;
   i varchar(20);
BEGIN
 i :='a';
 OPEN c2;
 LOOP
  FETCH c2
  INTO v_EMPLOYEES_UDT(i);
  EXIT WHEN c2%NOTFOUND;
  DBE_OUTPUT.PRINT_LINE(i || '  ' || RPAD(v_EMPLOYEES_UDT(i).last_name, 25, ' ') ||
                       v_EMPLOYEES_UDT(i).job_id);
 i:=i || 'b';
 END LOOP;
 CLOSE c2;
END;
/

DECLARE--hstb.record
 CURSOR c2 IS
  SELECT *
    FROM EMPLOYEES_UDT
   WHERE REGEXP_LIKE(job_id, '[ACADFIMKSA]_M[ANGR]')
   ORDER BY job_id;
  TYPE namelist IS TABLE OF EMPLOYEES_UDT%ROWTYPE INDEX BY PLS_INTEGER;
   v_EMPLOYEES_UDT namelist;
   cc EMPLOYEES_UDT%ROWTYPE;
   i int;
BEGIN
cc.job_id := 'SA_MAN';
cc.last_name := 'Greenberg';
 for i in 1.. 12 LOOP
v_EMPLOYEES_UDT(i) := cc;
 END LOOP;
 DBE_OUTPUT.PRINT_LINE('count:'|| v_EMPLOYEES_UDT.count);
 i :=1;
 OPEN c2;
 LOOP
  FETCH c2
  INTO v_EMPLOYEES_UDT(i);
  EXIT WHEN c2%NOTFOUND;
  DBE_OUTPUT.PRINT_LINE(RPAD(v_EMPLOYEES_UDT(i).last_name, 25, ' ') ||
                       v_EMPLOYEES_UDT(i).job_id);
 i:=i+1;
 END LOOP;
 CLOSE c2;
  DBE_OUTPUT.PRINT_LINE('count:'|| v_EMPLOYEES_UDT.count);
 for i in 1.. v_EMPLOYEES_UDT.count LOOP
    DBE_OUTPUT.PRINT_LINE(RPAD(v_EMPLOYEES_UDT(i).last_name, 25, ' ') ||
                       v_EMPLOYEES_UDT(i).job_id);
 END LOOP;
END;
/

DECLARE--record.hstb.record
 CURSOR c2 IS
  SELECT *
    FROM EMPLOYEES_UDT
   WHERE REGEXP_LIKE(job_id, '[ACADFIMKSA]_M[ANGR]')
   ORDER BY job_id;
  TYPE namelist IS TABLE OF EMPLOYEES_UDT%ROWTYPE INDEX BY PLS_INTEGER;
   type ccc is record(
   ss namelist
   );
   v_EMPLOYEES_UDT ccc;
BEGIN
 OPEN c2;
 LOOP
  FETCH c2
  INTO v_EMPLOYEES_UDT.ss(1);
  EXIT WHEN c2%NOTFOUND;
  DBE_OUTPUT.PRINT_LINE(RPAD(v_EMPLOYEES_UDT.ss(1).last_name, 25, ' ') ||
                       v_EMPLOYEES_UDT.ss(1).job_id);
 END LOOP;
 CLOSE c2;
END;
/

DECLARE--hstb.hstb.record
 CURSOR c2 IS
  SELECT *
    FROM EMPLOYEES_UDT
   WHERE REGEXP_LIKE(job_id, '[ACADFIMKSA]_M[ANGR]')
   ORDER BY job_id;
  TYPE namelist IS TABLE OF EMPLOYEES_UDT%ROWTYPE INDEX BY PLS_INTEGER;
  TYPE ccc IS TABLE OF namelist INDEX BY PLS_INTEGER;
   v_EMPLOYEES_UDT ccc;
BEGIN
 OPEN c2;
 LOOP
  FETCH c2
  INTO v_EMPLOYEES_UDT(2)(1);
  EXIT WHEN c2%NOTFOUND;
  DBE_OUTPUT.PRINT_LINE(RPAD(v_EMPLOYEES_UDT(2)(1).last_name, 25, ' ') ||
                       v_EMPLOYEES_UDT(2)(1).job_id);
 END LOOP;
 CLOSE c2;
END;
/

DROP TABLE EMPLOYEES_UDT PURGE;
DROP TABLE JOBS PURGE;

--error some method can't be function
declare
       type ListType is table of int index by binary_integer;
        p_key ListType;
        i int;
begin
       p_key(2):=1;
       i:=p_key.delete(2);
       DBE_OUTPUT.PRINT_LINE(i);
end;
/

declare
       type ListType is table of int index by binary_integer;
        p_key ListType;
        i int;
begin
       p_key(2):=1;
       if p_key.delete(2) < 1 then
       DBE_OUTPUT.PRINT_LINE('yes');
       else
       DBE_OUTPUT.PRINT_LINE('no');
       end if;
end;
/

declare
       type ListType is varray(10) of int;
        p_key ListType:=ListType(null, null);
        i int;
begin
       p_key(2):=1;
       i:=p_key.extend(2) + 1;
end;
/

declare
       type ListType is table of int;
        p_key ListType:=ListType(null, null);
        i int;
begin
       p_key(2):=1;
       i:=p_key.trim(2);
end;
/

declare
       type ListType is table of int index by binary_integer;
        p_key ListType;
        i int;
begin
       select 1 into i from dual order by p_key.delete(2);
end;
/

declare
       type ListType is table of int index by binary_integer;
        p_key ListType;
        i int;
begin
       p_key(1):=2;
       select 1 into i from dual where p_key.prior(2) < 1;
end;
/

--array to hash table
--error
declare
type myhash is table of int index by pls_integer;
arr myhash;
begin
select * bulk collect into arr from table(cast(array[1,2,3] as myhash));
end;
/

--success
set serveroutput on;
declare
type myhash is table of int index by pls_integer;
arr myhash;
begin
arr := cast(array[1,2,3,4] as myhash);
for i in 1..arr.count loop
    dbe_output.print_line(arr(i));
end loop;
end;
/


declare
type myhash is table of int index by pls_integer;
arr myhash;
begin
--assign cast result to a udt var directly(int)
arr := cast(array[1,2,3] as myhash);
for i in 1..arr.count loop
    dbe_output.print_line(arr(i));
end loop;
arr := cast('{1,2,3}'::int[] as myhash);
for i in 1..arr.count loop
    dbe_output.print_line(arr(i));
end loop;
end;
/

declare
type myhash is table of varchar(10) index by pls_integer;
arr myhash;
begin
--assign cast result to a udt var directly(string)
arr := cast(array['li','hang','hello'] as myhash);
for i in 1..arr.count loop
    dbe_output.print_line(arr(i));
end loop;
arr := cast('{"li","hello","world"}'::varchar(10)[] as myhash);
for i in 1..arr.count loop
    dbe_output.print_line(arr(i));
end loop;
end;
/

--test string truncation
declare
type myhash is table of varchar(2) index by pls_integer;
arr myhash;
begin
arr := cast(array['liu','hang','hello'] as myhash);
for i in 1..arr.count loop
    dbe_output.print_line(arr(i));
end loop;
arr := cast('{"liu","hang","world"}'::varchar(10)[] as myhash);
for i in 1..arr.count loop
    dbe_output.print_line(arr(i));
end loop;
end;
/

--local type can not be out parameter
declare
type array_varchar2 is table of varchar(100) INDEX BY PLS_INTEGER;
zz array_varchar2;
yy array_varchar2;
str_l_querysql varchar(100);
begin
    zz(1):='a';
    zz(2):='b';
    str_l_querysql :=
    ' begin
    :1 := :2;
    end;';
    execute immediate str_l_querysql using out yy, zz;
    dbe_output.print_line(yy(2));
end;
/

declare
type array_varchar2 is table of varchar(100);
zz array_varchar2:=array_varchar2('array', '0');
yy array_varchar2;
str_l_querysql varchar(100);
begin
    zz(1):='a';
    zz(2):='b';
    str_l_querysql :=
    ' begin
    :1 := :2;
    end;';
    execute immediate str_l_querysql using in out yy, in zz;
    dbe_output.print_line(yy(1));
end;
/

declare
type array_varchar2 is table of varchar(100) INDEX BY PLS_INTEGER;
zz array_varchar2;
str_l_querysql varchar(100);
i varchar(10);
begin
    zz(1):='a';
    zz(2):='b';
    str_l_querysql :=
    'begin
    :1 := :2;
    end;';
    execute immediate str_l_querysql using out i, zz(2);
    dbe_output.print_line(i);
end;
/

--error
declare
type array_varchar2 is table of varchar(100) INDEX BY PLS_INTEGER;
zz array_varchar2;
str_l_querysql varchar(200);
i varchar(10);
begin
    zz(1):='a';
    zz(2):='b';
    str_l_querysql :=
    'declare
    type array_varchar2 is table of varchar(100) INDEX BY PLS_INTEGER;
    yy array_varchar2;
    begin
    yy := :1;
    dbe_output.print_line(yy(2));
    end;
    ';
    execute immediate str_l_querysql using zz;
end;
/

--bug-hash table + multi-storey record
set serveroutput on;
declare
type t_table1 is table of int index by Binary_Integer;
Type RecType11 Is Record
(
  a t_table1,
  b int
);
type ListType Is Record
(
  c RecType11,
  d int
);
type secType Is Record
(
  e ListType,
  f int
);
        p_key secType;
begin
       p_key.e.c.a(1):=3;
       DBE_OUTPUT.PRINT_LINE(p_key.e.c.a(1));
end;
/

declare
type nesttb is table of int;
v1 nesttb;
begin
v1:=nesttb(1,2,3);
dbe_output.print_line(v1.trim);
end ;
/

declare
type nesttb is table of int;
v1 nesttb;
a int;
begin
v1:=nesttb(1,2,3);
a := v1.extend;
dbe_output.print_line(a);
end ;
/

declare
type nesttb is table of int;
v1 nesttb;
a int;
begin
v1:=nesttb(1,2,3);
v1.last;
dbe_output.print_line(a);
end ;
/

--DTS20200619
drop table if exists DISTRIBUTE_TABLE_01_03_PURCHASE;
create table DISTRIBUTE_TABLE_01_03_PURCHASE(id int,supernon_alphabetic blob);
begin
 for i in 1..5 loop
   insert into DISTRIBUTE_TABLE_01_03_PURCHASE values(i, 'A1234567891011121314151617181920212223A24A25A26A27A28A29A30A31A32A3');
 end loop;
 commit;
end;
/

declare
v_sql varchar(100);
begin
 update DISTRIBUTE_TABLE_01_03_PURCHASE set supernon_alphabetic=empty_blob() where id=1;
 select supernon_alphabetic into v_sql from DISTRIBUTE_TABLE_01_03_PURCHASE where id=1;
 dbe_output.print_line(v_sql);
end;
/
declare
 cursor v_cursor is select SUPERNON_ALPHABETIC from DISTRIBUTE_TABLE_01_03_PURCHASE where SUPERNON_ALPHABETIC is not null;
begin
 for i in v_cursor loop
   dbe_output.print_line('ok');
 end loop;
 end;
/
drop table DISTRIBUTE_TABLE_01_03_PURCHASE;

declare
       type ListType is table of varchar(10) index by binary_integer;
        p_key ListType;
        p2 ListType;
begin
       p_key(1) := 'a';
	   p_key(2) := null;
	   p2 := p_key;
       DBE_OUTPUT.PRINT_LINE(p2(1) || p2(2));
end;
/


declare
       type ListType is table of varchar(10) index by binary_integer;
       p_key ListType;
begin
       p_key(2) := null;
       p_key(2) := '1';
       p_key(3) := '';
       p_key(3) := '1';
       dbe_output.print_line(p_key(2));
end;
/

conn sys/Huawei@123@127.0.0.1:1611
drop user gs_plsql_hash_table cascade;
set serveroutput off;