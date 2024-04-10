DROP TABLE IF EXISTS T_ORDERBY_1;
CREATE TABLE T_ORDERBY_1 (F_INT1 INT, F_INT2 INT, F_CHAR CHAR(16), F_DATE DATE);

--ERROR
select array[1,2] from dual ORDER BY 1;
SELECT F_INT1 AS '' FROM T_ORDERBY_1;
SELECT F_INT1 FROM T_ORDERBY_1 null;
SELECT F_INT1 FROM T_ORDERBY_1 ORDER BY 0;
SELECT F_INT1 FROM T_ORDERBY_1 ORDER BY 2;
SELECT F_INT1 F1, F_INT2 F1 FROM T_ORDERBY_1 ORDER BY F1;
SELECT * FROM T_ORDERBY_1 ORDER BY MIN(F_INT1);

--EMPTY RECORD
SELECT * FROM T_ORDERBY_1 ORDER BY F_INT1,F_INT2;
SELECT * FROM T_ORDERBY_1 ORDER BY F_CHAR,F_INT2;
SELECT * FROM T_ORDERBY_1 ORDER BY F_DATE DESC;
SELECT * FROM T_ORDERBY_1 ORDER BY F_INT1 DESC,F_DATE;
SELECT * FROM T_ORDERBY_1 ORDER BY NULL;

INSERT INTO T_ORDERBY_1 VALUES(1,2,'A','2017-12-11 14:08:00');
INSERT INTO T_ORDERBY_1 VALUES(3,4,'C','2017-12-12 16:08:00');
INSERT INTO T_ORDERBY_1 VALUES(1,3,'A','2017-12-11 14:18:00');
INSERT INTO T_ORDERBY_1 VALUES(2,3,'B','2017-12-11 16:08:00');
COMMIT;

SELECT SUM(F_INT1) F1 FROM T_ORDERBY_1 ORDER BY MIN(F_INT1);
SELECT COUNT(1) F1 FROM T_ORDERBY_1 ORDER BY F_INT1;

SELECT * FROM T_ORDERBY_1 ORDER BY F_INT1,F_INT2;
SELECT * FROM T_ORDERBY_1 ORDER BY F_CHAR,F_INT2;
SELECT * FROM T_ORDERBY_1 ORDER BY F_DATE DESC;
SELECT * FROM T_ORDERBY_1 ORDER BY F_INT1 DESC,F_DATE;
SELECT tt.f_date, tt.f_int1 from ( SELECT F_INT1,F_DATE FROM T_ORDERBY_1 WHERE F_INT1 = 1 ORDER BY F_INT1,F_INT2 LIMIT 1,1) TT;
SELECT DISTINCT A.F_INT1 AS COL1 FROM T_ORDERBY_1 A ORDER BY COL1;

SELECT F_INT1+10 FROM T_ORDERBY_1 ORDER BY F_INT1+10;
SELECT F_INT1+10 FROM T_ORDERBY_1 ORDER BY 1;
SELECT F_INT1 F1 FROM T_ORDERBY_1 ORDER BY F1;
SELECT F_INT1 "F1" FROM T_ORDERBY_1 ORDER BY F1;
SELECT F_INT1 "1" FROM T_ORDERBY_1 ORDER BY "1";
SELECT F_INT1 "1" FROM T_ORDERBY_1 ORDER BY 1;
SELECT F_INT1 FROM T_ORDERBY_1 ORDER BY 1;
SELECT F_INT1 AS F1 FROM T_ORDERBY_1 ORDER BY F1;
SELECT F_INT1 AS "F1" FROM T_ORDERBY_1 ORDER BY F1;
SELECT F_INT1 AS "1F" FROM T_ORDERBY_1 ORDER BY "1F";
SELECT F_INT1 AS F1 FROM T_ORDERBY_1 T1 ORDER BY F1;
SELECT F_INT1 AS F1 FROM T_ORDERBY_1 T1 GROUP BY F_INT1 ORDER BY F1;
SELECT F_INT1+10 AS F1 FROM T_ORDERBY_1 T1 GROUP BY F_INT1+10 ORDER BY F1;
SELECT F_INT1+10 AS "1F" FROM T_ORDERBY_1 T1 GROUP BY F_INT1+10 ORDER BY "1F";
SELECT F_INT2 F2,F_INT1 F1,F_DATE F4,F_CHAR F3 FROM T_ORDERBY_1 ORDER BY F3,F4,F2,F1;
SELECT F_INT2 F2,F_INT1 F1,F_DATE F4,F_CHAR F3 FROM T_ORDERBY_1 ORDER BY 4,3,1,2;
SELECT F_INT2 F2,F_INT1 F1,F_DATE F4,F_CHAR F3 FROM T_ORDERBY_1 ORDER BY 4 DESC,3,1 DESC,2;

SELECT F_INT1 F1 FROM T_ORDERBY_1 ORDER BY T_ORDERBY_1.F_INT1;
SELECT F_INT1 AS F1 FROM T_ORDERBY_1 ORDER BY T_ORDERBY_1.F_INT1;
SELECT F_INT1 AS F1 FROM T_ORDERBY_1 T1 ORDER BY T1.F_INT1;
SELECT F_INT1 AS F1 FROM T_ORDERBY_1 T1 GROUP BY F_INT1 ORDER BY T1.F_INT1;
SELECT F_INT1 AS F1 FROM T_ORDERBY_1 T1 WHERE T1.f_int1 > 1 GROUP BY t1.F_INT1 ORDER BY T1.F_INT1;
SELECT F_INT2 F2,F_INT1 F1,F_DATE F4,F_CHAR F3 FROM T_ORDERBY_1 ORDER BY F3,T_ORDERBY_1.F_DATE,F2,F1;

SELECT F1 FROM (SELECT F_INT1 F1 FROM T_ORDERBY_1) T_SUB where F1 > 1 order by F1;
SELECT T_SUB.F1 FROM (SELECT F_INT1 F1 FROM T_ORDERBY_1) T_SUB where T_SUB.F1 > 1 order by T_SUB.F1;

SELECT F_INT2 FROM T_ORDERBY_1 WHERE F_CHAR = 'A' ORDER BY F_INT2 DESC;
SELECT F_INT2 FROM T_ORDERBY_1 WHERE F_CHAR = 'a' ORDER BY F_INT2 DESC;
SELECT F_INT1,F_INT2 FROM T_ORDERBY_1 WHERE (F_INT1) IN (SELECT F_INT1 FROM T_ORDERBY_1) ORDER BY F_INT1,F_INT2;
SELECT F_INT1,F_INT2 FROM T_ORDERBY_1 WHERE (F_INT1,F_INT2) IN (SELECT F_INT1+1,F_INT2+1 FROM T_ORDERBY_1) ORDER BY F_INT1,F_INT2;
SELECT F_INT1,F_INT2 FROM T_ORDERBY_1 WHERE (F_INT1) = (SELECT MAX(F_INT1) FROM T_ORDERBY_1);

SELECT * FROM T_ORDERBY_1 ORDER BY (CASE WHEN NULL THEN F_INT2 END);
SELECT * FROM T_ORDERBY_1 ORDER BY (CASE WHEN F_INT1 > F_INT2 THEN F_INT2 END);
SELECT * FROM T_ORDERBY_1 ORDER BY (CASE WHEN F_INT1 > F_INT2 THEN F_INT2 ELSE F_INT1 END);
SELECT * FROM T_ORDERBY_1 ORDER BY (CASE WHEN F_INT1 > F_INT2 THEN F_INT2 ELSE F_INT1 END) DESC;
SELECT * FROM T_ORDERBY_1 ORDER BY (CASE WHEN F_INT1 > F_INT2 AND F_INT2 > 0 THEN F_INT2 END);
SELECT * FROM T_ORDERBY_1 ORDER BY (CASE WHEN NOT F_INT1 > F_INT2 THEN F_INT2 END);
SELECT * FROM T_ORDERBY_1 ORDER BY (CASE F_INT1 - F_INT2 WHEN F_INT1 THEN F_INT2 END);
SELECT * FROM T_ORDERBY_1 ORDER BY (CASE F_INT1 - F_INT2 WHEN F_INT1 THEN F_INT2 ELSE F_INT1 END);
SELECT * FROM T_ORDERBY_1 ORDER BY (CASE F_INT1 - F_INT2 WHEN F_INT1 THEN F_INT2 ELSE F_INT1 END) DESC;

--T_ORDERBY_2
DROP TABLE IF EXISTS T_ORDERBY_2;
CREATE TABLE T_ORDERBY_2 (F_INT1 INT, F_INT2 INT, F_CHAR CHAR(16), F_DATE DATE);

INSERT INTO T_ORDERBY_2 VALUES(1,2,'A','2017-12-11 14:08:00');
INSERT INTO T_ORDERBY_2 VALUES(3,4,'C','2017-12-12 16:08:00');
INSERT INTO T_ORDERBY_2 VALUES(1,3,'A','2017-12-11 14:18:00');
INSERT INTO T_ORDERBY_2 VALUES(2,3,'B','2017-12-11 16:08:00');
INSERT INTO T_ORDERBY_2 VALUES(NULL,3,'B','2017-12-11 16:08:00');
INSERT INTO T_ORDERBY_2 VALUES(NULL,4,'B','2017-12-11 16:08:00');
COMMIT;

SELECT * FROM T_ORDERBY_2 ORDER BY F_INT1,F_INT2 DESC;

CREATE INDEX IND_ORDERBY_2_1 ON T_ORDERBY_2(F_INT1);
CREATE INDEX IND_ORDERBY_2_2 ON T_ORDERBY_2(F_INT2, F_CHAR);

