drop table if exists test_split_part_table ;
create table test_split_part_table(id int, name varchar(20)) partition by range(id)
(
partition p1 values less than(50)
);
insert into test_split_part_table values(10, 'aaaaaaaaa');
insert into test_split_part_table values(30, 'bbbbbbbbb');
commit;
alter table test_split_part_table split partition p1 at(60) into (partition p_l0, partition p_r0);    --fail
alter table test_split_part_table split partition p1 at(25) into (partition p_l0, partition p_r0);
select * from test_split_part_table partition(p1);	--fail
select * from test_split_part_table partition(p_l0);
select * from test_split_part_table partition(p_r0);
insert into test_split_part_table values(15, 'cccccccccc');
insert into test_split_part_table values(35, 'dddddddddd');
select * from test_split_part_table partition(p_l0) order by id;
select * from test_split_part_table partition(p_r0) order by id;
drop table if exists test_split_part_table ;

drop table if exists test_split_part_table;
create table test_split_part_table(id int, c_id int, name varchar(20)) partition by range(id)
(
partition p1 values less than(50)
);
create unique index index_unique_global on test_split_part_table(id);
insert into test_split_part_table values(10,10,'aaaaaaaaa');
insert into test_split_part_table values(30,30,'bbbbbbbbb');
commit;
alter table test_split_part_table split partition p1 at(25) into (partition p_l0, partition p_r0);
insert into test_split_part_table values(15,15, 'cccccccccc');	--fail
alter index index_unique_global on test_split_part_table rebuild;
insert into test_split_part_table values(15,15, 'cccccccccc');
insert into test_split_part_table values(35, 35,'dddddddddd');
select * from test_split_part_table partition(p_l0) order by id;
select * from test_split_part_table partition(p_20) order by id;
commit;
savepoint aa;
update test_split_part_table set id = id + 25 where id < 25;
insert into test_split_part_table values(15, 15, 'cccccccccc');
insert into test_split_part_table values(35, 35,'dddddddddd');
delete from test_split_part_table where id = 15;
select * from test_split_part_table order by id;
rollback to savepoint aa;
select * from test_split_part_table order by id;
drop table if exists test_split_part_table;

alter tablespace USERS autopurge off;purge recyclebin;
drop table if exists ACID_HASH_DML_TBL_000;
CREATE TABLE ACID_HASH_DML_TBL_000(C_ID INT,
C_D_ID INT NOT NULL,
C_W_ID INT NOT NULL,
C_FIRST VARCHAR(64) NOT NULL,
C_MIDDLE CHAR(2),
C_LAST VARCHAR(64) NOT NULL,
C_STREET_1 VARCHAR(20) NOT NULL,
C_STREET_2 VARCHAR(20),
C_CITY VARCHAR(20) NOT NULL,
C_STATE CHAR(2) NOT NULL,
C_ZIP CHAR(9) NOT NULL,
C_PHONE CHAR(16) NOT NULL,
C_SINCE TIMESTAMP,
C_CREDIT CHAR(2) NOT NULL,
C_CREDIT_LIM NUMERIC(12,2),
C_DISCOUNT NUMERIC(4,4),
C_BALANCE NUMERIC(12,2),
C_YTD_PAYMENT REAL NOT NULL,
C_PAYMENT_CNT NUMBER NOT NULL,
C_DELIVERY_CNT BOOL NOT NULL,
C_END DATE NOT NULL,
C_VCHAR VARCHAR(1000),
C_DATA CLOB,
C_TEXT BLOB,
C_CLOB CLOB,
primary key (c_id,c_d_id,c_w_id));
insert into ACID_HASH_DML_TBL_000 select 0,0,0,'AA'||'is0cmvls','OE','AA'||'BAR0BARBAR','bkili'||'0'||'fcxcle'||'0','pmbwo'||'0'||'vhvpaj'||'0','dyf'||'0'||'rya'||'0','uq',4800||'0',940||'0'||205||'0','2017-12-31 10:51:47','GC',50000.0,0.4361328,-10.0,10.0,1,true,'2017-12-31 10:51:47','QVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSF'||'0','QVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSF1','1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323','QVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSF1CLOB';
commit;
CREATE or replace procedure nebula_dml_interval_func_001(startall int,endall int)  as 
i INT;
BEGIN
  FOR i IN startall..endall LOOP
	insert into ACID_HASH_DML_TBL_000 select c_id+i,c_d_id+i,c_w_id+i,'AA'||'iscmvls',c_middle,'AA'||'BAR'||i||'ddBARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since+i,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end+i,c_vchar,c_data,c_text,c_clob from ACID_HASH_DML_TBL_000 where c_id=0;commit;
  END LOOP;
