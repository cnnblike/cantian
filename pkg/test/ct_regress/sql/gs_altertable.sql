--
-- ALTER_TABLE
--
--
-- CLASS DEFINITIONS
--
--test add column
drop table if exists IND_CONFS_NAME_5;
create table IND_CONFS_NAME_5 (a int, b INT,c int);
insert into IND_CONFS_NAME_5 values (1,1,1);
alter table IND_CONFS_NAME_5 modify c date constraint cc check (c>to_date('2018-01-01','YYYY-MM-DD'));
drop table if exists IND_CONFS_NAME_5;
create table IND_CONFS_NAME_5 (a int, b INT,c int);
alter table IND_CONFS_NAME_5 modify c date;
alter table IND_CONFS_NAME_5 add constraint cc check (c>to_date('2018-01-01','YYYY-MM-DD'));
desc IND_CONFS_NAME_5
drop table if exists IND_CONFS_NAME_5;
drop table if exists test_altertable;
drop table if exists test_altertable_1;
create table test_altertable(id int, a1 float default 3.1, a2 float default 3.2, a3 int);
insert into test_altertable values (1, default, default, 3);
select * from test_altertable order by id; 
alter table test_altertable add a4 varchar(10) default 'abcd';
select * from test_altertable order by id;
insert into test_altertable (id, a4) values (2, default);
select * from test_altertable order by id;
alter table test_altertable add a5 int;
select * from test_altertable order by id;
alter table test_altertable add a6 int default 66;
insert into test_altertable (id) values (3);
select * from test_altertable order by id;
drop table test_altertable;

--test modify column
create table test_altertable(id int,a1 char, a2 char, a3 char, a4 int, a5 char);
select * from test_altertable;

alter table test_altertable modify a4 char;
insert into test_altertable (id, a4) values (1, 'a');
alter table test_altertable modify a4 char;
alter table test_altertable modify aa4 char;
select * from test_altertable order by id;
alter table test_altertable modify a1 char;
insert into test_altertable (id, a1) values (2, 'a');
alter table test_altertable modify a1 char;
alter table test_altertable modify aa1 char;
select * from test_altertable order by id;
alter table test_altertable modify a5 char;
insert into test_altertable (id, a5) values (3, 'a');
alter table test_altertable modify a5 char;
alter table test_altertable modify aa5 char;
select * from test_altertable order by id;
update test_altertable set a1=null where id=2;
alter table test_altertable modify a1 int;
select * from test_altertable order by id;
alter table test_altertable modify a1 varchar(10);
alter table test_altertable modify a1 varchar(20) default 'abc01234567890';
select * from test_altertable order by id;

alter table test_altertable rename column a2 to ar2;
select * from test_altertable order by id;
insert into test_altertable (id, ar2) values (4, 'a');
select * from test_altertable order by id;
alter table test_altertable rename column aa2 to a2;
select * from test_altertable order by id;
alter table test_altertable rename column a3 to a4;
select * from test_altertable order by id;
alter table test_altertable rename column a5 to ar5;
select * from test_altertable order by id;
insert into test_altertable (id, ar5) values (5, 'a');
select * from test_altertable order by id;
alter table test_altertable rename column aa5 to a5;
select * from test_altertable order by id;
alter table test_altertable rename column a5 to a4;
select * from test_altertable order by id;

update test_altertable set a1=11;
select * from test_altertable order by id;
alter table test_altertable drop column a1;
select * from test_altertable order by id;
select t.NAME, c.ID, c.NAME, c.FLAGS from SYS_COLUMNS c, SYS_TABLES t where t.NAME='TEST_ALTERTABLE' and t.id = c.TABLE# ORDER BY c.ID;
alter table test_altertable add a1 char;
select c.ID, c.NAME, c.FLAGS from SYS_COLUMNS c, SYS_TABLES t where t.NAME='TEST_ALTERTABLE' and t.id = c.TABLE# ORDER BY c.ID;
select * from test_altertable order by id;
insert into test_altertable (id, a1) values (6, 'a');
select * from test_altertable order by id;
alter table test_altertable drop column a1;
select c.ID, c.NAME, c.FLAGS from SYS_COLUMNS c, SYS_TABLES t where t.NAME='TEST_ALTERTABLE' and t.id = c.TABLE# ORDER BY c.ID;
select * from test_altertable order by id;
alter table test_altertable drop column a5;
select * from test_altertable order by id;
alter table test_altertable add a5 char;
select * from test_altertable order by id;
insert into test_altertable (id, a5) values (7, 'a');
select * from test_altertable order by id;
alter table test_altertable drop column a5;
select * from test_altertable order by id;
alter table test_altertable add a1 char;
select * from test_altertable order by id;
alter table test_altertable add a5 char;
select * from test_altertable order by id;

