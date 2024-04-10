conn / as sysdba 
DROP TABLE  if exists training;
DROP TABLE  if exists education;
DROP TABLE  if exists trainings;
DROP TABLE  if exists educations;
CREATE TABLE education(staff_id INT primary key, first_name VARCHAR(20));
CREATE TABLE training(staff_id INT check(staff_id is not null), first_name VARCHAR(20));
alter table training add constraint trainingcon foreign key(staff_id) REFERENCES education(staff_id) on delete set null;
CREATE TABLE educations(staff_id INT primary key, first_name VARCHAR(20));
CREATE TABLE trainings(staff_id INT, first_name VARCHAR(20));
alter table trainings add constraint check_not_null check(staff_id is not null);
alter table trainings add constraint trainingcons foreign key(staff_id) REFERENCES educations(staff_id) on delete set null;
INSERT INTO education VALUES(1, 'ALICE');
INSERT INTO training VALUES(1, 'ALICE');
delete from education where staff_id=1;
select * from training;
select * from education;
INSERT INTO educations VALUES(1, 'ALICE');
INSERT INTO trainings VALUES(1, 'ALICE');
delete from educations where staff_id=1;
select * from trainings;
select * from educations;
DROP TABLE  if exists training;
DROP TABLE  if exists education;
DROP TABLE  if exists trainings;
DROP TABLE  if exists educations;
drop table if exists base_008;
create table base_008 (id int,name char);
alter table base_008 add constraint basepk primary key (id);
alter table base_008 add constraint basepk2 unique (name);
select constraint_name, table_name from all_constraints where table_name ='BASE_008' order by constraint_name;
alter table base_008 rename constraint  basepk to basepk2;
alter table base_008 rename constraint  basepk to basepk3;
select constraint_name, table_name from all_constraints where table_name ='BASE_008' order by constraint_name;
drop table if exists base_008;
drop table if exists sf;
create table sf (a int);
alter table sf add constraint sf check(a <100);
insert into sf values(20);
alter table sf drop constraint sf;
alter table sf add constraint sf check(a <100 or a>200);
drop table sf;
drop table if exists `check table`;
create table `check table` (c1 int, c2 int);
alter table `check table` add constraint check_cons_1 CHECK(c2>1);
drop table `check table`;
DROP TABLE IF EXISTS cons_table;
CREATE TABLE cons_table(c1 int, c2 varchar(32), c3 bigint);
INSERT INTO cons_table values(1, 'a1', 1000);
COMMIT;
--add constraint with a create index clause
ALTER TABLE cons_table ADD CONSTRAINT pk_cons_table PRIMARY KEY(c1, c2) USING INDEX (CREATE INDEX pk_cons_table ON cons_table(c2) INITRANS 10 TABLESPACE users PCTFREE 10);
ALTER TABLE cons_table ADD CONSTRAINT pk_cons_table PRIMARY KEY(c1, c2) USING INDEX (CREATE INDEX pk_cons_table ON cons_table(c1, c2) INITRANS 10 TABLESPACE users PCTFREE 10);
SELECT t.name, t.indexes, i.name, i.is_primary, i.is_unique, i.initrans, i.space#, i.pctfree, i.flags FROM SYS_TABLES t, SYS_INDEXES i WHERE t.name='CONS_TABLE' and t.USER# = i.USER# and t.id = i.TABLE#;
SELECT cons_name, cons_type FROM SYS_CONSTRAINT_DEFS WHERE cons_name = 'PK_CONS_TABLE';

--index is not dropped with constraint
ALTER TABLE cons_table DROP CONSTRAINT pk_cons_table;
SELECT t.name, t.indexes, i.name, i.is_primary, i.is_unique, i.initrans, i.space#, i.pctfree, i.flags FROM SYS_TABLES t, SYS_INDEXES i WHERE t.name='CONS_TABLE' and t.USER# = i.USER# and t.id = i.TABLE#;
SELECT cons_name, cons_type FROM SYS_CONSTRAINT_DEFS WHERE cons_name = 'PK_CONS_TABLE';
DROP INDEX pk_cons_table ON cons_table;
ALTER TABLE cons_table ADD CONSTRAINT pk_cons_table PRIMARY KEY(c1, c2) USING INDEX (CREATE INDEX ix_cons_table ON cons_table(c1, c2) INITRANS 10 TABLESPACE users PCTFREE 10);
INSERT INTO cons_table values(2, null, 1000);
INSERT INTO cons_table values(1, 'a1', 1000);
ALTER TABLE cons_table DROP CONSTRAINT pk_cons_table;

