DROP TABLE IF EXISTS T_UPDATE_1;
CREATE TABLE T_UPDATE_1 (F_INT1 INT, F_INT2 INT, F_CHAR CHAR(16), F_DATE DATE);
INSERT INTO T_UPDATE_1 VALUES(1,11,'A','2017-12-11 14:08:00');
INSERT INTO T_UPDATE_1 VALUES(2,22,'B','2017-12-12 16:08:00');
INSERT INTO T_UPDATE_1 VALUES(1,11,'A','2017-12-11 14:08:00');
INSERT INTO T_UPDATE_1 VALUES(3,33,'C','2017-12-13 15:08:20');
INSERT INTO T_UPDATE_1 VALUES(2,22,'B','2017-12-12 16:08:00');
DROP TABLE IF EXISTS T_UPDATE_2;
CREATE TABLE T_UPDATE_2 (F_INT1 INT, F_INT2 INT, F_CHAR CHAR(16), F_DATE DATE);
INSERT INTO T_UPDATE_2 VALUES(2,22,'C','2017-12-12 16:08:00');
INSERT INTO T_UPDATE_2 VALUES(1,11,'A','2017-12-11 14:08:00');
INSERT INTO T_UPDATE_2 VALUES(2,22,'C','2017-12-12 16:08:00');
COMMIT;
SELECT * FROM T_UPDATE_1;
SELECT * FROM T_UPDATE_2;
UPDATE T_UPDATE_1 SET F_INT1=11, F_INT2=(SELECT F_INT2 FROM T_UPDATE_2);
UPDATE T_UPDATE_1 SET F_INT1=11, F_INT2=(SELECT 111 FROM DUAL) WHERE F_INT2=11 AND F_INT1=1;
COMMIT;
SELECT F_INT1, F_INT2 FROM T_UPDATE_1;
UPDATE T_UPDATE_1 SET F_INT1=22, F_INT2=(SELECT F_INT2 FROM T_UPDATE_2 WHERE F_INT2=22 GROUP BY F_INT2) WHERE F_INT2=22 AND F_INT1=2;
COMMIT;
SELECT F_INT1, F_INT2 FROM T_UPDATE_1;
UPDATE T_UPDATE_1 SET F_INT1=(SELECT 33 FROM DUAL), F_INT2=(SELECT 333 FROM DUAL) WHERE F_INT1=3 AND F_INT2=(SELECT 33 FROM DUAL);
COMMIT;
SELECT F_INT1, F_INT2 FROM T_UPDATE_1;
UPDATE T_UPDATE_1 SET F_INT1=(SELECT 4 FROM DUAL), F_INT2=(SELECT 44 FROM DUAL);
COMMIT;
SELECT F_INT1, F_INT2 FROM T_UPDATE_1;

update t_update_1 set f_int1=1, f_int2=2 , f_int1=1;

--multi update error
DROP VIEW IF EXISTS TEST_V1;
CREATE VIEW TEST_V1 AS SELECT * FROM T_UPDATE_1;
UPDATE TEST_V1 SET F_INT1=10;
UPDATE T_UPDATE_1 T1 JOIN (SELECT * FROM T_UPDATE_2) T2 ON T1.F_INT1=T2.F_INT1 SET T2.F_INT1=100;
UPDATE T_UPDATE_1 T1 FULL JOIN T_UPDATE_2 T2 ON T1.F_INT1=T2.F_INT1 SET T1.F_INT1=100;
DROP VIEW  TEST_V1;
DROP TABLE T_UPDATE_1;
DROP TABLE T_UPDATE_2;

