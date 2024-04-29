--
-- testing 'execute immediate'
--

set serveroutput on;

--BEGIN: TEST OUT PARAM
declare
	a int;
	b char(16);
	c varchar(16);
begin
	a := 10;
	b := 'abc';
	c := 'efc';
	execute immediate 'begin :x := 1 + :x; :y := ''aaa''; :z := ''bbb'';end;' using in out a, out b, out c;
	dbe_output.print_line('a='||a); 
	dbe_output.print_line('b='||b);
	dbe_output.print_line('c='||c);
end;
/
--END: TEST OUT PARAM

--test execute immediate(DDL)
drop procedure if exists p_exec_immediate;
create or replace procedure p_exec_immediate(v_type IN int,v_name IN varchar2)
as
sqlstr  varchar2(200);
tabname varchar2(200) := v_name;
begin
	sqlstr:='drop table '||tabname;
	execute immediate sqlstr;
end;
/

drop table if exists t_exec_immediate;
create table t_exec_immediate(f_int1 int);

select f_int1 from t_exec_immediate;

begin
	p_exec_immediate(0, 't_exec_immediate');
end;
/

select f_int1 from t_exec_immediate;

--test execute immediate(DML)
drop procedure if exists p_exec_immediate;
create or replace procedure p_exec_immediate(v_type IN int,v_name IN varchar2)
as
sqlstr varchar2(200);
begin
	sqlstr:='delete from '||v_name;
	execute immediate sqlstr;
end;
/

drop table if exists t_exec_immediate;
create table t_exec_immediate(f_int1 int);

insert into t_exec_immediate(f_int1) values(0);
insert into t_exec_immediate(f_int1) values(1);
commit;
select f_int1 from t_exec_immediate;

begin
	p_exec_immediate(0, 't_exec_immediate');
	commit;
end;
/

select f_int1 from t_exec_immediate;


--test execute immediate(anonymous block)
drop procedure if exists p_exec_immediate;
create or replace procedure p_exec_immediate(v_type IN int,v_name IN varchar2)
AS
  plsql_block VARCHAR2(500);
  plsql_block1 VARCHAR2(500);
  plsql_block2 VARCHAR2(500);
  plsql_block3 VARCHAR2(500);
BEGIN
  plsql_block1 := 'BEGIN ';
  plsql_block2 := 'INSERT INTO '|| v_name ||'(F_INT1) VALUES(123456);commit;';
  plsql_block3 := 'END;';
  plsql_block := plsql_block1 || plsql_block2 || plsql_block3;
	execute immediate plsql_block;
END;
/

drop table if exists t_exec_immediate;
create table t_exec_immediate(f_int1 int);

select f_int1 from t_exec_immediate;

begin
	p_exec_immediate(0, 't_exec_immediate');
end;
/

select f_int1 from t_exec_immediate;


--error,test execute immediate into cluase
drop table if exists t_exec_immediate;
create table t_exec_immediate(f_int1 int,f_char1 char(16),f_varchar1 varchar(16));

create or replace procedure p_exec_immediate(v_type IN int,v_name IN varchar2)
as
sqlstr varchar2(200);
v_count1 int;
v_count2 int;
begin
	sqlstr:='select count(1) from '||v_name;
	execute immediate sqlstr into v_count1,v_count2;
end;
/

begin
	p_exec_immediate(0, 't_exec_immediate');
end;
/

--error,test execute immediate into cluase
drop table if exists t_exec_immediate;
create table t_exec_immediate(f_int1 int,f_char1 char(16),f_varchar1 varchar(16));

create or replace procedure p_exec_immediate(v_type IN int,v_name IN varchar2)
as
sqlstr varchar2(200);
v_count int;
begin
	sqlstr:='delete from '||v_name;
	execute immediate sqlstr into v_count;
end;
/

begin
	p_exec_immediate(0, 't_exec_immediate');
end;
/

--test execute immediate into cluase
drop table if exists t_exec_immediate;
create table t_exec_immediate(f_int1 int,f_char1 char(16),f_varchar1 varchar(16));
insert into t_exec_immediate(f_int1,f_char1,f_varchar1) values(0,'abc','cde');
commit;