--add constraint add specified using an existed index
ALTER TABLE cons_table ADD CONSTRAINT uni_cons_table UNIQUE(c1) USING INDEX ix_cons_table;
ALTER TABLE cons_table ADD CONSTRAINT uni_cons_table UNIQUE(c1, c2) USING INDEX ix_cons_table;
SELECT t.name, t.indexes, i.name, i.is_primary, i.is_unique, i.initrans, i.space#, i.pctfree, i.flags FROM SYS_TABLES t, SYS_INDEXES i WHERE t.name='CONS_TABLE' and t.USER# = i.USER# and t.id = i.TABLE#;
ALTER TABLE cons_table DROP CONSTRAINT uni_cons_table;
SELECT t.name, t.indexes, i.name, i.is_primary, i.is_unique, i.initrans, i.space#, i.pctfree, i.flags FROM SYS_TABLES t, SYS_INDEXES i WHERE t.name='CONS_TABLE' and t.USER# = i.USER# and t.id = i.TABLE#;

--add constraint with index attributes specified.
DROP INDEX ix_cons_table ON cons_table;
ALTER TABLE cons_table ADD CONSTRAINT uni_cons_table UNIQUE(c1, c2) USING INDEX ix_cons_table;
ALTER TABLE cons_table ADD CONSTRAINT uni_cons_table UNIQUE(c1, c2) USING INDEX INITRANS 10 PCTFREE 15;
SELECT t.name, t.indexes, i.name, i.is_primary, i.is_unique, i.initrans, i.space#, i.pctfree, i.flags FROM SYS_TABLES t, SYS_INDEXES i WHERE t.name='CONS_TABLE' and t.USER# = i.USER# and t.id = i.TABLE#;

DROP TABLE cons_table;

DROP TABLE IF EXISTS cons_part;
CREATE TABLE cons_part(c1 int, c2 varchar(32), c3 bigint) PARTITION BY RANGE(c1) (PARTITION p1 VALUES LESS THAN (100), PARTITION p2 VALUES LESS THAN (200), PARTITION p3 VALUES LESS THAN (300), PARTITION p4 VALUES LESS THAN (maxvalue));
INSERT INTO cons_part VALUES(50, 'P1', 5000);
INSERT INTO cons_part VALUES(150, 'P2', 15000);
INSERT INTO cons_part VALUES(250, 'P3', 25000);
INSERT INTO cons_part VALUES(350, 'P4', 35000);
COMMIT;
--add primary key for partition table(default a global index will be created.
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c1);
INSERT INTO cons_part VALUES(250, 'P3', 25000);
SELECT t.name, p.name, p.initrans, p.space#, p.pctfree FROM SYS_INDEX_PARTS p, SYS_TABLES t WHERE t.name = 'CONS_PART' AND p.user# = t.user# AND p.table# = t.id ORDER BY p.PART#;
SELECT t.name, t.indexes, i.name, i.is_primary, i.is_unique, i.initrans, i.space#, i.pctfree, i.flags, i.partitioned FROM SYS_TABLES t, SYS_INDEXES i WHERE t.name='CONS_PART' and t.USER# = i.USER# and t.id = i.TABLE#;
ALTER TABLE cons_part DROP CONSTRAINT pk_cons_part;

--add primary key for partition table and specify index local
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c1) USING INDEX LOCAL (PARTITION idx_p1 INITRANS 1 TABLESPACE users, PARTITION idx_p2 INITRANS 2 PCTFREE 12, PARTITION idx_p3 INITRANS 3 PCTFREE 13, PARTITION idx_p4 INITRANS 4 PCTFREE 14);
INSERT INTO cons_part VALUES(250, 'P3', 25000);
SELECT t.name, p.name, p.initrans, p.space#, p.pctfree FROM SYS_INDEX_PARTS p, SYS_TABLES t WHERE t.name = 'CONS_PART' AND p.user# = t.user# AND p.table# = t.id ORDER BY p.PART#;
SELECT t.name, t.indexes, i.name, i.is_primary, i.is_unique, i.initrans, i.space#, i.pctfree, i.flags, i.partitioned FROM SYS_TABLES t, SYS_INDEXES i WHERE t.name='CONS_PART' and t.USER# = i.USER# and t.id = i.TABLE#;
ALTER TABLE cons_part DROP CONSTRAINT pk_cons_part;

