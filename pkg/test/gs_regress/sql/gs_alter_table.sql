--创建sys用户的预置环境
CONN / AS SYSDBA
CREATE TABLE BOOK_TAB(BOOK_TABID INT, NAME VARCHAR(1024), CATEGORY_ID int);
--创建dba用户
CREATE USER DBA_USER IDENTIFIED BY Changeme_123;
GRANT DBA TO DBA_USER;
--创建普通用户和表
CREATE USER TEST_USER IDENTIFIED BY Changeme_123;
CREATE TABLE TEST_USER.CATEGORY(ID int primary key);
INSERT INTO TEST_USER.CATEGORY VALUES(1),(2),(3);
--DBA给sys用户赋予references权限
CONN DBA_USER/Changeme_123@127.0.0.1:1611
GRANT REFERENCES ON TEST_USER.CATEGORY TO SYS;
--登录SYS用户进行操作
CONN / AS SYSDBA
ALTER TABLE SYS.BOOK_TAB ADD CONSTRAINT FK_CATEGORY_ID1 FOREIGN KEY(CATEGORY_ID) REFERENCES TEST_USER.CATEGORY(ID);
INSERT INTO SYS.BOOK_TAB VALUES(1,'CANTIAN100 OLAP',2);
--恢复环境
CONN / AS SYSDBA
DROP TABLE BOOK_TAB;
DROP USER TEST_USER CASCADE;
DROP USER DBA_USER;
drop table if exists test_add_column;
create table test_add_column (id int);
insert into test_add_column values(1),(2);
commit;
alter table test_add_column add (col_uint_2 binary_uint32 default convert(2345.45,uint) on update 56.57 comment 'uint type' COLLATE UTF8_BIN not null,col_uint_3 int default 234.565 on update 3.45 comment 'test_add_column uint' collate UTF8_GENERAL_CI check (col_uint_3>100));
insert into test_add_column(id,col_uint_2,col_uint_3) values(1000,1,101);
insert into test_add_column(id,col_uint_2,col_uint_3) values(1000,101,101);
select * from test_add_column where id = 1000;
drop table test_add_column;
--TEST
DROP TABLE IF EXISTS RQG_ALL_TYPE_TABLE_GSQL; 
CREATE TABLE RQG_ALL_TYPE_TABLE_GSQL( 
ID BIGINT, 
C_INTEGER INTEGER , C_BIGINT BIGINT, 
C_NUMBER NUMBER, C_DOUBLE DOUBLE PRECISION,
C_CHAR20 CHAR(20), C_CHAR4000 CHAR(100), 
C_VARCHAR20 VARCHAR(20), C_VARCHAR4000 VARCHAR(100), 
C_TEXT TEXT,
C_BOOL BOOL, 
C_TIMESTAMP3 TIMESTAMP(3), C_TIMESTAMP6 TIMESTAMP(6) )
--DISTRIBUTE BY HASH(C_INTEGER)
PARTITION BY RANGE ( C_BIGINT)
( PARTITION PT1 VALUES LESS THAN ( 10000 ),
PARTITION PT2 VALUES LESS THAN ( 20000 ),
PARTITION PT3 VALUES LESS THAN ( 30000 ),
PARTITION PT4 VALUES LESS THAN ( MAXVALUE ));
INSERT INTO RQG_ALL_TYPE_TABLE_GSQL(C_CHAR20) VALUES('CANTIANDB');
ALTER TABLE RQG_ALL_TYPE_TABLE_GSQL ADD COLUMN C_NUMBER_NEW NUMBER DEFAULT 10+100; 
INSERT INTO RQG_ALL_TYPE_TABLE_GSQL(C_BOOL) VALUES(FALSE);
INSERT INTO RQG_ALL_TYPE_TABLE_GSQL(C_NUMBER_NEW) VALUES(11);
SELECT * FROM RQG_ALL_TYPE_TABLE_GSQL ORDER BY C_CHAR20,C_NUMBER_NEW;

--TEST
DROP TABLE IF EXISTS RQG_ALL_TYPE_TABLE_GSQL; 
CREATE TABLE RQG_ALL_TYPE_TABLE_GSQL( 
ID BIGINT, 
C_INTEGER INTEGER , C_BIGINT BIGINT, 
C_NUMBER NUMBER, C_DOUBLE DOUBLE PRECISION,
C_CHAR20 CHAR(20), C_CHAR4000 CHAR(100), 
C_VARCHAR20 VARCHAR(20), C_VARCHAR4000 VARCHAR(100), 
C_TEXT TEXT,
C_BOOL BOOL, 
C_TIMESTAMP3 TIMESTAMP(3), C_TIMESTAMP6 TIMESTAMP(6) )
--DISTRIBUTE BY HASH(C_INTEGER)
PARTITION BY RANGE ( C_BIGINT)
( PARTITION PT1 VALUES LESS THAN ( 10000 ),
PARTITION PT2 VALUES LESS THAN ( 20000 ),
PARTITION PT3 VALUES LESS THAN ( 30000 ),
PARTITION PT4 VALUES LESS THAN ( MAXVALUE ));
INSERT INTO RQG_ALL_TYPE_TABLE_GSQL(C_CHAR20) VALUES('CANTIANDB');
ALTER TABLE RQG_ALL_TYPE_TABLE_GSQL ADD COLUMN C_NUMBER_NEW NUMBER DEFAULT 110 NOT NULL; 
INSERT INTO RQG_ALL_TYPE_TABLE_GSQL(C_BOOL) VALUES(FALSE);
INSERT INTO RQG_ALL_TYPE_TABLE_GSQL(C_NUMBER_NEW) VALUES(11);
SELECT * FROM RQG_ALL_TYPE_TABLE_GSQL ORDER BY C_CHAR20,C_NUMBER_NEW;

--TEST
DROP TABLE IF EXISTS RQG_ALL_TYPE_TABLE_GSQL; 
CREATE TABLE RQG_ALL_TYPE_TABLE_GSQL( 
ID BIGINT, 
C_INTEGER INTEGER , C_BIGINT BIGINT, 
C_NUMBER NUMBER, C_DOUBLE DOUBLE PRECISION,
C_CHAR20 CHAR(20), C_CHAR4000 CHAR(100), 
C_VARCHAR20 VARCHAR(20), C_VARCHAR4000 VARCHAR(100), 
C_TEXT TEXT,
C_BOOL BOOL, 
C_TIMESTAMP3 TIMESTAMP(3), C_TIMESTAMP6 TIMESTAMP(6) )
--DISTRIBUTE BY HASH(C_INTEGER)
PARTITION BY RANGE ( C_BIGINT)
( PARTITION PT1 VALUES LESS THAN ( 10000 ),
PARTITION PT2 VALUES LESS THAN ( 20000 ),
PARTITION PT3 VALUES LESS THAN ( 30000 ),
PARTITION PT4 VALUES LESS THAN ( MAXVALUE ));
INSERT INTO RQG_ALL_TYPE_TABLE_GSQL(C_CHAR20) VALUES('CANTIANDB');
ALTER TABLE RQG_ALL_TYPE_TABLE_GSQL ADD COLUMN C_NUMBER_NEW NUMBER NULL DEFAULT 110; 
INSERT INTO RQG_ALL_TYPE_TABLE_GSQL(C_BOOL) VALUES(FALSE);
INSERT INTO RQG_ALL_TYPE_TABLE_GSQL(C_NUMBER_NEW) VALUES(11);
SELECT * FROM RQG_ALL_TYPE_TABLE_GSQL ORDER BY C_CHAR20,C_NUMBER_NEW;

