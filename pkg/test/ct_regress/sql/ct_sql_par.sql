create user sql_par identified by sql_par_1234;
grant dba to sql_par;
conn sql_par/sql_par_1234@127.0.0.1:1611

drop table if exists par_test_t1;
create table par_test_t1(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp);
insert into par_test_t1 values(1, 15, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into par_test_t1 values(2, 16, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into par_test_t1 values(7, 26, 39, '26', '39', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into par_test_t1 values(8, 36, 49, '36', '49', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into par_test_t1 values(12, 46, 59, '46', '59', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into par_test_t1 values(13, 56, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));

insert into par_test_t1 select * from par_test_t1;
insert into par_test_t1 select * from par_test_t1;
insert into par_test_t1 select * from par_test_t1;
insert into par_test_t1 select * from par_test_t1;
insert into par_test_t1 select * from par_test_t1;
insert into par_test_t1 select * from par_test_t1;
insert into par_test_t1 select * from par_test_t1;
commit;
insert into par_test_t1 select * from par_test_t1;
insert into par_test_t1 select * from par_test_t1;
commit;
insert into par_test_t1 select * from par_test_t1;
insert into par_test_t1 select * from par_test_t1;
insert into par_test_t1 select * from par_test_t1;
insert into par_test_t1 select * from par_test_t1;
commit;
insert into par_test_t1 select * from par_test_t1;
insert into par_test_t1 select * from par_test_t1;
commit;

select /*+ parallel(8) */ count(*) from par_test_t1;
select /*+ parallel(8) */ avg(f1) from par_test_t1;
select /*+ parallel(8) */ sum(f1) from par_test_t1;
select /*+ parallel(8) */ max(f1) from par_test_t1;
select /*+ parallel(8) */ min(f1) from par_test_t1;

DROP TABLE IF EXISTS "bmsql_history" CASCADE CONSTRAINTS;
create table bmsql_history (
  hist_id  integer,
  h_c_id   integer,
  h_c_d_id integer,
  h_c_w_id integer,
  h_d_id   integer,
  h_w_id   integer not null,
  h_date   timestamp,
  h_amount decimal(6,2),
  h_data   varchar(24)
);

create index bmsql_history_idx_001   on  bmsql_history (h_w_id);
create index bmsql_history_idx_002   on  bmsql_history (h_c_id);
create index bmsql_history_idx_003   on  bmsql_history (h_d_id);
create index bmsql_history_idx_004   on  bmsql_history (h_w_id,h_c_id,h_d_id);
create index bmsql_history_idx_005   on  bmsql_history (h_data);
create index bmsql_history_idx_006   on  bmsql_history (h_w_id,h_data);
create index bmsql_history_idx_007   on  bmsql_history (h_w_id,h_c_id,h_data);

insert into bmsql_history values(2156056,2056,9,72,9,72,to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'),10,'nanjing');
select /*+parallel(6)*/  HIST_ID as HIST_ID01,H_C_ID as H_C_ID01 from BMSQL_HISTORY where H_C_ID not in  (4,3) and H_DATE = '2018-01-24 16:00:00.000' ;

DROP TABLE IF EXISTS "T_P_SCCPCHTFC_C2" CASCADE CONSTRAINTS;
CREATE TABLE "T_P_SCCPCHTFC_C2"
(
  "PLANID" BINARY_INTEGER NOT NULL,
  "CMENEID" BINARY_INTEGER NOT NULL,
  "CELLID" NUMBER(17) NOT NULL,
  "PHYCHID" BINARY_INTEGER NOT NULL,
  "CTFC" NUMBER(17) NOT NULL
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;

drop table if exists test_row;
create table test_row(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp);
insert into test_row values(1, 15, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_row values(2, 16, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_row values(7, 26, 39, '26', '39', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_row values(8, 36, 49, '36', '49', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_row values(12, 46, 59, '46', '59', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_row values(13, 56, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));

select * from test_row;
select * from test_row where f1 > 12;
select f1, f2, f3, f4, f5, f6, f7 from test_row;
select f1, f2, f3, f4, f5, f6, f7 from test_row where f1 > 12;
select f2, f1, f3, f4, f5, f6, f7 from test_row;

CREATE TABLE "FVT_PARTITION_05"
(
  "C_ID" BINARY_INTEGER NOT NULL,
  "C_CLOB" CLOB,
  "C_TIME" TIMESTAMP(6),
  "C_NUM" NUMBER(10, 5),
  "C_NAME" VARCHAR(10 CHAR)
)
PARTITION BY RANGE ("C_ID")
INTERVAL(500)
(
    PARTITION P1 VALUES LESS THAN (100) TABLESPACE "USERS" INITRANS 2 PCTFREE 8,
    PARTITION P2 VALUES LESS THAN (200) TABLESPACE "USERS" INITRANS 2 PCTFREE 8,
    PARTITION P3 VALUES LESS THAN (300) TABLESPACE "USERS" INITRANS 2 PCTFREE 8
)
TABLESPACE "USERS"
INITRANS 2
MAXTRANS 255
PCTFREE 8;
CREATE INDEX "FVT_PARTITION_INDEX_005" ON "FVT_PARTITION_05"("C_TIME", "C_NAME")
LOCAL
TABLESPACE "USERS"
INITRANS 2
PCTFREE 8;
CREATE INDEX "FVT_PARTITION_INDEX_5" ON "FVT_PARTITION_05"("C_TIME", "C_NAME", "C_NUM")
TABLESPACE "USERS"
INITRANS 2
PCTFREE 8;
ALTER TABLE "FVT_PARTITION_05" ADD CONSTRAINT "_PK_SYS_8039766F42D624EE06245418649FB9FB" PRIMARY KEY("C_ID");

create table t_union_all_parallel_001(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10) not null,c_vchar2 varchar2(100),c_clob clob,
c_long varchar(200),c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp);
insert into t_union_all_parallel_001 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
 
create table t_union_all_parallel_101(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10) not null,c_vchar2 varchar2(100),c_clob clob,
c_long varchar(200),c_blob blob,c_raw varchar(100),c_date date,c_timestamp timestamp)
PARTITION BY LIST(id)  
(
PARTITION p1 VALUES (1,2,3),
PARTITION p2 VALUES (4,5,6,7),
PARTITION p3 VALUES (8,9,10,11)
);
insert into t_union_all_parallel_101 select * from t_union_all_parallel_001; 
 
create table t_union_all_parallel_102(
id int not null,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10) not null,c_vchar2 varchar2(100),c_clob clob,
c_long varchar(200),c_blob blob,c_raw varchar(100),c_date date,c_timestamp timestamp,CONSTRAINT t_union_all_parallel_102_con primary key(id,c_vchar))
PARTITION BY RANGE(id)
(
PARTITION p1 VALUES LESS THAN(6),
PARTITION p2 VALUES LESS THAN(10),
PARTITION p3 VALUES LESS THAN(maxvalue)
);
insert into t_union_all_parallel_102 select * from t_union_all_parallel_001;  

create index idx_union_all_parallel_101_1 on t_union_all_parallel_101(c_int);
create index idx_union_all_parallel_101_2 on t_union_all_parallel_101(c_int,c_vchar);
create index idx_union_all_parallel_101_3 on t_union_all_parallel_101(c_int,c_vchar,c_date);

create index idx_union_all_parallel_102_1 on t_union_all_parallel_102(c_int);
create index idx_union_all_parallel_102_2 on t_union_all_parallel_102(c_int,c_vchar);
create index idx_union_all_parallel_102_3 on t_union_all_parallel_102(c_int,c_vchar,c_date);


conn / as sysdba
drop user sql_par cascade; 
 
