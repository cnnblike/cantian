--from gsql_test/sql_empty_string.sql
select DBE_LOB.get_length('123') from dual;
select 1 from dual where DBE_LOB.get_length('') is null;
select 1 from dual where DBE_LOB.get_length('') = 0;
select DBE_LOB.SUBSTR('123',1,3) from dual;
select 1 from dual where DBE_LOB.SUBSTR('123',-10,1) = '';
select 1 from dual where DBE_LOB.SUBSTR('123',-10,1) is null;
select 1 from dual where DBE_LOB.SUBSTR('123',2,5) = '';
select 1 from dual where DBE_LOB.SUBSTR('123',2,5) is null;
select 1 from dual where DBE_LOB.SUBSTR('',1,3) is null;
select 1 from dual where DBE_LOB.SUBSTR('',1,3) = '';


--from gsql_test/sql_upper_lower.sql
--DTS2019062809663
select DBE_LOB.SUBSTR('șșțăîțîâîă',1,5) from dual;
select DBE_LOB.SUBSTR('șșțăîțîâîă',30,9)  from dual;
select DBE_LOB.SUBSTR('șșțăîțîâîă',30,11)  from dual;
select DBE_LOB.SUBSTR('ⅰ南京  ⅱ  研究所  ⅲ  雨花台  ⅳ  软件大道  ⅴ、ⅵ、ⅶ、ⅷ、ⅸ、ⅹ',10,5) from dual;
select DBE_LOB.SUBSTR('А а Б б В в Г г Д д Е е',-1,9)  from dual;
select DBE_LOB.SUBSTR('А а Б б В в Г г Д д Е е',1,-1)  from dual;
select DBE_LOB.SUBSTR('А а Б б В в Г г Д д Е е',0,9)  from dual;
select DBE_LOB.SUBSTR('А а Б б В в Г г Д д Е е',1,0)  from dual;


--from gsql_test/sql_proc_1.sql
--DTS2019062100657
set serveroutput on;

drop table if exists fvt_pragma_table_03;
create table fvt_pragma_table_03 (c_int int,c_number number,c_varchar varchar(80));
insert into fvt_pragma_table_03 values(1,1.25,'abcd');
insert into fvt_pragma_table_03 values(2,2.25,'efgh');
commit;

drop procedure if exists fvt_pragma_proc_03;
create or replace procedure fvt_pragma_proc_03 is
pragma autonomous_transaction;
begin
    update fvt_pragma_table_03 set c_int = 100 where c_int < 10;
	for i in 1..10
	loop
		insert into fvt_pragma_table_03 values(i,3.25,'hijk');
	end loop;
commit;
end;
/

declare 
pragma autonomous_transaction;
TYPE tcur IS REF CURSOR;
cursor_k tcur;
b number := 0;
b_number number := 0;
cursor c_job is select c_varchar from fvt_pragma_table_03 where c_varchar='hijk';
c varchar(100) := 'abc';
begin
	fvt_pragma_proc_03;
	execute immediate 'alter table fvt_pragma_table_03 rename column c_int to c_id';
	delete from fvt_pragma_table_03 where c_varchar = 'hijk';
	open cursor_k for select c_number from fvt_pragma_table_03;
	fetch cursor_k into b;
	dbe_output.print_line(b);
	close cursor_k;
	open c_job;
	fetch c_job into c;
	rollback;
	dbe_output.print_line(b);
	close c_job;
rollback;
end;
/

select * from fvt_pragma_table_03 order by c_id desc;
drop table fvt_pragma_table_03;
drop procedure fvt_pragma_proc_03;


--from gsql_test/sql_proc.sql
-- 5 anonymous_block
DECLARE
    grade CHAR(1) := 'B';
    appraisal VARCHAR2(20);
BEGIN    
    appraisal := CASE grade
            WHEN 'A' THEN  'Excellent'
            WHEN 'B' THEN  'Very Good'
            WHEN 'C' THEN  'Good'
            WHEN 'D' THEN  'Fair'
            WHEN 'F' THEN  'Poor'
            ELSE 'No such grade'
        END ;
    dbe_output.print_line(appraisal);
END;
/

--6
declare
   v_bool boolean;
begin
  v_bool:=(1+2+3+4+5=3*5);
	if(v_bool)
	then
     dbe_output.print_line('The condition is true');
  end if;
