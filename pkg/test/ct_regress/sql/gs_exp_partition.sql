conn sys/Huawei@123@127.0.0.1:1611
DROP USER IF EXISTS exp_partition;
CREATE USER exp_partition identified by Changeme_123;
grant dba to exp_partition;
CONN exp_partition/Changeme_123@127.0.0.1:1611

drop table if exists t_partition_list;
create table t_partition_list(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10) not null,c_vchar2 varchar2(100),c_clob clob,
c_long varchar(200),c_blob blob,c_raw varchar(100),c_date date,c_timestamp timestamp)
PARTITION BY LIST(id,c_int)
(
PARTITION p1 VALUES ((1,1000),(2,2000),(3,3000)),
PARTITION p2 VALUES ((4,4000),(5,5000),(6,6000),(7,7000)),
PARTITION p3 VALUES ((8,8000),(9,9000),(10,10000),(11,11000),(12,12000))
);
insert into t_partition_list values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_partition_list values(5,5000,null,null,null,null,null,'M',null,null,null,null,null,null,null);
insert into t_partition_list values(8,8000,null,null,null,null,null,'M',null,null,null,null,null,null,null);
commit;

drop table if exists t_sigle_partition_list;
create table t_sigle_partition_list(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10) not null,c_vchar2 varchar2(100),c_clob clob,
c_long varchar(200),c_blob blob,c_raw varchar(100),c_date date,c_timestamp timestamp)
PARTITION BY LIST(id)
(
PARTITION p1 VALUES (1,2,3),
PARTITION p2 VALUES (4,5,6,7),
PARTITION p3 VALUES (8,9,10,11,12)
);
insert into t_sigle_partition_list values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),
lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_sigle_partition_list values(5,null,null,null,null,null,null,'M',null,null,null,null,null,null,null);
insert into t_sigle_partition_list values(8,null,null,null,null,null,null,'M',null,null,null,null,null,null,null);
commit;

drop table if exists t_sigle_subpartition_list;
create table t_sigle_subpartition_list(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10) not null,c_vchar2 varchar2(100),c_clob clob,
c_long varchar(200),c_blob blob,c_raw varchar(100),c_date date,c_timestamp timestamp)
PARTITION BY LIST(id) SUBPARTITION BY list(id)
(
PARTITION p1 VALUES (1,2,3) TABLESPACE "USERS" INITRANS 2 PCTFREE 8 (
subpartition p4 values(1,2) TABLESPACE "USERS",
subpartition p5 values(3) TABLESPACE "USERS") ,
PARTITION p2 VALUES (4,5,6,7) TABLESPACE "USERS" INITRANS 2 PCTFREE 8 (
subpartition p6 values(4,5) TABLESPACE "USERS",
subpartition p7 values(6,7) TABLESPACE "USERS") ,
PARTITION p3 VALUES (8,9,10,11,12) TABLESPACE "USERS" INITRANS 2 PCTFREE 8 (
subpartition p8 values(8,9) TABLESPACE "USERS",
subpartition p9 values(10,11) TABLESPACE "USERS") 
);
insert into t_sigle_subpartition_list values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),
to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_sigle_subpartition_list values(5,5000,null,null,null,null,null,'M',null,null,null,null,null,null,null);
insert into t_sigle_subpartition_list values(8,8000,null,null,null,null,null,'M',null,null,null,null,null,null,null);
commit;

drop table if exists t_mul_subpartition_list;
create table t_mul_subpartition_list(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10) not null,c_vchar2 varchar2(100),c_clob clob,
c_long varchar(200),c_blob blob,c_raw varchar(100),c_date date,c_timestamp timestamp)
PARTITION BY LIST(id,c_int) SUBPARTITION BY LIST(id,c_int)
(
PARTITION p1 VALUES ((1,1000),(2,2000),(3,3000)) (
subpartition p4 values((1,1000),(2,2000)),
subpartition p5 values((3,3000))),
PARTITION p2 VALUES ((4,4000),(5,5000),(6,6000),(7,7000)) (
subpartition p6 values((4,4000),(5,5000)),
subpartition p7 values((6,6000),(7,7000))),
PARTITION p3 VALUES ((8,8000),(9,9000),(10,10000),(11,11000),(12,12000)) (
subpartition p8 values((8,8000),(9,9000)),
subpartition p9 values((10,10000),(11,11000)))
);
insert into t_mul_subpartition_list values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),
to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_mul_subpartition_list values(5,5000,null,null,null,null,null,'M',null,null,null,null,null,null,null);
insert into t_mul_subpartition_list values(8,8000,null,null,null,null,null,'M',null,null,null,null,null,null,null);
commit;

