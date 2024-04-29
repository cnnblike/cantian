drop table if exists nolog_ins1; 
create table nolog_ins1 (id int, name varchar(20));
alter table nolog_ins1 enable nologging;
alter table nolog_ins1 enable nologging ;
alter table nolog_ins1 disable nologging;
alter table nolog_ins1 enable nologging ;
insert into nolog_ins1 values(0, 'it is a long string');
insert into nolog_ins1 values(0, 'it is a long string');
savepoint sp1;
insert into nolog_ins1 values(0, 'it is a long string');
rollback to savepoint sp1;
select count(*) from nolog_ins1;
insert into nolog_ins1 values(0, 'it is a long string');
insert into nolog_ins1 values(0, 'it is a long string');
insert into nolog_ins1 values(0, 'it is a long string');
select count(*) from nolog_ins1;
commit;
insert into nolog_ins1 select * from nolog_ins1;
commit;
truncate table nolog_ins1;
alter table nolog_ins1 disable nologging;

drop table if exists nolog_ins1; 
create table nolog_ins1 (id int, name clob);
alter table nolog_ins1 enable nologging;
insert into nolog_ins1 values(1,lpad('clob',5500,'clob'));
insert into nolog_ins1 values(1,lpad('clob',5500,'clob'));
insert into nolog_ins1 values(1,lpad('clob',5500,'clob'));
insert into nolog_ins1 values(1,lpad('clob',5500,'clob'));
insert into nolog_ins1 values(1,lpad('clob',5500,'clob'));
alter table nolog_ins1 disable nologging;

drop table if exists nolog_subpart1;
create table nolog_subpart1(id int, c_id int, c_d_id int, c_w_id int) partition by range(id) subpartition by range(c_d_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
),
partition p2 values less than(100)
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
)
);

alter table nolog_subpart1 enable partition p1  nologging force ;
alter table nolog_subpart1 enable partition p1  nologging undo;
alter table nolog_subpart1 enable partition p1  nologging ;
alter table nolog_subpart1 enable partition p2  nologging ;
alter table nolog_subpart1 enable subpartition p11  nologging ;
alter table nolog_subpart1 enable subpartition p12  nologging ;
alter table nolog_subpart1 disable partition p1  nologging;
alter table nolog_subpart1 disable partition p2  nologging;
alter table nolog_subpart1 enable subpartition p11  nologging ;
alter table nolog_subpart1 enable subpartition p12  nologging ;

drop table if exists nolog_subpart1;
create table nolog_subpart1(id int, c_id int, c_d_id int, c_w_id int) partition by range(id) subpartition by range(c_d_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
),
partition p2 values less than(100)
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
)
);

alter table nolog_subpart1 enable partition p1  nologging ;
alter table nolog_subpart1 enable partition p2  nologging ;

insert into nolog_subpart1 values(10, 11, 12, 13);
insert into nolog_subpart1 values(21, 22, 23, 24);
insert into nolog_subpart1 values(31, 32, 61, 62);
savepoint sp1;
insert into nolog_subpart1 values(41, 42, 71, 72);
savepoint sp2;
insert into nolog_subpart1 values(51, 51, 11, 12);
rollback to savepoint sp1;
select * from nolog_subpart1 order by id;
commit;

drop table if exists nolog_subpart1;
create table nolog_subpart1(id int, c_id int, c_d_id int, c_w_id int) partition by range(id) subpartition by range(c_d_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
),
partition p2 values less than(100)
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
)
);

alter table nolog_subpart1 enable partition p1  nologging ;
alter table nolog_subpart1 enable partition p2  nologging ;

insert into nolog_subpart1 values(10, 11, 12, 13);
insert into nolog_subpart1 values(21, 22, 23, 24);
insert into nolog_subpart1 values(31, 32, 61, 62);
savepoint sp1;
insert into nolog_subpart1 values(51, 51, 11, 12);
savepoint sp2;
insert into nolog_subpart1 values(41, 42, 71, 72);
rollback to savepoint sp1;
rollback to savepoint sp2;
select * from nolog_subpart1 order by id;
commit;
savepoint sp1;
insert into nolog_subpart1 values(31, 32, 61, 62);
rollback to savepoint sp1;
select * from nolog_subpart1 order by id;
commit;
insert into nolog_subpart1 values(50, 51, 73, 74);
insert into nolog_subpart1 values(53, 54, 50, 51);
insert into nolog_subpart1 values(55, 56, 71, 72);
insert into nolog_subpart1 values(57, 58, 99, 102);
insert into nolog_subpart1 values(61, 62, 21, 22);
insert into nolog_subpart1 values(71, 72, 50, 51);
insert into nolog_subpart1 values(81, 82, 83, 84);
insert into nolog_subpart1 values(91, 92, 99, 103);
rollback;
select * from nolog_subpart1 order by id;