EXPLAIN PLAN FOR SELECT * FROM T_ORDERBY_2 WHERE F_INT1 > 0 ORDER BY F_INT1;
SELECT * FROM T_ORDERBY_2 WHERE F_INT1 > 0 ORDER BY F_INT1;
EXPLAIN PLAN FOR SELECT * FROM T_ORDERBY_2 WHERE F_INT1 > 0 ORDER BY F_INT1 DESC;
SELECT * FROM T_ORDERBY_2 WHERE F_INT1 > 0 ORDER BY F_INT1 DESC;
EXPLAIN PLAN FOR SELECT * FROM T_ORDERBY_2 WHERE F_INT2 > 0 ORDER BY F_INT2, F_CHAR;
SELECT * FROM T_ORDERBY_2 WHERE F_INT2 > 0 ORDER BY F_INT2, F_CHAR;
EXPLAIN PLAN FOR SELECT * FROM T_ORDERBY_2 WHERE F_INT2 > 0 ORDER BY F_INT2 DESC, F_CHAR DESC;
SELECT * FROM T_ORDERBY_2 WHERE F_INT2 > 0 ORDER BY F_INT2 DESC, F_CHAR DESC;
EXPLAIN PLAN FOR SELECT * FROM T_ORDERBY_2 WHERE F_INT2 > 0 ORDER BY F_INT2, F_CHAR DESC;
SELECT * FROM T_ORDERBY_2 WHERE F_INT2 > 0 ORDER BY F_INT2, F_CHAR DESC;
--DTS2018101003805
SELECT I.F_INT2 AS F_INT1, F_INT1 FROM T_ORDERBY_2 I GROUP BY I.F_INT1, I.F_INT2 ORDER BY F_INT1;
SELECT DISTINCT F_INT1, F_INT2 AS F_INT1 FROM T_ORDERBY_2 ORDER BY F_INT1;
SELECT DISTINCT F_INT1+1 AS F_INT2, F_INT2 FROM T_ORDERBY_2 ORDER BY F_INT2;

DROP TABLE IF EXISTS T_ORDERBY_3;
CREATE TABLE T_ORDERBY_3 (F_INT1 INT, F_INT2 INT);
insert into T_ORDERBY_3 values(4,3),(3,1),(5,2),(1,4);
select * from T_ORDERBY_3 order by 1;
select * from T_ORDERBY_3 order by 1.3;
select * from T_ORDERBY_3 order by 1.8;
select * from T_ORDERBY_3 order by 2.2;
select * from T_ORDERBY_3 order by 0;
select * from T_ORDERBY_3 order by -0;
select * from T_ORDERBY_3 order by 0.5;
select * from T_ORDERBY_3 order by -1.5;
select * from T_ORDERBY_3 order by '1';
select * from T_ORDERBY_3 order by 'aa';

select count(1) as m from T_ORDERBY_1 union all select count(1) as m from T_ORDERBY_2 order by m ;
select count(1) as m from T_ORDERBY_1 union all select count(1) as m from T_ORDERBY_2 order by m desc;

drop table if exists DELETE_BY_ROWID_FROM_SUBSEL;
create table DELETE_BY_ROWID_FROM_SUBSEL(PlanID int, CMENEID int, CELLID int, TRXID int, OperType int, MAXPDCHNUM int, CHNO int, SRN int, SN int, PORTTYPE int, PN int);
insert into DELETE_BY_ROWID_FROM_SUBSEL values(1,1,1,1,1,1,1,1,1,1,1);
insert into DELETE_BY_ROWID_FROM_SUBSEL values(2,2,2,2,2,2,2,2,2,2,2);
insert into DELETE_BY_ROWID_FROM_SUBSEL values(3,3,3,3,3,3,3,3,3,3,3);
delete from DELETE_BY_ROWID_FROM_SUBSEL where rowid in(select rowid from DELETE_BY_ROWID_FROM_SUBSEL order by 1 limit 1) ;
delete from DELETE_BY_ROWID_FROM_SUBSEL where rowid in(select rowid from DELETE_BY_ROWID_FROM_SUBSEL order by rowid limit 1) ;
delete from DELETE_BY_ROWID_FROM_SUBSEL where planId in(select planId+2 from DELETE_BY_ROWID_FROM_SUBSEL order by 1);

DROP TABLE IF EXISTS store;
DROP TABLE IF EXISTS customer;
create table store
(
    s_store_sk                integer               not null,
    s_store_id                char(16)              not null,
    s_rec_start_date          date                          ,
    s_rec_end_date            date                          ,
    s_closed_date_sk          integer                       ,
    s_store_name              varchar(50)                   ,
    s_number_employees        integer                       ,
    s_floor_space             integer                       ,
    s_hours                   char(20)                      ,
    s_manager                 varchar(40)                   ,
    s_market_id               integer                       ,
    s_geography_class         varchar(100)                  ,
    s_market_desc             varchar(100)                  ,
    s_market_manager          varchar(40)                   ,
    s_division_id             integer                       ,
    s_division_name           varchar(50)                   ,
    s_company_id              integer                       ,
    s_company_name            varchar(50)                   ,
    s_street_number           varchar(10)                   ,
    s_street_name             varchar(60)                   ,
    s_street_type             char(15)                      ,
    s_suite_number            char(10)                      ,
    s_city                    varchar(60)                   ,
    s_county                  varchar(30)                   ,
    s_state                   char(2)                       ,
    s_zip                     char(10)                      ,
    s_country                 varchar(20)                   ,
    s_gmt_offset              decimal(5,2)                  ,
    s_tax_precentage          decimal(5,2)
 );
 
create table customer
(
    c_customer_sk             integer               not null,
    c_customer_id             char(16)              not null,
    c_current_cdemo_sk        integer                       ,
    c_current_hdemo_sk        integer                       ,
    c_current_addr_sk         integer                       ,
    c_first_shipto_date_sk    integer                       ,
    c_first_sales_date_sk     integer                       ,
    c_salutation              char(10)                      ,
    c_first_name              char(20)                      ,
    c_last_name               char(30)                      ,
    c_preferred_cust_flag     char(1)                       ,
    c_birth_day               integer                       ,
    c_birth_month             integer                       ,
    c_birth_year              integer                       ,
    c_birth_country           varchar(20)                   ,
    c_login                   char(13)                      ,
    c_email_address           char(50)                      ,
    c_last_review_date        char(10)
);

select count(distinct c_birth_month)
  from customer
 order by (with tmp1 as (select sum(s_closed_date_sk),
                                s_manager,
                                s_market_id,
                                rank() over(partition by sum(s_closed_date_sk) order by sum(s_closed_date_sk), s_manager, s_market_id)
                           from store
                          where length(s_manager) > 12
                          group by 2, 3
                          order by 1, 2, 3, 4)
            select s_market_id
              from tmp1
             order by 1 limit 1);

DROP TABLE IF EXISTS store;
DROP TABLE IF EXISTS customer;

--DTS2019013102954
select group_concat((INTERVAL '12' YEAR),(INTERVAL '4 5:12:10.222' DAY TO SECOND(3)) order by 1 SEPARATOR '#$%~!@') from dual;

DROP TABLE IF EXISTS "TMP0000000254_ORDER_BY_NULLS";
CREATE TABLE "TMP0000000254_ORDER_BY_NULLS"
(
  "ID"        INT NOT NULL,
  "CHR_FIELD" VARCHAR(30),
  "VALUE" NUMBER
);

insert into "TMP0000000254_ORDER_BY_NULLS" 
  select rownum, decode(mod(rownum, 2), 0, NULL, rpad('CHR_', 10, chr(rownum + 64))), decode(mod(rownum, 3), 0, NULL, rownum * 10000) from dual connect by rownum < 6;

insert into "TMP0000000254_ORDER_BY_NULLS" 
  select rownum + 10, decode(mod(rownum, 2), 0, NULL, rpad('CHR_', 10, chr(rownum + 64))), decode(mod(rownum, 3), 1, NULL, rownum * 10000) from dual connect by rownum < 6;  
 
insert into "TMP0000000254_ORDER_BY_NULLS" 
  select rownum + 15, decode(mod(rownum, 2), 0, NULL, rpad('CHR_', 10, chr(rownum + 64))), decode(mod(rownum, 3), 1, NULL, rownum * 10) from dual connect by rownum < 6;   
 
commit;
--syntax test
SELECT * FROM "TMP0000000254_ORDER_BY_NULLS" ORDER BY VALUE DESC NULLS LAST, CHR_FIELD DESC NULLS, ID;
SELECT * FROM "TMP0000000254_ORDER_BY_NULLS" ORDER BY VALUE DESC NULLS LAST, CHR_FIELD NULLS, ID;
SELECT * FROM "TMP0000000254_ORDER_BY_NULLS" ORDER BY VALUE DESC NULLS LAST, CHR_FIELD LAST, ID;
SELECT * FROM "TMP0000000254_ORDER_BY_NULLS" ORDER BY VALUE DESC NULLS LAST, NULLS LAST, ID;
SELECT * FROM "TMP0000000254_ORDER_BY_NULLS" ORDER BY VALUE DESC NULLS LAST, ASC NULLS LAST, ID;
SELECT * FROM "TMP0000000254_ORDER_BY_NULLS" ORDER BY VALUE DESC "NULLS" LAST;
SELECT * FROM "TMP0000000254_ORDER_BY_NULLS" ORDER BY VALUE DESC NULLS "LAST";

SELECT * FROM "TMP0000000254_ORDER_BY_NULLS" ORDER BY VALUE DESC NULLS LAST, CHR_FIELD DESC NULLS FIRST, ID;
SELECT * FROM "TMP0000000254_ORDER_BY_NULLS" ORDER BY VALUE DESC NULLS LAST, CHR_FIELD DESC NULLS LAST, ID;

SELECT * FROM "TMP0000000254_ORDER_BY_NULLS" ORDER BY 3 DESC NULLS LAST, 1 ASC NULLS FIRST;
SELECT * FROM "TMP0000000254_ORDER_BY_NULLS" ORDER BY 2 NULLS FIRST, 1 ASC NULLS FIRST;
SELECT "ID", "CHR_FIELD" CCC, "VALUE" VVV from "TMP0000000254_ORDER_BY_NULLS" ORDER BY CCC DESC NULLS FIRST, VVV ASC NULLS LAST, 1;
SELECT "ID", "CHR_FIELD" NULLS, "VALUE" VVV from "TMP0000000254_ORDER_BY_NULLS" ORDER BY NULLS NULLS FIRST, VVV ASC NULLS LAST, 1;
SELECT "ID", "CHR_FIELD" NULLS, "VALUE" VVV from "TMP0000000254_ORDER_BY_NULLS" ORDER BY NULLS DESC NULLS FIRST, VVV ASC NULLS LAST, 1;

