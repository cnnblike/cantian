spool ./results/gs_output.out

set serveroutput on;

-- [1]inout normal bind + inout normal bind
drop procedure if exists p_out1;
create or replace procedure p_out1(v_name in out varchar, v_age in out int)
as
	sqlstr varchar2(200);
begin
	sqlstr :='123' || v_age;
	v_name :=sqlstr || v_name;
	v_age  :=sqlstr || v_age;
end;
/
call p_out1(:p1, :p2);
in out
string
abcd
in out
int
456

-- [2]in out normal bind + out normal bind
drop procedure if exists p_out2;
create or replace procedure p_out2(v_name in out varchar, v_age out int)
as
	sqlstr varchar2(200);
begin
	sqlstr :='123';
	v_name :=sqlstr || v_name;
	v_age  :=sqlstr || sqlstr;
end;
/
call p_out2(:p1, :p2);
in out
string
abcd
out
int
456

-- [3]in out normal bind + in normal no bind
drop table if exists t_output;
create table t_output(f1 int);
insert into t_output values(1),(2),(3);
commit;
drop procedure if exists p_out3;
create or replace procedure p_out3(v_age in out int, v_name in int)
as
	sqlstr varchar2(200);
begin
	sqlstr :='123' || v_name;
	v_age  :=sqlstr || v_age;
end;
/
call p_out3(:p1, 789);
in out
int
456

-- [4]in out normal bind + in normal bind
drop table if exists t_output;
create table t_output(f1 int);
insert into t_output values(1),(2),(3);
commit;
drop procedure if exists p_out4;
create or replace procedure p_out4(v_age in out int, v_name in int)
as
	sqlstr varchar2(200);
begin
	sqlstr :='123' || v_name;
	v_age  :=sqlstr || v_age;
end;
/
call p_out4(:p1, :p2);
in out
int
456
in
string
789

-- [5]in normal no bind+in normal no bind(test int to string)
drop table if exists t_output;
create table t_output(a int, b varchar(200));
drop procedure if exists p_out5;
create or replace procedure p_out5(a int, b varchar)
as
c int := 1;
d int := 2;
begin
  insert into t_output values(a, b);
  commit;
end;
/
call p_out5(3, 4);
select * from t_output order by a, b;

-- [6]need keep params for sys_refcursor
drop table if exists t_output;
create table t_output(f_int_output int, f_varchar1 varchar(200),  f_varchar2 varchar(200));
insert into t_output (f_int_output, f_varchar1, f_varchar2) values (1, 'e', 'f');
insert into t_output (f_int_output, f_varchar1, f_varchar2) values (2, 'e', 'f');
insert into t_output (f_int_output, f_varchar1, f_varchar2) values (3, 'e', 'f');
insert into t_output (f_int_output, f_varchar1, f_varchar2) values (4, 'e', 'f');
insert into t_output (f_int_output, f_varchar1, f_varchar2) values (3, 'a', 'ww');
commit;
drop procedure if exists p_out6;
create or replace procedure p_out6 (f1 in number, n_count out number)
 as
   f2 int := 0;
 begin
	n_count := 10;
 end;
/
call p_out6(:p1,:p2);
in
int
3
out
int
1

create or replace procedure p_number2_out6 (f1 in number, n_count out number2)
 as
   f2 int := 0;
 begin
	n_count := 10E50;
 end;
/
call p_number2_out6(:p1,:p2);
in
int
3
out
int
1

-- [7]open cursor table not exists
drop table if exists t_not_exists;
drop procedure if exists p_out7;
create or replace procedure p_out7(result_cur out sys_refcursor)
	as
		strSQL varchar2(1000);
	begin
		strSQL := 'select * from t_not_exists order by f1, f2';
		dbe_output.print_line(strSQL);
		OPEN result_cur for strSQL;
	end p_out7;
/
call p_out7(:p1);
out
int
1

-- [8] out param + put_line + return_result
drop table if exists employees;
drop table if exists locations;
create table employees(employee_id int, first_name varchar2(32), last_name varchar2(32));
insert into employees values(1, 'zhang', 'wei');
insert into employees values(2, 'wang', 'hai');
commit;
create table locations(country_id varchar2(16), city varchar2(16), state_province varchar2(16));
insert into locations values('AU', 'beijing', 'beijing');
insert into locations values('NKG', 'nanjing', 'jiangsu');
commit;

CREATE OR REPLACE PROCEDURE p_out8(c1 in out int, c3 out varchar) 
AS
  c4 SYS_REFCURSOR;
  c5 SYS_REFCURSOR;
  a employees%rowtype;
BEGIN
  c1 := c1 + 1234;
  
  dbe_output.print_line('test return result1');
  
  OPEN c4 FOR
    SELECT first_name, last_name
    FROM employees
    WHERE employee_id > 0
    ORDER BY first_name, last_name;
  DBE_SQL.RETURN_CURSOR(c4);
  
  dbe_output.print_line(c1 || '8899');
  
  c3 := 'outparams' || 'put_line';
  
  OPEN c5 FOR
    SELECT city, state_province
    FROM locations
    WHERE country_id = 'AU'
    ORDER BY city, state_province;
 
  DBE_SQL.RETURN_CURSOR(c5);
  
  dbe_output.print_line(c3);
END;
/

call p_out8(:p1, :p3);
in out
int
1314
out
string
abcde

-- [9] 
set autocommit on
drop table if exists gs_output_test;
create table gs_output_test(f1 int);
create or replace procedure p_out8(a in int, b out int)
as
begin
    b := a;
    insert into gs_output_test values(a);
    insert into gs_output_test values(b);
end p_out8;
/

call p_out8(?,?);
in
int
2
out
int
1

select * from gs_output_test order by f1;

--test anonymous block with pl param
begin
insert into gs_output_test values(:p1);
insert into gs_output_test values(:p2);
commit;
end;
/
in
int
12345
in
int
12346

select * from gs_output_test order by f1;

drop table if exists testProcBind;
create table testProcBind(f1 int, f2 varchar(10), f3 varchar(20));

declare
v1 number(10, 0);
begin
insert into testProcBind(f1,f2,f3) values(?,?,?);
end;
/
in
int
1
in
int
2
in
int
3

select * from testProcBind;

set autocommit off
spool off
