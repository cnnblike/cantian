--basic test
drop table if exists func_t1;
create table func_t1 (i clob unique);
create table func_t1 (i blob unique);
create table func_t1 (i image unique);
create table func_t1 (i varchar(2), id varchar(2));
insert into func_t1 values ('a', 'c'); 
insert into func_t1 values (NULL, NULL);
create index idx_func_1 on func_t1 (upper(i));
create index idx_func_2 on func_t1 (upper(i),upper(id)) online;
create index idx_func_3 on func_t1 (upper(i), upper(id));  -- error
create index idx_func_3 on func_t1 (upper(i), i);
insert into func_t1 values ('', '');
commit;
alter index idx_func_1 on func_t1 rebuild; 
alter index idx_func_2 on func_t1 rebuild online;
select * from func_t1 where upper(id) = 'C';
select * from func_t1 order by i;

--DML
insert into func_t1 values ('a', 'c'); 
update func_t1 set id = 'F' where upper(id) = 'C';
delete from func_t1 where upper(id) = 'F';
insert into func_t1 values ('a', 'c'); 
commit;
select * from func_t1 where upper(id) = 'C';
select * from func_t1 order by i;

--muti table delete/update
drop table if exists func_t2;
create table func_t2 (i varchar(2), id varchar(2));
create index idx_func2_1 on func_t2 (upper(i));
insert into func_t2 values ('a', 'c'); 
update func_t2, func_t1 set func_t1.i = 'F', func_t2.i = 'F';
select * from func_t1 where upper(id) = 'C';
select * from func_t1 order by id;
--column with func index test
delete from func_t1; commit;
alter table func_t1 modify i varchar(4);
alter table func_t1 modify i clob;
alter table func_t1 drop column i;
alter table func_t1 add column i varchar(3);
create index idx_t1_func on func_t1 (upper(i));
alter table func_t1 rename column i to i55; -- error
drop table if exists func_t2;
drop table if exists func_t1;
--constraint test(not supported)
drop table if exists t4;
create table t4 (id1 varchar(2), id2 varchar(2));
alter table t4 add constraint pk_1 primary key(id1) using index (create index idx_pk on t4(upper(id1)));
alter table t4 add constraint pk_1 primary key(upper(id1));
alter table t4 add constraint pk_1 unique(upper(id1));
insert into t4 values ('a', 'c'); 
insert into t4 values (NULL, NULL);
commit;
create unique index idx_t4_1 on t4(upper(id2), upper(id1));
alter table t4 add constraint pk_func_1 unique(id2);
insert into t4 values ('a', 'c'); 
drop table if exists t4;

--partition table and local index
drop table if exists pt1;
create table pt1(i varchar(100), id int) partition by range (id)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);
insert into pt1 values ('a', 1);
insert into pt1 values ('asss', 15);
insert into pt1 values ('', 25);
insert into pt1 values (NULL, 35);
create index idx_loc_1 on pt1 (upper(i)) local;
delete from pt1;
alter table pt1 modify i varchar(4);
 
 --temp table
 alter system set LOCAL_TEMPORARY_TABLE_ENABLED = TRUE;
 create temporary table #func_t1 (i varchar(2), id varchar(2));
 create index idx_t1 on #func_t1(upper(i)); -- error
 drop table #func_t1;
 alter system set LOCAL_TEMPORARY_TABLE_ENABLED = FALSE;
  
 drop table if exists temp_func_1;
 create global temporary table temp_func_1 (id1 varchar(2) not null, id2 varchar(2)) on commit preserve rows;
 insert into temp_func_1 values ('a', 'a');commit;
 insert into temp_func_1 values ('', 'a');
 insert into temp_func_1 values (NULL, 'a'); 
 create index idx_temp_1 on temp_func_1(upper(id2));
  insert into temp_func_1 values ('', 'a');
  update temp_func_1 set id1 = NULL where upper(id2) = 'A';
  update temp_func_1 set id1 = 'D' where upper(id2) = 'A';
    update temp_func_1 set id2 = NULL where upper(id2) = 'A';
  update temp_func_1 set id1 = 'D' where upper(id2) = NULL;
  delete from temp_func_1;
  drop table temp_func_1;
  
-- complicate func index and normal index test
drop table if exists t3;
create table t3 (id1 varchar(2), id2 varchar(2),  id3 varchar(20), id4 varchar(20), id5 varchar(40));
create index idx_t3_1 on t3 (upper(id5), id3, upper(id1));
create index idx_t3_2 on t3 (upper(id3), upper(id2) desc);
insert into t3 values ('a', 'a', 'a', 'a', 'a');
insert into t3 values ('', 'a', 'a', 'a', 'a');
drop table if exists t3;

DROP TABLE IF EXISTS T_INDEX_5;
CREATE TABLE T_INDEX_5
(
	F_INT51 INT,
	F_INT52 INT,
	F_CHAR51 CHAR(20)
);

INSERT INTO T_INDEX_5 VALUES(1,2,'abc');
INSERT INTO T_INDEX_5 VALUES(2,3,'dec');
INSERT INTO T_INDEX_5 VALUES(3,4,'hij');
INSERT INTO T_INDEX_5 VALUES(4,5,'qwe');
INSERT INTO T_INDEX_5 VALUES(null,6,'asd');

CREATE INDEX INDEX_INT_T_INDEX_5 ON T_INDEX_5(F_INT51) ONLINE;
CREATE INDEX INDEX_CHAR_INDEX_5 ON T_INDEX_5(upper(F_CHAR51)) ONLINE;
SELECT * FROM T_INDEX_5 WHERE upper(F_CHAR51) = 'ABC' or F_CHAR51 = 'qwe'; 
ALTER INDEX INDEX_INT_T_INDEX_5 ON T_INDEX_5 REBUILD;
ALTER INDEX INDEX_CHAR_INDEX_5 ON T_INDEX_5 REBUILD ONLINE;
DROP TABLE IF EXISTS T_INDEX_5;

DROP TABLE IF EXISTS T_FUNC_INDEX_1;
CREATE TABLE T_FUNC_INDEX_1
(
	F_INT1 INT,
	F_INT2 INT,
	F_CHAR1 CHAR(20)
);

CREATE INDEX FUNC_INDEX_INT_T_INDEX_1 ON T_FUNC_INDEX_1(TO_CHAR(F_INT1));
CREATE INDEX FUNC_INDEX_CHAR_INDEX_1 ON T_FUNC_INDEX_1(UPPER(F_CHAR1));

INSERT INTO T_FUNC_INDEX_1 VALUES(1,2,'0001Z01000ACCOUNT028');
INSERT INTO T_FUNC_INDEX_1 VALUES(2,3,'0001Z01000ACCOUNT073');
INSERT INTO T_FUNC_INDEX_1 VALUES(3,4,'10111110000000001ZX5');
INSERT INTO T_FUNC_INDEX_1 VALUES(4,5,'101511100000000006NZ');
INSERT INTO T_FUNC_INDEX_1 VALUES(null,6,'101511100000000006NX');
COMMIT;

SELECT * FROM T_FUNC_INDEX_1 WHERE F_CHAR1 = '0001Z01000ACCOUNT028' or F_CHAR1 = '0001Z01000ACCOUNT073';
SELECT * FROM T_FUNC_INDEX_1 WHERE F_CHAR1 = '10111110000000001ZX5' or F_CHAR1 = '101511100000000006NZ';

SELECT * FROM T_FUNC_INDEX_1 WHERE F_INT1 = 3 AND EXISTS (SELECT 1 FROM DUAL);
SELECT * FROM T_FUNC_INDEX_1 WHERE F_INT1 = 1 AND NOT EXISTS (SELECT 1 FROM DUAL);
SELECT * FROM T_FUNC_INDEX_1 WHERE F_INT1 = 1 AND NOT EXISTS (SELECT 1 FROM DUAL WHERE 1 = 0);

SELECT * FROM T_FUNC_INDEX_1 WHERE F_INT1 IS NULL AND F_INT1 IS NULL;
SELECT * FROM T_FUNC_INDEX_1 WHERE TO_CHAR(F_INT1) = '1';
SELECT * FROM T_FUNC_INDEX_1 WHERE TO_CHAR(F_INT1) IN ('1','2','3');
SELECT * FROM T_FUNC_INDEX_1 WHERE F_INT1 < 2;
SELECT * FROM T_FUNC_INDEX_1 WHERE UPPER(F_CHAR1) = '0001Z01000ACCOUNT028';
--DTS2020021208980
EXPLAIN SELECT * FROM T_FUNC_INDEX_1 WHERE F_CHAR1 = '0001Z01000ACCOUNT028';
EXPLAIN SELECT * FROM T_FUNC_INDEX_1 WHERE F_CHAR1 IN('0001Z01000ACCOUNT028','10111110000000001ZX5');
--cannot use index
EXPLAIN SELECT * FROM T_FUNC_INDEX_1 WHERE F_CHAR1 > '0001Z01000ACCOUNT028';
EXPLAIN SELECT * FROM T_FUNC_INDEX_1 WHERE F_CHAR1 IS NULL;
EXPLAIN SELECT * FROM T_FUNC_INDEX_1 WHERE UPPER(F_CHAR1) = '0001Z01000ACCOUNT028';
EXPLAIN SELECT * FROM T_FUNC_INDEX_1 WHERE UPPER(F_CHAR1) > '0001Z01000ACCOUNT028';
EXPLAIN SELECT * FROM T_FUNC_INDEX_1 WHERE UPPER(F_CHAR1) IN ('0001Z01000ACCOUNT028');
EXPLAIN SELECT * FROM T_FUNC_INDEX_1 WHERE UPPER(F_CHAR1) IS NULL;

