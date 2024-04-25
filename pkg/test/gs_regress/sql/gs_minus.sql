drop table if exists t_minus_1;
drop table if exists t_minus_2;
drop table if exists t_minus_3;
drop table if exists t_minus_4;
drop table if exists t_all_join_03_010;
create table t_all_join_03_010(c1 clob,c2 varchar(6));
create table t_minus_1(f_int1 int, f_int2 int);
create table t_minus_2(f_int1 int, f_int2 int);
create table t_minus_3(f_int1 int, f_int2 int);
create table t_minus_4(f_int1 int, f_int2 int);
insert into t_minus_1 values(1, 11);
insert into t_minus_1 values(3, 332);
insert into t_minus_1 values(1, 11);
insert into t_minus_1 values(3, 33);
insert into t_minus_1 values(2, 22);
insert into t_minus_1 values(3, 33);
insert into t_minus_1 values(1, 11);
insert into t_minus_1 values(5, 55);
insert into t_minus_2 values(2, 22);
insert into t_minus_2 values(4, 44);
insert into t_minus_2 values(2, 22);
insert into t_minus_2 values(4, 44);
insert into t_minus_2 values(5, 54);
insert into t_minus_2 values(5, 55);
insert into t_minus_2 values(6, 66);
insert into t_minus_3 values(3, 33);
insert into t_minus_1 values(2, 22);
insert into t_minus_2 values(2, 22);
insert into t_all_join_03_010 values('aab','aab');
commit;

-- syntax error
select f_int1, f_int2 from t_minus_1 minus select f_int1 from t_minus_2;
select f_int1, f_int2 from t_minus_1 order by f_int1 minus select f_int1, f_int2 from t_minus_2;
(select f_int1, f_int2 from t_minus_1 order by f_int1) minus select f_int1, f_int2 from t_minus_2 order by 1,2;
(select f_int1, f_int2 from t_minus_1 minus select f_int1, f_int2 from t_minus_2 order by f_int1 desc) minus select f_int1, f_int2 from t_minus_2;
select f_int1, f_int2 from t_minus_1 minus (select f_int1, f_int2 from t_minus_2 order by f_int1 desc) order by 1,2;

-- simple minus
select f_int1, f_int2 from t_minus_1 minus select f_int1, f_int2 from t_minus_2 order by 1,2;
select f_int1, f_int2 from t_minus_1 minus select f_int1, f_int2 from t_minus_2 order by f_int1 desc, f_int2;
-- zenith is correct, oracle is incorrect
select * from t_minus_1 minus select * from t_minus_2 order by f_int1 desc, f_int2;

-- complex minus
(select * from t_minus_1 minus select * from t_minus_2) minus select * from t_minus_2 order by 1,2;
((select * from t_minus_1 minus select * from t_minus_2) minus select * from t_minus_2) minus select * from t_minus_2 order by 1,2;
(select * from t_minus_1 minus select * from t_minus_2) minus (select * from t_minus_1 minus select * from t_minus_2) order by 1,2;

select * from t_minus_1 minus select * from t_minus_2 union select * from t_minus_3 order by 1,2;
(select * from t_minus_1 minus select * from t_minus_2) union select * from t_minus_3 order by 1,2;
select * from t_minus_1 minus (select * from t_minus_2 union select * from t_minus_3) order by 1,2;

select * from t_minus_1 minus select * from t_minus_2 union all select * from t_minus_3 order by 1,2;
(select * from t_minus_1 minus select * from t_minus_2) union all select * from t_minus_3 order by 1,2;
select * from t_minus_1 minus (select * from t_minus_2 union all select * from t_minus_3) order by 1,2;

select distinct f_int1, f_int2 from t_minus_1 minus select f_int1, f_int2 from t_minus_2 order by 1,2;

