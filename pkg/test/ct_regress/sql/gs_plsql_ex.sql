--
-- gs_plsql_ex
-- testing procedure
--

set serveroutput on;

SELECT COUNT(*) FROM SYS.SYS_DEPENDENCIES D  WHERE D.D_OWNER# NOT IN (SELECT ID FROM SYS.SYS_USERS);

create user gs_plsql_ex identified by root_1234;
grant dba to gs_plsql_ex;
grant select on SYS.SYS_DEPENDENCIES to gs_plsql_ex;
grant select on SYS.SYS_PROCS to gs_plsql_ex;
grant select on SYS.DV_ME to gs_plsql_ex;
conn gs_plsql_ex/root_1234@127.0.0.1:1611

--test: dependency will be recorded when create procedure or function
--begin
DROP TABLE IF EXISTS DEPD_T1;
DROP TABLE IF EXISTS DEPD_T2;
DROP TABLE IF EXISTS DEPD_T3;
DROP TABLE IF EXISTS DEPD_T4;
CREATE TABLE DEPD_T1(F1 INT, F2 VARCHAR2(20));
CREATE TABLE DEPD_T2(F1 INT, F2 VARCHAR2(20));
CREATE TABLE DEPD_T3(F1 INT, F2 VARCHAR2(20));
CREATE TABLE DEPD_T4(F1 INT, F2 VARCHAR2(20));

SELECT COUNT(*) FROM SYS.SYS_DEPENDENCIES D, SYS.DV_ME M WHERE D.D_OWNER# = M.USER_ID;
SELECT * FROM USER_DEPENDENCIES ORDER BY NAME, REFERENCED_NAME;

create or replace view depd_v1 as select * from depd_t1;

drop sequence if exists depd_s1;
CREATE SEQUENCE depd_s1 START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE NOCACHE;
  
create or replace procedure depd_p1(a int, b varchar2)
as
c int := 1;
d int := 2;
begin
  insert into depd_t1 values(a,b);
  commit;
end;
/

SELECT * FROM USER_DEPENDENCIES WHERE NAME='DEPD_P1';

create or replace function depd_f1(a int)
return int
as
c int;
begin
  return a;
end;
/

create or replace function depd_f2(a int)
return int
as
c int;
begin
	select count(*) into c from dual;
  return c+1;
end;
/

SELECT * FROM USER_DEPENDENCIES WHERE NAME='DEPD_F2';

create or replace function depd_f3(a int)
return int
as
c int;
begin	
  return a;
end;
/

create or replace function depd_f4(a int, b int)
return int
as
c int;
begin
  return a + b;
end;
/

create or replace function depd_f5(a int)
return int
as
c int;
begin
	select count(*) into c from depd_t1;
end;
/

create or replace view depd_v2 as select depd_f2(f1) as a, f2 from depd_t1;
create or replace view depd_v3 as select * from depd_v2;
 
CREATE OR REPLACE SYNONYM  my_objects_s  FOR SYS.USER_OBJECTS;
CREATE OR REPLACE SYNONYM  my_depd_f3  FOR depd_f3;
CREATE OR REPLACE SYNONYM  my_depd_s1  FOR depd_s1;

Create Or Replace Procedure TEST_P1_REF
As
C Int := 1;
D Varchar2(20) := '2';
Begin
	Select depd_f1(4) Into C From Dual;
	Select count(*) Into C From depd_v3;
	depd_p1(depd_f2(2),D);
	execute immediate 'select count(*) from depd_t1' into c;
	select depd_s1.nextval into c from dual;
	select count(*) into c from my_objects_s;
	select count(*) into c from my_objects_s where object_id = depd_f3(100);	
	select count(*) into c from SYS.V$LOGFILE;
End;
/

SELECT * FROM USER_DEPENDENCIES WHERE NAME='TEST_P1_REF' ORDER BY REFERENCED_OWNER, REFERENCED_NAME;

--TEST recursive call 
Create Or Replace Procedure TEST_P2_REF
AS
    a number(10, 0) ;
	D Varchar2(20) := '2';
begin
	Select count(*) Into a From depd_v3;
	depd_p1(depd_f2(2),D);
	
    begin
        select  depd_f1(1) + 1 into a from dual;
    exception
        when no_data_found then
            dbe_output.print_line(depd_f2(2));
    end;
    select count(*) into a from depd_t1;
end; 
/
SELECT * FROM USER_DEPENDENCIES WHERE NAME='TEST_P2_REF' ORDER BY REFERENCED_OWNER, REFERENCED_NAME;

Create Or Replace Procedure TEST_P3_REF
As
C Int := 1;
D Varchar2(20) := '2';
Begin
	Select count(*) Into C From depd_v3;
End;
/
SELECT * FROM USER_DEPENDENCIES WHERE NAME='TEST_P3_REF' ORDER BY REFERENCED_OWNER, REFERENCED_NAME;

Create Or Replace Procedure TEST_P4_REF
As
C Int := 1;
D Varchar2(20) := '2';
Begin
	Select depd_f1(1) Into C From dual;
End;
/
SELECT * FROM USER_DEPENDENCIES WHERE NAME='TEST_P4_REF' ORDER BY REFERENCED_OWNER, REFERENCED_NAME;

Create Or Replace Procedure TEST_P5_REF
As
C Int := 1;
D Varchar2(20) := '2';
Begin
	Select depd_f4(depd_f1(1),depd_f2(2)) Into C From dual;
End;
/
SELECT * FROM USER_DEPENDENCIES WHERE NAME='TEST_P5_REF' ORDER BY REFERENCED_OWNER, REFERENCED_NAME;

--test explicit cursor and implicit cursor
Create Or Replace Procedure TEST_P6_REF
As
cursor c1 is select f1 from depd_t1;
cursor c2(xx int default 10) is select f1 from depd_t2 where f1 = xx;
b int;
Begin
	open c1;
	open c2(20);
	FETCH c2 into b;
	
	for rec in (select f1  from depd_t3) loop 
	  dbe_output.print_line(rec.f1); 
	end loop; 
End;
/

SELECT * FROM USER_DEPENDENCIES WHERE NAME='TEST_P6_REF' ORDER BY REFERENCED_OWNER, REFERENCED_NAME;
drop Procedure TEST_P6_REF;

--test ref cursor
Create Or Replace Procedure TEST_P7_REF
As
  type rc is ref cursor;   
  l_cursor rc; 
  sys_cur sys_refcursor;
begin 
  if (to_char(sysdate,'dd') = 30) then 
	  -- ref cursor with dynamic sql 
	  open l_cursor for 'select * from depd_t1'; 
  elsif (to_char(sysdate,'dd') = 29) then 
	  -- ref cursor with static sql 
	  open l_cursor for select * from depd_t2; 
  else 
	   -- with ref cursor with static sql 
	   open l_cursor for select * from depd_t3; 
  end if; 
  
  open sys_cur for select * from depd_t4;
end; 
/ 

SELECT * FROM USER_DEPENDENCIES WHERE NAME='TEST_P7_REF' ORDER BY REFERENCED_OWNER, REFERENCED_NAME;
drop Procedure TEST_P7_REF;	
	
--test trigger
CREATE OR REPLACE TRIGGER TRIG_BEFORE_DEPD_T1 BEFORE UPDATE ON DEPD_T1
BEGIN
  INSERT INTO DEPD_T2 VALUES(depd_f2(1), 'NEW');
END;
/

CREATE OR REPLACE TRIGGER TRIG_BEFORE_DEPD_T2 BEFORE UPDATE ON DEPD_T1
BEGIN
  INSERT INTO DEPD_T3 VALUES(1, 'NEW');
END;
/

CREATE OR REPLACE TRIGGER TRIG_BEFORE_DEPD_T3 BEFORE UPDATE ON DEPD_T3
BEGIN
  INSERT INTO DEPD_T1 VALUES(1, 'NEW');
END;
/

SELECT * FROM USER_DEPENDENCIES WHERE NAME='TRIG_BEFORE_DEPD_T1' ORDER BY REFERENCED_OWNER, REFERENCED_NAME;

drop TRIGGER TRIG_BEFORE_DEPD_T1;
SELECT * FROM USER_DEPENDENCIES WHERE NAME='TRIG_BEFORE_DEPD_T1' ORDER BY REFERENCED_OWNER, REFERENCED_NAME;

--trigger will be drop when table is dropped
drop table DEPD_T1;

SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME IN ('DEPD_P1','TEST_P1_REF','TRIG_BEFORE_DEPD_T3', 'DEPD_F5') ORDER BY OBJECT_NAME;

--test compile objects by user
exec dbe_util.compile_schema('abc', false);
exec dbe_util.compile_schema('abc', true);
exec dbe_util.compile_schema('gs_plsql_ex', false);
exec dbe_util.compile_schema('gs_plsql_ex', NULL);
exec dbe_util.compile_schema('gs_plsql_ex', true);
exec dbe_util.compile_schema('gs_plsql_ex', false);
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME IN ('DEPD_P1','TEST_P1_REF','TRIG_BEFORE_DEPD_T3','DEPD_F5') ORDER BY OBJECT_NAME;


SELECT COUNT(*) FROM SYS.SYS_DEPENDENCIES D, SYS.SYS_PROCS P, SYS.DV_ME M
WHERE P.USER# = M.USER_ID AND D.D_OWNER# = M.USER_ID AND D.D_OBJ# = P.OBJ# AND P.NAME='TRIG_BEFORE_DEPD_T2';

select object_name, status from user_objects where object_name in ('DEPD_P1','TEST_P1_REF') order by object_name;

drop table DEPD_T2;
select object_name, status from user_objects where object_name in ('TRIG_BEFORE_DEPD_T1') order by object_name;


drop function DEPD_F2;
SELECT * FROM USER_DEPENDENCIES WHERE NAME='DEPD_F2';

drop Procedure Test_P1_Ref;
SELECT * FROM USER_DEPENDENCIES WHERE NAME='TEST_P1_REF' ORDER BY REFERENCED_OWNER, REFERENCED_NAME;
--end

drop table if exists depd_t3;
create table depd_t3(a int);
create or replace SYNONYM MY_SYNONYM for depd_t3;
SELECT * FROM USER_DEPENDENCIES WHERE NAME='MY_SYNONYM' ORDER BY REFERENCED_OWNER, REFERENCED_NAME;
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='MY_SYNONYM';

drop TABLE depd_t3;
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='MY_SYNONYM';

--test soft parse
DROP SYNONYM my_objects_s;
drop sequence depd_s1;
drop view depd_v3;

Create Or Replace Procedure TEST_P1_REF
As
C Int := 1;
D Varchar2(20) := '2';
Begin
	Select depd_f1(4) Into C From Dual;
	Select count(*) Into C From depd_v3;
	select depd_s1.nextval into c from dual;
	select count(*) into c from my_objects_s;	
End;
/

--drop all objects
SELECT COUNT(*) FROM SYS.SYS_DEPENDENCIES D, SYS.DV_ME M WHERE D.D_OWNER# = M.USER_ID;
SELECT * FROM USER_DEPENDENCIES ORDER BY NAME, REFERENCED_NAME;
DROP SYNONYM MY_SYNONYM;
DROP PROCEDURE TEST_P2_REF;
DROP PROCEDURE DEPD_P1;
drop function DEPD_F4;
DROP PROCEDURE TEST_P4_REF;
DROP PROCEDURE TEST_P5_REF;

