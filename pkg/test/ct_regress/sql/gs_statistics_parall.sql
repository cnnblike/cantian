alter system set STATS_ENABLE_PARALL = TRUE;
drop table if exists test_statistics_1;

create table test_statistics_1 (a int);

insert into test_statistics_1 values(1);
insert into test_statistics_1 (a) select a + 1 from test_statistics_1;
insert into test_statistics_1 (a) select a + 2 from test_statistics_1;
insert into test_statistics_1 (a) select a + 4 from test_statistics_1;
insert into test_statistics_1 (a) select a + 8 from test_statistics_1;
insert into test_statistics_1 (a) select a + 16 from test_statistics_1;
insert into test_statistics_1 (a) select a + 32 from test_statistics_1;
insert into test_statistics_1 (a) select a + 64 from test_statistics_1;
commit;

analyze table test_statistics_1 compute statistics;
select NUM_DISTINCT, NUM_NULLS, HISTOGRAM from dba_tab_columns where TABLE_NAME = 'TEST_STATISTICS_1';

insert into test_statistics_1 (a) select a + 128 from test_statistics_1;
commit;

analyze table test_statistics_1 compute statistics;
select NUM_DISTINCT, NUM_NULLS, HISTOGRAM from dba_tab_columns where TABLE_NAME = 'TEST_STATISTICS_1';

create user hzy_analy identified by Cantian_234;
GRANT CREATE SESSION TO hzy_analy;
grant dba to hzy_analy;
grant create table to hzy_analy;

create table hzy_analy.t0(a int, b clob);
create table hzy_analy.t1(a int, b clob);
create table hzy_analy.t2(a int, b clob);
create table hzy_analy.t3(a int, b clob);
create table hzy_analy.t4(a int, b clob);
create table hzy_analy.t5(a int, b clob);
create table hzy_analy.t6(a int, b clob);
create table hzy_analy.t7(a int, b clob);
create table hzy_analy.t8(a int, b clob);
create table hzy_analy.t9(a int, b clob);
create table hzy_analy.t10(a int, b clob);
create table hzy_analy.t11(a int, b clob);
create table hzy_analy.t12(a int, b clob);
create table hzy_analy.t13(a int, b clob);
create table hzy_analy.t14(a int, b clob);
create table hzy_analy.t15(a int, b clob);
create table hzy_analy.t16(a int, b clob);
create table hzy_analy.t17(a int, b clob);
create table hzy_analy.t18(a int, b clob);
create table hzy_analy.t19(a int, b clob);
create table hzy_analy.t20(a int, b clob);
create table hzy_analy.t21(a int, b clob);
create table hzy_analy.t22(a int, b clob);
create table hzy_analy.t23(a int, b clob);
create table hzy_analy.t24(a int, b clob);
create table hzy_analy.t25(a int, b clob);
create table hzy_analy.t26(a int, b clob);
create table hzy_analy.t27(a int, b clob);
create table hzy_analy.t28(a int, b clob);
create table hzy_analy.t29(a int, b clob);
create table hzy_analy.t30(a int, b clob);
create table hzy_analy.t31(a int, b clob);
create table hzy_analy.t32(a int, b clob);
create table hzy_analy.t33(a int, b clob);
create table hzy_analy.t34(a int, b clob);
exec DBE_STATS.COLLECT_SCHEMA_STATS('hzy_analy');

insert into  hzy_analy.t0 values(1,'a');
insert into  hzy_analy.t1 values(1,'a');
insert into  hzy_analy.t2 values(1,'a');
insert into  hzy_analy.t3 values(1,'a');
insert into  hzy_analy.t4 values(1,'a');
insert into  hzy_analy.t4 values(1,'a');
insert into  hzy_analy.t5 values(1,'a');
insert into  hzy_analy.t6 values(1,'a');
insert into  hzy_analy.t7 values(1,'a');
insert into  hzy_analy.t8 values(1,'a');
insert into  hzy_analy.t9 values(1,'a');
insert into  hzy_analy.t10 values(1,'a');
insert into  hzy_analy.t11 values(1,'a');
insert into  hzy_analy.t12 values(1,'a');
insert into  hzy_analy.t13 values(1,'a');
insert into  hzy_analy.t14 values(1,'a');
insert into  hzy_analy.t15 values(1,'a');
insert into  hzy_analy.t16 values(1,'a');
insert into  hzy_analy.t17 values(1,'a');
insert into  hzy_analy.t18 values(1,'a');
insert into  hzy_analy.t19 values(1,'a');
insert into  hzy_analy.t20 values(1,'a');
insert into  hzy_analy.t21 values(1,'a');
insert into  hzy_analy.t22 values(1,'a');
insert into  hzy_analy.t23 values(1,'a');
insert into  hzy_analy.t24 values(1,'a');
insert into  hzy_analy.t25 values(1,'a');
insert into  hzy_analy.t26 values(1,'a');
insert into  hzy_analy.t27 values(1,'a');
insert into  hzy_analy.t28 values(1,'a');
insert into  hzy_analy.t29 values(1,'a');
insert into  hzy_analy.t30 values(1,'a');
insert into  hzy_analy.t31 values(1,'a');
insert into  hzy_analy.t32 values(1,'a');
insert into  hzy_analy.t33 values(1,'a');
insert into  hzy_analy.t34 values(1,'a');
exec DBE_STATS.COLLECT_SCHEMA_STATS('hzy_analy');
drop user hzy_analy cascade;

analyze table dba_tables compute statistics;

drop table if exists temp_table1;
create global temporary table temp_table1(a int);
analyze table temp_table1 compute statistics;
analyze table SYS_TABLES compute statistics;

alter system set LOCAL_TEMPORARY_TABLE_ENABLED=TRUE;
create temporary table #analyze_temp_tab(a int);
analyze table #analyze_temp_tab compute statistics;

drop table if exists test_statistics_2;
create table test_statistics_2 (id int, name varchar(20));
create index idx_statistics_2 on test_statistics_2(id);

insert into test_statistics_2 values(0, 'it is a long string');
insert into test_statistics_2 select id + 1, name from test_statistics_2;
insert into test_statistics_2 select id + 2, name from test_statistics_2;
insert into test_statistics_2 select id + 4, name from test_statistics_2;
insert into test_statistics_2 select id + 8, name from test_statistics_2;
insert into test_statistics_2 select id + 16, name from test_statistics_2;
insert into test_statistics_2 select id + 32, name from test_statistics_2;
insert into test_statistics_2 select id + 64, name from test_statistics_2;
insert into test_statistics_2 select id + 128, name from test_statistics_2;
insert into test_statistics_2 select id + 256, name from test_statistics_2;
insert into test_statistics_2 select id + 512, name from test_statistics_2;

exec dbe_stats.collect_table_stats('SYS','test_statistics_2', null, 80);
exec dbe_stats.collect_table_stats('SYS','test_statistics_2', null, 0.00001);
select count(*) from v$buffer_pool_statistics;
alter system flush buffer;
select count(*) from v$buffer_pool_statistics;
analyze index idx_statistics_2 on test_statistics_2 compute statistics;
select BLEVEL, LEVEL_BLOCKS, DISTINCT_KEYS, COMB_COLS_2_NDV, COMB_COLS_3_NDV, COMB_COLS_4_NDV from sys_indexes where name = upper('idx_statistics_2');
analyze index idx_statistics_2 on test_statistics_2 estimate statistics 80;

alter system set STATS_PARALL_THREADS = 4;
drop table if exists  LISTTABLE0020;
create table LISTTABLE0020(
field1   integer,
field2   bigint,
field3   real,
field4   decimal(10,2),
field5   number(6),
field6   char(10),
field7   varchar(10),
field8   varchar2(20),
field9   CLOB,
field10  BLOB,
field11  BINARY(1024),
field12 date,
field13 timestamp,
field14 INTERVAL DAY(3) TO SECOND(4),
field15 timestamp with time zone,
field16 timestamp,
field17 boolean,
field18  varbinary(1024),
field19  raw(1027)
)PARTITION BY LIST (field8)
(PARTITION  PART_HZY1 VALUES ('guangdong'), 
 PARTITION  part_hzy2 VALUES ('shanghai'), 
 PARTITION  part_hzy3 VALUES ('nanjing') 
);

declare
i int:=0;
begin
  loop
    i:=i+1;
insert into LISTTABLE0020  values(256,10000000,123.3212,123456.123,123456,'abc','dgr',
'guangdong',lpad('345abc',50,'abc'),lpad('345abc',50,'abc'),null,'2004-08-11 00:00:00',
'2012-11-11 00:00:00',interval '2' day,'2016-12-11 00:00:00','2011-12-11 00:00:00','true',null,null);
	exit when i= 100;
  end loop;
  dbe_output.print_line('111');
end;
/
commit;

declare
i int:=0;
begin
  loop
    i:=i+1;
insert into LISTTABLE0020  values(256,10000000,123.3212,123456.123,123456,'abc','dgr',
'shanghai',lpad('345abc',50,'abc'),lpad('345abc',50,'abc'),null,'2004-08-11 00:00:00',
'2012-11-11 00:00:00',interval '2' day,'2016-12-11 00:00:00','2011-12-11 00:00:00','true',null,null);
	exit when i= 100;
  end loop;
  dbe_output.print_line('111');
end;
/
commit;

declare
i int:=0;
begin
  loop
    i:=i+1;
insert into LISTTABLE0020  values(256,10000000,123.3212,123456.123,123456,'abc','dgr',
'nanjing',lpad('345abc',50,'abc'),lpad('345abc',50,'abc'),null,'2004-08-11 00:00:00',
'2012-11-11 00:00:00',interval '2' day,'2016-12-11 00:00:00','2011-12-11 00:00:00','true',null,null);
	exit when i= 100;
  end loop;
  dbe_output.print_line('111');
end;
/
commit;

exec dbe_stats.collect_table_stats('SYS', 'LISTTABLE0020', 'PART_HZY1');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'PART_HZY1' order by part#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'LISTTABLE0020') 
and SPARE1 = 10 order by col#;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'LISTTABLE0020') and part# = 10 order by BUCKET;

exec DBE_STATS.DELETE_TABLE_STATS('SYS', 'LISTTABLE0020', 'PART_HZY1');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'PART_HZY1';
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'LISTTABLE0020') 
and SPARE1 = 10 order by col#;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'LISTTABLE0020') and part# = 10 order by BUCKET;
exec DBE_STATS.DELETE_TABLE_STATS('SYS', 'LISTTABLE0020');

exec dbe_stats.collect_table_stats('SYS', 'LISTTABLE0020');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'PART_HZY1' order by part#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'LISTTABLE0020') 
and SPARE1 = 10 order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'LISTTABLE0020') 
and SPARE1 = 20 order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'LISTTABLE0020') 
and SPARE1 = 30 order by col#;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'LISTTABLE0020') and part# = 10 and col# = 1 order by BUCKET;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'LISTTABLE0020') and part# = 10 and col# = 2 order by BUCKET;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'LISTTABLE0020') and part# = 10 and col# = 3 order by BUCKET;
exec DBE_STATS.DELETE_TABLE_STATS('SYS', 'LISTTABLE0020');

select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'PART_HZY1' order by part#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'LISTTABLE0020') 
and SPARE1 = 10 order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'LISTTABLE0020') 
and SPARE1 = 20 order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'LISTTABLE0020') 
and SPARE1 = 30 order by col#;

drop table if exists stats_interval1;
create table stats_interval1(f1 int, f2 int, f3 char(30))
PARTITION BY RANGE(f2)
INTERVAL(5)
(
 PARTITION stats_interval1p1 values less than(10),
 PARTITION stats_interval1p2 values less than(20),
 PARTITION stats_interval1p3 values less than(30)
);
insert into stats_interval1 values(1,5,'hzy');
insert into stats_interval1 values(2,15,'hzy1');
insert into stats_interval1 values(3,25,'hzy2');
insert into stats_interval1 values(4,35,'hzy3');
insert into stats_interval1 values(5,115,'hzy66');
insert into stats_interval1 values(6,55,'6hzy');
insert into stats_interval1 values(7,65,'hezy');
insert into stats_interval1 values(8,75,'hzfdy');
insert into stats_interval1 values(9,85,'hzyf');
insert into stats_interval1 values(10,95,'hzyd');
insert into stats_interval1 values(11,105,'hzy');
insert into stats_interval1 select * from stats_interval1;
insert into stats_interval1 select * from stats_interval1;
commit;
exec dbe_stats.collect_table_stats('SYS', 'stats_interval1', 'STATS_INTERVAL1P2');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'STATS_INTERVAL1P2' order by part#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 20 order by col#;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') and part# = 20 order by BUCKET;

exec DBE_STATS.DELETE_TABLE_STATS('SYS', 'stats_interval1', 'STATS_INTERVAL1P2');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'STATS_INTERVAL1P2';
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 20 order by col#;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') and part# = 20 order by BUCKET;
exec DBE_STATS.DELETE_TABLE_STATS('SYS', 'stats_interval1');

exec dbe_stats.collect_table_stats('SYS', 'stats_interval1');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'STATS_INTERVAL1P2' order by part#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 20 order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 20 order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 30 order by col#;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') and part# = 20 and col# = 0 order by BUCKET;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') and part# = 20 and col# = 1 order by BUCKET;
exec DBE_STATS.DELETE_TABLE_STATS('SYS', 'stats_interval1');

select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'STATS_INTERVAL1P2' order by part#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 20 order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 20 order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 30 order by col#;

insert into stats_interval1 values(12,45,'hzy');
insert into stats_interval1 values(13,85,'hzyf');
insert into stats_interval1 values(14,95,'hzyd');
insert into stats_interval1 values(15,1105,'hzy');
insert into stats_interval1 values(16,445,'hzy');
insert into stats_interval1 values(17,215,'hzyf');
insert into stats_interval1 values(18,95,'hzyd');
insert into stats_interval1 values(19,105,'hzy');
insert into stats_interval1 values(20,45,'hzy');
insert into stats_interval1 select * from stats_interval1;
commit;

exec dbe_stats.collect_table_stats('SYS', 'STATS_INTERVAL1', 'STATS_INTERVAL1P2');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'STATS_INTERVAL1P2' order by part#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 20 order by col#;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') and part# = 20 order by BUCKET;

exec DBE_STATS.DELETE_TABLE_STATS('SYS', 'STATS_INTERVAL1', 'STATS_INTERVAL1P2');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'STATS_INTERVAL1P2';
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 20 order by col#;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') and part# = 20 order by BUCKET;
exec DBE_STATS.DELETE_TABLE_STATS('SYS', 'STATS_INTERVAL1');

exec dbe_stats.collect_table_stats('SYS', 'STATS_INTERVAL1');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'STATS_INTERVAL1P2' order by part#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 20 order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 20 order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 30 order by col#;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') and part# = 20 and col# = 0 order by BUCKET;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') and part# = 20 and col# = 1 order by BUCKET;
exec DBE_STATS.DELETE_TABLE_STATS('SYS', 'STATS_INTERVAL1');

select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'STATS_INTERVAL1P2' order by part#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 20 order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 20 order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL1') 
and SPARE1 = 30 order by col#;
drop table if exists STATS_INTERVAL1;

drop user if exists hzy_pstats cascade;
create user hzy_pstats identified by Cantian_234;

create table hzy_pstats.STATS_INTERVAL2(
c_id int,
c_d_id int NOT NULL,
c_w_id int NOT NULL,
c_first varchar(50) NOT NULL,
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
c_ytd_payment real NOT NULL,
c_payment_cnt number NOT NULL,
c_delivery_cnt bool NOT NULL,
c_end date NOT NULL,
c_data varchar(1000),
c_clob clob,
c_text blob) 
partition by range(c_id) 
(
   partition PART_H1 values less than (10),
   partition PART_H2 values less than (20),
   partition PART_H3 values less than (30),
   partition PART_H4 values less than (40),
   partition PART_5 values less than (50),
   partition PART_6 values less than (60),
   partition PART_7 values less than (70),
   partition PART_8 values less than (80),
   partition PART_9 values less than (90),
   partition PART_H10 values less than (maxvalue)
);

