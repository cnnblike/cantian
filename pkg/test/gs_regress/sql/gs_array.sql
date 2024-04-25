-- create table with array field
ALTER SESSION SET TIME_ZONE='+08:00';

drop table if exists array_test_1;
drop table if exists array_test_2;
drop table if exists array_test_3;
drop table if exists array_test_4;
create table array_test_1 (
    f1 integer[10],
    f2 binary_uint32[],
    f3 bigint[],
    f4 binary_double[],
    f5 double[],
    f6 float[],
    f7 real[],
    f8 number(12,3)[],
    f9 decimal(20,5)[],
    f10 char(30)[],
    f11 nchar(30)[],
    f12 varchar(30)[],
    f13 nvarchar(30)[],
    f14 date[],
    f15 datetime[],
    f16 timestamp[],
    f17 timestamp(3) with time zone[],
    f18 timestamp(3) with local time zone[],
    f19 boolean[],
    f20 interval year(4) to month[],
    f21 interval day(7) to second(6)[],
    f22 integer
);
desc array_test_1

-- create table as select clause
create table array_test_2 as (select array[1,2,3]::int[] as f1 from dual);
desc array_test_2
select * from array_test_2;

create table array_test_3 as (select array[1,2,3] as f1 from dual); -- error
desc array_test_3

create table array_test_4 as (select * from array_test_1);
desc array_test_4
select * from array_test_4;

drop table if exists t_test_array_008;
drop table if exists t_test_array_base;
create table t_test_array_base (id int[]);
insert into t_test_array_base values(array[1,2,2]);
insert into t_test_array_base values(array[5,3,2]);
commit;

create table t_test_array_008(c) as
    select id[3] from t_test_array_base union all select id[3] from t_test_array_base order by 1;
desc t_test_array_008

drop table if exists t_test_array_base2;
drop table if exists t_test_array_030;
create table t_test_array_base2(id int, id2 decimal(20,5), id3 int[], C_VCHAR varchar(100));
insert into t_test_array_base2 values(1,1234567.12345,array[1,2], 'aabbaaaaaaa');
create table t_test_array_030 as select array_agg(C_VCHAR||C_VCHAR||C_VCHAR) C_VCHAR from t_test_array_base2;
desc -q select array_agg(id) from t_test_array_base2;
desc -q select array_agg(id2) from t_test_array_base2;
desc t_test_array_030;

-- expect failed when use data type unsupported for array
drop table if exists array_test_5;
create table array_test_5 (
    f1 clob[]
);

create table array_test_5 (
    f1 blob[]
);

create table array_test_5 (
    f1 image[]
);

create table array_test_5 (
    f1 abc[]
);

create table array_test_5 (
    f1 binary(20)[]
);

create table array_test_5 (
    f1 varbinary(20)[]
);

-- can not create index/primary key/unique/references key on column with array type
create index ix_array_test_1 on array_test_1 (f1);
alter table array_test_1 add constraint abc primary key(f1);
alter table array_test_1 add constraint abc unique(f1);
create table array_test_5 (f1 int[] primary key);
drop table if exists array_test_6;
drop table if exists array_test_7;
drop table if exists array_test_8;
drop table if exists array_test_9;
create table array_test_6 (c1 int, c2 int[]);
create table array_test_7 (c1 int, c2 int[]);
-- alter table add primary/references/unique constraint
alter table array_test_6 add constraint pk_a primary key(c1);
alter table array_test_6 add foreign key (c2) references array_test_7(c1);
create table array_test_8 (c1 int[] references array_test_6(c1)); -- error
alter table array_test_7  add constraint fk_a_b1 foreign key (c2) references array_test_6 (c1); --error
 -- outline primary/references key
create table array_test_9(c1 int, c2 int[], primary key(c2));
create table array_test_9(c1 int, c2 int[], foreign key (c2) references array_test_6(c1));
create table array_test_9(c1 int, c2 int[], foreign key (c1) references array_test_6(c2));
create table array_test_9(c1, c2 references array_test_6(c1)) as select c1, c2 from array_test_7;

-- can not include array type columns in non-heap table
drop table if exists array_test_022;
create global TEMPORARY table array_test_022 (
    COL1 CHAR(200),
    COL2 VARCHAR(30),
    COL3 VARCHAR(8000)[],
    COL4 NCHAR(90)[20],
    COL5 NVARCHAR(200)[2147483647]
);

-- can not set default value for array column
create table t_test_array_017(c1 int default 2, c2 int[] default 2);
create table t_test_array_018(c1 int, c2 int[] default array[2]);

-- can not modify column to array type
alter table array_test_1 modify (f1 varchar(30)[]);
alter table array_test_1 modify (f1 integer);
alter table array_test_1 modify (f1 char(30));
alter table array_test_1 modify (f22 integer[]);
alter table array_test_1 modify (f22 varchar(30)[]);

--DTS2020020504429
select array[:] from dual;
-- add array type columns
drop table if exists array_test_015;
create table array_test_015 (
    COL1 CHAR(200)[],
    COL2 VARCHAR(2000)[],
    COL3 NCHAR(9)[20],
    COL4 INT[],
    COL5 BIGINT[],
    COL6 BIGINT SIGNED[],
    COL7 REAL[],
    COL8 BINARY_DOUBLE[],
    COL9 DECIMAL[],
    COL10 DATE[],
    COL11 TIMESTAMP(6)[],
    COL12 INTERVAL YEAR(4) TO MONTH[],
    COL13 INTERVAL DAY(7) TO SECOND (6)[],
    COL14 BOOL
);

alter table array_test_015 add COLUMN COL15 VARCHAR(2000)[767];
alter table array_test_015 add (COL16 int AUTO_INCREMENT unique,COL17 DECIMAL[]);
desc array_test_015
insert into array_test_015 (col15, col17) values (array['abc', 'def'], array[1,3]);
select col15, col17 from array_test_015 where col15 regexp 'abc';
select col15, col17 from array_test_015 where col15 regexp 'def';
select col15, col17 from array_test_015 where col15 regexp 'abc,def';
select col15, col17 from array_test_015 where col15 regexp 'abc def';
select col15, col17 from array_test_015 where regexp_like(col15, 'abc');
select col15, col17 from array_test_015 where regexp_like(col15, 'abc,def');
select col15, col17 from array_test_015 where regexp_like(col15, 'abc def');
select col15, col17 from array_test_015 where col15 like '{abc%';
select col15, col17 from array_test_015;
alter table array_test_015 add col17 int[] default 10;

