drop user if exists hzy_sts_rep cascade;
create user hzy_sts_rep identified by Cantian_234;

drop table if exists hzy_sts_rep.STATS_INTERVAL_REP;
create table hzy_sts_rep.STATS_INTERVAL_REP(
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
c_text blob);
CREATE INDEX hzy_sts_rep.hzy_sts_rep_indx_087 ON hzy_sts_rep.STATS_INTERVAL_REP(c_d_id,c_last);
CREATE INDEX hzy_sts_rep.hzy_sts_rep_indx_088 ON hzy_sts_rep.STATS_INTERVAL_REP(c_w_id);
CREATE INDEX hzy_sts_rep.hzy_sts_rep_indx_089 ON hzy_sts_rep.STATS_INTERVAL_REP(c_d_id, c_w_id, c_last);
ANALYZE TABLE  hzy_sts_rep.STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT;

CREATE or replace procedure hzy_sts_rep.lob_hzy_proc_1115(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from dual;
    insert into  hzy_sts_rep.STATS_INTERVAL_REP select i,i,i,'is'||j||'cmRDs'||j,'OE','BAR'||j||'Bar'||j,'bkili'||j||'fcrRGF'||j,'pmbwo'||j||'vhSDGj'||j,'dyf'||j||'rDa'||j,'uq',4801||j,940||j||215||j,'2011-12-11 00:00:00','GC',50000.0,0.4361328,-10.0,10.0,1,true,'2011-12-11 00:00:00','dasd'||j,'dasdsd'||j,'\x1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323';
  END LOOP;
END;
/
call hzy_sts_rep.lob_hzy_proc_1115(1,20);
call hzy_sts_rep.lob_hzy_proc_1115(1,15);
call hzy_sts_rep.lob_hzy_proc_1115(10,30);
call hzy_sts_rep.lob_hzy_proc_1115(50,100);
call hzy_sts_rep.lob_hzy_proc_1115(50,150);
commit;
ANALYZE TABLE  hzy_sts_rep.STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT;
ANALYZE TABLE  hzy_sts_rep.STATS_INTERVAL_REP COMPUTE STATISTICS;
ANALYZE TABLE  hzy_sts_rep.STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT SAMPLE 30;

drop table if exists hzy_sts_rep.STATS_INTERVAL_REP;
create GLOBAL TEMPORARY table hzy_sts_rep.STATS_INTERVAL_REP(
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
c_text blob);
CREATE INDEX hzy_sts_rep.hzy_sts_rep_indx_087 ON hzy_sts_rep.STATS_INTERVAL_REP(c_d_id,c_last);
CREATE INDEX hzy_sts_rep.hzy_sts_rep_indx_088 ON hzy_sts_rep.STATS_INTERVAL_REP(c_w_id);
CREATE INDEX hzy_sts_rep.hzy_sts_rep_indx_089 ON hzy_sts_rep.STATS_INTERVAL_REP(c_d_id, c_w_id, c_last);
ANALYZE TABLE  hzy_sts_rep.STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT;
ANALYZE TABLE  hzy_sts_rep.STATS_INTERVAL_REP COMPUTE STATISTICS;
ANALYZE TABLE  hzy_sts_rep.STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT;
ANALYZE TABLE  hzy_sts_rep.STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT SAMPLE 40;

CREATE or replace procedure hzy_sts_rep.lob_hzy_proc_1115(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from dual;
    insert into  hzy_sts_rep.STATS_INTERVAL_REP select i,i,i,'is'||j||'cmRDs'||j,'OE','BAR'||j||'Bar'||j,'bkili'||j||'fcrRGF'||j,'pmbwo'||j||'vhSDGj'||j,'dyf'||j||'rDa'||j,'uq',4801||j,940||j||215||j,'2011-12-11 00:00:00','GC',50000.0,0.4361328,-10.0,10.0,1,true,'2011-12-11 00:00:00','dasd'||j,'dasdsd'||j,'\x1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323';
  END LOOP;
END;
/
call hzy_sts_rep.lob_hzy_proc_1115(1,20);
call hzy_sts_rep.lob_hzy_proc_1115(1,15);
call hzy_sts_rep.lob_hzy_proc_1115(10,30);
call hzy_sts_rep.lob_hzy_proc_1115(50,100);
commit;
ANALYZE TABLE  hzy_sts_rep.STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT;
ANALYZE TABLE  hzy_sts_rep.STATS_INTERVAL_REP COMPUTE STATISTICS;
ANALYZE TABLE  hzy_sts_rep.STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT SAMPLE 30;

ALTER SYSTEM SET LOCAL_TEMPORARY_TABLE_ENABLED=TRUE;
drop table if exists hzy_sts_rep.#STATS_INTERVAL_REP;
create TEMPORARY table hzy_sts_rep.#STATS_INTERVAL_REP(
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
c_text blob);
CREATE INDEX hzy_sts_rep.hzy_sts_rep_indx_087 ON hzy_sts_rep.#STATS_INTERVAL_REP(c_d_id,c_last);
CREATE INDEX hzy_sts_rep.hzy_sts_rep_indx_088 ON hzy_sts_rep.#STATS_INTERVAL_REP(c_w_id);
CREATE INDEX hzy_sts_rep.hzy_sts_rep_indx_089 ON hzy_sts_rep.#STATS_INTERVAL_REP(c_d_id, c_w_id, c_last);
ANALYZE TABLE  hzy_sts_rep.#STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT;
ANALYZE TABLE  hzy_sts_rep.#STATS_INTERVAL_REP COMPUTE STATISTICS;
ANALYZE TABLE  hzy_sts_rep.#STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT;
ANALYZE TABLE  hzy_sts_rep.#STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT SAMPLE 40;

CREATE or replace procedure hzy_sts_rep.lob_hzy_proc_1115(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from dual;
    insert into  hzy_sts_rep.#STATS_INTERVAL_REP select i,i,i,'is'||j||'cmRDs'||j,'OE','BAR'||j||'Bar'||j,'bkili'||j||'fcrRGF'||j,'pmbwo'||j||'vhSDGj'||j,'dyf'||j||'rDa'||j,'uq',4801||j,940||j||215||j,'2011-12-11 00:00:00','GC',50000.0,0.4361328,-10.0,10.0,1,true,'2011-12-11 00:00:00','dasd'||j,'dasdsd'||j,'\x1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323';
  END LOOP;
END;
/
call hzy_sts_rep.lob_hzy_proc_1115(1,20);
call hzy_sts_rep.lob_hzy_proc_1115(10,30);
call hzy_sts_rep.lob_hzy_proc_1115(50,100);
commit;
ANALYZE TABLE  hzy_sts_rep.#STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT;
ANALYZE TABLE  hzy_sts_rep.#STATS_INTERVAL_REP COMPUTE STATISTICS;
ANALYZE TABLE  hzy_sts_rep.#STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT SAMPLE 30;
ALTER SYSTEM SET LOCAL_TEMPORARY_TABLE_ENABLED=FALSE;

drop table if exists hzy_sts_rep.STATS_INTERVAL_REP;
create table hzy_sts_rep.STATS_INTERVAL_REP(
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

CREATE INDEX hzy_sts_rep.hzy_sts_rep_indx_087 ON hzy_sts_rep.STATS_INTERVAL_REP(c_d_id,c_last) local;
CREATE INDEX hzy_sts_rep.hzy_sts_rep_indx_088 ON hzy_sts_rep.STATS_INTERVAL_REP(c_w_id);
CREATE INDEX hzy_sts_rep.hzy_sts_rep_indx_089 ON hzy_sts_rep.STATS_INTERVAL_REP(c_d_id, c_w_id, c_last);
ANALYZE TABLE  hzy_sts_rep.STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT;

CREATE or replace procedure hzy_sts_rep.lob_hzy_proc_1115(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from dual;
    insert into  hzy_sts_rep.STATS_INTERVAL_REP select i,i,i,'is'||j||'cmRDs'||j,'OE','BAR'||j||'Bar'||j,'bkili'||j||'fcrRGF'||j,'pmbwo'||j||'vhSDGj'||j,'dyf'||j||'rDa'||j,'uq',4801||j,940||j||215||j,'2011-12-11 00:00:00','GC',50000.0,0.4361328,-10.0,10.0,1,true,'2011-12-11 00:00:00','dasd'||j,'dasdsd'||j,'\x1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323';
  END LOOP;
END;
/
call hzy_sts_rep.lob_hzy_proc_1115(1,20);
call hzy_sts_rep.lob_hzy_proc_1115(25,45);
call hzy_sts_rep.lob_hzy_proc_1115(50,100);
commit;
ANALYZE TABLE  hzy_sts_rep.STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT;
exec DBE_STATS.COLLECT_TABLE_STATS('hzy_sts_rep', 'STATS_INTERVAL_REP', 'PART_H1',30);
ANALYZE TABLE  hzy_sts_rep.STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT;
ANALYZE TABLE  hzy_sts_rep.STATS_INTERVAL_REP COMPUTE STATISTICS FOR REPORT SAMPLE 40;

drop user if exists hzy_sts_rep cascade;

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
exec DBE_STATS.COLLECT_TABLE_STATS('SYS', 'FVT_LIST_INDEX32_TABLE_001', part_name=>NULL,sample_ratio => 10,method_opt=>'for all indexed columns');
select COL# ,ROW_NUM from SYS_HISTGRAM_ABSTR where  TAB# = (select id from sys_tables where name = 'FVT_LIST_INDEX32_TABLE_001') and col# = 2 order by SPARE1;