end;
/
--7
declare
v_sal int;
begin
v_sal := 1;
v_sal := v_sal + 1;
dbe_output.print_line('value1:'||v_sal);
if v_sal < 2 then
   dbe_output.print_line('value2:'||v_sal);
elsif v_sal = 2 then
   if v_sal != 2 then
     dbe_output.print_line('value3:'||v_sal);
   else
     dbe_output.print_line('value3x:'||v_sal);
   end if;
elsif v_sal = 4 then
   dbe_output.print_line('value4:'||v_sal);
else
   dbe_output.print_line('value5:'||v_sal);
end if;
dbe_output.print_line('value6:'||to_char(v_sal+2));
end;
/
--8
DECLARE
x NUMBER;
BEGIN
x := 0;
LOOP
  dbe_output.print_line ('Inside loop: x = ' || x);
  x := x + 1;
  IF x > 3 THEN
     dbe_output.print_line(' BEGIN EXIT ');
     EXIT WHEN x > 4;
     dbe_output.print_line(' AFTER EXIT ');
  END IF;
END LOOP;
dbe_output.print_line(' After loop: x = ' || x);
END;
/
--9
DECLARE
x NUMBER;
BEGIN
x := 0;
while x <= 1 LOOP
dbe_output.print_line ('here:' || x);
x := x + 1;
END LOOP;
END;
/

--10 cursor
drop table if exists emp;
create table emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into emp values(1,'zhangsan','doctor1',10000);
insert into emp values(2,'zhangsan2','doctor2',10000);
insert into emp values(123,'zhangsan3','doctor3',10000);
insert into emp values(1,'zhansi','doctor1',10000);
insert into emp values(2,'lisiabc','doctor2',10000);
insert into emp values(123,'zhangwu123','doctor3',10000);
--commit;

declare
   cursor cv(v_empno int,v_job varchar2) is select * from emp where empno=v_empno and job =v_job;
BEGIN
        for i in cv(1,'doctor1')
        loop
        dbe_output.print_line('ename ='||i.ename);
        end loop;
end;
/

--11
create or replace function syscur_028(v_num int) return sys_refcursor
is
        cv1 SYS_REFCURSOR;
        v_empno NUMBER(10,0);
begin
        select count(*) INTO v_empno from emp;
        if v_empno <> v_num then
                open cv1 for select 1 from dual;
        else
                open cv1 for select 0 from dual;
        end if;
        RETURN cv1;
end;
/

declare
cv sys_refcursor;
v_empno emp.empno%type;
begin
cv :=syscur_028(10);
loop
fetch cv into v_empno;
exit when cv%notfound;
dbe_output.print_line('v_empno is '|| v_empno);
end loop;
close cv;
end;
/
--12
DECLARE
   v_emp_test     emp%ROWTYPE;
   cursor cv is SELECT * FROM emp where empno=1 for update;
   BEGIN
   OPEN cv;
   FETCH cv INTO v_emp_test;
   while cv%FOUND LOOP
       update emp set sal=sal+1000 where current of cv;
       dbe_output.print_line(rpad(v_emp_test.empno,15,' ')||rpad(v_emp_test.ename,15,' ')||v_emp_test.sal);
       FETCH cv INTO v_emp_test;       
   END LOOP;   
   dbe_output.print_line( '-------------------------------------' );
   CLOSE cv;
END;
/
--13
DECLARE
   v_emp_test     emp%ROWTYPE;
   cursor cv is SELECT * FROM emp where empno=1 for update;
   BEGIN
   OPEN cv;
   FETCH cv INTO v_emp_test;
   while cv%FOUND LOOP
       delete from emp where current of cv;
       dbe_output.print_line(rpad(v_emp_test.empno,15,' ')||rpad(v_emp_test.ename,15,' ')||v_emp_test.sal);
       FETCH cv INTO v_emp_test;       
   END LOOP;   
   dbe_output.print_line( '-------------------------------------' );
   CLOSE cv;