-- array type expression test
select array[] from dual;
select array[1] from dual;
select array[1,] from dual;
select array[,1] from dual;
select array[,1,] from dual;
select array[1,2] from dual;
select array[null,1,2] from dual;
select array[1,2,null] from dual;
select array[null,1,2,null] from dual;
select array[null,null,null] from dual;
select array[] from dual;
select array['abc', ''def', '''] from dual; -- error
select array['abc', 'def'abc, ''''] from dual; --error
select array['abc', 'def'', '''] from dual;
select array['abc', 'def', ''''] from dual;
select array['abc', 'def,ghi', ''''] from dual;
select array['abc', "abc", '\"'] from dual;
select array['abc', '""'] from dual;
select array['abc', '"abc"'] from dual;
select case when cast('{1,2,3}' as int[]) is not null then array[1,2] else array[]::int[] end from dual;

drop table if exists t2;
create table t2 (f1 int, f2 int);
insert into t2 values (1,2),(1,1),(1,3),(2,4),(2,10),(4,100);
select decode(f1, 1, case when cast('{1,2,3}' as int[]) is not null then array[1,2,3] else '{1,2,3,4}' end, '2', '{1,3}', '{2,5}') from t2;
select decode(f1, 1, case when cast('{1,2,3}' as int[]) is null then array[1,2,3] else '{1,2,3,4}' end, '2', '{1,3}', '{2,5}') from t2;

-- select operation from array type table field
insert into array_test_1 values (
    array[1, '2'::integer, null],
    array[null, '2'::binary_uint32],
    '{null,1,2,3,null}',
    array[1.23, 3.2123, null, 0],
    array[null, '1.23', 3.2123, null],
    array[null, '1.23', 3.2123, null],
    array[null, '1.23', 3.2123, null],
    array[null, '1234567.89', 1234567.89, null],
    array[1234567.12345, '1234567.89', 1234567.89, null],
    array['abc', 'def', 'abc''def', null],
    array[],
    '{}',
    array['abc', 'def', 'abc''def', null],
    array[null, '0001-01-01 00:00:00', '9999-12-31 23:59:59', null],
    array['0001-01-01 00:00:00', null, '9999-12-31 23:59:59', null],
    array['0001-01-01 00:00:00.000000', null, '9999-12-31 23:59:59.999999', null],
    array['2019-06-15 14:36:25.046731'],
    array['2019-06-15 14:36:25.046731'],
    array[true, false, 1::bool, 0::bool, null],
    array['-9999-11', '+9999-11', null],
    array['-P99DT655M999.99999S', '1231 12:3:4.1234', 'P1231DT16H3.3333333S', '-0 00:19:7.7777777777', '-1234 0:0:0.0004', 'PT12H', null],
    1
);

select * from array_test_1;
select f21 from array_test_1;
select f22[1] from array_test_1;
select f21[0] from array_test_1;
select f21[1] from array_test_1;
select f21[1000] from array_test_1;
select f21[1:1000] from array_test_1;
select f21[1:2] from array_test_1;
select f21[2:4] from array_test_1;
select f1[1], f21[2:4] from array_test_1 where f1[1] = 1;
select f1[1], f21[2:4] from array_test_1 where f1[1] != 1;
select f1[3], f21[2:4] from array_test_1 where f1[3] is null;
select f1[3], f21[2:4] from array_test_1 where f1[3] is not null;
select f21[2:4]::varchar(3) from array_test_1;
select f21[2:4]::int from array_test_1;
select f1[1] + 3, f21[2:4] from array_test_1 where f1[1] = 1;
select * from (select f1[1] + 3, f21[2:4] from array_test_1 where f1[1] = 1);
select f1[1] from array_test_1 where array[] is null; -- no rows
with a as (select f1 from array_test_2) select f1 from a;
with a as (select f1::varchar(10)[] b from array_test_2) select b from a;
-- union all/minus
select array[] from dual union all select '{1,2,3}' from dual;
select array[] from dual union all select '{1,2,3}'::int[] from dual;
select '{1,2,3}' from dual union all select array[] from dual;
select '{1,2,3}'::int[] from dual union all select array[] from dual;
select array[] from dual union all select array_agg(f2) from t2 group by f1;
select array_agg(f2) from t2 group by f1 union all select array[] from dual;

drop table if exists t_test_array_base;
create table t_test_array_base (id int,c_int int[],c_bigint bigint[],c_varchar varchar(200)[],c_char char(5)[],c_bool bool[],c_date date[],c_iym interval year to month[]);
insert into t_test_array_base values(2,array[1,2,null,10,11],array[1001,1002,1003,null,1004],array['abce','efgg','1233'],array['abcc','efgf','1233'],array[TRUE,FALSE,'f','t'],array['2013-10-01 10:10:10','2014-10-01 10:10:10'],array['50-0']);
insert into t_test_array_base values(2,array[1,2,2,10],array[2001,2002,1003,null,1004],array['abc','efg','123'],array['abc','efg','123'],array[TRUE,FALSE,'f','t'],array['2011-10-01 10:10:10','2012-10-01 10:10:10'],array['60-0']);
insert into t_test_array_base values(2,array[1,2,2,10],array[2001,2002,1003,null,1004],array['abc','efg','123'],array['abc','efg','123'],array[TRUE,FALSE,'f','t'],array['2011-10-01 10:10:10','2012-10-01 10:10:10'],array['60-0']);
commit;

select t1.c_int[1] from t_test_array_base t1 union all select t1.c_int from t_test_array_base t1;
select t1.c_int from t_test_array_base t1 union all select t1.c_int[1] from t_test_array_base t1;

-- not support union
select array_agg(f2) from t2 group by f1 union select array[1,2,3] from dual;
select * from ( select array[1,2] c_int from dual union all select array['abc','feg']::varchar(15) from dual) order by 1;

-- not supported: group by expression(array type)
select f1 from array_test_1 group by f1;
select f1 from array_test_1 group by array[1,2];
select f1 from t2 group by array_agg(f2);

-- not supported: order by expression(array type)
select f1 from array_test_1 order by f1;
select f1 from array_test_1 order by array[1,2];
select f1 from array_test_1 order by '{1}';
select f1 from t2 order by array_agg(f2);
select f1 from array_test_1 order by '{1}'::int[];

drop table if exists orderby_array;
create table orderby_array (id int[],id1 bigint[],id3 varchar(20));
insert into orderby_array values(array[1,2,2],array[111,222,333],'jsfwo');
commit;
select id[3] a from orderby_array order by 1;
select id[3] a from orderby_array order by a;
select id[3] a from orderby_array order by id[3];
select id a from orderby_array order by a;
select id[1:2] a from orderby_array order by a;

-- update operation for array type table field
update array_test_1 set f1[-1] = 1;
update array_test_1 set f1[0] = 1;
update array_test_1 set f1[1:1] = 1;
update array_test_1 set f1[1:2] = '{1,2,3}';
update array_test_1 set f1[1:2] = '{1}';

update array_test_1 set f11 = array['abc', 'def', 1, 1.2324];
select f11 from array_test_1;
update array_test_1 set f11 = array['abc', 'def', 1, 1.2324]::varchar(5)[];
select f11 from array_test_1;
update array_test_1 set f11 = '{abc, def, 1, 1.2324}';
select f11 from array_test_1;

update array_test_1 set f12[1] = 'abc';
update array_test_1 set f12[6] = 123;
update array_test_1 set f12[2] = 'def';
update array_test_1 set f12[2:3] = '{ghi, ddd}';
update array_test_1 set f12[4] = 'kkk';
select f12 from array_test_1;
update array_test_1 set f12 = null;
select f12 from array_test_1;
update array_test_1 set f12[1] = null;

update array_test_1 set f1[1] = 2;
select f1[1] from array_test_1;
update array_test_1 set f1[3] = 3;
select f1[1] from array_test_1;
update array_test_1 set f1[100] = 100;
select f1 from array_test_1;
update array_test_1 set f1[101] = null;
select f1 from array_test_1;

update array_test_1 set f1[1:2] = '{100, 200}';
update array_test_1 set f10[1:2] = array['abc', 123];
update array_test_1 set f21[1] = '-0 00:19:7.7777777777';
select f1, f10, f21 from array_test_1;

-- update set col = select clause
update array_test_1 set f17[1] = (select '2019-06-16 15:36:25.046723' from dual);
update array_test_1 set f17[1:2] = (select '2019-06-16 15:36:25.046723' from dual);
update array_test_1 set f17[1:2] = (select '{2019-06-16 15:36:25.046723, 2019-06-16 15:52:25.332612}' from dual);
update array_test_1 set f17[3] = (select null from dual);

update array_test_1 set f17[4] = (select '2019-08-16 15:36:25.046723' from dual) where f17[1] = '2019-06-16 15:36:25.046723';
update array_test_1 set f17[4] = (select '2019-08-16 15:36:25.046723' from dual) where f17[1] = '2019-06-16 15:36:25.047';
select f17 from array_test_1;

-- insert operation for array type table field
insert into array_test_1(f1, f2, f22) values (array[11,2], '{100,200}', 2);
insert into array_test_1(f1, f2, f22) values (array[100,1000], null, null);
insert into array_test_1(f1, f2, f22) values (array[11,2], null, 3);

insert into array_test_1 
    select array[1, '2'::integer, null],
        array[null, '2'::binary_uint32],
        '{null,1,2,3,null}',
        array[1.23, 3.2123, null, 0],
        array[null, '1.23', 3.2123, null],
        array[null, '1.23', 3.2123, null],
        array[null, '1.23', 3.2123, null],
        array[null, '1234567.89', 1234567.89, null],
        array[1234567.12345, '1234567.89', 1234567.89, null],
        array['abc', 'def', 'abc''def', null],
        array[],
        '{}',
        array['abc', 'def', 'abc''def', null],
        array[null, '0001-01-01 00:00:00', '9999-12-31 23:59:59', null],
        array['0001-01-01 00:00:00', null, '9999-12-31 23:59:59', null],
        array['0001-01-01 00:00:00.000000', null, '9999-12-31 23:59:59.999999', null],
        array['2019-06-15 14:36:25.046731'],
        array['2019-06-15 14:36:25.046731'],
        array[true, false, 1::boolean, 0::boolean, null],
        array['-9999-11', '+9999-11', null],
        array['-P99DT655M999.99999S', '1231 12:3:4.1234', 'P1231DT16H3.3333333S', '-0 00:19:7.7777777777', '-1234 0:0:0.0004', 'PT12H', null],
        5
            from dual;

select * from array_test_1;

-- related array functions test
-- array_length(array express), arguments can be column, constant expression, variant array expression
-- constant expression as arguments
SELECT array_length(null) FROM dual;
select array_length(1) from dual;
select array_length('abc') from dual;
select array_length('{112,3,4') from dual;
select array_length('{112,3,4}') from dual;
select array_length(array[112,3,4]) from dual;
select array_length('{}') from dual;
select array_length(array[]) from dual;
select array_length('{1,2,3,4,1930,3023,111}'::int[]) from dual;
select array_length('{1,2,3,4,1930,3023,111}'::varchar(30)[]) from dual;

-- column as arguments
delete from array_test_2;
select array_length(a.f1) from array_test_2 a;
insert into array_test_2 values ('{1,2,null,4}'), (array[null, null, null]), ('{null,null,null,4}');
select array_length(f1) from array_test_2 a;
with a as (select f1 from array_test_2) select array_length(f1) from a;

-- variant array expression
update array_test_1 set f1[1] = 1;
select f1[1] + 3, array_length(f21[2:4]) from array_test_1 where f1[1] = 1;
select array_length(array_agg(f22)) from array_test_1;

-- array_agg()
select array_agg((select 1 from dual)) from dual;
select array_agg((select 'abc' from dual)) from dual;
desc -q select array_agg((select 'abc' from dual)) from dual;
select array_agg((select array[1,2] from dual)) from dual;
select array_agg((select 'abc'::clob from dual)) from dual;
select array_agg((select 'abc'::image from dual)) from dual;
select array_agg((select 'abc'::blob from dual)) from dual;

drop table if exists t2;
create table t2 (f1 int, f2 int);
insert into t2 values (1,1), (1,2), (1,3), (2, 100), (2,200), (2, 300), (3, 500), (3,600);

select array_agg(f2) from t2;
select array_agg(f2) from t2 group by f1;
select array_agg(f2) from t2 group by f1 order by f1;
select * from (select array_agg(f2) from t2 group by f1 order by f1);

drop table if exists t_test_array_base2;
drop table if exists t_test_array_027;
create table t_test_array_base2(id int,c_long clob);
insert into t_test_array_base2 values(1,lpad('11100011',50,'1100'));
insert into t_test_array_base2 values(2,lpad('11100011',51,'1100'));
create table t_test_array_027 as select array_agg(c_long) c_long from t_test_array_base2;

drop table if exists t_test_array_base;
create table t_test_array_base (id int,c_int int[],c_bigint bigint[],c_varchar varchar(20)[],c_char char(5)[],c_bool bool[],c_date date[],c_iym interval year to month[]);
insert into t_test_array_base values(2,array[1,2,null,10,11],array[1001,1002,1003,null,1004],array['abce','efgg','1233'],array['abcc','efgf','1233'],array[TRUE,FALSE,'f','t'],array['2013-10-01 10:10:10','2014-10-01 10:10:10'],array['50-0']);
select array_agg(id+id+power(id,id)) from t_test_array_base;
insert into t_test_array_base (id) values (1),(2),(3),(4),(4),(3),(0);
select array_agg(id+id+power(id,id)) from t_test_array_base group by id order by id;

-- pl/function use array type as arguments and return value
set serveroutput on

CREATE OR REPLACE PROCEDURE PLSQL_Zenith_Test_005 (param1 in int[])
IS
    tmp varchar2(1000) :='';
begin
    tmp := param1[2];
    dbe_output.print_line(tmp);
end;
/

call PLSQL_Zenith_Test_005(array[1,2]);

create or replace function plsql_ztest_f1(a int[], b varchar2)
return int[]
as
c int[];
begin
  c := a[1:2];
  return c;
end plsql_ztest_f1;
/

select plsql_ztest_f1(array[1,2,3], 'abc') from dual;

create or replace function plsql_ztest_f2(a int[], b varchar2)
return int[]
as
c int[];
begin
  c := array[1,2,3,4,5];
  return c;
end plsql_ztest_f2;
/

declare
    c int[];
begin
    select plsql_ztest_f1(array[1,2,3], 'abc') into c from dual;
    dbe_output.print_line(c);
end;
/

declare
    c int[];
begin
    select plsql_ztest_f2(array[1,2,3], 'abc') into c from dual;
    dbe_output.print_line(c);
end;
/

declare
    c int[];
begin
    select array_agg(f2) into c from t2 group by f1 order by f1 limit 1;
    dbe_output.print_line(c);
end;
/

declare
    c int[];
begin
    begin
        select array_agg(f2) into c from t2 group by f1 order by f1 limit 1;
        dbe_output.print_line(c);
    end;
end;
/

set serveroutput off
drop table if exists array_test_1;
drop table if exists array_test_2;
drop table if exists array_test_3;
drop table if exists array_test_4;
drop table if exists array_test_5;

create table array_test_5 (a number(12,3)[]);
insert into array_test_5 values('{null,1234567.89,1234567.89,null}');
insert into array_test_5 values(array[null, '1234567.89', 1234567.89, null]);
select * from array_test_5;
select array[null, '1234567.89', 1234567.89, null]::number(12,1)[] from dual;

drop table if exists array_test_004_06;
create table array_test_004_06 (COL30 BOOL[]);
insert into array_test_004_06 values(array[1,0,'TRUE']); -- report error
insert into array_test_004_06 values(array['1',0,'TRUE', false]); -- ok
update array_test_004_06 set COL30[324346] = 0;
select COL30[324346] from array_test_004_06;
update array_test_004_06 set COL30[324346] = 1;
select COL30[324346] from array_test_004_06;
update array_test_004_06 set COL30[1:4] = array['1', 0, 'TRUE', false];
select COL30[1:4] from array_test_004_06;
update array_test_004_06 set COL30[1:1] = array['FALSE'];
select COL30[1:4] from array_test_004_06;
update array_test_004_06 set COL30[2:3] = array['TRUE', '0'];
select COL30[1:4] from array_test_004_06;

DROP TABLE IF EXISTS t_varray_datatype1;
create table t_varray_datatype1(
 f12 varchar(30)[]
);
insert into t_varray_datatype1 values('{DDDDDDDDDDDDDDDDDDDDDDDD}');
update t_varray_datatype1 set f12[1223232]='DDDDDDDDDDDDDDDDDDDDDDDDDDWEQWQEWQDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD';
insert into t_varray_datatype1 (f12) values ('{DDDDDDDDDDDDDDDDDDDDDDDDDDWEQWQEWQDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD}');
commit;
select f12[1223232] from t_varray_datatype1;

drop table if exists SELECT_ARRAY_002;
create table SELECT_ARRAY_002 (id int[]);
insert into SELECT_ARRAY_002 values(array[1,2,2]);
insert into SELECT_ARRAY_002 values(array[5,3,2]);
commit;
select id[3] from SELECT_ARRAY_002;
select distinct id[3] from SELECT_ARRAY_002;

drop table if exists array_test_029_1;
create table array_test_029_1 (COL1 BIGINT[]);
insert into array_test_029_1 values(array[2,0,2147483648]);
select * from array_test_029_1;

drop table if exists t_test_array_base;
create table t_test_array_base (id int,c_int int[],c_bigint bigint[],c_varchar varchar(20)[],c_char char(5)[],c_bool bool[],c_date date[],c_iym interval year to month[]);
insert into t_test_array_base values(2,array[1,2,null,10,11],array[1001,1002,1003,null,1004],array['abce','efgg','1233'],array['abcc','efgf','1233'],array[TRUE,FALSE,'f','t'],array['2013-10-01 10:10:10','2014-10-01 10:10:10'],array['50-0']);
select 2 from t_test_array_base t1 for update of t1.c_int; --ok 
select 2 from t_test_array_base t1 order by 1 for update of t1.c_int;  --err

drop table if exists ARRAY_TAB_001;
create table ARRAY_TAB_001 (
    f1 integer[10]
);
insert into ARRAY_TAB_001 values ('{10}');

create or replace procedure ARRAY_PRO_001 (ARRAY_C integer)
as
    ARRAY_A integer[] :=array[1,2,3,4,5,6,7,8,9,10];
begin
    for i in 1 .. ARRAY_C loop
        update ARRAY_TAB_001 set f1 = ARRAY_A where f1[1] = i;
    end loop;
end;
/

call ARRAY_PRO_001(11);
select f1 from ARRAY_TAB_001;

set serveroutput on;
drop table if exists array_test_034;
create table array_test_034 (COL1 int,COL2 INTERVAL YEAR TO MONTH[],COL3 number[]);
insert into array_test_034 values(1,array[(INTERVAL '12' YEAR(4)) , (INTERVAL '-99' YEAR(3)) , (INTERVAL '0' YEAR(2))],array[-0.9E128 , 1.0E126 -1 , -89.0000001]);
insert into array_test_034 values(2,array[(INTERVAL '12' YEAR(4)) , (INTERVAL '-99' YEAR(3)) , (INTERVAL '0' YEAR(2))],array[-1.0E127 , 1.0E28 , -1-128]);
commit;

CREATE OR REPLACE PROCEDURE PROC_ARRAY_TEST_005(P1 out real )
AS
V1 real;
BEGIN
	select COL3[2] into V1 from array_test_034 where COL1 = 2;
	P1:= V1;
	dbe_output.print_line(P1);
EXCEPTION WHEN NO_DATA_FOUND THEN dbe_output.print_line('NO_DATA_FOUND');
END;
/

declare
  p real;
begin
    begin PROC_ARRAY_TEST_005(p); end;
end;
/

drop table if exists array_test_034;
create table array_test_034 (COL1 int,COL2 INTERVAL YEAR TO MONTH[],COL3 number2[]);
insert into array_test_034 values(1,array[(INTERVAL '12' YEAR(4)) , (INTERVAL '-99' YEAR(3)) , (INTERVAL '0' YEAR(2))],array[-0.9E128 , 1.0E126 -1 , -89.0000001]);
insert into array_test_034 values(1,array[(INTERVAL '12' YEAR(4)) , (INTERVAL '-99' YEAR(3)) , (INTERVAL '0' YEAR(2))],array[-0.9E126 , 1.0E125 -1 , -89.0000001]);
insert into array_test_034 values(2,array[(INTERVAL '12' YEAR(4)) , (INTERVAL '-99' YEAR(3)) , (INTERVAL '0' YEAR(2))],array[-1.0E125 , 1.0E26 , -1E-131]);

commit;

CREATE OR REPLACE PROCEDURE PROC_ARRAY_TEST_005(P1 out real )
AS
V1 real;
BEGIN
	select COL3[3] into V1 from array_test_034 where COL1 = 2;
	P1:= V1;
EXCEPTION WHEN NO_DATA_FOUND THEN dbe_output.print_line('NO_DATA_FOUND');
END;
/

declare
  p real;
begin
    PROC_ARRAY_TEST_005(p);
    dbe_output.print_line(P);
end;
/
drop table if exists array_test_034;

-- DTS2019062205948
drop table if exists test1;
create table  test1 (c1 int,c2 int[] );
commit;
insert into  test1 values(123, NULL);
insert into  test1 values(123, array[NULL]);
insert into  test1 values(123, array[NULL]);
insert into  test1 values(123, array[NULL]);
insert into  test1 values(123, array[NULL]);
insert into  test1 values(123, array[NULL]);
insert into  test1 values(123, NULL);
insert into  test1 values(123, NULL);
insert into  test1 values(123, NULL);
select * from test1;

-- DTS2019062507230
drop table if exists t_test_array_base;
create table t_test_array_base (id int,c_int int[],c_bigint bigint[],c_varchar varchar(200)[],c_char char(5)[],c_bool bool[],c_date date[],c_iym interval year to month[]);
insert into t_test_array_base values(2,array[1,2,null,10,11],array[1001,1002,1003,null,1004],array['abce','efgg','1233'],array['abcc','efgf','1233'],array[TRUE,FALSE,'f','t'],array['2013-10-01 10:10:10','2014-10-01 10:10:10'],array['50-0']);
insert into t_test_array_base values(2,array[1,2,2,10],array[2001,2002,1003,null,1004],array['abc','efg','123'],array['abc','efg','123'],array[TRUE,FALSE,'f','t'],array['2011-10-01 10:10:10','2012-10-01 10:10:10'],array['60-0']);
insert into t_test_array_base values(2,array[1,2,2,10],array[2001,2002,1003,null,1004],array['abc','efg','123'],array['abc','efg','123'],array[TRUE,FALSE,'f','t'],array['2011-10-01 10:10:10','2012-10-01 10:10:10'],array['60-0']);
commit;

drop table if exists t_test_array_base2;
create table t_test_array_base2(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(100),c_vchar2 varchar2(100),c_clob clob,
c_long clob,c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp)
PARTITION BY RANGE(id)
(
PARTITION id1 VALUES LESS than(10),
PARTITION id2 VALUES LESS than(100),
PARTITION id3 VALUES LESS than(1000),
PARTITION id4 VALUES LESS than(MAXVALUE)
);
insert into t_test_array_base2 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-01-01 10:51:47.123456'),'yyyy-mm-dd hh24:mi:ss.FF6'));
insert into t_test_array_base2 values(0,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
        
        sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_real+'||i||',c_float+'||i||',c_decimal+'||i||',c_number+'||i||',c_char'||',c_vchar||'||i||',c_vchar2||'||i||',c_clob||'||i||',c_long||'||i||',c_blob'||',c_raw,c_date+TO_DSINTERVAL('''||i|| ' 00:00:00'''||'),c_timestamp+TO_DSINTERVAL('''||i|| ' 00:00:00'''||') from '||tname|| ' where id=1';
        --dbe_output.print_line(sqlst);
        execute immediate sqlst;
  END LOOP;
END;
/
 
exec proc_insert('t_test_array_base2',1,2000);
commit;

insert into t_test_array_base(c_varchar) select array_agg(c_vchar2||c_vchar2) from t_test_array_base2;
insert into t_test_array_base(c_varchar) select array_agg(c_vchar2||c_vchar2) from t_test_array_base2;
insert into t_test_array_base(c_varchar) select array_agg(c_vchar2||c_vchar2) from t_test_array_base2;
insert into t_test_array_base(c_varchar) select array_agg(c_vchar2||c_vchar2) from t_test_array_base2;
insert into t_test_array_base(c_varchar) select array_agg(c_vchar2||c_vchar2) from t_test_array_base2;
select array_length(c_varchar) from t_test_array_base order by 1;

-- DTS2019062713088
drop table if exists array_test_012_1;
create table array_test_012_1 (COL1 int,COL2 varchar(8000)[] null ,COL3 bigint,COL4 int[]);
insert into array_test_012_1 values(1,null,83678569,array[1234,0.00000001,2147483647]);
insert into array_test_012_1 values(1,array[' ','gdff',null,'12'],83678569,array[1234,0.00000001,2147483647]);
commit;
select * from array_test_012_1 order by col1;

-- DTS2019062700983
drop table if exists t_varray_array_agg;
create table t_varray_array_agg
(
    f1 integer,
    f2 integer,
    f3 varchar(30)
);
insert into t_varray_array_agg values (1,100,'fdfd1'), (1,100,'fdfd'), (2,200,'fdfd'), (2, 220,'fdfd'), (3,300,'fdfd'), (4, 300,'fdfd'), (4, 500,'fdfd'), (5,600,'fdfd');
commit;
select array_agg(f1),array_agg(f2),array_agg(f3) from t_varray_array_agg group by f1 order by f1;
drop table if exists t_varray_array_agg5;
create table t_varray_array_agg5(f int, a int[],b bigint[],c varchar(50)[]);
insert into t_varray_array_agg5 select f1, array_agg(f1),array_agg(f2),array_agg(f3) from t_varray_array_agg group by f1 order by f1;
commit;
select * from t_varray_array_agg5 order by f;

-- DTS2019062700983
drop table if exists t_varray_array_agg;
create table t_varray_array_agg
(
    f1 integer,
    f2 integer,
    f3 varchar(30)
);
insert into t_varray_array_agg values (1,100,'fdfd1'), (1,100,'fdfd'), (2,200,'fdfd'), (2, 220,'fdfd'), (3,300,'fdfd'), (4, 300,'fdfd'), (4, 500,'fdfd'), (5,600,'fdfd');
commit;
select array_agg(f2) from t_varray_array_agg group by f1 order by f1;

drop table if exists t_varray_array_agg5;
create table t_varray_array_agg5(a int, b bigint[]);
insert into t_varray_array_agg5 select f1, array_agg(f2) from t_varray_array_agg group by f1 order by f1;
commit;
select * from t_varray_array_agg5 order by a;

-- DTS2019062700960
drop table if exists select_array_003;
create table select_array_003 (f1 integer, f2 integer, f3 integer[]);
insert into select_array_003 values (1,1,array[1,2]), (1,2,array[4,5,6]), (1,3,array[1,3]),
(2,100,array[2,4]), (2,200,array[6,8]), (2, 300,array[7,9]), (3, 500,array[5,0]),
(3,600,array[9,10]);
commit;
select f3,case when f3[1] = 1 then f3[2] else f3[1] end as a from select_array_003 order by a;

-- DTS2019062608595
drop table if exists select_array_003;
create table select_array_003 (f1 integer, f2 integer, f3 integer[]);
insert into select_array_003 values 
    (1,1,array[1,2]),
    (1,2,array[4,5,6]), 
    (1,3,array[1,3]),
    (2,100,array[2,4]), 
    (2,200,array[6,8]), 
    (2, 300,array[7,9]), 
    (3, 500,array[5,0]),
    (3,600,array[9,10]);
commit;

select f3,case when f3[2] = 3 then f3[2] else array[0,9999,8888] end from SELECT_ARRAY_003;
desc -q select f3,case when f3[2] = 3 then f3[2] else array[0,9999,8888] end from SELECT_ARRAY_003;
desc -q select f3,case when f3[2] = 3 then f3[2]::varchar(30) else array[0,9999,8888] end from SELECT_ARRAY_003;
desc -q select f3,case when f3[2] = 3 then f3[2] else '{0,9999,8888}' end from SELECT_ARRAY_003;

-- DTS2019062602166
drop table if exists t_test_array_base;
create table t_test_array_base (id int,c_int int[],c_bigint bigint[],c_varchar varchar(200)[],c_char char(5)[],c_bool bool[],c_date date[],c_iym interval year to month[]);
insert into t_test_array_base values(2,array[1,2,null,10,11],array[1001,1002,1003,null,1004],array['abce','efgg','1233'],array['abcc','efgf','1233'],array[TRUE,FALSE,'f','t'],array['2013-10-01 10:10:10','2014-10-01 10:10:10'],array['50-0']);
insert into t_test_array_base values(2,array[1,2,2,10],array[2001,2002,1003,null,1004],array['abc','efg','123'],array['abc','efg','123'],array[TRUE,FALSE,'f','t'],array['2011-10-01 10:10:10','2012-10-01 10:10:10'],array['60-0']);
insert into t_test_array_base values(2,array[1,2,2,10],array[2001,2002,1003,null,1004],array['abc','efg','123'],array['abc','efg','123'],array[TRUE,FALSE,'f','t'],array['2011-10-01 10:10:10','2012-10-01 10:10:10'],array['60-0']);
commit;
select max(c_varchar[2]) from t_test_array_base;
select max(c_varchar) from t_test_array_base;
select left(c_varchar, 3) from t_test_array_base;
select upper(c_varchar) from t_test_array_base;
select substr(c_varchar,2) from t_test_array_base;

-- DTS2019062409547
ALTER SYSTEM SET LOCAL_TEMPORARY_TABLE_ENABLED=TRUE;
drop table if exists #array_test_023;
create TEMPORARY table #array_test_023 (
    col0 integer,
    COL1 CHAR(200)[],
    COL2 VARCHAR(2000)[],
    COL3 VARCHAR(8000)[],
    COL4 NCHAR(90)[20],
    COL5 NVARCHAR(200)[2147483647]
); -- report error
alter table #array_test_023 modify (col0 integer); -- report error

drop table if exists t_test_array_base2;
create table t_test_array_base2(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(100),c_vchar2 varchar2(100),c_clob clob,
c_long clob,c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp);
insert into t_test_array_base2 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-01-01 10:51:47.123456'),'yyyy-mm-dd hh24:mi:ss.FF6'));
insert into t_test_array_base2 values(0,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
commit;
CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP

                sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_real+'||i||',c_float+'||i||',c_decimal+'||i||',c_number+'||i||',c_char'||',c_vchar||'||i||',c_vchar2||'||i||',c_clob||'||i||',c_long||'||i||',c_blob'||',c_raw,c_date+TO_DSINTERVAL('''||i|| ' 00:00:00'''||'),c_timestamp+TO_DSINTERVAL('''||i|| ' 00:00:00'''||') from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/

exec proc_insert('t_test_array_base2',1,2000);
insert into t_test_array_base2(c_clob) select to_char(array_agg(c_vchar2)) from t_test_array_base2; -- the length of array can't be more than CT_CONVERT_BUFFER_SIZE for to_char
rollback;
exec proc_insert('t_test_array_base2',1,200);
insert into t_test_array_base2(c_clob) select to_char(array_agg(c_vchar2)) from t_test_array_base2;
drop table t_test_array_base2;

-- DTS2019070301771
drop table if exists t_test_array_base2;
create table t_test_array_base2(id int,c_timestamp timestamp);
insert into t_test_array_base2 values(1,to_timestamp(to_char('1800-01-01 10:51:47.123456'),'yyyy-mm-dd hh24:mi:ss.FF6'));
select c_timestamp,array_agg(c_timestamp) c_timestamp from t_test_array_base2 group by c_timestamp;

-- DTS2019062111454
select array[CAST(-1234.567 AS NUMBER(6, 2)),CAST(-0.001234 AS NUMBER(2,4))] from dual;
select array[TO_DATE('2018-08-08', 'YYYY-MM-DD'),TO_DATE('1990-08-08', 'YYYY-MM-DD')] from dual;
select array[rpad('abc','8000','a@123&^%djgk'),lpad('abc','3000','a@123&^%djgk')] from dual;

-- DTS2019070507999
drop table if exists array_test_009;
create table array_test_009 (f0 int,f1 varchar(8000)[]);

insert into array_test_009 values (0, array['1','jgf''hjgf','"agfdgd"','{}']);
insert into array_test_009 values (4, '{1,jgf''hjgf,[fdab],''}''}');
insert into array_test_009 values (1, array['1','jgf''hjgf','abc','{}']);
insert into array_test_009 values (3, '{1,jgf''hjgf,bdef,''}''}');
insert into array_test_009 values (4, '{1,jgf''hjgf,bdeg,''}''}');
insert into array_test_009 values (3, '{1,jgf''hjgf,bdaf,''}''}');
insert into array_test_009 values (1, '{1,jgf''hjgf,"adb",''{''}');

commit;
select * from array_test_009 order by f0, f1[3];
select f0, f1 from array_test_009 order by f0, f1[3];
select f0, f1[3] from array_test_009 order by 1, 2;

-- DTS2019062203952
select c_int[2] from ( select array[1,2,4,5,6,7] c_int) t;
select a from (select c_int[2] a from ( select array[1,2,4,5,6,7] c_int) t);
select 1 from dual where 1 < (select c_int[2] a from ( select array[1,2,4,5,6,7] c_int) t);
select 1 from dual where 1 in (select c_int[1] a from ( select array[1,2,4,5,6,7] c_int) t);

drop table if exists t_test_array_017;
create table t_test_array_017(c) as select c_int[2] from ( select array[1,2,4,5,6,7] c_int) t;
desc t_test_array_017;

drop table if exists t_test_array_018;
create table t_test_array_018(c) as (select * from (select c_int[2] from ( select array[1,2,4,5,6,7] c_int) t));
desc t_test_array_018;

-- DTS2019062112485
drop table if exists SELECT_ARRAY_003;
CREATE TABLE SELECT_ARRAY_003 (f1 INTEGER, f2 INTEGER, f3 INTEGER[]);
INSERT INTO SELECT_ARRAY_003 VALUES 
    (1,1,array[1,2]),
    (1,2,array[4,5,6]),
    (1,3,array[1,3]),
    (2,100,array[2,4]),
    (2,200,array[6,8]),
    (2, 300,array[7,9]),
    (3, 500,array[5,0]),
    (3,600,array[9,10]);
commit;
drop table if exists SELECT_ARRAY_005;
CREATE TABLE SELECT_ARRAY_005 (f1 INTEGER,f2 INTEGER[]);
INSERT INTO SELECT_ARRAY_005 VALUES 
    (1,array[1,3]), 
    (2,array[4,6]), 
    (3,array[1,3]),
    (4,array[2,4]), 
    (5,array[6,8]), 
    (6,array[8,9]), 
    (7,array[5,0]);
commit;
select t1.f1,t1.f2,t1.f3 from SELECT_ARRAY_003 t1 inner join SELECT_ARRAY_005 t2 on t1.f3[2] = t2.f2[2] order by 1, 2;
select t1.f1,t1.f2,t1.f3[2] from SELECT_ARRAY_003 t1 inner join SELECT_ARRAY_005 t2 on t1.f1 = t2.f1 order by 1, 2, 3;

drop table if exists t_test_array_017;
create table t_test_array_017(col array[int]);

-- DTS2019071910525
drop table if exists t_order_base_000;
drop table if exists gt_order_base_000;
CREATE TABLE t_order_base_000("ID" INT NOT NULL, "CHR_FIELD" VARCHAR(30), "VALUE" NUMBER);
insert into t_order_base_000 select rownum, decode(mod(rownum, 2), 0, NULL, rpad('CHR_', 10, chr(rownum + 64))), decode(mod(rownum, 3), 0, NULL, rownum * 10000) from dual connect by rownum < 6;
insert into t_order_base_000 select rownum + 10, decode(mod(rownum, 2), 0, NULL, rpad('CHR_', 10, chr(rownum + 64))), decode(mod(rownum, 3), 1, NULL, rownum * 10000) from dual connect by rownum < 6;
insert into t_order_base_000 select rownum + 15, decode(mod(rownum, 2), 0, NULL, rpad('CHR_', 10, chr(rownum + 64))), decode(mod(rownum, 3), 2, '', rownum * 10) from dual connect by rownum < 6;
insert into t_order_base_000 select rownum + 15, decode(mod(rownum, 2), 0, NULL, rpad('CHR_', 10, chr(rownum + 64))), decode(mod(rownum, 3), 2, '', rownum * 10) from dual connect by rownum < 6;
commit;

create global temporary table gt_order_base_000 ON COMMIT PRESERVE ROWS as select * from t_order_base_000;

create or replace view v_test_view_002 as select c1,c2 from (select rowid c1,rownum c2,ID,CHR_FIELD,VALUE from gt_order_base_000 union select rowid,rownum,ID,CHR_FIELD,VALUE from t_order_base_000) t2 where exists(select * from gt_order_base_000 where t2.ID in(ID+15)) union select c1,c2 from (select rowid c1,rownum c2,ID,CHR_FIELD,VALUE from gt_order_base_000 union select rowid,rownum,ID,CHR_FIELD,VALUE from t_order_base_000) t2 where exists(select * from gt_order_base_000 where t2.ID in(ID+10));

CREATE OR REPLACE SYNONYM v_test_view_002_sys FOR v_test_view_002;

select t1.c2,t2.c2 from v_test_view_002_sys t1 join v_test_view_002_sys t2 on array_length(array[t1.c2,t2.c2])*3=t1.c2 order by 1,2;

-- DTS2019072316038
drop table if exists t_par_tab_idx_0001;
CREATE TABLE t_par_tab_idx_0001(
    id int,
    c_int int,
    c_int2 int,
    c_int3 int,
    c_vchar varchar(100),
    c_vchar2 varchar(100),
    c_vchar3 varchar(100),
    c_char char(100),
    c_char2 char(100),
    c_char3 char(850),
    c_clob clob,
    c_blob blob,
    c_date date)
PARTITION BY RANGE (c_int)
(
    partition t_par_tab_idx_0001_P_50 values less than (50),
    partition t_par_tab_idx_0001_P_100 values less than (2000),
    partition t_par_tab_idx_0001_P_150 values less than (100000)
);

create index idx_par_tab_idx_0001 on t_par_tab_idx_0001(c_int,c_vchar,c_vchar2) local;
create index idx_par_tab_idx_0002 on t_par_tab_idx_0001(c_int,c_vchar,c_vchar2,c_vchar3);
create index idx_par_tab_idx_0003 on t_par_tab_idx_0001(c_int,c_char,c_vchar,c_char2,c_vchar2,c_char3,c_vchar3);
create index idx_par_tab_idx_1001 on t_par_tab_idx_0001(c_int) CRMODE PAGE local
(
    partition idx_par_tab_idx_0001_P_50,
    partition idx_par_tab_idx_0001_P_100,
    partition idx_par_tab_idx_0001_P_150);

insert into t_par_tab_idx_0001 values(1,
100,110,120,
lpad('123abc',20,'abc'),lpad('11100011',20,'1100'),lpad('21100011',20,'1100'),
lpad('123abc',20,'abc'),lpad('11100011',20,'1100'),lpad('21100011',20,'1100'),
lpad('123abc',20,'abc'),lpad('11100011',20,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));

CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
    sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
        sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_int2+'||i||',c_int2+'||i||',c_vchar||'||i||',c_vchar2||'||i||',c_vchar3||'||i||',c_char'||',c_char2'||',c_char3'||',c_clob||'||i||',c_blob'||',c_date from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/

commit;

exec proc_insert('t_par_tab_idx_0001',1,500);
insert into t_par_tab_idx_0001 select * from t_par_tab_idx_0001;
insert into t_par_tab_idx_0001 select * from t_par_tab_idx_0001;
insert into t_par_tab_idx_0001 select * from t_par_tab_idx_0001;
insert into t_par_tab_idx_0001 select * from t_par_tab_idx_0001;
select count(c_int) from t_par_tab_idx_0001;
select array_agg(c_int) from t_par_tab_idx_0001 order by c_int;

-- test views' columns data type
drop user if exists array_test_user;
create user array_test_user identified by Root1234;
grant connect, resource, create view to array_test_user;
grant select on ADM_TAB_COLS to array_test_user;
grant select on ADM_TAB_COLUMNS to array_test_user;
grant select on ADM_VIEW_COLUMNS to array_test_user;

conn array_test_user/Root1234@127.0.0.1:1611
drop table if exists tab_001;
create table tab_001 (f1 int, f2 int[], f3 varchar(30)[]);
create or replace view view_001 as select * from tab_001;

select column_name, data_type from ADM_TAB_COLS where owner = 'ARRAY_TEST_USER' and table_name = 'TAB_001' order by column_name;
select column_name, data_type from DB_TAB_COLS where owner = 'ARRAY_TEST_USER' and table_name = 'TAB_001' order by column_name;
select column_name, data_type from MY_TAB_COLS where table_name = 'TAB_001' order by column_name;

select column_name, data_type from ADM_TAB_COLUMNS where owner = 'ARRAY_TEST_USER' and table_name = 'TAB_001' order by column_name;
select column_name, data_type from DB_TAB_COLUMNS where owner = 'ARRAY_TEST_USER' and table_name = 'TAB_001' order by column_name;
select column_name, data_type from MY_TAB_COLUMNS where table_name = 'TAB_001' order by column_name;

select column_name, data_type from ADM_VIEW_COLUMNS where owner = 'ARRAY_TEST_USER' and view_name = 'VIEW_001' order by column_name;
select column_name, data_type from DB_VIEW_COLUMNS where owner = 'ARRAY_TEST_USER' and view_name = 'VIEW_001' order by column_name;
select column_name, data_type from MY_VIEW_COLUMNS where view_name = 'VIEW_001' order by column_name;

conn sys/Huawei@123@127.0.0.1:1611
drop user array_test_user cascade;

drop table if exists t_array;
create table t_array(id int);
insert into t_array values (1),(100),(1000);
select case array[1,2] when array_agg(t1.id) then array[1,2] else array[1,2] end c from t_array t1 group by t1.id;

drop table if exists t3;
drop table if exists t4;
create table t3(id int,f1 int[],f2 varchar(30)[],f3 date[]);
insert into t3 values(1,array[1,2,3],array['a','b','c'],array['2019-03-22 12:00:00']);
insert into t3 values(2,array[4,5,6],array['d','e','f'],array['2019-04-22 12:00:00']);
insert into t3 values(3,array[7,8,9],array['g','h','i'],array['2019-05-22 12:00:00']);
create table t4(id int,m1 int[],m2 varchar(30)[],m3 date[]);
insert into t4 values(1,array[1,3,5],array['a','d','c'],array['2019-03-22 12:00:00']);
insert into t4 values(3,array[4,6,5],array['a','d','c'],array['2019-05-22 12:00:00']);
insert into t4 values(5,array[7,8,9],array['a','d','e'],array['2019-07-22 12:00:00']);
select t3.id,t3.f1,t4.m3 from t3 left join t4 on t3.id=t4.id order by t3.id;
select t3.id,t3.f1,t4.m3 from t4 join t3 on t3.id=t4.id order by t3.id;

drop table if exists t_merge_join_explain_1;
drop table if exists t_merge_join_explain_2;

create table t_merge_join_explain_1( 
  COL_1 bigint, 
  COL_2 TIMESTAMP WITHOUT TIME ZONE, 
  COL_3 bool,
  COL_4 text,
  COL_5 char(30),
  COL_6 character varying(30),
  COL_7 char(60),
  COL_8 integer,
  COL_9 interval day to second,
  COL_10 decimal,
  COL_11 TIMESTAMP,
  COL_12 varchar(50),
  COL_13 date,
  COL_14 decimal(12,6),
  COL_15 char(60),
  COL_16 TIMESTAMP,
  COL_17 int[],
  COL_18 integer,
  COL_19 int,
  COL_20 bigint
);

create table t_merge_join_explain_2( 
  COL_1 bigint, 
  COL_2 TIMESTAMP WITHOUT TIME ZONE, 
  COL_3 bool,
  COL_4 text,
  COL_5 char(30),
  COL_6 character varying(30),
  COL_7 char(60),
  COL_8 integer,
  COL_9 interval day to second,
  COL_10 decimal,
  COL_11 TIMESTAMP,
  COL_12 varchar(50),
  COL_13 date,
  COL_14 decimal(12,6),
  COL_15 char(60),
  COL_16 TIMESTAMP,
  COL_17 int[],
  COL_18 integer,
  COL_19 int,
  COL_20 bigint
);

declare
    cnt int;
begin
    for cnt in 1..6 loop
        insert into t_merge_join_explain_1 values(
          1,
          '2019-01-03 14:14:12',
          true,
          lpad('abc','10','a@123&^%djgk'), 
          lpad('abc','30','@'), 
          lpad('abc','30','b'),
          lpad('10','12','01010'),
          12,
          '4 5:12:10.222',
          12+445.255,
          '2019-01-03 14:58:54.000000',      
          rpad('abc','30','e'),
          '2018-11-03 14:14:12',
          98*0.99, 
          rpad('abc','9','a@123&^%djgk'),
          '2019-01-03 14:14:12',
          '{32,535,5645645,6767,76,67,56,48,979,978,7}',
          1+10,
          12+100,
          1-100
        );
        insert into t_merge_join_explain_2 values(
          1,
          '2019-01-03 14:14:12',
          true,
          lpad('abc','10','a@123&^%djgk'), 
          lpad('abc','30','@'), 
          lpad('abc','30','b'),
          lpad('10','12','01010'),
          12,
          '4 5:12:10.222',
          12+445.255,
          '2019-01-03 14:58:54.000000',      
          rpad('abc','30','e'),
          '2018-11-03 14:14:12',
          98*0.99, 
          rpad('abc','9','a@123&^%djgk'),
          '2019-01-03 14:14:12',
          '{32,535,5645645,6767,76,67,56,48,979,978,7}',
          1+10,
          12+100,
          1-100
        );
    end loop;
end;
/

SELECT t2.COL_17[1] FROM t_merge_join_explain_1 t1 JOIN t_merge_join_explain_2 t2 ON t1.COL_8<t2.COL_17[1];
SELECT t2.COL_17 FROM t_merge_join_explain_1 t1 JOIN t_merge_join_explain_2 t2 ON t1.COL_8<t2.COL_17[1];

--DTS2019091211735
drop table if exists t_count_base_001;
create table t_count_base_001(id int,deptno int,name varchar(20),sal int);
insert into t_count_base_001 values(1,1,'1aa',120);
insert into t_count_base_001 values(2,1,'2aa',300);
insert into t_count_base_001 values(3,1,'3aa',100);
insert into t_count_base_001 values(4,1,'4aa',99);
insert into t_count_base_001 values(5,1,'5aa',90);
insert into t_count_base_001 values(6,2,'6aa',87);
insert into t_count_base_001 values(7,2,'7aa',500);
insert into t_count_base_001 values(8,2,'8aa',200);
insert into t_count_base_001 values(9,2,'9aa',20);
insert into t_count_base_001 values(10,2,'10aa',30);
insert into t_count_base_001 values(null,2,'10aa',30);
insert into t_count_base_001 values(12,2,'10aa',null);
commit;

select array[count(sal) over()] c from t_count_base_001;
select count(sal[2]) over(order by sal) c from (select array[sal,sal,sal] sal,deptno,deptno from t_count_base_001) as t order by 1;
--DTS2019103109591
select count(ID) over(partition by array[deptno,2]) c from t_count_base_001 t1 order by 1;
drop table if exists SELECT_ARRAY_003;
CREATE TABLE SELECT_ARRAY_003 (f1 INTEGER, f2 INTEGER, f3 INTEGER[]);
INSERT INTO SELECT_ARRAY_003 VALUES (1,1,array[1,2]), (1,2,array[4,5,6]), (1,3,array[1,3]),
(2,100,array[2,4]), (2,200,array[6,8]), (2, 300,array[7,9]), (3, 500,array[5,0]),
(3,600,array[9,10]);
commit;
select case when f3 = '{2,4}' then 'aa' else 'bb' end from SELECT_ARRAY_003 order by 1;
drop table SELECT_ARRAY_003;
--DTS2019121609705
drop table if exists t_union_all_parallel_001;
create table t_union_all_parallel_001(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10) not null,c_vchar2 varchar2(100),c_clob clob,
c_long varchar(200),c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp);
insert into t_union_all_parallel_001 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));

CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
                sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_real+'||i||',c_float+'||i||',c_decimal+'||i||',c_number+'||i||',c_char'||',c_vchar||'||i||',c_vchar2||'||i||',c_clob||'||i||',c_long||'||i||',c_blob'||',c_raw,ADD_MONTHS(c_date,'||i||'),ADD_MONTHS(c_timestamp,'||i||') from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/
exec proc_insert('t_union_all_parallel_001',1,20);
commit;
select * from (select array[id,c_int] c from  t_union_all_parallel_001 t1 where id<=10 union all select array[id,to_char(c_int)] c from t_union_all_parallel_001 t1 where id<=10) order by c[1];
drop table t_union_all_parallel_001;
--DTS2019121601548
drop table if exists parallelism_selct_t005;
create table parallelism_selct_t005(c1 INT, c14 int[])PARTITION BY RANGE(c1) interval(2)(PARTITION p1 VALUES LESS THAN(3));
insert into parallelism_selct_t005 values(1,array[1,2,3]);
insert into parallelism_selct_t005 values(2,array[1,2,3]);
insert into parallelism_selct_t005 values(3,array[1,2,3]);
select * from parallelism_selct_t005;
drop table parallelism_selct_t005;
--DTS2019110500578
drop table if exists t_merge_join_explain_1;
create table t_merge_join_explain_1( 
COL_1 bigint, 
COL_2 TIMESTAMP WITHOUT TIME ZONE, 
COL_3 bool,
COL_4 text,
COL_5 char(30),
COL_6 character varying(30),
COL_7 blob,
COL_8 integer,
COL_9 interval day to second,
COL_10 double,
COL_11 TIMESTAMP,
COL_12 varchar2(50),
COL_13 date,
COL_14 decimal(12,6),
COL_15 clob,
COL_16 datetime,
COL_17 int[],
COL_18 integer,
COL_19 int,
COL_20 bigint,
constraint merge_join_pk_id1 primary key(COL_1)
);
drop sequence if exists merge_join_seq_1;
create sequence merge_join_seq_1 increment by 1 start with 100000;
truncate table t_merge_join_explain_1;
begin
	for i in 1..60 loop
      insert into t_merge_join_explain_1 values(	  
      merge_join_seq_1.nextval,
	  TIMESTAMPADD(HOUR,i,'2019-01-03 14:14:12'),
	  true,
	  lpad('abc','10','a@123&^%djgk'), 
	  lpad('abc','30','@')	  , 
	  lpad('abc','30','b'),
	  lpad('10','12','01010'),
	  i,
	  (INTERVAL '4 5:12:10.222' DAY TO SECOND(3)),
	  i+445.255,
	  to_timestamp('2019-01-03 14:58:54.000000','YYYY-MM-DD HH24:MI:SS.FFFFFF'),	  
	  rpad('abc','30','e'),
	  TIMESTAMPADD(SECOND,i,'2018-11-03 14:14:12'),
	  98*0.99, 
	  rpad('abc','9','a@123&^%djgk'),
	  TIMESTAMPADD(SECOND,i,'2019-01-03 14:14:12'),
	  '{32,535,5645645,6767,76,67,56,48,979,978,7}',
	  merge_join_seq_1.nextval+10,
	  i+100,
	  merge_join_seq_1.nextval-100
	  );
      commit;
    end loop;
end;
/
drop table if exists t_merge_join_explain_2;
create table t_merge_join_explain_2( 
COL_1 bigint, 
COL_2 TIMESTAMP WITHOUT TIME ZONE, 
COL_3 bool,
COL_4 text,
COL_5 char(30),
COL_6 character varying(30),
COL_7 blob,
COL_8 integer,
COL_9 interval day to second,
COL_10 double,
COL_11 TIMESTAMP,
COL_12 varchar2(50),
COL_13 date,
COL_14 decimal(12,6),
COL_15 clob,
COL_16 datetime,
COL_17 int[],
COL_18 integer,
COL_19 int,
COL_20 bigint,
constraint merge_join_pk_id2 primary key(COL_1)
);
drop sequence if exists merge_join_seq_2;
create sequence merge_join_seq_2 increment by 1 start with 100000;
truncate table t_merge_join_explain_2;
begin
	for i in 1..60 loop
      insert into t_merge_join_explain_2 values(	  
      merge_join_seq_2.nextval,
	  TIMESTAMPADD(HOUR,i,'2019-01-03 14:14:12'),
	  true,
	  lpad('abc','10','a@123&^%djgk'), 
	  lpad('abc','30','@')	  , 
	  lpad('abc','30','b'),
	  lpad('10','12','01010'),
	  i,
	  (INTERVAL '4 5:12:10.222' DAY TO SECOND(3)),
	  i+445.255,
	  to_timestamp('2019-01-03 14:58:54.000000','YYYY-MM-DD HH24:MI:SS.FFFFFF'),	  
	  rpad('abc','30','e'),
	  TIMESTAMPADD(SECOND,i,'2018-11-03 14:14:12'),
	  98*0.99, 
	  rpad('abc','9','a@123&^%djgk'),
	  TIMESTAMPADD(SECOND,i,'2019-01-03 14:14:12'),
	  '{32,535,5645645,6767,76,67,56,48,979,978,7}',
	  merge_join_seq_2.nextval+10,
	  i+100,
	  merge_join_seq_2.nextval-100
	  );
      commit;
    end loop;
end;
/
drop view if exists v_merge_join_explain_1;
drop view if exists v_merge_join_explain_2;
CREATE VIEW v_merge_join_explain_1 AS select * from t_merge_join_explain_1;
CREATE VIEW v_merge_join_explain_2 AS select * from t_merge_join_explain_2;
SELECT t1.COL_8  
    FROM v_merge_join_explain_1 t1
    JOIN v_merge_join_explain_2 t2 
ON abs(ceil(t1.COL_8+50)) > floor(ceil(t2.COL_19)) 
and abs(ceil(t2.COL_18+50)) > ln(floor(ceil(t2.COL_19)))
where t2.COL_17[1]=32 OR t1.COL_14>=98*0.99 
group by t1.COL_8 
having abs(ceil(t1.COL_8+50)) > 10 order by 1;

SELECT t1.COL_8  
    FROM t_merge_join_explain_1 t1
    JOIN t_merge_join_explain_2 t2 
ON abs(ceil(t1.COL_8+50)) > floor(ceil(t2.COL_19)) 
and abs(ceil(t2.COL_18+50)) > ln(floor(ceil(t2.COL_19)))
where t2.COL_17[1]=32 OR t1.COL_14>=98*0.99 
group by t1.COL_8 
having abs(ceil(t1.COL_8+50)) > 10 order by 1;
SELECT t1.COL_8      FROM v_merge_join_explain_1 t1    JOIN v_merge_join_explain_2 t2 where t2.COL_17[1]=32 order by 1 LIMIT 10;
SELECT t1.COL_8      FROM t_merge_join_explain_1 t1    JOIN t_merge_join_explain_2 t2 where t2.COL_17[1]=32 order by 1 LIMIT 1;\
drop sequence merge_join_seq_2;
drop view v_merge_join_explain_1;
drop view v_merge_join_explain_2;
drop table t_merge_join_explain_1;
drop table t_merge_join_explain_2;
--DTS2019122400671
drop table if exists DTS2019122400671_test01;
drop table if exists DTS2019122400671_test02;
create table DTS2019122400671_test01(id int,c_long clob);
create table DTS2019122400671_test02 as select array_agg(c_long) c_long from DTS2019122400671_test01;
drop table DTS2019122400671_test01;
drop table if exists DTS2019122400671_test02;

--DTS2020020704297
drop table if exists t10000_20200207;
create table t10000_20200207(c int,c2 int);
insert into t10000_20200207 values(1,2);
insert into t10000_20200207 values(2,3);
commit;
select prior array[c,c2] from t10000_20200207 connect by nocycle prior c2=c order by c,c2;
drop table t10000_20200207;
-- DTS2020011907113
drop table if exists test_values_t15;
create table test_values_t15 (
  c1 int primary key,
  c2 varchar(100)[],
  c3 varchar(100)[]
);

insert into test_values_t15 values(
-1110001,array['abc','qwerty','tyuiopbn'],array[lpad('a',100,'b'),lpad('a',100,'c'),lpad('a',100,'d'),lpad('a',100,'e')]);


select * from test_values_t15;
insert into test_values_t15 select * from test_values_t15 on duplicate key update c2[2] = values(c3[3]);
select * from test_values_t15;
--20200211
DROP TABLE IF EXISTS T_20200211;
CREATE TABLE T_20200211(F1 VARCHAR(10));
INSERT INTO T_20200211 VALUES(NULL),('A');
COMMIT;
select 'a'||array_agg(f1) from T_20200211 group by f1 ORDER BY 1;
DROP TABLE T_20200211;
--DTS2020032008928	
drop table if exists t_DTS2020032008928_003;
create table t_DTS2020032008928_003(id int,deptno int,name varchar(20),sal int,
id2 int,deptno2 int,name2 varchar(20),sal2 int,
id3 int,deptno3 int,name3 varchar(20),sal3 int,
id4 int,deptno4 int,name4 varchar(20),sal4 int);
insert into t_DTS2020032008928_003 values(1,1,'1aa',120,1,1,'1aa',120,1,1,'1aa',120,1,1,'1aa',120);
insert into t_DTS2020032008928_003 values(2,1,'2aa',300,2,1,'2aa',300,2,1,'2aa',300,2,1,'2aa',300);
insert into t_DTS2020032008928_003 values(3,1,'3aa',100,3,1,'3aa',100,3,1,'3aa',100,3,1,'3aa',100);
insert into t_DTS2020032008928_003 values(7,2,'7aa',500,7,2,'7aa',500,7,2,'7aa',500,7,2,'7aa',500);
insert into t_DTS2020032008928_003 values(8,2,'8aa',200,8,2,'8aa',200,8,2,'8aa',200,8,2,'8aa',200);
insert into t_DTS2020032008928_003 values(9,2,'9aa',20,9,2,'9aa',20,9,2,'9aa',20,9,2,'9aa',20);
insert into t_DTS2020032008928_003 values(null,2,'10aa',30,null,2,'10aa',30,null,2,'10aa',30,null,2,'10aa',30);
commit;
drop table if exists t_DTS2020032008928_004; 
create table t_DTS2020032008928_004 (id int,c1 varchar(8000),c2 varchar(8000),c3 varchar(8000)); 
declare 
begin 
for i in 1..2000 loop 
insert into t_DTS2020032008928_004 values (i,rpad('abc',8000,2),rpad('abc',8000,i),rpad('abc',8000,i)); 
end loop; 
for i in 2001..4000 loop 
insert into t_DTS2020032008928_004 values (i,rpad('abc',8000,2),rpad('abc',8000,2),rpad('abc',8000,i)); 
end loop; 
for i in 4001..8000 loop 
insert into t_DTS2020032008928_004 values (i,rpad('abc',8000,2),rpad('abc',8000,2),rpad('abc',8000,2)); 
end loop; 
end; 
/ 
commit;

drop table t_DTS2020032008928_003;
drop table t_DTS2020032008928_004;

-- test array element cast
drop table if exists tab_array_cast_test;
create table tab_array_cast_test (f1 varchar(30)[]);
insert into tab_array_cast_test values (array['', null, 'abc']);
insert into tab_array_cast_test values ('{'''', null, ''abc''}');
update tab_array_cast_test set f1 = '{'''', null, ''def''}';
select '{'''', null, ''def''}'::varchar(30)[] from dual;

drop table if exists trig_array_test;
create table trig_array_test(f1 int,f2 varchar(20)[],f3 varchar(8000));

CREATE OR REPLACE TRIGGER TRIG_AFTER_INSERT before INSERT or update ON trig_array_test
for each row
declare
	tep varchar(800);
	temp varchar(880)[];
BEGIN
	temp := :new.f2;
	tep := to_char(temp);
	:new.f3 :=tep;
END;
/

insert into trig_array_test values (1, array['abc', 'gdsaf'], '');
select * from trig_array_test;
update trig_array_test set f2 = array['213424'];
select * from trig_array_test;

drop table if exists array_test_041;
CREATE TABLE array_test_041(
  t_id  int primary key,
  t_name VARCHAR2(200)[],
  t_age int[],
  t_sex CHAR(110)[],
  t_address  number[],
  t_email date[],
  t_phonenum real[],
  t_remarks INTERVAL DAY(4) TO SECOND[6]
);
insert into array_test_041 values(1,array['xiaoming','23'],array[1234567.67,12345.4567],array['m','huanpu','@123','1399','none'],array[58814,546223077,1234567.67],array['2012-10-31 10:16:52','2002-08-11','2000-03-01 15:42:21'],array[],array[(INTERVAL '4 5:12:10.222' DAY TO SECOND(3)),(INTERVAL '12 15:12:10.222' DAY TO SECOND(6))]);
commit;

create or replace function FUNC_ARRAY_TEST_001() return date[]
is
V1 date[];
begin
  select t_email into V1 from array_test_041 where t_id=1;
  return V1;
  EXCEPTION
WHEN NO_DATA_FOUND THEN dbe_output.print_line('NO_DATA_FOUND');
end;
/

select FUNC_ARRAY_TEST_001() from sys_dummy;

-- DTS202005270616KSP0G00
drop table if exists t_varray_array_agg;
create table t_varray_array_agg
(
  f1 integer,
  f2 integer,
  f3 varchar(30)
);
insert into t_varray_array_agg values (1,100,'fdfd1'), (1,100,'fdfd'), (2,200,'fdfd'), (2, 220,'fdfd'), (3,300,'fdfd'), (4, 300,'fdfd'), (4, 500,'fdfd'), (5,600,'fdfd');
commit;

select array_agg(f3) from t_varray_array_agg group by f1 union select array_agg(f3) from t_varray_array_agg group by f1;
select array_agg(f3) from t_varray_array_agg group by f1 union select array_agg(f3) from t_varray_array_agg group by f1;
drop table t_varray_array_agg;

drop table if exists t_varray_datatype;
create table t_varray_datatype(
    f1 integer[10],
    f2 binary_uint32[]
);
insert into t_varray_datatype values (
    array[1, '2'::integer, null],
    array[null, '2'::binary_uint32]
);
commit;

update t_varray_datatype t1 join t_varray_datatype t2 on t1.f1=t2.f1 set t1.f1[4]=12;
drop table t_varray_datatype;

drop table if exists TAB_DCN_GBP_LOGIC_ROUTER;
CREATE TABLE "TAB_DCN_GBP_LOGIC_ROUTER"
(
  "VPN_RT_IMPORT" VARCHAR(8000 BYTE)[]
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;

CREATE OR REPLACE TRIGGER "DCN_DTAGENT_TAB_DCN_GBP_LOGIC_ROUTER_TRIGGER"
before insert on TAB_DCN_GBP_LOGIC_ROUTER for each row  DECLARE TG_VALUE VARCHAR(16); N_VALUE varchar(1000); O_VALUE varchar(12);  
BEGIN
TG_VALUE := 'INSERT'; 
O_VALUE := NULL; 
N_VALUE := :new.VPN_RT_IMPORT;
END;
/

insert into TAB_DCN_GBP_LOGIC_ROUTER values(NULL);

-- datatype decision
drop table if exists t1;
create table t1 (f1 timestamp[]);
insert into t1 values (array[systimestamp]);
insert into t1 values (array[systimestamp, null]);
insert into t1 values (array[systimestamp, '2020-09-02 09:24:34.464515']); -- error

alter session set NLS_TIMESTAMP_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF TZH:TZM';
insert into t1 values (array[systimestamp, '2020-09-02 09:24:34.464515']); -- ok

alter session set NLS_TIMESTAMP_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';
drop table if exists t2;
create table t2 (f1 timestamp);
insert into t2 values (systimestamp);
insert into t2 values (systimestamp::varchar(50)); -- error
alter session set NLS_TIMESTAMP_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF TZH:TZM';
insert into t2 values (systimestamp::varchar(50)); -- ok
drop table t1;
drop table t2;
desc -q select array[];
desc -q select array[null, null];

-- array as partition key
create table test(id int[]) partition by hash(id)(partition p_1, partition p_2); -- failed

-- test lob segment recycle
drop table if exists t1;
create table t1 (f1 varchar(5000)[]);
select segment_name, bytes, pages,extents from adm_segments where segment_name = 'LOB_T1_F1'; -- 0 pages
begin
	for i in 1..100 loop
      insert into t1 values(array['abc', 'def', 'kkk']);
      commit;
    end loop;
end;
/
truncate table t1;
select segment_name, bytes, pages,extents from adm_segments where segment_name = 'LOB_T1_F1'; -- 8 pages
drop table t1;

-- DTS202009210QMEFTP1G00
drop table if exists array_vm_t1;
drop table if exists array_vm_t2;

create table array_vm_t1
(
    id number(5),
    int_arr int[]
);
insert into array_vm_t1 values(1, array[1,2]);
insert into array_vm_t1 values(2, array[3,4]);
commit;

create table array_vm_t2
(
    id number(5),
    int_arr int[]
);

insert into array_vm_t2 values(1, array[10,20]);
insert into array_vm_t2 values(2, array[30,40]);
commit;

SELECT
  ref_0.id AS C0,
  (SELECT int_arr FROM array_vm_t1 LIMIT 1) AS C1
FROM
  array_vm_t2 AS ref_0 order by c0;

drop table array_vm_t1;
drop table array_vm_t2;

DROP TABLE IF EXISTS "TAB_DCN_SVO_CROSS_ROUTER_INFO" CASCADE CONSTRAINTS;
CREATE TABLE "TAB_DCN_SVO_CROSS_ROUTER_INFO"
(
  "ID" VARCHAR(36 BYTE) NOT NULL,
  "SFC_ID" VARCHAR(36 BYTE) NOT NULL,
  "NAME" VARCHAR(256 BYTE),
  "DESCRIPTION" VARCHAR(256 BYTE),
  "SRC_ROUTER_ID" VARCHAR(73 BYTE),
  "DST_ROUTER_ID" VARCHAR(73 BYTE),
  "SRC_LOGICVAS_ID" VARCHAR(73 BYTE),
  "DST_LOGICVAS_ID" VARCHAR(73 BYTE),
  "SRC_LOGICVAS_PORT_ID" VARCHAR(73 BYTE),
  "DST_LOGICVAS_PORT_ID" VARCHAR(73 BYTE),
  "TENANT_ID" VARCHAR(36 BYTE),
  "PEER_TENANT_ID" VARCHAR(36 CHAR),
  "SCENE_TYPE" BINARY_INTEGER,
  "VNI_RES_ARRAY" VARCHAR(8000 BYTE)[],
  "CONN_IP_ARRAY" VARCHAR(8000 BYTE)[],
  "VLAN_ARRAY" VARCHAR(8000 BYTE)[],
  "VRF0_ARRAY" VARCHAR(8000 BYTE)[],
  "CREATE_TIME" TIMESTAMP(6) DEFAULT current_timestamp,
  "UPDATE_TIME" TIMESTAMP(6) WITH TIME ZONE,
  "PRODUCER" VARCHAR(128 CHAR),
  "SRC_CIDRS" VARCHAR(8000 BYTE)[],
  "DST_CIDRS" VARCHAR(8000 BYTE)[],
  "DCI_GATEWAY_IDS" VARCHAR(8000 BYTE)[],
  "VRF0_KEY" VARCHAR(72 CHAR),
  "PRIORITY" BINARY_INTEGER,
  "LOCAL_EXTGW_IDS" VARCHAR(36 BYTE)[],
  "PEER_EXTGW_IDS" VARCHAR(36 BYTE)[],
  "CONNECT_RT" VARCHAR(36 BYTE),
  "LOCAL_ROUTER_TYPE" VARCHAR(36 BYTE),
  "PEER_ROUTER_TYPE" VARCHAR(36 BYTE)
);

INSERT INTO "TAB_DCN_SVO_CROSS_ROUTER_INFO" ("ID","SFC_ID","NAME","DESCRIPTION","SRC_ROUTER_ID","DST_ROUTER_ID","SRC_LOGICVAS_ID","DST_LOGICVAS_ID","SRC_LOGICVAS_PORT_ID","DST_LOGICVAS_PORT_ID","TENANT_ID","PEER_TENANT_ID","SCENE_TYPE","VNI_RES_ARRAY","CONN_IP_ARRAY","VLAN_ARRAY","VRF0_ARRAY","CREATE_TIME","UPDATE_TIME","PRODUCER","SRC_CIDRS","DST_CIDRS","DCI_GATEWAY_IDS","VRF0_KEY","PRIORITY","LOCAL_EXTGW_IDS","PEER_EXTGW_IDS","CONNECT_RT","LOCAL_ROUTER_TYPE","PEER_ROUTER_TYPE") values
  ('bd123122-f76e-4437-956f-0d20d9042ee0','9ae4073e-39e6-477d-bd0b-5d4ca7581209','vpc_128','','bcf6f5f5-5d9f-4a9f-ab7e-4abbe5ba5d3b','b5691909-793c-431b-b075-a048acc0c0b8',null,null,null,null,'00000000-0000-0000-0000-000000000000','f76e49b3-22e6-4126-aa09-9b4d92852ffb',11,null,null,null,null,'2020-10-08 17:00:21.000000','2020-10-08 17:08:32.000000 +08:00','Agile-Controller-MDC',null,'{164:1:75::/64,164.1.25.0/24,164.1.14.0/24,164:1:104::/64,164.1.29.0/24,164.1.21.0/24,164:1:17::/64,164:1:46::/64,164:1:107::/64,164.1.10.0/24,164:1:13::/64,164:1:116::/64,164.1.111.0/24,164.1.48.0/24,164.1.24.0/24,164:1:68::/64,164.1.87.0/24,164.1.35.0/24,164:1:117::/64,164:1:33::/64,164:1:76::/64,164.1.12.0/24,164:1:72::/64,164.1.107.0/24,164.1.3.0/24,164:1:96::/64,164.1.40.0/24,164.1.28.0/24,164:1:100::/64,164.1.67.0/24,164.1.82.0/24,164.1.96.0/24,164.1.80.0/24,164.1.98.0/24,164.1.84.0/24,164:1:61::/64,164:1:66::/64,164:1:77::/64,164:1:26::/64,164:1:108::/64,164.1.76.0/24,164:1:106::/64,164.1.51.0/24,164:1:45::/64,164:1:95::/64,164.1.103.0/24,164.1.88.0/24,164.1.31.0/24,164:1:69::/64,164:1:19::/64,164.1.77.0/24,164:1:62::/64,164:1:58::/64,164:1:80::/64,164:1:20::/64,164.1.6.0/24,164.1.109.0/24,164.1.123.0/24,164.1.104.0/24,164.1.69.0/24,164:1:57::/64,164:1:82::/64,164:1:125::/64,164:1:60::/64,164:1:23::/64,164.1.36.0/24,164.1.54.0/24,164.1.61.0/24,164:1:64::/64,164.1.119.0/24,164.1.79.0/24,164.1.39.0/24,164.1.13.0/24,164.1.118.0/24,164:1:114::/64,164.1.15.0/24,164:1:15::/64,164:1:85::/64,164.1.90.0/24,164.1.114.0/24,164:1:38::/64,164:1:10::/64,164:1:124::/64,164.1.53.0/24,164:1:78::/64,164.1.30.0/24,164.1.33.0/24,164.1.32.0/24,164.1.45.0/24,164:1:52::/64,164:1:63::/64,164.1.50.0/24,164.1.60.0/24,164.1.97.0/24,164.1.78.0/24,164:1:27::/64,164:1:110::/64,164.1.102.0/24,164.1.81.0/24,164.1.19.0/24,164:1:87::/64,164.1.85.0/24,164:1:109::/64,164.1.38.0/24,164:1:34::/64,164:1:83::/64,164.1.47.0/24,164:1:115::/64,164.1.121.0/24,164:1:103::/64,164.1.20.0/24,164.1.100.0/24,164.1.112.0/24,164:1:43::/64,164.1.7.0/24,164:1:53::/64,164:1:8::/64,164.1.43.0/24,164:1:11::/64,164:1:4::/64,164:1:14::/64,164:1:9::/64,164:1:86::/64,164.1.89.0/24,164:1:93::/64,164:1:59::/64,164:1:32::/64,164:1:111::/64,164:1:51::/64,164:1:29::/64,164:1:16::/64,164.1.124.0/24,164:1:50::/64,164.1.16.0/24,164.1.44.0/24,164.1.12888888.0/24}',null,null,120,'{421fb4f2-6610-410c-bdd6-f0d646b2c805}','{421fb4f2-6610-410c-bdd6-f0d646b2c805}',null,'TransitRouter','LogicRouter');
COMMIT;
ALTER TABLE "TAB_DCN_SVO_CROSS_ROUTER_INFO" ADD PRIMARY KEY("ID");
select DST_CIDRS from tab_dcn_svo_cross_router_info where name = 'vpc_128';
select dst_cidrs7_469_ from (
select crossroute0_.dst_cidrs as dst_cidrs7_469_ from tab_dcn_svo_cross_router_info crossroute0_ where crossroute0_.name = 'vpc_128' order by crossroute0_.create_time desc) 
where rownum <= 1;
ALTER SYSTEM SET CBO = ON;
select dst_cidrs7_469_ from (
select crossroute0_.dst_cidrs as dst_cidrs7_469_ from tab_dcn_svo_cross_router_info crossroute0_ where crossroute0_.name = 'vpc_128' order by crossroute0_.create_time desc) 
where rownum <= 1;
ALTER SYSTEM SET CBO = OFF;

declare 
str varchar(100);
str2 clob;
begin
for i in 1..4000 loop
    str := i*1000 || ',';
	str2 := str2 || str ;
end loop;
str2 :=array[substr(str2,1,length(str2)-1)];
dbe_output.print_line(str2);
end;
/

drop table if exists array_test_10;
create table array_test_10 (f1 int[]);
select distinct f1 from array_test_10;
select * from (select distinct f1 from array_test_10);
select f1 from array_test_10 minus select f1 from array_test_10;
select f1 from array_test_10 union select f1 from array_test_10;

declare
var int[];
x int;
begin
var:=array[1,2];
x:=var[1];
dbe_output.print_line(var[2]);
END;
/

declare
var int[];
x int;
begin
x:=var[2];
dbe_output.print_line(X);
END;
/

declare
var int[];
x int;
begin
var[1]:=2;
END;
/

declare
var int[];
x int;
begin
dbe_output.print_line(var[2:4]);
END;
/

CREATE OR REPLACE PROCEDURE MYPROC1_test1217(F1 INT[]) AS
var int[];
x int;
begin
var:=F1;
x:=var[1];
dbe_output.print_line(var[2]);
dbe_output.print_line(F1[2]);
END;
/

CALL MYPROC1_test1217(ARRAY[1,2]);

CALL MYPROC1_test1217(ARRAY[1]);

CALL MYPROC1_test1217(1);

CREATE OR REPLACE FUNCTION MYFUNC1_test1217(F1 INT[]) RETURN INT[] AS
var int[];
x int;
begin
var:=F1;
x:=var[1];
RETURN VAR;
END;
/

DECLARE
X INT[];
Y INT:=1;
BEGIN
X:=MYFUNC1_test1217(Y);
dbe_output.print_line(X);
END;
/

DECLARE
X INT[];
Z INT[];
Y INT:=1;
BEGIN
X:=MYFUNC1_test1217(Z);
dbe_output.print_line(X);
Z:=ARRAY[1,2,3];
X:=MYFUNC1_test1217(Z);
dbe_output.print_line(X);
dbe_output.print_line(X[5]);
END;
/

DECLARE
X INT[];
Z INT[];
Y INT:=1;
Q INT:=1;
BEGIN
Q:=MYFUNC1_test1217(Z);
dbe_output.print_line(Q);
Z:=ARRAY[1,2,3];
Q:=MYFUNC1_test1217(Z);
dbe_output.print_line(Q);
END;
/


CREATE OR REPLACE FUNCTION MYFUNC2_test1217(F1 INT[]) RETURN INT AS
var int[];
x int;
begin
var:=F1;
x:=var[1];
RETURN VAR;
END;
/

DECLARE
X INT[];
Y INT:=1;
BEGIN
Y:=MYFUNC2_test1217(X);
dbe_output.print_line(Y);
END;
/

DECLARE
Z INT[]:=ARRAY[1,234,5];
Y INT:=1;
BEGIN
Y:=MYFUNC2_test1217(Z);
dbe_output.print_line(Y);
END;
/

CREATE OR REPLACE FUNCTION MYFUNC3_test1217(F1 INT[]) RETURN INT AS
x int;
begin
RETURN F1[3];
END;
/

DECLARE
Z INT[]:=ARRAY[1,234,5];
A INT[];
Y INT:=1;
BEGIN
A:=MYFUNC3_test1217(Z);
dbe_output.print_line(A[1]);
END;
/

DECLARE
Z INT[]:=ARRAY[1,234,5];
A INT[];
Y INT:=1;
BEGIN
Y:=MYFUNC3_test1217(Z);
dbe_output.print_line(Y);
Y:=MYFUNC3_test1217(Z[1:2]);
dbe_output.print_line(Y);
Z:=ARRAY[5,7];
Y:=MYFUNC3_test1217(Z);
dbe_output.print_line(Y);
Z:=ARRAY[1,2,3,4,5,6,7,8,9];
A:=Z[5:8];
dbe_output.print_line(A);
dbe_output.print_line(A[1]);
dbe_output.print_line(A[5]);
Y:=MYFUNC3_test1217(Z[5:8]);
dbe_output.print_line(Y);
END;
/
create or replace function funcdsh(f1 int) return int[] as
f2 int[];
Begin
F2:=array[3,9,13];
return f2;
end;
/
select funcdsh(1) from sys_dummy;

create or replace function funcdsh4(f1 int) return int as
f2 int[];
Begin
F2:=array[3,9,13];
return f2[1];
end;
/
select funcdsh4(1) from sys_dummy;

create or replace function funcdsh2(f1 int) return int[] as
f2 int[];
x int;
Begin
F2:=array[3,9,13];
x:=f2[2];
return x;
end;
/
select funcdsh2(1) from sys_dummy;

create or replace function funcdsh3(f1 int) return int as
f2 int[];
Begin
F2:=array[3,9,13];
return f2;
end;
/
select funcdsh3(1) from sys_dummy;

declare
f2 int[];
x int;
Begin
F2:=array[3,9,13];
x:=f2[2];
F2[1]:=1;
dbe_output.print_line(x);
end;
/

declare
f2 int[]:=array[3,4,13];
begin
for i in f2[1]..f2[2]
loop
dbe_output.print_line(i);
end loop;
end;
/

declare
f2 int[]:=array[3,4,13];
x f2%type;
begin
x:=f2;
dbe_output.print_line(x);
end;
/

declare
f2 int[]:=array[3,4,13];
x f2[1]%type;
begin
x:=f2[1];
end;
/

create or replace function funcdsh5(f1 varchar,f2 f1%type) return int[] as
f3 int[];
x int;
Begin
F2:=array[3,9,13];
x:=f2[2];
return f2;
end;
/

create or replace function funcdsh5(f1 varchar,f2 f1%rowtype) return int[] as
f3 int[];
x int;
Begin
F2:=array[3,9,13];
x:=f2[2];
return f2;
end;
/

declare
type mytype is table of int[];
x mytype;
y x%type;
begin
x:=mytype(array[1,2]);
dbe_output.print_line(x);
end;
/

create table tb_test_arr_pl(f1 int[],f2 int);
insert into tb_test_arr_pl values(array[1,2,3],10);
declare
x int[];
y int;
begin
select f2 into x[1] from tb_test_arr_pl limit 1;
dbe_output.print_line(x);
end;
/
declare
x int[];
y int;
begin
select f1 into x from tb_test_arr_pl limit 1;
dbe_output.print_line(x);
end;
/
drop table if exists tb_test_arr_pl;
drop function if exists funcdsh5;
drop function if exists funcdsh4;
drop function if exists funcdsh3;
drop function if exists funcdsh2;
drop function if exists funcdsh;
drop FUNCTION if exists MYFUNC3_test1217;
drop FUNCTION if exists MYFUNC1_test1217;
drop FUNCTION if exists MYFUNC2_test1217;
drop PROCEDURE if exists MYPROC1_test1217;
--20210531
drop table if exists staffs_f;
create table staffs_f(id number(6), c_id int[], d date default current_timestamp);
ALTER TABLE staffs_f ADD CONSTRAINT CON check(array_length(c_id)>2);
select array_length(c_id) from staffs_f;
drop table staffs_f;
--20210626
select array_agg(c) from (select cast(1.2 as number(10,5)) c from sys_dummy union all select cast(1.23 as number(10,4)) from sys_dummy union all select cast(1.233 as varchar(10)) from sys_dummy);