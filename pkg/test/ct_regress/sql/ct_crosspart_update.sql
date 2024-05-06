--test update overpart for range part
drop table if exists test_range;
create table test_range(id int, name varchar(200)) partition by range(id)
(
partition p1 values less than(50),
partition p2 values less than(100)
);
create index index_test_range on test_range(id);
insert into test_range values(10, 'wuhan');
insert into test_range values(20, 'xian');
commit;
savepoint aa;
select * from test_range partition(p1);
select * from test_range partition(p2);
update test_range set id = 60 where id = 10;
select * from test_range partition(p1);
select * from test_range partition(p2);
rollback to savepoint aa;
select * from test_range partition(p1);
select * from test_range partition(p2);
drop table test_range;

--test update overpart for range interval part
drop table if exists test_range_interval;
create table test_range_interval(id int, name varchar(200)) partition by range(id)
interval(50)
(
partition p1 values less than(50)
);
create index index_test_range_interval on test_range_interval(id);
insert into test_range_interval values(10, 'wuhan');
commit;
savepoint aa;
select * from test_range_interval partition(p1);
update test_range_interval set id = 60 where id = 10;
select * from test_range_interval partition(p1);
rollback to savepoint aa;
select * from test_range_interval partition(p1);
drop table test_range_interval;

--test update overpart for hash part
drop table if exists test_hash;
create table test_hash(id int, name varchar(200)) partition by hash(id)
(
partition p1,
partition p2,
partition p3
);
create index index_test_hash on test_hash(id);
insert into test_hash values(1, 'wuhan');
insert into test_hash values(10256, 'nanjing');
insert into test_hash values(265875664, 'xian');
commit;
savepoint aa;
select * from test_hash partition(p1);
select * from test_hash partition(p2);
select * from test_hash partition(p3);
update test_hash set id = 2 where id = 10256;
select * from test_hash partition(p1);
select * from test_hash partition(p2);
select * from test_hash partition(p3);
rollback to savepoint aa;
select * from test_hash partition(p1);
select * from test_hash partition(p2);
select * from test_hash partition(p3);
drop table test_hash;

--test update overpart for list part
drop table if exists test_list;
create table test_list(id int, name varchar(200)) partition by list(id)
(
partition p1 values(1,3,5,7,9),
partition p2 values(2,4,6,8,10)
);
create index index_test_list on test_list(id);
insert into test_list values(1, 'wuhan');
insert into test_list values(2, 'xian');
insert into test_list values(3, 'nanjing');
commit;
savepoint aa;
select * from test_list partition(p1);
select * from test_list partition(p2);
update test_list set id = 4 where id = 3;
select * from test_list partition(p1);
select * from test_list partition(p2);
rollback to savepoint aa;
select * from test_list partition(p1);
select * from test_list partition(p2);
drop table test_list;

--test update overpart for lob link row
drop table if exists test_lob_link_row;
create table test_lob_link_row(c_id int, c_d_id int, c_first varchar(8000), c_second varchar(8000), c_third varchar(8000), c_lob clob) partition by range(c_id)
interval(50)
(
partition p1 values less than(50),
partition p2 values less than(100)
);
create index index_combinate on test_lob_link_row(c_id, c_d_id);
insert into test_lob_link_row values(10, 20, 'aaaaaaaaaaaaaa', 'bbbbbbbbbbbbbb', 'ccccccccccccccccc', 'dddddddddddddddd');
insert into test_lob_link_row values(20, 40, 'ffffffffffffff', 'gggggggggggggg', 'hhhhhhhhhhhhhhhhh', 'iiiiiiiiiiiiiiii');
commit;
savepoint aa;
select c_id, count(*) from test_lob_link_row partition(p1) group by c_id order by c_id;
select c_id, count(*) from test_lob_link_row partition(p2) group by c_id order by c_id;
update test_lob_link_row set c_id = 60, c_first = lpad('aaaaaaaa', 8000, 'aaaaaaaa'), c_second = lpad('bbbbbbb', 8000, 'bbbbbbb'), c_third = lpad('cccccc', 8000, 'cccccccc'), c_lob = lpad('dddddddd', 8000, 'ddddddd')where c_id = 10;
select c_id, count(*) from test_lob_link_row partition(p1) group by c_id order by c_id;
select c_id, count(*) from test_lob_link_row partition(p2) group by c_id order by c_id;
rollback to savepoint aa;
select c_id, count(*) from test_lob_link_row partition(p1) group by c_id order by c_id;
select c_id, count(*) from test_lob_link_row partition(p2) group by c_id order by c_id;
drop table test_lob_link_row;

