drop table if exists high_hist;
create table high_hist(a int,b int,c int);
insert into high_hist values(0,0,0);
commit;

drop table if exists hzy_sub1;
CREATE TABLE hzy_sub1(a int, b int, c int)
PARTITION BY RANGE (a)
SUBPARTITION BY range (b)
(
    PARTITION q1_1999 VALUES LESS THAN (250)
    (
        SUBPARTITION q1_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q1_1999_southwest VALUES LESS THAN (MAXVALUE)
    ),
    PARTITION q2_1999 VALUES LESS THAN (500)
    (
        SUBPARTITION q2_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q2_1999_southwest VALUES LESS THAN (MAXVALUE)
    ),
    PARTITION q3_1999 VALUES LESS THAN (750)
    (
        SUBPARTITION q3_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q3_1999_southwest VALUES LESS THAN (MAXVALUE)
    ),
    PARTITION q4_1999 VALUES LESS THAN (1001)
    (
        SUBPARTITION q4_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q4_1999_southwest VALUES LESS THAN (MAXVALUE)
    )
);

analyze table hzy_sub1 compute statistics;
select PARENT_PART#,SUBPART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_SUB_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PARENT_PART#, SUBPART#;
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  order by col#,spare1,spare2;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 4294967295;
select num_rows,blocks,empty_blocks,avg_row_len,samplesize from SYS_TABLES where name = 'HZY_SUB1'; 

drop table if exists hzy_sub1;
CREATE TABLE hzy_sub1(a int, b int, c int)
PARTITION BY RANGE (a)
SUBPARTITION BY range (b)
(
    PARTITION q1_1999 VALUES LESS THAN (250)
    (
        SUBPARTITION q1_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q1_1999_southwest VALUES LESS THAN (MAXVALUE)
    ),
    PARTITION q2_1999 VALUES LESS THAN (500)
    (
        SUBPARTITION q2_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q2_1999_southwest VALUES LESS THAN (MAXVALUE)
    ),
    PARTITION q3_1999 VALUES LESS THAN (750)
    (
        SUBPARTITION q3_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q3_1999_southwest VALUES LESS THAN (MAXVALUE)
    ),
    PARTITION q4_1999 VALUES LESS THAN (1001)
    (
        SUBPARTITION q4_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q4_1999_southwest VALUES LESS THAN (MAXVALUE)
    )
);

exec dbe_stats.collect_table_stats(
schema =>'SYS',
name =>'HZY_SUB1',
part_name =>'Q1_1999',
sample_ratio =>100,
method_opt =>'for all columns');
select count(*) from HZY_SUB1;
select PARENT_PART#,SUBPART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_SUB_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PARENT_PART#, SUBPART#;
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  order by col#,spare1,spare2;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 4294967295;
select num_rows,blocks,empty_blocks,avg_row_len,samplesize from SYS_TABLES where name = 'HZY_SUB1'; 

select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by id,blevel;
select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;


CREATE or replace procedure storage_proc_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    insert into hzy_sub1 select a+i,b+i,c+i from high_hist;
  END LOOP;
END;
/

call storage_proc_000(1,1000);
commit;

analyze table hzy_sub1 compute statistics;
select PARENT_PART#,SUBPART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_SUB_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PARENT_PART#, SUBPART#;
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  order by col#,spare1,spare2;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 4294967295;
select num_rows,blocks,empty_blocks,avg_row_len,samplesize from SYS_TABLES where name = 'HZY_SUB1'; 

create index hzy_sub1_idx1 on hzy_sub1(a);
analyze table hzy_sub1 compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by id,blevel;
select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

create index hzy_sub1_idx2 on hzy_sub1(a,b) parallel 4 local;
analyze table hzy_sub1 compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by id,blevel;
select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

create index hzy_sub1_idx3 on hzy_sub1(a,c) local parallel 4;
analyze table hzy_sub1 compute statistics;
select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by id,blevel;
select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

