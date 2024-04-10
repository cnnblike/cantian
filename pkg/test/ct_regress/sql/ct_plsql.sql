--
-- gs_plsql
-- testing procedure
--
conn / as sysdba
drop user if exists zyd1 cascade;
create user zyd1 identified by Cantian_234;
grant dba to zyd1;
conn zyd1/Cantian_234@127.0.0.1:1611
exec DBE_UTIL.COMPILE_SCHEMA('sys');
conn / as sysdba
select object_type,owner,object_name,status from DB_OBJECTS where OBJECT_NAME = 'AUD$CLEAN_AUD_LOG';
drop user if exists zyd1 cascade;
conn / as sysdba
create user compile_user identified by Cantian_234;
create user compile_user1 identified by Cantian_234;
grant create session to compile_user;
grant create session to compile_user1;
create table compile_user.t1(id int,name varchar(20));
create table compile_user1.t1(id int,name varchar(20));
grant select any table to compile_user;
grant select any table to compile_user1;
grant dba to compile_user;
grant dba to compile_user1;
conn compile_user1/Cantian_234@127.0.0.1:1611
create view view_t1 as select * from t1;
create synonym syn_view_t1 for view_t1;
conn compile_user/Cantian_234@127.0.0.1:1611
exec DBE_UTIL.COMPILE_SCHEMA('compile_user1');
conn compile_user1/Cantian_234@127.0.0.1:1611
drop table  t1 cascade constraints;
conn compile_user/Cantian_234@127.0.0.1:1611
exec DBE_UTIL.COMPILE_SCHEMA('compile_user1');
SELECT object_type,owner,object_name,status FROM DB_OBJECTS WHERE status = 'INVALID' and owner = 'COMPILE_USER1';
conn / as sysdba
drop user compile_user cascade;
drop user compile_user1 cascade;
set serveroutput on;
DROP USER IF EXISTS gs_plsql1 cascade;
create user gs_plsql1 identified by Whf00174302;
grant dba to gs_plsql1;
DROP USER IF EXISTS gs_plsql cascade;
create user gs_plsql identified by Whf00174302;
grant dba to gs_plsql;
conn gs_plsql/Whf00174302@127.0.0.1:1611

--BEGIN: timestamp
create or replace procedure testProcWithAllTypeInputOut(datetime_type IN datetime,timestamp_type IN TIMESTAMP)
as
SWC_Current_1 SYS_REFCURSOR;
begin
    open SWC_Current_1 for select datetime_type as datetime1,timestamp_type as timestamp_type1 from dual;
    dbe_sql.return_cursor(SWC_Current_1);
commit;
end;
/
call testProcWithAllTypeInputOut('2012-12-05 19:00:00', '2012-12-05 19:00:00');
drop procedure testProcWithAllTypeInputOut;
--END: timestamp

--BEGIN: test serveroutput
DROP TABLE IF EXISTS PLSQL_T_PROC_1;
CREATE TABLE PLSQL_T_PROC_1 (F_INT1 INT);
CREATE OR REPLACE FUNCTION PLSQL_Zenith_Test_Sysdate return varchar2
IS
 cunt int := 0;
 Begin
 select count(*) into cunt from dual;
 dbe_output.print_line(cunt);
 IF SQL % FOUND
  then
 return cunt;
 end if;
 End PLSQL_Zenith_Test_Sysdate;
/

--select
select PLSQL_Zenith_Test_Sysdate() from dual;
--insert/delete/update
insert into PLSQL_T_PROC_1(f_int1) values(PLSQL_Zenith_Test_Sysdate());
update PLSQL_T_PROC_1 set f_int1=PLSQL_Zenith_Test_Sysdate() where f_int1=PLSQL_Zenith_Test_Sysdate();
delete from PLSQL_T_PROC_1 where f_int1=PLSQL_Zenith_Test_Sysdate();
drop table PLSQL_T_PROC_1;

--END: test serveroutput

--BEGIN: TEST OUT PARAM
CREATE OR REPLACE PROCEDURE PLSQL_Zenith_Test_004(param1 out varchar2)
IS
    tmp varchar2(20) :='12345678';
begin
 param1:=param1||tmp;
end PLSQL_Zenith_Test_004;
/

Declare
    v_char1 char(9) :='A';
begin
    PLSQL_Zenith_Test_004(v_char1);
    dbe_output.print_line('OUT PUT RESULT:'||v_char1);
end;
/

CREATE OR REPLACE PROCEDURE PLSQL_Zenith_Test_004(param1 out varchar2)
IS
    tmp varchar2(20) :='12345678';
begin
    dbe_output.print_line('OUT PUT RESULT:'||param1);
end PLSQL_Zenith_Test_004;
/


Declare
    v_char1 char(9) :='A';
begin
    PLSQL_Zenith_Test_004(v_char1);
    dbe_output.print_line('OUT PUT RESULT:'||v_char1);
end;
/

--END: TEST OUT PARAM

--BEGIN:TEST ERROR, not allow to appear column
begin
dbe_output.print_line("-------------------");
end;
/
--END

--BEGIN: TEST SQL%ROWCOUNT
DROP TABLE IF EXISTS PLSQL_T_PROC_1;
DROP TABLE IF EXISTS PLSQL_T_PROC_2;
CREATE TABLE PLSQL_T_PROC_1 (F_INT1 INT, F_INT2 INT);
CREATE TABLE PLSQL_T_PROC_2 (F_INT1 INT, F_INT2 INT);

DECLARE
A INT;
B INT;
BEGIN
	INSERT INTO PLSQL_T_PROC_1(F_INT1) VALUES(12);
	INSERT INTO PLSQL_T_PROC_1(F_INT1) VALUES(12);
	A := SQL%ROWCOUNT;
	EXECUTE IMMEDIATE 'DELETE FROM PLSQL_T_PROC_1';
	B := SQL%ROWCOUNT;
	INSERT INTO PLSQL_T_PROC_2(F_INT1,F_INT2) VALUES(A,B);
END;
/

SELECT * FROM PLSQL_T_PROC_1;
SELECT * FROM PLSQL_T_PROC_2;


DELETE FROM PLSQL_T_PROC_1;
DELETE FROM PLSQL_T_PROC_2;

DECLARE
A INT;
B INT;
BEGIN
	EXECUTE IMMEDIATE 'INSERT INTO PLSQL_T_PROC_1(F_INT1) VALUES(12)';
	A := SQL%ROWCOUNT;
	INSERT INTO PLSQL_T_PROC_1(F_INT1) VALUES(12);
	DELETE FROM PLSQL_T_PROC_1;
	B := SQL%ROWCOUNT;
	INSERT INTO PLSQL_T_PROC_2(F_INT1,F_INT2) VALUES(A,B);
END;
/

SELECT * FROM PLSQL_T_PROC_1;
SELECT * FROM PLSQL_T_PROC_2;


DELETE FROM PLSQL_T_PROC_1;
DELETE FROM PLSQL_T_PROC_2;

INSERT INTO PLSQL_T_PROC_1(F_INT1) VALUES(1);
INSERT INTO PLSQL_T_PROC_1(F_INT1) VALUES(2);
INSERT INTO PLSQL_T_PROC_1(F_INT1) VALUES(3);

DECLARE
A INT;
B INT;
BEGIN
	UPDATE PLSQL_T_PROC_1 SET F_INT1 = 2 WHERE F_INT1 = 1;
	A := SQL%ROWCOUNT;
	EXECUTE IMMEDIATE 'UPDATE PLSQL_T_PROC_1 SET F_INT1 = 3 WHERE F_INT1 = 2';
	B := SQL%ROWCOUNT;
	INSERT INTO PLSQL_T_PROC_2(F_INT1,F_INT2) VALUES(A,B);
END;
/

SELECT * FROM PLSQL_T_PROC_1;
SELECT * FROM PLSQL_T_PROC_2;


DELETE FROM PLSQL_T_PROC_1;
DELETE FROM PLSQL_T_PROC_2;

INSERT INTO PLSQL_T_PROC_1(F_INT1) VALUES(1);
INSERT INTO PLSQL_T_PROC_1(F_INT1) VALUES(2);
INSERT INTO PLSQL_T_PROC_1(F_INT1) VALUES(3);

DECLARE
A INT;
B INT;
BEGIN
	MERGE INTO PLSQL_T_PROC_1 USING DUAL ON (1=1) WHEN MATCHED THEN UPDATE SET F_INT1 = 2;
	A := SQL%ROWCOUNT;
	EXECUTE IMMEDIATE 'MERGE INTO PLSQL_T_PROC_1 USING DUAL ON (1=0) WHEN NOT MATCHED THEN INSERT (F_INT1) VALUES(1)';
	B := SQL%ROWCOUNT;
	INSERT INTO PLSQL_T_PROC_2(F_INT1,F_INT2) VALUES(A,B);
END;
/

SELECT * FROM PLSQL_T_PROC_1;
SELECT * FROM PLSQL_T_PROC_2;
COMMIT;
--EDN: TEST SQL%ROWCOUNT

--BEGIN:TEST Case sensitivity
drop table if exists "plsql_t1";
create table "plsql_t1" ("f1" int, "f2" int);
insert into "plsql_t1" values(1,2);
insert into "plsql_t1" values(2,3);
insert into "plsql_t1" values(3,4);
declare
a int;
Begin
select "f1" into a from "plsql_t1" order by "f1" limit 1;
dbe_output.print_line(a);
select max("f1") into a from "plsql_t1";
dbe_output.print_line(a);
select "f1" into a from "plsql_t1" where "f1" = 2;
dbe_output.print_line(a);
End;
/
--END:Case sensitivity 

--test 'bool var = cond'
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
dbe_output.print_line('value6:'||(v_sal+2));
end;
/

declare
v_sal int;
begin
v_sal := 1;
case v_sal
when v_sal+1 then
  v_sal := v_sal + 1;
  dbe_output.print_line('value1:'||v_sal);
when v_sal+2 then
  v_sal := v_sal + 3;
  dbe_output.print_line('value1X:'||v_sal);  
else
  v_sal := v_sal + 2;
  dbe_output.print_line('value2:'||v_sal);
end case;
end;
/

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

<<main>>
DECLARE
x NUMBER;
BEGIN
x := 0;
goto outer_loop;
x := 100;
<<outer_loop>>
LOOP
dbe_output.print_line(' outer in ');
<<inner_loop>>
LOOP
  dbe_output.print_line ('Inside loop: x = ' || x);
  x := x + 1;
  IF x > 3 THEN
     dbe_output.print_line(' BEGIN EXIT ');
     EXIT inner_loop WHEN x > 4;
     dbe_output.print_line(' AFTER EXIT ');
  else
     continue inner_loop when x > 1;
  END IF;
  dbe_output.print_line(' after continue ');
    END LOOP; 
  dbe_output.print_line(' outer_loop ');
  EXIT outer_loop;
END LOOP;
dbe_output.print_line(' After loop: x = ' || x);
if x < 6 then
goto inner_loop;
end if;
END;
/

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

Declare
x bool;
BEGIN
x := FALSE;
FOR i IN x..3 LOOP
if i > 2 then
dbe_output.print_line ('here:' || i);
else
dbe_output.print_line ('there:' || i);
end if;
END LOOP;
dbe_output.print_line ('x:' || x);
END;
/

Declare
x bool;
BEGIN
x := FALSE;
FOR i IN 1..3 LOOP
dbe_output.print_line ('here:' || i);
END LOOP;
dbe_output.print_line ('x:' || x);
END;
/

drop table if exists test;
create table test(a1 int);
insert into test values(10);

declare
a int;
begin
a := 1;
update test set a1 = a1 + 11 where a = 1;
delete from test where a1 = 1;
select * into a from test limit 1;
commit;
dbe_output.print_line ('result is:' || a);
end;
/

select * from test order by a1;

declare
a int;
begin
a := 1;
MERGE INTO test USING DUAL ON (a1 = 2) WHEN NOT MATCHED THEN INSERT (a1) VALUES(2);
commit;
end;
/

select * from test;

--test stack
drop table if exists plsql_Utils_CheckPoint;
create table plsql_Utils_CheckPoint(
PlanID number(10, 0) not null ,
Tag varchar2(150) not null
);

create or replace procedure plsql_sp_LockFor (
v_PlanID in number ,
v_Tag in varchar2 )
as
v_flag number(10, 0);
loop_num int := 0;
begin
insert into plsql_Utils_CheckPoint
select v_PlanID, v_Tag from dual where not exists ( select 1 from plsql_Utils_CheckPoint where PlanID = v_PlanID and Tag = v_Tag ) ;
commit;
v_flag := 1;
while (loop_num < 10000)
loop
 begin
	 begin
		 select count( 1 ) into v_flag from plsql_Utils_CheckPoint where PlanID = v_PlanID and Tag = v_Tag;
		 exception
		 when no_data_found then
		 null;
	 end;
	 begin loop_num := loop_num + 1; end;
 end;
end loop;
dbe_output.print_line ('loop number: ' || loop_num);
end;
/

insert into plsql_Utils_CheckPoint values (32, 'tag_jfj');
call plsql_sp_LockFor(32, 'tag_jfj');
--test stack

--test case-when expr
--add 2018/07/09
drop table if exists plsql_tab_test_case_when;
create table plsql_tab_test_case_when
(
id number,
score number
);

insert into plsql_tab_test_case_when values(1,1);
insert into plsql_tab_test_case_when values(2,2);
insert into plsql_tab_test_case_when values(3,3);
commit;

select id , case score when 1 then 1 else 0 end  from plsql_tab_test_case_when order by id;
select id , case score when 1 then 1 end  from plsql_tab_test_case_when order by id;

insert into plsql_tab_test_case_when values(4,null);
commit;

select id , case score when 1 then 1 when null then 2 end  from plsql_tab_test_case_when order by id;


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

DECLARE
    grade CHAR(1) := 'E';
    appraisal VARCHAR2(20);
BEGIN
    appraisal := CASE
            WHEN grade = 'A' THEN  'Excellent'
            WHEN grade = 'B' THEN  'Very Good'
            WHEN grade = 'C' THEN  'Good'
            WHEN grade = 'D' THEN  'Fair'
            WHEN grade = 'F' THEN  'Poor'
            ELSE 'No such grade'
        END ;
    dbe_output.print_line(appraisal);
END;
/

DECLARE
    grade CHAR(1) := 'B';
    appraisal VARCHAR2(20);
BEGIN    
        CASE grade
            WHEN 'A' THEN appraisal := 'Excellent';
            WHEN 'B' THEN appraisal := 'Very Good';
            WHEN 'B' THEN appraisal := 'Good';
            WHEN 'D' THEN appraisal := 'Fair';
            WHEN 'F' THEN appraisal := 'Poor';
            ELSE appraisal := 'No such grade';
        END CASE;
    dbe_output.print_line(appraisal);
END;
/

DECLARE
    grade CHAR(1) := 'B';
    appraisal VARCHAR2(20);
BEGIN    
        CASE 
            WHEN grade = 'A' THEN appraisal := 'Excellent';
            WHEN grade = 'B' THEN appraisal := 'Very Good';
            WHEN grade = 'C' THEN appraisal := 'Good';
            WHEN grade = 'D' THEN appraisal := 'Fair';
            WHEN grade = 'F' THEN appraisal := 'Poor';
            ELSE appraisal := 'No such grade';
        END CASE;
    dbe_output.print_line(appraisal);
END;
/

DECLARE
    grade CHAR(1) := 'B';
    appraisal VARCHAR2(20);
BEGIN    
        CASE grade
            WHEN 'A' THEN appraisal := 'Excellent';            
            WHEN 'C' THEN appraisal := 'Good';
            WHEN 'D' THEN appraisal := 'Fair';
            WHEN 'F' THEN appraisal := 'Poor';            
        END CASE;
    dbe_output.print_line(appraisal);
END;
/

--test for cursor
drop table if exists plsql_test;
create table plsql_test(a int, b bigint, c char(10), d varchar(20), e bool);
insert into plsql_test (a, b) values(1,200);

declare
a1 int;
begin
a1 := 1;
update plsql_test set a = a + 11 where a = 1;
delete from plsql_test where a = a1;
select a as a1 into a1 from plsql_test;
dbe_output.print_line('result is ' || a1);
commit;
end;
/

declare
a1 int;
begin
a1 := 1;
insert into plsql_test (a, b) values(2,201);
select a into a1 from plsql_test;
dbe_output.print_line('result is ' || a1);
commit;
end;
/

declare
a1 int;
begin
a1 := 1;
select a into a1 from plsql_test limit 1;
dbe_output.print_line('result is ' || a1);
commit;
end;
/

declare
a1 int;
begin
a1 := 1;
delete from plsql_test;
select a into a1 from plsql_test;
dbe_output.print_line('result is ' || a1);
commit;
end;
/

declare
a1 int;
begin
a1 := 1;
insert into plsql_test (a, b) values(2,201);
select * into a1 from plsql_test;
dbe_output.print_line('result is ' || a1);
commit;
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
declare
b int;
cursor c1(xx int default 10) is select a from plsql_test where a = xx;
begin
open c1(20);
FETCH c1 into b;
dbe_output.print_line('result is:' || b);
FETCH c1 into b;
dbe_output.print_line('result is:' || b);
close c1;
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;

declare
b1 int;
cursor c1 is select a from plsql_test;
begin
delete from plsql_test;
insert into plsql_test (a, b) values(1,100);
insert into plsql_test (a, b) values(2,100);
insert into plsql_test (a, b) values(2,201);
open c1;
FETCH c1 into b1;
dbe_output.print_line('result is:' || b1);
FETCH c1 into b1;
dbe_output.print_line('result is:' || b1);
FETCH c1 into b1;
dbe_output.print_line('result is:' || b1);
FETCH c1 into b1;
dbe_output.print_line('result is:' || b1);
close c1;
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;

declare
b int;
cursor c1(xx int default 10) is select a from plsql_test where a = xx;
begin
delete from plsql_test;
open c1;
FETCH c1 into b;
dbe_output.print_line('result is:' || b);
FETCH c1 into b;
dbe_output.print_line('result is:' || b);
close c1;
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
declare
b int;
c1 sys_refcursor;
begin
delete from plsql_test;
open c1 for select a from plsql_test;
FETCH c1 into b;
dbe_output.print_line('result is:' || b);
FETCH c1 into b;
dbe_output.print_line('result is:' || b);
close c1;
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;

declare
b int;
c1 sys_refcursor;
begin
delete from plsql_test;
open c1;
FETCH c1 into b;
dbe_output.print_line('result is:' || b);
FETCH c1 into b;
dbe_output.print_line('result is:' || b);
close c1;
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;

declare
b int;
c1 sys_refcursor;
begin
delete from plsql_test;
insert into plsql_test (a) values(100);
insert into plsql_test (a) values(101);
open c1 for select a from plsql_test;
FETCH c1 into b;
dbe_output.print_line('result is:' || b);
FETCH c1 into b;
dbe_output.print_line('result is:' || b);
close c1;
end;
/

select * from plsql_test;
delete from plsql_test;
commit;

select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;

--BEGIN:TEST
drop table if exists plsql_t1;
create table plsql_t1 (f1 int, f2 varchar(100));
insert into plsql_t1 values (1, 'a'), (2, 'b'), (3, 'c');
commit;

create or replace procedure plsql_p1()
as
a int := 10;
c4 SYS_REFCURSOR;
begin
open c4 for select * from plsql_t1 where f1 < a order by f1;
dbe_sql.return_cursor(c4);
end;
/

call plsql_p1();
drop table plsql_t1;
call plsql_p1();
create table plsql_t1 (f1 int, f2 varchar(100));
call plsql_p1();
--END

--test exec/execute procedure
--2018/6/16
drop table if exists plsql_test_pro_t1;
create table plsql_test_pro_t1(f1 int, f2 varchar2(20));

drop function if exists plsql_test_p1;
drop procedure if exists plsql_test_p1;
create or replace procedure plsql_test_p1(a int, b varchar2)
as
c int := 1;
d int := 2;
begin
  insert into plsql_test_pro_t1 values(a,b);
  commit;
end;
/

--expect success
exec plsql_test_p1(100,'sss');
execute plsql_test_p1(101,'sss'); 
call plsql_test_p1(101,'sss'); 

select f1, f2 from plsql_test_pro_t1 order by f1, f2;

--expect error
exec plsql_test_noexist_p1(100,'sss');
execute plsql_test_noexist_p1(101,'sss'); 
call plsql_test_noexist_p1(101,'sss'); 
call plsql_test_noexist_p1(101,'sss') abc; 
call plsql_test_noexist_p1(101,'sss') abc(); 

--unsupport without brackets when procedure has no arguments.
--create success
create or replace procedure plsql_test_p2
as
begin
  insert into plsql_test_pro_t1 values(1,'a');
  commit;
end;
/
--expect succ
exec plsql_test_p2;
execute plsql_test_p2;
call plsql_test_p2;
--expect success
exec plsql_test_p2();
execute plsql_test_p2();
call plsql_test_p2();

select f1, f2 from plsql_test_pro_t1 order by f1, f2;

drop table if exists plsql_test_pro_t1;
drop procedure if exists plsql_test_p1;
drop procedure if exists plsql_test_p2;


declare
a1 int;
begin
dbe_output.print_line('SQL%ISOPEN :' || SQL%ISOPEN);
dbe_output.print_line('SQL%FOUND :' || SQL%FOUND);
dbe_output.print_line('SQL%NOTFOUND :' || SQL%NOTFOUND);
dbe_output.print_line('SQL%ROWCOUNT :' || SQL%ROWCOUNT);
end;
/

