--test case1:create compress table on normal/encrypt tablespace

--expect:CT-00130, Operation create compress table is not supported on encrypt tablespace
create tablespace ct_encrypt_space datafile 'encrypt_space' size 500M compress encryption extent autoallocate;

--expect:CT-00130, Operation create compress table is not supported on normal tablespace
create tablespace ct_normal_space datafile 'ct_ns_normal_file' size 128M compress autoextend on next 32M;
create tablespace ct_normal_space datafile 'ct_ns_normal_file' size 128M autoextend on next 32M;
create user ct_normal_user identified by Cantian_234 default tablespace ct_normal_space;
grant dba to ct_normal_user;

--expect:CT-00130, Operation create compress table is not supported on normal tablespace
drop table if exists ct_normal_user.ct_normal_table;
create table ct_normal_user.ct_normal_table(i int) compress;
drop user ct_normal_user cascade;
drop tablespace ct_normal_space including contents and datafiles;

--test case2:base function test

create tablespace ct_compress_space datafile 'ct_cs_compress_file' size 128M compress autoextend on next 32M extent autoallocate;
alter tablespace ct_compress_space add datafile 'ct_cs_normal_file' size 128M autoextend on next 32M;
create user ct_compress_user identified by Cantian_234 default tablespace ct_compress_space;
grant dba to ct_compress_user;

--DTS202104160HFHQAP1300:interval part inherit table's compression mode
drop table if exists ct_compress_user.compress_part_inter_001;
create table ct_compress_user.compress_part_inter_001(num int,c_id int) compress PARTITION BY RANGE(C_ID) interval(100)
(PARTITION P1 VALUES LESS THAN(201),
PARTITION P2 VALUES LESS THAN(401),
PARTITION P3 VALUES LESS THAN(601),
PARTITION P4 VALUES LESS THAN(701)) TABLESPACE ct_compress_space;
insert into ct_compress_user.compress_part_inter_001 values(1,800);
select count(*) from adm_tab_partitions where table_name=upper('compress_part_inter_001') and compress_algo='ZSTD';

--loop insert test
drop table if exists ct_compress_user.ct_compress_table1;
create table ct_compress_user.ct_compress_table1
(
sm_ID INTEGER,
OrgAddr VARCHAR(21),
DestAddr VARCHAR(21),
ScAddr VARCHAR(21),
MTMscAddr VARCHAR(21),
esm_class char(1),
PRI char(1),
MMS char(1),
RP char(1),
UDHI char(1),
SRR char(1),
PID char(1),
DCS char(1),
TimeStamp VARCHAR(20),
UDL NUMBER(4,0),
ServiceType VARCHAR(6),
STATUSREPORT CHAR(1),
SubmitTime CHAR(20),
ucSMStatus CHAR(1),
MOMscAddrType CHAR(1),
MOMscAddr CHAR(21),
MOMscTON CHAR(1),
MOMscNPI CHAR(1),
MTMscAddrType CHAR(1),
MTMscTON CHAR(1),
MTMscNPI CHAR(1),
OrgTON CHAR(1),
OrgNPI CHAR(1),
DestTON CHAR(1),
DestNPI CHAR(1),
MR CHAR(1),
RN CHAR(2),
MN CHAR(1),
SN CHAR(1),
ErrCode CHAR(1),
OrigShortNum VARCHAR(20),
DestShortNum VARCHAR(20),
SMLogType CHAR(1),
OrgAccount VARCHAR(21),
DestAccount VARCHAR(21)
) partition by range(sm_ID) 
(
partition p1 VALUES LESS THAN (2000) format csf compress,
partition p2 VALUES LESS THAN (3000) format csf compress,
partition p3 VALUES LESS THAN (4000),
partition p4 VALUES LESS THAN (10000) format csf compress
);

--expect:CT-00601, [1:104]Sql syntax error: unexpected text compress
create index ct_compress_user.ORGADDRs_INDEXS on ct_compress_user.ct_compress_table1 (OrgAddr,DestAddr) compress;
create index ct_compress_user.DESTADDRs_INDEXS on ct_compress_user.ct_compress_table1 (DestAddr) compress;

create index ct_compress_user.ORGADDRs_INDEXS on ct_compress_user.ct_compress_table1 (OrgAddr,DestAddr);
create index ct_compress_user.DESTADDRs_INDEXS on ct_compress_user.ct_compress_table1 (DestAddr);

