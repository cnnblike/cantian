-- create table/alter table
ALTER SESSION SET TIME_ZONE='+08:00';

-- specify the capacity of array
drop table if exists array_1;
create table array_1(name varchar(30),pay_by_quarter integer[4]);
insert into array_1 values ('paul',array[1,2,3,4,5,6]);
insert into array_1 values ('willim', array[1,2,3]);
desc array_1
select * from array_1;

-- Multidimensional arrays are not supported
drop table if exists array_0;
create table array_0 (f1 int,f2 integer[][]);

-- create not null
drop table if exists array_3;
create table array_3 (f1 integer[] not null,f2 varchar(30));

-- select clause
drop table if exists array_4;
create table array_4 as (select name as f1 from array_1);
desc array_4
drop table if exists array_5;
drop table if exists array_6;
drop table if exists array_7;
drop table if exists array_8;
create table array_5 (id int,f1 varchar(30),f2 varchar(30),f3 varchar(30)[]);
create table array_6 as (select concat(f1,'(',f2,')') as f1 from array_5);
create table array_7 as (select concat(f1,'(',f3,')') as f1 from array_5);
insert into array_5 values(1,'a','b',array['a','b']);
insert into array_5 values(2,'a','d',array['a','d']);
create table array_8 as (select id,f3 from array_5);
select * from array_8;

-- alter table
drop table if exists array_1;
drop table if exists array_3;
drop table if exists array_4;
drop table if exists array_5;
drop table if exists array_6;
drop table if exists array_7;
drop table if exists array_8;
create table array_1 (f1 int[]);
alter table array_1 add f2 int[];
desc array_1
insert into array_1 values(array[1,2],array[5,6,7]);
insert into array_1 values('{5,6}','{7,8,9}');
alter table array_1 add f3 varchar(30)[];
desc array_1
select * from array_1;

-- alter type
create table array_3 (id int,f1 int[],f2 varchar(30),f3 varchar(30)[]);
alter table array_3 modify f3 varchar(30);
alter table array_3 modify f1 int[];
alter table array_3 modify f2 int;
alter table array_3 modify f3 varchar(60)[];
desc array_3

-- drop array
alter table array_3 drop f1;
alter table array_1 drop f1;

-- insert 
drop table if exists array_1;
create table array_1(id int,f1 int[],f2 varchar(30)[]);
insert into array_1 values(1,array[1,2,3,6,8],array['a','c']);
insert into array_1 values(2,'{3,5,7,9}','{"b","d"}');
insert into array_1 values(3,array[3,5,9],['f','v']);
insert into array_1 values(4,'{8,9}','{'a','g'}');
insert into array_1 values(5,'{8,11}','{"f",y}');
insert into array_1 values(6,array[1,3,5],array["h","g"]);
insert into array_1 values(7,'{3,7}','{4,7}');
insert into array_1 values(5,'{b,c}','{f,y}');
select * from array_1;
drop table if exists array_3;
create table array_3(f1 varchar(30)[]);
insert into array_3 values ('{who''s bread,It''s ok}');
select * from array_3;

-- type transform
insert into array_3 values (array[2019-07-22,'a',9]);
insert into array_3 values (array['2019-07-25 12:00:00',7]);
alter table array_3 add f2 int[];
alter table array_3 add f3 bool[];
desc array_3
insert into array_3 values(array['a','b','c'],array['1','3','9'],null);
insert into array_3 values(array['d','e','f'],array[2.1,3.578],null);
insert into array_3 values(array['g','h','k'],array[0110,0010],null);
insert into array_3 values(array['b','t','b'],array[2019-07-25,3,5],null);
insert into array_3 values(null,null,array[0,1,'true','false','t','f']);
insert into array_3 values(null,null,array[0,101]);
select * from array_3;
create table array_4 (f1 date[]);
insert into array_4 values(array['2019-07-25 12:00']);
insert into array_4 values(array['abc']);
insert into array_4 values(array[1011]);
insert into array_4 values(array['1011']);
insert into array_4 values(array['2019-07-25']);
insert into array_4 values(array[null]);
insert into array_4 values(null);
select * from array_4;

-- update
drop table if exists array_1;
drop table if exists array_3;
drop table if exists array_4;
create table array_1 (id int,f1 int[]);
insert into array_1 values(1,array[1,3,5]);
insert into array_1 values(2,array[1,7,5]);
commit;
select * from array_1;
update array_1 set f1[2147483647]=100 where id=1;
select array_length(f1) from array_1 where id=1;
update array_1 set f1[2147483648]=100 where id=1;
rollback;
select * from array_1;
update array_1 set f1[1:2]=array[1,5] where id=2;
update array_1 set f1[1:2]=array[1,5,9] where id=2;
create table array_3 (id int,f1 int[],f2 varchar(30)[]);
insert into array_3 values(1,array[1,2],array['a','b']);
insert into array_3 values(2,array[2,7],array['k','m']);
select * from array_3;
update array_1 set f1 = (select f1 from array_3 where id=1) where id=2;
select * from array_1;
update array_3 set f1=(select f1 from array_1 where id=2),f2=array['m','m','z'];
select * from array_3;
update array_1 set f1 = (select f2 from array_3 where id=1) where id=1;