--test update overpart for partition index
drop table if exists test_index_partition;
create table test_partition_index(id int, name varchar(200)) partition by range(id)
interval(50)
(
partition p1 values less than(50)
);
create index idx_part on test_partition_index(id) local
(
partition idx_p1
);
insert into test_partition_index values(10, 'wuhan');
insert into test_partition_index values(20, 'xian');
commit;
savepoint aa;
select * from test_partition_index partition(p1);
update test_partition_index set id = 60 where id = 10;
select * from test_partition_index partition(p1);
rollback to savepoint aa;
select * from test_partition_index partition(p1);
drop table test_partition_index;

--test update overpart for different tablespace
drop table if exists test_diff_tablespace;
create tablespace space1 datafile 'file1' size 32M autoextend on next 10M;
create tablespace space2 datafile 'file2' size 32M autoextend on next 10M;
create table test_diff_tablespace(id int, name varchar(200)) partition by range(id)
(
partition p1 values less than(50) tablespace space1,
partition p2 values less than(100) tablespace space2
);
insert into test_diff_tablespace values(10, 'wuhan');
insert into test_diff_tablespace values(20, 'xian');
commit;
savepoint aa;
select * from test_diff_tablespace partition(p1);
select * from test_diff_tablespace partition(p2);
update test_diff_tablespace set id = 60 where id = 10;

select * from test_diff_tablespace partition(p1);
select * from test_diff_tablespace partition(p2);
rollback to savepoint aa;
select * from test_diff_tablespace partition(p1);
select * from test_diff_tablespace partition(p2);
drop table test_diff_tablespace;

--test lob inline and outline
drop table if exists test_part_lob;
create table test_part_lob(id int, c_first varchar(8000), c_second varchar(8000), c_thrid varchar(8000), c_fouth varchar(8000), c_fifth varchar(8000), c_lob clob, primary key(id)) partition by range(id) interval(50)
(
partition p1 values less than(50),
partition p2 values less than(100)
);
insert into test_part_lob values(10, 'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff');
commit;
select * from test_part_lob partition(p1);
update test_part_lob set id = 60 where id = 10;
select * from test_part_lob partition(p2);
update test_part_lob set id = 10 where id = 60;
select * from test_part_lob partition(p1);
update test_part_lob set id = 60, c_first = lpad('aaaa', 8000, 'aaaa'), c_second = lpad('bbbb', 8000, 'bbbb'), c_thrid = lpad('cccc', 8000, 'cccc'), c_fouth = lpad('dddd', 8000, 'dddd'), c_fifth = lpad('eeee', 8000, 'eeee'), c_lob = lpad('ffff', 8000, 'ffff');
select count(*) from test_part_lob partition(p2);
update test_part_lob set id = 10, c_first = 'aaaa', c_second = 'bbbb', c_thrid = 'cccc', c_fouth = 'dddd', c_fifth = 'eeee', c_lob = 'ffff';
select * from test_part_lob partition(p1);
drop table test_part_lob;

--test merge into
drop table if exists test_merge_table_into;
drop table if exists test_merge_table_using;
create table test_merge_table_into (f_int1 int, f_int2 int, f_int3 int) partition by range(f_int2)(partition p1 values less than(10), partition p2 values less than(30));  
create table test_merge_table_using (f_int1 int, f_int2 int);
create index idx_merge_into on test_merge_table_into(f_int1);
insert into test_merge_table_into values(1,1,1);
insert into test_merge_table_into values(2,1,1);
insert into test_merge_table_into values(3,1,1);
insert into test_merge_table_using values(1,1);
insert into test_merge_table_using values(1,1);
insert into test_merge_table_using values(2,1);
insert into test_merge_table_using values(20,1);
merge into test_merge_table_into using (select * from test_merge_table_using) test_merge_table_using on (test_merge_table_into.f_int1 = test_merge_table_using.f_int1 and test_merge_table_into.f_int2 = test_merge_table_using.f_int2) when not matched then insert (f_int1,f_int2,f_int3) values(21,22,23) when matched then update set f_int2 = 20;
drop index idx_merge_into on test_merge_table_into;
drop table test_merge_table_into;
drop table test_merge_table_using;

