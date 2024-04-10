conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_plsql_dts6 cascade;
create user gs_plsql_dts6 identified by Cantian_234;
grant dba to gs_plsql_dts6;
conn gs_plsql_dts6/Cantian_234@127.0.0.1:1611
set serveroutput on;

alter system set EMPTY_STRING_AS_NULL=false;
drop table if exists tt_clob;
create table tt_clob(a int primary key, jsdoc clob);
ALTER TABLE tt_clob ADD CHECK(jsdoc IS JSON);
insert into tt_clob values(1,'{"fruit": [{"name": "banana", "size": "medium"}]}');
insert into tt_clob values(1,'') on duplicate key update a=2,jsdoc='';
alter system set EMPTY_STRING_AS_NULL=true;


declare
    sql1 varchar(1024);
    val int;
begin
    savepoint aa1;
    begin
        savepoint aa2;
        execute immediate 'savepoint aa3';
    end;
    select value into val from dv_gma_stats where  POOL='sql pool' and NAME='free page count';
    for i in 1..val loop
        sql1 := 'select '||i||' from sys_dummy';
        execute immediate sql1;
    end loop;
    select value into val from dv_gma_stats where  POOL='sql pool' and NAME='free page count';
    --dbe_output.print(val);
    execute immediate 'rollback to aa3';
    rollback to aa2;
    rollback to aa1;
end;
/

conn sys/Huawei@123@127.0.0.1:1611

--PL_MAX_BLOCK_DEPTH
DROP TABLE IF EXISTS table_temp;
CREATE TABLE table_temp(f1 INT, f2 VARCHAR2(20));
--128
CREATE OR REPLACE PROCEDURE p_no_param IS
begin
begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin
  INSERT INTO table_temp VALUES(1,'xxx');
end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end;
end;
/
call p_no_param();

--129
CREATE OR REPLACE PROCEDURE p_no_param IS
begin
begin
begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin begin
  INSERT INTO table_temp VALUES(1,'xxx');
end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end;
end;
end;
/
call p_no_param();
DROP PROCEDURE p_no_param;
DROP TABLE IF EXISTS table_temp;

DROP TABLE IF EXISTS t_sql_plan PURGE;
CREATE TABLE t_sql_plan(SNAP_TIME  DATE)
PARTITION BY RANGE(SNAP_TIME) INTERVAL (NUMTODSINTERVAL(1,'DAY')) (PARTITION P_0 VALUES LESS THAN (TO_DATE('2009-02-01','YYYY-MM-DD')));
CREATE OR REPLACE PROCEDURE WSR$WRITE_INSTANCE_SNAP2
AS
BEGIN
    INSERT INTO t_sql_plan( SNAP_TIME)VALUES(SYSDATE);
END;
/
DROP TABLE IF EXISTS t_sql_plan PURGE;

CREATE OR REPLACE function f_random_string() return VARCHAR2 AS
c VARCHAR2(2000);
BEGIN
    c := DBE_RANDOM.GET_STRING(flag  => 'a',len  => 5);
    c := DBE_RANDOM.GET_VALUE(2,1);
    return 1;
END;
/

select f_random_string();



drop table if exists parallel_scan_tab;
create table parallel_scan_tab
(
a int,
b varchar(1024)
);

begin
        for i in 1..10 loop
                insert into parallel_scan_tab values(i,i||i);
        end loop;
end;
/
commit;

declare
beg_id number;
end_id number;
scn_id number;
d int;
e int;
begin
        select BEG,END into beg_id,end_id from table(get_tab_parallel('parallel_scan_tab', 1));
        select current_scn into scn_id from dv_database;
         execute immediate 'select count(1) from parallel_scan_tab as of scn :x' into d using scn_id;
         dbe_output.print_line(d);
        insert into parallel_scan_tab values(11,'bb');
        insert into parallel_scan_tab values(12,'gg');
        commit;
        select count(1) into e from table(get_tab_rows('parallel_scan_tab', -1,scn_id,NULL, beg_id,end_id)) ;
        dbe_output.print_line(e);
end;
/

create or replace function fun_stack_depth_002(num int) return clob
is
 v_lang clob := 'abc';
BEGIN
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
 FOR I IN 1 .. num 
 LOOP
    if num>0 then
	v_lang := v_lang || 'e';
	end if;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 END LOOP;
 return v_lang;
END;
/

create or replace procedure procedureA() as 
begin
    dbe_output.print_line(1);
end;
/
create or replace procedure procedureA1() as 
begin
    procedureA();