---- CHANGE TABLE : INSERT ROWS 
delete from high_hist;
insert into high_hist values(100,0,0);
commit;
CREATE or replace procedure storage_proc_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    insert into hzy_sub1 select a,b + i,c from high_hist;
  END LOOP;
END;
/
call storage_proc_000(1,600);
commit;

exec dbe_stats.collect_table_stats(
schema =>'SYS',
name =>'HZY_SUB1',
part_name =>'Q1_1999',
sample_ratio =>100,
method_opt =>'for all indexed columns');
select count(*) from HZY_SUB1;
select PARENT_PART#,SUBPART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_SUB_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PARENT_PART#, SUBPART#;
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  order by col#,spare1,spare2;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 4294967295;
select num_rows,blocks,empty_blocks,avg_row_len,samplesize from SYS_TABLES where name = 'HZY_SUB1'; 

select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by id,blevel;
select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

---- CHANGE TABLE : DELETE ONE PART ROWS 
select count(*) from hzy_sub1 WHERE A < 100;
DELETE FROM hzy_sub1 WHERE A < 100;
exec dbe_stats.collect_table_stats(
schema =>'SYS',
name =>'HZY_SUB1',
part_name =>'Q1_1999',
sample_ratio =>100,
method_opt =>'for all indexed columns');
select count(*) from HZY_SUB1;
select PARENT_PART#,SUBPART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_SUB_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PARENT_PART#, SUBPART#;
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  order by col#,spare1,spare2;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 4294967295;
select num_rows,blocks,empty_blocks,avg_row_len,samplesize from SYS_TABLES where name = 'HZY_SUB1'; 

select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by id,blevel;
select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

---- CHANGE TABLE : DELETE TWO PART ROWS 
DELETE FROM hzy_sub1 WHERE A < 250;
exec dbe_stats.collect_table_stats(
schema =>'SYS',
name =>'HZY_SUB1',
part_name =>'Q1_1999',
sample_ratio =>100,
method_opt =>'for all indexed columns');
select count(*) from HZY_SUB1;
select PARENT_PART#,SUBPART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_SUB_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PARENT_PART#, SUBPART#;
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  order by col#,spare1,spare2;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 4294967295;
select num_rows,blocks,empty_blocks,avg_row_len,samplesize from SYS_TABLES where name = 'HZY_SUB1'; 

select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by id,blevel;
select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

---- test first gather is single part
drop table if exists hzy_sub1;
CREATE TABLE hzy_sub1(a int, b int, c int)
PARTITION BY RANGE (a)
SUBPARTITION BY range (b)
(
    PARTITION q1_1999 VALUES LESS THAN (250)
    (
        SUBPARTITION q1_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q1_1999_southwest VALUES LESS THAN (MAXVALUE)
    ),
    PARTITION q2_1999 VALUES LESS THAN (500)
    (
        SUBPARTITION q2_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q2_1999_southwest VALUES LESS THAN (MAXVALUE)
    ),
    PARTITION q3_1999 VALUES LESS THAN (750)
    (
        SUBPARTITION q3_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q3_1999_southwest VALUES LESS THAN (MAXVALUE)
    ),
    PARTITION q4_1999 VALUES LESS THAN (1001)
    (
        SUBPARTITION q4_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q4_1999_southwest VALUES LESS THAN (MAXVALUE)
    )
);

delete from high_hist;
insert into high_hist values(0,0,0);
commit;

CREATE or replace procedure storage_proc_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    insert into hzy_sub1 select a+i,b+i,c+i from high_hist;
  END LOOP;
END;
/

call storage_proc_000(1,1000);
commit;

create index hzy_sub1_idx1 on hzy_sub1(a) parallel 4;
create index hzy_sub1_idx2 on hzy_sub1(a,b) parallel 18 local;
create index hzy_sub1_idx3 on hzy_sub1(a,c) local;

