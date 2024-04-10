drop user if exists number_dts cascade;
create user number_dts identified by 'Changeme_123';
grant dba to number_dts;
conn number_dts/Changeme_123@127.0.0.1:1611

--datatype combine by sql_verify_select_rs_datatype
drop table if exists num_comb2;
create table num_comb2(c NUMBER not null);
insert into num_comb2 values(99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999);  
commit;
drop table if exists num_comb3;
create table num_comb3(c3 NUMBER2 not null);
insert into num_comb3 values(999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999);  
commit;
desc -q select * from num_comb2 union all select * from num_comb3 order by 1; --NUMBER and NUMBER2 -> NUMBER
desc -q select * from num_comb3 union all select * from num_comb2 order by 1;
select * from num_comb3 union all select * from num_comb2 order by 1;

drop table if exists num_comb1;
create table num_comb1(c2 BINARY(50) not null);
insert into num_comb1 values(900.98);
commit;
desc -q select * from num_comb2 union all select * from num_comb1 order by 1; --BINARY and NUMBER -> BINARY
desc -q select * from num_comb1 union all select * from num_comb2 order by 1;
select * from num_comb1 union all select * from num_comb2 order by 1;
desc -q select * from num_comb3 union all select * from num_comb1 order by 1; --BINARY and NUMBER2 -> BINARY
desc -q select * from num_comb1 union all select * from num_comb3 order by 1;
select * from num_comb1 union all select * from num_comb3 order by 1;

drop table if exists num_comb1;
create table num_comb1(c2 INT not null);
insert into num_comb1 values(-900); 
commit;
desc -q select * from num_comb2 union all select * from num_comb1 order by 1; --INT and NUMBER -> NUMBER
desc -q select * from num_comb1 union all select * from num_comb2 order by 1;
select * from num_comb1 union all select * from num_comb2 order by 1;
desc -q select * from num_comb3 union all select * from num_comb1 order by 1; --INT and NUMBER2 -> NUMBER2
desc -q select * from num_comb1 union all select * from num_comb3 order by 1;
select * from num_comb1 union all select * from num_comb3 order by 1;

drop table if exists num_comb1;
create table num_comb1(c2 BINARY_UINT32 not null);
insert into num_comb1 values(900); 
commit;
desc -q select * from num_comb2 union all select * from num_comb1 order by 1; --BINARY_UINT32 and NUMBER -> NUMBER
desc -q select * from num_comb1 union all select * from num_comb2 order by 1;
select * from num_comb1 union all select * from num_comb2 order by 1;
desc -q select * from num_comb3 union all select * from num_comb1 order by 1; --BINARY_UINT32 and NUMBER2 -> NUMBER2
desc -q select * from num_comb1 union all select * from num_comb3 order by 1;
select * from num_comb1 union all select * from num_comb3 order by 1;
drop table if exists num_comb1;
create table num_comb1(c2 varchar(30) not null);
insert into num_comb1 values('92000000000000000000'); 
commit;
desc -q select * from num_comb2 union all select * from num_comb1 order by 1; --STRING and NUMBER -> STRING
desc -q select * from num_comb1 union all select * from num_comb2 order by 1;
select * from num_comb1 union all select * from num_comb2 order by 1;
desc -q select * from num_comb3 union all select * from num_comb1 order by 1; --STRING and NUMBER2 -> STRING
desc -q select * from num_comb1 union all select * from num_comb3 order by 1;
select * from num_comb1 union all select * from num_comb3 order by 1;
drop table if exists num_comb1;
drop table if exists num_comb2;
drop table if exists num_comb3;

--DTS20210719074PEPP1D00
drop table if exists number2_datatype1;
create table number2_datatype1(number_col1 number2 PRIMARY KEY);
insert into number2_datatype1 values(1.234556);
insert into number2_datatype1 values(1.0E-130);
insert into number2_datatype1 values(-1.0E-130);
select * from number2_datatype1;
drop table if exists number2_datatype1;

