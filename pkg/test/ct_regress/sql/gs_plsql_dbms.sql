--
-- gs_plsql_DBE
-- testing system procedure
--

set serveroutput on;


--BEGIN:TEST ERROR, not allow to appear column
begin
dbe_output.print_line("-------------------");
end;
/
--END


--test for dbe_stats.AUTO_SAMPLE_SIZE and dbe_random.get_string
declare
a int;
c1 varchar2(20);
c2 varchar2(20);
c3 varchar2(20);
c4 varchar2(20);
c5 varchar2(20);
c6 varchar2(20);
c7 varchar2(20);
c8 varchar2(20);
c9 varchar2(20);
c10 varchar2(20);
c11 varchar2(20);
c12 varchar2(20);
begin
a := dbe_stats.AUTO_SAMPLE_SIZE;
c1 := dbe_random.get_string('u', 3);
c2 := dbe_random.get_string('U', 3);
c3 := dbe_random.get_string('l', 3);
c4 := dbe_random.get_string('L', 3);
c5 := dbe_random.get_string('a', 3);
c6 := dbe_random.get_string('A', 3);
c7 := dbe_random.get_string('x', 3);
c8 := dbe_random.get_string('X', 3);
c9 := dbe_random.get_string('p', 3);
c10 := dbe_random.get_string('P', 3);
c11 := dbe_random.get_string('P', 0);
c12 := dbe_random.get_string('1', (a+7)*2.3);
dbe_output.print_line(length(c1)||length(c2)||length(c3)||length(c4)||length(c5)||length(c6)||length(c7)||length(c8)||length(c9)||length(c10)||length(c11)||a);
dbe_output.print_line(length(c12));
end; 
/

select length(dbe_random.get_string('', 3));
select length(dbe_random.get_string('ab', 3));
select length(dbe_random.get_string('1', 3.1));
select length(dbe_random.get_string(NULL, 3));
select length(dbe_random.get_string(NULL, NULL));

select length(dbe_random.get_string(replace('2x','2',''),3)) from dual;
select dbe_random.get_string() from dual;
select dbe_random.get_string('u',) from dual;
select dbe_random.get_string(,1) from dual;
select dbe_random.get_string(,1,) from dual;

select dbe_random.get_string('u', -100) from dual;
select dbe_random.get_string('u', 0) from dual;
select length(dbe_random.get_string('u', 0)) from dual;

select length(dbe_random.get_string('u', 4001)) from dual;
select length(dbe_random.get_string('u', 4000)) from dual;
select length(dbe_random.get_string('u', 3999)) from dual;

select dbe_random.get_string() from dual;
select dbe_random.get_string('u',) from dual;
select dbe_random.get_string(,1) from dual;
select dbe_random.get_string('u',1,1) from dual;

--test for dbe_stats.AUTO_SAMPLE_SIZE and dbe_random.get_string
declare
c varchar2(20);
begin
c := dbe_random.get_string('k', 3);
dbe_output.print_line(length(c));
end; 
/

--test for dbe_stats.AUTO_SAMPLE_SIZE and dbe_random.get_string
declare
c varchar2(20);
begin
c2 := dbe_random.get_string('U', -1);
dbe_output.print_line(length(c));
end; 
/

--test for DBE_STATS.COLLECT_TABLE_STATS
drop table if exists test_gather;
create table test_gather(a int);

declare
c varchar2(20);
begin
c := dbe_random.get_string('U', 1);
DBE_STATS.COLLECT_TABLE_STATS(schema => 'SYS',name => 'test_gather');
DBE_STATS.PURGE_STATS(sysdate-5);
DBE_STATS.FLUSH_DB_STATS_INFO();
end; 
/

--expect right
execute DBE_STATS.COLLECT_TABLE_STATS(schema => 'SYS',name => 'test_gather');
execute DBE_STATS.COLLECT_TABLE_STATS('SYS','test_gather');
exec DBE_STATS.PURGE_STATS(sysdate-101);

--expect success
execute DBE_STATS.COLLECT_TABLE_STATS('SYS','test_gather', NULL, 0.000001);
--expect success
execute DBE_STATS.COLLECT_TABLE_STATS('SYS','test_gather', NULL, 0.000001, true);
execute DBE_STATS.COLLECT_TABLE_STATS('SYS','test_gather', NULL, 0.000001, false);
execute DBE_STATS.COLLECT_TABLE_STATS('SYS','test_gather', NULL, 100, true);
--expect error
execute DBE_STATS.COLLECT_TABLE_STATS('SYS','test_gather', NULL, 0.0000001);
execute DBE_STATS.COLLECT_TABLE_STATS('SYS','test_gather', NULL, 0.000001, null);
execute DBE_STATS.COLLECT_TABLE_STATS('SYS','test_gather', NULL, 100.00001, true);



drop table test_gather;


--test dbe_util.get_date_time
--begin
--expect success:2-0
declare
a number;
b number;
c int := 1;
begin
	a := dbe_util.get_date_time();
	b := dbe_util.get_date_time();
	if b-a < 2 then
	c := 0;
	end if;
	dbe_output.print_line(round(a/100000000000)||'-'||(b-a));
end;
/

--end

--test dbe_sql.return_cursor Procedure
--Example 7-11 dbe_sql.return_cursor Procedure
--begin
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

CREATE OR REPLACE PROCEDURE p_DBE AS
  c1 SYS_REFCURSOR;
  c2 SYS_REFCURSOR;
BEGIN
  OPEN c1 FOR
    SELECT first_name, last_name
    FROM employees
    WHERE employee_id > 0
    ORDER BY first_name, last_name;
 
  dbe_sql.return_cursor (c1);
  -- Now p cannot access the result.
 
  OPEN c2 FOR
    SELECT city, state_province
    FROM locations
    WHERE country_id = 'AU'
    ORDER BY city, state_province;
 
  dbe_sql.return_cursor (c2);
  -- Now p cannot access the result.
END;
/
BEGIN
  p_DBE();
END;
/

--end

--test return result set in function
--begin
drop table if exists employees;
create table employees(employeesno int,ename varchar(10),job varchar(10) ,sal integer);
insert into employees values(1,'zhangsan','doctor1',10000);
insert into employees values(2,'zhangsan2','doctor2',10010);
insert into employees values(123,'zhangsan3','doctor3',10020);
commit;

alter table employees add hiretime date;

create or replace function test_outf return sys_refcursor 
is 
cursorv1 sys_refcursor;
begin
open cursorv1 for select ename as name, sal, sal*2 ep_sal from employees where ename like 'zhangsan%' ;
return cursorv1;
end;
/

--expect error
declare
sys_cur1 sys_refcursor;
type XXX is record(
a varchar2(100),
b number(10,1),
c number(11,1)
);
var1 XXX;
begin
open sys_cur1 for select test_outf() from dual;
loop
fetch sys_cur1 into var1;
exit when sys_cur1%notfound;
dbe_output.print_line('line NO:'||sys_cur1%rowcount||': +'||var1.a||'+'||var1.b||'+'||var1.c); 
end loop;
close sys_cur1;
end;
/

--expect success and print result of set
select test_outf(), 1234 from dual;
--end

--test return invaild cursor
--begin
drop table if exists emp;
create table emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
insert into emp values(1,'zhansi','doctor1',10000),(2,'lisiabc','doctor2',10000),(123,'zhangwu123','doctor3',10000);
insert into emp values(10,'abc','worker',9000);
insert into emp values(716,'ZHANGSAN','leader',20000);
commit;

create or replace procedure p1 is 
   a emp%rowtype;
   v_refcur1 SYS_REFCURSOR;
begin
open v_refcur1 for   select * from emp where emp.ename like  'zhang%' ;
dbe_sql.return_cursor(v_refcur1); close v_refcur1;
open v_refcur1 for  select * from emp where emp.ename like  'zhang___';
dbe_sql.return_cursor(v_refcur1); close v_refcur1;
end;
/

--expect error
call p1();

create or replace procedure p1 is 
   v_refcur1 SYS_REFCURSOR;
   a   int := 1;
begin
open v_refcur1 for   select * from emp where emp.ename like  'zhang%' ;
dbe_sql.return_cursor(v_refcur1); 
   a := a/0;
end;
/

--expect error
call p1();

drop procedure if exists p1;
--end

--test: RETURN_CURSOR() can only be used in procedure or anonymous block
--begin
drop table if exists employees;
create table employees(employeesno int,ename varchar(10),job varchar(10) ,sal integer);

commit;

--expect error
create or replace function test_outf return sys_refcursor 
is 
cursorv1 sys_refcursor;
begin
open cursorv1 for select ename , sal, sal*2 ep_sal from employees where ename like 'zhangsan%' ;
dbe_sql.return_cursor(cursorv1)
end;
/
--end

--test:RETURN_CURSOR only support sysrefcursor
--begin
--expect error
CREATE or replace PROCEDURE proc AS
  cursor rc1 is SELECT 1 FROM dual;
BEGIN
  OPEN rc1;
  dbe_sql.return_cursor(rc1);
END;
/
--end

--test: one sys_refcursor can be return only once.
create or replace procedure p1(f1 in int) is 
   v_refcur2 SYS_REFCURSOR;
begin
open v_refcur2 for   select  sal,f1*sal  from emp where ename like '%zhangsan%' and sal > 9000;
dbe_sql.return_cursor(v_refcur2); 
dbe_sql.return_cursor(v_refcur2); 
dbe_sql.return_cursor(v_refcur2); 
end;
/

--expect error
exec p1(2);

--test the max result set size is 300:dts DTS2018081003915
--begin
CREATE OR REPLACE PROCEDURE test_proc AS
  rc1 sys_refcursor;
BEGIN
  OPEN rc1 FOR SELECT 1 FROM dual;
  dbe_sql.return_cursor(rc1);
END;
/ 

CREATE OR REPLACE PROCEDURE test_proc_2 AS
  rc1 sys_refcursor;
BEGIN
  OPEN rc1 FOR SELECT 2 FROM dual;
  dbe_sql.return_cursor(rc1);
END;
/ 

--expect error
declare
v_refcur2      SYS_REFCURSOR;
begin
open v_refcur2  for   SELECT 1 FROM dual;
dbe_sql.return_cursor(v_refcur2); 
for i in 1..1000
loop
test_proc();
test_proc_2();
end loop;
end;
/

--expect success
declare
v_refcur2      SYS_REFCURSOR;
v_refcur3      SYS_REFCURSOR;
begin
open v_refcur2  for   SELECT 1 FROM dual;
open v_refcur3  for   SELECT 2 FROM dual;
dbe_sql.return_cursor(v_refcur2); 
dbe_sql.return_cursor(v_refcur3);

end;
/


CREATE OR REPLACE PROCEDURE test_proc AS
BEGIN
  execute immediate 'declare rc sys_refcursor; begin open rc for select 1 from dual; dbe_sql.return_cursor(rc); end;';
END;
/ 

--expect error
begin
test_proc();
end;
/
--end

--test max number of put_line:8192
CREATE OR REPLACE PROCEDURE test_proc_1(a int) AS
BEGIN
  dbe_output.print_line(a);
END;
/ 

--expect error
set serveroutput off
begin
dbe_output.print_line(0);
for i in 1..8192
loop
test_proc_1(i);
end loop;
end;
/

--expect error
begin
dbe_output.print_line(0);
for i in 1..8193
loop
execute immediate 'begin dbe_output.print_line(0);end;';
end loop;
end;
/


CREATE OR REPLACE PROCEDURE test_proc_1(a int) AS
BEGIN
  dbe_output.print_line(a);
  execute immediate 'begin dbe_output.print_line(0);end;';
END;
/ 

--expect error
begin
for i in 1..4097
loop
	test_proc_1(i);
end loop;
end;
/

--expect success
begin
for i in 1..4096
loop
	test_proc_1(i);
end loop;
end;
/

set serveroutput on;
--end
--test the counter of stmt has been reset
--expect success
begin
dbe_output.print_line(0);
for i in 1..1
loop
test_proc_1(i);
end loop;
end;
/
--end

--test dbe_random.get_values
--begin
select dbe_random.get_value(0) from dual;
select dbe_random.get_value(0, 'a') from dual;
select dbe_random.get_value(0, 1, 1) from dual;