show create table t_partition_list;
show create table t_sigle_subpartition_list;
show create table t_mul_subpartition_list;

exp tables=t_partition_list,t_sigle_subpartition_list,t_mul_subpartition_list file="t_partition_list.sql" filetype=txt;

select count(*) from t_partition_list;
select count(*) from t_sigle_subpartition_list;
select count(*) from t_partition_list;

drop table if exists t_partition_list;
drop table if exists t_sigle_subpartition_list;
drop table if exists t_mul_subpartition_list;
imp tables=t_partition_list,t_sigle_subpartition_list,t_mul_subpartition_list file="t_partition_list.sql" filetype=txt;

show create table t_partition_list;
show create table t_sigle_subpartition_list;
show create table t_mul_subpartition_list;

select count(*) from t_partition_list;
select count(*) from t_sigle_subpartition_list;
select count(*) from t_partition_list;

drop table if exists test_subpart_range;
create table test_subpart_range(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
),
partition p2 values less than(100)
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
)
);

drop table if exists test_subpart_hash;
create table test_subpart_hash(id int, name varchar(20)) partition by list(id) subpartition by hash(name)
(
partition p1 values(1, 2, 3)
(
subpartition p11,
subpartition p12
),
partition p2 values(4, 5, 6)
(
subpartition p21,
subpartition p22
)
);

drop table if exists test_subpart_hash_range;
create table test_subpart_hash_range(id int, name varchar(20)) partition by hash(name) subpartition by range(id)
(
partition p1
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
),
partition p2
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
)
);

drop table if exists test_subpart_hash_list;
create table test_subpart_hash_list(id int, name varchar(20)) partition by hash(name) subpartition by list(id)
(
partition p1
(
subpartition p11 values(1, 2, 3),
subpartition p12 values(4, 5, 6)
),
partition p2
(
subpartition p21 values(1, 2, 3),
subpartition p22 values(4, 5, 6)
)
);

drop table if exists test_subpart_range_range;
create table test_subpart_range_range(id int, c_id int, name varchar(20)) partition by range(id) interval(50) subpartition by range(c_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
),
partition p2 values less than(100)
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
)
);

drop table if exists test_interval;
create table test_interval(id int) PARTITION BY RANGE(ID) INTERVAL(50) SUBPARTITION BY RANGE(id)
(
PARTITION P1 VALUES LESS THAN(50)
(
SUBPARTITION p2 VALUES LESS THAN (2),
SUBPARTITION p3 VALUES LESS THAN (4),
SUBPARTITION P4 VALUES LESS THAN(MAXVALUE)
)
);

exp tables=% file="t_partition_com1.sql" filetype=txt;
imp tables=% file="t_partition_com1.sql" filetype=txt;

exp tables=% file="t_partition_com2.sql" filetype=bin;
imp tables=% file="t_partition_com2.sql" filetype=bin;

exp tables=% file="t_partition_com3.sql" filetype=txt CONSISTENT=Y;
imp tables=% file="t_partition_com3.sql" filetype=txt;
imp tables=% file="t_partition_com3.sql" filetype=txt DDL_PARALLEL=4 PARALLEL=4;

exp tables=% file="t_partition_com4.sql" filetype=bin CONSISTENT=Y;
imp tables=% file="t_partition_com4.sql" filetype=bin;

show create table t_partition_list;
show create table t_sigle_subpartition_list;
show create table t_mul_subpartition_list;

select count(*) from t_partition_list;
select count(*) from t_sigle_subpartition_list;
select count(*) from t_partition_list;

exp tables=% file="t_partition_com5.sql" filetype=txt PARALLEL=4;

exp tables=% file="t_partition_com6.sql" filetype=bin PARALLEL=4 CONSISTENT=Y;

