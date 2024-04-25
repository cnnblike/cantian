conn / as  sysdba 
drop table if exists tbl_008 ;
CREATE TABLESPACE tp_08 DATAFILE 'tp_08_1' SIZE 32M autoextend on next 32M;
create table tbl_008
(
c_id int,
CAOC clob,
CAOB blob
) 
partition by range(c_id)
(partition part_1 values less than(10000) tablespace tp_08,
partition part_2 values less than(100000) tablespace tp_08,
partition part_3 values less than(maxvalue) tablespace tp_08);
insert into tbl_008 values (5,'ghjghjkghjk','0x1245653');
insert into tbl_008 values (500000,'ghjghjkghjk','0x1245653');
select owner,partition_name,tablespace_name from adm_segments where partition_name like '%CAO%' order by partition_name;
drop table tbl_008 ;
drop tablespace tp_08 INCLUDING CONTENTS AND DATAFILES;
conn / as sysdba
drop table if exists t_par_tab_idx_0001;
CREATE TABLE t_par_tab_idx_0001
(id int,
c_int int,c_int2 int,c_int3 int,
c_vchar varchar(100),c_vchar2 varchar(100),c_vchar3 varchar(100),
c_char char(100),c_char2 char(100),c_char3 char(850),
c_clob clob,c_blob blob,c_date date)
PARTITION BY HASH (c_int)
(
partition t_par_tab_idx_0001_P_50 storage( initial 64K next 1M ),
partition t_par_tab_idx_0001_P_100,
partition t_par_tab_idx_0001_P_150
);
alter table t_par_tab_idx_0001 add partition p_max storage( initial 64K next 1M );
alter table t_par_tab_idx_0001 add partition p_max *;
alter table t_par_tab_idx_0001 add partition p_max +;
drop table if exists t_par_tab_idx_0001;
drop table if exists t_order_base_000;
drop table if exists t_ct_sub_022;
CREATE TABLE t_order_base_000("ID" INT NOT NULL, "CHR_FIELD" VARCHAR(30), VALUECOL NUMBER);
insert into t_order_base_000 select rownum, decode(mod(rownum, 2), 0, NULL, rpad('CHR_', 10, chr(rownum + 64))), decode(mod(rownum, 3), 0, NULL, rownum * 10000) from dual connect by rownum < 6;
commit;
create table t_ct_sub_022 PARTITION BY HASH (VALUECOL) (partition p1,partition p2,partition p3) as select CHR_FIELD,VALUECOL from (select * from t_order_base_000 where CHR_FIELD like '%' or VALUECOL is null or VALUECOL is not null) order by 2 nulls first,1 nulls first;
SELECT TABLE_NAME,PARTITIONING_TYPE ,PARTITION_COUNT from USER_PART_TABLES where table_name='T_CT_SUB_022';
SELECT TABLE_NAME,PARTITION_NAME,TABLESPACE_NAME FROM all_TAB_PARTITIONS where table_name='T_CT_SUB_022' order by PARTITION_NAME;
select * from t_order_base_000;
select * from t_ct_sub_022;
drop table  if exists t_ct_sub_027;
create table t_ct_sub_027 PARTITION BY list (id) 
(
partition p1 values (1),
partition p2 values (2),
partition p3 values (3),
partition p4 values (default)
) as select * from t_order_base_000;
select * from t_order_base_000;
select * from t_ct_sub_027;
SELECT TABLE_NAME,PARTITIONING_TYPE ,PARTITION_COUNT from USER_PART_TABLES where table_name='T_CT_SUB_027';
SELECT TABLE_NAME,PARTITION_NAME,TABLESPACE_NAME FROM all_TAB_PARTITIONS where table_name='T_CT_SUB_027' order by PARTITION_NAME;
drop table  if exists t_ct_sub_028;
create table t_ct_sub_028 PARTITION BY range (id) 
(
partition p1  VALUES LESS THAN  (10),
partition p2  VALUES LESS THAN  (20),
partition p3  VALUES LESS THAN  (30),
partition p4  VALUES LESS THAN  (MAXVALUE)
) as select * from t_order_base_000;
select * from t_order_base_000;
select * from t_ct_sub_028;
SELECT TABLE_NAME,PARTITIONING_TYPE ,PARTITION_COUNT from USER_PART_TABLES where table_name='T_CT_SUB_028';
SELECT TABLE_NAME,PARTITION_NAME,TABLESPACE_NAME FROM all_TAB_PARTITIONS where table_name='T_CT_SUB_028' order by PARTITION_NAME;
drop table  if exists t_ct_sub_029;
create table t_ct_sub_029 PARTITION BY range (id) interval (10) 
(
partition p1  VALUES LESS THAN  (10),
partition p2  VALUES LESS THAN  (20),
partition p3  VALUES LESS THAN  (30)
) as select * from t_order_base_000;
select * from t_order_base_000;
select * from t_ct_sub_029;
SELECT TABLE_NAME,PARTITIONING_TYPE ,PARTITION_COUNT from USER_PART_TABLES where table_name='T_CT_SUB_029';
SELECT TABLE_NAME,PARTITION_NAME,TABLESPACE_NAME FROM all_TAB_PARTITIONS where table_name='T_CT_SUB_029' order by PARTITION_NAME;
drop table  if exists t_ct_sub_029;
drop table  if exists t_ct_sub_028;
drop table  if exists t_ct_sub_027;
drop table  if exists t_ct_sub_022;
drop table  if exists t_order_base_000;
create table test_part_t4_08(f1 int, f2 real, f3 number, f4 char(5), f5 varchar(5), f6 date, f7 timestamp)
 PARTITION BY RANGE(f1,f2,f2, f3, f4, f5, f6, f7)
 (
  PARTITION p1 values less than(10, 15.6,15.6, 28.5, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),
  PARTITION p2 values less than(20, 16.6,16.6, 29.5, 'efgh', 'efgh', to_date('2018/01/25', 'YYYY/MM/DD'), to_timestamp('2018-01-24 17:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),
  PARTITION p3 values less than(30, 17.6,17.6, 30.5, 'jkla', 'jkla', to_date('2018/01/26', 'YYYY/MM/DD'), to_timestamp('2018-01-24 18:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),
  PARTITION p4 values less than(40, 18.6,18.6, 31.5, 'zxv', 'zxv',   to_date('2018/01/27', 'YYYY/MM/DD'), to_timestamp('2018-01-24 19:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),
  PARTITION p5 values less than(MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE)
 );
drop table if exists test_part_t1;
create table test_part_t1(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);

drop table if exists test_part_t2;
create table test_part_t2(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p1 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);

drop table if exists test_part_t3;
create table test_part_t3(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(30),
 PARTITION p2 values less than(40),
 PARTITION p3 values less than(20),
 PARTITION p4 values less than(MAXVALUE)
);

drop table if exists test_part_t4;
create table test_part_t4(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f1,f2, f3, f4, f5, f6, f7)
(
 PARTITION p1 values less than(10, 15.6, 28.5, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),
 PARTITION p2 values less than(20, 16.6, 29.5, 'efgh', 'efgh', to_date('2018/01/25', 'YYYY/MM/DD'), to_timestamp('2018-01-24 17:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),
 PARTITION p3 values less than(30, 17.6, 30.5, 'jkla', 'jkla', to_date('2018/01/26', 'YYYY/MM/DD'), to_timestamp('2018-01-24 18:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),
 PARTITION p4 values less than(40, 18.6, 31.5, 'zxv', 'zxv',   to_date('2018/01/27', 'YYYY/MM/DD'), to_timestamp('2018-01-24 19:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),
 PARTITION p5 values less than(MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE)
);

drop table if exists test_part_t5;
create table test_part_t5(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f1,f2, f3, f4, f5, f6, f7)
(
 PARTITION p1 values less than(30, 17.6, 30.5, 'jkla', 'jkla', to_date('2018/01/26', 'YYYY/MM/DD'), to_timestamp('2018-01-24 18:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),
 PARTITION p2 values less than(10, 15.6, 28.5, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),
 PARTITION p3 values less than(20, 16.6, 29.5, 'efgh', 'efgh', to_date('2018/01/25', 'YYYY/MM/DD'), to_timestamp('2018-01-24 17:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),
 PARTITION p4 values less than(40, 18.6, 31.5, 'zxv', 'zxv',   to_date('2018/01/27', 'YYYY/MM/DD'), to_timestamp('2018-01-24 19:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),
 PARTITION p5 values less than(MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE)
);

drop table if exists test_part_t6;
create table test_part_t6(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
partition by list(f1)
(
partition p1 values (1,2,3,4,5),
partition p2 values (6,7,8,9,10),
partition p3 values (11,12,13),
partition p4 values (default)
);

drop table if exists test_part_t7;
create table test_part_t7(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
partition by list(f1)
(
partition p1 values (1,2,3,4,5),
partition p2 values (6,7,8,9,10),
partition p3 values (11,12,13),
partition p2 values (default)
);

drop table if exists test_part_t8;
create table test_part_t8(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
partition by list(f1)
(
partition p1 values (1,2,3,4,5),
partition p2 values (6,7,8,9,10),
partition p3 values (11,12,8),
partition p4 values (default)
);

drop table if exists test_part_t9;
create table test_part_t9(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
partition by list(f1,f2,f3,f4,f5,f6,f7)
(
partition p1 values ((10, 15.6, 28.5, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),(40, 18.6, 31.5, 'zxv', 'zxv',   to_date('2018/01/27', 'YYYY/MM/DD'), to_timestamp('2018-01-24 19:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'))),
partition p2 values (default)
);

drop table if exists test_part_t10;
create table test_part_t10(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
partition by list(f1,f2,f3,f4,f5,f6,f7)
(
partition p1 values ((10, 15.6, 28.5, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),(40, 18.6, 31.5, 'zxv', 'zxv',   to_date('2018/01/27', 'YYYY/MM/DD'), to_timestamp('2018-01-24 19:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'))),
partition p2 values ((20, 16.6, 29.5, 'efgh', 'efgh', to_date('2018/01/25', 'YYYY/MM/DD'), to_timestamp('2018-01-24 17:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),(40, 18.6, 31.5, 'zxv', 'zxv',   to_date('2018/01/27', 'YYYY/MM/DD'), to_timestamp('2018-01-24 19:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'))),
partition p3 values (default)
);

drop table if exists test_part_t11;
create table test_part_t11(f1 clob)
partition by list(f1)
(
partition p1 values ('abc','123'),
partition p2 values (default)
);

drop table if exists test_part_t12;
create table test_part_t12(f1 varchar2(2))
partition by list(f1)
(
partition p1 values ('abc','123'),
partition p2 values (default)
);

drop table if exists test_part_t13;
create table test_part_t13(f1 varchar2(2),f2 varchar2(2))
partition by list(f1,f2)
(
partition p1 values (('ab','123')),
partition p2 values (default)
);

drop table if exists test_part_t14;
create table test_part_t14(f1 varchar2(2),f2 varchar2(2))
partition by range(f1)
(
partition as1 values less than('abc'),
);

drop table if exists test_part_t15;
create table test_part_t15(f1 varchar2(2),f2 varchar2(2))
partition by range(f1,f2)
(
partition as1 values less than('ab','123'),
);

create index idx_t9_1 on test_part_t9(f1,f2) parallel 4;
create index idx_t9_2 on test_part_t9(f2,f3) local parallel 4;
create index idx_t9_3 on test_part_t9(f3,f4) local
(
partition p1 tablespace sp1,
partition p2 tablespace sp1
);

create index idx_t9_4 on test_part_t9(f3,f4)
(
partition p1 tablespace sp1,
partition p2 tablespace sp1
);

create index idx_t9_5 on test_part_t9(f3,f4) local
(
partition p1,
partition p1
);

select * from dba_tab_partitions where table_name like 'TEST_PART_%' order by TABLE_OWNER, TABLE_NAME, PARTITION_NAME;

create user test_partition_user_001 identified by Root1234;
grant create session to test_partition_user_001;
drop table if exists test_partition_user_001.test_part_t1;
create table test_partition_user_001.test_part_t1(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);

conn test_partition_user_001/Root1234@127.0.0.1:1611
select * from user_tab_partitions order by TABLE_NAME, PARTITION_NAME;

conn sys/Huawei@123@127.0.0.1:1611
drop table if exists test_partition_user_001.test_part_t1;
drop user test_partition_user_001 cascade;

create index idx_t1_1 on test_part_t1(f2,f3);
create index idx_t1_2 on test_part_t1(f4,f5) local;
insert into test_part_t1 values(5, 15, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(6, 16, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(16, 26, 39, '26', '39', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(26, 36, 49, '36', '49', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(36, 46, 59, '46', '59', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(46, 56, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
update test_part_t1 set f1 = 15 where f1=46;
update test_part_t1 set f1 = 56 where f1=46;
delete from test_part_t1 where f1=56;
select * from test_part_t1 order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t1 where f1 = 16 order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t1 where f1 > 16 order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t1 where f1 >= 16 order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t1 where f1 is null order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t1 where f4='abcd' and f5='abcd' order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t1 where f4='16' and f5='29' and f2=16 and f3=29 order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t1 where f4='16' and f5='29' and f2=16 and f3=29 and f1 <10 order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t1 where f4='16' and f5='29' and f2=16 and f3=29 and f1 =6 order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t1 where f4='16' and f5='29' and f2=16 and f3=29 and (f1 =6 or f1=26) order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t1 where f4 >='16' and f5 >='29' and (f2=16 or f2=36) and (f3=29 or f3 = 49) and (f1 =6 or f1=26) order by f1,f2,f3,f4,f5,f6,f7;

create index idx_t6_1 on test_part_t6(f2,f3);
create index idx_t6_2 on test_part_t6(f4,f5) local;
insert into test_part_t6 values(1, 15, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t6 values(2, 16, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t6 values(7, 26, 39, '26', '39', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t6 values(8, 36, 49, '36', '49', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t6 values(12, 46, 59, '46', '59', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t6 values(13, 56, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
update test_part_t6 set f1 = 15 where f1=8;
update test_part_t6 set f1 = 9 where f1=8;
delete from test_part_t6 where f1=9;
select * from test_part_t6 order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t6 where f1 = 11 order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t6 where f1 > 6 order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t6 where f1 >= 6 order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t6 where f4='abcd' and f5='abcd' order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t6 where f4='16' and f5='29' and f2=16 and f3=29 order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t6 where f4='16' and f5='29' and f2=16 and f3=29 and f1 <10 order by f1,f2,f3,f4,f5,f6,f7;
explain plan for select * from test_part_t6 where f4='16' and f5='29' and f2=16 and f3=29 and f1 <10;
select * from test_part_t6 where f4='16' and f5='29' and f2=16 and f3=29 and f1 =6 order by f1,f2,f3,f4,f5,f6,f7;
explain plan for select * from test_part_t6 where f4='16' and f5='29' and f2=16 and f3=29 and f1 =6;
select * from test_part_t6 where f4='16' and f5='29' and f2=16 and f3=29 and (f1 =6 or f1=5) order by f1,f2,f3,f4,f5,f6,f7;
select * from test_part_t6 where f4 >='16' and f5 >='29' and (f2=16 or f2=36) and (f3=29 or f3 = 49) and (f1 =6 or f1=3) order by f1,f2,f3,f4,f5,f6,f7;

drop table if exists test_part_t12;
create table test_part_t12(f1 int, f2 int, f3 int, f4 int, f5 int)
PARTITION BY RANGE(f1,f2,f3)
(
 PARTITION p1 values less than(10,20,30),
 PARTITION p3 values less than(30,40,50),
 PARTITION p4 values less than(MAXVALUE,MAXVALUE,MAXVALUE)
);
create index idx_t12_1 on test_part_t12(f2,f3);
create index idx_t12_2 on test_part_t12(f4,f5) local;
insert into test_part_t12 values(6,15,25,10,20);
insert into test_part_t12 values(16,21,25,20,30);
insert into test_part_t12 values(35,48,40,40,60);
insert into test_part_t12 values(20,15,25,80,40);
select * from test_part_t12 where f1=16 and f2=21 and f3=25 order by f1,f2,f3,f4,f5;
select * from test_part_t12 where f1>20 and f2>30 and f3>40 order by f1,f2,f3,f4,f5;
select * from test_part_t12 where f1=33 and f2=45 and f3=25 and f4=40 and f5=60 order by f1,f2,f3,f4,f5;
explain plan for select * from test_part_t12 where f1=33 and f2=45 and f3=25 and f4=40 and f5=60;
drop table if exists test_part_t13;
create table test_part_t13(f1 int,f2 int, f3 int, f4 int)
partition by list(f1,f2)
(
partition p1 values ((1,2),(2,3),(3,4),(4,5)),
partition p2 values ((6,7),(7,8),(9,10)),
partition p3 values (default)
);
insert into test_part_t13 values(1,2,25,10);
insert into test_part_t13 values(7,8,21,25);
insert into test_part_t13 values(9,10,48,40);
insert into test_part_t13 values(20,15,25,80);
select * from test_part_t13 where f1=1 and f2=2 order by f1,f2,f3,f4;
select * from test_part_t13 where f1>7 and f2>10 order by f1,f2,f3,f4;
select * from test_part_t13 where f1=7 and f2=10 order by f1,f2,f3,f4;
alter table test_part_t13 drop partition p1;
alter table test_part_t13 drop partition p2;
alter table test_part_t13 drop partition p3;

create table test_part_t14(f1 int,f2 int)
partition by list(f1)
(
partition p1 values (1,2,3,4,5),
partition p2 values (6,7,8,9,10),
partition p3 values (11,12,13),
partition p4 values (default)
);
insert into test_part_t14 values(1,1);
insert into test_part_t14 values(2,2);
select * from test_part_t14 where f1 = 1 or f1 = 2 order by f1,f2;
explain plan for select * from test_part_t14 where f1 >= 1;
explain plan for select * from test_part_t14 where f1 >= 1 and f1 <1;

alter table test_part_t14 drop partition p4;
alter table test_part_t14 add partition p5 values (default);

create table test_part_t15(f1 int, f2 int, f3 int)
PARTITION BY RANGE(f1,f2)
(
 PARTITION p1 values less than(10,20),
 PARTITION p3 values less than(30,40),
 PARTITION p4 values less than(MAXVALUE,MAXVALUE)
);
insert into test_part_t15 values(5,5,5);
insert into test_part_t15 values(15,15,15);
insert into test_part_t15 values(25,25,25);
select * from test_part_t15 where f1 =15 or f1 = 35 order by f1,f2,f3;

drop table if exists test_part_t16;
create table test_part_t16(id1 int, id2 int, id3 clob)
partition by range(id1, id2)
(
partition p1 values less than(5, 50),
partition p2 values less than(10, 100),
partition p3 values less than(20, 200)
);

create index ix_add_part_01 on test_part_t16(id1) local;
create index ix_add_part_02 on test_part_t16(id2) local;

insert into test_part_t16 values(6, 200, 'asdfasfadsfasdfadsfadsf');

select * from test_part_t16 order by id1;

alter table test_part_t16 drop partition p2;
alter table test_part_t16 add partition p4 values less than(30, 200);
alter table test_part_t16 add partition p5 values less than(30, 300);

insert into test_part_t16 values (29, 199, 'asdfasfadsfasdfadsfadsf');
insert into test_part_t16 values (30, 299, 'asdfasfadsfasdfadsfadsf');

select * from test_part_t16 order by id1;

alter table test_part_t16 truncate partition p4 drop storage;

select * from test_part_t16 order by id1;

alter table test_part_t16 drop partition p4;

insert into test_part_t16 values (29, 199, 'asdfasfadsfasdfadsfadsf');

select * from test_part_t16 order by id1;

drop table if exists test_part_t17;
create table test_part_t17(id int)
partition by range(id)
(
partition p1 values less than(5),
partition p2 values less than(10),
partition p3 values less than(20)
);

create index idx_test_part_t17 on test_part_t17 (id) local
(
partition p1,
partition p2,
partition p4
);

alter table test_part_t17 add partition p4 values less than (30);

drop table if exists STORAGE_PARTRANGE_TBL_001;
CREATE TABLE STORAGE_PARTRANGE_TBL_001(C_ID INT,C_D_ID INT NOT NULL,C_W_ID INT NOT NULL,C_FIRST VARCHAR(64) NOT NULL,C_MIDDLE CHAR(2),C_LAST VARCHAR(64) NOT NULL,C_STREET_1 VARCHAR(20) NOT NULL,C_STREET_2 VARCHAR(20),C_CITY VARCHAR(20) NOT NULL,C_STATE CHAR(2) NOT NULL,C_ZIP CHAR(9) NOT NULL,C_PHONE CHAR(16) NOT NULL,C_SINCE TIMESTAMP,C_CREDIT CHAR(2) NOT NULL,C_CREDIT_LIM NUMERIC(12,2),C_DISCOUNT NUMERIC(4,4),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL NOT NULL,C_PAYMENT_CNT NUMBER NOT NULL,C_DELIVERY_CNT BOOL NOT NULL,C_END DATE NOT NULL,C_VCHAR VARCHAR(1000),C_DATA varchar(2000),C_TEXT varchar(2000)) PARTITION BY RANGE(C_ID,C_FIRST,C_LAST) (PARTITION PART_1 VALUES LESS THAN (201,'B','B'),PARTITION PART_2 VALUES LESS THAN (401,'C','C'),PARTITION PART_3 VALUES LESS THAN (601,'D','D'),PARTITION PART_4 VALUES LESS THAN (801,'E','E'),PARTITION PART_5 VALUES LESS THAN (1001,'F','F'),PARTITION PART_6 VALUES LESS THAN (5001,'G','G'),PARTITION PART_7 VALUES LESS THAN (6001,'H','H'),PARTITION PART_8 VALUES LESS THAN (7001,'I',$),PARTITION PART_9 VALUES LESS THAN (8001,'J','J'),PARTITION PART_10 VALUES LESS THAN (MAXVALUE,MAXVALUE,MAXVALUE));


drop table if exists test_part_t1;
drop table if exists test_part_t2;
drop table if exists test_part_t3;
drop table if exists test_part_t4;
drop table if exists test_part_t5;
drop table if exists test_part_t6;
drop table if exists test_part_t7;
drop table if exists test_part_t8;
drop table if exists test_part_t9;
drop table if exists test_part_t10;
drop table if exists test_part_t11;
drop table if exists test_part_t12;
drop table if exists test_part_t13;
drop table if exists test_part_t14;
drop table if exists test_part_t15;
drop table if exists test_part_t16;
drop table if exists test_part_t17;

--DTS2018020706510
create global temporary table nebula_ddl_range_001(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(50) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data varchar(1000),c_clob varchar(1000),c_text varchar(1000)) partition by range(c_id,c_first) (partition PART_1 values less than (101,'is101'),partition PART_2 values less than (201,'is201'),partition PART_3 values less than (301,'is301'),partition PART_4 values less than (401,'is401'),partition PART_5 values less than (501,'is501'),partition PART_6 values less than (601,'is601'),partition PART_7 values less than (701,'is701'),partition PART_8 values less than (801,'is801'),partition PART_9 values less than (901,'is901'),partition PART_10 values less than (maxvalue,maxvalue));

--DTS2018021102005
drop table if exists STORAGE_PARTRANGE_TBL_001;
CREATE TABLE STORAGE_PARTRANGE_TBL_001(C_ID INT,C_D_ID INT NOT NULL,C_W_ID INT NOT NULL,C_FIRST VARCHAR(64) NOT NULL,C_MIDDLE CHAR(2),C_LAST VARCHAR(64) NOT NULL,C_STREET_1 VARCHAR(20) NOT NULL,C_STREET_2 VARCHAR(20),C_CITY VARCHAR(20) NOT NULL,C_STATE CHAR(2) NOT NULL,C_ZIP CHAR(9) NOT NULL,C_PHONE CHAR(16) NOT NULL,C_SINCE TIMESTAMP,C_CREDIT CHAR(2) NOT NULL,C_CREDIT_LIM NUMERIC(12,2),C_DISCOUNT NUMERIC(4,4),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL NOT NULL,C_PAYMENT_CNT NUMBER NOT NULL,C_DELIVERY_CNT BOOL NOT NULL,C_END DATE NOT NULL,C_VCHAR VARCHAR(1000),C_DATA varchar(2000),C_TEXT varchar(2000)) PARTITION BY RANGE(C_ID,C_FIRST,C_LAST) (PARTITION PART_1 VALUES LESS THAN (201,'B','B'),PARTITION PART_2 VALUES LESS THAN (401,'C','C'),PARTITION PART_3 VALUES LESS THAN (601,'D','D'),PARTITION PART_4 VALUES LESS THAN (801,'E','E'),PARTITION PART_5 VALUES LESS THAN (1001,'F','F'),PARTITION PART_6 VALUES LESS THAN (5001,'G','G'),PARTITION PART_7 VALUES LESS THAN (6001,'H','H'),PARTITION PART_8 VALUES LESS THAN (7001,'I','I'),PARTITION PART_9 VALUES LESS THAN (8001,'J','J'),PARTITION PART_10 VALUES LESS THAN (MAXVALUE,MAXVALUE,MAXVALUE));
ALTER TABLE STORAGE_PARTRANGE_TBL_001 ADD PARTITION PART_11 VALUES LESS THAN (9001,'K','K','K');

create table test_part_t17(f1 int,f2 int)
partition by list(f1,f2)
(
partition p1 values ((1),(2)),
partition p2 values (default)
);

create table test_part_t18(f1 int,f2 int)
partition by list(f1)
(
partition p1 values ((1,2),(2,3)),
partition p2 values (default)
);

create table test_part_t19(f1 int, f2 int, f3 int)
PARTITION BY RANGE(f1,f2)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);

create table test_part_t20(f1 int, f2 int, f3 int)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(20,MAXVALUE)
);

--DTS2018030104383
drop table if exists aa;
create table aa(c_id int,c_d_id int NOT NULL) 
partition by range(c_id) 
(
partition PART_1 values less than (5002),
partition PART_2 values less than (10002),
partition PART_3 values less than (20002),
partition PART_4 values less than (30002),
partition 1233456 values less than (40002),
partition PART_8 values less than (50002),
partition PART_13  values less than (maxvalue)
);

create table aa(c_id int,c_d_id int NOT NULL) 
partition by range(c_id) 
(
partition PART_1 values less than (5002),
partition PART_2 values less than (10002),
partition PART_3 values less than (20002),
partition PART_4 values less than (30002),
partition PART_5 values less than (40002),
partition PART_8 values less than (50002),
partition PART_13  values less than (60002)
);
alter table aa add partition 1233456 values less than (maxvalue);
alter table aa truncate partition 1233456;
alter table aa drop partition 1233456;
drop table if exists aa;
drop table if exists STORAGE_PARTRANGE_TBL_001;
drop table if exists test_part_t17;
drop table if exists test_part_t18;
drop table if exists test_part_t19;
drop table if exists test_part_t20;

--test appendonly on partition table
drop table if exists apd_part_table_00422311;
create table apd_part_table_00422311(a int, b char(2000), c char(2000), d char(2000), e varchar(1800)) appendonly on
partition by range (a)
(
PARTITION PT1 VALUES LESS THAN ( 1000 ),
PARTITION PT2 VALUES LESS THAN ( 2000 ),
PARTITION PT3 VALUES LESS THAN ( 3000 ),
PARTITION PT4 VALUES LESS THAN ( MAXVALUE )
);
insert into apd_part_table_00422311 values(100, 'abcdefghijklmnopqrstuvwxyz1234567890,.[]','abcdefghijklmnopqrstuvwxyz1234567890,.[]','abcdefghijklmnopqrstuvwxyz1234567890,.[]','abcdefghijklmnopqrstuvwxyz1234567890,.[]');
insert into apd_part_table_00422311 values(2100, 'abcdefghijklmnopqrstuvwxyz1234567890,.[]','abcdefghijklmnopqrstuvwxyz1234567890,.[]','abcdefghijklmnopqrstuvwxyz1234567890,.[]','abcdefghijklmnopqrstuvwxyz1234567890,.[]');
insert into apd_part_table_00422311 values(3100, 'abcdefghijklmnopqrstuvwxyz1234567890,.[]','abcdefghijklmnopqrstuvwxyz1234567890,.[]','abcdefghijklmnopqrstuvwxyz1234567890,.[]','abcdefghijklmnopqrstuvwxyz1234567890,.[]');
insert into apd_part_table_00422311 values(4100, 'abcdefghijklmnopqrstuvwxyz1234567890,.[]','abcdefghijklmnopqrstuvwxyz1234567890,.[]','abcdefghijklmnopqrstuvwxyz1234567890,.[]','abcdefghijklmnopqrstuvwxyz1234567890,.[]');
truncate table apd_part_table_00422311 drop storage;
drop table apd_part_table_00422311;
--DTS2018040208851
drop table if exists strg_part_list_tbl_000;
create table strg_part_list_tbl_000(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(32) NOT NULL,c_street_1 varchar(40) NOT NULL,c_street_2 varchar(40),c_city varchar(40) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(32) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_vchar varchar(1000),c_data clob,c_text blob,primary key (c_id,c_d_id,c_w_id));
insert into strg_part_list_tbl_000  values(1,1,1,'is'||1||'cmvls'||1,'OE','BAR'||1||'BAR'||1,'bkili'||1||'fcxcle'||1,'pmbwo'||1||'vhvpaj'||1,'dyf'||1||'rya'||1,'uq',4801||1,940||1||215||1,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSF','QVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSF','1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');
insert into strg_part_list_tbl_000 select  c_id+1,2,2,'AA'||'is2cmvls',c_middle,'AA'||'BARBARBAR2','bkili2fcxcle2','pmbwo2vhvpaj2',c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from strg_part_list_tbl_000 where c_id=1;
insert into strg_part_list_tbl_000 select  c_id+2,3,3,'AA'||'is3cmvls',c_middle,'AA'||'BARBARBAR3','bkili3fcxcle3','pmbwo3vhvpaj3',c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from strg_part_list_tbl_000 where c_id=1;
insert into strg_part_list_tbl_000 select  c_id+3,4,4,'AA'||'is4cmvls',c_middle,'AA'||'BARBARBAR4','bkili4fcxcle4','pmbwo4vhvpaj4',c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from strg_part_list_tbl_000 where c_id=1;
insert into strg_part_list_tbl_000 select  c_id+4,5,5,'AA'||'is5cmvls',c_middle,'AA'||'BARBARBAR5','bkili5fcxcle5','pmbwo5vhvpaj5',c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from strg_part_list_tbl_000 where c_id=1;
insert into strg_part_list_tbl_000 select  c_id+5,6,6,'AA'||'is6cmvls',c_middle,'AA'||'BARBARBAR6','bkili6fcxcle6','pmbwo6vhvpaj6',c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from strg_part_list_tbl_000 where c_id=1;
insert into strg_part_list_tbl_000 select  c_id+6,7,7,'AA'||'is7cmvls',c_middle,'AA'||'BARBARBAR7','bkili7fcxcle7','pmbwo7vhvpaj7',c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from strg_part_list_tbl_000 where c_id=1;
insert into strg_part_list_tbl_000 select  c_id+7,8,8,'AA'||'is8cmvls',c_middle,'AA'||'BARBARBAR8','bkili8fcxcle8','pmbwo8vhvpaj8',c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from strg_part_list_tbl_000 where c_id=1;
insert into strg_part_list_tbl_000 select  c_id+8,9,9,'AA'||'is9cmvls',c_middle,'AA'||'BARBARBAR9','bkili9fcxcle9','pmbwo9vhvpaj9',c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from strg_part_list_tbl_000 where c_id=1;
insert into strg_part_list_tbl_000 select  c_id+9,10,10,'AA'||'is10cmvls',c_middle,'AA'||'BARBARBAR10','bkili10fcxcle10','pmbwo10vhvpaj10',c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from strg_part_list_tbl_000 where c_id=1;
drop table if exists stag_par_lis_sig_xa_tbl_001;
create table stag_par_lis_sig_xa_tbl_001(c_id int,c_d_id int not null,c_w_id int not null,c_first varchar(32) not null,c_middle char(2),c_last varchar(32) not null,c_street_1 varchar(40) not null,c_street_2 varchar(40),c_city varchar(40) not null,c_state char(2) not null,c_zip char(9) not null,c_phone char(32) not null,c_since timestamp,c_credit char(2) not null,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real not null,c_payment_cnt number not null,c_delivery_cnt bool not null,c_end date not null,c_vchar varchar(1000),c_data clob,c_text blob) partition by list(c_d_id) (partition part_1 values(1,2,3,4),partition part_2 values(5,6,7),partition part_3 values(8,9),partition part_4 values(default));
insert into stag_par_lis_sig_xa_tbl_001 select * from strg_part_list_tbl_000;
create index stag_par_lis_sig_xa_ind_1_001 on stag_par_lis_sig_xa_tbl_001(c_d_id)  parallel 4 local;
create index stag_par_lis_sig_xa_ind_2_001 on stag_par_lis_sig_xa_tbl_001(c_last) local;
create unique index stag_par_lis_sig_xa_ind_3_001 on stag_par_lis_sig_xa_tbl_001(c_first) parallel 4;
create index stag_par_lis_sig_xa_ind_4_001 on stag_par_lis_sig_xa_tbl_001(c_street_1) parallel 5;
select c_last from stag_par_lis_sig_xa_tbl_001 where c_last like 'A%' and length(c_last)=12 order by c_last desc;
delete from stag_par_lis_sig_xa_tbl_001;
drop table if exists strg_part_list_tbl_000;
drop table if exists stag_par_lis_sig_xa_tbl_001;

DROP TABLE IF EXISTS TEST_PART_T100;
CREATE TABLE TEST_PART_T100(F1 INT, F2 INT)
PARTITION BY RANGE(F1)
(
 PARTITION P1 VALUES LESS THAN(10),
 PARTITION P2 VALUES LESS THAN(20),
 PARTITION P3 VALUES LESS THAN(30),
 PARTITION P4 VALUES LESS THAN(MAXVALUE)
);
CREATE INDEX IDX_TEST_PART_T100_1 ON TEST_PART_T100(F1) LOCAL;
EXPLAIN SELECT * FROM TEST_PART_T100 WHERE (F1 >5 AND F1 <15) OR (F1 >16 AND F1 < 25);
INSERT INTO TEST_PART_T100 VALUES(1,1);
INSERT INTO TEST_PART_T100 VALUES(2,2);
INSERT INTO TEST_PART_T100 VALUES(11,11);
INSERT INTO TEST_PART_T100 VALUES(12,12);
INSERT INTO TEST_PART_T100 VALUES(21,21);
INSERT INTO TEST_PART_T100 VALUES(22,22);
INSERT INTO TEST_PART_T100 VALUES(31,31);
INSERT INTO TEST_PART_T100 VALUES(32,32);
SELECT * FROM TEST_PART_T100 WHERE (F1 >=1 AND F1 <=12) OR (F1 >= 21 AND F1 <=35) ORDER BY F1;
SELECT * FROM TEST_PART_T100 WHERE (F1 >=1 AND F1 <=12) OR (F1 >= 21 AND F1 <=35) ORDER BY F1 DESC;
EXPLAIN PLAN FOR SELECT * FROM TEST_PART_T100 WHERE (F1 >=1 AND F1 <=12) OR (F1 >= 21 AND F1 <=35) ORDER BY F1 DESC;
DROP TABLE IF EXISTS TEST_PART_T100;

DROP TABLE IF EXISTS TEST_PART_T101;
CREATE TABLE TEST_PART_T101(F1 INT,F2 INT, F3 INT)
PARTITION BY LIST(F1)
(
PARTITION P1 VALUES (6,7,8),
PARTITION P2 VALUES (1,2,3),
PARTITION P3 VALUES (9,10,11),
PARTITION P4 VALUES (DEFAULT)
);
EXPLAIN SELECT * FROM TEST_PART_T101 WHERE F1=1 OR F1=7;
DROP TABLE TEST_PART_T101;

DROP TABLE IF EXISTS TEST_PART_T102;
CREATE TABLE TEST_PART_T102 (ID1 INT, ID2 INT, ID3 INT)
PARTITION BY RANGE (ID1, ID2)
(
PARTITION P1 VALUES LESS THAN (5, 10),
PARTITION P2 VALUES LESS THAN (MAXVALUE, MAXVALUE)
);
CREATE UNIQUE INDEX IDX_TEST_PART_T102_1 ON TEST_PART_T102 (ID1, ID3) LOCAL;
CREATE UNIQUE INDEX IDX_TEST_PART_T102_1 ON TEST_PART_T102 (ID3, ID2, ID1) LOCAL;
DROP TABLE TEST_PART_T102;

--PARTITION PRUNE TEST
DROP TABLE IF EXISTS TEST_PART_PRUNE_T1;
CREATE TABLE TEST_PART_PRUNE_T1 (ID1 INT, ID2 INT)
PARTITION BY RANGE (ID1, ID2)
(
PARTITION P1 VALUES LESS THAN (10, 5),                  --PART_NO 0
PARTITION P2 VALUES LESS THAN (10, 10),                 --PART_NO 1
PARTITION P3 VALUES LESS THAN (20, 10),                 --PART_NO 2
PARTITION P4 VALUES LESS THAN (20, 20),                 --PART_NO 3
PARTITION P5 VALUES LESS THAN (20, MAXVALUE)            --PART_NO 4
);
--LEFT BORDER TEST
EXPLAIN PLAN FOR SELECT * FROM TEST_PART_PRUNE_T1 WHERE ID1 >= 20 AND ID2 >= 10;    --FILTER 3, 4
EXPLAIN PLAN FOR SELECT * FROM TEST_PART_PRUNE_T1 WHERE ID1 > 20 AND ID2 >= 10;     --FILTER INVALID
EXPLAIN PLAN FOR SELECT * FROM TEST_PART_PRUNE_T1 WHERE ID1 >= 20 AND ID2 > 10;     --FILTER 3, 4
EXPLAIN PLAN FOR SELECT * FROM TEST_PART_PRUNE_T1 WHERE ID1 > 20 AND ID2 > 10;      --FILTER INVALID
--RIGHT BORDER TEST
EXPLAIN PLAN FOR SELECT * FROM TEST_PART_PRUNE_T1 WHERE ID1 <= 20 AND ID2 <= 10;    --FILTER 0, 1, 2, 3
EXPLAIN PLAN FOR SELECT * FROM TEST_PART_PRUNE_T1 WHERE ID1 < 20 AND ID2 <= 10;     --FILTER 0, 1, 2
EXPLAIN PLAN FOR SELECT * FROM TEST_PART_PRUNE_T1 WHERE ID1 <= 20 AND ID2 < 10;     --FILTER 0, 1, 2
EXPLAIN PLAN FOR SELECT * FROM TEST_PART_PRUNE_T1 WHERE ID1 < 20 AND ID2 < 10;      --FILTER 0, 1, 2
--SPECIAL CASE FOR SCAN ONE MORE PARTITION
EXPLAIN PLAN FOR SELECT * FROM TEST_PART_PRUNE_T1 WHERE ID1 > 19 AND ID2 > 10;      --FILTER 2, 3, 4
DROP TABLE TEST_PART_PRUNE_T1;


drop table if exists test_part_table;
create table test_part_table
(
   REF_NO               bigint not null,
   RANGE_NO             bigint not null,
   RANGE_LOB            clob   not null,
   primary key (REF_NO)
)partition by range (RANGE_NO)
(
        partition P_01 values less than (100),
        partition P_02 values less than (200),
        partition P_03 values less than (300),
        partition P_04 values less than (400),
        partition P_05 values less than (500),
        partition P_06 values less than (600),
        partition P_07 values less than (700),
        partition P_08 values less than (800),
        partition P_09 values less than (900),
        partition P_10 values less than (1000),
        partition P_11 values less than (1100),
        partition P_12 values less than (1200),
        partition P_13 values less than (1300),
        partition P_14 values less than (1400),
        partition P_15 values less than (1500),
        partition P_16 values less than (1600),
        partition P_17 values less than (1700),
        partition P_18 values less than (1800),
        partition P_19 values less than (1900),
        partition P_20 values less than (2000),
        partition P_21 values less than (2100),
        partition P_22 values less than (2200),
        partition P_23 values less than (2300),
        partition P_24 values less than (2400),
        partition P_25 values less than (2500),
        partition P_26 values less than (2600),
        partition P_27 values less than (2700),
        partition P_28 values less than (2800),
        partition P_29 values less than (2900),
        partition P_30 values less than (3000)
);

insert into test_part_table (ref_no, range_no, range_lob) values(1,99 , 'abcdefghijklmnopqrstuvwxyz1');
insert into test_part_table (ref_no, range_no, range_lob) values(2,199, 'abcdefghijklmnopqrstuvwxyz2');
insert into test_part_table (ref_no, range_no, range_lob) values(3,299, 'abcdefghijklmnopqrstuvwxyz3');
insert into test_part_table (ref_no, range_no, range_lob) values(4,399, 'abcdefghijklmnopqrstuvwxyz4');
insert into test_part_table (ref_no, range_no, range_lob) values(5,499, 'abcdefghijklmnopqrstuvwxyz5');

select DBE_DIAGNOSE.DBA_PARTITIONED_TABSIZE(0,'SYS','TEST_PART_TABLE');
select DBE_DIAGNOSE.DBA_PARTITIONED_TABSIZE(0,'SYS','SYS_TABLES');
select DBE_DIAGNOSE.DBA_PARTITIONED_TABSIZE(0,'SYS',1234);
select DBE_DIAGNOSE.DBA_PARTITIONED_TABSIZE(0,'SYS','TEST_PART_TABLE',1234);
select DBE_DIAGNOSE.DBA_PARTITIONED_TABSIZE(0,null,'TEST_PART_TABLE');
select DBE_DIAGNOSE.DBA_PARTITIONED_TABSIZE(0,1234,'TEST_PART_TABLE');
select DBE_DIAGNOSE.DBA_PARTITIONED_TABSIZE(0,'SYS',null);
select DBE_DIAGNOSE.DBA_PARTITIONED_TABSIZE(0,'SYS','TEST_PART_TABLE',null);

select DBE_DIAGNOSE.DBA_PARTITIONED_LOBSIZE(0,'SYS','TEST_PART_TABLE');
select DBE_DIAGNOSE.DBA_PARTITIONED_LOBSIZE(0,'SYS','SYS_TABLES');
select DBE_DIAGNOSE.DBA_PARTITIONED_LOBSIZE(0,'SYS',1234);
select DBE_DIAGNOSE.DBA_PARTITIONED_LOBSIZE(0,'SYS','TEST_PART_TABLE', 'fdsfs');
select DBE_DIAGNOSE.DBA_PARTITIONED_LOBSIZE(0,'SYS','TEST_PART_TABLE', null);
select DBE_DIAGNOSE.DBA_PARTITIONED_LOBSIZE(0,'SYS','TEST_PART_TABLE', 2);
select DBE_DIAGNOSE.DBA_PARTITIONED_LOBSIZE(0,'SYS','TEST_PART_TABLE', 0);
select DBE_DIAGNOSE.DBA_PARTITIONED_LOBSIZE(0,'SYS','TEST_PART_TABLE', 3);
select DBE_DIAGNOSE.DBA_PARTITIONED_LOBSIZE(0,'SYS','TEST_PART_TABLE', 123124);

select DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','TEST_PART_TABLE');
select DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','TEST_PART_TABLE', 12342);
select DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','TEST_PART_TABLE', null);
select DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','TEST_PART_TABLE', 'indexxx');
select DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','SYS_TABLES');

create index tr_index_test on test_part_table
(
   RANGE_NO ASC
) local;

select DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','TEST_PART_TABLE');
select DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','TEST_PART_TABLE', 'TR_INDEX_TEST');
select DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','TEST_PART_TABLE', 'xxx');
select DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','TEST_PART_TABLE', 12342);
select DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','TEST_PART_TABLE', null);
select DBE_DIAGNOSE.DBA_PARTITIONED_INDSIZE(0,'SYS','SYS_TABLES');

select table_name,bytes,pages,extents from all_tables where table_name = 'TEST_PART_TABLE';
select * from ALL_TAB_COLS where table_name = 'TEST_PART_TABLE' ORDER BY COLUMN_ID;
--select * from v$locked_object;
drop index tr_index_test on test_part_table;
drop table test_part_table;
create user hh identified by 'Cantian_222';
create table hh.test_part_table(a int, b bigint, c clob);
select * from ALL_TAB_COLS where table_name = 'TEST_PART_TABLE' ORDER BY COLUMN_ID;
drop table hh.test_part_table;
purge recyclebin;
drop user hh;

--this usecase will check whether fetching tablepart by org_scn is working
drop table if exists test_part_00422311;
create table test_part_00422311(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);
insert into test_part_00422311 values(5, 15, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_00422311 values(6, 16, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_00422311 values(16, 26, 39, '26', '39', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_00422311 values(26, 36, 49, '36', '49', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_00422311 values(36, 46, 59, '46', '59', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_00422311 values(46, 56, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
create index idx_00422311 on test_part_00422311(f2,f3);
select * from test_part_00422311 where f2>'15' and f3>'39';
drop table test_part_00422311;


-- test partition index online
 drop table if exists part_t1;
 create table part_t1(a1 int,a2 int,a3 int)
 partition by range(a1)
(partition table_p01 values less than (5),
 partition table_p02 values less than (10),
 partition table_p03 values less than (20),
 partition table_p04 values less than (40),
 partition table_p05 values less than(MAXVALUE)
 );
 
 create index idx_part_t1 on part_t1(a1) online;
 create index idx_part_t2 on part_t1(a1,a2) local online;
 create index idx_part_t3 on part_t1(a1,a4) parallel 4 local online;
 alter index idx_part_t1 on part_t1 rebuild;
 alter index idx_part_t1 on part_t1 rebuild online;
 alter index idx_part_t2 on part_t1 rebuild;
 alter index idx_part_t2 on part_t1 rebuild online;
 alter index idx_part_t3 on part_t1 rebuild online;
 select * from part_t1;
 drop  index idx_part_t1;
 drop  index idx_part_t2;
 
 drop table if exists part_t1;
 create table part_t1(a1 int,a2 int,a3 int)
 partition by range(a1)
(partition table_p01 values less than (5),
 partition table_p02 values less than (10),
 partition table_p03 values less than (20),
 partition table_p04 values less than (40),
 partition table_p05 values less than(MAXVALUE)
 );
 
 insert into part_t1 values(1,2,3);
 insert into part_t1 values(2,2,3);
 insert into part_t1 values(4,2,3);
 insert into part_t1 values(6,2,3);
 insert into part_t1 values(7,2,3);
 insert into part_t1 values(8,2,3);
 insert into part_t1 values(17,2,3);
 insert into part_t1 values(12,2,3);
 insert into part_t1 values(21,2,3);
 insert into part_t1 values(22,2,3);
 insert into part_t1 values(30,2,3);
 insert into part_t1 values(16,2,3);
 insert into part_t1 values(7,2,3);
 insert into part_t1 values(8,2,3);
 insert into part_t1 values(27,2,3);
 insert into part_t1 values(50,2,3); 
 create index idx_part_t1 on part_t1(a1) online;
 select * from SYS_SHADOW_INDEXES;
 select * from SYS_SHADOW_INDEX_PARTS;
 create index idx_part_t2 on part_t1(a1,a2) local online;
 select * from SYS_SHADOW_INDEXES;
 select * from SYS_SHADOW_INDEX_PARTS;
 alter index idx_part_t1 on part_t1 rebuild;
 alter index idx_part_t1 on part_t1 rebuild online;
 select * from SYS_SHADOW_INDEXES;
 select * from SYS_SHADOW_INDEX_PARTS;
 alter index idx_part_t2 on part_t1 rebuild;
 alter index idx_part_t2 on part_t1 rebuild online;
 select * from SYS_SHADOW_INDEXES;
 select * from SYS_SHADOW_INDEX_PARTS;
 create index idx_part_1111 on part_t1(a1,a2,a3) local (partition table_p01, partition table_p02,partition p3, partition p4, partition p5) online;
 
 select * from part_t1 order by a1; 
 drop  index idx_part_t1;
 drop  index idx_part_t2;
 drop  index idx_part_1111;

 drop table if exists part_t1;
 create table part_t1(a1 int,a2 int,a3 int)
 partition by range(a1)
(partition table_p01 values less than (5),
 partition table_p02 values less than (10),
 partition table_p03 values less than (20),
 partition table_p04 values less than (40),
 partition table_p05 values less than(MAXVALUE)
 );

 insert into part_t1 values(1,2,3);
 insert into part_t1 values(2,2,3);
 insert into part_t1 values(4,2,3);
 insert into part_t1 values(6,2,3);
 insert into part_t1 values(7,2,3);
 insert into part_t1 values(8,2,3);
 insert into part_t1 values(17,2,3);
 insert into part_t1 values(12,2,3);
 create index idx_part_t1 on part_t1(a1) online;
 alter index idx_part_t1 on part_t1 rebuild;
 alter index idx_part_t1 on part_t1 rebuild online;
 select * from part_t1 order by a1; 
 
 insert into part_t1 values(21,2,3);
 insert into part_t1 values(22,2,3);
 insert into part_t1 values(30,2,3);
 insert into part_t1 values(16,2,3);
 insert into part_t1 values(7,2,3);
 insert into part_t1 values(8,2,3);
 insert into part_t1 values(27,2,3);
 insert into part_t1 values(50,2,3); 
 create index idx_part_t2 on part_t1(a1,a2) local online;
 select * from SYS_SHADOW_INDEXES;
 select * from SYS_SHADOW_INDEX_PARTS;
 alter index idx_part_t2 on part_t1 rebuild;
 alter index idx_part_t2 on part_t1 rebuild online;
 select * from SYS_SHADOW_INDEXES;
 select * from SYS_SHADOW_INDEX_PARTS;
 select * from part_t1 order by a1; 
 
---test case for hash partition-----------------------------------------
drop table if exists part_t1;
drop table if exists test_hash;
  
create table test_hash (
c1 char(20) not null,
c2 number(8) not null
)
partition by hash(c1)
(
partition part_01 tablespace users,
partition part_02 tablespace users,
partition part_03 tablespace users
);

insert into test_hash values('aaaa',111);
insert into test_hash values('bbbb',111);
insert into test_hash values('cccc',111);
insert into test_hash values('dddd',111);
insert into test_hash values('eeee',111);
insert into test_hash values('ffff',111);
insert into test_hash values('hhhh',111);
insert into test_hash values('iiii',111);

select * from test_hash partition (part_01) order by c1,c2;
select * from test_hash partition (part_02) order by c1,c2;
select * from test_hash partition (part_03) order by c1,c2;

update test_hash set c1 = 'xxxx' where c1 = 'aaaa';
update test_hash set c1 = 'yyyy' where c1 = 'bbbb';

------------------add partition --------------------------------
create index idx_hash_part_t1 on test_hash(upper(c1));

select * from test_hash partition(part_02) order by c1,c2;

alter table test_hash add partition part_04 tablespace users;

select * from test_hash partition(part_02) order by c1,c2;
select * from test_hash partition(part_04) order by c1,c2;

alter table test_hash add partition part_05 tablespace users;

select * from test_hash partition(part_01) order by c1,c2;
select * from test_hash partition(part_05) order by c1,c2;

-------------------coalesce partition----------------------------
ALTER TABLE test_hash COALESCE PARTITION ;
select * from test_hash partition(part_02) order by c1,c2;
select * from test_hash partition(part_04) order by c1,c2;
drop table test_hash;

drop table if exists test_hash1;

create table test_hash1 (
c3 char(20) primary key,
c4 number(8) not null
)
partition by hash(c3)
(
partition part_01 tablespace users,
partition part_02 tablespace users,
partition part_03 tablespace users
);

insert into test_hash1 values('aaaa',111);
insert into test_hash1 values('bbbb',111);
insert into test_hash1 values('cccc',111);
insert into test_hash1 values('dddd',111);
insert into test_hash1 values('eeee',111);
insert into test_hash1 values('ffff',111);
insert into test_hash1 values('hhhh',111);
insert into test_hash1 values('iiii',111);

create index idx_hash_part_t2 on test_hash1(c3,c4) local;
select * from test_hash1 partition(part_02) order by c3,c4;

alter table test_hash1 add partition part_04 tablespace users;

select * from test_hash1 partition(part_02) order by c3,c4;
select * from test_hash1 partition(part_04) order by c3,c4;

alter table test_hash1 add partition part_05 tablespace users;

select * from test_hash1 partition(part_01) order by c3,c4;
select * from test_hash1 partition(part_05) order by c3,c4;

ALTER TABLE test_hash1 COALESCE PARTITION ;
select * from test_hash1 partition(part_02) order by c3,c4;
select * from test_hash1 partition(part_04) order by c3,c4;
ALTER TABLE test_hash1 COALESCE PARTITION ;
select * from test_hash1 partition(part_02) order by c3,c4;
select * from test_hash1 partition(part_04) order by c3,c4;
drop index idx_hash_part_t2 on test_hash1;
drop table test_hash1;
-------------------------hash column is int----------------------
drop table if exists test_hash_int;
 
create table test_hash_int (
c1 int not null,
c2 number(8) not null
)
partition by hash(c1)
(
partition part_01 tablespace users,
partition part_02 tablespace users,
partition part_03 tablespace users
);

insert into test_hash_int values(231,111);
insert into test_hash_int values(123,111);
insert into test_hash_int values(345,111);
insert into test_hash_int values(567,111);
insert into test_hash_int values(678,111);
insert into test_hash_int values(789,111);
insert into test_hash_int values(256,111);
insert into test_hash_int values(478,111);
drop table test_hash_int;
---------------------------two hash columns------------------------------
drop table if exists  test_hash_two_col;
 
create table test_hash_two_col (
c1 int not null,
c2 number(8) not null,
c3 char(15)
)
partition by hash(c1,c2)
(
partition part_01 tablespace users,
partition part_02 tablespace users,
partition part_03 tablespace users
);

insert into test_hash_two_col values(23,111,'aaa');
insert into test_hash_two_col values(24,111,'bbb');
insert into test_hash_two_col values(25,111,'ccc');
insert into test_hash_two_col values(26,111,'ddd');
insert into test_hash_two_col values(27,111,'eee');
insert into test_hash_two_col values(28,111,'fff');

select * from test_hash_two_col partition(part_01) order by c1,c2,c3;
select * from test_hash_two_col partition(part_02) order by c1,c2,c3;
select * from test_hash_two_col partition(part_03) order by c1,c2,c3;
drop table test_hash_two_col;
------------------------create hash partition with store in grammar------
drop table if exists test_hash_store_in;

CREATE TABLE test_hash_store_in 
(c1 char(15), 
c2  int
)
PARTITION BY HASH (c1)
PARTITIONS 3
STORE IN(users,users, users);

insert into test_hash_store_in values('aaaa',111);
insert into test_hash_store_in values('bbbb',111);
insert into test_hash_store_in values('cccc',111);
insert into test_hash_store_in values('dddd',111);
insert into test_hash_store_in values('eeee',111);
insert into test_hash_store_in values('ffff',111);
insert into test_hash_store_in values('hhhh',111);
insert into test_hash_store_in values('iiii',111);
drop table test_hash_store_in;
------------------------create hash partition with store in grammer---------
------------------------tablespace cnt is less than partcnt-----------------
drop table if exists test_hash_store_in2;

CREATE TABLE test_hash_store_in2 
(c1 char(15), 
c2  int
)
PARTITION BY HASH (c1)
PARTITIONS 3
STORE IN(users,users);

insert into test_hash_store_in2 values('aaaa',111);
insert into test_hash_store_in2 values('bbbb',111);
insert into test_hash_store_in2 values('cccc',111);
insert into test_hash_store_in2 values('dddd',111);
insert into test_hash_store_in2 values('eeee',111);
insert into test_hash_store_in2 values('ffff',111);
insert into test_hash_store_in2 values('hhhh',111);
insert into test_hash_store_in2 values('iiii',111);
drop table test_hash_store_in2;
-----------------------------------------------------------------------------
drop table if exists test_one_part;
  
create table test_one_part (
c1 char(20) primary key,
c2 number(8) not null,
c3 clob   not null
)
partition by hash(c1)
(
partition part_01 tablespace users
);

insert into test_one_part values('aaaaaaa',1111,'xxxxxxxxxxxxxxxxxxxxxxxxx');
insert into test_one_part values('bbbbbbb',1111,'xxxxxxxxxxxxxxxxxxxxxxxxx');
insert into test_one_part values('ccccccc',1111,'xxxxxxxxxxxxxxxxxxxxxxxxx');
insert into test_one_part values('ddddddd',1111,'xxxxxxxxxxxxxxxxxxxxxxxxx');

select * from test_one_part partition (part_01) order by c1,c2;
alter table test_one_part add partition part_02 tablespace users;
select * from test_one_part partition (part_01) order by c1,c2;
select * from test_one_part partition (part_02) order by c1,c2;
alter table test_one_part add partition part_03 tablespace users;
select * from test_one_part partition (part_03) order by c1,c2;
select * from test_one_part partition (part_02) order by c1,c2;

alter table test_one_part coalesce partition;
select * from test_one_part partition (part_03) order by c1,c2;
select * from test_one_part partition (part_02) order by c1,c2;
alter table test_one_part coalesce partition;
select * from test_one_part partition (part_02) order by c1,c2;
select * from test_one_part partition (part_01) order by c1,c2;
drop table test_one_part;
------------------------comprehensive && exceptional case--------------------------------------
drop table if exists test_part_hash_multi;
create table test_part_hash_multi(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
partition by hash(f1,f2,f3,f4,f5,f6,f7)
(
partition p1 tablespace users,
partition p2 tablespace users
);

create index idx_hash_t1_1 on test_part_hash_multi(f2,f3) parallel 4;
create index idx_hash_t1_2 on test_part_hash_multi(f4,f5) local;
insert into test_part_hash_multi values(5, 15, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_hash_multi values(6, 16, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_hash_multi values(16, 26, 39, '26', '39', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_hash_multi values(26, 36, 49, '36', '49', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_hash_multi values(36, 46, 59, '46', '59', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_hash_multi values(46, 56, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
update test_part_hash_multi set f1 = 15 where f1=46;
update test_part_hash_multi set f1 = 56 where f1=46;
delete from test_part_hash_multi where f1=56;
select * from test_part_hash_multi order by f1;
select * from test_part_hash_multi where f1 = 16 order by f1;
select * from test_part_hash_multi where f1 > 16 order by f1;
select * from test_part_hash_multi where f1 >= 16 order by f1;
select * from test_part_hash_multi where f1 is null order by f1;
select * from test_part_hash_multi where f4='abcd' and f5='abcd' order by f1;
select * from test_part_hash_multi where f4='16' and f5='29' and f2=16 and f3=29 order by f1;
select * from test_part_hash_multi where f4='16' and f5='29' and f2=16 and f3=29 and f1 <10 order by f1;
explain plan for select * from test_part_hash_multi where f4='16' and f5='29' and f2=16 and f3=29 and f1 <10 order by f1;
select * from test_part_hash_multi where f4='16' and f5='29' and f2=16 and f3=29 and f1 =6 order by f1;
explain plan for select * from test_part_hash_multi where f4='16' and f5='29' and f2=16 and f3=29 and f1 =6 order by f1;
select * from test_part_hash_multi where f4='16' and f5='29' and f2=16 and f3=29 and (f1 =6 or f1=26) order by f1;
select * from test_part_hash_multi where f4 >='16' and f5 >='29' and (f2=16 or f2=36) and (f3=29 or f3 = 49) and (f1 =6 or f1=26) order by f1;
drop table test_part_hash_multi;
drop table if exists test_hash1;
create table test_hash1 (
c1 char(20) primary key,
c2 number(8) not null
)
partition by hash(c1)
(
partition part_01 tablespace users,
partition part_02 tablespace users,
partition part_01 tablespace users
);

drop table if exists test_hash2;
create table test_hash2 (
c1 char(20) primary key,
c2 number(8) not null
)
partition by hash(c1)
(
partition part_01 tablespace users,
partition part_02 tablespace users,
partition 123456 tablespace users
);

drop table if exists test_hash3;
create table test_hash3 (
c1 char(20) primary key,
c2 number(8) not null
)
partition by hash(c1)
(
partition part_01 tablespace users,
partition part_02 tablespace users,
partition part_03 tablespace users,
partition part_04 tablespace users
);

insert into test_hash3 values('aaaa',1111);
insert into test_hash3 values('bbbb',1111);
insert into test_hash3 values('cccc',1111);
insert into test_hash3 values('dddd',1111);
insert into test_hash3 values('eeee',1111);
insert into test_hash3 values('ffff',1111);
insert into test_hash3 values('gggg',1111);
insert into test_hash3 values('hhhh',1111);

select * from test_hash3 partition(part_01) order by c1,c2;
alter table test_hash3 coalesce partition;
alter table test_hash3 coalesce partition;
alter table test_hash3 coalesce partition;
alter table test_hash3 coalesce partition;
select * from test_hash3 partition(part_01) order by c1,c2;
-------do not support drop for hash partition---------------
alter table test_hash3 drop partition part_04;
drop table test_hash3;
create table test_part_lob(f1 clob)
partition by hash(f1)
(
partition p1 tablespace users,
partition p2 tablespace users
);

-----test hash partition index online-----------------------
 drop table if exists part_t1;
 create table part_t1(a1 int,a2 int,a3 int)
 partition by hash(a1)
(partition table_p01 tablespace users,
 partition table_p02 tablespace users,
 partition table_p03 tablespace users,
 partition table_p04 tablespace users,
 partition table_p05 tablespace users
 );
 
 create index idx_hash_part_t1 on part_t1(a1) online;
 create index idx_hash_part_t2 on part_t1(a1,a2) local online;
 create index idx_hash_part_t3 on part_t1(a1,a3) local online;
 alter index idx_hash_part_t1 on part_t1 rebuild;
 alter index idx_hash_part_t1 on part_t1 rebuild online;
 alter index idx_hash_part_t2 on part_t1 rebuild;
 alter index idx_hash_part_t2 on part_t1 rebuild online;
 alter index idx_hash_part_t3 on part_t1 rebuild online;
 select * from part_t1;
 drop index idx_hash_part_t1 on part_t1;
 drop index idx_hash_part_t2 on part_t1;
 
 drop table if exists part_t1;
 create table part_t1(a1 int,a2 int,a3 int)
 partition by hash(a1)
(partition table_p01 tablespace users,
 partition table_p02 tablespace users,
 partition table_p03 tablespace users,
 partition table_p04 tablespace users,
 partition table_p05 tablespace users
 );
 
 insert into part_t1 values(1,2,3);
 insert into part_t1 values(2,2,3);
 insert into part_t1 values(4,2,3);
 insert into part_t1 values(6,2,3);
 insert into part_t1 values(7,2,3);
 insert into part_t1 values(8,2,3);
 insert into part_t1 values(17,2,3);
 insert into part_t1 values(12,2,3);
 insert into part_t1 values(21,2,3);
 insert into part_t1 values(22,2,3);
 insert into part_t1 values(30,2,3);
 insert into part_t1 values(16,2,3);
 insert into part_t1 values(7,2,3);
 insert into part_t1 values(8,2,3);
 insert into part_t1 values(27,2,3);
 insert into part_t1 values(50,2,3); 
 create index idx_hash_part_t1 on part_t1(a1) online;
 select * from SYS_SHADOW_INDEXES;
 select * from SYS_SHADOW_INDEX_PARTS;
 create index idx_hash_part_t2 on part_t1(a1,a2) local online;
 select * from SYS_SHADOW_INDEXES;
 select * from SYS_SHADOW_INDEX_PARTS;
 alter index idx_hash_part_t1 on part_t1 rebuild;
 alter index idx_hash_part_t1 on part_t1 rebuild online;
 select * from SYS_SHADOW_INDEXES;
 select * from SYS_SHADOW_INDEX_PARTS;
 alter index idx_hash_part_t2 on part_t1 rebuild;
 alter index idx_hash_part_t2 on part_t1 rebuild online;
 select * from SYS_SHADOW_INDEXES;
 select * from SYS_SHADOW_INDEX_PARTS;
 
 select * from part_t1 order by a1; 
 drop  index idx_hash_part_t1;
 drop  index idx_hash_part_t2;
---------------------------------------------------------------
 drop table if exists part_t1;
 create table part_t1(a1 int,a2 int,a3 int)
 partition by hash(a1)
(partition table_p01 tablespace users,
 partition table_p02 tablespace users,
 partition table_p03 tablespace users,
 partition table_p04 tablespace users,
 partition table_p05 tablespace users
 ) crmode row;

 insert into part_t1 values(1,2,3);
 insert into part_t1 values(2,2,3);
 insert into part_t1 values(4,2,3);
 insert into part_t1 values(6,2,3);
 insert into part_t1 values(7,2,3);
 insert into part_t1 values(8,2,3);
 insert into part_t1 values(17,2,3);
 insert into part_t1 values(12,2,3);
 create index idx_hash_part_t1 on part_t1(a1) online;
 alter index idx_hash_part_t1 on part_t1 rebuild;
 alter index idx_hash_part_t1 on part_t1 rebuild online;
 select * from part_t1 order by a1; 
 
 insert into part_t1 values(21,2,3);
 insert into part_t1 values(22,2,3);
 insert into part_t1 values(30,2,3);
 insert into part_t1 values(16,2,3);
 insert into part_t1 values(7,2,3);
 insert into part_t1 values(8,2,3);
 insert into part_t1 values(27,2,3);
 insert into part_t1 values(50,2,3); 
 create index idx_hash_part_t2 on part_t1(a1,a2) local online;
 select * from SYS_SHADOW_INDEXES;
 select * from SYS_SHADOW_INDEX_PARTS;
 alter index idx_hash_part_t2 on part_t1 rebuild;
 alter index idx_hash_part_t2 on part_t1 rebuild online;
 select * from SYS_SHADOW_INDEXES;
 select * from SYS_SHADOW_INDEX_PARTS;
 select * from part_t1 order by a1; 
 ------------------flashback-------------------------------------
 SELECT SLEEP(2);
 delete from part_t1 where a1=21;
 select * from part_t1 order by a1;
 select ORG_NAME FROM SYS_RECYCLEBIN WHERE ORG_NAME = 'PART_T1';
 flashback table part_t1 to timestamp SYSTIMESTAMP - 1/(24*60*60);
 select * from part_t1 order by a1;
 truncate table part_t1;
 select * from part_t1 order by a1;
 -----------------------------------------------------------------
 drop table if exists part_t1;
 create table part_t1(f1 int,f2 int,f3 int)
 partition by hash(f1)
 (
 partition p1,
 partition p2,
 partition p3,
 partition p4,
 partition p5
 );
 
 drop table if exists part_t1;
 CREATE TABLE part_t1 (f1 int, f2 int) PARTITION BY HASH (f1) PARTITIONS 0;
 
 drop table if exists part_t1;
 CREATE TABLE part_t1 (f1 int, f2 int) PARTITION BY HASH (f1) PARTITIONS 5;
 
 insert into part_t1 values(1,1);
 insert into part_t1 values(2,1);
 insert into part_t1 values(3,1);
 insert into part_t1 values(4,1);
 insert into part_t1 values(5,1);
 insert into part_t1 values(6,1);
 insert into part_t1 values(7,1);
 insert into part_t1 values(8,1);
 insert into part_t1 values(9,1);
 insert into part_t1 values(10,1);
 select * from part_t1 where f1 = 2;
 explain select * from part_t1 where f1 = 2;
 select * from part_t1 where f1 = 8;
 explain select * from part_t1 where f1 = 8;
 select * from part_t1 where f1 > 3 order by f1;
 explain select * from part_t1 where f1 > 3 order by f1;
 
drop table if exists test_part_t1;
create table test_part_t1(f1 int, f2 int, f3 int, f4 int, f5 int)
PARTITION BY RANGE(f1,f2,f3)
(
 PARTITION p1 values less than(10,20,30),
 PARTITION p2 values less than(30,40,50),
 PARTITION p3 values less than(MAXVALUE,MAXVALUE,MAXVALUE)
);
explain select * from test_part_t1 partition(p1);
explain select * from test_part_t1 partition for (5,5,5);
explain select * from test_part_t1 partition(p1) where f1=15 and f2=25 and f3=20;
explain select * from test_part_t1 partition for (5,5,5) where f1=15 and f2=25 and f3=20;
explain select * from test_part_t1 partition(p2) where f1=15 and f2=25 and f3=20;
explain select * from test_part_t1 partition for (15,25,20) where f1=15 and f2=25 and f3=20;
explain select * from test_part_t1 partition for (15,25,35) where f1=15 and f2=25 and f3=20;
explain select * from test_part_t1 partition(p3) where f1=15 and f2=25 and f3=20;
explain select * from test_part_t1 partition for (35,45,55) where f1=15 and f2=25 and f3=20;
drop table test_part_t1;
-----------------------------test huge partition count-------------------------------
drop table if exists table_hash;
CREATE TABLE table_hash(C_ID INT,
C_D_ID INT NOT NULL,
C_W_ID INT NOT NULL,
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
C_END DATE NOT NULL,
C_VCHAR VARCHAR(1000),
C_DATA CLOB,
C_TEXT BLOB
)
PARTITION BY HASH(c_id,c_first,c_end)
partitions 8192
store in
(users
);
alter table table_hash add partition part_01;
alter table table_hash add partition part_02;
alter table table_hash coalesce partition;
drop table table_hash;
------------------------------truncate partition then dml operation----------------------
drop table if exists strg_wait_lk_range_tbl_30;
create table strg_wait_lk_range_tbl_30(
c_id int,
c_first varchar(30) NOT NULL,
c_end int NOT NULL,
c_vchar varchar(1000),
c_data clob,
c_text blob) 
partition by range(c_id,c_first) 
(partition PART_1 values less than (201,'is201'),
 partition PART_2 values less than (401,'is401'),
 partition PART_3 values less than (601,'is601'),
 partition PART_4 values less than (801,'is801'),
 partition PART_5 values less than (maxvalue,maxvalue)
 );
 
 insert into strg_wait_lk_range_tbl_30 values(12,'is12',12,'','','');
 insert into strg_wait_lk_range_tbl_30 values(300,'is300',300,'','','');
 insert into strg_wait_lk_range_tbl_30 values(500,'is500',500,'','','');
 insert into strg_wait_lk_range_tbl_30 values(700,'is700',700,'','','');
 insert into strg_wait_lk_range_tbl_30 values(900,'is900',900,'','','');
 
 select count(*) from strg_wait_lk_range_tbl_30;
 alter table strg_wait_lk_range_tbl_30 add constraint strg_wait_lk_range_constr_30 UNIQUE(c_id,c_first,c_end);
 insert into strg_wait_lk_range_tbl_30 values(12,'is12',12,'','','');
 alter table strg_wait_lk_range_tbl_30 truncate partition PART_1;
 insert into strg_wait_lk_range_tbl_30 values(12,'is12',12,'','','');
 delete from strg_wait_lk_range_tbl_30 where c_id = 300;
 update strg_wait_lk_range_tbl_30 set c_end = 200 where c_id = 300;
 drop table strg_wait_lk_range_tbl_30;
 
drop table if exists table_interval;
create table table_interval(
C_ID INT,
C_D_ID INT NOT NULL,
C_W_ID INT NOT NULL,
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
C_END DATE NOT NULL,
C_VCHAR VARCHAR(1000),
C_DATA CLOB,
C_TEXT BLOB
)
partition by range(c_d_id,c_payment_cnt,c_end)
(
partition part_1 values less than (10,100.0,(to_date('2016-01-01','yyyy-mm-dd'))),
partition part_2 values less than (60,200.0,(to_date('2016-06-01','yyyy-mm-dd'))),
partition part_3 values less than (90,300.0,(to_date('2016-09-01','yyyy-mm-dd')))
);
alter table table_interval set interval(66);
drop table if exists table_interval;

drop table if exists ACID_INTERVAL_DML_TBL_001;
CREATE TABLE ACID_INTERVAL_DML_TBL_001(C_ID INT,C_END DATE NOT NULL)PARTITION BY RANGE(C_END)INTERVAL(NUMTODSINTERVAL(1,'day'))(PARTITION PART_1 VALUES LESS THAN (TO_DATE('2018-02-01','YYYY-MM-DD')),PARTITION PART_2 VALUES LESS THAN (TO_DATE('2018-03-01','YYYY-MM-DD')),PARTITION PART_3 VALUES LESS THAN (TO_DATE('2018-04-01','YYYY-MM-DD')),PARTITION PART_4 VALUES LESS THAN (TO_DATE('2018-05-01','YYYY-MM-DD')),PARTITION PART_5 VALUES LESS THAN (TO_DATE('2018-06-01','YYYY-MM-DD')),PARTITION PART_6 VALUES LESS THAN (TO_DATE('2018-07-01','YYYY-MM-DD')),PARTITION PART_7 VALUES LESS THAN (TO_DATE('2018-09-01','YYYY-MM-DD')),PARTITION PART_8 VALUES LESS THAN (TO_DATE('2018-10-01','YYYY-MM-DD')),PARTITION PART_9 VALUES LESS THAN (TO_DATE('2018-11-01','YYYY-MM-DD')));
insert into ACID_INTERVAL_DML_TBL_001 values (1,'2018-06-01');
alter table ACID_INTERVAL_DML_TBL_001 set interval();
alter table ACID_INTERVAL_DML_TBL_001 set interval(NUMTODSINTERVAL(1,'day'));
alter table ACID_INTERVAL_DML_TBL_001 set interval(100);
select  count(*) from ACID_INTERVAL_DML_TBL_001;
drop table if exists ACID_INTERVAL_DML_TBL_001;

DROP TABLE IF EXISTS ALL_DATATYPE_TABLE;
CREATE TABLE ALL_DATATYPE_TABLE(ID INT NOT NULL,C_INTGER INTEGER,C_CHAR CHAR(10))
PARTITION BY RANGE (C_INTGER)
(
PARTITION P_20180121 VALUES LESS THAN (2018),
PARTITION P_20190122 VALUES LESS THAN (2019),
PARTITION P_20200123 VALUES LESS THAN (2020),
PARTITION P_MAX VALUES LESS THAN (2050)
);
INSERT INTO ALL_DATATYPE_TABLE VALUES(1,1000,1000);
INSERT INTO ALL_DATATYPE_TABLE VALUES(2,2000,1000);
INSERT INTO ALL_DATATYPE_TABLE VALUES(3,2001,NULL);
INSERT INTO ALL_DATATYPE_TABLE VALUES(4,2002,'A');

SELECT * FROM ALL_DATATYPE_TABLE T1 JOIN ALL_DATATYPE_TABLE T2 ON T1.C_INTGER=T2.C_INTGER;
SELECT * FROM ALL_DATATYPE_TABLE T1 LEFT JOIN ALL_DATATYPE_TABLE T2 ON T1.C_INTGER=T2.C_INTGER;
SELECT * FROM ALL_DATATYPE_TABLE T1 RIGHT JOIN ALL_DATATYPE_TABLE T2 ON T1.C_INTGER=T2.C_INTGER;

--DTS2018121801645
drop table if exists DTS2018121801645;
create table DTS2018121801645 (i int);
alter table DTS2018121801645 coalesce partition;
drop table DTS2018121801645;

-- coalesce partition table with one partition
drop table if exists table_one_part_coalesce;
create table table_one_part_coalesce (c1 char(20) not null,c2 number(8) not null)
partition by hash(c1) (partition part_01 tablespace users);
alter table table_one_part_coalesce coalesce partition;
drop table table_one_part_coalesce;

--check statement read consistency in global index for partition table
drop table if exists test_btree_hash purge;
drop table if exists test_btree_hash2 purge;
create table test_btree_hash(id int) partition by hash(id) (partition p1, partition p2);
create table test_btree_hash2(id int);
create index idx_test_btree_hash on test_btree_hash(id);

insert into test_btree_hash values (1), (2), (3), (4);
insert into test_btree_hash2 select * from test_btree_hash partition(p1);
commit;

declare
v_sql varchar2(500);
hash_cursor sys_refcursor;
begin
   execute immediate 'insert into test_btree_hash select * from test_btree_hash2';  
   v_sql :='select * from test_btree_hash partition(p2) where id < 100';
   open hash_cursor for v_sql; 
   dbe_sql.return_cursor(hash_cursor);  
   commit;
end;
/
--expected same result with result from procedure
select * from test_btree_hash partition(p2) where id < 100;

drop table test_btree_hash purge;
drop table test_btree_hash2 purge;

--DTS2019011807963: add partition after truncate partition with unique index
drop table if exists test_hash_part;
create table test_hash_part(c1 int, c2 char(10)) partition by hash(c2) (partition p1, partition p2, partition p3,partition p4);
create index idx_local on test_hash_part(c1) local;
create unique index idx_hash on test_hash_part(c2);
insert into test_hash_part values(1,'aaaa1');
insert into test_hash_part values(2,'bbbb2');
insert into test_hash_part values(3,'ccc3c');
insert into test_hash_part values(4,'ddd4d');
insert into test_hash_part values(5,'eee5e');
insert into test_hash_part values(6,'ff5rff');
insert into test_hash_part values(6,'gg444gg');
insert into test_hash_part values(6,'hh333hh');
insert into test_hash_part values(6,'iiii');
insert into test_hash_part values(6,'jj33321jj');
insert into test_hash_part values(6,'kkkkkkkkkk');
insert into test_hash_part values(6,'q3kkkk23k');
insert into test_hash_part values(6,'qkkkkk23k');
select count(*) from test_hash_part;
alter table test_hash_part truncate partition p4 reuse storage;
alter table test_hash_part add partition add_part;
select count(*) from test_hash_part;
drop index idx_hash on test_hash_part;
drop table test_hash_part;

drop table if exists tbl_hash1;
create table tbl_hash1(
col_int int,
col_integer integer,
col_BINARY_INTEGER BINARY_INTEGER,
col_smallint smallint not null default '7',
col_bigint bigint not null default '3',
col_BINARY_BIGINT BINARY_BIGINT,
col_real real,
col_double double,
col_float float,
col_BINARY_DOUBLE BINARY_DOUBLE,
col_decimal decimal,
col_number1 number,
col_number2 number(38),
col_number3 number(38,-84),
col_number4 number(38,127),
col_number5 number(38,7),
col_numeric numeric,
col_char1 char(100),
col_char2 char(8000),
col_nchar1 nchar(100),
col_nchar2 nchar(8000),
col_varchar_200 varchar(100),
col_varchar_8000 varchar(8000) default 'aaaabbbb',
col_varchar2_1000 varchar2(100) not null default 'aaaabbbb' comment 'varchar2(1000)',
col_varchar2_8000 varchar2(8000),
col_nvarchar1 nvarchar(100),
col_nvarchar2 nvarchar(8000),
col_nvarchar2_1000 nvarchar2(100),
col_nvarchar2_8000 nvarchar2(8000),
col_clob clob,
col_text text,
col_longtext longtext,
col_image image,
col_binary1 binary(100),
col_binary2 binary(8000),
col_varbinary1 varbinary(100),
col_varbinary2 varbinary(8000),
col_raw1 raw(100),
col_raw2 raw(8000),
col_blob blob,
col_date date not null default '2018-01-07 08:08:08',
col_datetime datetime default '2018-01-07 08:08:08',
col_timestamp1 timestamp ,
col_timestamp2 timestamp(6),
col_timestamp3 TIMESTAMP WITH TIME ZONE,
col_timestamp4 TIMESTAMP WITH LOCAL TIME ZONE,
col_bool bool,
col_boolean boolean,
col_interval1 INTERVAL YEAR TO MONTH,
col_interval2 INTERVAL DAY TO SECOND
)
partition by hash(col_BINARY_INTEGER,col_float,col_numeric,col_raw1,col_varchar2_1000,col_interval1,col_date)
(
  partition p_hash_01 tablespace users,
  partition p_hash_02 tablespace users,
  partition p_hash_03 tablespace users,
  partition p_hash_04 tablespace users,
  partition p_hash_05 tablespace users,
  partition p_hash_06 tablespace users,
  partition p_hash_07 tablespace users
) tablespace users;

alter table tbl_hash1 add constraint cos_hash_pk11 primary key(col_int);
alter table tbl_hash1 add constraint cos_hash_uk11 unique(col_varbinary1);
create index if not exists idx_tbl_hash1_local_011 on tbl_hash1(col_BINARY_INTEGER,col_raw1 asc,col_bool,col_interval1 asc) local (partition p_hash_01 tablespace users,partition p_hash_02 tablespace users,partition p_hash_03 tablespace users,partition p_hash_04 tablespace users,partition p_hash_05 tablespace users,partition p_hash_06 tablespace users,partition p_hash_07 tablespace users) tablespace users parallel 12; 
create index if not exists idx_tbl_hash1_local_021 on tbl_hash1(col_BINARY_INTEGER,col_float,col_numeric,col_raw1,col_varchar2_1000,col_interval1,col_date) local (partition p_hash_01 tablespace users,partition p_hash_02 tablespace users,partition p_hash_03 tablespace users,partition p_hash_04 tablespace users,partition p_hash_05 tablespace users,partition p_hash_06 tablespace users,partition p_hash_07 tablespace users) tablespace users;
create index idx_tbl_hash1_fun_011 on tbl_hash1(to_char(col_timestamp2) asc,upper(col_number1) desc) tablespace users;
create index idx_tbl_hash1_fun_021 on tbl_hash1(to_char(col_BINARY_INTEGER) asc,col_timestamp3 desc) tablespace users;

insert into tbl_hash1(COL_INT,COL_INTEGER,COL_BINARY_INTEGER,COL_SMALLINT,COL_BIGINT,COL_BINARY_BIGINT,COL_REAL,COL_DOUBLE,COL_FLOAT,COL_BINARY_DOUBLE,COL_DECIMAL,
COL_NUMBER1,COL_NUMBER2,COL_NUMBER3,COL_NUMBER4,COL_NUMBER5,COL_NUMERIC,COL_CHAR1,COL_CHAR2,COL_NCHAR1,COL_NCHAR2,COL_VARCHAR_200,COL_VARCHAR_8000,
COL_VARCHAR2_1000,COL_VARCHAR2_8000,COL_NVARCHAR1,COL_NVARCHAR2,COL_NVARCHAR2_1000,COL_NVARCHAR2_8000,COL_CLOB,COL_TEXT,COL_LONGTEXT,COL_IMAGE,COL_BINARY1,COL_BINARY2,COL_VARBINARY1,COL_VARBINARY2,
COL_RAW1,COL_RAW2,COL_BLOB,COL_DATE,COL_DATETIME,COL_TIMESTAMP1,COL_TIMESTAMP2,COL_TIMESTAMP3,COL_TIMESTAMP4,COL_BOOL,COL_BOOLEAN,COL_INTERVAL1,COL_INTERVAL2) values
(0,0,null,1,'2',null,'-92.9','84.526','-63.478',null,null,'34.2','10.0','-72.904',
0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000042,'3.501','-39.97','030031e14bc14eb2b4e4c003070f4439',
'28c0edeee23b4229aaa1847e903c258a','d589dfefd62c4841859d137363fe1ab7','26141db0dcb248538741e9b0d54d3a56','bbf3ac65c9ef43e1837af59398b74e14','ede135be66d249d8899a335cf37b3454','0d0b97a88d1e4d9cadc706a7892028e2',null,'1783c72ccab1498cb5ee06232a87f8f1',null,null,'ed1a6a10c0354c35b301d4cfa9192c4e',null,'CLOB','CLOB',null,null,'17ddd254ec4c4c519925105021bd5f07','ac0aa4f80e714fb0bb164c52217831d5','0a2917c285c3459e909ccc75f5dcd2fb',null,'c9fc834af295477a9af5f63f243281d2','22A6B4D821E1FDE32142B9EF7D7390045A','2018-10-28 11:35:20','2018-11-27 03:27:17','2019-06-08 09:20:52','2019-03-07 04:15:24','1729-10-10 07:20:43',null,'T',null,'60-6','13 12:4:18.13263');
insert into tbl_hash1(COL_INT,COL_INTEGER,COL_BINARY_INTEGER,COL_SMALLINT,COL_BIGINT,COL_BINARY_BIGINT,COL_REAL,COL_DOUBLE,COL_FLOAT,COL_BINARY_DOUBLE,COL_DECIMAL,COL_NUMBER1,COL_NUMBER2,COL_NUMBER3,COL_NUMBER4,COL_NUMBER5,COL_NUMERIC,COL_CHAR1,COL_CHAR2,COL_NCHAR1,COL_NCHAR2,COL_VARCHAR_200,COL_VARCHAR_8000,COL_VARCHAR2_1000,COL_VARCHAR2_8000,COL_NVARCHAR1,COL_NVARCHAR2,COL_NVARCHAR2_1000,COL_NVARCHAR2_8000,COL_CLOB,COL_TEXT,COL_LONGTEXT,COL_IMAGE,COL_BINARY1,COL_BINARY2,COL_VARBINARY1,COL_VARBINARY2,COL_RAW1,COL_RAW2,COL_BLOB,COL_DATE,COL_DATETIME,COL_TIMESTAMP1,COL_TIMESTAMP2,COL_TIMESTAMP3,COL_TIMESTAMP4,COL_BOOL,COL_BOOLEAN,COL_INTERVAL1,COL_INTERVAL2) values(1,5,'2',3,'7','8','59.221','94.91','-3.2','-96.0','-94.0','87.21','12.8','90.0',0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000033,null,'55.59','f2600ee4fb86435fb16accdef99640ca','29a4f8d05b8b4a4f88f6c44a646e961f','1b5e34c1488b45bfb55b4575611e23aa','8e96531c76fd4fdc83b6ef2842c56291','789278ad7e1f48bcb958aba6285c3a06','4ee23c4c7cbe44eea017f744cc6c53e2','1d1ebe4fdef04b0bb34921c82133348f','18a496181cc5441686fc9c6b5da4794f','f226d8ff984148cf8f1d7c70d590c115',null,'d439690c5b564360b1afb7c139146f4d','4c8e3486dad54796874497c832ca1dc6',null,'CLOB','CLOB',null,'79f6728f8e3f4cef8a378c82190ec3ef','d99a3c08102f4b97a16693728016e272','af597e88b0da487d8d148e9a87020b7e','2995914fe1184b38a2a90959fb99f050','920cf3e1854b40c8bcefcae51005c4ec','7fc17a383fa94312a22c944aba24a751','22A6B4D821E1FDE32142B9EF7D7390045A','2018-10-31 11:06:46','2019-01-13 08:52:06','2018-09-05 10:50:05','2018-08-01 08:41:12','5714-03-05 01:10:24',null,'f',null,'32-11','14 0:8:10.259945');

update tbl_hash1 t1 set t1.col_varchar2_1000 = col_varchar2_1000 where col_int < 1;
update tbl_hash1 t1 set t1.col_numeric = col_numeric where col_int < 1;
update tbl_hash1 t1 set t1.col_raw1 = col_raw1 where col_int < 1;
drop table tbl_hash1;

--DTS2019021500313:When the number of partitions exceeds 65535, it falls into a dead cycle at truncate
drop table if exists test_part_truncate1;
CREATE TABLE test_part_truncate1(THE_ID INT, C_TEXT BLOB,C_CLOB CLOB)PARTITION BY RANGE(THE_ID)INTERVAL(1)
(
PARTITION trai1 VALUES LESS than(1),
PARTITION trai2 VALUES LESS than(2),
PARTITION trai3 VALUES LESS than(3)
);
insert into test_part_truncate1 values (1, '0000', '11111');
insert into test_part_truncate1 values (65534, '0000', '11111');
commit;
truncate table test_part_truncate1;

insert into test_part_truncate1 values (1, '0000', '11111');
insert into test_part_truncate1 values (65535, '0000', '11111');
commit;
truncate table test_part_truncate1;

insert into test_part_truncate1 values (1, '0000', '11111');
insert into test_part_truncate1 values (65536, '0000', '11111');
commit;
truncate table test_part_truncate1;
drop table test_part_truncate1;

drop table if exists test_range;
create table test_range(f1 int, f2 int, f3 int)
PARTITION BY RANGE(f1,f2)
(
 PARTITION p1 values less than(10,20),
 PARTITION p3 values less than(30,40),
 PARTITION p4 values less than(MAXVALUE,MAXVALUE)
);

insert into test_range values(5,6,1);
insert into test_range values(15,26,2);
insert into test_range values(35,46,3);

select PART#,NAME,FLAGS from SYS_TABLE_PARTS where TABLE# = (select ID from SYS_TABLES where NAME='TEST_RANGE') order by PART# desc;
alter table test_range drop partition p4;
select PART#,NAME,FLAGS from SYS_TABLE_PARTS where TABLE# = (select ID from SYS_TABLES where NAME='TEST_RANGE') order by PART# desc;
alter table test_range add partition p4 values less than (MAXVALUE,MAXVALUE);
select PART#,NAME,FLAGS from SYS_TABLE_PARTS where TABLE# = (select ID from SYS_TABLES where NAME='TEST_RANGE') order by PART# desc;
drop table test_range;

--DTS2019021408096:Invalidate dc when the state(is_invalid) of global index is changed
ALTER SYSTEM SET RECYCLEBIN = FALSE;
DROP TABLE IF EXISTS TEST;
CREATE TABLE TEST (i int, id int) PARTITION BY RANGE(i) (PARTITION p1 VALUES LESS THAN(10), PARTITION p2 VALUES LESS THAN (maxvalue));
CREATE INDEX idx_test ON TEST(i);

INSERT INTO TEST VALUES(1,1);
INSERT INTO TEST VALUES(16,16);
COMMIT;

ALTER TABLE TEST TRUNCATE PARTITION p1;
TRUNCATE TABLE TEST;
INSERT INTO TEST VALUES (1, 6);
CREATE INDEX idx_3333 ON TEST(id);
DELETE FROM TEST;
DROP TABLE IF EXISTS TEST;

CREATE TABLE TEST (i int, id int) PARTITION BY RANGE(i) (PARTITION p1 VALUES LESS THAN(10), PARTITION p2 VALUES LESS THAN (maxvalue));
CREATE INDEX idx_test1 ON TEST(i) parallel 5;
CREATE INDEX idx_test2 ON TEST(id);

INSERT INTO TEST VALUES(1,1);
INSERT INTO TEST VALUES(16,16);
ALTER TABLE TEST DROP PARTITION p1;
TRUNCATE TABLE TEST;

ALTER INDEX idx_test1 ON TEST REBUILD ONLINE;
DROP TABLE IF EXISTS TEST;
ALTER SYSTEM SET RECYCLEBIN = TRUE;

---PCR PAGE CACHE TEST
DROP TABLE IF EXISTS PCR_00 PURGE;
CREATE TABLE PCR_00 (ID INT, TT INT);
INSERT INTO PCR_00 VALUES (0, 0);
COMMIT;

CREATE OR REPLACE PROCEDURE PCR_00_FUC (STARTALL INT,ENDALL INT)  AS
I INT;
BEGIN
  FOR I IN STARTALL..ENDALL LOOP
        INSERT INTO PCR_00 SELECT ID+I, TT+I FROM PCR_00 WHERE ID = 0;COMMIT;
  END LOOP;
END;
/
CALL PCR_00_FUC(1,8);
DELETE FROM PCR_00 WHERE ID = 0;
COMMIT;

DROP TABLE IF EXISTS PCR_01 PURGE;
CREATE TABLE PCR_01 (ID INT, TT INT) PARTITION BY HASH(ID)
(PARTITION P1, PARTITION P2) CRMODE PAGE;

CREATE UNIQUE INDEX IDX_PCR_01_1 ON PCR_01 (ID);
CREATE INDEX IDX_PCR_01_2 ON PCR_01 (TT) LOCAL;

INSERT INTO PCR_01 SELECT * FROM PCR_00;
COMMIT;

UPDATE PCR_01 SET TT = TT + 1 WHERE ID < 2 OR ID > 7;
ROLLBACK;

DROP TABLE IF EXISTS PCR_00 PURGE;
DROP TABLE IF EXISTS PCR_01 PURGE;

DROP TABLE IF EXISTS TEST_VIEW_EMP2;
DROP TABLE IF EXISTS TEST_INTREVAL_ALL_PART_STORE;
CREATE TABLE TEST_VIEW_EMP2
(EMPNO VARCHAR(20) NOT NULL ,
EMPNAME VARCHAR(20),
JOB VARCHAR(20),
MGR INT,
HIREDATE DATE,
SALARY INT,
DEPTNO INT);
INSERT INTO TEST_VIEW_EMP2 VALUES('7369','SMITH','CLERK','7902',to_date('1981-02-01','yyyy-mm-dd'),'800','20');
INSERT INTO TEST_VIEW_EMP2 VALUES('7499','ALLEN','SALESMAN','7698',to_date('1981-02-02','yyyy-mm-dd'),'1600','30');
INSERT INTO TEST_VIEW_EMP2 VALUES('7521','WARD','SALESMAN','7698',to_date('1981-02-03','yyyy-mm-dd'),'1250','30');
INSERT INTO TEST_VIEW_EMP2 VALUES('7566','JONES','MANAGER','7839',to_date('1981-02-04','yyyy-mm-dd'),'2975','20');
INSERT INTO TEST_VIEW_EMP2 VALUES('7654','MARTIN','SALESMAN','7698',to_date('1981-02-05','yyyy-mm-dd'),'1250','30');
commit;
create table TEST_INTREVAL_ALL_PART_STORE
( EMPNO VARCHAR2(20) NOT NULL,
EMPNAME VARCHAR2(20),
JOB VARCHAR2(20),
MGR NUMBER(38),
HIREDATE DATE,
SALARY NUMBER(38),
DEPTNO NUMBER(38))
PARTITION BY RANGE (HIREDATE)
INTERVAL (NUMTODSINTERVAL(1,'DAY'))
STORE IN(tablespace users, tablespace system)
(PARTITION ALL_PART_STORE_PART01
VALUES LESS THAN (TO_DATE ('02/02/1981', 'MM/DD/YYYY')),
PARTITION ALL_PART_STORE_PART02
VALUES LESS THAN (TO_DATE ('03/02/1981', 'MM/DD/YYYY'))
);
insert into TEST_INTREVAL_ALL_PART_STORE select * from TEST_VIEW_EMP2;
commit;
SELECT NAME FROM ALL_PART_STORE WHERE NAME =(SELECT NAME FROM ALL_PART_STORE WHERE NAME ='TEST_INTREVAL_ALL_PART_STORE' and POSITION =1) ORDER BY NAME;
DROP TABLE TEST_VIEW_EMP2;
DROP TABLE TEST_INTREVAL_ALL_PART_STORE;

drop table if exists test_add_null_part;
create table test_add_null_part(c1 int,c2 bigint,c3 varchar(20)) PARTITION BY list(c3) (PARTITION p1 VALUES ('sss','ss'), PARTITION p2 VALUES (''),PARTITION p3 VALUES ('null'),PARTITION p4 VALUES ('bb'));
alter table test_add_null_part ADD PARTITION p5 values('') DEFAULT;
drop table test_add_null_part;

drop table if exists strg_update_part_merge_mul_list_001;
create table strg_update_part_merge_mul_list_001(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar2(8000) NOT NULL,c_street_2 varchar2(8000),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_unsig tinyint unsigned,c_big bigint,c_vchar varchar2(8000),c_data long,c_text blob,c_clob clob,c_image image,c_binary binary(5000),c_varbinary varbinary(5000),c_raw raw(5000)) partition by list(c_w_id,c_last,c_end) (partition part_1 values ((1,'AABAR1ddBARBAR',to_date('2017-01-01','yyyy-mm-dd')),(2,'AABAR2ddBARBAR',to_date('2017-01-02','yyyy-mm-dd')),(3,'AABAR3ddBARBAR',to_date('2017-01-03','yyyy-mm-dd')),(4,'AABAR4ddBARBAR',to_date('2017-01-04','yyyy-mm-dd')),(5,'AABAR5ddBARBAR',to_date('2017-01-05','yyyy-mm-dd')),(6,'AABAR6ddBARBAR',to_date('2017-01-06','yyyy-mm-dd')),(7,'AABAR7ddBARBAR',to_date('2017-01-07','yyyy-mm-dd')),(8,'AABAR8ddBARBAR',to_date('2017-01-08','yyyy-mm-dd')),(9,'AABAR9ddBARBAR',to_date('2017-01-09','yyyy-mm-dd')),(10,'AABAR10ddBARBAR',to_date('2017-01-10','yyyy-mm-dd')),(11,'AABAR11ddBARBAR',to_date('2017-01-11','yyyy-mm-dd')),(12,'AABAR12ddBARBAR',to_date('2017-01-12','yyyy-mm-dd')),(13,'AABAR13ddBARBAR',to_date('2017-01-13','yyyy-mm-dd')),(14,'AABAR14ddBARBAR',to_date('2017-01-14','yyyy-mm-dd')),(15,'AABAR15ddBARBAR',to_date('2017-01-15','yyyy-mm-dd')),(16,'AABAR16ddBARBAR',to_date('2017-01-16','yyyy-mm-dd')),(17,'AABAR17ddBARBAR',to_date('2017-01-17','yyyy-mm-dd')),(18,'AABAR18ddBARBAR',to_date('2017-01-18','yyyy-mm-dd')),(19,'AABAR19ddBARBAR',to_date('2017-01-19','yyyy-mm-dd')),(20,'AABAR20ddBARBAR',to_date('2017-01-20','yyyy-mm-dd')),(21,'AABAR21ddBARBAR',to_date('2017-01-21','yyyy-mm-dd')),(22,'AABAR22ddBARBAR',to_date('2017-01-22','yyyy-mm-dd')),(23,'AABAR23ddBARBAR',to_date('2017-01-23','yyyy-mm-dd')),(24,'AABAR24ddBARBAR',to_date('2017-01-24','yyyy-mm-dd')),(25,'AABAR25ddBARBAR',to_date('2017-01-25','yyyy-mm-dd')),(26,'AABAR26ddBARBAR',to_date('2017-01-26','yyyy-mm-dd')),(27,'AABAR27ddBARBAR',to_date('2017-01-27','yyyy-mm-dd')),(28,'AABAR28ddBARBAR',to_date('2017-01-28','yyyy-mm-dd')),(29,'AABAR29ddBARBAR',to_date('2017-01-29','yyyy-mm-dd')),(30,'AABAR30ddBARBAR',to_date('2017-01-30','yyyy-mm-dd')),(31,'AABAR31ddBARBAR',to_date('2017-01-31','yyyy-mm-dd')),(32,'AABAR32ddBARBAR',to_date('2017-02-01','yyyy-mm-dd')),(33,'AABAR33ddBARBAR',to_date('2017-02-02','yyyy-mm-dd')),(34,'AABAR34ddBARBAR',to_date('2017-02-03','yyyy-mm-dd')),(35,'AABAR35ddBARBAR',to_date('2017-02-04','yyyy-mm-dd')),(36,'AABAR36ddBARBAR',to_date('2017-02-05','yyyy-mm-dd')),(37,'AABAR37ddBARBAR',to_date('2017-02-06','yyyy-mm-dd')),(38,'AABAR38ddBARBAR',to_date('2017-02-07','yyyy-mm-dd')),(39,'AABAR39ddBARBAR',to_date('2017-02-08','yyyy-mm-dd')),(40,'AABAR40ddBARBAR',to_date('2017-02-09','yyyy-mm-dd')),(41,'AABAR41ddBARBAR',to_date('2017-02-10','yyyy-mm-dd')),(42,'AABAR42ddBARBAR',to_date('2017-02-11','yyyy-mm-dd')),(43,'AABAR43ddBARBAR',to_date('2017-02-12','yyyy-mm-dd')),(44,'AABAR44ddBARBAR',to_date('2017-02-13','yyyy-mm-dd')),(45,'AABAR45ddBARBAR',to_date('2017-02-14','yyyy-mm-dd')),(46,'AABAR46ddBARBAR',to_date('2017-02-15','yyyy-mm-dd')),(47,'AABAR47ddBARBAR',to_date('2017-02-16','yyyy-mm-dd')),(48,'AABAR48ddBARBAR',to_date('2017-02-17','yyyy-mm-dd')),(49,'AABAR49ddBARBAR',to_date('2017-02-18','yyyy-mm-dd')),(50,'AABAR50ddBARBAR',to_date('2017-02-19','yyyy-mm-dd')),(51,'AABAR51ddBARBAR',to_date('2017-02-20','yyyy-mm-dd')),(52,'AABAR52ddBARBAR',to_date('2017-02-21','yyyy-mm-dd')),(53,'AABAR53ddBARBAR',to_date('2017-02-22','yyyy-mm-dd')),(54,'AABAR54ddBARBAR',to_date('2017-02-23','yyyy-mm-dd')),(55,'AABAR55ddBARBAR',to_date('2017-02-24','yyyy-mm-dd')),(56,'AABAR56ddBARBAR',to_date('2017-02-25','yyyy-mm-dd')),(57,'AABAR57ddBARBAR',to_date('2017-02-26','yyyy-mm-dd')),(58,'AABAR58ddBARBAR',to_date('2017-02-27','yyyy-mm-dd')),(59,'AABAR59ddBARBAR',to_date('2017-02-28','yyyy-mm-dd')),(60,'AABAR60ddBARBAR',to_date('2017-03-01','yyyy-mm-dd')),(61,'AABAR61ddBARBAR',to_date('2017-03-02','yyyy-mm-dd')),(62,'AABAR62ddBARBAR',to_date('2017-03-03','yyyy-mm-dd')),(63,'AABAR63ddBARBAR',to_date('2017-03-04','yyyy-mm-dd')),(64,'AABAR64ddBARBAR',to_date('2017-03-05','yyyy-mm-dd')),(65,'AABAR65ddBARBAR',to_date('2017-03-06','yyyy-mm-dd')),(66,'AABAR66ddBARBAR',to_date('2017-03-07','yyyy-mm-dd')),(67,'AABAR67ddBARBAR',to_date('2017-03-08','yyyy-mm-dd')),(68,'AABAR68ddBARBAR',to_date('2017-03-09','yyyy-mm-dd')),(69,'AABAR69ddBARBAR',to_date('2017-03-10','yyyy-mm-dd')),(70,'AABAR70ddBARBAR',to_date('2017-03-11','yyyy-mm-dd')),(71,'AABAR71ddBARBAR',to_date('2017-03-12','yyyy-mm-dd')),(72,'AABAR72ddBARBAR',to_date('2017-03-13','yyyy-mm-dd')),(73,'AABAR73ddBARBAR',to_date('2017-03-14','yyyy-mm-dd')),(74,'AABAR74ddBARBAR',to_date('2017-03-15','yyyy-mm-dd')),(75,'AABAR75ddBARBAR',to_date('2017-03-16','yyyy-mm-dd')),(76,'AABAR76ddBARBAR',to_date('2017-03-17','yyyy-mm-dd')),(77,'AABAR77ddBARBAR',to_date('2017-03-18','yyyy-mm-dd')),(78,'AABAR78ddBARBAR',to_date('2017-03-19','yyyy-mm-dd')),(79,'AABAR79ddBARBAR',to_date('2017-03-20','yyyy-mm-dd')),(80,'AABAR80ddBARBAR',to_date('2017-03-21','yyyy-mm-dd')),(81,'AABAR81ddBARBAR',to_date('2017-03-22','yyyy-mm-dd')),(82,'AABAR82ddBARBAR',to_date('2017-03-23','yyyy-mm-dd')),(83,'AABAR83ddBARBAR',to_date('2017-03-24','yyyy-mm-dd')),(84,'AABAR84ddBARBAR',to_date('2017-03-25','yyyy-mm-dd')),(85,'AABAR85ddBARBAR',to_date('2017-03-26','yyyy-mm-dd')),(86,'AABAR86ddBARBAR',to_date('2017-03-27','yyyy-mm-dd')),(87,'AABAR87ddBARBAR',to_date('2017-03-28','yyyy-mm-dd')),(88,'AABAR88ddBARBAR',to_date('2017-03-29','yyyy-mm-dd')),(89,'AABAR89ddBARBAR',to_date('2017-03-30','yyyy-mm-dd')),(90,'AABAR90ddBARBAR',to_date('2017-03-31','yyyy-mm-dd')),(91,'AABAR91ddBARBAR',to_date('2017-04-01','yyyy-mm-dd')),(92,'AABAR92ddBARBAR',to_date('2017-04-02','yyyy-mm-dd')),(93,'AABAR93ddBARBAR',to_date('2017-04-03','yyyy-mm-dd')),(94,'AABAR94ddBARBAR',to_date('2017-04-04','yyyy-mm-dd')),(95,'AABAR95ddBARBAR',to_date('2017-04-05','yyyy-mm-dd')),(96,'AABAR96ddBARBAR',to_date('2017-04-06','yyyy-mm-dd')),(97,'AABAR97ddBARBAR',to_date('2017-04-07','yyyy-mm-dd')),(98,'AABAR98ddBARBAR',to_date('2017-04-08','yyyy-mm-dd')),(99,'AABAR99ddBARBAR',to_date('2017-04-09','yyyy-mm-dd')),(100,'AABAR100ddBARBAR',to_date('2017-04-10','yyyy-mm-dd')),(101,'AABAR101ddBARBAR',to_date('2017-04-11','yyyy-mm-dd')),(102,'AABAR102ddBARBAR',to_date('2017-04-12','yyyy-mm-dd')),(103,'AABAR103ddBARBAR',to_date('2017-04-13','yyyy-mm-dd')),(104,'AABAR104ddBARBAR',to_date('2017-04-14','yyyy-mm-dd')),(105,'AABAR105ddBARBAR',to_date('2017-04-15','yyyy-mm-dd')),(106,'AABAR106ddBARBAR',to_date('2017-04-16','yyyy-mm-dd')),(107,'AABAR107ddBARBAR',to_date('2017-04-17','yyyy-mm-dd')),(108,'AABAR108ddBARBAR',to_date('2017-04-18','yyyy-mm-dd')),(109,'AABAR109ddBARBAR',to_date('2017-04-19','yyyy-mm-dd')),(110,'AABAR110ddBARBAR',to_date('2017-04-20','yyyy-mm-dd')),(111,'AABAR111ddBARBAR',to_date('2017-04-21','yyyy-mm-dd')),(112,'AABAR112ddBARBAR',to_date('2017-04-22','yyyy-mm-dd')),(113,'AABAR113ddBARBAR',to_date('2017-04-23','yyyy-mm-dd')),(114,'AABAR114ddBARBAR',to_date('2017-04-24','yyyy-mm-dd')),(115,'AABAR115ddBARBAR',to_date('2017-04-25','yyyy-mm-dd')),(116,'AABAR116ddBARBAR',to_date('2017-04-26','yyyy-mm-dd')),(117,'AABAR117ddBARBAR',to_date('2017-04-27','yyyy-mm-dd')),(118,'AABAR118ddBARBAR',to_date('2017-04-28','yyyy-mm-dd')),(119,'AABAR119ddBARBAR',to_date('2017-04-29','yyyy-mm-dd')),(120,'AABAR120ddBARBAR',to_date('2017-04-30','yyyy-mm-dd')),(121,'AABAR121ddBARBAR',to_date('2017-05-01','yyyy-mm-dd')),(122,'AABAR122ddBARBAR',to_date('2017-05-02','yyyy-mm-dd')),(123,'AABAR123ddBARBAR',to_date('2017-05-03','yyyy-mm-dd')),(124,'AABAR124ddBARBAR',to_date('2017-05-04','yyyy-mm-dd')),(125,'AABAR125ddBARBAR',to_date('2017-05-05','yyyy-mm-dd')),(126,'AABAR126ddBARBAR',to_date('2017-05-06','yyyy-mm-dd')),(127,'AABAR127ddBARBAR',to_date('2017-05-07','yyyy-mm-dd')),(128,'AABAR128ddBARBAR',to_date('2017-05-08','yyyy-mm-dd')),(129,'AABAR129ddBARBAR',to_date('2017-05-09','yyyy-mm-dd')),(130,'AABAR130ddBARBAR',to_date('2017-05-10','yyyy-mm-dd')),(131,'AABAR131ddBARBAR',to_date('2017-05-11','yyyy-mm-dd')),(132,'AABAR132ddBARBAR',to_date('2017-05-12','yyyy-mm-dd')),(133,'AABAR133ddBARBAR',to_date('2017-05-13','yyyy-mm-dd')),(134,'AABAR134ddBARBAR',to_date('2017-05-14','yyyy-mm-dd')),(135,'AABAR135ddBARBAR',to_date('2017-05-15','yyyy-mm-dd')),(136,'AABAR136ddBARBAR',to_date('2017-05-16','yyyy-mm-dd')),(137,'AABAR137ddBARBAR',to_date('2017-05-17','yyyy-mm-dd')),(138,'AABAR138ddBARBAR',to_date('2017-05-18','yyyy-mm-dd')),(139,'AABAR139ddBARBAR',to_date('2017-05-19','yyyy-mm-dd')),(140,'AABAR140ddBARBAR',to_date('2017-05-20','yyyy-mm-dd')),(141,'AABAR141ddBARBAR',to_date('2017-05-21','yyyy-mm-dd')),(142,'AABAR142ddBARBAR',to_date('2017-05-22','yyyy-mm-dd')),(143,'AABAR143ddBARBAR',to_date('2017-05-23','yyyy-mm-dd')),(144,'AABAR144ddBARBAR',to_date('2017-05-24','yyyy-mm-dd')),(145,'AABAR145ddBARBAR',to_date('2017-05-25','yyyy-mm-dd')),(146,'AABAR146ddBARBAR',to_date('2017-05-26','yyyy-mm-dd')),(147,'AABAR147ddBARBAR',to_date('2017-05-27','yyyy-mm-dd')),(148,'AABAR148ddBARBAR',to_date('2017-05-28','yyyy-mm-dd')),(149,'AABAR149ddBARBAR',to_date('2017-05-29','yyyy-mm-dd')),(150,'AABAR150ddBARBAR',to_date('2017-05-30','yyyy-mm-dd')),(151,'AABAR151ddBARBAR',to_date('2017-05-31','yyyy-mm-dd')),(152,'AABAR152ddBARBAR',to_date('2017-06-01','yyyy-mm-dd')),(153,'AABAR153ddBARBAR',to_date('2017-06-02','yyyy-mm-dd')),(154,'AABAR154ddBARBAR',to_date('2017-06-03','yyyy-mm-dd')),(155,'AABA
R155ddBARBAR',to_date('2017-06-04','yyyy-mm-dd')),(156,'AABAR156ddBARBAR',to_date('2017-06-05','yyyy-mm-dd')),(157,'AABAR157ddBARBAR',to_date('2017-06-06','yyyy-mm-dd')),(158,'AABAR158ddBARBAR',to_date('2017-06-07','yyyy-mm-dd')),(159,'AABAR159ddBARBAR',to_date('2017-06-08','yyyy-mm-dd')),(160,'AABAR160ddBARBAR',to_date('2017-06-09','yyyy-mm-dd')),(161,'AABAR161ddBARBAR',to_date('2017-06-10','yyyy-mm-dd')),(162,'AABAR162ddBARBAR',to_date('2017-06-11','yyyy-mm-dd')),(163,'AABAR163ddBARBAR',to_date('2017-06-12','yyyy-mm-dd')),(164,'AABAR164ddBARBAR',to_date('2017-06-13','yyyy-mm-dd')),(165,'AABAR165ddBARBAR',to_date('2017-06-14','yyyy-mm-dd')),(166,'AABAR166ddBARBAR',to_date('2017-06-15','yyyy-mm-dd')),(167,'AABAR167ddBARBAR',to_date('2017-06-16','yyyy-mm-dd')),(168,'AABAR168ddBARBAR',to_date('2017-06-17','yyyy-mm-dd')),(169,'AABAR169ddBARBAR',to_date('2017-06-18','yyyy-mm-dd')),(170,'AABAR170ddBARBAR',to_date('2017-06-19','yyyy-mm-dd')),(171,'AABAR171ddBARBAR',to_date('2017-06-20','yyyy-mm-dd')),(172,'AABAR172ddBARBAR',to_date('2017-06-21','yyyy-mm-dd')),(173,'AABAR173ddBARBAR',to_date('2017-06-22','yyyy-mm-dd')),(174,'AABAR174ddBARBAR',to_date('2017-06-23','yyyy-mm-dd')),(175,'AABAR175ddBARBAR',to_date('2017-06-24','yyyy-mm-dd')),(176,'AABAR176ddBARBAR',to_date('2017-06-25','yyyy-mm-dd')),(177,'AABAR177ddBARBAR',to_date('2017-06-26','yyyy-mm-dd')),(178,'AABAR178ddBARBAR',to_date('2017-06-27','yyyy-mm-dd')),(179,'AABAR179ddBARBAR',to_date('2017-06-28','yyyy-mm-dd')),(180,'AABAR180ddBARBAR',to_date('2017-06-29','yyyy-mm-dd')),(181,'AABAR181ddBARBAR',to_date('2017-06-30','yyyy-mm-dd')),(182,'AABAR182ddBARBAR',to_date('2017-07-01','yyyy-mm-dd')),(183,'AABAR183ddBARBAR',to_date('2017-07-02','yyyy-mm-dd')),(184,'AABAR184ddBARBAR',to_date('2017-07-03','yyyy-mm-dd')),(185,'AABAR185ddBARBAR',to_date('2017-07-04','yyyy-mm-dd')),(186,'AABAR186ddBARBAR',to_date('2017-07-05','yyyy-mm-dd')),(187,'AABAR187ddBARBAR',to_date('2017-07-06','yyyy-mm-dd')),(188,'AABAR188ddBARBAR',to_date('2017-07-07','yyyy-mm-dd')),(189,'AABAR189ddBARBAR',to_date('2017-07-08','yyyy-mm-dd')),(190,'AABAR190ddBARBAR',to_date('2017-07-09','yyyy-mm-dd')),(191,'AABAR191ddBARBAR',to_date('2017-07-10','yyyy-mm-dd')),(192,'AABAR192ddBARBAR',to_date('2017-07-11','yyyy-mm-dd')),(193,'AABAR193ddBARBAR',to_date('2017-07-12','yyyy-mm-dd')),(194,'AABAR194ddBARBAR',to_date('2017-07-13','yyyy-mm-dd')),(195,'AABAR195ddBARBAR',to_date('2017-07-14','yyyy-mm-dd')),(196,'AABAR196ddBARBAR',to_date('2017-07-15','yyyy-mm-dd')),(197,'AABAR197ddBARBAR',to_date('2017-07-16','yyyy-mm-dd')),(198,'AABAR198ddBARBAR',to_date('2017-07-17','yyyy-mm-dd')),(199,'AABAR199ddBARBAR',to_date('2017-07-18','yyyy-mm-dd')),(200,'AABAR200ddBARBAR',to_date('2017-07-19','yyyy-mm-dd'))),partition part_2 values ((201,'AABAR201ddBARBAR',to_date('2017-07-20','yyyy-mm-dd'))),PARTITION PART_10 VALUES (DEFAULT));

select t.table_name,t.partition_name from adm_tab_partitions t where t.table_name = 'STRG_UPDATE_PART_MERGE_MUL_LIST_001' order by t.partition_name;

--ADD PARTITION PRUNE TEST CASE
drop table if exists multi_col_prune1 purge;
create table multi_col_prune1(STARTTIME DATE NOT NULL, "HOUR" BINARY_INTEGER NOT NULL) PARTITION BY RANGE ("STARTTIME", "HOUR") 
(
    PARTITION DEFAULT_19000101 VALUES LESS THAN (to_date('19000101', 'YYYYMMDD'),0),             -- 0
    PARTITION PRS_PART_20190610 VALUES LESS THAN (to_date('20190610', 'YYYYMMDD'),0),            -- 1
    PARTITION PRS_PART_2019061012 VALUES LESS THAN (to_date('20190610', 'YYYYMMDD'),12),         -- 2
    PARTITION PRS_PART_2019061023 VALUES LESS THAN (to_date('20190610', 'YYYYMMDD'),23),         -- 3
    PARTITION PRS_PART_20190611 VALUES LESS THAN (to_date('20190611', 'YYYYMMDD'),0),            -- 4
    PARTITION PRS_PART_2019061112 VALUES LESS THAN (to_date('20190611', 'YYYYMMDD'),12),         -- 5
    PARTITION PRS_PART_2019061123 VALUES LESS THAN (to_date('20190611', 'YYYYMMDD'),23),         -- 6
    PARTITION PRS_PART_20190612 VALUES LESS THAN (to_date('20190612', 'YYYYMMDD'),0),            -- 7
    PARTITION PRS_PART_2019061212 VALUES LESS THAN (to_date('20190612', 'YYYYMMDD'),12),         -- 8
    PARTITION PRS_PART_2019061223 VALUES LESS THAN (to_date('20190612', 'YYYYMMDD'),23),         -- 9
    PARTITION PRS_PART_20190613 VALUES LESS THAN (to_date('20190613', 'YYYYMMDD'),0)             -- 10
);

explain select * from multi_col_prune1 where StartTime < to_date('2019-06-11 00:00', 'YYYY-MM-DD HH24:MI');              -- FILTER 0, 1, 2, 3, 4
explain select * from multi_col_prune1 where StartTime <= to_date('2019-06-11 00:00', 'YYYY-MM-DD HH24:MI');             -- FILTER 0, 1, 2, 3, 4, 5, 6, 7
explain select * from multi_col_prune1 where StartTime > to_date('2019-06-11 00:00', 'YYYY-MM-DD HH24:MI');              -- FILTER 7, 8, 9, 10
explain select * from multi_col_prune1 where StartTime >= to_date('2019-06-10 00:00', 'YYYY-MM-DD HH24:MI') and StartTime < to_date('2019-06-11 00:00', 'YYYY-MM-DD HH24:MI');  -- FILTER 1, 2, 3, 4
explain select * from multi_col_prune1 where StartTime > to_date('2019-06-11 00:00', 'YYYY-MM-DD HH24:MI') and StartTime < to_date('2019-06-12 00:00', 'YYYY-MM-DD HH24:MI');  -- FILTER 7
drop table multi_col_prune1 purge;

drop table if exists multi_col_prune2 purge;
create table multi_col_prune2 (id1 int, id2 int)
partition by range (id1, id2)
(
partition p1 values less than (10, 10),                  -- 0
partition p2 values less than (20, 20),                  -- 1
partition p3 values less than (20, 30),                  -- 2
partition p4 values less than (maxvalue, maxvalue)       -- 3
);

insert into multi_col_prune2 values (10, 9);
insert into multi_col_prune2 values (10, 10);
insert into multi_col_prune2 values (10, 11);
insert into multi_col_prune2 values (20, 19);
insert into multi_col_prune2 values (20, 20);
insert into multi_col_prune2 values (20, 21);
insert into multi_col_prune2 values (20, 30);
commit;

select * from multi_col_prune2 partition (p1);
select * from multi_col_prune2 partition (p2);
select * from multi_col_prune2 partition (p3);

explain select * from multi_col_prune2 where id1 < 9;   -- FILTER 0
explain select * from multi_col_prune2 where id1 < 10;  -- FILTER 0
explain select * from multi_col_prune2 where id1 <= 10; -- FILTER 0, 1
explain select * from multi_col_prune2 where id1 < 11;  -- FILTER 0, 1
explain select * from multi_col_prune2 where id1 < 19;  -- FILTER 0, 1
explain select * from multi_col_prune2 where id1 < 20;  -- FILTER 0, 1
explain select * from multi_col_prune2 where id1 <= 20; -- FILTER 0, 1, 2, 3
explain select * from multi_col_prune2 where id1 < 21;  -- FILTER 0, 1, 2, 3

explain select * from multi_col_prune2 where id1 > 9;   -- FILTER 0, 1, 2, 3
explain select * from multi_col_prune2 where id1 >= 10; -- FILTER 0, 1, 2, 3
explain select * from multi_col_prune2 where id1 > 10;  -- FILTER 1, 2, 3
explain select * from multi_col_prune2 where id1 > 11;  -- FILTER 1, 2, 3
explain select * from multi_col_prune2 where id1 > 19;  -- FILTER 1, 2, 3
explain select * from multi_col_prune2 where id1 >= 20; -- FILTER 1, 2, 3
explain select * from multi_col_prune2 where id1 > 20;  -- FILTER 3
explain select * from multi_col_prune2 where id1 > 21;  -- FILTER 3
drop table multi_col_prune2 purge;

--split partition  expect sql parse error
drop table if exists test_split_range_table;
drop table if exists test_not_part_table;
drop table if exists test_not_range_table;
create table test_split_range_table(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f1,f2, f3, f4, f5, f6, f7)
(
 PARTITION p1 values less than(10, 15.6, 28.5, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),
 PARTITION p2 values less than(20, 16.6, 29.5, 'efgh', 'efgh', to_date('2018/01/25', 'YYYY/MM/DD'), to_timestamp('2018-01-24 17:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),
 PARTITION p3 values less than(40, 18.6, 31.5, 'zxv', 'zxv',   to_date('2018/01/27', 'YYYY/MM/DD'), to_timestamp('2018-01-24 19:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')),
 PARTITION p4 values less than(MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE)
 
);
create table test_not_part_table(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp); 
create table test_not_range_table(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
partition by list(f1)
(
partition p1 values (1,2,3,4,5),
partition p2 values (6,7,8,9,10),
partition p3 values (11,12,13),
partition p4 values (default)
);

alter table test_split_range_table split  PARTITION p4 at (30, 17.6, 30.5, 'jkla', 'jkla', to_date('2018/01/26', 'YYYY/MM/DD'), to_timestamp('2018-01-24 18:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')) into (partition p5 , partition p5); 
alter table test_split_range_table split  PARTITION p4 at (30, 17.6, 30.5, 'jkla', 'jkla', to_date('2018/01/26', 'YYYY/MM/DD'), to_timestamp('2018-01-24 18:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')) into (partition p5 , partition p6,partition p7); 
alter table test_split_range_table split  PARTITION p3 at (30, 17.6, 30.5, 'jkla', 'jkla', to_date('2018/01/26', 'YYYY/MM/DD'), to_timestamp('2018-01-24 18:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')) into (); 
alter table test_split_range_table split  PARTITION p3 at () into (partition p5 , partition p6); 
alter table test_split_range_table split  PARTITION p3 at (40, 18.6, 31.5, 'zxv', 'zxv',   to_date('2018/01/27', 'YYYY/MM/DD'), to_timestamp('2018-01-24 19:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')) into (partition p5 , partition p6); 
alter table test_not_part_table split  PARTITION p3 at (30, 17.6, 30.5, 'jkla', 'jkla', to_date('2018/01/26', 'YYYY/MM/DD'), to_timestamp('2018-01-24 18:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')) into (partition p5 , partition p6); 
alter table test_not_range_table split  PARTITION p3 at (30, 17.6, 30.5, 'jkla', 'jkla', to_date('2018/01/26', 'YYYY/MM/DD'), to_timestamp('2018-01-24 18:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')) into (partition p5 , partition p6); 

drop table  test_split_range_table;
drop table  test_not_part_table;
drop table  test_not_range_table;
 

drop table if exists test_interval_part;
CREATE TABLE test_interval_part(THE_ID INT, C_TEXT BLOB,C_CLOB CLOB)PARTITION BY RANGE(THE_ID)INTERVAL(1)
(
PARTITION p1 VALUES LESS than(1),
PARTITION p2 VALUES LESS than(3)
);
alter table test_interval_part split partition   p2  at (2) into (partition p3,partition p4) ;
drop table test_interval_part;

drop table if exists test_range_null_key;
create table test_range_null_key(id int, name varchar(20)) partition by range(id)
interval(50)
(
partition p1 values less than(50),
partition p2 values less than(100)
);
insert into test_range_null_key values(NULL, 'AAAAA');
drop table test_range_null_key;

drop table if exists test_hiboundval;
CREATE TABLE test_hiboundval
(
  SN NUMBER NOT NULL,
  OBJID VARBINARY(16) NOT NULL,
  OBJTYPE VARCHAR(128) NOT NULL DEFAULT '',
  OPERATION VARCHAR(64) NOT NULL,
  SENDSTATUS NUMBER(8) NOT NULL DEFAULT 0,
  DATETIME BIGINT NOT NULL,
  USERID VARCHAR(64),
  DETAIL BLOB NOT NULL,
  TENANTID VARCHAR(64)
)partition by range (DATETIME)
INTERVAL(3600000)
(
PARTITION history1 VALUES LESS than(1546272000000)
);
insert into test_hiboundval (sn,objid,OBJTYPE,OPERATION,SENDSTATUS,DATETIME,detail) values(1234,unhex('1124123'),'TEMP','TEMP','2',1552362242048,hex('TEMP'));
insert into test_hiboundval (sn,objid,OBJTYPE,OPERATION,SENDSTATUS,DATETIME,detail) values(1234,unhex('1124123'),'TEMP','TEMP','2',1258764,hex('TEMP'));
select datetime from test_hiboundval;
select datetime from test_hiboundval where datetime > 100000;
select datetime from test_hiboundval where datetime > 1548335710208;
drop table test_hiboundval;

drop table if exists hash_data_distribute;
create table hash_data_distribute(id number) partition by hash(id)
(
partition p1,
partition p2,
partition p3,
partition p4,
partition p5,
partition p6,
partition p7,
partition p8,
partition p9,
partition p10,
partition p11,
partition p12,
partition p13,
partition p14,
partition p15,
partition p16,
partition p17,
partition p18,
partition p19,
partition p20,
partition p21,
partition p22,
partition p23,
partition p24,
partition p25,
partition p26,
partition p27,
partition p28,
partition p29,
partition p30,
partition p31,
partition p32,
partition p33,
partition p34,
partition p35,
partition p36,
partition p37,
partition p38,
partition p39,
partition p40,
partition p41,
partition p42,
partition p43,
partition p44,
partition p45,
partition p46,
partition p47,
partition p48,
partition p49,
partition p50,
partition p51,
partition p52,
partition p53,
partition p54,
partition p55,
partition p56,
partition p57,
partition p58,
partition p59,
partition p60,
partition p61,
partition p62,
partition p63,
partition p64
);

CREATE or replace procedure insert_rand_data(startall int,endall int)  as
i INT;
BEGIN
  FOR i IN startall..endall LOOP
        insert into hash_data_distribute select 16602400 + i * 4;
  END LOOP;
END;
/

call insert_rand_data(0, 13999);

select count(*) from hash_data_distribute partition(p1);
select count(*) from hash_data_distribute partition(p2);
select count(*) from hash_data_distribute partition(p3);
select count(*) from hash_data_distribute partition(p4);
select count(*) from hash_data_distribute partition(p5);
select count(*) from hash_data_distribute partition(p6);
select count(*) from hash_data_distribute partition(p7);
select count(*) from hash_data_distribute partition(p8);
select count(*) from hash_data_distribute partition(p9);
select count(*) from hash_data_distribute partition(p10);
select count(*) from hash_data_distribute partition(p11);
select count(*) from hash_data_distribute partition(p12);
select count(*) from hash_data_distribute partition(p13);
select count(*) from hash_data_distribute partition(p14);
select count(*) from hash_data_distribute partition(p15);
select count(*) from hash_data_distribute partition(p16);
select count(*) from hash_data_distribute partition(p17);
select count(*) from hash_data_distribute partition(p18);
select count(*) from hash_data_distribute partition(p19);
select count(*) from hash_data_distribute partition(p20);
select count(*) from hash_data_distribute partition(p21);
select count(*) from hash_data_distribute partition(p22);
select count(*) from hash_data_distribute partition(p23);
select count(*) from hash_data_distribute partition(p24);
select count(*) from hash_data_distribute partition(p25);
select count(*) from hash_data_distribute partition(p26);
select count(*) from hash_data_distribute partition(p27);
select count(*) from hash_data_distribute partition(p28);
select count(*) from hash_data_distribute partition(p29);
select count(*) from hash_data_distribute partition(p30);
select count(*) from hash_data_distribute partition(p31);
select count(*) from hash_data_distribute partition(p32);
select count(*) from hash_data_distribute partition(p33);
select count(*) from hash_data_distribute partition(p34);
select count(*) from hash_data_distribute partition(p35);
select count(*) from hash_data_distribute partition(p36);
select count(*) from hash_data_distribute partition(p37);
select count(*) from hash_data_distribute partition(p38);
select count(*) from hash_data_distribute partition(p39);
select count(*) from hash_data_distribute partition(p40);
select count(*) from hash_data_distribute partition(p41);
select count(*) from hash_data_distribute partition(p42);
select count(*) from hash_data_distribute partition(p43);
select count(*) from hash_data_distribute partition(p44);
select count(*) from hash_data_distribute partition(p45);
select count(*) from hash_data_distribute partition(p46);
select count(*) from hash_data_distribute partition(p47);
select count(*) from hash_data_distribute partition(p48);
select count(*) from hash_data_distribute partition(p49);
select count(*) from hash_data_distribute partition(p50);
select count(*) from hash_data_distribute partition(p51);
select count(*) from hash_data_distribute partition(p52);
select count(*) from hash_data_distribute partition(p53);
select count(*) from hash_data_distribute partition(p54);
select count(*) from hash_data_distribute partition(p55);
select count(*) from hash_data_distribute partition(p56);
select count(*) from hash_data_distribute partition(p57);
select count(*) from hash_data_distribute partition(p58);
select count(*) from hash_data_distribute partition(p59);
select count(*) from hash_data_distribute partition(p60);
select count(*) from hash_data_distribute partition(p61);
select count(*) from hash_data_distribute partition(p62);
select count(*) from hash_data_distribute partition(p63);
select count(*) from hash_data_distribute partition(p64);
drop table if exists hash_data_distribute;
drop table if exists tvod_result;
create table tvod_result (
    id number(12),
    content_id number(12) not null ,
    device_id number(12) not null ,
    pop_id number(12) not null ,
    lost_time date ,
    renew_time date,
    flag number(12),
    livecontentid number(12),
    constraint PK_tvod_result_id primary key(id) 
)
partition by range (content_id)
(
  partition USER_P_TVOD_RESULT_1 values less than (3621225472),
  partition SYS_PD3E values less than (3621225497),
  partition SYS_PD4E values less than (3621225499),
  partition SYS_PD5E values less than (3621225510),
  partition SYS_PD6E values less than (3621225530),
  partition SYS_PD7E values less than (3621225550),
  partition SYS_PD8E values less than (3621225570)
);
select count(*) from TVOD_RESULT partition (SYS_PD3E);
alter table TVOD_RESULT drop PARTITION SYS_PD3E;
insert into tvod_result (id, content_id, device_id, pop_id, lost_time, renew_time, flag)
               values (1,
                        3621225498,
                        1,
                        1,
                        null,
                        null,
                        1
                        );
select count(*) from TVOD_RESULT partition (SYS_PD4E);						
DELETE FROM  tvod_result WHERE content_id=3621225498;
select count(*) from TVOD_RESULT partition (SYS_PD4E);
alter table TVOD_RESULT drop PARTITION SYS_PD4E;
insert into tvod_result (id, content_id, device_id, pop_id, lost_time, renew_time, flag)
               values (2,
                        3621225508,
                        1,
                        1,
                        null,
                        null,
                        1
                        );
insert into tvod_result (id, content_id, device_id, pop_id, lost_time, renew_time, flag)
               values (3,
                        3621225506,
                        1,
                        1,
                        null,
                        null,
                        1
                        );
select count(*) from TVOD_RESULT partition (SYS_PD5E);
DELETE FROM  tvod_result WHERE content_id=3621225508;
select count(*) from TVOD_RESULT partition (SYS_PD5E);
alter table TVOD_RESULT drop PARTITION SYS_PD5E;
insert into tvod_result (id, content_id, device_id, pop_id, lost_time, renew_time, flag)
               values (4,
                        3621225520,
                        1,
                        1,
                        null,
                        null,
                        1
                        );
						
drop table if exists tvod_result;
create table tvod_result (
    id number(12),
    content_id number(12) not null ,
    device_id number(12) not null ,
    pop_id number(12) not null ,
    lost_time date ,
    renew_time date,
    flag number(12),
    livecontentid number(12),
    constraint PK_tvod_result_id primary key(id) 
)
partition by range (content_id)
(
  partition USER_P_TVOD_RESULT_1 values less than (3621225472),
  partition SYS_PD3E values less than (3621225497),
  partition SYS_PD4E values less than (3621225499),
  partition SYS_PD5E values less than (3621225510),
  partition SYS_PD6E values less than (3621225530),
  partition SYS_PD7E values less than (3621225550),
  partition SYS_PD8E values less than (3621225570)
);
select count(*) from TVOD_RESULT partition (SYS_PD3E);
alter table TVOD_RESULT truncate PARTITION SYS_PD3E;
insert into tvod_result (id, content_id, device_id, pop_id, lost_time, renew_time, flag)
               values (1,
                        3621225498,
                        1,
                        1,
                        null,
                        null,
                        1
                        );
select count(*) from TVOD_RESULT partition (SYS_PD4E);						
DELETE FROM  tvod_result WHERE content_id=3621225498;
select count(*) from TVOD_RESULT partition (SYS_PD4E);
alter table TVOD_RESULT truncate PARTITION SYS_PD4E;
insert into tvod_result (id, content_id, device_id, pop_id, lost_time, renew_time, flag)
               values (2,
                        3621225508,
                        1,
                        1,
                        null,
                        null,
                        1
                        );
insert into tvod_result (id, content_id, device_id, pop_id, lost_time, renew_time, flag)
               values (3,
                        3621225506,
                        1,
                        1,
                        null,
                        null,
                        1
                        );
select count(*) from TVOD_RESULT partition (SYS_PD5E);
DELETE FROM  tvod_result WHERE content_id=3621225508;
select count(*) from TVOD_RESULT partition (SYS_PD5E);
alter table TVOD_RESULT truncate PARTITION SYS_PD5E;
insert into tvod_result (id, content_id, device_id, pop_id, lost_time, renew_time, flag)
               values (4,
                        3621225520,
                        1,
                        1,
                        null,
                        null,
                        1
                        );
drop table if exists tvod_result;

drop table if exists test_split_index;
create table test_split_index(c1 int, c2 int) partition by range(c1)
(partition p1 values less than(100), partition p2 values less than(200));
create index idx1_local on test_split_index(c1) local;
select PART#, NAME from indexpart$ where table# = (select id from table$ where name='TEST_SPLIT_INDEX') order by PART#;
alter table test_split_index split partition p1 at(50) into (partition p11, partition p12);
select PART#, NAME from indexpart$ where table# = (select id from table$ where name='TEST_SPLIT_INDEX') order by PART#;
drop table test_split_index;

drop table if exists test_number_hash;
create table test_number_hash(id number(30)) partition by hash(id)
(
partition p1,
partition p2
);

insert into test_number_hash values(256256256256256256256);
select * from test_number_hash where id = 256256256256256256256;
update test_number_hash set id = 123;
select * from test_number_hash where id = 123;
update test_number_hash set id = 10001001;
select * from test_number_hash where id = 10001001;
update test_number_hash set id = 256256256256256256256;
select * from test_number_hash where id = 256256256256256256256;
drop table test_number_hash;
--DTS2019092108429
drop table if exists partition_test_8429;
create table partition_test_8429(id int not null,c_int int,c_vchar varchar(20) not null,c_clob clob not null,c_blob blob not null,c_date date,constraint partition_test_8429_con primary key(c_vchar))
PARTITION BY RANGE(id) interval(10)
(
PARTITION p1 VALUES LESS THAN(100),
PARTITION p2 VALUES LESS THAN(200),
PARTITION p3 VALUES LESS THAN(300)
);
insert into partition_test_8429 values(1,100,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into partition_test_8429 select id + 100, c_int, c_vchar||'100', c_clob,c_blob,c_date from partition_test_8429;
select count(*) from (partition_test_8429) partition(p2) t1;
select count(*) from ((partition_test_8429) partition(p2)) t1;
select count(*) from ((partition_test_8429) partition(p2) t1);
select count(*) from ((partition_test_8429) t1 partition(p2) t2);
select count(*) from ((partition_test_8429) t1 partition(p2)) t2;
select count(*) from ((partition_test_8429)  partition(p2) t1) t2;
select count(*) from (partition_test_8429 partition(p2)  as join);
select count(*) from (partition_test_8429 partition(p2) join);
select count(*) from (partition_test_8429 partition(p2)  as limit);
select count(*) from (partition_test_8429 partition(p2)  as left);
select count(*) from (partition_test_8429 partition(p2)  as offset);
select count(*) from (partition_test_8429 partition(p2) offset);
select count(*) from (partition_test_8429 partition(p2)  as using);
select count(*) from (partition_test_8429 partition(p2)  as cross);
drop table if exists partition_test_8429;

drop table if exists test_drop_part;
create table test_drop_part(id int) partition by range(id)
(
partition p1 values less than(50)
);
alter table test_drop_part drop partition PART_NOT_EXISTS;
drop table if exists test_drop_part;

--DTS2019101500890
drop table if exists HIS_BUSINESSINFO;
create table HIS_BUSINESSINFO
(
  busi_seq             VARCHAR2(16) not null,
  rela_bsno            VARCHAR2(16),
  rela_busi_type       VARCHAR2(5),
  cust_id              NUMBER(24),
  sub_id               NUMBER(24),
  group_sub_id         NUMBER(24),
  acct_id              NUMBER(24),
  msisdn               VARCHAR2(64),
  iccid                VARCHAR2(20),
  imsi                 VARCHAR2(20),
  busi_type            VARCHAR2(5) not null,
  tele_type            VARCHAR2(8),
  busi_oper_id         VARCHAR2(20),
  busi_dept_id         VARCHAR2(20),
  busi_local_id        VARCHAR2(10),
  busi_date            DATE not null,
  busi_state           VARCHAR2(1) not null,
  reason_code          VARCHAR2(10),
  reason               VARCHAR2(100),
  busi_source          VARCHAR2(2) not null,
  busi_desc            VARCHAR2(512),
  remark               VARCHAR2(1024),
  partition_id         NUMBER(8) not null,
  rela_seq             VARCHAR2(32),
  be_id                VARCHAR2(32) default '101' not null,
  oper_be_id           VARCHAR2(32),
  transaction_id       VARCHAR2(32),
  order_id             VARCHAR2(16),
  external_order_id    VARCHAR2(32),
  external_sub_id      VARCHAR2(32),
  external_cust_id     VARCHAR2(32),
  external_acct_id     VARCHAR2(32),
  cust_code            VARCHAR2(64),
  acct_code            VARCHAR2(64),
  sub_code             VARCHAR2(64),
  is_cancel            VARCHAR2(1),
  status_date          DATE,
  complete_timestamp   TIMESTAMP,
  tech_channel_id      VARCHAR2(20),
  canceled_busi_seq    VARCHAR2(16),
  cancel_busi_seq      VARCHAR2(16),
  customer_order_id    VARCHAR2(16),
  prepaid_flag         VARCHAR2(1),
  is_display           VARCHAR2(8),
  file_name            VARCHAR2(256),
  isbatch              VARCHAR2(8),
  execute_type         NUMBER(1),
  reserve_execute_date DATE,
  contact_seq          VARCHAR2(30),
  alias_busi_type      VARCHAR2(5),
  cust_type            VARCHAR2(20),
  wait_im_paid         VARCHAR2(1),
  im_paid_flag         VARCHAR2(1),
  im_paid_date         DATE,
  contact_time         DATE,
  sort_num             NUMBER(2),
  trace_id             VARCHAR2(16),
  ponr_flag            VARCHAR2(1),
  modify_oper_id       VARCHAR2(20),
  modify_date          DATE,
  info1                VARCHAR2(128),
  info2                VARCHAR2(128),
  info3                VARCHAR2(128),
  info4                VARCHAR2(128),
  info5                VARCHAR2(128),
  info6                VARCHAR2(128),
  info7                VARCHAR2(128),
  info8                VARCHAR2(128),
  info9                VARCHAR2(128),
  info10               VARCHAR2(128),
  operate_type         VARCHAR2(16) default '0000000000000000',
  wish_date            DATE,
  shift_service_order  NUMBER(1),
  order_type           NUMBER(1) default 0 not null,
  accept_node          VARCHAR2(20)
)
partition by range (PARTITION_ID)
(
partition P201901 values less than (201901),
partition P201902 values less than (201902),
partition P201903 values less than (201903),
partition P201904 values less than (201904),
partition P201905 values less than (201905),
partition P201906 values less than (201906),
partition P201907 values less than (201907),
partition P201908 values less than (201908),
partition P201909 values less than (201909),
partition P201910 values less than (201910),
partition P201911 values less than (201911),
partition P201912 values less than (201912)
);

create index index_status_date on HIS_BUSINESSINFO(status_date) parallel 5;

create index index_complete_timestamp on HIS_BUSINESSINFO(complete_timestamp);

explain select * from HIS_BUSINESSINFO where status_date > sysdate - 100;

explain select * from HIS_BUSINESSINFO where status_date > current_date - 100;

explain select * from HIS_BUSINESSINFO where complete_timestamp > CURRENT_TIMESTAMP - 100;

explain select * from HIS_BUSINESSINFO where complete_timestamp > LOCALTIMESTAMP - 100;
delete from HIS_BUSINESSINFO;
drop table HIS_BUSINESSINFO;

DROP TABLE IF EXISTS TEST_EXPR_BOUNDVAL;
CREATE TABLE TEST_EXPR_BOUNDVAL(ID INT) PARTITION BY RANGE(ID)
(
PARTITION P1 VALUES LESS THAN(60 - 10),
PARTITION P2 VALUES LESS THAN(100)
);

DROP TABLE IF EXISTS TEST_EXPR_BOUNDVAL;
CREATE TABLE TEST_EXPR_BOUNDVAL(ID INT) PARTITION BY RANGE(ID)
(
PARTITION P1 VALUES LESS THAN(50),
PARTITION P2 VALUES LESS THAN(100)
);
ALTER TABLE TEST_EXPR_BOUNDVAL SPLIT PARTITION P2 AT(100 - 20) INTO (PARTITION P1, PARTITION P2);

--DongFangTong
drop table if exists DFT_KC24;
create table DFT_KC24
(
  AAZ208 NUMBER(16) not null,
  AAZ216 NUMBER(16),
  AAE036 DATE
)
partition by range (AAE036)
(
  partition PART2012 values less than   (TO_DATE(' 2013-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )),
  partition PART201301 values less than (TO_DATE(' 2013-02-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )),
  partition PART201302 values less than (TO_DATE(' 2013-03-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )),
  partition PART201303 values less than (TO_DATE(' 2013-04-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )),
  partition PART201304 values less than (TO_DATE(' 2013-05-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )),
  partition PART201305 values less than (TO_DATE(' 2013-06-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )),
  partition PART201306 values less than (TO_DATE(' 2013-07-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )),
  partition PART201307 values less than (TO_DATE(' 2013-08-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )),
  partition PART201308 values less than (TO_DATE(' 2013-09-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )),
  partition PART201309 values less than (TO_DATE(' 2013-10-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )),
  partition PART201310 values less than (TO_DATE(' 2013-11-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS' )),
  partition PARTOTHER values less than (MAXVALUE)
);
alter table DFT_KC24 add constraint PK_KC24 primary key (AAZ208);
explain select count(*) from DFT_KC24 where aae036>=TO_DATE(201302, 'yyyymm') AND aae036<=TO_DATE(201303, 'yyyymm');
explain select count(*) from DFT_KC24 where aae036>=TO_DATE(201302, 'yyyymm') AND aae036<=add_months(TO_DATE(201302, 'yyyymm'),1);
drop table DFT_KC24;

DROP TABLE IF EXISTS storage_no_part;
create table storage_no_part(id int);
alter table storage_no_part modify partition part_1 storage (maxsize 1G);
drop table storage_no_part;
--raw as part key
drop table if exists part_key_t1;
drop table if exists part_key_t2;
create table part_key_t1 ( i raw(100))partition by list(i) (partition part_key_t1_p1 values('11001100110011001100110011001100110011001111100011',''));
create table part_key_t2 ( i raw(100))partition by list(i) SUBPARTITION BY list(i) 
    (partition part_key_t2_p2 values('11001100110011001100110011001100110011001111100011','')
    (subpartition part_key_t2_sp2 values('11001100110011001100110011001100110011001111100011','')));
select * from part_key_t1  where i='11001100110011001100110011001100110011001111100011';
select * from part_key_t2  where i='11001100110011001100110011001100110011001111100011';

drop table if exists tbl_interval_csf;
create table tbl_interval_csf(col_int int AUTO_INCREMENT, col_integer integer,
col_BINARY_INTEGER BINARY_INTEGER,
col_smallint smallint not null default '7',
col_bigint bigint not null default '3',
col_real real,
col_double double comment 'double',
col_float float,
col_BINARY_DOUBLE BINARY_DOUBLE,
col_decimal decimal,
col_number1 number,
col_number2 number(20,2),
col_number3 number(20,-3),
col_number4 number(3,10),
col_number5 number(38,7),
col_numeric numeric,
col_char1 char(100),
col_char2 char(100),
col_text text,
col_binary1 binary(200),
col_varbinary1 varbinary(100),
col_raw1 raw(100),
col_bool bool,
col_boolean boolean,
col_interval1 INTERVAL YEAR TO MONTH,
col_interval2 INTERVAL DAY TO SECOND,
primary key(col_int)
)
partition by range(col_number1) interval (10)
(
partition p_interval_01 values less than (10) ,
partition p_interval_02 values less than (20) ,
partition p_interval_03 values less than (30)
);
insert into TBL_INTERVAL_CSF(col_int,col_number1,col_number2,col_number3,col_number4) values (14,12323131231231231231231.23123,1,12323131231231231231231.23123,0);

--support part csf format
drop table  if exists t_part_csf;
create table t_part_csf(id int, name varchar2(100)) PARTITION BY list(id) 
(
partition p1 values (1) format csf,
partition p2 values (2),
partition p3 values (3) format csf
); 
alter table t_part_csf add partition p6 values(4) format csf;
alter table t_part_csf add partition p7 values(5);

drop table  if exists t_part_csf;
create table t_part_csf(id int, name varchar2(100)) PARTITION BY range(id) 
(
partition p1 VALUES LESS THAN (1) format csf,
partition p2 VALUES LESS THAN (2),
partition p3 VALUES LESS THAN (3) format csf
); 
alter table t_part_csf add partition p6 VALUES LESS THAN(4) format csf;
alter table t_part_csf add partition p7 VALUES LESS THAN(5);

drop table  if exists t_part_csf;
create table t_part_csf(id int, name varchar2(100)) PARTITION BY range(id) interval(1)
(
partition p1 VALUES LESS THAN (1) format csf,
partition p2 VALUES LESS THAN (2),
partition p3 VALUES LESS THAN (3) format csf
);
alter table t_part_csf add partition p6 VALUES LESS THAN(4) format csf;
alter table t_part_csf add partition p7 VALUES LESS THAN(5);

drop table  if exists t_part_csf;
create table t_part_csf(id int, name varchar2(100)) PARTITION BY hash(id)
(
partition p1 format csf,
partition p2,
partition p3 format csf
);
alter table t_part_csf add partition p6 format csf;
alter table t_part_csf add partition p7;

drop table if exists t_part_csf;
create table t_part_csf(id int, name varchar2(100)) PARTITION BY range(id) 
(
partition p1 VALUES LESS THAN (10) format csf,
partition p2 VALUES LESS THAN (20),
partition p3 VALUES LESS THAN (30) format csf
); 
insert into t_part_csf values(1,'jack');
insert into t_part_csf values(2,'rose');
commit;
update t_part_csf set id=11;
alter table t_part_csf split partition p1 at(5) into (partition p4, partition p5);
alter table t_part_csf split partition p2 at(15) into (partition p6, partition p7);

drop table  if exists t_part_csf;
create table t_part_csf(id int, name varchar2(100)) PARTITION BY hash(id)
(
partition p1 format csf,
partition p2,
partition p3 format csf
);
alter table t_part_csf coalesce partition;
alter table t_part_csf coalesce partition;

drop table  if exists t_part_csf3;
create table t_part_csf3(id number, name varchar2(100)) PARTITION BY range(id) interval(10)
(
partition p1 VALUES LESS THAN (11),
partition p2 VALUES LESS THAN (21),
partition p3 VALUES LESS THAN (31)
) format csf;
insert into t_part_csf3 values(1, 'a');
update t_part_csf3 set id = 16000000 where id = 1;


drop table  if exists t_part_csf3;
create table t_part_csf3(id number, name varchar2(100)) PARTITION BY range(id) interval(10)
(
partition p1 VALUES LESS THAN (11) format csf,
partition p2 VALUES LESS THAN (21),
partition p3 VALUES LESS THAN (31)
);
insert into t_part_csf3 values(1, 'a');
update t_part_csf3 set id = 16000000 where id = 1;

drop table  if exists t_part_csf3;
create table t_part_csf3(id number, name varchar2(100)) PARTITION BY range(id) interval(10)
(
partition p1 VALUES LESS THAN (11) format csf,
partition p2 VALUES LESS THAN (21),
partition p3 VALUES LESS THAN (31)
);
insert into t_part_csf3 values(1, 'a');
alter table t_part_csf3 add add_column varchar2(20) default '11111';

drop table if exists t_part_csf3;
create table t_part_csf3(id int primary key auto_increment, c_clob clob) PARTITION BY range(id) interval(10)
(
partition p1 VALUES LESS THAN (500) format csf,
partition p2 VALUES LESS THAN (1000)
);
declare 
i integer;
begin
for i in 1 .. 1019 loop
insert into t_part_csf3(c_clob) values(lpad('a',5000,'a'));
end loop;
commit;
end;
/
delete from t_part_csf3 where mod(id,2)=0;
alter table t_part_csf3 modify lob (c_clob) (shrink space);


--DTS2020091807DK5HP1300
drop table if exists storage_lob_inline_tbl_000;
CREATE TABLE storage_lob_inline_tbl_000(C_ID INT not null,c_d_id DATE NOT NULL,C_W_ID int NOT NULL,C_FIRST1 VARCHAR(100) NOT NULL,C_FIRST2 VARCHAR(100) NOT NULL,C_FIRST3 VARCHAR(100) NOT NULL,C_FIRST4 VARCHAR(100) NOT NULL,C_FIRST5 VARCHAR(100) NOT NULL,C_FIRST6 VARCHAR(100) NOT NULL,C_FIRST7 VARCHAR(100) NOT NULL,C_FIRST8 VARCHAR(100) NOT NULL,C_DATA LONG,C_TEXT BLOB,C_CLOB CLOB);
insert into storage_lob_inline_tbl_000 values(0,'2018-01-01 10:51:47',0,'AA','BB','CC','DD','EE','FF','GG','HH','LONG','111','CLOB');
commit;
CREATE or replace procedure lob_inline_func_001(startall int,endall int) as
i INT;
BEGIN
 FOR i IN startall..endall LOOP
    insert into storage_lob_inline_tbl_000 select c_id+i*10,c_d_id+i*10,c_w_id+i*10,'AA'||i,'BB'||i,'CC'||i,'DD'||i,'EE'||i,'FF'||i,'GG'||i,'HH'||i,c_data,c_text,c_clob from storage_lob_inline_tbl_000 where c_id=0;commit;
 END LOOP;
END;
/
call lob_inline_func_001(2,100);

drop table if exists nebula_ddl_hash_001;
CREATE TABLE nebula_ddl_hash_001 (C_ID INT,C_D_ID DATE NOT NULL,C_W_ID int NOT NULL,C_FIRST1 varchar(7744) NOT NULL,C_FIRST2 varchar(7744) NOT NULL,C_FIRST3 varchar(7744) NOT NULL,C_FIRST4 varchar(7744) NOT NULL,C_FIRST5 varchar(7744) NOT NULL,C_FIRST6 varchar(7744) NOT NULL,C_FIRST7 varchar(7744) NOT NULL,C_FIRST8 varchar(7744) NOT NULL,C_DATA LONG,C_TEXT BLOB,C_CLOB CLOB) partition by hash(c_id,c_d_id) (partition part_1 storage(INITIAL 128K maxsize 5G) format csf,partition PART_2 format csf,partition part_3 format csf,partition part_4,partition part_5);
insert into nebula_ddl_hash_001 select C_ID,C_D_ID,C_W_ID,C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,C_DATA,C_TEXT,C_CLOB from storage_lob_inline_tbl_000 where mod(c_id,3)=0;
insert into nebula_ddl_hash_001 select C_ID,C_D_ID,C_W_ID,lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm'),C_DATA,C_TEXT,C_CLOB from storage_lob_inline_tbl_000 where mod(c_id,3)=1;
insert into nebula_ddl_hash_001 select C_ID,C_D_ID,C_W_ID,C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',4000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('123456656565767',4000,'565656576768787'),C_CLOB from storage_lob_inline_tbl_000 where mod(c_id,3)=2;
commit;

alter table nebula_ddl_hash_001 add partition add_part_001_001;
alter table nebula_ddl_hash_001 add partition add_part_001_2;
alter table nebula_ddl_hash_001 add add_column varchar(4000) default lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',2100,'yxcfgdsgtcsdsjxrbxxbm');
alter table nebula_ddl_hash_001 drop column add_column;

drop table if exists storage_lob_inline_tbl_000;
CREATE TABLE storage_lob_inline_tbl_000(C_ID INT not null,c_d_id DATE NOT NULL,C_W_ID int NOT NULL,C_FIRST1 VARCHAR(100) NOT NULL,C_FIRST2 VARCHAR(100) NOT NULL,C_FIRST3 VARCHAR(100) NOT NULL,C_FIRST4 VARCHAR(100) NOT NULL,C_FIRST5 VARCHAR(100) NOT NULL,C_FIRST6 VARCHAR(100) NOT NULL,C_FIRST7 VARCHAR(100) NOT NULL,C_FIRST8 VARCHAR(100) NOT NULL,C_DATA LONG,C_TEXT BLOB,C_CLOB CLOB);
create unique index STORAGE_LOB_INLINE_INDEX_000 on storage_lob_inline_tbl_000(c_id,c_d_id,c_w_id);
insert into storage_lob_inline_tbl_000 values(0,'2018-01-01 10:51:47',0,'AA','BB','CC','DD','EE','FF','GG','HH','LONG','111','CLOB');
commit;
CREATE or replace procedure lob_inline_func_001(startall int,endall int) as
i INT;
BEGIN
 FOR i IN startall..endall LOOP
    insert into storage_lob_inline_tbl_000 select c_id+i*10,c_d_id+i*10,c_w_id+i*10,'AA'||i,'BB'||i,'CC'||i,'DD'||i,'EE'||i,'FF'||i,'GG'||i,'HH'||i,c_data,c_text,c_clob from storage_lob_inline_tbl_000 where c_id=0;commit;
 END LOOP;
END;
/
call lob_inline_func_001(2,100);
select count(*) from storage_lob_inline_tbl_000;
commit;

drop table if exists nebula_ddl_hash_004;
CREATE TABLE nebula_ddl_hash_004 (C_ID INT,C_D_ID DATE NOT NULL,C_W_ID int NOT NULL,C_FIRST1 varchar(7744) NOT NULL,C_FIRST2 varchar(7744) NOT NULL,C_FIRST3 varchar(7744) NOT NULL,C_FIRST4 varchar(7744) NOT NULL,C_FIRST5 varchar(7744) NOT NULL,C_FIRST6 varchar(7744) NOT NULL,C_FIRST7 varchar(7744) NOT NULL,C_FIRST8 varchar(7744) NOT NULL,C_DATA LONG,C_TEXT BLOB,C_CLOB CLOB) partition by hash(c_id,c_d_id) (partition part_1 storage(INITIAL 128K maxsize 5G) format csf,partition PART_2 format csf,partition part_3 format csf,partition part_4,partition part_5,partition part_6,partition part_7 format csf,partition part_8 storage(INITIAL 128K maxsize 5G) format csf,partition PART_9,partition part_10);
insert into nebula_ddl_hash_004 select C_ID,C_D_ID,C_W_ID,C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,C_DATA,C_TEXT,C_CLOB from storage_lob_inline_tbl_000 where mod(c_id,3)=0;
insert into nebula_ddl_hash_004 select C_ID,C_D_ID,C_W_ID,lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm'),C_DATA,C_TEXT,C_CLOB from storage_lob_inline_tbl_000 where mod(c_id,3)=1;
insert into nebula_ddl_hash_004 select C_ID,C_D_ID,C_W_ID,C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',4000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('123456656565767',4000,'565656576768787'),C_CLOB from storage_lob_inline_tbl_000 where mod(c_id,3)=2;
commit;

delete from nebula_ddl_hash_004;rollback;
update nebula_ddl_hash_004 set c_data='aaaa',c_text='33333',c_clob='bbbbb';rollback;
update nebula_ddl_hash_004 set c_data='aaaa',c_text='33333',c_clob='bbbbb';commit;
savepoint aa;update nebula_ddl_hash_004 set c_data='aaaaa',c_text='33333',c_clob='bbbbb';rollback to savepoint aa;
update nebula_ddl_hash_004 set c_data=lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',1000,'yxcfgdsgtcsdsjxrbxxbm'),c_text=lpad('12323243',5000,'4354545'),c_clob=lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm');rollback;
update nebula_ddl_hash_004 set c_data=lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',1000,'yxcfgdsgtcsdsjxrbxxbm'),c_text=lpad('12323243',5000,'4354545'),c_clob=lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm');commit;
savepoint aa;update nebula_ddl_hash_004 set c_data=lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',1000,'yxcfgdsgtcsdsjxrbxxbm'),c_text=lpad('12323243',5000,'4354545'),c_clob=lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm');rollback to savepoint aa;
alter table nebula_ddl_hash_004 add partition add_part_004 tablespace nebula_tablespace;alter table nebula_ddl_hash_004 add partition add_part storage (maxsize 5G);
alter table nebula_ddl_hash_004 coalesce partition ;
alter table nebula_ddl_hash_004 add add_column varchar(7744) default lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm');
alter table nebula_ddl_hash_004 drop column add_column;
alter table nebula_ddl_hash_004 modify lob (c_clob) (shrink space);alter table nebula_ddl_hash_004 modify lob (c_text) (shrink space);alter table nebula_ddl_hash_004 modify lob (c_data) (shrink space);
alter system load dictionary for adm_tables;alter system load dictionary for adm_indexes;alter system load dictionary for adm_users;alter system load dictionary for adm_tab_columns;
alter table nebula_ddl_hash_004 storage (maxsize 5G);alter table nebula_ddl_hash_004 storage (maxsize 2G) format csf;


delete from nebula_ddl_hash_004;rollback;
update nebula_ddl_hash_004 set c_data='aaaa',c_text='33333',c_clob='bbbbb';rollback;
update nebula_ddl_hash_004 set c_data='aaaa',c_text='33333',c_clob='bbbbb';commit;
savepoint aa;update nebula_ddl_hash_004 set c_data='aaaaa',c_text='33333',c_clob='bbbbb';rollback to savepoint aa;
update nebula_ddl_hash_004 set c_data=lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',1000,'yxcfgdsgtcsdsjxrbxxbm'),c_text=lpad('12323243',5000,'4354545'),c_clob=lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm');rollback;
update nebula_ddl_hash_004 set c_data=lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',1000,'yxcfgdsgtcsdsjxrbxxbm'),c_text=lpad('12323243',5000,'4354545'),c_clob=lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm');commit;
savepoint aa;update nebula_ddl_hash_004 set c_data=lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',1000,'yxcfgdsgtcsdsjxrbxxbm'),c_text=lpad('12323243',5000,'4354545'),c_clob=lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm');rollback to savepoint aa;
alter table nebula_ddl_hash_004 add partition add_part_004 tablespace nebula_tablespace;alter table nebula_ddl_hash_004 add partition add_part storage (maxsize 5G);
alter table nebula_ddl_hash_004 coalesce partition ;
alter table nebula_ddl_hash_004 add add_column varchar(7744) default lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',7744,'yxcfgdsgtcsdsjxrbxxbm');
alter table nebula_ddl_hash_004 drop column add_column;
alter table nebula_ddl_hash_004 modify lob (c_clob) (shrink space);alter table nebula_ddl_hash_004 modify lob (c_text) (shrink space);alter table nebula_ddl_hash_004 modify lob (c_data) (shrink space);
alter system load dictionary for adm_tables;alter system load dictionary for adm_indexes;alter system load dictionary for adm_users;alter system load dictionary for adm_tab_columns;
alter table nebula_ddl_hash_004 storage (maxsize 5G);alter table nebula_ddl_hash_004 storage (maxsize 2G) format csf;

drop table if exists test_null_part_column;
create table test_null_part_column(id number) partition by hash(id)
(
partition p1
);

insert into test_null_part_column values(null);
insert into test_null_part_column values(null);
insert into test_null_part_column values(null);
insert into test_null_part_column values(null);
insert into test_null_part_column values(null);
commit;
alter table test_null_part_column add partition p2;
select count(*) from test_null_part_column partition(p1);
drop table if exists test_null_part_column;
--20201214
drop table if exists t_subpart_001;
create table t_subpart_001(c_d_id bigint NOT NULL) PARTITION BY RANGE(c_d_id) subpartition BY RANGE(c_d_id) (PARTITION P1 VALUES LESS THAN(10)(subpartition p11 VALUES LESS THAN(5),subpartition p12 VALUES LESS THAN(array[1])),PARTITION P2 VALUES LESS THAN(50) (subpartition p21 VALUES LESS THAN(30),subpartition p22 VALUES LESS THAN(MAXVALUE)));
create table t_subpart_001(c_d_id bigint NOT NULL) PARTITION BY RANGE(c_d_id)(PARTITION P1 VALUES LESS THAN(array[1]));
create table t_subpart_001(c_d_id bigint NOT NULL) PARTITION BY RANGE(c_d_id)(PARTITION P1 VALUES LESS THAN(1 1));
create table t_subpart_001(c_d_id bigint NOT NULL) PARTITION BY RANGE(c_d_id)(PARTITION P1 VALUES LESS THAN(array{1}));
create table t_subpart_001(c_d_id bigint NOT NULL) PARTITION BY RANGE(c_d_id)(PARTITION P1 VALUES LESS THAN(array);
create table t_subpart_001(c_d_id bigint NOT NULL) PARTITION BY list(c_d_id)(PARTITION P1 VALUES (array[1]));
--20210107
drop table if exists R_ANNC_SUBVOICELANMAP;
create table R_ANNC_SUBVOICELANMAP(f1 int, f2 int, f3 int, f4 int, f5 int, f6 int, f7 int, f8 int, f9 int, f10 int, f11 int, f12 int, f13 int, f14 int, f15 int, f16 int)
partition by hash(f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16) partitions 10;
insert into R_ANNC_SUBVOICELANMAP values(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
insert into R_ANNC_SUBVOICELANMAP values(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2);
select * from R_ANNC_SUBVOICELANMAP where f1 in (1,2,3,4,5) and f2 in (1,2,3,4,5) and f3 in (1,2,3,4,5) and f4 in (1,2,3,4,5) and f5 in (1,2,3,4,5) and f6 in (1,2,3,4,5) and f7 in (1,2,3,4,5) and f8 in (1,2,3,4,5) and f9 in (1,2,3,4,5) and f10 in (1,2,3,4,5) and f11 in (1,2,3,4,5) and f12 in (1,2,3,4,5) and f13 in (1,2,3,4,5) and f14 in (1,2,3,4,5) and f15 in (1,2,3,4,5) and f16 in (1,2,3,4,5);
select * from R_ANNC_SUBVOICELANMAP where f1 in (1,2,3,4) and f2 in (1,2,3,4) and f3 in (1,2,3,4) and f4 in (1,2,3,4) and f5 in (1,2,3,4) and f6 in (1,2,3,4) and f7 in (1,2,3,4) and f8 in (1,2,3,4) and f9 in (1,2,3,4) and f10 in (1,2,3,4) and f11 in (1,2,3,4) and f12 in (1,2,3,4) and f13 in (1,2,3,4) and f14 in (1,2,3,4) and f15 in (1,2,3,4) and f16 in (1,2,3,4);
drop table R_ANNC_SUBVOICELANMAP;

-- test partition table dynamic sample
DROP TABLE IF EXISTS F_TNN000012_LTECELL_H;
DROP TABLE IF EXISTS F_TNN000018_LTECELL_H;
alter system set cbo = on;
CREATE TABLE "F_TNN000012_LTECELL_H"
(
  "STARTTIME" DATE NOT NULL,
  "NEID" NUMBER(19) NOT NULL,
  "MONTH" NUMBER(3) NOT NULL,
  "DAY" NUMBER(3) NOT NULL,
  "HOUR" NUMBER(3) NOT NULL,
  "DSTOFFSET" NUMBER(5),
  "LTECELLID" NUMBER(19) NOT NULL,
  "PERIOD" NUMBER(10),
  "RESULTNO" NUMBER(10) NOT NULL,
  "DELETEFLAG" NUMBER(10),
  "SUBDELETEFLAG" NUMBER(10),
  "PREINTEGRITY" NUMBER(10),
  "INTEGRITY" NUMBER(10),
  "C1526726737" NUMBER(25, 5)
)
PARTITION BY RANGE ("STARTTIME")
(
    PARTITION DEFAULT_19000101 VALUES LESS THAN (to_date('19000101', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PRS_PART_20210105 VALUES LESS THAN (to_date('20210105', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PRS_PART_20210106 VALUES LESS THAN (to_date('20210106', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PRS_PART_20210107 VALUES LESS THAN (to_date('20210107', 'YYYYMMDD'))  INITRANS 2 PCTFREE 3 FORMAT CSF,
    PARTITION PRS_PART_20210108 VALUES LESS THAN (to_date('20210108', 'YYYYMMDD'))  INITRANS 2 PCTFREE 3 FORMAT CSF
)
INITRANS 2
MAXTRANS 255
PCTFREE 8
FORMAT CSF;
CREATE INDEX "III_TNN000012_LTECELL_H" ON "F_TNN000012_LTECELL_H"("RESULTNO")
LOCAL
INITRANS 2
PCTFREE 8;

CREATE INDEX "II_TNN000012_LTECELL_H" ON "F_TNN000012_LTECELL_H"("LTECELLID")
LOCAL
INITRANS 2
PCTFREE 8;
CREATE UNIQUE INDEX "I_TNN000012_LTECELL_H" ON "F_TNN000012_LTECELL_H"("STARTTIME", "HOUR", "LTECELLID", "DSTOFFSET")
LOCAL
INITRANS 2
PCTFREE 8;

CREATE INDEX "NE_TNN000012_LTECELL_H" ON "F_TNN000012_LTECELL_H"("NEID", "HOUR")
LOCAL
INITRANS 2
PCTFREE 8;

CREATE TABLE "F_TNN000018_LTECELL_H"
(
  "STARTTIME" DATE NOT NULL,
  "NEID" NUMBER(19) NOT NULL,
  "MONTH" NUMBER(3) NOT NULL,
  "DAY" NUMBER(3) NOT NULL,
  "HOUR" NUMBER(3) NOT NULL,
  "DSTOFFSET" NUMBER(5),
  "LTECELLID" NUMBER(19) NOT NULL,
  "PERIOD" NUMBER(10),
  "RESULTNO" NUMBER(10) NOT NULL,
  "DELETEFLAG" NUMBER(10),
  "SUBDELETEFLAG" NUMBER(10),
  "PREINTEGRITY" NUMBER(10),
  "INTEGRITY" NUMBER(10),
  "C1526730137" NUMBER(25, 5),
  "C1526730138" NUMBER(25, 5),
  "C1526728293" NUMBER(25, 5),
  "C1526728294" NUMBER(25, 5)
)
PARTITION BY RANGE ("STARTTIME")
(
    PARTITION DEFAULT_19000101 VALUES LESS THAN (to_date('19000101', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PRS_PART_20201231 VALUES LESS THAN (to_date('20201231', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PRS_PART_20210101 VALUES LESS THAN (to_date('20210101', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PRS_PART_20210102 VALUES LESS THAN (to_date('20210102', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PRS_PART_20210103 VALUES LESS THAN (to_date('20210103', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PRS_PART_20210104 VALUES LESS THAN (to_date('20210104', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PRS_PART_20210105 VALUES LESS THAN (to_date('20210105', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PRS_PART_20210106 VALUES LESS THAN (to_date('20210106', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PRS_PART_20210107 VALUES LESS THAN (to_date('20210107', 'YYYYMMDD'))  INITRANS 2 PCTFREE 3 FORMAT CSF,
    PARTITION PRS_PART_20210108 VALUES LESS THAN (to_date('20210108', 'YYYYMMDD'))  INITRANS 2 PCTFREE 3 FORMAT CSF
)
INITRANS 2
MAXTRANS 255
PCTFREE 8
FORMAT CSF;

CREATE INDEX "III_TNN000018_LTECELL_H" ON "F_TNN000018_LTECELL_H"("RESULTNO")
LOCAL
INITRANS 2
PCTFREE 8;
CREATE INDEX "II_TNN000018_LTECELL_H" ON "F_TNN000018_LTECELL_H"("LTECELLID")
LOCAL
INITRANS 2
PCTFREE 8;

CREATE UNIQUE INDEX "I_TNN000018_LTECELL_H" ON "F_TNN000018_LTECELL_H"("STARTTIME", "HOUR", "LTECELLID", "DSTOFFSET")
LOCAL
INITRANS 2
PCTFREE 8;

CREATE INDEX "NE_TNN000018_LTECELL_H" ON "F_TNN000018_LTECELL_H"("NEID", "HOUR")
LOCAL
INITRANS 2
PCTFREE 8;

insert into F_TNN000018_LTECELL_H values
('2021-01-04 00:00:00', 9, 1, 4, 23, 0, 300000001539, 60, 1048, 0, 0, 60, 60, 19, 55, 50, 54 ),
('2021-01-04 00:00:00', 9, 1, 4, 23, 0, 300000001537, 60, 1048, 0, 0, 60, 60, 27, 0,  52, 57 ),
('2021-01-04 00:00:00', 9, 1, 4, 23, 0, 300000001538, 60, 1048, 0, 0, 60, 60, 43, 63, 75, 16 ),
('2021-01-04 00:00:00', 9, 1, 4, 23, 0, 300000001534, 60, 1048, 0, 0, 60, 60, 5,  25, 13, 64 ),
('2021-01-04 00:00:00', 9, 1, 4, 23, 0, 300000001535, 60, 1048, 0, 0, 60, 60, 88, 27, 9,  75 ),
('2021-01-04 00:00:00', 9, 1, 4, 22, 0, 300000001539, 60, 1049, 0, 0, 60, 60, 37, 21, 39, 71 ),
('2021-01-04 00:00:00', 9, 1, 4, 22, 0, 300000001537, 60, 1049, 0, 0, 60, 60, 90, 100, 61, 59),
('2021-01-04 00:00:00', 9, 1, 4, 22, 0, 300000001538, 60, 1049, 0, 0, 60, 60, 5,  71, 66, 81 ),
('2021-01-04 00:00:00', 9, 1, 4, 22, 0, 300000001534, 60, 1049, 0, 0, 60, 60, 36, 55, 82, 29 ),
('2021-01-04 00:00:00', 9, 1, 4, 22, 0, 300000001535, 60, 1049, 0, 0, 60, 60, 96, 24, 36, 48 ),
('2021-01-04 00:00:00', 9, 1, 4, 21, 0, 300000001539, 60, 1050, 0, 0, 60, 60, 81, 66, 41, 26 ),
('2021-01-04 00:00:00', 9, 1, 4, 21, 0, 300000001537, 60, 1050, 0, 0, 60, 60, 78, 1,  72, 15 ),
('2021-01-04 00:00:00', 9, 1, 4, 21, 0, 300000001538, 60, 1050, 0, 0, 60, 60, 13, 29, 90, 41 ),
('2021-01-04 00:00:00', 9, 1, 4, 21, 0, 300000001534, 60, 1050, 0, 0, 60, 60, 11, 86, 28, 43 ),
('2021-01-04 00:00:00', 9, 1, 4, 21, 0, 300000001535, 60, 1050, 0, 0, 60, 60, 8,  95, 98, 8  ),
('2021-01-04 00:00:00', 9, 1, 4, 20, 0, 300000001539, 60, 1051, 0, 0, 60, 60, 83, 93, 26, 27 ),
('2021-01-04 00:00:00', 9, 1, 4, 20, 0, 300000001537, 60, 1051, 0, 0, 60, 60, 80, 83, 75, 47 ),
('2021-01-04 00:00:00', 9, 1, 4, 20, 0, 300000001538, 60, 1051, 0, 0, 60, 60, 9,  93, 75, 72 ),
('2021-01-04 00:00:00', 9, 1, 4, 20, 0, 300000001534, 60, 1051, 0, 0, 60, 60, 63, 96, 58, 54 ),
('2021-01-04 00:00:00', 9, 1, 4, 20, 0, 300000001535, 60, 1051, 0, 0, 60, 60, 99, 86, 88, 16 ),
('2021-01-04 00:00:00', 9, 1, 4, 19, 0, 300000001539, 60, 1052, 0, 0, 60, 60, 41, 25, 98, 12 ),
('2021-01-04 00:00:00', 9, 1, 4, 19, 0, 300000001537, 60, 1052, 0, 0, 60, 60, 57, 57, 82, 86 ),
('2021-01-04 00:00:00', 9, 1, 4, 19, 0, 300000001538, 60, 1052, 0, 0, 60, 60, 93, 80, 73, 23 ),
('2021-01-04 00:00:00', 9, 1, 4, 19, 0, 300000001534, 60, 1052, 0, 0, 60, 60, 56, 29, 43, 29 ),
('2021-01-04 00:00:00', 9, 1, 4, 19, 0, 300000001535, 60, 1052, 0, 0, 60, 60, 11, 41, 5,  80 ),
('2021-01-04 00:00:00', 9, 1, 4, 18, 0, 300000001539, 60, 1053, 0, 0, 60, 60, 48, 64, 42, 33 ),
('2021-01-04 00:00:00', 9, 1, 4, 18, 0, 300000001537, 60, 1053, 0, 0, 60, 60, 96, 80, 43, 65 ),
('2021-01-04 00:00:00', 9, 1, 4, 18, 0, 300000001538, 60, 1053, 0, 0, 60, 60, 81, 85, 86, 41 ),
('2021-01-04 00:00:00', 9, 1, 4, 18, 0, 300000001534, 60, 1053, 0, 0, 60, 60, 28, 76, 36, 81 ),
('2021-01-04 00:00:00', 9, 1, 4, 18, 0, 300000001535, 60, 1053, 0, 0, 60, 60, 8,  67, 87, 25 ),
('2021-01-04 00:00:00', 9, 1, 4, 17, 0, 300000001539, 60, 1054, 0, 0, 60, 60, 63, 87, 40, 74 ),
('2021-01-04 00:00:00', 9, 1, 4, 17, 0, 300000001537, 60, 1054, 0, 0, 60, 60, 74, 60, 53, 86 ),
('2021-01-04 00:00:00', 9, 1, 4, 17, 0, 300000001538, 60, 1054, 0, 0, 60, 60, 32, 3,  50, 51 ),
('2021-01-04 00:00:00', 9, 1, 4, 17, 0, 300000001534, 60, 1054, 0, 0, 60, 60, 10, 62, 7,  35 ),
('2021-01-04 00:00:00', 9, 1, 4, 17, 0, 300000001535, 60, 1054, 0, 0, 60, 60, 41, 74, 63, 76 ),
('2021-01-04 00:00:00', 9, 1, 4, 16, 0, 300000001539, 60, 1055, 0, 0, 60, 60, 27, 46, 91, 48 ),
('2021-01-04 00:00:00', 9, 1, 4, 16, 0, 300000001537, 60, 1055, 0, 0, 60, 60, 52, 69, 6,  47 ),
('2021-01-04 00:00:00', 9, 1, 4, 16, 0, 300000001538, 60, 1055, 0, 0, 60, 60, 1,  34, 24, 88 ),
('2021-01-04 00:00:00', 9, 1, 4, 16, 0, 300000001534, 60, 1055, 0, 0, 60, 60, 78, 21, 41, 33 ),
('2021-01-04 00:00:00', 9, 1, 4, 16, 0, 300000001535, 60, 1055, 0, 0, 60, 60, 24, 12, 11, 36 ),
('2021-01-04 00:00:00', 9, 1, 4, 15, 0, 300000001539, 60, 1056, 0, 0, 60, 60, 1,  8,  93, 61 ),
('2021-01-04 00:00:00', 9, 1, 4, 15, 0, 300000001537, 60, 1056, 0, 0, 60, 60, 5,  74, 42, 5  ),
('2021-01-04 00:00:00', 9, 1, 4, 15, 0, 300000001538, 60, 1056, 0, 0, 60, 60, 71, 78, 99, 51 ),
('2021-01-04 00:00:00', 9, 1, 4, 15, 0, 300000001534, 60, 1056, 0, 0, 60, 60, 54, 96, 25, 43 ),
('2021-01-04 00:00:00', 9, 1, 4, 15, 0, 300000001535, 60, 1056, 0, 0, 60, 60, 69, 35, 34, 50 ),
('2021-01-04 00:00:00', 9, 1, 4, 14, 0, 300000001539, 60, 1057, 0, 0, 60, 60, 87, 17, 2,  89 ),
('2021-01-04 00:00:00', 9, 1, 4, 14, 0, 300000001537, 60, 1057, 0, 0, 60, 60, 75, 53, 31, 100),
('2021-01-04 00:00:00', 9, 1, 4, 14, 0, 300000001538, 60, 1057, 0, 0, 60, 60, 68, 40, 81, 24 ),
('2021-01-04 00:00:00', 9, 1, 4, 14, 0, 300000001534, 60, 1057, 0, 0, 60, 60, 17, 78, 57, 35 ),
('2021-01-04 00:00:00', 9, 1, 4, 14, 0, 300000001535, 60, 1057, 0, 0, 60, 60, 51, 8,  42, 25 ),
('2021-01-04 00:00:00', 9, 1, 4, 13, 0, 300000001539, 60, 1058, 0, 0, 60, 60, 25, 61, 42, 31 ),
('2021-01-04 00:00:00', 9, 1, 4, 13, 0, 300000001537, 60, 1058, 0, 0, 60, 60, 4,  51, 6,  100),
('2021-01-04 00:00:00', 9, 1, 4, 13, 0, 300000001538, 60, 1058, 0, 0, 60, 60, 38, 39, 75, 53 ),
('2021-01-04 00:00:00', 9, 1, 4, 13, 0, 300000001534, 60, 1058, 0, 0, 60, 60, 69, 22, 65, 31 ),
('2021-01-04 00:00:00', 9, 1, 4, 13, 0, 300000001535, 60, 1058, 0, 0, 60, 60, 6,  87, 91, 59 ),
('2021-01-04 00:00:00', 9, 1, 4, 12, 0, 300000001539, 60, 1059, 0, 0, 60, 60, 44, 34, 34, 28 ),
('2021-01-04 00:00:00', 9, 1, 4, 12, 0, 300000001537, 60, 1059, 0, 0, 60, 60, 88, 8,  62, 52 ),
('2021-01-04 00:00:00', 9, 1, 4, 12, 0, 300000001538, 60, 1059, 0, 0, 60, 60, 46, 53, 52, 33 ),
('2021-01-04 00:00:00', 9, 1, 4, 12, 0, 300000001534, 60, 1059, 0, 0, 60, 60, 25, 3,  20, 78 ),
('2021-01-04 00:00:00', 9, 1, 4, 12, 0, 300000001535, 60, 1059, 0, 0, 60, 60, 68, 68, 85, 62 ),
('2021-01-04 00:00:00', 9, 1, 4, 11, 0, 300000001539, 60, 1060, 0, 0, 60, 60, 92, 68, 94, 88 ),
('2021-01-04 00:00:00', 9, 1, 4, 11, 0, 300000001537, 60, 1060, 0, 0, 60, 60, 8,  89, 23, 42 ),
('2021-01-04 00:00:00', 9, 1, 4, 11, 0, 300000001538, 60, 1060, 0, 0, 60, 60, 23, 89, 82, 97 ),
('2021-01-04 00:00:00', 9, 1, 4, 11, 0, 300000001534, 60, 1060, 0, 0, 60, 60, 70, 17, 56, 15 ),
('2021-01-04 00:00:00', 9, 1, 4, 11, 0, 300000001535, 60, 1060, 0, 0, 60, 60, 32, 11, 11, 69 ),
('2021-01-04 00:00:00', 9, 1, 4, 10, 0, 300000001539, 60, 1061, 0, 0, 60, 60, 15, 13, 92, 38 ),
('2021-01-04 00:00:00', 9, 1, 4, 10, 0, 300000001537, 60, 1061, 0, 0, 60, 60, 81, 49, 7,  7  ),
('2021-01-04 00:00:00', 9, 1, 4, 10, 0, 300000001538, 60, 1061, 0, 0, 60, 60, 50, 86, 41, 37 ),
('2021-01-04 00:00:00', 9, 1, 4, 10, 0, 300000001534, 60, 1061, 0, 0, 60, 60, 8,  35, 7,  9  ),
('2021-01-04 00:00:00', 9, 1, 4, 10, 0, 300000001535, 60, 1061, 0, 0, 60, 60, 31, 28, 77, 65 ),
('2021-01-04 00:00:00', 9, 1, 4, 9 , 0, 300000001539, 60, 1062, 0, 0, 60, 60, 43, 35, 88, 14 ),
('2021-01-04 00:00:00', 9, 1, 4, 9 , 0, 300000001537, 60, 1062, 0, 0, 60, 60, 13, 6,  14, 8  ),
('2021-01-04 00:00:00', 9, 1, 4, 9 , 0, 300000001538, 60, 1062, 0, 0, 60, 60, 30, 60, 62, 23 ),
('2021-01-04 00:00:00', 9, 1, 4, 9 , 0, 300000001534, 60, 1062, 0, 0, 60, 60, 82, 98, 86, 100),
('2021-01-04 00:00:00', 9, 1, 4, 9 , 0, 300000001535, 60, 1062, 0, 0, 60, 60, 67, 36, 67, 13 );

commit;

select ObjId, NeId, DSTOffset, Hour, (avg(Period)) Period, (max(Period_cond)) Period_cond, StartTime, (sum(Integrity)) Integrity, (sum(PreIntegrity)) PreIntegrity, (sum(C1526726737)) C1526726737, (sum(C1526730138)) C1526730138 from (
select  (T0.LTECellId) ObjId, (T0.NeId) NeId, StartTime, T0.Hour, T0.DSTOffset, T0.Period, 0 Period_cond, Integrity, PreIntegrity,C1526726737,null C1526730138, 1 RecordNum from f_TNN000012_LTECell_H T0 where  ((T0.LTECellId=300000147130)) and ( (T0.StartTime >  TO_DATE('2021/01/01','YYYY/MM/DD') or  (T0.StartTime =  TO_DATE('2021/01/01','YYYY/MM/DD') and T0.Hour >= 0)) and  (T0.StartTime <  TO_DATE('2021/01/05','YYYY/MM/DD') or  (T0.StartTime =  TO_DATE('2021/01/05','YYYY/MM/DD') and T0.Hour < 4)))
 union all select  (T0.LTECellId) ObjId, (T0.NeId) NeId, StartTime, T0.Hour, T0.DSTOffset, T0.Period, 0 Period_cond, Integrity, PreIntegrity,null C1526726737,C1526730138, 1 RecordNum from f_TNN000018_LTECell_H T0 where  ((T0.LTECellId=300000147130)) and ( (T0.StartTime >  TO_DATE('2021/01/01','YYYY/MM/DD') or  (T0.StartTime =  TO_DATE('2021/01/01','YYYY/MM/DD') and T0.Hour >= 0)) and  (T0.StartTime <  TO_DATE('2021/01/05','YYYY/MM/DD') or  (T0.StartTime =  TO_DATE('2021/01/05','YYYY/MM/DD') 
 and T0.Hour < 4))))group by NeId,ObjId, StartTime,Hour  ,DSTOffset;

-- re-create the partitions
alter table F_TNN000018_LTECELL_H drop PARTITION PRS_PART_20201231;
alter table F_TNN000018_LTECELL_H drop PARTITION PRS_PART_20210101;
alter table F_TNN000018_LTECELL_H drop PARTITION PRS_PART_20210102;
alter table F_TNN000018_LTECELL_H drop PARTITION PRS_PART_20210103;
alter table F_TNN000018_LTECELL_H drop PARTITION PRS_PART_20210104;
alter table F_TNN000018_LTECELL_H drop PARTITION PRS_PART_20210105;
alter table F_TNN000018_LTECELL_H drop PARTITION PRS_PART_20210106;
alter table F_TNN000018_LTECELL_H drop PARTITION PRS_PART_20210107;
alter table F_TNN000018_LTECELL_H drop PARTITION PRS_PART_20210108;

alter table F_TNN000018_LTECELL_H add PARTITION PRS_PART_20201231 VALUES LESS THAN (to_date('20201231', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF;
alter table F_TNN000018_LTECELL_H add PARTITION PRS_PART_20210101 VALUES LESS THAN (to_date('20210101', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF;
alter table F_TNN000018_LTECELL_H add PARTITION PRS_PART_20210102 VALUES LESS THAN (to_date('20210102', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF;
alter table F_TNN000018_LTECELL_H add PARTITION PRS_PART_20210103 VALUES LESS THAN (to_date('20210103', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF;
alter table F_TNN000018_LTECELL_H add PARTITION PRS_PART_20210104 VALUES LESS THAN (to_date('20210104', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF;
alter table F_TNN000018_LTECELL_H add PARTITION PRS_PART_20210105 VALUES LESS THAN (to_date('20210105', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF;
alter table F_TNN000018_LTECELL_H add PARTITION PRS_PART_20210106 VALUES LESS THAN (to_date('20210106', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF;
alter table F_TNN000018_LTECELL_H add PARTITION PRS_PART_20210107 VALUES LESS THAN (to_date('20210107', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF;
alter table F_TNN000018_LTECELL_H add PARTITION PRS_PART_20210108 VALUES LESS THAN (to_date('20210108', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8 FORMAT CSF;

-- add data for the last selected partitions
insert into F_TNN000018_LTECELL_H values
('2021-01-04 00:00:00', 9, 1, 4, 23, 0, 300000001539, 60, 1048, 0, 0, 60, 60, 19, 55, 50, 54 ),
('2021-01-04 00:00:00', 9, 1, 4, 23, 0, 300000001537, 60, 1048, 0, 0, 60, 60, 27, 0,  52, 57 ),
('2021-01-04 00:00:00', 9, 1, 4, 23, 0, 300000001538, 60, 1048, 0, 0, 60, 60, 43, 63, 75, 16 ),
('2021-01-04 00:00:00', 9, 1, 4, 23, 0, 300000001534, 60, 1048, 0, 0, 60, 60, 5,  25, 13, 64 ),
('2021-01-04 00:00:00', 9, 1, 4, 23, 0, 300000001535, 60, 1048, 0, 0, 60, 60, 88, 27, 9,  75 ),
('2021-01-04 00:00:00', 9, 1, 4, 22, 0, 300000001539, 60, 1049, 0, 0, 60, 60, 37, 21, 39, 71 ),
('2021-01-04 00:00:00', 9, 1, 4, 22, 0, 300000001537, 60, 1049, 0, 0, 60, 60, 90, 100, 61, 59),
('2021-01-04 00:00:00', 9, 1, 4, 22, 0, 300000001538, 60, 1049, 0, 0, 60, 60, 5,  71, 66, 81 ),
('2021-01-04 00:00:00', 9, 1, 4, 22, 0, 300000001534, 60, 1049, 0, 0, 60, 60, 36, 55, 82, 29 ),
('2021-01-04 00:00:00', 9, 1, 4, 22, 0, 300000001535, 60, 1049, 0, 0, 60, 60, 96, 24, 36, 48 ),
('2021-01-04 00:00:00', 9, 1, 4, 21, 0, 300000001539, 60, 1050, 0, 0, 60, 60, 81, 66, 41, 26 ),
('2021-01-04 00:00:00', 9, 1, 4, 21, 0, 300000001537, 60, 1050, 0, 0, 60, 60, 78, 1,  72, 15 ),
('2021-01-04 00:00:00', 9, 1, 4, 21, 0, 300000001538, 60, 1050, 0, 0, 60, 60, 13, 29, 90, 41 ),
('2021-01-04 00:00:00', 9, 1, 4, 21, 0, 300000001534, 60, 1050, 0, 0, 60, 60, 11, 86, 28, 43 ),
('2021-01-04 00:00:00', 9, 1, 4, 21, 0, 300000001535, 60, 1050, 0, 0, 60, 60, 8,  95, 98, 8  ),
('2021-01-04 00:00:00', 9, 1, 4, 20, 0, 300000001539, 60, 1051, 0, 0, 60, 60, 83, 93, 26, 27 ),
('2021-01-04 00:00:00', 9, 1, 4, 20, 0, 300000001537, 60, 1051, 0, 0, 60, 60, 80, 83, 75, 47 ),
('2021-01-04 00:00:00', 9, 1, 4, 20, 0, 300000001538, 60, 1051, 0, 0, 60, 60, 9,  93, 75, 72 ),
('2021-01-04 00:00:00', 9, 1, 4, 20, 0, 300000001534, 60, 1051, 0, 0, 60, 60, 63, 96, 58, 54 ),
('2021-01-04 00:00:00', 9, 1, 4, 20, 0, 300000001535, 60, 1051, 0, 0, 60, 60, 99, 86, 88, 16 ),
('2021-01-04 00:00:00', 9, 1, 4, 19, 0, 300000001539, 60, 1052, 0, 0, 60, 60, 41, 25, 98, 12 ),
('2021-01-04 00:00:00', 9, 1, 4, 19, 0, 300000001537, 60, 1052, 0, 0, 60, 60, 57, 57, 82, 86 ),
('2021-01-04 00:00:00', 9, 1, 4, 19, 0, 300000001538, 60, 1052, 0, 0, 60, 60, 93, 80, 73, 23 ),
('2021-01-04 00:00:00', 9, 1, 4, 19, 0, 300000001534, 60, 1052, 0, 0, 60, 60, 56, 29, 43, 29 ),
('2021-01-04 00:00:00', 9, 1, 4, 19, 0, 300000001535, 60, 1052, 0, 0, 60, 60, 11, 41, 5,  80 ),
('2021-01-04 00:00:00', 9, 1, 4, 18, 0, 300000001539, 60, 1053, 0, 0, 60, 60, 48, 64, 42, 33 ),
('2021-01-04 00:00:00', 9, 1, 4, 18, 0, 300000001537, 60, 1053, 0, 0, 60, 60, 96, 80, 43, 65 ),
('2021-01-04 00:00:00', 9, 1, 4, 18, 0, 300000001538, 60, 1053, 0, 0, 60, 60, 81, 85, 86, 41 ),
('2021-01-04 00:00:00', 9, 1, 4, 18, 0, 300000001534, 60, 1053, 0, 0, 60, 60, 28, 76, 36, 81 ),
('2021-01-04 00:00:00', 9, 1, 4, 18, 0, 300000001535, 60, 1053, 0, 0, 60, 60, 8,  67, 87, 25 ),
('2021-01-04 00:00:00', 9, 1, 4, 17, 0, 300000001539, 60, 1054, 0, 0, 60, 60, 63, 87, 40, 74 ),
('2021-01-04 00:00:00', 9, 1, 4, 17, 0, 300000001537, 60, 1054, 0, 0, 60, 60, 74, 60, 53, 86 ),
('2021-01-04 00:00:00', 9, 1, 4, 17, 0, 300000001538, 60, 1054, 0, 0, 60, 60, 32, 3,  50, 51 ),
('2021-01-04 00:00:00', 9, 1, 4, 17, 0, 300000001534, 60, 1054, 0, 0, 60, 60, 10, 62, 7,  35 ),
('2021-01-04 00:00:00', 9, 1, 4, 17, 0, 300000001535, 60, 1054, 0, 0, 60, 60, 41, 74, 63, 76 ),
('2021-01-04 00:00:00', 9, 1, 4, 16, 0, 300000001539, 60, 1055, 0, 0, 60, 60, 27, 46, 91, 48 ),
('2021-01-04 00:00:00', 9, 1, 4, 16, 0, 300000001537, 60, 1055, 0, 0, 60, 60, 52, 69, 6,  47 ),
('2021-01-04 00:00:00', 9, 1, 4, 16, 0, 300000001538, 60, 1055, 0, 0, 60, 60, 1,  34, 24, 88 ),
('2021-01-04 00:00:00', 9, 1, 4, 16, 0, 300000001534, 60, 1055, 0, 0, 60, 60, 78, 21, 41, 33 ),
('2021-01-04 00:00:00', 9, 1, 4, 16, 0, 300000001535, 60, 1055, 0, 0, 60, 60, 24, 12, 11, 36 ),
('2021-01-04 00:00:00', 9, 1, 4, 15, 0, 300000001539, 60, 1056, 0, 0, 60, 60, 1,  8,  93, 61 ),
('2021-01-04 00:00:00', 9, 1, 4, 15, 0, 300000001537, 60, 1056, 0, 0, 60, 60, 5,  74, 42, 5  ),
('2021-01-04 00:00:00', 9, 1, 4, 15, 0, 300000001538, 60, 1056, 0, 0, 60, 60, 71, 78, 99, 51 ),
('2021-01-04 00:00:00', 9, 1, 4, 15, 0, 300000001534, 60, 1056, 0, 0, 60, 60, 54, 96, 25, 43 ),
('2021-01-04 00:00:00', 9, 1, 4, 15, 0, 300000001535, 60, 1056, 0, 0, 60, 60, 69, 35, 34, 50 ),
('2021-01-04 00:00:00', 9, 1, 4, 14, 0, 300000001539, 60, 1057, 0, 0, 60, 60, 87, 17, 2,  89 ),
('2021-01-04 00:00:00', 9, 1, 4, 14, 0, 300000001537, 60, 1057, 0, 0, 60, 60, 75, 53, 31, 100),
('2021-01-04 00:00:00', 9, 1, 4, 14, 0, 300000001538, 60, 1057, 0, 0, 60, 60, 68, 40, 81, 24 ),
('2021-01-04 00:00:00', 9, 1, 4, 14, 0, 300000001534, 60, 1057, 0, 0, 60, 60, 17, 78, 57, 35 ),
('2021-01-04 00:00:00', 9, 1, 4, 14, 0, 300000001535, 60, 1057, 0, 0, 60, 60, 51, 8,  42, 25 ),
('2021-01-04 00:00:00', 9, 1, 4, 13, 0, 300000001539, 60, 1058, 0, 0, 60, 60, 25, 61, 42, 31 ),
('2021-01-04 00:00:00', 9, 1, 4, 13, 0, 300000001537, 60, 1058, 0, 0, 60, 60, 4,  51, 6,  100),
('2021-01-04 00:00:00', 9, 1, 4, 13, 0, 300000001538, 60, 1058, 0, 0, 60, 60, 38, 39, 75, 53 ),
('2021-01-04 00:00:00', 9, 1, 4, 13, 0, 300000001534, 60, 1058, 0, 0, 60, 60, 69, 22, 65, 31 ),
('2021-01-04 00:00:00', 9, 1, 4, 13, 0, 300000001535, 60, 1058, 0, 0, 60, 60, 6,  87, 91, 59 ),
('2021-01-04 00:00:00', 9, 1, 4, 12, 0, 300000001539, 60, 1059, 0, 0, 60, 60, 44, 34, 34, 28 ),
('2021-01-04 00:00:00', 9, 1, 4, 12, 0, 300000001537, 60, 1059, 0, 0, 60, 60, 88, 8,  62, 52 ),
('2021-01-04 00:00:00', 9, 1, 4, 12, 0, 300000001538, 60, 1059, 0, 0, 60, 60, 46, 53, 52, 33 ),
('2021-01-04 00:00:00', 9, 1, 4, 12, 0, 300000001534, 60, 1059, 0, 0, 60, 60, 25, 3,  20, 78 ),
('2021-01-04 00:00:00', 9, 1, 4, 12, 0, 300000001535, 60, 1059, 0, 0, 60, 60, 68, 68, 85, 62 ),
('2021-01-04 00:00:00', 9, 1, 4, 11, 0, 300000001539, 60, 1060, 0, 0, 60, 60, 92, 68, 94, 88 ),
('2021-01-04 00:00:00', 9, 1, 4, 11, 0, 300000001537, 60, 1060, 0, 0, 60, 60, 8,  89, 23, 42 ),
('2021-01-04 00:00:00', 9, 1, 4, 11, 0, 300000001538, 60, 1060, 0, 0, 60, 60, 23, 89, 82, 97 ),
('2021-01-04 00:00:00', 9, 1, 4, 11, 0, 300000001534, 60, 1060, 0, 0, 60, 60, 70, 17, 56, 15 ),
('2021-01-04 00:00:00', 9, 1, 4, 11, 0, 300000001535, 60, 1060, 0, 0, 60, 60, 32, 11, 11, 69 ),
('2021-01-04 00:00:00', 9, 1, 4, 10, 0, 300000001539, 60, 1061, 0, 0, 60, 60, 15, 13, 92, 38 ),
('2021-01-04 00:00:00', 9, 1, 4, 10, 0, 300000001537, 60, 1061, 0, 0, 60, 60, 81, 49, 7,  7  ),
('2021-01-04 00:00:00', 9, 1, 4, 10, 0, 300000001538, 60, 1061, 0, 0, 60, 60, 50, 86, 41, 37 ),
('2021-01-04 00:00:00', 9, 1, 4, 10, 0, 300000001534, 60, 1061, 0, 0, 60, 60, 8,  35, 7,  9  ),
('2021-01-04 00:00:00', 9, 1, 4, 10, 0, 300000001535, 60, 1061, 0, 0, 60, 60, 31, 28, 77, 65 ),
('2021-01-04 00:00:00', 9, 1, 4, 9 , 0, 300000001539, 60, 1062, 0, 0, 60, 60, 43, 35, 88, 14 ),
('2021-01-04 00:00:00', 9, 1, 4, 9 , 0, 300000001537, 60, 1062, 0, 0, 60, 60, 13, 6,  14, 8  ),
('2021-01-04 00:00:00', 9, 1, 4, 9 , 0, 300000001538, 60, 1062, 0, 0, 60, 60, 30, 60, 62, 23 ),
('2021-01-04 00:00:00', 9, 1, 4, 9 , 0, 300000001534, 60, 1062, 0, 0, 60, 60, 82, 98, 86, 100),
('2021-01-04 00:00:00', 9, 1, 4, 9 , 0, 300000001535, 60, 1062, 0, 0, 60, 60, 67, 36, 67, 13 );

commit;

select ObjId, NeId, DSTOffset, Hour, (avg(Period)) Period, (max(Period_cond)) Period_cond, StartTime, (sum(Integrity)) Integrity, (sum(PreIntegrity)) PreIntegrity, (sum(C1526726737)) C1526726737, (sum(C1526730138)) C1526730138 from (
select  (T0.LTECellId) ObjId, (T0.NeId) NeId, StartTime, T0.Hour, T0.DSTOffset, T0.Period, 0 Period_cond, Integrity, PreIntegrity,C1526726737,null C1526730138, 1 RecordNum from f_TNN000012_LTECell_H T0 where  ((T0.LTECellId=300000147130)) and ( (T0.StartTime >  TO_DATE('2021/01/01','YYYY/MM/DD') or  (T0.StartTime =  TO_DATE('2021/01/01','YYYY/MM/DD') and T0.Hour >= 0)) and  (T0.StartTime <  TO_DATE('2021/01/05','YYYY/MM/DD') or  (T0.StartTime =  TO_DATE('2021/01/05','YYYY/MM/DD') and T0.Hour < 4)))
 union all select  (T0.LTECellId) ObjId, (T0.NeId) NeId, StartTime, T0.Hour, T0.DSTOffset, T0.Period, 0 Period_cond, Integrity, PreIntegrity,null C1526726737,C1526730138, 1 RecordNum from f_TNN000018_LTECell_H T0 where  ((T0.LTECellId=300000147130)) and ( (T0.StartTime >  TO_DATE('2021/01/01','YYYY/MM/DD') or  (T0.StartTime =  TO_DATE('2021/01/01','YYYY/MM/DD') and T0.Hour >= 0)) and  (T0.StartTime <  TO_DATE('2021/01/05','YYYY/MM/DD') or  (T0.StartTime =  TO_DATE('2021/01/05','YYYY/MM/DD') 
 and T0.Hour < 4))))group by NeId,ObjId, StartTime,Hour  ,DSTOffset;

alter system set cbo = off;

DROP TABLE IF EXISTS FB_TBL_PART_RB;
CREATE TABLE FB_TBL_PART_RB(ID INT, C1 INT)
PARTITION BY RANGE (ID)
(
PARTITION P1 VALUES LESS THAN (10),
PARTITION P2 VALUES LESS THAN (maxvalue)
) TABLESPACE USERS;
CREATE INDEX IDX_1_PART ON FB_TBL_PART_RB (C1);
CREATE INDEX IDX_2_PART ON FB_TBL_PART_RB (ID) local;

INSERT INTO FB_TBL_PART_RB VALUES (1, 1);
INSERT INTO FB_TBL_PART_RB VALUES (40, 1);
COMMIT;
ALTER INDEX IDX_2_PART ON FB_TBL_PART_RB modify PARTITION P1 UNUSABLE;
truncate table FB_TBL_PART_RB;
alter index idx_2_part ON FB_TBL_PART_RB rebuild;
FLASHBACK TABLE FB_TBL_PART_RB TO BEFORE TRUNCATE force;
delete from FB_TBL_PART_RB;
DROP TABLE IF EXISTS FB_TBL_PART_RB;