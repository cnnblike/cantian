DROP TABLE IF EXISTS T_RBO_1;
CREATE TABLE T_RBO_1(F_INT INT, F_CHAR VARCHAR(20), F_REAL REAL, F_DOUBLE DOUBLE);
CREATE INDEX IDX_1_1 ON T_RBO_1(F_REAL);
CREATE UNIQUE INDEX IDX_1_2 ON T_RBO_1(F_INT, F_CHAR);
EXPLAIN PLAN FOR SELECT * FROM T_RBO_1 WHERE F_INT=1 AND F_CHAR='1' AND F_REAL=1.0;
EXPLAIN PLAN FOR SELECT * FROM T_RBO_1 WHERE F_INT=1 AND F_CHAR>='1' AND F_REAL=1.0;
EXPLAIN PLAN FOR SELECT * FROM T_RBO_1 WHERE F_INT=1 AND F_REAL=1.0;
EXPLAIN PLAN FOR SELECT * FROM T_RBO_1 WHERE (F_INT=1 OR F_INT=2) AND F_CHAR='1' AND F_REAL=1.0;
EXPLAIN PLAN FOR SELECT * FROM T_RBO_1 WHERE (F_INT=1 OR F_INT IS NULL) AND F_CHAR='1' AND F_REAL=1.0;
EXPLAIN PLAN FOR SELECT * FROM T_RBO_1 WHERE (F_INT=NULL OR F_INT IS NULL) AND F_CHAR='1' AND F_REAL=1.0;
DROP TABLE IF EXISTS T_RBO_2;
CREATE TABLE T_RBO_2(F_INT INT, F_CHAR VARCHAR(20), F_REAL REAL, F_DOUBLE DOUBLE);
CREATE INDEX IDX_2_1 ON T_RBO_2(F_CHAR);
CREATE INDEX IDX_2_2 ON T_RBO_2(F_REAL);
CREATE UNIQUE INDEX IDX_2_3 ON T_RBO_2(F_INT, F_CHAR);
EXPLAIN PLAN FOR SELECT * FROM T_RBO_2 WHERE F_INT=1 AND F_CHAR='1';
EXPLAIN PLAN FOR SELECT * FROM T_RBO_2 WHERE F_INT=1 AND F_CHAR>='1';
EXPLAIN PLAN FOR SELECT * FROM T_RBO_2 WHERE F_INT=1 AND F_CHAR='1' AND F_REAL=8.0 ORDER BY F_REAL;
EXPLAIN PLAN FOR SELECT F_INT, F_CHAR FROM T_RBO_2 WHERE F_INT=1 AND F_CHAR>='1' ORDER BY F_CHAR;
DROP TABLE IF EXISTS T_RBO_3;
CREATE TABLE T_RBO_3(F_INT INT, F_CHAR VARCHAR(20), F_REAL REAL)
PARTITION BY RANGE(F_REAL)
(
 PARTITION P1 VALUES LESS THAN(10),
 PARTITION P2 VALUES LESS THAN(20),
 PARTITION P3 VALUES LESS THAN(30),
 PARTITION P4 VALUES LESS THAN(MAXVALUE)
);
CREATE INDEX IDX_3_1 ON T_RBO_3(F_CHAR) LOCAL;
CREATE UNIQUE INDEX  IDX_3_2 ON T_RBO_3(F_INT, F_CHAR);
EXPLAIN PLAN FOR SELECT * FROM T_RBO_3 WHERE F_INT=1 AND F_CHAR='1' AND F_REAL=8.0;
EXPLAIN PLAN FOR SELECT * FROM T_RBO_3 WHERE F_INT>1 AND F_CHAR>'1' AND F_REAL=8.0;
DROP TABLE IF EXISTS T_RBO_4;
CREATE TABLE T_RBO_4(F_INT INT, F_CHAR VARCHAR(20), F_REAL REAL, F_DOUBLE DOUBLE);
CREATE INDEX IDX_4_1 ON T_RBO_4(F_INT,F_CHAR);
CREATE INDEX IDX_4_2 ON T_RBO_4(F_CHAR,F_REAL);
EXPLAIN PLAN FOR SELECT * FROM T_RBO_4 WHERE F_INT=1 AND F_CHAR ='1' AND F_REAL=8.0 ORDER BY F_DOUBLE;
EXPLAIN PLAN FOR SELECT * FROM T_RBO_4 WHERE F_INT=1 AND F_CHAR ='1' AND F_REAL=8.0 ORDER BY F_INT;
EXPLAIN PLAN FOR SELECT * FROM T_RBO_4 WHERE F_INT=1 AND F_CHAR ='1' AND F_REAL=8.0 ORDER BY F_REAL;
EXPLAIN PLAN FOR SELECT * FROM T_RBO_4 WHERE F_INT=1 AND F_CHAR >='1' ORDER BY F_CHAR;
EXPLAIN PLAN FOR SELECT * FROM T_RBO_4 WHERE F_INT>1 AND F_CHAR >='1' ORDER BY F_CHAR;
EXPLAIN PLAN FOR SELECT F_INT,F_CHAR FROM T_RBO_4 WHERE F_INT=1 AND F_CHAR ='1';
DROP TABLE IF EXISTS T_RBO_5;
CREATE TABLE T_RBO_5(F_INT INT, F_CHAR VARCHAR(20), F_REAL REAL, F_DOUBLE DOUBLE, F_DATE DATE);
CREATE INDEX IDX_5_1 ON T_RBO_5(F_INT,F_CHAR,F_REAL);
CREATE INDEX IDX_5_2 ON T_RBO_5(F_CHAR,F_REAL);
CREATE INDEX IDX_5_3 ON T_RBO_5(F_INT,F_CHAR,F_DOUBLE,F_DATE);
EXPLAIN PLAN FOR SELECT * FROM T_RBO_5 WHERE F_INT=1 AND F_CHAR >'1' AND F_REAL>8.0;
EXPLAIN PLAN FOR SELECT * FROM T_RBO_5 WHERE F_INT=1 AND F_CHAR ='1' AND F_DOUBLE=8.0;
EXPLAIN PLAN FOR SELECT MAX(F_INT) FROM T_RBO_5 WHERE F_INT > 10;
EXPLAIN PLAN FOR SELECT * FROM T_RBO_5 WHERE F_CHAR IN ('aa','bb','cc');
EXPLAIN PLAN FOR SELECT * FROM T_RBO_5 WHERE F_CHAR = 'aa' AND F_REAL IN (123,456);

EXPLAIN SELECT * FROM T_RBO_1 T1 JOIN T_RBO_2 T2 ON T1.F_DOUBLE = T2.F_DOUBLE WHERE T1.F_REAL=10;
EXPLAIN SELECT * FROM T_RBO_1 T1 JOIN T_RBO_2 T2 ON T1.F_DOUBLE = T2.F_DOUBLE WHERE T2.F_REAL=10;
EXPLAIN SELECT * FROM T_RBO_1 T1 JOIN T_RBO_2 T2 ON T1.F_REAL = T2.F_REAL;
EXPLAIN SELECT * FROM T_RBO_1 T1 LEFT JOIN T_RBO_2 T2 ON T1.F_DOUBLE = T2.F_DOUBLE WHERE T1.F_REAL=10;
EXPLAIN SELECT * FROM T_RBO_1 T1 LEFT JOIN T_RBO_2 T2 ON T1.F_DOUBLE = T2.F_DOUBLE WHERE T2.F_REAL=10;
EXPLAIN SELECT * FROM T_RBO_1 T1 LEFT JOIN T_RBO_2 T2 ON T1.F_REAL = T2.F_REAL;
EXPLAIN SELECT * FROM T_RBO_1 T1 RIGHT JOIN T_RBO_2 T2 ON T1.F_DOUBLE = T2.F_DOUBLE WHERE T1.F_REAL=10;
EXPLAIN SELECT * FROM T_RBO_1 T1 RIGHT JOIN T_RBO_2 T2 ON T1.F_DOUBLE = T2.F_DOUBLE WHERE T2.F_REAL=10;
EXPLAIN SELECT * FROM T_RBO_1 T1 RIGHT JOIN T_RBO_2 T2 ON T1.F_REAL = T2.F_REAL;
EXPLAIN SELECT * FROM T_RBO_1 T1 JOIN T_RBO_2 T2 ON T1.F_INT=T2.F_INT LEFT JOIN T_RBO_4 T4 ON T1.F_INT=T4.F_INT;
EXPLAIN SELECT * FROM T_RBO_1 T1 JOIN T_RBO_2 T2 ON T1.F_INT=T2.F_INT RIGHT JOIN T_RBO_4 T4 ON T1.F_INT=T4.F_INT;
EXPLAIN SELECT * FROM T_RBO_1 T1 LEFT JOIN T_RBO_2 T2 ON T1.F_INT=T2.F_INT JOIN T_RBO_4 T4 ON T1.F_INT=T4.F_INT;
EXPLAIN SELECT * FROM T_RBO_1 T1 RIGHT JOIN T_RBO_2 T2 ON T1.F_INT=T2.F_INT JOIN T_RBO_4 T4 ON T1.F_INT=T4.F_INT;
EXPLAIN SELECT * FROM T_RBO_1 T1 JOIN T_RBO_2 T2 ON T1.F_INT=T2.F_INT LEFT JOIN T_RBO_4 T4 ON T1.F_INT=T4.F_INT RIGHT JOIN T_RBO_5 T5 ON T4.F_INT=T5.F_INT;
EXPLAIN SELECT * FROM T_RBO_1 T1 JOIN T_RBO_2 T2 ON T1.F_INT=T2.F_INT RIGHT JOIN T_RBO_4 T4 ON T1.F_INT=T4.F_INT LEFT JOIN T_RBO_5 T5 ON T4.F_INT=T5.F_INT;

DROP TABLE IF EXISTS T_RBO_1;
DROP TABLE IF EXISTS T_RBO_2;
DROP TABLE IF EXISTS T_RBO_3;
DROP TABLE IF EXISTS T_RBO_4;
DROP TABLE IF EXISTS T_RBO_5;

select * from dual where rowid = to_char('00086364160');
select * from dual where rowid = to_char('A00863641600000');
select * from dual where rowid = to_char('000863641600002');
select * from dual where rowid = to_char('000863846400000') or rowid = to_char('000863641600001');
select * from dual where rowid = to_char('000863846400000') or rowid = to_char('000863641700000');
select * from dual where rowid = to_char('000863846400000') and rowid = to_char('000863641700000');
select * from dual where rowid = to_char('000863846400000') and rowid = to_char('000863846400000');
select * from dual where rowid = to_char('000863846400000') and rowid = to_char('000863846400000') and rowid = to_char('000863641700000');
select * from dual where rowid in (to_char('000863846400000'), to_char('000863641700000'), to_char('000863641700000'), to_char('000863641700000'), to_char('000863846400000'));
select * from dual where rowid = '000863846400000' or rowid = '000863641600001';

DROP TABLE IF EXISTS T1;
DROP TABLE IF EXISTS T2;
DROP TABLE IF EXISTS T3;
DROP TABLE IF EXISTS T4;

create table t1(f_int1 int, f_int2 int, f_varchar1 varchar(32));
create index idx_t1 on t1(f_int1);
create table t2(f_int1 int, f_int2 int, f_varchar1 varchar(32));
create index idx_t2 on t2(f_int1);
create table t3(f_int1 int, f_int2 int, f_varchar1 varchar(32));
create index idx_t3 on t3(f_int1);
create table t4(f_int1 int, f_int2 int, f_varchar1 varchar(32));
create index idx_t4 on t4(f_int1);