CREATE USER NEBULA2 IDENTIFIED BY Cantian_234;
DROP TABLE IF EXISTS NEBULA2.STORAGE_LIST_TBL_001;
CREATE TABLE NEBULA2.STORAGE_LIST_TBL_001(C_ID INT,C_D_ID INT NOT NULL,C_W_ID INT NOT NULL,C_FIRST VARCHAR(64) NOT NULL,C_MIDDLE CHAR(2),C_LAST VARCHAR(64) NOT NULL,C_STREET_1 VARCHAR(20) NOT NULL,C_STREET_2 VARCHAR(20),C_CITY VARCHAR(64) NOT NULL,C_STATE CHAR(2) NOT NULL,C_ZIP CHAR(9) NOT NULL,C_PHONE CHAR(16) NOT NULL,C_SINCE TIMESTAMP,C_CREDIT CHAR(2) NOT NULL,C_CREDIT_LIM NUMERIC(12,2),C_DISCOUNT NUMERIC(4,4),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL NOT NULL,C_PAYMENT_CNT NUMBER NOT NULL,C_DELIVERY_CNT BOOLEAN NOT NULL,C_END DATE NOT NULL,C_VCHAR VARCHAR(1000),C_DATA varchar(2000),C_TEXT varchar(2000)) PARTITION BY LIST(C_D_ID,C_FIRST,C_LAST,C_CITY) (PARTITION PART_1 VALUES ((1,'A','A','A'),(10,'AA','AA','AA'),(10,'AAAA','AAAA','AAAA'),(10,'aaaa','aaaa','aaaa'),(100,'AAAA','AAAA','AAAA'),(1,'a','a','a'),(10,'aa','aa','aa'),(100,'aaaa','aaaa','aaaa')),PARTITION PART_2 VALUES ((2,'B','B','B'),(20,'BB','BB','BB'),(20,'BBBB','BBBB','BBBB'),(20,'bbbb','bbbb','bbbb'),(200,'BBBB','BBBB','BBBB'),(2,'b','b','b'),(20,'bb','bb','bb'),(200,'bbbb','bbbb','bbbb')),PARTITION PART_3 VALUES ((3,'C','C','C'),(30,'CC','CC','CC'),(30,'CCCC','CCCC','CCCC'),(30,'cccc','cccc','cccc'),(300,'CCCC','CCCC','CCCC'),(3,'c','c','c'),(30,'cc','cc','cc'),(300,'cccc','cccc','cccc')),PARTITION PART_4 VALUES ((4,'D','D','D'),(40,'DD','DD','DD'),(40,'DDDD','DDDD','DDDD'),(40,'dddd','dddd','dddd'),(400,'DDDD','DDDD','DDDD'),(4,'d','d','d'),(40,'dd','dd','dd'),(400,'dddd','dddd','dddd')),PARTITION PART_5 VALUES ((5,'E','E','E'),(50,'EE','EE','EE'),(50,'EEEE','EEEE','EEEE'),(50,'eeee','eeee','eeee'),(500,'EEEE','EEEE','EEEE'),(5,'e','e','e'),(50,'ee','ee','ee'),(500,'eeee','eeee','eeee')),PARTITION PART_6 VALUES ((6,'F','F','F'),(60,'FF','FF','FF'),(60,'FFFF','FFFF','FFFF'),(60,'ffff','ffff','ffff'),(600,'FFFF','FFFF','FFFF'),(6,'f','f','f'),(60,'ff','ff','ff'),(600,'ffff','ffff','ffff')),PARTITION PART_7 VALUES ((7,'G','G','G'),(70,'GG','GG','GG'),(70,'GGGG','GGGG','GGGG'),(70,'gggg','gggg','gggg'),(700,'GGGG','GGGG','GGGG'),(7,'g','g','g'),(70,'gg','gg','gg'),(700,'gggg','gggg','gggg')),PARTITION PART_8 VALUES ((8,'H','H','H'),(80,'HH','HH','HH'),(80,'HHHH','HHHH','HHHH'),(80,'hhhh','hhhh','hhhh'),(800,'HHHH','HHHH','HHHH'),(8,'h','h','h'),(80,'hh','hh','hh'),(800,'hhhh','hhhh','hhhh')),PARTITION PART_9 VALUES ((9,'I','I','I'),(90,'II','II','II'),(90,'IIII','IIII','IIII'),(90,'iiii','iiii','iiii'),(900,'IIII','IIII','IIII'),(9,'i','i','i'),(90,'ii','ii','ii'),(900,'iiii','iiii','iiii')),PARTITION PART_10 VALUES (DEFAULT));
CREATE UNIQUE INDEX  NEBULA2.STORAGE_LIST_INDEX_001_1 ON NEBULA2.STORAGE_LIST_TBL_001(C_D_ID,C_FIRST,C_LAST,C_CITY,TO_CHAR(C_ID))  LOCAL ;
CREATE UNIQUE INDEX NEBULA2.STORAGE_LIST_INDEX_001_2 ON NEBULA2.STORAGE_LIST_TBL_001(TO_CHAR(C_ID),C_CITY,C_LAST,C_STREET_2)  ;
CREATE UNIQUE INDEX NEBULA2.STORAGE_LIST_INDEX_001_3 ON NEBULA2.STORAGE_LIST_TBL_001(C_STREET_2,TO_CHAR(C_ID))  ;
CREATE INDEX NEBULA2.STORAGE_LIST_INDEX_001_4 ON NEBULA2.STORAGE_LIST_TBL_001(TO_CHAR(C_ID),C_CITY,C_FIRST)  LOCAL ;
CREATE INDEX NEBULA2.STORAGE_LIST_INDEX_001_5 ON NEBULA2.STORAGE_LIST_TBL_001(TO_CHAR(C_STREET_1),C_W_ID)   ;
INSERT INTO NEBULA2.STORAGE_LIST_TBL_001 VALUES(1,90,1,'II'||'9'||'Cabdg','OE','II'||'9'||'Bdbed','bki'||'9'||'fdger','pwo'||'9'||'vedef','II'||'9'||'Yed3f','uq',4801||'9',940||'9',to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'||'9','QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'||'9','1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542329');
SELECT TO_CHAR(C_ID),C_D_ID,C_FIRST,C_LAST,C_CITY  FROM NEBULA2.STORAGE_LIST_TBL_001 where TO_CHAR(C_ID)<1500 and C_D_ID<1500 and (C_FIRST like 'I%' ) and  (C_LAST like 'I%' )and  (C_CITY like 'I%' );
SELECT TO_CHAR(C_ID),C_D_ID,C_FIRST,C_LAST,C_CITY  FROM NEBULA2.STORAGE_LIST_TBL_001 where TO_CHAR(C_ID)<1500 and C_D_ID<1500 ;
SELECT TO_CHAR(C_ID),C_D_ID,C_FIRST,C_LAST,C_CITY  FROM NEBULA2.STORAGE_LIST_TBL_001 where  (C_FIRST like 'I%' ) and  (C_LAST like 'I%' )and  (C_CITY like 'I%' );
SELECT TO_CHAR(C_ID),C_D_ID,C_FIRST,C_LAST,C_CITY  FROM NEBULA2.STORAGE_LIST_TBL_001 ;
DROP TABLE IF EXISTS NEBULA2.STORAGE_LIST_TBL_001;
DROP TABLE IF EXISTS NEBULA2.STRG_PARTRANGE_TBL_001;
CREATE TABLE NEBULA2.STRG_PARTRANGE_TBL_001(c_id int,c_d_id int not null,c_w_id int not null,c_first varchar(32) not null,c_middle char(2),c_last varchar(32) not null,c_street_1 varchar(20) not null,c_street_2 varchar(20),c_city varchar(20) not null,c_state char(2) not null,c_zip char(9) not null,c_phone char(16) not null,c_since timestamp,c_credit char(2) not null,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real not null,c_payment_cnt number not null,c_delivery_cnt bool not null,c_end date not null,c_vchar varchar(1000),c_data varchar(2000),c_text varchar(2000)) partition by range(c_id) (partition part_1 values less than (201),partition part_2 values less than (401),partition part_3 values less than (601),partition part_4 values less than (801),partition part_5 values less than (1001),partition part_6 values less than (1201),partition part_7 values less than (1401),partition part_8 values less than (1601),partition part_9 values less than (1801),partition part_10 values less than (2001),partition part_11 values less than (maxvalue));
CREATE UNIQUE INDEX NEBULA2.STRG_RANGE_INDEX_001_1 ON NEBULA2.STRG_PARTRANGE_TBL_001(TO_CHAR(C_ID)) LOCAL;
CREATE UNIQUE INDEX NEBULA2.STRG_RANGE_INDEX_001_2 ON NEBULA2.STRG_PARTRANGE_TBL_001(TO_CHAR(C_W_ID));
CREATE INDEX NEBULA2.STRG_RANGE_INDEX_001_3 ON NEBULA2.STRG_PARTRANGE_TBL_001(UPPER(C_FIRST)) LOCAL;
INSERT INTO  NEBULA2.STRG_PARTRANGE_TBL_001 SELECT 1,1,1,'AA'||'is1cmvls','OE','AA'||'BAR1BARBAR','bkili'||'1'||'fcxcle'||'1','pmbwo'||'1'||'vhvpaj'||'1','dyf'||'1'||'rya'||'1','uq',4801||'1',940||'1'||215||'1',to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSF'||'1','QVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSF'||'1','\x1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323';
SELECT COUNT(*) FROM  NEBULA2.STRG_PARTRANGE_TBL_001;
SELECT COUNT(*) FROM NEBULA2.STRG_PARTRANGE_TBL_001 WHERE UPPER(C_FIRST) LIKE 'AA%';
SELECT c_first FROM NEBULA2.STRG_PARTRANGE_TBL_001 WHERE UPPER(C_FIRST) < 'BB';
SELECT * FROM NEBULA2.STRG_PARTRANGE_TBL_001 WHERE C_ID like 1234;
SELECT * FROM NEBULA2.STRG_PARTRANGE_TBL_001 WHERE C_ID like '1234';
SELECT * FROM NEBULA2.STRG_PARTRANGE_TBL_001 WHERE UPPER(C_FIRST) like 1234;
SELECT * FROM NEBULA2.STRG_PARTRANGE_TBL_001 WHERE UPPER(C_FIRST) like '1234' OR C_ID like '1234';
DROP TABLE IF EXISTS NEBULA2.STRG_PARTRANGE_TBL_001;
DROP USER NEBULA2 CASCADE;
DROP TABLE IF EXISTS T_FUNC_INDEX_2;
CREATE TABLE T_FUNC_INDEX_2(F1 REAL, F2 DATE, F3 TIMESTAMP, F4 NUMBER(6), F5 DECIMAL(20,5), F6 RAW(6), F7 VARBINARY(6));
CREATE INDEX IDX_T_FUNC_INDEX_2_1 ON T_FUNC_INDEX_2(TO_CHAR(F1, 'FM999.99999'));
CREATE INDEX IDX_T_FUNC_INDEX_2_2 ON T_FUNC_INDEX_2(TO_CHAR(F2, 'YYYY-MM-DD'));
CREATE INDEX IDX_T_FUNC_INDEX_2_3 ON T_FUNC_INDEX_2(TO_CHAR(F3, 'YYYY-MM-DD HH24:MI:SS'));
CREATE INDEX IDX_T_FUNC_INDEX_2_4 ON T_FUNC_INDEX_2(TO_CHAR(F4));
CREATE INDEX IDX_T_FUNC_INDEX_2_5 ON T_FUNC_INDEX_2(TO_CHAR(F5, 'FM999999999.99990'));
CREATE INDEX IDX_T_FUNC_INDEX_2_6 ON T_FUNC_INDEX_2(TO_CHAR(F6));
CREATE INDEX IDX_T_FUNC_INDEX_2_7 ON T_FUNC_INDEX_2(TO_CHAR(F7));

INSERT INTO T_FUNC_INDEX_2 VALUES(12.5, '2018-02-13', '2018-02-13 09:30:00', 1, 123456, '1111', '11111');
SELECT * FROM T_FUNC_INDEX_2 WHERE F1=12.5;
SELECT * FROM T_FUNC_INDEX_2 WHERE F2='2018-02-13';
SELECT * FROM T_FUNC_INDEX_2 WHERE F3='2018-02-13 09:30:00';
SELECT * FROM T_FUNC_INDEX_2 WHERE F4=1;
SELECT * FROM T_FUNC_INDEX_2 WHERE F5=123456;
SELECT * FROM T_FUNC_INDEX_2 WHERE F6='1111';
SELECT * FROM T_FUNC_INDEX_2 WHERE F7='11111';
SELECT * FROM T_FUNC_INDEX_2 WHERE to_char(F1,'FM999.99999')='12.5';
SELECT * FROM T_FUNC_INDEX_2 WHERE to_char(F2,'YYYY-MM-DD')='2018-02-13';
SELECT * FROM T_FUNC_INDEX_2 WHERE to_char(F3,'YYYY-MM-DD HH24:MI:SS')='2018-02-13 09:30:00';
SELECT * FROM T_FUNC_INDEX_2 WHERE to_char(F4)='1';
SELECT * FROM T_FUNC_INDEX_2 WHERE to_char(F5,'FM999999999.99990')='123456.00000';
SELECT * FROM T_FUNC_INDEX_2 WHERE to_char(F6)='1111';
SELECT * FROM T_FUNC_INDEX_2 WHERE to_char(F7)='11111';

DROP TABLE IF EXISTS T_FUNC_INDEX_3;
DROP TABLE IF EXISTS T_FUNC_INDEX_4;
CREATE TABLE T_FUNC_INDEX_3(CAR_ID NUMBER(6),CAR_CUST NUMBER(3),ADDR_3 NUMBER(5),CAR_CODE VARCHAR2(32),CAR_STATUS CHAR(1),CAR_REGION NUMBER(6),CAR_DOUBLE NUMBER(6,4),PRIMARY KEY(CAR_ID)); 
CREATE TABLE T_FUNC_INDEX_4(PHONE_ID NUMBER(6),CUST NUMBER(3),ADDR_2 NUMBER(5),PHONE_CODE VARCHAR2(32),PHONE_STATUS CHAR(1),PHONE_REGION NUMBER(10),PHONE_DOUBLE NUMBER(20,4),PRIMARY KEY (PHONE_ID));
INSERT INTO T_FUNC_INDEX_3(CAR_ID,CAR_CODE) VALUES(1000,'XYZ');
INSERT INTO T_FUNC_INDEX_4(PHONE_ID, PHONE_CODE) VALUES(1000,'ASD');

SELECT CAR_CODE FROM T_FUNC_INDEX_3 WHERE CAR_ID IN(SELECT PHONE_ID FROM T_FUNC_INDEX_4 WHERE PHONE_CODE = 'ASD');
SELECT * FROM T_FUNC_INDEX_3,T_FUNC_INDEX_4;

DROP TABLE IF EXISTS FBI_PURCHASES;
CREATE TABLE FBI_PURCHASES (
	CUSTOMER_ID INTEGER  NOT NULL,
	PRODUCT_ID INTEGER  NOT NULL,
	QUANTITY INTEGER ,
	TEST VARCHAR2(10) ,
	PHONE VARCHAR2(12) NOT NULL,
	CONSTRAINT PURCHASES_PK PRIMARY KEY(PRODUCT_ID, CUSTOMER_ID)
);

DROP TABLE IF EXISTS FBI_CUSTOMERS;
CREATE TABLE FBI_CUSTOMERS (
	CUSTOMER_ID INTEGER ,
	FIRST_NAME VARCHAR2(10) NOT NULL,
	LAST_NAME VARCHAR2(10) NOT NULL,
	BIRTH DATE NOT NULL,
	PHONE VARCHAR2(12),
	TEST VARCHAR2(10),
	CONSTRAINT CUSTOMERS_PK PRIMARY KEY (CUSTOMER_ID)
);

INSERT INTO FBI_CUSTOMERS (CUSTOMER_ID,FIRST_NAME,LAST_NAME,BIRTH,PHONE,TEST) VALUES(1,'JOHN','BROWN','1890-01-01 00:00:00','800-555-1211','123');
INSERT INTO FBI_PURCHASES (CUSTOMER_ID,PRODUCT_ID,QUANTITY,TEST,PHONE) VALUES (1,1,1,'TEST1','13776144901');
SELECT PRODUCT_ID,QUANTITY,TEST,PHONE FROM FBI_PURCHASES P WHERE P.CUSTOMER_ID IN (SELECT CUSTOMER_ID FROM FBI_CUSTOMERS WHERE FIRST_NAME LIKE 'JOHN' AND BIRTH < '2014-10-10');

DROP TABLE IF EXISTS FBI_TEST_MULTI_KEY;
CREATE TABLE FBI_TEST_MULTI_KEY(F1 INT, F2 INT);
CREATE INDEX IDX_TEST_MULTI_KEY_1 ON FBI_TEST_MULTI_KEY(TO_CHAR(F1));
INSERT INTO FBI_TEST_MULTI_KEY VALUES(1,1);
INSERT INTO FBI_TEST_MULTI_KEY VALUES(2,2);
INSERT INTO FBI_TEST_MULTI_KEY VALUES(3,3);
INSERT INTO FBI_TEST_MULTI_KEY VALUES(4,4);
INSERT INTO FBI_TEST_MULTI_KEY VALUES(5,5);
INSERT INTO FBI_TEST_MULTI_KEY VALUES(6,6);
INSERT INTO FBI_TEST_MULTI_KEY VALUES(7,7);
INSERT INTO FBI_TEST_MULTI_KEY VALUES(8,8);
SELECT * FROM FBI_TEST_MULTI_KEY WHERE (F1 >=1 AND F1 <4) OR (F1 >=5 AND F1 <8) ORDER BY F1;
SELECT * FROM FBI_TEST_MULTI_KEY WHERE (F1 >=1 AND F1 <4) OR (F1 >=5 AND F1 <8) ORDER BY F1 DESC;  
DROP TABLE IF EXISTS FBI_TEST_MULTI_KEY;

DROP TABLE IF EXISTS T_FUNC_INDEX_2;
DROP TABLE IF EXISTS T_FUNC_INDEX_3;
DROP TABLE IF EXISTS T_FUNC_INDEX_4;
DROP TABLE IF EXISTS FBI_PURCHASES;
DROP TABLE IF EXISTS FBI_CUSTOMERS;

DROP TABLE IF EXISTS T_FUNC_INDEX_5;
CREATE TABLE T_FUNC_INDEX_5
(
	F_INT51 INT,
	F_INT52 INT,
	F_CHAR51 CHAR(20)
);

INSERT INTO T_FUNC_INDEX_5 VALUES(1,2,'abc');
INSERT INTO T_FUNC_INDEX_5 VALUES(2,3,'dec');
INSERT INTO T_FUNC_INDEX_5 VALUES(3,4,'hij');
INSERT INTO T_FUNC_INDEX_5 VALUES(4,5,'qwe');
INSERT INTO T_FUNC_INDEX_5 VALUES(null,6,'asd');

CREATE INDEX FUNC_INDEX_INT_T_INDEX_5 ON T_FUNC_INDEX_5(TO_CHAR(F_INT51)) ONLINE;
CREATE INDEX FUNC_INDEX_CHAR_INDEX_5 ON T_FUNC_INDEX_5(UPPER(F_CHAR51) )ONLINE;
SELECT * FROM T_FUNC_INDEX_5 WHERE F_CHAR51 = 'abc' or TO_CHAR(F_CHAR51)= 'QWE';

ALTER INDEX FUNC_INDEX_INT_T_INDEX_5 ON T_FUNC_INDEX_5 REBUILD;
ALTER INDEX FUNC_INDEX_CHAR_INDEX_5 ON T_FUNC_INDEX_5 REBUILD ONLINE;
DROP TABLE IF EXISTS T_FUNC_INDEX_5;

DROP TABLE IF EXISTS T_FUNC_INDEX_55;
CREATE TABLE T_FUNC_INDEX_55(A INT, B BOOLEAN);
CREATE INDEX FUNC_IDX_T_INDEX_55_1 ON T_FUNC_INDEX_55(TO_CHAR(B));
INSERT INTO T_FUNC_INDEX_55 VALUES(1,0);
INSERT INTO T_FUNC_INDEX_55 VALUES(2,1);
SELECT * FROM T_FUNC_INDEX_55 WHERE TO_CHAR(B)='FALSE';
SELECT * FROM T_FUNC_INDEX_55 WHERE B = 0;
SELECT * FROM T_FUNC_INDEX_55 WHERE B IS NULL OR B IS NULL;
DROP TABLE IF EXISTS T_FUNC_INDEX_55;

DROP TABLE IF EXISTS T_FUNC_INDEX_56;
create table T_FUNC_INDEX_56(a int, b int);
create index FUNC_idx_T_INDEX_56_1 on T_FUNC_INDEX_56(TO_CHAR(A));
SELECT * FROM T_FUNC_INDEX_56 WHERE (A>20 AND A <30) OR (A >40 AND A <50) OR (A >60 AND A <70) OR (A >25 AND A <35);
DROP TABLE IF EXISTS T_FUNC_INDEX_56;

DROP TABLE IF EXISTS IF_NOT_EXIST;
CREATE TABLE IF_NOT_EXIST(c1 INTEGER, c2 VARCHAR(1000), c3 INTEGER);
CREATE INDEX ix_if_not_exist ON IF_NOT_EXIST(c1, c2);
CREATE INDEX ix_if_not_exist ON IF_NOT_EXIST(c1, c2);
CREATE INDEX IF NOT EXISTS ix_if_not_exist ON IF_NOT_EXIST(c1, c2);
DROP INDEX ix_if_not_exist ON IF_NOT_EXIST;
DROP TABLE IF_NOT_EXIST;
--pctfree
DROP TABLE IF EXISTS PCT_TB0;
CREATE TABLE PCT_TB0 (f1 int, f2 int, f3 int);
INSERT INTO PCT_TB0 VALUES (1,2,3);INSERT INTO PCT_TB0 VALUES (2,2,19);
INSERT INTO PCT_TB0 VALUES (3,2,29);INSERT INTO PCT_TB0 VALUES (4,2,39);
INSERT INTO PCT_TB0 SELECT * FROM PCT_TB0;INSERT INTO PCT_TB0 SELECT * FROM PCT_TB0;
INSERT INTO PCT_TB0 SELECT * FROM PCT_TB0;INSERT INTO PCT_TB0 SELECT * FROM PCT_TB0;
INSERT INTO PCT_TB0 SELECT * FROM PCT_TB0;INSERT INTO PCT_TB0 SELECT * FROM PCT_TB0;
INSERT INTO PCT_TB0 SELECT * FROM PCT_TB0;INSERT INTO PCT_TB0 SELECT * FROM PCT_TB0;
COMMIT;

DROP TABLE IF EXISTS PCT_TB1;
CREATE TABLE PCT_TB1 (f1 int, f2 int, f3 int);
INSERT INTO PCT_TB1 VALUES (1,2,3);INSERT INTO PCT_TB1 VALUES (2,2,19);
INSERT INTO PCT_TB1 VALUES (3,2,29);INSERT INTO PCT_TB1 VALUES (4,2,39);
INSERT INTO PCT_TB1 SELECT * FROM PCT_TB1;INSERT INTO PCT_TB1 SELECT * FROM PCT_TB1;
INSERT INTO PCT_TB1 SELECT * FROM PCT_TB1;INSERT INTO PCT_TB1 SELECT * FROM PCT_TB1;
INSERT INTO PCT_TB1 SELECT * FROM PCT_TB1;INSERT INTO PCT_TB1 SELECT * FROM PCT_TB1;
INSERT INTO PCT_TB1 SELECT * FROM PCT_TB1;INSERT INTO PCT_TB1 SELECT * FROM PCT_TB1;
COMMIT;
CREATE INDEX idx_ptctb_1 ON PCT_TB1 (f1) ONLINE crmode row;
CREATE INDEX idx_ptctb_2 ON PCT_TB1 (f2) PCTFREE 10 crmode page;
CREATE INDEX idx_ptctb_3 ON PCT_TB1 (f3) PCTFREE 80 ONLINE crmode row;
SELECT SEGMENT_NAME, PAGES FROM USER_SEGMENTS where SEGMENT_NAME = 'IDX_PTCTB_1' OR SEGMENT_NAME = 'IDX_PTCTB_2'  OR SEGMENT_NAME = 'IDX_PTCTB_3' ORDER BY SEGMENT_NAME;
ALTER INDEX idx_ptctb_1 ON PCT_TB1 REBUILD PCTFREE 80;
DELETE FROM PCT_TB1;COMMIT;
INSERT INTO PCT_TB1 SELECT * FROM PCT_TB0; COMMIT;
ALTER INDEX idx_ptctb_2 ON PCT_TB1 REBUILD ONLINE;
ALTER INDEX idx_ptctb_3 ON PCT_TB1 REBUILD PCTFREE 50;

DROP TABLE IF EXISTS PCT_P_TB1;
CREATE TABLE PCT_P_TB1 (f1 int, f2 int, f3 int)
PARTITION BY RANGE(f3)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(40)
);
INSERT INTO PCT_P_TB1 VALUES (1,2,3);INSERT INTO PCT_P_TB1 VALUES (2,2,19);
INSERT INTO PCT_P_TB1 VALUES (3,2,29);INSERT INTO PCT_P_TB1 VALUES (4,2,39);
INSERT INTO PCT_P_TB1 SELECT * FROM PCT_P_TB1;INSERT INTO PCT_P_TB1 SELECT * FROM PCT_P_TB1;
INSERT INTO PCT_P_TB1 SELECT * FROM PCT_P_TB1;INSERT INTO PCT_P_TB1 SELECT * FROM PCT_P_TB1;
INSERT INTO PCT_P_TB1 SELECT * FROM PCT_P_TB1;INSERT INTO PCT_P_TB1 SELECT * FROM PCT_P_TB1;
INSERT INTO PCT_P_TB1 SELECT * FROM PCT_P_TB1;INSERT INTO PCT_P_TB1 SELECT * FROM PCT_P_TB1;
INSERT INTO PCT_P_TB1 SELECT * FROM PCT_P_TB1;INSERT INTO PCT_P_TB1 SELECT * FROM PCT_P_TB1;
COMMIT;
create index idx_p11_3 on PCT_P_TB1(f3) local
(
partition p1 pctfree 10,
partition p2 pctfree 50,
partition p3 pctfree 80,
partition p4
) crmode row;
SELECT SEGMENT_NAME, PARTITION_NAME, PAGES FROM USER_SEGMENTS where SEGMENT_NAME = 'IDX_P11_3' ORDER BY PARTITION_NAME;
DELETE FROM PCT_P_TB1; COMMIT;
ALTER INDEX idx_p11_3 on PCT_P_TB1 REBUILD PCTFREE 10;
SELECT  SEGMENT_NAME, PARTITION_NAME, PAGES  FROM USER_SEGMENTS where SEGMENT_NAME = 'IDX_P11_3' ORDER BY PARTITION_NAME;
DROP TABLE IF EXISTS PCT_TB1;
DROP TABLE IF EXISTS PCT_P_TB1;
DROP TABLE IF EXISTS PCT_TB0;
DROP TABLE IF EXISTS I_FIXEDNETWORKLTP;

--DTS2018091501597
CREATE USER fbitester IDENTIFIED BY asdf_1234;
GRANT CREATE ANY TABLE TO fbitester;
GRANT CREATE ANY INDEX TO fbitester;

