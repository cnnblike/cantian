DROP TABLE IF EXISTS T_GROUPBY_1;
CREATE TABLE T_GROUPBY_1 (F_INT1 INT, F_INT2 INT, F_CHAR CHAR(16), F_DATE DATE);

--EXPECT ERROR
SELECT F_INT1,SUM(F_INT2) FROM T_GROUPBY_1;
SELECT F_INT1 FROM T_GROUPBY_1 GROUP BY F_INT1,SUM(F_INT2);
SELECT F_INT1,SUM(F_INT2) FROM T_GROUPBY_1 GROUP BY 1,2;
SELECT F_INT1 FROM T_GROUPBY_1 GROUP BY 1,2;
SELECT * FROM T_GROUPBY_1 GROUP BY 1,2,3;
SELECT * FROM (SELECT * FROM T_GROUPBY_1) TT GROUP BY 1,2,3;
SELECT F_INT1,count(1),F_INT2 FROM T_GROUPBY_1 GROUP BY 1,2 ORDER BY 1 DESC;

SELECT F_INT1,F_INT2 FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2;
SELECT F_INT1 FROM T_GROUPBY_1 GROUP BY F_INT1;
SELECT F_CHAR FROM T_GROUPBY_1 GROUP BY F_CHAR;
SELECT F_DATE FROM T_GROUPBY_1 GROUP BY F_DATE;
SELECT F_INT1,F_INT2 FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2,F_CHAR,F_DATE;
SELECT F_INT1,F_INT2,F_CHAR,F_DATE FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2,F_CHAR,F_DATE;
SELECT F_DATE,F_INT2,F_CHAR,F_INT1 FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2,F_CHAR,F_DATE;
SELECT * FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2,F_CHAR,F_DATE;
SELECT F_INT1,F_INT2,F_CHAR,F_DATE FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2,F_CHAR,F_DATE ORDER BY F_DATE DESC;