DECLARE
BEGIN
    FOR I IN 1..10000 LOOP
    insert into ct_compress_user.ct_compress_table1(sm_ID,OrgAddr,DestAddr,ScAddr,MTMscAddr,esm_class,PRI,MMS,RP,UDHI,SRR,PID,DCS,TimeStamp,UDL,ServiceType,STATUSREPORT,SubmitTime,ucSMStatus,MOMscAddrType,MOMscAddr,MOMscTON,MOMscNPI,MTMscAddrType,MTMscTON,MTMscNPI,OrgTON,OrgNPI,DestTON,DestNPI,MR,RN,MN,SN,ErrCode,OrigShortNum,DestShortNum,SMLogType,OrgAccount,DestAccount)
       values(round(DBE_RANDOM.GET_VALUE(1000,9999)),round(DBE_RANDOM.GET_VALUE(1000000000000000000, 9000000000000000000)),round(DBE_RANDOM.GET_VALUE(1000000000000000000, 9000000000000000000)),round(DBE_RANDOM.GET_VALUE(1000000000000000000, 9000000000000000000)),round(DBE_RANDOM.GET_VALUE(1000000000000000000, 9000000000000000000)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(19999999999999999999, 99999999999999999999)),round(DBE_RANDOM.GET_VALUE(1000, 9999)),round(DBE_RANDOM.GET_VALUE(100000, 999999)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1999999999999999999, 9999999999999999999)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(19999999999999999999, 99999999999999999999)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(2, 99)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1000000000000000000, 9000000000000000000)),round(DBE_RANDOM.GET_VALUE(1000000000000000000, 9000000000000000000)),round(DBE_RANDOM.GET_VALUE(1, 9)),round(DBE_RANDOM.GET_VALUE(1000000000000000000, 9000000000000000000)),round(DBE_RANDOM.GET_VALUE(1000000000000000000, 9000000000000000000)));
    END LOOP;
END;
/
commit;
alter system checkpoint;
select count(*) from ct_compress_user.ct_compress_table1;

--test case3:

--single part compress test
drop table if exists ct_compress_user.ct_compress_table2;
create table ct_compress_user.ct_compress_table2(id int, name varchar2(100)) PARTITION BY list(id)
(
partition p11 values (1),
partition p21 values (2),
partition p31 values (3) format csf compress
);
select count(*) from adm_tab_partitions where table_name=upper('ct_compress_table2') and compress_algo='ZSTD';
--split part test
--coalesce part test
--part inherit table's compression mode
drop table if exists ct_compress_user.ct_compress_table3;
create table ct_compress_user.ct_compress_table3(id int, name varchar2(100)) PARTITION BY list(id)
(
partition p11 values (1),
partition p21 values (2),
partition p31 values (3) 
) format csf compress;
select count(*) from adm_tab_partitions where table_name=upper('ct_compress_table3') and compress_algo='ZSTD';

--test case4: sql syntax test

--expect:CT-00601, [13:3]Sql syntax error: unexpected text compress, table doesn't support compress if exists subpartitons
drop table if exists ct_compress_user.ct_compress_table4;
create table ct_compress_user.ct_compress_table4(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
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
) compress;
select count(*) from adm_tab_partitions where table_name=upper('ct_compress_table4') and compress_algo='ZSTD';

--expect:CT-00601, [13:3]Sql syntax error: unexpected text compress, table part doesn't support compress if exists subpartitons
drop table if exists ct_compress_user.ct_compress_table5;
create table ct_compress_user.ct_compress_table5(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50) compress
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
select count(*) from adm_tab_partitions where table_name=upper('ct_compress_table5') and compress_algo='ZSTD';

--add part test
drop table if exists ct_compress_user.ct_compress_table6;
create table ct_compress_user.ct_compress_table6(id int, name varchar2(100)) PARTITION BY list(id) 
(
partition p1 values (1) format csf compress,
partition p2 values (2),
partition p3 values (3) format csf compress
);
alter table ct_compress_user.ct_compress_table6 add partition p6 values(4) format csf compress;
alter table ct_compress_user.ct_compress_table6 add partition p7 values(5);
select count(*) from adm_tab_partitions where table_name=upper('ct_compress_table6') and compress_algo='ZSTD';

--split part test
drop table if exists ct_compress_user.ct_compress_table7;
create table ct_compress_user.ct_compress_table7(id int,c_number number)partition by range(c_number)(partition part_1 values less than(40), partition part_2 values less than(100) compress);
alter table ct_compress_user.ct_compress_table7 split partition part_2 at (70) into (partition part_2_1 compress, partition part_2_2);
alter table ct_compress_user.ct_compress_table7 split partition part_1 at (20) into (partition part_1_1 compress, partition part_1_2);
select count(*) from adm_tab_partitions where table_name=upper('ct_compress_table7') and compress_algo='ZSTD';