exec dbe_stats.collect_table_stats(
schema =>'SYS',
name =>'HZY_SUB1',
part_name =>'Q1_1999',
sample_ratio =>100,
method_opt =>'for all columns');
select count(*) from HZY_SUB1;
select PARENT_PART#,SUBPART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_SUB_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PARENT_PART#, SUBPART#;
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  order by col#,spare1,spare2;

select count(*) from HZY_SUB1 where a < 250;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 10 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 4294967295;
select num_rows,blocks,empty_blocks,avg_row_len,samplesize from SYS_TABLES where name = 'HZY_SUB1'; 

select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by id,blevel;
select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

exec dbe_stats.collect_table_stats(
schema =>'SYS',
name =>'HZY_SUB1',
part_name =>'Q2_1999',
sample_ratio =>100,
method_opt =>'for all columns');

select count(*) from HZY_SUB1 where a > 250 and a < 500;
select PARENT_PART#,SUBPART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_SUB_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PARENT_PART#, SUBPART#;
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  order by col#,spare1,spare2;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 20 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 20 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 0 and part# = 20 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 0 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 20 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 20 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 1 and part# = 20 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 1 and spare1 = 10 and spare2 = 4294967295;

select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 20 and spare1 = 10 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 10;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 20 and spare1 = 20 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 20;
select col#,BUCKET,ENDPOINT,part#,spare1  from SYS_HISTGRAM where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') and col# = 2 and part# = 20 and spare1 = 4294967295 order by ENDPOINT; 
select col#,spare1,spare2,BUCKET_NUM,DIST_NUM,DENSITY from sys.SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'HZY_SUB1')  
and col# = 2 and spare1 = 10 and spare2 = 4294967295;
select num_rows,blocks,empty_blocks,avg_row_len,samplesize from SYS_TABLES where name = 'HZY_SUB1'; 

select BLEVEL,LEVEL_BLOCKS,DISTINCT_KEYS,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE from SYS_INDEXES where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by id,blevel;
select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

select INDEX#,part#,BLEVEL,LEVEL_BLOCKS,DISTKEY,COMB_COLS_2_NDV,COMB_COLS_3_NDV,COMB_COLS_4_NDV from SYS_INDEX_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') 
 order by index#,part#;
select INDEX#,PARENT_PART#,SUBPART#,BLEVEL ,LEVEL_BLOCKS ,DISTKEY ,EMPTY_LEAF_BLOCKS ,CLUFAC ,SAMPLESIZE ,COMB_COLS_2_NDV ,COMB_COLS_3_NDV ,COMB_COLS_4_NDV from SYS_SUB_INDEX_PARTS 
where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by index#,PARENT_PART#,SUBPART#;

--- test drop subpart,drop part
drop table if exists hzy_sub1;
CREATE TABLE hzy_sub1(a int, b int, c int)
PARTITION BY RANGE (a)
SUBPARTITION BY range (b)
(
    PARTITION q1_1999 VALUES LESS THAN (250)
    (
        SUBPARTITION q1_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q1_1999_southwest VALUES LESS THAN (MAXVALUE)
    ),
    PARTITION q2_1999 VALUES LESS THAN (500)
    (
        SUBPARTITION q2_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q2_1999_southwest VALUES LESS THAN (MAXVALUE)
    ),
    PARTITION q3_1999 VALUES LESS THAN (750)
    (
        SUBPARTITION q3_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q3_1999_southwest VALUES LESS THAN (MAXVALUE)
    ),
    PARTITION q4_1999 VALUES LESS THAN (1001)
    (
        SUBPARTITION q4_1999_northwest VALUES LESS THAN (100),
        SUBPARTITION q4_1999_southwest VALUES LESS THAN (MAXVALUE)
    )
);

delete from high_hist;
insert into high_hist values(0,0,0);
commit;

CREATE or replace procedure storage_proc_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    insert into hzy_sub1 select a+i,b+i,c+i from high_hist;
  END LOOP;
