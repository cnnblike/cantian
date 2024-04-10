drop user if exists gs_array2udt cascade;
create user gs_array2udt identified by Cantian_234;
grant dba to gs_array2udt;
grant all privileges to gs_array2udt;
conn gs_array2udt/Cantian_234@127.0.0.1:1611
set serveroutput on;
--expect wrong
declare
type myarray is varray(3) of int;
arr myarray;
begin
select * bulk collect into arr from table(cast(array[1,2,3] as myarray));
end;
/
--expect wrong
declare
type myarray is varray(3) of int;
arr myarray;
begin
arr := cast(array[1,2,3,4] as myarray);
end;
/

--expect wrong
declare
type myarray is varray(3) of date;
arr myarray;
begin
arr := cast(array[1,2,3] as myarray);
for i in 1..arr.count loop
    dbe_output.print_line(arr(i));
end loop;
end;
/

--array.count=0
create or replace type myarray is varray(3) of int;
/

select * from table(cast(array[] as myarray));

declare
arr myarray;
begin
arr := cast(array[] as myarray);
dbe_output.print_line(arr.count);
end;
/

create or replace function get_udt_array_count(arr myarray) return int
is
begin
return arr.count;
end;
/

create or replace type myarray is varray(3) of int;
/
--directly call udt method of the result of udf, wrong
create or replace function create_udt_array() return myarray
is
arr myarray := myarray(1,2,3);
begin
return arr;
end;
/
select create_udt_array().count from dual; --expect wrong 
select get_udt_array_count(create_udt_array()) from dual; --expect 3

-- array=zero
drop table if exists t_pgarr_null;
create table t_pgarr_null(id int,arr int[]);
insert into t_pgarr_null values(1,array[1,2,3]), (2,'{2,3,4}'::int[]),(3, null);
select (cast(arr as myarray)).count from t_pgarr_null; --expect wrong
select get_udt_array_count(cast(arr as myarray)) from t_pgarr_null; --expect wrong
select get_udt_array_count(cast(arr as myarray)) from t_pgarr_null where arr is not null order by id; 

--basic example, local global
declare
type myarray is varray(3) of int;
arr myarray;
begin
--assign cast result to a udt var directly(int)
arr := cast(array[1,2,3] as myarray);
for i in 1..arr.count loop
    dbe_output.print_line(arr(i));
end loop;
arr := cast('{1,2,3}'::int[] as myarray);
for i in 1..arr.count loop
    dbe_output.print_line(arr(i));
end loop;
end;
/
declare
type myarray is varray(3) of varchar(10);
arr myarray;
begin
--assign cast result to a udt var directly(string)
arr := cast(array['liu','hang','hello'] as myarray);
for i in 1..arr.count loop
    dbe_output.print_line(arr(i));
end loop;
arr := cast('{"liu","hang","world"}'::varchar(10)[] as myarray);
for i in 1..arr.count loop
    dbe_output.print_line(arr(i));
end loop;
end;
/

--test string truncation
declare
type myarray is varray(3) of varchar(2);
arr myarray;
begin
arr := cast(array['liu','hang','hello'] as myarray);
for i in 1..arr.count loop
    dbe_output.print_line(arr(i));
end loop;
arr := cast('{"liu","hang","world"}'::varchar(10)[] as myarray);
for i in 1..arr.count loop
    dbe_output.print_line(arr(i));
end loop;
end;
/

--basic table func
create or replace type myarray is varray(3) of int;
/
select * from table(cast(array[1,2,3] as myarray));
select * from table(cast('{1,2,3}'::int[] as myarray));
create or replace type myarray is varray(3) of varchar(10);
/
select * from table(cast(array['abc','def','hij'] as myarray));
select * from table(cast('{"abc","def","hij"}'::varchar(10)[] as myarray));


--example for NCE-E
create or replace type myarray is table of varchar(128);
/
create or replace function string_to_array(str_input varchar, c varchar) return myarray
is
res myarray :=myarray();
pos int :=1;
pos_right int :=0;
tmp varchar(128); 
res_c int :=1;
begin
loop
pos_right := instr(str_input,c,pos);
exit when pos_right = 0;
tmp := substr(str_input,pos,pos_right-pos);
--dbe_output.print_line(tmp);
res.extend(1);
res(res_c) := tmp;
res_c := res_c+1;
pos := pos_right+1;
end loop;
res.extend(1);
res(res_c) := substr(str_input,pos);
return res;
end;
/

select * from table(cast(string_to_array('123;345;456',';') as myarray));