alter table test_altertable modify A1 int;
select * from test_altertable order by id;
alter table test_altertable rename column A1 to AaA1;
select c.ID, c.NAME, c.FLAGS from SYS_COLUMNS c, SYS_TABLES t where t.NAME='TEST_ALTERTABLE' and t.id = c.TABLE# ORDER BY c.ID;
select * from test_altertable order by id;
alter table test_altertable modify aaa1 char;
select * from test_altertable order by id;
alter table test_altertable drop column AAA1;
select * from test_altertable order by id;
drop table test_altertable;

create table test_altertable(id int, a1 char, a2 char, a3 char, a4 varchar(10) default 'abcd', a5 char);
insert into test_altertable values (1,'a','b','c',default,'e');
insert into test_altertable values (2,'a','b','c','d','e');
alter table test_altertable add constraint pk_test primary key (a4);
insert into test_altertable values (3,'a','b','c',default,'e');
alter table test_altertable drop constraint pk_test;
insert into test_altertable values (3,'a','b','c',default,default);
alter table test_altertable add constraint pk_test primary key (a5);
alter table test_altertable add constraint un_test unique (a5);
update test_altertable set a5='x' where id=2;
update test_altertable set a5='y' where id=3;
alter table test_altertable add constraint un_test unique (a5);
select i.ID,i.NAME from SYS_INDEXES i, SYS_TABLES t where t.id = i.TABLE# and t.name = 'TEST_ALTERTABLE' order by i.NAME;
alter table test_altertable drop constraint un_test;

alter table test_altertable add constraint pk_test primary key (a3);
alter table test_altertable add constraint pk_test primary key (a3);
alter table test_altertable add constraint pk_test primary key (a4);
alter table test_altertable add constraint pk_test1 primary key (a4);
alter table test_altertable add constraint un_test unique (id);
alter table test_altertable add constraint un_test1 unique (id);
alter table test_altertable add constraint un_test unique (a1);
alter table test_altertable add constraint un_test1 unique (a1);
select i.ID,i.NAME from SYS_INDEXES i, SYS_TABLES t where t.id = i.TABLE# and t.name = 'TEST_ALTERTABLE' order by i.NAME;
alter table test_altertable drop constraint un_test;
alter table test_altertable drop constraint pk_test;
alter table test_altertable drop constraint un_test1;

drop table test_altertable;

create table test_altertable(id int, a1 char, a2 char, a3 char, a4 varchar(10) default 'abcd', a5 char);
create table test_altertable_1(id int, a1 char, a2 char, a3 char, a4 varchar(10) default 'abcd', a5 char);
insert into test_altertable values (1,'a','b','c',default,'e');
insert into test_altertable_1 values (1,'a','b','c',default,'e');
alter table test_altertable add constraint pk_test primary key (a1);
alter table test_altertable add constraint un_test unique (a2);
alter table test_altertable_1 add constraint pk_test1 primary key (a1);
alter table test_altertable_1 add constraint un_test1 unique (a2);
alter table test_altertable drop constraint pk_test;
select i.ID,i.NAME from SYS_INDEXES i, SYS_TABLES t where t.id = i.TABLE# and (t.name = 'TEST_ALTERTABLE' or t.name = 'TEST_ALTERTABLE_1') order by i.NAME;

drop table test_altertable;
drop table test_altertable_1;
select i.ID,i.NAME from SYS_INDEXES i, SYS_TABLES t where t.id = i.TABLE# and (t.name = 'TEST_ALTERTABLE' or t.name = 'TEST_ALTERTABLE_1') order by i.NAME;

