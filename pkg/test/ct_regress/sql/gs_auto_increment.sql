create table autoinctab(i int primary key,j int);
alter table autoinctab modify i bigint;
drop table autoinctab;
create table autoinctab(i int primary key,j int);
insert into autoinctab values (10,20);
alter table autoinctab modify i bigint;
drop table autoinctab;
create table autoinctab(i bigint primary key,j int);
alter table autoinctab modify i int;
drop table autoinctab;
create table autoinctab(i bigint primary key,j int);
insert into autoinctab values (10,20);
alter table autoinctab modify i int;
drop table autoinctab;

create table autoinctab(i int ,j int);
alter table autoinctab modify i auto_increment;
drop table autoinctab;
create table autoinctab(i int primary key,j int);
alter table autoinctab modify i auto_increment;
alter table autoinctab modify j auto_increment;
drop table autoinctab;

create table autoinctab(i int primary key,j int);
alter table autoinctab modify i auto_increment;
alter table autoinctab modify i char;
drop table autoinctab;
create table autoinctab(i int primary key,j int);
alter table autoinctab modify i auto_increment;
alter table autoinctab modify i int;
drop table autoinctab;
create table autoinctab(i int primary key,j int);
alter table autoinctab modify i auto_increment;
alter table autoinctab modify i bigint;
drop table autoinctab;
create table autoinctab(i bigint primary key,j int);
alter table autoinctab modify i auto_increment;
alter table autoinctab modify i bigint;
drop table autoinctab;
create table autoinctab(i bigint primary key,j int);
alter table autoinctab modify i auto_increment;
alter table autoinctab modify i int;
drop table autoinctab;
CREATE TABLE SERIAL_FAILD_1 (F1 bool, F2 int, F3 serial, F4 serial);
CREATE TABLE SERIAL_FAILD_2 (F1 bool, F2 int, F3 varchar(100) AUTO_INCREMENT);
CREATE TABLE SERIAL_FAILD_2 (F1 bool, F2 int, F3 int AUTO_INCREMENT);
CREATE TABLE SERIAL_FAILD_3 (F1 bool, F2 int, F3 bigint AUTO_INCREMENT);
CREATE TABLE SERIAL_FAILD_4 (F1 bool, F2 int, F3 bigint AUTO_INCREMENT primary key AUTO_INCREMENT);
CREATE TABLE SERIAL_FAILD_5 (F1 bool, F2 int, F3 bigint AUTO_INCREMENT primary key, F4 bigint AUTO_INCREMENT unique);
CREATE TABLE SERIAL_FAILD_6 (F1 bool, F2 int, F3 bigint AUTO_INCREMENT primary key) AUTO_INCREMENT=-1;
CREATE TABLE SERIAL_FAILD_7 (F1 bool, F2 int, F3 int AUTO_INCREMENT primary key) AUTO_INCREMENT=100000000000000;
CREATE TABLE SERIAL_FAILD_8 (F1 bool, F2 int, F3 int AUTO_INCREMENT, CONSTRAINT PK_F2_F3 primary key(F2, F3)) AUTO_INCREMENT=100;
CREATE TABLE SERIAL_FAILD_9 (F1 bool, F2 int, F3 int AUTO_INCREMENT, CONSTRAINT UK_F2_F3 unique(F2, F3)) AUTO_INCREMENT=100;
DROP TABLE IF EXISTS SERIAL_SUCESS_0;
CREATE TABLE SERIAL_SUCESS_0 (F1 int, F2 bigint AUTO_INCREMENT, CONSTRAINT PK_F2 PRIMARY KEY (F2));
INSERT INTO SERIAL_SUCESS_0 VALUES(1, NULL);
INSERT INTO SERIAL_SUCESS_0 VALUES(2, 0);
INSERT INTO SERIAL_SUCESS_0 (F1) VALUES(3);
SELECT * FROM SERIAL_SUCESS_0 ORDER BY F2;
INSERT INTO SERIAL_SUCESS_0 VALUES(3, 3);
INSERT INTO SERIAL_SUCESS_0 VALUES(-1, -1);
INSERT INTO SERIAL_SUCESS_0 VALUES(4, 4);
INSERT INTO SERIAL_SUCESS_0 VALUES(5, NULL);
INSERT INTO SERIAL_SUCESS_0 VALUES(101, 101);
INSERT INTO SERIAL_SUCESS_0 (F1) VALUES(102);
SELECT * FROM SERIAL_SUCESS_0 ORDER BY F2;
UPDATE SERIAL_SUCESS_0 SET F2 = 201 WHERE F1 = 102;
UPDATE SERIAL_SUCESS_0 SET F2 = NULL WHERE F1 = 102;
INSERT INTO SERIAL_SUCESS_0 VALUES(202, NULL);
UPDATE SERIAL_SUCESS_0 SET F2 = 0 WHERE F1 = 202;
SELECT * FROM SERIAL_SUCESS_0 ORDER BY F2;
DROP TABLE SERIAL_SUCESS_0;