SELECT "ID", "CHR_FIELD" NULLS, "VALUE" VVV from "TMP0000000254_ORDER_BY_NULLS" ORDER BY NULLS FIRST, VVV ASC NULLS LAST, 1;

-- winsort order by NULLS / 
SELECT ID, CHR_FIELD, VALUE, ROW_NUMBER() OVER (PARTITION BY -VALUE ORDER BY CHR_FIELD DESC NULLS LAST, ID) ROW_NUM from "TMP0000000254_ORDER_BY_NULLS";
SELECT ID, CHR_FIELD, VALUE, SUM(VALUE) OVER (PARTITION BY CHR_FIELD ORDER BY VALUE NULLS FIRST, ID) SUM_VALUE from "TMP0000000254_ORDER_BY_NULLS";
SELECT ID, CHR_FIELD, VALUE, MAX(VALUE) OVER (PARTITION BY CHR_FIELD ORDER BY ID, VALUE DESC NULLS FIRST) SUM_VALUE from "TMP0000000254_ORDER_BY_NULLS";

-- group by may eliminate the sorting
insert into "TMP0000000254_ORDER_BY_NULLS" values(23, 'CHR_XXXXXX', NULL);
insert into "TMP0000000254_ORDER_BY_NULLS" values(24, 'CHR_YYYYYY', 80020);
select CHR_FIELD, sum(value) from "TMP0000000254_ORDER_BY_NULLS" group by CHR_FIELD order by CHR_FIELD nulls first;
select CHR_FIELD, sum(value) from "TMP0000000254_ORDER_BY_NULLS" group by CHR_FIELD order by CHR_FIELD DESC nulls first;
select CHR_FIELD, sum(value) from "TMP0000000254_ORDER_BY_NULLS" group by CHR_FIELD order by CHR_FIELD DESC nulls first, 2;
select CHR_FIELD, sum(value) from "TMP0000000254_ORDER_BY_NULLS" group by CHR_FIELD order by 2 ASC NULLS FIRST, CHR_FIELD DESC nulls LAST;
select CHR_FIELD, sum(value) from "TMP0000000254_ORDER_BY_NULLS" group by CHR_FIELD order by 2 ASC NULLS FIRST, CHR_FIELD DESC nulls first;

select CHR_FIELD, id, sum(value) from "TMP0000000254_ORDER_BY_NULLS" group by CHR_FIELD, id order by CHR_FIELD DESC nulls first,3 nulls first, 2 nulls first;
select CHR_FIELD, id, sum(value) from "TMP0000000254_ORDER_BY_NULLS" group by CHR_FIELD, id order by CHR_FIELD DESC nulls last, id nulls first;

explain select CHR_FIELD, sum(value) from "TMP0000000254_ORDER_BY_NULLS" group by CHR_FIELD order by CHR_FIELD nulls first;
explain select CHR_FIELD, sum(value) from "TMP0000000254_ORDER_BY_NULLS" group by CHR_FIELD order by CHR_FIELD nulls last;
explain select CHR_FIELD, sum(value) from "TMP0000000254_ORDER_BY_NULLS" group by CHR_FIELD order by 2 nulls first;

-- index scan may eliminate the sorting
create index idx_ORDER_BY_NULLS on "TMP0000000254_ORDER_BY_NULLS"(CHR_FIELD);
explain select CHR_FIELD from "TMP0000000254_ORDER_BY_NULLS" order by 1;
explain select CHR_FIELD from "TMP0000000254_ORDER_BY_NULLS" order by 1 nulls last;
explain select CHR_FIELD from "TMP0000000254_ORDER_BY_NULLS" order by 1 nulls first;

explain select * from "TMP0000000254_ORDER_BY_NULLS" order by CHR_FIELD desc;
explain select * from "TMP0000000254_ORDER_BY_NULLS" order by CHR_FIELD desc nulls last;
explain select id, value from "TMP0000000254_ORDER_BY_NULLS" order by CHR_FIELD desc nulls first;

select CHR_FIELD from "TMP0000000254_ORDER_BY_NULLS" order by 1 desc nulls last;
select * from "TMP0000000254_ORDER_BY_NULLS" order by CHR_FIELD asc nulls first, id;


--DTS2019020203833
DROP TABLE IF EXISTS t_type_004;
CREATE TABLE t_type_004(b BOOLEAN);
INSERT INTO t_type_004 VALUES(TRUE);
INSERT INTO t_type_004 VALUES(FALSE);
INSERT INTO t_type_004 VALUES('TRUE');
INSERT INTO t_type_004 VALUES('FALSE');
INSERT INTO t_type_004 VALUES('true');
INSERT INTO t_type_004 VALUES('false');
INSERT INTO t_type_004 VALUES('T');
INSERT INTO t_type_004 VALUES('F');
INSERT INTO t_type_004 VALUES('t');
INSERT INTO t_type_004 VALUES('f');
INSERT INTO t_type_004 VALUES('1');
INSERT INTO t_type_004 VALUES('0');
INSERT INTO t_type_004 VALUES(1);
INSERT INTO t_type_004 VALUES(0);
COMMIT;

SELECT * FROM T_TYPE_004 T WHERE T.B = '1' AND T.B = TRUE AND T.B = 't' AND B = 'T' AND B = 'true' AND B = 'TRUE' AND B = 1 AND b ORDER BY B;
SELECT * FROM T_TYPE_004 T WHERE T.B = '0' ORDER BY B;
SELECT * FROM T_TYPE_004 T WHERE T.B = 'LIMIT' ORDER BY B;
SELECT * FROM T_TYPE_004 T WHERE T.B = 'ROWID' ORDER BY B;
SELECT * FROM T_TYPE_004 T WHERE T.B = 'NULL' ORDER BY B;
SELECT * FROM T_TYPE_004 T WHERE T.B = 'LEFT' ORDER BY B;
SELECT * FROM T_TYPE_004 T WHERE T.B = 'JOIN' ORDER BY B;
SELECT * FROM T_TYPE_004 T WHERE T.B = 'SELECT' ORDER BY B;
SELECT * FROM T_TYPE_004 T WHERE T.B = 'TRUE' or T.B = 'll' ORDER BY B;
SELECT * FROM T_TYPE_004 T WHERE T.B = X'02';
SELECT * FROM T_TYPE_004 T WHERE T.B = 0x02;
SELECT * FROM T_TYPE_004 T WHERE T.B = NULL;
DROP TABLE T_TYPE_004;


DROP TABLE IF EXISTS I_PHYINVLTP_test;
CREATE TABLE I_PHYINVLTP_test
(
  id VARBINARY(16) NOT NULL,
  name VARCHAR(765 BYTE),
  neName VARCHAR(765 BYTE),
  PRIMARY KEY(id)
);
CREATE INDEX IDX_PHYINVLTP_NENAME_1204_test ON I_PHYINVLTP_test(neName, id);

explain SELECT  name, neName,id ,rowid
FROM I_PHYINVLTP_test I 
WHERE (((((I.neName<'10004') 
OR (I.neName IS NULL )) 
OR ((I.neName='10004') 
AND (I.id>UNHEX('11e969c29bd3ee40adf00050569e7b91')))))) 
ORDER BY I.neName DESC, I.id ASC
limit 10;

explain SELECT  name, neName,id ,rowid
FROM I_PHYINVLTP_test I 
WHERE (((((I.neName<'10004') 
OR (I.neName IS NULL )) 
OR ((I.neName='10004') 
AND (I.id>UNHEX('11e969c29bd3ee40adf00050569e7b91')))))) 
ORDER BY I.neName ASC, I.id DESC
limit 10;

explain SELECT  name, neName,id ,rowid
FROM I_PHYINVLTP_test I 
WHERE (((((I.neName<'10004') 
OR (I.neName IS NULL )) 
OR ((I.neName='10004') 
AND (I.id>UNHEX('11e969c29bd3ee40adf00050569e7b91')))))) 
ORDER BY I.neName DESC, I.id DESC
limit 10;

explain SELECT  name, neName,id ,rowid
FROM I_PHYINVLTP_test I 
WHERE (((((I.neName<'10004') 
OR (I.neName IS NULL )) 
OR ((I.neName='10004') 
AND (I.id>UNHEX('11e969c29bd3ee40adf00050569e7b91')))))) 
ORDER BY I.neName, I.id 
limit 10;

explain SELECT  name, neName,id ,rowid
FROM I_PHYINVLTP_test I 
WHERE (((((I.neName<'10004') 
OR (I.neName IS NULL )) 
OR ((I.neName='10004') 
AND (I.id>UNHEX('11e969c29bd3ee40adf00050569e7b91')))))) 
limit 10;

DROP TABLE I_PHYINVLTP_test;

drop table if exists ToClob_T1;
create table ToClob_T1(f_long long,f_clob clob);
insert into ToClob_T1 values('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',to_clob(LPAD(1,20000,'x')));
insert into ToClob_T1 values('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',to_clob(LPAD(1,20000,'a')));
select to_clob(f_long) from ToClob_T1 order by 1;
select f_long from ToClob_T1 order by f_clob desc;
drop table ToClob_T1;
--DTS2019082311282
drop table if exists t_count_base_001;
create table t_count_base_001(id number,deptno number,name varchar2(20),sal number);
insert into t_count_base_001 values(1,1,'1aa',120);
insert into t_count_base_001 values(2,1,'2aa',300);
insert into t_count_base_001 values(3,1,'3aa',100);
insert into t_count_base_001 values(4,1,'4aa',99);
insert into t_count_base_001 values(5,1,'5aa',90);
insert into t_count_base_001 values(6,2,'6aa',87);
insert into t_count_base_001 values(7,2,'7aa',500);
insert into t_count_base_001 values(8,2,'8aa',200);
insert into t_count_base_001 values(9,2,'9aa',20);
insert into t_count_base_001 values(10,2,'10aa',30);
insert into t_count_base_001 values(null,2,'10aa',30);
insert into t_count_base_001 values(12,2,'10aa',null);
commit;
select distinct to_char(to_blob('a'))||array[1] c from t_count_base_001 t connect by nocycle prior id=1 order by abs(c);
drop table if exists t_count_base_001;

