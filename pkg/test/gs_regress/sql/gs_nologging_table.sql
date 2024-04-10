select ID, NAME, TEMPORARY, IN_MEMORY, AUTO_PURGE, EXTENT_SIZE from v$tablespace where name in ('TEMP2', 'TEMP2_UNDO') order by name;
alter tablespace TEMP2_UNDO autoextend off;
select tablespace_name,AUTOEXTENSIBLE from SYS.DBA_DATA_FILES where tablespace_name in ('TEMP2_UNDO');
alter tablespace TEMP2_UNDO autoextend on;
create tablespace nologging_spc datafile 'nologging_spc' size 1M autoextend on nologging;
alter tablespace temp2_undo rename to temp2_undo_new_name;
-- OK: Create an unlogging table
create table nologging_t1(a int, b int, c char(100) default '123456789') nologging;
select table_name, TABLESPACE_NAME, table_type from dba_tables where table_name = 'NOLOGGING_T1';
select table_name, TABLESPACE_NAME, table_type from all_tables where table_name = 'NOLOGGING_T1';
select table_name, TABLESPACE_NAME, table_type from user_tables where table_name = 'NOLOGGING_T1';
drop table nologging_t1;
create tablespace logging_spc datafile 'logging_spc' size 1M autoextend on;

---------------CREATE NOLOGGING TABLE------------------------
-- OK: no nologging space, default is on temp2 space 
create table nologging_test (a int, b int, c char(100) default '123456789' ) nologging;
create index idx_nologging_test on nologging_test(b);
---TEMP2 expected
select table_name, TABLESPACE_NAME, table_type from dba_tables where table_name = 'NOLOGGING_TEST';
---index also on default on TEMP2
select index_name, table_name, tablespace_name from dba_indexes where table_name = 'NOLOGGING_TEST';
drop table nologging_test;

-- create on nologging space is also a nologging table and index and on the same tablespace;
create table nologging_test2 (a int, b int, c char(100) default '123456789' ) tablespace nologging_spc;
create index idx_nologging_test2 on nologging_test2(b);
select table_name, TABLESPACE_NAME, table_type from dba_tables where table_name = 'NOLOGGING_TEST2';
select index_name, table_name, tablespace_name from dba_indexes where table_name = 'NOLOGGING_TEST2';
drop table nologging_test2;
-- specified temp2 as default space
create table nologging_test2 (a int, b int, c char(100) default '123456789' ) tablespace temp2;
select table_name, TABLESPACE_NAME, table_type from dba_tables where table_name = 'NOLOGGING_TEST2';
drop table nologging_test2;

-- failed : create nologging table on normal tablespace;
create table nologging_test2 (a int, b int, c char(100) default '123456789' ) nologging tablespace logging_spc;

-- specify unlogging as user default tablespace
create user nlg_user1 identified by 'Cantian_123' default tablespace temp2;
create user nlg_user2 identified by 'Cantian_123' default tablespace nologging_spc;
drop user nlg_user1 cascade;
drop user nlg_user2 cascade;
-- failed : cannot use undo 
create user nlg_user3 identified by 'Cantian_123' default tablespace undo;
create user nlg_user4 identified by 'Cantian_123' default tablespace temp2_undo;

-- Test alter user
create user tempdb identified by 'Cantian_123';
create table tempdb.test2 (a int primary key, b int, c char(100) default '123456789' );
drop table tempdb.test2;
-- failed: 
alter user tempdb default tablespace temp;
alter user tempdb default tablespace temp2_undo;
alter user tempdb default tablespace undo;
-- OK
alter user tempdb default tablespace temp2;
--export/import
create table tempdb.nologging_exp(a int primary key, b int);
insert into tempdb.nologging_exp values(1,1);
commit;
-- global temporary table on the tempdb is also a temporary table not a nologging table
create global temporary table tempdb.temp_nlg_test(a int, b int);
select table_name, table_type from all_tables where table_name = 'TEMP_NLG_TEST';
drop table tempdb.temp_nlg_test;
-- Failed: global temporary cannot set nologging
create global temporary table tempdb.temp_nlg_test(a int, b int) nologging;

