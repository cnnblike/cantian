DROP USER IF EXISTS MOPRODUCTDB CASCADE;

CREATE USER MOPRODUCTDB IDENTIFIED BY Cantian_234;
GRANT DBA TO MOPRODUCTDB;
CONN MOPRODUCTDB/Cantian_234@127.0.0.1:1611

CREATE TABLE "MOPRODUCTDB_T_PRODUCT"
(
  "ID" VARCHAR(36 BYTE) NOT NULL,
  "SERVICE_TYPE" VARCHAR(32 BYTE) NOT NULL,
  "CREATE_VDC_ID" VARCHAR(64 BYTE),
  "CREATE_USER_ID" VARCHAR(64 BYTE),
  "ICON_ID" VARCHAR(36 BYTE),
  "CATALOG_ID" VARCHAR(36 BYTE),
  "REGION_ID" VARCHAR(128 BYTE) DEFAULT '',
  "PARAMS" CLOB,
  "SECRET_PARAMS" CLOB,
  "NAME" VARCHAR(8000 BYTE) NOT NULL,
  "DESCRIPTION" VARCHAR(8000 BYTE),
  "CREATE_TIME" DATE DEFAULT CURRENT_TIMESTAMP,
  "PUBLISH_STATUS" VARCHAR(32 BYTE) DEFAULT 'draft',
  "DELETABLE_STATUS" VARCHAR(32 BYTE) DEFAULT 'normal',
  "IS_DEFAULT" BINARY_INTEGER DEFAULT 0,
  "RESOURCE_POOL_ID" VARCHAR(128 BYTE) DEFAULT '',
  "PROJECT_ID" VARCHAR(128 BYTE) DEFAULT '',
  "AZ_ID" VARCHAR(128 BYTE) DEFAULT '',
  "EXTEND1" VARCHAR(128 BYTE),
  "EXTEND2" VARCHAR(128 BYTE),
  "EXTEND3" BINARY_INTEGER,
  "EXTEND4" BINARY_BIGINT,
  "PRODUCT_TYPE" VARCHAR(32 BYTE),
  PRIMARY KEY("ID")
);

load data infile "./sql/gs_exp_imp_T_PRODUCT.dat" 
into table MOPRODUCTDB_T_PRODUCT 
FIELDS ENCLOSED by '\v' 
FIELDS TERMINATED BY '\f' 
ROWS TERMINATED BY '\a';

-- copy MOPRODUCTDB_T_PRODUCT for check results
CREATE TABLE COPY_T_PRODUCT AS SELECT * FROM MOPRODUCTDB_T_PRODUCT;

select count(*), sum(length(id)), sum(lengthb(params)), sum(lengthb(PROJECT_ID)) from COPY_T_PRODUCT;
select max(CREATE_TIME), min(CREATE_TIME), sum(length(DELETABLE_STATUS)) from COPY_T_PRODUCT;

ALTER TABLE MOPRODUCTDB_T_PRODUCT ADD (ADD_COL1 INT);

\! rm -rf moproductdb_dir/
\! mkdir  moproductdb_dir

EXP TABLES=MOPRODUCTDB_T_PRODUCT FILETYPE=BIN file="./moproductdb_dir/add_col1.sql";

DROP TABLE IF EXISTS "MOPRODUCTDB_T_PRODUCT" CASCADE CONSTRAINTS;

IMPORT TABLES=MOPRODUCTDB_T_PRODUCT FILETYPE=BIN file="./moproductdb_dir/add_col1.sql";

select count(*), sum(length(id)), sum(lengthb(params)), sum(lengthb(PROJECT_ID)) from MOPRODUCTDB_T_PRODUCT;
select max(CREATE_TIME), min(CREATE_TIME), sum(length(DELETABLE_STATUS)), sum(ADD_COL1) from MOPRODUCTDB_T_PRODUCT;

ALTER TABLE MOPRODUCTDB_T_PRODUCT ADD (ADD_COL2 NUMBER default sin(0.3));

EXP TABLES=MOPRODUCTDB_T_PRODUCT FILETYPE=BIN file="./moproductdb_dir/add_col2.sql";
DROP TABLE IF EXISTS "MOPRODUCTDB_T_PRODUCT" CASCADE CONSTRAINTS;

IMPORT TABLES=MOPRODUCTDB_T_PRODUCT FILETYPE=BIN file="./moproductdb_dir/add_col2.sql";

select count(*), sum(length(id)), sum(lengthb(params)), sum(lengthb(PROJECT_ID)) from MOPRODUCTDB_T_PRODUCT;
select max(CREATE_TIME), min(CREATE_TIME), sum(length(DELETABLE_STATUS)), sum(ADD_COL1), sum(ADD_COL2) from MOPRODUCTDB_T_PRODUCT;
select ADD_COL1, ADD_COL2 from MOPRODUCTDB_T_PRODUCT limit 1;

alter table MOPRODUCTDB_T_PRODUCT drop DESCRIPTION;

desc MOPRODUCTDB_T_PRODUCT
EXP TABLES=MOPRODUCTDB_T_PRODUCT FILETYPE=BIN file="./moproductdb_dir/drop_desc.sql";
DROP TABLE IF EXISTS "MOPRODUCTDB_T_PRODUCT" CASCADE CONSTRAINTS;
IMPORT TABLES=MOPRODUCTDB_T_PRODUCT FILETYPE=BIN file="./moproductdb_dir/drop_desc.sql";

select count(*), sum(length(id)), sum(lengthb(params)), sum(lengthb(PROJECT_ID)) from MOPRODUCTDB_T_PRODUCT;
select max(CREATE_TIME), min(CREATE_TIME), sum(length(DELETABLE_STATUS)), sum(ADD_COL1), sum(ADD_COL2) from MOPRODUCTDB_T_PRODUCT;
select ADD_COL1, ADD_COL2 from MOPRODUCTDB_T_PRODUCT limit 1;

select sum(length(DESCRIPTION)) from MOPRODUCTDB_T_PRODUCT;

DROP TABLE IF EXISTS "MOPRODUCTDB_T_PRODUCT" CASCADE CONSTRAINTS;
CREATE TABLE MOPRODUCTDB_T_PRODUCT AS SELECT * FROM COPY_T_PRODUCT;

ALTER TABLE MOPRODUCTDB_T_PRODUCT ADD (ADD_COL1 INT);
ALTER TABLE MOPRODUCTDB_T_PRODUCT ADD (ADD_COL2 NUMBER default sin(0.3));

desc MOPRODUCTDB_T_PRODUCT
EXP TABLES=MOPRODUCTDB_T_PRODUCT FILETYPE=BIN file="./moproductdb_dir/add_two.sql";
DROP TABLE IF EXISTS "MOPRODUCTDB_T_PRODUCT" CASCADE CONSTRAINTS;
IMPORT TABLES=MOPRODUCTDB_T_PRODUCT FILETYPE=BIN file="./moproductdb_dir/add_two.sql";

select count(*), sum(length(id)), sum(lengthb(params)), sum(lengthb(PROJECT_ID)) from MOPRODUCTDB_T_PRODUCT;
select max(CREATE_TIME), min(CREATE_TIME), sum(length(DELETABLE_STATUS)), sum(ADD_COL1), sum(ADD_COL2) from MOPRODUCTDB_T_PRODUCT;
select ADD_COL1, ADD_COL2 from MOPRODUCTDB_T_PRODUCT limit 1;

DROP TABLE IF EXISTS "MOPRODUCTDB_T_PRODUCT" CASCADE CONSTRAINTS;
CREATE TABLE MOPRODUCTDB_T_PRODUCT AS SELECT * FROM COPY_T_PRODUCT;

ALTER TABLE MOPRODUCTDB_T_PRODUCT ADD (ADD_COL1 INT);
ALTER TABLE MOPRODUCTDB_T_PRODUCT ADD (ADD_COL2 NUMBER default sin(0.3));
alter table MOPRODUCTDB_T_PRODUCT drop DESCRIPTION;

desc MOPRODUCTDB_T_PRODUCT
EXP TABLES=MOPRODUCTDB_T_PRODUCT FILETYPE=BIN file="./moproductdb_dir/add_drop_desc.sql";
DROP TABLE IF EXISTS "MOPRODUCTDB_T_PRODUCT" CASCADE CONSTRAINTS;
IMPORT TABLES=MOPRODUCTDB_T_PRODUCT FILETYPE=BIN file="./moproductdb_dir/add_drop_desc.sql";

select count(*), sum(length(id)), sum(lengthb(params)), sum(lengthb(PROJECT_ID)) from MOPRODUCTDB_T_PRODUCT;
select max(CREATE_TIME), min(CREATE_TIME), sum(length(DELETABLE_STATUS)), sum(ADD_COL1), sum(ADD_COL2) from MOPRODUCTDB_T_PRODUCT;
select ADD_COL1, ADD_COL2 from MOPRODUCTDB_T_PRODUCT limit 1;

DROP TABLE IF EXISTS MOPRODUCTDB_T_PRODUCT_X CASCADE CONSTRAINTS;
CREATE TABLE MOPRODUCTDB_T_PRODUCT_X AS SELECT * FROM COPY_T_PRODUCT;
ALTER TABLE MOPRODUCTDB_T_PRODUCT_X ADD (ADD_LOB_COL1 CLOB, ADD_LOB_COL2 CLOB, ADD_LOB_COL3 CLOB);

EXP USERS=MOPRODUCTDB FILETYPE=BIN file="./moproductdb_dir/moproductdb_usr.sql";
DROP TABLE IF EXISTS "MOPRODUCTDB_T_PRODUCT" CASCADE CONSTRAINTS;
IMPORT TABLES=MOPRODUCTDB_T_PRODUCT FILETYPE=BIN file="./moproductdb_dir/add_drop_desc.sql";

desc MOPRODUCTDB_T_PRODUCT_X
select count(*), sum(length(id)), sum(lengthb(params)), sum(lengthb(PROJECT_ID)) from MOPRODUCTDB_T_PRODUCT_X;
select max(CREATE_TIME), min(CREATE_TIME), sum(length(DELETABLE_STATUS)) from MOPRODUCTDB_T_PRODUCT_X;
select ADD_LOB_COL1, ADD_LOB_COL2, ADD_LOB_COL3 from MOPRODUCTDB_T_PRODUCT_X limit 1;

