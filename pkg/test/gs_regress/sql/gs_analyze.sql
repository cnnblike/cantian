drop table analyze_int;

create table analyze_int(a int);
-- 21
insert into analyze_int values(10);
insert into analyze_int values(11);
insert into analyze_int values(12);
insert into analyze_int values(13);
insert into analyze_int values(14);
insert into analyze_int values(15);
insert into analyze_int values(16);
insert into analyze_int values(17);
insert into analyze_int values(18);
insert into analyze_int values(19);
insert into analyze_int values(20);
insert into analyze_int values(21);
insert into analyze_int values(20);
insert into analyze_int values(21);
insert into analyze_int values(22);
insert into analyze_int values(23);
insert into analyze_int values(24);
insert into analyze_int values(25);
insert into analyze_int values(26);
insert into analyze_int values(27);
insert into analyze_int values(28);
insert into analyze_int values(29);
insert into analyze_int values(30);
-- 11
insert into analyze_int values(20);
insert into analyze_int values(21);
insert into analyze_int values(20);
insert into analyze_int values(21);
insert into analyze_int values(22);
insert into analyze_int values(23);
insert into analyze_int values(24);
insert into analyze_int values(25);
insert into analyze_int values(26);
insert into analyze_int values(27);
insert into analyze_int values(28);
insert into analyze_int values(29);
insert into analyze_int values(30);
-- 11
insert into analyze_int values(20);
insert into analyze_int values(21);
insert into analyze_int values(20);
insert into analyze_int values(21);
insert into analyze_int values(22);
insert into analyze_int values(23);
insert into analyze_int values(24);
insert into analyze_int values(25);
insert into analyze_int values(26);
insert into analyze_int values(27);
insert into analyze_int values(28);
insert into analyze_int values(29);
insert into analyze_int values(30);
analyze table analyze_int compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_INT') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'ANALYZE_INT');
drop table analyze_int;

drop table analyze_bigint;
create table analyze_bigint(a bigint);
-- 31
insert into analyze_bigint values(213545678100);
insert into analyze_bigint values(213545678101);
insert into analyze_bigint values(213545678102);
insert into analyze_bigint values(213545678103);
insert into analyze_bigint values(213545678104);
insert into analyze_bigint values(213545678105);
insert into analyze_bigint values(213545678106);
insert into analyze_bigint values(213545678107);
insert into analyze_bigint values(213545678108);
insert into analyze_bigint values(213545678109);
insert into analyze_bigint values(213545678110);
insert into analyze_bigint values(213545678111);
insert into analyze_bigint values(213545678112);
insert into analyze_bigint values(213545678113);
insert into analyze_bigint values(213545678114);
insert into analyze_bigint values(213545678115);
insert into analyze_bigint values(213545678116);
insert into analyze_bigint values(213545678117);
insert into analyze_bigint values(213545678118);
insert into analyze_bigint values(213545678119);
insert into analyze_bigint values(213545678120);
insert into analyze_bigint values(213545678121);
insert into analyze_bigint values(213545678122);
insert into analyze_bigint values(213545678123);
insert into analyze_bigint values(213545678124);
insert into analyze_bigint values(213545678125);
insert into analyze_bigint values(213545678126);
insert into analyze_bigint values(213545678127);
insert into analyze_bigint values(213545678128);
insert into analyze_bigint values(213545678129);
insert into analyze_bigint values(213545678130);
-- 21
insert into analyze_bigint values(213545678100);
insert into analyze_bigint values(213545678101);
insert into analyze_bigint values(213545678102);
insert into analyze_bigint values(213545678103);
insert into analyze_bigint values(213545678104);
insert into analyze_bigint values(213545678105);
insert into analyze_bigint values(213545678106);
insert into analyze_bigint values(213545678107);
insert into analyze_bigint values(213545678108);
insert into analyze_bigint values(213545678109);
insert into analyze_bigint values(213545678110);
insert into analyze_bigint values(213545678111);
insert into analyze_bigint values(213545678112);
insert into analyze_bigint values(213545678113);
insert into analyze_bigint values(213545678114);
insert into analyze_bigint values(213545678115);
insert into analyze_bigint values(213545678116);
insert into analyze_bigint values(213545678117);
insert into analyze_bigint values(213545678118);
insert into analyze_bigint values(213545678119);
insert into analyze_bigint values(213545678120);
-- 21
insert into analyze_bigint values(213545678110);
insert into analyze_bigint values(213545678111);
insert into analyze_bigint values(213545678112);
insert into analyze_bigint values(213545678113);
insert into analyze_bigint values(213545678114);
insert into analyze_bigint values(213545678115);
insert into analyze_bigint values(213545678116);
insert into analyze_bigint values(213545678117);
insert into analyze_bigint values(213545678118);
insert into analyze_bigint values(213545678119);
insert into analyze_bigint values(213545678120);
insert into analyze_bigint values(213545678121);
insert into analyze_bigint values(213545678122);
insert into analyze_bigint values(213545678123);
insert into analyze_bigint values(213545678124);
insert into analyze_bigint values(213545678125);
insert into analyze_bigint values(213545678126);
insert into analyze_bigint values(213545678127);
insert into analyze_bigint values(213545678128);
insert into analyze_bigint values(213545678129);
insert into analyze_bigint values(213545678130);
analyze table analyze_bigint compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_BIGINT') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'ANALYZE_BIGINT');
drop table analyze_bigint;

drop table analyze_number;
create table analyze_number(a number);
-- 15
insert into analyze_number values(12312.121);
insert into analyze_number values(12312.122);
insert into analyze_number values(12312.122);
insert into analyze_number values(12312.123);
insert into analyze_number values(12312.123);
insert into analyze_number values(12312.123);
insert into analyze_number values(12312.124);
insert into analyze_number values(12312.124);
insert into analyze_number values(12312.124);
insert into analyze_number values(12312.124);
insert into analyze_number values(12312.125);
insert into analyze_number values(12312.125);
insert into analyze_number values(12312.125);
insert into analyze_number values(12312.125);
insert into analyze_number values(12312.125);
analyze table analyze_number compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_NUMBER') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'ANALYZE_NUMBER');
drop table analyze_number;


drop table analyze_date;
create table analyze_date(a date);
-- 15
insert into analyze_date values('1992-02-09');
insert into analyze_date values('1993-02-09');
insert into analyze_date values('1993-02-09');
insert into analyze_date values('1994-02-09');
insert into analyze_date values('1994-02-09');
insert into analyze_date values('1994-02-09');
insert into analyze_date values('1995-02-09');
insert into analyze_date values('1995-02-09');
insert into analyze_date values('1995-02-09');
insert into analyze_date values('1995-02-09');
insert into analyze_date values('1995-02-19');
insert into analyze_date values('1995-02-19');
insert into analyze_date values('1995-02-19');
insert into analyze_date values('1995-02-19');
insert into analyze_date values('1995-02-19');
analyze table analyze_date compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_DATE') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY   from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'ANALYZE_DATE');
drop table analyze_date;


drop table analyze_timestamp;
create table analyze_timestamp(a timestamp);
-- 15
insert into analyze_timestamp values('1992-02-09 15:12:36');
insert into analyze_timestamp values('1992-02-09 15:22:36');
insert into analyze_timestamp values('1992-02-09 15:22:36');
insert into analyze_timestamp values('1992-02-09 15:32:36');
insert into analyze_timestamp values('1992-02-09 15:32:36');
insert into analyze_timestamp values('1992-02-09 15:32:36');
insert into analyze_timestamp values('1992-02-09 15:42:36');
insert into analyze_timestamp values('1992-02-09 15:42:36');
insert into analyze_timestamp values('1992-02-09 15:42:36');
insert into analyze_timestamp values('1992-02-09 15:42:36');
insert into analyze_timestamp values('1992-02-09 15:52:36');
insert into analyze_timestamp values('1992-02-09 15:52:36');
insert into analyze_timestamp values('1992-02-09 15:52:36');
insert into analyze_timestamp values('1992-02-09 15:52:36');
insert into analyze_timestamp values('2009-02-09 15:52:36');
insert into analyze_timestamp values('2009-02-09 15:52:36');
analyze table analyze_timestamp compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_TIMESTAMP') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY  from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'ANALYZE_TIMESTAMP');
drop table analyze_timestamp;



drop table analyze_real;
create table analyze_real(a real);
insert into analyze_real values(11272.264);
insert into analyze_real values(11372.264);
insert into analyze_real values(11372.264);
insert into analyze_real values(11472.264);
insert into analyze_real values(11472.264);
insert into analyze_real values(11472.264);
insert into analyze_real values(11572.264);
insert into analyze_real values(11572.264);
insert into analyze_real values(11572.264);
insert into analyze_real values(21372.264);
insert into analyze_real values(21272.264);
insert into analyze_real values(21372.264);
insert into analyze_real values(21372.964);
insert into analyze_real values(21272.964);
insert into analyze_real values(21372.964);
analyze table analyze_real compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_REAL') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'ANALYZE_REAL');
drop table analyze_real;

drop table analyze_char;
create table analyze_char(a char(10));
insert into analyze_char values('aaaaaaaaaa');
insert into analyze_char values('bbbbbaaaaa');
insert into analyze_char values('bbbbbaaaaa');
insert into analyze_char values('cccccaaaaa');
insert into analyze_char values('cccccaaaaa');
insert into analyze_char values('cccccaaaaa');
insert into analyze_char values('dddddaaaaa');
insert into analyze_char values('ddddaaaaa');
insert into analyze_char values('ddddaaaaa');
analyze table analyze_char compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_CHAR') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'ANALYZE_CHAR');
drop table analyze_char;


drop table analyze_lob;
create table analyze_lob(a clob);
insert into analyze_lob values('aaaaaaaaaa');
insert into analyze_lob values('bbbbbaaaaa');
insert into analyze_lob values('bbbbbaaaaa');
insert into analyze_lob values('ccccaaaaaa');
insert into analyze_lob values('ccccbaaaaa');
insert into analyze_lob values('ccdeebaaaaa');
insert into analyze_lob values('eeeeeeaaaaa');
insert into analyze_lob values('ddddddaaaaa');
analyze table analyze_lob compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_LOB') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'ANALYZE_LOB');
drop table analyze_lob;

drop table analyze_null;
create table analyze_null(a varchar(10));
insert into analyze_null values ('');
insert into analyze_null values ('');
-- 6
insert into analyze_null values(null);
insert into analyze_null values(null);
insert into analyze_null values(null);
insert into analyze_null values(null);
insert into analyze_null values(null);
insert into analyze_null values(null);
analyze table analyze_null compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_NULL') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'ANALYZE_NULL');
drop table analyze_null;

drop table analyze_index;
create table analyze_index (a char(10));
create index ix_analy001 on analyze_index(a);
insert into analyze_index values('aaaabbb');
insert into analyze_index values('bbcccc');
insert into analyze_index values('aaaabbb');
insert into analyze_index values('bbcccc');
insert into analyze_index values('bbb');
insert into analyze_index values('ccc');
insert into analyze_index values('ddd');
insert into analyze_index values('eee');
insert into analyze_index values('fff');
insert into analyze_index values('ggg');
insert into analyze_index values('hhh');
insert into analyze_index values('jjj');
insert into analyze_index values('iii');
insert into analyze_index values('ooo');
insert into analyze_index values('ppp');
insert into analyze_index values('qqqq');
insert into analyze_index values('vvvvv');
insert into analyze_index values('xxxx');
analyze table analyze_index compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_INDEX') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'ANALYZE_INDEX');
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'ANALYZE_INDEX');
drop table analyze_index;

drop table analyze_delete;
create table analyze_delete (a char(10));
create index ix_analy002 on analyze_delete(a);
insert into analyze_delete values('aaaabbb');
insert into analyze_delete values('bbcccc');
insert into analyze_delete values('aaaabbb');
insert into analyze_delete values('bbcccc');
insert into analyze_delete values('bbb');
insert into analyze_delete values('ccc');
insert into analyze_delete values('ddd');
insert into analyze_delete values('eee');
insert into analyze_delete values('fff');
insert into analyze_delete values('ggg');
insert into analyze_delete values('hhh');
analyze table analyze_delete compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_DELETE') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'ANALYZE_DELETE');
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'ANALYZE_DELETE');
delete from analyze_delete;
analyze table analyze_delete compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_DELETE') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'ANALYZE_DELETE');
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'ANALYZE_DELETE');
drop table analyze_delete;

