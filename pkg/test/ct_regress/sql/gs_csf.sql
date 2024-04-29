--DTS202007170479MTP0J00
ALTER SYSTEM SET EMPTY_STRING_AS_NULL = FALSE;
drop table if exists aa_csf;
create table aa_csf(a number, b varchar(10), c char(8000)) format csf;
insert into aa_csf values(0, '1', 'asdf');
update aa_csf set b = '';
select * from aa_csf where b = '';
select count(*) from aa_csf where b is null;
drop table if exists test;
create table test(name varchar(1000));
insert into test values('111');
commit;
update test set name = (select '' from sys_dummy) where name = '111';
drop table test;
ALTER SYSTEM SET EMPTY_STRING_AS_NULL = TRUE;

drop user if exists wanggang1 cascade;
create user wanggang1 identified by 'Changeme_123';
grant dba to wanggang1;
conn wanggang1/Changeme_123@127.0.0.1:1611
--base table  
drop table if exists aa;
create table aa(C_ID INT, C_PAYMENT_CNT_3 NUMBER(12,8), PRIMARY KEY (C_ID)) format csf;
create OR REPLACE PROCEDURE insert_into_aa(STARTNUM INT,ENDALL INT) IS
I int :=1;
begin
  for I in STARTNUM..ENDALL loop
    INSERT INTO aa SELECT I, (I+0.12345678) FROM SYS_DUMMY;
  end loop;
end;
/
call insert_into_aa(1,10);
select * from aa order by C_ID;
--csf table
DROP TABLE IF EXISTS aa_csf;
CREATE TABLE aa_csf(C_ID INT, C_PAYMENT_CNT_3 NUMBER(12,8), PRIMARY KEY (C_ID)) 
PARTITION BY LIST(C_PAYMENT_CNT_3)(PARTITION PART_1 VALUES (0,1),PARTITION PART_2 VALUES (2,3),PARTITION PART_3 VALUES (4,5),PARTITION PART_4 VALUES (6,7),PARTITION PART_5 VALUES (DEFAULT)) FORMAT CSF ;
INSERT INTO aa_csf SELECT * FROM aa;
UPDATE aa_csf SET C_PAYMENT_CNT_3=MOD(C_ID,10);
COMMIT;
select * from aa_csf order by C_ID;
--asf table
DROP TABLE IF EXISTS aa_asf;
CREATE TABLE aa_asf(C_ID INT, C_PAYMENT_CNT_3 NUMBER(12,8), PRIMARY KEY (C_ID)) 
PARTITION BY LIST(C_PAYMENT_CNT_3)(PARTITION PART_1 VALUES (0,1),PARTITION PART_2 VALUES (2,3),PARTITION PART_3 VALUES (4,5),PARTITION PART_4 VALUES (6,7),PARTITION PART_5 VALUES (DEFAULT)) ;
INSERT INTO aa_asf SELECT * FROM aa;
UPDATE aa_asf SET C_PAYMENT_CNT_3=MOD(C_ID,10);
COMMIT;
select * from aa_asf order by C_ID;
select table_name,row_format from db_tables where owner = 'WANGGANG1' order by table_name;

conn sys/Huawei@123@127.0.0.1:1611
exp users=wanggang1 filetype=bin file='csf_wanggang1.bin';
exp users=wanggang1 filetype=txt file='csf_wanggang1.txt';

drop user if exists wanggang2 cascade;
create user wanggang2 identified by 'Changeme_123';
grant dba to wanggang2;
imp remap_schema=wanggang1:wanggang2 filetype=bin file='csf_wanggang1.bin';
select table_name,row_format from db_tables where owner = 'WANGGANG2' order by table_name;
select * from wanggang2.aa order by C_ID;
select * from wanggang2.aa_csf order by C_ID;
select * from wanggang2.aa_asf order by C_ID;
conn wanggang2/Changeme_123@127.0.0.1:1611
show create table aa;
show create table aa_csf;
show create table aa_asf;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists wanggang3 cascade;
create user wanggang3 identified by 'Changeme_123';
grant dba to wanggang3;
imp remap_schema=wanggang1:wanggang3 filetype=txt file='csf_wanggang1.txt';
select table_name,row_format from db_tables where owner = 'WANGGANG3' order by table_name;
select * from wanggang3.aa order by C_ID;
select * from wanggang3.aa_csf order by C_ID;
select * from wanggang3.aa_asf order by C_ID;
conn wanggang3/Changeme_123@127.0.0.1:1611
show create table aa;
show create table aa_csf;
show create table aa_asf;

-- exp/imp part csf
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists wanggang4 cascade;
create user wanggang4 identified by 'Changeme_123';
grant dba to wanggang4;
conn wanggang4/Changeme_123@127.0.0.1:1611
drop table  if exists t_part_csf1;
create table t_part_csf1(id int, name varchar2(100)) PARTITION BY list(id) 
(
partition p1 values (1) format csf,
partition p2 values (2),
partition p3 values (3) format csf
);
alter table t_part_csf1 add partition p6 values(4) format csf;
alter table t_part_csf1 add partition p7 values(5);

drop table  if exists t_part_csf2;
create table t_part_csf2(id int, name varchar2(100)) PARTITION BY range(id) 
(
partition p1 VALUES LESS THAN (1) format csf,
partition p2 VALUES LESS THAN (2),
partition p3 VALUES LESS THAN (3) format csf
); 
alter table t_part_csf2 add partition p6 VALUES LESS THAN(4) format csf;
alter table t_part_csf2 add partition p7 VALUES LESS THAN(5);

drop table  if exists t_part_csf3;
create table t_part_csf3(id int, name varchar2(100)) PARTITION BY range(id) interval(1)
(
partition p1 VALUES LESS THAN (1),
partition p2 VALUES LESS THAN (2),
partition p3 VALUES LESS THAN (3)
);

drop table  if exists t_part_csf4;
create table t_part_csf4(id int, name varchar2(100)) PARTITION BY hash(id)
(
partition p1 format csf,
partition p2,
partition p3 format csf
);
alter table t_part_csf4 add partition p6 format csf;
alter table t_part_csf4 add partition p7;

drop table  if exists t_part_csf11;
create table t_part_csf11(id int, name varchar2(100)) PARTITION BY list(id) 
(
partition p1 values (1) format csf,
partition p2 values (2),
partition p3 values (3) format csf
) format csf; 
alter table t_part_csf11 add partition p6 values(4) format csf;
alter table t_part_csf11 add partition p7 values(5);

drop table  if exists t_part_csf22;
create table t_part_csf22(id int, name varchar2(100)) PARTITION BY range(id) 
(
partition p1 VALUES LESS THAN (1) format csf,
partition p2 VALUES LESS THAN (2),
partition p3 VALUES LESS THAN (3) format csf
) format csf; 
alter table t_part_csf22 add partition p6 VALUES LESS THAN(4) format csf;
alter table t_part_csf22 add partition p7 VALUES LESS THAN(5);

drop table  if exists t_part_csf33;
create table t_part_csf33(id int, name varchar2(100)) PARTITION BY range(id) interval(1)
(
partition p1 VALUES LESS THAN (1),
partition p2 VALUES LESS THAN (2),
partition p3 VALUES LESS THAN (3)
) format csf;

drop table  if exists t_part_csf44;
create table t_part_csf44(id int, name varchar2(100)) PARTITION BY hash(id)
(
partition p1 format csf,
partition p2,
partition p3 format csf
) format csf;
alter table t_part_csf44 add partition p6 format csf;
alter table t_part_csf44 add partition p7;

drop table if exists test_subpart1;
drop table if exists test_subpart2;
drop table if exists test_subpart3;
drop table if exists test_subpart4;
drop table if exists test_subpart11;
drop table if exists test_subpart22;
drop table if exists test_subpart33;
drop table if exists test_subpart44;
create table test_subpart1(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
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
)format csf;


create table test_subpart2(id int, name varchar(20)) partition by range(id) subpartition by hash(name)
(
partition p1 values less than(50)
(
subpartition p11,
subpartition p12
),
partition p2 values less than(100)
(
subpartition p21,
subpartition p22
)
)format csf;

create table test_subpart3(id int, name varchar(20)) partition by list(name) subpartition by range(id)
(
partition p1 values('zhangsan')
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
),
partition p2 values('lisi')
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
)
)format csf;

create table test_subpart4(id int, c_id int, name varchar(20)) partition by range(id) interval(50) subpartition by range(c_id)
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
)format csf;

create table test_subpart11(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50) format csf
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

create table test_subpart22(id int, name varchar(20)) partition by range(id) subpartition by hash(name)
(
partition p1 values less than(50) format csf
(
subpartition p11,
subpartition p12
),
partition p2 values less than(100)
(
subpartition p21,
subpartition p22
)
);

create table test_subpart33(id int, name varchar(20)) partition by list(name) subpartition by range(id)
(
partition p1 values('zhangsan') format csf
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
),
partition p2 values('lisi')
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
)
);

