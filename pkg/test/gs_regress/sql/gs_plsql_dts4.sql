set serveroutput on;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_plsql_dts4 cascade;
create user gs_plsql_dts4 identified by Lh00420062;
grant dba to gs_plsql_dts4;

conn gs_plsql_dts4/Lh00420062@127.0.0.1:1611
set serveroutput on;

CREATE OR REPLACE FUNCTION MYF RETURN INT
IS
V1 INT := 20;
BEGIN
NULL;
RETURN V1;
END;
/
SELECT MYF FROM DUAL;

CREATE OR REPLACE PACKAGE PAK1
IS
FUNCTION MYF RETURN INT;
FUNCTION MYF2 RETURN INT;
END;
/

CREATE OR REPLACE PACKAGE BODY PAK1
IS
FUNCTION MYF RETURN INT
IS
V1 INT := 10;
BEGIN
NULL;
RETURN V1;
END;

FUNCTION MYF2 RETURN INT
IS
V1 INT;
BEGIN
SELECT MYF INTO V1 FROM DUAL;
RETURN V1;
END;
END;
/
SELECT PAK1.MYF2 FROM DUAL;
SELECT MYF FROM DUAL;

create or replace procedure job_proce_t()
as
begin
dbe_output.print_line('aaa');
end;
/

--excepting wrong
declare
jobno number;
begin
DBE_TASK.SUBMIT(jobno,'job_proce_t();',sysdate,'sysdate+1/:4/60');
commit;
end;
/

--excepting wrong
declare
jobno number;
begin
DBE_TASK.SUBMIT(jobno,'declare a int; begin job_proce_t(); a := :1; end;',sysdate,'sysdate+1/4/60');
commit;
end;
/

drop table if exists tt1 ;
drop table if exists tt2 ;
create table tt1(a int, b int,c int, d int);
insert into tt1 values(1,1,1,1);
create table tt2(a int, b int,c int);
insert into tt2 values(1,10,11);
insert into tt2 values(2,20,21);
create or replace procedure my_merge_into_table(v_in int)
is
begin
merge into tt1 using tt2
on (tt1.a = tt2.a)
when matched then
update set tt1.b = v_in, tt1.c=tt2.c, tt1.d = case when v_in > 10 then 30 else 40 end;
end; 
/
call my_merge_into_table(100);
select  * from tt1;

create or replace procedure my_merge_into_table2(b int, c int, d int)
is
begin
merge into tt1 using tt2
on (tt1.a = tt2.a)
when matched then
update set b = length('abc')+b, c = c+abs(c), d = case when d > 10 then b else c end;
end; 
/
call my_merge_into_table2(200,300,400);
select  * from tt1;

--DTS2019062112007
set serveroutput on;
drop table if exists fvt_pragma_table_015;
create table fvt_pragma_table_015 (c_int int,c_number number,c_varchar varchar(80),c_date date);
insert into fvt_pragma_table_015 values(1,1.25,'abcd','2015-5-5');
insert into fvt_pragma_table_015 values(2,2.25,'nh','2016-6-6');
DROP TABLE IF EXISTS fvt_pragma_table_15;
create global temporary table fvt_pragma_table_15 
(
c_int int,
c_number number,
c_varchar varchar(80),
c_date date
)ON COMMIT PRESERVE ROWS;
insert into fvt_pragma_table_15 values
(1,1.25,'xiao','0001-1-1');
insert into fvt_pragma_table_15 values
(2,2.25,'xiaohu','2019-1-1');
insert into fvt_pragma_table_15 values
(3,3.25,' xiaolan','2178-12-31');

declare
begin
	merge into fvt_pragma_table_015 a using fvt_pragma_table_15 b1 on (a.c_int = b1.c_int) when matched then update set a.c_varchar = b1.c_varchar 
	when not matched then insert (c_int,c_number,c_varchar,c_date) values(b1.c_int,b1.c_number,b1.c_varchar,b1.c_date);
	execute immediate 'alter table fvt_pragma_table_015 rename column c_int to c_id';
	insert into fvt_pragma_table_015 values(100,3.25,'$#@','2019-6-19');
	declare
	  b_number number := 0;
	  low_income exception;
	begin
		for i in 1..10
		loop
			insert into fvt_pragma_table_015 values(i,3.25,'jtfz','2018-8-8');
		end loop;
		begin
		  if b_number < 10 then 
		  raise low_income;
		  end if;
		  select c_number into b_number from fvt_pragma_table_015 where c_number = 2.25;
		  dbe_output.print_line (b_number);
		exception
		  when low_income then
		  dbe_output.print_line ('low number occurred');
		end;
	end;
	execute immediate 'commit';
	select c_number into b_number from fvt_pragma_table_015 where c_number = 2.25;
end;
/

select * from fvt_pragma_table_015;

-- nestted 9 level autonomous transaction
drop table if exists table_liu_1;
drop table if exists table_liu_2;
drop table if exists table_liu_3;
drop table if exists table_liu_4;
drop table if exists table_liu_5;
drop table if exists table_liu_6;
drop table if exists table_liu_7;
drop table if exists table_liu_8;
drop table if exists table_liu_9;
drop table if exists table_liu_10;
CREATE TABLE table_liu_1(a int);
CREATE TABLE table_liu_2(a int);
CREATE TABLE table_liu_3(a int);
CREATE TABLE table_liu_4(a int);
CREATE TABLE table_liu_5(a int);
CREATE TABLE table_liu_6(a int);
CREATE TABLE table_liu_7(a int);
CREATE TABLE table_liu_8(a int);
CREATE TABLE table_liu_9(a int);
CREATE TABLE table_liu_10(a int);
CREATE OR REPLACE TRIGGER trigger_liu_1 BEFORE INSERT ON table_liu_1 FOR EACH ROW 
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
 INSERT INTO table_liu_2 values (10);
 EXECUTE IMMEDIATE 'COMMIT';
END;
/
CREATE OR REPLACE TRIGGER trigger_liu_2 BEFORE INSERT ON table_liu_2 FOR EACH ROW 
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
 INSERT INTO table_liu_3 values (10);
 EXECUTE IMMEDIATE 'COMMIT';
END;
/
CREATE OR REPLACE TRIGGER trigger_liu_3 BEFORE INSERT ON table_liu_3 FOR EACH ROW 
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
 INSERT INTO table_liu_4 values (10);
 EXECUTE IMMEDIATE 'COMMIT';
END;
/
CREATE OR REPLACE TRIGGER trigger_liu_4 BEFORE INSERT ON table_liu_4 FOR EACH ROW 
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
 INSERT INTO table_liu_5 values (10);
 EXECUTE IMMEDIATE 'COMMIT';
END;
/
CREATE OR REPLACE TRIGGER trigger_liu_5 BEFORE INSERT ON table_liu_5 FOR EACH ROW 
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
 INSERT INTO table_liu_6 values (10);
 EXECUTE IMMEDIATE 'COMMIT';
END;
/
CREATE OR REPLACE TRIGGER trigger_liu_6 BEFORE INSERT ON table_liu_6 FOR EACH ROW 
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
 INSERT INTO table_liu_7 values (10);
 EXECUTE IMMEDIATE 'COMMIT';