--test trigger after
drop table if exists test_trigger_table;
drop table if exists test_data_table;
create table test_trigger_table(id int);
create table test_data_table(id int, name varchar(100)) partition by range(id)
interval(50)
(
partition p1 values less than(50),
partition p2 values less than(100),
partition p3 values less than(150),
partition p4 values less than(200)
);
insert into test_trigger_table values(10);
insert into test_trigger_table values(20);
insert into test_data_table values(10, 'aaaaaaaa');
commit;
create or replace trigger test_update_overpart after insert or update or delete
on test_trigger_table
begin
    update test_data_table set id = id + 50;
end;
/
select * from test_data_table partition(p1);
insert into test_trigger_table values(30);
select * from test_data_table partition(p2);
update test_trigger_table set id = id + 10 where id = 10;
select * from test_data_table partition(p3);
delete from test_trigger_table where id = 20;
select * from test_data_table partition(p4);
drop table test_trigger_table;
drop table test_data_table;

--test trigger before
drop table if exists test_trigger_table;
drop table if exists test_data_table;
create table test_trigger_table(id int);
create table test_data_table(id int, name varchar(100)) partition by range(id)
interval(50)
(
partition p1 values less than(50),
partition p2 values less than(100),
partition p3 values less than(150),
partition p4 values less than(200)
);
insert into test_trigger_table values(10);
insert into test_trigger_table values(20);
insert into test_data_table values(10, 'aaaaaaaa');
commit;
create or replace trigger test_update_overpart before insert or update or delete
on test_trigger_table
begin
    update test_data_table set id = id + 50;
end;
/
select * from test_data_table partition(p1);
insert into test_trigger_table values(30);
select * from test_data_table partition(p2);
update test_trigger_table set id = id + 10 where id = 10;
select * from test_data_table partition(p3);
delete from test_trigger_table where id = 20;
select * from test_data_table partition(p4);
drop table test_trigger_table;
drop table test_data_table;

--test flashback of update overpart
drop table if exists test_update_overpart_flashback;
drop table if exists time_temp;
create table time_temp(id int, times varchar2(200)); 
create table test_update_overpart_flashback(id int, c_d_id int, c_first varchar(8000), c_second varchar(8000), c_lob clob, primary key(c_d_id)) partition by range(id)
interval(50)
(
partition p1 values less than(50),
partition p2 values less than(100)
);
create or replace procedure pro_generate_time(id int)
as
scn_num varchar2(200);
begin
	select sysdate into scn_num from dual;
	insert into time_temp values(id, scn_num);