create table test_subpart44(id int, c_id int, name varchar(20)) partition by range(id) interval(50) subpartition by range(c_id)
(
partition p1 values less than(50) format csf
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
drop table if exists test_subpart1;
drop table if exists test_subpart2;
drop table if exists test_subpart3;
drop table if exists test_subpart4;
drop table if exists test_subpart11;
drop table if exists test_subpart22;
drop table if exists test_subpart33;
drop table if exists test_subpart44;

conn sys/Huawei@123@127.0.0.1:1611
exp users=wanggang4 filetype=bin file='csf_part_wanggang4.bin';
exp users=wanggang4 filetype=txt file='csf_part_wanggang4.txt';

drop user if exists wanggang5 cascade;
create user wanggang5 identified by 'Changeme_123';
grant dba to wanggang5;
imp remap_schema=wanggang4:wanggang5 filetype=bin file='csf_part_wanggang4.bin';
conn wanggang5/Changeme_123@127.0.0.1:1611
show create table t_part_csf1;
show create table t_part_csf2;
show create table t_part_csf3;
show create table t_part_csf4;
show create table t_part_csf11;
show create table t_part_csf22;
show create table t_part_csf33;
show create table t_part_csf44;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists wanggang6 cascade;
create user wanggang6 identified by 'Changeme_123';
grant dba to wanggang6;
imp remap_schema=wanggang4:wanggang6 filetype=txt file='csf_part_wanggang4.txt';
conn wanggang6/Changeme_123@127.0.0.1:1611
show create table t_part_csf1;
show create table t_part_csf2;
show create table t_part_csf3;
show create table t_part_csf4;
show create table t_part_csf11;
show create table t_part_csf22;
show create table t_part_csf33;
show create table t_part_csf44;

select table_name, PARTITION_NAME, row_format from my_tab_partitions where table_name = 'T_PART_CSF1' order by partition_name;
select table_name, PARTITION_NAME, row_format from ADM_TAB_PARTITIONS where table_name = 'T_PART_CSF2' and table_owner = 'WANGGANG6' order by partition_name;
select table_name, PARTITION_NAME, row_format from DB_TAB_PARTITIONS where table_name = 'T_PART_CSF33' and table_owner = 'WANGGANG6' order by partition_name;

--can't use format csf for split part
drop table if exists t_part_csf;
create table t_part_csf(id int,c_number number)partition by range(c_number)(partition part_1 values less than(40), partition part_2 values less than(100) format csf);
alter table t_part_csf split partition part_2 at (70) into (partition part_2_1 format csf, partition part_2_2);
alter table t_part_csf split partition part_1 at (20) into (partition part_1_1 format csf, partition part_1_2);

-- set csf format of hash part which implicit created
drop table if exists test_hash_part;
create table test_hash_part(id int) partition by hash(id)partitions 8 format csf;
select TABLE_NAME, row_format from ADM_TAB_PARTITIONS where TABLE_NAME=upper('test_hash_part');

-- DTS202009160JE1FOP0G00
drop table if exists TAB_PARTITION_CSF_002;
CREATE TABLE "TAB_PARTITION_CSF_002"
(
  "ID" BINARY_INTEGER NOT NULL,
  "C_INT" BINARY_INTEGER,
  "C_VCHAR" VARCHAR(20 BYTE) NOT NULL,
  "C_CLOB" CLOB NOT NULL,
  "C_BLOB" BLOB NOT NULL,
  "C_DATE" DATE
)
PARTITION BY RANGE ("ID")
INTERVAL(10)
(
    PARTITION P1 VALUES LESS THAN (100) TABLESPACE "USERS" INITRANS 2 PCTFREE 8,
    PARTITION P2 VALUES LESS THAN (200) TABLESPACE "USERS" INITRANS 2 PCTFREE 8,
    PARTITION P3 VALUES LESS THAN (300) TABLESPACE "USERS" INITRANS 2 PCTFREE 8
);
CREATE INDEX "IDX_TAB_PARTITION_CSF_002_001" ON "TAB_PARTITION_CSF_002"("C_INT");
CREATE INDEX "IDX_TAB_PARTITION_CSF_002_002" ON "TAB_PARTITION_CSF_002"("C_INT", "C_VCHAR");
CREATE INDEX "IDX_TAB_PARTITION_CSF_002_003" ON "TAB_PARTITION_CSF_002"("C_INT", "C_VCHAR", "C_DATE");
ALTER TABLE "TAB_PARTITION_CSF_002" ADD CONSTRAINT "TAB_PARTITION_CSF_002_CON" PRIMARY KEY("C_VCHAR");
declare 
  i int;
  str varchar(100);
  ID int;
  C_INT int;
  C_VCHAR  varchar(200);
  C_CLOB   varchar(200);
  C_BLOB   varchar(200);
  C_DATE   varchar(200);
begin
  i := 1;
  for i in 1..501 
  loop
	ID := i;
	C_INT := 10||i;
	C_VCHAR := 'abc123'||i;
	C_CLOB := 'abcabcabcabcabcabcabcabcabcabcabcabcabcabcab123abc'||i;
	C_BLOB := '11001100110011001100110011001100110011001111100011';
	C_DATE := '1800-01-01 10:51:47';
	insert into	TAB_PARTITION_CSF_002 values(ID, C_INT, C_VCHAR, C_CLOB, C_BLOB, C_DATE);
  end loop;
  commit;
end;
/

drop table if exists TAB_PARTITION_CSF_004;
CREATE TABLE "TAB_PARTITION_CSF_004"
(
  "C_ID" BINARY_INTEGER,
  "C_D_ID" BINARY_INTEGER NOT NULL,
  "C_W_ID" BINARY_INTEGER NOT NULL,
  "C_FIRST" VARCHAR(40 BYTE) NOT NULL,
  "C_MIDDLE" CHAR(2 BYTE),
  "C_LAST" VARCHAR(50 BYTE) NOT NULL,
  "C_STREET_1" VARCHAR(35 BYTE) NOT NULL,
  "C_STREET_2" VARCHAR(20 BYTE),
  "C_CITY" VARCHAR(20 BYTE) NOT NULL,
  "C_STATE" CHAR(2 BYTE) NOT NULL,
  "C_ZIP" CHAR(9 BYTE) NOT NULL,
  "C_PHONE" CHAR(40 BYTE) NOT NULL,
  "C_SINCE" TIMESTAMP(6),
  "C_CREDIT" CHAR(2 BYTE) NOT NULL,
  "C_CREDIT_LIM" NUMBER(12, 2),
  "C_DISCOUNT" NUMBER(4, 4),
  "C_BALANCE" NUMBER(12, 2),
  "C_YTD_PAYMENT" BINARY_DOUBLE NOT NULL,
  "C_PAYMENT_CNT" NUMBER NOT NULL,
  "C_DELIVERY_CNT" BOOLEAN NOT NULL,
  "C_END" DATE NOT NULL,
  "C_UNSIG" BINARY_INTEGER,
  "C_BIG" BINARY_BIGINT,
  "C_VCHAR" VARCHAR(8000 BYTE),
  "C_DATA" CLOB,
  "C_TEXT" BLOB,
  "C_CLOB" CLOB
)
PARTITION BY HASH ("C_ID")
(
    PARTITION PART_1 INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PART_2 INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PART_3 INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PART_4 INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PART_5 INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PART_6 INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PART_7 INITRANS 2 PCTFREE 8 FORMAT CSF,
    PARTITION PART_8 INITRANS 2 PCTFREE 8 FORMAT CSF
)FORMAT CSF;
INSERT INTO "TAB_PARTITION_CSF_004" ("C_ID","C_D_ID","C_W_ID","C_FIRST","C_MIDDLE","C_LAST","C_STREET_1","C_STREET_2","C_CITY","C_STATE","C_ZIP","C_PHONE","C_SINCE","C_CREDIT","C_CREDIT_LIM","C_DISCOUNT","C_BALANCE","C_YTD_PAYMENT","C_PAYMENT_CNT","C_DELIVERY_CNT","C_END","C_UNSIG","C_BIG","C_VCHAR","C_DATA","C_TEXT","C_CLOB") values
  (1,1,1,'AAis1cmvls','OE','AABAR1ddBARBAR','bkili1fcxcle1','pmbwo1vhvpaj1','dyf1rya1','uq','48001    ','94012051                                ','1800-01-01 10:51:47.000000','GC',50000,.4361,-10,10,1,TRUE,'1800-01-01 10:51:47',1,1,'ABfgCDefgh','bxxbm','76873890157687389015768738901576873890157687389015768738901576873890157687389015768738901576873890157687389015768738901576873890157687389015768738901576873890157687389015768124324543256546324554354325','xxbm');
INSERT INTO "TAB_PARTITION_CSF_004" ("C_ID","C_D_ID","C_W_ID","C_FIRST","C_MIDDLE","C_LAST","C_STREET_1","C_STREET_2","C_CITY","C_STATE","C_ZIP","C_PHONE","C_SINCE","C_CREDIT","C_CREDIT_LIM","C_DISCOUNT","C_BALANCE","C_YTD_PAYMENT","C_PAYMENT_CNT","C_DELIVERY_CNT","C_END","C_UNSIG","C_BIG","C_VCHAR","C_DATA","C_TEXT","C_CLOB") values
  (2,2,2,'AAis2cmvls','OE','AABAR2ddBARBAR','bkili2fcxcle2','pmbwo2vhvpaj2','dyf2rya2','uq','48002    ','94022052                                ','1800-01-01 10:51:47.000000','GC',50000,.4361,-10,10,1,TRUE,'1800-01-01 10:51:47',2,2,'ABfgCDefgh','bxxbm','76873890157687389015768738901576873890157687389015768738901576873890157687389015768738901576873890157687389015768738901576873890157687389015768738901576873890157687389015768124324543256546324554354325','xxbm');
COMMIT;

select count(*) from (SELECT		
	REGEXP_COUNT  (
	1,
	MAX(ref_0.C_LAST) over ( partition by ref_1.C_CLOB ORDER BY ref_0.C_BIG)
	) 
FROM
	TAB_PARTITION_CSF_004  AS ref_0
	FULL JOIN 
	TAB_PARTITION_CSF_002 AS ref_1
	on     1 =1);
	
-- test the WITH_FORMAT_CSF option which is N
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists wanggang7 cascade;
create user wanggang7 identified by 'Changeme_123';
grant dba to wanggang7;
conn wanggang7/Changeme_123@127.0.0.1:1611
drop table if exists t_WITH_FORMAT_CSF1;
create table t_WITH_FORMAT_CSF1(a int) format csf;
drop table if exists t_WITH_FORMAT_CSF2;
create table t_WITH_FORMAT_CSF2(id int, name varchar2(100)) PARTITION BY range(id) 
(
partition p1 VALUES LESS THAN (1) format csf,
partition p2 VALUES LESS THAN (2),
partition p3 VALUES LESS THAN (3) format csf
) format csf;

exp users=wanggang7 filetype=bin file='csf_wanggang7.bin' with_format_csf=N;
exp users=wanggang7 filetype=txt file='csf_wanggang7.txt' with_format_csf=N;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists wanggang8 cascade;
create user wanggang8 identified by 'Changeme_123';
grant dba to wanggang8;
conn wanggang8/Changeme_123@127.0.0.1:1611
imp remap_schema=wanggang7:wanggang8 filetype=bin file='csf_wanggang7.bin';
-- table is not csf
show create table t_WITH_FORMAT_CSF1;
-- table and part table are not csf
show create table t_WITH_FORMAT_CSF2;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists wanggang9 cascade;
create user wanggang9 identified by 'Changeme_123';
grant dba to wanggang9;
conn wanggang9/Changeme_123@127.0.0.1:1611
imp remap_schema=wanggang7:wanggang9 filetype=txt file='csf_wanggang7.txt';
-- table is not csf
show create table t_WITH_FORMAT_CSF1;
-- table and part table are not csf
show create table t_WITH_FORMAT_CSF2;

-- don't support format csf if exits subpartitions
create table test_subpart_error(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50) 
(
subpartition p11 values less than(50) format csf,
subpartition p12 values less than(100)
));
create table test_subpart_error(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50) format csf
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
));
create table test_subpart_error(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
)) format csf;
drop table if exists test_subpart;
create table test_subpart(id int) PARTITION BY RANGE(ID) INTERVAL(50) SUBPARTITION BY RANGE(id)
(
PARTITION P1 VALUES LESS THAN(50)
(
SUBPARTITION p11 VALUES LESS THAN (2)
));
alter table test_subpart modify partition p1 add subpartition p12 values less than(8) format csf;
drop table if exists shrink_timeout_sub_001;
create table shrink_timeout_sub_001(f1 int not null,f2 bigint,f3 numeric,f4 varchar(200),f5 date,f6 varchar(8000),f7 clob,f8 blob) partition by range(f1) subpartition by hash(f2) (partition p1 values less than(201) (subpartition p11,subpartition p12,subpartition p13), partition p2 values less than(401) (subpartition p21,subpartition p22,subpartition p23), partition p3 values less than(601) (subpartition p31,subpartition p32,subpartition p33), partition p4 values less than(801) (subpartition p41,subpartition p42,subpartition p43), partition p5 values less than(1201) (subpartition p51,subpartition p52,subpartition p53));
alter table shrink_timeout_sub_001 add partition p6 values less than(maxvalue) format csf (subpartition p61,subpartition p62);
alter table shrink_timeout_sub_001 add partition p6 values less than(maxvalue) format csf;
drop table if exists training;
CREATE TABLE training(staff_id INT NOT NULL, course_name CHAR(20), course_period DATETIME, exam_date DATETIME, score INT)
PARTITION BY RANGE(staff_id)
(
PARTITION training2 VALUES LESS THAN(200),
PARTITION training3 VALUES LESS THAN(300),
PARTITION training4 VALUES LESS THAN(MAXVALUE)
);
ALTER TABLE training SPLIT PARTITION training3 AT(250) INTO (PARTITION p1, PARTITION p2) format csf;