explain select t1.f_varchar1, t2.f_varchar1 from t1 join t2 on t1.f_int2=t2.f_int2;
explain select t1.f_varchar1, tt2.f_varchar1 from t1 join (select f_int1, f_varchar1, count(*) from t2 group by f_int1, f_varchar1) tt2 on t1.f_int2 = tt2.f_int1 where t1.f_int1 > 0;
explain select t1.f_varchar1, tt2.f_varchar1 from t1 join (select f_int1, f_varchar1, count(*) from t2 group by f_int1, f_varchar1) tt2 on t1.f_int2 = tt2.f_int1;
explain select tt1.f_varchar1, tt2.f_varchar1 from (select f_int1, f_varchar1, count(*) from t1 group by f_int1, f_varchar1) tt1 join (select f_int1, f_varchar1, count(*) from t2 group by f_int1, f_varchar1) tt2 on tt1.f_int1 = tt2.f_int1;
explain select t1.f_varchar1, t2.f_varchar1, t3.f_varchar1 from t1 join t2 on t1.f_int2=t2.f_int2 join t3 on t2.f_int2= t3.f_int2;
explain select t1.f_varchar1, t2.f_varchar1, t3.f_varchar1 from t1 join t2 on t1.f_int1=t2.f_int1 join t3 on t2.f_int2= t3.f_int2;
explain select t1.f_varchar1, t2.f_varchar1, t3.f_varchar1 from t1 join t2 on t1.f_int2=t2.f_int2 join t3 on t2.f_int1= t3.f_int1;
explain select t1.f_varchar1, t2.f_varchar1, t3.f_varchar1 from t1, t2 join t3 on t2.f_int2= t3.f_int2;
explain select t1.f_varchar1, t2.f_varchar1, t3.f_varchar1, t4.f_varchar1 from t1 join t2 on t1.f_int2=t2.f_int2, t3 join t4 on t3.f_int2=t4.f_int2;
explain select t1.f_varchar1, t2.f_varchar1, t3.f_varchar1, t4.f_varchar1 from t1 join t2 on t1.f_int2=t2.f_int2, t3 join t4 on t3.f_int1=t4.f_int1;
explain select t1.f_varchar1, t2.f_varchar1, t3.f_varchar1, t4.f_varchar1 from t1 join t2 on t1.f_int1=t2.f_int1, t3 join t4 on t3.f_int2=t4.f_int2;

DROP TABLE IF EXISTS T1;
DROP TABLE IF EXISTS T2;
DROP TABLE IF EXISTS T3;
DROP TABLE IF EXISTS T4;

DROP TABLE IF EXISTS T_RBO_6;
CREATE TABLE T_RBO_6(F_INT INT, F_DATE DATE, F_VARCHAR VARCHAR(128));
CREATE INDEX IDX_6_1 ON T_RBO_6(F_INT);
CREATE INDEX IDX_6_2 ON T_RBO_6(F_DATE);
EXPLAIN SELECT * FROM T_RBO_6 WHERE F_INT = COS(0);
EXPLAIN SELECT * FROM T_RBO_6 WHERE F_INT = COS(0)+1;
EXPLAIN SELECT * FROM T_RBO_6 WHERE F_DATE = SYSDATE;
EXPLAIN SELECT * FROM T_RBO_6 WHERE F_DATE = SYSDATE+10;
EXPLAIN SELECT F_INT, COUNT(*) FROM T_RBO_6 WHERE F_INT >10 GROUP BY F_INT;
EXPLAIN SELECT F_INT, COUNT(*) FROM T_RBO_6 GROUP BY F_INT;
EXPLAIN SELECT * FROM T_RBO_6 ORDER BY F_INT;
EXPLAIN SELECT * FROM T_RBO_6 ORDER BY F_INT DESC;
EXPLAIN SELECT MIN(F_INT) FROM T_RBO_6;
EXPLAIN SELECT MAX(F_INT) FROM T_RBO_6;
DROP VIEW IF EXISTS V_RBO_1;
DROP VIEW IF EXISTS V_RBO_2;
CREATE VIEW V_RBO_1 AS SELECT * FROM T_RBO_6;
CREATE VIEW V_RBO_2 AS SELECT * FROM V_RBO_1;
EXPLAIN SELECT * FROM (SELECT * FROM V_RBO_1) WHERE F_INT = 10;
EXPLAIN SELECT * FROM V_RBO_2 WHERE F_INT = 10;
DROP TABLE IF EXISTS t_dlvr_1;
DROP TABLE IF EXISTS t_dlvr_2;
DROP TABLE IF EXISTS t_dlvr_3;
DROP TABLE IF EXISTS t_dlvr_4;
create table t_dlvr_1(a int, b int, c int);
create table t_dlvr_2(a int, b int, c int);
create table t_dlvr_3(a int, b int, c int);
create table t_dlvr_4(a int, b int, c int);
create index idx_t_dlvr_1_1 on t_dlvr_1(a);
explain select t1.* from t_dlvr_1 t1 join t_dlvr_2 t2 on t1.a=t2.a where t2.a=1;

create index idx_t_dlvr_2_1 on t_dlvr_2(a,b);
create index idx_t_dlvr_3_1 on t_dlvr_3(a,b);
explain select t4.* from t_dlvr_4 t4 join t_dlvr_2 t2 on t4.a=t2.a join t_dlvr_3 t3 on t3.a=t2.a where t3.b=2;
DROP TABLE IF EXISTS T_TEST_ZENITH_T1;
DROP TABLE IF EXISTS T_TEST_ZENITH_T2;
CREATE TABLE T_TEST_ZENITH_T1(ID INT, NAME VARCHAR2(100), SQLTEXT VARCHAR2(1000));
CREATE UNIQUE INDEX UNIQ_IDX_T1 ON T_TEST_ZENITH_T1(ID);
CREATE TABLE T_TEST_ZENITH_T2(ID INT, NAME VARCHAR2(100), SQLTEXT VARCHAR2(1000));
CREATE UNIQUE INDEX UNIQ_IDX_T2 ON T_TEST_ZENITH_T2(ID);
CREATE OR REPLACE VIEW V_TEST_ZENITH_T1 AS SELECT * FROM T_TEST_ZENITH_T1;
CREATE OR REPLACE VIEW V_TEST_ZENITH_T2 AS SELECT * FROM T_TEST_ZENITH_T2;
EXPLAIN SELECT * FROM V_TEST_ZENITH_T1 A LEFT JOIN V_TEST_ZENITH_T2 B ON A.ID = B.ID WHERE A.ID = 1;
EXPLAIN SELECT * FROM V_TEST_ZENITH_T1 A LEFT JOIN V_TEST_ZENITH_T2 B ON A.ID = B.ID WHERE B.ID = 1;
EXPLAIN SELECT * FROM V_TEST_ZENITH_T1 A JOIN V_TEST_ZENITH_T2 B ON A.ID = B.ID WHERE A.ID = 1;
EXPLAIN SELECT * FROM T_TEST_ZENITH_T1 T1 JOIN T_TEST_ZENITH_T2 T2 ON T1.ID=T2.ID WHERE T2.ID = 1;
EXPLAIN SELECT * FROM V_TEST_ZENITH_T1 A FULL JOIN V_TEST_ZENITH_T2 B ON A.ID = B.ID WHERE A.ID = 1;
EXPLAIN SELECT * FROM V_TEST_ZENITH_T1 A FULL JOIN V_TEST_ZENITH_T2 B ON A.ID = B.ID WHERE B.ID = 1;
EXPLAIN SELECT * FROM V_TEST_ZENITH_T1 A FULL JOIN V_TEST_ZENITH_T2 B ON A.ID = B.ID WHERE A.ID =1 AND B.ID = 1;

DROP TABLE IF EXISTS T_TEST_ZENITH_T1;
CREATE TABLE T_TEST_ZENITH_T1(ID INT, NAME VARCHAR2(100), SQLTEXT VARCHAR2(1000));
CREATE UNIQUE INDEX UNIQ_IDX_T1 ON T_TEST_ZENITH_T1(ID);
CREATE OR REPLACE VIEW V_TEST_ZENITH_T1 AS SELECT * FROM T_TEST_ZENITH_T1;
EXPLAIN SELECT (SELECT COUNT(*) FROM V_TEST_ZENITH_T1 B WHERE B.ID = A.ID AND ROWNUM > 0) FROM V_TEST_ZENITH_T1 A WHERE ID >= 1 AND ID <= 100;
EXPLAIN SELECT (SELECT (SELECT COUNT(*) FROM V_TEST_ZENITH_T1 B WHERE B.ID = A.ID) FROM V_TEST_ZENITH_T1) FROM V_TEST_ZENITH_T1 A WHERE ID >= 1 AND ID <= 100;

DROP TABLE IF EXISTS RBO_T1;
DROP TABLE IF EXISTS RBO_T2;
DROP TABLE IF EXISTS RBO_T3;
DROP TABLE IF EXISTS RBO_T4;
DROP TABLE IF EXISTS RBO_T5;
CREATE TABLE RBO_T1(C1 INT, C2 INT, C3 INT, C4 INT);
CREATE TABLE RBO_T2(C1 INT, C2 INT, C3 INT, C4 INT);
CREATE TABLE RBO_T3(C1 INT, C2 INT, C3 INT, C4 INT);
CREATE TABLE RBO_T4(C1 INT, C2 INT, C3 INT, C4 INT);
CREATE TABLE RBO_T5(C1 INT, C2 INT, C3 INT, C4 INT);
EXPLAIN SELECT * FROM RBO_T1 T1, RBO_T2 T2, RBO_T3 T3 LEFT JOIN RBO_T4 T4 ON (T3.C1 = T4.C1), RBO_T5 T5 WHERE T1.C1 = T5.C1 AND T2.C2 = T5.C2 AND T3.C1 = T5.C1;
CREATE INDEX IDX_RBO_T1_1 ON RBO_T1(C1,C2);
CREATE INDEX IDX_RBO_T2_1 ON RBO_T2(C1,C2);
CREATE INDEX IDX_RBO_T3_1 ON RBO_T3(C1,C2);
CREATE INDEX IDX_RBO_T4_1 ON RBO_T4(C1,C2);
CREATE INDEX IDX_RBO_T5_1 ON RBO_T5(C1,C2);
EXPLAIN SELECT * FROM RBO_T1 T1, RBO_T2 T2, RBO_T3 T3 LEFT JOIN RBO_T4 T4 ON (T3.C2 = T4.C2) WHERE T1.C1 = T2.C1 AND T2.C1 = T3.C1;

DROP TABLE IF EXISTS T_EDGE;
CREATE TABLE T_EDGE
(
IGS_EDGEID       VARBINARY(16),
IGS_RELCATEGORY  VARCHAR(128 BYTE),
IGS_STARTID      VARBINARY(16),
IGS_STARTTYPE    VARCHAR(128 BYTE),
IGS_TYPE         NUMBER(11),
IGS_ENDID        VARBINARY(16),
IGS_ENDTYPE      VARCHAR(128 BYTE),
IGS_NAME         VARCHAR(256 BYTE),
IGS_COLLECTORID  VARCHAR(128 BYTE),
IGS_UNIQUEKEY    VARCHAR(255 BYTE),
IGS_REPORTSN     NUMBER(20),
IGS_PROPERTY     CLOB
);
CREATE INDEX IDX_TYPE_EDGEID ON T_EDGE ( IGS_TYPE, IGS_EDGEID );
CREATE INDEX IDX_EDGE_IDTYPE ON T_EDGE ( IGS_STARTID, IGS_TYPE, IGS_ENDID );
EXPLAIN SELECT * FROM T_EDGE WHERE (IGS_TYPE = 106 AND IGS_STARTID = UNHEX(REPLACE('4520F1B6-6F90-642C-9416-27464745653F', '-', ''))) ORDER BY T_EDGE.IGS_EDGEID ASC LIMIT 201;
DROP TABLE IF EXISTS T_EDGE;

DROP TABLE IF EXISTS T_P_GTRXCHAN_A4;
DROP TABLE IF EXISTS T_P_GTRXIUO_A4;
DROP TABLE IF EXISTS T_RL_GTRX_A4;
DROP TABLE IF EXISTS T_CELLSP_UPTGCELL_EXTTP_A41;