drop table analyze_all;
create table analyze_all(a int, b bigint, c number, d date, e timestamp, f real, g char(10), h clob, i varchar(10));
create index ix_analy003 on analyze_all(a);
create index ix_analy004 on analyze_all(a, g);
create index ix_analy005 on analyze_all(a, b);
insert into analyze_all values(1,213545678100, 12312.122, '1990-11-30', '1992-02-09 15:12:36', 11272.264, 'aaaaaaaaaa','aaaaaaaaaaa','aaaaa');
insert into analyze_all values(2,213545678120, 22312.122, '1992-11-30', '1992-02-09 20:12:36', 21272.264, 'bbbbaaaaaa','aaaaaaaaaaa','aaaaaaa');
insert into analyze_all values(2,213545678120, 22312.122, '1992-11-30', '1992-02-09 20:12:36', 21272.264, 'ccccaaaaaa','aaaaaaaaaaa','aaaaaaaa');
insert into analyze_all values(3,213545678130, 32312.122, '1993-11-09', '1990-11-30 15:12:36', 31272.264, 'dddaaaaaaa','aaaaaaaaaaa','aaaaaaaaaa');
insert into analyze_all values(3,213545678130, 32312.122, '1993-11-09', '1990-11-30 15:12:36', 31272.264, 'dddddaaaaa','aaaaaaaaaaa','bbbbb');
insert into analyze_all values(3,213545678130, 32312.122, '1993-02-09', '1990-11-30 20:12:36', 31272.264, 'dddddaaaaa','aaaaaaaaaaa','bbb');
insert into analyze_all values(4,213545678140, 42312.122, '1994-11-30', '1993-02-09 15:12:38', 41272.264, 'fffffaaaaa','aaaaaaaaaaa','bbbbb');
insert into analyze_all values(4,213545678140, 42312.122, '1994-11-30', '1993-02-09 15:12:38', 41272.264, 'fffffaaaaa','aaaaaaaaaaa','bbbbb');
insert into analyze_all values(4,213545678140, 12312.222, '1994-02-09', '1993-02-09 15:12:39', 41272.264, 'fffffaaaaa','aaaaaaaaaaa','ccccc');
insert into analyze_all values(4,213545678140, 12312.222, '1994-02-09', '1993-02-09 15:12:39', 41272.264, 'ffffaaaaaa','aaaaaaaaaaa','ccccc');
insert into analyze_all values(5,213545678150, 52312.122, '1995-02-09', '1995-02-09 15:12:40', 41272.264, 'ffffaaaaaa','aaaaaaaaaaa','ccccc');
insert into analyze_all values(5,213545678150, 52312.122, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'fgggaaaaaa','aaaaaaaaaaa','ccccc');
insert into analyze_all values(5,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'fgggaaaaaa','aaaaaaaaaaa','ccccc');
insert into analyze_all values(5,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','bbb');
insert into analyze_all values(5,213545678150, 12312.722, '1995-02-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into analyze_all values(null,null,null,null,null,null,null,null,null);
insert into analyze_all values(null,null,null,null,null,null,null,null,null);
insert into analyze_all values(null,null,null,null,null,null,null,null,null);
analyze table analyze_all compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_ALL') AND COL# = 0 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_ALL') AND COL# = 1 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_ALL') AND COL# = 2 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_ALL') AND COL# = 3 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_ALL') AND COL# = 4 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_ALL') AND COL# = 5 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_ALL') AND COL# = 6 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_ALL') AND COL# = 7 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_ALL') AND COL# = 8 order by endpoint;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_ALL') AND COL# = 9 order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'ANALYZE_ALL') order BY COL#;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'ANALYZE_ALL') ORDER BY ID;
drop table analyze_all;

drop table if exists any_partition_add_table0;
create table any_partition_add_table0(id1 int, id2 int, id3 clob)
partition by range(id1, id2)
(
partition p1 values less than(5, 50),
partition p2 values less than(10, 100),
partition p3 values less than(20, 200)
);

insert into any_partition_add_table0 values(6, 200, 'asdfasfadsfasdfadsfadsf');
analyze table any_partition_add_table0 compute statistics;
drop table if exists any_partition_add_table0;

----------------
set serveroutput on
drop table if exists gs_analyze_test;
drop table if exists gs_analyze_test1;
create table gs_analyze_test(a int);
create table gs_analyze_test1(a int);
alter system set sql_stat = true;
insert into gs_analyze_test values(1),(2),(3);
commit;
declare
prev int;
next int;
tmp int;
begin
select count(1) into tmp from gs_analyze_test;
execute immediate 'select processed_rows from v$sqlarea where sql_text = ''select count(1) from gs_analyze_test''' into prev;
select count(1) into tmp from gs_analyze_test;
execute immediate 'select processed_rows from v$sqlarea where sql_text = ''select count(1) from gs_analyze_test''' into next;
dbe_output.print_line('select processed_rows:' || (next-prev));
end;
/

declare
prev int;
next int;
begin
insert into gs_analyze_test1 select * from gs_analyze_test;
execute immediate 'select processed_rows from v$sqlarea where sql_text like ''insert into gs_analyze_test1%select%''' into prev;
insert into gs_analyze_test1 select * from gs_analyze_test;
execute immediate 'select processed_rows from v$sqlarea where sql_text like ''insert into gs_analyze_test1%select%''' into next;
dbe_output.print_line('insert processed_rows:' || (next-prev));
end;
/

declare
prev int;
next int;
begin
update gs_analyze_test set a = 200;
execute immediate 'select processed_rows from v$sqlarea where sql_text like ''update%gs_analyze_test%set%a%=%200%''' into prev;
update gs_analyze_test set a = 200;
execute immediate 'select processed_rows from v$sqlarea where sql_text like ''update%gs_analyze_test%set%a%=%200%''' into next;
dbe_output.print_line('update processed_rows:' || (next-prev));
end;
/

declare
prev int;
next int;
begin
delete from gs_analyze_test;
execute immediate 'select processed_rows from v$sqlarea where sql_text like ''delete%from%gs_analyze_test%''' into prev;
insert into gs_analyze_test values(1),(2),(3);
delete from gs_analyze_test;
execute immediate 'select processed_rows from v$sqlarea where sql_text like ''delete%from%gs_analyze_test%''' into next;
dbe_output.print_line('delete processed_rows:' || (next-prev));
end;
/

----------------
drop table if exists gs_analyze_test;
create table gs_analyze_test(a int);
select * from table(dba_analyze_table('SYS','GS_ANALYZE_TEST'));
select * from table(dba_analyze_table('SYS','GS_ANALYZE_TEST', 2));
drop table if exists gs_analyze_test;
select * from table(dba_analyze_table('SYS','GS_ANALYZE_TEST'));
set serveroutput off

analyze table SYS_TABLES compute statistics;

drop table analyze_char;
create table analyze_char(a varchar(1000));
insert into analyze_char values(LPAD('a',300,'a'));
insert into analyze_char values(LPAD('bx',1000,'bx'));
insert into analyze_char values(LPAD('ac',300,'ac'));
insert into analyze_char values(LPAD('ac',300,'ac'));
insert into analyze_char values(LPAD('bx',1000,'bx'));
analyze table analyze_char compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'ANALYZE_CHAR') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'ANALYZE_CHAR');
drop table analyze_char;

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
commit;
analyze table hzy_high_hist compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST');
drop table if exists hzy_high_hist;
drop table if exists high_hist;

drop table if exists t1;
create table t1 (a int,b char(10));
insert into t1 values (1,4);
call DBE_STATS.FLUSH_DB_STATS_INFO();
select TABLE_OWNER,TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,INSERTS,UPDATES,DELETES,DROP_SEGMENTS from  dba_tab_modifications where table_name='T1';


drop table if exists heap_tab_002;
create table heap_tab_002(
field1 integer,
field2 bigint,
field3 real,
field4 decimal(10,2),
field5 number(6)
);

declare
i int:=0;
begin
loop
i:=i+1;
INSERT INTO heap_tab_002(field1,field2,field3,field4,field5) VALUES(102,100000,123.321,123.123654,123456);
exit when i= 100;
commit;
end loop;
dbe_output.print_line('111');
end;
/

analyze table heap_tab_002 compute statistics;
truncate table heap_tab_002;
select num_rows,blocks,avg_row_len from SYS_TABLES where name = 'HEAP_TAB_002';

DROP TABLE IF EXISTS BIN_TEST; 
CREATE TABLE BIN_TEST(A varchar(100));
insert into BIN_TEST values('da');
alter table BIN_TEST add add_binary binary(100) default lpad('111',100,'222');
alter table BIN_TEST add add_binary1 binary(40) default lpad('111',30,'222');
analyze table BIN_TEST compute statistics;

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
call storage_proc_000(1,24001);
commit;
update hzy_high_hist set a = 5  where a between 5 and 9995;
analyze table hzy_high_hist compute statistics;
select BUCKET,ENDPOINT  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST') order by endpoint;
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_HIST');

drop table if exists hzy_test;
CREATE TABLE HZY_TEST(A INT,B INT);
create index ix_hzy on hzy_test(a);
analyze table hzy_test compute statistics;
select NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_ROW_LEN,SAMPLESIZE from SYS_TABLES where name = 'HZY_TEST';
select NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,HISTOGRAM from SYS_COLUMNS where TABLE# = (select id from SYS_TABLES where name = 'HZY_TEST') and user# = 0;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_TEST') 
AND USER# = (select USER# from SYS_TABLES where name = 'HZY_TEST');
INSERT INTO hzy_test values(1,2);
INSERT INTO hzy_test values(2,2);
INSERT INTO hzy_test values(3,3);
INSERT INTO hzy_test values(4,4);
INSERT INTO hzy_test values(5,25);
INSERT INTO hzy_test values(6,21);
INSERT INTO hzy_test values(7,25);
INSERT INTO hzy_test values(8,21);
INSERT INTO hzy_test values(9,25);
INSERT INTO hzy_test values(10,21);
INSERT INTO hzy_test values(11,25);
INSERT INTO hzy_test values(12,21);
COMMIT;
analyze table hzy_test compute statistics;
select NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_ROW_LEN,SAMPLESIZE from SYS_TABLES where name = 'HZY_TEST';
select NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,HISTOGRAM from SYS_COLUMNS where TABLE# = (select id from SYS_TABLES where name = 'HZY_TEST') and user# = 0;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_TEST')
AND USER# = (select USER# from SYS_TABLES where name = 'HZY_TEST');

drop table if exists hzy_temp1;
create global temporary table hzy_temp1(id int, description varchar(400)) ON COMMIT preserve ROWS; 
create index ix_hzy1 on hzy_temp1(id);
analyze table hzy_temp1 compute statistics;
select NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_ROW_LEN,SAMPLESIZE from SYS_TABLES where name = 'HZY_TEMP1';
select NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,HISTOGRAM from SYS_COLUMNS where TABLE# = (select id from SYS_TABLES where name = 'HZY_TEMP1') and user# = 0;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_TEMP1') 
AND USER# = (select USER# from SYS_TABLES where name = 'HZY_TEMP1');
INSERT INTO hzy_temp1 values(1,'aa');
INSERT INTO hzy_temp1 values(2,'aaaaa');
INSERT INTO hzy_temp1 values(3,'aa');
INSERT INTO hzy_temp1 values(3,'aba');
INSERT INTO hzy_temp1 values(4,'caa');
INSERT INTO hzy_temp1 values(5,'aa');
INSERT INTO hzy_temp1 values(5,'aa');
INSERT INTO hzy_temp1 values(6,'aadaa');
INSERT INTO hzy_temp1 values(7,'sdqwaa');
INSERT INTO hzy_temp1 values(8,'adsaa');
commit;
analyze table hzy_temp1 compute statistics;
select NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_ROW_LEN,SAMPLESIZE from SYS_TABLES where name = 'HZY_TEMP1';
select NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,HISTOGRAM from SYS_COLUMNS where TABLE# = (select id from SYS_TABLES where name = 'HZY_TEMP1') and user# = 0;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_TEMP1') 
AND USER# = (select USER# from SYS_TABLES where name = 'HZY_TEMP1');