SELECT COUNT(*) FROM SYS.SYS_DEPENDENCIES D, SYS.DV_ME M WHERE D.D_OWNER# = M.USER_ID;
SELECT * FROM USER_DEPENDENCIES ORDER BY NAME, REFERENCED_NAME;

--test
--sql context which with sequence will be reparse.
--begin
create sequence ALL_DEPENDENCIES_012_Seq_01  increment by 2 start with 1 maxvalue 50 cache 10 cycle noorder;
create table  ALL_DEPENDENCIES_012_Tab_01(id  int,name varchar(100),ctime date);

create or replace procedure ALL_DEPENDENCIES_012_Proc_01 
is 
A varchar(30);
begin
insert into ALL_DEPENDENCIES_012_Tab_01 values (ALL_DEPENDENCIES_012_Seq_01.nextval,'test','2018-09-17 16:10:28');
select ALL_DEPENDENCIES_012_Seq_01.nextval  into A from dual ;
return ;
end;
/

drop sequence ALL_DEPENDENCIES_012_Seq_01;

--expect error
create or replace procedure ALL_DEPENDENCIES_012_Proc_03 
is 
A varchar(30);
begin
insert into ALL_DEPENDENCIES_012_Tab_01 values (ALL_DEPENDENCIES_012_Seq_01.nextval,'test','2018-09-17 16:10:28');
select ALL_DEPENDENCIES_012_Seq_01.nextval  into A from dual ;
return ;
end;
/

--end

--test recompile OBJECTS
--BEGIN
CREATE TABLE DEPD_T1(F1 INT, F2 VARCHAR2(20));
CREATE OR REPLACE VIEW DEPD_V1 AS SELECT * FROM DEPD_T1;

CREATE SEQUENCE DEPD_S1 START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE NOCACHE;

CREATE OR REPLACE SYNONYM  DEPD_SYN1  FOR DEPD_T1;

CREATE OR REPLACE FUNCTION DEPD_F1(A INT)
RETURN INT
AS
C INT;
BEGIN
	SELECT COUNT(*) INTO C FROM DEPD_T1;
END;
/

CREATE OR REPLACE PROCEDURE DEPD_P1_REF
AS
C INT := 1;
D VARCHAR2(20) := '2';
BEGIN
	SELECT COUNT(*) INTO C FROM DEPD_V1;
END;
/

CREATE OR REPLACE PROCEDURE DEPD_P2_REF
AS
C INT := 1;
D VARCHAR2(20) := '2';
BEGIN
	SELECT COUNT(*) INTO C FROM DEPD_SYN1;
END;
/

CREATE OR REPLACE PROCEDURE DEPD_P3_REF
AS
CURSOR C1 IS SELECT F1 FROM DEPD_T1;
B INT;
BEGIN
	OPEN C1;
END;
/

CREATE OR REPLACE PROCEDURE DEPD_P4_REF
AS
CURSOR C2(XX INT DEFAULT 10) IS SELECT F1 FROM DEPD_V1 WHERE F1 = XX;
B INT;
BEGIN
	OPEN C2(20);
	FETCH C2 INTO B;
	
END;
/

CREATE OR REPLACE PROCEDURE DEPD_P5_REF
AS
CURSOR C2(XX INT DEFAULT 10) IS SELECT F1 FROM DEPD_SYN1 WHERE F1 = XX;
B INT;
BEGIN
	OPEN C2(20);
	FETCH C2 INTO B;
	
END;
/

CREATE OR REPLACE PROCEDURE DEPD_P6_REF
AS
B INT;
BEGIN	
	FOR REC IN (SELECT F1  FROM DEPD_V1) LOOP 
	  dbe_output.print_line(REC.F1); 
	END LOOP; 
END;
/

CREATE OR REPLACE PROCEDURE DEPD_P7_REF
AS
B INT;
BEGIN	
	FOR REC IN (SELECT F1  FROM DEPD_SYN1) LOOP 
	  dbe_output.print_line(REC.F1); 
	END LOOP; 
END;
/

CREATE OR REPLACE PROCEDURE DEPD_P8_REF
AS
B INT;
BEGIN
	FOR REC IN (SELECT F1  FROM DEPD_SYN1 WHERE F1 = DEPD_F1(1)) LOOP 
	  dbe_output.print_line(REC.F1); 
	END LOOP; 
END;
/

CREATE OR REPLACE PROCEDURE "depd_p9_ref"
AS
B INT;
BEGIN
	FOR REC IN (SELECT F1  FROM depd_syn1 WHERE F1 = depd_f1(1)) LOOP 
	  dbe_output.print_line(REC.F1); 
	END LOOP; 
END;
/

DROP TABLE DEPD_T1;

SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME LIKE 'DEPD%' ORDER BY OBJECT_NAME;
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME LIKE 'depd%' ORDER BY OBJECT_NAME;

EXEC dbe_util.compile_schema('GS_PLSQL_EX', FALSE);

SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME LIKE 'DEPD%' ORDER BY OBJECT_NAME;

--end


--test memcpy to self
Declare
  Sqlstr1 Varchar(60);
  Sqlstr2 Varchar(60);
Begin 
  Sqlstr1 := 'abcdefghfdskfjddsfds';
  Sqlstr1 := Right(Sqlstr1,  Length(Sqlstr1) - 1);

End;
/

--test plm_entry will lose effectiveness after the references has been dropped.
--begin
create sequence ALL_DEPENDENCIES_010_Seq_01  increment by 2 start with 1 maxvalue 50 cache 10 cycle noorder;
create table  ALL_DEPENDENCIES_010_Tab_01(id  int,name varchar(100),ctime date);
insert into ALL_DEPENDENCIES_010_Tab_01 values (ALL_DEPENDENCIES_010_Seq_01.nextval,'test','2018-09-17 16:10:28');
commit;

create or replace procedure ALL_DEPENDENCIES_010_Func_01 
is 
A varchar(30);
begin
insert into ALL_DEPENDENCIES_010_Tab_01 values (ALL_DEPENDENCIES_010_Seq_01.nextval,'abc','2018-09-18 16:10:28');
select name into A  from ALL_DEPENDENCIES_010_Tab_01 where id =  3;
return ;
end;
/
create or replace function ALL_DEPENDENCIES_010_Func_02 return varchar
is 
A varchar(30);
begin
ALL_DEPENDENCIES_010_Func_01();
A := 1;
return A;
end;
/

select * from user_dependencies where name ='ALL_DEPENDENCIES_010_FUNC_01' order by REFERENCED_NAME; 
select OBJECT_TYPE, STATUS from user_objects where OBJECT_NAME='ALL_DEPENDENCIES_010_FUNC_01';

select * from user_dependencies where name ='ALL_DEPENDENCIES_010_FUNC_02' order by REFERENCED_NAME; 
select OBJECT_TYPE, STATUS from user_objects where OBJECT_NAME='ALL_DEPENDENCIES_010_FUNC_02';

 drop table  ALL_DEPENDENCIES_010_Tab_01;
select OBJECT_TYPE, STATUS from user_objects where OBJECT_NAME='ALL_DEPENDENCIES_010_FUNC_02';
 select * from user_dependencies where name ='ALL_DEPENDENCIES_010_FUNC_02' order by REFERENCED_NAME; 

select OBJECT_TYPE, STATUS from user_objects where OBJECT_NAME='ALL_DEPENDENCIES_010_FUNC_02';

--create ALL_DEPENDENCIES_010_Func_02 again
--expect error
create or replace function ALL_DEPENDENCIES_010_Func_02 return varchar
is 
A varchar(30);
begin
ALL_DEPENDENCIES_010_Func_01();
A := 1;
return A;
end;
/
--end

--DTS2018101808429
drop table if exists stud_blob;
create table stud_blob(c_id int,b_blob blob);
insert into stud_blob values(1,'35466');
commit;
create or replace procedure blob_0011()
as
cc_blob varchar(8000);
begin
update stud_blob set b_blob =b_blob || '35466' where c_id=1;
select b_blob into cc_blob from stud_blob where c_id=1;
dbe_output.print_line('result:'||cc_blob);
end;
/
call blob_0011();
create or replace procedure blob_0011()
as
cc_blob blob;
begin
update stud_blob set b_blob =b_blob || '35466' where c_id=1;
select b_blob into cc_blob from stud_blob where c_id=1;
dbe_output.print_line('result:'||cc_blob);
end;
/
call blob_0011();

conn sys/Huawei@123@127.0.0.1:1611
select sleep(1);
drop user gs_plsql_ex cascade;
SELECT COUNT(*) FROM SYS.SYS_DEPENDENCIES D  WHERE D.D_OWNER# NOT IN (SELECT ID FROM SYS.SYS_USERS);

drop user if exists test_ctsql_plsql_ex_0121 cascade;
create user test_ctsql_plsql_ex_0121 identified by root_1234;
grant all privileges to test_ctsql_plsql_ex_0121;
grant select on v$sqlarea to test_ctsql_plsql_ex_0121;
grant DELETE on sys.WSR_SNAPSHOT to test_ctsql_plsql_ex_0121;
grant DELETE on sys.WSR_SYS_STAT to test_ctsql_plsql_ex_0121;
grant DELETE on sys.WSR_SYSTEM to test_ctsql_plsql_ex_0121;
grant DELETE on sys.WSR_SYSTEM_EVENT to test_ctsql_plsql_ex_0121;
grant DELETE on sys.WSR_SQLAREA to test_ctsql_plsql_ex_0121;
grant DELETE on sys.WSR_PARAMETER to test_ctsql_plsql_ex_0121;
conn test_ctsql_plsql_ex_0121/root_1234@127.0.0.1:1611
--test duplicate procedure and function
--begin
--EXPECT SUCCESS

CREATE OR REPLACE FUNCTION DUP_TEST(A INT)
RETURN INT
AS
C INT;
BEGIN
	SELECT COUNT(*) INTO C FROM DUAL;
END;
/

--EXPECT ERROR
CREATE OR REPLACE PROCEDURE DUP_TEST
AS
C INT := 1;
D VARCHAR2(20) := '2';
BEGIN
	SELECT COUNT(*) INTO C FROM DUAL;
END;
/

DROP FUNCTION IF EXISTS DUP_TEST;
--end

--test clob used in pl:DTS2018103108301
--begin
drop function if exists fun_lob_005;
drop function if exists fun_lob_006;

create or replace function fun_lob_005(num int) return clob
is
 v_lang clob := 'abc';
BEGIN
 FOR I IN 1 .. num 
 LOOP
  v_lang := v_lang || 'efg';	
 END LOOP;
 return v_lang;
END;
/

create or replace function fun_lob_006(num int) return clob
is
 v_lang clob := fun_lob_005(200);
BEGIN
 FOR I IN 1 .. num 
 LOOP
  v_lang := v_lang || 'efg';	
 END LOOP;
 return v_lang;
END;
/

select fun_lob_006(10) from dual;
select fun_lob_005(10) from dual;
--end

