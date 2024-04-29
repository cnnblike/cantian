--重名检测，分区名不能重复（父分区与父分区，子分区与子分区，父分区与子分区）
drop table if exists test_subpart;
create table test_subpart(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
),
partition p1 values less than(100)
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
)
);

drop table if exists test_subpart;
create table test_subpart(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
),
partition p2 values less than(100)
(
subpartition p11 values less than(50),
subpartition p22 values less than(100)
)
);

drop table if exists test_subpart;
create table test_subpart(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
),
partition p2 values less than(100)
(
subpartition p1 values less than(50),
subpartition p22 values less than(100)
)
);

--父分区键与子分区键重复
drop table if exists test_subpart; 
create table test_subpart(id int, c_id int) partition by range(id) subpartition by range(id)
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

--检测九种组合分区类型
drop table if exists test_subpart;
create table test_subpart(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
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

drop table if exists test_subpart;
create table test_subpart(id int, name varchar(20)) partition by range(id) subpartition by list(name)
(
partition p1 values less than(50)
(
subpartition p11 values('zhangsan'),
subpartition p12 values('lisi')
),
partition p2 values less than(100)
(
subpartition p21 values('wangwu')
)
);

drop table if exists test_subpart;
create table test_subpart(id int, name varchar(20)) partition by range(id) subpartition by hash(name)
(
partition p1 values less than(50)
(
subpartition p11,
subpartition p12
),
partition p2 values less than(100)
(
subpartition p21,
subpartition p22
)
);

drop table if exists test_subpart;
create table test_subpart(id int, name varchar(20)) partition by list(name) subpartition by range(id)
(
partition p1 values('zhangsan')
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
),
partition p2 values('lisi')
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
)
);

drop table if exists test_subpart;
create table test_subpart(id int, name varchar(20)) partition by list(id) subpartition by list(name)
(
partition p1 values(1, 2, 3)
(
subpartition p11 values('zhangsan'),
subpartition p12 values('lisi')
),
partition p2 values(4, 5, 6)
(
subpartition p21 values('wangwu'),
subpartition p22 values('zhaoliu')
)
);

drop table if exists test_subpart;
create table test_subpart(id int, name varchar(20)) partition by list(id) subpartition by hash(name)
(
partition p1 values(1, 2, 3)
(
subpartition p11,
subpartition p12
),
partition p2 values(4, 5, 6)
(
subpartition p21,
subpartition p22
)
);

drop table if exists test_subpart;
create table test_subpart(id int, name varchar(20)) partition by hash(name) subpartition by range(id)
(
partition p1
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
),
partition p2
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
)
);

drop table if exists test_subpart;
create table test_subpart(id int, name varchar(20)) partition by hash(name) subpartition by list(id)
(
partition p1
(
subpartition p11 values(1, 2, 3),
subpartition p12 values(4, 5, 6)
),
partition p2
(
subpartition p21 values(1, 2, 3),
subpartition p22 values(4, 5, 6)
)
);

drop table if exists test_subpart;
create table test_subpart(id int, name varchar(20)) partition by hash(name) subpartition by hash(id)
(
partition p1
(
subpartition p11,
subpartition p12
),
partition p2
(
subpartition p21,
subpartition p22
)
);

--interval检测,只有父分区支持interval
drop table if exists test_subpart;
create table test_subpart(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id) interval(50)
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

drop table if exists test_subpart;
create table test_subpart(id int, c_id int, name varchar(20)) partition by range(id) interval(50) subpartition by range(c_id) interval(50)
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

drop table if exists test_subpart;
create table test_subpart(id int, c_id int, name varchar(20)) partition by range(id) interval(50) subpartition by range(c_id)
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

--检测as select方式创建表
drop table if exists data_source;
create table data_source(id int, c_id int, name varchar(20));
insert into data_source values(10, 10, 'zhangsan');
insert into data_source values(10, 60, 'lisi');
insert into data_source values(60, 10, 'wangwu');
insert into data_source values(60, 60, 'zhaoliu');
commit;

