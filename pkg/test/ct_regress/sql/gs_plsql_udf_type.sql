conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_plsql_udf_type cascade;
create user gs_plsql_udf_type identified by Lh00420062;
grant dba to gs_plsql_udf_type;

conn gs_plsql_udf_type/Lh00420062@127.0.0.1:1611
set serveroutput on;
--common test
DECLARE
  TYPE array IS VARRAY(10) OF Integer;
  TYPE asso_array IS TABLE OF Integer INDEX BY varchar2(64);
  va array := array(2,3,5);
  aso asso_array;
  i varchar2(64);
  TYPE nest_table IS TABLE OF varchar2(15);
  nest nest_table := nest_table('D Caruso', 'J Hamil', 'D Piro', 'R Singh');
BEGIN
  dbe_output.print_line('varray:');
  FOR i IN 1  ..    3 LOOP
    dbe_output.print_line(va(i));
  END LOOP;
  dbe_output.print_line('---');
  dbe_output.print_line('Associative Array:');
  aso('Smallville') := 2000; aso('Midland') := 3000; aso('Megalopolis') := 10000;
  i := aso.FIRST();
  WHILE i IS NOT NULL LOOP
	dbe_output.print_line(i || ' is ' || aso(i));
    i := aso.NEXT(i); -- Get next element of array
  END LOOP;
  dbe_output.print_line('---');
  dbe_output.print_line('nested table:');
  FOR i IN nest.FIRST() .. nest.LAST() LOOP -- For first to last element
	dbe_output.print_line(nest(i));
  END LOOP;
END;
/


--test collection of nesting
DECLARE
  TYPE array IS VARRAY(10) OF INTEGER; -- varray of integer
  va array := array(2,3,5);
  TYPE nt1 IS VARRAY(10) OF array; -- varray of varray of integer
  nva nt1 := nt1(va, array(55,6,73), array(2,4,3), va);
  TYPE aso_array IS TABLE OF array INDEX BY varchar2(15); -- associative array of varray
  aso aso_array;
  TYPE nest_table IS TABLE OF array;
  nest nest_table := nest_table(va, array(55,6,73), array(2,4,3), va);
  TYPE nest_table2 IS TABLE OF nest_table;
  nest2 nest_table2 := nest_table2(nest,nest_table(va, array(1,4,7)));
  i varchar2(64);
BEGIN
  aso('Smallville') := va;
  aso('Megalopolis') := array(55,6,73); -- nested table of varray
  dbe_output.print_line('varray:');
  FOR i IN 1 .. 4 LOOP
     dbe_output.print_line(nva(i)(1) || ',' ||  nva(i)(2)|| ',' || nva(i)(3));
  END LOOP;
  dbe_output.print_line('---');
  dbe_output.print_line('Associative Array:');
  i := aso.FIRST();
  WHILE i IS NOT NULL LOOP
	dbe_output.print_line(i || ' is ' || aso(i)(1)|| ',' ||  aso(i)(2)|| ',' || aso(i)(3));
    i := aso.NEXT(i); -- Get next element of array
  END LOOP;
  dbe_output.print_line('---');
  dbe_output.print_line('nested table:');
  FOR i IN 1 .. 4 LOOP
    dbe_output.print_line(nest(i)(1) || ',' ||  nest(i)(2)|| ',' || nest(i)(3));
  END LOOP;
  dbe_output.print_line('---');
  FOR j IN 1 .. nest2.COUNT() LOOP
    FOR m IN 1 .. nest2(j).COUNT() LOOP 
	  FOR n IN 1 .. nest2(j)(m).COUNT() LOOP 
        dbe_output.print(nest2(j)(m)(n) || ' ');
	  END LOOP;
	  dbe_output.print_line('---' || j);
	END LOOP;
  END LOOP;
END;
/

--test deep copy
DECLARE
  TYPE array IS VARRAY(10) OF INTEGER; -- varray of integer
  va array := array(2,3,5);
  va_cp array;
  TYPE asso_array IS TABLE OF Integer INDEX BY varchar2(64);
  aso asso_array;
  aso_cp asso_array;
  TYPE nest_table IS TABLE OF varchar2(15);
  nest nest_table := nest_table('D Caruso', 'J Hamil', 'D Piro', 'R Singh');
  nest_cp nest_table;
  j varchar2(64);
BEGIN
  va_cp := va;
  va_cp(1) := 1; va_cp(2) := 4; va_cp(3) := 7;
  dbe_output.print_line('varray:');
  FOR i IN 1 .. va.COUNT() LOOP
     dbe_output.print_line(va(i) || ',' ||  va_cp(i));
  END LOOP;
  dbe_output.print_line('---');
  dbe_output.print_line('Associative Array:');
  aso('Smallville') := 2000; aso('Midland') := 3000; aso('Megalopolis') := 10000;
  aso_cp := aso;
  aso_cp('Smallville') := 1000; aso_cp('Midland') := 4000;
  j := aso.FIRST();
  WHILE j IS NOT NULL LOOP
	dbe_output.print_line(j || ' is ' || aso(j) || ',' || aso_cp(j));
    j := aso.NEXT(j); 
  END LOOP;
  dbe_output.print_line('---');
  dbe_output.print_line('nested table:');
  nest_cp := nest;
  nest_cp(1) := 'A'; nest_cp(2) := 'B'; nest_cp(3) := 'C'; nest_cp(4) := 'D';
  FOR m IN 1 .. nest.COUNT() LOOP
     dbe_output.print_line(nest(m) || ',' ||  nest_cp(m));
  END LOOP;
END;
/

--test collection func(FIRST LAST COUNT LIMIT)
DECLARE
  TYPE array IS VARRAY(3) OF varchar(10);
  va array := array('Smith','John','Merry');
  TYPE asso_array IS TABLE OF Integer INDEX BY PLS_INTEGER;
  aso asso_array;
  TYPE nest_table IS TABLE OF varchar2(15);
  nest nest_table := nest_table('D Caruso', 'J Hamil', 'D Piro', 'R Singh');