-- test modify column with default value
create table test_altertable(id int);
insert into test_altertable(id) values(1);
alter table test_altertable add c1 varchar(10);
insert into test_altertable(id) values(2);
insert into test_altertable(id, c1) values(3, 'abc');
select * from test_altertable order by id;
alter table test_altertable modify c1 varchar(20) default 'varchar10';
select * from test_altertable order by id;
alter table test_altertable drop column c1;
select * from test_altertable order by id;
drop table test_altertable;

-- test modify lob column
create table test_altertable(c1 clob, c2 blob);
alter table test_altertable modify c1 varchar(4000);
alter table test_altertable modify c2 binary(4000);
drop table test_altertable;

-- test alter table rename to
CREATE TABLE test_table_old(c1 integer);
INSERT INTO test_table_old VALUES(1);
INSERT INTO test_table_old VALUES(2);
INSERT INTO test_table_old VALUES(3);
SELECT * FROM test_table_old;
ALTER TABLE test_table_old RENAME TO test_table_new;
SELECT * FROM test_table_old;
SELECT * FROM test_table_new;
DROP TABLE test_table_new;

-- test ddl on view
DROP VIEW IF EXISTS test_view_ddl;
CREATE VIEW test_view_ddl AS SELECT * FROM SYS_TABLES;
ALTER TABLE test_view_ddl ADD c1 integer;
ALTER TABLE test_view_ddl ADD CONSTRAINT pk_test_view_ddl PRIMARY KEY(id);
CREATE INDEX ix_test_view_ddl ON test_view_ddl(id);
TRUNCATE TABLE test_view_ddl;
DROP VIEW test_view_ddl;

--dts
--DTS2017120901598 & DTS2017120901407
DROP TABLE IF EXISTS ref_cons_column1;
DROP TABLE IF EXISTS drop_cons_column1;
CREATE TABLE drop_cons_column1(c1 int, c2 int, c3 int, CONSTRAINT drop_pk1 PRIMARY KEY(c1, c2), c4 int UNIQUE, c5 int, CONSTRAINT drop_unique1 UNIQUE(c4, c5));
ALTER TABLE drop_cons_column1 add CONSTRAINT if not exists drop_pk1 PRIMARY KEY(c1, c2,c3);
ALTER TABLE drop_cons_column1 add CONSTRAINT drop_pk1 PRIMARY KEY(c1, c2,c3);
ALTER TABLE drop_cons_column1 drop CONSTRAINT if exists drop_pk;
ALTER TABLE drop_cons_column1 drop CONSTRAINT drop_pk;
CREATE TABLE ref_cons_column1(c1 int, c2 int, c3 int);
ALTER TABLE ref_cons_column1 ADD FOREIGN KEY(c1, c2) REFERENCES drop_cons_column1(c1, c2);
ALTER TABLE ref_cons_column1 ADD FOREIGN KEY(c3) REFERENCES drop_cons_column1(c4);
ALTER TABLE ref_cons_column1 DROP COLUMN c1;
ALTER TABLE ref_cons_column1 DROP COLUMN c2;
ALTER TABLE ref_cons_column1 DROP COLUMN c3;
DROP TABLE ref_cons_column1;
ALTER TABLE drop_cons_column1 DROP COLUMN c1;
ALTER TABLE drop_cons_column1 DROP COLUMN c2;
ALTER TABLE drop_cons_column1 DROP CONSTRAINT drop_pk1;
ALTER TABLE drop_cons_column1 DROP COLUMN c1;
ALTER TABLE drop_cons_column1 DROP COLUMN c2;
ALTER TABLE drop_cons_column1 DROP COLUMN c4;
ALTER TABLE drop_cons_column1 DROP COLUMN c5;
ALTER TABLE drop_cons_column1 DROP CONSTRAINT drop_unique1;
ALTER TABLE drop_cons_column1 DROP COLUMN c4;
ALTER TABLE drop_cons_column1 DROP COLUMN c5;
SELECT * FROM drop_cons_column1;
DROP TABLE drop_cons_column1;
DROP TABLE IF EXISTS drop_cons_column2;
CREATE TABLE drop_cons_column2(c1 int, c2 int, c3 int, CONSTRAINT drop_pk2 PRIMARY KEY(c1, c2), c4 int, c5 int, CONSTRAINT drop_unique2 UNIQUE(c4, c5));
SELECT name FROM SYS_INDEXES WHERE name ='DROP_PK2' or name ='DROP_UNIQUE2' ORDER BY name;
SELECT cons_name, cons_type FROM SYS_CONSTRAINT_DEFS WHERE cons_name ='DROP_PK2' or cons_name ='DROP_UNIQUE2' ORDER BY cons_name;
ALTER TABLE drop_cons_column2 DROP COLUMN c4;
ALTER TABLE drop_cons_column2 DROP COLUMN c5;
SELECT name FROM SYS_INDEXES WHERE name ='DROP_PK2' or name ='DROP_UNIQUE2' ORDER BY name;
SELECT cons_name, cons_type FROM SYS_CONSTRAINT_DEFS WHERE cons_name ='DROP_PK2' or cons_name ='DROP_UNIQUE2' ORDER BY cons_name;
--DTS2017120809170 & DTS2017120806977 & DTS2017120713138
DROP TABLE IF EXISTS drop_fk2;
DROP TABLE IF EXISTS drop_fk1;
DROP TABLE IF EXISTS drop_fk0;
CREATE TABLE drop_fk0(c1 int, c2 int, c3 int);
ALTER TABLE drop_fk0 ADD CONSTRAINT pk_drop_fk0 PRIMARY KEY(c1, c2);
DROP TABLE drop_fk0;
CREATE TABLE drop_fk1(c1 int, c2 int, c3 int);
ALTER TABLE drop_fk1 ADD CONSTRAINT pk_drop_fk0 PRIMARY KEY(c1, c2);
CREATE TABLE drop_fk2(c1 int, c2 int, c3 int);
ALTER TABLE drop_fk2 ADD CONSTRAINT ref_drop_fk2 FOREIGN KEY(c1, c2) REFERENCES drop_fk1(c1);
ALTER TABLE drop_fk2 ADD CONSTRAINT ref_drop_fk2 FOREIGN KEY(c1, c2) REFERENCES drop_fk1(c1, c2);
ALTER TABLE drop_fk1 MODIFY c1 VARCHAR(10);
ALTER TABLE drop_fk2 MODIFY c2 VARCHAR(10);
ALTER TABLE drop_fk2 DROP CONSTRAINT ref_drop_fk2;
DROP TABLE drop_fk2;
DROP TABLE drop_fk1;

