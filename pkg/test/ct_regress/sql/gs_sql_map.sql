spool ./results/gs_sql_map.out
select SRC_TEXT,DST_TEXT from SYS_SQL_MAPS;
ALTER SQL_MAP (select count(*) from dual) REWRITE TO (select count(1) as cnt from dual);
select SRC_TEXT,DST_TEXT from SYS_SQL_MAPS;
select count(*) from dual;
alter system set enable_sql_map = true;
select count(*) from dual;
ALTER SQL_MAP (select count(*) from dual
) REWRITE TO (select count(1) as cnt2 from dual);
select count(*) from dual
;
select count(*) from dual  ;
DROP SQL_MAP (select count(*) from dual);
DROP SQL_MAP (select count(*) from dual);
DROP SQL_MAP IF EXISTS (select count(*) from dual);
select SRC_TEXT,DST_TEXT from SYS_SQL_MAPS;
select ? from dual where ? = 1;
in
string
abc
in
int
1
ALTER SQL_MAP (select ? from dual where ? = 1) REWRITE TO (select ? from dual where 1 = 1);
select ? from dual where ? = 1;
in
string
abc
DROP SQL_MAP (select ? from dual where ? = 1);
alter system set enable_sql_map = false;

alter system set _SQL_MAP_BUCKETS = 0;
alter system set _SQL_MAP_BUCKETS = 4294967295;
ALTER SQL_MAP (select * from test) REWRITE TO (create user test1 identified by Cantian_234);

create user sql_map_user1 identified by Mypwd123;
create user sql_map_user2 identified by Mypwd123;
grant connect to sql_map_user1,sql_map_user2;
alter system set enable_sql_map = true;
ALTER SQL_MAP (select 1 from dual) REWRITE TO (select 'sys' from dual);
conn sql_map_user1/Mypwd123@127.0.0.1:1611
ALTER SQL_MAP (select 1 from dual) REWRITE TO (select 'sql_map_user1' from dual);
conn sql_map_user2/Mypwd123@127.0.0.1:1611
ALTER SQL_MAP (select 1 from dual) REWRITE TO (select 'sql_map_user2' from dual);
select 1 from dual;
conn sql_map_user1/Mypwd123@127.0.0.1:1611
select 1 from dual;
DROP SQL_MAP (select 1 from dual);
select 1 from dual;
conn sql_map_user2/Mypwd123@127.0.0.1:1611
select 1 from dual;
select count(*) from dual;
conn sys/Huawei@123@127.0.0.1:1611
DROP USER sql_map_user1;
DROP USER sql_map_user2;
DROP USER sql_map_user2 cascade;
select 1 from dual;
DROP SQL_MAP (select 1 from dual);
select SRC_TEXT,DST_TEXT from SYS_SQL_MAPS;
--test remap by sql_id
select count(*) from dual;
alter sql_map 2455653625 rewrite to (select count(1) as cnt from dual);
select count(*) from dual;
alter system set enable_sql_map = false;
--DTS2019112514113
drop table if exists oracle_test_tbl_001;
create table oracle_test_tbl_001(c_id int,
c_d_id bigint NOT NULL,
c_w_id tinyint unsigned NOT NULL,
c_first varchar(16) NOT NULL,
c_middle char(2),
c_last varchar(16) NOT NULL,
c_street_1 varchar(20) NOT NULL,
c_street_2 varchar(20),
c_city varchar(20) NOT NULL,
c_state char(2) NOT NULL,
c_zip char(9) NOT NULL,
c_phone char(16) NOT NULL,
c_since timestamp,
c_credit char(2) NOT NULL,
c_credit_lim numeric(12,2),
c_discount numeric(4,4),
c_balance numeric(12,2),
c_end date NOT NULL,
c_data1 varchar(8000),
c_data2 varchar(8000),
c_data3 varchar(8000),
c_data4 varchar(8000),
c_data5 varchar(8000),
c_data6 varchar(8000),
c_data7 varchar(8000),
c_data8 varchar(8000),
c_clob clob,
c_blob blob,
column_int int default 1,
column_bigint bigint default 1,
column_tinyint tinyint unsigned default 1,
column_float float default 0.001,
column_double double default 1.001,
column_decimal decimal default 1.001,
column_number number default 1.001,
column_numeric numeric default 1.001,
column_char char default 'A',
column_varchar varchar(100) default lpad('aa',80,'bb'),
column_varchar2 varchar2(100) default lpad('aa',80,'bb'),
column_binary binary(100) default lpad('111',80,'222'),
column_varbinary varbinary(100) default lpad('111',80,'222'),
column_date date default sysdate,
column_timestamp timestamp default systimestamp,
add_int_0 int default  12345,
add_varchar2_0 varchar2(100) default 'abcde',
add_varchar_0 varchar(8000) default 'abcde',
add_clob_0 clob default 'abcde',
add_blob_0 blob default 'abcde',
add_int_1 int default  12345,
add_varchar2_1 varchar2(100) default 'abcde',
add_varchar_1 varchar(8000) default 'abcde',
add_clob_1 clob default 'abcde',
add_blob_1 blob default 'abcde',
add_int_2 int default  12345,
add_varchar2_2 varchar2(100) default 'abcde',
add_varchar_2 varchar(8000) default 'abcde',
add_clob_2 clob default 'abcde',
add_blob_2 blob default 'abcde',
add_int_3 int default  12345,
add_varchar2_3 varchar2(100) default 'abcde',
add_varchar_3 varchar(8000) default 'abcde',
add_clob_3 clob default 'abcde',
add_blob_3 blob default 'abcde',
add_int_4 int default  12345,
add_varchar2_4 varchar2(100) default 'abcde',
add_varchar_4 varchar(8000) default 'abcde',
add_clob_4 clob default 'abcde',
add_blob_4 blob default 'abcde',
add_int_5 int default  12345,
add_varchar2_5 varchar2(100) default 'abcde',
add_varchar_5 varchar(8000) default 'abcde',
add_clob_5 clob default 'abcde',
add_blob_5 blob default 'abcde',
add_int_6 int default  12345,
add_varchar2_6 varchar2(100) default 'abcde',
add_varchar_6 varchar(8000) default 'abcde',
add_clob_6 clob default 'abcde',
add_blob_6 blob default 'abcde',
add_int_7 int default  12345,
add_varchar2_7 varchar2(100) default 'abcde',
add_varchar_7 varchar(8000) default 'abcde',
add_clob_7 clob default 'abcde',
add_blob_7 blob default 'abcde',
add_int_8 int default  12345,
add_varchar2_8 varchar2(100) default 'abcde',
add_varchar_8 varchar(8000) default 'abcde',
add_clob_8 clob default 'abcde',
add_blob_8 blob default 'abcde',
add_int_9 int default  12345,
add_varchar2_9 varchar2(100) default 'abcde',
add_varchar_9 varchar(8000) default 'abcde',
add_clob_9 clob default 'abcde',
add_blob_9 blob default 'abcde',
add_int_10 int default  12345,
add_varchar2_10 varchar2(100) default 'abcde',
add_varchar_10 varchar(8000) default 'abcde',
add_clob_10 clob default 'abcde',
add_blob_10 blob default 'abcde',
add_int_11 int default  12345,
add_varchar2_11 varchar2(100) default 'abcde',
add_varchar_11 varchar(8000) default 'abcde',
add_clob_11 clob default 'abcde',
add_blob_11 blob default 'abcde',
add_int_12 int default  12345,
add_varchar2_12 varchar2(100) default 'abcde',
add_varchar_12 varchar(8000) default 'abcde',
add_clob_12 clob default 'abcde',
add_blob_12 blob default 'abcde',
add_int_13 int default  12345,
add_varchar2_13 varchar2(100) default 'abcde',
add_varchar_13 varchar(8000) default 'abcde',
add_clob_13 clob default 'abcde',
add_blob_13 blob default 'abcde',
add_int_14 int default  12345,
add_varchar2_14 varchar2(100) default 'abcde',
add_varchar_14 varchar(8000) default 'abcde',
add_clob_14 clob default 'abcde',
add_blob_14 blob default 'abcde',
add_int_15 int default  12345,
add_varchar2_15 varchar2(100) default 'abcde',
add_varchar_15 varchar(8000) default 'abcde',
add_clob_15 clob default 'abcde',
add_blob_15 blob default 'abcde',
add_int_16 int default  12345,
add_varchar2_16 varchar2(100) default 'abcde',
add_varchar_16 varchar(8000) default 'abcde',
add_clob_16 clob default 'abcde',
add_blob_16 blob default 'abcde',
add_int_17 int default  12345,
add_varchar2_17 varchar2(100) default 'abcde',
add_varchar_17 varchar(8000) default 'abcde',
add_clob_17 clob default 'abcde',
add_blob_17 blob default 'abcde',
add_int_18 int default  12345,
add_varchar2_18 varchar2(100) default 'abcde',
add_varchar_18 varchar(8000) default 'abcde',
add_clob_18 clob default 'abcde',
add_blob_18 blob default 'abcde',
add_int_19 int default  12345,
add_varchar2_19 varchar2(100) default 'abcde',
add_varchar_19 varchar(8000) default 'abcde',
add_clob_19 clob default 'abcde',
add_blob_19 blob default 'abcde',
add_int_20 int default  12345,
add_varchar2_20 varchar2(100) default 'abcde',
add_varchar_20 varchar(8000) default 'abcde',
add_clob_20 clob default 'abcde',
add_blob_20 blob default 'abcde',
add_int_21 int default  12345,
add_varchar2_21 varchar2(100) default 'abcde',
add_varchar_21 varchar(8000) default 'abcde',
add_clob_21 clob default 'abcde',
add_blob_21 blob default 'abcde',
add_int_22 int default  12345,
add_varchar2_22 varchar2(100) default 'abcde',
add_varchar_22 varchar(8000) default 'abcde',
add_clob_22 clob default 'abcde',
add_blob_22 blob default 'abcde',
add_int_23 int default  12345,
add_varchar2_23 varchar2(100) default 'abcde',
add_varchar_23 varchar(8000) default 'abcde',
add_clob_23 clob default 'abcde',
add_blob_23 blob default 'abcde',
add_int_24 int default  12345,
add_varchar2_24 varchar2(100) default 'abcde',
add_varchar_24 varchar(8000) default 'abcde',
add_clob_24 clob default 'abcde',
add_blob_24 blob default 'abcde',
add_int_25 int default  12345,
add_varchar2_25 varchar2(100) default 'abcde',
add_varchar_25 varchar(8000) default 'abcde',
add_clob_25 clob default 'abcde',
add_blob_25 blob default 'abcde',
add_int_26 int default  12345,
add_varchar2_26 varchar2(100) default 'abcde',
add_varchar_26 varchar(8000) default 'abcde',
add_clob_26 clob default 'abcde',
add_blob_26 blob default 'abcde',
add_int_27 int default  12345,
add_varchar2_27 varchar2(100) default 'abcde',
add_varchar_27 varchar(8000) default 'abcde',
add_clob_27 clob default 'abcde',
add_blob_27 blob default 'abcde',
add_int_28 int default  12345,
add_varchar2_28 varchar2(100) default 'abcde',
add_varchar_28 varchar(8000) default 'abcde',
add_clob_28 clob default 'abcde',
add_blob_28 blob default 'abcde',
add_int_29 int default  12345,
add_varchar2_29 varchar2(100) default 'abcde',
add_varchar_29 varchar(8000) default 'abcde',
add_clob_29 clob default 'abcde',
add_blob_29 blob default 'abcde',
add_int_30 int default  12345,
add_varchar2_30 varchar2(100) default 'abcde',
add_varchar_30 varchar(8000) default 'abcde',
add_clob_30 clob default 'abcde',
add_blob_30 blob default 'abcde',
add_int_31 int default  12345,
add_varchar2_31 varchar2(100) default 'abcde',
add_varchar_31 varchar(8000) default 'abcde',
add_clob_31 clob default 'abcde',
add_blob_31 blob default 'abcde',
add_int_32 int default  12345,
add_varchar2_32 varchar2(100) default 'abcde',
add_varchar_32 varchar(8000) default 'abcde',
add_clob_32 clob default 'abcde',
add_blob_32 blob default 'abcde',
add_int_33 int default  12345,
add_varchar2_33 varchar2(100) default 'abcde',
add_varchar_33 varchar(8000) default 'abcde',
add_clob_33 clob default 'abcde',
add_blob_33 blob default 'abcde',
add_int_34 int default  12345,
add_varchar2_34 varchar2(100) default 'abcde',
add_varchar_34 varchar(8000) default 'abcde',
add_clob_34 clob default 'abcde',
add_blob_34 blob default 'abcde',
add_int_35 int default  12345,
add_varchar2_35 varchar2(100) default 'abcde',
add_varchar_35 varchar(8000) default 'abcde',
add_clob_35 clob default 'abcde',
add_blob_35 blob default 'abcde',
add_int_36 int default  12345,
add_varchar2_36 varchar2(100) default 'abcde',
add_varchar_36 varchar(8000) default 'abcde',
add_clob_36 clob default 'abcde',
add_blob_36 blob default 'abcde',
add_int_37 int default  12345,
add_varchar2_37 varchar2(100) default 'abcde',
add_varchar_37 varchar(8000) default 'abcde',
add_clob_37 clob default 'abcde',
add_blob_37 blob default 'abcde',
add_int_38 int default  12345,
add_varchar2_38 varchar2(100) default 'abcde',
add_varchar_38 varchar(8000) default 'abcde',
add_clob_38 clob default 'abcde',
add_blob_38 blob default 'abcde',
add_int_39 int default  12345,
add_varchar2_39 varchar2(100) default 'abcde',
add_varchar_39 varchar(8000) default 'abcde',
add_clob_39 clob default 'abcde',
add_blob_39 blob default 'abcde',
add_int_40 int default  12345,
add_varchar2_40 varchar2(100) default 'abcde',
add_varchar_40 varchar(8000) default 'abcde',
add_clob_40 clob default 'abcde',
add_blob_40 blob default 'abcde',
add_int_41 int default  12345,
add_varchar2_41 varchar2(100) default 'abcde',
add_varchar_41 varchar(8000) default 'abcde',
add_clob_41 clob default 'abcde',
add_blob_41 blob default 'abcde',
add_int_42 int default  12345,
add_varchar2_42 varchar2(100) default 'abcde',
add_varchar_42 varchar(8000) default 'abcde',
add_clob_42 clob default 'abcde',
add_blob_42 blob default 'abcde',
add_int_43 int default  12345,
add_varchar2_43 varchar2(100) default 'abcde',
add_varchar_43 varchar(8000) default 'abcde',
add_clob_43 clob default 'abcde',
add_blob_43 blob default 'abcde',
add_int_44 int default  12345,
add_varchar2_44 varchar2(100) default 'abcde',
add_varchar_44 varchar(8000) default 'abcde',
add_clob_44 clob default 'abcde',
add_blob_44 blob default 'abcde',
add_int_45 int default  12345,
add_varchar2_45 varchar2(100) default 'abcde',
add_varchar_45 varchar(8000) default 'abcde',
add_clob_45 clob default 'abcde',
add_blob_45 blob default 'abcde',
add_int_46 int default  12345,
add_varchar2_46 varchar2(100) default 'abcde',
add_varchar_46 varchar(8000) default 'abcde',
add_clob_46 clob default 'abcde',
add_blob_46 blob default 'abcde',
add_int_47 int default  12345,
add_varchar2_47 varchar2(100) default 'abcde',
add_varchar_47 varchar(8000) default 'abcde',
add_clob_47 clob default 'abcde',
add_blob_47 blob default 'abcde',
add_int_48 int default  12345,
add_varchar2_48 varchar2(100) default 'abcde',
add_varchar_48 varchar(8000) default 'abcde',
add_clob_48 clob default 'abcde',
add_blob_48 blob default 'abcde',
add_int_49 int default  12345,
add_varchar2_49 varchar2(100) default 'abcde',
add_varchar_49 varchar(8000) default 'abcde',
add_clob_49 clob default 'abcde',
add_blob_49 blob default 'abcde',
add_int_50 int default  12345,
add_varchar2_50 varchar2(100) default 'abcde',
add_varchar_50 varchar(8000) default 'abcde',
add_clob_50 clob default 'abcde',
add_blob_50 blob default 'abcde'
);

