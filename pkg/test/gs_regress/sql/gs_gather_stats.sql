--
-- gs_gather_stats
-- testing system procedure
--
set serveroutput on;

--test case 1: test GATHER_DB_STATS()
drop table if exists SYS_STATS_T1;
CREATE TABLE sys_stats_t1 (F_INT1 INT, F_INT2 INT, F_INT3 INT, F_INT4 INT,F_CHAR VARCHAR(16));
INSERT INTO sys_stats_t1 VALUES(1,2,3,4,'ABCFDD');
INSERT INTO sys_stats_t1 VALUES(1,2,3,4,'ABCFDD');
COMMIT;

drop table if exists SYS_STATS_T2;        
CREATE TABLE sys_stats_t2 (F_INT1 INT, F_INT2 INT, F_INT3 INT, F_INT4 INT,F_CHAR VARCHAR(16));    
INSERT INTO sys_stats_t2 VALUES(1,2,3,4,'ABCFDD');
INSERT INTO sys_stats_t2 VALUES(1,2,3,4,'ABCFDD');
COMMIT;

drop table if exists SYS_STATS_T_PART1; 
create table SYS_STATS_T_PART1(id int,ware_name varchar2(50))
partition by range(id)
(
partition par_01 values less than(10),
partition par_02 values less than(20),
partition par_03 values less than(30),
partition par_04 values less than(40)
);

INSERT INTO SYS_STATS_T_PART1 VALUES(1,'ABCFDD');
INSERT INTO SYS_STATS_T_PART1 VALUES(2,'ABCFDD');
INSERT INTO SYS_STATS_T_PART1 VALUES(3,'ABCFDD');
COMMIT;

exec GATHER_DB_STATS(estimate_percent=>10, force=>TRUE);

--EXPECT 3
SELECT COUNT(*) FROM ADM_TABLES WHERE TABLE_NAME in ('SYS_STATS_T1','SYS_STATS_T2','SYS_STATS_T_PART1') AND LAST_ANALYZED is NOT NULL;

drop table if exists SYS_STATS_T4;        
CREATE TABLE SYS_STATS_T4 (F_INT1 INT, F_INT2 INT, F_INT3 INT, F_INT4 INT,F_CHAR VARCHAR(16));    
INSERT INTO SYS_STATS_T4 VALUES(1,2,3,4,'ABCFDD');
INSERT INTO SYS_STATS_T4 VALUES(1,2,3,4,'ABCFDD');
COMMIT;

drop table if exists SYS_STATS_T5;        
CREATE TABLE SYS_STATS_T5 (F_INT1 INT, F_INT2 INT, F_INT3 INT, F_INT4 INT,F_CHAR VARCHAR(16));   

drop table if exists SYS_STATS_T_PART2; 
create table SYS_STATS_T_PART2(id int,ware_name varchar2(50))
partition by range(id)
(
partition par_01 values less than(10),
partition par_02 values less than(20),
partition par_03 values less than(30),
partition par_04 values less than(40)
);

drop table if exists SYS_STATS_T_PART3; 
create table SYS_STATS_T_PART3(id int,ware_name varchar2(50))
partition by range(id)
(
partition par_01 values less than(10),
partition par_02 values less than(20),
partition par_03 values less than(30),
partition par_04 values less than(40)
);

INSERT INTO SYS_STATS_T_PART3 VALUES(1,'ABCFDD');
INSERT INTO SYS_STATS_T_PART3 VALUES(2,'ABCFDD');
INSERT INTO SYS_STATS_T_PART3 VALUES(3,'ABCFDD');
COMMIT;

drop table if exists SYS_STATS_T_PART4; 
create table SYS_STATS_T_PART4(id int,ware_name varchar2(50))
partition by range(id)
(
partition par_01 values less than(10),
partition par_02 values less than(20),
partition par_03 values less than(30),
partition par_04 values less than(40)
);


declare
start_time   DATE;
tab_count    number;
begin
start_time := SYSDATE;
sleep(1);
GATHER_DB_STATS(estimate_percent=>10, force=>TRUE);
SELECT COUNT(*) into tab_count FROM ADM_TABLES WHERE TABLE_NAME like 'SYS_STATS_T%' AND LAST_ANALYZED > start_time;

--expect 8
dbe_output.print_line('table count:'||tab_count);
end;
/

--test case 2: test GATHER_CHANGE_STATS()
ALTER TABLE SYS_STATS_T_PART3 add partition p5 values less than(50);
ALTER TABLE SYS_STATS_T_PART4 add partition p5 values less than(50);

INSERT INTO sys_stats_t1 VALUES(1,2,3,4,'ABCFDD');
INSERT INTO SYS_STATS_T_PART1 VALUES(1,'ABCFDD');
INSERT INTO SYS_STATS_T_PART1 VALUES(30,'ABCFDD');
INSERT INTO sys_stats_t5 VALUES(1,2,3,4,'ABCFDD');
INSERT INTO SYS_STATS_T_PART2 VALUES(1,'ABCFDD');
INSERT INTO SYS_STATS_T_PART4 VALUES(1,'ABCFDD');
COMMIT;


drop table if exists SYS_STATS_T7;        
CREATE TABLE SYS_STATS_T7 (F_INT1 INT, F_INT2 INT, F_INT3 INT, F_INT4 INT,F_CHAR VARCHAR(16));   

drop table if exists SYS_STATS_T_PART5; 
create table SYS_STATS_T_PART5(id int,ware_name varchar2(50))
partition by range(id)
(
partition par_01 values less than(10),
partition par_02 values less than(20),
partition par_03 values less than(30),
partition par_04 values less than(40)
);