--TEST
DROP TABLE IF EXISTS RQG_ALL_TYPE_TABLE_GSQL; 
CREATE TABLE RQG_ALL_TYPE_TABLE_GSQL( 
ID BIGINT, 
C_INTEGER INTEGER , C_BIGINT BIGINT, 
C_NUMBER NUMBER, C_DOUBLE DOUBLE PRECISION,
C_CHAR20 CHAR(20), C_CHAR4000 CHAR(100), 
C_VARCHAR20 VARCHAR(20), C_VARCHAR4000 VARCHAR(100), 
C_TEXT TEXT,
C_BOOL BOOL, 
C_TIMESTAMP3 TIMESTAMP(3), C_TIMESTAMP6 TIMESTAMP(6) )
--DISTRIBUTE BY HASH(C_INTEGER)
PARTITION BY RANGE ( C_BIGINT)
( PARTITION PT1 VALUES LESS THAN ( 10000 ),
PARTITION PT2 VALUES LESS THAN ( 20000 ),
PARTITION PT3 VALUES LESS THAN ( 30000 ),
PARTITION PT4 VALUES LESS THAN ( MAXVALUE ));
INSERT INTO RQG_ALL_TYPE_TABLE_GSQL(C_CHAR20) VALUES('CANTIANDB');
ALTER TABLE RQG_ALL_TYPE_TABLE_GSQL ADD COLUMN C_NUMBER_NEW NUMBER DEFAULT NULL; 
INSERT INTO RQG_ALL_TYPE_TABLE_GSQL(C_BOOL) VALUES(FALSE);
INSERT INTO RQG_ALL_TYPE_TABLE_GSQL(C_NUMBER_NEW) VALUES(11);
SELECT * FROM RQG_ALL_TYPE_TABLE_GSQL ORDER BY C_CHAR20,C_NUMBER_NEW;
DROP TABLE IF EXISTS RQG_ALL_TYPE_TABLE_GSQL; 
--TEST RENAME, the table name does not support case sensitive , DML not support single(double) quotes of table
DROP TABLE IF EXISTS T_RENAME_1; 
DROP TABLE IF EXISTS T_RENAME_2; 
CREATE TABLE T_RENAME_1(i int,j int);
INSERT INTO T_RENAME_1 values(1,1);
SELECT * from T_RENAME_1;
SELECT NAME from SYS_TABLES where name like 'T_RENAME_%';
DROP TABLE IF EXISTS "t_rename_1"; 
CREATE TABLE "t_rename_1" (a varchar2(10),b varchar2(10));
CREATE TABLE T_RENAME_2 (a varchar2(10),b varchar2(10));
INSERT INTO T_RENAME_2 values('a','a');
SELECT * from T_RENAME_2;
SELECT NAME from SYS_TABLES where name like 'T_RENAME_%' ORDER BY name;
DROP TABLE IF EXISTS  "t_rename_2";
ALTER TABLE T_RENAME_1 rename to T_RENAME_2;
ALTER TABLE T_RENAME_1 rename to "t_rename_2";
SELECT NAME from SYS_TABLES where name like 'T_RENAME_%' ORDER BY name;
SELECT * from T_RENAME_2;
SELECT * from T_RENAME_1;
SELECT * from 't_rename_2';
DROP TABLE T_RENAME_2; 
---case 5 modify column type which column in index
drop table STORAGE_ELSE_TABLE_047;
create table STORAGE_ELSE_TABLE_047(a int);
create index STORAGE_ELSE_IDX_047 on STORAGE_ELSE_TABLE_047(a);
insert into STORAGE_ELSE_TABLE_047 values(1);
select * from STORAGE_ELSE_TABLE_047;
delete from STORAGE_ELSE_TABLE_047;
alter table STORAGE_ELSE_TABLE_047 modify a int;
insert into STORAGE_ELSE_TABLE_047 values(111);
select * from STORAGE_ELSE_TABLE_047;
delete from STORAGE_ELSE_TABLE_047;
alter table STORAGE_ELSE_TABLE_047 modify a TIMESTAMP;
insert into STORAGE_ELSE_TABLE_047 values(to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'));
select count(*) from STORAGE_ELSE_TABLE_047;
delete from STORAGE_ELSE_TABLE_047;
alter table STORAGE_ELSE_TABLE_047 modify a number;
insert into STORAGE_ELSE_TABLE_047 values(2);
select * from STORAGE_ELSE_TABLE_047;
delete from STORAGE_ELSE_TABLE_047;
alter table STORAGE_ELSE_TABLE_047 modify a numeric(12,2);
insert into STORAGE_ELSE_TABLE_047 values(3);
select * from STORAGE_ELSE_TABLE_047;
delete from STORAGE_ELSE_TABLE_047;
alter table STORAGE_ELSE_TABLE_047 modify a char(100);
insert into STORAGE_ELSE_TABLE_047 values('abcdefghe');
select * from STORAGE_ELSE_TABLE_047;
delete from STORAGE_ELSE_TABLE_047;
alter table STORAGE_ELSE_TABLE_047 modify a varchar2(200);
insert into STORAGE_ELSE_TABLE_047 values('varchar2-50000000000000');
select * from STORAGE_ELSE_TABLE_047;
delete from STORAGE_ELSE_TABLE_047;
drop table STORAGE_ELSE_TABLE_047;

drop table if exists t1;
create table t1(a int, b int);
create index idx_t1_1 on t1(a);
alter index idx_t1_1 on t1 rebuild  tablespace 'xxx' online;
drop table if exists t1;

drop table if exists resource_state_type;
CREATE TABLE resource_state_type
(
   name VARCHAR(32) NOT NULL,
   maxNumber INTEGER NOT NULL,
   PRIMARY KEY (name)
);

CREATE TABLE IF NOT EXISTS resource_state_type
(
   name VARCHAR(32) NOT NULL,
   maxNumber INTEGER NOT NULL,
   PRIMARY KEY (name)
);
drop table resource_state_type;


drop table if exists test_part_if_not_exist;
CREATE TABLE IF NOT EXISTS test_part_if_not_exist(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f3)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);

create table test_part_if_not_exist(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f3)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);
drop table test_part_if_not_exist;

create table if not exists TEST (fd int);
alter table  TEST enable row movement;
alter table  TEST DISABLE row movement;
alter TABLE  TEST shrink SPACE;
alter TABLE  TEST shrink SPACE COMPACT;
alter TABLE  TEST shrink SPACE CASCADE;
alter TABLE  TEST shrink SPACE COMPACT CASCADE;
drop table TEST;

--TEST for ALTER TABLE syntax
DROP TABLE IF EXISTS test_brackets_tbl;
CREATE TABLE test_brackets_tbl(col1 INTEGER NOT NULL, col2 CHAR(8), col3 VARCHAR(32));
--for unique constrant
ALTER TABLE test_brackets_tbl ADD CONSTRAINT const_brackets_uniq(col2);
ALTER TABLE test_brackets_tbl ADD (CONSTRAINT const_brackets_uniq UNIQUE(col3);
ALTER TABLE test_brackets_tbl ADD (CONSTRAINT const_brackets_uniq UNIQUE(col3)));
ALTER TABLE test_brackets_tbl ADD (CONSTRAINT const_brackets_uniq UNIQUE(col3) enab);
ALTER TABLE test_brackets_tbl ADD (CONSTRAINT const_brackets_uniq_01 UNIQUE(col3) ENABLE);
ALTER TABLE test_brackets_tbl ADD (CONSTRAINT const_brackets_uniq UNIQUE(col3) ) ENABLE;
ALTER TABLE test_brackets_tbl ADD ((CONSTRAINT const_brackets_uniq UNIQUE(col3) ) ENABLE);
ALTER TABLE test_brackets_tbl ADD ((CONSTRAINT const_brackets_uniq_02) UNIQUE(col2));
ALTER TABLE test_brackets_tbl ADD (CONSTRAINT const_brackets_uniq_02 UNIQUE(col2));

ALTER TABLE test_brackets_tbl DROP CONSTRAINT const_brackets_uniq_01;
ALTER TABLE test_brackets_tbl ADD ((CONSTRAINT const_brackets_uniq_03 UNIQUE(col3) VALIDATE /* COMMENT */ ) /* COMMENT */);

ALTER TABLE test_brackets_tbl DROP CONSTRAINT const_brackets_uniq_02;
ALTER TABLE test_brackets_tbl DROP CONSTRAINT const_brackets_uniq_03;

ALTER TABLE sys.test_brackets_tbl ADD ( CONSTRAINT const_brackets_uniq_02 UNIQUE (col2) NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE );    --esight's needs
ALTER TABLE test_brackets_tbl DROP CONSTRAINT const_brackets_uniq_02;

ALTER TABLE test_brackets_tbl ADD (CONSTRAINT const_brackets_uniq_02 UNIQUE(col2), CONSTRAINT const_brackets_uniq_03 UNIQUE(col3) RELY);  --only one constraint can be defined in add constraint clause

ALTER TABLE test_brackets_tbl MODIFY (col1 BIGINT);
ALTER TABLE test_brackets_tbl MODIFY (col1 BIGINT)));
ALTER TABLE test_brackets_tbl MODIFY (col1 BIGINT), col2 VARCHAR(32);
ALTER TABLE test_brackets_tbl MODIFY (col1 BIGINT, col2 VARCHAR(32));

ALTER TABLE sys.test_brackets_tbl ADD ( CONSTRAINT const_brackets_uniq_02 UNIQUE (col2) NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE );
ALTER TABLE test_brackets_tbl MODIFY (UNIQUE(col2);
ALTER TABLE test_brackets_tbl MODIFY (CONSTRAINT const_brackets_uniq_02 UNIQUE(col2) RELY) VALIDATE);

DROP TABLE test_brackets_tbl;

--DTS2018062701679
DROP TABLE IF EXISTS constraint_index_range_tbl_045;
create table constraint_index_range_tbl_045(c_id int,
c_d_id int NOT NULL,
c_w_id int,
c_first varchar(32),
c_middle char(2),
c_last varchar(32) NOT NULL,
c_street_1 varchar(20),
c_street_2 varchar(20),
c_city varchar(20) NOT NULL,
c_state char(2) NOT NULL,
c_zip char(9) NOT NULL,
c_phone char(16) NOT NULL,
c_since timestamp,
c_credit char(2) NOT NULL,
c_credit_lim numeric(12,2),
c_discount numeric(4,4),
c_balance numeric(12,2),
c_ytd_payment real NOT NULL,
c_payment_cnt number NOT NULL,
c_delivery_cnt bool NOT NULL,
c_end date NOT NULL,
c_vchar varchar(1000),
c_data clob,
c_text blob) partition by range(c_d_id,c_last) (partition PART_1 values less than (101,'BBBAR101'),partition PART_2 values less than (201,'CCBAR201'),partition PART_3 values less than (301,'DDBAR301'),partition PART_4 values less than (401,'EEBAR401'),partition PART_5 values less than (maxvalue,maxvalue));

select cons_name from SYS_CONSTRAINT_DEFS where cons_name like 'RGE_TBL_045%' order by 1;