drop table if exists t_sort_1;
drop table if exists t_sort_2;
drop table if exists t_sort_3;
drop table if exists t_sort_4;
create table t_sort_1(a int, b int, c int, d int);
create index idx_t_sort_1_1 on t_sort_1(a);
create table t_sort_2(a int, b int, c int, d int);
create index idx_t_sort_2_1 on t_sort_2(b);
create table t_sort_3(a int, b int, c int, d int);
create index idx_t_sort_3_1 on t_sort_3(c);
create table t_sort_4(a int, b int, c int, d int);
create index idx_t_sort_4_1 on t_sort_4(d);
explain select * from t_sort_1 t1 join t_sort_2 t2 on t1.b = t2.b where t1.a >= 0 order by t2.b;
explain select * from t_sort_1 t1 join t_sort_2 t2 on t1.c = t2.c order by t1.a;
explain select * from t_sort_1 t1 join t_sort_2 t2 on t1.b = t2.b order by t1.a;
explain select * from t_sort_1 t1 join t_sort_2 t2 on t1.c = t2.c order by t2.b;
explain select * from t_sort_1 t1 left join t_sort_2 t2 on t1.c = t2.c order by t1.a;
explain select * from t_sort_1 t1 join t_sort_2 t2 on t1.b = t2.b where t1.a >= 0 order by t1.a;
explain select * from t_sort_1 t1 join t_sort_2 t2 on t1.b = t2.b  join t_sort_3 t3 on t2.c = t3.c where t1.a = 100 order by t1.a;
explain select * from t_sort_1 t1 join ((t_sort_2 t2 join t_sort_3 t3 on t2.c = t3.c) left join t_sort_4 t4 on t3.b = t4.b) on t1.a = t4.a order by t2.b;
explain select * from t_sort_1 t1 join ((t_sort_2 t2 join t_sort_3 t3 on t2.a = t3.a) left join t_sort_4 t4 on t3.b = t4.b) on t1.a = t4.a order by t3.c;
drop table if exists t_sort_1;
drop table if exists t_sort_2;
drop table if exists t_sort_3;
drop table if exists t_sort_4;

drop table if exists t_orderby1;
drop table if exists t_orderby2;
create table t_orderby1(f1 int, f2 int, f3 int, f4 int);
create table t_orderby2(f1 int, f2 int, f3 int, f4 int);
insert into t_orderby1 values(1,2,3,4);
insert into t_orderby1 values(2,3,4,5);
insert into t_orderby1 values(3,4,5,6);
insert into t_orderby1 values(4,5,6,7);
insert into t_orderby1 values(3,4,1,2);
insert into t_orderby1 values(4,5,2,3);
insert into t_orderby1 values(5,6,3,4);
insert into t_orderby1 values(6,7,4,5);
insert into t_orderby2 values(1,2,3,4);
insert into t_orderby2 values(2,3,4,5);
insert into t_orderby2 values(3,4,5,6);
insert into t_orderby2 values(4,5,6,7);
insert into t_orderby2 values(3,4,1,2);
insert into t_orderby2 values(4,5,2,3);
insert into t_orderby2 values(5,6,3,4);
insert into t_orderby2 values(6,7,4,5);

explain select * from (select distinct f1,f2,f3,f4 from t_orderby1) order by f1,f2;
explain select * from (select distinct f1,f2,f3,f4 from t_orderby1) order by f3+f4;
explain select * from (select f1,f2,sum(f3) over(partition by f1 order by f4) winsort from t_orderby1) order by f1,f2;
explain select * from (select distinct t1.f1 f1,t1.f2 f2,t1.f3 f3,t2.f1 f4,t2.f2 f5,t2.f3 f6 from t_orderby1 t1 join t_orderby2 t2 on t1.f1 = t2.f1) order by f2,f4,f6;

select * from (select distinct f1,f2,f3,f4 from t_orderby1) order by f1,f2;
select * from (select distinct f1,f2,f3,f4 from t_orderby1) order by f3+f4;
select * from (select f1,f2,sum(f3) over(partition by f1 order by f4) winsort from t_orderby1) order by f1,f2;
select * from (select distinct t1.f1 f1,t1.f2 f2,t1.f3 f3,t2.f1 f4,t2.f2 f5,t2.f3 f6 from t_orderby1 t1 join t_orderby2 t2 on t1.f1 = t2.f1) order by f2,f4,f6;

drop table if exists t_orderby1;
drop table if exists t_orderby2;

DROP TABLE IF EXISTS "PBI_EDITION_OD";
CREATE TABLE "PBI_EDITION_OD"
(
  "EDITION_ID" NUMBER(20) NOT NULL,
  "OFFERING_ID" NUMBER(20),
  "PARENT_ID" NUMBER(20),
  "NO" VARCHAR(45 BYTE) NOT NULL,
  "EDITION_CODE" VARCHAR(75 BYTE),
  "CATEGORY" VARCHAR(30 BYTE) NOT NULL,
  "STATUS" NUMBER(1) NOT NULL,
  "OFFERING_NAME" VARCHAR(768 BYTE),
  "ALIAS" VARCHAR(768 BYTE),
  "FOR_FINACE" NUMBER(1) NOT NULL,
  "LIFECYCLE_ID" VARCHAR(45 BYTE),
  "OLD_NO" VARCHAR(150 BYTE),
  "VERSION" VARCHAR(15 BYTE) NOT NULL,
  "CREATED_BY" VARCHAR(768 BYTE),
  "CREATION_DATE" DATE,
  "LAST_UPDATED_BY" VARCHAR(768 BYTE),
  "LAST_UPDATE_DATE" DATE,
  "DIFFICULTY_COEFFICIENT" VARCHAR(45 BYTE),
  "SPLIMIT" NUMBER(1),
  "SPNUM" NUMBER(5),
  "IFHISTORYCOA" NUMBER(1),
  "RESERVE11" VARCHAR(375 BYTE),
  "RESERVE12" VARCHAR(375 BYTE),
  "RESERVE13" VARCHAR(375 BYTE),
  "RESERVE14" VARCHAR(375 BYTE),
  "RESERVE15" VARCHAR(375 BYTE)
);
DROP TABLE IF EXISTS "HWF_DD_ITEM";
CREATE TABLE "HWF_DD_ITEM"
(
  "ITEM_ID" VARCHAR(75 BYTE) NOT NULL,
  "ITEM_NAME" VARCHAR(150 BYTE) NOT NULL,
  "ITEM_DESC" VARCHAR(750 BYTE),
  "ITEM_TIME" DATE,
  "NLS_LANG" VARCHAR(15 BYTE) NOT NULL,
  "CLASSIFY_ID" VARCHAR(75 BYTE) NOT NULL,
  "PARENT_ITEM_ID" VARCHAR(75 BYTE),
  "ITEM_STATUS" NUMBER(38) NOT NULL
);

DROP TABLE IF EXISTS "PBI_RND_EDITION";
CREATE TABLE "PBI_RND_EDITION"
(
  "RND_EDITION_ID" NUMBER(20) NOT NULL,
  "EDITION_ID" NUMBER(20),
  "PARENT_ID" NUMBER(20),
  "NO" VARCHAR(45 BYTE) NOT NULL,
  "EDITION_CODE" VARCHAR(75 BYTE),
  "CATEGORY" VARCHAR(30 BYTE) NOT NULL,
  "STATUS" NUMBER(1) NOT NULL,
  "OFFERING_NAME" VARCHAR(768 BYTE),
  "ALIAS" VARCHAR(768 BYTE),
  "OLD_NO" VARCHAR(150 BYTE),
  "VERSION" VARCHAR(15 BYTE) NOT NULL,
  "CREATED_BY" VARCHAR(768 BYTE),
  "CREATION_DATE" DATE,
  "LAST_UPDATED_BY" VARCHAR(768 BYTE),
  "LAST_UPDATE_DATE" DATE,
  "SPLIMIT" NUMBER(1),
  "SPNUM" NUMBER(5),
  "RESERVE11" VARCHAR(375 BYTE),
  "RESERVE12" VARCHAR(375 BYTE),
  "RESERVE13" VARCHAR(375 BYTE),
  "RESERVE14" VARCHAR(375 BYTE),
  "RESERVE15" VARCHAR(375 BYTE)
);
ALTER TABLE "PBI_RND_EDITION" ADD CONSTRAINT "PK_RND_EDITION_ID" PRIMARY KEY("RND_EDITION_ID");
explain SELECT *
  FROM (SELECT ROWNUM rn, t.*
          FROM (SELECT *
                  FROM (SELECT C.RND_EDITION_ID AS ENTITY_ID,
                               C.RND_EDITION_ID,
                               C.EDITION_ID,
                               (CASE
                                 WHEN (SELECT T.CATEGORY
                                         FROM PBI_EDITION_OD T
                                        WHERE T.EDITION_ID = C.EDITION_ID) =
                                      '402-00023814' THEN
                                  (SELECT T.PARENT_ID
                                     FROM PBI_EDITION_OD T
                                    WHERE T.EDITION_ID = C.EDITION_ID)
                                 ELSE
                                  C.EDITION_ID
                               END) AS PARENT_ID,
                               C.NO,
                               C.CATEGORY,
                               C.ALIAS,
                               C.EDITION_CODE,
                               C.ALIAS AS CN,
                               C.ALIAS AS EN,
                               (SELECT item_name
                                  FROM hwf_dd_item
                                 WHERE C.category = item_id) AS categoryName,
                               C.STATUS,
                               C.OFFERING_NAME,
                               C.OLD_NO AS VERSION,
                               C.SPLIMIT,
                               C.SPNUM,
                               C.RESERVE11,
                               C.RESERVE12,
                               C.RESERVE13,
                               C.RESERVE14,
                               C.RESERVE15,
                               C.CREATED_BY,
                               C.CREATION_DATE,
                               C.LAST_UPDATED_BY,
                               C.LAST_UPDATE_DATE AS last_update_date
                          FROM (SELECT RND_EDITION_ID,
                                       EDITION_ID,
                                       PARENT_ID,
                                       NO,
                                       EDITION_CODE,
                                       CATEGORY,
                                       STATUS,
                                       OFFERING_NAME,
                                       ALIAS,
                                       OLD_NO,
                                       VERSION,
                                       CREATED_BY,
                                       CREATION_DATE,
                                       LAST_UPDATED_BY,
                                       LAST_UPDATE_DATE,
                                       SPLIMIT,
                                       SPNUM,
                                       RESERVE11,
                                       RESERVE12,
                                       RESERVE13,
                                       RESERVE14,
                                       RESERVE15
                                  FROM PBI_RND_EDITION BL) C
                         WHERE 1 = 1
                           AND C.status = '1') C
                 WHERE 1 = 1
                 ORDER BY entity_id) t
         WHERE ROWNUM <= 10)
 WHERE rn >= 1;
