drop table if exists t_aggr_1;
create table t_aggr_1(f0 int, f1 bigint, f2 double, f3 number(20,10), f4 date, f5 timestamp, f6 char(100), f7 varchar(100), f8 binary(100), f9 clob, f10 blob);

select count(f0), sum(f0), max(f0), min(f0), avg(f0) from t_aggr_1;

-- DTS2019012410194
select max(f0) + ROWID from t_aggr_1;
select max(f0) - (min(f0) % ROWID) from t_aggr_1;

-- int/bigint/real/decimal/date/timestamp
insert into t_aggr_1(f0) values(10);
insert into t_aggr_1(f0) values(null);
insert into t_aggr_1(f0) values(5);
insert into t_aggr_1(f0) values(15);
select count(f0) from t_aggr_1;
select sum(f0) from t_aggr_1;
select max(f0) from t_aggr_1;
select min(f0) from t_aggr_1;
select avg(f0) from t_aggr_1;
select approx_count_distinct(f0) from t_aggr_1;
delete from t_aggr_1;
commit;

insert into t_aggr_1(f1) values(2147483648);
insert into t_aggr_1(f1) values(null);
insert into t_aggr_1(f1) values(2147483650);
insert into t_aggr_1(f1) values(2147483649);
select count(f1) from t_aggr_1;
select sum(f1) from t_aggr_1;
select max(f1) from t_aggr_1;
select min(f1) from t_aggr_1;
select avg(f1) from t_aggr_1;
select approx_count_distinct(f1) from t_aggr_1;
delete from t_aggr_1;
commit;

insert into t_aggr_1(f2) values(12334.997);
insert into t_aggr_1(f2) values(null);
insert into t_aggr_1(f2) values(12334.999);
insert into t_aggr_1(f2) values(12334.998);
select count(f2) from t_aggr_1;
select sum(f2) from t_aggr_1;
select max(f2) from t_aggr_1;
select min(f2) from t_aggr_1;
select avg(f2) from t_aggr_1;
select approx_count_distinct(f2) from t_aggr_1;
delete from t_aggr_1;
commit;

insert into t_aggr_1(f3) values(9912334.997);
insert into t_aggr_1(f3) values(null);
insert into t_aggr_1(f3) values(9912334.999);
insert into t_aggr_1(f3) values(9912334.998);
select count(f3) from t_aggr_1;
select sum(f3) from t_aggr_1;
select max(f3) from t_aggr_1;
select min(f3) from t_aggr_1;
select avg(f3) from t_aggr_1;
select approx_count_distinct(f3) from t_aggr_1;
delete from t_aggr_1;
commit;

insert into t_aggr_1(f4) values('2018-02-23 13:18:23');
insert into t_aggr_1(f4) values(null);
insert into t_aggr_1(f4) values('2018-02-23 13:18:25');
insert into t_aggr_1(f4) values('2018-02-23 13:18:24');
select count(f4) from t_aggr_1;
select max(f4) from t_aggr_1;
select min(f4) from t_aggr_1;
select approx_count_distinct(f4) from t_aggr_1;
delete from t_aggr_1;
commit;

insert into t_aggr_1(f5) values('2018-02-23 13:18:23.345');
insert into t_aggr_1(f5) values(null);
insert into t_aggr_1(f5) values('2018-02-23 13:18:23.347');
insert into t_aggr_1(f5) values('2018-02-23 13:18:23.346');
select count(f5) from t_aggr_1;
select max(f5) from t_aggr_1;
select min(f5) from t_aggr_1;
select approx_count_distinct(f5) from t_aggr_1;
delete from t_aggr_1;
commit;

-- string
insert into t_aggr_1(f6) values('2018-02-23 13:18:23.345');
insert into t_aggr_1(f6) values(null);
insert into t_aggr_1(f6) values('2018-02-23 13:18:23.347');
insert into t_aggr_1(f6) values('2018-02-23 13:18:23.346');
select count(f6) from t_aggr_1;
select max(f6) from t_aggr_1;
select min(f6) from t_aggr_1;
select approx_count_distinct(f6) from t_aggr_1;
delete from t_aggr_1;
commit;

insert into t_aggr_1(f7) values('2018-02-23 13:18:23.345');
insert into t_aggr_1(f7) values(null);
insert into t_aggr_1(f7) values('2018-02-23 13:18:23.347');
insert into t_aggr_1(f7) values('2018-02-23 13:18:23.346');
select count(f7) from t_aggr_1;
select max(f7) from t_aggr_1;
select min(f7) from t_aggr_1;
select approx_count_distinct(f7) from t_aggr_1;
delete from t_aggr_1;
commit;

-- binary
insert into t_aggr_1(f8, f9, f10) values('1D', '222', '3133');
insert into t_aggr_1(f8, f9, f10) values('1F', '222', '3323');
insert into t_aggr_1(f8, f9, f10) values('1E', '222', '3333');
select count(f8) from t_aggr_1;
select max(f8) from t_aggr_1;
select min(f8) from t_aggr_1;
select approx_count_distinct(f8) from t_aggr_1;

-- clob/blob
select max(f9) from t_aggr_1;
select max(f10) from t_aggr_1;
select approx_count_distinct(f9),approx_count_distinct(f10) from t_aggr_1;
delete from t_aggr_1;
commit;

--test recursive agg
insert into t_aggr_1(f0) values(10);
insert into t_aggr_1(f0) values(6);
insert into t_aggr_1(f0) values(5);
insert into t_aggr_1(f0) values(15);
commit;

SELECT AVG((CASE WHEN (f0 > 5) THEN f0 ELSE (2000) END)) Average_Salary FROM t_aggr_1 e;
SELECT AVG((CASE WHEN (f0 > 5 AND f0 < 20) THEN (f0) ELSE (2000) END)) Average_Salary FROM t_aggr_1 e;
SELECT AVG((CASE WHEN (f0 > 5 or f0 < 4) THEN (f0) ELSE (2000) END)) Average_Salary FROM t_aggr_1 e;

select avg(min(f0)) from t_aggr_1;
select avg(min(f0) + 3) from t_aggr_1;
select avg(min(f0) - 3) from t_aggr_1;
SELECT AVG((CASE WHEN (min(f0) > 5) THEN f0 ELSE (2000) END)) Average_Salary FROM t_aggr_1 e;
SELECT AVG((CASE WHEN (f0 > 5 AND f0 < 20) THEN (max(f0)) ELSE (2000) END)) Average_Salary FROM t_aggr_1 e;
SELECT AVG((CASE WHEN (f0 > 5 or least(21,max(f0),20) < 4) THEN (f0) ELSE (2000) END)) Average_Salary FROM t_aggr_1 e;
SELECT AVG((CASE WHEN (f0 > 5 or least(21,max(f0),20) < 4) THEN (least(21,max(f0),20)) ELSE (2000) END)) Average_Salary FROM t_aggr_1 e;
drop table t_aggr_1;
--DTS2019111506888
drop table if exists t_sql_cacel_002;
create table t_sql_cacel_002(id int not null,c_int int,c_vchar varchar(55) not null,c_vchar2 varchar(55) not null,c_blob blob not null,c_date date)
PARTITION BY HASH(id,c_vchar)
(
PARTITION p1,
PARTITION p2,
PARTITION p3
);
 