END;
/
CREATE OR REPLACE TRIGGER trigger_liu_7 BEFORE INSERT ON table_liu_7 FOR EACH ROW 
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
 INSERT INTO table_liu_8 values (10);
 EXECUTE IMMEDIATE 'COMMIT';
END;
/
CREATE OR REPLACE TRIGGER trigger_liu_8 BEFORE INSERT ON table_liu_8 FOR EACH ROW 
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
 INSERT INTO table_liu_9 values (10);
 EXECUTE IMMEDIATE 'COMMIT';
END;
/
CREATE OR REPLACE TRIGGER trigger_liu_9 BEFORE INSERT ON table_liu_9 FOR EACH ROW 
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
 INSERT INTO table_liu_10 values (10);
 EXECUTE IMMEDIATE 'COMMIT';
END;
/
CREATE OR REPLACE PROCEDURE proc_insert_table_1 IS
b INTEGER := 20;
BEGIN
  INSERT INTO table_liu_1 VALUES (b);
END;
/
exec proc_insert_table_1;

drop table if exists test_table_0620_06_04_02;
CREATE TABLE test_table_0620_06_04_02 (id int,test_value VARCHAR2(25));
insert into test_table_0620_06_04_02 values(1,'123');
insert into test_table_0620_06_04_02 values(1,'234');
commit;
CREATE OR REPLACE procedure PRO_C_06_04_02(p_id int) IS
	PRAGMA AUTONOMOUS_TRANSACTION;
	cursor v_cursor(sid int) is select * from test_table_0620_06_04_02 where id=sid;
BEGIN
	for i in v_cursor(p_id) loop
	    dbe_output.print_line(i.test_value);
	end loop;	
	commit;
END PRO_C_06_04_02;
/

call PRO_C_06_04_02(1);

--func error
create or replace function f1(b int) return int
is 
a int :=1;
begin
a := a/b;
return a;
end;
/
create or replace function f2(c int) return varchar
is 
a int :=0;
begin
a := f1(a);
return a;
end;
/

create or replace function f3(c int) return varchar
is 
a int :=0;
b varchar(10) := 'abc';
begin
return b;
end;
/

create or replace function f4(d int) return int
is 
a int :=0;
b varchar(10) := 'abc';
begin
a := abs(b);
return a;
end;
/


select abs('abc') from dual;
select abs(f2(0)) from dual;
select abs(f1(0)) from dual;
select abs(to_char(f3(0))) from dual;
select abs(to_char(f2(f1(0)))) from dual;
select abs(f2(f1(0))) from dual;
select f2(abs(f1(0))) from dual;
select f2(abs('abc')) from dual;
select f2(abs(f3(0))) from dual;
select f2(f1(abs('abc'))) from dual;
select f2(f2(0)) from dual;
select f2(abs(f2(0))) from dual;
select f2(f4(0)) from dual;
select f2(to_char(f4(0))) from dual;

drop table if exists liu1;
drop table if exists liu2;
create table liu1(c_text blob);
insert into liu1 values ('123abc');
create global temporary table liu2(c_text blob);
insert into liu2 select * from liu1;
select  * from liu2;

create user liu_end identified by Lh00420062;
grant dba to liu_end;
create or replace procedure liu_end.testa
as
begin
dbe_output.print_line('good1');
end;
/
create or replace procedure liu_end.testa
as
begin
dbe_output.print_line('good1');
end testa;
/
create or replace procedure liu_end.testa
as
begin
dbe_output.print_line('good1');
end liu_end.testa;
/
create or replace procedure testa
as
begin
<<aa.bb>>
begin
dbe_output.print_line('good1');
end aa.bb;
end;
/
drop table if exists plsql_dts4_t1;
drop table if exists plsql_dts4_t3;
create table plsql_dts4_t1(a int, b int);
insert into plsql_dts4_t1 values (1,2);
create table plsql_dts4_t3(a int, b int);
declare
    str varchar2(50);
begin
    insert into plsql_dts4_t3 (a)(with temp as (select * from plsql_dts4_t1) select a from temp); 
end;
/
select a from plsql_dts4_t3;
drop table if exists tt1;
create table tt1(a int);
insert into tt1 values(10);

-- explicit cursor
create or replace trigger t_tt1 after insert on tt1 for each row
is 
cursor cur is select a from tt1;
v1 int;
begin
for i in cur loop
fetch cur into v1;
dbe_output.print_line(i.a);
end loop;
end;
/
insert into tt1 values(30);

-- ref cursor
create or replace trigger t_tt1 after insert on tt1 for each row
is 
cur sys_refcursor;
v1 int;
begin
open cur for select a from tt1;
fetch cur into v1; 
end;
/
insert into tt1 values(30);

-- for implicit cursor
create or replace trigger t_tt1 after insert on tt1 for each row
is 
v1 int;
begin
for cur in (select a from tt1) loop
dbe_output.print_line(cur.a);
end loop;
end;
/
insert into tt1 values(30);

-- for explicit cursor
create or replace trigger t_tt1 after insert on tt1 for each row
is 
cursor cur is select a from tt1;
v1 int;
begin
for cur in cur loop
dbe_output.print_line(cur.a);
end loop;
end;
/
insert into tt1 values(30);

create or replace trigger t_tt1 after insert on tt1 for each row
is 
cursor cur is select a from tt1;
v1 int;
begin
for cur1 in cur loop
dbe_output.print_line(cur1.a);
end loop;
end;
/
insert into tt1 values(30);

--using ref as return_result
create or replace procedure p_tt1 
is
cur sys_refcursor;
begin
open cur for select a from tt1;
dbe_sql.return_cursor(cur);
end;
/
create or replace trigger t_tt1 after insert on tt1 for each row
is 
cur sys_refcursor;
v1 int;
begin
p_tt1();
end;
/
insert into tt1 values(30);

--using ref as function result
create or replace function f_tt1 return sys_refcursor 
is
cur sys_refcursor;
begin
open cur for select a from tt1;
return cur;
end;
/
create or replace trigger t_tt1 after insert on tt1 for each row
is 
cur sys_refcursor;
v1 int;
begin
cur := f_tt1();
end;
/
insert into tt1 values(30);
drop table tt1;

-- test out or inout param used in into clause
declare
b varchar(10) := 'a';
begin
  execute immediate 'begin select ''abc'' into :1 from dual; end;' using out b;
  dbe_output.print_line(b);
  execute immediate 'begin select ''efd'' into :1 from dual; end;' using in out b;
  dbe_output.print_line(b);
end;
/

-- DTS2019071710664 
declare 
a int;
begin
 dbe_debug.attach(a, 20);
end;
/
declare 
a int;
b int;
begin
 b := dbe_debug.init(a);
end;
/
declare 
a varchar(64);
b varchar(64);
begin
 execute immediate 'select * from table(dba_proc_line(:1, ''TEST_FOR_LOOP_P''))' using a;
end;
/
declare 
a varchar(64);
b varchar(64);
begin
 execute immediate 'select * from table(dba_proc_decode(''SYS'', ''PINVALIDCURSOR'', :1))' using a;
end;
/
drop table if exists t_cdb_cur_defect;
drop sequence if exists seq_cur_defect_id;
drop trigger if exists trg_cur_defect_id;
create table t_cdb_cur_defect(cur_defect_id number,a varchar(200));
create sequence seq_cur_defect_id;
create trigger trg_cur_defect_id before insert on t_cdb_cur_defect for each row
is
a int;
begin
    a := 1+seq_cur_defect_id.nextval;