select 1 from dual where (select dbe_random.get_value from dual) between 0 and 1;
select 1 from dual where (select dbe_random.get_value from dual) < 1;
select 1 from dual where (select dbe_random.get_value() from dual) between 0 and 1;
select 1 from dual where (select dbe_random.get_value() from dual) < 1;
select 1 from dual where (select dbe_random.get_value(1, 10.5) from dual) between 1 and 10.5;
select 1 from dual where (select dbe_random.get_value(1, 10.5) from dual) < 10.5;
select 1 from dual where (select dbe_random.get_value(1, -10.5) from dual) between -10.5 and 1;
select 1 from dual where (select dbe_random.get_value(1, -10.5) from dual) > -10.5;

--DTS2018082211480
select dbe_random.get_value(null,null);
select dbe_random.get_value(2,null);
select dbe_random.get_value(null, 2);
--end

--DBE_LOB.SUBSTR
select TO_CHAR(rawtohex(DBE_LOB.SUBSTR())) from dual;
select TO_CHAR(rawtohex(DBE_LOB.SUBSTR('CERTPIC'))) from dual;
select TO_CHAR(rawtohex(DBE_LOB.SUBSTR('CERTPIC',4))) from dual;
select TO_CHAR(rawtohex(DBE_LOB.SUBSTR('CERTPIC',4,1))) from dual;

--test return result and close the cursor
--begin
CREATE OR REPLACE PROCEDURE proc_1(a int) AS
  rc1 sys_refcursor;
  rc2 sys_refcursor;
BEGIN
  OPEN rc1 FOR SELECT 1 FROM dual where a > 1;
  dbe_sql.return_cursor(rc1);
  close rc1;
  OPEN rc2 FOR SELECT 2 FROM dual where a > 1;
  dbe_sql.return_cursor(rc2);
END;
/ 

--expect error
exec proc_1(2);

CREATE OR REPLACE PROCEDURE proc_2(a int) AS
  rc1 sys_refcursor;
  rc2 sys_refcursor;
BEGIN
  OPEN rc1 FOR SELECT 1 FROM dual where a > 1;
  dbe_sql.return_cursor(rc1);
  OPEN rc2 FOR SELECT 2 FROM dual where a > 1;
  dbe_sql.return_cursor(rc2);
  close rc2;
END;
/ 

--expect error
exec proc_2(2);

create or replace procedure p1(v_nePhyID   IN NUMBER) as
   SWC_Current SYS_REFCURSOR;
   SWC_Current2 SYS_REFCURSOR;
   v_p  NUMBER(19,0);
   SWP_Ret_Value number;
BEGIN
   open SWC_Current for SELECT 1 from dual where v_nePhyID > 1;
   dbe_sql.return_cursor(SWC_Current);   
   CLOSE SWC_Current;
END;
/

--expect error
exec p1(2);
--end

drop user if exists GS_PL_DBE cascade;
create user GS_PL_DBE identified by root_1234;
grant dba to GS_PL_DBE;
GRANT SELECT ON SYS.SYS_TABLES TO GS_PL_DBE;
GRANT SELECT ON SYS.SYS_COLUMNS TO GS_PL_DBE;
GRANT SELECT ON SYS.SYS_HISTGRAM_ABSTR TO GS_PL_DBE;
GRANT SELECT ON SYS.SYS_DML_STATS TO GS_PL_DBE;
GRANT SELECT ON SYS.SYS_INDEXES TO GS_PL_DBE;
conn GS_PL_DBE/root_1234@127.0.0.1:1611

drop table if exists tbl_stat;

create table tbl_stat
(
f1 int,
f2 varchar2(16)
);

create index idx_tbl_stat_f1 on tbl_stat(f1);

insert into tbl_stat values(1, 'mike');
insert into tbl_stat values(1, 'bob');
insert into tbl_stat values(1, 'backham');
insert into tbl_stat values(1, 'own');
insert into tbl_stat values(2, 'bc');
insert into tbl_stat values(3, 'abc');
insert into tbl_stat values(3, 'zk');
insert into tbl_stat values(3, 'aq');
insert into tbl_stat values(4, 'bob');
insert into tbl_stat values(4, 'aq');
insert into tbl_stat values(4, 'zk');
insert into tbl_stat values(4, 'mike');
insert into tbl_stat values(4, 'pike');
insert into tbl_stat values(4, 'mike');
insert into tbl_stat values(4, 'mike');
insert into tbl_stat values(11, 'mike');
insert into tbl_stat values(11, 'bob');
insert into tbl_stat values(11, 'backham');
insert into tbl_stat values(11, 'own');
insert into tbl_stat values(12, 'bc');
insert into tbl_stat values(13, 'abc');
insert into tbl_stat values(13, 'zk');
insert into tbl_stat values(13, 'aq');
insert into tbl_stat values(14, 'bob');
insert into tbl_stat values(14, 'aq');
insert into tbl_stat values(14, 'zk');
insert into tbl_stat values(14, 'mike');
insert into tbl_stat values(14, 'pike');


SELECT A.NUM_ROWS, A.AVG_ROW_LEN  FROM SYS.SYS_TABLES A , DV_ME M WHERE A.NAME='TBL_STAT' AND A.USER#=M.USER_ID;
SELECT C.NUM_DISTINCT, C.LOW_VALUE,C.HIGH_VALUE,C.HISTOGRAM FROM SYS.SYS_TABLES A , DV_ME M, SYS.SYS_COLUMNS C WHERE A.NAME='TBL_STAT' AND A.USER#=M.USER_ID AND C.USER#=M.USER_ID AND C.TABLE#=A.ID ORDER BY C.ID;
SELECT H.ROW_NUM, H.NULL_NUM,H.MINVALUE, H.MAXVALUE,H.DIST_NUM,H.DENSITY FROM SYS.SYS_TABLES A , DV_ME M, SYS.SYS_HISTGRAM_ABSTR H
 WHERE A.NAME='TBL_STAT' AND A.USER#=M.USER_ID AND H.USER#=M.USER_ID AND H.TAB#=A.ID
 ORDER BY H.USER#, H.TAB#, H.COL#;
select H.* from sys.SYS_TABLES A , DV_ME M, sys.SYS_DML_STATS h
 where A.name='TBL_STAT' AND A.USER#=M.USER_ID and h.user#=m.user_id and h.table#=a.id;

insert into tbl_stat values(14, 'mike');
call DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE','tbl_stat'); 
SELECT A.NUM_ROWS, A.AVG_ROW_LEN  FROM SYS.SYS_TABLES A , V$ME M WHERE A.NAME='TBL_STAT' AND A.USER#=M.USER_ID;

insert into tbl_stat values(14, 'mike');
exec DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE','tbl_stat');
SELECT A.NUM_ROWS, A.AVG_ROW_LEN  FROM SYS.SYS_TABLES A , V$ME M WHERE A.NAME='TBL_STAT' AND A.USER#=M.USER_ID;

exec DBE_STATS.COLLECT_TABLE_STATS('gs_pl_DBE','tbl_stat');
exec DBE_STATS.COLLECT_TABLE_STATS('gs_pl_DBE','TBL_STAT');
exec DBE_STATS.COLLECT_TABLE_STATS('gs_pl_DBE1','TBL_STAT1');
exec DBE_STATS.COLLECT_TABLE_STATS('gs_pl_DBE1');
exec DBE_STATS.COLLECT_TABLE_STATS('gs_pl_DBE','TBL_STAT',3);
exec DBE_STATS.COLLECT_TABLE_STATS(,'TBL_STAT',3);
exec DBE_STATS.COLLECT_TABLE_STATS(NULL,'TBL_STAT',3);
exec DBE_STATS.COLLECT_TABLE_STATS(NULL,'TBL_STAT');
exec DBE_STATS.COLLECT_TABLE_STATS(NULL,NULL,3);
exec DBE_STATS.COLLECT_TABLE_STATS(NULL,NULL,NULL);
exec DBE_STATS.COLLECT_TABLE_STATS(NULL);
exec DBE_STATS.COLLECT_TABLE_STATS (schema=>'GS_PL_DBE', name=>'tbl_stat');

SELECT A.NUM_ROWS, A.AVG_ROW_LEN  FROM SYS.SYS_TABLES A , DV_ME M WHERE A.NAME='TBL_STAT' AND A.USER#=M.USER_ID;
SELECT C.NUM_DISTINCT, C.LOW_VALUE,C.HIGH_VALUE,C.HISTOGRAM FROM SYS.SYS_TABLES A , DV_ME M, SYS.SYS_COLUMNS C WHERE A.NAME='TBL_STAT' AND A.USER#=M.USER_ID AND C.USER#=M.USER_ID AND C.TABLE#=A.ID ORDER BY C.ID;
SELECT H.ROW_NUM, H.NULL_NUM,H.MINVALUE, H.MAXVALUE,H.DIST_NUM,H.DENSITY FROM SYS.SYS_TABLES A , DV_ME M, SYS.SYS_HISTGRAM_ABSTR H
 WHERE A.NAME='TBL_STAT' AND A.USER#=M.USER_ID AND H.USER#=M.USER_ID AND H.TAB#=A.ID
 ORDER BY H.USER#, H.TAB#, H.COL#;
select H.DISTINCT_KEYS from sys.SYS_TABLES A , DV_ME M, sys.SYS_INDEXES h
 where A.name='TBL_STAT' AND A.USER#=M.USER_ID and h.user#=m.user_id and h.table#=a.id;
select H.* from sys.SYS_TABLES A , DV_ME M, sys.SYS_DML_STATS h
 where A.name='TBL_STAT' AND A.USER#=M.USER_ID and h.user#=m.user_id and h.table#=a.id;

select SAMPLE_SIZE, decode(LAST_ANALYZED, null,0,1) from all_tables where table_NAME='TBL_STAT';
select SAMPLE_SIZE, decode(LAST_ANALYZED, null,0,1) from dba_tables where table_NAME='TBL_STAT';
select SAMPLE_SIZE, decode(LAST_ANALYZED, null,0,1) from user_tables where table_NAME='TBL_STAT';


drop table if exists tbl_stat1;
create table tbl_stat1
(
f1 int,
f2 varchar2(16)
);

create index idx_tbl_stat1_f1 on tbl_stat1(f1);

insert into tbl_stat1 values(31, 'mike');
insert into tbl_stat1 values(31, 'bobs');
insert into tbl_stat1 values(41, 'backhams');
insert into tbl_stat1 values(41, 'ownd');
insert into tbl_stat1 values(52, 'bcd');
insert into tbl_stat1 values(63, 'abcz');
insert into tbl_stat1 values(33, 'zk2');
insert into tbl_stat1 values(3, 'aq');
insert into tbl_stat1 values(24, 'bob');
insert into tbl_stat1 values(44, 'aq');
insert into tbl_stat1 values(34, 'zks');
insert into tbl_stat1 values(4, 'mike');
insert into tbl_stat1 values(4, 'pike');
commit; 

exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE');
exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE', 0.000001);
exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE', 100);
exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE', 100, true);
exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE', 100, false);
exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE', 100, null);
exec DBE_STATS.COLLECT_SCHEMA_STATS('gs_pl_DBE');
exec DBE_STATS.COLLECT_SCHEMA_STATS('');
exec DBE_STATS.COLLECT_SCHEMA_STATS();
exec DBE_STATS.COLLECT_SCHEMA_STATS(NULL);
exec DBE_STATS.COLLECT_SCHEMA_STATS(null);

--expect error
exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE', 0.0000001);
exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE', 100.001);

SELECT A.NUM_ROWS, A.AVG_ROW_LEN  FROM SYS.SYS_TABLES A , DV_ME M WHERE A.NAME LIKE 'TBL_STAT%' AND A.USER#=M.USER_ID ORDER BY A.NAME;
SELECT C.NUM_DISTINCT, C.LOW_VALUE,C.HIGH_VALUE,C.HISTOGRAM FROM  DV_ME M, SYS.SYS_COLUMNS C,SYS.SYS_TABLES A  
WHERE A.NAME LIKE 'TBL_STAT%' AND A.USER#=M.USER_ID AND C.USER#=M.USER_ID AND C.TABLE#=A.ID ORDER BY A.NAME;
SELECT H.ROW_NUM, H.NULL_NUM,H.MINVALUE, H.MAXVALUE,H.DIST_NUM,H.DENSITY FROM DV_ME M, SYS.SYS_HISTGRAM_ABSTR H,SYS.SYS_TABLES A 
 WHERE A.NAME LIKE 'TBL_STAT%' AND A.USER#=M.USER_ID AND H.USER#=M.USER_ID AND H.TAB#=A.ID
 ORDER BY H.USER#, A.NAME, H.COL#;
