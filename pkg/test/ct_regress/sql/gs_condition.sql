drop table if exists ref1;
drop table if exists cons1;
create table cons1(id int, res int, val int);
create unique index idx2 on cons1(id);
create table ref1(cid int REFERENCES cons1(id), cval int); --expect error
drop table if exists ref1;
drop table if exists cons1;
create table cons1(id int, res int, val int);
alter table cons1 add constraint c unique(id, res);
create table ref1(cid int REFERENCES cons1(id), cval int); --expect error
drop table if exists ref1;
drop table if exists cons1;
create table cons1(id int, res int, val int);
alter table cons1 add constraint c unique(id);
create table ref1(cid int REFERENCES cons1(id), cval int); --expect right
drop table if exists ref1;
drop table if exists cons1;
drop table if exists t_default_check_111;
create table t_default_check_111(id int,c_int int,c_vchar varchar(100),c_clob clob,c_blob blob,c_date date,
constraint t_default_check_111con check( c_vchar>'a' or c_vchar||c_vchar not in('abcabc') and c_vchar||c_vchar in(c_vchar||c_vchar) and abs(c_int)=length(c_vchar) and abs(c_int)=length(c_clob) and c_date in(ADD_MONTHS(TO_DATE('2016-01-29','YYYY-MM-DD'),1)) and c_date in (TO_DATE('2016-01-29','YYYY-MM-DD')+NUMTOYMINTERVAL(1, 'MONTH')) and c_int in(CAST('12' AS INT)) and c_vchar like '%abc_' and c_int between -1000 and 1000 and c_vchar is not null and c_int=any(12,12) or c_vchar>'a' or c_vchar||c_vchar not in('abcabc') and c_vchar||c_vchar in(c_vchar||c_vchar) and abs(c_int)=length(c_vchar) and abs(c_int)=length(c_clob) and c_date in(ADD_MONTHS(TO_DATE('2016-01-29','YYYY-MM-DD'),1)) and c_date in (TO_DATE('2016-01-29','YYYY-MM-DD')+NUMTOYMINTERVAL(1, 'MONTH')) and c_int in(CAST('12' AS INT)) and c_vchar like '%abc_' and c_int between -1000 and 1000 and c_vchar is not null and c_int=any(12,12) or c_vchar>'a' or c_vchar||c_vchar not in('abcabc') and c_vchar||c_vchar in(c_vchar||c_vchar) and abs(c_int)=length(c_vchar) and abs(c_int)=length(c_clob) and c_date in(ADD_MONTHS(TO_DATE('2016-01-29','YYYY-MM-DD'),1)) and c_date in (TO_DATE('2016-01-29','YYYY-MM-DD')+NUMTOYMINTERVAL(1, 'MONTH')) and c_int in(CAST('12' AS INT)) and c_vchar like '%abc_' and c_int between -1000 and 1000 and c_vchar is not null and c_int=any(12,12) or c_vchar>'a' or c_vchar||c_vchar not in('abcabc') and c_vchar||c_vchar in(c_vchar||c_vchar) and abs(c_int)=length(c_vchar) and abs(c_int)=length(c_clob) and c_date in(ADD_MONTHS(TO_DATE('2016-01-29','YYYY-MM-DD'),1)) and c_date in (TO_DATE('2016-01-29','YYYY-MM-DD')+NUMTOYMINTERVAL(1, 'MONTH')) and c_int in(CAST('12' AS INT)) and c_vchar like '%abc_' and c_int between -1000 and 1000 and c_vchar is not null and c_int=any(12,12) or c_vchar>'a' or c_vchar||c_vchar not in('abcabc') and c_vchar||c_vchar in(c_vchar||c_vchar) and abs(c_int)=length(c_vchar) and abs(c_int)=length(c_clob) and c_date in(ADD_MONTHS(TO_DATE('2016-01-29','YYYY-MM-DD'),1))));
insert into t_default_check_111(id,c_int,c_vchar,c_clob,c_date) values(1,12,'11111111abc1','111111111111',TO_DATE('2012-02-29','YYYY-MM-DD')); 
insert into t_default_check_111(id,c_int,c_vchar,c_clob) values(1,12,'111111111111','11111111111');

--normal test
DROP TABLE if exists training;
DROP TABLE if exists education;
CREATE TABLE education(staff_id INT primary key, first_name VARCHAR(20));
CREATE TABLE training(staff_id INT check(staff_id is not null), first_name VARCHAR(20));
alter table training add constraint trainingcon foreign key(staff_id) REFERENCES education(staff_id) on delete set null;
INSERT INTO education VALUES(1, 'ALICE');
INSERT INTO education VALUES(2, 'BROWN');
INSERT INTO training VALUES(1, 'ALICE');
INSERT INTO training VALUES(1, 'ALICE');
commit;
delete from education where staff_id=1; 
 
--index
DROP TABLE if exists training;
DROP TABLE if exists education;
CREATE TABLE education(staff_id INT primary key, first_name VARCHAR(20));
CREATE TABLE training(staff_id INT check(staff_id is not null), first_name VARCHAR(20));
create index training_idx on training(staff_id);
alter table training add constraint trainingcon foreign key(staff_id) REFERENCES education(staff_id) on delete set null;
INSERT INTO education VALUES(1, 'ALICE');
INSERT INTO education VALUES(2, 'BROWN');
INSERT INTO training VALUES(1, 'ALICE');
INSERT INTO training VALUES(1, 'ALICE');
commit;
delete from education where staff_id=1; 
 
 --partition 
DROP TABLE if exists training;
DROP TABLE if exists education;
CREATE TABLE education(staff_id INT primary key, first_name VARCHAR(20));
CREATE TABLE training(staff_id INT check(staff_id is not null), first_name VARCHAR(20)) partition by hash(staff_id)
(partition part_0, partition part_1,partition part_2);
alter table training add constraint trainingcon foreign key(staff_id) REFERENCES education(staff_id) on delete set null;
INSERT INTO education VALUES(1, 'ALICE');
INSERT INTO education VALUES(2, 'BROWN');
INSERT INTO training VALUES(1, 'ALICE');
INSERT INTO training VALUES(1, 'ALICE');
commit;
delete from education where staff_id=1; 
 
--partition + global index
DROP TABLE if exists training;
DROP TABLE if exists education;
CREATE TABLE education(staff_id INT primary key, first_name VARCHAR(20));
CREATE TABLE training(staff_id INT check(staff_id is not null), first_name VARCHAR(20)) partition by hash(staff_id)
(partition part_0, partition part_1,partition part_2);
create index training_idx on training(staff_id);
alter table training add constraint trainingcon foreign key(staff_id) REFERENCES education(staff_id) on delete set null;
INSERT INTO education VALUES(1, 'ALICE');
INSERT INTO education VALUES(2, 'BROWN');
INSERT INTO training VALUES(1, 'ALICE');
INSERT INTO training VALUES(1, 'ALICE');
commit;
delete from education where staff_id=1; 
 
--partition + local index
DROP TABLE if exists training;
DROP TABLE if exists education;
CREATE TABLE education(staff_id INT primary key, first_name VARCHAR(20));
CREATE TABLE training(staff_id INT check(staff_id is not null), first_name VARCHAR(20)) partition by hash(staff_id)
(partition part_0, partition part_1,partition part_2);
create index training_idx on training(staff_id) local;
alter table training add constraint trainingcon foreign key(staff_id) REFERENCES education(staff_id) on delete set null;
INSERT INTO education VALUES(1, 'ALICE');
INSERT INTO education VALUES(2, 'BROWN');
INSERT INTO training VALUES(1, 'ALICE');
INSERT INTO training VALUES(1, 'ALICE');
commit;
 delete from education where staff_id=1; 
 
DROP TABLE IF EXISTS T_CONDITION_1;
CREATE TABLE T_CONDITION_1(F_INT INT, F_CHAR CHAR(10), F_FLOAT FLOAT, F_DATE DATE);
INSERT INTO T_CONDITION_1 VALUES(1,'ABC',1.00,'2017-12-13 17:24:00');
INSERT INTO T_CONDITION_1 VALUES(2,'BCD',2.00,'2017-12-13 17:25:00');
INSERT INTO T_CONDITION_1 VALUES(3,'CDE',3.00,'2017-12-13 17:26:00');
INSERT INTO T_CONDITION_1 VALUES(4,'EFG',4.00,'2017-12-13 17:27:00');
INSERT INTO T_CONDITION_1 VALUES(null,'FGH',5.00,'2017-12-13 17:28:00');
INSERT INTO T_CONDITION_1 VALUES(6,'GHM',6.00,'2017-12-13 17:29:00');
INSERT INTO T_CONDITION_1 VALUES(7,'HMN',7.00,'2017-12-13 17:30:00');
INSERT INTO T_CONDITION_1 VALUES(null,null,8.00,'2017-12-13 17:30:00');
INSERT INTO T_CONDITION_1 VALUES(null,null,1.00,'2017-12-13 17:30:00');
DROP TABLE IF EXISTS T_CONDITION_2;
CREATE TABLE T_CONDITION_2(F_INT INT, F_CHAR CHAR(10), F_FLOAT FLOAT, F_DATE DATE);
INSERT INTO T_CONDITION_2 VALUES(1,'ABC',1.00,'2017-12-13 17:24:00');
INSERT INTO T_CONDITION_2 VALUES(2,'BCD',2.00,'2017-12-13 17:25:00');
INSERT INTO T_CONDITION_2 VALUES(3,null,3.00,'2017-12-13 17:26:00');
INSERT INTO T_CONDITION_2 VALUES(4,'EFG',4.00,'2017-12-13 17:27:00');
INSERT INTO T_CONDITION_2 VALUES(null,'FGH',5.00,'2017-12-13 17:28:00');
INSERT INTO T_CONDITION_2 VALUES(6,'GHM',6.00,'2017-12-13 17:29:00');
INSERT INTO T_CONDITION_2 VALUES(null,null,7.00,'2017-12-13 17:29:00');
DROP TABLE IF EXISTS T_CONDITION_3;
CREATE TABLE T_CONDITION_3(F_INT INT, F_CHAR CHAR(10), F_FLOAT FLOAT, F_DATE DATE);
INSERT INTO T_CONDITION_3 VALUES(1,'ABC',1.00,'2017-12-13 17:24:00');
INSERT INTO T_CONDITION_3 VALUES(2,'BCD',2.00,'2017-12-13 17:25:00');
INSERT INTO T_CONDITION_3 VALUES(3,null,3.00,'2017-12-13 17:26:00');
INSERT INTO T_CONDITION_3 VALUES(4,'EFG',4.00,'2017-12-13 17:27:00');
DROP TABLE IF EXISTS T_CONDITION_4;
CREATE TABLE T_CONDITION_4(F_INT INT, F_CHAR CHAR(10), F_FLOAT FLOAT, F_DATE DATE);
--TEST IS[NOT] NULL CONDITION
SELECT * FROM T_CONDITION_1 WHERE F_INT IS NULL;
SELECT * FROM T_CONDITION_1 WHERE F_INT IS NOT NULL;
--TEST [NOT] IN CONDITION
SELECT * FROM T_CONDITION_1 WHERE F_INT IN (1,2,3);
SELECT * FROM T_CONDITION_1 WHERE F_INT NOT IN (1,2,3);
SELECT * FROM T_CONDITION_1 WHERE F_INT IN (1,2,3,null,4);
SELECT * FROM T_CONDITION_1 WHERE F_INT NOT IN (1,2,3,null,4);
SELECT * FROM T_CONDITION_1 WHERE F_CHAR IN ('ABC','BCD','CDE');
SELECT * FROM T_CONDITION_1 WHERE F_CHAR NOT IN ('ABC','BCD','CDE');
SELECT * FROM T_CONDITION_1 WHERE F_FLOAT IN (1.00,2.00,3.00);
SELECT * FROM T_CONDITION_1 WHERE F_FLOAT NOT IN (1.00,2.00,3.00);
SELECT * FROM T_CONDITION_1 WHERE (F_INT, F_CHAR) IN ((1,'ABC'),(2,'BCD'),(3,'CDE'));
SELECT * FROM T_CONDITION_1 WHERE (F_INT, F_CHAR) NOT IN ((1,'ABC'),(2,'BCD'),(3,'CDE'));
SELECT * FROM T_CONDITION_1 WHERE (F_INT, F_CHAR) IN ((1,'ABC'),(3,null),(null,'EFG'),(6,'GHM'));
SELECT * FROM T_CONDITION_1 WHERE (F_INT, F_CHAR)  NOT IN ((1,'ABC'),(3,null),(null,'BCD'),(6,'GHM'));
SELECT * FROM T_CONDITION_1 WHERE (F_INT, F_CHAR) IN ((1,'ABC'),(null,'FGH'),(null,null),(6,'GHM'));
SELECT * FROM T_CONDITION_1 WHERE (F_INT, F_CHAR) NOT IN ((1,'ABC'),(null,'FGH'),(null,null),(6,'GHM'));
SELECT * FROM T_CONDITION_1 WHERE (F_INT,F_CHAR,F_FLOAT) IN ((1,'ABC',null));
SELECT * FROM T_CONDITION_1 WHERE (F_INT,F_CHAR,F_FLOAT) not IN ((1,'ABC',null));
SELECT * FROM T_CONDITION_1 WHERE F_INT IN (SELECT F_INT FROM T_CONDITION_2);
SELECT * FROM T_CONDITION_1 WHERE F_INT NOT IN (SELECT F_INT FROM T_CONDITION_2);
SELECT * FROM T_CONDITION_1 WHERE (F_INT, F_CHAR) IN (SELECT F_INT, F_CHAR FROM T_CONDITION_2);
SELECT * FROM T_CONDITION_1 WHERE (F_INT, F_CHAR) NOT IN (SELECT F_INT, F_CHAR FROM T_CONDITION_2);
SELECT * FROM T_CONDITION_1 WHERE (F_INT, F_CHAR, F_FLOAT) IN (SELECT F_INT, F_CHAR, F_FLOAT FROM T_CONDITION_2);
SELECT * FROM T_CONDITION_1 WHERE (F_INT, F_CHAR, F_FLOAT) NOT IN (SELECT F_INT, F_CHAR, F_FLOAT FROM T_CONDITION_2);
SELECT * FROM T_CONDITION_1 WHERE (F_INT, F_CHAR) IN (1,'A');
SELECT * FROM T_CONDITION_1 WHERE (F_INT, F_CHAR) NOT IN (1,'A');
SELECT * FROM T_CONDITION_1 WHERE (F_INT, F_CHAR) IN (SELECT F_INT FROM T_CONDITION_2);
SELECT * FROM T_CONDITION_1 WHERE (F_INT, F_CHAR) NOT IN (SELECT F_INT FROM T_CONDITION_2);
SELECT * FROM T_CONDITION_1 WHERE F_INT IN (SELECT F_INT, F_CHAR FROM T_CONDITION_2);
SELECT * FROM T_CONDITION_1 WHERE F_INT NOT IN (SELECT F_INT, F_CHAR FROM T_CONDITION_2);
--TEST [NOT] BETWEEN AND CONDITION
SELECT * FROM T_CONDITION_1 WHERE F_INT BETWEEN 2 AND 6;
SELECT * FROM T_CONDITION_1 WHERE F_INT NOT BETWEEN 2 AND 6;
SELECT * FROM T_CONDITION_1 WHERE F_INT BETWEEN 6 AND 2;
SELECT * FROM T_CONDITION_1 WHERE F_INT NOT BETWEEN 6 AND 2;
SELECT * FROM T_CONDITION_1 WHERE F_INT BETWEEN null AND 6;
SELECT * FROM T_CONDITION_1 WHERE F_INT NOT BETWEEN null AND 6;
SELECT * FROM T_CONDITION_1 WHERE F_INT BETWEEN 2 AND null;
SELECT * FROM T_CONDITION_1 WHERE F_INT NOT BETWEEN 2 AND null;
SELECT * FROM T_CONDITION_1 WHERE F_INT BETWEEN null AND null;
SELECT * FROM T_CONDITION_1 WHERE F_INT NOT BETWEEN null AND null;
SELECT * FROM T_CONDITION_1 WHERE F_CHAR BETWEEN 'ABC' AND 'GHM';
SELECT * FROM T_CONDITION_1 WHERE F_CHAR NOT BETWEEN 'ABC' AND 'GHM';
SELECT * FROM T_CONDITION_1 WHERE F_FLOAT BETWEEN 2.00 AND 6.00;
SELECT * FROM T_CONDITION_1 WHERE F_FLOAT NOT BETWEEN 2.00 AND 6.00;

DROP INDEX IF EXISTS T_CONDITION_1_INDEX ON T_CONDITION_1;
CREATE INDEX T_CONDITION_1_INDEX ON T_CONDITION_1(F_INT);
SELECT COUNT(*) FROM T_CONDITION_1 WHERE F_INT = 1 and F_INT < 10;

--TEST LIKE
create table likett1 (a int);
INSERT INTO LIKETT1 VALUES(66);
INSERT INTO LIKETT1 VALUES(132);
INSERT INTO LIKETT1 VALUES(5);
SELECT * FROM LIKETT1 WHERE 12563 LIKE 1%63;
SELECT * FROM LIKETT1 WHERE 1%63 LIKE 12363;
drop table likett1;

--TEST [NOT] EXISTS
SELECT * FROM T_CONDITION_1 WHERE EXISTS (SELECT * FROM T_CONDITION_2 WHERE F_INT <= 10);
SELECT * FROM T_CONDITION_1 WHERE NOT EXISTS (SELECT * FROM T_CONDITION_2 WHERE F_INT <= 10);
SELECT * FROM T_CONDITION_1 WHERE EXISTS (SELECT * FROM T_CONDITION_2 WHERE F_INT > 10);
SELECT * FROM T_CONDITION_1 WHERE NOT EXISTS (SELECT * FROM T_CONDITION_2 WHERE F_INT > 10);
SELECT * FROM T_CONDITION_1 WHERE EXISTS (SELECT count(*) FROM T_CONDITION_2 WHERE F_INT <= 10);
SELECT * FROM T_CONDITION_1 WHERE NOT EXISTS (SELECT count(*) FROM T_CONDITION_2 WHERE F_INT <= 10);
SELECT * FROM T_CONDITION_1 WHERE EXISTS (SELECT count(*) FROM T_CONDITION_2 WHERE F_INT > 10);
SELECT * FROM T_CONDITION_1 WHERE NOT EXISTS (SELECT count(*) FROM T_CONDITION_2 WHERE F_INT > 10);
SELECT * FROM T_CONDITION_1 WHERE EXISTS (SELECT * FROM T_CONDITION_2 T_2 JOIN T_CONDITION_3 T_3 ON T_2.F_INT=T_3.F_INT);
SELECT * FROM T_CONDITION_1 WHERE NOT EXISTS (SELECT * FROM T_CONDITION_2 T_2 JOIN T_CONDITION_3 T_3 ON T_2.F_INT=T_3.F_INT);
SELECT * FROM T_CONDITION_1 WHERE EXISTS (SELECT * FROM T_CONDITION_2 T_2 JOIN T_CONDITION_4 T_4 ON T_2.F_INT=T_4.F_INT);
SELECT * FROM T_CONDITION_1 WHERE NOT EXISTS (SELECT * FROM T_CONDITION_2 T_2 JOIN T_CONDITION_4 T_4 ON T_2.F_INT=T_4.F_INT);

--TEST ||
SELECT 'HELLO' || ' ' || 'WORLD' FROM DUAL;
SELECT 'HELLO' || NULL FROM DUAL;
SELECT 1234 || 5678 || 'HELLO' FROM DUAL;
SELECT 'TEST' || ' ' || F_CHAR FROM T_CONDITION_1;
--DTS2018021400824
DROP TABLE IF EXISTS TEST_CONCAT;
CREATE TABLE TEST_CONCAT(F1 VARCHAR(10), F2 INT);
INSERT INTO TEST_CONCAT VALUES(NULL, 10000);
SELECT * FROM TEST_CONCAT WHERE ((F1 || F1) || (F1 || (((-2454461796916920320) || NULL) || '2004'))) <> NULL;
DROP TABLE IF EXISTS TEST_CONCAT;

--TEST +,-,*,\
SELECT 1+1 FROM DUAL;
SELECT 1+NULL FROM DUAL;
SELECT 10-5 FROM DUAL;
SELECT 6-8 FROM DUAL;
SELECT 6-NULL FROM DUAL;
SELECT 3*4 FROM DUAL;
SELECT 0*4 FROM DUAL;
SELECT 4*NULL FROM DUAL;
SELECT 20/5 FROM DUAL;
SELECT 6/20 FROM DUAL;
SELECT 0/10 FROM DUAL;
SELECT 10/0 FROM DUAL;
SELECT NULL/8 FROM DUAL;
SELECT 8/NULL FROM DUAL;
SELECT 1+8-5*4/2 FROM DUAL;
SELECT (1+8-5)*4/2 FROM DUAL;
SELECT 'ABCDG'+13 FROM DUAL;
SELECT 'ABCDG'-10 FROM DUAL;
SELECT 'ABCDG'*10 FROM DUAL;
SELECT 'ABCDG'/8 FROM DUAL;
--TEST & | ^
SELECT 5&3 FROM DUAL;
SELECT 5|3 FROM DUAL;
SELECT 5^3 FROM DUAL;
SELECT 3&8 FROM DUAL;
SELECT 3|8 FROM DUAL;
SELECT 3^8 FROM DUAL;
SELECT 4&NULL FROM DUAL;
SELECT 6|NULL FROM DUAL;
SELECT NULL^7 FROM DUAL;
SELECT 1+8-5*4/2&6|8^10 FROM DUAL;
SELECT 5&'ABC' FROM DUAL;
SELECT 'BCD'&8 FROM DUAL;
SELECT 'ABG'&'ABC' FROM DUAL;

--TEST <,<=,>,>=,=,<> OR !=
SELECT * FROM T_CONDITION_1 WHERE F_INT < 4;
SELECT * FROM T_CONDITION_1 WHERE F_INT <= 4;
SELECT * FROM T_CONDITION_1 WHERE F_INT < NULL;
SELECT * FROM T_CONDITION_1 WHERE F_INT > 4;
SELECT * FROM T_CONDITION_1 WHERE F_INT >= 4;
SELECT * FROM T_CONDITION_1 WHERE F_INT > NULL;
SELECT * FROM T_CONDITION_1 WHERE F_INT = 4;
SELECT * FROM T_CONDITION_1 WHERE F_INT = NULL;
SELECT * FROM T_CONDITION_1 WHERE F_INT <> 4;
SELECT * FROM T_CONDITION_1 WHERE F_INT <> NULL;
SELECT * FROM T_CONDITION_1 WHERE F_CHAR < 'EFG';
SELECT * FROM T_CONDITION_1 WHERE F_CHAR <= 'EFG';
SELECT * FROM T_CONDITION_1 WHERE F_CHAR > 'EFG';
SELECT * FROM T_CONDITION_1 WHERE F_CHAR >= 'EFG';
SELECT * FROM T_CONDITION_1 WHERE F_CHAR = 'EFG';
SELECT * FROM T_CONDITION_1 WHERE F_CHAR <> 'EFG';
SELECT * FROM T_CONDITION_1 WHERE F_FLOAT < 4.0;
SELECT * FROM T_CONDITION_1 WHERE F_FLOAT <= 4.0;
SELECT * FROM T_CONDITION_1 WHERE F_FLOAT > 4.0;
SELECT * FROM T_CONDITION_1 WHERE F_FLOAT >= 4.0;
SELECT * FROM T_CONDITION_1 WHERE F_FLOAT = 4.0;
SELECT * FROM T_CONDITION_1 WHERE F_FLOAT <> 4.0;
--SELECT * FROM T_CONDITION_1 WHERE F_INT < 'EFG';
--SELECT * FROM T_CONDITION_1 WHERE F_INT < '100';
--SELECT * FROM T_CONDITION_1 WHERE F_CHAR < 100;
--SELECT * FROM T_CONDITION_1 WHERE F_FLOAT < 'EFG';
--SELECT * FROM T_CONDITION_1 WHERE F_FLOAT < '4.00';

--TEST AND,OR
SELECT * FROM T_CONDITION_1 WHERE F_INT < 4 AND F_CHAR = 'ABC';
SELECT * FROM T_CONDITION_1 WHERE F_INT < 4 AND F_CHAR = 'ABC' AND F_FLOAT < 4.0;
SELECT * FROM T_CONDITION_1 WHERE F_INT < 4 AND F_CHAR = NULL;
SELECT * FROM T_CONDITION_1 WHERE F_INT < 4 AND F_CHAR > NULL AND F_FLOAT < 4.0;
SELECT * FROM T_CONDITION_1 WHERE F_INT < 4 OR F_CHAR = 'ABC';
SELECT * FROM T_CONDITION_1 WHERE F_INT < 4 OR F_CHAR = NULL;
SELECT * FROM T_CONDITION_1 WHERE F_INT < 4 OR F_CHAR = NULL OR F_FLOAT > 5.0;

--not
DROP TABLE IF EXISTS t_temp_1;
CREATE TABLE t_temp_1(F1 int, F2 int);
INSERT INTO t_temp_1 VALUES(1, 11);
INSERT INTO t_temp_1 VALUES(2, 22);
COMMIT;

select f1 from t_temp_1 where (f1>1 and f1<1 and f1=1 and f1>=1 and f1<=1 and f1 != 1);
select f1 from t_temp_1 where (f1>1 or f1<1 or f1=1 or f1>=1 or f1<=1 or f1 != 1);
select f1 from t_temp_1 where (f1>1 or f1<1 and f1=1 or f1>=1 and f1<=1 or f1 != 1);

DROP TABLE IF EXISTS t_temp_1;

select 1 from dual where not 1=1;
select 1 from dual where not 1=2;
select 1 from dual where not (1=2 or 1=1);
select 1 from dual where not (1=2 or 2=1);
select 1 from dual where not(exists(select 1 from dual));
select 1 from dual where not(not exists(select 1 from dual));

select 1 from dual where not(3 in (1,2,3));
select 1 from dual where not (3 not in (1,2,3,null) or 1=1);
select 1 from dual where not (3 not in (1,2,null) or 1=2);
select 1 from dual where  3 not in (1,2,null) or 1=1;
select 1 from dual where  not (3 not in (1,2) or 1=2);
select 1 from dual where 3   in (1,2,null) ;
select 1 from dual where not (3  in (1,2,null) );
select 1 from dual where 3 in (1,2,null) and not 1=2;
select 1 from dual where not (3 not in (1,2,null)) and not 1=2;
select 1 from dual where not(3 not in (1,2,null) or 1=1);
select 1 from dual where 3 in (null, 1,2,3,null);
select 1 from dual where not (1=1 and 2=2);
select 1 from dual where not 1=1 and  not 2=2;
select 1 from dual where  not(not 3 not in (1,2,null));

select 1 from dual where  10  between null and 9;
select 1 from dual where  10 not between null and 9;
select 1 from dual where  1 not between null and 9;

select 1 from dual where  not (10  between null and 9);
select 1 from dual where  not (10 not between null and 9);
select 1 from dual where  not (1 not between null and 9);

select 1 from dual where not( 'a' like null);
select 1 from dual where not ('a' not like null);
select 1 from dual where not('a' not like 'a%');

--TEST [NOT] LIKE
DROP TABLE IF EXISTS T_TEST_LIKE;
CREATE TABLE T_TEST_LIKE(F1 VARCHAR(20), F2 VARCHAR(20));
INSERT INTO T_TEST_LIKE VALUES('ABCDE','ABCDE');
INSERT INTO T_TEST_LIKE VALUES('EFGHL','EFGHL');
INSERT INTO T_TEST_LIKE VALUES('HIJKU','HIJKU');
INSERT INTO T_TEST_LIKE VALUES('WIYTR','WIYTR');
INSERT INTO T_TEST_LIKE VALUES('123456789','123456789');
SELECT * FROM T_TEST_LIKE WHERE F1 LIKE 'AB%';
SELECT * FROM T_TEST_LIKE WHERE F1 NOT LIKE 'AB%';
SELECT * FROM T_TEST_LIKE WHERE F1 LIKE 'EF%%L';
SELECT * FROM T_TEST_LIKE WHERE F1 NOT LIKE 'EF%%L';
SELECT * FROM T_TEST_LIKE WHERE F1 LIKE '1%67%%9';
SELECT * FROM T_TEST_LIKE WHERE F1 NOT LIKE '1%67%%9';
SELECT * FROM T_TEST_LIKE WHERE F1 LIKE '%';
SELECT * FROM T_TEST_LIKE WHERE F1 NOT LIKE '%';
SELECT * FROM T_TEST_LIKE WHERE F1 LIKE '%KU';
SELECT * FROM T_TEST_LIKE WHERE F1 NOT LIKE '%KU';
SELECT * FROM T_TEST_LIKE WHERE F1 LIKE 'AB_';
SELECT * FROM T_TEST_LIKE WHERE F1 NOT LIKE 'AB_';
SELECT * FROM T_TEST_LIKE WHERE F1 LIKE 'EF__L';
SELECT * FROM T_TEST_LIKE WHERE F1 NOT LIKE 'EF__L';
SELECT * FROM T_TEST_LIKE WHERE F1 LIKE '1_67__9';
SELECT * FROM T_TEST_LIKE WHERE F1 NOT LIKE '1_67__9';
SELECT * FROM T_TEST_LIKE WHERE F1 LIKE '_';
SELECT * FROM T_TEST_LIKE WHERE F1 NOT LIKE '_';
SELECT * FROM T_TEST_LIKE WHERE F1 LIKE '_KU';
SELECT * FROM T_TEST_LIKE WHERE F1 NOT LIKE '_KU';
DROP TABLE IF EXISTS T_TEST_LIKE_2;
CREATE TABLE T_TEST_LIKE_2(A VARCHAR(128));
INSERT INTO T_TEST_LIKE_2 VALUES('ABCXXX123');
INSERT INTO T_TEST_LIKE_2 VALUES('ABCXXX%123');
INSERT INTO T_TEST_LIKE_2 VALUES('ABC');
INSERT INTO T_TEST_LIKE_2 VALUES('ABC_XX123');
INSERT INTO T_TEST_LIKE_2 VALUES('ADC_XX123');
INSERT INTO T_TEST_LIKE_2 VALUES('ABCD');
INSERT INTO T_TEST_LIKE_2 VALUES('ABC_%XXX_\123');
INSERT INTO T_TEST_LIKE_2 VALUES('%ABC');
INSERT INTO T_TEST_LIKE_2 VALUES('ABC%');
INSERT INTO T_TEST_LIKE_2 VALUES('123XXXABC');
INSERT INTO T_TEST_LIKE_2 VALUES('%123XXXABC');
INSERT INTO T_TEST_LIKE_2 VALUES('123XXX%ABC');
INSERT INTO T_TEST_LIKE_2 VALUES('123XXXAB%C');
INSERT INTO T_TEST_LIKE_2 VALUES('123XXXABC%');
INSERT INTO T_TEST_LIKE_2 VALUES('ABCXXX123%');
INSERT INTO T_TEST_LIKE_2 VALUES('ABC%XXX123');
INSERT INTO T_TEST_LIKE_2 VALUES('ABC%X123');
INSERT INTO T_TEST_LIKE_2 VALUES('ABCX123');
INSERT INTO T_TEST_LIKE_2 VALUES('ABCX');
INSERT INTO T_TEST_LIKE_2 VALUES('ABCXXX');
INSERT INTO T_TEST_LIKE_2 VALUES('ABCXXX123XXX456');
INSERT INTO T_TEST_LIKE_2 VALUES('ABCXXX%123XXX456');
INSERT INTO T_TEST_LIKE_2 VALUES('ABCXXX123XXX4');
INSERT INTO T_TEST_LIKE_2 VALUES('\ABCC124123');
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC%123' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC%\%123' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC\\' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABCD%123' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC_%123' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC\_%123' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC\_\%%\_\\123' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC\%123' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE '\%ABC%' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE '%\%ABC' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE '%ABC' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC%' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE '\%%ABC' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE '%\%ABC' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE '%AB\%C' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE '%ABC\%' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC%\%' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC\%%' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC%%%123' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC%__123' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC%%_123' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC%__' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC%123%456' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC%\%123%456' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE 'ABC%123%4' ESCAPE '\';
SELECT * FROM T_TEST_LIKE_2 WHERE A LIKE '\\ABC%123' ESCAPE '\';
DROP TABLE IF EXISTS T_TEST_LIKE_2;

--TEST TRUE AND FALSE
SELECT 1 FROM DUAL WHERE TRUE;
SELECT 1 FROM DUAL WHERE FALSE;
SELECT 1 FROM DUAL WHERE TRUE AND FALSE;
SELECT 1 FROM DUAL WHERE TRUE OR FALSE;
SELECT F_INT FROM T_CONDITION_1 WHERE TRUE AND F_INT = 1;
SELECT F_INT FROM T_CONDITION_1 WHERE F_INT = 1 AND FALSE;
SELECT F_INT FROM T_CONDITION_1 WHERE F_INT = 1 OR TRUE ORDER BY F_INT;
SELECT F_INT FROM T_CONDITION_1 WHERE F_INT = 1 OR FALSE;
SELECT F_INT FROM T_CONDITION_1 GROUP BY F_INT HAVING TRUE AND F_INT = 1;
SELECT F_INT FROM T_CONDITION_1 GROUP BY F_INT HAVING F_INT = 1 AND FALSE;
SELECT F_INT FROM T_CONDITION_1 GROUP BY F_INT HAVING F_INT = 1 OR TRUE;
SELECT F_INT FROM T_CONDITION_1 GROUP BY F_INT HAVING F_INT = 1 OR FALSE;

--TEST IS [NOT] NULL
SELECT 1 FROM DUAL WHERE (2) IS NULL;
SELECT 1 FROM DUAL WHERE (-2) IS NOT NULL;
SELECT F_INT FROM T_CONDITION_1 WHERE (F_INT) IS NULL;
SELECT F_INT FROM T_CONDITION_1 WHERE (F_INT) IS NOT NULL ORDER BY F_INT;
SELECT F_INT FROM T_CONDITION_1 WHERE (-F_INT) IS NULL;
SELECT F_INT FROM T_CONDITION_1 WHERE (-F_INT) IS NOT NULL ORDER BY F_INT;
SELECT F_INT FROM T_CONDITION_1 WHERE (F_INT+1) IS NULL;