-- select / test operator
drop table if exists array_1;
drop table if exists array_3;
create table array_3(id int,f1 int[],f2 varchar(30)[],f3 date[]);
insert into array_3 values(1,array[1,2,3],array['a','b','c'],array['2019-03-22 12:00:00']);
insert into array_3 values(2,array[1,3,5],array['b','e','c'],array['2019-04-22 12:00:00']);
insert into array_3 values(3,array[5,2,3],array['g','b','m'],null);
insert into array_3 values(4,array[4,6,8],array['b','f','c'],array['2019-05-22 12:00:00']);
insert into array_3 values(5,array[3,7,3],array['m','m','z'],array['2019-06-22 12:00:00']);
insert into array_3 values(6,array[7,8,9],array['g','g','c'],null);
insert into array_3 values(1,array[9,2,3],array['s','f','c'],array[null]);
select * from array_3 where f3 is not null;
select * from array_3 where f3 is null;
select f2 from array_3 where f2[1] regexp'[a-d]';
select * from array_3 where f1 = 1;
select * from array_3 where f1 != 1;
select * from array_3 where f1 >= 1;
select * from array_3 where f1 <= 1;
select * from array_3 where f1 > 1;
select * from array_3 where f1 < 1;
select * from array_3 where f1 between 1 and 2;
select * from array_3 where f1 not between 1 and 2;
select * from array_3 where f1 regexp 1;
select * from array_3 where f1 not regexp 1;
select * from array_3 where f1 in (1,2);
select * from array_3 where f1 not in (1,2);
select * from array_3 where id in (select f1 from array_3);
select * from array_3 where id not in (select f1 from array_3);
select * from array_3 where id = any (select f1 from array_3);
select * from array_3 where id != any (select f1 from array_3);
select * from array_3 where exists(select f3 from array_3);
select * from array_3 t1 join array_3 t2 on t1.f1 = t2.f3;

-- array function
select array_length(array[null]) from dual;
select array_length('{"a","b"}');
update array_3 set f1=array[3,5,7,9,10] where id=3;
update array_3 set f1=array[4,5,6,9] where id=5;
select * from array_3;
select id,array_length(f1) from array_3;
select * from array_3 where array_length(f1)=array_length(f2);
drop table if exists test_agg;
create table test_agg (id int,v int);
insert into test_agg values(1,1);
insert into test_agg values(1,4);
insert into test_agg values(1,9);
insert into test_agg values(2,11);
insert into test_agg values(2,13);
insert into test_agg values(2,16);
insert into test_agg values(2,23);
insert into test_agg values(3,15);
insert into test_agg values(3,7);
insert into test_agg values(3,18);
select * from test_agg;
select id,array_agg(v) from test_agg group by id;
delete from test_agg;
alter table test_agg modify v varchar(30);
alter table test_agg add t date;
insert into test_agg values(1,'baby','2019-03-22 12:00:00'),(1,'cdd','2019-04-22 12:00:00'),(2,'full',null),(2,'happy','2019-03-22 12:00:00'),(2,'up','2019-05-22 12:00:00'),(3,'go','2019-05-22 12:00:00'),(3,'tt','2019-04-22 12:00:00');
select * from test_agg order by id, v;
--unstable result
--select id,array_agg(v) from test_agg group by id order by id;
--select id,array_agg(t) from test_agg group by id order by id;

-- join
drop table if exists array_3;
drop table if exists array_4;
create table array_3(id int,f1 int[],f2 varchar(30)[],f3 date[]);
insert into array_3 values(1,array[1,2,3],array['a','b','c'],array['2019-03-22 12:00:00']);
insert into array_3 values(2,array[4,5,6],array['d','e','f'],array['2019-04-22 12:00:00']);
insert into array_3 values(3,array[7,8,9],array['g','h','i'],array['2019-05-22 12:00:00']);
create table array_4(id int,m1 int[],m2 varchar(30)[],m3 date[]);
insert into array_4 values(1,array[1,3,5],array['a','d','c'],array['2019-03-22 12:00:00']);
insert into array_4 values(3,array[4,6,5],array['a','d','c'],array['2019-05-22 12:00:00']);
insert into array_4 values(5,array[7,8,9],array['a','d','e'],array['2019-07-22 12:00:00']);
select array_3.id,array_3.f1,array_4.m3 from array_3,array_4;
select array_3.id,array_3.f1,array_4.m3 from array_3 join array_4 on array_3.id=array_4.id;
select array_3.id,array_3.f1,array_4.m3 from array_3 right join array_4 on array_3.id=array_4.id;
select array_3.id,array_3.f1,array_4.m3 from array_3 full join array_4 on array_3.id=array_4.id;
select f3 from array_3 where id=(select id from array_4 where m1[1]=4);