CREATE TABLE T_P_GTRXCHAN_A4
(
  PLANID NUMBER(10) NOT NULL,
  CMENEID NUMBER(10) NOT NULL,
  TRXID NUMBER(10) NOT NULL,
  CHNO NUMBER(3) NOT NULL,
  CHTYPE NUMBER(3),
  CELLID NUMBER(10) NOT NULL,
  BTSID NUMBER(10),
  UCMAPPINGCHANTYPE NUMBER(3),
  RESERVEDPARA1 NUMBER(3),
  RESERVEDPARA2 NUMBER(3),
  TSPRIORITY NUMBER(3),
  UPBTSPORTNO NUMBER(3),
  UPBTSTSNO NUMBER(3),
  REVBTSUPPORTNO NUMBER(3),
  REVUPBTSTSNO NUMBER(3),
  TRANSTYPE NUMBER(3),
  ADMSTAT NUMBER(3),
  FLEXABISMODE NUMBER(3),
  ABISMODE NUMBER(3),
  UPOUTBSCSUBRACKNO NUMBER(3),
  UPOUTBSCSLOTNO NUMBER(3),
  UPOUTBSCE1PORTNO NUMBER(10),
  UPOUTBSCTSNO NUMBER(3),
  REVUPOUTBSCSUBRACKNO NUMBER(3),
  REVUPOUTBSCSLOTNO NUMBER(3),
  REVUPOUTBSCE1PORTNO NUMBER(10),
  REVUPOUTBSCTSNO NUMBER(3),
  GPRSCHPRI NUMBER(3),
  ACTSTATUS NUMBER(17),
  TSPROPFLAG NUMBER(3),
  TSASSIGNFLAG NUMBER(10),
  CHANRSV NUMBER(3)
);
CREATE UNIQUE INDEX IDX_T_P_GTRXCHAN_A4 ON T_P_GTRXCHAN_A4(PLANID, CMENEID, TRXID, CHNO, CELLID);

CREATE TABLE T_P_GTRXIUO_A4
(
  PLANID NUMBER(10) NOT NULL,
  CMENEID NUMBER(10) NOT NULL,
  TRXID NUMBER(10) NOT NULL,
  IUO NUMBER(3),
  CELLID NUMBER(10) NOT NULL
);
CREATE UNIQUE INDEX IDX_T_P_GTRXIUO_A4 ON T_P_GTRXIUO_A4(PLANID, CMENEID, TRXID, CELLID);

CREATE TABLE T_RL_GTRX_A4
(
  PLANID NUMBER(10) NOT NULL,
  CMENEID NUMBER(10) NOT NULL,
  TRXID NUMBER(10) NOT NULL,
  ACTSTATUS NUMBER(3),
  TRXNAME VARCHAR(102 BYTE),
  FREQ NUMBER(10),
  TRXNO NUMBER(3),
  QTRUPRIARITY NUMBER(3),
  ABISMODE NUMBER(3),
  SPUSUBRACKNO NUMBER(3),
  SPUSLOTNO NUMBER(3),
  SPUCPUNO NUMBER(3),
  UPRSLPORTNO NUMBER(3),
  UPRSLTSNO NUMBER(3),
  UPRSLLOGICNO NUMBER(10),
  RESERVEDPARA VARCHAR(63 BYTE),
  RACKGRPNO NUMBER(3),
  REVUPRSLPORTNO NUMBER(3),
  REVUPRSLTSNO NUMBER(3),
  TRANSTYPE NUMBER(3),
  COTRXNOFORDYNPBT NUMBER(3),
  INHDLCINDEX NUMBER(10),
  HUBHDLCINDEX NUMBER(10),
  REVINHDLCINDEX NUMBER(10),
  TRXNOINHUB NUMBER(3),
  TRXABILITY NUMBER(3),
  CABINETNO NUMBER(3),
  ISTOWEREQUIPPED NUMBER(3),
  UCPRIORITY NUMBER(3),
  DIVERSITYMODE NUMBER(3),
  BTSID NUMBER(10),
  CELLID NUMBER(10) NOT NULL,
  ADMSTAT NUMBER(3),
  BOARDTYPE NUMBER(3),
  TEI NUMBER(3),
  FREQOPA VARCHAR(387 BYTE),
  SRN NUMBER(3),
  SN NUMBER(3),
  TRXPN NUMBER(3),
  ISMAINBCCH NUMBER(3),
  UPOUTBSCSUBRACKNO NUMBER(3),
  UPOUTBSCSLOTNO NUMBER(3),
  UPOUTBSCE1PORTNO NUMBER(10),
  UPOUTBSCTSNO NUMBER(3),
  REVUPOUTBSCSUBRACKNO NUMBER(3),
  REVUPOUTBSCSLOTNO NUMBER(3),
  REVUPOUTBSCE1PORTNO NUMBER(10),
  REVUPOUTBSCTSNO NUMBER(3),
  TSPROPFLAG NUMBER(3),
  TRXPN1 NUMBER(3),
  ANTPASSNO NUMBER(3),
  TSASSIGNFLAG NUMBER(10),
  MRRUSPTSHARING NUMBER(3),
  ACTSTATUSFORUPGRADE NUMBER(3),
  TRXNOMANUL NUMBER(3),
  CPUID NUMBER(17),
  NEWTRXNAME VARCHAR(102 BYTE),
  ISTMPTRX NUMBER(3),
  GTRXGROUPID NUMBER(17),
  DISPERFDATADEATRX NUMBER(3),
  TRXSHAREFLAG NUMBER(17),
  ANT1CN NUMBER(3),
  ANT1SRN NUMBER(3),
  ANT1SN NUMBER(3),
  ANT1N NUMBER(3),
  ANTTYPE1 NUMBER(3),
  ANT2CN NUMBER(3),
  ANT2SRN NUMBER(3),
  ANT2SN NUMBER(3),
  ANT2N NUMBER(3),
  ANTTYPE2 NUMBER(3),
  ANT3CN NUMBER(3),
  ANT3SRN NUMBER(3),
  ANT3SN NUMBER(3),
  ANT3N NUMBER(3),
  ANTTYPE3 NUMBER(3),
  ANT4CN NUMBER(3),
  ANT4SRN NUMBER(3),
  ANT4SN NUMBER(3),
  ANT4N NUMBER(3),
  ANTTYPE4 NUMBER(3),
  ANT5CN NUMBER(3),
  ANT5SRN NUMBER(3),
  ANT5SN NUMBER(3),
  ANT5N NUMBER(3),
  ANTTYPE5 NUMBER(3),
  ANT6CN NUMBER(3),
  ANT6SRN NUMBER(3),
  ANT6SN NUMBER(3),
  ANT6N NUMBER(3),
  ANTTYPE6 NUMBER(3),
  ANT7CN NUMBER(3),
  ANT7SRN NUMBER(3),
  ANT7SN NUMBER(3),
  ANT7N NUMBER(3),
  ANTTYPE7 NUMBER(3),
  ANT8CN NUMBER(3),
  ANT8SRN NUMBER(3),
  ANT8SN NUMBER(3),
  ANT8N NUMBER(3),
  ANTTYPE8 NUMBER(3),
  BUFZONETRXSHAREFLAG NUMBER(17)
);
CREATE UNIQUE INDEX IDX_T_RL_GTRX_A4 ON T_RL_GTRX_A4(PLANID, CMENEID, TRXID, CELLID);

CREATE GLOBAL TEMPORARY TABLE T_CELLSP_UPTGCELL_EXTTP_A41
(
  PLANID NUMBER(10),
  CMENEID NUMBER(10),
  BTSID NUMBER(10),
  CELLID NUMBER(10),
  RECID NUMBER(10)
)ON COMMIT DELETE ROWS;

explain delete from t_P_GTRXCHAN_A4
 where rowid in (select a.rowid
                   from t_P_GTRXCHAN_A4 a
                   join t_P_GTRXIUO_A4 b
                     on a.PlanID = b.PlanID
                    and a.CMENEID = b.CMENEID
                    and a.TRXID = b.TRXID
                   join t_RL_GTRX_A4 c
                     on a.PlanID = c.PlanID
                    and a.CMENEID = c.CMENEID
                    and a.TRXID = c.TRXID
                   join t_CELLsp_UptGCELL_EXTTP_A41 d
                     on c.PlanID = d.PlanID
                    and c.CMENEID = d.CMENEID
                    and c.CELLID = d.CELLID
                  where a.PlanID = 51
                    and a.CMENEID = 231
                    and a.CHNO in (1, 3, 5, 7)
                    and b.IUO = 2 );

DROP TABLE IF EXISTS hash_join_com_tbl_001_1;
DROP TABLE IF EXISTS hash_join_com_tbl_001_2;
DROP TABLE IF EXISTS hash_join_com_tbl_001;
create table hash_join_com_tbl_001_1(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt real NOT NULL,c_end date NOT NULL,c_unsig int,c_big number(20,0),c_vchar varchar2(2000),c_data varchar2(1500),c_text blob,c_clob clob,c_image clob,c_binary varchar2(3000),c_varbinary varchar2(1000),c_raw raw(1000));
create table hash_join_com_tbl_001_2(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt real NOT NULL,c_end date NOT NULL,c_unsig int,c_big number(20,0),c_vchar varchar2(2000),c_data varchar2(1500),c_text blob,c_clob clob,c_image clob,c_binary varchar2(3000),c_varbinary varchar2(1000),c_raw raw(1000));
create table hash_join_com_tbl_001(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt real NOT NULL,c_end date NOT NULL,c_unsig int,c_big number(20,0),c_vchar varchar2(2000),c_data varchar2(1500),c_text blob,c_clob clob,c_image clob,c_binary varchar2(3000),c_varbinary varchar2(1000),c_raw raw(1000));
create unique index hash_join_indx_001_1 ON hash_join_com_tbl_001(c_id,c_d_id);
create index hash_join_indx_001_2 ON hash_join_com_tbl_001(c_id);
create unique index hash_join_indx_001_3 ON hash_join_com_tbl_001(c_big);
create index hash_join_indx_001_4 ON hash_join_com_tbl_001(c_first,c_binary);
create index hash_join_indx_001_5 ON hash_join_com_tbl_001(c_id,c_d_id,c_varbinary);
create index hash_join_indx_001_6 ON hash_join_com_tbl_001(c_id,c_d_id,c_street_1,c_raw);
create index index_primary_key ON hash_join_com_tbl_001(c_id,c_d_id,c_w_id);


explain select a.c_id, a.c_first
  from hash_join_com_tbl_001_1 a
 inner join hash_join_com_tbl_001_2 b
    on (a.c_id = b.c_id and mod(a.c_id, 5) = mod(b.c_id, 7))
    or (a.c_id + 100 = b.c_id and a.c_first < 'AAis9')
 right join hash_join_com_tbl_001 c
    on a.c_id + 1 = (b.c_id - 10) * 2;
	
drop table if exists t_test_zenith_1;
drop table if exists t_test_zenith_2;
drop table if exists t_test_zenith_3;
create table t_test_zenith_1(id int, name varchar2(100), sqltext varchar2(1000));
create unique index uniq_idx_t_1 on t_test_zenith_1(id);
create table t_test_zenith_2(id int, name varchar2(100), sqltext varchar2(1000));
create table t_test_zenith_3(id int, name varchar2(100), sqltext varchar2(1000));
create or replace view v_test_zenith_1 as select id from t_test_zenith_1;
create or replace view v_test_zenith_2 as select b.id from t_test_zenith_2 a left join t_test_zenith_1 b on a.name=b.name;
create or replace view v_test_zenith_3 as select c.id from t_test_zenith_3 a left join t_test_zenith_2 b on a.name=b.name left join t_test_zenith_1 c on a.name=c.name;
explain select /*+use_nl(a b)*/* from v_test_zenith_1 a left join v_test_zenith_1 b on a.id = b.id where a.id = 1;
explain select /*+use_nl(a b)*/a.* from v_test_zenith_1 a left join v_test_zenith_1 b on a.id = b.id where a.id = 1;
explain select /*+use_nl(a b)*/* from v_test_zenith_1 a join v_test_zenith_1 b on a.id = b.id;
explain select /*+use_nl(a b)*/* from t_test_zenith_1 a left join v_test_zenith_2 b on a.id=b.id;
explain select /*+use_nl(a b)*/* from t_test_zenith_1 a left join v_test_zenith_3 b on a.id=b.id;
explain select /*+use_nl(a b c)*/* from t_test_zenith_1 a join v_test_zenith_2 b on a.id=b.id join v_test_zenith_3 c on a.id=c.id;
explain select /*+use_nl(a b c)*/* from t_test_zenith_1 a join v_test_zenith_2 b on a.id=b.id left join v_test_zenith_3 c on a.id=c.id;
declare 
    i integer;