alter system set enable_sql_map=true;
ALTER SQL_MAP (select count(*) from oracle_test_tbl_001 where c_id is not null and c_d_id is not null and c_w_id is not null and c_first is not null and 
c_middle is not null and c_last is not null and c_street_1 is not null and c_street_2 is not null and c_city is not null and c_state is not null and 
c_zip is not null and c_phone is not null and c_since is not null and c_credit is not null and c_credit_lim is not null and c_discount is not null and 
c_balance is not null and c_end is not null and c_data1 is not null and c_data2 is not null and c_data3 is not null and c_data4 is not null and c_data5 is not null 
and c_data6 is not null and c_data7 is not null and c_data8 is not null and c_clob is not null and c_blob is not null and column_int is not null and column_bigint is not null and 
column_tinyint is not null and column_float is not null and column_double is not null and column_decimal is not null and column_number is not null and column_numeric is not null and 
column_char is not null and column_varchar is not null and column_varchar2 is not null and column_binary is not null and column_varbinary is not null and column_date is not null and 
column_timestamp is not null and add_int_0 is not null and add_varchar2_0 is not null and add_varchar_0 is not null and add_clob_0 is not null and add_blob_0 is not null and add_int_1 is not null and 
add_varchar2_1 is not null and add_varchar_1 is not null and add_clob_1 is not null and add_blob_1 is not null and add_int_2 is not null and add_varchar2_2 is not null and add_varchar_2 is not null and 
add_clob_2 is not null and add_blob_2 is not null and add_int_3 is not null and add_varchar2_3 is not null and add_varchar_3 is not null and add_clob_3 is not null and add_blob_3 is not null and add_int_4 is not null and 
add_varchar2_4 is not null and add_varchar_4 is not null and add_clob_4 is not null and add_blob_4 is not null and add_int_5 is not null and add_varchar2_5 is not null and add_varchar_5 is not null and add_clob_5 is not null and 
add_blob_5 is not null and add_int_6 is not null and add_varchar2_6 is not null and add_varchar_6 is not null and add_clob_6 is not null and add_blob_6 is not null and add_int_7 is not null and add_varchar2_7 is not null and 
add_varchar_7 is not null and add_clob_7 is not null and add_blob_7 is not null and add_int_8 is not null and add_varchar2_8 is not null and add_varchar_8 is not null and add_clob_8 is not null and add_blob_8 is not null and 
add_int_9 is not null and add_varchar2_9 is not null and add_varchar_9 is not null and add_clob_9 is not null and add_blob_9 is not null and add_int_10 is not null and add_varchar2_10 is not null and add_varchar_10 is not null and 
add_clob_10 is not null and add_blob_10 is not null and add_int_11 is not null and add_varchar2_11 is not null and add_varchar_11 is not null and add_clob_11 is not null and add_blob_11 is not null and add_int_12 is not null and 
add_varchar2_12 is not null and add_varchar_12 is not null and add_clob_12 is not null and add_blob_12 is not null and add_int_13 is not null and add_varchar2_13 is not null and add_varchar_13 is not null and 
add_clob_13 is not null and add_blob_13 is not null and add_int_14 is not null and add_varchar2_14 is not null and add_varchar_14 is not null and add_clob_14 is not null and add_blob_14 is not null and 
add_int_15 is not null and add_varchar2_15 is not null and add_varchar_15 is not null and add_clob_15 is not null and add_blob_15 is not null and add_int_16 is not null and add_varchar2_16 is not null and 
add_varchar_16 is not null and add_clob_16 is not null and add_blob_16 is not null and add_int_17 is not null and add_varchar2_17 is not null and add_varchar_17 is not null and add_clob_17 is not null and 
add_blob_17 is not null and add_int_18 is not null and add_varchar2_18 is not null and add_varchar_18 is not null and add_clob_18 is not null and add_blob_18 is not null and add_int_19 is not null and 
add_varchar2_19 is not null and add_varchar_19 is not null and add_clob_19 is not null and add_blob_19 is not null and add_int_20 is not null and add_varchar2_20 is not null and add_varchar_20 is not null and 
add_clob_20 is not null and add_blob_20 is not null and add_int_21 is not null and add_varchar2_21 is not null and add_varchar_21 is not null and add_clob_21 is not null and add_blob_21 is not null and 
add_int_22 is not null and add_varchar2_22 is not null and add_varchar_22 is not null and add_clob_22 is not null and add_blob_22 is not null and add_int_23 is not null and add_varchar2_23 is not null and 
add_varchar_23 is not null and add_clob_23 is not null and add_blob_23 is not null and add_int_24 is not null and add_varchar2_24 is not null and add_varchar_24 is not null and add_clob_24 is not null and 
add_blob_24 is not null and add_int_25 is not null and add_varchar2_25 is not null and add_varchar_25 is not null and add_clob_25 is not null and add_blob_25 is not null and add_int_26 is not null and 
add_varchar2_26 is not null and add_varchar_26 is not null and add_clob_26 is not null and add_blob_26 is not null and add_int_27 is not null and add_varchar2_27 is not null and add_varchar_27 is not null and 
add_clob_27 is not null and add_blob_27 is not null and add_int_28 is not null and add_varchar2_28 is not null and add_varchar_28 is not null and add_clob_28 is not null and add_blob_28 is not null and 
add_int_29 is not null and add_varchar2_29 is not null and add_varchar_29 is not null and add_clob_29 is not null and add_blob_29 is not null and add_int_30 is not null and add_varchar2_30 is not null and 
add_varchar_30 is not null and add_clob_30 is not null and add_blob_30 is not null and add_int_31 is not null and add_varchar2_31 is not null and add_varchar_31 is not null and add_clob_31 is not null and 
add_blob_31 is not null and add_int_32 is not null and add_varchar2_32 is not null and add_varchar_32 is not null and add_clob_32 is not null and add_blob_32 is not null and add_int_33 is not null and 
add_varchar2_33 is not null and add_varchar_33 is not null and add_clob_33 is not null and add_blob_33 is not null and add_int_34 is not null and add_varchar2_34 is not null and add_varchar_34 is not null and 
add_clob_34 is not null and add_blob_34 is not null and add_int_35 is not null and add_varchar2_35 is not null and add_varchar_35 is not null and add_clob_35 is not null and add_blob_35 is not null and 
add_int_36 is not null and add_varchar2_36 is not null and add_varchar_36 is not null and add_clob_36 is not null and add_blob_36 is not null and add_int_37 is not null and add_varchar2_37 is not null and 
add_varchar_37 is not null and add_clob_37 is not null and add_blob_37 is not null and add_int_38 is not null and add_varchar2_38 is not null and add_varchar_38 is not null and add_clob_38 is not null and 
add_blob_38 is not null and add_int_39 is not null and add_varchar2_39 is not null and add_varchar_39 is not null and add_clob_39 is not null and add_blob_39 is not null and add_int_40 is not null and 
add_varchar2_40 is not null and add_varchar_40 is not null and add_clob_40 is not null and add_blob_40 is not null and add_int_41 is not null and add_varchar2_41 is not null and add_varchar_41 is not null and 
add_clob_41 is not null and add_blob_41 is not null and add_int_42 is not null and add_varchar2_42 is not null and add_varchar_42 is not null and add_clob_42 is not null and add_blob_42 is not null and 
add_int_43 is not null and add_varchar2_43 is not null and add_varchar_43 is not null and add_clob_43 is not null and add_blob_43 is not null and add_int_44 is not null and add_varchar2_44 is not null and 
add_varchar_44 is not null and add_clob_44 is not null and add_blob_44 is not null and add_int_45 is not null and add_varchar2_45 is not null and add_varchar_45 is not null and add_clob_45 is not null and 
add_blob_45 is not null and add_int_46 is not null and add_varchar2_46 is not null and add_varchar_46 is not null and add_clob_46 is not null and add_blob_46 is not null and add_int_47 is not null and 
add_varchar2_47 is not null and add_varchar_47 is not null and add_clob_47 is not null and add_blob_47 is not null and add_int_48 is not null and add_varchar2_48 is not null and 
add_varchar_48 is not null and add_clob_48 is not null and add_blob_48 is not null and add_int_49 is not null and add_varchar2_49 is not null and add_varchar_49 is not null and 
add_clob_49 is not null and add_blob_49 is not null and add_int_50 is not null and add_varchar2_50 is not null and add_varchar_50 is not null and add_clob_50 is not null and add_blob_50 is not null and
c_id is not null and c_d_id is not null and c_w_id is not null and c_first is not null and 
c_middle is not null and c_last is not null and c_street_1 is not null and c_street_2 is not null and c_city is not null and c_state is not null and 
c_zip is not null and c_phone is not null and c_since is not null and c_credit is not null and c_credit_lim is not null and c_discount is not null and 
c_balance is not null and c_end is not null and c_data1 is not null and c_data2 is not null and c_data3 is not null and c_data4 is not null and c_data5 is not null 
and c_data6 is not null and c_data7 is not null and c_data8 is not null and c_clob is not null and c_blob is not null and column_int is not null and column_bigint is not null and 
column_tinyint is not null and column_float is not null and column_double is not null and column_decimal is not null and column_number is not null and column_numeric is not null and 
column_char is not null and column_varchar is not null and column_varchar2 is not null and column_binary is not null and column_varbinary is not null and column_date is not null and 
column_timestamp is not null and add_int_0 is not null and add_varchar2_0 is not null and add_varchar_0 is not null and add_clob_0 is not null and add_blob_0 is not null and add_int_1 is not null and 
add_varchar2_1 is not null and add_varchar_1 is not null and add_clob_1 is not null and add_blob_1 is not null and add_int_2 is not null and add_varchar2_2 is not null and add_varchar_2 is not null and 
add_clob_2 is not null and add_blob_2 is not null and add_int_3 is not null and add_varchar2_3 is not null and add_varchar_3 is not null and add_clob_3 is not null and add_blob_3 is not null and add_int_4 is not null and 
add_varchar2_4 is not null and add_varchar_4 is not null and add_clob_4 is not null and add_blob_4 is not null and add_int_5 is not null and add_varchar2_5 is not null and add_varchar_5 is not null and add_clob_5 is not null and 
add_blob_5 is not null and add_int_6 is not null and add_varchar2_6 is not null and add_varchar_6 is not null and add_clob_6 is not null and add_blob_6 is not null and add_int_7 is not null and add_varchar2_7 is not null and 
add_varchar_7 is not null and add_clob_7 is not null and add_blob_7 is not null and add_int_8 is not null and add_varchar2_8 is not null and add_varchar_8 is not null and add_clob_8 is not null and add_blob_8 is not null and 
add_int_9 is not null and add_varchar2_9 is not null and add_varchar_9 is not null and add_clob_9 is not null and add_blob_9 is not null and add_int_10 is not null and add_varchar2_10 is not null and add_varchar_10 is not null and 
add_clob_10 is not null and add_blob_10 is not null and add_int_11 is not null and add_varchar2_11 is not null and add_varchar_11 is not null and add_clob_11 is not null and add_blob_11 is not null and add_int_12 is not null and 
add_varchar2_12 is not null and add_varchar_12 is not null and add_clob_12 is not null and add_blob_12 is not null and add_int_13 is not null and add_varchar2_13 is not null and add_varchar_13 is not null and 
add_clob_13 is not null and add_blob_13 is not null and add_int_14 is not null and add_varchar2_14 is not null and add_varchar_14 is not null and add_clob_14 is not null and add_blob_14 is not null and 
add_int_15 is not null and add_varchar2_15 is not null and add_varchar_15 is not null and add_clob_15 is not null and add_blob_15 is not null and add_int_16 is not null and add_varchar2_16 is not null and 
add_varchar_16 is not null and add_clob_16 is not null and add_blob_16 is not null and add_int_17 is not null and add_varchar2_17 is not null and add_varchar_17 is not null and add_clob_17 is not null and 
add_blob_17 is not null and add_int_18 is not null and add_varchar2_18 is not null and add_varchar_18 is not null and add_clob_18 is not null and add_blob_18 is not null and add_int_19 is not null and 
add_varchar2_19 is not null and add_varchar_19 is not null and add_clob_19 is not null and add_blob_19 is not null and add_int_20 is not null and add_varchar2_20 is not null and add_varchar_20 is not null and 
add_clob_20 is not null and add_blob_20 is not null and add_int_21 is not null and add_varchar2_21 is not null and add_varchar_21 is not null and add_clob_21 is not null and add_blob_21 is not null and 
add_int_22 is not null and add_varchar2_22 is not null and add_varchar_22 is not null and add_clob_22 is not null and add_blob_22 is not null and add_int_23 is not null and add_varchar2_23 is not null and 
add_varchar_23 is not null and add_clob_23 is not null and add_blob_23 is not null and add_int_24 is not null and add_varchar2_24 is not null and add_varchar_24 is not null and add_clob_24 is not null and 
add_blob_24 is not null and add_int_25 is not null and add_varchar2_25 is not null and add_varchar_25 is not null and add_clob_25 is not null and add_blob_25 is not null and add_int_26 is not null and 
add_varchar2_26 is not null and add_varchar_26 is not null and add_clob_26 is not null and add_blob_26 is not null and add_int_27 is not null and add_varchar2_27 is not null and add_varchar_27 is not null and 
add_clob_27 is not null and add_blob_27 is not null and add_int_28 is not null and add_varchar2_28 is not null and add_varchar_28 is not null and add_clob_28 is not null and add_blob_28 is not null and 
add_int_29 is not null and add_varchar2_29 is not null and add_varchar_29 is not null and add_clob_29 is not null and add_blob_29 is not null and add_int_30 is not null and add_varchar2_30 is not null and 
add_varchar_30 is not null and add_clob_30 is not null and add_blob_30 is not null and add_int_31 is not null and add_varchar2_31 is not null and add_varchar_31 is not null and add_clob_31 is not null and 
add_blob_31 is not null and add_int_32 is not null and add_varchar2_32 is not null and add_varchar_32 is not null and add_clob_32 is not null and add_blob_32 is not null and add_int_33 is not null and 
add_varchar2_33 is not null and add_varchar_33 is not null and add_clob_33 is not null and add_blob_33 is not null and add_int_34 is not null and add_varchar2_34 is not null and add_varchar_34 is not null and 
add_clob_34 is not null and add_blob_34 is not null and add_int_35 is not null and add_varchar2_35 is not null and add_varchar_35 is not null and add_clob_35 is not null and add_blob_35 is not null and 
add_int_36 is not null and add_varchar2_36 is not null and add_varchar_36 is not null and add_clob_36 is not null and add_blob_36 is not null and add_int_37 is not null and add_varchar2_37 is not null and 
add_varchar_37 is not null and add_clob_37 is not null and add_blob_37 is not null and add_int_38 is not null and add_varchar2_38 is not null and add_varchar_38 is not null and add_clob_38 is not null and 
add_blob_38 is not null and add_int_39 is not null and add_varchar2_39 is not null and add_varchar_39 is not null and add_clob_39 is not null and add_blob_39 is not null and add_int_40 is not null and 
add_varchar2_40 is not null and add_varchar_40 is not null and add_clob_40 is not null and add_blob_40 is not null and add_int_41 is not null and add_varchar2_41 is not null and add_varchar_41 is not null and 
add_clob_41 is not null and add_blob_41 is not null and add_int_42 is not null and add_varchar2_42 is not null and add_varchar_42 is not null and add_clob_42 is not null and add_blob_42 is not null and 
add_int_43 is not null and add_varchar2_43 is not null and add_varchar_43 is not null and add_clob_43 is not null and add_blob_43 is not null and add_int_44 is not null and add_varchar2_44 is not null and 
add_varchar_44 is not null and add_clob_44 is not null and add_blob_44 is not null and add_int_45 is not null and add_varchar2_45 is not null and add_varchar_45 is not null and add_clob_45 is not null and 
add_blob_45 is not null and add_int_46 is not null and add_varchar2_46 is not null and add_varchar_46 is not null and add_clob_46 is not null and add_blob_46 is not null and add_int_47 is not null and 
add_varchar2_47 is not null and add_varchar_47 is not null and add_clob_47 is not null and add_blob_47 is not null and add_int_48 is not null and add_varchar2_48 is not null and 
add_varchar_48 is not null and add_clob_48 is not null and add_blob_48 is not null and add_int_49 is not null and add_varchar2_49 is not null and add_varchar_49 is not null and 
add_clob_49 is not null and add_blob_49 is not null and add_int_50 is not null and add_varchar2_50 is not null and add_varchar_50 is not null and add_clob_50 is not null and add_blob_50 is not null)  
REWRITE TO (select count(1) as ff from oracle_test_tbl_001 where c_id is not null and c_d_id is not null and c_w_id is not null and c_first is not null and 
c_middle is not null and c_last is not null and c_street_1 is not null and c_street_2 is not null and c_city is not null and c_state is not null and 
c_zip is not null and c_phone is not null and c_since is not null and c_credit is not null and c_credit_lim is not null and c_discount is not null and 
c_balance is not null and c_end is not null and c_data1 is not null and c_data2 is not null and c_data3 is not null and c_data4 is not null and c_data5 is not null 
and c_data6 is not null and c_data7 is not null and c_data8 is not null and c_clob is not null and c_blob is not null and column_int is not null and column_bigint is not null and 
column_tinyint is not null and column_float is not null and column_double is not null and column_decimal is not null and column_number is not null and column_numeric is not null and 
column_char is not null and column_varchar is not null and column_varchar2 is not null and column_binary is not null and column_varbinary is not null and column_date is not null and 
column_timestamp is not null and add_int_0 is not null and add_varchar2_0 is not null and add_varchar_0 is not null and add_clob_0 is not null and add_blob_0 is not null and add_int_1 is not null and 
add_varchar2_1 is not null and add_varchar_1 is not null and add_clob_1 is not null and add_blob_1 is not null and add_int_2 is not null and add_varchar2_2 is not null and add_varchar_2 is not null and 
add_clob_2 is not null and add_blob_2 is not null and add_int_3 is not null and add_varchar2_3 is not null and add_varchar_3 is not null and add_clob_3 is not null and add_blob_3 is not null and add_int_4 is not null and 
add_varchar2_4 is not null and add_varchar_4 is not null and add_clob_4 is not null and add_blob_4 is not null and add_int_5 is not null and add_varchar2_5 is not null and add_varchar_5 is not null and add_clob_5 is not null and 
add_blob_5 is not null and add_int_6 is not null and add_varchar2_6 is not null and add_varchar_6 is not null and add_clob_6 is not null and add_blob_6 is not null and add_int_7 is not null and add_varchar2_7 is not null and 
add_varchar_7 is not null and add_clob_7 is not null and add_blob_7 is not null and add_int_8 is not null and add_varchar2_8 is not null and add_varchar_8 is not null and add_clob_8 is not null and add_blob_8 is not null and 
add_int_9 is not null and add_varchar2_9 is not null and add_varchar_9 is not null and add_clob_9 is not null and add_blob_9 is not null and add_int_10 is not null and add_varchar2_10 is not null and add_varchar_10 is not null and 
add_clob_10 is not null and add_blob_10 is not null and add_int_11 is not null and add_varchar2_11 is not null and add_varchar_11 is not null and add_clob_11 is not null and add_blob_11 is not null and add_int_12 is not null and 
add_varchar2_12 is not null and add_varchar_12 is not null and add_clob_12 is not null and add_blob_12 is not null and add_int_13 is not null and add_varchar2_13 is not null and add_varchar_13 is not null and 
add_clob_13 is not null and add_blob_13 is not null and add_int_14 is not null and add_varchar2_14 is not null and add_varchar_14 is not null and add_clob_14 is not null and add_blob_14 is not null and 
add_int_15 is not null and add_varchar2_15 is not null and add_varchar_15 is not null and add_clob_15 is not null and add_blob_15 is not null and add_int_16 is not null and add_varchar2_16 is not null and 
add_varchar_16 is not null and add_clob_16 is not null and add_blob_16 is not null and add_int_17 is not null and add_varchar2_17 is not null and add_varchar_17 is not null and add_clob_17 is not null and 
add_blob_17 is not null and add_int_18 is not null and add_varchar2_18 is not null and add_varchar_18 is not null and add_clob_18 is not null and add_blob_18 is not null and add_int_19 is not null and 
add_varchar2_19 is not null and add_varchar_19 is not null and add_clob_19 is not null and add_blob_19 is not null and add_int_20 is not null and add_varchar2_20 is not null and add_varchar_20 is not null and 
add_clob_20 is not null and add_blob_20 is not null and add_int_21 is not null and add_varchar2_21 is not null and add_varchar_21 is not null and add_clob_21 is not null and add_blob_21 is not null and 
add_int_22 is not null and add_varchar2_22 is not null and add_varchar_22 is not null and add_clob_22 is not null and add_blob_22 is not null and add_int_23 is not null and add_varchar2_23 is not null and 
add_varchar_23 is not null and add_clob_23 is not null and add_blob_23 is not null and add_int_24 is not null and add_varchar2_24 is not null and add_varchar_24 is not null and add_clob_24 is not null and 
add_blob_24 is not null and add_int_25 is not null and add_varchar2_25 is not null and add_varchar_25 is not null and add_clob_25 is not null and add_blob_25 is not null and add_int_26 is not null and 
add_varchar2_26 is not null and add_varchar_26 is not null and add_clob_26 is not null and add_blob_26 is not null and add_int_27 is not null and add_varchar2_27 is not null and add_varchar_27 is not null and 
add_clob_27 is not null and add_blob_27 is not null and add_int_28 is not null and add_varchar2_28 is not null and add_varchar_28 is not null and add_clob_28 is not null and add_blob_28 is not null and 
add_int_29 is not null and add_varchar2_29 is not null and add_varchar_29 is not null and add_clob_29 is not null and add_blob_29 is not null and add_int_30 is not null and add_varchar2_30 is not null and 
add_varchar_30 is not null and add_clob_30 is not null and add_blob_30 is not null and add_int_31 is not null and add_varchar2_31 is not null and add_varchar_31 is not null and add_clob_31 is not null and 
add_blob_31 is not null and add_int_32 is not null and add_varchar2_32 is not null and add_varchar_32 is not null and add_clob_32 is not null and add_blob_32 is not null and add_int_33 is not null and 
add_varchar2_33 is not null and add_varchar_33 is not null and add_clob_33 is not null and add_blob_33 is not null and add_int_34 is not null and add_varchar2_34 is not null and add_varchar_34 is not null and 
add_clob_34 is not null and add_blob_34 is not null and add_int_35 is not null and add_varchar2_35 is not null and add_varchar_35 is not null and add_clob_35 is not null and add_blob_35 is not null and 
add_int_36 is not null and add_varchar2_36 is not null and add_varchar_36 is not null and add_clob_36 is not null and add_blob_36 is not null and add_int_37 is not null and add_varchar2_37 is not null and 
add_varchar_37 is not null and add_clob_37 is not null and add_blob_37 is not null and add_int_38 is not null and add_varchar2_38 is not null and add_varchar_38 is not null and add_clob_38 is not null and 
add_blob_38 is not null and add_int_39 is not null and add_varchar2_39 is not null and add_varchar_39 is not null and add_clob_39 is not null and add_blob_39 is not null and add_int_40 is not null and 
add_varchar2_40 is not null and add_varchar_40 is not null and add_clob_40 is not null and add_blob_40 is not null and add_int_41 is not null and add_varchar2_41 is not null and add_varchar_41 is not null and 
add_clob_41 is not null and add_blob_41 is not null and add_int_42 is not null and add_varchar2_42 is not null and add_varchar_42 is not null and add_clob_42 is not null and add_blob_42 is not null and 
add_int_43 is not null and add_varchar2_43 is not null and add_varchar_43 is not null and add_clob_43 is not null and add_blob_43 is not null and add_int_44 is not null and add_varchar2_44 is not null and 
add_varchar_44 is not null and add_clob_44 is not null and add_blob_44 is not null and add_int_45 is not null and add_varchar2_45 is not null and add_varchar_45 is not null and add_clob_45 is not null and 
add_blob_45 is not null and add_int_46 is not null and add_varchar2_46 is not null and add_varchar_46 is not null and add_clob_46 is not null and add_blob_46 is not null and add_int_47 is not null and 
add_varchar2_47 is not null and add_varchar_47 is not null and add_clob_47 is not null and add_blob_47 is not null and add_int_48 is not null and add_varchar2_48 is not null and 
add_varchar_48 is not null and add_clob_48 is not null and add_blob_48 is not null and add_int_49 is not null and add_varchar2_49 is not null and add_varchar_49 is not null and 
add_clob_49 is not null and add_blob_49 is not null and add_int_50 is not null and add_varchar2_50 is not null and add_varchar_50 is not null and add_clob_50 is not null and add_blob_50 is not null and
c_id is not null and c_d_id is not null and c_w_id is not null and c_first is not null and 
c_middle is not null and c_last is not null and c_street_1 is not null and c_street_2 is not null and c_city is not null and c_state is not null and 
c_zip is not null and c_phone is not null and c_since is not null and c_credit is not null and c_credit_lim is not null and c_discount is not null and 
c_balance is not null and c_end is not null and c_data1 is not null and c_data2 is not null and c_data3 is not null and c_data4 is not null and c_data5 is not null 
and c_data6 is not null and c_data7 is not null and c_data8 is not null and c_clob is not null and c_blob is not null and column_int is not null and column_bigint is not null and 
column_tinyint is not null and column_float is not null and column_double is not null and column_decimal is not null and column_number is not null and column_numeric is not null and 
column_char is not null and column_varchar is not null and column_varchar2 is not null and column_binary is not null and column_varbinary is not null and column_date is not null and 
column_timestamp is not null and add_int_0 is not null and add_varchar2_0 is not null and add_varchar_0 is not null and add_clob_0 is not null and add_blob_0 is not null and add_int_1 is not null and 
add_varchar2_1 is not null and add_varchar_1 is not null and add_clob_1 is not null and add_blob_1 is not null and add_int_2 is not null and add_varchar2_2 is not null and add_varchar_2 is not null and 
add_clob_2 is not null and add_blob_2 is not null and add_int_3 is not null and add_varchar2_3 is not null and add_varchar_3 is not null and add_clob_3 is not null and add_blob_3 is not null and add_int_4 is not null and 
add_varchar2_4 is not null and add_varchar_4 is not null and add_clob_4 is not null and add_blob_4 is not null and add_int_5 is not null and add_varchar2_5 is not null and add_varchar_5 is not null and add_clob_5 is not null and 
add_blob_5 is not null and add_int_6 is not null and add_varchar2_6 is not null and add_varchar_6 is not null and add_clob_6 is not null and add_blob_6 is not null and add_int_7 is not null and add_varchar2_7 is not null and 
add_varchar_7 is not null and add_clob_7 is not null and add_blob_7 is not null and add_int_8 is not null and add_varchar2_8 is not null and add_varchar_8 is not null and add_clob_8 is not null and add_blob_8 is not null and 
add_int_9 is not null and add_varchar2_9 is not null and add_varchar_9 is not null and add_clob_9 is not null and add_blob_9 is not null and add_int_10 is not null and add_varchar2_10 is not null and add_varchar_10 is not null and 
add_clob_10 is not null and add_blob_10 is not null and add_int_11 is not null and add_varchar2_11 is not null and add_varchar_11 is not null and add_clob_11 is not null and add_blob_11 is not null and add_int_12 is not null and 
add_varchar2_12 is not null and add_varchar_12 is not null and add_clob_12 is not null and add_blob_12 is not null and add_int_13 is not null and add_varchar2_13 is not null and add_varchar_13 is not null and 
add_clob_13 is not null and add_blob_13 is not null and add_int_14 is not null and add_varchar2_14 is not null and add_varchar_14 is not null and add_clob_14 is not null and add_blob_14 is not null and 
add_int_15 is not null and add_varchar2_15 is not null and add_varchar_15 is not null and add_clob_15 is not null and add_blob_15 is not null and add_int_16 is not null and add_varchar2_16 is not null and 
add_varchar_16 is not null and add_clob_16 is not null and add_blob_16 is not null and add_int_17 is not null and add_varchar2_17 is not null and add_varchar_17 is not null and add_clob_17 is not null and 
add_blob_17 is not null and add_int_18 is not null and add_varchar2_18 is not null and add_varchar_18 is not null and add_clob_18 is not null and add_blob_18 is not null and add_int_19 is not null and 
add_varchar2_19 is not null and add_varchar_19 is not null and add_clob_19 is not null and add_blob_19 is not null and add_int_20 is not null and add_varchar2_20 is not null and add_varchar_20 is not null and 
add_clob_20 is not null and add_blob_20 is not null and add_int_21 is not null and add_varchar2_21 is not null and add_varchar_21 is not null and add_clob_21 is not null and add_blob_21 is not null and 
add_int_22 is not null and add_varchar2_22 is not null and add_varchar_22 is not null and add_clob_22 is not null and add_blob_22 is not null and add_int_23 is not null and add_varchar2_23 is not null and 
add_varchar_23 is not null and add_clob_23 is not null and add_blob_23 is not null and add_int_24 is not null and add_varchar2_24 is not null and add_varchar_24 is not null and add_clob_24 is not null and 
add_blob_24 is not null and add_int_25 is not null and add_varchar2_25 is not null and add_varchar_25 is not null and add_clob_25 is not null and add_blob_25 is not null and add_int_26 is not null and 
add_varchar2_26 is not null and add_varchar_26 is not null and add_clob_26 is not null and add_blob_26 is not null and add_int_27 is not null and add_varchar2_27 is not null and add_varchar_27 is not null and 
add_clob_27 is not null and add_blob_27 is not null and add_int_28 is not null and add_varchar2_28 is not null and add_varchar_28 is not null and add_clob_28 is not null and add_blob_28 is not null and 
add_int_29 is not null and add_varchar2_29 is not null and add_varchar_29 is not null and add_clob_29 is not null and add_blob_29 is not null and add_int_30 is not null and add_varchar2_30 is not null and 
add_varchar_30 is not null and add_clob_30 is not null and add_blob_30 is not null and add_int_31 is not null and add_varchar2_31 is not null and add_varchar_31 is not null and add_clob_31 is not null and 
add_blob_31 is not null and add_int_32 is not null and add_varchar2_32 is not null and add_varchar_32 is not null and add_clob_32 is not null and add_blob_32 is not null and add_int_33 is not null and 
add_varchar2_33 is not null and add_varchar_33 is not null and add_clob_33 is not null and add_blob_33 is not null and add_int_34 is not null and add_varchar2_34 is not null and add_varchar_34 is not null and 
add_clob_34 is not null and add_blob_34 is not null and add_int_35 is not null and add_varchar2_35 is not null and add_varchar_35 is not null and add_clob_35 is not null and add_blob_35 is not null and 
add_int_36 is not null and add_varchar2_36 is not null and add_varchar_36 is not null and add_clob_36 is not null and add_blob_36 is not null and add_int_37 is not null and add_varchar2_37 is not null and 
add_varchar_37 is not null and add_clob_37 is not null and add_blob_37 is not null and add_int_38 is not null and add_varchar2_38 is not null and add_varchar_38 is not null and add_clob_38 is not null and 
add_blob_38 is not null and add_int_39 is not null and add_varchar2_39 is not null and add_varchar_39 is not null and add_clob_39 is not null and add_blob_39 is not null and add_int_40 is not null and 
add_varchar2_40 is not null and add_varchar_40 is not null and add_clob_40 is not null and add_blob_40 is not null and add_int_41 is not null and add_varchar2_41 is not null and add_varchar_41 is not null and 
add_clob_41 is not null and add_blob_41 is not null and add_int_42 is not null and add_varchar2_42 is not null and add_varchar_42 is not null and add_clob_42 is not null and add_blob_42 is not null and 
add_int_43 is not null and add_varchar2_43 is not null and add_varchar_43 is not null and add_clob_43 is not null and add_blob_43 is not null and add_int_44 is not null and add_varchar2_44 is not null and 
add_varchar_44 is not null and add_clob_44 is not null and add_blob_44 is not null and add_int_45 is not null and add_varchar2_45 is not null and add_varchar_45 is not null and add_clob_45 is not null and 
add_blob_45 is not null and add_int_46 is not null and add_varchar2_46 is not null and add_varchar_46 is not null and add_clob_46 is not null and add_blob_46 is not null and add_int_47 is not null and 
add_varchar2_47 is not null and add_varchar_47 is not null and add_clob_47 is not null and add_blob_47 is not null and add_int_48 is not null and add_varchar2_48 is not null and 
add_varchar_48 is not null and add_clob_48 is not null and add_blob_48 is not null and add_int_49 is not null and add_varchar2_49 is not null and add_varchar_49 is not null and 
add_clob_49 is not null and add_blob_49 is not null and add_int_50 is not null and add_varchar2_50 is not null and add_varchar_50 is not null and add_clob_50 is not null and add_blob_50 is not null);