CREATE INDEX hzy_pstats.hzy_pstats_dml_range_indx_087 ON hzy_pstats.STATS_INTERVAL2(c_d_id,c_last) local;
CREATE INDEX hzy_pstats.hzy_pstats_dml_range_indx_088 ON hzy_pstats.STATS_INTERVAL2(c_w_id);
CREATE INDEX hzy_pstats.hzy_pstats_dml_range_indx_089 ON hzy_pstats.STATS_INTERVAL2(c_d_id, c_w_id, c_last);

CREATE or replace procedure hzy_pstats.lob_hzy_proc_1115(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from dual;
    insert into  hzy_pstats.STATS_INTERVAL2 select i,i,i,'is'||j||'cmRDs'||j,'OE','BAR'||j||'Bar'||j,'bkili'||j||'fcrRGF'||j,'pmbwo'||j||'vhSDGj'||j,'dyf'||j||'rDa'||j,'uq',4801||j,940||j||215||j,'2011-12-11 00:00:00','GC',50000.0,0.4361328,-10.0,10.0,1,true,'2011-12-11 00:00:00','dasd'||j,'dasdsd'||j,'\x1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323';
  END LOOP;
END;
/
call hzy_pstats.lob_hzy_proc_1115(1,20);
call hzy_pstats.lob_hzy_proc_1115(1,15);
call hzy_pstats.lob_hzy_proc_1115(10,30);
call hzy_pstats.lob_hzy_proc_1115(25,45);
call hzy_pstats.lob_hzy_proc_1115(50,100);
commit;

exec dbe_stats.collect_table_stats('hzy_pstats', 'STATS_INTERVAL2', 'PART_H1');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'PART_H1' AND USER# = ( SELECT ID FROM SYS_USERS WHERE NAME = 'HZY_PSTATS') order by part#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
and SPARE1 = 10 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS') order by col#;

exec DBE_STATS.DELETE_TABLE_STATS('hzy_pstats', 'STATS_INTERVAL2', 'PART_H1');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'PART_H1' AND USER# = ( SELECT ID FROM SYS_USERS WHERE NAME = 'HZY_PSTATS');
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
and SPARE1 = 10 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS') order by col#;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') and part# = 10 order by BUCKET;
exec DBE_STATS.DELETE_TABLE_STATS('hzy_pstats', 'STATS_INTERVAL2');

exec dbe_stats.collect_table_stats('hzy_pstats', 'STATS_INTERVAL2');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'PART_H1' AND USER# = ( SELECT ID FROM SYS_USERS WHERE NAME = 'HZY_PSTATS') order by part#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
and SPARE1 = 10 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS') order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
and SPARE1 = 20 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS') order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
and SPARE1 = 30 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS') order by col#;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') and part# = 20 and col# = 0 order by BUCKET;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') and part# = 20 and col# = 1 order by BUCKET;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') and part# = 20 and col# = 2 order by BUCKET;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') and part# = 20 and col# = 3 order by BUCKET;
exec DBE_STATS.DELETE_TABLE_STATS('hzy_pstats', 'STATS_INTERVAL2');

select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'PART_H1' AND USER# = ( SELECT ID FROM SYS_USERS WHERE NAME = 'HZY_PSTATS') order by part#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
and SPARE1 = 10 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS') order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
and SPARE1 = 20 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS') order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
and SPARE1 = 30 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS') order by col#;


exec dbe_stats.collect_table_stats('hzy_pstats', 'STATS_INTERVAL2');
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS') order by id;
select BLEVEL,LEVEL_BLOCKS,DISTKEY,LBLKKEY,DBLKKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS') and part# = 20 order by index#;
select BLEVEL,LEVEL_BLOCKS,DISTKEY,LBLKKEY,DBLKKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS') and part# = 30 order by index#;
select BLEVEL,LEVEL_BLOCKS,DISTKEY,LBLKKEY,DBLKKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS') and part# = 40 order by index#;

exec DBE_STATS.DELETE_TABLE_STATS('HZY_PSTATS', 'STATS_INTERVAL2');
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS') order by id;
select BLEVEL,LEVEL_BLOCKS,DISTKEY,LBLKKEY,DBLKKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS') and part# = 20 order by index#;
select BLEVEL,LEVEL_BLOCKS,DISTKEY,LBLKKEY,DBLKKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS') and part# = 30 order by index#;
select BLEVEL,LEVEL_BLOCKS,DISTKEY,LBLKKEY,DBLKKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS') and part# = 40 order by index#;

analyze index hzy_pstats.hzy_pstats_dml_range_indx_087 ON hzy_pstats.STATS_INTERVAL2 compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTKEY,LBLKKEY,DBLKKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL2')
AND index# = (select id from sys_indexes where name = upper('hzy_pstats_dml_range_indx_087')) order by part#;
analyze index hzy_pstats.hzy_pstats_dml_range_indx_088 ON hzy_pstats.STATS_INTERVAL2 compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where name = upper('hzy_pstats_dml_range_indx_088');
analyze index hzy_pstats.hzy_pstats_dml_range_indx_089 ON hzy_pstats.STATS_INTERVAL2 compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where name = upper('hzy_pstats_dml_range_indx_089');

analyze index hzy_pstats.hzy_pstats_dml_range_indx_087 ON hzy_pstats.STATS_INTERVAL2 estimate statistics 60;
analyze index hzy_pstats.hzy_pstats_dml_range_indx_088 ON hzy_pstats.STATS_INTERVAL2 estimate statistics 70;
analyze index hzy_pstats.hzy_pstats_dml_range_indx_089 ON hzy_pstats.STATS_INTERVAL2 estimate statistics 80;

drop user if exists HZY_PSTATS cascade;

alter system set default_extents = 32;
drop table if exists STATS_SPC_HASH1;
drop tablespace spc_hzystats9 including contents and datafiles;
CREATE TABLESPACE spc_hzystats9 datafile 'hzy_stats_part9' size 32M;
drop table if exists STATS_SPC_HASH1;

create table STATS_SPC_HASH1 (
c3 char(20) primary key,
c4 number(8) not null
)
partition by hash(c3)
(
partition PART_0H1 tablespace spc_hzystats9,
partition part_0h2 tablespace users,
partition part_0h3 tablespace spc_hzystats9
);

insert into STATS_SPC_HASH1 values('aaaa',111);
insert into STATS_SPC_HASH1 values('bbbb',111);
insert into STATS_SPC_HASH1 values('cccc',111);
insert into STATS_SPC_HASH1 values('dddd',111);
insert into STATS_SPC_HASH1 values('eeee',111);
insert into STATS_SPC_HASH1 values('ffff',111);
insert into STATS_SPC_HASH1 values('hhhh',111);
insert into STATS_SPC_HASH1 values('iiii',111);

create index idx_hash_part_t2 on STATS_SPC_HASH1(c3,c4) local;
exec dbe_stats.collect_table_stats('SYS', 'STATS_SPC_HASH1');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'PART_0H1' order by part#;
exec dbe_stats.collect_table_stats('SYS', 'STATS_SPC_HASH1','PART_0H1');
analyze index idx_hash_part_t2 on STATS_SPC_HASH1 compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTKEY,LBLKKEY,DBLKKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'STATS_SPC_HASH1')
AND index# = (select id from sys_indexes where name = upper('idx_hash_part_t2')) order by part#;
analyze index idx_hash_part_t2 on STATS_SPC_HASH1 estimate statistics 20;
drop table if exists STATS_SPC_HASH1;
drop tablespace spc_hzystats9 including contents and datafiles;
alter system set default_extents = 8;

drop user if exists HZY_PSTATS1 cascade;
create user HZY_PSTATS1 identified by Cantian_234;

create table HZY_PSTATS1.STATS_INTERVAL_NEW_1(
c_id int,
c_d_id int NOT NULL,
c_w_id int NOT NULL,
c_first varchar(50) NOT NULL,
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
c_ytd_payment real NOT NULL,
c_payment_cnt number NOT NULL,
c_delivery_cnt bool NOT NULL,
c_end date NOT NULL,
c_data varchar(1000),
c_clob clob,
c_text blob) 
partition by range(c_id)
interval(20) 
(
   partition PART_H1 values less than (10),
   partition PART_H2 values less than (20),
   partition PART_H3 values less than (30),
   partition PART_H4 values less than (40),
   partition PART_5 values less than (50),
   partition PART_6 values less than (60),
   partition PART_7 values less than (70),
   partition PART_8 values less than (80),
   partition PART_9 values less than (90)
);

CREATE INDEX HZY_PSTATS1.HZY_PSTATS1_dml_range_indx_087 ON HZY_PSTATS1.STATS_INTERVAL_NEW_1(c_d_id,c_last) local;
CREATE INDEX HZY_PSTATS1.HZY_PSTATS1_dml_range_indx_088 ON HZY_PSTATS1.STATS_INTERVAL_NEW_1(c_w_id);
CREATE INDEX HZY_PSTATS1.HZY_PSTATS1_dml_range_indx_089 ON HZY_PSTATS1.STATS_INTERVAL_NEW_1(c_d_id, c_w_id, c_last);

CREATE or replace procedure HZY_PSTATS1.lob_hzy_proc_1115(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from dual;
    insert into  HZY_PSTATS1.STATS_INTERVAL_NEW_1 select i,i,i,'is'||j||'cmRDs'||j,'OE','BAR'||j||'Bar'||j,'bkili'||j||'fcrRGF'||j,'pmbwo'||j||'vhSDGj'||j,'dyf'||j||'rDa'||j,'uq',4801||j,940||j||215||j,'2011-12-11 00:00:00','GC',50000.0,0.4361328,-10.0,10.0,1,true,'2011-12-11 00:00:00','dasd'||j,'dasdsd'||j,'\x1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323';
  END LOOP;
END;
/

call HZY_PSTATS1.lob_hzy_proc_1115(1001,1120);
call HZY_PSTATS1.lob_hzy_proc_1115(1,20);
call HZY_PSTATS1.lob_hzy_proc_1115(1,15);
call HZY_PSTATS1.lob_hzy_proc_1115(10,30);
call HZY_PSTATS1.lob_hzy_proc_1115(25,45);
call HZY_PSTATS1.lob_hzy_proc_1115(50,100);
commit;

exec dbe_stats.collect_table_stats('HZY_PSTATS1', 'STATS_INTERVAL_NEW_1', 'PART_H1');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'PART_H1' AND USER# = ( SELECT ID FROM SYS_USERS WHERE NAME = 'HZY_PSTATS1') order by part#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
and SPARE1 = 10 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') order by col#;

exec DBE_STATS.DELETE_TABLE_STATS('HZY_PSTATS1', 'STATS_INTERVAL_NEW_1', 'PART_H1');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'PART_H1' AND USER# = ( SELECT ID FROM SYS_USERS WHERE NAME = 'HZY_PSTATS1');
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
and SPARE1 = 10 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') order by col#;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') and part# = 10 order by BUCKET;
exec DBE_STATS.DELETE_TABLE_STATS('HZY_PSTATS1', 'STATS_INTERVAL_NEW_1');

exec dbe_stats.collect_table_stats('HZY_PSTATS1', 'STATS_INTERVAL_NEW_1');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'PART_H1' AND USER# = ( SELECT ID FROM SYS_USERS WHERE NAME = 'HZY_PSTATS1') order by part#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
and SPARE1 = 10 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
and SPARE1 = 20 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
and SPARE1 = 30 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') order by col#;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') and part# = 20 and col# = 0 order by BUCKET;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') and part# = 20 and col# = 1 order by BUCKET;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') and part# = 20 and col# = 2 order by BUCKET;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') and part# = 20 and col# = 3 order by BUCKET;
exec DBE_STATS.DELETE_TABLE_STATS('HZY_PSTATS1', 'STATS_INTERVAL_NEW_1');

select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS where name = 'PART_H1' AND USER# = ( SELECT ID FROM SYS_USERS WHERE NAME = 'HZY_PSTATS1') order by part#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
and SPARE1 = 10 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
and SPARE1 = 20 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') order by col#;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
and SPARE1 = 30 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') order by col#;


exec dbe_stats.collect_table_stats('HZY_PSTATS1', 'STATS_INTERVAL_NEW_1');
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS1') order by id;
select BLEVEL,LEVEL_BLOCKS,DISTKEY,LBLKKEY,DBLKKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS1') and part# = 20 order by index#;
select BLEVEL,LEVEL_BLOCKS,DISTKEY,LBLKKEY,DBLKKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS1') and part# = 30 order by index#;
select BLEVEL,LEVEL_BLOCKS,DISTKEY,LBLKKEY,DBLKKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS1') and part# = 40 order by index#;

exec DBE_STATS.DELETE_TABLE_STATS('HZY_PSTATS1', 'STATS_INTERVAL_NEW_1');
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS1') order by id;
select BLEVEL,LEVEL_BLOCKS,DISTKEY,LBLKKEY,DBLKKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS1') and part# = 20 order by index#;
select BLEVEL,LEVEL_BLOCKS,DISTKEY,LBLKKEY,DBLKKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS1') and part# = 30 order by index#;
select BLEVEL,LEVEL_BLOCKS,DISTKEY,LBLKKEY,DBLKKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW_1') 
AND USER# = (select id from SYS_USERS where name = 'HZY_PSTATS1') and part# = 40 order by index#;

create table HZY_PSTATS1.analyze_empty_table(a int, b int, c int, d int);
create index HZY_PSTATS1.analyze_empty_table_index on HZY_PSTATS1.analyze_empty_table(a, b ,c ,d);
insert into HZY_PSTATS1.analyze_empty_table values(1, 2, 3, 4);

declare
i int:=0;
begin
  loop
    i:=i+1;
    insert into HZY_PSTATS1.analyze_empty_table select a, b, c, d+1 from HZY_PSTATS1.analyze_empty_table;
	exit when i= 15;
  end loop;
end;
/
commit;

exec dbe_stats.collect_table_stats('HZY_PSTATS1','analyze_empty_table', null);
select DISTINCT_KEYS, COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV,blocks, SYS_INDEXES.NAME from SYS_INDEXES, SYS_TABLES where SYS_INDEXES.table# = SYS_TABLES.id and SYS_INDEXES.user# = SYS_TABLES.user# and SYS_INDEXES.name = 'ANALYZE_EMPTY_TABLE_INDEX';

delete from HZY_PSTATS1.analyze_empty_table;
analyze table HZY_PSTATS1.analyze_empty_table compute statistics;
drop table HZY_PSTATS1.analyze_empty_table;

drop table if exists HZY_PSTATS1.dsz;
create table HZY_PSTATS1.dsz(a int,b char(10));
create index HZY_PSTATS1.dsa_idx on HZY_PSTATS1.dsz(b);
create index HZY_PSTATS1.dsa_idx1 on HZY_PSTATS1.dsz(a);

insert into HZY_PSTATS1.dsz values(2,5);
analyze table HZY_PSTATS1.dsz compute statistics;
select a.BLEVEL,a.LEVEL_BLOCKS,a.DISTINCT_KEYS,a.AVG_LEAF_BLOCKS_PER_KEY,a.AVG_DATA_BLOCKS_PER_KEY,a.EMPTY_LEAF_BLOCKS,a.CLUFAC,a.SAMPLESIZE from SYS_INDEXES a,SYS_TABLES b where A.TABLE#=b.ID AND A.USER# = b.USER# AND b.NAME='DSZ';

drop user if exists HZY_PSTATS1 cascade;

drop table if exists hzy_test_comidx;
create table hzy_test_comidx(a int,b int,c int);
create index hzy_comidx1 on hzy_test_comidx(a);
create index hzy_comidx2 on hzy_test_comidx(a,b);
create index hzy_comidx3 on hzy_test_comidx(a,b,c);
insert into hzy_test_comidx values(1,2,3);
insert into hzy_test_comidx values(2,2,3);
insert into hzy_test_comidx values(3,2,3);
insert into hzy_test_comidx values(4,2,3);
insert into hzy_test_comidx values(6,2,3);
insert into hzy_test_comidx values(5,2,3);
insert into hzy_test_comidx values(7,2,3);
analyze table hzy_test_comidx compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV,samplesize from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_TEST_COMIDX') 
 order by id;