DROP TABLE IF EXISTS "PBI_EDITION_OD";
DROP TABLE IF EXISTS "HWF_DD_ITEM";
DROP TABLE IF EXISTS "PBI_RND_EDITION";
---DTS2020022716448
DROP TABLE IF EXISTS T_ORDER_BY_PUSHODWN;
CREATE TABLE T_ORDER_BY_PUSHODWN(
	I_INT INT,
	V_VARCHAR VARCHAR(20),
	BOOL BOOLEAN,
	D_DECIMAL DECIMAL,
	V_CHAR  CHAR(10),
	B_BINARY BINARY(10),
	D_DATETIME DATETIME,
	T_INTERVAL interval day(7) to second,
	ARRAY_LIST INT[]	
);
INSERT INTO T_ORDER_BY_PUSHODWN VALUES(1,'AA',TRUE,12.3,'王五','101010','2020-01-01 17:18:18','-1234 0:0:0.0004','{1,2,3}');
INSERT INTO T_ORDER_BY_PUSHODWN VALUES(2,'BB',FALSE,12.4,'张天','010101','2021-01-01 17:18:18','-1234 0:0:0.0004','{1,2,3}');
INSERT INTO T_ORDER_BY_PUSHODWN VALUES(3,'CC',0,12.5,'张三','010101','2020-01-01 17:18:18','-1234 0:0:0.0004','{1,2}');
INSERT INTO T_ORDER_BY_PUSHODWN VALUES(4,'DD',1,12.4,'李四','010101','2021-01-01 17:18:18','-1234 0:0:0.0004','{1,2,3}');
INSERT INTO T_ORDER_BY_PUSHODWN VALUES(5,'AA',TRUE,1.3,'王五','101010','2020-01-01 17:18:18','-1234 0:0:0.0004','{1,2,3}');
INSERT INTO T_ORDER_BY_PUSHODWN VALUES(6,'DD',FALSE,12.40,'六六','101010','2021-01-01 17:18:18','-1234 0:0:0.0004','{1,2}');
commit;
explain select case when D_DECIMAL>2 then D_DECIMAL else I_INT+5 end,case when I_INT>2 then I_INT else I_INT+5 end from (select distinct I_INT,D_DECIMAL from T_ORDER_BY_PUSHODWN) order by case when D_DECIMAL>2 then D_DECIMAL else I_INT+5 end;
select case when D_DECIMAL>2 then D_DECIMAL else I_INT+5 end,case when I_INT>2 then I_INT else I_INT+5 end from (select distinct I_INT,D_DECIMAL from T_ORDER_BY_PUSHODWN) order by case when D_DECIMAL>2 then D_DECIMAL else I_INT+5 end;
explain select I_INT from (select I_INT, V_VARCHAR, D_DECIMAL FROM T_ORDER_BY_PUSHODWN connect by nocycle prior I_INT+1=I_INT) WHERE D_DECIMAL > 2 ORDER BY I_INT;
explain select I_INT from (select I_INT, V_VARCHAR FROM T_ORDER_BY_PUSHODWN connect by nocycle prior I_INT+1=I_INT)  HAVING 1 =2  ORDER BY I_INT;
DROP TABLE IF EXISTS T_ORDER_BY_PUSHODWN;

--basic
drop table if exists t_subselect_rs_001;
create table t_subselect_rs_001(f1 int);
insert into t_subselect_rs_001 values(1),(2000);
commit;
select f1,(select dummy||sleep(f1) from dual) from t_subselect_rs_001 order by f1 limit 1;
drop table if exists t_subselect_rs_003;
create table t_subselect_rs_003(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10) not null,c_vchar2 varchar2(100),c_clob clob,
c_long varchar(200),c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp);
insert into t_subselect_rs_003 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),
lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_subselect_rs_003 values(-1,null,null,null,null,null,null,'M',null,null,null,null,null,null,null);
CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
                sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_real+'||i||',c_float+'||i||',c_decimal+'||i||',c_number+'||i||',c_char'||',c_vchar||'||i||',c_vchar2||'||i||',c_clob||'||i||',c_long||'||i||',c_blob'||',c_raw,ADD_MONTHS(c_date,'||i||'),ADD_MONTHS(c_timestamp,'||i||') from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/