END;
/
call nebula_dml_interval_func_001(1,2000);
commit;
delete from ACID_HASH_DML_TBL_000 where c_id=0;
commit;
select count(*) from ACID_HASH_DML_TBL_000;


drop table if exists test_split;
create table test_split(C_ID INT,
C_D_ID INT NOT NULL,
C_W_ID INT NOT NULL,
C_FIRST VARCHAR(64) NOT NULL,
C_MIDDLE CHAR(2),
C_LAST VARCHAR(64) NOT NULL,
C_STREET_1 VARCHAR(20) NOT NULL,
C_STREET_2 VARCHAR(20),
C_CITY VARCHAR(20) NOT NULL,
C_STATE CHAR(2) NOT NULL,
C_ZIP CHAR(9) NOT NULL,
C_PHONE CHAR(16) NOT NULL,
C_SINCE TIMESTAMP,
C_CREDIT CHAR(2) NOT NULL,
C_CREDIT_LIM NUMERIC(12,2),
C_DISCOUNT NUMERIC(4,4),
C_BALANCE NUMERIC(12,2),
C_YTD_PAYMENT REAL NOT NULL,
C_PAYMENT_CNT NUMBER NOT NULL,
C_DELIVERY_CNT BOOL NOT NULL,
C_END DATE NOT NULL,
C_VCHAR VARCHAR(1000),
C_DATA CLOB,
C_TEXT BLOB,
C_CLOB CLOB,
primary key (c_id,c_d_id,c_w_id)) partition by range(c_id) (partition p1 values less than(10), partition p2 values less than(20),partition p3 values less than(3000));

insert into test_split select * from ACID_HASH_DML_TBL_000;
alter table test_split split partition p3 at(1000) into (partition p3_1, partition p3_2);
select count(*) from test_split partition(p3_1);
select count(*) from test_split partition(p3_2);
alter table test_split split partition p3_2 at(1500) into (partition p3_11, partition p3_12);
drop table test_split;

create table test_split_space(c1 int, c2 int) partition by range(c1) (partition p1 values less than(20), partition p2 values less than(50));
insert into test_split_space values(10,10);
insert into test_split_space values(40,40);
commit;
alter table test_split_space split partition p2 at(30) into (partition p2_1 tablespace users, partition p2_2);
select space# from tablepart$ where table# = (select id from table$ where name=upper('test_split_space')) order by space#;
drop table test_split_space;

drop table if exists test_index;
create table test_index(C_ID INT,
C_D_ID INT NOT NULL,
C_W_ID INT NOT NULL,
C_FIRST VARCHAR(64) NOT NULL,
C_MIDDLE CHAR(2),
C_LAST VARCHAR(64) NOT NULL,
C_STREET_1 VARCHAR(20) NOT NULL,
C_STREET_2 VARCHAR(20),
C_CITY VARCHAR(20) NOT NULL,
C_STATE CHAR(2) NOT NULL,
C_ZIP CHAR(9) NOT NULL,
C_PHONE CHAR(16) NOT NULL,
C_SINCE TIMESTAMP,
C_CREDIT CHAR(2) NOT NULL,
C_CREDIT_LIM NUMERIC(12,2),
C_DISCOUNT NUMERIC(4,4),
C_BALANCE NUMERIC(12,2),
C_YTD_PAYMENT REAL NOT NULL,
C_PAYMENT_CNT NUMBER NOT NULL,
C_DELIVERY_CNT BOOL NOT NULL,
C_END DATE NOT NULL,
C_VCHAR VARCHAR(1000),
C_DATA CLOB,
C_TEXT BLOB,
C_CLOB CLOB,
primary key (c_id,c_d_id,c_w_id)) partition by range(c_id) (partition p1 values less than(10), partition p2 values less than(1000),partition p3 values less than(3000));

