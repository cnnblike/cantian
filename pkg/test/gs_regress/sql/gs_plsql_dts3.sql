set serveroutput on;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_plsql_dts3 cascade;
create user gs_plsql_dts3 identified by Lh00420062;
grant all privileges to gs_plsql_dts3;
grant CREATE SESSION CREATE USER CREATE CREATE SESSION CREATE USER CREATE CREATE SESSION CREATE USER CREATE CREATE SESSION CREATE USER to gs_plsql_dts3;

conn gs_plsql_dts3/Lh00420062@127.0.0.1:1611
--1.1 pl_exec core, return cursor without args
drop table if exists table_core_1;
create table table_core_1(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into table_core_1 values(1,'zhangsan','doctor1',10000);
insert into table_core_1 values(2,'zhangsan2','doctor2',20000);
insert into table_core_1 values(3,'zhangsan2','doctor3',30000);

create or replace function fun_core_length(str1 varchar) return int 
is 
mycursor1 sys_refcursor;
a int;
begin
   select empno into a from table_core_1 limit 1;
   dbe_output.print_line('fun_core_length '||a);
return length(str1);
end;
/

create or replace function fun_core_return_cur_noargs return sys_refcursor
is 
cursor1 sys_refcursor;
begin 
   dbe_output.print_line('fun_core_return_cur_noargs print 1');
   dbe_output.print_line('fun_core_return_cur_noargs print 2');
    open cursor1 for select fun_core_length(ename) from table_core_1;
return cursor1;
end;
/
create or replace procedure proc_core_1_1 is 
mycursor1 sys_refcursor ;
begin 
   dbe_output.print_line('proc_core_1_1 print 1');
   dbe_output.print_line('proc_core_1_1 print 2');
   mycursor1 := fun_core_return_cur_noargs();
   dbe_sql.return_cursor(mycursor1);
   dbe_output.print_line('proc_core_1_1 print 3');
   dbe_output.print_line('proc_core_1_1 print 4');
end;
/

exec proc_core_1_1; 

--1.2 pl_exec core, return cursor with args
create or replace function fun_core_return_cur_args(cmp int) return sys_refcursor
is 
cursor1 sys_refcursor;
begin 
   dbe_output.print_line('fun_core_return_cur_args print 1');
   dbe_output.print_line('fun_core_return_cur_args print 2');
   open cursor1 for select fun_core_length(ename) from table_core_1 where empno > cmp;
return cursor1;
end;
/
create or replace procedure proc_core_1_2 is 
mycursor1 sys_refcursor ;
begin 
   dbe_output.print_line('proc_core_1_2 print 3');
   dbe_output.print_line('proc_core_1_2 print 4');
   mycursor1 := fun_core_return_cur_args(1);
   dbe_sql.return_cursor(mycursor1);
   dbe_output.print_line('proc_core_1_2 print 3');
   dbe_output.print_line('proc_core_1_2 print 4');
end;
/

exec proc_core_1_2; 

select fun_core_return_cur_args(1) from dual;

--new problem, 0130
create or replace function fun_core_return_cur_args2 return int
is 
cursor1 sys_refcursor;
var varchar(20);
begin 
    cursor1 := fun_core_return_cur_args(1);
    loop
    exit when cursor1%notfound;
    fetch cursor1 into var;
    dbe_output.print_line(var);
    end loop;
return length(var);
end;
/

select fun_core_return_cur_args2();

drop table if exists DEPENDENCY_COMPILE_001_TAB_01;
create table DEPENDENCY_COMPILE_001_TAB_01(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into DEPENDENCY_COMPILE_001_TAB_01 values(1,'zhangsan','doctor1',10000);
insert into DEPENDENCY_COMPILE_001_TAB_01 values(2,'zhangsan2','doctor2',10000);
insert into DEPENDENCY_COMPILE_001_TAB_01 values(123,'zhangsan3','doctor3',10000);
insert into DEPENDENCY_COMPILE_001_TAB_01 values(11,'zhansi','doctor1',10000);
insert into DEPENDENCY_COMPILE_001_TAB_01 values(22,'lisiabc','doctor2',10000);
insert into DEPENDENCY_COMPILE_001_TAB_01 values(33,'zhangwu123','doctor3',10000);
insert into DEPENDENCY_COMPILE_001_TAB_01 values(10,'abc','worker',9000);
insert into DEPENDENCY_COMPILE_001_TAB_01 values(76,'ZHANGSAN','leader',20000);
commit;
--create view
create or replace view DEPENDENCY_COMPILE_001_VIEW_01 as select * from DEPENDENCY_COMPILE_001_TAB_01;
--functionA
create or replace function DEPENDENCY_COMPILE_001_FUN_01 (str1 varchar) return int 
is 
mycursor1 sys_refcursor ;
a DEPENDENCY_COMPILE_001_VIEW_01%rowtype;
begin
 open mycursor1 for select * from DEPENDENCY_COMPILE_001_VIEW_01;
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

--functionB
create or replace function DEPENDENCY_COMPILE_001_FUN_02 (str1 varchar) return sys_refcursor
is 
cursor1 sys_refcursor;
begin
open cursor1 for select DEPENDENCY_COMPILE_001_FUN_01(ename) from DEPENDENCY_COMPILE_001_TAB_01;
return cursor1;
end;
/

select DEPENDENCY_COMPILE_001_FUN_02('a') from dual;

conn sys/Huawei@123@127.0.0.1:1611

--DTS2019012807698
drop table if exists FVT_TRIGGER_TABLE_yf_044;
create table FVT_TRIGGER_TABLE_yf_044 (id int,name varchar(50),sal int);
insert into FVT_TRIGGER_TABLE_yf_044 values(10,'xg',5000);
insert into FVT_TRIGGER_TABLE_yf_044 values(20,'xig',8000);
insert into FVT_TRIGGER_TABLE_yf_044 values(30,'xia',5800);
insert into FVT_TRIGGER_TABLE_yf_044 values(40,'xing',6600);
insert into FVT_TRIGGER_TABLE_yf_044 values(50,'xiwsg',7000); 
drop table if exists FVT_TRIGGER_TABLE_yf_045;
create table FVT_TRIGGER_TABLE_yf_045 (id int,name varchar(50),sal int);
insert into FVT_TRIGGER_TABLE_yf_045 values(50,'xiwsg',7000);
 
set serveroutput on
 
create or replace trigger FVT_TRIGGER_yf_045 after update on FVT_TRIGGER_TABLE_yf_045 for each row as
 a int;
 b int;
 begin
 b:=0;
 loop 
 b:=b+3;
 if b <4 then
 select id into a from FVT_TRIGGER_TABLE_yf_044 where rowid = 123;
 dbe_output.print_line('b='||b);
 end if;
 end loop;
 exception
	 when SYS_INVALID_ROWID then
	  dbe_output.print_line('error: SYS_INVALID_ROWID');
	   dbe_output.print_line(SQL_ERR_CODE || ' error ' || SQL_ERR_MSG); 
	   declare
	   c1 sys_refcursor;
       a int;	   
		begin
		 open c1 for select* from FVT_TRIGGER_TABLE_yf_044;
		  fetch c1 into a;
		   close c1;
	exception
	  when  ROWTYPE_MISMATCH then 
		dbe_output.print_line('error: ROWTYPE_MISMATCH');
         dbe_output.print_line(SQL_ERR_CODE || ' error ' || SQL_ERR_MSG);
		  declare
		  a int;
		  b int;
		  c varchar(30);
		  d int;
		  begin
	        EXECUTE IMMEDIATE  'BEGIN
			 :x := 1; :y := 2; :z :=3;
			   END;'
			     USING out a,out b,out c,out d;
			      dbe_output.print_line('a='||a);
			       dbe_output.print_line('b='||b);
                    dbe_output.print_line('c='||c);  
	         exception 
	            when  PROGRAM_ERROR then
				  dbe_output.print_line('error: PROGRAM_ERROR');
				   dbe_output.print_line(SQL_ERR_CODE || ' error ' || SQL_ERR_MSG);
	      end;
	end;
 end;
 /

update FVT_TRIGGER_TABLE_yf_045 set name='ds' where id=50;
drop table if exists CURSOR_FUNCTION_001_TAB_01;
create table CURSOR_FUNCTION_001_TAB_01(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into CURSOR_FUNCTION_001_TAB_01 values(1,'zhangsan','doctor1',10000);
insert into CURSOR_FUNCTION_001_TAB_01 values(2,'zhangsan2','doctor2',10000);
insert into CURSOR_FUNCTION_001_TAB_01 values(123,'zhangsan3','doctor3',10000);
insert into CURSOR_FUNCTION_001_TAB_01 values(11,'zhansi','doctor1',10000);
insert into CURSOR_FUNCTION_001_TAB_01 values(22,'lisiabc','doctor2',10000);
insert into CURSOR_FUNCTION_001_TAB_01 values(33,'zhangwu123','doctor3',10000);
insert into CURSOR_FUNCTION_001_TAB_01 values(10,'abc','worker',9000);
insert into CURSOR_FUNCTION_001_TAB_01 values(76,'ZHANGSAN','leader',20000);
commit;

--create view
create or replace view CURSOR_FUNCTION_001_VIEW_01 as select * from CURSOR_FUNCTION_001_TAB_01;
--functionA
create or replace function CURSOR_FUNCTION_001_FUN_01 (str1 varchar) return int 
is 
mycursor1 sys_refcursor;
a int;
begin
 select empno into a from CURSOR_FUNCTION_001_VIEW_01;
   dbe_output.print_line(a);
   exception
   when  TOO_MANY_ROWS  then
   begin
      select empno into a from CURSOR_FUNCTION_001_VIEW_01 limit 1;
     dbe_output.print_line(a);
     return length(str1);
   end;
end;
/

create or replace function CURSOR_FUNCTION_001_FUN_02 (str1 varchar) return sys_refcursor
is 
cursor1 sys_refcursor;
begin
open cursor1 for select CURSOR_FUNCTION_001_FUN_01(ename) from CURSOR_FUNCTION_001_TAB_01;
return cursor1;
end;
/

create or replace function CURSOR_FUNCTION_001_FUN_02_3 (str1 varchar) return sys_refcursor
is 
cursor1 sys_refcursor;
begin
open cursor1 for select CURSOR_FUNCTION_001_FUN_01('') from CURSOR_FUNCTION_001_TAB_01;
return cursor1;
end;
/

create or replace procedure CURSOR_FUNCTION_001_PROC_01(P_TNAME varchar) is 
mycursor1 sys_refcursor ;
a varchar(100);
begin
   a:=P_TNAME;
   mycursor1 := CURSOR_FUNCTION_001_FUN_02('aa');
   dbe_sql.return_cursor(mycursor1);
   dbe_output.print_line(a);
end;
/

CREATE OR REPLACE PROCEDURE CURSOR_FUNCTION_001_PROC_02 (x BOOLEAN) AS
mycursor1 sys_refcursor ;
mycursor2 sys_refcursor ;
v_int int;
v_int_2 int;
BEGIN
  sys.CURSOR_FUNCTION_001_PROC_01('exec CURSOR_FUNCTION_001_PROC_01');
  IF x THEN
    dbe_output.print_line('x is true');
  END IF;
  mycursor1 := CURSOR_FUNCTION_001_FUN_02_3('aa');
  mycursor2 := CURSOR_FUNCTION_001_FUN_02('cantian!@#$% ');
  fetch mycursor1 into v_int;
  loop
  if mycursor1%found then 
        loop
        fetch mycursor2 into v_int_2;  --core
        if mycursor2%found then 
            dbe_output.print_line('mycursor2='||v_int_2);
        else 
        exit;
        end if;
        end loop;
   dbe_output.print_line('mycursor1='||v_int);
   fetch mycursor1 into v_int;
  else  
    exit;
  end if;
  end loop;
END;
/

call  CURSOR_FUNCTION_001_PROC_02('T');

select length(space(423.999));
select t1.name, t2.event from v$sysstat t1,v$system_event t2 
where UPPER(t1.NAME)=UPPER('sql execution total time') and UPPER(t2.EVENT)=UPPER('db file sequential read') and t1.value > t2.TIME_WAITED_MIRCO;

declare
a int :=1;
begin
<<'aaa'>>
dbe_output.print_line(a);
end;
/

declare
a int :=1;
begin
goto "aaa";
<<"aaa">>
dbe_output.print_line(a);
end;
/

drop table if exists tab_test_2;
create table tab_test_2(a int);
CREATE OR REPLACE SYNONYM syn_tab_1 FOR tab_test_2;
CREATE OR REPLACE TRIGGER TRIG_SYN_5 BEFORE INSERT OR UPDATE on syn_tab_1
BEGIN
INSERT INTO tab_test_2 VALUES(8);
END;
/
insert into syn_tab_1 values(20);
select trig_table from SYS_PROCS where type='T' and name='TRIG_SYN_5';

select case when count(accumulative) > 0 then 1 end from v$system;

drop user if exists gs_plsql_dts3 cascade;

-- DTS2019022704715
conn sys/Huawei@123@127.0.0.1:1611

drop user if exists DTS2019022704715 cascade;
create user DTS2019022704715 identified by Root1234;
grant connect, resource to DTS2019022704715;

conn DTS2019022704715/Root1234@127.0.0.1:1611
-- no privileges
create or replace function CURSOR_FUNCTION_001_FUN_03(str1 varchar) return sys_refcursor
is
    cursor1 sys_refcursor;
begin
    open cursor1 for select sys.CURSOR_FUNCTION_001_FUN_01(ename) from sys.CURSOR_FUNCTION_001_TAB_01;
    return cursor1;
end;
/

-- succeed
conn sys/Huawei@123@127.0.0.1:1611

create or replace function DTS2019022704715.CURSOR_FUNCTION_001_FUN_03(str1 varchar) return sys_refcursor
is
    cursor1 sys_refcursor;
begin
    open cursor1 for select sys.CURSOR_FUNCTION_001_FUN_01(ename) from sys.CURSOR_FUNCTION_001_TAB_01;
    return cursor1;
end;
/

conn DTS2019022704715/Root1234@127.0.0.1:1611
-- no privileges
create or replace function CURSOR_FUNCTION_001_FUN_03(str1 varchar) return sys_refcursor
is
    cursor1 sys_refcursor;
begin
    open cursor1 for select sys.CURSOR_FUNCTION_001_FUN_01(ename) from sys.CURSOR_FUNCTION_001_TAB_01;
    return cursor1;
end;
/

conn sys/Huawei@123@127.0.0.1:1611
drop user DTS2019022704715 cascade;
create user plsql_dts_u1 identified by 'wW00174302!';
grant all privileges to plsql_dts_u1;
grant dba to plsql_dts_u1;
grant create session,create table,CREATE PROCEDURE,EXECUTE ANY PROCEDURE,
READ ANY TABLE,CREATE TRIGGER ,INSERT ANY TABLE to plsql_dts_u1;
create user plsql_dts_u2 identified by 'wW00174302!';
grant all privileges to plsql_dts_u2; 
grant dba to plsql_dts_u2;
grant create session,create table,CREATE PROCEDURE,EXECUTE ANY PROCEDURE,
READ ANY TABLE,CREATE TRIGGER ,INSERT ANY TABLE to plsql_dts_u2;

drop table if exists plsql_dts_u1.t1;
drop table if exists plsql_dts_u2.t1;
create table plsql_dts_u1.t1(a int);
create table plsql_dts_u2.t1(a int);
insert into plsql_dts_u1.t1 values(1);
insert into plsql_dts_u2.t1 values(2);
commit;

drop procedure if exists plsql_dts_u1.t1;
drop procedure if exists plsql_dts_u2.t1;

conn plsql_dts_u1/wW00174302!@127.0.0.1:1611
create or replace procedure plsql_dts_u1.p1 
as
b int;
begin
  select a into b from t1;
  dbe_output.print_line(b);
end;
/

create or replace procedure plsql_dts_u2.p1 
as
b int;
begin
  select a into b from t1;
  dbe_output.print_line(b);
end;
/

conn plsql_dts_u2/wW00174302!@127.0.0.1:1611
set serveroutput on
begin
plsql_dts_u1.p1;
end;
/

begin
plsql_dts_u2.p1;
end;
/

create or replace procedure test_p1(i int)
is
a int;
begin
if(i>0) then
test_p1(i-1);
end if;
end;
/
create or replace procedure test_p2(i int)
is
a int;
begin
if(i>0) then
test_p1(i-1);
end if;
end;
/
conn sys/Huawei@123@127.0.0.1:1611
grant select on sys.SYS_PROCS to plsql_dts_u2;
conn plsql_dts_u2/wW00174302!@127.0.0.1:1611
select status from sys.SYS_PROCS where name=upper('test_p2');
create or replace procedure test_p1(i int)
is
a int;
begin
if(i>0) then
test_p2(i-1);
end if;
end;
/
select status from sys.SYS_PROCS where name=upper('test_p2');

-------------- BEGIN test for loop index ---------------------------
drop table if exists liu_tab;
create table liu_tab(a int , c varchar(50));
insert into liu_tab values(1,'liu');
insert into liu_tab values(2,'liu');
insert into liu_tab values(3,'test');

create or replace function liu_func (a int) return int
is 
begin
return a;
end;
/

declare
begin
	for i in i..10 loop
        dbe_output.print_line(i);
	end loop;
end;
/

declare
begin
	for i in liu_func(i)..10 loop
        dbe_output.print_line(i);
	end loop;
end;
/

begin
  for i in (select i+2 from dual) loop
    null;
  end loop;
end;
/

begin
  for i in (select a from liu_tab where a > i) loop
    dbe_output.print_line('here wrong');
  end loop;
end;
/

BEGIN  
    execute immediate '
    declare
    begin
        for i in i..10 loop
        dbe_output.print_line(i);
    end loop;
    end;'; 
END;
/

declare
cursor a is select 1 from sys_dummy;
begin
for a in a loop
dbe_output.print_line(1);
end loop;
end;
/
-------------- END test for loop index ---------------------------

declare
v_refcur2 SYS_REFCURSOR;
begin
OPEN v_refcur2 FOR SELECT 1 FROM dual;
OPEN v_refcur2 FOR dbe_sql.return_cursor(v_refcur2);
end;
/

declare
v_refcur2 SYS_REFCURSOR;
begin
OPEN v_refcur2 FOR select 1 from dual;
dbe_sql.return_cursor(v_refcur2, null);
end;
/

declare
v_refcur2 SYS_REFCURSOR;
begin
OPEN v_refcur2 FOR select 1 from dual;
dbe_sql.return_cursor(v_refcur2, '');
end;
/

declare
v_refcur2 SYS_REFCURSOR;
s varchar(100);
o int;
begin
s := 'select 100 from dual';
OPEN v_refcur2 FOR to_char(s);
while v_refcur2%found loop
fetch v_refcur2 into o;
dbe_output.print_line(o);
end loop;
close v_refcur2;
end;
/

--test get_lock, release_lock
declare
res bigint :=0;
acc bigint :=0;
begin
for i in 1..10000 loop
    select get_lock(to_char(i),1) into res from dual;
    acc := acc+res;
    select release_lock(to_char(i)) into res from dual;
    acc := acc+res;
end loop;
dbe_output.print_line('acc = '||acc);
end;
/


drop table if exists meger_into_bracket;
drop table if exists meger_into_bracket_cmp;
create table meger_into_bracket(a int, c varchar(100));
insert into meger_into_bracket values(1,'liu');
insert into meger_into_bracket values(2,'zhang');
create table meger_into_bracket_cmp(a int, c varchar(100));
insert into meger_into_bracket_cmp values(2,'liu');
insert into meger_into_bracket_cmp values(3,'li');

declare
begin
merge into meger_into_bracket t1
using meger_into_bracket_cmp t2
on (t1.a = t2.a)
when matched then update
set t1.c = (select c from meger_into_bracket_cmp where a=3 limit 1);
end;
/
select * from meger_into_bracket;


declare
  type type_name is record(c_id int,c_num numeric(12,2),c_vchars varchar(32),c_vchar_c varchar2(3000 char),c_vchar_b varchar2(3000 byte),c_ts timestamp,c_blob blob,c_clob clob);
  rd type_name;
  c2 sys_refcursor;
begin
   open c2 for select 1,1000.56,'AA'||'BAR1BARBAR',lpad('1234567890abcdfe',3000,'abc1d2fb456cdef'),lpad('1234567890abcdfe',3000,'abc1d2fb456cdef'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),lpad('123abc',3000,'abc'),lpad('12345abcde',32767,'abcde') from dual;
   fetch c2 into rd;
   close c2;
   dbe_output.print_line('result is '||rd.c_id);
   dbe_output.print_line('result is '||length(rd.c_clob));
end;
/

CREATE OR REPLACE PROCEDURE Zenith_Test_004_inout_char(param1 in out char) 
IS
    tmp varchar2(20) :='12345678';
begin
        param1:=tmp||'A';
end Zenith_Test_004_inout_char;
/

CREATE OR REPLACE PROCEDURE Zenith_Test_004_inout_varchar(param1 in out varchar) 
IS
    tmp varchar2(20) :='12345678';
begin
        param1:=tmp||'A';
end Zenith_Test_004_inout_varchar;
/

CREATE OR REPLACE PROCEDURE Zenith_Test_004_out_char(param1 out char) 
IS
    tmp varchar2(20) :='12345678';
begin
        param1:=tmp||'A';
end Zenith_Test_004_out_char;
/

CREATE OR REPLACE PROCEDURE Zenith_Test_004_out_varchar(param1 out varchar) 
IS
    tmp varchar2(20) :='12345678';
begin
        param1:=tmp||'A';
end Zenith_Test_004_out_varchar;
/

Declare
    v_char1 char(9) :='A';
    v_char2 char(9) :='B';
    v_varchar1 varchar(9) :='C';
    v_varchar2 varchar(9) :='D';
begin 
    Zenith_Test_004_out_char(v_char1);
    Zenith_Test_004_inout_char(v_char2);
    Zenith_Test_004_out_varchar(v_varchar1);
    Zenith_Test_004_inout_varchar(v_varchar2);
    dbe_output.print_line(v_char1);
    dbe_output.print_line(v_char2);
    dbe_output.print_line(v_varchar1);
    dbe_output.print_line(v_varchar2);
end;
/

create or replace function test_arg_duplicate_f(a int, a varchar) return int
as
begin
null;
return 1;
end;
/
create or replace procedure test_arg_duplicate_p(a int, a varchar)
as
begin
null;
end;
/
drop table if exists test_sql_t;
create table test_sql_t(a int);
create or replace trigger TEST_TRIGGER before 
insert or delete or update on test_sql_t for each row 
begin
  :NEW.A := 10; 
  dbe_output.print_line(:New."A");
  :NEW.A := 20; 
  dbe_output.print_line(:NEW.a);
end;
/

insert into test_sql_t values (1);
select * from test_sql_t;
update test_sql_t set a = 100;
delete from test_sql_t;

drop table if exists PACK_BODY_FUN_SELECT_002_TAB_01;
create table PACK_BODY_FUN_SELECT_002_TAB_01(id int,name varchar2(100));
insert into PACK_BODY_FUN_SELECT_002_TAB_01 values(1,'jim'),(1,'marry'),(9,'sfdsfdf');
commit;
CREATE OR REPLACE PACKAGE PACK_BODY_FUN_SELECT_002
IS
FUNCTION test_outf(p1 int,p2 int)   return int ;
procedure proc1(canshu1 int,canshu2 int) ;
end;
/
CREATE OR REPLACE PACKAGE body PACK_BODY_FUN_SELECT_002
IS
function test_outf(p1 int,p2 int)   return int is 
begin
return p1-p2;
end;
procedure proc1(canshu1 int,canshu2 int) is 
c int;
begin
c:=test_outf(canshu1,canshu2);
dbe_output.print_line(c);
end;
END PACK_BODY_FUN_SELECT_002;
/
exec PACK_BODY_FUN_SELECT_002.proc1(4,1);
CREATE OR REPLACE PACKAGE body PACK_BODY_FUN_SELECT_002
IS
function test_outf(p1 int,p2 int)   return int is 
begin
return p1-p2;
end;
procedure proc1(canshu1 int,canshu2 int) is 
cur1 sys_refcursor;
begin
open cur1 for select * from PACK_BODY_FUN_SELECT_002_TAB_01 where id < test_outf(canshu1,canshu2);
dbe_sql.return_cursor(cur1);
end;
END PACK_BODY_FUN_SELECT_002;
/
select PACK_BODY_FUN_SELECT_002.test_outf(3,1);
select PACK_BODY_FUN_SELECT_002.test_outf(null,'');
select PACK_BODY_FUN_SELECT_002.test_outf(1,3);
exec PACK_BODY_FUN_SELECT_002.proc1(3,1);
exec PACK_BODY_FUN_SELECT_002.proc1(null,'');
exec PACK_BODY_FUN_SELECT_002.proc1(1,3);

drop table if exists BODY_DML_002_TAB_01;
create table BODY_DML_002_TAB_01(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into BODY_DML_002_TAB_01 values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
insert into BODY_DML_002_TAB_01 values(1,'zhansi','doctor1',10000),(2,'lisiabc','doctor2',10000),(123,'zhangwu123','doctor3',10000);
insert into BODY_DML_002_TAB_01 values(10,'abc','worker',9000);
insert into BODY_DML_002_TAB_01 values(716,'ZHANGSAN','leader',20000);

drop table if exists BODY_DML_002_TAB_02;
create table BODY_DML_002_TAB_02(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into BODY_DML_002_TAB_02 values(100,'marry','teacher',9600);
insert into BODY_DML_002_TAB_02 values(716,'ZHANGSAN','leader',20000);
commit;

declare
     c int :=100;
begin
delete from BODY_DML_002_TAB_01 using (select * from BODY_DML_002_TAB_01 where empno < c) as T2 left outer join BODY_DML_002_TAB_01 on BODY_DML_002_TAB_01.sal=T2.sal;
end;
/

select count(1) from BODY_DML_002_TAB_01;

drop table BODY_DML_002_TAB_01;
drop table BODY_DML_002_TAB_02;

conn sys/Huawei@123@127.0.0.1:1611
drop user plsql_dts_u1 cascade;
drop user plsql_dts_u2 cascade;

--DTS2019080508002
conn sys/Huawei@123@127.0.0.1:1611

drop user if exists DTS2019080508002 cascade;
create user DTS2019080508002 identified by Root1234;
grant all privileges to DTS2019080508002;

conn DTS2019080508002/Root1234@127.0.0.1:1611

drop table if exists PROC_DML_KEY_001_TAB_01;
create table PROC_DML_KEY_001_TAB_01(empno int,ename varchar(10),job varchar(10) ,sal integer);

drop table if exists PROC_DML_KEY_001_TAB_02;
create table PROC_DML_KEY_001_TAB_02(empno int primary key ,ename varchar(10),job varchar(10) ,sal integer);

CREATE OR REPLACE PACKAGE PACK_PROC_DML_KEY_001
IS
FUNCTION PACK_PROC_DML_KEY_001_FUN_01(p1 int,p2 int,p3 number)
RETURN int;

procedure PACK_PROC_DML_KEY_001_PRO_01(p_no int,p_sal integer);
END PACK_PROC_DML_KEY_001;
/

CREATE OR REPLACE PACKAGE body PACK_PROC_DML_KEY_001
IS
function PACK_PROC_DML_KEY_001_FUN_01(p1 int,p2 int,p3 number)   return int is 
c int;
begin
c:=mod(p1,p2)+trunc(p3);
insert into PROC_DML_KEY_001_TAB_02 values(716,'insert','leader',c);
return c;
end;
procedure PACK_PROC_DML_KEY_001_PRO_01(p_no int,p_sal integer)   is
begin
insert into PROC_DML_KEY_001_TAB_02 T2 (empno,ename) select * from  PROC_DML_KEY_001_TAB_01; 
commit;
end;
END PACK_PROC_DML_KEY_001;
/

drop table PROC_DML_KEY_001_TAB_01;
drop table PROC_DML_KEY_001_TAB_02;
drop package PACK_PROC_DML_KEY_001;

create table tt1_dts3(a1 int);
insert into tt1_dts3 values(10),(20);
commit;
create or replace procedure out_cursor(o1 OUT sys_refcursor)
is
begin
open o1 for select a1 from tt1_dts3;
end;
/
create or replace procedure out_cursor1(o1 OUT sys_refcursor)
is
begin
out_cursor(o1);
end;
/
create or replace procedure out_cursor2(o1 OUT sys_refcursor)
is
res sys_refcursor;
begin
out_cursor1(res);
o1 := res;
end;
/

create or replace function out_cursor_f return sys_refcursor
is
res sys_refcursor;
begin
out_cursor2(res);
return res;
end;
/
create or replace function out_cursor_f2 return sys_refcursor
is
res sys_refcursor;
begin
out_cursor2(res);
return res;
end;
/
create or replace function out_cursor_f3 return sys_refcursor
is
res sys_refcursor;
begin
out_cursor2(res);
out_cursor2(res);
return res;
end;
/

select out_cursor_f1;
select out_cursor_f2;
select out_cursor_f3;
select out_cursor_f1;
select out_cursor_f2;
select out_cursor_f3;

conn sys/Huawei@123@127.0.0.1:1611
drop user DTS2019080508002 cascade;

--DTS2019080608260
conn sys/Huawei@123@127.0.0.1:1611

drop user if exists DTS2019080608260 cascade;
create user DTS2019080608260 identified by Root1234;
grant all privileges to DTS2019080608260;

conn DTS2019080608260/Root1234@127.0.0.1:1611

drop table if exists FVT_FUCTION_DECODE_TABLE_001;
create table FVT_FUCTION_DECODE_TABLE_001(COL_1 NUMBER(6) not null, COL_2 VARCHAR2(200));
INSERT INTO FVT_FUCTION_DECODE_TABLE_001 (COL_1, COL_2) values (198, 'wangyin');
INSERT INTO FVT_FUCTION_DECODE_TABLE_001 (COL_1, COL_2) values (199, 'hekaiping');
INSERT INTO FVT_FUCTION_DECODE_TABLE_001 (COL_1, COL_2) values (200, 'lirui');

drop table if exists FVT_FUCTION_DECODE_TABLE_002;
create table FVT_FUCTION_DECODE_TABLE_002(COL_1 NUMBER(6) not null, COL_2 VARCHAR2(200));

set serveroutput on;
declare
v_count_01 int;
BEGIN
EXECUTE IMMEDIATE 'INSERT INTO FVT_FUCTION_DECODE_TABLE_002 (COL_1,COL_2) SELECT COL_1,COL_2 FROM FVT_FUCTION_DECODE_TABLE_001 WHERE DECODE(COL_1, :v1, 1, :v2, 2, 3)>1' USING 198,199;
select 
count(1) into v_count_01 
from 
(
select COL_1,COL_2 from FVT_FUCTION_DECODE_TABLE_001 where DECODE(COL_1,198, 1, 199, 2, 3)>1;
except 
select COL_1,COL_2 from FVT_FUCTION_DECODE_TABLE_002
);
dbe_output.print_line(v_count_01);
EXCEPTION
WHEN NO_DATA_FOUND THEN dbe_output.print_line('NO_DATA_FOUND');
END;
/
drop table FVT_FUCTION_DECODE_TABLE_001;
drop table FVT_FUCTION_DECODE_TABLE_002;
declare
v_sql            varchar2(32765);
v_unit               number;
v_res  int;
begin
v_unit:=1;
v_sql:='select lag(:unit, 1) over(order by 1) from dual';                  
execute immediate v_sql into v_res using v_unit;    
dbe_output.print_line(v_res);
end;
/

-- DTS2019111106550 start
drop table if exists auto_trans_test_t;
create table auto_trans_test_t(id int,name varchar(20));
insert into auto_trans_test_t values(3,'test');
CREATE OR REPLACE TRIGGER huawei_Test
BEFORE INSERT OR DELETE OR UPDATE ON auto_trans_test_t
for each row
declare
a_id_1 number;
 PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
select t.id into a_id_1 from auto_trans_test_t t where t.id = :new.id;
dbe_output.print_line('success! id: ' || a_id_1);
END huawei_Test;
/
update auto_trans_test_t t set t.name = 'qqqqqq' where t.id = 3;
select * from auto_trans_test_t;

drop table if exists auto_trans_test_t;
create table auto_trans_test_t(id int,name varchar(20));
insert into auto_trans_test_t values(3,'test');
CREATE OR REPLACE TRIGGER huawei_Test
BEFORE INSERT OR DELETE OR UPDATE ON auto_trans_test_t
for each row
declare
 PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
insert into auto_trans_test_t values(4,'test');
commit;
END huawei_Test;
/
update auto_trans_test_t t set t.name = 'qqqqqq' where t.id = 3;

drop table if exists auto_trans_test_t;
create table auto_trans_test_t(id int,name varchar(20));
insert into auto_trans_test_t values(3,'test');
CREATE OR REPLACE TRIGGER huawei_Test
BEFORE INSERT OR DELETE OR UPDATE ON auto_trans_test_t
for each row
declare
 PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
update auto_trans_test_t t set t.name = 'qqqqqq' where t.id = 3;
commit;
exception
 when others then
  SYS.dbe_output.print_line(SQL_ERR_CODE || ': Found transaction deadlock in session');
END;
/
update auto_trans_test_t t set t.name = 'qqqqqq' where t.id = 3;

drop table if exists auto_trans_test_t;
create table auto_trans_test_t(id int,name varchar(20));
insert into auto_trans_test_t values(3,'test');
CREATE OR REPLACE TRIGGER huawei_Test
BEFORE INSERT OR DELETE OR UPDATE ON auto_trans_test_t
for each row
declare
 PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
delete auto_trans_test_t t where t.id = 3;
commit;
exception
 when others then
  SYS.dbe_output.print_line(SQL_ERR_CODE || ': Found transaction deadlock in session');
END;
/
update auto_trans_test_t t set t.name = 'qqqqqq' where t.id = 3;

drop table if exists auto_trans_test_t;
create table auto_trans_test_t(id int,name varchar(20));
insert into auto_trans_test_t values(3,'test');
CREATE OR REPLACE function huawei_Test_func(a int) return int
is
a_id_1 number;
 PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
select t.id into a_id_1 from auto_trans_test_t t where t.id = a;
insert into auto_trans_test_t values(4,'test');
update auto_trans_test_t t set t.name = 'qqqqqq' where t.id = 4;
delete auto_trans_test_t t where t.id = 4;
commit;
return a_id_1;
END huawei_Test_func;
/
update auto_trans_test_t t set t.name = 'qqqqqq' where t.id = huawei_Test_func(3);
select * from auto_trans_test_t;
-- DTS2019111106550 end

conn sys/Huawei@123@127.0.0.1:1611
drop user DTS2019080608260 cascade;

--DTS2019091105554
create or replace procedure indexes_test()
IS
rec_indexes dba_indexes%rowtype;
BEGIN
null;
END;
/

--DTS2019111302705
drop table if exists fvt_04;
create table fvt_04 (a bigint, b clob,c blob, d date, e boolean, f  interval day(7) to second, g VARCHAR2(100) check(g IS JSON),h decimal(10,1));
insert into fvt_04 values(1,'$#$%#$#$','110',to_date('01-07-2019','dd-mm-yyyy'),'true','1231 12:3:4.1234','{"classes": [{"name":"class 1", "size":"50"}]}',1.23);
insert into fvt_04 values(1,'$#$%#$#$','110',to_date('01-07-2019','dd-mm-yyyy'),'true','1231 12:3:4.1234','{"classes": [{"name":"class 1", "size":"50"}]}',1.23);
insert into fvt_04 values(1,'$#$%#$#$','110',to_date('01-07-2019','dd-mm-yyyy'),'true','1231 12:3:4.1234','{"classes": [{"name":"class 1", "size":"50"}]}',1.23);
insert into fvt_04 values(1,'$#$%#$#$','1010',to_date('01-07-2019','dd-mm-yyyy'),'true','1231 12:3:4.1234','{"classes": [{"name":"class 1", "size":"50"}]}',1.23);

create or replace type varray04 force is varray(4) of clob;
/
CREATE OR REPLACE TYPE varray4 force is varray(4) of clob;
/

create or replace procedure fvt_proc_001 (aa4 varray04,bb4 out varray4) is
type mycurtp is  ref cursor;
cursorv4  mycurtp;
sys_cur4  sys_refcursor;
cursorv04  mycurtp;
sys_cur04  sys_refcursor;
var4 varray4 := varray4();
type  record04 is record(
a varchar2(100),
b number(10,1),
c blob
);
redd04  record04;
begin
select b bulk collect into var4 from fvt_04 where b = aa4(1);
for i in 1..var4.count() loop
	dbe_output.print_line(var4(i));
end loop;

select b,h,c into redd04 from fvt_04 where b = aa4(1) and c = aa4(2);
for i in 1..4 loop
	dbe_output.print_line(redd04.a||'-'||redd04.b||'-'||redd04.c);
end loop;

open  sys_cur4 for  select b from fvt_04 where b = aa4(1) ;
cursorv4 := sys_cur4;
bb4 := var4;
loop
fetch cursorv4 bulk collect  into var4;
exit when cursorv4%notfound;
for i in 1..var4.count() loop
	dbe_output.print_line(var4(i));
end loop;
end loop;
close cursorv4;
open sys_cur04 for select b,h,c from fvt_04 where b = aa4(1);
cursorv04 := sys_cur04;
loop
fetch cursorv04 into redd04;
exit when cursorv04%notfound;
dbe_output.print_line('1'||cursorv04%rowcount||'2 +'||redd04.a||'+'||redd04.b||'+'||redd04.c);
end loop;

end;
/

declare
dd varray4;
a varray04;
begin
a := varray04('$#$%#$#$', '1010', '$#$%#$#$', '$#$%#$#$');
fvt_proc_001(a,dd);
end;
/

drop table if exists fvt_08;
create table fvt_08 (a bigint, b varchar(100),c blob, d date, e boolean, f  interval day(7) to second, g VARCHAR2(100) check(g IS JSON),h decimal(10,1));
insert into fvt_08 values(1,'$#$%#$#$','110',to_date('01-07-2019','dd-mm-yyyy'),'true','1231 12:3:4.1234','{"classes": [{"name":"class 1", "size":"50"}]}',1.23);
insert into fvt_08 values(1,'$#$%#$#$','110',to_date('01-07-2019','dd-mm-yyyy'),'true','1231 12:3:4.1234','{"classes": [{"name":"class 1", "size":"50"}]}',1.23);
insert into fvt_08 values(1,'$#$%#$#$','110',to_date('01-07-2019','dd-mm-yyyy'),'true','1231 12:3:4.1234','{"classes": [{"name":"class 1", "size":"50"}]}',1.23);
insert into fvt_08 values(1,'$#$%#$#$','1010',to_date('01-07-2019','dd-mm-yyyy'),'true','1231 12:3:4.1234','{"classes": [{"name":"class 1", "size":"50"}]}',1.23);
create or replace type table8 force is table of blob;
/

create or replace function fvt_proc_08 (aaa8 table8) return table8 is
type record8 is record(r1 fvt_08.a%type,r2 fvt_08.b%type,r3 fvt_08.c%type,r4 fvt_08.d%type,r5 fvt_08.e%type,r6 fvt_08.f%type,r7 fvt_08.g%type,r8 fvt_08.h%type);
tab8 table8;
type  table08 is table of  record8;
cursor cur_08 is select a,b,c,d,e,f,g,h from fvt_08 where c = aaa8(1);
tab08 table08;

begin
select c bulk collect into tab8  from fvt_08 where c = aaa8(1) ;
	begin
	open cur_08;
	fetch cur_08 bulk collect into tab08;
	for i in tab08.first..tab08.last loop
		dbe_output.print_line(tab08(i).r1||'-'||tab08(i).r2||'-'||tab08(i).r8);
	end loop;
	close cur_08;
	return tab8;
	end;
end;
/

declare
dd table8 := table8('110');
id table8;
begin
id := fvt_proc_08(dd);
dbe_output.print_line(id(1));
end;
/
drop TYPE if exists table8 force;
drop TYPE if exists varray04 force;
drop TYPE if exists varray4 force;
drop function fvt_proc_08;
drop procedure fvt_proc_001;
drop table if exists fvt_08;
drop table if exists fvt_04;

drop type if exists for_type_null force;
CREATE OR REPLACE TYPE for_type_null IS TABLE OF varchar(100);
/
declare 
  nt for_type_null := for_type_null();
BEGIN
for i in nt.first..nt.last loop
dbe_output.print_line(1);
end loop;
end;
/
declare 
  a int:=null;
  b int:=null;
BEGIN
for i in a..b loop
dbe_output.print_line(1);
end loop;
end;
/
BEGIN
for i in null..null loop
dbe_output.print_line(1);
end loop;
end;
/
drop type for_type_null;
set serveroutput off;
--DTS2019111907315
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists test_user_1 cascade;
drop user if exists test_user_2 cascade;
create user test_user_1 identified by Cantian_234;
create user test_user_2 identified by Cantian_234;
grant create any type,execute any type,create any procedure, create session to test_user_1;
grant create any type,execute any type,create any procedure, create session to test_user_2;
drop table if exists test_user_1.table_2_1;
create table test_user_1.table_2_1(id1 number,id2 number);
drop type if exists test_user_2.test_type_t_1;
create or replace type test_user_2.test_type_t_1 is object(a number,b int);
/
create or replace procedure test_user_1.test_pro_type_1 is
result1 test_user_2.test_type_t_1;
begin
dbe_output.print_line('a');
end;
/
conn test_user_1/Cantian_234@127.0.0.1:1611
set serveroutput on;
call test_user_1.test_pro_type_1();
conn sys/Huawei@123@127.0.0.1:1611
revoke execute any type from test_user_1;
conn test_user_1/Cantian_234@127.0.0.1:1611
set serveroutput on;
call test_user_1.test_pro_type_1();
conn sys/Huawei@123@127.0.0.1:1611
drop type test_user_2.test_type_t_1 force;
drop procedure test_user_1.test_pro_type_1;
drop table test_user_1.table_2_1;
drop user test_user_1 cascade;
drop user test_user_2 cascade;
--DTS2019111913698
drop table if exists EMP;
CREATE TABLE EMP
       (EMPNO NUMBER(4) NOT NULL,
        ENAME VARCHAR2(10),
        JOB VARCHAR2(9),
        MGR NUMBER(4),
        HIREDATE DATE,
        SAL NUMBER(7, 2),
        COMM NUMBER(7, 2),
        DEPTNO NUMBER(2));
INSERT INTO EMP VALUES (1, 'SITH',  'CLEK',     7902,TO_DATE('1980-12-1', 'yyyy-mm-dd'),  800, NULL, 20);
INSERT INTO EMP VALUES (2, 'ALEN',  'SALSMAN',  7698,TO_DATE('1981-12-1', 'yyyy-mm-dd'), 1600,  300, 30);
INSERT INTO EMP VALUES (3, 'ARD',   'SAESMAN',  7698,TO_DATE('1982-12-1', 'yyyy-mm-dd'), 1250,  500, 30);
INSERT INTO EMP VALUES (4, 'JOES',  'MANGER',   7839,TO_DATE('1983-12-1', 'yyyy-mm-dd'),  2975, NULL, 20);
INSERT INTO EMP VALUES (5, 'MATIN', 'SALEMAN',  7698,TO_DATE('1984-12-1', 'yyyy-mm-dd'), 1250, 1400, 30);
commit;
set serveroutput on;
DECLARE
CURSOR emp_cur IS
SELECT empno, ename, hiredate FROM emp;
TYPE emp_rec_type IS RECORD
(empno emp.empno%TYPE,
ename emp.ename%TYPE,
hiredate emp.hiredate%TYPE);
TYPE nes_emp_type IS TABLE OF emp_rec_type;
emp_tab nes_emp_type;
v_limit number := 2;
v_count number := 0;
BEGIN
OPEN emp_cur;
LOOP
FETCH emp_cur
BULK COLLECT INTO emp_tab
LIMIT v_limit;
EXIT WHEN emp_tab.COUNT = 0;
v_count := v_count + 1;
FOR i IN emp_tab.FIRST .. emp_tab.LAST
LOOP
dbe_output.print_line(emp_tab(i).empno||CHR(9)||emp_tab(i).ename||CHR(9)||emp_tab(i).hiredate);
END LOOP;
END LOOP;
CLOSE emp_cur;
END;
/
drop table if exists EMP;
--DTS2019112806379
alter system set EMPTY_STRING_AS_NULL=false;
DROP TABLE if exists t1;
create table t1 (a int,d VARCHAR2(8000));
insert into t1 values (1,'');
insert into t1 values (2,'');
DROP TABLE if exists t2;
create table t2 (a int, b int, c int,d VARCHAR2(8000));
declare     
v1 int :=1;
v2 VARCHAR2(8000):='';
BEGIN  
    FOR ITEM IN ( SELECT a,d FROM t1) LOOP
    INSERT INTO t2 ( a,d) VALUES( ITEM.a,ITEM.d);
    end loop;
END;
/
alter system set EMPTY_STRING_AS_NULL=true;
--DTS2019112905707
declare 
  type array_number is table of number(20);
  numarr_result array_number := array_number();
begin
  select user_id bulk collect into numarr_result from all_users where rownum < 0;	
end;
/
declare 
  v_count number;
begin
  select user_id into v_count from all_users where rownum < 0;	
end;
/

-- DTS2020020701351 start
create or replace function return_cursor_func1 return SYS_REFCURSOR 
is
type xxx is record(a int);
v1 xxx;
v_refcur1 SYS_REFCURSOR;
begin
v1.a := 1;
open v_refcur1 for select v1.a from dual;
return v_refcur1;
end;
/

select return_cursor_func1 from dual;

declare
v_refcur1 SYS_REFCURSOR;
type xxx is record(a int);
v1 xxx;
begin
v1.a := 0;
v_refcur1 := return_cursor_func1();
fetch v_refcur1 into v1.a;
dbe_output.print_line('v1.a: ' || v1.a);
end;
/

declare
v_refcur1 SYS_REFCURSOR;
type xxx is record(a int);
v1 xxx;
begin
v1.a := 0;
v_refcur1 := return_cursor_func1();
fetch v_refcur1 into v1;
dbe_output.print_line('v1.a: ' || v1.a);
end;
/
-- DTS2020020701351 end

--DTS2019112712529
create or replace type testspce is / of clob;
/
create or replace type testspces is /^ of clob;
/

--DTS2019113000956
CREATE OR REPLACE TYPE varray_test3 IS VARRAY(15360) OF int;
/
DECLARE
 var_C1 varray_test3 := varray_test3(1234, 234, 345);
BEGIN
 dbe_output.print_line(var_C1(3));
END;
/
drop type varray_test3 force;

--DTS array
drop procedure if exists PROC_ARRAY_TEST_003;
CREATE OR REPLACE PROCEDURE PROC_ARRAY_TEST_003(P1 char[] DEFAULT array['abcde',null,'1999-01-01'],P2 double[] := '{12.1234567,1234.78,2345.89,12345.4567,12.1234567,12.55}')
AS
V1 int; V2 int;
BEGIN
        V1:= array_length(P1); V2:= array_length(P2);
        dbe_output.print_line('length of P1 is:'||V1);
        dbe_output.print_line('length of P2 is:'||V2);
EXCEPTION WHEN NO_DATA_FOUND THEN dbe_output.print_line('NO_DATA_FOUND');
END;
/
CALL PROC_ARRAY_TEST_003();
CALL PROC_ARRAY_TEST_003(P1=>array['dbcd','abcde','1999-01-01','ab'],P2=>array[1233,null,89.0000001,-2147483647]);
drop procedure if exists PROC_ARRAY_TEST_003;

drop table if exists table_char;
create table table_char(c1 char(1));
drop procedure if exists pchar;
create or replace procedure pchar(f1 in out char)
as
begin 
insert into table_char(c1) values(f1);
f1 := 9;
end;
/
declare
c int;
begin
c:=7;
pchar(c);
DBE_OUTPUT.PRINT_LINE(c);
end;
/
select * from table_char;
drop procedure pchar;
drop table table_char;

--DTS2020052607B6PLP0H00
drop table if exists test_clob_0526;
create table test_clob_0526(c1 clob);
insert into test_clob_0526 values('adhjkgaljhgjkha');
insert into test_clob_0526 values('agAGAGASGFDDCBGJLKYIOUJKFUHJHKUIKUITUUJYUIJKYUIUYIYUg');
insert into test_clob_0526 values('adhjkgaljhgjkhadddA,MKFGJSDJFHLAHGHAJHJGHALHJHDFJLGHAJLHJLGHJFAHJHGJdddddddddddddh');
select dbe_lob.get_length(c1) length from test_clob_0526 order by length desc;
select min(dbe_lob.get_length(c1)) from test_clob_0526;
select max(dbe_lob.get_length(c1)) from test_clob_0526;
drop table if exists test_clob_0526;

-- xid
DROP TABLE IF EXISTS T_SMSTASKLIST_2020_0664 CASCADE CONSTRAINTS;
CREATE TABLE T_SMSTASKLIST_2020_0664(staff_ID NUMBER(6) not null,val int)
PARTITION BY RANGE (staff_ID)(
partition P_050_BEFORE values less than (50),
partition P_100 values less than (100) ,
partition P_100_AFTER values less than (MAXVALUE)
);
insert into T_SMSTASKLIST_2020_0664 values(1,1);
insert into T_SMSTASKLIST_2020_0664 values(70,2);
insert into T_SMSTASKLIST_2020_0664 values(120,3);
COMMIT;
create or replace function f_cursor_test_0602 return sys_refcursor is
  i_taskid T_SMSTASKLIST_2020_0664.val%type;
  c_tasks  sys_refcursor;
begin 
  update T_SMSTASKLIST_2020_0664 t set val = 8;
  --commit;
  open c_tasks for select staff_ID from T_SMSTASKLIST_2020_0664 where val = 8;
  return c_tasks;
end;
/
create or replace procedure p_cursor_test2_0602(c_tasks out sys_refcursor) is
begin
  c_tasks := f_cursor_test_0602();
  commit;
end;
/
declare
  taskrecordid number;
  c_tasks      sys_refcursor;
begin
  p_cursor_test2_0602(c_tasks);
  loop
    FETCH c_tasks into taskrecordid;
    EXIT WHEN c_tasks%notfound;
    dbe_output.print_line('taskrecordid =' || taskrecordid);
  end loop;
end;
/
DROP procedure p_cursor_test2_0602;
DROP function f_cursor_test_0602;
DROP TABLE IF EXISTS T_SMSTASKLIST_2020_0664 CASCADE CONSTRAINTS;
set serveroutput off;
