conn   sys/Huawei@123@127.0.0.1:1611
drop table if exists tab_check_null;
create table tab_check_null (a int not null);
alter table tab_check_null modify ( a int check ( a is null));
insert into tab_check_null values(4);
drop table if exists tab_check_null;
create user constraints_user identified by cao102_cao;
grant connect to constraints_user;
grant create table  to constraints_user;
grant create view to constraints_user;
conn   constraints_user/cao102_cao@127.0.0.1:1611
drop table if exists caot1;
create  table caot1(id int constraint caot1_pri primary key ,name int constraint caot1_check check (name>10));
select TABLE_NAME,CONSTRAINT_NAME,CONSTRAINT_type,CONS_COLS from ALL_CONSTRAINTS where TABLE_NAME='CAOT1';
conn   sys/Huawei@123@127.0.0.1:1611
select TABLE_NAME,CONSTRAINT_NAME,CONSTRAINT_type,CONS_COLS from DBA_CONSTRAINTS where TABLE_NAME='CAOT1';
drop user constraints_user cascade;
CREATE TABLE T_CHECK_FAILED_1
(
    sn           NUMBER(38),   
    logLevel     VARCHAR2(100)   not null constraint chk_sec_level check(logLevel in ('WARNING','MINOR','RISK', 'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff', 'ggg', 'asdfasdlkfjasldjfalksdjfkasdasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfa', 
	'111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'211111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'311111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'411111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'511111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'611111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'811111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'911111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'1011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'121111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'131111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'141111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'151111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'161111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'181111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'191111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',
'201111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111')),   
    PRIMARY KEY ( sn ) using index tablespace users
)tablespace users;

CREATE TABLE T_CHECK_FAILED_2
(
    sn           NUMBER(38),   
    logLevel     VARCHAR2(100)  not null constraint chk_sec_level  check(logLevel in ('WARNING','MINOR','RISK')) check(logLevel in ('WARNING','MINOR','RISK')),   
    PRIMARY KEY ( sn ) using index tablespace users
)tablespace users;

CREATE TABLE T_CHECK_FAILED_3
(
    sn           NUMBER(38),   
    logLevel     VARCHAR2(100)   not null constraint chk_sec_level  check( 'ABC'  = CASE logLevel  WHEN 'WARNING' THEN 'WARNING' ELSE NULL END),   
    PRIMARY KEY ( sn ) using index tablespace users
)tablespace users;

drop table if exists T_CHECK_SUCESS_0;
CREATE TABLE T_CHECK_SUCESS_0
(
    sn           NUMBER(38),   
    logLevel     VARCHAR2(100)   not null constraint chk_sec_level  check(logLevel in ('WARNING','MINOR','RISK')),   
	result       VARCHAR2(10)    not null constraint "Chk_SEC_level" check(result in ('SUCCESSFUL','FAILURE','POK'))   
)tablespace users;
SELECT CONS_NAME FROM SYS_CONSTRAINT_DEFS WHERE USER#=0 AND  TABLE# = (SELECT ID  FROM SYS_TABLES WHERE  NAME = 'T_CHECK_SUCESS_0') order by CONS_NAME;
drop table T_CHECK_SUCESS_0;

CREATE TABLE T_CHECK_FAILED_4
(
    sn           NUMBER(38),   
    logLevel     VARCHAR2(100)   not null constraint chk_sec_level  check(logLevel in ('WARNING','MINOR','RISK')),   
	result       VARCHAR2(10)    not null constraint chk_sec_level check(result in ('SUCCESSFUL','FAILURE','POK')), 
    PRIMARY KEY ( sn ) using index tablespace users
)tablespace users;

CREATE TABLE T_CHECK_FAILED_5
(
    sn           NUMBER(38),   
    logLevel     VARCHAR2(100)   not null constraint chk_sec_level  check(logLevel in ('WARNING','MINOR','RISK')),   
	result       VARCHAR2(10)    not null , 
	constraint chk_sec_level check(result in ('SUCCESSFUL','FAILURE','POK')),
    PRIMARY KEY ( sn ) using index tablespace users
)tablespace users;

CREATE TABLE T_CHECK_FAILED_6
(
    sn           NUMBER(38),   
    logLevel     VARCHAR2(100)   not null constraint chk_sec_level  check(logLevel in ('WARNING','MINOR','RISK')),   
	result       VARCHAR2(10)    not null , 
	constraint chk_sec_result check(result in ('SUCCESSFUL','FAILURE','POK')),
	constraint chk_sec_result check(result in ('SUCCESSFUL','FAILURE','POK')),
    PRIMARY KEY ( sn ) using index tablespace users
)tablespace users;

CREATE TABLE T_CHECK_FAILED_7
(
    sn           NUMBER(38),   
    logLevel     VARCHAR2(100)   not null constraint chk_sec_level  check(logLevel1 in ('WARNING','MINOR','RISK')),  
    PRIMARY KEY ( sn ) using index tablespace users
)tablespace users;

CREATE TABLE T_CHECK_FAILED_8
(
    sn           NUMBER(38),   
    logLevel     CLOB  not null constraint chk_sec_level  check(logLevel in ('WARNING','MINOR','RISK')),  
    PRIMARY KEY ( sn ) using index tablespace users
)tablespace users;

CREATE TABLE T_CHECK_FAILED_9(F_CHAR CHAR(10) CHECK (EXISTS (SELECT NAME FROM SYS_TABLES)));