alter table constraint_index_range_tbl_045 add constraint rge_tbl_045_constraint_001 unique(c_first,c_last) local;  --syntax error
alter table constraint_index_range_tbl_045 add constraint rge_tbl_045_constraint_003 primary key(c_last) online;  --syntax error
alter table constraint_index_range_tbl_045 add constraint rge_tbl_045_constraint_004 primary key(c_last) online online;  --syntax error
alter table constraint_index_range_tbl_045 add constraint rge_tbl_045_constraint_005 primary key(c_last) local local;  --syntax error
alter table constraint_index_range_tbl_045 add constraint rge_tbl_045_constraint_005 primary key(c_last) ,,;  --syntax error

alter table constraint_index_range_tbl_045 add constraint rge_tbl_045_constraint_002 primary key(c_last) enable;  --constraint state "enable" syntaxly compatable

select cons_name from SYS_CONSTRAINT_DEFS where cons_name like 'RGE_TBL_045%' order by 1;

DROP TABLE constraint_index_range_tbl_045;

DROP TABLE IF EXISTS  test;
create table test(id int constraint pk_id primary key, name varchar2(10));
alter table test Enable validate constraint ck_name;
alter table test Enable validate constraint pk_id;
alter table test add constraint ck_id check(id > 10);
select FLAGS from SYS_CONSTRAINT_DEFS join SYS_TABLES ON SYS_CONSTRAINT_DEFS.TABLE# = SYS_TABLES.ID and SYS_CONSTRAINT_DEFS.USER# = SYS_TABLES.USER# where SYS_CONSTRAINT_DEFS.CONS_NAME = 'CK_ID';
alter table test enable constraint ck_id;
select STATUS, VALIDATED from DBA_CONSTRAINTS where CONSTRAINT_NAME = 'CK_ID';
select STATUS, VALIDATED from ALL_CONSTRAINTS where CONSTRAINT_NAME = 'CK_ID';
select STATUS, VALIDATED from USER_CONSTRAINTS where CONSTRAINT_NAME = 'CK_ID';
select FLAGS from SYS_CONSTRAINT_DEFS join SYS_TABLES ON SYS_CONSTRAINT_DEFS.TABLE# = SYS_TABLES.ID and SYS_CONSTRAINT_DEFS.USER# = SYS_TABLES.USER# where SYS_CONSTRAINT_DEFS.CONS_NAME = 'CK_ID';
alter table test Enable validate constraint ck_id;
select FLAGS from SYS_CONSTRAINT_DEFS join SYS_TABLES ON SYS_CONSTRAINT_DEFS.TABLE# = SYS_TABLES.ID and SYS_CONSTRAINT_DEFS.USER# = SYS_TABLES.USER# where SYS_CONSTRAINT_DEFS.CONS_NAME = 'CK_ID';
alter table test Enable NOVALIDATE constraint ck_id;
select STATUS, VALIDATED from DBA_CONSTRAINTS where CONSTRAINT_NAME = 'CK_ID';
select STATUS, VALIDATED from ALL_CONSTRAINTS where CONSTRAINT_NAME = 'CK_ID';
select STATUS, VALIDATED from USER_CONSTRAINTS where CONSTRAINT_NAME = 'CK_ID';
select FLAGS from SYS_CONSTRAINT_DEFS join SYS_TABLES ON SYS_CONSTRAINT_DEFS.TABLE# = SYS_TABLES.ID and SYS_CONSTRAINT_DEFS.USER# = SYS_TABLES.USER# where SYS_CONSTRAINT_DEFS.CONS_NAME = 'CK_ID';
alter table test disable  constraint ck_id;
select STATUS, VALIDATED from DBA_CONSTRAINTS where CONSTRAINT_NAME = 'CK_ID';
select STATUS, VALIDATED from ALL_CONSTRAINTS where CONSTRAINT_NAME = 'CK_ID';
select STATUS, VALIDATED from USER_CONSTRAINTS where CONSTRAINT_NAME = 'CK_ID';
select FLAGS from SYS_CONSTRAINT_DEFS join SYS_TABLES ON SYS_CONSTRAINT_DEFS.TABLE# = SYS_TABLES.ID and SYS_CONSTRAINT_DEFS.USER# = SYS_TABLES.USER# where SYS_CONSTRAINT_DEFS.CONS_NAME = 'CK_ID';
alter table test disable validate  constraint ck_id;
select STATUS, VALIDATED from DBA_CONSTRAINTS where CONSTRAINT_NAME = 'CK_ID';
select STATUS, VALIDATED from ALL_CONSTRAINTS where CONSTRAINT_NAME = 'CK_ID';
select STATUS, VALIDATED from USER_CONSTRAINTS where CONSTRAINT_NAME = 'CK_ID';
select FLAGS from SYS_CONSTRAINT_DEFS join SYS_TABLES ON SYS_CONSTRAINT_DEFS.TABLE# = SYS_TABLES.ID and SYS_CONSTRAINT_DEFS.USER# = SYS_TABLES.USER# where SYS_CONSTRAINT_DEFS.CONS_NAME = 'CK_ID';
alter table test enable constraint ck_id;
insert into test values(5, 'Oracle');--failed
insert into test values(17,'ERP');--success
commit;
alter table test disable constraint ck_id;
insert into test values(5, 'Oracle');--success
select * from test  order by id;
alter table test enable novalidate constraint ck_id;
insert into test values(32, 'SAP');
insert into test values(3, 'Linux');
commit;
alter table test disable validate constraint ck_id;
select FLAGS from SYS_CONSTRAINT_DEFS join SYS_TABLES ON SYS_CONSTRAINT_DEFS.TABLE# = SYS_TABLES.ID and SYS_CONSTRAINT_DEFS.USER# = SYS_TABLES.USER# where SYS_CONSTRAINT_DEFS.CONS_NAME = 'CK_ID';
delete from test where id < 10;
commit;
alter table test disable validate constraint ck_id;
select * from test  order by id;
update test set name = 'update' where id = 32;
insert into test values(18, 'insert');
delete from test where id = 17;
alter table test disable novalidate constraint ck_id;
insert into test values(2, 'Linux');
insert into test values(13, 'Windows');
update test set name = 'Change' where id = 17;
commit;
select * from test  order by id;
DROP TABLE test;

DROP TABLE IF EXISTS  F_TAB;
DROP TABLE IF EXISTS  C_TAB;
CREATE TABLE F_TAB(FD_INT INT, FD_VARCHAR VARCHAR(100), CONSTRAINT PK_F_TAB PRIMARY KEY (FD_INT, FD_VARCHAR));
CREATE TABLE C_TAB(FD_INT INT PRIMARY KEY, FD_VARCHAR_2 VARCHAR(50), FD_VARCHAR VARCHAR(100), FD_INT_2 INT, FD_CLOB CLOB, CONSTRAINT RF_C_TAB FOREIGN KEY (FD_INT_2, FD_VARCHAR) REFERENCES F_TAB ON DELETE SET NULL);