--DROP TABLES
DROP TABLE IF EXISTS T_CONDITION_1;
DROP TABLE IF EXISTS T_CONDITION_2;
DROP TABLE IF EXISTS T_CONDITION_3;
DROP TABLE IF EXISTS T_CONDITION_4;
DROP TABLE IF EXISTS T_TEST_LIKE;

--DTS2019032601535  DTS2019032602165
Drop table if exists test_tt;
Create table test_tt(f1 int);
Insert into test_tt values(1);
Create index t1_indx on test_tt(f1);
Select * from test_tt where f1 in (999999999999999999,'aa');
Drop table test_tt;

--DTS2019041206092
drop table if exists t_all_base_001;
create table t_all_base_001(id int);
insert into t_all_base_001 values(1);
insert into t_all_base_001 values(2);
select t1.id,t2.id from t_all_base_001 t1 left join t_all_base_001 t2 on t2.id<all((select sum(id) from t_all_base_001),(select * from (select id from t_all_base_001 order by 1) where rownum=1));
drop table t_all_base_001;

drop table if exists warehouse;
create table warehouse
(
    w_warehouse_sk            integer               not null,
    w_warehouse_id            char(16)              not null,
    w_warehouse_name          varchar(20)                   ,
    w_warehouse_sq_ft         integer                       ,
    w_street_number           char(10)                      ,
    w_street_name             varchar(60)                   ,
    w_street_type             char(15)                      ,
    w_suite_number            char(10)                      ,
    w_city                    varchar(60)                   ,
    w_county                  varchar(30)                   ,
    w_state                   char(2)                       ,
    w_zip                     char(10)                      ,
    w_country                 varchar(20)                   ,
    w_gmt_offset              decimal(5,2)
 );
drop table if exists catalog_page;
create table catalog_page
(
    cp_catalog_page_sk        integer               not null,
    cp_catalog_page_id        char(16)              not null,
    cp_start_date_sk          integer                       ,
    cp_end_date_sk            integer                       ,
    cp_department             varchar(50)                   ,
    cp_catalog_number         integer                       ,
    cp_catalog_page_number    integer                       ,
    cp_description            varchar(100)                  ,
    cp_type                   varchar(100)
 );
drop table if exists income_band;
create table income_band
(
    ib_income_band_sk         integer               not null,
    ib_lower_bound            integer                       ,
    ib_upper_bound            integer
 );
 drop table if exists reason;
create table reason
(
    r_reason_sk               integer               not null,
    r_reason_id               char(16)              not null,
    r_reason_desc             char(100)
 );
 drop table if exists household_demographics;
create table household_demographics
(
    hd_demo_sk                integer               not null,
    hd_income_band_sk         integer                       ,
    hd_buy_potential          char(15)                      ,
    hd_dep_count              integer                       ,
    hd_vehicle_count          integer
 );
 drop table if exists item;
create table item
(
    i_item_sk                 integer               not null,
    i_item_id                 char(16)              not null,
    i_rec_start_date          date                          ,
    i_rec_end_date            date                          ,
    i_item_desc               varchar(200)                  ,
    i_current_price           decimal(7,2)                  ,
    i_wholesale_cost          decimal(7,2)                  ,
    i_brand_id                integer                       ,
    i_brand                   char(50)                      ,
    i_class_id                integer                       ,
    i_class                   char(50)                      ,
    i_category_id             integer                       ,
    i_category                char(50)                      ,
    i_manufact_id             integer                       ,
    i_manufact                char(50)                      ,
    i_size                    char(20)                      ,
    i_formulation             char(20)                      ,
    i_color                   char(20)                      ,
    i_units                   char(10)                      ,
    i_container               char(10)                      ,
    i_manager_id              integer                       ,
    i_product_name            char(50)
);

drop table if exists ship_mode;
create table ship_mode
(
    sm_ship_mode_sk           integer               not null,
    sm_ship_mode_id           char(16)              not null,
    sm_type                   char(30)                      ,
    sm_code                   char(10)                      ,
    sm_carrier                char(20)                      ,
    sm_contract               char(20)
);

 select /*+hashjoin(warehouse ship_mode)*/ count(w_warehouse_sk),w_warehouse_id, w_warehouse_name from warehouse
 where w_warehouse_sk  in (select cast(r_reason_sk as char(2)) from reason where r_reason_sk>'5')
 or right(replace(w_warehouse_id,'A','1'),1)  in (select /*+blockname (ship_mode)*/   sm_ship_mode_id from ship_mode group by sm_ship_mode_id having avg(sm_ship_mode_sk)>'10')
 group by w_warehouse_id, w_warehouse_name order by 1,2,3;
 
 
 select  /*+leading(warehouse catalog_page) hashjoin(catalog_page income_band) rows(catalog_page warehouse #2)*/ (w_warehouse_sk),replace(w_warehouse_id,'A','1') from warehouse
 where w_warehouse_sk in (select /*+blockname(catalog_page)*/  cp_catalog_page_sk from catalog_page group by cp_catalog_page_sk)
 and left (replace(w_warehouse_id,'A','1'),1) in (select /*+blockname(income_band)*/ ib_income_band_sk from income_band ) order by 1,2;

select /*+hashjoin(warehouse ship_mode reason )*/ count(w_warehouse_sk),w_warehouse_id, w_warehouse_name from warehouse
 where w_warehouse_sk not in (select /*+blockname (reason)*/  cast(r_reason_sk as char) from reason) or right(replace(w_warehouse_id,'A','1'),1)
 not in (select /*+blockname (ship_mode)*/   sm_ship_mode_id from ship_mode group by sm_ship_mode_id having avg(sm_ship_mode_sk)>'10')
 group by w_warehouse_id, w_warehouse_name order by 1,2,3;
 
select  /*+leading(warehouse catalog_page) hashjoin(catalog_page income_band) rows(catalog_page warehouse #2)*/ (w_warehouse_sk),replace(w_warehouse_id,'A','1') from warehouse
 where w_warehouse_sk in (select /*+blockname(catalog_page)*/  cp_catalog_page_sk from catalog_page where cp_catalog_page_id=w_warehouse_id)
 and left (replace(w_warehouse_id,'A','1'),1) in (select /*+blockname(income_band)*/ ib_income_band_sk from income_band where ib_income_band_sk = w_warehouse_sk) order by 1,2;

select  /*+leading(warehouse catalog_page) hashjoin(catalog_page income_band) rows(catalog_page warehouse #2)*/ trim(w_warehouse_sk),replace(w_warehouse_id,'A','1') from warehouse
 where w_warehouse_sk in (select /*+blockname(catalog_page)*/  cp_catalog_page_sk from catalog_page where cp_catalog_page_id=w_warehouse_id)
 and left (replace(w_warehouse_id,'A','1'),1) in (select /*+blockname(income_band)*/ ib_income_band_sk from income_band where ib_income_band_sk = w_warehouse_sk) order by 1,2;

select w_warehouse_sk,replace(w_warehouse_id,'A','1') from warehouse
 where w_warehouse_sk in (select cp_catalog_page_sk from catalog_page where cp_catalog_page_id=w_warehouse_id)
 and left (replace(w_warehouse_id,'A','1'),1) in (select ib_income_band_sk from income_band where ib_income_band_sk = w_warehouse_sk) order by 1,2;

select count(w_warehouse_sk),w_warehouse_id, w_warehouse_name from warehouse
 where w_warehouse_sk not in (select cast(r_reason_sk as char) from reason where r_reason_sk>'5')
 and right(replace(w_warehouse_id,'A','1'),1) not  in (select sm_ship_mode_id from ship_mode group by sm_ship_mode_id having avg(sm_ship_mode_sk)>'10')
 group by w_warehouse_id, w_warehouse_name order by 1,2,3;

select sum(hd_demo_sk),
case when i_item_sk is not null
  and left(i_item_sk,2)=18
   then i_item_sk
     when (select count(*) from household_demographics)>100
          then (select avg(hd_demo_sk) from household_demographics)
       else null end
 from (select hd_demo_sk,hd_income_band_sk,hd_buy_potential,hd_dep_count from household_demographics)A
 full join item on hd_demo_sk=i_item_sk
 group by hd_demo_sk,i_rec_start_date,i_rec_end_date,i_item_sk ,hd_income_band_sk
 having  hd_income_band_sk between 1 and 2
 and sum(hd_demo_sk)<50
 order by 1,2; 
 
drop table if exists warehouse;
drop table if exists catalog_page;
drop table if exists income_band;
drop table if exists reason;
drop table if exists household_demographics;
drop table if exists item;
drop table if exists ship_mode;

drop table if exists  t_in_base_001;
create table t_in_base_001(id int,c_int int not null primary key,c_vchar varchar(100),c_clob clob,c_blob blob,c_date date);  
create index idx_in_base_001_2 on t_in_base_001(c_int,c_vchar);
create index idx_in_base_001_3 on t_in_base_001(c_int,c_vchar,c_date);
insert into t_in_base_001 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_in_base_001 values('',997,'','','','');
insert into t_in_base_001 values(null,998,null,null,null,null);
CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
        sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_vchar||'||i||',c_clob||'||i||',c_blob'||',c_date from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/
exec proc_insert('t_in_base_001',1,20);
commit;

select count(*) from t_in_base_001 t1 where
(select t1.id+t3.id-t1.id from t_in_base_001 t2,t_in_base_001 t3 where t1.id=t2.id and t1.id=t3.id and t1.c_date=t2.c_date and t1.c_int=t3.c_int and t3.id=t2.id or t1.c_vchar=t3.c_vchar and t2.id=t3.id and t1.c_vchar||t1.c_vchar=t3.c_vchar||t2.c_vchar) in(select id from t_in_base_001 t2 where t1.id=id
and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id
and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id and (select t1.id+t2.id+id from t_in_base_001 t3 where t2.id=id) in(select id+t2.id+t1.id from t_in_base_001 t4 where t4.id=t2.id)))))))))))))))))))))))))));
drop table t_in_base_001 purge;
drop procedure proc_insert;

drop table if exists offset_tab;
create table offset_tab(a int);
insert into offset_tab values(4);
commit;
select * from offset_tab where 1=1 offset 0;
select * from offset_tab where 1=1 offset 0 limit 1 ;
drop table if exists offset_tab;

--regexp
create table regexp_kkk3 (a char(15), b int, c varchar(15));
insert into regexp_kkk3 values ('23', 888, 'abcd');
insert into regexp_kkk3 values ('joy', 888, 'abcd');
insert into regexp_kkk3 values ('amy', 999, 'hunki');
insert into regexp_kkk3 values ('amy', 333, 'kpp');
--basic regexp
select b from regexp_kkk3 where a regexp 'amy' order by c;
select b from regexp_kkk3 where 'amy' regexp a order by c;
select a from regexp_kkk3 where b regexp 888 order by a;
select a from regexp_kkk3 where 90 regexp 90 order by a;
--or regexp
select a from regexp_kkk3 where 90 regexp 90|80 order by a;
select a from regexp_kkk3 where 90 regexp 70|80 order by a;
select a from regexp_kkk3 where b regexp b|65 order by a;
select a from regexp_kkk3 where 'dfg' regexp 'dfg|98' order by a;
--20200612
select  
  ref_0.GRANTOR as c0, ref_0.GRANTOR as c1, ref_0.UID as c2, ref_0.GRANTOR as c3, ref_0.GRANTOR as c5
from SYS.SYS_USER_PRIVS as ref_0 where EXISTS (
  select ref_0.GRANTOR as c0, subq_0.c4 as c1, (select UID from SYS.SYS_USER_PRIVS limit 1 offset 26) as c2
    from (select ref_0.GRANTOR as c0, 37 as c1, ref_0.GRANTOR as c2, ref_1.GRANTOR as c3, ref_0.GRANTOR as c4
          from (SYS.SYS_USER_PRIVS as ref_1)
              left join (SYS.SYS_USER_PRIVS as ref_2)
              on (ref_1.GRANTOR = ref_2.UID )
          where ((true) and (EXISTS ( select ref_1.UID as c0, ref_0.GRANTOR as c1, ref_0.GRANTOR as c2, ref_1.UID as c3
                  from SYS.SYS_USER_PRIVS as ref_3
                  where ref_2.GRANTOR is not NULL))) 
            or ((((false) and (true)) and (ref_1.GRANTOR is not NULL)) 
              or (ref_1.UID is NULL))) as subq_0
    where (case when subq_0.c2 is NULL then (select GRANTOR from SYS.SYS_USER_PRIVS limit 1 offset 5)
             else (select GRANTOR from SYS.SYS_USER_PRIVS limit 1 offset 5) end is NULL) 
      and (case when EXISTS ( select ref_0.GRANTOR as c0, ref_4.GRANTOR as c1, subq_0.c1 as c2, ref_0.GRANTOR as c3, ref_4.GRANTOR as c4
              from SYS.SYS_USER_PRIVS as ref_4
              where (((ref_4.GRANTOR is not NULL) 
                    and (ref_4.GRANTOR is not NULL)) 
                  and (((((false) 
                          and (subq_0.c4 is NULL)) 
                        or (ref_0.GRANTOR is NULL)) 
                      or (true)) 
                    or (ref_4.GRANTOR is NULL))) 
                and (subq_0.c1 is not NULL)
              limit 109) then subq_0.c2 else subq_0.c2 end
           is NULL)    limit 102)limit 99;
select  
  ref_0.GRANTOR as c0, ref_0.GRANTOR as c1, ref_0.UID as c2, ref_0.GRANTOR as c3, ref_0.GRANTOR as c5
from SYS.SYS_USER_PRIVS as ref_0 where EXISTS (
  select ref_0.GRANTOR as c0, subq_0.c4 as c1, (select UID from SYS.SYS_USER_PRIVS limit 1 offset 26) as c2
    from (select ref_0.GRANTOR as c0, 37 as c1, ref_0.GRANTOR as c2, ref_1.GRANTOR as c3, ref_0.GRANTOR as c4
          from (SYS.SYS_USER_PRIVS as ref_1)
              left join (SYS.SYS_USER_PRIVS as ref_2)
              on (ref_1.GRANTOR = ref_2.UID )
          where ((true) and (EXISTS ( select ref_1.UID as c0, ref_0.GRANTOR as c1, ref_0.GRANTOR as c2, ref_1.UID as c3
                  from SYS.SYS_USER_PRIVS as ref_3
                  where ref_2.GRANTOR is not NULL))) 
            or ((((false) and (true)) and (ref_1.GRANTOR is not NULL)) 
              or (ref_1.UID is NULL))) as subq_0
    where (case when subq_0.c2 is NULL then (select GRANTOR from SYS.SYS_USER_PRIVS limit 1 offset 5)
             else (select GRANTOR from SYS.SYS_USER_PRIVS limit 1 offset 5) end is NULL) 
      and (case when EXISTS ( select ref_0.GRANTOR as c0, ref_4.GRANTOR as c1, subq_0.c1 as c2, ref_0.GRANTOR as c3, ref_4.GRANTOR as c4
              from SYS.SYS_USER_PRIVS as ref_4
              where (((ref_4.GRANTOR is not NULL) 
                    and (ref_4.GRANTOR is not NULL)) 
                  and (((((false) 
                          and (subq_0.c4 is NULL)) 
                        or (ref_0.GRANTOR is NULL)) 
                      or (true)) 
                    or (ref_4.GRANTOR is NULL))) 
                and (subq_0.c1 is not NULL)
              limit 109) then subq_0.c2 else subq_0.c2 end
           is NULL)    limit 102)limit 99;
select  
  ref_0.GRANTOR as c0, ref_0.GRANTOR as c1, ref_0.UID as c2, ref_0.GRANTOR as c3, ref_0.GRANTOR as c5
from SYS.SYS_USER_PRIVS as ref_0 where EXISTS (
  select ref_0.GRANTOR as c0, subq_0.c4 as c1, (select UID from SYS.SYS_USER_PRIVS limit 1 offset 26) as c2
    from (select ref_0.GRANTOR as c0, 37 as c1, ref_0.GRANTOR as c2, ref_1.GRANTOR as c3, ref_0.GRANTOR as c4
          from (SYS.SYS_USER_PRIVS as ref_1)
              left join (SYS.SYS_USER_PRIVS as ref_2)
              on (ref_1.GRANTOR = ref_2.UID )
          where ((true) and (EXISTS ( select ref_1.UID as c0, ref_0.GRANTOR as c1, ref_0.GRANTOR as c2, ref_1.UID as c3
                  from SYS.SYS_USER_PRIVS as ref_3
                  where ref_2.GRANTOR is not NULL))) 
            or ((((false) and (true)) and (ref_1.GRANTOR is not NULL)) 
              or (ref_1.UID is NULL))) as subq_0
    where (case when subq_0.c2 is NULL then (select GRANTOR from SYS.SYS_USER_PRIVS limit 1 offset 5)
             else (select GRANTOR from SYS.SYS_USER_PRIVS limit 1 offset 5) end is NULL) 
      and (case when EXISTS ( select ref_0.GRANTOR as c0, ref_4.GRANTOR as c1, subq_0.c1 as c2, ref_0.GRANTOR as c3, ref_4.GRANTOR as c4
              from SYS.SYS_USER_PRIVS as ref_4
              where (((ref_4.GRANTOR is not NULL) 
                    and (ref_4.GRANTOR is not NULL)) 
                  and (((((false) 
                          and (subq_0.c4 is NULL)) 
                        or (ref_0.GRANTOR is NULL)) 
                      or (true)) 
                    or (ref_4.GRANTOR is NULL))) 
                and (subq_0.c1 is not NULL)
              limit 109) then subq_0.c2 else subq_0.c2 end
           is NULL)    limit 102)limit 99;
select  
  ref_0.GRANTOR as c0, ref_0.GRANTOR as c1, ref_0.UID as c2, ref_0.GRANTOR as c3, ref_0.GRANTOR as c5
from SYS.SYS_USER_PRIVS as ref_0 where EXISTS (
  select ref_0.GRANTOR as c0, subq_0.c4 as c1, (select UID from SYS.SYS_USER_PRIVS limit 1 offset 26) as c2
    from (select ref_0.GRANTOR as c0, 37 as c1, ref_0.GRANTOR as c2, ref_1.GRANTOR as c3, ref_0.GRANTOR as c4
          from (SYS.SYS_USER_PRIVS as ref_1)
              left join (SYS.SYS_USER_PRIVS as ref_2)
              on (ref_1.GRANTOR = ref_2.UID )
          where ((true) and (EXISTS ( select ref_1.UID as c0, ref_0.GRANTOR as c1, ref_0.GRANTOR as c2, ref_1.UID as c3
                  from SYS.SYS_USER_PRIVS as ref_3
                  where ref_2.GRANTOR is not NULL))) 
            or ((((false) and (true)) and (ref_1.GRANTOR is not NULL)) 
              or (ref_1.UID is NULL))) as subq_0
    where (case when subq_0.c2 is NULL then (select GRANTOR from SYS.SYS_USER_PRIVS limit 1 offset 5)
             else (select GRANTOR from SYS.SYS_USER_PRIVS limit 1 offset 5) end is NULL) 
      and (case when EXISTS ( select ref_0.GRANTOR as c0, ref_4.GRANTOR as c1, subq_0.c1 as c2, ref_0.GRANTOR as c3, ref_4.GRANTOR as c4
              from SYS.SYS_USER_PRIVS as ref_4
              where (((ref_4.GRANTOR is not NULL) 
                    and (ref_4.GRANTOR is not NULL)) 
                  and (((((false) 
                          and (subq_0.c4 is NULL)) 
                        or (ref_0.GRANTOR is NULL)) 
                      or (true)) 
                    or (ref_4.GRANTOR is NULL))) 
                and (subq_0.c1 is not NULL)
              limit 109) then subq_0.c2 else subq_0.c2 end
           is NULL)    limit 102)limit 99;
select  
  ref_0.GRANTOR as c0, ref_0.GRANTOR as c1, ref_0.UID as c2, ref_0.GRANTOR as c3, ref_0.GRANTOR as c5
from SYS.SYS_USER_PRIVS as ref_0 where EXISTS (
  select ref_0.GRANTOR as c0, subq_0.c4 as c1, (select UID from SYS.SYS_USER_PRIVS limit 1 offset 26) as c2
    from (select ref_0.GRANTOR as c0, 37 as c1, ref_0.GRANTOR as c2, ref_1.GRANTOR as c3, ref_0.GRANTOR as c4
          from (SYS.SYS_USER_PRIVS as ref_1)
              left join (SYS.SYS_USER_PRIVS as ref_2)
              on (ref_1.GRANTOR = ref_2.UID )
          where ((true) and (EXISTS ( select ref_1.UID as c0, ref_0.GRANTOR as c1, ref_0.GRANTOR as c2, ref_1.UID as c3
                  from SYS.SYS_USER_PRIVS as ref_3
                  where ref_2.GRANTOR is not NULL))) 
            or ((((false) and (true)) and (ref_1.GRANTOR is not NULL)) 
              or (ref_1.UID is NULL))) as subq_0
    where (case when subq_0.c2 is NULL then (select GRANTOR from SYS.SYS_USER_PRIVS limit 1 offset 5)
             else (select GRANTOR from SYS.SYS_USER_PRIVS limit 1 offset 5) end is NULL) 
      and (case when EXISTS ( select ref_0.GRANTOR as c0, ref_4.GRANTOR as c1, subq_0.c1 as c2, ref_0.GRANTOR as c3, ref_4.GRANTOR as c4
              from SYS.SYS_USER_PRIVS as ref_4
              where (((ref_4.GRANTOR is not NULL) 
                    and (ref_4.GRANTOR is not NULL)) 
                  and (((((false) 
                          and (subq_0.c4 is NULL)) 
                        or (ref_0.GRANTOR is NULL)) 
                      or (true)) 
                    or (ref_4.GRANTOR is NULL))) 
                and (subq_0.c1 is not NULL)
              limit 109) then subq_0.c2 else subq_0.c2 end
           is NULL)    limit 102)limit 99;
select  
  ref_0.GRANTOR as c0, ref_0.GRANTOR as c1, ref_0.UID as c2, ref_0.GRANTOR as c3, ref_0.GRANTOR as c5
from SYS.SYS_USER_PRIVS as ref_0 where EXISTS (
  select ref_0.GRANTOR as c0, subq_0.c4 as c1, (select UID from SYS.SYS_USER_PRIVS limit 1 offset 26) as c2
    from (select ref_0.GRANTOR as c0, 37 as c1, ref_0.GRANTOR as c2, ref_1.GRANTOR as c3, ref_0.GRANTOR as c4
          from (SYS.SYS_USER_PRIVS as ref_1)
              left join (SYS.SYS_USER_PRIVS as ref_2)
              on (ref_1.GRANTOR = ref_2.UID )
          where ((true) and (EXISTS ( select ref_1.UID as c0, ref_0.GRANTOR as c1, ref_0.GRANTOR as c2, ref_1.UID as c3
                  from SYS.SYS_USER_PRIVS as ref_3
                  where ref_2.GRANTOR is not NULL))) 
            or ((((false) and (true)) and (ref_1.GRANTOR is not NULL)) 
              or (ref_1.UID is NULL))) as subq_0
    where (case when subq_0.c2 is NULL then (select GRANTOR from SYS.SYS_USER_PRIVS limit 1 offset 5)
             else (select GRANTOR from SYS.SYS_USER_PRIVS limit 1 offset 5) end is NULL) 
      and (case when EXISTS ( select ref_0.GRANTOR as c0, ref_4.GRANTOR as c1, subq_0.c1 as c2, ref_0.GRANTOR as c3, ref_4.GRANTOR as c4
              from SYS.SYS_USER_PRIVS as ref_4
              where (((ref_4.GRANTOR is not NULL) 
                    and (ref_4.GRANTOR is not NULL)) 
                  and (((((false) 
                          and (subq_0.c4 is NULL)) 
                        or (ref_0.GRANTOR is NULL)) 
                      or (true)) 
                    or (ref_4.GRANTOR is NULL))) 
                and (subq_0.c1 is not NULL)
              limit 109) then subq_0.c2 else subq_0.c2 end
           is NULL)    limit 102)limit 99;
select  
  ref_0.GRANTOR as c0, ref_0.GRANTOR as c1, ref_0.UID as c2, ref_0.GRANTOR as c3, ref_0.GRANTOR as c5
from SYS.SYS_USER_PRIVS as ref_0 where EXISTS (
  select ref_0.GRANTOR as c0, subq_0.c4 as c1, (select UID from SYS.SYS_USER_PRIVS limit 1 offset 26) as c2
    from (select ref_0.GRANTOR as c0, 37 as c1, ref_0.GRANTOR as c2, ref_1.GRANTOR as c3, ref_0.GRANTOR as c4
          from (SYS.SYS_USER_PRIVS as ref_1)
              left join (SYS.SYS_USER_PRIVS as ref_2)
              on (ref_1.GRANTOR = ref_2.UID )
          where ((true) and (EXISTS ( select ref_1.UID as c0, ref_0.GRANTOR as c1, ref_0.GRANTOR as c2, ref_1.UID as c3
                  from SYS.SYS_USER_PRIVS as ref_3
                  where ref_2.GRANTOR is not NULL))) 
            or ((((false) and (true)) and (ref_1.GRANTOR is not NULL)) 
              or (ref_1.UID is NULL))) as subq_0
    where (case when subq_0.c2 is NULL then (select GRANTOR from SYS.SYS_USER_PRIVS limit 1 offset 5)
             else (select GRANTOR from SYS.SYS_USER_PRIVS limit 1 offset 5) end is NULL) 
      and (case when EXISTS ( select ref_0.GRANTOR as c0, ref_4.GRANTOR as c1, subq_0.c1 as c2, ref_0.GRANTOR as c3, ref_4.GRANTOR as c4
              from SYS.SYS_USER_PRIVS as ref_4
              where (((ref_4.GRANTOR is not NULL) 
                    and (ref_4.GRANTOR is not NULL)) 
                  and (((((false) 
                          and (subq_0.c4 is NULL)) 
                        or (ref_0.GRANTOR is NULL)) 
                      or (true)) 
                    or (ref_4.GRANTOR is NULL))) 
                and (subq_0.c1 is not NULL)
              limit 109) then subq_0.c2 else subq_0.c2 end
           is NULL)    limit 102)limit 99;