declare
a1 int;
begin
delete from plsql_test;
dbe_output.print_line('SQL%ISOPEN :' || SQL%ISOPEN);
dbe_output.print_line('SQL%FOUND :' || SQL%FOUND);
dbe_output.print_line('SQL%NOTFOUND :' || SQL%NOTFOUND);
dbe_output.print_line('SQL%ROWCOUNT :' || SQL%ROWCOUNT);
dbe_output.print_line('%ROWCOUNT :' || SQL%xxxx);
end;
/

begin
delete from plsql_test;
dbe_output.print_line('SQL%ISOPEN :' || SQL%ISOPEN);
dbe_output.print_line('SQL%FOUND :' || SQL%FOUND);
dbe_output.print_line('SQL%NOTFOUND :' || SQL%NOTFOUND);
dbe_output.print_line('SQL%ROWCOUNT :' || SQL%ROWCOUNT);
end;
/

declare
a1 int;
begin
delete from plsql_test;
insert into plsql_test (a) values (1);
select a into a1 from plsql_test;
dbe_output.print_line('SQL%ISOPEN :' || SQL%ISOPEN);
dbe_output.print_line('SQL%FOUND :' || SQL%FOUND);
dbe_output.print_line('SQL%NOTFOUND :' || SQL%NOTFOUND);
dbe_output.print_line('SQL%ROWCOUNT :' || SQL%ROWCOUNT);
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
declare
cursor a1 is select a from plsql_test;
begin
dbe_output.print_line('%ISOPEN :' || a1%ISOPEN);
dbe_output.print_line('%FOUND :' || a1%FOUND);
end;
/
declare
cursor a1 is select a from plsql_test;
begin
dbe_output.print_line('%ISOPEN :' || a1%ISOPEN);
dbe_output.print_line('%NOTFOUND :' || a1%NOTFOUND);
end;
/
declare
cursor a1 is select a from plsql_test;
begin
dbe_output.print_line('%ISOPEN :' || a1%ISOPEN);
dbe_output.print_line('%ROWCOUNT :' || a1%ROWCOUNT);
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
delete from plsql_test;
declare
cursor a1 is select a from plsql_test;
begin
open a1;
dbe_output.print_line('%ISOPEN :' || a1%ISOPEN);
dbe_output.print_line('%FOUND :' || a1%FOUND);
dbe_output.print_line('%NOTFOUND :' || a1%NOTFOUND);
dbe_output.print_line('%ROWCOUNT :' || a1%ROWCOUNT);
close a1;
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
declare
b int;
cursor a1 is select a from plsql_test;
begin
open a1;
fetch a1 into b;
dbe_output.print_line('%OPEN :' || a1%ISOPEN);
dbe_output.print_line('%FOUND :' || a1%FOUND);
dbe_output.print_line('%NOTFOUND :' || a1%NOTFOUND);
dbe_output.print_line('%ROWCOUNT :' || a1%ROWCOUNT);
close a1;
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
declare
b int;
cursor a1 is select a from plsql_test;
begin
open a1;
fetch a1 into b;
dbe_output.print_line('%OPEN :' || a1%ISOPEN);
dbe_output.print_line('%FOUND :' || a1%FOUND);
dbe_output.print_line('%NOTFOUND :' || a1%NOTFOUND);
dbe_output.print_line('%ROWCOUNT :' || a1%ROWCOUNT);
dbe_output.print_line('%ROWCOUNT :' || a1%xxxx);
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
--record.

declare
type xxx is record (
  a int,
  b int
);
type yyy is record (
  a xxx
);
ab yyy;
abc xxx;
begin
delete from plsql_test;
insert into plsql_test (a,b) values(1,100);
select a,b into ab from plsql_test;
dbe_output.print_line('result is ' || ab.a.a);
dbe_output.print_line('result is ' || ab.a.b);
end;
/
declare
type xxx is record (
  a int,
  b int
);
type yyy is record (
  a xxx
);
ab yyy;
abc xxx;
begin
delete from plsql_test;
insert into plsql_test (a,b) values(1,100);
select a,b into abc from plsql_test;
dbe_output.print_line('result is ' || abc.a);
dbe_output.print_line('result is ' || abc.b);
select a,b into ab.a from plsql_test;
dbe_output.print_line('result is ' || ab.a.a);
dbe_output.print_line('result is ' || ab.a.b);
end;
/

declare
type xxx is record (
  a int,
  b int
);
type yyy is record (
  a xxx
);
ab yyy;
abc xxx;
cursor c1 is select a,b from plsql_test order by a;
begin
delete from plsql_test;
insert into plsql_test (a,b) values(1,100);
insert into plsql_test (a,b) values(2,101);
open c1;
fetch c1 into abc;
dbe_output.print_line('result is ' || abc.a);
dbe_output.print_line('result is ' || abc.b);
close c1;
end;
/
declare
type xxx is record (
  a int,
  b int
);
type yyy is record (
  a xxx
);
ab yyy;
abc xxx;
cursor c1 is select a,b from plsql_test order by a;
begin
delete from plsql_test;
insert into plsql_test (a,b) values(1,100);
insert into plsql_test (a,b) values(2,101);
open c1;
fetch c1 into ab;
dbe_output.print_line('result is ' || ab.a.a);
dbe_output.print_line('result is ' || ab.a.b);
close c1;
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
declare
type xxx is record (
  a int,
  b int
);
type yyy is record (
  a xxx
);
ab yyy;
cursor c1 is select a from plsql_test order by a;
begin
open c1;
fetch c1 into ab.a.a;
dbe_output.print_line('result is ' || ab.a.a);
dbe_output.print_line('result is ' || ab.a.b);
close c1;
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
declare
type xxx is record (
  a int,
  b int
);
ab xxx;
abc ab%type;
begin
delete from plsql_test;
insert into plsql_test (a,b) values(1,100);
select a,b into abc from plsql_test order by a;
dbe_output.print_line('result is ' || abc.a);
dbe_output.print_line('result is ' || abc.b);
end;
/

declare
type xxx is record (
  a int,
  b int
);
ab xxx;
abc ab.a%type;
begin
delete from plsql_test;
insert into plsql_test (a,b) values(1,100);
select a into abc from plsql_test;
dbe_output.print_line('result is ' || abc);
end;
/
--expect error
declare
type xxx is record (
  a int,
  b int
);
cursor a1 is select a,b from plsql_test order by a;
abc a1%type;
ab  xxx;
begin
open abc;
fetch abc into ab;
dbe_output.print_line('result is ' || ab.a);
dbe_output.print_line('result is ' || ab.b);
close abc;
end;
/
declare
type xxx is record (
  a int,
  b int
);
cursor a1 is select a,b from plsql_test order by a;
abc a1%type;
ab  xxx;
begin
open abc;
fetch abc into ab;
dbe_output.print_line('result is ' || ab.a);
dbe_output.print_line('result is ' || ab.b);
close abc;
end;
/
declare
type xxx is record (
  a int,
  b int
);
cursor c1 is select * from plsql_test order by a;
c2 sys_refcursor;
abc xxx;
begin
open c2 for select a from plsql_test order by a;
close c2;
open c2 for select a,b from plsql_test order by a;
fetch c2 into abc;
close c2;
dbe_output.print_line('result is ' || abc.a);
dbe_output.print_line('result is ' || abc.b);
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
declare
abc plsql_test.a%type;
c2 sys_refcursor;
begin
open c2 for select a from plsql_test order by a;
fetch c2 into abc;
close c2;
dbe_output.print_line('result is ' || abc);
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;

DECLARE
CURSOR c1 IS
select a,b from plsql_test order by a;
BEGIN
delete from plsql_test;
insert into plsql_test(a,b) values(1,100);
insert into plsql_test(a,b) values(1,100);
FOR item IN c1
LOOP
dbe_output.print_line('A = ' || item.a || ',B = ' || item.b);
dbe_output.print_line('CURSOR%ISOPEN   is ' || c1%ISOPEN);
dbe_output.print_line('CURSOR%FOUND    is ' || c1%FOUND);
dbe_output.print_line('CURSOR%NOTFOUND is ' || c1%NOTFOUND);
dbe_output.print_line('CURSOR%ROWCOUNT is ' || c1%ROWCOUNT);
END LOOP;
dbe_output.print_line('after for loop');
dbe_output.print_line('CURSOR%ISOPEN   is ' || c1%ISOPEN);
END;
/

DECLARE
CURSOR c1 IS
select a,b from plsql_test order by a;
BEGIN
delete from plsql_test;
insert into plsql_test(a,b) values(1,100);
insert into plsql_test(a,b) values(1,100);
FOR item IN c1
LOOP
dbe_output.print_line('A = ' || item.a || ',B = ' || item.b);
END LOOP;
dbe_output.print_line('after for loop');
dbe_output.print_line('CURSOR%ISOPEN   is ' || c1%ISOPEN);
dbe_output.print_line('CURSOR%FOUND    is ' || c1%FOUND);
END;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
DECLARE
CURSOR c1 IS
select a,b from plsql_test order by a;
BEGIN
delete from plsql_test;
FOR item IN c1
LOOP
dbe_output.print_line('A = ' || item.a || ',B = ' || item.b);
END LOOP;
END;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
DECLARE
CURSOR c1 IS
select a,b from plsql_test order by a;
BEGIN
open c1;
close c1;
delete from plsql_test;
insert into plsql_test(a,b) values(1,100);
insert into plsql_test(a,b) values(2,101);
insert into plsql_test(a,b) values(3,99);
FOR item IN c1
LOOP
dbe_output.print_line('A = ' || item.a || ',B = ' || item.b);
END LOOP;
END;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
DECLARE
CURSOR c1 IS
select a,b from plsql_test order by a;
BEGIN
open c1;
open c1;
exception
when CURSOR_ALREADY_OPEN then
dbe_output.print_line('exception CURSOR_ALREADY_OPEN');
close c1;
END;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
DECLARE
c1 sys_refcursor;
BEGIN
open c1 for select a,b from plsql_test order by a;
open c1 for select a,b from plsql_test order by b;
exception
when CURSOR_ALREADY_OPEN then
dbe_output.print_line('exception CURSOR_ALREADY_OPEN');
close c1;
END;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;

--BEGIN: plsql_test '=>'
DROP TABLE IF EXISTS plsql_T_PL_1;
CREATE TABLE plsql_T_PL_1 (F_INT1 INT, F_INT2 INT, F_CHAR VARCHAR(16));
DROP procedure IF EXISTS plsql_p1;
CREATE procedure plsql_p1(a int , b varchar2, c int)
AUTHID CURRENT_USER
as
d int := 1;
Begin
Insert into plsql_T_PL_1( f_int1, f_char,f_int2)  values(a,b,c);
Commit;
End;
/

begin 
	plsql_p1(1,'ww1',1);
end;
/
SELECT * FROM plsql_T_PL_1 ORDER BY 1,2,3;

begin
	plsql_p1(1,'ww1',c => 2); 
end;
/
SELECT * FROM plsql_T_PL_1 ORDER BY 1,2,3;

begin
	plsql_p1(1,c => 2,b => 'ww2');
end;
/
SELECT * FROM plsql_T_PL_1 ORDER BY 1,2,3;

begin
	plsql_p1(1,b => 'ww3',c => 2);
end;
/
SELECT * FROM plsql_T_PL_1 ORDER BY 1,2,3;

begin
	plsql_p1(a => 1,b => 'ww4',c => 2);
end;
/
SELECT * FROM plsql_T_PL_1 ORDER BY 1,2,3;

--error
begin
	plsql_p1(a => 1,b => 'ww4', 2);
end;
/

--error
begin
	plsql_p1(a => 1,b => 'ww4', a => 2, c => 2);
end;
/

--error
begin
	plsql_p1(a => 1,b => 'ww4', b => 'a',c => 2);
end;
/
--END: plsql_test '=>'

CREATE OR REPLACE PROCEDURE plsql_Zenith_Test_003(param1 in varchar2,param2 in varchar2)
IS
begin
dbe_output.print_line('Hello Zenith:'||param1||','||param2);
end plsql_Zenith_Test_003;
/

call plsql_Zenith_Test_003(to_char(to_date('2018-01-07','YYYY-MM-DD'),'DDD'),UPPER('Zenith$'));
call plsql_Zenith_Test_003(param2=>UPPER('Zenith$'),param1=>to_char(to_date('2018-01-07','YYYY-MM-DD'),'DDD'));
call plsql_Zenith_Test_003(param2=>(select case when 1=1 then 'True' else 'False' end from dual),param1=>'Case when Sub');

--test create procedure/function can end with object name
--2018/6/20
create or replace procedure plsql_ztest_p1(a int, b varchar2)
as
c int;
begin
  c := a;
end plsql_ztest_p1;
/

drop procedure plsql_ztest_p1;

create or replace procedure plsql_ztest_p2(a int, b varchar2)
as
c int;
begin
  c := a;
end;
/

drop procedure plsql_ztest_p2;

create or replace procedure plsql_ztest_p3(a int, b varchar2)
as
c int;
begin
  c := a;
end plsql_ztest_p34;
/

create or replace procedure plsql_ztest_p4(a int, b varchar2)
as
c int;
begin
  c := a;
end plsql_ztest_p4 /
/

drop procedure if exists plsql_ztest_p1;
drop procedure if exists plsql_ztest_p2;
drop procedure if exists plsql_ztest_p3;
drop procedure if exists plsql_ztest_p4;

create or replace function plsql_ztest_f1(a int, b varchar2)
return int
as
c int;
begin
  c := a;
  return c;
end plsql_ztest_f1;
/

create or replace function plsql_ztest_f2(a int, b varchar2)
return int
as
c int;
begin
  c := a;
  return c;
end;
/

exec plsql_ztest_f1(1,'1');
exec plsql_ztest_f2(1,'1');
exec ztest_f3(1,'1');

drop function if exists plsql_ztest_f1;
drop function if exists plsql_ztest_f2;



--test variable default value can be set to another variable in declares.
--2018/6/22
declare
a int := 1+2;
b int := a+1;
c int;
begin
 c := b+3;
 dbe_output.print_line(a);
 dbe_output.print_line(b);
 dbe_output.print_line(c);
 a := 10;
 dbe_output.print_line(a);
 dbe_output.print_line(b);
 dbe_output.print_line(c);
end; 
/

--test cloud sop.
drop table plsql_tab;
create table plsql_tab(tname varchar(200));
insert into plsql_tab values('donghaijun');
drop procedure if exists plsql_Setting_Drop_Entity;
create or replace procedure plsql_Setting_Drop_Entity(v_type IN varchar2,v_name IN varchar2)
as
        v_cnt number;
        sqlstr varchar2(200);
begin
        if v_type='table' then
                select count(*) into v_cnt from plsql_tab
                        where upper(tname)=upper(v_name);
                dbe_output.print_line('count is ' || v_cnt);
        else 
                dbe_output.print_line('no data found');
        end if;
end;
/

declare
v_type varchar2(200);
v_name varchar2(200);
begin
v_type := 'table';
v_name := 'donghaijun';
plsql_Setting_Drop_Entity(v_type,v_name);
end;
/              
declare
v_type varchar2(200);
v_name varchar2(200);
begin
v_type := 'table';
v_name := 'DONGHAIJUN';
plsql_Setting_Drop_Entity(v_type,v_name);
end;
/

declare
v_type varchar2(200);
v_name varchar2(200);
begin
v_type := 'table1';
v_name := 'DONGHAIJUN';
plsql_Setting_Drop_Entity(v_type,v_name);
end;
/
insert into plsql_tab values('donghaijun');
execute plsql_Setting_Drop_Entity('table1','DONGHAIJUN');
execute plsql_Setting_Drop_Entity('table','donghaijun');
execute plsql_Setting_Drop_Entity('table','DONGHAIJUN');
drop table plsql_tab;

--call procedure
drop table if exists plsql_test_pro_t1;
create table plsql_test_pro_t1(f1 int, f2 varchar2(20));
drop procedure if exists plsql_test_p1;
create or replace procedure plsql_test_p1(a int, b varchar2, f_out1 out int, f_out2 out int, f_out3 OUT sys_refcursor)
as
c int := 1;
d int := 2;
begin
  delete from plsql_test_pro_t1;
  insert into plsql_test_pro_t1 values(a,b);
  select f1 into f_out1 from plsql_test_pro_t1;
  f_out2 := 22;
  open f_out3 for select f1,f2 from plsql_test_pro_t1;
  commit;
end;
/

declare
a int := 1;
b varchar2(10) := 'abcd';
c int;
d int;
f sys_refcursor;
type xxx is record (
  a int,
  b varchar2(10)
);
item xxx;
begin
plsql_test_p1(a,b,c,d,f);
dbe_output.print_line('c is ' || c);
dbe_output.print_line('d is ' || d);
fetch f into item;
dbe_output.print_line('item.a is ' || item.a);
dbe_output.print_line('item.b is ' || item.b);
close f;
end;
/
drop table plsql_test_pro_t1;
drop procedure plsql_test_p1;

drop table if exists t1;
create table t1 
(  
    f_int1           integer default 0 not null,  
    f_int2           integer,  
    f_int3           integer, 
    f_bigint1        bigint,  
    f_bigint2        bigint,  
    f_bigint3        bigint,  
    f_bool1          integer,  
    f_bool2          integer,  
    f_num1           number(38, 0),  
    f_num2           number(38, 0),  
    f_dec1           DECIMAL(38, 0), 
    f_dec2           DECIMAL(38, 0),  
    f_num10          number(38, 10),  
    f_dec10          decimal(38, 10),      
    f_float          float,  
    f_double         double,  
    f_real           real,  
    f_char1          char(128),  
    f_char2          char(128),  
    f_varchar1       varchar(512),  
    f_varchar2       varchar2(512),  
    f_date1          date,  
    f_date2          date,  
    f_time           date, 
    f_timestamp      timestamp
);
insert into t1 values (1,2,3,
 555555555555, 555555555556, 555555555557, 
 true, false, 
 1234567890.1234567890, 1234567890.1234567891, 1234567890.1234567892,
 1234567890.1234567893, 1234567890.1234567894, 1234567890.1234567895,
 1.234, 1.235, 1.236,
 'wanghaifeng', 'wanghaifeng1', 'wanghaifeng2', 'wanghaifeng3', 
 '2018-06-25 22:55:00', '2018-06-25 22:55:01',
 '2018-06-25 22:55:02', '2018-06-25 22:55:03');
 commit;
 
declare
type xxx is record (
    f_int1           integer,  
    f_int2           integer,  
    f_int3           integer, 
    f_bigint1        bigint,  
    f_bigint2        bigint,  
    f_bigint3        bigint,  
    f_bool1          integer,  
    f_bool2          integer,  
    f_num1           number(38, 0),     
    f_num2           number(38, 0),     
    f_dec1           DECIMAL(38, 0),    
    f_dec2           DECIMAL(38, 0),    
    f_num10          number(38, 10),    
    f_dec10          decimal(38, 10),   
    f_float          float,  
    f_double         double,  
    f_real           real,  
    f_char1          char(128),  
    f_char2          char(128),  
    f_varchar1       varchar(512),  
    f_varchar2       varchar2(512),  
    f_date1          date,  
    f_date2          date,  
    f_time           date, 
    f_timestamp      timestamp
);
f_int1           integer;
f_int2           integer;  
f_int3           integer; 
f_bigint1        bigint; 
f_bigint2        bigint;  
f_bigint3        bigint;  
f_bool1          integer;  
f_bool2          integer;  
f_num1           number(38, 0);
f_num2           number(38, 0);     
f_dec1           DECIMAL(38, 0);    
f_dec2           DECIMAL(38, 0);    
f_num10          number(38, 10);    
f_dec10          decimal(38, 10);   
f_float          float;
f_double         double;  
f_real           real; 
f_char1          char(128);
f_char2          char(128);  
f_varchar1       varchar(512);
f_varchar2       varchar2(512);  
f_date1          date; 
f_date2          date;  
f_time           date; 
f_timestamp      timestamp;
item xxx;
begin
select * into item from t1;
dbe_output.print_line('item.f_int1      is ' || item.f_int1     );
dbe_output.print_line('item.f_int2      is ' || item.f_int2     );
dbe_output.print_line('item.f_int3      is ' || item.f_int3     );
dbe_output.print_line('item.f_bigint1   is ' || item.f_bigint1  );
dbe_output.print_line('item.f_bigint2   is ' || item.f_bigint2  );
dbe_output.print_line('item.f_bigint3   is ' || item.f_bigint3  );
dbe_output.print_line('item.f_bool1     is ' || item.f_bool1    );
dbe_output.print_line('item.f_bool2     is ' || item.f_bool2    );
dbe_output.print_line('item.f_num1      is ' || item.f_num1     );
dbe_output.print_line('item.f_num2      is ' || item.f_num2     );
dbe_output.print_line('item.f_dec1      is ' || item.f_dec1     );
dbe_output.print_line('item.f_dec2      is ' || item.f_dec2     );
dbe_output.print_line('item.f_num10     is ' || item.f_num10    );
dbe_output.print_line('item.f_dec10     is ' || item.f_dec10    );
dbe_output.print_line('item.f_float     is ' || item.f_float    );
dbe_output.print_line('item.f_double    is ' || item.f_double   );
dbe_output.print_line('item.f_real      is ' || item.f_real     );
dbe_output.print_line('item.f_char1     is ' || item.f_char1    );
dbe_output.print_line('item.f_char2     is ' || item.f_char2    );
dbe_output.print_line('item.f_varchar1  is ' || item.f_varchar1 );
dbe_output.print_line('item.f_varchar2  is ' || item.f_varchar2 );
dbe_output.print_line('item.f_date1     is ' || item.f_date1    );
dbe_output.print_line('item.f_date2     is ' || item.f_date2    );
dbe_output.print_line('item.f_time      is ' || item.f_time     );
dbe_output.print_line('item.f_timestamp is ' || item.f_timestamp);
select * into f_int1,f_int2,f_int3,f_bigint1,f_bigint2,f_bigint3,f_bool1,f_bool2,f_num1,f_num2,f_dec1,f_dec2,f_num10,f_dec10,f_float,f_double,f_real,f_char1,f_char2,f_varchar1,f_varchar2,f_date1,f_date2,f_time,f_timestamp from t1;
dbe_output.print_line('f_int1      is ' || f_int1     );
dbe_output.print_line('f_int2      is ' || f_int2     );
dbe_output.print_line('f_int3      is ' || f_int3     );
dbe_output.print_line('f_bigint1   is ' || f_bigint1  );
dbe_output.print_line('f_bigint2   is ' || f_bigint2  );
dbe_output.print_line('f_bigint3   is ' || f_bigint3  );
dbe_output.print_line('f_bool1     is ' || f_bool1    );
dbe_output.print_line('f_bool2     is ' || f_bool2    );
dbe_output.print_line('f_num1      is ' || f_num1     );
dbe_output.print_line('f_num2      is ' || f_num2     );
dbe_output.print_line('f_dec1      is ' || f_dec1     );
dbe_output.print_line('f_dec2      is ' || f_dec2     );
dbe_output.print_line('f_num10     is ' || f_num10    );
dbe_output.print_line('f_dec10     is ' || f_dec10    );
dbe_output.print_line('f_float     is ' || f_float    );
dbe_output.print_line('f_double    is ' || f_double   );
dbe_output.print_line('f_real      is ' || f_real     );
dbe_output.print_line('f_char1     is ' || f_char1    );
dbe_output.print_line('f_char2     is ' || f_char2    );
dbe_output.print_line('f_varchar1  is ' || f_varchar1 );
dbe_output.print_line('f_varchar2  is ' || f_varchar2 );
dbe_output.print_line('f_date1     is ' || f_date1    );
dbe_output.print_line('f_date2     is ' || f_date2    );
dbe_output.print_line('f_time      is ' || f_time     );
dbe_output.print_line('f_timestamp is ' || f_timestamp);
end;
/