call proc_insert('t_subselect_rs_003',1,66);
commit;
drop table if exists t_subselect_rs_004;
drop table if exists t_subselect_rs_005;
drop table if exists t_subselect_rs_006;
create table t_subselect_rs_004(t4_f1 int, t4_f2 int, t4_f3 int);
create table t_subselect_rs_005(t5_f1 int, t5_f2 int, t5_f3 int);
create table t_subselect_rs_006(t6_f1 int, t6_f2 int, t6_f3 int);
CREATE or replace procedure proc_insert2(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
                sqlst := 'insert into ' || tname ||' values('|| i ||',' || i || '+1,' || i||'+2)';
        execute immediate sqlst;
  END LOOP;
END;
/
call proc_insert2('t_subselect_rs_004',1,200);
call proc_insert2('t_subselect_rs_005',1,200);
call proc_insert2('t_subselect_rs_006',1,200);
create index idx_t4_002 on t_subselect_rs_004(t4_f2);
create index idx_t5_003 on t_subselect_rs_005(t5_f3);
create index idx_t6_002 on t_subselect_rs_006(t6_f2);
--mtrl datatype
drop table if exists t_subselect_rs_002;
CREATE TABLE  t_subselect_rs_002(
     COL_1 int,
     COL_2 integer, 
     COL_3 bigint,
     COL_4 real,
     COL_5 double,
     COL_6 float,
     COL_7 decimal(12,6),
     COL_8 number,
     COL_9 numeric,
     COL_10 char(30),
     COL_11 varchar(30),
     COL_12 varchar2(30),
     COL_13 image,
     COL_14 date,
     COL_15 datetime,
     COL_16 timestamp,
     COL_17 timestamp with time zone,
     COL_18 timestamp with local time zone,
     COL_19 bool,
     COL_20 boolean,
     COL_21 interval year to month,
     COL_22 interval day to second,
	 col_23 blob,
	 col_24 clob
);
begin
    for i in 1..10 loop
      insert into t_subselect_rs_002 values(     
      i,
      i+1,      
      i+2,
      i+3.1415926,
      i+445.255,
      3.1415926-i*2,
      98*0.99*i, 
      99*1.01*i,
      -98*0.99*i,
      lpad('abc','10','@'), 
      lpad('abc','10','b'),
      rpad('abc','10','e'),
      '1111111111',
      TIMESTAMPADD(SECOND,i,'2018-11-03 14:14:12'),
      TIMESTAMPADD(MINUTE,i,'2019-01-03 14:14:12'),
      to_timestamp('2019-01-03 14:58:54.000000','YYYY-MM-DD HH24:MI:SS.FFFFFF'),    
      TIMESTAMPADD(HOUR,i,'2019-01-03 14:14:12'),
      TIMESTAMPADD(DAY,i,'2019-08-17 15:36:00'),
      true,
      false,
      (INTERVAL '99-02' YEAR TO MONTH),
      (INTERVAL '4 5:12:10.222' DAY TO SECOND(3)),
	  lpad('123abc',50,'abc'),
	  lpad('11100001',50,'1100')
      );
      commit;
    end loop;
end;
/
select (select COL_1||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_2||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_3||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_4||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_5||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_6||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_7||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_8||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_9||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_10||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_11||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_12||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_13 from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_14||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_15||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_16||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_17||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_18||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_19||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_20||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_21||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_22||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_23 from dual) from t_subselect_rs_002 order by COL_1 limit 2;
select (select COL_24||dummy from dual) from t_subselect_rs_002 order by COL_1 limit 2;
--rowid
select (select t6_f1 from t_subselect_rs_005 where t5_f1 < t6.rowid limit 1) from t_subselect_rs_006 t6 order by t6_f1 limit 2;
select (select t5_f1 from t_subselect_rs_005 where t5_f1 < t6.rowid limit 1) from t_subselect_rs_006 t6 order by t6_f1 limit 2;
select (select t5_f1 from t_subselect_rs_005 where t5_f1 < t6.rowid and t5_f1 = t6.t6_f1) from t_subselect_rs_006 t6 order by t6_f1 limit 2;
--group by + aggr
select (select t6_f1 from dual) from t_subselect_rs_006 group by t6_f1 order by 1 limit 2;
select t6_f1,(select t6_f2||t6_f1||dummy from dual) from t_subselect_rs_006 group by t6_f1,t6_f2 order by 1 limit 6;
select t6_f1,GROUP_CONCAT(t6_f2),(select t6_f1 from dual) from t_subselect_rs_006 group by t6_f1 order by 1 limit 6;
select t6_f1,(select GROUP_CONCAT(dummy)||t6_f1||dummy from dual) from t_subselect_rs_006 group by t6_f1,t6_f2 order by t6_f1 limit 6;
select GROUP_CONCAT(t6_f2),(select GROUP_CONCAT(t6_f2)||t6_f1||dummy from dual) from t_subselect_rs_006 group by t6_f1,t6_f2 order by t6_f1 limit 6;
select (select median(t4_f1) from dual) from t_subselect_rs_004 order by t4_f2 limit 6;
select (select median(avg(t4_f1)) from dual) from t_subselect_rs_004 order by t4_f2 limit 6;
--order by
select (select t5_f1 from t_subselect_rs_005 where t5_f1 < t6.rowid order by t5_f1 desc limit 1) from t_subselect_rs_006 t6 order by t6_f1 limit 2;
select (select t5_f1 from t_subselect_rs_005 where t5_f1 < t6.rowid order by t5_f1 asc limit 1) from t_subselect_rs_006 t6 order by t6_f1 limit 2;
--limit
select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f3 limit 1) from t_subselect_rs_005 t5  order by t5.t5_f1 limit 10;
--join
select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f3 limit 1) from t_subselect_rs_005 t5 left join t_subselect_rs_006 t6 on t5.t5_f1 = t6.t6_f2 order by t5.t5_f1 limit 10;
select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f3 limit 1) from t_subselect_rs_005 t5 left join t_subselect_rs_006 t6 on t5.t5_f1 > t6.t6_f2 order by t5.t5_f1 limit 10;
select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f3 or t4_f2=t6_f3 limit 1) from t_subselect_rs_005 t5 left join t_subselect_rs_006 t6 on t5.t5_f1 > t6.t6_f2 order by t5.t5_f1 limit 10;
select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f3 or t4_f2=t6_f3 limit 1) from t_subselect_rs_005 t5 left join t_subselect_rs_006 t6 on t5.t5_f1 = t6.t6_f2 inner join t_subselect_rs_003 t3 on
t5.t5_f1!=t3.c_int order by t5.t5_f1 limit 10;
--connect by
select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f3 limit 1) from (select * from t_subselect_rs_005) t5 left join t_subselect_rs_006 t6 on t5.t5_f1 = t6.t6_f2 start with
t5.t5_f1 = 10 connect by prior t5.t5_f1 = t5.t5_f1 + 1 order by t5.t5_f1 limit 10;
select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f3 limit 1) from (select * from t_subselect_rs_005) t5 inner join t_subselect_rs_006 t6 on t5.t5_f1 = t6.t6_f2 start with
t5.t5_f1 = 10 connect by prior t5.t5_f1 = t5.t5_f1 + 1 order by t5.t5_f1 limit 10;
select /*+rule*/ (select sys_connect_by_path(t4_f2||t5_f3,'/') from t_subselect_rs_004 start with t4_f2=t5_f3 connect by prior t4_f2 + 1 = t4_f2 limit 1) from (select * from t_subselect_rs_005) t5
inner join t_subselect_rs_006 t6 on t5.t5_f1 = t6.t6_f2 start with t5.t5_f1 = 10 connect by prior t5.t5_f1 = t5.t5_f1 + 1 order by t5.t5_f1 limit 10;
select /*+rule*/ (select sys_connect_by_path(t4_f2||t5_f3,'/') from t_subselect_rs_004 start with t4_f2=t5_f3 connect by prior t4_f2 + 1 = t4_f2 limit 1) from (select * from t_subselect_rs_005) t5
inner join t_subselect_rs_006 t6 on t5.t5_f1 = t6.t6_f2  order by t5.t5_f1 limit 10;
select /*+rule*/ (select t4_f2 from t_subselect_rs_004 where t4_f2=t5_f3 limit 1),sys_connect_by_path(t5_f3,'/') from (select * from t_subselect_rs_005) t5 inner join t_subselect_rs_006 t6
on t5.t5_f1 = t6.t6_f2 start with t5.t5_f1 = 10 connect by prior t5.t5_f1 = t5.t5_f1 + 1 order by t5.t5_f1 limit 10;
select /*+rule*/ (select sys_connect_by_path(t4_f2||t5_f3,'/') from t_subselect_rs_004 start with t4_f2=t5_f3 connect by prior t4_f2 + 1 = t4_f2 limit 1) from (select * from t_subselect_rs_005) t5
inner join t_subselect_rs_006 t6 on t5.t5_f1 = t6.t6_f2 start with t5.t5_f1 = 10 connect by prior t5.t5_f1 = t5.t5_f1 + 1 order siblings by t5.t5_f1 limit 10;
select /*+rule*/ (select t4_f2 from t_subselect_rs_004 where t4_f2=t5_f3 limit 1),sys_connect_by_path(t5_f3,'/') from (select * from t_subselect_rs_005) t5 inner join t_subselect_rs_006 t6
on t5.t5_f1 = t6.t6_f2 start with t5.t5_f1 = 10 connect by prior t5.t5_f1 = t5.t5_f1 + 1 order siblings by t5.t5_f1 limit 10;
--array
select (select sys_connect_by_path(c_char, '/') from t_subselect_rs_003 t3 start with t3.id = t5.t5_f1 connect by prior id+1=id limit 1) from t_subselect_rs_005 t5 order by t5_f1 limit 10;
select (select array_length(array_agg(sys_connect_by_path(c_char, '/'))) from t_subselect_rs_003 t3 start with t3.id = t5.t5_f1 connect by prior id+1=id group by c_char limit 1) from
t_subselect_rs_005 t5 order by t5_f1 limit 10;
select (select array_length(array_agg(sys_connect_by_path(t5.t5_f1, '/'))) from t_subselect_rs_003 t3 start with t3.id = t5.t5_f1 connect by prior id+1=id group by c_char limit 1) from
t_subselect_rs_005 t5 order by t5_f1 limit 10;
--rs subselect + order by const
select (select c_int from t_subselect_rs_003 where c_int!=t4_f1 order by 1 limit 1) from t_subselect_rs_004 order by t4_f1 limit 10;
select (select c_char from t_subselect_rs_003 where c_int!=t4_f1 order by 1 limit 1) from t_subselect_rs_004 order by t4_f1 limit 10;
select (select c_char from t_subselect_rs_003 where id=t4_f1 order by 1 limit 1) from t_subselect_rs_004 order by 1 limit 10;
select (select c_char from t_subselect_rs_003 where id=t4_f1 order by 1 limit 1) from t_subselect_rs_004 group by t4_f1 order by 1 limit 10;
--select sort
select (select c_char||id from t_subselect_rs_003 where id=t4_f1 order by 1 limit 1) from t_subselect_rs_004 union all select (select c_char from t_subselect_rs_003 where id=t4_f1 order by 1 limit 1)
from t_subselect_rs_004 order by 1 limit 10;
select (select c_char||id from t_subselect_rs_003 where id=t4_f1 order by 1 limit 1) from t_subselect_rs_004 union all select (select c_char from t_subselect_rs_003 where id=t4_f1 order by 1 limit 1)
from t_subselect_rs_004 order by 1 limit 10;
--where
select (select t4_f1 from t_subselect_rs_004 where t4_f2=a.t5_f3 limit 1) from (select (select t5_f3 from t_subselect_rs_005 where t5_f3 = t6_f2 limit 1)t5_f3,t6_f2 from 
(select t6_f2,t6_f3 from t_subselect_rs_006) where t6_f2 = 66 order by t6_f3 desc)a;
select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f3 limit 1) from t_subselect_rs_005 t5 left join t_subselect_rs_006 t6 on t5.t5_f1 = t6.t6_f2 order by t5.t5_f1 limit 10;
select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f3 limit 1) from t_subselect_rs_005 t5 left join t_subselect_rs_006 t6 on t5.t5_f1 > t6.t6_f2 order by t5.t5_f1 limit 10;
select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f3 limit 1) from t_subselect_rs_005 t5 left join t_subselect_rs_006 t6 on t5.t5_f1 > t6.t6_f2 order by t5.t5_f1 limit 10;
select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f3 limit 1) from t_subselect_rs_005 t5 left join t_subselect_rs_006 t6 on t5.t5_f1 = t6.t6_f2 inner join t_subselect_rs_003 t3 on
t5.t5_f1!=t3.c_int order by t5.t5_f1 limit 10;
--explain
explain select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f3 limit 1) from (select * from t_subselect_rs_005) t5 inner join t_subselect_rs_006 t6 on t5.t5_f1 = t6.t6_f2
start with t5.t5_f1 = 10 connect by prior t5.t5_f1 = t5.t5_f1 + 1 order by t5.t5_f1 limit 10;
explain select /*+use_hash*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f3 limit 1) from (select * from t_subselect_rs_005) t5 inner join t_subselect_rs_006 t6 on t5.t5_f1 = t6.t6_f2
order by t5.t5_f1 limit 10;
--winsort
select (select sum(t4_f1) over (partition by t4_f2 order by t4_f3) from t_subselect_rs_004 where t4_f1 = t5_f1 limit 1) from t_subselect_rs_005 order by t5_f1 limit 10;
select (select t4_f1 from t_subselect_rs_004 where t4_f1 = t5_f1 limit 1),sum(t5_f1) over (partition by t5_f2 order by t5_f3) from t_subselect_rs_005 order by t5_f1 limit 2;
--winsort + within group
select listagg(t4_f1,dummy) within group (order by t4_f2) over (partition by t4_f2),(select t5_f1 from t_subselect_rs_005 where t5_f1=t4_f1 limit 1) from t_subselect_rs_004,dual limit 2;
select listagg(t4_f1,dummy) within group (order by t4_f2) over (partition by t4_f2),(select listagg(t4_f1,dummy) within group (order by t4_f2) over (partition by t4_f2) from t_subselect_rs_005
where t5_f1=t4_f1 limit 1) from t_subselect_rs_004,dual limit 2;
--case
select (select case when t4_f1 > t5_f1 then t4_f1-t5_f1 else t5_f1-t4_f1 end from t_subselect_rs_004 where t4_f1 = 66) from t_subselect_rs_005 order by t5_f1 limit 10;
select (select case when t4_f1 > t5_f1 then t4_f1-t5_f1 else t5_f1-t4_f1 end from t_subselect_rs_004 where t4_f1 = 66),sum(t5_f1) over (partition by t5_f2 order by t5_f3) from t_subselect_rs_005
where case when t5_f1 + t5_f2 > t5_f3 then 1 else 0 end > 0 order by t5_f1 limit 10;
select sum(t5_f1) over (partition by t5_f2 order by case when t5_f1 + t5_f2 > t5_f3 then 1 else 0 end) from t_subselect_rs_005 order by t5_f1 limit 10;
select (select sum(t4_f1) over (partition by t4_f2 order by case when t5_f1 + t5_f2 > t5_f3 then 1 else 0 end) from t_subselect_rs_004 where t4_f1 = t5_f1 limit 1) from t_subselect_rs_005
order by t5_f1 limit 10;
select (select sum(t4_f1) over (partition by t4_f2 order by case when t5_f1 then t5_f1 else t4_f1 end) from t_subselect_rs_004 where t4_f1 = t5_f1 limit 1) from t_subselect_rs_005 order by t5_f1 limit 10;
select (select case when t4_f1 > t5_f1 then t4_f1-t5_f1 else t5_f1-t4_f1 end from t_subselect_rs_004 where t4_f1 = 66),sum(t5_f1) over (partition by t5_f2 order by t5_f3) from t_subselect_rs_005
order by case when t5_f1 then t5_f2 else  t5_f3 end  limit 10;
select case (t6_f1) when (66) then ('six') when (100) then ('hundred') else ('others') end as aaa from t_subselect_rs_006 order by aaa limit 10;
--others
DROP TABLE IF EXISTS t_subselect_rs_007;
CREATE TABLE t_subselect_rs_007(F_INT51 INT, F_INT52 INT, F_CHAR51 varCHAR(20));
INSERT INTO t_subselect_rs_007 VALUES(1,2,'abc');
INSERT INTO t_subselect_rs_007 VALUES(2,3,'dec');
INSERT INTO t_subselect_rs_007 VALUES(3,4,'hij');
INSERT INTO t_subselect_rs_007 VALUES(4,5,'qwe');
INSERT INTO t_subselect_rs_007 VALUES(null,6,'asd');
CREATE INDEX FUNC_INDEX_INT_T_INDEX_5 ON t_subselect_rs_007(TO_CHAR(F_INT51)) ONLINE;
CREATE INDEX FUNC_INDEX_CHAR_INDEX_5 ON t_subselect_rs_007(UPPER(F_CHAR51) )ONLINE;
select /*+rule*/ (select f_int51||a.f_char51 from t_subselect_rs_007 where to_char(a.f_char51) = TO_CHAR(F_CHAR51) limit 1) from t_subselect_rs_007 a 
where upper(F_CHAR51)='QWE' order by f_int51 limit 2;
explain select /*+rule*/ (select f_int51||a.f_char51 from t_subselect_rs_007 where to_char(a.f_char51) = TO_CHAR(F_CHAR51) limit 1) from t_subselect_rs_007 a 
where upper(F_CHAR51)='QWE' order by f_int51 limit 2;
--distinct
select distinct t4_f1,(select c_int from t_subselect_rs_003 where c_int!=t4_f1 order by 1 limit 1) from t_subselect_rs_004 order by 1 limit 2;
--having
select (select t5_f1 from t_subselect_rs_005 having t6_f1 > 1 limit 1) from t_subselect_rs_006 order by t6_f1 limit 2;
select (select t6_f1 from t_subselect_rs_005 limit 1) from t_subselect_rs_006 group by t6_f1 having t6_f1 > 1 order by t6_f1 limit 2;
select (select t5_f1 from t_subselect_rs_005 having t6_f1 > 1 limit 1) from t_subselect_rs_006 group by t6_f1 having t6_f1 > 6 order by t6_f1 limit 2;
--pivot+unpivot
select (select t5_f3 from t_subselect_rs_005 pivot (avg(t5_f1) for t5_f2 in(1,2)) where t5_f3 = t6_f3 limit 1) from t_subselect_rs_006 order by t6_f1 limit 2;
select (select t5_f3 from t_subselect_rs_005 where t5_f3 = t6_f3 limit 1) from t_subselect_rs_006 pivot (avg(t6_f2) for t6_f2 in(2,3)) order by t6_f1 limit 2;
select (select t5_f3 from t_subselect_rs_005 pivot (avg(t5_f1) for t5_f2 in(1,2)) where t5_f3 = t6_f3 limit 1) from t_subselect_rs_006 pivot (avg(t6_f2) for t6_f2 in(2,3)) order by t6_f1 limit 2;
select (select aaa||t6_f1 from t_subselect_rs_005 unpivot (aaa for bbb in(t5_f1,t5_f2,t5_f3)) limit 1) from t_subselect_rs_006 order by t6_f1 limit 2;
select (select t5_f1 + t6_f2 from t_subselect_rs_005 limit 1) from t_subselect_rs_006 unpivot (aaa for bbb in(t6_f1)) order by bbb limit 2;
--subselect
select (select * from (select t5_f1 from t_subselect_rs_005) t5 where t5.t5_f1 = t6_f1) from t_subselect_rs_006 order by t6_f1 limit 2;
select (select * from (select t5_f1 from t_subselect_rs_005) t5 where t5.t5_f1 = t6_f1) from t_subselect_rs_006 where t6_f1 = 10 order by t6_f1 limit 2;
select (select * from (select t5_f1 from t_subselect_rs_005) t5 where t5.t5_f1 = t6_f1) from t_subselect_rs_006 where t6_f1 > 10 order by t6_f1 limit 2;
select * from (select (select * from (select t5_f1 from t_subselect_rs_005) t5 where t5.t5_f1 = t6_f1) from t_subselect_rs_006 order by t6_f1) limit 2;
--transfom
--distinct column eliminate
select distinct t6_f1,aaa from (select distinct t6_f1, (select t5_f1 from t_subselect_rs_005 where t5_f1 = t6_f1) aaa from t_subselect_rs_006 order by 1) limit 2;
select distinct t6_f1,aaa from (select distinct t6_f1, (select t5_f1 from t_subselect_rs_005 where t5_f1 > t6_f1 order by t5_f1 desc limit 1) aaa from t_subselect_rs_006 order by t6_f1 desc) limit 2;
select distinct t6_f1,aaa,rownum from (select distinct t6_f1, (select t5_f1 from t_subselect_rs_005 where t5_f1 > t6_f1  limit 1) aaa from t_subselect_rs_006 order by t6_f1%7 desc, t6_f1) limit 10;
select (select t5_f1 from t_subselect_rs_005 where t5_f1 > t6_f1  limit 1) aaa from (select distinct t6_f1 from (select distinct t6_f1 from t_subselect_rs_006 )) t6 left join t_subselect_rs_004 t4 on t6.t6_f1 = t4.t4_f1  order by t6_f1%7 desc limit 2;
--project column eliminate
select (select t5_f1 from t_subselect_rs_005 where t5_f1 < t6_f1 limit 1) from (select t6_f1,t6_f2 from t_subselect_rs_006) t6 left join t_subselect_rs_004 t4 on t6.t6_f1 = t4.t4_f1 order by t6_f1 limit 2;
--sub-select table eliminate
select (select t5_f1 from t_subselect_rs_005 where t5_f1 < t6_f1 limit 1) from (select * from (select * from t_subselect_rs_006)) t6 left join t_subselect_rs_004 t4 on t6.t6_f1 = t4.t4_f1 order by t6_f1 limit 2;
select (select t5_f1 from t_subselect_rs_005 where t5_f1 < t6_f1 limit 1) from (select * from (select /*+use_nl*/ * from t_subselect_rs_006,t_subselect_rs_001)) t6 left join t_subselect_rs_004 t4 on t6.t6_f1 = t4.t4_f1 order by t6_f1 limit 2;
select (select t5_f1 from t_subselect_rs_005 where t5_f1 <= t6_f1 limit 1) from (select * from (select /*+use_nl*/ * from t_subselect_rs_006,t_subselect_rs_001)) t6 left join t_subselect_rs_004 t4 on t6.t6_f1 = t4.t4_f1 order by t6_f1 limit 2;
--order by push down
select (select t5_f1 from t_subselect_rs_005 where t5_f1<t6_f1 limit 1) from (select * from t_subselect_rs_006 order by t6_f1 desc) order by t6_f2 asc limit 10;
explain select (select t5_f1 from t_subselect_rs_005 where t5_f1<t6_f1 limit 1) from (select * from t_subselect_rs_006 order by t6_f1 desc) order by t6_f2 asc limit 10;
alter system set _OPTIM_ORDER_BY_PLACEMENT=false;
explain select (select t5_f1 from t_subselect_rs_005 where t5_f1<t6_f1 limit 1) from (select * from t_subselect_rs_006 order by t6_f1 desc) order by t6_f2 asc limit 10   ;
alter system set _OPTIM_ORDER_BY_PLACEMENT=true;
--transform in to exist
select (select t5_f1 from t_subselect_rs_005 where t5_f1<t6_f1 limit 1) from t_subselect_rs_006 where t6_f1 in (select t4_f1 from t_subselect_rs_004) order by t6_f2 asc limit 10;
--sub-select optimizer
select (select t5_f1 from t_subselect_rs_005 where t5_f1<t6_f1 limit 1) from t_subselect_rs_006 where t6_f1 = (select max(t4_f1) from t_subselect_rs_004 ) order by t6_f2 asc;
SELECT * FROM t_subselect_rs_004 T4 WHERE EXISTS( SELECT t6.t6_f1, t5.t5_f2 FROM t_subselect_rs_006 t6, t_subselect_rs_005 t5 
WHERE t6.t6_f2 = t5.t5_f1 AND t5.t5_f2 = t4.t4_f1 AND t6.t6_f3 < (SELECT 0.2 * sum(t6.t6_f3) FROM t_subselect_rs_006 t6 WHERE t6.t6_f2 = t5.t5_f1)) limit 2;
--variant sub-select optimizer/cannot
 select (select t4_f1+t5_f1 from t_subselect_rs_004 where t4_f1 = t5_f1) from (SELECT t6.t6_f1, t6.t6_f2,t5_f1,t5.t5_f2
             FROM t_subselect_rs_006 t6, t_subselect_rs_005 t5
            WHERE t6.t6_f1 = t5.t5_f1 AND t6.t6_f3 > (SELECT 0.2 * sum(t6.t6_f3) FROM t_subselect_rs_006 t6 WHERE t6.t6_f1 = t5.t5_f1)) inner join t_subselect_rs_004 order by t5_f1 limit 2;