--constraints using existing index
DROP TABLE IF EXISTS test_cons;
CREATE TABLE test_cons(c1 int, c2 int, c3 int);
CREATE INDEX ix_cons ON test_cons(c1, c3);
ALTER TABLE test_cons ADD CONSTRAINT pk_cons PRIMARY KEY(c1, c3);
SELECT count(*) FROM SYS_INDEXES i, SYS_TABLES t WHERE i.USER#=t.USER# and i.TABLE#=t.ID and t.NAME='TEST_CONS';
DROP INDEX ix_cons ON test_cons;
INSERT INTO test_cons VALUES(null,1, 1);
INSERT INTO test_cons VALUES(1,2, 1);
INSERT INTO test_cons VALUES(1,3, 1);
ALTER TABLE test_cons DROP CONSTRAINT pk_cons;
INSERT INTO test_cons VALUES(null,1, 1);
INSERT INTO test_cons VALUES(1,3, 1);
DROP INDEX ix_cons ON test_cons;
DROP TABLE test_cons;
CREATE TABLE test_cons(c1 int, c2 int, c3 int);
CREATE INDEX ix_cons ON test_cons(c1, c3);
ALTER TABLE test_cons ADD CONSTRAINT u_cons UNIQUE(c1, c3);
SELECT count(*) FROM SYS_INDEXES i, SYS_TABLES t WHERE i.USER#=t.USER# and i.TABLE#=t.ID and t.NAME='TEST_CONS';
DROP INDEX ix_cons ON test_cons;
INSERT INTO test_cons VALUES(null,1, 1);
INSERT INTO test_cons VALUES(1,2, 1);
INSERT INTO test_cons VALUES(1,3, 1);
ALTER TABLE test_cons DROP CONSTRAINT u_cons;
INSERT INTO test_cons VALUES(null,1, 1);
INSERT INTO test_cons VALUES(1,3, 1);
DROP INDEX ix_cons ON test_cons;
DROP TABLE test_cons;
CREATE TABLE test_cons(c1 int, c2 int, c3 int, constraint u_cons1 unique(c1), constraint u_cons1 unique(c2));
CREATE TABLE test_cons(c1 int, c2 int, c3 int, constraint u_cons1 unique(c1), constraint u_cons2 unique(c1));
CREATE TABLE test_cons(c1 int, c2 int, c3 int, constraint u_cons1 primary key(c1), constraint u_cons2 primary key(c2));
CREATE TABLE test_cons(c1 int, c2 int, c3 int, constraint u_cons1 primary key(c1), constraint u_cons2 unique(c1));
DROP TABLE test_cons;
--DTS2018032712051
DROP TABLE IF EXISTS t1;
create table t1(a int, b varchar(2048) default  '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111');
insert into t1 values(1,'1111');
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t1 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
alter table t3 drop column b;
alter table t1 add  b varchar(2048) default '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
insert into t1 values(2,'2222');
DROP TABLE IF EXISTS t1;