insert into t_sql_cacel_002 values(1,100,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_sql_cacel_002 values(2,100,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_sql_cacel_002 values(3,200,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
commit;
SELECT count(*) from (select * from (select c_vchar,c_int from t_sql_cacel_002 t2) t1 PIVOT(MAX((select length(c_vchar)))  FOR c_vchar IN ('abc1233' c1,'abc12333' c2))) t0;
SELECT count(*) from (select * from (select c_vchar,c_int from t_sql_cacel_002 t2) t1 PIVOT(MAX((select length(c_vchar)))  FOR c_vchar IN ('abc1233' c1,'abc12333' c2))) t0;
SELECT count(*) from (select * from (select c_vchar,c_int from t_sql_cacel_002 t2) t1 PIVOT(MAX((select length(c_vchar)))  FOR c_vchar IN ('abc1233' c1,'abc12333' c2))) t0;
SELECT count(*) from (select * from (select c_vchar,c_int from t_sql_cacel_002 t2) t1 PIVOT(MAX((select length(c_vchar)))  FOR c_vchar IN ('abc1233' c1,'abc12333' c2))) t0;
SELECT count(*) from (select * from (select c_vchar,c_int from t_sql_cacel_002 t2) t1 PIVOT(MAX((select length(c_vchar)))  FOR c_vchar IN ('abc1233' c1,'abc12333' c2))) t0;
drop table t_sql_cacel_002;

-- DTS2018022304251
drop table if exists RQG_SELECT_DIS_TBL;
CREATE TABLE RQG_SELECT_DIS_TBL(C_INTEGER INTEGER, C_BIGINT BIGINT, C_DOUBLE DOUBLE, C_NUMBER NUMBER, C_CHAR CHAR(100), C_VARCHAR VARCHAR(2000), C_VARCHAR2 VARCHAR(2000), C_TIMESTAMP TIMESTAMP, C_TEXT TEXT, C_BOOL BOOL); 

create unique index index_001 on RQG_SELECT_DIS_TBL(c_integer);
create index index_002 on RQG_SELECT_DIS_TBL(c_integer,c_bigint,c_double,c_char); 
create index index_003 on RQG_SELECT_DIS_TBL(c_char,c_timestamp);
create index index_004 on RQG_SELECT_DIS_TBL(c_integer,c_char,c_timestamp,c_bool);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 1, NULL, NULL, NULL, -474021888, NULL, NULL, NULL, 'mpdxvhqvf', NULL);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 3, NULL, NULL, NULL, 1488257024, 43244354354354, NULL, to_timestamp('2007-02-01 19:11:52', 'yyyy-mm-dd hh24:mi:ss'), NULL, NULL);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 4, NULL, 4214806301265362944, NULL, 257818624, 243243534, 6564645654646, to_timestamp('2008-05-18 05:43:36', 'yyyy-mm-dd hh24:mi:ss'), 'qif', TRUE);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 5, NULL, NULL, NULL, NULL, 1321324234, 756756757575, NULL, 'hqifmpdx', TRUE);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 7, NULL, -1844786997361639424, NULL, NULL, 564654646554, 4555555555555544, NULL, '=+', TRUE);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 8, NULL, NULL, NULL, 434044928, NULL, 54354353, NULL, 't', NULL);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 10, NULL, NULL, NULL, -654311424, 324324, 65464645464, NULL, NULL, NULL);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 12, 303431680, -2225059690897735680, NULL, 2024996864, 435453543, 342434324, to_timestamp('2004-02-21 08:56:50', 'yyyy-mm-dd hh24:mi:ss'), 't', FALSE);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 14, NULL, -8050184333924761600, NULL, -322109440, 432424324, NULL, NULL, '~', FALSE);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 16, NULL, -3823556083637551104, NULL, NULL, 34534534535, NULL, to_timestamp('2000-12-21 15:20:30', 'yyyy-mm-dd hh24:mi:ss'), 'ghimtialj', NULL);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 17, NULL, NULL, NULL, NULL, 6546464, 643543543, NULL, '; ', NULL);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 20, -1960706048, NULL, NULL, 1235812352, NULL, 345344443, NULL, 'sblvgs', NULL);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 21, 109969408, NULL, NULL, -1079181312, NULL, NULL, to_timestamp('2007-07-16 04:44:07', 'yyyy-mm-dd hh24:mi:ss'), 'lsblvgsgh', TRUE);

select distinct sum(c_varchar) from RQG_SELECT_DIS_TBL;
select distinct sum(c_varchar::number(38, -2)) from RQG_SELECT_DIS_TBL;
select distinct sum(c_varchar::number(38, -6)) from RQG_SELECT_DIS_TBL;
select distinct sum(c_varchar::number(38, -5)) from RQG_SELECT_DIS_TBL;
select distinct sum(c_varchar::int) from RQG_SELECT_DIS_TBL;
select distinct sum(c_varchar::bigint) from RQG_SELECT_DIS_TBL;
select distinct sum(c_varchar::date) from RQG_SELECT_DIS_TBL;
select distinct sum(c_varchar::timestamp) from RQG_SELECT_DIS_TBL;
select distinct sum(c_varchar::binary(100)) from RQG_SELECT_DIS_TBL;
select distinct sum(c_varchar::bool) from RQG_SELECT_DIS_TBL;

--tests for group_concat

--group_index
DROP TABLE IF EXISTS foo_index; 
DROP INDEX IF EXISTS idx_foo ON foo_index;
CREATE TABLE foo_index (col1 INTEGER NOT NULL, col2 VARCHAR(32));
CREATE INDEX idx_foo ON foo_index(col1);

INSERT INTO foo_index VALUES (1, 'aaa');
INSERT INTO foo_index VALUES (2, 'b');
INSERT INTO foo_index VALUES (3, 'cc');
INSERT INTO foo_index VALUES (4, 'ddd');
INSERT INTO foo_index VALUES (5, 'eeee');
INSERT INTO foo_index VALUES (6, 'fffff');
INSERT INTO foo_index VALUES (7, 'cbd');
INSERT INTO foo_index VALUES (8, 'b');
INSERT INTO foo_index VALUES (9, 'zzzzzz');
INSERT INTO foo_index VALUES (10, 'dddd');
INSERT INTO foo_index VALUES (11, 'xyz');
INSERT INTO foo_index VALUES (12, 'f'); 
INSERT INTO foo_index VALUES (4, 'ddd');
INSERT INTO foo_index VALUES (6, 'fffff');
INSERT INTO foo_index VALUES (7, 'cbd');
INSERT INTO foo_index VALUES (9, 'zzzzzz');
INSERT INTO foo_index VALUES (12, 'f');
INSERT INTO foo_index VALUES (1, 'aaa');
INSERT INTO foo_index VALUES (3, 'cc');
INSERT INTO foo_index VALUES (7, 'cbd');

SELECT col1, GROUP_CONCAT(col2) AS ncol2 FROM foo_index GROUP BY col1 order by 1;
SELECT col1, GROUP_CONCAT(col1, col2) AS ncol2 FROM foo_index GROUP BY col1 order by 1;
SELECT col1, TRIM(GROUP_CONCAT(col1, col2 SEPARATOR '|')) AS ncol2 FROM foo_index GROUP BY col1 order by 1;

SELECT col1, GROUP_CONCAT(col1, col2 SEPARATOR '|') AS ncol2 FROM foo_index GROUP BY col1 ORDER BY ncol2 DESC, col1;