CREATE UNIQUE INDEX ACID_XA_DATE_INVAL_DML_IDX_002_1 ON test_index(C_END) LOCAL;
CREATE UNIQUE INDEX ACID_XA_DATE_INVAL_DML_IDX_002_2 ON test_index(C_ID,C_FIRST,C_SINCE,C_END) LOCAL;
CREATE INDEX ACID_XA_DATE_INVAL_DML_IDX_002_0 ON test_index(C_VCHAR,C_FIRST,C_LAST);

insert into test_index select * from ACID_HASH_DML_TBL_000;


alter table test_index split partition p2 at(500) into (partition p2_1 tablespace users, partition p2_2);
select c_id from test_index partition(p2_1);
select c_id from test_index partition(p2_2);
select c_id from test_index partition(p2);
alter table test_index split partition p2_2 at(700) into (partition p2_21 tablespace users, partition p2_22);
alter table test_index split partition p2_22 at(900) into (partition p2_221 tablespace users, partition p2_222);
drop table test_index;

drop table if exists test_index;
create table test_index(C_ID INT,
C_D_ID INT NOT NULL,
C_W_ID INT NOT NULL,
C_FIRST VARCHAR(64) NOT NULL,
C_MIDDLE CHAR(2),
C_LAST VARCHAR(64) NOT NULL,
C_STREET_1 VARCHAR(20) NOT NULL,
C_STREET_2 VARCHAR(20),
C_CITY VARCHAR(20) NOT NULL,
C_STATE CHAR(2) NOT NULL,
C_ZIP CHAR(9) NOT NULL,
C_PHONE CHAR(16) NOT NULL,
C_SINCE TIMESTAMP,
C_CREDIT CHAR(2) NOT NULL,
C_CREDIT_LIM NUMERIC(12,2),
C_DISCOUNT NUMERIC(4,4),
C_BALANCE NUMERIC(12,2),
C_YTD_PAYMENT REAL NOT NULL,
C_PAYMENT_CNT NUMBER NOT NULL,
C_DELIVERY_CNT BOOL NOT NULL,
C_END DATE NOT NULL,
C_VCHAR VARCHAR(1000),
C_DATA CLOB,
C_TEXT BLOB,
C_CLOB CLOB,
primary key (c_id,c_d_id,c_w_id)) partition by range(c_id) (partition p1 values less than(10), partition p2 values less than(1000),partition p3 values less than(3000));

CREATE UNIQUE INDEX ACID_XA_DATE_INVAL_DML_IDX_002_1 ON test_index(C_END) LOCAL;
CREATE UNIQUE INDEX ACID_XA_DATE_INVAL_DML_IDX_002_2 ON test_index(C_ID,C_FIRST,C_SINCE,C_END) LOCAL;
CREATE INDEX ACID_XA_DATE_INVAL_DML_IDX_002_0 ON test_index(C_VCHAR,C_FIRST,C_LAST);

insert into test_index select * from ACID_HASH_DML_TBL_000;

alter table test_index split partition p2 at(500) into (partition p2_1 tablespace users, partition p2_2) update global indexes;
alter table test_index split partition p2_2 at(700) into (partition p2_21 tablespace users, partition p2_22);
alter table test_index split partition p2_22 at(800) into (partition p2_221 tablespace users, partition p2_222);
alter table test_index split partition p2_222 at(900) into (partition p2_2221 tablespace users, partition p2_2222);
alter table test_index split partition p2_2222 at(920) into (partition p2_22221 tablespace users, partition p2_22222);
drop table test_index;