select count(*) from oracle_test_tbl_001 where c_id is not null and c_d_id is not null and c_w_id is not null and c_first is not null and 
c_middle is not null and c_last is not null and c_street_1 is not null and c_street_2 is not null and c_city is not null and c_state is not null and 
c_zip is not null and c_phone is not null and c_since is not null and c_credit is not null and c_credit_lim is not null and c_discount is not null and 
c_balance is not null and c_end is not null and c_data1 is not null and c_data2 is not null and c_data3 is not null and c_data4 is not null and c_data5 is not null 
and c_data6 is not null and c_data7 is not null and c_data8 is not null and c_clob is not null and c_blob is not null and column_int is not null and column_bigint is not null and 
column_tinyint is not null and column_float is not null and column_double is not null and column_decimal is not null and column_number is not null and column_numeric is not null and 
column_char is not null and column_varchar is not null and column_varchar2 is not null and column_binary is not null and column_varbinary is not null and column_date is not null and 
column_timestamp is not null and add_int_0 is not null and add_varchar2_0 is not null and add_varchar_0 is not null and add_clob_0 is not null and add_blob_0 is not null and add_int_1 is not null and 
add_varchar2_1 is not null and add_varchar_1 is not null and add_clob_1 is not null and add_blob_1 is not null and add_int_2 is not null and add_varchar2_2 is not null and add_varchar_2 is not null and 
add_clob_2 is not null and add_blob_2 is not null and add_int_3 is not null and add_varchar2_3 is not null and add_varchar_3 is not null and add_clob_3 is not null and add_blob_3 is not null and add_int_4 is not null and 
add_varchar2_4 is not null and add_varchar_4 is not null and add_clob_4 is not null and add_blob_4 is not null and add_int_5 is not null and add_varchar2_5 is not null and add_varchar_5 is not null and add_clob_5 is not null and 
add_blob_5 is not null and add_int_6 is not null and add_varchar2_6 is not null and add_varchar_6 is not null and add_clob_6 is not null and add_blob_6 is not null and add_int_7 is not null and add_varchar2_7 is not null and 
add_varchar_7 is not null and add_clob_7 is not null and add_blob_7 is not null and add_int_8 is not null and add_varchar2_8 is not null and add_varchar_8 is not null and add_clob_8 is not null and add_blob_8 is not null and 
add_int_9 is not null and add_varchar2_9 is not null and add_varchar_9 is not null and add_clob_9 is not null and add_blob_9 is not null and add_int_10 is not null and add_varchar2_10 is not null and add_varchar_10 is not null and 
add_clob_10 is not null and add_blob_10 is not null and add_int_11 is not null and add_varchar2_11 is not null and add_varchar_11 is not null and add_clob_11 is not null and add_blob_11 is not null and add_int_12 is not null and 
add_varchar2_12 is not null and add_varchar_12 is not null and add_clob_12 is not null and add_blob_12 is not null and add_int_13 is not null and add_varchar2_13 is not null and add_varchar_13 is not null and 
add_clob_13 is not null and add_blob_13 is not null and add_int_14 is not null and add_varchar2_14 is not null and add_varchar_14 is not null and add_clob_14 is not null and add_blob_14 is not null and 
add_int_15 is not null and add_varchar2_15 is not null and add_varchar_15 is not null and add_clob_15 is not null and add_blob_15 is not null and add_int_16 is not null and add_varchar2_16 is not null and 
add_varchar_16 is not null and add_clob_16 is not null and add_blob_16 is not null and add_int_17 is not null and add_varchar2_17 is not null and add_varchar_17 is not null and add_clob_17 is not null and 
add_blob_17 is not null and add_int_18 is not null and add_varchar2_18 is not null and add_varchar_18 is not null and add_clob_18 is not null and add_blob_18 is not null and add_int_19 is not null and 
add_varchar2_19 is not null and add_varchar_19 is not null and add_clob_19 is not null and add_blob_19 is not null and add_int_20 is not null and add_varchar2_20 is not null and add_varchar_20 is not null and 
add_clob_20 is not null and add_blob_20 is not null and add_int_21 is not null and add_varchar2_21 is not null and add_varchar_21 is not null and add_clob_21 is not null and add_blob_21 is not null and 
add_int_22 is not null and add_varchar2_22 is not null and add_varchar_22 is not null and add_clob_22 is not null and add_blob_22 is not null and add_int_23 is not null and add_varchar2_23 is not null and 
add_varchar_23 is not null and add_clob_23 is not null and add_blob_23 is not null and add_int_24 is not null and add_varchar2_24 is not null and add_varchar_24 is not null and add_clob_24 is not null and 
add_blob_24 is not null and add_int_25 is not null and add_varchar2_25 is not null and add_varchar_25 is not null and add_clob_25 is not null and add_blob_25 is not null and add_int_26 is not null and 
add_varchar2_26 is not null and add_varchar_26 is not null and add_clob_26 is not null and add_blob_26 is not null and add_int_27 is not null and add_varchar2_27 is not null and add_varchar_27 is not null and 
add_clob_27 is not null and add_blob_27 is not null and add_int_28 is not null and add_varchar2_28 is not null and add_varchar_28 is not null and add_clob_28 is not null and add_blob_28 is not null and 
add_int_29 is not null and add_varchar2_29 is not null and add_varchar_29 is not null and add_clob_29 is not null and add_blob_29 is not null and add_int_30 is not null and add_varchar2_30 is not null and 
add_varchar_30 is not null and add_clob_30 is not null and add_blob_30 is not null and add_int_31 is not null and add_varchar2_31 is not null and add_varchar_31 is not null and add_clob_31 is not null and 
add_blob_31 is not null and add_int_32 is not null and add_varchar2_32 is not null and add_varchar_32 is not null and add_clob_32 is not null and add_blob_32 is not null and add_int_33 is not null and 
add_varchar2_33 is not null and add_varchar_33 is not null and add_clob_33 is not null and add_blob_33 is not null and add_int_34 is not null and add_varchar2_34 is not null and add_varchar_34 is not null and 
add_clob_34 is not null and add_blob_34 is not null and add_int_35 is not null and add_varchar2_35 is not null and add_varchar_35 is not null and add_clob_35 is not null and add_blob_35 is not null and 
add_int_36 is not null and add_varchar2_36 is not null and add_varchar_36 is not null and add_clob_36 is not null and add_blob_36 is not null and add_int_37 is not null and add_varchar2_37 is not null and 
add_varchar_37 is not null and add_clob_37 is not null and add_blob_37 is not null and add_int_38 is not null and add_varchar2_38 is not null and add_varchar_38 is not null and add_clob_38 is not null and 
add_blob_38 is not null and add_int_39 is not null and add_varchar2_39 is not null and add_varchar_39 is not null and add_clob_39 is not null and add_blob_39 is not null and add_int_40 is not null and 
add_varchar2_40 is not null and add_varchar_40 is not null and add_clob_40 is not null and add_blob_40 is not null and add_int_41 is not null and add_varchar2_41 is not null and add_varchar_41 is not null and 
add_clob_41 is not null and add_blob_41 is not null and add_int_42 is not null and add_varchar2_42 is not null and add_varchar_42 is not null and add_clob_42 is not null and add_blob_42 is not null and 
add_int_43 is not null and add_varchar2_43 is not null and add_varchar_43 is not null and add_clob_43 is not null and add_blob_43 is not null and add_int_44 is not null and add_varchar2_44 is not null and 
add_varchar_44 is not null and add_clob_44 is not null and add_blob_44 is not null and add_int_45 is not null and add_varchar2_45 is not null and add_varchar_45 is not null and add_clob_45 is not null and 
add_blob_45 is not null and add_int_46 is not null and add_varchar2_46 is not null and add_varchar_46 is not null and add_clob_46 is not null and add_blob_46 is not null and add_int_47 is not null and 
add_varchar2_47 is not null and add_varchar_47 is not null and add_clob_47 is not null and add_blob_47 is not null and add_int_48 is not null and add_varchar2_48 is not null and 
add_varchar_48 is not null and add_clob_48 is not null and add_blob_48 is not null and add_int_49 is not null and add_varchar2_49 is not null and add_varchar_49 is not null and 
add_clob_49 is not null and add_blob_49 is not null and add_int_50 is not null and add_varchar2_50 is not null and add_varchar_50 is not null and add_clob_50 is not null and add_blob_50 is not null and
c_id is not null and c_d_id is not null and c_w_id is not null and c_first is not null and 
c_middle is not null and c_last is not null and c_street_1 is not null and c_street_2 is not null and c_city is not null and c_state is not null and 
c_zip is not null and c_phone is not null and c_since is not null and c_credit is not null and c_credit_lim is not null and c_discount is not null and 
c_balance is not null and c_end is not null and c_data1 is not null and c_data2 is not null and c_data3 is not null and c_data4 is not null and c_data5 is not null 
and c_data6 is not null and c_data7 is not null and c_data8 is not null and c_clob is not null and c_blob is not null and column_int is not null and column_bigint is not null and 
column_tinyint is not null and column_float is not null and column_double is not null and column_decimal is not null and column_number is not null and column_numeric is not null and 
column_char is not null and column_varchar is not null and column_varchar2 is not null and column_binary is not null and column_varbinary is not null and column_date is not null and 
column_timestamp is not null and add_int_0 is not null and add_varchar2_0 is not null and add_varchar_0 is not null and add_clob_0 is not null and add_blob_0 is not null and add_int_1 is not null and 
add_varchar2_1 is not null and add_varchar_1 is not null and add_clob_1 is not null and add_blob_1 is not null and add_int_2 is not null and add_varchar2_2 is not null and add_varchar_2 is not null and 
add_clob_2 is not null and add_blob_2 is not null and add_int_3 is not null and add_varchar2_3 is not null and add_varchar_3 is not null and add_clob_3 is not null and add_blob_3 is not null and add_int_4 is not null and 
add_varchar2_4 is not null and add_varchar_4 is not null and add_clob_4 is not null and add_blob_4 is not null and add_int_5 is not null and add_varchar2_5 is not null and add_varchar_5 is not null and add_clob_5 is not null and 
add_blob_5 is not null and add_int_6 is not null and add_varchar2_6 is not null and add_varchar_6 is not null and add_clob_6 is not null and add_blob_6 is not null and add_int_7 is not null and add_varchar2_7 is not null and 
add_varchar_7 is not null and add_clob_7 is not null and add_blob_7 is not null and add_int_8 is not null and add_varchar2_8 is not null and add_varchar_8 is not null and add_clob_8 is not null and add_blob_8 is not null and 
add_int_9 is not null and add_varchar2_9 is not null and add_varchar_9 is not null and add_clob_9 is not null and add_blob_9 is not null and add_int_10 is not null and add_varchar2_10 is not null and add_varchar_10 is not null and 
add_clob_10 is not null and add_blob_10 is not null and add_int_11 is not null and add_varchar2_11 is not null and add_varchar_11 is not null and add_clob_11 is not null and add_blob_11 is not null and add_int_12 is not null and 
add_varchar2_12 is not null and add_varchar_12 is not null and add_clob_12 is not null and add_blob_12 is not null and add_int_13 is not null and add_varchar2_13 is not null and add_varchar_13 is not null and 
add_clob_13 is not null and add_blob_13 is not null and add_int_14 is not null and add_varchar2_14 is not null and add_varchar_14 is not null and add_clob_14 is not null and add_blob_14 is not null and 
add_int_15 is not null and add_varchar2_15 is not null and add_varchar_15 is not null and add_clob_15 is not null and add_blob_15 is not null and add_int_16 is not null and add_varchar2_16 is not null and 
add_varchar_16 is not null and add_clob_16 is not null and add_blob_16 is not null and add_int_17 is not null and add_varchar2_17 is not null and add_varchar_17 is not null and add_clob_17 is not null and 
add_blob_17 is not null and add_int_18 is not null and add_varchar2_18 is not null and add_varchar_18 is not null and add_clob_18 is not null and add_blob_18 is not null and add_int_19 is not null and 
add_varchar2_19 is not null and add_varchar_19 is not null and add_clob_19 is not null and add_blob_19 is not null and add_int_20 is not null and add_varchar2_20 is not null and add_varchar_20 is not null and 
add_clob_20 is not null and add_blob_20 is not null and add_int_21 is not null and add_varchar2_21 is not null and add_varchar_21 is not null and add_clob_21 is not null and add_blob_21 is not null and 
add_int_22 is not null and add_varchar2_22 is not null and add_varchar_22 is not null and add_clob_22 is not null and add_blob_22 is not null and add_int_23 is not null and add_varchar2_23 is not null and 
add_varchar_23 is not null and add_clob_23 is not null and add_blob_23 is not null and add_int_24 is not null and add_varchar2_24 is not null and add_varchar_24 is not null and add_clob_24 is not null and 
add_blob_24 is not null and add_int_25 is not null and add_varchar2_25 is not null and add_varchar_25 is not null and add_clob_25 is not null and add_blob_25 is not null and add_int_26 is not null and 
add_varchar2_26 is not null and add_varchar_26 is not null and add_clob_26 is not null and add_blob_26 is not null and add_int_27 is not null and add_varchar2_27 is not null and add_varchar_27 is not null and 
add_clob_27 is not null and add_blob_27 is not null and add_int_28 is not null and add_varchar2_28 is not null and add_varchar_28 is not null and add_clob_28 is not null and add_blob_28 is not null and 
add_int_29 is not null and add_varchar2_29 is not null and add_varchar_29 is not null and add_clob_29 is not null and add_blob_29 is not null and add_int_30 is not null and add_varchar2_30 is not null and 
add_varchar_30 is not null and add_clob_30 is not null and add_blob_30 is not null and add_int_31 is not null and add_varchar2_31 is not null and add_varchar_31 is not null and add_clob_31 is not null and 
add_blob_31 is not null and add_int_32 is not null and add_varchar2_32 is not null and add_varchar_32 is not null and add_clob_32 is not null and add_blob_32 is not null and add_int_33 is not null and 
add_varchar2_33 is not null and add_varchar_33 is not null and add_clob_33 is not null and add_blob_33 is not null and add_int_34 is not null and add_varchar2_34 is not null and add_varchar_34 is not null and 
add_clob_34 is not null and add_blob_34 is not null and add_int_35 is not null and add_varchar2_35 is not null and add_varchar_35 is not null and add_clob_35 is not null and add_blob_35 is not null and 
add_int_36 is not null and add_varchar2_36 is not null and add_varchar_36 is not null and add_clob_36 is not null and add_blob_36 is not null and add_int_37 is not null and add_varchar2_37 is not null and 
add_varchar_37 is not null and add_clob_37 is not null and add_blob_37 is not null and add_int_38 is not null and add_varchar2_38 is not null and add_varchar_38 is not null and add_clob_38 is not null and 
add_blob_38 is not null and add_int_39 is not null and add_varchar2_39 is not null and add_varchar_39 is not null and add_clob_39 is not null and add_blob_39 is not null and add_int_40 is not null and 
add_varchar2_40 is not null and add_varchar_40 is not null and add_clob_40 is not null and add_blob_40 is not null and add_int_41 is not null and add_varchar2_41 is not null and add_varchar_41 is not null and 
add_clob_41 is not null and add_blob_41 is not null and add_int_42 is not null and add_varchar2_42 is not null and add_varchar_42 is not null and add_clob_42 is not null and add_blob_42 is not null and 
add_int_43 is not null and add_varchar2_43 is not null and add_varchar_43 is not null and add_clob_43 is not null and add_blob_43 is not null and add_int_44 is not null and add_varchar2_44 is not null and 
add_varchar_44 is not null and add_clob_44 is not null and add_blob_44 is not null and add_int_45 is not null and add_varchar2_45 is not null and add_varchar_45 is not null and add_clob_45 is not null and 
add_blob_45 is not null and add_int_46 is not null and add_varchar2_46 is not null and add_varchar_46 is not null and add_clob_46 is not null and add_blob_46 is not null and add_int_47 is not null and 
add_varchar2_47 is not null and add_varchar_47 is not null and add_clob_47 is not null and add_blob_47 is not null and add_int_48 is not null and add_varchar2_48 is not null and 
add_varchar_48 is not null and add_clob_48 is not null and add_blob_48 is not null and add_int_49 is not null and add_varchar2_49 is not null and add_varchar_49 is not null and 
add_clob_49 is not null and add_blob_49 is not null and add_int_50 is not null and add_varchar2_50 is not null and add_varchar_50 is not null and add_clob_50 is not null and add_blob_50 is not null;