drop table if exists hzy_temp1;
create global temporary table hzy_temp1(id int, description varchar(400)); 
create global temporary table hzy_temp1(id int, description varchar(400)) ON COMMIT preserve ROWS; 
create index ix_hzy1 on hzy_temp1(id);
analyze table hzy_temp1 compute statistics;
select NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_ROW_LEN,SAMPLESIZE from SYS_TABLES where name = 'HZY_TEMP1';
select NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,HISTOGRAM from SYS_COLUMNS where TABLE# = (select id from SYS_TABLES where name = 'HZY_TEMP1') and user# = 0;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_TEMP1') 
AND USER# = (select USER# from SYS_TABLES where name = 'HZY_TEMP1');
INSERT INTO hzy_temp1 values(1,'aa');
INSERT INTO hzy_temp1 values(2,'aaaaa');
INSERT INTO hzy_temp1 values(3,'aa');
INSERT INTO hzy_temp1 values(3,'aba');
INSERT INTO hzy_temp1 values(4,'caa');
INSERT INTO hzy_temp1 values(5,'aa');
INSERT INTO hzy_temp1 values(5,'aa');
INSERT INTO hzy_temp1 values(6,'aadaa');
INSERT INTO hzy_temp1 values(7,'sdqwaa');
INSERT INTO hzy_temp1 values(8,'adsaa');
commit;
analyze table hzy_test compute statistics;
select NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_ROW_LEN,SAMPLESIZE from SYS_TABLES where name = 'HZY_TEMP1';
select NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,HISTOGRAM from SYS_COLUMNS where TABLE# = (select id from SYS_TABLES where name = 'HZY_TEMP1') and user# = 0;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_TEMP1') 
AND USER# = (select USER# from SYS_TABLES where name = 'HZY_TEMP1');

create user hzy_lob identified by Cantian_234;
create table hzy_lob.test(a int primary key);
analyze table hzy_lob.test compute statistics;
INSERT INTO hzy_lob.test values(1);
INSERT INTO hzy_lob.test values(2);
INSERT INTO hzy_lob.test values(3);
INSERT INTO hzy_lob.test values(4);
analyze table hzy_lob.test compute statistics;
drop user hzy_lob cascade;

create user hzy_lob identified by Cantian_234;
create table hzy_lob.t1 as select * from sys.SYS_TABLES;
create table hzy_lob.t2 as select * from sys.SYS_TABLES;
create table hzy_lob.t3 as select * from sys.SYS_TABLES;
create table hzy_lob.t4 as select * from sys.SYS_TABLES;
create table hzy_lob.t5 as select * from sys.SYS_TABLES;
create table hzy_lob.t6 as select * from sys.SYS_TABLES;
create table hzy_lob.t7 as select * from sys.SYS_TABLES;
create table hzy_lob.t8 as select * from sys.SYS_TABLES;
create table hzy_lob.t9 as select * from sys.SYS_TABLES;
create table hzy_lob.t10 as select * from sys.SYS_TABLES;

create index hzy_lob.ix_test1 on hzy_lob.t1(upper(name));
create index hzy_lob.ix_test2 on hzy_lob.t2(upper(name));
create index hzy_lob.ix_test3 on hzy_lob.t3(upper(name));
create index hzy_lob.ix_test4 on hzy_lob.t4(upper(name));
create index hzy_lob.ix_test5 on hzy_lob.t5(upper(name));
create index hzy_lob.ix_test6 on hzy_lob.t6(upper(name));
create index hzy_lob.ix_test7 on hzy_lob.t7(upper(name));
create index hzy_lob.ix_test8 on hzy_lob.t8(upper(name));
create index hzy_lob.ix_test9 on hzy_lob.t9(upper(name));
create index hzy_lob.ix_test10 on hzy_lob.t10(upper(name));

exec DBE_STATS.COLLECT_SCHEMA_STATS('HZY_LOB'); 
drop user hzy_lob cascade;

DROP TABLE IF EXISTS wide1;
create table wide1( 
f_int0 integer, 
f_int1 integer, 
f_int2 integer, 
f_int3 integer, 
f_int4 integer, f_int5 integer, f_int6 integer, f_int7 integer, f_int8 integer, f_int9 integer, f_int10 integer, f_int11 integer, f_int12 integer, f_int13 integer, f_int14 integer, f_int15 integer, f_int16 integer, f_int17 integer, f_int18 integer, f_int19 integer, f_int20 integer, f_int21 integer, f_int22 integer, f_int23 integer, f_int24 integer, f_int25 integer, f_int26 integer, f_int27 integer, f_int28 integer, f_int29 integer, f_int30 integer, f_int31 integer, f_int32 integer, f_int33 integer, f_int34 integer, f_int35 integer, f_int36 integer, f_int37 integer, f_int38 integer, f_int39 integer, f_int40 integer, f_int41 integer, f_int42 integer, f_int43 integer, f_int44 integer, f_int45 integer, f_int46 integer, f_int47 integer, f_int48 integer, f_int49 integer, f_int50 integer, f_int51 integer, f_int52 integer, f_int53 integer, f_int54 integer, f_int55 integer, f_int56 integer, f_int57 integer, f_int58 integer, f_int59 integer, f_int60 integer, f_int61 integer, f_int62 integer, f_int63 integer, f_int64 integer, f_int65 integer, f_int66 integer);

analyze table wide1 compute statistics;
insert into wide1( f_int0, f_int1, f_int2, f_int3, f_int4, f_int5, f_int6, f_int7, f_int8, f_int9, f_int10, f_int11, f_int12, f_int13, f_int14, f_int15, f_int16, f_int17, f_int18, f_int19, f_int20, f_int21, f_int22, f_int23, f_int24, f_int25, f_int26, f_int27, f_int28, f_int29, f_int30, f_int31, f_int32, f_int33, f_int34, f_int35, f_int36, f_int37, f_int38, f_int39, f_int40, f_int41, f_int42, f_int43, f_int44, f_int45, f_int46, f_int47, f_int48, f_int49, f_int50, f_int51, f_int52, f_int53, f_int54, f_int55, f_int56, f_int57, f_int58, f_int59, f_int60, f_int61, f_int62, f_int63, f_int64, f_int65, f_int66) values(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66);
analyze table wide1 compute statistics;

drop table if exists t3;
create table t3(C1 TIMESTAMP WITH TIME ZONE);
insert into t3 values(to_timestamp('2019-01-04 16:33:47.123456','YYYY-MM-DD HH24:MI:SS.FFFFFF'));
insert into t3 values(to_timestamp('2019-01-04 16:33:46.123456','YYYY-MM-DD HH24:MI:SS.FFFFFF'));
insert into t3 values(to_timestamp('2019-01-04 16:33:37.123456','YYYY-MM-DD HH24:MI:SS.FFFFFF'));
insert into t3 values(to_timestamp('2019-01-04 16:13:47.123456','YYYY-MM-DD HH24:MI:SS.FFFFFF'));
insert into t3 values(to_timestamp('2019-01-04 16:53:47.123456','YYYY-MM-DD HH24:MI:SS.FFFFFF'));
analyze table t3 COMPUTE STATISTICS;

drop table if exists test_statistics_2;
create table test_statistics_2 (id int, name varchar(2300));
create index idx_statistics_2 on test_statistics_2(id);
insert into test_statistics_2 values(0, LPAD('a',2300,'a'));
insert into test_statistics_2 select id + 1, name from test_statistics_2;
insert into test_statistics_2 select id, name from test_statistics_2;
insert into test_statistics_2 select id + 2, name from test_statistics_2;
insert into test_statistics_2 select id, name from test_statistics_2;
insert into test_statistics_2 select id + 4, name from test_statistics_2;
insert into test_statistics_2 select id, name from test_statistics_2;
insert into test_statistics_2 select id + 8, name from test_statistics_2;
insert into test_statistics_2 select id, name from test_statistics_2;
insert into test_statistics_2 select id + 16, name from test_statistics_2;
insert into test_statistics_2 select id, name from test_statistics_2;

exec dbe_stats.collect_table_stats('SYS','test_statistics_2', null, 80);
drop table if exists test_statistics_2;

create tablespace hzy_stats_spc1 datafile 'hzy_stats_file1' size 32M;
drop table if exists t1;
create table t1(id int, name varchar(8000)) tablespace hzy_stats_spc1;
insert into t1 values(1,'31232');
insert into t1 values(2,'312w32');
insert into t1 values(3,'31w232');
insert into t1 values(4,'312w32');
insert into t1 values(5,'3q1232');
insert into t1 values(6,'3q1232');
exec dbe_stats.collect_table_stats('SYS','t1', null, 1);
exec dbe_stats.collect_table_stats('SYS','t1', null, 80);
analyze table t1 compute statistics;
drop tablespace  hzy_stats_spc1  including contents and datafiles;

drop table if exists stats_reindex;
create table stats_reindex(id integer, part_key integer, val int) partition by range(part_key)
(
    partition reindex_p1 values less than(10),
    partition reindex_p2 values less than(20),
    partition reindex_p3 values less than(30),
    partition reindex_p4 values less than(maxvalue)
);
create index ix_stats_reindex1 on stats_reindex(id);
create index ix_stats_reindex2 on stats_reindex(part_key) local;
declare
    i integer;
begin
    for i in 1..50 loop
        execute immediate 'insert into stats_reindex values('||i||','||i||',100000)';
    end loop;
    commit;
end;
/

select index_name, tablespace_name, ini_trans, pct_free, blevel, distinct_keys from user_indexes where index_name='IX_STATS_REINDEX1';
select index_name, partition_name, ini_trans, pct_free, blevel, distinct_keys from user_ind_partitions where index_name='IX_STATS_REINDEX2' order by partition_name;
analyze table stats_reindex compute statistics;
select index_name, tablespace_name, ini_trans, pct_free, blevel, distinct_keys from user_indexes where index_name='IX_STATS_REINDEX1';
select index_name, partition_name, ini_trans, pct_free, blevel, distinct_keys from user_ind_partitions where index_name='IX_STATS_REINDEX2' order by partition_name;
alter index ix_stats_reindex1 on stats_reindex rebuild online tablespace users pctfree 20;
alter index ix_stats_reindex2 on stats_reindex rebuild;
select index_name, tablespace_name, ini_trans, pct_free, blevel, distinct_keys from user_indexes where index_name='IX_STATS_REINDEX1';
select index_name, partition_name, ini_trans, pct_free, blevel, distinct_keys from user_ind_partitions where index_name='IX_STATS_REINDEX2' order by partition_name;
alter index ix_stats_reindex2 on stats_reindex rebuild partition reindex_p3 online;
select index_name, partition_name, ini_trans, pct_free, blevel, distinct_keys from user_ind_partitions where index_name='IX_STATS_REINDEX2' order by partition_name;
drop table stats_reindex purge;

--create sys table for test
drop table if exists liu_tab;
create table if not exists liu_tab(a int , c varchar(50));
insert into liu_tab values(1,'liu');
--create normal user
drop user if exists analyze_table_0424 cascade;
create user analyze_table_0424 identified by Lh00420062;
grant CREATE SESSION, analyze any, create table to analyze_table_0424;
conn analyze_table_0424/Lh00420062@127.0.0.1:1611
analyze table sys.liu_tab compute statistics;
conn sys/Huawei@123@127.0.0.1:1611
grant dba to analyze_table_0424;
conn analyze_table_0424/Lh00420062@127.0.0.1:1611
analyze table sys.liu_tab compute statistics;
conn sys/Huawei@123@127.0.0.1:1611
revoke dba from analyze_table_0424;
conn analyze_table_0424/Lh00420062@127.0.0.1:1611
analyze table sys.liu_tab compute statistics;
conn sys/Huawei@123@127.0.0.1:1611
drop table if exists liu_tab;
drop user if exists analyze_table_0424 cascade;

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
insert into test_statistics_2 select id + 120, name from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
insert into test_statistics_2 select * from test_statistics_2;
commit;
analyze table test_statistics_2 compute statistics;
select count(distinct id) from test_statistics_2;
select NUM_DISTINCT, NUM_NULLS, HISTOGRAM from dba_tab_columns where TABLE_NAME = 'TEST_STATISTICS_2' order by NUM_DISTINCT asc;
select count(*) from SYS_HISTGRAM,SYS_TABLES where SYS_TABLES.id=SYS_HISTGRAM.table# and SYS_TABLES.name='TEST_STATISTICS_2' and SYS_HISTGRAM.col# = 0;
exec dbe_stats.collect_table_stats('SYS', 'TEST_STATISTICS_2', part_name=>NULL,sample_ratio => 10,method_opt=>'for all columns');
select NUM_DISTINCT, NUM_NULLS, HISTOGRAM from dba_tab_columns where TABLE_NAME = 'TEST_STATISTICS_2' order by NUM_DISTINCT asc;
select count(*) from SYS_HISTGRAM,SYS_TABLES where SYS_TABLES.id=SYS_HISTGRAM.table# and SYS_TABLES.name='TEST_STATISTICS_2' and SYS_HISTGRAM.col# = 0;

create table hzy_part_vm_test(id1 int, id2 int,c varchar(8000))
partition by range(id1, id2)
(
partition p1 values less than(5, 50),
partition p2 values less than(10, 100),
partition p3 values less than(20, 200)
);


declare
    i integer;
begin
    for i in 1..50 loop
        execute immediate 'insert into hzy_part_vm_test values(3, 200, lpad(''a'',8000,''a''))';
		execute immediate 'insert into hzy_part_vm_test values(6, 200, lpad(''a'',8000,''a''))';
		execute immediate 'insert into hzy_part_vm_test values(12, 200, lpad(''a'',8000,''a''))';
		commit;
    end loop;
