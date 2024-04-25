---- RCR test ------
--1. prepare
drop table if exists tb1;
CREATE TABLE tb1(id int, b int) crmode row;
create index idx_tb1 on tb1(b);
drop table if exists test_part_1;
create table test_part_1(f1 int, f2 real, f3 number)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(40)
) crmode row;
create index idx_p1_1 on test_part_1(f1);
create index idx_p1_2 on test_part_1(f2,f3) local;
create index idx_p1_3 on test_part_1(f1,f3) local
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
    for i in 1 .. 4000 loop
        execute immediate 'insert into tb1 values(1, ' || i || ')';
        execute immediate 'commit';
    end loop;
    commit;
end;
/

insert into tb1 values(1, 10000);
commit;
select PAGES from USER_SEGMENTS where SEGMENT_NAME = 'IDX_TB1';
delete from tb1 where b < 10000;
commit;

--4. partition table
declare
    i integer;
begin
    for i in 1 .. 4000 loop
        execute immediate 'insert into test_part_1 values(1, 1, ' || i || ')';
        execute immediate 'commit';
    end loop;
    commit;
end;
/
commit;
select PAGES from user_segments where SEGMENT_NAME = 'IDX_P1_2' and PARTITION_NAME = 'P1';
delete from test_part_1 where f1=1;
commit;

--create a table to force inc min scn
drop table if exists test_coalesce;
create table test_coalesce(id int);
select sleep(1);
--recycle
alter index idx_tb1 on tb1 coalesce;
alter index idx_tb1 on tb1 coalesce index;
alter index idx_tb1 on tb1 coalesce partition p1;
alter index idx_tb1 on tb1 coalesce aaa;
alter index idx_p1_1 on test_part_1 coalesce;
alter index idx_p1_2 on test_part_1 modify partition p1 coalesce;
alter index idx_p1_2 on test_part_1 modify partition p1 coalesce index;
alter index idx_p1_2 on test_part_1 modify partition p1 coalesce aaa;
--commit a transaction to force increase scn
insert into test_coalesce values(1);
commit;
select sleep(1);
--3. test for error code
alter index idx_p1_1 on test_part_1 modify partition p1 coalesce;
alter index idx_p1_2 on test_part_1 coalesce;
alter index idx_tb1 on tb1 modify partition p1 coalesce;
ALTER INDEX idx_p1_3 on test_part_1 MODIFY PARTITION p10 COALESCE;
ALTER INDEX idx_p1_4 on test_part_1 MODIFY PARTITION p1 COALESCE;


declare
    i integer;
begin
    for i in 1 .. 2000 loop
        execute immediate 'insert into tb1 values(1, 10000 + ' || i || ')';
        execute immediate 'commit';
    end loop;
    commit;
end;
/

--4. partition table
alter index idx_p1_1 on test_part_1 coalesce;
alter index idx_p1_2 on test_part_1 modify partition p1 coalesce;
declare
    i integer;
begin
    for i in 1 .. 2000 loop
        execute immediate 'insert into test_part_1 values(1, 1, 10000 + ' || i || ')';
        execute immediate 'commit';
    end loop;
    commit;
end;
/

insert into test_part_1 values (21, 5, 5);
commit;
alter index idx_p1_1 on test_part_1 coalesce;
alter index idx_p1_2 on test_part_1 modify partition p3 coalesce;

alter index idx_p1_2 on test_part_1 modify partition p2 coalesce;
ALTER INDEX idx_p1_3 on test_part_1 MODIFY PARTITION p1 COALESCE;

--dts
create table strg_btree_range_tbl_001(c_id int,
c_d_id int NOT NULL,
c_w_id int,
c_first varchar(32),
c_middle char(2),
c_last varchar(32) NOT NULL,
c_street_1 varchar(20),
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
c_vchar varchar(1000),
c_data clob,
c_text blob) partition by range(c_d_id,c_last) (partition PART_1 values less than (101,'BBBAR101'),partition PART_2 values less than (201,'CCBAR201'),partition PART_3 values less than (301,'DDBAR301'),partition PART_4 values less than (401,'EEBAR401'),partition PART_5 values less than (501,'FFBAR501'),partition PART_6 values less than (601,'GGBAR601'),partition PART_7 values less than (701,'HHBAR701'),partition PART_8 values less than (801,'IIBAR801'),partition PART_9 values less than (maxvalue,maxvalue));