END;
/

call storage_proc_000(1,1000);
commit;

exec dbe_stats.collect_table_stats(
schema =>'SYS',
name =>'HZY_SUB1',
part_name => NULL,
sample_ratio =>100,
method_opt =>'for all indexed columns');
select PART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PART#;
select PARENT_PART#,SUBPART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_SUB_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PARENT_PART#, SUBPART#;
select num_rows,blocks,empty_blocks,avg_row_len,samplesize from SYS_TABLES where name = 'HZY_SUB1';
ALTER TABLE HZY_SUB1 DROP PARTITION q1_1999;
select PART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PART#;
select PARENT_PART#,SUBPART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_SUB_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PARENT_PART#, SUBPART#;
select num_rows,blocks,empty_blocks,avg_row_len,samplesize from SYS_TABLES where name = 'HZY_SUB1';

delete from hzy_sub1;
CREATE or replace procedure storage_proc_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    insert into hzy_sub1 select a+i,b+i,c+i from high_hist;
  END LOOP;
END;
/

call storage_proc_000(1,1000);
commit;

exec dbe_stats.collect_table_stats(
schema =>'SYS',
name =>'HZY_SUB1',
part_name => NULL,
sample_ratio =>100,
method_opt =>'for all indexed columns');
select PART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PART#;
select PARENT_PART#,SUBPART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_SUB_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PARENT_PART#, SUBPART#;
select num_rows,blocks,empty_blocks,avg_row_len,samplesize from SYS_TABLES where name = 'HZY_SUB1';
ALTER TABLE HZY_SUB1 DROP SUBPARTITION q2_1999_northwest;
select PART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PART#;
select PARENT_PART#,SUBPART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_SUB_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PARENT_PART#, SUBPART#;
select num_rows,blocks,empty_blocks,avg_row_len,samplesize from SYS_TABLES where name = 'HZY_SUB1';

delete from hzy_sub1;
exec dbe_stats.collect_table_stats(
schema =>'SYS',
name =>'HZY_SUB1',
part_name => NULL,
sample_ratio =>100,
method_opt =>'for all indexed columns');
select PART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PART#;
select PARENT_PART#,SUBPART#,ROWCNT,BLKCNT,EMPCNT,AVGRLN,SAMPLESIZE from SYS_SUB_TABLE_PARTS  where table# = (select id from SYS_TABLES where name = 'HZY_SUB1') order by PARENT_PART#, SUBPART#;
select num_rows,blocks,empty_blocks,avg_row_len,samplesize from SYS_TABLES where name = 'HZY_SUB1';

drop table if exists intervalTable001;
create table intervalTable001(
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
field17 boolean
)PARTITION BY  range(field5)
 interval(100)
(
partition p1 values less than (1000)
);

insert into intervalTable001  values(256,10000000,123.3212,123456.123,123456,'dnf','957',
'78',lpad('345abc',50,'abc'),lpad('345abc',50,'abc'),null,'2004-08-11 00:00:00',
'2012-11-11 00:00:00',interval '2' day,'2016-12-11 00:00:00','2011-12-11 00:00:00','true');

analyze table  intervalTable001 compute statistics;

alter system set cbo = on;
drop table if exists high_hist;
create table high_hist(a int,b int,c int);
insert into high_hist values(0,0,0);
commit;

drop table if exists hzy_sub1;
CREATE TABLE hzy_sub1(a int, b int, c int)
PARTITION BY RANGE (a)
interval(5) 
SUBPARTITION BY range (b)
(
    PARTITION q1_1999 VALUES LESS THAN (10)
    (
        SUBPARTITION q1_1 VALUES LESS THAN (MAXVALUE)
    ),
    PARTITION q2_1999 VALUES LESS THAN (20)
    (
        SUBPARTITION q2_1 VALUES LESS THAN (25),
		SUBPARTITION q2_2 VALUES LESS THAN (50),
        SUBPARTITION q2_3 VALUES LESS THAN (MAXVALUE)
    ),
    PARTITION q3_1999 VALUES LESS THAN (30)
    (
        SUBPARTITION q3_1 VALUES LESS THAN (50),
        SUBPARTITION q3_2 VALUES LESS THAN (MAXVALUE)
    )
);

