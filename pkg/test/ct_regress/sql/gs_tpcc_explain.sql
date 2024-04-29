drop table if exists bmsql_config;
drop table if exists bmsql_new_order;
drop table if exists bmsql_order_line;
drop table if exists bmsql_oorder;
drop table if exists bmsql_history;
drop table if exists bmsql_customer;
drop table if exists bmsql_stock;
drop table if exists bmsql_item;
drop table if exists bmsql_district;
drop table if exists bmsql_warehouse;
drop sequence if exists bmsql_hist_id_seq;
create table bmsql_config (
  cfg_name    varchar(30),
  cfg_value   varchar(50)
);

create index cfg_name_index on bmsql_config(cfg_name);

create table bmsql_warehouse (
  w_id        integer   not null,
  w_ytd       decimal(12,2),
  w_tax       decimal(4,4),
  w_name      varchar(10),
  w_street_1  varchar(20),
  w_street_2  varchar(20),
  w_city      varchar(20),
  w_state     char(2),
  w_zip       char(9)
);
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
create table bmsql_customer (
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
create sequence bmsql_hist_id_seq;
create table bmsql_history (
  hist_id  integer,
  h_c_id   integer,
  h_c_d_id integer,
  h_c_w_id integer,
  h_d_id   integer,
  h_w_id   integer,
  h_date   timestamp,
  h_amount decimal(6,2),
  h_data   varchar(24)
);
create table bmsql_new_order (
  no_w_id  integer   not null,
  no_d_id  integer   not null,
  no_o_id  integer   not null
);
create table bmsql_oorder (
  o_w_id       integer      not null,
  o_d_id       integer      not null,
  o_id         integer      not null,
  o_c_id       integer,
  o_carrier_id integer,
  o_ol_cnt     integer,
  o_all_local  integer,
  o_entry_d    timestamp
);
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
create table bmsql_item (
  i_id     integer      not null,
  i_name   varchar(24),
  i_price  decimal(5,2),
  i_data   varchar(50),
  i_im_id  integer
);
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
alter table bmsql_warehouse add constraint bmsql_warehouse_pkey
  primary key (w_id);

alter table bmsql_district add constraint bmsql_district_pkey
  primary key (d_w_id, d_id);

alter table bmsql_customer add constraint bmsql_customer_pkey
  primary key (c_w_id, c_d_id, c_id);

create index bmsql_customer_idx1
  on  bmsql_customer (c_w_id, c_d_id, c_last, c_first);

alter table bmsql_oorder add constraint bmsql_oorder_pkey
  primary key (o_w_id, o_d_id, o_id);

create unique index bmsql_oorder_idx1
  on  bmsql_oorder (o_w_id, o_d_id, o_carrier_id, o_id);

alter table bmsql_new_order add constraint bmsql_new_order_pkey
  primary key (no_w_id, no_d_id, no_o_id);

alter table bmsql_order_line add constraint bmsql_order_line_pkey
  primary key (ol_w_id, ol_d_id, ol_o_id, ol_number);

alter table bmsql_stock add constraint bmsql_stock_pkey
  primary key (s_w_id, s_i_id);

alter table bmsql_item add constraint bmsql_item_pkey
  primary key (i_id);

 --以下为标准执行计划，切勿擅自改动！！！
 
explain SELECT cfg_value FROM bmsql_config  WHERE cfg_name = 'p1';
explain SELECT d_tax, d_next_o_id FROM bmsql_district WHERE d_w_id = 'p1' AND d_id = 2 FOR UPDATE;
explain UPDATE bmsql_district SET d_ytd = d_ytd + 'p1' WHERE d_w_id = 2 AND d_id = 3;
explain SELECT c_id FROM bmsql_customer WHERE c_w_id = 'p1' AND c_d_id = 2 AND c_last = 3 ORDER BY c_first;
explain SELECT count(*) AS low_stock FROM ( SELECT s_w_id, s_i_id, s_quantity FROM bmsql_stock WHERE s_w_id = 'p1' AND s_quantity < 2 AND s_i_id IN ( SELECT ol_i_id  FROM bmsql_district JOIN bmsql_order_line ON ol_w_id = d_w_id AND ol_d_id = d_id AND ol_o_id >= d_next_o_id - 20 AND ol_o_id < d_next_o_id WHERE d_w_id = 3 AND d_id = 4 ));
explain SELECT d_name, d_street_1, d_street_2, d_city,d_state, d_zip FROM bmsql_district WHERE d_w_id = 'p1' AND d_id = 2;
explain SELECT c_first, c_middle, c_last, c_balance FROM bmsql_customer WHERE c_w_id = 'p1' AND c_d_id = 2 AND c_id = 3;
explain UPDATE bmsql_warehouse SET w_ytd = w_ytd + 'p1' WHERE w_id = 2;
explain SELECT w_name, w_street_1, w_street_2, w_city,w_state, w_zip FROM bmsql_warehouse  WHERE w_id = 'p1';
explain SELECT no_o_id FROM bmsql_new_order WHERE no_w_id = 'p1' AND no_d_id = 2 ORDER BY no_o_id ASC;
explain SELECT c_first, c_middle, c_last, c_street_1, c_street_2,c_city, c_state, c_zip, c_phone, c_since, c_credit,c_credit_lim, c_discount, c_balance FROM bmsql_customer WHERE c_w_id = 'p1' AND c_d_id = 2 AND c_id = 3 FOR UPDATE;
explain SELECT c_discount, c_last, c_credit, w_tax FROM bmsql_customer JOIN bmsql_warehouse ON (w_id = c_w_id) WHERE c_w_id = 'p1' AND c_d_id = 2 AND c_id = 3;
explain DELETE FROM bmsql_new_order WHERE no_w_id = 'p1' AND no_d_id = 2 AND no_o_id = 3;
explain UPDATE bmsql_customer SET c_balance = c_balance - 'p1',c_ytd_payment = c_ytd_payment + 2,c_payment_cnt = c_payment_cnt + 1 WHERE c_w_id = 3 AND c_d_id = 4 AND c_id = 5;
explain SELECT c_data FROM bmsql_customer WHERE c_w_id = 'p1' AND c_d_id = 2 AND c_id = 3;
explain UPDATE bmsql_district SET d_next_o_id = d_next_o_id + 1 WHERE d_w_id = 'p1' AND d_id = 2;
explain UPDATE bmsql_customer SET c_balance = c_balance - 'p1', c_ytd_payment = c_ytd_payment + 2, c_payment_cnt = c_payment_cnt + 1, c_data = 3 WHERE c_w_id = 4 AND c_d_id = 5 AND c_id = 6;
explain SELECT o_id, o_entry_d, o_carrier_id FROM bmsql_oorder WHERE o_w_id = 'p1' AND o_d_id = 2 AND o_c_id = 3  AND o_id = (SELECT max(o_id) FROM bmsql_oorder WHERE o_w_id = 4 AND o_d_id = 5 AND o_c_id = 6);
explain UPDATE bmsql_oorder SET o_carrier_id = 'p1' WHERE o_w_id = 2 AND o_d_id = 3 AND o_id = 4;
explain INSERT INTO bmsql_oorder (o_id, o_d_id, o_w_id, o_c_id, o_entry_d,o_ol_cnt, o_all_local) VALUES (1, 2, 3, 4, '2011-11-11 11:11:11.1', 6, 7);
explain SELECT ol_i_id, ol_supply_w_id, ol_quantity,ol_amount, ol_delivery_d FROM bmsql_order_line WHERE ol_w_id = 'p1' AND ol_d_id = 2 AND ol_o_id = 3 ORDER BY ol_w_id, ol_d_id, ol_o_id, ol_number;
explain SELECT o_c_id FROM bmsql_oorder WHERE o_w_id = 'p1' AND o_d_id = 2 AND o_id = 3;
explain UPDATE bmsql_order_line SET ol_delivery_d = 'p1' WHERE ol_w_id = 2 AND ol_d_id = 3 AND ol_o_id = 4;
explain SELECT sum(ol_amount) AS sum_ol_amount FROM bmsql_order_line WHERE ol_w_id = 'p1' AND ol_d_id = 2 AND ol_o_id = 3;
explain INSERT INTO bmsql_new_order (no_o_id, no_d_id, no_w_id) VALUES ('p1', 2, 3);
explain INSERT INTO bmsql_history (h_c_id, h_c_d_id, h_c_w_id, h_d_id, h_w_id,h_date, h_amount, h_data) VALUES ('p1', 2, 3, 4, 5, '2011-11-11 11:11:11.1', 7, 'p8');
explain UPDATE bmsql_customer SET c_balance = c_balance + 'p1',c_delivery_cnt = c_delivery_cnt + 1 WHERE c_w_id = 2 AND c_d_id = 3 AND c_id = 4;
explain SELECT i_price, i_name, i_data FROM bmsql_item WHERE i_id = 'p1';
explain SELECT s_quantity, s_data,s_dist_01, s_dist_02, s_dist_03, s_dist_04,s_dist_05, s_dist_06, s_dist_07, s_dist_08,s_dist_09, s_dist_10 FROM bmsql_stock WHERE s_w_id = 'p1' AND s_i_id = 2 FOR UPDATE;
explain UPDATE bmsql_stock SET s_quantity = 'p1', s_ytd = s_ytd + 2, s_order_cnt = s_order_cnt + 1, s_remote_cnt = s_remote_cnt + 3 WHERE s_w_id = 4 AND s_i_id = 5;
explain INSERT INTO bmsql_order_line (ol_o_id, ol_d_id, ol_w_id, ol_number,ol_i_id, ol_supply_w_id, ol_quantity,ol_amount, ol_dist_info) VALUES ('p1', 2, 3, 4, 5, 6, 7, 8, 'p'); 
  
  
alter table bmsql_warehouse drop constraint bmsql_warehouse_pkey;

alter table bmsql_district drop constraint bmsql_district_pkey;

alter table bmsql_customer drop constraint bmsql_customer_pkey;
drop index bmsql_customer_idx1 on bmsql_customer;

alter table bmsql_oorder drop constraint bmsql_oorder_pkey;
drop index bmsql_oorder_idx1 on bmsql_oorder;

alter table bmsql_new_order drop constraint bmsql_new_order_pkey;

alter table bmsql_order_line drop constraint bmsql_order_line_pkey;

alter table bmsql_stock drop constraint bmsql_stock_pkey;

alter table bmsql_item drop constraint bmsql_item_pkey;

drop table bmsql_config;
drop table bmsql_new_order;
drop table bmsql_order_line;
drop table bmsql_oorder;
drop table bmsql_history;
drop table bmsql_customer;
drop table bmsql_stock;
drop table bmsql_item;
drop table bmsql_district;
drop table bmsql_warehouse;
drop sequence bmsql_hist_id_seq;


-- 以下是分区表TPCC执行计划,请勿乱动
drop table if exists bmsql_order_line;
drop table if exists bmsql_oorder;
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
) CRMODE ROW PCTFREE 20
partition by hash(ol_w_id) partitions 32;
alter table bmsql_order_line add constraint bmsql_order_line_pkey
  primary key (ol_w_id, ol_d_id, ol_o_id, ol_number) using index(create unique index order_line_index on bmsql_order_line(ol_w_id, ol_d_id, ol_o_id, ol_number) CRMODE PAGE LOCAL PCTFREE 20);
			  