-- 1 test db_tables adm_tables and my_tables
-- 2 my_tab_partitions db_tab_partitions and adm_tab_partitions
conn sys/Huawei@123@127.0.0.1:1611
drop table if exists test_view_col_row_format;
create table  test_view_col_row_format(part_key int) storage (maxsize 2M initial 1M)
partition by range (part_key) (
partition p1 values less than(1) storage (maxsize 2M initial 1M) pctfree 1 format csf,
partition p2 values less than(2) storage (maxsize 2M initial 1M) format csf,
partition p3 values less than(3) pctfree 1 format csf,
partition p4 values less than(4) storage (maxsize 2M initial 1M) pctfree 1
);

select row_format from my_tables where table_name = 'TEST_VIEW_COL_ROW_FORMAT';
select row_format from db_tables where table_name = 'TEST_VIEW_COL_ROW_FORMAT';
select row_format from adm_tables where table_name = 'TEST_VIEW_COL_ROW_FORMAT';
select PARTITION_NAME,row_format from my_tab_partitions  where table_name = 'TEST_VIEW_COL_ROW_FORMAT' order by PARTITION_NAME;
select PARTITION_NAME,row_format from db_tab_partitions  where table_name = 'TEST_VIEW_COL_ROW_FORMAT' order by PARTITION_NAME;
select PARTITION_NAME,row_format from adm_tab_partitions where table_name = 'TEST_VIEW_COL_ROW_FORMAT' order by PARTITION_NAME;

drop table if exists test_view_col_row_format;
create table  test_view_col_row_format(part_key int) storage (maxsize 2M initial 1M) format csf
partition by range (part_key) (
partition p1 values less than(1) storage (maxsize 2M initial 1M) pctfree 1 format csf,
partition p2 values less than(2) storage (maxsize 2M initial 1M) format csf,
partition p3 values less than(3) pctfree 1 format csf,
partition p4 values less than(4) storage (maxsize 2M initial 1M) pctfree 1
);

select row_format from my_tables where table_name = 'TEST_VIEW_COL_ROW_FORMAT';
select row_format from db_tables where table_name = 'TEST_VIEW_COL_ROW_FORMAT';
select row_format from adm_tables where table_name = 'TEST_VIEW_COL_ROW_FORMAT';
select PARTITION_NAME,row_format from my_tab_partitions  where table_name = 'TEST_VIEW_COL_ROW_FORMAT' order by PARTITION_NAME;
select PARTITION_NAME,row_format from db_tab_partitions  where table_name = 'TEST_VIEW_COL_ROW_FORMAT' order by PARTITION_NAME;
select PARTITION_NAME,row_format from adm_tab_partitions where table_name = 'TEST_VIEW_COL_ROW_FORMAT' order by PARTITION_NAME;


--DTS202101290LF234P1N00
drop table  if exists test1;
create table test1(id int) PARTITION BY list(id) 
(
partition p1 values (1) format csf ,
partition p2 values (2)
) APPENDONLY ON;
show create table test1;
drop table  if exists test1;
create table test1(id int) APPENDONLY ON;
show create table test1;

drop table if exists test_csf;
create table test_csf(id int, c_id number) format csf;
create unique index test_index_csf on test_csf(c_id);
insert into test_csf values(10, 0);
update test_csf set c_id = null;
select * from test_csf;
delete from test_csf;
drop table test_csf;

--syntax test
drop table if exists tbl_format_test;
create table tbl_format_test(a int, b int) format;
create table tbl_format_test(a int, b int) format hello;
create table tbl_format_test(a int, b int) format XXX YYY;
create table tbl_format_test(a int, b int) format asf;
drop table if exists tbl_format_test;
create table tbl_format_test(a int, b int) format csf;
drop table if exists tbl_format_test;

--support normal table csf format
--csf mode test case1
alter system set row_format = asf;
show parameters row_format;

drop table if exists tbl_format_test;
create table tbl_format_test(a int, b int) format csf;
select owner, table_name, ROW_FORMAT from ADM_TABLES where table_name = upper('tbl_format_test') order by table_name asc;

drop table if exists tbl_format_test;
create table tbl_format_test(a int, b int) format asf;
select owner, table_name, ROW_FORMAT from ADM_TABLES where table_name = upper('tbl_format_test') order by table_name asc;

drop table if exists tbl_format_test;
create table tbl_format_test(a int, b int);
select owner, table_name, ROW_FORMAT from ADM_TABLES where table_name = upper('tbl_format_test') order by table_name asc;

alter system set row_format = csf;
show parameters row_format;

drop table if exists tbl_format_test;
create table tbl_format_test(a int, b int) format csf;
select owner, table_name, ROW_FORMAT from ADM_TABLES where table_name = upper('tbl_format_test') order by table_name asc;