--DTS2020031805402
drop table if exists t_DTS2020031805402;
create table t_DTS2020031805402(a int);
select * from t_DTS2020031805402  where(a=9832) or(a=9831) or(a=9830) or(a=9829) or(a=9828) or(a=9827) or(a=9826) or(a=9825) or(a=9824) or(a=9823) or(a=9822) or(a=9821) or(a=9820) or(a=9819) or(a=9818) or(a=9817) or(a=9816) or(a=9815) or
(a=9814) or(a=9813) or(a=9812) or(a=9811) or(a=9810) or(a=9809) or(a=9808) or(a=9807) or(a=9806) or(a=9805) or(a=9804) or(a=9803) or(a=9802) or(a=9801) or(a=9800) or(a=9799) or(a=9798) or(a=9797) or
(a=9796) or(a=9795) or(a=9794) or(a=9793) or(a=9792) or(a=9791) or(a=9790) or(a=9789) or(a=9788) or(a=9787) or(a=9786) or(a=9785) or(a=9784) or(a=9783) or(a=9782) or(a=9781) or(a=9780) or(a=9779) or
(a=9778) or(a=9777) or(a=9776) or(a=9775) or(a=9774) or(a=9773) or(a=9772) or(a=9771) or(a=9770) or(a=9769) or(a=9768) or(a=9767) or(a=9766) or(a=9765) or(a=9764) or(a=9763) or(a=9762) or(a=9761) or
(a=9760) or(a=9759) or(a=9758) or(a=9757) or(a=9756) or(a=9755) or(a=9754) or(a=9753) or(a=9752) or(a=9751) or(a=9750) or(a=9749) or(a=9748) or(a=9747) or(a=9746) or(a=9745) or(a=9744) or(a=9743) or
(a=9742) or(a=9741) or(a=9740) or(a=9739) or(a=9738) or(a=9737) or(a=9736) or(a=9735) or(a=9734) or(a=9733) or(a=9732) or(a=9731) or(a=9730) or(a=9729) or(a=9728) or(a=9727) or(a=9726) or(a=9725) or
(a=9724) or(a=9723) or(a=9722) or(a=9721) or(a=9720) or(a=9719) or(a=9718) or(a=9717) or(a=9716) or(a=9715) or(a=9714) or(a=9713) or(a=9712) or(a=9711) or(a=9710) or(a=9709) or(a=9708) or(a=9707) or
(a=9706) or(a=9705) or(a=9704) or(a=9703) or(a=9702) or(a=9701) or(a=9700) or(a=9699) or(a=9698) or(a=9697) or(a=9696) or(a=9695) or(a=9694) or(a=9693) or(a=9692) or(a=9691) or(a=9690) or(a=9689) or
(a=9688) or(a=9687) or(a=9686) or(a=9685) or(a=9684) or(a=9683) or(a=9682) or(a=9681) or(a=9680) or(a=9679) or(a=9678) or(a=9677) or(a=9676) or(a=9675) or(a=9674) or(a=9673) or(a=9672) or(a=9671) or
(a=9670) or(a=9669) or(a=9668) or(a=9667) or(a=9666) or(a=9665) or(a=9664) or(a=9663) or(a=9662) or(a=9661) or(a=9660) or(a=9659) or(a=9658) or(a=9657) or(a=9656) or(a=9655) or(a=9654) or(a=9653) or
(a=9652) or(a=9651) or(a=9650) or(a=9649) or(a=9648) or(a=9647) or(a=9646) or(a=9645) or(a=9644) or(a=9643) or(a=9642) or(a=9641) or(a=9640) or(a=9639) or(a=9638) or(a=9637) or(a=9636) or(a=9635) or
(a=9634) or(a=9633) or(a=9632) or(a=9631) or(a=9630) or(a=9629) or(a=9628) or(a=9627) or(a=9626) or(a=9625) or(a=9624) or(a=9623) or(a=9622) or(a=9621) or(a=9620) or(a=9619) or(a=9618) or(a=9617) or
(a=9616) or(a=9615) or(a=9614) or(a=9613) or(a=9612) or(a=9611) or(a=9610) or(a=9609) or(a=9608) or(a=9607) or(a=9606) or(a=9605) or(a=9604) or(a=9603) or(a=9602) or(a=9601) or(a=9600) or(a=9599) or
(a=9598) or(a=9597) or(a=9596) or(a=9595) or(a=9594) or(a=9593) or(a=9592) or(a=9591) or(a=9590) or(a=9589) or(a=9588) or(a=9587) or(a=9586) or(a=9585) or(a=9584) or(a=9583) or(a=9582) or(a=9581) or
(a=9580) or(a=9579) or(a=9578) or(a=9577) or(a=9576) or(a=9575) or(a=9574) or(a=9573) or(a=9572) or(a=9571) or(a=9570) or(a=9569) or(a=9568) or(a=9567) or(a=9566) or(a=9565) or(a=9564) or(a=9563) or
(a=9562) or(a=9561) or(a=9560) or(a=9559) or(a=9558) or(a=9557) or(a=9556) or(a=9555) or(a=9554) or(a=9553) or(a=9552) or(a=9551) or(a=9550) or(a=9549) or(a=9548) or(a=9547) or(a=9546) or(a=9545) or
(a=9544) or(a=9543) or(a=9542) or(a=9541) or(a=9540) or(a=9539) or(a=9538) or(a=9537) or(a=9536) or(a=9535) or(a=9534) or(a=9533) or(a=9532) or(a=9531) or(a=9530) or(a=9529) or(a=9528) or(a=9527) or
(a=9526) or(a=9525) or(a=9524) or(a=9523) or(a=9522) or(a=9521) or(a=9520) or(a=9519) or(a=9518) or(a=9517) or(a=9516) or(a=9515) or(a=9514) or(a=9513) or(a=9512) or(a=9511) or(a=9510) or(a=9509) or
(a=9508) or(a=9507) or(a=9506) or(a=9505) or(a=9504) or(a=9503) or(a=9502) or(a=9501) or(a=9500) or(a=9499) or(a=9498) or(a=9497) or(a=9496) or(a=9495) or(a=9494) or(a=9493) or(a=9492) or(a=9491) or
(a=9490) or(a=9489) or(a=9488) or(a=9487) or(a=9486) or(a=9485) or(a=9484) or(a=9483) or(a=9482) or(a=9481) or(a=9480) or(a=9479) or(a=9478) or(a=9477) or(a=9476) or(a=9475) or(a=9474) or(a=9473) or
(a=9472) or(a=9471) or(a=9470) or(a=9469) or(a=9468) or(a=9467) or(a=9466) or(a=9465) or(a=9464) or(a=9463) or(a=9462) or(a=9461) or(a=9460) or(a=9459) or(a=9458) or(a=9457) or(a=9456) or(a=9455) or
(a=9454) or(a=9453) or(a=9452) or(a=9451) or(a=9450) or(a=9449) or(a=9448) or(a=9447) or(a=9446) or(a=9445) or(a=9444) or(a=9443) or(a=9442) or(a=9441) or(a=9440) or(a=9439) or(a=9438) or(a=9437) or
(a=9436) or(a=9435) or(a=9434) or(a=9433) or(a=9432) or(a=9431) or(a=9430) or(a=9429) or(a=9428) or(a=9427) or(a=9426) or(a=9425) or(a=9424) or(a=9423) or(a=9422) or(a=9421) or(a=9420) or(a=9419) or
(a=9418) or(a=9417) or(a=9416) or(a=9415) or(a=9414) or(a=9413) or(a=9412) or(a=9411) or(a=9410) or(a=9409) or(a=9408) or(a=9407) or(a=9406) or(a=9405) or(a=9404) or(a=9403) or(a=9402) or(a=9401) or
(a=9400) or(a=9399) or(a=9398) or(a=9397) or(a=9396) or(a=9395) or(a=9394) or(a=9393) or(a=9392) or(a=9391) or(a=9390) or(a=9389) or(a=9388) or(a=9387) or(a=9386) or(a=9385) or(a=9384) or(a=9383) or
(a=9382) or(a=9381) or(a=9380) or(a=9379) or(a=9378) or(a=9377) or(a=9376) or(a=9375) or(a=9374) or(a=9373) or(a=9372) or(a=9371) or(a=9370) or(a=9369) or(a=9368) or(a=9367) or(a=9366) or(a=9365) or
(a=9364) or(a=9363) or(a=9362) or(a=9361) or(a=9360) or(a=9359) or(a=9358) or(a=9357) or(a=9356) or(a=9355) or(a=9354) or(a=9353) or(a=9352) or(a=9351) or(a=9350) or(a=9349) or(a=9348) or(a=9347) or
(a=9346) or(a=9345) or(a=9344) or(a=9343) or(a=9342) or(a=9341) or(a=9340) or(a=9339) or(a=9338) or(a=9337) or(a=9336) or(a=9335) or(a=9334) or(a=9333) or(a=9332) or(a=9331) or(a=9330) or(a=9329) or
(a=9328) or(a=9327) or(a=9326) or(a=9325) or(a=9324) or(a=9323) or(a=9322) or(a=9321) or(a=9320) or(a=9319) or(a=9318) or(a=9317) or(a=9316) or(a=9315) or(a=9314) or(a=9313) or(a=9312) or(a=9311) or
(a=9310) or(a=9309) or(a=9308) or(a=9307) or(a=9306) or(a=9305) or(a=9304) or(a=9303) or(a=9302) or(a=9301) or(a=9300) or(a=9299) or(a=9298) or(a=9297) or(a=9296) or(a=9295) or(a=9294) or(a=9293) or
(a=9292) or(a=9291) or(a=9290) or(a=9289) or(a=9288) or(a=9287) or(a=9286) or(a=9285) or(a=9284) or(a=9283) or(a=9282) or(a=9281) or(a=9280) or(a=9279) or(a=9278) or(a=9277) or(a=9276) or(a=9275) or
(a=9274) or(a=9273) or(a=9272) or(a=9271) or(a=9270) or(a=9269) or(a=9268) or(a=9267) or(a=9266) or(a=9265) or(a=9264) or(a=9263) or(a=9262) or(a=9261) or(a=9260) or(a=9259) or(a=9258) or(a=9257) or
(a=9256) or(a=9255) or(a=9254) or(a=9253) or(a=9252) or(a=9251) or(a=9250) or(a=9249) or(a=9248) or(a=9247) or(a=9246) or(a=9245) or(a=9244) or(a=9243) or(a=9242) or(a=9241) or(a=9240) or(a=9239) or
(a=9238) or(a=9237) or(a=9236) or(a=9235) or(a=9234) or(a=9233) or(a=9232) or(a=9231) or(a=9230) or(a=9229) or(a=9228) or(a=9227) or(a=9226) or(a=9225) or(a=9224) or(a=9223) or(a=9222) or(a=9221) or
(a=9220) or(a=9219) or(a=9218) or(a=9217) or(a=9216) or(a=9215) or(a=9214) or(a=9213) or(a=9212) or(a=9211) or(a=9210) or(a=9209) or(a=9208) or(a=9207) or(a=9206) or(a=9205) or(a=9204) or(a=9203) or
(a=9202) or(a=9201) or(a=9200) or(a=9199) or(a=9198) or(a=9197) or(a=9196) or(a=9195) or(a=9194) or(a=9193) or(a=9192) or(a=9191) or(a=9190) or(a=9189) or(a=9188) or(a=9187) or(a=9186) or(a=9185) or
(a=9184) or(a=9183) or(a=9182) or(a=9181) or(a=9180) or(a=9179) or(a=9178) or(a=9177) or(a=9176) or(a=9175) or(a=9174) or(a=9173) or(a=9172) or(a=9171) or(a=9170) or(a=9169) or(a=9168) or(a=9167) or
(a=9166) or(a=9165) or(a=9164) or(a=9163) or(a=9162) or(a=9161) or(a=9160) or(a=9159) or(a=9158) or(a=9157) or(a=9156) or(a=9155) or(a=9154) or(a=9153) or(a=9152) or(a=9151) or(a=9150) or(a=9149) or
(a=9148) or(a=9147) or(a=9146) or(a=9145) or(a=9144) or(a=9143) or(a=9142) or(a=9141) or(a=9140) or(a=9139) or(a=9138) or(a=9137) or(a=9136) or(a=9135) or(a=9134) or(a=9133) or(a=9132) or(a=9131) or
(a=9130) or(a=9129) or(a=9128) or(a=9127) or(a=9126) or(a=9125) or(a=9124) or(a=9123) or(a=9122) or(a=9121) or(a=9120) or(a=9119) or(a=9118) or(a=9117) or(a=9116) or(a=9115) or(a=9114) or(a=9113) or
(a=9112) or(a=9111) or(a=9110) or(a=9109) or(a=9108) or(a=9107) or(a=9106) or(a=9105) or(a=9104) or(a=9103) or(a=9102) or(a=9101) or(a=9100) or(a=9099) or(a=9098) or(a=9097) or(a=9096) or(a=9095) or
(a=9094) or(a=9093) or(a=9092) or(a=9091) or(a=9090) or(a=9089) or(a=9088) or(a=9087) or(a=9086) or(a=9085) or(a=9084) or(a=9083) or(a=9082) or(a=9081) or(a=9080) or(a=9079) or(a=9078) or(a=9077) or
(a=9076) or(a=9075) or(a=9074) or(a=9073) or(a=9072) or(a=9071) or(a=9070) or(a=9069) or(a=9068) or(a=9067) or(a=9066) or(a=9065) or(a=9064) or(a=9063) or(a=9062) or(a=9061) or(a=9060) or(a=9059) or
(a=9058) or(a=9057) or(a=9056) or(a=9055) or(a=9054) or(a=9053) or(a=9052) or(a=9051) or(a=9050) or(a=9049) or(a=9048) or(a=9047) or(a=9046) or(a=9045) or(a=9044) or(a=9043) or(a=9042) or(a=9041) or
(a=9040) or(a=9039) or(a=9038) or(a=9037) or(a=9036) or(a=9035) or(a=9034) or(a=9033) or(a=9032) or(a=9031) or(a=9030) or(a=9029) or(a=9028) or(a=9027) or(a=9026) or(a=9025) or(a=9024) or(a=9023) or
(a=9022) or(a=9021) or(a=9020) or(a=9019) or(a=9018) or(a=9017) or(a=9016) or(a=9015) or(a=9014) or(a=9013) or(a=9012) or(a=9011) or(a=9010) or(a=9009) or(a=9008) or(a=9007) or(a=9006) or(a=9005) or(a=9004) or(a=9003) or(a=9002) or
(a=9001) or(a=9000) or(a=8999) or(a=8998) or(a=8997) or(a=8996) or(a=8995) or(a=8994) or(a=8993) or(a=8992) or(a=8991) or(a=8990) or(a=8989) or(a=8988) or(a=8987) or(a=8986) or(a=8985) or(a=8984) or(a=8983) or(a=8982) or(a=8981) or
(a=8980) or(a=8979) or(a=8978) or(a=8977) or(a=8976) or(a=8975) or(a=8974) or(a=8973) or(a=8972) or(a=8971) or(a=8970) or(a=8969) or(a=8968) or(a=8967) or(a=8966) or(a=8965) or(a=8964) or(a=8963) or(a=8962) or(a=8961) or(a=8960) or
(a=8959) or(a=8958) or(a=8957) or(a=8956) or(a=8955) or(a=8954) or(a=8953) or(a=8952) or(a=8951) or(a=8950) or(a=8949) or(a=8948) or(a=8947) or(a=8946) or(a=8945) or(a=8944) or(a=8943) or(a=8942) or(a=8941) or(a=8940) or(a=8939) or
(a=8938) or(a=8937) or(a=8936) or(a=8935) or(a=8934) or(a=8933) or(a=8932) or(a=8931) or(a=8930) or(a=8929) or(a=8928) or(a=8927) or(a=8926) or(a=8925) or(a=8924) or(a=8923) or(a=8922) or(a=8921) or(a=8920) or(a=8919) or(a=8918) or
(a=8917) or(a=8916) or(a=8915) or(a=8914) or(a=8913) or(a=8912) or(a=8911) or(a=8910) or(a=8909) or(a=8908) or(a=8907) or(a=8906) or(a=8905) or(a=8904) or(a=8903) or(a=8902) or(a=8901) or(a=8900) or(a=8899) or(a=8898) or(a=8897) or(a=8896) or(a=8895) or(a=8894) or(a=8893) or(a=8892) or(a=8891) or(a=8890) or(a=8889) or(a=8888) or
(a=8887) or(a=8886) or(a=8885) or(a=8884) or(a=8883) or(a=8882) or(a=8881) or(a=8880) or(a=8879) or(a=8878) or(a=8877) or(a=8876) or(a=8875) or(a=8874) or(a=8873) or(a=8872) or(a=8871) or(a=8870) or(a=8869) or(a=8868) or(a=8867) or(a=8866) or(a=8865) or(a=8864) or(a=8863) or(a=8862) or(a=8861) or(a=8860) or(a=8859) or(a=8858) or
(a=8857) or(a=8856) or(a=8855) or(a=8854) or(a=8853) or(a=8852) or(a=8851) or(a=8850) or(a=8849) or(a=8848) or(a=8847) or(a=8846) or(a=8845) or(a=8844) or(a=8843) or(a=8842) or(a=8841) or(a=8840) or(a=8839) or(a=8838) or(a=8837) or(a=8836) or(a=8835) or(a=8834) or(a=8833) or(a=8832) or(a=8831) or(a=8830) or(a=8829) or(a=8828) or
(a=8827) or(a=8826) or(a=8825) or(a=8824) or(a=8823) or(a=8822) or(a=8821) or(a=8820) or(a=8819) or(a=8818) or(a=8817) or(a=8816) or(a=8815) or(a=8814) or(a=8813) or(a=8812) or(a=8811) or(a=8810) or(a=8809) or(a=8808) or(a=8807) or(a=8806) or(a=8805) or(a=8804) or(a=8803) or(a=8802) or(a=8801) or(a=8800) or(a=8799) or(a=8798) or
(a=8797) or(a=8796) or(a=8795) or(a=8794) or(a=8793) or(a=8792) or(a=8791) or(a=8790) or(a=8789) or(a=8788) or(a=8787) or(a=8786) or(a=8785) or(a=8784) or(a=8783) or(a=8782) or(a=8781) or(a=8780) or(a=8779) or(a=8778) or(a=8777) or(a=8776) or(a=8775) or(a=8774) or(a=8773) or(a=8772) or(a=8771) or(a=8770) or(a=8769) or(a=8768) or
(a=8767) or(a=8766) or(a=8765) or(a=8764) or(a=8763) or(a=8762) or(a=8761) or(a=8760) or(a=8759) or(a=8758) or(a=8757) or(a=8756) or(a=8755) or(a=8754) or(a=8753) or(a=8752) or(a=8751) or(a=8750) or(a=8749) or(a=8748) or(a=8747) or(a=8746) or(a=8745) or(a=8744) or(a=8743) or(a=8742) or(a=8741) or(a=8740) or(a=8739) or(a=8738) or
(a=8737) or(a=8736) or(a=8735) or(a=8734) or(a=8733) or(a=8732) or(a=8731) or(a=8730) or(a=8729) or(a=8728) or(a=8727) or(a=8726) or(a=8725) or(a=8724) or(a=8723) or(a=8722) or(a=8721) or(a=8720) or(a=8719) or(a=8718) or(a=8717) or(a=8716) or(a=8715) or(a=8714) or(a=8713) or(a=8712) or(a=8711) or(a=8710) or(a=8709) or(a=8708) or
(a=8707) or(a=8706) or(a=8705) or(a=8704) or(a=8703) or(a=8702) or(a=8701) or(a=8700) or(a=8699) or(a=8698) or(a=8697) or(a=8696) or(a=8695) or(a=8694) or(a=8693) or(a=8692) or(a=8691) or(a=8690) or(a=8689) or(a=8688) or(a=8687) or(a=8686) or(a=8685) or(a=8684) or(a=8683) or(a=8682) or(a=8681) or(a=8680) or(a=8679) or(a=8678) or
(a=8677) or(a=8676) or(a=8675) or(a=8674) or(a=8673) or(a=8672) or(a=8671) or(a=8670) or(a=8669) or(a=8668) or(a=8667) or(a=8666) or(a=8665) or(a=8664) or(a=8663) or(a=8662) or(a=8661) or(a=8660) or(a=8659) or(a=8658) or(a=8657) or(a=8656) or(a=8655) or(a=8654) or(a=8653) or(a=8652) or(a=8651) or(a=8650) or(a=8649) or(a=8648) or
(a=8647) or(a=8646) or(a=8645) or(a=8644) or(a=8643) or(a=8642) or(a=8641) or(a=8640) or(a=8639) or(a=8638) or(a=8637) or(a=8636) or(a=8635) or(a=8634) or(a=8633) or(a=8632) or(a=8631) or(a=8630) or(a=8629) or(a=8628) or(a=8627) or(a=8626) or(a=8625) or(a=8624) or(a=8623) or(a=8622) or(a=8621) or(a=8620) or(a=8619) or(a=8618) or
(a=8617) or(a=8616) or(a=8615) or(a=8614) or(a=8613) or(a=8612) or(a=8611) or(a=8610) or(a=8609) or(a=8608) or(a=8607) or(a=8606) or(a=8605) or(a=8604) or(a=8603) or(a=8602) or(a=8601) or(a=8600) or(a=8599) or(a=8598) or(a=8597) or(a=8596) or(a=8595) or(a=8594) or(a=8593) or(a=8592) or(a=8591) or(a=8590) or(a=8589) or(a=8588) or
(a=8587) or(a=8586) or(a=8585) or(a=8584) or(a=8583) or(a=8582) or(a=8581) or(a=8580) or(a=8579) or(a=8578) or(a=8577) or(a=8576) or(a=8575) or(a=8574) or(a=8573) or(a=8572) or(a=8571) or(a=8570) or(a=8569) or(a=8568) or(a=8567) or(a=8566) or(a=8565) or(a=8564) or(a=8563) or(a=8562) or(a=8561) or(a=8560) or(a=8559) or(a=8558) or
(a=8557) or(a=8556) or(a=8555) or(a=8554) or(a=8553) or(a=8552) or(a=8551) or(a=8550) or(a=8549) or(a=8548) or(a=8547) or(a=8546) or(a=8545) or(a=8544) or(a=8543) or(a=8542) or(a=8541) or(a=8540) or(a=8539) or(a=8538) or(a=8537) or(a=8536) or(a=8535) or(a=8534) or(a=8533) or(a=8532) or(a=8531) or(a=8530) or(a=8529) or(a=8528) or
(a=8527) or(a=8526) or(a=8525) or(a=8524) or(a=8523) or(a=8522) or(a=8521) or(a=8520) or(a=8519) or(a=8518) or(a=8517) or(a=8516) or(a=8515) or(a=8514) or(a=8513) or(a=8512) or(a=8511) or(a=8510) or(a=8509) or(a=8508) or(a=8507) or(a=8506) or(a=8505) or(a=8504) or(a=8503) or(a=8502) or(a=8501) or(a=8500) or(a=8499) or(a=8498) or
(a=8497) or(a=8496) or(a=8495) or(a=8494) or(a=8493) or(a=8492) or(a=8491) or(a=8490) or(a=8489) or(a=8488) or(a=8487) or(a=8486) or(a=8485) or(a=8484) or(a=8483) or(a=8482) or(a=8481) or(a=8480) or(a=8479) or(a=8478) or(a=8477) or(a=8476) or(a=8475) or(a=8474) or(a=8473) or(a=8472) or(a=8471) or(a=8470) or(a=8469) or(a=8468) or
(a=8467) or(a=8466) or(a=8465) or(a=8464) or(a=8463) or(a=8462) or(a=8461) or(a=8460) or(a=8459) or(a=8458) or(a=8457) or(a=8456) or(a=8455) or(a=8454) or(a=8453) or(a=8452) or(a=8451) or(a=8450) or(a=8449) or(a=8448) or(a=8447) or(a=8446) or(a=8445) or(a=8444) or(a=8443) or(a=8442) or(a=8441) or(a=8440) or(a=8439) or(a=8438) or
(a=8437) or(a=8436) or(a=8435) or(a=8434) or(a=8433) or(a=8432) or(a=8431) or(a=8430) or(a=8429) or(a=8428) or(a=8427) or(a=8426) or(a=8425) or(a=8424) or(a=8423) or(a=8422) or(a=8421) or(a=8420) or(a=8419) or(a=8418) or(a=8417) or(a=8416) or(a=8415) or(a=8414) or(a=8413) or(a=8412) or(a=8411) or(a=8410) or(a=8409) or(a=8408) or
(a=8407) or(a=8406) or(a=8405) or(a=8404) or(a=8403) or(a=8402) or(a=8401) or(a=8400) or(a=8399) or(a=8398) or(a=8397) or(a=8396) or(a=8395) or(a=8394) or(a=8393) or(a=8392) or(a=8391) or(a=8390) or(a=8389) or(a=8388) or(a=8387) or(a=8386) or(a=8385) or(a=8384) or(a=8383) or(a=8382) or(a=8381) or(a=8380) or(a=8379) or(a=8378) or
(a=8377) or(a=8376) or(a=8375) or(a=8374) or(a=8373) or(a=8372) or(a=8371) or(a=8370) or(a=8369) or(a=8368) or(a=8367) or(a=8366) or(a=8365) or(a=8364) or(a=8363) or(a=8362) or(a=8361) or(a=8360) or(a=8359) or(a=8358) or(a=8357) or(a=8356) or(a=8355) or(a=8354) or(a=8353) or(a=8352) or(a=8351) or(a=8350) or(a=8349) or(a=8348) or
(a=8347) or(a=8346) or(a=8345) or(a=8344) or(a=8343) or(a=8342) or(a=8341) or(a=8340) or(a=8339) or(a=8338) or(a=8337) or(a=8336) or(a=8335) or(a=8334) or(a=8333) or(a=8332) or(a=8331) or(a=8330) or(a=8329) or(a=8328) or(a=8327) or(a=8326) or(a=8325) or(a=8324) or(a=8323) or(a=8322) or(a=8321) or(a=8320) or(a=8319) or(a=8318) or
(a=8317) or(a=8316) or(a=8315) or(a=8314) or(a=8313) or(a=8312) or(a=8311) or(a=8310) or(a=8309) or(a=8308) or(a=8307) or(a=8306) or(a=8305) or(a=8304) or(a=8303) or(a=8302) or(a=8301) or(a=8300) or(a=8299) or(a=8298) or(a=8297) or(a=8296) or(a=8295) or(a=8294) or(a=8293) or(a=8292) or(a=8291) or(a=8290) or(a=8289) or(a=8288) or
(a=8287) or(a=8286) or(a=8285) or(a=8284) or(a=8283) or(a=8282) or(a=8281) or(a=8280) or(a=8279) or(a=8278) or(a=8277) or(a=8276) or(a=8275) or(a=8274) or(a=8273) or(a=8272) or(a=8271) or(a=8270) or(a=8269) or(a=8268) or(a=8267) or(a=8266) or(a=8265) or(a=8264) or(a=8263) or(a=8262) or(a=8261) or(a=8260) or(a=8259) or(a=8258) or
(a=8257) or(a=8256) or(a=8255) or(a=8254) or(a=8253) or(a=8252) or(a=8251) or(a=8250) or(a=8249) or(a=8248) or(a=8247) or(a=8246) or(a=8245) or(a=8244) or(a=8243) or(a=8242) or(a=8241) or(a=8240) or(a=8239) or(a=8238) or(a=8237) or(a=8236) or(a=8235) or(a=8234) or(a=8233) or(a=8232) or(a=8231) or(a=8230) or(a=8229) or(a=8228) or
(a=8227) or(a=8226) or(a=8225) or(a=8224) or(a=8223) or(a=8222) or(a=8221) or(a=8220) or(a=8219) or(a=8218) or(a=8217) or(a=8216) or(a=8215) or(a=8214) or(a=8213) or(a=8212) or(a=8211) or(a=8210) or(a=8209) or(a=8208) or(a=8207) or(a=8206) or(a=8205) or(a=8204) or(a=8203) or(a=8202) or(a=8201) or(a=8200) or(a=8199) or(a=8198) or
(a=8197) or(a=8196) or(a=8195) or(a=8194) or(a=8193) or(a=8192) or(a=8191) or(a=8190) or(a=8189) or(a=8188) or(a=8187) or(a=8186) or(a=8185) or(a=8184) or(a=8183) or(a=8182) or(a=8181) or(a=8180) or(a=8179) or(a=8178) or(a=8177) or(a=8176) or(a=8175) or(a=8174) or(a=8173) or(a=8172) or(a=8171) or(a=8170) or(a=8169) or(a=8168) or
(a=8167) or(a=8166) or(a=8165) or(a=8164) or(a=8163) or(a=8162) or(a=8161) or(a=8160) or(a=8159) or(a=8158) or(a=8157) or(a=8156) or(a=8155) or(a=8154) or(a=8153) or(a=8152) or(a=8151) or(a=8150) or(a=8149) or(a=8148) or(a=8147) or(a=8146) or(a=8145) or(a=8144) or(a=8143) or(a=8142) or(a=8141) or(a=8140) or(a=8139) or(a=8138) or
(a=8137) or(a=8136) or(a=8135) or(a=8134) or(a=8133) or(a=8132) or(a=8131) or(a=8130) or(a=8129) or(a=8128) or(a=8127) or(a=8126) or(a=8125) or(a=8124) or(a=8123) or(a=8122) or(a=8121) or(a=8120) or(a=8119) or(a=8118) or(a=8117) or(a=8116) or(a=8115) or(a=8114) or(a=8113) or(a=8112) or(a=8111) or(a=8110) or(a=8109) or(a=8108) or
(a=8107) or(a=8106) or(a=8105) or(a=8104) or(a=8103) or(a=8102) or(a=8101) or(a=8100) or(a=8099) or(a=8098) or(a=8097) or(a=8096) or(a=8095) or(a=8094) or(a=8093) or(a=8092) or(a=8091) or(a=8090) or(a=8089) or(a=8088) or(a=8087) or(a=8086) or(a=8085) or(a=8084) or(a=8083) or(a=8082) or(a=8081) or(a=8080) or(a=8079) or(a=8078) or
(a=8077) or(a=8076) or(a=8075) or(a=8074) or(a=8073) or(a=8072) or(a=8071) or(a=8070) or(a=8069) or(a=8068) or(a=8067) or(a=8066) or(a=8065) or(a=8064) or(a=8063) or(a=8062) or(a=8061) or(a=8060) or(a=8059) or(a=8058) or(a=8057) or(a=8056) or(a=8055) or(a=8054) or(a=8053) or(a=8052) or(a=8051) or(a=8050) or(a=8049) or(a=8048) or
(a=8047) or(a=8046) or(a=8045) or(a=8044) or(a=8043) or(a=8042) or(a=8041) or(a=8040) or(a=8039) or(a=8038) or(a=8037) or(a=8036) or(a=8035) or(a=8034) or(a=8033) or(a=8032) or(a=8031) or(a=8030) or(a=8029) or(a=8028) or(a=8027) or(a=8026) or(a=8025) or(a=8024) or(a=8023) or(a=8022) or(a=8021) or(a=8020) or(a=8019) or(a=8018) or
(a=8017) or(a=8016) or(a=8015) or(a=8014) or(a=8013) or(a=8012) or(a=8011) or(a=8010) or(a=8009) or(a=8008) or(a=8007) or(a=8006) or(a=8005) or(a=8004) or(a=8003) or(a=8002) or(a=8001) or(a=8000) or(a=7999) or(a=7998) or(a=7997) or(a=7996) or(a=7995) or(a=7994) or(a=7993) or(a=7992) or(a=7991) or(a=7990) or(a=7989) or(a=7988) or
(a=7987) or(a=7986) or(a=7985) or(a=7984) or(a=7983) or(a=7982) or(a=7981) or(a=7980) or(a=7979) or(a=7978) or(a=7977) or(a=7976) or(a=7975) or(a=7974) or(a=7973) or(a=7972) or(a=7971) or(a=7970) or(a=7969) or(a=7968) or(a=7967) or(a=7966) or(a=7965) or(a=7964) or(a=7963) or(a=7962) or(a=7961) or(a=7960) or(a=7959) or(a=7958) or
(a=7957) or(a=7956) or(a=7955) or(a=7954) or(a=7953) or(a=7952) or(a=7951) or(a=7950) or(a=7949) or(a=7948) or(a=7947) or(a=7946) or(a=7945) or(a=7944) or(a=7943) or(a=7942) or(a=7941) or(a=7940) or(a=7939) or(a=7938) or(a=7937) or(a=7936) or(a=7935) or(a=7934) or(a=7933) or(a=7932) or(a=7931) or(a=7930) or(a=7929) or(a=7928) or
(a=7927) or(a=7926) or(a=7925) or(a=7924) or(a=7923) or(a=7922) or(a=7921) or(a=7920) or(a=7919) or(a=7918) or(a=7917) or(a=7916) or(a=7915) or(a=7914) or(a=7913) or(a=7912) or(a=7911) or(a=7910) or(a=7909) or(a=7908) or(a=7907) or(a=7906) or(a=7905) or(a=7904) or(a=7903) or(a=7902) or(a=7901) or(a=7900) or(a=7899) or(a=7898) or
(a=7897) or(a=7896) or(a=7895) or(a=7894) or(a=7893) or(a=7892) or(a=7891) or(a=7890) or(a=7889) or(a=7888) or(a=7887) or(a=7886) or(a=7885) or(a=7884) or(a=7883) or(a=7882) or(a=7881) or(a=7880) or(a=7879) or(a=7878) or(a=7877) or(a=7876) or(a=7875) or(a=7874) or(a=7873) or(a=7872) or(a=7871) or(a=7870) or(a=7869) or(a=7868) or
(a=7867) or(a=7866) or(a=7865) or(a=7864) or(a=7863) or(a=7862) or(a=7861) or(a=7860) or(a=7859) or(a=7858) or(a=7857) or(a=7856) or(a=7855) or(a=7854) or(a=7853) or(a=7852) or(a=7851) or(a=7850) or(a=7849) or(a=7848) or(a=7847) or(a=7846) or(a=7845) or(a=7844) or(a=7843) or(a=7842) or(a=7841) or(a=7840) or(a=7839) or(a=7838) or
(a=7837) or(a=7836) or(a=7835) or(a=7834) or(a=7833) or(a=7832) or(a=7831) or(a=7830) or(a=7829) or(a=7828) or(a=7827) or(a=7826) or(a=7825) or(a=7824) or(a=7823) or(a=7822) or(a=7821) or(a=7820) or(a=7819) or(a=7818) or(a=7817) or(a=7816) or(a=7815) or(a=7814) or(a=7813) or(a=7812) or(a=7811) or(a=7810) or(a=7809) or(a=7808) or
(a=7807) or(a=7806) or(a=7805) or(a=7804) or(a=7803) or(a=7802) or(a=7801) or(a=7800) or(a=7799) or(a=7798) or(a=7797) or(a=7796) or(a=7795) or(a=7794) or(a=7793) or(a=7792) or(a=7791) or(a=7790) or(a=7789) or(a=7788) or(a=7787) or(a=7786) or(a=7785) or(a=7784) or(a=7783) or(a=7782) or(a=7781) or(a=7780) or(a=7779) or(a=7778) or
(a=7777) or(a=7776) or(a=7775) or(a=7774) or(a=7773) or(a=7772) or(a=7771) or(a=7770) or(a=7769) or(a=7768) or(a=7767) or(a=7766) or(a=7765) or(a=7764) or(a=7763) or(a=7762) or(a=7761) or(a=7760) or(a=7759) or(a=7758) or(a=7757) or(a=7756) or(a=7755) or(a=7754) or(a=7753) or(a=7752) or(a=7751) or(a=7750) or(a=7749) or(a=7748) or
(a=7747) or(a=7746) or(a=7745) or(a=7744) or(a=7743) or(a=7742) or(a=7741) or(a=7740) or(a=7739) or(a=7738) or(a=7737) or(a=7736) or(a=7735) or(a=7734) or(a=7733) or(a=7732) or(a=7731) or(a=7730) or(a=7729) or(a=7728) or(a=7727) or(a=7726) or(a=7725) or(a=7724) or(a=7723) or(a=7722) or(a=7721) or(a=7720) or(a=7719) or(a=7718) or
(a=7717) or(a=7716) or(a=7715) or(a=7714) or(a=7713) or(a=7712) or(a=7711) or(a=7710) or(a=7709) or(a=7708) or(a=7707) or(a=7706) or(a=7705) or(a=7704) or(a=7703) or(a=7702) or(a=7701) or(a=7700) or(a=7699) or(a=7698) or(a=7697) or(a=7696) or(a=7695) or(a=7694) or(a=7693) or(a=7692) or(a=7691) or(a=7690) or(a=7689) or(a=7688) or
(a=7687) or(a=7686) or(a=7685) or(a=7684) or(a=7683) or(a=7682) or(a=7681) or(a=7680) or(a=7679) or(a=7678) or(a=7677) or(a=7676) or(a=7675) or(a=7674) or(a=7673) or(a=7672) or(a=7671) or(a=7670) or(a=7669) or(a=7668) or(a=7667) or(a=7666) or(a=7665) or(a=7664) or(a=7663) or(a=7662) or(a=7661) or(a=7660) or(a=7659) or(a=7658) or
(a=7657) or(a=7656) or(a=7655) or(a=7654) or(a=7653) or(a=7652) or(a=7651) or(a=7650) or(a=7649) or(a=7648) or(a=7647) or(a=7646) or(a=7645) or(a=7644) or(a=7643) or(a=7642) or(a=7641) or(a=7640) or(a=7639) or(a=7638) or(a=7637) or(a=7636) or(a=7635) or(a=7634) or(a=7633) or(a=7632) or(a=7631) or(a=7630) or(a=7629) or(a=7628) or
(a=7627) or(a=7626) or(a=7625) or(a=7624) or(a=7623) or(a=7622) or(a=7621) or(a=7620) or(a=7619) or(a=7618) or(a=7617) or(a=7616) or(a=7615) or(a=7614) or(a=7613) or(a=7612) or(a=7611) or(a=7610) or(a=7609) or(a=7608) or(a=7607) or(a=7606) or(a=7605) or(a=7604) or(a=7603) or(a=7602) or(a=7601) or(a=7600) or(a=7599) or(a=7598) or
(a=7597) or(a=7596) or(a=7595) or(a=7594) or(a=7593) or(a=7592) or(a=7591) or(a=7590) or(a=7589) or(a=7588) or(a=7587) or(a=7586) or(a=7585) or(a=7584) or(a=7583) or(a=7582) or(a=7581) or(a=7580) or(a=7579) or(a=7578) or(a=7577) or(a=7576) or(a=7575) or(a=7574) or(a=7573) or(a=7572) or(a=7571) or(a=7570) or(a=7569) or(a=7568) or
(a=7567) or(a=7566) or(a=7565) or(a=7564) or(a=7563) or(a=7562) or(a=7561) or(a=7560) or(a=7559) or(a=7558) or(a=7557) or(a=7556) or(a=7555) or(a=7554) or(a=7553) or(a=7552) or(a=7551) or(a=7550) or(a=7549) or(a=7548) or(a=7547) or(a=7546) or(a=7545) or(a=7544) or(a=7543) or(a=7542) or(a=7541) or(a=7540) or(a=7539) or(a=7538) or
(a=7537) or(a=7536) or(a=7535) or(a=7534) or(a=7533) or(a=7532) or(a=7531) or(a=7530) or(a=7529) or(a=7528) or(a=7527) or(a=7526) or(a=7525) or(a=7524) or(a=7523) or(a=7522) or(a=7521) or(a=7520) or(a=7519) or(a=7518) or(a=7517) or(a=7516) or(a=7515) or(a=7514) or(a=7513) or(a=7512) or(a=7511) or(a=7510) or(a=7509) or(a=7508) or
(a=7507) or(a=7506) or(a=7505) or(a=7504) or(a=7503) or(a=7502) or(a=7501) or(a=7500) or(a=7499) or(a=7498) or(a=7497) or(a=7496) or(a=7495) or(a=7494) or(a=7493) or(a=7492) or(a=7491) or(a=7490) or(a=7489) or(a=7488) or(a=7487) or(a=7486) or(a=7485) or(a=7484) or(a=7483) or(a=7482) or(a=7481) or(a=7480) or(a=7479) or(a=7478) or
(a=7477) or(a=7476) or(a=7475) or(a=7474) or(a=7473) or(a=7472) or(a=7471) or(a=7470) or(a=7469) or(a=7468) or(a=7467) or(a=7466) or(a=7465) or(a=7464) or(a=7463) or(a=7462) or(a=7461) or(a=7460) or(a=7459) or(a=7458) or(a=7457) or(a=7456) or(a=7455) or(a=7454) or(a=7453) or(a=7452) or(a=7451) or(a=7450) or(a=7449) or(a=7448) or
(a=7447) or(a=7446) or(a=7445) or(a=7444) or(a=7443) or(a=7442) or(a=7441) or(a=7440) or(a=7439) or(a=7438) or(a=7437) or(a=7436) or(a=7435) or(a=7434) or(a=7433) or(a=7432) or(a=7431) or(a=7430) or(a=7429) or(a=7428) or(a=7427) or(a=7426) or(a=7425) or(a=7424) or(a=7423) or(a=7422) or(a=7421) or(a=7420) or(a=7419) or(a=7418) or
(a=7417) or(a=7416) or(a=7415) or(a=7414) or(a=7413) or(a=7412) or(a=7411) or(a=7410) or(a=7409) or(a=7408) or(a=7407) or(a=7406) or(a=7405) or(a=7404) or(a=7403) or(a=7402) or(a=7401) or(a=7400) or(a=7399) or(a=7398) or(a=7397) or(a=7396) or(a=7395) or(a=7394) or(a=7393) or(a=7392) or(a=7391) or(a=7390) or(a=7389) or(a=7388) or
(a=7387) or(a=7386) or(a=7385) or(a=7384) or(a=7383) or(a=7382) or(a=7381) or(a=7380) or(a=7379) or(a=7378) or(a=7377) or(a=7376) or(a=7375) or(a=7374) or(a=7373) or(a=7372) or(a=7371) or(a=7370) or(a=7369) or(a=7368) or(a=7367) or(a=7366) or(a=7365) or(a=7364) or(a=7363) or(a=7362) or(a=7361) or(a=7360) or(a=7359) or(a=7358) or
(a=7357) or(a=7356) or(a=7355) or(a=7354) or(a=7353) or(a=7352) or(a=7351) or(a=7350) or(a=7349) or(a=7348) or(a=7347) or(a=7346) or(a=7345) or(a=7344) or(a=7343) or(a=7342) or(a=7341) or(a=7340) or(a=7339) or(a=7338) or(a=7337) or(a=7336) or(a=7335) or(a=7334) or(a=7333) or(a=7332) or(a=7331) or(a=7330) or(a=7329) or(a=7328) or
(a=7327) or(a=7326) or(a=7325) or(a=7324) or(a=7323) or(a=7322) or(a=7321) or(a=7320) or(a=7319) or(a=7318) or(a=7317) or(a=7316) or(a=7315) or(a=7314) or(a=7313) or(a=7312) or(a=7311) or(a=7310) or(a=7309) or(a=7308) or(a=7307) or(a=7306) or(a=7305) or(a=7304) or(a=7303) or(a=7302) or(a=7301) or(a=7300) or(a=7299) or(a=7298) or
(a=7297) or(a=7296) or(a=7295) or(a=7294) or(a=7293) or(a=7292) or(a=7291) or(a=7290) or(a=7289) or(a=7288) or(a=7287) or(a=7286) or(a=7285) or(a=7284) or(a=7283) or(a=7282) or(a=7281) or(a=7280) or(a=7279) or(a=7278) or(a=7277) or(a=7276) or(a=7275) or(a=7274) or(a=7273) or(a=7272) or(a=7271) or(a=7270) or(a=7269) or(a=7268) or
(a=7267) or(a=7266) or(a=7265) or(a=7264) or(a=7263) or(a=7262) or(a=7261) or(a=7260) or(a=7259) or(a=7258) or(a=7257) or(a=7256) or(a=7255) or(a=7254) or(a=7253) or(a=7252) or(a=7251) or(a=7250) or(a=7249) or(a=7248) or(a=7247) or(a=7246) or(a=7245) or(a=7244) or(a=7243) or(a=7242) or(a=7241) or(a=7240) or(a=7239) or(a=7238) or
(a=7237) or(a=7236) or(a=7235) or(a=7234) or(a=7233) or(a=7232) or(a=7231) or(a=7230) or(a=7229) or(a=7228) or(a=7227) or(a=7226) or(a=7225) or(a=7224) or(a=7223) or(a=7222) or(a=7221) or(a=7220) or(a=7219) or(a=7218) or(a=7217) or(a=7216) or(a=7215) or(a=7214) or(a=7213) or(a=7212) or(a=7211) or(a=7210) or(a=7209) or(a=7208) or
(a=7207) or(a=7206) or(a=7205) or(a=7204) or(a=7203) or(a=7202) or(a=7201) or(a=7200) or(a=7199) or(a=7198) or(a=7197) or(a=7196) or(a=7195) or(a=7194) or(a=7193) or(a=7192) or(a=7191) or(a=7190) or(a=7189) or(a=7188) or(a=7187) or(a=7186) or(a=7185) or(a=7184) or(a=7183) or(a=7182) or(a=7181) or(a=7180) or(a=7179) or(a=7178) or
(a=7177) or(a=7176) or(a=7175) or(a=7174) or(a=7173) or(a=7172) or(a=7171) or(a=7170) or(a=7169) or(a=7168) or(a=7167) or(a=7166) or(a=7165) or(a=7164) or(a=7163) or(a=7162) or(a=7161) or(a=7160) or(a=7159) or(a=7158) or(a=7157) or(a=7156) or(a=7155) or(a=7154) or(a=7153) or(a=7152) or(a=7151) or(a=7150) or(a=7149) or(a=7148) or
(a=7147) or(a=7146) or(a=7145) or(a=7144) or(a=7143) or(a=7142) or(a=7141) or(a=7140) or(a=7139) or(a=7138) or(a=7137) or(a=7136) or(a=7135) or(a=7134) or(a=7133) or(a=7132) or(a=7131) or(a=7130) or(a=7129) or(a=7128) or(a=7127) or(a=7126) or(a=7125) or(a=7124) or(a=7123) or(a=7122) or(a=7121) or(a=7120) or(a=7119) or(a=7118) or
(a=7117) or(a=7116) or(a=7115) or(a=7114) or(a=7113) or(a=7112) or(a=7111) or(a=7110) or(a=7109) or(a=7108) or(a=7107) or(a=7106) or(a=7105) or(a=7104) or(a=7103) or(a=7102) or(a=7101) or(a=7100) or(a=7099) or(a=7098) or(a=7097) or(a=7096) or(a=7095) or(a=7094) or(a=7093) or(a=7092) or(a=7091) or(a=7090) or(a=7089) or(a=7088) or
(a=7087) or(a=7086) or(a=7085) or(a=7084) or(a=7083) or(a=7082) or(a=7081) or(a=7080) or(a=7079) or(a=7078) or(a=7077) or(a=7076) or(a=7075) or(a=7074) or(a=7073) or(a=7072) or(a=7071) or(a=7070) or(a=7069) or(a=7068) or(a=7067) or(a=7066) or(a=7065) or(a=7064) or(a=7063) or(a=7062) or(a=7061) or(a=7060) or(a=7059) or(a=7058) or
(a=7057) or(a=7056) or(a=7055) or(a=7054) or(a=7053) or(a=7052) or(a=7051) or(a=7050) or(a=7049) or(a=7048) or(a=7047) or(a=7046) or(a=7045) or(a=7044) or(a=7043) or(a=7042) or(a=7041) or(a=7040) or(a=7039) or(a=7038) or(a=7037) or(a=7036) or(a=7035) or(a=7034) or(a=7033) or(a=7032) or(a=7031) or(a=7030) or(a=7029) or(a=7028) or
(a=7027) or(a=7026) or(a=7025) or(a=7024) or(a=7023) or(a=7022) or(a=7021) or(a=7020) or(a=7019) or(a=7018) or(a=7017) or(a=7016) or(a=7015) or(a=7014) or(a=7013) or(a=7012) or(a=7011) or(a=7010) or(a=7009) or(a=7008) or(a=7007) or(a=7006) or(a=7005) or(a=7004) or(a=7003) or(a=7002) or(a=7001) or(a=7000) or(a=6999) or(a=6998) or
(a=6997) or(a=6996) or(a=6995) or(a=6994) or(a=6993) or(a=6992) or(a=6991) or(a=6990) or(a=6989) or(a=6988) or(a=6987) or(a=6986) or(a=6985) or(a=6984) or(a=6983) or(a=6982) or(a=6981) or(a=6980) or(a=6979) or(a=6978) or(a=6977) or(a=6976) or(a=6975) or(a=6974) or(a=6973) or(a=6972) or(a=6971) or(a=6970) or(a=6969) or(a=6968) or
(a=6967) or(a=6966) or(a=6965) or(a=6964) or(a=6963) or(a=6962) or(a=6961) or(a=6960) or(a=6959) or(a=6958) or(a=6957) or(a=6956) or(a=6955) or(a=6954) or(a=6953) or(a=6952) or(a=6951) or(a=6950) or(a=6949) or(a=6948) or(a=6947) or(a=6946) or(a=6945) or(a=6944) or(a=6943) or(a=6942) or(a=6941) or(a=6940) or(a=6939) or(a=6938) or
(a=6937) or(a=6936) or(a=6935) or(a=6934) or(a=6933) or(a=6932) or(a=6931) or(a=6930) or(a=6929) or(a=6928) or(a=6927) or(a=6926) or(a=6925) or(a=6924) or(a=6923) or(a=6922) or(a=6921) or(a=6920) or(a=6919) or(a=6918) or(a=6917) or(a=6916) or(a=6915) or(a=6914) or(a=6913) or(a=6912) or(a=6911) or(a=6910) or(a=6909) or(a=6908) or
(a=6907) or(a=6906) or(a=6905) or(a=6904) or(a=6903) or(a=6902) or(a=6901) or(a=6900) or(a=6899) or(a=6898) or(a=6897) or(a=6896) or(a=6895) or(a=6894) or(a=6893) or(a=6892) or(a=6891) or(a=6890) or(a=6889) or(a=6888) or(a=6887) or(a=6886) or(a=6885) or(a=6884) or(a=6883) or(a=6882) or(a=6881) or(a=6880) or(a=6879) or(a=6878) or
(a=9814) or(a=9813) or(a=9812) or(a=9811) or(a=9810) or(a=9809) or(a=9808) or(a=9807) or(a=9806) or(a=9805) or(a=9804) or(a=9803) or(a=9802) or(a=9801) or(a=9800) or(a=9799) or(a=9798) or(a=9797) or
(a=9796) or(a=9795) or(a=9794) or(a=9793) or(a=9792) or(a=9791) or(a=9790) or(a=9789) or(a=9788) or(a=9787) or(a=9786) or(a=9785) or(a=9784) or(a=9783) or(a=9782) or(a=9781) or(a=9780) or(a=9779) or
(a=9778) or(a=9777) or(a=9776) or(a=9775) or(a=9774) or(a=9773) or(a=9772) or(a=9771) or(a=9770) or(a=9769) or(a=9768) or(a=9767) or(a=9766) or(a=9765) or(a=9764) or(a=9763) or(a=9762) or(a=9761) or
(a=9760) or(a=9759) or(a=9758) or(a=9757) or(a=9756) or(a=9755) or(a=9754) or(a=9753) or(a=9752) or(a=9751) or(a=9750) or(a=9749) or(a=9748) or(a=9747) or(a=9746) or(a=9745) or(a=9744) or(a=9743) or
(a=9742) or(a=9741) or(a=9740) or(a=9739) or(a=9738) or(a=9737) or(a=9736) or(a=9735) or(a=9734) or(a=9733) or(a=9732) or(a=9731) or(a=9730) or(a=9729) or(a=9728) or(a=9727) or(a=9726) or(a=9725) or
(a=9724) or(a=9723) or(a=9722) or(a=9721) or(a=9720) or(a=9719) or(a=9718) or(a=9717) or(a=9716) or(a=9715) or(a=9714) or(a=9713) or(a=9712) or(a=9711) or(a=9710) or(a=9709) or(a=9708) or(a=9707) or
(a=9706) or(a=9705) or(a=9704) or(a=9703) or(a=9702) or(a=9701) or(a=9700) or(a=9699) or(a=9698) or(a=9697) or(a=9696) or(a=9695) or(a=9694) or(a=9693) or(a=9692) or(a=9691) or(a=9690) or(a=9689) or
(a=9688) or(a=9687) or(a=9686) or(a=9685) or(a=9684) or(a=9683) or(a=9682) or(a=9681) or(a=9680) or(a=9679) or(a=9678) or(a=9677) or(a=9676) or(a=9675) or(a=9674) or(a=9673) or(a=9672) or(a=9671) or
(a=9670) or(a=9669) or(a=9668) or(a=9667) or(a=9666) or(a=9665) or(a=9664) or(a=9663) or(a=9662) or(a=9661) or(a=9660) or(a=9659) or(a=9658) or(a=9657) or(a=9656) or(a=9655) or(a=9654) or(a=9653) or
(a=9652) or(a=9651) or(a=9650) or(a=9649) or(a=9648) or(a=9647) or(a=9646) or(a=9645) or(a=9644) or(a=9643) or(a=9642) or(a=9641) or(a=9640) or(a=9639) or(a=9638) or(a=9637) or(a=9636) or(a=9635) or
(a=9634) or(a=9633) or(a=9632) or(a=9631) or(a=9630) or(a=9629) or(a=9628) or(a=9627) or(a=9626) or(a=9625) or(a=9624) or(a=9623) or(a=9622) or(a=9621) or(a=9620) or(a=9619) or(a=9618) or(a=9617) or
(a=9616) or(a=9615) or(a=9614) or(a=9613) or(a=9612) or(a=9611) or(a=9610) or(a=9609) or(a=9608) or(a=9607) or(a=9606) or(a=9605) or(a=9604) or(a=9603) or(a=9602) or(a=9601) or(a=9600) or(a=9599) or
(a=9598) or(a=9597) or(a=9596) or(a=9595) or(a=9594) or(a=9593) or(a=9592) or(a=9591) or(a=9590) or(a=9589) or(a=9588) or(a=9587) or(a=9586) or(a=9585) or(a=9584) or(a=9583) or(a=9582) or(a=9581) or
(a=9580) or(a=9579) or(a=9578) or(a=9577) or(a=9576) or(a=9575) or(a=9574) or(a=9573) or(a=9572) or(a=9571) or(a=9570) or(a=9569) or(a=9568) or(a=9567) or(a=9566) or(a=9565) or(a=9564) or(a=9563) or
(a=9562) or(a=9561) or(a=9560) or(a=9559) or(a=9558) or(a=9557) or(a=9556) or(a=9555) or(a=9554) or(a=9553) or(a=9552) or(a=9551) or(a=9550) or(a=9549) or(a=9548) or(a=9547) or(a=9546) or(a=9545) or
(a=9544) or(a=9543) or(a=9542) or(a=9541) or(a=9540) or(a=9539) or(a=9538) or(a=9537) or(a=9536) or(a=9535) or(a=9534) or(a=9533) or(a=9532) or(a=9531) or(a=9530) or(a=9529) or(a=9528) or(a=9527) or
(a=9526) or(a=9525) or(a=9524) or(a=9523) or(a=9522) or(a=9521) or(a=9520) or(a=9519) or(a=9518) or(a=9517) or(a=9516) or(a=9515) or(a=9514) or(a=9513) or(a=9512) or(a=9511) or(a=9510) or(a=9509) or
(a=9508) or(a=9507) or(a=9506) or(a=9505) or(a=9504) or(a=9503) or(a=9502) or(a=9501) or(a=9500) or(a=9499) or(a=9498) or(a=9497) or(a=9496) or(a=9495) or(a=9494) or(a=9493) or(a=9492) or(a=9491) or
(a=9490) or(a=9489) or(a=9488) or(a=9487) or(a=9486) or(a=9485) or(a=9484) or(a=9483) or(a=9482) or(a=9481) or(a=9480) or(a=9479) or(a=9478) or(a=9477) or(a=9476) or(a=9475) or(a=9474) or(a=9473) or
(a=9472) or(a=9471) or(a=9470) or(a=9469) or(a=9468) or(a=9467) or(a=9466) or(a=9465) or(a=9464) or(a=9463) or(a=9462) or(a=9461) or(a=9460) or(a=9459) or(a=9458) or(a=9457) or(a=9456) or(a=9455) or
(a=9454) or(a=9453) or(a=9452) or(a=9451) or(a=9450) or(a=9449) or(a=9448) or(a=9447) or(a=9446) or(a=9445) or(a=9444) or(a=9443) or(a=9442) or(a=9441) or(a=9440) or(a=9439) or(a=9438) or(a=9437) or
(a=9436) or(a=9435) or(a=9434) or(a=9433) or(a=9432) or(a=9431) or(a=9430) or(a=9429) or(a=9428) or(a=9427) or(a=9426) or(a=9425) or(a=9424) or(a=9423) or(a=9422) or(a=9421) or(a=9420) or(a=9419) or
(a=9418) or(a=9417) or(a=9416) or(a=9415) or(a=9414) or(a=9413) or(a=9412) or(a=9411) or(a=9410) or(a=9409) or(a=9408) or(a=9407) or(a=9406) or(a=9405) or(a=9404) or(a=9403) or(a=9402) or(a=9401) or
(a=9400) or(a=9399) or(a=9398) or(a=9397) or(a=9396) or(a=9395) or(a=9394) or(a=9393) or(a=9392) or(a=9391) or(a=9390) or(a=9389) or(a=9388) or(a=9387) or(a=9386) or(a=9385) or(a=9384) or(a=9383) or
(a=9382) or(a=9381) or(a=9380) or(a=9379) or(a=9378) or(a=9377) or(a=9376) or(a=9375) or(a=9374) or(a=9373) or(a=9372) or(a=9371) or(a=9370) or(a=9369) or(a=9368) or(a=9367) or(a=9366) or(a=9365) or
(a=9364) or(a=9363) or(a=9362) or(a=9361) or(a=9360) or(a=9359) or(a=9358) or(a=9357) or(a=9356) or(a=9355) or(a=9354) or(a=9353) or(a=9352) or(a=9351) or(a=9350) or(a=9349) or(a=9348) or(a=9347) or
(a=9346) or(a=9345) or(a=9344) or(a=9343) or(a=9342) or(a=9341) or(a=9340) or(a=9339) or(a=9338) or(a=9337) or(a=9336) or(a=9335) or(a=9334) or(a=9333) or(a=9332) or(a=9331) or(a=9330) or(a=9329) or
(a=9328) or(a=9327) or(a=9326) or(a=9325) or(a=9324) or(a=9323) or(a=9322) or(a=9321) or(a=9320) or(a=9319) or(a=9318) or(a=9317) or(a=9316) or(a=9315) or(a=9314) or(a=9313) or(a=9312) or(a=9311) or
(a=9310) or(a=9309) or(a=9308) or(a=9307) or(a=9306) or(a=9305) or(a=9304) or(a=9303) or(a=9302) or(a=9301) or(a=9300) or(a=9299) or(a=9298) or(a=9297) or(a=9296) or(a=9295) or(a=9294) or(a=9293) or
(a=9292) or(a=9291) or(a=9290) or(a=9289) or(a=9288) or(a=9287) or(a=9286) or(a=9285) or(a=9284) or(a=9283) or(a=9282) or(a=9281) or(a=9280) or(a=9279) or(a=9278) or(a=9277) or(a=9276) or(a=9275) or
(a=9274) or(a=9273) or(a=9272) or(a=9271) or(a=9270) or(a=9269) or(a=9268) or(a=9267) or(a=9266) or(a=9265) or(a=9264) or(a=9263) or(a=9262) or(a=9261) or(a=9260) or(a=9259) or(a=9258) or(a=9257) or
(a=9256) or(a=9255) or(a=9254) or(a=9253) or(a=9252) or(a=9251) or(a=9250) or(a=9249) or(a=9248) or(a=9247) or(a=9246) or(a=9245) or(a=9244) or(a=9243) or(a=9242) or(a=9241) or(a=9240) or(a=9239) or
(a=9238) or(a=9237) or(a=9236) or(a=9235) or(a=9234) or(a=9233) or(a=9232) or(a=9231) or(a=9230) or(a=9229) or(a=9228) or(a=9227) or(a=9226) or(a=9225) or(a=9224) or(a=9223) or(a=9222) or(a=9221) or
(a=9220) or(a=9219) or(a=9218) or(a=9217) or(a=9216) or(a=9215) or(a=9214) or(a=9213) or(a=9212) or(a=9211) or(a=9210) or(a=9209) or(a=9208) or(a=9207) or(a=9206) or(a=9205) or(a=9204) or(a=9203) or
(a=9202) or(a=9201) or(a=9200) or(a=9199) or(a=9198) or(a=9197) or(a=9196) or(a=9195) or(a=9194) or(a=9193) or(a=9192) or(a=9191) or(a=9190) or(a=9189) or(a=9188) or(a=9187) or(a=9186) or(a=9185) or
(a=9184) or(a=9183) or(a=9182) or(a=9181) or(a=9180) or(a=9179) or(a=9178) or(a=9177) or(a=9176) or(a=9175) or(a=9174) or(a=9173) or(a=9172) or(a=9171) or(a=9170) or(a=9169) or(a=9168) or(a=9167) or
(a=9166) or(a=9165) or(a=9164) or(a=9163) or(a=9162) or(a=9161) or(a=9160) or(a=9159) or(a=9158) or(a=9157) or(a=9156) or(a=9155) or(a=9154) or(a=9153) or(a=9152) or(a=9151) or(a=9150) or(a=9149) or
(a=9148) or(a=9147) or(a=9146) or(a=9145) or(a=9144) or(a=9143) or(a=9142) or(a=9141) or(a=9140) or(a=9139) or(a=9138) or(a=9137) or(a=9136) or(a=9135) or(a=9134) or(a=9133) or(a=9132) or(a=9131) or
(a=9130) or(a=9129) or(a=9128) or(a=9127) or(a=9126) or(a=9125) or(a=9124) or(a=9123) or(a=9122) or(a=9121) or(a=9120) or(a=9119) or(a=9118) or(a=9117) or(a=9116) or(a=9115) or(a=9114) or(a=9113) or
(a=9112) or(a=9111) or(a=9110) or(a=9109) or(a=9108) or(a=9107) or(a=9106) or(a=9105) or(a=9104) or(a=9103) or(a=9102) or(a=9101) or(a=9100) or(a=9099) or(a=9098) or(a=9097) or(a=9096) or(a=9095) or
(a=9094) or(a=9093) or(a=9092) or(a=9091) or(a=9090) or(a=9089) or(a=9088) or(a=9087) or(a=9086) or(a=9085) or(a=9084) or(a=9083) or(a=9082) or(a=9081) or(a=9080) or(a=9079) or(a=9078) or(a=9077) or
(a=9076) or(a=9075) or(a=9074) or(a=9073) or(a=9072) or(a=9071) or(a=9070) or(a=9069) or(a=9068) or(a=9067) or(a=9066) or(a=9065) or(a=9064) or(a=9063) or(a=9062) or(a=9061) or(a=9060) or(a=9059) or
(a=9058) or(a=9057) or(a=9056) or(a=9055) or(a=9054) or(a=9053) or(a=9052) or(a=9051) or(a=9050) or(a=9049) or(a=9048) or(a=9047) or(a=9046) or(a=9045) or(a=9044) or(a=9043) or(a=9042) or(a=9041) or
(a=9040) or(a=9039) or(a=9038) or(a=9037) or(a=9036) or(a=9035) or(a=9034) or(a=9033) or(a=9032) or(a=9031) or(a=9030) or(a=9029) or(a=9028) or(a=9027) or(a=9026) or(a=9025) or(a=9024) or(a=9023) or
(a=9022) or(a=9021) or(a=9020) or(a=9019) or(a=9018) or(a=9017) or(a=9016) or(a=9015) or(a=9014) or(a=9013) or(a=9012) or(a=9011) or(a=9010) or(a=9009) or(a=9008) or(a=9007) or(a=9006) or(a=9005) or(a=9004) or(a=9003) or(a=9002) or
(a=9001) or(a=9000) or(a=8999) or(a=8998) or(a=8997) or(a=8996) or(a=8995) or(a=8994) or(a=8993) or(a=8992) or(a=8991) or(a=8990) or(a=8989) or(a=8988) or(a=8987) or(a=8986) or(a=8985) or(a=8984) or(a=8983) or(a=8982) or(a=8981) or
(a=8980) or(a=8979) or(a=8978) or(a=8977) or(a=8976) or(a=8975) or(a=8974) or(a=8973) or(a=8972) or(a=8971) or(a=8970) or(a=8969) or(a=8968) or(a=8967) or(a=8966) or(a=8965) or(a=8964) or(a=8963) or(a=8962) or(a=8961) or(a=8960) or
(a=8959) or(a=8958) or(a=8957) or(a=8956) or(a=8955) or(a=8954) or(a=8953) or(a=8952) or(a=8951) or(a=8950) or(a=8949) or(a=8948) or(a=8947) or(a=8946) or(a=8945) or(a=8944) or(a=8943) or(a=8942) or(a=8941) or(a=8940) or(a=8939) or
(a=8938) or(a=8937) or(a=8936) or(a=8935) or(a=8934) or(a=8933) or(a=8932) or(a=8931) or(a=8930) or(a=8929) or(a=8928) or(a=8927) or(a=8926) or(a=8925) or(a=8924) or(a=8923) or(a=8922) or(a=8921) or(a=8920) or(a=8919) or(a=8918) or
(a=8917) or(a=8916) or(a=8915) or(a=8914) or(a=8913) or(a=8912) or(a=8911) or(a=8910) or(a=8909) or(a=8908) or(a=8907) or(a=8906) or(a=8905) or(a=8904) or(a=8903) or(a=8902) or(a=8901) or(a=8900) or(a=8899) or(a=8898) or(a=8897) or(a=8896) or(a=8895) or(a=8894) or(a=8893) or(a=8892) or(a=8891) or(a=8890) or(a=8889) or(a=8888) or
(a=8887) or(a=8886) or(a=8885) or(a=8884) or(a=8883) or(a=8882) or(a=8881) or(a=8880) or(a=8879) or(a=8878) or(a=8877) or(a=8876) or(a=8875) or(a=8874) or(a=8873) or(a=8872) or(a=8871) or(a=8870) or(a=8869) or(a=8868) or(a=8867) or(a=8866) or(a=8865) or(a=8864) or(a=8863) or(a=8862) or(a=8861) or(a=8860) or(a=8859) or(a=8858) or
(a=8857) or(a=8856) or(a=8855) or(a=8854) or(a=8853) or(a=8852) or(a=8851) or(a=8850) or(a=8849) or(a=8848) or(a=8847) or(a=8846) or(a=8845) or(a=8844) or(a=8843) or(a=8842) or(a=8841) or(a=8840) or(a=8839) or(a=8838) or(a=8837) or(a=8836) or(a=8835) or(a=8834) or(a=8833) or(a=8832) or(a=8831) or(a=8830) or(a=8829) or(a=8828) or
(a=8827) or(a=8826) or(a=8825) or(a=8824) or(a=8823) or(a=8822) or(a=8821) or(a=8820) or(a=8819) or(a=8818) or(a=8817) or(a=8816) or(a=8815) or(a=8814) or(a=8813) or(a=8812) or(a=8811) or(a=8810) or(a=8809) or(a=8808) or(a=8807) or(a=8806) or(a=8805) or(a=8804) or(a=8803) or(a=8802) or(a=8801) or(a=8800) or(a=8799) or(a=8798) or
(a=8797) or(a=8796) or(a=8795) or(a=8794) or(a=8793) or(a=8792) or(a=8791) or(a=8790) or(a=8789) or(a=8788) or(a=8787) or(a=8786) or(a=8785) or(a=8784) or(a=8783) or(a=8782) or(a=8781) or(a=8780) or(a=8779) or(a=8778) or(a=8777) or(a=8776) or(a=8775) or(a=8774) or(a=8773) or(a=8772) or(a=8771) or(a=8770) or(a=8769) or(a=8768) or
(a=8767) or(a=8766) or(a=8765) or(a=8764) or(a=8763) or(a=8762) or(a=8761) or(a=8760) or(a=8759) or(a=8758) or(a=8757) or(a=8756) or(a=8755) or(a=8754) or(a=8753) or(a=8752) or(a=8751) or(a=8750) or(a=8749) or(a=8748) or(a=8747) or(a=8746) or(a=8745) or(a=8744) or(a=8743) or(a=8742) or(a=8741) or(a=8740) or(a=8739) or(a=8738) or
(a=8737) or(a=8736) or(a=8735) or(a=8734) or(a=8733) or(a=8732) or(a=8731) or(a=8730) or(a=8729) or(a=8728) or(a=8727) or(a=8726) or(a=8725) or(a=8724) or(a=8723) or(a=8722) or(a=8721) or(a=8720) or(a=8719) or(a=8718) or(a=8717) or(a=8716) or(a=8715) or(a=8714) or(a=8713) or(a=8712) or(a=8711) or(a=8710) or(a=8709) or(a=8708) or
(a=8707) or(a=8706) or(a=8705) or(a=8704) or(a=8703) or(a=8702) or(a=8701) or(a=8700) or(a=8699) or(a=8698) or(a=8697) or(a=8696) or(a=8695) or(a=8694) or(a=8693) or(a=8692) or(a=8691) or(a=8690) or(a=8689) or(a=8688) or(a=8687) or(a=8686) or(a=8685) or(a=8684) or(a=8683) or(a=8682) or(a=8681) or(a=8680) or(a=8679) or(a=8678) or
(a=8677) or(a=8676) or(a=8675) or(a=8674) or(a=8673) or(a=8672) or(a=8671) or(a=8670) or(a=8669) or(a=8668) or(a=8667) or(a=8666) or(a=8665) or(a=8664) or(a=8663) or(a=8662) or(a=8661) or(a=8660) or(a=8659) or(a=8658) or(a=8657) or(a=8656) or(a=8655) or(a=8654) or(a=8653) or(a=8652) or(a=8651) or(a=8650) or(a=8649) or(a=8648) or
(a=8647) or(a=8646) or(a=8645) or(a=8644) or(a=8643) or(a=8642) or(a=8641) or(a=8640) or(a=8639) or(a=8638) or(a=8637) or(a=8636) or(a=8635) or(a=8634) or(a=8633) or(a=8632) or(a=8631) or(a=8630) or(a=8629) or(a=8628) or(a=8627) or(a=8626) or(a=8625) or(a=8624) or(a=8623) or(a=8622) or(a=8621) or(a=8620) or(a=8619) or(a=8618) or
(a=8617) or(a=8616) or(a=8615) or(a=8614) or(a=8613) or(a=8612) or(a=8611) or(a=8610) or(a=8609) or(a=8608) or(a=8607) or(a=8606) or(a=8605) or(a=8604) or(a=8603) or(a=8602) or(a=8601) or(a=8600) or(a=8599) or(a=8598) or(a=8597) or(a=8596) or(a=8595) or(a=8594) or(a=8593) or(a=8592) or(a=8591) or(a=8590) or(a=8589) or(a=8588) or
(a=8587) or(a=8586) or(a=8585) or(a=8584) or(a=8583) or(a=8582) or(a=8581) or(a=8580) or(a=8579) or(a=8578) or(a=8577) or(a=8576) or(a=8575) or(a=8574) or(a=8573) or(a=8572) or(a=8571) or(a=8570) or(a=8569) or(a=8568) or(a=8567) or(a=8566) or(a=8565) or(a=8564) or(a=8563) or(a=8562) or(a=8561) or(a=8560) or(a=8559) or(a=8558) or
(a=8557) or(a=8556) or(a=8555) or(a=8554) or(a=8553) or(a=8552) or(a=8551) or(a=8550) or(a=8549) or(a=8548) or(a=8547) or(a=8546) or(a=8545) or(a=8544) or(a=8543) or(a=8542) or(a=8541) or(a=8540) or(a=8539) or(a=8538) or(a=8537) or(a=8536) or(a=8535) or(a=8534) or(a=8533) or(a=8532) or(a=8531) or(a=8530) or(a=8529) or(a=8528) or
(a=8527) or(a=8526) or(a=8525) or(a=8524) or(a=8523) or(a=8522) or(a=8521) or(a=8520) or(a=8519) or(a=8518) or(a=8517) or(a=8516) or(a=8515) or(a=8514) or(a=8513) or(a=8512) or(a=8511) or(a=8510) or(a=8509) or(a=8508) or(a=8507) or(a=8506) or(a=8505) or(a=8504) or(a=8503) or(a=8502) or(a=8501) or(a=8500) or(a=8499) or(a=8498) or
(a=8497) or(a=8496) or(a=8495) or(a=8494) or(a=8493) or(a=8492) or(a=8491) or(a=8490) or(a=8489) or(a=8488) or(a=8487) or(a=8486) or(a=8485) or(a=8484) or(a=8483) or(a=8482) or(a=8481) or(a=8480) or(a=8479) or(a=8478) or(a=8477) or(a=8476) or(a=8475) or(a=8474) or(a=8473) or(a=8472) or(a=8471) or(a=8470) or(a=8469) or(a=8468) or
(a=8467) or(a=8466) or(a=8465) or(a=8464) or(a=8463) or(a=8462) or(a=8461) or(a=8460) or(a=8459) or(a=8458) or(a=8457) or(a=8456) or(a=8455) or(a=8454) or(a=8453) or(a=8452) or(a=8451) or(a=8450) or(a=8449) or(a=8448) or(a=8447) or(a=8446) or(a=8445) or(a=8444) or(a=8443) or(a=8442) or(a=8441) or(a=8440) or(a=8439) or(a=8438) or
(a=8437) or(a=8436) or(a=8435) or(a=8434) or(a=8433) or(a=8432) or(a=8431) or(a=8430) or(a=8429) or(a=8428) or(a=8427) or(a=8426) or(a=8425) or(a=8424) or(a=8423) or(a=8422) or(a=8421) or(a=8420) or(a=8419) or(a=8418) or(a=8417) or(a=8416) or(a=8415) or(a=8414) or(a=8413) or(a=8412) or(a=8411) or(a=8410) or(a=8409) or(a=8408) or
(a=8407) or(a=8406) or(a=8405) or(a=8404) or(a=8403) or(a=8402) or(a=8401) or(a=8400) or(a=8399) or(a=8398) or(a=8397) or(a=8396) or(a=8395) or(a=8394) or(a=8393) or(a=8392) or(a=8391) or(a=8390) or(a=8389) or(a=8388) or(a=8387) or(a=8386) or(a=8385) or(a=8384) or(a=8383) or(a=8382) or(a=8381) or(a=8380) or(a=8379) or(a=8378) or
(a=8377) or(a=8376) or(a=8375) or(a=8374) or(a=8373) or(a=8372) or(a=8371) or(a=8370) or(a=8369) or(a=8368) or(a=8367) or(a=8366) or(a=8365) or(a=8364) or(a=8363) or(a=8362) or(a=8361) or(a=8360) or(a=8359) or(a=8358) or(a=8357) or(a=8356) or(a=8355) or(a=8354) or(a=8353) or(a=8352) or(a=8351) or(a=8350) or(a=8349) or(a=8348) or
(a=8347) or(a=8346) or(a=8345) or(a=8344) or(a=8343) or(a=8342) or(a=8341) or(a=8340) or(a=8339) or(a=8338) or(a=8337) or(a=8336) or(a=8335) or(a=8334) or(a=8333) or(a=8332) or(a=8331) or(a=8330) or(a=8329) or(a=8328) or(a=8327) or(a=8326) or(a=8325) or(a=8324) or(a=8323) or(a=8322) or(a=8321) or(a=8320) or(a=8319) or(a=8318) or
(a=8317) or(a=8316) or(a=8315) or(a=8314) or(a=8313) or(a=8312) or(a=8311) or(a=8310) or(a=8309) or(a=8308) or(a=8307) or(a=8306) or(a=8305) or(a=8304) or(a=8303) or(a=8302) or(a=8301) or(a=8300) or(a=8299) or(a=8298) or(a=8297) or(a=8296) or(a=8295) or(a=8294) or(a=8293) or(a=8292) or(a=8291) or(a=8290) or(a=8289) or(a=8288) or
(a=8287) or(a=8286) or(a=8285) or(a=8284) or(a=8283) or(a=8282) or(a=8281) or(a=8280) or(a=8279) or(a=8278) or(a=8277) or(a=8276) or(a=8275) or(a=8274) or(a=8273) or(a=8272) or(a=8271) or(a=8270) or(a=8269) or(a=8268) or(a=8267) or(a=8266) or(a=8265) or(a=8264) or(a=8263) or(a=8262) or(a=8261) or(a=8260) or(a=8259) or(a=8258) or
(a=8257) or(a=8256) or(a=8255) or(a=8254) or(a=8253) or(a=8252) or(a=8251) or(a=8250) or(a=8249) or(a=8248) or(a=8247) or(a=8246) or(a=8245) or(a=8244) or(a=8243) or(a=8242) or(a=8241) or(a=8240) or(a=8239) or(a=8238) or(a=8237) or(a=8236) or(a=8235) or(a=8234) or(a=8233) or(a=8232) or(a=8231) or(a=8230) or(a=8229) or(a=8228) or
(a=8227) or(a=8226) or(a=8225) or(a=8224) or(a=8223) or(a=8222) or(a=8221) or(a=8220) or(a=8219) or(a=8218) or(a=8217) or(a=8216) or(a=8215) or(a=8214) or(a=8213) or(a=8212) or(a=8211) or(a=8210) or(a=8209) or(a=8208) or(a=8207) or(a=8206) or(a=8205) or(a=8204) or(a=8203) or(a=8202) or(a=8201) or(a=8200) or(a=8199) or(a=8198) or
(a=8197) or(a=8196) or(a=8195) or(a=8194) or(a=8193) or(a=8192) or(a=8191) or(a=8190) or(a=8189) or(a=8188) or(a=8187) or(a=8186) or(a=8185) or(a=8184) or(a=8183) or(a=8182) or(a=8181) or(a=8180) or(a=8179) or(a=8178) or(a=8177) or(a=8176) or(a=8175) or(a=8174) or(a=8173) or(a=8172) or(a=8171) or(a=8170) or(a=8169) or(a=8168) or
(a=8167) or(a=8166) or(a=8165) or(a=8164) or(a=8163) or(a=8162) or(a=8161) or(a=8160) or(a=8159) or(a=8158) or(a=8157) or(a=8156) or(a=8155) or(a=8154) or(a=8153) or(a=8152) or(a=8151) or(a=8150) or(a=8149) or(a=8148) or(a=8147) or(a=8146) or(a=8145) or(a=8144) or(a=8143) or(a=8142) or(a=8141) or(a=8140) or(a=8139) or(a=8138) or
(a=8137) or(a=8136) or(a=8135) or(a=8134) or(a=8133) or(a=8132) or(a=8131) or(a=8130) or(a=8129) or(a=8128) or(a=8127) or(a=8126) or(a=8125) or(a=8124) or(a=8123) or(a=8122) or(a=8121) or(a=8120) or(a=8119) or(a=8118) or(a=8117) or(a=8116) or(a=8115) or(a=8114) or(a=8113) or(a=8112) or(a=8111) or(a=8110) or(a=8109) or(a=8108) or
(a=8107) or(a=8106) or(a=8105) or(a=8104) or(a=8103) or(a=8102) or(a=8101) or(a=8100) or(a=8099) or(a=8098) or(a=8097) or(a=8096) or(a=8095) or(a=8094) or(a=8093) or(a=8092) or(a=8091) or(a=8090) or(a=8089) or(a=8088) or(a=8087) or(a=8086) or(a=8085) or(a=8084) or(a=8083) or(a=8082) or(a=8081) or(a=8080) or(a=8079) or(a=8078) or
(a=8077) or(a=8076) or(a=8075) or(a=8074) or(a=8073) or(a=8072) or(a=8071) or(a=8070) or(a=8069) or(a=8068) or(a=8067) or(a=8066) or(a=8065) or(a=8064) or(a=8063) or(a=8062) or(a=8061) or(a=8060) or(a=8059) or(a=8058) or(a=8057) or(a=8056) or(a=8055) or(a=8054) or(a=8053) or(a=8052) or(a=8051) or(a=8050) or(a=8049) or(a=8048) or
(a=8047) or(a=8046) or(a=8045) or(a=8044) or(a=8043) or(a=8042) or(a=8041) or(a=8040) or(a=8039) or(a=8038) or(a=8037) or(a=8036) or(a=8035) or(a=8034) or(a=8033) or(a=8032) or(a=8031) or(a=8030) or(a=8029) or(a=8028) or(a=8027) or(a=8026) or(a=8025) or(a=8024) or(a=8023) or(a=8022) or(a=8021) or(a=8020) or(a=8019) or(a=8018) or
(a=8017) or(a=8016) or(a=8015) or(a=8014) or(a=8013) or(a=8012) or(a=8011) or(a=8010) or(a=8009) or(a=8008) or(a=8007) or(a=8006) or(a=8005) or(a=8004) or(a=8003) or(a=8002) or(a=8001) or(a=8000) or(a=7999) or(a=7998) or(a=7997) or(a=7996) or(a=7995) or(a=7994) or(a=7993) or(a=7992) or(a=7991) or(a=7990) or(a=7989) or(a=7988) or
(a=7987) or(a=7986) or(a=7985) or(a=7984) or(a=7983) or(a=7982) or(a=7981) or(a=7980) or(a=7979) or(a=7978) or(a=7977) or(a=7976) or(a=7975) or(a=7974) or(a=7973) or(a=7972) or(a=7971) or(a=7970) or(a=7969) or(a=7968) or(a=7967) or(a=7966) or(a=7965) or(a=7964) or(a=7963) or(a=7962) or(a=7961) or(a=7960) or(a=7959) or(a=7958) or
(a=7957) or(a=7956) or(a=7955) or(a=7954) or(a=7953) or(a=7952) or(a=7951) or(a=7950) or(a=7949) or(a=7948) or(a=7947) or(a=7946) or(a=7945) or(a=7944) or(a=7943) or(a=7942) or(a=7941) or(a=7940) or(a=7939) or(a=7938) or(a=7937) or(a=7936) or(a=7935) or(a=7934) or(a=7933) or(a=7932) or(a=7931) or(a=7930) or(a=7929) or(a=7928) or
(a=7927) or(a=7926) or(a=7925) or(a=7924) or(a=7923) or(a=7922) or(a=7921) or(a=7920) or(a=7919) or(a=7918) or(a=7917) or(a=7916) or(a=7915) or(a=7914) or(a=7913) or(a=7912) or(a=7911) or(a=7910) or(a=7909) or(a=7908) or(a=7907) or(a=7906) or(a=7905) or(a=7904) or(a=7903) or(a=7902) or(a=7901) or(a=7900) or(a=7899) or(a=7898) or
(a=7897) or(a=7896) or(a=7895) or(a=7894) or(a=7893) or(a=7892) or(a=7891) or(a=7890) or(a=7889) or(a=7888) or(a=7887) or(a=7886) or(a=7885) or(a=7884) or(a=7883) or(a=7882) or(a=7881) or(a=7880) or(a=7879) or(a=7878) or(a=7877) or(a=7876) or(a=7875) or(a=7874) or(a=7873) or(a=7872) or(a=7871) or(a=7870) or(a=7869) or(a=7868) or
(a=7867) or(a=7866) or(a=7865) or(a=7864) or(a=7863) or(a=7862) or(a=7861) or(a=7860) or(a=7859) or(a=7858) or(a=7857) or(a=7856) or(a=7855) or(a=7854) or(a=7853) or(a=7852) or(a=7851) or(a=7850) or(a=7849) or(a=7848) or(a=7847) or(a=7846) or(a=7845) or(a=7844) or(a=7843) or(a=7842) or(a=7841) or(a=7840) or(a=7839) or(a=7838) or
(a=7837) or(a=7836) or(a=7835) or(a=7834) or(a=7833) or(a=7832) or(a=7831) or(a=7830) or(a=7829) or(a=7828) or(a=7827) or(a=7826) or(a=7825) or(a=7824) or(a=7823) or(a=7822) or(a=7821) or(a=7820) or(a=7819) or(a=7818) or(a=7817) or(a=7816) or(a=7815) or(a=7814) or(a=7813) or(a=7812) or(a=7811) or(a=7810) or(a=7809) or(a=7808) or
(a=7807) or(a=7806) or(a=7805) or(a=7804) or(a=7803) or(a=7802) or(a=7801) or(a=7800) or(a=7799) or(a=7798) or(a=7797) or(a=7796) or(a=7795) or(a=7794) or(a=7793) or(a=7792) or(a=7791) or(a=7790) or(a=7789) or(a=7788) or(a=7787) or(a=7786) or(a=7785) or(a=7784) or(a=7783) or(a=7782) or(a=7781) or(a=7780) or(a=7779) or(a=7778) or
(a=7777) or(a=7776) or(a=7775) or(a=7774) or(a=7773) or(a=7772) or(a=7771) or(a=7770) or(a=7769) or(a=7768) or(a=7767) or(a=7766) or(a=7765) or(a=7764) or(a=7763) or(a=7762) or(a=7761) or(a=7760) or(a=7759) or(a=7758) or(a=7757) or(a=7756) or(a=7755) or(a=7754) or(a=7753) or(a=7752) or(a=7751) or(a=7750) or(a=7749) or(a=7748) or
(a=7747) or(a=7746) or(a=7745) or(a=7744) or(a=7743) or(a=7742) or(a=7741) or(a=7740) or(a=7739) or(a=7738) or(a=7737) or(a=7736) or(a=7735) or(a=7734) or(a=7733) or(a=7732) or(a=7731) or(a=7730) or(a=7729) or(a=7728) or(a=7727) or(a=7726) or(a=7725) or(a=7724) or(a=7723) or(a=7722) or(a=7721) or(a=7720) or(a=7719) or(a=7718) or
(a=7717) or(a=7716) or(a=7715) or(a=7714) or(a=7713) or(a=7712) or(a=7711) or(a=7710) or(a=7709) or(a=7708) or(a=7707) or(a=7706) or(a=7705) or(a=7704) or(a=7703) or(a=7702) or(a=7701) or(a=7700) or(a=7699) or(a=7698) or(a=7697) or(a=7696) or(a=7695) or(a=7694) or(a=7693) or(a=7692) or(a=7691) or(a=7690) or(a=7689) or(a=7688) or
(a=7687) or(a=7686) or(a=7685) or(a=7684) or(a=7683) or(a=7682) or(a=7681) or(a=7680) or(a=7679) or(a=7678) or(a=7677) or(a=7676) or(a=7675) or(a=7674) or(a=7673) or(a=7672) or(a=7671) or(a=7670) or(a=7669) or(a=7668) or(a=7667) or(a=7666) or(a=7665) or(a=7664) or(a=7663) or(a=7662) or(a=7661) or(a=7660) or(a=7659) or(a=7658) or
(a=7657) or(a=7656) or(a=7655) or(a=7654) or(a=7653) or(a=7652) or(a=7651) or(a=7650) or(a=7649) or(a=7648) or(a=7647) or(a=7646) or(a=7645) or(a=7644) or(a=7643) or(a=7642) or(a=7641) or(a=7640) or(a=7639) or(a=7638) or(a=7637) or(a=7636) or(a=7635) or(a=7634) or(a=7633) or(a=7632) or(a=7631) or(a=7630) or(a=7629) or(a=7628) or
(a=7627) or(a=7626) or(a=7625) or(a=7624) or(a=7623) or(a=7622) or(a=7621) or(a=7620) or(a=7619) or(a=7618) or(a=7617) or(a=7616) or(a=7615) or(a=7614) or(a=7613) or(a=7612) or(a=7611) or(a=7610) or(a=7609) or(a=7608) or(a=7607) or(a=7606) or(a=7605) or(a=7604) or(a=7603) or(a=7602) or(a=7601) or(a=7600) or(a=7599) or(a=7598) or
(a=7597) or(a=7596) or(a=7595) or(a=7594) or(a=7593) or(a=7592) or(a=7591) or(a=7590) or(a=7589) or(a=7588) or(a=7587) or(a=7586) or(a=7585) or(a=7584) or(a=7583) or(a=7582) or(a=7581) or(a=7580) or(a=7579) or(a=7578) or(a=7577) or(a=7576) or(a=7575) or(a=7574) or(a=7573) or(a=7572) or(a=7571) or(a=7570) or(a=7569) or(a=7568) or
(a=7567) or(a=7566) or(a=7565) or(a=7564) or(a=7563) or(a=7562) or(a=7561) or(a=7560) or(a=7559) or(a=7558) or(a=7557) or(a=7556) or(a=7555) or(a=7554) or(a=7553) or(a=7552) or(a=7551) or(a=7550) or(a=7549) or(a=7548) or(a=7547) or(a=7546) or(a=7545) or(a=7544) or(a=7543) or(a=7542) or(a=7541) or(a=7540) or(a=7539) or(a=7538) or
(a=7537) or(a=7536) or(a=7535) or(a=7534) or(a=7533) or(a=7532) or(a=7531) or(a=7530) or(a=7529) or(a=7528) or(a=7527) or(a=7526) or(a=7525) or(a=7524) or(a=7523) or(a=7522) or(a=7521) or(a=7520) or(a=7519) or(a=7518) or(a=7517) or(a=7516) or(a=7515) or(a=7514) or(a=7513) or(a=7512) or(a=7511) or(a=7510) or(a=7509) or(a=7508) or
(a=7507) or(a=7506) or(a=7505) or(a=7504) or(a=7503) or(a=7502) or(a=7501) or(a=7500) or(a=7499) or(a=7498) or(a=7497) or(a=7496) or(a=7495) or(a=7494) or(a=7493) or(a=7492) or(a=7491) or(a=7490) or(a=7489) or(a=7488) or(a=7487) or(a=7486) or(a=7485) or(a=7484) or(a=7483) or(a=7482) or(a=7481) or(a=7480) or(a=7479) or(a=7478) or
(a=7477) or(a=7476) or(a=7475) or(a=7474) or(a=7473) or(a=7472) or(a=7471) or(a=7470) or(a=7469) or(a=7468) or(a=7467) or(a=7466) or(a=7465) or(a=7464) or(a=7463) or(a=7462) or(a=7461) or(a=7460) or(a=7459) or(a=7458) or(a=7457) or(a=7456) or(a=7455) or(a=7454) or(a=7453) or(a=7452) or(a=7451) or(a=7450) or(a=7449) or(a=7448) or
(a=7447) or(a=7446) or(a=7445) or(a=7444) or(a=7443) or(a=7442) or(a=7441) or(a=7440) or(a=7439) or(a=7438) or(a=7437) or(a=7436) or(a=7435) or(a=7434) or(a=7433) or(a=7432) or(a=7431) or(a=7430) or(a=7429) or(a=7428) or(a=7427) or(a=7426) or(a=7425) or(a=7424) or(a=7423) or(a=7422) or(a=7421) or(a=7420) or(a=7419) or(a=7418) or
(a=7417) or(a=7416) or(a=7415) or(a=7414) or(a=7413) or(a=7412) or(a=7411) or(a=7410) or(a=7409) or(a=7408) or(a=7407) or(a=7406) or(a=7405) or(a=7404) or(a=7403) or(a=7402) or(a=7401) or(a=7400) or(a=7399) or(a=7398) or(a=7397) or(a=7396) or(a=7395) or(a=7394) or(a=7393) or(a=7392) or(a=7391) or(a=7390) or(a=7389) or(a=7388) or
(a=7387) or(a=7386) or(a=7385) or(a=7384) or(a=7383) or(a=7382) or(a=7381) or(a=7380) or(a=7379) or(a=7378) or(a=7377) or(a=7376) or(a=7375) or(a=7374) or(a=7373) or(a=7372) or(a=7371) or(a=7370) or(a=7369) or(a=7368) or(a=7367) or(a=7366) or(a=7365) or(a=7364) or(a=7363) or(a=7362) or(a=7361) or(a=7360) or(a=7359) or(a=7358) or
(a=7357) or(a=7356) or(a=7355) or(a=7354) or(a=7353) or(a=7352) or(a=7351) or(a=7350) or(a=7349) or(a=7348) or(a=7347) or(a=7346) or(a=7345) or(a=7344) or(a=7343) or(a=7342) or(a=7341) or(a=7340) or(a=7339) or(a=7338) or(a=7337) or(a=7336) or(a=7335) or(a=7334) or(a=7333) or(a=7332) or(a=7331) or(a=7330) or(a=7329) or(a=7328) or
(a=7327) or(a=7326) or(a=7325) or(a=7324) or(a=7323) or(a=7322) or(a=7321) or(a=7320) or(a=7319) or(a=7318) or(a=7317) or(a=7316) or(a=7315) or(a=7314) or(a=7313) or(a=7312) or(a=7311) or(a=7310) or(a=7309) or(a=7308) or(a=7307) or(a=7306) or(a=7305) or(a=7304) or(a=7303) or(a=7302) or(a=7301) or(a=7300) or(a=7299) or(a=7298) or
(a=7297) or(a=7296) or(a=7295) or(a=7294) or(a=7293) or(a=7292) or(a=7291) or(a=7290) or(a=7289) or(a=7288) or(a=7287) or(a=7286) or(a=7285) or(a=7284) or(a=7283) or(a=7282) or(a=7281) or(a=7280) or(a=7279) or(a=7278) or(a=7277) or(a=7276) or(a=7275) or(a=7274) or(a=7273) or(a=7272) or(a=7271) or(a=7270) or(a=7269) or(a=7268) or
(a=7267) or(a=7266) or(a=7265) or(a=7264) or(a=7263) or(a=7262) or(a=7261) or(a=7260) or(a=7259) or(a=7258) or(a=7257) or(a=7256) or(a=7255) or(a=7254) or(a=7253) or(a=7252) or(a=7251) or(a=7250) or(a=7249) or(a=7248) or(a=7247) or(a=7246) or(a=7245) or(a=7244) or(a=7243) or(a=7242) or(a=7241) or(a=7240) or(a=7239) or(a=7238) or
(a=7237) or(a=7236) or(a=7235) or(a=7234) or(a=7233) or(a=7232) or(a=7231) or(a=7230) or(a=7229) or(a=7228) or(a=7227) or(a=7226) or(a=7225) or(a=7224) or(a=7223) or(a=7222) or(a=7221) or(a=7220) or(a=7219) or(a=7218) or(a=7217) or(a=7216) or(a=7215) or(a=7214) or(a=7213) or(a=7212) or(a=7211) or(a=7210) or(a=7209) or(a=7208) or
(a=7207) or(a=7206) or(a=7205) or(a=7204) or(a=7203) or(a=7202) or(a=7201) or(a=7200) or(a=7199) or(a=7198) or(a=7197) or(a=7196) or(a=7195) or(a=7194) or(a=7193) or(a=7192) or(a=7191) or(a=7190) or(a=7189) or(a=7188) or(a=7187) or(a=7186) or(a=7185) or(a=7184) or(a=7183) or(a=7182) or(a=7181) or(a=7180) or(a=7179) or(a=7178) or
(a=7177) or(a=7176) or(a=7175) or(a=7174) or(a=7173) or(a=7172) or(a=7171) or(a=7170) or(a=7169) or(a=7168) or(a=7167) or(a=7166) or(a=7165) or(a=7164) or(a=7163) or(a=7162) or(a=7161) or(a=7160) or(a=7159) or(a=7158) or(a=7157) or(a=7156) or(a=7155) or(a=7154) or(a=7153) or(a=7152) or(a=7151) or(a=7150) or(a=7149) or(a=7148) or
(a=7147) or(a=7146) or(a=7145) or(a=7144) or(a=7143) or(a=7142) or(a=7141) or(a=7140) or(a=7139) or(a=7138) or(a=7137) or(a=7136) or(a=7135) or(a=7134) or(a=7133) or(a=7132) or(a=7131) or(a=7130) or(a=7129) or(a=7128) or(a=7127) or(a=7126) or(a=7125) or(a=7124) or(a=7123) or(a=7122) or(a=7121) or(a=7120) or(a=7119) or(a=7118) or
(a=7117) or(a=7116) or(a=7115) or(a=7114) or(a=7113) or(a=7112) or(a=7111) or(a=7110) or(a=7109) or(a=7108) or(a=7107) or(a=7106) or(a=7105) or(a=7104) or(a=7103) or(a=7102) or(a=7101) or(a=7100) or(a=7099) or(a=7098) or(a=7097) or(a=7096) or(a=7095) or(a=7094) or(a=7093) or(a=7092) or(a=7091) or(a=7090) or(a=7089) or(a=7088) or
(a=7087) or(a=7086) or(a=7085) or(a=7084) or(a=7083) or(a=7082) or(a=7081) or(a=7080) or(a=7079) or(a=7078) or(a=7077) or(a=7076) or(a=7075) or(a=7074) or(a=7073) or(a=7072) or(a=7071) or(a=7070) or(a=7069) or(a=7068) or(a=7067) or(a=7066) or(a=7065) or(a=7064) or(a=7063) or(a=7062) or(a=7061) or(a=7060) or(a=7059) or(a=7058) or
(a=7057) or(a=7056) or(a=7055) or(a=7054) or(a=7053) or(a=7052) or(a=7051) or(a=7050) or(a=7049) or(a=7048) or(a=7047) or(a=7046) or(a=7045) or(a=7044) or(a=7043) or(a=7042) or(a=7041) or(a=7040) or(a=7039) or(a=7038) or(a=7037) or(a=7036) or(a=7035) or(a=7034) or(a=7033) or(a=7032) or(a=7031) or(a=7030) or(a=7029) or(a=7028) or
(a=7027) or(a=7026) or(a=7025) or(a=7024) or(a=7023) or(a=7022) or(a=7021) or(a=7020) or(a=7019) or(a=7018) or(a=7017) or(a=7016) or(a=7015) or(a=7014) or(a=7013) or(a=7012) or(a=7011) or(a=7010) or(a=7009) or(a=7008) or(a=7007) or(a=7006) or(a=7005) or(a=7004) or(a=7003) or(a=7002) or(a=7001) or(a=7000) or(a=6999) or(a=6998) or
(a=6997) or(a=6996) or(a=6995) or(a=6994) or(a=6993) or(a=6992) or(a=6991) or(a=6990) or(a=6989) or(a=6988) or(a=6987) or(a=6986) or(a=6985) or(a=6984) or(a=6983) or(a=6982) or(a=6981) or(a=6980) or(a=6979) or(a=6978) or(a=6977) or(a=6976) or(a=6975) or(a=6974) or(a=6973) or(a=6972) or(a=6971) or(a=6970) or(a=6969) or(a=6968) or
(a=6967) or(a=6966) or(a=6965) or(a=6964) or(a=6963) or(a=6962) or(a=6961) or(a=6960) or(a=6959) or(a=6958) or(a=6957) or(a=6956) or(a=6955) or(a=6954) or(a=6953) or(a=6952) or(a=6951) or(a=6950) or(a=6949) or(a=6948) or(a=6947) or(a=6946) or(a=6945) or(a=6944) or(a=6943) or(a=6942) or(a=6941) or(a=6940) or(a=6939) or(a=6938) or
(a=6937) or(a=6936) or(a=6935) or(a=6934) or(a=6933) or(a=6932) or(a=6931) or(a=6930) or(a=6929) or(a=6928) or(a=6927) or(a=6926) or(a=6925) or(a=6924) or(a=6923) or(a=6922) or(a=6921) or(a=6920) or(a=6919) or(a=6918) or(a=6917) or(a=6916) or(a=6915) or(a=6914) or(a=6913) or(a=6912) or(a=6911) or(a=6910) or(a=6909) or(a=6908) or
(a=6907) or(a=6906) or(a=6905) or(a=6904) or(a=6903) or(a=6902) or(a=6901) or(a=6900) or(a=6899) or(a=6898) or(a=6897) or(a=6896) or(a=6895) or(a=6894) or(a=6893) or(a=6892) or(a=6891) or(a=6890) or(a=6889) or(a=6888) or(a=6887) or(a=6886) or(a=6885) or(a=6884) or(a=6883) or(a=6882) or(a=6881) or(a=6880) or(a=6879) or(a=6878) or
(a=9814) or(a=9813) or(a=9812) or(a=9811) or(a=9810) or(a=9809) or(a=9808) or(a=9807) or(a=9806) or(a=9805) or(a=9804) or(a=9803) or(a=9802) or(a=9801) or(a=9800) or(a=9799) or(a=9798) or(a=9797) or
(a=9796) or(a=9795) or(a=9794) or(a=9793) or(a=9792) or(a=9791) or(a=9790) or(a=9789) or(a=9788) or(a=9787) or(a=9786) or(a=9785) or(a=9784) or(a=9783) or(a=9782) or(a=9781) or(a=9780) or(a=9779) or
(a=9778) or(a=9777) or(a=9776) or(a=9775) or(a=9774) or(a=9773) or(a=9772) or(a=9771) or(a=9770) or(a=9769) or(a=9768) or(a=9767) or(a=9766) or(a=9765) or(a=9764) or(a=9763) or(a=9762) or(a=9761) or
(a=9760) or(a=9759) or(a=9758) or(a=9757) or(a=9756) or(a=9755) or(a=9754) or(a=9753) or(a=9752) or(a=9751) or(a=9750) or(a=9749) or(a=9748) or(a=9747) or(a=9746) or(a=9745) or(a=9744) or(a=9743) or
(a=9742) or(a=9741) or(a=9740) or(a=9739) or(a=9738) or(a=9737) or(a=9736) or(a=9735) or(a=9734) or(a=9733) or(a=9732) or(a=9731) or(a=9730) or(a=9729) or(a=9728) or(a=9727) or(a=9726) or(a=9725) or
(a=9724) or(a=9723) or(a=9722) or(a=9721) or(a=9720) or(a=9719) or(a=9718) or(a=9717) or(a=9716) or(a=9715) or(a=9714) or(a=9713) or(a=9712) or(a=9711) or(a=9710) or(a=9709) or(a=9708) or(a=9707) or
(a=9706) or(a=9705) or(a=9704) or(a=9703) or(a=9702) or(a=9701) or(a=9700) or(a=9699) or(a=9698) or(a=9697) or(a=9696) or(a=9695) or(a=9694) or(a=9693) or(a=9692) or(a=9691) or(a=9690) or(a=9689) or
(a=9688) or(a=9687) or(a=9686) or(a=9685) or(a=9684) or(a=9683) or(a=9682) or(a=9681) or(a=9680) or(a=9679) or(a=9678) or(a=9677) or(a=9676) or(a=9675) or(a=9674) or(a=9673) or(a=9672) or(a=9671) or
(a=9670) or(a=9669) or(a=9668) or(a=9667) or(a=9666) or(a=9665) or(a=9664) or(a=9663) or(a=9662) or(a=9661) or(a=9660) or(a=9659) or(a=9658) or(a=9657) or(a=9656) or(a=9655) or(a=9654) or(a=9653) or
(a=9652) or(a=9651) or(a=9650) or(a=9649) or(a=9648) or(a=9647) or(a=9646) or(a=9645) or(a=9644) or(a=9643) or(a=9642) or(a=9641) or(a=9640) or(a=9639) or(a=9638) or(a=9637) or(a=9636) or(a=9635) or
(a=9634) or(a=9633) or(a=9632) or(a=9631) or(a=9630) or(a=9629) or(a=9628) or(a=9627) or(a=9626) or(a=9625) or(a=9624) or(a=9623) or(a=9622) or(a=9621) or(a=9620) or(a=9619) or(a=9618) or(a=9617) or
(a=9616) or(a=9615) or(a=9614) or(a=9613) or(a=9612) or(a=9611) or(a=9610) or(a=9609) or(a=9608) or(a=9607) or(a=9606) or(a=9605) or(a=9604) or(a=9603) or(a=9602) or(a=9601) or(a=9600) or(a=9599) or
(a=9598) or(a=9597) or(a=9596) or(a=9595) or(a=9594) or(a=9593) or(a=9592) or(a=9591) or(a=9590) or(a=9589) or(a=9588) or(a=9587) or(a=9586) or(a=9585) or(a=9584) or(a=9583) or(a=9582) or(a=9581) or
(a=9580) or(a=9579) or(a=9578) or(a=9577) or(a=9576) or(a=9575) or(a=9574) or(a=9573) or(a=9572) or(a=9571) or(a=9570) or(a=9569) or(a=9568) or(a=9567) or(a=9566) or(a=9565) or(a=9564) or(a=9563) or
(a=9562) or(a=9561) or(a=9560) or(a=9559) or(a=9558) or(a=9557) or(a=9556) or(a=9555) or(a=9554) or(a=9553) or(a=9552) or(a=9551) or(a=9550) or(a=9549) or(a=9548) or(a=9547) or(a=9546) or(a=9545) or
(a=9544) or(a=9543) or(a=9542) or(a=9541) or(a=9540) or(a=9539) or(a=9538) or(a=9537) or(a=9536) or(a=9535) or(a=9534) or(a=9533) or(a=9532) or(a=9531) or(a=9530) or(a=9529) or(a=9528) or(a=9527) or
(a=9526) or(a=9525) or(a=9524) or(a=9523) or(a=9522) or(a=9521) or(a=9520) or(a=9519) or(a=9518) or(a=9517) or(a=9516) or(a=9515) or(a=9514) or(a=9513) or(a=9512) or(a=9511) or(a=9510) or(a=9509) or
(a=9508) or(a=9507) or(a=9506) or(a=9505) or(a=9504) or(a=9503) or(a=9502) or(a=9501) or(a=9500) or(a=9499) or(a=9498) or(a=9497) or(a=9496) or(a=9495) or(a=9494) or(a=9493) or(a=9492) or(a=9491) or
(a=9490) or(a=9489) or(a=9488) or(a=9487) or(a=9486) or(a=9485) or(a=9484) or(a=9483) or(a=9482) or(a=9481) or(a=9480) or(a=9479) or(a=9478) or(a=9477) or(a=9476) or(a=9475) or(a=9474) or(a=9473) or
(a=9472) or(a=9471) or(a=9470) or(a=9469) or(a=9468) or(a=9467) or(a=9466) or(a=9465) or(a=9464) or(a=9463) or(a=9462) or(a=9461) or(a=9460) or(a=9459) or(a=9458) or(a=9457) or(a=9456) or(a=9455) or
(a=9454) or(a=9453) or(a=9452) or(a=9451) or(a=9450) or(a=9449) or(a=9448) or(a=9447) or(a=9446) or(a=9445) or(a=9444) or(a=9443) or(a=9442) or(a=9441) or(a=9440) or(a=9439) or(a=9438) or(a=9437) or
(a=9436) or(a=9435) or(a=9434) or(a=9433) or(a=9432) or(a=9431) or(a=9430) or(a=9429) or(a=9428) or(a=9427) or(a=9426) or(a=9425) or(a=9424) or(a=9423) or(a=9422) or(a=9421) or(a=9420) or(a=9419) or
(a=9418) or(a=9417) or(a=9416) or(a=9415) or(a=9414) or(a=9413) or(a=9412) or(a=9411) or(a=9410) or(a=9409) or(a=9408) or(a=9407) or(a=9406) or(a=9405) or(a=9404) or(a=9403) or(a=9402) or(a=9401) or
(a=9400) or(a=9399) or(a=9398) or(a=9397) or(a=9396) or(a=9395) or(a=9394) or(a=9393) or(a=9392) or(a=9391) or(a=9390) or(a=9389) or(a=9388) or(a=9387) or(a=9386) or(a=9385) or(a=9384) or(a=9383) or
(a=9382) or(a=9381) or(a=9380) or(a=9379) or(a=9378) or(a=9377) or(a=9376) or(a=9375) or(a=9374) or(a=9373) or(a=9372) or(a=9371) or(a=9370) or(a=9369) or(a=9368) or(a=9367) or(a=9366) or(a=9365) or
(a=9364) or(a=9363) or(a=9362) or(a=9361) or(a=9360) or(a=9359) or(a=9358) or(a=9357) or(a=9356) or(a=9355) or(a=9354) or(a=9353) or(a=9352) or(a=9351) or(a=9350) or(a=9349) or(a=9348) or(a=9347) or
(a=9346) or(a=9345) or(a=9344) or(a=9343) or(a=9342) or(a=9341) or(a=9340) or(a=9339) or(a=9338) or(a=9337) or(a=9336) or(a=9335) or(a=9334) or(a=9333) or(a=9332) or(a=9331) or(a=9330) or(a=9329) or
(a=9328) or(a=9327) or(a=9326) or(a=9325) or(a=9324) or(a=9323) or(a=9322) or(a=9321) or(a=9320) or(a=9319) or(a=9318) or(a=9317) or(a=9316) or(a=9315) or(a=9314) or(a=9313) or(a=9312) or(a=9311) or
(a=9310) or(a=9309) or(a=9308) or(a=9307) or(a=9306) or(a=9305) or(a=9304) or(a=9303) or(a=9302) or(a=9301) or(a=9300) or(a=9299) or(a=9298) or(a=9297) or(a=9296) or(a=9295) or(a=9294) or(a=9293) or
(a=9292) or(a=9291) or(a=9290) or(a=9289) or(a=9288) or(a=9287) or(a=9286) or(a=9285) or(a=9284) or(a=9283) or(a=9282) or(a=9281) or(a=9280) or(a=9279) or(a=9278) or(a=9277) or(a=9276) or(a=9275) or
(a=9274) or(a=9273) or(a=9272) or(a=9271) or(a=9270) or(a=9269) or(a=9268) or(a=9267) or(a=9266) or(a=9265) or(a=9264) or(a=9263) or(a=9262) or(a=9261) or(a=9260) or(a=9259) or(a=9258) or(a=9257) or
(a=9256) or(a=9255) or(a=9254) or(a=9253) or(a=9252) or(a=9251) or(a=9250) or(a=9249) or(a=9248) or(a=9247) or(a=9246) or(a=9245) or(a=9244) or(a=9243) or(a=9242) or(a=9241) or(a=9240) or(a=9239) or
(a=9238) or(a=9237) or(a=9236) or(a=9235) or(a=9234) or(a=9233) or(a=9232) or(a=9231) or(a=9230) or(a=9229) or(a=9228) or(a=9227) or(a=9226) or(a=9225) or(a=9224) or(a=9223) or(a=9222) or(a=9221) or
(a=9220) or(a=9219) or(a=9218) or(a=9217) or(a=9216) or(a=9215) or(a=9214) or(a=9213) or(a=9212) or(a=9211) or(a=9210) or(a=9209) or(a=9208) or(a=9207) or(a=9206) or(a=9205) or(a=9204) or(a=9203) or
(a=9202) or(a=9201) or(a=9200) or(a=9199) or(a=9198) or(a=9197) or(a=9196) or(a=9195) or(a=9194) or(a=9193) or(a=9192) or(a=9191) or(a=9190) or(a=9189) or(a=9188) or(a=9187) or(a=9186) or(a=9185) or
(a=9184) or(a=9183) or(a=9182) or(a=9181) or(a=9180) or(a=9179) or(a=9178) or(a=9177) or(a=9176) or(a=9175) or(a=9174) or(a=9173) or(a=9172) or(a=9171) or(a=9170) or(a=9169) or(a=9168) or(a=9167) or
(a=9166) or(a=9165) or(a=9164) or(a=9163) or(a=9162) or(a=9161) or(a=9160) or(a=9159) or(a=9158) or(a=9157) or(a=9156) or(a=9155) or(a=9154) or(a=9153) or(a=9152) or(a=9151) or(a=9150) or(a=9149) or
(a=9148) or(a=9147) or(a=9146) or(a=9145) or(a=9144) or(a=9143) or(a=9142) or(a=9141) or(a=9140) or(a=9139) or(a=9138) or(a=9137) or(a=9136) or(a=9135) or(a=9134) or(a=9133) or(a=9132) or(a=9131) or
(a=9130) or(a=9129) or(a=9128) or(a=9127) or(a=9126) or(a=9125) or(a=9124) or(a=9123) or(a=9122) or(a=9121) or(a=9120) or(a=9119) or(a=9118) or(a=9117) or(a=9116) or(a=9115) or(a=9114) or(a=9113) or
(a=9112) or(a=9111) or(a=9110) or(a=9109) or(a=9108) or(a=9107) or(a=9106) or(a=9105) or(a=9104) or(a=9103) or(a=9102) or(a=9101) or(a=9100) or(a=9099) or(a=9098) or(a=9097) or(a=9096) or(a=9095) or
(a=9094) or(a=9093) or(a=9092) or(a=9091) or(a=9090) or(a=9089) or(a=9088) or(a=9087) or(a=9086) or(a=9085) or(a=9084) or(a=9083) or(a=9082) or(a=9081) or(a=9080) or(a=9079) or(a=9078) or(a=9077) or
(a=9076) or(a=9075) or(a=9074) or(a=9073) or(a=9072) or(a=9071) or(a=9070) or(a=9069) or(a=9068) or(a=9067) or(a=9066) or(a=9065) or(a=9064) or(a=9063) or(a=9062) or(a=9061) or(a=9060) or(a=9059) or
(a=9058) or(a=9057) or(a=9056) or(a=9055) or(a=9054) or(a=9053) or(a=9052) or(a=9051) or(a=9050) or(a=9049) or(a=9048) or(a=9047) or(a=9046) or(a=9045) or(a=9044) or(a=9043) or(a=9042) or(a=9041) or
(a=9040) or(a=9039) or(a=9038) or(a=9037) or(a=9036) or(a=9035) or(a=9034) or(a=9033) or(a=9032) or(a=9031) or(a=9030) or(a=9029) or(a=9028) or(a=9027) or(a=9026) or(a=9025) or(a=9024) or(a=9023) or
(a=9022) or(a=9021) or(a=9020) or(a=9019) or(a=9018) or(a=9017) or(a=9016) or(a=9015) or(a=9014) or(a=9013) or(a=9012) or(a=9011) or(a=9010) or(a=9009) or(a=9008) or(a=9007) or(a=9006) or(a=9005) or(a=9004) or(a=9003) or(a=9002) or
(a=9001) or(a=9000) or(a=8999) or(a=8998) or(a=8997) or(a=8996) or(a=8995) or(a=8994) or(a=8993) or(a=8992) or(a=8991) or(a=8990) or(a=8989) or(a=8988) or(a=8987) or(a=8986) or(a=8985) or(a=8984) or(a=8983) or(a=8982) or(a=8981) or
(a=8980) or(a=8979) or(a=8978) or(a=8977) or(a=8976) or(a=8975) or(a=8974) or(a=8973) or(a=8972) or(a=8971) or(a=8970) or(a=8969) or(a=8968) or(a=8967) or(a=8966) or(a=8965) or(a=8964) or(a=8963) or(a=8962) or(a=8961) or(a=8960) or
(a=8959) or(a=8958) or(a=8957) or(a=8956) or(a=8955) or(a=8954) or(a=8953) or(a=8952) or(a=8951) or(a=8950) or(a=8949) or(a=8948) or(a=8947) or(a=8946) or(a=8945) or(a=8944) or(a=8943) or(a=8942) or(a=8941) or(a=8940) or(a=8939) or
(a=8938) or(a=8937) or(a=8936) or(a=8935) or(a=8934) or(a=8933) or(a=8932) or(a=8931) or(a=8930) or(a=8929) or(a=8928) or(a=8927) or(a=8926) or(a=8925) or(a=8924) or(a=8923) or(a=8922) or(a=8921) or(a=8920) or(a=8919) or(a=8918) or
(a=8917) or(a=8916) or(a=8915) or(a=8914) or(a=8913) or(a=8912) or(a=8911) or(a=8910) or(a=8909) or(a=8908) or(a=8907) or(a=8906) or(a=8905) or(a=8904) or(a=8903) or(a=8902) or(a=8901) or(a=8900) or(a=8899) or(a=8898) or(a=8897) or(a=8896) or(a=8895) or(a=8894) or(a=8893) or(a=8892) or(a=8891) or(a=8890) or(a=8889) or(a=8888) or
(a=8887) or(a=8886) or(a=8885) or(a=8884) or(a=8883) or(a=8882) or(a=8881) or(a=8880) or(a=8879) or(a=8878) or(a=8877) or(a=8876) or(a=8875) or(a=8874) or(a=8873) or(a=8872) or(a=8871) or(a=8870) or(a=8869) or(a=8868) or(a=8867) or(a=8866) or(a=8865) or(a=8864) or(a=8863) or(a=8862) or(a=8861) or(a=8860) or(a=8859) or(a=8858) or
(a=8857) or(a=8856) or(a=8855) or(a=8854) or(a=8853) or(a=8852) or(a=8851) or(a=8850) or(a=8849) or(a=8848) or(a=8847) or(a=8846) or(a=8845) or(a=8844) or(a=8843) or(a=8842) or(a=8841) or(a=8840) or(a=8839) or(a=8838) or(a=8837) or(a=8836) or(a=8835) or(a=8834) or(a=8833) or(a=8832) or(a=8831) or(a=8830) or(a=8829) or(a=8828) or
(a=8827) or(a=8826) or(a=8825) or(a=8824) or(a=8823) or(a=8822) or(a=8821) or(a=8820) or(a=8819) or(a=8818) or(a=8817) or(a=8816) or(a=8815) or(a=8814) or(a=8813) or(a=8812) or(a=8811) or(a=8810) or(a=8809) or(a=8808) or(a=8807) or(a=8806) or(a=8805) or(a=8804) or(a=8803) or(a=8802) or(a=8801) or(a=8800) or(a=8799) or(a=8798) or
(a=8797) or(a=8796) or(a=8795) or(a=8794) or(a=8793) or(a=8792) or(a=8791) or(a=8790) or(a=8789) or(a=8788) or(a=8787) or(a=8786) or(a=8785) or(a=8784) or(a=8783) or(a=8782) or(a=8781) or(a=8780) or(a=8779) or(a=8778) or(a=8777) or(a=8776) or(a=8775) or(a=8774) or(a=8773) or(a=8772) or(a=8771) or(a=8770) or(a=8769) or(a=8768) or
(a=8767) or(a=8766) or(a=8765) or(a=8764) or(a=8763) or(a=8762) or(a=8761) or(a=8760) or(a=8759) or(a=8758) or(a=8757) or(a=8756) or(a=8755) or(a=8754) or(a=8753) or(a=8752) or(a=8751) or(a=8750) or(a=8749) or(a=8748) or(a=8747) or(a=8746) or(a=8745) or(a=8744) or(a=8743) or(a=8742) or(a=8741) or(a=8740) or(a=8739) or(a=8738) or
(a=8737) or(a=8736) or(a=8735) or(a=8734) or(a=8733) or(a=8732) or(a=8731) or(a=8730) or(a=8729) or(a=8728) or(a=8727) or(a=8726) or(a=8725) or(a=8724) or(a=8723) or(a=8722) or(a=8721) or(a=8720) or(a=8719) or(a=8718) or(a=8717) or(a=8716) or(a=8715) or(a=8714) or(a=8713) or(a=8712) or(a=8711) or(a=8710) or(a=8709) or(a=8708) or
(a=8707) or(a=8706) or(a=8705) or(a=8704) or(a=8703) or(a=8702) or(a=8701) or(a=8700) or(a=8699) or(a=8698) or(a=8697) or(a=8696) or(a=8695) or(a=8694) or(a=8693) or(a=8692) or(a=8691) or(a=8690) or(a=8689) or(a=8688) or(a=8687) or(a=8686) or(a=8685) or(a=8684) or(a=8683) or(a=8682) or(a=8681) or(a=8680) or(a=8679) or(a=8678) or
(a=8677) or(a=8676) or(a=8675) or(a=8674) or(a=8673) or(a=8672) or(a=8671) or(a=8670) or(a=8669) or(a=8668) or(a=8667) or(a=8666) or(a=8665) or(a=8664) or(a=8663) or(a=8662) or(a=8661) or(a=8660) or(a=8659) or(a=8658) or(a=8657) or(a=8656) or(a=8655) or(a=8654) or(a=8653) or(a=8652) or(a=8651) or(a=8650) or(a=8649) or(a=8648) or
(a=8647) or(a=8646) or(a=8645) or(a=8644) or(a=8643) or(a=8642) or(a=8641) or(a=8640) or(a=8639) or(a=8638) or(a=8637) or(a=8636) or(a=8635) or(a=8634) or(a=8633) or(a=8632) or(a=8631) or(a=8630) or(a=8629) or(a=8628) or(a=8627) or(a=8626) or(a=8625) or(a=8624) or(a=8623) or(a=8622) or(a=8621) or(a=8620) or(a=8619) or(a=8618) or
(a=8617) or(a=8616) or(a=8615) or(a=8614) or(a=8613) or(a=8612) or(a=8611) or(a=8610) or(a=8609) or(a=8608) or(a=8607) or(a=8606) or(a=8605) or(a=8604) or(a=8603) or(a=8602) or(a=8601) or(a=8600) or(a=8599) or(a=8598) or(a=8597) or(a=8596) or(a=8595) or(a=8594) or(a=8593) or(a=8592) or(a=8591) or(a=8590) or(a=8589) or(a=8588) or
(a=8587) or(a=8586) or(a=8585) or(a=8584) or(a=8583) or(a=8582) or(a=8581) or(a=8580) or(a=8579) or(a=8578) or(a=8577) or(a=8576) or(a=8575) or(a=8574) or(a=8573) or(a=8572) or(a=8571) or(a=8570) or(a=8569) or(a=8568) or(a=8567) or(a=8566) or(a=8565) or(a=8564) or(a=8563) or(a=8562) or(a=8561) or(a=8560) or(a=8559) or(a=8558) or
(a=8557) or(a=8556) or(a=8555) or(a=8554) or(a=8553) or(a=8552) or(a=8551) or(a=8550) or(a=8549) or(a=8548) or(a=8547) or(a=8546) or(a=8545) or(a=8544) or(a=8543) or(a=8542) or(a=8541) or(a=8540) or(a=8539) or(a=8538) or(a=8537) or(a=8536) or(a=8535) or(a=8534) or(a=8533) or(a=8532) or(a=8531) or(a=8530) or(a=8529) or(a=8528) or
(a=8527) or(a=8526) or(a=8525) or(a=8524) or(a=8523) or(a=8522) or(a=8521) or(a=8520) or(a=8519) or(a=8518) or(a=8517) or(a=8516) or(a=8515) or(a=8514) or(a=8513) or(a=8512) or(a=8511) or(a=8510) or(a=8509) or(a=8508) or(a=8507) or(a=8506) or(a=8505) or(a=8504) or(a=8503) or(a=8502) or(a=8501) or(a=8500) or(a=8499) or(a=8498) or
(a=8497) or(a=8496) or(a=8495) or(a=8494) or(a=8493) or(a=8492) or(a=8491) or(a=8490) or(a=8489) or(a=8488) or(a=8487) or(a=8486) or(a=8485) or(a=8484) or(a=8483) or(a=8482) or(a=8481) or(a=8480) or(a=8479) or(a=8478) or(a=8477) or(a=8476) or(a=8475) or(a=8474) or(a=8473) or(a=8472) or(a=8471) or(a=8470) or(a=8469) or(a=8468) or
(a=8467) or(a=8466) or(a=8465) or(a=8464) or(a=8463) or(a=8462) or(a=8461) or(a=8460) or(a=8459) or(a=8458) or(a=8457) or(a=8456) or(a=8455) or(a=8454) or(a=8453) or(a=8452) or(a=8451) or(a=8450) or(a=8449) or(a=8448) or(a=8447) or(a=8446) or(a=8445) or(a=8444) or(a=8443) or(a=8442) or(a=8441) or(a=8440) or(a=8439) or(a=8438) or
(a=8437) or(a=8436) or(a=8435) or(a=8434) or(a=8433) or(a=8432) or(a=8431) or(a=8430) or(a=8429) or(a=8428) or(a=8427) or(a=8426) or(a=8425) or(a=8424) or(a=8423) or(a=8422) or(a=8421) or(a=8420) or(a=8419) or(a=8418) or(a=8417) or(a=8416) or(a=8415) or(a=8414) or(a=8413) or(a=8412) or(a=8411) or(a=8410) or(a=8409) or(a=8408) or
(a=8407) or(a=8406) or(a=8405) or(a=8404) or(a=8403) or(a=8402) or(a=8401) or(a=8400) or(a=8399) or(a=8398) or(a=8397) or(a=8396) or(a=8395) or(a=8394) or(a=8393) or(a=8392) or(a=8391) or(a=8390) or(a=8389) or(a=8388) or(a=8387) or(a=8386) or(a=8385) or(a=8384) or(a=8383) or(a=8382) or(a=8381) or(a=8380) or(a=8379) or(a=8378) or
(a=8377) or(a=8376) or(a=8375) or(a=8374) or(a=8373) or(a=8372) or(a=8371) or(a=8370) or(a=8369) or(a=8368) or(a=8367) or(a=8366) or(a=8365) or(a=8364) or(a=8363) or(a=8362) or(a=8361) or(a=8360) or(a=8359) or(a=8358) or(a=8357) or(a=8356) or(a=8355) or(a=8354) or(a=8353) or(a=8352) or(a=8351) or(a=8350) or(a=8349) or(a=8348) or
(a=8347) or(a=8346) or(a=8345) or(a=8344) or(a=8343) or(a=8342) or(a=8341) or(a=8340) or(a=8339) or(a=8338) or(a=8337) or(a=8336) or(a=8335) or(a=8334) or(a=8333) or(a=8332) or(a=8331) or(a=8330) or(a=8329) or(a=8328) or(a=8327) or(a=8326) or(a=8325) or(a=8324) or(a=8323) or(a=8322) or(a=8321) or(a=8320) or(a=8319) or(a=8318) or
(a=8317) or(a=8316) or(a=8315) or(a=8314) or(a=8313) or(a=8312) or(a=8311) or(a=8310) or(a=8309) or(a=8308) or(a=8307) or(a=8306) or(a=8305) or(a=8304) or(a=8303) or(a=8302) or(a=8301) or(a=8300) or(a=8299) or(a=8298) or(a=8297) or(a=8296) or(a=8295) or(a=8294) or(a=8293) or(a=8292) or(a=8291) or(a=8290) or(a=8289) or(a=8288) or
(a=8287) or(a=8286) or(a=8285) or(a=8284) or(a=8283) or(a=8282) or(a=8281) or(a=8280) or(a=8279) or(a=8278) or(a=8277) or(a=8276) or(a=8275) or(a=8274) or(a=8273) or(a=8272) or(a=8271) or(a=8270) or(a=8269) or(a=8268) or(a=8267) or(a=8266) or(a=8265) or(a=8264) or(a=8263) or(a=8262) or(a=8261) or(a=8260) or(a=8259) or(a=8258) or
(a=8257) or(a=8256) or(a=8255) or(a=8254) or(a=8253) or(a=8252) or(a=8251) or(a=8250) or(a=8249) or(a=8248) or(a=8247) or(a=8246) or(a=8245) or(a=8244) or(a=8243) or(a=8242) or(a=8241) or(a=8240) or(a=8239) or(a=8238) or(a=8237) or(a=8236) or(a=8235) or(a=8234) or(a=8233) or(a=8232) or(a=8231) or(a=8230) or(a=8229) or(a=8228) or
(a=8227) or(a=8226) or(a=8225) or(a=8224) or(a=8223) or(a=8222) or(a=8221) or(a=8220) or(a=8219) or(a=8218) or(a=8217) or(a=8216) or(a=8215) or(a=8214) or(a=8213) or(a=8212) or(a=8211) or(a=8210) or(a=8209) or(a=8208) or(a=8207) or(a=8206) or(a=8205) or(a=8204) or(a=8203) or(a=8202) or(a=8201) or(a=8200) or(a=8199) or(a=8198) or
(a=8197) or(a=8196) or(a=8195) or(a=8194) or(a=8193) or(a=8192) or(a=8191) or(a=8190) or(a=8189) or(a=8188) or(a=8187) or(a=8186) or(a=8185) or(a=8184) or(a=8183) or(a=8182) or(a=8181) or(a=8180) or(a=8179) or(a=8178) or(a=8177) or(a=8176) or(a=8175) or(a=8174) or(a=8173) or(a=8172) or(a=8171) or(a=8170) or(a=8169) or(a=8168) or
(a=8167) or(a=8166) or(a=8165) or(a=8164) or(a=8163) or(a=8162) or(a=8161) or(a=8160) or(a=8159) or(a=8158) or(a=8157) or(a=8156) or(a=8155) or(a=8154) or(a=8153) or(a=8152) or(a=8151) or(a=8150) or(a=8149) or(a=8148) or(a=8147) or(a=8146) or(a=8145) or(a=8144) or(a=8143) or(a=8142) or(a=8141) or(a=8140) or(a=8139) or(a=8138) or
(a=8137) or(a=8136) or(a=8135) or(a=8134) or(a=8133) or(a=8132) or(a=8131) or(a=8130) or(a=8129) or(a=8128) or(a=8127) or(a=8126) or(a=8125) or(a=8124) or(a=8123) or(a=8122) or(a=8121) or(a=8120) or(a=8119) or(a=8118) or(a=8117) or(a=8116) or(a=8115) or(a=8114) or(a=8113) or(a=8112) or(a=8111) or(a=8110) or(a=8109) or(a=8108) or
(a=8107) or(a=8106) or(a=8105) or(a=8104) or(a=8103) or(a=8102) or(a=8101) or(a=8100) or(a=8099) or(a=8098) or(a=8097) or(a=8096) or(a=8095) or(a=8094) or(a=8093) or(a=8092) or(a=8091) or(a=8090) or(a=8089) or(a=8088) or(a=8087) or(a=8086) or(a=8085) or(a=8084) or(a=8083) or(a=8082) or(a=8081) or(a=8080) or(a=8079) or(a=8078) or
(a=8077) or(a=8076) or(a=8075) or(a=8074) or(a=8073) or(a=8072) or(a=8071) or(a=8070) or(a=8069) or(a=8068) or(a=8067) or(a=8066) or(a=8065) or(a=8064) or(a=8063) or(a=8062) or(a=8061) or(a=8060) or(a=8059) or(a=8058) or(a=8057) or(a=8056) or(a=8055) or(a=8054) or(a=8053) or(a=8052) or(a=8051) or(a=8050) or(a=8049) or(a=8048) or
(a=8047) or(a=8046) or(a=8045) or(a=8044) or(a=8043) or(a=8042) or(a=8041) or(a=8040) or(a=8039) or(a=8038) or(a=8037) or(a=8036) or(a=8035) or(a=8034) or(a=8033) or(a=8032) or(a=8031) or(a=8030) or(a=8029) or(a=8028) or(a=8027) or(a=8026) or(a=8025) or(a=8024) or(a=8023) or(a=8022) or(a=8021) or(a=8020) or(a=8019) or(a=8018) or
(a=8017) or(a=8016) or(a=8015) or(a=8014) or(a=8013) or(a=8012) or(a=8011) or(a=8010) or(a=8009) or(a=8008) or(a=8007) or(a=8006) or(a=8005) or(a=8004) or(a=8003) or(a=8002) or(a=8001) or(a=8000) or(a=7999) or(a=7998) or(a=7997) or(a=7996) or(a=7995) or(a=7994) or(a=7993) or(a=7992) or(a=7991) or(a=7990) or(a=7989) or(a=7988) or
(a=7987) or(a=7986) or(a=7985) or(a=7984) or(a=7983) or(a=7982) or(a=7981) or(a=7980) or(a=7979) or(a=7978) or(a=7977) or(a=7976) or(a=7975) or(a=7974) or(a=7973) or(a=7972) or(a=7971) or(a=7970) or(a=7969) or(a=7968) or(a=7967) or(a=7966) or(a=7965) or(a=7964) or(a=7963) or(a=7962) or(a=7961) or(a=7960) or(a=7959) or(a=7958) or
(a=7957) or(a=7956) or(a=7955) or(a=7954) or(a=7953) or(a=7952) or(a=7951) or(a=7950) or(a=7949) or(a=7948) or(a=7947) or(a=7946) or(a=7945) or(a=7944) or(a=7943) or(a=7942) or(a=7941) or(a=7940) or(a=7939) or(a=7938) or(a=7937) or(a=7936) or(a=7935) or(a=7934) or(a=7933) or(a=7932) or(a=7931) or(a=7930) or(a=7929) or(a=7928) or
(a=7927) or(a=7926) or(a=7925) or(a=7924) or(a=7923) or(a=7922) or(a=7921) or(a=7920) or(a=7919) or(a=7918) or(a=7917) or(a=7916) or(a=7915) or(a=7914) or(a=7913) or(a=7912) or(a=7911) or(a=7910) or(a=7909) or(a=7908) or(a=7907) or(a=7906) or(a=7905) or(a=7904) or(a=7903) or(a=7902) or(a=7901) or(a=7900) or(a=7899) or(a=7898) or
(a=7897) or(a=7896) or(a=7895) or(a=7894) or(a=7893) or(a=7892) or(a=7891) or(a=7890) or(a=7889) or(a=7888) or(a=7887) or(a=7886) or(a=7885) or(a=7884) or(a=7883) or(a=7882) or(a=7881) or(a=7880) or(a=7879) or(a=7878) or(a=7877) or(a=7876) or(a=7875) or(a=7874) or(a=7873) or(a=7872) or(a=7871) or(a=7870) or(a=7869) or(a=7868) or
(a=7867) or(a=7866) or(a=7865) or(a=7864) or(a=7863) or(a=7862) or(a=7861) or(a=7860) or(a=7859) or(a=7858) or(a=7857) or(a=7856) or(a=7855) or(a=7854) or(a=7853) or(a=7852) or(a=7851) or(a=7850) or(a=7849) or(a=7848) or(a=7847) or(a=7846) or(a=7845) or(a=7844) or(a=7843) or(a=7842) or(a=7841) or(a=7840) or(a=7839) or(a=7838) or
(a=7837) or(a=7836) or(a=7835) or(a=7834) or(a=7833) or(a=7832) or(a=7831) or(a=7830) or(a=7829) or(a=7828) or(a=7827) or(a=7826) or(a=7825) or(a=7824) or(a=7823) or(a=7822) or(a=7821) or(a=7820) or(a=7819) or(a=7818) or(a=7817) or(a=7816) or(a=7815) or(a=7814) or(a=7813) or(a=7812) or(a=7811) or(a=7810) or(a=7809) or(a=7808) or
(a=7807) or(a=7806) or(a=7805) or(a=7804) or(a=7803) or(a=7802) or(a=7801) or(a=7800) or(a=7799) or(a=7798) or(a=7797) or(a=7796) or(a=7795) or(a=7794) or(a=7793) or(a=7792) or(a=7791) or(a=7790) or(a=7789) or(a=7788) or(a=7787) or(a=7786) or(a=7785) or(a=7784) or(a=7783) or(a=7782) or(a=7781) or(a=7780) or(a=7779) or(a=7778) or
(a=7777) or(a=7776) or(a=7775) or(a=7774) or(a=7773) or(a=7772) or(a=7771) or(a=7770) or(a=7769) or(a=7768) or(a=7767) or(a=7766) or(a=7765) or(a=7764) or(a=7763) or(a=7762) or(a=7761) or(a=7760) or(a=7759) or(a=7758) or(a=7757) or(a=7756) or(a=7755) or(a=7754) or(a=7753) or(a=7752) or(a=7751) or(a=7750) or(a=7749) or(a=7748) or
(a=7747) or(a=7746) or(a=7745) or(a=7744) or(a=7743) or(a=7742) or(a=7741) or(a=7740) or(a=7739) or(a=7738) or(a=7737) or(a=7736) or(a=7735) or(a=7734) or(a=7733) or(a=7732) or(a=7731) or(a=7730) or(a=7729) or(a=7728) or(a=7727) or(a=7726) or(a=7725) or(a=7724) or(a=7723) or(a=7722) or(a=7721) or(a=7720) or(a=7719) or(a=7718) or
(a=7717) or(a=7716) or(a=7715) or(a=7714) or(a=7713) or(a=7712) or(a=7711) or(a=7710) or(a=7709) or(a=7708) or(a=7707) or(a=7706) or(a=7705) or(a=7704) or(a=7703) or(a=7702) or(a=7701) or(a=7700) or(a=7699) or(a=7698) or(a=7697) or(a=7696) or(a=7695) or(a=7694) or(a=7693) or(a=7692) or(a=7691) or(a=7690) or(a=7689) or(a=7688) or
(a=7687) or(a=7686) or(a=7685) or(a=7684) or(a=7683) or(a=7682) or(a=7681) or(a=7680) or(a=7679) or(a=7678) or(a=7677) or(a=7676) or(a=7675) or(a=7674) or(a=7673) or(a=7672) or(a=7671) or(a=7670) or(a=7669) or(a=7668) or(a=7667) or(a=7666) or(a=7665) or(a=7664) or(a=7663) or(a=7662) or(a=7661) or(a=7660) or(a=7659) or(a=7658) or
(a=7657) or(a=7656) or(a=7655) or(a=7654) or(a=7653) or(a=7652) or(a=7651) or(a=7650) or(a=7649) or(a=7648) or(a=7647) or(a=7646) or(a=7645) or(a=7644) or(a=7643) or(a=7642) or(a=7641) or(a=7640) or(a=7639) or(a=7638) or(a=7637) or(a=7636) or(a=7635) or(a=7634) or(a=7633) or(a=7632) or(a=7631) or(a=7630) or(a=7629) or(a=7628) or
(a=7627) or(a=7626) or(a=7625) or(a=7624) or(a=7623) or(a=7622) or(a=7621) or(a=7620) or(a=7619) or(a=7618) or(a=7617) or(a=7616) or(a=7615) or(a=7614) or(a=7613) or(a=7612) or(a=7611) or(a=7610) or(a=7609) or(a=7608) or(a=7607) or(a=7606) or(a=7605) or(a=7604) or(a=7603) or(a=7602) or(a=7601) or(a=7600) or(a=7599) or(a=7598) or
(a=7597) or(a=7596) or(a=7595) or(a=7594) or(a=7593) or(a=7592) or(a=7591) or(a=7590) or(a=7589) or(a=7588) or(a=7587) or(a=7586) or(a=7585) or(a=7584) or(a=7583) or(a=7582) or(a=7581) or(a=7580) or(a=7579) or(a=7578) or(a=7577) or(a=7576) or(a=7575) or(a=7574) or(a=7573) or(a=7572) or(a=7571) or(a=7570) or(a=7569) or(a=7568) or
(a=7567) or(a=7566) or(a=7565) or(a=7564) or(a=7563) or(a=7562) or(a=7561) or(a=7560) or(a=7559) or(a=7558) or(a=7557) or(a=7556) or(a=7555) or(a=7554) or(a=7553) or(a=7552) or(a=7551) or(a=7550) or(a=7549) or(a=7548) or(a=7547) or(a=7546) or(a=7545) or(a=7544) or(a=7543) or(a=7542) or(a=7541) or(a=7540) or(a=7539) or(a=7538) or
(a=7537) or(a=7536) or(a=7535) or(a=7534) or(a=7533) or(a=7532) or(a=7531) or(a=7530) or(a=7529) or(a=7528) or(a=7527) or(a=7526) or(a=7525) or(a=7524) or(a=7523) or(a=7522) or(a=7521) or(a=7520) or(a=7519) or(a=7518) or(a=7517) or(a=7516) or(a=7515) or(a=7514) or(a=7513) or(a=7512) or(a=7511) or(a=7510) or(a=7509) or(a=7508) or
(a=7507) or(a=7506) or(a=7505) or(a=7504) or(a=7503) or(a=7502) or(a=7501) or(a=7500) or(a=7499) or(a=7498) or(a=7497) or(a=7496) or(a=7495) or(a=7494) or(a=7493) or(a=7492) or(a=7491) or(a=7490) or(a=7489) or(a=7488) or(a=7487) or(a=7486) or(a=7485) or(a=7484) or(a=7483) or(a=7482) or(a=7481) or(a=7480) or(a=7479) or(a=7478) or
(a=7477) or(a=7476) or(a=7475) or(a=7474) or(a=7473) or(a=7472) or(a=7471) or(a=7470) or(a=7469) or(a=7468) or(a=7467) or(a=7466) or(a=7465) or(a=7464) or(a=7463) or(a=7462) or(a=7461) or(a=7460) or(a=7459) or(a=7458) or(a=7457) or(a=7456) or(a=7455) or(a=7454) or(a=7453) or(a=7452) or(a=7451) or(a=7450) or(a=7449) or(a=7448) or
(a=7447) or(a=7446) or(a=7445) or(a=7444) or(a=7443) or(a=7442) or(a=7441) or(a=7440) or(a=7439) or(a=7438) or(a=7437) or(a=7436) or(a=7435) or(a=7434) or(a=7433) or(a=7432) or(a=7431) or(a=7430) or(a=7429) or(a=7428) or(a=7427) or(a=7426) or(a=7425) or(a=7424) or(a=7423) or(a=7422) or(a=7421) or(a=7420) or(a=7419) or(a=7418) or
(a=7417) or(a=7416) or(a=7415) or(a=7414) or(a=7413) or(a=7412) or(a=7411) or(a=7410) or(a=7409) or(a=7408) or(a=7407) or(a=7406) or(a=7405) or(a=7404) or(a=7403) or(a=7402) or(a=7401) or(a=7400) or(a=7399) or(a=7398) or(a=7397) or(a=7396) or(a=7395) or(a=7394) or(a=7393) or(a=7392) or(a=7391) or(a=7390) or(a=7389) or(a=7388) or
(a=7387) or(a=7386) or(a=7385) or(a=7384) or(a=7383) or(a=7382) or(a=7381) or(a=7380) or(a=7379) or(a=7378) or(a=7377) or(a=7376) or(a=7375) or(a=7374) or(a=7373) or(a=7372) or(a=7371) or(a=7370) or(a=7369) or(a=7368) or(a=7367) or(a=7366) or(a=7365) or(a=7364) or(a=7363) or(a=7362) or(a=7361) or(a=7360) or(a=7359) or(a=7358) or
(a=7357) or(a=7356) or(a=7355) or(a=7354) or(a=7353) or(a=7352) or(a=7351) or(a=7350) or(a=7349) or(a=7348) or(a=7347) or(a=7346) or(a=7345) or(a=7344) or(a=7343) or(a=7342) or(a=7341) or(a=7340) or(a=7339) or(a=7338) or(a=7337) or(a=7336) or(a=7335) or(a=7334) or(a=7333) or(a=7332) or(a=7331) or(a=7330) or(a=7329) or(a=7328) or
(a=7327) or(a=7326) or(a=7325) or(a=7324) or(a=7323) or(a=7322) or(a=7321) or(a=7320) or(a=7319) or(a=7318) or(a=7317) or(a=7316) or(a=7315) or(a=7314) or(a=7313) or(a=7312) or(a=7311) or(a=7310) or(a=7309) or(a=7308) or(a=7307) or(a=7306) or(a=7305) or(a=7304) or(a=7303) or(a=7302) or(a=7301) or(a=7300) or(a=7299) or(a=7298) or
(a=7297) or(a=7296) or(a=7295) or(a=7294) or(a=7293) or(a=7292) or(a=7291) or(a=7290) or(a=7289) or(a=7288) or(a=7287) or(a=7286) or(a=7285) or(a=7284) or(a=7283) or(a=7282) or(a=7281) or(a=7280) or(a=7279) or(a=7278) or(a=7277) or(a=7276) or(a=7275) or(a=7274) or(a=7273) or(a=7272) or(a=7271) or(a=7270) or(a=7269) or(a=7268) or
(a=7267) or(a=7266) or(a=7265) or(a=7264) or(a=7263) or(a=7262) or(a=7261) or(a=7260) or(a=7259) or(a=7258) or(a=7257) or(a=7256) or(a=7255) or(a=7254) or(a=7253) or(a=7252) or(a=7251) or(a=7250) or(a=7249) or(a=7248) or(a=7247) or(a=7246) or(a=7245) or(a=7244) or(a=7243) or(a=7242) or(a=7241) or(a=7240) or(a=7239) or(a=7238) or
(a=7237) or(a=7236) or(a=7235) or(a=7234) or(a=7233) or(a=7232) or(a=7231) or(a=7230) or(a=7229) or(a=7228) or(a=7227) or(a=7226) or(a=7225) or(a=7224) or(a=7223) or(a=7222) or(a=7221) or(a=7220) or(a=7219) or(a=7218) or(a=7217) or(a=7216) or(a=7215) or(a=7214) or(a=7213) or(a=7212) or(a=7211) or(a=7210) or(a=7209) or(a=7208) or
(a=7207) or(a=7206) or(a=7205) or(a=7204) or(a=7203) or(a=7202) or(a=7201) or(a=7200) or(a=7199) or(a=7198) or(a=7197) or(a=7196) or(a=7195) or(a=7194) or(a=7193) or(a=7192) or(a=7191) or(a=7190) or(a=7189) or(a=7188) or(a=7187) or(a=7186) or(a=7185) or(a=7184) or(a=7183) or(a=7182) or(a=7181) or(a=7180) or(a=7179) or(a=7178) or
(a=7177) or(a=7176) or(a=7175) or(a=7174) or(a=7173) or(a=7172) or(a=7171) or(a=7170) or(a=7169) or(a=7168) or(a=7167) or(a=7166) or(a=7165) or(a=7164) or(a=7163) or(a=7162) or(a=7161) or(a=7160) or(a=7159) or(a=7158) or(a=7157) or(a=7156) or(a=7155) or(a=7154) or(a=7153) or(a=7152) or(a=7151) or(a=7150) or(a=7149) or(a=7148) or
(a=7147) or(a=7146) or(a=7145) or(a=7144) or(a=7143) or(a=7142) or(a=7141) or(a=7140) or(a=7139) or(a=7138) or(a=7137) or(a=7136) or(a=7135) or(a=7134) or(a=7133) or(a=7132) or(a=7131) or(a=7130) or(a=7129) or(a=7128) or(a=7127) or(a=7126) or(a=7125) or(a=7124) or(a=7123) or(a=7122) or(a=7121) or(a=7120) or(a=7119) or(a=7118) or
(a=7117) or(a=7116) or(a=7115) or(a=7114) or(a=7113) or(a=7112) or(a=7111) or(a=7110) or(a=7109) or(a=7108) or(a=7107) or(a=7106) or(a=7105) or(a=7104) or(a=7103) or(a=7102) or(a=7101) or(a=7100) or(a=7099) or(a=7098) or(a=7097) or(a=7096) or(a=7095) or(a=7094) or(a=7093) or(a=7092) or(a=7091) or(a=7090) or(a=7089) or(a=7088) or
(a=7087) or(a=7086) or(a=7085) or(a=7084) or(a=7083) or(a=7082) or(a=7081) or(a=7080) or(a=7079) or(a=7078) or(a=7077) or(a=7076) or(a=7075) or(a=7074) or(a=7073) or(a=7072) or(a=7071) or(a=7070) or(a=7069) or(a=7068) or(a=7067) or(a=7066) or(a=7065) or(a=7064) or(a=7063) or(a=7062) or(a=7061) or(a=7060) or(a=7059) or(a=7058) or
(a=7057) or(a=7056) or(a=7055) or(a=7054) or(a=7053) or(a=7052) or(a=7051) or(a=7050) or(a=7049) or(a=7048) or(a=7047) or(a=7046) or(a=7045) or(a=7044) or(a=7043) or(a=7042) or(a=7041) or(a=7040) or(a=7039) or(a=7038) or(a=7037) or(a=7036) or(a=7035) or(a=7034) or(a=7033) or(a=7032) or(a=7031) or(a=7030) or(a=7029) or(a=7028) or
(a=7027) or(a=7026) or(a=7025) or(a=7024) or(a=7023) or(a=7022) or(a=7021) or(a=7020) or(a=7019) or(a=7018) or(a=7017) or(a=7016) or(a=7015) or(a=7014) or(a=7013) or(a=7012) or(a=7011) or(a=7010) or(a=7009) or(a=7008) or(a=7007) or(a=7006) or(a=7005) or(a=7004) or(a=7003) or(a=7002) or(a=7001) or(a=7000) or(a=6999) or(a=6998) or
(a=6997) or(a=6996) or(a=6995) or(a=6994) or(a=6993) or(a=6992) or(a=6991) or(a=6990) or(a=6989) or(a=6988) or(a=6987) or(a=6986) or(a=6985) or(a=6984) or(a=6983) or(a=6982) or(a=6981) or(a=6980) or(a=6979) or(a=6978) or(a=6977) or(a=6976) or(a=6975) or(a=6974) or(a=6973) or(a=6972) or(a=6971) or(a=6970) or(a=6969) or(a=6968) or
(a=6967) or(a=6966) or(a=6965) or(a=6964) or(a=6963) or(a=6962) or(a=6961) or(a=6960) or(a=6959) or(a=6958) or(a=6957) or(a=6956) or(a=6955) or(a=6954) or(a=6953) or(a=6952) or(a=6951) or(a=6950) or(a=6949) or(a=6948) or(a=6947) or(a=6946) or(a=6945) or(a=6944) or(a=6943) or(a=6942) or(a=6941) or(a=6940) or(a=6939) or(a=6938) or
(a=6937) or(a=6936) or(a=6935) or(a=6934) or(a=6933) or(a=6932) or(a=6931) or(a=6930) or(a=6929) or(a=6928) or(a=6927) or(a=6926) or(a=6925) or(a=6924) or(a=6923) or(a=6922) or(a=6921) or(a=6920) or(a=6919) or(a=6918) or(a=6917) or(a=6916) or(a=6915) or(a=6914) or(a=6913) or(a=6912) or(a=6911) or(a=6910) or(a=6909) or(a=6908) or
(a=6907) or(a=6906) or(a=6905) or(a=6904) or(a=6903) or(a=6902) or(a=6901) or(a=6900) or(a=6899) or(a=6898) or(a=6897) or(a=6896) or(a=6895) or(a=6894) or(a=6893) or(a=6892) or(a=6891) or(a=6890) or(a=6889) or(a=6888) or(a=6887) or(a=6886) or(a=6885) or(a=6884) or(a=6883) or(a=6882) or(a=6881) or(a=6880) or(a=6879) or(a=6878) or
(a=6877) or(a=6876) or(a=6875) or(a=6874) or(a=6873) or(a=6872) or(a=6871) or(a=6870) or(a=6869) or(a=6868) or(a=6867) or(a=6866) or(a=6865) or(a=6864) or(a=6863) or(a=6862) or(a=6861) or(a=6860) or(a=6859) or(a=6858) or(a=6857) or(a=6856) or(a=6855) or(a=6854);
drop table t_DTS2020031805402;
--20200615
drop table if exists temp_20200615;
drop index if exists idx_temp_20200615 on temp_20200615;
create table temp_20200615(UID BINARY_INTEGER NOT NULL,
GRANTOR BINARY_INTEGER  NOT NULL,
GRANTEE BINARY_INTEGER NOT NULL,
PRIVILEGE BINARY_INTEGER NOT NULL,
OPTION BINARY_INTEGER);
create unique index idx_temp_20200615 on temp_20200615(uid,grantee,privilege);
insert into temp_20200615 values(0,0,1,0,0);
commit;
--          NL
--         / \
--        a  HASH
--          / \
--         b  NLO
--            / \
--           d   c
select 1 from temp_20200615 as a inner join (((select b.GRANTOR as c0, b.GRANTOR as c5 from temp_20200615 as b) as subq_2) 
inner join ((((temp_20200615 as c)) right join (temp_20200615 as d) on ((c.GRANTOR is not NULL)))) on (subq_2.c0 = d.UID )) on 
(((EXISTS (select 1 from temp_20200615 as e where subq_2.c5 is not NULL limit 73))) or c.UID is not NULL);
select  
  subq_0.c1 as c0, 
  case when (((EXISTS (
            select  
                ref_7.UID as c0, 
                ref_1.GRANTOR as c1, 
                ref_1.GRANTOR as c2, 
                ref_7.UID as c3, 
                subq_2.c10 as c4, 
                ref_15.UID as c5, 
                ref_5.GRANTOR as c6, 
                subq_1.c0 as c7, 
                ref_5.UID as c8, 
                subq_1.c9 as c9, 
                ref_15.GRANTOR as c10
              from 
                temp_20200615 as ref_15
              where true
              limit 142)) 
          and ((false) 
            and (((false) 
                or (false)) 
              and (ref_1.GRANTOR is NULL)))) 
        or ((EXISTS (
            select  
                subq_2.c7 as c0, 
                subq_2.c2 as c1, 
                subq_0.c2 as c2
              from 
                temp_20200615 as ref_16
              where false)) 
          or (ref_6.GRANTOR is not NULL))) 
      or ((EXISTS (
          select  
              ref_17.GRANTOR as c0
            from 
              temp_20200615 as ref_17
            where (true) 
              or ((false) 
                or (ref_6.UID is NULL)))) 
        and (83 is NULL)) then subq_1.c0 else subq_1.c0 end
     as c1