drop table if exists test_subpart;
create table test_subpart partition by range(id) subpartition by range(c_id)
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
) as select * from data_source;

create table test_subpart partition by range(id) subpartition by range(c_id)
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
) as select id, c_id from data_source;
drop table if exists data_source;

--hash分区创建方式检测(store in),对于组合分区，只能是子分区以store in方式
drop table if exists test_subpart;
create table test_subpart(id int, c_id int, name varchar(20)) partition by hash(id) partitions 4 subpartition by hash(name) subpartitions 4;
create table test_subpart(id int, c_id int, name varchar(20)) partition by hash(id) subpartition by hash(name) partitions 4 subpartitions 4;
create table test_subpart(id int, c_id int, name varchar(20)) partition by hash(id) subpartition by hash(name) partitions 4 
(
subpartition p11,
subpartition p12
);

drop table if exists test_subpart;
create table test_subpart(id int, c_id int, name varchar(20)) partition by hash(id) subpartition by hash(name) subpartitions 4
(
partition p1,
partition p2
);

drop table if exists test_subpart;
create table test_subpart(id int, c_id int, name varchar(20)) partition by range(id) subpartition by hash(name) subpartitions 4
(
partition p1 values less than(50),
partition p2 values less than(100)
);

drop table if exists test_subpart;
create table test_subpart(id int, c_id int, name varchar(20)) partition by range(id) interval(50) subpartition by hash(name) subpartitions 4
(
partition p1 values less than(50),
partition p2 values less than(100)
);

drop table if exists test_subpart;
create table test_subpart(id int, c_id int, name varchar(20)) partition by list(id) subpartition by hash(name) subpartitions 4
(
partition p1 values(1),
partition p2 values(2)
);

--测试分区tablespace属性，父分区没有指定，则继承自表；子分区没有指定，继承自父分区
create tablespace test_space_1 datafile 'test_datafile_1' size 8M;
create tablespace test_space_2 datafile 'test_datafile_2' size 8M;
create tablespace test_space_3 datafile 'test_datafile_3' size 8M;
drop table if exists test_subpart;
create table test_subpart(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50) tablespace test_space_2
(
subpartition p11 values less than(50) tablespace test_space_3,
subpartition p12 values less than(100) tablespace test_space_3
),
partition p2 values less than(100) tablespace test_space_2
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
),
partition p3 values less than(150)
(
subpartition p31 values less than(50),
subpartition p32 values less than(100)
)
)tablespace test_space_1;

insert into test_subpart values(10, 10, 'zhangsan');
insert into test_subpart values(10, 60, 'lisi');
insert into test_subpart values(60, 10, 'wangwu');
insert into test_subpart values(60, 60, 'zhaoliu');
commit;

--子分区只支持tablespace，pctfree、initrans、storage不支持
drop table if exists test_subpart;
create table test_subpart(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50) tablespace test_space_1 pctfree 8 initrans 2 storage( initial 2M maxsize 10M )
(
subpartition p11 values less than(50) tablespace test_space_2,
subpartition p12 values less than(100) tablespace test_space_3
),
partition p2 values less than(100) tablespace test_space_1 pctfree 8 initrans 2 storage( initial 2M maxsize 10M )
(
subpartition p21 values less than(50) tablespace test_space_2,
subpartition p22 values less than(100) tablespace test_space_3
)
);

drop table if exists test_subpart;
drop tablespace test_space_1 including contents and datafiles;
drop tablespace test_space_2 including contents and datafiles;
drop tablespace test_space_3 including contents and datafiles;

drop table if exists test_interval;
create table test_interval(id int) PARTITION BY RANGE(ID) INTERVAL(50) SUBPARTITION BY RANGE(id)
(
PARTITION P1 VALUES LESS THAN(50)
(
SUBPARTITION p2 VALUES LESS THAN (2),
SUBPARTITION p3 VALUES LESS THAN (4),
SUBPARTITION P4 VALUES LESS THAN(MAXVALUE)
)
);
drop table test_interval;