begin
    for i in 1 .. 1000 loop
        insert into t_test_zenith_1 values(i, i || 'abcdefg', lpad(' ', 1000, ' '));  
        insert into t_test_zenith_2 values(i, i || 'abcdefg', lpad(' ', 1000, ' '));
        insert into t_test_zenith_3 values(i, i || 'abcdefg', lpad(' ', 1000, ' '));		
    end loop;
    commit;
end;
/
select /*+use_nl(a b)*/* from v_test_zenith_1 a left join v_test_zenith_1 b on a.id = b.id where a.id = 1;
select /*+use_nl(a b)*/* from v_test_zenith_1 a join v_test_zenith_1 b on a.id = b.id where a.id = 1;
select /*+use_nl(a b)*/* from t_test_zenith_1 a left join v_test_zenith_2 b on a.id=b.id where a.id = 1;
select /*+use_nl(a b)*/* from t_test_zenith_1 a left join v_test_zenith_3 b on a.id=b.id where a.id = 1;
select /*+use_nl(a b c)*/* from t_test_zenith_1 a join v_test_zenith_2 b on a.id=b.id join v_test_zenith_3 c on a.id=c.id where a.id = 1;
select /*+use_nl(a b c)*/* from t_test_zenith_1 a join v_test_zenith_2 b on a.id=b.id left join v_test_zenith_3 c on a.id=c.id where a.id = 1;

drop table if exists index_t1;
drop table if exists index_t2;
drop table if exists index_t3;
create table index_t1(a int, b int, c int);
create index idx_t1_index_1 on index_t1(a);
create index idx_t1_index_2 on index_t1(b);
create table index_t2(a int, b int, c int);
create index idx_t2_index_1 on index_t2(a);
create index idx_t2_index_2 on index_t2(b);
create table index_t3(a int, b int, c int);
explain select * from index_t1 where a=1 or a=2;
explain select * from index_t1 where a=1 or b=2;
explain select * from index_t1 t1 join index_t2 t2 on t1.a=t2.a or t1.b=t2.a;
explain select * from index_t1 t1 join index_t2 t2 on t1.a=t2.a or t1.b=t2.b;
explain select * from index_t1 t1 join index_t3 t3 on t1.a=t3.a or t1.b=t3.b;
explain select * from index_t1 t1 left join index_t2 t2 on t1.a=t2.a or t1.b=t2.b;
explain select * from index_t1 t1 join index_t2 t2 on t1.a=t2.a where t1.a=1 or t1.b=2;
explain select * from index_t1 t1 join index_t2 t2 on t1.a=t2.a or t1.b=t2.b where t1.a=1 or t1.b=2;
explain select * from (select * from index_t1) t1 join index_t2 t2 on t1.a=t2.a or t1.b=t2.b;
explain select * from index_t1 t1 join index_t2 t2 on t1.a=t2.a or t1.b=t2.b join index_t3 t3 on t2.c=t3.c;
drop table if exists index_t1;
drop table if exists index_t2;
drop table if exists index_t3;

drop table if exists t_join_base_001;
drop table if exists t_join_base_101;
drop table if exists t_join_base_102;
create table t_join_base_001(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date);
create table t_join_base_101(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date);
create table t_join_base_102(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date);

create index idx_join_base_001_1 on t_join_base_001(c_int);
create index idx_join_base_001_2 on t_join_base_001(c_int,c_vchar);
create index idx_join_base_001_3 on t_join_base_001(c_int,c_vchar,c_date);

create index idx_join_base_101_1 on t_join_base_101(c_int);
create index idx_join_base_101_2 on t_join_base_101(c_int,c_vchar);
create index idx_join_base_101_3 on t_join_base_101(c_int,c_vchar,c_date);

create index idx_join_base_102_1 on t_join_base_102(c_int);
create index idx_join_base_102_2 on t_join_base_102(c_int,c_vchar);
create index idx_join_base_102_3 on t_join_base_102(c_int,c_vchar,c_date);

insert into t_join_base_001 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_join_base_101 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_join_base_102 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));

select count(*) from t_join_base_001 t1 left join (t_join_base_101 t2 left join t_join_base_102 t3 on t2.c_vchar=t3.c_vchar) on t1.c_int=t2.c_int;
--test temp
drop table if exists temp_t1;
drop table if exists temp_t2;
create global temporary table temp_t1(a int, b int, c int);
create table temp_t2 (a int, b int, c int);
create index idx_temp_t2_1 on temp_t2(a);
explain select t1.a, t2.a from temp_t1 t1 join temp_t2 t2 on t1.a=t2.a;
explain select t1.a, t2.a from temp_t1 t1 join temp_t2 t2 on t1.a=t2.a where t2.a >10;
drop table if exists temp_t1;
drop table if exists temp_t2;

--test sub-select push down
drop table if exists test_push_t1;
drop table if exists test_push_t2;
create table test_push_t1(a int, b int, c int);
create table test_push_t2(a int, b int, c int);
create index idx_test_push_t1_1 on test_push_t1(a);
insert into test_push_t1 values(1,1,1);
insert into test_push_t1 values(2,2,2);
insert into test_push_t1 values(3,3,3);
insert into test_push_t2 values(1,1,1);
insert into test_push_t2 values(2,2,2);
insert into test_push_t2 values(3,3,3);
explain select * from (select * from test_push_t1) tt where tt.a=(select a from test_push_t2 where a=1);
select * from (select * from test_push_t1) tt where tt.a=(select a from test_push_t2 where a=1);
--DTS2019011608160
drop table if exists t_join_base_001;
drop table if exists t_join_base_101;
create table t_join_base_001(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10),c_vchar2 varchar2(100),c_clob clob,
c_long clob,c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp);

create table t_join_base_101(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10),c_vchar2 varchar2(100),c_clob clob,
c_long clob,c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp);

explain select count(*) from t_join_base_001 t1 
where exists (select max(t11.c_int) over(partition by t1.c_int) from t_join_base_101 t11 
where t11.c_number=t1.c_number);
--hash materialize
DROP TABLE IF EXISTS "T_D_TYPRABBASIC_B4";
CREATE TABLE "T_D_TYPRABBASIC_B4"
(
  "SAVEPOINTID" NUMBER(10) NOT NULL,
  "OPERTYPE" NUMBER(3) NOT NULL,
  "PLANID" NUMBER(10) NOT NULL,
  "CMENEID" NUMBER(10) NOT NULL,
  "RABINDEX" NUMBER(3) NOT NULL,
  "APPLIEDDIRECT" NUMBER(3),
  "CNDOMAINID" NUMBER(3),
  "TRAFFICCLASS" NUMBER(3),
  "MAXBITRATE" NUMBER(17),
  "SSD" NUMBER(3),
  "TYPCFGSUPPORT" NUMBER(3),
  "BETAC" NUMBER(3),
  "BETAD" NUMBER(3),
  "SHIND" NUMBER(3),
  "REQ2GCAP" NUMBER(3),
  "ULFPMODE" NUMBER(3),
  "ACTSTATUS" NUMBER(3),
  "EUTRANSHIND" NUMBER(3),
  "ULDPCH10MSMODEBETAC" NUMBER(3),
  "ULDPCH10MSMODEBETAD" NUMBER(3),
  "LOGUPTID" VARCHAR(383 BYTE),
  "NBI_RECID" NUMBER(10),
  "ISGENMML" NUMBER(3)
);
create index primary_key_T_D_B4 on T_D_TYPRABBASIC_B4("PLANID", "CMENEID", "RABINDEX", "OPERTYPE", "SAVEPOINTID");

DROP TABLE IF EXISTS "T_P_TYPRABRLC_B4";
CREATE TABLE "T_P_TYPRABRLC_B4"
(
  "PLANID" NUMBER(10) NOT NULL,
  "CMENEID" NUMBER(10) NOT NULL,
  "RABINDEX" NUMBER(3),
  "SUBFLOWINDEX" NUMBER(3),
  "TRCHTYPE" NUMBER(3),
  "DELAYCLASS" NUMBER(3),
  "OPPOSITETRCHTYPE" NUMBER(3),
  "RLCMODE" NUMBER(3),
  "AMRLCCFGPARA" NUMBER(3),
  "AMRLCDISCARDMODE" NUMBER(10),
  "UMTMRLCDISCARDMODE" NUMBER(10),
  "EXPLICITTIMERMRW" NUMBER(3),
  "EXPLICITTIMERDISCARD" NUMBER(3),
  "EXPLICITMAXMRW" NUMBER(3),
  "NOEXPLICITTIMERDISCARD" NUMBER(3),
  "MAXDAT" NUMBER(3),
  "TIMERMRW" NUMBER(3),
  "MAXMRW" NUMBER(3),
  "NODISCARDMAXDAT" NUMBER(3),
  "TXWINDOWSIZE" NUMBER(3),
  "TXWINDOWSIZELIMIT" NUMBER(3),
  "TIMERRST" NUMBER(3),
  "MAXRST" NUMBER(3),
  "RXWINDOWSIZE" NUMBER(3),
  "RXWINDOWSIZELIMIT" NUMBER(3),
  "MISSINGPDUIND" NUMBER(3),
  "TIMERSTATUSPROHIBIT" NUMBER(3),
  "TIMERSTATUSPERIODIC" NUMBER(3),
  "LASTTXPDUPOLL" NUMBER(3),
  "LASTRETXPDUPOLL" NUMBER(3),
  "TIMERPOLLPROHIBIT" NUMBER(3),
  "TIMERPOLL" NUMBER(3),
  "POLLPDU" NUMBER(3),
  "POLLSDU" NUMBER(3),
  "POLLWINDOW" NUMBER(3),
  "TIMERPOLLPERIODIC" NUMBER(3),
  "ULSEGIND" NUMBER(3),
  "DLSEGIND" NUMBER(3),
  "TIMETOMONITER" NUMBER(17),
  "MONITERPRD" NUMBER(10),
  "RETRANSRATIOFILTERCOEF" NUMBER(3),
  "EVENTATHRED" NUMBER(10),
  "TIMETOTRIGGERA" NUMBER(10),
  "PENDINGTIMEA" NUMBER(10),
  "EVENTBTHRED" NUMBER(10),
  "TIMETOTRIGGERB" NUMBER(10),
  "PENDINGTIMEB" NUMBER(10),
  "INSEQUENCEDELIVERYORDER" NUMBER(3),
  "CFGPOLLINGPARA" NUMBER(3),
  "EVENTAREPORTDELAY" NUMBER(10),
  "RLCDISCARDMODE" NUMBER(10),
  "POLLPDUFORENL2" NUMBER(3),
  "POLLSDUFORENL2" NUMBER(3),
  "POLLPDUFORDLENL2" NUMBER(17),
  "POLLSDUFORDLENL2" NUMBER(17),
  "POLLPDUFORULENL2" NUMBER(17),
  "POLLSDUFORULENL2" NUMBER(17),
  "RNCMAXRST" NUMBER(3),
  "RNCNODISCARDMAXDAT" NUMBER(3),
  "CMERECORDID" VARCHAR(383 BYTE) NOT NULL
);
create index primary_key_T_P_B4 on T_P_TYPRABRLC_B4("PLANID", "CMENEID", "CMERECORDID");