from 
  ((temp_20200615 as ref_0)
      inner join (temp_20200615 as ref_1)
      on (ref_0.GRANTOR = ref_1.UID ))
    inner join (((select  
            (select UID from temp_20200615 limit 1 offset 2)
               as c0, 
            ref_2.UID as c1, 
            80 as c2, 
            ref_2.GRANTOR as c3, 
            ref_2.GRANTOR as c4, 
            ref_2.GRANTOR as c5
          from 
            temp_20200615 as ref_2
          where ref_2.GRANTOR is NULL
          limit 136) as subq_0)
      right join (((select  
              ref_3.GRANTOR as c0, 
              ref_3.GRANTOR as c1, 
              ref_3.GRANTOR as c2, 
              ref_3.GRANTOR as c3, 
              (select GRANTOR from temp_20200615 limit 1 offset 3)
                 as c4, 
              ref_3.GRANTOR as c5, 
              ref_3.GRANTOR as c6, 
              (select UID from temp_20200615 limit 1 offset 58)
                 as c7, 
              (select UID from temp_20200615 limit 1 offset 6)
                 as c8, 
              ref_3.GRANTOR as c9, 
              ref_3.UID as c10, 
              ref_3.GRANTOR as c11
            from 
              temp_20200615 as ref_3
            where ref_3.GRANTOR is not NULL) as subq_1)
        inner join (((select  
                ref_4.GRANTOR as c0, 
                ref_4.GRANTOR as c1, 
                ref_4.GRANTOR as c2, 
                (select GRANTOR from temp_20200615 limit 1 offset 2)
                   as c3, 
                ref_4.GRANTOR as c4, 
                ref_4.GRANTOR as c5, 
                ref_4.GRANTOR as c6, 
                ref_4.UID as c7, 
                (select ID from SYS.SYS_VIEWS limit 1 offset 3)
                   as c8, 
                ref_4.GRANTOR as c9, 
                ref_4.GRANTOR as c10
              from 
                temp_20200615 as ref_4
              where true) as subq_2)
          inner join ((temp_20200615 as ref_5)
            inner join (((temp_20200615 as ref_6)
                inner join (temp_20200615 as ref_7)
                on (ref_6.GRANTOR = ref_7.UID ))
              right join (temp_20200615 as ref_8)
              on ((false) 
                  or (ref_6.GRANTOR is not NULL)))
            on ((ref_7.GRANTOR is not NULL) 
                or ((ref_6.UID is NULL) 
                  or (EXISTS (
                    select  
                        ref_9.VIEW# as c0, 
                        ref_5.GRANTOR as c1, 
                        ref_5.GRANTOR as c2, 
                        ref_5.UID as c3, 
                        ref_7.GRANTOR as c4, 
                        ref_7.GRANTOR as c5
                      from 
                        SYS.SYS_VIEW_COLS as ref_9
                      where false)))))
          on (subq_2.c0 = ref_8.UID ))
        on (((EXISTS (
                select  
                    ref_7.GRANTOR as c0, 
                    ref_8.GRANTOR as c1, 
                    ref_7.GRANTOR as c2
                  from 
                    temp_20200615 as ref_10
                  where subq_2.c5 is not NULL
                  limit 73)) 
              or (EXISTS (
                select  
                    subq_1.c2 as c0, 
                    ref_6.GRANTOR as c1, 
                    ref_11.GRANTOR as c2, 
                    ref_5.UID as c3
                  from 
                    temp_20200615 as ref_11
                  where subq_2.c1 is not NULL
                  limit 36))) 
            or ((ref_6.UID is not NULL) 
              or (EXISTS (
                select  
                    ref_6.GRANTOR as c0, 
                    (select abs(UID) from temp_20200615)
                       as c1, 
                    subq_1.c2 as c2
                  from 
                    temp_20200615 as ref_12
                  where ref_8.GRANTOR is not NULL)))))
      on (((subq_0.c0 is not NULL) 
            and (false)) 
          or (EXISTS (
            select  
                ref_14.GRANTOR as c0, 
                ref_6.UID as c1, 
                47 as c2
              from 
                (temp_20200615 as ref_13)
                  inner join (temp_20200615 as ref_14)
                  on ((false) 
                      and (true))
              where subq_1.c0 is NULL
              limit 133))))
    on ((subq_1.c0 is not NULL) 
        or ((true) 
          and (false)))