create or replace function array_to_string(arr myarray, c varchar) return varchar
is
res varchar(1000);
arr_c int := arr.count;
begin
--dbe_output.print_line('The lenght of input array: '||arr_c);
for i in 1..arr_c-1 loop
res :=res||arr(i)||c;
end loop;
res :=res||arr(arr_c);
return res;
end;
/
--input const array
select array_to_string(cast(array['abc','def','hij'] as myarray),';') from dual;
select array_to_string(cast('{"abc","def","hij"}'::varchar(10)[] as myarray),';') from dual;

--input column from table
drop table if exists t_pg_arr_string;
create table t_pg_arr_string(id int,arr varchar(100)[]);
insert into t_pg_arr_string values(1,array['abc','def','hij']),(2,array['hij','def','aaa']);
select array_to_string(cast(arr as myarray),';') from t_pg_arr_string;

--UNNEST function, instead of
select * from t_pg_arr_string t1 where 'abc' in (select * from table(cast(t1.arr as myarray)));
select * from t_pg_arr_string where 'abc' in (select * from table(cast(arr as myarray)));

create or replace function sort_array(arr myarray) return myarray
is
res myarray := myarray();
begin
    select distinct * bulk collect into res from (
    select * from table(cast(arr as myarray))) order by 1;
return res;
end;
/
select array_to_string(sort_array(cast(array['bbb','ccc','aaa','bbb'] as myarray)),';') from dual;

create or replace function sort_string(str_input varchar, c varchar) return varchar
is 
arr myarray := myarray();
begin
select distinct * bulk collect into arr from (
select * from table(cast(string_to_array(str_input,c) as myarray))) order by 1;
return array_to_string(arr,c);
end;
/
select sort_string('def;abc;efg',';') from dual;

create or replace function equal_any(var varchar, arr myarray) return boolean
is
begin
for i in 1..arr.count loop
if(arr(i)=var) then 
    return true;
end if;
end loop;
return false;
end;
/

select 1 from dual where equal_any('abc',cast(array['abcd','def','hij'] as myarray));
select 1 from dual where equal_any('abcd',cast(array['abcd','def','hij'] as myarray));
select 1 from dual where not equal_any('abc',cast(array['abcd','def','hij'] as myarray));
select 1 from dual where not equal_any('abcd',cast(array['abcd','def','hij'] as myarray));

--ultimate goal in NCE-E cicrumstance
select sort_string(array_to_string(cast(arr as myarray),';'),';') from t_pg_arr_string order by id;
insert into t_pg_arr_string values(3,array['abcd','def','hij']),(4,array['hij','def','ab']),(5,array['hhh','def','abc']);
select * from t_pg_arr_string order by id;
--way 1
select id, sort_string(array_to_string(cast(arr as myarray),';'),';') from t_pg_arr_string 
        where 'abc' in (select * from table(cast(arr as myarray)))
        order by id;
--way 2
select id, array_to_string(sort_array(cast(arr as myarray)),';') from t_pg_arr_string 
        where 'abc' in (select * from table(cast(arr as myarray)))
        order by id;
--way 3
select id, sort_string(array_to_string(cast(arr as myarray),';'),';') from t_pg_arr_string 
        where equal_any('abc', cast(arr as myarray))
        order by id;
--way 4
select id, array_to_string(sort_array(cast(arr as myarray)),';') from t_pg_arr_string 
        where equal_any('abc', cast(arr as myarray))
        order by id;
        
--modify by DTS
create table t1(a number(10,1)[]);
insert into t1 values(array[1,2,3]);
insert into t1 values(array[1.1,2.2,3.3]);
select * from t1;
create type myarr is table of number(10,1);
/
select * from table(cast(array[1,2,3] as myarr));
select * from table(cast(array[1.1,2.2,3.3] as myarr));

create or replace function array2_to_string(arr myarr, c varchar) return varchar
is
res varchar(1000);
arr_c int := arr.count;
begin
for i in 1..arr_c-1 loop
res :=res||arr(i)||c;
end loop;
res :=res||arr(arr_c);
return res;
end;
/
select array2_to_string(cast(a as myarr),';') from t1;

--DTS, during exec should check value from param, otherwise it will core
create or replace type a_type is varray(100) of varchar(100);
/
create or replace type b_type is varray(100) of number;
/
create table t_pg_arr_string(id int[]);
declare
 a int;
 b b_type;
begin
 select *  bulk collect into b from  table(cast(a as a_type));
end;
/
declare
 a t_pg_arr_string.id%type;
 b b_type;
begin
 select *  bulk collect into b from  table(cast(a as a_type));
end;
/
declare
 a int[];
 b b_type;
begin
 select *  bulk collect into b from  table(cast(a as a_type));
end;
/
declare
 a int[] := array[1,2,3];
 b b_type;
begin
 select * bulk collect into b from  table(cast(a as a_type));
 dbe_output.print_line(b(1));
end;
/



conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_array2udt cascade;