-- order by/group by
insert into array_3 values(4,array[7,1,3],array['m','g','z'],array['2019-06-22 12:00:00']);
select * from array_3;
select * from array_3 order by f1[2];
select f1[1],count(*) from array_3 group by f1[1];
select f1[1],count(*) from array_3 group by f1[1] order by count(*);
select f1[1],count(*) from array_3 group by f1[1] order by f1[1];
insert into array_3 values(5,array[7,2,3],array['m','g','z'],array['2019-07-22 12:00:00']);
insert into array_3 values(6,array[3,5,3],array['m','g','z'],array['2019-08-22 12:00:00']);
insert into array_3 values(7,array[6,2,6],array['m','g','z'],array['2019-09-22 12:00:00']);
commit;
select f1[2],count(*) from array_3 group by f1[2] having count(*)>=2 order by count(*);
select * from array_3 order by id limit 2,5;
select * from array_3 offset 1 limit 2;
select * from array_3 limit 2 offset 1;

-- merge
merge into array_4 using array_3 on (array_4.id=array_3.id) when matched then update set array_4.m1[1]=array_3.f1[1] when not matched then insert (id,m1,m2,m3) values (array_3.id,array_3.f1,array_3.f2,array_3.f3);
select * from array_4;

-- delete
rollback;
delete from array_3 where f3=array['2019-07-22 12:00:00'];
delete from array_3 where f3[1]='2019-07-22 12:00:00';
update array_3 set f3=array['2019-05-22 12:00:00'] where id=4;
update array_3 set f1=array[1,2,3,4] where id=1;
select * from array_3;
delete from array_3 where f3[1]='2019-05-22 12:00:00' and id=3;
delete from array_3 where array_length(f1)=4;
select * from array_3;
rollback;
delete from array_3 using array_4 join array_3 on array_3.id=array_4.id;
select * from array_3;

-- DTS2019110500628
DROP TABLE IF EXISTS t_group_by_rollup_004;
CREATE TABLE t_group_by_rollup_004 (
 fact_1_id int,
 fact_2_id int,
 fact_3_id int,
 fact_4_id int[],
 sales_value int
);

INSERT INTO t_group_by_rollup_004 VALUES (1,2,3,'{1,2,3}',5);
INSERT INTO t_group_by_rollup_004 VALUES (2,9,3,'{1,2,3}',5);
INSERT INTO t_group_by_rollup_004 VALUES (3,9,3,'{4,5,6}',5);
INSERT INTO t_group_by_rollup_004 VALUES (4,9,3,'{4,5,6}',8);
INSERT INTO t_group_by_rollup_004 VALUES (5,9,3,'{4,5,6}',8);
INSERT INTO t_group_by_rollup_004 VALUES (6,2,3,'{7,8,9}',8);
INSERT INTO t_group_by_rollup_004 VALUES (7,2,3,'{7,8,9}',8);
INSERT INTO t_group_by_rollup_004 VALUES (8,2,4,'{7,8,9}',5);
COMMIT;

SELECT fact_1_id, fact_4_id[1], fact_4_id[2], fact_4_id[3], SUM(sales_value) AS sales_value
 FROM t_group_by_rollup_004 GROUP BY rollup (fact_1_id,fact_4_id[1],fact_4_id[2],fact_4_id[3])
 ORDER BY fact_1_id,fact_4_id[1],fact_4_id[2],fact_4_id[3];

-- select array into array
drop table if exists t_array2array;
create table t_array2array (COL1 int,COL2 number(38,8)[]);
insert into t_array2array values(1,array[58814,546223077,1234567.67,12345.4567,12.1234567,null,2345.89,-12345.4567,12.1234567,12.55]);
insert into t_array2array values(2,array[-0.9E12 , 1.0E26 -1 , -89.0000001]);
commit;

set serveroutput on;
CREATE OR REPLACE PROCEDURE p_array2array()
AS
V1 number[];
BEGIN
	select COL2 into V1 from t_array2array where COL1=1;
	if (V1[3]>10000)and(V1[8]<0)
	then
		dbe_output.print_line('array[3] is: '||V1[3]);
	else
		dbe_output.print_line('V1[6] is : '||V1[6]);
	end if;
END;
/
call p_array2array();
call p_array2array();
call p_array2array();
drop PROCEDURE p_array2array;
drop table t_array2array;

