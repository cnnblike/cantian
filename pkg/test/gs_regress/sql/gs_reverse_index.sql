drop table if exists test_reverse;
create table test_reverse(
c_id int,
c_d_id uint NOT NULL,
c_w_id bigint NOT NULL,
c_first varchar(50) NOT NULL,
c_middle char(2),
c_last varchar(16) NOT NULL,
c_street_1 varchar(20) NOT NULL,
c_street_2 varchar(20),
c_city varbinary(20),
c_state char(2) NOT NULL,
c_zip char(9) NOT NULL,
c_phone binary(16),
c_since timestamp,
c_since_tz timestamp with time zone,
c_credit_lim numeric(12,2),
c_discount numeric(4,4),
c_balance numeric(12,2),
c_ytd_payment real,
c_payment_cnt number,
c_delivery_cnt bool,
c_end date NOT NULL,
c_data varchar(1000),
c_clob clob,
c_text blob) 
partition by range(c_id) 
(
   partition PART_1 values less than (10),
   partition PART_2 values less than (20),
   partition PART_3 values less than (30),
   partition PART_4 values less than (40),
   partition PART_5 values less than (50),
   partition PART_6 values less than (60),
   partition PART_7 values less than (70),
   partition PART_8 values less than (80),
   partition PART_9 values less than (maxvalue)
);