--add primary key for partition table and specified property for each partition.
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c1) USING INDEX LOCAL (PARTITION idx_p1 INITRANS 1, PARTITION idx_p2 INITRANS 2, PARTITION idx_p3 INITRANS 3);
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c1) USING INDEX LOCAL (PARTITION idx_p1 INITRANS 1, PARTITION idx_p2 INITRANS 2, PARTITION idx_p3 INITRANS 3, PARTITION idx_p4 INITRANS 4, PARTITION idx_p5 INITRANS 5);
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c1) USING INDEX LOCAL (PARTITION idx_p1 INITRANS 1 TABLESPACE users, PARTITION idx_p2 INITRANS 2, PARTITION idx_p3 INITRANS 3, PARTITION idx_p4 INITRANS 4 PCTFREE 14);
SELECT t.name, p.name, p.initrans, p.space#, p.pctfree FROM SYS_INDEX_PARTS p, SYS_TABLES t WHERE t.name = 'CONS_PART' AND p.user# = t.user# AND p.table# = t.id ORDER BY p.PART#;
SELECT t.name, t.indexes, i.name, i.is_primary, i.is_unique, i.initrans, i.space#, i.pctfree, i.flags, i.partitioned FROM SYS_TABLES t, SYS_INDEXES i WHERE t.name='CONS_PART' and t.USER# = i.USER# and t.id = i.TABLE#;
INSERT INTO cons_part VALUES(250, 'P3', 25000);
ALTER TABLE cons_part DROP CONSTRAINT pk_cons_part;

--add primary key for partition table with a create index statement creating a global index
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c1) USING INDEX (CREATE INDEX ix_cons_part_global ON cons_part(c1));
SELECT t.name, p.name, p.initrans, p.space#, p.pctfree FROM SYS_INDEX_PARTS p, SYS_TABLES t WHERE t.name = 'CONS_PART' AND p.user# = t.user# AND p.table# = t.id ORDER BY p.PART#;
SELECT t.name, t.indexes, i.name, i.is_primary, i.is_unique, i.initrans, i.space#, i.pctfree, i.flags, i.partitioned FROM SYS_TABLES t, SYS_INDEXES i WHERE t.name='CONS_PART' and t.USER# = i.USER# and t.id = i.TABLE#;
INSERT INTO cons_part VALUES(250, 'P3', 25000);
ALTER TABLE cons_part DROP CONSTRAINT pk_cons_part;
DROP INDEX ix_cons_part_global ON cons_part;

--add primary key for partition table with a create index statement creating a local index
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c1) USING INDEX (CREATE INDEX ix_cons_part_local ON cons_part(c1) PCTFREE 9 LOCAL (PARTITION idx_p1 INITRANS 1 TABLESPACE users PCTFREE 11, PARTITION idx_p2 INITRANS 2, PARTITION idx_p3 INITRANS 3, PARTITION idx_p4 INITRANS 4));
SELECT t.name, p.name, p.initrans, p.space#, p.pctfree FROM SYS_INDEX_PARTS p, SYS_TABLES t WHERE t.name = 'CONS_PART' AND p.user# = t.user# AND p.table# = t.id ORDER BY p.PART#;
SELECT t.name, t.indexes, i.name, i.is_primary, i.is_unique, i.initrans, i.space#, i.pctfree, i.flags, i.partitioned FROM SYS_TABLES t, SYS_INDEXES i WHERE t.name='CONS_PART' and t.USER# = i.USER# and t.id = i.TABLE#;
INSERT INTO cons_part VALUES(250, 'P3', 25000);
ALTER TABLE cons_part DROP CONSTRAINT pk_cons_part;
DROP INDEX ix_cons_part_local ON cons_part;