DROP TABLE IF EXISTS idx_tab001;
DROP TABLE IF EXISTS fbitester.idx_tab001;
CREATE TABLE fbitester.idx_tab001 (col1 INTEGER NOT NULL, col2 VARCHAR(64));
CREATE TABLE idx_tab001 (col1 INTEGER NOT NULL, col2 REAL);
CREATE INDEX sys.ix_idx_tab001 ON fbitester.idx_tab001(TO_CHAR(col1));    -- error. schema name not same
CREATE INDEX ix_idx_tab001 ON fbitester.idx_tab001(TO_CHAR(col1));        -- OK. index's schema equals with "fbitester"
CREATE INDEX fbitester.ix_idx_tab002 ON idx_tab001(TO_CHAR(col2));        -- error. schema name not same
CREATE INDEX ix_idx_tab002 ON idx_tab001(TO_CHAR(col2));                  -- OK. index's schema equals with "sys"

SELECT U.NAME AS OWNER, T.NAME AS TABLE_NAME, I.NAME AS INDEX_NAME FROM SYS_USERS U JOIN SYS_INDEXES I ON U.ID=I.USER# AND U.NAME='fbitester' JOIN SYS_TABLES T ON I.USER#=T.USER# AND I.TABLE#=T.ID WHERE T.NAME='IDX_TAB001';  --1 row expected
SELECT M.USER_NAME AS OWNER, T.NAME AS TABLE_NAME, I.NAME AS INDEX_NAME FROM V$ME M JOIN SYS_INDEXES I ON M.USER_ID=I.USER# JOIN SYS_TABLES T ON I.USER#=T.USER# AND I.TABLE#=T.ID WHERE T.NAME='IDX_TAB001';  --1 row expected

DROP INDEX ix_idx_tab002 ON idx_tab001;
DROP TABLE idx_tab001;
DROP INDEX fbitester.ix_idx_tab001 ON fbitester.idx_tab001;
DROP TABLE fbitester.idx_tab001;
DROP USER fbitester CASCADE;

DROP TABLE IF EXISTS FBI_TEST_IN_INDEX;
CREATE TABLE FBI_TEST_IN_INDEX (ID VARBINARY(36));
CREATE UNIQUE INDEX FBI_UDX_TEST_IN_INDEX ON FBI_TEST_IN_INDEX(TO_CHAR(ID));
SELECT * FROM FBI_TEST_IN_INDEX I WHERE (((((((I.ID IN (UNHEX('11E8C9FF31C8B27489990242E088AEF7'),UNHEX('11E8C9FF31C8D98589990242E088AEF7'),UNHEX('11E8C9FF31C8D98789990242E088AEF7'),UNHEX('11E8C9FF31C8D98689990242E088AEF7'),UNHEX('11E8C9FF31C9009889990242E088AEF7'),UNHEX('11E8C9FF31C9009989990242E088AEF7')) ))
AND (I.ID IN (UNHEX('11E8C9FF31C8B27489990242E088AEF7'),UNHEX('11E8C9FF31C8D98589990242E088AEF7'),UNHEX('11E8C9FF31C8D98789990242E088AEF7'),UNHEX('11E8C9FF31C8D98689990242E088AEF7'),UNHEX('11E8C9FF31C9009889990242E088AEF7'),UNHEX('11E8C9FF31C9009989990242E088AEF7')) ))
AND (I.ID IN (UNHEX('11E8C9FF31C8B27489990242E088AEF7'),UNHEX('11E8C9FF31C8D98589990242E088AEF7'),UNHEX('11E8C9FF31C8D98789990242E088AEF7'),UNHEX('11E8C9FF31C8D98689990242E088AEF7'),UNHEX('11E8C9FF31C9009889990242E088AEF7'),UNHEX('11E8C9FF31C9009989990242E088AEF7')) ))
AND (I.ID IN (UNHEX('11E8C9FF31C8B27489990242E088AEF7'),UNHEX('11E8C9FF31C8D98589990242E088AEF7'),UNHEX('11E8C9FF31C8D98789990242E088AEF7'),UNHEX('11E8C9FF31C8D98689990242E088AEF7'),UNHEX('11E8C9FF31C9009889990242E088AEF7'),UNHEX('11E8C9FF31C9009989990242E088AEF7')) ))
AND (I.ID IN (UNHEX('11E8C9FF31C8B27489990242E088AEF7'),UNHEX('11E8C9FF31C8D98589990242E088AEF7'),UNHEX('11E8C9FF31C8D98789990242E088AEF7'),UNHEX('11E8C9FF31C8D98689990242E088AEF7'),UNHEX('11E8C9FF31C9009889990242E088AEF7'),UNHEX('11E8C9FF31C9009989990242E088AEF7')) )));
DROP TABLE IF EXISTS FBI_TEST_IN_INDEX;

CREATE TABLE FBI_TEST_IN_INDEX (ID INT, PID INT, NAME VARCHAR(8));
CREATE INDEX IDX_IDS ON FBI_TEST_IN_INDEX(TO_CHAR(ID),PID);
INSERT INTO FBI_TEST_IN_INDEX VALUES (1,1,'zzz');
SELECT DISTINCT ID,PID FROM FBI_TEST_IN_INDEX;
DROP TABLE FBI_TEST_IN_INDEX;

--column name using quote, for operating index
DROP TABLE IF EXISTS FBI_TAB_INDEX_KEY_3;
DROP TABLE IF EXISTS FBI_TAB_INDEX_KEY_4;
DROP TABLE IF EXISTS FBI_TAB_INDEX_KEY_1;
DROP TABLE IF EXISTS FBI_TAB_INDEX_KEY_2;
CREATE TABLE FBI_TAB_INDEX_KEY_1 (F_INT1 INT, F_INT2 INT, F_CHAR1 CHAR(8), F_VARCHAR2 VARCHAR(8));
CREATE TABLE FBI_TAB_INDEX_KEY_2 (F_INT3 INT, F_INT4 INT, F_CHAR3 CHAR(8), F_VARCHAR4 VARCHAR(8));
CREATE TABLE FBI_TAB_INDEX_KEY_3 (F_INT5 INT, F_INT6 INT, F_CHAR5 CHAR(8), F_VARCHAR6 VARCHAR(8));
CREATE TABLE FBI_TAB_INDEX_KEY_4 (F_INT7 INT, F_INT8 INT, F_CHAR7 CHAR(8), F_VARCHAR8 VARCHAR(8));
-- INDEX
CREATE INDEX FBI_AAAA ON FBI_TAB_INDEX_KEY_1(UPPER(F_CHAR1));
CREATE INDEX FBI_BBBB ON FBI_TAB_INDEX_KEY_2(UPPER('F_CHAR3'));
-- PRIMARY KEY
ALTER TABLE FBI_TAB_INDEX_KEY_1 ADD CONSTRAINT pk_F1 PRIMARY KEY(UPPER('F_INT1'));
ALTER TABLE FBI_TAB_INDEX_KEY_2 ADD CONSTRAINT PK_F3 PRIMARY KEY(UPPER(F_INT3), 'F_INT4');
-- FOREIGN KEY
ALTER TABLE FBI_TAB_INDEX_KEY_3 ADD CONSTRAINT FK_F5 FOREIGN KEY (TO_CHAR('F_INT5')) REFERENCES FBI_TAB_INDEX_KEY_1 ('F_INT1');
ALTER TABLE FBI_TAB_INDEX_KEY_4 ADD CONSTRAINT FK_F78 FOREIGN KEY (TO_CHAR(F_INT7), 'F_INT8') REFERENCES FBI_TAB_INDEX_KEY_2 (F_INT3, 'F_INT4');
DROP TABLE FBI_TAB_INDEX_KEY_3;
DROP TABLE FBI_TAB_INDEX_KEY_4;
DROP TABLE FBI_TAB_INDEX_KEY_1;
DROP TABLE FBI_TAB_INDEX_KEY_2;

--TO_CHAR char
drop table if exists t_func_tochar;
create table t_func_tochar(f1 int, f2 char(20));
insert into t_func_tochar values(1,'aaa'),(2,'bbb');
create index idx_t_func_tochar on t_func_tochar(to_char(f2));
explain select * from t_func_tochar where to_char(f2) = 'aaa';
select * from t_func_tochar where to_char(f2) = 'aaa';
drop table if exists t_func_tochar;

--DTS2018120310716 
drop table if exists fbi_t1;
create table fbi_t1(f1 int, f2 number(20), f3 int, f4 char(20), f5 varchar(20), f6 number(20));
create index fbi_t1_idx1 on fbi_t1(to_char(f2), to_char(f6));
create index fbi_t1_idx2 on fbi_t1(to_char(f4), upper(f5));
create unique index pk_fbi_t1 on fbi_t1(to_char(f1));
insert into fbi_t1 values(1,1,1,'aaa','bbb',1);
insert into fbi_t1 values(2,1,2,'abc','bca',2);
insert into fbi_t1 values(3,2,3,'acb','bac',3);
insert into fbi_t1 select * from fbi_t1 on duplicate key update f1 = f1+3, f5 = 'xxxx';
commit;
select * from fbi_t1 where f5 = 'xxxx' order by f1;
select count(*) from fbi_t1 where f2 = 1;
select f2 from fbi_t1 where f2 = 1;
select * from fbi_t1 where to_char(f4) = 'aaa';
drop table if exists fbi_t1;

--func index in references
drop table if exists DEP_B;
drop table if exists DEP_A;
create table DEP_A (id1 int, id2 int, id3 int,id4 int);
create table DEP_B (id1 int, id2 int, id3 int,id4 int);
create index IDX_DEP_B on DEP_B (TO_CHAR(id2), id3);
alter table DEP_A add primary key (id3, id2);
alter table DEP_B add foreign key (id2, id3) references DEP_A(id3, id2) on delete cascade;
insert into DEP_A values (1,1,1,1);
insert into DEP_B values (1,1,1,1);
insert into DEP_A values (2,2,2,2);
insert into DEP_B values (3,2,2,4);
commit;
delete from DEP_A where id1 =1; 
commit;
select * from DEP_B;
drop table DEP_B;
drop table DEP_A;

--DTS2018120705742
drop user if exists nebula cascade;
create user nebula identified by Cantian_234;
grant all to nebula;

create table nebula.storage_support_upper_index_range_tbl_000(c_id int,c_d_id bigint NOT NULL,c_w_id bigint NOT NULL,c_p_id bigint NOT NULL,c_k_id bigint NOT NULL,c_middle char(20),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 binary(1500),c_data2 varbinary(8000),c_data3 float,c_data4 double,c_data5 decimal,c_clob clob,c_text blob,c_text1 long,c_text2 raw(1500),c_text3 char(20),c_first varchar(16) NOT NULL);
CREATE or replace procedure nebula.storage_support_upper_index_range_proc_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from dual;
    insert into nebula.storage_support_upper_index_range_tbl_000 select i,i,i,i,i,'OE'||j,'BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate,lpad('QVBUflcHOQNvmgfvdPFZSF',100,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',100,'QVLDfscHOQgfvmPFZDSF'),153.0,100.0,50.0,lpad('12314315487569809',100,'1435764ABC7890abcdef'),lpad('12314315487569809',100,'1435764ABC7890abcdef'),to_char(200),lpad('12314315487569809',100,'1435764ABC7890abcdef'),'bg','iscmRDs'||j from dual;
  END LOOP;
END;
/
call nebula.storage_support_upper_index_range_proc_000(1,100);
commit;

--I1.create table and create index
create table nebula.storage_support_upper_index_range_tbl_010(c_id int,c_d_id bigint NOT NULL,c_w_id bigint NOT NULL,c_p_id bigint NOT NULL,c_k_id bigint NOT NULL,c_middle char(20),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 binary(1500),c_data2 varbinary(8000),c_data3 float,c_data4 double,c_data5 decimal,c_clob clob,c_text blob,c_text1 long,c_text2 raw(1500),c_text3 char(20),c_first varchar(16) NOT NULL) partition by range(c_id,c_first) (partition PART_1 values less than (9999,'iscmRDs9999'),partition PART_2 values less than (99999,'iscmRDs99999'),partition PART_3 values less than (maxvalue,maxvalue));
create table nebula.storage_support_upper_index_range_tbl_010_1(c_id int,c_d_id bigint NOT NULL,c_w_id bigint NOT NULL,c_p_id bigint NOT NULL,c_k_id bigint NOT NULL,c_middle char(20),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 binary(1500),c_data2 varbinary(8000),c_data3 float,c_data4 double,c_data5 decimal,c_clob clob,c_text blob,c_text1 long,c_text2 raw(1500),c_text3 char(20),c_first varchar(16) NOT NULL) partition by range(c_id,c_first) (partition PART_1 values less than (9999,'iscmRDs9999'),partition PART_2 values less than (99999,'iscmRDs99999'),partition PART_3 values less than (maxvalue,maxvalue));
insert into nebula.storage_support_upper_index_range_tbl_010 select * from nebula.storage_support_upper_index_range_tbl_000;
insert into nebula.storage_support_upper_index_range_tbl_010_1 select * from nebula.storage_support_upper_index_range_tbl_000;
commit;
create  index nebula.storage_support_upper_index_range_indx_010_1 on nebula.storage_support_upper_index_range_tbl_010(upper(c_first)) local;
create  index nebula.storage_support_upper_index_range_indx_010_1_1 on nebula.storage_support_upper_index_range_tbl_010_1(to_char(c_id)) local;
--I2.DML
--DML
--select: join
select count(*) from nebula.storage_support_upper_index_range_tbl_000 t1 join nebula.storage_support_upper_index_range_tbl_010 t2 on t1.c_id=t2.c_id;
--delete: without where
select count(*) from nebula.storage_support_upper_index_range_tbl_010;
delete from nebula.storage_support_upper_index_range_tbl_010;
insert into nebula.storage_support_upper_index_range_tbl_010 select * from nebula.storage_support_upper_index_range_tbl_000;
select count(*) from nebula.storage_support_upper_index_range_tbl_010;
--insert:with where and without where
insert into nebula.storage_support_upper_index_range_tbl_010 select c_id+1000,c_d_id+1000,c_w_id+1000,c_p_id+1000,c_k_id+1000,substr(c_middle,1,2)||'1001',substr(c_last,1,6)||(to_number(trim(LEADING 'BARBar' from c_last))+1000),c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data1,c_data2,c_data3,c_data4,c_data5,c_clob,c_text,c_text1,c_text2,c_text3,substr(c_first,1,7)||(to_number(trim(LEADING 'iscmRDs' from c_first))+1000) from nebula.storage_support_upper_index_range_tbl_000 where c_first='iscmRDs1';
select count(*) from nebula.storage_support_upper_index_range_tbl_010 where c_id=1;
delete from nebula.storage_support_upper_index_range_tbl_010 where c_d_id=1001;
insert into nebula.storage_support_upper_index_range_tbl_010_1 select c_id+1000,c_d_id+1000,c_w_id+1000,c_p_id+1000,c_k_id+1000,substr(c_middle,1,2)||'1001',substr(c_last,1,6)||(to_number(trim(LEADING 'BARBar' from c_last))+1000),c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data1,c_data2,c_data3,c_data4,c_data5,c_clob,c_text,c_text1,c_text2,c_text3,substr(c_first,1,7)||(to_number(trim(LEADING 'iscmRDs' from c_first))+1000) from nebula.storage_support_upper_index_range_tbl_000 where c_d_id=1;
select count(*) from nebula.storage_support_upper_index_range_tbl_010_1 where c_first='iscmRDs1001';
delete from nebula.storage_support_upper_index_range_tbl_010_1 where c_id=1001;
insert into nebula.storage_support_upper_index_range_tbl_010 select c_id+100,c_d_id+100,c_w_id+100,c_p_id+100,c_k_id+100,substr(c_middle,1,2)||(to_number(trim(LEADING 'OE' from c_middle))+100),substr(c_last,1,6)||(to_number(trim(LEADING 'BARBar' from c_last))+100),c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data1,c_data2,c_data3,c_data4,c_data5,c_clob,c_text,c_text1,c_text2,c_text3,substr(c_first,1,7)||(to_number(trim(LEADING 'iscmRDs' from c_first))+100) from nebula.storage_support_upper_index_range_tbl_000;
select count(*) from nebula.storage_support_upper_index_range_tbl_010;
insert into nebula.storage_support_upper_index_range_tbl_010_1 select c_id+100,c_d_id+100,c_w_id+100,c_p_id+100,c_k_id+100,substr(c_middle,1,2)||(to_number(trim(LEADING 'OE' from c_middle))+100),substr(c_last,1,6)||(to_number(trim(LEADING 'BARBar' from c_last))+100),c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data1,c_data2,c_data3,c_data4,c_data5,c_clob,c_text,c_text1,c_text2,c_text3,substr(c_first,1,7)||(to_number(trim(LEADING 'iscmRDs' from c_first))+100) from nebula.storage_support_upper_index_range_tbl_000;
select count(*) from nebula.storage_support_upper_index_range_tbl_010_1;
commit;
--update single table 
update nebula.storage_support_upper_index_range_tbl_010 set c_id=2000,c_first='iscmRDs2000' where c_first='iscmRDs200';
select count(*) from nebula.storage_support_upper_index_range_tbl_010 where c_first='iscmRDs2000';
update nebula.storage_support_upper_index_range_tbl_010 set c_id=200,c_first='iscmRDs200' where c_d_id=200;
select c_id,c_first from nebula.storage_support_upper_index_range_tbl_010 where  c_d_id=200;
update nebula.storage_support_upper_index_range_tbl_010 set c_id=900,c_first='iscmRDs900' where c_id=200;
select c_id,c_first from nebula.storage_support_upper_index_range_tbl_010 where c_id=900;
update nebula.storage_support_upper_index_range_tbl_010_1 set c_id=2000,c_first='iscmRDs2000' where c_id=200;
select count(*) from nebula.storage_support_upper_index_range_tbl_010_1 where c_id=2000;
update nebula.storage_support_upper_index_range_tbl_010_1 set c_id=200,c_first='iscmRDs200' where c_w_id=200;
select c_id,c_first from nebula.storage_support_upper_index_range_tbl_010_1 where  c_w_id=200;
update nebula.storage_support_upper_index_range_tbl_010_1 set c_id=900,c_first='iscmRDs900' where c_first='iscmRDs200';
select c_id,c_first from nebula.storage_support_upper_index_range_tbl_010_1 where c_first='iscmRDs900';
--update muti tables
update nebula.storage_support_upper_index_range_tbl_010 t1,nebula.storage_support_upper_index_range_tbl_010_1 t2 set t1.c_id=300,t1.c_first='iscmRDs300',t2.c_id=300,t2.c_first='iscmRDs300' where  t1.c_id=t2.c_id and t1.c_first='iscmRDs30';
select t1.c_id,t1.c_first,t2.c_id,t2.c_first from nebula.storage_support_upper_index_range_tbl_010 t1 join nebula.storage_support_upper_index_range_tbl_010_1 t2 on t1.c_id=t2.c_id where t1.c_first='iscmRDs300';
update nebula.storage_support_upper_index_range_tbl_010 t1,nebula.storage_support_upper_index_range_tbl_010_1 t2 set t1.c_id=30,t1.c_first='iscmRDs30',t2.c_id=30,t2.c_first='iscmRDs30' where  t1.c_id=t2.c_id and t1.c_id=300;
select t1.c_id,t1.c_first,t2.c_id,t2.c_first from nebula.storage_support_upper_index_range_tbl_010 t1 join nebula.storage_support_upper_index_range_tbl_010_1 t2 on t1.c_id=t2.c_id where t1.c_id=30;
commit;
drop user nebula cascade;