drop table if exists tbl_format_test;
create table tbl_format_test(a int, b int) format asf;
select owner, table_name, ROW_FORMAT from ADM_TABLES where table_name = upper('tbl_format_test') order by table_name asc;

drop table if exists tbl_format_test;
create table tbl_format_test(a int, b int);
select owner, table_name, ROW_FORMAT from ADM_TABLES where table_name = upper('tbl_format_test') order by table_name asc;

--support part csf format
--csf mode test case2
alter system set row_format = asf;
show parameters row_format;

drop table  if exists t_part_tbl_csf;
create table t_part_tbl_csf(id int, name varchar2(100)) PARTITION BY list(id)
(
partition p1 values (1) format csf,
partition p2 values (2),
partition p3 values (3) format csf
);
alter table t_part_tbl_csf add partition p6 values(4) format csf;
alter table t_part_tbl_csf add partition p7 values(5);
alter table t_part_tbl_csf add partition p8 values(6) format asf;
select TABLE_OWNER, PARTITION_NAME, ROW_FORMAT from ADM_TAB_PARTITIONS where table_name = upper('t_part_tbl_csf') order by PARTITION_NAME asc;

alter system set row_format = csf;
show parameters row_format;

drop table  if exists t_part_tbl_csf;
create table t_part_tbl_csf(id int, name varchar2(100)) PARTITION BY list(id)
(
partition p1 values (1) format csf,
partition p2 values (2),
partition p3 values (3) format csf
);
alter table t_part_tbl_csf add partition p6 values(4) format csf;
alter table t_part_tbl_csf add partition p7 values(5);
alter table t_part_tbl_csf add partition p8 values(6) format asf;
select TABLE_OWNER, PARTITION_NAME, ROW_FORMAT from ADM_TAB_PARTITIONS where table_name = upper('t_part_tbl_csf') order by PARTITION_NAME asc;

--csf mode test case3
alter system set row_format = asf;
show parameters row_format;

drop table  if exists t_part_tbl_csf;
create table t_part_tbl_csf(id int, name varchar2(100)) PARTITION BY range(id)
(
partition p1 VALUES LESS THAN (1) format csf,
partition p2 VALUES LESS THAN (2),
partition p3 VALUES LESS THAN (3) format csf
);
alter table t_part_tbl_csf add partition p6 VALUES LESS THAN(4) format csf;
alter table t_part_tbl_csf add partition p7 VALUES LESS THAN(5);
alter table t_part_tbl_csf add partition p8 VALUES LESS THAN(100) format asf;
select TABLE_OWNER, PARTITION_NAME, ROW_FORMAT from ADM_TAB_PARTITIONS where table_name = upper('t_part_tbl_csf') order by PARTITION_NAME asc;

alter system set row_format = csf;
show parameters row_format;

drop table  if exists t_part_tbl_csf;
create table t_part_tbl_csf(id int, name varchar2(100)) PARTITION BY range(id)
(
partition p1 VALUES LESS THAN (1) format csf,
partition p2 VALUES LESS THAN (2),
partition p3 VALUES LESS THAN (3) format csf
);
alter table t_part_tbl_csf add partition p6 VALUES LESS THAN(4) format csf;
alter table t_part_tbl_csf add partition p7 VALUES LESS THAN(5);
alter table t_part_tbl_csf add partition p8 VALUES LESS THAN(100) format asf;
select TABLE_OWNER, PARTITION_NAME, ROW_FORMAT from ADM_TAB_PARTITIONS where table_name = upper('t_part_tbl_csf') order by PARTITION_NAME asc;

--csf mode test case4
alter system set row_format = asf;
show parameters row_format;

drop table  if exists t_part_tbl_csf;
create table t_part_tbl_csf(id int, name varchar2(100)) PARTITION BY range(id) interval(1)
(
partition p1 VALUES LESS THAN (1) format csf,
partition p2 VALUES LESS THAN (2),
partition p3 VALUES LESS THAN (3) format csf,
partition p4 VALUES LESS THAN (4) format asf
);
alter table t_part_tbl_csf add partition p6 VALUES LESS THAN(5) format csf;
alter table t_part_tbl_csf add partition p7 VALUES LESS THAN(6);
select TABLE_OWNER, PARTITION_NAME, ROW_FORMAT from ADM_TAB_PARTITIONS where table_name = upper('t_part_tbl_csf') order by PARTITION_NAME asc;

alter system set row_format = csf;
show parameters row_format;

drop table  if exists t_part_tbl_csf;
create table t_part_tbl_csf(id int, name varchar2(100)) PARTITION BY range(id) interval(1)
(
partition p1 VALUES LESS THAN (1) format csf,
partition p2 VALUES LESS THAN (2),
partition p3 VALUES LESS THAN (3) format csf,
partition p4 VALUES LESS THAN (4) format asf
);
alter table t_part_tbl_csf add partition p6 VALUES LESS THAN(5) format csf;
alter table t_part_tbl_csf add partition p7 VALUES LESS THAN(6);
select TABLE_OWNER, PARTITION_NAME, ROW_FORMAT from ADM_TAB_PARTITIONS where table_name = upper('t_part_tbl_csf') order by PARTITION_NAME asc;

--csf mode test case5
alter system set row_format = asf;
show parameters row_format;

drop table  if exists t_part_tbl_csf;
create table t_part_tbl_csf(id int, name varchar2(100)) PARTITION BY hash(id)
(
partition p1 format csf,
partition p2,
partition p3 format csf,
partition p4 format asf,
partition p5 format asf
);
alter table t_part_tbl_csf add partition p6 format csf;
alter table t_part_tbl_csf add partition p7;
alter table t_part_tbl_csf add partition p8 format csf;
select TABLE_OWNER, PARTITION_NAME, ROW_FORMAT from ADM_TAB_PARTITIONS where table_name = upper('t_part_tbl_csf') order by PARTITION_NAME asc;

alter system set row_format = csf;
show parameters row_format;

drop table  if exists t_part_tbl_csf;
create table t_part_tbl_csf(id int, name varchar2(100)) PARTITION BY hash(id)
(
partition p1 format csf,
partition p2,
partition p3 format csf,
partition p4 format asf,
partition p5 format asf
);
alter table t_part_tbl_csf add partition p6 format csf;
alter table t_part_tbl_csf add partition p7;
alter table t_part_tbl_csf add partition p8 format csf;
select TABLE_OWNER, PARTITION_NAME, ROW_FORMAT from ADM_TAB_PARTITIONS where table_name = upper('t_part_tbl_csf') order by PARTITION_NAME asc;

--csf parameter test end
alter system set row_format = asf;
drop table  if exists t_part_tbl_csf;
drop table if exists tbl_format_test;

--DTS20210331075Q8KP0H00
alter system set row_format = csf;
drop table if exists sub_part_csf_test;
create table sub_part_csf_test(num int,c_id int,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_uint UINT not null,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_zero timestamp NOT NULL,c_start date NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2),c_credit_lim numeric,c_discount numeric(5,2),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(7744),c_data2 varchar(7744),c_data3 varchar(7744),c_data4 varchar(7744),c_data5 varchar(7744),c_data6 varchar(7744),c_data7 varchar(7744),c_data8 varchar(7744),c_clob clob,c_blob blob) PARTITION BY RANGE(C_ID) SUBPARTITION BY RANGE(C_W_ID) (PARTITION P1 VALUES LESS THAN(161)(SUBPARTITION P11 VALUES LESS THAN(3),SUBPARTITION P12 VALUES LESS THAN(5),SUBPARTITION P13 VALUES LESS THAN(7),SUBPARTITION P14 VALUES LESS THAN(9),SUBPARTITION P15 VALUES LESS THAN(11)),PARTITION P2 VALUES LESS THAN(321)(SUBPARTITION P21 VALUES LESS THAN(3),SUBPARTITION P22 VALUES LESS THAN(5),SUBPARTITION P23 VALUES LESS THAN(7),SUBPARTITION P24 VALUES LESS THAN(9),SUBPARTITION P25 VALUES LESS THAN(11)),PARTITION P3 VALUES LESS THAN(481)(SUBPARTITION P31 VALUES LESS THAN(3),SUBPARTITION P32 VALUES LESS THAN(5),SUBPARTITION P33 VALUES LESS THAN(7),SUBPARTITION P34 VALUES LESS THAN(9),SUBPARTITION P35 VALUES LESS THAN(11)),PARTITION P4 VALUES LESS THAN(641)(SUBPARTITION P41 VALUES LESS THAN(3),SUBPARTITION P42 VALUES LESS THAN(5),SUBPARTITION P43 VALUES LESS THAN(7),SUBPARTITION P44 VALUES LESS THAN(9),SUBPARTITION P45 VALUES LESS THAN(11)),PARTITION P5 VALUES LESS THAN(801)(SUBPARTITION P51 VALUES LESS THAN(3),SUBPARTITION P52 VALUES LESS THAN(5),SUBPARTITION P53 VALUES LESS THAN(7),SUBPARTITION P54 VALUES LESS THAN(9),SUBPARTITION P55 VALUES LESS THAN(11)));
show create table sub_part_csf_test;

select table_name, ROW_FORMAT from ADM_TABLES where table_name = upper('sub_part_csf_test') order by table_name asc;
drop table if exists sub_part_csf_test;
alter system set row_format = asf;