--DTS202107200JF2FEP1400
select sin(cast(1.0E-127 as decimal));
desc -q select sin(cast(1.0E-127 as decimal));
select cos(cast(1.0E-127 as decimal));
select tan(cast(1.0E-127 as decimal));
select sin(cast(1.0E-130 as number2));
desc -q select sin(cast(1.0E-130 as number2));
select cos(cast(1.0E-130 as number2));
select tan(cast(1.0E-130 as number2));
select ln(cast(9.999999999999999999E-129 as number2));
select ceil(cast(9.9999999999E-128 as number));
select ceil(cast(9.9999999999E-128 as number2));
select round(cast(9.9999999999E-128 as number), 2);
select round(cast(9.9999999999E-128 as number2), 2);
select trunc(cast(9.9999999999E-128 as number), 2);
select trunc(cast(9.9999999999E-128 as number2), 2);
select round(cast(9.9999999999 as number), 2);
select round(cast(9.9999999999 as number2), 2);
select trunc(cast(9.9999999999 as number), 2);
select trunc(cast(9.9999999999 as number2), 2);

--DTS202107220LJXUKP1F00
drop table if exists tbl_number2_151;
create table tbl_number2_151(c NUMBER2 not null,b number2(10,2));
insert into tbl_number2_151 values(1.234,5.555);
insert into tbl_number2_151 values(-1.234,-5.555);
insert into tbl_number2_151 values(-1,100.111);
insert into tbl_number2_151 values(0,0);
select c,decode(c,-1,'A1',0,'B2','OK') "group" from tbl_number2_151 where b is not null order by 1;
drop table if exists tbl_number2_151;
drop table if exists tbl_number2_167;
create table tbl_number2_167(c NUMBER2 not null,b number2(10,2));
insert into tbl_number2_167 values(1.234,5.555);
select ln(b),ln(c) from tbl_number2_167;
drop table if exists tbl_number2_167;
drop table if exists tbl_number2_169;
create table tbl_number2_169(c NUMBER2 not null,b number2(10,2));
insert into tbl_number2_169 values(1.234,5.555);
select LOG(b,c) from tbl_number2_169;
drop table if exists tbl_number2_169;
drop table if exists tbl_number2_181;
create table tbl_number2_181(c NUMBER2 not null,b number2(10,2));
insert into tbl_number2_181 values(1.234,5.555);
insert into tbl_number2_181 values(-1.234,-5.555);
insert into tbl_number2_181 values(-1,100.111);
insert into tbl_number2_181 values(0,0);
insert into tbl_number2_181 values(0,null);
select REGEXP_COUNT(b,'[^,]+',1,'i') from tbl_number2_181;
drop table if exists tbl_number2_181;

select cast(true as number2);
select cast(true as float);
select abs(cast(-10 as number2));
desc -q select abs(cast(10 as number2));

select atan2(cast(-10 as number2), 0);
desc -q select atan2(cast(-10 as number2), 0);