end;
/

analyze table hzy_part_vm_test compute statistics;

drop table if exists FVT_STAT_PATATITON_LIST_TABLE_001;
create table FVT_STAT_PATATITON_LIST_TABLE_001 
(
	ID1 INT ,
	ID2 NUMBER,
	ID3 BINARY_INTEGER,
	ID4 DOUBLE,
	ID5 FLOAT,
	ID6 REAL,
	NAME1 VARCHAR2(100),
	NAME2 VARCHAR(100),
	NAME3 NCHAR(100),
	NAME4 NCHAR(50),
	TIME1 DATE ,
	TIME2 DATETIME,
	TIME3 TIMESTAMP,
	BR1 BOOLEAN,
	BR2 BOOLEAN,
	BR3 BOOLEAN,
	C_CLOB CLOB	
)
partition by list(id1)
(
partition t1 values (1,2,3,4,5,6,7,8,9,10),
partition t2 values (11,12,13,14,15,16,17,18,19,20),
partition t3 values (21,22,23,24,25,26,27,28,29,30),
partition t4 values (31,32,33,34,35,36,37,38,39,40),
partition t5 values (41,42,43,44,45,46,47,48,49,50)
);

insert into FVT_STAT_PATATITON_LIST_TABLE_001  values(1,null,null,null,null,null,'','','','','','','',0,1,0,'');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (2,-2658.1,-266,-26.581,-2.6581,-0.26581,'DX5S0XPON6','BDNMINTOHY','bdnmintohy                                                                                          ','bDnminTOhY                                        ','0001-01-01 00:00:00','0001-02-02 00:00:00','0001-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'bDnminTOhY');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (3,9969.2,997,99.692,9.9692,0.99692,'S8ZKDKMDD8','GEPAPOUZTU','gepapouztu                                                                                          ','GepaPOUzTu                                        ','0002-01-01 00:00:00','0002-02-02 00:00:00','0002-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'GepaPOUzTu');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (4,9969.2,997,99.692,9.9692,0.99692,'S8ZKDKMDD8','GEPAPOUZTU','gepapouztu                                                                                          ','GepaPOUzTu                                        ','0003-01-01 00:00:00','0003-02-02 00:00:00','0003-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'GepaPOUzTu');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (5,9969.2,997,99.692,9.9692,0.99692,'S8ZKDKMDD8','GEPAPOUZTU','gepapouztu                                                                                          ','GepaPOUzTu                                        ','0004-01-01 00:00:00','0004-02-02 00:00:00','0004-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'GepaPOUzTu');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (6,9969.2,997,99.692,9.9692,0.99692,'S8ZKDKMDD8','GEPAPOUZTU','gepapouztu                                                                                          ','GepaPOUzTu                                        ','0005-01-01 00:00:00','0005-02-02 00:00:00','0005-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'GepaPOUzTu');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (7,3016.84,302,30.1684,3.01684,0.301684,'896RHFW4A6','KLORNRCEUS','klornrceus                                                                                          ','KLoRnRCeUs                                        ','0006-01-01 00:00:00','0006-02-02 00:00:00','0006-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'KLoRnRCeUs');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (8,3016.84,302,30.1684,3.01684,0.301684,'896RHFW4A6','KLORNRCEUS','klornrceus                                                                                          ','KLoRnRCeUs                                        ','0007-01-01 00:00:00','0007-02-02 00:00:00','0007-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'KLoRnRCeUs');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (9,3016.84,302,30.1684,3.01684,0.301684,'896RHFW4A6','KLORNRCEUS','klornrceus                                                                                          ','KLoRnRCeUs                                        ','0008-01-01 00:00:00','0008-02-02 00:00:00','0008-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'KLoRnRCeUs');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (10,3016.84,302,30.1684,3.01684,0.301684,'896RHFW4A6','KLORNRCEUS','klornrceus                                                                                          ','KLoRnRCeUs                                        ','0009-01-01 00:00:00','0009-02-02 00:00:00','0009-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'KLoRnRCeUs');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (1,3669.84,367,36.6984,3.66984,0.366984,'62MJOC80RF','EQCLACMAHH','eqclacmahh                                                                                          ','EQclaCmahh                                        ','0049-01-01 00:00:00','0049-02-02 00:00:00','0049-03-03 00:00:00.000000',TRUE,FALSE,FALSE,'EQclaCmahh');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (2,3669.84,367,36.6984,3.66984,0.366984,'62MJOC80RF','EQCLACMAHH','eqclacmahh                                                                                          ','EQclaCmahh                                        ','0050-01-01 00:00:00','0050-02-02 00:00:00','0050-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'EQclaCmahh');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (3,3669.84,367,36.6984,3.66984,0.366984,'62MJOC80RF','EQCLACMAHH','eqclacmahh                                                                                          ','EQclaCmahh                                        ','0051-01-01 00:00:00','0051-02-02 00:00:00','0051-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'EQclaCmahh');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (4,2931.44,293,29.3144,2.93144,0.293144,'MQ8YBLTNFQ','EGEQRDHRBY','egeqrdhrby                                                                                          ','EgeQRDHRBY                                        ','0052-01-01 00:00:00','0052-02-02 00:00:00','0052-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'EgeQRDHRBY');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (5,2931.44,293,29.3144,2.93144,0.293144,'MQ8YBLTNFQ','EGEQRDHRBY','egeqrdhrby                                                                                          ','EgeQRDHRBY                                        ','0053-01-01 00:00:00','0053-02-02 00:00:00','0053-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'EgeQRDHRBY');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (6,2931.44,293,29.3144,2.93144,0.293144,'MQ8YBLTNFQ','EGEQRDHRBY','egeqrdhrby                                                                                          ','EgeQRDHRBY                                        ','0054-01-01 00:00:00','0054-02-02 00:00:00','0054-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'EgeQRDHRBY');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (7,2931.44,293,29.3144,2.93144,0.293144,'MQ8YBLTNFQ','EGEQRDHRBY','egeqrdhrby                                                                                          ','EgeQRDHRBY                                        ','0055-01-01 00:00:00','0055-02-02 00:00:00','0055-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'EgeQRDHRBY');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (8,2931.44,293,29.3144,2.93144,0.293144,'MQ8YBLTNFQ','EGEQRDHRBY','egeqrdhrby                                                                                          ','EgeQRDHRBY                                        ','0056-01-01 00:00:00','0056-02-02 00:00:00','0056-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'EgeQRDHRBY');
INSERT INTO "FVT_STAT_PATATITON_LIST_TABLE_001" ("ID1","ID2","ID3","ID4","ID5","ID6","NAME1","NAME2","NAME3","NAME4","TIME1","TIME2","TIME3","BR1","BR2","BR3","C_CLOB") values
  (9,2931.44,293,29.3144,2.93144,0.293144,'MQ8YBLTNFQ','EGEQRDHRBY','egeqrdhrby                                                                                          ','EgeQRDHRBY                                        ','0057-01-01 00:00:00','0057-02-02 00:00:00','0057-03-03 00:00:00.000000',TRUE,FALSE,TRUE,'EgeQRDHRBY');
commit; 

drop table if exists FVT_MERGER_TABLE_01;
create table FVT_MERGER_TABLE_01(ID1 INT ,ID2 INT,name1 varchar2(100));
insert into FVT_MERGER_TABLE_01 values(1,2,'');
insert into FVT_MERGER_TABLE_01 values(11,12,'xx');
insert into FVT_MERGER_TABLE_01 values(21,22,'xxx');
insert into FVT_MERGER_TABLE_01 values(50,62,'xxxx');
declare 
begin
for i in 1 .. 10 
loop
execute immediate 'delete from FVT_STAT_PATATITON_LIST_TABLE_001 where id1='||i||'';
execute immediate 'update  FVT_STAT_PATATITON_LIST_TABLE_001 set id2=10 where id1=11 ';
insert into FVT_STAT_PATATITON_LIST_TABLE_001 values(1,null,null,null,null,null,'xx','','','','','','',0,1,0,'');
merge into FVT_STAT_PATATITON_LIST_TABLE_001 t1  using (select id1,id2,name1 from FVT_MERGER_TABLE_01 ) t2 on (t1.id1=t2.id2) when matched then update set t1.id2=t2.id2 
when not  matched then insert (id1,id2,name1) values(t2.id1,t2.id2,t2.name1);
end loop;
end ;
/

analyze table FVT_STAT_PATATITON_LIST_TABLE_001 compute statistics;
select t5.col#,t5.BUCKET_NUM,t5.ROW_NUM,t5.NULL_NUM,t5.MINVALUE,t5.MAXVALUE,t5.dist_num,t5.spare1 from SYS.SYS_TABLES t1,SYS.SYS_HISTGRAM_ABSTR t5 where t1.name='FVT_STAT_PATATITON_LIST_TABLE_001' and t5.TAB#=t1.id and t1.USER#=t5.USER#  and  t5.USER#=(select id from sys.sys_users where name='SYS') 
and t5.spare1 = 10 order by  1,2,3,4,5,6,7,8 ;
select t6.col#,t6.bucket,t6.endpoint,t6.part# from SYS.SYS_TABLES t1  ,SYS.SYS_HISTGRAM t6 where t1.name='FVT_STAT_PATATITON_LIST_TABLE_001' and t1.id=t6.TABLE# and  t1.USER#=t6.USER#  and  t6.USER#=(select id from sys.sys_users where name='SYS') and t6.part# = 10 order by 1,2,3,4;


drop user if exists stats_dny cascade;
create user stats_dny identified by Cantian_234;
grant dba to stats_dny;

drop table if exists stats_dny.dyn_t1;
drop table if exists stats_dny.dyn_t2;
drop table if exists stats_dny.dyn_t3;
create table stats_dny.cbo_ef_data_1w_s (id int,int_f0 int, int_f1 int);
insert into stats_dny.cbo_ef_data_1w_s values(1,22,12);
insert into stats_dny.cbo_ef_data_1w_s values(2,22,23);
insert into stats_dny.cbo_ef_data_1w_s values(3,22,14);
insert into stats_dny.cbo_ef_data_1w_s values(34,22,14);
insert into stats_dny.cbo_ef_data_1w_s values(1,22,15);
insert into stats_dny.cbo_ef_data_1w_s values(1,22,16);
create table stats_dny.dyn_t1 as select * from stats_dny.cbo_ef_data_1w_s order by id;
create table stats_dny.dyn_t2 as select * from stats_dny.cbo_ef_data_1w_s order by id;
create table stats_dny.dyn_t3 as select * from stats_dny.cbo_ef_data_1w_s order by id;
commit;
create index stats_dny.dyn_t1_intf0_idx on stats_dny.dyn_t1 (int_f0);
create index stats_dny.dyn_t1_intf1_idx on stats_dny.dyn_t1 (int_f1);
create index stats_dny.dyn_t1_mult2_idx on stats_dny.dyn_t1 (int_f0,int_f1);

create index stats_dny.dyn_t2_intf0_idx on stats_dny.dyn_t2 (int_f0);
create index stats_dny.dyn_t2_intf1_idx on stats_dny.dyn_t2 (int_f1);
create index stats_dny.dyn_t2_mult2_idx on stats_dny.dyn_t2 (int_f0,int_f1);

create index stats_dny.dyn_t3_intf0_idx on stats_dny.dyn_t3 (int_f0);
create index stats_dny.dyn_t3_intf1_idx on stats_dny.dyn_t3 (int_f1);
create index stats_dny.dyn_t3_mult2_idx on stats_dny.dyn_t3 (int_f0,int_f1);
select t1.* from stats_dny.dyn_t1 t1, stats_dny.dyn_t2 t2, stats_dny.dyn_t3 t3 where t1.int_f0=t2.int_f0 and t1.int_f1=t3.int_f1 and t1.int_f0 = 1 and t3.int_f0 = 0;

conn stats_dny/Cantian_234@127.0.0.1:1611
analyze table stats_dny.dyn_t1 compute statistics;
conn sys/Huawei@123@127.0.0.1:1611
grant select on SYS.SYS_HISTGRAM to stats_dny;
grant select on SYS.SYS_TABLES to stats_dny;
grant select on SYS.SYS_USERS to stats_dny;
conn stats_dny/Cantian_234@127.0.0.1:1611
select A.COL# ,a.bucket,a.endpoint from SYS.SYS_HISTGRAM a,SYS.SYS_TABLES b, SYS.SYS_USERS c where a.table#=b.id and b.name='DYN_T1' and c.name = 'STATS_DNY' order by 1,2,3;
drop table if exists stats_dny.dyn_t1;
drop table if exists stats_dny.dyn_t2;
drop table if exists stats_dny.dyn_t3;