declare
f_int1           integer;
f_int2           integer;  
f_int3           integer; 
f_bigint1        bigint; 
f_bigint2        bigint;  
f_bigint3        bigint;  
f_bool1          integer;  
f_bool2          integer;  
f_num1           number(38, 0);
f_num2           number(38, 0);     
f_dec1           DECIMAL(38, 0);    
f_dec2           DECIMAL(38, 0);    
f_num10          number(38, 10);    
f_dec10          decimal(38, 10);   
f_float          float;
f_double         double;  
f_real           real; 
f_char1          char(128);
f_char2          char(128);  
f_varchar1       varchar(512);
f_varchar2       varchar2(512);  
f_date1          date; 
f_date2          date;  
f_time           date; 
f_timestamp      timestamp;
begin
dbe_output.print_line('BEGIN:');
insert into t1 values (1,2,3,
 555555555555, 555555555556, 555555555557, 
 true, false, 
 1234567890.1234567890, 1234567890.1234567891, 1234567890.1234567892,
 1234567890.1234567893, 1234567890.1234567894, 1234567890.1234567895,
 1.234, 1.235, 1.236,
 'wanghaifeng', 'wanghaifeng1', 'wanghaifeng2', 'wanghaifeng3', 
 '2018-06-25 22:55:00', '2018-06-25 22:55:01',
 '2018-06-25 22:55:02', '2018-06-25 22:55:03');
select * into f_int1,f_int2,f_int3,f_bigint1,f_bigint2,f_bigint3,f_bool1,f_bool2,f_num1,f_num2,f_dec1,f_dec2,f_num10,f_dec10,f_float,f_double,f_real,f_char1,f_char2,f_varchar1,f_varchar2,f_date1,f_date2,f_time,f_timestamp from t1;
dbe_output.print_line('f_int1      is ' || f_int1     );
dbe_output.print_line('f_int2      is ' || f_int2     );
dbe_output.print_line('f_int3      is ' || f_int3     );
dbe_output.print_line('f_bigint1   is ' || f_bigint1  );
dbe_output.print_line('f_bigint2   is ' || f_bigint2  );
dbe_output.print_line('f_bigint3   is ' || f_bigint3  );
dbe_output.print_line('f_bool1     is ' || f_bool1    );
dbe_output.print_line('f_bool2     is ' || f_bool2    );
dbe_output.print_line('f_num1      is ' || f_num1     );
dbe_output.print_line('f_num2      is ' || f_num2     );
dbe_output.print_line('f_dec1      is ' || f_dec1     );
dbe_output.print_line('f_dec2      is ' || f_dec2     );
dbe_output.print_line('f_num10     is ' || f_num10    );
dbe_output.print_line('f_dec10     is ' || f_dec10    );
dbe_output.print_line('f_float     is ' || f_float    );
dbe_output.print_line('f_double    is ' || f_double   );
dbe_output.print_line('f_real      is ' || f_real     );
dbe_output.print_line('f_char1     is ' || f_char1    );
dbe_output.print_line('f_char2     is ' || f_char2    );
dbe_output.print_line('f_varchar1  is ' || f_varchar1 );
dbe_output.print_line('f_varchar2  is ' || f_varchar2 );
dbe_output.print_line('f_date1     is ' || f_date1    );
dbe_output.print_line('f_date2     is ' || f_date2    );
dbe_output.print_line('f_time      is ' || f_time     );
dbe_output.print_line('f_timestamp is ' || f_timestamp);
end;
/

BEGIN
delete from plsql_test;
insert into plsql_test(a,b) values(1,100);
insert into plsql_test(a,b) values(2,101);
FOR item IN (select a,b from plsql_test order by a)
LOOP
dbe_output.print_line('A = ' || item.a || ',B = ' || item.b);
dbe_output.print_line('SQL%ISOPEN :' || SQL%ISOPEN);
dbe_output.print_line('SQL%FOUND :' || SQL%FOUND);
dbe_output.print_line('SQL%NOTFOUND :' || SQL%NOTFOUND);
dbe_output.print_line('SQL%ROWCOUNT :' || SQL%ROWCOUNT);
END LOOP;
dbe_output.print_line('after for loop');
dbe_output.print_line('SQL%ISOPEN :' || SQL%ISOPEN);
dbe_output.print_line('SQL%FOUND :' || SQL%FOUND);
dbe_output.print_line('SQL%NOTFOUND :' || SQL%NOTFOUND);
dbe_output.print_line('SQL%ROWCOUNT :' || SQL%ROWCOUNT);
END;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
DECLARE
xxx int := 0;
BEGIN
delete from plsql_test;
insert into plsql_test(a,b) values(1,100);
insert into plsql_test(a,b) values(2,101);
FOR item IN (select a,b from plsql_test order by a)
LOOP
dbe_output.print_line('A = ' || item.a || ',B = ' || item.b);
dbe_output.print_line('SQL%ISOPEN :' || SQL%ISOPEN);
dbe_output.print_line('SQL%FOUND :' || SQL%FOUND);
dbe_output.print_line('SQL%NOTFOUND :' || SQL%NOTFOUND);
dbe_output.print_line('SQL%ROWCOUNT :' || SQL%ROWCOUNT);
xxx := xxx / 0;
END LOOP;
dbe_output.print_line('after for loop');
dbe_output.print_line('SQL%ISOPEN :' || SQL%ISOPEN);
dbe_output.print_line('SQL%FOUND :' || SQL%FOUND);
dbe_output.print_line('SQL%NOTFOUND :' || SQL%NOTFOUND);
dbe_output.print_line('SQL%ROWCOUNT :' || SQL%ROWCOUNT);
END;
/

drop table if exists plsql_test;
create table plsql_test(a int, b bigint, c char(10), d varchar(20), e bool);

select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
BEGIN
delete from plsql_test;
FOR item IN (select a,b from plsql_test order by a)
LOOP
dbe_output.print_line('A = ' || item.a || ',B = ' || item.b);
dbe_output.print_line('SQL%ISOPEN :' || SQL%ISOPEN);
dbe_output.print_line('SQL%FOUND :' || SQL%FOUND);
dbe_output.print_line('SQL%NOTFOUND :' || SQL%NOTFOUND);
dbe_output.print_line('SQL%ROWCOUNT :' || SQL%ROWCOUNT);
END LOOP;
dbe_output.print_line('after for loop');
dbe_output.print_line('SQL%ISOPEN :' || SQL%ISOPEN);
dbe_output.print_line('SQL%FOUND :' || SQL%FOUND);
dbe_output.print_line('SQL%NOTFOUND :' || SQL%NOTFOUND);
dbe_output.print_line('SQL%ROWCOUNT :' || SQL%ROWCOUNT);
END;
/

drop procedure if exists p_upgradecron
/
drop table if exists CRON_FIRED_TRIGGERS;
drop table if exists SCHED_TIME;
create table CRON_FIRED_TRIGGERS(a int);
create table SCHED_TIME(a int);
conn sys/Huawei@123@127.0.0.1:1611
grant select on SYS.SYS_COLUMNS to gs_plsql;
grant select on SYS.SYS_TABLES to gs_plsql;
conn gs_plsql/Whf00174302@127.0.0.1:1611
CREATE OR REPLACE PROCEDURE p_upgradecron()
as
    v_count int;
begin 
    SELECT COUNT(1) into v_count FROM SYS.SYS_COLUMNS WHERE (USER#, table#) IN (SELECT USER#, ID FROM SYS.SYS_TABLES WHERE NAME='CRON_FIRED_TRIGGERS') AND NAME='SCHED_TIME';
    if v_count = 0 then 
        EXECUTE IMMEDIATE 'alter table CRON_FIRED_TRIGGERS add SCHED_TIME bigint not null default 0';
        dbe_output.print_line('alter table');
    else
    	dbe_output.print_line('v_count is ' || v_count);
    end if;
end;
/
call p_upgradecron()
/
drop procedure if exists p_upgradecron
/

create or replace procedure plsql_ztest_p1(a int)
as
c int;
begin
  select a into c from dual;
  dbe_output.print_line(c);
  dbe_output.print_line(a);
end plsql_ztest_p1;
/

exec plsql_ztest_p1(1);


drop procedure plsql_ztest_p1;
create or replace procedure ztest_p5
as
c int := 1;
begin
  dbe_output.print_line(c);
end ztest_p5;
/

exec ztest_p5;
exec ztest_p5();
execute ztest_p5;
execute ztest_p5();
call ztest_p5;
call ztest_p5();

drop procedure ztest_p5;

set serveroutput off;

select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
--test select into
--2018/6/26
set serveroutput on;
drop table if exists plsql_test_pl_t1;
create table plsql_test_pl_t1(a int, b int,c int, d varchar2(32));
insert into plsql_test_pl_t1 values(4,3,4,'321');
insert into plsql_test_pl_t1 values(-2,3,4,'1111111111');
commit;

drop SEQUENCE if exists seq_test_1;
CREATE  SEQUENCE seq_test_1  INCREMENT BY 1 START WITH 1 MAXVALUE 10000000000 MINVALUE 1 NOCYCLE CACHE 20 ORDER;

create or replace procedure plsql_ztest_p2(f int)
as
c int;
begin
  select count(*) into c from plsql_test_pl_t1;
  dbe_output.print_line(c);
  dbe_output.print_line(f);
end plsql_ztest_p2;
/

exec plsql_ztest_p2(2);

create or replace procedure plsql_ztest_p3(f int)
as
c int;
begin
  select a into c from plsql_test_pl_t1 where a=-2;
  dbe_output.print_line(c);
  dbe_output.print_line(f);
end plsql_ztest_p3;
/

exec plsql_ztest_p3(3);

create or replace procedure plsql_ztest_p4(a int)
as
c int;
begin
  select seq_test_1.nextval into c from dual;
  dbe_output.print_line(c);
  dbe_output.print_line(a);
end plsql_ztest_p4;
/

exec plsql_ztest_p4(4);

drop table plsql_test_pl_t1;
drop SEQUENCE seq_test_1;
drop procedure plsql_ztest_p2;
drop procedure plsql_ztest_p3;
drop procedure plsql_ztest_p4;

drop procedure if exists Pro_ColumnOper;
CREATE PROCEDURE Pro_ColumnOper(TableName VARCHAR,ColumnName VARCHAR,CType INT,SqlStr VARCHAR)
AS
   Rows1 INT;
   SQL1 VARCHAR(4000);
BEGIN
Rows1 := 0;

IF (CType=1 AND Rows1<=0) THEN
	SqlStr := 'ALTER table ' || plsql_tableName || ' ADD COLUMN ' || ColumnName || ' ' || SqlStr;
ELSIF (CType=2 AND Rows1>0)  THEN
	SqlStr := '1';      
END IF;
dbe_output.print_line(SqlStr);
END;
/
call Pro_ColumnOper('test','check',1,'int default 0 not null');

-----call func() and column-list support expr-list
DROP table IF EXISTS storage_deadlock_tbl_001_1;
CREATE table storage_deadlock_tbl_001_1(i int);
insert into storage_deadlock_tbl_001_1 values(0);
DROP table IF EXISTS strg_wait_lk_range_tbl_001_1;
CREATE table strg_wait_lk_range_tbl_001_1(i int);
insert into strg_wait_lk_range_tbl_001_1 values(0);
DROP table IF EXISTS nebula_storage_tbl_000;
create table nebula_storage_tbl_000(c_id int,
c_d_id int NOT NULL,
c_w_id int NOT NULL,
c_first varchar(16) NOT NULL,
c_middle char(2),
c_last varchar(16) NOT NULL,
c_street_1 varchar(20) NOT NULL,
c_street_2 varchar(20),
c_city varchar(20) NOT NULL,
c_state char(2) NOT NULL,
c_zip char(9) NOT NULL,
c_phone char(16) NOT NULL,
c_since timestamp,
c_credit char(2) NOT NULL,
c_credit_lim numeric(12,2),
c_discount numeric(4,4),
c_balance numeric(12,2),
c_ytd_payment real NOT NULL,
c_payment_cnt number NOT NULL,
c_delivery_cnt bool NOT NULL,
c_end date NOT NULL,
c_vchar varchar(1000),
c_data clob,
c_text blob,
primary key (c_id,c_d_id,c_w_id));
select c_id from nebula_storage_tbl_000;

drop procedure if exists strg_wait_lk_range_proc_001;
create or replace procedure strg_wait_lk_range_proc_001(a int) is
  b int := 0;
begin
  while (a - b != 0) loop
  	select i into b from strg_wait_lk_range_tbl_001_1;
  	dbe_output.print_line(b);
  	a := a - 1;   	
  end loop;
end;
/
call strg_wait_lk_range_proc_001(1);
drop procedure if exists nebula_storage_func_000;
CREATE or replace procedure nebula_storage_func_000(startnum int,endall int)
as
i int :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from dual;    
    insert into nebula_storage_tbl_000 select i,i,i,'is'||j||'cmRDs'||j,'OE','BAR'||j||'Bar'||j,'bkili'||j||'fcrRGF'||j,'pmbwo'||j||'vhSDGj'||j,'dyf'||j||'rDa'||j,'uq','4801'||j,'940'||j||'215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,1,sysdate,lpad('QVLDETANRBRBURBMfhlhfrcllgfSMNTECC348493214893542NPFZCSfjlufvCDSF',650,'QVLDETANRBRBURBMfhlhfrcllgfSMNTECC348493214893542NPFZCSfjlufvCDSF')||j,lpad('QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF',630,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF')||j,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323' from dual;
  END LOOP;
END;
/
call nebula_storage_func_000(1,2);
select c_id from nebula_storage_tbl_000;

create user plsql_omcdb identified by Root1234;
create or replace procedure plsql_omcdb.proc_create_iad_index as
  strSQL varchar2(1000);
begin
  strSQL := 'create index idx_t1_c1 on t1(c1)';
  EXECUTE IMMEDIATE strSQL;
end plsql_omcdb.proc_create_iad_index;
/
drop procedure if exists plsql_omcdb.proc_create_iad_index;
drop user plsql_omcdb cascade;

declare
  v_int int;
begin
    select -2147483647.7898765 into v_int from dual;
   dbe_output.print_line('result: '||v_int);
end;
/

declare
  v_sysdate number(12,2);
begin
    select 123456.7898765 into v_sysdate from dual;
   dbe_output.print_line('result: '||v_sysdate);
end;
/

declare
  v_int int;
begin
    select -2147483647.7898765 into v_int from dual;
   dbe_output.print_line('result: '||v_int);
end;
/


declare
  v_int int;
begin
    select 2147483647.7898765 into v_int from dual;
   dbe_output.print_line('result: '||v_int);
end;
/

declare
  v_real real;
begin
    select 7.7898765+1 into v_real from dual;
   dbe_output.print_line('result: '||v_real);
end;
/

declare
  v_real real;
begin
    select 9223372036854775808.7898765 into v_real from dual;
   dbe_output.print_line('result: '||v_real);
end;
/

--BUG?? bigint overflow to minus
declare
   v_real real;
   v_bigint bigint;
begin
    v_real:=9223372036854775800.7898765;
    select v_real into v_bigint from dual;
   dbe_output.print_line('result: '||v_bigint);
end;
/

--BUG?? overflow
declare
   v_real real;
   v_number number(12,3);
begin
    v_real:=9.999999999999999999999999999999999e+127;
    select v_real into v_number from dual;
   dbe_output.print_line('result: '||v_number);
end;
/
delete from plsql_test;
begin
insert into plsql_test (a) values(1),(2),(3),(4);
end;
/
select * from plsql_test order by 1 desc;
drop table if exists plsql_test;
create table plsql_test (a varchar(100));
insert into plsql_test values('1');
select * from plsql_test;
declare
like_str varchar(120) := '1%';
begin
delete from plsql_test where a like like_str;
end;
/
select * from plsql_test;

drop table if exists t_casewhen;
create table t_casewhen(id int,year int,month int,day int);
insert into t_casewhen values (1,2018,6,30);
declare
    v_int int;
begin
    select (select case id when 1 then '1530331200' end from t_casewhen) into v_int from dual;
    dbe_output.print_line('result: '||v_int);
end;
/

drop procedure if exists plsql_test_p1;
create or replace procedure plsql_test_p1(a int, b varchar2)
as
c int := a;
d int := c;
begin
  dbe_output.print_line('a is ' || a || ',b is ' || b || ',c is ' || c || ',d is ' || d);
end;
/
call plsql_test_p1(1,'123');

create or replace procedure plsql_test_p1(a int := 3, b varchar2 := 'abcd')
as
c int := a;
d int := c;
begin
  dbe_output.print_line('a is ' || a || ',b is ' || b || ',c is ' || c || ',d is ' || d);
end;
/
call plsql_test_p1();
call plsql_test_p1(1);
call plsql_test_p1(2,'ccc');
call plsql_test_p1(b =>'ccc');

drop procedure if exists plsql_test_p1;
declare
a int := 1;
b int := a;
begin
  dbe_output.print_line('a is ' || a || ',b is ' || b);
end;
/

drop table if exists t_casewhen;
drop table if exists plsql_test;
DROP table IF EXISTS storage_deadlock_tbl_001_1;
DROP table IF EXISTS strg_wait_lk_range_tbl_001_1;
DROP table IF EXISTS nebula_storage_tbl_000;
drop SEQUENCE if exists seq_test_1;

select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;


--test use input argument as default value

create or replace procedure gs_plsql1.plsql_test_pl_proc1(a int)
as
c int := 2+1;
d int :=a;
begin
  c := a;
  
  dbe_output.print_line(d);
  dbe_output.print_line(c);
end;
/

exec gs_plsql1.plsql_test_pl_proc1(0);
exec gs_plsql1.plsql_test_pl_proc1(0);


--BEGIN: plsql_test create proc -> drop user -> create proc
CREATE USER plsql_ww identified by Cantian_234;
GRANT dba to plsql_ww;
CREATE table plsql_ww.T_TRIG_1 (F_INT1 INT, F_INT2 INT, F_CHAR1 CHAR(16), F_DATE DATE);
CREATE table plsql_ww.T_TRIG_2 (F_INT1 INT, F_INT2 INT, F_CHAR1 CHAR(16), F_DATE DATE);
CREATE OR REPLACE TRIGGER plsql_ww.TRIG_BEFORE_STMT BEFORE INSERT OR UPDATE OF F_INT1 OR DELETE ON plsql_ww.T_TRIG_1
BEGIN
  INSERT INTO plsql_ww.T_TRIG_2 VALUES(4,2,'A','2017-12-11 14:08:00');
END;
/

CREATE OR REPLACE PROCEDURE plsql_ww.p1(a int)
AS
x int;
BEGIN
	x := 10;
	a := a + x;
	dbe_output.print_line(a);
END;
/