--DTS2018020906949
DROP TABLE IF EXISTS table_multi_mix;
CREATE TABLE table_multi_mix(C_INTEGER INTEGER, C_BIGINT BIGINT, C_DOUBLE DOUBLE, C_NUMBER NUMBER, C_CHAR CHAR(63), C_VARCHAR VARCHAR(99), C_TIMESTAMP TIMESTAMP, C_TEXT TEXT null, C_BOOL BOOL)
partition by range (C_TIMESTAMP)
(partition p1 values less than (to_timestamp('1989-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p2 values less than (to_timestamp('1990-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p3 values less than (to_timestamp('1991-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
 partition p4 values less than (to_timestamp('1992-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p5 values less than (to_timestamp('1993-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p6 values less than (to_timestamp('1994-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
 partition p7 values less than (to_timestamp('1995-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p8 values less than (to_timestamp('1996-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p9 values less than (to_timestamp('1997-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
partition p10 values less than (to_timestamp('1998-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p11 values less than (to_timestamp('1999-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p12 values less than (to_timestamp('2000-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
partition p13 values less than (to_timestamp('2001-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p14 values less than (to_timestamp('2002-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p15 values less than (to_timestamp('2003-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
partition p16 values less than (to_timestamp('2004-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p17 values less than (to_timestamp('2005-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p18 values less than (to_timestamp('2006-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
partition p19 values less than (to_timestamp('2007-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p20 values less than (to_timestamp('2008-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p21 values less than (to_timestamp('2009-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
partition p22 values less than (to_timestamp('2010-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p23 values less than (to_timestamp('2011-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p24 values less than (to_timestamp('2012-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
partition p25 values less than (to_timestamp('2013-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p26 values less than (to_timestamp('2014-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p27 values less than (to_timestamp('2015-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
partition p28 values less than (to_timestamp('2016-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p29 values less than (to_timestamp('2017-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p30 values less than (to_timestamp('2018-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
partition p31 values less than (to_timestamp('2019-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p32 values less than (to_timestamp('2020-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p33 values less than (to_timestamp('2021-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
partition p34 values less than (to_timestamp('2022-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p35 values less than (to_timestamp('2023-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p36 values less than (to_timestamp('2024-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
partition p37 values less than (to_timestamp('2025-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p38 values less than (to_timestamp('2026-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),partition p39 values less than (to_timestamp('2027-12-12 00:00:00', 'yyyy-mm-dd hh24:mi:ss')),
partition p40 values less than (maxvalue));

UPDATE table_multi_mix SET C_NUMBER = C_DOUBLE WHERE (((NULL - (C_NUMBER / (-902408775334363136 / (6 + 1)))) / 736559104) in (-1720647680)) and (C_TIMESTAMP between to_timestamp('2005-07-06 18:49:04', 'yyyy-mm-dd hh24:mi:ss') and C_TIMESTAMP);
DROP TABLE IF EXISTS table_multi_mix;

--DTS2018041703844
DROP TABLE IF EXISTS T_UPDATE_ROLLBACK_1;
CREATE TABLE T_UPDATE_ROLLBACK_1 (COL1 VARCHAR(64), COL2 VARCHAR(64), COL3 VARCHAR(64), COL4 VARCHAR(64), COL5 VARCHAR(64), COL6 VARCHAR(64), COL7 VARCHAR(64), COL8 VARCHAR(64), COL9 VARCHAR(64), COL10 VARCHAR(64), COL11 VARCHAR(64), COL12 VARCHAR(64));
INSERT INTO T_UPDATE_ROLLBACK_1 VALUES ('QWERTYUIOPASDFGHJKLZXCVBNM', 'QWERTYUIOPASDFGHJKLZXCVBNM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'QWERTYUIOPASDFG', NULL);
COMMIT;
ALTER TABLE T_UPDATE_ROLLBACK_1 ADD COL13 VARCHAR(24);
UPDATE T_UPDATE_ROLLBACK_1 SET COL11 = NULL, COL12 = 'ZXCVBNMASDFGH';
ROLLBACK;

----------------------------------------------------------------------
----- [CASE BLOCK BEGIN]: SUPPORT MULTI SET -----
drop table if exists t;
create table t (c1 int, c2 int, c3 int, c4 int default 10 + 1, c5 varchar(32), c6 varchar(32), c7 varchar(32));
insert into t(c1, c2, c3) values (1, 2, 3);

drop table if exists t1;
create table t1 (c1 int, c2 int, c3 int, c5 varchar(32), c6 varchar(32), c7 varchar(32));
insert into t1 values (11, 12, 13, 'a', 'b', 'c');
insert into t1 values (21, 22, 23, 'a', 'b', 'c');
commit;

-- Subquery returns single row: Oracle/PG support
update t set (c1, c2, c3) = (select c1, c2, c3 from t1 where c1 = 21);
update t set (c5, c6, c7) = (select c5, c6, c7 from t1 where c1 = 21);
select * from t;
rollback;

update t set (c1, c2) = (select c1 + t.c1, c2 + t.c2 from t1 where c1 = 21), (c3, c5) = (select c3 + t.c3, c5 from t1 where c1 = 21), (c6, c7) = (select c6, c7 from t1 where c1 = 21);
select * from t;
rollback;

insert into t1(c1, c2, c3, c5, c6, c7) values (1, 502, 503, 'x', 'y', 'z');
update sys.t 
set 
    (c1, c2) = (SELECT a.c1, a.c2    from sys.t1 a where a.c1 = sys.t.c1),
    (c3, c5) = (select c3 + t.c3, c5 from sys.t1 a where a.c1 = sys.t.c1),
    (c6, c7) = (select c6, c7        from sys.t1 a where a.c1 = sys.t.c1)
where 
    exists (select 1                 from sys.t1 a where a.c1 = sys.t.c1);
select * from t;
rollback;

insert into t1(c1, c2, c3, c5, c6, c7) values (1, 502, 503, 'x', 'y', 'z');
update t 
set 
    (c1, c2) = (SELECT a.c1, a.c2    from t1 a where a.c1 = t.c1),
    (c3, c5) = (select c3 + t.c3, c5 from t1 a where a.c1 = t.c1),
    (c6, c7) = (select c6, c7        from t1 a where a.c1 = t.c1)
where 
    exists (select 1                 from t1 a where a.c1 = t.c1);
select * from t;
rollback;

-- Subquery returns more than one row: Oracle/PG not support
update t set (c1, c2, c3) = (select c1, c2, c3 from t1);
rollback;

-- Subquery returns no row: Oracle/PG support, columns will set to NULL
update t set (c1, c2, c3) = (select c1, c2, c3 from t1 where c1 > 100);
select count(1) from t where c1 is null and c2 is null and c3 is null;
rollback;

-- Subquery returns single row with NULL: Oracle/PG support, columns will set to NULL
update t set (c1, c2, c3) = (select NULL, NULL, NULL from t1 where c1 = 2);
select count(1) from t where c1 is null and c2 is null and c3 is null;
rollback;

-- Non-subquery: Oracle not support, PG support
update t set (c1, c2, c3) = (4, 4, 4);
update t set (c1, c2) = (1);

-- Set list mis-matched
update t set c1 = (select c1, c2 from t1 where c1 = 21);
update t set (c1, c2) = (select c1 from t1 where c1 = 21);
update t set (c1, c2) = (select c1, 1, 1 from t1 where c1 = 21);

-- Duplicate column
update t set c1 = 1, (c1) = (select c1 from t1 where c1 = 21);
update t set (c1) = (select c1 from t1 where c1 = 21), c1 = 1;
update t set (c1, c2) = (select c1, c2 from t1 where c1 = 21), (c3, c1) = (select c1, c2 from t1 where c1 = 21);

-- Wrong syntax
update t set c1, c2 = select 1, 2 from t1;
update t set (c1, c2) = select 1, 2 from t1;
update t set (c1, c2) = 1;

-- Column type mis-matched
update t set c1 = (select to_date('2018-06-30', 'yyyy-mm-dd') from t1);
update t set (c1, c2) = (select 1, to_date('2018-06-30', 'yyyy-mm-dd') from t1 limit 1);
rollback;

-- merge into 
merge into t new using t1 old on (old.c1 = 11) 
when matched then update set new.c1 = old.c1 where new.c1 = 1;
select * from t;
rollback;

merge into t new using t1 old on (old.c1 = 11) 
when matched then 
    update set (new.c1, new.c2) = (select 100 + old.c1, 200 + old.c1), 
               (new.c3, new.c5)         = (select c3 + old.c3, c5 from t1 where c1 = 21), 
               (new.c6, new.c7)         = (select c6, c7 from t1 where c1 = 21)
    where new.c1 = 1; 
select * from t;
rollback;

merge into t new using t1 old on (old.c1 = 11) 
when matched then 
    update set (new.c1, new.c2) = (select 100 + old.c1, 200 + old.c1)
    where new.c1 = 1; 
select * from t;
rollback;

-- Check normal update syntax
update t set c1 = 101, c2 = 102, c3 = 103;
select * from t;
rollback;

update t set c1 = (select c1 from t1 where c1 = 21);
select * from t;
rollback;

update t set (c1) = (select c1 from t1 where c1 = 21);
select * from t;
rollback;

update t set c1 = default;
rollback;

update t1 set ("T1"."C1", c2, c3) = (select 1, 2, 3 from t1 limit 1);
rollback;

update t1 set "T1"."C1" = (select 1 from t1 limit 1);
rollback;

-- cleanup
drop table t;
drop table t1;
commit;
----- [CASE BLOCK END]: SUPPORT MULTI SET -----
----------------------------------------------------------------------
--------------------MULTI UPDATE-----------------------------
DROP TABLE IF EXISTS T1;
DROP TABLE IF EXISTS T2;
DROP TABLE IF EXISTS T3;
CREATE TABLE T1(F_INT1 INT, F_VARCHAR1 VARCHAR(32));
CREATE TABLE T2(F_INT1 INT, F_VARCHAR1 VARCHAR(32));
CREATE TABLE T3(F_INT1 INT, F_VARCHAR1 VARCHAR(32));

INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (1, 'T1_VALUE_1');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (1, 'T1_VALUE_1');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (2, 'T1_VALUE_2');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (3, 'T1_VALUE_3');

INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (1, 'T2_VALUE_1');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (1, 'T2_VALUE_1');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (2, 'T2_VALUE_2');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (2, 'T2_VALUE_2');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (3, 'T2_VALUE_3');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (4, 'T2_VALUE_4');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (5, 'T2_VALUE_5');
UPDATE T1 JOIN T2 ON T1.F_INT1=T2.F_INT1 SET T1.F_VARCHAR1 = T1.F_VARCHAR1 || 'UPDATED';
UPDATE T1 JOIN T2 ON T1.F_INT1=T2.F_INT1 SET T2.F_VARCHAR1 = T2.F_VARCHAR1 || 'UPDATED';
SELECT F_INT1, F_VARCHAR1 FROM T1;
SELECT F_INT1, F_VARCHAR1 FROM T2;
UPDATE T1 TT1 JOIN T2 TT2 ON TT1.F_INT1=TT2.F_INT1 SET TT1.F_INT1 = TT1.F_INT1*10, TT2.F_INT1=TT2.F_INT1*100;
SELECT F_INT1, F_VARCHAR1 FROM T1;
SELECT F_INT1, F_VARCHAR1 FROM T2;

DELETE FROM T1;
DELETE FROM T2;
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (1, 'T1_VALUE_1');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (1, 'T1_VALUE_1');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (2, 'T1_VALUE_2');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (3, 'T1_VALUE_3');

INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (1, 'T2_VALUE_1');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (1, 'T2_VALUE_1');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (2, 'T2_VALUE_2');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (2, 'T2_VALUE_2');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (3, 'T2_VALUE_3');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (4, 'T2_VALUE_4');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (5, 'T2_VALUE_5');

UPDATE T1 JOIN (SELECT * FROM T2 WHERE F_INT1=2) TT2 ON T1.F_INT1=TT2.F_INT1 SET T1.F_VARCHAR1 = T1.F_VARCHAR1 || 'UPDATED';
SELECT F_INT1, F_VARCHAR1 FROM T1;

DELETE FROM T1;
DELETE FROM T2;
DELETE FROM T3;
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (1, 'T1_VALUE_1');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (2, 'T1_VALUE_2');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (3, 'T1_VALUE_3');

INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (1, 'T2_VALUE_1');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (1, 'T2_VALUE_1');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (2, 'T2_VALUE_2');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (2, 'T2_VALUE_2');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (3, 'T2_VALUE_3');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (4, 'T2_VALUE_4');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (5, 'T2_VALUE_5');

INSERT INTO T3 (F_INT1, F_VARCHAR1) VALUES (1, 'T3_VALUE_1');
INSERT INTO T3 (F_INT1, F_VARCHAR1) VALUES (2, 'T3_VALUE_2');
INSERT INTO T3 (F_INT1, F_VARCHAR1) VALUES (2, 'T3_VALUE_2');
INSERT INTO T3 (F_INT1, F_VARCHAR1) VALUES (3, 'T3_VALUE_3');
INSERT INTO T3 (F_INT1, F_VARCHAR1) VALUES (4, 'T3_VALUE_4');
INSERT INTO T3 (F_INT1, F_VARCHAR1) VALUES (5, 'T3_VALUE_5');
INSERT INTO T3 (F_INT1, F_VARCHAR1) VALUES (6, 'T3_VALUE_6');
UPDATE T1 JOIN T2 ON T1.F_INT1=T2.F_INT1,T3 SET T1.F_INT1=T1.F_INT1*10,T2.F_INT1=T2.F_INT1*100 WHERE T2.F_INT1=T3.F_INT1;
SELECT F_INT1, F_VARCHAR1 FROM T1;
SELECT F_INT1, F_VARCHAR1 FROM T2;

DELETE FROM T1;
DELETE FROM T2;
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (1, 'T1_VALUE_1');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (2, 'T1_VALUE_2');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (3, 'T1_VALUE_3');

INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (1, 'T2_VALUE_1');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (1, 'T2_VALUE_1');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (2, 'T2_VALUE_2');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (2, 'T2_VALUE_2');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (3, 'T2_VALUE_3');
UPDATE T1,T2 LEFT JOIN T3 ON T2.F_INT1=T3.F_INT1 SET T1.F_INT1=50,T2.F_INT1=60 WHERE T1.F_INT1=T2.F_INT1;
SELECT F_INT1, F_VARCHAR1 FROM T1;
SELECT F_INT1, F_VARCHAR1 FROM T2;

DELETE FROM T1;
DELETE FROM T2;
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (1, 'T1_VALUE_1');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (2, 'T1_VALUE_2');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (3, 'T1_VALUE_3');

INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (1, 'T2_VALUE_1');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (1, 'T2_VALUE_1');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (2, 'T2_VALUE_2');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (2, 'T2_VALUE_2');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (3, 'T2_VALUE_3');
UPDATE T1,T2 RIGHT JOIN T3 ON T2.F_INT1=T3.F_INT1 SET T1.F_INT1=50,T2.F_INT1=60 WHERE T1.F_INT1=T2.F_INT1;
SELECT F_INT1, F_VARCHAR1 FROM T1;
SELECT F_INT1, F_VARCHAR1 FROM T2;

DELETE FROM T1;
DELETE FROM T2;
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (1, 'T1_VALUE_1');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (2, 'T1_VALUE_2');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (3, 'T1_VALUE_3');

INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (1, 'T2_VALUE_1');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (1, 'T2_VALUE_1');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (2, 'T2_VALUE_2');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (2, 'T2_VALUE_2');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (3, 'T2_VALUE_3');
UPDATE T1 LEFT JOIN T2 ON T1.F_INT1=T2.F_INT1 RIGHT JOIN T3 ON T2.F_INT1=T3.F_INT1 SET T1.F_INT1=50,T2.F_INT1=60;
SELECT F_INT1, F_VARCHAR1 FROM T1;
SELECT F_INT1, F_VARCHAR1 FROM T2;

DELETE FROM T1;
DELETE FROM T2;
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (1, 'T1_VALUE_1');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (2, 'T1_VALUE_2');
INSERT INTO T1 (F_INT1, F_VARCHAR1) VALUES (3, 'T1_VALUE_3');

INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (1, 'T2_VALUE_1');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (1, 'T2_VALUE_1');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (2, 'T2_VALUE_2');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (2, 'T2_VALUE_2');
INSERT INTO T2 (F_INT1, F_VARCHAR1) VALUES (3, 'T2_VALUE_3');
UPDATE T1 LEFT JOIN T2 ON T1.F_INT1=T2.F_INT1 RIGHT JOIN T3 ON T2.F_INT1=T3.F_INT1 SET T1.F_INT1=50,T2.F_INT1=60 WHERE T1.F_INT1=2;
SELECT F_INT1, F_VARCHAR1 FROM T1;
SELECT F_INT1, F_VARCHAR1 FROM T2;
DROP TABLE IF EXISTS T1;
DROP TABLE IF EXISTS T2;
DROP TABLE IF EXISTS T3;
--DTS2018073105767
DROP TABLE IF EXISTS ALL_DATATYPE_TBL;
CREATE TABLE ALL_DATATYPE_TBL( C_INTEGER INTEGER, C_VARCHAR VARCHAR(50) ); 
INSERT INTO ALL_DATATYPE_TBL VALUES(1,'AAAAA');
UPDATE ALL_DATATYPE_TBL T1 SET (C_INTEGER, C_VARCHAR) = (SELECT C_INTEGER C1, C_VARCHAR C2 FROM ALL_DATATYPE_TBL UNION SELECT C_INTEGER C1, C_VARCHAR C2 FROM ALL_DATATYPE_TBL WHERE T1.C_INTEGER = C_INTEGER);
SELECT * FROM ALL_DATATYPE_TBL;
DROP TABLE IF EXISTS ALL_DATATYPE_TBL;

DROP TABLE IF EXISTS ABC;
DROP TABLE IF EXISTS EFG;
CREATE GLOBAL TEMPORARY TABLE ABC(A INT);
CREATE TABLE EFG(B INT);
INSERT INTO EFG VALUES(1);
INSERT INTO EFG VALUES(1);
INSERT INTO ABC VALUES(1);
UPDATE EFG, ABC SET ABC.A=2 WHERE ABC.A=EFG.B;
DELETE ABC FROM ABC JOIN EFG ON ABC.A=EFG.B;
DROP TABLE IF EXISTS ABC;
DROP TABLE IF EXISTS EFG;

--
create table t_D_BTSAUTODLDACTINFO_B8
(
    SAVEPOINTID       NUMBER(10,0) NOT NULL ,                                      
    OPERTYPE          NUMBER(3,0)  NOT NULL,                                      
    PLANID            NUMBER(10,0) NOT NULL,                                    
    CMENEID           NUMBER(10,0) NOT NULL ,                                  
    BTSID             NUMBER(10,0) NOT NULL,                                     
    ADLDACT           NUMBER(3,0),                                                     
    AUTOTYPE          NUMBER(3,0) ,                                                    
    ADVER1            VARCHAR(77) ,                                                    
    ADVER2            VARCHAR(77) ,                                                    
    PV                VARCHAR(75) ,                                                    
    ADMODE            NUMBER(3,0) ,                                                    
    STTYPE            NUMBER(3,0) ,                                                    
    MAINVER           NUMBER(10,0) ,                                                   
    SUBVER            NUMBER(10,0) ,                                                   
    PATCHNO           NUMBER(10,0) ,                                                   
    MONTH             NUMBER(3,0)  ,                                                   
    DAY               NUMBER(3,0)  ,                                                   
    VVER              NUMBER(10,0) ,                                                   
    RVER              NUMBER(10,0) ,                                                   
    CVER              NUMBER(3,0)  ,                                                   
    PATCHNO1          NUMBER(10,0) ,                                                   
    AUTOACTIVEVERSION NUMBER(3,0)  ,                                                   
    LOGUPTID          VARCHAR(383) ,                                                   
    NBI_RECID         NUMBER(10,0) ,                                                   
    ISGENMML          NUMBER(3,0)                                                   
);

create table t_P_BTSAUTODLDACTINFO_B8
(
PLANID             NUMBER(10,0)  NOT NULL,                                          
CMENEID            NUMBER(10,0)  NOT NULL,                                             
BTSID              NUMBER(10,0)  NOT NULL,                                         
ADLDACT            NUMBER(3,0),
AUTOTYPE           NUMBER(3,0),
ADVER1             VARCHAR(77),
ADVER2             VARCHAR(77),
PV                 VARCHAR(75),
ADMODE             NUMBER(3,0),
STTYPE             NUMBER(3,0),
MAINVER            NUMBER(10,0),
SUBVER             NUMBER(10,0),
PATCHNO            NUMBER(10,0),
MONTH              NUMBER(3,0),
DAY                NUMBER(3,0),
VVER               NUMBER(10,0),
RVER               NUMBER(10,0),
CVER               NUMBER(3,0) ,
PATCHNO1           NUMBER(10,0),
AUTOACTIVEVERSION  NUMBER(3,0)
);

merge into t_P_BTSAUTODLDACTINFO_B8 
using ( select B.rowid as row_id, A.PlanID as field0, 
A.CMENEID as field1, A.ADLDACT as field2, A.AUTOTYPE as field3, A.ADVER1 as field4, A.ADVER2 as field5, A.PV as field6, A.ADMODE as field7, A.STTYPE as field8, A.MAINVER as field9, A.SUBVER as field10, 
A.PATCHNO as field11, A.MONTH as field12, A.DAY as field13, A.VVER as field14, A.RVER as field15, A.CVER as field16, A.PATCHNO1 as field17, A.AUTOACTIVEVERSION as field18 from t_D_BTSAUTODLDACTINFO_B8 A, t_P_BTSAUTODLDACTINFO_B8 B 
where A.PlanID = 1 and A.OperType = 4 and A.PlanID = B.PlanID
     and A.CMENEID = B.CMENEID and A.BTSID = B.BTSID) src 
on(t_P_BTSAUTODLDACTINFO_B8.rowid = src.row_id) 
when matched then update set 
PlanID = src.field0, 
CMENEID = src.field1, ADLDACT = src.field2, AUTOTYPE = src.field3, ADVER1 = src.field4, ADVER2 = src.field5, PV = src.field6, ADMODE = src.field7, STTYPE = src.field8, MAINVER = src.field9, SUBVER = src.field10, 
PATCHNO = src.field11, MONTH = src.field12, DAY = src.field13, VVER = src.field14, RVER = src.field15, CVER = src.field16, PATCHNO1 = src.field17, AUTOACTIVEVERSION = src.field18;

drop table t_D_BTSAUTODLDACTINFO_B8;
drop table t_P_BTSAUTODLDACTINFO_B8;

create table test_update_reserved (month NUMBER(3,0), day NUMBER(3,0));
insert into test_update_reserved values (1, 2);
update test_update_reserved set day = 3 where month = 1;
drop table test_update_reserved;

drop table if exists update_hash_partition_table_009_2;
create table update_hash_partition_table_009_2(C_ID int,
C_D_ID bigint,
C_W_ID tinyint unsigned NOT NULL,
C_FIRST VARCHAR(64) NOT NULL,
C_MIDDLE CHAR(2),
C_LAST VARCHAR(64),
C_STREET_1 VARCHAR(20) NOT NULL,
C_STREET_2 VARCHAR(20),
C_CITY VARCHAR(20) NOT NULL,
C_STATE CHAR(2) NOT NULL,
C_ZIP CHAR(9) NOT NULL,
C_PHONE CHAR(16) NOT NULL,
C_SINCE TIMESTAMP,
C_CREDIT CHAR(2) NOT NULL,
C_CREDIT_LIM NUMERIC(12,2),
C_DISCOUNT NUMERIC(4,4),
C_BALANCE NUMERIC(12,2),
C_YTD_PAYMENT REAL NOT NULL,
C_PAYMENT_CNT NUMBER NOT NULL,
C_DELIVERY_CNT BOOL NOT NULL,
C_END DATE NOT NULL,
C_VCHAR VARCHAR(1000),
C_VARCHAR1 VARCHAR2(3000),
C_VARCHAR2 VARCHAR2(3000),
C_VARCHAR3 VARCHAR2(3000),
C_VARCHAR4 VARCHAR2(3000),
C_DATA LONG,
C_TEXT BLOB,
C_CLOB CLOB,
C_VARCHAR5 VARCHAR2(100 BYTE) DEFAULT LPAD('AA',30,'BB'),
C_FLOAT FLOAT DEFAULT 0.001,
C_DOUBLE DOUBLE DEFAULT 1.001,
C_DECIMAL DECIMAL DEFAULT 1.001,
C_BINARY BINARY(100) DEFAULT LPAD('101',30,'201'),
C_VARBINARY VARBINARY(100) DEFAULT LPAD('101',30,'201'),
C_BOOLEAN BOOLEAN DEFAULT TRUE,
C_LONG LONG DEFAULT LPAD('AA',100,'BB'),
C_RAW RAW(100) DEFAULT LPAD('101',50,'201'),
C_IMAGE IMAGE DEFAULT LPAD('101',50,'201'))
partition by hash(c_d_id,c_last)
(
partition part_1,
partition part_2,
partition part_3,
partition part_4,
partition part_5,
partition part_6,
partition part_7,
partition part_8
);
INSERT INTO update_hash_partition_table_009_2 ("C_ID","C_D_ID","C_W_ID","C_FIRST","C_MIDDLE","C_LAST","C_STREET_1","C_STREET_2","C_CITY","C_STATE","C_ZIP","C_PHONE","C_SINCE","C_CREDIT","C_CREDIT_LIM","C_DISCOUNT","C_BALANCE","C_YTD_PAYMENT","C_PAYMENT_CNT","C_DELIVERY_CNT","C_END","C_VCHAR","C_VARCHAR1","C_VARCHAR2","C_VARCHAR3","C_VARCHAR4","C_DATA","C_TEXT","C_CLOB","C_VARCHAR5","C_FLOAT","C_DOUBLE","C_DECIMAL","C_BINARY","C_VARBINARY","C_BOOLEAN","C_LONG","C_RAW","C_IMAGE") values
  (180,106,180,'AAiscmvls','OE','106AA106106ddBA106RBAR106','bkili0fcxcle0','pmbwo0vhvpaj0','dyf0rya0','uq','48000    ','94002050        ','2018-06-29 10:51:47.000000','GC',50000,.4361,-10,10,1,TRUE,'2018-06-29 10:51:47','varchar1ERTDPvarchar1ERTDPvarchar1ERTDPvarchar1ERTDPvarchar1ERTDPvarchar1ERTDPvarchar1ERTDPvarchar1ERTDPvarchar1ERTDPvarchar1ERTDPvarchar1ERTDPvarchar1ERTDPvarchar1ERTDPvarchar1ERTDPvarcvarachar11234D','varchar2EROPHFFvarchar2EROPHFFvarchar2EROPHFFvarchar2EROPHFFvarchar2EROPHFFvarchar2EROPHFFvarchar2EROPHFFvarchar2EROPHFFvarchar2EROPHFFvarchar2EROPHFFvarchar2EROPHFFvarchar2EROPHFFvarc1234WEDRvarchar2','varchar3ERTSFvarchar3ERTSFvarchar3ERTSFvarchar3ERTSFvarchar3ERTSFvarchar3ERTSFvarchar3ERTSFvarchar3ERTSFvarchar3ERTSFvarchar3ERTSFvarchar3ERTSFvarchar3ERTSFvarchar3ERTSFvarchar3ERTSFvarchvarchar321345','ABfgCDefghABfgCDefghABfgCDefghABfgCDefghABfgCDefghABfgCDefghABfgCDefghABfgCDefghABfgCDefghABfgCDefghABfgCDefghABfgCDefghABfgCDefghABfgCDefghABfgCDefghABfgCDefghABfgCDefghABfgCDefghABfgCDefghA1234ESDFT','yxcfgdsgtcjxrbxxbmyxcfgdsgtcjxrbxxbmyxcfgdsgtcjxrbxxbmyxcfgdsgtcjxrbxxbmyxcfgdsgtcjxrbxxbmyxcfgdsgtcjxrbxxbmyxcfgdsgtcjxrbxxbmyxcfgdsgtcjxrbxxbmyxcfgdsgtcjxrbxxbmyxcfsbfacwjdafgjyjhfpyxcpmnutcjxrbxxbm','lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lob125lcobCLOr','76873890157687389015768738901576873890157687389015768738901576873890157687389015768738901576873890157687389015768738901576873890157687389015768738901576873890157687389015768124324543256546324554354325','clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clob12345clclobCLOBer','BBBBBBBBBBBBBBBBBBBBBBBBBBBBAA',0.001,1.001,1.001,0x323031323031323031323031323031323031323031323031323031313031,0x323031323031323031323031323031323031323031323031323031313031,TRUE,'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBAA','20120120120120120120120120120120120120120120120101',X'3230313230313230313230313230313230313230313230313230313230313230313230313230313230313230313230313031');
update update_hash_partition_table_009_2 set (c_d_id,c_last,c_clob,c_data)=(select 106, '106AA106106ddBA106RBAR106', lpad('clobCLOBer',3000,'clob12345'), lpad('cobCLOr',200,'lob125') from dual) 
where c_id = 180;
update update_hash_partition_table_009_2 set (c_d_id,c_last,c_clob,c_data)=(select 107, '106AA106106ddBA106RBAR108', lpad('clobCLOBer',3000,'clob12345'), lpad('cobCLOr',2000,'lob125') from dual),
(C_CREDIT_LIM,C_VARCHAR1,C_VARCHAR2,C_VARCHAR3)=(select 108, '106AA106106ddBA106RBAR108', lpad('clobCLOBer',3000,'clob12345'), lpad('cobCLOr',2000,'lob125') from dual)
where c_id = 180;
drop table update_hash_partition_table_009_2;

DROP TABLE IF EXISTS test_null;
create table test_null (i int, b varchar(30), c int);
declare
i integer;
begin
FOR i IN 1..500 LOOP
insert into test_null values(i,'aa',i);
END LOOP;
END;
/
update test_null set i=null,b=null,c=null;

declare
i integer;
begin
FOR i IN 1..400 LOOP
insert into test_null values(i,'aa',i);
END LOOP;
END;
/
update test_null set i=null,b='bb',c=6;
rollback;
update test_null set i=null,b='bb',c=6;
commit;
DROP TABLE IF EXISTS test_null;