conn sys/Huawei@123@127.0.0.1:1611
drop table if exists test_part_t1;
create table test_part_t1(f1 int)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30)
);

insert into test_part_t1 values(1);
insert into test_part_t1 values(2);
insert into test_part_t1 values(3);
insert into test_part_t1 values(11);
insert into test_part_t1 values(12);
insert into test_part_t1 values(13);
commit;

exec dbe_stats.collect_table_stats('SYS', 'TEST_PART_T1');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'TEST_PART_T1') order by part#;

exec dbe_stats.collect_table_stats('SYS', 'TEST_PART_T1', 'P3');
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'TEST_PART_T1') order by part#;
drop table if exists test_part_t1;

drop table if exists test_part_t1;
create table test_part_t1(f1 int)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30)
);

ANALYZE TABLE test_part_t1 COMPUTE STATISTICS;
select NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_ROW_LEN,SAMPLESIZE from SYS_TABLES where name = 'TEST_PART_T1' and user# = 0;
insert into test_part_t1 values(8);
commit;
ANALYZE TABLE test_part_t1 COMPUTE STATISTICS;
select NAME,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from sys.SYS_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'TEST_PART_T1') order by part#;
drop table if exists test_part_t1;




DROP TABLE IF EXISTS "PARTITION_TEST_TABLE" CASCADE CONSTRAINTS;
CREATE TABLE "PARTITION_TEST_TABLE"
(
  "ID" BINARY_INTEGER NOT NULL,
  "VALUE" BINARY_INTEGER,
  "NAME" varchar(10),
  "NAME1"  varchar(10)
)
PARTITION BY RANGE ("ID")
INTERVAL(1)
(
    PARTITION P1 VALUES LESS THAN (1)
);

insert into PARTITION_TEST_TABLE values (1, 12, 'hzy','null');
insert into PARTITION_TEST_TABLE values (2, 13, 'hzy1', 'hzy1');
insert into PARTITION_TEST_TABLE values (3, 12, 'hzy','hzy1');
insert into PARTITION_TEST_TABLE values (4, 134, 'h4zy1', 'hzy1');
insert into PARTITION_TEST_TABLE values (5, 17, 'hzy', 'hzy1');
insert into PARTITION_TEST_TABLE values (6, 16, 'h5zy1', 'hzay1');
insert into PARTITION_TEST_TABLE values (7, 15, 'hz4y', 'hzy1a');
insert into PARTITION_TEST_TABLE values (8, 14, 'hz3y1', 'hzyw1');
insert into PARTITION_TEST_TABLE values (9, 13, 'hzys', 'hzy1');
insert into PARTITION_TEST_TABLE values (10, 12, 'hzsy1','hzy1');
insert into PARTITION_TEST_TABLE values (11, 11, 'hz2y', 'hzy1a');
insert into PARTITION_TEST_TABLE values (12, 1, 'hzy21', 'hzy1');
insert into PARTITION_TEST_TABLE values (10, 12, 'hz2y1', 'hzay1');
insert into PARTITION_TEST_TABLE values (11, 11, 'hz2y', 'hzqy1');
insert into PARTITION_TEST_TABLE values (12, 1, 'hzy11', 'hz3ey1');
commit;
insert into PARTITION_TEST_TABLE select * from PARTITION_TEST_TABLE;
commit;
create index hzy1 on PARTITION_TEST_TABLE(id) local;
create index hzy2 on PARTITION_TEST_TABLE(value) local;
create index hzy3 on PARTITION_TEST_TABLE(name);
create index hzy4 on PARTITION_TEST_TABLE(name1) local;
drop index hzy1 on PARTITION_TEST_TABLE;
analyze table PARTITION_TEST_TABLE compute statistics;
select * from PARTITION_TEST_TABLE where value = 15;

drop table if exists test_statistics_2;
create table test_statistics_2 (id int, name varchar(2500));
create index idx_statistics_2 on test_statistics_2(id);

insert into test_statistics_2 values(0,LPAD('g',2300,'g'));
insert into test_statistics_2 select id + 1, name from test_statistics_2;
insert into test_statistics_2 select id + 2, name from test_statistics_2;
insert into test_statistics_2 select id + 4, name from test_statistics_2;
insert into test_statistics_2 select id + 8, name from test_statistics_2;
insert into test_statistics_2 select id + 8, name from test_statistics_2;
insert into test_statistics_2 select id + 8, name from test_statistics_2;
insert into test_statistics_2 select id + 8, name from test_statistics_2;

exec dbe_stats.collect_table_stats('SYS','test_statistics_2', null, 90);