INSERT INTO T_GROUPBY_1 VALUES(1,2,'A','2017-12-11 14:08:00');
INSERT INTO T_GROUPBY_1 VALUES(3,4,'C','2017-12-12 16:08:00');
INSERT INTO T_GROUPBY_1 VALUES(1,3,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_1 VALUES(1,3,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_1 VALUES(2,3,'B','2017-12-11 16:08:00');
INSERT INTO T_GROUPBY_1 VALUES(2,3,'B','2017-12-11 16:08:00');
COMMIT;

SELECT * FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2;
SELECT F_INT1+1 FROM T_GROUPBY_1 GROUP BY 1+F_INT2;

SELECT F_INT1+1 FROM T_GROUPBY_1 GROUP BY 1+F_INT1 ORDER BY 1;
SELECT F_INT1+1 FROM T_GROUPBY_1 GROUP BY 1;
SELECT F_INT1,F_INT2 FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2 ORDER BY 1,2;
SELECT F_INT1,F_INT2 FROM T_GROUPBY_1 GROUP BY 1,2;
SELECT F_INT1 FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY 1;
SELECT F_CHAR FROM T_GROUPBY_1 GROUP BY F_CHAR ORDER BY 1;
SELECT F_DATE FROM T_GROUPBY_1 GROUP BY F_DATE ORDER BY 1;
SELECT F_INT1,F_INT2 FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2,F_CHAR,F_DATE ORDER BY 1,2;
SELECT F_INT1,F_INT2,F_CHAR,F_DATE FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2,F_CHAR,F_DATE ORDER BY F_INT1,F_INT2,F_CHAR,F_DATE;
SELECT F_INT1,F_INT2,F_CHAR,F_DATE FROM T_GROUPBY_1 GROUP BY 1,2,3,4;
SELECT F_DATE,F_INT2,F_CHAR,F_INT1 FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2,F_CHAR,F_DATE ORDER BY F_INT1,F_INT2,F_CHAR,F_DATE;
SELECT F_DATE,F_INT2,F_CHAR,F_INT1 FROM T_GROUPBY_1 GROUP BY 4,2,3,1;
SELECT * FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2,F_CHAR,F_DATE ORDER BY F_INT1,F_INT2,F_CHAR,F_DATE;
SELECT * FROM T_GROUPBY_1 GROUP BY 1,2,3,4;
SELECT * FROM (SELECT * FROM T_GROUPBY_1) TT GROUP BY 1,2,3,4;
SELECT TT.*,T_GROUPBY_1.* FROM (SELECT * FROM T_GROUPBY_1) TT,T_GROUPBY_1 WHERE TT.F_INT1 = T_GROUPBY_1.F_INT1 GROUP BY 1,2,3,4,5,6,7,8;
SELECT F_INT1,F_INT2,F_CHAR,F_DATE FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2,F_CHAR,F_DATE ORDER BY F_DATE DESC;

SELECT count(*) FROM T_GROUPBY_1 ORDER BY 1;
SELECT F_INT1,count(1) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY F_INT1 DESC;
SELECT F_INT1,count(1) FROM T_GROUPBY_1 GROUP BY 1 ORDER BY F_INT1 DESC;
SELECT F_INT1,count(1)+F_INT1 FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY F_INT1 DESC;
SELECT F_INT1,count(1) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY COUNT(1) DESC;
SELECT F_INT1,count(1) FROM T_GROUPBY_1 GROUP BY 1 ORDER BY COUNT(1) DESC;
SELECT F_INT1,count(1) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY 1 DESC;
SELECT F_INT1,count(1) FROM T_GROUPBY_1 GROUP BY 1 ORDER BY 1 DESC;
SELECT F_INT1,F_INT2,count(1) FROM T_GROUPBY_1 GROUP BY 1,2 ORDER BY 1 DESC;
SELECT F_INT1,count(1),F_INT2 FROM T_GROUPBY_1 GROUP BY 1,3 ORDER BY 1 DESC;
SELECT F_INT1,avg(f_int2) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY F_INT1 DESC;
SELECT F_INT1,max(f_int2) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY F_INT1 DESC;
SELECT F_INT1,min(f_int2) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY F_INT1 DESC;
SELECT F_INT1,sum(f_int2) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY F_INT1 DESC;
SELECT F_INT1,min(f_int2) + max(f_int2) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY F_INT1 DESC;
SELECT F_INT1,min(f_int2) + max(f_int2) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY 2 DESC;
SELECT F_INT1,min(f_int2) + max(f_int2) FROM T_GROUPBY_1 GROUP BY 1 ORDER BY 2 DESC;
SELECT F_INT1,COUNT(*) FROM T_GROUPBY_1 WHERE F_INT1 > 1 GROUP BY F_INT1 ORDER BY F_INT1;
SELECT F_INT1,COUNT(*) FROM T_GROUPBY_1 WHERE F_INT1 > 100 GROUP BY F_INT1;

--TEST CONST
SELECT 1 FROM T_GROUPBY_1 GROUP BY T_GROUPBY_1.F_INT1;
SELECT CAST ( NULL AS INTEGER ) AS COL1 FROM T_GROUPBY_1 GROUP BY T_GROUPBY_1.F_INT1;
SELECT CAST ( 1 + 1 AS INTEGER ) AS COL1 FROM T_GROUPBY_1 GROUP BY T_GROUPBY_1.F_INT1;
SELECT CAST ( F_INT1 AS INTEGER ) AS COL1 FROM T_GROUPBY_1 GROUP BY T_GROUPBY_1.F_INT1 ORDER BY COL1;
SELECT CAST ( F_INT2 AS INTEGER ) AS COL1 FROM T_GROUPBY_1 GROUP BY T_GROUPBY_1.F_INT1;
SELECT CAST ( 1+F_INT2 AS INTEGER ) AS COL1 FROM T_GROUPBY_1 GROUP BY T_GROUPBY_1.F_INT1;
SELECT CAST ( 1+F_INT2 AS INTEGER ) AS COL1 FROM T_GROUPBY_1 GROUP BY 1;

CREATE INDEX IND1_T_GROUPBY_1 ON T_GROUPBY_1 (F_INT1);
CREATE INDEX IND2_T_GROUPBY_1 ON T_GROUPBY_1 (F_INT1,F_INT2);

SELECT F_INT1+1 FROM T_GROUPBY_1 GROUP BY 1+F_INT1 ORDER BY 1;
SELECT F_INT1+1 FROM T_GROUPBY_1 GROUP BY 1;
SELECT F_INT1,F_INT2 FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2;
SELECT F_INT1,F_INT2 FROM T_GROUPBY_1 GROUP BY 18,F_INT1,F_INT2;
SELECT F_INT1,F_INT2 FROM T_GROUPBY_1 GROUP BY 1,2;
SELECT F_INT1 FROM T_GROUPBY_1 GROUP BY F_INT1;
SELECT F_INT1 FROM T_GROUPBY_1 GROUP BY F_INT1,10;
SELECT F_CHAR FROM T_GROUPBY_1 GROUP BY F_CHAR ORDER BY 1;
SELECT F_DATE FROM T_GROUPBY_1 GROUP BY F_DATE ORDER BY 1;
SELECT F_INT1,F_INT2 FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2,F_CHAR,F_DATE ORDER BY F_INT1,F_INT2,F_CHAR,F_DATE;
SELECT F_INT1,F_INT2,F_CHAR,F_DATE FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2,F_CHAR,F_DATE ORDER BY F_INT1,F_INT2,F_CHAR,F_DATE;
SELECT F_INT1,F_INT2,F_CHAR,F_DATE FROM T_GROUPBY_1 GROUP BY 1,2,3,4;
SELECT F_DATE,F_INT2,F_CHAR,F_INT1 FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2,F_CHAR,F_DATE ORDER BY F_INT1,F_INT2,F_CHAR,F_DATE;
SELECT F_DATE,F_INT2,F_CHAR,F_INT1 FROM T_GROUPBY_1 GROUP BY 4,2,3,1;
SELECT * FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2,F_CHAR,F_DATE ORDER BY F_INT1,F_INT2,F_CHAR,F_DATE;
SELECT * FROM T_GROUPBY_1 GROUP BY 1,2,3,4;
SELECT * FROM (SELECT * FROM T_GROUPBY_1) TT GROUP BY 1,2,3,4;
SELECT TT.*,T_GROUPBY_1.* FROM (SELECT * FROM T_GROUPBY_1) TT,T_GROUPBY_1 WHERE TT.F_INT1 = T_GROUPBY_1.F_INT1 GROUP BY 1,2,3,4,5,6,7,8;
SELECT F_INT1,F_INT2,F_CHAR,F_DATE FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2,F_CHAR,F_DATE ORDER BY F_DATE DESC;

SELECT count(*) FROM T_GROUPBY_1 ORDER BY 1;
SELECT F_INT1,count(1) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY F_INT1 DESC;
SELECT F_INT1,count(1) FROM T_GROUPBY_1 GROUP BY 1 ORDER BY F_INT1 DESC;
SELECT F_INT1,count(1)+F_INT1 FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY F_INT1 DESC;
SELECT F_INT1,count(1) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY COUNT(1) DESC;
SELECT F_INT1,count(1) FROM T_GROUPBY_1 GROUP BY 1 ORDER BY COUNT(1) DESC;
SELECT F_INT1,count(1) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY 1 DESC;
SELECT F_INT1,count(1) FROM T_GROUPBY_1 GROUP BY 1 ORDER BY 1 DESC;
SELECT F_INT1,F_INT2,count(1) FROM T_GROUPBY_1 GROUP BY 1,2 ORDER BY 1 DESC;
SELECT F_INT1,count(1),F_INT2 FROM T_GROUPBY_1 GROUP BY 1,3 ORDER BY 1 DESC;
SELECT F_INT1,avg(f_int2) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY F_INT1 DESC;
SELECT F_INT1,max(f_int2) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY F_INT1 DESC;
SELECT F_INT1,min(f_int2) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY F_INT1 DESC;
SELECT F_INT1,sum(f_int2) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY F_INT1 DESC;
SELECT F_INT1,min(f_int2) + max(f_int2) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY F_INT1 DESC;
SELECT F_INT1,min(f_int2) + max(f_int2) FROM T_GROUPBY_1 GROUP BY F_INT1 ORDER BY 2 DESC;
SELECT F_INT1,min(f_int2) + max(f_int2) FROM T_GROUPBY_1 GROUP BY 1 ORDER BY 2 DESC;
SELECT F_INT1,COUNT(*) FROM T_GROUPBY_1 WHERE F_INT1 > 1 GROUP BY F_INT1 ORDER BY F_INT1;
SELECT F_INT1,COUNT(*) FROM T_GROUPBY_1 WHERE F_INT1 > 100 GROUP BY F_INT1;

--TEST CONST
SELECT 1 FROM T_GROUPBY_1 GROUP BY T_GROUPBY_1.F_INT1;
SELECT CAST ( NULL AS INTEGER ) AS COL1 FROM T_GROUPBY_1 GROUP BY T_GROUPBY_1.F_INT1;
SELECT CAST ( 1 + 1 AS INTEGER ) AS COL1 FROM T_GROUPBY_1 GROUP BY T_GROUPBY_1.F_INT1;
SELECT CAST ( F_INT1 AS INTEGER ) AS COL1 FROM T_GROUPBY_1 GROUP BY T_GROUPBY_1.F_INT1 ORDER BY COL1;
SELECT CAST ( F_INT2 AS INTEGER ) AS COL1 FROM T_GROUPBY_1 GROUP BY T_GROUPBY_1.F_INT1;
SELECT CAST ( 1+F_INT2 AS INTEGER ) AS COL1 FROM T_GROUPBY_1 GROUP BY T_GROUPBY_1.F_INT1;
SELECT CAST ( 1+F_INT2 AS INTEGER ) AS COL1 FROM T_GROUPBY_1 GROUP BY 1;

--T_GROUPBY_2
DROP TABLE IF EXISTS T_GROUPBY_2;
CREATE TABLE T_GROUPBY_2 (F_INT1 INT, F_INT2 INT, F_CHAR CHAR(16), F_DATE DATE);

INSERT INTO T_GROUPBY_2 VALUES(NULL,2,'A','2017-12-11 14:08:00');
INSERT INTO T_GROUPBY_2 VALUES(3,4,'C','2017-12-12 16:08:00');
INSERT INTO T_GROUPBY_2 VALUES(NULL,3,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_2 VALUES(NULL,3,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_2 VALUES(2,3,'B','2017-12-11 16:08:00');
INSERT INTO T_GROUPBY_2 VALUES(2,3,'B','2017-12-11 16:08:00');
COMMIT;

SELECT F_INT1 FROM T_GROUPBY_2 GROUP BY F_INT1 ORDER BY F_INT1;
SELECT F_INT1,F_INT2 FROM T_GROUPBY_2 GROUP BY F_INT1,F_INT2 ORDER BY 1,2;
SELECT DISTINCT F_INT1 FROM T_GROUPBY_2 GROUP BY F_INT1 ORDER BY F_INT1;
SELECT DISTINCT F_INT1 FROM T_GROUPBY_2 GROUP BY 1;

--test segment count
DELETE FROM T_GROUPBY_1;
DELETE FROM T_GROUPBY_2;
INSERT INTO T_GROUPBY_1 VALUES(1,1,'A','2017-12-11 14:08:00');
INSERT INTO T_GROUPBY_1 VALUES(2,1,'C','2017-12-12 16:08:00');
INSERT INTO T_GROUPBY_1 VALUES(3,1,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_1 VALUES(4,1,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_1 VALUES(5,1,'B','2017-12-11 16:08:00');
INSERT INTO T_GROUPBY_1 VALUES(6,1,'B','2017-12-11 16:08:00');
INSERT INTO T_GROUPBY_1 VALUES(7,1,'A','2017-12-11 14:08:00');
INSERT INTO T_GROUPBY_1 VALUES(8,1,'C','2017-12-12 16:08:00');
INSERT INTO T_GROUPBY_1 VALUES(9,1,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_1 VALUES(10,1,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_1 VALUES(11,1,'B','2017-12-11 16:08:00');
INSERT INTO T_GROUPBY_1 VALUES(12,1,'B','2017-12-11 16:08:00');
INSERT INTO T_GROUPBY_1 VALUES(13,1,'A','2017-12-11 14:08:00');
INSERT INTO T_GROUPBY_1 VALUES(14,1,'C','2017-12-12 16:08:00');
INSERT INTO T_GROUPBY_1 VALUES(15,1,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_1 VALUES(16,1,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_1 VALUES(17,1,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_1 VALUES(1,1,'B','2017-12-11 16:08:00');

INSERT INTO T_GROUPBY_2 VALUES(1,2,'A','2017-12-11 14:08:00');
INSERT INTO T_GROUPBY_2 VALUES(2,2,'C','2017-12-12 16:08:00');
INSERT INTO T_GROUPBY_2 VALUES(3,2,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_2 VALUES(4,2,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_2 VALUES(5,2,'B','2017-12-11 16:08:00');
INSERT INTO T_GROUPBY_2 VALUES(6,2,'B','2017-12-11 16:08:00');
INSERT INTO T_GROUPBY_2 VALUES(7,2,'A','2017-12-11 14:08:00');
INSERT INTO T_GROUPBY_2 VALUES(8,2,'C','2017-12-12 16:08:00');
INSERT INTO T_GROUPBY_2 VALUES(9,2,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_2 VALUES(10,2,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_2 VALUES(11,2,'B','2017-12-11 16:08:00');
INSERT INTO T_GROUPBY_2 VALUES(12,2,'B','2017-12-11 16:08:00');
INSERT INTO T_GROUPBY_2 VALUES(13,2,'A','2017-12-11 14:08:00');
INSERT INTO T_GROUPBY_2 VALUES(14,2,'C','2017-12-12 16:08:00');
INSERT INTO T_GROUPBY_2 VALUES(15,2,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_2 VALUES(16,2,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_2 VALUES(17,2,'A','2017-12-11 14:18:00');
INSERT INTO T_GROUPBY_2 VALUES(1,2,'B','2017-12-11 16:08:00');

SELECT T1.F_INT1,T1.F_INT2,T2.F_INT1,T2.F_INT2 FROM (SELECT F_INT1,F_INT2 FROM T_GROUPBY_1 GROUP BY F_INT1,F_INT2) T1,(SELECT F_INT1,F_INT2 FROM T_GROUPBY_2 GROUP BY F_INT1,F_INT2) T2 WHERE T1.F_INT1 = T2.F_INT1 ORDER BY T1.F_INT1;

-- DTS2018021108356
select * from T_GROUPBY_1;
select 1, count(F_INT1) from T_GROUPBY_1;
select 1+2, count(F_INT1) from T_GROUPBY_1;

-- DTS2018052802846
select add_months(to_char(f_int1), count(f_int1)) from T_GROUPBY_1;
select substr(f_int1, 1, min(f_int1)) from T_GROUPBY_1;
select f_int1 + count(f_int1) from T_GROUPBY_1;
select f_int1 || count(f_int1) from T_GROUPBY_1;
select case f_int1 when 1 then 1 else count(f_int1) end from T_GROUPBY_1;
select case 1 when f_int1 then 1 else count(f_int1) end from T_GROUPBY_1;
select case 1 when 1 then f_int1 else count(f_int1) end from T_GROUPBY_1;
select case 1 when 1 then count(f_int1) else f_int1 end from T_GROUPBY_1;
select case when 1=1 then f_int1 else count(f_int1) end from T_GROUPBY_1;
select case when 1=1 then count(f_int1) else f_int1 end from T_GROUPBY_1;

-- DTS202007310KFDQYP1100
select  
    instr(
    cast(count(cast(null as VARCHAR(50))) as VARCHAR(50)),
    cast(
      MIN(
        cast(2 as VARCHAR(50))) over (partition by subq_0.c0,subq_0.c0 order by subq_0.c0) as VARCHAR(50))) as c0, 
  1 as c1
from 
  (select  
        ref_0.F_INT1 as c0
      from 
        T_GROUPBY_1 ref_0
      ) subq_0
where EMPTY_CLOB() is NULL;

select lnnvl(sum(f_int2) > f_int1) from T_GROUPBY_1;
select array[sum(f_int1),f_int2,3] from T_GROUPBY_1;

drop table T_GROUPBY_1;
drop table T_GROUPBY_2;


drop table if exists T_CURRENT_ALARM;
CREATE TABLE IF NOT EXISTS T_CURRENT_ALARM (
CSN int NOT NULL, 
COUNT int NULL, 
CLEARED int NULL,
CLEARUSER varchar(32) NULL,
CLEARUTC bigint NULL,
CLEARDST int NOT NULL, 
CLEARCATEGORY int NULL,
ACKED int NULL,
ACKUSER varchar(32) NULL, 
ACKUTC bigint NULL, 
OCCURUTC bigint NOT NULL,
OCCURDST int NOT NULL,
ARRIVEUTC bigint NULL,
LATESTOCCURUTC bigint NULL,
MATCHKEY varchar(512) NOT NULL, 
MERGEKEY varchar(512) NOT NULL,
MEDN varchar(36) NULL,
MENAME varchar(256) NULL, 
METYPE varchar(64) NULL,
ORIGINSYSTEMTYPE varchar(64) NOT NULL,
MOI varchar(750) NOT NULL,
BACKUPSTATUS	int NULL, 
IDENTIFIER int NULL,
SUBCSN bigint NULL,
EVENTTYPE int NULL,
ALARMID varchar(128) NOT NULL, 
ALARMNAME varchar(256) NULL,
SEVERITY int NULL,
PROBABLECAUSE varchar(256) NULL, 
REASONID int NULL,
SERVICEAFFECTEDTYPE int NULL,
AFFECTEDSERVICE varchar(512) NULL, 
ROOTCSN varchar(256) NULL,
SUBROOTCSN varchar(256) NULL,
ADDITIONALINFORMATION varchar(750) NULL, 
USERDATA varchar(1024) NULL,
COMMENT varchar(512) NULL,
SPECIALALARMSTATUS int NULL, 
CORRGROUPID varchar(256) NULL,
TENANT varchar(512) NULL,
TENANTID varchar(512) NULL, 
ORIGINSYSTEMNAME varchar(255) NOT NULL,
REGIONID varchar(36) NULL,
REGION varchar(128) NOT NULL,
MANUFACTURER varchar(32) NULL, 
DOMAIN varchar(16) NULL,
MOC varchar(64) NULL,
MECATEGORY varchar(64) NOT NULL, 
VERSION bigint NULL,
CHANGEFLAG int NULL,
LOCATION varchar(256) NULL, 
WORKORDERID varchar(64) NULL,
WORKORDERSENDER varchar(32) NULL,
WORKORDERUTC bigint NULL, 
WORKORDERSTATUS varchar(32) NULL,
NATIVEMEDN varchar(256) NOT NULL, 
ADDRESS varchar(256) NULL, 
MERGEGROUPID int NULL, 
CLEARTIME bigint NOT NULL, 
OCCURTIME bigint NOT NULL,
LATESTOCCURTIME bigint NOT NULL, 
LATESTOCCURDST int NULL, 
PRODUCTNAME varchar(64) NOT NULL, 
ORIGINSYSTEMID varchar(36) NULL, 
INVALIDATED int NULL,
MERGED int NULL,
DCID varchar(64) NULL,
DCNAME varchar(128) NULL,
SVCGROUPID varchar(64) NULL,
OWNERUID varchar(32) NULL, 
ENDUTC bigint NULL,  
MODN varchar(256) NULL, 
MONAME varchar(256) NULL,  
LOGICALREGIONID varchar(36) NULL, 
AZONEID varchar(36) NULL, 
RESPOOLID varchar(36) NULL, 
RESGROUPID varchar(36) NULL, 
STREXT1 varchar(256) NULL, 
STREXT2 varchar(256) NULL, 
STREXT3 varchar(256) NULL, 
STREXT4 varchar(256) NULL, 
STREXT5 varchar(256) NULL,  
STREXT6 varchar(256) NULL, 
STREXT7 varchar(256) NULL, 
STREXT8 varchar(256) NULL, 
STREXT9 varchar(256) NULL, 
STREXT10 varchar(256) NULL,  
STREXT11 varchar(256) NULL, 
STREXT12 varchar(256) NULL, 
STREXT13 varchar(256) NULL, 
STREXT14 varchar(256) NULL, 
STREXT15 varchar(256) NULL,  
STREXT16 varchar(256) NULL, 
STREXT17 varchar(256) NULL, 
STREXT18 varchar(256) NULL, 
STREXT19 varchar(256) NULL, 
STREXT20 varchar(256) NULL,  
STREXT21 varchar(256) NULL, 
STREXT22 varchar(256) NULL, 
STREXT23 varchar(256) NULL, 
STREXT24 varchar(256) NULL, 
STREXT25 varchar(256) NULL,  
STREXT26 varchar(256) NULL, 
STREXT27 varchar(256) NULL, 
STREXT28 varchar(256) NULL, 
STREXT29 varchar(256) NULL, 
STREXT40 varchar(256) NULL,  
STREXT41 varchar(256) NULL, 
STREXT42 varchar(256) NULL, 
STREXT43 varchar(256) NULL, 
STREXT44 varchar(256) NULL, 
STREXT45 varchar(256) NULL,  
STREXT46 varchar(256) NULL, 
STREXT47 varchar(256) NULL, 
STREXT48 varchar(256) NULL, 
STREXT49 varchar(256) NULL,  
NUMEXT1 int NULL, 
NUMEXT2 int NULL, 
NUMEXT3 int NULL, 
NUMEXT4 int NULL, 
NUMEXT5 int NULL,  
NUMEXT6 int NULL, 
NUMEXT7 int NULL, 
NUMEXT8 int NULL, 
NUMEXT9 int NULL, 
NUMEXT10 int NULL,  
SHORTEXT1 int NULL, 
SHORTEXT2 int NULL, 
SHORTEXT3 int NULL, 
SHORTEXT4 int NULL, 
SHORTEXT5 int NULL,  
SHORTEXT6 int NULL, 
SHORTEXT7 int NULL, 
SHORTEXT8 int NULL, 
SHORTEXT9 int NULL, 
SHORTEXT10 int NULL,  
INT64EXT1 bigint NULL, 
INT64EXT2 bigint NULL, 
INT64EXT3 bigint NULL, 
INT64EXT4 bigint NULL, 
INT64EXT5 bigint NULL,  
INT64EXT6 bigint NULL, 
INT64EXT7 bigint NULL, 
INT64EXT8 bigint NULL, 
INT64EXT9 bigint NULL, 
INT64EXT10 bigint NULL,  
NUMEXT11 int NULL, 
NUMEXT12 int NULL, 
NUMEXT13 int NULL, 
NUMEXT14 int NULL, 
NUMEXT15 int NULL,  
NUMEXT16 int NULL, 
NUMEXT17 int NULL, 
NUMEXT18 int NULL, 
NUMEXT19 int NULL, 
NUMEXT20 int NULL,  
SHORTEXT11 int NULL, 
SHORTEXT12 int NULL, 
SHORTEXT13 int NULL, 
SHORTEXT14 int NULL, 
SHORTEXT15 int NULL,  
SHORTEXT16 int NULL, 
SHORTEXT17 int NULL, 
SHORTEXT18 int NULL, 
SHORTEXT19 int NULL, 
SHORTEXT20 int NULL,  
COMMENTUTC bigint NULL, 
COMMENTUSER varchar(32) NULL,  
PRIMARY KEY(CSN));

SELECT CASE  WHEN LATESTOCCURUTC>=1531065829507 AND LATESTOCCURUTC<1534244229508 THEN 0 ELSE -1 END , COUNT(1) FROM T_CURRENT_ALARM  GROUP BY (CASE  WHEN LATESTOCCURUTC>=1531065829507 AND LATESTOCCURUTC<1534244229507 THEN 0 ELSE -1 END);  
SELECT CASE  WHEN LATESTOCCURUTC>=1531065829507 AND LATESTOCCURUTC<1534244229507 THEN 0 END , COUNT(1) FROM T_CURRENT_ALARM  GROUP BY (CASE  WHEN LATESTOCCURUTC>=1531065829507 AND LATESTOCCURUTC<1534244229507 THEN 0 ELSE -1 END);  
SELECT CASE  WHEN LATESTOCCURUTC>=1531065829507 THEN 0  ELSE -1 END , COUNT(1) FROM T_CURRENT_ALARM  GROUP BY (CASE  WHEN LATESTOCCURUTC>=1531065829507 AND LATESTOCCURUTC<1534244229507 THEN 0 ELSE -1 END);  
SELECT CASE  WHEN LATESTOCCURUTC>=1531065829507 AND LATESTOCCURUTC<1534244229507 THEN (case CSN when 10 then 10 when 20 then 20 else 100 end) ELSE -1 END , COUNT(1) FROM T_CURRENT_ALARM  GROUP BY (CASE  WHEN LATESTOCCURUTC>=1531065829507 AND LATESTOCCURUTC<1534244229507 THEN 0 ELSE -1 END);  

SELECT 
CASE  WHEN 
    LATESTOCCURUTC>=1531065829507 
    AND LATESTOCCURUTC<1534244229507 
THEN 
    0 
ELSE 
    -1 
END ,

COUNT(1) 

FROM T_CURRENT_ALARM  
GROUP BY (
CASE  WHEN 
    LATESTOCCURUTC>=1531065829507 
    AND
    LATESTOCCURUTC<1534244229507 THEN 0 ELSE -1 END
);

-- DTS2018082406903
drop table if exists T_RANCC_MBTSBRDTEMP;
create table T_RANCC_MBTSBRDTEMP(f1 int, f2 int);
insert into T_RANCC_MBTSBRDTEMP values(10, 11);
create or replace procedure sp_Chk_MBTSSingleConfig(v_PlanID in number)
as 
    v_Temp_1 NUMBER(10, 0);
begin
    insert into T_RANCC_MBTSBRDTEMP(f1, f2) select f1, v_PlanID from T_RANCC_MBTSBRDTEMP group by f1;
end;
/
call sp_Chk_MBTSSingleConfig(11);

CREATE OR REPLACE FUNCTION sp_Chk_MBTSSingleConfig_func return varchar2
IS
 cunt int := 0;
 Begin
 select count(*) into cunt from dual;
 IF SQL % FOUND
  then
 return cunt;
 end if;
 End sp_Chk_MBTSSingleConfig_func;
/
select f1, 12, sp_Chk_MBTSSingleConfig_func() from T_RANCC_MBTSBRDTEMP group by f1;

drop table T_CURRENT_ALARM;
drop table T_RANCC_MBTSBRDTEMP;

drop table if exists customer;
CREATE TABLE customer
(CUSTOMER_ID integer,
 CUST_FIRST_NAME  VARCHAR(20) NOT NULL,
 CUST_LAST_NAME   VARCHAR(20) NOT NULL,
 CREDIT_LIMIT INTEGER
);
select t1.CUSTOMER_ID,t1.CUST_FIRST_NAME t1.CREDIT_LIMIT from customer t1;

drop table if exists zsharding_tbl;
create table zsharding_tbl(
c_id int, c_int int, c_integer integer, c_bool bool, c_boolean boolean, c_bigint bigint,
c_real real, c_double double,
c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
c_date date, c_datetime datetime, c_timestamp timestamp
);
select C_REAL, ASCII(ASCII('=')) from zsharding_tbl group by C_REAL,ASCII(ASCII('='));
drop table if exists customer;
drop table if exists zsharding_tbl;

create or replace function group_by_1(a int) return int
is
begin
return a;
end;
/

drop table if exists  group_by_t1;
create table group_by_t1(a int,b int);
insert into group_by_t1 values(1,2);

set serveroutput on;
DECLARE
bonus int;
BEGIN
SELECT group_by_1(b) into bonus from group_by_t1 group by b;
dbe_output.print_line('bonus = ' || TO_CHAR(bonus));
end;
/
set serveroutput off;

DROP TABLE IF EXISTS T_GROUP_1;
CREATE TABLE T_GROUP_1(F_INT1 INT, F_INT2 INT, F_VARCHAR1 VARCHAR(4000));
INSERT INTO T_GROUP_1 VALUES(1,2,lpad('A',3000,'A'));
INSERT INTO T_GROUP_1 SELECT * FROM T_GROUP_1;
INSERT INTO T_GROUP_1 SELECT * FROM T_GROUP_1;
INSERT INTO T_GROUP_1 SELECT * FROM T_GROUP_1;
INSERT INTO T_GROUP_1 SELECT * FROM T_GROUP_1;
INSERT INTO T_GROUP_1 SELECT * FROM T_GROUP_1;
--EXPECT ERROR: EXCEED MAX ROW SIZE
SELECT GROUP_CONCAT(F_VARCHAR1) FROM T_GROUP_1 GROUP BY F_INT1;
DROP TABLE T_GROUP_1;


--DTS2019011410545
drop table  if exists table_group_concat;
drop table  if exists table_group_concat_1;
create table table_group_concat (c1 char, c2 char(1024), c3 varchar(1024), c4 clob);
insert into table_group_concat select 'a', 'a', 'a', 'a' from SYS_COLUMNS limit 256;
create table table_group_concat_1(c1,c2,c3,c4) as select a.* from table_group_concat a, table_group_concat b;
commit;
select length(group_concat(c1)) from table_group_concat_1;
select length(group_concat(c1)), length(group_concat(c1)) from (select * from table_group_concat_1 limit 20000) group by c1;
select length(group_concat(c1)), length(group_concat(c1)), length(group_concat(c1)), length(group_concat(c1)), length(group_concat(c1)) from (select * from table_group_concat_1 limit 30000) group by c1;
drop table table_group_concat_1;
drop table table_group_concat;

--support group_concat with order by
drop table if exists group_by_t2;
create table group_by_t2(f_int1 int, f_varchar1 varchar(4000), f_varchar2 varchar(4000));
insert into group_by_t2 values(1, lpad('A', 3000, 'A'), lpad('A', 3000, 'A'));
insert into group_by_t2 values(2, lpad('A', 3000, 'B'), lpad('B', 3000, 'A'));
insert into group_by_t2 values(3, lpad('A', 3000, 'C'), lpad('C', 3000, 'A'));
insert into group_by_t2 values(4, lpad('A', 3000, 'D'), lpad('D', 3000, 'A'));
insert into group_by_t2 select f_int1,f_varchar1||'1',f_varchar2||'4' from group_by_t2;
insert into group_by_t2 select f_int1,f_varchar1||'1',f_varchar2||'2' from group_by_t2;
insert into group_by_t2 select f_int1,f_varchar1||'2',f_varchar2||'3' from group_by_t2;
insert into group_by_t2 select f_int1,f_varchar1||'2',f_varchar2||'1' from group_by_t2;
commit;

select f_int1, group_concat(f_varchar1 order by f_varchar1,f_varchar2) from group_by_t2 group by f_int1 order by f_int1;
select group_concat(f_varchar1 order by f_varchar1,f_varchar2) from group_by_t2 where f_int1 = 1;
delete from group_by_t2;
insert into group_by_t2 values(1, lpad('A', 4000, 'A'), lpad('B', 4000, 'B'));
commit;
select f_int1, lengthb(group_concat(f_varchar1,f_varchar2,f_varchar1,f_varchar2,f_varchar1,f_varchar2,f_varchar1,f_varchar2,f_varchar1,f_varchar2,f_varchar1,f_varchar2,f_varchar1,f_varchar2,f_varchar1,f_varchar2)) from group_by_t2 group by f_int1;
drop table group_by_t2;

--group by coredump
drop table if exists hj_t1;
create table hj_t1(f1 int, f2 int, f3 int, F4 VARCHAR(100));
drop procedure if exists p_hj_insert_data;
create procedure p_hj_insert_data
is 
i number;
begin
i := 0;
for i in 1..3000 loop
  insert into hj_t1(f1,f2,f3,f4) values(i, i+1, 1, 'aaa' || i%10);
  insert into hj_t1(f1,f2,f3,f4) values(i, i+2, 2, 'bbb' || i%11);
  insert into hj_t1(f1,f2,f3,f4) values(i, i+3, 3, 'ccc' || i%12);
end loop;
commit;
end p_hj_insert_data;
/
call p_hj_insert_data();
select f1,group_concat(f2 order by f2) from hj_t1 group by f1 order by f1 limit 10;
select f3, count(f1), count(distinct f1), approx_count_distinct(f1), count(f2), count(distinct f2), approx_count_distinct(f2), count(distinct f4), approx_count_distinct(f4) from hj_t1 group by f3;
drop procedure p_hj_insert_data;

--special treatment for binary
drop table if exists t_group_concat_011;
create table t_group_concat_011(id int,c_binary binary(50));
insert into t_group_concat_011 values(1,'1010101111111111111111111111111111111111111111'),(1,'10101011111111111111111111111111111111111111'),(2,'10101011111111111111111111111111111111111111'),(2,null); 
select id,group_concat(c_binary order by 1) t1 from t_group_concat_011 group by id order by id,t1;
select group_concat(c_binary order by 1) t1 from t_group_concat_011;
drop table t_group_concat_011;

--DTS2019021405817 
drop table if exists ORDERS;
CREATE TABLE ORDERS  ( O_ORDERKEY       INTEGER NOT NULL,
                           O_CUSTKEY        INTEGER NOT NULL,
                           O_ORDERSTATUS    CHAR(1) NOT NULL,
                           O_TOTALPRICE     DECIMAL(15,2) NOT NULL,
                           O_ORDERDATE      DATE NOT NULL,
                           O_ORDERPRIORITY  CHAR(15) NOT NULL,
                           O_CLERK          CHAR(15) NOT NULL,
                           O_SHIPPRIORITY   INTEGER NOT NULL,
                           O_COMMENT        VARCHAR(79) NOT NULL);
load data infile './data/orders.csv' into table orders COLUMNS TERMINATED BY '|';
select group_concat(O_ORDERKEY,O_CUSTKEY SEPARATOR '---------->>>>>>>>>>'), COUNT(1) from orders group by O_COMMENT HAVING COUNT(1) > 1;
select group_concat(O_ORDERKEY,O_CUSTKEY order by O_ORDERKEY ASC SEPARATOR '---------->>>>>>>>>>'), COUNT(1) from orders group by O_COMMENT HAVING COUNT(1) > 1;
select count(distinct O_ORDERKEY), count(distinct O_CUSTKEY) from orders;
select approx_count_distinct(O_ORDERKEY), approx_count_distinct(distinct O_CUSTKEY) from orders;
select /*+parallel(4)*/ approx_count_distinct(O_ORDERKEY), approx_count_distinct(distinct O_CUSTKEY) from orders;
drop table ORDERS;

--group by cube
DROP TABLE if exists dimension_tab;
CREATE TABLE dimension_tab (
  fact_1_id   NUMBER NOT NULL,
  fact_2_id   NUMBER ,
  fact_3_id   NUMBER ,
  fact_4_id   NUMBER ,
  sales_value NUMBER(10,2) 
);

SELECT fact_1_id,
       fact_2_id,
       SUM(sales_value) AS sales_value,
       GROUPING(fact_1_id) AS f1g,
       GROUPING_ID(fact_1_id, fact_2_id, sum(sales_value)) AS grouping_id
FROM  dimension_tab 
GROUP BY ROLLUP((fact_1_id), (fact_2_id, fact_3_id))
ORDER BY fact_1_id, fact_2_id, GROUPING(fact_1_id);

SELECT fact_1_id,
       fact_2_id,
       SUM(sales_value) AS sales_value,
       GROUPING(1) AS f1g,
       GROUPING_ID(fact_1_id, fact_2_id) AS grouping_id
FROM  dimension_tab 
GROUP BY ROLLUP((fact_1_id), (fact_2_id, fact_3_id))
ORDER BY fact_1_id, fact_2_id,sales_value;
--DTS2019121805477
drop table if exists parallelism_selct_t001;
create table parallelism_selct_t001
(
c1 INT,
c2 INTEGER,
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
c14 int[]
);
begin
	for i in 1 .. 100 loop
		insert into parallelism_selct_t001 values(i,i+i,-(i+i),i*i,i/i,i*(i+1),i*(i-1),1.1+i,2.2+i,3.3+i,i||i,i||i-1,i||i||i,array[1,2,3]);
	end loop;
end;
/
create or replace function parallelism_selct_p1(a number[],n int) return number
as
b number;
begin
	b:=a[3]-n;
	return b;
end;
/
select parallelism_selct_p1(c14,9),array_agg(c1) from parallelism_selct_t001 where  parallelism_selct_p1(c14,-4)>0 union all select parallelism_selct_p1(c14,7),array_agg(c3) from parallelism_selct_t001 where parallelism_selct_p1(c14,-9)>0;
drop table parallelism_selct_t001;

-- the num of expr in cube cannot exceed 10
drop table if exists group_by_cube_t1;
drop table if exists group_by_cube_t2;

create table group_by_cube_t1(col_1 number(8));
insert into group_by_cube_t1 values(1);
commit;

create table group_by_cube_t2
(
    id number(8),
    col_1 number(8),
    col_2 number(8),
    col_3 number(8),
    col_4 number(8),
    col_5 number(8),
    col_6 number(8),
    col_7 number(8),
    col_8 number(8),
    col_9 number(8),
    col_10 number(8),
    col_11 number(8),
    col_12 number(8)
);

insert into group_by_cube_t2 values(1,1,1,1,1,1,1,1,1,1,1,1,1);
insert into group_by_cube_t2 values(2,2,2,2,2,2,2,2,2,2,2,2,2);
commit;

select distinct 
    count((select max(col_1) from group_by_cube_t1)) as c0, 
    ref_0.col_1 as c1, 
    min(ref_0.col_2) over (partition by ref_0.col_3 order by ref_0.col_4 desc nulls first) as c2
from
    group_by_cube_t2 ref_0
where id < 10
group by cube(col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12);

drop table group_by_cube_t1;
drop table group_by_cube_t2;

-- DTS2020120702LU7EP1300
drop table if exists sort_group_ancestor_t1;
drop table if exists sort_group_ancestor_t2;

create table sort_group_ancestor_t1(c1 number(8), c2 number(8));
insert into sort_group_ancestor_t1 values(1,2);
insert into sort_group_ancestor_t1 values(2,3);
insert into sort_group_ancestor_t1 values(3,4);
commit;
create table sort_group_ancestor_t2(c1 number(8), c2 number(8), c3 number(8), c4 number(8));
insert into sort_group_ancestor_t2 values(1,2,3,4);
insert into sort_group_ancestor_t2 values(2,3,4,5);
insert into sort_group_ancestor_t2 values(3,4,5,6);
commit;


select
    ref_0.c4 as col_0,
    (select min(ref_1.c1) as c1 from sort_group_ancestor_t1 as ref_1 group by ref_0.c4 order by ref_0.c4 asc limit 1) as col_1
from
    sort_group_ancestor_t2 as ref_0
group by
    rollup(
        ref_0.c1,
        ref_0.c2,
        ref_0.c3,
        ref_0.c4
    )
order by 1;

drop table sort_group_ancestor_t1;
drop table sort_group_ancestor_t2;

CREATE TABLE T_BOOL_GROUPBY(T1 INT,T2 BOOL);
INSERT INTO T_BOOL_GROUPBY VALUES(1,0);
INSERT INTO T_BOOL_GROUPBY VALUES(1,1);
SELECT MAX(T2) FROM T_BOOL_GROUPBY GROUP BY T1;
SELECT MIN(T2) FROM T_BOOL_GROUPBY GROUP BY T1;
DROP TABLE T_BOOL_GROUPBY;