drop table if exists fun_t1;
create table fun_t1 (id varchar(1), num int);
create index idx_fun_01 on fun_t1 (upper(id));
insert into fun_t1 values ('a',2);
insert into fun_t1 values ('a',2);
truncate table fun_t1;
FLASHBACK TABLE fun_t1 TO BEFORE TRUNCATE FORCE;
alter table fun_t1 shrink space compact;
drop table fun_t1;
drop table if exists test_hash1;
create table test_hash1 (
c3 char(20) primary key,
c4 number(8) not null
)
partition by hash(c3)
(
partition part_01,
partition part_02,
partition part_03
);

insert into test_hash1 values('aaaa',111);
insert into test_hash1 values('bbbb',111);
insert into test_hash1 values('cccc',111);
insert into test_hash1 values('dddd',111);
insert into test_hash1 values('eeee',111);
insert into test_hash1 values('ffff',111);
insert into test_hash1 values('hhhh',111);
insert into test_hash1 values('iiii',111);

create index idx_hash_part_t2 on test_hash1(upper(c3),c4) local;
select * from test_hash1 partition(part_02) order by c3,c4;

alter table test_hash1 add partition part_04 tablespace users;

select * from test_hash1 partition(part_02) order by c3,c4;
select * from test_hash1 partition(part_04) order by c3,c4;
drop table if exists test_hash1;

conn sys/Huawei@123@127.0.0.1:1611
drop table if exists lin_hash;
create table lin_hash(
col_number1 number,
col_timestamp2 timestamp(6)) crmode row;
create tablespace LIN_INDEX_01 datafile 'lin_index_01.dbf' size 32M autoextend on next 8M maxsize unlimited;
create index if not exists LIN_INDEX_TEST on lin_hash(to_char(col_timestamp2) asc,upper(col_number1) desc) tablespace LIN_INDEX_01 REVERSE;
select * from all_indexes where INDEX_NAME = 'LIN_INDEX_TEST';
drop table lin_hash;
drop tablespace LIN_INDEX_01 including contents and datafiles;

drop table if exists func_idx_t1;
create table func_idx_t1(f1 nvarchar(100));
insert into func_idx_t1 values('访异调野野野环注爱时败世败大大试异测第务野测境智试了xhkf”—~、（；—、【—•~册本失界本了试册测时界时野版智注务测小册');
commit;
select * from func_idx_t1;
create index idx_upper_idx_t1 on func_idx_t1(upper(f1));
select count(1) from func_idx_t1 where f1 = '访异调野野野环注爱时败世败大大试异测第务野测境智试了xhkf”—~、（；—、【—•~册本失界本了试册测时界时野版智注务测小册';
select count(1) from func_idx_t1 where upper(f1) = '访异调野野野环注爱时败世败大大试异测第务野测境智试了XHKF”—~、（；—、【—•~册本失界本了试册测时界时野版智注务测小册';
drop index idx_upper_idx_t1 on func_idx_t1;
create index idx_to_char_idx_t1 on func_idx_t1(to_char(f1));
select count(1) from func_idx_t1 where to_char(f1) = '访异调野野野环注爱时败世败大大试异测第务野测境智试了xhkf”—~、（；—、【—•~册本失界本了试册测时界时野版智注务测小册';
drop table func_idx_t1;

drop table if exists func_idx_t2;
create table func_idx_t2("c1" varchar(10));
create index idx_upper_func_idx_t2 on func_idx_t2(upper("c1"));
select index_name, columns from my_indexes where index_name=upper('idx_upper_func_idx_t2');
drop table func_idx_t2;

create table table1(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(2396) NOT NULL,c_middle char(1500),
c_last varchar(4200) NOT NULL,c_street_1 varchar2(8000) NOT NULL,c_street_2 varchar2(8000),c_city varchar(3892) NOT NULL,
c_state varchar2(3900) NOT NULL,c_zip varchar2(3896) NOT NULL,c_phone varchar2(3900) NOT NULL,c_since timestamp,
c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,
c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_unsig tinyint unsigned,c_big bigint,c_vchar varchar2(8000),
c_data long,c_text blob,c_clob clob,c_image image,c_binary binary(1000),c_varbinary varbinary(1000),c_raw raw(1000));

create unique index index1_1 on table1 (upper(c_id),upper(c_last));
alter table table1 modify c_last varchar(4100);
create unique index index1_1 on table1 (upper(c_id),upper(c_last));
alter table table1 modify c_last varchar(1945);
create unique index index1 on table1 (upper(c_id),upper(c_last));
alter table table1 modify c_last varchar(4100);
alter table table1 modify c_last varchar(4095);
alter table table1 modify c_last varchar(4090);
alter table table1 modify c_last varchar(4085);
alter table table1 modify c_last varchar(4080);
alter table table1 modify c_last varchar(4070);
alter table table1 modify c_last char(4060);

drop table table1;
create table table2(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(2396) NOT NULL,c_middle char(1500),
c_last varchar(1000) NOT NULL,c_street_1 varchar2(8000) NOT NULL,c_street_2 varchar2(8000),c_city varchar(3892) NOT NULL,
c_state varchar2(3900) NOT NULL,c_zip varchar2(3896) NOT NULL,c_phone varchar2(3900) NOT NULL,c_since timestamp,
c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,
c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_unsig tinyint unsigned,c_big bigint,c_vchar varchar2(8000),
c_data long,c_text blob,c_clob clob,c_image image,c_binary binary(1000),c_varbinary varbinary(1000),c_raw raw(1000));

create unique index index2_1 on table2 (c_id,c_last);
create unique index index2_2 on table2 (upper(c_id),upper(c_last));
create unique index index2_3 on table2 (c_id,upper(c_id),upper(c_last));
create unique index index2_4 on table2 (c_id,upper(c_id),c_last);
create unique index index2_5 on table2 (c_id,upper(c_id),c_last, upper(c_last));

alter table table2 modify c_last varchar(2100);
alter table table2 modify c_last varchar(1800);
alter table table2 modify c_last varchar(2080);
alter table table2 modify c_last char(2060);
alter table table2 modify c_last char(1850);
alter table table2 modify c_last varchar(8000);
drop table table2;

drop table if exists func_like_t188;
create table func_like_t188(f1 nvarchar(10),f2 nchar(20));
insert into func_like_t188 values('abad','abc');
alter system set enable_permissive_unicode=true;
insert into func_like_t188 values('0xC0F6BDAD','0xFED0C0F6BDAD');
alter system set enable_permissive_unicode=false;
select * from func_like_t188 where f1 like '0xC0F6BDAD' and f2 like '0xFED0C0F6BDAD';
select * from func_like_t188 where f1 like 0xC0F6BDAD and f2 like 0xFED0C0F6BDAD;
select * from func_like_t188 where f1 like 'a%0xC0F6BDAD%d' and f2 like 'a%0xC0F6BDAD%c';
select * from func_like_t188 where f1 like substrb('中', 1, 1);
select * from func_like_t188 where f1 like '%0xC0F6BDAD%%' escape '0';
select * from func_like_t188 where f1 like '%/0xC0F6BDAD%%' escape '/';
select * from func_like_t188 where f1 like '%0x/C0F6BDAD%%' escape '/';
select * from func_like_t188 where f1 like '%0x/C0F6BDAD%%' escape '\';
drop table func_like_t188;

-- test function index
drop table if exists func_idx_basic_tab;
create table func_idx_basic_tab (
 f1  binary_integer,
 f2  binary_uint32,
 f3  binary_bigint,
 f4  char(3),
 f5  varchar(30),
 f6  boolean,
 f7  datetime,
 f8  timestamp(3),
 f9  timestamp(3) with time zone,
 f10 timestamp(3) with local time zone,
 f11 float,
 f12 number,
 f13 interval day(7) to second,
 f14 interval year(3) to month
);

insert into func_idx_basic_tab values (-1, 100, -32890473279324, 'abc', 'function', true, sysdate, '2020-01-30 13:50:59.202', '2020-02-06 11:20:09.035 +08:00', '2018-03-06 11:20:09.230', 156.275, 4544.2572, '1231 12:3:4.1234', INTERVAL '120-11' YEAR(3) TO MONTH);
insert into func_idx_basic_tab values (0, 200, 32890473279324, 'def', 'PKG', 0, sysdate, '2020-02-19 13:50:59.202', '2020-02-07 11:20:09.035 +08:00', '2002-02-06 11:20:09.230', 27.24, 2727.287, 'P1231DT16H3.3333333S', INTERVAL '10-2' YEAR TO MONTH);
insert into func_idx_basic_tab values (1, null, 4645161, 'ghi', 'INDEX', false, sysdate, '2020-03-30 13:50:59.202', '2020-02-08 11:20:09.035 +08:00', '2002-02-06 11:20:09.230', 257.52, 4542774.242, 'PT12H', null);
insert into func_idx_basic_tab values (2, 300, 48945135, 'gkl', 'test', 1, sysdate, '2020-04-30 13:50:59.202', '2020-02-09 11:20:09.035 +08:00', '2013-02-06 11:20:09.230', 2275.22, null, '-P99DT655M999.99999S', INTERVAL '10-11' YEAR(3) TO MONTH);
insert into func_idx_basic_tab values (3, null, -4315, 'mno', 'REGRESS', true, sysdate, '2020-05-30 13:50:59.202', '2020-02-19 11:20:09.035 +08:00', '2019-02-06 11:20:09.230', 54325725.2782, 25.257, '-0 00:19:7.7777777777', '999-11');
insert into func_idx_basic_tab values (null, 700, 54651364586, 'pqr', 'sql', false, sysdate, '2020-06-30 13:50:59.202', '2020-02-18 11:20:09.035 +08:00', '2013-02-06 11:20:09.230', 2542.8287, 57.27, '-1234 0:0:0.0004', '100-2');
insert into func_idx_basic_tab values (4, 800, 5451, 'stu', 'code', true, sysdate, '2020-07-30 13:50:59.202', '2020-02-11 11:20:09.035 +08:00', '2010-02-06 11:20:09.230', 67.827, 276.546, null, '100-2');
insert into func_idx_basic_tab values (5, 0, 1456465, 'vwx', 'MASTER', false, sysdate, '2020-08-30 13:50:59.202', '2020-02-10 11:20:09.035 +08:00', '2011-02-06 11:20:09.230', 372.87, null, null, null);
commit;

-- test nvl/nvl2 function index
create index ix_nvl_tab_1 on func_idx_basic_tab (nvl('abc', 'def')); -- error
create index ix_nvl_tab_1 on func_idx_basic_tab (nvl(f1, 100));
create index ix_nvl_tab_2 on func_idx_basic_tab (nvl(f1, f2)); -error
create index ix_nvl_tab_2 on func_idx_basic_tab (f1, nvl(f1, 1000));
create index ix_nvl_tab_3 on func_idx_basic_tab (f1, nvl(f1, 1000), nvl2(f2, 'not null', 'null'));
create index ix_nvl_tab_4 on func_idx_basic_tab (nvl2(f1, f1, 10000));
create index ix_nvl_tab_5 on func_idx_basic_tab (nvl2(f2, f2, 10000));
create index ix_nvl_tab_6 on func_idx_basic_tab (nvl2(f3, f3, 10000));
create index ix_nvl_tab_7 on func_idx_basic_tab (nvl2(f4, f4, '-'));
create index ix_nvl_tab_8 on func_idx_basic_tab (nvl2(f5, f5, '-'));
create index ix_nvl_tab_9 on func_idx_basic_tab (nvl2(f6, f6, false));
create index ix_nvl_tab_10 on func_idx_basic_tab (nvl2(f7, f7, sysdate)); -- error
create index ix_nvl_tab_11 on func_idx_basic_tab (nvl2(f8, f8, '2020-02-02 23:59:59'));
create index ix_nvl_tab_12 on func_idx_basic_tab (nvl2(f11, f11, -1.0342));
create index ix_nvl_tab_13 on func_idx_basic_tab (nvl2(f12, f12, 0));
create index ix_nvl_tab_14 on func_idx_basic_tab (nvl2(f13, f13, '-1234 0:0:0.0004'));
create index ix_nvl_tab_15 on func_idx_basic_tab (nvl2(f14, f14, '11-10'));

select index_name, columns from user_indexes where table_name = 'FUNC_IDX_BASIC_TAB' order by index_name;

alter table func_idx_basic_tab modify f2 varchar(30);

select f1, nvl(f1, 100), f2 from func_idx_basic_tab where nvl(f1, 100) = 1 order by 1,2,3;
select f1, nvl(f1, 100), f2 from func_idx_basic_tab where nvl(f1, 100) = 100 order by 1,2,3;
select f1, nvl(f1, 100), f2 from func_idx_basic_tab where nvl(f1, 100) > 3 order by 1,2,3;
select f1, nvl2(f1, f1, 100), f2 from func_idx_basic_tab where nvl2(f1, f1, 100) = 1 order by 1,2,3;
select f1, nvl2(f1, f1, 100), f2 from func_idx_basic_tab where nvl2(f1, f1, 100) = 100 order by 1,2,3;

select f3 from func_idx_basic_tab where nvl2(f3, f3, 10000) > 100 order by f3;
explain select f3 from func_idx_basic_tab where nvl2(f3, f3, 10000) > 100 and nvl2(f3, f3, 10000) <= 48945135 order by f3;
select f3 from func_idx_basic_tab where nvl2(f3, f3, 10000) > 100 and nvl2(f3, f3, 10000) <= 48945135 order by f3;
explain select f3 from func_idx_basic_tab where nvl2(f3, f3, 10000) > 100 or nvl2(f3, f3, 10000) = -4315 order by f3;
select f3 from func_idx_basic_tab where nvl2(f3, f3, 10000) > 100 or nvl2(f3, f3, 10000) = -4315 order by f3;

explain select f4 from func_idx_basic_tab where nvl2(f4, f4, '-') = 'ghi';
select f4 from func_idx_basic_tab where nvl2(f4, f4, '-') = 'ghi';
explain select f4 from func_idx_basic_tab where nvl2(f4, f4, '-') like 'ghi%';
select f4 from func_idx_basic_tab where nvl2(f4, f4, '-') like 'ghi%';

explain select f5 from func_idx_basic_tab where nvl2(f5, f5, '-') = 'function';
select f5 from func_idx_basic_tab where nvl2(f5, f5, '-') = 'function';
explain select f5 from func_idx_basic_tab where nvl2(f5, f5, '-') like 't%' or nvl2(f5, f5, '-') like 'm%';
select f5 from func_idx_basic_tab where nvl2(f5, f5, '-') like 't%' or nvl2(f5, f5, '-') like 'm%' order by f5;

explain select f6 from func_idx_basic_tab where nvl2(f6, f6, false) = 'T';
select f6 from func_idx_basic_tab where nvl2(f6, f6, false) = true;

explain select f8 from func_idx_basic_tab where nvl2(f8, f8, '2020-02-02 23:59:59') = '2020-03-30 13:50:59.202';
select f8 from func_idx_basic_tab where nvl2(f8, f8, '2020-02-02 23:59:59') = '2020-03-30 13:50:59.202';
explain select f8 from func_idx_basic_tab where nvl2(f8, f8, '2020-02-02 23:59:59') > '2020-03-30 13:50:59.202' and nvl2(f8, f8, '2020-02-02 23:59:59') <= '2020-06-30 13:50:59.202';
select f8 from func_idx_basic_tab where nvl2(f8, f8, '2020-02-02 23:59:59') > '2020-03-30 13:50:59.202' and nvl2(f8, f8, '2020-02-02 23:59:59') <= '2020-06-30 13:50:59.202' order by f8;

explain select f11 from func_idx_basic_tab where nvl2(f11, f11, -1.0342) = 257.52;
select f11 from func_idx_basic_tab where nvl2(f11, f11, -1.0342) = 257.52;
explain select f11 from func_idx_basic_tab where nvl2(f11, f11, -1.0342) = 257.52 or nvl2(f11, f11, -1.0342) = 372.87;
select f11 from func_idx_basic_tab where nvl2(f11, f11, -1.0342) = 257.52 or nvl2(f11, f11, -1.0342) = 372.87 order by f11;

explain select f12 from func_idx_basic_tab where nvl2(f12, f12, 0) = 4542774.242;
select f12 from func_idx_basic_tab where nvl2(f12, f12, 0) = 4542774.242;
explain select f12 from func_idx_basic_tab where nvl2(f12, f12, 0) > 2727.287 or nvl2(f12, f12, 0) <= 57.27 order by f12;
select f12 from func_idx_basic_tab where nvl2(f12, f12, 0) > 2727.287 or nvl2(f12, f12, 0) <= 57.27 order by f12;
explain select f12 from func_idx_basic_tab where nvl2(f12, f12, 0) >= 254.727 and nvl2(f12, f12, 0) <= 4544.2572 order by f12;
select f12 from func_idx_basic_tab where nvl2(f12, f12, 0) >= 254.727 and nvl2(f12, f12, 0) <= 4544.2572 order by f12;

explain select f13 from func_idx_basic_tab where nvl2(f13, f13, '-1234 0:0:0.0004') = '-1234 0:0:0.0004';
select f13 from func_idx_basic_tab where nvl2(f13, f13, '-1234 0:0:0.0004') = '-1234 0:0:0.0004' order by f13;
explain select f13 from func_idx_basic_tab where nvl2(f13, f13, '-1234 0:0:0.0004') >= '100 10:0:0.0004' and nvl2(f13, f13, '-1234 0:0:0.0004') <= '+0001231 12:03:04.123400';
select f13 from func_idx_basic_tab where nvl2(f13, f13, '-1234 0:0:0.0004') >= '100 10:0:0.0004' and nvl2(f13, f13, '-1234 0:0:0.0004') <= '+0001231 12:03:04.123400' order by f13;

