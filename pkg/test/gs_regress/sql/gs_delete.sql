DROP TABLE IF EXISTS T_DELETE_1;
CREATE TABLE T_DELETE_1 (F_INT1 INT, F_INT2 INT, F_CHAR CHAR(16), F_DATE DATE);
INSERT INTO T_DELETE_1 VALUES(1,11,'A','2017-12-11 14:08:00');
INSERT INTO T_DELETE_1 VALUES(2,22,'B','2017-12-12 16:08:00');
INSERT INTO T_DELETE_1 VALUES(3,33,'C','2017-12-13 08:08:00');
INSERT INTO T_DELETE_1 VALUES(2,22,'B','2017-12-12 16:08:00');
INSERT INTO T_DELETE_1 VALUES(5,55,'E','2017-12-21 18:29:10');
INSERT INTO T_DELETE_1 VALUES(1,11,'A','2017-12-11 14:08:00');
INSERT INTO T_DELETE_1 VALUES(4,44,'D','2017-12-13 13:09:00');
DROP TABLE IF EXISTS T_DELETE_2;
CREATE TABLE T_DELETE_2 (F_INT1 INT, F_INT2 INT, F_CHAR CHAR(16), F_DATE DATE);
INSERT INTO T_DELETE_2 VALUES(1,11,'A','2017-12-11 14:08:00');
INSERT INTO T_DELETE_2 VALUES(2,22,'B','2017-12-12 16:08:00');
COMMIT;
SELECT * FROM T_DELETE_1;
SELECT * FROM T_DELETE_2;
DELETE T_DELETE_1 WHERE F_INT1=1 AND F_INT2=(SELECT F_INT2 FROM T_DELETE_2);
DELETE T_DELETE_1 WHERE F_INT1=1 AND F_INT2=(SELECT F_INT2 FROM T_DELETE_2 WHERE F_INT1=1 AND F_INT2=11);
COMMIT;
SELECT F_INT1, F_INT2 FROM T_DELETE_1;
DELETE T_DELETE_1 WHERE F_INT2=22;
COMMIT;
SELECT F_INT1, F_INT2 FROM T_DELETE_1;
DELETE T_DELETE_1 WHERE F_INT1=3 AND F_INT2=(SELECT 22 FROM DUAL);
DELETE T_DELETE_1 WHERE F_INT1=3 AND F_INT2=(SELECT 33 FROM DUAL);
COMMIT;
SELECT F_INT1, F_INT2 FROM T_DELETE_1;
DELETE T_DELETE_1 WHERE F_INT1=(SELECT 4 FROM DUAL) AND F_INT2=(SELECT 44 FROM DUAL);
COMMIT;
SELECT F_INT1, F_INT2 FROM T_DELETE_1;
DROP VIEW IF EXISTS TEST_V1;
CREATE VIEW TEST_V1 AS SELECT * FROM T_DELETE_1;
DELETE TEST_V1;
DELETE FROM TEST_V1;
DELETE FROM T_DELETE_1,T_DELETE_2;
DELETE T_DELETE_1,T_DELETE_2;
DELETE FROM T_DELETE_1,T_DELETE_2 FROM T_DELETE_1 JOIN T_DELETE_2 ON T_DELETE_1.F_INT1=T_DELETE_2.F_INT1;
DELETE T_DELETE_1,T_DELETE_2 USING T_DELETE_1 JOIN T_DELETE_2 ON T_DELETE_1.F_INT1=T_DELETE_2.F_INT1;
DELETE T_DELETE_1,T_DELETE_1 FROM T_DELETE_1 JOIN T_DELETE_2 ON T_DELETE_1.F_INT1=T_DELETE_2.F_INT1;
DELETE T_DELETE_1 FROM T_DELETE_1 JOIN T_DELETE_1 ON T_DELETE_1.F_INT1=T_DELETE_1.F_INT1;
DELETE TT2 FROM T_DELETE_1 TT1 JOIN T_DELETE_2 ON TT1.F_INT1=T_DELETE_2.F_INT1;
DELETE T_DELETE_1 FROM T_DELETE_1 TT1 JOIN T_DELETE_2 ON TT1.F_INT1=T_DELETE_2.F_INT1;
DELETE T_DELETE_1 FROM T_DELETE_1 FULL JOIN T_DELETE_2 ON TT1.F_INT1=T_DELETE_2.F_INT1;
DELETE TT2 FROM T_DELETE_1 JOIN (SELECT * FROM T_DELETE_2) TT2 ON T_DELETE_1.F_INT1=TT2.F_INT1;
DELETE V1 FROM T_DELETE_1 JOIN TEST_V1 V1 ON T_DELETE_1.F_INT1=V1.F_INT1;
DELETE TT1 FROM T_DELETE_1 TT1 JOIN T_DELETE_2 ON TT1.F_INT1=T_DELETE_2.F_INT1;
DELETE TT1 TT2 FROM T_DELETE_1 TT1 JOIN T_DELETE_2 ON TT1.F_INT1=T_DELETE_2.F_INT1;
DROP VIEW  TEST_V1;
DROP TABLE T_DELETE_1;
DROP TABLE T_DELETE_2;
DROP TABLE IF EXISTS TEMP_T1;
CREATE GLOBAL TEMPORARY TABLE TEMP_T1(A INT, B INT);
INSERT INTO TEMP_T1 VALUES(5,5);
INSERT INTO TEMP_T1 VALUES(4,4);
INSERT INTO TEMP_T1 VALUES(3,3);
INSERT INTO TEMP_T1 VALUES(2,2);
INSERT INTO TEMP_T1 VALUES(1,1);
DELETE FROM TEMP_T1 ORDER BY A LIMIT 3;
SELECT * FROM TEMP_T1 ORDER BY A;
DROP TABLE IF EXISTS TEMP_T1;