BEGIN
  aso(1) := 2000; aso(2) := 3000; aso(3) := 10000;
  dbe_output.print_line(va.FIRST() || ',' || aso.FIRST() || ',' || nest.FIRST());
  --oracle support
  dbe_output.print_line(va.FIRST || ',' || aso.FIRST || ',' ||nest.FIRST);
  dbe_output.print_line(va.LAST()|| ',' ||aso.LAST() ||',' || nest.LAST());
  --oracle support
  dbe_output.print_line(va.LAST || ',' || aso.LAST || ',' || nest.LAST);
  dbe_output.print_line(va.COUNT() || ',' || aso.COUNT() || ',' || nest.COUNT());
  --oracle support
  dbe_output.print_line(va.COUNT || ',' || aso.COUNT || ',' || nest.COUNT);
  dbe_output.print_line(va.LIMIT() || ',' || aso.LIMIT() || ',' || nest.LIMIT());
  --oracle support
  dbe_output.print_line(va.LIMIT || ',' || aso.LIMIT || ',' || nest.LIMIT);
END;
/

CREATE OR REPLACE TYPE array IS VARRAY(10) OF Integer;
/
CREATE OR REPLACE PROCEDURE print_arr (var array) IS
  i NUMBER;
BEGIN
  i := var.FIRST();
  IF i IS NULL THEN
    dbe_output.print_line('var is empty');
  ELSE
    WHILE i IS NOT NULL LOOP
      dbe_output.print_line('var(' || i || ') = ' || var(i));
      i := var.NEXT(i);
    END LOOP;
  END IF;
    dbe_output.print_line('---');
END print_arr;
/

CREATE OR REPLACE TYPE nest_table IS TABLE OF Integer;
/
CREATE OR REPLACE PROCEDURE print_nest (nest nest_table) IS
  i NUMBER;
BEGIN
  i := nest.FIRST();
  IF i IS NULL THEN
    dbe_output.print_line('nest is empty');
  ELSE
    WHILE i IS NOT NULL LOOP
      dbe_output.print_line('nest(' || i || ') = ' || nest(i));
      i := nest.NEXT(i);
    END LOOP;
  END IF;
    dbe_output.print_line('---');
END print_nest;
/

--test collection func(DELETE)
DECLARE
  var array := array(11, 22, 33, 44, 55, 66);
  nest nest_table := nest_table(11, 22, 33, 44, 55, 66);
  TYPE aso_array IS TABLE OF INTEGER INDEX BY VARCHAR2(10);
  aa aso_array;
  PROCEDURE print_aa IS
	i VARCHAR2(10);
  BEGIN
	i := aa.FIRST;
	IF i IS NULL THEN
	  dbe_output.print_line('aa is empty');
	ELSE
	  WHILE i IS NOT NULL LOOP
	    dbe_output.print_line('aa.(' || i || ') = ' || aa(i));
		  i := aa.NEXT(i);
	  END LOOP;
	END IF;
	dbe_output.print_line('---');
  END print_aa;
BEGIN
  print_arr(var);
  var.DELETE();
  print_arr(var);
  nest.DELETE(2); -- Delete second element
  print_nest(nest);
  nest(2) := 2222; -- Restore second element
  print_nest(nest);
  nest.DELETE(2, 4); -- Delete range of elements
  print_nest(nest);
  nest(3) := 3333; -- Restore third element
  print_nest(nest);
  nest.DELETE; -- Delete all elements
  print_nest(nest);
  aa('M') := 13; aa('Z') := 26; aa('C') := 3;
  print_aa;
  aa.DELETE; -- Delete all elements
  print_aa;
  aa('M') := 13; aa('Z') := 260; aa('C') := 30; aa('W') := 23; 
  aa('J') := 10; aa('N') := 14; aa('P') := 16; aa('W') := 23; aa('J') := 10; 
  print_aa;
  aa.DELETE('C'); -- Delete one element
  print_aa;
  aa.DELETE('N','W'); -- Delete range of elements
  print_aa;
  aa.DELETE('Z','M'); -- Does nothing
  print_aa;
END;
/

--test varray or nested table func(TRIM)
DECLARE
  var array := array(11, 22, 33, 44, 55, 66);
  nest nest_table := nest_table(11, 22, 33, 44, 55, 66);
BEGIN
  print_arr(var);
  var.TRIM; -- Trim last element
  print_arr(var);
  var.TRIM(2); -- Trim last two elements
  print_arr(var);
  print_nest(nest);
  nest.TRIM; -- Trim last element
  print_nest(nest);
  nest.DELETE(4); -- Delete fourth element
  print_nest(nest);
  nest.TRIM(2); -- Trim last two elements
  print_nest(nest);
END;
/

--test varray or nested table func(EXTEND)
DECLARE
  var array := array(11, 22, 33);
  nest nest_table := nest_table(11, 22, 33, 44, 55, 66);
BEGIN
  print_arr(var);
  var.EXTEND(2,1); -- Append two copies of first element
  print_arr(var);
  var.EXTEND(); -- Append one null element
  print_arr(var);
  var.EXTEND(2); -- Append two null element
  print_arr(var);
  print_nest(nest);
  nest.EXTEND(2,1); -- Append two copies of first element 
  print_nest(nest);
  nest.DELETE(5); -- Delete fifth element
  print_nest(nest);
  nest.EXTEND; -- Append one null element
  print_nest(nest);
END;
/

--test varray or nested table func(EXISTS)
DECLARE
  var array := array(1, 3, 5);
  nest nest_table := nest_table(1,3,5,7);
BEGIN
  FOR i IN 1..3 LOOP
    IF var.EXISTS(i) THEN
	  dbe_output.print_line('var(' || i || ') = ' || var(i));
	ELSE
	  dbe_output.print_line('var(' || i || ') does not exist');
	END IF;
  END LOOP;
  nest.DELETE(2); -- Delete second element
  FOR j IN 1..6 LOOP
    IF nest.EXISTS(j) THEN
      dbe_output.print_line('nest(' || j || ') = ' || nest(j));
    ELSE
      dbe_output.print_line('nest(' || j || ') does not exist');
    END IF;
  END LOOP;
END;
/

--test collection func(prior next)
DECLARE
  TYPE Arr_Type IS VARRAY(10) OF NUMBER;
  v_Numbers Arr_Type := Arr_Type();
  nest nest_table := nest_table(18, NULL, 36, 45, 54, 63);
BEGIN
  v_Numbers.EXTEND(4);
  v_Numbers (1) := 10; v_Numbers (2) := 20; v_Numbers (3) := 30; v_Numbers (4) := 40;
  dbe_output.print_line(NVL(v_Numbers.prior (3400), 1));
  dbe_output.print_line(NVL(v_Numbers.next (3400), 1));
  nest.DELETE(4);
  dbe_output.print_line('nest(4) was deleted.');
  FOR i IN 1..7 LOOP
    dbe_output.print_line('nest.PRIOR(' || i || ') = ' || nest.PRIOR(i)); 
    dbe_output.print_line('nest.NEXT(' || i || ') = ' || nest.NEXT(i));
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
  nva nt1;