end;
/

insert t_cdb_cur_defect values (10,'100');
-- switch schema
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists PACK_SCHEMA_001_USR_01_DTS4 cascade;
drop user if exists PACK_SCHEMA_001_USR_02_DTS4 cascade;
create user PACK_SCHEMA_001_USR_01_DTS4 identified by Changeme_123;
create user PACK_SCHEMA_001_USR_02_DTS4 identified by Changeme_123;
grant dba to PACK_SCHEMA_001_USR_01_DTS4;
grant dba to PACK_SCHEMA_001_USR_02_DTS4;

--user1
conn PACK_SCHEMA_001_USR_01_DTS4/Changeme_123@127.0.0.1:1611
create table PACK_SCHEMA_001_TAB_01_DTS (id int, name varchar(100));
CREATE OR REPLACE PACKAGE  PACKAGE_B
IS
FUNCTION  test_outf return varchar;
END PACKAGE_B;
/

CREATE OR REPLACE PACKAGE body PACKAGE_B
IS
function test_outf return varchar is 
c varchar(100) := 'ok';
begin
return c;
end;
END;
/

--user2
conn PACK_SCHEMA_001_USR_02_DTS4/Changeme_123@127.0.0.1:1611
CREATE OR REPLACE PACKAGE PACKAGE_B
IS
FUNCTION  test_outf return int;
END PACKAGE_B;
/

CREATE OR REPLACE PACKAGE body PACKAGE_B
IS
function test_outf return int is 
d int ;
begin
select id into d from PACK_SCHEMA_001_USR_01_DTS4.PACK_SCHEMA_001_TAB_01_DTS where name=PACK_SCHEMA_001_USR_01_DTS4.PACKAGE_B.test_outf;
return d;
end;
END PACKAGE_B;
/
--DTS2019072906224
drop PACKAGE if exists PACK_BODY_DYNAMIC_008_pack_01;

CREATE OR REPLACE PACKAGE PACK_BODY_DYNAMIC_008_pack_01
IS
FUNCTION PACK_BODY_DYNAMIC_008_FUN_02 (p1 int,p2 int,p3 number)   return int;
procedure PACK_BODY_DYNAMIC_008_PRO_02(p_no int,p_sal integer);
END PACK_BODY_DYNAMIC_008_pack_01;

CREATE OR REPLACE PACKAGE body PACK_BODY_DYNAMIC_008_pack_01
IS
procedure PACK_BODY_DYNAMIC_008_PRO_02(p_no int,p_sal integer)   is
begin
insert into BODY_DYNAMIC_008_TAB_01 values(p_no,''insert'',''worker'',p_sal);
update BODY_DYNAMIC_008_TAB_01 set job=''update'' where empno=p_no;
commit;
end;


function PACK_BODY_DYNAMIC_008_FUN_02(p1 int,p2 int,p3 number)   return int is 
c int;
begin
c := p1+p2-p3;
end;
END PACK_BODY_DYNAMIC_008_pack_01;
/

drop PACKAGE PACK_BODY_DYNAMIC_008_pack_01;

drop table if exists tt1_dropspace;
create tablespace myspc datafile 'myspc' size 20M autoextend on next 10M;
create table tt1_dropspace(a int) tablespace myspc;
insert into tt1_dropspace values(2);
CREATE or replace FUNCTION func_objectid_dropsapce(A varchar) RETURN varchar
AS
bb int;
BEGIN
select a into bb from tt1_dropspace limit 1;
END;
/
select status from my_objects where object_name='FUNC_OBJECTID_DROPSAPCE';
drop tablespace myspc INCLUDING CONTENTS AND DATAFILES;
select status from my_objects where object_name='FUNC_OBJECTID_DROPSAPCE';

