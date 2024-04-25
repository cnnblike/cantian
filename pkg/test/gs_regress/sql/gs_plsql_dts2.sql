set serveroutput on;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_plsql_dts2 cascade;
create user gs_plsql_dts2 identified by Lh00420062;
grant all privileges to gs_plsql_dts2;
grant select on dba_arguments to gs_plsql_dts2;
conn gs_plsql_dts2/Lh00420062@127.0.0.1:1611

--1.1 test using cursor;
declare
v_refcur1 sys_refcursor;
aa int := 10;
BEGIN  --
    execute immediate ' --vars
    BEGIN  
    open :1 for select :2 from dual;
    close :1;
    END'using in out v_refcur1,aa;
END;
/

--1.2 test using cursor;
drop table if exists myt;
create table myt (c int);
insert into myt values(10);
insert into myt values(20);
declare
cursor myc is select c from myt;
BEGIN  
    
    execute immediate '
    BEGIN  
    for item in :1 loop
    dbe_output.print_line(item.c);
    end loop;
    END' using myc ;
END;
/

--2.1 test after pl, the same sql occur again
declare
  i int;
begin
  i := 0;
  select 1 into i from dual where i = 0;
end;
/

select 1 from dual where @0_0 = 0;
--end

--3.1 label verify, occur before end
create  or replace procedure FVT_goto_l00P_02 
as 
a int :=0;
b int :=2;
c int :=0;
begin 
<<aaa>>
c :=c+1;
<<ccc>>
end;
/

--3.2 label verify, occur before loop
create  or replace procedure FVT_goto_l00P_02 
as 
a int :=0;
su int :=0;
begin 
for a in 1..10 loop
su := su + a;
<<ccc>>
end loop;
end;
/

--3.3 label verify, occur before endif
create  or replace procedure FVT_goto_l00P_02 
as 
a int :=0;

begin 
if(a=0) then
dbe_output.print_line(a);
<<ccc>>
end if;
end;
/


--DTS2019013109845 
call abs(-1);

begin
abs(-1);
end;
/

--4.1 test too many error info
create or replace function test_too_many_error return int is
v1 int;
v2 int;
begin
  v1 = 0;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  v2 = v1;
  return v1;
end;
/

begin
  execute immediate 'select test_too_many_error() from dual';
end;
/