END;
/
--14
declare
type syscur is record (
  a int,
  b varchar2(20)
);
cv sys_refcursor;
cv1 syscur;
begin
open cv for select empno,ename from emp where job like '%1%' order by empno;
loop
fetch cv into cv1;
exit when cv%notfound;
dbe_output.print_line('empno is ' || cv1.a||'---->'||'ename is '|| cv1.b);
end loop;
close cv;
end;
/
--15
begin
for a  in  (select * from emp where ename like '%zhangsan%' and sal > 9000 order by empno)
loop
dbe_output.print_line('a is emp:'||a.empno||'name:'||a.ename||'job:'||a.job||'sal:'||a.sal);
dbe_output.print_line(sql%rowcount);
end loop;
end;
/
drop table emp;
drop function syscur_028;

--cann't use bind param after using
DECLARE
a INT;
b CHAR(16);
c VARCHAR(16);
BEGIN
a := 10;
b := 'abc';
c := 'efc';
EXECUTE IMMEDIATE 'BEGIN 
:x := 11; :y := ''aaa''; :z := ''bbb'';
dbe_output.print_line(''a=''||:x);dbe_output.print_line(''b=''||:y);dbe_output.print_line(''c=''||:z);
END;'
USING 7,'efg','opq';
dbe_output.print_line('a='||a);
dbe_output.print_line('b='||b);
dbe_output.print_line('c='||c);
END;
/

--test bind param in cursor clause of dynamic sql
declare
xx int := 1;
begin
execute immediate '
declare
   a sys_refcursor;
   b int := 1;
   p int;
begin
   open a for select b from dual;
   open a for select b + :1 from dual;
   fetch a into p;
   dbe_output.print_line(p);
end;' using in xx;
end;
/


--testcase 11
drop procedure if exists proc;
create or replace procedure proc(b in out number, c in out int)
as
begin
  dbe_output.print_line(b);
  dbe_output.print_line(c);
  b:=3;
  c:=4;
end;
/

declare
b number;
c int;
begin
b:=1;
c:=2;
proc(b,c);
dbe_output.print_line(b);
dbe_output.print_line(c);
end;
/
drop procedure proc;


--from gsql_test/gs_plsql_type_dts.sql
declare
    TYPE nt_type IS TABLE OF varchar(10);
    nt nt_type := nt_type('a','s','null','w','e');
BEGIN
    if nt.exists(null) then
        dbe_output.print_line('ok');
    else
        dbe_output.print_line('end');
    end if;
end;
/

declare
    TYPE nt_type IS TABLE OF varchar(10);
    nt nt_type := nt_type('a','s','null','w','e');
BEGIN
    dbe_output.print_line(nt.prior(null) || 'ok');
end;
/

declare
    TYPE nt_type IS TABLE OF varchar(10);
    nt nt_type := nt_type('a','s','null','w','e');
BEGIN
    dbe_output.print_line(nt.next(null) || 'ok');
end;
/

--from gsql_test/sql_merge_into.sql
drop table if exists merge_t1;
drop table if exists merge_t2;
create table merge_t1(f1 int, f2 varchar2(20));

declare
    i number;
begin
    i := 0;
    while i < 100000 loop
        insert into merge_t1(f1) values(i+1);
        if mod(i+1, 10000) = 0 then
            commit;
        end if;
        i := i+1;
    end loop;
    commit;
end;
/

create table merge_t2 as select * from merge_t1;

declare
   v_sdate timestamp;
   v_edate timestamp;
begin
    select systimestamp into v_sdate from dual;
    merge into merge_t1 a using(select * from merge_t2) b on (a.f1=b.f1+10000000) 
        when matched then update set a.f2='bbb';
    select systimestamp into v_edate from dual;
    if v_edate - v_sdate > interval '2' second then
        THROW_EXCEPTION(-20123, 'SQL elapsed too much time');
    end if;
end;
/

drop table merge_t1;
drop table merge_t2;

--package compile error
--sub_proc has no parameter
drop table if exists pkg_t222222;
create table pkg_t222222(a varchar2(10),b varchar2(10));

drop PACKAGE if exists COMP_PACK02;
CREATE OR REPLACE PACKAGE COMP_PACK02 IS PROCEDURE PROCEDURE001; END;
/
drop PACKAGE body if exists COMP_PACK02;
create or replace package body COMP_PACK02
IS PROCEDURE PROCEDURE001 as  BEGIN  insert into pkg_t222222 values('1','bbb'); commit ;end PROCEDURE001;end COMP_PACK02;
/
EXEC COMP_PACK02.PROCEDURE001;

