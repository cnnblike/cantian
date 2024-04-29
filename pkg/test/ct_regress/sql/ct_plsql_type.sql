-----------------------
-- USER DEFINED TYPE --
-----------------------
--init
set serveroutput on;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_plsql_type cascade;
create user gs_plsql_type identified by Cantian_234;
grant all privileges to gs_plsql_type;
conn gs_plsql_type/Cantian_234@127.0.0.1:1611

--assignment for table type
declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
 i int;
begin
 var_C1.delete(2);
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 var_C1(2) := null;
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 i := var_C1.first();
 LOOP  
    if i is null then
       exit;
    end if;  
    dbe_output.print_line(i || '.' || var_C1(i));
    i := var_C1.next(i);
 END LOOP;
 
 i := var_C1.last();
 LOOP 
    if i is null then
       exit;
    end if;   
    dbe_output.print_line(i || '.' || var_C1(i));
    i := var_C1.prior(i);
 END LOOP;
end;
/

--forward/reverse traversal for table type
declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
 i int;
begin
 var_C1.delete(2);
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 i := var_C1.first();
 LOOP  
    if i is null then
       exit;
    end if;  
    dbe_output.print_line(i || '.' || var_C1(i));
    i := var_C1.next(i);
 END LOOP;
 
 i := var_C1.last();
 LOOP 
    if i is null then
       exit;
    end if;   
    dbe_output.print_line(i || '.' || var_C1(i));
    i := var_C1.prior(i);
 END LOOP;
end;
/

-- table of number test
DECLARE
TYPE nt_type IS TABLE OF NUMBER;
nt nt_type := nt_type(18, NULL, 36, 45, 54, 63);
BEGIN
dbe_output.print('nt.count() = ' || nt.count());
nt.DELETE(4);
dbe_output.print('nt.count() = ' || nt.count());
dbe_output.print_line('nt(4) was deleted.');
dbe_output.print('nt.NEXT(' || 0 || ') = ' || nt.NEXT(0));
FOR i IN 1..7 LOOP
dbe_output.print('nt.PRIOR(' || i || ') = ' || nt.PRIOR(i));
dbe_output.print('nt.NEXT(' || i || ') = ' || nt.NEXT(i));
END LOOP;
nt.DELETE(3);
dbe_output.print_line('nt(3)nt(4) was deleted.');
FOR i IN 1..7 LOOP
dbe_output.print('nt.PRIOR(' || i || ') = ' || nt.PRIOR(i));
dbe_output.print('nt.NEXT(' || i || ') = ' || nt.NEXT(i));
END LOOP;
END;
/

-- expression for table type
drop table if exists coll_tbl1;
create table coll_tbl1(a1 int);
insert into coll_tbl1 values(1);
commit;
declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
 a int;
begin 
 select a1 + var_C1(1) into a from coll_tbl1 order by a1;
 dbe_output.print_line(a);
 select a1 + var_C1(1) into a from coll_tbl1 order by a1 + var_C1(1);
 dbe_output.print_line(a);
 select a1 + var_C1(1) into a from coll_tbl1 order by var_C1(1);
 dbe_output.print_line(a);
end;
/
declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
 a int;
begin 
 select a1 + var_C1(1) into a from coll_tbl1 group by a1;
 dbe_output.print_line(a);
end;
/
declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
 a int;
begin 
 select a1 + var_C1(1) into a from coll_tbl1 order by var_C1;
 dbe_output.print_line(a);
end;
/
declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
 a int;
begin 
 select a1 + var_C1(1) into a from coll_tbl1 group by a1 + var_C1(1);
 dbe_output.print_line(a);
end;
/
declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
 a int;
begin 
 select var_C1(2) into a from dual;
 dbe_output.print_line(a);
end;
/
declare
 a varchar(20);
 TYPE C1 IS TABLE OF varchar(20);
 var_C1 C1 := C1('abc', 'bcd', 'cdf');
begin 
 select var_C1(2) into a from dual;
 dbe_output.print_line(a);
end;
/

declare
 TYPE C1 IS TABLE OF INTEGER;
 TYPE C2 IS TABLE OF C1;
 var_C2 C2 := C2(C1(123, 234, 345));
 a int;
begin 
 select var_C2(1)(3) into a from dual;
 dbe_output.print_line(a);
end;
/
declare
 TYPE C1 IS TABLE OF varchar(20);
 TYPE C2 IS TABLE OF C1;
 var_C2 C2 := C2(C1('abc', 'bcd', 'cdf'));
 a varchar(20);
begin 
 select var_C2(1)(3) into a from dual;
 dbe_output.print_line(a);
end;
/
declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
 a int;
begin 
 -- raise error
 select a1 + var_C1(1) into a from coll_tbl1 group by var_C1(1); 
end;
/
declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
 a int;
begin 
 -- raise error
 select a1 + var_C1(1) into a from coll_tbl1 group by var_C1; 
end;
/

declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
 v_lower int;
 v_upper int;
 v_prev int;
 v_next int;
begin
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 v_lower := var_C1.first();
 v_prev  := var_C1.PRIOR(v_lower);
 dbe_output.print_line('prev of head:' || v_prev);
 v_upper := var_C1.last();
 v_next  := var_C1.next(v_upper);
 dbe_output.print_line('next of tail:' || v_next);
 
 dbe_output.print_line(v_lower || '.' || var_C1(v_lower));
 v_next := var_C1.next(v_lower);
 dbe_output.print_line(v_next || '.' || var_C1(v_next));
 v_next := var_C1.next(v_next);
 dbe_output.print_line(v_next || '.' || var_C1(v_next));
 
 dbe_output.print_line(v_upper || '.' || var_C1(v_upper));
 v_prev := var_C1.PRIOR(v_upper);
 dbe_output.print_line(v_prev || '.' || var_C1(v_prev));
 v_prev := var_C1.PRIOR(v_prev);
 dbe_output.print_line(v_prev || '.' || var_C1(v_prev));
end;
/

declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
 v_prev int;
 v_next int;
begin
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 v_prev  := var_C1.PRIOR(var_C1.first());
 dbe_output.print_line('prev of head:' || v_prev);
 v_next  := var_C1.next(var_C1.last());
 dbe_output.print_line('next of tail:' || v_next);
 
 dbe_output.print_line(var_C1.first() || '.' || var_C1(var_C1.first()));
 v_next := var_C1.next(var_C1.first());
 dbe_output.print_line(v_next || '.' || var_C1(v_next));
 v_next := var_C1.next(v_next);
 dbe_output.print_line(v_next || '.' || var_C1(v_next));
 
 dbe_output.print_line(var_C1.last() || '.' || var_C1(var_C1.last()));
 v_prev := var_C1.PRIOR(var_C1.last());
 dbe_output.print_line(v_prev || '.' || var_C1(v_prev));
 v_prev := var_C1.PRIOR(v_prev);
 dbe_output.print_line(v_prev || '.' || var_C1(v_prev));
end;
/

-- for-loop for table type
declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
begin
 dbe_output.print_line('LIMIT:' || var_C1.LIMIT());
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 FOR i IN var_C1.first() .. var_C1.last()  LOOP
    dbe_output.print_line(i || '.' || var_C1(i));
 END LOOP;
end;
/

-- exists for table type
declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
begin
 dbe_output.print_line('exists[0]:' || var_C1.exists(0));
 dbe_output.print_line('exists[100]:' || var_C1.exists(100));
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 FOR i IN var_C1.first() .. var_C1.last()  LOOP
    dbe_output.print_line('exists[' || i || ']:' || var_C1.exists(i));
 END LOOP;
 dbe_output.print_line('exists[' || (var_C1.last()+1) || ']:' || var_C1.exists(var_C1.last()+1));
end;
/

-- record type
declare
 TYPE C1 IS VARRAY(4) OF varchar(100);
 TYPE C2 IS TABLE OF INTEGER;
 TYPE R1 IS RECORD(
  F1 C1,
  F2 C2);
 var_C1 C1 := C1('123', 234, 345);
 var_C2 C2;
 var_R1 R1;
begin
 var_C2 := C2();
 var_C2.EXTEND;
 var_C2(1) := '456';
 var_C2.EXTEND;
 var_C2(2) := '567';
 var_R1.F1 := var_C1;
 var_R1.F2 := var_C2;
 FOR i IN 1 .. var_R1.F1.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_R1.F1(i));
 END LOOP;
 FOR i IN 1 .. var_C1.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_C1(i));
 END LOOP;
 FOR i IN 1 .. var_R1.F2.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_R1.F2(i));
 END LOOP;
 FOR i IN 1 .. var_C2.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_C2(i));
 END LOOP;
 var_C1 := C1('NEW_123', 1234, 1345);

 FOR i IN 1 .. var_R1.F1.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_R1.F1(i));
 END LOOP;
 FOR i IN 1 .. var_C1.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_C1(i));
 END LOOP;
 FOR i IN 1 .. var_C2.COUNT() LOOP
  var_C2(i) := i;
 END LOOP;
 FOR i IN 1 .. var_R1.F2.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_R1.F2(i));
 END LOOP;
 FOR i IN 1 .. var_C2.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_C2(i));
 END LOOP;
 end;
 /

-- only record fields can be compared
Declare
    Type EmpType is Record(
       EMPNO number(4),
       ENAME  varchar2(10),
       JOB varchar2(15),
       SAL number(7,2),
       DEPTNO number(2)
    );
    EmpRec1  EmpType;
    EmpRec2  EmpType;
Begin
    EmpRec1.Empno:=7369;
    EmpRec1.Ename:='SMITH';
    EmpRec1.Job:='CLERK';
    EmpRec1.Sal:=800;
    EmpRec1.Deptno:=10;
    -- record types can be assigned as a whole
    EmpRec2 := EmpRec1;
    
    if EmpRec1.sal <= EmpRec2.sal then
       dbe_output.print_line('CantianDB');
    end if;
	-- only record fields can be judged
    if EmpRec2.JOB is not null then
       dbe_output.print_line('Huawei');
	end if;
End;
/
--unsupport use record to update table info
drop table if exists t_422311;
create table t_422311(EMPNO int, b varchar(100));
insert into t_422311 values(123, 'test422311'),(234, 'test1123224');
commit;
--DECLARE
--vEmp t_422311%RowType;
--Begin
--select * InTo vEmp From t_422311 Where t_422311.EMPNO = 123;
--update t_422311 set ROW = vEmp Where EMPNO = 234;
--commit;
--End;
--/
--unsupport
Declare
Type RecType Is Record
(
  rno t_422311.EMPNO%type,
  rname t_422311.b%type
);
Type TabType Is Table Of RecType Index By Binary_Integer;
MyTab TabType;
vN Number;
Begin
vN := 1;
For varR In (Select * From t_422311 Order By EMPNO ASC)
Loop
  MyTab(vN).rno  := varR.EMPNO;
  MyTab(vN).rname := varR.b;
  vN := vN + 1;
End Loop;
vN := MyTab.First;
For varR In vN..MyTab.count
Loop
  dbe_output.print_line(vN ||'   '||MyTab(vN).rno||'   '||MyTab(vN).rname);
  vN := vN + 1;
End Loop;
End;
/
drop table t_422311;

declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
begin
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 FOR i IN 1 .. var_C1.COUNT() LOOP
    dbe_output.print_line(i || '.' || var_C1(i));
 END LOOP;
 
 var_C1.EXTEND;
 var_C1(4) := 456;
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 FOR i IN 1 .. var_C1.COUNT() LOOP
    dbe_output.print_line(i || '.' || var_C1(i));
 END LOOP;
 
 var_C1.EXTEND(2,3);
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 FOR i IN 1 .. var_C1.COUNT() LOOP
    dbe_output.print_line(i || '.' || var_C1(i));
 END LOOP;
end;
/

declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
begin
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 FOR i IN 1 .. var_C1.COUNT() LOOP
    dbe_output.print_line(i || '.' || var_C1(i));
 END LOOP;
 
 var_C1.TRIM(3);
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 FOR i IN 1 .. var_C1.COUNT() LOOP
    dbe_output.print_line(i || '.' || var_C1(i));
 END LOOP;
 
 var_C1 := C1(123, 234, 345);
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 FOR i IN 1 .. var_C1.COUNT() LOOP
    dbe_output.print_line(i || '.' || var_C1(i));
 END LOOP;
 var_C1.TRIM;
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 FOR i IN 1 .. var_C1.COUNT() LOOP
    dbe_output.print_line(i || '.' || var_C1(i));
 END LOOP;
end;
/

declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
begin
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 FOR i IN 1 .. var_C1.COUNT() LOOP
    dbe_output.print_line(i || '.' || var_C1(i));
 END LOOP;
 
 var_C1.TRIM(3);
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 FOR i IN 1 .. var_C1.COUNT() LOOP
    dbe_output.print_line(i || '.' || var_C1(i));
 END LOOP;

 dbe_output.print_line(0 || '.' || var_C1(0));
end;
/

declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
begin
 var_C1.delete(2);
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 FOR i IN 1 .. var_C1.count() LOOP
    dbe_output.print_line(i || '.' || var_C1(i));
 END LOOP;
end;
/

declare
 TYPE C1 IS TABLE OF INTEGER;
 var_C1 C1 := C1(123, 234, 345);
 lower int;
 upper int;
begin
 dbe_output.print_line('COUNT:' || var_C1.COUNT());
 lower := var_C1.first();
 upper := var_C1.last();
 FOR i IN lower .. upper  LOOP
    dbe_output.print_line(i || '.' || var_C1(i));
 END LOOP;
end;
/

-- nested type
CREATE OR REPLACE TYPE ATTR_TYPE2 FORCE AS OBJECT
( month int,
  month int
);
/

CREATE OR REPLACE TYPE ATTR_TYPE2 FORCE AS OBJECT
( month int
);
/

CREATE OR REPLACE TYPE ATTR_TYPE FORCE AS OBJECT
( year int,
  month ATTR_TYPE2
);
/

drop type ATTR_TYPE2;

--
CREATE OR REPLACE TYPE ATTR_SUPER_TYPE FORCE AS OBJECT
( year int,
  MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
  FINAL MEMBER FUNCTION prod2(invent NUMBER) RETURN NUMBER,
  NOT FINAL NOT INSTANTIABLE MEMBER FUNCTION prod3(invent NUMBER) RETURN NUMBER,
  STATIC PROCEDURE prod4(invent NUMBER)
) not final not instantiable;
/
select TYPE_NAME,TYPE_CODE,ATTRIBUTES,METHODS,PREDEFINED,INCOMPLETE,FINAL,INSTANTIABLE,SUPERTYPE_NAME,LOCAL_ATTRIBUTES,LOCAL_METHODS from SYS.SYS_TYPES where type_name='ATTR_SUPER_TYPE';
select TYPE_NAME,ATTR_NAME,ATTR_NO,ATTR_TYPE_MOD,ATTR_TYPE_NAME,ATTR_TYPE,LENGTH,PRECISION,SCALE,CHAR_SET,INHERITED from SYS.SYS_TYPE_ATTRS where type_name='ATTR_SUPER_TYPE' ORDER BY ATTR_NO;
select TYPE_NAME,METHOD_NAME,METHOD_NO,METHOD_TYPE,PARAMETERS,RESULTS,FINAL,INSTANTIABLE,OVERRIDING,INHERITED from SYS.SYS_TYPE_METHODS where type_name='ATTR_SUPER_TYPE' ORDER BY METHOD_NO;
CREATE OR REPLACE TYPE ALL_ATTR_TYPE FORCE UNDER ATTR_SUPER_TYPE
( a int,
  b number(8),
  c number(10,2),
  d char(20),
  e varchar(30),
  f clob,
  g blob,
  h ATTR_TYPE,
  OVERRIDING MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
  OVERRIDING FINAL MEMBER FUNCTION prod3(invent NUMBER) RETURN NUMBER,
  MEMBER PROCEDURE prod5(invent NUMBER)
);
/
select TYPE_NAME,TYPE_CODE,ATTRIBUTES,METHODS,PREDEFINED,INCOMPLETE,FINAL,INSTANTIABLE,SUPERTYPE_NAME,LOCAL_ATTRIBUTES,LOCAL_METHODS from SYS.SYS_TYPES where type_name='ALL_ATTR_TYPE';
select TYPE_NAME,ATTR_NAME,ATTR_NO,ATTR_TYPE_MOD,ATTR_TYPE_NAME,ATTR_TYPE,LENGTH,PRECISION,SCALE,CHAR_SET,INHERITED from SYS.SYS_TYPE_ATTRS where type_name='ALL_ATTR_TYPE' ORDER BY ATTR_NO;
select TYPE_NAME,METHOD_NAME,METHOD_NO,METHOD_TYPE,PARAMETERS,RESULTS,FINAL,INSTANTIABLE,OVERRIDING,INHERITED from SYS.SYS_TYPE_METHODS where type_name='ALL_ATTR_TYPE' ORDER BY METHOD_NO;

declare
v1 ALL_ATTR_TYPE;
v2 ALL_ATTR_TYPE;
begin
  v2.a := v1.a;
  dbe_output.print_line(v2.a);
end;
/

declare
v1 ALL_ATTR_TYPE;
v2 ALL_ATTR_TYPE;
begin
  v1 := ALL_ATTR_TYPE(2, 3, 4, 5.1, 'abc', 'def', 'ghi', 'abc123', ATTR_TYPE(1, ATTR_TYPE2(2)));
  v2 := v1;
  dbe_output.print_line(v2.a);
end;
/

create or replace type yyy is VARRAY(10) OF NUMBER(10, 2);
/
select TYPE_NAME,TYPE_CODE,ATTRIBUTES,METHODS,PREDEFINED,INCOMPLETE,FINAL,INSTANTIABLE,SUPERTYPE_NAME,LOCAL_ATTRIBUTES,LOCAL_METHODS from SYS.SYS_TYPES where type_name='YYY';
select TYPE_NAME,COLL_TYPE,UPPER_BOUND,ELEM_TYPE_MOD,ELEM_TYPE_NAME,LENGTH,PRECISION,SCALE,CHAR_SET,ELEM_STORAGE,NULLS_STORED from SYS.SYS_COLL_TYPES where type_name='YYY';

create or replace type zzz is VARRAY(20) OF ALL_ATTR_TYPE;
/
select TYPE_NAME,TYPE_CODE,ATTRIBUTES,METHODS,PREDEFINED,INCOMPLETE,FINAL,INSTANTIABLE,SUPERTYPE_NAME,LOCAL_ATTRIBUTES,LOCAL_METHODS from SYS.SYS_TYPES where type_name='ZZZ';
select TYPE_NAME,COLL_TYPE,UPPER_BOUND,ELEM_TYPE_MOD,ELEM_TYPE_NAME,LENGTH,PRECISION,SCALE,CHAR_SET,ELEM_STORAGE,NULLS_STORED from SYS.SYS_COLL_TYPES where type_name='ZZZ';

declare
type xxx is VARRAY(10) OF NUMBER;
v1 xxx;
v2 yyy;
begin
  v1 := xxx(1,2,3);
  dbe_output.print_line(v1(1));
  v2 := yyy(1,2,3);
  dbe_output.print_line(v2(1));
  dbe_output.print_line(v2(2));
  dbe_output.print_line(v2(3));
end;
/


-- test type privilege
drop user if exists gs_plsql_type2 cascade;
create user gs_plsql_type2 identified by Cantian_234;
grant execute any type to gs_plsql_type2;
grant create session to gs_plsql_type2;
conn gs_plsql_type2/Cantian_234@127.0.0.1:1611

CREATE OR REPLACE TYPE ATTR_TYPE_NOT_USE FORCE AS OBJECT
( month int
) not final;
/

declare
v1 gs_plsql_type.ALL_ATTR_TYPE;
begin
  v1 := gs_plsql_type.ALL_ATTR_TYPE(2, 3, 4, 5.1, 'abc', 'def', 'ghi', 'abc123', gs_plsql_type.ATTR_TYPE(1, gs_plsql_type.ATTR_TYPE2(2)));
  dbe_output.print_line(v1.a);
end;
/

conn gs_plsql_type/Cantian_234@127.0.0.1:1611
grant create type to gs_plsql_type2;
conn gs_plsql_type2/Cantian_234@127.0.0.1:1611