exp users=tempdb file="nologging_exp.dmp" log="nologging_exp.log";
drop table tempdb.nologging_exp;
imp users=tempdb file="nologging_exp.dmp" log="nologging_imp.log";
select owner, table_name, TABLESPACE_NAME, table_type from dba_tables where table_name = 'NOLOGGING_EXP';
select * from tempdb.nologging_exp;
drop table tempdb.nologging_exp;
alter session set current_schema= sys;

--OK: if create table on nologging space, table is nologging
create table tempdb.nologging_test3(a int);
select owner, table_name, TABLESPACE_NAME, table_type from dba_tables where table_name = 'NOLOGGING_TEST3';
drop table tempdb.nologging_test3;
--OK: if create table on nologging space, table is nologging
create table tempdb.nlg_test_hash1 (
c3 char(20) primary key,
c4 number(8) not null
)
partition by hash(c3)
(
partition part_01,
partition part_02,
partition part_03
);
select owner, table_name, TABLESPACE_NAME, table_type from dba_tables where table_name = 'NLG_TEST_HASH1';
--failed: nologging partition table add partition on logging tablespace
alter table tempdb.nlg_test_hash1 add partition part_04 tablespace users;
drop table tempdb.nlg_test_hash1;
create table tempdb.nlg_test_hash1 (
c3 char(20) primary key,
c4 number(8) not null
)
partition by hash(c3)
(
partition part_01,
partition part_02,
partition part_03
) tablespace users;
--failed: logging partition table add partition on nologging tablespace
alter table tempdb.nlg_test_hash1 add partition part_04 tablespace temp2;
drop table tempdb.nlg_test_hash1;

drop user tempdb cascade;
-------------CRATE PARTITION TABLE --------------------------
-- 1.partiton table : create as nologging table default on temp2 space
create table NLG_PART_TEST1 (a int, b int, c char(8) not null ) partition by list (c)
(
partition nlg_part1 values ('35020000'),
partition nlg_part2 values ('37020000'),
partition nlg_default values ('00000000')
)
nologging;
select table_name, TABLESPACE_NAME, table_type from dba_tables where table_name = 'NLG_PART_TEST1';
drop table NLG_PART_TEST1;

create tablespace nologging_spc2 datafile 'nologging_spc2' size 1M autoextend on nologging;
-- 2.partiton table : create as nologging table on different unlogging space
create table nlg_part_test2 (a int, b int, c char(8) not null ) partition by list (c)
(
partition nlg_part1 values ('35020000') tablespace nologging_spc,
partition nlg_part2 values ('37020000') tablespace nologging_spc2,
partition nlg_default values ('00000000') tablespace temp2
)
nologging;
drop table nlg_part_test2;

-- 3.Faild partiton table : create as nologging table on different type of space
create table nlg_part_test2 (a int, b int, c char(8) not null ) partition by list (c)
(
partition nlg_part1 values ('35020000') tablespace logging_spc,
partition nlg_part2 values ('37020000') tablespace nologging_spc2,
partition nlg_default values ('00000000') tablespace logging_spc
)
nologging;

-- 3.Faild partiton table : create as logging table on nologging space
create table nlg_part_test3 (a int, b int, c char(8) not null ) partition by list (c)
(
partition nlg_part1 values ('35020000') tablespace logging_spc,
partition nlg_part2 values ('37020000') tablespace nologging_spc2,
partition nlg_default values ('00000000') tablespace logging_spc
);
drop table nlg_part_test3;
-----------INDEX TEST -------------------------------------
------- Table and index on different nologging space
create table nologging_test2 (a int, b int, c char(100) default '123456789' ) tablespace nologging_spc;
create index idx_nologging_test2 on nologging_test2(b) tablespace nologging_spc2;
select table_name, TABLESPACE_NAME, table_type from dba_tables where table_name = 'NOLOGGING_TEST2';
select index_name, table_name, tablespace_name from dba_indexes where table_name = 'NOLOGGING_TEST2';
drop table nologging_test2;

------ Table on temp2, index specified other nologging space
create table nologging_test3 (a int, b int, c char(100) default '123456789' ) nologging;
create index idx_nologging_test3 on nologging_test3(b) tablespace nologging_spc;
select table_name, TABLESPACE_NAME, table_type from dba_tables where table_name = 'NOLOGGING_TEST3';
select index_name, table_name, tablespace_name from dba_indexes where table_name = 'NOLOGGING_TEST3';