SELECT H.DISTINCT_KEYS FROM DV_ME M, SYS.SYS_INDEXES H,SYS.SYS_TABLES A 
 WHERE A.NAME LIKE 'TBL_STAT%' AND A.USER#=M.USER_ID AND H.USER#=M.USER_ID AND H.TABLE#=A.ID;
SELECT H.* FROM SYS.SYS_TABLES A , DV_ME M, SYS.SYS_DML_STATS H
 WHERE A.NAME LIKE 'TBL_STAT%' AND A.USER#=M.USER_ID AND H.USER#=M.USER_ID AND H.TABLE#=A.ID;

select DBE_STATS.FLUSH_DB_STATS_INFO() from dual;

--test temp table will be gather
CREATE GLOBAL TEMPORARY TABLE DBE_PL_T1(
f1 int,
f2 varchar2(16)
);
insert into DBE_PL_T1 values(24, 'bob');
insert into DBE_PL_T1 values(44, 'aq');
insert into DBE_PL_T1 values(34, 'zks');
insert into DBE_PL_T1 values(4, 'mike');
insert into DBE_PL_T1 values(4, 'pike');
commit; 
exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE');
SELECT A.NUM_ROWS, A.AVG_ROW_LEN  FROM SYS.SYS_TABLES A where a.name ='DBE_PL_T1';

drop table if exists TBL_STAT;
drop table if exists TBL_STAT1;

conn sys/Huawei@123@127.0.0.1:1611

--test COLLECT_SCHEMA_STATS
--begin
drop user if exists wms cascade;
create user wms identified by Cantian_234;
grant create session,create table to wms;
grant dba to wms;
GRANT SELECT ON SYS.SYS_TABLES TO WMS;
GRANT SELECT ON SYS.SYS_COLUMNS TO WMS;
GRANT SELECT ON SYS.SYS_HISTGRAM_ABSTR TO WMS;
GRANT SELECT ON SYS.SYS_DML_STATS TO WMS;
GRANT SELECT ON SYS.SYS_INDEXES TO WMS;
conn wms/Cantian_234@127.0.0.1:1611

CREATE TABLE DBE_T1(A INT);
INSERT INTO DBE_T1 VALUES(2);
select table_name,num_rows,AVG_ROW_LEN ,EMPTY_BLOCKS from all_tables where table_name='DBE_T1';
select table_name,num_rows,AVG_ROW_LEN ,EMPTY_BLOCKS from all_tables where table_name='DBE_T1';

CREATE TABLE DBE_T2(A INT);
INSERT INTO DBE_T2 VALUES(2);
select table_name,num_rows,AVG_ROW_LEN ,EMPTY_BLOCKS from all_tables where table_name='DBE_T2';
call DBE_STATS.COLLECT_TABLE_STATS('wms','DBE_T2');
select table_name,num_rows,AVG_ROW_LEN ,EMPTY_BLOCKS from all_tables where table_name='DBE_T2';
DROP TABLE IF EXISTS DBE_T2;

--test purge_stats
--begin

--test syntax
EXEC DBE_STATS.PURGE_STATS();
EXEC DBE_STATS.PURGE_STATS(null);
EXEC DBE_STATS.PURGE_STATS(sysdate, null);
EXEC DBE_STATS.PURGE_STATS('2017-01-01');
EXEC DBE_STATS.PURGE_STATS(to_date('2004-05-07','yyyy-mm-dd'));
EXEC DBE_STATS.PURGE_STATS(to_date('2004-05-07 13:23:44','yyyy-mm-dd hh24:mi:ss'));
EXEC DBE_STATS.PURGE_STATS(sysdate + 1);

DROP TABLE IF EXISTS TBL_STAT;
CREATE TABLE TBL_STAT
(
F1 INT,
F2 VARCHAR2(16)
);

CREATE INDEX IDX_TBL_STAT_F1 ON TBL_STAT(F1);

INSERT INTO TBL_STAT VALUES(31, 'MIKE');
INSERT INTO TBL_STAT VALUES(31, 'BOBS');
INSERT INTO TBL_STAT VALUES(41, 'BACKHAMS');
INSERT INTO TBL_STAT VALUES(41, 'OWND');
INSERT INTO TBL_STAT VALUES(52, 'BCD');
INSERT INTO TBL_STAT VALUES(63, 'ABCZ');
INSERT INTO TBL_STAT VALUES(33, 'ZK2');
INSERT INTO TBL_STAT VALUES(3, 'AQ');
INSERT INTO TBL_STAT VALUES(24, 'BOB');
INSERT INTO TBL_STAT VALUES(44, 'AQ');
INSERT INTO TBL_STAT VALUES(34, 'ZKS');
INSERT INTO TBL_STAT VALUES(4, 'MIKE');
INSERT INTO TBL_STAT VALUES(4, 'PIKE');
COMMIT; 

DROP TABLE IF EXISTS TBL_STAT1;
CREATE TABLE TBL_STAT1
(
F1 INT,
F2 VARCHAR2(16)
);

CREATE INDEX IDX_TBL_STAT1_F1 ON TBL_STAT1(F1);

INSERT INTO TBL_STAT1 VALUES(123331, 'MIDAFDAKE');
INSERT INTO TBL_STAT1 VALUES(123331, 'BODAFBS');
INSERT INTO TBL_STAT1 VALUES(123341, 'OWDAFDND');
INSERT INTO TBL_STAT1 VALUES(123333, 'ZDAFK2');
INSERT INTO TBL_STAT1 VALUES(12333, 'ADAFQ');
INSERT INTO TBL_STAT1 VALUES(123324, 'BDAFOB');
INSERT INTO TBL_STAT1 VALUES(123334, 'FDAZKS');
INSERT INTO TBL_STAT1 VALUES(12334, 'MIFDAKE');
COMMIT; 

SELECT NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_ROW_LEN,SAMPLESIZE FROM SYS.SYS_TABLES WHERE NAME IN ('TBL_STAT','TBL_STAT1') ORDER BY NAME;
SELECT NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,HISTOGRAM FROM SYS.SYS_COLUMNS A, SYS.SYS_TABLES B WHERE A.TABLE#=B.ID AND A.USER#=B.USER# AND
 B.NAME IN ('TBL_STAT','TBL_STAT1') ORDER BY B.NAME, A.ID;
SELECT BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,
        AVG_DATA_BLOCKS_PER_KEY,EMPTY_LEAF_BLOCKS,CLUFAC 
		FROM SYS.SYS_INDEXES A, SYS.SYS_TABLES B WHERE A.TABLE#=B.ID AND A.USER#=B.USER# AND B.NAME IN ('TBL_STAT','TBL_STAT1') ORDER BY B.NAME, A.ID;
SELECT BUCKET_NUM,ROW_NUM,NULL_NUM, MINVALUE,MAXVALUE,DIST_NUM,DENSITY  FROM SYS.SYS_HISTGRAM_ABSTR A, SYS.SYS_TABLES B WHERE A.TAB#=B.ID AND A.USER#=B.USER# AND B.NAME IN ('TBL_STAT','TBL_STAT1') ORDER BY B.NAME, A.COL#;

EXEC DBE_STATS.COLLECT_SCHEMA_STATS('WMS');

SELECT NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_ROW_LEN,SAMPLESIZE FROM SYS.SYS_TABLES WHERE NAME IN ('TBL_STAT','TBL_STAT1') ORDER BY NAME;
SELECT NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,HISTOGRAM FROM SYS.SYS_COLUMNS A, SYS.SYS_TABLES B WHERE A.TABLE#=B.ID AND A.USER#=B.USER# AND
 B.NAME IN ('TBL_STAT','TBL_STAT1') ORDER BY B.NAME, A.ID;
SELECT BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,
        AVG_DATA_BLOCKS_PER_KEY,EMPTY_LEAF_BLOCKS,CLUFAC
		FROM SYS.SYS_INDEXES A, SYS.SYS_TABLES B WHERE A.TABLE#=B.ID AND A.USER#=B.USER# AND B.NAME IN ('TBL_STAT','TBL_STAT1') ORDER BY B.NAME, A.ID;
SELECT BUCKET_NUM,ROW_NUM,NULL_NUM, MINVALUE,MAXVALUE,DIST_NUM,DENSITY  FROM SYS.SYS_HISTGRAM_ABSTR A, SYS.SYS_TABLES B WHERE A.TAB#=B.ID AND A.USER#=B.USER# AND B.NAME IN ('TBL_STAT','TBL_STAT1') ORDER BY B.NAME, A.COL#;

EXEC DBE_STATS.PURGE_STATS(SYSTIMESTAMP);

SELECT NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_ROW_LEN,SAMPLESIZE FROM SYS.SYS_TABLES WHERE NAME IN ('TBL_STAT','TBL_STAT1') ORDER BY NAME;
SELECT NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,HISTOGRAM FROM SYS.SYS_COLUMNS A, SYS.SYS_TABLES B WHERE A.TABLE#=B.ID AND A.USER#=B.USER# AND
 B.NAME IN ('TBL_STAT','TBL_STAT1') ORDER BY B.NAME, A.ID;
SELECT BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,
        AVG_DATA_BLOCKS_PER_KEY,EMPTY_LEAF_BLOCKS,CLUFAC
		FROM SYS.SYS_INDEXES A, SYS.SYS_TABLES B WHERE A.TABLE#=B.ID AND A.USER#=B.USER# AND B.NAME IN ('TBL_STAT','TBL_STAT1') ORDER BY B.NAME, A.ID;
SELECT BUCKET_NUM,ROW_NUM,NULL_NUM, MINVALUE,MAXVALUE,DIST_NUM,DENSITY  FROM SYS.SYS_HISTGRAM_ABSTR A, SYS.SYS_TABLES B WHERE A.TAB#=B.ID AND A.USER#=B.USER# AND B.NAME IN ('TBL_STAT','TBL_STAT1') ORDER BY B.NAME, A.COL#;

--END

--TEST DBE_UTIL.COMPILE_SCHEMA
--begin
--create user wms identified by Cantian_234;
--grant create session,create table to wms;
--grant dba to wms;
--conn wms/Cantian_234@127.0.0.1:1611
DROP TABLE IF EXISTS DBE_T1;
DROP TABLE IF EXISTS DBE_T2;
DROP VIEW IF EXISTS DBE_V1;
DROP VIEW IF EXISTS DBE_V2;
DROP VIEW IF EXISTS DBE_V3;
DROP VIEW IF EXISTS DBE_V4;
DROP VIEW IF EXISTS DBE_T1;
DROP SYNONYM IF EXISTS DBE_S1;
DROP SYNONYM IF EXISTS DBE_S2;
DROP PROCEDURE IF EXISTS DBE_P1;
DROP PROCEDURE IF EXISTS DBE_P2;
CREATE TABLE DBE_T1 (A INT);
CREATE TABLE DBE_T2 (A INT);
CREATE VIEW DBE_V1 AS SELECT * FROM DBE_T1;
CREATE VIEW DBE_V2 AS SELECT * FROM DBE_V1;
CREATE OR REPLACE SYNONYM DBE_S1 FOR DBE_T1;
CREATE OR REPLACE SYNONYM DBE_S2 FOR DBE_V1;
CREATE VIEW DBE_V3 AS SELECT * FROM DBE_S2;
CREATE VIEW DBE_V4 AS SELECT * FROM DBE_V2;

CREATE OR REPLACE PROCEDURE DBE_P1(A INT)
AS
C INT := 1;
D VARCHAR2(20) := '2';
BEGIN
	SELECT count(*) INTO C FROM DBE_S2;
END;
/

CREATE OR REPLACE PROCEDURE DBE_P2
AS
C INT := 1;
D INT := 2;
BEGIN
  DBE_P1(c);
  SELECT COUNT(*) INTO D FROM DBE_T1;
END;
/

select OBJECT_NAME,OBJECT_TYPE, STATUS from user_objects where OBJECT_NAME LIKE 'DBE%' ORDER BY OBJECT_NAME;


DROP TABLE DBE_T1;
select OBJECT_NAME,OBJECT_TYPE, STATUS from user_objects where OBJECT_NAME LIKE 'DBE%' ORDER BY OBJECT_NAME;