DROP TABLE IF EXISTS SERIAL_SUCESS_1;
CREATE TABLE SERIAL_SUCESS_1 (F1 int, F2 INT AUTO_INCREMENT CONSTRAINT UK_F2 unique) AUTO_INCREMENT 1000 tablespace users;
INSERT INTO SERIAL_SUCESS_1 VALUES(1000, NULL);
INSERT INTO SERIAL_SUCESS_1 VALUES(1001, 0);
INSERT INTO SERIAL_SUCESS_1 (F1) VALUES(1002);
SELECT * FROM SERIAL_SUCESS_1 ORDER BY F2;
INSERT INTO SERIAL_SUCESS_1 VALUES(1002, 1002);
INSERT INTO SERIAL_SUCESS_1 VALUES(-1, -1);
INSERT INTO SERIAL_SUCESS_1 VALUES(1003, 1003);
INSERT INTO SERIAL_SUCESS_1 VALUES(1004, NULL);
INSERT INTO SERIAL_SUCESS_1 VALUES(1100, 1100);
INSERT INTO SERIAL_SUCESS_1 (F1) VALUES(1101);
SELECT * FROM SERIAL_SUCESS_1 ORDER BY F2;
UPDATE SERIAL_SUCESS_1 SET F2 = 1150 WHERE F1 = 1101;
INSERT INTO SERIAL_SUCESS_1 VALUES(1151, NULL);
SELECT * FROM SERIAL_SUCESS_1 ORDER BY F2;
UPDATE SERIAL_SUCESS_1 SET F2 = 2200 WHERE F1 = 1151;
INSERT INTO SERIAL_SUCESS_1 VALUES(2201, NULL);
SELECT * FROM SERIAL_SUCESS_1 ORDER BY F2;
DROP TABLE SERIAL_SUCESS_1;
FLASHBACK TABLE SERIAL_SUCESS_1 TO BEFORE DROP; 
INSERT INTO SERIAL_SUCESS_1 VALUES(2202, NULL);
SELECT * FROM SERIAL_SUCESS_1 ORDER BY F2;
DROP TABLE SERIAL_SUCESS_1 PURGE;
CREATE TABLE SERIAL_SUCESS_1 (F1 int, F2 bigint AUTO_INCREMENT unique) AUTO_INCREMENT 1000;
INSERT INTO SERIAL_SUCESS_1 VALUES(1000, NULL);
ALTER TABLE SERIAL_SUCESS_1 AUTO_INCREMENT = 1001;
select SERIAL_START from SYS_TABLES where name = 'SERIAL_SUCESS_1';
INSERT INTO SERIAL_SUCESS_1 VALUES(1001, NULL);
ALTER TABLE SERIAL_SUCESS_1 AUTO_INCREMENT = 1003;
select SERIAL_START from SYS_TABLES where name = 'SERIAL_SUCESS_1';
INSERT INTO SERIAL_SUCESS_1 VALUES(1003, NULL);
INSERT INTO SERIAL_SUCESS_1 VALUES(1004, NULL);
ALTER TABLE SERIAL_SUCESS_1 AUTO_INCREMENT = 1100;
select SERIAL_START from SYS_TABLES where name = 'SERIAL_SUCESS_1';
INSERT INTO SERIAL_SUCESS_1 VALUES(1100, NULL);
INSERT INTO SERIAL_SUCESS_1 VALUES(1200, NULL);
SELECT * FROM SERIAL_SUCESS_1 ORDER BY F2;
DROP TABLE SERIAL_SUCESS_1;

--DTS2018070200585
DROP TABLE IF EXISTS SERIAL_DTS2018070200585;
CREATE TABLE SERIAL_DTS2018070200585 (
 ID BIGINT NOT NULL AUTO_INCREMENT,
 ATTR_ID BIGINT UNIQUE NOT NULL,
 NAME VARCHAR(60) NOT NULL,
 VALUE_LIST VARCHAR(1000),
 I18N_LIST VARCHAR(2000),
 PRIMARY KEY (ID)
)AUTO_INCREMENT=9223372036854775808;