SELECT col1, GROUP_CONCAT(col2 ORDER BY 0.5) FROM foo_index GROUP BY col1 order by 1;
SELECT col1, GROUP_CONCAT(col2 ORDER BY col2) FROM foo_index GROUP BY col1 order by 1;
SELECT col1, GROUP_CONCAT(col2 ORDER BY 1) FROM foo_index GROUP BY col1 order by 1;
SELECT col1, GROUP_CONCAT(col2,1,2 ORDER BY 0.5) FROM foo_index GROUP BY col1 order by 1;
SELECT col1, GROUP_CONCAT(col2,1,2 ORDER BY 2) FROM foo_index GROUP BY col1 order by 1;
SELECT col1, GROUP_CONCAT(1,2 ORDER BY 1) FROM foo_index GROUP BY col1 order by 1;

SELECT col1, GROUP_CONCAT(col1, col2 SEQUENCE '|') AS ncol2 FROM foo_index GROUP BY col1; --syntax error
SELECT col1, GROUP_CONCAT(col1, SEPARATOR '|') AS ncol2 FROM foo_index GROUP BY col1; --syntax error
SELECT col1, GROUP_CONCAT(col1, col2 SEPARATOR) AS ncol2 FROM foo_index GROUP BY col1; --syntax error 
SELECT col1, GROUP_CONCAT(col1, col2 SEPARATOR '|') AS ncol2 FROM foo_index;  --syntax error
SELECT GROUP_CONCAT(col1, col2 SEPARATOR NULL) AS ncol2 FROM foo_index; --syntax error
SELECT GROUP_CONCAT(col1, col2 SEPARATOR col2) AS ncol2 FROM foo_index; --syntax error
SELECT GROUP_CONCAT(col1, col2 SEPARATOR col1) AS ncol2 FROM foo_index; --syntax error

DROP TABLE foo_index; 
DROP INDEX idx_foo ON foo_index;

--DTS2018062904810
DROP TABLE if exists OSS_FUNCTION_LIST_001;
CREATE TABLE OSS_FUNCTION_LIST_001(C_INT INT ,C_INTEGER INTEGER NOT NULL ,C_BIGINT BIGINT,C_NUMBER NUMBER DEFAULT 0.2332,C_NUMBER1 NUMBER(12,2),C_NUMBER2 NUMBER(12,6),C_DOUBLE DOUBLE,C_DECIMAL DECIMAL,C_DECIMAL1 DECIMAL(8,2),C_DECIMAL2 DECIMAL(8,4),C_REAL REAL,C_CHAR CHAR(4000),C_VARCHAR VARCHAR(4000),C_VARCHAR2 VARCHAR2(4000),C_VARCHAR1 VARCHAR(100),C_CHAR1 CHAR(100),C_NUMERIC NUMERIC,C_DATETIME DATETIME,C_DATE DATE,C_TIMESTAMP TIMESTAMP,C_TIMESTAMP1 TIMESTAMP(6),C_BOOL BOOL) ;
create unique index  indx_t1 on OSS_FUNCTION_LIST_001 (c_int);
create index indx_t2 on OSS_FUNCTION_LIST_001 (c_int,C_DATETIME,C_TIMESTAMP);

INSERT INTO OSS_FUNCTION_LIST_001 VALUES(12,58812,546223079,1234567.89,12345.6789,12.3456789,1234.56,2345.67,12345.6789,12.3456789,12.33,'dbcd','abcde','1999-01-01','ab','adc',123.45,'2017-05-12 10:15:52','2005-08-08','2000-01-01 15:12:21.11','2000-08-01 15:12:21.32',true);
INSERT INTO OSS_FUNCTION_LIST_001 VALUES(13,58813,546223078,1234567.78,12345.5678,12.2345678,1234.67,2345.78,12345.5678,12.2345678,12.44,'dbce','abcdf','abcdeg','ac','ade',123.46,'2017-05-12 11:15:52','2012-08-08','2000-02-01 15:22:21.11','2012-02-01 15:12:11.32',false);
INSERT INTO OSS_FUNCTION_LIST_001 VALUES(14,58814,546223077,1234567.67,12345.4567,12.1234567,1234.78,2345.89,12345.4567,12.1234567,12.55,'dbcf','abcdg','2010-02-28','ad','adf',123.47,'2017-05-12 10:16:52','2002-08-11','2000-03-01 15:42:21.11','2008-08-12 15:13:21.32',true);
INSERT INTO OSS_FUNCTION_LIST_001 VALUES(15,58814,546223077,1234567.67,12345.4567,12.1234567,1234.78,2345.89,12345.4567,12.1234567,12.55,'dbcf','abcdg','abcdeh','ad','adf',123.47,'2016-02-29 10:16:52','2002-08-11','2000-03-01 15:42:21.11','2008-08-12 15:13:21.32',true);
INSERT INTO OSS_FUNCTION_LIST_001 VALUES(16,58814,546223077,1234567.67,12345.4567,12.1234567,1234.78,2345.89,12345.4567,12.1234567,12.55,'dbcf','abcdg','abcdeh','ad','adf',123.47,'2012-10-31 10:16:52','2002-08-11','2000-03-01 15:42:21.11','2008-08-12 15:13:21.32',true);

COMMIT;

select c_bigint,count(group_concat(c_bigint)) from   OSS_FUNCTION_LIST_001 group by c_bigint;
SELECT count(sum(c_bigint)) from OSS_FUNCTION_LIST_001;

DROP TABLE OSS_FUNCTION_LIST_001;
DROP TABLE if exists t1;
create table t1(a int,  b int);
create index idx_t1_1 on t1(a);
insert into t1 values(1,1);
insert into t1 values(2,1);
insert into t1 values(3,1);
insert into t1 values(4,1);
select max(a) +1 from t1 where a >=1;
select min(a) +1 from t1 where a >=1;
DROP TABLE if exists t1;

CREATE TABLE t1(f1 CHAR(200));
insert into t1 values('30');
COMMIT;

select 
 case when cast(f1 as int)<20 then '20'
 when cast(f1 as int)>=20 and cast(f1 as int) < 25 then '[20,25)'
 when cast(f1 as int)>=25 and cast(f1 as int) < 30 then '[25,30)'
 when cast(f1 as int)>=30 and cast(f1 as int) < 35 then '[30,35)'
 when cast(f1 as int)>=35 and cast(f1 as int) < 40 then '[35,40)'
 when cast(f1 as int)>=40 and cast(f1 as int) < 45 then '[40,45)'
 when cast(f1 as int)>=45 and cast(f1 as int) < 50 then '[45,50)'
 when cast(f1 as int)>=50 and cast(f1 as int) < 55 then '[50,55)'
 when cast(f1 as int)>=55 and cast(f1 as int) < 60 then '[55,60)'
 when cast(f1 as int)>=60 then '60' end
 from T1
 group by
 case when cast(f1 as int)<20 then '20'
 when cast(f1 as int)>=20 and cast(f1 as int) < 25 then '[20,25)'
 when cast(f1 as int)>=25 and cast(f1 as int) < 30 then '[25,30)'
 when cast(f1 as int)>=30 and cast(f1 as int) < 35 then '[30,35)'
 when cast(f1 as int)>=35 and cast(f1 as int) < 40 then '[35,40)'
 when cast(f1 as int)>=40 and cast(f1 as int) < 45 then '[40,45)'
 when cast(f1 as int)>=45 and cast(f1 as int) < 50 then '[45,50)'
 when cast(f1 as int)>=50 and cast(f1 as int) < 55 then '[50,55)'
 when cast(f1 as int)>=55 and cast(f1 as int) < 60 then '[55,60)'
 when cast(f1 as int)>=60 then '60' end;