create table bmsql_oorder (
  o_w_id       integer      not null,
  o_d_id       integer      not null,
  o_id         integer      not null,
  o_c_id       integer,
  o_carrier_id integer,
  o_ol_cnt     integer,
  o_all_local  integer,
  o_entry_d    timestamp
) CRMODE ROW PCTFREE 20;
create unique index bmsql_oorder_idx1
  on  bmsql_oorder (o_w_id, o_d_id, o_carrier_id, o_id) CRMODE PAGE PCTFREE 20;
  
explain SELECT ol_w_id, ol_d_id, ol_o_id, COUNT(*) count_ol
                 FROM bmsql_order_line 
                  GROUP BY ol_w_id, ol_d_id, ol_o_id;
  
explain SELECT ol_w_id, ol_d_id, ol_o_id, COUNT(*) count_ol
                 FROM bmsql_order_line 
                  GROUP BY ol_w_id, ol_d_id, ol_o_id
				  order by ol_w_id, ol_d_id, ol_o_id;

-- Condition 6: For any row in the ORDER table, O_OL_CNT must equal the number
-- of rows in the ORDER-LINE table for the corresponding order
explain SELECT * FROM (SELECT o.o_w_id, o.o_d_id, o.o_id, o.o_ol_cnt, ol.count_ol
           FROM bmsql_oorder o,
                (SELECT ol_w_id, ol_d_id, ol_o_id, COUNT(*) count_ol
                 FROM bmsql_order_line
                 GROUP BY ol_w_id, ol_d_id, ol_o_id) ol
           WHERE o.o_w_id = ol.ol_w_id AND
                 o.o_d_id = ol.ol_d_id AND
                 o.o_id = ol.ol_o_id) as x