where ref_8.UID is not NULL
limit 105;
--20200619
insert into temp_20200615 values(2,2,1,0,0);
commit;
select  
  13 as c4
from 
  ((((SYS.SYS_USER_ROLES as ref_0))
        right join ((((temp_20200615 as ref_7)
              right join (temp_20200615 as ref_8)
              on (true))
            inner join (((temp_20200615 as ref_9)
                inner join ((temp_20200615 as ref_10)
                  inner join (temp_20200615 as ref_11)
                  on (false))
                on ((false))))
            on (true))
          inner join (temp_20200615 as ref_14)
          on (false))
        on ((ref_10.GRANTOR is not NULL)))
      inner join ((select  
            ref_16.GRANTOR as c0, 
            ref_16.GRANTOR as c1, 
            ref_16.UID as c2
          from 
            temp_20200615 as ref_16
          where true
          limit 145) as subq_1)
      on ((false)))
    inner join (((select  
            ref_17.GRANTOR as c0, 
            ref_17.GRANTOR as c1, 
            ref_17.GRANTOR as c2, 
            ref_17.GRANTOR as c3, 
            ref_17.GRANTOR as c4
          from 
            temp_20200615 as ref_17
          where (((((false)))) ) 
            and (ref_17.GRANTOR is not NULL)
          limit 175) as subq_2)
      inner join (((((temp_20200615 as ref_23)
              left join (temp_20200615 as ref_24)
              on (((ref_23.UID is NULL) 
                    or ((((ref_23.UID is not NULL))) 
                      or ((ref_24.GRANTOR is not NULL))))))
            inner join ((temp_20200615 as ref_26)
              right join (temp_20200615 as ref_27)
              on (((ref_26.GRANTOR is not NULL))))
            on ((ref_24.GRANTOR is not NULL) 
                or (70 is not NULL)))
          left join (temp_20200615 as ref_29)
          on (true)))
      on (subq_2.c3 = ref_26.UID ))
    on ((((EXISTS (
              select  
                  ref_11.UID as c0, 
                  ref_8.GRANTOR as c1
                from 
                  temp_20200615 as ref_47
                where 16 is not NULL
                limit 60)) 
            and (((((ref_14.GRANTOR is NULL)) 
                  and ((subq_2.c3 is NULL) 
                    or ((ref_23.GRANTOR is NULL)))) 
                and (((ref_9.GRANTOR is NULL)))))) 
          or (subq_2.c3 is not NULL)));