alter table nolog_subpart1 disable partition p2  nologging;
alter table nolog_subpart1 enable partition p2  nologging ;
truncate table nolog_subpart1;
alter table nolog_subpart1 enable partition p2  nologging ;
insert into nolog_subpart1 values(50, 51, 73, 74);
insert into nolog_subpart1 values(53, 54, 50, 51);
insert into nolog_subpart1 values(55, 56, 71, 72);
insert into nolog_subpart1 values(57, 58, 99, 102);
insert into nolog_subpart1 values(61, 62, 21, 22);
insert into nolog_subpart1 values(71, 72, 50, 51);
insert into nolog_subpart1 values(81, 82, 83, 84);
insert into nolog_subpart1 values(91, 92, 99, 103);
rollback;
select * from nolog_subpart1 order by id;

alter system set AUTO_INHERIT_USER = ON;
drop table if exists test_nologging_000;
create table test_nologging_000(c_id int,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state varchar(20) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(8000),c_data2 varchar(8000),c_data3 varchar(8000),c_data4 varchar(8000),c_data5 varchar(8000),c_data6 varchar(8000),c_data7 varchar(6000),c_data8 varchar(4000),c_clob clob,c_blob blob);
CREATE or replace procedure procedure_test_nologging_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from sys_dummy;
    insert into test_nologging_000 select i,i,i,'iscmRDs'||j,'OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,1,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',4000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',1000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',5000,'1435764ABC7890abcdef') from sys_dummy;
  END LOOP;
END;
/
call procedure_test_nologging_000(1,1000);
commit;
alter tablespace undo_00 autoextend on next 1G;
drop table if exists test_nologging;
create table test_nologging(c_id int,c_d_id bigint,c_w_id tinyint unsigned,c_first varchar(16),c_middle char(2),c_last varchar(16),c_street_1 varchar(20),c_street_2 varchar(20),c_city varchar(20),c_state varchar(20),c_zip char(9),c_phone char(16),c_since timestamp,c_credit char(2),c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real,c_payment_cnt NUMBER2,c_delivery_cnt bool,c_end date,c_data1 varchar(7744),c_data2 varchar(7744),c_data3 varchar(7744),c_data4 varchar(7744),c_data5 varchar(7744),c_data6 varchar(7744),c_data7 varchar(7744),c_data8 varchar(7744),c_clob clob,c_blob blob) partition by range(c_id) interval(10) (partition PART_1 values less than (21),partition PART_2 values less than (41),partition PART_3 values less than (61),partition PART_4 values less than (81)) format csf;
CREATE UNIQUE INDEX test_nologging_indx_1 ON test_nologging(c_id,c_d_id);
CREATE INDEX test_nologging_indx_2 ON test_nologging(c_id) local;

alter table test_nologging enable partition part_2 nologging;
insert into test_nologging select * from test_nologging_000;
delete from test_nologging;
alter table test_nologging shrink space;
insert into test_nologging select * from test_nologging_000;
savepoint aa;
delete from test_nologging where c_id < 500;
select count(*) from test_nologging where c_id > 500;
update test_nologging set c_id = c_id - 500;
select count(*) from test_nologging where c_id > 500;
rollback to savepoint aa;
select count(*) from test_nologging;

alter system set recyclebin = true;
alter table test_nologging truncate partition part_2;
flashback table test_nologging partition part_2 to before truncate;
select count(*) from test_nologging;

truncate table test_nologging;
flashback table test_nologging to before truncate;
select count(*) from test_nologging;
alter system set recyclebin = false;

alter index test_nologging_indx_1 ON test_nologging rebuild;
drop table if exists test_nologging_000;
drop table if exists test_nologging;

drop table if exists idx_coalesce_tab_001;
create table idx_coalesce_tab_001(f1 int not null,f2 bigint,f3 numeric,f4 char(180),f5 date) nologging;
CREATE or replace procedure proc_idx_coalesce_tab_001_1(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
 FOR i IN startnum..endall LOOP
 insert into idx_coalesce_tab_001 values (i,1000,12389.12789,'aaaaaaaaaaaaaaaa',sysdate);
 END LOOP;
END;
/
call proc_idx_coalesce_tab_001_1(1,30000);
create index idx_coalesce_tab_001_idx_001 on idx_coalesce_tab_001(f1,f4) nologging;