UPDATE T1 SET F1 = '00000020180830';
ALTER SESSION SET NLS_DATE_FORMAT='YYYYMMDD';

select 
 case when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)<20 then '20'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=20 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 25 then '[20,25)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=25 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 30 then '[25,30)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=30 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 35 then '[30,35)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=35 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 40 then '[35,40)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=40 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 45 then '[40,45)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=45 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 50 then '[45,50)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=50 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 55 then '[50,55)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=55 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 60 then '[55,60)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=60 then '60' end
 from T1
 group by
 case when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)<20 then '20'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=20 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 25 then '[20,25)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=25 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 30 then '[25,30)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=30 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 35 then '[30,35)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=35 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 40 then '[35,40)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=40 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 45 then '[40,45)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=45 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 50 then '[45,50)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=50 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 55 then '[50,55)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=55 and timestampdiff(year,cast(substring(F1,7,8) as date),sysdate) < 60 then '[55,60)'
 when timestampdiff(year,cast(substring(F1,7,8) as date),sysdate)>=60 then '60' end;

ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
DROP TABLE if exists t1;

drop table if exists t_subselect_dept;
create table t_subselect_dept(
deptno int primary key,
dname varchar(30) UNIQUE,
loc varchar(30),
mgr varchar(30)
);
drop table if exists t_subselect_emp;
create table t_subselect_emp(
empno int primary key,
ename varchar(30) not null,
job varchar(30),
mgr varchar(30),
hiredate int,
sal int not null,
comm int check(comm<10000),
deptno int
);
insert into t_subselect_dept values(1, '技术部1' ,'南泥湾','Steve1');
insert into t_subselect_dept values(2, 'SALES1' ,'深圳市','宋祖英1');
insert into t_subselect_dept values(3, '事业部1' ,'北京市','宋祖英1');
insert into t_subselect_dept values(4, '服务部1' ,'延安','刘备备1');
insert into t_subselect_dept values(5, '生产部1' ,'南京市','刘备备1');
insert into t_subselect_dept values(6, '宣传部1' ,'上海市','刘备备1');
insert into t_subselect_dept values(7, '打杂部1' ,'广州市','刘备备1');
insert into t_subselect_dept values(8, '司令部1' ,'重庆市','曹操操1');
insert into t_subselect_dept values(9, '卫生部1' ,'长沙市','无1');
insert into t_subselect_dept values(10, '文化部1' ,'武冈市','无1');
insert into t_subselect_dept values(11, '娱乐部1' ,'纽约','无1');
insert into t_subselect_dept values(12, '管理部1' ,'伦敦','无1');
insert into t_subselect_dept values(13, '行政部1' ,'天津市','无1');
insert into t_subselect_emp values(1, '关羽羽', 'CLERK' ,'刘备备1', 20011109, 2000, 1000, 3);
insert into t_subselect_emp values(2, 'SMITH', 'CLERK' ,'刘备备1', 20120101, 2000, 800, 6);
insert into t_subselect_emp values(3, '刘备备', 'MANAGER' ,'宋祖英1', 20080808, 9000, 4000, 3);
insert into t_subselect_emp values(4, 'TOM', 'ENGINEER' ,'Steve1', 20050612, 3000, 1000, 1);
insert into t_subselect_emp values(5, 'Steve', 'MANAGER' ,'宋祖英1', 20110323, 80000, 9000, 1);
insert into t_subselect_emp values(6, '张飞飞', 'CLERK' ,'刘备备1', 20101010, 2000, 1000, 7);
insert into t_subselect_emp values(7, 'SCOTT', 'CLERK' ,'刘备备1', 20071204, 2000, 1000, 3);
insert into t_subselect_emp values(8, '宋祖英', 'Boss' ,'无1', 20060603, 2000, 1000, 8);
insert into t_subselect_emp values(9, '曹仁人', 'SALESMAN' ,'曹操操1', 20120130, 2000, 1000, 2);
insert into t_subselect_emp values(10, '曹操操', 'MANAGER' ,'宋祖英1',20090815, 2000, 1000, 2);
insert into t_subselect_emp values(11, '酱油哥', 'HAPI' ,'毛泽东1',20090215, 500, 1, 2);
insert into t_subselect_emp values(12, 'FISTH', 'CLERK' ,'刘备备1', 20120101, 2000, 800, 6);
insert into t_subselect_emp values(13, '张三三', 'MANAGER' ,'宋祖英1', 20080808, 9000, 4000, 3);
insert into t_subselect_emp values(14, '李苗苗', 'ENGINEER' ,'Steve1', 20050612, 3000, 1000, 1);
insert into t_subselect_emp values(15, '王舒数', 'MANAGER' ,'宋祖英1', 20110323, 80000, 9000, 1);
insert into t_subselect_emp values(16, '谢谢', 'CLERK' ,'刘备备1', 20101010, 2000, 1000, 3);
insert into t_subselect_emp values(17, '王欣欣', 'CLERK' ,'刘备备1', 20071204, 2000, 1000, 5);
insert into t_subselect_emp values(18, '李唐', 'Boss' ,'无1', 20060603, 2000, 1000, 8);
insert into t_subselect_emp values(19, '曹仁人', 'SALESMAN' ,'曹操操1', 20120130, 2000, 1000, 2);
insert into t_subselect_emp values(20, '陈星', 'MANAGER' ,'宋祖英1',20090815, 2000, 1000, 2);
insert into t_subselect_emp values(21, '君君', 'HAPI' ,'毛泽东1',20090215, 500, 1, 2);
commit;

select
  a.deptno,
  b.ename ,
  a.loc   ,
  b.job   ,
  b.sal
from
  t_subselect_dept a
  inner join
    t_subselect_emp b
    on
      a.deptno=b.deptno
where
  ascii(concat(b.sal,'1')) =
  (
    select
      ascii(GROUP_CONCAT(c.sal))
    from
      t_subselect_emp c
    where
      a.deptno   =c.deptno
      and a.mgr  =c.mgr
      and c.sal >=2000
  )
order by
  a.deptno,
  b.ename ,
  a.loc   ,
  b.job   ,
  b.sal
;

select distinct
  a.deptno,
  b.ename ,
  a.loc   ,
  b.job   ,
  b.sal
from
  t_subselect_dept a
  inner join
    t_subselect_emp b
    on
      a.deptno=b.deptno
where
  ascii(concat(b.sal,'1')) =
  (
    select
      ascii(GROUP_CONCAT(c.sal))
    from
      t_subselect_emp c
    where
      a.deptno   =c.deptno
      and a.mgr  =c.mgr
      and c.sal >=2000
  )
order by
  a.deptno,
  b.ename ,
  a.loc   ,
  b.job   ,
  b.sal
;

select 
  a.deptno,
  b.ename ,
  a.loc   ,
  b.job   ,
  b.sal
from
  t_subselect_dept a
  inner join
    t_subselect_emp b
    on
      a.deptno=b.deptno
where
  ascii(concat(b.sal,'1')) =
  (
    select
      ascii(GROUP_CONCAT(c.sal))
    from
      t_subselect_emp c
    where
      a.deptno   =c.deptno
      and a.mgr  =c.mgr
      and c.sal >=2000000
  )
order by
  a.deptno,
  b.ename ,
  a.loc   ,
  b.job   ,
  b.sal
;

select distinct
  a.deptno,
  a.dname ,
  a.loc   ,
  b.job   ,
  b.sal
from
  t_subselect_dept a,
  t_subselect_emp  b