explain select f14 from func_idx_basic_tab where nvl2(f14, f14, '11-10') = '10-11';
select f14 from func_idx_basic_tab where nvl2(f14, f14, '11-10') = '10-11';
explain select f14 from func_idx_basic_tab where nvl2(f14, f14, '11-10') > '10-11' and nvl2(f14, f14, '11-10') <= '+120-11' order by f14;
select f14 from func_idx_basic_tab where nvl2(f14, f14, '11-10') > '10-11' and nvl2(f14, f14, '11-10') <= '+120-11' order by f14;
explain select f14 from func_idx_basic_tab where nvl2(f14, f14, '11-10') < '+100-02' or nvl2(f14, f14, '11-10') >= '+120-11' order by f14;
select f14 from func_idx_basic_tab where nvl2(f14, f14, '11-10') < '+100-02' or nvl2(f14, f14, '11-10') >= '+120-11' order by f14;
explain select f14 from func_idx_basic_tab where nvl2(f14, f14, '11-10') between '+100-02' and '+120-11' order by f14;
select f14 from func_idx_basic_tab where nvl2(f14, f14, '11-10') between '+100-02' and '+120-11' order by f14;



-- test substr function index
drop table if exists substr_idx_tab;
create table substr_idx_tab (f1 varchar(30), f2 varchar(40));
insert into substr_idx_tab values ('abc', 'beijing');
insert into substr_idx_tab values ('abc', 'nanjingnan');
insert into substr_idx_tab values ('Def', 'shanghai');
insert into substr_idx_tab values (null, 'guangzhou');
insert into substr_idx_tab values ('substr function index', 'nanjing');
insert into substr_idx_tab values ('test', 'shenzhen');
commit;
create index ix_substr_tab_1 on substr_idx_tab (substr(f1, 2, 5));
create index ix_substr_tab_2 on substr_idx_tab (substr(f1, 1, 3), f2);
create index ix_substr_tab_3 on substr_idx_tab (f2, substr(f1, 1, 3));
create index ix_substr_tab_2 on substr_idx_tab (substr(f2, 1, 1)); -- oralce can create succeed
explain select * from substr_idx_tab where substr(f1, 2, 5) = 'bc';
explain select * from substr_idx_tab where substr(f1, 2, 6) = 'dk';
explain select * from substr_idx_tab where substr(f1, 2, 5) like 'bdaf%';
explain select * from substr_idx_tab where substr(f1, 1, 3) = 'abc';

select * from substr_idx_tab where substr(f1, 2, 5) = 'bc';
select * from substr_idx_tab where substr(f1, 2, 5) >= 'ef' order by f1;
select * from substr_idx_tab where substr(f1, 2, 5) like 'bc%' order by f1;
select * from substr_idx_tab where substr(f1, 2, 5) between 'bc%' and 'test' order by f1;
select * from substr_idx_tab where substr(f1, 1, 3) = 'abc' order by f2;

-- test to_date function index
drop table if exists to_date_tab;
create table to_date_tab(f1 varchar(30), f2 number);
create index ix_to_date_1 on to_date_tab(to_date(f1, 'YYYY-MM-DD HH24:MI:SS:FF'));
create index ix_to_date_2 on to_date_tab(to_date(f2, 'YYYYMMDD HH24MISS'));

insert into to_date_tab values ('2009-10-01 00:00:00:00', 20091001000000);
insert into to_date_tab values ('2012-05-28 12:00:00:59', 20120528120000);
insert into to_date_tab values ('2015-08-28 12:00:00:59', 20150828120059);
insert into to_date_tab values ('2019-12-31 12:59:59:59', 20191231125959);
insert into to_date_tab values ('2020-02-02 23:59:59:59', 20200202235959);

commit;
insert into to_date_tab values ('2020-02-02 12:59:59:59-', 20191231125959); --error
insert into to_date_tab values ('2020-02-02 12:59:59:59', 20191231125960); --error
explain select * from to_date_tab where f1 = '2015-08-28 12:00:00:59';
select * from to_date_tab where f1 = '2015-08-28 12:00:00:59'; -- can also use the function index
explain select * from to_date_tab where to_date(f1, 'YYYY-MM-DD HH24:MI:SS:FF') < '2012-05-28 12:00:00' or to_date(f1, 'YYYY-MM-DD HH24:MI:SS:FF') >= '2019-12-31 12:59:59';
select * from to_date_tab where to_date(f1, 'YYYY-MM-DD HH24:MI:SS:FF') < '2012-05-28 12:00:00' or to_date(f1, 'YYYY-MM-DD HH24:MI:SS:FF') >= '2019-12-31 12:59:59' order by f1;
explain select * from to_date_tab where to_date(f1, 'YYYY-MM-DD HH24:MI:SS:FF') >= '2012-05-28 12:00:00' and to_date(f1, 'YYYY-MM-DD HH24:MI:SS:FF') < '2019-12-31 12:59:59';
select * from to_date_tab where to_date(f1, 'YYYY-MM-DD HH24:MI:SS:FF') >= '2012-05-28 12:00:00' and to_date(f1, 'YYYY-MM-DD HH24:MI:SS:FF') < '2019-12-31 12:59:59' order by f1;

explain select * from to_date_tab where f2 = 20150828120059;
explain select * from to_date_tab where to_date(f2, 'YYYYMMDD HH24MISS') = '2015-08-28 12:00:59';
select * from to_date_tab where to_date(f2, 'YYYYMMDD HH24MISS') = '2015-08-28 12:00:59';
explain select * from to_date_tab where to_date(f2, 'YYYYMMDD HH24MISS') < '2012-05-28 12:00:00' or to_date(f2, 'YYYYMMDD HH24MISS') >= '2019-12-31 12:59:59' order by f1;
select * from to_date_tab where to_date(f2, 'YYYYMMDD HH24MISS') < '2012-05-28 12:00:00' or to_date(f2, 'YYYYMMDD HH24MISS') >= '2019-12-31 12:59:59' order by f1;
explain select * from to_date_tab where to_date(f2, 'YYYYMMDD HH24MISS') >= '2012-05-28 12:00:00' and to_date(f2, 'YYYYMMDD HH24MISS') < '2020-02-02 23:59:59' order by f1;
select * from to_date_tab where to_date(f2, 'YYYYMMDD HH24MISS') >= '2012-05-28 12:00:00' and to_date(f2, 'YYYYMMDD HH24MISS') < '2020-02-02 23:59:59' order by f1;

-- test trunc function index
drop table if exists trunc_tab;
create table trunc_tab (f1 number);
insert into trunc_tab values (14563.45);
insert into trunc_tab values (34354.43234);
insert into trunc_tab values (35435.3472);
insert into trunc_tab values (3422540.2404);
insert into trunc_tab values (40.240);
insert into trunc_tab values (278.45);
insert into trunc_tab values (145323);
commit;
create index ix_trunc_tab on trunc_tab (trunc(f1, 2));
explain select * from trunc_tab where trunc(f1,2) = 35435.34;
select * from trunc_tab where trunc(f1,2) = 35435.34 order by f1;
explain select * from trunc_tab where trunc(f1,2) > 278.40 and trunc(f1,2) <= 145323;
select * from trunc_tab where trunc(f1,2) > 278.40 and trunc(f1,2) <= 145323 order by f1;
explain select * from trunc_tab where trunc(f1,2) > 35435.3 or trunc(f1,2) <= 278.454 order by f1;
select * from trunc_tab where trunc(f1,2) > 35435.3 or trunc(f1,2) <= 278.454 order by f1;
explain select * from trunc_tab where trunc(f1,2) in (14563.45, 145323, 3422540.240);
select * from trunc_tab where trunc(f1,2) in (14563.45, 145323, 3422540.240);

-- test to_number function index
drop table if exists to_number_tab;
create table to_number_tab(f1 varchar(30));
create index ix_to_number_1 on to_number_tab (to_number(f1, 'XXXXXXX'));
insert into to_number_tab values ('ABCfd00');
insert into to_number_tab values ('FA00340');
insert into to_number_tab values ('123E500');
insert into to_number_tab values ('1456A00');
insert into to_number_tab values ('213AD00');
insert into to_number_tab values ('12DE500');
insert into to_number_tab values ('123.500'); -- error format
insert into to_number_tab values ('123H500'); -- error format

explain select f1, to_number(f1, 'XXXXXXX') from to_number_tab where to_number(f1, 'XXXXXXX') = 19129600;
select f1, to_number(f1, 'XXXXXXX') from to_number_tab where to_number(f1, 'XXXXXXX') = 19129600;
explain select f1, to_number(f1, 'XXXXXXX') from to_number_tab where to_number(f1, 'XXXXXXX') <= 21326336 order by 2;
select f1, to_number(f1, 'XXXXXXX') from to_number_tab where to_number(f1, 'XXXXXXX') <= 21326336 order by 2;
explain select f1, to_number(f1, 'XXXXXXX') from to_number_tab where to_number(f1, 'XXXXXXX') > 19784960 and to_number(f1, 'XXXXXXX') <= 180157696order by 2;
select f1, to_number(f1, 'XXXXXXX') from to_number_tab where to_number(f1, 'XXXXXXX') > 19784960 and to_number(f1, 'XXXXXXX') <= 180157696order by 2;

-- test lower function index
create index ix_nvl_tab_16 on func_idx_basic_tab (lower(f5));
explain select f5 from func_idx_basic_tab where lower(f5) = 'master';
select f5 from func_idx_basic_tab where lower(f5) = 'master';

-- test REGEXP_INSTR function index
insert into func_idx_basic_tab (f5) values ('17,20,23');
insert into func_idx_basic_tab (f5) values ('abasd,fdjsalfj,fjdlsaj');
insert into func_idx_basic_tab (f5) values (',fejljf,fjdls,1232');
insert into func_idx_basic_tab (f5) values (',fdsaf,17,20wour4389,2r4jfos,');
insert into func_idx_basic_tab (f5) values ('fewfd,fewqff325,frewg523,');
insert into func_idx_basic_tab (f5) values ('ferf1d5,fdsafd5416,fdsagra156a');
create index ix_nvl_tab_17 on func_idx_basic_tab (regexp_instr(f5, '[^,]+',1,3,0,'i'));
explain select f1, f5, regexp_instr(f5, '[^,]+',1,3,0,'i') from func_idx_basic_tab where regexp_instr(f5, '[^,]+',1,3,0,'i') = 16 order by 3,2,1;
select f1, f5, regexp_instr(f5, '[^,]+',1,3,0,'i') from func_idx_basic_tab where regexp_instr(f5, '[^,]+',1,3,0,'i') = 16 order by 3,2,1;
explain select f1, f5, regexp_instr(f5, '[^,]+',1,3,0,'i') from func_idx_basic_tab where regexp_instr(f5, '[^,]+',1,3,0,'i') >= 11 and regexp_instr(f5, '[^,]+',1,3,0,'i') < 17 order by 3,2,1;
select f1, f5, regexp_instr(f5, '[^,]+',1,3,0,'i') from func_idx_basic_tab where regexp_instr(f5, '[^,]+',1,3,0,'i') >= 11 and regexp_instr(f5, '[^,]+',1,3,0,'i') < 17 order by 3,2,1;
explain select f1, f5, regexp_instr(f5, '[^,]+',1,3,0,'i') from func_idx_basic_tab where regexp_instr(f5, '[^,]+',1,3,0,'i') < 11 or regexp_instr(f5, '[^,]+',1,3,0,'i') >= 17 order by 3,2,1;
select f1, f5, regexp_instr(f5, '[^,]+',1,3,0,'i') from func_idx_basic_tab where regexp_instr(f5, '[^,]+',1,3,0,'i') < 11 or regexp_instr(f5, '[^,]+',1,3,0,'i') >= 17 order by 3,2,1;

-- test regexp_substr function index
create index ix_nvl_tab_18 on func_idx_basic_tab (regexp_substr(f5, '[^,]+',1,3,'i'));
explain select f1, f5, regexp_substr(f5, '[^,]+',1,3,'i') from func_idx_basic_tab where regexp_substr(f5, '[^,]+',1,3,'i') is null order by 2, 1;
select f1, f5, regexp_substr(f5, '[^,]+',1,3,'i') from func_idx_basic_tab where regexp_substr(f5, '[^,]+',1,3,'i') is null order by 2, 1;
explain select f1, f5, regexp_substr(f5, '[^,]+',1,3,'i') from func_idx_basic_tab where regexp_substr(f5, '[^,]+',1,3,'i') = 'fjdlsaj' order by 2, 1;
select f1, f5, regexp_substr(f5, '[^,]+',1,3,'i') from func_idx_basic_tab where regexp_substr(f5, '[^,]+',1,3,'i') = 'fjdlsaj' order by 2, 1;
explain select f1, f5, regexp_substr(f5, '[^,]+',1,3,'i') from func_idx_basic_tab where regexp_substr(f5, '[^,]+',1,3,'i') >= '23' and regexp_substr(f5, '[^,]+',1,3,'i') < 'frewg523' order by 3, 2;
select f1, f5, regexp_substr(f5, '[^,]+',1,3,'i') from func_idx_basic_tab where regexp_substr(f5, '[^,]+',1,3,'i') >= '23' and regexp_substr(f5, '[^,]+',1,3,'i') < 'frewg523' order by 3, 2;
explain select f1, f5, regexp_substr(f5, '[^,]+',1,3,'i') from func_idx_basic_tab where regexp_substr(f5, '[^,]+',1,3,'i') < '23' or regexp_substr(f5, '[^,]+',1,3,'i') >= 'frewg523' order by 3, 2;
select f1, f5, regexp_substr(f5, '[^,]+',1,3,'i') from func_idx_basic_tab where regexp_substr(f5, '[^,]+',1,3,'i') < '23' or regexp_substr(f5, '[^,]+',1,3,'i') >= 'frewg523' order by 3, 2;

-- test trim function index
create index ix_nvl_tab_19 on func_idx_basic_tab (trim(leading f5 from 'apockf'));
explain select f5, trim(leading f5 from 'apockf') from func_idx_basic_tab where trim(leading f5 from 'apockf') = 'apockf' order by 1;
select f5, trim(leading f5 from 'apockf') from func_idx_basic_tab where trim(leading f5 from 'apockf') = 'apockf' order by 1;
explain select f5, trim(leading f5 from 'apockf') from func_idx_basic_tab where trim(leading f5 from 'apockf') like 'poc%' order by 1;
select f5, trim(leading f5 from 'apockf') from func_idx_basic_tab where trim(leading f5 from 'apockf') like 'poc%' order by 1;
create index ix_nvl_tab_20 on func_idx_basic_tab (trim(both ',apock137' from f5));
explain select f5, trim(both ',apock137' from f5) from func_idx_basic_tab where trim(both ',apock137' from f5) = '20,2' order by 1;
select f5, trim(both ',apock137' from f5) from func_idx_basic_tab where trim(both ',apock137' from f5) = '20,2' order by 1;
explain select f5, trim(both ',apock137' from f5) from func_idx_basic_tab where trim(both ',apock137' from f5) like 'f%' order by 1;
select f5, trim(both ',apock137' from f5) from func_idx_basic_tab where trim(both ',apock137' from f5) like 'f%' order by 1;
explain select f5, trim(both ',apock137' from f5) from func_idx_basic_tab where trim(both ',apock137' from f5) > 'de' and trim(both ',apock137' from f5) <= 'indfx' order by 2;
select f5, trim(both ',apock137' from f5) from func_idx_basic_tab where trim(both ',apock137' from f5) > 'de' and trim(both ',apock137' from f5) <= 'indfx' order by 2;

-- test decode function index
create index ix_nvl_tab_21 on func_idx_basic_tab (decode(f1, -1, 100, 0, 200, 2, 300, 400));
explain select f1, decode(f1, -1, 100, 0, 200, 2, 300, 400) from func_idx_basic_tab where decode(f1, -1, 100, 0, 200, 2, 300, 400) = 200 order by 1, 2;
select f1, decode(f1, -1, 100, 0, 200, 2, 300, 400) from func_idx_basic_tab where decode(f1, -1, 100, 0, 200, 2, 300, 400) = 200 order by 1, 2;
explain select f1, decode(f1, -1, 100, 0, 200, 2, 300, 400) from func_idx_basic_tab where decode(f1, -1, 100, 0, 200, 2, 300, 400) >= 200 and decode(f1, -1, 100, 0, 200, 2, 300, 400) < 400 order by 1, 2;
select f1, decode(f1, -1, 100, 0, 200, 2, 300, 400) from func_idx_basic_tab where decode(f1, -1, 100, 0, 200, 2, 300, 400) >= 200 and decode(f1, -1, 100, 0, 200, 2, 300, 400) < 400 order by 1, 2;

create index ix_nvl_tab_22 on func_idx_basic_tab (decode(-1, f1, 0, 0, f1, 2));
create index ix_nvl_tab_23 on func_idx_basic_tab (decode(-1, f1, 0, 0, f2, 2)); -- not support now
explain select f1, decode(-1, f1, 0, 0, f1, 2) from func_idx_basic_tab where decode(-1, f1, 0, 0, f1, 2) = 0 order by f1, f2;
explain select f1, decode(-1, f1, 0, 0, f1, 2) from func_idx_basic_tab where decode(-1, f1, 0, 0, f1, 2) > 3 order by f1, f2;
select f1, decode(-1, f1, 0, 0, f1, 2) from func_idx_basic_tab where decode(-1, f1, 0, 0, f1, 2) > 3 order by f1, f2;

-- test case when
create index ix_nvl_tab_24 on func_idx_basic_tab (case f1 when -1 then 'abc' when 1 then 'def' when null then 'null' else 'ok' end);
explain select * from (select f1, case f1 when -1 then 'abc' when 1 then 'def' when null then 'null' else 'ok' end as result from func_idx_basic_tab) where result = 'def';
select * from (select f1, case f1 when -1 then 'abc' when 1 then 'def' when null then 'null' else 'ok' end as result from func_idx_basic_tab) where result = 'def';
explain select * from (select f1, case f1 when -1 then 'abc' when 1 then 'def' when null then 'null' else 'ok' end as result from func_idx_basic_tab) where result like 'abc%';
select * from (select f1, case f1 when -1 then 'abc' when 1 then 'def' when null then 'null' else 'ok' end as result from func_idx_basic_tab) where result like 'abc%';

create index ix_nvl_tab_25 on func_idx_basic_tab (case when f1 = -1 then 'abc' when f1=1 then 'def' when f1 is null then 'null' else 'ok' end);
explain select * from (select f1, case when f1 = -1 then 'abc' when f1=1 then 'def' when f1 is null then 'null' else 'ok' end as result from func_idx_basic_tab) where result = 'def';
select * from (select f1, case when f1 = -1 then 'abc' when f1=1 then 'def' when f1 is null then 'null' else 'ok' end as result from func_idx_basic_tab) where result = 'def';
explain select * from (select f1, case when f1 = -1 then 'abc' when f1=1 then 'def' when f1 is null then 'null' else 'ok' end as result from func_idx_basic_tab) where result like 'o%' order by 1, 2;
select * from (select f1, case when f1 = -1 then 'abc' when f1=1 then 'def' when f1 is null then 'null' else 'ok' end as result from func_idx_basic_tab) where result like 'o%' order by 1, 2;