select tanh(cast(-10 as number2));
desc -q select tanh(cast(-10 as number2));
select char_length('9.999999999999999999999999999999999999999E+123');
select char_length(cast(9.999999999999999999999999999999999999999E+123 as number2));
select cast(9.9999999999999999999999999999999999999999E+123 as number2);
select char_length(cast(9.888888888888888999999999999991237655555555555 as number2));
DROP TABLE IF EXISTS staffS_xian;
CREATE TABLE  staffS_xian
(
  staff_ID       NUMBER2(6) not null,
  inter          interval day(7) to second,
  EMAIL          VARCHAR2(25),
  pb             bool,
  HIRE_DATE      timestamp,
  employment_ID  NUMBER2[10],
  SALARY         double,
  MANAGER_ID     binary(20),
  section_ID     bigint,
  cb             clob,
  bb             blob,
  im             image
);
INSERT INTO  staffS_xian values (198, '1231 12:3:4.1234', 'wangying@126.com', 'true', to_timestamp('21-06-1999', 'dd-mm-yyyy'), array[1,2], 2600.00, '124', 50, to_clob('bonus 8000'), to_blob('a12'), '12345');
INSERT INTO  staffS_xian values (199, '1231 12:3:4.1234', 'hekaipng02@126.com', 'true', to_timestamp('13-01-2000', 'dd-mm-yyyy'), array[1,2], 2600.00, '124', 50, to_clob('bonus 8000'), null, '89345');
INSERT INTO  staffS_xian values (200, '-P99DT655M999.99999S', 'lirui03@126.com', 'false', to_timestamp('17-09-1987', 'dd-mm-yyyy'), array[3,2], 4400.00, '101', 10, null, to_blob('a56'), '128745');
commit;
SELECT staff_ID, DECODE (staff_ID, 198, 'A1', 199, 'B2', 'unknown') "GROUP" FROM staffS_xian WHERE staff_ID < 201   ORDER BY staff_ID;
SELECT inter, DECODE (inter, '1231 12:3:4.1234', 'A1', '-P99DT655M999.99999S', 'B2', 'unknown') "GROUP" FROM staffS_xian ORDER BY staff_ID;
SELECT pb, DECODE (pb, 'true', 'A1', 'false', 'B2', 'unknown') "GROUP" FROM staffS_xian ORDER BY staff_ID;
SELECT cb, DECODE (cb, to_clob('bonus 8000'), 'A1', null, 'B2', 'unknown') "GROUP" FROM staffS_xian ORDER BY staff_ID;
SELECT bb, DECODE (bb, to_blob('a12'), 'A1', null, 'B2', 'unknown') "GROUP" FROM staffS_xian ORDER BY staff_ID;
SELECT im, DECODE (im, '12345', 'A1', '1345', 'B2', 'unknown') "GROUP" FROM staffS_xian ORDER BY staff_ID;
SELECT employment_ID, DECODE (employment_ID, array[1,2], 'A1', array[3,2], 'B2', 'unknown') "GROUP" FROM staffS_xian ORDER BY staff_ID;--error
SELECT employment_ID, DECODE (employment_ID, 1, 'A1', 2, 'B2', 'unknown') "GROUP" FROM staffS_xian ORDER BY staff_ID;--error
SELECT employment_ID, DECODE (employment_ID[1], array[1,2], 'A1', array[3,2], 'B2', 'unknown') "GROUP" FROM staffS_xian ORDER BY staff_ID;--error
SELECT employment_ID, DECODE (employment_ID[1], 1, 10, array[1,2], 13, 'unknown') "GROUP" FROM staffS_xian ORDER BY staff_ID;--error
SELECT employment_ID, DECODE (employment_ID[1], 1, 10, 2, 13, 'unknown') "GROUP" FROM staffS_xian ORDER BY staff_ID;
desc -q SELECT employment_ID, DECODE (employment_ID[1], 1, 10, 2, 13, 'unknown') "GROUP" FROM staffS_xian ORDER BY staff_ID;
desc -q SELECT employment_ID, DECODE (employment_ID[1], 1, null)  "GROUP" FROM staffS_xian ORDER BY staff_ID;
SELECT SALARY, DECODE (SALARY, 2600.00, true, 3600.00, 'B2', false) "GROUP" FROM staffS_xian ORDER BY staff_ID;--error
SELECT SALARY, DECODE (SALARY, 2600.00, true, 3600.00, false, 'ok') "GROUP" FROM staffS_xian ORDER BY staff_ID;--error
SELECT SALARY, DECODE (SALARY, 5600.00, true, 3600.00, false, 'ok') "GROUP" FROM staffS_xian ORDER BY staff_ID;--error
SELECT SALARY, DECODE (SALARY, 2600.00, true, 4400.00, false, 'ok') "GROUP" FROM staffS_xian ORDER BY staff_ID;
desc -q SELECT SALARY, DECODE (SALARY, 2600.00, true, 4400.00, false, 'ok') "GROUP" FROM staffS_xian ORDER BY staff_ID;
SELECT SALARY, DECODE (SALARY, 2600.00, 100, 3600.00, 'a', 'ok') "GROUP" FROM staffS_xian ORDER BY staff_ID;
desc -q SELECT SALARY, DECODE (SALARY, 2600.00, 100, 3600.00, 'a', 'ok') "GROUP" FROM staffS_xian ORDER BY staff_ID;
DROP TABLE IF EXISTS staffS_xian;