DROP USER plsql_ww cascade;
CREATE USER plsql_ww identified by Cantian_234;
GRANT dba to plsql_ww;
CREATE table plsql_ww.T_TRIG_1 (F_INT1 INT, F_INT2 INT, F_CHAR1 CHAR(16), F_DATE DATE);
CREATE table plsql_ww.T_TRIG_2 (F_INT1 INT, F_INT2 INT, F_CHAR1 CHAR(16), F_DATE DATE);
CREATE OR REPLACE TRIGGER plsql_ww.TRIG_BEFORE_STMT BEFORE INSERT OR UPDATE OF F_INT1 OR DELETE ON plsql_ww.T_TRIG_1
BEGIN
  INSERT INTO plsql_ww.T_TRIG_2 VALUES(4,2,'A','2017-12-11 14:08:00');
END;
/

INSERT INTO plsql_ww.T_TRIG_1 VALUES(1,2,'A','2017-12-11 14:08:00');
INSERT INTO plsql_ww.T_TRIG_1 VALUES(3,4,'C','2017-12-12 16:08:00');
INSERT INTO plsql_ww.T_TRIG_1 VALUES(1,3,'A','2017-12-11 14:18:00');
INSERT INTO plsql_ww.T_TRIG_1 VALUES(2,3,'B','2017-12-11 16:08:00');
SELECT * FROM plsql_ww.T_TRIG_1 ORDER BY F_INT1,F_INT2,F_CHAR1,F_DATE;
SELECT * FROM plsql_ww.T_TRIG_2 ORDER BY F_INT1,F_INT2,F_CHAR1,F_DATE;

UPDATE plsql_ww.T_TRIG_1 SET F_INT1 = 10,F_CHAR1='TRIG' WHERE F_INT1 = 1;
SELECT * FROM plsql_ww.T_TRIG_1 ORDER BY F_INT1,F_INT2,F_CHAR1,F_DATE;
SELECT * FROM plsql_ww.T_TRIG_2 ORDER BY F_INT1,F_INT2,F_CHAR1,F_DATE;

DELETE FROM plsql_ww.T_TRIG_1 WHERE F_INT1 = 10;
SELECT * FROM plsql_ww.T_TRIG_1 ORDER BY F_INT1,F_INT2,F_CHAR1,F_DATE;
SELECT * FROM plsql_ww.T_TRIG_2 ORDER BY F_INT1,F_INT2,F_CHAR1,F_DATE;

UPDATE plsql_ww.T_TRIG_1 SET F_INT2 = 5;
SELECT * FROM plsql_ww.T_TRIG_1 ORDER BY F_INT1,F_INT2,F_CHAR1,F_DATE;
SELECT * FROM plsql_ww.T_TRIG_2 ORDER BY F_INT1,F_INT2,F_CHAR1,F_DATE;

COMMIT;

drop table if exists T_TRIG_1;
drop table if exists T_TRIG_2;

CREATE OR REPLACE PROCEDURE plsql_ww.p1(a int)
AS
x int;
BEGIN
	x := 10;
	a := a + x;
	dbe_output.print_line(a);
END;
/

begin
	plsql_ww.p1(1);
end;
/

--END: plsql_test create proc -> drop user -> create proc

declare 
    v_time varchar2(113) ;
	a int :=600;
begin
    begin
        select 'TIMETAG='  into v_time from dual where rownum <= 1;
    exception
        when no_data_found then                                                                                                                                                                         
            null;
        when others then
    			dbe_output.print_line(a||SQL_ERR_CODE||'==='||SQL_ERR_MSG);  
    end;
    dbe_output.print_line(a||v_time);
exception
    when no_data_found then                                                                                                                                                                         
        null;   
        when others then
    dbe_output.print_line(a||SQL_ERR_CODE||'******'||SQL_ERR_MSG);     
end;
/

--test for-loop DTS2018070301650
--begin
--expect compile success and run success
create or replace procedure bubble_sort
as
    v_order number;
begin
    v_order:=10;
    v_order:= v_order + 0.1;
    for i in v_order-5..v_order-1+0.5
    loop
        dbe_output.print_line(i);
    end loop;
end;
/

exec bubble_sort;

--expect compile success and run success
create or replace procedure bubble_sort
as
    v_order number;
begin
    v_order:=10;
    v_order:= v_order + 0.5;
    for i in v_order-5..v_order-1+0.5
    loop
        dbe_output.print_line(i);
    end loop;
end;
/

exec bubble_sort;

--expect compile success and run error
create or replace procedure bubble_sort
as
    v_order varchar2(10) := 'abc';
begin
    for i in v_order-5..v_order-1
    loop
        dbe_output.print_line(i);
    end loop;
end;
/

exec bubble_sort;
--end plsql_test for-loop DTS2018070301650

drop procedure if exists plsql_test_p1;
create or replace procedure plsql_test_p1(result_cur sys_refcursor)
	as
		strSQL varchar2(1000);
	begin
		strSQL := 'select * from t_not_exists order by f1, f2';
		dbe_output.print_line(strSQL);
		OPEN result_cur for strSQL;
	end plsql_test_p1;
/

--param only allowed in dml or anonymous block or call
drop procedure if exists plsql_test_p1;
create or replace procedure plsql_test_p1
as
	v_refcur SYS_REFCURSOR;   
	SWV_tbl_DeviceTab__var0 NUMBER(10,0);
begin
	select count(*) INTO SWV_tbl_DeviceTab__var0 from dual;   
	if SWV_tbl_DeviceTab__var0 <> :p1 
	then      
		open v_refcur for select 1 from dual;      
		dbe_output.return_result(v_refcur);      
		RETURN;   
	else      
		open v_refcur for select 0 from dual;      
		dbe_output.return_result(v_refcur);   
	end if;  
	
	RETURN;
end;
/

drop procedure if exists plsql_test_p1;
create or replace procedure plsql_test_p1
as
	v_refcur SYS_REFCURSOR;   
begin
	open v_refcur for select 1 from dual where 1=:p1;   
end;
/

drop procedure if exists plsql_test_p1;
create or replace procedure plsql_test_p1
as
	SWV_tbl_DeviceTab__var0 NUMBER(10,0);
begin
	select count(*) INTO SWV_tbl_DeviceTab__var0 from dual where 1=:p1;   
	RETURN;
end;
/

drop procedure if exists plsql_test_p1;
create or replace function plsql_test_p1(a int, b varchar2)
return int
as
c int;
begin
  c := :p1;
  return c;
end plsql_test_p1;
/

drop procedure if exists plsql_test_p1;
create or replace function plsql_test_p1(a int, b varchar2)
return int
as
c int;
begin
  c := a;
  select 1 into c from dual where 1=:p1;
  return c;
end plsql_test_p1;
/

CREATE OR REPLACE TRIGGER plsql_ww.TRIG_BEFORE_STMT BEFORE INSERT OR UPDATE OF F_INT1 OR DELETE ON plsql_ww.T_TRIG_1
BEGIN
  INSERT INTO plsql_ww.T_TRIG_2 VALUES(4,2,'A',:p1);
END;
/
DROP USER plsql_ww cascade;
--test create procedure with quotes
--add 2018/7/9
--begin
--expect error
CREATE OR REPLACE PROCEDURE "Zenith_Test_001"
AS
Begin
    dbe_output.print_line('Hello Zenith');
end Zenith_Test_001;
/

--expect error
CREATE OR REPLACE PROCEDURE gs_plsql1."Zenith_Test_001"
AS
Begin
    dbe_output.print_line('Hello Zenith');
end gs_plsql1."ZENITH_TEST_001";
/

--expect error
CREATE OR REPLACE PROCEDURE "Zenith_Test_001"
AS
Begin
    dbe_output.print_line('Hello Zenith');
end "ZENITH_TEST_001";
/
--expect success
CREATE OR REPLACE PROCEDURE gs_plsql1."Zenith_Test_001"
AS
Begin
    dbe_output.print_line('Hello Zenith');
end "Zenith_Test_001";
/

--expect success
CREATE OR REPLACE PROCEDURE gs_plsql1."ZENITH_TEST_001"
AS
Begin
    dbe_output.print_line('Hello Zenith');
end "ZENITH_TEST_001";
/

CREATE OR REPLACE PROCEDURE "ZENITH_TEST_001"
AS
Begin
    dbe_output.print_line('Hello Zenith');
end "ZENITH_TEST_001";
/
--expect success
CREATE OR REPLACE PROCEDURE "Zenith_Test_001"
AS
Begin
    dbe_output.print_line('Hello Zenith');
end;
/

--expect success
CREATE OR REPLACE PROCEDURE "Zenith_Test_002"(a number)
AS
Begin
    dbe_output.print_line('Hello Zenith'||a);
end "Zenith_Test_002";
/

--expect error
CREATE OR REPLACE PROCEDURE 'Zenith_Test_001'
AS
Begin
    dbe_output.print_line('Hello Zenith');
end;
/

exec Zenith_Test_001;
exec "Zenith_Test_001";
exec gs_plsql1."Zenith_Test_001";
exec "Zenith_Test_002"(1);
exec Zenith_Test_002(1);

drop procedure Zenith_Test_001;
drop procedure "Zenith_Test_001";
drop procedure "Zenith_Test_002";
drop procedure gs_plsql1."ZENITH_TEST_001";
drop PROCEDURE gs_plsql1."Zenith_Test_001";

--end plsql_test create procedure with quotes
drop table if exists plsql_emp_test;
create table plsql_emp_test(empno number,ename varchar2(100),job varchar2(100), sal number);
insert into plsql_emp_test values(1,'wanghaifeng','doctor1',10000);

CREATE OR REPLACE PROCEDURE syscur(sys_cur OUT SYS_REFCURSOR) 
IS 
C1 SYS_REFCURSOR; 
BEGIN 
OPEN C1 FOR
    SELECT empno,ename FROM plsql_emp_test  where empno=1 ORDER BY empno; 
sys_cur := C1; 
END; 
/

DECLARE
  cv SYS_REFCURSOR;
  v_sal   plsql_emp_test.sal%type;
  v_sal_mul     plsql_emp_test.sal%type;
  factor   integer :=2;
BEGIN
    open cv for
          select sal,sal*factor from plsql_emp_test where job like '%1' and sal < 13000 order by sal;
    loop
    fetch cv into v_sal,v_sal_mul;
    exit when cv%notfound;
    dbe_output.print_line('factor ='||factor||';');
    dbe_output.print_line('sal ='||v_sal||';');
    dbe_output.print_line('sal_mul ='||v_sal_mul||';');
    factor :=factor+1;

  END LOOP;
  close cv;
end;
/
--test the max length of char and varchar is 32767
--2018/7/13
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
--expect error
declare
v_type1 varchar2(32768);
begin
v_type1 := 'staticbool32plccompiletriggervariant1plcompiler';
  dbe_output.print_line(v_type1);
end;
/ 

--expect error
declare
v_type1 char(32767);
begin
v_type1 := 'staticbool32plccompiletriggervariant1plcompiler';
  dbe_output.print_line(v_type1);
end;
/ 

--expect success
declare
v_type1 varchar2(32767);
begin
v_type1 := 'staticbool32plccompiletriggervariant1plcompiler';
  dbe_output.print_line(v_type1);
end;
/ 

--expect success
declare
v_type1 varchar2(32767);
v_type2 varchar2(32767);
begin
v_type1 := 'stat';
v_type2 := v_type1 || 'sta';
  dbe_output.print_line(substr(v_type2, 1,2));
end;
/ 