drop table if exists tab_list_list_partition_001; 
create table tab_list_list_partition_001(  
COL_1 bigint not null,  
COL_2 TIMESTAMP WITHOUT TIME ZONE,  
COL_3 bool, 
COL_4 decimal, 
COL_5 text, 
COL_6 smallint, 
COL_7 char(30), 
COL_8 double precision, 
COL_9 longtext, 
COL_10 character varying(30), 
COL_11 bool , 
COL_12 bytea , 
COL_13 real , 
COL_14 numeric , 
COL_15 blob , 
COL_16 integer , 
COL_17 int , 
COL_18 TIMESTAMP WITH TIME ZONE , 
COL_19 binary_integer , 
COL_20 interval day to second , 
COL_21 boolean,  
COL_22 nchar(30), 
COL_23 binary_bigint, 
COL_24 nchar(100), 
COL_25 character(1000),  
COL_26 text, 
COL_27 float, 
COL_28 double, 
COL_29 bigint, 
COL_30 TIMESTAMP WITH LOCAL TIME ZONE , 
COL_31 TIMESTAMP, 
COL_32 image, 
COL_33 interval year to month, 
COL_34 character(30), 
COL_35 smallint, 
COL_36 blob, 
COL_37 char(300), 
COL_38 float, 
COL_39 raw(100), 
COL_40 clob , 
COL_41 binary_double, 
COL_42 number(6,2), 
COL_43 decimal(6,2), 
COL_44 varchar2(50), 
COL_45 varchar(30), 
COL_46 nvarchar2(100), 
COL_47 numeric(12,6), 
COL_48 nvarchar(30), 
COL_49 date, 
COL_50 image , 
COL_51 integer, 
COL_52 binary_double, 
COL_53 decimal(12,6), 
COL_54 raw(8000), 
COL_55 clob, 
COL_56 varchar2(8000), 
COL_57 datetime, 
COL_58 number(12,6), 
COL_59 nvarchar2(4000), 
COL_60 varbinary(2000) , 
COL_61 binary(200), 
COL_62 datetime, 
COL_63 binary(100), 
COL_64 varchar(1000), 
COL_65 date, 
 primary key(COL_1) 
)
PARTITION BY LIST(COL_1) SUBPARTITION BY LIST(COL_1)
(
PARTITION PART_1 VALUES(default) 
(SUBPARTITION P1_1 VALUES(0,200),
 SUBPARTITION P1_2 VALUES(201,300),
 SUBPARTITION P1_3 VALUES(301,400),
 SUBPARTITION P1_4 VALUES(401,500),
 SUBPARTITION P1_5 VALUES(501,600),
 SUBPARTITION P1_6 VALUES(601,700),
 SUBPARTITION P1_7 VALUES(701,800),
 SUBPARTITION P1_8 VALUES(801,900),
 SUBPARTITION P1_9 VALUES(901,1000),
 SUBPARTITION P1_10 VALUES(default)
)
)
; 

show create table tab_list_list_partition_001;
exp tables=tab_list_list_partition_001 file="tab_list_list_partition1.sql" filetype=txt;
imp tables=tab_list_list_partition_001 file="tab_list_list_partition1.sql" filetype=txt;
exp tables=tab_list_list_partition_001 file="tab_list_list_partition2.sql" filetype=txt CONSISTENT=Y;
imp tables=tab_list_list_partition_001 file="tab_list_list_partition2.sql" filetype=txt;

conn sys/Huawei@123@127.0.0.1:1611
DROP USER IF EXISTS exp_partition CASCADE;

drop table if exists T_SINGLE_PARTITION_001;
CREATE TABLE "T_SINGLE_PARTITION_001"
(
  "ID" BINARY_INTEGER,
  "C_INT" BINARY_INTEGER,
  "C_REAL" BINARY_DOUBLE,
  "C_FLOAT" BINARY_DOUBLE,
  "C_DECIMAL" NUMBER,
  "C_NUMBER" NUMBER,
  "C_CHAR" CHAR(10 BYTE),
  "C_VCHAR" VARCHAR(20 BYTE) NOT NULL,
  "C_VCHAR2" VARCHAR(100 BYTE),
  "C_CLOB" CLOB,
  "C_LONG" VARCHAR(200 BYTE),
  "C_BLOB" BLOB,
  "C_RAW" RAW(100),
  "C_DATE" DATE,
  "C_TIMESTAMP" TIMESTAMP(6)
);
show create table T_SINGLE_PARTITION_001;select 1;
drop table if exists T_SINGLE_PARTITION_001;