create table test_hash_split(c1 int, c2 int) partition by hash(c1) (partition p1, partition p2);
alter table test_hash_split split partition p1 at(100) into (partition p1_1, partition p1_2);
drop table test_hash_split;

create table test_interval_split(c1 int, c2 int) partition by range(c1) interval (2) (partition p1 values less than(100));
alter table test_interval_split split partition p1 at(50) into (partition p11, partition p21);
drop table test_interval_split;

drop table if exists test_split;
create table test_split(C_ID INT, C_D_ID INT NOT NULL, C_W_ID INT NOT NULL, C_FIRST VARCHAR(64) NOT NULL, C_MIDDLE CHAR(2), C_LAST VARCHAR(64) NOT NULL, C_STREET_1 VARCHAR(20) NOT NULL, C_STREET_2 VARCHAR(20), C_CITY VARCHAR(20) NOT NULL, C_STATE CHAR(2) NOT NULL, C_ZIP CHAR(9) NOT NULL, C_PHONE CHAR(16) NOT NULL, C_SINCE TIMESTAMP, C_CREDIT CHAR(2) NOT NULL,C_CREDIT_LIM NUMERIC(12,2), C_DISCOUNT NUMERIC(4,4), C_BALANCE NUMERIC(12,2), C_YTD_PAYMENT REAL NOT NULL, C_PAYMENT_CNT NUMBER NOT NULL, C_DELIVERY_CNT BOOL NOT NULL, C_END DATE NOT NULL, C_VCHAR VARCHAR(1000), C_DATA CLOB, C_TEXT BLOB, C_CLOB CLOB, primary key (c_id,c_d_id,c_w_id)) partition by range(c_id) (partition p1 values less than(10), partition p2 values less than(1000),partition p3 values less than(3000));
create index test_index_split on test_split(c_id) local;
alter table test_split split partition p2 at(500) into (partition p2_1 tablespace users, partition p2_2);
alter table test_split split partition p2_2 at(700) into (partition p2_21 tablespace users, partition p2_22);
alter table test_split split partition p2_22 at(800) into (partition p2_221 tablespace users, partition p2_222);
alter table test_split split partition p2_222 at(900) into (partition p2_2221 tablespace users, partition p2_2222);
alter table test_split split partition p2_2222 at(920) into (partition p2_22221 tablespace users, partition p2_22222);
alter table test_split split partition p2_22222 at(930) into (partition p2_222221 tablespace users, partition p2_222222);
alter table test_split split partition p2_222222 at(940) into (partition p2_2222221 tablespace users, partition p2_2222222);
alter table test_split split partition p2_2222222 at(950) into (partition p2_22222221 tablespace users, partition p2_22222222);
alter table test_split split partition p2_22222222 at(960) into (partition p2_222222221 tablespace users, partition p2_222222222);
alter table test_split split partition p2_222222222 at(970) into (partition p2_2222222221 tablespace users, partition p2_2222222222);
drop table test_split;

drop table ACID_HASH_DML_TBL_000;

drop table if exists test_space;
create table test_space(c1 int, c2 int) tablespace swap_00 partition by range(c1) (partition p1 values less than(10) tablespace users, partition p2 values less than(1000),partition p3 values less than(3000));
alter table test_space add partition p4 values less than(4000) tablespace users;
drop table test_space;

drop table if exists test_space;
create table test_space(c1 int, c2 int) tablespace swap_00 partition by range(c1) (partition p1 values less than(10), partition p2 values less than(1000),partition p3 values less than(3000));
alter table test_space add partition p4 values less than(4000) tablespace users;
drop table test_space;

drop table if exists test_space;
create table test_space(c1 int, c2 int) tablespace users partition by range(c1) (partition p1 values less than(10), partition p2 values less than(1000),partition p3 values less than(3000));
alter table test_space add partition p4 values less than(4000) tablespace users;
drop table test_space;

drop table if exists test_space1;
create table test_space1(c1 int, c2 int)tablespace users partition by range(c1) (partition p1 values less than(10), partition p2 values less than(1000),partition p3 values less than(3000));
alter table test_space1 add partition p4 values less than(4000) tablespace swap_00;
drop table test_space1;