create or replace package
body COMP_PACK02 IS PROCEDURE PROCEDURE001 as
BEGIN
insert into pkg_t222222 values('2','bbb'); commit ;
end PROCEDURE001;
end COMP_PACK02;
/
EXEC COMP_PACK02.PROCEDURE001;

create or replace package body COMP_PACK02 IS PROCEDURE PROCEDURE001 as  BEGIN  insert into pkg_t222222 values('3','bbb'); commit ;end PROCEDURE001;end COMP_PACK02;
/
select source from sys_procs where name = 'COMP_PACK02';
EXEC COMP_PACK02.PROCEDURE001;
drop package if exists COMP_PACK02;

----sub_proc has parameters
DROP PACKAGE IF EXISTS COMP_PACK01;
CREATE OR REPLACE PACKAGE COMP_PACK01
IS
 PROCEDURE PROCEDURE001(PARAM1 IN VARCHAR2,PARAM2 IN VARCHAR2);
END;
/

create or replace package
body
COMP_PACK01 IS PROCEDURE PROCEDURE001 (PARAM1 IN VARCHAR2, PARAM2 IN VARCHAR2) as BEGIN
insert into pkg_t222222 values(PARAM1,PARAM2); commit ;
end PROCEDURE001;
end COMP_PACK01;
/
EXEC COMP_PACK01.PROCEDURE001('4','bbb');

drop PACKAGE body if exists COMP_PACK01;
create or replace package body COMP_PACK01 IS PROCEDURE PROCEDURE001 (PARAM1 IN VARCHAR2, PARAM2 IN VARCHAR2) as BEGIN insert into pkg_t222222 values(PARAM1,PARAM2); commit ; end PROCEDURE001; end COMP_PACK01;
/
EXEC COMP_PACK01.PROCEDURE001('5','bbb');
DROP PACKAGE IF EXISTS COMP_PACK01;

--multiple sub_procs
DROP PACKAGE IF EXISTS COMP_PACK03;
CREATE OR REPLACE PACKAGE COMP_PACK03
IS
 PROCEDURE PROCEDURE001(PARAM1 IN VARCHAR2,PARAM2 IN VARCHAR2);
 PROCEDURE PROCEDURE002;
END;
/

create or replace package body COMP_PACK03 IS
PROCEDURE PROCEDURE001 (PARAM1 IN VARCHAR2, PARAM2 IN VARCHAR2) as 
BEGIN 
insert into pkg_t222222 values(PARAM1,PARAM2);
commit ;
end PROCEDURE001;PROCEDURE PROCEDURE002 as  BEGIN  insert into pkg_t222222 values('6','bbb'); commit ;end PROCEDURE002;
end COMP_PACK03;
/
EXEC COMP_PACK03.PROCEDURE002;

create or replace package 
body COMP_PACK03 IS PROCEDURE PROCEDURE001 (PARAM1 IN VARCHAR2, PARAM2 IN VARCHAR2) as BEGIN insert into pkg_t222222 values(PARAM1,PARAM2); commit ; end PROCEDURE001;PROCEDURE PROCEDURE002 as  BEGIN  insert into pkg_t222222 values('7','bbb');
commit ;end PROCEDURE002;
end COMP_PACK03;
/
EXEC COMP_PACK03.PROCEDURE002;
EXEC COMP_PACK03.PROCEDURE001('8','bbb');
select * from pkg_t222222;
DROP PACKAGE IF EXISTS PACK03;
drop table if exists pkg_t222222;

--DTS202008240R60APP0G00
DROP PACKAGE IF EXISTS CASE_PAK_1;
CREATE OR REPLACE PACKAGE CASE_PAK_1
IS
 PROCEDURE proc_tt1("aQWQ" int, `b` int);
END;
/
CREATE OR REPLACE PACKAGE BODY CASE_PAK_1
IS
procedure proc_tt1("aQWQ" int, `b` int) is
  p int := "aQWQ";
  q int := "b";
begin
  dbe_output.print_line('p = ' || p);
  dbe_output.print_line('q = ' || q);