explain select f1 from func_idx_basic_tab where f1 is null;
select f1 from func_idx_basic_tab where f1 is null;

-- not support
create index ix_nvl_tab_26 on func_idx_basic_tab (case when f8 = systimestamp then 'abc' else 'def' end); -- error

-- temp table
alter system set LOCAL_TEMPORARY_TABLE_ENABLED = TRUE;
create table #func_t1(i varchar(30), id int);
create index idx_t1 on #func_t1(case when i='abc' then 'def' else 'dfds' end); -- error
drop table #func_t1;
alter system set LOCAL_TEMPORARY_TABLE_ENABLED = FALSE;

-- global temp table
drop table if exists temp_func_1;
create global temporary table temp_func_1 (id1 varchar(2) not null, id2 varchar(2)) on commit preserve rows;
insert into temp_func_1 values ('a', 'a');
insert into temp_func_1 values ('a', 'b');
insert into temp_func_1 values ('a', null);
insert into temp_func_1 values ('b', '');
create index idx_temp_1 on temp_func_1(nvl2(id2, id2, 'kk'));
explain select * from temp_func_1 where nvl2(id2, id2, 'kk') = 'kk' order by 1;
select * from temp_func_1 where nvl2(id2, id2, 'kk') = 'kk' order by 1;
create index idx_temp_2 on temp_func_1(case id1 when 'a' then 'A' else 'B' end);
explain select * from temp_func_1 where case id1 when 'a' then 'A' else 'B' end = 'A' order by 1, 2;
select * from temp_func_1 where case id1 when 'a' then 'A' else 'B' end = 'A' order by 1, 2;
explain update temp_func_1 set id1 = 'k' where nvl2(id2, id2, 'kk') = 'kk';
explain update temp_func_1 set id1 = 'k' where case id1 when 'a' then 'A' else 'B' end = 'A';

--partition table and local index
drop table if exists func_idx_part_tab;
create table func_idx_part_tab(i varchar(100), id int) partition by range (id)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
);
insert into func_idx_part_tab values ('a', 1);
insert into func_idx_part_tab values ('asss', 15);
insert into func_idx_part_tab values ('', 25);
insert into func_idx_part_tab values (NULL, 35);
create index idx_part_tab_1 on func_idx_part_tab (case i when 'a' then 'A' else 'B' end) local;
alter table func_idx_part_tab modify i varchar(4000);
explain select * from func_idx_part_tab where case i when 'a' then 'A' else 'B' end = 'A';
select * from func_idx_part_tab where case i when 'a' then 'A' else 'B' end = 'A';
alter table func_idx_part_tab modify i varchar(4); -- error
alter table func_idx_part_tab rename column i to f1; -- not support
alter table func_idx_part_tab modify i int;
create index idx_loc_2 on func_idx_part_tab (decode(id, 1, 'abc', 2, 'def', 'null'));
alter table func_idx_part_tab modify id varchar(10);
truncate table func_idx_part_tab;
create index idx_loc_6 on func_idx_part_tab (upper(i));
alter table func_idx_part_tab modify i varchar(4000);
alter table func_idx_part_tab modify i varchar(4043);
alter table func_idx_part_tab modify i varchar(4042);

-- check is the same index
create index idx_loc_2 on func_idx_part_tab (case i when  'a' then 'A' else 'B' end) local; -- error
create index idx_loc_2 on func_idx_part_tab (case I when  'a' then 'A' else 'B' end) local; -- error
create index idx_loc_2 on func_idx_part_tab (case I when  'a' then 'A' else 'C' end) local; -- succeed
create index idx_loc_3 on func_idx_part_tab (to_char(id + 1));
create index idx_loc_4 on func_idx_part_tab (to_char(id +1)); -- error
create index idx_loc_4 on func_idx_part_tab (to_char(ID + 1)); -- error
create index idx_loc_4 on func_idx_part_tab (id);
create index idx_loc_5 on func_idx_part_tab (id); -- error

-- create function index on lob/array field
drop table if exists test_array_index_tab;
create table test_array_index_tab (f1 int, f2 varchar(30), f3 int[], f4 clob, f5 blob, f6 image);
create index ix_test_array_1 on test_array_index_tab (nvl2(f3, f3, '{12,34,42}')); -- error
create index ix_test_array_1 on test_array_index_tab (case f3 when '{12,34,42}' then null else array[1,3] end)); -- error
create index ix_test_array_1 on test_array_index_tab (case f1 when 1 then array[1,2] else array[3,4] end); -- error
create index ix_test_array_1 on test_array_index_tab (nvl(f4, 'abc'));
create index ix_test_array_1 on test_array_index_tab (nvl(f5, 'abc'));
create index ix_test_array_1 on test_array_index_tab (nvl(f6, 'abc'));

-- can not create function index on 2 different columns
drop table if exists tab_func_index_cols_test;
create table tab_func_index_cols_test (f1 int, "f2" int, "F2" varchar(30));
create index ix_cols_test_1 on tab_func_index_cols_test (f1, "f2");
create index ix_cols_test_2 on tab_func_index_cols_test (f1, "F2");
create index ix_cols_test_3 on tab_func_index_cols_test (f1, f2); -- conflict with ix_cols_test_2
create index ix_cols_test_4 on tab_func_index_cols_test (f1, F2); -- conflict with ix_cols_test_2
create index ix_cols_test_5 on tab_func_index_cols_test (f1, nvl2(f2, f2, 100));
create index ix_cols_test_6 on tab_func_index_cols_test (f1, nvl2("f2", "f2", 100));
create index ix_cols_test_7 on tab_func_index_cols_test (f1, nvl2("F2", "F2", 100)); -- conflict with ix_cols_test_5
create index ix_cols_test_8 on tab_func_index_cols_test (f1, nvl2(F2, F2, 100)); -- conflict with ix_cols_test_5
create index ix_cols_test_9 on tab_func_index_cols_test (f1, nvl2(F2, "f2", 100)); -- report error
create index ix_cols_test_9 on tab_func_index_cols_test (f1, nvl2("f2", "F2", 100)); -- report error
create index ix_cols_test_10 on tab_func_index_cols_test (f1, nvl2(f2, "F2", 100)); -- conflict with ix_cols_test_5
create index ix_cols_test_10 on tab_func_index_cols_test (f1, nvl2("F2", f2, 100)); -- conflict with ix_cols_test_5

drop table if exists t_fun_index_001;
create table t_fun_index_001(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10) not null,c_vchar2 varchar2(100),c_clob clob,
c_long varchar(200),c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp);
insert into t_fun_index_001 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));

create index idx_t_fun_index_001 on t_fun_index_001(case count(c_int) over() when 1007 then 'abc' else 'def' end,SUBSTR(c_vchar,2,3)); -- error
create index idx_t_fun_index_001 on t_fun_index_001(case prior id when 1 then 'abc' else 'def' end); -- error
create index idx_t_fun_index_001 on t_fun_index_001(case when id in (select 1 from dual) then 'ab' else 'def' end); -- error
create index idx_t_fun_index_001 on t_fun_index_001(case when sys_connect_by_path(id, '/') = 'abc' then 1 else 2 end); -- error
create index idx_t_fun_index_001 on t_fun_index_001(case c_int when 1007 then 'abc' else 'def' end,case c_int when 1007 then 'abc' else 'def' end,SUBSTR(c_vchar,2,3)); --error
create index idx_t_fun_index_001 on t_fun_index_001(SUBSTR(c_vchar,2,3),SUBSTR(c_vchar,2,3)); -error

-- rollback test
DROP TABLE IF EXISTS t_function_index_004;
DROP TABLE IF EXISTS t_function_index_005;
CREATE TABLE t_function_index_004(staff_id INT NOT NULL, staff_name CHAR(50), job VARCHAR(30), bonus NUMBER);
CREATE TABLE t_function_index_005(staff_id INT NOT NULL, staff_name CHAR(50), job VARCHAR(30), bonus NUMBER);
CREATE INDEX idx_function_index_004_001 ON t_function_index_004(case staff_id when 21 then to_char(staff_id) else 999 end,NVL(staff_name,'2020-03-10'),case job when 'tester' then to_char(job) else 'doctor' end);
CREATE INDEX idx_function_index_005_001 ON t_function_index_005(case staff_id when 21 then to_char(staff_id) else 999 end,NVL(staff_name,'2020-03-10'),case job when 'tester' then to_char(job) else 'doctor' end,trim(to_char(bonus),'1'));
INSERT INTO t_function_index_004(staff_id, staff_name, job, bonus) VALUES(23,'wangxia','developer',5000);
INSERT INTO t_function_index_004(staff_id, staff_name, job, bonus) VALUES(24,'limingying','tester',7000);
INSERT INTO t_function_index_004(staff_id, staff_name, job, bonus) VALUES(25,'liulili','quality control',8000);
INSERT INTO t_function_index_004(staff_id, staff_name, job, bonus) VALUES(29,'liuxue','tester',8000);
INSERT INTO t_function_index_004(staff_id, staff_name, job, bonus) VALUES(21,'caoming','document developer',11000);
COMMIT;
INSERT INTO t_function_index_005(staff_id, staff_name, job, bonus) VALUES(23,'wangxia','developer',7000);
INSERT INTO t_function_index_005(staff_id, staff_name, job, bonus) VALUES(27,'wangxuefen','document developer',7000);
INSERT INTO t_function_index_005(staff_id, staff_name, job, bonus) VALUES(28,'denghui','quality control',8000);
INSERT INTO t_function_index_005(staff_id, staff_name, job, bonus) VALUES(25,'liulili','quality control',10000);
INSERT INTO t_function_index_005(staff_id, staff_name, job, bonus) VALUES(21,'caoming','document developer',12000);
COMMIT;
MERGE INTO t_function_index_004 BD1 USING t_function_index_005 NBD1 ON (BD1.staff_id = NBD1.staff_id) WHEN MATCHED THEN UPDATE SET BD1.bonus = NBD1.bonus WHEN NOT MATCHED THEN INSERT (staff_id, staff_name, job, bonus) VALUES (NBD1.staff_id, NBD1.staff_name, NBD1.job, NBD1.bonus);
rollback;

DROP TABLE IF EXISTS tb_func_idx_009;
CREATE TABLE tb_func_idx_009(
COL_2 varchar(20),
COL_3 varchar(20),
COL_4 varchar(20),
COL_6 char(30)
);
insert into tb_func_idx_009 values(19947,446.255,97.02,'@@@abc');
CREATE INDEX idx_func_026 ON tb_func_idx_009(upper(SUBSTR(COL_6,2,3)),TRUNC(COL_3,1),to_char(DECODE(COL_2,10,'正确',12,'错误','unknown')) ,case SUBSTR(COL_4,2,4) when upper(SUBSTR(COL_4,2,3)) then to_char(DECODE(COL_4,10,'正确',12,'错误','unknown')) else 'def' end);

drop table if exists t_fun_index_101;
create table t_fun_index_101(id int,c_int int, constraint t_fun_index_101_con_pri primary key(c_int when c_int then c_int else c_int end)); -- error
create table t_fun_index_101(id int,c_int int, constraint t_fun_index_101_con_pri primary key(id, c_int when c_int then c_int else c_int end)); -- error
create table t_fun_index_101(id int,c_int int, constraint t_fun_index_101_con_pri primary key(upper(id))); -- error

--DTS2020031903511
drop table if exists test_func_index_nvl2;
create table test_func_index_nvl2(id int);
create index ix_nvl2 on test_func_index_nvl2(nvl2(id, 1, 0));
insert into test_func_index_nvl2 values(1);
update test_func_index_nvl2 set id=2;
select * from test_func_index_nvl2 where nvl2(id, 1, 0)=0;
select * from test_func_index_nvl2 where nvl2(id, 1, 0)=1;
update test_func_index_nvl2 set id=2;
select * from test_func_index_nvl2 where nvl2(id, 1, 0)=0;
select * from test_func_index_nvl2 where nvl2(id, 1, 0)=1;
drop table test_func_index_nvl2;

-- DTS2020040308787
drop table if exists t_fun_index_1010;
create table t_fun_index_1010(id int);
create index idx_t_fun_index_1010_100001 on t_fun_index_1010(case when DBE_LOB.SUBSTR('123456',id,1)=SUBSTR('123456',id,1) then id end);
explain select * from t_fun_index_1010 where case when DBE_LOB.SUBSTR('123456',id,1)=SUBSTR('123456',id,1) then id end = 1020;


--DTS20201110035W5TP0G00
drop table if exists func_index_upper;
create table func_index_upper(a varbinary(200), b int);
insert into func_index_upper values('a', 1);
create index func_index_upper_idx_1 on func_index_upper (upper(a));
create index func_index_upper_idx_2 on func_index_upper (a,b);
delete func_index_upper;
drop table func_index_upper;

-- func index only scan test start
drop table if exists func_index_only_scan;
create table func_index_only_scan (c_int int, c_vchar varchar(30), c_num number, c_float float, c_decimal decimal);
insert into func_index_only_scan values (1, 'ABC', 2000, 100.1, 100);
insert into func_index_only_scan values (1, 'def', 2001, 100.2, 300);
insert into func_index_only_scan values (2, 'AkF', 2002, 100.3, 400);
insert into func_index_only_scan values (2, 'ADD', 2004, 100.4, 500);
insert into func_index_only_scan values (3, 'fdj', 2004, 100.5, 600);
insert into func_index_only_scan values (3, 'fdj', 2004, 100.5, 700);
commit;

create index IDX_FUNC_INDEX_ONLY_SCAN_1 on func_index_only_scan(upper(c_vchar), c_int);
create index idx_func_index_only_scan_2 on func_index_only_scan(upper(c_vchar), c_int, c_num, nvl(c_float, 200.0));

-- distinct / index distinct
explain select * from func_index_only_scan where upper(c_vchar) = 'AKF'; -- rowid
explain select upper(c_vchar) from func_index_only_scan where upper(c_vchar) = 'AKF'; -- index only
explain select distinct c_int from func_index_only_scan where upper(c_vchar) = 'AKF' or upper(c_vchar) = 'FDJ'; -- index only
explain select distinct upper(c_vchar) from func_index_only_scan where upper(c_vchar) = 'AKF' or upper(c_vchar) = 'FDJ'; -- index only
explain select count(distinct upper(c_vchar)) from func_index_only_scan where upper(c_vchar) = 'AKF' or upper(c_vchar) = 'FDJ'; -- index only
explain select distinct upper(c_vchar), c_float from func_index_only_scan where upper(c_vchar) = 'AKF' or upper(c_vchar) = 'FDJ'; -- index_1 rowid
explain select distinct c_decimal from func_index_only_scan where upper(c_vchar) = 'AKF' or upper(c_vchar) = 'FDJ'; -- rowid
explain select distinct a from (select distinct upper(c_vchar) a from func_index_only_scan where upper(c_vchar) = 'AKF' or upper(c_vchar) = 'FDJ');
explain select distinct upper(c_vchar), c_int from func_index_only_scan; -- index distinct
explain select distinct upper(c_vchar), c_num from func_index_only_scan; -- hash distinct
explain select distinct c_int, c_num from func_index_only_scan;	-- hash distinct

-- order by / eliminate sort by index
explain select c_int from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by c_vchar; -- rowid
explain select c_vchar from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by c_int; -- rowid
explain select c_int from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by c_int; -- index only
explain select c_int from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by 1; -- index only

explain select c_int from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by upper(c_vchar); -- index only, eliminate sort by index
select c_int from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by upper(c_vchar); -- index only

explain select c_int, upper(c_vchar) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by c_int, upper(c_vchar); -- index only
select c_int, upper(c_vchar) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by c_int, upper(c_vchar); -- index only

explain select c_int, upper(c_vchar) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by 1, 2; -- index only
select c_int, upper(c_vchar) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by 1, 2; -- index only
explain select upper(c_vchar), c_int from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by upper(c_vchar), c_int; -- eliminate sort by index
explain select upper(c_vchar) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by c_int;
select upper(c_vchar) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by c_int;

-- index aggr
explain select max(c_int) from func_index_only_scan where upper(c_vchar) = 'DEF';
explain select min(c_int) from func_index_only_scan where upper(c_vchar) = 'DEF';
explain select max(c_int), min(c_int) from func_index_only_scan where upper(c_vchar) = 'DEF';

-- group by / having
explain select count(*) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' group by c_int; -- index only
explain select c_int, count(c_vchar) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' group by c_int; -- rowid
explain select c_int, count(c_vchar) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' group by c_int, c_vchar; -- rowid
explain select c_int, count(c_vchar) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' group by c_int, upper(c_vchar); -- rowid
explain select c_int, upper(c_vchar) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' group by c_int, upper(c_vchar); -- index only
explain select c_int, upper(c_vchar) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' group by c_int, upper(c_vchar) having c_int in (2) order by 1, 2; -- index only
explain select c_int c1, upper(c_vchar) c2 from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' group by c_int, upper(c_vchar) having c_int in (2) order by c1, c2; -- index only
explain select c_int, upper(c_vchar) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' group by c_int, upper(c_vchar) having upper(c_vchar) = 'ADD' order by 1, 2; -- index only
explain select count(*) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' group by c_num, nvl(c_float, 200.0); -- index only
explain select count(*) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' group by c_num, nvl(c_float, 200.1); -- rowid
explain select sum(c_decimal) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' group by c_num, nvl(c_float, 200.0); -- rowid
explain select to_char(nvl(c_float, 200.0)) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' group by c_num, nvl(c_float, 200.0); -- index only

-- start with / connect by
explain select c_int, c_decimal, sys_connect_by_path(c_int, '->') from func_index_only_scan start with upper(c_vchar) >= 'D' connect by prior c_int = c_decimal / 10; -- rowid
explain select c_int, sys_connect_by_path(c_int, '->') from func_index_only_scan start with upper(c_vchar) >= 'D' connect by prior c_int = c_num; -- index_2 index only

-- winsort, not support index only scan
explain select c_int, avg(c_num) over(partition by c_int) avg from func_index_only_scan where upper(c_vchar) > 'A' and upper(c_vchar) <= 'D'; -- -- rowid
explain select c_int, avg(c_num) over(partition by c_int order by c_decimal) avg from func_index_only_scan where upper(c_vchar) > 'A' and upper(c_vchar) <= 'D'; -- rowid
explain select upper(c_vchar), c_int, avg(c_num) over(partition by c_int order by upper(c_vchar) desc) avg from func_index_only_scan where upper(c_vchar) > 'A' and upper(c_vchar) <= 'D';  -- rowid
select upper(c_vchar), c_int, avg(c_num) over(partition by c_int order by upper(c_vchar) desc) avg from func_index_only_scan where upper(c_vchar) > 'A' and upper(c_vchar) <= 'D'; -- rowid
select upper(c_vchar), c_int, avg(c_num) over(partition by c_int order by upper(c_vchar)) avg from func_index_only_scan where upper(c_vchar) > 'A' and upper(c_vchar) <= 'D'; -- rowid

