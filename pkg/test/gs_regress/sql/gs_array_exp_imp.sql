--1. create user
drop user if exists wg1 cascade;
drop user if exists wg2 cascade;
create user wg1 identified by Changeme_123;
grant dba to wg1;
create user wg2 identified by Changeme_123;
grant dba to wg2;

--2. create table which inclues array, and export
conn wg1/Changeme_123@127.0.0.1:1611
drop table if exists wg_t2;
drop table if exists wg_t1;
drop table if exists emp;
drop table if exists exp_imp_noarr_test;
drop table if exists exp_imp_arr_test;

CREATE TABLE wg_t1(id1 int, id2 int, constraint pk_id1 primary key(id1));
CREATE TABLE wg_t2(t_id int, t_num int, CONSTRAINT t_id_fk FOREIGN KEY(t_id) REFERENCES wg_t1(id1));
alter table wg_t2 add constraint t_num_fk foreign key(t_num) references wg_t1(id1);
insert into wg_t1 values(1,2);
insert into wg_t2 values(1,1);

create table emp(id int, age int, ename varchar(20), gongzi int default 10000);
alter table emp add constraint pkpk1 primary key(id);
alter table emp add constraint chch1 check(age>20);
alter table emp add constraint unun1 unique(ename);
alter table emp modify gongzi default 10001;
insert into emp values(1,21,'ghost', 10001);

create table exp_imp_arr_test(
f0 int              ,
f1 BINARY_INTEGER[] ,
f2 BINARY_DOUBLE[]  ,
f3 BINARY_UINT32[]  ,
f4 BINARY_BIGINT[]  ,
f6 CHAR(456)[]      ,
f7 VARCHAR(123)[]   ,
f8 DATE[]           ,
f9 TIMESTAMP[]      ,
f10 BOOLEAN[]       ,
constraint pk_f0 primary key(f0));
create table exp_imp_noarr_test(a int);
alter table exp_imp_noarr_test add constraint a_fk foreign key(a) references exp_imp_arr_test(f0);
insert into exp_imp_arr_test values(
1,
array[99], 
array[99.0], 
array[12345], 
array[543216], 
array['Iron Man'], 
array['Hospitial'], 
array['2020-05-08 10:48:25'], 
array['2020-05-08 10:48:25'], 
array['TRUE']);
insert into exp_imp_noarr_test values(1);
commit;

desc wg_t2;
desc wg_t1;
desc emp;
desc exp_imp_noarr_test;
desc exp_imp_arr_test;
select * from wg_t2;
select * from wg_t1;
select * from emp;
select * from exp_imp_noarr_test;
select * from exp_imp_arr_test;
select * from MY_CONSTRAINTS order by CONSTRAINT_NAME;
exp users=wg1 filetype=bin file="./data/test.exp" content=METADATA_ONLY;

--2. import metadata from wg1 to wg2, and use Anonymous copy data from wg1 to wg2
conn wg2/Changeme_123@127.0.0.1:1611
drop table if exists wg_t2;
drop table if exists wg_t1;
drop table if exists emp;
drop table if exists exp_imp_noarr_test;
drop table if exists exp_imp_arr_test;

imp remap_schema=WG1:WG2 filetype=bin file="./data/test.exp";
declare
str varchar(1000);
cur_scn number(38);
begin
	--0. obtain current scn
	select current_scn into cur_scn from dv_database;
	
	--1. disable all foreign key
	for item in (select table_name, constraint_name 
	             from MY_CONSTRAINTS 
				 where constraint_type = 'R';)
	loop
	str := 'alter table ' || item.table_name || ' disable constraint ' || item.constraint_name;
	execute immediate str;
	end loop;
	
	--2. copy data from userA to userB
	for item in (select table_name from my_tables;)
	loop
	str := 'insert into wg2.' || item.table_name || ' select * from wg1.' || item.table_name || ' as of scn(' || cur_scn || ')';
	execute immediate str;
	end loop;
	
	--3. enable all foreign key
	for item in (select table_name, constraint_name 
	             from MY_CONSTRAINTS 
				 where constraint_type = 'R';)
	loop
	str := 'alter table ' || item.table_name || ' enable constraint ' || item.constraint_name;
	execute immediate str;
	end loop;
end;
/

desc wg_t2;
desc wg_t1;
desc emp;
desc exp_imp_noarr_test;
desc exp_imp_arr_test;
select * from wg_t2;
select * from wg_t1;
select * from emp;
select * from exp_imp_noarr_test;
select * from exp_imp_arr_test;
select * from MY_CONSTRAINTS order by CONSTRAINT_NAME;

--4.delete user
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists wg1 cascade;
drop user if exists wg2 cascade;

-- exp/imp support array datatype bin format
drop user if exists wg cascade;
create user wg identified by Changeme_123;
grant dba to wg;
conn wg/Changeme_123@127.0.0.1:1611