CREATE TABLE SERIAL_DTS2018070200585 (
 ID BIGINT NOT NULL AUTO_INCREMENT,
 ATTR_ID BIGINT UNIQUE NOT NULL,
 NAME VARCHAR(60) NOT NULL,
 VALUE_LIST VARCHAR(1000),
 I18N_LIST VARCHAR(2000),
 constraint PK_ID primary key (ID)
)AUTO_INCREMENT=1000;
ALTER TABLE SERIAL_DTS2018070200585 AUTO_INCREMENT = 9223372036854775808;
select SERIAL_START from SYS_TABLES where name = 'SERIAL_DTS2018070200585';
ALTER TABLE SERIAL_DTS2018070200585 AUTO_INCREMENT = 9223372036854775807;
select SERIAL_START from SYS_TABLES where name = 'SERIAL_DTS2018070200585';
insert into SERIAL_DTS2018070200585 values(9223372036854775807,99,'aa','bb',100);
insert into SERIAL_DTS2018070200585 values(9223372036854775808,100,'aa','bb',100);
insert into SERIAL_DTS2018070200585 values(0,100,'aa','bb',100);
insert into SERIAL_DTS2018070200585 values(NULL,100,'aa','bb',100);
SELECT * FROM SERIAL_DTS2018070200585;
DROP TABLE SERIAL_DTS2018070200585;

--DTS2018070309023
 CREATE TABLE IF NOT EXISTS META_ENUM 
(
 ID BIGINT NOT NULL AUTO_INCREMENT,
 ATTR_ID BIGINT UNIQUE NOT NULL,
 NAME VARCHAR(60) NOT NULL,
   VALUE_LIST VARCHAR(1000),
   I18N_LIST VARCHAR(2000),
   PRIMARY KEY (ID)
)AUTO_INCREMENT=10 AUTO_INCREMENT=20 AUTO_INCREMENT=30;

--DTS2018070402012
DROP TABLE IF EXISTS META_ENUM;
CREATE TABLE IF NOT EXISTS META_ENUM 
(
 ID int NOT NULL AUTO_INCREMENT,
 NAME VARCHAR(60) NOT NULL,
 PRIMARY KEY (ID,NAME)
)AUTO_INCREMENT=1000;

insert into META_ENUM(ID,NAME) values(10,1);
insert into META_ENUM(NAME) values(2);
insert into META_ENUM(NAME) values(3);
insert into META_ENUM(ID,NAME) values(4,4);
insert into META_ENUM(NAME) values(5);
select * from META_ENUM order by name;
DROP TABLE META_ENUM;


--DTS2018071002169
DROP TABLE IF EXISTS META_ENUM;
CREATE TABLE IF NOT EXISTS META_ENUM 
(
 ID BIGINT NOT NULL AUTO_INCREMENT,
 ATTR_ID BIGINT NOT NULL,
 NAME VARCHAR(60) NOT NULL,
 VALUE_LIST VARCHAR(1000),
 I18N_LIST VARCHAR(2000),
 CONSTRAINT PK_ID PRIMARY KEY (ID)
)AUTO_INCREMENT=10;
ALTER TABLE META_ENUM AUTO_INCREMENT = 2 abc;
ALTER TABLE META_ENUM AUTO_INCREMENT = 2;
select SERIAL_START from SYS_TABLES where name = 'META_ENUM';
insert into META_ENUM(ATTR_ID,NAME) values(5,'luo');
insert into META_ENUM(ATTR_ID,NAME) values(6,'li');
commit;

select ID,ATTR_ID,NAME from META_ENUM order by ID;
ALTER TABLE META_ENUM AUTO_INCREMENT = 50;
select SERIAL_START from SYS_TABLES where name = 'META_ENUM';
insert into META_ENUM (ATTR_ID,NAME) values(50, 'luo');
insert into META_ENUM (ATTR_ID,NAME) values(51, 'luo');
select ID,ATTR_ID,NAME from META_ENUM order by ID;
ALTER TABLE META_ENUM AUTO_INCREMENT = 150;
select SERIAL_START from SYS_TABLES where name = 'META_ENUM';
insert into META_ENUM (ATTR_ID,NAME) values(150, 'luo');
insert into META_ENUM (ATTR_ID,NAME) values(151, 'luo');
select ID,ATTR_ID,NAME from META_ENUM order by ID;
ALTER TABLE META_ENUM AUTO_INCREMENT = 2;
select SERIAL_START from SYS_TABLES where name = 'META_ENUM';
ALTER TABLE META_ENUM AUTO_INCREMENT = 9223372036854775807;
select SERIAL_START from SYS_TABLES where name = 'META_ENUM';
insert into META_ENUM(ATTR_ID,NAME) values(7,'luo');
insert into META_ENUM(ATTR_ID,NAME) values(8,'luo');
select ID,ATTR_ID,NAME from META_ENUM order by ID;