-- or -> union
alter system set cbo = on;
declare
	count int;
begin
	for count in 1 .. 10000 loop
		insert into func_index_only_scan (c_int, c_vchar) values (count, substr(to_char(uuid()), 1, 30));
	end loop;
	commit;
end;
/

select upper(c_vchar), c_int from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' and (exists (select 1 from sys_dummy where 1 = func_index_only_scan.c_int) or exists (select 1 from sys_dummy where 1 = func_index_only_scan.c_int + 1));

alter system set cbo = off;

-- join
create table func_index_test_tab (f1 int, f2 varchar(30));
insert into func_index_test_tab values (2, 'abc');
insert into func_index_test_tab values (4, 'def');
commit;
explain select /*+use_nl(t1 t2) leading(t2)*/ t1.c_int, t1.c_vchar from func_index_only_scan t1 join func_index_test_tab t2 on t1.c_int = t2.f1 where upper(t1.c_vchar) >= 'A' and upper(t1.c_vchar) <=  'D' order by 1, 2;
explain select /*+use_nl(t1 t2) leading(t2)*/ t1.c_int, upper(t1.c_vchar) from func_index_only_scan t1 join func_index_test_tab t2 on t1.c_int = t2.f1 where upper(t1.c_vchar) >= 'A' and upper(t1.c_vchar) <=  'D' order by 1, 2;
explain select /*+use_hash(t1 t2) leading(t2)*/ t1.c_int, upper(t1.c_vchar) from func_index_only_scan t1 join func_index_test_tab t2 on t1.c_int = t2.f1 where upper(t1.c_vchar) >= 'A' and upper(t1.c_vchar) <=  'D' order by 1, 2;

-- sub-select
explain select t1.a, t1.b from (select c_int a, upper(c_vchar) b from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by c_int) t1 where
 exists (select 1 from func_index_test_tab where upper(f2) = t1.b);  -- index only

explain select t1.a, t1.b from (select c_int a, upper(c_vchar) b, c_decimal c from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by c_int) t1 where
 exists (select 1 from func_index_test_tab where upper(f2) = t1.b and f1 = t1.c);  -- rowid

select t1.a, t1.b from (select c_int a, upper(c_vchar) b from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by c_int) t1 where
 exists (select 1 from func_index_test_tab where upper(f2) = t1.b);	 -- one row
 
explain select f1, f2, (select upper(c_vchar) from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by c_int limit 1) res from func_index_test_tab; -- index only
explain select c_int, (select f2 from func_index_test_tab where upper(f2) = upper(t1.c_vchar) order by f2 limit 1) res from func_index_only_scan t1 order by 1; -- rowid

explain with t1 as (select c_int a, upper(c_vchar) b from func_index_only_scan where upper(c_vchar) >= 'A' and upper(c_vchar) <= 'D' order by c_int)
 select * from func_index_test_tab t2, t1 where upper(t2.f2) = t1.b; -- index only

-- hash mtrl
select t1.c_int, upper(t1.c_vchar) from func_index_only_scan t1 where c_int < (select avg(f1) from func_index_test_tab where upper(f2) = t1.c_vchar);
explain select /*+index(t1 IDX_FUNC_INDEX_ONLY_SCAN_1)*/ t1.c_int, upper(t1.c_vchar) from func_index_only_scan t1 where c_int < (select avg(f1) from func_index_test_tab where upper(f2) = upper(t1.c_vchar)); -- rowid

-- json_value
DROP TABLE IF EXISTS t_school;
CREATE TABLE t_school(id INT NOT NULL, info VARCHAR2(8000) check(info IS JSON));
INSERT INTO t_school VALUES(1, '{"name":"First Primary School", "create_time":"2012-05-08", "classes": [{"name":"class 1", "size":50, "teachers":{"teacher":"Master Zhang", "age":31}}, {"name":"class 2", "size":45, "teachers":{"teacher":"Master Liu", "age":40}}]}');
COMMIT;
CREATE INDEX idx_t_school_info_name ON t_school(JSON_VALUE(info, '$.name'));
EXPLAIN SELECT * FROM T_SCHOOL WHERE JSON_VALUE(info, '$.name') = 'First Primary School'; -- rowid
EXPLAIN SELECT count(*) FROM T_SCHOOL WHERE JSON_VALUE(info, '$.name') = 'First Primary School'; -- index only
explain select case when JSON_VALUE(info, '$.name') = 'class 1' then 0 else 1 end type from t_school where JSON_VALUE(info, '$.name') <= 'class 3' order by 1;

-- parallel
DROP TABLE if exists t_index_only_scan2;
CREATE TABLE t_index_only_scan2(id INT,c_js varchar(150),c_vchar varchar(10),c_int int,c_num number,c_date date,check(c_js is json));
insert into t_index_only_scan2 values(1,'{"ctry":{"pro1":"a0001", "pro2":{"city1":"a0001","city2":"b0001"}, "pro3":["a0001","b0001","c0001"]}}','ctry1',1,1,ADD_MONTHS(to_timestamp('1000-01-01 10:10:10','yyyy-mm-dd hh24:mi:ss'),MOD(1,10000)));
insert into t_index_only_scan2 values(2,'{"ctry":{"pro1":"a0002", "pro2":{"city1":"a0002","city2":"b0002"}, "pro3":["a0002","b0002","c0002"]}}','ctry2',2,2,ADD_MONTHS(to_timestamp('1000-01-01 10:10:10','yyyy-mm-dd hh24:mi:ss'),MOD(2,10000)));
insert into t_index_only_scan2 values(3,'{"ctry":{"pro1":"a0003", "pro2":{"city1":"a0003","city2":"b0003"}, "pro3":["a0003","b0003","c0003"]}}','ctry3',3,3,ADD_MONTHS(to_timestamp('1000-01-01 10:10:10','yyyy-mm-dd hh24:mi:ss'),MOD(3,10000)));
insert into t_index_only_scan2 values(4,'{"ctry":{"pro1":"a0004", "pro2":{"city1":"a0004","city2":"b0004"}, "pro3":["a0004","b0004","c0004"]}}','ctry4',4,4,ADD_MONTHS(to_timestamp('1000-01-01 10:10:10','yyyy-mm-dd hh24:mi:ss'),MOD(4,10000)));
insert into t_index_only_scan2 values(5,'{"ctry":{"pro1":"a0005", "pro2":{"city1":"a0005","city2":"b0005"}, "pro3":["a0005","b0005","c0005"]}}','ctry5',5,5,ADD_MONTHS(to_timestamp('1000-01-01 10:10:10','yyyy-mm-dd hh24:mi:ss'),MOD(5,10000)));
create index idx_t_index_only_scan2_05 on t_index_only_scan2(JSON_VALUE((c_js),'$.ctry.pro1'),SUBSTR(c_vchar,1));
select count(*) from t_index_only_scan2 t1 where JSON_VALUE(c_js,'$.ctry.pro1') <='a0004';
select /*+parallel(8)*/count(*) from t_index_only_scan2 t1 where JSON_VALUE(c_js,'$.ctry.pro1') <='a0004';
explain plan for select /*+parallel(8)*/count(*) from t_index_only_scan2 t1 where JSON_VALUE(c_js,'$.ctry.pro1') <='a0004';
-- merge join not support
create index idx_t_index_only_scan2_001 on t_index_only_scan2(upper(id));
create index idx_t_index_only_scan2_017 on t_index_only_scan2(upper(id+id));
select sum(upper(t1.id+t1.id)) from t_index_only_scan2 t1 full join t_index_only_scan2 t2 on upper(t1.id+t1.id)>upper(t2.id) join t_index_only_scan2 t3 on upper(t1.id+t1.id)>upper(t3.id);
explain select sum(upper(t1.id+t1.id)) from t_index_only_scan2 t1 full join t_index_only_scan2 t2 on upper(t1.id+t1.id)>upper(t2.id) join t_index_only_scan2 t3 on upper(t1.id+t1.id)>upper(t3.id);
-- index group
create index idx_t_index_only_scan2_06 on t_index_only_scan2(UPPER(JSON_VALUE((c_js),'$.ctry.pro1')));
explain select UPPER(JSON_VALUE((c_js),'$.ctry.pro1')) from t_index_only_scan2 group by UPPER(JSON_VALUE((c_js),'$.ctry.pro1'));
explain select count(*) from t_index_only_scan2 group by UPPER(JSON_VALUE((c_js),'$.ctry.pro1'));
explain select group_concat(UPPER(JSON_VALUE((c_js),'$.ctry.pro1')), '-') from t_index_only_scan2 group by UPPER(JSON_VALUE((c_js),'$.ctry.pro1'));
explain select JSON_VALUE(c_js,'$.ctry.pro1') from t_index_only_scan2 group by JSON_VALUE(c_js,'$.ctry.pro1');
select group_concat(UPPER(JSON_VALUE((c_js),'$.ctry.pro1')), '-') from t_index_only_scan2 group by UPPER(JSON_VALUE((c_js),'$.ctry.pro1')) order by 1;

drop table if exists complex_func_index_t;
create table complex_func_index_t(col_1 int, col_2 int);
insert into complex_func_index_t values(1,2);
insert into complex_func_index_t values(100,4);
insert into complex_func_index_t values(200,6);
create index complex_func_index_t_idx on complex_func_index_t(case when col_1 < 100 then 1 when col_1 < 200 then 2 else 3 end);
create index complex_func_index_t_nested_func_idx2 on complex_func_index_t(nvl(to_char(col_1 + 1), '100'));

explain select nvl(to_char(col_1 + 1), '100') as c1 from complex_func_index_t group by nvl(to_char(col_1 + 1), '100');
explain select nvl(to_char(col_1 + 1), '100') as c1 from complex_func_index_t order by c1;
explain select case when col_1 < 100 then 1 when col_1 < 200 then 2 else 3 end as c1 from complex_func_index_t group by case when col_1 < 100 then 1 when col_1 < 200 then 2 else 3 end;
explain select case when col_1 < 100 then 1 when col_1 < 200 then 2 else 3 end as c1 from complex_func_index_t order by 1;
drop table complex_func_index_t;

drop table if exists func_index_t;
create table func_index_t (a int, b int, c varchar(10));

create index func_index1 on func_index_t(upper(c), a);
explain select upper(upper(c)) from func_index_t where upper(c) = 'BC';
explain select reverse(upper(c)) from func_index_t where upper(c) = 'BC' and (a = 6 or a = 10);
explain select upper(nvl(upper(c),b)) from func_index_t where upper(c) = 'BC';
drop index func_index1 on func_index_t;

create index func_index2 on func_index_t(nvl(upper(upper(c)),1));
explain select 1 from  func_index_t where nvl(upper(upper(c)),1) = 1;
drop index func_index2 on func_index_t;

create index func_index3 on func_index_t(nvl(upper(upper(c)),1),upper(upper(c)));
explain select upper(upper(c)) from func_index_t where nvl(upper(upper(c)),1) = 'BC';
drop index func_index3 on func_index_t;

drop table func_index_t;

--reverse function index
drop table if exists test_reverse_func_index;
create table test_reverse_func_index(f1 int, f2 varchar(20), f3 char(10));
insert into test_reverse_func_index values(1,'abc','abc');
insert into test_reverse_func_index values(2,'abd','abd');
commit;
create index temp_idx_001 on test_reverse_func_index(reverse(f2));
create index temp_idx_002 on test_reverse_func_index(reverse(f3));
create index temp_idx_003 on test_reverse_func_index(f1, reverse(f2));
create index temp_idx_004 on test_reverse_func_index(reverse(f3),f1);
--index only
--index fast full scan
explain select reverse(f3) from test_reverse_func_index;
explain select reverse(reverse(f3)) from test_reverse_func_index;
explain select count(distinct reverse(f2)) from test_reverse_func_index;
--index range scan
explain select reverse(f3) from test_reverse_func_index where reverse(f3) = ?;
explain select reverse(f3) from test_reverse_func_index where reverse(f3) = 'cba';
explain select reverse(f2) from test_reverse_func_index where f1 = 1;
explain select reverse(f3) from test_reverse_func_index where reverse(f3) > 'aaa';
explain select reverse(f3) from test_reverse_func_index where reverse(f3) >= 'aaa';
explain select reverse(f3) from test_reverse_func_index where reverse(f3) < 'aaa';
explain select reverse(f3) from test_reverse_func_index where reverse(f3) <= 'aaa';
explain select reverse(f3) from test_reverse_func_index where reverse(f3) between '123' and '789';
explain select reverse(f3) from test_reverse_func_index where reverse(f3) is null;
--concatenation
explain select * from test_reverse_func_index where reverse(f3) = '  0000099999' or reverse(f2) = '9999900000';
explain select * from test_reverse_func_index where reverse(f3) < '  0000099999' or reverse(f2) > '9999900000';
explain select * from test_reverse_func_index where reverse(f3) < '  0001099999' or reverse(f2) > '8999900000';
--union minus
explain select * from test_reverse_func_index where reverse(f3) = '  0000099999' union select * from test_reverse_func_index where reverse(f2) = '9999900000';
explain select * from test_reverse_func_index where reverse(f3) = '  0000099999' union all select * from test_reverse_func_index where reverse(f2) = '9999900000';
explain select * from test_reverse_func_index where reverse(f3) < '  0000099999' minus select * from test_reverse_func_index where reverse(f2) = '9999900000';
--like
explain select * from test_reverse_func_index where reverse(f3) like '  0000%';
explain select * from test_reverse_func_index where reverse(f3) like '  0000_9999_';
explain select count(*) from test_reverse_func_index where reverse(f3) like '  %';
explain select count(*) from test_reverse_func_index where reverse(f3) like '%';
--in
explain select * from test_reverse_func_index where reverse(f2) in ('9999900000','8999910000','7999920000','6999930000','5999940000','9899901000','8899911000','7899921000','6899931000','5899941000');
explain select * from test_reverse_func_index where reverse(f2) in (select rtrim(reverse(f3)) from test_reverse_func_index where f1 < 20);
explain select * from test_reverse_func_index where reverse(f2) in (select rtrim(f3) from test_reverse_func_index where f1 < 20);
explain select * from test_reverse_func_index where reverse(f2) in (select reverse(f2) from test_reverse_func_index where f1 < 20) and f1 in (select f1 from test_reverse_func_index where f1 < 20);
explain select * from test_reverse_func_index where reverse(f2) in (select reverse(f2) from test_reverse_func_index where f1 < 20) or f1 in (select f1 from test_reverse_func_index where f1 < 20);
explain select * from test_reverse_func_index where reverse(f2) in (select reverse(f2) from test_reverse_func_index where f1 < 20) or f1 in (select f1 from test_reverse_func_index where f1 > 3000);
explain select * from test_reverse_func_index where reverse(f2) in (select reverse(f2) from test_reverse_func_index where f1 < 110) and f1 in (select f1 from test_reverse_func_index where f1 < 110);
--index order by
explain select reverse(f3) from test_reverse_func_index order by 1;
explain select reverse(f3) from test_reverse_func_index order by 1 desc;
--index rowid
explain select f3 from test_reverse_func_index where reverse(f3) = ?;
explain select reverse(f3) from test_reverse_func_index where f1 = 1;
--index aggr
explain select max(f1) from test_reverse_func_index where reverse(f3) between 'a' and 'z';
explain select max(f1) from test_reverse_func_index where reverse(f3) = '       cba';
explain select /*+index(test_reverse_func_index temp_idx_004)*/ max(f1) from test_reverse_func_index where reverse(f3) = '       cba';
explain select min(reverse(f2)) from test_reverse_func_index where f1 = 2;
explain select max(reverse(f2)) from test_reverse_func_index;
explain select min(reverse(f3)) from test_reverse_func_index;
explain select min(reverse(f3)), max(reverse(f3)) from test_reverse_func_index;
--index group by
explain select max(f1) from test_reverse_func_index where reverse(f3) between 'a' and 'z' group by reverse(f3);
explain select max(f1) from test_reverse_func_index where reverse(f3) = '       cba' group by reverse(f3);
explain select /*+index(test_reverse_func_index temp_idx_004)*/ max(f1) from test_reverse_func_index where reverse(f3) = '       cba' group by reverse(f3);
explain select min(reverse(f2)) from test_reverse_func_index where f1 = 2 group by f1;
explain select reverse(f2) from test_reverse_func_index group by reverse(f2);
--having
explain select max(f1) from test_reverse_func_index where reverse(f3) between 'a' and 'z' group by reverse(f3) having count(1) = 1;
explain select max(f1) from test_reverse_func_index where reverse(f3) between 'a' and 'z' group by reverse(f3) having count(reverse(f3)) = 1;
explain select /*+index(test_reverse_func_index temp_idx_004)*/ max(f1) from test_reverse_func_index where reverse(f3) between 'a' and 'z' group by reverse(f3) having count(reverse(f3)) = 1;
explain select max(f1) from test_reverse_func_index where reverse(f3) between 'a' and 'z' group by reverse(f3) having count(reverse(f2)) = 1;
--index distinct
explain select distinct reverse(f2) from test_reverse_func_index;
explain select distinct f1,reverse(f2) from test_reverse_func_index;
explain select distinct reverse(f2) from test_reverse_func_index where f1 = 1;
--hash distinct + index range scan
explain select distinct reverse(f2) from test_reverse_func_index where f1 > 0;
--connect by
explain select sys_connect_by_path(f1,'/') from test_reverse_func_index start with f1 = 1 connect by reverse(prior f3) > reverse(f3);
explain select sys_connect_by_path(f1,'/') from test_reverse_func_index start with f1 = 1 connect by reverse(prior f3) > reverse(f3) order siblings by 1;
--winsort
explain select row_number() over (partition by f1 order by reverse(f3)) from test_reverse_func_index;
explain select max(reverse(f3)) over (partition by f1 order by reverse(f3)) from test_reverse_func_index;
explain select /*+index(test_reverse_func_index temp_idx_004)*/ max(reverse(f3)) over (partition by f1 order by reverse(f3)) from test_reverse_func_index;
--parallel
explain select /*+parallel(2)*/ reverse(f3) from test_reverse_func_index;
explain select /*+parallel(2)*/ reverse(f2) from test_reverse_func_index group by reverse(f2);
drop table if exists test_reverse_func_index2;
create table test_reverse_func_index2(f1 int, f2 varchar(20), f3 char(10));
insert into test_reverse_func_index2 values(1,'abc','abc');
insert into test_reverse_func_index2 values(2,'abd','abd');
commit;
create unique index temp_idx_103 on test_reverse_func_index2(f1, reverse(f2));
explain select /*+index(test_reverse_func_index2 temp_idx_103)*/ * from test_reverse_func_index2 where reverse(f2) = 'cba';
--index unique scan
explain select * from test_reverse_func_index2 where reverse(f2) = 'cba' and f1 = 1;
--join
explain select * from test_reverse_func_index a join test_reverse_func_index2 b on reverse(a.f2) = b.f1;
explain select /*+leading(b)*/ * from test_reverse_func_index a join test_reverse_func_index2 b on reverse(a.f2) = b.f1;
explain select * from test_reverse_func_index2 b join test_reverse_func_index a on reverse(a.f2) = b.f1;
explain select * from test_reverse_func_index a join test_reverse_func_index b on reverse(a.f2) = reverse(b.f2) where reverse(a.f2) = 'cba';
explain select * from test_reverse_func_index a join test_reverse_func_index b on reverse(a.f2) = reverse(b.f2) where a.f1 = 1;
explain select * from test_reverse_func_index a left join test_reverse_func_index b on reverse(a.f2) = reverse(b.f2) where reverse(a.f2) = 'cba';
explain select * from test_reverse_func_index a left join test_reverse_func_index b on reverse(a.f2) = reverse(b.f2) where a.f1 = 1;
explain select * from test_reverse_func_index a right join test_reverse_func_index b on reverse(a.f2) = reverse(b.f2) where reverse(a.f2) = 'cba';
explain select * from test_reverse_func_index a right join test_reverse_func_index b on reverse(a.f2) = reverse(b.f2) where a.f1 = 1;
explain select * from test_reverse_func_index a full join test_reverse_func_index b on reverse(a.f2) = reverse(b.f2) where reverse(a.f2) = 'cba';
explain select * from test_reverse_func_index a full join test_reverse_func_index b on reverse(a.f2) = reverse(b.f2) where a.f1 = 1;
explain select * from test_reverse_func_index a cross join test_reverse_func_index b where reverse(a.f2) = reverse(b.f2) and reverse(a.f2) = 'cba';
explain select * from test_reverse_func_index a cross join test_reverse_func_index b where reverse(a.f2) = reverse(b.f2) and a.f1 = 1;
explain select * from test_reverse_func_index a , test_reverse_func_index b where reverse(a.f2) = reverse(b.f2) and reverse(a.f2) = 'cba';
explain select * from test_reverse_func_index a , test_reverse_func_index b where reverse(a.f2) = reverse(b.f2) and a.f1 = 1;
--hint
explain select /*+no_index(test_reverse_func_index temp_idx_001)*/ * from test_reverse_func_index where reverse(f2) = 'cba';
explain select /*+no_index(test_reverse_func_index temp_idx_001)*/ * from test_reverse_func_index where reverse(f2) = 'cba';
delete from test_reverse_func_index;
insert into test_reverse_func_index values(1,'123','cba'),(2,'223','cba');
explain select /*+index_asc(test_reverse_func_index temp_idx_001)*/ * from test_reverse_func_index where reverse(f2) = 'cba';
explain select /*+index_desc(test_reverse_func_index temp_idx_001)*/ * from test_reverse_func_index where reverse(f2) = 'cba';
select /*+index_asc(test_reverse_func_index temp_idx_001)*/ * from test_reverse_func_index where reverse(f2) like '32_';
select /*+index_desc(test_reverse_func_index temp_idx_001)*/ * from test_reverse_func_index where reverse(f2) like '32_';
explain select /*+index_ffs(test_reverse_func_index temp_idx_001)*/ * from test_reverse_func_index where reverse(f2) = 'cba';
explain select /*+index_ffs(test_reverse_func_index temp_idx_001)*/ count(*) from test_reverse_func_index;
explain select /*+no_index_ffs(test_reverse_func_index temp_idx_001)*/ count(*) from test_reverse_func_index;
explain select /*+index_ffs(test_reverse_func_index temp_idx_001)*/ * from test_reverse_func_index;
create index upper_idx_001_002 on test_reverse_func_index(upper(f2));
explain select /*+index_ffs(test_reverse_func_index upper_idx_001_002)*/ * from test_reverse_func_index where reverse(f2) = 'cba';
explain select /*+index_ffs(test_reverse_func_index upper_idx_001_002)*/ * from test_reverse_func_index;
--table type
drop table if exists temp_test_reverse_func_index;
create global temporary table temp_test_reverse_func_index(f1 int, f2 varchar(400)) ON COMMIT preserve ROWS;
create index temp_test_reverse_func_index_idx_001 on temp_test_reverse_func_index(reverse(f2));
insert into temp_test_reverse_func_index values(1, '123'), (3, '456'), (5, '789');
explain select * from temp_test_reverse_func_index where reverse(f2) = '456';
explain with temp as (select * from test_reverse_func_index where reverse(f2) = 'cba') select * from temp;
explain with temp as (select * from test_reverse_func_index) select * from temp where reverse(f2) = 'cba';
create or replace view view_test_reverse_func_index as select * from test_reverse_func_index where reverse(f2) = 'cba';
explain select * from view_test_reverse_func_index;
drop view view_test_reverse_func_index;
drop table temp_test_reverse_func_index;
drop table test_reverse_func_index;
drop table test_reverse_func_index2;