drop table if exists PROC_DML_KEY_018_TAB_01;
create table PROC_DML_KEY_018_TAB_01(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into PROC_DML_KEY_018_TAB_01 values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
insert into PROC_DML_KEY_018_TAB_01 values(1,'zhansi','doctor1',10000),(2,'lisiabc','doctor2',10000),(123,'zhangwu123','doctor3',10000);
insert into PROC_DML_KEY_018_TAB_01 values(10,'abc','worker',9000);
insert into PROC_DML_KEY_018_TAB_01 values(716,'ZHANGSAN','leader',20000);
drop table if exists PROC_DML_KEY_018_TAB_02;
create table PROC_DML_KEY_018_TAB_02(empno int   ,ename varchar(10),job varchar(10) ,sal integer);
insert into PROC_DML_KEY_018_TAB_02 values(100,'marry','teacher',9600);
insert into PROC_DML_KEY_018_TAB_02 values(716,'ZHANGSAN','leader',20000);
CREATE OR REPLACE  procedure  PACK_PROC_DML_KEY_018_FUN_01(p1 int,p2 int,p3 number)   is 
c int;
cur sys_refcursor;
begin
open cur for select * from PROC_DML_KEY_018_TAB_01 T1,PROC_DML_KEY_018_TAB_02 T2 where T1.empno=T2.empno(+) order by T1.empno,T1.ename ;
c:=found_rows();
dbe_sql.return_cursor(cur);
dbe_output.print_line(c);
end;
/
call PACK_PROC_DML_KEY_018_FUN_01(4,3,3);

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_plsql_test_error cascade;
drop user if exists TEST_PRIV_PAK1 cascade;
create user gs_plsql_test_error identified by Lh00420062;
create user TEST_PRIV_PAK1 identified by Lh00420062;
grant create session, create procedure to gs_plsql_test_error;
conn gs_plsql_test_error/Lh00420062@127.0.0.1:1611
CREATE OR REPLACE PACKAGE TEST_PRIV_PAK
IS
END;
/
CREATE OR REPLACE PACKAGE BODY TEST_PRIV_PAK
IS
END;
/
--expect pack object not exists;
call TEST_PRIV_PAK.MYP1; 
--expect user pack object not exists;
call gs_plsql_test_error.TEST_PRIV_PAK.MYP1; 
--expect privilsge error;
call TEST_PRIV_PAK1.MYP1; 
--expect privilsge error;
call TEST_PRIV_PAK1.gs_plsql_test_error.MYP1;
--expect privilsge error;
call gs_plsql_test_xxx.MYP1;
call gs_plsql_test_xxx.xxx.MYP1;

conn gs_plsql_dts4/Lh00420062@127.0.0.1:1611
drop table if exists SYN_TAB_001;
create table SYN_TAB_001
(
    id int,
    name varchar2(10),
     sal number
);
insert into SYN_TAB_001 values(1,'aaa',2600);

create or replace function SYN_FUN_SYN_001(v1 int) return int
is
begin
return v1;
end;
/
create  or replace function SYN_FUN_SYN_002(v1 int) return int
is
begin
return v1;
end;
/
create  or replace function SYN_FUN_SYN_003(v1 int) return int
is
begin
return v1;
end;
/
create  or replace function SYN_FUN_SYN_004(v1 int) return int
is
begin
return v1;
end;
/
select name,sal,max(SYN_FUN_SYN_001(SYN_FUN_SYN_002(SYN_FUN_SYN_003(SYN_FUN_SYN_004(-1)))))over(partition by id order by id) from SYN_TAB_001;
select name,sal,min(SYN_FUN_SYN_001(SYN_FUN_SYN_002(SYN_FUN_SYN_003(SYN_FUN_SYN_004(-1)))))over(partition by id order by id) from SYN_TAB_001;

-- DTS2019092406819
declare
b int := 5;
sql_str varchar(160);
begin
  sql_str := 'begin execute immediate ''select 123 from dual'' into :1; end;';
  execute immediate sql_str using out b;
  dbe_output.print_line(b);
end;
/

DROP TABLE IF EXISTS test_part_t1;
create table test_part_t1(f1 int NOT NULL, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);
create index idx_t1_1 on test_part_t1(f2,f3);
create index idx_t1_2 on test_part_t1(f4,f5) local;
insert into test_part_t1 values(5, 15, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(6, 16, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));

drop table if exists get_tab_rows_tab;
create table get_tab_rows_tab(a int,b int);
insert into get_tab_rows_tab values(1,11);
commit;
declare
beg_id number;
end_id number;
scn_id number;
d int;
e varchar(1024);
begin
select BEG,END into beg_id,end_id from table(get_tab_parallel('get_tab_rows_tab', 1));
select current_scn into scn_id from v$database;
select * into d,e from table(get_tab_rows('get_tab_rows_tab', -1, scn_id,null, beg_id, end_id));
dbe_output.print_line(d);
dbe_output.print_line(e);
end;
/
--example 1, test soft-parser
DECLARE
 	a INT;
 	b CHAR(16);
 	c VARCHAR(16);
 BEGIN
 	a := 10;
 	b := 'abc';
 	c := 'efc';
 EXECUTE IMMEDIATE 'BEGIN 
  :x := 11; 
  :y := ''aaa''; 
  :z := ''bbb'';
  END;' USING out a, out b, out c;
 END;
 /
 DECLARE
 	a INT;
 	b CHAR(16);
 	c VARCHAR(16);
 BEGIN
 	a := 10;
 	b := 'abc';
 	c := 'efc';
 EXECUTE IMMEDIATE 'BEGIN 
  :x := 11; 
  :y := ''aaa''; 
  :z := ''bbb'';
  END;' USING in a, in b, in c;
 END;
 /
--example 2
DECLARE
a INT :=10;
BEGIN
EXECUTE IMMEDIATE '
begin
dbe_output.print_line(:x);
END;' USING out a;
END;
/
DECLARE
a INT :=10;
BEGIN
EXECUTE IMMEDIATE '
begin
dbe_output.print_line(:x);
END;' USING in a;
END;
/
DECLARE
a INT :=10;
BEGIN
EXECUTE IMMEDIATE '
begin
dbe_output.print_line(:x);
END;' USING out a;
END;
/
-- example 3
DECLARE
a INT :=10;
BEGIN
EXECUTE IMMEDIATE '
declare
inner_a int;
BEGIN 
inner_a := :x;  
dbe_output.print_line(inner_a);
END;' USING out a;
END;
/
DECLARE
a INT :=10;
BEGIN
EXECUTE IMMEDIATE '
declare
inner_a int;
BEGIN 
inner_a := :x;  
dbe_output.print_line(inner_a);
END;' USING in a;
END;
/
DECLARE
a INT :=10;
BEGIN
EXECUTE IMMEDIATE '
declare
inner_a int;
BEGIN 
inner_a := :x;  
dbe_output.print_line(inner_a);
END;' USING out a;
END;
/
conn sys/Huawei@123@127.0.0.1:1611
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'gs_plsql_dts4','TEST_PART_T1');
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'GS_PLSQL_DTS4','test_part_t1');
drop user gs_plsql_dts4 cascade;
drop user liu_end cascade;
drop user if exists PACK_SCHEMA_001_USR_01_DTS4 cascade;
drop user if exists PACK_SCHEMA_001_USR_02_DTS4 cascade;
drop user gs_plsql_test_error cascade;
drop user TEST_PRIV_PAK1 cascade;

--DTS2019111414436
drop type if exists nt_type_null force;
CREATE OR REPLACE TYPE nt_type_null IS TABLE OF varchar(100);
/
declare 
  nt nt_type_null := nt_type_null('','','null',' ','');
  a varchar(10);
BEGIN
a:=nt(null);
end;
/
call nt_type_null();
drop type nt_type_null;
--DTS2019112210961
drop user if exists FVT_Security_018_1 cascade;
drop user if exists FVT_Security_018_2 cascade;
create user FVT_Security_018_1 identified by Cantian_234;
grant create session to FVT_Security_018_1;
create user FVT_Security_018_2 identified by Cantian_234;
grant create session,create any type to FVT_Security_018_2;
CREATE OR REPLACE TYPE FVT_Security_018_1.FVT_Security_Custom_Type_018_1 FORCE AS OBJECT(
year int,
month int,
day int
) NOT FINAL;
/

conn FVT_Security_018_2/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE TYPE FVT_Security_018_1.FVT_Security_Custom_Type_018_1_2 FORCE UNDER FVT_Security_018_1.FVT_Security_Custom_Type_018_1(
name varchar(20),
city varchar(20)
);
/
conn FVT_Security_018_1/Cantian_234@127.0.0.1:1611
--DTS2019112208296
select * from all_source where name like 'FVT_SECURITY_CUSTOM_TYPE_018%';
conn sys/Huawei@123@127.0.0.1:1611
drop user FVT_Security_018_1 cascade;
drop user FVT_Security_018_2 cascade;
--DTS2019112213740
drop type if exists FVT_Security_Custom_Type_018_1 force;
CREATE OR REPLACE TYPE FVT_Security_Custom_Type_018_1 FORCE AS OBJECT(
year int,
month int,
day int
) NOT FINAL;
/
CREATE OR REPLACE TYPE FVT_Security_Custom_Type_018_1 FORCE UNDER FVT_Security_Custom_Type_018_1(
name varchar(20),
city varchar(20)
);
/
drop type FVT_Security_Custom_Type_018_1 force;

create or replace type my_type_1 is object (id number, name varchar2(64));
 /
create or replace type my_type_2 is table of my_type_1;
 /
drop table if exists my_table;
create table my_table(id number, FILE_NAME varchar2(64));

insert into my_table values(1,'happy');
insert into my_table values(2,'like');
insert into my_table values(3,'love');
create or replace function g_my_table1 return my_type_2
  is
    l_my_table_tab my_type_2 ;
    n integer := 0;
	route_str VARCHAR2(256);
  begin
    l_my_table_tab := my_type_2();
	for r in (select id, FILE_NAME from my_table)
    loop
		l_my_table_tab.extend;
		n := n + 1;
		l_my_table_tab(n) := my_type_1(r.id, r.FILE_NAME);
	end loop;
	return l_my_table_tab;
  end;
  /
create view my_view1 as select * from table(dba_analyze_table('sys','my_table'));
select * from my_view1;
create view my_view2 as select * from table(cast(g_my_table1 as my_type_2));
select * from my_view2;

drop view my_view1;
drop view my_view2;
drop function g_my_table1;
drop table my_table;
drop type my_type_2 force;
drop type my_type_1 force;

--DTS2019113000956
CREATE OR REPLACE TYPE varray_test IS VARRAY(2000000) OF varchar(4096);
/
DECLARE
	TYPE varray1 IS VARRAY(2000000) OF varchar(4096);
	varray_test1 varray1;