DROP TABLE IF EXISTS "R_CTRL_OPERATION" CASCADE CONSTRAINTS;
CREATE TABLE "R_CTRL_OPERATION"
(
  "CTRL_ID" VARCHAR(64 CHAR) NOT NULL,
  "OPERATION_ID" VARCHAR(64 CHAR) NOT NULL,
  PRIMARY KEY("CTRL_ID", "OPERATION_ID")
);

insert into "R_CTRL_OPERATION" select hex(rownum||rownum||rownum), hex(exp(rownum)) from dual connect by rownum < 100;
commit;

EXP TABLES=R_CTRL_OPERATION FILETYPE=BIN file="./moproductdb_dir/unique_constraint_violated.sql";
IMPORT TABLES=R_CTRL_OPERATION FILETYPE=BIN file="./moproductdb_dir/unique_constraint_violated.sql";

select count(*), sum(length(CTRL_ID)), sum(length("OPERATION_ID")) from R_CTRL_OPERATION;

EXP TABLES=R_CTRL_OPERATION FILETYPE=BIN file="./moproductdb_dir/unique_constraint_violated_02.sql" PARALLEL = 3;
IMPORT TABLES=R_CTRL_OPERATION FILETYPE=BIN file="./moproductdb_dir/unique_constraint_violated_02.sql";

select count(*), sum(length(CTRL_ID)), sum(length("OPERATION_ID")) from R_CTRL_OPERATION;

drop table if exists "你好tb;drop ''table 101";
create table "你好tb;drop ''table 101" (id int, name varchar(100));
insert into "你好tb;drop ''table 101" values(1, 'X');
insert into "你好tb;drop ''table 101" values(2, 'x');
insert into "你好tb;drop ''table 101" select id + id, name || name from "你好tb;drop ''table 101";
insert into "你好tb;drop ''table 101" select id + id, name || name from "你好tb;drop ''table 101";
insert into "你好tb;drop ''table 101" select id + id, name || name from "你好tb;drop ''table 101";
SELECT * FROM "你好tb;drop ''table 101" order by id, name;
EXP TABLES="你好tb;drop ''table 101" FILE="./moproductdb_dir/sp_table101.dmp";

IMP TABLES="你好tb;drop ''table 101" FILE="./moproductdb_dir/sp_table101.dmp";
desc "你好tb;drop ''table 101"
SELECT * FROM "你好tb;drop ''table 101" order by id, name;

--DTS2019032306861
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists using_index_local;
create user using_index_local identified by Cantian_234;
grant dba to using_index_local;
conn using_index_local/Cantian_234@127.0.0.1:1611
drop table if exists T_TESTNODEB;
create table T_TESTNODEB(
    PlanID int,
    NodeBID int,
    ObjectID int default 0,
    PRIMARY KEY(PlanID, NodeBID) using index local
)
PARTITION BY RANGE(PlanID) INTERVAL(1) (PARTITION p_0 VALUES less than(1))
/
create sequence seq_TESTNODEB
/
create or replace trigger tr_TESTNODEB
    before insert
    on T_TESTNODEB
    for each row
    begin
        select seq_TESTNODEB.nextval into :new.ObjectID from dual;
    end;
/
create index idx_t_TestNodeB on t_TestNodeB(PlanID) local
/
select IS_PRIMARY,PARTITIONED from user_indexes where table_name = 'T_TESTNODEB' order by IS_PRIMARY;
exp FILETYPE=TXT CONTENT=ALL TABLES=T_TESTNODEB FILE="using_index_local_1.sql";
imp FILETYPE=TXT CONTENT=ALL TABLES=T_TESTNODEB FILE="using_index_local_1.sql";
select IS_PRIMARY,PARTITIONED from user_indexes where table_name = 'T_TESTNODEB' order by IS_PRIMARY;
exp FILETYPE=TXT CONTENT=ALL TABLES=T_TESTNODEB FILE="using_index_local_2.sql" CONSISTENT=Y;
imp FILETYPE=TXT CONTENT=ALL TABLES=T_TESTNODEB FILE="using_index_local_2.sql";
select IS_PRIMARY,PARTITIONED from user_indexes where table_name = 'T_TESTNODEB' order by IS_PRIMARY;
drop table T_TESTNODEB;

create table T_TESTNODEB(
    PlanID int,
    NodeBID int,
    ObjectID int default 0
) PARTITION BY RANGE(PlanID) INTERVAL(1) (PARTITION p_0 VALUES less than(1));
create index idx_t_TestNodeB on t_TestNodeB(PlanID) local;
ALTER TABLE T_TESTNODEB ADD CONSTRAINT PK#T_TESTNODEB PRIMARY KEY(PlanID, NodeBID) using index local;
select IS_PRIMARY,PARTITIONED from user_indexes where table_name = 'T_TESTNODEB' order by IS_PRIMARY;
exp FILETYPE=TXT CONTENT=ALL TABLES=T_TESTNODEB FILE="using_index_local_3.sql";
imp FILETYPE=TXT CONTENT=ALL TABLES=T_TESTNODEB FILE="using_index_local_3.sql";
select IS_PRIMARY,PARTITIONED from user_indexes where table_name = 'T_TESTNODEB' order by IS_PRIMARY;
exp FILETYPE=TXT CONTENT=ALL TABLES=T_TESTNODEB FILE="using_index_local_4.sql" CONSISTENT=Y;
imp FILETYPE=TXT CONTENT=ALL TABLES=T_TESTNODEB FILE="using_index_local_4.sql";
select IS_PRIMARY,PARTITIONED from user_indexes where table_name = 'T_TESTNODEB' order by IS_PRIMARY;
drop table T_TESTNODEB;

--nologging + trigger
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists u_nolog_trig;
create user u_nolog_trig identified by Cantian_234;
grant dba to u_nolog_trig;
conn u_nolog_trig/Cantian_234@127.0.0.1:1611
DROP TABLE IF EXISTS t_nolog_trig;
CREATE TABLE t_nolog_trig (F_INT1 INT, F_INT2 INT, F_CHAR1 CHAR(16), F_DATE DATE);
INSERT INTO t_nolog_trig VALUES(2,2,'A','2017-12-11 14:08:00');
CREATE OR REPLACE TRIGGER NOLOG_TRIG BEFORE INSERT ON t_nolog_trig
   FOR EACH ROW
   BEGIN
     UPDATE t_nolog_trig SET F_INT1 = 1;
   END;
   /
INSERT INTO t_nolog_trig VALUES(2,3,'A','2017-12-11 14:08:00');
SELECT * FROM t_nolog_trig ORDER BY F_INT2;
EXP TABLES=t_nolog_trig FILE="t_nolog_trig.sql";
IMP TABLES=t_nolog_trig FILE="t_nolog_trig.sql" NOLOGGING=Y;
SELECT * FROM t_nolog_trig ORDER BY F_INT2;

--DTS2019022112554
conn sys/Huawei@123@127.0.0.1:1611			
create role exp_role1;
create role exp_role2;
drop user if exists exp_lin_test1;
create user exp_lin_test1 IDENTIFIED by 'exp_user123';
grant create table to exp_role1;
grant create session to exp_role1;
grant create table to exp_role2;
grant create session to exp_role2;
grant dba to exp_lin_test1;
grant exp_role1 to exp_lin_test1;
grant exp_role2 to exp_lin_test1;
commit;

drop user if exists exp_lin_test2;
create user exp_lin_test2 IDENTIFIED by 'exp_user123';
grant create table to exp_role1;
grant create session to exp_role1;
grant create table to exp_role2;
grant create session to exp_role2;
grant dba to exp_lin_test2;
grant exp_role1 to exp_lin_test2;
grant exp_role2 to exp_lin_test2;
commit;

select count(*) from SYS_ROLES;
SELECT count(*) FROM ROLE_SYS_PRIVS;

exp users=exp_lin_test1,exp_lin_test2 create_user=Y grant=Y role=Y filetype = bin file="temp_bin.dmp";
drop USER if exists exp_lin_test1;
drop USER if exists exp_lin_test2;
drop role exp_role1;
drop role exp_role2;

imp users=exp_lin_test1,exp_lin_test2 create_user=Y filetype = bin file="temp_bin.dmp";
conn exp_lin_test1/exp_user123@127.0.0.1:1611
conn exp_lin_test2/exp_user123@127.0.0.1:1611
conn sys/Huawei@123@127.0.0.1:1611	
select count(*) from SYS_ROLES;
select count(*) from ROLE_SYS_PRIVS;
drop USER if exists exp_lin_test1;
drop USER if exists exp_lin_test2;
drop role exp_role1;
drop role exp_role2;

drop user if exists exp_lin_test1;
create user exp_lin_test1 IDENTIFIED by 'exp_user123';
grant dba to exp_lin_test1;
conn exp_lin_test1/exp_user123@127.0.0.1:1611
DROP TABLE IF EXISTS LIN_HASH1;
CREATE TABLE LIN_HASH1
(
  COL_NUMBER1 NUMBER,
  COL_TIMESTAMP2 TIMESTAMP(6)
);
CREATE INDEX LIN_INDEX_TEST1 ON LIN_HASH1(TO_CHAR(COL_TIMESTAMP2), UPPER(COL_NUMBER1));
CREATE INDEX LIN_INDEX_TEST2 ON LIN_HASH1(COL_TIMESTAMP2, UPPER(COL_NUMBER1), COL_NUMBER1);
CREATE INDEX LIN_INDEX_TEST3 ON LIN_HASH1(COL_TIMESTAMP2, COL_NUMBER1);
select * from all_indexES  where TABLE_NAME = 'LIN_HASH1' AND OWNER = 'EXP_LIN_TEST1' ORDER BY INDEX_NAME;
exp users=exp_lin_test1 file="func_index.dmp";
exp users=exp_lin_test1 QUOTE_NAMES = N file="func_index_quote.dmp";

DROP TABLE IF EXISTS LIN_HASH1;
imp users=exp_lin_test1 file="func_index.dmp";
select * from all_indexES  where TABLE_NAME = 'LIN_HASH1' AND OWNER = 'EXP_LIN_TEST1' ORDER BY INDEX_NAME;

DROP TABLE IF EXISTS LIN_HASH1;
imp users=exp_lin_test1 file="func_index_quote.dmp";
select * from all_indexES  where TABLE_NAME = 'LIN_HASH1' AND OWNER = 'EXP_LIN_TEST1' ORDER BY INDEX_NAME;

DROP TABLE IF EXISTS LIN_HASH1;
conn sys/Huawei@123@127.0.0.1:1611