select extract(year from cast(19910101 as number2));
select extract(year from to_clob('19900101'));
desc -q select extract(year from '19900101000001.123');
select extract(second from interval '-1 11:22:33.456' day to second);
desc -q select extract(second from interval '-1 11:22:33.456' day to second);

select ct_hash(cast(895687.89 as number2), 5);
select hash(cast(895687.89 as number2), cast(10 as number2), cast(56 as number2)) "A";
desc -q select hash(cast(895687.89 as number2), cast(10 as number2), cast(56 as number2)) "A";

select isnumeric(cast(895687.89 as number2));
select to_number(cast(1E-129 as number2));

select log(cast(1 as number2));
select log(cast(1 as number2), cast(4 as number2));
select log(cast(-1 as number2), cast(4 as number2));
select log(cast(0.5 as number2), cast(4 as number2));
select log(cast(0.5 as number2), cast(0 as number2));

select type_id2name(20034);
select type_id2name(20043);

drop table if exists test_alt;
create table test_alt(c2 number2);
alter table test_alt modify c2 number;
insert into test_alt values(1E126);
commit;
select * from test_alt;
drop table if exists test_alt;
create table test_alt(c2 number2);
insert into test_alt values(10); 
commit;
alter table test_alt modify c2 number;
alter table test_alt modify c2 number2(38);
drop table if exists test_alt;
create table test_alt(c2 number2(10));
insert into test_alt values(10); 
commit;
alter table test_alt modify c2 number2(5);
alter table test_alt modify c2 number2(20);
drop table if exists test_alt;
create table test_alt(c2 number2(10, 8));
insert into test_alt values(10.23); 
commit;
alter table test_alt modify c2 number2(10, 5);
alter table test_alt modify c2 number2(10, 9);
alter table test_alt modify c2 number2(20, 5);
alter table test_alt modify c2 number2(20, 10);
drop table if exists test_alt;

--DTS2021072608DKS0P0H00
drop table if exists TBL_NUMBER2_152;
create table tbl_number2_152(n1 NUMBER, n2 number(10,2), b1 NUMBER2, b2 number2(10,2));
select COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE from db_tab_columns where OWNER = 'NUMBER_DTS' and table_name = 'TBL_NUMBER2_152';
insert into tbl_number2_152 values(12.34, 12.56, 12.34, 12.56);
commit;
drop table if exists TBL_NUMBER2_153;
create table TBL_NUMBER2_153 (f1, f2, f3, f4) as select ifnull(n1, n1), ifnull(n2, n2), ifnull(b1, b1), ifnull(b2, b2) from tbl_number2_152;
select COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE from db_tab_columns where OWNER = 'NUMBER_DTS' and table_name = 'TBL_NUMBER2_153';
drop table if exists TBL_NUMBER2_152;
drop table if exists TBL_NUMBER2_153;