ALTER TABLE C_TAB disable CONSTRAINT RF_C_TAB;
select FLAGS from SYS_CONSTRAINT_DEFS join SYS_TABLES ON SYS_CONSTRAINT_DEFS.TABLE# = SYS_TABLES.ID and SYS_CONSTRAINT_DEFS.USER# = SYS_TABLES.USER# where SYS_CONSTRAINT_DEFS.CONS_NAME = 'RF_C_TAB';
INSERT INTO F_TAB VALUES(1,'F_ABC');--success
INSERT INTO F_TAB VALUES(2,'F_ABC');--success
INSERT INTO C_TAB VALUES(1,'F_ABC', 'F_ABC', 1, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(2,'F_ABC','F_ABC', 2, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(3,'F_ABC','F_ABC', 3, '1234354587643123455213445656723123424554566776763221132454566768767433242323');--success
INSERT INTO C_TAB VALUES(4,'C_ABC', 'C_ABC', 1, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(5,'C_ABC','C_ABC', 2, '1234354587643123455213445656723123424554566776763221132454566768767433242323');--success
UPDATE C_TAB SET FD_INT_2 = 4 WHERE FD_INT = 1;--success
SELECT * FROM C_TAB ORDER BY FD_INT;--success

ALTER TABLE C_TAB enable validate CONSTRAINT RF_C_TAB;
select FLAGS from SYS_CONSTRAINT_DEFS join SYS_TABLES ON SYS_CONSTRAINT_DEFS.TABLE# = SYS_TABLES.ID and SYS_CONSTRAINT_DEFS.USER# = SYS_TABLES.USER# where SYS_CONSTRAINT_DEFS.CONS_NAME = 'RF_C_TAB';
ALTER TABLE C_TAB enable novalidate CONSTRAINT RF_C_TAB;
select FLAGS from SYS_CONSTRAINT_DEFS join SYS_TABLES ON SYS_CONSTRAINT_DEFS.TABLE# = SYS_TABLES.ID and SYS_CONSTRAINT_DEFS.USER# = SYS_TABLES.USER# where SYS_CONSTRAINT_DEFS.CONS_NAME = 'RF_C_TAB';
delete from C_TAB;
INSERT INTO C_TAB VALUES(1,'F_ABC', 'F_ABC', 1, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(3,'F_ABC','F_ABC', 3, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(2,'F_ABC','F_ABC', 2, '1234354587643123455213445656723123424554566776763221132454566768767433242323');--failed
INSERT INTO C_TAB VALUES(1,'C_ABC', 'C_ABC', 1, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(2,'C_ABC','C_ABC', 2, '1234354587643123455213445656723123424554566776763221132454566768767433242323');--failed
INSERT INTO C_TAB VALUES(1,'F_ABC', 'F_ABC', 1, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(2,'F_ABC','F_ABC', 2, '1234354587643123455213445656723123424554566776763221132454566768767433242323');--success
UPDATE C_TAB SET FD_INT_2 = 4 WHERE FD_INT = 1;--failed
SELECT * FROM C_TAB ORDER BY FD_INT;

ALTER TABLE C_TAB disable validate CONSTRAINT RF_C_TAB;
select FLAGS from SYS_CONSTRAINT_DEFS join SYS_TABLES ON SYS_CONSTRAINT_DEFS.TABLE# = SYS_TABLES.ID and SYS_CONSTRAINT_DEFS.USER# = SYS_TABLES.USER# where SYS_CONSTRAINT_DEFS.CONS_NAME = 'RF_C_TAB';
UPDATE C_TAB SET FD_INT_2 = 4 WHERE FD_INT = 1;--failed
INSERT INTO C_TAB VALUES(3,'F_ABC', 'F_ABC', 1, '1234354587643123455213445656723123424554566776763221132454566768767433242323');--failed
DELETE FROM C_TAB;--failed
DROP TABLE C_TAB;
DROP TABLE F_TAB;

DROP TABLE IF EXISTS TEST;
CREATE TABLE TEST(FD varchar(100) DEFAULT 10 NOT NULL);
DESC TEST;
select DEFAULT_TEXT from SYS_COLUMNS JOIN SYS_TABLES ON SYS_COLUMNS.USER#=SYS_TABLES.USER# AND SYS_COLUMNS.TABLE#=SYS_TABLES.ID where SYS_TABLES.NAME = 'TEST' AND SYS_COLUMNS.NAME='FD';
ALTER TABLE TEST MODIFY FD;
DESC TEST;
select DEFAULT_TEXT from SYS_COLUMNS JOIN SYS_TABLES ON SYS_COLUMNS.USER#=SYS_TABLES.USER# AND SYS_COLUMNS.TABLE#=SYS_TABLES.ID where SYS_TABLES.NAME = 'TEST' AND SYS_COLUMNS.NAME='FD';
ALTER TABLE TEST MODIFY FD CONSTRAINT CK_FD CHECK (FD IN ('SUCCESSFUL','FAILURE','PARTIAL_SUCCESS'));--todo alter table support inline constraint
DESC TEST;
SELECT count(*) FROM USER_CONSTRAINTS WHERE CONSTRAINT_NAME = 'CK_FD';
ALTER TABLE TEST MODIFY FD varchar(50) default 20;
DESC TEST;
select DEFAULT_TEXT from SYS_COLUMNS JOIN SYS_TABLES ON SYS_COLUMNS.USER#=SYS_TABLES.USER# AND SYS_COLUMNS.TABLE#=SYS_TABLES.ID where SYS_TABLES.NAME = 'TEST' AND SYS_COLUMNS.NAME='FD';
DROP TABLE TEST;

DROP TABLE IF EXISTS ALT_INLINE_CSTR;
CREATE TABLE ALT_INLINE_CSTR(C1 INT);
ALTER TABLE ALT_INLINE_CSTR ADD C2 INT UNIQUE;
ALTER TABLE ALT_INLINE_CSTR ADD C3 INT PRIMARY KEY;
INSERT INTO ALT_INLINE_CSTR VALUES(1, 1, NULL);
ALTER TABLE ALT_INLINE_CSTR ADD C4 INT;
INSERT INTO ALT_INLINE_CSTR VALUES(1, 1, 1, 1);
ALTER TABLE ALT_INLINE_CSTR MODIFY C4 UNIQUE;
SELECT i.ID, i.COLS, i.IS_PRIMARY, i.IS_UNIQUE FROM SYS_INDEXES i, SYS_TABLES t WHERE t.name='ALT_INLINE_CSTR' AND t.USER#=i.USER# AND t.ID=i.TABLE# ORDER BY i.ID;
DROP TABLE ALT_INLINE_CSTR PURGE;
--multi-column support
DROP TABLE IF EXISTS t_foobar;
CREATE TABLE t_foobar (col1 INTEGER NOT NULL, col2 VARCHAR(32));
DESC t_foobar;

ALTER TABLE t_foobar MODIFY (col1 INTEGER DEFAULT 0, col1 CHAR(64) NOT NULL);
ALTER TABLE t_foobar MODIFY col1 INTEGER DEFAULT 0, col1 CHAR(64) NOT NULL;
ALTER TABLE t_foobar MODIFY (col1 REAL, col3 VARCHAR(32));
DESC t_foobar;
ALTER TABLE t_foobar MODIFY (col1 INTEGER DEFAULT 0, col2 CHAR(64) NOT NULL);
DESC t_foobar;
ALTER TABLE t_foobar MODIFY (col1 INTEGER NOT NULL);
DESC t_foobar;

ALTER TABLE t_foobar ADD (col3 INTEGER NOT NULL, col3 REAL);
ALTER TABLE t_foobar ADD col3 INTEGER NOT NULL, col4 REAL;
ALTER TABLE t_foobar ADD (col3 INTEGER NOT NULL, col4 REAL);
ALTER TABLE t_foobar ADD (col5 INTEGER NOT NULL, COLUMN col6 REAL);
ALTER TABLE t_foobar ADD (COLUMN col7 INTEGER NOT NULL, COLUMN col8 REAL);
DESC t_foobar;

ALTER TABLE t_foobar ADD (UNIQUE (col3, col5), PRIMARY KEY(col1));
ALTER TABLE t_foobar ADD COLUMN UNIQUE (col3, col5);
ALTER TABLE t_foobar ADD UNIQUE (col3, col5), PRIMARY KEY(col1);
ALTER TABLE t_foobar ADD UNIQUE (col3, col5);  --success
ALTER TABLE t_foobar MODIFY(col3 VARCHAR(10), c999 INTEGER); --error
DESC t_foobar;
DROP TABLE t_foobar;

DROP TABLE IF EXISTS t_foobar;
CREATE TABLE t_foobar(
c_id int, c_integer integer,
c_real real,c_float float, c_cdouble binary_double,
c_decimal decimal(38), c_number number(38),c_number1 number,c_number2 number(20,10),c_numeric numeric(38),
c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
c_clob clob,
c_raw raw(20),c_blob blob,
c_date date,c_timestamp timestamp
);

ALTER TABLE t_foobar MODIFY (c_id int,c_char char(50),c_cdouble not null, c_varchar varchar(22),c_numeric numeric);
ALTER TABLE t_foobar MODIFY (c_id int,c_char char(50));
ALTER TABLE t_foobar MODIFY (c_numeric numeric);
ALTER TABLE t_foobar MODIFY (c_cdouble not null, c_varchar varchar(22));
DROP TABLE t_foobar;

DROP TABLE IF EXISTS test_multi_add;
CREATE TABLE test_multi_add(id INT, c1 VARCHAR(10), c2 BIGINT, c3 CHAR(10)) PARTITION BY RANGE(id) (PARTITION p1 VALUES LESS THAN(10), PARTITION p2 VALUES LESS THAN(20), PARTITION p3 VALUES LESS THAN(MAXVALUE));
INSERT INTO test_multi_add VALUES(1, 'c1', 111, 'c3'), (11, 'c1', 222, 'c3'), (21, 'c1', 333, 'c3');
ALTER TABLE test_multi_add DROP c1;
ALTER TABLE test_multi_add DROP c3;
ALTER TABLE test_multi_add ADD (col_1 INT, col_2 BIGINT DEFAULT 98765432123, col_3 CHAR(10) DEFAULT 'ABCDEFG', col_4 VARCHAR(10), col_5 CLOB DEFAULT 'STORM, EARTH AND FIRE, HEAR MY CALL');
SELECT * FROM test_multi_add ORDER BY id;
DROP TABLE test_multi_add PURGE;

DROP TABLE IF EXISTS test_multi_modify;
DROP TABLE IF EXISTS test_index_entry1;
DROP TABLE IF EXISTS test_index_entry2;
CREATE TABLE test_index_entry1(table_name VARCHAR(100), index_name VARCHAR(100), entry BIGINT);
CREATE TABLE test_index_entry2(table_name VARCHAR(100), index_name VARCHAR(100), entry BIGINT);
CREATE TABLE test_multi_modify(id INT, col_1 INT, col_2 BIGINT DEFAULT 98765432123, col_3 CHAR(10) DEFAULT 'ABCDEFG', col_4 VARCHAR(10), col_5 CLOB DEFAULT 'I STAND READY');
INSERT INTO test_multi_modify(id, col_1, col_4) VALUES(1, 2, 'c4'), (11, 222, 'c3'), (21, 333, 'c4');
CREATE INDEX ix_test_multi_01 ON test_multi_modify(id, col_1);
CREATE INDEX ix_test_multi_02 ON test_multi_modify(col_1, col_2);
CREATE INDEX ix_test_multi_03 ON test_multi_modify(id, col_3);
INSERT INTO test_index_entry1 SELECT T.name, I.name, I.entry FROM sys_tables T, sys_indexes I WHERE T.user#=I.user# AND T.id = I.table# AND T.name='TEST_MULTI_MODIFY';
COMMIT;
UPDATE test_multi_modify SET col_1=null, col_2=null;
ALTER TABLE test_multi_modify MODIFY (col_1 NUMBER(10, 4), col_2 INTEGER, col_3 VARCHAR(100));
INSERT INTO test_index_entry2 SELECT T.name, I.name, I.entry FROM sys_tables T, sys_indexes I WHERE T.user#=I.user# AND T.id = I.table# AND T.name='TEST_MULTI_MODIFY';
COMMIT;
SELECT E1.table_name, E1.index_name FROM test_index_entry1 E1, test_index_entry2 E2 WHERE E1.table_name=E2.table_name AND E1.index_name = E2.index_name AND E1.entry = E2.entry;
SELECT * FROM test_multi_modify ORDER BY id;
DROP TABLE test_multi_modify PURGE;
DROP TABLE test_index_entry1 PURGE;
DROP TABLE test_index_entry2 PURGE;

-- TEST alter table add column auto_increment
-- 1 FAIL
DROP TABLE IF EXISTS ALT_TEST;
CREATE TABLE ALT_TEST
(
	F1 INT NOT NULL AUTO_INCREMENT UNIQUE,
	F2 VARCHAR(10)
);
ALTER TABLE ALT_TEST ADD COLUMN F3 INT NOT NULL AUTO_INCREMENT UNIQUE;

-- 2 FAIL
DROP TABLE IF EXISTS ALT_TEST;
CREATE TABLE ALT_TEST
(
	F2 VARCHAR(10)
);
ALTER TABLE ALT_TEST ADD COLUMN F1 VARCHAR(10) AUTO_INCREMENT UNIQUE;

-- 3 FAIL
DROP TABLE IF EXISTS ALT_TEST;
CREATE TABLE ALT_TEST
(
	F2 VARCHAR(10)
);
ALTER TABLE ALT_TEST ADD (COLUMN F1 INT AUTO_INCREMENT UNIQUE, COLUMN F3 INT AUTO_INCREMENT);

-- 4 FAIL
DROP TABLE IF EXISTS ALT_TEST;
CREATE TABLE ALT_TEST
(
	F1 VARCHAR(10)
);
ALTER TABLE ALT_TEST ADD (COLUMN F2 INT AUTO_INCREMENT UNIQUE DEFAULT 0);

-- 5 SUCC
DROP TABLE IF EXISTS ALT_TEST;
CREATE TABLE ALT_TEST
(
	F1 VARCHAR(10)
);
ALTER TABLE ALT_TEST ADD (COLUMN F2 INT AUTO_INCREMENT UNIQUE);
INSERT INTO ALT_TEST VALUES ('A', NULL), ('B', NULL), ('C', NULL);
SELECT * FROM ALT_TEST ORDER BY F2;

-- 6 SUCC
DROP TABLE IF EXISTS ALT_TEST;
CREATE TABLE ALT_TEST
(
	F1 VARCHAR(10)
);
ALTER TABLE ALT_TEST ADD (COLUMN F2 BIGINT AUTO_INCREMENT UNIQUE, COLUMN F3 VARCHAR(10) DEFAULT 'AAAA');
INSERT INTO ALT_TEST (F1, F2) VALUES ('A', NULL), ('B', NULL), ('C', NULL);
SELECT * FROM ALT_TEST ORDER BY F2 DESC;

-- 7 SUCC
DROP TABLE IF EXISTS ALT_TEST;
CREATE TABLE ALT_TEST
(
	F1 VARCHAR(10)
);
ALTER TABLE ALT_TEST ADD COLUMN F2 INT AUTO_INCREMENT PRIMARY KEY;
INSERT INTO ALT_TEST (F1, F2) VALUES ('A', NULL), ('B', NULL), ('C', NULL);
SELECT * FROM ALT_TEST ORDER BY F2 ASC;

-- 8 SUCC, Oracle inline constraint关键字是 primary key/unique, 对于key/unique key不支持
--         Mysql 支持key/primary key/unique key
DROP TABLE IF EXISTS ALT_TEST;
CREATE TABLE ALT_TEST
(
	F1 VARCHAR(10)
);
ALTER TABLE ALT_TEST ADD COLUMN F2 INT AUTO_INCREMENT UNIQUE;
INSERT INTO ALT_TEST (F1, F2) VALUES ('A', NULL), ('B', NULL), ('C', NULL);
SELECT * FROM ALT_TEST ORDER BY F2 ASC;


-- 9 FAIL
DROP TABLE IF EXISTS ALT_TEST;
CREATE TABLE ALT_TEST
(
	F1 VARCHAR(10)
);
-- ERR, 只有 PRIMARY KEY/UNIQUE 合法; 跟oracle一致, 跟mysql有些出入
ALTER TABLE ALT_TEST ADD COLUMN F2 INT AUTO_INCREMENT UNIQUE KEY;
ALTER TABLE ALT_TEST ADD COLUMN F2 INT AUTO_INCREMENT KEY;
ALTER TABLE ALT_TEST ADD COLUMN F2 INT AUTO_INCREMENT PRIMARY;

-- 10 SUCC
DROP TABLE IF EXISTS ALT_TEST;
CREATE TABLE ALT_TEST
(
	F1 VARCHAR(10)
);
INSERT INTO ALT_TEST VALUES ('A'),('B'),('C'),('D');
ALTER TABLE ALT_TEST ADD COLUMN F2 INT AUTO_INCREMENT PRIMARY KEY;
SELECT * FROM ALT_TEST ORDER BY F2;
INSERT INTO ALT_TEST (F1) VALUES ('D'),('E');
SELECT * FROM ALT_TEST ORDER BY F2 DESC;

INSERT INTO ALT_TEST VALUES ('P', NULL), ('Q', 1000), ('Z', NULL);
SELECT * FROM ALT_TEST ORDER BY F2 DESC;

DROP TABLE IF EXISTS check_test_t;
CREATE TABLE check_test_t(a INT, CHECK(a IN(NULL, 2)), b INT);
ALTER TABLE check_test_t MODIFY a DATE;
drop table if exists cjb%  ;
drop table if exists cjb%  b;


conn sys/Huawei@123@127.0.0.1:1611
create user test_altertable_dropcolumn identified by Lh00420062;
grant dba to test_altertable_dropcolumn;
conn test_altertable_dropcolumn/Lh00420062@127.0.0.1:1611

drop table if exists YY;
drop table if exists YYY;
create table YY (id number,name varchar(13), create_time timestamp);
CREATE SEQUENCE k START WITH 1 INCREMENT BY 1;
create table YYY (id INT,name VARCHAR(30), sal int);
--创建view
create or replace view YF_view_2 as select name from YY where length(name)>3;  
--创建触发器
create or replace trigger DEL_YF_000 AFTER INSERT ON YYY
BEGIN
  INSERT INTO YY VALUES(k.nextval,'after insert',systimestamp);
END;
/
insert into YYY values (2,'xiaoming',50);

create or replace function YF_FUN(n number) 
return number is
v_n number;
begin
select length(name) into v_n  from YY where length(name)>2;
return v_n;
exception 
when no_data_found then
dbe_output.print_line('date not exists!');
when others then
dbe_output.print_line('other error!');
commit;
end;
/

CREATE OR REPLACE PROCEDURE YF_cunchu_2 IS 
BEGIN  
update YY set name='tiantian' where name = 'after insert';  
COMMIT;
END;
/

alter table YY rename column name to myname;
commit;

select status from all_objects where OBJECT_NAME='YF_VIEW_2';
select status from all_objects where OBJECT_NAME='DEL_YF_000';
select status from all_objects where OBJECT_NAME='YF_FUN';
select status from all_objects where OBJECT_NAME='YF_CUNCHU_2';

drop table if exists YY;
drop table if exists YYY;
drop sequence if exists k;
drop view if exists YF_view_2;
drop procedure if exists YF_cunchu_2;
drop function if exists YF_FUN;
drop trigger if exists del_YF_000;

conn sys/Huawei@123@127.0.0.1:1611
drop user test_altertable_dropcolumn cascade;

create user test_altertable_renamecolumn identified by Lh00420062;
grant dba to test_altertable_renamecolumn;
conn test_altertable_renamecolumn/Lh00420062@127.0.0.1:1611

drop table if exists YY;
drop table if exists YYY;
create table YY (id number,name varchar(13), create_time timestamp);
CREATE SEQUENCE k START WITH 1 INCREMENT BY 1;
create table YYY (id INT,name VARCHAR(30), sal int);
--创建view
create or replace view YF_view_2 as select name from YY where length(name)>3;  
--创建触发器
create or replace trigger DEL_YF_000 AFTER INSERT ON YYY
BEGIN
  INSERT INTO YY VALUES(k.nextval,'after insert',systimestamp);
END;
/
insert into YYY values (2,'xiaoming',50);

create or replace function YF_FUN(n number) 
return number is
v_n number;
begin
select length(name) into v_n  from YY where length(name)>2;
return v_n;
exception 
when no_data_found then
dbe_output.print_line('date not exists!');
when others then
dbe_output.print_line('other error!');
commit;
end;
/

CREATE OR REPLACE PROCEDURE YF_cunchu_2 IS 
BEGIN  
update YY set name='tiantian' where name = 'after insert';  
COMMIT;
END;
/

alter table YY drop name;
commit;

select status from all_objects where OBJECT_NAME='YF_VIEW_2';
select status from all_objects where OBJECT_NAME='DEL_YF_000';
select status from all_objects where OBJECT_NAME='YF_FUN';
select status from all_objects where OBJECT_NAME='YF_CUNCHU_2';

drop table if exists YY;
drop table if exists YYY;
drop sequence if exists k;
drop view if exists YF_view_2;
drop procedure if exists YF_cunchu_2;
drop function if exists YF_FUN;
drop trigger if exists del_YF_000;
conn sys/Huawei@123@127.0.0.1:1611
drop user test_altertable_renamecolumn cascade;

create table t1(c1 varbinary(16) not null, c2 varchar(60) not null, c3 bigint not null,
           c4 varchar(8000), c5 varchar(128), c6 varchar(128), c7 varchar(256),
          c8 varchar(128),c9 varchar(128),c10 varchar(128),c11 varchar(128));

alter table t1 add column c12 varchar(128);
alter table t1 add column c13 varchar(128);
alter table t1 drop  c13;
alter table t1 drop  c12;
alter table t1 drop  c11;
alter table t1 drop  c10;
insert into t1(c1, c2 ,c3,c4,c5)  values('aaa','bbb',123,'ccccc','dddd');
alter table t1 modify  c8 varchar(1000) default 'auto';
select * from t1;
alter table t1 modify  c10 varchar(1000) default 'auto';

create table test_default(a int, b int);
insert into test_default values(1, 1);
alter table test_default drop column b;
alter table test_default add column c int default 10;
select * from test_default;

drop table if exists test_char_char;
create table test_char_char(ic varchar(10 char), jc char(10 char), ib varchar(10 byte), jb char(10 byte));
desc test_char_char;
alter table test_char_char modify ic char(100);
alter table test_char_char modify jc varchar(100);
alter table test_char_char modify ib char(100 char);
alter table test_char_char modify jb varchar(100 char);
desc test_char_char;
alter table test_char_char modify ic nvarchar(10);
desc test_char_char;
drop table test_char_char;

drop table if exists t_con_base_001;
create table t_con_base_001(id int,c_int int,c_vchar varchar(100),c_clob clob,c_blob blob,c_date date) AUTO_INCREMENT=9;  
alter table t_con_base_001 add constraint t_con_base_001_con_001 check(c_int>10 and c_vchar>'a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a00000000000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');
drop table t_con_base_001;


drop table if exists t_abc_001;
create table t_abc_001(a varchar(10) null, b clob null);
alter table t_abc_001 modify a varchar(10) null;
alter table t_abc_001 modify b clob null;
alter table t_abc_001 modify b default 'abc';
desc t_abc_001;
drop table t_abc_001;

drop table if exists column_test;
create table column_test(c_id int, c_char1 varchar(10), c_char2 varchar(10), c_char3 varchar(10), c_char4 varchar(10));
declare 
i integer;
begin
for i in 1 .. 10 loop
insert into column_test values(1, 'a', null, 'c', 'd');
end loop;
commit;
end;
/
alter table column_test add col_uint_1 int;
alter table column_test add col_uint_2 int;
alter table column_test drop column col_uint_1;
alter table column_test drop column col_uint_2;
alter table column_test modify c_char2 varchar(10) default 'f';
drop  table  column_test;

drop table if exists tbl_hash;
create table tbl_hash(col_int int, col_real real);
create index if not exists idx_tbl_hash_global_02 on tbl_hash(col_int,col_real asc);
insert into tbl_hash values (1,2.00);
insert into tbl_hash values (1,2.00);
commit;
alter table tbl_hash add col_uint_1 uint;
update tbl_hash set col_real=null;
commit;
alter table tbl_hash modify (col_real uint default 67.34 on update convert(45.3,uint) comment 'real modify uint' collate UTF8_BIN check(col_real>3));
drop table if exists tbl_hash;

--test shrink system table
alter table SYS_TABLES shrink space;
alter table SYS_INDEXES shrink space;
alter table SYS_SQL_MAPS shrink space;
alter table WSR_SQL_LIST_PLAN shrink space;
alter table WSR_DBA_SEGMENTS shrink space;

drop table if exists tbl_hash;
create table tbl_hash(
col_int int,
col_integer integer,
col_int_unsigned integer unsigned default 1,
col_binary_uint32 binary_uint32 not null default 4294967295,
col_uint UINT default 45465,
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
partition by hash(col_int_unsigned,col_int,col_varchar_200)
(
  partition p_hash_01 ,
  partition p_hash_02 ,
  partition p_hash_03 ,
  partition p_hash_04 ,
  partition p_hash_05 ,
  partition p_hash_06 ,
  partition p_hash_07 
) ;

create or replace procedure proc_insertdata(tablename varchar,start_num int,end_num int) is
i int :=1;
sql_str varchar(3000) ;
begin
for i in start_num..end_num loop
    sql_str:='insert into ' || tablename || '(col_int,col_integer,col_int_unsigned ,col_binary_uint32,col_uint,col_BINARY_INTEGER,col_smallint,col_bigint,col_BINARY_BIGINT,col_real,col_double,col_float,col_BINARY_DOUBLE ,col_decimal,col_number1,col_number2,col_number3,col_number4,col_number5,col_numeric,col_char1,col_char2,col_nchar1,col_nchar2,col_varchar_200,col_varchar_8000,col_varchar2_1000,col_varchar2_8000,col_nvarchar1,col_nvarchar2,col_nvarchar2_1000,col_nvarchar2_8000,col_clob,col_text,col_longtext,col_image,col_binary1,col_binary2,col_varbinary1,col_varbinary2,col_raw1,col_raw2,col_blob,col_date,col_datetime,col_timestamp1,col_timestamp2,col_timestamp3,col_timestamp4,col_bool,col_boolean,col_interval1,col_interval2) values(' || i || ',' || i || ',' || i || ',' || i || ',' || i || ',' || i || ',' || i || ',' || i*1000 || ',' || i*100 || ',' || i*10 || ',' || i*5.32 || ',' || i*1.235 || ',' || i*2.546 || ',' || i*5.24 || ',' || i*6.65 || ',' || i*5.34 || ',' || i*56.45 || ',' || '0' || ',' || i*3.34 || ',' || i*50.2 || ',' || '''' || 'sdf' || '''||' || i || ',' || 'lpad(''we'',40,''gfgf'') ||' || i*13 || ',' || 'lpad(''cv'',20,''nhbn'') ||' || i*17 || ',' || i*160 || ',' || 'lpad(''dsfds'',50,''ghg'') ||' || i || ',' || 'lpad(''vngvf'',7000,''mbnyt'') ||' || i || ',' || 'lpad(''CN'',90,''vcQW'') ||' || i || ',' || 'rpad(''rtFD'',7500,''jkHU'') ||' || i || ',' || 'rpad(''fg'',50,''FDGs'') ||' || i || ',' || 'lpad(''hgjYU'',7800,''HWERa'') ||' || i || ',' || 'lpad(''OK'',60,''wqe'') ||' || i || ',' || 'lpad(''NOCN'',7900,''ewtwb'') ||' || i || ',' || 'lpad(''wtrew'',8000,''d345gfgd'') ||' || i || ',' || 'lpad(''g4gf5DF'',8000,''fg5D'') ||' || i || ',' || 'lpad(''fgdgtr'',8000,''fdgd5'') ||' || i || ',' || 'lpad(''dvgfsvgds'',8000,''retrbv'') ||' || i || ',' || i || ',' || i || ',' || i || ',' || i || ',' || '''' || i || '''' || ',' || '''' || i || '''' || ',' || '''' || i || '''' || ',' || 'add_months(''2018-01-01'',' || i || ')' || ',' || 'add_months(''2018-01-10 08:10:10'',' || i || ')' || ',' || 'add_months(to_timestamp(''2018-01-21 09:10:30.45'',''YYYY-MM-DD HH24:MI:SS.FF''),' || i || ')' || ',' || 'add_months(to_timestamp(''2007-05-06 11:30:20.56'',''YYYY-MM-DD HH24:MI:SS.FF''),' || i || ')' || ',' || 'add_months(''2008-08-08'',' || i || ')' || ',' || 'add_months(''2008-07-01'',' || i || ')' || ',' || 'true' || ',' || 'false' || ',' || 'numtoyminterval(' || i || ',''year'')+numtoyminterval(' || i || ',''month'')' || ',' || 'to_dsinterval(' || '''' || i || ' 05:30:56' || '''' || ')' || ')';
  --dbe_output.print_line(sql_str);
   execute immediate sql_str;
end loop;
end;
/

alter table tbl_hash modify col_real uint default 67.34 on update convert(45.3,uint);
call proc_insertdata('tbl_hash',1,50);

update tbl_hash set col_uint=null where col_uint>20 and col_uint<25;
update tbl_hash set col_binary_uint32=0 where  col_binary_uint32=1;
update tbl_hash set col_binary_uint32=4294967295 where  col_binary_uint32=50;
commit;
alter table tbl_hash modify col_real uint default 67.34;
drop table tbl_hash;
drop procedure proc_insertdata;

--more cases
drop function if exists test_f1;
create function test_f1(a int) return int
IS
Begin
return a*-1;
End;
/

drop function if exists test_f2;
create function test_f2() return int
IS
Begin
return 566;
End;
/

drop table if exists test_t1;
create table test_t1 (
    c1 int not null default( 1     + 2  + sqrt(abs(test_f1(100+21)))),
    c2 int not null default (1+33*3+test_f2()) on update sqrt(abs(test_f1(-16)))*222,
    c3 int not null check(c3 < 63333 AND sqrt(abs(test_f1(c3))) > 2)
);

desc test_t1;
alter table test_t1 add CONSTRAINT check_test1 check (c3 > 0);
insert into test_t1(c3) values(9);
insert into test_t1(c3) values(4);
insert into test_t1(c3) values(99);
insert into test_t1(c3) values(999);
insert into test_t1(c3) values(-999);
insert into test_t1(c3) values(99999);
alter table test_t1 drop CONSTRAINT check_test1;
insert into test_t1(c3) values(-999);
update test_t1 set c3=c3-1 where c3=999;
commit;
select * from test_t1;
drop function if exists test_f2;
create function test_f2() return int
IS
Begin
return 766;
End;
/

insert into test_t1(c3) values(1999);
commit;
select * from test_t1;
alter table test_t1 add c4 varchar(100) default sys_guid();
drop table if exists test_t1;
drop function if exists test_f1;
drop function if exists test_f2;

drop table if exists t1_jdd;
create table t1_jdd (c1 int default ( 1     + 2  + abs(100) ), c2 int default ( 100*58     + 201  + abs(100) ), c3 int default ( 111 *6    + 988  + abs(100) ), CONSTRAINT check_test1 check (c1 + c2 * c3 +     abs(c1) > 3));
alter table t1_jdd rename column c1 to col_integer_2;
alter table t1_jdd drop column c1;
desc t1_jdd;
drop table if exists t1_jdd;

drop table if exists test_jdd;
create table test_jdd(id int ,name varchar(10) constraint UNIQUE_001 unique);
alter table test_jdd add col_integer integer constraint check_add_001 check(col_integer>=10);
alter table test_jdd rename column id to id_2;
alter table test_jdd rename column col_integer to col_integer_2;
desc test_jdd;
drop table if exists test_jdd;

drop table if exists test_check_rename_jdd;
drop table if exists AAAAAAA;
create table AAAAAAA(id int not null primary key, name varchar(100));
create table test_check_rename_jdd(a int not null primary key, b int not null unique, c int check(c > 0), d int not null unique);
alter table test_check_rename_jdd add CONSTRAINT fffffffff FOREIGN KEY(d) REFERENCES AAAAAAA(id);
alter table test_check_rename_jdd rename column a to a_2;
alter table test_check_rename_jdd rename column b to b_2;
alter table test_check_rename_jdd rename column c to c_2;
alter table test_check_rename_jdd rename column d to d_2;
desc test_check_rename_jdd;
drop table if exists test_check_rename_jdd;
drop table if exists AAAAAAA;
drop table if exists test_modify_lob;
create table test_modify_lob(a int, b clob) partition by hash(a)(partition p1, partition p2);
alter table test_modify_lob modify b int;
drop table if exists test_modify_lob;

drop table if exists test_pct_free;
create table test_pct_free(a int);
insert into test_pct_free values(1);
alter table test_pct_free pctfree 15;
drop table if exists test_pct_free;

drop table if exists test_shrink_lob;
create table test_shrink_lob(a clob);
create view view_test_shrink_lob(a) as select a from test_shrink_lob;
drop view if exists view_test_shrink_lob;
drop table if exists test_shrink_lob;

--DTS2019080114849
create or replace package pack1 is
function f2 return number;
end;
/
create or replace package body pack1 is
function f2 return number 
as
a number;
begin
a:= 1;
return(a);
end f2;
end pack1;
/
select object_name,object_type from all_objects where object_name='PACK1';
select object_name,object_type from dba_objects where object_name='PACK1';
select object_name,object_type from user_objects where object_name='PACK1';
select object_name,object_type from adm_objects where object_name='PACK1';
select object_name,object_type from db_objects where object_name='PACK1';
select object_name,object_type from my_objects where object_name='PACK1';
drop package pack1;

drop table if exists TEST_DROP;
create table TEST_DROP(c_char1 varchar(8000), c_char2 varchar(8000),  c_char3 varchar(8000),  c_char4 varchar(8000),
 c_char5 varchar(8000),  c_char6 varchar(8000),  c_char7 varchar(8000), c_char8 varchar(8000),
 c_char9 varchar(8000), c_char10 varchar(8000), c_char11 varchar(8000), c_char12 varchar(8000),
 c_char13 varchar(8000), c_char14 varchar(8000), c_char15 varchar(8000), c_char16 varchar(8000), id int) crmode page;

insert into TEST_DROP(id, c_char1,c_char2,c_char3,c_char4,c_char5,c_char6,c_char7,c_char8)  values(10, lpad('a', 7000, 'a'), lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),
lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),lpad('a', 7000, 'a'));
insert into TEST_DROP(id, c_char1,c_char2,c_char3,c_char4,c_char5,c_char6,c_char7,c_char8)  values(20, lpad('a', 7000, 'a'), lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),
lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),lpad('a', 7000, 'a'));
commit;

alter table TEST_DROP drop column c_char1;
alter table TEST_DROP drop column c_char2;
alter table TEST_DROP drop column c_char3;
alter table TEST_DROP drop column c_char4;
alter table TEST_DROP drop column c_char5;
alter table TEST_DROP drop column c_char6;
alter table TEST_DROP drop column c_char7;
alter table TEST_DROP drop column c_char8;

update TEST_DROP set id = 60, c_char9 = lpad('a', 7000, 'a'), c_char10 = lpad('a', 7000, 'a'), c_char11 = lpad('a', 7000, 'a'), c_char12 = lpad('a', 7000, 'a'),
c_char13 = lpad('a', 7000, 'a'), c_char14 = lpad('a', 7000, 'a'), c_char15 = lpad('a', 7000, 'a'), c_char16 = lpad('a', 7000, 'a');

drop table if exists TEST_DROP;
create table TEST_DROP(c_char1 varchar(8000), c_char2 varchar(8000),  c_char3 varchar(8000),  c_char4 varchar(8000),
 c_char5 varchar(8000),  c_char6 varchar(8000),  c_char7 varchar(8000), c_char8 varchar(8000),
 c_char9 varchar(8000), c_char10 varchar(8000), c_char11 varchar(8000), c_char12 varchar(8000),
 c_char13 varchar(8000), c_char14 varchar(8000), c_char15 varchar(8000), c_char16 varchar(8000), id int) crmode row;

insert into TEST_DROP(id, c_char1,c_char2,c_char3,c_char4,c_char5,c_char6,c_char7,c_char8)  values(10, lpad('a', 7000, 'a'), lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),
lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),lpad('a', 7000, 'a'));
insert into TEST_DROP(id, c_char1,c_char2,c_char3,c_char4,c_char5,c_char6,c_char7,c_char8)  values(20, lpad('a', 7000, 'a'), lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),
lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),lpad('a', 7000, 'a'),lpad('a', 7000, 'a'));
commit;