--DTS2019032506534
conn sys/Huawei@123@127.0.0.1:1611
DROP USER IF EXISTS test_schema;
create user test_schema identified by Cantian_234;
DROP TABLE IF EXISTS curr_schema;
create table test_schema.curr_schema as select * from dual;
EXP USERS = test_schema FILE="test_schema.dmp" filetype = txt;
IMP USERS = test_schema FILE="test_schema.dmp" filetype = txt;
select USER_NAME,CURR_SCHEMA  from V$ME;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists tbl_trigger;
create user tbl_trigger identified by Cantian_234;
grant dba to tbl_trigger;
conn tbl_trigger/Cantian_234@127.0.0.1:1611
drop table if exists T_TESTNODEB;
create table T_TESTNODEB(
    PlanID int,
    NodeBID int,
    ObjectID int default 0,
    PRIMARY KEY(PlanID, NodeBID) using index local
)
PARTITION BY RANGE(PlanID) INTERVAL(1) (PARTITION p_0 VALUES less than(1));
 
create sequence seq_TESTNODEB;
 
create or replace trigger tr_TESTNODEB
    before insert
    on T_TESTNODEB
    for each row
    begin
        select seq_TESTNODEB.nextval into :new.ObjectID from dual;
    end;
/

create index idx_t_TestNodeB on t_TestNodeB(PlanID) local;

insert into T_TESTNODEB(PlanID, NodeBID) values(1,1);
insert into T_TESTNODEB(PlanID, NodeBID) values(2,1);
commit;

drop table if exists T_TEST2;
create table T_TEST2(
    PlanID int,
    NodeBID int,
    ObjectID int default 0,
    PRIMARY KEY(PlanID, NodeBID) using index local
)
PARTITION BY RANGE(PlanID) INTERVAL(1) (PARTITION p_0 VALUES less than(1));
 
create or replace trigger tr_TEST
    before insert
    on T_TEST2
    for each row
    begin
        select seq_TESTNODEB.nextval into :new.ObjectID from dual;
    end;
/

insert into T_TEST2(PlanID, NodeBID) values(1,1);
insert into T_TEST2(PlanID, NodeBID) values(2,1);
commit;

conn tbl_trigger/Cantian_234@127.0.0.1:1611
exp tables=T_TEST2 file="trigger_bin.dat" filetype=bin;
exp tables=T_TEST2 file="trigger_bin_p.dat" filetype=bin parallel=4;
exp tables=% file="all_trigger_bin.dat" filetype=bin;
exp tables=% file="all_trigger_bin_p.dat" filetype=bin parallel=4;

exp tables=T_TEST2 file="trigger_txt.dat" filetype=txt;
exp tables=T_TEST2 file="trigger_txt_p.dat" filetype=txt parallel=4;
exp tables=% file="all_trigger_txt.dat" filetype=txt;
exp tables=% file="all_trigger_txt_p.dat" filetype=txt parallel=4;

conn sys/Huawei@123@127.0.0.1:1611
exp users=tbl_trigger file="user_trigger_bin.dat" filetype=bin;
exp users=tbl_trigger file="user_trigger_txt.dat" filetype=txt;

conn tbl_trigger/Cantian_234@127.0.0.1:1611
drop trigger if exists tr_TESTNODEB;
drop trigger if exists tr_TEST;
imp tables=T_TEST2 file="trigger_bin.dat" filetype=bin;
select OWNER,TRIGGER_NAME,TABLE_OWNER,TABLE_OWNER from all_triggers where owner = 'TBL_TRIGGER';
drop trigger if exists tr_TESTNODEB;
drop trigger if exists tr_TEST;
imp tables=T_TEST2 file="trigger_bin_p.dat" filetype=bin parallel=4;
select OWNER,TRIGGER_NAME,TABLE_OWNER,TABLE_OWNER from all_triggers where owner = 'TBL_TRIGGER';
drop trigger if exists tr_TESTNODEB;
drop trigger if exists tr_TEST;
imp tables=% file="all_trigger_bin.dat" filetype=bin;
select OWNER,TRIGGER_NAME,TABLE_OWNER,TABLE_OWNER from all_triggers where owner = 'TBL_TRIGGER';
drop trigger if exists tr_TESTNODEB;
drop trigger if exists tr_TEST;
imp tables=% file="all_trigger_bin_p.dat" filetype=bin parallel=4;
select OWNER,TRIGGER_NAME,TABLE_OWNER,TABLE_OWNER from all_triggers where owner = 'TBL_TRIGGER';
drop trigger if exists tr_TESTNODEB;
drop trigger if exists tr_TEST;
imp tables=T_TEST2 file="trigger_txt.dat" filetype=txt;
select OWNER,TRIGGER_NAME,TABLE_OWNER,TABLE_OWNER from all_triggers where owner = 'TBL_TRIGGER';
drop trigger if exists tr_TESTNODEB;
drop trigger if exists tr_TEST;
imp tables=T_TEST2 file="trigger_txt_p.dat" filetype=txt parallel=4;
select OWNER,TRIGGER_NAME,TABLE_OWNER,TABLE_OWNER from all_triggers where owner = 'TBL_TRIGGER';
drop trigger if exists tr_TESTNODEB;
drop trigger if exists tr_TEST;
imp tables=% file="all_trigger_txt.dat" filetype=txt;
select OWNER,TRIGGER_NAME,TABLE_OWNER,TABLE_OWNER from all_triggers where owner = 'TBL_TRIGGER';
drop trigger if exists tr_TESTNODEB;
drop trigger if exists tr_TEST;
imp tables=% file="all_trigger_txt_p.dat" filetype=txt parallel=4;
select OWNER,TRIGGER_NAME,TABLE_OWNER,TABLE_OWNER from all_triggers where owner = 'TBL_TRIGGER';
drop trigger if exists tr_TESTNODEB;
drop trigger if exists tr_TEST;
imp tables=T_TEST2 file="all_trigger_txt.dat" filetype=txt;
select OWNER,TRIGGER_NAME,TABLE_OWNER,TABLE_OWNER from all_triggers where owner = 'TBL_TRIGGER';
drop trigger if exists tr_TESTNODEB;
drop trigger if exists tr_TEST;
imp tables=T_TEST2 file="all_trigger_bin.dat" filetype=bin;
select OWNER,TRIGGER_NAME,TABLE_OWNER,TABLE_OWNER from all_triggers where owner = 'TBL_TRIGGER';

drop trigger if exists tr_TESTNODEB;
drop trigger if exists tr_TEST;
conn tbl_trigger/Cantian_234@127.0.0.1:1611
imp tables=% file="user_trigger_bin.dat" filetype=bin;
select OWNER,TRIGGER_NAME,TABLE_OWNER,TABLE_OWNER from all_triggers where owner = 'TBL_TRIGGER';
drop trigger if exists tr_TESTNODEB;
drop trigger if exists tr_TEST;
imp tables=T_TEST2 file="user_trigger_txt.dat" filetype=txt;
select OWNER,TRIGGER_NAME,TABLE_OWNER,TABLE_OWNER from all_triggers where owner = 'TBL_TRIGGER';

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists verify_user;
create user verify_user IDENTIFIED by 'exp_user123';
grant dba to verify_user;
conn verify_user/exp_user123@127.0.0.1:1611
drop table if exists test_lin;
create table test_lin(f1 int, f2 int, f3 int);
exp tables=test_lin filetype=bin file = "verify_opts.dmp";
imp tables=test_lin filetype=bin file = "verify_opts_thread.dmp" parallel=33;
imp tables=test_lin filetype=bin file = "verify_opts_thread.dmp" ddl_parallel=0;
imp tables=t2 filetype=bin file = "verify_opts.dmp" BATCH_COUNT=10001;
drop table if exists test_lin;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists imp_manul;
create user imp_manul IDENTIFIED by 'exp_user123';
grant dba to imp_manul;
conn imp_manul/exp_user123@127.0.0.1:1611
imp users=imp_manul file="./data/imp_manul_append_data.bat";

conn sys/Huawei@123@127.0.0.1:1611
imp users=AUDITLOGDB filetype=bin ignore=y content=data_only create_user=y parallel=32 file="./data/compatible_data/spc100/compatible_bin_data_only/data_bin_single_user_01.dmp";