drop table if exists hzy_high_hist;
drop table if exists high_hist;
create table high_hist(a int);
insert into high_hist values(0);
create table hzy_high_hist(a int)
partition by range(A)
(
   partition PART_H1 values less than (100),
   partition PART_H2 values less than (200),
   partition PART_H3 values less than (301)
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
call storage_proc_000(1,300);
commit;
call DBE_STATS.FLUSH_DB_STATS_INFO();
select TABLE_OWNER,TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,INSERTS,UPDATES,DELETES,DROP_SEGMENTS from  dba_tab_modifications where table_name='HZY_HIGH_HIST' order by INSERTS;
exec dbe_stats.collect_table_stats('SYS', 'HZY_HIGH_HIST', 'PART_H3');
select TABLE_OWNER,TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,INSERTS,UPDATES,DELETES,DROP_SEGMENTS from  dba_tab_modifications where table_name='HZY_HIGH_HIST' order by INSERTS;
drop table if exists hzy_high_hist;
drop table if exists high_hist;

drop table if exists hzy_high_hist;
drop table if exists high_hist;
create table high_hist(a int, name varchar(2500));
insert into high_hist values(0,LPAD('g',2300,'g'));
create table hzy_high_hist(a int, name varchar(2500))
partition by range(A)
(
   partition PART_H1 values less than (100),
   partition PART_H2 values less than (200),
   partition PART_H3 values less than (301)
);

CREATE or replace procedure storage_proc_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    insert into hzy_high_hist select a+i,name from high_hist;
  END LOOP;
END;
/
call storage_proc_000(1,200);
commit;
exec dbe_stats.collect_table_stats('SYS','hzy_high_hist', null, 10);
exec dbe_stats.collect_table_stats('SYS','hzy_high_hist', 'PART_H1', 90);

drop table if exists fvt_gather_table_01;
create table fvt_gather_table_01
(c_int int,c_num number(10,1),c_name varchar(80),c_clob clob,c_bllo boolean)
partition by range(c_int) 
(partition p1 values less than (1),
partition p2 values less than (11),
partition p3 values less than (1001),
partition p4 values less than (11011)
);

begin
for i in 0..11001
loop
    insert into fvt_gather_table_01 values(i,i,'abs'||i,'clo'||i,'true') ;
end loop;
end;
/
commit;
exec dbe_stats.collect_table_stats(
schema =>'SYS',
name =>'FVT_GATHER_TABLE_01',
part_name =>'P4',
sample_ratio =>100,
method_opt =>'for all indexed columns');
--sys_tables
select cols,indexes,partitioned,num_rows,avg_row_len,samplesize from sys.sys_tables 
where name=upper('fvt_gather_table_01') and user#=( select id from sys.SYS_USERS where name='SYS' );

exec dbe_stats.collect_table_stats(
schema =>'SYS',
name =>'FVT_GATHER_TABLE_01',
part_name =>'P3',
sample_ratio =>100,
method_opt =>'for all indexed columns');
select count(*) from  fvt_gather_table_01 partition(p3);
--sys_tables
select cols,indexes,partitioned,num_rows,avg_row_len,samplesize from sys.sys_tables 
where name=upper('fvt_gather_table_01') and user#=( select id from sys.SYS_USERS where name='SYS' );


drop table if exists FVT_LIST_INDEX32_TABLE_001;
create table FVT_LIST_INDEX32_TABLE_001
(
    ID INT ,
    NAME1 VARCHAR(100),
    TIME1 DATETIME,
    BR1 BOOLEAN,
    C_CLOB CLOB,
    b_blob blob
)
partition by list(id)
(
partition t1 values (1,2,3,4,5,6,7,8,9,10),
partition t2 values (11,12,13,14,15,16,17,18,19,20),
partition t3 values (21,22,23,24,25,26,27,28,29,30),
partition t4 values (31,32,33,34,35,36,37,38,39,40),
partition t5 values (41,42,43,44,45,46,47,48,49,50)
);
insert into FVT_LIST_INDEX32_TABLE_001 values(9,'_1_1xx&','2019-6-30',true,'x1x#','1345');
insert into FVT_LIST_INDEX32_TABLE_001 values(11,'_1_1xx&_2','2019-7-31',false,'x1x#_111','134501a');
insert into FVT_LIST_INDEX32_TABLE_001 values(11,'_1_1xx&_2','2019-7-31',false,'x1x#_111','134501a');
insert into FVT_LIST_INDEX32_TABLE_001 values(20,'_1_1xx&_3','2019-8-30','1','x1x#_111','134501a1');
insert into FVT_LIST_INDEX32_TABLE_001 values(21,'_1_1xx&_3','2019-9-30','0','x1x#_112','134501a2');
insert into FVT_LIST_INDEX32_TABLE_001 values(31,'_1_1xx&_3','2019-10-31','0','x1x#_112','134501a2');
insert into FVT_LIST_INDEX32_TABLE_001 values(40,'_1_1xx&_3','2019-10-31','0','x1x#_112','134501a2');
commit;

drop index if exists FVT_LIST_INDEX1_001 ON FVT_LIST_INDEX32_TABLE_001;
create index  FVT_LIST_INDEX1_001 ON FVT_LIST_INDEX32_TABLE_001(id) local;
analyze table FVT_LIST_INDEX32_TABLE_001 compute statistics ;
exec dbe_stats.collect_table_stats('SYS', 'FVT_LIST_INDEX32_TABLE_001', part_name=>NULL,sample_ratio => 10,method_opt=>'for all indexed columns');
--select COL# ,ROW_NUM from SYS_HISTGRAM_ABSTR where  TAB# = (select id from sys_tables where name = 'FVT_LIST_INDEX32_TABLE_001') and col# = 2 order by SPARE1;

DROP USER IF EXISTS HZY_PSTATS1 CASCADE;
CREATE USER HZY_PSTATS1 IDENTIFIED BY CANTIAN_234;

DROP TABLE IF EXISTS HZY_PSTATS1.HZY_HIGH_GOLIDX;
DROP TABLE IF EXISTS HZY_PSTATS1.HZY_GOLIDX;
CREATE TABLE HZY_PSTATS1.HZY_GOLIDX(A INT);
INSERT INTO HZY_PSTATS1.HZY_GOLIDX VALUES(0);
CREATE TABLE HZY_PSTATS1.HZY_HIGH_GOLIDX(A INT)
PARTITION BY RANGE(A)
(
   PARTITION P_NDV1 VALUES LESS THAN (101),
   PARTITION P_NDV2 VALUES LESS THAN (201),
   PARTITION P_NDV3 VALUES LESS THAN (301)
);

CREATE OR REPLACE PROCEDURE STORAGE_PROC_000(STARTNUM INT,ENDALL INT) IS
I INT :=1;
J VARCHAR(10);
BEGIN
  FOR I IN STARTNUM..ENDALL LOOP
    INSERT INTO HZY_PSTATS1.HZY_HIGH_GOLIDX SELECT A FROM HZY_PSTATS1.HZY_GOLIDX;
  END LOOP;
END;
/

CALL STORAGE_PROC_000(1,100);
CALL STORAGE_PROC_000(101,200);
CALL STORAGE_PROC_000(201,300);
COMMIT;

CREATE INDEX HZY_PSTATS1.HZY_HIGH_GOLIDX_1 ON HZY_PSTATS1.HZY_HIGH_GOLIDX(A) LOCAL;
EXEC dbe_stats.collect_table_stats('HZY_PSTATS1', 'HZY_HIGH_GOLIDX', 'P_NDV1');

SELECT NAME,BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,EMPTY_LEAF_BLOCKS,CLUFAC,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV FROM SYS_INDEXES WHERE TABLE# = (SELECT ID FROM SYS_TABLES WHERE NAME = 'HZY_HIGH_GOLIDX') AND USER# = (SELECT ID FROM SYS_USERS WHERE NAME = 'HZY_PSTATS1');
DROP USER IF EXISTS HZY_PSTATS1 CASCADE;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists liuhang_analyze cascade;
create user liuhang_analyze identified by Cantian_234;
grant all privileges to liuhang_analyze;
grant select on sys.sys_columns to liuhang_analyze;
grant select on sys.sys_tables to liuhang_analyze;
grant select on sys.sys_users to liuhang_analyze;
conn liuhang_analyze/Cantian_234@127.0.0.1:1611
create table employee_test(
       emp_id number(18),
       lead_id number(18),
       emp_name varchar2(200)
);
insert into employee_test values('1',0,'king');
insert into employee_test values('2',1,'arise');
insert into employee_test values('3',1,'jack');
commit;
--expected error
call dbe_stats.collect_table_stats(schema => 'liuhang_analyze', name => 'employee_test', method_opt=>'for columns');
call dbe_stats.collect_table_stats(schema => 'liuhang_analyze', name => 'employee_test', method_opt=>'for columns xxx');
call dbe_stats.collect_table_stats(schema => 'liuhang_analyze', name => 'employee_test', method_opt=>'for columns to_char(emp_id)');
call dbe_stats.collect_table_stats(schema => 'liuhang_analyze', name => 'employee_test', method_opt=>'for columns emp_id;lead_id');
call dbe_stats.collect_table_stats(schema => 'liuhang_analyze', name => 'employee_test', method_opt=>'for columns emp_id,emp_id');

--expected right
select count(*) from sys.sys_columns c, sys.sys_tables t, sys.sys_users u where 
c.user# = t.user# and c.table# = t.id and t.name = 'EMPLOYEE_TEST' and t.user# = u.id and u.name = 'LIUHANG_ANALYZE'
and c.HISTOGRAM is not null;
call dbe_stats.collect_table_stats(schema => 'liuhang_analyze', name => 'employee_test', method_opt=>'for columns lead_id');
select count(*) from sys.sys_columns c, sys.sys_tables t, sys.sys_users u where 
c.user# = t.user# and c.table# = t.id and t.name = 'EMPLOYEE_TEST' and t.user# = u.id and u.name = 'LIUHANG_ANALYZE'
and c.HISTOGRAM is not null;
call DBE_STATS.DELETE_TABLE_STATS(schema => 'liuhang_analyze', name => 'employee_test');
call dbe_stats.collect_table_stats(schema => 'liuhang_analyze', name => 'employee_test', method_opt=>'for columns emp_id, lead_id');
select count(*) from sys.sys_columns c, sys.sys_tables t, sys.sys_users u where 
c.user# = t.user# and c.table# = t.id and t.name = 'EMPLOYEE_TEST' and t.user# = u.id and u.name = 'LIUHANG_ANALYZE'
and c.HISTOGRAM is not null;
call DBE_STATS.DELETE_TABLE_STATS(schema => 'liuhang_analyze', name => 'employee_test');
call dbe_stats.collect_table_stats(schema => 'liuhang_analyze', name => 'employee_test', method_opt=>'for columns emp_id, lead_id, emp_name');
select count(*) from sys.sys_columns c, sys.sys_tables t, sys.sys_users u where 
c.user# = t.user# and c.table# = t.id and t.name = 'EMPLOYEE_TEST' and t.user# = u.id and u.name = 'LIUHANG_ANALYZE'
and c.HISTOGRAM is not null;
--test case sensitive
create table "employee_test_case"(
       `emp_id` number(18),
       "lead_id" number(18),
       `emp_name` varchar2(200)
);
insert into `employee_test_case` values('1',0,'king');
insert into `employee_test_case` values('2',1,'arise');
insert into `employee_test_case` values('3',1,'jack');
commit;
select count(*) from sys.sys_columns c, sys.sys_tables t, sys.sys_users u where 
c.user# = t.user# and c.table# = t.id and t.name = 'employee_test_case' and t.user# = u.id and u.name = 'LIUHANG_ANALYZE'
and c.HISTOGRAM is not null;
call dbe_stats.collect_table_stats(schema => 'liuhang_analyze', name => '`employee_test_case`', method_opt=>'for columns '||'`lead_id`');
select count(*) from sys.sys_columns c, sys.sys_tables t, sys.sys_users u where 
c.user# = t.user# and c.table# = t.id and t.name = 'employee_test_case' and t.user# = u.id and u.name = 'LIUHANG_ANALYZE'
and c.HISTOGRAM is not null;
call DBE_STATS.DELETE_TABLE_STATS(schema => 'liuhang_analyze', name => '`employee_test_case`');
call dbe_stats.collect_table_stats(schema => 'liuhang_analyze', name => '`employee_test_case`', method_opt=>'for columns '||'`emp_id`'||','||'`lead_id`');
select count(*) from sys.sys_columns c, sys.sys_tables t, sys.sys_users u where 
c.user# = t.user# and c.table# = t.id and t.name = 'employee_test_case' and t.user# = u.id and u.name = 'LIUHANG_ANALYZE'
and c.HISTOGRAM is not null;
call DBE_STATS.DELETE_TABLE_STATS(schema => 'liuhang_analyze', name => '`employee_test_case`');
call dbe_stats.collect_table_stats(schema => 'liuhang_analyze', name => '`employee_test_case`', method_opt=>'for columns '||'`emp_id`'||','||'`lead_id`'||','||'`emp_name`');
select count(*) from sys.sys_columns c, sys.sys_tables t, sys.sys_users u where 
c.user# = t.user# and c.table# = t.id and t.name = 'employee_test_case' and t.user# = u.id and u.name = 'LIUHANG_ANALYZE'
and c.HISTOGRAM is not null;
call DBE_STATS.DELETE_TABLE_STATS(schema => 'liuhang_analyze', name => '`employee_test_case`');
select count(*) from sys.sys_columns c, sys.sys_tables t, sys.sys_users u where 
c.user# = t.user# and c.table# = t.id and t.name = 'employee_test_case' and t.user# = u.id and u.name = 'LIUHANG_ANALYZE'
and c.HISTOGRAM is not null;
call dbe_stats.collect_table_stats(schema => 'liuhang_analyze', name => '`employee_test_case`', method_opt=>'for columns `lead_id`');
select count(*) from sys.sys_columns c, sys.sys_tables t, sys.sys_users u where 
c.user# = t.user# and c.table# = t.id and t.name = 'employee_test_case' and t.user# = u.id and u.name = 'LIUHANG_ANALYZE'
and c.HISTOGRAM is not null;
call DBE_STATS.DELETE_TABLE_STATS(schema => 'liuhang_analyze', name => '`employee_test_case`');
call dbe_stats.collect_table_stats(schema => 'liuhang_analyze', name => '`employee_test_case`', method_opt=>'for columns `emp_id`,`lead_id`');
select count(*) from sys.sys_columns c, sys.sys_tables t, sys.sys_users u where 
c.user# = t.user# and c.table# = t.id and t.name = 'employee_test_case' and t.user# = u.id and u.name = 'LIUHANG_ANALYZE'
and c.HISTOGRAM is not null;
call DBE_STATS.DELETE_TABLE_STATS(schema => 'liuhang_analyze', name => '`employee_test_case`');
call dbe_stats.collect_table_stats(schema => 'liuhang_analyze', name => '`employee_test_case`', method_opt=>'for columns `emp_id`,`lead_id`, "emp_name"');
select count(*) from sys.sys_columns c, sys.sys_tables t, sys.sys_users u where 
c.user# = t.user# and c.table# = t.id and t.name = 'employee_test_case' and t.user# = u.id and u.name = 'LIUHANG_ANALYZE'
and c.HISTOGRAM is not null;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists liuhang_analyze cascade;
drop table if exists mod_1;
create table mod_1 (
c_id int, c_integer integer,
c_real real,c_float float, c_cdouble binary_double,
c_decimal decimal(38), c_number number(38),c_number1 number,c_number2 number(20,10),c_numeric numeric(38),
c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
c_clob clob,
c_raw raw(20),c_blob blob,
c_date date,c_timestamp timestamp
);

insert into mod_1(c_id) values(4);
call DBE_STATS.FLUSH_DB_STATS_INFO;
select TABLE_OWNER,TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,INSERTS,UPDATES,DELETES,DROP_SEGMENTS from dba_tab_modifications where table_name='MOD_1';
insert into mod_1(c_date) values('2018-08-26');
call DBE_STATS.FLUSH_DB_STATS_INFO();

--@testpoint:insert 2
select TABLE_OWNER,TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,INSERTS,UPDATES,DELETES,DROP_SEGMENTS from dba_tab_modifications where table_name='MOD_1';
insert into mod_1(c_id) values(9);
exec DBE_STATS.FLUSH_DB_STATS_INFO;

--@testpoint:insert 3
select TABLE_OWNER,TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,INSERTS,UPDATES,DELETES,DROP_SEGMENTS from dba_tab_modifications where table_name='MOD_1';
update  mod_1 set c_date='2018-10-09' where c_id is null;
call DBE_STATS.FLUSH_DB_STATS_INFO;

--@testpoint:updates 1
select TABLE_OWNER,TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,INSERTS,UPDATES,DELETES,DROP_SEGMENTS from dba_tab_modifications where table_name='MOD_1';
drop table if exists mod_1;

---test empty leaves stats
drop table if exists hzy_emp_tab;
CREATE TABLE hzy_emp_tab(id int, b int) crmode row;
create index idx_hzy_emp_tab on hzy_emp_tab(b);
drop table if exists hzy_emp_tab_part;
create table hzy_emp_tab_part(f1 int, f2 real, f3 number)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(1500),
 PARTITION p2 values less than(3000),
 PARTITION p3 values less than(4500),
 PARTITION p4 values less than(6001)
) crmode row;
create index hzy_idx_p1_1 on hzy_emp_tab_part(f1);
create index hzy_idx_p1_2 on hzy_emp_tab_part(f2,f3) local;
create index hzy_idx_p1_3 on hzy_emp_tab_part(f1,f3) local
(
partition p1,
partition p2,
partition p3,
partition p4
);

--2. normal table
declare
    i integer;
begin
    for i in 1 .. 4500 loop
        execute immediate 'insert into hzy_emp_tab values(1, ' || i || ')';
    end loop;
    commit;
end;
/

select PAGES from USER_SEGMENTS where SEGMENT_NAME = 'IDX_HZY_EMP_TAB';
analyze table hzy_emp_tab compute statistics;
select BLEVEL,LEVEL_BLOCKS,EMPTY_LEAF_BLOCKS,DISTINCT_KEYS,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_EMP_TAB');
delete from hzy_emp_tab;
commit;
analyze table hzy_emp_tab compute statistics;
select BLEVEL,LEVEL_BLOCKS,EMPTY_LEAF_BLOCKS,DISTINCT_KEYS,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_EMP_TAB');

--4. partition table
declare
    i integer;
begin
    for i in 1 .. 4500 loop
        execute immediate 'insert into hzy_emp_tab_part values(' || i || ', 1, ' || i || ')';
    end loop;
    commit;
end;
/
commit;
select PAGES from user_segments where SEGMENT_NAME = 'HZY_IDX_P1_2' order by pages;
analyze table hzy_emp_tab_part compute statistics;
select index#,part#,BLEVEL,LEVEL_BLOCKS,EMPTY_LEAF_BLOCKS,DISTKEY,COMB_COLS_2_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_EMP_TAB_PART') order by index#,part#;
delete from hzy_emp_tab_part;
commit;
analyze table hzy_emp_tab_part compute statistics;
select index#,part#,BLEVEL,LEVEL_BLOCKS,EMPTY_LEAF_BLOCKS,DISTKEY,COMB_COLS_2_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_EMP_TAB_PART') order by index#,part#;

drop table if exists hzy_emp_tab;
CREATE TABLE hzy_emp_tab(id int, b int) crmode page;
create index idx_hzy_emp_tab on hzy_emp_tab(b);
drop table if exists hzy_emp_tab_part;
create table hzy_emp_tab_part(f1 int, f2 real, f3 number)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(1500),
 PARTITION p2 values less than(3000),
 PARTITION p3 values less than(4500),
 PARTITION p4 values less than(6001)
) crmode page;
create index hzy_idx_p1_1 on hzy_emp_tab_part(f1);
create index hzy_idx_p1_2 on hzy_emp_tab_part(f2,f3) local;
create index hzy_idx_p1_3 on hzy_emp_tab_part(f1,f3) local
(
partition p1,
partition p2,
partition p3,
partition p4
);

--2. normal table
declare
    i integer;
begin
    for i in 1 .. 4500 loop
        execute immediate 'insert into hzy_emp_tab values(1, ' || i || ')';
    end loop;
    commit;
end;
/

select PAGES from USER_SEGMENTS where SEGMENT_NAME = 'IDX_HZY_EMP_TAB';
analyze table hzy_emp_tab compute statistics;
select BLEVEL,LEVEL_BLOCKS,EMPTY_LEAF_BLOCKS,DISTINCT_KEYS,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_EMP_TAB');
delete from hzy_emp_tab;
commit;
analyze table hzy_emp_tab compute statistics;
select BLEVEL,LEVEL_BLOCKS,EMPTY_LEAF_BLOCKS,DISTINCT_KEYS,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_EMP_TAB');