---Failed : index on logging space
create index idx2_nologging_test3 on nologging_test3(c) tablespace logging_spc;
create table logging_test4 (a int, b int, c char(100) default '123456789' ) ;
create index idx_nologging_test on logging_test4(b) tablespace nologging_spc;
drop table nologging_test3;
drop table logging_test4;

------------ TEST BASIC UNLOGGING TABLE FUNCTION--------
create table nologging_t1(a int, b int, c char(100) default '123456789') nologging tablespace nologging_spc;
create index nologging_t1_idx_a on nologging_t1(a);
create table logging_t1(a int, b int, c char(100) default '123456789');
create index logging_t1_idx_a on logging_t1(a);

--check table type
select table_name, TABLESPACE_NAME, table_type from dba_tables where table_name = 'NOLOGGING_T1';
--insert
insert into nologging_t1(a,b) values(1,1);
insert into logging_t1(a,b) values(1,1);
commit;
insert into nologging_t1(a,b) values(2,2);
insert into logging_t1(a,b) values(2,2);
rollback;
select * from nologging_t1;
select * from logging_t1;

--dc invalidate
drop index nologging_t1_idx_a on nologging_t1;
create index nologging_t1_idx_a on nologging_t1(a);

--update
update nologging_t1 set b=b+10;
update logging_t1 set b=b+10;
select * from nologging_t1;
select * from logging_t1;
rollback;
select * from nologging_t1;
select * from logging_t1;
update nologging_t1 set b=b+10;
update logging_t1 set b=b+10;
commit;
select * from nologging_t1;
select * from logging_t1;

--delete
delete from nologging_t1;
delete from logging_t1;
rollback;
select * from nologging_t1;
select * from logging_t1;
delete from nologging_t1;
delete from logging_t1;
commit;
select * from nologging_t1;
select * from logging_t1;

insert into nologging_t1(a,b) values(1,1);
insert into logging_t1(a,b) values(1,1);
commit;

SAVEPOINT POINT1;
INSERT INTO nologging_t1(a,b) VALUES(2,2);
INSERT INTO logging_t1(a,b) VALUES(2,2);
SAVEPOINT POINT2;
INSERT INTO nologging_t1(a,b) VALUES(3,3);
INSERT INTO logging_t1(a,b) VALUES(3,3);
SAVEPOINT POINT3;
INSERT INTO nologging_t1(a,b) VALUES(4,4);
INSERT INTO logging_t1(a,b) VALUES(4,4);
SAVEPOINT POINT4;
INSERT INTO nologging_t1(a,b) VALUES(5,5);
INSERT INTO logging_t1(a,b) VALUES(5,5);
SAVEPOINT POINT5;
INSERT INTO nologging_t1(a,b) VALUES(6,6);
INSERT INTO logging_t1(a,b) VALUES(6,6);
SAVEPOINT POINT6;
INSERT INTO nologging_t1(a,b) VALUES(7,7);
INSERT INTO logging_t1(a,b) VALUES(7,7);
SAVEPOINT POINT5;
INSERT INTO nologging_t1(a,b) VALUES(8,8);
INSERT INTO logging_t1(a,b) VALUES(8,8);
SELECT * FROM nologging_t1;
SELECT '1 POINT1 2 POINT2 3 POINT3 4 POINT4 5 6 POINT6 7 POINT5 8' AS SAVEPOINT_DESC FROM DUAL;

--TEST ROLLBACK TO SAVEPOINT
ROLLBACK TO SAVEPOINT POINT7;
ROLLBACK TO SAVEPOINT POINT5;
SELECT * FROM nologging_t1;
SELECT * FROM logging_t1;
ROLLBACK TO SAVEPOINT POINT5;
SELECT * FROM nologging_t1;
SELECT * FROM logging_t1;
ROLLBACK TO SAVEPOINT POINT6;
SELECT * FROM nologging_t1;
SELECT * FROM logging_t1;
ROLLBACK TO SAVEPOINT POINT5;
SELECT * FROM nologging_t1;
SELECT * FROM logging_t1;
COMMIT;
select * from nologging_t1;
SELECT * FROM logging_t1;

SAVEPOINT AA;
insert into nologging_t1(a,b) values(1,1);
SAVEPOINT BB;
insert into nologging_t1(a,b) values(1,1);
SAVEPOINT CC;
insert into nologging_t1(a,b) values(1,1);
RELEASE SAVEPOINT AA;
ROLLBACK TO SAVEPOINT BB;
ROLLBACK TO  SAVEPOINT CC;
ROLLBACK;