-- set compress of hash part which implicit created
drop table if exists ct_compress_user.ct_compress_table8;
create table ct_compress_user.ct_compress_table8(id int) partition by hash(id)partitions 8 compress;
select count(*) from adm_tab_partitions where table_name=upper('ct_compress_table8') and compress_algo='ZSTD';

-- don't support compress if exits subpartitions
drop table if exists ct_compress_user.ct_compress_table9;
create table ct_compress_user.ct_compress_table9(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50) compress
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
));
drop table if exists ct_compress_user.ct_compress_table9;
create table ct_compress_user.ct_compress_table9(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
)) compress;
drop table if exists ct_compress_user.ct_compress_table9;
create table ct_compress_user.ct_compress_table9(id int) PARTITION BY RANGE(ID) INTERVAL(50) SUBPARTITION BY RANGE(id)
(
PARTITION P1 VALUES LESS THAN(50)
(
SUBPARTITION p11 VALUES LESS THAN (2)
));
alter table ct_compress_user.ct_compress_table9 modify partition p1 add subpartition p12 values less than(8) compress;
select count(*) from adm_tab_partitions where table_name=upper('ct_compress_table9') and compress_algo='ZSTD';

--expect:CT-00601, [1:98]Sql syntax error: unexpected text compress, table compress only supported on (part)table
drop table if exists ct_compress_user.ct_temp_table;
create global temporary table ct_compress_user.ct_temp_table(id int, c_id int, name varchar(20)) compress;
--expect:CT-00601, [1:98]Sql syntax error: unexpected text compress, table compress only supported on (part)table
drop table if exists ct_compress_user.ct_temp_table;
create global temporary table ct_compress_user.ct_temp_table(id int, c_id int, name varchar(20)) on Commit Preserve Rows compress;
--expect:CT-00601, [1:98]Sql syntax error: unexpected text compress, table compress only supported on (part)table
drop table if exists ct_compress_user.ct_temp_table;
create table ct_compress_user.ct_temp_table(id int, c_id int, name varchar(20)) nologging compress;
--expect:CT-00601, [1:98]Sql syntax error: unexpected text nologging, table compress only supported on (part)table
drop table if exists ct_compress_user.ct_temp_table;
create table ct_compress_user.ct_temp_table(id int, c_id int, name varchar(20)) compress nologging;

--DTS202104170IBUTKP1300
create table ct_compress_user.tc_compress_csf_001(num int,c_id int,c_last varchar(16) NOT NULL) compress partition by hash(c_id,c_last) partitions 8 compress tablespace ct_compress_space compress compress;

--DTS202104160JISCHP1300
create tablespace nebula_tablespace datafile 'nebula_tablespace' size 500M compress autoextend on next 1G encryption extent autoallocate;

--DTS202104150KWMAYP0F00
alter tablespace temp add datafile 'test_temp' size 128M compress autoextend on next 32M;

--DTS202104150KWMAYP0F00
drop table if exists ct_compress_user.tc_compress_tbl_001_06;
create table ct_compress_user.tc_compress_tbl_001_06 (num int,c_id int,c_d_id bigint NOT NULL) partition by hash(c_id) subpartition by hash(c_d_id) (partition p1(subpartition p11,subpartition p12)) compress;
drop table if exists ct_compress_user.tc_compress_tbl_001_06;
create table ct_compress_user.tc_compress_tbl_001_06 (num int,c_id int,c_d_id bigint NOT NULL) compress partition by hash(c_id) subpartition by hash(c_d_id) (partition p1(subpartition p11,subpartition p12));

drop user ct_compress_user cascade;
drop tablespace ct_compress_space including contents and datafiles;

--DTS2021042007LUUOP0G00
CREATE TABLESPACE TABLESPACE_PARTITION_range_2 DATAFILE 'PARTITION_range_2' SIZE 8M compress AUTOEXTEND ON NEXT 8M extent autoallocate;
drop table if exists strg_tablespace_split_range_tbl_001;
create table strg_tablespace_split_range_tbl_001(id int,c_number number)partition by range(c_number)(partition part_1 values less than(40) TABLESPACE sysaux,partition part_2 values less than(100) format csf compress) tablespace TABLESPACE_PARTITION_range_2 format csf;
insert into strg_tablespace_split_range_tbl_001 values(10,10),(20 ,20),(30,30),(40,40),(50,50),(60,60),(70,70),(80,80),(90,90);
alter table strg_tablespace_split_range_tbl_001 split partition part_2 at (70) into (partition part_2_1 tablespace sysaux, partition part_2_2);
drop tablespace TABLESPACE_PARTITION_range_2 including contents and datafiles;