BEGIN
	varray_test1 := varray1('name', 'salary', 'city', 'birthday');
END;
/
drop TYPE varray_test force;

CREATE TABLE LONG_TABLE(
F1 INT,F2 INT,F3 INT,F4 INT,F5 INT,F6 INT,F7 INT,F8 INT,F9 INT,F10 INT,F11 INT,F12 INT,F13 INT,
F14 INT,F15 INT,F16 INT,F17 INT,F18 INT,F19 INT,F20 INT,F21 INT,F22 INT,F23 INT,F24 INT,F25 INT,
F26 INT,F27 INT,F28 INT,F29 INT,F30 INT,F31 INT,F32 INT,F33 INT,F34 INT,F35 INT,F36 INT,F37 INT,
F38 INT,F39 INT,F40 INT,F41 INT,F42 INT,F43 INT,F44 INT,F45 INT,F46 INT,F47 INT,F48 INT,F49 INT,
F50 INT,F51 INT,F52 INT,F53 INT,F54 INT,F55 INT,F56 INT,F57 INT,F58 INT,F59 INT,F60 INT,F61 INT,
F62 INT,F63 INT,F64 INT,F65 INT,F66 INT,F67 INT,F68 INT,F69 INT,F70 INT,F71 INT,F72 INT,F73 INT,
F74 INT,F75 INT,F76 INT,F77 INT,F78 INT,F79 INT,F80 INT,F81 INT,F82 INT,F83 INT,F84 INT,F85 INT,
F86 INT,F87 INT,F88 INT,F89 INT,F90 INT,F91 INT,F92 INT,F93 INT,F94 INT,F95 INT,F96 INT,F97 INT
);

INSERT INTO LONG_TABLE VALUES(1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10,
1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7);

creATE OR REPLACE TYPE LONG_OBJ IS OBJECT(
F1 INT,F2 INT,F3 INT,F4 INT,F5 INT,F6 INT,F7 INT,F8 INT,F9 INT,F10 INT,F11 INT,F12 INT,F13 INT,
F14 INT,F15 INT,F16 INT,F17 INT,F18 INT,F19 INT,F20 INT,F21 INT,F22 INT,F23 INT,F24 INT,F25 INT,
F26 INT,F27 INT,F28 INT,F29 INT,F30 INT,F31 INT,F32 INT,F33 INT,F34 INT,F35 INT,F36 INT,F37 INT,
F38 INT,F39 INT,F40 INT,F41 INT,F42 INT,F43 INT,F44 INT,F45 INT,F46 INT,F47 INT,F48 INT,F49 INT,
F50 INT,F51 INT,F52 INT,F53 INT,F54 INT,F55 INT,F56 INT,F57 INT,F58 INT,F59 INT,F60 INT,F61 INT,
F62 INT,F63 INT,F64 INT,F65 INT,F66 INT,F67 INT,F68 INT,F69 INT,F70 INT,F71 INT,F72 INT,F73 INT,
F74 INT,F75 INT,F76 INT,F77 INT,F78 INT,F79 INT,F80 INT,F81 INT,F82 INT,F83 INT,F84 INT,F85 INT,
F86 INT,F87 INT,F88 INT,F89 INT,F90 INT,F91 INT,F92 INT,F93 INT,F94 INT,F95 INT,F96 INT,F97 INT
);
/

creATE OR REPLACE TYPE LONG_ARR IS TABLE OF LONG_OBJ;
/

create or replace function g_my_table5 return LONG_ARR
  is
    l_my_table_tab LONG_ARR ;
    n integer := 0;
  begin
    l_my_table_tab := LONG_ARR();
	for r in (select f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18,f19,f20,f21,f22,f23,f24,f25,f26,f27,f28,f29,f30,f31,
f32,f33,f34,f35,f36,f37,f38,f39,f40,f41,f42,f43,f44,f45,f46,f47,f48,f49,f50,f51,f52,f53,f54,f55,f56,f57,f58,f59,
f60,f61,f62,f63,f64,f65,f66,f67,f68,f69,f70,f71,f72,f73,f74,f75,f76,f77,f78,f79,f80,f81,f82,f83,f84,f85,f86,
f87,f88,f89,f90,f91,f92,f93,f94,f95,f96,f97 from LONG_TABLE)
    loop
		l_my_table_tab.extend;
		n := n + 1;
		l_my_table_tab(n) := LONG_OBJ(r.f1,r.f2,r.f3,r.f4,r.f5,r.f6,r.f7,r.f8,r.f9,r.f10,r.f11,r.f12,r.f13,r.f14,r.f15,r.f16,r.f17,r.f18,r.f19,r.f20,
r.f21,r.f22,r.f23,r.f24,r.f25,r.f26,r.f27,r.f28,r.f29,r.f30,r.f31,r.f32,r.f33,r.f34,r.f35,r.f36,r.f37,r.f38,r.f39,
r.f40,r.f41,r.f42,r.f43,r.f44,r.f45,r.f46,r.f47,r.f48,r.f49,r.f50,r.f51,r.f52,r.f53,r.f54,r.f55,r.f56,r.f57,r.f58,
r.f59,r.f60,r.f61,r.f62,r.f63,r.f64,r.f65,r.f66,r.f67,r.f68,r.f69,r.f70,r.f71,r.f72,r.f73,r.f74,r.f75,r.f76,r.f77,
r.f78,r.f79,r.f80,r.f81,r.f82,r.f83,r.f84,r.f85,r.f86,r.f87,r.f88,r.f89,r.f90,r.f91,r.f92,r.f93,r.f94,r.f95,r.f96,r.f97);
	end loop;
	return l_my_table_tab;
  end;
  /

select * from table(cast(g_my_table5 as LONG_ARR));
drop TYPE LONG_OBJ force;
drop TYPE LONG_ARR force;
drop function g_my_table2;
drop TABLE LONG_TABLE;

--DTS2019112712284
CREATE OR REPLACE PACKAGE PAK1
IS
 FUNCTION MYF RETURN INT;
 PROCEDURE MYP;
END;
/
create or replace package body PAK1 is 
FUNCTION MYF RETURN INT is 
V1 INT :=10;
BEGIN
RETURN V1 ;
END;
B? MYP is 
V1 INT;
BEGIN
SELECT MYF INTO V1 FROM SYS_DUMMY;
dbe_output.print_line(V1);
END;
END;
/
create or replace package body PAK1 is 
FUNCTION MYF RETURN INT is 
V1 INT :=10;
BEGIN
RETURN V1 ;
END;
B? MYP is 
V1 INT;
BEGIN
SELECT MYF INTO V1 FROM SYS_DUMMY;
dbe_output.print_line(V1);
END;
END;
/

--DTS2019122303990
drop table if exists t_userinfo_test;
create table t_userinfo_test(phonenumber varchar2(100),userid int);
insert into t_userinfo_test(phonenumber ,userid) values('15600000014',1);
commit;
create or replace function f_di_test_rowtype
(
    str_in_phonenumber        in varchar2,
    rec_o_userinfo      out t_userinfo_test%rowtype
) return integer as
str_operationdetails varchar2(1000);
begin
select *
  into rec_o_userinfo
  from t_userinfo_test a