CREATE or replace procedure reverse_idx_proc(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from sys_dummy;
    insert into test_reverse select i,i,i,'is'||j||'cmRDs'||j,'OE','BAR'||j||'Bar'||j,'bkili'||j||'fcrRGF'||j,'pmbwo'||j||'vhSDGj'||j,'dyf'||j||'rDa'||j,'uq',4801||j,940||j||215||j,'2011-12-11 00:00:00','2011-12-11 00:00:00.00000 +08:00',50000.0,0.4361328,-10.0,10.0,1,true,'2011-12-11 00:00:00','dasd'||j,'dasdsd'||j,'\x1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323';
  END LOOP;
END;
/
call reverse_idx_proc(1,100);
commit;
insert into test_reverse select * from test_reverse;
insert into test_reverse select * from test_reverse;
commit;
CREATE INDEX usidx1 ON test_reverse(c_id) reverse;
CREATE INDEX usidx2 ON test_reverse(c_d_id) local reverse;
CREATE INDEX usidx3 ON test_reverse(c_w_id, c_last) local reverse;
CREATE INDEX usidx4 ON test_reverse(c_id, c_since_tz) reverse;
CREATE INDEX usidx5 ON test_reverse(c_since) local reverse;
CREATE INDEX usidx6 ON test_reverse(c_w_id, c_phone) local reverse;
CREATE INDEX usidx7 ON test_reverse(c_street_2) reverse;
CREATE INDEX usidx8 ON test_reverse(c_first) local reverse;
CREATE INDEX usidx9 ON test_reverse(c_city, c_last) local reverse;
CREATE INDEX usidx10 ON test_reverse(c_ytd_payment) reverse;
CREATE INDEX usidx11 ON test_reverse(c_phone) local reverse;
CREATE INDEX usidx12 ON test_reverse(c_payment_cnt, c_last) local reverse;
CREATE INDEX usidx13 ON test_reverse(c_balance) reverse;
CREATE INDEX usidx14 ON test_reverse(c_state) local reverse;
CREATE INDEX usidx15 ON test_reverse(c_d_id, c_delivery_cnt) local reverse;
CREATE INDEX usidx16 ON test_reverse(c_end) reverse;
CREATE INDEX usidx17 ON test_reverse(c_credit_lim) local reverse;
CREATE INDEX usidx18 ON test_reverse(c_street_1, c_last) local reverse;
CREATE INDEX usidx19 ON test_reverse(c_middle) reverse;
CREATE INDEX usidx20 ON test_reverse(c_payment_cnt) local reverse;
CREATE INDEX usidx21 ON test_reverse(c_first, c_last) local reverse;
CREATE INDEX usidx22 ON test_reverse(c_text) reverse;
CREATE INDEX usidx23 ON test_reverse(upper(c_d_id)) local reverse;
CREATE INDEX usidx24 ON test_reverse(c_w_id, c_payment_cnt) local reverse;
CREATE INDEX usidx25 ON test_reverse(to_char(c_id)) reverse;
CREATE INDEX usidx26 ON test_reverse(upper(c_ytd_payment)) local reverse;
CREATE INDEX usidx27 ON test_reverse(c_data, c_last) local reverse;
CREATE INDEX usidx28 ON test_reverse(c_w_id, upper(c_text)) local reverse;
CREATE INDEX usidx29 ON test_reverse(c_id);
CREATE INDEX usidx30 ON test_reverse(c_discount) local reverse;
CREATE INDEX usidx31 ON test_reverse(c_zip, to_char(c_last)) local reverse;
CREATE INDEX usidx32 ON test_reverse(upper(c_state)) reverse;

delete from test_reverse; commit;
call reverse_idx_proc(101,200);
commit;
update test_reverse set c_since_tz = '2021-12-11 00:00:00.00000 -04:00' , c_discount = 0 , c_balance = null , c_city = '';
update test_reverse set c_since_tz = '2091-12-11 00:00:00.00000 -04:00' , c_balance = 0 , c_delivery_cnt = null , c_street_2 = '';
update test_reverse set c_since_tz = '2011-12-11 00:00:00.00000 +03:00' , c_balance = null, c_street_2 = 'sdd' , c_since = null;
rollback;
drop table if exists test_reverse;

drop table if exists match_cond;
create table match_cond(c1 int, c2 int, c3 int, c4 int, c5 int);
create index ix_match_cond on match_cond(c1, c2, c3, c4);
create or replace procedure load_data() as
    a int;
    b int;
    c int;
    d int;
begin
    for a in 1..10 loop
        for b in 1..10 loop
            for c in 1..10 loop
                for d in 1..10 loop
                    execute immediate 'insert into match_cond values('||a||', '||b||', '||c||', '||d||', 1)';
                end loop;
            end loop;
        end loop;
    end loop;
    commit;
end;
/

call load_data();
drop index ix_match_cond on match_cond;
create index ix_match_cond on match_cond(c1, c2, c3, c4) reverse;
drop table if exists match_cond;

DROP TABLE IF EXISTS TEST_MULTI_KEY;
CREATE TABLE TEST_MULTI_KEY(F1 INT, F2 INT);
INSERT INTO TEST_MULTI_KEY VALUES(1,1);
INSERT INTO TEST_MULTI_KEY VALUES(2,2);
INSERT INTO TEST_MULTI_KEY VALUES(3,3);
INSERT INTO TEST_MULTI_KEY VALUES(4,4);
INSERT INTO TEST_MULTI_KEY VALUES(5,5);
CREATE INDEX IDX_TEST_MULTI_KEY_1 ON TEST_MULTI_KEY(F1) parallel 4 reverse;
DROP TABLE IF EXISTS TEST_MULTI_KEY;

DROP TABLE IF EXISTS TC_NUMBER2_TBL_HASH_002;
CREATE TABLE TC_NUMBER2_TBL_HASH_002(C_ID NUMBER2 NOT NULL,C_D_ID BIGINT,C_W_ID TINYINT UNSIGNED,C_FIRST VARCHAR(16),C_MIDDLE VARCHAR(10),C_LAST VARCHAR(16),C_STREET_1 VARCHAR(20),C_STREET_2 VARCHAR(20),C_CITY VARCHAR(20),C_STATE CHAR(2),C_ZIP CHAR(9),C_PHONE CHAR(16),C_SINCE TIMESTAMP,C_CREDIT CHAR(2),C_CREDIT_LIM NUMERIC,C_DISCOUNT NUMERIC(5,2),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL,C_PAYMENT_CNT_1 NUMBER2(6,2) NOT NULL,C_PAYMENT_CNT_2 NUMBER2(6,2),C_PAYMENT_CNT_3 NUMBER2(8,4),C_DELIVERY_CNT BOOL,C_END DATE,C_DATA1 VARCHAR(7744),C_DATA2 VARCHAR(7744),C_DATA3 VARCHAR(7744),C_DATA4 VARCHAR(7744),C_DATA5 VARCHAR(7744),C_DATA6 VARCHAR(7744),C_DATA7 VARCHAR(7744),C_DATA8 VARCHAR(7744),C_CLOB CLOB,C_BLOB BLOB) partition by hash(c_id)(partition p1,partition p2,partition p3,partition p4);

INSERT INTO TC_NUMBER2_TBL_HASH_002 SELECT 0,0,0,'ISCMRDS','OA','BARBAR','BKILIFCRRGF','PMBWOVHSDGJ','DYFRDA','UQ','4801','940215',TO_DATE('2019-04-01','YYYY-MM-DD'),'GC',10000.0,0.4361328,-10.0,10.12,0.1,0,1.9,TRUE,SYSDATE,LPAD('QVBRFSCC3484942ZCSFJVCF',300,'QVLDBURHLHFRC484ZCSFJF'),LPAD('QVBUFLCHOQNVMGFVDPFZSF',300,'QVLDFSCHOQGFVMPFZDSF'),LPAD('QVBUFLCHOQNVMGFVDPFZSF',300,'QVLDFSCHOQGFVMPFZDSF'),LPAD('QVBUFLCHOQNVMGFVDPFZSF',300,'QVLDFSCHOQGFVMPFZDSF'),LPAD('QVBUFLCHOQNVMGFVDPFZSF',300,'QVLDFSCHOQGFVMPFZDSF'),LPAD('QVBUFLCHOQNVMGFVDPFZSF',300,'QVLDFSCHOQGFVMPFZDSF'),LPAD('QVBUFLCHOQNVMGFVDPFZSF',300,'QVLDFSCHOQGFVMPFZDSF'),LPAD('QVBUFLCHOQNVMGFVDPFZSF',300,'QVLDFSCHOQGFVMPFZDSF'),LPAD('QVBUFLCHOQNVMGFVDPFZSF',500,'QVLDFSCHOQGFVMPFZDSF'),LPAD('12314315487569809',500,'1435764ABC7890ABCDEF');
commit;
create indexcluster (index TC_NUMBER2_IDX_HASH_002_1 on TC_NUMBER2_TBL_HASH_002(C_ID,C_D_ID,C_PAYMENT_CNT_2) REVERSE PARALLEL 10,index TC_NUMBER2_IDX_HASH_002_2 on TC_NUMBER2_TBL_HASH_002(C_ID,C_PAYMENT_CNT_3) REVERSE PARALLEL 10,index TC_NUMBER2_IDX_HASH_002_3 on TC_NUMBER2_TBL_HASH_002(C_PAYMENT_CNT_1) REVERSE PARALLEL 10);

select distinct C_PAYMENT_CNT_1 from TC_NUMBER2_TBL_HASH_002 order by 1 limit 10;
alter table TC_NUMBER2_TBL_HASH_002 modify C_PAYMENT_CNT_1 number2(38,5);
update TC_NUMBER2_TBL_HASH_002 set C_PAYMENT_CNT_1=12345678901.111;
select distinct C_PAYMENT_CNT_1 from TC_NUMBER2_TBL_HASH_002 order by 1 limit 10;

select distinct C_PAYMENT_CNT_2 from TC_NUMBER2_TBL_HASH_002 order by 1 limit 10;
alter table TC_NUMBER2_TBL_HASH_002 modify C_PAYMENT_CNT_2 number2(18,6);
update TC_NUMBER2_TBL_HASH_002 set C_PAYMENT_CNT_2=1234567899.111;
select distinct C_PAYMENT_CNT_2 from TC_NUMBER2_TBL_HASH_002 order by 1 limit 10;

select distinct C_PAYMENT_CNT_3 from TC_NUMBER2_TBL_HASH_002 order by 1 limit 10;
alter table TC_NUMBER2_TBL_HASH_002 modify C_PAYMENT_CNT_3 number2(9,5);
select distinct C_PAYMENT_CNT_3 from TC_NUMBER2_TBL_HASH_002 order by 1 limit 10;
DROP TABLE IF EXISTS TC_NUMBER2_TBL_HASH_002;