drop table if exists array_imp_exp_1;
drop table if exists array_imp_exp_2;
create table array_imp_exp_1 (
    f1 integer[10],
    f2 binary_uint32[],
    f3 bigint[],
	f3_1 varchar(8000)[],
    f4 binary_double[],
    f5 double[],
    f6 float[],
    f7 real[],
	f7_1 varchar(8000)[],
    f8 number(12,3)[],
    f9 decimal(20,5)[],
    f10 char(30)[],
	f10_1 varchar(8000)[],
    f11 nchar(30)[],
    f12 varchar(30)[],
    f13 nvarchar(30)[],
    f14 date[],
    f15 datetime[],
    f16 timestamp[],
	f16_1 varchar(8000)[],
    f17 timestamp(3) with time zone[],
    --f18 timestamp(3) with local time zone[],
    f19 boolean[],
    f20 interval year(4) to month[],
    f21 interval day(7) to second(6)[],
    f22 integer,
	f23 varchar(8000)[]
);

insert into array_imp_exp_1 values (
    array[1, '2'::integer, null],
    array[null, '2'::binary_uint32],
    '{null,1,2,3,null}',
	'{' || rpad('1234567890',5000,'1234567890') || '}',
    array[1.23, 3.2123, null, 0],
    array[null, '1.23', 3.2123, null],
    array[null, '1.23', 3.2123, null],
    array[null, '1.23', 3.2123, null],
	'{' || rpad('1234567890',5000,'1234567890') || '}',
    array[null, '1234567.89', 1234567.89, null],
    array[1234567.12345, '1234567.89', 1234567.89, null],	
    array['abc', 'def', 'abc''def', null],
	'{' || rpad('1234567890',5000,'1234567890') || '}',
    array[],
    '{}',
    array['abc', 'def', 'abc''def', null],
    array[null, '0001-01-01 00:00:00', '9999-12-31 23:59:59', null],
    array['0001-01-01 00:00:00', null, '9999-12-31 23:59:59', null],
    array['0001-01-01 00:00:00.000000', null, '9999-12-31 23:59:59.999999', null],
    '{' || rpad('1234567890',5000,'1234567890') || '}',
    array['2019-06-15 14:36:25.046731'],
    --array['2019-06-15 14:36:25.046731'],
    array[true, false, 1::bool, 0::bool, null],
    array['-9999-11', '+9999-11', null],
    array['-P99DT655M999.99999S', '1231 12:3:4.1234', 'P1231DT16H3.3333333S', '-0 00:19:7.7777777777', '-1234 0:0:0.0004', 'PT12H', null],
    1,
	'{' || rpad('1234567890',5000,'1234567890') || '}'
);
commit;
create table array_imp_exp_2 as select * from array_imp_exp_1;

exp tables=array_imp_exp_1 filetype=txt file="array_imp_exp_1_txt";
imp tables=array_imp_exp_1 filetype=txt file="array_imp_exp_1_txt";

select 1 from array_imp_exp_2 a, array_imp_exp_1 b where to_char(a.f1)  = to_char(b.f1)  and
 to_char(a.f2 ) = to_char(b.f2 ) and
 to_char(a.f3 ) = to_char(b.f3 ) and
 to_char(a.f3_1 ) = to_char(b.f3_1 ) and
 to_char(a.f4 ) = to_char(b.f4 ) and
 to_char(a.f5 ) = to_char(b.f5 ) and
 to_char(a.f6 ) = to_char(b.f6 ) and
 to_char(a.f7 ) = to_char(b.f7 ) and
 to_char(a.f7_1 ) = to_char(b.f7_1 ) and
 to_char(a.f8 ) = to_char(b.f8 ) and
 to_char(a.f9 ) = to_char(b.f9 ) and
 to_char(a.f10) = to_char(b.f10) and
 to_char(a.f10_1) = to_char(b.f10_1) and 
 to_char(a.f11) = to_char(b.f11) and
 to_char(a.f12) = to_char(b.f12) and
 to_char(a.f13) = to_char(b.f13) and
 to_char(a.f14) = to_char(b.f14) and
 to_char(a.f15) = to_char(b.f15) and
 to_char(a.f16) = to_char(b.f16) and
 to_char(a.f16_1) = to_char(b.f16_1) and 
 to_char(a.f17) = to_char(b.f17) and
 --to_char(a.f18) = to_char(b.f18) and
 to_char(a.f19) = to_char(b.f19) and
 to_char(a.f20) = to_char(b.f20) and
 to_char(a.f21) = to_char(b.f21) and
 to_char(a.f22) = to_char(b.f22) and
 to_char(a.f23) = to_char(b.f23);

exp tables=array_imp_exp_1 filetype=bin file="array_imp_exp_1_bin";
imp tables=array_imp_exp_1 filetype=bin file="array_imp_exp_1_bin";