WHERE o_ol_cnt != count_ol;
drop table if exists bmsql_order_line;
drop table if exists bmsql_oorder;

--bugfix for tpch5
drop table if exists nation;
drop table if exists region;
drop table if exists supplier;
drop table if exists customer;
drop table if exists orders;
drop table if exists lineitem;

CREATE TABLE NATION  ( N_NATIONKEY  INTEGER NOT NULL,
                            N_NAME       CHAR(25) NOT NULL,
                            N_REGIONKEY  INTEGER NOT NULL,
                            N_COMMENT    VARCHAR(152));

CREATE TABLE REGION  ( R_REGIONKEY  INTEGER NOT NULL,
                            R_NAME       CHAR(25) NOT NULL,
                            R_COMMENT    VARCHAR(152));

CREATE TABLE SUPPLIER ( S_SUPPKEY     INTEGER NOT NULL,
                             S_NAME        CHAR(25) NOT NULL,
                             S_ADDRESS     VARCHAR(40) NOT NULL,
                             S_NATIONKEY   INTEGER NOT NULL,
                             S_PHONE       CHAR(15) NOT NULL,
                             S_ACCTBAL     DECIMAL(15,2) NOT NULL,
                             S_COMMENT     VARCHAR(101) NOT NULL);

CREATE TABLE CUSTOMER ( C_CUSTKEY     INTEGER NOT NULL,
                             C_NAME        VARCHAR(25) NOT NULL,
                             C_ADDRESS     VARCHAR(40) NOT NULL,
                             C_NATIONKEY   INTEGER NOT NULL,
                             C_PHONE       CHAR(15) NOT NULL,
                             C_ACCTBAL     DECIMAL(15,2)   NOT NULL,
                             C_MKTSEGMENT  CHAR(10) NOT NULL,
                             C_COMMENT     VARCHAR(117) NOT NULL);