where phonenumber = str_in_phonenumber;
dbe_output.print_line('userid is ' || rec_o_userinfo.userid );
return 1;
exception
when no_data_found then
         return 0;
end f_di_test_rowtype;
/
declare
  str_in_phonenumber         varchar2(100) := '15600000014';
  rec_o_userinfo       t_userinfo_test%rowtype;
  return_value            integer;
begin
         return_value := f_di_test_rowtype(str_in_phonenumber, rec_o_userinfo);
         if rec_o_userinfo is not null then
                   dbe_output.print_line('Test userid is ' || rec_o_userinfo.userid);
         end if;
end;
/
drop function f_di_test_rowtype;
drop table t_userinfo_test;

--DTS2019122801871
drop table if exists VV;
create table VV(id int,name varchar(10),sal int);
insert into VV values(1,'xiaohong',100);
insert into VV values(2,'xiaowang',200);
insert into VV values(3,'xiaolei',300);
insert into VV values(4,'xiaozhang',400);
insert into VV values(5,'xili',600);
drop table if exists CC;
create table CC(id int,name varchar(10),sal int);
insert into CC values(1,'ss',444);
drop table if exists dd;
create table dd(sal int);
insert into dd values(100),(200),(100),(500),(200);
commit;
set serveroutput on;
drop trigger if exists wq;
create or replace trigger wq before insert on VV as
a int;
b int;
l sys_refcursor;
v vv.id%type;
cursor k is select vv.id from vv,cc where vv.id>cc.id and length(vv.name)>4;
begin
a:=1;
b:=0;
for i in (select id from vv where sal > (select avg(sal) from dd) )
  loop
     a:=a+1;
    if
       a<4 then
       insert into cc values(4,'as',40);
    dbe_output.print_line('a='||a||'b='||b);
   else
     b:=b+1;
   for i in k loop
     open l for select id from vv;
        fetch l into v;
         dbe_output.print_line('result is'|| v);
         close l;
   end loop;
   dbe_output.print_line('a='||a||'b='||b);
   end if;
  end loop;
end;
/
create or replace function CREATE_FUNCTION_003_FUN_01  return char is
begin
insert into VV values(9,'cxz',700);
return 'a';
end;
/
select * from vv;
select CREATE_FUNCTION_003_FUN_01;
drop function CREATE_FUNCTION_003_FUN_01;
drop trigger wq;
drop table VV;
drop table CC;
drop table dd;

--DTS2019122807199
drop function if exists TEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST;
CREATE OR REPLACE FUNCTION TEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST(a int, b int) RETURN INT
  AS
    c INT;
  BEGIN
       c := a * b * a * 4;
  RETURN c;
END;
/
select count(*) from table(dba_proc_decode('SYS', 'TEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST', 'FUNCTION'));
drop function TEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST;
drop function if exists TEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST_;
select count(*) from table(dba_proc_decode('SYS', 'TEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST_FOR_LOOP_FTEST_', 'FUNCTION'));

drop table if exists t_user;
create table t_user(aa varchar(10));
create or replace procedure p_test(str_phonenumber  t_user.aa%type)
is
begin
    null;
end;
/
call p_test('123456789123456789');
drop procedure p_test;
drop table t_user;
drop table if exists rec_table_test;
create table rec_table_test(c1 varchar(5));
create or replace procedure rec_proc_test(p1 rec_table_test%rowtype) is
begin
 dbe_output.print_line(p1.c1);
end;
/
declare
type xxx is record (f1 varchar(7));
v1 xxx;
begin
 v1.f1 := '1234567';
 rec_proc_test(v1);
end;
/
drop procedure rec_proc_test;
drop table rec_table_test;

--DTS2020010605246
create or replace package pkg_test is
    function f_isobject_exist(str_objname    varchar2, str_objecttype varchar2)
    return boolean;
    procedure drop_object(str_objname varchar2, str_objecttype varchar2);
end pkg_test;
/
create or replace package body pkg_test is   
    function f_isobject_exist(str_objname    varchar2, str_objecttype varchar2)
    return boolean as i_cnt integer;
    begin
        select count(*) into i_cnt from user_objects where object_name = upper(str_objname) and object_type = upper(str_objecttype);
        if i_cnt > 0 then
           return true;
        else
           return false;
        end if;
        exception
            when others then
                 null;
    end f_isobject_exist;
    procedure drop_object(str_objname varchar2, str_objecttype varchar2) as
        str_l_statement varchar2(4000);        
    begin
        if (f_isobject_exist(str_objname, str_objecttype)) then
            null;
        end if;
    end;
end pkg_test;
/

--DTS2020010611233
drop table if exists T_PROvbnC_temp_18 ;
create table T_PROvbnC_temp_18 
(
c_int int primary key,
c_number number,
c_varchar varchar(80),
c_date date
);
insert into T_PROvbnC_temp_18 values(3,3.12345,'   红绿灯','2018-8-8');
CREATE OR REPLACE PROCEDURE PROC_DML_TRUNCATE_PROC_18()
IS
v_refcur1 sys_refcursor;
c_cur1 date :='2018-8-8';
b_sql varchar(100);
BEGIN  
				execute immediate '
				BEGIN  
				open :1 for select c_date from #T_PROvbnC_temp_18 where c_date=c_cur1;
				dbe_sql.return_cursor(v_refcur1);
				END'using v_refcur1 ;
				
END;
/
exec PROC_DML_TRUNCATE_PROC_18;
drop PROCEDURE PROC_DML_TRUNCATE_PROC_18;
drop table if exists T_PROvbnC_temp_18 ;

--compile with procedure variables
DROP TABLE IF EXISTS T_UPDATE_1;
CREATE TABLE T_UPDATE_1 (F_INT1 INT, F_INT2 INT, F_CHAR CHAR(16), F_DATE varchar(20));
INSERT INTO T_UPDATE_1 VALUES(1,11,'A','2017-12-11 14:08:00');
INSERT INTO T_UPDATE_1 VALUES(2,22,'B','2017-12-12 16:08:00');
INSERT INTO T_UPDATE_1 VALUES(1,11,'A','2017-12-11 14:08:00');
INSERT INTO T_UPDATE_1 VALUES(3,33,'C','2017-12-13 15:08:20');
INSERT INTO T_UPDATE_1 VALUES(2,23,'B','2017-12-12 16:08:00');
DROP TABLE IF EXISTS T_UPDATE_2;
CREATE TABLE T_UPDATE_2 (F_INT1 INT, F_INT2 INT, F_CHAR CHAR(16), F_DATE DATE);
INSERT INTO T_UPDATE_2 VALUES(2,22,'C','2017-12-12 16:08:00');
INSERT INTO T_UPDATE_2 VALUES(1,11,'A','2017-12-11 14:08:00');
INSERT INTO T_UPDATE_2 VALUES(2,22,'C','2017-12-12 16:08:00');
DROP TABLE IF EXISTS T_UPDATE_3;
CREATE TABLE T_UPDATE_3 (F_INT1 INT, F_INT2 INT, F_CHAR CHAR(16), F_DATE varchar(20));
INSERT INTO T_UPDATE_3 VALUES(1,11,'A','2017-12-11 14:08:00');
INSERT INTO T_UPDATE_3 VALUES(2,22,'B','2017-12-12 16:08:00');
INSERT INTO T_UPDATE_3 VALUES(2,23,'B','2017-12-12 16:08:00');
COMMIT;