end;
/
create or replace procedure procedureA2() as 
begin
    procedureA1();
end;
/
create or replace procedure procedureA3() as 
begin
    procedureA2();
end;
/

create or replace procedure procedureA4() as 
begin
    procedureA3();
end;
/
create or replace procedure procedureA5() as 
begin
    procedureA4();
end;
/
create or replace procedure procedureA6() as 
begin
    procedureA5();
end;
/
create or replace procedure procedureA7() as 
begin
    procedureA6();
end;
/
create or replace procedure procedureA8() as 
begin
    procedureA7();
end;
/
create or replace procedure procedureA9() as 
begin
    procedureA8();
end;
/
create or replace procedure procedureA10() as 
begin
    procedureA9();
end;
/
create or replace procedure procedureA11() as 
begin
    procedureA10();
end;
/
create or replace procedure procedureA12() as 
begin
    procedureA11();
end;
/
create or replace procedure procedureA13() as 
begin
    procedureA12();
end;
/
create or replace procedure procedureA14() as 
begin
    procedureA13();
end;
/

create or replace procedure procedureA15() as 
begin
    procedureA14();
end;
/

create or replace procedure procedureA16() as 
begin
    procedureA15();
end;
/

create or replace procedure procedureA17() as 
begin
    procedureA16();
end;
/
create or replace procedure procedureA18() as 
begin
    procedureA17();
end;
/
create or replace procedure procedureA19() as 
begin
    procedureA18();
end;
/
create or replace procedure procedureA20() as 
begin
    procedureA19();
end;
/
create or replace procedure procedureA21() as 
begin
    procedureA20();
end;
/

create or replace procedure procedureA22() as 
begin
    procedureA21();
end;
/

create or replace procedure procedureA23() as 
begin
    procedureA22();
end;
/

create or replace procedure procedureA24() as 
begin
    procedureA23();
end;
/

create or replace procedure procedureA25() as 
begin
    procedureA24();
end;
/

create or replace procedure procedureA26() as 
begin
    procedureA25();
end;
/

create or replace procedure procedureA27() as 
begin
    procedureA26();
end;
/

create or replace procedure procedureA28() as 
begin
    procedureA27();
end;
/

create or replace procedure procedureA29() as 
begin
    procedureA28();
end;
/

create or replace procedure procedureA30() as 
begin
    procedureA29();
end;
/

create or replace procedure procedureA31() as 
begin
    procedureA30();
end;
/

create or replace procedure procedureA32() as 
begin
    procedureA31();
end;
/

create or replace procedure procedureA() as 
begin
    dbe_output.print_line(1);
end;
/

call procedureA32();

--nameable datatype as right value in pl, such as int
drop table if exists t123;
create table t123(int int, id int);
insert into t123 values(12, 45);
commit;
select sum(int) from t123 where int < 20;
select dense_rank(15) within group (order by int) from t123;

CREATE OR REPLACE FUNCTION ztest_f1112(a int, b int) RETURN int
AS
int int;
n int;
id int := 3;
BEGIN
int := a + b + 2;
dbe_output.print_line(int);
n := int;
dbe_output.print_line(n);
select id into n from t123; --When a column name has the same name as a variable, the variable takes precedence
dbe_output.print_line(n);
select int into int from t123;
RETURN int;
END;
/
select ztest_f1112(int, 2) from t123;

declare
c2 sys_refcursor;
type type_name is record
(c_int int,
c_id int);
int type_name;
begin
open c2 for select * from t123;
fetch c2 into int;
close c2;
DBE_OUTPUT.PRINT_LINE('Happy new year ' || int.c_int);
DBE_OUTPUT.PRINT_LINE('Happy new year ' || int.c_id);
end;
/
drop table if exists t123;

--error: Built-in Advanced Packages(FO_PROC) as right value
conn sys/Huawei@123@127.0.0.1:1611
drop PUBLIC synonym if exists SP_DBE_STD;
create or replace public synonym SP_DBE_STD for DBE_STD;
conn gs_plsql_dts6/Cantian_234@127.0.0.1:1611
--plc_compile_return->plc_verify_expr
drop function if exists f_DBMS_STANDARD;
CREATE OR REPLACE function f_DBMS_STANDARD() return varchar2 AS
BEGIN
    execute immediate '
    declare
        begin
        a := DBE_RANDOM.GET_VALUE(low  => 100,high  => 200);
        end';
EXCEPTION
        WHEN others THEN SP_DBE_STD.THROW_EXCEPTION(error_code => -20009,message => 'error1');
        return SP_DBE_STD.THROW_EXCEPTION(error_code => -20009,message => 'error1');