CREATE TABLE ORDERS  ( O_ORDERKEY       INTEGER NOT NULL,
                           O_CUSTKEY        INTEGER NOT NULL,
                           O_ORDERSTATUS    CHAR(1) NOT NULL,
                           O_TOTALPRICE     DECIMAL(15,2) NOT NULL,
                           O_ORDERDATE      DATE NOT NULL,
                           O_ORDERPRIORITY  CHAR(15) NOT NULL,  
                           O_CLERK          CHAR(15) NOT NULL, 
                           O_SHIPPRIORITY   INTEGER NOT NULL,
                           O_COMMENT        VARCHAR(79) NOT NULL);

CREATE TABLE LINEITEM ( L_ORDERKEY    INTEGER NOT NULL,
                             L_PARTKEY     INTEGER NOT NULL,
                             L_SUPPKEY     INTEGER NOT NULL,
                             L_LINENUMBER  INTEGER NOT NULL,
                             L_QUANTITY    DECIMAL(15,2) NOT NULL,
                             L_EXTENDEDPRICE  DECIMAL(15,2) NOT NULL,
                             L_DISCOUNT    DECIMAL(15,2) NOT NULL,
                             L_TAX         DECIMAL(15,2) NOT NULL,
                             L_RETURNFLAG  CHAR(1) NOT NULL,
                             L_LINESTATUS  CHAR(1) NOT NULL,
                             L_SHIPDATE    DATE NOT NULL,
                             L_COMMITDATE  DATE NOT NULL,
                             L_RECEIPTDATE DATE NOT NULL,
                             L_SHIPINSTRUCT CHAR(25) NOT NULL,
                             L_SHIPMODE     CHAR(10) NOT NULL,
                             L_COMMENT      VARCHAR(44) NOT NULL);


							 
ALTER TABLE REGION
ADD CONSTRAINT PK_REGIONKEY PRIMARY KEY (R_REGIONKEY);
ALTER TABLE NATION
ADD CONSTRAINT PK_NATIONKEY PRIMARY KEY (N_NATIONKEY);
ALTER TABLE SUPPLIER
ADD CONSTRAINT PK_SUPPKEY PRIMARY KEY (S_SUPPKEY);
ALTER TABLE CUSTOMER
ADD CONSTRAINT PK_CUSTKEY PRIMARY KEY (C_CUSTKEY);
ALTER TABLE LINEITEM
ADD CONSTRAINT PK_LINEITEMKEY PRIMARY KEY (L_ORDERKEY,L_LINENUMBER);
ALTER TABLE ORDERS
ADD CONSTRAINT PK_ORDERKEY PRIMARY KEY (O_ORDERKEY);

explain plan for
select n_name, sum(l_extendedprice * (1 - l_discount)) as revenue
  from customer, orders, lineitem, supplier, nation, region
 where c_custkey = o_custkey
   and l_orderkey = o_orderkey
   and l_suppkey = s_suppkey
   and c_nationkey = s_nationkey
   and s_nationkey = n_nationkey
   and n_regionkey = r_regionkey
   and r_name = 'MIDDLE EAST'
   and o_orderdate >= date '1996-01-01'
   and o_orderdate < date '1996-01-01' + interval '1' year
 group by n_name
 order by revenue desc;
 
drop table if exists nation;
drop table if exists region;
drop table if exists supplier;
drop table if exists customer;
drop table if exists orders;
drop table if exists lineitem;