alter system set row_format = csf;
drop table if exists row_format_tbl_003;
create global temporary table row_format_tbl_003(c_id int);
select TABLE_NAME,row_format from ADM_TABLES where TABLE_NAME='ROW_FORMAT_TBL_003';
drop table if exists row_format_tbl_003;
alter system set row_format = asf;

--DTS2021040906OYRCP1L00
drop table if exists row_format_tbl_003;
create table row_format_tbl_003(num int,c_id number,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_uint UINT not null,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_zero timestamp NOT NULL,c_start date NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2),c_credit_lim numeric,c_discount numeric(5,2),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(7744),c_data2 varchar(7744),c_data3 varchar(7744),c_data4 varchar(7744),c_data5 varchar(7744),c_data6 varchar(7744),c_data7 varchar(7744),c_data8 varchar(7744),c_clob clob,c_blob blob) PARTITION BY RANGE(C_ID) INTERVAL(100) SUBPARTITION BY RANGE(C_DISCOUNT)(PARTITION P1 VALUES LESS THAN(201) storage(initial 64k maxsize 2g)(SUBPARTITION P11 VALUES LESS THAN(21),SUBPARTITION P12 VALUES LESS THAN(51),SUBPARTITION P13 VALUES LESS THAN(81)),PARTITION P2 VALUES LESS THAN(401) storage(initial 128k maxsize 2g) (SUBPARTITION P21 VALUES LESS THAN(21),SUBPARTITION P22 VALUES LESS THAN(51),SUBPARTITION P23 VALUES LESS THAN(81)),PARTITION P3 VALUES LESS THAN(601) storage(initial 96k maxsize 2g) (SUBPARTITION P31 VALUES LESS THAN(21),SUBPARTITION P32 VALUES LESS THAN(51),SUBPARTITION P33 VALUES LESS THAN(81)),PARTITION P4 VALUES LESS THAN(701) storage(initial 96k maxsize 2g) (SUBPARTITION P41 VALUES LESS THAN(21) ,SUBPARTITION P42 VALUES LESS THAN(51),SUBPARTITION P43 VALUES LESS THAN(MAXVALUE))) storage(initial 164k maxsize 10g) format asf ;
drop table if exists row_format_tbl_003;
create table row_format_tbl_003(num int,c_id number,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_uint UINT not null,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_zero timestamp NOT NULL,c_start date NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2),c_credit_lim numeric,c_discount numeric(5,2),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(7744),c_data2 varchar(7744),c_data3 varchar(7744),c_data4 varchar(7744),c_data5 varchar(7744),c_data6 varchar(7744),c_data7 varchar(7744),c_data8 varchar(7744),c_clob clob,c_blob blob) PARTITION BY RANGE(C_ID) INTERVAL(100) SUBPARTITION BY RANGE(C_DISCOUNT)(PARTITION P1 VALUES LESS THAN(201) storage(initial 64k maxsize 2g)(SUBPARTITION P11 VALUES LESS THAN(21),SUBPARTITION P12 VALUES LESS THAN(51),SUBPARTITION P13 VALUES LESS THAN(81)),PARTITION P2 VALUES LESS THAN(401) storage(initial 128k maxsize 2g) (SUBPARTITION P21 VALUES LESS THAN(21),SUBPARTITION P22 VALUES LESS THAN(51),SUBPARTITION P23 VALUES LESS THAN(81)),PARTITION P3 VALUES LESS THAN(601) storage(initial 96k maxsize 2g) (SUBPARTITION P31 VALUES LESS THAN(21),SUBPARTITION P32 VALUES LESS THAN(51),SUBPARTITION P33 VALUES LESS THAN(81)),PARTITION P4 VALUES LESS THAN(701) storage(initial 96k maxsize 2g) (SUBPARTITION P41 VALUES LESS THAN(21) ,SUBPARTITION P42 VALUES LESS THAN(51),SUBPARTITION P43 VALUES LESS THAN(MAXVALUE))) storage(initial 164k maxsize 10g) format csf ;
drop table if exists row_format_tbl_003;

drop table if exists row_format_tbl_003;
create global temporary table row_format_tbl_003(c_first varchar(4000),c_first_1 varchar(8000),c_first_2 varchar(8000),c_first_3 varchar(8000),c_first_4 varchar(8000),c_first_5 varchar(8000),c_first_6 varchar(8000),c_first_7 varchar(8000),c_first_8 varchar(4000)) format asf;
drop table if exists row_format_tbl_003;
create global temporary table row_format_tbl_003(c_first varchar(4000),c_first_1 varchar(8000),c_first_2 varchar(8000),c_first_3 varchar(8000),c_first_4 varchar(8000),c_first_5 varchar(8000),c_first_6 varchar(8000),c_first_7 varchar(8000),c_first_8 varchar(4000)) format csf;
drop table if exists row_format_tbl_003;

drop table if exists row_format_tbl_003;
create table row_format_tbl_003(num int,c_id number,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_uint UINT not null,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_zero timestamp NOT NULL,c_start date NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2),c_credit_lim numeric,c_discount numeric(5,2),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(7744),c_data2 varchar(7744),c_data3 varchar(7744),c_data4 varchar(7744),c_data5 varchar(7744),c_data6 varchar(7744),c_data7 varchar(7744),c_data8 varchar(7744),c_clob clob,c_blob blob) PARTITION BY RANGE(C_ID) INTERVAL(100) SUBPARTITION BY RANGE(C_DISCOUNT)(PARTITION P1 VALUES LESS THAN(201) storage(initial 64k maxsize 2g) format asf (SUBPARTITION P11 VALUES LESS THAN(21),SUBPARTITION P12 VALUES LESS THAN(51),SUBPARTITION P13 VALUES LESS THAN(81)),PARTITION P2 VALUES LESS THAN(401) storage(initial 128k maxsize 2g) format asf (SUBPARTITION P21 VALUES LESS THAN(21),SUBPARTITION P22 VALUES LESS THAN(51),SUBPARTITION P23 VALUES LESS THAN(81)),PARTITION P3 VALUES LESS THAN(601) storage(initial 96k maxsize 2g) format asf (SUBPARTITION P31 VALUES LESS THAN(21),SUBPARTITION P32 VALUES LESS THAN(51),SUBPARTITION P33 VALUES LESS THAN(81)),PARTITION P4 VALUES LESS THAN(701) storage(initial 96k maxsize 2g) format asf (SUBPARTITION P41 VALUES LESS THAN(21) ,SUBPARTITION P42 VALUES LESS THAN(51),SUBPARTITION P43 VALUES LESS THAN(MAXVALUE))) storage(initial 164k maxsize 10g) format asf ;
drop table if exists row_format_tbl_003;
create table row_format_tbl_003(num int,c_id number,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_uint UINT not null,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_zero timestamp NOT NULL,c_start date NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2),c_credit_lim numeric,c_discount numeric(5,2),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(7744),c_data2 varchar(7744),c_data3 varchar(7744),c_data4 varchar(7744),c_data5 varchar(7744),c_data6 varchar(7744),c_data7 varchar(7744),c_data8 varchar(7744),c_clob clob,c_blob blob) PARTITION BY RANGE(C_ID) INTERVAL(100) SUBPARTITION BY RANGE(C_DISCOUNT)(PARTITION P1 VALUES LESS THAN(201) storage(initial 64k maxsize 2g) format csf (SUBPARTITION P11 VALUES LESS THAN(21),SUBPARTITION P12 VALUES LESS THAN(51),SUBPARTITION P13 VALUES LESS THAN(81)),PARTITION P2 VALUES LESS THAN(401) storage(initial 128k maxsize 2g) format csf (SUBPARTITION P21 VALUES LESS THAN(21),SUBPARTITION P22 VALUES LESS THAN(51),SUBPARTITION P23 VALUES LESS THAN(81)),PARTITION P3 VALUES LESS THAN(601) storage(initial 96k maxsize 2g) format csf (SUBPARTITION P31 VALUES LESS THAN(21),SUBPARTITION P32 VALUES LESS THAN(51),SUBPARTITION P33 VALUES LESS THAN(81)),PARTITION P4 VALUES LESS THAN(701) storage(initial 96k maxsize 2g) format csf (SUBPARTITION P41 VALUES LESS THAN(21) ,SUBPARTITION P42 VALUES LESS THAN(51),SUBPARTITION P43 VALUES LESS THAN(MAXVALUE))) storage(initial 164k maxsize 10g) format asf ;
drop table if exists row_format_tbl_003;

--DTS202104260E3OOGP0I00
drop table if exists jdd_csf_test;
create table jdd_csf_test(c_d_id int)partition by list(c_d_id) (partition part_1 values (0,1),partition part_max values (default) format asf) format csf;
insert into jdd_csf_test values(0),(1),(2),(3);
select TABLE_NAME,PARTITION_NAME,ROW_FORMAT from ADM_TAB_PARTITIONS where TABLE_NAME=upper('jdd_csf_test') order by PARTITION_NAME asc;
select * from jdd_csf_test partition(part_1) order by C_D_ID asc;
select * from jdd_csf_test partition(part_max) order by C_D_ID asc;
update jdd_csf_test set c_d_id=3 where C_D_ID=0;
drop table if exists jdd_csf_test;