analyze index hzy_comidx1 on hzy_test_comidx compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where name = 'HZY_COMIDX1';
analyze index hzy_comidx2 on hzy_test_comidx compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where name = 'HZY_COMIDX2';
analyze index hzy_comidx3 on hzy_test_comidx compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where name = 'HZY_COMIDX3';
 
drop table if exists hzy_test_comidx;
create table hzy_test_comidx(a int,b int,c int);
create index hzy_comidx1 on hzy_test_comidx(a);
create index hzy_comidx2 on hzy_test_comidx(a,b);
create index hzy_comidx3 on hzy_test_comidx(a,b,c);
insert into hzy_test_comidx values(1,2,3);
insert into hzy_test_comidx values(2,3,4);
insert into hzy_test_comidx values(2,3,5);
insert into hzy_test_comidx values(2,3,6);
insert into hzy_test_comidx values(2,4,7);
insert into hzy_test_comidx values(5,5,8);
insert into hzy_test_comidx values(7,6,9);
analyze table hzy_test_comidx compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV,samplesize from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_TEST_COMIDX')
 order by id;
 
 
 drop table if exists hzy_test_comidx;
create table hzy_test_comidx(a int,b int,c int, d int, e int);
create index hzy_comidx1 on hzy_test_comidx(a);
create index hzy_comidx2 on hzy_test_comidx(a,b);
create index hzy_comidx3 on hzy_test_comidx(a,b,c);
create index hzy_comidx4 on hzy_test_comidx(a,b,c,d);
create index hzy_comidx5 on hzy_test_comidx(a,b,c,d,e);
insert into hzy_test_comidx values(1,2,3,null,4);
insert into hzy_test_comidx values(2,3,4,4,7);
insert into hzy_test_comidx values(2,3,5,8,90);
insert into hzy_test_comidx values(2,3,6,4,4);
insert into hzy_test_comidx values(2,4,7,4,null);
insert into hzy_test_comidx values(2,4,7,4,null);
insert into hzy_test_comidx values(2,3,6,4,4);
analyze table hzy_test_comidx compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV,samplesize from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_TEST_COMIDX') 
 order by id;

analyze index hzy_comidx1 on hzy_test_comidx compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where name = 'HZY_COMIDX1';
analyze index hzy_comidx2 on hzy_test_comidx compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where name = 'HZY_COMIDX2';
analyze index hzy_comidx3 on hzy_test_comidx compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where name = 'HZY_COMIDX3';
analyze index hzy_comidx4 on hzy_test_comidx compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where name = 'HZY_COMIDX4';
analyze index hzy_comidx5 on hzy_test_comidx compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where name = 'HZY_COMIDX5';

 drop table if exists hzy_high_hist;
drop table if exists high_hist;
create table high_hist(a int);
insert into high_hist values(0);
create table hzy_high_hist(a int);
CREATE or replace procedure storage_proc_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    insert into hzy_high_hist select a+i from high_hist;
  END LOOP;
END;
/
call storage_proc_000(1,1000);
call storage_proc_000(1,10);
call storage_proc_000(1,100);
call storage_proc_000(20,300);
commit;
analyze table hzy_high_hist compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST');

delete from hzy_high_hist where a < 800;
commit;
analyze table hzy_high_hist compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST');

call storage_proc_000(20,230);
commit;

analyze table hzy_high_hist compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST');

call storage_proc_000(20,253);
commit;

analyze table hzy_high_hist compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST');

call storage_proc_000(20,254);
commit;

analyze table hzy_high_hist compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST');

delete from hzy_high_hist where a < 990;
commit;

analyze table hzy_high_hist compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST');

delete from hzy_high_hist;
commit;

analyze table hzy_high_hist compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST');

drop table if exists hzy_high_hist;
drop table if exists high_hist;

drop table if exists hzy_high_hist;
drop table if exists high_hist;
create table high_hist(a int);
insert into high_hist values(0);
create table hzy_high_hist(a int)
partition by range(A)
interval(258)
(
   partition PART_H1 values less than (100),
   partition PART_H2 values less than (359),
   partition PART_H3 values less than (659)
);

CREATE or replace procedure storage_proc_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    insert into hzy_high_hist select a+i from high_hist;
  END LOOP;
END;
/
call storage_proc_000(1,1000);
call storage_proc_000(1,10);
call storage_proc_000(1,100);
call storage_proc_000(20,300);
commit;

exec dbe_stats.collect_table_stats('SYS', 'HZY_HIGH_HIST');
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') AND PART# = 10 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') AND PART# = 20 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') AND PART# = 30 order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY,SPARE1 from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST')
ORDER BY SPARE1;

delete from hzy_high_hist where a < 800;
commit;
exec dbe_stats.collect_table_stats('SYS', 'HZY_HIGH_HIST');
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') AND PART# = 10 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') AND PART# = 20 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') AND PART# = 30 order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY,SPARE1 from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST')
ORDER BY SPARE1;


call storage_proc_000(20,830);
commit;
exec dbe_stats.collect_table_stats('SYS', 'HZY_HIGH_HIST', 'PART_H3');
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') AND PART# = 10 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') AND PART# = 20 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') AND PART# = 30 order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY,SPARE1 from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST')
ORDER BY SPARE1;

delete from hzy_high_hist where a < 550;
commit;

exec dbe_stats.collect_table_stats('SYS', 'HZY_HIGH_HIST', 'PART_H3');
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') AND PART# = 10 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') AND PART# = 20 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') AND PART# = 30 order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY,SPARE1 from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST')
ORDER BY SPARE1;


delete from hzy_high_hist where a < 800;
commit;

exec dbe_stats.collect_table_stats('SYS', 'HZY_HIGH_HIST', 'PART_H3');
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') AND PART# = 30 order by endpoint;

drop table if exists hzy_high_hist;
drop table if exists high_hist;

drop table if exists FVT_PROC_1000_bingfa_Tab_000;
create table FVT_PROC_1000_bingfa_Tab_000(c_varchar varchar(100),c_int int,c_num number,c_clob clob,c_date date);
create index PROC_1000_bingfa_000_Idx_01 on FVT_PROC_1000_bingfa_Tab_000(c_int);
exec dbe_stats.collect_table_stats('sys','FVT_PROC_1000_BINGFA_TAB_000','partname',10,true);

--- statistics for all  index columns ----
DROP TABLE IF EXISTS STATS_INTERVAL_NEW;
drop user if exists HZY_PSTATS1 cascade;
create user HZY_PSTATS1 identified by Cantian_234;

create table HZY_PSTATS1.STATS_INTERVAL_NEW(
c_id int,
c_d_id int NOT NULL,
c_w_id int NOT NULL,
c_first varchar(50) NOT NULL,
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
c_ytd_payment real NOT NULL,
c_payment_cnt number NOT NULL,
c_delivery_cnt bool NOT NULL,
c_end date NOT NULL,
c_data varchar(1000),
c_clob clob,
c_text blob) 
partition by range(c_id)
interval(100) 
(
   partition PART_H1 values less than (10),
   partition PART_H2 values less than (20),
   partition PART_H3 values less than (30)
);


