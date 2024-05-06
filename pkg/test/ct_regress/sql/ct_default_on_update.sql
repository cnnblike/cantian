conn / as sysdba
DROP TABLE IF EXISTS INTELLIGENT_TASK CASCADE  CONSTRAINTS;
DROP SEQUENCE IF EXISTS INTELLIGENT_TASK_ID_SEQ;
drop user IF EXISTS vcm cascade;
CREATE USER vcm IDENTIFIED by Cantian_234;
GRANT CREATE SESSION,CREATE TABLE,CREATE SEQUENCE,CREATE VIEW,CREATE PROCEDURE,CREATE TRIGGER to vcm;
conn vcm/Cantian_234@127.0.0.1:1611
DROP TABLE IF EXISTS INTELLIGENT_TASK CASCADE  CONSTRAINTS;
DROP SEQUENCE IF EXISTS INTELLIGENT_TASK_ID_SEQ;
CREATE SEQUENCE INTELLIGENT_TASK_ID_SEQ
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CYCLE  NOCACHE;
CREATE TABLE INTELLIGENT_TASK (
    ID BIGINT NOT NULL DEFAULT INTELLIGENT_TASK_ID_SEQ.NEXTVAL,
    DELETE_FLAG BOOLEAN NOT NULL DEFAULT FALSE,
    DIRTY_FLAG BOOLEAN NOT NULL
);
conn / as sysdba
insert into vcm.INTELLIGENT_TASK (DELETE_FLAG,DIRTY_FLAG) values(true,true);
commit;
conn vcm/Cantian_234@127.0.0.1:1611
insert into vcm.INTELLIGENT_TASK (DELETE_FLAG,DIRTY_FLAG) values(true,true);
commit;
select DELETE_FLAG, DIRTY_FLAG from vcm.INTELLIGENT_TASK;
conn / as sysdba
DROP TABLE IF EXISTS INTELLIGENT_TASK CASCADE  CONSTRAINTS;
DROP SEQUENCE IF EXISTS INTELLIGENT_TASK_ID_SEQ;
drop user vcm cascade;
conn / as sysdba 
DROP TABLE IF EXISTS INTELLIGENT_TASK CASCADE  CONSTRAINTS;
DROP SEQUENCE IF EXISTS INTELLIGENT_TASK_ID_SEQ;
drop user IF EXISTS vcm cascade;
CREATE USER vcm IDENTIFIED by Cantian_234;
GRANT CREATE SESSION,CREATE TABLE,CREATE SEQUENCE,CREATE VIEW,CREATE PROCEDURE,CREATE TRIGGER to vcm;
conn vcm/Cantian_234@127.0.0.1:1611
DROP TABLE IF EXISTS INTELLIGENT_TASK CASCADE  CONSTRAINTS;
DROP SEQUENCE IF EXISTS INTELLIGENT_TASK_ID_SEQ;
CREATE SEQUENCE INTELLIGENT_TASK_ID_SEQ
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CYCLE  NOCACHE;
CREATE TABLE INTELLIGENT_TASK (
    ID BIGINT NOT NULL DEFAULT INTELLIGENT_TASK_ID_SEQ.NEXTVAL,
    DELETE_FLAG BOOLEAN NOT NULL DEFAULT FALSE,
    DIRTY_FLAG BOOLEAN NOT NULL
);
conn / as sysdba 
insert into vcm.INTELLIGENT_TASK (DELETE_FLAG,DIRTY_FLAG) values(true,true);
commit;
conn vcm/Cantian_234@127.0.0.1:1611
insert into vcm.INTELLIGENT_TASK (DELETE_FLAG,DIRTY_FLAG) values(true,true);
commit;
select DELETE_FLAG, DIRTY_FLAG from vcm.INTELLIGENT_TASK;
conn / as sysdba 
DROP TABLE IF EXISTS INTELLIGENT_TASK CASCADE  CONSTRAINTS;
DROP SEQUENCE IF EXISTS INTELLIGENT_TASK_ID_SEQ;
drop user vcm cascade;
drop table if exists TRANS_RECORD_LOG;
create table TRANS_RECORD_LOG
(
   REF_NO               varchar(32) not null comment 'Sharding Key',
   TR_TIME              timestamp(3) not null default to_timestamp('2018-01-27','yyyy-mm-dd') comment 'Partitioning Key (Per Day)',  
   TR_API_ID            varchar(32) not null,
   CREATE_TIME          timestamp(3) not null default to_timestamp('2018-01-27','yyyy-mm-dd'),
   UPDATE_TIME          timestamp(3) default to_timestamp('2018-01-27','yyyy-mm-dd') ON UPDATE to_timestamp('2018-01-28','yyyy-mm-dd'), 
   primary key (REF_NO, TR_TIME)
);