CREATE OR REPLACE TYPE ATTR_TYPE_NOT_USE FORCE AS OBJECT
( month int
) not final;
/

CREATE OR REPLACE TYPE ATTR_TYPE_NOT_USE_SUB FORCE UNDER ATTR_TYPE_NOT_USE
( day int
);
/

conn gs_plsql_type/Cantian_234@127.0.0.1:1611
drop user if exists gs_plsql_type3 cascade;
create user gs_plsql_type3 identified by Cantian_234;
grant create any type to gs_plsql_type3;
grant create session to gs_plsql_type3;
conn gs_plsql_type3/Cantian_234@127.0.0.1:1611

CREATE OR REPLACE TYPE ATTR_TYPE_NOT_USE FORCE AS OBJECT
( month int
) not final;
/

declare
v1 gs_plsql_type.ALL_ATTR_TYPE;
begin
  v1 := gs_plsql_type.ALL_ATTR_TYPE(2, 3, 4, 5.1, 'abc', 'def', 'ghi', 'abc123', gs_plsql_type.ATTR_TYPE(1, gs_plsql_type.ATTR_TYPE2(2)));
  dbe_output.print_line(v1.a);
end;
/
--DTS2019112301103
CREATE OR REPLACE TYPE gs_plsql_type2.ATTR_TYPE_NOT_USE_SUB FORCE UNDER gs_plsql_type2.ATTR_TYPE_NOT_USE
( day int
);
/

CREATE OR REPLACE TYPE ATTR_TYPE_NOT_USE_SUB FORCE UNDER gs_plsql_type2.ATTR_TYPE_NOT_USE
( day int
);
/

conn sys/Huawei@123@127.0.0.1:1611
drop user gs_plsql_type cascade;
drop user gs_plsql_type2 cascade;
drop user gs_plsql_type3 cascade;

drop user if exists gs_plsql_type cascade;
create user gs_plsql_type identified by Cantian_234;
grant all privileges to gs_plsql_type;
conn gs_plsql_type/Cantian_234@127.0.0.1:1611

DECLARE 
    type xxxx is record(a int, b int);
    type yyyy is record(a xxxx, b int, c xxxx);
    v1 yyyy;
BEGIN
    v1.a.a :=3; 
	dbe_output.print_line (v1.a.a);
    dbe_output.print_line (v1.a.b);
    dbe_output.print_line (v1.b);
    dbe_output.print_line (v1.c.a);
    dbe_output.print_line (v1.c.b);
    v1.b:=4;
    dbe_output.print_line (v1.b);
END;
/

declare
type xxx is VARRAY(10) OF int;
type yyy is VARRAY(10) OF xxx;
v1 xxx;
v2 yyy;
begin
  v2 := yyy(xxx(1,2),xxx(2,3));
  dbe_output.print_line(v2(1)(2));
end;
/

declare
type xxx is VARRAY(10) OF int;
type yyy is VARRAY(10) OF xxx;
v1 xxx;
begin
  v1 := yyy(xxx(1,2),xxx(2,3));
  dbe_output.print_line(v1(1)(2));
end;
/

CREATE OR REPLACE TYPE ATTR_TYPE_SET_NULL FORCE AS OBJECT
( month int
);
/

DECLARE 
    v1 ATTR_TYPE_SET_NULL;
BEGIN
    v1 := ATTR_TYPE_SET_NULL(3);
    dbe_output.print_line (v1.month);
    v1 := NULL;
    dbe_output.print_line(v1.month || 'null');
END;
/

CREATE OR REPLACE TYPE TABLE_TYPE_SET_NULL IS TABLE OF VARCHAR(10);
/


DECLARE
 v1 TABLE_TYPE_SET_NULL;
BEGIN
 v1 := TABLE_TYPE_SET_NULL('ABC', 'def');
 dbe_output.print_line(v1(1));
 dbe_output.print_line(v1(2));
 v1 := null;
 dbe_output.print_line(v1(1));
END;
/

CREATE OR REPLACE TYPE TABLE_TYPE_SET_NULL_VARRAY IS VARRAY(10) OF VARCHAR(10);
/

DECLARE
 v1 TABLE_TYPE_SET_NULL_VARRAY;
BEGIN
 v1 := TABLE_TYPE_SET_NULL_VARRAY('ABC', 'def');
 dbe_output.print_line(v1(1));
 dbe_output.print_line(v1(2));
 v1 := null;
 dbe_output.print_line(v1(2));
END;
/

DECLARE
 type xxxx is record(
  a int,
  b int);
 v1 xxxx;
 v2 xxxx;
BEGIN
 v1.a := 3;
 v2   := v1;
 dbe_output.print_line(v2.a);
 dbe_output.print_line(v2.b);
END;
/

CREATE OR REPLACE TYPE ATTR_TYPE2 FORCE AS OBJECT
( month int
);
/

declare
v1 ATTR_TYPE2;
v2 ATTR_TYPE2;
v3 int;
begin
  v3 := v1.month;
  dbe_output.print_line(v3 ||'null');
  v2.month := v1.month;
  dbe_output.print_line(v2.month);
end;
/

create or replace type yyyy is VARRAY(10) OF ATTR_TYPE2;
/

declare
v1 yyyy;
v2 int;
begin
  v1 := yyyy();
  v1.EXTEND(2);
  v2 := v1(1).month;
  dbe_output.print_line(v2 ||'null');
end;
/

declare
v1 yyyy;
v2 int;
begin
  v1 := yyyy();
  v2 := v1(1).month;
  dbe_output.print_line(v2);
  v1.EXTEND(2);
  v2 := v1(1).month;
  dbe_output.print_line(v2);
end;
/

declare
v1 yyyy;
v2 yyyy;
begin
  v1 := yyyy();
  v2 := v1;
end;
/

declare
v1 yyyy;
v2 yyyy;
begin
  v2 := v1;
end;
/

create or replace type yyyy FORCE is VARRAY(10) OF int;
/

CREATE OR REPLACE TYPE ATTR_TYPE2 FORCE AS OBJECT
( a yyyy,
  b int
);
/

declare
v1 ATTR_TYPE2;
v2 ATTR_TYPE2;
begin
  v1 := ATTR_TYPE2(null);
  v2 := ATTR_TYPE2(yyyy(2));
  v2.a := v1.a;
  dbe_output.print_line(v2.a(1));
end;
/

declare
 v1 ATTR_TYPE2;
 v2 ATTR_TYPE2;
 type ZZZ is record(
  f1 int,
  f2 varchar(100));
 v3 zzz;
begin
 dbe_output.print_line(v3.f1 || 'null');
 v3.f1 := '123';
 dbe_output.print_line(v3.f1);
 dbe_output.print_line(v1.b || 'null');
 v1.b := '123';
end;
/

declare
 v1 ATTR_TYPE2;
 v2 ATTR_TYPE2;
 type ZZZ is record(
  f1 int,
  f2 varchar(100));
 v3 zzz;
begin
 dbe_output.print_line(v3.f1 || 'null');
 v3.f1 := '123';
 dbe_output.print_line(v3.f1);
 dbe_output.print_line(v1.a.count);
end;
/

declare
v1 ATTR_TYPE2;
v2 INT;
begin
  v2 := v1.a(1);
  dbe_output.print_line(v1.a(1));
end;
/

drop table if exists  for_record_var_table;
create table for_record_var_table(a varchar(10), b int);
declare
type xxxx is record(b int, c varchar(20));
v1 xxxx;
v2 for_record_var_table%rowtype;
begin
  v1.b := 2;
  v1.c := '3';
  v2 := v1;
  dbe_output.print_line(v2.a);
  dbe_output.print_line(v2.b);
end;
/

declare
type xxxx is record(b varchar(20), c int);
v1 xxxx;
v2 for_record_var_table%rowtype;
begin
  v1.b := '3ddddddddddd';
  v1.c := 2;
  v2 := v1;
  dbe_output.print_line(v2.a);
  dbe_output.print_line(v2.b);
end;
/

declare
type xxxx is record(b char(20), c int);
v1 xxxx;
v2 for_record_var_table%rowtype;
begin
  v1.b := '10';
  v1.c := 2;
  v2 := v1;
  dbe_output.print_line(v2.a);
  dbe_output.print_line(v2.b);
end;
/

declare
type xxxx is record(b raw(10), c int);
v1 xxxx;
v2 for_record_var_table%rowtype;
begin
  v1.b := '10';
  v1.c := 2;
  v2 := v1;
  dbe_output.print_line(v2.a);
  dbe_output.print_line(v2.b);
end;
/

declare
type xxxx is record(b for_record_var_table%rowtype, c int);
v1 xxxx;
begin
  v1.b.a := '10';
  v1.b.b := 5;
  v1.c := 2;
  dbe_output.print_line(v1.b.a);
  dbe_output.print_line(v1.b.b);
  dbe_output.print_line(v1.c);
end;
/

drop table if exists  for_record_var_table;
create table for_record_var_table(a int, b int);
declare
type xxxx is record(b number(8,2), c int);
v1 xxxx;
v2 for_record_var_table%rowtype;
begin
  v1.b := 2.5;
  v1.c := 3;
  v2 := v1;
  dbe_output.print_line(v2.a);
  dbe_output.print_line(v2.b);
end;
/

drop table for_record_var_table purge;

conn sys/Huawei@123@127.0.0.1:1611
drop user gs_plsql_type cascade;

--test varray constructor
DECLARE
 TYPE Foursome IS VARRAY(3) OF VARCHAR2(15); 
 team Foursome := Foursome('John', 'Mary', 'Alberto', 'Juanita');
BEGIN
 FOR i IN 1 .. 4 LOOP
  dbe_output.print_line(i || '.' || team(i));
 END LOOP;
END;
/

DECLARE
TYPE t1 IS VARRAY(10) OF INTEGER; -- varray of integer
va t1 := t1(2,3,5);
TYPE nt1 IS VARRAY(10) OF t1;  -- varray of varray of integer
nva nt1 := nt1(t1(55,6,73), 2,t1(55,6,73), t1(2,4));
i INTEGER;
BEGIN
 FOR i IN 1 .. 3 LOOP
  dbe_output.print_line(i);
 END LOOP;
END;
/

DECLARE
TYPE rec_type IS RECORD ( -- RECORD type
f1 INTEGER,
f2 VARCHAR2(15)
);
value1 rec_type;
value2 rec_type;
TYPE nt1 IS VARRAY(10) OF rec_type;  -- varray of RECORD
nva nt1 := nt1(value1, value2, 2);
BEGIN
  value1.f1 := 10;
  value1.f2 := 'John';
  value2.f1 := 20;
  value2.f2 := 'Smith';
END;
/

--test nested constructor 
DECLARE
TYPE t1 IS VARRAY(10) OF INTEGER; -- varray of integer
TYPE Roster IS TABLE OF t1; -- nested table type
ro Roster := Roster(t1(55,6,73),2,t1(55,6,73), t1(2,4));
BEGIN
 FOR i IN 1 .. 3 LOOP
  dbe_output.print_line(i);
 END LOOP;
END;
/

DECLARE
TYPE rec_type IS RECORD ( -- RECORD type
f1 INTEGER,
f2 VARCHAR2(15)
);
value1 rec_type;
value2 rec_type;
TYPE Roster IS TABLE OF rec_type;  -- varray of RECORD
ro Roster := Roster(value1, value2, 2);
BEGIN
  value1.f1 := 10;
  value1.f2 := 'John';
  value2.f1 := 20;
  value2.f2 := 'Smith';
END;
/

--test varray constructor
DECLARE
 TYPE Foursome IS VARRAY(4) OF char(16); 
 team Foursome := Foursome('John', 'Mary', 'Alberto', 'Juanita');
BEGIN
 FOR i IN 1 .. 4 LOOP
  dbe_output.print_line(i || '.' || team(i));
 END LOOP;
END;
/

--test varray constructor
DECLARE
 TYPE Foursome IS VARRAY(4) OF integer; 
 team Foursome := Foursome(1, 2, 3, 4);
BEGIN
 FOR i IN 1 .. 4 LOOP
  dbe_output.print_line(i || '.' || team(i));
 END LOOP;
END;
/

--test varray constructor
DECLARE
 TYPE Foursome IS VARRAY(4) OF BIGINT; 
 team Foursome := Foursome(9223372036854775807, 9223372036854775806, 9223372036854775802, 9223372036854775800);
BEGIN
 FOR i IN 1 .. 4 LOOP
  dbe_output.print_line(i || '.' || team(i));
 END LOOP;
END;
/

--test varray constructor
DECLARE
 TYPE Foursome IS VARRAY(4) OF NUMBER; 
 team Foursome := Foursome(3.1415926, 31.415926, 314.15926, 3141.5926);
BEGIN
 FOR i IN 1 .. 4 LOOP
  dbe_output.print_line(i || '.' || team(i));
 END LOOP;
END;
/

--test varray constructor
DECLARE
 TYPE Foursome IS VARRAY(4) OF VARCHAR2(15); -- VARRAY type
 -- varray variable initialized with constructor:
 team Foursome := Foursome('John', 'Mary', 'Alberto', 'Juanita');
 
BEGIN
 dbe_output.print_line('2001 Team:');
 FOR i IN 1 .. 4 LOOP
  dbe_output.print_line(i || '.' || team(i));
 END LOOP;
 dbe_output.print_line('---');
 team(3) := 'Pierre'; -- Change values of two elements
 team(4) := 'Yvonne'; 
 
 dbe_output.print_line('2005 Team:');
 FOR i IN 1 .. 4 LOOP
  dbe_output.print_line(i || '.' || team(i));
 END LOOP;
 dbe_output.print_line('---');
 
 -- Invoke constructor to assign new values to varray variable:
 team := Foursome('Arun', 'Amitha', 'Allan', 'Mae');
  dbe_output.print_line('2009 Team:');
 FOR i IN 1 .. 4 LOOP
  dbe_output.print_line(i || '.' || team(i));
 END LOOP;
 dbe_output.print_line('---');
END;
/


DECLARE
 TYPE Foursome IS VARRAY(4) OF VARCHAR2(15); -- VARRAY type
 -- varray variable initialized with constructor:
 team Foursome := Foursome('John', 'Mary', 'Alberto', 'Juanita');
BEGIN
 dbe_output.print_line('2001 Team:');
 FOR i IN 1 .. team.count() LOOP
  dbe_output.print_line(i || '.' || team(i));
 END LOOP;
 team(3) := 'Pierre'; -- Change values of two elements
 team(4) := 'Yvonne';
 
 dbe_output.print_line('2005 Team:');
 FOR i IN 1 .. team.count() LOOP
  dbe_output.print_line(i || '.' || team(i));
 END LOOP; 
 -- Invoke constructor to assign new values to varray variable:
 team := Foursome('Arun', 'Amitha', 'Allan', 'Mae');
 dbe_output.print_line('2009 Team:');
  FOR i IN 1 .. team.count() LOOP
  dbe_output.print_line(i || '.' || team(i));
 END LOOP; 
END;
/

DECLARE
 TYPE Foursome IS VARRAY(4) OF VARCHAR2(15);
 team Foursome := Foursome(); -- initialize to empty

BEGIN
 dbe_output.print_line('Team:');
 IF team.COUNT() = 0 THEN
  dbe_output.print_line('Empty');
 ELSE
  FOR i IN 1 .. team.COUNT() LOOP
   dbe_output.print_line(i || '.' || team(i));
  END LOOP;
 END IF;
 dbe_output.print_line('---');
 team := Foursome('John', 'Mary', 'Alberto', 'Juanita');
 dbe_output.print_line('Team:');
  IF team.COUNT() = 0 THEN
   dbe_output.print_line('Empty');
  ELSE
   FOR i IN 1 .. team.COUNT() LOOP
    dbe_output.print_line(i || '.' || team(i));
   END LOOP;
  END IF;
  dbe_output.print_line('---');
END;
/



DECLARE
 TYPE Foursome IS table OF VARCHAR2(15); -- VARRAY type
 -- varray variable initialized with constructor:
 team Foursome := Foursome('John', 'Mary', 'Alberto', 'Juanita');
 
BEGIN
 dbe_output.print_line('2001 Team:');
 FOR i IN 1 .. 4 LOOP
  dbe_output.print_line(i || '.' || team(i));
 END LOOP;
 dbe_output.print_line('---');
 team(3) := 'Pierre'; -- Change values of two elements
 team(4) := 'Yvonne'; 
 
 dbe_output.print_line('2005 Team:');
 FOR i IN 1 .. 4 LOOP
  dbe_output.print_line(i || '.' || team(i));
 END LOOP;
 dbe_output.print_line('---');
 
 -- Invoke constructor to assign new values to varray variable:
 team := Foursome('Arun', 'Amitha', 'Allan', 'Mae');
 dbe_output.print_line('2009 Team:');
 FOR i IN 1 .. 4 LOOP
  dbe_output.print_line(i || '.' || team(i));
 END LOOP;
 dbe_output.print_line('---');
 dbe_output.print_line(team.count());
 team.extend();
 team(5) := 'what';
 dbe_output.print_line('2010 Team:');
 dbe_output.print_line(team.first());
 dbe_output.print_line(team.last());
 FOR i IN team.first() .. team.last() LOOP
  dbe_output.print_line(i || '.' || team(i));
 END LOOP;
 dbe_output.print_line('---');
END;
/

declare
TYPE R1 IS RECORD(F1 INTEGER, F2 VARCHAR2(15));
var_r1 R1;
TYPE C1 IS VARRAY(4) OF R1;
var_c1 C1 :=C1(var_r1);
begin
  var_c1:= C1(var_r1);
  var_r1.F1:=3;
  var_r1.F2:='123';
  var_c1.EXTEND;
  var_c1(1) := var_r1;
  dbe_output.print_line(var_r1.F1);
  dbe_output.print_line(var_r1.F2);
  dbe_output.print_line(var_c1(1).F1);
  dbe_output.print_line(var_c1(1).F2);
  SELECT 1 INTO var_c1(1).F1 FROM DUAL;
  SELECT '456' INTO var_c1(1).F2 FROM DUAL;
  dbe_output.print_line(var_r1.F1);
  dbe_output.print_line(var_r1.F2);
  dbe_output.print_line(var_c1(1).F1);
  dbe_output.print_line(var_c1(1).F2);
end;
/

--core
declare
 TYPE C1 IS VARRAY(4) OF varchar(100);
 TYPE C2 IS TABLE OF INTEGER;
 TYPE R1 IS RECORD(
  F1 C1,
  F2 C2);
 var_C1 C1 := C1('123', 234, 345);
 var_C2 C2;
 var_R1 R1;
begin
 var_C2 := C2();
 var_C2.EXTEND;
 var_C2(1) := '456';
 var_C2.EXTEND;
 var_C2(2) := '567';
 var_R1.F1 := var_C1;
 var_R1.F2 := var_C2;
 FOR i IN 1 .. var_R1.F1.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_R1.F1(i));
 END LOOP;
 FOR i IN 1 .. var_C2.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_C2(i));
 END LOOP;
 FOR i IN 1 .. var_R1.F2.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_R1.F2(i));
 END LOOP;
 FOR i IN 1 .. var_C2.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_C2(i));
 END LOOP;
 var_C1 := C1('NEW_123', 1234, 1345);
 FOR i IN 1 .. var_C2.COUNT() LOOP
  var_C2(i) := i;
 END LOOP;
 FOR i IN 1 .. var_R1.F1.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_R1.F1(i));
 END LOOP;
 FOR i IN 1 .. var_C1.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_C1(i));
 END LOOP;
 FOR i IN 1 .. var_R1.F2.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_R1.F2(i));
 END LOOP;
 FOR i IN 1 .. var_C2.COUNT() LOOP
  dbe_output.print_line(i || '.' || var_C2(i));
 END LOOP;

end;
/

create or replace type test_type_varchar1 is table of varchar2(24);  
/ 
	  	  
create or replace type test_type_varchar2 is table of varchar2(20);
/	 
	    
create or replace type test_type_varchar3 is table of varchar2(26);
/	 
	  
create or replace type test_type_varchar4 is VARRAY(5) of varchar2(24);
/

create or replace type test_type_varchar5 is VARRAY(5) of varchar2(10);
/

create or replace type test_type_varchar6_1 is VARRAY(3) of varchar2(30);
/