explain select distinct 'B4' , a.PlanID , a.CMENEID , 'CMENEID:' || to_char(7381) || ',RABINDEX:' || to_char(a.RABINDEX ) as MoID , 'TYPRABBASIC' , 'RADIO_RAB_DELAYCLASS_RLC_CONFUSE' from t_D_TYPRABBASIC_B4 a 
join t_P_TYPRABRLC_B4 b on a.PlanID = b.PlanID and a.CMENEID = b.CMENEID and a.RABINDEX = b.RABINDEX where a.PlanID = 1 and a.CMENEID = 3076 and a.OperType in (2 , 4 )  
and a.ACTSTATUS = 1 and b.RLCMODE = 1 and b.AMRLCCFGPARA = 0 
and (select count(1) from t_P_TYPRABRLC_B4 c where a.PlanID = 1 and a.PlanID = c.PlanID and a.CMENEID = c.CMENEID and a.RABINDEX = c.RABINDEX 
and c.AMRLCCFGPARA = 1 and c.RLCMODE = 1 and c.TRCHTYPE = b.TRCHTYPE 
and  c.OPPOSITETRCHTYPE = b.OPPOSITETRCHTYPE and  c.SUBFLOWINDEX = b.SUBFLOWINDEX and c.DELAYCLASS = b.DELAYCLASS ) = 0;

--DTS2019011506478
drop table if exists t_subselect_dept;
create table t_subselect_dept(
       deptno number(10),
       dname varchar2(30),
       loc varchar2(30)
);
drop table if exists t_subselect_emp;
create table t_subselect_emp(
       empno number(10),
       ename varchar2(30),
       job varchar2(30),
       mgr varchar2(30),
       hiredate number(10),
       sal number(10),
       comm number(10),
       deptno number(10)
);
insert into t_subselect_dept values(1, 'aaa' ,'bbb');
insert into t_subselect_dept values(2, 'SALES' ,'ccc');
insert into t_subselect_dept values(3, 'ddd' ,'eee');
insert into t_subselect_emp values(1, 'fff', 'CLERK' ,'ggg', 20011109, 2000, 1000, 3);
insert into t_subselect_emp values(2, 'SMITH', 'CLERK' ,'hhh', 20120101, 2000, 800, 6);
insert into t_subselect_emp values(3, 'jjj', 'MANAGER' ,'kkk', 20080808, 9000, 4000, 3);

select a.deptno,a.dname,a.loc,b.job,b.sal
from t_subselect_dept a,t_subselect_emp b where b.sal = (select STDDEV(c.sal) from t_subselect_emp c where a.deptno=c.deptno) order by a.deptno,a.dname,a.loc,b.job,b.sal;

explain plan for select a.deptno,a.dname,a.loc,b.job,b.sal
from t_subselect_dept a,t_subselect_emp b where b.sal = (select STDDEV(c.sal) from t_subselect_emp c where a.deptno=c.deptno group by c.deptno) order by a.deptno,a.dname,a.loc,b.job,b.sal;

--DTS2019011714785
drop table if exists t_subselect_dept;
create table t_subselect_dept(
       deptno int,
       dname varchar(30) UNIQUE,
       loc varchar(30),
    mgr varchar(30)
);
create unique index idx_pk_subselect_dept on t_subselect_dept(deptno);

drop table if exists t_subselect_emp;
create table t_subselect_emp(
       empno int,
       ename varchar(30) not null,
       job varchar(30),
       mgr varchar(30),
       hiredate int,
       sal int not null,
       comm int check(comm<10000),
       deptno int
);
create unique index idx_pk_subselect_emp on t_subselect_emp(empno);

explain
select  a.deptno, a.dname, a.loc, b.job, b.sal
  from t_subselect_dept a
 inner join t_subselect_emp b
    on a.deptno = b.deptno
 where ascii(b.sal) = (select ascii(min(rownum))
                         from t_subselect_emp c
                        inner join t_subselect_dept d
                           on d.mgr = c.mgr
                        where a.deptno = c.deptno
                          and c.sal >= 2000)
 order by a.deptno, a.dname, a.loc, b.job, b.sal;
 
DROP TABLE IF EXISTS PULL_UP_T1;
DROP TABLE IF EXISTS PULL_UP_T2;
CREATE TABLE PULL_UP_T1(A INT, B INT, C INT);
CREATE INDEX IDX_PULL_UP_T1_1 ON PULL_UP_T1(A,B);
CREATE TABLE PULL_UP_T2(A INT, B INT, C INT);
EXPLAIN SELECT * FROM PULL_UP_T1 T1 WHERE EXISTS (SELECT * FROM PULL_UP_T2 T2 WHERE T2.A > T1.A AND T1.A=2 AND T1.B=2);
EXPLAIN SELECT * FROM PULL_UP_T1 T1 WHERE T1.C IN (SELECT T2.C FROM PULL_UP_T2 T2 WHERE T2.A > T1.A AND T1.A=2 AND T1.B=2);
EXPLAIN SELECT * FROM PULL_UP_T1 T1 WHERE NOT EXISTS (SELECT * FROM PULL_UP_T2 T2 WHERE T2.A > T1.A AND T1.A=2 AND T1.B=2);
EXPLAIN SELECT * FROM PULL_UP_T1 T1 WHERE T1.C NOT IN (SELECT T2.C FROM PULL_UP_T2 T2 WHERE T2.A > T1.A AND T1.A=2 AND T1.B=2);

DROP TABLE IF EXISTS "TBL_OBJECTINSTANCE" CASCADE CONSTRAINTS;
CREATE TABLE "TBL_OBJECTINSTANCE"
(
  "OBJECTTYPEID" BINARY_INTEGER NOT NULL,
  "OBJECTNO" BINARY_INTEGER NOT NULL,
  "INVALIDTIME" DATE,
  "OBJECTPARAMETER" VARCHAR(64 BYTE),
  "NEFDN" VARCHAR(120 BYTE) NOT NULL,
  "NENAME" VARCHAR(200 BYTE) NOT NULL,
  "MEMBERNUM" BINARY_INTEGER NOT NULL,
  "OBJECTMEMBER0" VARCHAR(255 BYTE),
  "OBJECTMEMNAME0" VARCHAR(512 BYTE),
  "OBJECTMEMBER1" VARCHAR(255 BYTE),
  "OBJECTMEMNAME1" VARCHAR(255 BYTE),
  "OBJECTMEMBER2" VARCHAR(255 BYTE),
  "OBJECTMEMNAME2" VARCHAR(255 BYTE),
  "OBJECTMEMBER3" VARCHAR(255 BYTE),
  "OBJECTMEMNAME3" VARCHAR(255 BYTE),
  "OBJECTMEMBER4" VARCHAR(255 BYTE),
  "OBJECTMEMNAME4" VARCHAR(255 BYTE),
  "OBJECTMEMBER5" VARCHAR(255 BYTE),
  "OBJECTMEMNAME5" VARCHAR(255 BYTE),
  "OBJECTDESCRIPTION" VARCHAR(192 BYTE),
  "BAMOBJECTSTR" VARCHAR(255 BYTE),
  "MEASUREMENTSTATE" BINARY_INTEGER NOT NULL,
  UNIQUE("OBJECTTYPEID", "OBJECTNO")
);
CREATE INDEX "INDEXNEFDN" ON "TBL_OBJECTINSTANCE"("OBJECTTYPEID", "NEFDN", "BAMOBJECTSTR");
CREATE INDEX "INDEXOBJECTTYPEID" ON "TBL_OBJECTINSTANCE"("OBJECTTYPEID");
CREATE INDEX "INDEXPURENEFDN" ON "TBL_OBJECTINSTANCE"("NEFDN");
CREATE INDEX "INVALIDTIMEINDEX" ON "TBL_OBJECTINSTANCE"("INVALIDTIME");

DROP TABLE IF EXISTS "TBL_OBJMEASREC_1526726666" CASCADE CONSTRAINTS;
CREATE TABLE "TBL_OBJMEASREC_1526726666"
(
  "OBJECTNO" BINARY_INTEGER NOT NULL,
  "STARTTIME" DATE NOT NULL,
  "ENDTIME" DATE,
  "TIMEZONEOFFSET" BINARY_INTEGER NOT NULL,
  "STARTTIMEDSTOFFSET" BINARY_INTEGER NOT NULL,
  "ENDTIMEDSTOFFSET" BINARY_INTEGER NOT NULL
);
ALTER TABLE "TBL_OBJMEASREC_1526726666" ADD CONSTRAINT "I_TBL_OBJMEASREC_1526726666" PRIMARY KEY("OBJECTNO", "STARTTIME");
explain select ObjectNo from tbl_ObjectInstance where ObjectTypeId = 1526726666 and NeFdn = 'NE=6699' and MeasurementState = 1 and InvalidTime is null and ObjectNo not in (select ObjectNo from tbl_ObjMeasRec_1526726666 where EndTime is null); 
DROP TABLE IF EXISTS t_join_drv_1 CASCADE CONSTRAINTS;
DROP TABLE IF EXISTS t_join_drv_2 CASCADE CONSTRAINTS;
create table t_join_drv_1(a int, b int, c int);
create table t_join_drv_2(a int, b int, c int);
create index idx_t1_1 on t_join_drv_1(a);
explain select * from t_join_drv_1 t1 join t_join_drv_2 t2 on t1.a=t2.a where t1.a=100;
explain select * from t_join_drv_1 t1 join t_join_drv_2 t2 on t1.a=t2.a;
explain select * from t_join_drv_2 t2 join t_join_drv_1 t1 on t1.a=t2.a;
explain select * from t_join_drv_2 t2 left join t_join_drv_1 t1 on t1.a=10 and t1.b=t2.b;
DROP TABLE IF EXISTS t_join_drv_1 CASCADE CONSTRAINTS;

--DTS2019022809303
drop table if exists t_subselect_dept;
create table t_subselect_dept(deptno int,dname varchar(30),loc varchar(30),mgr varchar(30));

drop table if exists t_subselect_emp;
create table t_subselect_emp(empno int,ename varchar(30),job varchar(30),mgr varchar(30),hiredate int,sal int,comm int,deptno int);

drop table if exists t_subselect_dept_null;
create table t_subselect_dept_null(deptno int primary key,dname varchar(30),loc varchar(30),mgr varchar(30));

drop table if exists t_subselect_emp_null;
create table t_subselect_emp_null(empno int primary key,ename varchar(30) not null,job varchar(30),mgr varchar(30),hiredate int,sal int,comm int check(comm<10000),deptno int);

drop table if exists t_subselect_family;
create table t_subselect_family(empno int,family_name varchar(100),family_sal int);

drop view if exists t_subselect_emp_view;
create view t_subselect_emp_view as select * from t_subselect_emp;
drop view if exists t_subselect_dept_view;
create view t_subselect_dept_view as select * from t_subselect_dept;

explain select a.deptno,a.dname,a.loc,b.job,b.sal
from t_subselect_dept_view a inner join t_subselect_emp_view b on a.deptno=b.deptno where b.sal = (select sum(c.sal) from t_subselect_emp_view c inner join t_subselect_dept_view d on d.mgr=c.mgr  where a.deptno=c.deptno and c.sal >=2000) order by a.deptno,a.dname,a.loc,b.job,b.sal;

explain select a.deptno,a.dname,a.loc,b.job,b.sal
from t_subselect_dept a inner join t_subselect_emp b on a.deptno=b.deptno where ascii(b.sal) = (select ascii(min(c.sal)) from (select sal,mgr,deptno from t_subselect_emp) c inner join (select deptno,dname,loc,mgr from t_subselect_dept d) as d on d.mgr=c.mgr  where a.deptno=c.deptno and c.sal >=2000) order by a.deptno,a.dname,a.loc,b.job,b.sal;