--cartesian join optimizer
select (select t5_f1 from t_subselect_rs_005 where t5_f1<t6_f1 limit 1) from (select max(t6_f1) t6_f1 from t_subselect_rs_006,t_subselect_rs_004 group by t6_f1) t6 
left join t_subselect_rs_004 t4 on t6.t6_f1=t4.t4_f1 order by t6_f1 asc limit 2;
--eliminate outer join+
select (select t5_f1 from t_subselect_rs_005 where t5_f1<t6_f1 limit 1) from (select max(t6_f1) t6_f1 from t_subselect_rs_006,t_subselect_rs_004 group by t6_f1) t6 
left join t_subselect_rs_004 t4 on t6.t6_f1=t4.t4_f1 order by t6_f1 asc limit 2;
select (select t5_f1 from t_subselect_rs_005 where t5_f1<t6_f2 limit 1) from t_subselect_rs_006 t6 left join t_subselect_rs_004 t4 on t6.t6_f2=t4.t4_f1 order by t6_f2 asc limit 2;
--query condition optimizer
select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f3 limit 1) from t_subselect_rs_005 t5 left join t_subselect_rs_006 t6 on t5.t5_f1 = t6.t6_f2 start with
(select t5_f1 from t_subselect_rs_005 where t5_f1=t6_f2) = 10 connect by prior t5.t5_f1 = t5.t5_f1 + 1 order by t5.t5_f1 limit 2;
--predicate push down
select /*+rule*/ (select t4_f1 from (select t4_f1 + t4_f2 t4_f1 from t_subselect_rs_004) where t4_f1=t5_f3 limit 1) from t_subselect_rs_005 t5 left join t_subselect_rs_006 t6 on t5.t5_f1 = t6.t6_f2 
where t6.t6_f2 < 66 and t5_f3 =15 order by t5.t5_f1 limit 2;
select max(t4_f1) over (partition by t4_f3 order by t4_f2) ,(select t5_f1+max(t5_f1) from (select t5_f1+t5_f2 t5_f1 from t_subselect_rs_005 where t5_f1 = t4_f1) group by t5_f1 limit 1) from t_subselect_rs_004   limit 1;
--sort group optimizer/cannot in one query
select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f3 limit 1) from (select max(t5_f3) t5_f3 from t_subselect_rs_005 group by t5_f1 order by t5_f1) t5 order by t5.t5_f3 limit 2;
select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f2 limit 1),rum from (select avg(t5_f2) t5_f2,rownum rum from t_subselect_rs_005 
group by t5_f1,rownum order by t5_f1,rownum) t5 inner join t_subselect_rs_006 order by t5.t5_f2 limit 1;
--cube group optimizer
select (select max(t5_f2) t5_f2 from t_subselect_rs_005 where t5_f1 <t6_f1 group by cube( t5_f1,t5_f2)  limit 1 offset 1) from t_subselect_rs_006 order by t6_f1 limit 1;
select /*+rule*/ (select t4_f1 from t_subselect_rs_004 where t4_f2=t5_f2 limit 1) from (select max(t5_f2) t5_f2 from t_subselect_rs_005 group by cube( t5_f1,t5_f2)) t5 inner join t_subselect_rs_006 order by t5.t5_f2 limit 2;
drop table t_subselect_rs_001;
drop table t_subselect_rs_002;
drop table t_subselect_rs_003;
drop table t_subselect_rs_004;
drop table t_subselect_rs_005;
drop table t_subselect_rs_006;
DROP TABLE t_subselect_rs_007;