--case modify column type which column in index

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


drop table if exists test_altertable;
create table test_altertable(id int,a1 char, a2 char, a3 char, a4 int, a5 char);
alter table test_altertable add logical log (primary key);
alter table test_altertable add primary key(id, a1);
alter table test_altertable add logical log (primary key);
alter table test_altertable add logical log (primary key);
alter table test_altertable drop logical log;
alter table test_altertable drop logical log;
alter table test_altertable drop logical log;


drop table if exists FTV_truncate_001;
drop table if exists FTV_truncate_002;
create table FTV_truncate_001(id int primary key ,name clob );
create table FTV_truncate_002(ids int primary key,sex int );
ALTER TABLE  FTV_truncate_002 ADD CONSTRAINT fk_a_ FOREIGN KEY(sex ) REFERENCES FTV_truncate_001(id);

truncate table FTV_truncate_001;
alter table FTV_truncate_001 enable constraint fk_a_;
alter table FTV_truncate_001 disable constraint fk_a_;

alter table FTV_truncate_002 enable constraint fk_a_;
alter table FTV_truncate_002 disable constraint fk_a_;
DROP TABLE FTV_truncate_001 CASCADE CONSTRAINTS;
DROP TABLE FTV_truncate_002 CASCADE CONSTRAINTS;

drop table if exists test_pct;
create table test_pct(id int,a1 char, a2 char, a3 char, a4 int, a5 char) partition by range(id)
( partition pt1 values less than (10),
partition pt2 values less than (20),
partition pt3 values less than (30),
partition pt4 values less than ( maxvalue ));
alter table test_pct pctfree 20;
alter table test_pct modify a1 int;
drop table if exists test_pct;

--create table with constraint
drop table if exists ind_confs_name_1 ;
create table ind_confs_name_1 (a int,constraint AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBbbbb_01 check(a>1));
drop table if exists ind_confs_name_2 ;
create table ind_confs_name_2 (a int constraint AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBbbbb_02 primary key);

--create index
drop table if exists ind_confs_name_1 ;
create table ind_confs_name_1 (a int,B int,c int,d int);
create index AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBbbbb_01 on ind_confs_name_1 (a,b);

--drop index
drop index AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBbbbb_01 on ind_confs_name_1;

--alter index
alter index AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBbbbb_01 on ind_confs_name_1 rebuild;