--analyze
analyze table nologging_t1 compute statistics;
select count(1) from SYS_TEMP_HISTGRAM where table# = (select id from SYS_TABLES where name = 'NOLOGGING_T1');
select count(1) from SYS_TEMP_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'NOLOGGING_T1');
select * from nologging_t1 where a=1;
select * from nologging_t1;

--truncate
truncate table nologging_t1;
commit;
select * from nologging_t1;

--2pc
update nologging_t1 set a=2 where a=1;
prepare transaction '3.ab.cd';

drop table nologging_t1;
drop table logging_t1;

select ID, NAME, TEMPORARY, IN_MEMORY, AUTO_PURGE, EXTENT_SIZE from v$tablespace where name in ('TEMP2', 'TEMP2_UNDO') order by name;

--interval
create table interval_noredo(f1 int, f2 int, f3 char(30))
PARTITION BY RANGE(f2)
INTERVAL(10)
(
 PARTITION interval_noredop1 values less than(10),
 PARTITION interval_noredop2 values less than(20),
 PARTITION interval_noredop3 values less than(30)
) tablespace temp2;

create index interval_noredo_gidx1 on interval_noredo(f1);
create index interval_noredo_lidx2 on interval_noredo(f2) local;
insert into interval_noredo values(1,5,'hzy');
insert into interval_noredo values(2,15,'hzy');
insert into interval_noredo values(3,25,'hzy');
insert into interval_noredo values(4,35,'hzy');
insert into interval_noredo values(5,45,'hzy');
insert into interval_noredo values(6,55,'hzy');
insert into interval_noredo values(7,65,'hzy');
insert into interval_noredo values(8,75,'hzy');
insert into interval_noredo values(9,85,'hzy');
insert into interval_noredo values(10,95,'hzy');
insert into interval_noredo values(11,105,'hzy');
insert into interval_noredo values(12,115,'hzy');
commit;
alter table interval_noredo truncate partition interval_noredop3;
truncate table interval_noredo;
drop table interval_noredo;

----------- Clean Envirement 
-- temp2 and temp2_undo cannot be dropped
drop tablespace temp2 including contents;
drop tablespace temp2_undo including contents;

drop tablespace nologging_spc including contents;
drop tablespace nologging_spc1 including contents;
drop tablespace nologging_spc2 including contents;
drop tablespace logging_spc2 including contents;
drop tablespace logging_spc  including contents;
select * from v$tablespace where name like '%LOGGING_SPC%';

--DTS2019052413362 
conn sys/sys@127.0.0.1:1611
drop user if exists nologging_user;
create user nologging_user IDENTIFIED by 'exp_user123';
grant dba to nologging_user;
conn nologging_user/exp_user123@127.0.0.1:1611

drop table if exists nologging_table;
create table nologging_table(f1 int, f2 int) nologging;
create index t2_ind on  nologging_table (to_char(f1), f2);
create index t2_ind2 on  nologging_table (to_char(f1), upper(f2));
insert into nologging_table values(1,2);
insert into nologging_table values(4,5);
commit;

exp users=nologging_user filetype=txt file ="nolongging_txt.dmp";
exp users=nologging_user filetype=txt PARALLEL = 5 file ="nolongging_txt_parallel.dmp";
exp users=nologging_user filetype=bin file ="nolongging_bin.dmp";
exp users=nologging_user filetype=bin PARALLEL = 5 file ="nolongging_bin_parallel.dmp";

imp users=nologging_user filetype=txt file ="nolongging_txt.dmp";
imp users=nologging_user filetype=txt PARALLEL = 5 file ="nolongging_txt_parallel.dmp";
imp users=nologging_user filetype=bin file ="nolongging_bin.dmp";
imp users=nologging_user filetype=bin PARALLEL = 5 file ="nolongging_bin_parallel.dmp";

drop synonym if exists s_liu1;
drop synonym if exists s_liu2;
drop synonym if exists s_liu3;

drop table if exists #liu_tab;
alter system set LOCAL_TEMPORARY_TABLE_ENABLED = true;
create temporary table #liu_tab(a int , c varchar(50));
create synonym s_liu1 for #liu_tab;
explain select * from s_liu1;