end;
END;
/
select OBJECT_NAME, ARGUMENT_NAME from sys_proc_args where object_name = 'PROC_TT1' ORDER BY SEQUENCE;
select OBJECT_NAME, ARGUMENT_NAME from db_arguments where object_name = 'PROC_TT1' ORDER BY SEQUENCE;
call CASE_PAK_1.proc_tt1(1, 2);
call CASE_PAK_1.proc_tt1("AQWQ"=>1, `b`=>2);
call CASE_PAK_1.proc_tt1("aqwQ"=>1, `b`=>2);
call CASE_PAK_1.proc_tt1("aQWQ"=>1, `B`=>2);
call CASE_PAK_1.proc_tt1("aQWQ"=>1, `b`=>2);

CREATE OR REPLACE PACKAGE CASE_PAK_1
IS
 PROCEDURE proc_tt1("sWER" int, "Qsq" int);
END;
/
CREATE OR REPLACE PACKAGE BODY CASE_PAK_1
IS
procedure proc_tt1("swer" int, "qsp" int) is
begin
  dbe_output.print_line('p = ' || 1);
end;
END;
/

CREATE OR REPLACE PACKAGE CASE_PAK_1
IS
 FUNCTION proc_tt1(aQWQ int, "B" int) RETURN INT;
END;
/
CREATE OR REPLACE PACKAGE BODY CASE_PAK_1
IS
FUNCTION proc_tt1(aqwq int, "B" int)  RETURN INT is
  p int := 1;
  q int :=2;
begin
  dbe_output.print_line('p = ' || p);
RETURN q;
end;
END;
/
select OBJECT_NAME, ARGUMENT_NAME from db_arguments where object_name = 'PROC_TT1' ORDER BY SEQUENCE;
select CASE_PAK_1.proc_tt1(2,3) from sys_dummy;

CREATE OR REPLACE PACKAGE CASE_PAK_1
IS
 PROCEDURE proc_tt1(a int, A int);
END;
/
CREATE OR REPLACE PACKAGE CASE_PAK_1
IS
 PROCEDURE proc_tt1(a int, "A" int);
END;
/
CREATE OR REPLACE PACKAGE CASE_PAK_1
IS
 PROCEDURE proc_tt1(a int, "a" int);
END;
/

CREATE OR REPLACE PACKAGE CASE_PAK_1
IS
 PROCEDURE PROC_TT1("a" INT, "A" INT);
END;
/
CREATE OR REPLACE PACKAGE BODY CASE_PAK_1
IS
PROCEDURE PROC_TT1("a" INT, "A" INT) IS
  P INT := "a";
  Q INT := "A";
BEGIN
  dbe_output.print_line(P);
  dbe_output.print_line(Q);
END;
END;
/
call CASE_PAK_1.proc_tt1("a"=>1, "A"=>2);
call CASE_PAK_1.proc_tt1("A"=>1, "a"=>2);
call CASE_PAK_1.proc_tt1("a"=>1, "a"=>2);
call CASE_PAK_1.proc_tt1("a"=>1);
call CASE_PAK_1.proc_tt1( a =>1, "A"=>2);
call CASE_PAK_1.proc_tt1( a =>1, "a"=>2);

CREATE OR REPLACE PROCEDURE PROC_TT2("a" INT, "A" INT) IS
BEGIN
  dbe_output.print_line("a");
  dbe_output.print_line("A");
END;
/
call proc_tt2("a"=>1, "A"=>2);
call proc_tt2("A"=>1, "a"=>2);
DROP PROCEDURE if exists PROC_TT2;

CREATE OR REPLACE PACKAGE CASE_PAK_1
IS
 PROCEDURE proc_tt1(`a` int, "A" int);
END;
/
CREATE OR REPLACE PACKAGE BODY CASE_PAK_1
IS
procedure proc_tt1(`a` int, A int) is
  p int := `a`;
  q int := A;
begin
  dbe_output.print_line('p = ' || p);
  dbe_output.print_line('q = ' || q);
end;
END;
/
call CASE_PAK_1.proc_tt1("a"=>1, "A"=>2);

create or replace package CASE_PAK_1 is
function a return int;
function "A" return int;
end;
/
create or replace package CASE_PAK_1 is
function a return int;
function "a" return int;
end;
/

create or replace package CASE_PAK_1 is
function `a` return int;
function "A" return int;
end;
/
create or replace package body CASE_PAK_1 is
function `a` return int
is
begin
return 3;
end;
function "A" return int
is
begin
return 4;
end;
end;
/
select OBJECT_NAME, ARGUMENT_NAME from db_arguments where PACKAGE_NAME = 'CASE_PAK_1' ORDER BY OBJECT_NAME;
select CASE_PAK_1.`A` from sys_dummy;
select CASE_PAK_1."a" from sys_dummy;
select CASE_PAK_1.a from sys_dummy;