--expect success
declare
v_type1 varchar2(32767);
v_type2 varchar2(32767);
begin
v_type1 := 'staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CM
SNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canon
lyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACH
ROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclchar
param[GSNA';
v_type2 := v_type1 || 'staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CM
SNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canon
lyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACH
ROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclchar
param[GSNA';
  dbe_output.print_line(substr(v_type2, 1,20));
end;
/ 

--expect error
declare
a varchar2(32766);
b integer;
begin
a := '123454545423542525525325435354325433535254325435432543535553552354352552';
select cast(a as integer) into b from dual;
  dbe_output.print_line(b-3);
end;
/ 

--expect error
declare
a varchar2(32767);
b integer;
begin
a := '123a';
select cast(a as integer) into b from dual;
  dbe_output.print_line(b-3);
end;
/ 

--expect success: convert bigvarchar to bigint
declare
a varchar2(32766);
b integer;
c real;
d decimal;
e date;
f datetime;
g number(20,3);
begin
a := '12345';
select cast(a as bigint) into b from dual;
a := '1231233413.123';
select cast(a as real) into c from dual;
a := '1231233413.123123213E100';
select cast(a as decimal) into d from dual;
a := '2017-08-11';
select to_date(a, 'YYYY-MM-DD') into e from dual;
a := '2017-08-11 23:11:20';
select to_date(a, 'YYYY-MM-DD HH24:MI:SS') into f from dual;

  dbe_output.print_line(b-3);
  dbe_output.print_line(c);
  dbe_output.print_line(d);
  dbe_output.print_line(e);
  dbe_output.print_line(f);
end;
/ 

--expect success
declare
a varchar2(32766);
b integer;
c varchar2(5);
begin
a := '12345';
c := '12345';
if a=c then
  dbe_output.print_line(a);
  end if;
end;
/ 

--expect success
declare
a varchar2(32766);
b integer;
c varchar2(5);
begin
a := '12345';
c := a;
  dbe_output.print_line(c);
end;
/ 

--expect success
--result is :1234512345600
declare
a varchar2(32766);
b integer;
c varchar2(5);
begin
a := '12345';
c := a;
b := 00600;
  dbe_output.print_line(c||a||b);
end;
/ 

create table plsql_test_varchar32k
(
a varchar2(32767)
);

--expect success
declare
v_type1 varchar2(32767);
v_type2 varchar2(32767);
v_type3 varchar2(32767);
a  integer;
begin
v_type1 := 'staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CM
SNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canon
lyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACH
ROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclchar
param[GSNA';
v_type2 := v_type1 || 'staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CM
SNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canon
lyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACH
ROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclchar
param[GSNA';
  dbe_output.print_line(substr(v_type2, 1,20));
  v_type3 := 'select count(*) from dual';
  execute immediate v_type3 into a;
  dbe_output.print_line(a);
end;
/ 

--expect success
drop table if exists plsql_tab_1023_col;
declare
    v_sql varchar2(32767);
begin
    v_sql:='create table plsql_tab_1023_col(';
 for i in 1..999
 loop
     v_sql:=v_sql||'col_'||to_char(i)||' int,';
 end loop;
 v_sql:=v_sql||'col_1000 int)';
 execute immediate v_sql;
end;
/

--expect success, string length is 16384
declare
v_type1 varchar2(32767);
a  integer;
begin
v_type1 := 'staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1
CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111ne
w1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharpara
m[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFORE
EACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1dec
l111void1CMSNPRINTFS1paramSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32p
lccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAstaticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcom
pilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111proctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111proctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111proctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111TRIGBEFOREEA
CHROW111PLCE';
  dbe_output.print_line(substr(v_type1, 1,20));
end;
/ 

--expect success, string length is 16385
declare
v_type1 varchar2(32767);
a  integer;
begin
v_type1 := 'staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1
CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111ne
w1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharpara
m[GSNAMEBUFFERSIZE]=101if1CMPLCONEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFORE
EACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1dec
l111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32p
lccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAstaticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcom
pilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111proctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111proctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111proctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111TRIGBEFOREEA
CHROW111PLCEa';
  dbe_output.print_line(substr(v_type1, 1,20));
end;
/


--expect success, string length is 16384
declare
v_type1 varchar2(32767) := 'staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1
CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111ne
w1or11old1canonlyappearinrowtriggr11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharpara
m[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFORE
EACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1dec
l111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32p
lccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAstaticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcom
pilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111proctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111proctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111proctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111TRIGBEFOREEA
CHROW111PLCE';
a  integer;
begin
  dbe_output.print_line(substr(v_type1, 1,20));
end;
/ 

--expect error, string length is 16385
declare
v_type1 varchar2(32767):= 'staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1
CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111ne
w1or11old1canonlyappearinrowtrigger1returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharpara
m[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFORE
EACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1dec
l111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32p
lccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAstaticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcom
pilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111new1or11old1canonlyappearinrowtrigger11returnGSFALSE1PLCCALL1plcgettriggerdecl1compiler0wordPLVVAR1decl111void1CMSNPRINTFS1paramGSNAMEBUFFERSIZEGSNAMEBUFFERSIZE111d1d1declvidblockdeclvidid1cmconcatstr1sqlparam1returnGSTRUE1staticbool32plccompiletriggervariant1plcompilertcompilertexttsqlwordtword11plvdecltdeclcharparam[GSNAMEBUFFERSIZE]=101if1CMPLCONTEXTtype=SQLTYPECREATETRIG1compilerproctrigtype=TRIGAFTEREACHROW11compilerproctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111proctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111proctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111proctrigtype=TRIGBEFOREEACHROW111PLCERROR1wordlocERRPLSYNTAXERROR111TRIGBEFOREEA
CHROW111PLCEa';
a  integer;
begin
  dbe_output.print_line(substr(v_type1, 1,20));
end;
/


select count(*) from plsql_tab_1023_col;
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
--end plsql_test the max length of char and varchar is 32767

DECLARE
  cv SYS_REFCURSOR;
  v_empno  plsql_emp_test.empno%TYPE;
  v_ename     plsql_emp_test.ename%TYPE;
  v_sal    plsql_emp_test.sal%TYPE;
  query_2 VARCHAR2(200) :=
    'select * from plsql_emp_test order by 1,2,3';
  v_emp_test plsql_emp_test%ROWTYPE;
BEGIN
  syscur(cv);
  LOOP
    FETCH cv INTO v_empno, v_ename;
    EXIT WHEN cv%NOTFOUND;
    -- dbe_output.print_line('v_empno is :'||v_empno||'---->'||'v_ename is :'||v_ename);
	dbe_output.print_line(rpad(v_empno,25,' ')||v_ename);
  END LOOP;
 
  dbe_output.print_line( '-------------------------------------' );
  CLOSE cv;
END;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
drop table if exists plsql_emp_test;
drop procedure if exists syscur;


--test:in parameter can not use as left assiagnment target
--add 2018/07/17
--begin
--expect error
CREATE OR REPLACE PROCEDURE plsql_test_in_para (
  t_column char,
  t_name   VARCHAR2
) 
IS
  temp VARCHAR2(30);
BEGIN
	t_column := t_column ||'--';
	dbe_output.print_line(t_column||t_name);
 
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    dbe_output.print_line ('No Data found for SELECT on ');
  WHEN OTHERS THEN
    dbe_output.print_line ('Unexpected error');
    RAISE;
END;
/

--expect success
CREATE OR REPLACE PROCEDURE plsql_test_in_para (
  t_column in char,
  t_name  in out VARCHAR2,
  result out varchar2
) 
IS
  temp VARCHAR2(30);
BEGIN
	t_name := t_name ||t_column ||'--';
	result := t_name;
	dbe_output.print_line(t_column||t_name);
 
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    dbe_output.print_line ('No Data found for SELECT on ');
  WHEN OTHERS THEN
    dbe_output.print_line ('Unexpected error');
    RAISE;
END;
/

DECLARE
  a    varchar2(20):='aaa';
  b    varchar2(20):='bbb';
  c    varchar2(20);
BEGIN
  plsql_test_in_para(a, b, c);
  dbe_output.print_line( 'a:'||a||'  b:'||b||'   c:'||c );
END;
/
--end plsql_test:in parameter can not use as left assiagnment target

--test cursor open and deal with the eof:DTS2018071706609
--add 2018/07/18
--begin
drop table if exists pl_emp;
create table pl_emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into pl_emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
insert into pl_emp values(1,'zhansi','doctor1',10000),(2,'lisiabc','doctor2',10000),(123,'zhangwu123','doctor3',10000);
insert into pl_emp values(10,'abc','worker',9000);
insert into pl_emp values(716,'ZHANGSAN','leader',20000);
insert into pl_emp values(715,'SYS','leader',20001);
commit;

--expect print 'sys' user info.
conn sys/Huawei@123@127.0.0.1:1611
grant select on sys.SYS_USERS to gs_plsql;
conn gs_plsql/Whf00174302@127.0.0.1:1611
declare
cursor mycursor is (select * from pl_emp,sys.SYS_USERS where pl_emp.ename=sys.SYS_USERS.NAME and pl_emp.ename like '%S%' and pl_emp.sal > 9000 order by empno);
begin
for a in mycursor
loop
dbe_output.print_line('a is emp:'||a.ENAME||'SYS_USERS name is: '||a.name);
dbe_output.print_line(mycursor%rowcount);
end loop;
end;
/
--end

drop table if exists plsql_test;
create table plsql_test(a int, b int);
declare
type tcur is ref cursor;
cursor_k tcur;
rec plsql_test%rowtype;
begin
open cursor_k for (select * from plsql_test);
fetch cursor_k into rec;
close cursor_k;
end;
/

declare
type tcur is ref cursor return plsql_test%rowtype;
cursor_k tcur;
rec plsql_test%rowtype;
begin
open cursor_k for select * from plsql_test;
fetch cursor_k into rec;
close cursor_k;
end;
/
drop table if exists plsql_emp;
create table plsql_emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
insert into plsql_emp values(1,'zhansi','doctor1',10000),(2,'lisiabc','doctor2',10000),(123,'zhangwu123','doctor3',10000);
insert into plsql_emp values(10,'abc','worker',9000);
insert into plsql_emp values(716,'ZHANGSAN','leader',20000);
commit;
declare
cursor mycursor is select * from plsql_emp where empno != 123 and sal=10000;
begin
close mycursor;
end;
/

create or  replace procedure procedure2(a int) is
cursor mycursor is select * from plsql_emp where empno != 123 and sal=10000;
b plsql_emp%rowtype;
mysyscur  sys_refcursor;
strSQL1 varchar(1000);
strSQL2 varchar(1000);
begin
strSQL1 := 'select * from plsql_emp  where  sal <> 10000';
strSQL2 := '';
 if a <= 10 then
   for i in mycursor
   loop
    dbe_output.print_line(i.ename||' is not 10000');
   end loop;
 elsif a >10  then
  open mysyscur for  strSQL1;
  fetch mysyscur into  b; 
  dbe_output.print_line(b.ename||' a > 10 and a < 100');
  close mycursor;
 else
  open mysyscur for strSQL2;
  dbe_output.print_line('else a > 10 and a < 100');
 end if;
 exception
   when others then
   dbe_output.print_line('close mysyscur');
   close mysyscur;   
end;
/
call procedure2(10);
exec procedure2(11);
declare
type vll is record(
s char(13),
b int);
ab vll.s%type;
begin
 ab := '10';
dbe_output.print_line(ab || 'xx');
 end;
/

declare
type vll is record(
s char(13),
b int);
ab vll%rowtype;
begin
 ab := '10';
dbe_output.print_line(ab || 'xx');
 end;
/

drop table plsql_emp;
create table plsql_emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
insert into plsql_emp values(1,'zhansi','doctor1',10000),(2,'lisiabc','doctor2',10000),(123,'zhangwu123','doctor3',10000);
insert into plsql_emp values(10,'abc','worker',9000);
insert into plsql_emp values(716,'ZHANGSAN','leader',20000);
commit;
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
declare
cursor mycursor  is select * from plsql_emp where  ename like '%ZHANGSAN%' and sal > 9000 ;
c mycursor%rowtype;
begin
for a  in  mycursor
loop
open mycursor;
--fetch mycursor into c;
dbe_output.print_line('a is emp:'||c.ENAME||'SYS_USERS name is: '||c.job);
dbe_output.print_line(mycursor%rowcount);
--close mycursor;
end loop;
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
declare
cursor mycursor  is select * from plsql_emp where  ename like '%ZHANGSAN%' and sal > 9000 ;
c mycursor%rowtype;
begin
for a  in  mycursor
loop
--open mycursor;
--fetch mycursor into c;
dbe_output.print_line('a is emp:'||c.ENAME||'SYS_USERS name is: '||c.job);
dbe_output.print_line(mycursor%rowcount);
close mycursor;
end loop;
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
declare
cursor mycursor  is select * from plsql_emp where  ename like '%ZHANGSAN%' and sal > 9000 ;
c mycursor%rowtype;
begin
for a  in  mycursor
loop
fetch mycursor into c;
dbe_output.print_line('a is emp:'||c.ENAME||'SYS_USERS name is: '||c.job);
dbe_output.print_line(mycursor%rowcount);
end loop;
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
drop table if exists plsql_emp;
create table plsql_emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
insert into plsql_emp values(1,'zhansi','doctor1',10000),(2,'lisiabc','doctor2',10000),(123,'zhangwu123','doctor3',10000);
insert into plsql_emp values(10,'abc','worker',9000);
declare
cursor mycursor  is select sum(sal) he from plsql_emp where ename like '%zhangsan%' and sal > 9000 ;
begin
for a  in  mycursor
loop
dbe_output.print_line('a is emp:'||a.he);
dbe_output.print_line(mycursor%rowcount);
end loop;
end;
/
declare
cursor mycursor  is select ename||' '||job as ejob ,sal*10 as exp_sal from plsql_emp order by ename DESC,exp_sal asc;
begin
for a  in  mycursor
loop
dbe_output.print_line('a is ejob:'||a.ejob||'exp_sal:'||a.exp_sal);
dbe_output.print_line(mycursor%rowcount);
end loop;
end;
/
drop table if exists plsql_emp;

--test unsupport column size at parameter
--add 2018/07/19
--begin
--expect error
CREATE OR REPLACE PROCEDURE plsql_select_item (
  t_column in CHAR(10),
  t_name   in VARCHAR2(10)
) 
IS
  temp1 VARCHAR2(10);
BEGIN
  temp1 := t_column; 
    dbe_output.print_line ('No Data found for SELECT on ' || temp1);
END;
/

CREATE OR REPLACE PROCEDURE plsql_select_item (
  t_column in CHAR,
  t_name   in VARCHAR2,
  t_num    in number(10),
  t_dec    in decimal(10,5)
) 
IS
  temp1 VARCHAR2(10);
BEGIN
  temp1 := t_column; 
    dbe_output.print_line ('No Data found for SELECT on ' || temp1);
END;
/

CREATE OR REPLACE PROCEDURE plsql_select_item (
  t_column in CHAR,
  t_name   in VARCHAR2,
  t_num    in number,
  t_dec    in decimal,
  t_bin    in binary(100),
  t_vbin   in varbinary(100)
) 
IS
  temp1 VARCHAR2(10);
  temp2 binary(100);
  temp3 varbinary(100);
BEGIN
  temp1 := t_column; 
    dbe_output.print_line ('No Data found for SELECT on ' || temp1);
END;
/

CREATE OR REPLACE PROCEDURE plsql_select_item (
  t_column in interval,
  t_name   in VARCHAR2
) 
IS
  temp1 VARCHAR2(10);
BEGIN
  temp1 := t_column; 
    dbe_output.print_line ('No Data found for SELECT on ' || temp1);
END;
/

CREATE OR REPLACE PROCEDURE plsql_select_item (
  t_column in interval year,
  t_name   in VARCHAR2
) 
IS
  temp1 VARCHAR2(10);
BEGIN
  temp1 := t_column; 
    dbe_output.print_line ('No Data found for SELECT on ' || temp1);
END;
/


CREATE OR REPLACE PROCEDURE plsql_select_item (
  t_column in interval day to second(2),
  t_name   in VARCHAR2
) 
IS
  temp1 VARCHAR2(10);
BEGIN
  temp1 := t_column; 
    dbe_output.print_line ('No Data found for SELECT on ' || temp1);
END;
/

CREATE OR REPLACE PROCEDURE plsql_select_item (
  t_column in timestamp(2),
  t_name   in VARCHAR2
) 
IS
  temp1 VARCHAR2(10);
BEGIN
  temp1 := t_column; 
    dbe_output.print_line ('No Data found for SELECT on ' || temp1);
END;
/

CREATE OR REPLACE PROCEDURE plsql_select_item (
  t_column in timestamp with time,
  t_name   in VARCHAR2
) 
IS
  temp1 VARCHAR2(10);
BEGIN
  temp1 := t_column; 
    dbe_output.print_line ('No Data found for SELECT on ' || temp1);
END;
/

--expect success
CREATE OR REPLACE PROCEDURE plsql_select_item (
  t_column in timestamp with time zone,
  t_name   in VARCHAR2
) 
IS
  temp1 VARCHAR2(10);
BEGIN
  temp1 := t_column; 
    dbe_output.print_line ('No Data found for SELECT on ' || temp1);
END;
/

CREATE OR REPLACE PROCEDURE plsql_select_item (
  t_column in clob,
  t_name   in VARCHAR2
) 
IS
  temp1 VARCHAR2(100);
BEGIN
  temp1 := t_column; 
    dbe_output.print_line ('No Data found for SELECT on ' || temp1);
END;
/

exec plsql_select_item(null, null);

-- TODO
exec plsql_select_item('WHF nihao!', null);


CREATE OR REPLACE PROCEDURE plsql_select_item (
  t_column in int signed,
  t_name   in VARCHAR2
) 
IS
  temp1 VARCHAR2(10);
BEGIN
  temp1 := t_column; 
    dbe_output.print_line ('No Data found for SELECT on ' || temp1);
END;
/

exec plsql_select_item('200.512', null);

CREATE OR REPLACE PROCEDURE plsql_select_item (
  t_column in CHAR,
  t_name   in VARCHAR2,
  t_num    in number,
  t_dec    in decimal,
  t_bin    in binary
) 
IS
  temp1 VARCHAR2(20);
  temp2 binary(100);
  temp3 varbinary(100);
BEGIN
	temp1 := t_column; 
	dbe_output.print_line ('data:' || temp1||'-');
	dbe_output.print_line ('data:' || t_column||'-');
	dbe_output.print_line ('data:' || t_name||'-');
	dbe_output.print_line ('data:' || t_num||'-');
	dbe_output.print_line ('data:' || t_dec||'-');
	dbe_output.print_line ('data:' || t_bin||'-');
END;
/
exec plsql_select_item('abc','111111111111',1.32452, 0.333,hex2bin('0x112233'));


--expect error
declare
  v_ename varchar2;
  n_value int;
begin
  n_value := 1;
     DBE_STATS.PURGE_STATS(sysdate);  
end;
/

--expect error:DTS2018071601849
drop table if exists plsql_emp;
create table plsql_emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
insert into plsql_emp values(1,'zhansi','doctor1',10000),(2,'lisiabc','doctor2',10000),(123,'zhangwu123','doctor3',10000);
commit;

declare
cursor mycursor(job_real varchar2 default 'doctor1',max_sal number default 9000) is  select ename from plsql_emp where job=job_real and sal> max_sal  order by sal;
c_empno varchar2(20);
a1 varchar2(20);
b1 number;
begin
a1 := 'doctor1';
b1 := 2000;
open mycursor(a1,b1);
fetch mycursor into c_empno;
dbe_output.print_line('doctor2 c_empno is emp:'||c_empno);
dbe_output.print_line(mycursor%rowcount);
a1 := 'doctor2';
b1 := 2100;
fetch mycursor into c_empno;
dbe_output.print_line('doctor2 c_empno is emp:'||c_empno);
dbe_output.print_line(mycursor%rowcount);
close mycursor;
open mycursor(a1,b1);
fetch mycursor into c_empno;
dbe_output.print_line('doctor2 c_empno is emp:'||c_empno);
dbe_output.print_line(mycursor%rowcount);
close mycursor;
end;
/

declare
cursor mycursor(job_real varchar2 default 'doctor1',max_sal number default 9000) is  select ename from plsql_emp where job=job_real and sal> max_sal  order by sal;
c_empno varchar2;
begin
open mycursor;
fetch mycursor into c_empno;
if  mycursor%found  then 
dbe_output.print_line('c_empno is emp:'||c_empno);
dbe_output.print_line(mycursor%rowcount);
end if;
close mycursor;
open mycursor('doctor2',8000);
fetch mycursor into c_empno;
dbe_output.print_line('doctor2 c_empno is emp:'||c_empno);
dbe_output.print_line(mycursor%rowcount);
close mycursor;
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
declare
   cursor cv(v_empno int,v_job varchar2) is select * from plsql_emp where empno=v_empno and job =v_job;
BEGIN
        for i in cv(1,'doctor1')
        loop
        dbe_output.print_line('ename ='||i.ename);
        end loop;
end;
/

create or replace function syscur_028(v_num int) return sys_refcursor
is
        cv1 SYS_REFCURSOR;
        v_empno NUMBER(10,0);
begin
        select count(*) INTO v_empno from plsql_emp;
        if v_empno <> v_num then
                open cv1 for select 1 from dual;
        else
                open cv1 for select 0 from dual;
        end if;
        RETURN cv1;
end;
/
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
declare
cv sys_refcursor;
v_empno plsql_emp.empno%type;
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
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;

create user plsql_nebula identified by Cantian_234;
create table plsql_nebula.plsql_syscur_026(c_since timestamp,c_end date);
insert into plsql_nebula.plsql_syscur_026 values(to_timestamp('2018-07-17 18:57:42.00','yyyy-mm-dd hh24:mi:ss.ff3'),to_date('2018-07-17 18:57:42','yyyy-mm-dd hh24:mi:ss'));
insert into plsql_nebula.plsql_syscur_026 values(to_timestamp('2018-07-16 18:57:42.00','yyyy-mm-dd hh24:mi:ss.ff3'),to_date('2018-07-16 18:57:42','yyyy-mm-dd hh24:mi:ss'));
commit;

declare
cv sys_refcursor;
--since   timestamp;
--ccend   date;
since plsql_nebula.plsql_syscur_026.c_since%type;
ccend plsql_nebula.plsql_syscur_026.c_since%type;
c_syscur_026 plsql_nebula.plsql_syscur_026%rowtype;
begin
open cv for select distinct c_since,c_end from plsql_nebula.plsql_syscur_026 group by c_since,c_end order by 1,2;
loop
fetch cv into since,ccend;
exit when cv%notfound;
dbe_output.print_line('since_timestamp is ' || since||'---->'||'date_end is '|| ccend);
end loop;
close cv;
open cv for select * from plsql_nebula.plsql_syscur_026 order by c_since,c_end;
loop
fetch cv into c_syscur_026;
exit when cv%notfound;
dbe_output.print_line('c_syscur_since_timestamp is ' || c_syscur_026.c_since||'---->'||'c_syscur_date_end is '|| c_syscur_026.c_end);
end loop;
close cv;
end;
/

DECLARE
   v_emp_test     plsql_emp%ROWTYPE;
   cursor cv is SELECT * FROM plsql_emp where empno=1 for update;
   BEGIN
   OPEN cv;
   FETCH cv INTO v_emp_test;
   while cv%FOUND LOOP
       update plsql_emp set sal=sal+1000 where current of cv;
       dbe_output.print_line(rpad(v_emp_test.empno,15,' ')||rpad(v_emp_test.ename,15,' ')||v_emp_test.sal);
       FETCH cv INTO v_emp_test;       
   END LOOP;   
   dbe_output.print_line( '-------------------------------------' );
   CLOSE cv;
END;
/

DECLARE
   v_emp_test     plsql_emp%ROWTYPE;
   cursor cv is SELECT * FROM plsql_emp where empno=1 for update;
   BEGIN
   OPEN cv;
   FETCH cv INTO v_emp_test;
   while cv%FOUND LOOP
       delete from plsql_emp where current of cv;
       dbe_output.print_line(rpad(v_emp_test.empno,15,' ')||rpad(v_emp_test.ename,15,' ')||v_emp_test.sal);
       FETCH cv INTO v_emp_test;       
   END LOOP;   
   dbe_output.print_line( '-------------------------------------' );
   CLOSE cv;
END;
/

DECLARE
   v_emp_test     plsql_emp%ROWTYPE;
   cursor cv is SELECT * FROM plsql_emp where empno=1 for update;
   BEGIN
   --OPEN cv;
   --FETCH cv INTO v_emp_test;
   --while cv%FOUND LOOP
       update plsql_emp set sal=sal+1000 where current of cv;
       dbe_output.print_line(rpad(v_emp_test.empno,15,' ')||rpad(v_emp_test.ename,15,' ')||v_emp_test.sal);
       --FETCH cv INTO v_emp_test;       
   --END LOOP;   
   dbe_output.print_line( '-------------------------------------' );
   CLOSE cv;
END;
/


DECLARE
   v_emp_test     plsql_emp%ROWTYPE;
   cursor cv is SELECT * FROM plsql_emp where empno=1 for update;
   BEGIN
   OPEN cv;
   --FETCH cv INTO v_emp_test;
   --while cv%FOUND LOOP
       update plsql_emp set sal=sal+1000 where current of cv;
       dbe_output.print_line(rpad(v_emp_test.empno,15,' ')||rpad(v_emp_test.ename,15,' ')||v_emp_test.sal);
       --FETCH cv INTO v_emp_test;       
   --END LOOP;   
   dbe_output.print_line( '-------------------------------------' );
   CLOSE cv;
exception
   when others then
   close cv;
END;
/

drop table if exists plsql_nebula.plsql_syscur_026;
drop user plsql_nebula cascade;
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
--end

--TEST: exit in procedure
create or replace procedure P_TEST_RETURN_EXIT is
i number:=1;
j number:=1;
begin

for i in 1..20 loop

dbe_output.print_line('output='||i);
if (i>10) then 
EXIT;
end if;

end loop;

for j in 1..20 loop

dbe_output.print_line('output='||j);
end loop;


end P_TEST_RETURN_EXIT;
/

exec P_TEST_RETURN_EXIT;

create or replace procedure P_TEST_RETURN_EXIT is

i number:=1;
j number:=1;
begin

for i in 1..20 loop
dbe_output.print_line('output='||i);
if (i>10) then 
RETURN;
end if;
end loop;

for j in 1..20 loop
dbe_output.print_line('output='||j);
end loop;

end P_TEST_RETURN_EXIT;
/

exec P_TEST_RETURN_EXIT;

--test return
declare 
    v_time varchar2(113) ;
    a      int := 1;
begin
    begin
        select 'TIMETAG=' into v_time from dual where rownum <= 1;
        a := a/0;
    exception
        when no_data_found then                                                                                                                                                                         
            null;
    when others then
	    dbe_output.print_line('will return immediate');
            return;
    end;
    dbe_output.print_line(v_time);
    dbe_output.print_line('**********');
    a := a/0;
exception
    when no_data_found then                                                                                                                                                                         
        null;   
        when others then
    dbe_output.print_line(a||SQL_ERR_CODE||'******'||SQL_ERR_MSG);     
end;
/

--test recursive block
declare 
    v_time varchar2(113) ;
    a      int := 1;
    
begin
    a := 9;
    v_time := 'aaaa';
    begin
        a := 10;
        v_time := v_time||'bbbb';
        a := a/0;
    exception
        when no_data_found then                                                                                                                                                                         
            null;
    end;
    dbe_output.print_line(a);
    dbe_output.print_line('****************');
    a := a/0;
exception
    when no_data_found then                                                                                                                                                                         
        null;   
        when others then
    dbe_output.print_line(SQL_ERR_CODE||'******'||SQL_ERR_MSG||'---'||a);     
    dbe_output.print_line(SQL_ERR_CODE||'******'||SQL_ERR_MSG||'---'||v_time);  
end;
/

--end plsql_test: exit in procedure

--test exit in for-loop
create or replace procedure P_TEST_RETURN_EXIT is

i number:=1;
j number:=2;
begin

for i in 1..5 loop

dbe_output.print_line('output i='||i);
if (i>3) then
EXIT;
end if;

end loop;

for j in 1..5 loop

dbe_output.print_line('output j='||j);
end loop;

end P_TEST_RETURN_EXIT;
/

--expect 1,2,3,4,1,2,3,4,5
exec P_TEST_RETURN_EXIT;

--test exit in loop
--expect 1
DECLARE
x number;
BEGIN
x:=0;
LOOP
x:=x+1;

EXIT WHEN x<3;
dbe_output.print_line('inner:x='||x);
END LOOP;
dbe_output.print_line('outer:x='||x);
END;
/

--test exit in while
--expect 1,2,2,3,4,5,6
DECLARE
x number;
BEGIN
x:=0;
WHILE x<3 LOOP
x:=x+1;
dbe_output.print_line('inner:x='||x);
EXIT WHEN x=2;
END LOOP;
dbe_output.print_line('outer:x='||x);
WHILE x<6 LOOP
x:=x+1;
dbe_output.print_line('inner:x='||x);
END LOOP;
END;
/

--empty body
begin
end;
/

begin
null;
begin
end;
end;
/

begin
  loop
  end loop;
end;
/

begin
  for i in 0..1 loop  
  end loop;
end;
/

begin
  while true loop  
  end loop;
end;
/

drop table if exists plsql_test;
drop table if exists t2;
create table plsql_test(f_int1 int, f_varchar1 varchar(10));
insert into plsql_test values(1,'value1');
insert into plsql_test values(2,'value2');
insert into plsql_test values(1,'value1_1');
insert into plsql_test values(4,'value4');
insert into plsql_test values(5,'value5');
create table t2(f_int1 int, f_varchar1 varchar(20));

declare
cursor cv(v_empno int) is select f_int1, f_varchar1 from plsql_test where f_int1=v_empno;
begin
for i in cv(1)
loop
dbe_output.print_line(i.f_int1 || ',' || i.f_varchar1);
insert into t2(f_int1, f_varchar1) values(i.f_int1,i.f_varchar1);
end loop;
end;
/
drop table if exists plsql_test;
drop table if exists t2;

-----------------
--begin
--drop table if exists plsql_tab_1023_col;
--create table plsql_tab_1023_col(col_1 int);
--declare
--    v_sql varchar2(100);
--begin
--	for i in 2..1023
--	loop
--	    v_sql:='alter table plsql_tab_1023_col add column col_'||to_char(i)||' int';
--		execute immediate v_sql;
--	end loop;
--end;
--/
--
--insert into plsql_tab_1023_col(col_1,col_128,col_256,col_512,col_768,col_1023) values (1,128,256,512,768,1023);
--
--CREATE OR REPLACE PROCEDURE plsql_open_v_1023col (emp_cv  OUT sys_refcursor) IS
--  BEGIN
--    OPEN emp_cv FOR SELECT * FROM plsql_tab_1023_col;
--  END;
--/
--
--CREATE OR REPLACE  PROCEDURE plsql_fecth_v_1023col is 
--type mycurtp  is  ref  cursor;
--cur1 mycurtp;
--rec1 plsql_tab_1023_col%ROWTYPE;
--begin
--plsql_open_v_1023col(cur1);
--loop 
--fetch cur1 into rec1;
--exit when cur1%notfound;
--dbe_output.print_line(rec1.col_1||rec1.col_128||rec1.col_256||rec1.col_512||rec1.col_768||rec1.col_1023);
--end loop;
--close cur1;
--end;
--/
--call plsql_fecth_v_1023col();
--drop table if exists plsql_tab_1023_col;
--drop PROCEDURE plsql_open_v_1023col;
--drop PROCEDURE plsql_fecth_v_1023col;
--end

drop table if exists plsql_employees;
create table plsql_employees(employeesno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_employees values(1,'zhangsan','doctor1',10000);
insert into plsql_employees values(2,'zhangsan2','doctor2',10010);
insert into plsql_employees values(123,'zhangsan3','doctor3',10020);
alter table plsql_employees add  hiretime datetime;

create or replace  procedure plsql_test_outp1  is 
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
sys_cur1 := cursorv1;
open  cursorv1 for  select ename as name, sal, sal*2 ep_sal from plsql_employees where ename like 'zhangsan%' ;
loop
fetch cursorv1 into var1;
if cursorv1%notfound then  exit;
end if;
dbe_output.print_line('LINENO: '||cursorv1%rowcount||' +'||var1.a||'+'||var1.b||'+'||var1.c);
end loop;
end;
/

call plsql_test_outp1();
--test when keyword is used in procedure
--expect success
CREATE OR REPLACE PROCEDURE plsql_select_item (
t_column in VARCHAR2,
t_name in VARCHAR2
)
IS
temp VARCHAR2(30);
BEGIN
temp := t_column;
dbe_output.print_line ('No Data found for SELECT on ' || temp || t_name);
END;
/

exec plsql_select_item('111', '222');

create or replace  PROCEDURE  plsql_test_DROP_PROCEDURE_021ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ()
       as
       begin
           dbe_output.print_line('This is a procedure');
       END ;
       /
call plsql_test_DROP_PROCEDURE_021ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ();
call plsql_test_DROP_PROCEDURE_021ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNO;
call plsql_test_DROP_PROCEDURE_021ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOP;
DROP PROCEDURE plsql_test_DROP_PROCEDURE_021ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ;

create or replace view sysobjects as
select object_name as name, object_name as id, CREATED as crdate, owner,
case object_type when 'TABLE' then 'U'
                 when 'VIEW' then 'V'
                 when 'TRIGGER' then 'TR'
                 when 'PROCEDURE' then 'P'
                 else 'D' end as type
from all_objects where instr(',SEQUENCE,PROCEDURE,TRIGGER,TABLE,VIEW,FUNCTION,',','||object_type||',')>0;

create or replace view sysindexes as
    select index_name as name, table_name as id, owner
    from all_indexes
/

declare
    v_Temp_1 NUMBER(10, 0);
    v_Temp_2 varchar2(8000);
begin
    select  count( a.id ) into v_Temp_1 from sysindexes a, sysobjects b where (UPPER(a.id) = UPPER(b.id) and UPPER(b.name) = UPPER('tmp_P_ANTENNAINFO_FOR_RAN')) AND UPPER(b.OWNER) = UPPER(user) AND UPPER(a.OWNER) = UPPER(user);
    if  (( v_Temp_1 ) > 1 ) then
        /*
		drop index IDX_tmp_P_ANT_RAN;
		*/
        v_Temp_2 := 'drop index IDX_tmp_P_ANT_RAN ON plsql_test';
        execute immediate v_Temp_2;
    end if;
end; 
/
drop table if exists plsql_test;
create table plsql_test(a int);
declare
a int;
test int;
begin
a := 2;
delete from plsql_test; 
insert into plsql_test(a) values(1);
update plsql_test set a = a;
insert into plsql_test(a) values(1);
end;
/
select * from plsql_test order by a;
drop table if exists plsql_test;
drop view sysobjects;
drop view sysindexes;


--test char size can not set
--begin
declare
    a char := '1';
  BEGIN
       CASE a
         WHEN '1' THEN
           dbe_output.print_line('1');
         WHEN '2' THEN
           dbe_output.print_line('2');
         WHEN '3' THEN
           dbe_output.print_line('a');
       END CASE;
EXCEPTION
  WHEN OTHERS THEN    
    null;
END;
/
--end

--test drop procedure
 DROP PROCEDURE IF EXISTS Pro_IndexCopy
 /

CREATE PROCEDURE Pro_IndexCopy(ParentTableName VARCHAR,TableName VARCHAR)
AS
    SqlStr VARCHAR(4000);
    IndexName VARCHAR(4000);
    columnName VARCHAR(4000);
    CURSOR curindex IS
    SELECT COLUMNS FROM USER_INDEXES WHERE table_name=UPPER(ParentTableName) AND IS_PRIMARY='N';
BEGIN
    for cindex in curindex loop
        dbe_output.print_line(cindex.COLUMNS||',');
        IndexName:=CONCAT('idx_', tableName, '_', REPLACE(cindex.COLUMNS, ',', '_'));
        IF (LENGTH(IndexName) > 64) THEN
            IndexName:=SUBSTR(IndexName, -64);
        END IF;
        columnName:=REPLACE(cindex.COLUMNS, ',', '`,`');
        SqlStr := CONCAT('CREATE INDEX IF NOT EXISTS ',IndexName, ' ON ' , tableName, '(`',columnName,'`)');
        EXECUTE IMMEDIATE SqlStr;
    end loop;
END;
/

drop procedure Pro_IndexCopy';
drop procedure Pro_IndexCopy'';
drop procedure Pro_IndexCopy ''''''''''''';
drop procedure Pro_IndexCopy'''''''''';
drop procedure Pro_IndexCopy();
drop procedure if exists Pro_IndexCopy';
drop procedure if exists Pro_IndexCopy'';
drop procedure if exists Pro_IndexCopy ''''''''''''';
drop procedure if exists Pro_IndexCopy'''''''''';
drop procedure if exists Pro_IndexCopy();
drop procedure Pro_IndexCopy;

drop procedure if exists plsql_test_drop
/
create procedure plsql_test_drop()
as
    aa int;
begin
    select count(*) into aa from all_tables;
end;
/
drop procedure plsql_test_drop';
drop procedure plsql_test_drop'';
drop procedure plsql_test_drop ''''''''''''';
drop procedure plsql_test_drop'''''''''';
drop procedure plsql_test_drop();
drop procedure plsql_test_drop;


--test sysrefcursor be opened more than once
--begin
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
----------open more than once
declare
a sys_refcursor;
begin
open a for select 1 from dual;
open a for select 2 from dual;
end;
/

select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
----------open more than once, then return someone 1
--expect 2
declare
a sys_refcursor;
begin
open a for select 1 from dual;
open a for select 2 from dual;
dbe_sql.return_cursor(a);
end;
/

select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
--expect output:1000
declare
b sys_refcursor;
a sys_refcursor;
c int;
begin
open b for select 2000 from dual;
a := b;
open b for select 1000 from dual;

fetch a into c;
dbe_output.print_line(c);
close a;
end;
/

select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
--expect output:3000, 2000
declare
b sys_refcursor;
a sys_refcursor;
c int;
begin
open b for select 2000 from dual;
dbe_sql.return_cursor(b);
a := b;
open b for select 1000 from dual;
open b for select 3000 from dual;
fetch a into c;
dbe_output.print_line(c);
end;
/

select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
--expect output:1000, 2000
declare
b sys_refcursor;
c int;
begin
open b for select 2000 from dual;
dbe_sql.return_cursor(b);
open b for select 1000 from dual;
fetch b into c;
dbe_output.print_line(c);
end;
/

select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
--expect invalid cursor
declare
b sys_refcursor;
a sys_refcursor;
c int;
begin
open b for select 2000 from dual;
dbe_sql.return_cursor(b);
a := b;
fetch a into c;
dbe_output.print_line(c);
end;
/

select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;

create or replace procedure a_ret(b OUT sys_refcursor)
is
begin
open b for select 2000 from dual;
dbe_sql.return_cursor(b);
open b for select 1000 from dual;
end;
/

--expect 2000, 1000
declare
a sys_refcursor;
begin
a_ret(a);
dbe_sql.return_cursor(a);
end;
/

----------open more than once, then return someone 2
create or replace procedure a_ret1(b OUT sys_refcursor)
is
a sys_refcursor;
begin
open a for select 2 from dual;
dbe_sql.return_cursor(a);
open a for select 1 from dual;
b := a;
end;
/

----------
create or replace procedure a_ret2(b OUT sys_refcursor)
is
a sys_refcursor;
begin
open a for select 2 from dual;
dbe_sql.return_cursor(a);
b := a;
end;
/

----------
create or replace procedure a_ret3(b OUT sys_refcursor)
is
a sys_refcursor;
begin
open a for select 3 from dual;
dbe_sql.return_cursor(a);
a_ret1(a);
dbe_sql.return_cursor(a);
b := a;
end;
/

----------call by procedure
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
--expect 2000,1000
declare
a sys_refcursor;
begin
open a for select 10 from dual;
a_ret(a);
dbe_sql.return_cursor(a);
open a for select 11 from dual;
end;
/

select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
--expect 2,1
declare
a sys_refcursor;
begin
open a for select 10 from dual;
a_ret1(a);
dbe_sql.return_cursor(a);
open a for select 11 from dual;
end;
/

select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
--expect error
declare
a sys_refcursor;
begin
open a for select 10 from dual;
a_ret2(a);
dbe_sql.return_cursor(a);
end;
/

--expect 2,11
declare
a sys_refcursor;
begin
open a for select 10 from dual;
a_ret2(a);
open a for select 11 from dual;
dbe_sql.return_cursor(a);
open a for select 12 from dual;
end;
/

select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
--expect 3,2,1
declare
a sys_refcursor;
begin
open a for select 10 from dual;
a_ret3(a);
end;
/

select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
create or replace procedure ret_null(b OUT sys_refcursor)
is
a int;
begin
a := 1;
end;
/

--expect 10
declare
a sys_refcursor;
begin
open a for select 10 from dual;
ret_null(a);
dbe_sql.return_cursor(a);
open a for select 11 from dual;
end;
/
--end
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;

--test cursor is setval recursive
--begin
--expect 10,11,12,13
declare
a sys_refcursor;
b sys_refcursor;
c sys_refcursor;
begin
open a for select 10 from dual;
b := a;
c := b;
a := c;
dbe_sql.return_cursor(a);
open a for select 11 from dual;
dbe_sql.return_cursor(b);
open b for select 12 from dual;
dbe_sql.return_cursor(a);
open b for select 13 from dual;
dbe_sql.return_cursor(c);
end;
/

--expect a,d,a,ad,b,b
declare
a sys_refcursor;
b sys_refcursor;
c sys_refcursor;
d sys_refcursor;
e sys_refcursor;
f sys_refcursor;
begin
open a for select 'a' from dual;
b := a;
c := b;
e := a;
a := c;

dbe_sql.return_cursor(a);
open a for select 'a' from dual;
open d for select 'd' from dual;
a := d;
dbe_sql.return_cursor(a);
open d for select 'ad' from dual;
dbe_sql.return_cursor(b);
open b for select 'b' from dual;
dbe_sql.return_cursor(a);
open b for select 'b' from dual;
dbe_sql.return_cursor(c);
open b for select 'b' from dual;
dbe_sql.return_cursor(e);
open f for select 'f' from dual;
b:= f;
dbe_sql.return_cursor(b);
end;
/
--end
select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
------Declare error    OK
declare
  a xxxx;
begin
  null;
end;
/
-------blank or comment line
declare
  a int;
begin
  a := 1;
  null  
end;
/

declare
  a int;
begin
  a := 1;
  /*do nothing*/
  null
end;
/

declare
  --do nothing
  a int;
begin
  --do nothing
  a := 1;
  --do nothing
  null  
end;
/
------sql error
declare
  a int;
begin 
  select 1 into a from dual;
  select 1 from dual;  
end;
/

declare
  a int;
begin 
  select 1 into a from dualx;  
end;
/
------dynamic sql error
declare
  a int;
  sqlstr varchar(20);
begin 
  select 1 into a from dual;
  sqlstr := 'select 1 from dualx';
  execute immediate sqlstr;
end;
/

------exec compile error procedure
create or replace procedure xxx_c 
as
  a int;
  sqlstr varchar(20);
begin 
  select 1 into a from dual;
  sqlstr := 'select 1 from dualx';
  execute immediate sqlstr;
end;
/

exec xxx_c();
------anonymous block call compile error procedure
create or replace procedure xxx_c as
  a int;
  sqlstr varchar(20);
begin 
  select 1 into a from dual;
  sqlstr := 'select 1 from dualx';
  execute immediate sqlstr;
end;
/

declare
sqlstr varchar(100);
begin
null;
null;
null;
xxx_c();
null;
sqlstr := 'select 1 from dualx';
execute immediate sqlstr;
end;
/
------anonymous block call compile error procedure
create or replace procedure xxx_c as
  a int;
  sqlstr varchar(20);
begin 
  select 1 into a from dual;
  sqlstr := 'select 1 from dual';
  execute immediate sqlstr;
end;
/

declare
sqlstr varchar(100);
begin
null;
null;
null;
xxx_c();
null;
sqlstr := 'select 1 from dualx';
execute immediate sqlstr;
end;
/
-------procedure call procedure with compiler error
create or replace procedure xxx_c as
  a sys_refcursor;
  sqlstr varchar(20);
begin
  null;
  open a for insert select 1 from dual;
end;
/

create or replace procedure xxx_h as
  a sys_refcursor;
  sqlstr varchar(20);
begin 
  open a for insert into plsql_test select 1 from dual;
  xxx_c();
end;
/
call xxx_h;
--------procedure call procedure with execute error
create or replace procedure xxx_c as
  a sys_refcursor;
  sqlstr varchar(100) := 'insert select 1 from dual';
begin 
  open a for sqlstr;
end;
/

create or replace procedure xxx_h as
  a sys_refcursor;
  sqlstr varchar(100) := 'insert into plsql_test values(1)';
begin 
  null;  
  open a for sqlstr;
  xxx_c();
end;
/

call xxx_h();
--------procedure call procedure with execute error
create or replace procedure xxx_h as
  a sys_refcursor;
  sqlstr varchar(100) := 'insert into plsql_test values(1)';
begin 
  null;  
  xxx_c();
  open a for sqlstr;
end;
/

call xxx_h();

declare
begin
null;
xxx_h();
end;
/

--begin:test alter password
DROP USER IF EXISTS plsql_test_USER_1 cascade;
CREATE USER plsql_test_USER_1 IDENTIFIED BY plsql_test_USER_12;
CREATE or replace procedure plsql_test_PROC_PASSWORD
is
BEGIN
execute immediate 'ALTER USER plsql_test_USER_1 IDENTIFIED BY plsql_test_USER_12';
END;
/

call plsql_test_PROC_PASSWORD();
call plsql_test_PROC_PASSWORD();

DROP USER plsql_test_USER_1;
--end:test:alter password

--DTS2020030625889
drop table if exists REF_DTS2020030625889_01;
drop table if exists REF_DTS2020030625889_02;
create table REF_DTS2020030625889_01(id int primary key,sn number (10,0),sal number(10,2),name varchar(100),text varchar(100) ,c_time date,m_time datetime);
create table REF_DTS2020030625889_02(id int ,sn number (10,0),sal number(10,2),name varchar(100),text varchar(100) default 'test',c_time date,m_time datetime);
insert into REF_DTS2020030625889_01 values(1,0.11,90000.50,'test','lob',to_date('2019-01-07'),to_date('2019-01-07 14:44:50'));
insert into REF_DTS2020030625889_01 values(5,0.11,90000.50,'jane','',to_date('2019-01-07'),to_date('2019-01-07 14:44:50'));
insert into REF_DTS2020030625889_01 values(6,123.11,90000.50,'test','lob',to_date('2019-01-07'),to_date('2019-01-07 14:44:50'));
insert into REF_DTS2020030625889_01 values(2,123.11,80000.50,'test','lob',to_date('2019-01-08'),to_date('2019-01-07 14:44:50'));
insert into REF_DTS2020030625889_01 values(10,123.11,90000.50,'test','lob',to_date('2019-01-09'),to_date('2019-01-07 14:44:50'));
insert into REF_DTS2020030625889_01 values(101,156262811.11,90000.50,'test','lob',to_date('2019-01-09'),to_date('2019-01-07 14:44:50'));
insert into REF_DTS2020030625889_02 values(1,123.11,90000.50,'test','lob',to_date('2019-01-07'),to_date('2019-01-07 14:44:50'));
insert into REF_DTS2020030625889_02 values(5,123.11,90000.50,'jane','lob',to_date('2019-01-07'),to_date('2019-01-07 14:44:50'));
insert into REF_DTS2020030625889_02 values(21,10001.11,90000.50,'test','lob',to_date('2019-01-07'),to_date('2019-01-07 14:44:50'));
insert into REF_DTS2020030625889_02 values(10,123.11,90000.50,'test','lob',to_date('2019-01-09'),to_date('2019-01-07 14:44:50'));
create or replace procedure REF_CURSOR_JOIN_005(v_sn in number,v_sal in number) is
v_id int;
v_name varchar(100);
v_text varchar(100) ;
v_c_time date;
v_m_time datetime;
cursor3 sys_refcursor;
str3 varchar(4000) := 'select t1.id ,(select t2.name from REF_DTS2020030625889_02 t2 where t2.name = t1.name limit 1) t2_name,t1.c_time  from
REF_DTS2020030625889_01 t1 left join REF_DTS2020030625889_02  t2 on t1.id = t2.id and t2.sn = 90000.50 order by id ,c_time';
begin
  open cursor3 for str3 ;
  loop
  fetch cursor3 into v_id,v_name,v_c_time;
    exit when cursor3%notfound;
    dbe_output.print_line(v_id||' '||v_name||' '||v_c_time );
   end loop;
end;
/
call  REF_CURSOR_JOIN_005(0,90000.50);

create or replace function REF_CURSOR_JOIN_006(v_sn in number,v_sal in number) return int is
v_id int;
v_name varchar(100);
v_text varchar(100) ;
v_c_time date;
v_m_time datetime;
cursor3 sys_refcursor;
str3 varchar(4000) := 'select t1.id ,(select t2.name from REF_DTS2020030625889_02 t2 where t2.name = t1.name limit 1) t2_name,t1.c_time  from
REF_DTS2020030625889_01 t1 left join REF_DTS2020030625889_02  t2 on t1.id = t2.id and t2.sn = 90000.50 order by id ,c_time';
begin
  open cursor3 for str3 ;
  loop
  fetch cursor3 into v_id,v_name,v_c_time;
    exit when cursor3%notfound;
    dbe_output.print_line(v_id||' '||v_name||' '||v_c_time );
   end loop;
   return 1;
end;
/
select REF_CURSOR_JOIN_006(0,90000.50) from dual;
create or replace function REF_CURSOR_JOIN_007(v_sn in number,v_sal in number) return varchar is
v_id int;
v_name varchar(100);
v_text varchar(100) ;
v_c_time date;
v_m_time datetime;
cursor3 sys_refcursor;
v_name2 varchar(4000) := '';
begin
   for item in (select t1.id id,(select t2.name from REF_DTS2020030625889_02 t2 where t2.name = t1.name limit 1) t2_name,t1.c_time  from
REF_DTS2020030625889_01 t1 left join REF_DTS2020030625889_02  t2 on t1.id = t2.id and t2.sn = 90000.50 order by id ,c_time)
   loop
       v_name2:=v_name2||item.t2_name;
   end loop;
   return v_name2;
end;
/
select REF_CURSOR_JOIN_007(0,90000.50) from dual;
drop table REF_DTS2020030625889_01;
drop table REF_DTS2020030625889_02;
------------------------------
--test fetch unopen cursor :DTS2018081702495
--begin
drop table plsql_employees;
create table plsql_employees(employeesno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_employees values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10010),(123,'zhangsan3','doctor3',10020);
alter table plsql_employees add  hiretime datetime;
commit;

--test refcursor
create or replace  function plsql_test_outf1()   return sys_refcursor is
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
sys_cur1 := cursorv1;
open  cursorv1 for  select ename as name, sal, sal*2 ep_sal from plsql_employees where ename like 'zhangsan%' ;
loop
fetch sys_cur1 into var1;
if sys_cur1%notfound then  exit;
end if;
dbe_output.print_line(sys_cur1%rowcount||':'||var1.a||'+'||var1.b||'+'||var1.c);
end loop;
end;
/
--expect error
select plsql_test_outf1();

--end
CREATE OR REPLACE PROCEDURE proc_2(a int) AS
  rc1 sys_refcursor;
BEGIN
  OPEN rc1 FOR SELECT 1 FROM dual where 1 > a;
  dbe_sql.return_cursor(rc1);
END;
/ 

--expect success
exec proc_2(0);



--test the variant name is dq_string
--begin
--exepect 0
declare
"a" number;
a number;
begin
"a" := 1;
a := "a";
dbe_output.print_line(a-"a");
end;
/

--expect null
declare
"a" number;
a number;
begin
"a" := 1;
a := a;
dbe_output.print_line(a-"a");
end;
/

drop table if exists plsql_test;
create table plsql_test(a int, b int);
insert into plsql_test values(10, 100);
commit;

declare
b int;
cursor c1("xx" int default 10) is select a from plsql_test where a = "xx";
begin
open c1(20);
FETCH c1 into b;
dbe_output.print_line('result is:' || b);
FETCH c1 into b;
dbe_output.print_line('result is:' || b);
close c1;
end;
/

CREATE OR REPLACE PROCEDURE p_test_dq("a" in number, "b" out varchar) AS
    a     number := 0;
  BEGIN
    IF "a" < a THEN
      "b" := 'negative number';
    ELSIF "a" = a THEN
      "b" := 'zero';
    ELSE
      "b" := 'positive number';
    END IF;
END p_test_dq;
/

--expect:positive number
declare
b varchar2(256);
v_sql varchar2(256);
begin
v_sql:='begin p_test_dq(:v1,:v2); end;';
execute immediate v_sql using in 1,out b;
dbe_output.print_line(b);
end;
/

--expect:negative number
declare
b varchar2(256);
v_sql varchar2(256);
begin
v_sql:='begin p_test_dq(:v1,:v2); end;';
execute immediate v_sql using -1,out b;
dbe_output.print_line(b);
end;
/

CREATE OR REPLACE PROCEDURE "p_test_dq"("a" in number, "b" out varchar) AS
    a     number := 0;
  BEGIN
    IF "a" < a THEN
      "b" := 'negative number1';
    ELSIF "a" = a THEN
      "b" := 'zero1';
    ELSE
      "b" := 'positive number1';
    END IF;
END "p_test_dq";
/

--expect:positive number1
declare
b varchar2(256);
v_sql varchar2(256);
begin
v_sql:='begin "p_test_dq"(:v1,:v2); end;';
execute immediate v_sql using in 1,out b;
dbe_output.print_line(b);
end;
/

--expect:positive number1
declare
b varchar2(256);
v_sql varchar2(256);
begin
v_sql:='declare "d" number :=0; e varchar2(256); begin "p_test_dq"("d",e); dbe_output.print_line(e);end;';
execute immediate v_sql;
dbe_output.print_line('outer:'||b);
end;
/
--end

--test label with dq string
--begin
--expect success
DECLARE
  p  VARCHAR2(30);
  n  INTEGER := 37;
BEGIN
    IF n = 37 THEN 
      p := ' is a prime number';
      GOTO "print_now";
    END IF;

  p := ' is not a prime number';
 
  <<"print_now">>
  dbe_output.print_line(TO_CHAR(n) || p);
END;
/

--expect success
DECLARE
  p  VARCHAR2(30);
  n  INTEGER := 36;
BEGIN
    IF n = 37 THEN 
      p := ' is a prime number';
      GOTO "print_now";
    END IF;

  p := ' is not a prime number';
 
  <<"print_now">>
  dbe_output.print_line(TO_CHAR(n) || p);
END;
/

--expect error
DECLARE
  p  VARCHAR2(30);
  n  INTEGER := 37;
BEGIN
    IF n = 37 THEN 
      p := ' is a prime number';
      GOTO print_now;
    END IF;

  p := ' is not a prime number';
 
  <<"print_now">>
  dbe_output.print_line(TO_CHAR(n) || p);
END;
/
 
--end

---------------DTS2018082204388
drop table if exists hash_tbl_002;
create table hash_tbl_002(c_id int,c_d_id number(10,4)) partition by hash(c_id) partitions 8;
declare
pname varchar2(20);
count_num int;
cursor mycursor is select name from SYS_TABLE_PARTS where table# in (select ID from SYS_TABLES where name=upper('hash_tbl_002')) order by name;
begin
   open mycursor;
   fetch mycursor into pname;
   while mycursor%found loop
   --dbe_output.print_line('part_name' ||' is '||pname);
   select count(*) into count_num from hash_tbl_002 partition(pname);
   --dbe_output.print_line(pname ||' is '||count_num);
   fetch mycursor into pname;
   end loop;
   close mycursor;
end;
/
create or replace function DBA_ARGUMENTS_003_f1(parm1 in varchar2,parm2 in varchar,parm3 out varchar2) return char
IS
timestamp_para char(100);
begin
     timestamp_para :=to_char(to_timestamp(parm1,'YYYY-MM-DD HH:MI:SS.ff6'));
     return timestamp_para;
end;
/
select data_type,data_length,data_precision,data_scale from user_arguments where object_name = 'DBA_ARGUMENTS_003_F1' order by sequence;

create or replace  function DBA_ARGUMENTS_003_f1(number1 in out number ) return number
IS
number2 number(10,2);
number3 number(9,3);
begin
     number3 := 123456.789;
  number2 := number1;
  number1 := number3;
  return number1;
end;
/
select data_type,data_length,data_precision,data_scale from user_arguments where object_name = 'DBA_ARGUMENTS_003_F1' order by sequence;


--test cursor
drop table if exists plsql_employees;
create table plsql_employees(employeesno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_employees values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10010),(123,'zhangsan3','doctor3',10020);
commit;
alter table plsql_employees add  hiretime datetime;

create or replace procedure plsql_test_out   is
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
open  sys_cur1 for  select ename as name, sal, sal*2 ep_sal from plsql_employees where ename like 'zhangsan%' ;
cursorv1 := sys_cur1;
loop
fetch cursorv1 into var1;
exit when cursorv1%notfound;
dbe_output.print_line('1'||cursorv1%rowcount||'2 +'||var1.a||'+'||var1.b||'+'||var1.c);
end loop;
close cursorv1;
end;
/

--expect success
exec plsql_test_out;

--support clob
declare
a clob;
begin
a := '123456';
dbe_output.print_line(a);
end;
/

drop function if exists pl_func_test;
drop procedure if exists pl_func_test;
create or replace function pl_func_test() return clob
as
l_a clob;
begin
l_a := '123456';
dbe_output.print_line(l_a);
return l_a;
end;
/

select pl_func_test();

create or replace procedure pl_proc_test(a out clob)
as
begin
a := '123456';
end;
/

declare
a1 clob;
begin
pl_proc_test(a1);
dbe_output.print_line(a1);
end;
/

create or replace function pl_func_test1() return clob
as
l_a clob;
begin
pl_proc_test(l_a);
return l_a;
end;
/

declare
l_a clob;
m_a clob;
a int;
begin
l_a := '123456';
m_a := DBE_LOB.substr(l_a, 32767);
dbe_output.print_line(m_a);
a := DBE_LOB.get_length(m_a);
dbe_output.print_line(a);

m_a := DBE_LOB.substr(l_a, 3);
dbe_output.print_line(m_a);
a := DBE_LOB.get_length(m_a);
dbe_output.print_line(a);

m_a := DBE_LOB.substr(l_a, 3, 4);
dbe_output.print_line(m_a);
a := DBE_LOB.get_length(m_a);
dbe_output.print_line(a);
end;
/

declare
a varchar(32767);
begin
a := '123456';
dbe_output.print_line(a);
end;
/

declare
a clob;
b1 clob;
begin
select pl_func_test1() into a from dual;
pl_func_test(b1);
dbe_output.print_line(a);
dbe_output.print_line(b1);
end;
/

drop table hh;
create table hh (a int);
insert into hh values(0);
declare
begin
insert into hh values(1);
execute immediate 'drop table hh';
execute immediate 'create table hh (a int)';
insert into hh values('adsf');
end;
/

select * from hh;

drop table if exists plsql_table_test;
create table plsql_table_test(t_a clob);

declare
a clob;
cnt int;
begin
select count(*) into cnt from plsql_table_test;
dbe_output.print_line(cnt);
pl_proc_test(a);
insert into plsql_table_test values(a);
insert into plsql_table_test values(pl_func_test1());
select count(*) into cnt from plsql_table_test;
dbe_output.print_line(cnt);
end;
/

create or replace function pl_func_test1(a in clob) return clob
as
c int;
begin
select count(1) into c from plsql_table_test;
return a;
end;
/
declare
a clob := '1234';
b1 clob;
begin
select pl_func_test1(a) into b1 from dual;
dbe_output.print_line(a);
dbe_output.print_line(b1);
end;
/

conn sys/Huawei@123@127.0.0.1:1611
drop user gs_plsql cascade;

--test comment display
/*this is a comment*/
begin
null;
end;
/

begin/*this is a comment*/
null;
end;
/

begin
/*this is a comment*/
null;
end;
/

begin
/*this is 
a comment*/
null;
end;
/

begin
/*this is 
a comment*/null;
end;
/

-- test reord with default vaule 
DECLARE
  TYPE DeptRecTyp IS RECORD (
    dept_id    NUMBER(4) NOT NULL := 10,
    dept_name  VARCHAR2(30) NOT NULL := 'Administration',
    mgr_id     NUMBER(6) := 200,
    loc_id     NUMBER(4) := 1700
  );
 
  dept_rec DeptRecTyp;
BEGIN
  dbe_output.print_line('dept_id:   ' || dept_rec.dept_id);
  dbe_output.print_line('dept_name: ' || dept_rec.dept_name);
  dbe_output.print_line('mgr_id:    ' || dept_rec.mgr_id);
  dbe_output.print_line('loc_id:    ' || dept_rec.loc_id);
END;
/

-- test sequence 
DROP TABLE if exists employees_temp;
drop sequence if exists employees_seq;

create sequence employees_seq start with 100;

CREATE TABLE employees_temp
(
    employee_id int
);
 
DECLARE
  seq_value NUMBER;
  seq_tmp NUMBER;
  seq_select employees_temp.employee_id%TYPE;
BEGIN
    --initial
    dbe_output.print_line ('sequency initial value = ' || TO_CHAR(employees_seq.NEXTVAL));
    
    -- normal expr sum 
    seq_tmp := 1+employees_seq.NEXTVAL+employees_seq.NEXTVAL;
    dbe_output.print_line ('expr sum value =' || TO_CHAR(seq_tmp));
    
    --continue incre
    seq_value := employees_seq.NEXTVAL;
    seq_value := employees_seq.NEXTVAL;
    dbe_output.print_line ('continue incre value =' || TO_CHAR(seq_value));
    
    --insert into     
    INSERT INTO employees_temp (employee_id) VALUES (employees_seq.NEXTVAL);
    select employee_id into seq_select from employees_temp;
    dbe_output.print_line ('insert into  value =' || TO_CHAR(seq_select));
    
    --select expr sum
    select employees_seq.NEXTVAL + employee_id into seq_select from employees_temp;
    dbe_output.print_line ('slect expr sum value =' || TO_CHAR(seq_select));
    
    --End current value
    dbe_output.print_line ('Ending sequence value = ' || TO_CHAR(employees_seq.CURRVAL));
END;
/

--test bind param in select into clause. expect return compile error
declare
   a int := 1;
begin
    select 1 into a from dual;
    select 1 into :1 from dual;
end;
/

--test bind param in fetch into clause. expect return compile error
set serveroutput on;
declare
   a sys_refcursor;
   b int := 1;
   c int;
begin
   open a for select b from dual;
   fetch a into :1;
   c := :1;
   dbe_output.print_line('c = ' || c);
end;
/

--add some testcases to test variant management
drop table if exists table_r1;
create table table_r1(a int, b int, c int);
drop table if exists table_r2;
create table table_r2(a int, b int, c int);
insert into table_r1 values(1,2,3);

drop table if exists ta1;
create table ta1(a char(10), b char(10));

--testcase 1
delete from ta1;
declare 
v1 char(10); 
v2 char(10); 
begin 
v1 := 'abc'; 
v2 := 'cfg'; 
execute immediate 'begin insert into ta1(a,b) values(:p, :p); end;' using v1, v2; 
end; 
/
select * from ta1;

--testcase 2
declare
   a int := 1;
begin
    select 1 into a from dual;
    select 1 into :1 from dual;
end;
/

--testcase 3
declare
   a sys_refcursor;
   b int := 1;
begin
   open a for select b from dual;
   dbe_sql.return_cursor(a);
   open a for select b + 2 from dual;
   dbe_sql.return_cursor(a);
end;
/

--testcase 4
alter system set LOCAL_TEMPORARY_TABLE_ENABLED = TRUE;
drop table if exists #tr1;
create temporary table #tr1(f1 int, f2 int);
insert into #tr1 values(1,2);
declare
   a int := 1;
begin
   select f1 into a from #tr1;   
   dbe_output.print_line(a);
end;
/

--testcase 5
DROP TABLE IF EXISTS T_TRIG_1;
CREATE TABLE T_TRIG_1 (F_INT1 INT, F_INT2 INT, F_CHAR1 CHAR(16));
INSERT INTO T_TRIG_1 VALUES(1,2,'A');

CREATE OR REPLACE TRIGGER TEST_TRIG
BEFORE DELETE ON T_TRIG_1
BEGIN
  UPDATE #tr1 SET f1 = 2;
END;
/

--testcase 6
DROP TABLE IF EXISTS T_TRIG_1;
CREATE  TABLE T_TRIG_1 (F_INT1 INT, F_INT2 INT, F_CHAR1 CHAR(16));
INSERT INTO T_TRIG_1 VALUES(1,2,'A');

CREATE OR REPLACE TRIGGER TEST_TRIG
BEFORE DELETE ON T_TRIG_1
BEGIN
  UPDATE #tr1 SET f1 = 2;
END;
/

CREATE OR REPLACE TRIGGER TEST_TRIG
BEFORE DELETE ON T_TRIG_1
BEGIN
  for i in (select * from #tr1) loop
    UPDATE #tr1 SET f1 = 2;
  end loop;
END;
/

--testcase 7
declare
a decimal(22,3) := 1234567890.123412342324;
xxx sys_refcursor;
begin
open xxx for select a from dual;
dbe_sql.return_cursor(xxx);
end;
/

declare
a int := 1;
xxx sys_refcursor;
begin
open xxx for select a from dual;
dbe_sql.return_cursor(xxx);
end;
/
--testcase 8
declare
a char(10) := 'abc';
xxx sys_refcursor;
begin
open xxx for select a from dual;
dbe_sql.return_cursor(xxx);
end;
/

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

 create or replace procedure p1(f1 in int)
is 
v_refcur2 SYS_REFCURSOR;
i varchar(10) := 'abc';
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

--testcase 9
declare
xxx int := 1;
begin
execute immediate '
declare
  rec table_r1%rowtype;
  c1 sys_refcursor;
begin
  open c1 for ''select * from table_r1'';
  fetch c1 into rec;
  execute immediate ''begin null; insert into table_r2 values(:1,:1,:1);end;'' using in :1;
end;
' using in xxx;
end;
/
--end
set serveroutput off;
CONN / AS  SYSDBA
SELECT COUNT(WHAT) FROM JOB$ WHERE WHAT LIKE 'AUD$CLEAN_AUD_LOG(%);';
CALL AUD$CLEAN_AUD_LOG(110);
CALL AUD$MODIFY_SETTING(20, 100);
SELECT WHAT FROM JOB$ WHERE WHAT LIKE 'AUD$CLEAN_AUD_LOG(%);';
CALL AUD$MODIFY_SETTING(110, 100);
SELECT WHAT FROM JOB$ WHERE WHAT LIKE 'AUD$CLEAN_AUD_LOG(%);';
CALL AUD$MODIFY_SETTING(10, 0);
SELECT WHAT FROM JOB$ WHERE WHAT LIKE 'AUD$CLEAN_AUD_LOG(%);';
CALL AUD$MODIFY_SETTING(10, 101);
SELECT WHAT FROM JOB$ WHERE WHAT LIKE 'AUD$CLEAN_AUD_LOG(%);';
CALL AUD$MODIFY_SETTING();
SELECT WHAT FROM JOB$ WHERE WHAT LIKE 'AUD$CLEAN_AUD_LOG(%);';
conn / as  sysdba
drop user if exists cao1 cascade;
drop user if exists cao2 cascade;
create user cao1 identified by Cantian_234;
grant create session,create any procedure  to cao1;
create user cao2 identified by Cantian_234;
grant create session  to cao2;
conn cao1/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE PACKAGE cao1_package
IS
    FUNCTION MYF RETURN INT;
    PROCEDURE MYP;
END;
/
CREATE OR REPLACE PACKAGE BODY cao1_package
IS
    FUNCTION MYF RETURN INT
    IS
        V1 INT := 10;
    BEGIN
        NULL;
       RETURN V1;
    END;
    PROCEDURE MYP
    IS
        V1 INT:=100;
    BEGIN
        SELECT MYF INTO V1 FROM DUAL;
        dbe_output.print_line(V1);
    END;
END;
/
conn cao1/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE PACKAGE cao2.cao2_package
IS
    FUNCTION MYF RETURN INT;
    PROCEDURE MYP;
END;
/
CREATE OR REPLACE PACKAGE BODY cao2.cao2_package
IS
    FUNCTION MYF RETURN INT
    IS
        V1 INT := 10;
    BEGIN
        NULL;
        RETURN V1;
    END;
    PROCEDURE MYP
    IS
        V1 INT:=100;
    BEGIN
        SELECT MYF INTO V1 FROM DUAL;
        dbe_output.print_line(V1);
    END;
END;
/
conn / as  sysdba
drop user if exists cao1 cascade;
drop user if exists cao2 cascade;
conn / as  sysdba 
drop user if exists jie cascade;
create user jie identified by jie102_jie;
grant connect to jie;
grant  execute  ON sys.AUD$MODIFY_SETTING TO jie;
conn jie/jie102_jie@127.0.0.1:1611
call sys.AUD$MODIFY_SETTING(3,1);
exec sys.AUD$MODIFY_SETTING(4,1);
exec sys.AUD$MODIFY_SETTING(6,1);
conn / as sysdba 
drop user if exists jie cascade;

--vmctx check
set serveroutput on;
drop table if exists t_userinfo_test;
create table t_userinfo_test(phonenumber varchar2(100),userid int);
insert into t_userinfo_test(phonenumber ,userid) values('15600000014',1);
commit;
create or replace function f_di_test_rowtype
(
    str_in_phonenumber        in varchar2,
    rec_o_userinfo      out t_userinfo_test%rowtype
) return t_userinfo_test%rowtype as
str_operationdetails varchar2(1000);
begin
select *
  into rec_o_userinfo
  from t_userinfo_test a
where phonenumber = str_in_phonenumber;
dbe_output.print_line('userid is ' || rec_o_userinfo.userid );
return rec_o_userinfo;
end f_di_test_rowtype;
/
declare
  str_in_phonenumber         varchar2(100) := '15600000014';
  rec_o_userinfo       t_userinfo_test%rowtype;
  rec_o_userinfo2       t_userinfo_test%rowtype;
begin
         rec_o_userinfo2 := f_di_test_rowtype(str_in_phonenumber, rec_o_userinfo);
         dbe_output.print_line('return_value is ' || rec_o_userinfo2.userid);
end;
/
drop function f_di_test_rowtype;
drop table t_userinfo_test;

--DTS2020030303579
drop table if  exists PROC_DTS2020030303579;
declare
str clob;
Type_1 varchar(30) := 'int';
Type_2 varchar(30) := 'bigint';
Type_3 varchar(30) := 'number(10,2)';
Type_4 varchar(30) := 'decimal(10,2)';
Type_5 varchar(30) := 'float';
Type_6 varchar(30) := 'double';
Type_7 varchar(30) := 'real';
Type_8 varchar(30) := 'char(100)';
Type_9 varchar(30) := 'varchar(100)';
Type_10 varchar(30) := 'varchar2(100)';
Type_11 varchar(30) := 'bool';
Type_12 varchar(30) := 'boolean';
Type_13 varchar(30) := 'date';
Type_14 varchar(30) := 'timestamp';
Type_15 varchar(30) := 'binary(10)';
Type_16 varchar(30) := 'varbinary(20)';
Type_17 varchar(30) := 'clob';
Type_18 varchar(30) := 'blob';
Type_19 varchar(30) := 'DATETIME';
Type_20 varchar(30) := 'NVARCHAR(100)';
b int := 0;
d int;
begin
for i in 1..30
loop
b := i -1;
str := str||'id'||(b*20+1)||' '||Type_1||','||'id'||(b*20+2)||' '||Type_2||','||'id'||(b*20+3)||' '||Type_3||','||'id'||(b*20+4)||' '||Type_4||','||'id'||(b*20+5)||' '||Type_5||','||
'id'||(b*20+6)||' '||Type_6||','||'id'||(b*20+7)||' '||Type_7||','||'id'||(b*20+8)||' '||Type_8||','||'id'||(b*20+9)||' '||Type_9||','||'id'||(b*20+10)||' '||Type_10||','||
'id'||(b*20+11)||' '||Type_11||','||'id'||(b*20+12)||' '||Type_12||','||'id'||(b*20+13)||' '||Type_13||','||'id'||(b*20+14)||' '||Type_14||','||'id'||(b*20+15)||' '||Type_15||','||
'id'||(b*20+16)||' '||Type_16||','||'id'||(b*20+17)||' '||Type_17||','||'id'||(b*20+18)||' '||Type_18||','||'id'||(b*20+19)||' '||Type_19||','||'id'||(b*20+20)||' '||Type_20||',';
end loop;
d := length(str)-1;
str := substr(str,0,d);
str := 'create table PROC_DTS2020030303579('||str||')';
--dbe_output.print_line(str);
execute immediate str;
end;
/
declare
str clob;
Type_1 varchar(30) := 'int';
Type_2 varchar(30) := 'bigint';
Type_3 varchar(30) := 'number(10,2)';
Type_4 varchar(30) := 'decimal(10,2)';
Type_5 varchar(30) := 'float';
Type_6 varchar(30) := 'double';
Type_7 varchar(30) := 'real';
Type_8 varchar(30) := 'char(100)';
Type_9 varchar(30) := 'varchar(100)';
Type_10 varchar(30) := 'varchar2(100)';
Type_11 varchar(30) := 'bool';
Type_12 varchar(30) := 'boolean';
Type_13 varchar(30) := 'date';
Type_14 varchar(30) := 'timestamp';
Type_15 varchar(30) := 'binary(10)';
Type_16 varchar(30) := 'varbinary(20)';
Type_17 varchar(30) := 'clob';
Type_18 varchar(30) := 'blob';
Type_19 varchar(30) := 'DATETIME';
Type_20 varchar(30) := 'NVARCHAR(100)';
b int := 0;
d int;
begin
for i in 31..50
loop
b := i -1;
--str := 'alter table PROC_USING_BIND_006_T_01 add ( id'||(i-1)*20+1||' int,'||'id'||(i-1)*20+2||' bigint,'||'id'||(i-1)*20+3||' number,'||'id'||(i-1)*20+4||' int,'||'id'||(i-1)*20+5||' int,'||'id'||(i-1)*20+6||' int,'||'id'||(i-1)*20+7||' int,'||'id'||(i-1)*20+8||' int,'
--||'id'||(i-1)*20+9||' int,'||'id'||(i-1)*20+10||' int,'||'id'||(i-1)*20+11||' int,'||'id'||(i-1)*20+12||' int,'||'id'||(i-1)*20+13||' int,'||'id'||(i-1)*20+14||' int,'||'id'||(i-1)*20+15||' int,'||'id'||(i-1)*20+16||' int,'||'id'||(i-1)*20+17||' int,'||'id'||(i-1)*20+18||' int,'';
str := str||'id'||(b*20+1)||' '||Type_1||','||'id'||(b*20+2)||' '||Type_2||','||'id'||(b*20+3)||' '||Type_3||','||'id'||(b*20+4)||' '||Type_4||','||'id'||(b*20+5)||' '||Type_5||','||
'id'||(b*20+6)||' '||Type_6||','||'id'||(b*20+7)||' '||Type_7||','||'id'||(b*20+8)||' '||Type_8||','||'id'||(b*20+9)||' '||Type_9||','||'id'||(b*20+10)||' '||Type_10||','||
'id'||(b*20+11)||' '||Type_11||','||'id'||(b*20+12)||' '||Type_12||','||'id'||(b*20+13)||' '||Type_13||','||'id'||(b*20+14)||' '||Type_14||','||'id'||(b*20+15)||' '||Type_15||','||
'id'||(b*20+16)||' '||Type_16||','||'id'||(b*20+17)||' '||Type_17||','||'id'||(b*20+18)||' '||Type_18||','||'id'||(b*20+19)||' '||Type_19||','||'id'||(b*20+20)||' '||Type_20||',';
end loop;
d := length(str)-1;
str := substr(str,0,d);
str := 'alter table PROC_DTS2020030303579 add ( '||str||')';
--dbe_output.print_line(str);
execute immediate str;
end;
/
create or replace procedure PROC_USING_BIND_009 is
V_1  int;
V_2  bigint;
V_3  number(10,2);
V_4  decimal(10,2);
V_5  float;
V_6  double;
V_7  real;
V_8  char(10);
V_9  varchar(100);
V_10  varchar2(100);
V_11  bool;
V_12  boolean;
V_13  date;
V_14  timestamp;
V_15  binary(10);
V_16  varbinary(20);
V_17  clob;
V_18  blob;
V_19  DATETIME;
V_20  NVARCHAR(100);
begin
V_1    :=11212                                ;
V_2    :=123424234                            ;
V_3    :=1234.56                              ;
V_4    :=123456.78                            ;
V_5    :=12.11                                ;
V_6    :=1888.32                              ;
V_7    :=111.11                               ;
V_8    :='01'                                 ;
V_9    :='1aaaaaaafdfdbadfsfdfdsf'            ;
V_10   :='11aaaaaaafdfdbadfsfdfdsfaaaa'       ;
V_11   :=true                                 ;
V_12   :=false                                ;
V_13   :=to_date('2019-06-27')                ;
V_14   :=to_date('2019-06-27 14:58')          ;
V_15   :='ADFD111'                            ;
V_16   :='afdfdsf111'                         ;
V_17   :='aaaaaaaaaaa i  am clob'             ;
V_18   :='AB0101'                             ;
V_19   :=to_date('2019-06-27')                ;
V_20   :='abcddd#$@'                          ;
execute immediate 'insert into PROC_DTS2020030303579 values
(:p1,:p2,:p3,:p4,:p5,:p6,:p7,:p8,:p9,:p10,:p11,:p12,:p13,:p14,:p15,:p16,:p17,:p18,:p19,:p20,:p21,:p22,:p23,:p24,:p25,:p26,:p27,:p28,:p29,:p30,
:p31,:p32,:p33,:p34,:p35,:p36,:p37,:p38,:p39,:p40,:p41,:p42,:p43,:p44,:p45,:p46,:p47,:p48,:p49,:p50,:p51,:p52,:p53,:p54,:p55,:p56,:p57,:p58,:p59,:p60,
:p61,:p62,:p63,:p64,:p65,:p66,:p67,:p68,:p69,:p70,:p71,:p72,:p73,:p74,:p75,:p76,:p77,:p78,:p79,:p80,:p81,:p82,:p83,:p84,:p85,:p86,:p87,:p88,:p89,:p90,
:p91,:p92,:p93,:p94,:p95,:p96,:p97,:p98,:p99,:p100,:p101,:p102,:p103,:p104,:p105,:p106,:p107,:p108,:p109,:p110,:p111,:p112,:p113,:p114,:p115,:p116,:p117,:p118,:p119,:p120,
:p121,:p122,:p123,:p124,:p125,:p126,:p127,:p128,:p129,:p130,:p131,:p132,:p133,:p134,:p135,:p136,:p137,:p138,:p139,:p140,:p141,:p142,:p143,:p144,:p145,:p146,:p147,:p148,:p149,:p150,
:p151,:p152,:p153,:p154,:p155,:p156,:p157,:p158,:p159,:p160,:p161,:p162,:p163,:p164,:p165,:p166,:p167,:p168,:p169,:p170,:p171,:p172,:p173,:p174,:p175,:p176,:p177,:p178,:p179,:p180,
:p181,:p182,:p183,:p184,:p185,:p186,:p187,:p188,:p189,:p190,:p191,:p192,:p193,:p194,:p195,:p196,:p197,:p198,:p199,:p200,:p201,:p202,:p203,:p204,:p205,:p206,:p207,:p208,:p209,:p210,
:p211,:p212,:p213,:p214,:p215,:p216,:p217,:p218,:p219,:p220,:p221,:p222,:p223,:p224,:p225,:p226,:p227,:p228,:p229,:p230,:p231,:p232,:p233,:p234,:p235,:p236,:p237,:p238,:p239,:p240,
:p241,:p242,:p243,:p244,:p245,:p246,:p247,:p248,:p249,:p250,:p251,:p252,:p253,:p254,:p255,:p256,:p257,:p258,:p259,:p260,:p261,:p262,:p263,:p264,:p265,:p266,:p267,:p268,:p269,:p270,
:p271,:p272,:p273,:p274,:p275,:p276,:p277,:p278,:p279,:p280,:p281,:p282,:p283,:p284,:p285,:p286,:p287,:p288,:p289,:p290,:p291,:p292,:p293,:p294,:p295,:p296,:p297,:p298,:p299,:p300,
:p301,:p302,:p303,:p304,:p305,:p306,:p307,:p308,:p309,:p310,:p311,:p312,:p313,:p314,:p315,:p316,:p317,:p318,:p319,:p320,:p321,:p322,:p323,:p324,:p325,:p326,:p327,:p328,:p329,:p330,
:p331,:p332,:p333,:p334,:p335,:p336,:p337,:p338,:p339,:p340,:p341,:p342,:p343,:p344,:p345,:p346,:p347,:p348,:p349,:p350,:p351,:p352,:p353,:p354,:p355,:p356,:p357,:p358,:p359,:p360,
:p361,:p362,:p363,:p364,:p365,:p366,:p367,:p368,:p369,:p370,:p371,:p372,:p373,:p374,:p375,:p376,:p377,:p378,:p379,:p380,:p381,:p382,:p383,:p384,:p385,:p386,:p387,:p388,:p389,:p390,
:p391,:p392,:p393,:p394,:p395,:p396,:p397,:p398,:p399,:p400,:p401,:p402,:p403,:p404,:p405,:p406,:p407,:p408,:p409,:p410,:p411,:p412,:p413,:p414,:p415,:p416,:p417,:p418,:p419,:p420,
:p421,:p422,:p423,:p424,:p425,:p426,:p427,:p428,:p429,:p430,:p431,:p432,:p433,:p434,:p435,:p436,:p437,:p438,:p439,:p440,:p441,:p442,:p443,:p444,:p445,:p446,:p447,:p448,:p449,:p450,
:p451,:p452,:p453,:p454,:p455,:p456,:p457,:p458,:p459,:p460,:p461,:p462,:p463,:p464,:p465,:p466,:p467,:p468,:p469,:p470,:p471,:p472,:p473,:p474,:p475,:p476,:p477,:p478,:p479,:p480,
:p481,:p482,:p483,:p484,:p485,:p486,:p487,:p488,:p489,:p490,:p491,:p492,:p493,:p494,:p495,:p496,:p497,:p498,:p499,:p500,:p501,:p502,:p503,:p504,:p505,:p506,:p507,:p508,:p509,:p510,
:p511,:p512,:p513,:p514,:p515,:p516,:p517,:p518,:p519,:p520,:p521,:p522,:p523,:p524,:p525,:p526,:p527,:p528,:p529,:p530,:p531,:p532,:p533,:p534,:p535,:p536,:p537,:p538,:p539,:p540,
:p541,:p542,:p543,:p544,:p545,:p546,:p547,:p548,:p549,:p550,:p551,:p552,:p553,:p554,:p555,:p556,:p557,:p558,:p559,:p560,:p561,:p562,:p563,:p564,:p565,:p566,:p567,:p568,:p569,:p570,
:p571,:p572,:p573,:p574,:p575,:p576,:p577,:p578,:p579,:p580,:p581,:p582,:p583,:p584,:p585,:p586,:p587,:p588,:p589,:p590,:p591,:p592,:p593,:p594,:p595,:p596,:p597,:p598,:p599,:p600,
:p601,:p602,:p603,:p604,:p605,:p606,:p607,:p608,:p609,:p610,:p611,:p612,:p613,:p614,:p615,:p616,:p617,:p618,:p619,:p620,:p621,:p622,:p623,:p624,:p625,:p626,:p627,:p628,:p629,:p630,
:p631,:p632,:p633,:p634,:p635,:p636,:p637,:p638,:p639,:p640,:p641,:p642,:p643,:p644,:p645,:p646,:p647,:p648,:p649,:p650,:p651,:p652,:p653,:p654,:p655,:p656,:p657,:p658,:p659,:p660,
:p661,:p662,:p663,:p664,:p665,:p666,:p667,:p668,:p669,:p670,:p671,:p672,:p673,:p674,:p675,:p676,:p677,:p678,:p679,:p680,:p681,:p682,:p683,:p684,:p685,:p686,:p687,:p688,:p689,:p690,
:p691,:p692,:p693,:p694,:p695,:p696,:p697,:p698,:p699,:p700,:p701,:p702,:p703,:p704,:p705,:p706,:p707,:p708,:p709,:p710,:p711,:p712,:p713,:p714,:p715,:p716,:p717,:p718,:p719,:p720,
:p721,:p722,:p723,:p724,:p725,:p726,:p727,:p728,:p729,:p730,:p731,:p732,:p733,:p734,:p735,:p736,:p737,:p738,:p739,:p740,:p741,:p742,:p743,:p744,:p745,:p746,:p747,:p748,:p749,:p750,
:p751,:p752,:p753,:p754,:p755,:p756,:p757,:p758,:p759,:p760,:p761,:p762,:p763,:p764,:p765,:p766,:p767,:p768,:p769,:p770,:p771,:p772,:p773,:p774,:p775,:p776,:p777,:p778,:p779,:p780,
:p781,:p782,:p783,:p784,:p785,:p786,:p787,:p788,:p789,:p790,:p791,:p792,:p793,:p794,:p795,:p796,:p797,:p798,:p799,:p800,:p801,:p802,:p803,:p804,:p805,:p806,:p807,:p808,:p809,:p810,
:p811,:p812,:p813,:p814,:p815,:p816,:p817,:p818,:p819,:p820,:p821,:p822,:p823,:p824,:p825,:p826,:p827,:p828,:p829,:p830,:p831,:p832,:p833,:p834,:p835,:p836,:p837,:p838,:p839,:p840,
:p841,:p842,:p843,:p844,:p845,:p846,:p847,:p848,:p849,:p850,:p851,:p852,:p853,:p854,:p855,:p856,:p857,:p858,:p859,:p860,:p861,:p862,:p863,:p864,:p865,:p866,:p867,:p868,:p869,:p870,
:p871,:p872,:p873,:p874,:p875,:p876,:p877,:p878,:p879,:p880,:p881,:p882,:p883,:p884,:p885,:p886,:p887,:p888,:p889,:p890,:p891,:p892,:p893,:p894,:p895,:p896,:p897,:p898,:p899,:p900,
:p901,:p902,:p903,:p904,:p905,:p906,:p907,:p908,:p909,:p910,:p911,:p912,:p913,:p914,:p915,:p916,:p917,:p918,:p919,:p920,:p921,:p922,:p923,:p924,:p925,:p926,:p927,:p928,:p929,:p930,
:p931,:p932,:p933,:p934,:p935,:p936,:p937,:p938,:p939,:p940,:p941,:p942,:p943,:p944,:p945,:p946,:p947,:p948,:p949,:p950,:p951,:p952,:p953,:p954,:p955,:p956,:p957,:p958,:p959,:p960,
:p961,:p962,:p963,:p964,:p965,:p966,:p967,:p968,:p969,:p970,:p971,:p972,:p973,:p974,:p975,:p976,:p977,:p978,:p979,:p980,:p981,:p982,:p983,:p984,:p985,:p986,:p987,:p988,:p989,:p990,
:p991,:p992,:p993,:p994,:p995,:p996,:p997,:p998,:p999,:p1000)
'using
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20;
commit;
end;
/
call PROC_USING_BIND_009;
create or replace procedure PROC_USING_BIND_009 (
V_1  int,
V_2  bigint,
V_3  number,
V_4  decimal,
V_5  float,
V_6  double,
V_7  real,
V_8  char,
V_9  varchar,
V_10  varchar2,
V_11  bool,
V_12  boolean,
V_13  date,
V_14  timestamp,
V_15  binary,
V_16  varbinary,
V_17  clob,
V_18  blob,
V_19  DATETIME,
V_20  NVARCHAR
)
is
type  XX is record
(
Rec_1  int,
Rec_2  bigint,
Rec_3  number(10,2),
Rec_4  decimal(10,2),
Rec_5  float,
Rec_6  double,
Rec_7  real,
Rec_8  char(10),
Rec_9  varchar(100),
Rec_10  varchar2(100),
Rec_11  bool,
Rec_12  boolean,
Rec_13  date,
Rec_14  timestamp,
Rec_15  binary(10),
Rec_16  varbinary(20),
Rec_17  clob,
Rec_18  blob,
Rec_19  DATETIME,
Rec_20  NVARCHAR(100)
);
v_rec XX;
str clob;
str2 clob;
begin
for i in 1..1000
loop
str := str||'id'||i||'=:p'||i||' and ';
end loop;
str := substr(str,0,length(str)-4);
--dbe_output.print_line(str);
for i in 1..50
loop
str2 := str2||'V_1'||','||'V_2'||','||'V_3'||','||'V_4'||','||'V_5'||','||'V_6'||','||'V_7'||','||'V_8'||','||'V_9'||','||'V_10'||','
            ||'V_11'||','||'V_12'||','||'V_13'||','||'V_14'||','||'V_15'||','||'V_16'||','||'V_17'||','||'V_18'||','||'V_19'||','||'V_20'||',';
end loop;
str2 :=substr(str2,0,length(str2)-1);
--dbe_output.print_line(str2);
execute immediate 'update  PROC_DTS2020030303579 set id1=:p1,id2=:p2,id3=:p3,id4=:p4,id5=:p5,id6=:p6,id7=:p7,id8=:p8,id9=:p9,id10=:p10,id11=:p11,id12=:p12,id13=:p13,id14=:p14,id15=:p15,id16=:p16,id17=:p17,id18=:p18,id19=:p19,id20=:p20  where   '||str
using  trunc(1234.51)+ABS(-100),cast('123424234' as bigint)+ceil(12.3) + bitand(-922337203685477808,9223372036854775801),ACOS(-1),ASIN(0.5)+TO_NUMBER('00FFFFFF', '0000000X'),log(101),ln(8),11.222+ exp(4),'高斯1234',DBE_LOB.SUBSTR('123456,7890',8,1)||UNHEX('746869732069732061207465737420737472'),
concat(HEX('ABC'),'like',hex(255)),1 ,'T',to_date('2018-07-05') + NUMTODSINTERVAL(1, 'HOUR'),to_date('2018-12-12')+TO_DSINTERVAL('180 00:00:00'),cast(concat(chr(67),char(56)) as binary(10)),cast(IFNULL(null,'AAAB0101fG') as varbinary(20)),TO_CLOB(if(9>1,'clobtest%QWERASGSDTRERE','null')),
RAWTOHEX ('0123456789abcdef')|| hex('h#2312#%$#@$'),CONVERT('2018-06-28 13:14:15', timestamp),nvl('ABFDSF#$@',''),
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20,
V_1,V_2,V_3,V_4,V_5,V_6,V_7,V_8,V_9,V_10,V_11,V_12,V_13,V_14,V_15,V_16,V_17,V_18,V_19,V_20;
commit;
end;
/
--call PROC_USING_BIND_009(11212+12,cast('123424234' as bigint),1234.56,exp(3),12.11,1888.32,111.11,'01','1aaaaaaafdfdbadfsfdfdsf',concat('11aaaaaaafdfdbadfsfdfdsfaaaa',null,'!!!@##A$%$%AFD "'),true,false,to_date('2019-06-27'),to_date('2019-06-27 14:58'),'ADFD111','afdfdsf111','aaaaaaaaaaa i  am clob','AB0101',FROM_UNIXTIME(1111885200),'abcddd#$@');
select id1,id2,id3,id4,id5,id19 from PROC_DTS2020030303579;
drop table PROC_DTS2020030303579;

DROP TABLE IF EXISTS tbl_RegNETable;
CREATE TABLE tbl_RegNETable
(
  cNeMgrSvrProcType BINARY_INTEGER NOT NULL,
  cNeMgrSvrProcHandle BINARY_INTEGER NOT NULL,
  cDbName VARCHAR(255 BYTE) NOT NULL,
  cTableName VARCHAR(255 BYTE) NOT NULL,
  cDevIDFieldName VARCHAR(255 BYTE) NOT NULL,
  cDevTypeFieldName VARCHAR(255 BYTE) NOT NULL,
  cDbServerName VARCHAR(255 BYTE)
);
INSERT INTO tbl_RegNETable  values (3022,0,'InventoryDB','view_inv_3rdParty_ne_unitedmgr','iDevID','iDevTypeID',null);
INSERT INTO tbl_RegNETable  values (30,401,'BMSDB','tbl_RegU2kNERegionView_30_401','DevID','DevType',null);
INSERT INTO tbl_RegNETable  values (30,301,'BMSDB','tbl_RegU2kNERegionView_30_301','DevID','DevType',null);
INSERT INTO tbl_RegNETable  values (30,801,'BMSDB','tbl_RegU2kNERegionView_30_801','DevID','DevType',null);
INSERT INTO tbl_RegNETable  values (30,701,'BMSDB','tbl_RegU2kNERegionView_30_701','DevID','DevType',null);
INSERT INTO tbl_RegNETable  values (30,101,'BMSDB','tbl_RegU2kNERegionView_30_101','DevID','DevType',null);
INSERT INTO tbl_RegNETable  values (30,201,'BMSDB','tbl_RegU2kNERegionView_30_201','DevID','DevType',null);
INSERT INTO tbl_RegNETable  values (30,601,'BMSDB','tbl_RegU2kNERegionView_30_601','DevID','DevType',null);
INSERT INTO tbl_RegNETable  values (30,501,'BMSDB','tbl_RegU2kNERegionView_30_501','DevID','DevType',null);
INSERT INTO tbl_RegNETable  values (236,0,'BitsDB','tbl_RegU2kNERegionView_236_0','DevID','DevType',null);
COMMIT;
ALTER TABLE tbl_RegNETable ADD PRIMARY KEY(cNeMgrSvrProcType, cNeMgrSvrProcHandle);

create or replace PROCEDURE ip_GetAllEMGroup
as
   v_SWV_ExecDyn  varchar2(1000);
   v_refcur SYS_REFCURSOR;
   v_refcur2 SYS_REFCURSOR;
   v_refcur3 SYS_REFCURSOR;
   v_ownerEMProcType  NUMBER(10,0);
   v_ownerEMProcHandle  NUMBER(10,0);
   v_procType  VARCHAR2(20);
   v_procHandle  VARCHAR2(20);
   allEMGroup_Cursor SYS_REFCURSOR;

begin
   open allEMGroup_Cursor for select cNeMgrSvrProcType, cNeMgrSvrProcHandle from tbl_RegNETable;
   fetch allEMGroup_Cursor into v_ownerEMProcType,v_ownerEMProcHandle;
   while (allEMGroup_Cursor%FOUND) LOOP
      open v_refcur for select v_ownerEMProcType ownerProcType, v_ownerEMProcHandle ownerProcHandle from SYS_DUMMY;
      DBE_SQL.RETURN_CURSOR(v_refcur);
      fetch allEMGroup_Cursor into v_ownerEMProcType,v_ownerEMProcHandle;
   END LOOP;
   close allEMGroup_Cursor;
commit;
end;
/

call ip_GetAllEMGroup();
drop PROCEDURE ip_GetAllEMGroup;
drop TABLE tbl_RegNETable;
set serveroutput off;