drop table if exists liu_tab_global_temp;
create global temporary table liu_tab_global_temp(a int , c varchar(50));
create synonym s_liu2 for liu_tab_global_temp;
explain select * from s_liu2;

drop table if exists liu_nologging ;
create table liu_nologging(a int , c varchar(50)) nologging;
create synonym s_liu3 for liu_nologging;
explain select * from s_liu3;
alter system set LOCAL_TEMPORARY_TABLE_ENABLED = false;

drop table if exists #liu_tab;
drop table if exists liu_tab_global_temp;
drop table if exists liu_nologging ;
drop table if exists nologging_table;

--split part of sub_part_table when part is nologging
conn sys/sys@127.0.0.1:1611
alter database enable_logic_replication off;
create tablespace nolog_tablespace_1 datafile 'nolog_tablespace_1' size 1G;
create tablespace nolog_tablespace_2 datafile 'nolog_tablespace_2' size 1G;

drop table if exists nologging_insert_r_h_008;
create table nologging_insert_r_h_008(num int,c_id int,c_d_id bigint not null,c_w_id tinyint unsigned not null,c_uint uint not null,c_first varchar(16) not null,c_middle char(2),c_last varchar(16) not null,c_street_1 varchar(20) not null,c_street_2 varchar2(20),c_zero timestamp not null,c_start date not null,c_zip char(9) not null,c_phone char(16) not null,c_since timestamp,c_credit char(2),c_credit_lim numeric,c_discount numeric(5,2),c_balance numeric(12,2),c_ytd_payment real not null,c_payment_cnt number not null,c_delivery_cnt bool not null,c_end date not null,c_data1 varchar2(7744),c_data2 varchar(7744),c_data3 varchar(7744),c_data4 varchar(7744),c_data5 varchar(7744),c_data6 varchar(7744),c_data7 varchar(7744),c_varbinary varbinary(100),c_clob clob,c_blob blob,c_binary binary(100)) partition by range(c_id) subpartition by hash(c_w_id,c_first,c_discount) (partition p1 values less than (201) tablespace nolog_tablespace_1 (subpartition p11,subpartition p12,subpartition p13,subpartition p14,subpartition p15),partition p2 values less than (401)(subpartition p21,subpartition p22,subpartition p23,subpartition p24,subpartition p25),partition p3 values less than (601)(subpartition p31,subpartition p32,subpartition p33,subpartition p34,subpartition p35),partition p4 values less than (maxvalue)(subpartition p41,subpartition p42,subpartition p43,subpartition p44,subpartition p45)) ;
alter table nologging_insert_r_h_008 enable partition p1 nologging;
select * from sys_instance_info;
alter table nologging_insert_r_h_008 split partition p1 at(101) into (partition p1_1 tablespace nolog_tablespace_1, partition p1_2 tablespace nolog_tablespace_1);
select * from sys_instance_info;
alter table nologging_insert_r_h_008 disable partition p1_1 nologging;
alter table nologging_insert_r_h_008 disable partition p1_2 nologging;
select PARTITION_NAME from sys.adm_tab_subpartitions where NOLOGGING_INSERT='YES' and TABLE_NAME=upper('nologging_insert_r_h_008');
select * from sys_instance_info;
alter table nologging_insert_r_h_008 drop partition p1_1;
select * from sys_instance_info;
alter table nologging_insert_r_h_008 drop partition p1_2;
select * from sys_instance_info;