declare
start_time   DATE;
tab_count    number;
begin
sleep(1);
start_time := SYSDATE;
sleep(1);
GATHER_CHANGE_STATS(estimate_percent=>10, change_percent=>10, force=>TRUE);
SELECT COUNT(*) into tab_count FROM ADM_TABLES WHERE TABLE_NAME like 'SYS_STATS_T_PART%' AND LAST_ANALYZED > start_time;

--expect 4
dbe_output.print_line('table count:'||tab_count);
end;
/


declare 
sql varchar2(256);
begin
  for item in (SELECT TABLE_NAME FROM ADM_TABLES WHERE TABLE_NAME like 'SYS_STATS_T%')
  loop
	sql := 'drop table if exists '||item.table_name;
	execute immediate sql;
	end loop;
end;
/	

set serveroutput off;

drop table if exists hzy_high_ndv1;
drop table if exists hzy_ndv1;
create table hzy_ndv1(a int);
insert into hzy_ndv1 values(0);
create table hzy_high_ndv1(a int)
partition by range(A)
(
   partition p_ndv1 values less than (101),
   partition p_ndv2 values less than (201),
   partition p_ndv3 values less than (301)
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
call storage_proc_000(1,100);
call storage_proc_000(101,200);
call storage_proc_000(201,300);
commit;

exec DBE_STATS.COLLECT_TABLE_STATS('SYS', 'hzy_high_ndv1', 'p_ndv1');
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY,SPARE1 from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_NDV1') ORDER BY SPARE1;
select part#,rowcnt,blkcnt,empcnt,samplesize from SYS_TABLE_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_NDV1') order by part#;
select NUM_ROWS,BLOCKS,EMPTY_BLOCKS,SAMPLESIZE FROM SYS_TABLES WHERE NAME = 'HZY_HIGH_NDV1';

exec DBE_STATS.COLLECT_TABLE_STATS('SYS', 'hzy_high_ndv1', 'p_ndv3');
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY,SPARE1 from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_NDV1') ORDER BY SPARE1;
select part#,rowcnt,blkcnt,empcnt,samplesize from SYS_TABLE_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_NDV1') order by part#;
select NUM_ROWS,BLOCKS,EMPTY_BLOCKS,SAMPLESIZE FROM SYS_TABLES WHERE NAME = 'HZY_HIGH_NDV1';

exec DBE_STATS.COLLECT_TABLE_STATS('SYS', 'hzy_high_ndv1', 'p_ndv2');
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY,SPARE1 from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_NDV1') ORDER BY SPARE1;
select part#,rowcnt,blkcnt,empcnt,samplesize from SYS_TABLE_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_NDV1') order by part#;
select NUM_ROWS,BLOCKS,EMPTY_BLOCKS,SAMPLESIZE FROM SYS_TABLES WHERE NAME = 'HZY_HIGH_NDV1';

alter table HZY_HIGH_NDV1 drop partition p_ndv3;
select NUM_ROWS,BLOCKS,EMPTY_BLOCKS,SAMPLESIZE FROM SYS_TABLES WHERE NAME = 'HZY_HIGH_NDV1';
select part#,rowcnt,blkcnt,empcnt,samplesize from SYS_TABLE_PARTS where table# = (select id from SYS_TABLES where name = 'HZY_HIGH_NDV1') order by part#;

alter table HZY_HIGH_NDV1 add partition p_ndv4 values less than(401);
call storage_proc_000(301,400);
commit;

exec DBE_STATS.COLLECT_TABLE_STATS('SYS', 'hzy_high_ndv1', 'p_ndv4');
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY,SPARE1 from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_NDV1')
ORDER BY SPARE1;
select NUM_ROWS,BLOCKS,EMPTY_BLOCKS,SAMPLESIZE FROM SYS_TABLES WHERE NAME = 'HZY_HIGH_NDV1';

alter table HZY_HIGH_NDV1 drop partition p_ndv2;
select NUM_ROWS,BLOCKS,EMPTY_BLOCKS,SAMPLESIZE FROM SYS_TABLES WHERE NAME = 'HZY_HIGH_NDV1';

alter table HZY_HIGH_NDV1 add partition p_ndv5 values less than(501);
call storage_proc_000(401,500);
commit;

exec DBE_STATS.COLLECT_TABLE_STATS('SYS', 'hzy_high_ndv1', 'p_ndv5');
select BUCKET_NUM,ROW_NUM,NULL_NUM,MINVALUE,MAXVALUE,DIST_NUM,DENSITY,SPARE1 from SYS_HISTGRAM_ABSTR where tab# = (select id from SYS_TABLES where name = 'HZY_HIGH_NDV1')
ORDER BY SPARE1;
select NUM_ROWS,BLOCKS,EMPTY_BLOCKS,SAMPLESIZE FROM SYS_TABLES WHERE NAME = 'HZY_HIGH_NDV1';
drop table if exists hzy_high_ndv1;
drop table if exists hzy_ndv1;

drop table  if exists TB_A_TEST_MDY_COLOUM;
create table TB_A_TEST_MDY_COLOUM(TB_A_TEST_MDY_COLOUM int);
insert into TB_A_TEST_MDY_COLOUM values(1);
insert into TB_A_TEST_MDY_COLOUM values(2);
insert into TB_A_TEST_MDY_COLOUM values(3);
analyze table TB_A_TEST_MDY_COLOUM compute statistics;

select col#,spare1,BUCKET_NUM,DIST_NUM,DENSITY from sys. SYS_HISTGRAM_ABSTR where tab# = (select id from sys.SYS_TABLES where name = 'TB_A_TEST_MDY_COLOUM')  order by col#,spare1;
drop table  if exists TB_A_TEST_MDY_COLOUM;