CREATE or replace procedure HZY_PSTATS1.lob_hzy_proc_1115(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from dual;
    insert into  HZY_PSTATS1.STATS_INTERVAL_NEW select i,i,i,'is'||j||'cmRDs'||j,'OE','BAR'||j||'Bar'||j,'bkili'||j||'fcrRGF'||j,'pmbwo'||j||'vhSDGj'||j,'dyf'||j||'rDa'||j,'uq',4801||j,940||j||215||j,'2011-12-11 00:00:00','GC',50000.0,0.4361328,-10.0,10.0,1,true,'2011-12-11 00:00:00','dasd'||j,'dasdsd'||j,'\x1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323';
  END LOOP;
END;
/

call HZY_PSTATS1.lob_hzy_proc_1115(1001,1120);
call HZY_PSTATS1.lob_hzy_proc_1115(1,20);
call HZY_PSTATS1.lob_hzy_proc_1115(1,15);
call HZY_PSTATS1.lob_hzy_proc_1115(10,30);
call HZY_PSTATS1.lob_hzy_proc_1115(25,45);
call HZY_PSTATS1.lob_hzy_proc_1115(50,100);
commit; 

select count(*) from HZY_PSTATS1.STATS_INTERVAL_NEW;

CREATE INDEX HZY_PSTATS1.HZY_PSTATS1_dml_range_indx_086 ON HZY_PSTATS1.STATS_INTERVAL_NEW(c_id);
exec dbe_stats.collect_table_stats('HZY_PSTATS1', 'STATS_INTERVAL_NEW', part_name=>NULL, sample_ratio => 100, method_opt=>'for all indexed columns');
select count(distinct col#)  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1');
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 0 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;

CREATE INDEX HZY_PSTATS1.HZY_PSTATS1_dml_range_indx_087 ON HZY_PSTATS1.STATS_INTERVAL_NEW(c_id, c_d_id,c_last) local;
exec dbe_stats.collect_table_stats('HZY_PSTATS1', 'STATS_INTERVAL_NEW', part_name=>NULL, sample_ratio => 100, method_opt=>'for all indexed columns');
select count(distinct col#)  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1');
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 0 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 1 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 5 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 2 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 3 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;

CREATE INDEX HZY_PSTATS1.HZY_PSTATS1_dml_range_indx_088 ON HZY_PSTATS1.STATS_INTERVAL_NEW(c_d_id,c_last) local;
exec dbe_stats.collect_table_stats('HZY_PSTATS1', 'STATS_INTERVAL_NEW', part_name=>NULL, sample_ratio => 100, method_opt=>'for all indexed columns');
select count(distinct col#)  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1');
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 2 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 3 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;

CREATE INDEX HZY_PSTATS1.HZY_PSTATS1_dml_range_indx_089 ON HZY_PSTATS1.STATS_INTERVAL_NEW(c_w_id, c_first);
exec dbe_stats.collect_table_stats('HZY_PSTATS1', 'STATS_INTERVAL_NEW', part_name=>NULL, sample_ratio => 100, method_opt=>'for all indexed columns');
select count(distinct col#)  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1');
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 2 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 3 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1')ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 4 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;

CREATE INDEX HZY_PSTATS1.HZY_PSTATS1_dml_range_indx_090 ON HZY_PSTATS1.STATS_INTERVAL_NEW(c_d_id, c_w_id, c_last, c_middle);
exec dbe_stats.collect_table_stats('HZY_PSTATS1', 'STATS_INTERVAL_NEW', part_name=>NULL, sample_ratio => 100, method_opt=>'for all indexed columns');
select count(distinct col#)  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1');
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 2 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 3 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 4 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;

CREATE INDEX HZY_PSTATS1.HZY_PSTATS1_dml_range_indx_091 ON HZY_PSTATS1.STATS_INTERVAL_NEW(c_d_id, c_w_id, c_last);
exec dbe_stats.collect_table_stats('HZY_PSTATS1', 'STATS_INTERVAL_NEW', part_name=>NULL, sample_ratio => 100, method_opt=>'for all indexed columns');
select count(distinct col#)  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1');
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 2 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 3 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 4 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;

CREATE INDEX HZY_PSTATS1.HZY_PSTATS1_dml_range_indx_091 ON HZY_PSTATS1.STATS_INTERVAL_NEW(c_w_id, c_last);
exec dbe_stats.collect_table_stats('HZY_PSTATS1', 'STATS_INTERVAL_NEW', part_name=>NULL, sample_ratio => 100, method_opt=>'for all indexed columns');
select count(distinct col#)  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1');
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 2 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 3 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 4 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;

exec DBE_STATS.DELETE_TABLE_STATS('HZY_PSTATS1', 'STATS_INTERVAL_NEW');
select count(distinct col#)  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1');
exec dbe_stats.collect_table_stats('HZY_PSTATS1', 'STATS_INTERVAL_NEW', part_name=>'PART_H1', sample_ratio => 100, method_opt=>'for all indexed columns');
select count(distinct col#)  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1');
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 2 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 3 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'STATS_INTERVAL_NEW') and col# = 4 and user# = (select id from SYS_USERS where name = 'HZY_PSTATS1') ORDER BY SPARE1;

drop table if exists HZY_PSTATS1.STATS_INTERVAL_NEW;
drop user if exists HZY_PSTATS1 cascade;

drop table if exists hzy_dts;
create table hzy_dts(a int);
insert into hzy_dts values(1);
exec dbe_stats.collect_table_stats('SYS','HZY_DTS', null, 100);
exec DBE_STATS.DELETE_TABLE_STATS('SYS', 'HZY_DTS', 'PART_HZY1');


create tablespace spc1 datafile 'spc_1_file' size 32M autoextend on next 16M;
drop table if exists test;
create table test(a int, b int, c int) tablespace spc1;

insert into test values(1,1,1);

declare
i int:=0;
begin
  loop
    i:=i+1;
    insert into test select * from test;
	exit when i= 16;
  end loop;
end;
/
commit;

create index idx_test on test(a, b, c);
exec dbe_stats.collect_table_stats('SYS', 'TEST', NULL, 0);
select samplesize from SYS_TABLES where name = 'TEST' and SYS_TABLES.USER# = 0;
select SYS_INDEXES.samplesize from SYS_INDEXES, SYS_TABLES where SYS_INDEXES.table# = SYS_TABLES.id and SYS_TABLES.name = 'TEST' and SYS_TABLES.USER# = 0;

exec dbe_stats.collect_table_stats('SYS', 'TEST', NULL, 15);
drop tablespace spc1 including contents;


drop table if exists test_statistics_2;
create table test_statistics_2 (id int, name varchar(20));
insert into test_statistics_2 values(0, 'it is a long string');
insert into test_statistics_2 select id + 1, name from test_statistics_2;
insert into test_statistics_2 select id + 2, name from test_statistics_2;
insert into test_statistics_2 select id + 4, name from test_statistics_2;
insert into test_statistics_2 select id + 8, name from test_statistics_2;
insert into test_statistics_2 select id + 16, name from test_statistics_2;
insert into test_statistics_2 select id + 32, name from test_statistics_2;
insert into test_statistics_2 select id + 64, name from test_statistics_2;
insert into test_statistics_2 select id + 128, name from test_statistics_2;
insert into test_statistics_2 select id + 256, name from test_statistics_2;
insert into test_statistics_2 select id + 512, name from test_statistics_2;
insert into test_statistics_2 select id + 1024, name from test_statistics_2;
insert into test_statistics_2 select id + 2048, name from test_statistics_2;
insert into test_statistics_2 select id + 4096, name from test_statistics_2;
insert into test_statistics_2 select id + 8192, name from test_statistics_2;
insert into test_statistics_2 values(null, 'it is a long string');
insert into test_statistics_2 select * from test_statistics_2;
commit;
analyze table test_statistics_2 compute statistics;
select count(distinct id) from test_statistics_2;
select NUM_DISTINCT, NUM_NULLS, HISTOGRAM from dba_tab_columns where TABLE_NAME = 'TEST_STATISTICS_2';

drop table if exists FVT_TABLE_ANALYSE_HYQ_001;
create or replace procedure FVT_PROC_ANALYSE_HYQ_001()
is
begin
    for i in 1..100 loop
        execute immediate 'insert into FVT_TABLE_ANALYSE_HYQ_001 values('||i*i||',
        ''*"%*%$3rfr'||i||'*656^5$34@%^&*()%'',to_date('''||(i+2015)||'-'||(i-i+1)||'-'||(i+10-i)||''',''yyyy-mm-dd''),
        '||(i+90-1.215784112-i*1)||','''||i||'@126.com'','||(i*i+57-i)||')';
    end loop;
    for i in 101..200 loop
       execute immediate 'insert into FVT_TABLE_ANALYSE_HYQ_001 values('''',''45'',to_date('''||(i+2015)||'-'||(i-i+5)||'-'||(i+15-i)||''',''yyyy-mm-dd''),'||(i*2.897654+i)||',''null'',null)';
    end loop;
    for i in 201..300 loop
        execute immediate 'insert into FVT_TABLE_ANALYSE_HYQ_001 values('||(-i)*i||','''',to_date('''||(i+2015)||'-'||(i-i+10)||'-'||(i+15-i)||''',''yyyy-mm-dd''),0,null,'||(i*i+57-i)||')';
    end loop;
    for i in 301..400 loop
    execute immediate 'insert into FVT_TABLE_ANALYSE_HYQ_001 values(0,null,to_date('''||2015||'-'||(i-i+2)||'-'||(i+20-i)||''',''yyyy-mm-dd''),'''',''%&*$iji@#4%^^&H'||i||'F$@WF'',0)';
        --null;
    end loop;
    for i in 401..500 loop
    execute immediate 'insert into FVT_TABLE_ANALYSE_HYQ_001 values('||i*i*i||',''null'',to_date(''2015-'||(i-i+1)||'-'||(i+10-i)||''',''yyyy-mm-dd''),'||(i+90.0987-1-i*1)||','''','||(i*i+57-i)||')';
    end loop;
end;
/
drop table if exists FVT_TABLE_ANALYSE_HYQ_001;
create table FVT_TABLE_ANALYSE_HYQ_001(
        c_id bigint,
        c_name varchar2(100),
        c_time date,
        c_num decimal(10,5),
        c_clob clob
        );
ALTER TABLE FVT_TABLE_ANALYSE_HYQ_001 ADD c_add INT;	
declare 
begin 
FVT_PROC_ANALYSE_HYQ_001(); 
end;
/
exec dbe_stats.collect_table_stats('SYS', 'FVT_TABLE_ANALYSE_HYQ_001', part_name=>NULL,sample_ratio => 100,method_opt=>'for all columns');
select count(distinct c_id ),count(distinct c_name ),count(distinct c_time ),count(distinct c_num ),count(distinct c_add ) from FVT_TABLE_ANALYSE_HYQ_001;
select t.name,hh.col#,hh.BUCKET_NUM,hh.ROW_NUM,hh.NULL_NUM,hh.MINVALUE,hh.MAXVALUE,hh.DIST_NUM from
SYS_HISTGRAM_ABSTR hh,SYS_TABLES t where hh.tab#=t.id and t.name='FVT_TABLE_ANALYSE_HYQ_001' and hh.col# = 0;
select t.name,hh.col#,hh.BUCKET_NUM,hh.ROW_NUM,hh.NULL_NUM,hh.MINVALUE,hh.MAXVALUE,hh.DIST_NUM from
SYS_HISTGRAM_ABSTR hh,SYS_TABLES t where hh.tab#=t.id and t.name='FVT_TABLE_ANALYSE_HYQ_001' and hh.col# = 1;
select t.name,hh.col#,hh.BUCKET_NUM,hh.ROW_NUM,hh.NULL_NUM,hh.MINVALUE,hh.MAXVALUE,hh.DIST_NUM from
SYS_HISTGRAM_ABSTR hh,SYS_TABLES t where hh.tab#=t.id and t.name='FVT_TABLE_ANALYSE_HYQ_001' and hh.col# = 2;
select t.name,hh.col#,hh.BUCKET_NUM,hh.ROW_NUM,hh.NULL_NUM,hh.MINVALUE,hh.MAXVALUE,hh.DIST_NUM from
SYS_HISTGRAM_ABSTR hh,SYS_TABLES t where hh.tab#=t.id and t.name='FVT_TABLE_ANALYSE_HYQ_001' and hh.col# = 3;
select t.name,hh.col#,hh.BUCKET_NUM,hh.ROW_NUM,hh.NULL_NUM,hh.MINVALUE,hh.MAXVALUE,hh.DIST_NUM from
SYS_HISTGRAM_ABSTR hh,SYS_TABLES t where hh.tab#=t.id and t.name='FVT_TABLE_ANALYSE_HYQ_001' and hh.col# = 4;
select count(*) from SYS_HISTGRAM,SYS_TABLES where SYS_TABLES.id=SYS_HISTGRAM.table# and SYS_TABLES.name='FVT_TABLE_ANALYSE_HYQ_001' and SYS_HISTGRAM.col# = 0;
select count(*) from SYS_HISTGRAM,SYS_TABLES where SYS_TABLES.id=SYS_HISTGRAM.table# and SYS_TABLES.name='FVT_TABLE_ANALYSE_HYQ_001' and SYS_HISTGRAM.col# = 1;
select count(*) from SYS_HISTGRAM,SYS_TABLES where SYS_TABLES.id=SYS_HISTGRAM.table# and SYS_TABLES.name='FVT_TABLE_ANALYSE_HYQ_001' and SYS_HISTGRAM.col# = 2;
select count(*) from SYS_HISTGRAM,SYS_TABLES where SYS_TABLES.id=SYS_HISTGRAM.table# and SYS_TABLES.name='FVT_TABLE_ANALYSE_HYQ_001' and SYS_HISTGRAM.col# = 3;
select count(*) from SYS_HISTGRAM,SYS_TABLES where SYS_TABLES.id=SYS_HISTGRAM.table# and SYS_TABLES.name='FVT_TABLE_ANALYSE_HYQ_001' and SYS_HISTGRAM.col# = 4;

drop table if exists test_staffs_03;
CREATE TABLE test_staffs_03
(
staff_id NUMBER(6),
first_name VARCHAR2(20),
last_name VARCHAR2(25),
email VARCHAR2(25),
sex int
)partition by range(staff_id)
(partition p_050_before values less than (50),partition p_100 values less than (100),
partition p_150 values less than (150),partition p_200 values less than (200),
partition p_200_after values less than (maxvalue));

create or replace procedure insert_staff_03_01()
is
begin
	for i in 1..99 loop
		execute immediate 'insert into test_staffs_03 values('||i||',''john'','''||i||'king'','''||i||'@126.com'',1)';
	end loop;
	for i in 100..200 loop
		execute immediate 'insert into test_staffs_03 values('||i||',''joe'','''||i||'queen'','''||i||'@126.com'',1)';
	end loop;
end;
/
call insert_staff_03_01();

drop index if exists idx_staff_03_1 on test_staffs_03;
create index idx_staff_03_1 on test_staffs_03(to_char(staff_id));
exec dbe_stats.collect_table_stats('SYS', 'TEST_STAFFS_03', part_name=>NULL,sample_ratio => 100,method_opt=>'for all indexed columns');
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 0 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 1 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 2 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 3 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 4 ORDER BY SPARE1;

drop index if exists idx_staff_03_2 on test_staffs_03;
create index idx_staff_03_2 on test_staffs_03(to_char(email));
exec dbe_stats.collect_table_stats('SYS', 'TEST_STAFFS_03', part_name=>NULL,sample_ratio => 100,method_opt=>'for all indexed columns');
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 0 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 1 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 2 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 3 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 4 ORDER BY SPARE1;

drop index if exists idx_staff_03_3 on test_staffs_03;
create index idx_staff_03_3 on test_staffs_03(upper(first_name));
exec dbe_stats.collect_table_stats('SYS', 'TEST_STAFFS_03', part_name=>NULL,sample_ratio => 100,method_opt=>'for all indexed columns');
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 0 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 1 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 2 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 3 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 4 ORDER BY SPARE1;

drop index if exists idx_staff_03_4 on test_staffs_03;
create unique index idx_staff_03_4 on test_staffs_03(upper(last_name));
exec dbe_stats.collect_table_stats('SYS', 'TEST_STAFFS_03', part_name=>NULL,sample_ratio => 100,method_opt=>'for all indexed columns');
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 0 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 1 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 2 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 3 ORDER BY SPARE1;
select col#,BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'TEST_STAFFS_03') and col# = 4 ORDER BY SPARE1;

analyze index idx_staff_03_1 on test_staffs_03 compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where name = upper('idx_staff_03_1');
analyze index idx_staff_03_2 on test_staffs_03 compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where name = upper('idx_staff_03_2');
analyze index idx_staff_03_3 on test_staffs_03 compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where name = upper('idx_staff_03_3');
analyze index idx_staff_03_4 on test_staffs_03 compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where name = upper('idx_staff_03_4');

drop table if exists stats_var;
create table stats_var(a varchar(8000));
insert into stats_var values(LPAD('12',1000,'1'));   
insert into stats_var values(LPAD('22',1000,'1'));
insert into stats_var values(LPAD('32',1000,'1'));
commit;
analyze table stats_var compute statistics; 
select bucket,endpoint from SYS_HISTGRAM,SYS_TABLES where SYS_TABLES.id=SYS_HISTGRAM.table# and SYS_TABLES.name=upper('stats_var') and SYS_HISTGRAM.col# = 0 
order by endpoint;
select count(distinct a) from stats_var;
select a.column_name,a.num_distinct,a.num_buckets from DBA_TAB_COL_STATISTICS a where a.table_name=upper('stats_var');
insert into stats_var values(LPAD('12',8000,'1'));   
insert into stats_var values(LPAD('22',8000,'1'));
insert into stats_var values(LPAD('32',8000,'1'));
commit;
analyze table stats_var compute statistics;
select count(distinct a) from stats_var;
select a.column_name,a.num_distinct,a.num_buckets from DBA_TAB_COL_STATISTICS a where a.table_name=upper('stats_var');

drop table if exists #stats_temp_table;
create temporary table #stats_temp_table(a int, b bigint, c varchar(10));
create index stats_temp_table_idx1 on #stats_temp_table(a);
create index stats_temp_table_idx2 on #stats_temp_table(a, b);

analyze index stats_temp_table_idx1 on #stats_temp_table compute statistics;

insert into #stats_temp_table values(1, 12345, '12345');

declare
i int:=0;
begin
  loop
    i:=i+1;
    insert into #stats_temp_table select * from #stats_temp_table;
	exit when i= 15;
  end loop;
end;
/

analyze table #stats_temp_table compute statistics;
exec dbe_stats.collect_table_stats('sys', '#stats_temp_table', NULL, 10);

drop tablespace spc1 including contents;
create tablespace spc1 datafile 'spc_1_file' size 32M autoextend on next 16M;
drop table if exists test_statistics_2;
create table test_statistics_2 (id int, name varchar(20))tablespace spc1;
insert into test_statistics_2 values(0, 'it is a long string');
insert into test_statistics_2 select id + 1, name from test_statistics_2;
insert into test_statistics_2 select id + 2, name from test_statistics_2;
insert into test_statistics_2 select id + 4, name from test_statistics_2;
insert into test_statistics_2 select id + 8, name from test_statistics_2;
insert into test_statistics_2 select id + 16, name from test_statistics_2;
insert into test_statistics_2 select id + 32, name from test_statistics_2;
insert into test_statistics_2 select id + 64, name from test_statistics_2;
insert into test_statistics_2 select id + 120, name from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
commit;
exec dbe_stats.collect_table_stats('SYS', 'TEST_STATISTICS_2', part_name=>NULL,sample_ratio => 35,method_opt=>'for all columns');
drop tablespace spc1 including contents;

alter system set cbo=on;
alter system set LOCAL_TEMPORARY_TABLE_ENABLED=true;
drop table if exists FVT_STATISTICS_TAB_1;
drop table if exists #FVT_STATISTICS_TAB_2;
create table FVT_STATISTICS_TAB_1 
(c_id number unique,
c_sal number,
c_name varchar2(64),
c_time datetime,
c_bol boolean
);
create temporary table #FVT_STATISTICS_TAB_2
(c_id number unique,
c_int int,
c_name varchar2(64),
c_time datetime,
c_bol boolean
);

drop index if exists STATISTICS_IND_1 on FVT_STATISTICS_TAB_1;
drop index if exists STATISTICS_IND_2 on #FVT_STATISTICS_TAB_2;
create index STATISTICS_IND_1 on FVT_STATISTICS_TAB_1(c_sal);
create index STATISTICS_IND_2 on #FVT_STATISTICS_TAB_2(c_int);


insert into FVT_STATISTICS_TAB_1 values(1,'',null,'2019-01-17',false);
insert into FVT_STATISTICS_TAB_1 values(2,45,'sad@fds.13','2019-04-17',true);
insert into FVT_STATISTICS_TAB_1 values(3,60,'fsdaaaaadsafsdaffds','2019-05-17',null);
insert into FVT_STATISTICS_TAB_1 values(4,20,'','2019-05-17',false);
insert into FVT_STATISTICS_TAB_1 values(5,3.5,'Qds@#$dsa','',true);
insert into FVT_STATISTICS_TAB_1 values(null,-7,'xiaoming',null,'');
insert into FVT_STATISTICS_TAB_1 values(7,null,'a','2019-07-17',false);
insert into #FVT_STATISTICS_TAB_2 values(1,'',null,'2019-01-17',false);
insert into #FVT_STATISTICS_TAB_2 values(2,45,'sad@fds.13','2019-04-17',true);
insert into #FVT_STATISTICS_TAB_2 values(3,60,'fsdaaaaadsafsdaffds','2019-05-17',null);
select c_sal from FVT_STATISTICS_TAB_1 a,#FVT_STATISTICS_TAB_2 b where a.c_id=b.c_id;

select cols,indexes,partitioned,num_rows,empty_blocks,avg_row_len,samplesize from SYS_TABLES where name ='FVT_STATISTICS_TAB_1'order by 1,2,3,4;
select a.histogram,a.precision,a.scale,a.num_distinct from SYS_COLUMNS a,SYS_TABLES b where b.name ='FVT_STATISTICS_TAB_1' and b.id=a.table# order by 1,2,3,4;
select a.bucket_num,a.row_num,a.minvalue,a.maxvalue,a.dist_num from SYS_HISTGRAM_ABSTR a,SYS_TABLES b where a.tab#=b.id and b.name='FVT_STATISTICS_TAB_1'order by 1,2,3,4;
select a.bucket,a.endpoint,a.part# from SYS_HISTGRAM a,SYS_TABLES b where a.table#=b.id and b.name='FVT_STATISTICS_TAB_1'order by bucket;

--建表
drop table if exists #FVT_OBJ_DEFINE_local_temp_table_002;
create TEMPORARY table #FVT_OBJ_DEFINE_local_temp_table_002(
COL_1 bigint, COL_2 TIMESTAMP WITHOUT TIME ZONE, COL_3 bool,COL_4 decimal,COL_5 text ,COL_6 smallint ,COL_7 char(30),COL_8 double precision,COL_9 longtext,COL_10 character varying(30),
COL_11 bool ,COL_12 bytea ,COL_13 real ,COL_14 numeric ,COL_15 blob ,COL_16 integer ,COL_17 int ,COL_18 TIMESTAMP WITH TIME ZONE ,COL_19 binary_integer ,COL_20 interval day to second ,
COL_21 boolean, COL_22 nchar(30) ,COL_23 binary_bigint ,COL_24 nchar(100) ,COL_25 character(1000) , OL_26 text , COL_27 float ,COL_28 double ,COL_29 bigint ,COL_30  TIMESTAMP WITH LOCAL TIME ZONE ,
COL_31 TIMESTAMP , COL_32 image ,COL_33 interval year to month, COL_34 character(30) ,COL_35 smallint ,COL_36 blob ,COL_37 char(300),COL_38 float ,COL_39 raw(100),COL_40 clob ,
COL_41 binary_double ,COL_42 number(6,2) ,COL_43 decimal(6,2) ,COL_44 varchar2(50),COL_45 varchar(30) ,COL_46 nvarchar2(100), COL_47 numeric(12,6),COL_48 nvarchar(30),COL_49 date,COL_50 image ,
COL_51 integer ,COL_52 binary_double ,COL_53 decimal(12,6),COL_54 raw(8000),COL_55 clob ,COL_56 varchar2(8000) ,COL_57 datetime ,COL_58 number(12,6),COL_59 nvarchar2(4000) ,COL_60 varbinary(2000) ,
COL_61 binary(200) ,COL_62 datetime ,COL_63 binary(100) , COL_64 varchar(1000),COL_65 date

);

--清空数据
truncate table #FVT_OBJ_DEFINE_local_temp_table_002;

--插入数据
insert into #FVT_OBJ_DEFINE_local_temp_table_002 values(
32768,to_timestamp('2019-01-03 14:58:54.000000','YYYY-MM-DD HH24:MI:SS.FFFFFF'),true,3.1415926,lpad('abc','30','a@123&^%djgk'),987,'asjk&%$454',10011.456789445455,lpad('abc','50','a@123&^%djgk'),'字符串',
false,'1001011',315454.1415926,99/4,'101101000111111101010',0,1,to_timestamp('2019-01-04 16:33:47.123456','YYYY-MM-DD HH24:MI:SS.FFFFFF'),'1',(INTERVAL '4 5:12:10.222' DAY TO SECOND(3)),
0,rpad('abc','10','e'),353848,rpad('abc','10','exc'),lpad('abc','30','a@123&^%djgk'),lpad('abc','20','a@123&^%djgk'),9745.548,-99,3141.5,to_timestamp('2019-01-04 16:33:47.123456','YYYY-MM-DD HH24:MI:SS.FFFFFF'),
to_timestamp('2019-01-03 14:58:54.000000','YYYY-MM-DD HH24:MI:SS.FFFFFF'),'a@123&^%djgk',(INTERVAL '12' YEAR),' ','0',lpad('10',50,'01010'),'这是一个字符串',1/2.15,'0FAADB9','a@123&^%djgk',
1.0E+100,3.14,4445.25,rpad('abc','10','&'),lpad('abc','10','&'),'abc&GDsh',125563.141592,rpad('abc','10','e'),TIMESTAMPADD(DAY,52,'2019-01-03 14:14:12'),'a@123汉字&^%djgk',
+2,-1.79E+100,98*0.99,'1010101001010','abca@123&^%djgk','abca@123&^%djgk',TIMESTAMPADD(SECOND,6,'2019-01-03 14:14:12'),25563.1415,'a字符串@123&^%djgk',lpad('10',20,'01010'),
'1001010',TIMESTAMPADD(MONTH,20,'2019-01-03 14:14:12'),'010101111111100000000000000','abc&GDsh',TIMESTAMPADD(SECOND,9,'2019-01-03 15:19:00')
);
commit;

--select复制数据,i的值可以修改
begin
        for i in 1..10 loop
        insert into #FVT_OBJ_DEFINE_local_temp_table_002 select * from #FVT_OBJ_DEFINE_local_temp_table_002;
    end loop;
end;
/


--创建索引
drop index if exists index_OBJ_DEFINE_001 on #FVT_OBJ_DEFINE_local_temp_table_002;
create index index_OBJ_DEFINE_001 on #FVT_OBJ_DEFINE_local_temp_table_002(COL_2,COL_7);

--创建视图
drop view if exists view_OBJ_DEFINE_001;
create view view_OBJ_DEFINE_001 as select COL_6,COL_45 from #FVT_OBJ_DEFINE_local_temp_table_002;

--analyze
analyze table #FVT_OBJ_DEFINE_local_temp_table_002 COMPUTE STATISTICS;
 
create index index_OBJ_DEFINE_002 on #FVT_OBJ_DEFINE_local_temp_table_002(COL_1,COL_7);
analyze table #FVT_OBJ_DEFINE_local_temp_table_002 COMPUTE STATISTICS;

--- DTS2019051600545
drop user if exists STATS_INDEX_COL_004_Usr_01 cascade;
create user STATS_INDEX_COL_004_Usr_01 identified by Cantian_234;
grant dba to STATS_INDEX_COL_004_Usr_01;
GRANT SELECT ON SYS.SYS_TABLES TO STATS_INDEX_COL_004_Usr_01;
GRANT SELECT ON SYS.SYS_USERS TO STATS_INDEX_COL_004_Usr_01;
GRANT SELECT ON SYS.SYS_HISTGRAM_ABSTR TO STATS_INDEX_COL_004_Usr_01;
GRANT SELECT ON SYS.SYS_HISTGRAM TO STATS_INDEX_COL_004_Usr_01;
GRANT SELECT ON SYS.SYS_COLUMNS TO STATS_INDEX_COL_004_Usr_01;
conn STATS_INDEX_COL_004_Usr_01/Cantian_234@127.0.0.1:1611
drop table if exists STATS_INDEX_COL_004_Tab_01;
create table STATS_INDEX_COL_004_Tab_01(id int,name varchar(100),num number ,ctime datetime,c_clob clob);
drop index if exists STATS_INDEX_COL_004_Idx_01 on STATS_INDEX_COL_004_TAB_01;
drop index if exists STATS_INDEX_COL_004_Idx_02 on STATS_INDEX_COL_004_TAB_01;
create index STATS_INDEX_COL_004_Idx_01 on STATS_INDEX_COL_004_TAB_01(ctime);
create unique index STATS_INDEX_COL_004_Idx_02 on STATS_INDEX_COL_004_TAB_01(id,name,num,upper(name));


insert into STATS_INDEX_COL_004_Tab_01 values(1,'test_1',1000.11,to_date('2019-04-18 11:35:11'),'11111111111AAAA@!!@');
insert into STATS_INDEX_COL_004_Tab_01 values(2,'tes_1',100.11,to_date('2019-04-19 11:35:11'),'11111111111AAAA@!!@');
insert into STATS_INDEX_COL_004_Tab_01 values(10,'tst_1',10020.11,to_date('2019-04-10 11:35:11'),'11111111111AAAA@!!@');
insert into STATS_INDEX_COL_004_Tab_01 values(12,'est_1',200.11,to_date('2018-04-18 11:35:11'),'11111111111AAAA@!!@');
insert into STATS_INDEX_COL_004_Tab_01 values(17,'',80.11,to_date('2018-04-18 11:35:11'),'11111111111AAAA@!!@');

select NAME,COLS,INDEXES,NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_ROW_LEN,SAMPLESIZE from sys.SYS_TABLES where name = 'STATS_INDEX_COL_004_TAB_01';

select t.name,hh.col#,hh.BUCKET_NUM,hh.ROW_NUM,hh.NULL_NUM,hh.MINVALUE,hh.MAXVALUE,hh.DIST_NUM,hh.DENSITY from sys.SYS_HISTGRAM_ABSTR hh,sys.SYS_USERS t3,sys.SYS_TABLES t
where hh.tab#=t.id and hh.user# = t3.ID and t.name='STATS_INDEX_COL_004_TAB_01' and t3.NAME='STATS_INDEX_COL_004_USR_01' order by NAME, COL#;
select  COL# ,   BUCKET , ENDPOINT,PART# ,  EPVALUE from sys.SYS_HISTGRAM t1 ,sys.user_tables t2 ,sys.SYS_USERS t3
where t1.TABLE# =t2.TABLE_ID and t1.user# = t3.ID and T2.TABLE_NAME='STATS_INDEX_COL_004_TAB_01' and t3.NAME='STATS_INDEX_COL_004_USR_01' order by COL# ,   BUCKET , ENDPOINT,PART# ,  EPVALUE;

select t1.NAME,DATATYPE,t1.BYTES,t1.PRECISION,t1.SCALE,t1.NULLABLE,t1.FLAGS,t1.DEFAULT_TEXT,t1.NUM_DISTINCT,t1.LOW_VALUE,t1.HIGH_VALUE,t1.HISTOGRAM from sys.SYS_COLUMNS t1 ,sys.user_tables t2 ,
sys.SYS_USERS t3 where t1.TABLE# =t2.TABLE_ID and t1.user# = t3.ID and T2.TABLE_NAME='STATS_INDEX_COL_004_TAB_01' and t3.NAME='STATS_INDEX_COL_004_USR_01' order by t1.NAME,DATATYPE,t1.BYTES,t1.PRECISION,t1.SCALE,t1.NULLABLE,t1.FLAGS,t1.DEFAULT_TEXT,t1.NUM_DISTINCT,t1.LOW_VALUE,t1.HIGH_VALUE,t1.HISTOGRAM;

exec dbe_stats.collect_table_stats(schema=>'STATS_INDEX_COL_004_Usr_01',name=>'STATS_INDEX_COL_004_Tab_01',sample_ratio => 50,method_opt=>' for   all indexed columns',part_name=>NULL);

select NAME,COLS,INDEXES,NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_ROW_LEN,SAMPLESIZE from sys.SYS_TABLES where name = 'STATS_INDEX_COL_004_TAB_01';
select t.name,hh.col#,hh.BUCKET_NUM,hh.ROW_NUM,hh.NULL_NUM,hh.MINVALUE,hh.MAXVALUE,hh.DIST_NUM,hh.DENSITY from sys.SYS_HISTGRAM_ABSTR hh,sys.SYS_USERS t3,sys.SYS_TABLES t
where hh.tab#=t.id and hh.user# = t3.ID and t.name='STATS_INDEX_COL_004_TAB_01' and t3.NAME='STATS_INDEX_COL_004_USR_01' order by NAME, COL#;
select  COL# ,   BUCKET , ENDPOINT,PART# ,  EPVALUE from sys.SYS_HISTGRAM t1 ,sys.user_tables t2 ,sys.SYS_USERS t3
where t1.TABLE# =t2.TABLE_ID and t1.user# = t3.ID and T2.TABLE_NAME='STATS_INDEX_COL_004_TAB_01' and t3.NAME='STATS_INDEX_COL_004_USR_01' order by COL# ,   BUCKET , ENDPOINT,PART# ,  EPVALUE;

drop table if exists STATS_SPC_HASH1;
drop tablespace spc_hzystats9 including contents and datafiles;
CREATE TABLESPACE spc_hzystats9 datafile 'hzy_stats_part9' size 32M;
drop table if exists STATS_SPC_HASH1;

create table STATS_SPC_HASH1 (
c3 char(20) primary key,
c4 number(8) not null
)tablespace spc_hzystats9;

insert into STATS_SPC_HASH1 values('aaaa',111);
insert into STATS_SPC_HASH1 values('bbbb',111);
insert into STATS_SPC_HASH1 values('cccc',111);
insert into STATS_SPC_HASH1 values('dddd',111);
insert into STATS_SPC_HASH1 values('eeee',111);
insert into STATS_SPC_HASH1 values('ffff',111);
insert into STATS_SPC_HASH1 values('hhhh',111);
insert into STATS_SPC_HASH1 values('iiii',111);
commit;
exec dbe_stats.collect_table_stats('STATS_INDEX_COL_004_Usr_01', 'STATS_SPC_HASH1',null,10);
select num_rows from sys.SYS_TABLES where name = 'STATS_SPC_HASH1';
exec dbe_stats.collect_table_stats('STATS_INDEX_COL_004_Usr_01', 'STATS_SPC_HASH1',null,30);
select num_rows from sys.SYS_TABLES where name = 'STATS_SPC_HASH1';
exec dbe_stats.collect_table_stats('STATS_INDEX_COL_004_Usr_01', 'STATS_SPC_HASH1',null,90);
drop table if exists STATS_SPC_HASH1;
drop tablespace spc_hzystats9 including contents and datafiles;
--test sql reparse
drop table if exists H_ANR_U2L_SRB_STATUS_TMP_5;
drop table if exists H_ANR_U2L_SRB_STATUS_5;
create table H_ANR_U2L_SRB_STATUS_TMP_5(CREATETIME int, CGI VARCHAR(32) not null, SUBRESULT  varchar(1));
create table H_ANR_U2L_SRB_STATUS_5(CREATETIME int, CGI VARCHAR(32) not null, SUBRESULT  varchar(1));

insert into H_ANR_U2L_SRB_STATUS_5(CGI,CREATETIME,SUBRESULT)values('301-55-33301-101',1562205029,'Y');        
insert into H_ANR_U2L_SRB_STATUS_5(CGI,CREATETIME,SUBRESULT)values('301-55-33301-102',1562205029,'Y');        
insert into H_ANR_U2L_SRB_STATUS_5(CGI,CREATETIME,SUBRESULT)values('301-55-33301-103',1562205029,'Y');        
insert into H_ANR_U2L_SRB_STATUS_5(CGI,CREATETIME,SUBRESULT)values('301-55-33301-104',1562205029,'Y');        
insert into H_ANR_U2L_SRB_STATUS_5(CGI,CREATETIME,SUBRESULT)values('301-55-33301-105',1562205029,'Y');        
insert into H_ANR_U2L_SRB_STATUS_5(CGI,CREATETIME,SUBRESULT)values('301-55-33301-106',1562205029,'Y');        
insert into H_ANR_U2L_SRB_STATUS_5(CGI,CREATETIME,SUBRESULT)values('301-55-33302-107',1562205029,'Y');        
insert into H_ANR_U2L_SRB_STATUS_5(CGI,CREATETIME,SUBRESULT)values('301-55-33302-108',1562205029,'Y');        
insert into H_ANR_U2L_SRB_STATUS_5(CGI,CREATETIME,SUBRESULT)values('301-55-33302-109',1562205029,'Y');        
insert into H_ANR_U2L_SRB_STATUS_5(CGI,CREATETIME,SUBRESULT)values('301-55-33302-110',1562205029,'Y');        
insert into H_ANR_U2L_SRB_STATUS_5(CGI,CREATETIME,SUBRESULT)values('301-55-33302-111',1562205029,'Y');        
insert into H_ANR_U2L_SRB_STATUS_5(CGI,CREATETIME,SUBRESULT)values('301-55-33302-112',1562205029,'Y'); 
commit;

create or replace procedure SP_TEMP_PROC 
(
    v_in_OptiExecutePeriod in number ,
    v_in_OptiStatisticPeriod in number ,
    v_in_TaskStartTime in number ,
    v_in_StatEndTime in number ,
    v_in_AnrSecPerUnit in number  default 3600 )
as 
begin

    begin dbe_stats.collect_table_stats (schema=>user, name=>'H_ANR_U2L_SRB_STATUS_5'); end;
    insert into H_ANR_U2L_SRB_STATUS_TMP_5 (CREATETIME,SUBRESULT)
        select  floor(trunc((CREATETIME - v_in_TaskStartTime) / (v_in_OptiExecutePeriod * v_in_AnrSecPerUnit))),   
        count( 1 ) from H_ANR_U2L_SRB_STATUS_5 where CREATETIME between v_in_StatEndTime and v_in_StatEndTime and SUBRESULT = 
'Y' group by  floor(trunc((CREATETIME - v_in_TaskStartTime) / (v_in_OptiExecutePeriod * v_in_AnrSecPerUnit)));          
begin dbe_stats.collect_table_stats (schema=>user, name=>'H_ANR_U2L_SRB_STATUS_5'); end;
	rollback;
end;
/
exec SP_TEMP_PROC(1,1,1,9,1);
create or replace procedure SP_TEMP_PROC 
(
    v_in_OptiExecutePeriod in number ,
    v_in_OptiStatisticPeriod in number ,
    v_in_TaskStartTime in number ,
    v_in_StatEndTime in number ,
    v_in_AnrSecPerUnit in number  default 3600 )
as 
begin

    begin dbe_stats.collect_table_stats (schema=>user, name=>'H_ANR_U2L_SRB_STATUS_5'); end;

    execute immediate 'insert into H_ANR_U2L_SRB_STATUS_TMP_5 (CREATETIME,SUBRESULT)
        select  floor(trunc((CREATETIME - :1) / (:2 * :3))),   
        count( 1 ) from H_ANR_U2L_SRB_STATUS_5 where CREATETIME between :4 and :5 and SUBRESULT = 
''Y'' group by  floor(trunc((CREATETIME -  :6) / (:7 * :8)))' using v_in_TaskStartTime, v_in_OptiExecutePeriod, v_in_AnrSecPerUnit, v_in_StatEndTime, v_in_StatEndTime, v_in_TaskStartTime, v_in_OptiExecutePeriod, v_in_AnrSecPerUnit;
	rollback;
end;
/

exec SP_TEMP_PROC(1,1,1,9,1);

create or replace procedure SP_TEMP_PROC 
(
    v_in_OptiExecutePeriod in number ,
    v_in_OptiStatisticPeriod in number ,
    v_in_TaskStartTime in number ,
    v_in_StatEndTime in number ,
    v_in_AnrSecPerUnit in number  default 3600 )
as 
begin

    begin dbe_stats.collect_table_stats (schema=>user, name=>'H_ANR_U2L_SRB_STATUS_5'); end;

    execute immediate 'begin insert into H_ANR_U2L_SRB_STATUS_TMP_5 (CREATETIME,SUBRESULT)
        select  floor(trunc((CREATETIME - :1) / (:2 * :3))),   
        count( 1 ) from H_ANR_U2L_SRB_STATUS_5 where CREATETIME between :4 and :4 and SUBRESULT = 
''Y'' group by  floor(trunc((CREATETIME - :1) / (:2 * :3))); end;' using v_in_TaskStartTime, v_in_OptiExecutePeriod, v_in_AnrSecPerUnit, v_in_StatEndTime;
	rollback;
end;
/
exec SP_TEMP_PROC(1,1,1,9,1);

conn sys/Huawei@123@127.0.0.1:1611
drop table if exists hzy_llt_opt;
create table hzy_llt_opt(a int)
partition by range(A)
interval(258)
(
   partition PART_H1 values less than (100),
   partition PART_H2 values less than (359),
   partition PART_H3 values less than (659)
);
create index hzy_lklt_idx on hzy_llt_opt(a) local;
exec dbe_stats.collect_table_stats('SYS', 'hzy_llt_opt', part_name=>'PART_H1',sample_ratio => 100,method_opt=>'for all indexed columns');
exec DBE_STATS.PURGE_STATS(sysdate);

drop table if exists hzy_llt_opt1;
create table hzy_llt_opt1(a int)
partition by range(A)
interval(258)
(
   partition PART_H1 values less than (100),
   partition PART_H2 values less than (359),
   partition PART_H3 values less than (659)
);
create index hzy_lklt_idx1 on hzy_llt_opt1(a) local;
insert into hzy_llt_opt1 values(350);
insert into hzy_llt_opt1 values(600);
exec dbe_stats.collect_table_stats('SYS', 'hzy_llt_opt1', part_name=>NULL,sample_ratio => 100,method_opt=>'for all indexed columns');
select BLEVEL,LEVEL_BLOCKS,DISTKEY,LBLKKEY,DBLKKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV,samplesize from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_LLT_OPT1') and USER# = 0 order by PART#;


alter system set local_temporary_table_enabled=true;
drop table if exists tbl_EventBuffer;
create table tbl_EventBuffer( Serial int,SerialContext int,TS int,EventID int,SenderProcID int,SenderProcHandle int);
insert into tbl_EventBuffer values(3,5,7,4,3,1);
drop table if exists tbl_ReceivedEvent;
create table tbl_ReceivedEvent(Serial int,RecvProcID int,RecvProcHandle int,RecvTaskMgrID int,v_newSerial int);
drop table if exists tbl_SubscribEvent;
create table tbl_SubscribEvent(EventID int,RecvProcID int,RecvProcHandle int,RecvTaskMgrID int,EventState int,EventType int);
drop table if exists tbl_SubscribEventBak;
create table tbl_SubscribEventBak(RecvProcID int,RecvProcHandle int,RecvTaskMgrID int,EventID int,EventState int,EventType int);
drop table if exists tbl_EventBufferContextData;
create table tbl_EventBufferContextData(Serial int,FirstPacketSN int);
drop sequence if exists YF_SEQ;
create sequence YF_SEQ start with 1 increment by 1;


create or replace procedure sp_ClearEventByRate(v_freeRate IN real,SWP_Ret_Value IN OUT NUMBER) as
   v_serial  NUMBER(18,0);
   v_newSerial  NUMBER(18,0);
BEGIN
        execute immediate 'DROP TABLE if exists #tt_TMP_TBL_SUBSCRIBE';

execute immediate 'CREATE TEMPORARY TABLE #tt_TMP_TBL_SUBSCRIBE
(
   EventID         NUMBER(10,0) NOT NULL,
   RecvProcID  NUMBER(10,0) NOT NULL,
   RecvProcHandle  NUMBER(10,0) DEFAULT 0 NOT NULL,
   RecvTaskMgrID NUMBER(5,0),
   EventState      NUMBER(10,0) DEFAULT 0,
   EventType       NUMBER(5,0) DEFAULT 0 NOT NULL,
   primary key
(EventID,
   RecvProcID,
   RecvProcHandle)
)on commit preserve rows';

   if v_freeRate < 0.2 then
                execute immediate 'drop table if exists #tt_TBL_SERIALTMP';
      execute immediate 'create TEMPORARY table #tt_TBL_SERIALTMP as SELECT  Serial,SerialContext from tbl_EventBuffer  where rownum<=5000  order by TS ';
      execute immediate 'select   max(Serial) from #tt_TBL_SERIALTMP' INTO v_serial ;
      execute immediate 'insert into tbl_EventBuffer(EventID, SenderProcID, SenderProcHandle, SerialContext) values(69662, 0, 0, 0)';
          select yf_seq.nextval into v_newSerial from dual;
      select yf_seq.currval into v_newSerial from dual;
      execute immediate 'insert into tbl_ReceivedEvent(Serial,RecvProcID,RecvProcHandle,RecvTaskMgrID) (select distinct '|| v_newSerial||', RecvProcID, RecvProcHandle, RecvTaskMgrID from tbl_ReceivedEvent where Serial <= '||v_serial||')';

      execute immediate 'insert into #tt_TMP_TBL_SUBSCRIBE(EventID,RecvProcID,RecvProcHandle,RecvTaskMgrID,EventState,EventType)(select distinct tbl_SubscribEvent.EventID,tbl_SubscribEvent.RecvProcID,tbl_SubscribEvent.RecvProcHandle,tbl_SubscribEvent.RecvTaskMgrID,tbl_SubscribEvent.EventState,tbl_SubscribEvent.EventType
         from tbl_SubscribEvent,tbl_ReceivedEvent
         where tbl_SubscribEvent.RecvProcID = tbl_ReceivedEvent.RecvProcID
         and tbl_SubscribEvent.RecvProcHandle = tbl_ReceivedEvent.RecvProcHandle
         and tbl_SubscribEvent.RecvTaskMgrID = tbl_ReceivedEvent.RecvTaskMgrID
         and tbl_ReceivedEvent.Serial in(select Serial from #tt_TBL_SERIALTMP))';
      execute immediate 'DELETE FROM tbl_SubscribEventBak WHERE ROWID IN(SELECT tbl_SubscribEventBak.ROWID from tbl_SubscribEventBak,#tt_TMP_TBL_SUBSCRIBE #tt_TMP_TBL_SUBSCRIBE where tbl_SubscribEventBak.RecvProcID = #tt_TMP_TBL_SUBSCRIBE.RecvProcID
      and tbl_SubscribEventBak.RecvProcHandle = #tt_TMP_TBL_SUBSCRIBE.RecvProcHandle
      and tbl_SubscribEventBak.RecvTaskMgrID = #tt_TMP_TBL_SUBSCRIBE.RecvTaskMgrID
      and tbl_SubscribEventBak.EventID = #tt_TMP_TBL_SUBSCRIBE.EventID)';
      execute immediate 'insert into tbl_SubscribEventBak(EventID,RecvProcID,RecvProcHandle,RecvTaskMgrID,EventState,EventType)(select distinct EventID,RecvProcID,RecvProcHandle,RecvTaskMgrID,EventState,EventType from #tt_TMP_TBL_SUBSCRIBE)';
      execute immediate 'DELETE FROM tbl_SubscribEvent WHERE ROWID IN(SELECT tbl_SubscribEvent.ROWID from tbl_SubscribEvent,#tt_TMP_TBL_SUBSCRIBE #tt_TMP_TBL_SUBSCRIBE where tbl_SubscribEvent.RecvProcID = #tt_TMP_TBL_SUBSCRIBE.RecvProcID
      and tbl_SubscribEvent.RecvProcHandle = #tt_TMP_TBL_SUBSCRIBE.RecvProcHandle
      and tbl_SubscribEvent.RecvTaskMgrID = #tt_TMP_TBL_SUBSCRIBE.RecvTaskMgrID
      and tbl_SubscribEvent.EventID = #tt_TMP_TBL_SUBSCRIBE.EventID)';
      EXECUTE IMMEDIATE ' TRUNCATE TABLE #tt_TMP_TBL_SUBSCRIBE ';
          execute immediate 'drop table #tt_TMP_TBL_SUBSCRIBE';
      execute immediate 'delete from tbl_EventBufferContextData where Serial in(select SerialContext from #tt_TBL_SERIALTMP)
      or FirstPacketSN in(select SerialContext from #tt_TBL_SERIALTMP)';
      execute immediate 'delete from tbl_EventBuffer where Serial in(select Serial from #tt_TBL_SERIALTMP)';
      execute immediate 'delete from tbl_ReceivedEvent where Serial in(select Serial from #tt_TBL_SERIALTMP)';

          execute immediate 'drop table if exists #tt_TBL_SERIALTMP';
      SWP_Ret_Value := 1;
      RETURN;
   end if;
   execute immediate 'drop table if exists #tt_TMP_TBL_SUBSCRIBE';
   SWP_Ret_Value := 0;
   RETURN;

commit;
end;
/
declare
a int;
begin
sp_ClearEventByRate(0,a);
end;
/

alter system set LOCAL_TEMPORARY_TABLE_ENABLED=true;
drop table if exists #fvt_table_job_012;
create TEMPORARY table #fvt_table_job_012(
		c_id bigint,
		c_clob blob,
		c_time date,
		c_num number(20,5),
		c_name char(100),
		c_boolean boolean
		);
create or replace procedure fvt_proc_job_012()
is
begin
	for i in 1..10000 loop
        execute immediate 'insert into #fvt_table_job_012 values('||i||',
		''123'',to_date(''2015-5-5'',''yyyy-mm-dd''),
		'||i||',''@126.com'',''true'')';
    end loop;
end;
/
call fvt_proc_job_012;
drop index if exists study_id_012 on #fvt_table_job_012;
create unique index study_id_012 on #fvt_table_job_012(c_id);
drop index if exists study_id1_012 on #fvt_table_job_012;
create unique index study_id1_012 on #fvt_table_job_012(c_id,c_num,c_name);
drop index if exists study_id2_012 ON #fvt_table_job_012;
CREATE INDEX study_id2_012 ON #fvt_table_job_012(upper(c_name));
drop index if exists study_id3_012 ON #fvt_table_job_012;
CREATE INDEX study_id3_012 ON #fvt_table_job_012(upper(c_id));


ANALYZE TABLE #fvt_table_job_012 COMPUTE STATISTICS;

drop table if exists tongep_temp_table_analyze_error;
create global temporary table tongep_temp_table_analyze_error(a int);
create index tongep_idx_temp on tongep_temp_table_analyze_error(a);
analyze index tongep_idx_temp on tongep_temp_table_analyze_error compute statistics;
drop table if exists tongep_temp_table_analyze_error;

drop table if exists tongep_empty_index;
drop index if exists tongep_idx_temp on tongep_temp_table_analyze_error;
create table tongep_empty_index(a int);
create index idx_empty_index on tongep_empty_index(a);
analyze index idx_empty_index on tongep_empty_index compute statistics;
select BLEVEL, LEVEL_BLOCKS, DISTINCT_KEYS, AVG_LEAF_BLOCKS_PER_KEY, AVG_DATA_BLOCKS_PER_KEY, EMPTY_LEAF_BLOCKS from sys_indexes where name = 'IDX_EMPTY_INDEX';
insert into tongep_empty_index values(1);
delete from tongep_empty_index;
analyze index idx_empty_index on tongep_empty_index compute statistics;
select BLEVEL, LEVEL_BLOCKS, DISTINCT_KEYS, AVG_LEAF_BLOCKS_PER_KEY, AVG_DATA_BLOCKS_PER_KEY, EMPTY_LEAF_BLOCKS from sys_indexes where name = 'IDX_EMPTY_INDEX';
drop table if exists tongep_empty_index;
drop table if exists tongep_part_empty_index;
create table tongep_part_empty_index(a int, b int) 
partition by range(a)
(
    partition part1 values less than(5),
    partition part2 values less than(10)
);
create index idx_part_empty_index on tongep_part_empty_index(a) local;
create index idx_part_global_index on tongep_part_empty_index(b);
analyze index idx_part_empty_index on tongep_part_empty_index compute statistics;
select BLEVEL, LEVEL_BLOCKS, DISTINCT_KEYS, AVG_LEAF_BLOCKS_PER_KEY, AVG_DATA_BLOCKS_PER_KEY, EMPTY_LEAF_BLOCKS from sys_indexes where name = 'IDX_PART_EMPTY_INDEX';
insert into tongep_part_empty_index values(1, 1);
insert into tongep_part_empty_index values(7, 7);
alter table tongep_part_empty_index drop partition part1;
analyze index idx_part_global_index on tongep_part_empty_index compute statistics;
delete from tongep_part_empty_index;
analyze index idx_part_empty_index on tongep_part_empty_index compute statistics;
select BLEVEL, LEVEL_BLOCKS, DISTINCT_KEYS, AVG_LEAF_BLOCKS_PER_KEY, AVG_DATA_BLOCKS_PER_KEY, EMPTY_LEAF_BLOCKS from sys_indexes where name = 'IDX_PART_EMPTY_INDEX';
exec DBE_STATS.PURGE_STATS(sysdate);

select VALUE from DV_PARAMETERS where name = 'STATS_MAX_BUCKET_SIZE';
alter system set STATS_MAX_BUCKET_SIZE = 0;
alter system set STATS_MAX_BUCKET_SIZE = 300;
drop table if exists test_statistics_1;

create table test_statistics_1 (a int);

insert into test_statistics_1 values(1);
insert into test_statistics_1 (a) select a + 1 from test_statistics_1;
insert into test_statistics_1 (a) select a + 2 from test_statistics_1;
insert into test_statistics_1 (a) select a + 4 from test_statistics_1;
insert into test_statistics_1 (a) select a + 8 from test_statistics_1;
insert into test_statistics_1 (a) select a + 16 from test_statistics_1;
insert into test_statistics_1 (a) select a + 32 from test_statistics_1;
insert into test_statistics_1 (a) select a + 64 from test_statistics_1;
insert into test_statistics_1 (a) select a + 64 from test_statistics_1;
commit;
alter system set STATS_MAX_BUCKET_SIZE = 75;
analyze table test_statistics_1 compute statistics;
select NUM_DISTINCT, NUM_NULLS, HISTOGRAM from dba_tab_columns where TABLE_NAME = 'TEST_STATISTICS_1';
alter system set STATS_MAX_BUCKET_SIZE = 250;
analyze table test_statistics_1 compute statistics;
select NUM_DISTINCT, NUM_NULLS, HISTOGRAM from dba_tab_columns where TABLE_NAME = 'TEST_STATISTICS_1';
alter system set STATS_MAX_BUCKET_SIZE = 254;

drop table if exists test_index_diskey;
create table test_index_diskey (name varchar(16));
create index idx_diskey on test_index_diskey(name);
insert into test_index_diskey values('is0');
begin
        for i in 1..250 loop
        insert into test_index_diskey values('is1');
    end loop;
end;
/
analyze index idx_diskey on test_index_diskey compute statistics;
select distinct_keys from sys_indexes where name = upper('idx_diskey');
drop table test_index_diskey;

drop table if exists fvt_gather_table_01;
create table fvt_gather_table_01
(c_int int,c_num number(10,1),c_name varchar(80),c_clob clob,c_bllo boolean)
partition by range(c_int)
(partition p1 values less than (1),
partition p2 values less than (11),
partition p3 values less than (1011),
partition p4 values less than (101011)
);

begin
for i in 0..101001
loop
insert into fvt_gather_table_01 values(i,i,'abs'||i,'clo'||i,'true') ;
end loop;
end;
/

drop index if exists fvt_index_1 on fvt_gather_table_01;
create unique index fvt_index_1 on fvt_gather_table_01(c_int);

select bytes/1024/1024 from adm_segments where segment_name='FVT_GATHER_TABLE_01';
exec dbe_stats.collect_table_stats(
schema =>'SYS',
name =>'FVT_GATHER_TABLE_01',
part_name =>'P4',
sample_ratio =>10,
method_opt =>'for all indexed columns');
drop table if exists fvt_gather_table_01;
create table fvt_gather_table_01
(c_int int,c_num number(10,1),c_name varchar(80),c_clob clob,c_bllo boolean)
partition by range(c_int)
(partition p1 values less than (1),
partition p2 values less than (11),
partition p3 values less than (1011),
partition p4 values less than (101011)
);


begin
for i in 0..101001
loop
insert into fvt_gather_table_01 values(i,i,'abs'||i,'clo'||i,'true') ;
end loop;
end;
/

drop index if exists fvt_index_1 on fvt_gather_table_01;
create unique index fvt_index_1 on fvt_gather_table_01(c_int);

select bytes/1024/1024 from adm_segments where segment_name='FVT_GATHER_TABLE_01';
exec dbe_stats.collect_table_stats(
schema =>'SYS',
name =>'FVT_GATHER_TABLE_01',
part_name =>'P4',
sample_ratio =>10,
method_opt =>'for all indexed columns');
select count(*) from fvt_gather_table_01;
exec dbe_stats.collect_table_stats(
schema =>'SYS',
name =>'FVT_GATHER_TABLE_01',
part_name =>'P2',
sample_ratio =>50,
method_opt =>'for all columns');

select a.COL#,a.bucket_num,a.row_num,a.minvalue,a.maxvalue,a.dist_num from sys.sys_histgram_abstr a,sys.sys_tables b where a.tab#=b.id and
b.name=upper('fvt_gather_table_01')and a.USER#=b.USER# and b.user#=( select id from sys.SYS_USERS where name='SYS' ) and a.spare1 = 20 order by 1,2,3,4,5,6;

drop table if exists test_sample_size;
create table test_sample_size(a int);
create index idx_sample_size on test_sample_size(a);
insert into test_sample_size values(1);
analyze index idx_sample_size on test_sample_size compute statistics;
select samplesize from sys.sys_indexes where name = 'IDX_SAMPLE_SIZE';

drop table if exists hzy_high_ndv1;
drop table if exists hzy_ndv1;
create table hzy_ndv1(a int);
insert into hzy_ndv1 values(0);
create table hzy_high_ndv1(a int)
partition by range(A)
interval(250)
(
   partition p_ndv1 values less than (100),
   partition p_ndv2 values less than (300),
   partition p_ndv3 values less than (600)
);

CREATE or replace procedure storage_proc_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    insert into hzy_high_ndv1 select a+i from hzy_ndv1;
  END LOOP;
END;
/
call storage_proc_000(1,1000);
call storage_proc_000(1,100);
call storage_proc_000(1,100);
call storage_proc_000(20,300);
commit;

exec dbe_stats.collect_table_stats('SYS', 'hzy_high_ndv1', 'p_ndv3');
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY,SPARE1 from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_NDV1')
ORDER BY SPARE1;

exec dbe_stats.collect_table_stats('SYS', 'hzy_high_ndv1', 'p_ndv1');
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY,SPARE1 from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_NDV1')
ORDER BY SPARE1;

exec dbe_stats.collect_table_stats('SYS', 'hzy_high_ndv1', 'p_ndv2');
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY,SPARE1 from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_NDV1')
ORDER BY SPARE1;

delete from hzy_high_ndv1 where a < 600;
commit;

exec dbe_stats.collect_table_stats('SYS', 'hzy_high_ndv1', 'p_ndv3');
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY,SPARE1 from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_NDV1')
ORDER BY SPARE1;

exec dbe_stats.collect_table_stats('SYS', 'hzy_high_ndv1');
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY,SPARE1 from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_NDV1')
ORDER BY SPARE1;

drop table if exists test_statistics_2;
create tablespace maos_spc datafile 'hzybitmap_spc' size 32M autoextend on next 16M extent autoallocate ;
create table test_statistics_2 (id int, name varchar(20)) TABLESPACE maos_spc;
insert into test_statistics_2 values(0, 'it is a long string');
insert into test_statistics_2 select id + 1, name from test_statistics_2;
insert into test_statistics_2 select id + 2, name from test_statistics_2;
insert into test_statistics_2 select id + 4, name from test_statistics_2;
insert into test_statistics_2 select id + 8, name from test_statistics_2;
insert into test_statistics_2 select id + 16, name from test_statistics_2;
insert into test_statistics_2 select id + 32, name from test_statistics_2;
insert into test_statistics_2 select id + 64, name from test_statistics_2;
insert into test_statistics_2 select id + 120, name from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
commit;
exec dbe_stats.collect_table_stats('SYS', 'TEST_STATISTICS_2', part_name=>NULL,sample_ratio => 90,method_opt=>'for all columns');
drop tablespace maos_spc including contents and datafiles;

drop table if exists test_stats_1;
create table test_stats_1 (a int);
insert into test_stats_1 values(1);
insert into test_stats_1 (a) select a + 1 from test_stats_1;
insert into test_stats_1 (a) select a + 2 from test_stats_1;
insert into test_stats_1 (a) select a + 4 from test_stats_1;
insert into test_stats_1 (a) select a + 8 from test_stats_1;
insert into test_stats_1 (a) select a + 16 from test_stats_1;
insert into test_stats_1 (a) select a + 32 from test_stats_1;
insert into test_stats_1 (a) select a + 64 from test_stats_1;
commit;
create index index1 on test_stats_1(a);

analyze table test_stats_1 compute statistics;
select NUM_ROWS, BLOCKS, AVG_ROW_LEN from sys_tables where name = 'TEST_STATS_1';

drop table if exists test_interval1;
create table test_interval1(f1 int, f2 int, f3 char(30))
PARTITION BY RANGE(f2)
INTERVAL(5)
(
 PARTITION test_interval1p1 values less than(10),
 PARTITION test_interval1p2 values less than(20),
 PARTITION test_interval1p3 values less than(30)
);
insert into test_interval1 values(1,5,'hzy');
insert into test_interval1 values(2,15,'hzy1');
insert into test_interval1 values(3,25,'hzy2');
insert into test_interval1 values(4,35,'hzy3');
insert into test_interval1 values(5,115,'hzy66');
insert into test_interval1 values(6,55,'6hzy');
insert into test_interval1 values(7,65,'hezy');
insert into test_interval1 values(8,75,'hzfdy');
insert into test_interval1 values(9,85,'hzyf');
insert into test_interval1 values(10,95,'hzyd');
insert into test_interval1 values(11,105,'hzy');
insert into test_interval1 select * from test_interval1;
insert into test_interval1 select * from test_interval1;
commit;
create index index2 on test_interval1(f1);

analyze table test_interval1 compute statistics;
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN from sys.SYS_TABLE_PARTS where name = 'TEST_INTERVAL1P1';

--DTS2019121209311
drop table if exists fvt_partition_04;
create table fvt_partition_04(
                c_id int PRIMARY KEY,
                c_clob clob,
                c_time timestamp,
                c_num decimal(10,5),
                c_name varchar(10)
                ) PARTITION BY RANGE(c_id)
(
PARTITION p1 values less than(5),
PARTITION p2 values less than(10),
PARTITION p3 values less than(20),
PARTITION p4 values less than(MAXVALUE)
);
drop index if exists fvt_partition_index_04 on fvt_partition_04;
create unique index fvt_partition_index_04 on fvt_partition_04(c_num);
drop index if exists fvt_partition_index_4 on fvt_partition_04;
create index fvt_partition_index_4 on fvt_partition_04(c_time,c_name,c_num);
drop index if exists fvt_partition_index_004 on fvt_partition_04;
create index fvt_partition_index_004  on fvt_partition_04 (c_time,c_name) local (partition p1,partition p2,partition p3,partition p4);
declare
a number;
b number;
c number;
d number;
begin
        for i in 1..30 loop
                b:=i+2015;
                c:=i-i+1;
                d:=i+10-i;
        execute immediate 'insert into fvt_partition_04 values('||i*i||',
                ''*"%*%$3rfr'||i||'*656^5$34@%^&*()%'',to_date('''||b||'-'||c||'-'||d||''',''yyyy-mm-dd''),
                '||(-i)*i||','''||i||'qs'')';
    end loop;
end;
/

analyze table fvt_partition_04 compute statistics;

drop table if exists test_interval1;
create table test_interval1(f1 int, f2 int, f3 char(30))
PARTITION BY RANGE(f2)
INTERVAL(5)
(
 PARTITION test_interval1p1 values less than(10),
 PARTITION test_interval1p2 values less than(20),
 PARTITION test_interval1p3 values less than(30)
);
insert into test_interval1 values(1,5,'hzy');
insert into test_interval1 values(2,15,'hzy1');
insert into test_interval1 values(3,25,'hzy2');
insert into test_interval1 values(4,35,'hzy3');
insert into test_interval1 values(5,115,'hzy66');
insert into test_interval1 values(6,55,'6hzy');
insert into test_interval1 values(7,65,'hezy');
insert into test_interval1 values(8,75,'hzfdy');
insert into test_interval1 values(9,85,'hzyf');
insert into test_interval1 values(10,95,'hzyd');
insert into test_interval1 values(11,105,'hzy');
insert into test_interval1 select * from test_interval1;
insert into test_interval1 select * from test_interval1;
commit;
create index index2 on test_interval1(f1)local;

analyze table test_interval1 compute statistics;

--DTS2019121209172
drop table if exists fvt_partition_05;
create table fvt_partition_05(
                c_id int PRIMARY KEY,
                c_clob clob,
                c_time timestamp,
                c_num decimal(10,5),
                c_name varchar(10 char)
                ) PARTITION BY RANGE(c_id) interval (500)
(
PARTITION p1 values less than(100),
PARTITION p2 values less than(200),
PARTITION p3 values less than(300));
drop index if exists fvt_partition_index_05 on fvt_partition_05;
create unique index fvt_partition_index_05 on fvt_partition_05(c_num);
drop index if exists fvt_partition_index_5 on fvt_partition_05;
create index fvt_partition_index_5 on fvt_partition_05(c_time,c_name,c_num);
drop index if exists fvt_partition_index_005 on fvt_partition_05;
create index fvt_partition_index_005  on fvt_partition_05 (c_time,c_name) local (partition p1,partition p2,partition p3);

declare
a number;
b number;
c number;
d number;
begin
        for i in 1..30 loop
                b:=i+2015;
                c:=i-i+1;
                d:=i+10-i;
        execute immediate 'insert into fvt_partition_05 values('||i*i||',
                ''*"%*%$3rfr'||i||'*656^5$34@%^&*()%'',to_date('''||b||'-'||c||'-'||d||''',''yyyy-mm-dd''),
                '||(-i)*i||','''||i||'@.com'')';
    end loop;
end;
/

analyze table fvt_partition_05 compute statistics;

drop table if exists tbl_Result_1911816254_3;
create table tbl_Result_1911816254_3
(StartTime int,ObjectNo int)
PARTITION BY RANGE(StartTime)
(
 PARTITION p1 values less than(100),
 PARTITION p2 values less than(200),
 PARTITION p3 values less than(300),
 PARTITION p4 values less than(maxvalue)
);

begin
for i in 0..10100
loop
insert into tbl_Result_1911816254_3 values(i,i) ;
end loop;
end;
/
commit;

drop table if exists tmp_nic_61;
create table tmp_nic_61 (ObjectNo int);

begin
for i in 0..100
loop
insert into tmp_nic_61 values(i) ;
end loop;
end;
/
commit;

select a.StartTime , a.ObjectNo from tbl_Result_1911816254_3 a, tmp_nic_61 b where (a.StartTime >= 100 and a.StartTime < 200 and (a.ObjectNo = b.ObjectNo))  order by a.StartTime  ASC, a.ObjectNo;

drop table if exists hzy_num_rows;
create table hzy_num_rows (C_ID INT) 
partition by range(c_id) 
  ( partition part_1 values less than(10),
  partition part_2 values less than(20),
  partition part_3 values less than(31));
 
insert into hzy_num_rows values(0);  
commit;
  
CREATE or replace procedure hzy_num_rows_proc(startall int,endall int)  as
i INT;
BEGIN
  FOR i IN startall..endall LOOP
		insert into hzy_num_rows (c_id) select c_id + i from  hzy_num_rows where c_id = 0;commit;
        END LOOP;
END;
/
call hzy_num_rows_proc(1,30);
commit;
select count(*) from hzy_num_rows;
analyze table hzy_num_rows compute statistics;
select a.NUM_ROWS,a.PARTITIONED from table$ a where a.name='HZY_NUM_ROWS';
delete from HZY_NUM_ROWS where c_id > 10 and c_id < 15;
call dbe_stats.collect_table_stats('SYS','HZY_NUM_ROWS','part_2');
select a.NUM_ROWS,a.PARTITIONED from table$ a where a.name='HZY_NUM_ROWS';

drop table if exists test_result_1;
create table test_result_1 (
StartTime date not null, 
StartTimeDstOffset number(5) not null,
SvrStartTime date not null,
STSvrDstOffset number(5) not null,
EndTime date not null,
EndTimeDstOffset number(5) not null,
SvrEndTime date not null,
ETSvrDstOffset number(5) not null,
InsertTime date,
TimezoneOffset number(5) not null,
ObjectNo number(10) not null,
GranulityPeriod number(5), 
ResultReliablityFlag number(5),
Counter_1526728850 number(12, 3) null)
PARTITION BY RANGE (StartTime) (
PARTITION P20200213 VALUES LESS THAN (TO_DATE('2020-02-13 00:00:00', 'YYYY-MM-DD HH24:MI:SS')), 
PARTITION P20200214 VALUES LESS THAN (TO_DATE('2020-02-14 00:00:00', 'YYYY-MM-DD HH24:MI:SS')), 
PARTITION P20200215 VALUES LESS THAN (TO_DATE('2020-02-15 00:00:00', 'YYYY-MM-DD HH24:MI:SS')), 
PARTITION P20200216 VALUES LESS THAN (TO_DATE('2020-02-16 00:00:00', 'YYYY-MM-DD HH24:MI:SS')), 
PARTITION P20200217 VALUES LESS THAN (TO_DATE('2020-02-17 00:00:00', 'YYYY-MM-DD HH24:MI:SS')), 
PARTITION P20200218 VALUES LESS THAN (TO_DATE('2020-02-18 00:00:00', 'YYYY-MM-DD HH24:MI:SS')), 
PARTITION P20200219 VALUES LESS THAN (TO_DATE('2020-02-19 00:00:00', 'YYYY-MM-DD HH24:MI:SS')), 
PARTITION P20200220 VALUES LESS THAN (TO_DATE('2020-02-20 00:00:00', 'YYYY-MM-DD HH24:MI:SS')));

create unique index ST_test_result_1 on test_result_1 (StartTime, ObjectNo, StartTimeDstOffset) local;
create index SS_test_result_1 on test_result_1 (SvrStartTime, ObjectNo, STSvrDstOffset) local;
create index IT_test_result_1 on test_result_1 (InsertTime) local;
insert into test_result_1 values('2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,2,60,1,1);
insert into test_result_1 values('2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,3,60,1,1);
insert into test_result_1 values('2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,4,60,1,1);
insert into test_result_1 values('2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,5,60,1,1);
insert into test_result_1 values('2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,6,60,1,1);
insert into test_result_1 values('2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,7,60,1,1);
insert into test_result_1 values('2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,8,60,1,1);
insert into test_result_1 values('2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,9,60,1,1);
commit;

drop table if exists  chenlei_test;
create table chenlei_test(OBJECTNO int,OBJECTINDEX int);
insert into chenlei_test values(2,1);
insert into chenlei_test values(1,1);
insert into chenlei_test values(4,1);
insert into chenlei_test values(3,1);
insert into chenlei_test values(52,1);
commit;

select a.StartTime , a.ObjectNo, a.GranulityPeriod , a.ResultReliablityFlag , a.Counter_1526728850 
from test_result_1 a, chenlei_test b where (a.StartTime >= to_date('2020-02-13 10:55:30','YYYY-MM-DD HH24:MI:SS') and a.StartTime < to_date('2020-02-14 10:55:30','YYYY-MM-DD HH24:MI:SS') and (a.ObjectNo = b.ObjectNo)) order by a.StartTime ASC, a.ObjectNo; 
drop table if exists test_result_1;
drop table if exists  chenlei_test;

drop table if exists test_result_1;
create table test_result_1 (
StartTime date not null, 
StartTimeDstOffset number(5) not null,
SvrStartTime date not null,
STSvrDstOffset number(5) not null,
EndTime date not null,
EndTimeDstOffset number(5) not null,
SvrEndTime date not null,
ETSvrDstOffset number(5) not null,
InsertTime date,
TimezoneOffset number(5) not null,
ObjectNo number(10) not null,
GranulityPeriod number(5), 
ResultReliablityFlag number(5),
Counter_1526728850 number(12, 3) null)
PARTITION BY RANGE (StartTime) (
PARTITION P20200213 VALUES LESS THAN (TO_DATE('2020-02-13 00:00:00', 'YYYY-MM-DD HH24:MI:SS')), 
PARTITION P20200214 VALUES LESS THAN (TO_DATE('2020-02-14 00:00:00', 'YYYY-MM-DD HH24:MI:SS')), 
PARTITION P20200215 VALUES LESS THAN (TO_DATE('2020-02-15 00:00:00', 'YYYY-MM-DD HH24:MI:SS')), 
PARTITION P20200216 VALUES LESS THAN (TO_DATE('2020-02-16 00:00:00', 'YYYY-MM-DD HH24:MI:SS')), 
PARTITION P20200217 VALUES LESS THAN (TO_DATE('2020-02-17 00:00:00', 'YYYY-MM-DD HH24:MI:SS')), 
PARTITION P20200218 VALUES LESS THAN (TO_DATE('2020-02-18 00:00:00', 'YYYY-MM-DD HH24:MI:SS')), 
PARTITION P20200219 VALUES LESS THAN (TO_DATE('2020-02-19 00:00:00', 'YYYY-MM-DD HH24:MI:SS')), 
PARTITION P20200220 VALUES LESS THAN (TO_DATE('2020-02-20 00:00:00', 'YYYY-MM-DD HH24:MI:SS')));

create unique index ST_test_result_1 on test_result_1 (StartTime, StartTimeDstOffset) local;
create index SS_test_result_1 on test_result_1 (SvrStartTime, STSvrDstOffset) local;
create index IT_test_result_1 on test_result_1 (InsertTime) local;
insert into test_result_1 values('2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,2,60,1,1);
insert into test_result_1 values('2020-02-14 00:04:01',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,3,60,1,1);
insert into test_result_1 values('2020-02-14 00:04:02',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,4,60,1,1);
insert into test_result_1 values('2020-02-14 00:04:03',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,5,60,1,1);
insert into test_result_1 values('2020-02-14 00:04:04',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,6,60,1,1);
insert into test_result_1 values('2020-02-14 00:04:05',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,7,60,1,1);
insert into test_result_1 values('2020-02-14 00:04:06',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,8,60,1,1);
insert into test_result_1 values('2020-02-14 00:04:07',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,9,60,1,1);
commit;

 exec  dbe_stats.collect_table_stats(
schema => 'sys',
name => 'test_result_1',
sample_ratio => 50,
method_opt=>'for all indexed columns');

drop table if exists  chenlei_test;
create table chenlei_test(OBJECTNO int,OBJECTINDEX int);
insert into chenlei_test values(2,1);
insert into chenlei_test values(1,1);
insert into chenlei_test values(4,1);
insert into chenlei_test values(3,1);
insert into chenlei_test values(52,1);
commit;

select a.StartTime , a.ObjectNo, a.GranulityPeriod , a.ResultReliablityFlag , a.Counter_1526728850 
from test_result_1 a, chenlei_test b where (a.StartTime <= to_date('2020-02-14 00:00:00','YYYY-MM-DD HH24:MI:SS') and a.StartTime < to_date('2020-02-14 10:55:30','YYYY-MM-DD HH24:MI:SS') and (a.ObjectNo = b.ObjectNo)) order by a.StartTime ASC, a.ObjectNo; 
drop table if exists test_result_1;
drop table if exists  chenlei_test;

-- test trans gtt dynamic stats
drop temporary table if exists gtt1_tran;
create global temporary table gtt1_tran(a int, b bigint, c number, d date, e timestamp, f real, g char(10), h clob, i varchar(10));
create index idx1_gtt1_tran on gtt1_tran(a);
create index idx2_gtt1_tran on gtt1_tran(a, g);
create index idx3_gtt1_tran on gtt1_tran(a, b);

drop temporary table if exists gtt1_session;
create global temporary table gtt1_session(a int, b bigint, c number, d date, e timestamp, f real, g char(10), h clob, i varchar(10)) on commit preserve rows;
create index idx1_gtt1_session on gtt1_session(a);
create index idx2_gtt1_session on gtt1_session(a, g);
create index idx3_gtt1_session on gtt1_session(a, b);

analyze table gtt1_tran compute statistics;
select NAME,NUM_ROWS,BLOCKS,AVG_ROW_LEN from dv_temp_table_stats where name = 'GTT1_TRAN';
select tab.NAME, col.NAME, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE, HISTOGRAM from dv_temp_column_stats col, dv_temp_table_stats tab where tab.user# = col.user# and tab.ID = col.TABLE# and tab.NAME = 'GTT1_TRAN';
select idx.NAME, BLEVEL, LEVEL_BLOCKS, CLUFAC, DISTINCT_KEYS, COMB_COLS_2_NDV, COMB_COLS_3_NDV, COMB_COLS_4_NDV, AVG_LEAF_BLOCKS_PER_KEY, AVG_DATA_BLOCKS_PER_KEY from dv_temp_index_stats idx, dv_temp_table_stats tab where tab.user# = idx.user# and tab.ID = idx.TABLE# and tab.NAME = 'GTT1_TRAN';

insert into gtt1_tran values(1,213545678100, 12312.122, '1990-11-30', '1992-02-09 15:12:36', 11272.264, 'aaaaaaaaaa','aaaaaaaaaaa','aaaaa');
insert into gtt1_tran values(2,213545678120, 22312.122, '1992-11-30', '1992-02-09 20:12:36', 21272.264, 'ccccaaaaaa','aaaaaaaaaaa','aaaaaaaa');
insert into gtt1_tran values(null,null,null,null,null,null,null,null,null);

insert into gtt1_session values(1,213545678100, 12312.122, '1990-11-30', '1992-02-09 15:12:36', 11272.264, 'aaaaaaaaaa','aaaaaaaaaaa','aaaaa');
insert into gtt1_session values(4,213545678140, 42312.122, '1994-11-30', '1993-02-09 15:12:38', 41272.264, 'fffffaaaaa','aaaaaaaaaaa','bbbbb');

-- trigger dynamic stats
select gtt1_tran.a from gtt1_tran, gtt1_session where gtt1_tran.a = gtt1_session.a;
select NAME,NUM_ROWS,BLOCKS,AVG_ROW_LEN from dv_temp_table_stats where name = 'GTT1_TRAN';
select col.NAME, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE, HISTOGRAM from dv_temp_column_stats col, dv_temp_table_stats tab where tab.user# = col.user# and tab.ID = col.TABLE# and tab.NAME = 'GTT1_TRAN';
select idx.NAME, BLEVEL, LEVEL_BLOCKS, CLUFAC, DISTINCT_KEYS, COMB_COLS_2_NDV, COMB_COLS_3_NDV, COMB_COLS_4_NDV, AVG_LEAF_BLOCKS_PER_KEY, AVG_DATA_BLOCKS_PER_KEY from dv_temp_index_stats idx, dv_temp_table_stats tab where tab.user# = idx.user# and tab.ID = idx.TABLE# and tab.NAME = 'GTT1_TRAN';

select NAME,NUM_ROWS,BLOCKS,AVG_ROW_LEN from dv_temp_table_stats where name = 'GTT1_SESSION';
select col.NAME, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE, HISTOGRAM from dv_temp_column_stats col, dv_temp_table_stats tab where tab.user# = col.user# and tab.ID = col.TABLE# and tab.NAME = 'GTT1_SESSION';
select idx.NAME, BLEVEL, LEVEL_BLOCKS, CLUFAC, DISTINCT_KEYS, COMB_COLS_2_NDV, COMB_COLS_3_NDV, COMB_COLS_4_NDV, AVG_LEAF_BLOCKS_PER_KEY, AVG_DATA_BLOCKS_PER_KEY from dv_temp_index_stats idx, dv_temp_table_stats tab where tab.user# = idx.user# and tab.ID = idx.TABLE# and tab.NAME = 'GTT1_SESSION';

-- stats info don't save in sys tables triggered by dynamic stats
select name, num_rows, blocks from sys_tables where name = 'GTT1_TRAN';
select name, num_rows, blocks from sys_tables where name = 'GTT1_SESSION';

-- modify table
insert into gtt1_tran values(4,213545678140, 42312.122, '1994-11-30', '1993-02-09 15:12:38', 41272.264, 'fffffaaaaa','aaaaaaaaaaa','bbbbb');
insert into gtt1_tran values(5,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into gtt1_tran values(6,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'fgggaaaaaa','aaaaaaaaaaa','ccccc');
insert into gtt1_tran values(7,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','bbb');
insert into gtt1_tran values(8,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into gtt1_tran values(9,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into gtt1_tran values(10,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into gtt1_tran values(10,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','aaaaaa');

insert into gtt1_session values(5,213545678150, 52312.122, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'fgggaaaaaa','aaaaaaaaaaa','ccccc');
insert into gtt1_session values(6,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','bbb');
insert into gtt1_session values(7,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into gtt1_session values(8,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','bbb');
insert into gtt1_session values(9,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into gtt1_session values(9,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into gtt1_session values(9,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into gtt1_session values(9,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into gtt1_session values(9,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into gtt1_session values(9,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','aaaaaa');
-- trigger dynamic stats again becaues of modify rate exceed 80%
select gtt1_tran.a from gtt1_tran, gtt1_session where gtt1_tran.a = gtt1_session.a;
select NAME,NUM_ROWS,BLOCKS,AVG_ROW_LEN from dv_temp_table_stats where name = 'GTT1_TRAN';
select NAME,NUM_ROWS,BLOCKS,AVG_ROW_LEN from dv_temp_table_stats where name = 'GTT1_SESSION';

analyze table gtt1_tran compute statistics;
analyze table gtt1_session compute statistics;

-- analyze is ddl sql, will commit the trans.
select NAME,NUM_ROWS,BLOCKS,AVG_ROW_LEN from dv_temp_table_stats where name = 'GTT1_TRAN';
select col.NAME, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE, HISTOGRAM from dv_temp_column_stats col, dv_temp_table_stats tab where tab.user# = col.user# and tab.ID = col.TABLE# and tab.NAME = 'GTT1_TRAN';
select idx.NAME, BLEVEL, LEVEL_BLOCKS, CLUFAC, DISTINCT_KEYS, COMB_COLS_2_NDV, COMB_COLS_3_NDV, COMB_COLS_4_NDV, AVG_LEAF_BLOCKS_PER_KEY, AVG_DATA_BLOCKS_PER_KEY from dv_temp_index_stats idx, dv_temp_table_stats tab where tab.user# = idx.user# and tab.ID = idx.TABLE# and tab.NAME = 'GTT1_TRAN';

select NAME,NUM_ROWS,BLOCKS,AVG_ROW_LEN from dv_temp_table_stats where name = 'gtt1_session';
select col.NAME, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE, HISTOGRAM from dv_temp_column_stats col, dv_temp_table_stats tab where tab.user# = col.user# and tab.ID = col.TABLE# and tab.NAME = 'gtt1_session';
select idx.NAME, BLEVEL, LEVEL_BLOCKS, CLUFAC, DISTINCT_KEYS, COMB_COLS_2_NDV, COMB_COLS_3_NDV, COMB_COLS_4_NDV, AVG_LEAF_BLOCKS_PER_KEY, AVG_DATA_BLOCKS_PER_KEY from dv_temp_index_stats idx, dv_temp_table_stats tab where tab.user# = idx.user# and tab.ID = idx.TABLE# and tab.NAME = 'gtt1_session';
-- manual stats info of session gtt will be saved in sys table session
select name, num_rows, blocks from sys_tables where name = 'GTT1_TRAN';
select name, num_rows, blocks from sys_tables where name = 'GTT1_SESSION';

delete from gtt1_session where a > 1;
select count(*) from gtt1_session;
insert into gtt1_tran values(4,213545678140, 42312.122, '1994-11-30', '1993-02-09 15:12:38', 41272.264, 'fffffaaaaa','aaaaaaaaaaa','bbbbb');
-- trigger dynamic stats again, only gtt1_tran will be analyzed. Because manual stats info in sys table of GTT1_SESSION, so it will be not analyzed when triggering dynamic stats.
select gtt1_tran.a from gtt1_tran, gtt1_session where gtt1_tran.a = gtt1_session.a;
select NAME,NUM_ROWS,BLOCKS,AVG_ROW_LEN from dv_temp_table_stats where name = 'GTT1_TRAN';
select NAME,NUM_ROWS,BLOCKS,AVG_ROW_LEN from dv_temp_table_stats where name = 'GTT1_SESSION';

drop table if exists hzy_parall_68;
create table hzy_parall_68 (
StartTime date not null, 
StartTimeDstOffset number(5) not null,
SvrStartTime date not null,
STSvrDstOffset number(5) not null,
EndTime date not null,
EndTimeDstOffset number(5) not null,
SvrEndTime date not null,
ETSvrDstOffset number(5) not null,
InsertTime date,
TimezoneOffset number(5) not null,
ObjectNo number(10) not null,
GranulityPeriod number(5), 
ResultReliablityFlag number(5),
Counter_1526728850 number(12, 3) null);

insert into hzy_parall_68 values('2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,2,60,1,1);
insert into hzy_parall_68 values('2020-02-14 00:04:01',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,3,60,1,1);
insert into hzy_parall_68 values('2020-02-14 00:04:02',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,4,60,1,1);
insert into hzy_parall_68 values('2020-02-14 00:04:03',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,5,60,1,1);
insert into hzy_parall_68 values('2020-02-14 00:04:04',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,6,60,1,1);
insert into hzy_parall_68 values('2020-02-14 00:04:05',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,7,60,1,1);
insert into hzy_parall_68 values('2020-02-14 00:04:06',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,8,60,1,1);
insert into hzy_parall_68 values('2020-02-14 00:04:07',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',0,'2020-02-14 00:04:00',480,9,60,1,1);
insert into hzy_parall_68 select * from hzy_parall_68;
insert into hzy_parall_68 select * from hzy_parall_68;
insert into hzy_parall_68 select * from hzy_parall_68;
commit;

 exec  dbe_stats.collect_table_stats(
schema => 'sys',
name => 'hzy_parall_68',
sample_ratio => 50,
method_opt=>'for all columns');

select  PARALLEL,FINISHED from DV_STATS_RESOURCE where SQL_TEXT like '%hzy_parall_68%';

alter system set cbo=off;
 exec  dbe_stats.collect_table_stats(
schema => 'sys',
name => 'hzy_resuo1',
sample_ratio => 50,
method_opt=>'for all columns');
select  PARALLEL,FINISHED from DV_STATS_RESOURCE where SQL_TEXT like '%hzy_resuo1%';