create index strg_btree_range_index_001_1 on strg_btree_range_tbl_001(c_first);
create unique index strg_btree_range_index_001_2 on strg_btree_range_tbl_001(c_id,c_first);
create index strg_btree_range_index_001_3 on strg_btree_range_tbl_001(c_d_id,c_last,c_first) local;
create unique index strg_btree_range_index_001_4 on strg_btree_range_tbl_001(c_d_id,c_last) local;
alter table strg_btree_range_tbl_001 drop column c_first;
alter index strg_btree_range_index_001_4 on strg_btree_range_tbl_001 modify partition  PART_9 coalesce;
drop table strg_btree_range_tbl_001;
--5. postprepare
drop index idx_tb1 on tb1;
drop table tb1;
drop table test_part_1;

---- PCR test -----
--1. prepare
drop table if exists tb1;
CREATE TABLE tb1(id int, b int) crmode page;
create index idx_tb1 on tb1(b);
drop table if exists test_part_1;
create table test_part_1(f1 int, f2 real, f3 number)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(40)
) crmode row;
create index idx_p1_1 on test_part_1(f1);
create index idx_p1_2 on test_part_1(f2,f3) local;
create index idx_p1_3 on test_part_1(f1,f3) local
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
    for i in 1 .. 4000 loop
        execute immediate 'insert into tb1 values(1, ' || i || ')';
        execute immediate 'commit';
    end loop;
    commit;
end;
/

insert into tb1 values(1, 10000);
commit;
select PAGES from USER_SEGMENTS where SEGMENT_NAME = 'IDX_TB1';
delete from tb1 where b < 10000;
commit;

--4. partition table
declare
    i integer;
begin
    for i in 1 .. 4000 loop
        execute immediate 'insert into test_part_1 values(1, 1, ' || i || ')';
        execute immediate 'commit';
    end loop;
    commit;
end;
/
commit;
select PAGES from user_segments where SEGMENT_NAME = 'IDX_P1_2' and PARTITION_NAME = 'P1';
delete from test_part_1 where f1=1;
commit;

--commit a transaction to force increase scn
insert into test_coalesce values(1);
commit;
select sleep(1);
--recycle
alter index idx_tb1 on tb1 coalesce;
alter index idx_p1_1 on test_part_1 coalesce;
alter index idx_p1_2 on test_part_1 modify partition p1 coalesce;
--commit a transaction to force increase scn
insert into test_coalesce values(1);
commit;
select sleep(1);
--3. test for error code
alter index idx_p1_1 on test_part_1 modify partition p1 coalesce;
alter index idx_p1_2 on test_part_1 coalesce;
alter index idx_tb1 on tb1 modify partition p1 coalesce;
ALTER INDEX idx_p1_3 on test_part_1 MODIFY PARTITION p10 COALESCE;
ALTER INDEX idx_p1_4 on test_part_1 MODIFY PARTITION p1 COALESCE;

declare
    i integer;
begin
    for i in 1 .. 2000 loop
        execute immediate 'insert into tb1 values(1, 10000 + ' || i || ')';
        execute immediate 'commit';
    end loop;
    commit;
end;
/

--4. partition table
alter index idx_p1_1 on test_part_1 coalesce;
alter index idx_p1_2 on test_part_1 modify partition p1 coalesce;
declare
    i integer;
begin
    for ggi in 1 .. 2000 loop
        execute immediate 'insert into test_part_1 values(1, 1, 10000 + ' || i || ')';
        execute immediate 'commit';
    end loop;
    commit;
end;
/

insert into test_part_1 values (21, 5, 5);
commit;
alter index idx_p1_1 on test_part_1 coalesce;
alter index idx_p1_2 on test_part_1 modify partition p3 coalesce;
alter index idx_p1_2 on test_part_1 modify partition p2 coalesce;
ALTER INDEX idx_p1_3 on test_part_1 MODIFY PARTITION p1 COALESCE;

--5. postprepare
drop index idx_tb1 on tb1;
drop table tb1;
drop table test_part_1;
drop table test_coalesce purge;