--DELETE ORDERBY
DROP TABLE IF EXISTS T1;
CREATE TABLE T1 (ID INTEGER, FIRST_NAME  VARCHAR(20) NOT NULL, LAST_NAME   VARCHAR(20) NOT NULL, CREDIT_LIMIT INTEGER);
INSERT INTO T1 VALUES (1, 'Li', 'Lei', 100);
INSERT INTO T1 VALUES (2, 'Han', 'Meimei', 2000);
DELETE FROM T1 ORDER BY 6;
DELETE FROM T1 ORDER BY abc;
DROP TABLE T1;

DROP TABLE IF EXISTS test_del_temp_1;
DROP TABLE IF EXISTS test_del_temp_2;
create table test_del_temp_1(a int);
create global temporary table test_del_temp_2(c int);
insert into test_del_temp_1 values(1);
insert into test_del_temp_1 values(2);
insert into test_del_temp_1 values(3);
commit;
insert into test_del_temp_2 values(2);
insert into test_del_temp_2 values(3);
delete test_del_temp_1 from test_del_temp_1 inner join test_del_temp_2 on test_del_temp_1.a=test_del_temp_2.c;
delete test_del_temp_2 from test_del_temp_1 inner join test_del_temp_2 on test_del_temp_1.a=test_del_temp_2.c;

drop table if exists delete_temptb_operation;
drop table if exists delete_temptb_policy;
drop table if exists delete_temptb_attribute;
create table delete_temptb_operation(id varchar(36) not null, apiid varchar(36)not null, res varchar(1024) not null, operation varchar(64) not null);
create table delete_temptb_policy (roid varchar(36) not null, name varchar(36) not null, value varchar(2048) not null);
create global temporary table delete_temptb_attribute(roid varchar(36) not null ,name varchar(36)not null, value varchar(2048));
insert into delete_temptb_operation(id,apiid,res,operation) values('d62e201c3e044764be51899366564b7a','2e4645926266ed4f9504196eda5a5944','/v1/openapi/instance','get');
insert into delete_temptb_policy(roid,name,value) values('d62e201c3e044764be51899366564b7a','plane','{"planes":["OM"]}');
insert into delete_temptb_policy(roid,name,value) values('d62e201c3e044764be51899366564b7a','route','{"service":"RCAccessConfigService_rest_ies_systemaccessservice"}');
insert into delete_temptb_policy(roid,name,value) values('d62e201c3e044764be51899366564b7a','auth','{"mode":"SSO"}');
delete p from delete_temptb_policy p left join delete_temptb_attribute a on p.roid = a.roid right join delete_temptb_operation o on o.id = p.roid 
where exists (select r.id from delete_temptb_operation r where r.apiid = '2e4645926266ed4f9504196eda5a5944' and p.roid = r.id);
drop table delete_temptb_operation;
drop table delete_temptb_policy;
drop table delete_temptb_attribute;