create or replace package CASE_PAK_1 is
function "aBRT" return int;
end;
/
create or replace package body CASE_PAK_1 is
function aBRT return int
is
begin
return 3;
end;
end;
/

create or replace package CASE_PAK_1 is
function "aBRT" return int;
function "Aaat" return int;
end;
/

create or replace package body CASE_PAK_1 is
function "aBRT" return int
is
begin
return 3;
end;
end;
/

create or replace package CASE_PAK_1 is
function "aBRT" return int;
function "Aaat" return int;
end;
/
create or replace package body CASE_PAK_1 is
function "aBRT" return int
is
begin
return 3;
end;
function "AAAT" return int
is
begin
return 4;
end;
end;
/
select CASE_PAK_1."Aaat" from sys_dummy;
select CASE_PAK_1."AAAT" from sys_dummy;

create or replace package CASE_PAK_1 is
function aBRT return int;
function Aaat return int;
end;
/
create or replace package body CASE_PAK_1 is
function abRT return int
is
begin
return 3;
end;
function AAAT return int
is
begin
return 4;
end;
end;
/
select CASE_PAK_1.AAAT from sys_dummy;


create or replace package CASE_PAK_1 is
function "aBRT" return int;
end;
/
create or replace package body CASE_PAK_1 is
function "AAAT" return int
is
begin
return 4;
end;
function "aBRT" return int
is
a int;
begin
a := 5;
return a;
end;
end;
/
drop package if exists CASE_PAK_1;

set serveroutput off;

--DTS20210428041KVWP1M00
CONN / AS SYSDBA
DROP USER IF EXISTS DTS20210428041KVWP1M00_USER CASCADE;
CREATE USER DTS20210428041KVWP1M00_USER IDENTIFIED BY Cantian_234;
CREATE TABLE DTS20210428041KVWP1M00_USER.T1(C1 INT);
CREATE OR REPLACE PROCEDURE DTS20210428041KVWP1M00_PROCEDURE() IS
BEGIN
 DBE_MASK_DATA.ADD_POLICY(
    object_schema => 'DTS20210428041KVWP1M00_USER',
    object_name => 'T1',
    column_name => 'C1',
    policy_name => 'DTS20210428041KVWP1M00_RULE',
    policy_type => 'FULL',
    mask_value=> '7');
 DBE_MASK_DATA.DROP_POLICY('DTS20210428041KVWP1M00_USER', 'T1', 'DTS20210428041KVWP1M00_RULE');
END;
/

call DTS20210428041KVWP1M00_PROCEDURE();
DROP USER DTS20210428041KVWP1M00_USER CASCADE;
DROP PROCEDURE DTS20210428041KVWP1M00_PROCEDURE;

--Add the dependency of package body on package START
DROP USER IF EXISTS PKG_DP_USER1 CASCADE;
CREATE USER PKG_DP_USER1 IDENTIFIED BY Cantian_234;
GRANT DBA TO PKG_DP_USER1;
CONN PKG_DP_USER1/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE FUNCTION F1(V1 INT) RETURN INT IS
BEGIN
 RETURN 1;
END;
/
CREATE OR REPLACE PACKAGE PKG1 IS
 FUNCTION PKG1_F1(V1 INT) RETURN INT;
END;
/
CREATE OR REPLACE PACKAGE BODY PKG1 IS
 FUNCTION PKG1_F1(V1 INT) RETURN INT IS
 BEGIN
  RETURN F1(V1);
 END;
END;
/
SELECT * FROM MY_DEPENDENCIES ORDER BY REFERENCED_NAME;
SELECT OBJECT_NAME,OBJECT_TYPE,STATUS FROM MY_OBJECTS ORDER BY OBJECT_TYPE;
SELECT PKG1.PKG1_F1(1) FROM SYS_DUMMY;
CREATE OR REPLACE PACKAGE BODY PKG1 IS
 FUNCTION PKG1_F1(V1 INT) RETURN INT IS
 BEGIN
  RETURN 2;
 END;