--add primary key using an existing global index
CREATE INDEX ix_cons_part_global ON cons_part(c1);
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c1) USING INDEX sys.ix_cons_part_global;
SELECT t.name, p.name, p.initrans, p.space#, p.pctfree FROM SYS_INDEX_PARTS p, SYS_TABLES t WHERE t.name = 'CONS_PART' AND p.user# = t.user# AND p.table# = t.id ORDER BY p.PART#;
SELECT t.name, t.indexes, i.name, i.is_primary, i.is_unique, i.initrans, i.space#, i.pctfree, i.flags, i.partitioned FROM SYS_TABLES t, SYS_INDEXES i WHERE t.name='CONS_PART' and t.USER# = i.USER# and t.id = i.TABLE#;
INSERT INTO cons_part VALUES(250, 'P3', 25000);
ALTER TABLE cons_part DROP CONSTRAINT pk_cons_part;
DROP INDEX sys.ix_cons_part_global ON cons_part; 

--add unique constraint using and existing local index
CREATE INDEX ix_cons_part_local ON cons_part(c1) LOCAL;
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c1) USING INDEX sys.ix_cons_part_local;
SELECT t.name, p.name, p.initrans, p.space#, p.pctfree FROM SYS_INDEX_PARTS p, SYS_TABLES t WHERE t.name = 'CONS_PART' AND p.user# = t.user# AND p.table# = t.id ORDER BY p.PART#;
SELECT t.name, t.indexes, i.name, i.is_primary, i.is_unique, i.initrans, i.space#, i.pctfree, i.flags, i.partitioned FROM SYS_TABLES t, SYS_INDEXES i WHERE t.name='CONS_PART' and t.USER# = i.USER# and t.id = i.TABLE#;
INSERT INTO cons_part VALUES(250, 'P3', 25000);
ALTER TABLE cons_part DROP CONSTRAINT pk_cons_part;
SELECT t.name, t.indexes, i.name, i.is_primary, i.is_unique, i.initrans, i.space#, i.pctfree, i.flags, i.partitioned FROM SYS_TABLES t, SYS_INDEXES i WHERE t.name='CONS_PART' and t.USER# = i.USER# and t.id = i.TABLE#;
--rebuild index partition
ALTER INDEX ix_cons_part_local ON cons_part REBUILD PARTITION p3;
ALTER INDEX ix_cons_part_local ON cons_part REBUILD PARTITION p3;

--test if index properties keep the same before and after used by a constraint;
INSERT INTO cons_part VALUES(250, 'P3', 35000);
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c1);
DELETE FROM cons_part WHERE c3=35000;
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c1);
SELECT t.name, p.name, p.initrans, p.space#, p.pctfree FROM SYS_INDEX_PARTS p, SYS_TABLES t WHERE t.name = 'CONS_PART' AND p.user# = t.user# AND p.table# = t.id ORDER BY p.PART#;
SELECT t.name, t.indexes, i.name, i.is_primary, i.is_unique, i.initrans, i.space#, i.pctfree, i.flags, i.partitioned FROM SYS_TABLES t, SYS_INDEXES i WHERE t.name='CONS_PART' and t.USER# = i.USER# and t.id = i.TABLE#;
INSERT INTO cons_part VALUES(250, 'P3', 35000);
ALTER TABLE cons_part DROP CONSTRAINT pk_cons_part;
SELECT t.name, p.name, p.initrans, p.space#, p.pctfree FROM SYS_INDEX_PARTS p, SYS_TABLES t WHERE t.name = 'CONS_PART' AND p.user# = t.user# AND p.table# = t.id ORDER BY p.PART#;
SELECT t.name, t.indexes, i.name, i.is_primary, i.is_unique, i.initrans, i.space#, i.pctfree, i.flags, i.partitioned FROM SYS_TABLES t, SYS_INDEXES i WHERE t.name='CONS_PART' and t.USER# = i.USER# and t.id = i.TABLE#;
DROP INDEX sys.ix_cons_part_local ON cons_part; 