where
  concat(b.comm,'') <>
  (
    select
      concat(1,GROUP_CONCAT(c.comm))
    from
      t_subselect_emp c
    where
      a.deptno=c.deptno
  )
  and concat(b.sal,'1') !=
  (
    select
      GROUP_CONCAT(c.sal)
    from
      t_subselect_emp c
    where
      a.deptno=c.deptno
  )
order by
  a.deptno,
  a.dname ,
  a.loc   ,
  b.job   ,
  b.sal
;

select distinct
  a.deptno,
  a.dname ,
  a.loc   ,
  b.job   ,
  b.sal
from
  t_subselect_dept a,
  t_subselect_emp  b
where
  concat(b.comm,'') <>
  (
    select
      GROUP_CONCAT(concat(1,c.comm))
    from
      t_subselect_emp c
    where
      a.deptno=c.deptno
  )
  and concat(b.sal,'1') !=
  (
    select
      GROUP_CONCAT(c.sal)
    from
      t_subselect_emp c
    where
      a.deptno=c.deptno
  )
order by
  a.deptno,
  a.dname ,
  a.loc   ,
  b.job   ,
  b.sal
;

drop table if exists t2;
create table t2(a int, b int, c int);
insert into t2 values(1,2,3);
insert into t2 values(2,2,2);
insert into t2 values(2,2,2);
insert into t2 values(3,2,2);
commit;
select b,c,case when c > (select avg(t.b) from t2) then 1 else 0 end as d from t2 t group by c,b order by 1;
drop table if exists t2;

--DTS2019012211799
drop table if exists avg_test;
create table avg_test(a int, b varchar(30));
insert into avg_test values(1123213, 'aaa');  
insert into avg_test values(2123213, 'baa');  
insert into avg_test values(3123213, 'caa');  
insert into avg_test values(4123213, 'daa');  
insert into avg_test values(5123213, 'eaa');    
insert into avg_test values(6123213, 'faa');  
insert into avg_test values(7123213, 'gaa');  
insert into avg_test values(8123213, 'haa');  
insert into avg_test values(9123213, 'iaa');  
insert into avg_test values(1123213, 'jaa'); 
insert into avg_test values(2123213, 'kaa');  
insert into avg_test values(3123213, 'laa');  
insert into avg_test values(4123213, 'maa');  
insert into avg_test values(5123213, 'naa');  
insert into avg_test values(6123213, 'oaa'); 
insert into avg_test values(7123213, 'paa');  
insert into avg_test values(8123213, 'qaa');  
insert into avg_test values(9123213, 'raa');  
insert into avg_test values(1123213, 'saa');  
insert into avg_test values(2123213, 'taa'); 
commit;

select avg(distinct(substr(a, 1, 1))) from avg_test;  
select avg(distinct(substr(a, 2, 1))) from avg_test;
select avg(distinct(substr(a, 3, 1))) from avg_test;
select avg(distinct(substr(a, 5, 1))) from avg_test;


drop table gs_test_aggr_mae_rmse;

--median
drop table if exists ct_regress_aggr_median;
create table ct_regress_aggr_median(id int not null, value_int int, value_decimal decimal(20,3), value_real real, value_varchar varchar(20), value_date date, value_bool boolean);
insert into ct_regress_aggr_median values(1, 0, 13132457.124, 13213478.57, '55647', '2018-05-05', false);
insert into ct_regress_aggr_median values(1, 1, 11546797.115, 15645482.11, '59875', '2018-06-01', false);
insert into ct_regress_aggr_median values(1, 1, 12745778.669, 16879447.56, '88654', '2018-06-02', false);
insert into ct_regress_aggr_median values(1, 5, 16797824.667, 11357945.96, '16797', '2018-06-03', false);
insert into ct_regress_aggr_median values(1, 3, 11647974.477, 11346794.12, '23467', '2018-06-03', false);
insert into ct_regress_aggr_median values(1, 3, 13464797.922, 16467467.22, '44642', '2018-05-03', false);
insert into ct_regress_aggr_median values(1, 8, 13464797.922, 15467467.22, '45642', '2018-05-03', true);
insert into ct_regress_aggr_median values(1, 4, 13434597.922, 16467117.11, '43842', '2018-05-04', true);
insert into ct_regress_aggr_median values(1, 9, 15464797.332, 14457667.61, '94542', '2018-05-05', false);
insert into ct_regress_aggr_median values(1, 9, 18433697.922, 11000001.00, '34642', '2018-05-03', false);
insert into ct_regress_aggr_median values(1, 6, 13456797.922, 16467467.22, '44642', '2018-05-07', true);
insert into ct_regress_aggr_median values(1, 6, 12558921.356, 13336467.89, '73895', '2018-05-08', true);
insert into ct_regress_aggr_median values(1, -1, 15376127.16, 19467567.92, '62254', '2018-05-09', false);
insert into ct_regress_aggr_median values(2, 9, 18632479.253, 13368921.62, '19525', '2018-05-10', true);
insert into ct_regress_aggr_median values(2, -9, 16589451.25, 13578944.00, '56987', '2019-06-04', true);
insert into ct_regress_aggr_median values(2, 2, 16657974.999, 46487348.46, '55672', '2018-09-09', false);
insert into ct_regress_aggr_median values(2, 6, 17985711.321, 1792364.767, '33568', '2018-10-10', false);
insert into ct_regress_aggr_median values(2, -1, 13132457.124, 13213478.57, '55647', '2018-05-05', true);
insert into ct_regress_aggr_median values(2, 7, 13132457.124, 13213478.57, '55647', '2018-05-05', false);

--const
select median(NULL) from ct_regress_aggr_median;
select median(-1.79E+308) from ct_regress_aggr_median;

--column odd
select median(value_int) from ct_regress_aggr_median;
select median(value_decimal) from ct_regress_aggr_median;
select median(value_real) from ct_regress_aggr_median;
select median(value_varchar) from ct_regress_aggr_median;
select median(value_date) from ct_regress_aggr_median;
select median(value_bool) from ct_regress_aggr_median;
--column even
select median(value_int) from ct_regress_aggr_median where id = 2;
select median(value_decimal) from ct_regress_aggr_median where id = 2;
select median(value_real) from ct_regress_aggr_median where id = 2;
select median(value_varchar) from ct_regress_aggr_median where id = 2;
select median(value_date) from ct_regress_aggr_median where id = 2;
select median(value_bool) from ct_regress_aggr_median where id = 2;

--expression
select median(2147483647 + 2147483647) from ct_regress_aggr_median;
select median(value_int + 2147483647) from ct_regress_aggr_median;
select median(value_decimal + 2147483647) from ct_regress_aggr_median;
select median(value_real + 2147483647) from ct_regress_aggr_median;
select median(value_varchar + 2147483647) from ct_regress_aggr_median;
select median(value_varchar + value_int) from ct_regress_aggr_median;
select median(value_varchar + value_decimal) from ct_regress_aggr_median;
select median(value_varchar + value_real) from ct_regress_aggr_median;
select median(value_varchar + value_varchar) from ct_regress_aggr_median;
select median(value_real + value_varchar) from ct_regress_aggr_median;
select median(value_real + value_real) from ct_regress_aggr_median;
select median(value_real + value_decimal) from ct_regress_aggr_median;
select median(value_real + value_int) from ct_regress_aggr_median;
select median(value_decimal + value_int) from ct_regress_aggr_median;
select median(value_decimal + value_decimal) from ct_regress_aggr_median;
select median(value_decimal + value_real) from ct_regress_aggr_median;
select median(value_decimal + value_varchar) from ct_regress_aggr_median;
select median(value_int + value_varchar) from ct_regress_aggr_median;
select median(value_int + value_real) from ct_regress_aggr_median;
select median(value_int + value_decimal) from ct_regress_aggr_median;
select median(value_int + value_int) from ct_regress_aggr_median;