select 1 from array_imp_exp_2 a, array_imp_exp_1 b where to_char(a.f1)  = to_char(b.f1)  and
 to_char(a.f2 ) = to_char(b.f2 ) and
 to_char(a.f3 ) = to_char(b.f3 ) and
 to_char(a.f3_1 ) = to_char(b.f3_1 ) and
 to_char(a.f4 ) = to_char(b.f4 ) and
 to_char(a.f5 ) = to_char(b.f5 ) and
 to_char(a.f6 ) = to_char(b.f6 ) and
 to_char(a.f7 ) = to_char(b.f7 ) and
 to_char(a.f7_1 ) = to_char(b.f7_1 ) and
 to_char(a.f8 ) = to_char(b.f8 ) and
 to_char(a.f9 ) = to_char(b.f9 ) and
 to_char(a.f10) = to_char(b.f10) and
 to_char(a.f10_1) = to_char(b.f10_1) and 
 to_char(a.f11) = to_char(b.f11) and
 to_char(a.f12) = to_char(b.f12) and
 to_char(a.f13) = to_char(b.f13) and
 to_char(a.f14) = to_char(b.f14) and
 to_char(a.f15) = to_char(b.f15) and
 to_char(a.f16) = to_char(b.f16) and
 to_char(a.f16_1) = to_char(b.f16_1) and 
 to_char(a.f17) = to_char(b.f17) and
 --to_char(a.f18) = to_char(b.f18) and
 to_char(a.f19) = to_char(b.f19) and
 to_char(a.f20) = to_char(b.f20) and
 to_char(a.f21) = to_char(b.f21) and
 to_char(a.f22) = to_char(b.f22) and
 to_char(a.f23) = to_char(b.f23);

--data_type in db_tab_cols should be end with "[]", or is_arr_type in gsql_export.c will be wrong
select 1 from db_tab_cols where COLUMN_NAME = 'F1' and table_name = 'ARRAY_IMP_EXP_1' and substr(data_type,-2,2) = '[]';

--update array
drop table if exists array_imp_exp_3;
create table array_imp_exp_3(f1 int[]);
insert into array_imp_exp_3 values(array[1,2,3]);
update array_imp_exp_3 set f1[1] = NULL;
select * from array_imp_exp_3;
update array_imp_exp_3 set f1[2:3] = '{NULL, null}';
select * from array_imp_exp_3;
update array_imp_exp_3 set f1[1:3] = '{1, 2, 3}';
select * from array_imp_exp_3;

--DTS202103170JZ37VP1J00
drop table if exists ARRAY_TEST_004_01;
CREATE TABLE ARRAY_TEST_004_01
(
  "COL1" CHAR(200 BYTE)[],
  "COL2" VARCHAR(2000 BYTE)[],
  "COL3" VARCHAR(8000 BYTE)[],
  "COL4" CHAR(90 CHAR)[],
  "COL5" VARCHAR(200 CHAR)[],
  "COL6" VARCHAR(8000 CHAR)[],
  "COL7" VARCHAR(8000 CHAR)[],
  "COL8" VARCHAR(8000 CHAR)[]
);
insert into array_test_004_01 values(array[NULL , ' ' , '' ],array['_char' ,' _varchar(100)' ,'123'], '{2019-6-20,111111}' ,'{asdfasdfrtyrty, mnop, '' ,'' , _a%}', array[ '123 ', 'abcdef'], array[lpad('1234567890', 8000, '1234567890')], '{""}', array['''""""""""""""""''''''''''''''''''''''''''''''''''''''''''''''''''''''''''']);
commit;
select * from ARRAY_TEST_004_01;
drop table if exists ARRAY_TEST_004_01_bk;
create table ARRAY_TEST_004_01_bk as select * from ARRAY_TEST_004_01;
exp tables=ARRAY_TEST_004_01;
imp tables=ARRAY_TEST_004_01;
select a.col7, b.col7 from ARRAY_TEST_004_01 a, ARRAY_TEST_004_01_bk b where 
to_char(a.col1) = to_char(b.col1)
and lengthb(to_char(a.col1)) = lengthb(to_char(b.col1))
and to_char(a.col2) = to_char(b.col2)
and to_char(a.col3) = to_char(b.col3)
and to_char(a.col4) = to_char(b.col4)
and lengthb(to_char(a.col4)) = lengthb(to_char(b.col4))
and to_char(a.col5) = to_char(b.col5)
and to_char(a.col6) = to_char(b.col6)
and to_char(a.col8) = to_char(b.col8);
exp tables=ARRAY_TEST_004_01 filetype=bin;
imp tables=ARRAY_TEST_004_01 filetype=bin;
select a.col7, b.col7 from ARRAY_TEST_004_01 a, ARRAY_TEST_004_01_bk b where 
to_char(a.col1) = to_char(b.col1)
and lengthb(to_char(a.col1)) = lengthb(to_char(b.col1))
and to_char(a.col2) = to_char(b.col2)
and to_char(a.col3) = to_char(b.col3)
and to_char(a.col4) = to_char(b.col4)
and lengthb(to_char(a.col4)) = lengthb(to_char(b.col4))
and to_char(a.col5) = to_char(b.col5)
and to_char(a.col6) = to_char(b.col6)
and to_char(a.col8) = to_char(b.col8);

--DTS2021033105JZE1P0K00
exp -v;