drop table if exists test_add_subpart;
create table test_add_subpart(id int) PARTITION BY RANGE(ID) INTERVAL(50) SUBPARTITION BY RANGE(id)
(
PARTITION P1 VALUES LESS THAN(50)
(
SUBPARTITION p11 VALUES LESS THAN (2),
SUBPARTITION p12 VALUES LESS THAN (4),
SUBPARTITION P13 VALUES LESS THAN (6)
)
);

alter table test_add_subpart modify partition p1 add subpartition p1 values less than(8);
drop table test_add_subpart;

drop table if exists t_range_subparts_range_009;
create table t_range_subparts_range_009(id int, c_int int[], c_real real, c_float float, c_decimal decimal, c_number number, c_char char(100), c_vchar varchar(100) not null, c_vchar2 varchar2(100), c_clob clob, c_long varchar(200), c_blob blob, c_raw raw(100), c_date date, c_timestamp timestamp) partition by range(c_float) subpartition by range(c_date)
(
partition p1 values less than(2185.456)
(
subpartition p11 values less than ('2020-02-01'),
subpartition p12 values less than ('2020-03-01'),
subpartition p13 values less than (maxvalue)
),
partition p2 values less than(4369.456)
(
subpartition p21 values less than ('2020-05-01'),
subpartition p22 values less than ('2020-06-01'),
subpartition p23 values less than ('2020-07-01')
),
partition p3 values less than(6577.456)
(
subpartition p31 values less than ('2020-08-01'),
subpartition p32 values less than ('2020-09-01'),
subpartition p33 values less than (maxvalue)
),
partition p4 values less than(8785.456)
(
subpartition p41 values less than ('2020-11-01'),
subpartition p42 values less than ('2020-12-01'),
subpartition p43 values less than ('2021-01-01')
),
partition p5 values less than(maxvalue)
(
subpartition p51 values less than ('2021-02-01'),
subpartition p55 values less than (maxvalue)
)
);
drop table if exists t_range_subparts_range_009;

drop table if exists test_subpart;
create table test_subpart(id int, c_id int, c_d_id int, c_w_id int) partition by range(id, c_id) subpartition by range(c_d_id, c_w_id)
(
partition p1 values less than(50, 60)
(
subpartition p11 values less than(50, 60),
subpartition p12 values less than(100, 110)
),
partition p2 values less than(100, 110)
(
subpartition p21 values less than(50, 60),
subpartition p22 values less than(100, 110)
)
);

insert into test_subpart values(10, 11, 12, 13);
insert into test_subpart values(21, 22, 23, 24);
insert into test_subpart values(31, 32, 61, 62);
insert into test_subpart values(41, 42, 71, 72);
insert into test_subpart values(50, 51, 11, 12);
insert into test_subpart values(50, 51, 73, 74);
insert into test_subpart values(53, 54, 50, 51);
insert into test_subpart values(55, 56, 71, 72);
insert into test_subpart values(57, 58, 100, 102);
insert into test_subpart values(61, 62, 21, 22);
insert into test_subpart values(71, 72, 50, 51);
insert into test_subpart values(81, 82, 83, 84);
insert into test_subpart values(91, 92, 100, 103);
commit;

-- 查询指定子分区
select * from test_subpart subpartition(p11);
select * from test_subpart partition(p2);

-- 相同父分区之间子分区切换
select * from test_subpart where id < 50;
select max(id) from test_subpart where id < 50;

-- 不同父分区之间子分区切换
select * from test_subpart where id > 30 and id < 81;
select max(id) from test_subpart where id > 30 and id < 81;

-- 带多个分区键的扫描
select * from test_subpart where id >= 50 and id <= 61 and c_id >= 50 and c_id <= 58;
select max(id) from test_subpart where id >= 50 and id <= 61 and c_id >= 50 and c_id <= 58;
select * from test_subpart where id >= 30 and id <= 80 and c_id >= 30 and c_id <= 70 and c_d_id >= 20 and c_d_id <= 80 and c_w_id >= 30 and c_w_id <= 120;
select max(c_d_id) from test_subpart where id >= 30 and id <= 80 and c_id >= 30 and c_id <= 70 and c_d_id >= 20 and c_d_id <= 80 and c_w_id >= 30 and c_w_id <= 120;
drop table test_subpart;