--subquery
select median(value_int) from (select a.value_int from ct_regress_aggr_median a join ct_regress_aggr_median b);

--recursive aggr
select median(avg(value_int)) from ct_regress_aggr_median;

--functions
select median(abs(value_int)) from ct_regress_aggr_median;
select median(floor(value_int)) from ct_regress_aggr_median;
select median(abs(value_decimal)) from ct_regress_aggr_median;
select median(floor(value_decimal)) from ct_regress_aggr_median;
select median(abs(value_real)) from ct_regress_aggr_median;
select median(floor(value_real)) from ct_regress_aggr_median;
select median(abs(value_varchar)) from ct_regress_aggr_median;
select median(floor(value_varchar)) from ct_regress_aggr_median;

--distinct
select distinct median(value_int) from ct_regress_aggr_median;
select distinct median(value_decimal) from ct_regress_aggr_median;
select distinct median(value_real) from ct_regress_aggr_median;
select distinct median(value_varchar) from ct_regress_aggr_median;
select median(distinct value_int) from ct_regress_aggr_median;
select median(distinct value_decimal) from ct_regress_aggr_median;
select median(distinct value_real) from ct_regress_aggr_median;
select median(distinct value_varchar) from ct_regress_aggr_median;

--first row is empty
drop table if exists ct_regress_aggr_median_empty;
create table ct_regress_aggr_median_empty(id int not null, value_int int);
select median(value_int) from ct_regress_aggr_median_empty;
insert into ct_regress_aggr_median_empty(id) values(1);
select median(value_int) from ct_regress_aggr_median_empty;
insert into ct_regress_aggr_median_empty(id) values(1);
select median(value_int) from ct_regress_aggr_median_empty;
insert into ct_regress_aggr_median_empty values(2, 1);
select median(value_int) from ct_regress_aggr_median_empty;
insert into ct_regress_aggr_median_empty values(2, 2);
select median(value_int) from ct_regress_aggr_median_empty;
drop table ct_regress_aggr_median_empty;

--multiple aggrs
select avg(value_int), median(value_int) from ct_regress_aggr_median;
select median(value_int), avg(value_int) from ct_regress_aggr_median;
select avg(value_int), median(value_int), avg(value_int) from ct_regress_aggr_median;
select avg(value_int), median(value_int), median(value_int) from ct_regress_aggr_median;
select avg(value_int), avg(value_int), median(value_int) from ct_regress_aggr_median;
select median(value_int), avg(value_int), median(value_decimal) from ct_regress_aggr_median;
select median(value_int), avg(value_int), avg(value_decimal) from ct_regress_aggr_median;
select median(value_int), median(value_decimal), avg(value_decimal) from ct_regress_aggr_median;
select median(value_int), median(value_decimal), median(value_decimal) from ct_regress_aggr_median;

--index
create index idx_value on ct_regress_aggr_median(value_int);
select avg(value_int), median(value_int) from ct_regress_aggr_median;
select median(value_int) from ct_regress_aggr_median;
select avg(distinct value_int), median(distinct value_int) from ct_regress_aggr_median;
select median(distinct value_int), avg(distinct value_int) from ct_regress_aggr_median;
select median(distinct value_int) from ct_regress_aggr_median;
drop index idx_value on ct_regress_aggr_median;


--group by
--const
select median(NULL) from ct_regress_aggr_median group by id order by id;
select median(-1.79E+308) from ct_regress_aggr_median group by id order by id;

--column odd
select median(value_int) from ct_regress_aggr_median group by id order by id;
select median(value_decimal) from ct_regress_aggr_median group by id order by id;
select median(value_real) from ct_regress_aggr_median group by id order by id;
select median(value_varchar) from ct_regress_aggr_median group by id order by id;
select median(value_date) from ct_regress_aggr_median group by id order by id;
select median(value_bool) from ct_regress_aggr_median group by id order by id;
--column even
insert into ct_regress_aggr_median values(3, 5, 16797824.667, 11357945.96, '16797', '2018-06-03', false);
select median(value_int) from ct_regress_aggr_median group by id order by id;
select median(value_decimal) from ct_regress_aggr_median group by id order by id;
select median(value_real) from ct_regress_aggr_median group by id order by id;
select median(value_varchar) from ct_regress_aggr_median group by id order by id;
select median(value_date) from ct_regress_aggr_median group by id order by id;
select median(value_bool) from ct_regress_aggr_median group by id order by id;
delete from ct_regress_aggr_median where id = 3;

--expression
select median(2147483647 + 2147483647) from ct_regress_aggr_median group by id order by id;
select median(value_int + 2147483647) from ct_regress_aggr_median group by id order by id;
select median(value_decimal + 2147483647) from ct_regress_aggr_median group by id order by id;
select median(value_real + 2147483647) from ct_regress_aggr_median group by id order by id;
select median(value_varchar + 2147483647) from ct_regress_aggr_median group by id order by id;
select median(value_varchar + value_int) from ct_regress_aggr_median group by id order by id;
select median(value_varchar + value_decimal) from ct_regress_aggr_median group by id order by id;
select median(value_varchar + value_real) from ct_regress_aggr_median group by id order by id;
select median(value_varchar + value_varchar) from ct_regress_aggr_median group by id order by id;
select median(value_real + value_varchar) from ct_regress_aggr_median group by id order by id;
select median(value_real + value_real) from ct_regress_aggr_median group by id order by id;
select median(value_real + value_decimal) from ct_regress_aggr_median group by id order by id;
select median(value_real + value_int) from ct_regress_aggr_median group by id order by id;
select median(value_decimal + value_int) from ct_regress_aggr_median group by id order by id;
select median(value_decimal + value_decimal) from ct_regress_aggr_median group by id order by id;
select median(value_decimal + value_real) from ct_regress_aggr_median group by id order by id;
select median(value_decimal + value_varchar) from ct_regress_aggr_median group by id order by id;
select median(value_int + value_varchar) from ct_regress_aggr_median group by id order by id;
select median(value_int + value_real) from ct_regress_aggr_median group by id order by id;
select median(value_int + value_decimal) from ct_regress_aggr_median group by id order by id;
select median(value_int + value_int) from ct_regress_aggr_median group by id order by id;

--subquery
select median(value_int) from (select a.value_int from ct_regress_aggr_median a join ct_regress_aggr_median b) group by id order by id;

--recursive aggr
select median(avg(value_int)) from ct_regress_aggr_median group by id order by id;

--functions
select median(abs(value_int)) from ct_regress_aggr_median group by id order by id;
select median(floor(value_int)) from ct_regress_aggr_median group by id order by id;
select median(abs(value_decimal)) from ct_regress_aggr_median group by id order by id;
select median(floor(value_decimal)) from ct_regress_aggr_median group by id order by id;
select median(abs(value_real)) from ct_regress_aggr_median group by id order by id;
select median(floor(value_real)) from ct_regress_aggr_median group by id order by id;
select median(abs(value_varchar)) from ct_regress_aggr_median group by id order by id;
select median(floor(value_varchar)) from ct_regress_aggr_median group by id order by id;