-- simple except
select f_int1, f_int2 from t_minus_1 except select f_int1, f_int2 from t_minus_2 order by 1,2;
select f_int1, f_int2 from t_minus_1 except all select f_int1, f_int2 from t_minus_2 order by f_int1 desc, f_int2;
select c1 from t_all_join_03_010 except select c2 from t_all_join_03_010;
(select f_int1, f_int2 from t_minus_1 order by f_int1) except (select f_int1, f_int2 from t_minus_2 order by f_int1 desc) order by 1,2;

-- complex except
(select * from t_minus_1 except select * from t_minus_2) except select * from t_minus_2 order by 1,2;
((select * from t_minus_1 except select * from t_minus_2) except select * from t_minus_2) except select * from t_minus_2 order by 1,2;
(select * from t_minus_1 except select * from t_minus_2) except (select * from t_minus_1 except select * from t_minus_2) order by 1,2;

-- complex except all
(select * from t_minus_1 except all select * from t_minus_2) except select * from t_minus_2 order by 1,2;
select * from t_minus_1 except all (select * from t_minus_1 where f_int1<2) order by 1,2;
select * from t_minus_1 except all (select * from t_minus_4) order by 1,2;
select count(*) from (((select * from t_minus_1) union all (select * from t_minus_1)) except all select distinct * from t_minus_1) t;
select count(*) from (((select f_int1, f_int2 from t_minus_1) union all (select f_int1, f_int2 from t_minus_1)) except all (select f_int1, f_int2 from t_minus_1  order by 1,2 limit 2 offset 3)) t;

-- intersect
select f_int1, f_int2 from t_minus_1 intersect select f_int1, f_int2 from t_minus_2 order by 1,2;
select f_int1, f_int2 from t_minus_1 intersect all select f_int1, f_int2 from t_minus_2 order by f_int1 desc, f_int2;
select f_int1, f_int2 from t_minus_1 intersect select f_int1, f_int2 from t_minus_4 order by 1,2;

-- complex intersect
(select * from t_minus_1 intersect select * from t_minus_2) intersect select * from t_minus_2 order by 1,2;
((select * from t_minus_1 intersect all select * from t_minus_2) intersect all select * from t_minus_2) intersect all select * from t_minus_2 order by 1,2;
((select * from t_minus_1 intersect all select * from t_minus_2) intersect all select * from t_minus_2) except select * from t_minus_2 order by 1,2;
select count(*) from (((select * from t_minus_1) union all (select * from t_minus_1)) intersect all select * from t_minus_1 where f_int1<3 except all select * from t_minus_1 where f_int1=3) t;

drop table t_minus_1;
drop table t_minus_2;
drop table t_minus_3;

DROP TABLE IF EXISTS MINUS_T1;
DROP TABLE IF EXISTS MINUS_T2;
CREATE TABLE MINUS_T1(a int, b varchar(20));
CREATE TABLE MINUS_T2(a int, b varchar(20));
insert into MINUS_T1 values(1, '1');
insert into MINUS_T1 values(1, '1');
insert into MINUS_T1 values(2, null);
insert into MINUS_T1 values(2, null);
insert into MINUS_T1 values(null, null);
insert into MINUS_T1 values(null, null);
insert into MINUS_T1 values(null, '2');
insert into MINUS_T1 values(null, '2');
insert into MINUS_T1 values(1, '3');
insert into MINUS_T1 values(1, '3');
insert into MINUS_T1 values(2, '3');
insert into MINUS_T2 values(1, '1');
insert into MINUS_T2 values(1, null);
insert into MINUS_T2 values(2, null);
insert into MINUS_T2 values(null, '2');
insert into MINUS_T2 values(null, null);
insert into MINUS_T2 values(3, 1);
commit;