drop table if exists t_dlvr_1;
drop table if exists t_dlvr_2;
drop table if exists t_dlvr_3;
drop table if exists t_dlvr_4;
create table t_dlvr_1(a int, b int, c int);
create table t_dlvr_2(a int, b int, c int)
PARTITION BY RANGE(a)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);
create table t_dlvr_3(a int, b int, c int)
PARTITION BY RANGE(b)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);
create table t_dlvr_4(a int, b int, c int)
PARTITION BY RANGE(a)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);
explain select * from t_dlvr_1 t1 left join t_dlvr_2 t2 on t1.a=t2.a where t1.b=10;
explain select * from t_dlvr_1 t1 left join t_dlvr_2 t2 on t1.a=t2.a where t1.a=10;
explain select * from t_dlvr_1 t1 left join t_dlvr_2 t2 on t1.a=t2.a left join t_dlvr_3 t3 on t1.b=t3.b where t1.a=10;
explain select * from t_dlvr_1 t1 left join t_dlvr_2 t2 on t1.a=t2.a left join t_dlvr_3 t3 on t1.b=t3.b where t1.a=10 and t1.b=20;
explain select * from t_dlvr_1 t1 right join t_dlvr_2 t2 on t1.a=t2.a left join t_dlvr_3 t3 on t1.b=t3.b where t1.a=10;
explain select * from t_dlvr_1 t1 left join t_dlvr_2 t2 on t1.a=t2.a right join t_dlvr_3 t3 on t1.b=t3.b where t1.a=10;
explain select * from t_dlvr_1 t1 right join t_dlvr_2 t2 on t1.a=t2.a left join t_dlvr_3 t3 on t1.b=t3.b where t1.a=10 and t1.b=20;
explain select * from t_dlvr_1 t1 left join t_dlvr_2 t2 on t1.a=t2.a right join t_dlvr_3 t3 on t1.b=t3.b where t1.a=10 and t1.b=20;
explain select * from t_dlvr_2 t2 left join t_dlvr_4 t4 on t2.a=t4.a left join t_dlvr_3 t3 on t4.b=t3.b where t4.a=10 and t4.b=20;

-- SR.IREQ02305460.001
drop table if exists test;
create table  test (a int, b int, c int);
create index ix_1 on test (a);
create index ix_2 on test (a, b);

explain select a from test where a = 40;
explain select b from test where a = 40;
explain select c from test where a = 40;

explain select a from test where a = 40 and b = 20;
explain select c from test where a = 40 and b = 20;
explain select a, b from test where a = 40 and b = 20;
explain select a, c from test where a = 40 and b = 20;

drop table if exists test;
create table  test (a int, b int, c int);
create index ix_2 on test (a, b);
create index ix_1 on test (a);

explain select a from test where a = 40;
explain select b from test where a = 40;
explain select c from test where a = 40;

explain select a from test where a = 40 and b = 20;
explain select c from test where a = 40 and b = 20;
explain select a, b from test where a = 40 and b = 20;
explain select a, c from test where a = 40 and b = 20;

drop table if exists t_push_1;
drop table if exists t_push_2;
drop table if exists t_push_3;
drop table if exists t_push_4;
drop table if exists t_push_5;
drop table if exists t_push_6;
create table t_push_1(a int, b int, c int);
create table t_push_2(a int, b int, c int);
create table t_push_3(a int, b int, c int);
create table t_push_4(a int, b int, c int);
create table t_push_5(a int, b int, c int);
create table t_push_6(a int, b int, c int);

create index idx_t_push_2 on t_push_2(a);
create index idx_t_push_4 on t_push_4(a);
create index idx_t_push_5 on t_push_5(a);
create index idx_t_push_6 on t_push_6(a);

create or replace view v_push_1 as select * from t_push_1;
create or replace view v_push_2 as select * from t_push_2;
create or replace view v_push_3 as select * from v_push_1;
create or replace view v_push_4 as select * from v_push_2;
create or replace view v_push_5 as select t2.a t2a,t4.a t4a from t_push_2 t2 join t_push_4 t4 on t2.a=t4.a;
create or replace view v_push_6 as select t5.a t5a,t6.a t6a from t_push_5 t5 left join t_push_6 t6 on t5.a=t6.a;
create or replace view v_push_7 as select t1.a t1a,t3.a t3a,t3.b t3b from t_push_1 t1 left join t_push_3 t3 on t1.a=t3.a;

explain select * from t_push_2 t2 join v_push_1 v1 on t2.a=v1.a;
explain select * from v_push_1 v1 join t_push_2 t2 on t2.a=v1.a;
explain select * from t_push_1 t1 join v_push_2 v2 on t1.a=v2.a;
explain select * from t_push_2 t2 join v_push_2 v2 on t2.a=v2.a;
explain select * from t_push_1 t1 join v_push_4 v4 on t1.a=v4.a;
explain select * from t_push_2 t2 join v_push_4 v4 on t2.a=v4.a;
explain select * from t_push_2 t2 join v_push_7 v7 on t2.a=v7.t1a and t2.b=v7.t3b;
explain select * from v_push_1 v1 join v_push_2 v2 on v1.a = v2.a;
explain select * from v_push_1 v1 left join v_push_2 v2 on v1.a = v2.a;
explain select * from v_push_2 v2 join v_push_1 v1 on v2.a = v1.a;
explain select * from v_push_3 v3 join v_push_4 v4 on v3.a = v4.a;
explain select * from v_push_4 v4 join v_push_3 v3 on v3.a = v4.a;
explain select * from v_push_5 v5 join v_push_6 v6 on v5.t2a=v6.t5a and v5.t4a=v6.t6a;
explain select * from v_push_6 v6 join v_push_5 v5 on v5.t2a=v6.t5a and v5.t4a=v6.t6a;
explain select * from v_push_5 v5 join v_push_7 v7 on v5.t2a=v7.t1a and v5.t4a=v7.t3a;
explain select * from v_push_7 v7 join v_push_5 v5 on v5.t2a=v7.t1a and v5.t4a=v7.t3a;
explain select * from t_push_1 t1 join v_push_1 v1 on t1.b=v1.b join v_push_2 v2 on t1.a=v2.a and v1.b=v2.b;
explain select * from t_push_1 t1 join v_push_1 v1 on t1.b=v1.b join v_push_2 v2 on t1.a=v2.a and v1.a=v2.a;
explain select * from t_push_1 t1 join v_push_2 v2 on t1.a=v2.a join v_push_4 v4 on t1.a=v4.a and v2.a=v4.a;

EXPLAIN SELECT A.TABLE_NAME, A.COLUMN_NAME, B.TABLE_NAME, B.COLUMN_NAME
  FROM (SELECT TABLE_NAME, COLUMN_NAME
          FROM USER_PART_COL_STATISTICS
         WHERE TABLE_NAME = 'T_USER_PART_COL_STATISTICS_001') A,
       (SELECT TABLE_NAME, COLUMN_NAME
          FROM USER_PART_COL_STATISTICS
         WHERE TABLE_NAME = 't_stack_test_n2') B
 WHERE A.COLUMN_NAME = B.COLUMN_NAME
 ORDER BY A.TABLE_NAME, A.COLUMN_NAME, B.TABLE_NAME, B.COLUMN_NAME;
 