--DTS2021080522717
DROP TABLE IF EXISTS "TBL_NUMBER_100" CASCADE CONSTRAINTS;
CREATE TABLE "TBL_NUMBER_100"("COL_NUMBER1" NUMBER2);
INSERT INTO "TBL_NUMBER_100" ("COL_NUMBER1") values(-9.99999999999999999999999999999999999999900000E+125);
INSERT INTO "TBL_NUMBER_100" ("COL_NUMBER1") values(-10023);
INSERT INTO "TBL_NUMBER_100" ("COL_NUMBER1") values(9.999999999999999999999999999999999999999000000E+125);
COMMIT;
exec dbe_stats.collect_table_stats(schema=>'NUMBER_DTS', name=>'TBL_NUMBER_100',part_name=>null, sample_ratio=>100,method_opt=> 'for all columns');
select t.name,hh.col#,hh.MINVALUE,hh.MAXVALUE from SYS.SYS_HISTGRAM_ABSTR hh,SYS.sys_tables t where hh.tab#=t.id and t.name='TBL_NUMBER_100' and t.user# = (select id from sys.sys_users where name = 'NUMBER_DTS');

set serveroutput on;
DROP TABLE IF EXISTS "TBL_NUMBER_100" CASCADE CONSTRAINTS;
CREATE TABLE "TBL_NUMBER_100"("COL_NUMBER1" NUMBER2 primary key);
INSERT INTO "TBL_NUMBER_100" ("COL_NUMBER1") values(-9.99999999999999999999999999999999999999900000E+125);
begin 
INSERT INTO "TBL_NUMBER_100" ("COL_NUMBER1") values(-9.99999999999999999999999999999999999999900000E+125);
exception
 when others then
 SYS.dbe_output.print_line('error code: ' || SQL_ERR_CODE);
 SYS.dbe_output.print_line('error message: ' || left(SQL_ERR_MSG, 28)||right(SQL_ERR_MSG, 66));
 end;
/
INSERT INTO "TBL_NUMBER_100" ("COL_NUMBER1") values(9.999999999999999999999999999999999999999000000E+125);
begin 
INSERT INTO "TBL_NUMBER_100" ("COL_NUMBER1") values(9.999999999999999999999999999999999999999000000E+125);
exception
 when others then
 SYS.dbe_output.print_line('error code: ' || SQL_ERR_CODE);
 SYS.dbe_output.print_line('error message: ' || left(SQL_ERR_MSG, 28)||right(SQL_ERR_MSG, 66));
 end;
/
DROP TABLE IF EXISTS "TBL_NUMBER_100";
set serveroutput off;

drop table  if exists t_part_csf3;
create table T_PART_CSF3(id number2, name varchar2(100)) PARTITION BY range(id) interval(1E125)
(
partition p1 VALUES LESS THAN (6.999999999999999999999999999999999999999000000E+125),
partition p2 VALUES LESS THAN (7.999999999999999999999999999999999999999000000E+125),
partition p3 VALUES LESS THAN (8.999999999999999999999999999999999999999000000E+125)
);
insert into t_part_csf3 values(1, 'a');
insert into t_part_csf3 values(2, 'b');
commit;
select hh.name, hh.HIBOUNDLEN, hh.HIBOUNDVAL from sys.sys_table_parts hh, SYS.sys_tables t where hh.table#=t.id and t.name='T_PART_CSF3' and t.user# = (select id from sys.sys_users where name = 'NUMBER_DTS') order by 1;
update t_part_csf3 set id = (8.999999999999999999999999999999999999999000000E+125 :: number2) where id = 1;
select hh.name, hh.HIBOUNDLEN, hh.HIBOUNDVAL from sys.sys_table_parts hh, SYS.sys_tables t where hh.table#=t.id and t.name='T_PART_CSF3' and t.user# = (select id from sys.sys_users where name = 'NUMBER_DTS') order by 1;
update t_part_csf3 set id = (9.999999999999999999999999999999999999999000000E+125 :: number2) where id = 2; --expect error: part_get_interval_boundval
drop table if exists t_part_csf3;

drop table if exists test1;
create table test1(f1 number);
insert into test1 values(cast(1.1 as real));
commit;
select vsize(f1) from test1;
select * from test1 where f1 = 1.1;
drop table test1;

conn / as sysdba
drop user if exists number_dts cascade;