--distinct
select distinct median(value_int) from ct_regress_aggr_median group by id order by id;
select distinct median(value_decimal) from ct_regress_aggr_median group by id order by id;
select distinct median(value_real) from ct_regress_aggr_median group by id order by id;
select distinct median(value_varchar) from ct_regress_aggr_median group by id order by id;
select median(distinct value_int) from ct_regress_aggr_median group by id order by id;
select median(distinct value_decimal) from ct_regress_aggr_median group by id order by id;
select median(distinct value_real) from ct_regress_aggr_median group by id order by id;
select median(distinct value_varchar) from ct_regress_aggr_median group by id order by id;

--first row is empty
drop table if exists ct_regress_aggr_median_empty;
create table ct_regress_aggr_median_empty(id int not null, value_int int);
select median(value_int) from ct_regress_aggr_median_empty group by id order by id;
insert into ct_regress_aggr_median_empty(id) values(1);
select median(value_int) from ct_regress_aggr_median_empty group by id order by id;
insert into ct_regress_aggr_median_empty(id) values(1);
select median(value_int) from ct_regress_aggr_median_empty group by id order by id;
insert into ct_regress_aggr_median_empty values(2, 1);
select median(value_int) from ct_regress_aggr_median_empty group by id order by id;
insert into ct_regress_aggr_median_empty values(2, 2);
select median(value_int) from ct_regress_aggr_median_empty group by id order by id;
drop table ct_regress_aggr_median_empty;

--multiple aggrs
select avg(value_int), median(value_int) from ct_regress_aggr_median group by id order by id;
select median(value_int), avg(value_int) from ct_regress_aggr_median group by id order by id;
select avg(value_int), median(value_int), avg(value_int) from ct_regress_aggr_median group by id order by id;
select avg(value_int), median(value_int), median(value_int) from ct_regress_aggr_median group by id order by id;
select avg(value_int), avg(value_int), median(value_int) from ct_regress_aggr_median group by id order by id;
select median(value_int), avg(value_int), median(value_decimal) from ct_regress_aggr_median group by id order by id;
select median(value_int), avg(value_int), avg(value_decimal) from ct_regress_aggr_median group by id order by id;
select median(value_int), median(value_decimal), avg(value_decimal) from ct_regress_aggr_median group by id order by id;
select median(value_int), median(value_decimal), median(value_decimal) from ct_regress_aggr_median group by id order by id;

--index
create index idx_value on ct_regress_aggr_median(value_int);
select avg(value_int), median(value_int) from ct_regress_aggr_median group by id order by id;
select median(value_int) from ct_regress_aggr_median group by id order by id;
select avg(distinct value_int), median(distinct value_int) from ct_regress_aggr_median group by id order by id;
select median(distinct value_int) from ct_regress_aggr_median group by id order by id;
drop index idx_value on ct_regress_aggr_median;

drop table ct_regress_aggr_median;

--DTS2019081305153
drop table if exists test_aggr_arg_is_array_element;
create table test_aggr_arg_is_array_element(col_16 int[],col_1 int);
insert into test_aggr_arg_is_array_element(col_1) values(null);
select VAR_POP(COL_16[1]) from test_aggr_arg_is_array_element order by 1;
drop table test_aggr_arg_is_array_element;

--max +max over( partition by) ---error
drop table if exists test_max_over;
create table test_max_over(f1 int,f2 int);
insert into test_max_over values (1,2);
insert into test_max_over values (2,3);
select max(f1) + max(f1) over(partition by f2) from test_max_over ;
drop table test_max_over;

--DENSE_RANK
drop table if exists rank1;
create table rank1(c1 int , c2 int, c3 varchar(10));
insert into rank1 values(3,1,'a10');
insert into rank1 values (3,3,'a11');
insert into rank1 values (3,2,'a12');
insert into rank1 values (3,1,'a13');
insert into rank1 values (3,5,'a14');
insert into rank1 values (3,5,'a15');
insert into rank1 values (3,7,'a16');
insert into rank1 values(4,1,'a17');
insert into rank1 values(1,3,'a1');
insert into rank1 values (1,2,'a2');
insert into rank1 values (1,1,'a3');
insert into rank1 values (1,3,'a4');
insert into rank1 values (1,2,'a5');
insert into rank1 values(2,1,'a6');
insert into rank1 values (2,3,'a7');
insert into rank1 values (2,2,'a8');
insert into rank1 values (2,1,'a9');
insert into rank1 values (2,null,'a18');
insert into rank1 values (3,null,'a19');
insert into rank1 values (null,null,'a20');
commit;

select DENSE_RANK(1) WITHIN GROUP (ORDER BY c1) as "dense_rank"  FROM rank1;
select DENSE_RANK(null) WITHIN GROUP (ORDER BY c1 asc nulls last) as "dense_rank"  FROM rank1;
select c1, DENSE_RANK(3) WITHIN GROUP (ORDER BY c2 desc) as "dense_rank"  FROM rank1 group by c1 order by c1;
select c1, DENSE_RANK(3, 'bd') WITHIN GROUP (ORDER BY c2 desc nulls last, c3 asc) as "dense_rank"  FROM rank1 group by c1 order by c1;

select DENSE_RANK(distinct 2) WITHIN GROUP (ORDER BY c1) as "dense_rank"  FROM rank1;
select DENSE_RANK('sw') WITHIN GROUP (ORDER BY c1) as "dense_rank"  FROM rank1;
select DENSE_RANK(2, 1) WITHIN GROUP (ORDER BY c1) as "dense_rank"  FROM rank1;
select DENSE_RANK(c1) WITHIN GROUP (ORDER BY c1) as "dense_rank"  FROM rank1;
--new
select DENSE_RANK(3.12) WITHIN GROUP (ORDER BY c1) as "dense_rank"  FROM rank1;
select c2, DENSE_RANK(5.4) WITHIN GROUP (ORDER BY c1) as "dense_rank"  FROM rank1 group by c2 order by c2;
select DENSE_RANK(true) WITHIN GROUP (ORDER BY c1) as "dense_rank"  FROM rank1;
select DENSE_RANK(false) WITHIN GROUP (ORDER BY c1) as "dense_rank"  FROM rank1;
--rank
select rank(1) WITHIN GROUP (ORDER BY c1) as "rank"  FROM rank1;
select rank(null) WITHIN GROUP (ORDER BY c1 asc nulls last) as "rank"  FROM rank1;
select c1, rank(3) WITHIN GROUP (ORDER BY c2 desc) as "rank"  FROM rank1 group by c1 order by c1;
select c1, rank(3, 'bd') WITHIN GROUP (ORDER BY c2 desc nulls last, c3 asc) as "rank"  FROM rank1 group by c1 order by c1;
select rank(distinct 2) WITHIN GROUP (ORDER BY c1) as "rank"  FROM rank1;
select rank('sw') WITHIN GROUP (ORDER BY c1) as "rank"  FROM rank1;
select rank(2, 1) WITHIN GROUP (ORDER BY c1) as "rank"  FROM rank1;
select rank(c1) WITHIN GROUP (ORDER BY c1) as "rank"  FROM rank1;
select rank(3.12) WITHIN GROUP (ORDER BY c1) as "rank"  FROM rank1;
select c2, rank(5.4) WITHIN GROUP (ORDER BY c1) as "rank"  FROM rank1 group by c2 order by c2;
select rank(true) WITHIN GROUP (ORDER BY c1) as "rank"  FROM rank1;
select rank(false) WITHIN GROUP (ORDER BY c1) as "rank"  FROM rank1;
--DTS2019120207030
select DENSE_RANK(2) WITHIN GROUP (ORDER BY max(c2)) as "dense_rank"  FROM rank1 group by c2;
select DENSE_RANK(max(c1)) WITHIN GROUP (ORDER BY c1) as "dense_rank"  FROM rank1  group by c1;
select DENSE_RANK(2) WITHIN GROUP (ORDER BY max(c2) over()) as "dense_rank"  FROM rank1 group by c2;
select DENSE_RANK(*) WITHIN GROUP (ORDER BY c1) as "dense_rank"  FROM rank1;
DROP SEQUENCE if exists seq_auto_extend11;
CREATE SEQUENCE seq_auto_extend11 START WITH 10 MAXVALUE 200 INCREMENT BY 2 CYCLE;
select DENSE_RANK(200) WITHIN GROUP (ORDER BY seq_auto_extend11.NEXTVAL) as "dense_rank"  FROM rank1;
DROP SEQUENCE seq_auto_extend11;
select DENSE_RANK(3) WITHIN GROUP (ORDER BY (select c1 from rank1 where c3 = 'a8')) as "dense_rank"  FROM rank1;
select DENSE_RANK(1) WITHIN GROUP (ORDER BY rowid) as "dense_rank"  FROM rank1; 
drop table if exists rank2;
create table rank2(c1 int default 3, c2 int[], c3 clob);
insert into rank2 values(3,array[2],'a10');
select DENSE_RANK('z') WITHIN GROUP (ORDER BY c3) as "dense_rank"  FROM rank2;
select DENSE_RANK(to_clob('z')) WITHIN GROUP (ORDER BY c3) as "dense_rank"  FROM rank2;
select DENSE_RANK(array[2]) WITHIN GROUP (ORDER BY c2) as "dense_rank"  FROM rank2;
drop table rank2;
drop table rank1;