DROP TABLE IF EXISTS "F_TNN000061_RNCUNCELL_H" CASCADE CONSTRAINTS;
CREATE TABLE "F_TNN000061_RNCUNCELL_H"
(
  "STARTTIME" DATE NOT NULL,
  "NEID" NUMBER(19) NOT NULL,
  "MONTH" NUMBER(3) NOT NULL,
  "DAY" NUMBER(3) NOT NULL,
  "HOUR" NUMBER(3) NOT NULL,
  "DSTOFFSET" NUMBER(5),
  "RNCUNCELLID" NUMBER(19) NOT NULL,
  "PERIOD" NUMBER(10),
  "RESULTNO" NUMBER(10) NOT NULL,
  "DELETEFLAG" NUMBER(10),
  "SUBDELETEFLAG" NUMBER(10),
  "PREINTEGRITY" NUMBER(10),
  "INTEGRITY" NUMBER(10),
  "C73393995" NUMBER(25, 5),
  "C73394011" NUMBER(25, 5),
  "C73394010" NUMBER(25, 5),
  "C73394009" NUMBER(25, 5),
  "C73394008" NUMBER(25, 5),
  "C73394007" NUMBER(25, 5),
  "C73394006" NUMBER(25, 5),
  "C73394005" NUMBER(25, 5),
  "C73394003" NUMBER(25, 5),
  "C73394002" NUMBER(25, 5),
  "C73394001" NUMBER(25, 5),
  "C73394000" NUMBER(25, 5),
  "C73393999" NUMBER(25, 5),
  "C73393998" NUMBER(25, 5),
  "C67183491" NUMBER(25, 5),
  "C73393994" NUMBER(25, 5),
  "C73393993" NUMBER(25, 5),
  "C73393992" NUMBER(25, 5),
  "C73393991" NUMBER(25, 5),
  "C73393990" NUMBER(25, 5),
  "C73393989" NUMBER(25, 5),
  "C73393988" NUMBER(25, 5),
  "C67189911" NUMBER(25, 5),
  "C67189910" NUMBER(25, 5),
  "C67189909" NUMBER(25, 5),
  "C67183494" NUMBER(25, 5),
  "C67183493" NUMBER(25, 5),
  "C67183492" NUMBER(25, 5),
  "C73394004" NUMBER(25, 5),
  "C73394033" NUMBER(25, 5),
  "C73394032" NUMBER(25, 5),
  "C73394031" NUMBER(25, 5),
  "C73394030" NUMBER(25, 5),
  "C73394029" NUMBER(25, 5),
  "C73394028" NUMBER(25, 5),
  "C73394027" NUMBER(25, 5),
  "C73394026" NUMBER(25, 5),
  "C67183489" NUMBER(25, 5),
  "C73393997" NUMBER(25, 5),
  "C73393996" NUMBER(25, 5),
  "C67190711" NUMBER(25, 5),
  "C67190710" NUMBER(25, 5),
  "C67190709" NUMBER(25, 5),
  "C67190708" NUMBER(25, 5),
  "C67189912" NUMBER(25, 5),
  "C67183490" NUMBER(25, 5)
)
PARTITION BY RANGE ("STARTTIME")
(
    PARTITION PRS_PART_19000101 VALUES LESS THAN (to_date('19000101', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8,
    PARTITION PRS_PART_20190501 VALUES LESS THAN (to_date('20190501', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8,
    PARTITION PRS_PART_20190502 VALUES LESS THAN (to_date('20190502', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8,
    PARTITION PRS_PART_20190503 VALUES LESS THAN (to_date('20190503', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8,
    PARTITION PRS_PART_20190504 VALUES LESS THAN (to_date('20190504', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8,
    PARTITION PRS_PART_20190505 VALUES LESS THAN (to_date('20190505', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8,
    PARTITION PRS_PART_20190506 VALUES LESS THAN (to_date('20190506', 'YYYYMMDD'))  INITRANS 2 PCTFREE 8
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;

CREATE UNIQUE INDEX "I_TNN000061_RNCUNCELL_H" ON "F_TNN000061_RNCUNCELL_H"("STARTTIME", "HOUR", "RNCUNCELLID", "DSTOFFSET")
LOCAL
INITRANS 2
PCTFREE 8;

CREATE INDEX "II_TNN000061_RNCUNCELL_H" ON "F_TNN000061_RNCUNCELL_H"("STARTTIME", "RNCUNCELLID")
LOCAL
INITRANS 2
PCTFREE 8;

CREATE INDEX "III_TNN000061_RNCUNCELL_H" ON "F_TNN000061_RNCUNCELL_H"("STARTTIME", "RESULTNO")
LOCAL
INITRANS 2
PCTFREE 8;

CREATE INDEX "NE_TNN000061_RNCUNCELL_H" ON "F_TNN000061_RNCUNCELL_H"("NEID", "HOUR")
LOCAL
INITRANS 2
PCTFREE 8;

DROP TABLE IF EXISTS "M_INOBJINDEX_2_01_00002" CASCADE CONSTRAINTS;
CREATE TABLE "M_INOBJINDEX_2_01_00002"
(
  "OBJECTID" NUMBER(19) NOT NULL
)NOLOGGING
TABLESPACE "TEMP2"
INITRANS 2
MAXTRANS 255
PCTFREE 8;

CREATE UNIQUE INDEX "I0_INOBJINDEX_2_01_00002" ON "M_INOBJINDEX_2_01_00002"("OBJECTID")
INITRANS 2
PCTFREE 8;

explain delete from f_TNN000061_RNCUNCELL_H where StartTime = to_date('20190504000000', 'yyyymmddhh24miss') and Hour = 17 and exists (select 1 from m_inObjIndex_2_01_00002 where RNCUNCELLId = m_inObjIndex_2_01_00002.ObjectId+0);

drop table if exists RBO_BMSQL_CUSTOMER_1;
drop table if exists RBO_BMSQL_CUSTOMER_2;
create table RBO_BMSQL_CUSTOMER_1
(
C_W_ID                              BINARY_INTEGER NOT NULL, 
C_D_ID                              BINARY_INTEGER NOT NULL, 
C_ID                                BINARY_INTEGER NOT NULL, 
C_DISCOUNT                          NUMBER(4, 4),
C_CREDIT                            CHAR(2 BYTE),
C_LAST                              VARCHAR(16 BYTE),
C_FIRST                             VARCHAR(16 BYTE),
C_CREDIT_LIM                        NUMBER(12, 2),
C_BALANCE                           NUMBER(12, 2),
C_YTD_PAYMENT                       NUMBER(12, 2),
C_PAYMENT_CNT                       BINARY_INTEGER,
C_DELIVERY_CNT                      BINARY_INTEGER,
C_STREET_1                          VARCHAR(20 BYTE),
C_STREET_2                          VARCHAR(20 BYTE),
C_CITY                              VARCHAR(20 BYTE),
C_STATE                             CHAR(2 BYTE),
C_ZIP                               CHAR(9 BYTE),
C_PHONE                             CHAR(16 BYTE),
C_SINCE                             TIMESTAMP(6),
C_MIDDLE                            CHAR(2 BYTE),
C_DATA                              VARCHAR(500 BYTE)
);

create index RBO_BMSQL_CUSTOMER_1_idx1 on  RBO_BMSQL_CUSTOMER_1 (c_w_id);
create index RBO_BMSQL_CUSTOMER_1_idx2 on  RBO_BMSQL_CUSTOMER_1 (c_d_id);
create index RBO_BMSQL_CUSTOMER_1_idx3 on  RBO_BMSQL_CUSTOMER_1 (c_id);
create index RBO_BMSQL_CUSTOMER_1_idx4 on  RBO_BMSQL_CUSTOMER_1 (c_last);
create index RBO_BMSQL_CUSTOMER_1_idx5 on  RBO_BMSQL_CUSTOMER_1 (c_first);
create index RBO_BMSQL_CUSTOMER_1_idx6 on  RBO_BMSQL_CUSTOMER_1 (c_w_id,c_first);
create index RBO_BMSQL_CUSTOMER_1_idx7 on  RBO_BMSQL_CUSTOMER_1 (c_w_id,c_d_id,c_first);
create index RBO_BMSQL_CUSTOMER_1_idx8 on  RBO_BMSQL_CUSTOMER_1 (c_w_id, c_d_id, c_last, c_first);
create index RBO_BMSQL_CUSTOMER_1_idx9 on  RBO_BMSQL_CUSTOMER_1 (C_SINCE);

create table RBO_BMSQL_CUSTOMER_2 (
  c_w_id         integer        not null,
  c_d_id         integer        not null,
  c_id           integer        not null,
  c_discount     decimal(4,4),
  c_credit       char(2),
  c_last         varchar(16),
  c_first        varchar(16),
  c_credit_lim   decimal(12,2),
  c_balance      decimal(12,2),
  c_ytd_payment  decimal(12,2),
  c_payment_cnt  integer,
  c_delivery_cnt integer,
  c_street_1     varchar(20),
  c_street_2     varchar(20),
  c_city         varchar(20),
  c_state        char(2),
  c_zip          char(9),
  c_phone        char(16),
  c_since        timestamp,
  c_middle       char(2),
  c_data         varchar(500)
);

create index rbo_bmsql_customer_2_idx1 on  RBO_BMSQL_CUSTOMER_2 (c_w_id, c_d_id, c_last, c_first);
create index rbo_bmsql_customer_2_idx2 on  RBO_BMSQL_CUSTOMER_2 (c_w_id);
create index rbo_bmsql_customer_2_idx3 on  RBO_BMSQL_CUSTOMER_2 (c_d_id);
create index rbo_bmsql_customer_2_idx4 on  RBO_BMSQL_CUSTOMER_2 (c_id);
create index rbo_bmsql_customer_2_idx5 on  RBO_BMSQL_CUSTOMER_2 (c_last);
create index rbo_bmsql_customer_2_idx6 on  RBO_BMSQL_CUSTOMER_2 (c_first);
create index rbo_bmsql_customer_2_idx7 on  RBO_BMSQL_CUSTOMER_2 (c_w_id,c_first);
create index rbo_bmsql_customer_2_idx8 on  RBO_BMSQL_CUSTOMER_2 (c_w_id,c_d_id,c_first);
create index rbo_bmsql_customer_2_idx9 on  RBO_BMSQL_CUSTOMER_2 (C_SINCE);

explain select a.C_W_ID, a.C_LAST
  from RBO_BMSQL_CUSTOMER_1 a
  left join (select C_SINCE
               from rbo_bmsql_customer_2
              where c_first like 'w%'
              group by C_SINCE) b
    on a.C_SINCE = b.C_SINCE
 where a.C_W_ID > 80;

drop table if exists RBO_BMSQL_CUSTOMER_1;
drop table if exists RBO_BMSQL_CUSTOMER_2;

drop table if exists rbo_t_join_base_001;
drop table if exists rbo_t_join_base_101;
drop table if exists rbo_t_join_base_102;
drop table if exists rbo_t_join_base_103;
drop table if exists rbo_t_join_base_104;
create table rbo_t_join_base_001(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10),c_vchar2 varchar2(100),c_clob clob,
c_long clob,c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp)
PARTITION BY RANGE(id)
(
PARTITION id1 VALUES LESS than(10),
PARTITION id2 VALUES LESS than(100),
PARTITION id3 VALUES LESS than(1000),
PARTITION id4 VALUES LESS than(MAXVALUE)
);
create table rbo_t_join_base_101 as select * from rbo_t_join_base_001;
create table rbo_t_join_base_102 as select * from rbo_t_join_base_001;
create table rbo_t_join_base_103 as select * from rbo_t_join_base_001;
create table rbo_t_join_base_104 as select * from rbo_t_join_base_001;
explain plan for
select count(*) from rbo_t_join_base_001 t1
where exists (select reverse(t11.c_vchar||t1.c_vchar) from rbo_t_join_base_101 t11
join rbo_t_join_base_102 t12 on t11.c_int=t12.c_int and t11.c_vchar=t12.c_vchar and t11.c_timestamp=t12.c_timestamp and t1.c_real=t12.c_real
where t11.c_int=t1.c_int and t11.c_vchar=t1.c_vchar and t11.c_timestamp=t1.c_timestamp and t11.c_real=t1.c_real
)
and exists (select bitand(rownum,rownum) from rbo_t_join_base_101 t11
join rbo_t_join_base_103 t13 on t11.c_number=t13.c_number and t11.c_clob is not null and t13.c_clob is not null
where t11.c_int=t1.c_int and t11.c_vchar=t1.c_vchar and t11.c_timestamp=t1.c_timestamp and t11.c_real=t1.c_real
)
and exists (select upper(t1.rowid) from rbo_t_join_base_101 t11
join rbo_t_join_base_104 t14 on t11.c_int=t14.c_int and t11.c_vchar=t14.c_vchar and t11.c_timestamp=t14.c_timestamp
where t11.c_int=t1.c_int and t11.c_vchar=t1.c_vchar and t11.c_timestamp=t1.c_timestamp and t11.c_real=t1.c_real
);
drop table if exists rbo_t_join_base_001;
drop table if exists rbo_t_join_base_101;
drop table if exists rbo_t_join_base_102;
drop table if exists rbo_t_join_base_103;
drop table if exists rbo_t_join_base_104;

drop table if exists rbo_test_in;
create table rbo_test_in(a int, b int, c int);
create index idx_rbo_test_in on rbo_test_in(a,b);
explain select * from rbo_test_in where a in (10) order by b;
drop table if exists rbo_test_in;


drop table if exists test_or_index;
create table test_or_index(a int, b int, c int, d int, e int);
create index idx_test_or_index_1 on test_or_index(b,a);
create index idx_test_or_index_2 on test_or_index(c,a);
create index idx_test_or_index_3 on test_or_index(d);
create index idx_test_or_index_4 on test_or_index(e);
explain select * from test_or_index where (b=10 or c = 100) and (d = 66 or a = 88);
explain select * from test_or_index where (b=10 or c = 100) and (d = 66 or e = 88);
explain select * from test_or_index where a=10 and (b=10 or c = 100) and (d = 66 or e = 88);
drop table if exists test_or_index;

--DTS2019112216305
drop table if exists CM_SUBS_ORDER;
create table CM_SUBS_ORDER
(
  oid                  NUMBER(20) not null,
  ordernumber          VARCHAR2(32),
  type                 CHAR(2),
  status               CHAR(1),
  start_time           VARCHAR2(14),
  end_time             VARCHAR2(14),
  corp_id              VARCHAR2(20),
  device_groupid       NUMBER(10),
  creator              VARCHAR2(32),
  create_time          DATE default sysdate,
  order_type           CHAR(2) default '01',
  job_id               VARCHAR2(32),
  file_name            VARCHAR2(256),
  job_msg              VARCHAR2(256),
  job_status           VARCHAR2(10),
  result_file_pathname VARCHAR2(256)
)
partition by range (CREATE_TIME) interval (NUMTOYMINTERVAL(1,'MONTH'))
(
  partition ORDER_CREATE_TIME_01 values less than (TO_DATE('2019-05-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'))
);
create index IDX_CRT_TIME_ORDER on CM_SUBS_ORDER (CREATOR,TYPE,CREATE_TIME) local; 
explain select o.oid,
         o.ORDERNUMBER,
         o.corp_id,
         o.status,
         o.start_time,
         o.end_time,
         o.type,
         o.create_time,
         o.creator,
         o.order_type,
         o.file_name
    from cm_subs_order o
   WHERE o.create_time >=
         to_date('2019-09-21 00:00:00', 'yyyy-MM-dd hh24:mi:ss')
     and o.create_time <=
         to_date('2019-09-30 00:00:00', 'yyyy-MM-dd hh24:mi:ss')
     and o.CREATOR = 'iot189'
     and o.TYPE = '27'
   order by  o.create_time limit 10;
drop table if exists CM_SUBS_ORDER;

--20210709
drop table if exists part_test;
create table part_test (a int, b int, c int, d int)
partition by range (a, b)
(
partition p1 values less than (5, 5),
partition p2 values less than (10, 10),
partition p3 values less than (15, 15),
partition p4 values less than (20, 20),
partition p5 values less than (25, 25),
partition p6 values less than (30, 30),
partition p7 values less than(MAXVALUE, MAXVALUE)
);
create index part_test_index_abc on part_test(a,b,c);
explain select * from part_test order by a;
drop table if exists part_test;

--20200218
drop table if exists t_join_base_001;
drop table if exists t_join_base_101;
drop table if exists t_join_base_102;
drop table if exists t_join_base_201;
create table t_join_base_001(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date);  
create table t_join_base_101(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date);    
create table t_join_base_102(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date);
create table t_join_base_201(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date);   
create index idx_join_base_001_1 on t_join_base_001(c_int);
create index idx_join_base_101_3 on t_join_base_101(c_int,c_vchar,c_date);
create index idx_join_base_102_1 on t_join_base_102(c_int);
create index idx_join_base_201_1 on t_join_base_201(c_int);
insert into t_join_base_001 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_join_base_101 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_join_base_102 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
commit;
select count(*) from t_join_base_001 t1, (t_join_base_101 t2 left join (t_join_base_201 t3 left join (t_join_base_201 t4 left join (t_join_base_102 t5 left join t_join_base_102 t6 on t5.c_int>t6.c_int) on t4.c_int>t5.c_int) on t3.c_int>t4.c_int) on t2.c_date>t4.c_date) where abs(t4.id) = -1;
drop table t_join_base_001;
drop table t_join_base_101;
drop table t_join_base_102;
drop table t_join_base_201;

-- DTS202009090LORNGP1I00
drop table if exists hash_anti_eof_t1;
drop table if exists hash_anti_eof_t2;
drop table if exists hash_anti_eof_t3;
drop table if exists hash_anti_eof_t4;
create table hash_anti_eof_t1
(
    id number(8) not null,
    c_int number(8),
    c_bigint number(15)
);
insert into hash_anti_eof_t1 values(1, 1, 100);
insert into hash_anti_eof_t1 values(2, 1, 200);
insert into hash_anti_eof_t1 values(3, 1, 300);
commit;

create table hash_anti_eof_t2
(
    id number(8) not null,
    c_int number(8)
);
insert into hash_anti_eof_t2 values(1, 1);
insert into hash_anti_eof_t2 values(2, 1);
insert into hash_anti_eof_t2 values(3, 1);
commit;

create table hash_anti_eof_t3
(
  id varchar(10) not null,
  c_str varchar(35)
);

create table hash_anti_eof_t4
(
  emp_no number(8) not null,
  salary number(8) not null
);

explain 
SELECT
    ref_1.c_str AS C0,
    ref_0.c_bigint AS C1
FROM
    (hash_anti_eof_t1 ref_0)
        INNER JOIN (((hash_anti_eof_t3 ref_1)
            INNER JOIN (((hash_anti_eof_t2 ref_2)
                INNER JOIN (hash_anti_eof_t4 ref_3)
                ON (NOT EXISTS (
                        SELECT DISTINCT
                            ref_3.emp_no AS C0,
                            ref_3.salary AS C3
                        FROM
                            hash_anti_eof_t1 ref_4
                        WHERE ref_4.c_int < ref_4.c_int)))
            CROSS JOIN (hash_anti_eof_t1 ref_5))
            ON ref_5.id is null))
        ON (ref_5.c_bigint IS NOT NULL)
WHERE ref_0.c_int >= ref_5.c_int;

SELECT
    ref_1.c_str AS C0,
    ref_0.c_bigint AS C1
FROM
    (hash_anti_eof_t1 ref_0)
        INNER JOIN (((hash_anti_eof_t3 ref_1)
            INNER JOIN (((hash_anti_eof_t2 ref_2)
                INNER JOIN (hash_anti_eof_t4 ref_3)
                ON (NOT EXISTS (
                        SELECT DISTINCT
                            ref_3.emp_no AS C0,
                            ref_3.salary AS C3
                        FROM
                            hash_anti_eof_t1 ref_4
                        WHERE ref_4.c_int < ref_4.c_int)))
            CROSS JOIN (hash_anti_eof_t1 ref_5))
            ON ref_5.id is null))
        ON (ref_5.c_bigint IS NOT NULL)
WHERE ref_0.c_int >= ref_5.c_int;

drop table hash_anti_eof_t1;
drop table hash_anti_eof_t2;
drop table hash_anti_eof_t3;
drop table hash_anti_eof_t4;

-- 
drop table if exists scan_mode_reset_t0;
drop table if exists scan_mode_reset_t1;
drop table if exists scan_mode_reset_t2;

create table scan_mode_reset_t0(id number(8), c_int number(8), name varchar(30));
create table scan_mode_reset_t1(name varchar(30), type char(6));
create table scan_mode_reset_t2(id number(8), type char(5)) partition by range(id) interval(1)(partition p_0 values less than (1));

insert into scan_mode_reset_t0 values(1, 10, 'test1');
insert into scan_mode_reset_t0 values(2, 20, 'test2');
insert into scan_mode_reset_t0 values(3, 30, 'test3');
insert into scan_mode_reset_t1 values('view1', 'normal');
insert into scan_mode_reset_t1 values('view2', 'normal');
insert into scan_mode_reset_t1 values('view3', 'normal');
commit;

select  
  ref_5.name as c0, 
  ref_2.type as c2
from 
  ((scan_mode_reset_t0 as ref_0)
      full join ((scan_mode_reset_t1 as ref_1)
        inner join (scan_mode_reset_t2 as ref_2)
        on (ref_1.type = ref_1.name))
      on (true))
    cross join (scan_mode_reset_t0 as ref_5)
where ref_0.c_int > ref_5.id;

explain plan for
select  
  ref_5.name as c0, 
  ref_2.type as c2
from 
  ((scan_mode_reset_t0 as ref_0)
      full join ((scan_mode_reset_t1 as ref_1)
        inner join (scan_mode_reset_t2 as ref_2)
        on (ref_1.type = ref_1.name))
      on (true))
    cross join (scan_mode_reset_t0 as ref_5)
where ref_0.c_int > ref_5.id;

drop table scan_mode_reset_t0;
drop table scan_mode_reset_t1;
drop table scan_mode_reset_t2;

create table scan_mode_reset_t0(id int, c_int bigint, c_text varchar(30), c_date date, c_timestamp timestamp, c_bool boolean);
create index idx_scan_mode_int on scan_mode_reset_t0(id);
create index idx_scan_mode_bigint on scan_mode_reset_t0(c_int);
create index idx_scan_mode_string on scan_mode_reset_t0(c_text);
create index idx_scan_mode_date on scan_mode_reset_t0(c_date);
create index idx_scan_mode_timestmp on scan_mode_reset_t0(c_timestamp);
create index idx_scan_mode_bool on scan_mode_reset_t0(c_bool);

create table scan_mode_reset_t1(id int, c_int bigint, c_text varchar(30), c_date date, c_timestamp timestamp, c_clob clob, c_raw raw(10), c_bool boolean);
--int
explain select * from scan_mode_reset_t0 where id=1;
explain select * from scan_mode_reset_t0 where id=1111111111111111111111111111111;
explain select * from scan_mode_reset_t0 where id=:p1;
explain select * from scan_mode_reset_t0 where id is null;
explain select * from scan_mode_reset_t0 where id='1';
explain select * from scan_mode_reset_t0 where id=1.1;
explain select * from scan_mode_reset_t0 where id=true;
--bigint
explain select * from scan_mode_reset_t0 where c_int=1;
explain select * from scan_mode_reset_t0 where c_int=1111111111111111111111111111111;
explain select * from scan_mode_reset_t0 where c_int=:p1;
explain select * from scan_mode_reset_t0 where c_int is null;
explain select * from scan_mode_reset_t0 where c_int='1';
explain select * from scan_mode_reset_t0 where c_int=1.1;
explain select * from scan_mode_reset_t0 where c_int=true;
--string
explain select * from scan_mode_reset_t0 where c_text=1;
explain select * from scan_mode_reset_t0 where c_text=1111111111111111111111111111111;
explain select * from scan_mode_reset_t0 where c_text=:p1;
explain select * from scan_mode_reset_t0 where c_text is null;
explain select * from scan_mode_reset_t0 where c_text='1';
explain select * from scan_mode_reset_t0 where c_text=1.1;
explain select * from scan_mode_reset_t0 where c_text='111'::binary(4);
explain select * from scan_mode_reset_t0 where c_text='111'::raw(4);
explain select * from scan_mode_reset_t0 where c_text=sysdate;
explain select * from scan_mode_reset_t0 where c_text=true;
explain select * from scan_mode_reset_t0 where c_text=interval '21-2' year to month;
explain select * from scan_mode_reset_t0 where c_text=interval '2 3:04:11.333' day to second(3);
--date/timestamp
explain select * from scan_mode_reset_t0 where c_date='2020-11-11 11:22:33';
explain select * from scan_mode_reset_t0 where c_date=sysdate;
explain select * from scan_mode_reset_t0 where c_date=systimestamp;
explain select * from scan_mode_reset_t0 where c_timestamp='2020-11-11 11:22:33';
explain select * from scan_mode_reset_t0 where c_timestamp=sysdate;
explain select * from scan_mode_reset_t0 where c_timestamp=systimestamp;
--bool
explain select * from scan_mode_reset_t0 where c_bool=0;
explain select * from scan_mode_reset_t0 where c_bool=1;
explain select * from scan_mode_reset_t0 where c_bool=2;
explain select * from scan_mode_reset_t0 where c_bool=1111111111111111111111111111111;
explain select * from scan_mode_reset_t0 where c_bool=:p1;
explain select * from scan_mode_reset_t0 where c_bool is null;
explain select * from scan_mode_reset_t0 where c_bool='1';
explain select * from scan_mode_reset_t0 where c_bool='true';
explain select * from scan_mode_reset_t0 where c_bool='false';
explain select * from scan_mode_reset_t0 where c_bool='yes';
explain select * from scan_mode_reset_t0 where c_bool='no';
explain select * from scan_mode_reset_t0 where c_bool=1.1;
explain select * from scan_mode_reset_t0 where c_bool=true;

--join/exists
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.id=t1.id;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.id=t1.c_int;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.id=t1.c_text;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.id=t1.c_date;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.c_text=t1.id;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.c_text=t1.c_int;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.c_text=t1.c_text;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.c_text=t1.c_date;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.c_text=t1.c_timestamp;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.c_text=t1.c_clob;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.c_text=t1.c_raw;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.c_text=t1.c_bool;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.c_date=t1.c_date;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.c_date=t1.c_timestamp;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.c_date=t1.c_text;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.c_timestamp=t1.c_date;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.c_timestamp=t1.c_timestamp;
explain select count(1) from scan_mode_reset_t0 t0, scan_mode_reset_t1 t1 where t0.c_timestamp=t1.c_text;
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where c_text=t1.id);
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where c_text=t1.c_int);
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where c_text=t1.c_text);
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where c_text=t1.c_clob);
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where c_text=t1.c_date);
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where c_text=t1.c_timestamp);
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where c_text=t1.c_raw);
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where id = t1.id);
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where id = t1.c_int);
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where id = t1.c_text);
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where c_date = t1.c_date);
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where c_date = t1.c_timestamp);
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where c_date = t1.c_text);
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where c_timestamp = t1.c_date);
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where c_timestamp = t1.c_timestamp);
explain select * from scan_mode_reset_t1 t1 where exists(select 1 from scan_mode_reset_t0 where c_timestamp = t1.c_text);
drop table scan_mode_reset_t0;
drop table scan_mode_reset_t1;