alter table TEST_DROP drop column c_char1;
alter table TEST_DROP drop column c_char2;
alter table TEST_DROP drop column c_char3;
alter table TEST_DROP drop column c_char4;
alter table TEST_DROP drop column c_char5;
alter table TEST_DROP drop column c_char6;
alter table TEST_DROP drop column c_char7;
alter table TEST_DROP drop column c_char8;

update TEST_DROP set id = 60, c_char9 = lpad('a', 7000, 'a'), c_char10 = lpad('a', 7000, 'a'), c_char11 = lpad('a', 7000, 'a'), c_char12 = lpad('a', 7000, 'a'),
c_char13 = lpad('a', 7000, 'a'), c_char14 = lpad('a', 7000, 'a'), c_char15 = lpad('a', 7000, 'a'), c_char16 = lpad('a', 7000, 'a');
drop table if exists TEST_DROP;
drop table if exists test_csf;
create table test_csf(c_id int, c_char1 varchar(100), c_char2 varchar(100)) format csf;

insert into test_csf values(1, 'a', 'a');
insert into test_csf values(2, 'b', 'b');

select flag from table$ where name = 'TEST_CSF';
drop table if exists test_csf;

--DTS2019101802654
drop table if exists sc;
create table sc (
    studentno    integer,
    courseid    integer,
    score    integer,
    CONSTRAINT  aaab primary key (studentno) );
	