--test use_native_datatype=false
--expect success
CREATE OR REPLACE PROCEDURE PL_DROP_SNAPSHOT_RANGE
(
    LOW_SNAP_ID      IN BINARY_INTEGER,
    HIGH_SNAP_ID     IN BINARY_INTEGER
)
AS
BEGIN
    IF (LOW_SNAP_ID IS NULL OR HIGH_SNAP_ID IS NULL) THEN
        THROW_EXCEPTION(-20000, 'LOW_SNAP_ID & HIGH_SNAP_ID CAN''T BE NULL!');
    END IF;
    
    FOR i IN LOW_SNAP_ID .. HIGH_SNAP_ID LOOP
    
        DELETE FROM sys.WSR_SNAPSHOT
         WHERE SNAP_ID = i;

        DELETE FROM sys.WSR_SYS_STAT
         WHERE SNAP_ID = i;        

        DELETE FROM sys.WSR_SYSTEM
         WHERE SNAP_ID = i; 
         
        DELETE FROM sys.WSR_SYSTEM_EVENT
         WHERE SNAP_ID = i;                  
   
        DELETE FROM sys.WSR_SQLAREA
         WHERE SNAP_ID = i;    
        
        DELETE FROM sys.WSR_PARAMETER
         WHERE SNAP_ID = i;         
         
        COMMIT;
    
    END LOOP;  
      
END;
/

DROP PROCEDURE IF EXISTS PL_DROP_SNAPSHOT_RANGE;
--end


--test error message
--begin
select SQL_ERR_MSG(602)||SQL_ERR_MSG(603)||SQL_ERR_MSG(604)||SQL_ERR_MSG(0)||SQL_ERR_MSG(-1)||SQL_ERR_MSG(2999)||SQL_ERR_MSG(3000) from dual;
select SQL_ERR_MSG(100000) from dual;
select SQL_ERR_MSG(100001) from dual;
select SQL_ERR_MSG(-20000)||SQL_ERR_MSG(-20999) from dual;
select SQL_ERR_MSG(-19999) from dual;
select SQL_ERR_MSG(-21000) from dual;
--end

declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, 50501);
BEGIN
    IF 1 < 2 THEN
      RAISE past_due;
    END IF;
  EXCEPTION
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/
declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, 602);
BEGIN
    IF 1 < 2 THEN
      RAISE past_due;
    END IF;
  EXCEPTION
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/

declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, -50501);
BEGIN
    IF 1 < 2 THEN
      RAISE past_due;
    END IF;
  EXCEPTION
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/

--test continue use in pl:DTS2018110100910 
--begin
create or replace function test_loop return boolean is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 0;
  FOR i IN 1..10 LOOP
    test_num := test_num + 1;
    CONTINUE when i > 7;
    test_num := test_num + 1;
    CONTINUE;
    test_num := test_num + 1;
  END LOOP;
  LOOP
    EXIT;
  END LOOP;
  dbe_output.print_line(test_num);
  IF test_num = 17 THEN
    FunctionResult := TRUE;
  ELSE
    FunctionResult := FALSE;
  END IF;
  return(FunctionResult);
end test_loop;
/

CREATE OR REPLACE PROCEDURE test_main_proc IS
  flag     BOOLEAN;
  num_type VARCHAR2(30);
BEGIN

  flag := test_loop();
  IF flag = FALSE THEN
    num_type := 'false';
  ELSE
    num_type := 'true';
  END IF;
  dbe_output.print_line(num_type);

END test_main_proc;
/

EXECUTE test_main_proc();
--end

--test continue,exit,goto with label use in pl
--begin
DECLARE
  aaa NUMBER;
  i   NUMBER;
BEGIN
  aaa := 2;
  i := 1;
  <<outer_loop>>
  WHILE i < 6 LOOP
  dbe_output.print_line('i:' || i);
    i := i + 1;
    FOR j IN 1..5 LOOP
    dbe_output.print_line('j:' || j);
      CONTINUE outer_loop WHEN j > 2;
      FOR k IN 1..5 LOOP
        dbe_output.print_line('k:' || k);
        CONTINUE outer_loop WHEN k > 2;
      END LOOP;
    END LOOP;
  END LOOP;
END;
/

DECLARE
  aaa NUMBER;
  j   NUMBER;
BEGIN
  aaa := 2;
  j := 1;
  FOR i IN 1..5 LOOP
  dbe_output.print_line('i:' || i);
    <<outer_loop>>
    WHILE j < 6 LOOP
    dbe_output.print_line('j:' || j);
    j := j + 1;
      FOR k IN 1..5 LOOP
        dbe_output.print_line('k:' || k);
        CONTINUE outer_loop WHEN k > 2;
      END LOOP;
    END LOOP;
  END LOOP;
END;
/

DECLARE
  aaa NUMBER;
  j   NUMBER;
BEGIN
  aaa := 2;
  j := 1;
  FOR i IN 1..5 LOOP
  dbe_output.print_line('i:' || i);
    <<outer_loop>>
    WHILE j < 6 LOOP
    dbe_output.print_line('j:' || j);
    j := j + 1;
      FOR k IN 1..5 LOOP
        dbe_output.print_line('k:' || k);
        FOR l IN 1..5 LOOP
          dbe_output.print_line('l:' || l);
          EXIT outer_loop WHEN l > 2;
        END LOOP;
      END LOOP;
    END LOOP;
  END LOOP;
END;
/

DECLARE
  aaa NUMBER;
  j   NUMBER;
  bbb NUMBER;
BEGIN
  aaa := 2;
  j := 1;
  bbb := 0;
  <<my_label>>
  bbb := bbb + 1;
  dbe_output.print_line('bbb:' || bbb);
  FOR i IN 1..5 LOOP
  dbe_output.print_line('i:' || i);
    <<outer_loop>>
    WHILE j < 6 LOOP
    dbe_output.print_line('j:' || j);
    j := j + 1;
      FOR k IN 1..5 LOOP
        dbe_output.print_line('k:' || k);
        FOR l IN 1..5 LOOP
          dbe_output.print_line('l:' || l);
          EXIT outer_loop WHEN bbb = 2;
          GOTO my_label;
        END LOOP;
      END LOOP;
    END LOOP;
  END LOOP;
END;
/
--end

--test goto with label invalid
--begin
DECLARE
  bbb NUMBER;
BEGIN
  bbb := 1;
  dbe_output.print_line('bbb:' || bbb);
  GOTO my_label;
  FOR i IN 1..5 LOOP
    <<my_label>>
    bbb := bbb + 1;
    dbe_output.print_line('bbb:' || bbb);
  END LOOP;
END;
/

DECLARE
  bbb NUMBER;
BEGIN
  bbb := 1;
  dbe_output.print_line('bbb:' || bbb);
  GOTO my_label;
  WHILE bbb < 5 LOOP
    <<my_label>>
    bbb := bbb + 1;
    dbe_output.print_line('bbb:' || bbb);
  END LOOP;
END;
/

DECLARE
  bbb NUMBER;
BEGIN
  bbb := 1;
  dbe_output.print_line('bbb:' || bbb);
  GOTO my_label;
  IF bbb = 1 THEN
    <<my_label>>
    dbe_output.print_line('bbb = 1');
    bbb := bbb + 1;
  ELSIF bbb = 2 THEN
    dbe_output.print_line('bbb = 2');
  END IF;
END;
/

DECLARE
  bbb NUMBER;
BEGIN
  bbb := 1;
  dbe_output.print_line('bbb:' || bbb);
  IF bbb = 1 THEN
    <<my_label>>
    dbe_output.print_line('bbb = 1');
    bbb := bbb + 1;
  ELSIF bbb = 2 THEN
    GOTO my_label;
    dbe_output.print_line('bbb = 2');
  END IF;
END;
/

DECLARE
  bbb NUMBER;
BEGIN
  bbb := 3;
  dbe_output.print_line('bbb:' || bbb);
  CASE bbb
  WHEN 1 THEN
    <<my_label>>
    dbe_output.print_line('bbb = 1');
    bbb := bbb + 1;
  WHEN 2 THEN
    dbe_output.print_line('bbb = 2');
    bbb := bbb + 1;
    GOTO my_label;
  ELSE
    dbe_output.print_line('bbb = 3');
  END CASE;
END;
/

DECLARE
  aaa NUMBER;
BEGIN
  aaa := 2;
  <<my_label>>
  FOR l IN 1..3 LOOP
    GOTO my_label;
    dbe_output.print_line('l:' || l);
  END LOOP;
  <<my_label>>
  aaa := 3;
END;
/

DECLARE
  aaa NUMBER;
BEGIN
  aaa := 2;
  BEGIN
  FOR l IN 1..3 LOOP
    GOTO my_label;
    dbe_output.print_line('l:' || l);
  END LOOP;
  END;
  aaa := 3;
EXCEPTION
  when no_data_found then
    <<my_label>>
    dbe_output.print_line(aaa);
END;
/

DECLARE
  aaa NUMBER := 2;
  bbb NUMBER := 0;
BEGIN
  BEGIN
    aaa := 1;
  END;
  aaa := aaa / bbb;
EXCEPTION
  WHEN no_data_found THEN
    LOOP
      <<my_label>>
      dbe_output.print_line(aaa);
      EXIT;
    END LOOP;
  WHEN ZERO_DIVIDE  THEN
    GOTO my_label;
    dbe_output.print_line(aaa);
END;
/

DECLARE
  aaa NUMBER := 2;
  bbb NUMBER := 0;
BEGIN
  BEGIN
    aaa := 1;
  END;
  aaa := aaa / bbb;
EXCEPTION
  WHEN no_data_found THEN
    LOOP
      <<my_label>>
      dbe_output.print_line(aaa);
      EXIT;
    END LOOP;
  WHEN ZERO_DIVIDE  THEN
    GOTO my_label;
    dbe_output.print_line(aaa);
END;
/

DECLARE
  stock_price   NUMBER := 9.73;
  net_earnings  NUMBER := 0;
  pe_ratio      NUMBER;
BEGIN
    goto exception2;  ---goto
    pe_ratio := stock_price / net_earnings;  -- raises ZERO_DIVIDE exception
    dbe_output.print_line('Price/earnings ratio = ' || pe_ratio);
EXCEPTION
  WHEN ZERO_DIVIDE THEN
    begin
    dbe_output.print_line('Company had zero earnings;SQL_ERR_CODE is:'||SQL_ERR_CODE||'SQL_ERR_MSG is:'||SQL_ERR_MSG);
    pe_ratio := NULL;
 pe_ratio := stock_price / net_earnings;  -- raises ZERO_DIVIDE exception
     <<exception2>>  
  exception
    WHEN ZERO_DIVIDE THEN
     begin
     dbe_output.print_line('Company had zero earnings;SQL_ERR_CODE is:'||SQL_ERR_CODE||'SQL_ERR_MSG is:'||SQL_ERR_MSG);
  pe_ratio := stock_price / net_earnings;  -- raises ZERO_DIVIDE exception
  for i in 1..5
  loop 
  exception
      WHEN ZERO_DIVIDE THEN
     exit;
    dbe_output.print_line('Company had zero earnings;SQL_ERR_CODE is:'||SQL_ERR_CODE||'SQL_ERR_MSG is:'||SQL_ERR_MSG);
     end loop;
     end;
 end;
END;
/
--end