drop table if exists test_space2;
create table test_space2(c1 int, c2 int)tablespace users partition by range(c1) (partition p1 values less than(10), partition p2 values less than(1000),partition p3 values less than(3000));
alter table test_space2 split partition p2 AT(100) INTO (partition p2_1 tablespace swap_00,partition p2_2);
drop table test_space2;

drop table if exists test_space3;
create table test_space3(c1 int, c2 int)tablespace swap_00 partition by range(c1) (partition p1 values less than(10), partition p2 values less than(1000),partition p3 values less than(3000));
alter table test_space3 split partition p2 AT(100) INTO (partition p2_1 tablespace users,partition p2_2);
drop table test_space3;

drop table if exists test_space4;
create table test_space4(c1 int, c2 int)tablespace users partition by range(c1) (partition p1 values less than(10), partition p2 values less than(1000),partition p3 values less than(3000));
alter table test_space4 split partition p2 AT(100) INTO (partition p2_1 tablespace users,partition p2_2);
drop table test_space4;

drop table if exists test_space5;
create table test_space5(c1 int, c2 int)tablespace users partition by range(c1) (partition p1 values less than(10), partition p2 values less than(1000),partition p3 values less than(3000));
alter table test_space5 split partition p2 AT(100) INTO (partition p2_1 tablespace temp2,partition p2_2);
drop table test_space5;

drop table if exists test_duplicate;
create table test_duplicate(c1 int, c2 int) partition by range(c1) 
(partition p1 values less than(100));

alter table test_duplicate split partition p1 at(50) into(partition p2, partition p3);
alter table test_duplicate split partition p2 at(30) into(partition p1, partition p3); 

drop table if exists test_duplicate;
create table test_duplicate(c1 int, c2 int) partition by range(c1) 
(partition p1 values less than(1000));
insert into test_duplicate values(10,10);
insert into test_duplicate values(50,50);
insert into test_duplicate values(150,150);
insert into test_duplicate values(800,800);
insert into test_duplicate values(900,900);
commit;
alter table test_duplicate split partition p1 at(500) into(partition p2, partition p1);
select * from test_duplicate partition(p1) order by c1;
select * from test_duplicate partition(p2) order by c1;
alter table test_duplicate split partition p2 at(300) into(partition p1, partition p3); 
drop table test_duplicate;

drop table if exists range_partition_split_tablespace_008;
create table range_partition_split_tablespace_008(C_ID INT,
C_D_ID bigint NOT NULL,
C_W_ID tinyint unsigned NOT NULL,
C_FIRST VARCHAR(64) NOT NULL,
C_MIDDLE CHAR(2),
C_LAST VARCHAR(64) NOT NULL,
C_STREET VARCHAR(20) NOT NULL,
C_STREET_2 VARCHAR(20),
C_CITY VARCHAR(20) NOT NULL,
C_STATE CHAR(2) NOT NULL,
C_ZIP CHAR(9) NOT NULL,
C_PHONE CHAR(16) NOT NULL,
C_SINCE TIMESTAMP,
C_CREDIT CHAR(2) NOT NULL,
C_CREDIT_LIM NUMERIC(12,2),
C_DISCOUNT NUMERIC(4,4),
C_BALANCE NUMERIC(12,2),
C_YTD_PAYMENT REAL NOT NULL,
C_PAYMENT_CNT NUMBER NOT NULL,
C_DELIVERY_CNT BOOL NOT NULL,
C_END DATE NOT NULL,
C_VCHAR VARCHAR(1000),
C_VARCHAR1 VARCHAR2(3000),
C_VARCHAR2 VARCHAR2(3000),
C_VARCHAR3 VARCHAR2(3000),
C_VARCHAR4 VARCHAR2(3000),
C_DATA LONG,
C_TEXT BLOB,
C_CLOB CLOB,
C_VARCHAR5 VARCHAR2(100 BYTE) DEFAULT LPAD('AA',30,'BB'),
C_FLOAT FLOAT DEFAULT 0.005,
C_DOUBLE DOUBLE DEFAULT 1.005,
C_DECIMAL DECIMAL DEFAULT 1.005,
C_BINARY BINARY(100) DEFAULT LPAD('101',30,'201'),
C_VARBINARY VARBINARY(100) DEFAULT LPAD('101',30,'201'),
C_BOOLEAN BOOLEAN DEFAULT TRUE,
C_LONG LONG DEFAULT LPAD('AA',100,'BB'),
C_RAW RAW(100) DEFAULT LPAD('101',50,'201'),
C_IMAGE IMAGE DEFAULT LPAD('101',50,'201')) partition by range(c_id)
  ( partition part_1 values less than(300)) tablespace users;