--origin sql
drop table if exists CPS_SIM_DEVICE;
create table CPS_SIM_DEVICE (
  DEVICE_ID                        NUMBER(18) NOT NULL,
  MSISDN                           VARCHAR2(18) NOT NULL,
  IMSI                             VARCHAR2(64),
  IDENTITY_TYPE                    VARCHAR2(4) NOT NULL,
  IDENTITY_ID                      NUMBER(18) NOT NULL,
  STATUS                           VARCHAR2(2),
  DEVICE_TYPE                      CHAR NOT NULL,
  CREATE_TIME                      TIMESTAMP,
  PIN_KEY                          VARCHAR2(1024),
  STK_SIM_KEYT                     NUMBER(16),
  ICCID                            VARCHAR2(32),
  STK_APP_VERSION                  NUMBER(32),
  LOAD_DATA_TS                     TIMESTAMP
);
create unique index IX_SIM_DEVICE_MSISDN2 on CPS_SIM_DEVICE (MSISDN ASC);
create index IDX_CPS_SIM_DEVICE_3 on CPS_SIM_DEVICE (REVERSE(MSISDN) ASC);
create index IDX_SIM_DEVICE_ICCID on CPS_SIM_DEVICE (ICCID ASC);
alter table CPS_SIM_DEVICE add constraint PK_CPS_SIM_DEVICE primary key (DEVICE_ID);
explain SELECT * FROM (SELECT T.IDENTITY_ID, T.MSISDN FROM CPS_SIM_DEVICE T WHERE T.IDENTITY_TYPE ='1000'AND REVERSE(T.MSISDN) LIKE REVERSE('%959456219258') ORDER BY T.MSISDN) WHERE 1=1 AND ROWNUM<= 10;
drop table CPS_SIM_DEVICE;

--ddl
drop table if exists test_reverse_func_index;
create table test_reverse_func_index(f1 int, f2 varchar(20), f3 char(10));
create index rev_temp_idx_001 on test_reverse_func_index(reverse(f2)) asc;
create index rev_temp_idx_002 on test_reverse_func_index(reverse(f1)) dsc;
create index rev_temp_idx_003 on test_reverse_func_index(reverse(f1), reverse(f2));
create index rev_temp_idx_004 on test_reverse_func_index(reverse(f3), reverse(f2));
create index rev_temp_idx_005 on test_reverse_func_index(f1, reverse(f2)) reverse;
create index rev_temp_idx_006 on test_reverse_func_index(reverse(f2)) reverse;
drop index rev_temp_idx_005 on test_reverse_func_index;
drop index rev_temp_idx_006 on test_reverse_func_index;
drop index rev_temp_idx_001 on test_reverse_func_index;
drop index rev_temp_idx_004 on test_reverse_func_index;
create index rev_temp_idx_005 on test_reverse_func_index(f1, reverse(f2));
create unique index rev_temp_idx_007 on test_reverse_func_index(reverse(f2)) online;
create unique index rev_temp_idx_008 on test_reverse_func_index(reverse(f2)) reverse;
create unique index rev_temp_idx_009 on test_reverse_func_index(reverse('aaa'));
create index rev_temp_idx_100 on test_reverse_func_index(reverse(reverse(f2)));
create index rev_temp_idx_101 on test_reverse_func_index(upper(reverse(f2)));
create index if not exists index rev_temp_idx_007 on test_reverse_func_index(reverse(f2));
create index if not exists index rev_temp_idx_107 on test_reverse_func_index(reverse(f2));
alter table test_reverse_func_index add constraint pk_111101 primary key (f1) using index rev_temp_idx_005;
alter table test_reverse_func_index add constraint pk_111101 primary key (reverse(f2)) using index rev_temp_idx_007;
explain select * from test_reverse_func_index where reverse(reverse(f2))=?;
--alter index
alter index rev_temp_idx_007 on test_reverse_func_index rebuild;
alter index rev_temp_idx_007 on test_reverse_func_index rebuild online;
alter index rev_temp_idx_007 on test_reverse_func_index rebuild online parallel 2;
alter index rev_temp_idx_007 on test_reverse_func_index rebuild parallel 2;
alter index rev_temp_idx_007 on test_reverse_func_index rename to rev_temp_idx_009;
drop table test_reverse_func_index;

--datatype
create table test_reverse_func_index(f1 bigint, f2 binary(10), f3 binary_bigint, f4 binary_double, f5 binary_float, f6 binary_integer, f7 binary_uint32, f8 blob, f9 bool, f10 boolean, f11 bpchar, f12 bytea, f13 char, f14 character, f15 clob, f16 date, f17 datetime, f18 decimal, f19 double, f20 float, f21 image, f23 int, f24 integer, f25 interval year to month, f26 long, f27 longblob, f28 longtext, f29 mediumblob, f30 nchar, f31 number, f32 numeric, f33 nvarchar(10), f34 nvarchar2(10), f35 raw(10), f36 real, f37 serial primary key, f38 short, f39 smallint, f40 text, f41 timestamp, f42 tinyint, f43 interval day to second, f44 uint, f45 uinteger, f46 ushort, f47 usmallint, f48 utinyint, f49 varbinary(10), f50 varchar(10), f51 varchar2(10));
create index rev_temp_idx_001 on test_reverse_func_index(reverse(f1));
create index rev_temp_idx_002 on test_reverse_func_index(reverse(f2));
create index rev_temp_idx_003 on test_reverse_func_index(reverse(f3));
create index rev_temp_idx_004 on test_reverse_func_index(reverse(f4));
create index rev_temp_idx_005 on test_reverse_func_index(reverse(f5));
create index rev_temp_idx_006 on test_reverse_func_index(reverse(f6));
create index rev_temp_idx_007 on test_reverse_func_index(reverse(f7));
create index rev_temp_idx_008 on test_reverse_func_index(reverse(f8));
create index rev_temp_idx_009 on test_reverse_func_index(reverse(f9));
create index rev_temp_idx_010 on test_reverse_func_index(reverse(f10));
create index rev_temp_idx_011 on test_reverse_func_index(reverse(f11));
create index rev_temp_idx_012 on test_reverse_func_index(reverse(f12));
create index rev_temp_idx_013 on test_reverse_func_index(reverse(f13));
create index rev_temp_idx_014 on test_reverse_func_index(reverse(f14));
create index rev_temp_idx_015 on test_reverse_func_index(reverse(f15));
create index rev_temp_idx_016 on test_reverse_func_index(reverse(f16));
create index rev_temp_idx_017 on test_reverse_func_index(reverse(f17));
create index rev_temp_idx_018 on test_reverse_func_index(reverse(f18));
create index rev_temp_idx_019 on test_reverse_func_index(reverse(f19));
create index rev_temp_idx_020 on test_reverse_func_index(reverse(f20));
create index rev_temp_idx_021 on test_reverse_func_index(reverse(f21));
create index rev_temp_idx_022 on test_reverse_func_index(reverse(f22));
create index rev_temp_idx_023 on test_reverse_func_index(reverse(f23));
create index rev_temp_idx_024 on test_reverse_func_index(reverse(f24));
create index rev_temp_idx_025 on test_reverse_func_index(reverse(f25));
create index rev_temp_idx_026 on test_reverse_func_index(reverse(f26));
create index rev_temp_idx_027 on test_reverse_func_index(reverse(f27));
create index rev_temp_idx_028 on test_reverse_func_index(reverse(f28));
create index rev_temp_idx_029 on test_reverse_func_index(reverse(f29));
create index rev_temp_idx_030 on test_reverse_func_index(reverse(f30));
create index rev_temp_idx_031 on test_reverse_func_index(reverse(f31));
create index rev_temp_idx_032 on test_reverse_func_index(reverse(f32));
create index rev_temp_idx_033 on test_reverse_func_index(reverse(f33));
create index rev_temp_idx_034 on test_reverse_func_index(reverse(f34));
create index rev_temp_idx_035 on test_reverse_func_index(reverse(f35));
create index rev_temp_idx_036 on test_reverse_func_index(reverse(f36));
create index rev_temp_idx_037 on test_reverse_func_index(reverse(f37));
create index rev_temp_idx_038 on test_reverse_func_index(reverse(f38));
create index rev_temp_idx_039 on test_reverse_func_index(reverse(f39));
create index rev_temp_idx_040 on test_reverse_func_index(reverse(f40));
create index rev_temp_idx_041 on test_reverse_func_index(reverse(f41));
create index rev_temp_idx_042 on test_reverse_func_index(reverse(f42));
create index rev_temp_idx_043 on test_reverse_func_index(reverse(f43));
create index rev_temp_idx_044 on test_reverse_func_index(reverse(f44));
create index rev_temp_idx_045 on test_reverse_func_index(reverse(f45));
create index rev_temp_idx_046 on test_reverse_func_index(reverse(f46));
create index rev_temp_idx_047 on test_reverse_func_index(reverse(f47));
create index rev_temp_idx_048 on test_reverse_func_index(reverse(f48));
create index rev_temp_idx_049 on test_reverse_func_index(reverse(f49));
create index rev_temp_idx_050 on test_reverse_func_index(reverse(f50));
create index rev_temp_idx_051 on test_reverse_func_index(reverse(f51));
drop table test_reverse_func_index;

--PARTITION
create table test_reverse_func_index(f1 varchar(10), f2 varchar(10), f3 varchar(10)) partition by range (f1) (partition p1 values less than ('10'), partition p2 values less than (maxvalue));
create unique index rev_temp_idx_001 on test_reverse_func_index(reverse(f1)) local;
create index rev_temp_idx_101 on test_reverse_func_index(reverse(dbe_lob.substr('123456',1) || f1)) local;
create index rev_temp_idx_001 on test_reverse_func_index(reverse(f1));
create index rev_temp_idx_002 on test_reverse_func_index(reverse(f2));
create index rev_temp_idx_003 on test_reverse_func_index(reverse(f3)) local;
explain select * from test_reverse_func_index where reverse(f3) = ?;
explain select * from test_reverse_func_index where reverse(f2) = ?;
explain select * from test_reverse_func_index partition(p1) where reverse(f3) = ?;
explain select * from test_reverse_func_index partition(p1) where reverse(f2) = ?;
explain select * from test_reverse_func_index where reverse(f1) = ?;
alter index rev_temp_idx_002 on test_reverse_func_index modify partition p1 initrans 2;
alter index rev_temp_idx_003 on test_reverse_func_index modify partition p1 initrans 2;
alter index rev_temp_idx_003 on test_reverse_func_index modify partition p1 coalesce;
alter index rev_temp_idx_003 on test_reverse_func_index modify partition p1 unusable;
explain select * from test_reverse_func_index where reverse(f3) = ?;
alter table test_reverse_func_index modify f2 varchar(5);
alter table test_reverse_func_index modify f2 char(10);
alter table test_reverse_func_index modify f2 varchar(10);
insert into test_reverse_func_index values ('aaa','aaa','aaa');
alter table test_reverse_func_index modify f2 varchar(20);
alter table test_reverse_func_index modify f2 varchar(5);
alter table test_reverse_func_index modify f2 char(20);
select * from test_reverse_func_index where f2 = 'aaa';
drop table test_reverse_func_index;
--subpartition
create table test_reverse_func_index(f1 varchar(10), f2 varchar(10), f3 varchar(10)) partition by range (f1) subpartition by range (f2) (partition p1 values less than ('10') (subpartition p11 values less than('123'), subpartition p12 values less than('789')), partition p2 values less than (maxvalue)(subpartition p21 values less than('123'), subpartition p22 values less than('789')));
create index rev_temp_idx_001 on test_reverse_func_index(reverse(f1));
create index rev_temp_idx_002 on test_reverse_func_index(reverse(f2));
create index rev_temp_idx_003 on test_reverse_func_index(reverse(f3)) local;
explain select * from test_reverse_func_index where reverse(f3) = ?;
explain select * from test_reverse_func_index where reverse(f2) = ?;
explain select * from test_reverse_func_index partition(p1) where reverse(f3) = ?;
explain select * from test_reverse_func_index partition(p1) where reverse(f2) = ?;
explain select * from test_reverse_func_index where reverse(f1) = ?;
alter index rev_temp_idx_002 on test_reverse_func_index modify partition p1 initrans 2;
alter index rev_temp_idx_003 on test_reverse_func_index modify partition p1 initrans 2;
alter index rev_temp_idx_003 on test_reverse_func_index modify partition p1 coalesce;
alter index rev_temp_idx_003 on test_reverse_func_index modify partition p1 unusable;
alter table test_reverse_func_index modify f2 varchar(5);
alter index rev_temp_idx_002 on test_reverse_func_index modify subpartition p21 initrans 2;
alter index rev_temp_idx_003 on test_reverse_func_index modify subpartition p21 initrans 2;
alter index rev_temp_idx_003 on test_reverse_func_index modify subpartition p21 coalesce;
alter index rev_temp_idx_003 on test_reverse_func_index modify subpartition p21 unusable;
drop table test_reverse_func_index;
--dts
create table test_reverse_func_index(f1 varchar(20));
insert into test_reverse_func_index values('123');
create index idx_test_reverse_func_index_001 on test_reverse_func_index(reverse(f1));
explain select * from test_reverse_func_index a join test_reverse_func_index b on reverse(a.f1) > reverse(b.f1);
insert into test_reverse_func_index select * from test_reverse_func_index ON DUPLICATE KEY UPDATE f1 = reverse(f1);
drop table test_reverse_func_index;