drop table if exists t_delete_limit;
create table t_delete_limit(a int,b char(2));
insert into t_delete_limit values(1,'xx');
delete from t_delete_limit limit (3-1);
drop table t_delete_limit;

--DTS2019072608546
drop table if exists  t_order_base_001;
create table t_order_base_001(id int,c_int int not null,c_vchar varchar(100),c_clob clob,c_blob blob,c_date date);  

create index idx_order_base_001_4 on t_order_base_001(to_char(c_int) asc,upper(c_vchar) desc);
insert into t_order_base_001 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
		sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_vchar||'||i||',c_clob||'||i||',c_blob'||',c_date from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/

exec proc_insert('t_order_base_001',1,20);
select id, c_vchar from t_order_base_001 order by c_vchar;
delete from t_order_base_001 order by c_vchar asc limit 3,5;
select id, c_vchar from t_order_base_001 order by c_vchar;
drop procedure proc_insert;
drop table t_order_base_001;

--DTSDTS2020050904826
DROP TABLE IF EXISTS SECEYE_VERTICAL_EVENT;
DROP TABLE IF EXISTS SECEYE_TRAN_EVENT;

CREATE TABLE "SECEYE_VERTICAL_EVENT"
(
   "EVENT_ID"           VARCHAR2(64)         NOT NULL,
   "DETECT_ID"          VARCHAR2(32),
   "DETECT_SOURCE"      INT,
   "SOURCE"             VARCHAR2(128),
   "SOURCE_CATEGORY"    INT,
   "SOURCE_TYPE"        VARCHAR2(64),
   "SOURCE_IP"          VARCHAR2(128),
   "DOMAIN"             INT,
   "EVENT_CATEGORY"     INT,
   "EVENT_TYPE"         INT,
   "EVENT_SUB_TYPE"     INT,
   "EVENT_NAME"         VARCHAR2(64),
   "EVENT_CLASS"        INT,
   "EVENT_LEVEL"        INT,
   "CONFIDENCE"         INT,
   "EVIDENCE"           VARCHAR2(2048),
   "ATTACK_STATUS"      INT,
   "ATTACK_PHASE"       INT,
   "CREATE_TIME"        bigint,
   "OCCUR_TIME"         bigint,
   "BEGIN_TIME"         bigint,
   "RECENT_TIME"        bigint,
   "DURATION"           INT,
   "TIMES"              INT,
   "OCCUR_DATE"         bigint,
   "HANDLE_RESULT"      INT,
   "EVENT_STATE"        INT,
   "HANDLE_TIME"        bigint,
   CONSTRAINT PK_SECEYE_VERTICAL_EVENT PRIMARY KEY ("EVENT_ID")
);

CREATE TABLE "SECEYE_TRAN_EVENT"
(
   "EVENT_ID"           VARCHAR2(64)         NOT NULL,
   "SRC_PORT"           INTEGER,
   "DEST_PORT"          INTEGER,
   "ATTACK_SPEED"       INTEGER,
   "SRC_MAC"            VARCHAR2(128),
   "DEST_MAC"           VARCHAR2(128),
   "PROTOCOL"           VARCHAR2(128),
   CONSTRAINT PK_SECEYE_TRAN_EVENT PRIMARY KEY ("EVENT_ID")
);