CREATE OR REPLACE PROCEDURE test_update2 (Na in CHAR, app in INT) AS 
ta varchar(20);
BEGIN
UPDATE T_UPDATE_1 T1 JOIN (SELECT T_UPDATE_1.F_INT1 aa FROM T_UPDATE_2 join T_UPDATE_1 on T_UPDATE_1.F_INT1 = T_UPDATE_2.F_INT1 where T_UPDATE_2.F_INT1 = app) T2 ON T2.aa=T1.F_INT1 and T1.F_CHAR = Na SET T1.F_DATE='0000-00-00 00:00:00';
select F_DATE into ta from T_UPDATE_1 where F_INT1 = 2 and F_CHAR = 'B' limit 1;
dbe_output.print_line(ta);
END;
/
call test_update2('B', 2);

CREATE OR REPLACE PROCEDURE test_delete2 (Na in int, app in INT) AS 
BEGIN
DELETE T_UPDATE_3 FROM (SELECT T_UPDATE_1.F_INT1 id FROM T_UPDATE_2 join T_UPDATE_1 on T_UPDATE_1.F_INT1 = T_UPDATE_2.F_INT1 where T_UPDATE_2.F_INT1 = app) T2 JOIN T_UPDATE_3 on T_UPDATE_3.F_INT1 = t2.id and T_UPDATE_3.F_INT2 = Na;
END;
/
call test_delete2(23, 2);
select * from T_UPDATE_3;
drop procedure test_delete2;
drop procedure test_update2;
DROP TABLE T_UPDATE_1;
DROP TABLE T_UPDATE_2;
DROP TABLE T_UPDATE_3;

create table PUB_ORG_INFO(ORGANIZATION_CODE VARCHAR2(36) not null);
CREATE OR REPLACE TYPE "T_PERM_ORG_ROW" Force as object(organization_code varchar2(36));
/
create or replace type t_perm_org is table of t_perm_org_row;
/
declare 
i int;
begin
for k in 1..50 loop
 insert into PUB_ORG_INFO values('fff');
end loop;
end;
/
CREATE OR REPLACE FUNCTION PERM_AUTHORIZEDORG_TABLE_F (l_current_user VARCHAR2,l_App_Id Varchar2) RETURN t_perm_org 
IS 
orgs t_perm_org := t_perm_org();
type v_type is table of varchar2(400);
v_tab v_type;
BEGIN
SELECT org.organization_code BULK COLLECT INTO v_tab FROM pub_org_info org;
for x in 1 .. v_tab.count loop
orgs.extend;
end loop;
RETURN orgs;
END;
/
select * from table(cast(PERM_AUTHORIZEDORG_TABLE_F('d','d') as t_perm_org));
drop TYPE "T_PERM_ORG_ROW" Force;
drop type t_perm_org force;
drop FUNCTION PERM_AUTHORIZEDORG_TABLE_F;
drop table PUB_ORG_INFO;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists cf_test cascade;
create user cf_test identified by Cantian_234;
grant create session to cf_test;
grant create procedure to cf_test;
conn cf_test/Cantian_234@127.0.0.1:1611
call liuhang_nouser.dbe_output.print_line('expect wrong');
call SYS.dbe_output.print_line('print right');
call Sys.dbe_output.print_line('print right');
call Sys.dbe_output.print_line('print right');
call public.dbe_output.print_line('expect wrong');

conn sys/Huawei@123@127.0.0.1:1611
grant all privileges to cf_test;
conn cf_test/Cantian_234@127.0.0.1:1611
create or replace function test_sub_two_int (x integer, y uinteger) 
return integer as
language c library test name "sub_two_int"
/
select flags,lib_user,lib_name from sys.sys_procs where name=upper('test_sub_two_int') and user# in (select user_id from v$me);
create or replace function test_sub_two_int(x integer, y uinteger) 
return integer
as
begin
null;
end;
/
select flags,lib_user,lib_name from sys.sys_procs where name=upper('test_sub_two_int') and user# in (select user_id from v$me);
create or replace function test_sub_two_int (x integer, y uinteger) 
return integer as
language c library test name "sub_two_int"
/
select flags,lib_user,lib_name from sys.sys_procs where name=upper('test_sub_two_int') and user# in (select user_id from v$me);
create or replace function test_sub_two_int(x integer, y uinteger) 
return integer
as
begin
null;
end;
/
select flags,lib_user,lib_name from sys.sys_procs where name=upper('test_sub_two_int') and user# in (select user_id from v$me);

CREATE OR REPLACE TYPE type_item_manpower_input force is OBJECT(plan number(8,2));
/
CREATE OR REPLACE TYPE type_item_manpower_input force is OBJECT(table number(8,2));
/
CREATE OR REPLACE TYPE type_item_manpower_input force is OBJECT(rowid number(8,2));
/
CREATE OR REPLACE TYPE type_item_manpower_input force is OBJECT(rowscn number(8,2));
/


--test global udt with %type %rowtype
drop table if exists t_type;
create table t_type(a1 int,a2 varchar(8000));
create or replace type udt1 is table of t_type%rowtype;
/
create or replace type udt2 is table of t_type.a2%type;
/
create or replace type udt3 is varray(10) of t_type%rowtype;
/
create or replace type udt4 is varray(10) of t_type.a2%type;
/

declare
v1 udt1 :=udt1();
v2 udt2 :=udt2();
v3 udt3 :=udt3();
v4 udt4 :=udt4();
begin
v1.extend(10);
v2.extend(10);
v3.extend(10);
v4.extend(10);
v1(1).a2 :='hello world1';
v2(2) :='hello world2';
v3(3).a2 :='hello world3';
v4(4) :='hello world4';
dbe_output.print_line(v1(1).a2);
dbe_output.print_line(v2(2));
dbe_output.print_line(v3(3).a2);
dbe_output.print_line(v4(4));
end;
/
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists cf_test cascade;

CREATE OR REPLACE PACKAGE PAK_DEFAULT_2020 IS 
FUNCTION AAA RETURN INT; 
FUNCTION BBB(a VARCHAR2, b VARCHAR2 default null) RETURN INT ; 
END; 
/ 
CREATE OR REPLACE PACKAGE BODY PAK_DEFAULT_2020 IS 
FUNCTION AAA RETURN INT 
IS 
V1 INT := 10;
 BEGIN  
 NULL;  
 RETURN V1; 
 END; 
FUNCTION BBB(a VARCHAR2, b VARCHAR2 default null) RETURN INT  IS
V1 INT; 
BEGIN  
SELECT AAA INTO  V1 FROM DUAL;  
RETURN 1; 
END; 
END; 
/ 
drop  PACKAGE PAK_DEFAULT_2020 ;

--DTS2020042113190
DROP TABLE IF EXISTS PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412;
create table PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412
(
c_int int primary key,
c_number number,
c_varchar varchar(80),
c_date date
);
insert into PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 values
(1,1.25,'abcd','2015-5-5');
insert into PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 values
(2,2.25,'你好','2016-6-6');
insert into PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 values
(3,3.25,'交通法则','2018-8-8');
insert into PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 values
(4,4.25,'工程力学','2019-9-9');