create or replace procedure p_exec_immediate(v_type IN int,v_name IN varchar2)
as
sqlstr varchar2(200);
v_count int;
begin
	sqlstr:='select count(1) from '||v_name;
	execute immediate sqlstr into v_count;
	sqlstr:='insert into '||v_name||'(f_int1) values('||v_count||')';
	execute immediate sqlstr;
end;
/

begin
	p_exec_immediate(0, 't_exec_immediate');
	commit;
end;
/

select * from t_exec_immediate order by f_int1,f_char1,f_varchar1;


--test execute immediate into cluase
drop table if exists t_exec_immediate;
create table t_exec_immediate(f_int1 int,f_char1 char(16),f_varchar1 varchar(16));
insert into t_exec_immediate(f_int1,f_char1,f_varchar1) values(1,'bbb','ccc');
insert into t_exec_immediate(f_int1,f_char1,f_varchar1) values(0,'aaa','bbb');
commit;

create or replace procedure p_exec_immediate(v_type IN int,v_name IN varchar2)
as
sqlstr varchar2(200);
f_int1 int;
f_char1 char(16);
f_varchar1 varchar(16);
begin
	sqlstr:='select f_int1,f_char1,f_varchar1 from '||v_name||' order by f_int1 limit 1';
	execute immediate sqlstr into f_int1,f_char1,f_varchar1;
	sqlstr:='insert into '||v_name||'(f_int1,f_char1,f_varchar1) values('||f_int1||','''||f_char1||''','''||f_varchar1||''')';
	execute immediate sqlstr;
end;
/

begin
	p_exec_immediate(0, 't_exec_immediate');
	commit;
end;
/

select * from t_exec_immediate order by f_int1,f_char1,f_varchar1;

--begin: test execute immediate
drop table if exists t_exec_immediate;
create table t_exec_immediate(f_int1 int,f_char1 char(16),f_varchar1 varchar(16));
insert into t_exec_immediate(f_int1,f_char1,f_varchar1) values(1,'bbb','ccc');
insert into t_exec_immediate(f_int1,f_char1,f_varchar1) values(0,'aaa','bbb');
commit;

create or replace function f_exec_immediate(v_name IN varchar)
return varchar
as
begin
	return v_name;
end;
/

begin
   execute immediate 'insert into t_exec_immediate select f_int1 + 10,f_char1,f_varchar1 from t_exec_immediate where f_varchar1 = f_exec_immediate(f_varchar1)';
end;
/

select * from t_exec_immediate order by 1,2,3;
--end: test

--begin:test CURRENT_TIMESTAMP
CREATE OR REPLACE FUNCTION getutcdate
RETURN VARCHAR2
AS
	v_return timestamp;
	v_time_zone number;
	v_sql varchar2(200);
BEGIN
	v_time_zone := to_number(replace(to_char(SESSIONTIMEZONE), ':', '.'));
	v_sql := 'select :1 - interval '''||v_time_zone||''' hour from dual';
	execute immediate v_sql into v_return using CURRENT_TIMESTAMP;
	return v_return;
END;
/

--end

--error(select record count > 1),test execute immediate into cluase
drop table if exists t_exec_immediate;
create table t_exec_immediate(f_int1 int,f_char1 char(16),f_varchar1 varchar(16));
insert into t_exec_immediate(f_int1,f_char1,f_varchar1) values(1,'bbb','ccc');
insert into t_exec_immediate(f_int1,f_char1,f_varchar1) values(0,'aaa','bbb');
commit;

create or replace procedure p_exec_immediate(v_type IN int,v_name IN varchar2)
as
sqlstr varchar2(200);
f_int1 int;
f_char1 char(16);
f_varchar1 varchar(16);
begin
	sqlstr:='select f_int1,f_char1,f_varchar1 from '||v_name;
	execute immediate sqlstr into f_int1,f_char1,f_varchar1;
	sqlstr:='insert into '||v_name||'(f_int1,f_char1,f_varchar1) values('||f_int1||','''||f_char1||''','''||f_varchar1||''')';
	execute immediate sqlstr;
end;
/

begin
	p_exec_immediate(0, 't_exec_immediate');
	commit;
end;
/

select * from t_exec_immediate order by f_int1,f_char1,f_varchar1;


--test execute immediate into cluase(record)
drop table if exists t_exec_immediate;
create table t_exec_immediate(f_int1 int,f_char1 char(16),f_varchar1 varchar(16));
insert into t_exec_immediate(f_int1,f_char1,f_varchar1) values(1,'bbb','ccc');
insert into t_exec_immediate(f_int1,f_char1,f_varchar1) values(0,'aaa','bbb');
commit;

create or replace procedure p_exec_immediate(v_type IN int,v_name IN varchar2)
as
type t_exec_immediate_record is record
(
	f_int1 int,
	f_char1 char(16),
	f_varchar1 varchar(16);
);
sqlstr varchar2(200);
item t_exec_immediate_record;
begin
	sqlstr:='select f_int1,f_char1,f_varchar1 from '||v_name||' order by f_int1 limit 1';
	execute immediate sqlstr into item;
	sqlstr:='insert into '||v_name||'(f_int1,f_char1,f_varchar1) values('||item.f_int1||','''||item.f_char1||''','''||item.f_varchar1||''')';
	execute immediate sqlstr;
end;
/

create or replace procedure p_exec_immediate(v_type IN int,v_name IN varchar2)
as
type t_exec_immediate_record is record
(
	f_int1 int,
	f_char1 char(16),
	f_varchar1 varchar(16)
);
sqlstr varchar2(200);
item t_exec_immediate_record;
begin
	sqlstr:='select f_int1,f_char1,f_varchar1 from '||v_name||' order by f_int1 limit 1';
	execute immediate sqlstr into item;
	sqlstr:='insert into '||v_name||'(f_int1,f_char1,f_varchar1) values('||item.f_int1||','''||item.f_char1||''','''||item.f_varchar1||''')';
	execute immediate sqlstr;
end;
/

begin
	p_exec_immediate(0, 't_exec_immediate');
	commit;
end;
/

select * from t_exec_immediate order by f_int1,f_char1,f_varchar1;


--error:test execute immediate using cluase
declare
	a int;
	b char(16);
	c varchar(16);
begin
	a := 10;
	b := 'abc';
	c := 'efc';
	execute immediate 'begin dbe_output.print_line(:x||:y||:z);end;' using a,b;
end;
/

--error:test execute immediate using cluase
declare
	a int;
	b char(16);
	c varchar(16);
begin
	a := 10;
	b := 'abc';
	c := 'efc';
	execute immediate 'begin dbe_output.print_line(:x||:y);end;' using a,b,c;
end;
/

--error:test execute immediate using cluase
declare
	a int;
	b char(16);
	c varchar(16);
begin
	a := 10;
	b := 'abc';
	c := 'efc';
	execute immediate 'begin dbe_output.print_line(:x||:y||:z||:y);end;' using a,b,c,c;
end;
/

--error:test execute immediate using cluase
declare
	a int;
	b char(16);
	c varchar(16);
begin
	a := 10;
	b := 'abc';
	c := 'efc';
	execute immediate 'begin dbe_output.print_line(:x||:y||:z||:y);end;' using a,b,c,out b;
end;
/

--test execute immediate using cluase
declare
	aa int := 10;
	bb char(16) := 'abc';
	cc varchar(16) := 'efc';
	a int := aa;
	b char(16) := bb;
	c varchar(16) := cc;
begin
	a := 10;
	b := 'abc';
	c := 'efc';
	execute immediate 'begin dbe_output.print_line(:x||:y||:z);end;' using a,b,c;
	execute immediate 'begin dbe_output.print_line(:x||:y||:z||:y);end;' using a,b,c;
  execute immediate 'begin dbe_output.print_line(:x||:y||:z||:w);end;' using a,b,c,b;
	execute immediate 'begin dbe_output.print_line(:x||:y||:z||:y||:x);end;' using a,b,c;
	execute immediate 'begin dbe_output.print_line(:x||:y||:z||:w||:v);select :x + 1 into :x from dual;:y := ''aaa'';:z := ''bbb'';end;' using in out a,in out b,in out c,b,a;
	dbe_output.print_line('a='||a);
	dbe_output.print_line('b='||b);
	dbe_output.print_line('c='||c);
	execute immediate 'select length(:x) + length(:y) from dual' into a using b,c;
	dbe_output.print_line('a='||a);
end;
/

--test execute immediate using cluase
declare
	a int;
	b char(16);
	c varchar(16);
begin
	a := 10;
	b := 'abc';
	c := 'efc';
	execute immediate 'declare xx int;yy varchar(16);begin xx := :x; yy := :y; :z := substr(yy,xx - :x + 2,1); :x := 0;end;' using a,b,out c;
	dbe_output.print_line('a='||a);
	dbe_output.print_line('b='||b);
	dbe_output.print_line('c='||c);
end;
/

--test execute immediate using cluase
drop table if exists t_exec_immediate;
create table t_exec_immediate(f_int1 int,f_char1 char(16),f_varchar1 varchar(16));

create or replace procedure p_exec_immediate(a IN int,b IN varchar2)
as
sqlstr varchar2(200);
v1 int;
begin
	sqlstr:='insert into t_exec_immediate values(:x,:y,:z)';
	execute immediate sqlstr using a,b,b;
	sqlstr:='begin :x := :x + length(:y);end;';
	v1 := a;
	execute immediate sqlstr using in out v1,b;
  sqlstr:='insert into t_exec_immediate values(:x,:y,:z)';
	execute immediate sqlstr using v1,b,b;
end;
/

begin
	p_exec_immediate(10, 'test');
end;
/

select * from t_exec_immediate order by f_int1,f_char1,f_varchar1;
--BEGIN test function return

create or replace function PRE_EXCEPTION_Fun_1210_1(a int,b out int) return int is

BEGIN
b := a;
END;
/
create or replace function PRE_EXCEPTION_Fun_1210_2(c int) return int is

d int;
e int;
BEGIN
d :=  PRE_EXCEPTION_Fun_1210_1(2,e) ;
END;
/

select PRE_EXCEPTION_Fun_1210_2(1);
--END test function return

--PL/SQL using SQL Begin
drop table if exists t_tmp_liu_1219;
create table t_tmp_liu_1219(a1 int);
create or replace function f_tmp_liu_1219(a int default 1)
return int
as
begin
insert into t_tmp_liu_1219 (select a1 from t_tmp_liu_1219 where a1 in (select * from t_tmp_liu_1219 where (a1<1) and rownum <= a)and a1 = 1);
return a;
end;
/
select f_tmp_liu_1219();
select * from t_tmp_liu_1219;
select f_tmp_liu_1219(10);
select * from t_tmp_liu_1219;
drop table t_tmp_liu_1219;
--PL/SQL using SQL End

-- test dynamic_sql+select+fetch
drop table if exists dynamic_sql_select_fetch_t;
create table dynamic_sql_select_fetch_t(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into dynamic_sql_select_fetch_t values(1,'zhangsan','doctor1',10000);
insert into dynamic_sql_select_fetch_t values(2,'zhangsan2','doctor2',10000);
insert into dynamic_sql_select_fetch_t values(123,'zhangsan3','doctor3',10000);
commit;
--create view
create or replace view dynamic_sql_select_fetch_v as select * from dynamic_sql_select_fetch_t;
--functionA
create or replace function dynamic_sql_select_fetch_f (str1 varchar) return int 
is 
mycursor1 sys_refcursor ;
a dynamic_sql_select_fetch_v%rowtype;
begin
 open mycursor1 for select * from dynamic_sql_select_fetch_v;
  fetch mycursor1 into a;
  loop
  if mycursor1%found
    then 
   dbe_output.print_line(a.empno||a.ename);
   fetch mycursor1 into a;
   else 
      exit;
  end if;    
  end loop;
  close mycursor1;
return length(str1);
end;
/

declare
  sql_str varchar(8000);
begin
  sql_str := 'select dynamic_sql_select_fetch_f(ename) from dynamic_sql_select_fetch_t';
  execute immediate sql_str;
end;
/

declare
v1 int;
begin
  select dynamic_sql_select_fetch_f(ename) into v1 from dynamic_sql_select_fetch_t;
end;
/

--end

drop table if exists test_cur;
create table test_cur (a int, b int, c int,d VARCHAR2(10));
insert into test_cur values (1, 2, -2, 'a');
insert into test_cur values (1, 3, -2, 'a');
DECLARE
       v3 int :=1;
       c1 SYS_REFCURSOR;
       CURSOR c2 is select * from test_cur where a = v3;
		v1 int := 100;
		v2 int;
BEGIN
       OPEN c1 FOR 'SELECT :1 FROM DUAL' using v1;
	   fetch c1 into v2;
	   close c1;
	   for i in c2 loop
		dbe_output.print_line(i.b);
	   end loop;
END;
/
drop table test_cur;
--end

set serveroutput off;