-- common don't support knl_array
DROP TABLE IF EXISTS t_array2array;
CREATE TABLE  t_array2array(
     COL_1 integer,
     COL_2 bigint,
     COL_3 double,
     COL_4 decimal(12,6),
     COL_5 bool,
     COL_6 char(30),
     COL_7 varchar2(50),
     COL_8 varchar(30),
     COL_9 interval day to second,
     COL_10 TIMESTAMP,
     COL_11 date,
     COL_12 datetime,
     COL_13 TIMESTAMP WITHOUT TIME ZONE,
     COL_14 blob,
     COL_15 clob,
     COL_16 int[]
);

drop sequence if exists s_array2array;
create sequence s_array2array increment by 1 start with 10;

begin
 for i in 1..50 loop
      insert into t_array2array values(
   i,
      s_array2array.nextval,
   i+445.255,
   98*0.99*i,
   true,
   lpad('abc','30','@'),
   lpad('abc','30','b'),
   rpad('abc','30','e'),
   (INTERVAL '4 5:12:10.222' DAY TO SECOND(3)),
   to_timestamp('2019-01-03 14:58:54.000000','YYYY-MM-DD HH24:MI:SS.FFFFFF'),
   TIMESTAMPADD(SECOND,i,'2018-11-03 14:14:12'),
   TIMESTAMPADD(MINUTE,i,'2019-01-03 14:14:12'),
   TIMESTAMPADD(HOUR,i,'2019-01-03 14:14:12'),
   lpad('10','12','01010'),
   rpad('abc','9','a@123&^%djgk'),
   '{32,535,5645645,6767,76,67,56,48,979,978,7}'
   );
      commit;
    end loop;
end;
/
commit;

select * from t_array2array t where t.COL_16 like '%' order by COL_1;
drop table t_array2array;
drop sequence s_array2array;

--ISSUE #29903
drop table if exists exp_imp_arr_test;
create table exp_imp_arr_test(f5 NUMBER(9,2)[]);
insert into exp_imp_arr_test values(array[12345678]);
drop table if exists exp_imp_arr_test;

--DTS202010210DONY2P1J00
set serveroutput on;
drop table if exists ARRAY_TAB_001;
create table ARRAY_TAB_001(f1 integer[10], f2 integer);
create or replace procedure ARRAY_PRO_001 (ARRAY_C integer[])
as
ARRAY_A ARRAY_TAB_001.f1%type;
begin
        ARRAY_A:=ARRAY_C;
        dbe_output.print_line(ARRAY_A);
end;
/
declare
ARRAY_B integer[] :=array[1,2,3];
begin
        ARRAY_PRO_001(ARRAY_B);
end;
/
declare
ARRAY_A integer[] :=array[1,2,3,4,5,6,7,8,9,10];
begin
        dbe_output.print_line(ARRAY[ARRAY_A[1],   ARRAY_A[2]]);
end;
/

create or replace function SYN_FUN_001(ARRAY_C integer[]) return integer[]
as
ARRAY_A integer[];
begin
        ARRAY_A:=ARRAY_C;
        return ARRAY_A;
end;
/
drop synonym if exists SYN_FUN_SYN_001;
create or replace synonym SYN_FUN_SYN_001 for SYN_FUN_001;
declare
        ARRAY_A integer[]:=array[1,2,3,4,5,6,7,8,9,10];
begin
        ARRAY_A:= SYN_FUN_SYN_001(ARRAY_A);
        dbe_output.print_line(SYN_FUN_SYN_001(ARRAY_A));
end;
/
drop table ARRAY_TAB_001;
drop procedure ARRAY_PRO_001;
drop synonym SYN_FUN_SYN_001;
drop function SYN_FUN_001;

set serveroutput off;

-- DTS202104230FBB6HP1200
drop table if exists test_array_rs_t;
create table test_array_rs_t(c_int int[]);
insert into test_array_rs_t values(array[1,2,null,10,11]);
insert into test_array_rs_t values(array[1,2,2,10]);
insert into test_array_rs_t values(array[1,2,2]);
select ref_0.c as c0, ref_0.c as c1 from (select array_agg(array_length(c_int)) c from test_array_rs_t) as ref_0;
select array_agg(array_length(c_int)) as c0, array_agg(array_length(c_int)) as c1 from test_array_rs_t as ref_0;

drop view if exists test_array_rs_v;
create view test_array_rs_v(c1,c2) as 
select t1.c_int,t2.c_int from test_array_rs_t t1 join test_array_rs_t t2 
on case when t1.c_int[2]=2 then array_length(t1.c_int) end=array_length(t2.c_int);

select
  (select c1 from test_array_rs_v limit 1) as c0
from
  sys_dummy as ref_0;

drop view test_array_rs_v;
drop table test_array_rs_t;