CREATE or replace procedure storage_proc_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    insert into hzy_sub1 select a+i,b+i,c+i from high_hist;
  END LOOP;
END;
/

call storage_proc_000(1,250);
commit;

drop table if exists hzy_sub1b;
create table hzy_sub1b as select * from hzy_sub1;
create index  idx_sub1 on hzy_sub1(a) local;
create index  idx_sub2 on hzy_sub1(a,c) local;
create index idx_sub4 on hzy_sub1b(b);

exec dbe_stats.collect_table_stats(
schema =>'SYS',
name =>'HZY_SUB1',
part_name =>NULL,
sample_ratio =>100,
method_opt =>'for all indexed columns');

analyze table hzy_sub1B compute statistics;
select count(*) from hzy_sub1 a inner join hzy_sub1b b where a.a < 1000 and a.b < b.a;
alter system set cbo = off;

--gether index of subpart table
drop table if exists test_subpart;
create table test_subpart(id int, f1 int, f2 int)
PARTITION BY RANGE(id) SUBPARTITION by RANGE(f1)(
PARTITION PART_1 VALUES LESS THAN (20)( SUBPARTITION SUBPART_1_1 VALUES LESS THAN (100),SUBPARTITION SUBPART_1_2 VALUES LESS THAN (MAXVALUE)),
PARTITION PART_2 VALUES LESS THAN (40)( SUBPARTITION SUBPART_2_1 VALUES LESS THAN (800),SUBPARTITION SUBPART_2_2 VALUES LESS THAN (MAXVALUE)),
PARTITION PART_3 VALUES LESS THAN (60)( SUBPARTITION SUBPART_3_1 VALUES LESS THAN (2000),SUBPARTITION SUBPART_3_2 VALUES LESS THAN (MAXVALUE)),
PARTITION PART_4 VALUES LESS THAN (80)( SUBPARTITION SUBPART_4_1 VALUES LESS THAN (5000),SUBPARTITION SUBPART_4_2 VALUES LESS THAN (MAXVALUE)),
PARTITION PART_5 VALUES LESS THAN (MAXVALUE)( SUBPARTITION SUBPART_5_1 VALUES LESS THAN (8000),SUBPARTITION SUBPART_5_2 VALUES LESS THAN (MAXVALUE)));

create index test_subpart_index_global on test_subpart(id);
create index test_subpart_index_local on test_subpart(f1) local;

CREATE or replace procedure storage_proc_000(startnum int,endall int) is
i INT :=0;
BEGIN
  FOR i IN startnum..endall LOOP
    insert into test_subpart values(i, i*i, -i);
  END LOOP;
END;
/

call storage_proc_000(1,100);
commit;

ANALYZE INDEX test_subpart_index_global on test_subpart COMPUTE STATISTICS;
select t1.BLEVEL, t1.LEAF_BLOCKS, t1.DISTINCT_KEYS from db_indexes t1 where t1.OWNER='SYS' and t1.INDEX_NAME =upper('test_subpart_index_global');
select a.BLEVEL, a.LEVEL_BLOCKS, a.DISTINCT_KEYS from SYS_INDEXES a,SYS_USERS b where a.user#=b.id and a.name=upper('test_subpart_index_global') and b.name='SYS';