drop table if exists jdd_csf_test;
create table jdd_csf_test(c_d_id int)partition by list(c_d_id) (partition part_1 values (0,1),partition part_max values (default) format csf) format asf;
insert into jdd_csf_test values(0),(1),(2),(3);
select TABLE_NAME,PARTITION_NAME,ROW_FORMAT from ADM_TAB_PARTITIONS where TABLE_NAME=upper('jdd_csf_test') order by PARTITION_NAME asc;
select * from jdd_csf_test partition(part_1) order by C_D_ID asc;
select * from jdd_csf_test partition(part_max) order by C_D_ID asc;
update jdd_csf_test set c_d_id=3 where C_D_ID=0;
drop table if exists jdd_csf_test;

--DTS2021052607HHT8P0F00
--pre set data
drop table if exists csf_row_rowlink_shrink_000;
create table csf_row_rowlink_shrink_000( c_id integer,f_char1 varchar(7744), f_char2 varchar(7744), f_char3 varchar(7744), f_char4 varchar(7744), f_char5 varchar(7744), f_char6 varchar(7744), f_char7 varchar(7744), f_char8 varchar(7744), f_char9 varchar(7744), f_char10 varchar(7744),
f_char11 varchar(7744), f_char12 varchar(7744), f_char13 varchar(7744), f_char14 varchar(7744), f_char15 varchar(7744), f_char16 varchar(7744), f_char17 varchar(7744), f_char18 varchar(7744), f_char19 varchar(7744), f_char20 varchar(7744),
f_char21 varchar(7744), f_char22 varchar(7744), f_char23 varchar(7744), f_char24 varchar(7744), f_char25 varchar(7744), f_char26 varchar(7744), f_char27 varchar(7744), f_char28 varchar(7744), f_char29 varchar(7744), f_char30 varchar(7744),
f_char31 varchar(7744), f_char32 varchar(7744), f_char33 varchar(7744), f_char34 varchar(7744), f_char35 varchar(7744), f_char36 varchar(7744), f_char37 varchar(7744), f_char38 varchar(7744), f_char39 varchar(7744), f_char40 varchar(7744),
f_char41 varchar(7744), f_char42 varchar(7744), f_char43 varchar(7744), f_char44 varchar(7744), f_char45 varchar(7744), f_char46 varchar(7744), f_char47 varchar(7744), f_char48 varchar(7744), f_char49 varchar(7744), f_char50 varchar(7744),
f_char51 varchar(7744), f_char52 varchar(7744), f_char53 varchar(7744), f_char54 varchar(7744), f_char55 varchar(7744), f_char56 varchar(7744), f_char57 varchar(7744), f_char58 varchar(7744), f_char59 varchar(7744), f_char60 varchar(7744),
f_char61 varchar(7744), f_char62 varchar(7744), f_char63 varchar(7744), f_char64 varchar(7744), f_char65 varchar(7744), f_char66 varchar(7744), f_char67 varchar(7744), f_char68 varchar(7744), f_char69 varchar(7744), f_char70 varchar(7744),
f_char71 varchar(7744), f_char72 varchar(7744), f_char73 varchar(7744), f_char74 varchar(7744), f_char75 varchar(7744), f_char76 varchar(7744), f_char77 varchar(7744), f_char78 varchar(7744), f_char79 varchar(7744), f_char80 varchar(7744),
f_char81 varchar(7744), f_char82 varchar(7744), f_char83 varchar(7744), f_char84 varchar(7744), f_char85 varchar(7744), f_char86 varchar(7744), f_char87 varchar(7744), f_char88 varchar(7744), f_char89 varchar(7744), f_char90 varchar(7744),
f_char91 varchar(7744), f_char92 varchar(7744), f_char93 varchar(7744), f_char94 varchar(7744), f_char95 varchar(7744), f_char96 varchar(7744), f_char97 varchar(7744), f_char98 varchar(7744), f_char99 varchar(7744), f_char100 varchar(7744),
f_char101 varchar(7744), f_char102 varchar(7744), f_char103 varchar(7744), f_char104 varchar(7744), f_char105 varchar(7744), f_char106 varchar(7744), f_char107 varchar(7744), f_char108 varchar(7744), f_char109 varchar(7744), f_char110 varchar(7744),
f_char111 varchar(7744), f_char112 varchar(7744), f_char113 varchar(7744), f_char114 varchar(7744), f_char115 varchar(7744), f_char116 varchar(7744), f_char117 varchar(7744), f_char118 varchar(7744), f_char119 varchar(7744), f_char120 varchar(7744),
f_char121 varchar(7744), f_char122 varchar(7744), f_char123 varchar(7744), f_char124 varchar(7744), f_char125 varchar(7744), f_char126 varchar(7744), f_char127 varchar(7744), f_char128 varchar(7744), f_char129 varchar(7744), f_char130 varchar(7744),
f_char131 varchar(7744), f_char132 varchar(7744), f_char133 varchar(7744), f_char134 varchar(7744), f_char135 varchar(7744), f_char136 varchar(7744), f_char137 varchar(7744), f_char138 varchar(7744), f_char139 varchar(7744), f_char140 varchar(7744),
f_char141 varchar(7744), f_char142 varchar(7744), f_char143 varchar(7744), f_char144 varchar(7744), f_char145 varchar(7744), f_char146 varchar(7744), f_char147 varchar(7744), f_char148 varchar(7744), f_char149 varchar(7744), f_char150 varchar(7744),
f_char151 varchar(7744), f_char152 varchar(7744), f_char153 varchar(7744), f_char154 varchar(7744), f_char155 varchar(7744), f_char156 varchar(7744), f_char157 varchar(7744), f_char158 varchar(7744), f_char159 varchar(7744), f_char160 varchar(7744),
f_char161 varchar(7744), f_char162 varchar(7744), f_char163 varchar(7744), f_char164 varchar(7744), f_char165 varchar(7744), f_char166 varchar(7744), f_char167 varchar(7744), f_char168 varchar(7744), f_char169 varchar(7744), f_char170 varchar(7744),
f_char171 varchar(7744), f_char172 varchar(7744), f_char173 varchar(7744), f_char174 varchar(7744), f_char175 varchar(7744), f_char176 varchar(7744), f_char177 varchar(7744), f_char178 varchar(7744), f_char179 varchar(7744), f_char180 varchar(7744),
f_char181 varchar(7744), f_char182 varchar(7744), f_char183 varchar(7744), f_char184 varchar(7744), f_char185 varchar(7744), f_char186 varchar(7744), f_char187 varchar(7744), f_char188 varchar(7744), f_char189 varchar(7744), f_char190 varchar(7744),
f_char191 varchar(7744), f_char192 varchar(7744), f_char193 varchar(7744), f_char194 varchar(7744), f_char195 varchar(7744), f_char196 varchar(7744), f_char197 varchar(7744), f_char198 varchar(7744), f_char199 varchar(7744), f_char200 varchar(7744),
f_char201 varchar(7744), f_char202 varchar(7744), f_char203 varchar(7744), f_char204 varchar(7744), f_char205 varchar(7744), f_char206 varchar(7744), f_char207 varchar(7744), f_char208 varchar(7744), f_char209 varchar(7744), f_char210 varchar(7744),
f_char211 varchar(7744), f_char212 varchar(7744), f_char213 varchar(7744), f_char214 varchar(7744), f_char215 varchar(7744), f_char216 varchar(7744), f_char217 varchar(7744), f_char218 varchar(7744), f_char219 varchar(7744), f_char220 varchar(7744),
f_char221 varchar(7744), f_char222 varchar(7744), f_char223 varchar(7744), f_char224 varchar(7744), f_char225 varchar(7744), f_char226 varchar(7744), f_char227 varchar(7744), f_char228 varchar(7744), f_char229 varchar(7744), f_char230 varchar(7744),
f_char231 varchar(7744), f_char232 varchar(7744), f_char233 varchar(7744), f_char234 varchar(7744), f_char235 varchar(7744), f_char236 varchar(7744), f_char237 varchar(7744), f_char238 varchar(7744), f_char239 varchar(7744), f_char240 varchar(7744),
f_char241 varchar(7744), f_char242 varchar(7744), f_char243 varchar(7744), f_char244 varchar(7744), f_char245 varchar(7744), f_char246 varchar(7744), f_char247 varchar(7744), f_char248 varchar(7744), f_char249 varchar(7744), f_char250 varchar(7744),f_char251 varchar(7744), f_char252 varchar(7744), f_char253 varchar(7744), f_char254 varchar(7744), f_char255 varchar(7744), f_char256 varchar(7744), f_char257 varchar(7744), f_char258 varchar(7744), f_char259 varchar(7744), f_char260 varchar(7744)) format csf;

create or replace procedure csf_row_rowlink_shrink_pro_000 (startall int,endall int)  as
i int;
begin
    for i in startall..endall loop
        insert into csf_row_rowlink_shrink_000(c_id,f_char1,f_char2) values(i,lpad(i,5000,'char1'),lpad(i,5000,'char2'));commit;
    end loop;
end;
/

call csf_row_rowlink_shrink_pro_000(1,100);
commit;