--test constraint using local index with constraint columns does not include part key
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c2) USING INDEX LOCAL;
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c2) USING INDEX (CREATE INDEX ix_cons_part_c2 ON cons_part(c2) LOCAL);
CREATE INDEX ix_cons_part_c2 ON cons_part(c2) LOCAL;
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c2);
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c2) USING INDEX ix_cons_part_c2;

--test inline & outline constraint
DROP TABLE IF EXISTS cons_test;
CREATE TABLE cons_test(c1 int, c2 int primary key, c3 int, unique(c1, c3), c4 int, c5 int, constraint u_c4_c5 unique(c5, c4), c6 int);
SELECT t.name, i.is_primary, i.is_unique, i.col_list FROM sys.SYS_TABLES t, sys.SYS_INDEXES i WHERE t.name='CONS_TEST' AND t.user# = i.user# AND t.id = i.table# ORDER BY i.col_list;
DROP TABLE cons_test;
--syntax error
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c2) USING INDEX (CREATE INDEX ix_cons_part_c2 ON cons_part2(c2) LOCAL);
ALTER TABLE cons_part ADD CONSTRAINT pk_cons_part PRIMARY KEY(c2) LOCAL;

DROP TABLE cons_part;

set serveroutput on
DROP TABLE IF EXISTS t_rca_006;
DECLARE
  V_SQL VARCHAR2(32767);
  V_E   VARCHAR2(32767);
BEGIN
  FOR I IN 1 .. 3 LOOP
    V_E := V_E || 'i_' || I || ' varchar2(4000),
    ';
  END LOOP;
  V_E   := V_E || '`Sex` varchar2(200)
  )';
  V_SQL := 'create table t_rca_006(`ID` int, ' || V_E;
  EXECUTE IMMEDIATE V_SQL;
  EXECUTE IMMEDIATE 'alter table t_rca_006 add constraint rca_Sex_ck check(`Sex` in(''1'',''0''))';
  EXECUTE IMMEDIATE 'alter table t_rca_006 add constraint t_rca_006_pk primary key(id)';
  EXECUTE IMMEDIATE 'create sequence seq_rca_003 increment by 1 start with 1000';
END;
/
-- 
INSERT INTO t_rca_006 (`Sex`) VALUES (1);
DROP TABLE IF EXISTS t_rca_006;
DROP SEQUENCE IF EXISTS seq_rca_003;

drop table if exists test_pk1;
create table test_pk1 (i int, id int, id3 int);
create index idx_pk_11 on test_pk1 (id);
create index idx_pk_22 on test_pk1 (id3);
create index idx_pk_33 on test_pk1 (i);
insert into test_pk1 values(1,1,1);
insert into test_pk1 values(1,1,1);
alter table test_pk1 add constraint nebula_com_cstr_001 primary key (i) using index idx_pk_33;
drop table test_pk1;

drop table if exists test_pk2;
create table test_pk2 (i int, id varchar(2), id3 int);
create unique index idx_pk_11 on test_pk2 (id);
insert into test_pk2 values(1, NULL, 1);
alter table test_pk2 add constraint nebula_com_cstr_002 primary key (id);
drop table test_pk2;

drop table if exists test_pk3;
create table test_pk3 (i int, id varchar(2), id3 int);
create unique index idx_pk3_01 on test_pk3 (i);
create unique index idx_pk3_11 on test_pk3 (id);
alter table test_pk3 add constraint nebula_com_cstr_001 primary key (i);
alter table test_pk3 add constraint nebula_com_cstr_002 primary key (id);
drop table test_pk3;

--DTS2020031713061
drop table if exists test_pk1;
create table test_pk1 (i int, id int, id3 int);
insert into test_pk1 values(1, 1, 1);
create unique index ix_test_pk1 on test_pk1(i);
select t.status from dv_transactions t, dv_me m where t.sid = m.sid;
drop table test_pk1 purge;