drop user if exists partition_table_exp;
create user partition_table_exp IDENTIFIED by 'exp_user123';
grant dba to partition_table_exp;
conn partition_table_exp/exp_user123@127.0.0.1:1611
CREATE TABLE TEST
(
PLANID BINARY_INTEGER NOT NULL AUTO_INCREMENT,
NODEBID BINARY_INTEGER NOT NULL,
PRIMARY KEY(PLANID, NODEBID)
)
PARTITION BY RANGE ("NODEBID")
INTERVAL(5)
(
PARTITION P_0 VALUES LESS THAN (5)  INITRANS 2 PCTFREE 8,
PARTITION P_1 VALUES LESS THAN (10)  INITRANS 2 PCTFREE 8
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;
INSERT INTO "TEST" ("PLANID","NODEBID") values(0,1);
INSERT INTO "TEST" ("PLANID","NODEBID") values(0,4);
INSERT INTO "TEST" ("PLANID","NODEBID") values(0,5);
INSERT INTO "TEST" ("PLANID","NODEBID") values(0,9);
INSERT INTO "TEST" ("PLANID","NODEBID") values(0,10);
commit;
select * from test order by NODEBID;
exp tables = test file = "./data/partition_table_exp_bin.dmp" filetype=bin parallel=5;
imp tables = test file = "./data/partition_table_exp_bin.dmp" filetype=bin parallel=5;
exp tables = test file = "./data/partition_table_exp_txt.dmp" filetype=txt parallel=5;
imp tables = test file = "./data/partition_table_exp_txt.dmp" filetype=txt parallel=5;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists import_verify_table;
create user import_verify_table IDENTIFIED by 'imp_user123';
grant dba to import_verify_table;
conn import_verify_table/imp_user123@127.0.0.1:1611
--DTS2019121603646
IMP TABLES=training233 FILETYPE=txt CONTENT=data_only PARALLEL=10 FILE="test1.sql";
conn sys/Huawei@123@127.0.0.1:1611

-- test metadata comment export & import
drop user if exists exp_imp_comment;
create user exp_imp_comment identified by Test_123456;
grant dba to exp_imp_comment;
conn exp_imp_comment/Test_123456@127.0.0.1:1611
create table ts(c int);
insert into ts values(1);
commit;
exp tables=ts file="./data/exp_imp_comment_txt.dmp" filetype=txt content=metadata_only;
exp tables=ts file="./data/exp_imp_comment_bin.dmp" filetype=bin content=metadata_only;
drop table ts;
imp tables=ts file="./data/exp_imp_comment_txt.dmp" filetype=txt content=metadata_only;
select * from ts;
drop table ts;
imp tables=ts file="./data/exp_imp_comment_bin.dmp" filetype=bin content=metadata_only;
select * from ts;
conn sys/Huawei@123@127.0.0.1:1611
drop user exp_imp_comment cascade;

-- test view dependent of different users
drop user if exists view_depend;
create user view_depend identified by Test_123456;
grant dba to view_depend;
conn view_depend/Test_123456@127.0.0.1:1611
create view v_trans as select * from sys.dv_transactions;
create view v_trans1 as select * from v_trans;
exp users=view_depend file="./data/view_depend.dmp";
imp users=view_depend file="./data/view_depend.dmp";
conn sys/Huawei@123@127.0.0.1:1611
drop user view_depend cascade;

-- DTS2020022730952
-- test independent role export
drop user if exists independ_role_exp;
create user independ_role_exp identified by Test_123456;
grant dba to independ_role_exp;
conn independ_role_exp/Test_123456@127.0.0.1:1611
create role role_independ_role_exp;
select count(1) from SYS.SYS_ROLES where name = upper('role_independ_role_exp');
exp users=independ_role_exp file="./data/independ_role_exp.dmp" role=Y;
drop role role_independ_role_exp;
imp users=independ_role_exp file="./data/independ_role_exp.dmp";
select count(1) from SYS.SYS_ROLES where name = upper('role_independ_role_exp');
conn sys/Huawei@123@127.0.0.1:1611
drop user independ_role_exp cascade;

-- test synonym export
drop user if exists synonym_export;
create user synonym_export identified by Test_123456;
grant dba to synonym_export;
conn synonym_export/Test_123456@127.0.0.1:1611
create table t1(c int);
insert into t1 values(10086);
create synonym st1 for t1;
select * from st1;
exp users=synonym_export file="./data/synonym_export_txt.dmp" filetype=txt;
drop synonym st1;
imp users=synonym_export file="./data/synonym_export_txt.dmp" filetype=txt;
select * from st1;
exp users=synonym_export file="./data/synonym_export_bin.dmp" filetype=bin;
drop synonym st1;
imp users=synonym_export file="./data/synonym_export_bin.dmp" filetype=bin;
select * from st1;
conn sys/Huawei@123@127.0.0.1:1611
drop user synonym_export cascade;

--- test profile export ---
CREATE or replace PROFILE test_profile LIMIT PASSWORD_GRACE_TIME 10 PASSWORD_LOCK_TIME DEFAULT PASSWORD_LIFE_TIME UNLIMITED;
drop user if exists profile_export CASCADE;
create user profile_export identified by Changeme_123 PROFILE test_profile;
grant dba to profile_export;
conn profile_export/Changeme_123@127.0.0.1:1611
CREATE PROFILE test_profile2 LIMIT PASSWORD_GRACE_TIME 11 PASSWORD_LOCK_TIME DEFAULT PASSWORD_LIFE_TIME UNLIMITED
/
CREATE or replace PROFILE test_profile2 LIMIT PASSWORD_GRACE_TIME 11 PASSWORD_LOCK_TIME DEFAULT PASSWORD_LIFE_TIME UNLIMITED
/
CREATE or replace PROFILE test_profile3 LIMIT PASSWORD_GRACE_TIME 12 PASSWORD_LOCK_TIME DEFAULT PASSWORD_LIFE_TIME UNLIMITED
/

exp users=profile_export file="./data/profile_export_txt.dmp" filetype = txt;
imp users=profile_export file="./data/profile_export_txt.dmp" filetype = txt;

DROP PROFILE test_profile CASCADE;
DROP PROFILE test_profile2 CASCADE;
DROP PROFILE test_profile3 CASCADE;
imp users=profile_export file="./data/profile_export_txt.dmp" filetype = txt;

exp users=profile_export file="./data/profile_export_bin.dmp" filetype = bin;
imp users=profile_export file="./data/profile_export_bin.dmp" filetype = bin;

conn sys/Huawei@123@127.0.0.1:1611
drop user profile_export cascade;
DROP PROFILE test_profile CASCADE;

--- test self_object export ---
drop user if exists self_export cascade;
create user self_export identified by Changeme_123;
grant dba to self_export;
conn self_export/Changeme_123@127.0.0.1:1611

---synonym---
DROP TABLE IF EXISTS test_synonym;
create table test_synonym (f1 int);
insert into test_synonym values (1);
commit;

DROP SYNONYM IF EXISTS synonym1;
CREATE OR REPLACE SYNONYM synonym1 for test_synonym
/

DROP TYPE if exists my_type_3;
DROP TYPE if exists my_type_2;
DROP TYPE if exists my_type_1;
DROP TYPE if exists my_type_4;
---type---
create or replace type my_type_1 is object (id number, name varchar2(64));
/
create or replace type my_type_2 is table of my_type_1;
/
create or replace type my_type_3 is table of my_type_2;
/
create or replace type my_type_4 is object (id number, name varchar2(64));
/

DROP TABLE IF EXISTS test_package;
create table test_package (f1 int);
insert into test_package values (1);
commit;

create or replace procedure test_alck(name varchar)
is
v1 int;
begin 
select get_lock(name) into v1 from test_package;
sleep(10);
select release_lock(name) into v1 from test_package;
-- a :=1;
end;
/

DROP PACKAGE IF EXISTS DD;
CREATE OR REPLACE PACKAGE DD
IS
FUNCTION MYF(v1 int ,v2 int) RETURN INT; 
PROCEDURE MYP;
END;
/

CREATE OR REPLACE PACKAGE BODY DD
IS
FUNCTION MYF(v1 int,v2 int) RETURN INT
is
a int :=10;
begin
return v1+v2;
end;
end;
/

DROP PACKAGE IF EXISTS PAK1;

CREATE OR REPLACE PACKAGE PAK1
IS
FUNCTION MYF1 RETURN INT;
PROCEDURE MYP1;
END;
/

CREATE OR REPLACE PACKAGE BODY PAK1
IS
FUNCTION MYF1 RETURN INT
IS
V1 INT := 10;
BEGIN
NULL;
RETURN V1;
END;
PROCEDURE MYP1 IS
V1 INT;
BEGIN
SELECT MYF1 INTO V1 FROM test_package;
DBE_OUTPUT.PRINT_LINE(V1);
END;
END;
/

DROP PACKAGE IF EXISTS PAK2;

CREATE OR REPLACE PACKAGE PAK2
IS
FUNCTION MYF2 RETURN INT;
PROCEDURE MYP2;
END;
/

CREATE OR REPLACE PACKAGE BODY PAK2
IS
FUNCTION MYF2 RETURN INT
IS
V1 INT := 20;
BEGIN
NULL;
RETURN V1;
END;
PROCEDURE MYP2 IS
V1 INT;
BEGIN
SELECT PAK1.MYF1 INTO V1 FROM test_package;
DBE_OUTPUT.PRINT_LINE(V1);
END;
END;
/

DROP PACKAGE IF EXISTS PAK3;

CREATE OR REPLACE PACKAGE PAK3
IS
FUNCTION MYF3 RETURN INT;
PROCEDURE MYP3;
END;
/

CREATE OR REPLACE PACKAGE BODY PAK3
IS
FUNCTION MYF3 RETURN INT
IS
V1 INT := 20;
BEGIN
NULL;
RETURN V1;
END;
PROCEDURE MYP3 IS
V1 INT;
BEGIN
SELECT PAK2.MYF2 INTO V1 FROM test_package;
DBE_OUTPUT.PRINT_LINE(V1);
END;
END;
/


CREATE OR REPLACE PROCEDURE "TEST_ALCK"
(name varchar)
is
v1 int;
begin 
select get_lock(name) into v1 from test_package;
sleep(10);
select release_lock(name) into v1 from test_package;
-- a :=1;
end;
/

exp users=self_export file="./data/self_export_txt.dmp" filetype = txt;
imp users=self_export file="./data/self_export_txt.dmp" filetype = txt;

exp users=self_export file="./data/self_export_bin.dmp" filetype = bin;
imp users=self_export file="./data/self_export_bin.dmp" filetype = bin;

DROP TYPE if exists table_test;
CREATE OR REPLACE TYPE table_test IS TABLE OF VARCHAR(10);
/

DECLARE
        v1 table_test;
BEGIN
        v1 := table_test('ABC', 'def');
        DBE_OUTPUT.PRINT_LINE(v1(1));
        DBE_OUTPUT.PRINT_LINE(v1(2));
END;
/

exp users=self_export filetype=bin file='./data/type_export_bin.dmp';
drop type table_test;
imp users=self_export filetype=bin file='./data/type_export_bin.dmp';

conn sys/Huawei@123@127.0.0.1:1611
drop user self_export cascade;

drop user if exists compatible_export1 cascade;
create user compatible_export1 identified by Test_123456;
grant dba to compatible_export1;

drop user if exists compatible_export2 cascade;
create user compatible_export2 identified by Test_123456;
grant dba to compatible_export2;

conn compatible_export1/Test_123456@127.0.0.1:1611
imp users=compatible_export1 file="./data/compatible_data/master_1.0.5/compatible_export_bin.dmp" filetype=bin parallel = 4;
select count(*) from compatible_export1.compatible_synonym1;

conn sys/Huawei@123@127.0.0.1:1611
imp users=% file="./data/compatible_data/master_1.0.5/compatible_export_bin.dmp" filetype=bin parallel = 4;
select count(*) from compatible_export1.compatible_synonym1;
select count(*) from compatible_export2.compatible_synonym2;

drop user compatible_export1 cascade;
drop user compatible_export2 cascade;

conn sys/Huawei@123@127.0.0.1:1611
create tablespace ts_for_exp DATAFILE 'ts_for_exp.dbf' size 32M;
drop user if exists root_user cascade;
create user root_user identified by Test_123456;
grant dba to root_user;
drop tenant if exists tnt1 cascade;
create tenant tnt1 tablespaces(users, ts_for_exp);
alter session set tenant=tnt1;
create user tnt1_user1 identified by Test_123456;
grant dba to tnt1_user1;
conn tnt1_user1/Test_123456@127.0.0.1:1611/tnt1
exp users=tnt1$tnt1_user1 filetype=txt file='./data/user_in_tenant_export_bin.dmp' create_user=y grant=y;
imp filetype=txt file='./data/user_in_tenant_export_bin.dmp' create_user=y;
conn root_user/Test_123456@127.0.0.1:1611
exp users=tnt1$tnt1_user1 filetype=txt file='./data/user_in_tenant_export_bin.dmp' create_user=y grant=y;
exp users=tnt1$tnt1_user1 filetype=txt file='./data/user_in_tenant_export_bin1.dmp' create_user=y grant=y tenant=y;
drop tenant if exists tnt1 cascade;
imp filetype=txt file='./data/user_in_tenant_export_bin.dmp' create_user=y;
SHOW TENANT_ID
SHOW TENANT_NAME
create tenant tnt1 tablespaces(users);
imp filetype=txt file='./data/user_in_tenant_export_bin.dmp' create_user=y;
conn tnt1_user1/Test_123456@127.0.0.1:1611/tnt1
conn root_user/Test_123456@127.0.0.1:1611
drop tenant if exists tnt1 cascade;
imp filetype=txt file='./data/user_in_tenant_export_bin1.dmp' create_user=y;
SHOW TENANT_ID
SHOW TENANT_NAME
conn tnt1_user1/Test_123456@127.0.0.1:1611/tnt1
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists root_user cascade;
drop tenant if exists tnt1 cascade;
drop tablespace ts_for_exp;

CREATE or replace PROFILE test_profile_exp LIMIT PASSWORD_GRACE_TIME 10 PASSWORD_LOCK_TIME DEFAULT PASSWORD_LIFE_TIME UNLIMITED;
drop user if exists profile_exp_per CASCADE;
create user profile_exp_per identified by Changeme_123 PROFILE test_profile_exp;
grant create session to profile_exp_per;
exp users=profile_exp_per file="test_privileage.dmp";
DROP PROFILE test_profile_exp CASCADE;
conn profile_exp_per/Changeme_123@127.0.0.1:1611
imp users=profile_exp_per file="test_privileage.dmp";
conn sys/Huawei@123@127.0.0.1:1611
drop user profile_exp_per cascade;
DROP PROFILE test_profile_exp CASCADE;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists usdpdbc01 cascade;
drop user if exists usdpdb cascade;
create user usdpdbc01 identified by Changeme_123;
GRANT CREATE VIEW TO usdpdbc01;
GRANT SELECT ANY TABLE TO usdpdbc01;
GRANT UNLIMITED TABLESPACE TO usdpdbc01;
GRANT CONNECT TO usdpdbc01;
GRANT RESOURCE TO usdpdbc01;
exp users=usdpdbc01 file="wyj.txt" filetype=bin create_user=y grant=y;
drop user if exists usdpdbc01 cascade;
create user usdpdb identified by Changeme_123;
grant dba to usdpdb;
conn usdpdb/Changeme_123@127.0.0.1:1611
imp remap_schema=usdpdbc01:usdpdb log="daochulog.txt" create_user = y filetype=bin file="wyj.txt";

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT cascade;
create user MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT identified by Changeme_123;
grant dba to MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT;
conn MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT/Changeme_123@127.0.0.1:1611
DROP TABLE IF EXISTS MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT;
create table MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT(f1 int, f2 varchar(100));
insert into MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT values(1,'test');
insert into MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT values(2,'test');
commit;

exp tables=MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT filetype=txt file = "tablename_64_txt.sql" parallel=4;
exp tables=MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT filetype=bin file = "tablename_64_bin.sql" parallel=4;

DROP TABLE IF EXISTS MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT;
imp tables=MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT filetype=txt file = "tablename_64_txt.sql" parallel=4;
select count(*) from MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT;

DROP TABLE IF EXISTS MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT;
imp tables=MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT filetype=bin file = "tablename_64_bin.sql" parallel=4;
select count(*) from MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT;

exp tables=MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT filetype=txt file = "tablename_exceed64_00000_00000_00000_00000_00000_00000_00000_000" parallel=4;
exp tables=MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT filetype=txt file = "tablename_exceed64_00000_00000_00000_00000_00000_00000_00000_000.sql" parallel=4;
DROP TABLE IF EXISTS MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT;
imp tables=MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT filetype=txt file = "tablename_exceed64_00000_00000_00000_00000_00000_00000_00000_000" parallel=4;
select count(*) from MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT;
imp tables=MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT filetype=txt file = "tablename_exceed64_00000_00000_00000_00000_00000_00000_00000_000.sql" parallel=4;
select count(*) from MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT;

drop table if exists MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN1;
drop table if exists MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN2;
create table MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN1 (c int);
alter table MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN1 add constraint t1_pkk primary key(c);
insert into MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN1 values(1),(2),(10);
commit;
exp tables=MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN1 remap_tables=MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN1:MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN2 filetype=bin file="exp_remap_tables.dmp";
drop table if exists MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN1;
drop table if exists MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN2;
imp tables=MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN2 filetype=bin file="exp_remap_tables.dmp";
select count(*) from MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN2;

DROP SYNONYM IF EXISTS MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_synomy1;
drop table if exists MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN3;
create table MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN3 (c int);
insert into MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN3 values(1),(2),(10);
commit;
CREATE OR REPLACE SYNONYM MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_synomy1 for MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN3
/
select count(*) from MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_synomy1;

CREATE OR REPLACE PROCEDURE MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_procedu(param1 out varchar2)
IS
    tmp varchar2(20) :='12345678';
begin
    dbe_output.print_line('OUT PUT RESULT:'||param1);
end MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_procedu;
/

DROP TABLE IF EXISTS MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_trigger;
CREATE TABLE MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_trigger (F_INT1 INT, F_INT2 INT, F_CHAR1 CHAR(16), F_DATE DATE);
INSERT INTO MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_trigger VALUES(2,2,'A','2017-12-11 14:08:00');
commit;
CREATE OR REPLACE TRIGGER MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_trigger BEFORE INSERT ON MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_trigger
FOR EACH ROW
BEGIN
    UPDATE MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_trigger SET F_INT1 = 1;
END;
/

DROP TABLE IF EXISTS MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_lobname;
CREATE TABLE MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_lobname (F_INT1 INT, MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_lobnam1 CLOB, MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_lobnam2 BLOB);
insert into MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_lobname values(1, 'sadfasfsadfsdfasfa', '1010010001001');
commit;
exp users=MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT file="maxlen_user.dmp" filetype=bin parallel=4;
drop table if exists MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN1;
drop table if exists MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN2;
DROP SYNONYM IF EXISTS MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_synomy1;
imp users=MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT file="maxlen_user.dmp" filetype=bin parallel=4;
select count(*) from MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_lobname;
select count(*) from MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_synomy1;
select count(*) from MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTEN2;
select count(*) from MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists MO_NE_471_STATUSABTEST_STATRESULT_SGSVLRLNK_C426B29786F9_CONTENT cascade;

drop user if exists test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_001 cascade;
create user test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_001 identified by Test_123456;
grant dba to test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_001;
conn test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_001/Test_123456@127.0.0.1:1611
create table ts1 (c int);
insert into ts1 values(1),(2);
commit;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_002 cascade;
create user test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_002 identified by Test_123456;
grant dba to test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_002;
conn test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_002/Test_123456@127.0.0.1:1611
create table ts2 (c int);
insert into ts2 values(3),(4);
commit;

conn sys/Huawei@123@127.0.0.1:1611
exp users=test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_001,test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_002 file="test_schema_remap64.dmp" filetype=bin;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_003 cascade;
create user test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_003 identified by Test_123456;
grant dba to test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_003;
imp file="test_schema_remap64.dmp" filetype=bin remap_schema=test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_001:test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_003;
select count(*) from test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_001.ts1;
select count(*) from test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_003.ts1;
select count(*) from test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_002.ts2;
drop user if exists test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_001 cascade;
drop user if exists test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_002 cascade;
drop user if exists test_remap_user_exceed64_00000_00000_00000_00000_00000_00000_003 cascade;

create tablespace tablespace_exceed64_00000_00000_00000_00000_00000_00000_00000_01 datafile 'tablespace_exceed64_00000_00000_00000_00000_00000_00000_00000_01' size 16m autoextend on next 16m;
create tablespace tablespace_exceed64_00000_00000_00000_00000_00000_00000_00000_02 datafile 'tablespace_exceed64_00000_00000_00000_00000_00000_00000_00000_02' size 16m autoextend on next 16m; 
drop user if exists test_remap cascade;
create user test_remap identified by Test_123456;
grant dba to test_remap;
conn test_remap/Test_123456@127.0.0.1:1611
create table ts1 (c int) tablespace tablespace_exceed64_00000_00000_00000_00000_00000_00000_00000_01;
insert into ts1 values(1),(2);
commit;
create table ts2 (c int) tablespace tablespace_exceed64_00000_00000_00000_00000_00000_00000_00000_01;
insert into ts2 values(3),(4);
commit;
create table ts3 (c int) tablespace tablespace_exceed64_00000_00000_00000_00000_00000_00000_00000_01;
insert into ts3 values(5),(6);
commit;

conn sys/Huawei@123@127.0.0.1:1611
exp users=test_remap file="test_remap64_tablespace.dmp" filetype=bin;
conn test_remap/Test_123456@127.0.0.1:1611
drop table ts1;
drop table ts2;
drop table ts3;
drop tablespace tablespace_exceed64_00000_00000_00000_00000_00000_00000_00000_01 including contents and datafiles;

conn test_remap/Test_123456@127.0.0.1:1611
imp tables=ts1,ts3 file="test_remap64_tablespace.dmp" filetype=bin REMAP_TABLESPACE=TABLESPACE_EXCEED64_00000_00000_00000_00000_00000_00000_00000_01:TABLESPACE_EXCEED64_00000_00000_00000_00000_00000_00000_00000_02;
select count(*) from ts1;
select count(*) from ts3;

conn sys/Huawei@123@127.0.0.1:1611
select TABLE_NAME,TABLESPACE_NAME from db_tables where OWNER = UPPER('test_remap') order by TABLE_NAME;
drop user test_remap cascade;
drop tablespace tablespace_exceed64_00000_00000_00000_00000_00000_00000_00000_02 including contents and datafiles;

-- DTS202105120JB1F7P0G00
drop user if exists cmbtest cascade;
create user cmbtest identified by Changeme_123;
grant dba to cmbtest;
conn cmbtest/Changeme_123@127.0.0.1:1611

drop table if exists tbl_interval;
create table tbl_interval(
col_int int AUTO_INCREMENT ,
col_integer integer,
col_BINARY_INTEGER BINARY_INTEGER,
col_smallint smallint not null default '7',
col_bigint bigint not null default '3',
col_BINARY_BIGINT BINARY_BIGINT,
col_real real,
col_double double comment 'double',
col_float float,
col_BINARY_DOUBLE BINARY_DOUBLE,
col_decimal decimal,
col_number1 number,
col_number2 number(38),
col_number3 number(38,-84),
col_number4 number(38,127),
col_number5 number(38,7),
col_numeric numeric,
col_char1 char(1000),
col_char2 char(8000),
col_nchar1 nchar(3000),
col_nchar2 nchar(8000),
col_varchar_200 varchar(200),
col_varchar_8000 varchar(8000) not null default 'abcd',
col_varchar2_1000 varchar2(1000),
col_varchar2_8000 varchar2(8000),
col_nvarchar1 nvarchar(1000),
col_nvarchar2 nvarchar(8000),
col_nvarchar2_1000 nvarchar2(1000),
col_nvarchar2_8000 nvarchar2(8000),
col_clob clob,
col_text text,
col_longtext longtext not null,
col_image image,
col_binary1 binary(2000),
col_binary2 binary(8000),
col_varbinary1 varbinary(1000),
col_varbinary2 varbinary(8000) not null,
col_raw1 raw(1000),
col_raw2 raw(8000),
col_blob blob,
col_date date not null default to_date('2018-06-01','yyyy-mm-dd'),
col_datetime datetime default '2018-01-07 08:08:08',
col_timestamp1 timestamp default to_timestamp('2018-01-07 08:08:08', 'YYYY-MM-DD HH24:MI:SS:FF'),
col_timestamp2 timestamp(6),
col_timestamp3 TIMESTAMP WITH TIME ZONE,
col_timestamp4 TIMESTAMP WITH LOCAL TIME ZONE,
col_bool bool,
col_boolean boolean,
col_interval1 INTERVAL YEAR TO MONTH,
col_interval2 INTERVAL DAY TO SECOND,
primary key(col_int,col_bigint)
);
--增加唯一约束
alter table tbl_interval add constraint cos_interval_uk1 unique(col_nvarchar1,col_raw1);
--函数索引目前支持to_char、upper
create index idx_tbl_interval_fun_01 on tbl_interval(to_char(col_BINARY_BIGINT) asc,upper(col_int) desc);
create index idx_tbl_interval_fun_02 on tbl_interval(to_char(col_interval2) asc,upper(col_timestamp4) desc);
--动态扩展interval
drop table if exists T_TESTNODEB;
CREATE TABLE "T_TESTNODEB"
(
"PLANID" BINARY_INTEGER NOT NULL,
"NODEBID" BINARY_INTEGER NOT NULL,
PRIMARY KEY("PLANID", "NODEBID")
);
INSERT INTO "T_TESTNODEB" ("PLANID","NODEBID") values
(1,1);
INSERT INTO "T_TESTNODEB" ("PLANID","NODEBID") values
(2,1);
INSERT INTO "T_TESTNODEB" ("PLANID","NODEBID") values
(4,1);
INSERT INTO "T_TESTNODEB" ("PLANID","NODEBID") values
(5,1);
COMMIT;
CREATE INDEX "IDX_T_TESTNODEB2" ON "T_TESTNODEB"("NODEBID")
TABLESPACE "CMEDB"
INITRANS 2
PCTFREE 8;

conn sys/Huawei@123@127.0.0.1:1611

exp users=cmbtest file="exp_alter_bin.dmp" parallel=4 insert_batch=8 COMMIT_BATCH=1000 filetype=bin;
imp users=cmbtest FILE="exp_alter_bin.dmp" log="exp_alter_bin.log" parallel=1 BATCH_COUNT=1 filetype=bin;
imp users=cmbtest FILE="exp_alter_bin.dmp" log="exp_alter_bin.log" parallel=2 ddl_parallel=2 BATCH_COUNT=1 filetype=bin;

exp users=cmbtest file="exp_alter_txt.dmp" parallel=4 insert_batch=8 COMMIT_BATCH=1000 filetype=txt;
imp users=cmbtest FILE="exp_alter_txt.dmp" log="aaaa.log" parallel=1 BATCH_COUNT=1 filetype=txt;
drop user if exists cmbtest cascade;

-- DTS2021051306F8GHP1300
CREATE TABLESPACE NCISLOB datafile 'NCISLOB' size 4M autoextend on next 32M extent autoallocate;
CREATE TABLESPACE NCISBLOB datafile 'NCISBLOB' size 4M autoextend on next 32M extent autoallocate;
CREATE TABLESPACE NCISDAT datafile 'NCISDAT' size 4M autoextend on next 32M extent autoallocate;
drop user if exists ncisdbau cascade;
create user ncisdbau identified by Cantian_234;
alter user ncisdbau default tablespace NCISDAT;
grant dba to ncisdbau;
conn ncisdbau/Cantian_234@127.0.0.1:1611
drop table if exists S31T1_CRD_AHN_TXN_JRNL_000001;
CREATE TABLE S31T1_CRD_AHN_TXN_JRNL_000001
(
RSRV_FLD_DSC            CLOB,
RSRV_FLD_DSC_B          BLOB,
SYS_SND_SERIAL_NO       CHAR(10) ,
SYS_TX_TYPE             CHAR(6) ,
MULTI_TENANCY_ID        CHAR(6) ,
TXN_DT                  CHAR(20) 
)
LOB(RSRV_FLD_DSC) STORE AS(
	TABLESPACE NCISLOB
)
LOB(RSRV_FLD_DSC_B) STORE AS(
	TABLESPACE NCISBLOB
)
PARTITION BY RANGE ("MULTI_TENANCY_ID","TXN_DT")
(
        PARTITION PCN000_20180727 VALUES LESS THAN ('CN000','20180728') TABLESPACE "NCISDAT" INITRANS 2 PCTFREE 10
)TABLESPACE "NCISDAT";

show create table S31T1_CRD_AHN_TXN_JRNL_000001;
exp tables=S31T1_CRD_AHN_TXN_JRNL_000001 file='lob_storage.txt';
imp tables=S31T1_CRD_AHN_TXN_JRNL_000001 file='lob_storage.txt';

exp tables=S31T1_CRD_AHN_TXN_JRNL_000001 file='lob_storage.bin' consistent=y;
imp tables=S31T1_CRD_AHN_TXN_JRNL_000001 file='lob_storage.bin';
conn sys/Huawei@123@127.0.0.1:1611

drop table if exists S31T1_CRD_AHN_TXN_JRNL_000001;
drop user if exists ncisdbau cascade;
drop TABLESPACE NCISLOB INCLUDING CONTENTS AND DATAFILES;
drop TABLESPACE NCISBLOB INCLUDING CONTENTS AND DATAFILES;
drop TABLESPACE NCISDAT INCLUDING CONTENTS AND DATAFILES;

-- 	DTS2021051703VS9FP1400
CREATE TABLESPACE TABLE_COMPRESS_TEST DATAFILE 'normal_object_compress_test' size 10M AUTOEXTEND on extent autoallocate;
CREATE TABLESPACE TABLE_COMPRESS_MAP DATAFILE 'normal_object_compress_map' size 10M compress AUTOEXTEND on extent autoallocate;
CREATE TABLESPACE TABLE_COMPRESS_THREE DATAFILE 'normal_object_compress_three' size 10M compress AUTOEXTEND on extent autoallocate;
drop user if exists cmbtest cascade;
create user cmbtest identified by Changeme_123;
grant dba to cmbtest;
conn CMBTEST/Changeme_123@127.0.0.1:1611

DROP TABLE IF EXISTS education;
CREATE TABLE education(staff_id INT NOT NULL, highest_degree CHAR(8), graduate_school VARCHAR(64), graduate_date DATETIME, education_note VARCHAR(70))
PARTITION BY LIST(highest_degree)
(
PARTITION doctor VALUES ('博士'),
PARTITION master VALUES ('硕士'),
PARTITION undergraduate VALUES ('学士')
);
--向表education中插入记录1。
INSERT INTO education(staff_id,highest_degree,graduate_school,graduate_date,education_note) VALUES(10,'博士','西安电子科技大学','2017-07-06 12:00:00','211');
--向表education中插入记录2。
INSERT INTO education(staff_id,highest_degree,graduate_school,graduate_date,education_note) VALUES(11,'博士','西北农林科技大学','2017-07-06 12:00:00','211和985');
--向表education中插入记录3。
INSERT INTO education(staff_id,highest_degree,graduate_school,graduate_date,education_note) VALUES(12,'硕士','西北工业大学','2017-07-06 12:00:00','211和985');
--向表education中插入记录4。
INSERT INTO education(staff_id,highest_degree,graduate_school,graduate_date,education_note) VALUES(15,'学士','西安建筑科技大学','2017-07-06 12:00:00','非211和985');
--向表education中插入记录5。
INSERT INTO education(staff_id,highest_degree,graduate_school,graduate_date,education_note) VALUES(18,'硕士','西安理工大学','2017-07-06 12:00:00','非211和985');
--向表education中插入记录6。
INSERT INTO education(staff_id,highest_degree,graduate_school,graduate_date,education_note) VALUES(20,'学士','北京师范大学','2017-07-06 12:00:00','211和985');
--提交事务。
COMMIT;
--创建分区索引。
drop table if exists idx_training;
CREATE INDEX idx_training ON education(staff_id ASC, highest_degree)
 LOCAL (PARTITION DOCTOR tablespace  TABLE_COMPRESS_TEST,
 PARTITION master tablespace  TABLE_COMPRESS_TEST,
 PARTITION undergraduate tablespace  TABLE_COMPRESS_TEST);
 
测试普通分区索引还有二级分区索引看都不一致
drop table if exists test_hash_hash;
create table test_hash_hash (
id int,
name varchar2(100)
)  PARTITION BY HASH(id) SUBPARTITION BY HASH(name)
(
PARTITION PART_1 (SUBPARTITION P1_1, SUBPARTITION P1_2),
PARTITION PART_2 (SUBPARTITION P2_1, SUBPARTITION P2_2)
)  tablespace TABLE_COMPRESS_TEST;

--- 创建二级分区索引
drop index if exists index_local_sub_hash_compress ON TEST_HASH_HASH;
create index index_local_sub_hash_compress ON TEST_HASH_HASH (id)
LOCAL (PARTITION PART_1  tablespace  TABLE_COMPRESS_MAP  
				 (SUBPARTITION P1_1 tablespace  TABLE_COMPRESS_MAP,
				  SUBPARTITION P1_2 tablespace  TABLE_COMPRESS_THREE
				 ),
       PARTITION PART_2  tablespace  TABLE_COMPRESS_TEST
	             (SUBPARTITION P2_1 tablespace  TABLE_COMPRESS_MAP,
				  SUBPARTITION P2_2 tablespace  TABLE_COMPRESS_THREE
				 )
      );

SHOW CREATE TABLE EDUCATION;
SHOW CREATE TABLE TEST_HASH_HASH;
exp tables=EDUCATION,TEST_HASH_HASH file='index_partitioning.txt';
imp tables=EDUCATION,TEST_HASH_HASH file='index_partitioning.txt';

exp tables=EDUCATION,TEST_HASH_HASH file='index_partitioning.bin' consistent=y filetype=bin;
imp tables=EDUCATION,TEST_HASH_HASH file='index_partitioning.bin' filetype=bin;

conn sys/Huawei@123@127.0.0.1:1611
drop table if exists EDUCATION;
drop table if exists TEST_HASH_HASH;
drop user if exists CMBTEST cascade;
drop TABLESPACE TABLE_COMPRESS_TEST INCLUDING CONTENTS AND DATAFILES;
drop TABLESPACE TABLE_COMPRESS_MAP INCLUDING CONTENTS AND DATAFILES;
drop TABLESPACE TABLE_COMPRESS_THREE INCLUDING CONTENTS AND DATAFILES;

--number2
drop user if exists test_data;
create user test_data identified by 'Changeme_123';
grant dba to test_data;
conn test_data/Changeme_123@127.0.0.1:1611

drop table if exists number2_test;
CREATE TABLE  number2_test(
     COL_1 real,
     COL_2 double,
     COL_3 float,
     COL_4 number2(12,6),
     COL_5 number2,
     COL_6 number2
);
begin
    for i in 1..10 loop
      insert into number2_test values(
      i+3.1415926,
      i+445.255,
      3.1415926-i*2,
      98*0.99*i, 
      99*1.01*i,
      -98*0.99*i
      );
      commit;
    end loop;
end;
/
select (select COL_4||dummy from sys_dummy) from number2_test order by COL_4 desc limit 2;
select (select COL_3||dummy from sys_dummy) from number2_test order by COL_3;

exp tables=number2_test file="number2_txt.dmp" filetype=txt;
drop table if exists number2_test;
imp tables=number2_test file="number2_txt.dmp" filetype=txt;
select (select COL_4||dummy from sys_dummy) from number2_test order by COL_4 desc limit 2;
select (select COL_3||dummy from sys_dummy) from number2_test order by COL_3;

exp tables=number2_test file="number2_bin.dmp" filetype=bin parallel=2;
drop table if exists number2_test;
imp tables=number2_test file="number2_bin.dmp" filetype=bin parallel=2;
select (select COL_4||dummy from sys_dummy) from number2_test order by COL_4 desc limit 2;
select (select COL_3||dummy from sys_dummy) from number2_test order by COL_3;

dump table number2_test INTO FILE "number2_dump.txt";
truncate table number2_test;
LOAD DATA INFILE 'number2_dump.txt' INTO TABLE number2_test;
select (select COL_4||dummy from sys_dummy) from number2_test order by COL_4 desc limit 2;
select (select COL_3||dummy from sys_dummy) from number2_test order by COL_3;
drop table if exists number2_test;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists test_data cascade;

---fuzz DTS202106080FNBXKP1L00
drop user if exists cantiandba cascade;
CREATE USER cantiandba IDENTIFIED BY Changeme_123;
GRANT DBA TO cantiandba;
conn cantiandba/Changeme_123@127.0.0.1:1611
imp users=cantiandba file="./data/fuzz_test/export_bin.dmp" filetype=bin;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists cantiandba cascade;

drop user if exists partition_user cascade;
CREATE USER partition_user IDENTIFIED BY Changeme_123;
GRANT DBA TO partition_user;
conn partition_user/Changeme_123@127.0.0.1:1611
drop table if exists EEE;
CREATE TABLE "EEE"
(
  "ID" BINARY_INTEGER,
  "NAME" VARCHAR(20 BYTE)
)
PARTITION BY RANGE ("ID")
INTERVAL(50)
SUBPARTITION BY HASH ("NAME")
(
    PARTITION P1 VALUES LESS THAN (50) TABLESPACE "USERS" INITRANS 2 PCTFREE 8(
        SUBPARTITION P11 TABLESPACE "USERS",
        SUBPARTITION P12 TABLESPACE "USERS"
    ),
    PARTITION P2 VALUES LESS THAN (100) TABLESPACE "USERS" INITRANS 2 PCTFREE 8(
        SUBPARTITION P21 TABLESPACE "USERS",
        SUBPARTITION P22 TABLESPACE "USERS"
    )
);
CREATE INDEX "INDEX_100" ON "EEE"("ID", "NAME")
LOCAL
      (
       PARTITION P1 TABLESPACE "USERS" INITRANS 2 PCTFREE 8(
           SUBPARTITION P11 TABLESPACE "USERS",
           SUBPARTITION P12 TABLESPACE "USERS"
        ),
       PARTITION P2 TABLESPACE "USERS" INITRANS 2 PCTFREE 8(
           SUBPARTITION P21 TABLESPACE "USERS",
           SUBPARTITION P22 TABLESPACE "USERS"
        )
      );


CREATE INDEX "INDEX_101" ON "EEE"("ID")
LOCAL
      (
       PARTITION P1 TABLESPACE "USERS" INITRANS 2 PCTFREE 8(
           SUBPARTITION P11 TABLESPACE "USERS",
           SUBPARTITION P12 TABLESPACE "USERS"
        ),
       PARTITION P2 TABLESPACE "USERS" INITRANS 2 PCTFREE 8(
           SUBPARTITION P21 TABLESPACE "USERS",
           SUBPARTITION P22 TABLESPACE "USERS"
        )
      );

CREATE INDEX "INDEX_102" ON "EEE"("NAME")
LOCAL
      (
       PARTITION P1 TABLESPACE "USERS" INITRANS 2 PCTFREE 8(
           SUBPARTITION P11 TABLESPACE "USERS",
           SUBPARTITION P12 TABLESPACE "USERS"
        ),
       PARTITION P2 TABLESPACE "USERS" INITRANS 2 PCTFREE 8(
           SUBPARTITION P21 TABLESPACE "USERS",
           SUBPARTITION P22 TABLESPACE "USERS"
        )
      );
exp tables=% file='partitioning.txt';
imp tables=% file='partitioning.txt';
drop table if exists EEE;
--number2 max_value
drop table if exists number2_test_overflow;
create table number2_test_overflow(id number2);
insert into number2_test_overflow values(cast('9.99999999999999999999999999999999999E+125' as number2));
insert into number2_test_overflow values(cast('9.999999999999999999999999999999999999999E+125' as number2));
insert into number2_test_overflow values(cast('-9.999999999999999999999999999999999999999E+125' as number2));
insert into number2_test_overflow values(cast('9.999999999999999999999999999999999999999E+124' as number2));
insert into number2_test_overflow values(cast('9.999999999999999999999999999999999999999E-130' as number2));
insert into number2_test_overflow values(cast('-9.999999999999999999999999999999999999999E-130' as number2));
insert into number2_test_overflow values(cast('9.999999999999999999999999999999999999999E-131' as number2));
insert into number2_test_overflow values(cast('9.99999999999999999999999999999E+125' as number2));
commit;
select * from  number2_test_overflow;
EXP TABLES = NUMBER2_TEST_OVERFLOW FILE = "./data/NUMBER2_TEST_OVERFLOW_1.dmp";
EXP TABLES = NUMBER2_TEST_OVERFLOW FILE = "./data/NUMBER2_TEST_OVERFLOW_2.dat" filetype=BIN;
EXP TABLES = NUMBER2_TEST_OVERFLOW FILE = "./data/NUMBER2_TEST_OVERFLOW_3.dat" filetype=txt parallel=4;
drop table number2_test_overflow;
IMP TABLES = NUMBER2_TEST_OVERFLOW FILE = "./data/NUMBER2_TEST_OVERFLOW_1.dmp";
select * from  number2_test_overflow where id = 0;
drop table number2_test_overflow;
IMP TABLES = NUMBER2_TEST_OVERFLOW FILE = "./data/NUMBER2_TEST_OVERFLOW_2.dat" filetype=BIN;
select * from  number2_test_overflow where id = 0;
drop table number2_test_overflow;
IMP TABLES = NUMBER2_TEST_OVERFLOW FILE = "./data/NUMBER2_TEST_OVERFLOW_3.dat" filetype=txt parallel=4;
select * from number2_test_overflow;
drop table if exists number2_test_overflow;
--number max_value
drop table if exists number_test_overflow;
create table number_test_overflow(id number);
insert into number_test_overflow values(cast('9.99999999999999999999999999999999999E+127' as number));
insert into number_test_overflow values(cast('9.999999999999999999999999999999999999999E+127' as number));
insert into number_test_overflow values(cast('-9.999999999999999999999999999999999999999E+127' as number));
insert into number_test_overflow values(cast('9.999999999999999999999999999999999999999E+126' as number));
insert into number_test_overflow values(cast('9.999999999999999999999999999999999999999E-127' as number));
insert into number_test_overflow values(cast('-9.999999999999999999999999999999999999999E-127' as number));
insert into number_test_overflow values(cast('9.999999999999999999999999999999999999999E-128' as number));
insert into number_test_overflow values(cast('9.99999999999999999999999999999E+127' as number));
commit;
select * from  number_test_overflow;
EXP TABLES = NUMBER_TEST_OVERFLOW FILE = "./data/NUMBER_TEST_OVERFLOW_1.dmp";
EXP TABLES = NUMBER_TEST_OVERFLOW FILE = "./data/NUMBER_TEST_OVERFLOW_2.dat" filetype=BIN;
EXP TABLES = NUMBER_TEST_OVERFLOW FILE = "./data/NUMBER_TEST_OVERFLOW_3.dat" filetype=txt parallel=4;
drop table number_test_overflow;
IMP TABLES = NUMBER_TEST_OVERFLOW FILE = "./data/NUMBER_TEST_OVERFLOW_1.dmp";
select * from  number_test_overflow limit 1;
drop table number_test_overflow;
IMP TABLES = NUMBER_TEST_OVERFLOW FILE = "./data/NUMBER_TEST_OVERFLOW_2.dat" filetype=BIN;
select * from  number_test_overflow limit 3;
drop table number_test_overflow;
IMP TABLES = NUMBER_TEST_OVERFLOW FILE = "./data/NUMBER_TEST_OVERFLOW_3.dat" filetype=txt parallel=4;
select * from  number_test_overflow;
drop table if exists number_test_overflow;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists partition_user cascade;

-- test for interval autoextend
create user test_interval_partition_exp1 identified by database_123;
grant dba to test_interval_partition_exp1;

conn test_interval_partition_exp1/database_123@127.0.0.1:1611

drop table if exists TBL_INTERVAL_CSF_FIRST;
create table tbl_interval_csf_first(
col_int int primary key,
col_number1 number,
col_number2 number(20,2),
col_number3 number(20,-3),
col_number4 number(3,10),
col_number5 number(38,7),
col_numeric numeric
)
partition by range(col_number1) interval (10)
(
  partition p_interval_01 values less than (10) ,
  partition p_interval_02 values less than (20),
  partition p_interval_03 values less than (30)
 );
create index INDEX_TBL_INTERVAL_CSF_FIRST_01 on TBL_INTERVAL_CSF_FIRST(col_number1) LOCAL;


insert into TBL_INTERVAL_CSF_FIRST(col_int,col_number1,col_number2,col_number3,col_number4) values (1,1,1,1,0);
CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
                sqlst := 'insert into ' || tname ||'(col_int,col_number1,col_number2,col_number3,col_number4)  select
			    col_int+'||i||',col_number1||'||i||',col_number2||'||i||',col_number3'||',0 from '||tname|| ' where col_int=1';
        execute immediate sqlst;
  END LOOP;
END;
/
exec proc_insert('TBL_INTERVAL_CSF_FIRST',1,99);
commit;

show create table tbl_interval_csf_first;
exp tables=tbl_interval_csf_first;
imp tables=tbl_interval_csf_first;

-- test for interval not autoextend
drop table if exists TBL_INTERVAL_CSF_FIRST;
create table tbl_interval_csf_first(
col_int int primary key,
col_number1 number,
col_number2 number(20,2),
col_number3 number(20,-3),
col_number4 number(3,10),
col_number5 number(38,7),
col_numeric numeric
)
partition by range(col_number1) interval (10)
(
  partition p_interval_01 values less than (10) ,
  partition p_interval_02 values less than (20),
  partition p_interval_03 values less than (30)
 );
create index INDEX_TBL_INTERVAL_CSF_FIRST_01 on TBL_INTERVAL_CSF_FIRST(col_number1) LOCAL;


insert into TBL_INTERVAL_CSF_FIRST(col_int,col_number1,col_number2,col_number3,col_number4) values (1,1,1,1,0);
CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
                sqlst := 'insert into ' || tname ||'(col_int,col_number1,col_number2,col_number3,col_number4)  select
			    col_int+'||i||',col_number1||'||i||',col_number2||'||i||',col_number3'||',0 from '||tname|| ' where col_int=1';
        execute immediate sqlst;
  END LOOP;
END;
/
exec proc_insert('TBL_INTERVAL_CSF_FIRST',1,8);
commit;

show create table tbl_interval_csf_first;
exp tables=tbl_interval_csf_first;
imp tables=tbl_interval_csf_first;

DROP TABLE IF EXISTS "TBL_INTERVAL_CSF_FIRST";
CREATE TABLE "TBL_INTERVAL_CSF_FIRST"
(
  "COL_INT" BINARY_INTEGER NOT NULL,
  "COL_NUMBER1" NUMBER,
  "COL_NUMBER2" NUMBER(20, 2),
  "COL_NUMBER3" NUMBER(20, -3),
  "COL_NUMBER4" NUMBER(3, 10),
  "COL_NUMBER5" NUMBER(38, 7),
  "COL_NUMERIC" NUMBER
)
PARTITION BY RANGE ("COL_NUMBER1")
INTERVAL(10)
(
    PARTITION P_INTERVAL_09 VALUES LESS THAN (10) TABLESPACE "USERS" INITRANS 2 PCTFREE 8,
    PARTITION P_INTERVAL_08 VALUES LESS THAN (20) TABLESPACE "USERS" INITRANS 2 PCTFREE 8,
    PARTITION P_INTERVAL_07 VALUES LESS THAN (30) TABLESPACE "USERS" INITRANS 2 PCTFREE 8
)
TABLESPACE "USERS"
INITRANS 2
MAXTRANS 255
PCTFREE 8;
INSERT INTO "TBL_INTERVAL_CSF_FIRST"("COL_INT","COL_NUMBER1") VALUES(1,9),(2,19),(3,29);
COMMIT;
CREATE INDEX "INDEX_TBL_INTERVAL_CSF_FIRST_01" ON "TBL_INTERVAL_CSF_FIRST"("COL_NUMBER1")
LOCAL
      (
       PARTITION P_INTERVAL_19 TABLESPACE "USERS" INITRANS 2 PCTFREE 8,
       PARTITION P_INTERVAL_18 TABLESPACE "USERS" INITRANS 2 PCTFREE 8,
       PARTITION P_INTERVAL_17 TABLESPACE "USERS" INITRANS 2 PCTFREE 8
      )
TABLESPACE "USERS"
INITRANS 2
PCTFREE 8;
ALTER TABLE "TBL_INTERVAL_CSF_FIRST" ADD PRIMARY KEY("COL_INT");

show create table TBL_INTERVAL_CSF_FIRST;
exp tables=TBL_INTERVAL_CSF_FIRST;
imp tables=TBL_INTERVAL_CSF_FIRST;
--20210731
drop table if exists temp_0731;
create table temp_0731(f1 int);
create index idx_temp_0731 on temp_0731(f1) reverse;
show create table temp_0731;
drop table temp_0731;
CREATE TABLE "TEMP_0731"
(
  "F1" BINARY_INTEGER
)
TABLESPACE "USERS"
INITRANS 2
MAXTRANS 255
PCTFREE 8
FORMAT ASF;
CREATE INDEX "IDX_TEMP_0731" ON "TEMP_0731"("F1")
TABLESPACE "USERS"
INITRANS 2
PCTFREE 8
REVERSE;
drop table TEMP_0731;

--20210815
drop table if exists temp0815;
create table temp0815(f1 int primary key reverse, f2 int);
show create table temp0815;
drop table temp0815;
create table temp0815(f1 int , f2 int, primary key(f1) reverse);
show create table temp0815;
drop table temp0815;
create table temp0815(f1 int, f2 int);
alter table temp0815 add constraint pk_temp0815 primary key (f1) reverse;
show create table temp0815;
drop table temp0815;
create table temp0815(f1 int, f2 int);
create index idx_temp0815 on temp0815(f1) reverse;
alter table temp0815 add constraint pk_temp0815 primary key (f1) using index idx_temp0815;
create unique index temp_0815_uidx on temp0815(f2) reverse;
show create table temp0815;
drop table temp0815;
create table temp0815 (f1 int check(f1 > 1));
drop table if exists temp0815_1;
create table temp0815_1 (f1 int);
alter table temp0815_1 add constraint chk_0813 check(f1 > 2);
exp tables = temp0815,temp0815_1 file = "TBL_INDEX_WITH_NOLOGGING_1.dmp"  quote_names=N;
imp file="TBL_INDEX_WITH_NOLOGGING_1.dmp";
exp tables = temp0815,temp0815_1 file = "TBL_INDEX_WITH_NOLOGGING_1.dmp"  quote_names=Y;
imp file="TBL_INDEX_WITH_NOLOGGING_1.dmp";
drop table temp0815;
drop table temp0815_1;
create table temp0815(f1 int, f2 int) partition by range(f1) (partition p1 values less than (1));
alter table temp0815 add constraint pk_temp0815 primary key (f1) reverse;
create index temp0815_idx002 on temp0815(f2) local reverse;
show create table temp0815;
drop table temp0815;
--AR.SR.20210623200704.001.004
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists test_index cascade;
create user test_index identified by Changeme_123;
grant dba to test_index;

conn test_index/Changeme_123@127.0.0.1:1611
drop table if exists TBL_INDEX_WITH_NOLOGGING;
create table TBL_INDEX_WITH_NOLOGGING(
col_int int primary key,
col_number1 number,
col_number2 number(20,2),
col_numeric numeric,
col_varchar varchar(20)
)
partition by range(col_number1) interval (10)
(
  partition p_interval_01 values less than (10) ,
  partition p_interval_02 values less than (20),
  partition p_interval_03 values less than (30)
 );
 
create index INDEX_WITHOUT_NOLOGGING on TBL_INDEX_WITH_NOLOGGING(col_number1);
create index INDEX_WITH_NOLOGGING on TBL_INDEX_WITH_NOLOGGING(col_varchar) NOLOGGING;
INSERT INTO TBL_INDEX_WITH_NOLOGGING VALUES(1, 9, 2323, 22, 'TEST1');
INSERT INTO TBL_INDEX_WITH_NOLOGGING VALUES(2, 15, 3434, 22, 'TEST2');
INSERT INTO TBL_INDEX_WITH_NOLOGGING VALUES(3, 21, 4545, 22, 'TEST3');
INSERT INTO TBL_INDEX_WITH_NOLOGGING VALUES(4, 33, 6767, 22, 'TEST4');
COMMIT;

show create table TBL_INDEX_WITH_NOLOGGING;
EXP TABLES = TBL_INDEX_WITH_NOLOGGING FILE = "TBL_INDEX_WITH_NOLOGGING_1.dmp";
drop table TBL_INDEX_WITH_NOLOGGING;
IMP TABLES = TBL_INDEX_WITH_NOLOGGING FILE = "TBL_INDEX_WITH_NOLOGGING_1.dmp";
SELECT COUNT(*) FROM TBL_INDEX_WITH_NOLOGGING;

EXP TABLES = TBL_INDEX_WITH_NOLOGGING FILE = "TBL_INDEX_WITH_NOLOGGING_2.dmp" FILETYPE=BIN;
drop table TBL_INDEX_WITH_NOLOGGING;
IMP TABLES = TBL_INDEX_WITH_NOLOGGING FILE = "TBL_INDEX_WITH_NOLOGGING_2.dmp" FILETYPE=BIN;
SELECT COUNT(*) FROM TBL_INDEX_WITH_NOLOGGING;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists test_index cascade;