UPDATE META_ENUM SET ID = 9223372036854775807 WHERE ATTR_ID = 6;
UPDATE META_ENUM SET ID = 9223372036854775806 WHERE ATTR_ID = 6;
select ID,ATTR_ID,NAME from META_ENUM order by ID;
DROP TABLE META_ENUM;

drop table IF EXISTS abc;
drop table IF EXISTS abc2;
create table abc(fd_int int, fd_bigint bigint auto_increment primary key, fd_varchar varchar(100));
alter table abc add fd_bigint2 bigint auto_increment;
alter table abc add fd_bigint2 bigint auto_increment primary key;
insert into abc values(1,null,'1');
insert into abc values(4,4,'4');
update abc set fd_bigint = default where fd_bigint = 4;
select * from abc order by fd_int;
create table abc2(fd_int int, fd_bigint bigint auto_increment primary key, fd_varchar varchar(100));
insert into abc2 values(1,1,'1');
insert into abc2 values(2,2,'2');
insert into abc2 values(3,3,'3');
select * from abc2 order by fd_int;
merge into abc using abc2 on (abc2.fd_int = abc.fd_int) when matched then update set abc.fd_bigint = (default - 1) when not matched then insert (fd_int, fd_bigint, fd_varchar) values(abc2.fd_int,default,abc2.fd_varchar);
select * from abc order by fd_int;
drop table abc;
drop table abc2;


DROP TABLE IF EXISTS abc;
create table abc(fd_int int, fd_varchar varchar(100));
ALTER table abc ADD fd_bigint bigint auto_increment;
ALTER table abc ADD (fd_bigint bigint auto_increment primary key, fd_bigint2 bigint auto_increment unique);
ALTER table abc ADD fd_bigint bigint auto_increment constraint pk_fd_bigint primary key;
INSERT INTO ABC VALUES (1,NULL,'1');
INSERT INTO ABC VALUES (2,NULL,'2');
INSERT INTO ABC VALUES (100,100,'100');
SELECT * FROM ABC ORDER BY fd_bigint;
delete from ABC;
ALTER table abc ADD fd_bigint2 bigint auto_increment primary key;
ALTER table abc  MODIFY fd_int auto_increment;
ALTER table abc  MODIFY fd_int auto_increment UNIQUE;
DROP TABLE ABC;

DROP TABLE IF EXISTS test_part_t1;
create table test_part_t1(f1 int auto_increment unique, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);