select  
  case when ((((((((true) 
                    or ((false) 
                      or ((EXISTS (
                          select  
                              ref_11.GRANTOR as c0, 
                              ref_14.GRANTOR as c1, 
                              ref_44.GRANTOR as c2, 
                              ref_15.ID as c3, 
                              ref_42.GRANTOR as c4, 
                              ref_46.GRANTOR as c5, 
                              ref_10.UID as c6, 
                              ref_17.UID as c7
                            from 
                              temp_20200615 as ref_46
                            where true)) 
                        or ((true) 
                          and ((ref_22.GRANTOR is not NULL) 
                            and ((ref_11.GRANTOR is not NULL) 
                              and (ref_39.UID is not NULL))))))) 
                  or ((ref_16.ID is not NULL) 
                    and (false))) 
                or ((true) 
                  or (true))) 
              and ((ref_11.GRANTOR is NULL) 
                and ((true) 
                  or (((EXISTS (
                        select  
                            ref_44.GRANTOR as c0, 
                            ref_13.GRANTOR as c1, 
                            (select GRANTOR from temp_20200615 limit 1 offset 2)
                               as c2, 
                            ref_23.GRANTOR as c3
                          from 
                            temp_20200615 as ref_47
                          where false)) 
                      and (false)) 
                    and (false))))) 
            or (ref_41.GRANTOR is not NULL)) 
          or (EXISTS (
            select  
                ref_48.ID as c0, 
                ref_40.GRANTOR as c1, 
                ref_27.GRANTEE_TYPE as c2, 
                ref_48.ID as c3, 
                ref_21.GRANTOR as c4
              from 
                (SYS.SYS_VIEWS as ref_48)
                  inner join (temp_20200615 as ref_49)
                  on (ref_23.GRANTOR is NULL)
              where EXISTS (
                select  
                    ref_26.ID as c0, 
                    ref_20.GRANTOR as c1, 
                    ref_11.GRANTOR as c2, 
                    ref_23.GRANTOR as c3, 
                    ref_43.STMTID as c4, 
                    ref_10.GRANTOR as c5
                  from 
                    temp_20200615 as ref_50
                  where true
                  limit 145)))) 
        and (((select GRANTOR from temp_20200615 limit 1 offset 2)
               is not NULL) 
          and (EXISTS (
            select  
                ref_21.GRANTOR as c0
              from 
                temp_20200615 as ref_51
              where false)))) 
      or ((true) 
        and (((false) 
            or (ref_41.GRANTOR is not NULL)) 
          and ((90 is NULL) 
            and ((((ref_22.GRANTOR is NULL) 
                  or (true)) 
                or ((ref_17.GRANTOR is not NULL) 
                  or (((ref_26.ID is NULL) 
                      and (ref_3.GRANTOR is not NULL)) 
                    and (((false) 
                        or (((select UID from temp_20200615 limit 1 offset 6)
                               is not NULL) 
                          or (((false) 
                              and ((ref_16.ID is NULL) 
                                or (37 is not NULL))) 
                            and (false)))) 
                      and (EXISTS (
                        select  
                            ref_19.GRANTOR as c0, 
                            ref_38.GRANTOR as c1, 
                            ref_9.GRANTOR as c2, 
                            ref_52.GRANTOR as c3, 
                            80 as c4, 
                            ref_2.GRANTOR as c5, 
                            ref_42.GRANTOR as c6, 
                            ref_52.GRANTOR as c7, 
                            ref_44.GRANTOR as c8
                          from 
                            temp_20200615 as ref_52
                          where (true) 
                            or (false))))))) 
              or (ref_21.UID is NULL))))) then ref_28.GRANTOR else ref_28.GRANTOR end
     as c0, 
  ref_11.UID as c1, 
  ref_9.GRANTOR as c2, 
  ref_8.GRANTOR as c3, 
  ref_11.GRANTOR as c4, 
  ref_5.GRANTOR as c5, 
  ref_17.GRANTOR as c6, 
  (select GRANTOR from temp_20200615 limit 1 offset 5)
     as c7, 
  ref_44.GRANTOR as c8, 
  case when ref_28.GRANTOR is not NULL then ref_26.ID else ref_26.ID end
     as c9, 
  ref_10.GRANTOR as c10, 
  ref_14.UID as c11, 
  ref_11.GRANTOR as c12, 
  (select GRANTOR from temp_20200615 limit 1 offset 3)
     as c13, 
  ref_44.GRANTOR as c14, 
  74 as c15