alter system set LOCAL_TEMPORARY_TABLE_ENABLED=true;
drop table if exists #PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_0987;
--创建临时表
create temporary table #PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_0987
(
c_int int,
c_number number,
c_varchar varchar(80),
c_date date
);
insert into #PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_0987 values
(1,1.12345,'aaa','2015-5-5');
insert into #PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_0987 values
(2,2.12345,'shengming','2016-6-6');
insert into #PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_0987 values
(3,3.12345,'   红绿灯','2018-8-8');
insert into #PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_0987 values
(4,4.12345,'物理  ','2019-9-9');

create or replace  procedure proc_PROC_FOR_LOOP_IFELSE_DYNAMICSTSTEMENT098765( c_name in out varchar) is
 i int :=0;
begin
        LOOP
         i := i+1;
                if i<=1 then
                        dbe_output.print_line(c_name);
                        c_name := 'xiaolaohu';
                elsif i >= 2 then
                if i = 2 then
                        dbe_output.print_line(upper(c_name));
                else
                dbe_output.print_line(length(c_name));
                exit when i> 4;
                end if;
                end if;

        end loop;
end;
/

declare
d_name varchar2(20);
begin
d_name :='1234';
proc_PROC_FOR_LOOP_IFELSE_DYNAMICSTSTEMENT098765(d_name);
DBE_OUTPUT.PRINT_LINE(d_name);
end;
 /

--创建存储过程
create or replace procedure proc_PROC_FOR_LOOP_IFELSE_DYNAMICSTSTEMENT002()
 as
b_bigint bigint:=0;
b_varchar varchar(15):='df';
b_date date :='2000-1-1';
b_temp int :=1;
str  varchar(15):='abc';
a int :=1;
b int :=1;
c int :=1;
emp_nofound_exception exception;
begin
  loop
     select upper(c_varchar) ,to_char(c_date), c_int into b_varchar,b_date,b_bigint from PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 
	 where c_int in (select c_int from #PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_0987 where c_int=b_temp);
      DBE_OUTPUT.PRINT(b_varchar);
          DBE_OUTPUT.PRINT(b_date);
      b_temp :=b_temp + 1;
            if ((b_temp-2+1)*2+1)  < 5 then
        DBE_OUTPUT.PRINT(b_bigint);
                update PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 set c_varchar = '123as' where c_int = 1;
                update PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 set c_varchar = 'haha' where c_int = 2;
                update PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 set c_date = '2019-1-1' where c_int = 2;
        elsif 2*(b_temp-1)-length(str)/3>=3  then
               if b_temp=3 then
                DBE_OUTPUT.PRINT_LINE('value2:'||b_bigint);
                     elsif b_temp = 4 then
                     execute immediate 'select c_int,c_varchar,c_date from PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 where c_int = :c_int or c_int = 0+1 or c_int= to_number(1) '
                 into b_bigint, b_varchar,b_date using in a;
                 dbe_output.print_line(b_bigint || ' ' || b_varchar|| ' ' ||b_date);
                                 execute immediate'truncate table PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412';
                                 execute immediate 'insert into PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 values(1,1.00,''wuli'',''2015-1-1'')';
                 execute immediate 'insert into PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 values(2,2.25,''yuwen'',''2012-2-2'')';
                 execute immediate 'insert into PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 values(3,3.25,''shuxue'',''2013-3-3'')';
                 execute immediate 'insert into PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 values(4,4.25,''yingyu'',''2014-1-1'')';
                                 execute immediate 'insert into PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 values(5,5.25,''huaxue'',''2015-5-5'')';
                                 execute immediate 'insert into PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 values(6,6.25,''shengwu'',''2016-6-6'')';
                                 execute immediate 'insert into PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 values(7,7.25,''shengwu'',''2016-6-6'')';
                                 execute immediate 'insert into #PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_0987 values(5,5.2530,'' 化学'',''2015-5-5'')';
                                 execute immediate 'insert into #PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_0987 values(6,6.2532,''生物 '',''2016-6-6'')';
                                 execute immediate 'delete from  PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 where c_int = 7 ';
                                 execute immediate 'update PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 set c_int = c_int + 10 where c_int = 3';
                                 execute immediate 'update PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 set c_varchar = ''数学'' where c_int = 3';
                         execute immediate 'update PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 set c_varchar = ''英语  '' where c_int = 4';
                         execute immediate 'update PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 set c_date = ''2019-9-9'' where c_int = 3';
                                 execute immediate 'update PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 set c_date = ''2018-8-8'' where c_int = 4';
                                 --动态语句 call proc(简单参数)
                                 execute immediate 'declare d_name varchar2(20);begin proc_PROC_FOR_LOOP_IFELSE_DYNAMICSTSTEMENT098765(d_name);DBE_OUTPUT.PRINT_LINE(d_name);end;';
                                 else
                                   update PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 set c_int = 9 where c_int = 8;
                    if sql%notfound then
                                        raise emp_nofound_exception;
                                else
                                        dbe_output.print_line('ok');
                                end if;
                     END IF;
         end if;
      EXIT when b_temp > 5;
      DBE_OUTPUT.PRINT_LINE(' AFTER EXIT ');
  END LOOP;
   exception
                                        when emp_nofound_exception then
                                        dbe_output.print_line('o my god 异常了：'||'no emp found!');
    if rtrim( str) ='abc' then
                     execute immediate'truncate table PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412';
                                 execute immediate 'insert into PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 values(1,1.25,''abcd'',''2015-5-5'')';
                                 execute immediate 'insert into PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 values(2,2.25,''你好'',''2016-6-6'')';
                                 execute immediate 'insert into PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 values(3,3.25,''交通法则'',''2018-8-8'')';
                                 execute immediate 'insert into PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412 values(4,4.25,''工程力学'',''2019-9-9'')';
                                 commit;
                 execute immediate'truncate table #PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_0987';

                 execute immediate'insert into #PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_0987 values(1,1.12345,''aaa'',''2015-5-5'')';
                 execute immediate'insert into #PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_0987 values(2,2.12345,''shengming'',''2016-6-6'')';
                 execute immediate'insert into #PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_0987 values(3,3.12345,''   红绿灯'',''2018-8-8'')';
                 execute immediate'insert into #PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_0987 values(4,4.12345,''物理  '',''2019-9-9'')';
                                 commit;
        else
        DBE_OUTPUT.PRINT('abc');
        end if;
 end ;
   /
exec proc_PROC_FOR_LOOP_IFELSE_DYNAMICSTSTEMENT002;
DROP TABLE IF EXISTS PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_4785412;
drop table if exists #PROC_FOR_LOOP_EXIT_DML_TRUNCATE_TAB_000_0987;
drop procedure proc_PROC_FOR_LOOP_IFELSE_DYNAMICSTSTEMENT098765;
drop procedure proc_PROC_FOR_LOOP_IFELSE_DYNAMICSTSTEMENT002;
declare
sql1 varchar(8000);
begin
for i in 1..100 loop
sql1 :='drop table if exists muchjoin'||i;
execute immediate sql1;
sql1 :='create table muchjoin'||i||'(a int,b int)';
execute immediate sql1;
end loop;

sql1 := 'explain select * from muchjoin1';
for i in 2..100 loop
sql1 := sql1|| ' left join muchjoin'||i|| ' on muchjoin'||(i-1)||'.a=muchjoin'||i||'.a';
execute immediate sql1;
end loop;
end;
/
set serveroutput off;