drop sql_map(select count(*) from oracle_test_tbl_001 where c_id is not null and c_d_id is not null and c_w_id is not null and c_first is not null and 
c_middle is not null and c_last is not null and c_street_1 is not null and c_street_2 is not null and c_city is not null and c_state is not null and 
c_zip is not null and c_phone is not null and c_since is not null and c_credit is not null and c_credit_lim is not null and c_discount is not null and 
c_balance is not null and c_end is not null and c_data1 is not null and c_data2 is not null and c_data3 is not null and c_data4 is not null and c_data5 is not null 
and c_data6 is not null and c_data7 is not null and c_data8 is not null and c_clob is not null and c_blob is not null and column_int is not null and column_bigint is not null and 
column_tinyint is not null and column_float is not null and column_double is not null and column_decimal is not null and column_number is not null and column_numeric is not null and 
column_char is not null and column_varchar is not null and column_varchar2 is not null and column_binary is not null and column_varbinary is not null and column_date is not null and 
column_timestamp is not null and add_int_0 is not null and add_varchar2_0 is not null and add_varchar_0 is not null and add_clob_0 is not null and add_blob_0 is not null and add_int_1 is not null and 
add_varchar2_1 is not null and add_varchar_1 is not null and add_clob_1 is not null and add_blob_1 is not null and add_int_2 is not null and add_varchar2_2 is not null and add_varchar_2 is not null and 
add_clob_2 is not null and add_blob_2 is not null and add_int_3 is not null and add_varchar2_3 is not null and add_varchar_3 is not null and add_clob_3 is not null and add_blob_3 is not null and add_int_4 is not null and 
add_varchar2_4 is not null and add_varchar_4 is not null and add_clob_4 is not null and add_blob_4 is not null and add_int_5 is not null and add_varchar2_5 is not null and add_varchar_5 is not null and add_clob_5 is not null and 
add_blob_5 is not null and add_int_6 is not null and add_varchar2_6 is not null and add_varchar_6 is not null and add_clob_6 is not null and add_blob_6 is not null and add_int_7 is not null and add_varchar2_7 is not null and 
add_varchar_7 is not null and add_clob_7 is not null and add_blob_7 is not null and add_int_8 is not null and add_varchar2_8 is not null and add_varchar_8 is not null and add_clob_8 is not null and add_blob_8 is not null and 
add_int_9 is not null and add_varchar2_9 is not null and add_varchar_9 is not null and add_clob_9 is not null and add_blob_9 is not null and add_int_10 is not null and add_varchar2_10 is not null and add_varchar_10 is not null and 
add_clob_10 is not null and add_blob_10 is not null and add_int_11 is not null and add_varchar2_11 is not null and add_varchar_11 is not null and add_clob_11 is not null and add_blob_11 is not null and add_int_12 is not null and 
add_varchar2_12 is not null and add_varchar_12 is not null and add_clob_12 is not null and add_blob_12 is not null and add_int_13 is not null and add_varchar2_13 is not null and add_varchar_13 is not null and 
add_clob_13 is not null and add_blob_13 is not null and add_int_14 is not null and add_varchar2_14 is not null and add_varchar_14 is not null and add_clob_14 is not null and add_blob_14 is not null and 
add_int_15 is not null and add_varchar2_15 is not null and add_varchar_15 is not null and add_clob_15 is not null and add_blob_15 is not null and add_int_16 is not null and add_varchar2_16 is not null and 
add_varchar_16 is not null and add_clob_16 is not null and add_blob_16 is not null and add_int_17 is not null and add_varchar2_17 is not null and add_varchar_17 is not null and add_clob_17 is not null and 
add_blob_17 is not null and add_int_18 is not null and add_varchar2_18 is not null and add_varchar_18 is not null and add_clob_18 is not null and add_blob_18 is not null and add_int_19 is not null and 
add_varchar2_19 is not null and add_varchar_19 is not null and add_clob_19 is not null and add_blob_19 is not null and add_int_20 is not null and add_varchar2_20 is not null and add_varchar_20 is not null and 
add_clob_20 is not null and add_blob_20 is not null and add_int_21 is not null and add_varchar2_21 is not null and add_varchar_21 is not null and add_clob_21 is not null and add_blob_21 is not null and 
add_int_22 is not null and add_varchar2_22 is not null and add_varchar_22 is not null and add_clob_22 is not null and add_blob_22 is not null and add_int_23 is not null and add_varchar2_23 is not null and 
add_varchar_23 is not null and add_clob_23 is not null and add_blob_23 is not null and add_int_24 is not null and add_varchar2_24 is not null and add_varchar_24 is not null and add_clob_24 is not null and 
add_blob_24 is not null and add_int_25 is not null and add_varchar2_25 is not null and add_varchar_25 is not null and add_clob_25 is not null and add_blob_25 is not null and add_int_26 is not null and 
add_varchar2_26 is not null and add_varchar_26 is not null and add_clob_26 is not null and add_blob_26 is not null and add_int_27 is not null and add_varchar2_27 is not null and add_varchar_27 is not null and 
add_clob_27 is not null and add_blob_27 is not null and add_int_28 is not null and add_varchar2_28 is not null and add_varchar_28 is not null and add_clob_28 is not null and add_blob_28 is not null and 
add_int_29 is not null and add_varchar2_29 is not null and add_varchar_29 is not null and add_clob_29 is not null and add_blob_29 is not null and add_int_30 is not null and add_varchar2_30 is not null and 
add_varchar_30 is not null and add_clob_30 is not null and add_blob_30 is not null and add_int_31 is not null and add_varchar2_31 is not null and add_varchar_31 is not null and add_clob_31 is not null and 
add_blob_31 is not null and add_int_32 is not null and add_varchar2_32 is not null and add_varchar_32 is not null and add_clob_32 is not null and add_blob_32 is not null and add_int_33 is not null and 
add_varchar2_33 is not null and add_varchar_33 is not null and add_clob_33 is not null and add_blob_33 is not null and add_int_34 is not null and add_varchar2_34 is not null and add_varchar_34 is not null and 
add_clob_34 is not null and add_blob_34 is not null and add_int_35 is not null and add_varchar2_35 is not null and add_varchar_35 is not null and add_clob_35 is not null and add_blob_35 is not null and 
add_int_36 is not null and add_varchar2_36 is not null and add_varchar_36 is not null and add_clob_36 is not null and add_blob_36 is not null and add_int_37 is not null and add_varchar2_37 is not null and 
add_varchar_37 is not null and add_clob_37 is not null and add_blob_37 is not null and add_int_38 is not null and add_varchar2_38 is not null and add_varchar_38 is not null and add_clob_38 is not null and 
add_blob_38 is not null and add_int_39 is not null and add_varchar2_39 is not null and add_varchar_39 is not null and add_clob_39 is not null and add_blob_39 is not null and add_int_40 is not null and 
add_varchar2_40 is not null and add_varchar_40 is not null and add_clob_40 is not null and add_blob_40 is not null and add_int_41 is not null and add_varchar2_41 is not null and add_varchar_41 is not null and 
add_clob_41 is not null and add_blob_41 is not null and add_int_42 is not null and add_varchar2_42 is not null and add_varchar_42 is not null and add_clob_42 is not null and add_blob_42 is not null and 
add_int_43 is not null and add_varchar2_43 is not null and add_varchar_43 is not null and add_clob_43 is not null and add_blob_43 is not null and add_int_44 is not null and add_varchar2_44 is not null and 
add_varchar_44 is not null and add_clob_44 is not null and add_blob_44 is not null and add_int_45 is not null and add_varchar2_45 is not null and add_varchar_45 is not null and add_clob_45 is not null and 
add_blob_45 is not null and add_int_46 is not null and add_varchar2_46 is not null and add_varchar_46 is not null and add_clob_46 is not null and add_blob_46 is not null and add_int_47 is not null and 
add_varchar2_47 is not null and add_varchar_47 is not null and add_clob_47 is not null and add_blob_47 is not null and add_int_48 is not null and add_varchar2_48 is not null and 
add_varchar_48 is not null and add_clob_48 is not null and add_blob_48 is not null and add_int_49 is not null and add_varchar2_49 is not null and add_varchar_49 is not null and 
add_clob_49 is not null and add_blob_49 is not null and add_int_50 is not null and add_varchar2_50 is not null and add_varchar_50 is not null and add_clob_50 is not null and add_blob_50 is not null and
c_id is not null and c_d_id is not null and c_w_id is not null and c_first is not null and 
c_middle is not null and c_last is not null and c_street_1 is not null and c_street_2 is not null and c_city is not null and c_state is not null and 
c_zip is not null and c_phone is not null and c_since is not null and c_credit is not null and c_credit_lim is not null and c_discount is not null and 
c_balance is not null and c_end is not null and c_data1 is not null and c_data2 is not null and c_data3 is not null and c_data4 is not null and c_data5 is not null 
and c_data6 is not null and c_data7 is not null and c_data8 is not null and c_clob is not null and c_blob is not null and column_int is not null and column_bigint is not null and 
column_tinyint is not null and column_float is not null and column_double is not null and column_decimal is not null and column_number is not null and column_numeric is not null and 
column_char is not null and column_varchar is not null and column_varchar2 is not null and column_binary is not null and column_varbinary is not null and column_date is not null and 
column_timestamp is not null and add_int_0 is not null and add_varchar2_0 is not null and add_varchar_0 is not null and add_clob_0 is not null and add_blob_0 is not null and add_int_1 is not null and 
add_varchar2_1 is not null and add_varchar_1 is not null and add_clob_1 is not null and add_blob_1 is not null and add_int_2 is not null and add_varchar2_2 is not null and add_varchar_2 is not null and 
add_clob_2 is not null and add_blob_2 is not null and add_int_3 is not null and add_varchar2_3 is not null and add_varchar_3 is not null and add_clob_3 is not null and add_blob_3 is not null and add_int_4 is not null and 
add_varchar2_4 is not null and add_varchar_4 is not null and add_clob_4 is not null and add_blob_4 is not null and add_int_5 is not null and add_varchar2_5 is not null and add_varchar_5 is not null and add_clob_5 is not null and 
add_blob_5 is not null and add_int_6 is not null and add_varchar2_6 is not null and add_varchar_6 is not null and add_clob_6 is not null and add_blob_6 is not null and add_int_7 is not null and add_varchar2_7 is not null and 
add_varchar_7 is not null and add_clob_7 is not null and add_blob_7 is not null and add_int_8 is not null and add_varchar2_8 is not null and add_varchar_8 is not null and add_clob_8 is not null and add_blob_8 is not null and 
add_int_9 is not null and add_varchar2_9 is not null and add_varchar_9 is not null and add_clob_9 is not null and add_blob_9 is not null and add_int_10 is not null and add_varchar2_10 is not null and add_varchar_10 is not null and 
add_clob_10 is not null and add_blob_10 is not null and add_int_11 is not null and add_varchar2_11 is not null and add_varchar_11 is not null and add_clob_11 is not null and add_blob_11 is not null and add_int_12 is not null and 
add_varchar2_12 is not null and add_varchar_12 is not null and add_clob_12 is not null and add_blob_12 is not null and add_int_13 is not null and add_varchar2_13 is not null and add_varchar_13 is not null and 
add_clob_13 is not null and add_blob_13 is not null and add_int_14 is not null and add_varchar2_14 is not null and add_varchar_14 is not null and add_clob_14 is not null and add_blob_14 is not null and 
add_int_15 is not null and add_varchar2_15 is not null and add_varchar_15 is not null and add_clob_15 is not null and add_blob_15 is not null and add_int_16 is not null and add_varchar2_16 is not null and 
add_varchar_16 is not null and add_clob_16 is not null and add_blob_16 is not null and add_int_17 is not null and add_varchar2_17 is not null and add_varchar_17 is not null and add_clob_17 is not null and 
add_blob_17 is not null and add_int_18 is not null and add_varchar2_18 is not null and add_varchar_18 is not null and add_clob_18 is not null and add_blob_18 is not null and add_int_19 is not null and 
add_varchar2_19 is not null and add_varchar_19 is not null and add_clob_19 is not null and add_blob_19 is not null and add_int_20 is not null and add_varchar2_20 is not null and add_varchar_20 is not null and 
add_clob_20 is not null and add_blob_20 is not null and add_int_21 is not null and add_varchar2_21 is not null and add_varchar_21 is not null and add_clob_21 is not null and add_blob_21 is not null and 
add_int_22 is not null and add_varchar2_22 is not null and add_varchar_22 is not null and add_clob_22 is not null and add_blob_22 is not null and add_int_23 is not null and add_varchar2_23 is not null and 
add_varchar_23 is not null and add_clob_23 is not null and add_blob_23 is not null and add_int_24 is not null and add_varchar2_24 is not null and add_varchar_24 is not null and add_clob_24 is not null and 
add_blob_24 is not null and add_int_25 is not null and add_varchar2_25 is not null and add_varchar_25 is not null and add_clob_25 is not null and add_blob_25 is not null and add_int_26 is not null and 
add_varchar2_26 is not null and add_varchar_26 is not null and add_clob_26 is not null and add_blob_26 is not null and add_int_27 is not null and add_varchar2_27 is not null and add_varchar_27 is not null and 
add_clob_27 is not null and add_blob_27 is not null and add_int_28 is not null and add_varchar2_28 is not null and add_varchar_28 is not null and add_clob_28 is not null and add_blob_28 is not null and 
add_int_29 is not null and add_varchar2_29 is not null and add_varchar_29 is not null and add_clob_29 is not null and add_blob_29 is not null and add_int_30 is not null and add_varchar2_30 is not null and 
add_varchar_30 is not null and add_clob_30 is not null and add_blob_30 is not null and add_int_31 is not null and add_varchar2_31 is not null and add_varchar_31 is not null and add_clob_31 is not null and 
add_blob_31 is not null and add_int_32 is not null and add_varchar2_32 is not null and add_varchar_32 is not null and add_clob_32 is not null and add_blob_32 is not null and add_int_33 is not null and 
add_varchar2_33 is not null and add_varchar_33 is not null and add_clob_33 is not null and add_blob_33 is not null and add_int_34 is not null and add_varchar2_34 is not null and add_varchar_34 is not null and 
add_clob_34 is not null and add_blob_34 is not null and add_int_35 is not null and add_varchar2_35 is not null and add_varchar_35 is not null and add_clob_35 is not null and add_blob_35 is not null and 
add_int_36 is not null and add_varchar2_36 is not null and add_varchar_36 is not null and add_clob_36 is not null and add_blob_36 is not null and add_int_37 is not null and add_varchar2_37 is not null and 
add_varchar_37 is not null and add_clob_37 is not null and add_blob_37 is not null and add_int_38 is not null and add_varchar2_38 is not null and add_varchar_38 is not null and add_clob_38 is not null and 
add_blob_38 is not null and add_int_39 is not null and add_varchar2_39 is not null and add_varchar_39 is not null and add_clob_39 is not null and add_blob_39 is not null and add_int_40 is not null and 
add_varchar2_40 is not null and add_varchar_40 is not null and add_clob_40 is not null and add_blob_40 is not null and add_int_41 is not null and add_varchar2_41 is not null and add_varchar_41 is not null and 
add_clob_41 is not null and add_blob_41 is not null and add_int_42 is not null and add_varchar2_42 is not null and add_varchar_42 is not null and add_clob_42 is not null and add_blob_42 is not null and 
add_int_43 is not null and add_varchar2_43 is not null and add_varchar_43 is not null and add_clob_43 is not null and add_blob_43 is not null and add_int_44 is not null and add_varchar2_44 is not null and 
add_varchar_44 is not null and add_clob_44 is not null and add_blob_44 is not null and add_int_45 is not null and add_varchar2_45 is not null and add_varchar_45 is not null and add_clob_45 is not null and 
add_blob_45 is not null and add_int_46 is not null and add_varchar2_46 is not null and add_varchar_46 is not null and add_clob_46 is not null and add_blob_46 is not null and add_int_47 is not null and 
add_varchar2_47 is not null and add_varchar_47 is not null and add_clob_47 is not null and add_blob_47 is not null and add_int_48 is not null and add_varchar2_48 is not null and 
add_varchar_48 is not null and add_clob_48 is not null and add_blob_48 is not null and add_int_49 is not null and add_varchar2_49 is not null and add_varchar_49 is not null and 
add_clob_49 is not null and add_blob_49 is not null and add_int_50 is not null and add_varchar2_50 is not null and add_varchar_50 is not null and add_clob_50 is not null and add_blob_50 is not null);