create or replace type test_type_varchar7 is VARRAY(3) of test_type_varchar6_1;
/

create or replace type test_type_number1 is table of number;
/	 	  

create or replace type dsh_record1 is object (f1 varchar2(10));
/

create or replace type dsh_record2 is object (f1 varchar2(20));
/

create or replace type dsh_type1 is VARRAY(3) of varchar2(30);
/


create table if not exists test_t1(f1 varchar(30));


--test cast func 1st arg contains collection
DECLARE
    i_n1 test_type_varchar7;
BEGIN
    i_n1 :=test_type_varchar7(test_type_varchar6_1('aaa','bbb'),test_type_varchar6_1('ccc','hjj'),test_type_varchar6_1('ddd','dff'));
    insert into test_t1 select * from table(cast(i_n1 as test_type_varchar4));
END;
/

--test cast func 2nd arg contains collection
DECLARE
    i_n1 test_type_varchar5;
BEGIN
    i_n1 :=test_type_varchar5('abc','dge');
    insert into test_t1 select * from table(cast(i_n1 as test_type_varchar7));
END;
/

DECLARE
    i_n1 test_type_varchar5;
BEGIN
    i_n1 :=test_type_varchar5('abc','dge');
    insert into test_t1 select * from table(cast(i_n1 as test_type_varchar7));
END;
/

--test cast 1st arg is local collection variant
DECLARE TYPE t_name IS TABLE OF varchar2(10); 
        i_n1 t_name := t_name(); 
BEGIN
        i_n1.EXTEND(2); 
        i_n1(1):='aaa'; 
        i_n1(2):='bbb';
	  dbe_output.print_line (i_n1(1));
	  dbe_output.print_line (i_n1(2));
	  insert  into test_t1 select column_value from table(cast(i_n1 as test_type_varchar1) ) ;
END;
/

--test cast 2nd arg is local collection variant
DECLARE 
		TYPE t_name IS TABLE OF varchar2(30); 
        i_n1 test_type_varchar1:=test_type_varchar1();
BEGIN
        i_n1.EXTEND(2); 
        i_n1(1):='jj'; 
        i_n1(2):='bbb';
	  dbe_output.print_line (i_n1(1));
	  dbe_output.print_line (i_n1(2));
	  insert  into test_t1 select column_value from table(cast(i_n1 as t_name) ) ;
END;
/


---test cast func precision
 declare
    a test_type_varchar1 := test_type_varchar1();
  begin 
     delete from test_t1;
         commit;
     a.extend(3);
         a(1) := '1';
         a(3) := '2';
       insert  into test_t1 select column_value from table(cast(a as test_type_varchar2 ) ) ;
         commit;
   end;
  /
  
  declare
    a test_type_varchar1 := test_type_varchar1();
  begin 
     delete from test_t1;
         commit;
     a.extend(3);
         a(1) := '1';
         a(2) := '123456789123456789123456';
       insert  into test_t1 select column_value from table(cast(a as test_type_varchar2 ) ) ;
         commit;
   end;
  /
  
--test cast transform type
 declare
    a test_type_varchar1 := test_type_varchar1();
  begin 
     delete from test_t1;
         commit;
     a.extend(3);
         a(1) := '1';
         a(3) := '2';
       insert  into test_t1 select column_value from table(cast(a as test_type_number1 ) ) ;
         commit;
   end;
  /
  

 --test cast func 1st arg is member of collection variant
 declare
    a test_type_varchar1 := test_type_varchar1();
  begin 
     delete from test_t1;
         commit;
     a.extend(3);
         a(1) := '1';
         a(3) := '2';
       insert  into test_t1 select column_value from table(cast(a(1) as test_type_number1 ) ) ;
         commit;
   end;
  /

--test cast using scalar as 2nd arg  
DECLARE 
    i_n1 int := 1; 
BEGIN
	dbe_output.print_line (i_n1);
    insert into test_t1 select * from table(cast(i_n1 as varchar(10)) ) ;
END;
/

--test cast(varray as record)
DECLARE
    i_n1 dsh_type1 := dsh_type1();
BEGIN
    i_n1.EXTEND(2);
    i_n1(1):='aaa';
    i_n1(2):='bbb';
    insert into test_t1 select * from table(cast(i_n1 as dsh_record2));
END;
/

--test cast(record as varray)
DECLARE
    i_n1 dsh_record1 ;
BEGIN
	i_n1 := dsh_record1('aaa');
    insert into test_t1 select * from table(cast(i_n1 as dsh_type3));
END;
/

--test cast success
DECLARE
    i_n1 test_type_varchar1 := test_type_varchar1();
BEGIN
    i_n1.EXTEND(3);
    i_n1(1):='dda';
    i_n1(2):='bhb';
    i_n1(3):='brf';
    insert into test_t1 select * from table(cast(i_n1 as test_type_varchar3));
END;
/

drop type test_type_varchar1 force;
drop type test_type_varchar2 force;
drop type test_type_varchar3 force;
drop type test_type_varchar4 force;
drop type test_type_varchar5 force;
drop type test_type_varchar6_1 force;
drop type test_type_varchar7 force;
drop type dsh_record1 force;
drop type dsh_record2 force;
drop type test_type_number1 force;
drop type dsh_type1 force;
drop table test_t1 purge;

----test record is null
create or replace type myrecord1 is object (a varchar2(10));
/

DECLARE
    x myrecord1 ;
BEGIN
	x := myrecord1('aafa');
	if x is NULL then
    dbe_output.print_line('x' || ' is null');
	end if;
END;
/

DECLARE
	type xxxx is record(a int, b int);
	v1 xxxx;
	v2 xxxx;
BEGIN
	v1.a := 3;
	if v1 is not NULL then
    dbe_output.print_line('v1' || v1.a||' is not null');
	end if;
END;
/

DECLARE
 type xxxx is record(
  a int,
  b int);
 TYPE C1 IS VARRAY(4) OF xxxx;
 v1 C1;
BEGIN
 v1 := C1();
 v1.EXTEND();
 v1(1) := NULL;
 v1(1).a := 3;
 v1(1).b := 5;
 dbe_output.print_line(v1(1).a);
 dbe_output.print_line(v1(1).b);
END;
/

create or replace type xxxx force is object (
  a int,
  b int);
/
DECLARE
 TYPE C1 IS VARRAY(4) OF xxxx;
 v1 C1;
BEGIN
 v1 := C1();
 v1.EXTEND();
 v1(1) := NULL;
 v1(1).a := 3;
 v1(1).b := 5;
 dbe_output.print_line(v1(1).a);
 dbe_output.print_line(v1(1).b);
END;
/

DECLARE
 type xxxx is record(
  a int,
  b int);
 type yyyy is record(
  a xxxx);
 v1 yyyy;
 v2 xxxx;
BEGIN
 v1.a := v2;
 v1.a.a := 3;
 v1.a.b := 5;
 dbe_output.print_line(v1.a.a);
 dbe_output.print_line(v1.a.b);
END;
/

-- test type table
drop TYPE if exists ATTR_TYPE10 force;
drop TYPE if exists ATTR_TYPE11 force;
drop TYPE if exists ATTR_TYPE12 force;
drop TYPE if exists zzz force;

CREATE OR REPLACE TYPE ATTR_TYPE12 FORCE AS OBJECT
( day int
) not final;
/

CREATE OR REPLACE TYPE ATTR_TYPE10 FORCE UNDER ATTR_TYPE12
( month ATTR_TYPE11
);
/

select TYPE_NAME,TYPE_CODE,ATTRIBUTES,METHODS,PREDEFINED,INCOMPLETE,FINAL,INSTANTIABLE,SUPERTYPE_NAME,LOCAL_ATTRIBUTES,LOCAL_METHODS from SYS.SYS_TYPES where TYPE_NAME='ATTR_TYPE10';
select TYPE_NAME,ATTR_NAME,ATTR_NO,ATTR_TYPE_MOD,ATTR_TYPE_NAME,ATTR_TYPE,LENGTH,PRECISION,SCALE,CHAR_SET,INHERITED from SYS.SYS_TYPE_ATTRS where TYPE_NAME='ATTR_TYPE10' ORDER BY ATTR_NO;

create or replace type ZZZ FORCE is VARRAY(20) OF ATTR_TYPE11;
/

select TYPE_NAME,TYPE_CODE,ATTRIBUTES,METHODS,PREDEFINED,INCOMPLETE,FINAL,INSTANTIABLE,SUPERTYPE_NAME,LOCAL_ATTRIBUTES,LOCAL_METHODS from SYS.SYS_TYPES where TYPE_NAME='ZZZ';
select TYPE_NAME,COLL_TYPE,UPPER_BOUND,ELEM_TYPE_MOD,ELEM_TYPE_NAME,LENGTH,PRECISION,SCALE,CHAR_SET,ELEM_STORAGE,NULLS_STORED from SYS.SYS_COLL_TYPES where TYPE_NAME='ZZZ';

CREATE OR REPLACE TYPE ATTR_TYPE11 FORCE AS OBJECT
( month int
);
/

select TYPE_NAME,ATTR_NAME,ATTR_NO,ATTR_TYPE_MOD,ATTR_TYPE_NAME,ATTR_TYPE,LENGTH,PRECISION,SCALE,CHAR_SET,INHERITED from SYS.SYS_TYPE_ATTRS where TYPE_NAME='ATTR_TYPE10' ORDER BY ATTR_NO;

declare
v1 ATTR_TYPE10;
v2 ZZZ;
begin
  v1 := ATTR_TYPE10(1, ATTR_TYPE11(5));
  v2 := ZZZ();
end;
/

select TYPE_NAME,ATTR_NAME,ATTR_NO,ATTR_TYPE_MOD,ATTR_TYPE_NAME,ATTR_TYPE,LENGTH,PRECISION,SCALE,CHAR_SET,INHERITED from SYS.SYS_TYPE_ATTRS where TYPE_NAME='ATTR_TYPE10' ORDER BY ATTR_NO;
select TYPE_NAME,COLL_TYPE,UPPER_BOUND,ELEM_TYPE_MOD,ELEM_TYPE_NAME,LENGTH,PRECISION,SCALE,CHAR_SET,ELEM_STORAGE,NULLS_STORED from SYS.SYS_COLL_TYPES where TYPE_NAME='ZZZ';

drop TYPE if exists ATTR_TYPE10 force;
drop TYPE if exists ATTR_TYPE11 force;
drop TYPE if exists ATTR_TYPE12 force;
drop TYPE if exists zzz force;

CREATE OR REPLACE TYPE ATTR_TYPE12 FORCE AS OBJECT
( day int
) not final;
/

CREATE OR REPLACE TYPE ATTR_TYPE11 FORCE AS OBJECT
( month int
);
/

CREATE OR REPLACE TYPE ATTR_TYPE10 FORCE UNDER ATTR_TYPE12
( month ATTR_TYPE11
);
/

select TYPE_NAME,TYPE_CODE,ATTRIBUTES,METHODS,PREDEFINED,INCOMPLETE,FINAL,INSTANTIABLE,SUPERTYPE_NAME,LOCAL_ATTRIBUTES,LOCAL_METHODS from SYS.SYS_TYPES where TYPE_NAME='ATTR_TYPE10';
select TYPE_NAME,ATTR_NAME,ATTR_NO,ATTR_TYPE_MOD,ATTR_TYPE_NAME,ATTR_TYPE,LENGTH,PRECISION,SCALE,CHAR_SET,INHERITED from SYS.SYS_TYPE_ATTRS where TYPE_NAME='ATTR_TYPE10' ORDER BY ATTR_NO;

create or replace type ZZZ FORCE is VARRAY(20) OF ATTR_TYPE11;
/

select TYPE_NAME,TYPE_CODE,ATTRIBUTES,METHODS,PREDEFINED,INCOMPLETE,FINAL,INSTANTIABLE,SUPERTYPE_NAME,LOCAL_ATTRIBUTES,LOCAL_METHODS from SYS.SYS_TYPES where TYPE_NAME='ZZZ';
select TYPE_NAME,COLL_TYPE,UPPER_BOUND,ELEM_TYPE_MOD,ELEM_TYPE_NAME,LENGTH,PRECISION,SCALE,CHAR_SET,ELEM_STORAGE,NULLS_STORED from SYS.SYS_COLL_TYPES where TYPE_NAME='ZZZ';

drop TYPE ATTR_TYPE11 force;

declare
v1 ATTR_TYPE10;
begin
  v1 := ATTR_TYPE10(1, ATTR_TYPE11(5));
end;
/

select TYPE_NAME,TYPE_CODE,ATTRIBUTES,METHODS,PREDEFINED,INCOMPLETE,FINAL,INSTANTIABLE,SUPERTYPE_NAME,LOCAL_ATTRIBUTES,LOCAL_METHODS from SYS.SYS_TYPES where TYPE_NAME='ATTR_TYPE10';
select TYPE_NAME,ATTR_NAME,ATTR_NO,ATTR_TYPE_MOD,ATTR_TYPE_NAME,ATTR_TYPE,LENGTH,PRECISION,SCALE,CHAR_SET,INHERITED from SYS.SYS_TYPE_ATTRS where TYPE_NAME='ATTR_TYPE10' ORDER BY ATTR_NO;

declare
v2 ZZZ;
begin
  v2 := ZZZ;
end;
/

select TYPE_NAME,TYPE_CODE,ATTRIBUTES,METHODS,PREDEFINED,INCOMPLETE,FINAL,INSTANTIABLE,SUPERTYPE_NAME,LOCAL_ATTRIBUTES,LOCAL_METHODS from SYS.SYS_TYPES where TYPE_NAME='ZZZ';
select TYPE_NAME,COLL_TYPE,UPPER_BOUND,ELEM_TYPE_MOD,ELEM_TYPE_NAME,LENGTH,PRECISION,SCALE,CHAR_SET,ELEM_STORAGE,NULLS_STORED from SYS.SYS_COLL_TYPES where TYPE_NAME='ZZZ';

drop TYPE if exists ATTR_TYPE10 force;
drop TYPE if exists ATTR_TYPE11 force;
drop TYPE if exists ATTR_TYPE12 force;
drop TYPE if exists zzz force;

CREATE OR REPLACE TYPE lv2_type FORCE AS OBJECT
( a NUMBER(6)
, b VARCHAR2(20)
) ;
/
CREATE OR REPLACE TYPE lv1_type FORCE AS OBJECT
( a NUMBER(6)
, b VARCHAR2(20)
, c lv2_type
) ;
/

declare
b lv1_type;
BEGIN
b := lv1_type(3,'abc', lv2_type(1, 'kkk'));
b := lv1_type(3,'abc', null);
dbe_output.print_line(b.a);
dbe_output.print_line(b.b);
b := null;
dbe_output.print_line(b.a || 'null');
dbe_output.print_line(b.b || 'null');
dbe_output.print_line(b.c.a || 'null');
dbe_output.print_line(b.c.b || 'null');
END;
/

CREATE OR REPLACE TYPE data_typ_error AS OBJECT
( year NUMBER,
MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
day NUMBER
);
/

CREATE OR REPLACE TYPE sys force AS OBJECT
( year NUMBER,
MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER
);
/
drop type sys;

CREATE OR REPLACE TYPE default_in_type FORCE AS OBJECT
( bbb int
, aaa int := 12
) ;
/

CREATE OR REPLACE TYPE cursor_in_type FORCE AS OBJECT
( cursor idx is select a from for_cursor_record_t1
) ;
/

CREATE OR REPLACE TYPE cursor_in_type FORCE AS OBJECT
( ct SYS_REFCURSOR
) ;
/

CREATE OR REPLACE TYPE data_typ3 FORCE AS OBJECT
( year NUMBER,
  prod NUMBER,
MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
MEMBER FUNCTION prod2(invent NUMBER) RETURN NUMBER
) NOT FINAL;
/

CREATE OR REPLACE TYPE DATA_TYP_NOT_INSTANT FORCE AS OBJECT
( year NUMBER,
MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
MEMBER FUNCTION prod2(invent NUMBER) RETURN NUMBER
) NOT INSTANTIABLE;
/

CREATE OR REPLACE TYPE DATA_TYP_NOT_INSTANT FORCE AS OBJECT
( year NUMBER,
MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
MEMBER FUNCTION prod2(invent NUMBER) RETURN NUMBER
) NOT FINAL NOT INSTANTIABLE;
/

CREATE OR REPLACE TYPE DATA_TYP_NOT_FINAL FORCE AS OBJECT
( year NUMBER,
MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
MEMBER FUNCTION prod2(invent NUMBER) RETURN NUMBER
) NOT FINAL;
/

CREATE OR REPLACE TYPE DATA_TYP_FINAL FORCE AS OBJECT
( year NUMBER,
MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
MEMBER FUNCTION prod2(invent NUMBER) RETURN NUMBER
);
/

CREATE OR REPLACE TYPE DATA_TYP_NOT_INSTANT FORCE AS OBJECT
( year NUMBER,
FINAL MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
NOT INSTANTIABLE MEMBER FUNCTION prod2(invent NUMBER) RETURN NUMBER,
FINAL NOT INSTANTIABLE MEMBER FUNCTION prod3(invent NUMBER) RETURN NUMBER
) NOT FINAL NOT INSTANTIABLE;
/

-- STATIC conflicts with NOT INSTANTIABLE
CREATE OR REPLACE TYPE DATA_TYP_NOT_INSTANT FORCE AS OBJECT
( year NUMBER,
MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
NOT INSTANTIABLE STATIC FUNCTION prod2(invent NUMBER) RETURN NUMBER,
NOT INSTANTIABLE MEMBER FUNCTION prod3(invent NUMBER) RETURN NUMBER
) NOT FINAL NOT INSTANTIABLE;
/
-- method does not override
CREATE OR REPLACE TYPE DATA_TYP_NOT_INSTANT FORCE AS OBJECT
( year NUMBER,
OVERRIDING MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
NOT INSTANTIABLE MEMBER FUNCTION prod2(invent NUMBER) RETURN NUMBER,
NOT INSTANTIABLE MEMBER FUNCTION prod3(invent NUMBER) RETURN NUMBER
) NOT FINAL NOT INSTANTIABLE;
/
-- name of subproc cannot be duplicated
CREATE OR REPLACE TYPE DATA_TYP_NOT_INSTANT FORCE AS OBJECT
( year NUMBER,
MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
OVERRIDING MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
NOT INSTANTIABLE MEMBER FUNCTION prod2(invent NUMBER) RETURN NUMBER,
NOT INSTANTIABLE MEMBER FUNCTION prod3(invent NUMBER) RETURN NUMBER
) NOT FINAL NOT INSTANTIABLE;
/

CREATE OR REPLACE TYPE DATA_TYP_NOT_INSTANT FORCE AS OBJECT
( year NUMBER,
FINAL MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
NOT INSTANTIABLE MEMBER FUNCTION prod2(invent NUMBER) RETURN NUMBER
) NOT FINAL NOT INSTANTIABLE;
/

-- TYPE_DAY->TYPE_MONTH->TYPE_DAY fail
CREATE OR REPLACE TYPE TYPE_DAY FORCE AS OBJECT
( day NUMBER
);
/
CREATE OR REPLACE TYPE TYPE_MONTH FORCE AS OBJECT
( month NUMBER,
  day TYPE_DAY
);
/
CREATE OR REPLACE TYPE TYPE_DAY FORCE AS OBJECT
( year NUMBER,
  month TYPE_MONTH
);
/

-- DATA_TYP_USING_REPLACE attr using, replace DATA_TYP_USING_REPLACE success
CREATE OR REPLACE TYPE DATA_TYP_USING_REPLACE FORCE AS OBJECT
( year NUMBER
);
/
create or replace function FVT_FUN_01_01(id int) return int 
is
 count_row int := 0;
 kkk DATA_TYP_USING_REPLACE;
begin
 kkk := DATA_TYP_USING_REPLACE(2);
 execute immediate 'CREATE OR REPLACE TYPE DATA_TYP_USING_REPLACE FORCE AS OBJECT
( year NUMBER,
day NUMBER
);';
 dbe_output.print_line(kkk.year);
 execute immediate 'declare xxx DATA_TYP_USING_REPLACE; begin xxx := DATA_TYP_USING_REPLACE(5,6); dbe_output.print_line(xxx.year); dbe_output.print_line(xxx.day); end;';
 return count_row;