DROP TABLE IF EXISTS PARAL_IDX_R_TBL_005;
CREATE TABLE PARAL_IDX_R_TBL_005(NUM INT,C_ID INT,C_D_ID BIGINT NOT NULL,C_W_ID INT NOT NULL,C_UINT UINT NOT NULL,C_FIRST VARCHAR(16) NOT NULL,C_MIDDLE CHAR(2),C_LAST VARCHAR(16) NOT NULL,C_STREET_1 VARCHAR(20) NOT NULL,C_STREET_2 VARCHAR2(20),C_ZERO TIMESTAMP NOT NULL,C_START DATE NOT NULL,C_ZIP CHAR(9) NOT NULL,C_PHONE CHAR(16) NOT NULL,C_SINCE TIMESTAMP,C_CREDIT CHAR(2),C_CREDIT_LIM NUMERIC,C_DISCOUNT NUMERIC(5,2),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL NOT NULL,C_PAYMENT_CNT NUMBER NOT NULL,C_DELIVERY_CNT BOOL NOT NULL,C_END DATE NOT NULL,C_DATA1 VARCHAR2(4000),C_DATA2 VARCHAR(4000),C_DATA3 VARCHAR(4000),C_DATA4 VARCHAR(4000),C_DATA5 VARCHAR(4000),C_DATA6 VARCHAR(4000),C_DATA7 VARCHAR(4000),C_VARBINARY VARBINARY(100),C_CLOB CLOB,C_BLOB BLOB,C_BINARY BINARY(100)) PARTITION BY RANGE(C_UINT)(PARTITION P1 VALUES LESS THAN (5) TABLESPACE SYSTEM,PARTITION P2 VALUES LESS THAN (11) TABLESPACE SYSTEM,PARTITION P3 VALUES LESS THAN (16) TABLESPACE SYSTEM,PARTITION P4 VALUES LESS THAN (MAXVALUE) TABLESPACE SYSTEM);

