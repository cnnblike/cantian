drop table if exists customer1;
create table customer1
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
) ;
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
    i_brand_id                double                       ,
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
    i_units                   char(20)                      ,
    i_container               char(10)                      ,
    i_manager_id              integer                       ,
    i_product_name            char(50)
);
explain select substr(c_current_cdemo_sk, length(c_current_cdemo_sk) - 3, 1),
substr(c_current_cdemo_sk, -7, 2) a,
substr((substr(max(c_current_cdemo_sk), -3, 5)),
substr(c_current_cdemo_sk, -7, 1),
2),
substr((substr((substr(c_current_cdemo_sk, -3, 5)),
substr(c_current_cdemo_sk, -7, 1),
2)),
2)
from customer1
inner join item
on substr(c_current_cdemo_sk, -7, 2) = c_birth_day
where trim(c_customer_id, 'A') like '%OPO%'
and c_current_cdemo_sk ::numeric * c_current_hdemo_sk is not null
group by c_current_cdemo_sk
order by 1, 2, 3, 4;
drop table if exists item;
drop table if exists customer1;
drop table if exists test_explain1;
drop table if exists test_explain2;
drop table if exists test_explain3;
drop table if exists test_explain4;
create table test_explain1(f1 int, f2 int);
create table test_explain2(f1 int, f2 int);
create table test_explain3(f1 int, f2 int);
create table test_explain4(f1 int, f2 int)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30)
);

-- explain [plan for]
explain p select 1 from dual;
explain plan f select 1 from dual;
explain plan for select 1 from dual;
explain select 1 from dual;

-- explain [plan binding parameters]
explain select * from dual where 1 > :1;

--test push down cond
explain plan for select *
  from (
  select distinct f1
          from (select distinct test_explain1.f1
                  from test_explain1, test_explain2) t1
         where t1.f1 in (select f1 from test_explain3)
         ) t2;

-- explain select
explain plan for select 1 from dual where not exists (select f1 from test_explain1 where test_explain1.f1 = 0);
explain plan for select 1 from dual where exists (select f1 from test_explain1 where test_explain1.f1 = 0);
explain plan for select distinct f1,f2 from test_explain1 where f1=1 and f2=2 group by f1, f2 having f1=1 and f2=2 order by f1 asc, f2 desc;
explain plan for select * from test_explain1 union select * from test_explain2;
explain plan for select * from (select * from test_explain1 union all select * from test_explain2);
explain plan for select count(*) from test_explain1;
explain plan for select * from test_explain1 where rowid in (to_char('000863641600000'), to_char('000863641700000'), to_char('000863641700000'), to_char('000863641700000'), to_char('000863641600000'), to_char('000863641800000'), to_char('000863642700000'));
explain plan for select * from test_explain1 union all select * from test_explain2 limit 10;
-- explain insert
explain plan for insert into test_explain1(f1) select 1 from dual where exists (select f1 from test_explain1 where test_explain1.f1 = 0);
explain plan for insert into test_explain1(f1, f2) values(1, 2);
explain plan for insert into test_explain1 select distinct f1,f2 from test_explain2 where f1=1 and f2=2 group by f1, f2 having f1=1 and f2=2 order by f1 asc, f2 desc;
explain plan for insert into test_explain1 select * from test_explain2 union select * from test_explain3;
explain plan for insert into test_explain1 select * from (select * from test_explain2 union all select * from test_explain3);
explain plan for insert into test_explain4 values(1,1);
explain plan for insert into test_explain4 values(40,40);
explain plan for insert into test_explain4 select * from test_explain1;

-- explain delete
explain plan for delete from test_explain1 where f1=1 and f2=2;
explain plan for delete from test_explain1 where f1=(select f1 from test_explain2 union select f1 from test_explain3) and f2=(select f2 from test_explain2);
explain plan for delete from test_explain1 order by f1;
explain plan for delete from test_explain1 limit 3;
explain plan for delete from test_explain1 order by f1 limit 3;
explain plan for delete t1,t2 from test_explain1 t1 join test_explain2 t2 on t1.f1=t2.f1 order by t1.f1 limit 3;
-- explain update
explain plan for update test_explain1 set f1=1, f2=2 where f1=1 and f2=2;
explain plan for update test_explain1 set f1=(select f1 from test_explain2 union select f1 from test_explain3), f2=(select f2 from test_explain2) where f1=(select f1 from test_explain2 union select f1 from test_explain3) and f2=(select f2 from test_explain2);

-- explain view
drop view if exists test_explain_view1;
drop view if exists test_explain_view2;
drop view if exists test_explain_view3;
create view test_explain_view1 as select distinct f1,f2 from test_explain1 where f1=1 and f2=2 group by f1, f2 having f1=1 and f2=2 order by f1 asc, f2 desc;
create view test_explain_view2 as select * from test_explain1 union select * from test_explain2;
create view test_explain_view3 as select * from (select * from test_explain1 union all select * from test_explain2);
explain plan for select * from test_explain_view1;
explain plan for select * from test_explain_view2 union select * from test_explain_view3;
explain plan for insert into test_explain1 select * from test_explain_view1;
explain plan for insert into test_explain1 select * from test_explain_view2 union select * from test_explain_view3;

--test pasre rowid
explain plan for select t1.rowid from test_explain1 t1;

-- explain replace into
drop table if exists test_explain5;
create table test_explain5(
id int ,
col_char1 varchar(30),
col_char2 varchar(40),
col_char3 varchar(40)
);
alter table test_explain5 add constraint test_explain5_pk1 primary key(id ,col_char1);
alter table test_explain5 add constraint test_explain5_pk2 UNIQUE(col_char3);
alter table test_explain5 add constraint test_explain5_pk3 UNIQUE(col_char1);
explain plan for replace into test_explain5 set id = 1,col_char1 ='a',col_char2='b',col_char3='ABCDEFG';
explain replace into test_explain5 select * from test_explain5 where id = 1 and col_char1 ='a' and col_char2='b' and col_char3='ABCDEFG';

-- support length of explain more than one package
drop table if exists bmsql_stock;
create table bmsql_stock (
  s_w_id       integer       not null,
  s_i_id       integer       not null,
  s_quantity   integer,
  s_ytd        integer,
  s_order_cnt  integer,
  s_remote_cnt integer,
  s_data       varchar(50),
  s_dist_01    char(24),
  s_dist_02    char(24),
  s_dist_03    char(24),
  s_dist_04    char(24),
  s_dist_05    char(24),
  s_dist_06    char(24),
  s_dist_07    char(24),
  s_dist_08    char(24),
  s_dist_09    char(24),
  s_dist_10    char(24)
);
alter table bmsql_stock add constraint bmsql_stock_pkey
  primary key (s_w_id, s_i_id);

drop table if exists bmsql_district;
create table bmsql_district (
  d_w_id       integer       not null,
  d_id         integer       not null,
  d_ytd        decimal(12,2),
  d_tax        decimal(4,4),
  d_next_o_id  integer,
  d_name       varchar(10),
  d_street_1   varchar(20),
  d_street_2   varchar(20),
  d_city       varchar(20),
  d_state      char(2),
  d_zip        char(9)
);
alter table bmsql_district add constraint bmsql_district_pkey
  primary key (d_w_id, d_id);

drop table if exists bmsql_order_line;
create table bmsql_order_line (
  ol_w_id         integer   not null,
  ol_d_id         integer   not null,
  ol_o_id         integer   not null,
  ol_number       integer   not null,
  ol_i_id         integer   not null,
  ol_delivery_d   timestamp,
  ol_amount       decimal(6,2),
  ol_supply_w_id  integer,
  ol_quantity     integer,
  ol_dist_info    char(24)
);
alter table bmsql_order_line add constraint bmsql_order_line_pkey
  primary key (ol_w_id, ol_d_id, ol_o_id, ol_number);

explain 
select count(*) from 
(
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
	union all 
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
	union 
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
	minus 	
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
	union 
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
	union all 
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
	union 
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
	minus 	
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
);

explain 
insert into test_explain1(f1) 
select count(*) from 
(
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
	union all 
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
	union 
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
	minus 	
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
	union 
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
	union all 
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
	union 
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
	minus 	
	SELECT count(*) AS low_stock FROM 
	(
		SELECT s_w_id, s_i_id, s_quantity 
			FROM bmsql_stock
			WHERE s_w_id = 2 AND s_quantity < 11 AND s_i_id IN (
				SELECT ol_i_id 
					FROM bmsql_district 
					JOIN bmsql_order_line ON ol_w_id = d_w_id 
					 AND ol_d_id = d_id 
					 AND ol_o_id >= d_next_o_id - 20 
					 AND ol_o_id < d_next_o_id 
					WHERE d_w_id = 2 AND d_id = 2 
			) 
	)
);

drop table if exists explain_t1;
drop table if exists explain_t2;
drop table if exists explain_t3;
create table explain_t1(a int, b int);
create table explain_t2(f1 int, f2 int);
create table explain_t3(f3 int, f4 int);
explain plan for select a from explain_t1 where a in (select f1 from explain_t2);
explain plan for select a from explain_t1 where a not in (select f1 from explain_t2);
explain plan for select * from explain_t1 where exists(select f1 from explain_t2);
explain plan for select a from explain_t1 where exists(select * from explain_t2) group by a having a in (select f3 from explain_t3);
explain plan for select * from (select a from explain_t1 where b=(select f1 from explain_t2));
explain plan for select a from explain_t1 where b=(select f1 from explain_t2);
explain plan for select a from explain_t1 where (select f1 from explain_t2)=b;
explain plan for select * from explain_t1 where exists(select f1 from explain_t2 GROUP BY f1 HAVING f1 IN (select f3 from explain_t3));
explain plan for  select * from explain_t1 where A = 1 + (select f1 from explain_t2);
explain plan for select t.a, (select f1 from explain_t2) from explain_t1 t;
explain plan for select t.a, (case when exists(select f1 from explain_t2 where f1 = 1) then 1 end) from explain_t1 t;
explain plan for select t.a  from explain_t1 t where t.b = (case when exists(select f1 from explain_t2 where f1 = 1) then 1 end);
explain plan for select t.a  from explain_t1 t where t.a = (select f1 from explain_t2) - 1;
explain plan for select t.a  from explain_t1 t where t.a = (select f1 from explain_t2 where f2 = (select f3 from explain_t3)) + 1;
explain plan for delete from explain_t1 where a = (select f1 from explain_t2 where f1 = (select f3 from explain_t3));
explain plan for update explain_t1 set a = 1 where b = (select f1 from explain_t2 where f1 = (select f3 from explain_t3));
explain plan for update explain_t1 set a = 1 where b = (select f1 from explain_t2 where f1 = 1);
explain plan for update explain_t1 set a = (select f3 from explain_t3) where b = 1;
explain plan for update explain_t1 set a = (select f3 from explain_t3) where b = (select f1 from explain_t2 where f1 = 1);
explain plan for merge into explain_t1 using (select * from explain_t2 where f1 = (select f3 from explain_t3)) tt2 on (explain_t1.a = tt2.f1) 
when matched then update set b = tt2.f2 + 1 where tt2.f2 = 2;
EXPLAIN PLAN FOR MERGE INTO explain_t1 USING explain_t2 ON (explain_t1.a = explain_t2.f1)
WHEN MATCHED THEN UPDATE SET b = (select f1 from explain_t1) WHERE explain_t2.f2 = (select f3 from explain_t3);
explain plan for merge into explain_t1 using explain_t2 on (explain_t1.a = explain_t2.f1)
when matched then update set b = (select f1 from explain_t2) where explain_t2.f2 = (select f3 from explain_t3)
when not matched then insert (a, b) values (explain_t2.f1, explain_t2.f1) where explain_t2.f1 = (select f3 from explain_t3);