DROP TABLE IF EXISTS T_CHECK_SUCESS_1;
CREATE TABLE T_CHECK_SUCESS_1
(
    sn           NUMBER(38),   
    logLevel     VARCHAR2(100)   not null constraint chk_sec_level  check(logLevel in ('WARNING','MINOR','RISK')),   
	result       VARCHAR2(10)    not null , 
	F1           INT,
	F2           NUMBER(38),
	F3           INT,
	F4           INT,
	constraint chk_sec_result check(result in ('SUCCESSFUL','FAILURE','POK')),
	constraint chk_outline_cons check((F1, F2) in ((1,1),(1,2),(10,1))),
	constraint chk_outline_cons_1 check(F3 + F4 > 100),
    PRIMARY KEY ( sn ) using index tablespace users
)tablespace users;
INSERT INTO T_CHECK_SUCESS_1 VALUES (1, 'WARNIN',  'SUCCESSFUL', 1,  2,  10, 10);
INSERT INTO T_CHECK_SUCESS_1 VALUES (1, 'WARNING', 'FAILUR',     11, 1,  10, 10);
INSERT INTO T_CHECK_SUCESS_1 VALUES (1, 'WARNING', 'FAILURE',    1,  3,  10, 10);
INSERT INTO T_CHECK_SUCESS_1 VALUES (1, 'WARNING', 'FAILURE',    1,  10, 10, 10);
INSERT INTO T_CHECK_SUCESS_1 VALUES (1, 'MINOR',   'SUCCESSFUL', 1,  1,  10, 100);
INSERT INTO T_CHECK_SUCESS_1 VALUES (2, 'MINOR',   'SUCCESSFUL', 1,  2,  100, 10);
INSERT INTO T_CHECK_SUCESS_1 VALUES (3, 'MINOR',   'SUCCESSFUL', 10, 1,  90, 100);
SELECT * FROM T_CHECK_SUCESS_1;

UPDATE T_CHECK_SUCESS_1 SET F1 = 1,  F2 = 3 WHERE sn = 2;
UPDATE T_CHECK_SUCESS_1 SET F1 = 10, F2 = 1 WHERE sn = 2;
SELECT * FROM T_CHECK_SUCESS_1 WHERE sn = 2;
UPDATE T_CHECK_SUCESS_1 SET F3 = 90  WHERE sn = 2;
UPDATE T_CHECK_SUCESS_1 SET F4 = 100 WHERE sn = 2;
SELECT * FROM T_CHECK_SUCESS_1 WHERE sn = 2;

CREATE TABLE T_CHECK_FAILED_10
(
    sn           NUMBER(38),   
    result       VARCHAR2(10)    not null constraint chk_sec_result check(result in ('SUCCESSFUL','FAILURE','POK')), 	
    PRIMARY KEY ( sn ) using index tablespace users
)tablespace users;

DROP TABLE T_CHECK_SUCESS_1;
FLASHBACK TABLE T_CHECK_SUCESS_1 TO BEFORE DROP;
SELECT * FROM T_CHECK_SUCESS_1;
INSERT INTO T_CHECK_SUCESS_1 VALUES (4, 'MINO', 'SUCCESSFUL', 10,1,10, 10);
UPDATE T_CHECK_SUCESS_1 SET F3 = 0 WHERE sn = 2;
ALTER TABLE T_CHECK_SUCESS_1  DROP CONSTRAINT chk_outline_cons_1;
ALTER TABLE T_CHECK_SUCESS_1  ADD CONSTRAINT chk_outline_cons_2 check(F3 - F4 > 100);
ALTER TABLE T_CHECK_SUCESS_1  ADD CONSTRAINT chk_outline_cons_2 check(F3 - F4 <= 0 );
INSERT INTO T_CHECK_SUCESS_1 VALUES (4, 'MINOR', 'SUCCESSFUL', 1, 1, 100, 90);
ALTER TABLE T_CHECK_SUCESS_1  DROP CONSTRAINT chk_outline_cons_2;
INSERT INTO T_CHECK_SUCESS_1 VALUES (4, 'MINOR', 'SUCCESSFUL', 1, 2, 100, 90);
SELECT * FROM T_CHECK_SUCESS_1 WHERE SN =4;
DROP TABLE T_CHECK_SUCESS_1 PURGE;
FLASHBACK TABLE T_CHECK_SUCESS_1 TO BEFORE DROP;

DROP TABLE IF EXISTS T_CHECK_SUCESS_2;
CREATE TABLE T_CHECK_SUCESS_2
(
    sn           NUMBER(38),
    operation    VARCHAR2(516)  not null,
    logLevel     VARCHAR2(7)   not null constraint chk_sec_level check(logLevel in ('WARNING','MINOR','RISK')),
    userId       VARCHAR2(512) not null,
    datetime     NUMBER(38)    not null,
    source       VARCHAR2(300)  not null,
    terminal     VARCHAR2(60)  not null,
    targetObj    VARCHAR2(765)  not null,
    result       VARCHAR2(10)  not null constraint chk_sec_result check(result in ('SUCCESSFUL','FAILURE','POK')),
    detail       VARCHAR2(3072) not null,
    addInfo      VARCHAR2(2400),
    PRIMARY KEY ( sn ) using index tablespace users
)tablespace users;
SELECT CONS_TYPE, COLS, COL_LIST, COND_TEXT FROM SYS_CONSTRAINT_DEFS WHERE USER#=0 AND  TABLE# = (SELECT ID  FROM SYS_TABLES WHERE  NAME = 'T_CHECK_SUCESS_2') ORDER BY CONS_TYPE DESC, COLS DESC, COL_LIST DESC;
DROP TABLE T_CHECK_SUCESS_2;