--verify curosr setval
drop table if exists CURSOR_FUNCTION_002_TAB_01;
create table CURSOR_FUNCTION_002_TAB_01(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into CURSOR_FUNCTION_002_TAB_01 values(1,'zhangsan','doctor1',10000);
create or replace view CURSOR_FUNCTION_002_VIEW_01 as select * from CURSOR_FUNCTION_002_TAB_01;
create or replace function CURSOR_FUNCTION_002_FUN_01 (str1 varchar) return int 
is 
mycursor1 sys_refcursor;
a int;
begin
 select empno into a from CURSOR_FUNCTION_002_VIEW_01;
   dbe_output.print_line(a);
    return length(str1);
   exception
   when  TOO_MANY_ROWS  then
   begin
      select empno into a from CURSOR_FUNCTION_002_VIEW_01 limit 1;
     dbe_output.print_line(a);
     return length(str1);
   end;
end;
/

create or replace function CURSOR_FUNCTION_002_FUN_02 (str1 varchar) return sys_refcursor
is 
cursor cursor1(a int,b varchar) is  select CURSOR_FUNCTION_002_FUN_01(b)*a from CURSOR_FUNCTION_002_TAB_01; 
begin
open cursor1(2,'aaa') ;
return cursor1;
end;
/

create or replace function CURSOR_FUNCTION_002_FUN_02 (str1 varchar) return int
is 
cursor cursor1(a int,b varchar) is  select CURSOR_FUNCTION_002_FUN_01(b)*a from CURSOR_FUNCTION_002_TAB_01; 
cursor2 sys_refcursor;
begin
open cursor1(2,'aaa') ;
cursor2 := cursor1;
close cursor1;
return 1;
end;
/
create or replace function liu_func (str1 varchar) return sys_refcursor
is 
cursor2 sys_refcursor;
begin
return cursor2;
end;
/
select liu_func('aa') from dual;

declare
cursor cursor1 is select 1 from dual;
cursor2 sys_refcursor;
begin
open cursor1;
cursor2 := cursor1;
close cursor1;
end;
/
declare
cursor cursor1(a int default 0) is select a from dual;
cursor2 sys_refcursor;
begin
open cursor1(10);
cursor2 := cursor1;
close cursor1;
end;
/
declare
cursor1 sys_refcursor;
cursor2 sys_refcursor;
begin
open cursor1 for select 1 from dual;
cursor2 := cursor1;
close cursor1;
end;
/
--ent verify cursor setval
drop table if exists CURSOR_PROC_FUN_001_TAB_01;
create table CURSOR_PROC_FUN_001_TAB_01(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into CURSOR_PROC_FUN_001_TAB_01 values(1,'zhangsan','doctor1',10000);

create or replace view CURSOR_PROC_FUN_001_VIEW_01 as select * from CURSOR_PROC_FUN_001_TAB_01;
--functionA
create or replace function CURSOR_PROC_FUN_001_FUN_01 (str1 varchar) return int 
is 
mycursor1 sys_refcursor;
a int;
begin
     return length(str1);
end;
/

create or replace function CURSOR_PROC_FUN_001_FUN_05 (a int,b varchar,str1 varchar) return sys_refcursor
is 
cursor1 sys_refcursor;
v_empno int;
v_ename varchar(10);
v_sal int;
begin
open cursor1 for  select empno,ename, sal*a from CURSOR_PROC_FUN_001_TAB_01 where job like  b||'%' and ename like str1||'%' order by empno,ename,sal;
fetch cursor1 into v_empno,v_ename,v_sal;
dbe_output.print_line(v_empno||'  '||v_ename||'  '||v_sal);
return cursor1;
end;
/
create or replace procedure CURSOR_PROC_FUN_001_Proc_05_2 is 
cur1 sys_refcursor;
v_empno int;
v_ename varchar(10);
v_sal int;
begin
cur1 := CURSOR_PROC_FUN_001_FUN_05(4,'doctor','zhangsan');
fetch cur1 into v_empno,v_ename,v_sal;
loop
if cur1%found then
dbe_output.print_line(v_empno||'  '||v_ename||'  '||v_sal);
fetch cur1 into v_empno,v_ename,v_sal; 
else exit;
end if;
end loop;
dbe_sql.return_cursor(cur1);
end;
/

exec CURSOR_PROC_FUN_001_Proc_05_2;

drop table if exists CURSOR_PROC_002_TAB_01;
create table CURSOR_PROC_002_TAB_01(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into CURSOR_PROC_002_TAB_01 values(1,'zhangsan','doctor1',10000);
insert into CURSOR_PROC_002_TAB_01 values(2,'zggg','doctor1',20000);

create or replace function CURSOR_PROC_002_FUN_01 (str1 varchar) return int
is 
a int;
begin
     return length(str1);
end;
/

select CURSOR_PROC_002_FUN_01('aaaa') from dual;

--test 1
create or replace procedure CURSOR_PROC_002_Proc_07_1 (b varchar) 
is 
cursor1 sys_refcursor;
begin
open cursor1 for select CURSOR_PROC_002_FUN_01(ename)*2 from CURSOR_PROC_002_TAB_01 ;
dbe_sql.return_cursor(cursor1);
end;
/
call  CURSOR_PROC_002_Proc_07_1('abcdeff');

--test 2
create or replace procedure CURSOR_PROC_002_Proc_07_1 (b varchar) 
is 
cursor1 sys_refcursor;
begin
open cursor1 for select CURSOR_PROC_002_FUN_01(b)*2 from CURSOR_PROC_002_TAB_01;
dbe_sql.return_cursor(cursor1);
end;
/
call  CURSOR_PROC_002_Proc_07_1('abcdeff');

--test 3
create or replace procedure CURSOR_PROC_002_Proc_07_1 (a int) 
is 
cursor1 sys_refcursor;
begin
open cursor1 for select CURSOR_PROC_002_FUN_01(ename)*2 from CURSOR_PROC_002_TAB_01 where sal>a;
dbe_sql.return_cursor(cursor1);
end;
/
call  CURSOR_PROC_002_Proc_07_1(10);

drop table if exists CURSOR_PROC_002_TAB_01;
create table CURSOR_PROC_002_TAB_01(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into CURSOR_PROC_002_TAB_01 values(1,'zhangsan','doctor1',10000);
insert into CURSOR_PROC_002_TAB_01 values(2,'zggg','doctor1',20000);

create or replace procedure test_ttt_proc(a varchar)
as
cursor1 sys_refcursor;
begin
open cursor1 for select ename from CURSOR_PROC_002_TAB_01 ;
dbe_sql.return_cursor(cursor1); 
end;
/

create or replace function CURSOR_PROC_002_FUN_01 (str1 varchar) return int
is 
a int;
cursor1 sys_refcursor;
begin
    test_ttt_proc(str1);
    return length(str1);
end;
/
select CURSOR_PROC_002_FUN_01('aaaa') from dual;


create or replace function return_normal_cursor_test (b varchar) return sys_refcursor
is 
cursor cursor1 is  select 1 from dual;  
begin
open cursor1 ;
return cursor1;
end;
/

create or replace function normal_cursor_setval_test (b varchar) return sys_refcursor
is 
cursor cursor1 is  select 1 from dual;  
begin
open cursor1 ;
return cursor1;
end;
/

-- DTS2019031105905 
--4.2 test too many error info
create or replace procedure p_OnexcLicenseInfo as
(v_xcTypeSDHnum IN OUT INT,
   v_xcTypeOTNnum IN OUT INT,
   v_xcTypePacketU16num IN OUT INT,
   v_xcTypePacketU32num IN OUT INT,
   v_xcTypePacketU64num IN OUT INT,
   v_xcCap360num IN OUT INT,
   v_xcCap640num IN OUT INT,
   v_xcCap720num IN OUT INT,
   v_xcCap1280num IN OUT INT,
   v_xcCap2560num IN OUT INT,
   v_xcCap5120num IN OUT INT,
   v_xcCap3200num IN OUT INT,
   v_xcCap6400num IN OUT INT,
   v_xcCap800Num IN OUT INT,
   v_xcCap1601Num IN OUT INT,
   v_xcCap2400Num IN OUT INT,
   v_xcCap4000Num IN OUT INT,
   v_xc1588v2num IN OUT INT,
   v_xcVC12T32num IN OUT INT,
   v_xcVC12T16num IN OUT INT,
   v_xcCap100320num IN OUT INT,
   v_xcCap100640num IN OUT INT,
   v_xcCap100C80num IN OUT INT,
   v_xcCap101900num IN OUT INT,
   v_xcCap101900num_96 IN OUT INT,
   v_xcCap103200num IN OUT INT,
   v_xcCap103200num_96 IN OUT INT,
   v_xcCap106400num IN OUT INT,
   v_xcCap106400Num_96 IN OUT INT,
   v_xcCap1600num IN OUT INT,
   v_xcTypeSDHnum_1800V IN OUT INT,
   v_xcTypePacketnum_1800V IN OUT INT,
   v_xcTypeOTNnum_1800V IN OUT INT,
   v_xc1588v2num_1800V IN OUT INT,
   v_clusterNum_En IN OUT INT,
   SWP_Ret_Value IN OUT INT)
AS
        v_xcTypeSDHnum_refcur SYS_REFCURSOR;
        v_xcTypeOTNnum_refcur SYS_REFCURSOR;
   v_xcTypePacketU16num_refcur SYS_REFCURSOR;
   v_xcTypePacketU32num_refcur SYS_REFCURSOR;
   v_xcTypePacketU64num_refcur SYS_REFCURSOR;
   v_xcCap360num_refcur SYS_REFCURSOR;
   v_xcCap640num_refcur SYS_REFCURSOR;
   v_xcCap720num_refcur SYS_REFCURSOR;
   v_xcCap1280num_refcur SYS_REFCURSOR;
   v_xcCap2560num_refcur SYS_REFCURSOR;
   v_xcCap5120num_refcur SYS_REFCURSOR;
   v_xcCap3200num_refcur SYS_REFCURSOR;
   v_xcCap6400num_refcur SYS_REFCURSOR;
   v_xcCap800Num_refcur SYS_REFCURSOR;
   v_xcCap1601Num_refcur SYS_REFCURSOR;
   v_xcCap2400Num_refcur SYS_REFCURSOR;
   v_xcCap4000Num_refcur SYS_REFCURSOR;
   v_xc1588v2num_refcur SYS_REFCURSOR;
   v_xcVC12T32num_refcur SYS_REFCURSOR;
   v_xcVC12T16num_refcur SYS_REFCURSOR;
   v_xcCap100320num_refcur SYS_REFCURSOR;
   v_xcCap100640num_refcur SYS_REFCURSOR;
   v_xcCap100C80num_refcur SYS_REFCURSOR;
   v_xcCap101900num_refcur SYS_REFCURSOR;
   v_xcCap101900num_96_refcur SYS_REFCURSOR;
   v_xcCap103200num_refcur SYS_REFCURSOR;
   v_xcCap103200num_96_refcur SYS_REFCURSOR;
   v_xcCap106400num_refcur SYS_REFCURSOR;
   v_xcCap106400Num_96_refcur SYS_REFCURSOR;
   v_xcCap1600num_refcur SYS_REFCURSOR;
   v_xcTypeSDHnum_1800V_refcur SYS_REFCURSOR;
   v_xcTypePacketnum_1800V_refcur SYS_REFCURSOR;
   v_xcTypeOTNnum_1800V_refcur SYS_REFCURSOR;
   v_xc1588v2num_1800V_refcur SYS_REFCURSOR;
   v_clusterNum_En_refcur SYS_REFCURSOR;
BEGIN


    execute immediate ' select count(*) from t_inv_chassis where svcType = 1 or svcType = 3 or svcType = 5
    or svcType = 7' into v_xcTypeSDHnum;
    open v_xcTypeSDHnum_refcur for select v_xcTypeSDHnum from dual;
        dbe_sql.return_cursor(v_xcTypeSDHnum_refcur);

   EXCEPTION
       when others then
           SWP_Ret_Value := SQL_ERR_CODE;
   RETURN;

commit;
end;
/


create or replace Procedure  FUNCTION_PROC_DDL_001_Proc_01  is
begin
null;
execute immediate 'set transaction ISOLATION LEVEL READ COMMITTED';
end;
/
create or replace function  FUNCTION_PROC_DDL_001_Fun_01 return int is
begin
FUNCTION_PROC_DDL_001_Proc_01;
return 1;
end;
/
select FUNCTION_PROC_DDL_001_Fun_01;
create or replace procedure  FUNCTION_Proc_DDL_002_Proc_11  is
begin
null;
execute immediate 'alter session set COMMIT_WAIT_LOGGING = WAIT';
end;
/
create or replace function  FUNCTION_PROC_DDL_001_Fun_02 return int is
begin
FUNCTION_Proc_DDL_002_Proc_11;
return 1;
end;
/
select FUNCTION_PROC_DDL_001_Fun_02;
create or replace procedure  FUNCTION_Proc_DDL_001_Proc_12  is
begin
null;
execute immediate 'alter system kill session ''49,9'' ' ;
end;
/
create or replace function  FUNCTION_PROC_DDL_001_Fun_02 return int is
begin
FUNCTION_Proc_DDL_001_Proc_12;
return 1;
end;
/
select FUNCTION_PROC_DDL_001_Fun_02;

-- DTS2019052101664  
drop table if exists hashjointest_big_table;
create table hashjointest_big_table(id int, name varchar(64));
drop table if exists hashjointest_little_table;
create table hashjointest_little_table(id int, age int);
begin
  for i in 1 .. 100000 loop
    insert into hashjointest_big_table values(1, to_char(i));
  end loop;
  for i in 1 .. 10 loop
    insert into hashjointest_little_table values(2, i);
  end loop;
end;
/

declare
v1 int := 1;
v2 int;
begin
	select count(*) into v2 from hashjointest_big_table big 
	    join hashjointest_little_table little on big.id = v1 and  big.id = little.age and v1 in (1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
	dbe_output.print_line(v2);
end;
/
drop table if exists hashjointest_big_table;
drop table if exists hashjointest_little_table;

-- test record + other type
declare
type zzz is record(a int);
c_r zzz;
c1_r zzz;
begin
  select c_r + 2 into c1_r from dual;
  dbe_output.print_line(c1_r.a);
end;
/

-- test record * other type
declare
type zzz is record(a int);
type yyy is record(r zzz);
c_r yyy;
c1_r zzz;
begin
  select c_r.r * 2 into c1_r from dual;
  dbe_output.print_line(c1_r.a);
end;
/

-- DTS2019061105262 
declare
ct SYS_REFCURSOR; 
begin
	ct := null;
end;
/

-- DTS2019061107304 
drop table if exists exception001_t001;
create table exception001_t001
 (
    f_int1 integer,
    f_bigint1 bigint,
    f_bool1 boolean,
    f_num1 number(38, 0),
    f_dec1 decimal(38, 0),
    f_float float,
    f_double double,
    f_real real,
    f_char1 char(128),
    f_varchar1 varchar(512),
    f_varchar2 varchar2(512),
    f_date1 date,
    f_timestamp timestamp
 );
drop table if exists exception001_t002;
create table exception001_t002
(
    f_int1 integer,
        f_bool2 boolean,
    f_varchar3 varchar(512),
        f_date2 date
);

drop table if exists exception001_t003;
create table exception001_t003 as
( select exception001_t001.f_int1,f_bool1,f_varchar1,f_date1,f_bool2,f_varchar3,f_date2
        from exception001_t001,exception001_t002
);
set serveroutput on;

drop procedure if exists exception001_p001;
create or replace procedure exception001_p001
as
cursor c1 is select exception001_t001.f_int1,f_bool1,f_varchar1,f_date1,f_bool2,f_varchar3,f_date2
                            from exception001_t001 join exception001_t002 on exception001_t001.f_int1 = exception001_t002.f_int1
                                where f_bool2 = false or f_bool1 = true
                                      and exception001_t002.f_int1 in (length('tru'), power(1,3), find_in_set('a','b,c,d,a') )
                                      order by exception001_t001.f_int1;
c2 sys_refcursor;
type t1 is record(a exception001_t003%rowtype);
v1 t1;
c_str varchar2(1024);
i int :=0;
tmp int;
tmp_str char(1);
begin
    insert into exception001_t001 values(1,2,false,3,4,5,6,7,'a','aa','aaa','2018-12-23','2018-12-23');
    insert into exception001_t001 values(2,2,'0',3,4,5,6,7,'c','cc','ccc','2018-12-24','2018-12-24');
    insert into exception001_t001 values(3,2,'0',3,4,5,6,7,'d','dd','ddd','2018-12-25','2018-12-25');
    insert into exception001_t001 values(4,2,true,3,4,5,6,7,'e','ee','eee','2018-12-26','2018-12-26');
    insert into exception001_t001 values(5,2,'0',3,4,5,6,7,'f','ff','fff','2018-12-27','2018-12-27');
    insert into exception001_t002 values(1,true,'a','2018-12-23');
    insert into exception001_t002 values(2,'1','c','2018-12-24');
        insert into exception001_t002 values(3,'1','d','2018-12-25');
        insert into exception001_t002 values(4,false,'e','2018-12-26');
        insert into exception001_t002 values(5,'1','f','2018-12-27');
        c_str := 'select exception001_t001.f_int1,f_bool1,f_varchar1,f_date1,f_bool2,f_varchar3,f_date2
                            from exception001_t001 join exception001_t002 on exception001_t001.f_int1 = exception001_t002.f_int1
                                where f_bool2 = false or f_bool1 = true
                                      and exception001_t002.f_int1 in (length(''tru''), power(1,3), find_in_set(''a'',''b,c,d,a'') )
                                      order by exception001_t001.f_int1';
        --CASE_NOT_FOUND
        begin
            for i in 1..10 loop
                if i<=5 then
               select exception001_t001.f_int1,f_bool1,f_varchar1,f_date1,f_bool2,f_varchar3,f_date2 into v1.a
                              from exception001_t001 join exception001_t002 on exception001_t001.f_int1 = exception001_t002.f_int1
                                  where f_bool2 = true  or f_bool1 = true
                                  and exception001_t002.f_int1 in (length('tru'), power(1,3), find_in_set('a','b,c,d,a') )
                                  order by exception001_t001.f_int1 limit 1;
                           case v1.a.f_varchar1
                        when  v1.a.f_varchar3 then  dbe_output.print_line(true);
                   end case;
                else
                   select exception001_t001.f_int1,f_bool1,f_varchar1,f_date1,f_bool2,f_varchar3,f_date2 into v1.a
                              from exception001_t001 join exception001_t002 on exception001_t001.f_int1 = exception001_t002.f_int1
                                  where f_bool2 = true  or f_bool1 = true
                                  and exception001_t002.f_int1 in (length('tru'), power(1,3), find_in_set('a','b,c,d,a') )
                                  order by exception001_t001.f_int1 limit 1;
                end if;
            end loop;
        exception
            when CASE_NOT_FOUND then                                                                                                                                                                   
              dbe_output.print_line('9 error: CASE_NOT_FOUND');
                          dbe_output.print_line(SQL_ERR_CODE || ' error ' || SQL_ERR_MSG);
            when others then
                      dbe_output.print_line('others error');
                          dbe_output.print_line(SQL_ERR_CODE || ' error ' || SQL_ERR_MSG);
        end;

    execute immediate 'truncate table exception001_t001';
        execute immediate 'truncate table exception001_t002';
        execute immediate 'truncate table exception001_t003';
    exception
        when others then
                    dbe_output.print_line('others error');
                        dbe_output.print_line(SQL_ERR_CODE || ' error ' || SQL_ERR_MSG);
end;
/
call exception001_p001;

drop table if exists TEST_LPAD12;
create table TEST_LPAD12 (COL1 VARCHAR2(20),COL2 integer,COL3 VARCHAR2(20));
insert into TEST_LPAD12 values('hi', 20, $$abc$$);
insert into TEST_LPAD12 values($$hi123$$, 20, 'abc');
insert into TEST_LPAD12 values($$nihao$$, 20,$$zaoshanghao$$);
select lpad(COL1,COL2,COL3) as RESULT from TEST_LPAD12 order by RESULT;
drop table TEST_LPAD12;

select log(log(null,2)+'adbcd',2)  from dual;
select log(2,log(null,3)+'$#NDSau=') from dual;
select log(3,log(null,2)||'$#ND') from dual;
select log(3,log(null,2) +$#ND) from dual;
select log(2,log(null,3)*'$#NDSau=') from dual;

drop table if exists LOB_TAB_001;
CREATE TABLE LOB_TAB_001
(
	C_ID INT,
	c_data clob
); 
declare
	str varchar(32767) :='welcome to lob wrong example.welcome to lob wrong example.welcome to lob wrong example.welcome to lob wrong example.welcome to lob wrong example.';
begin
    for i in 1..8 loop
        str := str||str;
    end loop;
	for i in 1..2 loop
        str:= str||i;
		insert into LOB_TAB_001 values(i,str);
		end loop;
	commit;
end;
/
select DBE_LOB.SUBSTR((select t1.c_data from LOB_TAB_001 t1 limit 1),10,3) STR from dual;
drop  table if exists LOB_TAB_001;

-- DTS2019061406641
create table employees(employeesno int,ename varchar(10),job varchar(10) ,sal integer);
insert into employees values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10010),(123,'zhangsan3','doctor3',10020);
alter table employees add  hiretime datetime;

create or replace  function test_outf1   return sys_refcursor is
type mycurtp is  ref cursor;
cursorv1  mycurtp;
sys_cur1  sys_refcursor;
type  XXX is record(
a varchar2(100),
b number(10,1),
c number(11,1)
);
var1 XXX;
begin
--先赋值；
sys_cur1 := cursorv1;
open  cursorv1 for  select ename as name, sal, sal*2 ep_sal from employees where ename like 'zhangsan%' ;
return  sys_cur1;
end;
/
select OWNER , OBJECT_NAME ,ARGUMENT_NAME ,POSITION ,SEQUENCE ,DATA_LEVEL ,DATA_TYPE ,DEFAULTED ,IN_OUT,DATA_LENGTH,DATA_PRECISION,DATA_SCALE  from dba_arguments where OWNER = 'GS_PLSQL_DTS2' and OBJECT_NAME like 'TEST_OUTF1'  order by  POSITION,ARGUMENT_NAME;
drop function test_outf1;
drop table employees;

-- DTS2019062105223
declare
a '9090898dfdkfkdsjfskjslkdflsdkfjksdlfjsdlfdjklfjsdklfjsdlkfjklgjklfdjglkfdjglkfdjgdflkgjdflkgfdjlkgfd'%type;
begin
   null;
end;
/

-- DTS2019070200731
DECLARE
  my_except EXCEPTION;
  PRAGMA EXCEPTION_INIT(my_except, 932);
BEGIN
  raise my_except;
END;
/

-- DTS2019070105010
drop table if exists PROC_USING_BIND_test_self ;
create table PROC_USING_BIND_test_self (a blob, b varbinary(20));
insert into PROC_USING_BIND_test_self  values(RAWTOHEX ('0123456789abcdef')|| hex('h#2312#%$#@$'), cast(IFNULL(null,'AAAB0141fG') as varbinary(20)));
create or replace procedure PROC_USING_BIND_014_02 (p1 blob, p2 varbinary)
is
cursor1 sys_refcursor;
begin
open  cursor1 for 'select * from  PROC_USING_BIND_test_self where a = :p1 and b = :p2'
using 
p1, p2;
dbe_sql.return_cursor(cursor1);
end;
/
call PROC_USING_BIND_014_02(RAWTOHEX ('0123456789abcdef')|| hex('h#2312#%$#@$'), cast(IFNULL(null,'AAAB0141fG') as varbinary(20)));

-- DTS2019070806102
drop table insert_into_outparam_tt;
create table insert_into_outparam_tt(name_str char(10));
create or replace procedure pInvalidCursor(p1 out char) 
is
begin
	p1 := '012345'; 
	insert into insert_into_outparam_tt values(p1); 
end;
/

DECLARE
  str char(10) := 'abc';
BEGIN
  pInvalidCursor(str);
  dbe_output.print_line(length(str));
  dbe_output.print_line(str);
END;
/

select * from insert_into_outparam_tt;

drop table if exists func_verify_out_arg_table;
create table func_verify_out_arg_table(id int);
insert into func_verify_out_arg_table values(2);
create or replace function func_verify_out_arg_function(p1 in out int) return int
is
v1 int;
begin
    v1 := p1;
	p1 := 123;
	return v1;
end;
/

DECLARE
  v1 int := 3;
  v2 int := 4;
BEGIN
  execute immediate 'drop table func_verify_out_arg_table';
  execute immediate 'create table func_verify_out_arg_table(id int)';
  execute immediate 'insert into func_verify_out_arg_table values(2)';
  select id into v1 from func_verify_out_arg_table where id = func_verify_out_arg_function(v2);
  dbe_output.print_line('v1');
  dbe_output.print_line(v1);
  dbe_output.print_line(v2);
END;
/

-- create out char --------------------------------------------
create or replace procedure test_out_param_proc(p1 out char) 
is
begin
  p1 := '2147483647';
  dbe_output.print_line(length(p1));
  p1 := '2147483647000000000000000000000000000000';
  dbe_output.print_line(length(p1));
end;
/

-- char to char
DECLARE
  v1 char(5) := 'abc';
BEGIN
  test_out_param_proc(v1);
  dbe_output.print_line(length(v1));
  dbe_output.print_line(v1);
END;
/

-- varchar to char
DECLARE
  v1 varchar(5) := 'abc';
BEGIN
  test_out_param_proc(v1);
  dbe_output.print_line(length(v1));
  dbe_output.print_line(v1);
END;
/

-- int to char
DECLARE
  v1 int := 0;
BEGIN
  test_out_param_proc(v1);
  dbe_output.print_line(length(v1));
  dbe_output.print_line(v1);
END;
/

-- create inout char --------------------------------------------
create or replace procedure test_out_param_proc(p1 in out char) 
is
begin
  p1 := '2147483647';
  dbe_output.print_line(length(p1));
  p1 := '2147483647000000000000000000000000000000';
  dbe_output.print_line(length(p1));
end;
/

-- varchar to char
DECLARE
  v1 varchar(50) := '2147483647000000000000000000000000000000';
BEGIN
  dbe_output.print_line(length(v1));
  test_out_param_proc(v1);
  dbe_output.print_line(length(v1));
  dbe_output.print_line(v1);
END;
/

-- create out varchar --------------------------------------------
create or replace procedure test_out_param_proc(p1 out varchar) 
is
begin
  p1 := '2147483647';
  dbe_output.print_line(length(p1));
  p1 := '2147483647000000000000000000000000000000';
  dbe_output.print_line(length(p1));
end;
/

-- char to varchar
DECLARE
  v1 char(5) := 'abc';
BEGIN
  test_out_param_proc(v1);
  dbe_output.print_line(length(v1));
  dbe_output.print_line(v1);
END;
/

-- varchar to varchar
DECLARE
  v1 varchar(5) := 'abc';
BEGIN
  test_out_param_proc(v1);
  dbe_output.print_line(length(v1));
  dbe_output.print_line(v1);
END;
/

-- int to varchar
DECLARE
  v1 int := 0;
BEGIN
  test_out_param_proc(v1);
  dbe_output.print_line(length(v1));
  dbe_output.print_line(v1);
END;
/

-- create out number --------------------------------------------
create or replace procedure test_out_param_proc(p1 out number) 
is
begin
  p1 := 32.4494;
  p1 := p1 + 0.0006;
end;
/

-- int to number
DECLARE
  v1 int := 0;
BEGIN
  test_out_param_proc(v1);
  dbe_output.print_line(length(v1));
  dbe_output.print_line(v1);
END;
/

-- number to number
DECLARE
  v1 number(10,1) := 0;
BEGIN
  test_out_param_proc(v1);
  dbe_output.print_line(length(v1));
  dbe_output.print_line(v1);
END;
/

-- number to number
DECLARE
  v1 number(3,2) := 0;
BEGIN
  test_out_param_proc(v1);
  dbe_output.print_line(length(v1));
  dbe_output.print_line(v1);
END;
/

-- create return char --------------------------------------------
create or replace function test_out_param_func(p1 out char) return char
is
v1 char(10) := '2147483';
begin
  p1 := v1;
  dbe_output.print_line(length(p1));
  return p1;
end;
/

-- char return char
DECLARE
  v1 char(20) := 'abc';
  v2 int := 0;
BEGIN
  v1 := test_out_param_func(v2);
  dbe_output.print_line(length(v1));
  dbe_output.print_line(v1);
END;
/

-- create return char --------------------------------------------
create or replace function test_out_param_func(p1 out char) return char
is
begin
  p1 := '2147483';
  dbe_output.print_line(length(p1));
  p1 := '21474';
  dbe_output.print_line(length(p1));
  return p1;
end;
/

-- char return char
DECLARE
  v1 char(10) := 'abc';
  v2 int := 0;
BEGIN
  v1 := test_out_param_func(v2);
  dbe_output.print_line(length(v1));
  dbe_output.print_line(v1);
END;
/

-- char return char
DECLARE
  v1 char(10);
BEGIN
  v1 := test_out_param_func(v1);
  dbe_output.print_line(length(v1));
  dbe_output.print_line(v1);
END;
/

-- char return char
DECLARE
  v1 varchar(10);
BEGIN
  v1 := test_out_param_func(v1);
  dbe_output.print_line(length(v1));
  dbe_output.print_line(v1);
END;
/

-- create return char --------------------------------------------
create or replace function test_out_param_func(p1 in out char) return char
is
begin
  dbe_output.print_line(length(p1));
  return p1;
end;
/

DECLARE
  v1 varchar(5) := '321';
  v2 varchar(5) := '4563';
BEGIN
  dbe_output.print_line(test_out_param_func(v1) || test_out_param_func(v2));
END;
/

-- DTS2019071110397
drop table if exists func_verify_out_arg_table;
create table func_verify_out_arg_table(id int);
insert into func_verify_out_arg_table values(2);
declare 
pragma autonomous_transaction;
begin
 execute immediate 'begin insert into func_verify_out_arg_table values(3); end;';
 execute immediate'prepare transaction ''0.ABABAAA000.006501''';
 execute immediate 'begin insert into func_verify_out_arg_table values(4); end;';
 commit;
end;
/
select * from func_verify_out_arg_table;

-- DTS2019071807624
create or replace function FVT_FUN_01_01(id int) return int 
is
ret int;
begin
	ret := id;
	if id > 0 then
	select FVT_FUN_01_01(id - 1) + id into ret from dual;
	end if;
	return ret;
end;
/
select FVT_FUN_01_01(4);
create or replace procedure FVT_PROC_01_01(id int)
is
ret int;
begin
	ret := id;
	if id > 0 then
	select FVT_PROC_01_01(id - 1) + id into ret from dual;
	end if;
end;
/
select max from dual;
select exp;

-- DTS2019072909080
drop table if exists FVT_TABLE_TEST_01_01;
create table FVT_TABLE_TEST_01_01(a int);
insert into FVT_TABLE_TEST_01_01 values(1);
select * from FVT_TABLE_TEST_01_01;
create or replace procedure FVT_PRO_TEST_02_01 AS
	v_sql varchar(8000);
BEGIN
	v_sql:='create or replace procedure ABCDEFGHIJKis a int; begin a:=0; end';
	dbe_output.print_line(v_sql);
	execute immediate v_sql;
	insert into FVT_TABLE_TEST_01_01 values(3);
END;
/
call FVT_PRO_TEST_02_01();
select * from FVT_TABLE_TEST_01_01;
create or replace procedure pro_uu_1 is
begin
null;
end;
/
conn sys/Huawei@123@127.0.0.1:1611
grant select on sys.sys_procs to gs_plsql_dts2;
conn gs_plsql_dts2/Lh00420062@127.0.0.1:1611
select TRIG_STATUS from sys.sys_procs where name='PRO_UU_1';
create or replace procedure pro_uu_1 is
begin
null;
end;
/
select TRIG_STATUS from sys.sys_procs where name='PRO_UU_1';

-- DTS2019080702341
drop table if exists using_for_proc_table;
create table using_for_proc_table(id int default 0, name varchar(20) default 'abc');
declare
v1 using_for_proc_table%rowtype;
v2 using_for_proc_table.id%type;
begin
  if v1.id is null then
   dbe_output.print_line('null');
  end if;
  if v1.name is null then
   dbe_output.print_line('null');
  end if;
  if v2 is null then
   dbe_output.print_line('null');
  end if;
end;
/

drop table if exists fun_dynamic_sql_table;
create table fun_dynamic_sql_table(id int);
create or replace procedure dynamic_sql_fail_func(id int) 
is
begin
    execute immediate 'insert into fun_dynamic_sql_table values(:1)' using id;
end;
/
call dynamic_sql_fail_func(0);
drop table fun_dynamic_sql_table;
call dynamic_sql_fail_func(1);
create table fun_dynamic_sql_table(id int);
call dynamic_sql_fail_func(2);
select id from fun_dynamic_sql_table;

-- DTS2019080710386
set charset gbk;
DECLARE
    vc_sql varchar(2 char); 
    c_sql char(4 char); 
BEGIN
    vc_sql := '一二';
    dbe_output.print_line('---' || vc_sql);
    dbe_output.print_line(length(vc_sql));
    c_sql := '一二';
    dbe_output.print_line('---' || c_sql);
    dbe_output.print_line(length(c_sql));
END;
/

DECLARE
    vc_sql varchar(2 char); 
BEGIN
    vc_sql := '一二三';
END;
/

DECLARE
    vc_sql varchar(16000 char); 
BEGIN
    for i in 1..2000 loop
    vc_sql := vc_sql || '一二三四五六';
	end loop;
END;
/

DECLARE
    c_sql char(4000 char); 
BEGIN
    for i in 1..1000 loop
    c_sql := c_sql || '一二三';
	end loop;
END;
/

create or replace procedure varchar_param_out_proc(p1 out varchar) is
begin
	p1 := '一三';
end;
/

-- DTS2019082809321
create or replace procedure varchar_param_out_proc(p1 out varchar) is
begin
	p1 := '一三一三一三一三一三';
end;
/

DECLARE
    vc_sql varchar(10 char);
BEGIN
	execute immediate 'begin varchar_param_out_proc(:1); end;' using out vc_sql;
    dbe_output.print_line('---' || vc_sql);
    dbe_output.print_line(length(vc_sql));
END;
/
set charset utf8;

-- DTS2019083010567
declare
type zzz is record(
a int,
a int);
a zzz;
begin
 a.a := 1;
end;
/

-- DTS2019111103442
declare
  TYPE varray1 IS VARRAY(4) OF clob;
  var1 varray1 := varray1('null', 'null', '', '');
begin
	dbe_output.print_line(var1(3));
end;
/

-- DTS2019112011773 start
create or replace type array_varchar2 is varray(10) of varchar(100);
/

declare
zz array_varchar2:=array_varchar2('a','b');
yy array_varchar2;
str_l_querysql varchar(100);
begin
    str_l_querysql := 
	' begin
	:1 := :2;
	end;';
    execute immediate str_l_querysql using out yy, zz;
	dbe_output.print_line(yy(2));
end;
/

create or replace type object_varchar2 is object(a varchar(100));
/

declare
zz object_varchar2:=object_varchar2('cd');
yy object_varchar2;
str_l_querysql varchar(100);
begin
    str_l_querysql := 
	' begin
	:1 := :2;
	end;';
    execute immediate str_l_querysql using out yy, zz;
	dbe_output.print_line(yy.a);
end;
/

create or replace procedure bind_param_func_test(p1 object_varchar2, p2 out object_varchar2)
is
begin
 p2 := p1;
end;
/

declare
zz object_varchar2:=object_varchar2('cd');
yy object_varchar2;
str_l_querysql varchar(100);
begin
    str_l_querysql := 
	' begin
	bind_param_func_test(:1, :2);
	end;';
    execute immediate str_l_querysql using zz, out yy;
	dbe_output.print_line(yy.a);
end;
/

-- DTS2019112011773 end
--table function cast
create or replace type my_type1 is object (id number, name varchar2(32));
 /
create or replace type my_type2 is table of my_type1;
 /
drop table if exists test_cast_table;

create table test_cast_table(id number, name varchar2(32));

insert into test_cast_table values(1,'happy');
insert into test_cast_table values(2,'like');
insert into test_cast_table values(3,'love');

create or replace function g_DV_LOG_FILES1 return my_type2
  is
     l_DV_LOG_FILES_tab my_type2 ;
	 n integer := 0;
  begin
       l_DV_LOG_FILES_tab := my_type2();
    for r in (select id, name from test_cast_table)
     loop
        l_DV_LOG_FILES_tab.extend;
        n := n + 1;
       l_DV_LOG_FILES_tab(n) := my_type1(r.id, r.name);
     end loop;
     return l_DV_LOG_FILES_tab;
  end;
  /
  
  
select * from table(cast(g_DV_LOG_FILES1 as my_type2));
select * from table(cast(g_DV_LOG_FILES1 as my_type2)) where id > 1;
select * from table(cast(g_DV_LOG_FILES1 as my_type2)) where name = 'love';
select * from table(cast(g_DV_LOG_FILES1 as my_type2)) order by id desc;
select * from table(cast(g_DV_LOG_FILES1 as my_type2)) order by name desc;
 
 declare
 l_DV_LOG_FILES_tab my_type2 ;
 begin
 l_DV_LOG_FILES_tab := g_DV_LOG_FILES1;
 end;
 /
 
create table cast_table(id number, name varchar2(32));
BEGIN
    insert into cast_table select * from table(cast(g_DV_LOG_FILES1 as my_type2));
END;
/

select * from cast_table;

create or replace type test_type_varchar1 is table of varchar2(24);  
/ 

create or replace function my_func_1 return test_type_varchar1
  is
     l_DV_LOG_FILES_tab test_type_varchar1:= test_type_varchar1();
  begin	
    l_DV_LOG_FILES_tab := test_type_varchar1('abc', 'def');
     return l_DV_LOG_FILES_tab;
  end;
 /
 
create table if not exists test_t1(f1 varchar(30));
 
select * from table(cast(my_func_1 as test_type_varchar1)) where column_value = 'def';

BEGIN
	insert  into test_t1 select * from table(cast(my_func_1 as test_type_varchar1));
END;
/

select * from test_t1;
select * from table(cast(my_func_1 as test_type_varchar1));
drop type my_type1 force;
drop type my_type2 force;
drop table test_cast_table;
drop table test_t1;
drop table cast_table;
drop type test_type_varchar1 force;
drop function my_func_1;
drop function g_DV_LOG_FILES1;
--DTS2019120907768
CREATE OR REPLACE TYPE ARRAY_NUMBER is table of number(20);
/

create or replace function f_ring_di_getdirexcludetones1() return array_number
is
    vntbl_l_dirindex array_number;
begin
    return vntbl_l_dirindex;      
end f_ring_di_getdirexcludetones1;
/

select * from table(cast(f_ring_di_getdirexcludetones1 as gs_plsql_dts2.array_number));

create or replace procedure p_ring_qr_getdirtonecount1 as
    vntbl_l_dirindex array_number;
    i_l_countdirindex number(5);
begin
     vntbl_l_dirindex := f_ring_di_getdirexcludetones1();
   select count('X') into i_l_countdirindex from table(cast(vntbl_l_dirindex as array_number)) where 1 =1;                                                          
    return;
end p_ring_qr_getdirtonecount1;
/
call p_ring_qr_getdirtonecount1;
drop TYPE ARRAY_NUMBER force;
drop function f_ring_di_getdirexcludetones1;
drop procedure p_ring_qr_getdirtonecount1;

-- s lock up to x lock start
create or replace procedure test_replace_self_proc() 
is
sql_str varchar(200);
begin
  sql_str := 'create or replace procedure test_replace_self_proc() 
is
begin
  dbe_output.print_line(''replace self success!!'');
end;';
  execute immediate sql_str;
end;
/

call test_replace_self_proc();
call test_replace_self_proc();
-- s lock up to x lock end
--DTS2019121211155
declare
type type_table1 is table of int;
type type_table2 is table of type_table1;
types type_table2:= type_table2(type_table1(1,2,3),type_table1(1,2,3));
begin
types(1)(jhfalj):=1;
end;
/

create or replace procedure casttype is
type type_table is table of int;
types type_table:=type_table(1,2,3);
begin
types(/122):=1;
types(afg):=1;
end;
/

drop procedure casttype;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_plsql_dts2 cascade;

--ple_push_decls
declare
a varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
b varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
c varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
d varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
e varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
f varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
g varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
h varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
i varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
j varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
k varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
l varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
m varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
n varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
o varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
p varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
q varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
r varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
s varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
t varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
u varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
v varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
w varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
x varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
y varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
a1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
b1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
c1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
d1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
e1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
f1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
g1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
h1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
i1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
j1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
k1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
l1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
m1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
n1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
o1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
p1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
q1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
r1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
s1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
t1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
u1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
v1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
w1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
x1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
y1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
a2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
b2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
c2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
d2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
e2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
f2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
g2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
h2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
i2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
j2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
k2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
l2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
m2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
n2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
o2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
p2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
q2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
r2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
s2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
t2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
u2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
v2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
w2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
x2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
y2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qa varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qb varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qc varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qd varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qe varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qf varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qg varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qh varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qi varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qj varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qk varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
ql varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qm varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qn varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qo varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qp varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qq varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qr varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qs varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qt varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qu varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qv varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qw varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qx varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qy varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qa1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qb1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qc1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qd1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qe1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qf1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qg1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qh1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qi1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qj1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qk1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
ql1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qm1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qn1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qo1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qqq varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qq1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qr1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qs1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qt1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qu1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qv1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qw1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qx1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qy1 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qa2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qb2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qc2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qd2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qe2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qf2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qg2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qh2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qi2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qj2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qk2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
ql2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qm2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qn2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qo2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qp2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qq2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qr2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qs2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qt2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qu2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qv2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qw2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qx2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
qy2 varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
wa varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
wb varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
wc varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
wd varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
we varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
wf varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
wg varchar(8000):='sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
type z is table of int;
BEGIN
  dbe_output.print_line('a');
END;
/

set serveroutput off;