--带interval空分区的分区切换
drop table if exists test_subpart;
create table test_subpart(id int, c_id int) partition by range(id) interval(5) subpartition by range(c_id)
(
partition p1 values less than(10)
(
subpartition p11 values less than(10),
subpartition p12 values less than(maxvalue)
),
partition p2 values less than(20)
(
subpartition p21 values less than(20),
subpartition p22 values less than(maxvalue)
)
);

insert into test_subpart values(10, 11);
insert into test_subpart values(21, 22);
insert into test_subpart values(31, 32);
insert into test_subpart values(41, 42);
insert into test_subpart values(50, 51);
insert into test_subpart values(50, 51);
insert into test_subpart values(53, 54);
insert into test_subpart values(55, 56);
insert into test_subpart values(57, 58);
insert into test_subpart values(61, 62);
insert into test_subpart values(71, 72);
insert into test_subpart values(81, 82);
insert into test_subpart values(91, 92);
insert into test_subpart values(20971500, 20971500);
commit;

select * from test_subpart where id > 50;
select * from test_subpart where c_id > 50;
select max(id) from test_subpart;
select max(c_id) from test_subpart;
drop table if exists test_subpart;

drop table if exists test_scan_empty_interval;
CREATE TABLE test_scan_empty_interval(ID INT, NAME VARCHAR(20)) PARTITION BY RANGE(ID) INTERVAL(50) SUBPARTITION BY list(NAME) (
PARTITION P1 VALUES LESS THAN(50)
(
SUBPARTITION P11 values('OSS3:NE=my')
),
PARTITION P2 VALUES LESS THAN(100)
(
SUBPARTITION P21 values('OSS3:NE=index')
),
PARTITION P3 VALUES LESS THAN(150)
(
SUBPARTITION P31 values('OSS3:NE=liker')
)
);

create index index_04 on test_scan_empty_interval(id) parallel 2;

declare
v_id int;
begin
for i in 10001..20000 loop
v_id :=i;
insert into test_scan_empty_interval values (v_id,'OSS3:NE=index');
end loop;
commit;
end;
/

declare
v_id int;
begin
for i in 20001..30000 loop
v_id :=i;
insert into test_scan_empty_interval values (v_id,'OSS3:NE=liker');
end loop;
commit;
end;
/

select count(1) from (select * from test_scan_empty_interval where id>500 or id <200 and name like '%liker');
select MAX(id) from test_scan_empty_interval where id>500 or id <200 and name like '%liker';
delete from test_scan_empty_interval where id>= 10000;
drop table if exists test_scan_empty_interval;

drop table if exists test_interval_subpart;
create table test_interval_subpart(id int, c_id int) partition by range(id) interval(10) subpartition by range(c_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
)
);
insert into test_interval_subpart values(10, 10);
insert into test_interval_subpart values(260, 260);
commit;
update test_interval_subpart set id = id + 100;
drop table if exists test_interval_subpart;