alter table sc modify studentno null;
drop table if exists sc;

--DTS2019121004245
create table test_tab(id int,name1 varchar(20) default 'aaa');
insert into test_tab(id) values(1);
commit;
select * from test_tab;
alter table test_tab add column name2 varchar(20) default 'aaa' on update 'bbb';
select * from test_tab;
drop table test_tab;

--test example no index
drop table if exists t_test;
create table t_test(a int, b int);
insert into t_test values (3,4),(5,6),(7,8);
alter table t_test modify a bigint;
select * from t_test where a>2 order by 1,2;
update t_test set a=a+1 where a>2;
select * from t_test order by 1,2;
delete from t_test where a>2;
select * from t_test order by 1,2;
insert into t_test values (3,4),(5,6),(7,8);
alter table t_test modify b bigint;
insert into t_test values (3,4),(5,6),(7,8);
select * from t_test order by 1,2;

--test example index
drop table if exists t_test_ind;
create table t_test_ind(a int, b int);
insert into t_test_ind values (3,4),(5,6),(7,8);
create index t_ind22 on t_test_ind(a);
select * from t_test_ind where a>2 order by 1,2;
alter table t_test_ind modify a bigint;
select * from t_test_ind where a>2 order by 1,2;
update t_test_ind set a=a+1 where a>2;