--test bool
drop table if exists t_base_vchar;
CREATE TABLE t_base_vchar
(c_vchar1 int not null,
 c_vchar2 boolean,
 c_vchar3 boolean,
 c_vchar4 boolean,
 c_vchar5 boolean,
 c_vchar6 boolean
);

INSERT INTO t_base_vchar values (13,'0','0','0','0','0');
INSERT INTO t_base_vchar values (14,'1','1','1','1','1');
COMMIT;

create unique index idx_t_base_vchar_001 on t_base_vchar(c_vchar1);
CREATE INDEX idx_t_base_vchar_002 ON t_base_vchar(c_vchar2);
CREATE INDEX idx_t_base_vchar_003 ON t_base_vchar(NVL(c_vchar3,0));
CREATE INDEX idx_t_base_vchar_004 ON t_base_vchar(c_vchar4,c_vchar5);

select /*+ full(t_base_vchar) */c_vchar2,NVL(c_vchar3,0) from t_base_vchar where NVL(c_vchar3,0) >= -180::INTEGER and NVL(c_vchar3,0) <= 180::INTEGER order by 1,2;
explain select /*+ full(t_base_vchar) */c_vchar2,NVL(c_vchar3,0) from t_base_vchar where NVL(c_vchar3,0) >= -180::BIGINT and NVL(c_vchar3,0) <= 180::BIGINT order by 1,2;
select c_vchar2,NVL(c_vchar3,0) from t_base_vchar where NVL(c_vchar3,0) >= -180::INTEGER and NVL(c_vchar3,0) <= 180::INTEGER order by 1,2;
select c_vchar2,NVL(c_vchar3,0) from t_base_vchar where NVL(c_vchar3,0) >= -180::BIGINT and NVL(c_vchar3,0) <= 180::BIGINT order by 1,2;
drop table t_base_vchar;