end;
/
declare
a int;
begin
 a := FVT_FUN_01_01(3);
end;
/

-- object can not use %rowtype and %type
drop table if exists TYPE_TABLE;
CREATE TABLE TYPE_TABLE(a int, b int);
CREATE OR REPLACE TYPE TYPE_OF_TABLE FORCE AS OBJECT
( year TYPE_TABLE%rowtype
);
/
CREATE OR REPLACE TYPE TYPE_OF_TABLE FORCE AS OBJECT
( day TYPE_TABLE.a%type
);
/

-- different type construct setvalue fail
CREATE OR REPLACE TYPE CONSTRUCT_TYPE FORCE AS OBJECT
( year int
);
/
CREATE OR REPLACE TYPE OTHER_CONSTRUCT_TYPE FORCE AS OBJECT
( year int
);
/
CREATE OR REPLACE PROCEDURE USE_CONSTRUCT_PROC IS
a CONSTRUCT_TYPE;
BEGIN
  a := OTHER_CONSTRUCT_TYPE(5);
END;
/

-- success
CREATE OR REPLACE TYPE OVERRIDING_METHOD_TYPE FORCE AS OBJECT
( year NUMBER,
MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
MEMBER FUNCTION prod2(invent NUMBER) RETURN NUMBER
) NOT INSTANTIABLE NOT FINAL;
/

-- object must have attibute fail
CREATE OR REPLACE TYPE NO_ATTR_TYPE FORCE AS OBJECT
(
MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER,
MEMBER FUNCTION prod2(invent NUMBER) RETURN NUMBER
);
/

CREATE OR REPLACE TYPE ATTR_TYPE2 FORCE AS OBJECT
( month int
);
/
CREATE OR REPLACE TYPE ATTR_TYPE3 FORCE AS OBJECT
( month int
);
/
CREATE OR REPLACE TYPE ATTR_TYPE FORCE AS OBJECT
( year int,
  month ATTR_TYPE2
);
/
-- oracle error
declare
v1 ATTR_TYPE3;
v2 ATTR_TYPE2;
begin
  v1 := ATTR_TYPE2(2);
end;
/
-- oracle error
declare
v1 ATTR_TYPE3;
v2 ATTR_TYPE2;
begin
  v1 := ATTR_TYPE3(2);
  v2 := ATTR_TYPE2(3);
  v2 := v1;
end;
/
-- oracle success
declare
v1 ATTR_TYPE2;
v2 ATTR_TYPE2;
begin
  v1 := ATTR_TYPE2(2);
  v2 := v1;
  dbe_output.print_line(v2.month);
end;
/
-- oracle success
declare
v1 ATTR_TYPE2;
v2 ATTR_TYPE2;
begin
  v1 := ATTR_TYPE2(2);
  v2 := v1;
  v2.month := 5;
  dbe_output.print_line(v2.month);
end;
/
-- oracle success
declare
v1 ATTR_TYPE2;
v2 ATTR_TYPE2;
v3 int;
begin
  v1 := null;
  v2 := v1;
  v3 := v1.month;
  dbe_output.print_line(v3 || 'null');
  v3 := v2.month;
  dbe_output.print_line(v3 || 'null');
end;
/
-- oracle error
declare
v1 ATTR_TYPE2;
v3 int := 0;
begin
  v1 := null;
  v1.month := v3;
end;
/
-- oracle error
declare
v1 ATTR_TYPE2;
v3 int;
begin
  v1 := v3;
end;
/
-- oracle error
declare
v1 ATTR_TYPE;
begin
  v1 := ATTR_TYPE(2, 3);
end;
/
DROP TABLE IF EXISTS TYPE_TEST_TABLE;
CREATE TABLE TYPE_TEST_TABLE(a INT);
-- oracle error
declare
v1 ATTR_TYPE2;
v2 TYPE_TEST_TABLE%ROWTYPE;
begin
  v1 := ATTR_TYPE2(2);
  v2.a := 4;
  v1 := v2;
end;
/
-- oracle error
declare
v1 ATTR_TYPE2;
v2 TYPE_TEST_TABLE%ROWTYPE;
begin
  v1 := ATTR_TYPE2(2);
  v2 := v1;
end;
/
-- oracle error but cantian support
declare
type zzz is record(a varchar(10)); 
v1 zzz;
v2 TYPE_TEST_TABLE%ROWTYPE;
begin
  v1.a := '2';
  v2 := v1;
  dbe_output.print_line(v2.a);
end;
/
-- oracle error
declare
type zzz is record(a varchar(10)); 
type yyy is record(a char(10)); 
v1 zzz;
v2 yyy;
begin
  v1.a := '2';
  v2 := v1;
end;
/
-- oracle error
declare
type zzz is record(a varchar(10)); 
v1 zzz;
v2 ATTR_TYPE2;
begin
  v2 := ATTR_TYPE2(2);
  v1 := v2;
end;
/
-- oracle error
declare
type zzz is record(a int); 
type yyy is record(a int); 
v1 zzz;
v2 yyy;
begin
  v1.a := 2;
  v2 := v1;
end;
/
-- oracle error
declare
type zzz is record(a ATTR_TYPE2); 
type yyy is record(a ATTR_TYPE2); 
v1 zzz;
v2 yyy;
begin
  v1.a := ATTR_TYPE2(3);
  v2 := v1;
end;
/
-- oracle success
declare
type zzz is record(a int); 
v1 zzz;
v2 zzz;
begin
  v1.a := 2;
  v2 := v1;
end;
/
-- oracle success
declare
type zzz is record(a varchar(10)); 
type yyy is record(b char(10)); 
v1 zzz;
v2 yyy;
begin
  v1.a := '2';
  v2.b := v1.a;
  dbe_output.print_line(v2.b);
end;
/
-- oracle success
declare
type zzz is record(a varchar(10)); 
v1 zzz;
v2 TYPE_TEST_TABLE%ROWTYPE;
begin
  v1.a := '2';
  v2.a := v1.a;
  dbe_output.print_line(v2.a);
end;
/
-- oracle success
declare
type zzz is record(a int); 
v1 zzz;
v2 TYPE_TEST_TABLE%ROWTYPE;
begin
  v1.a := 2;
  v2 := v1;
  dbe_output.print_line(v2.a);
end;
/
-- oracle success
declare
type zzz is record(a int); 
v1 zzz;
v2 TYPE_TEST_TABLE%ROWTYPE;
begin
  v2.a := 2;
  v1 := v2;
  dbe_output.print_line(v1.a);
end;
/
-- oracle success
declare
v1 TYPE_TEST_TABLE%ROWTYPE;
v2 TYPE_TEST_TABLE%ROWTYPE;
begin
  v1.a := 2;
  v2 := v1;
  dbe_output.print_line(v2.a);
end;
/
-- oracle error
declare
v1 ATTR_TYPE;
begin
  v1 := ATTR_TYPE(2, null);
  v1.month.month := 0;
end;
/
-- oracle success
declare
v1 ATTR_TYPE;
begin
  v1 := ATTR_TYPE(2, null);
  v1.month := ATTR_TYPE2(3);
  v1.month.month := 0;
end;
/
-- oracle success
declare
type zzz is record(a number); 
type yyy is record(a int, b zzz); 
v1 yyy;
v2 TYPE_TEST_TABLE%ROWTYPE;
begin
  v1.b.a := 2;
  v2 := v1.b;
  dbe_output.print_line(v2.a);
end;
/

-- creating a FINAL NOT INSTANTIABLE type fail
CREATE OR REPLACE TYPE USING_ATTR_UPDATE_TYPE FORCE AS OBJECT
( year NUMBER,
NOT INSTANTIABLE MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER
) NOT INSTANTIABLE;
/
-- type with NOT INSTANTIABLE methods must be declared NOT INSTANTIABLE
CREATE OR REPLACE TYPE USING_ATTR_UPDATE_TYPE FORCE AS OBJECT
( year NUMBER,
NOT INSTANTIABLE MEMBER FUNCTION prod(invent NUMBER) RETURN NUMBER
);
/

drop TYPE if exists c_v_s force;
drop TYPE if exists c_n_s force;
drop TYPE if exists c_n_v force;
drop TYPE if exists c_v_n force;
drop TYPE if exists r_s_s force;
drop TYPE if exists r_s_r_n_v force;
drop TYPE if exists c_v_r force;
drop TYPE if exists c_n_r force;

create type c_v_s is varray(3) of varchar(100);
/      
create type c_n_s is table of number;
/      
create type c_n_v is table of c_v_s;
/      
create type c_v_n is varray(3) of c_n_s;
/      
create type r_s_s FORCE AS OBJECT(a int, b int);
/      
create type r_s_r_n_v FORCE AS OBJECT(a int, b r_s_s, c c_n_v, d c_v_n);
/      
create type c_v_r is varray(3) of r_s_r_n_v;
/      
create type c_n_r is table of r_s_r_n_v;
/

DECLARE
	v5 r_s_s;
BEGIN
	v5.b := 3;
END;
/

DECLARE
	v5 r_s_s;
	v7 c_v_r;
BEGIN
	if v7(2).b is NULL then
      dbe_output.print_line('v7(2).b' ||' is null');
	end if;
END;
/

DECLARE
	v5 r_s_s;
	type l_r_s_r_n_v is record(a int, c c_v_r, d c_n_r);
	v12 l_r_s_r_n_v:= l_r_s_r_n_v();
BEGIN
    null;		
END;
/

DECLARE
	v5 r_s_s;
	type l_r_s_r_n_v is record(a int, c c_v_r, d c_n_r);
	v12 l_r_s_r_n_v;
BEGIN
	if v12.c(1).a is NULL then
      dbe_output.print_line('v12.c(1).a' ||' is null');
	end if;			
END;
/

DECLARE
	type l_r_s_s is record(a int, b int);
    type l_r_s_r_n_v is record(a int, b l_r_s_s, c c_v_r, d c_n_r);
	type l_c_v_r is varray(3) of l_r_s_r_n_v;
	v13 l_c_v_r := l_c_v_r();
	v12 l_r_s_r_n_v;
BEGIN
    v13.extend();
	v13(1):= v12;
	v13 := null;
	dbe_output.print_line('v13.count' || v13.count());
END;
/

DECLARE
	
	type l_c_n_v is table of c_v_s;
	type l_c_v_n is varray(3) of c_n_s;
	type l_r_s_s is record(a int, b int);
	type l_r_s_r_n_v is record(a int, b l_r_s_s, c c_v_r, d c_n_r);
	type l_c_v_r is varray(3) of l_r_s_r_n_v;
	type l_c_n_r is table of l_r_s_r_n_v;
	
	v1 c_v_s := c_v_s(123, 456, 789);
	v2 c_n_s := c_n_s(123, 456, 789);
	v3 c_n_v := c_n_v(v1, c_v_s(111, 222, 333));
	v4 c_v_n := c_v_n(v2, c_n_s(111, 222, 333));
	v5 r_s_s := r_s_s(1,1);

	v6 r_s_r_n_v := r_s_r_n_v(1, v5, v3, v4);
	v61 r_s_r_n_v;
	v7 c_v_r := c_v_r(v6, v6);
	v8 c_n_r := c_n_r(v6, v6, v6);

    v11 l_r_s_s;
	v12 l_r_s_r_n_v;
	v121 l_r_s_r_n_v;
	v13 l_c_v_r := l_c_v_r();
	v14 l_c_n_r := l_c_n_r();
	
BEGIN
	if v11.a is NULL then
      dbe_output.print_line('v11.a' ||' is null');
	end if;
	v11.b := 3;
	if v11.b is not NULL then
      dbe_output.print_line('v11.b = ' || v11.b ||' is not null');
	end if;
    v11:=null;
	if v11.b is NULL then
      dbe_output.print_line('v11.b' ||' is null');
	end if;
	
	-- local record assign
	if v12.b.b is NULL then
      dbe_output.print_line('v12.b.b' ||' is null');
	end if;
	
	v12.b.a:=3;
	if v12.b.a is not NULL then
      dbe_output.print_line('v12.b.a = ' || v12.b.a ||' is not null');
	end if;
	
	if v12.c is NULL then
      dbe_output.print_line('v12.c' ||' is null');
	end if;
	v12.c := v7;
	v12.d := v8;
	v121:= v12;
    v12 := null;
	if v12.b.b is NULL then
      dbe_output.print_line('v12.b.b' ||' is null');
	end if;
	
	if v12.c is NULL then
      dbe_output.print_line('v12.c' ||' is null');
	end if;	
	
	-- object record assign
	v61 := v6;
	v6 :=null;
	if v6 is NULL then
      dbe_output.print_line('v6' ||' is null');
	end if;
	
	dbe_output.print_line('v61.a = ' || v61.a);
    dbe_output.print_line('v61.b.a = ' || v61.a);
	dbe_output.print_line('v61.c(1)(1) = ' || v61.c(1)(1));
	dbe_output.print_line('v61.d(1)(2) = ' || v61.d(1)(2));
	
	-- collection assign, record and object is same
	v13.extend();
	v13(1):= v121;
	v13 := null;
	
	v14.extend();
	v14(1):= v121;
    v14(1).a := 100;
	v14(1).b.a := 100;
	v14(1).b.b := 100;
	dbe_output.print_line('v14(1).a = ' || v121.a);
	dbe_output.print_line('v14(1).b.a = ' || v121.b.a);
	dbe_output.print_line('v14(1).b.b = ' || v121.b.b);
	v14 := null;
	dbe_output.print_line('v121.a = ' || v121.a);
	dbe_output.print_line('v121.b.a = ' || v121.b.a);
	dbe_output.print_line('v121.b.b = ' || v121.b.b);
	
END;
/

drop type c_v_s FORCE;
drop type c_n_s FORCE;
drop type c_n_v FORCE;
drop type c_v_n FORCE;
drop type r_s_s FORCE;
drop type r_s_r_n_v FORCE;
drop type c_v_r FORCE;
drop type c_n_r FORCE;

drop PROCEDURE if exists print;
CREATE PROCEDURE print (n INTEGER) IS
BEGIN
IF n IS NOT NULL THEN
dbe_output.print_line(n);
ELSE
dbe_output.print_line('NULL');
END IF;
END print;
/

drop TYPE if exists v_type;
CREATE TYPE v_type IS varray(100) OF NUMBER;
/
drop PROCEDURE if exists print_va;
CREATE PROCEDURE print_va(va v_type) IS
 i NUMBER;
BEGIN
 i := va.FIRST;
 IF i IS NULL THEN
  dbe_output.print_line('va is empty');
 ELSE
  WHILE i IS NOT NULL LOOP
   dbe_output.print_line('va.(' || i || ') = ');
   print(va(i));
   i := va.NEXT(i);
  END LOOP;
 END IF;
 dbe_output.print_line('---');
END print_va;
/

DECLARE
 va v_type := v_type(11, 22, 33, 44, 55, 66);
BEGIN
 print_va(va);
 va.DELETE();
 print_va(va);
 va(1) := 1;
 va.extend(3, 1);
 print_va(va);
 va.TRIM; -- Trim last element
 print_va(va);
END;
/

DECLARE
 va v_type := v_type(11, 22, 33, 44, 55, 66);
BEGIN
 print_va(va);
 va.DELETE();
 print_va(va);
 va.extend();
 va(1) := 1;
 va.extend(3, 1);
 print_va(va);
 va.TRIM; -- Trim last element
 print_va(va);
END;
/

drop TYPE if exists nt_type;
CREATE TYPE nt_type IS table OF NUMBER;
/
drop PROCEDURE if exists print_nt;
CREATE PROCEDURE print_nt(nt nt_type) IS
 i NUMBER;
BEGIN
 i := nt.FIRST;
 IF i IS NULL THEN
  dbe_output.print_line('nt is empty');
 ELSE
  WHILE i IS NOT NULL LOOP
   dbe_output.print_line('nt.(' || i || ') = ');
   print(nt(i));
   i := nt.NEXT(i);
  END LOOP;
 END IF;
 dbe_output.print_line('---');
END print_nt;
/

DECLARE
 nt nt_type := nt_type(11, 22, 33, 44, 55, 66);
BEGIN
 print_nt(nt);
 nt.DELETE(2); -- Delete second element
 print_nt(nt);
 nt(2) := 2222; -- Restore second element
 print_nt(nt);
 nt.DELETE(2, 4); -- Delete range of elements
 print_nt(nt);
 nt(3) := 3333; -- Restore third element
 print_nt(nt);
 nt.DELETE; -- Delete all elements
 print_nt(nt);
END;
/

DECLARE
 nt nt_type := nt_type(11, 22, 33, 44, 55, 66);
BEGIN
 print_nt(nt);
 nt.TRIM; -- Trim last element
 print_nt(nt);
 nt.DELETE(4); -- Delete fourth element
 print_nt(nt);
 nt.TRIM(2); -- Trim last two elements
 print_nt(nt);
END;
/

DECLARE
 nt nt_type := nt_type(11, 22, 33);
BEGIN
 print_nt(nt);
 nt.EXTEND(2, 1); -- Append two copies of first element
 print_nt(nt);
 nt.DELETE(5); -- Delete fifth element
 print_nt(nt);
 nt.EXTEND; -- Append one null element
 print_nt(nt);
END;
/

drop PROCEDURE print_nt;

drop PROCEDURE print_va;

drop type nt_type FORCE;

drop type v_type FORCE;


DECLARE
 TYPE NumList IS TABLE OF INTEGER;
 n NumList := NumList(1, 3, 5, 7);
BEGIN
 n.DELETE(2); -- Delete second element
 FOR i IN 1 .. 6 LOOP
  IF n.EXISTS(i) THEN
   dbe_output.print_line('n(' || i || ') = ' || n(i));
  ELSE
   dbe_output.print_line('n(' || i || ') does not exist');
  END IF;
 END LOOP;
END;
/
drop TYPE if exists team_type;
CREATE TYPE team_type IS VARRAY(4) OF VARCHAR2(15);
/
drop PROCEDURE if exists print_team;
 CREATE PROCEDURE print_team(heading VARCHAR2, team team_type) IS
 BEGIN
  dbe_output.print_line(heading);
  IF team IS NULL THEN
   dbe_output.print_line('Does not exist');
  ELSIF team.FIRST IS NULL THEN
   dbe_output.print_line('Has no members');
  ELSE
   FOR i IN team.FIRST .. team.LAST LOOP
    dbe_output.print_line(i || '. ' || team(i));
   END LOOP;
  END IF;
  dbe_output.print_line('---');
 END;
 /
 
DECLARE
 team team_type;

BEGIN
 print_team('Team Status:', team);
 team := team_type(); -- Team is funded, but nobody is on it.
 print_team('Team Status:', team);
 team := team_type('John', 'Mary'); -- PUT_LINE 2 members on team.
 print_team('Initial Team:', team);
 team := team_type('Arun', 'Amitha', 'Allan', 'Mae'); -- Change team.
 print_team('New Team:', team);
END;
/
drop TYPE team_type force;


drop PROCEDURE print_team;

drop TYPE if exists NumList;
CREATE  TYPE NumList IS VARRAY(10) OF INTEGER;
/

drop PROCEDURE if exists print_count_and_last;
CREATE PROCEDURE print_count_and_last(n NumList) IS
 BEGIN
  dbe_output.print_line('n.COUNT = ' || n.COUNT || ', ');
  dbe_output.print_line('n.LAST = ' || n.LAST);
 END print_count_and_last;
/

DECLARE
 n NumList := NumList(1, 3, 5, 7);
 
BEGIN
 print_count_and_last(n);
 n.EXTEND(3);
 print_count_and_last(n);
 n.TRIM(5);
 print_count_and_last(n);
END;
/

drop type NumList FORCE;


drop PROCEDURE print_count_and_last;


DECLARE
 TYPE va_type IS VARRAY(4) OF INTEGER;
 va va_type := va_type(2, 4); -- varray
 TYPE nt_type IS TABLE OF INTEGER;
 nt nt_type := nt_type(1, 3, 5); -- nested table
BEGIN
 dbe_output.print_line('va.COUNT = ');
 print(va.COUNT);
 dbe_output.print_line('va.LIMIT = ');
 print(va.LIMIT);
 dbe_output.print_line('nt.COUNT = ');
 print(nt.COUNT);
 dbe_output.print_line('nt.LIMIT = ');
 print(nt.LIMIT);