alter system set enable_sql_map=false;
drop table oracle_test_tbl_001;

-- DTS202006010P5KBSP0D00
show parameter MAX_SQL_MAP_PER_USER
alter system set MAX_SQL_MAP_PER_USER = 5;
alter system set enable_sql_map = true;
drop user if exists sql_map_user3 cascade;
create user sql_map_user3 identified by Changeme_123;
grant create session to sql_map_user3;
grant create table to sql_map_user3;
select count(*) from sys_sql_maps;
conn sql_map_user3/Changeme_123@127.0.0.1:1611
alter SQL_MAP (insert into t1 values(1)) REWRITE TO (insert into t0 values(1));
alter SQL_MAP (insert into t2 values(1)) REWRITE TO (insert into t0 values(1));
alter SQL_MAP (insert into t3 values(1)) REWRITE TO (insert into t0 values(1));
alter SQL_MAP (insert into t4 values(1)) REWRITE TO (insert into t0 values(1));
alter SQL_MAP (insert into t5 values(1)) REWRITE TO (insert into t0 values(1));
conn sys/Huawei@123@127.0.0.1:1611
select count(*) from sys_sql_maps;
conn sql_map_user3/Changeme_123@127.0.0.1:1611
alter SQL_MAP (insert into t6 values(1)) REWRITE TO (insert into t0 values(1));
drop SQL_MAP IF EXISTS (insert into t1 values(1));
drop SQL_MAP IF EXISTS (insert into t2 values(1));
drop SQL_MAP IF EXISTS (insert into t3 values(1));
drop SQL_MAP IF EXISTS (insert into t4 values(1));
drop SQL_MAP IF EXISTS (insert into t5 values(1));
conn sys/Huawei@123@127.0.0.1:1611
select count(*) from sys_sql_maps;
drop user sql_map_user3 cascade;
alter system set enable_sql_map = false;
alter system set MAX_SQL_MAP_PER_USER = 100;