BEGIN
  value1.f1 := 10;
  value1.f2 := 'John';
  value2.f1 := 20;
  value2.f2 := 'Smith';
  nva := nt1(value1, value2);
  FOR i IN 1 .. 2 LOOP
	dbe_output.print_line(nva(i).f1 || '---' || nva(i).f2);
  END LOOP;
END;
/

DROP TYPE array;
DROP TYPE nest_table;
DROP PROCEDURE print_arr;
DROP PROCEDURE print_nest;

drop table if exists trigger8_bingfa_Tab_001;
drop table if exists trigger8_bingfa_Tab_002;
create table trigger8_bingfa_Tab_001(id int constraint trigger8_bingfa_Cons_001 primary key,sal number(10,2),name varchar(100),text clob default 'test',c_time date);
insert into trigger8_bingfa_Tab_001 values(1,123.11,'test','lob',to_date('2019-01-31 01:12:12'));
create table trigger8_bingfa_Tab_002(id int ,sal number(10,2),name varchar(100),text clob default 'test',c_time date);
drop sequence if exists trigger8_bingfa_Seq_01;
create sequence trigger8_bingfa_Seq_01 start  with 1 increment by 1;
create or replace function trigger8_bingfa_fun_01 return int is 
id int;
begin
select floor(avg(id)) into id from trigger8_bingfa_Tab_002;
return id;
end;
/
create or replace trigger trigger8_bingfa_02 before update on 
trigger8_bingfa_Tab_001 
declare
c trigger8_bingfa_Tab_001%rowtype;
cursor mycursor(p1 int) is select * from trigger8_bingfa_Tab_001 where id > p1 order by id;
begin
open mycursor(trigger8_bingfa_fun_01());
fetch mycursor into c;
loop 
if mycursor%found
   then
   dbe_output.print_line('before update:'||c.id||c.name||c.sal);
   fetch mycursor into c;
end if;
exit when mycursor%notfound;
end loop;
insert into trigger8_bingfa_Tab_002(id,text) values (trigger8_bingfa_Seq_01.nextval,'before update on trigger8_bingfa_Tab_001 ');
end;
/
update trigger8_bingfa_Tab_001 set sal = 225 where id = 1;
select * from trigger8_bingfa_Tab_001;
select * from trigger8_bingfa_Tab_002;
drop table trigger8_bingfa_Tab_001;
drop table trigger8_bingfa_Tab_002;
drop sequence trigger8_bingfa_Seq_01;
drop function trigger8_bingfa_fun_01;