ANALYZE INDEX test_subpart_index_local on test_subpart COMPUTE STATISTICS;
select BLEVEL,LEAF_BLOCKS, DISTINCT_KEYS from ADM_INDEXES where OWNER='SYS' and table_name=upper('test_subpart') and index_name=upper('test_subpart_index_local');
select BLEVEL,LEAF_BLOCKS, DISTINCT_KEYS from ADM_IND_PARTITIONS where INDEX_OWNER='SYS' and index_name=upper('test_subpart_index_local');
select BLEVEL,LEAF_BLOCKS, DISTINCT_KEYS from ADM_IND_SUBPARTITIONS where INDEX_OWNER='SYS' and index_name=upper('test_subpart_index_local') order by DISTINCT_KEYS;

exec DBE_STATS.COLLECT_INDEX_STATS ('SYS','test_subpart_index_local', 'test_subpart', 100);
select BLEVEL,LEAF_BLOCKS, DISTINCT_KEYS from ADM_INDEXES where OWNER='SYS' and table_name=upper('test_subpart') and index_name=upper('test_subpart_index_local');
select BLEVEL,LEAF_BLOCKS, DISTINCT_KEYS from ADM_IND_PARTITIONS where INDEX_OWNER='SYS' and index_name=upper('test_subpart_index_local');
select BLEVEL,LEAF_BLOCKS, DISTINCT_KEYS from ADM_IND_SUBPARTITIONS where INDEX_OWNER='SYS' and index_name=upper('test_subpart_index_local') order by DISTINCT_KEYS;
drop table test_subpart;

--gether index of part table
drop table if exists test_part_table;
create table test_part_table(id int, f1 int, f2 int)
PARTITION BY RANGE(id)(
PARTITION PART_1 VALUES LESS THAN (200),
PARTITION PART_2 VALUES LESS THAN (400),
PARTITION PART_3 VALUES LESS THAN (600),
PARTITION PART_4 VALUES LESS THAN (800),
PARTITION PART_5 VALUES LESS THAN (MAXVALUE));

create index test_part_table_index_global on test_part_table(id);
create index test_part_table_index_local on test_part_table(f1) local;

CREATE or replace procedure storage_proc_000(startnum int,endall int) is
i INT :=0;
BEGIN
  FOR i IN startnum..endall LOOP
    insert into test_part_table values(i, i*i, -i);
  END LOOP;
END;
/

call storage_proc_000(1,1000);
commit;

ANALYZE INDEX test_part_table_index_global on test_part_table COMPUTE STATISTICS;
select t1.BLEVEL, t1.LEAF_BLOCKS, t1.DISTINCT_KEYS from db_indexes t1 where t1.OWNER='SYS' and t1.INDEX_NAME =upper('test_part_table_index_global');
select a.BLEVEL, a.LEVEL_BLOCKS, a.DISTINCT_KEYS from SYS_INDEXES a,SYS_USERS b where a.user#=b.id and a.name=upper('test_part_table_index_global') and b.name='SYS';

ANALYZE INDEX test_part_table_index_local on test_part_table COMPUTE STATISTICS;
select BLEVEL,LEAF_BLOCKS, DISTINCT_KEYS from ADM_INDEXES where OWNER='SYS' and table_name=upper('test_part_table') and index_name=upper('test_part_table_index_local');
select BLEVEL,LEAF_BLOCKS, DISTINCT_KEYS from ADM_IND_PARTITIONS where INDEX_OWNER='SYS' and index_name=upper('test_part_table_index_local') order by DISTINCT_KEYS;

exec DBE_STATS.COLLECT_INDEX_STATS ('SYS','test_part_table_index_local', 'test_part_table', 100);
select BLEVEL,LEAF_BLOCKS, DISTINCT_KEYS from ADM_INDEXES where OWNER='SYS' and table_name=upper('test_part_table') and index_name=upper('test_part_table_index_local');
select BLEVEL,LEAF_BLOCKS, DISTINCT_KEYS from ADM_IND_PARTITIONS where INDEX_OWNER='SYS' and index_name=upper('test_part_table_index_local') order by DISTINCT_KEYS;
drop table test_part_table;