CREATE VIEW DBE_T1 AS SELECT * FROM DBE_T2;
conn sys/Huawei@123@127.0.0.1:1611
EXEC DBE_UTIL.COMPILE_SCHEMA('WMS', FALSE);
conn wms/Cantian_234@127.0.0.1:1611
select OBJECT_NAME,OBJECT_TYPE, STATUS from user_objects where OBJECT_NAME LIKE 'DBE%' ORDER BY OBJECT_NAME;
select * from user_dependencies where NAME LIKE 'DBE%' ORDER BY name, referenced_name;

DROP VIEW DBE_T1;
select OBJECT_NAME,OBJECT_TYPE, STATUS from user_objects where OBJECT_NAME LIKE 'DBE%' ORDER BY OBJECT_NAME;

conn sys/Huawei@123@127.0.0.1:1611
EXEC DBE_UTIL.COMPILE_SCHEMA('WMS', FALSE);

conn wms/Cantian_234@127.0.0.1:1611
select OBJECT_NAME,OBJECT_TYPE, STATUS from user_objects where OBJECT_NAME LIKE 'DBE%' ORDER BY OBJECT_NAME;
select * from user_dependencies where NAME LIKE 'DBE%' ORDER BY name, referenced_name;
--end


--test dbe_stats.delete_table_stats
--begin
exec dbe_stats.delete_table_stats();
exec dbe_stats.delete_table_stats(1);
exec dbe_stats.delete_table_stats('SYS','TABLE');
exec dbe_stats.delete_table_stats('SYS','TABLE', TRUE);
exec dbe_stats.delete_table_stats('SYS','TABLE', NULL);

exec dbe_stats.delete_table_stats('SYS','SYS_TABLES');

create global temporary table TBL_STAT_TEMP(id int, description varchar(400)) ON COMMIT preserve ROWS; 

insert into TBL_STAT_TEMP values(1, 'aaaaaaa'), (3, 'bbbb'), (5, 'xxxxxx');
commit;

DROP TABLE IF EXISTS TBL_STAT;
CREATE TABLE TBL_STAT
(
F1 INT,
F2 VARCHAR2(16)
);

CREATE INDEX IDX_TBL_STAT_F1 ON TBL_STAT(F1);

INSERT INTO TBL_STAT VALUES(1, 'MIKE');
INSERT INTO TBL_STAT VALUES(1, 'BOB');
INSERT INTO TBL_STAT VALUES(14, 'MIKE');
COMMIT;

exec DBE_STATS.COLLECT_TABLE_STATS(schema => 'WMS',name => 'TBL_STAT');
exec DBE_STATS.COLLECT_TABLE_STATS(schema => 'WMS',name => 'TBL_STAT_TEMP');
SELECT A.NAME, A.NUM_ROWS, A.AVG_ROW_LEN  FROM SYS.SYS_TABLES A , DV_ME M WHERE A.NAME like 'TBL_STAT%' AND A.USER#=M.USER_ID ORDER BY NUM_ROWS;
SELECT C.NUM_DISTINCT, C.LOW_VALUE,C.HIGH_VALUE,C.HISTOGRAM FROM SYS.SYS_TABLES A , DV_ME M, SYS.SYS_COLUMNS C WHERE A.NAME='TBL_STAT' AND A.USER#=M.USER_ID AND C.USER#=M.USER_ID AND C.TABLE#=A.ID ORDER BY C.ID;
SELECT H.ROW_NUM, H.NULL_NUM,H.MINVALUE, H.MAXVALUE,H.DIST_NUM,H.DENSITY FROM SYS.SYS_TABLES A , DV_ME M, SYS.SYS_HISTGRAM_ABSTR H
 WHERE A.NAME='TBL_STAT' AND A.USER#=M.USER_ID AND H.USER#=M.USER_ID AND H.TAB#=A.ID
 ORDER BY H.USER#, H.TAB#, H.COL#;
select H.DISTINCT_KEYS from sys.SYS_TABLES A , DV_ME M, sys.SYS_INDEXES h
 where A.name='TBL_STAT' AND A.USER#=M.USER_ID and h.user#=m.user_id and h.table#=a.id;
select H.* from sys.SYS_TABLES A , DV_ME M, sys.SYS_DML_STATS h
 where A.name='TBL_STAT' AND A.USER#=M.USER_ID and h.user#=m.user_id and h.table#=a.id;

exec dbe_stats.delete_table_stats(schema => 'WMS',NAME => 'TBL_STAT');
exec dbe_stats.delete_table_stats(schema => 'WMS',NAME => 'TBL_STAT_TEMP');
SELECT A.NUM_ROWS, A.AVG_ROW_LEN  FROM SYS.SYS_TABLES A , DV_ME M WHERE A.NAME like 'TBL_STAT%' AND A.USER#=M.USER_ID ORDER BY NUM_ROWS;
SELECT C.NUM_DISTINCT, C.LOW_VALUE,C.HIGH_VALUE,C.HISTOGRAM FROM SYS.SYS_TABLES A , DV_ME M, SYS.SYS_COLUMNS C WHERE A.NAME='TBL_STAT' AND A.USER#=M.USER_ID AND C.USER#=M.USER_ID AND C.TABLE#=A.ID ORDER BY C.ID;
SELECT H.ROW_NUM, H.NULL_NUM,H.MINVALUE, H.MAXVALUE,H.DIST_NUM,H.DENSITY FROM SYS.SYS_TABLES A , DV_ME M, SYS.SYS_HISTGRAM_ABSTR H
 WHERE A.NAME='TBL_STAT' AND A.USER#=M.USER_ID AND H.USER#=M.USER_ID AND H.TAB#=A.ID
 ORDER BY H.USER#, H.TAB#, H.COL#;
select H.DISTINCT_KEYS from sys.SYS_TABLES A , DV_ME M, sys.SYS_INDEXES h
 where A.name='TBL_STAT' AND A.USER#=M.USER_ID and h.user#=m.user_id and h.table#=a.id;
select H.* from sys.SYS_TABLES A , DV_ME M, sys.SYS_DML_STATS h
 where A.name='TBL_STAT' AND A.USER#=M.USER_ID and h.user#=m.user_id and h.table#=a.id;
 
DROP TABLE IF EXISTS TBL_STAT;
DROP TABLE IF EXISTS TBL_STAT_TEMP;


--end

--test dbe_stats.delete_schema_stats
DROP TABLE IF EXISTS TBL_STAT1;
DROP TABLE IF EXISTS TBL_STAT2;
CREATE TABLE TBL_STAT1(F1 INT,F2 VARCHAR2(16));
CREATE TABLE TBL_STAT2(F1 INT,F2 VARCHAR2(16));

CREATE INDEX IDX_TBL_STAT_F1 ON TBL_STAT1(F1);

INSERT INTO TBL_STAT1 VALUES(1, 'MIKE');
INSERT INTO TBL_STAT1 VALUES(3, 'BOB');
INSERT INTO TBL_STAT2 VALUES(14, 'MIKE');
INSERT INTO TBL_STAT2 VALUES(1, 'MIKE');
INSERT INTO TBL_STAT2 VALUES(8, 'BOB');
INSERT INTO TBL_STAT2 VALUES(14, 'MIKE');
COMMIT;

exec DBE_STATS.COLLECT_SCHEMA_STATS('WMS');

exec DBE_STATS.DELETE_SCHEMA_STATS('WMS');
SELECT A.NUM_ROWS, A.AVG_ROW_LEN  FROM SYS.SYS_TABLES A , DV_ME M WHERE A.NAME LIKE 'TBL_STAT%' AND A.USER#=M.USER_ID ORDER BY A.NAME;
SELECT C.NUM_DISTINCT, C.LOW_VALUE,C.HIGH_VALUE,C.HISTOGRAM FROM SYS.SYS_TABLES A , DV_ME M, SYS.SYS_COLUMNS C WHERE A.NAME LIKE 'TBL_STAT%' AND A.USER#=M.USER_ID AND C.USER#=M.USER_ID AND C.TABLE#=A.ID ORDER BY C.TABLE#, C.ID;
SELECT H.ROW_NUM, H.NULL_NUM,H.MINVALUE, H.MAXVALUE,H.DIST_NUM,H.DENSITY FROM SYS.SYS_TABLES A , DV_ME M, SYS.SYS_HISTGRAM_ABSTR H
 WHERE A.NAME LIKE 'TBL_STAT%' AND A.USER#=M.USER_ID AND H.USER#=M.USER_ID AND H.TAB#=A.ID
 ORDER BY H.USER#, H.TAB#, H.COL#;
select H.DISTINCT_KEYS from sys.SYS_TABLES A , DV_ME M, sys.SYS_INDEXES h
 where A.name LIKE 'TBL_STAT%' AND A.USER#=M.USER_ID and h.user#=m.user_id and h.table#=a.id ORDER BY H.TABLE#,H.ID;
select H.* from sys.SYS_TABLES A , DV_ME M, sys.SYS_DML_STATS h
 where A.name LIKE 'TBL_STAT%' AND A.USER#=M.USER_ID and h.user#=m.user_id and h.table#=a.id ORDER BY H.TABLE#;
 
DROP TABLE IF EXISTS TBL_STAT1;
DROP TABLE IF EXISTS TBL_STAT2;
--end

conn sys/Huawei@123@127.0.0.1:1611

--test trigger can not execute dbe_stats
--begin
drop table if exists gs_dbe_ww;
create table gs_dbe_ww(a int);
create or replace trigger gs_dbe_TIGER_1 after insert on gs_dbe_ww
begin
dbe_stats.delete_schema_stats('sys');
end;
/

--expect error
insert into gs_dbe_ww values(3);

create or replace trigger gs_dbe_TIGER_1 after insert on gs_dbe_ww
begin
dbe_stats.delete_table_stats('sys','gs_dbe_ww');
end;
/

--expect error
insert into gs_dbe_ww values(3);

create or replace trigger gs_dbe_TIGER_1 after insert on gs_dbe_ww
begin
DBE_STATS.FLUSH_DB_STATS_INFO();
end;
/

--expect error
insert into gs_dbe_ww values(3);

create or replace trigger gs_dbe_TIGER_1 after insert on gs_dbe_ww
begin
DBE_STATS.COLLECT_SCHEMA_STATS('sys');
end;
/

--expect error
insert into gs_dbe_ww values(3);

create or replace trigger gs_dbe_TIGER_1 after insert on gs_dbe_ww
begin
DBE_STATS.COLLECT_TABLE_STATS('sys','gs_dbe_ww');
end;
/
--expect error
insert into gs_dbe_ww values(3);

create or replace trigger gs_dbe_TIGER_1 after insert on gs_dbe_ww
begin
DBE_STATS.PURGE_STATS(sysdate);
end;
/

--expect error
insert into gs_dbe_ww values(3);


create or replace trigger gs_dbe_TIGER_1 after insert on gs_dbe_ww
begin
   analyze table gs_dbe_ww compute statistics;
end;
/

--expect error
insert into gs_dbe_ww values(3);

drop table if exists gs_dbe_ww;
--end

--test scn&ssn in RETURN_CURSOR
--begin
drop table if exists dbe_test_t1;
create table dbe_test_t1(f1 int);
insert into dbe_test_t1 (f1) values(1);
commit;

CREATE OR REPLACE PROCEDURE dbe_test_proc AS
  rc1 sys_refcursor;
BEGIN  
  --OPEN rc1 FOR SELECT * FROM dbe_test_t1;
  --dbe_sql.return_cursor(rc1);
  insert into dbe_test_t1 (f1) values(3);
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;
  update dbe_test_t1 set f1 = 4;
  dbe_sql.return_cursor(rc1);
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;
  dbe_sql.return_cursor(rc1);
  update dbe_test_t1 set f1 = 2;
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;
  dbe_sql.return_cursor(rc1);
  --rollback;
  --commit;
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;
  dbe_sql.return_cursor(rc1);
END;
/ 

--expect 1, 3
--expect 4, 4
--expect 2, 2
--expect 2, 2
exec dbe_test_proc();


drop table if exists dbe_test_t1;
create table dbe_test_t1(f1 int);
insert into dbe_test_t1 (f1) values(1);
commit;  

CREATE OR REPLACE PROCEDURE dbe_test_proc AS
  rc1 sys_refcursor;