--4. partition table
declare
    i integer;
begin
    for i in 1 .. 4500 loop
        execute immediate 'insert into hzy_emp_tab_part values(' || i || ', 1, ' || i || ')';
    end loop;
    commit;
end;
/
commit;
select PAGES from user_segments where SEGMENT_NAME = 'HZY_IDX_P1_2' order by pages;
analyze table hzy_emp_tab_part compute statistics;
select index#,part#,BLEVEL,LEVEL_BLOCKS,EMPTY_LEAF_BLOCKS,DISTKEY,COMB_COLS_2_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_EMP_TAB_PART') order by index#,part#;
delete from hzy_emp_tab_part;
commit;
analyze table hzy_emp_tab_part compute statistics;
select index#,part#,BLEVEL,LEVEL_BLOCKS,EMPTY_LEAF_BLOCKS,DISTKEY,COMB_COLS_2_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_EMP_TAB_PART') order by index#,part#;

drop table if exists hzy_sep;
create table hzy_sep(a int, b int, c int, d char(10));
create index ix_hzy_sep on hzy_sep(a);
insert into hzy_sep values(1,2,3,'hzy');
insert into hzy_sep values(2,4,3,'hzy');
insert into hzy_sep values(3,34,3,'hzy');
insert into hzy_sep values(4,2,1,'hzy');
insert into hzy_sep values(5,21,3,'hzy');
insert into hzy_sep values(6,2,13,'hzy');
insert into hzy_sep values(7,21,3,'hzy');
insert into hzy_sep values(1,2,3,'hzy');
exec  dbe_stats.collect_table_stats(schema => 'sys',name => 'hzy_sep',part_name => null,sample_ratio => dbe_stats.auto_sample_size,method_opt=>'for columns c');
select col#,BUCKET_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_SEP') order by col#;
exec  dbe_stats.collect_table_stats(schema => 'sys',name => 'hzy_sep',part_name => null,sample_ratio => dbe_stats.auto_sample_size,method_opt=>'for columns with indexed columns');
exec  dbe_stats.collect_table_stats(schema => 'sys',name => 'hzy_sep',part_name => null,sample_ratio => dbe_stats.auto_sample_size,method_opt=>'for columns c,d with indexed columns');
select col#,BUCKET_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_SEP') order by col#;

drop table if exists hzy_sep;
create table hzy_sep(f1 int, f2 int, f3 char(30))
PARTITION BY RANGE(f2)
INTERVAL(10)
(
 PARTITION hzy_sepp1 values less than(10),
 PARTITION hzy_sepp2 values less than(20),
 PARTITION hzy_sepp3 values less than(30)
);
create index ix_hzy_sep on hzy_sep(f1);
insert into hzy_sep values(1,5,'hzy');
insert into hzy_sep values(2,15,'hzy1');
insert into hzy_sep values(3,25,'hzy2');
insert into hzy_sep values(4,35,'hzy3');
insert into hzy_sep values(5,115,'hzy66');
insert into hzy_sep values(6,55,'6hzy');
insert into hzy_sep values(7,65,'hezy');
insert into hzy_sep values(8,75,'hzfdy');
insert into hzy_sep values(9,85,'hzyf');
insert into hzy_sep values(10,95,'hzyd');
insert into hzy_sep values(11,105,'hzy');
insert into hzy_sep select * from hzy_sep;
insert into hzy_sep select * from hzy_sep;
commit;
exec  dbe_stats.collect_table_stats(schema => 'sys',name => 'hzy_sep',part_name => null,sample_ratio => dbe_stats.auto_sample_size,method_opt=>'for columns f1');
select col#,spare1,BUCKET_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_SEP') order by col#,spare1;
exec  dbe_stats.collect_table_stats(schema => 'sys',name => 'hzy_sep',part_name => null,sample_ratio => dbe_stats.auto_sample_size,method_opt=>'for columns with indexed columns');
exec  dbe_stats.collect_table_stats(schema => 'sys',name => 'hzy_sep',part_name => null,sample_ratio => dbe_stats.auto_sample_size,method_opt=>'for columns f3,f1 with indexed columns');
select col#,spare1,BUCKET_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_SEP') order by col#,spare1;
drop table if exists hzy_patch_insert;
create table hzy_patch_insert(a int,b int);
create index bat_idx on hzy_patch_insert(a);
insert into hzy_patch_insert values(1,0);
insert into hzy_patch_insert select * from hzy_patch_insert;
insert into hzy_patch_insert select * from hzy_patch_insert;
insert into hzy_patch_insert select * from hzy_patch_insert;
commit;
select count(*) from HZY_PATCH_INSERT;
exec DBE_STATS.FLUSH_DB_STATS_INFO();
select TABLE_NAME,INSERTS,UPDATES,DELETES from ADM_TAB_MODIFICATIONS where TABLE_NAME  =  'HZY_PATCH_INSERT';

drop table if exists T_SP_ITP2GCELLFREQ_FREQ_C41;
drop table if exists t_TP_GTRX_C4;

CREATE GLOBAL TEMPORARY TABLE "T_SP_ITP2GCELLFREQ_FREQ_C41"
(
"OPERTYPE" BINARY_INTEGER NOT NULL,
"PLANID" BINARY_INTEGER NOT NULL,
"CMENEID" BINARY_INTEGER NOT NULL,
"CELLID" BINARY_INTEGER
)ON COMMIT DELETE ROWS;


create table t_TP_GTRX_C4
(OperType BINARY_INTEGER,
PlanID int);

create index t11 on t_TP_GTRX_C4(OperType);
insert into t_TP_GTRX_C4 values(1,2);
insert into t_TP_GTRX_C4 values(2,2);

insert into t_TP_GTRX_C4 values(3,2);

insert into t_TP_GTRX_C4 values(4,2);
insert into t_TP_GTRX_C4 values(5,2);
insert into t_TP_GTRX_C4 values(6,2);

insert into t_TP_GTRX_C4 select * from t_TP_GTRX_C4;
commit;

SELECT b.PlanID
FROM t_sp_ITP2GCELLFREQ_FREQ_C41 b
LEFT JOIN (
    SELECT *
    FROM t_TP_GTRX_C4
    WHERE OperType = 2
    ) c ON b.PlanID = c.PlanID
WHERE b.PlanID = 54;

alter system set cbo = on;
drop table if exists pbi_edition;
create table pbi_edition (id int, ENTITY_ID varbinary(20), category varbinary(20));
insert into pbi_edition values(1, '1','1');
CREATE or replace procedure proc_insert(startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
        insert into pbi_edition select i+1, ENTITY_ID,category from  pbi_edition where id = 1;commit;
  END LOOP;
END;
/

exec proc_insert(1,80);

call dbe_stats.collect_table_stats( schema=>'sys', name=>'pbi_edition', sample_ratio => 100, method_opt=>'for all columns');
select count(*) from pbi_edition t1 , pbi_edition t2 where t1.ENTITY_ID = t2.category;

alter system set cbo = off;

drop table if exists hzy_emp;
create table hzy_emp (id int, name varchar(20));
insert into hzy_emp values(0, 'it is a long string');
insert into hzy_emp select id + 1, name from hzy_emp;
insert into hzy_emp select id + 2, name from hzy_emp;
insert into hzy_emp select id + 4, name from hzy_emp;
insert into hzy_emp select id + 8, name from hzy_emp;
insert into hzy_emp select id + 16, name from hzy_emp;
insert into hzy_emp select id + 32, name from hzy_emp;
insert into hzy_emp select id + 64, name from hzy_emp;
insert into hzy_emp select id + 120, name from hzy_emp;
insert into hzy_emp select * from hzy_emp;
insert into hzy_emp select * from hzy_emp;
insert into hzy_emp select * from hzy_emp;
insert into hzy_emp select * from hzy_emp;
insert into hzy_emp select * from hzy_emp;
insert into hzy_emp select * from hzy_emp;
commit;
delete from hzy_emp;
commit;
analyze table hzy_emp compute statistics;
SELECT BLOCKS,EMPTY_BLOCKS  from sys_tables where name = 'HZY_EMP';

drop table hzy;
CREATE TABLE HZY(ID INT,NAME VARCHAR(100),ADDR VARCHAR(1024));
insert into hzy values(1,'hzy','dadadas');
insert into hzy values(1,'hzy','dadadas');
insert into hzy values(1,'hzy','dadadas');
insert into hzy values(1,'hzy','dadadas');
insert into hzy values(1,'hzy','dadadas');
exec dbe_stats.collect_table_stats('sys', 'HZY', part_name=>NULL, sample_ratio => 100, method_opt=>'for all columns');

EXEC DBE_STATS.MODIFY_COLUMN_STATS('sys','HZY', 'NAME', dist_nums=>0, density=>0.0075, null_cnt=>1);
create index iii on hzy(id, addr);
EXEC DBE_STATS.MODIFY_COLUMN_STATS('sys','HZY', 'NAME', dist_nums=>0, density=>0.0075, null_cnt=>1);

drop table if exists  PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010;
create GLOBAL TEMPORARY table PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_unsig tinyint unsigned,c_big bigint,c_vchar varchar2(8000),c_data long,c_text blob,c_clob clob,c_image image,c_binary binary(1000),c_varbinary varbinary(1000),c_raw raw(1000),primary key(c_id,c_d_id,c_w_id)) ON COMMIT DELETE rows;