END;
/

DECLARE
 TYPE Arr_Type IS VARRAY(10) OF NUMBER;
 v_Numbers Arr_Type := Arr_Type();
BEGIN
 v_Numbers.EXTEND(4);
 v_Numbers(1) := 10;
 v_Numbers(2) := 20;
 v_Numbers(3) := 30;
 v_Numbers(4) := 40;
 dbe_output.print_line(NVL(v_Numbers.prior(0), 1));
 dbe_output.print_line(NVL(v_Numbers.prior(5), 1));
 dbe_output.print_line(NVL(v_Numbers.next(5), 1));
 dbe_output.print_line(NVL(v_Numbers.prior(v_Numbers.first()), 1));
 dbe_output.print_line(NVL(v_Numbers.next(v_Numbers.last()), 1));
 dbe_output.print_line(NVL(v_Numbers.prior(3400), 1));
 dbe_output.print_line(NVL(v_Numbers.next(3400), 1));
END;
/

DECLARE
 TYPE nt_Type IS table OF NUMBER;
 v_Numbers nt_Type := nt_Type();
BEGIN
 v_Numbers.EXTEND(4);
 v_Numbers(1) := 10;
 v_Numbers(2) := 20;
 v_Numbers(3) := 30;
 v_Numbers(4) := 40;
 dbe_output.print_line(NVL(v_Numbers.prior(0), 1));
 dbe_output.print_line(NVL(v_Numbers.prior(5), 1));
 dbe_output.print_line(NVL(v_Numbers.next(5), 1));
 dbe_output.print_line(NVL(v_Numbers.prior(v_Numbers.first()), 1));
 dbe_output.print_line(NVL(v_Numbers.next(v_Numbers.last()), 1));
 dbe_output.print_line(NVL(v_Numbers.prior(3400), 1));
 dbe_output.print_line(NVL(v_Numbers.next(3400), 1));
END;
/


DECLARE
 TYPE nt_Type IS table OF NUMBER;
 v_Numbers nt_Type := nt_Type();
BEGIN
 v_Numbers.EXTEND(4);
 v_Numbers(1) := 10;
 v_Numbers(2) := 20;
 v_Numbers(3) := 30;
 v_Numbers(4) := 40;
 v_Numbers.delete(4);
 v_Numbers.delete(1);
 v_Numbers(3) := null;
 dbe_output.print_line(v_Numbers.prior(0));
 dbe_output.print_line(v_Numbers.prior(5));
 dbe_output.print_line(v_Numbers.next(5));
 dbe_output.print_line(v_Numbers.next(-1));
 dbe_output.print_line(v_Numbers.next(1));
 dbe_output.print_line(v_Numbers.prior(3400));
 dbe_output.print_line(v_Numbers.next(0));
END;
/

DECLARE
TYPE NumList IS TABLE OF NUMBER;
n NumList := NumList(1, 2, NULL, NULL, 5, NULL, 7, 8, 9, NULL);
idx INTEGER;
BEGIN
 dbe_output.print_line('First to last:');
 idx := n.FIRST;
 WHILE idx IS NOT NULL LOOP
  dbe_output.print_line('n(' || idx || ') = ');
  print(n(idx));
  idx := n.NEXT(idx);
 END LOOP;
 dbe_output.print_line('--------------');
 dbe_output.print_line('Last to first:');
 idx := n.LAST;
 WHILE idx IS NOT NULL LOOP
  dbe_output.print_line('n(' || idx || ') = ');
  print(n(idx));
  idx := n.PRIOR(idx);
 END LOOP;
END;
/

DECLARE
TYPE nt_type IS TABLE OF NUMBER;
nt nt_type := nt_type(18, NULL, 36, 45, 54, 63);
BEGIN
nt.DELETE(4);
dbe_output.print_line('nt(4) was deleted.');
FOR i IN 1..7 LOOP
dbe_output.print_line('nt.PRIOR(' || i || ') = '); print(nt.PRIOR(i));
dbe_output.print_line('nt.NEXT(' || i || ') = '); print(nt.NEXT(i));
END LOOP;
END;
/
drop PROCEDURE print;


create or replace type body FLIGHT_SCH_TYPE as
    member function DAYS_FN(FLIGHT_DAY1 in number) return varchar2
is
    disp_day varchar2(20) ;
begin  
    if flight_day1 = 1 then
        disp_day := 'Sunday' ;       
    elsif flight_day1 = 2 then
        disp_day := 'Monday' ;        
    elsif flight_day1 = 3 then  
        disp_day := 'Tuesday' ;     
    elsif flight_day1 = 4 then  
        disp_day := 'Wednesday' ;     
    elsif flight_day1 = 5 then    
        disp_day := 'Thursday' ;         
    elsif flight_day1 = 6 then      
        disp_day := 'Friday   ' ;   
    elsif flight_day1 = 7 then
        disp_day := 'Saturday' ;  
    end if ;         
    return disp_day ; 
    end ;
end ;
/

DECLARE
  TYPE ORG_TABLE_TYPE IS TABLE OF VARCHAR2(25)
  INDEX BY BINARY_INTEGER;
  V_ORG_TABLE ORG_TABLE_TYPE:= ORG_TABLE_TYPE('123', '234', '345');
BEGIN
  dbe_output.print_line('ok');
END;
/

DECLARE
 TYPE ORG_TABLE_TYPE IS TABLE OF VARCHAR2(25);
 V_ORG_TABLE ORG_TABLE_TYPE:= '2';
BEGIN
 dbe_output.print_line('ok');
END;
/

DECLARE
 TYPE ORG_TABLE_TYPE IS TABLE OF VARCHAR2(25);
 V_ORG_TABLE1 ORG_TABLE_TYPE:= ORG_TABLE_TYPE('abc');
 V_ORG_TABLE2 ORG_TABLE_TYPE:= V_ORG_TABLE1;
BEGIN
 dbe_output.print_line(V_ORG_TABLE1(1));
 dbe_output.print_line(V_ORG_TABLE2(1));
END;
/

drop table if exists record_table;
create table record_table(id int);
declare
	type zzz is record(a int := 1);
	a zzz;
	b record_table%rowtype := a;
begin
	SYS.dbe_output.print_line(b.id);
end;
/

DECLARE
TYPE t1 IS VARRAY(10) OF INTEGER; -- varray of integer
va t1 := t1(2,3,5);
TYPE nt1 IS VARRAY(10) OF t1; -- varray of varray of integer
nva nt1 := nt1(va, t1(55,6,73), t1(2,4), va);
i INTEGER;
va1 t1;
BEGIN
i := nva(2)(3);
dbe_output.print_line('i = ' || i);
nva.EXTEND;
nva(5) := t1(56, 32); -- replace inner varray elements
nva(4) := t1(45,43,67,43345); -- replace an inner integer element
nva(4)(4) := 1;
nva(4).EXTEND;
END;
/

DECLARE
  TYPE tb1 IS TABLE OF VARCHAR2(20); -- nested table of strings
  vtb1 tb1 := tb1('one', 'three');
  TYPE ntb1 IS TABLE OF tb1; -- nested table of nested tables of strings
  vntb1 ntb1 := ntb1(vtb1);
BEGIN
  vntb1.EXTEND;
  vntb1(2) := vntb1(1);
  vntb1.DELETE(1); -- delete first element of vntb1
  vntb1(2).DELETE(1); -- delete first string from second table in nested table
END;
/

--Data Type Compatibility for Collection Assignment
DECLARE
  TYPE triplet IS VARRAY(3) OF VARCHAR2(15);
  group1 triplet := triplet('Jones', 'Wong', 'Marceau');
  group2 triplet;
BEGIN
  group2 := group1; -- succeeds
END;
/

--%ROWTYPE Variable Represents Partial Database Table Row
DROP TABLE if exists t1;
create table t1 (a int, b int, c int,d VARCHAR2(10));
DECLARE
  CURSOR cc IS
    SELECT a, b, c
    FROM t1;
  friend cc%ROWTYPE;
BEGIN
  friend.a := 1;
  friend.b := 2;
  friend.c := 3;
  dbe_output.print_line (
    friend.a || ', ' ||
    friend.b || ', ' ||
    friend.c
);
END;
/

--Inserting %ROWTYPE Record into Table (Right)
DROP TABLE if exists plch_departure;
CREATE TABLE plch_departure (destination VARCHAR2(100),departure_time DATE,delay NUMBER(10));
DECLARE
dep_rec plch_departure%rowtype;
BEGIN
dep_rec.destination := 'X';
dep_rec.departure_time := SYSDATE;
dep_rec.delay := 1500;
INSERT INTO plch_departure (destination, departure_time, delay)
VALUES (dep_rec.destination, dep_rec.departure_time, dep_rec.delay);
END;
/

--Assigning %ROWTYPE Record to RECORD Type Record
DROP TABLE if exists t1;
create table t1 (a int, b int, c int,d VARCHAR2(10));
DECLARE
  TYPE name_rec IS RECORD (
    first t1.a%TYPE ,
    last t1.b%TYPE
  );
  CURSOR c IS
    SELECT a, b
    FROM t1;
  target name_rec;
  source c%ROWTYPE;
BEGIN
  source.a := 1; source.b := 2;
  dbe_output.print_line (
    'source: ' || source.a || ' ' || source.b
  );
  target := source;
  dbe_output.print_line (
    'target: ' || target.first || ' ' || target.last
  );
END;
/

--test default
DROP TABLE if exists t1;
create table t1 (a int);
DECLARE
  TYPE name_rec IS RECORD (
    first t1.a%TYPE DEFAULT 1
  );
  target name_rec;
    TYPE name_rec2 IS RECORD (
    rec2 t1%ROWTYPE DEFAULT target
  );
  target2 name_rec2;
    CURSOR c IS
    SELECT a
    FROM t1;
    target3 c%ROWTYPE DEFAULT target;
BEGIN
  dbe_output.print_line ('target2: ' || target2.rec2.a);
  dbe_output.print_line ('target3: ' || target3.a);
END;
/

--test default
create or replace type vv1 is varray(4) of varchar2(15);
/
DROP TABLE if exists t1;
create table t1 (a int, b int);
DECLARE
  TYPE name_rec1 IS RECORD (
    rec1 t1.a%TYPE DEFAULT 1,
    rec1_2 int DEFAULT 2
  );
  target1 name_rec1;
  TYPE name_rec2 IS RECORD (
    rec2 t1%ROWTYPE DEFAULT target1
  );
  target2 name_rec2;
  v_def_1 vv1 := vv1('aaaa');
  TYPE name_rec3 IS RECORD (
    rec3 name_rec2 DEFAULT target2,
    rec3_2 vv1 DEFAULT v_def_1,
    rec3_3 int DEFAULT 1
  );
  v_def_2 vv1 := vv1('bbbb');
  target3 name_rec3;
  TYPE name_rec4 IS RECORD (
    rec4 name_rec3 DEFAULT target3,
    rec4_2 vv1 DEFAULT v_def_2,
    rec4_3 int DEFAULT 1
  );
  target4 name_rec4;
  TYPE name_rec5 IS RECORD (
    rec5 name_rec4 DEFAULT target4
  );
  target5 name_rec5;
BEGIN
  dbe_output.print_line ('DEFAULT: ' || target5.rec5.rec4.rec3.rec2.a);
END;
/


drop table if exists FVT_PRO_TAB_001_0008;
create table FVT_PRO_TAB_001_0008
(
	id int,
	name varchar2(10),
	time date,
	age number
);
insert into FVT_PRO_TAB_001_0008 values('1','feng',to_date('2018','yyyy'),25);
insert into FVT_PRO_TAB_001_0008 values('2','li',to_date('2017','yyyy'),24);
insert into FVT_PRO_TAB_001_0008 values('3','wang',to_date('2016','yyyy'),23);
insert into FVT_PRO_TAB_001_0008 values('4','zhang',to_date('2015','yyyy'),22);
create or replace procedure proc_for_in_loop19( a int,b out int ,c in out varchar2) as
  d int :=0;
  e int :=0;
begin
  select a.id into d from FVT_PRO_TAB_001_0008 a;
  dbe_output.print_line('d='||d);
end;
/
drop table if exists FVT_PRO_TAB_001_0008;

create or replace procedure v_d_n_001_p1(v_tmp int)
is
type c_t1 is ref cursor;
type t_record2 is record
(
    c c_t1,
	d sys_refcursor
   );
begin
	dbe_output.print_line(' error ');
end v_d_n_001_p1;
/
create or replace procedure v_d_n_001_p2(v_tmp int)
is
type t_record2 is record
(
	c c_t1,
	d sys_refcursor
   );
begin
	dbe_output.print_line(' error ');
end v_d_n_001_p2;
/

drop table if exists fvt_table_returning_15;
create table fvt_table_returning_15(
		c_id int,
		c_clob clob,
		c_time date,
		c_num number(20,5),
		c_name varchar(100) default 'default',
		c_boolean boolean);

set serveroutput on;
declare
  ret1 int;
  ret2 clob;
  ret3 date;
  ret4 number(20,5);
  ret5 varchar(100);
  ret6 varchar(10);
begin
insert into fvt_table_returning_15(c_id,c_clob,c_time,c_num) values('','','','') returning
c_id+(select count(1) from dual)||c_num, c_clob||c_num,c_time,c_num,c_name,c_boolean into ret1, ret2,ret3,ret4,ret5,ret6;
dbe_output.print_line(ret1||'-'||ret2||'-'||ret3||'-'||ret4||'-'||ret5||'-'||ret6);
end;
/
drop table if exists fvt_table_returning_15;

drop table if exists FVT_T_TEST_02_01_01;
create table FVT_T_TEST_02_01_01(id int,name varchar(100), firedate date,sex int,salary number(7,2));
insert into FVT_T_TEST_02_01_01 values(null,'harry',to_date('2019-07-23','yyyy-mm-dd'),1,50000);
create or replace package P_TEST_02_01_01
as
	procedure FVT_P_TEST_02_01_01;
end;
/
create or replace package body P_TEST_02_01_01
as
procedure FVT_P_TEST_02_01_01 is
v_comm number(7,2);
begin
	execute immediate 'alter table FVT_T_TEST_02_01_01 add email varchar(50)';
for i in (select * from FVT_T_TEST_02_01_01) loop
if i.sex=1 then
	v_comm:=0.1;
else
	v_comm:=0.2;
end if;
end loop;
end;
end;
/

call P_TEST_02_01_01.FVT_P_TEST_02_01_01();
drop table if exists FVT_T_TEST_02_01_01;

drop table if exists FVT_T_TEST_02_01_02;
create table FVT_T_TEST_02_01_02(id int,name varchar(100), firedate date,sex int,salary number(7,2));
insert into FVT_T_TEST_02_01_02 values(null,'harry',to_date('2019-07-23','yyyy-mm-dd'),1,50000);
create or replace package P_TEST_02_01_02
as
	procedure FVT_P_TEST_02_01_02;
end;
/
create or replace package body P_TEST_02_01_02
as
procedure FVT_P_TEST_02_01_02 is
v_comm number(7,2);
begin
	execute immediate 'alter table FVT_T_TEST_02_01_02 drop column salary';
for i in (select * from FVT_T_TEST_02_01_02) loop
if i.sex=1 then
	v_comm:=0.1;
else
	v_comm:=0.2;
end if;
end loop;
end;
end;
/
call P_TEST_02_01_02.FVT_P_TEST_02_01_02();
drop table if exists FVT_T_TEST_02_01_02;

drop table if exists FVT_T_TEST_02_01_03;
create table FVT_T_TEST_02_01_03(id int,name varchar(100), firedate date,sex int,salary number(7,2));
insert into FVT_T_TEST_02_01_03 values(null,'harry',to_date('2019-07-23','yyyy-mm-dd'),1,50000);
create or replace package P_TEST_02_01_03
as
	procedure FVT_P_TEST_02_01_03;
end;
/
create or replace package body P_TEST_02_01_03
as
procedure FVT_P_TEST_02_01_03 is
v_comm number(7,2);
begin
	execute immediate 'alter table FVT_T_TEST_02_01_03 drop column salary';
	execute immediate 'alter table FVT_T_TEST_02_01_03 add salary varchar(100)';
	execute immediate 'insert into FVT_T_TEST_02_01_03 values(null,''harry'',to_date(''2019-07-23'',''yyyy-mm-dd''),1,''50a000'')';
for i in (select * from FVT_T_TEST_02_01_03) loop
if i.sex=1 then
	v_comm:=0.1;
else
	v_comm:=0.2;
end if;
end loop;
end;
end;
/
call P_TEST_02_01_03.FVT_P_TEST_02_01_03();
drop table if exists FVT_T_TEST_02_01_03;

declare
TYPE R1 IS RECORD(F1 INTEGER, F2 VARCHAR2(15));
var_r1 R1;
TYPE C1 IS VARRAY(4) OF R1;
var_c1 C1 :=C1(var_r1);
begin
  var_c1:= C1(var_r1);
  var_r1.F1:=3;
  var_r1.F2:='123';
  var_c1.EXTEND;
  var_c1(1) := var_r1;
  dbe_output.print_line(var_r1.F1);
  dbe_output.print_line(var_r1.F2);
  dbe_output.print_line(var_c1(1).F1);
  dbe_output.print_line(var_c1(1).F2);
  SELECT 1 INTO var_c1(1).F1 FROM DUAL;
  SELECT '456' INTO var_c1(1).F2 FROM DUAL;
  dbe_output.print_line(var_r1.F1);
  dbe_output.print_line(var_r1.F2);
  dbe_output.print_line(var_c1(1).F1);
  dbe_output.print_line(var_c1(1).F2);
end;
/
DROP TABLE IF EXISTS EMPLOYEES_UDT;
CREATE TABLE EMPLOYEES_UDT 
   (EMPLOYEE_ID NUMBER(6,0), 
	FIRST_NAME VARCHAR2(20), 
	LAST_NAME VARCHAR2(25) CONSTRAINT "EMP_LAST_NAME_NN" NOT NULL, 
	EMAIL VARCHAR2(25) CONSTRAINT "EMP_EMAIL_NN" NOT NULL, 
	PHONE_NUMBER VARCHAR2(20), 
	HIRE_DATE DATE CONSTRAINT "EMP_HIRE_DATE_NN" NOT NULL, 
	JOB_ID VARCHAR2(10) CONSTRAINT "EMP_JOB_NN" NOT NULL, 
	SALARY NUMBER(8,2), 
	COMMISSION_PCT NUMBER(2,2), 
	MANAGER_ID NUMBER(6,0), 
	DEPARTMENT_ID NUMBER(4,0)
   );
insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (198, 'Donald', 'OConnell', 'DOCONNEL', '650.507.9833', to_date('21-06-1999', 'dd-mm-yyyy'), 'SH_CLERK', 2600.00, null, 124, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (199, 'Douglas', 'Grant', 'DGRANT', '650.507.9844', to_date('13-01-2000', 'dd-mm-yyyy'), 'SH_CLERK', 2600.00, null, 124, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', to_date('17-09-1987', 'dd-mm-yyyy'), 'AD_ASST', 4400.00, null, 101, 10);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (201, 'Michael', 'Hartstein', 'MHARTSTE', '515.123.5555', to_date('17-02-1996', 'dd-mm-yyyy'), 'MK_MAN', 13000.00, null, 100, 20);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (202, 'Pat', 'Fay', 'PFAY', '603.123.6666', to_date('17-08-1997', 'dd-mm-yyyy'), 'MK_REP', 6000.00, null, 201, 20);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (203, 'Susan', 'Mavris', 'SMAVRIS', '515.123.7777', to_date('07-06-1994', 'dd-mm-yyyy'), 'HR_REP', 6500.00, null, 101, 40);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (204, 'Hermann', 'Baer', 'HBAER', '515.123.8888', to_date('07-06-1994', 'dd-mm-yyyy'), 'PR_REP', 10000.00, null, 101, 70);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (205, 'Shelley', 'Higgins', 'SHIGGINS', '515.123.8080', to_date('07-06-1994', 'dd-mm-yyyy'), 'AC_MGR', 12000.00, null, 101, 110);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (206, 'William', 'Gietz', 'WGIETZ', '515.123.8181', to_date('07-06-1994', 'dd-mm-yyyy'), 'AC_ACCOUNT', 8300.00, null, 205, 110);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (100, 'Steven', 'King', 'SKING', '515.123.4567', to_date('17-06-1987', 'dd-mm-yyyy'), 'AD_PRES', 24000.00, null, null, 90);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', to_date('21-09-1989', 'dd-mm-yyyy'), 'AD_VP', 17000.00, null, 100, 90);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', to_date('13-01-1993', 'dd-mm-yyyy'), 'AD_VP', 17000.00, null, 100, 90);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', to_date('03-01-1990', 'dd-mm-yyyy'), 'IT_PROG', 9000.00, null, 102, 60);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', to_date('21-05-1991', 'dd-mm-yyyy'), 'IT_PROG', 6000.00, null, 103, 60);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (105, 'David', 'Austin', 'DAUSTIN', '590.423.4569', to_date('25-06-1997', 'dd-mm-yyyy'), 'IT_PROG', 4800.00, null, 103, 60);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (106, 'Valli', 'Pataballa', 'VPATABAL', '590.423.4560', to_date('05-02-1998', 'dd-mm-yyyy'), 'IT_PROG', 4800.00, null, 103, 60);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', to_date('07-02-1999', 'dd-mm-yyyy'), 'IT_PROG', 4200.00, null, 103, 60);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (108, 'Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', to_date('17-08-1994', 'dd-mm-yyyy'), 'FI_MGR', 12000.00, null, 101, 100);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (109, 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', to_date('16-08-1994', 'dd-mm-yyyy'), 'FI_ACCOUNT', 9000.00, null, 108, 100);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (110, 'John', 'Chen', 'JCHEN', '515.124.4269', to_date('28-09-1997', 'dd-mm-yyyy'), 'FI_ACCOUNT', 8200.00, null, 108, 100);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (111, 'Ismael', 'Sciarra', 'ISCIARRA', '515.124.4369', to_date('30-09-1997', 'dd-mm-yyyy'), 'FI_ACCOUNT', 7700.00, null, 108, 100);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (112, 'Jose Manuel', 'Urman', 'JMURMAN', '515.124.4469', to_date('07-03-1998', 'dd-mm-yyyy'), 'FI_ACCOUNT', 7800.00, null, 108, 100);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (113, 'Luis', 'Popp', 'LPOPP', '515.124.4567', to_date('07-12-1999', 'dd-mm-yyyy'), 'FI_ACCOUNT', 6900.00, null, 108, 100);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (114, 'Den', 'Raphaely', 'DRAPHEAL', '515.127.4561', to_date('07-12-1994', 'dd-mm-yyyy'), 'PU_MAN', 11000.00, null, 100, 30);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (115, 'Alexander', 'Khoo', 'AKHOO', '515.127.4562', to_date('18-05-1995', 'dd-mm-yyyy'), 'PU_CLERK', 3100.00, null, 114, 30);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (116, 'Shelli', 'Baida', 'SBAIDA', '515.127.4563', to_date('24-12-1997', 'dd-mm-yyyy'), 'PU_CLERK', 2900.00, null, 114, 30);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (117, 'Sigal', 'Tobias', 'STOBIAS', '515.127.4564', to_date('24-07-1997', 'dd-mm-yyyy'), 'PU_CLERK', 2800.00, null, 114, 30);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (118, 'Guy', 'Himuro', 'GHIMURO', '515.127.4565', to_date('15-11-1998', 'dd-mm-yyyy'), 'PU_CLERK', 2600.00, null, 114, 30);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (119, 'Karen', 'Colmenares', 'KCOLMENA', '515.127.4566', to_date('10-08-1999', 'dd-mm-yyyy'), 'PU_CLERK', 2500.00, null, 114, 30);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (120, 'Matthew', 'Weiss', 'MWEISS', '650.123.1234', to_date('18-07-1996', 'dd-mm-yyyy'), 'ST_MAN', 8000.00, null, 100, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (121, 'Adam', 'Fripp', 'AFRIPP', '650.123.2234', to_date('10-04-1997', 'dd-mm-yyyy'), 'ST_MAN', 8200.00, null, 100, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (122, 'Payam', 'Kaufling', 'PKAUFLIN', '650.123.3234', to_date('01-05-1995', 'dd-mm-yyyy'), 'ST_MAN', 7900.00, null, 100, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (123, 'Shanta', 'Vollman', 'SVOLLMAN', '650.123.4234', to_date('10-10-1997', 'dd-mm-yyyy'), 'ST_MAN', 6500.00, null, 100, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (124, 'Kevin', 'Mourgos', 'KMOURGOS', '650.123.5234', to_date('16-11-1999', 'dd-mm-yyyy'), 'ST_MAN', 5800.00, null, 100, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (125, 'Julia', 'Nayer', 'JNAYER', '650.124.1214', to_date('16-07-1997', 'dd-mm-yyyy'), 'ST_CLERK', 3200.00, null, 120, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (126, 'Irene', 'Mikkilineni', 'IMIKKILI', '650.124.1224', to_date('28-09-1998', 'dd-mm-yyyy'), 'ST_CLERK', 2700.00, null, 120, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (127, 'James', 'Landry', 'JLANDRY', '650.124.1334', to_date('14-01-1999', 'dd-mm-yyyy'), 'ST_CLERK', 2400.00, null, 120, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (128, 'Steven', 'Markle', 'SMARKLE', '650.124.1434', to_date('08-03-2000', 'dd-mm-yyyy'), 'ST_CLERK', 2200.00, null, 120, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (129, 'Laura', 'Bissot', 'LBISSOT', '650.124.5234', to_date('20-08-1997', 'dd-mm-yyyy'), 'ST_CLERK', 3300.00, null, 121, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (130, 'Mozhe', 'Atkinson', 'MATKINSO', '650.124.6234', to_date('30-10-1997', 'dd-mm-yyyy'), 'ST_CLERK', 2800.00, null, 121, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (131, 'James', 'Marlow', 'JAMRLOW', '650.124.7234', to_date('16-02-1997', 'dd-mm-yyyy'), 'ST_CLERK', 2500.00, null, 121, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (132, 'TJ', 'Olson', 'TJOLSON', '650.124.8234', to_date('10-04-1999', 'dd-mm-yyyy'), 'ST_CLERK', 2100.00, null, 121, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (133, 'Jason', 'Mallin', 'JMALLIN', '650.127.1934', to_date('14-06-1996', 'dd-mm-yyyy'), 'ST_CLERK', 3300.00, null, 122, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (134, 'Michael', 'Rogers', 'MROGERS', '650.127.1834', to_date('26-08-1998', 'dd-mm-yyyy'), 'ST_CLERK', 2900.00, null, 122, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (135, 'Ki', 'Gee', 'KGEE', '650.127.1734', to_date('12-12-1999', 'dd-mm-yyyy'), 'ST_CLERK', 2400.00, null, 122, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (136, 'Hazel', 'Philtanker', 'HPHILTAN', '650.127.1634', to_date('06-02-2000', 'dd-mm-yyyy'), 'ST_CLERK', 2200.00, null, 122, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (137, 'Renske', 'Ladwig', 'RLADWIG', '650.121.1234', to_date('14-07-1995', 'dd-mm-yyyy'), 'ST_CLERK', 3600.00, null, 123, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (138, 'Stephen', 'Stiles', 'SSTILES', '650.121.2034', to_date('26-10-1997', 'dd-mm-yyyy'), 'ST_CLERK', 3200.00, null, 123, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (139, 'John', 'Seo', 'JSEO', '650.121.2019', to_date('12-02-1998', 'dd-mm-yyyy'), 'ST_CLERK', 2700.00, null, 123, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (140, 'Joshua', 'Patel', 'JPATEL', '650.121.1834', to_date('06-04-1998', 'dd-mm-yyyy'), 'ST_CLERK', 2500.00, null, 123, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (141, 'Trenna', 'Rajs', 'TRAJS', '650.121.8009', to_date('17-10-1995', 'dd-mm-yyyy'), 'ST_CLERK', 3500.00, null, 124, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (142, 'Curtis', 'Davies', 'CDAVIES', '650.121.2994', to_date('29-01-1997', 'dd-mm-yyyy'), 'ST_CLERK', 3100.00, null, 124, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (143, 'Randall', 'Matos', 'RMATOS', '650.121.2874', to_date('15-03-1998', 'dd-mm-yyyy'), 'ST_CLERK', 2600.00, null, 124, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (144, 'Peter', 'Vargas', 'PVARGAS', '650.121.2004', to_date('09-07-1998', 'dd-mm-yyyy'), 'ST_CLERK', 2500.00, null, 124, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (145, 'John', 'Russell', 'JRUSSEL', '011.44.1344.429268', to_date('01-10-1996', 'dd-mm-yyyy'), 'SA_MAN', 14000.00, 0.40, 100, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (146, 'Karen', 'Partners', 'KPARTNER', '011.44.1344.467268', to_date('05-01-1997', 'dd-mm-yyyy'), 'SA_MAN', 13500.00, 0.30, 100, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (147, 'Alberto', 'Errazuriz', 'AERRAZUR', '011.44.1344.429278', to_date('10-03-1997', 'dd-mm-yyyy'), 'SA_MAN', 12000.00, 0.30, 100, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (148, 'Gerald', 'Cambrault', 'GCAMBRAU', '011.44.1344.619268', to_date('15-10-1999', 'dd-mm-yyyy'), 'SA_MAN', 11000.00, 0.30, 100, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (149, 'Eleni', 'Zlotkey', 'EZLOTKEY', '011.44.1344.429018', to_date('29-01-2000', 'dd-mm-yyyy'), 'SA_MAN', 10500.00, 0.20, 100, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (150, 'Peter', 'Tucker', 'PTUCKER', '011.44.1344.129268', to_date('30-01-1997', 'dd-mm-yyyy'), 'SA_REP', 10000.00, 0.30, 145, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (151, 'David', 'Bernstein', 'DBERNSTE', '011.44.1344.345268', to_date('24-03-1997', 'dd-mm-yyyy'), 'SA_REP', 9500.00, 0.25, 145, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (152, 'Peter', 'Hall', 'PHALL', '011.44.1344.478968', to_date('20-08-1997', 'dd-mm-yyyy'), 'SA_REP', 9000.00, 0.25, 145, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (153, 'Christopher', 'Olsen', 'COLSEN', '011.44.1344.498718', to_date('30-03-1998', 'dd-mm-yyyy'), 'SA_REP', 8000.00, 0.20, 145, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (154, 'Nanette', 'Cambrault', 'NCAMBRAU', '011.44.1344.987668', to_date('09-12-1998', 'dd-mm-yyyy'), 'SA_REP', 7500.00, 0.20, 145, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (155, 'Oliver', 'Tuvault', 'OTUVAULT', '011.44.1344.486508', to_date('23-11-1999', 'dd-mm-yyyy'), 'SA_REP', 7000.00, 0.15, 145, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (156, 'Janette', 'King', 'JKING', '011.44.1345.429268', to_date('30-01-1996', 'dd-mm-yyyy'), 'SA_REP', 10000.00, 0.35, 146, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (157, 'Patrick', 'Sully', 'PSULLY', '011.44.1345.929268', to_date('04-03-1996', 'dd-mm-yyyy'), 'SA_REP', 9500.00, 0.35, 146, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (158, 'Allan', 'McEwen', 'AMCEWEN', '011.44.1345.829268', to_date('01-08-1996', 'dd-mm-yyyy'), 'SA_REP', 9000.00, 0.35, 146, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (159, 'Lindsey', 'Smith', 'LSMITH', '011.44.1345.729268', to_date('10-03-1997', 'dd-mm-yyyy'), 'SA_REP', 8000.00, 0.30, 146, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (160, 'Louise', 'Doran', 'LDORAN', '011.44.1345.629268', to_date('15-12-1997', 'dd-mm-yyyy'), 'SA_REP', 7500.00, 0.30, 146, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (161, 'Sarath', 'Sewall', 'SSEWALL', '011.44.1345.529268', to_date('03-11-1998', 'dd-mm-yyyy'), 'SA_REP', 7000.00, 0.25, 146, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (162, 'Clara', 'Vishney', 'CVISHNEY', '011.44.1346.129268', to_date('11-11-1997', 'dd-mm-yyyy'), 'SA_REP', 10500.00, 0.25, 147, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (163, 'Danielle', 'Greene', 'DGREENE', '011.44.1346.229268', to_date('19-03-1999', 'dd-mm-yyyy'), 'SA_REP', 9500.00, 0.15, 147, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (164, 'Mattea', 'Marvins', 'MMARVINS', '011.44.1346.329268', to_date('24-01-2000', 'dd-mm-yyyy'), 'SA_REP', 7200.00, 0.10, 147, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (165, 'David', 'Lee', 'DLEE', '011.44.1346.529268', to_date('23-02-2000', 'dd-mm-yyyy'), 'SA_REP', 6800.00, 0.10, 147, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (166, 'Sundar', 'Ande', 'SANDE', '011.44.1346.629268', to_date('24-03-2000', 'dd-mm-yyyy'), 'SA_REP', 6400.00, 0.10, 147, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (167, 'Amit', 'Banda', 'ABANDA', '011.44.1346.729268', to_date('21-04-2000', 'dd-mm-yyyy'), 'SA_REP', 6200.00, 0.10, 147, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (168, 'Lisa', 'Ozer', 'LOZER', '011.44.1343.929268', to_date('11-03-1997', 'dd-mm-yyyy'), 'SA_REP', 11500.00, 0.25, 148, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (169, 'Harrison', 'Bloom', 'HBLOOM', '011.44.1343.829268', to_date('23-03-1998', 'dd-mm-yyyy'), 'SA_REP', 10000.00, 0.20, 148, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (170, 'Tayler', 'Fox', 'TFOX', '011.44.1343.729268', to_date('24-01-1998', 'dd-mm-yyyy'), 'SA_REP', 9600.00, 0.20, 148, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (171, 'William', 'Smith', 'WSMITH', '011.44.1343.629268', to_date('23-02-1999', 'dd-mm-yyyy'), 'SA_REP', 7400.00, 0.15, 148, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (172, 'Elizabeth', 'Bates', 'EBATES', '011.44.1343.529268', to_date('24-03-1999', 'dd-mm-yyyy'), 'SA_REP', 7300.00, 0.15, 148, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (173, 'Sundita', 'Kumar', 'SKUMAR', '011.44.1343.329268', to_date('21-04-2000', 'dd-mm-yyyy'), 'SA_REP', 6100.00, 0.10, 148, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (174, 'Ellen', 'Abel', 'EABEL', '011.44.1644.429267', to_date('11-05-1996', 'dd-mm-yyyy'), 'SA_REP', 11000.00, 0.30, 149, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (175, 'Alyssa', 'Hutton', 'AHUTTON', '011.44.1644.429266', to_date('19-03-1997', 'dd-mm-yyyy'), 'SA_REP', 8800.00, 0.25, 149, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (176, 'Jonathon', 'Taylor', 'JTAYLOR', '011.44.1644.429265', to_date('24-03-1998', 'dd-mm-yyyy'), 'SA_REP', 8600.00, 0.20, 149, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (177, 'Jack', 'Livingston', 'JLIVINGS', '011.44.1644.429264', to_date('23-04-1998', 'dd-mm-yyyy'), 'SA_REP', 8400.00, 0.20, 149, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (178, 'Kimberely', 'Grant', 'KGRANT', '011.44.1644.429263', to_date('24-05-1999', 'dd-mm-yyyy'), 'SA_REP', 7000.00, 0.15, 149, null);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (179, 'Charles', 'Johnson', 'CJOHNSON', '011.44.1644.429262', to_date('04-01-2000', 'dd-mm-yyyy'), 'SA_REP', 6200.00, 0.10, 149, 80);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (180, 'Winston', 'Taylor', 'WTAYLOR', '650.507.9876', to_date('24-01-1998', 'dd-mm-yyyy'), 'SH_CLERK', 3200.00, null, 120, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (181, 'Jean', 'Fleaur', 'JFLEAUR', '650.507.9877', to_date('23-02-1998', 'dd-mm-yyyy'), 'SH_CLERK', 3100.00, null, 120, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (182, 'Martha', 'Sullivan', 'MSULLIVA', '650.507.9878', to_date('21-06-1999', 'dd-mm-yyyy'), 'SH_CLERK', 2500.00, null, 120, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (183, 'Girard', 'Geoni', 'GGEONI', '650.507.9879', to_date('03-02-2000', 'dd-mm-yyyy'), 'SH_CLERK', 2800.00, null, 120, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (184, 'Nandita', 'Sarchand', 'NSARCHAN', '650.509.1876', to_date('27-01-1996', 'dd-mm-yyyy'), 'SH_CLERK', 4200.00, null, 121, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (185, 'Alexis', 'Bull', 'ABULL', '650.509.2876', to_date('20-02-1997', 'dd-mm-yyyy'), 'SH_CLERK', 4100.00, null, 121, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (186, 'Julia', 'Dellinger', 'JDELLING', '650.509.3876', to_date('24-06-1998', 'dd-mm-yyyy'), 'SH_CLERK', 3400.00, null, 121, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (187, 'Anthony', 'Cabrio', 'ACABRIO', '650.509.4876', to_date('07-02-1999', 'dd-mm-yyyy'), 'SH_CLERK', 3000.00, null, 121, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (188, 'Kelly', 'Chung', 'KCHUNG', '650.505.1876', to_date('14-06-1997', 'dd-mm-yyyy'), 'SH_CLERK', 3800.00, null, 122, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (189, 'Jennifer', 'Dilly', 'JDILLY', '650.505.2876', to_date('13-08-1997', 'dd-mm-yyyy'), 'SH_CLERK', 3600.00, null, 122, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (190, 'Timothy', 'Gates', 'TGATES', '650.505.3876', to_date('11-07-1998', 'dd-mm-yyyy'), 'SH_CLERK', 2900.00, null, 122, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (191, 'Randall', 'Perkins', 'RPERKINS', '650.505.4876', to_date('19-12-1999', 'dd-mm-yyyy'), 'SH_CLERK', 2500.00, null, 122, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (192, 'Sarah', 'Bell', 'SBELL', '650.501.1876', to_date('04-02-1996', 'dd-mm-yyyy'), 'SH_CLERK', 4000.00, null, 123, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (193, 'Britney', 'Everett', 'BEVERETT', '650.501.2876', to_date('03-03-1997', 'dd-mm-yyyy'), 'SH_CLERK', 3900.00, null, 123, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (194, 'Samuel', 'McCain', 'SMCCAIN', '650.501.3876', to_date('01-07-1998', 'dd-mm-yyyy'), 'SH_CLERK', 3200.00, null, 123, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (195, 'Vance', 'Jones', 'VJONES', '650.501.4876', to_date('17-03-1999', 'dd-mm-yyyy'), 'SH_CLERK', 2800.00, null, 123, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (196, 'Alana', 'Walsh', 'AWALSH', '650.507.9811', to_date('24-04-1998', 'dd-mm-yyyy'), 'SH_CLERK', 3100.00, null, 124, 50);

insert into EMPLOYEES_UDT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (197, 'Kevin', 'Feeney', 'KFEENEY', '650.507.9822', to_date('23-05-1998', 'dd-mm-yyyy'), 'SH_CLERK', 3000.00, null, 124, 50);

DROP TABLE IF EXISTS JOBS;
CREATE TABLE JOBS
(	JOB_ID VARCHAR2(10), 
	JOB_TITLE VARCHAR2(35) CONSTRAINT "JOB_TITLE_NN" NOT NULL, 
	MIN_SALARY NUMBER(6,0), 
	MAX_SALARY NUMBER(6,0), 
	CONSTRAINT "JOB_ID_PK" PRIMARY KEY ("JOB_ID")
   );
 
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('AD_PRES', 'President', 20000, 40000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('AD_VP', 'Administration Vice President', 15000, 30000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('AD_ASST', 'Administration Assistant', 3000, 6000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('FI_MGR', 'Finance Manager', 8200, 16000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('FI_ACCOUNT', 'Accountant', 4200, 9000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('AC_MGR', 'Accounting Manager', 8200, 16000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('AC_ACCOUNT', 'Public Accountant', 4200, 9000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('SA_MAN', 'Sales Manager', 10000, 20000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('SA_REP', 'Sales Representative', 6000, 12000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('PU_MAN', 'Purchasing Manager', 8000, 15000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('PU_CLERK', 'Purchasing Clerk', 2500, 5500);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('ST_MAN', 'Stock Manager', 5500, 8500);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('ST_CLERK', 'Stock Clerk', 2000, 5000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('SH_CLERK', 'Shipping Clerk', 2500, 5500);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('IT_PROG', 'Programmer', 4000, 10000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('MK_MAN', 'Marketing Manager', 9000, 15000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('MK_REP', 'Marketing Representative', 4000, 9000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('HR_REP', 'Human Resources Representative', 4000, 9000);
insert into JOBS (job_id, job_title, min_salary, max_salary) values ('PR_REP', 'Public Relations Representative', 4500, 10500);
commit;


drop type if exists EmpRecTyp force;
create type EmpRecTyp force as object(emp_id NUMBER(6,0), salary NUMBER(8,2));
/
drop function if exists nth_highest_salary;
create FUNCTION nth_highest_salary(n INTEGER) RETURN EmpRecTyp IS
  c1 SYS_REFCURSOR;
  type rec is record(emp_id EMPLOYEES_UDT.employee_id%type, salary EMPLOYEES_UDT.salary%type);
  emp_rec rec;
  emp_obj EmpRecTyp;
 BEGIN
  OPEN c1 for SELECT employee_id, salary FROM EMPLOYEES_UDT ORDER BY salary DESC;
  FOR i IN 1 .. n LOOP
   FETCH c1 INTO emp_rec;
  END LOOP;
  CLOSE c1;
  emp_obj := EmpRecTyp(emp_rec.emp_id, emp_rec.salary);
  RETURN emp_obj;
 END nth_highest_salary;
/
DECLARE
 highest_paid_emp      EmpRecTyp;
 next_highest_paid_emp EmpRecTyp;

BEGIN
 highest_paid_emp      := nth_highest_salary(1);
 next_highest_paid_emp := nth_highest_salary(2);
 dbe_output.print_line('Highest Paid: #' || highest_paid_emp.emp_id ||
                      ', $' || highest_paid_emp.salary);
 dbe_output.print_line('Next Highest Paid: #' ||
                      next_highest_paid_emp.emp_id || ', $' ||
                      next_highest_paid_emp.salary);
END;
/

drop type  EmpRecTyp force;

DECLARE
 TYPE empcurtyp IS REF CURSOR;
 TYPE namelist IS TABLE OF VARCHAR(25);
 TYPE sallist IS TABLE OF NUMBER(8, 2);
 emp_cv empcurtyp;
 names  namelist;
 sals   sallist;
BEGIN
 OPEN emp_cv FOR
  SELECT last_name, salary
    FROM EMPLOYEES_UDT
   WHERE job_id = 'SA_REP'
   ORDER BY salary DESC, last_name;
 FETCH emp_cv BULK COLLECT
 INTO names, sals;
 CLOSE emp_cv;
 -- loop through the names and sals collections
 FOR i IN names.FIRST .. names.LAST LOOP
  dbe_output.print_line('Name = ' || names(i) || ', salary = ' || sals(i));
 END LOOP;
  OPEN emp_cv FOR
  SELECT last_name, salary
    FROM EMPLOYEES_UDT;
 FETCH emp_cv BULK COLLECT
 INTO names, sals;
 CLOSE emp_cv;
 DBE_OUTPUT.PRINT_LINE('names.count ' || names.count);
END;
/

DECLARE
  query VARCHAR2(4000) := 'SELECT first_name FROM EMPLOYEES_UDT';
   type c_1 is table of EMPLOYEES_UDT.first_name%type;
   var_c_1 c_1;
BEGIN
  EXECUTE IMMEDIATE query BULK COLLECT INTO var_c_1;
    DBE_OUTPUT.PRINT_LINE('--------' || var_c_1.COUNT);
END;
/

DECLARE
 TYPE empcurtyp IS REF CURSOR;
 TYPE namelist IS TABLE OF VARCHAR(25);
 TYPE sallist IS TABLE OF NUMBER(8, 2);
 emp_cv empcurtyp;
 names  namelist;
 sals   sallist;
BEGIN
 OPEN emp_cv FOR
  SELECT last_name, salary
    FROM EMPLOYEES_UDT
   ORDER BY salary DESC, last_name;
 FETCH emp_cv BULK COLLECT
 INTO names, sals LIMIT 33;
 CLOSE emp_cv;
 -- loop through the names and sals collections
 FOR i IN names.FIRST .. names.LAST LOOP
  dbe_output.print_line('Name = ' || names(i) || ', salary = ' || sals(i));
 END LOOP;
END;
/

DECLARE
 TYPE empcurtyp IS REF CURSOR;
 TYPE namelist IS TABLE OF VARCHAR(25);
 TYPE sallist IS TABLE OF NUMBER(8, 2);
 emp_cv empcurtyp;
 names  namelist;
 sals   sallist;
BEGIN
 OPEN emp_cv FOR
  SELECT last_name, salary
    FROM EMPLOYEES_UDT
   ORDER BY salary DESC, last_name;
 FETCH emp_cv BULK COLLECT
 INTO names, sals LIMIT sleep(2);
 CLOSE emp_cv;
END;
/

BEGIN
 FOR item IN (SELECT last_name, job_id
                FROM EMPLOYEES_UDT
               WHERE job_id LIKE '%CLERK%'
                 AND manager_id > 120
               ORDER BY last_name) LOOP
  dbe_output.print_line('Name = ' || item.last_name || ', Job = ' ||
                       item.job_id);
 END LOOP;
END;
/

DECLARE CURSOR c1 IS
 SELECT last_name, job_id
   FROM EMPLOYEES_UDT
  WHERE job_id LIKE '%CLERK%'
    AND manager_id > 120
  ORDER BY last_name;
BEGIN
 FOR item IN c1 LOOP
  dbe_output.print_line('Name = ' || item.last_name || ', Job = ' ||
                       item.job_id);
 END LOOP;
END;
/

DECLARE
 CURSOR c1 IS
  SELECT last_name, job_id
    FROM EMPLOYEES_UDT
   WHERE REGEXP_LIKE(job_id, 'S[HT]_CLERK')
   ORDER BY last_name;
 v_lastname EMPLOYEES_UDT.last_name%TYPE; -- variable for last_name
 v_jobid    EMPLOYEES_UDT.job_id%TYPE; -- variable for job_id
 CURSOR c2 IS
  SELECT *
    FROM EMPLOYEES_UDT
   WHERE REGEXP_LIKE(job_id, '[ACADFIMKSA]_M[ANGR]')
   ORDER BY job_id;
 v_EMPLOYEES_UDT EMPLOYEES_UDT%ROWTYPE; -- record variable for row of table
BEGIN
 OPEN c1;
 LOOP
  -- Fetches 2 columns into variables
  FETCH c1
  INTO v_lastname, v_jobid;
  EXIT WHEN c1%NOTFOUND;
  dbe_output.print_line(RPAD(v_lastname, 25, ' ') || v_jobid);
 END LOOP;
 CLOSE c1;
 dbe_output.print_line('-------------------------------------');
 OPEN c2;
 LOOP
  -- Fetches entire row into the v_EMPLOYEES_UDT record
  FETCH c2
  INTO v_EMPLOYEES_UDT;
  EXIT WHEN c2%NOTFOUND;
  dbe_output.print_line(RPAD(v_EMPLOYEES_UDT.last_name, 25, ' ') ||
                       v_EMPLOYEES_UDT.job_id);
 END LOOP;
 CLOSE c2;
END;
/

DECLARE
 CURSOR c IS
  SELECT e.job_id, j.job_title
    FROM EMPLOYEES_UDT e, jobs j
   WHERE e.job_id = j.job_id
     AND e.manager_id = 100
   ORDER BY last_name;
 -- Record variables for rows of cursor result set:
 job1 c%ROWTYPE;
 job2 c%ROWTYPE;
 job3 c%ROWTYPE;
 job4 c%ROWTYPE;
 job5 c%ROWTYPE;
BEGIN
 OPEN c;
 FETCH c
 INTO job1; -- fetches first row
 FETCH c
 INTO job2; -- fetches second row
 FETCH c
 INTO job3; -- fetches third row
 FETCH c
 INTO job4; -- fetches fourth row
 FETCH c
 INTO job5; -- fetches fifth row
 CLOSE c;
 dbe_output.print_line(job1.job_title || ' (' || job1.job_id || ')');
 dbe_output.print_line(job2.job_title || ' (' || job2.job_id || ')');
 dbe_output.print_line(job3.job_title || ' (' || job3.job_id || ')');
 dbe_output.print_line(job4.job_title || ' (' || job4.job_id || ')');
 dbe_output.print_line(job5.job_title || ' (' || job5.job_id || ')');
END;
/

DECLARE
 TYPE EmpCurTyp IS REF CURSOR;
 v_emp_cursor EmpCurTyp;
 emp_record   EMPLOYEES_UDT%ROWTYPE;
 v_stmt_str   VARCHAR2(200);
BEGIN
 -- Dynamic SQL statement with placeholder:
 v_stmt_str := 'SELECT * FROM EMPLOYEES_UDT  where job_id = :j ';
 -- Open cursor & specify bind variable in USING clause:
 OPEN v_emp_cursor FOR v_stmt_str USING 'PU_CLERK';
 -- Fetch rows from result set one at a time:
 LOOP
  FETCH v_emp_cursor
  INTO emp_record;
  EXIT WHEN v_emp_cursor%NOTFOUND;
 
  dbe_output.print_line('emp_record.EMPLOYEE_ID ' || emp_record.EMPLOYEE_ID);
  dbe_output.print_line('emp_record.FIRST_NAME ' || emp_record.FIRST_NAME);
  dbe_output.print_line('emp_record.LAST_NAME ' || emp_record.LAST_NAME);
  dbe_output.print_line('emp_record.EMAIL ' || emp_record.EMAIL);
  dbe_output.print_line('emp_record.PHONE_NUMBER ' ||
                       emp_record.PHONE_NUMBER);
  dbe_output.print_line('emp_record.HIRE_DATE ' || emp_record.HIRE_DATE);
  dbe_output.print_line('emp_record.JOB_ID ' || emp_record.JOB_ID);
  dbe_output.print_line('emp_record.SALARY ' || emp_record.SALARY);
  dbe_output.print_line('emp_record.COMMISSION_PCT ' ||
                       emp_record.COMMISSION_PCT);
  dbe_output.print_line('emp_record.MANAGER_ID ' || emp_record.MANAGER_ID);
  dbe_output.print_line('emp_record.DEPARTMENT_ID ' ||
                       emp_record.DEPARTMENT_ID);
  dbe_output.print_line('--------------------------------------');
 END LOOP;
 -- Close cursor:
 CLOSE v_emp_cursor;
END;
/

create or replace type c1_obj FORCE AS OBJECT(last_name VARCHAR2(25), salary NUMBER(8,2));
/

DECLARE
 CURSOR c1 IS
  SELECT last_name, salary
    FROM EMPLOYEES_UDT
   WHERE salary > 10000 and rownum <= 3
   ORDER BY last_name;
 c1_rec c1_obj;
 
BEGIN
 dbe_output.print_line('--- Processing all results simultaneously ---');

 OPEN c1;
 LOOP
  FETCH c1 into c1_rec;
  EXIT WHEN c1%NOTFOUND;
 END LOOP;
 CLOSE c1;
END;
/
drop TYPE c1_obj force;

drop TYPE if exists NameList force;
create type NameList IS TABLE OF VARCHAR(25);
/
drop TYPE if exists SalList force;
create type SalList IS TABLE OF NUMBER(8, 2);
/

drop PROCEDURE if exists print_results;
create PROCEDURE print_results(names NameList, sals SalList) IS
 BEGIN
  -- Check if collections are empty:
  IF names IS NULL OR names.COUNT = 0 THEN
   dbe_output.print_line('No results!');
  ELSE
   dbe_output.print_line('Result: ');
   FOR i IN names.FIRST .. names.LAST LOOP
    dbe_output.print_line(' Employee ' || names(i) || ': $' || sals(i));
   END LOOP;
  END IF;
 END;
/

DECLARE
 CURSOR c1 IS
  SELECT last_name, salary
    FROM EMPLOYEES_UDT
   WHERE salary > 10000
   ORDER BY last_name;
 names NameList;
 sals  SalList;
 type c1_rec is record (last_name EMPLOYEES_UDT.last_name%type, salary EMPLOYEES_UDT.salary%type);
 TYPE RecList IS TABLE OF c1_rec;
 recs RecList;
 v_limit INTEGER := 10;
 
BEGIN
 dbe_output.print_line('--- Processing all results simultaneously ---');
 OPEN c1;
 FETCH c1 BULK COLLECT
 INTO names, sals;
 CLOSE c1;
 print_results(names, sals);
 dbe_output.print_line('--- Processing ' || v_limit ||
                      ' rows at a time ---');
 OPEN c1;
 LOOP
  FETCH c1 BULK COLLECT
  INTO names, sals LIMIT v_limit;
  EXIT WHEN names.COUNT = 0;
   print_results(names, sals);
 END LOOP;
 CLOSE c1;
 dbe_output.print_line('--- Fetching records rather than columns ---');
 OPEN c1;
 FETCH c1 BULK COLLECT
 INTO recs;
 FOR i IN recs.FIRST .. recs.LAST LOOP
  -- Now all columns from result set come from one record
  dbe_output.print_line(' Employee ' || recs(i).last_name || ': $' || recs(i)
                       .salary);
 END LOOP;
END;
/
drop PROCEDURE print_results;
drop TYPE SalList force;
drop TYPE NameList force;

DECLARE
 CURSOR c1 IS
  SELECT first_name, last_name, hire_date FROM EMPLOYEES_UDT order by hire_date;
 TYPE NameSet IS TABLE OF c1%ROWTYPE;
 stock_managers NameSet; -- nested table of records
 TYPE cursor_var_type is REF CURSOR;
 cv cursor_var_type;
BEGIN
 -- Assign values to nested table of records:
 OPEN cv FOR
  SELECT first_name, last_name, hire_date
    FROM EMPLOYEES_UDT
   WHERE job_id = 'ST_MAN'
   ORDER BY hire_date;
 FETCH cv BULK COLLECT
 INTO stock_managers;
 CLOSE cv;
 -- Print nested table of records:
 FOR i IN stock_managers.FIRST .. stock_managers.LAST LOOP
  dbe_output.print_line(stock_managers(i)
                       .hire_date || ' ' || stock_managers(i).last_name || ', ' || stock_managers(i)
                       .first_name);
 END LOOP;
END;
/

DECLARE
 TYPE numtab IS TABLE OF NUMBER;
 CURSOR c1 IS
  SELECT employee_id
    FROM EMPLOYEES_UDT
   WHERE department_id = 80
   ORDER BY employee_id;
 empids numtab;
BEGIN
 OPEN c1;
 LOOP
  -- Fetch 10 rows or fewer in each iteration
  FETCH c1 BULK COLLECT
  INTO empids LIMIT 33;
  dbe_output.print_line('------- Results from One Bulk Fetch --------');
  FOR i IN 1 .. empids.COUNT LOOP
   dbe_output.print_line('Employee Id: ' || empids(i));
  END LOOP;
  EXIT WHEN c1%NOTFOUND;
 END LOOP;
 CLOSE c1;
END;
/
   
DECLARE
  x varchar(100) := 'SH_CLERK';
  y integer;
  query VARCHAR2(4000) := 'SELECT first_name, last_name, hire_date
    FROM EMPLOYEES_UDT
   WHERE job_id = :x and rownum <= :y
   ORDER BY hire_date';
  var_s1 EMPLOYEES_UDT.first_name%type;
  var_s2 EMPLOYEES_UDT.last_name%type;
  var_s3 EMPLOYEES_UDT.hire_date%type;
  cursor cv IS
  SELECT first_name, last_name, hire_date
    FROM EMPLOYEES_UDT
   WHERE job_id = 'ST_MAN'
   ORDER BY hire_date;
   var_rec cv%rowtype;
   TYPE c_r IS TABLE OF cv%rowtype;
   var_c_r c_r;
   type c_1 is table of EMPLOYEES_UDT.first_name%type;
   type c_2 is table of EMPLOYEES_UDT.last_name%type;
   type c_3 is table of EMPLOYEES_UDT.hire_date%type;
   var_c_1 c_1;
   var_c_2 c_2;
   var_c_3 c_3;
   
BEGIN
  EXECUTE IMMEDIATE query INTO var_s1, var_s2, var_s3 USING x, 1;
  dbe_output.print_line('------------------------------------');
  dbe_output.print_line('Employee first_name = ' || var_s1 || ' last_name = ' || var_s2 || ' hire_date =' || var_s3);
  EXECUTE IMMEDIATE query INTO var_rec USING x, 1;
  dbe_output.print_line('Employee first_name = ' || var_rec.first_name || ' last_name = ' || var_rec.last_name || ' hire_date =' || var_rec.hire_date);
  dbe_output.print_line('------------------------------------');
  EXECUTE IMMEDIATE query BULK COLLECT INTO var_c_r USING x, 10;
  FOR i IN 1 .. var_c_r.COUNT LOOP
   dbe_output.print_line('Employee first_name: ' || var_c_r(i).first_name || 'Employee last_name: '|| var_c_r(i).first_name|| 'Employee hire_date: '|| var_c_r(i).first_name);
  END LOOP;
  dbe_output.print_line('------------------------------------');

  EXECUTE IMMEDIATE query BULK COLLECT INTO var_c_1, var_c_2, var_c_3 USING x, 100000000;
  FOR i IN 1 .. var_c_1.COUNT LOOP
   dbe_output.print_line('Employee first_name: ' || var_c_1(i) || 'Employee last_name: '|| var_c_2(i)|| 'Employee hire_date: '|| var_c_3(i));
  END LOOP;
END;
/

DECLARE
 x      varchar(100) := 'SH_CLERK';
 var_s1 EMPLOYEES_UDT.first_name%type;
 var_s2 EMPLOYEES_UDT.last_name%type;
 var_s3 EMPLOYEES_UDT.hire_date%type;
 cursor cv IS
  SELECT first_name, last_name, hire_date
    FROM EMPLOYEES_UDT
   WHERE job_id = 'ST_MAN'
   ORDER BY hire_date;
 var_rec cv%rowtype;
 TYPE c_r IS TABLE OF cv%rowtype;
 var_c_r c_r;
 type c_1 is table of EMPLOYEES_UDT.first_name%type;
 type c_2 is table of EMPLOYEES_UDT.last_name%type;
 type c_3 is table of EMPLOYEES_UDT.hire_date%type;
 var_c_1 c_1;
 var_c_2 c_2;
 var_c_3 c_3;

BEGIN
 SELECT first_name, last_name, hire_date
   INTO var_s1, var_s2, var_s3
   FROM EMPLOYEES_UDT
  WHERE job_id = x
    and rownum = 1
  ORDER BY hire_date;

 dbe_output.print_line('------------------------------------');
 dbe_output.print_line('Employee first_name = ' || var_s1 ||
                      ' last_name = ' || var_s2 || ' hire_date =' ||
                      var_s3);
 SELECT first_name, last_name, hire_date
   INTO var_rec
   FROM EMPLOYEES_UDT
  WHERE job_id = x
    and rownum = 1
  ORDER BY hire_date;
 dbe_output.print_line('Employee first_name = ' || var_rec.first_name ||
                      ' last_name = ' || var_rec.last_name ||
                      ' hire_date =' || var_rec.hire_date);

 dbe_output.print_line('------------------------------------');

 SELECT first_name, last_name, hire_date BULK COLLECT INTO var_c_r
   FROM EMPLOYEES_UDT
  WHERE job_id = x
  ORDER BY hire_date;
 FOR i IN 1 .. var_c_r.COUNT LOOP
  dbe_output.print_line('Employee first_name: ' || var_c_r(i).first_name ||
                       'Employee last_name: ' || var_c_r(i).first_name ||
                       'Employee hire_date: ' || var_c_r(i).first_name);
 END LOOP;
 dbe_output.print_line('------------------------------------');

 SELECT first_name,
        last_name,
        hire_date BULK COLLECT INTO var_c_1,
        var_c_2,
        var_c_3
   FROM EMPLOYEES_UDT
  WHERE job_id = x
  ORDER BY hire_date;
 FOR i IN 1 .. var_c_1.COUNT LOOP
  dbe_output.print_line('Employee first_name: ' || var_c_1(i) ||
                       'Employee last_name: ' || var_c_2(i) ||
                       'Employee hire_date: ' || var_c_3(i));
 END LOOP;
END;
/
DROP TABLE EMPLOYEES_UDT PURGE;
DROP TABLE JOBS PURGE;

--returning...bulk collect into
DROP TABLE if exists test_returning_bulkinto;
create table test_returning_bulkinto (a VARCHAR2(10), b VARCHAR2(10), c VARCHAR2(10));
insert into test_returning_bulkinto values ('a','a','a');
insert into test_returning_bulkinto values ('a','a','a');
insert into test_returning_bulkinto values ('a','b','a');
insert into test_returning_bulkinto values ('a','b','a');
DECLARE 
   TYPE emp_rec_type IS RECORD
   (  
     ra      test_returning_bulkinto.a%TYPE,  
     rb      test_returning_bulkinto.b%TYPE,  
     rc   test_returning_bulkinto.c%TYPE  
   );  
   TYPE nested_emp_type1 IS TABLE OF emp_rec_type;
   emp_tab   nested_emp_type1; 
begin
  update test_returning_bulkinto set a='b' where a='a' returning a,b,c bulk collect into emp_tab;
  dbe_output.print_line('emp_tab');
  for i in 1..emp_tab.count loop
  dbe_output.print_line(emp_tab(i).ra||' '||emp_tab(i).rb||' '||emp_tab(i).rc);
  end loop;
end;
/
DECLARE 
   TYPE emp_rec_type IS RECORD
   (  
     ra      test_returning_bulkinto.a%TYPE,  
     rb      test_returning_bulkinto.b%TYPE,  
     rc      test_returning_bulkinto.c%TYPE  
   );
   TYPE nested_emp_type IS TABLE OF emp_rec_type;
   emp_tab   nested_emp_type; 
begin
  insert into test_returning_bulkinto (a, b ,c)
  values ('aa', 'bb','cc')
  returning a,b,c bulk collect into emp_tab;
  dbe_output.print_line('emp_tab');
  for i in 1..emp_tab.count loop
  dbe_output.print_line(emp_tab(i).ra||' '||emp_tab(i).rb||' '||emp_tab(i).rc);
  end loop;
end;
/
DECLARE 
   TYPE emp_rec_type IS RECORD
   (  
     ra      test_returning_bulkinto.a%TYPE,  
     rb      test_returning_bulkinto.b%TYPE,  
     rc      test_returning_bulkinto.c%TYPE  
   );
   TYPE nested_emp_type IS TABLE OF emp_rec_type;
   emp_tab   nested_emp_type; 
begin
  delete from test_returning_bulkinto where b='b'
  returning a,b,c bulk collect into emp_tab;
  dbe_output.print_line('emp_tab');
  for i in 1..emp_tab.count loop
  dbe_output.print_line(emp_tab(i).ra||' '||emp_tab(i).rb||' '||emp_tab(i).rc);
  end loop;
end;
/
DECLARE
   TYPE emp_rec_type IS RECORD
   (
     ra      test_returning_bulkinto.a%TYPE,
     rb      test_returning_bulkinto.b%TYPE,
     rc   test_returning_bulkinto.c%TYPE
   );
   TYPE nested_emp_type1 IS TABLE OF emp_rec_type;
   emp_tab   nested_emp_type1;
   CURSOR c1 IS SELECT a, b,c FROM test_returning_bulkinto;
begin
  open c1;
  fetch c1 bulk collect into emp_tab;
  close c1;
  dbe_output.print_line('emp_tab');
  for i in 1..emp_tab.count loop
  dbe_output.print_line(emp_tab(i).ra||' '||emp_tab(i).rb||' '||emp_tab(i).rc);
  end loop;
end;
/
DECLARE 
   TYPE nested_emp_type1 IS TABLE OF VARCHAR2(10);
   emp_tab1   nested_emp_type1; 
   emp_tab2   nested_emp_type1; 
   TYPE nested_emp_type2 IS varray(10) OF VARCHAR2(10);
   emp_tab3   nested_emp_type2; 
begin
  update test_returning_bulkinto set a='a' where a='b' returning a,b,c bulk collect into emp_tab1,emp_tab2,emp_tab3;
  for i in 1..emp_tab1.count loop
  dbe_output.print_line(emp_tab1(i)||' '||emp_tab2(i)||' '||emp_tab3(i));
  end loop;
end;
/
DROP TABLE if exists test_returning_bulkinto;
create table test_returning_bulkinto (f1 int, f2 int, f3 int);
insert into test_returning_bulkinto values (1,1,1);
insert into test_returning_bulkinto values (1,1,2);
insert into test_returning_bulkinto values (1,1,2);
DECLARE 
   TYPE emp_rec_type IS RECORD
   (  
     ra      test_returning_bulkinto.f1%TYPE,  
     rb      test_returning_bulkinto.f2%TYPE,  
     rc      test_returning_bulkinto.f3%TYPE  
   );  
   TYPE nested_emp_type1 IS TABLE OF emp_rec_type;
   emp_tab   nested_emp_type1; 
begin
  update test_returning_bulkinto set f1=2 where f1=1 returning f1+1,f2*f2,null bulk collect into emp_tab;
  dbe_output.print_line('count:' || emp_tab.count);
  dbe_output.print_line('emp_tab:  ' );
  FOR i IN emp_tab.FIRST .. emp_tab.LAST  
   LOOP  
      dbe_output.print_line(emp_tab(i).ra||'  '||emp_tab(i).rb||'  '||emp_tab(i).rc);
   END LOOP;  
end;
/
DECLARE 
  sa int;
  sb int;
  sc int;
begin
  update test_returning_bulkinto set f1=1 where f2=1 returning f1,f2,f3 into sa, sb, sc;
  dbe_output.print_line(sa||'  '||sb||'  '||sc);
end;
/
delete from test_returning_bulkinto where f3=2;
DECLARE 
  sa int;
  sb int;
  sc int;
begin
  update test_returning_bulkinto set f1=1 where f2=1 returning f1,f2,f3 into sa, sb, sc;
  dbe_output.print_line(sa||'  '||sb||'  '||sc);
end;
/
DECLARE 
  sa int;
  sb int;
  sc int;
begin
  insert into test_returning_bulkinto(f1,f2,f3) values (1,1,2) returning f1,f2,f3 into sa, sb, sc;
  dbe_output.print_line(sa||'  '||sb||'  '||sc);
end;
/
DECLARE 
  sa int;
  sb int;
  sc int;
begin
  delete from test_returning_bulkinto where f3=2 returning f1,f2,f3 into sa, sb, sc;
  dbe_output.print_line(sa||'  '||sb||'  '||sc);
end;
/
DECLARE 
   TYPE emp_rec_type IS RECORD
   (  
     ra      int,  
     rb      int,  
     rc      int   
   );  
   emp_tab   emp_rec_type; 
begin
  insert into test_returning_bulkinto(f1,f2,f3) values (1,1,2) returning f1,f2,f3 into emp_tab;
  dbe_output.print_line(emp_tab.ra||'  '||emp_tab.rb||'  '||emp_tab.rc);
end;
/
DROP TABLE test_returning_bulkinto;

--DTS2019111307418
drop table if exists fvt_0011;
create table fvt_0011(a int,b int,c int);
insert into fvt_0011 values(1,2,3);
drop table if exists fvt_11;
create table fvt_11(a int,b int);
insert into fvt_11 values(1,2);
declare
red11 fvt_11%rowtype;
red0011 fvt_0011%rowtype;
begin
for i in (select * from fvt_11) loop
red11 := i;
red0011 := red11;
dbe_output.print_line(red0011.a);
end loop;
end;
/
drop table fvt_0011;
drop table fvt_11;

--DTS2019111414436
drop type if exists nt_type force;
create or replace type nt_type is varray(7) of varchar(10);
/
declare
    nt nt_type := nt_type('a','s','null','w','e');
BEGIN
    nt.trim(null);
    dbe_output.print_line(nt.count);
end;
/
declare
    nt nt_type := nt_type('a','s','null','w','e');
BEGIN
    nt.extend(1, null);
    dbe_output.print_line(nt.count);
end;
/
drop type nt_type force;
declare
    TYPE nt_type IS TABLE OF varchar(10);
    nt nt_type := nt_type('a','s','null','w','e');
BEGIN
    nt.delete(null, 2);
    dbe_output.print_line(nt.count) ;
end;
/

drop table if exists t_objects;
create table t_objects as select * from user_objects; 

declare
type nt_object is table of t_objects%rowtype;
vnt_object_bulk nt_object;
begin
select * bulk collect into vnt_object_bulk from t_objects;
end;
/


declare
  type nt_object is table of t_objects%rowtype;
  vnt_object_bulk nt_object;
  vnt_object      nt_object := nt_object();
  c_big_number    number := power(2, 31);
  l_start_time    number;
  cursor cur_object is
    select * from t_objects;
begin
  dbe_output.print_line('========BULK COLLECT LIMIT==========');
  l_start_time := dbe_util.get_date_time;
  open cur_object;
  loop
    fetch cur_object bulk collect
      into vnt_object_bulk limit 100;
    exit when cur_object%notfound;
    for i in vnt_object_bulk.first .. vnt_object_bulk.last loop
      vnt_object.extend;
      vnt_object(vnt_object.last) := vnt_object_bulk(i);
    end loop;
  end loop;
  close cur_object;
end;
/
drop table t_objects;

drop table if exists SHORT_TABLE;
CREATE  TABLE SHORT_TABLE(F1 INT,F2 INT);
create OR REPLACE procedure my_proc_5 
is
x int;
begin
FOR R IN 1..97 LOOP
INSERT INTO SHORT_TABLE VALUES(R,R+1);
END LOOP;
END;
/
call my_proc_5;
creATE OR REPLACE TYPE SHORT_OBJ IS OBJECT(F1 INT, f2 int);
/
creATE OR REPLACE TYPE SHORT_ARR IS TABLE OF SHORT_OBJ;
/
create or replace procedure my_proc_6 is
  xxx SHORT_ARR ;
    l_my_table_tab SHORT_ARR ;
    n integer := 0;
  begin
    l_my_table_tab := SHORT_ARR();
	for r in (select f1,f2 from SHORT_TABLE)
    loop
		l_my_table_tab.extend;
		n := n + 1;
		l_my_table_tab(n) := SHORT_OBJ(r.f1, r.f2);
	end loop;
	xxx :=l_my_table_tab;
	dbe_output.print_line(xxx(97).f1);
  end;
  /
call my_proc_6;
drop TABLE SHORT_TABLE;
drop TYPE SHORT_OBJ force;
drop TYPE SHORT_ARR force;
drop procedure my_proc_6;
drop procedure my_proc_5;

--DTS2020011001606
create or replace type array_number is table of number(20);
/
drop table if exists t_user;
create table t_user(userid number,phone varchar2(11));
declare 
  numarr_result array_number := array_number(1,1,1);
  v_count number;
begin
  delete from t_user where userid = 1 
   returning userid bulk collect into  numarr_result;   
  dbe_output.print_line('numarr_result count:' ||numarr_result.count);
end;
/
drop table t_user;

create table t_user(userid number,phone varchar2(11));
insert into t_user values(1,'2');
declare 
  v_count number;
begin
   delete from t_user returning userid into v_count; 
   dbe_output.print_line(v_count);
end;
/
drop table t_user;


--Uninitialized object--write error
CREATE OR REPLACE TYPE sdc Force as object(name varchar2(36));
/

declare
s sdc;
begin
s.name :=1;
DBE_output.print_line(s.name || 1);
end;
/
---------read success
declare
s sdc;
begin
DBE_output.print_line(s.name || 1);
end;
/
drop TYPE sdc;

drop table if exists fvt_01;
create table fvt_01 (a varchar2(15),b int,c varchar2(15));
insert into fvt_01 values(' ',null,lpad('12',10,'ha'));
insert into fvt_01 values('null',123,lpad('12',10,'ha'));
insert into fvt_01 values(lpad('12',10,'ha'),'',lpad('12',10,'ha'));

set serveroutput on;
create or replace type varray2 is VARRAY(3) OF varchar2(15);
/
create or replace type varray02 is varray(3) of int;
/
declare
var2 varray2;
cursor cur_02 is select b from fvt_01;
var02 varray02;
begin
select a bulk collect into var2  from fvt_01;
for i in 1..var2.count loop
        dbe_output.print_line(var2(i));
        end loop;

        begin
        open cur_02;
        fetch cur_02 bulk collect into var02;
        for i in var02.first..var02.last loop
                dbe_output.print_line(var02(i));
        end loop;
        close cur_02;
        end;
end;
/

set serveroutput off;
--DTS202104280ID10ZP1M00
CONN / AS SYSDBA
SET SERVEROUTPUT ON
CREATE OR REPLACE TYPE TYPE_DTS202104280ID10ZP1M00 FORCE AS OBJECT(id int,name varchar(10));
/
CREATE OR REPLACE SYNONYM TYPE_DTS202104280ID10ZP1M00_LOCAL FOR TYPE_DTS202104280ID10ZP1M00;
CREATE OR REPLACE PUBLIC SYNONYM TYPE_DTS202104280ID10ZP1M00_PUBLIC FOR TYPE_DTS202104280ID10ZP1M00;
DECLARE
 x TYPE_DTS202104280ID10ZP1M00;
 y TYPE_DTS202104280ID10ZP1M00_LOCAL;
 z TYPE_DTS202104280ID10ZP1M00_PUBLIC;
BEGIN
 x := TYPE_DTS202104280ID10ZP1M00(1, 'xxx');
 y := TYPE_DTS202104280ID10ZP1M00_LOCAL(2, 'yyy');
 z := TYPE_DTS202104280ID10ZP1M00_PUBLIC(3, 'zzz');
 DBE_OUTPUT.PRINT_LINE('x:'||x.id||x.name);
 DBE_OUTPUT.PRINT_LINE('y:'||y.id||y.name);
 DBE_OUTPUT.PRINT_LINE('z:'||z.id||z.name);
END;
/
DROP TYPE TYPE_DTS202104280ID10ZP1M00;
DROP SYNONYM TYPE_DTS202104280ID10ZP1M00_LOCAL;
DROP PUBLIC SYNONYM TYPE_DTS202104280ID10ZP1M00_PUBLIC;
set serveroutput off;

--DTS202104290PCME4P1H00
SET SERVEROUTPUT ON
DROP TABLE IF EXISTS DTS202104290PCME4P1H00_T1;
CREATE TABLE DTS202104290PCME4P1H00_T1(C1 INT);
DECLARE
  CURSOR CURSOR1 IS SELECT 20210429 FROM SYS_DUMMY;
  TYPE1 DTS202104290PCME4P1H00_T1%ROWTYPE;
BEGIN
  OPEN CURSOR1;
  LOOP
    FETCH CURSOR1 INTO TYPE1;
    EXIT WHEN CURSOR1%NOTFOUND;
    DBE_OUTPUT.PRINT_LINE(TYPE1.C1);
    END LOOP;
  CLOSE CURSOR1;
END;
/
DROP TABLE IF EXISTS DTS202104290PCME4P1H00_T1;
CREATE TABLE DTS202104290PCME4P1H00_T1(C1 INT,C2 INT);
DECLARE
  CURSOR CURSOR1 IS SELECT 20210429 FROM SYS_DUMMY;
  TYPE1 DTS202104290PCME4P1H00_T1%ROWTYPE;
BEGIN
  OPEN CURSOR1;
  LOOP
    FETCH CURSOR1 INTO TYPE1;
    EXIT WHEN CURSOR1%NOTFOUND;
    DBE_OUTPUT.PRINT_LINE(TYPE1.C1);
  END LOOP;
  CLOSE CURSOR1;
END;
/

DROP TABLE IF EXISTS DTS202104290PCME4P1H00_T2;
CREATE TABLE DTS202104290PCME4P1H00_T2(C1 INT);
DECLARE
  CURSOR CURSOR1 IS SELECT 20210429 FROM SYS_DUMMY;
  TYPE1 DTS202104290PCME4P1H00_T2%ROWTYPE;
  TYPE2 DTS202104290PCME4P1H00_T2.C1%TYPE;
BEGIN
  OPEN CURSOR1;
  LOOP
    FETCH CURSOR1 INTO TYPE1;
    EXIT WHEN CURSOR1%NOTFOUND;
    DBE_OUTPUT.PRINT_LINE(TYPE1.C1);
    TYPE2 := TYPE1.C1;
    DBE_OUTPUT.PRINT_LINE(TYPE2);
  END LOOP;
  CLOSE CURSOR1;
END;
/
DROP TABLE IF EXISTS DTS202104290PCME4P1H00_T2;
CREATE TABLE DTS202104290PCME4P1H00_T2(C1 INT,C2 INT);
DECLARE
  CURSOR CURSOR1 IS SELECT 20210429 FROM SYS_DUMMY;
  TYPE1 DTS202104290PCME4P1H00_T2%ROWTYPE;
  TYPE2 DTS202104290PCME4P1H00_T2.C1%TYPE;
BEGIN
  OPEN CURSOR1;
  LOOP
    FETCH CURSOR1 INTO TYPE1;
    EXIT WHEN CURSOR1%NOTFOUND;
    DBE_OUTPUT.PRINT_LINE(TYPE1.C1);
    TYPE2 := TYPE1.C1;
    DBE_OUTPUT.PRINT_LINE(TYPE2);
  END LOOP;
  CLOSE CURSOR1;
END;
/
DROP TABLE IF EXISTS DTS202104290PCME4P1H00_T1;
DROP TABLE IF EXISTS DTS202104290PCME4P1H00_T2;
SET SERVEROUTPUT OFF

--DTS202105220EVH0FP0D00 START plsql objects cannot rely on temporary tables
CONN / AS SYSDBA
ALTER SYSTEM SET LOCAL_TEMPORARY_TABLE_ENABLED = TRUE;
DROP TABLE IF EXISTS #DTS202105220EVH0FP0D00_T1;
CREATE TEMPORARY TABLE #DTS202105220EVH0FP0D00_T1(c1 int);
DECLARE
  TYPE1 #DTS202105220EVH0FP0D00_T1%ROWTYPE;
  TYPE2 #DTS202105220EVH0FP0D00_T1.C1%TYPE;
BEGIN
 NULL;
END;
/
CONN / AS SYSDBA
SELECT SQL_TEXT FROM DV_ANONYMOUS WHERE SQL_TEXT LIKE '%DTS202105220EVH0FP0D00%' ORDER BY SQL_TEXT;
DROP TABLE IF EXISTS #DTS202105220EVH0FP0D00_T1;
DROP TABLE IF EXISTS DTS202105220EVH0FP0D00_T1;
CREATE TEMPORARY TABLE #DTS202105220EVH0FP0D00_T1(c1 int);
CREATE TABLE DTS202105220EVH0FP0D00_T1(c1 int);
CREATE OR REPLACE PROCEDURE DTS202105220EVH0FP0D00_PROC1(V1 INT) IS
  TYPE1 #DTS202105220EVH0FP0D00_T1%ROWTYPE;
  TYPE2 #DTS202105220EVH0FP0D00_T1.C1%TYPE;
  TYPE3 DTS202105220EVH0FP0D00_T1%ROWTYPE;
BEGIN
  NULL;
END;
/
SELECT NAME, REFERENCED_NAME FROM MY_DEPENDENCIES WHERE NAME='DTS202105220EVH0FP0D00_PROC1';
CALL DTS202105220EVH0FP0D00_PROC1(1);
SELECT SQL_TEXT FROM DV_ANONYMOUS WHERE SQL_TEXT LIKE '%DTS202105220EVH0FP0D00%' ORDER BY SQL_TEXT;
CONN / AS SYSDBA
DROP TABLE IF EXISTS #DTS202105220EVH0FP0D00_T1;
DROP TABLE IF EXISTS DTS202105220EVH0FP0D00_T1;
DROP PROCEDURE IF EXISTS DTS202105220EVH0FP0D00_PROC1;
--DTS202105220EVH0FP0D00 END