--I1.create normal table
drop table if exists csf_row_rowlink_shrink_002;
create table csf_row_rowlink_shrink_002 format csf as select * from csf_row_rowlink_shrink_000;
--insert into csf_row_rowlink_shrink_002(c_id,f_char1,f_char2) select c_id,f_char1,f_char2 from csf_row_rowlink_shrink_000;
select count(*) from csf_row_rowlink_shrink_002;
commit;

--I2.update to let slice to be 239
declare
    i integer;
    j integer;
    sql_str varchar(4000);
    sql_str1 varchar(4000);
    sql_str_11 varchar(4200);
	  sql_str_22 varchar(20);
begin
    sql_str_11 := lpad('3',10,'test');
	  sql_str_22 := lpad('3',null,'test');
    for i in 3 .. 238
    loop
        sql_str := 'update csf_row_rowlink_shrink_002 set f_char'||i||' = '''||sql_str_11||'''';
        j := i-1;
        sql_str1 := 'update csf_row_rowlink_shrink_002 set f_char'||j||' = '''||sql_str_22||'''';
        execute immediate sql_str;
        execute immediate sql_str1;
    end loop;
    i := 239;
	  sql_str := 'update csf_row_rowlink_shrink_002 set f_char'||i||' = lpad('''||i||''', 4200, ''char'''''||i||''')';
    j := i-1;
    sql_str1 := 'update csf_row_rowlink_shrink_002 set f_char'||j||' = lpad('''||j||''', null, ''char'''''||j||''')';
    execute immediate sql_str;
    execute immediate sql_str1;
    commit;
end;
/

--I3.updateto let slice to over 240
create or replace procedure csf_row_rowlink_shrink_002_pro(cidnum int)
is
    rowidnum varchar(500);
    buffergetsnum varchar(4000);
    sqltextnum varchar(4000);
    rowlinkcursor sys_refcursor;
begin
    execute immediate 'select rowid from csf_row_rowlink_shrink_002 where c_id='||cidnum into rowidnum;
    sqltextnum :='select * from csf_row_rowlink_shrink_002 where rowid='''||rowidnum||'''';
    open rowlinkcursor for sqltextnum;
    dbe_sql.return_cursor(rowlinkcursor);
end;
/

create or replace procedure csf_row_rowlink_shrink_002_pro_1(cidnum int)
is
    rowidnum varchar(500);
    buffergetsnum varchar(4000);
begin
    execute immediate 'select rowid from csf_row_rowlink_shrink_002 where c_id='||cidnum into rowidnum;
    execute immediate 'select buffer_gets from dv_sqls where sql_text=''select * from csf_row_rowlink_shrink_002 where rowid='''''||rowidnum||'''''''' into buffergetsnum;
end;
/

update csf_row_rowlink_shrink_002 set f_char240=lpad('240',4200,'char240'),f_char241=lpad('241',4200,'char241'),f_char242=lpad('242',4200,'char242'),f_char243=lpad('243',4200,'char243'),f_char244=lpad('244',4200,'char244'),f_char245=lpad('245',4200,'char245'),f_char246=lpad('246',4200,'char246'),f_char247=lpad('247',4100,'char247'),f_char248=lpad('248',4100,'char248'),f_char249=lpad('249',4100,'char249'),f_char250=lpad('250',4100,'char250'),f_char251=lpad('251',4100,'char251'),f_char252=lpad('252',4100,'char252');
commit;

--finally, clear
drop procedure csf_row_rowlink_shrink_pro_000;
drop procedure csf_row_rowlink_shrink_002_pro;
drop procedure csf_row_rowlink_shrink_002_pro_1;
drop table csf_row_rowlink_shrink_000;
drop table csf_row_rowlink_shrink_002;

----AR.20210623195540.001
-------------------------------
--RANGE
-------------------------------
alter system set row_format = csf;
drop table if exists sub_part_csf_test;

create table sub_part_csf_test(num int, c_id int, c_w_id tinyint unsigned NOT NULL) 
PARTITION BY RANGE(C_ID) 
SUBPARTITION BY RANGE(C_W_ID) (
PARTITION P1 VALUES LESS THAN(161) format asf (SUBPARTITION P11 VALUES LESS THAN(3),SUBPARTITION P12 VALUES LESS THAN(5),SUBPARTITION P13 VALUES LESS THAN(7),SUBPARTITION P14 VALUES LESS THAN(9),SUBPARTITION P15 VALUES LESS THAN(11)),
PARTITION P2 VALUES LESS THAN(321)(SUBPARTITION P21 VALUES LESS THAN(3),SUBPARTITION P22 VALUES LESS THAN(5),SUBPARTITION P23 VALUES LESS THAN(7),SUBPARTITION P24 VALUES LESS THAN(9),SUBPARTITION P25 VALUES LESS THAN(11)),
PARTITION P3 VALUES LESS THAN(481) format asf (SUBPARTITION P31 VALUES LESS THAN(3),SUBPARTITION P32 VALUES LESS THAN(5),SUBPARTITION P33 VALUES LESS THAN(7),SUBPARTITION P34 VALUES LESS THAN(9),SUBPARTITION P35 VALUES LESS THAN(11)),
PARTITION P4 VALUES LESS THAN(641)(SUBPARTITION P41 VALUES LESS THAN(3),SUBPARTITION P42 VALUES LESS THAN(5),SUBPARTITION P43 VALUES LESS THAN(7),SUBPARTITION P44 VALUES LESS THAN(9),SUBPARTITION P45 VALUES LESS THAN(11)),
PARTITION P5 VALUES LESS THAN(801) format asf (SUBPARTITION P51 VALUES LESS THAN(3),SUBPARTITION P52 VALUES LESS THAN(5),SUBPARTITION P53 VALUES LESS THAN(7),SUBPARTITION P54 VALUES LESS THAN(9),SUBPARTITION P55 VALUES LESS THAN(11)));

show create table sub_part_csf_test;

insert into sub_part_csf_test values(1, 100, 3), (1, 160, 8), (1, 130, 10);
insert into sub_part_csf_test values(1, 140, 20);
insert into sub_part_csf_test values(2, 200, 3), (2, 250, 8), (2, 300, 10);
insert into sub_part_csf_test values(3, 390, 3), (3, 470, 8), (3, 480, 10);
insert into sub_part_csf_test values(4, 500, 3), (4, 600, 8), (4, 630, 10);
insert into sub_part_csf_test values(5, 700, 3), (5, 800, 8), (5, 750, 10);
commit;
select * from sub_part_csf_test order by c_id;

--delete 
ALTER TABLE sub_part_csf_test DROP PARTITION P1;
ALTER TABLE sub_part_csf_test DROP SUBPARTITION P31;
ALTER TABLE sub_part_csf_test DROP SUBPARTITION P42;
ALTER TABLE sub_part_csf_test DROP SUBPARTITION P55;
select * from sub_part_csf_test order by c_id;

--add partition
alter table sub_part_csf_test ADD PARTITION  P6 VALUES LESS THAN(888) (SUBPARTITION P61 VALUES LESS THAN(3),SUBPARTITION P62 VALUES LESS THAN(5),SUBPARTITION P63 VALUES LESS THAN(7),SUBPARTITION P64 VALUES LESS THAN(9),SUBPARTITION P65 VALUES LESS THAN(11));
insert into sub_part_csf_test values(6, 810, 3), (6, 850, 8), (6, 880, 10);
commit;
select * from sub_part_csf_test order by c_id;

--split
alter table sub_part_csf_test SPLIT PARTITION P6 AT(855) into (PARTITION P6_1, PARTITION P6_2) UPDATE GLOBAL INDEXES;
alter table sub_part_csf_test SPLIT SUBPARTITION P43 AT(4) into (SUBPARTITION P43_1, SUBPARTITION P43_2) UPDATE GLOBAL INDEXES;
alter table sub_part_csf_test SPLIT SUBPARTITION P23 AT(6) into (SUBPARTITION P23_1, SUBPARTITION P23_2) UPDATE GLOBAL INDEXES;

--truncate
ALTER TABLE sub_part_csf_test TRUNCATE PARTITION P4;
ALTER TABLE sub_part_csf_test TRUNCATE SUBPARTITION P21;
ALTER TABLE sub_part_csf_test TRUNCATE SUBPARTITION P23;
ALTER TABLE sub_part_csf_test TRUNCATE SUBPARTITION P25;
ALTER TABLE sub_part_csf_test TRUNCATE SUBPARTITION P65;
select * from sub_part_csf_test order by c_id;

select TABLE_NAME, COMPOSITE, PARTITION_NAME, SUBPARTITION_COUNT, ROW_FORMAT from ADM_TAB_PARTITIONS where TABLE_NAME = upper('sub_part_csf_test');