END;
/
create or replace procedure pro_flashback_table(id int)
as
scn_num varchar2(200);
begin
	select time_temp.times into scn_num from time_temp where time_temp.id = id;
	execute immediate 'flashback table test_update_overpart_flashback to timestamp to_timestamp('''|| scn_num ||''',''yyyy-mm-dd hh24:mi:ss'')';
END;
/
insert into test_update_overpart_flashback values(10, 10, 'aaaaa', 'bbbbb', 'ccccc');
select count(*) from test_update_overpart_flashback partition(p1);
commit;
select sleep(3);
call pro_generate_time(1);
update test_update_overpart_flashback set id = 60, c_d_id = 60, c_first = lpad('aaa', 8000, 'aaa'), c_second = lpad('bbb', 8000, 'bbb'), c_lob = lpad('ccc', 8000, 'ccc');
commit;
select sleep(3);
call pro_generate_time(2);
select sleep(3);
update test_update_overpart_flashback set id = 120, c_d_id = 120, c_first = 'aaa', c_second = 'bbb', c_lob = 'ccc';
commit;
call pro_flashback_table(2);
select count(*) from test_update_overpart_flashback partition(p2);
call pro_flashback_table(1);
select count(*) from test_update_overpart_flashback partition(p1);
call pro_flashback_table(2);
select count(*) from test_update_overpart_flashback partition(p2);
drop table test_update_overpart_flashback;
drop table time_temp;
drop procedure pro_generate_time;
drop procedure pro_flashback_table;

create table storage_update_partition_000(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar2(8000) NOT NULL,c_street_2 varchar2(8000),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_unsig tinyint unsigned,c_big bigint,c_vchar varchar2(8000),c_data long,c_text blob,c_clob clob,c_image image,c_binary binary(1000),c_varbinary varbinary(1000),c_raw raw(1000),primary key(c_id,c_d_id,c_w_id));
insert into storage_update_partition_000 select 1,1,1,'AA'||'is1cmvls','OE','AA'||'BAR1ddBARBAR',lpad('sdasdsadasdwqrefgg',1000,'ABCDefgh'),lpad('qwesaddfgbdfgeffsad',1000,'RNGigedgweskt'),'dyf'||'1'||'rya'||'1','uq',4800||'1',940||'1'||205||'1','2017-01-01','GC',50000.0,0.4361328,-10.0,10.0,1,true,'2017-01-01',1,1,lpad('1234ABCDRFGHopqrstuvwxyz8',1000,'ABfgCDefgh'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbxxbm',200,'yxcfgdsgtcjxrbxxbm'),lpad('124324543256546324554354325',200,'7687389015'),lpad('sbfacwjpbvpgthpyxcpmnutcjdfaxrbxxbm',200,'yxcpmnutcjxrbxxbm'),lpad('123dSHGGefasdy',200,'678ASVDFopqrst9234'),lpad('12345abcdegf',200,'adbede1fghij1kLMHG3FFHUK'),lpad('ede1fghij1kLMHG3',200,'xcp2345abcdepmnu'),lpad('1234567890abcdfe',200,'abc1d2fe123895ab456cdef');

commit;
CREATE or replace procedure storage_update_partition_proc_1(startall int,endall int) as
i INT;
BEGIN
  FOR i IN startall..endall LOOP
     insert into storage_update_partition_000 select c_id+i,c_d_id+i,c_w_id+i,'AA'||'is'||(i+1)||'cmvls',c_middle,'AA'||'BAR'||(i+1)||'ddBARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,'940'||i||'205'||i,c_since+i,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end+i,c_unsig+i,c_big+100000*i,c_vchar,c_data,c_text,c_clob,c_image,lpad('12345abcdegf',200,'adbede1fghij'||i||'kLMHG3FFHUK'),lpad('ede1fghij1kLMHG3',200,'xcp23'||i||'45abcdepmnu'),lpad('1234567890abcdfe',200,'abc1d2fe123'||i||'895ab456cdef') from storage_update_partition_000 where c_id=1;commit;
  END LOOP;
END;
/
call storage_update_partition_proc_1(1,999);
select count(*) from storage_update_partition_000;

drop table if exists storage_update_partition_hash_001;
create table storage_update_partition_hash_001(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar2(8000) NOT NULL,c_street_2 varchar2(8000),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_unsig tinyint unsigned,c_big bigint,c_vchar varchar2(8000),c_data long,c_text blob,c_clob clob,c_image image,c_binary binary(5000),c_varbinary varbinary(5000),c_raw raw(5000))
 partition by hash(c_w_id,c_last,c_end) (partition part_1,partition part_2,partition part_3,partition part_4,partition part_5,partition part_6,partition part_7,partition part_8,partition part_9,partition part_10);

create unique index storage_update_partition_hash_001_1 on storage_update_partition_hash_001(c_w_id,c_last,c_end) local;
create index storage_update_partition_hash_001_10 on storage_update_partition_hash_001(c_id,c_first,c_middle,c_zip);

insert into storage_update_partition_hash_001 select * from storage_update_partition_000;
commit;
update storage_update_partition_hash_001 set c_id=c_id+10000,c_w_id=10,c_last='AABAR10ddBARBAR' where c_w_id>101 and c_w_id<103;
drop table storage_update_partition_hash_001;
drop table storage_update_partition_000;

drop table if exists test_update_overpart_lob;
create table test_update_overpart_lob(id int, c_lob clob) partition by range(id) (partition p1 values less than(50), partition p2 values less than(100));
insert into test_update_overpart_lob values(10, 'aaaaaaaaaa');
commit;
savepoint aa;
update test_update_overpart_lob set id = 60, c_lob = null;
select * from test_update_overpart_lob;
rollback to savepoint aa;
update test_update_overpart_lob set id = 60, c_lob = '';
select * from test_update_overpart_lob;
drop table if exists test_update_overpart_lob;

drop table if exists test_update_overpart_count;
create table test_update_overpart_count(id int, c_id int, name varchar(20), primary key(c_id)) partition by range(id)(partition p1 values less than(50), partition p2 values less than(100));
insert into test_update_overpart_count values(10, 20, 'aaaaaaaa');
insert into test_update_overpart_count values(20, 40, 'bbbbbbbb');
commit;
update test_update_overpart_count set id = 60 where id = 10;
select count(*) from test_update_overpart_count partition(p2);
drop table if exists test_update_overpart_count;

drop table if exists test_update_null;
create table test_update_null(id int, c_lob_1 clob, c_lob_2 clob) partition by list(id)
(
partition p1 values(50),
partition p2 values(default)
);
insert into test_update_null values(50, lpad('aaaaa', 8000, 'aaaa'), lpad('bbb', 8000, 'bbbb'));
select count(*) from test_update_null partition(p1);
update test_update_null set id = 10, c_lob_1 = null, c_lob_2 = lpad('cccc', 8000, 'cccc');
select count(*) from test_update_null partition(p2) where c_lob_2 = lpad('cccc', 8000, 'cccc');
drop table if exists test_update_null;

drop table if exists STORAGE_UPDATE_PARTITION_KEY_TABL_000;
drop table if exists STORAGE_UPDATE_INTERVAL_PARTITION_KEY_TABL_001;
CREATE TABLE STORAGE_UPDATE_PARTITION_KEY_TABL_000(C_ID INT,C_D_ID BIGINT not null,C_W_ID TINYINT UNSIGNED not null,C_FIRST VARCHAR(16) not null,C_MIDDLE CHAR(2),C_LAST VARCHAR(16) not null,C_STREET_1 VARCHAR(20) not null,C_STREET_2 VARCHAR(20),C_CITY VARCHAR(20) not null,C_STATE CHAR(2) not null,C_ZIP CHAR(9) not null,C_PHONE CHAR(16) not null,C_SINCE TIMESTAMP,C_CREDIT CHAR(2) not null,C_CREDIT_LIM NUMERIC(12,2),C_DISCOUNT NUMERIC(4,4),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL not null,C_PAYMENT_CNT NUMBER not null,C_DELIVERY_CNT BOOL not null,C_END DATE not null,C_DATA1 VARCHAR(4000),C_DATA2 VARCHAR(4000),C_DATA3 VARCHAR(4000),C_DATA4 VARCHAR(4000),C_DATA5 VARCHAR(4000),C_DATA6 VARCHAR(4000),C_DATA7 VARCHAR(4000),C_DATA8 VARCHAR(4000),C_CLOB CLOB,C_BLOB BLOB,PRIMARY KEY (C_ID));
create OR REPLACE PROCEDURE STORAGE_UPDATE_PARTITION_KEY_PROC_000_1(STARTNUM INT,ENDALL INT) IS
I int :=1;
J VARCHAR(10);
begin
  for I in STARTNUM..ENDALL loop
    SELECT CAST(I AS VARCHAR(10)) INTO J FROM DUAL;
    INSERT INTO STORAGE_UPDATE_PARTITION_KEY_TABL_000 SELECT I,I,I,'ISCMrdS'||J,'oA','barbAR'||J,'BKILIFCRrgf'||J,'PMBWOVHsdgJ'||J,'DYFRdA'||J,'UQ','4801'||J,'940215'||J,TO_DATE('2019-04-01','YYYY-MM-DD')+I,'gc',10000.0,0.4361328,-10.0,10.0,1,TRUE,SYSDATE,LPAD('qvbrFscc3484942zcsFJVcf',200,'qvldburHLHFRC484zcsFJf'),LPAD('qvbuFLChoqnVMGFVDpfzsf',200,'qvldFSChoqGFVMpfzdsf'),LPAD('qvbuFLChoqnVMGFVDpfzsf',200,'qvldFSChoqGFVMpfzdsf'),LPAD('qvbuFLChoqnVMGFVDpfzsf',200,'qvldFSChoqGFVMpfzdsf'),LPAD('qvbuFLChoqnVMGFVDpfzsf',200,'qvldFSChoqGFVMpfzdsf'),LPAD('qvbuFLChoqnVMGFVDpfzsf',200,'qvldFSChoqGFVMpfzdsf'),LPAD('qvbuFLChoqnVMGFVDpfzsf',200,'qvldFSChoqGFVMpfzdsf'),LPAD('qvbuFLChoqnVMGFVDpfzsf',200,'qvldFSChoqGFVMpfzdsf'),LPAD('qvbuFLChoqnVMGFVDpfzsf',200,'qvldFSChoqGFVMpfzdsf'),LPAD('12314315487569809',400,'1435764abc7890ABCDEF') FROM DUAL;
  end loop;
end;
/
CALL STORAGE_UPDATE_PARTITION_KEY_PROC_000_1(0,1999);
COMMIT;
CREATE TABLE STORAGE_UPDATE_INTERVAL_PARTITION_KEY_TABL_001(C_ID INT,C_D_ID BIGINT not null,C_W_ID TINYINT UNSIGNED not null,C_FIRST VARCHAR(16) not null,C_MIDDLE VARCHAR(10),C_LAST VARCHAR(16) not null,C_STREET_1 VARCHAR(20) not null,C_STREET_2 VARCHAR(20),C_CITY VARCHAR(20) not null,C_STATE CHAR(2) not null,C_ZIP CHAR(9) not null,C_PHONE CHAR(16) not null,C_SINCE TIMESTAMP,C_CREDIT CHAR(2) not null,C_CREDIT_LIM NUMERIC(12,2),C_DISCOUNT NUMERIC(4,4),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL not null,C_PAYMENT_CNT NUMBER not null,C_DELIVERY_CNT BOOL not null,C_END DATE not null,C_DATA1 VARCHAR(8000),C_DATA2 VARCHAR(8000),C_DATA3 VARCHAR(8000),C_DATA4 VARCHAR(8000),C_DATA5 VARCHAR(8000),C_DATA6 VARCHAR(8000),C_DATA7 VARCHAR(8000),C_DATA8 VARCHAR(8000),C_CLOB CLOB,C_BLOB BLOB,PRIMARY KEY (C_ID))
PARTITION BY RANGE(C_D_ID)INTERVAL(400)
(PARTITION PART_1 VALUES LESS THAN (400),PARTITION PART_2 VALUES LESS THAN (800),PARTITION PART_3 VALUES LESS THAN (1200),PARTITION PART_4 VALUES LESS THAN (1600),PARTITION PART_5 VALUES LESS THAN (3000));

INSERT INTO STORAGE_UPDATE_INTERVAL_PARTITION_KEY_TABL_001 SELECT * FROM STORAGE_UPDATE_PARTITION_KEY_TABL_000;

UPDATE STORAGE_UPDATE_INTERVAL_PARTITION_KEY_TABL_001 SET C_D_ID=C_D_ID*2;
drop table STORAGE_UPDATE_PARTITION_KEY_TABL_000;
drop table STORAGE_UPDATE_INTERVAL_PARTITION_KEY_TABL_001;

DROP TABLE IF EXISTS tbl_base;
CREATE TABLE tbl_base (
 id int,
 class varchar(8),
 name varchar2(8),
 gender boolean,
 score number(10, 5),
 id_1 int,
 id_2 int,
 id_3 int,
 id_4 int,
 id_5 int,
 id_6 int,
 id_7 int,
 id_8 int,
 id_9 int,
 id_10 int,
 id_11 int,
 id_12 int,
 id_13 int,
 id_14 int
)partition by hash(id) partitions 5;

INSERT INTO tbl_base
VALUES 
 (1, 'A_001', 'Jack', true, 91.2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14),
 (2, 'A_002', 'Paul', false, 87.1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14),
 (3, 'B_001', 'Javen', 0, 77.4, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14),
 (4, 'B_002', 'Simon', 1, 82.3, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14),
 (5, 'B_003', 'Chosen', 0, 82.3, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);

COMMIT;

alter table tbl_base add column c1 int;
update tbl_base set id = 3 where id = 1;
DROP TABLE tbl_base;