alter table TRANS_RECORD_LOG  add COMMENT_FD INT comment 'ADD COMMENT FOR COMMENT_FD FILED';
alter table TRANS_RECORD_LOG  MODIFY COMMENT_FD INT comment 'MODIFY COMMENT FOR COMMENT_FD FILED';
alter table TRANS_RECORD_LOG  DROP COLUMN COMMENT_FD;

DROP TABLE TRANS_RECORD_LOG;

create table TRANS_RECORD_LOG
(
   REF_NO               varchar(32) not null comment 'Sharding Key',
   TR_TIME              timestamp(3) not null default to_timestamp('2018-01-27','yyyy-mm-dd') comment 'Partitioning Key (Per Day)',  
   TR_API_ID            varchar(32) not null,
   CREATE_TIME          timestamp(4) not null default CURRENT_TIMESTAMP(3),
   UPDATE_TIME          timestamp(3) default to_timestamp('2018-01-27','yyyy-mm-dd') ON UPDATE to_timestamp('2018-01-28','yyyy-mm-dd'), 
   primary key (REF_NO, TR_TIME)
);

create table TRANS_RECORD_LOG
(
   REF_NO               varchar(32) not null comment 'Sharding Key',
   TR_TIME              timestamp(3) not null default to_timestamp('2018-01-27','yyyy-mm-dd') comment 'Partitioning Key (Per Day)',  
   TR_API_ID            varchar(32) not null,
   CREATE_TIME          timestamp(3) not null default CURRENT_TIMESTAMP(3),
   UPDATE_TIME          timestamp(3) default to_timestamp('2018-01-27','yyyy-mm-dd') ON UPDATE to_timestamp('2018-01-28','yyyy-mm-dd'), 
   primary key (REF_NO, TR_TIME)
);

insert into TRANS_RECORD_LOG (REF_NO, TR_TIME, TR_API_ID) values('1', default, 'API1');
insert into TRANS_RECORD_LOG values('2', default, 'API2',default, default);
select REF_NO, TR_TIME, TR_API_ID, UPDATE_TIME  from TRANS_RECORD_LOG;

update TRANS_RECORD_LOG set TR_API_ID = 'API1_1' where REF_NO = '1';
select REF_NO, TR_TIME, TR_API_ID, UPDATE_TIME from TRANS_RECORD_LOG;

merge into TRANS_RECORD_LOG new using TRANS_RECORD_LOG old on (old.REF_NO = '2') 
when matched then update set new.TR_API_ID = 'API1_2' where new.REF_NO = '2'; 
select REF_NO, TR_TIME, TR_API_ID, UPDATE_TIME from TRANS_RECORD_LOG;

update TRANS_RECORD_LOG set TR_API_ID = 'API1_1_1' where TR_TIME = '2018-01-27 00:00:00.000000';
select REF_NO, TR_TIME, TR_API_ID, UPDATE_TIME from TRANS_RECORD_LOG;

drop table TRANS_RECORD_LOG;

drop table if exists table_default_stack;
create table table_default_stack(fd varchar(100) default 111111111111111111111111111);
insert into table_default_stack values(default);
select *  from table_default_stack;
drop table table_default_stack;

drop table if exists cr_tab_00029;
create table if not exists cr_tab_00029
(
c1 INT  not  null comment 'product_id', 
c2 INTEGER default (1+1) ,
c3 BINARY_INTEGER,
c4 BINARY_UINT32,
c5 INTEGER UNSIGNED,
c6 BINARY_BIGINT,
c7 BIGINT,
c8 BINARY_DOUBLE,
c9 DOUBLE,
c10 FLOAT,
c11 REAL,
c12 DECIMAL,
c13 NUMBER,
c14 CHAR(5) COLLATE UTF8_BIN,
c15 NCHAR(5) COLLATE UTF8_GENERAL_CI,
c16 CLOB COLLATE GBK_BIN ,
c17 VARCHAR(4096) default 'a' on update 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
c19 NVARCHAR(20),
c20 NVARCHAR2(20),
c21 BINARY(20),
c22 VARBINARY(20),
c23 IMAGE,
c24 BLOB,
c25 RAW(20),
c26 DATETIME  ,
c27 DATE default last_day(sysdate),
c28 TIMESTAMP,
c29 TIMESTAMP WITH TIME ZONE,
c30 TIMESTAMP WITH LOCAL TIME ZONE,
c31 INTERVAL YEAR TO MONTH,
c32 INTERVAL DAY TO SECOND,
c33 BOOl,
c34 boolean default lnnvl(1>0),
constraint pk_030 UNIQUE(c1) using index local( PARTITION training1 PCTFREE 8,PARTITION training2 PCTFREE 8,PARTITION training3 PCTFREE 80,PARTITION training4 PCTFREE 80) 
)
PARTITION BY RANGE(c1)
(
PARTITION training1 VALUES LESS than(100),
PARTITION training2 VALUES LESS than(200),
PARTITION training3 VALUES LESS than(300),
PARTITION training4 VALUES LESS than(MAXVALUE)
);