from 
  (((select  
            ref_0.GRANTOR as c0, 
            ref_0.GRANTOR as c1, 
            ref_0.GRANTOR as c2, 
            ref_0.GRANTOR as c3, 
            85 as c4, 
            ref_0.GRANTOR as c5
          from 
            temp_20200615 as ref_0
          where ((EXISTS (
                select  
                    ref_0.GRANTOR as c0, 
                    ref_0.GRANTOR as c1, 
                    ref_1.GRANTOR as c2
                  from 
                    temp_20200615 as ref_1
                  where (true) 
                    and (ref_0.UID is not NULL)
                  limit 88)) 
              and (ref_0.GRANTOR is not NULL)) 
            and ((ref_0.UID is NULL) 
              or (true))
          limit 138) as subq_0)
      right join ((((((temp_20200615 as ref_2)
                right join (temp_20200615 as ref_3)
                on (ref_2.GRANTOR = ref_3.UID ))
              left join (((temp_20200615 as ref_4)
                  inner join (temp_20200615 as ref_5)
                  on (ref_4.UID is not NULL))
                right join ((temp_20200615 as ref_6)
                  inner join (temp_20200615 as ref_7)
                  on (ref_7.GRANTOR is NULL))
                on (false))
              on ((82 is not NULL) 
                  and (((((true) 
                          or (ref_4.GRANTOR is NULL)) 
                        or (false)) 
                      or (ref_5.GRANTOR is not NULL)) 
                    and (ref_3.GRANTOR is NULL))))
            inner join (temp_20200615 as ref_8)
            on ((ref_6.UID is NULL) 
                and (ref_8.GRANTOR is not NULL)))
          inner join (temp_20200615 as ref_9)
          on ((ref_6.GRANTOR is not NULL) 
              and (true)))
        inner join (((((temp_20200615 as ref_10)
                inner join ((temp_20200615 as ref_11)
                  inner join (temp_20200615 as ref_12)
                  on (false))
                on (((false) 
                      or (false)) 
                    or (ref_10.GRANTOR is not NULL)))
              inner join ((temp_20200615 as ref_13)
                left join (temp_20200615 as ref_14)
                on (true))
              on (true))
            inner join ((SYS.SYS_VIEWS as ref_15)
              right join ((SYS.SYS_VIEWS as ref_16)
                left join (temp_20200615 as ref_17)
                on (ref_16.ID = ref_17.UID ))
              on (false))
            on (((ref_11.GRANTOR is NULL) 
                  or (((ref_15.ID is NULL) 
                      and ((EXISTS (
                          select  
                              ref_15.ID as c0, 
                              ref_17.GRANTOR as c1, 
                              ref_15.ID as c2, 
                              ref_13.UID as c3, 
                              ref_16.ID as c4, 
                              ref_18.GRANTOR as c5, 
                              ref_13.GRANTOR as c6, 
                              ref_17.GRANTOR as c7
                            from 
                              temp_20200615 as ref_18
                            where true)) 
                        or ((ref_16.USER# is NULL) 
                          and (true)))) 
                    and (true))) 
                or ((select GRANTOR from temp_20200615 limit 1 offset 5)
                     is not NULL)))
          inner join (((((temp_20200615 as ref_19)
                  right join (temp_20200615 as ref_20)
                  on (ref_19.UID = ref_20.UID ))
                inner join (temp_20200615 as ref_21)
                on (ref_19.GRANTOR is not NULL))
              left join (temp_20200615 as ref_22)
              on ((true) 
                  or ((false) 
                    and (false))))
            left join (temp_20200615 as ref_23)
            on ((select UID from temp_20200615 limit 1 offset 1)
                   is not NULL))
          on (ref_16.ID = ref_20.UID ))
        on (((ref_21.GRANTOR is not NULL) 
              or (ref_17.UID is not NULL)) 
            or (((true) 
                and (true)) 
              and ((EXISTS (
                  select  
                      (select GRANTOR from temp_20200615 limit 1 offset 2)
                         as c0, 
                      ref_23.UID as c1, 
                      ref_5.GRANTOR as c2, 
                      ref_13.GRANTOR as c3, 
                      ref_12.GRANTOR as c4, 
                      ref_12.GRANTOR as c5, 
                      ref_21.GRANTOR as c6, 
                      ref_16.ID as c7, 
                      ref_12.GRANTOR as c8
                    from 
                      temp_20200615 as ref_24
                    where true
                    limit 121)) 
                and (EXISTS (
                  select  
                      ref_22.UID as c0, 
                      ref_8.GRANTOR as c1, 
                      ref_2.UID as c2
                    from 
                      temp_20200615 as ref_25
                    where ref_13.GRANTOR is NULL
                    limit 74))))))
      on (subq_0.c2 = ref_15.USER# ))
    inner join ((((SYS.SYS_VIEWS as ref_26)
          right join ((SYS.SYS_USER_ROLES as ref_27)
            inner join (temp_20200615 as ref_28)
            on (((EXISTS (
                    select  
                        (select VIEW# from SYS.SYS_VIEW_COLS limit 1 offset 5)
                           as c0, 
                        ref_27.GRANTEE_TYPE as c1, 
                        ref_29.UID as c2, 
                        (select UID from temp_20200615 limit 1 offset 5)
                           as c3, 
                        ref_28.GRANTOR as c4, 
                        ref_29.GRANTOR as c5, 
                        ref_27.GRANTEE_TYPE as c6, 
                        ref_29.GRANTOR as c7, 
                        ref_27.GRANTEE_ID as c8
                      from 
                        temp_20200615 as ref_29
                      where EXISTS (
                        select  
                            ref_28.GRANTOR as c0, 
                            (select GRANTOR from temp_20200615 limit 1 offset 5)
                               as c1
                          from 
                            temp_20200615 as ref_30
                          where ref_28.GRANTOR is not NULL))) 
                  or (false)) 
                or ((EXISTS (
                    select  
                        ref_28.GRANTOR as c0
                      from 
                        temp_20200615 as ref_31
                      where ((((((false) 
                                  and (true)) 
                                or (true)) 
                              or (EXISTS (
                                select  
                                    ref_31.GRANTOR as c0, 
                                    ref_27.GRANTEE_TYPE as c1, 
                                    ref_28.GRANTOR as c2, 
                                    ref_28.GRANTOR as c3, 
                                    ref_28.GRANTOR as c4, 
                                    ref_27.GRANTEE_TYPE as c5
                                  from 
                                    temp_20200615 as ref_32
                                  where EXISTS (
                                    select  
                                        ref_27.GRANTEE_TYPE as c0
                                      from 
                                        temp_20200615 as ref_33
                                      where ((true) 
                                          and ((false) 
                                            and (false))) 
                                        or (ref_27.GRANTEE_TYPE is not NULL)
                                      limit 74)))) 
                            and (false)) 
                          or ((true) 
                            or ((false) 
                              and (EXISTS (
                                select  
                                    ref_31.UID as c0, 
                                    ref_28.GRANTOR as c1, 
                                    ref_28.GRANTOR as c2
                                  from 
                                    temp_20200615 as ref_34
                                  where (ref_31.GRANTOR is NULL) 
                                    or (false)))))) 
                        and (((EXISTS (
                              select  
                                  ref_28.GRANTOR as c0, 
                                  ref_27.GRANTEE_TYPE as c1, 
                                  ref_31.GRANTOR as c2
                                from 
                                  SYS.SYS_AUDIT as ref_35
                                where (EXISTS (
                                    select  
                                        ref_28.GRANTOR as c0, 
                                        ref_31.GRANTOR as c1
                                      from 
                                        temp_20200615 as ref_36
                                      where false
                                      limit 102)) 
                                  and ((false) 
                                    or (EXISTS (
                                      select  
                                          17 as c0
                                        from 
                                          temp_20200615 as ref_37
                                        where (true) 
                                          or (ref_37.GRANTOR is NULL)
                                        limit 125))))) 
                            and (false)) 
                          and (((false) 
                              or (true)) 
                            and (ref_28.GRANTOR is NULL))))) 
                  and (ref_28.UID is not NULL))))
          on (ref_26.USER# = ref_27.GRANTEE_ID ))
        inner join ((temp_20200615 as ref_38)
          left join (temp_20200615 as ref_39)
          on (false))
        on (true))
      inner join (((temp_20200615 as ref_40)
          inner join (temp_20200615 as ref_41)
          on (ref_40.GRANTOR = ref_41.UID ))
        right join (((temp_20200615 as ref_42)
            right join (SYS.SYS_AUDIT as ref_43)
            on ((select GRANTOR from temp_20200615 limit 1 offset 4)
                   is NULL))
          inner join (temp_20200615 as ref_44)
          on (ref_44.UID is NULL))
        on ((false) 
            and (false)))
      on (EXISTS (
          select  
              ref_42.GRANTOR as c0, 
              ref_45.GRANTOR as c1
            from 
              temp_20200615 as ref_45
            where ref_26.ID is not NULL)))
    on (ref_5.GRANTOR = ref_28.UID )
where true;
select  
  subq_0.c0 as c0, 
  ref_23.GRANTOR as c1, 
  ref_8.GRANTOR as c2, 
  subq_2.c2 as c3, 
  13 as c4
from 
  ((((SYS.SYS_USER_ROLES as ref_0)
          left join ((select  
                ref_1.GRANTOR as c0
              from 
                temp_20200615 as ref_1
              where (false) 
                or ((((((EXISTS (
                            select  
                                ref_1.GRANTOR as c0, 
                                ref_1.GRANTOR as c1, 
                                ref_1.GRANTOR as c2, 
                                ref_2.UID as c3, 
                                ref_2.GRANTOR as c4
                              from 
                                temp_20200615 as ref_2
                              where (true) 
                                or (true)
                              limit 86)) 
                          or ((ref_1.GRANTOR is NULL) 
                            or (ref_1.GRANTOR is NULL))) 
                        and (EXISTS (
                          select  
                              ref_3.GRANTOR as c0, 
                              ref_3.GRANTOR as c1, 
                              ref_3.GRANTOR as c2, 
                              ref_1.UID as c3, 
                              ref_1.GRANTOR as c4, 
                              ref_3.UID as c5, 
                              92 as c6, 
                              ref_1.GRANTOR as c7, 
                              ref_3.GRANTOR as c8, 
                              ref_1.GRANTOR as c9, 
                              ref_1.GRANTOR as c10
                            from 
                              temp_20200615 as ref_3
                            where ref_3.GRANTOR is not NULL
                            limit 94))) 
                      and (ref_1.GRANTOR is not NULL)) 
                    and ((EXISTS (
                        select  
                            ref_1.GRANTOR as c0, 
                            ref_4.GRANTOR as c1
                          from 
                            temp_20200615 as ref_4
                          where EXISTS (
                            select  
                                ref_1.UID as c0, 
                                ref_1.GRANTOR as c1, 
                                ref_5.UID as c2
                              from 
                                temp_20200615 as ref_5
                              where ((ref_4.GRANTOR is not NULL) 
                                  or (false)) 
                                or (EXISTS (
                                  select  
                                      ref_4.GRANTOR as c0, 
                                      ref_4.GRANTOR as c1
                                    from 
                                      temp_20200615 as ref_6
                                    where false
                                    limit 77))
                              limit 99)
                          limit 36)) 
                      and ((true) 
                        or (false)))) 
                  and (ref_1.GRANTOR is NULL))
              limit 80) as subq_0)
          on (ref_0.GRANTEE_ID = subq_0.c0 ))
        right join ((((temp_20200615 as ref_7)
              right join (temp_20200615 as ref_8)
              on (true))
            inner join (((temp_20200615 as ref_9)
                inner join ((temp_20200615 as ref_10)
                  inner join (temp_20200615 as ref_11)
                  on (false))
                on ((((ref_11.UID is NULL) 
                        and (((((true) 
                                and (EXISTS (
                                  select  
                                      ref_9.GRANTOR as c0
                                    from 
                                      temp_20200615 as ref_12
                                    where ref_9.GRANTOR is NULL))) 
                              and (false)) 
                            or (((true) 
                                or ((((false) 
                                      or (ref_11.GRANTOR is NULL)) 
                                    and (ref_9.GRANTOR is NULL)) 
                                  or (true))) 
                              and (true))) 
                          or (ref_11.UID is NULL))) 
                      and (ref_11.GRANTOR is not NULL)) 
                    and (false)))
              left join (temp_20200615 as ref_13)
              on (true))
            on (true))
          inner join (temp_20200615 as ref_14)
          on (false))
        on ((ref_10.GRANTOR is not NULL) 
            and (EXISTS (
              select  
                  subq_0.c0 as c0
                from 
                  temp_20200615 as ref_15
                where (((true) 
                      or (ref_15.GRANTOR is NULL)) 
                    and (ref_9.GRANTOR is NULL)) 
                  or (ref_10.GRANTOR is not NULL)
                limit 53))))
      inner join ((select  
            ref_16.GRANTOR as c0, 
            ref_16.GRANTOR as c1, 
            ref_16.UID as c2
          from 
            temp_20200615 as ref_16
          where true
          limit 145) as subq_1)
      on ((false) 
          or (false)))
    inner join (((select  
            ref_17.GRANTOR as c0, 
            ref_17.GRANTOR as c1, 
            ref_17.GRANTOR as c2, 
            ref_17.GRANTOR as c3, 
            ref_17.GRANTOR as c4
          from 
            temp_20200615 as ref_17
          where (((((select VIEW# from SYS.SYS_VIEW_COLS limit 1 offset 2)
                       is NULL) 
                  or (false)) 
                and (((EXISTS (
                      select  
                          ref_17.GRANTOR as c0, 
                          ref_18.GRANTOR as c1, 
                          (select UID from temp_20200615 limit 1 offset 5)
                             as c2, 
                          ref_17.UID as c3
                        from 
                          temp_20200615 as ref_18
                        where false)) 
                    and (EXISTS (
                      select  
                          ref_17.GRANTOR as c0, 
                          ref_19.GRANTOR as c1, 
                          ref_17.UID as c2, 
                          ref_17.GRANTOR as c3, 
                          ref_19.GRANTOR as c4, 
                          ref_17.GRANTOR as c5, 
                          (select GRANTOR from temp_20200615 limit 1 offset 63)
                             as c6, 
                          ref_19.UID as c7, 
                          ref_19.GRANTOR as c8, 
                          ref_17.GRANTOR as c9, 
                          ref_17.GRANTOR as c10, 
                          ref_19.GRANTOR as c11, 
                          ref_17.GRANTOR as c12, 
                          ref_19.GRANTOR as c13, 
                          ref_17.GRANTOR as c14, 
                          ref_17.GRANTOR as c15, 
                          ref_17.GRANTOR as c16, 
                          51 as c17, 
                          ref_17.UID as c18, 
                          (select GRANTOR from temp_20200615 limit 1 offset 3)
                             as c19, 
                          ref_17.GRANTOR as c20
                        from 
                          temp_20200615 as ref_19
                        where false))) 
                  or (false))) 
              and ((false) 
                and (((false) 
                    or (ref_17.GRANTOR is NULL)) 
                  or (EXISTS (
                    select  
                        (select GRANTOR from temp_20200615 limit 1 offset 6)
                           as c0, 
                        ref_17.GRANTOR as c1, 
                        ref_17.GRANTOR as c2, 
                        ref_20.GRANTOR as c3, 
                        ref_20.GRANTOR as c4, 
                        ref_20.GRANTOR as c5
                      from 
                        temp_20200615 as ref_20
                      where EXISTS (
                        select  
                            ref_20.GRANTOR as c0, 
                            (select GRANTOR from temp_20200615 limit 1 offset 57)
                               as c1, 
                            ref_17.UID as c2, 
                            (select UID from temp_20200615 limit 1 offset 3)
                               as c3, 
                            ref_20.GRANTOR as c4, 
                            ref_20.GRANTOR as c5, 
                            ref_21.GRANTOR as c6, 
                            (select UID from temp_20200615 limit 1 offset 7)
                               as c7, 
                            ref_17.GRANTOR as c8, 
                            ref_21.GRANTOR as c9, 
                            ref_17.GRANTOR as c10
                          from 
                            temp_20200615 as ref_21
                          where EXISTS (
                            select  
                                ref_21.UID as c0, 
                                30 as c1, 
                                ref_20.GRANTOR as c2, 
                                ref_21.UID as c3, 
                                ref_20.GRANTOR as c4
                              from 
                                temp_20200615 as ref_22
                              where (true) 
                                and ((false) 
                                  and ((((false) 
                                        or (ref_22.GRANTOR is not NULL)) 
                                      or ((true) 
                                        and (true))) 
                                    or (ref_22.GRANTOR is not NULL))))
                          limit 120)
                      limit 130))))) 
            and (ref_17.GRANTOR is not NULL)
          limit 175) as subq_2)
      inner join (((((temp_20200615 as ref_23)
              left join (temp_20200615 as ref_24)
              on (((ref_23.UID is NULL) 
                    or ((((false) 
                          or (ref_23.UID is not NULL)) 
                        or (false)) 
                      or ((false) 
                        or (ref_24.GRANTOR is not NULL)))) 
                  or (EXISTS (
                    select  
                        (select GRANTOR from temp_20200615 limit 1 offset 2)
                           as c0, 
                        ref_23.UID as c1, 
                        ref_23.GRANTOR as c2, 
                        ref_23.UID as c3, 
                        ref_24.GRANTOR as c4, 
                        ref_24.UID as c5, 
                        ref_25.GRANTOR as c6, 
                        ref_24.GRANTOR as c7, 
                        ref_23.UID as c8, 
                        98 as c9, 
                        ref_25.GRANTOR as c10, 
                        33 as c11
                      from 
                        temp_20200615 as ref_25
                      where ref_23.GRANTOR is not NULL
                      limit 80))))
            inner join ((temp_20200615 as ref_26)
              right join (temp_20200615 as ref_27)
              on ((((((84 is NULL) 
                          and (false)) 
                        and (false)) 
                      or (true)) 
                    and (ref_26.GRANTOR is not NULL)) 
                  and (EXISTS (
                    select  
                        ref_28.GRANTOR as c0, 
                        ref_28.GRANTOR as c1, 
                        ref_27.GRANTOR as c2, 
                        ref_27.GRANTOR as c3, 
                        ref_27.GRANTOR as c4, 
                        (select GRANTOR from temp_20200615 limit 1 offset 6)
                           as c5, 
                        ref_27.GRANTOR as c6
                      from 
                        temp_20200615 as ref_28
                      where ref_26.GRANTOR is NULL
                      limit 98))))
            on ((ref_24.GRANTOR is not NULL) 
                or (70 is not NULL)))
          left join (temp_20200615 as ref_29)
          on (true))
        inner join (((temp_20200615 as ref_30)
            right join (temp_20200615 as ref_31)
            on (ref_30.GRANTOR is NULL))
          inner join ((select  
                ref_32.GRANTOR as c0, 
                ref_32.UID as c1, 
                ref_32.UID as c2, 
                ref_32.GRANTOR as c3, 
                ref_32.GRANTOR as c4, 
                ref_32.GRANTOR as c5
              from 
                temp_20200615 as ref_32
              where ((ref_32.GRANTOR is not NULL) 
                  and (false)) 
                and ((true) 
                  and (((EXISTS (
                        select  
                            ref_32.GRANTOR as c0, 
                            ref_33.VIEW# as c1, 
                            ref_32.UID as c2, 
                            ref_33.VIEW# as c3, 
                            ref_32.GRANTOR as c4, 
                            ref_32.UID as c5, 
                            ref_33.VIEW# as c6, 
                            ref_32.GRANTOR as c7, 
                            ref_32.GRANTOR as c8, 
                            ref_32.GRANTOR as c9
                          from 
                            SYS.SYS_VIEW_COLS as ref_33
                          where EXISTS (
                            select  
                                ref_32.UID as c0
                              from 
                                temp_20200615 as ref_34
                              where (false) 
                                and (false)
                              limit 64)
                          limit 78)) 
                      or (false)) 
                    and (((false) 
                        and (ref_32.GRANTOR is not NULL)) 
                      and (EXISTS (
                        select  
                            ref_35.UID as c0
                          from 
                            temp_20200615 as ref_35
                          where (EXISTS (
                              select  
                                  ref_35.GRANTOR as c0
                                from 
                                  temp_20200615 as ref_36
                                where true)) 
                            and (false)
                          limit 90)))))
              limit 103) as subq_3)
          on ((false) 
              and ((ref_31.GRANTOR is not NULL) 
                and (EXISTS (
                  select  
                      ref_31.GRANTOR as c0, 
                      (select UID from temp_20200615 limit 1 offset 2)
                         as c1, 
                      ref_31.GRANTOR as c2, 
                      ref_31.GRANTOR as c3, 
                      (select GRANTOR from temp_20200615 limit 1 offset 6)
                         as c4, 
                      ref_30.UID as c5, 
                      ref_37.UID as c6, 
                      ref_30.GRANTOR as c7, 
                      subq_3.c5 as c8, 
                      ref_30.UID as c9, 
                      ref_31.UID as c10, 
                      ref_31.GRANTOR as c11, 
                      ref_31.GRANTOR as c12, 
                      ref_30.GRANTOR as c13, 
                      subq_3.c3 as c14, 
                      ref_30.GRANTOR as c15, 
                      ref_37.UID as c16, 
                      ref_37.GRANTOR as c17, 
                      ref_30.GRANTOR as c18, 
                      ref_30.GRANTOR as c19, 
                      ref_30.UID as c20
                    from 
                      temp_20200615 as ref_37
                    where ((true) 
                        and ((((EXISTS (
                                select  
                                    subq_3.c5 as c0
                                  from 
                                    temp_20200615 as ref_38
                                  where (ref_30.UID is not NULL) 
                                    or (EXISTS (
                                      select  
                                          ref_37.UID as c0
                                        from 
                                          temp_20200615 as ref_39
                                        where true))
                                  limit 112)) 
                              or (true)) 
                            or (false)) 
                          and ((true) 
                            or (true)))) 
                      or (EXISTS (
                        select  
                            ref_40.UID as c0
                          from 
                            temp_20200615 as ref_40
                          where (false) 
                            or (true))))))))
        on ((ref_29.GRANTOR is not NULL) 
            or (((ref_27.GRANTOR is not NULL) 
                or ((false) 
                  and (((false) 
                      and (EXISTS (
                        select  
                            ref_26.UID as c0, 
                            41 as c1
                          from 
                            temp_20200615 as ref_41
                          where (true) 
                            and (true)
                          limit 60))) 
                    or (false)))) 
              and ((((95 is NULL) 
                    and ((EXISTS (
                        select  
                            ref_24.UID as c0, 
                            ref_24.GRANTOR as c1, 
                            ref_26.UID as c2, 
                            ref_29.GRANTOR as c3, 
                            ref_27.GRANTOR as c4, 
                            ref_26.GRANTOR as c5, 
                            ref_42.UID as c6, 
                            ref_24.GRANTOR as c7, 
                            ref_29.GRANTOR as c8, 
                            90 as c9, 
                            ref_27.GRANTOR as c10, 
                            ref_23.GRANTOR as c11
                          from 
                            temp_20200615 as ref_42
                          where ref_24.GRANTOR is NULL)) 
                      and (true))) 
                  or ((false) 
                    and (ref_24.GRANTOR is not NULL))) 
                and (EXISTS (
                  select  
                      ref_31.GRANTOR as c0, 
                      ref_23.UID as c1, 
                      subq_3.c1 as c2, 
                      ref_24.UID as c3, 
                      ref_29.GRANTOR as c4, 
                      90 as c5, 
                      ref_26.UID as c6
                    from 
                      SYS.SYS_AUDIT as ref_43
                    where EXISTS (
                      select  
                          ref_29.GRANTOR as c0, 
                          ref_27.GRANTOR as c1, 
                          ref_24.UID as c2, 
                          ref_29.GRANTOR as c3, 
                          ref_44.GRANTOR as c4, 
                          ref_26.UID as c5
                        from 
                          temp_20200615 as ref_44
                        where ((EXISTS (
                              select  
                                  ref_26.GRANTOR as c0, 
                                  ref_31.GRANTOR as c1, 
                                  ref_31.GRANTOR as c2, 
                                  ref_26.UID as c3, 
                                  ref_45.GRANTOR as c4
                                from 
                                  temp_20200615 as ref_45
                                where false
                                limit 129)) 
                            and (false)) 
                          or (EXISTS (
                            select  
                                ref_44.GRANTOR as c0, 
                                ref_31.UID as c1, 
                                ref_29.GRANTOR as c2, 
                                ref_26.GRANTOR as c3, 
                                ref_43.STMTID as c4, 
                                (select GRANTOR from temp_20200615 limit 1 offset 2)
                                   as c5, 
                                subq_3.c0 as c6, 
                                ref_46.UID as c7, 
                                ref_31.GRANTOR as c8, 
                                64 as c9, 
                                ref_27.GRANTOR as c10, 
                                ref_46.GRANTOR as c11, 
                                ref_30.GRANTOR as c12, 
                                ref_23.GRANTOR as c13, 
                                ref_24.UID as c14, 
                                ref_29.GRANTOR as c15, 
                                ref_27.GRANTOR as c16, 
                                ref_23.UID as c17, 
                                ref_44.GRANTOR as c18, 
                                ref_27.GRANTOR as c19
                              from 
                                temp_20200615 as ref_46
                              where false
                              limit 148))
                        limit 124)
                    limit 128))))))
      on (subq_2.c3 = ref_26.UID ))
    on ((((EXISTS (
              select  
                  ref_11.UID as c0, 
                  ref_8.GRANTOR as c1
                from 
                  temp_20200615 as ref_47
                where 16 is not NULL
                limit 60)) 
            and (((ref_13.UID is NULL) 
                or (true)) 
              and ((((true) 
                    and (ref_14.GRANTOR is NULL)) 
                  and ((subq_2.c3 is NULL) 
                    or ((ref_23.GRANTOR is NULL) 
                      and (true)))) 
                and (((ref_9.GRANTOR is NULL) 
                    and (EXISTS (
                      select  
                          ref_30.GRANTOR as c0, 
                          ref_7.GRANTOR as c1, 
                          (select UID from temp_20200615 limit 1 offset 30)
                             as c2
                        from 
                          temp_20200615 as ref_48
                        where (select UID from temp_20200615 limit 1 offset 1)
                             is NULL))) 
                  and (true))))) 
          or (subq_2.c3 is not NULL)) 
        or (false))
where ref_27.GRANTOR is not NULL
limit 88;
--20200613
select  
  ref_2.GRANTOR as c3
from 
  (((select  
              ref_0.GRANTOR as c0, 
              ref_0.GRANTOR as c1, 
              ref_0.GRANTOR as c2, 
              ref_0.GRANTOR as c3
            from 
              temp_20200615 as ref_0) as subq_0)
        left join ((temp_20200615 as ref_1)
          right join temp_20200615 as ref_2
          on ((false)))
        on (subq_0.c3 = ref_1.UID ))
      inner join (temp_20200615 as ref_4)
      on (((((ref_1.GRANTOR is not NULL) 
                or (EXISTS (
                  select  
                      ref_4.GRANTOR as c0, 
                      subq_0.c0 as c1, 
                      20 as c2
                    from 
                      temp_20200615 as ref_5)))
              and ((EXISTS (
                  select  
                      subq_0.c2 as c0, 
                      33 as c1, 
                      ref_1.GRANTOR as c4
                    from 
                      temp_20200615 as ref_6
                    where subq_0.c1 is not NULL)) 
                and (false))) 
            or (true))) offset 1;
select  
  subq_2.c9 as c0, 
  subq_1.c0 as c1, 
  ref_10.GRANTOR as c2, 
  ref_0.GRANTOR as c3
from 
  ((((temp_20200615 as ref_0)
          inner join ((select  
                ref_1.GRANTOR as c0, 
                ref_1.GRANTOR as c1, 
                ref_1.GRANTOR as c2, 
                ref_1.GRANTOR as c3, 
                ref_1.GRANTOR as c4, 
                ref_1.GRANTOR as c5
              from 
                temp_20200615 as ref_1
              where (select GRANTOR from temp_20200615 limit 1 offset 5)
                   is not NULL
              limit 68) as subq_0)
          on ((((ref_0.GRANTOR is not NULL) 
                  and ((ref_0.GRANTOR is not NULL) 
                    and (EXISTS (
                      select  
                          ref_2.GRANTOR as c0, 
                          ref_2.GRANTOR as c1
                        from 
                          temp_20200615 as ref_2
                        where (true) 
                          and (EXISTS (
                            select  
                                ref_2.UID as c0, 
                                subq_0.c3 as c1, 
                                subq_0.c4 as c2, 
                                subq_0.c4 as c3, 
                                ref_0.GRANTOR as c4, 
                                ref_3.UID as c5, 
                                ref_3.GRANTOR as c6, 
                                ref_3.UID as c7, 
                                ref_2.GRANTOR as c8, 
                                ref_0.GRANTOR as c9, 
                                ref_3.GRANTOR as c10, 
                                ref_2.UID as c11, 
                                ref_2.GRANTOR as c12, 
                                ref_0.GRANTOR as c13, 
                                (select GRANTOR from temp_20200615 limit 1 offset 4)
                                   as c14, 
                                ref_0.GRANTOR as c15, 
                                ref_0.GRANTOR as c16
                              from 
                                temp_20200615 as ref_3
                              where (EXISTS (
                                  select  
                                      ref_0.GRANTOR as c0, 
                                      ref_2.GRANTOR as c1, 
                                      ref_3.GRANTOR as c2, 
                                      ref_3.UID as c3, 
                                      subq_0.c1 as c4
                                    from 
                                      temp_20200615 as ref_4
                                    where (((ref_3.GRANTOR is not NULL) 
                                          or (true)) 
                                        and ((subq_0.c0 is NULL) 
                                          and (((true) 
                                              and ((true) 
                                                and (true))) 
                                            and (true)))) 
                                      and ((false) 
                                        or ((((false) 
                                              and (EXISTS (
                                                select  
                                                    ref_4.GRANTOR as c0, 
                                                    ref_0.GRANTOR as c1, 
                                                    subq_0.c5 as c2, 
                                                    ref_5.GRANTOR as c3, 
                                                    ref_2.GRANTOR as c4, 
                                                    subq_0.c0 as c5, 
                                                    ref_3.GRANTOR as c6
                                                  from 
                                                    temp_20200615 as ref_5
                                                  where ref_5.UID is not NULL
                                                  limit 101))) 
                                            and (false)) 
                                          or (true))))) 
                                or (true))))))) 
                or (ref_0.GRANTOR is NULL)) 
              and (subq_0.c1 is NULL)))
        right join ((select  
              ref_6.GRANTOR as c0
            from 
              temp_20200615 as ref_6
            where ((false) 
                or (false)) 
              and (ref_6.GRANTOR is not NULL)) as subq_1)
        on (ref_0.GRANTOR = subq_1.c0 ))
      inner join ((select  
            ref_7.GRANTOR as c0, 
            ref_7.GRANTOR as c1, 
            (select UID from temp_20200615 limit 1 offset 3)
               as c2, 
            61 as c3, 
            ref_7.GRANTOR as c4, 
            ref_7.GRANTOR as c5, 
            ref_7.GRANTOR as c6, 
            ref_7.GRANTOR as c7, 
            ref_7.GRANTOR as c8, 
            ref_7.GRANTOR as c9, 
            ref_7.GRANTOR as c10, 
            ref_7.GRANTOR as c11
          from 
            temp_20200615 as ref_7
          where true) as subq_2)
      on (((EXISTS (
              select  
                  ref_0.GRANTOR as c0
                from 
                  temp_20200615 as ref_8
                where (subq_1.c0 is NULL) 
                  or ((EXISTS (
                      select  
                          subq_1.c0 as c0
                        from 
                          temp_20200615 as ref_9
                        where false)) 
                    and (true)))) 
            or (false)) 
          or (subq_0.c4 is NULL)))
    right join (temp_20200615 as ref_10)
    on (subq_2.c10 is not NULL)
where true
limit 93 offset 1;
select  
  ref_7.GRANTOR as c0, 
  case when EXISTS (
      select  
          ref_10.GRANTOR as c0, 
          ref_2.GRANTOR as c1, 
          ref_3.GRANTOR as c2, 
          ref_3.GRANTOR as c3
        from 
          ((temp_20200615 as ref_9)
              inner join (temp_20200615 as ref_10)
              on (ref_9.GRANTOR = ref_10.UID ))
            left join (temp_20200615 as ref_11)
            on (EXISTS (
                select  
                    ref_1.GRANTOR as c0, 
                    ref_4.UID as c1, 
                    ref_4.GRANTOR as c2, 
                    ref_7.GRANTOR as c3, 
                    ref_4.GRANTOR as c4, 
                    ref_4.GRANTOR as c5
                  from 
                    temp_20200615 as ref_12
                  where (EXISTS (
                      select  
                          ref_3.GRANTOR as c0
                        from 
                          temp_20200615 as ref_13
                        where ref_2.GRANTOR is not NULL
                        limit 142)) 
                    or (true)
                  limit 83))
        where (true) 
          and (((EXISTS (
                select  
                    subq_0.c0 as c0, 
                    ref_14.GRANTOR as c1, 
                    (select GRANTOR from temp_20200615 limit 1 offset 4)
                       as c2, 
                    ref_1.GRANTOR as c3, 
                    ref_1.GRANTOR as c4, 
                    ref_14.GRANTOR as c5, 
                    ref_14.GRANTOR as c6, 
                    ref_14.GRANTOR as c7, 
                    subq_0.c1 as c8, 
                    ref_11.GRANTOR as c9, 
                    ref_9.GRANTOR as c10, 
                    ref_9.GRANTOR as c11, 
                    ref_10.GRANTOR as c12, 
                    ref_2.GRANTOR as c13, 
                    27 as c14, 
                    ref_1.GRANTOR as c15, 
                    ref_11.GRANTOR as c16, 
                    ref_2.GRANTOR as c17, 
                    ref_1.GRANTOR as c18, 
                    subq_0.c0 as c19, 
                    ref_10.GRANTOR as c20, 
                    subq_0.c3 as c21, 
                    ref_10.GRANTOR as c22, 
                    ref_14.GRANTOR as c23
                  from 
                    temp_20200615 as ref_14
                  where (subq_0.c0 is NULL) 
                    or (true))) 
              and ((ref_3.GRANTOR is NULL) 
                and (ref_11.GRANTOR is NULL))) 
            or (((true) 
                and ((EXISTS (
                    select  
                        ref_3.GRANTOR as c0, 
                        ref_4.GRANTOR as c1, 
                        (select GRANTOR from temp_20200615 limit 1 offset 2)
                           as c2, 
                        (select GRANTOR from temp_20200615 limit 1 offset 3)
                           as c3, 
                        ref_1.GRANTOR as c4, 
                        ref_3.GRANTOR as c5, 
                        ref_2.GRANTOR as c6, 
                        (select GRANTOR from temp_20200615 limit 1 offset 1)
                           as c7, 
                        ref_1.UID as c8, 
                        ref_1.GRANTOR as c9, 
                        ref_10.GRANTOR as c10
                      from 
                        temp_20200615 as ref_15
                      where (EXISTS (
                          select  
                              ref_11.GRANTOR as c0, 
                              ref_10.GRANTOR as c1
                            from 
                              temp_20200615 as ref_16
                            where (((true) 
                                  or ((true) 
                                    and (false))) 
                                and (true)) 
                              or (false))) 
                        and (false)
                      limit 124)) 
                  or (ref_7.GRANTOR is NULL))) 
              and (false)))
        limit 138) then ref_2.GRANTOR else ref_2.GRANTOR end
     as c1, 
  ref_4.GRANTOR as c2, 
  ref_2.GRANTOR as c3, 
  ref_7.GRANTOR as c4, 
  (select GRANTOR from temp_20200615 limit 1 offset 56)
     as c5
from 
  ((((select  
              ref_0.GRANTOR as c0, 
              ref_0.GRANTOR as c1, 
              ref_0.GRANTOR as c2, 
              ref_0.GRANTOR as c3
            from 
              temp_20200615 as ref_0
            where ((((false) 
                    and (true)) 
                  or (ref_0.GRANTOR is NULL)) 
                or ((true) 
                  or (true))) 
              and (ref_0.GRANTOR is NULL)
            limit 28) as subq_0)
        left join ((temp_20200615 as ref_1)
          right join ((temp_20200615 as ref_2)
            left join (temp_20200615 as ref_3)
            on (ref_2.GRANTOR = ref_3.UID ))
          on ((true) 
              and (false)))
        on (subq_0.c3 = ref_1.UID ))
      inner join (temp_20200615 as ref_4)
      on (((((ref_1.GRANTOR is not NULL) 
                or (EXISTS (
                  select  
                      ref_4.GRANTOR as c0, 
                      subq_0.c0 as c1, 
                      20 as c2
                    from 
                      temp_20200615 as ref_5
                    where (true) 
                      or (ref_3.UID is not NULL)
                    limit 108))) 
              and ((EXISTS (
                  select  
                      subq_0.c2 as c0, 
                      33 as c1, 
                      subq_0.c2 as c2, 
                      subq_0.c0 as c3, 
                      ref_1.GRANTOR as c4, 
                      (select GRANTOR from temp_20200615 limit 1 offset 6)
                         as c5, 
                      10 as c6, 
                      47 as c7, 
                      ref_3.UID as c8, 
                      ref_2.GRANTOR as c9, 
                      ref_6.GRANTOR as c10, 
                      ref_6.GRANTOR as c11
                    from 
                      temp_20200615 as ref_6
                    where subq_0.c1 is not NULL
                    limit 107)) 
                and (false))) 
            or (true)) 
          or (false)))
    inner join (temp_20200615 as ref_7)
    on ((((false) 
            or ((ref_1.GRANTOR is not NULL) 
              and (ref_3.GRANTOR is NULL))) 
          or (EXISTS (
            select  
                ref_7.UID as c0
              from 
                temp_20200615 as ref_8
              where ref_3.GRANTOR is not NULL))) 
        or ((ref_3.GRANTOR is not NULL) 
          or (true)))
where ref_7.GRANTOR is not NULL
limit 121;
drop table temp_20200615;

-- not equal any rewrite
drop table if exists ne_any_2_exists_t1;
drop table if exists ne_any_2_exists_t2;

create table ne_any_2_exists_t1
(
    id number(8) not null,
    c_int number(8) not null,
    c_name varchar(50),
    grade number(8)
);

create table ne_any_2_exists_t2
(
    id number(6),
    c_int number(8)
);

select
  subq_0.c8 as c5
from
   (select
        ref_0.c_name as c1,
        ref_0.grade as c2,
        ref_0.c_int as c3,
        ref_0.id as c4,
        ref_0.c_int as c5,
        ref_0.id as c6,
        ref_0.c_int as c8,
        ref_0.id as c9
    from
        ne_any_2_exists_t1 as ref_0
    limit 90
    ) as subq_0
where exists (
    select
      subq_1.c1 as c2,
      subq_0.c9 as c3
    from
      (select distinct
            ref_3.id as c0,
            ref_3.c_int as c1
       from
            ne_any_2_exists_t2 as ref_3) as subq_1
    where subq_0.c1 > cast(case when (subq_0.c5 <> some(select ref_4.id as c1 from ne_any_2_exists_t1 as ref_4)) 
                           then 'aa' else 'bb' end
                           as varchar(50))
    );
drop table ne_any_2_exists_t1;
drop table ne_any_2_exists_t2;

-- DTS202104080EB86YP1I00
drop table if exists diff_type_index_t;
create table diff_type_index_t(c_int int, c_uint32 binary_uint32, c_bigint bigint, c_bool boolean, c_number number(12), c_decimal decimal(10,3), c_real real, c_float float, 
                               c_char char(10), c_varchar varchar(10), c_binary binary(10), c_varbinary varbinary(10), c_raw raw(10), c_clob clob, c_blob blob, c_image image,
                               c_date date, c_timestamp timestamp(6), c_timestamp_tz timestamp(6) with time zone, c_timestamp_ltz timestamp(6) with local time zone, 
                               c_interval_ds interval day(7) to second, c_interval_ym interval year(4) to month);
insert into diff_type_index_t values(1,1,100000,true,12,20.333,5.6,6.6,'1111','2222','100','101','102','103','104','105', '1999-09-27 00:00:00','2000-01-01 12:59:59.999999',
'2021-04-08 07:00:00.000000 +04:00', '2021-04-08 14:36:25.046731', '123 9:20:27', '2020-10');
insert into diff_type_index_t values(2,2,200000,false,22,40.666,7.8,8.8,'2222','3333','200','201','202','203','204','205', '2000-09-27 00:00:00','2001-01-01 12:59:59.999999',
'2022-04-08 07:00:00.000000 +04:00', '2022-04-08 14:36:25.046731', '234 9:20:27', '2020-11');

create index diff_type_int_idx on diff_type_index_t(c_int);
create index diff_type_uint_idx on diff_type_index_t(c_uint32);
create index diff_type_bigint_idx on diff_type_index_t(c_bigint);
create index diff_type_bool_idx on diff_type_index_t(c_bool);
create index diff_type_number_idx on diff_type_index_t(c_number);
create index diff_type_decimal_idx on diff_type_index_t(c_decimal);
create index diff_type_real_idx on diff_type_index_t(c_real);
create index diff_type_float_idx on diff_type_index_t(c_float);
create index diff_type_char_idx on diff_type_index_t(c_char);
create index diff_type_varchar_idx on diff_type_index_t(c_varchar);
create index diff_type_binary_idx on diff_type_index_t(c_binary);
create index diff_type_varbinary_idx on diff_type_index_t(c_varbinary);
create index diff_type_raw_idx on diff_type_index_t(c_raw);
create index diff_type_date_idx on diff_type_index_t(c_date);
create index diff_type_timestamp_idx on diff_type_index_t(c_timestamp);
create index diff_type_timestamp_tz_idx on diff_type_index_t(c_timestamp_tz);
create index diff_type_c_timestamp_ltz_idx on diff_type_index_t(c_timestamp_ltz);
create index diff_type_interval_ds_idx on diff_type_index_t(c_interval_ds);
create index diff_type_interval_ym_idx on diff_type_index_t(c_interval_ym);

select c_int from diff_type_index_t where c_int='1';
select c_int from diff_type_index_t where c_int=true;
select c_int from diff_type_index_t where c_int=cast('1.4' as binary(3));
select c_int from diff_type_index_t where c_int=cast('1.4' as varchar(3));
select c_int from diff_type_index_t where c_int=cast('1.4' as decimal(3,1));
select c_int from diff_type_index_t where c_int='1.4';
select c_int from diff_type_index_t where c_int=1.4;
select c_int from diff_type_index_t where c_int=1.0;
select c_int from diff_type_index_t where c_int=cast('1.0' as varchar(3));
select c_int from diff_type_index_t where c_int=2147483648;
select c_int from diff_type_index_t where c_int='p1';
select c_bigint from diff_type_index_t where c_bigint = 100000;
select c_bigint from diff_type_index_t where c_bigint = cast(100000.1 as number(7,1));
select c_uint32 from diff_type_index_t where c_uint32=2.1;
select c_uint32 from diff_type_index_t where c_uint32=-1;
select c_decimal from diff_type_index_t where c_decimal = 20.333;
select c_decimal from diff_type_index_t where c_decimal = 20.3333;
select c_decimal from diff_type_index_t where c_decimal = cast(20.333 as real);
select c_decimal from diff_type_index_t where c_decimal = cast(20.3333 as real);
select c_decimal from diff_type_index_t where c_decimal = '20.333';
select c_decimal from diff_type_index_t where c_decimal = '20.3333';
select c_number from diff_type_index_t where c_number = '12.00';
select c_real from diff_type_index_t where c_real = '5.6';
select c_real from diff_type_index_t where c_real = 5.6;
select c_real from diff_type_index_t where c_real = 5.5999999899999997;
select c_char from diff_type_index_t where c_char = cast('1111' as binary(10));
select c_char from diff_type_index_t where c_char = cast('1111' as varbinary(10));
select c_char from diff_type_index_t where c_char = cast('1111' as raw(10));
select c_char from diff_type_index_t where c_char = to_blob('1111');
select c_char from diff_type_index_t where c_char = to_clob('1111');
select c_char from diff_type_index_t where c_char = cast('1111' as char(11));
select c_char from diff_type_index_t where c_char = '1111       ';
select c_char from diff_type_index_t where c_char = '1111      1';
select c_varchar from diff_type_index_t where c_varchar = cast('2222' as binary(4));
select c_varchar from diff_type_index_t where c_varchar = cast('2222' as varbinary(4));
select c_varchar from diff_type_index_t where c_varchar = cast('2222' as raw(4));
select c_varchar from diff_type_index_t where c_varchar = '2222 ';
select c_varchar from diff_type_index_t where c_varchar = '2222      2';
select c_varchar from diff_type_index_t where c_varchar = 2222;
select c_varchar from diff_type_index_t where c_varchar = to_date('2000-01-01 12:59:59');
select c_binary from diff_type_index_t where c_binary = 100;
select c_binary from diff_type_index_t where c_binary = '100';
select c_binary from diff_type_index_t where c_binary = cast(cast('100' as varchar(10)) as binary(10));
select c_binary from diff_type_index_t where c_binary = cast('100' as raw(10));
select c_binary from diff_type_index_t where c_binary = cast('0100' as char(10));
select c_raw from diff_type_index_t where c_raw = '0202';
select c_raw from diff_type_index_t where c_raw = '0202 ';
select c_raw from diff_type_index_t where c_raw = '0202 1';
select c_raw from diff_type_index_t where c_raw = cast('0202' as varchar(5));
select c_date from diff_type_index_t where c_date = '1999-09-27 00:00:00';
select c_date from diff_type_index_t where c_date = '1999-09-27 00:00:00.999999';
select c_date from diff_type_index_t where c_date = to_timestamp('1999-09-27 00:00:00','YYYY-MM-DD HH24:MI:SS');
select c_date from diff_type_index_t where c_date = to_timestamp('1999-09-27 00:00:00.999999','YYYY-MM-DD HH24:MI:SSXFF6');
select c_int from diff_type_index_t where c_timestamp = '2000-01-01 12:59:59.999999';
select c_int from diff_type_index_t where c_timestamp = '2000-01-01 12:59:59';
select c_int from diff_type_index_t where c_timestamp = to_date('2000-01-01 12:59:59');
select c_int from diff_type_index_t where c_timestamp = from_tz(timestamp '2000-01-01 12:59:59.999999', '4:00');
select c_int from diff_type_index_t where c_timestamp = to_timestamp('2000-01-01 12:59:59.999999','YYYY-MM-DD HH24:MI:SSXFF6');
select c_int from diff_type_index_t where c_timestamp = to_timestamp('2000-01-01 12:59:59.999','YYYY-MM-DD HH24:MI:SSXFF3');
select c_int from diff_type_index_t where c_timestamp_tz = '2021-04-08 07:00:00.000000 +04:00';
select c_int from diff_type_index_t where c_timestamp_tz = '2021-04-08 07:00:00.000000';
select c_int from diff_type_index_t where c_timestamp_tz = to_timestamp('2019-01-04 16:33:47.123456','YYYY-MM-DD HH24:MI:SSXFF6');
select c_int from diff_type_index_t where c_timestamp_ltz = '2022-04-08 14:36:25.046731';
select c_int from diff_type_index_t where c_timestamp_ltz = to_timestamp('2019-01-04 16:33:47.123456','YYYY-MM-DD HH24:MI:SS.FF6');
select c_interval_ds from diff_type_index_t where c_interval_ds='234 9:20:27';
select c_interval_ds from diff_type_index_t where c_interval_ds='234 9:20:27 1';
select c_interval_ym from diff_type_index_t where c_interval_ym='2020-11';
select c_interval_ym from diff_type_index_t where c_interval_ym='2020-11 1';
drop table diff_type_index_t;