select * from MINUS_T1 MINUS select * from MINUS_T2 order by 1,2;
select a, b from MINUS_T1 MINUS select b, a from MINUS_T2 order by 1,2;
select * from MINUS_T1 EXCEPT ALL select * from MINUS_T2 order by 1,2;
select a, b from MINUS_T1 EXCEPT ALL select b, a from MINUS_T2 order by 1,2;
select * from MINUS_T1 INTERSECT select * from MINUS_T2 order by 1,2;
select a,b from MINUS_T1 INTERSECT select b,a from MINUS_T2 order by 1,2;
select * from MINUS_T1 INTERSECT ALL select * from MINUS_T2 order by 1,2;
select a,b from MINUS_T1 INTERSECT ALL select b,a from MINUS_T2 order by 1,2;

DROP TABLE MINUS_T1;
DROP TABLE MINUS_T2;

--bugfix: external table minus
drop table if exists external_table_001;
CREATE OR REPLACE DIRECTORY external_table_directory as '/home/regress/CantianKernel/pkg/test/gs_regress/data';
CREATE TABLE external_table_001
(
C_ID INT,
C_D_ID bigint NOT NULL,
C_W_ID tinyint unsigned NOT NULL,
C_FIRST VARCHAR(64) NOT NULL,
C_MIDDLE CHAR(2),
C_LAST VARCHAR(64) NOT NULL,
C_STREET_1 VARCHAR(20) NOT NULL,
C_STREET_2 VARCHAR(20),
C_CITY VARCHAR(20) NOT NULL,
C_STATE CHAR(2) NOT NULL,
C_ZIP CHAR(9) NOT NULL,
C_PHONE CHAR(16) NOT NULL,
C_SINCE TIMESTAMP,
C_CREDIT CHAR(2) NOT NULL,
C_CREDIT_LIM NUMERIC(12,2),
C_DISCOUNT NUMERIC(4,4),
C_BALANCE NUMERIC(12,2),
C_YTD_PAYMENT REAL NOT NULL,
C_PAYMENT_CNT NUMBER NOT NULL,
C_DELIVERY_CNT BOOL NOT NULL,
C_END DATE NOT NULL,
C_VCHAR VARCHAR(1000),
C_VARCHAR1 VARCHAR2(3000),
C_VARCHAR2 VARCHAR2(3000),
C_VARCHAR3 VARCHAR2(3000),
C_VARCHAR4 VARCHAR2(3000),
C_VARCHAR5 VARCHAR2(100 BYTE) ,
C_FLOAT FLOAT ,
C_DOUBLE DOUBLE ,
C_DECIMAL DECIMAL ,
C_BINARY BINARY(100) ,
C_VARBINARY VARBINARY(100) ,
C_BOOLEAN BOOLEAN ,
C_RAW RAW(100)
)
ORGANIZATION EXTERNAL
(
TYPE LOADER
DIRECTORY external_table_directory
ACCESS PARAMETERS
    (
    RECORDS DELIMITED BY newline
    FIELDS TERMINATED BY ','
    )
    LOCATION 'external.sql'
);
select count(1) from external_table_001;
select * from external_table_001 except select * from external_table_001;
select count(1) from (select * from external_table_001 minus select * from external_table_001);
select count(1) from (select * from external_table_001 union select * from external_table_001);
select count(1) from (select * from external_table_001 intersect select * from external_table_001);

create table t_minus_1 as select * from external_table_001;
create table t_minus_2 as select * from external_table_001;
select count(1) from (select * from t_minus_1 union select * from external_table_001);
select count(1) from (select * from t_minus_1 except select * from external_table_001);
select count(1) from (select * from t_minus_1 except all select * from external_table_001);
select count(1) from (select * from t_minus_1 intersect select * from external_table_001);
select count(1) from (select * from t_minus_1 union select * from external_table_001);
select count(1) from (select * from t_minus_1 minus select * from t_minus_2);
select count(1) from (select * from t_minus_1 intersect select * from t_minus_2);

drop table external_table_001;
drop table t_minus_1;
drop table t_minus_2;
drop DIRECTORY external_table_directory;