--alter table add constraint
drop table if exists ind_confs_name_1 ;
create table ind_confs_name_1 (a int,B int,c int,d int);
alter table ind_confs_name_1 add (constraint AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBbbbb_01 UNIQUE(a);
alter table ind_confs_name_1 add (constraint AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBbbbb_02 UNIQUE (col2) NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE );
alter table ind_confs_name_1 add e int constraint AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBbbbb_01 check(e>1);
alter table ind_confs_name_1 modify a int constraint  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBbbbb_01 check(a>1);
alter table ind_confs_name_1 drop constraint AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBbbbb_01;

--purge
purge index AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBbbbb_01 ;

drop table if exists test_altertable;
create table test_altertable(
id int,
a1 char, 
a2 char, 
a3 char, 
a4 int, 
a5 char,
a6 char, 
a7 char, 
a8 char, 
a9 int, 
a10 char
);

alter table test_altertable modify (
a10 varchar(20) default 'abc20', 
a9 varchar(100) default 'abc30',
a8 varchar(20) default 'abc40', 
a5 varchar(100) default 'abc50',
a4 varchar(20) default 'abc60', 
a1 varchar(100) default 'abc70',
a2 varchar(20) default 'abc80', 
a3 varchar(100) default 'abc90');

insert into test_altertable values
(
1,
default,
default,
default,
default,
default,
'a',
'a',
default,
default,
default
);

commit;
select * from test_altertable;

drop table if exists table_liu;
CREATE TABLE table_liu(c1 int, c2 int, c3 int);
create index drop_pk1 on table_liu(c1,c2); 
select id,name,col_list,is_primary,is_unique from SYS_INDEXES where table# in (select id from SYS_TABLES where name=upper('table_liu'));
select cons_name,col_list,ind# from SYS_CONSTRAINT_DEFS  where table# in (select id from SYS_TABLES where name=upper('table_liu'));
ALTER TABLE table_liu add CONSTRAINT if not exists drop_pk1 PRIMARY KEY(c1, c2);
select id,name,col_list,is_primary,is_unique from SYS_INDEXES where table# in (select id from SYS_TABLES where name=upper('table_liu'));
select cons_name,col_list,ind# from SYS_CONSTRAINT_DEFS  where table# in (select id from SYS_TABLES where name=upper('table_liu'));
ALTER TABLE table_liu add CONSTRAINT if not exists drop_pk1 PRIMARY KEY(c1, c2, c3);
select id,name,col_list,is_primary,is_unique from SYS_INDEXES where table# in (select id from SYS_TABLES where name=upper('table_liu'));
select cons_name,col_list,ind# from SYS_CONSTRAINT_DEFS  where table# in (select id from SYS_TABLES where name=upper('table_liu'));
ALTER TABLE table_liu add CONSTRAINT drop_pk1 PRIMARY KEY(c1, c2);
ALTER TABLE table_liu add CONSTRAINT drop_pk1 PRIMARY KEY(c1, c2, c3);
ALTER TABLE table_liu drop CONSTRAINT if exists drop_pk1;
select id,name,col_list,is_primary,is_unique from SYS_INDEXES where table# in (select id from SYS_TABLES where name=upper('table_liu'));
select cons_name,col_list,ind# from SYS_CONSTRAINT_DEFS  where table# in (select id from SYS_TABLES where name=upper('table_liu'));
ALTER TABLE table_liu drop CONSTRAINT drop_pk1;
drop index drop_pk1 on table_liu;
select id,name,col_list,is_primary,is_unique from SYS_INDEXES where table# in (select id from SYS_TABLES where name=upper('table_liu'));
select cons_name,col_list,ind# from SYS_CONSTRAINT_DEFS  where table# in (select id from SYS_TABLES where name=upper('table_liu'));
ALTER TABLE table_liu add CONSTRAINT if not exists drop_pk1 PRIMARY KEY(c1, c2);
select id,name,col_list,is_primary,is_unique from SYS_INDEXES where table# in (select id from SYS_TABLES where name=upper('table_liu'));
select cons_name,col_list,ind# from SYS_CONSTRAINT_DEFS  where table# in (select id from SYS_TABLES where name=upper('table_liu'));
ALTER TABLE table_liu add CONSTRAINT if not exists drop_pk1 PRIMARY KEY(c1, c2, c3);
select id,name,col_list,is_primary,is_unique from SYS_INDEXES where table# in (select id from SYS_TABLES where name=upper('table_liu'));
select cons_name,col_list,ind# from SYS_CONSTRAINT_DEFS  where table# in (select id from SYS_TABLES where name=upper('table_liu'));
drop table if exists table_liu;

--test modify column with number type
drop table if exists alt_dec;
create table alt_dec(id int, c1 decimal, c2 number, c3 number(5,3), c4 number(5, -2));
insert into alt_dec values(1, 1.123123123123, 1.123456789, 1.001, 123456.812839);
insert into alt_dec values(2, 1.123123123123, 1.123456789, 2.0022, 123456.812839);
insert into alt_dec values(3, 1.123123123123, 1.123456789, 333.0033, 123456.812839);
select * from alt_dec order by id;
alter table alt_dec modify c1 decimal(5,3);
alter table alt_dec modify c1 number;
alter table alt_dec modify c2 number(5,3);
alter table alt_dec modify c2 decimal;
alter table alt_dec modify c3 number(5,2);
alter table alt_dec modify c3 number(4,3);
alter table alt_dec modify c3 number(5,4);
alter table alt_dec modify c3 number(6,4);
insert into alt_dec values(3, 1.123123123123, 1.123456789, 33.0003, 123456.812839);
insert into alt_dec values(4, 1.123123123123, 1.123456789, 444.00044, 123456.812839);
select * from alt_dec order by id;
alter table alt_dec modify c3 number(8,5);
insert into alt_dec values(4, 1.123123123123, 1.123456789, 444.00044, 123456.812839);
select * from alt_dec order by id;
commit;
alter table alt_dec modify c4 number(5, -1);
alter table alt_dec modify c4 number(5, -3);
alter table alt_dec modify c4 number(6, -1);
insert into alt_dec values(5, 1.123123123123, 1.123456789, 444.00044, 1234567.812839);
select * from alt_dec order by id;
alter table alt_dec modify c4 decimal;
create index ix_alt_dec on alt_dec(c3, c4);
update alt_dec set c3=null, c4= null;
alter table alt_dec modify c4 varchar(64);
insert into alt_dec values(5, 1.123123123123, 1.123456789, 444.00044, '1234567.812839');
delete from alt_dec;
drop table alt_dec purge;
drop table if exists RCA_NULL_010;
CREATE TABLE RCA_NULL_010 (COL_1 VARCHAR(255) default '' ON UPDATE NULL,
COL_2 clob default '' COLLATE  UTF8_BIN
);
insert into RCA_NULL_010 values ('ddd','&');
insert into RCA_NULL_010 values (' ','hjff6501');
insert into RCA_NULL_010 values (' ','hjff6501');
commit;
ALTER TABLE RCA_NULL_010 modify (COL_1 VARCHAR(255) default '' ON UPDATE '',COL_2 default '' COLLATE  UTF8_UNICODE_CI );
drop table RCA_NULL_010 purge;

DROP TABLE IF EXISTS TEST_ALTER;
CREATE TABLE TEST_ALTER (ID INT, VAL VARCHAR(10));
INSERT INTO TEST_ALTER VALUES (1, NULL);
ALTER TABLE TEST_ALTER MODIFY VAL VARCHAR(20) NOT NULL DEFAULT 'A';
DROP TABLE IF EXISTS TEST_ALTER;
CREATE TABLE TEST_ALTER (ID INT, VAL VARCHAR(10));
INSERT INTO TEST_ALTER VALUES (1, NULL);
ALTER TABLE TEST_ALTER MODIFY VAL VARCHAR(20) DEFAULT 'A';
SELECT * FROM TEST_ALTER;
INSERT INTO TEST_ALTER(ID) VALUES(3);
SELECT * FROM TEST_ALTER ORDER BY ID;
DROP TABLE IF EXISTS TEST_ALTER;

DROP TABLE IF EXISTS TEST_C;
CREATE TABLE TEST_C(COL_1 VARCHAR(200));
select TABLE_NAME, CONSTRAINT_TYPE, CONS_COLS, SEARCH_CONDITION, STATUS FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'TEST_C';
ALTER TABLE TEST_C MODIFY COL_1 VARCHAR(300) CHECK(COL_1 IN ('ddd')) UNIQUE;
select TABLE_NAME, CONSTRAINT_TYPE, CONS_COLS, SEARCH_CONDITION, STATUS FROM USER_CONSTRAINTS where TABLE_NAME = 'TEST_C';
DROP TABLE IF EXISTS TEST_C;