BEGIN  
  insert into dbe_test_t1 (f1) values(3);
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;  
  update dbe_test_t1 set f1 = 4;
  dbe_sql.return_cursor(rc1);
  OPEN rc1 FOR SELECT * FROM dbe_test_t1; 
  dbe_sql.return_cursor(rc1);
  update dbe_test_t1 set f1 = 2;
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;  
  dbe_sql.return_cursor(rc1);
  --rollback;
  commit;
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;
  dbe_sql.return_cursor(rc1);
END;
/ 

--ora
--expect 1, 3
--expect 4, 4
--expect 2, 2
--expect 2, 2
exec dbe_test_proc();

drop table if exists dbe_test_t1;
create table dbe_test_t1(f1 int);
insert into dbe_test_t1 (f1) values(1);
commit;

CREATE OR REPLACE PROCEDURE dbe_test_proc AS
  rc1 sys_refcursor;
BEGIN  
  insert into dbe_test_t1 (f1) values(3);
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;
  update dbe_test_t1 set f1 = 4;
  dbe_sql.return_cursor(rc1);
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;
  dbe_sql.return_cursor(rc1);
  update dbe_test_t1 set f1 = 2;
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;
  dbe_sql.return_cursor(rc1);
  rollback;
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;
  dbe_sql.return_cursor(rc1);
END;
/ 

--zenith
--ora will error ORA-01002
exec dbe_test_proc();

drop table if exists dbe_test_t1;
create table dbe_test_t1(f1 int);
insert into dbe_test_t1 (f1) values(1);
commit;

CREATE OR REPLACE PROCEDURE dbe_test_proc AS
  rc1 sys_refcursor;
BEGIN  
  insert into dbe_test_t1 (f1) values(3);
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;
  dbe_sql.return_cursor(rc1);
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;
  execute immediate 'drop table dbe_test_t1';  
  dbe_sql.return_cursor(rc1);
END;
/ 

--ora 
--expect 1, 3
--expect 1, 3
exec dbe_test_proc();
--end

--DTS2018122806030
--begin
drop table if exists dbe_test_t1;
create table dbe_test_t1(f1 int);
insert into dbe_test_t1 (f1) values(1);
commit;

CREATE OR REPLACE PROCEDURE dbe_test_proc AS
  rc1 sys_refcursor;
BEGIN  
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;
  dbe_sql.return_cursor(rc1);
  update dbe_test_t1 set f1 = 3;
END;
/ 

--ora 
--expect 1
exec dbe_test_proc();


drop table if exists dbe_test_t1;
create table dbe_test_t1(f1 int);
insert into dbe_test_t1 (f1) values(1);
commit;

CREATE OR REPLACE PROCEDURE dbe_test_proc AS
  rc1 sys_refcursor;
BEGIN  
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;
  dbe_sql.return_cursor(rc1);
  update dbe_test_t1 set f1 = 3;
  delete from dbe_test_t1;
  execute immediate 'drop table dbe_test_t1';  
END;
/ 

--ora 
--expect 1
exec dbe_test_proc();
--end

create or replace procedure DBE_P1()
as
a timestamp;
b timestamp;
a1 timestamp;
b1 timestamp;

begin
  a := systimestamp;
  sleep(1);
  b := systimestamp;
  if a != b then
  	dbe_output.print_line('true');  	
  else
  	dbe_output.print_line('false');
  end if;  
  
  select systimestamp,systimestamp into a1, b1 from dual;
  if a1 != b1 then
  	dbe_output.print_line('true');
  else
  	dbe_output.print_line('false');
  end if;  
  
  select systimestamp into a1 from dual;
  sleep(1);
  select systimestamp into b1 from dual;
  if a1 != b1 then
  	dbe_output.print_line('true');
  else
  	dbe_output.print_line('false');
  end if;  
end;
/

exec DBE_P1;
drop procedure DBE_P1;

--DTS2019010701347 
drop table if exists employees;
create table employees(employeesno int,ename varchar(10),job varchar(10) ,sal integer);
insert into employees values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10010),(123,'zhangsan3','doctor3',10020);
alter table employees add  hiretime datetime;
declare
type mycurtp  is  ref  cursor;
cur1 mycurtp;
cur2 mycurtp;
var1 employees%rowtype;
--f1  employees.employeesno%type :=1;
str1 varchar2(100);
begin
str1 := 'select * from employees where  EMPLOYEESNO = :f1 ';
open cur1 for str1 using 2  ;
cur2 := cur1;
fetch  cur2 into var1;
dbe_output.print_line(var1.ename||' sal:'||var1.sal);
close cur2;
end;
/
--DTS2019010409322 
alter system set LOCAL_TEMPORARY_TABLE_ENABLED=true;
create  user PROC_FOR_LOOP_JOIN_1_DML_USER_018_1 IDENTIFIED BY DATABASE_123 PASSWORD EXPIRE;
create  user PROC_FOR_LOOP_JOIN_1_DML_USER_018_2 IDENTIFIED BY DATABASE_123 PASSWORD EXPIRE;
create  user PROC_FOR_LOOP_JOIN_1_DML_USER_018_3 IDENTIFIED BY DATABASE_123 PASSWORD EXPIRE;
create  user PROC_FOR_LOOP_JOIN_1_DML_USER_018_4 IDENTIFIED BY DATABASE_123 PASSWORD EXPIRE;
--I1.create table
drop table if exists PROC_FOR_LOOP_JOIN_1_DML_USER_018_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018;
drop table if exists PROC_FOR_LOOP_JOIN_1_DML_USER_018_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_2;
drop table if exists PROC_FOR_LOOP_JOIN_1_DML_USER_018_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_3;
create table PROC_FOR_LOOP_JOIN_1_DML_USER_018_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018 
(
c_int int,
c_number number,
c_varchar varchar(4000),
c_date date
);
insert into PROC_FOR_LOOP_JOIN_1_DML_USER_018_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018 values
(1,1.25,'abcd','2015-5-5');
insert into PROC_FOR_LOOP_JOIN_1_DML_USER_018_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018 values
(2,2.25,'你好','2016-6-6');
insert into PROC_FOR_LOOP_JOIN_1_DML_USER_018_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018 values
(2,2.25,lpad('ab',75,'c'),'2017-7-7');
create table PROC_FOR_LOOP_JOIN_1_DML_USER_018_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_2 
(
c_int int,
c_number number,
c_varchar varchar(4000),
c_date date
)
partition by range (c_number)
(
partition p1 values less than (3),
partition p2 values less than (10)
);
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER_018_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_2 values
(1,1.12345,'aaa','2015-5-5');
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER_018_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_2 values
(2,2.12345,'shengming','2016-6-6');
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER_018_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_2 values
(2,2.25,lpad('ab',78,'c'),'2017-7-7');
create global temporary table PROC_FOR_LOOP_JOIN_1_DML_USER_018_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_3 
(
c_int int,
c_number number,
c_varchar varchar(4000),
c_date date
);
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER_018_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_3 values
(1,1.12345,'aaa','2015-5-5');
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER_018_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_3 values
(2,2.12345,'shengming','2016-6-6');
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER_018_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_3 values
(2,2.25,lpad('ab',78,'c'),'2017-7-7');
drop PROCEDURE if exists  PROC_FOR_LOOP_JOIN_1_DML_USER_018_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_018_1;
grant select on PROC_FOR_LOOP_JOIN_1_DML_USER_018_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_2 to PROC_FOR_LOOP_JOIN_1_DML_USER_018_1;
grant select on sys.SYS_TABLES to PROC_FOR_LOOP_JOIN_1_DML_USER_018_1;
grant update on PROC_FOR_LOOP_JOIN_1_DML_USER_018_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_2 to PROC_FOR_LOOP_JOIN_1_DML_USER_018_1;
CREATE OR REPLACE PROCEDURE  PROC_FOR_LOOP_JOIN_1_DML_USER_018_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_018_1()
IS
b_bigint bigint:=0;
c_cur1 date :='2016-6-6';
v_refcur1 sys_refcursor;
b_varchar varchar(15):='df';
b_date date :='2000-1-1';
b_temp int :=15;
b_sql varchar(2000);
BEGIN  
 for i in 
 (  select a.c_int from PROC_FOR_LOOP_JOIN_1_DML_USER_018_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018 as a  join  PROC_FOR_LOOP_JOIN_1_DML_USER_018_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_2 as b  where a.c_int =b.c_int and a.c_int<=2 )
  loop
    b_sql := 'drop table if exists PROC_FOR_LOOP_JOIN_1_DML_USER_018_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_3';
    execute immediate b_sql;
    b_sql :=' create global temporary table PROC_FOR_LOOP_JOIN_1_DML_USER_018_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_3 
(
c_int int,
c_number number,
c_varchar varchar(4000),
c_date date
)' ;
    execute immediate b_sql;
    select name  into b_sql from  sys.SYS_TABLES where name ='PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_3';
    dbe_output.print_line(b_sql);
    open v_refcur1 for select c_date from PROC_FOR_LOOP_JOIN_1_DML_USER_018_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018 where c_date=c_cur1;
    dbe_sql.return_cursor(v_refcur1);
 update PROC_FOR_LOOP_JOIN_1_DML_USER_018_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_018_2 set  c_varchar= '123456789';  
 end loop;
END;
/
call PROC_FOR_LOOP_JOIN_1_DML_USER_018_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_018_1();
call PROC_FOR_LOOP_JOIN_1_DML_USER_018_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_018_1();

drop user PROC_FOR_LOOP_JOIN_1_DML_USER_018_1 cascade;
drop user PROC_FOR_LOOP_JOIN_1_DML_USER_018_2 cascade;
drop user PROC_FOR_LOOP_JOIN_1_DML_USER_018_3 cascade;
drop user PROC_FOR_LOOP_JOIN_1_DML_USER_018_4 cascade;
--DTS2019010207906
create  user PROC_FOR_LOOP_JOIN_1_DML_USER1 IDENTIFIED BY DATABASE_123 PASSWORD EXPIRE;
create  user PROC_FOR_LOOP_JOIN_1_DML_USER2 IDENTIFIED BY DATABASE_123 PASSWORD EXPIRE;
create  user PROC_FOR_LOOP_JOIN_1_DML_USER3 IDENTIFIED BY DATABASE_123 PASSWORD EXPIRE;
create  user PROC_FOR_LOOP_JOIN_1_DML_USER4 IDENTIFIED BY DATABASE_123 PASSWORD EXPIRE;
--I1.create table
drop table if exists PROC_FOR_LOOP_JOIN_1_DML_USER1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011;
drop table if exists PROC_FOR_LOOP_JOIN_1_DML_USER2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_2;
drop table if exists PROC_FOR_LOOP_JOIN_1_DML_USER3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_3;
create table PROC_FOR_LOOP_JOIN_1_DML_USER1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011 
(
c_int int,
c_number number,
c_varchar varchar(80),
c_date date
);
insert into PROC_FOR_LOOP_JOIN_1_DML_USER1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011 values
(1,1.25,'abcd','2015-5-5');
insert into PROC_FOR_LOOP_JOIN_1_DML_USER1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011 values
(2,2.25,'你好','2016-6-6');
insert into PROC_FOR_LOOP_JOIN_1_DML_USER1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011 values
(2,2.25,lpad('ab',75,'c'),'2017-7-7');
create table PROC_FOR_LOOP_JOIN_1_DML_USER2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_2 
(
c_int int,
c_number number,
c_varchar varchar(80),
c_date date
)
partition by range (c_number)
(
partition p1 values less than (3),
partition p2 values less than (10)
);
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_2 values
(1,1.12345,'aaa','2015-5-5');
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_2 values
(2,2.12345,'shengming','2016-6-6');
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_2 values
(2,2.25,lpad('ab',78,'c'),'2017-7-7');
create global temporary table PROC_FOR_LOOP_JOIN_1_DML_USER3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_3 
(
c_int int,
c_number number,
c_varchar varchar(80),
c_date date
);
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_3 values
(2,2.25,lpad('ab',78,'c'),'2016-6-6');

drop PROCEDURE if exists  PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_1;
CREATE OR REPLACE PROCEDURE  PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_1()
IS
--declare
b_bigint bigint:=0;
c_cur1 date :='2016-6-6';
v_refcur1 sys_refcursor;
b_varchar varchar(15):='df';
b_date date :='2000-1-1';
b_temp int :=15;
b_sql varchar(2000);
BEGIN  
 for i in 
 (  select a.c_int from PROC_FOR_LOOP_JOIN_1_DML_USER1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011 as a  join  PROC_FOR_LOOP_JOIN_1_DML_USER2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_2 as b  where a.c_int =b.c_int and a.c_int<=3)
  loop
    insert into PROC_FOR_LOOP_JOIN_1_DML_USER3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_3 values (11,3.456,'eret','2145-8-9');
    b_sql := 'drop table if exists PROC_FOR_LOOP_JOIN_1_DML_USER3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_3';
    execute immediate b_sql;
    b_sql :=' create table PROC_FOR_LOOP_JOIN_1_DML_USER3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_3 