--DTS2020030202338
DROP TABLE IF EXISTS T_CONNECT_BASE_001;
CREATE TABLE T_CONNECT_BASE_001(
       EMP_ID NUMBER(18),
       LEAD_ID NUMBER(18),
       EMP_NAME VARCHAR2(200),
       SALARY NUMBER(10,2),
       DEPT_NO VARCHAR2(8)
);

EXPLAIN SELECT C[1] FROM (SELECT ARRAY[SYS_CONNECT_BY_PATH(EMP_NAME,'/'),EMP_NAME] C FROM T_CONNECT_BASE_001 START WITH EMP_ID=1 CONNECT BY PRIOR EMP_ID = LEAD_ID) ORDER BY 1;
EXPLAIN SELECT C[1] FROM (SELECT ARRAY[SYS_CONNECT_BY_PATH(EMP_NAME,'/'),EMP_NAME] C FROM T_CONNECT_BASE_001 START WITH EMP_ID=1 CONNECT BY PRIOR EMP_ID = LEAD_ID) ORDER BY C[1];
DROP TABLE IF EXISTS T_CONNECT_BASE_001;

drop table if exists t_sort_limit;
create table t_sort_limit(a int, b int, c varchar(20));
commit;

explain select * from t_sort_limit order by b limit 1000;
explain select * from t_sort_limit order by b limit 1001;
alter system set _query_topn_threshold = 0;
explain select * from t_sort_limit order by b limit 1000;
alter system set _query_topn_threshold = 10000;
explain select * from t_sort_limit order by b limit 10000;
alter system set _query_topn_threshold = 10001;
alter system set _query_topn_threshold = 1000;
drop table if exists t_sort_limit;

DROP TABLE IF EXISTS CONTEXT_DATA;
CREATE TABLE CONTEXT_DATA
(
  OBJECT_NAME VARCHAR(64 BYTE) NOT NULL,
  BE_ID NUMBER(10) NOT NULL,
  PARTITION_ID NUMBER(8) NOT NULL,
  DATA_CONTENT CLOB,
  STATUS VARCHAR(1 BYTE),
  CLOB_ID NUMBER(20),
  TENANT_ID NUMBER(20),
  HIS_DATE DATE,
  C_EX_FIELD4 VARCHAR(255 BYTE),
  C_EX_FIELD5 VARCHAR(255 BYTE)
);
INSERT INTO CONTEXT_DATA values('CreateOrderFlowInfoXMLVO',101,1,null,'0',31108,999999,null,null,null);
INSERT INTO CONTEXT_DATA values('Subscription_490000001000014108',101,2,null,'0',35299,999999,null,null,null);
INSERT INTO CONTEXT_DATA values('CreateOrderFlowInfoXMLVO',101,1,null,'0',113004,999999,null,null,null);
INSERT INTO CONTEXT_DATA values('CreateOrderRequestXMLVO',101,1,null,'0',111009,999999,null,null,null);
COMMIT;

SELECT
  REF_0.OBJECT_NAME AS C0,
  REF_0.BE_ID AS C1,
  REF_0.CLOB_ID AS C2,
  REF_0.STATUS AS C3,
  REF_0.C_EX_FIELD4 AS C4,
  REF_0.DATA_CONTENT AS C5
FROM
  CONTEXT_DATA AS REF_0
ORDER BY 
 REF_0.TENANT_ID DESC NULLS LAST, 
 REF_0.TENANT_ID DESC,
 REF_0.C_EX_FIELD5 DESC NULLS FIRST,
 REF_0.DATA_CONTENT DESC NULLS FIRST, 
 REF_0.OBJECT_NAME DESC NULLS FIRST, 
 REF_0.STATUS DESC NULLS FIRST, 
 REF_0.PARTITION_ID DESC NULLS LAST,
 REF_0.TENANT_ID ASC,
 REF_0.STATUS ASC NULLS LAST, 
 REF_0.STATUS ASC, 
 REF_0.HIS_DATE DESC NULLS LAST
LIMIT 1, 1;
DROP TABLE CONTEXT_DATA;

drop table if exists t_sort_lnnvl_alias;
create table t_sort_lnnvl_alias(id int, c_int int);
select id, c_int as c1 from t_sort_lnnvl_alias order by lnnvl(c1);
drop table t_sort_lnnvl_alias;

drop table if exists j1;
drop table if exists j2;
create table j1(a int, b int);
create table j2(a int, b int);
insert into j1 values(1,2),(2,3),(3,3),(4,3);
insert into j2 values(1,2),(2,2),(3,2),(4,3);
commit;
create index j1i on j1(a);
select count(a) from j1 where a in (select max(a) from j2 group by b order by abs(b));
select count(a) from j1 where a in (select max(a) from j2 group by b order by abs(b) limit 1);
select a from j1 where a in (select min(b) from j2 group by a order by a limit 2) ;
select * from j1 where rowid in (select rowid from j1 connect by nocycle prior a = b order by rowid limit 3);
drop table j1;
drop table j2;

DROP TABLE  if exists  merge_test_vchar_big;
create table merge_test_vchar_big
(
  emp_id VARCHAR2(8000)
);

DECLARE
vchar_big VARCHAR2(8000) := DBE_RANDOM.GET_STRING('l', 8000);
begin
for i in 0 .. 63 loop
  insert into merge_test_vchar_big(emp_id) values(DBE_LOB.SUBSTR(vchar_big, 8000 - i, 1));
end loop; 
end;
/
select MOD(LENGTH(emp_id),7) from merge_test_vchar_big order by emp_id;
DROP TABLE merge_test_vchar_big;

-- order siblings by select node cannot be pushed down
drop table if exists connect_push_down_t1;
drop table if exists connect_push_down_t2;
create table connect_push_down_t1(c1 int, c2 int);
create table connect_push_down_t2(c1 int, c2 int);

explain
select
	(select c1 from connect_push_down_t1 limit 1) as c0
from
	(
	select
		cast(ref_0.c1 as number(20, 0)) as c0,
		cast('273047 12:16:7' as interval day to second(6)) as c1,
		cast('957064 21:48:39' as interval day to second) as c3,
		cast(ref_0.c1 as number(20, 0)) as c4
	from
		connect_push_down_t2 as ref_0
	) as subq_0
where
	(select c2 from connect_push_down_t2 limit 1) = subq_0.c0
connect by
	subq_0.c4 = prior subq_0.c0
order siblings by 
    (select c2 from connect_push_down_t1 limit 1), 1, 1 desc;

drop table connect_push_down_t1;
drop table connect_push_down_t2;

drop table if exists nested_aggr_t;
create table nested_aggr_t(col_1 int, col_2 int);
insert into nested_aggr_t values(1,1);
insert into nested_aggr_t values(2,2);

select col_1, group_concat(col_2) c2 from nested_aggr_t group by col_1 order by group_concat(c2);
select col_1, cume_dist(1) within group (order by col_1 desc) c2 from nested_aggr_t group by col_1 order by cume_dist(1) within group (order by c2 desc);
select sum(col_1) over() c1 from nested_aggr_t order by sum(c1) over();
drop table nested_aggr_t;