drop table if exists nologging_insert_r_h_008;
create table nologging_insert_r_h_008(num int,c_id int,c_d_id bigint not null,c_w_id tinyint unsigned not null,c_uint uint not null,c_first varchar(16) not null,c_middle char(2),c_last varchar(16) not null,c_street_1 varchar(20) not null,c_street_2 varchar2(20),c_zero timestamp not null,c_start date not null,c_zip char(9) not null,c_phone char(16) not null,c_since timestamp,c_credit char(2),c_credit_lim numeric,c_discount numeric(5,2),c_balance numeric(12,2),c_ytd_payment real not null,c_payment_cnt number not null,c_delivery_cnt bool not null,c_end date not null,c_data1 varchar2(7744),c_data2 varchar(7744),c_data3 varchar(7744),c_data4 varchar(7744),c_data5 varchar(7744),c_data6 varchar(7744),c_data7 varchar(7744),c_varbinary varbinary(100),c_clob clob,c_blob blob,c_binary binary(100)) partition by range(c_id) subpartition by hash(c_w_id,c_first,c_discount) (partition p1 values less than (201) tablespace nolog_tablespace_1 (subpartition p11,subpartition p12,subpartition p13,subpartition p14,subpartition p15),partition p2 values less than (401)(subpartition p21,subpartition p22,subpartition p23,subpartition p24,subpartition p25),partition p3 values less than (601)(subpartition p31,subpartition p32,subpartition p33,subpartition p34,subpartition p35),partition p4 values less than (maxvalue)(subpartition p41,subpartition p42,subpartition p43,subpartition p44,subpartition p45)) ;
alter table nologging_insert_r_h_008 enable partition p1 nologging;
select * from sys_instance_info;
alter table nologging_insert_r_h_008 split partition p1 at(101) into (partition p1_1 tablespace nolog_tablespace_1, partition p1_2 tablespace nolog_tablespace_2);
select * from sys_instance_info;
alter table nologging_insert_r_h_008 disable partition p1_1 nologging;
alter table nologging_insert_r_h_008 disable partition p1_2 nologging;
select PARTITION_NAME from sys.adm_tab_subpartitions where NOLOGGING_INSERT='YES' and TABLE_NAME=upper('nologging_insert_r_h_008');
select * from sys_instance_info;
alter table nologging_insert_r_h_008 drop partition p1_1;
select * from sys_instance_info;
alter table nologging_insert_r_h_008 drop partition p1_2;
select * from sys_instance_info;

drop table if exists nologging_insert_r_h_008;
create table nologging_insert_r_h_008(num int,c_id int,c_d_id bigint not null,c_w_id tinyint unsigned not null,c_uint uint not null,c_first varchar(16) not null,c_middle char(2),c_last varchar(16) not null,c_street_1 varchar(20) not null,c_street_2 varchar2(20),c_zero timestamp not null,c_start date not null,c_zip char(9) not null,c_phone char(16) not null,c_since timestamp,c_credit char(2),c_credit_lim numeric,c_discount numeric(5,2),c_balance numeric(12,2),c_ytd_payment real not null,c_payment_cnt number not null,c_delivery_cnt bool not null,c_end date not null,c_data1 varchar2(7744),c_data2 varchar(7744),c_data3 varchar(7744),c_data4 varchar(7744),c_data5 varchar(7744),c_data6 varchar(7744),c_data7 varchar(7744),c_varbinary varbinary(100),c_clob clob,c_blob blob,c_binary binary(100)) partition by range(c_id) subpartition by hash(c_w_id,c_first,c_discount) (partition p1 values less than (201) tablespace nolog_tablespace_1 (subpartition p11,subpartition p12,subpartition p13,subpartition p14,subpartition p15),partition p2 values less than (401)(subpartition p21,subpartition p22,subpartition p23,subpartition p24,subpartition p25),partition p3 values less than (601)(subpartition p31,subpartition p32,subpartition p33,subpartition p34,subpartition p35),partition p4 values less than (maxvalue)(subpartition p41,subpartition p42,subpartition p43,subpartition p44,subpartition p45)) ;
alter table nologging_insert_r_h_008 enable partition p1 nologging;
select * from sys_instance_info;
alter table nologging_insert_r_h_008 split partition p1 at(101) into (partition p1_1 tablespace nolog_tablespace_2, partition p1_2 tablespace nolog_tablespace_2);
select * from sys_instance_info;
alter table nologging_insert_r_h_008 disable partition p1_1 nologging;
alter table nologging_insert_r_h_008 disable partition p1_2 nologging;
select PARTITION_NAME from sys.adm_tab_subpartitions where NOLOGGING_INSERT='YES' and TABLE_NAME=upper('nologging_insert_r_h_008');
select * from sys_instance_info;
alter table nologging_insert_r_h_008 drop partition p1_1;
select * from sys_instance_info;
alter table nologging_insert_r_h_008 drop partition p1_2;
select * from sys_instance_info;

drop table if exists nologging_insert_r_h_008;
drop tablespace nolog_tablespace_1 including contents and datafiles;
drop tablespace nolog_tablespace_2 INCLUDING contents and datafiles;