drop table if exists dense_null;
create table dense_null(c1 int , c2 int);
select DENSE_RANK(9) WITHIN GROUP (ORDER BY c1) as "dense_rank"  FROM dense_null;
select DENSE_RANK(null) WITHIN GROUP (ORDER BY c1) as "dense_rank"  FROM dense_null;
select CUME_DIST(9) WITHIN GROUP (ORDER BY c1) as "cume_dist"  FROM dense_null;
select CUME_DIST(null) WITHIN GROUP (ORDER BY c1) as "cume_dist"  FROM dense_null;
select RANK(9) WITHIN GROUP (ORDER BY c1) as "rank" FROM dense_null;
select RANK(null) WITHIN GROUP (ORDER BY c1) as "rank" FROM dense_null;
drop table dense_null;
--DTS2019090902204
select cume_dist(case when 1=2 then 2 else 3 end) within group (order by 1) from dual;
select cume_dist(lpad('z',4000,'q')) within group (order by 'wer') from dual;
select cume_dist(case when dummy=2 then 2 else 3 end) within group (order by dummy) from dual;
select cume_dist(lpad(dummy,4000,'q')) within group (order by dummy) from dual;

drop table if exists count_rewrite;
drop table if exists count_rewrite1;
CREATE TABLE count_rewrite ( id int not null, "NAME" VARCHAR2(30), "PRODUCTID" NUMBER, "PRICE" NUMBER(10,2));
CREATE TABLE count_rewrite1 ( id int not null, "NAME" VARCHAR2(30), "PRODUCTID" NUMBER, "PRICE" NUMBER(10,2));
create index ind_name on count_rewrite(name);
create index ind_1 on count_rewrite(name, price);
create index ind_name1 on count_rewrite1(name);
--DTS2019112910209,	DTS2019112909886
drop table if exists t_select_agg_001;
create table t_select_agg_001(id int not null,c_int int,c_vchar varchar(55) not null,c_vchar2 varchar(55) not null,c_blob blob not null,c_date date);
insert into t_select_agg_001 values(1,100,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
SELECT RANK('a') WITHIN GROUP(ORDER BY 'a'||max(id)) c FROM t_select_agg_001 group by id;
SELECT DENSE_RANK('a') WITHIN GROUP(ORDER BY 'a'||max(id)) c FROM t_select_agg_001 group by id;
SELECT listagg('a') WITHIN GROUP(ORDER BY 'a'||max(id)) c FROM t_select_agg_001 group by id;
SELECT cume_dist(1) WITHIN GROUP(ORDER BY 'a'||max(id)) c FROM t_select_agg_001 group by id;
SELECT group_concat(1 ORDER BY 'a'||max(id)) c FROM t_select_agg_001 group by id;
drop table if exists t_select_agg_001;
SELECT RANK('a') WITHIN GROUP(ORDER BY 'a'||max(1) over()) c FROM dual;
SELECT DENSE_RANK('a') WITHIN GROUP(ORDER BY 'a'||max(1) over()) c FROM dual;
SELECT listagg('a') WITHIN GROUP(ORDER BY 'a'||max(1) over()) c FROM dual;
SELECT cume_dist(1) WITHIN GROUP(ORDER BY 'a'||max(1) over()) c FROM dual;
SELECT group_concat(1 ORDER BY 'a'||max(1) over()) c FROM dual;
--20201020
alter system set _optimizer_aggr_placement = false;
alter system set _optimizer_aggr_placement = true;
--20201211
drop table if exists t_20201209;
create table t_20201209(c1 int,c2 int,c3 int);
insert into t_20201209 values(1,1,1);
insert into t_20201209 values(1,1,1);
insert into t_20201209 values(1,2,2);
insert into t_20201209 values(1,2,3);
commit;
select array[1,2,3],count(c3) from t_20201209;
select array[1,2,3],count(c3) from t_20201209 group by c3 order by c3;
select array[c3],count(c3) from t_20201209 group by c3 order by c3;
select array[c1],count(c3) from t_20201209 group by c3 order by c3;
drop table t_20201209;

DROP TABLE  if exists  group_concate_test;
create table group_concate_test
(
  emp_id number(10),
  lead_id2 VARCHAR2(43),
  lead_id3 VARCHAR2(43),
  lead_id4 VARCHAR2(43),
  lead_id5 VARCHAR2(43)
);

begin
for i in 0 .. 600 loop
  insert into group_concate_test values((i+3)%3 , DBE_RANDOM.GET_STRING('l', 43),DBE_RANDOM.GET_STRING('l', 43),DBE_RANDOM.GET_STRING('l', 43),DBE_RANDOM.GET_STRING('l', 3));
end loop;
end;
/
commit;

select group_concat(emp_id, lead_id2,lead_id3 , emp_id, lead_id3 , lead_id5, lead_id4 order by emp_id,lead_id2) ,
group_concat(emp_id, lead_id3 order by emp_id, lead_id3),
group_concat(emp_id, lead_id4 order by emp_id)
from group_concate_test;
DROP TABLE  if exists  group_concate_test;

--bugfix: session stack overflow
drop table if exists FVT_OBJ_DEFINE_table_001;
create table FVT_OBJ_DEFINE_table_001(f1 int, f2 clob);
begin
	for i in 1..1000 loop
      insert into FVT_OBJ_DEFINE_table_001 values(i, lpad('abc',i+4000,'a@123&^%djgk'));
      commit;
    end loop;
end;
/
select APPROX_COUNT_DISTINCT(f2) from FVT_OBJ_DEFINE_table_001;
select MIN(F2), MAX(f2) from FVT_OBJ_DEFINE_table_001;
drop table if exists FVT_OBJ_DEFINE_table_001;