END;
/
SELECT PKG1.PKG1_F1(1) FROM SYS_DUMMY;
CREATE OR REPLACE PACKAGE PKG1 IS
 FUNCTION PKG1_F2(V1 INT) RETURN INT;
END;
/
SELECT * FROM MY_DEPENDENCIES ORDER BY REFERENCED_NAME;
SELECT OBJECT_NAME,OBJECT_TYPE,STATUS FROM MY_OBJECTS ORDER BY OBJECT_TYPE;
SELECT PKG1.PKG1_F1(1) FROM SYS_DUMMY;
CONN / AS SYSDBA
DROP USER IF EXISTS PKG_DP_USER1 CASCADE;
--Add the dependency of package body on package END

SELECT DBE_UTIL.EDIT_DISTANCE('shackleford') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY('shackleford') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE('shackleford', 'shackelford','asdckef') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY('shackleford', 'shackelford','asdckef') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE('shackleford', 'shackelford') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY('shackleford', 'shackelford') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE(NULL, 'shackelford') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY(NULL, 'shackelford') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE('shackleford', NULL) FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY('shackleford', NULL) FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE('shackleford', '') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY('shackleford', '') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE('', 'shackelford') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY('', 'shackelford') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE(NULL, 'NULL') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY(NULL, 'NULL') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE('', '') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY('', '') FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE('sdfg','SDFG') FROM DUAL;
drop table if exists test_EDIT_DISTANCE_tb;
create table test_EDIT_DISTANCE_tb(f_index int,f_varchar1 varchar(100),f_varchar2 varchar(200),f_int BINARY_INTEGER,F_BIGINT BINARY_BIGINT,
F_BOOL BOOLEAN,F_NUM NUMBER,F_FLOAT BINARY_DOUBLE,F_CHAR  CHAR(128),F_DATE DATE,F_TIMESTAMP TIMESTAMP,F_BINARY BINARY(150),F_BLOB BLOB,F_CLOB CLOB);
insert into test_EDIT_DISTANCE_tb values(0,
'This is a test case which test new function EDIT_DISTANCE!', 
'attention,This is a test case,i hope its EDIT_DISTANCE all clear!',
152,
1215454848412154,
TRUE,
123.012345678987654321,
13.01234597054321,
'F_CHAR EDIT_DISTANCE test',
'2021-06-16',
'2021-06-16 10:59:26:123456',
'10100101010100111111111111111111111111100000000000000000000000000011111111111111111111',
TO_BLOB(LPAD('A12',16325,'A12')),
TO_CLOB(LPAD('A12',16326,'A12')));
SELECT DBE_UTIL.EDIT_DISTANCE(tb.f_varchar1, tb.f_varchar2) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY(tb.f_varchar1, tb.f_varchar2) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE(tb.F_BIGINT, tb.f_int) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY(tb.F_BIGINT, tb.f_int) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE(tb.F_BIGINT, tb.f_varchar2) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY(tb.F_BIGINT, tb.f_varchar2) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE(tb.F_BOOL, tb.f_int) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY(tb.F_BOOL, tb.f_int) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE(tb.F_NUM, tb.F_FLOAT) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY(tb.F_NUM, tb.F_FLOAT) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE(tb.F_NUM, tb.f_varchar2) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY(tb.F_NUM, tb.f_varchar2) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE(tb.F_CHAR, tb.F_DATE) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY(tb.F_CHAR, tb.F_DATE) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE(tb.F_DATE, tb.F_TIMESTAMP) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY(tb.F_DATE, tb.F_TIMESTAMP) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE(tb.F_BINARY, tb.f_varchar1) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY(tb.F_BINARY, tb.f_varchar1) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY(tb.f_varchar1, tb.F_BLOB) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE(tb.f_varchar1, tb.F_CLOB) FROM test_EDIT_DISTANCE_tb tb;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY(tb.f_varchar1, tb.F_CLOB) FROM test_EDIT_DISTANCE_tb tb;
drop table if exists test_EDIT_DISTANCE_tb_1;
drop table if exists test_EDIT_DISTANCE_tb_2;
create table test_EDIT_DISTANCE_tb_1(f1 int,f2 varchar(100));
insert into test_EDIT_DISTANCE_tb_1 values(1,'please input your name');
create table test_EDIT_DISTANCE_tb_2(f1 int,f2 varchar(100));
insert into test_EDIT_DISTANCE_tb_2 values(2,'ple put name');
SELECT DBE_UTIL.EDIT_DISTANCE(t1.f2, t2.f2) from test_EDIT_DISTANCE_tb_1 t1 ,test_EDIT_DISTANCE_tb_2 t2;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY(t1.f2, t2.f2) from test_EDIT_DISTANCE_tb_1 t1 ,test_EDIT_DISTANCE_tb_2 t2;
select * from test_EDIT_DISTANCE_tb_1 t1 inner join test_EDIT_DISTANCE_tb_2 t2 on DBE_UTIL.EDIT_DISTANCE(t1.f2, t2.f2) < 1;
select * from test_EDIT_DISTANCE_tb_1 t1 inner join test_EDIT_DISTANCE_tb_2 t2 on DBE_UTIL.EDIT_DISTANCE_SIMILARITY(t1.f2, t2.f2) > 1;
drop table if exists test_EDIT_DISTANCE_tb_1;
drop table if exists test_EDIT_DISTANCE_tb_2;
drop table if exists test_EDIT_DISTANCE_tb;
ALTER SYSTEM SET UPPER_CASE_TABLE_NAMES=FALSE;
SELECT DBE_UTIL.EDIT_DISTANCE('shackleford', 'shackelford')  FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE('sdfg','SDFG')  FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE("sdfg","SDFG")  FROM DUAL;
ALTER SYSTEM SET UPPER_CASE_TABLE_NAMES=TRUE;
alter system set EMPTY_STRING_AS_NULL=false;
SELECT DBE_UTIL.EDIT_DISTANCE('', '') FROM  DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY('', '') FROM  DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE('', 'aaa') FROM  DUAL;
alter system set EMPTY_STRING_AS_NULL=TRUE;
SELECT DBE_UTIL.EDIT_DISTANCE(NULL, NULL) FROM DUAL;
SELECT DBE_UTIL.EDIT_DISTANCE_SIMILARITY(NULL, NULL) FROM DUAL;