drop table if exists SUBPART_R_R_UPDATEALL_TBL_037;
create table SUBPART_R_R_UPDATEALL_TBL_037(num int,c_id int,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_uint UINT not null,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_zero timestamp NOT NULL,c_start date NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2),c_credit_lim numeric,c_discount numeric(5,2),c_balance number(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(7744),c_data2 varchar(7744),c_data3 varchar(7744),c_data4 varchar(7744),c_data5 varchar(7744),c_data6 varchar(7744),c_data7 varchar(7744),c_data8 varchar(7744),c_clob clob,c_blob blob) PARTITION BY RANGE(c_zero) SUBPARTITION BY RANGE(C_W_ID) (PARTITION P1 VALUES LESS THAN('2018-06-10 10:51:47.000000') (SUBPARTITION P11 VALUES LESS THAN(3) ,SUBPARTITION P12 VALUES LESS THAN(5) ,SUBPARTITION P13 VALUES LESS THAN(7) ,SUBPARTITION P14 VALUES LESS THAN(9) ,SUBPARTITION P15 VALUES LESS THAN(11) ),PARTITION P2 VALUES LESS THAN('2018-11-17 10:51:47.000000') (SUBPARTITION P21 VALUES LESS THAN(3) ,SUBPARTITION P22 VALUES LESS THAN(5) ,SUBPARTITION P23 VALUES LESS THAN(7) ,SUBPARTITION P24 VALUES LESS THAN(9) ,SUBPARTITION P25 VALUES LESS THAN(11) ),PARTITION P3 VALUES LESS THAN('2019-04-26 10:51:47.000000') (SUBPARTITION P31 VALUES LESS THAN(3) ,SUBPARTITION P32 VALUES LESS THAN(5) ,SUBPARTITION P33 VALUES LESS THAN(7) ,SUBPARTITION P34 VALUES LESS THAN(9) ,SUBPARTITION P35 VALUES LESS THAN(11) ),PARTITION P4 VALUES LESS THAN('2019-10-03 10:51:47.000000') (SUBPARTITION P41 VALUES LESS THAN(3) ,SUBPARTITION P42 VALUES LESS THAN(5) ,SUBPARTITION P43 VALUES LESS THAN(7) ,SUBPARTITION P44 VALUES LESS THAN(9) ,SUBPARTITION P45 VALUES LESS THAN(11) ),PARTITION P5 VALUES LESS THAN('2020-03-11 10:51:47.000000') (SUBPARTITION P51 VALUES LESS THAN(3) ,SUBPARTITION P52 VALUES LESS THAN(5) ,SUBPARTITION P53 VALUES LESS THAN(7) ,SUBPARTITION P54 VALUES LESS THAN(9) ,SUBPARTITION P55 VALUES LESS THAN(11) ));
drop sequence if exists subpartition_seq_000;
drop sequence if exists subpartition_seq_000_1;
create sequence subpartition_seq_000 start with 1 MAXVALUE 10 increment by 1 CACHE 2 cycle;
create sequence subpartition_seq_000_1 start with 1 MAXVALUE 100 increment by 1 CACHE 2 cycle;
insert into SUBPART_R_R_UPDATEALL_TBL_037(num,C_ID,C_D_ID,C_W_ID,C_UINT,C_FIRST,C_MIDDLE,C_LAST,C_STREET_1,C_STREET_2,C_ZERO,C_START,C_ZIP,C_PHONE,C_SINCE,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,C_PAYMENT_CNT,C_DELIVERY_CNT,C_END,C_DATA1,C_DATA2,C_DATA3,C_DATA4,C_DATA5,C_DATA6,C_DATA7,C_DATA8,C_CLOB,C_BLOB) select 0,0,0,0,0,'iscmRDs','OE','BARBar','RGF','SDG','2017-12-31 10:51:47','2017-12-31 10:51:47','4801','940215','2017-12-31 10:51:47','GC',50000.0,0.4361328,-10.0,10.0,1,true,'2017-12-31 10:51:47',lpad('QVBRfSCC3484942ZCSfjvCF',500,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',500,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',500,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',500,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',500,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',500,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',500,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',500,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',500,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',500,'1435764ABC7890abcdef');

drop table if exists SUBPART_R_R_UPDATEALL_TBL_037_1;
create table SUBPART_R_R_UPDATEALL_TBL_037_1(num int,c_id int primary key,id int);
insert into SUBPART_R_R_UPDATEALL_TBL_037_1 select num,c_id,1 from SUBPART_R_R_UPDATEALL_TBL_037;
commit;
alter table SUBPART_R_R_UPDATEALL_TBL_037 add constraint SUBPART_R_R_UPDATEALL_TBL_037_constraint1 foreign key(c_id) references SUBPART_R_R_UPDATEALL_TBL_037_1(c_id);
delete from SUBPART_R_R_UPDATEALL_TBL_037_1;
drop table if exists SUBPART_R_R_UPDATEALL_TBL_037;
drop table if exists SUBPART_R_R_UPDATEALL_TBL_037_1;
drop sequence if exists subpartition_seq_000;
drop sequence if exists subpartition_seq_000_1;