CREATE or replace procedure PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PRO_010(startall int,endall int) as
i INT;
m int;
f_start timestamp;
f_end timestamp;
f_interval INTERVAL DAY(7) TO SECOND(6);
BEGIN
    delete from PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010;

    FOR a in 1..120 LOOP
        insert into PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010 select 1,1,1,'AA'||'is1cmvls','OE','AA'||'BAR1BARBAR','bkili'||'1'||'fcxcle'||'1','pmbwo'||'1'||'vhvpaj'||'1','dyf'||'1'||'rya'||'1','uq',4800||'1',940||'1'||205||'1','1800-01-01 10:51:47','GC',50000.0,0.4361328,-10.0,10.0,1,true,'1800-01-01 10:51:47',1,1,lpad('1234ABCDRFGHopqrstuvwxyz8',1500,'ABfgCDefgh'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbxxbm',200,'yxcfgdsgtcjxrbxxbm'),lpad('124324543256546324554354325',200,'7687389015'),lpad('sbfacwjpbvpgthpyxcpmnutcjdfaxrbxxbm',200,'yxcpmnutcjxrbxxbm'),lpad('123dSHGGefasdy',200,'678ASVDFopqrst9234'),lpad('12345abcdegf',200,'adbede1fghij1kLMHG3FFHUK'),lpad('ede1fghij1kLMHG3',200,'xcp2345abcdepmnu'),lpad('1234567890abcdfe',200,'abc1d2fe123895ab456cdef');

       select count(*) into m from (select distinct c_id from PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010);

     dbe_output.print_line(m);

        select sysdate into f_start from sys_dummy;

        FOR i IN startall..endall LOOP
            insert into PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010 select c_id+i,c_d_id+i,c_w_id+i,'AA'||'is'||i||'cmvls',c_middle,'AA'||'BAR'||i||'ddBARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,'940'||i||'205'||i,c_since+i,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end+i,c_unsig+i,c_big+100000*i,c_vchar,c_data,c_text,c_clob,c_image,lpad('12345abcdegf',200,'adbede1fghij'||i||'kLMHG3FFHUK'),lpad('ede1fghij1kLMHG3',200,'xcp23'||i||'45abcdepmnu'),lpad('1234567890abcdfe',200,'abc1d2fe123'||i||'895ab456cdef') from PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010 where c_id=1;
        END LOOP;
     update PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010 set c_first='qwertyuityuiopasdfghjkl',c_street_1='qwertyuityu',c_last='qwertyuityuiopasdfghjklwertyuityuiopasdfg' where rowid>10;

       select count(*) into m from (select c_id from PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010);
     dbe_output.print_line(m);

     update PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010 set c_first='qwert',c_street_1='qwerty',c_last='qwertyuityuio' where rowid>10000;

     delete from PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010;

  select sysdate into f_end from sys_dummy;

 -- dbe_output.print_line(f_end - f_start);
  END LOOP;
END;
/

SET serveroutput ON;

select count(*) c_id from PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010;

call PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PRO_010(1,1);

drop table if exists test_csf_number_stat;
create table test_csf_number_stat(id number, ids binary_integer) format csf;
insert into test_csf_number_stat values(0, 0);
commit;
call dbe_stats.collect_table_stats('sys','test_csf_number_stat');
select col#,BUCKET,ENDPOINT from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'TEST_CSF_NUMBER_STAT') order by col#,endpoint;

drop table if exists hzy_number;
create table hzy_number(a NUMBER(6) ,b int);
insert into hzy_number values(0,1);
analyze table hzy_number compute statistics;
select col#,bucket_num,minvalue,maxvalue,dist_num from SYS_HISTGRAM_ABSTR where tab# = (select id from sys_tables where name = 'HZY_NUMBER') order by col#;
delete from hzy_number;
analyze table hzy_number compute statistics;
select col#,bucket_num,minvalue,maxvalue,dist_num from SYS_HISTGRAM_ABSTR where tab# = (select id from sys_tables where name = 'HZY_NUMBER') order by col#;

-- table function 'dba_analyze_table' for partition table
drop table if exists test_analyze_subpart_tab;
CREATE TABLE test_analyze_subpart_tab(c int, c1 int, c2 int) partition by list(c) subpartition by range(c1) (
PARTITION PART_1 VALUES(1)
(
 SUBPARTITION PART_11 VALUES LESS THAN(10),
 SUBPARTITION PART_12 VALUES LESS THAN(100)
),
PARTITION PART_2 VALUES(2)
(
 SUBPARTITION PART_21 VALUES LESS THAN(10),
 SUBPARTITION PART_22 VALUES LESS THAN(100)
),
PARTITION PART_3 VALUES(DEFAULT));

insert into test_analyze_subpart_tab values(1,9,1),(1,19,1),(2,9,1),(2,19,1),(3,9,1);
select * from table(dba_analyze_table('SYS', 'TEST_ANALYZE_SUBPART_TAB')) where STAT_ITEM = 'total rows';
drop table if exists test_analyze_subpart_tab;
drop table if exists EEE CASCADE CONSTRAINTS;
CREATE TABLE "EEE"
(
  "ID" BINARY_INTEGER,
  "NAME" VARCHAR(30 BYTE)
)
PARTITION BY RANGE ("ID")
INTERVAL(50)
SUBPARTITION BY HASH ("NAME")
(
    PARTITION P1 VALUES LESS THAN (50) TABLESPACE "USERS" INITRANS 2 PCTFREE 8(
        SUBPARTITION P11 TABLESPACE "USERS",
        SUBPARTITION P12 TABLESPACE "USERS"
    ),
    PARTITION P2 VALUES LESS THAN (100) TABLESPACE "USERS" INITRANS 2 PCTFREE 8(
        SUBPARTITION P21 TABLESPACE "USERS",
        SUBPARTITION P22 TABLESPACE "USERS"
    )
);

INSERT INTO "EEE" ("ID","NAME") values (5,'OSS3:NE=5');
INSERT INTO "EEE" ("ID","NAME") values (6,'OSS3:NE=6');
INSERT INTO "EEE" ("ID","NAME") values (7,'OSS3:NE=7');
INSERT INTO "EEE" ("ID","NAME") values (8,'OSS3:NE=8');
INSERT INTO "EEE" ("ID","NAME") values (10,'OSS3:NE=10');
commit;
exec dbe_stats.collect_table_stats(schema=>'SYS', name=>'EEE',part_name=>null, sample_ratio=>100,method_opt=> 'for all columns');
EXEC DBE_STATS.MODIFY_COLUMN_STATS(table_schema =>'SYS',table_name=>'EEE',part_name=>NULL,column_name=>'ID',dist_nums=>100);
EXEC DBE_STATS.MODIFY_COLUMN_STATS(table_schema =>'SYS',table_name=>'EEE',part_name=>'P1',column_name=>'ID',dist_nums=>100);
select col#,bucket_num,minvalue,maxvalue,dist_num,spare1,spare2 from SYS_HISTGRAM_ABSTR where tab# = (select id from sys_tables where name = 'EEE') order by col#,spare1,spare2;
drop table if exists EEE CASCADE CONSTRAINTS;

----DTS202107140GFWGPP1300
drop table if exists META_CLASS;
CREATE TABLE "META_CLASS"
(
  "ID" BINARY_BIGINT NOT NULL,
  "NAME" VARCHAR(128 BYTE) NOT NULL,
  "DESCRIPTION" VARCHAR(750 BYTE),
  "PARENT_ID" BINARY_BIGINT NOT NULL,
  "DISPLAY_NAME" VARCHAR(1500 BYTE),
  "CUSTOM" BOOLEAN DEFAULT TRUE,
  "ABSTRACT_CI" BOOLEAN DEFAULT FALSE,
  "SENDEVENT" BOOLEAN DEFAULT FALSE,
  "MERES" BOOLEAN DEFAULT FALSE,
  "CATEGORY" VARCHAR(128 BYTE),
  "DISPLAYPARENTNODENAME" VARCHAR(1500 BYTE),
  "LINKTOMOUI" BOOLEAN DEFAULT TRUE,
  "TOPIC_NAME" VARCHAR(240 BYTE),
  "VERSION" NUMBER(3, 2) DEFAULT NULL,
  "UPDATETIME" BINARY_BIGINT
);
ALTER TABLE "META_CLASS" MODIFY "ID" AUTO_INCREMENT;
ALTER TABLE "META_CLASS" AUTO_INCREMENT = 10100;
ALTER TABLE "META_CLASS" ADD PRIMARY KEY("ID");
ALTER TABLE "META_CLASS" ADD UNIQUE("NAME");

alter system set cbo = on;
MERGE INTO META_CLASS A USING (select 1 as ID,'BaseClass' as NAME,'BASE CLASS' as DESCRIPTION, -1 as PARENT_ID, '{"zh_CN":"aa","en_US":"Base Class"}' as DISPLAY_NAME, FALSE as CUSTOM, TRUE as ABSTRACT_CI, 1.0 as VERSION, 1000000000000 as UPDATETIME from SYS_DUMMY) B
ON (A.ID=B.ID)
WHEN NOT MATCHED THEN
INSERT (ID,NAME,DESCRIPTION,PARENT_ID,DISPLAY_NAME,CUSTOM,ABSTRACT_CI,VERSION,UPDATETIME) VALUES (B.ID,B.NAME,B.DESCRIPTION,B.PARENT_ID,B.DISPLAY_NAME,B.CUSTOM,B.ABSTRACT_CI,B.VERSION,B.UPDATETIME);
alter system set cbo = off;

drop table if exists gst_session;
drop table if exists res_t;
drop table if exists normal_table;
alter system set cbo = on;

create global temporary table gst_session(a int, b bigint, c number, d date, e timestamp, f real, g char(10), h clob, i varchar(10)) on commit preserve rows;
create index idx1_gst_session on gst_session(a);
create global temporary table res_t(a int) on commit delete rows;

create table normal_table(a int, b bigint, c number, d date, e timestamp, f real, g char(10), h clob, i varchar(10));
insert into normal_table values(5,213525678150, 52312.122, '1995-02-01', '1995-02-09 11:12:40', 1272.264, 'fgggaaaaaa','aaaaaaaaaaa','ccccc');
insert into normal_table values(6,113545678150, 12812.722, '1995-03-09', '1995-02-09 12:12:40', 61272.264, 'cacccaaaaa','aaaaaaaaaaa','fsda');
insert into normal_table values(7,223545678150, 12312.722, '1996-05-09', '1995-02-09 13:12:40', 1272.264, 'ccbccaaaaa','aaaaaaaaaaa','ter');
insert into normal_table values(8,213545678150, 22312.722, '1992-02-09', '1995-02-09 14:12:40', 6272.264, 'cccccaaaaa','aaaaaaaaaaa','fds');
insert into normal_table values(91,213645678150, 52312.722, '1991-02-09', '1995-02-09 15:12:40', 6122.264, 'cccccaaaaa','aaaaaaaaaaa','gfd');
insert into normal_table values(19,213945678150, 62312.722, '1992-02-09', '1995-02-01 15:12:40', 672.264, 'ccdccaaaaa','aaaaaaaaaaa','dfgasd');
insert into normal_table values(39,213145678150, 72312.722, '1995-02-09', '1995-02-19 15:12:40', 1272.264, 'cecccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into normal_table values(94,13545678150, 1312.722, '1999-02-09', '1995-02-02 15:12:40', 2.264, 'ccccca7aaa','aaaaaaaaaaa','6bsdf');
insert into normal_table values(91,2135678150, 2312.722, '1991-01-09', '1995-02-13 15:12:40', 71272.264, 'cccgcaaaaa','aaaaaaaaaaa','fvadfv');
insert into normal_table values(93,2135458150, 12312.722, '1995-02-09', '1995-02-04 15:12:40', 11272.264, 'cscccaaaaa','aaaaaaaaaaa','tt4rdf');
insert into normal_table values(54,545678150, 5232.122, '1995-03-09', '1995-02-05 15:12:40', 21272.264, 'fgg9aaaaaa','aaaaaaaaaaa','dfga');
insert into normal_table values(67,45678150, 1232.722, '1995-04-09', '1995-02-06 15:12:40', 31272.264, 'cccchaaaaa','aaaaaaaaaaa','va');
insert into normal_table values(97,213545678150, 2312.722, '1995-05-09', '1995-02-07 15:12:40', 41272.264, 'jccccaaaaa','aaaaaaaaaaa','adgery');
insert into normal_table values(80,21354560, 1232.722, '1995-06-09', '1995-02-08 15:12:40', 71272.264, 'ccccsaaaaa','aaaaaaaaaaa','bbb');
insert into normal_table values(98,213545678150, 82312.722, '1995-02-01', '1995-02-11 15:12:40', 81272.264, 'vccccaaaaa','aaaaaaaaaaa','afdgdf');
insert into normal_table values(1,213545678150, 12.722, '1995-02-02', '1995-02-09 15:12:40', 61278.264, 'ccccoaaaaa','aaaaaaaaaaa','ggadga');
insert into normal_table values(2,213545678150, 2512.722, '1995-02-03', '1995-03-09 15:12:40', 61271.264, '1cccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into normal_table values(3,213545678150, 62312.722, '1995-02-04', '1995-02-09 15:12:40', 6172.264, 'cc8ccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into normal_table values(4,213545678150, 62312.722, '1995-02-05', '1995-02-09 15:12:40', 6272.264, 'cccccaaaaa','aaaaaaaaaaa','gasd');
insert into normal_table values(8,213545678150, 1312.722, '1995-02-05', '1995-02-09 15:12:40', 64272.264, 'ccc3caaaaa','aaaaaaaaaaa','aaaaaa');
insert into normal_table values(511,2135478150, 82312.122, '1991-01-09', '1995-02-09 15:12:40', 1272.264, 'fgg0aaaaaa','aaaaaaaaaaa','asdfgsa');
insert into normal_table values(63,213545678150, 4312.722, '1995-02-09', '1995-02-09 15:12:40', 91272.264, '8ccccaaaaa','aaaaaaaaaaa','bbb');
insert into normal_table values(17,213545678150, 92312.722, '1995-03-09', '1995-02-09 15:12:40', 61272.264, 'cccccaaaaa','aaaaaaaaaaa','dfas');
insert into normal_table values(118,545678150, 112.722, '1995-02-19', '1995-02-09 15:12:40', 61272.264, 'cfcccaaaaa','aaaaaaaaaaa','bbb');
insert into normal_table values(9232,2135456781, 22312.722, '1995-02-19', '1995-02-09 15:12:40', 61272.264, 'cccdaaaaa','aaaaaaaaaaa','aaaaaa');
insert into normal_table values(9212,2545678150, 82312.722, '1995-02-20', '1995-02-09 15:12:40', 61272.264, '5ccccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into normal_table values(129,213578150, 1.722, '1995-08-09', '1995-02-09 15:12:40', 61272.264, 'ccccfaaaa','aaaaaaaaaaa','aaaaaa');
insert into normal_table values(194,2135478150, 13.722, '1995-12-09', '1995-02-09 15:12:40', 61272.264, 'ccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into normal_table values(69,13545678150, 122.722, '1993-02-09', '1995-02-09 15:12:40', 61272.264, 'dccccaaaaa','aaaaaaaaaaa','aaaaaa');
insert into normal_table values(1099,213678150, 112.722, '1998-02-09', '1995-02-09 15:12:40', 61272.264, 'asdfs','aaaaaaaaaaa','aaaaaa');
commit;

delete from gst_session;
insert into gst_session select * from normal_table limit 1;
DELETE FROM gst_session;
exec dbe_stats.collect_table_stats('SYS', 'gst_session', part_name=>NULL,sample_ratio => 35,method_opt=>'for all indexed columns');
insert into gst_session select * from normal_table;
insert into res_t select normal_table.a from normal_table, gst_session where normal_table.a = gst_session.a and normal_table.b = gst_session.b;
alter system set cbo = off;