insert into test_part_t1 values(0, 1, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
select serial_lastval('SYS','TEST_PART_T1');
insert into test_part_t1 values(10, 10, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(0, 11, 39, '26', '39', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(20, 20, 49, '36', '49', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(0, 21, 59, '46', '59', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(30, 30, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(0, 31, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));

SELECT F1,F2  FROM test_part_t1 ORDER BY F1;
UPDATE test_part_t1 SET F1= 40 WHERE F2 = 31;
insert into test_part_t1 values(0, 41, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
UPDATE test_part_t1 SET F1= 35 WHERE F2 = 31;
insert into test_part_t1 values(0, 42, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
SELECT F1,F2  FROM test_part_t1 ORDER BY F1;
SELECT F1,F2  FROM test_part_t1 PARTITION (p1) ORDER BY F1;
SELECT F1,F2  FROM test_part_t1 PARTITION (p2) ORDER BY F1;
SELECT F1,F2  FROM test_part_t1 PARTITION (p3) ORDER BY F1;
SELECT F1,F2  FROM test_part_t1 PARTITION (p4) ORDER BY F1;

TRUNCATE TABLE test_part_t1;
select serial_lastval('SYS','TEST_PART_T1');
insert into test_part_t1 values(10, 10, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(0, 11, 39, '26', '39', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(20, 20, 49, '36', '49', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(0, 21, 59, '46', '59', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(30, 30, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(0, 31, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));

SELECT F1,F2  FROM test_part_t1 ORDER BY F1;
drop table test_part_t1 purge;

DROP USER TEST CASCADE;
CREATE USER TEST IDENTIFIED BY TEST_1234;
GRANT DBA TO TEST;
CONNECT TEST/TEST_1234@127.0.0.1:1611
DROP TABLE IF EXISTS test_part_t1;
create table test_part_t1(f1 int auto_increment unique, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);

insert into test_part_t1 values(0, 1, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
select serial_lastval('TEST','TEST_PART_T1');
insert into test_part_t1 values(10, 10, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(0, 11, 39, '26', '39', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(20, 20, 49, '36', '49', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(0, 21, 59, '46', '59', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(30, 30, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(0, 31, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));

SELECT F1,F2  FROM test_part_t1 ORDER BY F1;

UPDATE test_part_t1 SET F1= 40  WHERE F2 = 31;
insert into test_part_t1 values(0, 41, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
UPDATE test_part_t1 SET F1= 35 WHERE F2 = 31;
insert into test_part_t1 values(0, 42, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
SELECT F1,F2  FROM test_part_t1 ORDER BY F1;
SELECT F1,F2  FROM test_part_t1 PARTITION (p1) ORDER BY F1;
SELECT F1,F2  FROM test_part_t1 PARTITION (p2) ORDER BY F1;
SELECT F1,F2  FROM test_part_t1 PARTITION (p3) ORDER BY F1;
SELECT F1,F2  FROM test_part_t1 PARTITION (p4) ORDER BY F1;
TRUNCATE TABLE test_part_t1;
select serial_lastval('TEST','TEST_PART_T1');
insert into test_part_t1 values(10, 10, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(0, 11, 39, '26', '39', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(20, 20, 49, '36', '49', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(0, 21, 59, '46', '59', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(30, 30, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(0, 31, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));

SELECT F1,F2  FROM test_part_t1 ORDER BY F1;
drop table test_part_t1 purge;
CONNECT sys/Huawei@123@127.0.0.1:1611
DROP USER TEST CASCADE;

--DTS2019021910945
drop table  if exists test_auto_increment;
create table test_auto_increment (a int);
alter table test_auto_increment add autosep int auto_increment unique;
alter table test_auto_increment drop autosep;
alter table test_auto_increment add autosep int auto_increment unique;
alter table test_auto_increment drop autosep;
alter table test_auto_increment add autosep int auto_increment primary key;
insert into test_auto_increment values(1,null);
insert into test_auto_increment values(2,null);
insert into test_auto_increment values(100,null);
insert into test_auto_increment values(101,null);
select * from test_auto_increment order by a;
drop table  test_auto_increment;

--DTS2021090621090
drop table if exists test_increment_convert;
create table test_increment_convert(id bigint auto_increment PRIMARY KEY, value bigint);
create unique index idx_test_value on test_increment_convert(value);
insert into test_increment_convert(id,value) values (null,1);
insert into test_increment_convert(id,value) values (null,1);
insert into test_increment_convert(id,value) values (null,2);
update test_increment_convert set id='2' where id=3;
insert into test_increment_convert(id,value) values (null,3);
select * from test_increment_convert order by id;
drop table test_increment_convert;

DROP TABLE if exists test_increment_uint32;
CREATE TABLE test_increment_uint32 (f1 UINT AUTO_INCREMENT PRIMARY KEY, f2 VARCHAR(10));
INSERT INTO test_increment_uint32 VALUES (null, 'abc');
INSERT INTO test_increment_uint32 VALUES (4294967295, 'BROWN');
INSERT INTO test_increment_uint32 VALUES (NULL, 'ALICE');
select * from test_increment_uint32 order by f1;
drop table test_increment_uint32;

DROP TABLE if exists test_increment_int;
CREATE TABLE test_increment_int (f1 int AUTO_INCREMENT PRIMARY KEY, f2 VARCHAR(10));
INSERT INTO test_increment_int VALUES (null, 'abc');
INSERT INTO test_increment_int VALUES (2147483647, 'BROWN');
INSERT INTO test_increment_int VALUES (NULL, 'ALICE');
select * from test_increment_int order by f1;
drop table test_increment_int;

DROP TABLE if exists test_increment_update_uint32;
CREATE TABLE test_increment_update_uint32 (f1 UINT AUTO_INCREMENT PRIMARY KEY, f2 VARCHAR(10));
INSERT INTO test_increment_update_uint32 VALUES (null, 'abc');
INSERT INTO test_increment_update_uint32 VALUES (null, 'BROWN');
update test_increment_update_uint32 set f1=4294967295 where f2='BROWN';
INSERT INTO test_increment_update_uint32 VALUES (NULL, 'ALICE');
select * from test_increment_update_uint32 order by f1;
drop table test_increment_update_uint32;