--test example trigger
drop table if exists t_test_trig;
create table t_test_trig(a int, b int,c int);
insert into t_test_trig values (3,4,4),(5,6,6),(7,8,8);
create index t_ind33 on t_test_trig(a);
create or replace trigger test_trigger before update on t_test_trig for each row
is
begin
dbe_output.print_line(:old.a||' '|| :old.b ||' '||:old.c);
dbe_output.print_line(:new.a||' '|| :new.b ||' '||:new.c);
:new.a := :new.a*100;
:new.b := :new.b*200;
:new.c := :new.c*300;
end;
/
alter table t_test_trig modify a bigint;
alter table t_test_trig modify b bigint;
set serveroutput on;
insert into t_test_trig values (130000,1400000,200), (30000001,40000002,300);
update t_test_trig set a=a+1,b=b-1 where a>2 and b>2;
select  * from t_test_trig order by 1,2,3;
drop table t_test_trig;

--test shrink and truncate reuse storage
CREATE TABLESPACE SPC DATAFILE 'FILE' SIZE 128M EXTENT AUTOALLOCATE;

DROP TABLE IF EXISTS SHK_TABLE;
CREATE TABLE SHK_TABLE(C_ID INT, C_CHAR VARCHAR2(8000), C_CHAR1 VARCHAR2(8000),C_CHAR2 VARCHAR2(8000), C_CHAR3 VARCHAR2(8000)) TABLESPACE SPC;