(
c_int int,
c_number number,
c_varchar varchar(80),
c_date date
)
partition by range (c_number)
(partition p2 values less than (10))' ;
    execute immediate b_sql;
    select name  into b_sql from  SYS_TABLES where name ='PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_3';
    dbe_output.print_line(b_sql);
    open v_refcur1 for select c_date from PROC_FOR_LOOP_JOIN_1_DML_USER1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011 where c_date=c_cur1;
    dbe_sql.return_cursor(v_refcur1);

    b_temp :=15;
    b_temp := b_temp-1;
    dbe_output.print_line(b_temp);
 
 end loop;
END;
/
call PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_1();
drop user PROC_FOR_LOOP_JOIN_1_DML_USER2 cascade;
call PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_1();
create  user PROC_FOR_LOOP_JOIN_1_DML_USER2 IDENTIFIED BY DATABASE_123 PASSWORD EXPIRE;
create table PROC_FOR_LOOP_JOIN_1_DML_USER2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_2 
(
c_int int,
c_number number,
c_varchar varchar(80),
c_date date
)
partition by range (c_number)
(
partition p1 values less than (3),
partition p2 values less than (10)
);
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_2 values
(1,1.12345,'aaa','2015-5-5');
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_2 values
(2,2.12345,'shengming','2016-6-6');
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_011_2 values
(2,2.25,lpad('ab',78,'c'),'2017-7-7');
call PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_1();
drop user PROC_FOR_LOOP_JOIN_1_DML_USER1 cascade;
drop user PROC_FOR_LOOP_JOIN_1_DML_USER2 cascade;
drop user PROC_FOR_LOOP_JOIN_1_DML_USER3 cascade;
drop user PROC_FOR_LOOP_JOIN_1_DML_USER4 cascade;

create or replace procedure xx_p2
as
begin
execute immediate 'drop table if exists xxxxx';
execute immediate 'create table xxxxx(a int)';
end;
/

create or replace function xx_f2 return int
as
begin
xx_p2;
return 1;
end;
/

select xx_f2 from dual;

declare
a int;
begin
a := xx_f2;
end;
/
drop table if exists xxxxx;

create or replace procedure xx_p1
as
begin
commit;
end;
/

create or replace function xx_f1 return int
as
begin
xx_p1;
return 1;
end;
/

select xx_f1 from dual;

declare
a int;
begin
a := xx_f1;
end;
/
--DTS2019010310372 
drop table if exists FVT_FUNCTION_DDL_001_T;
drop table if exists FVT_FUNCTION_DDL_001_T_02;
create table FVT_FUNCTION_DDL_001_T(id int,name varchar2(100));
create table FVT_FUNCTION_DDL_001_T_02(id int,name varchar2(100));
create or replace function  FVT_FUNCTION_DDL_001_Fun return int
is 
a int := 0;
begin
for i in  1..5
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
--DTS2019010503538 
drop table if exists FVT_FUNCTION_DDL_001_T;
drop table if exists FVT_FUNCTION_DDL_001_T_02;
create table FVT_FUNCTION_DDL_001_T(id int,name varchar2(100));
create table FVT_FUNCTION_DDL_001_T_02(id int,name varchar2(100));
create or replace function  FVT_FUNCTION_DDL_001_Fun() return int
is 
a int := 0;
begin
for i in  1..5
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

insert into FVT_FUNCTION_DDL_001_T_02 values (FVT_FUNCTION_DDL_001_Fun(),'function');
update FVT_FUNCTION_DDL_001_T_02 set id = FVT_FUNCTION_DDL_001_Fun() + 3;
insert into FVT_FUNCTION_DDL_001_T_02 values(1,'123');
update FVT_FUNCTION_DDL_001_T_02 set id = FVT_FUNCTION_DDL_001_Fun() + 3;

--test dbe with =>
--begin
drop user if exists gs_dbe cascade;
create user gs_dbe identified by root_1234;
grant dba to gs_dbe;
conn gs_dbe/root_1234@127.0.0.1:1611

create table TMP_CELL_A0JM (f1 int, f2 varchar(32), f3 date);
create index idx_f1_tep_A0JM on TMP_CELL_A0JM(f1);
create index idx_f2_tep_A0JM on TMP_CELL_A0JM(f2);

insert into TMP_CELL_A0JM(f1, f2, f3) values(10002, 'mike', '2018-12-20');
insert into TMP_CELL_A0JM(f1, f2, f3) values(10003, 'backham', '2018-12-20');
insert into TMP_CELL_A0JM(f1, f2, f3) values(10004, 'mike', '2018-12-21');
insert into TMP_CELL_A0JM(f1, f2, f3) values(10002, 'coco', '2018-12-20');
insert into TMP_CELL_A0JM(f1, f2, f3) values(10004, 'johndan', '2018-12-20');
commit;


begin DBE_STATS.COLLECT_TABLE_STATS( schema=>'gs_dbe', name=>'TMP_CELL_A0JM', part_name=>NULL, sample_ratio => 10, method_opt=>'for all indexed columns'); end;
/

begin DBE_STATS.COLLECT_TABLE_STATS( schema=>'gs_dbe', name=>'TMP_CELL_A0JM', part_name=>NULL, sample_ratio => 10, method_opt=>'for all indexed columns'); end;
/

begin DBE_STATS.COLLECT_TABLE_STATS( schema=>'gs_dbe', name=>'TMP_CELL_A0JM', part_name=>NULL, sample_ratio => 10, method_opt=>'for all indexed columns'); end;
/

exec DBE_STATS.COLLECT_SCHEMA_STATS
(
	schema          => 'gs_dbe',
	sample_ratio => dbe_stats.AUTO_SAMPLE_SIZE,
	method_opt       => 'for all columns size repeat'
);

exec DBE_STATS.COLLECT_SCHEMA_STATS
(
	schema          => 'gs_dbe',
	sample_ratio => 30,
	method_opt       => 'for all columns size repeat'
);

exec DBE_STATS.COLLECT_SCHEMA_STATS
(
	schema          => 'gs_dbe',
	sample_ratio => 30,
	method_opt       => 'for all columns size repeat'
);


--end

--test DBE_UTIL.compile_schema priv
--begin
--expect success
exec DBE_UTIL.compile_schema('GS_PL_DBE');

conn gs_dbe/root_1234@127.0.0.1:1611
exec DBE_UTIL.compile_schema('GS_PL_DBE');

conn sys/Huawei@123@127.0.0.1:1611
revoke dba from wms;
conn wms/Cantian_234@127.0.0.1:1611
exec DBE_UTIL.compile_schema('wms');

--expect error
exec DBE_UTIL.compile_schema('GS_PL_DBE');
--end

--test DBE_STATS priv
--begin
--expect error
conn wms/Cantian_234@127.0.0.1:1611
exec DBE_STATS.COLLECT_SCHEMA_STATS('gs_dbe');
exec dbe_stats.delete_schema_stats('gs_dbe');
exec DBE_STATS.COLLECT_SCHEMA_STATS('wms');
exec dbe_stats.delete_schema_stats('wms');
exec DBE_STATS.COLLECT_TABLE_STATS('gs_dbe', 'TMP_CELL_A0JM');
exec dbe_stats.delete_table_stats('gs_dbe', 'TMP_CELL_A0JM');

--expect success
conn sys/Huawei@123@127.0.0.1:1611
exec DBE_STATS.COLLECT_SCHEMA_STATS('gs_dbe');
exec dbe_stats.delete_schema_stats('gs_dbe');
exec DBE_STATS.COLLECT_TABLE_STATS('gs_dbe', 'TMP_CELL_A0JM');
exec dbe_stats.delete_table_stats('gs_dbe', 'TMP_CELL_A0JM');

grant dba to wms;
conn wms/Cantian_234@127.0.0.1:1611
exec DBE_STATS.COLLECT_SCHEMA_STATS('gs_dbe');
exec dbe_stats.delete_table_stats('gs_dbe');
exec DBE_STATS.COLLECT_TABLE_STATS('gs_dbe', 'TMP_CELL_A0JM');
exec dbe_stats.delete_table_stats('gs_dbe', 'TMP_CELL_A0JM');
exec DBE_STATS.PURGE_STATS(sysdate-1);

conn sys/Huawei@123@127.0.0.1:1611
revoke dba from wms;
grant select any table to wms;
conn wms/Cantian_234@127.0.0.1:1611
CREATE TABLE dbe_STAT_T1(A INT);
exec DBE_STATS.COLLECT_SCHEMA_STATS('gs_dbe');
exec dbe_stats.delete_table_stats('gs_dbe');
exec DBE_STATS.COLLECT_TABLE_STATS('gs_dbe', 'TMP_CELL_A0JM');
exec dbe_stats.delete_table_stats('gs_dbe', 'TMP_CELL_A0JM');
exec DBE_STATS.FLUSH_DB_STATS_INFO ();
analyze table wms.dbe_STAT_T1 compute statistics;
analyze table gs_dbe.TMP_CELL_A0JM compute statistics;
analyze table sys.test_gather compute statistics;

conn sys/Huawei@123@127.0.0.1:1611
create table test_gather(a int);
revoke select any table from wms;
grant analyze any to wms;
conn wms/Cantian_234@127.0.0.1:1611
exec DBE_STATS.COLLECT_SCHEMA_STATS('gs_dbe');
exec dbe_stats.delete_table_stats('gs_dbe');
exec DBE_STATS.COLLECT_TABLE_STATS('gs_dbe', 'TMP_CELL_A0JM');
exec dbe_stats.delete_table_stats('gs_dbe', 'TMP_CELL_A0JM');
exec DBE_STATS.PURGE_STATS(sysdate-1);
exec DBE_STATS.FLUSH_DB_STATS_INFO ();
exec DBE_STATS.COLLECT_SCHEMA_STATS('sys');
exec dbe_stats.delete_table_stats('sys');
exec DBE_STATS.COLLECT_TABLE_STATS('sys', 'test_gather');
exec dbe_stats.delete_table_stats('sys', 'test_gather');
analyze table wms.dbe_STAT_T1 compute statistics;
analyze table gs_dbe.TMP_CELL_A0JM compute statistics;
analyze table sys.test_gather compute statistics;

conn sys/Huawei@123@127.0.0.1:1611
revoke analyze any from wms;
exec DBE_STATS.COLLECT_SCHEMA_STATS('gs_dbe');
exec dbe_stats.delete_table_stats('gs_dbe');
exec DBE_STATS.COLLECT_TABLE_STATS('gs_dbe', 'TMP_CELL_A0JM');
exec dbe_stats.delete_table_stats('gs_dbe', 'TMP_CELL_A0JM');
exec DBE_STATS.PURGE_STATS(sysdate-1);
exec DBE_STATS.FLUSH_DB_STATS_INFO ();
exec DBE_STATS.COLLECT_SCHEMA_STATS('sys');
exec dbe_stats.delete_table_stats('sys');
exec DBE_STATS.COLLECT_TABLE_STATS('sys', 'test_gather');
exec dbe_stats.delete_table_stats('sys', 'test_gather');
analyze table wms.dbe_STAT_T1 compute statistics;
analyze table gs_dbe.TMP_CELL_A0JM compute statistics;
analyze table sys.test_gather compute statistics;
drop table if exists test_gather;


--test estimate_percent is 0
--begin
drop table if exists tbl_sta;
CREATE TABLE tbl_sta(
     id int,
     DATA VARCHAR2(20)
 );
insert into tbl_sta values(61, 'a1');
insert into tbl_sta values(71, 'aq');
insert into tbl_sta values(81, 'aa');
commit; 

exec DBE_STATS.COLLECT_TABLE_STATS(schema=>'sys', name=>'tbl_sta', sample_ratio=>dbe_stats.AUTO_SAMPLE_SIZE);
exec DBE_STATS.COLLECT_TABLE_STATS(schema=>'sys', name=>'tbl_sta', sample_ratio=>0);
exec DBE_STATS.COLLECT_TABLE_STATS(schema=>'sys', name=>'tbl_sta', sample_ratio=>0.000000001);