END;
/
CREATE OR REPLACE function f_DBMS_STANDARD() return varchar2 AS
BEGIN
    execute immediate '
    declare
        begin
        a := DBE_RANDOM.GET_VALUE(low  => 100,high  => 200);
        end';
	return DBE_LOB.SUBSTR('CERTPIC',4);
EXCEPTION
        WHEN others THEN SP_DBE_STD.THROW_EXCEPTION(error_code => -20009,message => 'error1');
END;
/
select f_DBMS_STANDARD();

CREATE OR REPLACE function f_DBMS_STANDARD() return varchar2 AS
BEGIN
    execute immediate '
    declare
	    a int;
        begin
        a := DBE_RANDOM.GET_VALUE(low  => 100,high  => 200);
        end';
	return DBE_LOB.SUBSTR('CERTPIC',4);
EXCEPTION
        WHEN others THEN SP_DBE_STD.THROW_EXCEPTION(error_code => -20009,message => 'error1');
END;
/
select f_DBMS_STANDARD();

CREATE OR REPLACE function f_DBMS_STANDARD(b int) return varchar2 AS
BEGIN
    return SLEEP(1);
END;
/

drop procedure if exists procedure_002;
CREATE OR REPLACE PROCEDURE procedure_002(a in int) IS
b int;
BEGIN
  b := a;
END;
/
CREATE OR REPLACE function f_DBMS_STANDARD(b int) return varchar2 AS
BEGIN
    return procedure_002(1);
END;
/
drop procedure procedure_002;

--plc_verify_using_expr
CREATE OR REPLACE function f_DBMS_STANDARD() return varchar2 AS
BEGIN
    execute immediate '
        declare
	    a varchar2;
        begin
        a := :1;
		dbe_output.print_line(''a'');
        end' using SP_DBE_STD.THROW_EXCEPTION(error_code => -20010,message => 'error1');
        return '2';
END;
/
drop function f_DBMS_STANDARD;


--plc_verify_setval->plc_verify_expr
declare
a varchar(30);
begin
a := SP_DBE_STD.THROW_EXCEPTION(error_code => -20010,message => 'error2');
dbe_output.print_line(a || ' 3');
end;
/
begin
 sleep(2) := 2;
end;
/
--plc_compile_default_def->plc_verify_expr
declare
a varchar(30) default sleep(2);
begin
dbe_output.print_line(a || ' 3');
end;
/
--plc_expected_fetch_range->plc_verify_expr
begin
 for i in 1 .. sleep(2) loop
  dbe_output.print_line(' 3');
 end loop;
end;
/
--plc_try_compile_when_case->plc_verify_expr
declare
a int := null;
begin
 CASE a
    WHEN dbe_task.run(1008) THEN
      dbe_output.print_line('1');
    ELSE
      dbe_output.print_line('2');
  END CASE;
end;
/

drop table if exists test_exception;
create table test_exception(i int, msg varchar(50));
begin 
 for i in 1..500 loop
    insert into test_exception values(1, 'msg');
 end loop;
 commit;
end;
/
 
create or replace procedure test_exeception_block()
as 
    RPTEXCEPTION EXCEPTION ;
begin
    for res in (select i, msg from test_exception) loop
        begin
            IF (res.i  = 1) THEN
                RAISE RPTEXCEPTION;
            END IF;
        EXCEPTION 
             WHEN RPTEXCEPTION THEN
                NULL;
        end;
    end loop;
end;
/
call test_exeception_block();

create or replace procedure test_if_cond() as
i int;
begin
i:=1;
if (i != 1) then
 dbe_output.print_line('i != 1');
end if;

if (i = 1) then
    begin
        if (i < 0) then
            dbe_output.print_line('i < 0');
        else 
            if (i < 0) then
               dbe_output.print_line('i < 0');
            else
                begin
                    dbe_output.print_line('i = 1');
                end;
            end if;
        end if;
    end;
else
    begin
        dbe_output.print_line('i != 1');
    end;
end if;
end;
/

call test_if_cond();

exec dbe_output.print_line(prior);
exec dbe_output.print_line(sys_connect_by_path(1,1));
exec dbe_output.print_line(grouping);
exec dbe_output.print_line(grouping_id);

conn sys/Huawei@123@127.0.0.1:1611
drop PUBLIC synonym SP_DBE_STD;
drop user if exists gs_plsql_dts6 cascade;
set serveroutput off;