DROP TABLE IF EXISTS T_CHECK_SUCESS_3;
create table T_CHECK_SUCESS_3 (
    ObjectTypeId number(10) not null,
    NeTypeId number(10) not null,
    ServiceType number(10) null check(ServiceType in(0,1,2,3,107)),
    primary key(ObjectTypeId,NeTypeId)
);
SELECT CONS_TYPE, COLS, COL_LIST, COND_TEXT FROM SYS_CONSTRAINT_DEFS WHERE USER#=0 AND  TABLE# = (SELECT ID  FROM SYS_TABLES WHERE  NAME = 'T_CHECK_SUCESS_3') ORDER BY CONS_TYPE DESC, COLS DESC, COL_LIST DESC;
DROP TABLE T_CHECK_SUCESS_3;

 
drop table if exists T_CHECK_SUCESS_4;
create table T_CHECK_SUCESS_4(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp, check (f1 + f2 < 40))
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);
insert into T_CHECK_SUCESS_4 values (9, 30, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')); 
insert into T_CHECK_SUCESS_4 values (9, 31, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')); 
insert into T_CHECK_SUCESS_4 values (19, 20, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')); 
insert into T_CHECK_SUCESS_4 values (19, 21, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')); 
insert into T_CHECK_SUCESS_4 values (29, 10, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into T_CHECK_SUCESS_4 values (29, 11, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into T_CHECK_SUCESS_4 values (31, 8, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')); 
insert into T_CHECK_SUCESS_4 values (31, 9, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3')); 

select * from T_CHECK_SUCESS_4;
update T_CHECK_SUCESS_4 SET f2 = 100 WHERE f1 = 9;
update T_CHECK_SUCESS_4 SET f2 = 19 WHERE f1 = 9;
select * from T_CHECK_SUCESS_4 where f1 = 9;
update T_CHECK_SUCESS_4 SET f2 = 100 WHERE f1 = 29;
update T_CHECK_SUCESS_4 SET f2 = 9 WHERE f1 = 29;
select * from T_CHECK_SUCESS_4 where f1 = 29;
drop table T_CHECK_SUCESS_4;

DROP TABLE IF EXISTS T_CHECK_SUCESS_5;
CREATE TABLE T_CHECK_SUCESS_5
( 
    F_INT_1 INT check (F_INT_1 IS NOT NULL), 
	F_INT_2 INT, 
    F_FLOAT_1 FLOAT,	
	F_INT_3 INT, 	
	F_FLOAT_2 FLOAT,	
	F_CHAR CHAR(10) check(F_CHAR NOT IN ('1','2','3') AND F_CHAR <>  ANY('aaa', 'bbb', 'ccc')),  
	F_NUM_0 NUMBER,
	F_NUM_1 NUMBER,
    F_NUM_2 NUMBER,
	F_NUM_3 NUMBER,
	F_VHARCHAR VARCHAR(10) check (F_VHARCHAR like 'ABC\%%123_' ESCAPE '\'),
  --constraint chk_outline_comparison_cons check ((F_INT_2, F_FLOAT_1) = ANY ((1,1.00), (2,2.00), (3, 3.00), (4,4.00))),
	constraint chk_outline_in_cons check ((F_INT_3, F_FLOAT_2) NOT IN ((5, 5.00), (6,6.00), (7, 7.00),(8,8.00))),
	constraint chk_outline_logical check (F_NUM_0 > 10 AND F_NUM_1 < 1000 OR NOT F_NUM_2 = 10),
	constraint chk_outline_range check (F_NUM_3 BETWEEN 2 AND 6)
)tablespace users;

INSERT INTO T_CHECK_SUCESS_5 VALUES(NULL, 1, 1.00, 4, 4.00, '4',   11, 100,  10, 2, 'ABC%DE123*');
--INSERT INTO T_CHECK_SUCESS_5 VALUES(1,    5, 5.00, 4, 4.00, '4',   11, 100,  10, 2, 'ABC%DE123*');
INSERT INTO T_CHECK_SUCESS_5 VALUES(1,    1, 1.00, 5, 5.00, '4',   11, 100,  10, 2, 'ABC%DE123*');
INSERT INTO T_CHECK_SUCESS_5 VALUES(1,    1, 1.00, 4, 4.00, 'aaa', 11, 100,  10, 2, 'ABC%DE123*');
INSERT INTO T_CHECK_SUCESS_5 VALUES(1,    1, 1.00, 4, 4.00, '4',   11, 1001, 10, 2, 'ABC%DE123*');
INSERT INTO T_CHECK_SUCESS_5 VALUES(1,    1, 1.00, 4, 4.00, '4',   11, 100,  10, 7, 'ABC%DE123*');
INSERT INTO T_CHECK_SUCESS_5 VALUES(1,    1, 1.00, 4, 4.00, '4',   11, 100,  10, 1, 'ABC%DE123*');
INSERT INTO T_CHECK_SUCESS_5 VALUES(1,    1, 1.00, 4, 4.00, '4',   11, 100,  10, 2, 'AB%DE123*');
INSERT INTO T_CHECK_SUCESS_5 VALUES(1,    1, 1.00, 4, 4.00, '4',   11, 100,  10, 2, 'ABC%DE123');
INSERT INTO T_CHECK_SUCESS_5 VALUES(1,    1, 1.00, 4, 4.00, '4',   11, 100,  10, 2, 'ABC%123*');
INSERT INTO T_CHECK_SUCESS_5 VALUES(2,    1, 1.00, 4, 4.00, '4',   11, 100,  10, 2, 'ABC%DE123A');
INSERT INTO T_CHECK_SUCESS_5 VALUES(3,    2, 2.00, 9, 9.00, 'ddd', 10, 1001, 11, 5, 'ABC%DE123B');
SELECT * FROM T_CHECK_SUCESS_5;
DROP TABLE T_CHECK_SUCESS_5;

DROP TABLE IF EXISTS T_CHECK_SUCESS_6;
CREATE TABLE T_CHECK_SUCESS_6
( 
    F_INT_1 INT, 
	F_INT_2 INT  
)tablespace users;
ALTER TABLE T_CHECK_SUCESS_6 ADD COLUMN F_INT_3 INT CONSTRAINT F_INT_3_CHECK CHECK(F_INT_3_CHECK > 10);
ALTER TABLE T_CHECK_SUCESS_6 ADD COLUMN F_INT_3 INT CONSTRAINT F_INT_3_CHECK CHECK(F_INT_2 > 10);

ALTER TABLE T_CHECK_SUCESS_6 ADD COLUMN F_INT_3 INT CONSTRAINT F_INT_3_CHECK CHECK(F_INT_3 > 10);
INSERT INTO T_CHECK_SUCESS_6 VALUES(1,1,10);
INSERT INTO T_CHECK_SUCESS_6 VALUES(1,1,100);
SELECT * FROM T_CHECK_SUCESS_6;
update T_CHECK_SUCESS_6 SET F_INT_3 = 10 WHERE F_INT_1 = 1;
update T_CHECK_SUCESS_6 SET F_INT_3 = 200 WHERE F_INT_1 = 1;
SELECT * FROM T_CHECK_SUCESS_6;
ALTER TABLE T_CHECK_SUCESS_6 ADD CONSTRAINT F_INT_2_3_CHECK CHECK(F_INT_3 + F_INT_2 < 100);
ALTER TABLE T_CHECK_SUCESS_6 ADD CONSTRAINT F_INT_2_3_CHECK CHECK(F_INT_3 + F_INT_2 > 100);
INSERT INTO T_CHECK_SUCESS_6 VALUES(2, 89, 11);
INSERT INTO T_CHECK_SUCESS_6 VALUES(2, 90, 11);
ALTER TABLE T_CHECK_SUCESS_6 DROP COLUMN F_INT_3;
ALTER TABLE T_CHECK_SUCESS_6 DROP CONSTRAINT F_INT_2_3_CHECK;
ALTER TABLE T_CHECK_SUCESS_6 MODIFY F_INT_3 NUMBER;
ALTER TABLE T_CHECK_SUCESS_6 DROP COLUMN F_INT_3;
SELECT * FROM T_CHECK_SUCESS_6;
DROP TABLE  T_CHECK_SUCESS_6;

DROP TABLE IF EXISTS T_CHECK_SUCESS_7;
CREATE TABLE T_CHECK_SUCESS_7
( 
    F_VARCHAR_1 VARCHAR(100), 
	F_VARCHAR_2 VARCHAR(100),
	constraint REGEXP_LIKE_CHECK check (REGEXP_LIKE (F_VARCHAR_1,'([aeiou])\1', 'i') AND REGEXP_LIKE (F_VARCHAR_2, '^Ste(v|ph)en$'))	
)tablespace users;

insert into T_CHECK_SUCESS_7 values('De Haan', 'Steven');
insert into T_CHECK_SUCESS_7 values('De Haan', 'Stephen');
insert into T_CHECK_SUCESS_7 values('De Haan', 'Stepven');
insert into T_CHECK_SUCESS_7 values('De Haan', 'StepHen');

insert into T_CHECK_SUCESS_7 values('De Haan',   'Steven');
insert into T_CHECK_SUCESS_7 values('bbb',       'Steven');
insert into T_CHECK_SUCESS_7 values('b Aabb',    'Steven');
insert into T_CHECK_SUCESS_7 values('Greenberg', 'Steven');
insert into T_CHECK_SUCESS_7 values('Khoo',      'Steven');
insert into T_CHECK_SUCESS_7 values('Lee',       'Steven');
insert into T_CHECK_SUCESS_7 values('Bloom',     'Steven');
SELECT * FROM T_CHECK_SUCESS_7;
DROP TABLE  T_CHECK_SUCESS_7;

DROP TABLE IF EXISTS T_CHECK_SUCESS_8;
CREATE TABLE T_CHECK_SUCESS_8
(
    sn           NUMBER(38),
	logLevel     VARCHAR2(7)   not null ,
	result       VARCHAR2(20)  not null	,
    PRIMARY KEY ( sn ) using index tablespace users
)tablespace users;
ALTER TABLE T_CHECK_SUCESS_8 ADD CONSTRAINT CHK_SEC_LEVEL CHECK(LOGLEVEL IN ('WARNING','MINOR','RISK'));
ALTER TABLE T_CHECK_SUCESS_8 ADD CONSTRAINT CHK_SEC_RESULT CHECK(RESULT IN ('SUCCESSFUL','FAILURE','PARTIAL_SUCCESS'));
insert into T_CHECK_SUCESS_8 values (1, 'WARNING', 'PARTIAL_SUCCESS');
insert into T_CHECK_SUCESS_8 values (2, 'MINOR1', 'SUCCESSFUL');
insert into T_CHECK_SUCESS_8 values (3, 'RISK', 'FAILURE1');
DROP TABLE T_CHECK_SUCESS_8;

drop table IF EXISTS tbl_Statistic_UserQueryFreq;
create table tbl_Statistic_UserQueryFreq(name varchar(4));
insert into tbl_Statistic_UserQueryFreq values('Jhon');
ALTER TABLE tbl_Statistic_UserQueryFreq ADD CONSTRAINT CUSTOM_constr1 CHECK (Name='Sand');
insert into tbl_Statistic_UserQueryFreq values('Jhon');
drop table  tbl_Statistic_UserQueryFreq;

create table tbl_Statistic_UserQueryFreq(f1 int, name varchar(4))
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);

insert into tbl_Statistic_UserQueryFreq values(15,'Jhon'),(5, 'Sand'), (123, 'Sand');
ALTER TABLE tbl_Statistic_UserQueryFreq ADD CONSTRAINT CUSTOM_constr1 CHECK (Name='Sand');
insert into tbl_Statistic_UserQueryFreq values(15,'Jhon'),(5, 'Sand'), (123, 'Sand');
drop table  tbl_Statistic_UserQueryFreq;

drop table IF EXISTS T_CHECK_SUCESS_9;
create table T_CHECK_SUCESS_9(fd int);
insert into T_CHECK_SUCESS_9 values (10),(20);
ALTER TABLE T_CHECK_SUCESS_9 ADD CONSTRAINT CHK_FD CHECK(FD > 15);
select SQL_TEXT,REF_COUNT,IS_FREE,CLEANED from v$sqlarea where SQL_TEXT = 'SELECT * FROM SYS.T_CHECK_SUCESS_9 WHERE NOT FD > 15';
ALTER TABLE T_CHECK_SUCESS_9 ADD CONSTRAINT CHK_FD CHECK(FD > 5);
select SQL_TEXT,REF_COUNT,IS_FREE,CLEANED from v$sqlarea where SQL_TEXT = 'SELECT * FROM SYS.T_CHECK_SUCESS_9 WHERE NOT FD > 5';
DROP TABLE T_CHECK_SUCESS_9;

CREATE USER TEST_CHECK IDENTIFIED BY Root1234;
GRANT DBA TO TEST_CHECK;
CONNECT TEST_CHECK/Root1234@127.0.0.1:1611
drop table IF EXISTS T_CHECK_SUCESS_9;
create table T_CHECK_SUCESS_9(fd int);
insert into T_CHECK_SUCESS_9 values (10),(20);
ALTER TABLE T_CHECK_SUCESS_9 ADD CONSTRAINT CHK_FD CHECK(FD > 15);
select SQL_TEXT,REF_COUNT,IS_FREE,CLEANED from v$sqlarea where SQL_TEXT = 'SELECT * FROM TEST_CHECK.T_CHECK_SUCESS_9 WHERE NOT FD > 15';
ALTER TABLE T_CHECK_SUCESS_9 ADD CONSTRAINT CHK_FD CHECK(FD > 5);
select SQL_TEXT,REF_COUNT,IS_FREE,CLEANED from v$sqlarea where SQL_TEXT = 'SELECT * FROM TEST_CHECK.T_CHECK_SUCESS_9 WHERE NOT FD > 5';
DROP TABLE T_CHECK_SUCESS_9 cascade CONSTRAINTS purge;
CONNECT sys/Huawei@123@127.0.0.1:1611 
DROP USER TEST_CHECK CASCADE;

drop table if exists test;
create table test (fd_int int constraint c_fd_int check (fd_int > 10), fd_varchar varchar(10), constraint c_fd_int_fd_varchar check( fd_int < 20 and fd_varchar in ('WARNING','MINOR','RISK')));
insert into test values(null, 'WARNING');
insert into test values(15, 'WARNING');
insert into test (fd_varchar, fd_int) values(null, null);
alter table test drop constraint c_fd_int_fd_varchar;
update test set fd_int=null, fd_varchar=null where fd_int = 15;
select * from test order by fd_varchar;
drop table test;


CREATE TABLE I_SYS_VOLUMETYPE
(
id VARBINARY(16) NOT NULL DEFAULT null,
class_Name VARCHAR(60 BYTE) NOT NULL DEFAULT ' ',
class_Id BINARY_BIGINT NOT NULL DEFAULT 0,
last_Modified BINARY_BIGINT NOT NULL DEFAULT 0,
collectorId VARCHAR(36 BYTE),
reportSn BINARY_BIGINT,
ownerType VARCHAR(64 BYTE),
ownerName VARCHAR(128 BYTE),
lastMonitorTime BINARY_BIGINT,
regionId VARBINARY(16),
name VARCHAR(255 BYTE) NOT NULL DEFAULT ' ',
confirmStatus VARCHAR(4000 BYTE),
remark VARCHAR(4096 BYTE),
nativeId VARCHAR(256 BYTE),
ownerId BINARY_BIGINT,
extraSpecs VARCHAR(4096 BYTE),
tags VARCHAR(4096 BYTE),
keystoneId BINARY_BIGINT,
keystoneIdDriver VARCHAR(256 BYTE),
PRIMARY KEY(id),
CHECK(`confirmStatus` in ('confirmed','unconfirmed'))
);

 DROP TABLE IF EXISTS I_SYS_VOLUMETYPE;
 CREATE TABLE I_SYS_VOLUMETYPE
 (
 id VARBINARY(16) NOT NULL,
 confirmStatus VARCHAR(4000 BYTE),
 confirmStatus2 VARCHAR(4000 BYTE),
 confirmStatus3 VARCHAR(4000 BYTE),
 confirmStatus4 VARCHAR(4000 BYTE),
 confirmStatus5 VARCHAR(4000 BYTE),
 confirmStatus6 VARCHAR(4000 BYTE),
 confirmStatus7 VARCHAR(4000 BYTE),
 confirmStatus8 VARCHAR(4000 BYTE),
 confirmStatus9 VARCHAR(4000 BYTE),
 confirmStatus10 VARCHAR(4000 BYTE),
 PRIMARY KEY(id),
 CHECK(confirmStatus in ('confirmed','unconfirmed'))
 );
insert into I_SYS_VOLUMETYPE (id,confirmStatus) values('xyz','unconfirmed');
insert into I_SYS_VOLUMETYPE (id,confirmStatus) values('xyz1',upper('unconfirmed'));
update I_SYS_VOLUMETYPE set confirmStatus='confirmed' where id='xyz';
update I_SYS_VOLUMETYPE set confirmStatus=upper('confirmed') where id='xyz';
DROP TABLE IF EXISTS I_SYS_VOLUMETYPE;

drop table if exists t_check_foobar1;
create table t_check_foobar1 (c1 int,`ad` VARCHAR(4000) NULL,`AD` VARCHAR(4000) NULL);
alter table t_check_foobar1 add constraint cc check(ad default 30);
drop table t_check_foobar1;

drop table if exists t1;
create table t1(a int,check(a in(1,2)),b int);
insert into t1 values(null,2);
update t1 set a=3;
drop table t1;

--DTS2018112404018
drop table if exists t2;
create table t2(a int,b char(10));
insert into t2 values(-32,78);
alter table t2 add c int;
alter table t2 modify c int check(c <0);
update t2 set a=10 where b='78';
select * from t2;
update t2 set a=10,c = 9 where b='78';
update t2 set a=10,c = -1 where b='78';
select * from t2;
drop table t2;
--DTS2018120314928
drop table if exists check_minus;
create table check_minus(a int,check(-a!=3));
insert into check_minus values(-3);
insert into check_minus values(3);

--DTS2019030806421
DROP TABLE IF EXISTS TBL_TWAMP_TEST CASCADE CONSTRAINTS;
CREATE TABLE TBL_TWAMP_TEST
(
  ID bigint NOT NULL,
  STATUS int,
  MONITORMODEL int,
  TENANTID VARCHAR(255),
  TENANTNAME VARCHAR(255),
  LEASEDLINEID VARCHAR(255),
  LEASEDLINENAME VARCHAR(255),
  CONNECTIONID VARCHAR(255),
  SRCSEGMENTID VARCHAR(255),
  TARGETSEGMENTID VARCHAR(255),
  SENDERTYPE int,
  SOURCEADDRESS VARCHAR(16),
  SRCDEVICEIFNAME VARCHAR(32),
  SRCDEVICEOWNERID VARCHAR(255),
  SRCDEVICEID VARCHAR(255),
  SRCDEVICEUUID VARCHAR(255),
  SRCDEVICEIFUUID VARCHAR(255),
  SRCTESTID bigint,
  SRCTESTSTATUS int,
  SRCDEVICENAME VARCHAR(255),
  SRCDEVICETYPE int,
  TARGETADDRESS VARCHAR(16),
  TARGETNAME VARCHAR(255),
  TESTSTATUS int,
  NICKNAME VARCHAR(32),
  VRFNAME VARCHAR(32),
  TESTFLAG int,
  TARGETDEVICETYPE int,
  TARGETDEVICEOWNERID VARCHAR(255),
  TARGETDEVICEID VARCHAR(255),
  TARGETDEVICEUUID VARCHAR(255),
  TARGETDEVICEIFUUID VARCHAR(255),
  REFLECTORSTATUS int,
  REFLECTORID bigint,
  CYCTPGROUP int,
  CYCTPID bigint,
  CYCTPNAME VARCHAR(255),
  DOMAINSRCTESTUUID VARCHAR(64),
  SRCDEVICEIFID VARCHAR(36),
  TARGETDEVICEIFID VARCHAR(36),
  CREATETIME int,
  UPDATETIME int,
  ERRORCODE int,
  ERRORMESSAGE VARCHAR(255),
  PRIMARY KEY(ID)
);
INSERT INTO TBL_TWAMP_TEST (ID,STATUS,MONITORMODEL,TENANTID,TENANTNAME,LEASEDLINEID,LEASEDLINENAME,CONNECTIONID,SRCSEGMENTID,TARGETSEGMENTID,SENDERTYPE,SOURCEADDRESS,SRCDEVICEIFNAME,SRCDEVICEOWNERID,SRCDEVICEID,SRCDEVICEUUID,SRCDEVICEIFUUID,SRCTESTID,SRCTESTSTATUS,SRCDEVICENAME,SRCDEVICETYPE,TARGETADDRESS,TARGETNAME,TESTSTATUS,NICKNAME,VRFNAME,TESTFLAG,TARGETDEVICETYPE,TARGETDEVICEOWNERID,TARGETDEVICEID,TARGETDEVICEUUID,TARGETDEVICEIFUUID,REFLECTORSTATUS,REFLECTORID,CYCTPGROUP,CYCTPID,CYCTPNAME,DOMAINSRCTESTUUID,SRCDEVICEIFID,TARGETDEVICEIFID,CREATETIME,UPDATETIME,ERRORCODE,ERRORMESSAGE) values
  (1,0,0,'8978817485070337','Carrier','8990307659661321','optionA_L3VPN_vlan1700','8990307659661325','8990307659661319','8990307659661319',0,'117.0.2.1','GigabitEthernet0/3/10.3','9134228721622858249','8987417376411648','7e19387a-3efa-11e9-a6fc-1d99d9171280','66d81b33-3f46-11e9-8ce8-286ed488d02a',null,0,'Core3_NE40E-M2E',0,'117.0.1.1','Core1_CX600-M2F',0,null,null,null,0,'9134228721622858249','8985439409082368','28e69a10-3e6d-11e9-a6fc-1d99d9171280','153a4bf6-3f31-11e9-8ce8-286ed488d02a',0,null,null,null,null,null,null,null,null,null,null,null);
COMMIT;
ALTER TABLE TBL_TWAMP_TEST MODIFY ID AUTO_INCREMENT;
ALTER TABLE TBL_TWAMP_TEST AUTO_INCREMENT = 101;

DROP TABLE IF EXISTS TBL_TWAMP_TEST_EXT CASCADE CONSTRAINTS;
CREATE TABLE TBL_TWAMP_TEST_EXT
(
  ID bigint NOT NULL,
  STATUS int,
  FREQUENCY int NOT NULL,
  RESULTPROCESSORURLS VARCHAR(255),
  CEVLAN int NOT NULL,
  CLIENTSDLFLAG bigint NOT NULL,
  CODETYPE int,
  CONTINUETEST bigint NOT NULL,
  DATAFILL VARCHAR(255),
  DATASIZE int NOT NULL,
  DSFIELD int NOT NULL,
  DURATION int NOT NULL,
  IFINDEX int NOT NULL,
  L3VPNSERVICENAME VARCHAR(255),
  LOOPCHECK bigint NOT NULL,
  NEGOTIATE bigint NOT NULL,
  PACKETCOUNT int NOT NULL,
  PADDINGTYPE bigint NOT NULL,
  PEVLAN int NOT NULL,
  PTNREFLECTORID int NOT NULL,
  PWE3SERVICENAME VARCHAR(255),
  REFLECTORPORT int NOT NULL,
  SENDINTERVAL int NOT NULL,
  SESSIONID int NOT NULL,
  SRCUDPPORT int NOT NULL,
  TARGETDEVICEIFNAME VARCHAR(255),
  TARGETVPN VARCHAR(255),
  THRESHOLDTEMPLATEID VARCHAR(255),
  TIMEMODE int,
  TIMEOUT int NOT NULL,
  CITYNODEIP VARCHAR(16),
  CITYNODETESTID bigint NOT NULL,
  TWAMPPERIOD int,
  MULTIFLOW bigint NOT NULL,
  PRIMARY KEY(ID),
  CHECK(ceVlan>=0),
  CHECK(ifIndex>=0),
  CHECK(peVlan>=0),
  CHECK(reflectorPort<=65535),
  CHECK(srcUdpPort>=0)
);
INSERT INTO TBL_TWAMP_TEST_EXT (ID,STATUS,FREQUENCY,RESULTPROCESSORURLS,CEVLAN,CLIENTSDLFLAG,CODETYPE,CONTINUETEST,DATAFILL,DATASIZE,DSFIELD,DURATION,IFINDEX,L3VPNSERVICENAME,LOOPCHECK,NEGOTIATE,PACKETCOUNT,PADDINGTYPE,PEVLAN,PTNREFLECTORID,PWE3SERVICENAME,REFLECTORPORT,SENDINTERVAL,SESSIONID,SRCUDPPORT,TARGETDEVICEIFNAME,TARGETVPN,THRESHOLDTEMPLATEID,TIMEMODE,TIMEOUT,CITYNODEIP,CITYNODETESTID,TWAMPPERIOD,MULTIFLOW) values
  (1,1,300,null,0,0,null,0,'superutrafficutraffic',1454,0,300,0,null,0,0,20,0,0,0,null,863,20,0,863,'GigabitEthernet0/3/15.1',null,null,null,3,null,0,1,0);
COMMIT;

UPDATE TBL_TWAMP_TEST T1 INNER JOIN TBL_TWAMP_TEST_EXT T2   SET T1.STATUS = 1 ,T2.STATUS = 2   WHERE T1.ID = T2.ID  AND T1.LEASEDLINEID IN   ( 8990307659661321   );
SELECT STATUS FROM TBL_TWAMP_TEST;
SELECT STATUS FROM TBL_TWAMP_TEST_EXT;
UPDATE TBL_TWAMP_TEST T1 INNER JOIN TBL_TWAMP_TEST_EXT T2   SET T1.STATUS = 1 ,T2.ceVlan = -1   WHERE T1.ID = T2.ID  AND T1.LEASEDLINEID IN   ( 8990307659661321   );
UPDATE TBL_TWAMP_TEST T1 INNER JOIN TBL_TWAMP_TEST_EXT T2   SET T1.STATUS = 1 ,T2.reflectorPort = 65536   WHERE T1.ID = T2.ID  AND T1.LEASEDLINEID IN   ( 8990307659661321   );
DROP TABLE IF EXISTS TBL_TWAMP_TEST;
DROP TABLE IF EXISTS TBL_TWAMP_TEST_EXT;

--DTS2019081512936
CONN / AS SYSDBA
DROP TABLE IF EXISTS MODIFY_COLUMN_ZZC_T1;
DROP TABLE IF EXISTS MODIFY_COLUMN_ZZC_T2;

CREATE TABLE MODIFY_COLUMN_ZZC_T1 (ID INT NOT NULL CHECK(ID>100),NAME VARCHAR(20));
INSERT INTO MODIFY_COLUMN_ZZC_T1(ID) VALUES (200); 
ALTER TABLE MODIFY_COLUMN_ZZC_T1 MODIFY NAME VARCHAR(20) CHECK (NAME IS NOT NULL);
ALTER TABLE MODIFY_COLUMN_ZZC_T1 MODIFY ID INT CHECK (ID<150);

CREATE TABLE MODIFY_COLUMN_ZZC_T2(COL_1 TIMESTAMP WITHOUT TIME ZONE CHECK(COL_1<(UTC_TIMESTAMP + 1)), COL_2 TIMESTAMP WITH TIME ZONE, COL_3 INTERVAL DAY TO SECOND, COL_4 TIMESTAMP WITH LOCAL TIME ZONE, COL_5 TIMESTAMP, COL_6 INTERVAL YEAR TO MONTH, COL_7 DATE, COL_8 DATETIME);
INSERT INTO MODIFY_COLUMN_ZZC_T2 VALUES(UTC_TIMESTAMP,UTC_TIMESTAMP,(INTERVAL '4 5:12:10.222' DAY TO SECOND(3)),UTC_TIMESTAMP,UTC_TIMESTAMP,(INTERVAL '12' YEAR),UTC_TIMESTAMP,UTC_TIMESTAMP);
ALTER TABLE MODIFY_COLUMN_ZZC_T2 MODIFY COL_1 TIMESTAMP WITHOUT TIME ZONE CHECK (COL_1<(UTC_TIMESTAMP-1));

DROP TABLE IF EXISTS MODIFY_COLUMN_ZZC_T1;
DROP TABLE IF EXISTS MODIFY_COLUMN_ZZC_T2;

--first step, expected right
drop table if exists datatype_alter_table_001;
create table datatype_alter_table_001(c_date date);
alter table datatype_alter_table_001 modify c_date INT SIGNED CONSTRAINT t_alter_constr5 check(c_date!=4567888);

--seconde step, expected error
drop table datatype_alter_table_001;
create table datatype_alter_table_001(c_date date);
insert into datatype_alter_table_001 values(to_date('2018-08-11', 'YYYY-MM-DD'));
alter table datatype_alter_table_001 modify c_date INT SIGNED CONSTRAINT t_alter_constr5 check(c_date!=4567888);

--seconde step, expected right
drop table datatype_alter_table_001;
create table datatype_alter_table_001(c_date date);
insert into datatype_alter_table_001 values(to_date('2018-08-11', 'YYYY-MM-DD'));
insert into datatype_alter_table_001 values(to_date('2018-08-11', 'YYYY-MM-DD'));
delete from datatype_alter_table_001;
alter table datatype_alter_table_001 modify c_date INT SIGNED CONSTRAINT t_alter_constr5 check(c_date!=4567888);
drop table datatype_alter_table_001;

 
drop table if exists tab_check_rewrite_cond;
drop table if exists tab_check_any_cond2;
create table tab_check_any_cond2(id int);
create table tab_check_rewrite_cond(fd int CHECK (fd < (select id from tab_check_any_cond2))); --failed
drop table tab_check_any_cond2;

create table tab_check_rewrite_cond(fd int, fd2 varchar(100), CONSTRAINT tab_check_any_chk2 check (fd in (10)));
insert into tab_check_rewrite_cond (fd) values(10);
insert into tab_check_rewrite_cond (fd) values(20);
alter table tab_check_rewrite_cond drop constraint tab_check_any_chk2;
alter table tab_check_rewrite_cond add constraint tab_check_any_chk1 CHECK ((fd, fd2) in ((0,'0'),(1,'1'),(2,'2'),(3,'3'),(4,'4'),(5,'5'),(6,'6'),(7,'7'),(8,'8'),(9,'9'),(10,'10')));
insert into tab_check_rewrite_cond values(0,'1');
insert into tab_check_rewrite_cond values(0,'0');
insert into tab_check_rewrite_cond values(10,'10');
select * from tab_check_rewrite_cond order by fd, fd2;
alter table tab_check_rewrite_cond drop constraint tab_check_any_chk1;
alter table tab_check_rewrite_cond add constraint tab_check_any_chk1 CHECK (fd = any (0,1,2,3,4,5,6,7,8,9,10));
insert into tab_check_rewrite_cond values(10, '11');
insert into tab_check_rewrite_cond values(11, '11');
select * from tab_check_rewrite_cond order by fd, fd2;

drop table tab_check_rewrite_cond;
--20201028
DROP TABLE IF EXISTS "I_SYS_PSU" CASCADE CONSTRAINTS;
CREATE TABLE "I_SYS_PSU"
(
  "id" VARBINARY(16) NOT NULL,
  "class_Name" VARCHAR(384 BYTE) NOT NULL,
  "class_Id" BINARY_BIGINT NOT NULL,
  "collectorId" VARCHAR(36 BYTE),
  "reportSn" BINARY_BIGINT,
  "last_Modified" BINARY_BIGINT NOT NULL,
  "tenantId" VARCHAR(64 BYTE),
  "ownerType" VARCHAR(192 BYTE),
  "ownerName" VARCHAR(384 BYTE),
  "lastMonitorTime" BINARY_BIGINT,
  "regionId" VARBINARY(16),
  "name" VARCHAR(384 BYTE) NOT NULL,
  "confirmStatus" VARCHAR(4000 BYTE),
  "remark" CLOB,
  "nativeId" VARCHAR(768 BYTE),
  "ownerId" BINARY_BIGINT,
  "productName" VARCHAR(384 BYTE),
  "manufacturer" VARCHAR(384 BYTE),
  "moDN" VARCHAR(768 BYTE),
  "inputMode" VARCHAR(4000 BYTE),
  "power" BINARY_DOUBLE,
  "status" VARCHAR(4000 BYTE),
  "healthStatus" VARCHAR(4000 BYTE),
  "powerConsumedWatts" BINARY_INTEGER,
  "vimResOriginId" VARCHAR(768 BYTE),
  "powerCapacityWatts" BINARY_DOUBLE,
  "slot" VARCHAR(144 BYTE)
);
CREATE INDEX "IDX_I_SYS_PSU_CLASS_ID" ON "I_SYS_PSU"("class_Id");
CREATE INDEX "IDX_I_SYS_PSU_COLLECTORID" ON "I_SYS_PSU"("collectorId");
CREATE INDEX "IDX_I_SYS_PSU_TENANTID_COLLECTORID" ON "I_SYS_PSU"("tenantId", "collectorId");
ALTER TABLE "I_SYS_PSU" ADD PRIMARY KEY("id");
ALTER TABLE "I_SYS_PSU" ADD CHECK(`inputMode` in ('AC','DC','AC_DC'));
ALTER TABLE "I_SYS_PSU" ADD CHECK(`status` in ('normal','offline','abnormal','unknown'));
ALTER TABLE "I_SYS_PSU" ADD CHECK(`healthStatus` in ('OK','Warning','Error','Critical','Offline','Unknown'));
INSERT INTO "I_SYS_PSU" ("id","class_Name","class_Id","collectorId","reportSn","last_Modified","tenantId","ownerType","ownerName","lastMonitorTime","regionId","name","confirmStatus","remark","nativeId","ownerId","productName","manufacturer","moDN","inputMode","power","status","healthStatus","powerConsumedWatts","vimResOriginId","powerCapacityWatts","slot") values
  (0x11EAFD943F595EA0AD81FA163E588E82,'SYS_Psu',10021,'c235bdc0-c1ac-39ef-a1ec-6993c18e88e9',1603286644392,1603286644602,null,'pimOps','pimOps_az2.dc2_oKQtR',1603286644568,0x01,'serverChassis#&#NE=34605950#&#4',null,null,'serverChassis#&#NE=34605950#&#4',6573640023318446379,'LTEON 750W SERVER PS',null,null,null,null,null,'Offline',125,'4',750,'5');
INSERT INTO "I_SYS_PSU" ("id","class_Name","class_Id","collectorId","reportSn","last_Modified","tenantId","ownerType","ownerName","lastMonitorTime","regionId","name","confirmStatus","remark","nativeId","ownerId","productName","manufacturer","moDN","inputMode","power","status","healthStatus","powerConsumedWatts","vimResOriginId","powerCapacityWatts","slot") values
  (0x11EAFD943F595EA1AD81FA163E588E82,'SYS_Psu',10021,'c235bdc0-c1ac-39ef-a1ec-6993c18e88e9',1603286644392,1603286644602,null,'pimOps','pimOps_az2.dc2_oKQtR',1603286644568,0x01,'serverChassis#&#NE=34605950#&#5',null,null,'serverChassis#&#NE=34605950#&#5',6573640023318446379,'LTEON 750W SERVER PS',null,null,null,null,null,'Unknown',125,'5',750,'6');
INSERT INTO "I_SYS_PSU" ("id","class_Name","class_Id","collectorId","reportSn","last_Modified","tenantId","ownerType","ownerName","lastMonitorTime","regionId","name","confirmStatus","remark","nativeId","ownerId","productName","manufacturer","moDN","inputMode","power","status","healthStatus","powerConsumedWatts","vimResOriginId","powerCapacityWatts","slot") values
  (0x11EAFD943F595EA2AD81FA163E588E82,'SYS_Psu',10021,'c235bdc0-c1ac-39ef-a1ec-6993c18e88e9',1603286644392,1603286644602,null,'pimOps','pimOps_az2.dc2_oKQtR',1603286644568,0x01,'serverChassis#&#NE=34605952#&#0',null,null,'serverChassis#&#NE=34605952#&#0',6573640023318446379,'LTEON 750W SERVER PS',null,null,null,null,null,'OK',112,'0',750,'1');
INSERT INTO "I_SYS_PSU" ("id","class_Name","class_Id","collectorId","reportSn","last_Modified","tenantId","ownerType","ownerName","lastMonitorTime","regionId","name","confirmStatus","remark","nativeId","ownerId","productName","manufacturer","moDN","inputMode","power","status","healthStatus","powerConsumedWatts","vimResOriginId","powerCapacityWatts","slot") values
  (0x11EAFD943F595EA3AD81FA163E588E82,'SYS_Psu',10021,'c235bdc0-c1ac-39ef-a1ec-6993c18e88e9',1603286644392,1603286644602,null,'pimOps','pimOps_az2.dc2_oKQtR',1603286644568,0x01,'serverChassis#&#NE=34605952#&#1',null,null,'serverChassis#&#NE=34605952#&#1',6573640023318446379,'LTEON 750W SERVER PS',null,null,null,null,null,'Error',125,'1',750,'2');
commit;
CREATE OR REPLACE PROCEDURE PRO_COLUMNOPER (TableName VARCHAR,ColumnName VARCHAR,CType INT,SqlStr VARCHAR)
AS
   Rows1 INT;
   concatSqlStr VARCHAR(4000);
BEGIN
Rows1 := 0;
SELECT COUNT(*) INTO Rows1  FROM MY_TAB_COLS WHERE TABLE_NAME=UPPER(TableName) AND COLUMN_NAME=REPLACE(ColumnName, '`', '');
IF CType=1 AND Rows1<=0 THEN
        concatSqlStr := CONCAT( 'ALTER TABLE ',TableName,' ADD COLUMN ',ColumnName,' ',SqlStr);
ELSIF CType=2 AND Rows1>0  THEN
        concatSqlStr := CONCAT('ALTER TABLE ',TableName,' MODIFY ',ColumnName,' ',SqlStr);
ELSIF CType=3 AND Rows1>0 THEN
        concatSqlStr := CONCAT('ALTER TABLE  ',TableName,' DROP COLUMN  ',ColumnName);
ELSE
        concatSqlStr :='';
END IF;
IF (concatSqlStr is not null) THEN
        EXECUTE IMMEDIATE concatSqlStr;
END IF;
END;
/
begin
 Pro_ColumnOper('I_SYS_PSU','`healthStatus`',2,'VARCHAR(4000) CHECK (`healthStatus` in (''OK'',''Warning'',''Critical'',''Offline'',''Unknown''))  ');
 end;
/