drop table tbl_sta;
--end

begin
THROW_EXCEPTION(1, 'aaa');
end;
/

begin
THROW_EXCEPTION(-20000, 'aaa');
end;
/

begin
THROW_EXCEPTION(-19999, 'aaa');
end;
/
begin
THROW_EXCEPTION(-20999, 'aaa');
end;
/
begin
THROW_EXCEPTION(-21000, 'aaa');
end;
/

--test gather stats of partitioned table
--begin
conn GS_PL_DBE/root_1234@127.0.0.1:1611

drop table if exists TEST_PART_T;
create table TEST_PART_T(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);
insert into test_part_t values(5, 15, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t values(6, 16, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t values(16, 26, 39, '26', '39', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t values(26, 36, 49, '36', '49', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t values(36, 46, 59, '46', '59', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t values(46, 56, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
commit;

exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE');
select table_name,num_rows from user_tables where table_name='TEST_PART_T';

exec dbe_stats.delete_table_stats('GS_PL_DBE');
select table_name,num_rows from user_tables where table_name='TEST_PART_T';

exec DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE', 'TEST_PART_T');
select table_name,num_rows from user_tables where table_name='TEST_PART_T';
exec dbe_stats.delete_table_stats('GS_PL_DBE', 'TEST_PART_T');
select table_name,num_rows from user_tables where table_name='TEST_PART_T';

exec DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE', 'TEST_PART_T', 'P1');
select table_name,num_rows from user_tables where table_name='TEST_PART_T';
exec dbe_stats.delete_table_stats('GS_PL_DBE', 'TEST_PART_T', 'P2');
select table_name,num_rows from user_tables where table_name='TEST_PART_T';
exec dbe_stats.delete_table_stats('GS_PL_DBE', 'TEST_PART_T', 'P1');
select table_name,num_rows from user_tables where table_name='TEST_PART_T';

exec DBE_STATS.PURGE_STATS(systimestamp);
select table_name,num_rows from user_tables where table_name='TEST_PART_T';

--end

--test gather partitioned table statistic info
--begin
drop table if exists TAB_PART_DBE;
create table TAB_PART_DBE(f1 int, f2 varchar(30), f3 clob)
PARTITION BY RANGE(f1)
(
 PARTITION t_p1 values less than(10),
 PARTITION t_p2 values less than(20),
 PARTITION t_p3 values less than(30),
 PARTITION t_p4 values less than(100),
 PARTITION t_p5 values less than(MAXVALUE)
);

create index IDX_TAB_PART_DBE_F12 on TAB_PART_DBE(f1, f2) local(partition t_p1, partition t_p2, partition t_p3, partition t_p4, partition t_p5);
create index IDX_TAB_PART_DBE_F2 on TAB_PART_DBE(f2);

insert into TAB_PART_DBE values(1, 'a', 'bbb');
insert into TAB_PART_DBE values(1, 'a', 'tte');
insert into TAB_PART_DBE values(13, 'a', 'aaqqqaaa');
insert into TAB_PART_DBE values(14, 'a', 'sss');
insert into TAB_PART_DBE values(22, 'a', 'aasdsaaa');
insert into TAB_PART_DBE values(22, 'a', 'aaasdfdsaa');
insert into TAB_PART_DBE values(91, 'a', 'aaasdfdsaa');
insert into TAB_PART_DBE values(91, 'b', 'aasdsfaaaa');
insert into TAB_PART_DBE values(92, 'b', 'aaadafdxxaa');
commit;

exec DBE_STATS.FLUSH_DB_STATS_INFO;

select TABLE_OWNER,TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,INSERTS,UPDATES,DELETES,DROP_SEGMENTS from DBA_TAB_MODIFICATIONS where table_name ='TAB_PART_DBE' ORDER BY PARTITION_NAME;

exec DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE', 'TAB_PART_DBE', 't_p0', 10);
exec DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE', 'TAB_PART_DBE', 't_p1', 10);
exec DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE', 'TAB_PART_DBE', 't_p5', 10);
exec DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE', 'TAB_PART_DBE', null, 10);

select table_name,num_rows from user_tables where table_name='TAB_PART_DBE';
select PARTITION_NAME,PARTITION_POSITION, num_rows from USER_TAB_PARTITIONS where table_name='TAB_PART_DBE' order by PARTITION_POSITION;
select TABLE_OWNER,TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,INSERTS,UPDATES,DELETES,DROP_SEGMENTS from DBA_TAB_MODIFICATIONS where table_name ='TAB_PART_DBE' ORDER BY PARTITION_NAME;

exec dbe_stats.delete_table_stats('GS_PL_DBE', 'TAB_PART_DBE');
select table_name,num_rows from user_tables where table_name='TAB_PART_DBE';
select PARTITION_NAME,PARTITION_POSITION, num_rows from USER_TAB_PARTITIONS where table_name='TAB_PART_DBE' order by PARTITION_POSITION;

exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE');
select table_name,num_rows from user_tables where table_name='TAB_PART_DBE';

--(1)CHECK USER_TAB_PARTITIONS
select PARTITION_NAME,PARTITION_POSITION, num_rows from USER_TAB_PARTITIONS where table_name='TAB_PART_DBE' order by PARTITION_POSITION;
select PARTITION_NAME,PARTITION_POSITION, num_rows from ALL_TAB_PARTITIONS where table_name='TAB_PART_DBE' order by PARTITION_POSITION;
select PARTITION_NAME,PARTITION_POSITION, num_rows from DBA_TAB_PARTITIONS where table_name='TAB_PART_DBE' order by PARTITION_POSITION;

--(2)CHECK DBA_TAB_MODIFICATIONS
select TABLE_OWNER,TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,INSERTS,UPDATES,DELETES,DROP_SEGMENTS from DBA_TAB_MODIFICATIONS where table_name ='TAB_PART_DBE' ORDER BY PARTITION_NAME;
select TABLE_OWNER,TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,INSERTS,UPDATES,DELETES,DROP_SEGMENTS from ALL_TAB_MODIFICATIONS where table_name ='TAB_PART_DBE' ORDER BY PARTITION_NAME;
select TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,INSERTS,UPDATES,DELETES,DROP_SEGMENTS from USER_TAB_MODIFICATIONS where table_name ='TAB_PART_DBE' ORDER BY PARTITION_NAME;

--(3)check user_tab_col_statistics 
select TABLE_NAME,COLUMN_NAME,NUM_DISTINCT, LOW_VALUE,HIGH_VALUE,DENSITY,NUM_NULLS,AVG_COL_LEN,HISTOGRAM  from USER_TAB_COL_STATISTICS where table_name = 'TAB_PART_DBE' ORDER BY COLUMN_NAME;
select TABLE_NAME,COLUMN_NAME,NUM_DISTINCT, LOW_VALUE,HIGH_VALUE,DENSITY,NUM_NULLS,AVG_COL_LEN,HISTOGRAM  from ALL_TAB_COL_STATISTICS where table_name = 'TAB_PART_DBE' ORDER BY COLUMN_NAME;
select TABLE_NAME,COLUMN_NAME,NUM_DISTINCT, LOW_VALUE,HIGH_VALUE,DENSITY,NUM_NULLS,AVG_COL_LEN,HISTOGRAM  from DBA_TAB_COL_STATISTICS where table_name = 'TAB_PART_DBE' ORDER BY COLUMN_NAME;

--(4)CHECK user_part_col_statistics
select TABLE_NAME,PARTITION_NAME,COLUMN_NAME,NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,DENSITY,NUM_NULLS,AVG_COL_LEN,HISTOGRAM from user_part_col_statistics where table_name = 'TAB_PART_DBE' ORDER BY PARTITION_NAME, COLUMN_NAME;
select TABLE_NAME,PARTITION_NAME,COLUMN_NAME,NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,DENSITY,NUM_NULLS,AVG_COL_LEN,HISTOGRAM from all_part_col_statistics where table_name = 'TAB_PART_DBE' ORDER BY PARTITION_NAME, COLUMN_NAME;
select TABLE_NAME,PARTITION_NAME,COLUMN_NAME,NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,DENSITY,NUM_NULLS,AVG_COL_LEN,HISTOGRAM from dba_part_col_statistics where table_name = 'TAB_PART_DBE' ORDER BY PARTITION_NAME, COLUMN_NAME;

--(5)check ALL_TAB_STATISTICS,DBA_TAB_STATISTICS,USER_TAB_STATISTICS
select OWNER,TABLE_NAME,PARTITION_NAME,PARTITION_POSITION,OBJECT_TYPE,NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_SPACE,CHAIN_CNT,AVG_ROW_LEN,AVG_SPACE_FREELIST_BLOCKS,NUM_FREELIST_BLOCKS,AVG_CACHED_BLOCKS,AVG_CACHE_HIT_RATIO from ALL_TAB_STATISTICS where table_name = 'TAB_PART_DBE' ORDER BY TABLE_NAME, PARTITION_NAME;
select TABLE_NAME,PARTITION_NAME,PARTITION_POSITION,OBJECT_TYPE,NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_SPACE,CHAIN_CNT,AVG_ROW_LEN,AVG_SPACE_FREELIST_BLOCKS,NUM_FREELIST_BLOCKS,AVG_CACHED_BLOCKS,AVG_CACHE_HIT_RATIO from USER_TAB_STATISTICS where table_name = 'TAB_PART_DBE' ORDER BY TABLE_NAME, PARTITION_NAME;
select TABLE_NAME,PARTITION_NAME,PARTITION_POSITION,OBJECT_TYPE,NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_SPACE,CHAIN_CNT,AVG_ROW_LEN,AVG_SPACE_FREELIST_BLOCKS,NUM_FREELIST_BLOCKS,AVG_CACHED_BLOCKS,AVG_CACHE_HIT_RATIO from DBA_TAB_STATISTICS where table_name = 'TAB_PART_DBE' ORDER BY TABLE_NAME, PARTITION_NAME;


--(6) ALL_TAB_COLUMNS,DBA_TAB_COLUMNS,USER_TAB_COLUMNS
select OWNER,TABLE_NAME,COLUMN_NAME,DATA_TYPE,DATA_LENGTH,DATA_PRECISION,DATA_SCALE,NULLABLE,COLUMN_ID,DATA_DEFAULT,NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,NUM_NULLS,NUM_BUCKETS,CHAR_LENGTH,CHAR_USED,SAMPLE_SIZE,HISTOGRAM,AUTO_INCREMENT from ALL_TAB_COLUMNS where table_name = 'TAB_PART_DBE' ORDER BY TABLE_NAME, COLUMN_NAME;
select TABLE_NAME,COLUMN_NAME,DATA_TYPE,DATA_LENGTH,DATA_PRECISION,DATA_SCALE,NULLABLE,COLUMN_ID,DATA_DEFAULT,NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,NUM_NULLS,NUM_BUCKETS,CHAR_LENGTH,CHAR_USED,SAMPLE_SIZE,HISTOGRAM,AUTO_INCREMENT from USER_TAB_COLUMNS where table_name = 'TAB_PART_DBE' ORDER BY TABLE_NAME, COLUMN_NAME;
select TABLE_NAME,COLUMN_NAME,DATA_TYPE,DATA_LENGTH,DATA_PRECISION,DATA_SCALE,NULLABLE,COLUMN_ID,DATA_DEFAULT,NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,NUM_NULLS,NUM_BUCKETS,CHAR_LENGTH,CHAR_USED,SAMPLE_SIZE,HISTOGRAM,AUTO_INCREMENT from DBA_TAB_COLUMNS where table_name = 'TAB_PART_DBE' ORDER BY TABLE_NAME, COLUMN_NAME;

--(7)DBA_IND_PARTITIONS,ALL_IND_PARTITIONS
select INDEX_NAME,COMPOSITE,PARTITION_NAME,PARTITION_POSITION,STATUS,PCT_FREE,INI_TRANS,MAX_TRANS,BLEVEL,LEAF_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,CLUSTERING_FACTOR,NUM_ROWS from DBA_IND_PARTITIONS where INDEX_name IN ('IDX_TAB_PART_DBE_F12','IDX_TAB_PART_DBE_F1') ORDER BY INDEX_name, PARTITION_NAME;
select INDEX_NAME,COMPOSITE,PARTITION_NAME,PARTITION_POSITION,STATUS,PCT_FREE,INI_TRANS,MAX_TRANS,BLEVEL,LEAF_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,CLUSTERING_FACTOR,NUM_ROWS from ALL_IND_PARTITIONS where INDEX_name IN ('IDX_TAB_PART_DBE_F12','IDX_TAB_PART_DBE_F1') ORDER BY INDEX_name, PARTITION_NAME;
select INDEX_NAME,COMPOSITE,PARTITION_NAME,PARTITION_POSITION,STATUS,PCT_FREE,INI_TRANS,MAX_TRANS,BLEVEL,LEAF_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,CLUSTERING_FACTOR,NUM_ROWS from USER_IND_PARTITIONS where INDEX_name IN ('IDX_TAB_PART_DBE_F12','IDX_TAB_PART_DBE_F1') ORDER BY INDEX_name, PARTITION_NAME;

--(8)DBA_IND_STATISTICS,USER_IND_STATISTICS
select INDEX_NAME,TABLE_NAME,PARTITION_NAME,PARTITION_POSITION,OBJECT_TYPE,BLEVEL,LEAF_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,CLUSTERING_FACTOR,NUM_ROWS from DBA_IND_STATISTICS where INDEX_name IN ('IDX_TAB_PART_DBE_F12','IDX_TAB_PART_DBE_F1') ORDER BY INDEX_name, PARTITION_NAME;
select INDEX_NAME,TABLE_NAME,PARTITION_NAME,PARTITION_POSITION,OBJECT_TYPE,BLEVEL,LEAF_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,CLUSTERING_FACTOR,NUM_ROWS from USER_IND_STATISTICS where INDEX_name IN ('IDX_TAB_PART_DBE_F12','IDX_TAB_PART_DBE_F1') ORDER BY INDEX_name, PARTITION_NAME;
select INDEX_NAME,TABLE_NAME,PARTITION_NAME,PARTITION_POSITION,OBJECT_TYPE,BLEVEL,LEAF_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,CLUSTERING_FACTOR,NUM_ROWS from ALL_IND_STATISTICS where INDEX_name IN ('IDX_TAB_PART_DBE_F12','IDX_TAB_PART_DBE_F1') ORDER BY INDEX_name, PARTITION_NAME;

--(9)ALL_HISTOGRAMS,DBA_HISTOGRAMS,USER_HISTOGRAMS
select TABLE_NAME,COLUMN_NAME,ENDPOINT_NUMBER,ENDPOINT_VALUE,ENDPOINT_ACTUAL_VALUE from ALL_HISTOGRAMS where table_name = 'TAB_PART_DBE' ORDER BY TABLE_NAME, COLUMN_NAME, ENDPOINT_NUMBER;
select TABLE_NAME,COLUMN_NAME,ENDPOINT_NUMBER,ENDPOINT_VALUE,ENDPOINT_ACTUAL_VALUE from DBA_HISTOGRAMS where table_name = 'TAB_PART_DBE' ORDER BY TABLE_NAME, COLUMN_NAME, ENDPOINT_NUMBER;
select TABLE_NAME,COLUMN_NAME,ENDPOINT_NUMBER,ENDPOINT_VALUE,ENDPOINT_ACTUAL_VALUE from USER_HISTOGRAMS where table_name = 'TAB_PART_DBE' ORDER BY TABLE_NAME, COLUMN_NAME, ENDPOINT_NUMBER;

--end

--test case: fuzz test
conn sys/Huawei@123@127.0.0.1:1611

--1.gsql_fuzz_DBE_LOB_GET_LENGTH
--2.gsql_fuzz_DBE_LOB_SUBSTR
drop table if exists pl_lob_tab;
create table pl_lob_tab(a int, b blob, c clob);

select DBE_LOB.substr('', 1, 2) from pl_lob_tab;
select DBE_LOB.substr(null, 1, 2) from pl_lob_tab;
select DBE_LOB.substr(c, null, 2) from pl_lob_tab;
select DBE_LOB.substr(c, '', 2) from pl_lob_tab;
select DBE_LOB.substr(c, 1, '') from pl_lob_tab;
select DBE_LOB.substr(c, 1, null) from pl_lob_tab;

select DBE_LOB.GET_LENGTH('') from pl_lob_tab;
select DBE_LOB.GET_LENGTH(null) from pl_lob_tab;
select DBE_LOB.GET_LENGTH(NULL) from pl_lob_tab;

drop table if exists pl_lob_tab;


--3.gsql_fuzz_DBE_OUTPUT_PUT
--4.gsql_fuzz_DBE_OUTPUT_PUT_LINE
begin
	dbe_output.print(null);
	dbe_output.print('');
	dbe_output.print_line(null);
	dbe_output.print_line('');	
end;
/

--5.gsql_fuzz_dbe_random_get_value
select dbe_random.get_string('U', null);

select dbe_random.get_value(0, null) from dual;
select dbe_random.get_value(0, '') from dual;
select dbe_random.get_value(null,0) from dual;
select dbe_random.get_value('',0) from dual;

--6.gsql_fuzz_dbe_SQL_RETURN_CURSOR
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
OPEN v_refcur2 FOR dbe_sql.return_cursor(null);
end;
/

declare
v_refcur2 SYS_REFCURSOR;
begin
OPEN v_refcur2 FOR dbe_sql.return_cursor(v_refcur2);
end;
/

--7.gsql_fuzz_dbe_STANDARD_THROW_EXCEPTION
begin
THROW_EXCEPTION(1, 'aaa', null);
end;
/

begin
THROW_EXCEPTION(1, 'aaa', '');
end;
/

begin
THROW_EXCEPTION(1, '');
end;
/

begin
THROW_EXCEPTION(1, null);
end;
/

begin
THROW_EXCEPTION(null, 'a');
end;
/

begin
THROW_EXCEPTION('', 'a');
end;
/

begin
THROW_EXCEPTION(' ', 'a');
end;
/

--8.gsql_fuzz_dbe_STANDARD_SLEEP
select sleep(null);
select sleep('');

--9.gsql_fuzz_dbe_STANDARD_SQL_ERR_CODE
--10.gsql_fuzz_dbe_STANDARD_SQL_ERR_MSG
declare 
v_age number;
begin 
v_age:=89;
v_age:= v_age/0;
exception
 when others then
 SYS.dbe_output.print_line(SQL_ERR_CODE(null)||SQL_ERR_MSG);
 end;
/

declare 
v_age number;
begin 
v_age:=89;
v_age:= v_age/0;
exception
 when others then
 SYS.dbe_output.print_line(SQL_ERR_CODE||SQL_ERR_MSG(null));
 end;
/

declare 
v_age number;
begin 
v_age:=89;
v_age:= v_age/0;
exception
 when others then
 SYS.dbe_output.print_line(SQL_ERR_CODE||SQL_ERR_MSG(''));
 end;
/

--11.gsql_fuzz_dbe_STATS_AUTO_SAMPLE_SIZE
select dbe_stats.AUTO_SAMPLE_SIZE(null);
select dbe_stats.AUTO_SAMPLE_SIZE('');


--12.gsql_fuzz_dbe_STATS_FLUSH_DB_STATS_INFO
select DBE_STATS.FLUSH_DB_STATS_INFO(null);
select DBE_STATS.FLUSH_DB_STATS_INFO('');

--13.gsql_fuzz_dbe_STATS_COLLECT_SCHEMA_STATS
exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE', 100, true, null);
exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE', 100, true, '');
exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE', 100, null);
exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE', 100, '');
exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE', null);
exec DBE_STATS.COLLECT_SCHEMA_STATS('GS_PL_DBE', '');
exec DBE_STATS.COLLECT_SCHEMA_STATS(null);
exec DBE_STATS.COLLECT_SCHEMA_STATS('');
exec DBE_STATS.COLLECT_SCHEMA_STATS(' ');
exec DBE_STATS.COLLECT_SCHEMA_STATS(''=>'GS_PL_DBE');

--14.gsql_fuzz_dbe_STATS_GATHER_TABLE_STATS
exec DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE','TAB_PART_DBE', null,100, true, null);
exec DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE','TAB_PART_DBE', '',100, true, '');
exec DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE','TAB_PART_DBE', '',100, null);
exec DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE','TAB_PART_DBE', '',100, '');
exec DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE','TAB_PART_DBE', null);
exec DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE','TAB_PART_DBE', '');
exec DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE',null);
exec DBE_STATS.COLLECT_TABLE_STATS('GS_PL_DBE','');
exec DBE_STATS.COLLECT_TABLE_STATS(' ');
exec DBE_STATS.COLLECT_TABLE_STATS(''=>'GS_PL_DBE');

--15.gsql_fuzz_dbe_STATS_DELETE_SCHEMA_STATS
exec dbe_stats.delete_table_stats('sys', null, null);
exec dbe_stats.delete_table_stats('sys', '', '', '', '', '');


--16.gsql_fuzz_dbe_STATS_DELETE_TABLE_STATS
exec dbe_stats.DELETE_TABLE_STATS('sys', 'pl_lob_tab', null);
exec dbe_stats.DELETE_TABLE_STATS('sys', 'pl_lob_tab','');
exec dbe_stats.DELETE_TABLE_STATS('sys', null);
exec dbe_stats.DELETE_TABLE_STATS('sys', '');

--17.gsql_fuzz_dbe_STATS_PURGE_STATS
exec dbe_stats.PURGE_STATS('');
exec dbe_stats.PURGE_STATS(NULL);

--18.compile_schema
exec DBE_UTIL.COMPILE_SCHEMA('GS_PL_DBE',null);
exec DBE_UTIL.COMPILE_SCHEMA('GS_PL_DBE','', '');

--19.get_time
select dbe_util.get_date_time(null);

set serveroutput off;


--test for DBE_STATS.COLLECT_INDEX_STATS
drop table if exists TEST_GATHER_INDEX_TABLE;
create table TEST_GATHER_INDEX_TABLE(a int, b int, c int,d VARCHAR2(10));
create index INDEX_T1 on TEST_GATHER_INDEX_TABLE(a);
insert into TEST_GATHER_INDEX_TABLE values (1, 2, -2, 'a');
insert into TEST_GATHER_INDEX_TABLE values (2, 3, -2, 'a');
call DBE_STATS.PURGE_STATS(sysdate);
select LEVEL_BLOCKS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY from SYS_INDEXES where NAME = 'INDEX_T1';
call DBE_STATS.COLLECT_INDEX_STATS('SYS','INDEX_T1', 'TEST_GATHER_INDEX_TABLE');
select LEVEL_BLOCKS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY from SYS_INDEXES where NAME = 'INDEX_T1';
--expect success
call DBE_STATS.COLLECT_INDEX_STATS('SYS','INDEX_T1', 'TEST_GATHER_INDEX_TABLE');
call DBE_STATS.COLLECT_INDEX_STATS('SYS','INDEX_T1', 'TEST_GATHER_INDEX_TABLE');
call DBE_STATS.PURGE_STATS(sysdate-101);
call DBE_STATS.COLLECT_INDEX_STATS('SYS','INDEX_T1', 'TEST_GATHER_INDEX_TABLE', 0.000001);
call DBE_STATS.COLLECT_INDEX_STATS('SYS','INDEX_T1', 'TEST_GATHER_INDEX_TABLE', 100);
--expect error
call DBE_STATS.COLLECT_INDEX_STATS('SYS','INDEX_T1', 'TEST_GATHER_INDEX_TABLE', 0.0000001);
call DBE_STATS.COLLECT_INDEX_STATS('SYS','INDEX_T1', 'TEST_GATHER_INDEX_TABLE', 100.00001);
call DBE_STATS.COLLECT_INDEX_STATS(NULL,'INDEX_T1', 'TEST_GATHER_INDEX_TABLE');
call DBE_STATS.COLLECT_INDEX_STATS(NULL,'INDEX_T1', 'TEST_GATHER_INDEX_TABLE');
call DBE_STATS.COLLECT_INDEX_STATS(NULL, NULL, NULL);
call DBE_STATS.COLLECT_INDEX_STATS(NULL, NULL, NULL);
call DBE_STATS.COLLECT_INDEX_STATS('SYS');
call DBE_STATS.COLLECT_INDEX_STATS(NULL);
drop index INDEX_T1 on TEST_GATHER_INDEX_TABLE;
drop table TEST_GATHER_INDEX_TABLE;
