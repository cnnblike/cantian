drop table if exists t_wmagic_1;
drop table if exists t_wmagic_2;
drop table if exists t_wmagic_3;
create table t_wmagic_1(f_int1 int, f_int2 int, f_char char(32), f_vchar varchar(32), f_real real);
create table t_wmagic_2(f_int1 int, f_int2 int, f_char char(32), f_vchar varchar(32), f_real real);
create table t_wmagic_3(f_int1 int, f_int2 int, f_char char(32), f_vchar varchar(32), f_real real);

--Can not WinMagic Rewrite
EXPLAIN
SELECT * FROM t_wmagic_3 T3 WHERE EXISTS
(
 SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
		   AND t2.f_char = t3.f_char
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1)
);

EXPLAIN
SELECT distinct t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1);
						   
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
		   AND t2.f_vchar = (select max(t3.f_vchar) from t_wmagic_3 t3)
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1);
						   
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1)
		   order by t2.f_char;
		   
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1)
		   group by t2.f_char, t1.f_char;
		   
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1)
		   limit 100;
		   
EXPLAIN
SELECT t1.f_char, t2.f_char, sum(t1.f_real) over(partition by t2.f_vchar)
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1);
						   
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1 left join t_wmagic_2 t2 on t1.f_int1 = t2.f_int1
         WHERE t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1);
						   
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1)
		   AND rownum > 0;

EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
		   AND (t2.f_int2 = 10 or t2.f_int2 = 100)
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1);
						   
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
		   AND t1.f_int2 = 10
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1);

EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                            WHERE t1.f_int1 = t2.f_int1
						    union
						    SELECT 0.2 * sum(t1.f_int2)
                             FROM t_wmagic_1 t1
                            WHERE t1.f_int1 = t2.f_int1);
						   
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
		   AND t1.f_int2 = t2.f_int2
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1
						     AND t1.f_int2 = t2.f_int2);
							 
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)+t2.f_real
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1);

EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1 and rownum >0);

EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t3.f_real)
                            FROM t_wmagic_3 t3
                           WHERE t3.f_int1 = t2.f_int1);						   

EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(distinct t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1);
						   
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t2.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1);
						   
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
		   AND t1.f_int1 = 100
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = 100);
						   
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int2 = t2.f_int2);
						   
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1
						     AND t1.f_int2 = 100);
							 
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
		   AND t1.f_int2 = 50
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1
						     AND t1.f_int2 = 100);
							 
EXPLAIN
SELECT t1.f_char, t2.f_char, t3.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2, t_wmagic_3 t3
         WHERE t1.f_int1 = t2.f_int1
		   AND t1.f_int2 = t3.f_int2
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1, t_wmagic_3 t3
                           WHERE t1.f_int1 = t2.f_int1
						     AND t1.f_int2 = t3.f_int2);
--Can WinMagic Rewrite
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1);
alter system set _optim_winmagic_rewrite = false;
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1)  ;
alter system set _optim_winmagic_rewrite = true;					   

EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
		   AND t2.f_int2 > 100
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1);
						   
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
		   AND t1.f_int2 > 100
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1
						     AND t1.f_int2 > 100);
							 
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
		   AND t2.f_real > 55.5
		   AND t1.f_int2 > 100
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1
						     AND t1.f_int2 > 100);
							 
create index idx_t_wmagic_2_1 on t_wmagic_2(f_int1);
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1);
						   
EXPLAIN
SELECT t1.f_char, t2.f_char
          FROM t_wmagic_1 t1, t_wmagic_2 t2
         WHERE t1.f_int1 = t2.f_int1
           AND t1.f_real < (SELECT 0.2 * sum(t1.f_real)
                            FROM t_wmagic_1 t1
                           WHERE t1.f_int1 = t2.f_int1 limit 2);

drop table if exists t_wmagic_1;
drop table if exists t_wmagic_2;
drop table if exists t_wmagic_3;

--DTS2019080912008
drop table if exists BMSQL_CUSTOMER;
drop table if exists BMSQL_STOCK;
drop view if exists view_BMSQL_CUSTOMER;

create table BMSQL_CUSTOMER
(
C_W_ID         INTEGER,
C_D_ID         INTEGER,
C_ID           INTEGER,
C_DISCOUNT     NUMBER(4, 4),
C_CREDIT       CHAR(2 BYTE),
C_LAST         VARCHAR(16 BYTE),
C_FIRST        VARCHAR(16 BYTE),
C_CREDIT_LIM   NUMBER(12, 2),
C_BALANCE      NUMBER(12, 2),
C_YTD_PAYMENT  NUMBER(12, 2),
C_PAYMENT_CNT  INTEGER,
C_DELIVERY_CNT INTEGER,
C_STREET_1     VARCHAR(20 BYTE),
C_STREET_2     VARCHAR(20 BYTE),
C_CITY         VARCHAR(20 BYTE),
C_STATE        CHAR(2 BYTE),
C_ZIP          CHAR(9 BYTE),
C_PHONE        CHAR(16 BYTE),
C_SINCE        TIMESTAMP(6),
C_MIDDLE       CHAR(2 BYTE),
C_DATA         VARCHAR(500 BYTE)
);

create table BMSQL_STOCK
(
S_W_ID         INTEGER,
S_I_ID         INTEGER,
S_QUANTITY     INTEGER,
S_YTD          INTEGER,
S_ORDER_CNT    INTEGER,
S_REMOTE_CNT   INTEGER,
S_DATA         VARCHAR(50 BYTE),
S_DIST_01      CHAR(24 BYTE),
S_DIST_02      CHAR(24 BYTE),
S_DIST_03      CHAR(24 BYTE),
S_DIST_04      CHAR(24 BYTE),
S_DIST_05      CHAR(24 BYTE),
S_DIST_06      CHAR(24 BYTE),
S_DIST_07      CHAR(24 BYTE),
S_DIST_08      CHAR(24 BYTE),
S_DIST_09      CHAR(24 BYTE),
S_DIST_10      CHAR(24 BYTE)
);

create or replace view view_BMSQL_CUSTOMER as select distinct * from BMSQL_CUSTOMER;

explain
select sum(C_CREDIT_LIM)/7.0 as avg_C_CREDIT_LIM
from view_BMSQL_CUSTOMER,BMSQL_STOCK
where C_W_ID=S_W_ID
and S_DIST_07='iI0jh8oBJz1r4v7mxF5CtY1c'
and S_DIST_01='dc9c7RuJDCVJikkS93DnS2j7'
and C_ID<(select max(C_D_ID)
		  from view_BMSQL_CUSTOMER
		  where C_W_ID=S_W_ID);
		  
drop table if exists BMSQL_CUSTOMER;
drop table if exists BMSQL_STOCK;
drop view if exists view_BMSQL_CUSTOMER;