--check row format
select a.NAME, a.INITRANS, a.PCTFREE, DECODE(a.FLAGS & 8, 8, 'CSF', 'ASF') AS ROW_FORMAT from SYS_SUB_TABLE_PARTS a join MY_TABLES b on a.TABLE# = TABLE_ID where NAME like 'P2%' and b.TABLE_NAME = upper('sub_part_csf_test') order by a.NAME;
select a.NAME, a.INITRANS, a.PCTFREE, DECODE(a.FLAGS & 8, 8, 'CSF', 'ASF') AS ROW_FORMAT from SYS_SUB_TABLE_PARTS a join MY_TABLES b on a.TABLE# = TABLE_ID where NAME like 'P3%' and b.TABLE_NAME = upper('sub_part_csf_test') order by a.NAME;
select a.NAME, a.INITRANS, a.PCTFREE, DECODE(a.FLAGS & 8, 8, 'CSF', 'ASF') AS ROW_FORMAT from SYS_SUB_TABLE_PARTS a join MY_TABLES b on a.TABLE# = TABLE_ID where NAME like 'P4%' and b.TABLE_NAME = upper('sub_part_csf_test') order by a.NAME;
select a.NAME, a.INITRANS, a.PCTFREE, DECODE(a.FLAGS & 8, 8, 'CSF', 'ASF') AS ROW_FORMAT from SYS_SUB_TABLE_PARTS a join MY_TABLES b on a.TABLE# = TABLE_ID where NAME like 'P43%' and b.TABLE_NAME = upper('sub_part_csf_test') order by a.NAME;
select a.NAME, a.INITRANS, a.PCTFREE, DECODE(a.FLAGS & 8, 8, 'CSF', 'ASF') AS ROW_FORMAT from SYS_SUB_TABLE_PARTS a join MY_TABLES b on a.TABLE# = TABLE_ID where NAME like 'P5%' and b.TABLE_NAME = upper('sub_part_csf_test') order by a.NAME;
select a.NAME, a.INITRANS, a.PCTFREE, DECODE(a.FLAGS & 8, 8, 'CSF', 'ASF') AS ROW_FORMAT from SYS_SUB_TABLE_PARTS a join MY_TABLES b on a.TABLE# = TABLE_ID where NAME like 'P6%' and b.TABLE_NAME = upper('sub_part_csf_test') order by a.NAME;
select a.INITRANS, a.PCTFREE, DECODE(a.FLAGS & 8, 8, 'CSF', 'ASF') AS ROW_FORMAT from SYS_SUB_TABLE_PARTS a join MY_TABLES b on a.TABLE# = TABLE_ID where NAME like 'SYS%' and b.TABLE_NAME = upper('sub_part_csf_test') order by a.NAME;

select TABLE_NAME, PARENTPART_NAME, PARTITION_POSITION, ROW_FORMAT from DB_TAB_SUBPARTITIONS where TABLE_NAME = upper('sub_part_csf_test') order by PARENTPART_NAME, PARTITION_POSITION;
select TABLE_NAME, PARENTPART_NAME, PARTITION_POSITION, ROW_FORMAT from ADM_TAB_SUBPARTITIONS where TABLE_NAME = upper('sub_part_csf_test') order by PARENTPART_NAME, PARTITION_POSITION;
select TABLE_NAME, PARENTPART_NAME, PARTITION_POSITION, ROW_FORMAT from MY_TAB_SUBPARTITIONS where TABLE_NAME = upper('sub_part_csf_test') order by PARENTPART_NAME, PARTITION_POSITION;

drop table if exists sub_part_csf_test;

-------------------------------
--list
-------------------------------
alter system set row_format = asf;
show parameters row_format;

drop table  if exists t_part_tbl_csf;
create table t_part_tbl_csf(id int, col int) PARTITION BY list(id) SUBPARTITION BY list(col)
(
partition p1 values (1) format csf (SUBPARTITION P11 values (1), SUBPARTITION P12 values (2), SUBPARTITION P13 values (3,4,5,6)),
partition p2 values (2) (SUBPARTITION P21 values (1), SUBPARTITION P22 values (2), SUBPARTITION P23 values (3)),
partition p3 values (3) format csf (SUBPARTITION P31 values (1), SUBPARTITION P32 values (2), SUBPARTITION P33 values (3))
);
alter table t_part_tbl_csf add partition p6 values(4) format csf;
alter table t_part_tbl_csf add partition p7 values(5);
alter table t_part_tbl_csf add partition p8 values(6) format asf;
select TABLE_OWNER, PARTITION_NAME, ROW_FORMAT from ADM_TAB_PARTITIONS where table_name = upper('t_part_tbl_csf') order by PARTITION_NAME asc;
select TABLE_NAME, PARENTPART_NAME, PARTITION_POSITION, ROW_FORMAT from MY_TAB_SUBPARTITIONS where TABLE_NAME = upper('t_part_tbl_csf') order by PARENTPART_NAME, PARTITION_POSITION;

--update
insert into t_part_tbl_csf values(1,2);
commit;
update t_part_tbl_csf set id = 2 where id = 1;
update t_part_tbl_csf set id = 3 where id = 1;
drop table  if exists t_part_tbl_csf;

-------------------------------
--hash
-------------------------------
alter system set row_format = asf;
show parameters row_format;
drop table  if exists t_part_tbl_csf;
create table t_part_tbl_csf(id int, col int) PARTITION BY hash(id) SUBPARTITION BY hash(col)
(
partition p1 format csf (SUBPARTITION P11, SUBPARTITION P12, SUBPARTITION P13),
partition p2 (SUBPARTITION P21, SUBPARTITION P22, SUBPARTITION P23),
partition p3 format csf (SUBPARTITION P31, SUBPARTITION P32, SUBPARTITION P33),
partition p4 format asf (SUBPARTITION P41, SUBPARTITION P42, SUBPARTITION P43),
partition p5 format asf (SUBPARTITION P51, SUBPARTITION P52, SUBPARTITION P53)
);
alter table t_part_tbl_csf add partition p6 format csf;
alter table t_part_tbl_csf add partition p7;
alter table t_part_tbl_csf add partition p8 format csf;
select TABLE_OWNER, PARTITION_NAME, ROW_FORMAT from ADM_TAB_PARTITIONS where table_name = upper('t_part_tbl_csf') order by PARTITION_NAME asc;
select TABLE_NAME, PARENTPART_NAME, PARTITION_POSITION, ROW_FORMAT from MY_TAB_SUBPARTITIONS where TABLE_NAME = upper('t_part_tbl_csf') order by PARENTPART_NAME, PARTITION_POSITION;

drop table  if exists t_part_tbl_csf;

-------------------------------
--inertval
-------------------------------
alter system set row_format = asf;
show parameters row_format;
drop table  if exists t_part_tbl_csf;
create table t_part_tbl_csf(id int, col int) PARTITION BY range(id) interval(3) SUBPARTITION BY hash(col)
(
partition p1 VALUES LESS THAN (1) format csf (SUBPARTITION P11, SUBPARTITION P12, SUBPARTITION P13),
partition p2 VALUES LESS THAN (2) (SUBPARTITION P21, SUBPARTITION P22, SUBPARTITION P23),
partition p3 VALUES LESS THAN (3) format csf (SUBPARTITION P31, SUBPARTITION P32, SUBPARTITION P33),
partition p4 VALUES LESS THAN (4) format asf (SUBPARTITION P41, SUBPARTITION P42, SUBPARTITION P43)
);
alter table t_part_tbl_csf add partition p6 VALUES LESS THAN(5) format csf;
alter table t_part_tbl_csf add partition p7 VALUES LESS THAN(6);
show create table t_part_tbl_csf;
select TABLE_OWNER, PARTITION_NAME, ROW_FORMAT from ADM_TAB_PARTITIONS where table_name = upper('t_part_tbl_csf') order by PARTITION_NAME asc;
select TABLE_NAME, PARENTPART_NAME, PARTITION_POSITION, ROW_FORMAT from MY_TAB_SUBPARTITIONS where TABLE_NAME = upper('t_part_tbl_csf') order by PARENTPART_NAME, PARTITION_POSITION;

insert into t_part_tbl_csf values(2, 1000);
commit;
update t_part_tbl_csf set id = 1 where id = 2;
update t_part_tbl_csf set id = 3 where id = 2;
update t_part_tbl_csf set id = 0 where id = 2;
update t_part_tbl_csf set id = 100 where id = 0;

drop table  if exists t_part_tbl_csf;

-------------------------------
--hash partition coalesce operation
-------------------------------
alter system set row_format = asf;
show parameters row_format;
drop table  if exists t_part_tbl_csf;
create table t_part_tbl_csf(id int, col int) PARTITION BY hash(id) SUBPARTITION BY hash(col)
(
partition p1 format csf (SUBPARTITION P11, SUBPARTITION P12, SUBPARTITION P13, SUBPARTITION P14, SUBPARTITION P15),
partition p2 (SUBPARTITION P21, SUBPARTITION P22, SUBPARTITION P23, SUBPARTITION P24, SUBPARTITION P25)
);

alter table t_part_tbl_csf coalesce partition;
alter table t_part_tbl_csf modify partition p2 coalesce subpartition;

insert into t_part_tbl_csf values(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8,8);
commit;

select count(*) from t_part_tbl_csf partition(p1);
select count(*) from t_part_tbl_csf partition(p2);

alter table t_part_tbl_csf coalesce partition;
alter table t_part_tbl_csf modify partition p2 coalesce subpartition;
ALTER TABLE t_part_tbl_csf TRUNCATE PARTITION p2;
alter table t_part_tbl_csf coalesce partition;
alter table t_part_tbl_csf modify partition p2 coalesce subpartition;
alter table t_part_tbl_csf modify partition p2 coalesce subpartition;
alter table t_part_tbl_csf modify partition p2 coalesce subpartition;
drop table  if exists t_part_tbl_csf;