--expect failed
drop table if exists plt_emp;
create table plt_emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
create or  replace procedure procedure3(a int) is
cursor mycursor is select * from plt_emp where empno != 123 and sal=10000;
b plt_emp%rowtype;
mysyscur  sys_refcursor;
strSQL1 varchar(1000);
strSQL2 varchar(1000);
begin
strSQL1 := 'select * from plt_emp  where  sal <> 10000';
strSQL2 := '';
 if a <= 10 then
   for i in mycursor
   loop
    dbe_output.print_line(i.ename||' is not 10000');
   end loop;
 elsif a >10 and a <100 then
  open mysyscur for  strSQL1;
  fetch mysyscur into  b;
  dbe_output.print_line(b.ename||' a > 10 and a < 100');
  close mysyscur;
 else
  open mysyscur for strSQL2;
  dbe_output.print_line('else a > 10 and a < 100');
 end if;
end;
/
call procedure3(10);
exec procedure3(100);
drop table if exists plt_emp;

--expect failed
drop table if exists plt_emp;
create table plt_emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
create or  replace procedure procedure3(a int) is
cursor mycursor is select * from plt_emp where empno != 123 and sal=10000;
b plt_emp%rowtype;
mysyscur  sys_refcursor;
strSQL1 varchar(1000);
strSQL2 varchar(1000);
begin
strSQL1 := 'select * from plt_emp  where  sal <> 10000';
strSQL2 := '';
 if a <= 10 then
   for i in mycursor
   loop
    dbe_output.print_line(i.ename||' is not 10000');
   end loop;
 elsif a >10 and a <100 then
  open mysyscur for  strSQL1;
  fetch mysyscur into  b;
  dbe_output.print_line(b.ename||' a > 10 and a < 100');
  close mysyscur;
 else
  open mysyscur for strSQL2;
  dbe_output.print_line('else a > 10 and a < 100');
 end if;
end;
/
call procedure3(10);
exec procedure3(100);
drop table if exists plt_emp;

--test 