DECLARE 
I INTEGER;
BEGIN
FOR I IN 1 .. 140 LOOP
INSERT INTO SHK_TABLE VALUES(1, LPAD(' ', 5000, 'A'), NULL, NULL, NULL);
END LOOP;
COMMIT;
END;
/
COMMIT;   
     
TRUNCATE TABLE SHK_TABLE REUSE STORAGE; 
   
DECLARE 
I INTEGER;
BEGIN
FOR I IN 1 .. 125 LOOP
INSERT INTO SHK_TABLE VALUES(1, LPAD(' ', 5000, 'A'), NULL, NULL, NULL);
END LOOP;
COMMIT;
END;
/
COMMIT;      

DELETE FROM SHK_TABLE;
COMMIT;

ALTER TABLE SHK_TABLE SHRINK SPACE;

DECLARE 
I INTEGER;
BEGIN
FOR I IN 1 .. 140 LOOP
INSERT INTO SHK_TABLE VALUES(1, LPAD(' ', 5000, 'A'), NULL, NULL, NULL);
END LOOP;
COMMIT;
END;
/
COMMIT;  

DELETE FROM SHK_TABLE LIMIT 50;
COMMIT;

ALTER TABLE SHK_TABLE SHRINK SPACE;

DROP TABLE IF EXISTS SHK_TABLE;

CREATE TABLE SHK_TABLE(C_ID INT, C_CHAR VARCHAR2(8000), C_CHAR1 VARCHAR2(8000),C_CHAR2 VARCHAR2(8000), C_CHAR3 VARCHAR2(8000)) TABLESPACE SPC;

DECLARE 
I INTEGER;
BEGIN
FOR I IN 1 .. 5 LOOP
INSERT INTO SHK_TABLE VALUES(1, LPAD(' ', 5000, 'A'), NULL, NULL, NULL);
END LOOP;
COMMIT;
END;
/
COMMIT;   
      
DELETE FROM SHK_TABLE;
COMMIT;

ALTER TABLE SHK_TABLE SHRINK SPACE;

DROP TABLE IF EXISTS SHK_TABLE;
DROP TABLESPACE SPC INCLUDING CONTENTS AND DATAFILES;

--test duplicate inline con 
drop table if exists my_table_dsh;
CREATE TABLE my_table_dsh (
 id int,
 class varchar(8),
 name varchar2(8),
 gender int,
 score number(10, 5)
);
ALTER TABLE my_table_dsh ADD COLUMN id1 int CONSTRAINT con PRIMARY KEY;
ALTER TABLE my_table_dsh ADD COLUMN id2 int CONSTRAINT con UNIQUE;
drop table my_table_dsh;
--
drop table if exists test_null;
create table test_null (i int, j int);
insert into test_null values (1,2);
alter table test_null add column b int default null;
alter table test_null modify b not null;
update test_null set b = 1;
update test_null set b = null;
alter table test_null modify b not null;
update test_null set b = 1;
alter table test_null modify b not null;
alter table test_null add column c int default 1;
alter table test_null modify c not null;
drop table if exists test_null;

--test alter table initrans
DROP TABLE IF EXISTS TEST_TRANS;
DROP INDEX IF EXISTS IDX_TRANS ON TEST_TRANS;
DROP TABLE IF EXISTS ALTRANS;
DROP INDEX IF EXISTS IDX_ALTRANS ON ALTRANS;

CREATE TABLE TEST_TRANS(staff_id INT NOT NULL, highest_degree CHAR(8), graduate_school VARCHAR(64), graduate_date DATETIME,  NAME VARCHAR(20))
PARTITION BY LIST(highest_degree) SUBPARTITION BY HASH(NAME)
(
PARTITION TRANS_P1 VALUES ('博士') (SUBPARTITION TRANS_SP11,  SUBPARTITION TRANS_SP12),
PARTITION TRANS_P2 VALUES ('硕士') (SUBPARTITION TRANS_SP21,  SUBPARTITION TRANS_SP22),
PARTITION TRANS_P3 VALUES ('学士')  (SUBPARTITION TRANS_SP31,  SUBPARTITION TRANS_SP32)
);
CREATE INDEX IDX_TRANS ON TEST_TRANS(staff_id ASC, highest_degree) LOCAL 
(
PARTITION TRANS_P1 ( SUBPARTITION TRANS_SP11, SUBPARTITION TRANS_SP12), 
PARTITION TRANS_P2 ( SUBPARTITION TRANS_SP21, SUBPARTITION TRANS_SP22), 
PARTITION TRANS_P3 ( SUBPARTITION TRANS_SP31, SUBPARTITION TRANS_SP32)
);
ALTER TABLE TEST_TRANS INITRANS 3;
select INITRANS from SYS_TABLES where name = 'TEST_TRANS';
select INITRANS from SYS_TABLE_PARTS where name = 'TRANS_P1' or  name = 'TRANS_P2' or name = 'TRANS_P3';
select INITRANS from SYS_SUB_TABLE_PARTS where name = 'TRANS_SP11' or name = 'TRANS_SP12' or name = 'TRANS_SP21' or name = 'TRANS_SP22' or name = 'TRANS_SP31' or name = 'TRANS_SP32';
ALTER INDEX IDX_TRANS ON TEST_TRANS INITRANS 4;
select INITRANS from SYS_INDEXES where name = 'IDX_TRANS';
select INITRANS from SYS_INDEX_PARTS where name = 'TRANS_P1' or  name = 'TRANS_P2' or name = 'TRANS_P3';
select INITRANS from SYS_SUB_INDEX_PARTS where name = 'TRANS_SP11' or name = 'TRANS_SP12' or name = 'TRANS_SP21' or name = 'TRANS_SP22' or name = 'TRANS_SP31' or name = 'TRANS_SP32';
ALTER TABLE TEST_TRANS MODIFY PARTITION TRANS_P1 INITRANS 5;
select INITRANS from SYS_TABLE_PARTS where name = 'TRANS_P1';
select INITRANS from SYS_SUB_TABLE_PARTS where name = 'TRANS_SP11' or name = 'TRANS_SP12';
ALTER INDEX IDX_TRANS ON TEST_TRANS MODIFY PARTITION TRANS_P1 INITRANS 6;
select INITRANS from SYS_INDEX_PARTS where name = 'TRANS_P1';
select INITRANS from SYS_SUB_INDEX_PARTS where name = 'TRANS_SP11' or name = 'TRANS_SP12';
ALTER TABLE TEST_TRANS INITRANS 0;
ALTER INDEX IDX_TRANS ON TEST_TRANS INITRANS 256;
ALTER TABLE TEST_TRANS MODIFY PARTITION TRANS_P1 INITRANS 0;
ALTER INDEX IDX_TRANS ON TEST_TRANS MODIFY PARTITION TRANS_P1 INITRANS 256;
ALTER TABLE TEST_TRANS MODIFY PARTITION TRANS_P11 INITRANS 5;
ALTER INDEX IDX_TRANS ON TEST_TRANS MODIFY PARTITION TRANS_P11 INITRANS 6;

CREATE TABLE ALTRANS(id INT, c INT);
CREATE INDEX IDX_ALTRANS ON ALTRANS(id);
ALTER TABLE ALTRANS  MODIFY PARTITION P1 INITRANS 3;
ALTER INDEX IDX_ALTRANS ON ALTRANS MODIFY PARTITION P1 INITRANS 3;

DROP TABLE IF EXISTS TEST_TRANS;
DROP INDEX IF EXISTS IDX_TRANS ON TEST_TRANS;
DROP TABLE IF EXISTS ALTRANS;
DROP INDEX IF EXISTS IDX_ALTRANS ON ALTRANS;
--20201112
CREATE TABLESPACE temp_tablespace_20201112 DATAFILE 'temp_tablespace_20201112' SIZE 8M AUTOEXTEND ON MAXSIZE 10G EXTENT AUTOALLOCATE;
alter TABLESPACE temp_tablespace_20201112 shrink space keep;
alter TABLESPACE temp_tablespace_20201112 shrink space ke;
alter tablespace temp_tablespace_20201112 shrink;
alter tablespace temp_tablespace_20201112 shrink sdhsjd;
alter tablespace temp_tablespace_20201112 shrink space keep 8K;
alter tablespace temp_tablespace_20201112 shrink space keep 8M;
drop tablespace temp_tablespace_20201112;