EXPLAIN PLAN FOR
SELECT I.NAME, M.USER_NAME, T.NAME, NULL::VARCHAR(64), NULL::NUMBER,
'TABLE', I.BLEVEL, I.LEVEL_BLOCKS, I.DISTINCT_KEYS, I.AVG_LEAF_BLOCKS_PER_KEY, I.AVG_DATA_BLOCKS_PER_KEY,
NULL::NUMBER, T.SAMPLESIZE, T.ANALYZETIME
FROM SYS.V$ME M JOIN SYS.SYS_TABLES T ON T.USER# = M.USER_ID
JOIN SYS.SYS_INDEXES I ON T.USER# = I.USER# AND T.ID = I.TABLE#
UNION ALL
SELECT IP.NAME, M.USER_NAME, T.NAME, TP.NAME,
ROW_NUMBER() OVER (PARTITION BY TP.USER#, TP.TABLE# ORDER BY TP.PART#),
'PARTITION', IP.BLEVEL, IP.LEVEL_BLOCKS, IP.DISTKEY, IP.LBLKKEY, IP.DBLKKEY,
NULL::NUMBER, TP.SAMPLESIZE, TP.ANALYZETIME
FROM SYS.V$ME M JOIN SYS.SYS_TABLES T ON T.USER# = M.USER_ID
JOIN SYS.SYS_TABLE_PARTS TP ON T.USER# = TP.USER# AND T.ID = TP.TABLE#
JOIN SYS.SYS_INDEX_PARTS IP ON TP.USER# = IP.USER# AND TP.TABLE# = IP.TABLE# AND TP.PART# = IP.PART#;
EXPLAIN PLAN FOR
SELECT U.NAME, T.NAME, C.NAME, ROW_NUMBER() OVER (PARTITION BY T.NAME, C.NAME ORDER BY H.BUCKET), H.ENDPOINT, H.BUCKET
FROM SYS.SYS_USERS U JOIN SYS.SYS_TABLES T ON T.USER# = U.ID
JOIN SYS.SYS_COLUMNS C ON T.USER# = C.USER# AND T.ID = C.TABLE#
JOIN SYS.SYS_HISTGRAM H ON C.USER# = H.USER# AND C.TABLE# = H.TABLE# AND C.ID = H.COL#;

drop table if exists WF_T_TASKTALK;
drop table if exists WF_T_PROCESSINSTANCE;
drop table if exists tm_t_jhseattrack;
drop table if exists TM_T_JHSEATTRACK_TELESALE;
create table WF_T_TASKTALK
(
  talkid            VARCHAR2(30) not null,
  taskid            VARCHAR2(30),
  activityid        VARCHAR2(30),
  nodeid            VARCHAR2(30),
  comid             VARCHAR2(8) not null,
  inserttimeforhis  DATE,
  operatetimeforhis DATE,
  updatercode       VARCHAR2(20),
  comcode           VARCHAR2(8),
  contactid         VARCHAR2(50),
  clienttype        VARCHAR2(10) default '-1',
  processid         VARCHAR2(30),
  piid              VARCHAR2(30)
);
create index IDX_TASKTALK_ACTIVITYID on WF_T_TASKTALK (ACTIVITYID);
create index IDX_TASKTALK_PIID on WF_T_TASKTALK (PIID);
create index IDX_TASKTALK_PROCESSID on WF_T_TASKTALK (PROCESSID);
create index IDX_TASKTALK_TASKID on WF_T_TASKTALK (TASKID);
alter table WF_T_TASKTALK add constraint PK_WF_T_TASKTALK primary key (TALKID, COMID) using index pctfree 10;

create table WF_T_PROCESSINSTANCE
(
  piid                  VARCHAR2(30) not null,
  processid             VARCHAR2(30),
  activityid            VARCHAR2(30),
  validstatus           VARCHAR2(10),
  finishstatus          VARCHAR2(10),
  closestatus           VARCHAR2(10),
  inserttimeforhis      DATE,
  starttime             DATE,
  endtime               DATE,
  creatorcode           VARCHAR2(30),
  updatercode           VARCHAR2(30),
  updatetimeforhis      DATE,
  comid                 VARCHAR2(8),
  comcode               VARCHAR2(8),
  nextoperatorcode      VARCHAR2(30),
  tasktargetid          VARCHAR2(30),
  tasktargettype        VARCHAR2(10),
  activitybatch         NUMBER,
  batchtime             DATE,
  title                 VARCHAR2(100),
  assignstatus          VARCHAR2(2),
  claimstatus           VARCHAR2(2),
  custid                VARCHAR2(30),
  currentoperatorcode   VARCHAR2(30),
  tasktracestatusreason VARCHAR2(200),
  tasktracestatus       VARCHAR2(20),
  operatetimeforhis     DATE,
  customercname         VARCHAR2(200),
  statustype            VARCHAR2(2),
  licenseno             VARCHAR2(40),
  carid                 VARCHAR2(30),
  policyno              VARCHAR2(30),
  enddate               DATE,
  monthday              VARCHAR2(8),
  carstatus             VARCHAR2(2),
  managername           VARCHAR2(300),
  enrolldate            DATE,
  policycomcode         VARCHAR2(24),
  monopolycode          VARCHAR2(40),
  uniqassist            VARCHAR2(30),
  reservationstatus     VARCHAR2(1),
  lastestcontacttime    DATE,
  lastestremarktime     DATE
);
create index IDX_PROCESSINSTANCE_ACTIV7 on WF_T_PROCESSINSTANCE (ACTIVITYID);
create index IDX_PROCESSINSTANCE_CUSTID7 on WF_T_PROCESSINSTANCE (CUSTID);
create index IDX_PROCESSINSTANCE_PROCID7 on WF_T_PROCESSINSTANCE (PROCESSID);
create index IDX_PROCESSINST_NEXTOPR7 on WF_T_PROCESSINSTANCE (NEXTOPERATORCODE);
create index IDX_PROCESSINST_TATID7 on WF_T_PROCESSINSTANCE (TASKTARGETID);
create index IDX_PROCESSINST_TRACESTATUS7 on WF_T_PROCESSINSTANCE (TASKTRACESTATUS);
create index IDX_PROCESSINST_UPDATER7 on WF_T_PROCESSINSTANCE (UPDATERCODE);
create unique index IDX_UNIQ_PROCESSINSTANCE7 on WF_T_PROCESSINSTANCE (TASKTARGETID, ACTIVITYID, UNIQASSIST, COMID);
alter table WF_T_PROCESSINSTANCE add constraint PK_WF_T_PROCESSINSTANCE_7 primary key (PIID) using index  pctfree 10;

create table tm_t_jhseattrack 
(
  calltrackid       VARCHAR2(30) not null,
  miscallid         VARCHAR2(30),
  ucid              VARCHAR2(309),
  recordid          VARCHAR2(200),
  starttime         DATE,
  endtime           DATE,
  operatorcode      VARCHAR2(50),
  intervaltime      NUMBER,
  type              VARCHAR2(1),
  seattelephone     VARCHAR2(30),
  custtelephone     VARCHAR2(30),
  qualityflag       VARCHAR2(2),
  validstatus       VARCHAR2(1),
  comid             VARCHAR2(8) not null,
  creatorcode       VARCHAR2(50),
  inserttimeforhis  DATE,
  updatercode       VARCHAR2(50),
  operatetimeforhis DATE,
  recordobtainflag  VARCHAR2(1),
  suppliercode      VARCHAR2(10),
  comcode           VARCHAR2(10),
  usercode          VARCHAR2(50),
  longdistanceflag  VARCHAR2(1),
  source            VARCHAR2(1),
  seatcode          VARCHAR2(30),
  ringtime          DATE,
  callresult        VARCHAR2(8),
  exeremk           VARCHAR2(100), -- 
  customercname     VARCHAR2(200),   
  licenseno         VARCHAR2(40),  
  enddate           DATE,
  taskid            VARCHAR2(30),
  activityid        VARCHAR2(30),
  nodeid            VARCHAR2(30),
  clienttype        VARCHAR2(10) default '-1',
  processid         VARCHAR2(30),
  piid              VARCHAR2(30),
  tradeStatus       VARCHAR2(20),
  tradeStatusReason VARCHAR2(50)
);

create table TM_T_JHSEATTRACK_TELESALE
(
  calltrackid VARCHAR2(30) not null,
  comid varchar(30)
);

alter table TM_T_JHSEATTRACK_TELESALE add constraint PK_TM_T_JHSEATTRACKTELESALE primary key (CALLTRACKID) using index pctfree 10 initrans 2;

explain update tm_t_jhseattrack a
   set (a.customercname,
        a.licenseno,
        a.enddate,
        a.taskid,
        a.activityid,
        a.nodeid,
        a.clienttype,
        a.processid,
        a.piid) =
       (select c.customercname,
               c.licenseno,
               c.enddate,
               x.taskid,
               x.activityid,
               x.nodeid,
               x.clienttype,
               x.processid,
               x.piid
          from wf_t_tasktalk x, wf_t_processinstance c
         where a.calltrackid = x.talkid
           and c.piid = x.piid
           and c.comid = x.comid);

explain insert into tm_t_jhseattrack_telesale(calltrackid,comid) values((select t.calltrackid from tm_t_jhseattrack t where t.calltrackid='#{calltrackid}' and t.starttime<t.endtime and not exists(select 1 from tm_t_jhseattrack_telesale ts where ts.calltrackid='#{calltrackid}')),'#{comid}');

--INDEX UNIQUE SCAN
drop table if exists test_index_scan;
create table test_index_scan(id int not null,c_int int,c_varchar varchar(20));
alter table test_index_scan add constraint ind_001 primary key(c_int);
explain select * from test_index_scan where c_int = 1;

drop table if exists um_t_user;
drop table if exists um_t_teamuser;

create table um_t_user(usercode int, username varchar(64));
create table um_t_teamuser(usercode int, username varchar(64));
explain select * from um_t_user u left join um_t_teamuser tu on tu.usercode = u.usercode where u.usercode = '111' and (u.usercode = '222' or (1 = 0));


drop table if exists t_join_base_001;
drop table if exists t_join_base_002;
drop table if exists t_join_base_101;
 
create table t_join_base_001(
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
insert into t_join_base_001 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-01-01 10:51:47.123456'),'yyyy-mm-dd hh24:mi:ss.FF6'));
insert into t_join_base_001 values(0,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
create table t_join_base_002 as select * from t_join_base_001;
create table t_join_base_101 as select * from t_join_base_001;

explain plan for select count(*) from t_join_base_001 t1 join t_join_base_002 t2 on t1.id=t2.id where exists(select * from t_join_base_101 t11 where (select t11.c_number+1 from dual)=t1.c_number and (select t11.c_int+1 from dual)=t1.c_int and t11.c_vchar=t1.c_vchar and t11.c_timestamp=t1.c_timestamp);

drop table if exists t_join_base_001;
drop table if exists t_join_base_002;
drop table if exists t_join_base_101;


drop table if exists tbl_explain_hash;
drop table if exists tbl_explain_interval;
drop table if exists tbl_explain_list;
create table tbl_explain_hash(
col_int int,
col_integer integer,
col_BINARY_INTEGER BINARY_INTEGER,
col_smallint smallint not null default '7',
col_bigint bigint not null default '3',
col_BINARY_BIGINT BINARY_BIGINT,
col_real real,
col_double double,
col_float float,
col_BINARY_DOUBLE BINARY_DOUBLE,
col_decimal decimal,
col_number1 number,
col_number2 number(38),
col_number3 number(38,-84),
col_number4 number(38,127),
col_number5 number(38,7),
col_numeric numeric,
col_char1 char(100),
col_char2 char(8000),
col_nchar1 nchar(100),
col_nchar2 nchar(8000),
col_varchar_200 varchar(100),
col_varchar_8000 varchar(8000) default 'aaaabbbb',
col_varchar2_1000 varchar2(100) not null default 'aaaabbbb' comment 'varchar2(1000)',
col_varchar2_8000 varchar2(8000),
col_nvarchar1 nvarchar(100),
col_nvarchar2 nvarchar(8000),
col_nvarchar2_1000 nvarchar2(100),
col_nvarchar2_8000 nvarchar2(8000),
col_clob clob,
col_text text,
col_longtext longtext,
col_image image,
col_binary1 binary(100),
col_binary2 binary(8000),
col_varbinary1 varbinary(100),
col_varbinary2 varbinary(8000),
col_raw1 raw(100),
col_raw2 raw(8000),
col_blob blob,
col_date date not null default '2018-01-07 08:08:08',
col_datetime datetime default '2018-01-07 08:08:08',
col_timestamp1 timestamp ,
col_timestamp2 timestamp(6),
col_timestamp3 TIMESTAMP WITH TIME ZONE,
col_timestamp4 TIMESTAMP WITH LOCAL TIME ZONE,
col_bool bool,
col_boolean boolean,
col_interval1 INTERVAL YEAR TO MONTH,
col_interval2 INTERVAL DAY TO SECOND
)
partition by hash(col_BINARY_INTEGER,col_float,col_numeric,col_raw1,col_varchar2_1000,col_interval1,col_date)
(
  partition p_hash_01  ,
  partition p_hash_02  ,
  partition p_hash_03  ,
  partition p_hash_04  ,
  partition p_hash_05  ,
  partition p_hash_06  ,
  partition p_hash_07  
)  ;
create table tbl_explain_interval(
col_int int ,
col_integer integer,
col_BINARY_INTEGER BINARY_INTEGER,
col_smallint smallint not null default '7',
col_bigint bigint not null default '3',
col_BINARY_BIGINT BINARY_BIGINT,
col_real real,
col_double double comment 'double',
col_float float,
col_BINARY_DOUBLE BINARY_DOUBLE,
col_decimal decimal,
col_number1 number,
col_number2 number(38),
col_number3 number(38,-84),
col_number4 number(38,127),
col_number5 number(38,7),
col_numeric numeric,
col_char1 char(100),
col_char2 char(8000),
col_nchar1 nchar(100),
col_nchar2 nchar(8000),
col_varchar_200 varchar(100),
col_varchar_8000 varchar(8000) not null default 'abcd',
col_varchar2_1000 varchar2(100),
col_varchar2_8000 varchar2(8000),
col_nvarchar1 nvarchar(100),
col_nvarchar2 nvarchar(8000),
col_nvarchar2_1000 nvarchar2(100),
col_nvarchar2_8000 nvarchar2(8000),
col_clob clob,
col_text text,
col_longtext longtext not null,
col_image image,
col_binary1 binary(100),
col_binary2 binary(8000),
col_varbinary1 varbinary(100),
col_varbinary2 varbinary(8000) not null,
col_raw1 raw(100),
col_raw2 raw(8000),
col_blob blob,
col_date date not null default to_date('2018-06-01','yyyy-mm-dd'),
col_datetime datetime default '2018-01-07 08:08:08',
col_timestamp1 timestamp default to_timestamp('2018-01-07 08:08:08', 'YYYY-MM-DD HH24:MI:SS:FF'),
col_timestamp2 timestamp(6),
col_timestamp3 TIMESTAMP WITH TIME ZONE,
col_timestamp4 TIMESTAMP WITH LOCAL TIME ZONE,
col_bool bool,
col_boolean boolean,
col_interval1 INTERVAL YEAR TO MONTH,
col_interval2 INTERVAL DAY TO SECOND
)
partition by range(col_date) interval (numtoyminterval(1, 'month'))
(
  partition p_interval_01 values less than (to_date('2018-02-01','yyyy-mm-dd'))  ,
  partition p_interval_02 values less than (to_date('2018-03-01','yyyy-mm-dd'))  ,
  partition p_interval_03 values less than (to_date('2018-05-01','yyyy-mm-dd'))  ,
  partition p_interval_04 values less than (to_date('2018-07-01','yyyy-mm-dd'))  ,
  partition p_interval_05 values less than (to_date('2018-09-01','yyyy-mm-dd'))  ,
  partition p_interval_06 values less than (to_date('2018-10-01','yyyy-mm-dd'))  ,
  partition p_interval_07 values less than (to_date('2018-12-01','yyyy-mm-dd'))  
 );
create table tbl_explain_list(
col_int int,
col_integer integer,
col_BINARY_INTEGER BINARY_INTEGER,
col_smallint smallint not null default '7',
col_bigint bigint not null default '3',
col_BINARY_BIGINT BINARY_BIGINT,
col_real real,
col_double double,
col_float float,
col_BINARY_DOUBLE BINARY_DOUBLE,
col_decimal decimal,
col_number1 number,
col_number2 number(38),
col_number3 number(38,-84),
col_number4 number(38,127),
col_number5 number(38,7),
col_numeric numeric,
col_char1 char(100),
col_char2 char(8000),
col_nchar1 nchar(100),
col_nchar2 nchar(8000),
col_varchar_200 varchar(100),
col_varchar_8000 varchar(8000) default 'aaaabbbb',
col_varchar2_1000 varchar2(100),
col_varchar2_8000 varchar2(8000),
col_nvarchar1 nvarchar(100),
col_nvarchar2 nvarchar(8000),
col_nvarchar2_1000 nvarchar2(100),
col_nvarchar2_8000 nvarchar2(8000),
col_clob clob,
col_text text,
col_longtext longtext,
col_image image,
col_binary1 binary(100),
col_binary2 binary(8000),
col_varbinary1 varbinary(100),
col_varbinary2 varbinary(8000),
col_raw1 raw(100),
col_raw2 raw(8000),
col_blob blob,
col_date date default to_date('2018-01-07','yyyy-mm-dd'),
col_datetime datetime default '2018-01-07 08:08:08',
col_timestamp1 timestamp not null default '2018-01-07 08:08:08',
col_timestamp2 timestamp(6),
col_timestamp3 TIMESTAMP WITH TIME ZONE,
col_timestamp4 TIMESTAMP WITH LOCAL TIME ZONE,
col_bool bool,
col_boolean boolean,
col_interval1 INTERVAL YEAR TO MONTH,
col_interval2 INTERVAL DAY TO SECOND
)
partition by list(col_bigint,col_char1,col_timestamp1)
(
   partition p_list_01 values ((1,'aaaabbbbccc1','2018-01-07 08:08:08'),(2,'aaaabbbbccc2','2018-01-08 08:08:08'),(3,'aaaabbbbccc3','2018-01-09 08:08:08'),(4,'aaaabbbbccc4','2018-01-10 08:08:08'),(5,'aaaabbbbccc5','2018-01-11 08:08:08'))  ,
   partition p_list_02 values ((101,'aaaabbbbccc6','2018-02-07 08:08:08'),(102,'aaaabbbbccc7','2018-02-08 08:08:08'),(103,'aaaabbbbccc8','2018-02-09 08:08:08'),(104,'aaaabbbbccc9','2018-02-10 08:08:08'),(105,'aaaabbbbccc10','2018-02-11 08:08:08'))  ,
   partition p_list_03 values ((1010,'aaaabbbbccc11','2018-03-07 08:08:08'),(1020,'aaaabbbbccc12','2018-03-08 08:08:08'),(1030,'aaaabbbbccc13','2018-03-09 08:08:08'),(1040,'aaaabbbbccc14','2018-03-10 08:08:08'),(1050,'aaaabbbbccc15','2018-03-11 08:08:08'))  ,
   partition p_list_04 values ((10010,'aaaabbbbccc16','2018-04-07 08:08:08'),(10020,'aaaabbbbccc17','2018-04-08 08:08:08'),(10030,'aaaabbbbccc18','2018-04-09 08:08:08'),(10040,'aaaabbbbccc19','2018-04-10 08:08:08'),(10050,'aaaabbbbccc20','2018-04-11 08:08:08'))  ,
   partition p_list_05 values ((100010,'aaaabbbbccc21','2018-05-07 08:08:08'),(100020,'aaaabbbbccc22','2018-05-08 08:08:08'),(100030,'aaaabbbbccc23','2018-05-09 08:08:08'),(100040,'aaaabbbbccc24','2018-05-10 08:08:08'),(100050,'aaaabbbbccc25','2018-05-11 08:08:08'))  ,
   partition p_list_06 values ((200010,'aaaabbbbccc26','2018-06-07 08:08:08'),(200020,'aaaabbbbccc27','2018-06-08 08:08:08'),(200030,'aaaabbbbccc28','2018-06-09 08:08:08'),(200040,'aaaabbbbccc29','2018-06-10 08:08:08'),(200050,'aaaabbbbccc30','2018-06-11 08:08:08'))  ,
   partition p_list_07 values (default)  
);
explain merge into tbl_explain_list t1 using(select * from tbl_explain_interval where col_int<=50) t2 on(t1.COL_RAW1!=t2.col_raw1) 
when matched then update set COL_IMAGE=t2.col_image where t1.col_int<=10
when not matched then insert (COL_INT,COL_SMALLINT,COL_BIGINT,COL_TIMESTAMP1) values(t2.col_int*100000,t2.col_int,t2.col_bigint,t2.col_timestamp2) 
where exists(select distinct st1.col_int from tbl_explain_hash st1 left join tbl_explain_list st2 on st1.col_int=st2.col_int and st1.col_int<=50 
and st2.col_int<=50 where st2.col_timestamp1<=(select distinct max(distinct col_timestamp1) 
from tbl_explain_interval where col_timestamp1=t2.COL_TIMESTAMP1));
drop table tbl_explain_hash;
drop table tbl_explain_interval;
drop table tbl_explain_list;

DROP TABLE IF EXISTS "I_FIXEDNETWORKLTP";
CREATE TABLE "I_FIXEDNETWORKLTP"
(
  "id" VARBINARY(16) NOT NULL,
  "class_Name" VARCHAR(384 BYTE) NOT NULL,
  "class_Id" BINARY_BIGINT NOT NULL,
  "collectorId" VARCHAR(36 BYTE),
  "reportSn" BINARY_BIGINT,
  "last_Modified" BINARY_BIGINT NOT NULL,
  "regionId" VARBINARY(16),
  "createTime" BINARY_BIGINT,
  "name" VARCHAR(765 BYTE) NOT NULL,
  "remark" VARCHAR(3072 BYTE),
  "nativeId" VARCHAR(765 BYTE),
  "ownerId" BINARY_BIGINT,
  "bandwidth" BINARY_DOUBLE,
  "frameId" VARCHAR(96 BYTE),
  "portId" VARCHAR(96 BYTE),
  "cardNativeId" VARCHAR(765 BYTE),
  "portIndex" VARCHAR(765 BYTE),
  "ltpTypeName" VARCHAR(384 BYTE) NOT NULL,
  "adminState" VARCHAR(96 BYTE),
  "layerRate" VARCHAR(192 BYTE),
  "tenantId" VARCHAR(192 BYTE),
  "alias" VARCHAR(765 BYTE),
  "slotId" VARCHAR(96 BYTE),
  "daughterSlotId" VARCHAR(96 BYTE),
  "neNativeId" VARCHAR(765 BYTE),
  "direction" VARCHAR(96 BYTE),
  "Access__ponType" VARCHAR(96 BYTE),
  "Eth__portCableType" VARCHAR(96 BYTE),
  "nativeId2" VARCHAR(765 BYTE),
  "refParentCard" VARBINARY(16),
  "Eth__mtu" BINARY_INTEGER,
  "Optical__sfpTransLength" VARCHAR(96 BYTE),
  "ltpRole" VARCHAR(96 BYTE),
  "PonUNI__maxDistance" BINARY_DOUBLE,
  "IP__addrv4Mask" BINARY_INTEGER,
  "refTrunkLTP" VARBINARY(16),
  "operateState" VARCHAR(48 BYTE),
  "Microwave__guaranteedModulaMode" VARCHAR(96 BYTE),
  "Access__supportService" VARCHAR(96 BYTE),
  "OTN__workBandParity" VARCHAR(96 BYTE),
  "Optical__txReference" VARCHAR(24 BYTE),
  "FanVoipUser__telNumber" VARCHAR(384 BYTE),
  "Eth__tunnelId" BINARY_INTEGER,
  "tags" VARCHAR(6144 BYTE),
  "SDH__highPath" BINARY_INTEGER,
  "portType" BINARY_INTEGER,
  "ATM__vpiVci" CLOB,
  "deleteTime" BINARY_BIGINT,
  "OTN__pathId" VARCHAR(96 BYTE),
  "refTrunkLTPNativeId" VARCHAR(765 BYTE),
  "SAP__refServiceType" VARCHAR(96 BYTE),
  "Trunk__trunkId" VARCHAR(96 BYTE),
  "Plan__role" VARCHAR(96 BYTE),
  "nativeName" VARCHAR(192 BYTE),
  "Vdsl__xTUR_serialNumber" VARCHAR(192 BYTE),
  "workMode" VARCHAR(192 BYTE),
  "Vdsl__xTUR_vendorId" VARCHAR(192 BYTE),
  "OTN__flexFreq" VARCHAR(96 BYTE),
  "LAG__lagType" VARCHAR(48 BYTE),
  "Eth__ingressPIR" BINARY_DOUBLE,
  "Eth__vlanType" VARCHAR(96 BYTE),
  "MPLSTE__reservedBandwidthRatio" BINARY_DOUBLE,
  "OTN__maxWaveNum" BINARY_INTEGER,
  "isSubLTP" BOOLEAN,
  "SAP__refService" VARBINARY(16),
  "Optical__sfpPortType" VARCHAR(96 BYTE),
  "protectionRole" VARCHAR(96 BYTE),
  "PonUNI__opticsModuleSubType" VARCHAR(96 BYTE),
  "PonNNI__unknownUnicastTrafficSuppression" BINARY_INTEGER,
  "NVE__sourceIP" VARCHAR(192 BYTE),
  "Optical__rxHighThreshold" VARCHAR(24 BYTE),
  "PonUNI__minDistance" BINARY_DOUBLE,
  "capabilityURI" VARCHAR(384 BYTE),
  "signalTypeCapability" VARCHAR(1536 BYTE),
  "Eth__vlan" CLOB,
  "Eth__egressCIR" BINARY_DOUBLE,
  "refParentNE" VARBINARY(16),
  "PonUNI__pgGroupId" BINARY_INTEGER,
  "C64K__timeslot" VARCHAR(300 BYTE),
  "PonUNI__remainingGuaranteedBandwidth" BINARY_DOUBLE,
  "FlexEth__groupId" BINARY_INTEGER,
  "Adsl__extendProfile" VARCHAR(192 BYTE),
  "Eth__mac" VARCHAR(192 BYTE),
  "OTN__refAccessTPNativeIdList" CLOB,
  "OTN__freqWidth" VARCHAR(96 BYTE),
  "Eth__ipv6Mtu" BINARY_INTEGER,
  "Eth__autoNegotiation" VARCHAR(96 BYTE),
  "Vdsl__alarmProfile" VARCHAR(192 BYTE),
  "Eth__ingressCIR" BINARY_DOUBLE,
  "Eth__enableChannelMode" BOOLEAN,
  "LAG__loadBalanceMode" VARCHAR(96 BYTE),
  "Vdsl__linkProfile" VARCHAR(192 BYTE),
  "MPLSTE__availableBandwidth" BINARY_DOUBLE,
  "Optical__rxReference" VARCHAR(24 BYTE),
  "Vdsl__xTUR_systemVendorId" VARCHAR(192 BYTE),
  "refDaughterSlotNativeId" VARCHAR(765 BYTE),
  "Microwave__amStatus" VARCHAR(3 BYTE),
  "MPLSTE__maxReservedBandwidth" BINARY_DOUBLE,
  "OTN__workBand" VARCHAR(96 BYTE),
  "PonUNI__onuAutoDiscovery" VARCHAR(96 BYTE),
  "Eth__egressPIR" BINARY_DOUBLE,
  "Optical__fiberMode" VARCHAR(96 BYTE),
  "Optical__opticalModule" VARCHAR(96 BYTE),
  "LAG__protectionRatio" VARCHAR(24 BYTE),
  "Access__refParentONU" VARBINARY(16),
  "Vdsl__xTUR_versionNumber" VARCHAR(192 BYTE),
  "scLtpType" VARCHAR(96 BYTE),
  "Adsl__linkProfile" VARCHAR(192 BYTE),
  "IP__unnumberedNativeId" VARCHAR(765 BYTE),
  "level" VARCHAR(192 BYTE),
  "OTN__waveNo" VARCHAR(96 BYTE),
  "IP__backupAddrv4" CLOB,
  "Optical__txHighThreshold" VARCHAR(24 BYTE),
  "Microwave__fullModulaMode" VARCHAR(96 BYTE),
  "SDH__lowPath" BINARY_INTEGER,
  "IP__addrv6" CLOB,
  "Physical__powerToBeReceived" VARCHAR(30 BYTE),
  "Plan__usageState" VARCHAR(96 BYTE),
  "OTN__pathMapModeId" BINARY_INTEGER,
  "AgentIntegrate__resTypeName" VARCHAR(96 BYTE),
  "PonUNI__maxOnuNumber" BINARY_INTEGER,
  "IP__addrv4" VARCHAR(96 BYTE),
  "userLabel" VARCHAR(768 BYTE),
  "refSlotNativeId" VARCHAR(765 BYTE),
  "FanVoipAG__mgId" BINARY_INTEGER,
  "LAG__maxActiveLinkNumber" BINARY_INTEGER,
  "description" VARCHAR(765 BYTE),
  "refParentLTPNativeId" VARCHAR(765 BYTE),
  "PonNNI__multicastTrafficSuppression" BINARY_INTEGER,
  "OTN__pathLayerInfo" VARCHAR(765 BYTE),
  "PonNNI__broadcastTrafficSuppression" BINARY_INTEGER,
  "LAG__revertiveMode" VARCHAR(48 BYTE),
  "OTN__aggPoint" VARCHAR(765 BYTE),
  "equivalentFBNativeId" VARCHAR(765 BYTE),
  "VNI__vniId" BINARY_INTEGER,
  "isPhysical" BOOLEAN,
  "SAP__refServiceNativeId" VARCHAR(765 BYTE),
  "Access__isUplinkPort" BINARY_INTEGER,
  "ownerId2" BINARY_BIGINT,
  "Physical__mediumType" VARCHAR(96 BYTE),
  "Access__isInOnt" BINARY_INTEGER,
  "layerRateCapability" VARCHAR(3072 BYTE),
  "Eth__defaultVlanId" BINARY_INTEGER,
  "controllerSubType" BINARY_INTEGER,
  "Optical__txLowThreshold" VARCHAR(24 BYTE),
  "Optical__rxLowThreshold" VARCHAR(24 BYTE),
  "refParentLTP" VARBINARY(16),
  "Adsl__alarmProfile" VARCHAR(192 BYTE),
  "Optical__sfpWaveLength" VARCHAR(96 BYTE)
);
CREATE UNIQUE INDEX "IDXFIXEDNETWORKLTP_PRIMARY_KEY"           ON "I_FIXEDNETWORKLTP"("id");
CREATE INDEX "IDXFIXEDNETWORKLTP_FANVOIPUSER_TELNUMBER_2130"   ON "I_FIXEDNETWORKLTP"("FanVoipUser__telNumber", "id");
CREATE INDEX "IDXFIXEDNETWORKLTP_IP_ADDRV4_2130"               ON "I_FIXEDNETWORKLTP"("IP__addrv4", "id");
CREATE INDEX "IDXFIXEDNETWORKLTP_PARENTLTP_2130"               ON "I_FIXEDNETWORKLTP"("refParentLTP", "id");
CREATE INDEX "IDXFIXEDNETWORKLTP_PARENTNE_2130"                ON "I_FIXEDNETWORKLTP"("refParentNE", "id");
CREATE INDEX "IDX_I_FIXEDNETWORKLTP_ALIAS"                     ON "I_FIXEDNETWORKLTP"("alias", "id");
CREATE INDEX "IDX_I_FIXEDNETWORKLTP_CLASS_ID"                  ON "I_FIXEDNETWORKLTP"("class_Id", "id");
CREATE INDEX "IDX_I_FIXEDNETWORKLTP_COLLECTORID"               ON "I_FIXEDNETWORKLTP"("collectorId", "id");
CREATE INDEX "IDX_I_FIXEDNETWORKLTP_NAME"                      ON "I_FIXEDNETWORKLTP"("name", "id");
CREATE INDEX "IDX_I_FIXEDNETWORKLTP_NATIVEID_OWNERID_REGIONID" ON "I_FIXEDNETWORKLTP"("nativeId", "ownerId", "regionId", "id");

DROP TABLE IF EXISTS "I_FIXEDNETWORKELEMENT" CASCADE CONSTRAINTS;
CREATE TABLE "I_FIXEDNETWORKELEMENT"
(
  "id" VARBINARY(16) NOT NULL,
  "class_Name" VARCHAR(384 BYTE) NOT NULL,
  "class_Id" BINARY_BIGINT NOT NULL,
  "collectorId" VARCHAR(36 BYTE),
  "reportSn" BINARY_BIGINT,
  "last_Modified" BINARY_BIGINT NOT NULL,
  "regionId" VARBINARY(16),
  "createTime" BINARY_BIGINT,
  "name" VARCHAR(765 BYTE) NOT NULL,
  "remark" VARCHAR(3072 BYTE),
  "nativeId" VARCHAR(765 BYTE),
  "ownerId" BINARY_BIGINT,
  "container" BOOLEAN NOT NULL,
  "commuState" VARCHAR(48 BYTE),
  "refParentSubnet" VARBINARY(16),
  "latitude" BINARY_DOUBLE,
  "ipAddress" VARCHAR(765 BYTE),
  "timeZone" VARCHAR(768 BYTE),
  "language" VARCHAR(762 BYTE),
  "version" VARCHAR(1536 BYTE),
  "mac" VARCHAR(384 BYTE),
  "productName" VARCHAR(384 BYTE),
  "manufacturer" VARCHAR(384 BYTE),
  "refParentNE" VARBINARY(16),
  "codeset" VARCHAR(765 BYTE),
  "adminState" VARCHAR(96 BYTE),
  "tenantId" VARCHAR(192 BYTE),
  "manufactureDate" VARCHAR(384 BYTE),
  "alias" VARCHAR(765 BYTE),
  "isVNF" BOOLEAN,
  "typeId" VARCHAR(384 BYTE) NOT NULL,
  "location" VARCHAR(1500 BYTE),
  "parentNeNativeId" VARCHAR(765 BYTE),
  "sn" VARCHAR(384 BYTE),
  "interfaceId" VARCHAR(1536 BYTE),
  "longitude" BINARY_DOUBLE,
  "__plat_ipfield_ipAddress" VARBINARY(16),
  "Qx__physicalId" BINARY_INTEGER,
  "userLabel" VARCHAR(768 BYTE),
  "ASON__enableAson" BINARY_INTEGER,
  "ONE__devList" CLOB,
  "workMode" VARCHAR(192 BYTE),
  "ipv6Address" VARCHAR(192 BYTE),
  "ASON__isInACDomain" BOOLEAN,
  "roles" VARCHAR(1536 BYTE),
  "nativeId2" VARCHAR(765 BYTE),
  "fiberCount" BINARY_INTEGER,
  "refParentONENativeId" VARCHAR(765 BYTE),
  "detailDevTypeName" VARCHAR(96 BYTE),
  "Qx__masterGateway" VARBINARY(16),
  "tenantName" VARCHAR(765 BYTE),
  "Access__playMode" VARCHAR(96 BYTE),
  "refParentSubnetNativeId" VARCHAR(765 BYTE),
  "Plan__roles" VARCHAR(1536 BYTE),
  "Qx__port" BINARY_INTEGER,
  "IP__asNumber" BINARY_BIGINT,
  "equivalentNum" BINARY_DOUBLE,
  "ownerId2" BINARY_BIGINT,
  "capabilityURI" VARCHAR(384 BYTE),
  "IP__devLsrId" VARCHAR(192 BYTE),
  "startupTime" BINARY_BIGINT,
  "IP__bgpRouterId" VARCHAR(96 BYTE),
  "SNMP__devSysName" VARCHAR(765 BYTE),
  "detailDevType" BINARY_INTEGER,
  "tags" VARCHAR(6144 BYTE),
  "Qx__refGatewayNEList" VARCHAR(765 BYTE),
  "hardVersion" VARCHAR(384 BYTE),
  "preConfig" BINARY_INTEGER,
  "deleteTime" BINARY_BIGINT,
  "Qx__isGateway" BINARY_INTEGER,
  "patchVersion" VARCHAR(384 BYTE),
  "refParentONE" VARBINARY(16),
  "frameType" VARCHAR(96 BYTE),
  "isVirtual" BOOLEAN
);
CREATE UNIQUE INDEX "I_FIXEDNETWORKELEMENT_PRIMARY_KEY"   ON "I_FIXEDNETWORKELEMENT"("id");
CREATE INDEX "IDXFIXEDNETWORKELEMENT_IP_BGPROUTERID_2100" ON "I_FIXEDNETWORKELEMENT"("IP__bgpRouterId", "id");
CREATE INDEX "IDXFIXEDNETWORKELEMENT_NAME_IPADDRESS_QX__PHYSICALID_2100" ON "I_FIXEDNETWORKELEMENT"("name", "ipAddress", "Qx__physicalId", "id");
CREATE INDEX "IDXFIXEDNETWORKELEMENT_QX_PHYSICALID_2100" ON "I_FIXEDNETWORKELEMENT"("Qx__physicalId", "id");
CREATE INDEX "IDX_I_FIXEDNETWORKELEMENT_CLASS_ID" ON "I_FIXEDNETWORKELEMENT"("class_Id", "id");
CREATE INDEX "IDX_I_FIXEDNETWORKELEMENT_COLLECTORID" ON "I_FIXEDNETWORKELEMENT"("collectorId", "id");
CREATE INDEX "IDX_I_FIXEDNETWORKELEMENT_IPADDRESS" ON "I_FIXEDNETWORKELEMENT"("ipAddress", "id");
CREATE INDEX "IDX_I_FIXEDNETWORKELEMENT_NAME" ON "I_FIXEDNETWORKELEMENT"("name", "id");
CREATE INDEX "IDX_I_FIXEDNETWORKELEMENT_NATIVEID_OWNERID_REGIONID" ON "I_FIXEDNETWORKELEMENT"("nativeId", "ownerId", "regionId", "id");
CREATE INDEX "IDX_I_FIXEDNETWORKELEMENT___PLAT_IPFIELD_IPADDRESS" ON "I_FIXEDNETWORKELEMENT"("__plat_ipfield_ipAddress", "id");

--sort index
EXPLAIN SELECT * FROM I_FIXEDNETWORKLTP I WHERE ((((((I.`deleteTime` IS NULL ) OR (I.`deleteTime`=0)))))) ORDER BY I.`id` ASC limit 1000;

EXPLAIN SELECT  * FROM I_FIXEDNETWORKLTP I WHERE ((((((I.`deleteTime` IS NULL ) OR (I.`deleteTime`=0)))))) AND ((I.`name` > 'abc' OR I.`name` IS NULL) OR (I.`name` = 'abcd' AND I.`id` > '0x01')) AND I.`name` like '%LISHUITUAN%' ORDER BY I.`name` ASC, I.`id` ASC limit 1000;

EXPLAIN SELECT * FROM I_FIXEDNETWORKLTP I WHERE ((((((I.`deleteTime` IS NULL ) OR (I.`deleteTime`=0)))))) AND ((I.`name` > 'abc' OR I.`name` IS NULL) OR (I.`name` = 'abcde' AND I.`id` > '0x01')) AND I.`name` like '%LISHUITUAN%' ORDER BY I.`id` ASC limit 1000;

--filter index
EXPLAIN SELECT * 
FROM I_FIXEDNETWORKELEMENT I 
WHERE ((((((I.`__plat_ipfield_ipAddress` BETWEEN UNHEX('01020305') AND UNHEX('9bfffffe')) AND LENGTH(I.`__plat_ipfield_ipAddress`) = 4)))))
order by `id` LIMIT 21 OFFSET 0;

EXPLAIN SELECT * FROM I_FIXEDNETWORKLTP I WHERE ((((((I.`deleteTime` IS NULL ) OR (I.`deleteTime`=0)))))) AND ((I.`name` > 'abc' OR I.`name` IS NULL) OR (I.`name` = 'abcd' AND I.`id` > '0x01')) AND `collectorId` = '12354' ORDER BY I.`name` ASC, I.`id` ASC limit 1000;

EXPLAIN SELECT * FROM I_FIXEDNETWORKLTP I WHERE ((((((I.`deleteTime` IS NULL ) OR (I.`deleteTime`=0)))))) AND ((I.`name` > 'abc' OR I.`name` IS NULL) OR (I.`name` = 'abcd' AND I.`id` > '0x01')) AND `collectorId` = '12354' ORDER BY I.`id` ASC limit 1000;

EXPLAIN SELECT * FROM I_FIXEDNETWORKLTP I WHERE ((((((I.`deleteTime` IS NULL ) OR (I.`deleteTime`=0)))))) AND ((I.`name` > 'abc' OR I.`name` IS NULL) OR (I.`name` = 'abcd' AND I.`id` > '0x01')) AND `FanVoipUser__telNumber` = '12354' ORDER BY I.`name` ASC, I.`id` ASC limit 1000;

EXPLAIN SELECT * FROM I_FIXEDNETWORKLTP I WHERE ((((((I.`deleteTime` IS NULL ) OR (I.`deleteTime`=0)))))) AND ((I.`name` > 'abc' OR I.`name` IS NULL) OR (I.`name` = 'abcd' AND I.`id` > '0x01')) AND `IP__addrv4` = '12354' ORDER BY I.`name` ASC, I.`id` ASC limit 1000;

EXPLAIN SELECT * FROM I_FIXEDNETWORKLTP I WHERE ((((((I.`deleteTime` IS NULL ) OR (I.`deleteTime`=0)))))) AND ((I.`name` > 'abc' OR I.`name` IS NULL) OR (I.`name` = 'abcd' AND I.`id` > '0x01')) AND `IP__addrv4` between '12354' and '1235466' ORDER BY I.`name` ASC, I.`id` ASC limit 1000;

EXPLAIN SELECT * FROM I_FIXEDNETWORKLTP I WHERE ((((((I.`deleteTime` IS NULL ) OR (I.`deleteTime`=0)))))) AND ((I.`name` > 'abc' OR I.`name` IS NULL) OR (I.`name` = 'abcd' AND I.`id` > '0x01')) AND `nativeId` = '12354' and `ownerId` = '12354' and `regionId` = '12354' ORDER BY I.`name` ASC, I.`id` ASC limit 1000;

--filter and sort index
EXPLAIN SELECT * FROM I_FIXEDNETWORKLTP I WHERE ((((((I.`deleteTime` IS NULL ) OR (I.`deleteTime`=0)))))) AND ((I.`name` > 'abc' OR I.`name` IS NULL) OR (I.`name` = 'abcd' AND I.`id` > :p2)) ORDER BY I.`name` ASC, I.`id` ASC limit 1000;


--subselect in hash join
DROP TABLE IF EXISTS T_OUTER_JOIN_1;
DROP TABLE IF EXISTS T_OUTER_JOIN_2;
DROP TABLE IF EXISTS T_OUTER_JOIN_3;
CREATE TABLE T_OUTER_JOIN_1(F_INT1 INT);
CREATE TABLE T_OUTER_JOIN_2(F_INT1 INT);
CREATE TABLE T_OUTER_JOIN_3(F_INT1 INT);
CREATE INDEX IND_T_OUTER_JOIN_3 ON T_OUTER_JOIN_3(F_INT1);
INSERT INTO T_OUTER_JOIN_1 VALUES(1);
INSERT INTO T_OUTER_JOIN_2 VALUES(1),(2);
INSERT INTO T_OUTER_JOIN_3 VALUES(1);
EXPLAIN SELECT COUNT(1) FROM T_OUTER_JOIN_1 T1 LEFT JOIN T_OUTER_JOIN_2 T2 ON T1.F_INT1 = T2.F_INT1 JOIN T_OUTER_JOIN_3 T3 ON T1.F_INT1 = T3.F_INT1 
WHERE (T1.F_INT1 <> 2 OR  T1.F_INT1 IS NULL) AND EXISTS(SELECT 1 FROM T_OUTER_JOIN_3 T4 WHERE T4.F_INT1 = T1.F_INT1);

--subselect in column
drop table if exists customer_address;
drop table if exists customer_demographics;
create table customer_address
(
    ca_address_sk             integer               not null,
    ca_address_id             char(16)              not null,
    ca_street_number          char(10)                      ,
    ca_street_name            varchar(60)                   ,
    ca_street_type            char(15)                      ,
    ca_suite_number           char(10)                      ,
    ca_city                   varchar(60)                   ,
    ca_county                 varchar(30)                   ,
    ca_state                  char(2)                       ,
    ca_zip                    char(10)                      ,
    ca_country                varchar(20)                   ,
    ca_gmt_offset             decimal(5,2)                  ,
    ca_location_type          char(20)
); 
create table customer_demographics
(
    cd_demo_sk                integer               not null,
    cd_gender                 char(1)                       ,
    cd_marital_status         char(1)                       ,
    cd_education_status       char(20)                      ,
    cd_purchase_estimate      integer                       ,
    cd_credit_rating          char(10)                      ,
    cd_dep_count              integer                       ,
    cd_dep_employed_count     integer                       ,
    cd_dep_college_count      integer
)
partition by range (cd_demo_sk)
(
partition customer_demographics_1 values less than (1000),
partition customer_demographics_2 values less than (7700),
partition customer_demographics_3 values less than (33700),
partition customer_demographics_4 values less than (57300),
partition customer_demographics_5 values less than (135700),
partition customer_demographics_6 values less than (203300),
partition customer_demographics_7 values less than (208700),
partition customer_demographics_8 values less than (238700),
partition customer_demographics_9 values less than (268700),
partition customer_demographics_10 values less than (298700),
partition customer_demographics_11 values less than (338700),
partition customer_demographics_12 values less than (368700),
partition customer_demographics_13 values less than (398700),
partition customer_demographics_14 values less than (438700),
partition customer_demographics_15 values less than (maxvalue)
);
create index customer_address_index on customer_address(ca_address_sk);
create index customer_demographics_index on customer_demographics(cd_demo_sk) local;
--DTS2019030703066
explain select trim(ca_street_number) from customer_address;
--function column
explain select to_number((select nvl(ca_street_number, '888') from customer_demographics WHERE cd_demo_sk = ca_address_sk)) / 2 c1
from customer_address
WHERE ca_gmt_offset > -10;
--aggr function column
explain select count((select ca_street_number from customer_demographics WHERE cd_demo_sk = ca_address_sk)) / 2 c1
from customer_address
WHERE ca_gmt_offset > -10;
--function cond arg
explain select if((select ca_street_name from customer_demographics)='888', '888', '999') c1
from customer_address
WHERE ca_gmt_offset > -10;
--QUERY SORT ORDER BY
explain select to_number((select nvl(ca_street_number, '888') from customer_demographics WHERE cd_demo_sk = ca_address_sk)) / 2 c1
from customer_address
WHERE ca_gmt_offset > -10
ORDER BY 1;
--HASH DISTINCT
explain select distinct sum(ca_gmt_offset) + to_number((select nvl(ca_street_number, '888') from customer_demographics WHERE cd_demo_sk = ca_address_sk)) / 2 c1
from customer_address
WHERE ca_gmt_offset > -10
group by ca_street_number, ca_city, ca_address_sk
ORDER BY 1;
drop table if exists customer_address;
drop table if exists customer_demographics;

drop table test_explain1;
drop table test_explain2;
drop table test_explain3;
drop table test_explain4;
drop table test_explain5;

drop table if exists t_siblings_order;
create table t_siblings_order(EMPNO NUMBER(4) NOT NULL,ENAME VARCHAR2(10),MGR NUMBER(4));
explain select ENAME,EMPNO,MGR from t_siblings_order start with MGR is null connect by PRIOR empno = mgr order siblings by ename;
create index idx_sibling_order_name on t_siblings_order(ename);
explain select ENAME,EMPNO,MGR from t_siblings_order start with MGR is null connect by PRIOR empno = mgr order siblings by ename;
drop table t_siblings_order;

drop table if exists sub_group_1;
create table sub_group_1 (
  f1        integer        not null, 
  f2        integer        not null,  
  f3        varchar(16),
  f4        varchar(16)
);
create index sub_group_1_idx1 on  sub_group_1 (f1);
create index sub_group_1_idx2 on  sub_group_1 (f2);
create index sub_group_1_idx3 on  sub_group_1 (f3);
create index sub_group_1_idx4 on  sub_group_1 (f4);

drop table if exists sub_group_2;
create table sub_group_2 (
  f1        integer        not null, 
  f2        integer        not null,  
  f3        varchar(16),
  f4        varchar(16)
);
create index sub_group_2_idx1 on  sub_group_2 (f1);
create index sub_group_2_idx2 on  sub_group_2 (f2);
create index sub_group_2_idx3 on  sub_group_2 (f3);
create index sub_group_2_idx4 on  sub_group_2 (f4);

explain select a.f1, a.f2 from sub_group_1 a left join (select f3 from sub_group_2 where f4 like 'w%' group by f3) b on a.f3 = b.f3 where a.f1 > 90;
explain select a.f1, a.f2 from sub_group_1 a left join (select f3 from sub_group_2 where f4 like 'w%' group by f3) b on a.f3 = b.f3 and a.f1 < 100 where a.f1 > 90;
explain select a.f1, a.f2 from sub_group_1 a left join (select f3 from sub_group_2 where f4 like 'w%' group by f3) b on a.f3 = b.f3 or a.f1 < 100 where a.f1 > 90;
explain select a.f1, a.f2 from sub_group_1 a left join (select f3 from sub_group_2 group by f3) b on a.f3 = b.f3 or a.f1 < 100 and a.f1 != a.f2 where a.f1 > 90 group by a.f1,a.f2;
explain select a.f1, /* subselect */(select f3 from sub_group_2 where f2 > 100 group by f3) from sub_group_1 a where a.f1 > 90 group by a.f1,a.f2;
create or replace view sub_group_1_view as select f1,f2 from sub_group_1;
create or replace view sub_group_2_view as select f1,f2 from sub_group_2;
explain select f1 from sub_group_1_view group by f1;
explain select f1 from sub_group_1_view where f2 > 10 group by f1;  
explain select a.f1 from sub_group_1_view a left join (select f1 from sub_group_2_view group by f1) on a.f1 < 100;
explain select a.f1, a.f2 from sub_group_1_view a left join (select f2 from sub_group_2_view group by f2) b on a.f2 = b.f2 or a.f1 < 100 and a.f1 != a.f2 where a.f1 > 90 group by a.f1,a.f2; 
explain select a.f1, /* subselect */(select f1 from sub_group_2_view where f2 > 100 group by f1) from sub_group_1_view a where a.f1 > 90 group by a.f1,a.f2;
explain select a.f1 from sub_group_1 a where a.f1 in (select (select f1 from sub_group_2 where f1 > 0 group by f1) from sub_group_2 where f2 > 100 group by f3);
explain select a.f1, a.f2 from sub_group_1 a right join (select distinct f3 from sub_group_2 group by f3) b on a.f3 = b.f3 or a.f1 < 200 where a.f1 > 90 order by a.f1;
explain 
select a.f4 from sub_group_1 a where a.f2 in (select case when f2 > 11 Then f2+1 else f2-1 end from sub_group_2 where f1 < 1000 group by f2) group by f4 having f4 > 0
union all 
select a.f4 from sub_group_1 a left join (select f3 from sub_group_2 group by f3) b on a.f3 like '%lin' where a.f1 > 90;
explain
select a.f1, a.f2, a.f3 from sub_group_1 a right join (select distinct f3 from sub_group_2 group by f3) b on a.f3 = b.f3
minus
select a.f1, a.f2, a.f3 from sub_group_1 a left join (select distinct f1 from sub_group_2 group by f1) b on a.f1 > b.f1;
drop table if exists sub_group_1;
drop table if exists sub_group_2;
--DTS2019100806027
drop table if exists explain_core;
create table explain_core(id1 int not null,num1 float,char1 varchar(500) default '字符串kjdsgfkj') 
partition by range(id1)	
(
	partition p1 values less than (5),
	partition p2 values less than (16),
	partition p3 values less than (maxvalue)
);

insert into explain_core values(1,0.094785,'rjhcgrhjkg');
insert into explain_core values(3,78.85,'的脚后跟');
insert into explain_core values(6,497947.85,'预告发热护4gvhj');
insert into explain_core values(14,4785,'rjhjkg');
insert into explain_core values(87,-4785,'rj零食就打开过hjkg');
commit;

explain plan for delete from explain_core where id1 = (select 87 from dual);
explain plan for delete from explain_core where id1 = (select 87 from dual); 
explain plan for delete from explain_core where id1 = (select 87 from dual); 
explain plan for delete from explain_core where id1 = (select 87 from dual); 
explain plan for delete from explain_core where id1 = (select 87 from dual); 
explain plan for delete from explain_core where id1 = (select 87 from dual); 
explain plan for delete from explain_core where id1 = (select 87 from dual); 
explain plan for delete from explain_core where id1 = (select 87 from dual); 
explain plan for delete from explain_core where id1 = (select 87 from dual); 
explain plan for delete from explain_core where id1 = (select 87 from dual); 
drop table explain_core;

 
DROP TABLE IF EXISTS f_TNN000005_NodeBCell_H;
CREATE TABLE f_TNN000005_NodeBCell_H(
    NodeBCellId NUMBER(20),
    StartTime DATE,
    Hour NUMBER(20),
    DSTOffset NUMBER(20),
    Period NUMBER(20),
    Integrity NUMBER(20),
    PreIntegrity NUMBER(20)
);
DROP TABLE IF EXISTS d_NodeBCellGrpObject;
CREATE TABLE d_NodeBCellGrpObject(
    NodeBCellGrpId NUMBER(20),
    NodeBCellId NUMBER(20)
);

explain select ObjId,
       DSTOffset,
       Hour,
       T0.StartTime,
       (Period) Period,
       (Integrity) Integrity,
       (PreIntegrity) PreIntegrity,
       (RecordNum) RecordNum
  from (select (d0.NodeBCellGrpId) ObjId,
               T0.StartTime,
               T0.Hour,
               T0.DSTOffset,
               AVG(T0.Period) Period,
               0 Period_cond,
               AVG(Integrity) Integrity,
               Max(PreIntegrity) PreIntegrity,
               count(1) RecordNum
          from f_TNN000005_NodeBCell_H T0, d_NodeBCellGrpObject d0
         where T0.NodeBCellId = d0.NodeBCellId
           and ((d0.NodeBCellGrpId >= 298 and d0.NodeBCellGrpId <= 397))
           and ((T0.StartTime = to_date('2019/09/28', 'yyyy/mm/dd')))
         group by (d0.NodeBCellGrpId), T0.StartTime, T0.Hour, T0.DSTOffset) T0;

explain select ObjId,
       DSTOffset,
       Hour,
       T0.StartTime,
       (Period) Period,
       (Integrity) Integrity,
       (PreIntegrity) PreIntegrity,
       (RecordNum) RecordNum
  from (select (d0.NodeBCellGrpId) ObjId,
               T0.StartTime,
               T0.Hour,
               T0.DSTOffset,
               AVG(T0.Period) Period,
               0 Period_cond,
               AVG(Integrity) Integrity,
               Max(PreIntegrity) PreIntegrity,
               count(1) RecordNum
          from f_TNN000005_NodeBCell_H T0, d_NodeBCellGrpObject d0
         where T0.NodeBCellId = d0.NodeBCellId
           and ((d0.NodeBCellGrpId >= 298 and d0.NodeBCellGrpId <= 397))
           and ((T0.StartTime = to_date('2019/09/28', 'yyyy/mm/dd')))
         group by (d0.NodeBCellGrpId), T0.StartTime, T0.Hour, T0.DSTOffset) T0
    WHERE T0.Period>0;

drop table if exists t_or2union_1;
drop table if exists t_or2union_2;
drop table if exists t_or2union_3;
drop table if exists t_or2union_4;
drop table if exists t_or2union_5;
drop table if exists t_or2union_6;
create table t_or2union_1(a int, b int, c int, d int, e int);
create table t_or2union_2(a int, b int, c int, d int, e int);
create table t_or2union_3(a int, b int, c int, d int, e int);
create table t_or2union_4(a int, b int, c int, d int, e int);
create table t_or2union_5(a int, b int, c int, d int, e int);
create table t_or2union_6(a int, b int, c int, d int, e int);

--Not Rewrite
explain select * from t_or2union_1 t1 join t_or2union_2 t2 on t1.a = 10 or t1.b = t2.b;
explain select * from t_or2union_1 t1 where t1.a = 10 or exists (select 1 from t_or2union_2 t2);
explain select * from t_or2union_1 t1 join t_or2union_2 t2 on exists (select 1 from t_or2union_3 t3) or t1.a = t2.a;
explain select * from t_or2union_1 t1 join t_or2union_2 t2 on t1.a = t2.a and (t1.b = t2.b or t1.c = t2.c);
explain select * from t_or2union_1 t1, t_or2union_2 t2, t_or2union_3 t3 where t1.a = t2.a or t1.b = t2.b or t1.c = t3.c;
explain select * from t_or2union_1 t1 join t_or2union_2 t2 on exists (select 1 from t_or2union_3 t3) and (t1.a = t2.a or t1.b = t2.b);
explain select * from t_or2union_1 t1 join t_or2union_2 t2 on (exists (select 1 from t_or2union_3 t3) or t1.a = 100) and (t1.a = t2.a or t1.b = t2.b);
explain select * from t_or2union_1 t1 where exists (select 1 from t_or2union_2 t2) or exists (select 1 from t_or2union_3 t3);
explain select * from t_or2union_1 t1 join t_or2union_2 t2 on exists (select 1 from t_or2union_3 t3) or (t1.a = t2.a and (t1.b = t2.b or t1.c = t2.c));
explain select * from t_or2union_1 t1 where (t1.c in (select t2.c from t_or2union_2 t2) or t1.a in (select t3.a from t_or2union_3 t3)) and (t1.d in (select t4.d from t_or2union_4 t4) or t1.b in (select t5.b from t_or2union_5 t5));
explain select * from t_or2union_1 t1 where exists (select 1 from t_or2union_2 t2) or (t1.a = 100 and (t1.b in (select t3.b from t_or2union_3 t3) or t1.c in (select t4.c from t_or2union_4 t4)));
--Rewrite
explain select * from t_or2union_1 t1 join t_or2union_2 t2 on t1.a = t2.a or t1.b = t2.b;
explain select * from t_or2union_1 t1 where t1.a in (select t2.a from t_or2union_2 t2) or t1.b in (select t3.b from t_or2union_3 t3);
explain select * from t_or2union_1 t1 where exists (select 1 from t_or2union_2 t2) or exists (select 1 from t_or2union_3 t3 where t3.a = t1.a);
explain select * from t_or2union_1 t1 join t_or2union_2 t2 on t1.d = t2.d and (t1.a in (select t3.a from t_or2union_3 t3) or t2.c in (select t4.c from t_or2union_4 t4));
explain select * from t_or2union_1 t1 join t_or2union_2 t2 on t1.d = t2.d join t_or2union_3 t3 on t2.d = t3.d where t1.a in (select t4.a from t_or2union_4 t4) or t3.b in (select t5.b from t_or2union_5 t5);
explain select sum(t1.a+t2.b) from t_or2union_1 t1 join t_or2union_2 t2 on t1.a = t2.a or t1.b = t2.b;
explain select distinct t1.a,t2.a,t1.b,t2.b from t_or2union_1 t1 join t_or2union_2 t2 on t1.a = t2.a or t1.b = t2.b;
explain select distinct t1.a,t2.a,t1.b,t2.b from t_or2union_1 t1 join t_or2union_2 t2 on t1.a = t2.a or t1.b = t2.b order by t1.b,t2.b;
explain select t1.a,t2.a,t1.b,t2.b from t_or2union_1 t1 join t_or2union_2 t2 on t1.a = t2.a or t1.b = t2.b order by t2.a,t2.b;
explain select t1.a,t2.b, sum(t1.b) over (partition by t2.a) from t_or2union_1 t1 join t_or2union_2 t2 on t1.a = t2.a or t1.b = t2.b;
explain select t1.a,t2.b, sum(t1.b) over (partition by t2.a) from t_or2union_1 t1 join t_or2union_2 t2 on t1.a = t2.a or t1.b = t2.b order by t1.b,t2.c;
explain select t1.a,t2.a,t1.b,t2.b, sum(t2.c) from t_or2union_1 t1 join t_or2union_2 t2 on t1.a = t2.a or t1.b = t2.b group by t1.a,t2.a,t1.b,t2.b;
explain select t1.a,t2.a,t1.b,t2.b, sum(t2.c) from t_or2union_1 t1 join t_or2union_2 t2 on t1.a = t2.a or t1.b = t2.b group by t1.a,t2.a,t1.b,t2.b order by t1.a,t2.b;
explain select * from t_or2union_1 t1 where exists (select 1 from t_or2union_2 t2 where t1.a = t2.a) or exists (select 1 from t_or2union_3 t3 where t3.a = t1.a) or exists(select 1 from t_or2union_4 t4 where t4.a = t1.a);

--or to union all Not Rewrite (lnnvl not support)
explain select * from t_or2union_1 t1 left join t_or2union_2 t2 on (t1.a = t2.a and t1.a between 10 and 20) or (t1.b = t2.b and t1.c > t2.d)  or t1.c = t2.c where t1.a = 1 and t2.a = 1;
explain select * from t_or2union_1 t1 where t1.a > any (select a from t_or2union_2 t2 where t2.a = t1.a) or exists (select 1 from t_or2union_3 t3 where t3.a = t1.a);
explain select * from t_or2union_1 t1 left join t_or2union_2 t2 on (t1.a = t2.a and t1.a in(1,2,3,4,5)) or (t1.b = t2.b and t1.c > t2.d)  or t1.c = t2.c where t1.a = 1 and t2.a = 1;
--or to union all Not Rewrite (has equal join cond)
explain select * from t_or2union_1 t1 left join t_or2union_2 t2 on t1.a = t2.a or t1.b = t2.b where t1.a = t2.a;

--or to union all can rewrite
explain select * from t_or2union_1 t1 left join t_or2union_2 t2 on t1.a = t2.a or t1.b = t2.b where t1.a = t2.a and t1.a = 1;
explain select * from t_or2union_1 t1 left join t_or2union_2 t2 on (t1.a = t2.a) or (t1.b = t2.b)  or t1.c = t2.c where t1.a = 1 and t2.a = 1;
explain select * from t_or2union_1 t1 left join t_or2union_2 t2 on (t1.a = t2.a and t1.a > t2.b and t1.b >= t2.c) or (t1.b = t2.b and t1.c < t2.d and t1.d != t2.c)  or t1.c = t2.c where t1.a = 1 and t2.a = 1;
explain select * from t_or2union_1 t1 left join t_or2union_2 t2 on (t1.a = t2.a and t1.a like to_char('%' || t2.b || '%') and t1.b is not null and t1.d regexp 1) or (t1.b = t2.b and t1.d != t2.c)  or t1.c = t2.c where t1.a = 1 and t2.a = 1;
explain select * from t_or2union_1 t1 full join t_or2union_2 t2 on (t1.a = t2.a and t1.a > t2.b and 1=1) or (t1.b = t2.b and t1.c < t2.d and t1.d != t2.c)  or t1.c = t2.c or 1!=1 where t1.a = 1 and t2.a = 1;


drop table if exists t_or2union_2;
drop table if exists t_or2union_3;
drop table if exists t_or2union_4;
drop table if exists t_or2union_5;
drop table if exists t_or2union_6;

--view with scn
create view v_or2union_1 as select * from t_or2union_1;
explain select * from v_or2union_1;
explain select * from v_or2union_1 as of scn 2194944746815489;
drop view v_or2union_1;
drop table if exists t_or2union_1;

--DTS2019110503063
drop table if exists explain_t1;
drop table if exists explain_t2;
create table explain_t1(f_int1 int, f_int2 int);
create table explain_t2(f_int1 int, f_int2 int);
insert into explain_t1(f_int1, f_int2) values(1,1);
insert into explain_t2(f_int1, f_int2) values(1,2);
commit;

select t2.f_int1,
      (select x
         from (select abs(t2.f_int1 - t1.f_int1) x, t1.f_int2
                 from explain_t1 t1 order by 1,2)) as F_INT2
 from (select t2.f_int1
         from explain_t2 t2
        group by t2.f_int1) t2
group by t2.f_int1;
drop table explain_t1;
drop table explain_t2;
--DTS2019110600846
drop table if exists t_dense_rank;
create table t_dense_rank(a int constraint cons1_dense_rank primary key,b int);
insert into t_dense_rank values(1,1);
insert into t_dense_rank values(2,3);
insert into t_dense_rank values(3,7);
insert into t_dense_rank values(4,5);
insert into t_dense_rank values(5,2);
explain select dense_rank(2) within group(order by a) from t_dense_rank group by a;
select dense_rank(2) within group(order by a) from t_dense_rank group by a;
--DTS2020021107784
drop table if exists t_DTS2020021107784;
create table t_DTS2020021107784(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10) not null,c_vchar2 varchar2(100),c_clob clob,
c_long varchar(200),c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp);
insert into t_DTS2020021107784 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_DTS2020021107784 values(-1,null,null,null,null,null,null,'M',null,null,null,null,null,null,null);
CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
                sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_real+'||i||',c_float+'||i||',c_decimal+'||i||',c_number+'||i||',c_char'||',c_vchar||'||i||',c_vchar2||'||i||',c_clob||'||i||',c_long||'||i||',c_blob'||',c_raw,ADD_MONTHS(c_date,'||i||'),ADD_MONTHS(c_timestamp,'||i||') from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/
exec proc_insert('t_DTS2020021107784',1,20);
commit;
explain with w_1 as(select sum(id) over(partition by id) id,to_char(c_clob) c_clob from t_DTS2020021107784)select count(*) from w_1 t1 join w_1 t2 on t1.c_clob>t2.c_clob or t1.id=t2.id,w_1 t3 left join w_1 t4 on t4.id=t3.id where exists(select id from w_1 where t2.id=id);
with w_1 as(select sum(id) over(partition by id) id,to_char(c_clob) c_clob from t_DTS2020021107784)select count(*) from w_1 t1 join w_1 t2 on t1.c_clob>t2.c_clob or t1.id=t2.id,w_1 t3 left join w_1 t4 on t4.id=t3.id where exists(select id from w_1 where t2.id=id);
--DTS2020021211230
create index idx_DTS2020021211230_1 on t_DTS2020021107784(c_int,c_vchar,c_vchar2,c_date);
create unique index idx_DTS2020021211230_2 on t_DTS2020021107784(c_real,c_vchar);
create index idx_DTS2020021211230_3 on t_DTS2020021107784(to_char(c_number));
explain with w_1 as(select sum(id) over(partition by id) id from t_DTS2020021107784)select count(*) from t_DTS2020021107784 t1 inner join w_1 t2 on t1.id>t2.id where exists(select id from t_DTS2020021107784 where t2.id=id);
with w_1 as(select sum(id) over(partition by id) id from t_DTS2020021107784)select count(*) from t_DTS2020021107784 t1 inner join w_1 t2 on t1.id>t2.id where exists(select id from t_DTS2020021107784 where t2.id=id);
drop table t_DTS2020021107784;

drop table if exists no_scan_1;
drop table if exists no_scan_2;
create table no_scan_1 (a int not null, b int, c varchar(10));
create table no_scan_2 (a int not null, b int, c varchar(10));

explain select * from no_scan_1 where 1<>1;
explain select t1.a, t2.b from no_scan_1 t1 join no_scan_2 t2 on t1.a = t2.a where rownum = -1;
explain select * from no_scan_1 where 1<>1 union select * from no_scan_2 ;
explain select count(*) from no_scan_1 t1 where a in (select b from no_scan_2 t2 where t2.a = t1.a and 1<>1);
drop table no_scan_1;
drop table no_scan_2;

drop table if exists t_const2num_1;
drop table if exists t_const2num_2;
create table t_const2num_1(
c_int int, c_binary_uint binary_uint32, c_int_unsigned integer unsigned, c_bigint bigint,
c_double double, c_float float, c_real real,
c_number number, c_dec decimal(20,5),
c_varchar varchar(50)
) ;
create table t_const2num_2(
c_int int, c_binary_uint binary_uint32, c_int_unsigned integer unsigned, c_bigint bigint,
c_double double, c_float float, c_real real,
c_number number, c_dec decimal(20,5),
c_varchar varchar(50)
) ;
insert into t_const2num_1 values(
1, 5, 4294967295, 9223372036854775807,
1.12345, 0.001, 123.456,
1.234, 123456.12345,
'hello'
);
insert into t_const2num_2 values(
1, 100, 4294967295, 9223372036854775807,
1.12345, 10.00001, 1234.567,
1.234, 123456.12345,
'nihao'
);
commit;

explain select c_int, c_varchar from t_const2num_1 where c_int = '1';
explain select c_int, c_varchar from t_const2num_1 where c_bigint = '9223372036854775807';
explain select c_int, c_varchar from t_const2num_1 where '-1.001' < c_real;
explain select c_int, c_varchar from t_const2num_1 where abs(c_number) = '+1.234';
explain select c_int, c_varchar from t_const2num_1 where c_dec + 1 = '123457.12345';
explain select c_int, count(c_int) from t_const2num_1 group by c_int having count(c_int) = '1.0';
explain select c_int, c_varchar from t_const2num_1 where '1' = (select count(*) from t_const2num_2);

drop table t_const2num_1;
drop table t_const2num_2;

--
drop table if exists hint_index_t1;
create table hint_index_t1(a int, b int, c int);
create index hint_index_a on hint_index_t1(a);
create index hint_index_b on hint_index_t1(b);
create index hint_index_c on hint_index_t1(c);
alter index hint_index_a on hint_index_t1 unusable;
explain select /*+INDEX(i, hint_index_b)*/ i.a from hint_index_t1 i where i.b = 1;
explain select /*+INDEX(i, hint_index_a)*/ i.a from hint_index_t1 i where i.b = 1;
drop table hint_index_t1;

drop table if exists t_explain_index;
create table t_explain_index(id varchar(10), name varchar(10));
create unique index t_explain_index_idx1 on t_explain_index(id, name);
explain select * from t_explain_index where id='000001';
explain select * from t_explain_index where id='000001' and name='index';
drop table t_explain_index;

-- reserved word false/true/null is const expr node
drop table if exists res_as_const_node_t1;
create table res_as_const_node_t1
(
    id number(4) not null
);

explain select * from res_as_const_node_t1 where false;
explain select * from res_as_const_node_t1 where true;
explain select * from res_as_const_node_t1 where null;
drop table res_as_const_node_t1;

-- Longest table name + alias + parallel information
drop table if exists AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
create table AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA(id number(8));
explain plan for select /*+parallel(16)*/ * from AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB;
drop table AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
--20201031
drop table if exists  t_stack_or_001; 
create table t_stack_or_001 (id int,c1 varchar(8000),c2 varchar(8000),c3 varchar(8000)); 
declare 
begin 
for i in 1..2000 loop 
insert into t_stack_or_001 values (i,rpad('12',20,2),rpad('12',20,i),rpad('23',20,i)); 
end loop; 
for i in 2001..4000 loop 
insert into t_stack_or_001 values (i,rpad('abc',20,i),rpad('23',20,2),rpad('12',20,i)); 
end loop; 
for i in 4001..8000 loop 
insert into t_stack_or_001 values (i,rpad('ab',20,2),rpad('45',20,2),rpad('12',20,2)); 
end loop;
commit; 
end; 
/ 
drop table if exists t_stack_or_002; 
create table t_stack_or_002 (id int,c1 varchar(8000),c2 varchar(8000),c3 varchar(8000)); 
declare 
begin 
for i in 1..2000 loop 
insert into t_stack_or_002 values (i,rpad('12',20,2),rpad('12',20,i),rpad('23',20,i)); 
end loop; 
for i in 2001..4000 loop 
insert into t_stack_or_002 values (i,rpad('abc',20,i),rpad('23',20,2),rpad('12',20,i)); 
end loop; 
for i in 4001..8000 loop 
insert into t_stack_or_002 values (i,rpad('ab',20,2),rpad('45',20,2),rpad('12',20,2)); 
end loop; 
commit; 
end; 
/
explain SELECT * FROM ( SELECT ROWNUM rn,  t.* FROM ( SELECT  * FROM(
            SELECT id,c1,c2 from t_stack_or_001 p join (select 1100 from sys_dummy
 MINUS select 1212 from sys_dummy MINUS select 1000 from sys_dummy MINUS select 1001 from sys_dummy MINUS select 1002 from sys_dummy MINUS select 1003 from sys_dummy
 MINUS select 1004 from sys_dummy MINUS select 1005 from sys_dummy MINUS select 1006 from sys_dummy MINUS select 1007 from sys_dummy MINUS select 1008 from sys_dummy
 MINUS select 1009 from sys_dummy MINUS select 1010 from sys_dummy MINUS select 1011 from sys_dummy MINUS select 1012 from sys_dummy MINUS select 1013 from sys_dummy
 MINUS select 1014 from sys_dummy MINUS select 1015 from sys_dummy MINUS select 1016 from sys_dummy MINUS select 1017 from sys_dummy MINUS select 1018 from sys_dummy
 MINUS select 1019 from sys_dummy MINUS select 1020 from sys_dummy MINUS select 1021 from sys_dummy MINUS select 1022 from sys_dummy MINUS select 1023 from sys_dummy
 MINUS select 1024 from sys_dummy MINUS select 1025 from sys_dummy MINUS select 1026 from sys_dummy MINUS select 1027 from sys_dummy MINUS select 1028 from sys_dummy
 MINUS select 1029 from sys_dummy MINUS select 1030 from sys_dummy MINUS select 1031 from sys_dummy MINUS select 1032 from sys_dummy MINUS select 1033 from sys_dummy
 MINUS select 1034 from sys_dummy MINUS select 1035 from sys_dummy MINUS select 1036 from sys_dummy MINUS select 1037 from sys_dummy MINUS select 1038 from sys_dummy
 MINUS select 1039 from sys_dummy MINUS select 1040 from sys_dummy MINUS select 1041 from sys_dummy MINUS select 1042 from sys_dummy MINUS select 1043 from sys_dummy
 MINUS select 1044 from sys_dummy MINUS select 1045 from sys_dummy MINUS select 1046 from sys_dummy MINUS select 1047 from sys_dummy MINUS select 1048 from sys_dummy
 MINUS select 1049 from sys_dummy MINUS select 1050 from sys_dummy MINUS select 1051 from sys_dummy MINUS select 1052 from sys_dummy MINUS select 1053 from sys_dummy
 MINUS select 1054 from sys_dummy MINUS select 1055 from sys_dummy MINUS select 1056 from sys_dummy MINUS select 1057 from sys_dummy MINUS select 1058 from sys_dummy
 MINUS select 1059 from sys_dummy MINUS select 1060 from sys_dummy MINUS select 1061 from sys_dummy MINUS select 1062 from sys_dummy MINUS select 1063 from sys_dummy
 MINUS select 1064 from sys_dummy MINUS select 1065 from sys_dummy MINUS select 1066 from sys_dummy MINUS select 1067 from sys_dummy MINUS select 1068 from sys_dummy
 MINUS select 1069 from sys_dummy MINUS select 1070 from sys_dummy MINUS select 1071 from sys_dummy MINUS select 1072 from sys_dummy MINUS select 1073 from sys_dummy
 MINUS select 1074 from sys_dummy MINUS select 1075 from sys_dummy MINUS select 1076 from sys_dummy MINUS select 1077 from sys_dummy MINUS select 1078 from sys_dummy
 MINUS select 1079 from sys_dummy MINUS select 1080 from sys_dummy MINUS select 1081 from sys_dummy MINUS select 1082 from sys_dummy MINUS select 1083 from sys_dummy
 MINUS select 1084 from sys_dummy MINUS select 1085 from sys_dummy MINUS select 1086 from sys_dummy MINUS select 1087 from sys_dummy MINUS select 1088 from sys_dummy
 MINUS select 1089 from sys_dummy MINUS select 1090 from sys_dummy MINUS select 1091 from sys_dummy MINUS select 1092 from sys_dummy MINUS select 1093 from sys_dummy
 MINUS select 1094 from sys_dummy MINUS select 1095 from sys_dummy MINUS select 1096 from sys_dummy MINUS select 1097 from sys_dummy MINUS select 1098 from sys_dummy
 MINUS select 1099 from sys_dummy MINUS select 1100 from sys_dummy MINUS select 1101 from sys_dummy MINUS select 1102 from sys_dummy MINUS select 1103 from sys_dummy
 MINUS select 1104 from sys_dummy MINUS select 1105 from sys_dummy MINUS select 1106 from sys_dummy MINUS select 1107 from sys_dummy MINUS select 1108 from sys_dummy
 MINUS select 1109 from sys_dummy MINUS select 1110 from sys_dummy MINUS select 1111 from sys_dummy MINUS select 1112 from sys_dummy MINUS select 1113 from sys_dummy
 MINUS select 1114 from sys_dummy MINUS select 1115 from sys_dummy MINUS select 1116 from sys_dummy MINUS select 1117 from sys_dummy MINUS select 1118 from sys_dummy
 MINUS select 1119 from sys_dummy MINUS select 1120 from sys_dummy MINUS select 1121 from sys_dummy MINUS select 1122 from sys_dummy MINUS select 1123 from sys_dummy
 MINUS select 1124 from sys_dummy MINUS select 1125 from sys_dummy MINUS select 1126 from sys_dummy MINUS select 1127 from sys_dummy MINUS select 1128 from sys_dummy
 MINUS select 1129 from sys_dummy MINUS select 1130 from sys_dummy MINUS select 1131 from sys_dummy MINUS select 1132 from sys_dummy MINUS select 1133 from sys_dummy
 MINUS select 1134 from sys_dummy MINUS select 1135 from sys_dummy MINUS select 1136 from sys_dummy MINUS select 1137 from sys_dummy MINUS select 1138 from sys_dummy
 MINUS select 1139 from sys_dummy MINUS select 1140 from sys_dummy MINUS select 1141 from sys_dummy MINUS select 1142 from sys_dummy MINUS select 1143 from sys_dummy
 MINUS select 1144 from sys_dummy MINUS select 1145 from sys_dummy MINUS select 1146 from sys_dummy MINUS select 1147 from sys_dummy MINUS select 1148 from sys_dummy
 MINUS select 1149 from sys_dummy MINUS select 1150 from sys_dummy MINUS select 1151 from sys_dummy MINUS select 1152 from sys_dummy MINUS select 1153 from sys_dummy
 MINUS select 1154 from sys_dummy MINUS select 1155 from sys_dummy MINUS select 1156 from sys_dummy MINUS select 1157 from sys_dummy MINUS select 1158 from sys_dummy
 MINUS select 1159 from sys_dummy MINUS select 1160 from sys_dummy MINUS select 1161 from sys_dummy MINUS select 1162 from sys_dummy MINUS select 1163 from sys_dummy
 MINUS select 1164 from sys_dummy MINUS select 1165 from sys_dummy MINUS select 1166 from sys_dummy MINUS select 1167 from sys_dummy MINUS select 1168 from sys_dummy
 MINUS select 1169 from sys_dummy MINUS select 1170 from sys_dummy MINUS select 1171 from sys_dummy MINUS select 1172 from sys_dummy MINUS select 1173 from sys_dummy
 MINUS select 1174 from sys_dummy MINUS select 1175 from sys_dummy MINUS select 1176 from sys_dummy MINUS select 1177 from sys_dummy MINUS select 1178 from sys_dummy
 MINUS select 1179 from sys_dummy MINUS select 1180 from sys_dummy MINUS select 1181 from sys_dummy MINUS select 1182 from sys_dummy MINUS select 1183 from sys_dummy
 MINUS select 1184 from sys_dummy MINUS select 1185 from sys_dummy MINUS select 1186 from sys_dummy MINUS select 1187 from sys_dummy MINUS select 1188 from sys_dummy
 MINUS select 1189 from sys_dummy MINUS select 1190 from sys_dummy MINUS select 1191 from sys_dummy MINUS select 1192 from sys_dummy MINUS select 1193 from sys_dummy
 MINUS select 1194 from sys_dummy MINUS select 1195 from sys_dummy MINUS select 1196 from sys_dummy MINUS select 1197 from sys_dummy MINUS select 1198 from sys_dummy
 MINUS select 1199 from sys_dummy MINUS select 1200 from sys_dummy MINUS select 1201 from sys_dummy MINUS select 1202 from sys_dummy MINUS select 1203 from sys_dummy
 MINUS select 1204 from sys_dummy MINUS select 1205 from sys_dummy MINUS select 1206 from sys_dummy MINUS select 1207 from sys_dummy MINUS select 1208 from sys_dummy
 MINUS select 1209 from sys_dummy MINUS select 1210 from sys_dummy MINUS select 1211 from sys_dummy MINUS select 1212 from sys_dummy MINUS select 1213 from sys_dummy
 MINUS select 1214 from sys_dummy MINUS select 1215 from sys_dummy MINUS select 1216 from sys_dummy MINUS select 1217 from sys_dummy MINUS select 1218 from sys_dummy
 MINUS select 1219 from sys_dummy MINUS select 1220 from sys_dummy MINUS select 1221 from sys_dummy MINUS select 1222 from sys_dummy MINUS select 1223 from sys_dummy
 MINUS select 1224 from sys_dummy MINUS select 1225 from sys_dummy MINUS select 1226 from sys_dummy MINUS select 1227 from sys_dummy MINUS select 1228 from sys_dummy
 MINUS select 1229 from sys_dummy MINUS select 1230 from sys_dummy MINUS select 1231 from sys_dummy MINUS select 1232 from sys_dummy MINUS select 1233 from sys_dummy
 MINUS select 1234 from sys_dummy MINUS select 1235 from sys_dummy MINUS select 1236 from sys_dummy MINUS select 1237 from sys_dummy MINUS select 1238 from sys_dummy
 MINUS select 1239 from sys_dummy MINUS select 1240 from sys_dummy MINUS select 1241 from sys_dummy MINUS select 1242 from sys_dummy MINUS select 1243 from sys_dummy
 MINUS select 1244 from sys_dummy MINUS select 1245 from sys_dummy MINUS select 1246 from sys_dummy MINUS select 1247 from sys_dummy MINUS select 1248 from sys_dummy
 MINUS select 1249 from sys_dummy MINUS select 1250 from sys_dummy MINUS select 1251 from sys_dummy MINUS select 1252 from sys_dummy MINUS select 1253 from sys_dummy
 MINUS select 1254 from sys_dummy MINUS select 1255 from sys_dummy MINUS select 1256 from sys_dummy MINUS select 1257 from sys_dummy MINUS select 1258 from sys_dummy
 MINUS select 1259 from sys_dummy MINUS select 1260 from sys_dummy MINUS select 1261 from sys_dummy MINUS select 1262 from sys_dummy MINUS select 1263 from sys_dummy
 MINUS select 1264 from sys_dummy MINUS select 1265 from sys_dummy MINUS select 1266 from sys_dummy MINUS select 1267 from sys_dummy MINUS select 1268 from sys_dummy
 MINUS select 1269 from sys_dummy MINUS select 1270 from sys_dummy MINUS select 1271 from sys_dummy MINUS select 1272 from sys_dummy MINUS select 1273 from sys_dummy
 MINUS select 1274 from sys_dummy MINUS select 1275 from sys_dummy MINUS select 1276 from sys_dummy MINUS select 1277 from sys_dummy MINUS select 1278 from sys_dummy
 MINUS select 1279 from sys_dummy MINUS select 1280 from sys_dummy MINUS select 1281 from sys_dummy MINUS select 1282 from sys_dummy MINUS select 1283 from sys_dummy
 MINUS select 1284 from sys_dummy MINUS select 1285 from sys_dummy MINUS select 1286 from sys_dummy MINUS select 1287 from sys_dummy MINUS select 1288 from sys_dummy
 MINUS select 1289 from sys_dummy MINUS select 1290 from sys_dummy MINUS select 1291 from sys_dummy MINUS select 1292 from sys_dummy MINUS select 1293 from sys_dummy
 MINUS select 1294 from sys_dummy MINUS select 1295 from sys_dummy MINUS select 1296 from sys_dummy MINUS select 1297 from sys_dummy MINUS select 1298 from sys_dummy
 MINUS select 1299 from sys_dummy MINUS select 1300 from sys_dummy MINUS select 1301 from sys_dummy MINUS select 1302 from sys_dummy MINUS select 1303 from sys_dummy
 MINUS select 1304 from sys_dummy MINUS select 1305 from sys_dummy MINUS select 1306 from sys_dummy MINUS select 1307 from sys_dummy MINUS select 1308 from sys_dummy
 MINUS select 1309 from sys_dummy MINUS select 1310 from sys_dummy MINUS select 1311 from sys_dummy MINUS select 1312 from sys_dummy MINUS select 1313 from sys_dummy
 MINUS select 1314 from sys_dummy MINUS select 1315 from sys_dummy MINUS select 1316 from sys_dummy MINUS select 1317 from sys_dummy MINUS select 1318 from sys_dummy
 MINUS select 1319 from sys_dummy MINUS select 1320 from sys_dummy MINUS select 1321 from sys_dummy MINUS select 1322 from sys_dummy MINUS select 1323 from sys_dummy
 MINUS select 1324 from sys_dummy MINUS select 1325 from sys_dummy MINUS select 1326 from sys_dummy MINUS select 1327 from sys_dummy MINUS select 1328 from sys_dummy
 MINUS select 1329 from sys_dummy MINUS select 1330 from sys_dummy MINUS select 1331 from sys_dummy MINUS select 1332 from sys_dummy MINUS select 1333 from sys_dummy
 MINUS select 1334 from sys_dummy MINUS select 1335 from sys_dummy MINUS select 1336 from sys_dummy MINUS select 1337 from sys_dummy MINUS select 1338 from sys_dummy
 MINUS select 1339 from sys_dummy MINUS select 1340 from sys_dummy MINUS select 1341 from sys_dummy MINUS select 1342 from sys_dummy MINUS select 1343 from sys_dummy
 MINUS select 1344 from sys_dummy MINUS select 1345 from sys_dummy MINUS select 1346 from sys_dummy MINUS select 1347 from sys_dummy MINUS select 1348 from sys_dummy
 MINUS select 1349 from sys_dummy MINUS select 1350 from sys_dummy MINUS select 1351 from sys_dummy MINUS select 1352 from sys_dummy MINUS select 1353 from sys_dummy
 MINUS select 1354 from sys_dummy MINUS select 1399 from sys_dummy MINUS select 1384 from sys_dummy MINUS select 1444 from sys_dummy MINUS select 1748 from sys_dummy
 MINUS select 1355 from sys_dummy MINUS select 1400 from sys_dummy MINUS select 1385 from sys_dummy MINUS select 1445 from sys_dummy MINUS select 1749 from sys_dummy
 MINUS select 1356 from sys_dummy MINUS select 1401 from sys_dummy MINUS select 1386 from sys_dummy MINUS select 1446 from sys_dummy MINUS select 1750 from sys_dummy
 MINUS select 1357 from sys_dummy MINUS select 1402 from sys_dummy MINUS select 1387 from sys_dummy MINUS select 1447 from sys_dummy MINUS select 1751 from sys_dummy
 MINUS select 1358 from sys_dummy MINUS select 1403 from sys_dummy MINUS select 1388 from sys_dummy MINUS select 1448 from sys_dummy MINUS select 1752 from sys_dummy
 MINUS select 1359 from sys_dummy MINUS select 1404 from sys_dummy MINUS select 1389 from sys_dummy MINUS select 1449 from sys_dummy MINUS select 1753 from sys_dummy
 MINUS select 1360 from sys_dummy MINUS select 1405 from sys_dummy MINUS select 1390 from sys_dummy MINUS select 1450 from sys_dummy MINUS select 1754 from sys_dummy
 MINUS select 1361 from sys_dummy MINUS select 1406 from sys_dummy MINUS select 1391 from sys_dummy MINUS select 1451 from sys_dummy MINUS select 1755 from sys_dummy
 MINUS select 1362 from sys_dummy MINUS select 1407 from sys_dummy MINUS select 1392 from sys_dummy MINUS select 1452 from sys_dummy MINUS select 1756 from sys_dummy
 MINUS select 1363 from sys_dummy MINUS select 1408 from sys_dummy MINUS select 1393 from sys_dummy MINUS select 1453 from sys_dummy MINUS select 1757 from sys_dummy
 MINUS select 1364 from sys_dummy MINUS select 1409 from sys_dummy MINUS select 1394 from sys_dummy MINUS select 1454 from sys_dummy MINUS select 1758 from sys_dummy
 MINUS select 1365 from sys_dummy MINUS select 1410 from sys_dummy MINUS select 1395 from sys_dummy MINUS select 1455 from sys_dummy MINUS select 1759 from sys_dummy
 MINUS select 1366 from sys_dummy MINUS select 1411 from sys_dummy MINUS select 1396 from sys_dummy MINUS select 1456 from sys_dummy MINUS select 1760 from sys_dummy
 MINUS select 1367 from sys_dummy MINUS select 1412 from sys_dummy MINUS select 1397 from sys_dummy MINUS select 1457 from sys_dummy MINUS select 1761 from sys_dummy
 MINUS select 1368 from sys_dummy MINUS select 1413 from sys_dummy MINUS select 1398 from sys_dummy MINUS select 1458 from sys_dummy MINUS select 1762 from sys_dummy
 MINUS select 1369 from sys_dummy MINUS select 1414 from sys_dummy MINUS select 1429 from sys_dummy MINUS select 1459 from sys_dummy MINUS select 1763 from sys_dummy
 MINUS select 1370 from sys_dummy MINUS select 1415 from sys_dummy MINUS select 1430 from sys_dummy MINUS select 1460 from sys_dummy MINUS select 1764 from sys_dummy
 MINUS select 1371 from sys_dummy MINUS select 1416 from sys_dummy MINUS select 1431 from sys_dummy MINUS select 1461 from sys_dummy MINUS select 1765 from sys_dummy
 MINUS select 1372 from sys_dummy MINUS select 1417 from sys_dummy MINUS select 1432 from sys_dummy MINUS select 1462 from sys_dummy MINUS select 1766 from sys_dummy
 MINUS select 1373 from sys_dummy MINUS select 1418 from sys_dummy MINUS select 1433 from sys_dummy MINUS select 1463 from sys_dummy MINUS select 1767 from sys_dummy
 MINUS select 1374 from sys_dummy MINUS select 1419 from sys_dummy MINUS select 1434 from sys_dummy MINUS select 1464 from sys_dummy MINUS select 1768 from sys_dummy
 MINUS select 1375 from sys_dummy MINUS select 1420 from sys_dummy MINUS select 1435 from sys_dummy MINUS select 1465 from sys_dummy MINUS select 1733 from sys_dummy
 MINUS select 1376 from sys_dummy MINUS select 1421 from sys_dummy MINUS select 1436 from sys_dummy MINUS select 1466 from sys_dummy MINUS select 1734 from sys_dummy
 MINUS select 1377 from sys_dummy MINUS select 1422 from sys_dummy MINUS select 1437 from sys_dummy MINUS select 1467 from sys_dummy MINUS select 1735 from sys_dummy
 MINUS select 1378 from sys_dummy MINUS select 1423 from sys_dummy MINUS select 1438 from sys_dummy MINUS select 1468 from sys_dummy MINUS select 1736 from sys_dummy
 MINUS select 1379 from sys_dummy MINUS select 1424 from sys_dummy MINUS select 1439 from sys_dummy MINUS select 1469 from sys_dummy MINUS select 1737 from sys_dummy
 MINUS select 1380 from sys_dummy MINUS select 1425 from sys_dummy MINUS select 1440 from sys_dummy MINUS select 1470 from sys_dummy MINUS select 1738 from sys_dummy
 MINUS select 1381 from sys_dummy MINUS select 1426 from sys_dummy MINUS select 1441 from sys_dummy MINUS select 1471 from sys_dummy MINUS select 1739 from sys_dummy
 MINUS select 1382 from sys_dummy MINUS select 1427 from sys_dummy MINUS select 1442 from sys_dummy MINUS select 1472 from sys_dummy MINUS select 1740 from sys_dummy
 MINUS select 1383 from sys_dummy MINUS select 1428 from sys_dummy MINUS select 1443 from sys_dummy MINUS select 1473 from sys_dummy MINUS select 1741 from sys_dummy
 MINUS select 1474 from sys_dummy MINUS select 1769 from sys_dummy MINUS select 1636 from sys_dummy MINUS select 1931 from sys_dummy MINUS select 1742 from sys_dummy
 MINUS select 1475 from sys_dummy MINUS select 1770 from sys_dummy MINUS select 1637 from sys_dummy MINUS select 1932 from sys_dummy MINUS select 1743 from sys_dummy
 MINUS select 1476 from sys_dummy MINUS select 1771 from sys_dummy MINUS select 1638 from sys_dummy MINUS select 1933 from sys_dummy MINUS select 1744 from sys_dummy
 MINUS select 1477 from sys_dummy MINUS select 1772 from sys_dummy MINUS select 1639 from sys_dummy MINUS select 1934 from sys_dummy MINUS select 1745 from sys_dummy
 MINUS select 1478 from sys_dummy MINUS select 1773 from sys_dummy MINUS select 1640 from sys_dummy MINUS select 1935 from sys_dummy MINUS select 1746 from sys_dummy
 MINUS select 1479 from sys_dummy MINUS select 1774 from sys_dummy MINUS select 1641 from sys_dummy MINUS select 1936 from sys_dummy MINUS select 1704 from sys_dummy
 MINUS select 1480 from sys_dummy MINUS select 1775 from sys_dummy MINUS select 1642 from sys_dummy MINUS select 1937 from sys_dummy MINUS select 1705 from sys_dummy
 MINUS select 1481 from sys_dummy MINUS select 1776 from sys_dummy MINUS select 1643 from sys_dummy MINUS select 1938 from sys_dummy MINUS select 1706 from sys_dummy
 MINUS select 1482 from sys_dummy MINUS select 1777 from sys_dummy MINUS select 1644 from sys_dummy MINUS select 1939 from sys_dummy MINUS select 1707 from sys_dummy
 MINUS select 1483 from sys_dummy MINUS select 1778 from sys_dummy MINUS select 1645 from sys_dummy MINUS select 1940 from sys_dummy MINUS select 1708 from sys_dummy
 MINUS select 1484 from sys_dummy MINUS select 1779 from sys_dummy MINUS select 1646 from sys_dummy MINUS select 1941 from sys_dummy MINUS select 1709 from sys_dummy
 MINUS select 1485 from sys_dummy MINUS select 1780 from sys_dummy MINUS select 1647 from sys_dummy MINUS select 1942 from sys_dummy MINUS select 1710 from sys_dummy
 MINUS select 1486 from sys_dummy MINUS select 1781 from sys_dummy MINUS select 1648 from sys_dummy MINUS select 1943 from sys_dummy MINUS select 1711 from sys_dummy
 MINUS select 1487 from sys_dummy MINUS select 1782 from sys_dummy MINUS select 1649 from sys_dummy MINUS select 1944 from sys_dummy MINUS select 1712 from sys_dummy
 MINUS select 1488 from sys_dummy MINUS select 1783 from sys_dummy MINUS select 1650 from sys_dummy MINUS select 1945 from sys_dummy MINUS select 1713 from sys_dummy
 MINUS select 1489 from sys_dummy MINUS select 1784 from sys_dummy MINUS select 1651 from sys_dummy MINUS select 1946 from sys_dummy MINUS select 1714 from sys_dummy
 MINUS select 1490 from sys_dummy MINUS select 1785 from sys_dummy MINUS select 1652 from sys_dummy MINUS select 1947 from sys_dummy MINUS select 1715 from sys_dummy
 MINUS select 1491 from sys_dummy MINUS select 1786 from sys_dummy MINUS select 1653 from sys_dummy MINUS select 1948 from sys_dummy MINUS select 1716 from sys_dummy
 MINUS select 1492 from sys_dummy MINUS select 1787 from sys_dummy MINUS select 1654 from sys_dummy MINUS select 1949 from sys_dummy MINUS select 1717 from sys_dummy
 MINUS select 1493 from sys_dummy MINUS select 1788 from sys_dummy MINUS select 1655 from sys_dummy MINUS select 1950 from sys_dummy MINUS select 1718 from sys_dummy
 MINUS select 1494 from sys_dummy MINUS select 1789 from sys_dummy MINUS select 1656 from sys_dummy MINUS select 1951 from sys_dummy MINUS select 1719 from sys_dummy
 MINUS select 1495 from sys_dummy MINUS select 1790 from sys_dummy MINUS select 1657 from sys_dummy MINUS select 1952 from sys_dummy MINUS select 1720 from sys_dummy
 MINUS select 1496 from sys_dummy MINUS select 1791 from sys_dummy MINUS select 1658 from sys_dummy MINUS select 1953 from sys_dummy MINUS select 1721 from sys_dummy
 MINUS select 1497 from sys_dummy MINUS select 1792 from sys_dummy MINUS select 1659 from sys_dummy MINUS select 1954 from sys_dummy MINUS select 1722 from sys_dummy
 MINUS select 1498 from sys_dummy MINUS select 1793 from sys_dummy MINUS select 1660 from sys_dummy MINUS select 1955 from sys_dummy MINUS select 1723 from sys_dummy
 MINUS select 1499 from sys_dummy MINUS select 1794 from sys_dummy MINUS select 1661 from sys_dummy MINUS select 1956 from sys_dummy MINUS select 1724 from sys_dummy
 MINUS select 1500 from sys_dummy MINUS select 1795 from sys_dummy MINUS select 1662 from sys_dummy MINUS select 1957 from sys_dummy MINUS select 1725 from sys_dummy
 MINUS select 1501 from sys_dummy MINUS select 1796 from sys_dummy MINUS select 1663 from sys_dummy MINUS select 1958 from sys_dummy MINUS select 1726 from sys_dummy
 MINUS select 1502 from sys_dummy MINUS select 1797 from sys_dummy MINUS select 1664 from sys_dummy MINUS select 1959 from sys_dummy MINUS select 1727 from sys_dummy
 MINUS select 1503 from sys_dummy MINUS select 1798 from sys_dummy MINUS select 1665 from sys_dummy MINUS select 1960 from sys_dummy MINUS select 1728 from sys_dummy
 MINUS select 1504 from sys_dummy MINUS select 1799 from sys_dummy MINUS select 1666 from sys_dummy MINUS select 1961 from sys_dummy MINUS select 1729 from sys_dummy
 MINUS select 1505 from sys_dummy MINUS select 1800 from sys_dummy MINUS select 1667 from sys_dummy MINUS select 1962 from sys_dummy MINUS select 1730 from sys_dummy
 MINUS select 1506 from sys_dummy MINUS select 1801 from sys_dummy MINUS select 1668 from sys_dummy MINUS select 1963 from sys_dummy MINUS select 1731 from sys_dummy
 MINUS select 1507 from sys_dummy MINUS select 1802 from sys_dummy MINUS select 1673 from sys_dummy MINUS select 1968 from sys_dummy MINUS select 1732 from sys_dummy
 MINUS select 1508 from sys_dummy MINUS select 1803 from sys_dummy MINUS select 1674 from sys_dummy MINUS select 1969 from sys_dummy MINUS select 1747 from sys_dummy
 MINUS select 1509 from sys_dummy MINUS select 1804 from sys_dummy MINUS select 1675 from sys_dummy MINUS select 1970 from sys_dummy MINUS select 1999 from sys_dummy
 MINUS select 1510 from sys_dummy MINUS select 1805 from sys_dummy MINUS select 1676 from sys_dummy MINUS select 1971 from sys_dummy MINUS select 1601 from sys_dummy
 MINUS select 1511 from sys_dummy MINUS select 1806 from sys_dummy MINUS select 1677 from sys_dummy MINUS select 1972 from sys_dummy MINUS select 1896 from sys_dummy
 MINUS select 1512 from sys_dummy MINUS select 1807 from sys_dummy MINUS select 1678 from sys_dummy MINUS select 1973 from sys_dummy MINUS select 1602 from sys_dummy
 MINUS select 1513 from sys_dummy MINUS select 1808 from sys_dummy MINUS select 1679 from sys_dummy MINUS select 1974 from sys_dummy MINUS select 1897 from sys_dummy
 MINUS select 1514 from sys_dummy MINUS select 1809 from sys_dummy MINUS select 1680 from sys_dummy MINUS select 1975 from sys_dummy
 MINUS select 1515 from sys_dummy MINUS select 1810 from sys_dummy MINUS select 1681 from sys_dummy MINUS select 1976 from sys_dummy
 MINUS select 1516 from sys_dummy MINUS select 1811 from sys_dummy MINUS select 1682 from sys_dummy MINUS select 1977 from sys_dummy
 MINUS select 1517 from sys_dummy MINUS select 1812 from sys_dummy MINUS select 1683 from sys_dummy MINUS select 1978 from sys_dummy
 MINUS select 1518 from sys_dummy MINUS select 1813 from sys_dummy MINUS select 1684 from sys_dummy MINUS select 1979 from sys_dummy
 MINUS select 1519 from sys_dummy MINUS select 1814 from sys_dummy MINUS select 1685 from sys_dummy MINUS select 1980 from sys_dummy
 MINUS select 1520 from sys_dummy MINUS select 1815 from sys_dummy MINUS select 1686 from sys_dummy MINUS select 1981 from sys_dummy
 MINUS select 1521 from sys_dummy MINUS select 1816 from sys_dummy MINUS select 1687 from sys_dummy MINUS select 1982 from sys_dummy
 MINUS select 1522 from sys_dummy MINUS select 1817 from sys_dummy MINUS select 1688 from sys_dummy MINUS select 1983 from sys_dummy
 MINUS select 1523 from sys_dummy MINUS select 1818 from sys_dummy MINUS select 1689 from sys_dummy MINUS select 1984 from sys_dummy
 MINUS select 1524 from sys_dummy MINUS select 1819 from sys_dummy MINUS select 1690 from sys_dummy MINUS select 1985 from sys_dummy
 MINUS select 1525 from sys_dummy MINUS select 1820 from sys_dummy MINUS select 1691 from sys_dummy MINUS select 1986 from sys_dummy
 MINUS select 1526 from sys_dummy MINUS select 1821 from sys_dummy MINUS select 1692 from sys_dummy MINUS select 1987 from sys_dummy
 MINUS select 1527 from sys_dummy MINUS select 1822 from sys_dummy MINUS select 1693 from sys_dummy MINUS select 1988 from sys_dummy
 MINUS select 1528 from sys_dummy MINUS select 1823 from sys_dummy MINUS select 1694 from sys_dummy MINUS select 1989 from sys_dummy
 MINUS select 1529 from sys_dummy MINUS select 1824 from sys_dummy MINUS select 1695 from sys_dummy MINUS select 1990 from sys_dummy
 MINUS select 1530 from sys_dummy MINUS select 1825 from sys_dummy MINUS select 1696 from sys_dummy MINUS select 1991 from sys_dummy
 MINUS select 1531 from sys_dummy MINUS select 1826 from sys_dummy MINUS select 1697 from sys_dummy MINUS select 1992 from sys_dummy
 MINUS select 1532 from sys_dummy MINUS select 1827 from sys_dummy MINUS select 1698 from sys_dummy MINUS select 1993 from sys_dummy
 MINUS select 1533 from sys_dummy MINUS select 1828 from sys_dummy MINUS select 1699 from sys_dummy MINUS select 1994 from sys_dummy
 MINUS select 1534 from sys_dummy MINUS select 1829 from sys_dummy MINUS select 1700 from sys_dummy MINUS select 1995 from sys_dummy
 MINUS select 1535 from sys_dummy MINUS select 1830 from sys_dummy MINUS select 1701 from sys_dummy MINUS select 1996 from sys_dummy
 MINUS select 1536 from sys_dummy MINUS select 1831 from sys_dummy MINUS select 1702 from sys_dummy MINUS select 1997 from sys_dummy
 MINUS select 1537 from sys_dummy MINUS select 1832 from sys_dummy MINUS select 1703 from sys_dummy MINUS select 1998 from sys_dummy
 MINUS select 1538 from sys_dummy MINUS select 1833 from sys_dummy MINUS select 1603 from sys_dummy MINUS select 1898 from sys_dummy
 MINUS select 1539 from sys_dummy MINUS select 1834 from sys_dummy MINUS select 1604 from sys_dummy MINUS select 1899 from sys_dummy
 MINUS select 1540 from sys_dummy MINUS select 1835 from sys_dummy MINUS select 1605 from sys_dummy MINUS select 1900 from sys_dummy
 MINUS select 1541 from sys_dummy MINUS select 1836 from sys_dummy MINUS select 1606 from sys_dummy MINUS select 1901 from sys_dummy
 MINUS select 1542 from sys_dummy MINUS select 1837 from sys_dummy MINUS select 1607 from sys_dummy MINUS select 1902 from sys_dummy
 MINUS select 1543 from sys_dummy MINUS select 1838 from sys_dummy MINUS select 1608 from sys_dummy MINUS select 1903 from sys_dummy
 MINUS select 1544 from sys_dummy MINUS select 1839 from sys_dummy MINUS select 1609 from sys_dummy MINUS select 1904 from sys_dummy
 MINUS select 1545 from sys_dummy MINUS select 1840 from sys_dummy MINUS select 1610 from sys_dummy MINUS select 1905 from sys_dummy
 MINUS select 1546 from sys_dummy MINUS select 1841 from sys_dummy MINUS select 1611 from sys_dummy MINUS select 1906 from sys_dummy
 MINUS select 1547 from sys_dummy MINUS select 1842 from sys_dummy MINUS select 1612 from sys_dummy MINUS select 1907 from sys_dummy
 MINUS select 1548 from sys_dummy MINUS select 1843 from sys_dummy MINUS select 1613 from sys_dummy MINUS select 1908 from sys_dummy
 MINUS select 1549 from sys_dummy MINUS select 1844 from sys_dummy MINUS select 1614 from sys_dummy MINUS select 1909 from sys_dummy
 MINUS select 1550 from sys_dummy MINUS select 1845 from sys_dummy MINUS select 1615 from sys_dummy MINUS select 1910 from sys_dummy
 MINUS select 1551 from sys_dummy MINUS select 1846 from sys_dummy MINUS select 1616 from sys_dummy MINUS select 1911 from sys_dummy
 MINUS select 1552 from sys_dummy MINUS select 1847 from sys_dummy MINUS select 1617 from sys_dummy MINUS select 1912 from sys_dummy
 MINUS select 1553 from sys_dummy MINUS select 1848 from sys_dummy MINUS select 1618 from sys_dummy MINUS select 1913 from sys_dummy
 MINUS select 1554 from sys_dummy MINUS select 1849 from sys_dummy MINUS select 1619 from sys_dummy MINUS select 1914 from sys_dummy
 MINUS select 1555 from sys_dummy MINUS select 1850 from sys_dummy MINUS select 1620 from sys_dummy MINUS select 1915 from sys_dummy
 MINUS select 1556 from sys_dummy MINUS select 1851 from sys_dummy MINUS select 1621 from sys_dummy MINUS select 1916 from sys_dummy
 MINUS select 1557 from sys_dummy MINUS select 1852 from sys_dummy MINUS select 1622 from sys_dummy MINUS select 1917 from sys_dummy
 MINUS select 1558 from sys_dummy MINUS select 1853 from sys_dummy MINUS select 1623 from sys_dummy MINUS select 1918 from sys_dummy
 MINUS select 1559 from sys_dummy MINUS select 1854 from sys_dummy MINUS select 1624 from sys_dummy MINUS select 1919 from sys_dummy
 MINUS select 1560 from sys_dummy MINUS select 1855 from sys_dummy MINUS select 1625 from sys_dummy MINUS select 1920 from sys_dummy
 MINUS select 1561 from sys_dummy MINUS select 1856 from sys_dummy MINUS select 1626 from sys_dummy MINUS select 1921 from sys_dummy
 MINUS select 1562 from sys_dummy MINUS select 1857 from sys_dummy MINUS select 1627 from sys_dummy MINUS select 1922 from sys_dummy
 MINUS select 1563 from sys_dummy MINUS select 1858 from sys_dummy MINUS select 1628 from sys_dummy MINUS select 1923 from sys_dummy
 MINUS select 1564 from sys_dummy MINUS select 1859 from sys_dummy MINUS select 1629 from sys_dummy MINUS select 1924 from sys_dummy
 MINUS select 1565 from sys_dummy MINUS select 1860 from sys_dummy MINUS select 1630 from sys_dummy MINUS select 1925 from sys_dummy
 MINUS select 1566 from sys_dummy MINUS select 1861 from sys_dummy MINUS select 1631 from sys_dummy MINUS select 1926 from sys_dummy
 MINUS select 1567 from sys_dummy MINUS select 1862 from sys_dummy MINUS select 1632 from sys_dummy MINUS select 1927 from sys_dummy
 MINUS select 1568 from sys_dummy MINUS select 1863 from sys_dummy MINUS select 1633 from sys_dummy MINUS select 1928 from sys_dummy
 MINUS select 1569 from sys_dummy MINUS select 1864 from sys_dummy MINUS select 1634 from sys_dummy MINUS select 1929 from sys_dummy
 MINUS select 1570 from sys_dummy MINUS select 1865 from sys_dummy MINUS select 1635 from sys_dummy MINUS select 1930 from sys_dummy
 MINUS select 1571 from sys_dummy MINUS select 1866 from sys_dummy MINUS select 1669 from sys_dummy MINUS select 1964 from sys_dummy
 MINUS select 1572 from sys_dummy MINUS select 1867 from sys_dummy MINUS select 1670 from sys_dummy MINUS select 1965 from sys_dummy
 MINUS select 1573 from sys_dummy MINUS select 1868 from sys_dummy MINUS select 1671 from sys_dummy MINUS select 1966 from sys_dummy
 MINUS select 1574 from sys_dummy MINUS select 1869 from sys_dummy MINUS select 1672 from sys_dummy MINUS select 1967 from sys_dummy
 MINUS select 1575 from sys_dummy MINUS select 1870 from sys_dummy MINUS select 1588 from sys_dummy MINUS select 1883 from sys_dummy
 MINUS select 1576 from sys_dummy MINUS select 1871 from sys_dummy MINUS select 1589 from sys_dummy MINUS select 1884 from sys_dummy
 MINUS select 1577 from sys_dummy MINUS select 1872 from sys_dummy MINUS select 1590 from sys_dummy MINUS select 1885 from sys_dummy
 MINUS select 1578 from sys_dummy MINUS select 1873 from sys_dummy MINUS select 1591 from sys_dummy MINUS select 1886 from sys_dummy
 MINUS select 1579 from sys_dummy MINUS select 1874 from sys_dummy MINUS select 1592 from sys_dummy MINUS select 1887 from sys_dummy
 MINUS select 1580 from sys_dummy MINUS select 1875 from sys_dummy MINUS select 1593 from sys_dummy MINUS select 1888 from sys_dummy
 MINUS select 1581 from sys_dummy MINUS select 1876 from sys_dummy MINUS select 1594 from sys_dummy MINUS select 1889 from sys_dummy
 MINUS select 1582 from sys_dummy MINUS select 1877 from sys_dummy MINUS select 1595 from sys_dummy MINUS select 1890 from sys_dummy
 MINUS select 1583 from sys_dummy MINUS select 1878 from sys_dummy MINUS select 1596 from sys_dummy MINUS select 1891 from sys_dummy
 MINUS select 1584 from sys_dummy MINUS select 1879 from sys_dummy MINUS select 1597 from sys_dummy MINUS select 1892 from sys_dummy
 MINUS select 1585 from sys_dummy MINUS select 1880 from sys_dummy MINUS select 1598 from sys_dummy MINUS select 1893 from sys_dummy
 MINUS select 1586 from sys_dummy MINUS select 1881 from sys_dummy MINUS select 1599 from sys_dummy MINUS select 1894 from sys_dummy
 MINUS select 1587 from sys_dummy MINUS select 1882 from sys_dummy MINUS select 1600 from sys_dummy MINUS select 1895 from sys_dummy
) )C        WHERE            1 = 1        ORDER BY            id ) t    WHERE        ROWNUM <= 800 )WHERE    rn >= 1 order by 1,2,3,4;
drop table  t_stack_or_001; 
drop table t_stack_or_002; 
-- dv_sql_plan -> explain
DROP TABLE IF EXISTS "INF_OFFERS" CASCADE CONSTRAINTS;
CREATE TABLE "INF_OFFERS"
(
  "OFFER_SEQ" NUMBER(16) NOT NULL,
  "OWNER_TYPE" VARCHAR(1 BYTE) NOT NULL,
  "CUST_ID" NUMBER(24) NOT NULL,
  "SUB_ID" NUMBER(24),
  "ACCT_ID" NUMBER(24),
  "OFFER_ID" VARCHAR(20 BYTE) NOT NULL,
  "PRIMARY_FLAG" VARCHAR(1 BYTE) NOT NULL,
  "BUNDLE_FLAG" VARCHAR(1 BYTE) NOT NULL,
  "P_OFFER_SEQ" NUMBER(16),
  "PRI_OFFER_SEQ" NUMBER(16),
  "FOR_MEMBER_FLAG" VARCHAR(1 BYTE),
  "STATUS" VARCHAR(5 BYTE),
  "M_STATUS" VARCHAR(1 BYTE),
  "CREATE_DATE" DATE,
  "AMOUNT" NUMBER(3),
  "EFF_DATE" DATE,
  "EXP_DATE" DATE,
  "REASON" VARCHAR(24 BYTE),
  "REMARK" VARCHAR(256 BYTE),
  "BUSI_SEQ" VARCHAR(16 BYTE),
  "BUSI_TYPE" VARCHAR(5 BYTE),
  "PARTITION_ID" NUMBER(8) NOT NULL,
  "SUBSCRIBE_CHANNEL" VARCHAR(10 BYTE),
  "UNSUBSCRIBE_CHANNEL" VARCHAR(10 BYTE),
  "BE_ID" VARCHAR(32 BYTE),
  "EFF_MODE" VARCHAR(3 BYTE),
  "EXTERNAL_OFFER_SEQ" VARCHAR(32 BYTE) DEFAULT '',
  "TRIAL_S_DATE" DATE,
  "TRIAL_E_DATE" DATE,
  "EXP_MODE" VARCHAR(3 BYTE),
  "ACTIVE_MODE" VARCHAR(3 BYTE),
  "LATEST_ACTIVE_DATE" DATE,
  "ACTIVE_TIME" DATE,
  "OFFER_CATE" VARCHAR(10 BYTE),
  "STATE_REASON_DETAIL" VARCHAR(24 BYTE),
  "ACTION_TYPE" VARCHAR(6 BYTE),
  "PROMOTION_SEQ" NUMBER(16),
  "PROMOTION_ID" VARCHAR(10 BYTE),
  "GROUP_SUB_ID" NUMBER(24),
  "MOD_DATE" DATE,
  "BUNDLE_OFFER_ID" VARCHAR(32 BYTE),
  "RESERVE_SEQ" VARCHAR(64 BYTE),
  "ORIG_EXP_DATE" DATE,
  "COLUMN1" VARCHAR(256 BYTE),
  "COLUMN2" VARCHAR(256 BYTE),
  "COLUMN3" VARCHAR(256 BYTE),
  "COLUMN4" VARCHAR(256 BYTE),
  "COLUMN5" VARCHAR(256 BYTE),
  "PACKAGE_ID" VARCHAR(20 BYTE),
  "GROUP_ID" VARCHAR(20 BYTE)
)
PARTITION BY RANGE ("PARTITION_ID")
(
    PARTITION P_00 VALUES LESS THAN (1)  INITRANS 1 PCTFREE 10,
    PARTITION P_01 VALUES LESS THAN (2)  INITRANS 1 PCTFREE 10,
    PARTITION P_02 VALUES LESS THAN (MAXVALUE)  INITRANS 1 PCTFREE 10
)
INITRANS 1
MAXTRANS 255
PCTFREE 10;
ALTER TABLE "INF_OFFERS" ADD CONSTRAINT "PK_INF_OFFERS" PRIMARY KEY("OFFER_SEQ");

create or replace function FCALPID(CALNUMBER IN NUMBER) RETURN NUMBER IS
BEGIN
  RETURN 0;
END;
/
alter system flush sqlpool;
explain insert INTO INF_OFFERS NOLOGGING (OFFER_SEQ , OWNER_TYPE , CUST_ID , SUB_ID , ACCT_ID , OFFER_ID , PRIMARY_FLAG , BUNDLE_FLAG , P_OFFER_SEQ , PRI_OFFER_SEQ , FOR_MEMBER_FLAG , STATUS , M_STATUS , CREATE_DATE , AMOUNT , TRIAL_S_DATE , TRIAL_E_DATE , EFF_DATE , EXP_DATE , REASON , REMARK , BUSI_SEQ , BUSI_TYPE , PARTITION_ID , SUBSCRIBE_CHANNEL , UNSUBSCRIBE_CHANNEL , BE_ID , EFF_MODE , ACTIVE_MODE , LATEST_ACTIVE_DATE , ACTIVE_TIME , OFFER_CATE , ACTION_TYPE , MOD_DATE ) VALUES(:1 ,'2',:2 ,:3 ,:4 ,:5 ,:6 ,'0',NULL,NULL,NULL,'C01','',:7 ,1,:8 ,:9 ,:10 ,:11 ,NULL,NULL,:12 ,'CO015',FCALPID(:13 ),NULL,NULL,101,'0','A',:14 ,:15 ,'0','1',:16 );
select PLAN_TEXT from dv_sql_plan where sql_id = 2445080300;

drop table if exists tb_test;
create table tb_test
(
c_id int,
CAOC clob default '123456789',
CAOB blob default '123456789'
) 
partition by range(c_id) interval(50)
(partition part_1 values less than(10),
partition part_2 values less than(30));
explain insert into tb_test(c_id) values(:1);
drop table if exists tb_test;

drop table if exists expr_node_certain_t;
create table expr_node_certain_t(id int, c_int int not null, c_bool boolean);
create index idx_expr_node_certain_t on expr_node_certain_t(c_int);
explain select * from expr_node_certain_t where c_int = if(10 > 5, 10, 5);
explain select * from expr_node_certain_t where c_int = lnnvl(10 > 5);
explain select * from expr_node_certain_t where c_int = case when 10 > 5 then 5 else 10 end;
drop table expr_node_certain_t;

drop table if exists nl_convert_to_hash_t1;
drop table if exists nl_convert_to_hash_t2;
create table nl_convert_to_hash_t1(f1 int, f2 int, f3 int);
create table nl_convert_to_hash_t2(f1 int, f2 int, f3 int);

explain
select
  subq_1.c0 as c1
from
  ((nl_convert_to_hash_t1 as ref_0)
  right join nl_convert_to_hash_t1 as ref_1 on 1=1)
  left join (
    ((
        select
            ref_3.f1 as c0,
            ref_3.f2 as c1
        from
            nl_convert_to_hash_t1 as ref_3
        where ref_3.f3 < 10) as subq_1)
    cross join (nl_convert_to_hash_t2 as ref_4))
   on (ref_4.f1 = case when ref_0.f2 != ref_0.f3 then 1 else 2 end)
where ref_4.f2 <> subq_1.c1;

explain
select
  subq_1.c0 as c1
from
  ((nl_convert_to_hash_t1 as ref_0)
  right join nl_convert_to_hash_t1 as ref_1 on 1=1)
  left join (
    ((
        select
            ref_3.f1 as c0,
            ref_3.f2 as c1
        from
            nl_convert_to_hash_t1 as ref_3
        where ref_3.f3 < 10) as subq_1)
    cross join (nl_convert_to_hash_t2 as ref_4))
   on (ref_4.f1 = case when ref_0.f2 != ref_0.f3 then 1 else 2 end)
where ref_4.f2 <> subq_1.c1 and ref_4.rowid != subq_1.rowid;

explain
select
  subq_1.c0 as c1
from
  ((nl_convert_to_hash_t1 as ref_0)
  right join nl_convert_to_hash_t1 as ref_1 on 1=1)
  left join (
    ((
        select
            ref_3.f1 as c0,
            ref_3.f2 as c1
        from
            nl_convert_to_hash_t1 as ref_3
        where ref_3.f3 < 10) as subq_1)
    cross join (nl_convert_to_hash_t2 as ref_4))
   on (ref_4.f1 = case when ref_0.f2 != ref_0.f3 then 1 else 2 end)
where ref_4.f2 <> subq_1.c1 and ref_4.f3 = true;

drop table nl_convert_to_hash_t1;
drop table nl_convert_to_hash_t2;

drop table if exists delete_ancestor_t;
create table delete_ancestor_t(col_1 int, col_2 int, col_3 int, col_4 int);
explain 
select 
    1 as c0
from delete_ancestor_t as ref_0
    cross join (
        select 
            null as c0,
            col_1 as c1,
            col_2 as c2,
            col_3 as c3,
            col_4 as c4
        from delete_ancestor_t as ref_1
    ) as subq_0
where 
    subq_0.c2 > any(
        select subq_0.c2 as c0
        from delete_ancestor_t as ref_2
        where 
            exists(
                select
                    max(subq_0.c1) over(partition by subq_0.c3 order by subq_0.c0) as c0
                from delete_ancestor_t as ref_3
            )
    )
group by rollup(subq_0.c4);

drop table delete_ancestor_t;

drop table if exists t_winsort_elim;
create table t_winsort_elim(a int, b number, c varchar(10), d int);
insert into t_winsort_elim values(1, 1.1, 'aaa', 200);
insert into t_winsort_elim values(2, 2.2, 'bbb', 100);
insert into t_winsort_elim values(3, 1.1, null, 200);
commit;

drop view if exists v_eliminate;
CREATE VIEW v_eliminate(a,b,c,d,ss,cc) 
AS
SELECT 
t1.a,
t2.b,
t1.c,
t2.d,
sum(t1.a)over(partition by t1.b) as ss,
(select count(1) from sys_dummy) as cc
FROM t_winsort_elim t1 join t_winsort_elim t2 on t1.a = t2.a join t_winsort_elim t3 join t_winsort_elim t4
order by t1.a,t2.b;

explain select distinct a from v_eliminate where b < 2;
drop table t_winsort_elim;