drop table if exists CURSOR_FUNCTION_001_TAB_01;
create table CURSOR_FUNCTION_001_TAB_01(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into CURSOR_FUNCTION_001_TAB_01 values(1,'zhangsan','doctor1',10000);
insert into CURSOR_FUNCTION_001_TAB_01 values(2,'zhangsan2','doctor2',10000);
insert into CURSOR_FUNCTION_001_TAB_01 values(123,'zhangsan3','doctor3',10000);
commit;
create or replace function CURSOR_FUNCTION_001_FUN_01(str1 varchar) return int 
is 
mycursor1 sys_refcursor;
a int;
begin
 select empno into a from CURSOR_FUNCTION_001_TAB_01;
   dbe_output.print_line(a);
   exception
   when  TOO_MANY_ROWS  then
   begin
      select empno into a from CURSOR_FUNCTION_001_TAB_01 limit 1;
     dbe_output.print_line(a);
     return length(str1);
   end;
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
CREATE OR REPLACE PROCEDURE CURSOR_FUNCTION_001_PROC_02_2(x BOOLEAN) AS
mycursor1 sys_refcursor ;
v_int int;
BEGIN
  IF x THEN
    dbe_output.print_line('x is true');
  END IF;
   select CURSOR_FUNCTION_001_FUN_02_3('aa') into mycursor1 from dual;
  fetch mycursor1 into v_int;
   dbe_output.print_line('mycursor1='||v_int);
END;
/
drop table CURSOR_FUNCTION_001_TAB_01;
drop function CURSOR_FUNCTION_001_FUN_01;
drop function CURSOR_FUNCTION_001_FUN_02_3;
drop PROCEDURE CURSOR_FUNCTION_001_PROC_02_2;

drop table if exists ARRAY_TAB_001;
create table ARRAY_TAB_001(f1 int);
create or replace procedure ARRAY_PRO_001(p0 int, p1 ARRAY_TAB_001%rowtype, p2 ARRAY_TAB_001%rowtype)
as
begin
    dbe_output.print_line(p1.f1);
end;
/
declare
v1 ARRAY_TAB_001%rowtype;
v2 int := 2;
begin
  v1.f1 := 5;
  ARRAY_PRO_001(v2, v1, v1);
end;
/
create or replace function ARRAY_FUNC_001(p1 ARRAY_TAB_001%rowtype) return int
as
begin
    dbe_output.print_line(p1.f1);
return 3;
end;
/
declare
x ARRAY_TAB_001%rowtype;
d int;
begin
x.f1 := 1;
d := ARRAY_FUNC_001(x);
dbe_output.print_line(d);
end;
/
drop procedure ARRAY_PRO_001;
drop function ARRAY_FUNC_001;
drop table ARRAY_TAB_001;
--DTS2019111300608
CREATE OR REPLACE TYPE varray5 force is varray(4) of int;
/ 
create or replace function fvt_func_05 (aa5 varray5) return varray5 is
var5 varray5;
begin
var5 := varray5(5, 6);
return var5;
end;
/
declare
v1 varray5:=varray5(1, 2, 3, 4);
id int;
begin
	select fvt_func_05(v1) into id from dual;  
    dbe_output.print_line(id);
end;
/

CREATE OR REPLACE TYPE varray5 force is object(id int);
/ 
create or replace function fvt_func_05 (aa5 varray5) return varray5 is
var5 varray5 := varray5(3);
begin
var5 := varray5(3);
return var5;
end;
/
declare
v1 varray5:=varray5(1);
id int;
begin
	select fvt_func_05(v1) into id from dual;  
    dbe_output.print_line(id);
end;
/
drop type varray5 force;
drop function fvt_func_05;

create or replace type varray_array_g force is varray(4) of int[];
/
create or replace type table_array_g force is table of int[];
/
create or replace type object_array_g force is object(name char(10), id int[]);
/
declare
type varray_array is varray(4) of int[];
begin
  dbe_output.print_line(1);
end;
/
declare
type table_array is table of int[];
begin
  dbe_output.print_line(1);
end;
/
declare
type record_array is record(
id int[],
name char(10)
);
begin
  dbe_output.print_line(1);
end;
/
drop table if exists test_array;
create table test_array(id int, arr int[]);
insert into test_array values(1, array[1]);
insert into test_array values(2, array[2]);
commit;
declare
type record_array1111 is table of test_array.arr%type;
v1 record_array1111;
begin
  dbe_output.print_line(1);
end;
/
declare
v1 test_array%rowtype;
begin
select * into v1 from test_array where id=1;
  dbe_output.print_line(v1.arr);
end;
/
drop table test_array;

create or replace type table7777 force is table of varchar(100);
/
declare
dd table7777 := table7777('0110');
begin
dd:=dd;
dbe_output.print_line(dd(1));
end;
/
drop type table7777;
declare
type table7 is record(name varchar(100), id int);
dd table7;
begin
dd.name:='0110';
dd:=dd;
dbe_output.print_line(dd.name);
end;
/
--DTS2019113006407
drop type if exists DATA_TYP_USING_REPLACE force;
drop type if exists DATA_TYP_USING_REPLACE_2 force;
CREATE OR REPLACE TYPE DATA_TYP_USING_REPLACE FORCE AS OBJECT
( year NUMBER
);
/
CREATE OR REPLACE TYPE DATA_TYP_USING_REPLACE_2 FORCE AS OBJECT
( year DATA_TYP_USING_REPLACE
);
/
CREATE OR REPLACE TYPE DATA_TYP_USING_REPLACE FORCE AS OBJECT
( year NUMBER,
  day NUMBER
);
/
declare
    b DATA_TYP_USING_REPLACE:=DATA_TYP_USING_REPLACE(11, 22);
	a DATA_TYP_USING_REPLACE_2:=DATA_TYP_USING_REPLACE_2(b);
begin
	dbe_output.print_line(a.year.year);
end;
/
drop type DATA_TYP_USING_REPLACE_2 force;
drop type DATA_TYP_USING_REPLACE force;

--DTS2020020800296
declare
       type ListType is table of int;
	   p_key ListType:= ListType(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34);
begin
       p_key.delete;
	   dbe_output.print_line('p_key: ' ||p_key.count);
	   p_key(1):=1;
end;
/
declare
       type ListType is table of int;
	    p_key ListType:= ListType(1,2,3);
begin
       p_key.delete(3);
       p_key(3) := 4;
	   dbe_output.print_line('p_key(3): ' ||p_key(3));
end;
/
declare
       type ListType is table of int;
	    p_key ListType:= ListType(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34);
begin
       p_key.delete;
	   dbe_output.print_line('p_key: ' ||p_key.count);
end;
/
declare
       type ListType is table of int;
	    p_key ListType:= ListType();
begin
	   dbe_output.print_line('p_key: ' ||p_key.count);
       p_key.trim;
	   dbe_output.print_line('p_key: ' ||p_key.count);
end;
/
declare
       type ListType is table of int;
	    p_key ListType:= ListType(1);
begin
	   dbe_output.print_line('p_key: ' ||p_key.count);
	   p_key.delete;
       p_key.trim;
	   dbe_output.print_line('p_key: ' ||p_key.count);
end;
/
declare
       type ListType is table of int;
	    p_key ListType:= ListType(1, 2);
begin
	   dbe_output.print_line('p_key: ' ||p_key.count);
	   p_key.delete(2);
       p_key.trim;
	   dbe_output.print_line('p_key1: ' ||p_key(1));
end;
/
declare
       type ListType is table of int;
	    p_key ListType:= ListType(1);
begin
	   dbe_output.print_line('p_key: ' ||p_key.count);
	   p_key.delete(1);
       p_key.extend;
	   p_key(1):=0;
	   p_key(2):=2;
	   dbe_output.print_line('p_key: ' ||p_key.count);
end;
/
declare
       type ListType is table of int;
	    p_key ListType:= ListType(1);
begin
	   dbe_output.print_line('p_key: ' ||p_key.count);
	   p_key.delete;
       p_key.extend;
	   p_key(1):=0;
	   p_key(2):=2;
	   dbe_output.print_line('p_key: ' ||p_key.count);
end;
/
declare
       type ListType is table of int;
	    p_key ListType:= ListType(1,2,3);
begin
       p_key.delete;
	   dbe_output.print_line('last: ' ||p_key.last);
end;
/
declare
       type ListType is table of int;
	    p_key ListType:= ListType(1,2,3);
begin
       p_key.delete;
	   dbe_output.print_line('3prior: ' ||p_key.prior(3));
end;
/

--DTS2020021307176	
CREATE OR REPLACE PROCEDURE Proc_Test_003()
   IS
   BEGIN
     DECLARE
       CURSOR C2 IS
         select 1 from dual;
       R_C2 C2%ROWTYPE;
     BEGIN
       OPEN C2;
      CLOSE C2;
    END;
  END Proc_Test_003;
  /
  
  begin
   Proc_Test_003;
   Proc_Test_003;
   end;
   /
drop PROCEDURE Proc_Test_003;
drop table if exists my_tab_0217;

create table my_tab_0217(f1 BINARY_UINT32, f2  INTERVAL YEAR(4) TO MONTH, f3 INTERVAL DAY(7) TO SECOND, f4 TIMESTAMP WITH LOCAL TIME ZONE, f5 clob);

INSERT INTO  my_tab_0217 VALUES(1, '2009-10', '1231 12:3:4.1234', '2020-02-17 15:10:20.123000', 'aopPokjojgokj');
INSERT INTO  my_tab_0217 VALUES(1, '2009-10', '1231 12:3:4.1234', '2020-02-17 15:10:20.123000', 'aopPokjojgokj');
create or replace procedure my_proc_02171(v_refcur1 out sys_refcursor)
is
ppp my_tab_0217%rowtype;
begin
open v_refcur1 for select * from my_tab_0217;
fetch v_refcur1 into ppp;
dbe_output.print_line('f1 ' ||ppp.f1 ||' f2 ' ||ppp.f2 ||' f3 ' ||ppp.f3 ||' f4 ' ||ppp.f4 ||' f5 ' ||ppp.f5);
end;
/

declare
v_refcur1 sys_refcursor;
ppp my_tab_0217%rowtype;
begin
my_proc_02171(v_refcur1);
fetch v_refcur1 into ppp;
dbe_output.print_line('f1 ' ||ppp.f1 ||' f2 ' ||ppp.f2 ||' f3 ' ||ppp.f3 ||' f4 ' ||ppp.f4 ||' f5 ' ||ppp.f5);
end;
/

drop procedure my_proc_02171;
drop table my_tab_0217;

DECLARE
  TYPE rec_type1 IS RECORD ( 
    f1 INTEGER,
    f2 VARCHAR2(15)
  );
  TYPE rec_type IS RECORD ( 
    a rec_type1,
    b VARCHAR2(15)
  );
  
  value1 rec_type1;
  value2 rec_type;
  TYPE nt1 IS VARRAY(10) OF rec_type;  -- varray of RECORD
  nva nt1;
BEGIN
  value1.f1 := 10;
  value1.f2 := 'John';
  value2.a := value1;
  value2.b := 'Smith';
  nva := nt1(value2);
  dbe_output.print_line(nva(1).a.f1 || '---' || nva(1).a.f2 || '---' || nva(1).b);
END;
/

CREATE OR REPLACE TYPE my_type_2020_01 force is object(f1 int, f2 varchar(10));
/ 
CREATE OR REPLACE TYPE my_type_2020_02 force is object(a my_type_2020_01, b varchar(10));
/
CREATE OR REPLACE TYPE my_type_2020_03 force is table of my_type_2020_01;
/ 
CREATE OR REPLACE TYPE my_type_2020_04 force is table of my_type_2020_02;
/
CREATE OR REPLACE TYPE my_type_2020_05 force is table of int;
/
CREATE OR REPLACE TYPE my_type_2020_06 force is object(f1 my_type_2020_05);
/
CREATE OR REPLACE TYPE my_type_2020_07 force is table of int;
/
CREATE OR REPLACE TYPE my_type_2020_08 force is object(f1 int, f2 varchar(10));
/
CREATE OR REPLACE TYPE my_type_2020_09 force is object(a my_type_2020_08, b varchar(10));
/
create or replace function g_my_table311 return my_type_2020_02
  is
  value1 my_type_2020_01 := my_type_2020_01(10, 'jhon');
  value2 my_type_2020_02;
  nva my_type_2020_04;
BEGIN
	value2 := my_type_2020_02(value1, 'ero');
  nva := my_type_2020_04(value2);
  --dbe_output.print_line(nva(1).a.f1 || '---' || nva(1).a.f2 || '---' || nva(1).b);
  return value2;
 end;
 /
 create or replace function g_my_table411 return my_type_2020_09
  is
  value1 my_type_2020_08 := my_type_2020_08(10, 'jhon');
  value2 my_type_2020_09;
BEGIN
	value2 := my_type_2020_09(value1, 'ero');
  --dbe_output.print_line(nva(1).a.f1 || '---' || nva(1).a.f2 || '---' || nva(1).b);
  return value2;
 end;
 /
 
declare
ret my_type_2020_04;
begin
ret := my_type_2020_04(g_my_table311);
dbe_output.print_line(ret(1).a.f1);
end;
/
 
 create or replace function g_my_table511 return my_type_2020_07
  is
  value1 my_type_2020_07 := my_type_2020_07(10, 11);
BEGIN
  return value1;
 end;
 /

declare
ret my_type_2020_06;
begin
ret := my_type_2020_06(g_my_table511);
dbe_output.print_line(ret.f1(1));
end;
/

declare
ret my_type_2020_04;
begin
ret := my_type_2020_04(g_my_table411);
dbe_output.print_line(ret(1).a.f1);
end;
/

drop TYPE my_type_2020_01 force;
drop TYPE my_type_2020_02 force;
drop TYPE my_type_2020_03 force;
drop TYPE my_type_2020_04 force;
drop TYPE my_type_2020_05 force;
drop TYPE my_type_2020_06 force;
drop TYPE my_type_2020_07 force;
drop TYPE my_type_2020_08 force;
drop TYPE my_type_2020_09 force;
drop function g_my_table311;
drop function g_my_table411;
drop function g_my_table511;

--scalar check
declare
   type ListType is table of varchar(10);
   p_key ListType:=ListType('a');
begin
   p_key(1):= '221sssssssss';
   dbe_output.print_line
	   ('index: ' ||1 || ' is ' || p_key(1));
end;
/

declare
   type ListType is varray(5) of binary(10);
   p_key ListType:=ListType(1011);
begin
   p_key(1):= 101111001101;
   dbe_output.print_line
	   ('index: ' ||1 || ' is ' || p_key(1));
end;
/

declare
   type ListType is record(
   a varchar(10),
   b int
   );
   p_key ListType;
begin
   p_key.a:= '221sssssssss';
   dbe_output.print_line
	   ('index: ' ||1 || ' is ' || p_key.a);
end;
/

--test case by d00504205
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_user_2020 cascade;
create user gs_user_2020 identified by Cantian_234;
grant dba to gs_user_2020;
conn gs_user_2020/Cantian_234@127.0.0.1:1611
set serveroutput on;
create or replace type my_type_345 is  table of number;
 /
CREATE OR REPLACE PACKAGE PAK1_DSH
IS
 FUNCTION g_my_table1 return my_type_345;
END;
/
CREATE OR REPLACE PACKAGE BODY PAK1_DSH
IS
 FUNCTION g_my_table1 return my_type_345
 IS
  l_my_table_tab my_type_345 := my_type_345(1,2,3);
  begin
	return l_my_table_tab;
 end;
END;
/

CREATE OR REPLACE PACKAGE PAK2_DSH
IS
 PROCEDURE MY_PROC1 ;
END;
/
CREATE OR REPLACE PACKAGE BODY PAK2_DSH
IS
 PROCEDURE MY_PROC1
 IS
  xxx my_type_345 ;
  begin
		xxx := PAK1_DSH.g_my_table1;
 end;
END;
/
exec dbe_util.compile_schema('gs_user_2020');
CREATE OR REPLACE PACKAGE BODY PAK2_DSH
IS
 PROCEDURE MY_PROC1
 IS
  xxx my_type_345 ;
  begin
		xxx := PAK1_DSH.g_my_table1;
 end;
END;
/
DROP PACKAGE IF EXISTS PAK1_DSH;
DROP PACKAGE IF EXISTS PAK2_DSH;
drop type my_type_345 force;
conn gs_plsql_udf_type/Lh00420062@127.0.0.1:1611
drop user if exists gs_user_2020 cascade;

--test package core 
CREATE OR REPLACE PACKAGE PAK_CORE_2020 IS 
FUNCTION AAA RETURN INT; 
FUNCTION BBB(a VARCHAR2, b VARCHAR2) RETURN INT ; 
END; 
/ 
CREATE OR REPLACE PACKAGE BODY PAK_CORE_2020 IS 
FUNCTION CCC RETURN INT 
IS 
V1 INT := 10;
 BEGIN  
 NULL;  
 RETURN V1; 
 END; 
 
FUNCTION BBB(a VARCHAR2, b VARCHAR2) RETURN INT  IS
V1 INT; 
BEGIN  
SELECT CCC INTO  V1 FROM DUAL;  
RETURN 1; 
END; 
END; 
/ 
DROP PACKAGE IF EXISTS PAK_CORE_2020;

DROP TABLE if exists t17534;
create table t17534 (a int, b int, c int, d varchar2(12));
create or replace type myarray345 is table of varchar(128);
/
declare 
v1 myarray345;
begin
delete from t17534 returning a bulk collect into v1;
dbe_output.print_line(v1.count);
end;
/
declare 
v1 myarray345;
begin
update t17534 set a=1 where a=2 returning a bulk collect into v1;
dbe_output.print_line(v1.count);
end;
/
declare 
v1 myarray345;
begin
select 1 bulk collect into v1 from dual where 1=2;
dbe_output.print_line(v1.count);
end;
/
insert into t17534 values (2, 3, -2, 'a');
insert into t17534 values (3, 4, -2, 'a');
insert into t17534 values (4, 5, -5, 'a');
insert into t17534 values (5, 6, -6, 'b');
insert into t17534 values (6, 7, -7, 'b');
insert into t17534 values (7, 8, -88, 'b');
declare 
cursor cur_object is  select a,b,d from t17534;
v1 myarray345;
v2 myarray345;
v3 myarray345;
begin
open cur_object;
loop
fetch cur_object bulk collect into v1,v2,v3 limit 2;
exit when cur_object%notfound;
end loop;
close cur_object;
end;
/
DROP TABLE t17534;
DROP TYPE  myarray345;

--DTS20200708
create or replace type abc FORCE is VARRAY(10) OF int;
/
create or replace type dcc FORCE is table OF int;
/
CREATE OR REPLACE TYPE ATTR_TY FORCE AS OBJECT
( month int
);
/
--nvl() & complex type
DECLARE 
s abc;
d dcc;
BEGIN
dbe_output.print_line(nvl(s, d));
END;
/
DECLARE
s abc := abc(1);
d dcc := dcc(2);
c abc;
BEGIN
dbe_output.print_line(nvl(s(1), d(1)));
END;
/
DECLARE
s ATTR_TY;
BEGIN
dbe_output.print_line(nvl(s.month, 1));
END;
/
declare
type err is varray(10) of int;
v1 err;
v2 int;
begin
  v1 := err();
  v1.EXTEND(2);
  dbe_output.print_line(nvl(v1(1), 1));
end;
/
declare
s ATTR_TY;
begin
if s is null then
dbe_output.print_line(1);
else
dbe_output.print_line(2);
end if;
end;
/
declare
s ATTR_TY;
begin
if s.month is null then
dbe_output.print_line(1);
else
dbe_output.print_line(2);
end if;
end;
/
declare
s ATTR_TY;
begin
if s.a is null then
dbe_output.print_line(1);
end if;
end;
/
--addressing
declare
s ATTR_TY:=ATTR_TY(1);
c int;
begin
c:=s(a);
end;
/
DECLARE
type sss is table of int index by binary_integer;
q sss;
c int;
begin
q(1) := 1;
c:=q(((1)));
END;
/
DECLARE
type sss is table of int index by binary_integer;
type err is record(a sss);
e err;
q sss;
c int;
begin
q(1) := 1;
e.a := q;
c:=q(e.a(1));
dbe_output.print_line(c);
END;
/
DROP TYPE abc FORCE;
DROP TYPE dcc FORCE;
DROP TYPE ATTR_TY FORCE;

--------------------------------------------OBJECT test & coverage
CREATE OR REPLACE TYPE OBJ_1 FORCE AS OBJECT
( m int
);
/
CREATE OR REPLACE TYPE OBJ_2 FORCE AS OBJECT
( m int
);
/
CREATE OR REPLACE TYPE OBJ_3 FORCE AS OBJECT
( x OBJ_1
);
/
CREATE OR REPLACE TYPE OBJ_4 FORCE AS OBJECT
( x varchar(10)
);
/
declare
a OBJ_1 := OBJ_1(1);
b OBJ_2;
begin
b := a;
dbe_output.print_line(b.m);
end;
/
declare
a OBJ_3 := OBJ_3(1);
begin
dbe_output.print_line(1);
end;
/

declare
a OBJ_4 := OBJ_4('aaaaaaaaaa12');
begin
dbe_output.print_line(1);
end;
/

--bulk
drop table if exists bulk_t1;
create table bulk_t1(id int, name varchar(10));
insert into bulk_t1 values(1, 'a');
insert into bulk_t1 values(2, 'g');
commit;
CREATE OR REPLACE TYPE ATTR_T3  AS OBJECT
( e int,
  r varchar(10)
);
/

declare
t1 ATTR_T3;
begin
select * into t1 from bulk_t1 limit 1;
end;
/

declare
t1 ATTR_T3;
begin
execute immediate 'select * from bulk_t1 limit 1' into t1;
end;
/

declare
type nstb is table of ATTR_T3;
t1 nstb;
begin
select * bulk collect into t1 from bulk_t1;
end;
/

declare
type nstb is table of ATTR_T3;
t1 nstb;
begin
execute immediate '
select * from bulk_t1
' bulk collect into t1;
end;
/

declare
type nstb is table of ATTR_T3;
t1 nstb;
begin
select * bulk collect into t1, t1 from bulk_t1;
dbe_output.print_line(t1(2).e);
end;
/

declare
type rec is record(e int,
  r varchar(10));
type nstb is table of rec;
t1 nstb;
t2 nstb;
begin
select * bulk collect into t2, t1 from bulk_t1;
end;
/

declare
type nstb is table of varchar(10);
t1 nstb;
type nstb2 is table of int;
t2 nstb2;
begin
select * bulk collect into t2, t1 from bulk_t1;
dbe_output.print_line(t1(2));
end;
/

--cast & coll-object
DROP TABLE IF EXISTS TEST_CAST;
CREATE TABLE TEST_CAST(F1 VARCHAR(30), F2 INT);
CREATE OR REPLACE TYPE ATTR_T FORCE AS OBJECT (F1 VARCHAR(30), F2 INT);
/
create or replace type cast_type_target is table of ATTR_T;
/
create or replace type cast_type_origin is VARRAY(5) of ATTR_T;
/

DECLARE
    c ATTR_T := ATTR_T('aa', 1);
    cast_type cast_type_origin;
BEGIN
    cast_type := cast_type_origin(c, c);
	insert into TEST_CAST SELECT * FROM TABLE(CAST(cast_type as cast_type_target));
END;  
/

DECLARE
    c ATTR_T := ATTR_T('aa', 1);
    cast_type cast_type_origin;
BEGIN
    cast_type := cast_type_origin(c, c);
	insert into TEST_CAST SELECT * FROM TABLE(CAST(cast_type as cast_type_origin));
END;  
/

create or replace type cast_type is VARRAY(5) of ATTR_T;
/
DECLARE
    d ATTR_T := ATTR_T('abc', 2);
    e ATTR_T := ATTR_T('dge', 3);
    cast1 cast_type := cast_type(d, e);
BEGIN
    insert into TEST_CAST SELECT * FROM TABLE(CAST(cast1 as cast_type));
END;
/
select * from TEST_CAST order by F2;

--object & %type
DECLARE
    d ATTR_T;
    e d%type;
BEGIN
    e := ATTR_T('abc', 2);
    dbe_output.print_line(e.F1);
END;
/

DECLARE
    d ATTR_T;
    e d.f1%type;
BEGIN
    select f1 into e from TEST_CAST order by F2 limit 1;
    dbe_output.print_line(e);
END;
/

--default
CREATE OR REPLACE TYPE OBJ_NULL FORCE AS OBJECT
( m int not null
);
/
CREATE OR REPLACE TYPE OBJ_NULL FORCE AS OBJECT
( m int default 3
);
/
CREATE OR REPLACE TYPE OBJ_NULL FORCE AS OBJECT
( m int not null default 3
);
/

create or replace type tab_coll FORCE is table of varchar2(10);
/
create or replace type obj_de FORCE AS OBJECT(
oa int,
ob varchar(100),
oc number) not final;
/
declare
w obj_de:= obj_de(1, 'a', 0);
p tab_coll:=tab_coll('r', 't');
TYPE record_test IS RECORD(
x int,
z obj_de default w,
q int not null default 2,
d varchar(10) default 's',
e tab_coll default p
);
v1 record_test;
begin
dbe_output.print_line(v1.q);
dbe_output.print_line(v1.d);
dbe_output.print_line(v1.e(2));
dbe_output.print_line(v1.z.ob);
end;
/

--out & object
create or replace procedure obj_proc(a OBJ_1, b out OBJ_3) is
str_l_querysql varchar(100);
begin
    dbe_output.print_line(a.m);
    str_l_querysql := 
    'begin
    :1 := OBJ_3(:2);
    end;';
    execute immediate str_l_querysql using out b, a;
end;
/
SELECT OBJECT_NAME, ARGUMENT_NAME, POSITION, DATA_TYPE FROM DB_ARGUMENTS WHERE OBJECT_NAME = 'OBJ_PROC' ORDER BY SEQUENCE;

create or replace function fvt_func_05(aa in out OBJ_1) return ATTR_T3 is
xx ATTR_T3 := ATTR_T3(8, 'iu');
begin
aa.m := 6;
return xx;
end;
/
SELECT OBJECT_NAME, ARGUMENT_NAME, POSITION, DATA_TYPE FROM DB_ARGUMENTS WHERE OBJECT_NAME = 'FVT_FUNC_05' ORDER BY SEQUENCE;

declare
a OBJ_1 := OBJ_1(9);
b OBJ_3;
c ATTR_T3;
begin
obj_proc(a, b);
dbe_output.print_line(b.x.m);
c := fvt_func_05(a);
dbe_output.print_line(a.m);
dbe_output.print_line(c.e);
end;
/

--record & %rowtype
drop table if exists test_rec1;
drop table if exists test_rec2;
drop table if exists test_rec3;
create table test_rec1(id int, name varchar(10));
insert into test_rec1 values(1, 'a');
create table test_rec2 as select * from test_rec1;
create table test_rec3(a int, b varchar(10));
commit;

declare
t1 test_rec2%rowtype;
type a is record (q int, w varchar(10));
s a;
begin
select * into t1 from test_rec1;
s := t1;
dbe_output.print_line(s.q);
end;
/

declare
t1 test_rec2%rowtype;
type a is record (q int, w varchar(10));
s a;
begin
select * into s from test_rec1;
t1 := s;
dbe_output.print_line(t1.id);
end;
/

declare
t1 test_rec3%rowtype;
s test_rec1%rowtype;
begin
select * into s from test_rec1;
t1 := s;
dbe_output.print_line(t1.a);
end;
/

create or replace type obj_de_test FORCE AS OBJECT(oa test_rec1%rowtype);
/

create or replace function fvt_func_row(aa in out test_rec1%rowtype) return test_rec3%rowtype is
xx test_rec1%rowtype;
begin
aa.id := 6;
aa.name := 'iu';
xx := aa;
return xx;
end;
/
SELECT OBJECT_NAME, ARGUMENT_NAME, POSITION, DATA_TYPE FROM DB_ARGUMENTS WHERE OBJECT_NAME = 'FVT_FUNC_ROW' ORDER BY SEQUENCE;

declare
a test_rec1%rowtype;
c test_rec3%rowtype;
begin
c := fvt_func_row(a);
dbe_output.print_line(a.id);
dbe_output.print_line(c.b);
end;
/

--DTS202009010PM8C0P1400
drop table if exists FVT_TYPE_RECORD_2;
create table FVT_TYPE_RECORD_2(id int,name varchar2(20),omg_b clob,d_tel boolean);
insert into FVT_TYPE_RECORD_2 values(5,'aedgf','gcbDgh',1);
commit;
declare
   type type_v_t_2 is record (
        a            number,
        type_col_3   FVT_TYPE_RECORD_2%rowtype);
        v_type_1 type_v_t_2;
begin
select id,omg_b into v_type_1 from FVT_TYPE_RECORD_2 where length(name)>4;
for i in 1..v_type_1.type_col_1 loop
if i>4 then
insert into FVT_TYPE_RECORD_2 values(1,'1','1',1);
else
insert into FVT_TYPE_RECORD_2 values(2,'2','2',0);
end if;
end loop;
end;
/

create or replace type test_ar is table of int;
/
create or replace type attr is object(a int);
/
declare
   type type_v_t_2 is record (
        a            number,
        type_col_3   attr);
        v_type_1 type_v_t_2;
   type type_v_t_6 is record (
        a            number,
        type_col_5   test_ar);
        v_type_6 type_v_t_6;
begin
select id,omg_b into v_type_1 from FVT_TYPE_RECORD_2 where length(name)>4;
select id,omg_b into v_type_6 from FVT_TYPE_RECORD_2 where length(name)>4;
end;
/

--not null & default
create or replace function fun_for_sysfun_010(num int) return int
is
BEGIN
 return num + 5;
END;
/
declare
  c int default fun_for_sysfun_010(20);
begin
   dbe_output.print_line('result is '||c);
end;
/

declare
  c varchar(10) not null default '20';
begin
   dbe_output.print_line('result is '||c);
end;
/

declare
type ba is table of int not null;
  c ba := ba(1, 2);
begin
   dbe_output.print_line('result is '||c(1));
end;
/

declare
  type xxx is record (c varchar(10) null);
  a xxx;
begin
   a.c := 6;
   dbe_output.print_line('result is '||a.c);
end;
/

declare
  type xxx is record (c varchar(10) not null);
  a xxx;
begin
   a.c := 6;
   dbe_output.print_line('result is '||a.c);
end;
/

declare
  type xxx is record (c varchar(10) not null := 'a23');
  a xxx;
begin
   dbe_output.print_line('result is '||a.c);
end;
/

declare
  type xxx is record (c varchar(10) default to_char(20));
  a xxx;
begin
   dbe_output.print_line('result is '||a.c);
end;
/

drop user if exists test_def cascade;
create user test_def identified by Cantian_234;
create or replace function test_def.fun_for_sysfun(num int) return clob
is
 v_lang clob := '';
BEGIN
 FOR I IN 1 .. num
 LOOP
  v_lang := v_lang || 'e';
 END LOOP;
 return v_lang;
END;
/
declare
  type type_name is record(id int, c_clob clob not null default test_def.fun_for_sysfun(20) );
  rd type_name;
  c2 sys_refcursor;
begin
   open c2 for select 10 from sys_dummy;
   fetch c2 into rd.id;
   close c2;
   dbe_output.print_line('result is '||rd.id);
   dbe_output.print_line('result is '||rd.c_clob);
end;
/
drop user test_def cascade;

create or replace procedure proc_for_sysfun_010(num int)
is
BEGIN
 dbe_output.print_line('result is '||num);
END;
/ 
declare
  type xxx is record (c int default proc_for_sysfun_010(20));
  a xxx;
begin
   dbe_output.print_line('result is '||a.c);
end;
/
DECLARE
type test_type_limit is table of number;
var_test test_type_limit := test_type_limit(123, 234, 345, '1.123', prior f1 + 1);
BEGIN
var_test.delete(2);
DBE_OUTPUT.PRINT_LINE(var_test.count);
END;
/
DECLARE
type test_type_limit is table of number;
var_test test_type_limit := test_type_limit(123, 234, 345, '1.123', f1 + 1);
BEGIN
var_test.delete(2);
DBE_OUTPUT.PRINT_LINE(var_test.count);
END;
/
DECLARE
type test_type_limit is table of number;
var_test test_type_limit := test_type_limit(123, 234, 345, '1.123', count(1)over());
BEGIN
var_test.delete(2);
DBE_OUTPUT.PRINT_LINE(var_test.count);
END;
/
DECLARE
type test_type_limit is table of number;
var_test test_type_limit := test_type_limit(123, 234, 345, '1.123', count(1));
BEGIN
var_test.delete(2);
DBE_OUTPUT.PRINT_LINE(var_test.count);
END;
/
DECLARE
type test_type_limit is table of number;
var_test test_type_limit := test_type_limit(123, 234, 345, '1.123', level);
BEGIN
var_test.delete(2);
DBE_OUTPUT.PRINT_LINE(var_test.count);
END;
/
DECLARE
type test_type_limit is table of number;
var_test test_type_limit := test_type_limit(123, 234, 345, '1.123', sys_connect_by_path('1','/'));
BEGIN
var_test.delete(2);
DBE_OUTPUT.PRINT_LINE(var_test.count);
END;
/
DECLARE
type test_type_limit is table of number;
var_test test_type_limit := test_type_limit(123, 234, 345, '1.123', root);
BEGIN
var_test.delete(2);
DBE_OUTPUT.PRINT_LINE(var_test.count);
END;
/
DECLARE
type test_type_limit is table of number;
var_test test_type_limit := test_type_limit(123, 234, 345, '1.123', array[1,2]);
BEGIN
var_test.delete(2);
DBE_OUTPUT.PRINT_LINE(var_test.count);
END;
/
drop sequence if exists slient_mode_seque_007;
CREATE SEQUENCE slient_mode_seque_007 START WITH 10 MAXVALUE 20 INCREMENT BY 1 CYCLE CACHE 19; 
DECLARE
type test_type_limit is table of number;
var_test test_type_limit := test_type_limit(123, 234, 345, '1.123', slient_mode_seque_007.nextval);
BEGIN
var_test.delete(2);
DBE_OUTPUT.PRINT_LINE(var_test.count);
END;
/
drop sequence slient_mode_seque_007;
DECLARE
type test_type_limit is table of number;
var_test test_type_limit := test_type_limit(123, 234, 345, '1.123', CONNECT_BY_ROOT);
BEGIN
NULL;
END;
/
DECLARE
type test_type_limit is table of number;
var_test test_type_limit := test_type_limit(123, 234, 345, '1.123', CONNECT_BY_isleaf);
BEGIN
NULL;
END;
/
DECLARE
type test_type_limit is table of number;
var_test test_type_limit := test_type_limit(123, 234, 345, '1.123', CONNECT_BY_isCYCLE);
BEGIN
NULL;
END;
/
DECLARE
type test_type_limit is table of number[];
var_test test_type_limit := test_type_limit(array[1,2],array[1,2]);
BEGIN
NULL;
END;
/
set serveroutput off;
conn / as sysdba
drop user gs_plsql_udf_type cascade;