drop table if exists myt1;
create table myt1(a int,b varchar(2000), 
c1 varchar(2000) default 'abcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl',
c2 varchar(2000) default 'abcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl',
c3 varchar(2000) default 'abcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl',
c4 varchar(2000) default 'abcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl',
c5 varchar(2000) default 'abcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl',
c6 varchar(2000) default 'abcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl')
partition by hash(a)
(
PARTITION training1,
PARTITION training2,
PARTITION training3,
PARTITION training4,
PARTITION training5,
PARTITION training6,
PARTITION training7,
PARTITION training8
);

create index gidx on myt1(b);
create index lidx on myt1(a) local;
select dbe_diagnose.dba_index_size(0, user,'myt1');
select dbe_diagnose.dba_index_size(1, user,'myt1');
select dbe_diagnose.dba_index_size(2, user,'myt1');
select dbe_diagnose.dba_index_size(0, user,'myt1','gidx');
select dbe_diagnose.dba_index_size(1, user,'myt1','gidx');
select dbe_diagnose.dba_index_size(2, user,'myt1','gidx');
select dbe_diagnose.dba_index_size(0, user,'myt1','lidx');
select dbe_diagnose.dba_index_size(1, user,'myt1','lidx');
select dbe_diagnose.dba_index_size(2, user,'myt1','lidx');
begin
for i in 1..1000 loop
insert into myt1(a,b) values(i,i+1);
end loop;
commit;
end;
/
select dbe_diagnose.dba_index_size(0, user,'myt1');
select dbe_diagnose.dba_index_size(1, user,'myt1');
select dbe_diagnose.dba_index_size(2, user,'myt1');
select dbe_diagnose.dba_index_size(0, user,'myt1','gidx');
select dbe_diagnose.dba_index_size(1, user,'myt1','gidx');
select dbe_diagnose.dba_index_size(2, user,'myt1','gidx');
select dbe_diagnose.dba_index_size(0, user,'myt1','lidx');
select dbe_diagnose.dba_index_size(1, user,'myt1','lidx');
select dbe_diagnose.dba_index_size(2, user,'myt1','lidx');
select dbe_diagnose.dba_index_size(2, user,'myt1','not_exsits');
drop table myt1;