declare random number;
id number;
BEGIN FOR i IN 1 .. 10 loop
    random :=  trunc(DBE_RANDOM.GET_VALUE(400,403));
    id := 20;
   INSERT INTO SECEYE_VERTICAL_EVENT
   (EVENT_ID, DETECT_ID, DETECT_SOURCE, SOURCE, SOURCE_CATEGORY, SOURCE_TYPE, SOURCE_IP, DOMAIN, EVENT_CATEGORY, EVENT_TYPE, EVENT_SUB_TYPE, EVENT_NAME, EVENT_CLASS,
    EVENT_LEVEL,CONFIDENCE, EVIDENCE, ATTACK_STATUS, ATTACK_PHASE, CREATE_TIME, OCCUR_TIME, BEGIN_TIME, RECENT_TIME, DURATION, TIMES, OCCUR_DATE, HANDLE_RESULT, EVENT_STATE, HANDLE_TIME)
   VALUES ( 'verticalb5577f16-025f-'|| id || i, 23, 2, id || i, trunc(DBE_RANDOM.GET_VALUE(1,3)), 'NE_NAME' || i, '9.35.23.' || i ,
   trunc(DBE_RANDOM.GET_VALUE(3,5)),trunc(DBE_RANDOM.GET_VALUE(1,3)), trunc(DBE_RANDOM.GET_VALUE(1,5))||trunc(DBE_RANDOM.GET_VALUE(0,2)),
   trunc(DBE_RANDOM.GET_VALUE(1,5))||trunc(DBE_RANDOM.GET_VALUE(0,2)) || 0, trunc(DBE_RANDOM.GET_VALUE(1,5))||trunc(DBE_RANDOM.GET_VALUE(0,2))||0||0,
   trunc(DBE_RANDOM.GET_VALUE(1,5))||trunc(DBE_RANDOM.GET_VALUE(0,2)) ||0||0, trunc(DBE_RANDOM.GET_VALUE(1,6)), 999999, '{usualIp=1.1.1.2, failures=2, destUser=test1}', trunc(DBE_RANDOM.GET_VALUE(0,3)),trunc(DBE_RANDOM.GET_VALUE(0,3)),
   unix_TIMESTAMP(SYSDATE-random)*1000, unix_TIMESTAMP(SYSDATE-random)*1000, unix_TIMESTAMP(SYSDATE-random)*1000, unix_TIMESTAMP(SYSDATE-random)*1000, 109, 209, unix_TIMESTAMP(trunc(sysdate-random))*1000, trunc(DBE_RANDOM.GET_VALUE(0,4)), 0,
   unix_TIMESTAMP(SYSDATE-trunc(DBE_RANDOM.GET_VALUE(1,30)))*1000);
   INSERT INTO SECEYE_TRAN_EVENT (EVENT_ID, SRC_PORT, DEST_PORT, ATTACK_SPEED, SRC_MAC, DEST_MAC, PROTOCOL) VALUES ('verticalb5577f16-025f-'|| id || i, 80||i, 80||i, 80||i, '00-FF-16-C7-61-B'||i, '00-FF-06-F1-0C-55'||i, 'udp');
END loop;
COMMIT;
END;
/

call dbe_stats.collect_table_stats( schema=>'SYS', name=>'SECEYE_VERTICAL_EVENT', sample_ratio => 100, method_opt=>'for all columns' );
call dbe_stats.collect_table_stats( schema=>'SYS', name=>'SECEYE_TRAN_EVENT', sample_ratio => 100,method_opt=>'for all columns' );
ALTER SYSTEM SET CBO=ON;

select event_id from SECEYE_TRAN_EVENT order by event_id;
delete from SECEYE_TRAN_EVENT WHERE EXISTS
            (select event_id from SECEYE_VERTICAL_EVENT where event_id=SECEYE_TRAN_EVENT.EVENT_ID and occur_time <= unix_TIMESTAMP(TIMESTAMPADD(YEAR,-1, FROM_UNIXTIME(unix_TIMESTAMP)))*1000)
            order by event_id limit 0,1;
select event_id from SECEYE_TRAN_EVENT order by event_id;
delete from SECEYE_TRAN_EVENT WHERE EXISTS
            (select event_id from SECEYE_VERTICAL_EVENT where event_id=SECEYE_TRAN_EVENT.EVENT_ID and occur_time <= unix_TIMESTAMP(TIMESTAMPADD(YEAR,-1, FROM_UNIXTIME(unix_TIMESTAMP)))*1000)
            order by event_id limit 0,1;
select event_id from SECEYE_TRAN_EVENT order by event_id;

DROP TABLE IF EXISTS SECEYE_VERTICAL_EVENT;
DROP TABLE IF EXISTS SECEYE_TRAN_EVENT;
ALTER SYSTEM SET CBO=OFF;