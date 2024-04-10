--DTS202009160ERSORP1F00
drop table if exists nebula_ddl_range_001;
drop table if exists oracle_tbl_000;
drop procedure if exists nebula_dml_range_func_001;
create table oracle_tbl_000(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(50) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data varchar(8000),c_clob clob,c_text blob);
CREATE unique INDEX oracle_indx_000 ON oracle_tbl_000(c_id);
insert into oracle_tbl_000(C_ID,C_D_ID,C_W_ID,C_FIRST,C_MIDDLE,C_LAST,C_STREET_1,C_STREET_2,c_city,c_state,C_ZIP,C_PHONE,C_SINCE,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,C_PAYMENT_CNT,C_DELIVERY_CNT,C_END,C_DATA,C_CLOB,c_text) select 0,0,0,'iscmRDs','OE','BAR','RGF','SDG','dyfrDa','uq','4801','940215','2017-12-31 10:51:47','GC',50000.0,0.4361328,-10.0,10.0,1,true,'2017-12-31 10:51:47',lpad('QVBRfSCC3484942ZCSfjvCF',500,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',500,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',500,'1435764ABC7890abcdef');
CREATE or replace procedure nebula_dml_range_func_001(startall int,endall int)  as
i INT;
j int;
BEGIN
  FOR i IN startall..endall LOOP
  if  i%8=1 then
    select i into j from sys_dummy;
    insert into oracle_tbl_000(C_ID,C_D_ID,C_W_ID,C_FIRST,C_MIDDLE,C_LAST,C_STREET_1,C_STREET_2,c_city,c_state,C_ZIP,C_PHONE,C_SINCE,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,C_PAYMENT_CNT,C_DELIVERY_CNT,C_END,C_DATA,C_CLOB,c_text) select i,i,i,'is'||i||'aa',C_MIDDLE,'BAR'||i,'RGF'||j||'AB','RGF'||i||'ABC',c_city,c_state,C_ZIP,C_PHONE,C_SINCE+j,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,i,C_DELIVERY_CNT,C_END+i,lpad('aaa',4000,'bbb'),lpad('QVBUflcHOQNvmgfvdPFZSF',1000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',1000,'1435764ABC7890abcdef') from oracle_tbl_000 where c_id=0;
    elsif i%8=2 then
        insert into oracle_tbl_000(C_ID,C_D_ID,C_W_ID,C_FIRST,C_MIDDLE,C_LAST,C_STREET_1,C_STREET_2,c_city,c_state,C_ZIP,C_PHONE,C_SINCE,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,C_PAYMENT_CNT,C_DELIVERY_CNT,C_END,C_DATA,C_CLOB,c_text) select i,i,i,'is'||i||'aa',C_MIDDLE,'BAR'||i,'RGF'||j||'AB','RGF'||i||'ABC',c_city,c_state,C_ZIP,C_PHONE,C_SINCE+j,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,i,C_DELIVERY_CNT,C_END+i,C_DATA,lpad('QVBUflcHOQNvmgfvdPFZSF',5000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',5000,'1435764ABC7890abcdef') from oracle_tbl_000 where c_id=0;
    elsif i%8=3 then
    insert into oracle_tbl_000(C_ID,C_D_ID,C_W_ID,C_FIRST,C_MIDDLE,C_LAST,C_STREET_1,C_STREET_2,c_city,c_state,C_ZIP,C_PHONE,C_SINCE,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,C_PAYMENT_CNT,C_DELIVERY_CNT,C_END,C_DATA,C_CLOB,c_text) select i,i,i,'is'||i||'aa',C_MIDDLE,'BAR'||i,'RGF'||j||'AB','RGF'||i||'ABC',c_city,c_state,C_ZIP,C_PHONE,C_SINCE+j,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,i,C_DELIVERY_CNT,C_END+i,C_DATA,null,null from oracle_tbl_000 where c_id=0;
    elsif i%8=4 then
    insert into oracle_tbl_000(C_ID,C_D_ID,C_W_ID,C_FIRST,C_MIDDLE,C_LAST,C_STREET_1,C_STREET_2,c_city,c_state,C_ZIP,C_PHONE,C_SINCE,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,C_PAYMENT_CNT,C_DELIVERY_CNT,C_END,C_DATA,C_CLOB,c_text) select i,i,i,'is'||i||'aa',C_MIDDLE,'BAR'||i,'RGF'||j||'AB','RGF'||i||'ABC',c_city,c_state,C_ZIP,C_PHONE,C_SINCE+j,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,i,C_DELIVERY_CNT,C_END+i,C_DATA,lpad('QVBUflcHOQNvmgfvdPFZSF',2000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',5000,'1435764ABC7890abcdef') from oracle_tbl_000 where c_id=0;
    elsif i%8=5 then
    insert into oracle_tbl_000(C_ID,C_D_ID,C_W_ID,C_FIRST,C_MIDDLE,C_LAST,C_STREET_1,C_STREET_2,c_city,c_state,C_ZIP,C_PHONE,C_SINCE,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,C_PAYMENT_CNT,C_DELIVERY_CNT,C_END,C_DATA,C_CLOB,c_text) select i,i,i,'is'||i||'aa',C_MIDDLE,'BAR'||i,'RGF'||j||'AB','RGF'||i||'ABC',c_city,c_state,C_ZIP,C_PHONE,C_SINCE+j,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,i,C_DELIVERY_CNT,C_END+i,lpad('aaa',6000,'bbb'),lpad('QVBUflcHOQNvmgfvdPFZSF',1000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',1000,'1435764ABC7890abcdef') from oracle_tbl_000 where c_id=0;
    elsif i%8=6 then
    insert into oracle_tbl_000(C_ID,C_D_ID,C_W_ID,C_FIRST,C_MIDDLE,C_LAST,C_STREET_1,C_STREET_2,c_city,c_state,C_ZIP,C_PHONE,C_SINCE,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,C_PAYMENT_CNT,C_DELIVERY_CNT,C_END,C_DATA,C_CLOB,c_text) select i,i,i,'is'||i||'aa',C_MIDDLE,'BAR'||i,'RGF'||j||'AB','RGF'||i||'ABC',c_city,c_state,C_ZIP,C_PHONE,C_SINCE+j,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,i,C_DELIVERY_CNT,C_END+i,lpad('aaa',7000,'bbb'),lpad('QVBUflcHOQNvmgfvdPFZSF',5000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',5000,'1435764ABC7890abcdef') from oracle_tbl_000 where c_id=0;
    elsif i%8=7 then
    insert into oracle_tbl_000(C_ID,C_D_ID,C_W_ID,C_FIRST,C_MIDDLE,C_LAST,C_STREET_1,C_STREET_2,c_city,c_state,C_ZIP,C_PHONE,C_SINCE,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,C_PAYMENT_CNT,C_DELIVERY_CNT,C_END,C_DATA,C_CLOB,c_text) select i,i,i,'is'||i||'aa',C_MIDDLE,'BAR'||i,'RGF'||j||'AB','RGF'||i||'ABC',c_city,c_state,C_ZIP,C_PHONE,C_SINCE+j,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,i,C_DELIVERY_CNT,C_END+i,lpad('aaa',7000,'bbb'),null,null from oracle_tbl_000 where c_id=0;
    elsif i%8=0 then
    insert into oracle_tbl_000(C_ID,C_D_ID,C_W_ID,C_FIRST,C_MIDDLE,C_LAST,C_STREET_1,C_STREET_2,c_city,c_state,C_ZIP,C_PHONE,C_SINCE,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,C_PAYMENT_CNT,C_DELIVERY_CNT,C_END,C_DATA,C_CLOB,c_text) select i,i,i,'is'||i||'aa',C_MIDDLE,'BAR'||i,'RGF'||j||'AB','RGF'||i||'ABC',c_city,c_state,C_ZIP,C_PHONE,C_SINCE+j,C_CREDIT,C_CREDIT_LIM,C_DISCOUNT,C_BALANCE,C_YTD_PAYMENT,i,C_DELIVERY_CNT,C_END+i,lpad('aaa',7000,'bbb'),lpad('QVBUflcHOQNvmgfvdPFZSF',100,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',5000,'1435764ABC7890abcdef') from oracle_tbl_000 where c_id=0;
   end if;
  END LOOP;
END;
/
call nebula_dml_range_func_001(1,800);
commit;
create table nebula_ddl_range_001(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(50) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data varchar(8000),c_clob clob,c_text blob, c_add int default 10) partition by range(c_id,c_first) (partition PART_1 values less than (101,'is101') storage(INITIAL 128K maxsize 5G),partition PART_2 values less than (201,'is201'),partition PART_3 values less than (301,'is301'),partition PART_4 values less than (401,'is401'),partition PART_5 values less than (501,'is501'),partition PART_6 values less than (601,'is601'),partition PART_7 values less than (701,'is701'),partition PART_8 values less than (801,'is801') storage(INITIAL 128K maxsize 5G),partition PART_9 values less than (901,'is901'),partition PART_10 values less than (maxvalue,maxvalue));
CREATE INDEX nebula_ddl_range_indx_001_1 ON nebula_ddl_range_001(c_d_id,c_last,c_end,c_payment_cnt, c_add);
CREATE INDEX nebula_ddl_range_indx_001_2 ON nebula_ddl_range_001(c_first) local;
CREATE INDEX nebula_ddl_range_indx_001_3 ON nebula_ddl_range_001(c_id,c_first) local;
CREATE INDEX nebula_ddl_range_indx_001_4 ON nebula_ddl_range_001(c_id,c_first,c_last);
insert into nebula_ddl_range_001 select *, c_id from oracle_tbl_000;commit;
ALTER TABLE nebula_ddl_range_001 ADD CONSTRAINT nebula_ddl_range_cstr_001 PRIMARY KEY(c_id,c_first,c_d_id,c_w_id,c_end) USING INDEX LOCAL (PARTITION idx_p1,PARTITION idx_p,PARTITION idx_p3,PARTITION idx_p4,PARTITION idx_p5,PARTITION idx_p6,PARTITION idx_p7,PARTITION idx_p8,PARTITION idx_p9,PARTITION idx_p10);
replace into nebula_ddl_range_001(c_id,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_clob,c_text) select * from oracle_tbl_000;
commit;
drop procedure if exists nebula_dml_range_func_001;
drop table if exists nebula_ddl_range_001;
drop table if exists oracle_tbl_000;

--DTS202007270539T5P1100
drop table if exists replace_tt1;
drop trigger if exists replace_tt1_trg;
create table replace_tt1 (f1 int,f2 int,f3 int);
CREATE UNIQUE INDEX ttt1_idx on replace_tt1(f1,f2);
insert into replace_tt1 values(1,3,3),(11,13,13);
commit;
create or replace trigger replace_tt1_trg before delete on replace_tt1
begin
  update replace_tt1 set f2=f2+1,f3=f3+1;
end;
/
replace into replace_tt1 select f1+10,f2+10,f3+10 from replace_tt1;
drop trigger replace_tt1_trg;
drop table replace_tt1;

--DTS202007270K2Q7IP1300
drop table if exists merge_into_csf_tbl_000;
drop table if exists merge_into_csf_trg_tbl_001;
drop procedure if exists merge_into_csf_proc_000;
drop sequence if exists merge_into_csf_trg_seq_001;
drop sequence if exists merge_into_csf_trg_seq_001_1;
drop sequence if exists merge_into_csf_trg_seq_001_2;
drop trigger if exists merge_into_csf_trg_001;
drop trigger if exists merge_into_csf_trg_001_1;
create table merge_into_csf_tbl_000(c_id int,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state varchar(20) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(8000),c_data2 varchar(8000),c_data3 varchar(8000),c_data4 varchar(8000),c_data5 varchar(8000),c_data6 varchar(8000),c_data7 varchar(6000),c_data8 varchar(4000),c_clob clob,c_blob blob);
CREATE or replace procedure merge_into_csf_proc_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from sys_dummy;
    insert into merge_into_csf_tbl_000 select i,i,i,'iscmRDs'||j,'OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,1,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',4000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',1000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',5000,'1435764ABC7890abcdef') from sys_dummy;
  END LOOP;
END;
/
call merge_into_csf_proc_000(1,1000);
commit;
create table merge_into_csf_trg_tbl_001(c_id int,c_d_id bigint,c_w_id tinyint unsigned,c_first varchar(16),c_middle char(2),c_last varchar(16),c_street_1 varchar(20),c_street_2 varchar(20),c_city varchar(20),c_state varchar(20),c_zip char(9),c_phone char(16),c_since timestamp,c_credit char(2),c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real,c_payment_cnt number,c_delivery_cnt bool,c_end date,c_data1 varchar(7744),c_data2 varchar(7744),c_data3 varchar(7744),c_data4 varchar(7744),c_data5 varchar(7744),c_data6 varchar(7744),c_data7 varchar(7744),c_data8 varchar(7744),c_clob clob,c_blob blob) partition by range(c_id) interval(10) (partition PART_1 values less than (21),partition PART_2 values less than (41),partition PART_3 values less than (61),partition PART_4 values less than (81)) format csf;
CREATE UNIQUE INDEX merge_into_csf_trg_indx_001_1 ON merge_into_csf_trg_tbl_001(c_id,c_d_id);
CREATE INDEX merge_into_csf_trg_indx_001_2 ON merge_into_csf_trg_tbl_001(c_id);
CREATE INDEX merge_into_csf_trg_indx_001_3 ON merge_into_csf_trg_tbl_001(c_city);
CREATE INDEX merge_into_csf_trg_indx_001_4 ON merge_into_csf_trg_tbl_001(c_first,c_state);
CREATE INDEX merge_into_csf_trg_indx_001_5 ON merge_into_csf_trg_tbl_001(c_id,c_d_id,c_middle);
CREATE INDEX merge_into_csf_trg_indx_001_6 ON merge_into_csf_trg_tbl_001(c_id,c_d_id,c_middle,c_street_1);
--I2.创建触发器
create sequence merge_into_csf_trg_seq_001 start with 1 increment by 1 order;
create sequence merge_into_csf_trg_seq_001_1 start with 1 increment by 1 order;
create sequence merge_into_csf_trg_seq_001_2 start with 1 increment by 1 order;
MERGE INTO merge_into_csf_trg_tbl_001 T1 USING (SELECT * FROM merge_into_csf_tbl_000) T2 on (T1.c_id=T2.c_id) WHEN MATCHED THEN UPDATE SET T1.c_first=T1.c_first||'aa',T1.c_state=T1.c_state||'aa' WHEN NOT MATCHED THEN  INSERT (c_id,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data1,c_data2,c_data3,c_data4,c_data5,c_data6,c_data7,c_data8,c_clob,c_blob) VALUES (merge_into_csf_trg_seq_001.nextval,merge_into_csf_trg_seq_001_1.nextval,merge_into_csf_trg_seq_001_2.nextval,'iscmRDs0','OE','BARBar0','bkilifcrRGF0','pmbwovhSDGj0','dyfrDa0','uq','48010','9402150',sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,1,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',4000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',3000,'1435764ABC7890abcdef'));
create or replace trigger merge_into_csf_trg_001 before insert or update or delete on merge_into_csf_trg_tbl_001
begin
  DBE_OUTPUT.PRINT_LINE('Hello 1!');
END;
/
create or replace trigger merge_into_csf_trg_001_1 after insert or update or delete on merge_into_csf_trg_tbl_001
begin
  DBE_OUTPUT.PRINT_LINE('Hello 2!');
END;
/
set serverout on
replace into merge_into_csf_trg_tbl_001(c_id,c_d_id,c_w_id,c_payment_cnt,c_data1,c_clob,c_blob) select c_id+10,c_d_id+10,c_w_id+10,1234123412341.1,lpad('aaa',4000,'bbb'),lpad('aaa',4000,'bbb'),lpad('1111',4000,'2222') from merge_into_csf_trg_tbl_001;
set serverout off
drop table merge_into_csf_tbl_000;
drop table merge_into_csf_trg_tbl_001;
drop procedure merge_into_csf_proc_000;
drop sequence merge_into_csf_trg_seq_001;
drop sequence merge_into_csf_trg_seq_001_1;
drop sequence merge_into_csf_trg_seq_001_2;

--DTS2019061711815
drop table if exists tbl_dml_js1;
create table tbl_dml_js1(
id int primary key,
js varchar(8000) check(js is json)
);
insert into tbl_dml_js1 values(1 ,'{"A":1 ,":":[1,"A1 ",true],"B1 ":{"C ":"1 "},"D":[1 ]}');
insert into tbl_dml_js1 values(2 ,'{"A":2 ,":":[1,"A2 ",true],"B2 ":{"C ":"2 "},"D":[2 ]}');

drop table if exists tbl_js1;
create table tbl_js1(
id int ,
js varchar(3900)check(js is json)
);
alter table tbl_js1 add constraint tbl_js1_pk_1 primary key(js);
replace into tbl_js1 set id = (1),js = (select js from tbl_dml_js1 order by 1 limit 1);
replace into tbl_js1 set id = (1),js = (select js from tbl_dml_js1 order by 1 limit 1);
select * from tbl_js1 order by 2;
drop table tbl_dml_js1;
drop table tbl_js1;

--test 'REPLACE INTO' in PROCEDURE 
drop table if exists test_student;
create table test_student(SId varchar(10) primary key,Sname varchar(10),Sage datetime,Ssex varchar(10));
	--two or more brackets are not supported by procedure yet
CREATE or replace procedure construct_student_pro(startall int,endall int,sex varchar) as 
i INT;
BEGIN
  FOR i IN startall..endall LOOP
		replace into test_student ((select i+6,'asdf'||i||'f','2012-10-12',sex));
		commit;
  END LOOP;
END;
/
CREATE or replace procedure construct_student_pro(startall int,endall int,sex varchar) as 
i INT;
BEGIN
  FOR i IN startall..endall LOOP
		replace into test_student (select i+6,'asdf'||i||'f','2012-10-12',sex);
		commit;
  END LOOP;
END;
/
CREATE or replace procedure construct_student_pro(startall int,endall int,sex varchar) as
i INT;
BEGIN
  FOR i IN startall..endall LOOP
        replace into test_student values(i,'asdf'||i||'f','2012-10-10',sex);
		replace into test_student set sid = i+3, Sname = 'asdf'||i||'f', Sage = '2012-10-11', Ssex = sex; 
		replace into test_student select i+6,'asdf'||i||'f','2012-10-12',sex;
		commit;
  END LOOP;
END;
/
call construct_student_pro(1,3,'man');
select * from test_student order by to_number(sid);
drop procedure if exists construct_student_pro;
drop table if exists test_student;

--test 'REPLACE INTO' in ANONYMOUS 
drop table if exists test_student;
create table test_student(SId varchar(10) primary key,Sname varchar(10),Sage datetime,Ssex varchar(10));
declare 
  i int;
  str varchar(100);
begin
  i := 1;
  for i in 1..1 
  loop
	str := 'replace into test_student values(1,''asdf1f'',''2012-10-10'',''man'')';
	execute immediate str;
	str := 'replace into test_student set sid = 2, Sname = ''asdf2f'', Sage = ''2012-10-11'', Ssex = ''man''';
	execute immediate str;
	str := 'replace into test_student select 3,''asdf3f'',''2012-10-12'',''man''';
	execute immediate str;
  end loop;
end;
/
select * from test_student order by to_number(sid);
drop table if exists test_student;

--test 'REPLACE INTO' in FUNCTION
drop table if exists test_student;
create table test_student(SId varchar(10) primary key,Sname varchar(10),Sage datetime,Ssex varchar(10));
CREATE OR REPLACE function select_item_fuc (
startall in number,
endall in number
)
return number
IS
temp VARCHAR2(30);
BEGIN
  FOR i IN startall..endall LOOP
        replace into test_student values(i,'asdf'||i||'f','2012-10-10','man');
		replace into test_student set sid = i+3, Sname = 'asdf'||i||'f', Sage = '2012-10-11', Ssex = 'man'; 
		replace into test_student select i+6,'asdf'||i||'f','2012-10-12','man';
		commit;
  END LOOP;
return 1;
END;
/
declare
dept_count int;
begin
dept_count:=select_item_fuc(1,3);
end;
/
select * from test_student order by to_number(sid);
drop function if exists select_item_fuc;
drop table if exists test_student;

--test using replace with trigger
drop table if exists test_replace_trigger;
drop function if exists func_11;
drop trigger if exists trigger_a;
create table test_replace_trigger(a int);
insert into test_replace_trigger values(11);
create trigger trigger_a after insert on test_replace_trigger for each row
begin
	delete from test_replace_trigger;
end;
/
create function func_11 return int
is
begin
   loop
    if (true)
      then
        replace into test_replace_trigger select 1;
        goto end_loop;
    end if;
   end loop;
  <<end_loop>> --label
  return 0;
end;
/
select func_11() from dual;
replace into test_replace_trigger select 1;
replace into test_replace_trigger set a = 1;
replace into test_replace_trigger values(1);

create or replace trigger trigger_a after insert on test_replace_trigger for each row
DECLARE
 NEXT_ID NUMBER;
begin
	select * into NEXT_ID from test_replace_trigger where a = 11;
end;
/
create or replace function func_11 return int
is
esal number;
begin
   loop
    if (true)
      then
        replace into test_replace_trigger select 1;
		replace into test_replace_trigger set a = 1;
		replace into test_replace_trigger values(1);
        goto end_loop;
    end if;
   end loop;
  <<end_loop>> --label
  return 0;
end;
/
select func_11() from dual;
replace into test_replace_trigger select 1;
replace into test_replace_trigger set a = 1;
replace into test_replace_trigger values(1);

drop table if exists test_replace_trigger;
drop function if exists func_11;
drop trigger if exists trigger_a;

--DTS2019060102640
drop table if exists tbl_replace_range;
create table tbl_replace_range(
id int,
col_char1 varchar(30),
col_char2 varchar(30),
col_char3 varchar(30)
)partition  by range(id)
(
    partition p_range_01 values less than (5),
    partition p_range_02 values less than (15),
    partition p_range_03 values less than (25),
    partition p_range_04 values less than (35)
);
    
alter table tbl_replace_range add constraint cos_range_pk1 primary key(id);  
alter table tbl_replace_range add constraint cos_range_uk1 unique(col_char3);

replace into tbl_replace_range values(1,'test for range 1','replace into values','...1');
replace into tbl_replace_range values(2,'test for range 2','replace into values','...2');
replace into tbl_replace_range values(3,'test for range 3','replace into values','...3');
replace into tbl_replace_range values(4,'test for range 4','replace into values','...4');
replace into tbl_replace_range value(select 5,'test for range 5','replace into value select','...5' from dual);
replace into tbl_replace_range value(select 6,'test for range 6','replace into value select','...6' from dual);
replace into tbl_replace_range value(select 7,'test for range 7','replace into value select','...7' from dual);
replace into tbl_replace_range value(select 8,'test for range 8','replace into value select','...8' from dual);
replace into tbl_replace_range (select 15,'test for range 15','replace into select ','...15');
replace into tbl_replace_range (select 16,'test for range 16','replace into select ','...16');
replace into tbl_replace_range (select 17,'test for range 17','replace into select ','...17');
replace into tbl_replace_range (select 18,'test for range 18','replace into select ','...18');
replace into tbl_replace_range set id=25,col_char1='test for range 25',col_char2='replace into set',col_char3='...25';
replace into tbl_replace_range set id=26,col_char1='test for range 26',col_char2='replace into set',col_char3='...26';
replace into tbl_replace_range set id=27,col_char1='test for range 27',col_char2='replace into set',col_char3='...27';
replace into tbl_replace_range set id=28,col_char1='test for range 28',col_char2='replace into set',col_char3='...28';
commit;
select * from tbl_replace_range order by id;

drop table tbl_replace_range;

-- DTS2019072801741
alter system SET UPPER_CASE_TABLE_NAMES = false;
drop table if exists test;
create table test(f1 int, f2 int);
replace into test(f1,f2)values(1,3);
alter system SET UPPER_CASE_TABLE_NAMES = true;
show parameter UPPER_CASE_TABLE_NAMES

-- DTS202010300E3ZCMP1300,
drop table partition_interval_001;
CREATE TABLE partition_interval_001 (
	c_id INT
	,c_d_id BIGINT 
	,c_w_id TINYINT unsigned 
	,c_first VARCHAR(64) 
	,c_middle CHAR(2)
	,c_last VARCHAR(64) 
	,c_street_1 VARCHAR(20) 
	,c_street_2 VARCHAR(2000)
	,c_city VARCHAR(20) 
	,c_state CHAR(2) 
	,c_zip CHAR(9) 
	,c_phone CHAR(16) 
	,c_since TIMESTAMP
	,c_credit CHAR(2) 
	,c_credit_lim NUMERIC(12, 2)
	,c_discount NUMERIC(4, 4)
	,c_balance NUMERIC(12, 2)
	,c_ytd_payment REAL 
	,c_payment_cnt number 
	,c_delivery_cnt bool 
	,c_end DATE 
	,c_vchar VARCHAR(1000)
	,c_data long
	,c_text blob
	,c_clob clob
    , add_column blob default lpad('11111',1,'4253365450')
	) PARTITION BY range (c_id) interval (10) (
	PARTITION part_1 VALUES less than(201)
	,PARTITION part_2 VALUES less than(401)
	,PARTITION part_3 VALUES less than(601)
	,PARTITION part_4 VALUES less than(801)
	,PARTITION part_5 VALUES less than(1001)
	,PARTITION part_6 VALUES less than(1201)
	,PARTITION part_7 VALUES less than(1401)
	,PARTITION part_8 VALUES less than(1601)
	,PARTITION part_9 VALUES less than(1801)
	);
    
replace into PARTITION_INTERVAL_001 set  C_ID=9749, C_D_ID=8943, C_W_ID=3496, C_SINCE=sysdate, C_CREDIT_LIM=0;
select add_column from PARTITION_INTERVAL_001;

drop table if exists test_load;
create table test_load (f1 int default 1000, f2 int ,f3 int, f4 int default 2000);
insert into test_load values(5,50,500,5000);
replace test_load set f1 = f2 = f3,f4 = 6;
drop table test_load;