--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0000(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0000(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0000(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0001(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0000(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0000(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0002(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0001(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0001(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0003(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0002(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0002(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0004(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0003(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0003(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0005(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0004(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0004(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0006(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0005(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0005(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0007(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0006(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0006(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0008(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0007(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0007(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0009(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0008(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0008(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0010(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0009(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0009(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0011(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0010(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0010(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0012(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0011(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0011(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0013(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0012(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0012(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0014(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0013(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0013(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0015(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0014(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0014(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0016(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0015(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0015(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0017(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0016(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0016(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0018(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0017(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0017(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0019(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0018(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0018(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0020(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0019(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0019(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0021(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0019(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0020(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0022(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0020(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0021(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0023(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0021(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0022(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0024(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0022(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0023(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0025(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0023(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0024(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0026(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0024(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0025(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0027(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0025(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0026(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0028(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0026(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0027(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0029(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0027(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0028(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0030(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0028(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0029(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0031(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0029(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0030(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0032(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0030(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0031(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0033(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0031(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0032(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0034(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0032(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0033(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0035(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0033(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0034(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0036(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0034(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0035(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0037(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0035(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0036(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0038(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0036(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0037(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0039(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0037(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0038(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0040(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0038(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0039(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
--
--select OBJECT_NAME, OBJECT_TYPE, STATUS from user_objects where OBJECT_NAME like 'P_RECURSIVE_CALL_OTHER%' order by OBJECT_NAME;
--
----expect success
--CREATE OR REPLACE PROCEDURE P_RECURSIVE_CALL_OTHER_0000(V_NUM IN OUT INT) IS
--  V_NUM_1 INT;
--  V_NUM_2 INT;
--BEGIN
--  V_NUM_1 := V_NUM - 1;
--  V_NUM_2 := V_NUM - 2;
--  IF V_NUM < 3 THEN
--     V_NUM := 1;
--  ELSE
--  P_RECURSIVE_CALL_OTHER_0000(V_NUM_1);
--  P_RECURSIVE_CALL_OTHER_0000(V_NUM_2);
--  V_NUM := V_NUM_1 + V_NUM_2;
--  END IF;
--END;
--/
----end;
--select OBJECT_NAME, OBJECT_TYPE, STATUS from user_objects where OBJECT_NAME like 'P_RECURSIVE_CALL_OTHER%' order by OBJECT_NAME;

create or replace procedure test_casewhen(score in int) as 
begin 
case when (score < 0) then dbe_output.print_line('aaa'); 
else dbe_output.print_line('bbb'); 
end case; 
end;
/

call test_casewhen(123);

create or replace procedure test_casewhen(score in int) as 
begin 
case score when (123) then dbe_output.print_line('aaa'); 
else dbe_output.print_line('bbb'); 
end case; 
end;
/

call test_casewhen(123);

--expect failed
drop table if exists PRE_EXCEPTION_012_T_01;
create table PRE_EXCEPTION_012_T_01(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into PRE_EXCEPTION_012_T_01 values(1,'zhangsan','doctor1',10000);

DECLARE
var_tmp varchar(10);
BEGIN
execute immediate 'update PRE_EXCEPTION_012_T_01 set sal=10000 where empno =1' into var_tmp ;
END;
/

DECLARE
var_tmp varchar(10);
BEGIN
execute immediate 'select empno,ename from PRE_EXCEPTION_012_T_01' into var_tmp ;
END;
/

DECLARE
var_tmp varchar(10);
BEGIN
execute immediate 123 into var_tmp ;
END;
/
--end

drop table if exists storage_transaction_anonymous_tbl_001;
create table storage_transaction_anonymous_tbl_001 (a int);
savepoint bb;
insert into storage_transaction_anonymous_tbl_001 values(0);
rollback to bb;

savepoint bb;
insert into storage_transaction_anonymous_tbl_001 values(0);
begin
insert into storage_transaction_anonymous_tbl_001 values(1);
savepoint aa;
insert into storage_transaction_anonymous_tbl_001 values(2);
rollback to aa;
insert into storage_transaction_anonymous_tbl_001 values(3);
end;
/
select * from storage_transaction_anonymous_tbl_001;

begin
insert into storage_transaction_anonymous_tbl_001 values(1);
savepoint aa;
insert into storage_transaction_anonymous_tbl_001 values(2);
rollback to savepoint aa;
insert into storage_transaction_anonymous_tbl_001 values(1);
end;
/
select * from storage_transaction_anonymous_tbl_001;
drop table storage_transaction_anonymous_tbl_001;

--test param num check
create or replace function dd(a float) return float
is
begin
return a;
end;
/
select dd(12,1);

--test select into binary to char,varchar convert
drop table if exists FVT_PROC_BINARY_TABLE_025;
create table FVT_PROC_BINARY_TABLE_025(
  T1 INT,
  T2 RAW(100)  
  );
INSERT INTO FVT_PROC_BINARY_TABLE_025 VALUES(1,'01AFFB6710114657895500101');

create or replace procedure FVT_PROC_BINARY_025() is
V1 CHAR(100);
V2 VARCHAR(100);
begin
  select T2 into V1 from FVT_PROC_BINARY_TABLE_025 where T1=1;
  dbe_output.print_line('V1=:'||V1);
  select T2 into V2 from FVT_PROC_BINARY_TABLE_025 where T1=1;
  dbe_output.print_line('V2=:'||V2);
  EXCEPTION
WHEN NO_DATA_FOUND THEN dbe_output.print_line('NO_DATA_FOUND');
end;
/

CALL FVT_PROC_BINARY_025();

drop table if exists FVT_PROC_BINARY_TABLE_025;
drop procedure if exists FVT_PROC_BINARY_025;

--test return/goto
drop table if exists test_aa;
drop table if exists test_bb;
create table test_aa(a int);
create table test_bb(a int);
insert into test_aa values(1);
commit;


DECLARE
  pe_ratio      NUMBER;
BEGIN
  for i in 1..10000 loop
	begin
	for item in (select a from test_aa)
	loop
	goto new;
	end loop;   
  end;
	<<new>>
	pe_ratio := 1;
 end loop;
END;
/
--end

--test nl with pending
--begin
drop table if exists pl_ww1;
CREATE TABLE pl_ww1 (F_INT1 INT, F_INT2 INT, F_INT3 INT, F_INT4 INT,F_CHAR VARCHAR(16));
INSERT INTO pl_ww1 VALUES(1,2,3,4,'ABCFDD');
INSERT INTO pl_ww1 VALUES(1,2,3,4,'ABCFDD');
COMMIT;

drop table if exists pl_ww2;        
CREATE TABLE pl_ww2 (F_INT1 INT, F_INT2 INT, F_INT3 INT, F_INT4 INT,F_CHAR VARCHAR(16));    
INSERT INTO pl_ww2 VALUES(1,2,3,4,'ABCFDD');
INSERT INTO pl_ww2 VALUES(1,2,3,4,'ABCFDD');
COMMIT;
create index ind_pl_ww2 on pl_ww2(f_int1);

create or replace function pl_len(msg in varchar2)
return number
as
begin
    return length(msg);
end;
/

create or replace procedure SP_R_AARU_A0JM(
v_PlanID in number,
v_NeGroupId in number)
as
        v_Temp_1 varchar2(50);
        v_Temp_2 NUMBER(10, 0);
        v_Temp_3 NUMBER(10, 0);
begin
    insert into pl_ww1 
         select neGroup.F_INT2, ruleSelf.f_int2, ruleSelf.F_INT3, '0', pl_len(ruleSelf.f_char) 
          from pl_ww1 ruleSelf
          join pl_ww2 neGroup on ruleSelf.F_INT1 = neGroup.F_INT1
          where pl_len(neGroup.f_char) > 99;
end;
/

explain select neGroup.F_INT2, ruleSelf.f_int2, ruleSelf.F_INT3, '0', pl_len(ruleSelf.f_char) 
          from pl_ww1 ruleSelf
          join pl_ww2 neGroup on ruleSelf.F_INT1 = neGroup.F_INT1
          where pl_len(neGroup.f_char) > 99;

BEGIN SP_R_AARU_A0JM(1,2); END;
/

--end

--
drop table if exists T_TP_CELLDCCC_B4;
create table T_TP_CELLDCCC_B4(OPERTYPE NUMBER(3),PLANID NUMBER(10),CMENEID NUMBER(10),CELLID NUMBER(17),BEPWRMARGIN NUMBER(3),ULFULLCVRRATE NUMBER(3),DLFULLCVRRATE NUMBER(3),COMBPWRMARGIN NUMBER(3),DRASWITCH NUMBER(17),BEABNOMH2FSWITCH NUMBER(3),ULDCCCRATETHD NUMBER(3),ULMIDRATECALC NUMBER(3),ULMIDRATETHD NUMBER(3),ULEVENT4ATHLD NUMBER(3),ULEVENT4BTHLD NUMBER(3),DLEVENT4ATHLD NUMBER(3),DLEVENT4BTHLD NUMBER(3),ULMIDRATE2THD NUMBER(3),LOGUPTID  VARCHAR(383),NBI_RECID NUMBER(10),ISGENMML  NUMBER(3),CMEREMARK VARCHAR(383),DATASOURCETYPE NUMBER(3),CMERESERVED1   VARCHAR(383));
drop table if exists T_P_DCCC_B4;
create table T_P_DCCC_B4(PLANID NUMBER(10)  ,CMENEID NUMBER(10) ,ULMIDRATETHD NUMBER(3) ,DLMIDRATETHD NUMBER(3) ,ULDCCCRATETHD NUMBER(3) ,DLDCCCRATETHD NUMBER(3) ,LITTLERATETHD NUMBER(3) ,DCCCSTG NUMBER(3) ,HSUPADCCCSTG NUMBER(3) ,BEPWRMARGIN NUMBER(3) ,ULRATEUPADJLEVEL NUMBER(3) ,ULRATEDNADJLEVEL NUMBER(3) ,ULMIDRATECALC NUMBER(3) ,DLRATEUPADJLEVEL NUMBER(3) ,DLRATEDNADJLEVEL NUMBER(3) ,DLMIDRATECALC NUMBER(3) ,FAILTIMETH NUMBER(3) ,MONITIMELEN NUMBER(10) ,DCCCUPPENALTYLEN NUMBER(10) ,ULFULLCVRRATE NUMBER(3) ,DLFULLCVRRATE NUMBER(3) ,HSUPABESHORATETHD NUMBER(3) ,DCHTHROUMEASPERIOD NUMBER(10) ,COMBPWRMARGIN NUMBER(3) ,E2DTHROU4BTHD NUMBER(10) ,CHANNELRETRYPENALTYNUM NUMBER(3) ,BASECOVERD2E6ATHD NUMBER(3) ,BASECOVERD2E6BTHD NUMBER(3) ,LITTLERATECHLFLBKFORCSPS NUMBER(3) ,CSPS0KDLRATEUPTHLD NUMBER(10) ,CSPS0KULRATEUPTHLD NUMBER(10) ,TIMETOTRIGGER4AFORCSPSCMB NUMBER(3) ,TRIGTIMEFORPSDCH0KRATEUP NUMBER(10) ,DCHCONGSTATETHD NUMBER(3) ,CSPSBEDCCCPROHTIMER NUMBER(10) ,DLMIDRATE2THD NUMBER(3) ,ULMIDRATE2THD NUMBER(3) ,DCHTHROUENHMEASPERIOD NUMBER(10) ,DCHTHROUENHTIMETOTRIG4A NUMBER(10) ,DCHTHROUENHTIMETOTRIG4B NUMBER(10) ,DCHTHROUENHUPTHDRATIO NUMBER(3) ,DCHTHROUENHDNTHDRATIO NUMBER(3));
drop table if exists T_P_CORRMALGOSWITCH_B4;
create table T_P_CORRMALGOSWITCH_B4(PLANID NUMBER(10) ,CMENEID NUMBER(10) ,MAPSWITCH NUMBER(17) ,HOSWITCH NUMBER(17) ,PCSWITCH NUMBER(17) ,CFGSWITCH NUMBER(17) ,DRASWITCH NUMBER(17) ,SRNSRSWITCH NUMBER(17) ,CMCFSWITCH NUMBER(17) ,PSSWITCH NUMBER(17) ,CSSWITCH NUMBER(17) ,DRSWITCH NUMBER(17) ,CMPSWITCH NUMBER(17) ,RESERVEDSWITCH0 NUMBER(17) ,RESERVEDSWITCH1 NUMBER(17) ,RESERVEDU32PARA0 NUMBER(17) ,RESERVEDU32PARA1 NUMBER(17) ,RESERVEDU8PARA0 NUMBER(3) ,RESERVEDU8PARA1 NUMBER(3) ,CMPSWITCH2 NUMBER(17) ,HOSWITCH1 NUMBER(17) ,DRASWITCH2 NUMBER(17) ,PCSWITCH1 NUMBER(17) ,CMPSWITCH3 NUMBER(17) ,IRATHOCFGSWITCH NUMBER(17) ,HOSWITCH2 NUMBER(17) ,CFGSWITCH1 NUMBER(17) ,DRASWITCH3 NUMBER(17));
drop table if exists T_P_CELLDCCC_B4;
create table T_P_CELLDCCC_B4(PLANID NUMBER(10) ,CMENEID  NUMBER(10) ,CELLID  NUMBER(17) ,BEPWRMARGIN NUMBER(3) ,ULFULLCVRRATE NUMBER(3) ,DLFULLCVRRATE NUMBER(3) ,COMBPWRMARGIN NUMBER(3) ,DRASWITCH NUMBER(17) ,BEABNOMH2FSWITCH NUMBER(3) ,ULDCCCRATETHD NUMBER(3) ,ULMIDRATECALC NUMBER(3) ,ULMIDRATETHD NUMBER(3) ,ULEVENT4ATHLD NUMBER(3) ,ULEVENT4BTHLD NUMBER(3) ,DLEVENT4ATHLD NUMBER(3) ,DLEVENT4BTHLD NUMBER(3) ,ULMIDRATE2THD NUMBER(3)); 

begin  
  merge into T_TP_CELLDCCC_B4 a
  using T_P_DCCC_B4 b
  on (a.PlanID = b.PlanID and a.CMENEID = b.CMENEID)
  when matched then
    update
       set a.BEPWRMARGIN   = nvl(a.BEPWRMARGIN, b.BEPWRMARGIN),
           a.COMBPWRMARGIN = nvl(a.COMBPWRMARGIN, b.COMBPWRMARGIN),
           a.DLFULLCVRRATE = nvl(a.DLFULLCVRRATE, b.DLFULLCVRRATE),
           a.ULDCCCRATETHD = nvl(a.ULDCCCRATETHD, b.ULDCCCRATETHD),
           a.ULFULLCVRRATE = nvl(a.ULFULLCVRRATE, b.ULFULLCVRRATE),
           a.ULMIDRATE2THD = nvl(a.ULMIDRATE2THD, b.ULMIDRATE2THD),
           a.ULMIDRATECALC = nvl(a.ULMIDRATECALC, b.ULMIDRATECALC),
           a.ULMIDRATETHD  = nvl(a.ULMIDRATETHD, b.ULMIDRATETHD)
     where a.PlanID = 131
       and a.OperType = 2;
       
  merge into T_TP_CELLDCCC_B4 a
  using T_P_CORRMALGOSWITCH_B4 b
  on (a.PlanID = b.PlanID and a.CMENEID = b.CMENEID)
  when matched then
    update set a.DRASWITCH = case
  when a.DRASWITCH = b.DRASWITCH then a.DRASWITCH else bitand(bitxor(to_number(a.DRASWITCH), to_number(b.DRASWITCH)), 127) end where a.PlanID = 131 and a.OperType = 2;
  
  merge into T_TP_CELLDCCC_B4 a
  using T_P_CELLDCCC_B4 b
  on (a.PlanID = b.PlanID and a.CMENEID = b.CMENEID and a.CELLID = b.CELLID)
  when matched then
    update
       set a.DRASWITCH = case
  when a.DRASWITCH = 0 then b.DRASWITCH else(bitxor(to_number(a.DRASWITCH), to_number(nvl(b.DRASWITCH, 0)))) end where a.PlanID = 131 and a.OperType = 1;
end;
/

--test pl compile with hint
--begin
drop table if exists pl_tab;
drop table if exists pl_tbb;
create table pl_tab (a int not null);
create table pl_tbb (a int not null);
insert into pl_tab(a) values(3);
insert into pl_tab(a) values(1);
insert into pl_tab(a) values(2);
commit;
create index idx_pl_tab on pl_tab(a);

Create Or Replace Procedure TEST_PL_HINT
AS
	var number := 3;
	c1 SYS_REFCURSOR;
begin
	OPEN c1 FOR Select /*+index(pl_tab idx_pl_tab)*/ * From pl_tab;
	dbe_sql.return_cursor (c1);
	update /*+index(pl_tab idx_pl_tab)*/ pl_tab set a = 3 where a=var;
	insert /*+ parallel(pl_tbb 2) */ into pl_tbb (select /*+index(pl_tab idx_pl_tab)*/ a from pl_tab);
	delete /*+index(pl_tab idx_pl_tab)*/ from pl_tab where a=1;
	commit;
end; 
/


exec TEST_PL_HINT();
select * from pl_tab order by a;
select * from pl_tbb order by a;

select count(*) from v$sqlarea where sql_text='select /*+index(pl_tab idx_pl_tab)*/ * from pl_tab';
select count(*) from v$sqlarea where sql_text='update /*+index(pl_tab idx_pl_tab)*/ pl_tab set a=3 where a=:1';
select count(*) from v$sqlarea where sql_text='insert /*+parallel(pl_tbb 2) */ into pl_tbb (select /*+index(pl_tab idx_pl_tab)*/ a from pl_tab)';
select count(*) from v$sqlarea where sql_text='delete /*+index(pl_tab idx_pl_tab)*/ from pl_tab where a=1';
--end

--test pl USER_ARGUMENTS veiw
CREATE or replace procedure proc_003(n0 int,n1 varchar,nu2 char,n3 out number  ,n4  out boolean  ,n5 out date,n6  number ,n7 REAL) as
sqlst varchar(500);
BEGIN
  sqlst := 'proc_002 test';
END;
/
select * from USER_ARGUMENTS where OBJECT_NAME = 'PROC_003'; 

--begin

drop table if exists ToClob_T2;
create table ToClob_T2(f2 clob);

select * from ToClob_T2 where f2>to_clob('11111111191111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111') order by to_char(f2);
--end

--test sys_stack
--alter system set _LOG_LEVEL = 255;
drop table if exists sys_stack_t;
create table sys_stack_t(c1 int, c2 varchar(10));
drop function if exists test_sys_stack_01;
drop function if exists test_sys_stack_02;
drop function if exists test_sys_stack_03;
drop function if exists test_sys_stack_04;
drop function if exists test_sys_stack_05;
drop function if exists test_sys_stack_06;
drop function if exists test_sys_stack_07;
drop function if exists test_sys_stack_08;
drop function if exists test_sys_stack_09;

create or replace function test_sys_stack_02(p1 int) return int is
v1 int;
begin
  select test_sys_stack_03(c1) into v1 from sys_stack_t where c2 = 'abc';
  return (v1 + p1);
end;
/

create or replace function test_sys_stack_03(p1 int) return int is
v1 int;
begin
  select test_sys_stack_04(c1) into v1 from sys_stack_t where c2 = 'ijk';
  return (v1 + p1);
end;
/

create or replace function test_sys_stack_04(p1 int) return int is
v1 int;
begin
  select test_sys_stack_05(c1) into v1 from sys_stack_t where c2 = 'lmn';
  return (v1 + p1);
end;
/

create or replace function test_sys_stack_05(p1 int) return int is
v1 int;
begin
  select test_sys_stack_06(c1) into v1 from sys_stack_t where c2 = 'opq';
  return (v1 + p1);
end;
/

create or replace function test_sys_stack_06(p1 int) return int is
v1 int;
begin
  select test_sys_stack_07(c1) into v1 from sys_stack_t where c2 = 'opq';
  return (v1 + p1);
end;
/

create or replace function test_sys_stack_07(p1 int) return int is
v1 int;
begin
  select test_sys_stack_08(c1) into v1 from sys_stack_t where c2 = 'opq';
  return (v1 + p1);
end;
/

create or replace function test_sys_stack_08(p1 int) return int is
v1 int;
begin
  select test_sys_stack_09(c1) into v1 from sys_stack_t where c2 = 'opq';
  return (v1 + p1);
end;
/

create or replace function test_sys_stack_09(p1 int) return int is
v1 int;
begin
  select c3 into v1 from sys_stack_t where c2 = 'opq';
  return (v1 + p1);
end;
/

create or replace function test_sys_stack_01(p1 int) return int is
begin
  insert into sys_stack_t(c1,c2) values(test_sys_stack_02(1), 'efg');
  return p1;
end;
/

drop table if exists sys_stack_t;
--end

-- test for range
declare
begin
  for i in 2147483646..2147483647
  loop
    dbe_output.print_line(i);
  end loop;
end;
/

declare
begin
  for i in 2147483647..2147483648
  loop
    dbe_output.print_line(i);
  end loop;
end;
/

declare
begin
  for i in reverse -2147483648..-2147483647
  loop
    dbe_output.print_line(i);
  end loop;
end;
/

declare
begin
  for i in reverse -2147483649..-2147483648
  loop
    dbe_output.print_line(i);
  end loop;
end;
/
--end 


--test.1 ctsql with nested put_line behind fetch process
conn sys/Huawei@123@127.0.0.1:1611
drop table if exists test_ctsql_plsql_ex_0121;
drop user if exists test_ctsql_nested_putline cascade;
create user test_ctsql_nested_putline identified by root_1234;
grant all privileges to test_ctsql_nested_putline;
conn test_ctsql_nested_putline/root_1234@127.0.0.1:1611

drop table if exists test_t;
create table test_t(a int,b varchar(20));
insert into test_t values(1,'liu');

create or replace function r_len(str1 varchar) return int
is 
begin
dbe_output.print_line('nested input: '||str1);
dbe_output.print_line('nested input1:'||str1);
return length(str1);
end;
/

create or replace function r_cur(str1 varchar) return sys_refcursor
is 
cursor1 sys_refcursor;
begin
dbe_output.print_line('outer layer input: '||str1);
dbe_output.print_line('outer layer input1:'||str1);
open cursor1 for select r_len(test_t.b) from test_t;
return cursor1;
end;
/

select r_cur('aaaa');

--test.2 ctsql with nested put_line behind fetch process
create table DEPENDENCY_COMPILE_004_TAB_01(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into DEPENDENCY_COMPILE_004_TAB_01 values(1,'zhangsan','doctor1',10000);
insert into DEPENDENCY_COMPILE_004_TAB_01 values(2,'zhangsan2','doctor2',10000);
insert into DEPENDENCY_COMPILE_004_TAB_01 values(123,'zhangsan3','doctor3',10000);
insert into DEPENDENCY_COMPILE_004_TAB_01 values(11,'zhansi','doctor1',10000);
insert into DEPENDENCY_COMPILE_004_TAB_01 values(22,'lisiabc','doctor2',10000);
insert into DEPENDENCY_COMPILE_004_TAB_01 values(33,'zhangwu123','doctor3',10000);
insert into DEPENDENCY_COMPILE_004_TAB_01 values(10,'abc','worker',9000);
insert into DEPENDENCY_COMPILE_004_TAB_01 values(76,'ZHANGSAN','leader',20000);
commit;

create or replace view DEPENDENCY_COMPILE_004_VIEW_01 as select * from DEPENDENCY_COMPILE_004_TAB_01;
create or replace function DEPENDENCY_COMPILE_004_FUN_01 (str1 varchar) return int 
is 
mycursor1 sys_refcursor;
a int;
begin
 select empno into a from DEPENDENCY_COMPILE_004_VIEW_01;
   dbe_output.print_line(a);
   exception
   when  TOO_MANY_ROWS  then
   begin
      select empno into a from DEPENDENCY_COMPILE_004_VIEW_01 limit 1;
     dbe_output.print_line('here nested '||a);
     return length(str1);
   end;
end;
/

create or replace function DEPENDENCY_COMPILE_004_FUN_02 (str1 varchar) return sys_refcursor
is 
cursor1 sys_refcursor;
begin
open cursor1 for select DEPENDENCY_COMPILE_004_FUN_01(ename) from DEPENDENCY_COMPILE_004_TAB_01;
return cursor1;
end;
/
select DEPENDENCY_COMPILE_004_FUN_02('a');

--test.3 ctsql with nested put_line behind fetch process
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
drop user if exists test_ctsql_nested_putline cascade;

-- test convert sql in pl
create or replace function fun_stack_depth_000(num int) return int
is
 v_lang int := 0;
BEGIN
  select (((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((1+1)+1)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) into v_lang from dual;
  return v_lang;
END;
/

begin 
delete t_tmp_CMENEID where PlanID = 7;
insert into t_tmp_CMENEID (PlanID,CMENEID,LOGICRNCID) select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLFRC_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_PRACHACTOASCMAP_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLOPERHOCOV_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UNODEBGPS_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLADAPTRACH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLCONGACALGO_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLINTRAFREQHO_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLHHONCELLPAOPT_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLHSDPCCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_SCPICH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLIDLEMODETIMER_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_BCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLHCSHO_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLREDRRCREL_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLCHLQUALITY_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLALGOSWITCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLSELRESEL_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLMEAS_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLPLMNREDRRCREL_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLINTERFREQPRIO00_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLACCESSSTRICT_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLSMARTALGPARA_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLOLC_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLHSUPA_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLANR_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLAUTONCELLDETECT_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_PCHDYNTFS_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_PICH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_FACH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLCOALGOENHPARA_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CHRSCOPECTRL_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLHCS_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLAMRC_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLHOCOMM_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CHPWROFFSET_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLEPCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLQUALITYMEAS_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLCAC_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLMBMSFACH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UUNIDLELAYERPGCELL_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLCMCF_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLDISTANCEREDIRE00_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_PRACHSLOTFORMAT_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLGUDLINTERFCTRL_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_PCCPCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_RACHDYNTFS_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_SCCPCHTFC_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLMULTIRABHOCOV_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLALGOOPTSWITCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLMBMS_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLFSTDRMTIMER_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLCBS_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLPCOPTPARA_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLLDM_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLMCLDR_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLMBMSSA_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLPPAC_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLLDR_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLFLEXUEGROUPPARA_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLMOCNDPAPOWERD00_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLUESTATETRANS_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLPUC_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLERACHHSDPCCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLHOFORHSMUE_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_MRSCOPECTRL_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLALTIMER_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLINTERFREQHOCOV_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_PRACHASC_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLCLB_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLREDIRECTION_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLRLREESTSWITCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLAMRBLACKBOXCTRL_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLDCCC_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLLDB_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLEDRX_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLCONNALGOPARA_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELL_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLCOVAREAMAP_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_NCELLDETECTSWITCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_PRACHBASIC_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLDRD_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLMBDRINTERRAT_C6 a  where a.PlanID = 7 union select distincta.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CTCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLFACHCONGCTRL_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLOPERALGOSWITCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLDYNSHUTDOWN_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLLDMPARA_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_PSCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLU2LTEHOCOV_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLSIBSWITCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLRESGRP_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLEFACH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLGPSFRMTIMING_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_AICH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLALGORSVPARA_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLRLACTTIME_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLCMUSERNUM_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLUECAPREDIRECT00_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLGUCOORDNCTRL_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLCONNREDIR_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLSTATETIMER_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLMIMO_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLQOSHO_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLINTERANR_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLINTERRATDR_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLMR_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLIPDL_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLSEREXPCAC_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLINTERRATHOCOV_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_FACHDYNTFS_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLGUULINTERFCTRL_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_PCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_PRACHTFC_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLCBSSAC_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLMBSCCRRM_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLINTERFREQHONCOV_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLULB_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLDSACMANUALPARA_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLPARTNERDEMAR_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLRLPWR_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLWLAN_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLMBDRINTERFREQ_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_PCPICH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLCONNMODETIMER_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLQUEUEPREEMPT_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLINTERRATHONCOV_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLMBMSPARA_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLMOCNSFDEMAR_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLINTRAFREQHOENH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_ERACHBASIC_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLDRDMIMO_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLU2LTEHONCOV_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLMCCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLAMRCWB_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLERACH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLCBSDRX_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_SSCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLNFREQPRIOINFO_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLFCALGOPARA_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLGSMFREQPRIOINFO_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLMOCNPWRDEMAR_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_SCCPCHBASIC_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLHSDPA_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLPCSWITCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_RACH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_SMLCCELL_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLDESENSE_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLLICENSE_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLMBMSSCCPCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLPLMNREDGSM_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_CELLMCDRD_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_FACHLOCH_C6 a  where a.PlanID = 7 union select distinct a.PlanID, a.CMENEID ,nvl(a.LOGICRNCID, -1) from t_TP_UCELLINTRANCELLPAOPT_C6 a  where a.PlanID = 7;
end;
/
--end

--test function can not used directly in plsql DTS2019012112199
--begin

CREATE OR REPLACE FUNCTION PL_FUNC_1(a int) return INT
IS
 Begin 
 return a + 1;
 End;
/


--expect error
begin
DBE_STATS.AUTO_SAMPLE_SIZE;
end;
/

--expect error
begin
PL_FUNC_1(1);
end;
/
--end


--begin
drop table if exists pl_conv_intv;
create table pl_conv_intv
(
SNAP_ID                             INTEGER,
FLUSH_ELAPSED                       INTERVAL DAY(5) TO SECOND(1)
);


insert into pl_conv_intv values(1, NUMTODSINTERVAL(10, 'DAY'));
commit;

BEGIN
	  FOR ITEM IN (SELECT * FROM pl_conv_intv) LOOP
	    dbe_output.print_line(item.SNAP_ID||'_'||item.FLUSH_ELAPSED);
	END LOOP;

END;
/
--end

--test case: test subsql in plsql
CREATE OR REPLACE FUNCTION TEST_SOFT_PARSE_SUBSQL_F1 RETURN NUMERIC IS A NUMERIC ;
BEGIN
return 3;
END TEST_SOFT_PARSE_SUBSQL_F1;
/

--expect 3 
DECLARE A NUMERIC;
BEGIN
SELECT TEST_SOFT_PARSE_SUBSQL_F1() INTO A FROM DUAL;
dbe_output.print_line(A);
END;
/

CREATE OR REPLACE FUNCTION TEST_SOFT_PARSE_SUBSQL_F1 RETURN NUMERIC IS A NUMERIC ;
BEGIN
return 1;
END TEST_SOFT_PARSE_SUBSQL_F1;
/

--expect 1
DECLARE A NUMERIC;
BEGIN
SELECT TEST_SOFT_PARSE_SUBSQL_F1() INTO A FROM DUAL;
dbe_output.print_line(A);
END;
/ 

DROP FUNCTION IF EXISTS TEST_SOFT_PARSE_SUBSQL_F1;
--end

--test case: test hint used in plsql
--begin
drop table if exists pl_hint_t1;
drop table if exists pl_hint_t2;
drop table if exists pl_hint_t3;
create table pl_hint_t1(f1 int, f2 varchar2(32));
create table pl_hint_t2(f1 int, f2 varchar2(32));
create table pl_hint_t3(f1 int, f2 varchar2(32));

create index idx_pl_hint2_1 on pl_hint_t2(f1);
create index idx_pl_hint2_2 on pl_hint_t2(f1,f2);

BEGIN
	insert INTO pl_hint_t1(f1) SELECT /*+leading(b)*/ b.f1 FROM pl_hint_t2 b join pl_hint_t3 c on b.f1 = c.f1;
	insert INTO pl_hint_t1 SELECT /*+leading(b)*/ b.* FROM pl_hint_t2 b join pl_hint_t3 c on b.f1 = c.f1;
	MERGE INTO pl_hint_t1 a	USING (SELECT /*+INDEX(t,idx_pl_hint2_2)*/ t.* FROM pl_hint_t2 t) b
	ON (a.f1=b.f1)
	WHEN MATCHED THEN 
	UPDATE SET a.f2='test';
END; 
/

--expect 2
select count(*) from v$sqlarea where sql_text like 'insert%t1%leading(b)%';
--expect 1
select count(*) from v$sqlarea where sql_text like 'merge%t1%INDEX(t,idx_pl_hint2_2)%';

--end
--test procedure autonomous transaction
--A is autonomous transaction, B is not autonomous transaction, and there is not commit or rollback, expect throw error
DROP TABLE IF EXISTS t_auton;
CREATE TABLE t_auton (test_value VARCHAR2(25));
CREATE OR REPLACE PROCEDURE A_block IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO t_auton (test_value) VALUES ('A block insert');
END A_block;
/

CREATE OR REPLACE PROCEDURE B_block IS
BEGIN
  INSERT INTO t_auton (test_value) VALUES ('B block insert');
  A_block;
  ROLLBACK;
END B_block;
/

exec B_block;
SELECT * FROM t_auton order by test_value;
drop procedure A_block;
drop procedure B_block;
drop table t_auton;

--A is autonomous transaction, B is not autonomous transaction, and there is not commit or rollback, and error not handle, expect error
CREATE TABLE t_auton (test_value VARCHAR2(25));
CREATE OR REPLACE PROCEDURE A_block IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO t_auton (test_value) VALUES ('A block insert');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
	    dbe_output.print_line('error ocurred');
END A_block;
/

CREATE OR REPLACE PROCEDURE B_block IS
BEGIN
  INSERT INTO t_auton (test_value) VALUES ('B block insert');
  A_block;
  ROLLBACK;
END B_block;
/

exec B_block;
SELECT * FROM t_auton order by test_value;
drop procedure A_block;
drop procedure B_block;
drop table t_auton;

--autonomous transaction must has commit or rollback in the end
CREATE TABLE t_auton (test_value VARCHAR2(25));
CREATE OR REPLACE PROCEDURE A_block IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO t_auton (test_value) VALUES ('A block insert');
  COMMIT;
  DELETE FROM t_auton where test_value = 'B block insert';
END A_block;
/

CREATE OR REPLACE PROCEDURE B_block IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO t_auton (test_value) VALUES ('B block insert');
  A_block;
  ROLLBACK;
END B_block;
/

exec B_block;
SELECT * FROM t_auton order by test_value;
drop procedure A_block;
drop procedure B_block;
drop table t_auton;

--has dml clause after commit
CREATE TABLE t_auton (test_value VARCHAR2(25));
CREATE OR REPLACE PROCEDURE A_block IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO t_auton (test_value) VALUES ('A block insert');
  COMMIT;
 execute immediate 'insert into t_auton values (''dynamic sql insert'')';
END A_block;
/

exec A_block;
SELECT * FROM t_auton order by test_value;
drop procedure A_block;
drop table t_auton;

--anoymous block called another and both are autonomous transaction, it is forrbidden
CREATE TABLE t_auton (test_value VARCHAR2(30));
DECLARE
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO t_auton (test_value) VALUES ('A block insert');
  COMMIT;
  DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
  Begin
      INSERT INTO t_auton (test_value) VALUES ('xxxxxxxxxx');
	  COMMIT;
  end;
END;
/

SELECT * FROM t_auton order by test_value;

drop table t_auton;

--only top stack anoymous block can be autonomous transaction
CREATE TABLE t_auton (test_value VARCHAR2(30));
DECLARE
BEGIN
  INSERT INTO t_auton (test_value) VALUES ('top anonmous block insert');
  COMMIT;
  DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
  Begin
      INSERT INTO t_auton (test_value) VALUES ('inner anonmous block insert');
	  COMMIT;
  end;
END;
/
SELECT * FROM t_auton order by test_value;

--only top stack anoymous block can be autonomous transaction
 CREATE TABLE t_auton (test_value VARCHAR2(30));
DECLARE
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO t_auton (test_value) VALUES ('A block insert');
  COMMIT;
 execute immediate 'insert into t_auton values (''dynamic sql insert'')';
END;
/

SELECT * FROM t_auton order by test_value;
drop table t_auton;

--only top stack anoymous block can be autonomous transaction
CREATE TABLE t_auton (test_value VARCHAR2(30));
DECLARE
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO t_auton (test_value) VALUES ('top anonmous block insert');
  COMMIT;
  DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
  Begin
      INSERT INTO t_auton (test_value) VALUES ('inner anonmous block insert');
	  COMMIT;
  end;
END;
/

SELECT * FROM t_auton order by test_value;
drop table t_auton;

--test the autonomous transaction exceed the max defualt vale expect throw error
CREATE OR REPLACE PROCEDURE auton_block0 IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  dbe_output.print_line('5555555');
  COMMIT;
END;
/

DECLARE 
    COUNT INT := 9;
	i int;
	strsql varchar2(1000);
BEGIN 
	FOR i in 1..COUNT loop
	  strsql := 'create or replace procedure auton_block'|| i || ' is a int := 1; PRAGMA AUTONOMOUS_TRANSACTION; begin auton_block' || (i-1) || '; commit;end';
	  execute immediate strsql;
	  execute immediate 'commit';
	end loop;
end;
/


exec auton_block9;

DECLARE 
    COUNT INT := 9;
	i int;
	strsql varchar2(1000);
BEGIN 
	FOR i in 0..COUNT loop
	  strsql := 'drop procedure auton_block'|| i;
	  execute immediate strsql;
	end loop;
end;
/

--test funcA called funcB by select clause
CREATE TABLE t_auton (test_value VARCHAR2(25));

CREATE OR REPLACE FUNCTION C_func RETURN INTEGER IS
PRAGMA AUTONOMOUS_TRANSACTION;
RET INTEGER;
BEGIN
   RET := 1;
  INSERT INTO t_auton (test_value) VALUES ('C func insert');
  COMMIT;
  RETURN RET;
END C_func;
/

CREATE OR REPLACE FUNCTION B_func RETURN INTEGER IS
RET INTEGER;
c int;
BEGIN
   RET := 1;
   c := C_func();
  INSERT INTO t_auton (test_value) VALUES ('B func insert');
  ROLLBACK;
  RETURN RET;
END B_func;
/

CREATE OR REPLACE FUNCTION A_func RETURN INTEGER IS
PRAGMA AUTONOMOUS_TRANSACTION;
RET INTEGER;
b int;
BEGIN
   RET := 1;
   select B_func() into b from dual;
  INSERT INTO t_auton (test_value) VALUES ('A func insert');
  COMMIT;
  RETURN RET;
END A_func;
/

SELECT A_func() from dual;
SELECT * FROM t_auton order by test_value;
drop function A_func;
drop function B_func;
drop function C_func;
drop table t_auton;

--test funcA called funcB by select clause, funcB called funcC by select clause
CREATE TABLE t_auton (test_value VARCHAR2(25));

CREATE OR REPLACE FUNCTION C_func RETURN INTEGER IS
PRAGMA AUTONOMOUS_TRANSACTION;
RET INTEGER;
BEGIN
   RET := 1;
  INSERT INTO t_auton (test_value) VALUES ('C func insert');
  COMMIT;
  RETURN RET;
END C_func;
/

CREATE OR REPLACE FUNCTION B_func RETURN INTEGER IS

RET INTEGER;
c int;
BEGIN
   RET := 1;
   select C_func() into c from dual;
  INSERT INTO t_auton (test_value) VALUES ('B func insert');
  ROLLBACK;
  RETURN RET;
END B_func;
/

CREATE OR REPLACE FUNCTION A_func RETURN INTEGER IS
PRAGMA AUTONOMOUS_TRANSACTION;
RET INTEGER;
b int;
BEGIN
   RET := 1;
   select B_func() into b from dual;
  INSERT INTO t_auton (test_value) VALUES ('A func insert');
  COMMIT;
  RETURN RET;
END A_func;
/

SELECT A_func() from dual;
SELECT * FROM t_auton order by test_value;
drop function A_func;
drop function B_func;
drop function C_func;
drop table t_auton;

--call func directly
CREATE TABLE t_auton (test_value VARCHAR2(25));
  CREATE OR REPLACE FUNCTION C_func RETURN INTEGER IS
RET INTEGER;
BEGIN
   RET := 1;
  INSERT INTO t_auton (test_value) VALUES ('C func insert');
  ROLLBACK;
  RETURN RET;
END C_func;
/

 CREATE OR REPLACE FUNCTION B_func RETURN INTEGER IS
 PRAGMA AUTONOMOUS_TRANSACTION;
RET INTEGER;
c int;
BEGIN
   RET := 1;
   c := C_func();
  INSERT INTO t_auton (test_value) VALUES ('B func insert');
  ROLLBACK;
  RETURN RET;
END B_func;
/

 CREATE OR REPLACE FUNCTION A_func RETURN INTEGER IS
RET INTEGER;
b int;
BEGIN
   RET := 1;
   b := B_func();
  INSERT INTO t_auton (test_value) VALUES ('A func insert');
  COMMIT;
  RETURN RET;
END A_func;
/

SELECT A_func() from dual;
SELECT * FROM t_auton order by test_value;
drop function A_func;
drop function B_func;
drop function C_func;
drop table t_auton;

--test funcA called funcB by select clause
CREATE TABLE t_auton (test_value VARCHAR2(25));

CREATE OR REPLACE FUNCTION C_func RETURN INTEGER IS

RET INTEGER;
BEGIN
   RET := 1;
  INSERT INTO t_auton (test_value) VALUES ('C func insert');
  COMMIT;
  RETURN RET;
END C_func;
/

CREATE OR REPLACE FUNCTION B_func RETURN INTEGER IS
PRAGMA AUTONOMOUS_TRANSACTION;
RET INTEGER;
c int;
BEGIN
   RET := 1;
   c := C_func();
  INSERT INTO t_auton (test_value) VALUES ('B func insert');
  ROLLBACK;
  RETURN RET;
END B_func;
/

CREATE OR REPLACE FUNCTION A_func RETURN INTEGER IS
RET INTEGER;
b int;
BEGIN
   RET := 1;
   select B_func() into b from dual;
  INSERT INTO t_auton (test_value) VALUES ('A func insert');
  COMMIT;
  RETURN RET;
END A_func;
/

SELECT A_func() from dual;
SELECT * FROM t_auton order by test_value;
drop function A_func;
drop function B_func;
drop function C_func;
drop table t_auton;

CREATE TABLE t_auton (test_value VARCHAR2(25));

CREATE OR REPLACE FUNCTION C_func RETURN INTEGER IS

RET INTEGER;
BEGIN
   RET := 1;
  INSERT INTO t_auton (test_value) VALUES ('C func insert');
  COMMIT;
  RETURN RET;
END C_func;
/

CREATE OR REPLACE FUNCTION B_func RETURN INTEGER IS
PRAGMA AUTONOMOUS_TRANSACTION;
RET INTEGER;
c int;
BEGIN
   RET := 1;
   select C_func() into c from dual;
  INSERT INTO t_auton (test_value) VALUES ('B func insert');
  ROLLBACK;
  RETURN RET;
END B_func;
/

CREATE OR REPLACE FUNCTION A_func RETURN INTEGER IS

RET INTEGER;
b int;
BEGIN
   RET := 1;
   b := B_func();
  INSERT INTO t_auton (test_value) VALUES ('A func insert');
  COMMIT;
  RETURN RET;
END A_func;
/

SELECT A_func() from dual;
SELECT * FROM t_auton order by test_value;
drop function A_func;
drop function B_func;
drop function C_func;
drop table t_auton;

CREATE TABLE t_auton (test_value VARCHAR2(25));

CREATE OR REPLACE FUNCTION C_func RETURN INTEGER IS

RET INTEGER;
BEGIN
   RET := 1;
  INSERT INTO t_auton (test_value) VALUES ('C func insert');
  COMMIT;
  RETURN RET;
END C_func;
/

CREATE OR REPLACE FUNCTION B_func RETURN INTEGER IS
PRAGMA AUTONOMOUS_TRANSACTION;
RET INTEGER;
c int;
BEGIN
   RET := 1;
   select C_func() into c from dual;
  INSERT INTO t_auton (test_value) VALUES ('B func insert');
  ROLLBACK;
  RETURN RET;
END B_func;
/

CREATE OR REPLACE FUNCTION A_func RETURN INTEGER IS

RET INTEGER;
b int;
BEGIN
   RET := 1;
   select B_func() into b from dual;
  INSERT INTO t_auton (test_value) VALUES ('A func insert');
  COMMIT;
  RETURN RET;
END A_func;
/

SELECT A_func() from dual;
SELECT * FROM t_auton order by test_value;
drop function A_func;
drop function B_func;
drop function C_func;
drop table t_auton;

--test RETURN RESULUT  not support now
CREATE TABLE t_auton (test_value VARCHAR2(25));
insert into t_auton values ('a');
insert into t_auton values ('b');
insert into t_auton values ('c');
insert into t_auton values ('d');
insert into t_auton values ('e');
insert into t_auton values ('f');

CREATE OR REPLACE PROCEDURE ablock IS
PRAGMA AUTONOMOUS_TRANSACTION;
t varchar(25);
cur sys_refcursor;
BEGIN
  open cur for select * from t_auton;
  dbe_sql.return_cursor(cur);
  COMMIT;
END;
/

exec ablock;
drop procedure ablock;
drop table t_auton;

--test sequence in autonomous transaction
drop table if exists  auton_sequ_t;
create table auton_sequ_t (a number);
insert into auton_sequ_t values (1); 

CREATE OR REPLACE PROCEDURE auton_proc_sequ authid current_user IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   execute immediate 'create sequence auton_seq_002 start with 0 maxvalue 4 minvalue 0 INCREMENT BY 2 CYCLE nocache';
   execute immediate 'insert into auton_sequ_t values (auton_seq_002.NEXTVAL)';      
  COMMIT;
END;
/

call auton_proc_sequ();
select count(*) from auton_sequ_t;
drop table auton_sequ_t;
drop sequence auton_seq_002;

--test start coverage in autonomous transaction
DROP TABLE IF EXISTS auton_cover_t;
create table auton_cover_t (id int);
insert into auton_cover_t values(35);
insert into auton_cover_t values(5);
insert into auton_cover_t values(3);

CREATE OR REPLACE PROCEDURE auton_proc_cover authid current_user IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   execute immediate 'alter system set COVERAGE_ENABLE = TRUE';
   insert into auton_cover_t values(40);  
   execute immediate 'alter system set COVERAGE_ENABLE = FALSE';
  COMMIT;
END;
/
call auton_proc_cover();
select * from auton_cover_t order by id desc;
drop table auton_cover_t;
drop table if exists COVERAGE$;

--test anonmous block call another anonmous block 1
drop table fvt_pragma_table_011;
create table fvt_pragma_table_011 (c_int int,c_number number,c_varchar varchar(80));
insert into fvt_pragma_table_011 values(1,1.25,'abcd');
insert into fvt_pragma_table_011 values(2,2.25,'nh');
create or replace procedure FVT_PRAGMA_PROC_011 is
pragma autonomous_transaction;
begin
	declare
	pragma autonomous_transaction;
	begin
    update fvt_pragma_table_011 set c_int = 100 where c_int < 10;
	execute immediate 'commit';
	end;
end;
/
call FVT_PRAGMA_PROC_011();
drop table fvt_pragma_table_011;
drop procedure FVT_PRAGMA_PROC_011;

--test anonmous block call another anonmous block 2
create table t_auton (test_value varchar(50));

DECLARE
   BEGIN
     INSERT INTO t_auton (test_value) VALUES ('top anonmous block insert');
     COMMIT;
     DECLARE
     PRAGMA AUTONOMOUS_TRANSACTION;
     Begin
        INSERT INTO t_auton (test_value) VALUES ('inner anonmous block insert');
   	    COMMIT;
     end;
  END;
/

SELECT * FROM t_auton order by test_value;

--test anonmous block call another anonmous block 3
drop table fvt_pragma_table_011;
create table fvt_pragma_table_011 (c_int int,c_number number,c_varchar varchar(80));
insert into fvt_pragma_table_011 values(1,1.25,'abcd');
insert into fvt_pragma_table_011 values(2,2.25,'nh');

create or replace procedure FVT_PRAGMA_PROC_012 is
   pragma autonomous_transaction;
begin
   update fvt_pragma_table_011 set c_int = 100 where c_int < 10;
   execute immediate 'commit';
end;
/
	
create or replace procedure FVT_PRAGMA_PROC_011 is
pragma autonomous_transaction;
begin
	FVT_PRAGMA_PROC_012;
	commit;
end;
/
call FVT_PRAGMA_PROC_011();
drop table fvt_pragma_table_011;
drop procedure FVT_PRAGMA_PROC_011;
drop procedure FVT_PRAGMA_PROC_012;

--test anonmous block call another anonmous block 4
drop table fvt_pragma_table_011;
create table fvt_pragma_table_011 (c_int int,c_number number,c_varchar varchar(80));
insert into fvt_pragma_table_011 values(1,1.25,'abcd');
insert into fvt_pragma_table_011 values(2,2.25,'nh');
create or replace procedure FVT_PRAGMA_PROC_011 is
pragma autonomous_transaction;
begin
	declare
	pragma autonomous_transaction;
	begin
    update fvt_pragma_table_011 set c_int = 100 where c_int < 10;
	execute immediate 'commit';
	end;
end;
/

declare 
pragma autonomous_transaction;
begin
	fvt_pragma_proc_011;
commit;
end;
/
drop table fvt_pragma_table_011;
drop procedure FVT_PRAGMA_PROC_011;
drop procedure FVT_PRAGMA_PROC_012;

--test pragma autonomous is declared in inner anoymous block of trigger
DROP TABLE IF EXISTS t_auton;
drop table if exists t1_auton;
CREATE TABLE t_auton (test_value VARCHAR2(25));
CREATE TABLE t1_auton (test_value VARCHAR2(25));
CREATE OR REPLACE TRIGGER A_trig AFTER INSERT ON t_auton FOR EACH ROW 
DECLARE
BEGIN
    DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
	BEGIN
	   INSERT INTO t1_auton values ('A trigger insert');
	END;
	INSERT INTO t1_auton values ('A trigger insert');
	EXECUTE IMMEDIATE 'COMMIT';
END;
/
drop table t_auton;
drop table t1_auton;
drop trigger A_trig;

--test pragma autonomous is declared in inner anoymous block of procedure
DROP TABLE IF EXISTS t_auton;
drop table if exists t1_auton;
CREATE TABLE t_auton (test_value VARCHAR2(25));
CREATE TABLE t1_auton (test_value VARCHAR2(25));
CREATE OR REPLACE PROCEDURE A_porce1 is
BEGIN
    DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
	BEGIN
	   INSERT INTO t1_auton values ('A trigger insert');
	END;
	INSERT INTO t1_auton values ('A trigger insert');
	EXECUTE IMMEDIATE 'COMMIT';
END;
/
drop table t_auton;
drop table t1_auton;
drop procedure A_porce1;

--DTS2019062504833
set serveroutput on;
drop table if exists fvt_pragma_table_017;
create table fvt_pragma_table_017 (c_int int,c_number number,c_varchar varchar(80),c_date date);
insert into fvt_pragma_table_017 values(1,1.25,'abcd','2015-5-5');
insert into fvt_pragma_table_017 values(2,2.25,'nh','2016-6-6');
DROP TABLE IF EXISTS fvt_pragma_table_17;
create  table fvt_pragma_table_17 
(
c_int int,
c_number number,
c_varchar varchar(80),
c_date date
);
insert into fvt_pragma_table_17 values
(1,1.25,'xiao','0001-1-1');
insert into fvt_pragma_table_17 values
(2,2.25,'xiaohu','2019-1-1');
insert into fvt_pragma_table_17 values
(3,3.25,'xiaolan','2178-12-31');

declare
begin
	merge into fvt_pragma_table_017 a using fvt_pragma_table_17 b1 on (a.c_int = b1.c_int) when matched then update set a.c_varchar = b1.c_varchar 
	when not matched then insert (c_int,c_number,c_varchar,c_date) values(b1.c_int,b1.c_number,b1.c_varchar,b1.c_date);
	execute immediate 'alter table fvt_pragma_table_017 rename column c_int to c_id';
	insert into fvt_pragma_table_017 values(100,3.25,'$#@','2019-6-19');
		declare	
		pragma autonomous_transaction;
		b_number number := 0;
		low_income EXCEPTION;	
		begin
			for i in 1..10
			loop
				insert into fvt_pragma_table_017 values(i,3.25,'jtfz','2018-8-8');
			end loop;
			begin
			if b_number < 10 then 
			raise low_income;
			end if;
			select c_number into b_number from fvt_pragma_table_017 where c_number = 2.25;
			dbe_output.print_line (b_number);
			EXCEPTION
			when low_income then
			dbe_output.print_line ('low number occurred');
			end;
		end;
	commit;
end;
/

declare
begin
	merge into fvt_pragma_table_017 a using fvt_pragma_table_17 b1 on (a.c_int = b1.c_int) when matched then update set a.c_varchar = b1.c_varchar 
	when not matched then insert (c_int,c_number,c_varchar,c_date) values(b1.c_int,b1.c_number,b1.c_varchar,b1.c_date);
	execute immediate 'alter table fvt_pragma_table_017 rename column c_int to c_id';
	insert into fvt_pragma_table_017 values(100,3.25,'$#@','2019-6-19');
		declare	
		pragma autonomous_transaction;
		b_number number := 0;
		low_income EXCEPTION;	
		begin
			for i in 1..10
			loop
				insert into fvt_pragma_table_017 values(i,3.25,'jtfz','2018-8-8');
			end loop;
			begin
			if b_number < 10 then 
			raise low_income;
			end if;
			select c_number into b_number from fvt_pragma_table_017 where c_number = 2.25;
			dbe_output.print_line (b_number);
			EXCEPTION
			when low_income then
			dbe_output.print_line ('low number occurred');
			end;
		end;
	commit;
end;
/
drop table if exists fvt_pragma_table_017;
drop table if exists fvt_pragma_table_17;
set serveroutput off;

--DTS2019070306367
declare
begin
for i in 1..2
loop
	 declare
			b varchar2(100);
			a||i sys_refcursor;
	begin
		b :='open a''||i||'' for  select * from sys_dummy';
		dbe_output.print_line(b);
	 end;
end loop;
end;
/