CREATE UNIQUE INDEX PARAL_IDX_R_TBL_005_IDX_14 ON PARAL_IDX_R_TBL_005(C_SINCE,C_BINARY,C_PHONE);
ALTER TABLE PARAL_IDX_R_TBL_005 ADD CONSTRAINT PARAL_IDX_R_TBL_005_CONST_15 PRIMARY KEY(C_MIDDLE,C_VARBINARY);                                                  
CREATE UNIQUE INDEX PARAL_IDX_R_TBL_005_IDX_16 ON PARAL_IDX_R_TBL_005(TO_CHAR(C_ID)) CRMODE ROW;
CREATE UNIQUE INDEX PARAL_IDX_R_TBL_005_IDX_17 ON PARAL_IDX_R_TBL_005(UPPER(C_STREET_2),TO_CHAR(C_UINT),TO_NUMBER(C_PHONE));
UPDATE PARAL_IDX_R_TBL_005 SET C_UINT=C_ID;
CREATE UNIQUE INDEX PARAL_IDX_R_TBL_005_IDX_18 ON PARAL_IDX_R_TBL_005(C_UINT) LOCAL;
CREATE UNIQUE INDEX PARAL_IDX_R_TBL_005_IDX_19 ON PARAL_IDX_R_TBL_005(C_DISCOUNT,C_START,C_LAST,C_UINT) LOCAL;
CREATE UNIQUE INDEX PARAL_IDX_R_TBL_005_IDX_20 ON PARAL_IDX_R_TBL_005(C_START,C_D_ID,C_SINCE,C_UINT) LOCAL;
ALTER TABLE PARAL_IDX_R_TBL_005 ADD CONSTRAINT PARAL_IDX_R_TBL_005_CONST_21 UNIQUE(C_MIDDLE,C_STREET_2,C_UINT) USING INDEX (CREATE UNIQUE INDEX PARAL_IDX_R_TBL_005_IDX_21 ON PARAL_IDX_R_TBL_005(C_MIDDLE,C_STREET_2,C_UINT) LOCAL INITRANS 10 TABLESPACE SYSTEM PCTFREE 10);
CREATE UNIQUE INDEX PARAL_IDX_R_TBL_005_IDX_22 ON PARAL_IDX_R_TBL_005(C_SINCE,C_BINARY,C_PHONE,C_UINT) LOCAL;
ALTER TABLE PARAL_IDX_R_TBL_005 ADD CONSTRAINT PARAL_IDX_R_TBL_005_CONST_23 PRIMARY KEY(C_MIDDLE,C_VARBINARY,C_UINT) USING INDEX LOCAL (PARTITION P1 INITRANS 1 TABLESPACE SYSTEM,PARTITION P2 INITRANS 2 TABLESPACE SYSTEM,PARTITION P3 INITRANS 3 TABLESPACE SYSTEM,PARTITION P4 INITRANS 4 PCTFREE 14);
ALTER TABLE PARAL_IDX_R_TBL_005 DROP CONSTRAINT PARAL_IDX_R_TBL_005_CONST_15;
ALTER TABLE PARAL_IDX_R_TBL_005 ADD CONSTRAINT PARAL_IDX_R_TBL_005_CONST_23 PRIMARY KEY(C_MIDDLE,C_VARBINARY,C_UINT) USING INDEX LOCAL (PARTITION P1 INITRANS 1 TABLESPACE SYSTEM,PARTITION P2 INITRANS 2 TABLESPACE SYSTEM,PARTITION P3 INITRANS 3 TABLESPACE SYSTEM,PARTITION P4 INITRANS 4 PCTFREE 14);
CREATE UNIQUE INDEX PARAL_IDX_R_TBL_005_IDX_24 ON PARAL_IDX_R_TBL_005(TO_CHAR(C_W_ID),C_UINT) CRMODE ROW LOCAL;
ALTER TABLE PARAL_IDX_R_TBL_005 ADD CONSTRAINT PARAL_IDX_R_TBL_005_CONST_25 UNIQUE(C_UINT) USING INDEX PARAL_IDX_R_TBL_005_IDX_18;
ALTER TABLE PARAL_IDX_R_TBL_005 ADD CONSTRAINT PARAL_IDX_R_TBL_005_CONST_26 PRIMARY KEY(C_START,C_D_ID,C_SINCE,C_UINT);
ALTER TABLE PARAL_IDX_R_TBL_005 ADD CONSTRAINT PARAL_IDX_R_TBL_005_CONST_26 PRIMARY KEY(C_START,C_D_ID,C_SINCE,C_UINT) USING INDEX PARAL_IDX_R_TBL_005_IDX_20;
ALTER TABLE PARAL_IDX_R_TBL_005 ADD CONSTRAINT PARAL_IDX_R_TBL_005_CONST_27 PRIMARY KEY(C_SINCE,C_BINARY,C_PHONE);
ALTER TABLE PARAL_IDX_R_TBL_005 ADD CONSTRAINT PARAL_IDX_R_TBL_005_CONST_27 PRIMARY KEY(C_SINCE,C_BINARY,C_PHONE) USING INDEX PARAL_IDX_R_TBL_005_IDX_14;
ALTER TABLE PARAL_IDX_R_TBL_005 ADD CONSTRAINT PARAL_IDX_R_TBL_005_CONST_28 PRIMARY KEY(C_STREET_2,C_ID) USING INDEX (CREATE UNIQUE INDEX PARAL_IDX_R_TBL_005_IDX_28 ON PARAL_IDX_R_TBL_005(C_STREET_2,C_ID) INITRANS 10 TABLESPACE SYSTEM PCTFREE 10);
ALTER TABLE PARAL_IDX_R_TBL_005 ADD CONSTRAINT PARAL_IDX_R_TBL_005_CONST_29 PRIMARY KEY(C_UINT,C_ZERO) USING INDEX LOCAL (PARTITION P1 INITRANS 1 TABLESPACE SYSTEM,PARTITION P2 INITRANS 2 TABLESPACE SYSTEM,PARTITION P3 INITRANS 3 TABLESPACE SYSTEM,PARTITION P4 INITRANS 4 PCTFREE 14); 

DROP TABLE IF EXISTS AUTO_INCREMENT_T1;
create table AUTO_INCREMENT_T1(id int auto_increment primary key,id2 int);
DECLARE
 CONS_NAME VARCHAR(30);
 SQLTEXT VARCHAR(200);
BEGIN
 select CONSTRAINT_NAME INTO CONS_NAME from ADM_CONSTRAINTS where TABLE_NAME = 'AUTO_INCREMENT_T1';
 SQLTEXT := 'alter table AUTO_INCREMENT_T1 DROP CONSTRAINT ' || CONS_NAME;
 execute immediate SQLTEXT;
END;
/
DROP TABLE IF EXISTS AUTO_INCREMENT_T1;