alter table range_partition_split_tablespace_008 split partition part_1
at(150)
into
(partition part_2
tablespace swap_00,
partition part_3
tablespace swap_00
);

alter table range_partition_split_tablespace_008 split partition part_1
at(150)
into
(partition part_2
tablespace temp2_undo,
partition part_3
tablespace temp2_undo
);

alter table range_partition_split_tablespace_008 split partition part_1
at(150)
into
(partition part_2
tablespace undo_00,
partition part_3
tablespace undo_00
);

drop user if exists nebula cascade;
create user nebula identified by Cantian_234;
grant dba to nebula;
drop table if exists nebula.test;
create table nebula.test(c_id number) partition by range(c_id)(partition part_1 values less than(20),partition part_2 values less than(40));
create index index_1 on nebula.test(c_id) local;
alter index nebula.index_1 on nebula.test modify partition part_2 unusable;
select index_name,status from adm_indexes where owner=upper('nebula') and index_name=upper('index_1') order by 1,2;
select index_name,partition_name,status from adm_ind_partitions where index_owner=upper('nebula') and index_name=upper('index_1') order by 1,2;
alter table nebula.test split partition part_2 at(30) into (partition part_21,partition part_22);
select index_name,status from adm_indexes where owner=upper('nebula') and index_name=upper('index_1') order by 1,2;
select index_name,partition_name,status from adm_ind_partitions where index_owner=upper('nebula') and index_name=upper('index_1') order by 1,2;
drop table if exists nebula.test1;
create table nebula.test1(c_id number,c_d_id number) partition by range(c_id) subpartition by range(c_d_id) ( partition part_1 values less than (80) format csf ( subpartition p11 values less than(40),subpartition p12 values less than(80),subpartition p13 values less than(maxvalue) ),partition part_2 values less than (160) format csf ( subpartition p21 values less than(40), subpartition p22 values less than(80),subpartition p23 values less than(maxvalue)));
create index index_2 on nebula.test1(c_id) local;
alter index nebula.index_2 on nebula.test1 modify partition part_2 unusable;
select index_name,partition_name,status from adm_ind_partitions where index_owner=upper('nebula') and index_name=upper('index_2') order by 1,2;
select index_name,partition_name,status from adm_ind_subpartitions where index_owner=upper('nebula') and index_name=upper('index_2') order by 1,2;
alter table nebula.test1 split partition part_2 at(120) into (partition part_21,partition part_22);
select index_name,partition_name,status from adm_ind_partitions where index_owner=upper('nebula') and index_name=upper('index_2') order by 1,2;
select index_name,partition_name,status from adm_ind_subpartitions where index_owner=upper('nebula') and index_name=upper('index_2') and partition_name not like 'SYS_%' order by 1,2;
alter index nebula.index_2 on nebula.test1 rebuild;
alter index nebula.index_2 on nebula.test1 modify partition part_22 unusable;
alter table nebula.test1 split subpartition p23 at(90) into (subpartition p23_1,subpartition p23_2);
select index_name,partition_name,status from adm_ind_partitions where index_owner=upper('nebula') and index_name=upper('index_2') order by 1,2;
select index_name,partition_name,status from adm_ind_subpartitions where index_owner=upper('nebula') and index_name=upper('index_2') and partition_name not like 'SYS_%' order by 1,2;
drop user if exists nebula cascade;
