--
-- Temporary table
--

create global temporary table ww_temp1(id int, description varchar(400)) ON COMMIT preserve ROWS; 

insert into ww_temp1 values(1, 'aaaaaaa'), (3, 'bbbb'), (5, 'xxxxxx');

create table ww_norm_t1(id int);
insert into ww_norm_t1 values(1),(2),(5);

select a.description from ww_temp1 a inner join ww_norm_t1 b on a.id=b.id;

delete from ww_temp1 where rowid in ( select a.rowid from ww_temp1 a inner join ww_norm_t1 b on a.id=b.id); 

select * from ww_temp1;

create global temporary table tmp_t1(id int, name varchar(4000)) on commit preserve rows;
insert into tmp_t1 values (1,lpad('a',20,'a'));
insert into tmp_t1 values (2,lpad('b',20,'b'));
update tmp_t1 set name=lpad('a',30,'a') where id=1;
update tmp_t1 set name=lpad('b',30,'b') where id=2;
select * from tmp_t1;
update tmp_t1 set name=lpad('a',40,'a') where id=1;
update tmp_t1 set name=lpad('b',40,'a') where id=2;
select * from tmp_t1;
update tmp_t1 set name=lpad('a',50,'a') where id=1;
update tmp_t1 set name=lpad('b',50,'b') where id=2;
select * from tmp_t1;
update tmp_t1 set name=lpad('a',40,'a') where id=1;
update tmp_t1 set name=lpad('b',40,'b') where id=2;
select * from tmp_t1;
update tmp_t1 set name=lpad('a',30,'a') where id=1;
update tmp_t1 set name=lpad('b',30,'b') where id=2;
select * from tmp_t1;
truncate table tmp_t1;
select count(*) from tmp_t1;
select id from tmp_t1 where id=1;	
insert into tmp_t1 values (1,lpad('a',20,'a'));
select * from tmp_t1;
rollback;
select * from tmp_t1;
insert into tmp_t1 values (1,lpad('a',20,'a'));
commit;
update tmp_t1 set name=lpad('a',30,'a') where id=1;
select * from tmp_t1;
rollback;
select * from tmp_t1;
update tmp_t1 set name=lpad('a',30,'a') where id=1;
commit;
select * from tmp_t1;
update tmp_t1 set name=lpad('a',20,'a') where id=1;
select * from tmp_t1;
rollback;
select * from tmp_t1;
update tmp_t1 set name=lpad('b',30,'b') where id=1;
select * from tmp_t1;
rollback;
select * from tmp_t1;
delete from tmp_t1;
select * from tmp_t1;
rollback;
select * from tmp_t1;
truncate table tmp_t1;
select count(*) from tmp_t1;
insert into tmp_t1 values (1, lpad('1',4000,'1'));
insert into tmp_t1 values (2, lpad('2',4000,'2'));
insert into tmp_t1 values (3, lpad('3',4000,'3'));
insert into tmp_t1 values (4, lpad('4',4000,'4'));
insert into tmp_t1 values (5, lpad('5',4000,'5'));
insert into tmp_t1 values (6, lpad('6',4000,'6'));
insert into tmp_t1 values (7, lpad('7',4000,'7'));
insert into tmp_t1 values (8, lpad('8',4000,'8'));
insert into tmp_t1 values (9, lpad('9',4000,'9'));
insert into tmp_t1 values (10, lpad('0',4000,'0'));
create unique index tmp_ti1 on tmp_t1(id);
create unique index tmp_ti2 on tmp_t1(id) online;
insert into tmp_t1 values (11, lpad('1',4000,'1'));
insert into tmp_t1 values (12, lpad('2',4000,'2'));
insert into tmp_t1 values (13, lpad('3',4000,'3'));
insert into tmp_t1 values (14, lpad('4',4000,'4'));
insert into tmp_t1 values (15, lpad('5',4000,'5'));
insert into tmp_t1 values (16, lpad('6',4000,'6'));
insert into tmp_t1 values (17, lpad('7',4000,'7'));
insert into tmp_t1 values (18, lpad('8',4000,'8'));
insert into tmp_t1 values (19, lpad('9',4000,'9'));
insert into tmp_t1 values (20, lpad('0',4000,'0'));
select count(*) from tmp_t1;
select id from tmp_t1 where id=2;
insert into tmp_t1 values (21,'aa'),(22,'bb'),(23,'cc'),(24,'dd'),(25,'ee');
update tmp_t1 set name='bbbbbbbbbbbbbb' where id=22;
select * from tmp_t1 where id=21;
select * from tmp_t1 where id=22;
select count(*) from tmp_t1;
select id from tmp_t1 where id=16;
select id from tmp_t1 where id=17;
select id from tmp_t1 where id=18;
select id from tmp_t1 where id=19;
select id from tmp_t1 where id=20;
select id from tmp_t1 where id=21;
delete from tmp_t1 where id<=5;
select count(*) from tmp_t1;
select id from tmp_t1 order by id;
insert into tmp_t1 values (1, lpad('1',4000,'1'));
insert into tmp_t1 values (2, lpad('2',4000,'2'));
insert into tmp_t1 values (3, lpad('3',4000,'3'));
insert into tmp_t1 values (4, lpad('3',4000,'3'));
insert into tmp_t1 values (5, lpad('0',4000,'0'));
select count(*) from tmp_t1;
select id from tmp_t1 order by id;
select id from tmp_t1 where id=4;
delete from tmp_t1 where id>10 and id<=15;
select id from tmp_t1 order by id;
insert into tmp_t1 values (11, lpad('1',4000,'1'));
insert into tmp_t1 values (12, lpad('2',4000,'2'));
insert into tmp_t1 values (13, lpad('3',4000,'3'));
insert into tmp_t1 values (14, lpad('4',4000,'4'));
insert into tmp_t1 values (15, lpad('5',4000,'5'));
update tmp_t1 set name=lpad('0',2000,'0') where id=1;
update tmp_t1 set name=lpad('0',2000,'0') where id=3;
update tmp_t1 set name=lpad('0',2000,'0') where id=5;
update tmp_t1 set name=lpad('0',2000,'0') where id=7;
update tmp_t1 set name=lpad('0',2000,'0') where id=9;
delete from tmp_t1 where id>20;
insert into tmp_t1 values (21, lpad('1',4000,'1'));
insert into tmp_t1 values (22, lpad('2',4000,'2'));
update tmp_t1 set name=lpad('0',2000,'0') where id=21;
insert into tmp_t1 values (23, lpad('3',4000,'3'));
insert into tmp_t1 values (24, lpad('4',4000,'4'));
update tmp_t1 set name=lpad('0',2000,'0') where id=23;
insert into tmp_t1 values (25, lpad('5',4000,'5'));
insert into tmp_t1 values (26, lpad('6',4000,'6'));
update tmp_t1 set name=lpad('0',2000,'0') where id=25;
insert into tmp_t1 values (27, lpad('7',4000,'7'));
insert into tmp_t1 values (28, lpad('8',4000,'8'));
update tmp_t1 set name=lpad('0',2000,'0') where id=27;
insert into tmp_t1 values (29, lpad('9',4000,'9'));
insert into tmp_t1 values (30, lpad('0',4000,'0'));
insert into tmp_t1 values (31, lpad('1',4000,'1'));
insert into tmp_t1 values (32, lpad('2',4000,'2'));
insert into tmp_t1 values (33, lpad('3',4000,'3'));
insert into tmp_t1 values (34, lpad('4',4000,'4'));
insert into tmp_t1 values (35, lpad('5',4000,'5'));
select id from tmp_t1 order by id;
select count(*) from tmp_t1;
select id from tmp_t1 where id=18;
select id from tmp_t1 where id=1;
select id from tmp_t1 where id=5;
select id from tmp_t1 where id=12;
update tmp_t1 set id=40 where id=35;
select id from tmp_t1 where id=40;
select count(*) from tmp_t1;
insert into tmp_t1 values (1, lpad('1',4000,'1'));
insert into tmp_t1 values (2, lpad('2',4000,'2'));
explain select id from tmp_t1 where id=1;
explain update tmp_t1 set name='aaaaa' where id=5;
explain delete from tmp_t1 where id=3;
alter index tmp_ti1 on tmp_t1 rebuild online;
select count(*) from tmp_t1;
drop table tmp_t1;
create global temporary table tmp_t2(id int, name varchar(32));
create index tmp_ti3 on tmp_t2(id);
create index tmp_ti4 on tmp_t2(name);
insert into tmp_t2 values (1, lpad('a',20,'a'));
insert into tmp_t2 values (2, lpad('b',20,'b'));
insert into tmp_t2 values (3, lpad('c',20,'c'));
insert into tmp_t2 values (4, lpad('d',20,'d'));
insert into tmp_t2 values (5, lpad('e',20,'e'));
insert into tmp_t2 values (6, lpad('f',20,'f'));
insert into tmp_t2 values (7, lpad('g',20,'g'));
insert into tmp_t2 values (8, lpad('h',20,'h'));
insert into tmp_t2 values (9, lpad('i',20,'i'));
insert into tmp_t2 values (10, lpad('j',20,'j'));
select * from tmp_t2 where id=9 and name='iiiiiiiiiiiiiiiiiiii';
select * from tmp_t2 where id=10 and name='iiiiiiiiiiiiiiiiiiii';
explain select * from tmp_t2 where id=9 and name='aaaaaaaaaaaaaaaaaaaa';
select count(*) from tmp_t2;
commit;
select count(*) from tmp_t2;
drop index tmp_ti4 on tmp_t3;
drop table tmp_t2;
create global temporary table tmp_t3(id int, name varchar(32)) on commit preserve rows;
create index tmp_ti3 on tmp_t3(id);
create index tmp_ti4 on tmp_t3(name);
insert into tmp_t3 values (1, lpad('a',20,'a'));
insert into tmp_t3 values (2, lpad('b',20,'b'));
insert into tmp_t3 values (3, lpad('c',20,'c'));
insert into tmp_t3 values (4, lpad('d',20,'d'));
insert into tmp_t3 values (5, lpad('e',20,'e'));
insert into tmp_t3 values (6, lpad('f',20,'f'));
insert into tmp_t3 values (7, lpad('g',20,'g'));
insert into tmp_t3 values (8, lpad('h',20,'h'));
insert into tmp_t3 values (9, lpad('i',20,'i'));
insert into tmp_t3 values (10, lpad('j',20,'j'));
select * from tmp_t3 where id=9 and name='iiiiiiiiiiiiiiiiiiii';
drop index tmp_ti4 on tmp_t3;
select * from tmp_t3 where id=1;
drop table tmp_t3;
create global temporary table tmp_t5(id int, name varchar(32));
create index tmp_ti5 on tmp_t5(id);
create index tmp_ti6 on tmp_t5(name);
insert into tmp_t5 values (1, lpad('a',20,'a'));
insert into tmp_t5 values (2, lpad('b',20,'b'));
insert into tmp_t5 values (3, lpad('c',20,'c'));
insert into tmp_t5 values (4, lpad('d',20,'d'));
insert into tmp_t5 values (5, lpad('e',20,'e'));
insert into tmp_t5 values (6, lpad('f',20,'f'));
insert into tmp_t5 values (7, lpad('g',20,'g'));
insert into tmp_t5 values (8, lpad('h',20,'h'));
insert into tmp_t5 values (9, lpad('i',20,'i'));
insert into tmp_t5 values (10, lpad('j',20,'j'));
update tmp_t5 set name='iiiiii' where id=9;
update tmp_t5 set name='jjjjj' where id=10;
delete from tmp_t5 where id=4;
delete from tmp_t5 where id=5;
delete from tmp_t5;
rollback;

create temporary tablespace tmp_sp1 tempfile 'temp1' size 64M;
create global temporary table tmp_t1(id int) tablespace user1;

-- DTS2018080308859 
drop table if exists storage_exp_global_tbl_000;
create table storage_exp_global_tbl_000(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data varchar(1000),c_text binary(1000),c_clob varchar(1000));
CREATE UNIQUE INDEX storage_exp_global_indx_000_1 ON storage_exp_global_tbl_000(c_id,c_d_id);
CREATE INDEX storage_exp_global_indx_000_2 ON storage_exp_global_tbl_000(c_id);
CREATE INDEX storage_exp_global_indx_000_3 ON storage_exp_global_tbl_000(c_city);
CREATE INDEX storage_exp_global_indx_000_4 ON storage_exp_global_tbl_000(c_first,c_state);
CREATE INDEX storage_exp_global_indx_000_5 ON storage_exp_global_tbl_000(c_id,c_d_id,c_middle);
CREATE INDEX storage_exp_global_indx_000_6 ON storage_exp_global_tbl_000(c_id,c_d_id,c_middle,c_street_1);

alter table storage_exp_global_tbl_000 add constraint storage_exp_global_constraint_000 primary key(c_id,c_w_id) using index(create index storage_exp_global_indx_000 on storage_exp_global_tbl_000(c_id,c_w_id) pctfree 30 initrans 10);
CREATE or replace procedure storage_exp_global_func_000(start_n int,endall int) IS
i INT;
j varchar(10);
BEGIN
  FOR i IN start_n..endall LOOP
    select cast(i as varchar(10)) into j from dual;
    insert into storage_exp_global_tbl_000 select i,i,i,'is'||j||'cmRDs'||j,'OE','BAR'||j||'Bar'||j,'bkili'||j||'fcrRGF'||j,'pmbwo'||j||'vhSDGj'||j,'dyf'||j||'rDa'||j,'uq',4801||j
,940||j||215||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate,lpad('QVLDETANRBRBUfSMNTECC3489354CufvCDSF',200,'sadfu87324'),lpad('DEfcf31436',200,'789dfafd'),lpad('QVLDC3489354CufvCDSF',200,'sadfu
87324') from dual;
  END LOOP;
END;
/

call storage_exp_global_func_000(1,1000);
commit;

drop table if exists storage_exp_global_tbl_001;
create global temporary table storage_exp_global_tbl_001 as select * from storage_exp_global_tbl_000;
CREATE INDEX storage_exp_global_indx_001_3 ON storage_exp_global_tbl_001(c_city);
CREATE INDEX storage_exp_global_indx_001_4 ON storage_exp_global_tbl_001(c_first,c_state);
CREATE INDEX storage_exp_global_indx_001_5 ON storage_exp_global_tbl_001(c_id,c_d_id,c_middle);
CREATE INDEX storage_exp_global_indx_001_6 ON storage_exp_global_tbl_001(c_id,c_d_id,c_middle,c_street_1);

alter table storage_exp_global_tbl_001 add constraint storage_exp_global_constraint_001 primary key(c_id) using index(create index storage_exp_global_indx_001 on storage_exp_global_tbl_001(c_id) pctfree 30 initrans 10);

CREATE or replace procedure storage_exp_global_func_001(start_n int,endall int) IS
i INT;
j varchar(10);
BEGIN
  FOR i IN start_n..endall LOOP
    select cast(i as varchar(10)) into j from dual;
    insert into storage_exp_global_tbl_001 select i,i,i,'is'||j||'cmRDs'||j,'OE','BAR'||j||'Bar'||j,'bkili'||j||'fcrRGF'||j,'pmbwo'||j||'vhSDGj'||j,'dyf'||j||'rDa'||j,'uq',4801||j
,940||j||215||j,sysdate,'GC',50010.0,0.4361328,-10.0,10.0,1,true,sysdate,lpad('QVLDETANRBRBUfSMNTECC3489354CufvCDSF',200,'sadfu87324'),lpad('DEfcf31436',200,'789dfafd'),lpad('QVLDC3489354CufvCDSF',200,'sadfu
87324') from dual;
  END LOOP;
END;
/

call storage_exp_global_func_001(1,10);
commit;

insert into storage_exp_global_tbl_001 select * from storage_exp_global_tbl_000;
update storage_exp_global_tbl_001 set c_id=c_id+1001,c_first=c_first||'a',c_data=lpad('QVLDC3489354CufvCDSF',300,'sadfu87324'),c_text=lpad('DEfcf31436',300,'789dfafd') where c_id>500 and c_id<=1001;
select sum(c_id) from storage_exp_global_tbl_001;
commit;


----DTS2018082210679
DROP TABLE IF EXISTS storage_row_link_global_tbl_000;
create table storage_row_link_global_tbl_000(c_id int,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(8000),c_data2 varchar(8000),c_data3 varchar(8000),c_data4 varchar(8000),c_data5 varchar(8000),c_data6 varchar(8000),c_data7 varchar(6000),c_data8 varchar(4000),c_clob varchar(3000),c_text varchar(3000));
CREATE or replace procedure storage_row_link_global_proc_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from dual;
    insert into storage_row_link_global_tbl_000 select i,i,i,'iscmRDs'||j,'OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,1,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',4000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',1000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',1000,'1435764ABC7890abcdef') from dual;
  END LOOP;
END;
/
call storage_row_link_global_proc_000(1,1000);
commit;
DROP TABLE IF EXISTS storage_row_link_global_tbl_001;
create global temporary table storage_row_link_global_tbl_001 as select * from storage_row_link_global_tbl_000;
CREATE UNIQUE INDEX storage_row_link_global_indx_001_1 ON storage_row_link_global_tbl_001(c_id,c_d_id);
CREATE INDEX storage_row_link_global_indx_001_2 ON storage_row_link_global_tbl_001(c_id);
CREATE INDEX storage_row_link_global_indx_001_3 ON storage_row_link_global_tbl_001(c_city);
CREATE INDEX storage_row_link_global_indx_001_4 ON storage_row_link_global_tbl_001(c_first,c_state);
CREATE INDEX storage_row_link_global_indx_001_5 ON storage_row_link_global_tbl_001(c_id,c_d_id,c_middle);
CREATE INDEX storage_row_link_global_indx_001_6 ON storage_row_link_global_tbl_001(c_id,c_d_id,c_middle,c_street_1);
--I2.Update变短，行链接—>普通
insert into storage_row_link_global_tbl_001 select * from storage_row_link_global_tbl_000;
--1000 rows affected.
update storage_row_link_global_tbl_001 set c_d_id=c_d_id+1,c_w_id=c_w_id+1,c_since=sysdate,c_first='aaaaaaa',c_data1='aaaaaaaaaaaa',c_data2='bbbbbbbbbb',c_data3='cccccccccc',c_data4='dddddddddd',c_data5='eeeeeeeeee',c_data6='ffffffffff',c_data7='gggggggggg',c_data8='aaaaaaaaaa',c_text='aaaaaaaaaa',c_clob='1111111111';
--1000 rows affected.
COMMIT;

--DTS2018081506766, migr row
drop table if exists global_strg_func_tbl_000;
create table global_strg_func_tbl_000(c_id int,
c_d_id int NOT NULL,
c_w_id int NOT NULL,
c_first varchar(16) NOT NULL,
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
c_text raw(1000),
c_clob varchar(1000),
primary key (c_id,c_d_id,c_w_id));
insert into global_strg_func_tbl_000 values (1,1,1,'zdftvbktwqmv','OE','BARBARPRES','bmzqwgevtzuky','hwgqmnmedtfzpqdmhkcl','wwlywigjzzgrpo','ew','189611111','3547275456392941','2013-01-04 11:26:41','GC',50000.0,0.24249771,-10.0,10.0,1,false,'2013-01-04 10:26:41','qvldetanrbrburbmzqujshoqnggsmnteccipriirdhirwiynpfzcsykxxyscdsfqafhatdokmjogfgslucunvwbtbfsqzjeclbacpjqdhjchvgbnrkjrgjrycsgppsocnevautzfeosviaxbvobffnjuqhlvnwuqhtgjqsbfacwjpbvpgthpyxcpmnutcjxrbxxbmrmwwxcepwiixvvleyajautcesljhrsfsmsnmzjcxvcuxdwmyijbwywiirsgocwktedbbokhynznceaesuifkgoaafagugetfhbcylksrjukvbufqcvbffaxnzssyquidvwefktknrchyxfphunqktwnipnsrvqswsymocnoexbabwnpmnxsvshdsjhazcauvqjgvqjfkjjgqrceyjmbumkapmcbxeashybpgekjkfezthnjbhfqiwbutbxtkjkndyyhjchvgbnrkjrgjrycsgppsocnevautzfeosviaxbvobf','431543254325636536465390148338192473147389574574295482974528942574827543289574239574239574239857428564236829543295874283574382574238957842357234857482357432985749235845254235425432542354325423454235423542354325432543276576878798026537657368790','qvldetanrbrburbmzqujshoqnggsmnteccipriirdhirwiynpfzcsykxxyscdsfqafhatdokmjogfgslucunvwbtbfsqzjeclbacpjqdhjchvgbnrkjrgjrycsgppsocnevautzfeosviaxbvobffnjuqhlvnwuqhtgjqsbfacwjpbvpgthdaffdafdafdafdasfdbmrmwwxcepwiixvvleyajautcesljhrsfsmsnmzjcxvcuxdwmyijbwywiirsgocwktedbbokhynznceaesuifkgoaafagugetfhbcylksrjukvbufqcvbffaxnzssyquidvwefktknrchyxfphunqktwnipnsrvqswsymocnoexbabwnpmnxsvshdsjhazcauvqjgvqjfkjjgqrceyjmbumkapmcbxeashybpgekjkfezthnjbhfqiwbutbxtkjkndyyhjchvgbnrkjrgjrycsgppsocnevautzfsdfeosviax');
insert into global_strg_func_tbl_000 select c_id+1,c_d_id+1,c_w_id+1,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000 where c_id=1;
insert into global_strg_func_tbl_000 select c_id+1,c_d_id+1,c_w_id+1,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000 where c_id=2;
insert into global_strg_func_tbl_000 select c_id+1,c_d_id+1,c_w_id+1,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000 where c_id=3;
insert into global_strg_func_tbl_000 select c_id+1,c_d_id+1,c_w_id+1,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000 where c_id=4;
insert into global_strg_func_tbl_000 select c_id+1,c_d_id+1,c_w_id+1,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000 where c_id=5;
insert into global_strg_func_tbl_000 select c_id+1,c_d_id+1,c_w_id+1,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000 where c_id=6;
insert into global_strg_func_tbl_000 select c_id+1,c_d_id+1,c_w_id+1,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000 where c_id=7;
insert into global_strg_func_tbl_000 select c_id+1,c_d_id+1,c_w_id+1,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000 where c_id=8;
insert into global_strg_func_tbl_000 select c_id+1,c_d_id+1,c_w_id+1,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000 where c_id=9;
insert into global_strg_func_tbl_000 select c_id+10,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000;
insert into global_strg_func_tbl_000 select c_id+20,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000;
insert into global_strg_func_tbl_000 select c_id+40,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000;
insert into global_strg_func_tbl_000 select c_id+80,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000;
insert into global_strg_func_tbl_000 select c_id+160,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000;
insert into global_strg_func_tbl_000 select c_id+320,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000;
insert into global_strg_func_tbl_000 select c_id+640,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data,c_text,c_clob from global_strg_func_tbl_000;
delete from global_strg_func_tbl_000 where c_id>1000;

drop table if exists global_strg_func_tbl_117;
create global temporary table global_strg_func_tbl_117(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data clob,c_text blob,c_clob clob) on commit preserve rows;

create or replace procedure GLOBAL_ACID_FUNC_117_1(name varchar) is
str varchar(4000);
tablename varchar(200) :=name;
begin
str := 'update' ||' '||tablename||' '||'set c_first=c_first||''aa'',c_data=lpad(''sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm'',500,''yxcfgdsgtcsdsjxrbxxbm''),c_text=lpad(''12432454325654632455425644354325'',450,''7687389015''),c_clob=lpad(''sbfacwjpbvpgthpyxcpmnutcjdfaxrbxxbm'',500,''yxcpmnutcjxrbxxbm'') where mod(c_id,4)=1';
EXECUTE IMMEDIATE str;
end;
/

create or replace procedure GLOBAL_ACID_FUNC_117_2(name varchar) is
str varchar(4000);
tablename varchar(200) :=name;
begin
str := 'update' ||' '||tablename||' '||'set c_first=c_first||''aa'',c_data=lpad(''sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm'',500,''yxcfgdsgtcsdsjxrbxxbm''),c_text=lpad(''12432454325654632455425644354325'',450,''7687389015''),c_clob=lpad(''sbfacwjpbvpgthpyxcpmnutcjdfaxrbxxbm'',500,''yxcpmnutcjxrbxxbm'')';
EXECUTE IMMEDIATE str;
end;
/
CREATE UNIQUE INDEX global_acid_func_indx_117_1 ON global_strg_func_tbl_117(c_id,c_d_id);
CREATE INDEX global_acid_func_indx_117_2 ON global_strg_func_tbl_117(c_id);
CREATE INDEX global_acid_func_indx_117_3 ON global_strg_func_tbl_117(c_city);
CREATE INDEX global_acid_func_indx_117_4 ON global_strg_func_tbl_117(c_first,c_state);
CREATE INDEX global_acid_func_indx_117_5 ON global_strg_func_tbl_117(c_id,c_d_id,c_middle);
CREATE INDEX global_acid_func_indx_117_6 ON global_strg_func_tbl_117(c_id,c_d_id,c_middle,c_street_1);
insert into global_strg_func_tbl_117 select * from global_strg_func_tbl_000;

delete from global_strg_func_tbl_117 where mod(c_id,2)=0;
commit;--begin transaction;
call GLOBAL_ACID_FUNC_117_1('global_strg_func_tbl_117');
select distinct c_first,count(*) from global_strg_func_tbl_117 group by c_first order by 1,2;
savepoint aa;
call GLOBAL_ACID_FUNC_117_2('global_strg_func_tbl_117');
select distinct c_first,count(*) from global_strg_func_tbl_117 group by c_first order by 1,2;
rollback;
select distinct c_first,count(*) from global_strg_func_tbl_117 group by c_first order by 1,2;

DROP TABLE IF EXISTS temp_add_col;
CREATE GLOBAL TEMPORARY TABLE temp_add_col (col1 INTEGER NOT NULL, col2 VARCHAR(32)) ON COMMIT PRESERVE ROWS;
INSERT INTO temp_add_col VALUES (1, 'aaa');
ALTER TABLE temp_add_col ADD col3 BINARY(20) DEFAULT 'abcd';
SELECT col1, col2, IFNULL(col3, 'NULL') FROM temp_add_col;
DROP TABLE temp_add_col;

DROP TABLE IF EXISTS temp_spc_table;
CREATE TABLE temp_spc_table (col1 INTEGER NOT NULL, col2 VARCHAR(32)) tablespace temp;


drop table if exists t1;
create table t1(i int);
drop table if exists temp_001;
create global temporary table temp_001(i int) on commit preserve rows;
create index tmp_ti1 on temp_001(i);
insert into temp_001 values(1);
insert into temp_001 values(1);
insert into t1 values (1);
insert into t1 values (1);
commit;
select * from temp_001;

update temp_001 set i=10;
update t1 set i=10;
select * from temp_001;
select * from t1;
prepare transaction '1.ab.cd';
rollback;
update t1 set i=10;
select * from temp_001;
select * from t1;
prepare transaction '1.ab.cd';
rollback prepared '1.ab.cd';
select * from temp_001;
select * from t1;

delete from temp_001;
delete from t1;
select * from temp_001;
select * from t1;
prepare transaction '1.ab.cd';
rollback;
delete from t1;
select * from temp_001;
select * from t1;
prepare transaction '1.ab.cd';
rollback prepared '1.ab.cd';
select * from temp_001;
select * from t1;

CREATE GLOBAL TEMPORARY TABLE temp_btree (id int, str varchar(96));
CREATE INDEX idx1 ON temp_btree(id);

insert into temp_btree values (0, 'this is a very very long string.this is a very very long string.this is a very very long string.');
insert into temp_btree (id, str) select id + 1, str from temp_btree;
insert into temp_btree (id, str) select id + 2, str from temp_btree;
insert into temp_btree (id, str) select id + 4, str from temp_btree;
insert into temp_btree (id, str) select id + 8, str from temp_btree;
insert into temp_btree (id, str) select id + 16, str from temp_btree;
insert into temp_btree (id, str) select id + 32, str from temp_btree;
insert into temp_btree (id, str) select id + 64, str from temp_btree;
insert into temp_btree (id, str) select id + 128, str from temp_btree;
insert into temp_btree (id, str) select id + 256, str from temp_btree;
insert into temp_btree (id, str) select id + 512, str from temp_btree;
insert into temp_btree (id, str) select id + 1024, str from temp_btree;
insert into temp_btree (id, str) select id + 2048, str from temp_btree;
insert into temp_btree (id, str) select id + 4096, str from temp_btree;
insert into temp_btree (id, str) select id + 8192, str from temp_btree;
drop TEMPORARY table temp_btree;
--DTS2018110103159:btree split and rescan
drop table if exists tt0;
create table tt0(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_unsig tinyint unsigned,c_big bigint,c_vchar varchar2(8000),c_data long,c_text blob,c_clob clob,c_image image,c_binary binary(1000),c_varbinary varbinary(1000),c_raw raw(1000),primary key(c_id,c_d_id,c_w_id));

insert into tt0 select 1,1,1,'AA'||'is1cmvls','OE','AA'||'BAR1BARBAR','bkili'||'1'||'fcxcle'||'1','pmbwo'||'1'||'vhvpaj'||'1','dyf'||'1'||'rya'||'1','uq',4800||'1',940||'1'||205||'1','1800-01-01 10:51:47','GC',50000.0,0.4361328,-10.0,10.0,1,true,'1800-01-01 10:51:47',1,1,lpad('1234ABCDRFGHopqrstuvwxyz8',1500,'ABfgCDefgh'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbxxbm',200,'yxcfgdsgtcjxrbxxbm'),lpad('124324543256546324554354325',200,'7687389015'),lpad('sbfacwjpbvpgthpyxcpmnutcjdfaxrbxxbm',200,'yxcpmnutcjxrbxxbm'),lpad('123dSHGGefasdy',200,'678ASVDFopqrst9234'),lpad('12345abcdegf',200,'adbede1fghij1kLMHG3FFHUK'),lpad('ede1fghij1kLMHG3',200,'xcp2345abcdepmnu'),lpad('1234567890abcdfe',200,'abc1d2fe123895ab456cdef');
commit;
CREATE or replace procedure temp_table_func1(startall int,endall int) as
i INT;
BEGIN
 if startall > endall then
  return;
 else
  FOR i IN startall..endall LOOP
        insert into tt0 select c_id+i,c_d_id+i,c_w_id+i,'AA'||'is'||i||'cmvls',c_middle,'AA'||'BAR'||i||'ddBARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,'940'||i||'205'||i,c_since+i,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end+i,c_unsig+i,c_big+100000*i,c_vchar,c_data,c_text,c_clob,c_image,lpad('12345abcdegf',200,'adbede1fghij'||i||'kLMHG3FFHUK'),lpad('ede1fghij1kLMHG3',200,'xcp23'||i||'45abcdepmnu'),lpad('1234567890abcdfe',200,'abc1d2fe123'||i||'895ab456cdef') from tt0 where c_id=1;commit;
  END LOOP;
  return;
 end if;
END;
/
exec temp_table_func1(1,1999);

drop table if exists tt1;
create table tt1(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_unsig tinyint unsigned,c_big bigint,c_vchar varchar2(8000),c_data long,c_text blob,c_clob clob,c_image image,c_binary binary(1000),c_varbinary varbinary(1000),c_raw raw(1000)) partition by hash(c_w_id,c_last) (partition part_1,partition part_2,partition part_3,partition part_4,partition part_5,partition part_6,partition part_7,partition part_8);

drop table if exists tmp_t;
create global temporary table tmp_t(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_unsig tinyint unsigned,c_big bigint,c_vchar varchar2(8000),c_data long,c_text blob,c_clob clob,c_image image,c_binary binary(1000),c_varbinary varbinary(1000),c_raw raw(1000)) on commit preserve rows;

create unique index ltt_index1 ON tmp_t(c_id,c_d_id);
create index ltt_index2 ON tmp_t(c_id);
create unique index ltt_index3 ON tmp_t(c_big);
create index ltt_index4 ON tmp_t(c_first,c_binary);
create index ltt_index5 ON tmp_t(c_id,c_d_id,c_varbinary);
create index ltt_index6 ON tmp_t(c_id,c_d_id,c_street_1,c_raw);

insert into tt1 select * from tt0 where mod(c_id,2)=1;
select count(*) from tt1;
insert into tmp_t select * from tt0;
select count(*) from tmp_t;

commit;
select count(*) from tt1 a,tmp_t b where a.c_id=b.c_id;

insert into tt1 select a.c_id+1000000,a.c_d_id,a.c_w_id,a.c_first,a.c_middle,a.c_last,a.c_street_1,a.c_street_2,a.c_city,a.c_state,a.c_zip,a.c_phone,a.c_since,a.c_credit,a.c_credit_lim,a.c_discount,a.c_balance,a.c_ytd_payment,a.c_payment_cnt,a.c_delivery_cnt,a.c_end,a.c_unsig,a.c_big+10000000000,a.c_vchar,a.c_data,a.c_text,a.c_clob,a.c_image,a.c_binary,a.c_varbinary,a.c_raw from tt1 a,tmp_t b where a.c_binary=b.c_binary and mod(a.c_id,3)=1 and mod(b.c_d_id,5)=1;

select count(*) from tt1 a,tmp_t b where a.c_id=b.c_id;
select distinct a.c_first,sum(a.c_id) from tt1 a,tmp_t b where a.c_d_id=b.c_d_id and a.c_first='aaaaaaaaaaaa' group by a.c_first order by 1,2;
select distinct c_first,sum(c_id) from tt1 where c_id in (select a.c_id from tt1 a,tmp_t b where a.c_street_1=b.c_street_1 and b.c_first like 'AAis80%') and c_first like 'AAis80%' group by c_first,c_id order by 1,2;
select distinct a.c_first,sum(a.c_id) from tt1 a,tmp_t b where a.c_d_id=b.c_d_id and a.c_first='aaaaaaaaaaaa' and a.c_d_id in (select c_d_id from tt1) group by a.c_first order by 1,2;


update tt1 set c_id=c_id+10000000,c_first='aaaaaaaaaaaa',c_data=lpad('datalong',300,'aystrdatadataopest'),c_text=lpad('11111111111',300,'abcdef2345adb'),c_vchar=lpad('vcharchar',300,'abcdefytsops'),c_image=lpad('image',300,'rstabde1234sopstADCE'),c_binary=lpad('binary',300,'abcdrstyesdd'),c_varbinary=rpad('varbinary',300,'rstuvwopqbn'),c_raw=rpad('abcdef123',300,'11111111122222222') where c_first in(select a.c_first from tt1 a,tmp_t b where a.c_first=b.c_first and a.c_d_id=b.c_d_id and a.c_first like 'AAis1%' and b.c_last like 'AABAR1%');

select count(*) from tt1 a,tmp_t b where a.c_id=b.c_id;
select distinct a.c_first,sum(a.c_id) from tt1 a,tmp_t b where a.c_d_id=b.c_d_id and a.c_first='aaaaaaaaaaaa' group by a.c_first order by 1,2;
select distinct c_first,sum(c_id) from tt1 where c_id in (select a.c_id from tt1 a,tmp_t b where a.c_street_1=b.c_street_1 and b.c_first like 'AAis80%') and c_first like 'AAis80%' group by c_first,c_id order by 1,2;

delete from tt1 where mod(c_id,3)=1 and c_first in (select a.c_first from tt1 a,tmp_t b where a.c_id=b.c_id and mod(a.c_id,3)=mod(b.c_id,2));
select count(*) from tt1 a,tmp_t b where a.c_id=b.c_id;
select distinct a.c_first,sum(a.c_id) from tt1 a,tmp_t b where a.c_d_id=b.c_d_id and a.c_first='aaaaaaaaaaaa' group by a.c_first order by 1,2;
select distinct c_first,sum(c_id) from tt1 where c_id in (select a.c_id from tt1 a,tmp_t b where a.c_street_1=b.c_street_1 and b.c_first like 'AAis80%') and c_first like 'AAis80%' group by c_first,c_id order by 1,2;

commit;
select count(*) from tt1 a,tmp_t b where a.c_id=b.c_id;
insert into tmp_t select b.c_id+1000000,b.c_d_id,b.c_w_id,b.c_first,b.c_middle,b.c_last,b.c_street_1,b.c_street_2,b.c_city,b.c_state,b.c_zip,b.c_phone,b.c_since,b.c_credit,b.c_credit_lim,b.c_discount,b.c_balance,b.c_ytd_payment,b.c_payment_cnt,b.c_delivery_cnt,b.c_end,b.c_unsig,b.c_big+10000000000,b.c_vchar,b.c_data,b.c_text,b.c_clob,b.c_image,b.c_binary,b.c_varbinary,b.c_raw from tt1 a,tmp_t b where a.c_binary=b.c_binary and mod(a.c_id,5)=1 and mod(b.c_d_id,7)=1;

select count(*) from tt1 a,tmp_t b where a.c_id=b.c_id;
select distinct a.c_first,sum(a.c_id) from tt1 a,tmp_t b where a.c_d_id=b.c_d_id and a.c_first='aaaaaaaaaaaa' group by a.c_first order by 1,2;
select distinct c_first,sum(c_id) from tmp_t where c_id in (select b.c_id from tt1 a,tmp_t b where a.c_street_1=b.c_street_1 and a.c_first like 'AAis80%') and c_first like 'AAis80%' group by c_first,c_id order by 1,2;

update tmp_t set c_id=c_id+1000000,c_d_id=c_d_id+1000000,c_first='aaaaaaaaaaaa',c_data=lpad('datalong',300,'aystrdatadataopest'),c_text=lpad('11111111111',300,'abcdef2345adb'),c_vchar=lpad('vcharchar',300,'abcdefytsops'),c_image=lpad('image',300,'rstabde1234sopstADCE'),c_binary=lpad('binary',300,'abcdrstyesdd'),c_varbinary=rpad('varbinary',300,'rstuvwopqbn'),c_raw=rpad('abcdef123',300,'11111111122222222') where c_first in(select b.c_first from tt1 a,tmp_t b where a.c_first=b.c_first and a.c_d_id=b.c_d_id and a.c_first like 'AAis9%') and c_last like 'AABAR9%';

drop table if exists constraint_index_glo_tbl_005;
create global temporary table constraint_index_glo_tbl_005(c_id int, c_d_id int NOT NULL, c_w_id int, c_first varchar(32), c_middle char(2), c_last varchar(32) NOT NULL) on commit preserve rows;
create index glo_tbl_005_index_001 on constraint_index_glo_tbl_005(c_d_id);
alter table constraint_index_glo_tbl_005 add constraint glo_tbl_005_constraint_002 unique(c_d_id);
create unique index glo_tbl_005_index_002 on constraint_index_glo_tbl_005(c_id);
insert into constraint_index_glo_tbl_005 values (1, 2, 3, 'aa', 'bb', 'ccc');
CREATE or replace procedure func005(startall int,endall int) as
i INT;
BEGIN
 if startall > endall then
  return;
 else
  FOR i IN startall..endall LOOP
		insert into constraint_index_glo_tbl_005 select c_id + i * 2,  c_d_id, c_w_id, c_first, c_middle, c_last  from constraint_index_glo_tbl_005 where c_id = 1; commit;
  END LOOP;
  return;
 end if;
END;
/
exec func005(1,200);
insert into constraint_index_glo_tbl_005 select  c_id + 100000,  c_d_id, c_w_id, c_first, c_middle, c_last from constraint_index_glo_tbl_005 where c_id = 1;
insert into constraint_index_glo_tbl_005 select  c_id + 100003,  c_d_id, c_w_id, c_first, c_middle, c_last from constraint_index_glo_tbl_005 where c_id < 999;
drop table constraint_index_glo_tbl_005;

---	DTS2018120417435
alter system set TEMP_BUFFER_SIZE=5;

create user temhz identified by Cantian_234;
GRANT CREATE SESSION TO temhz;
grant dba to temhz;
grant create table to temhz;


alter tablespace USERS autopurge off;purge recyclebin;
drop table if exists temhz.STORAGE_LOB_INLINE_TBL_000;
CREATE TABLE temhz.STORAGE_LOB_INLINE_TBL_000(C_ID INT,
C_D_ID int NOT NULL,
C_W_ID int NOT NULL,
C_FIRST1 VARCHAR(100) NOT NULL,
C_FIRST2 VARCHAR(100) NOT NULL,
C_FIRST3 VARCHAR(100) NOT NULL,
C_FIRST4 VARCHAR(100) NOT NULL,
C_FIRST5 VARCHAR(100) NOT NULL,
C_FIRST6 VARCHAR(100) NOT NULL,
C_FIRST7 VARCHAR(100) NOT NULL,
C_FIRST8 VARCHAR(100) NOT NULL,
C_DATA LONG,
C_TEXT BLOB,
C_CLOB CLOB);
insert into  temhz.STORAGE_LOB_INLINE_TBL_000 values(0,0,0,'AA','BB','CC','DD','EE','FF','GG','HH','LONG','111','CLOB');
commit;
CREATE or replace procedure temhz_lob_inline_func_001(startall int,endall int)  as
i INT;
BEGIN
  FOR i IN startall..endall LOOP
        insert into temhz.STORAGE_LOB_INLINE_TBL_000 select c_id+i,c_d_id+i,c_w_id+i,'AA'||i,'BB'||i,'CC'||i,'DD'||i,'EE'||i,'FF'||i,'GG'||i,'HH'||i,c_data,c_text,c_clob from temhz.STORAGE_LOB_INLINE_TBL_000 where c_id=0;commit;
  END LOOP;
END;
/
call temhz_lob_inline_func_001(1,1000);

alter tablespace USERS autopurge off;
drop table if exists temhz.STORAGE_LOB_INLINE_GOT_004;
CREATE GLOBAL TEMPORARY TABLE temhz.STORAGE_LOB_INLINE_GOT_004(C_ID INT,C_D_ID int NOT NULL,C_W_ID int NOT NULL,C_FIRST1 VARCHAR(8000) NOT NULL,C_FIRST2 VARCHAR(8000) NOT NULL,C_FIRST3 VARCHAR(8000) NOT NULL,C_FIRST4 VARCHAR(8000) NOT NULL,C_FIRST5 VARCHAR(8000) NOT NULL,C_FIRST6 VARCHAR(8000) NOT NULL,C_FIRST7 VARCHAR(8000) NOT NULL,C_FIRST8 VARCHAR(8000) NOT NULL,C_DATA LONG,C_TEXT BLOB,C_CLOB CLOB) on commit preserve rows;

insert into temhz.STORAGE_LOB_INLINE_GOT_004 select C_ID,C_D_ID,C_W_ID,C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,C_DATA,C_TEXT,C_CLOB from temhz.STORAGE_LOB_INLINE_TBL_000 where mod(c_id,3)=0;

insert into temhz.STORAGE_LOB_INLINE_GOT_004 select C_ID,C_D_ID,C_W_ID,lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),C_DATA,C_TEXT,C_CLOB from temhz.STORAGE_LOB_INLINE_TBL_000 where mod(c_id,3)=1;

insert into temhz.STORAGE_LOB_INLINE_GOT_004 select C_ID,C_D_ID,C_W_ID,C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',4000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('123456656565767',4000,'565656576768787'),C_CLOB from temhz.STORAGE_LOB_INLINE_TBL_000 where mod(c_id,3)=2;


commit;

drop user temhz cascade;


--temp table with store procedure
set serveroutput on;
drop table if exists tmp_t10;
create global temporary table tmp_t10(id int);
declare
	cursor c1 is select id from tmp_t10;
	b int;
begin
	insert into tmp_t10(id) values(1);
	insert into tmp_t10(id) values(2);
	open c1;
	fetch c1 into b;
	begin
		dbe_output.print_line(b);
		execute immediate 'truncate table tmp_t10';
	    insert into tmp_t10(id) values(5);
	end;
	fetch c1 into b;
	dbe_output.print_line(b);
	close c1;
end;
/

declare
	cursor c1 is select id from tmp_t10;
	b int;
begin
	insert into tmp_t10(id) values(1);
	insert into tmp_t10(id) values(2);
	open c1;
	fetch c1 into b;
	begin
		dbe_output.print_line(b);
	    insert into tmp_t10(id) values(5);
	end;
	fetch c1 into b;
	dbe_output.print_line(b);
	close c1;
end;
/

declare
	cursor c1 is select id from tmp_t10;
	b int;
begin
	insert into tmp_t10(id) values(1);
	insert into tmp_t10(id) values(2);
	open c1;
	fetch c1 into b;
	begin
		dbe_output.print_line(b);
        delete from tmp_t10;
	end;
	fetch c1 into b;
	dbe_output.print_line(b);
	close c1;
end;
/

drop table if exists tmp_t10;
create global temporary table tmp_t10(id int) on commit preserve rows;
declare
	cursor c1 is select id from tmp_t10;
	b int;
begin
	insert into tmp_t10(id) values(1);
	insert into tmp_t10(id) values(2);
	open c1;
	fetch c1 into b;
	begin
		dbe_output.print_line(b);
		execute immediate 'truncate table tmp_t10';
	    insert into tmp_t10(id) values(5);
	end;
	fetch c1 into b;
	dbe_output.print_line(b);
	close c1;
end;
/

drop table if exists tmp_t10;
create global temporary table tmp_t10(id int) on commit preserve rows;
declare
	cursor c1 is select id from tmp_t10;
	b int;
begin
	insert into tmp_t10(id) values(1);
	insert into tmp_t10(id) values(2);
	open c1;
	fetch c1 into b;
	begin
		dbe_output.print_line(b);
		execute immediate 'drop table tmp_t10';
		execute immediate 'create global temporary table tmp_t10(id int)';
	    insert into tmp_t10(id) values(1);
	end;
	fetch c1 into b;
	dbe_output.print_line(b);
	close c1;
end;
/

drop table if exists tmp_t10;
create global temporary table tmp_t10(id int, name varchar(64));
insert into tmp_t10(id) values(1);
insert into tmp_t10(id) values(2);
savepoint aa;
delete from tmp_t10;
select * from tmp_t10;
insert into tmp_t10(id) values(3);
rollback to savepoint aa;
select * from tmp_t10;

drop table if exists tmp_t10;
create global temporary table tmp_t10(id int, name varchar(64));
create index ti_1 on tmp_t10(name);
create unique index ti_2 on tmp_t10(id);
insert into tmp_t10 values (1,'aa');
savepoint aa;
insert into tmp_t10 values (2,'bb');
insert into tmp_t10 values (2,'bb');
select /* +full(tmp_t10*/ * from tmp_t10;
delete from tmp_t10;
select /* +full(tmp_t10*/ * from tmp_t10;
insert into tmp_t10 values (1,'aa');
insert into tmp_t10 values (2,'bb');
rollback to savepoint aa;
select /* +full(tmp_t10*/ * from tmp_t10;

drop table if exists oracle_insert_dul_dml_tbl_005;
create global temporary table oracle_insert_dul_dml_tbl_005(c_id int,
c_d_id bigint ,
c_w_id tinyint unsigned ,
c_first varchar(16) ,
c_middle char(2),
c_last varchar(16) ,
c_street_1 varchar(20) ,
c_street_2 varchar(20),
c_city varchar(20) ,
c_state char(2) ,
c_zip char(9) ,
c_phone char(16) ,
c_since timestamp,
c_credit char(2) ,
c_credit_lim numeric(12,2),
c_discount numeric(4,4),
c_balance numeric(12,2),
c_ytd_payment real ,
c_payment_cnt number ,
c_delivery_cnt bool ,
c_end date ,
c_data1 varchar(8000),
c_data2 varchar(8000),
c_data3 varchar(8000),
c_data4 varchar(8000),
c_data5 varchar(8000),
c_data6 varchar(8000),
c_data7 varchar(8000),
c_data8 varchar(8000),
c_clob clob,
c_blob blob,
add_varchar2_289 varchar2(100) default 'a');
CREATE INDEX oracle_insert_dul_dml_tbl_005_indx_1 ON oracle_insert_dul_dml_tbl_005(to_char(c_first),upper(c_since));
CREATE INDEX oracle_insert_dul_dml_tbl_005_indx_3 ON oracle_insert_dul_dml_tbl_005(to_char(c_since));
CREATE INDEX oracle_insert_dul_dml_tbl_005_indx_4 ON oracle_insert_dul_dml_tbl_005(upper(c_first),c_state);
CREATE INDEX oracle_insert_dul_dml_tbl_005_indx_5 ON oracle_insert_dul_dml_tbl_005(c_id,c_d_id,c_since);
CREATE INDEX oracle_insert_dul_dml_tbl_005_indx_6 ON oracle_insert_dul_dml_tbl_005(c_id,c_d_id,c_middle,c_street_1);
--#lob<4k,row size>64k --#lob<4k,row size<64k  --#lob<4k row_size<8k
CREATE or replace procedure oracle_insert_dul_dml_tbl_005_proc(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from dual;
    --if mod(i,3)=0 then
    --insert into oracle_insert_dul_dml_tbl_005(c_id,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data1,c_data2,c_data3,c_data4,c_data5,c_data6,c_data7,c_data8,c_clob,c_blob) select i,i,i,'is'||j||'cmRDs','OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate+i,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate+i,lpad('aaa',5000,'bbb'),lpad('aaa',5000,'bbb'),lpad('aaa',5000,'bbb'),lpad('aaa',8000,'bbb'),lpad('aaa',8000,'bbb'),lpad('aaa',8000,'bbb'),lpad('aaa',8000,'bbb'),lpad('aaa',8000,'bbb'),lpad('aaa',3000,'bbb'),lpad('111',3000,'222') from dual;
   --elsif mod(i,3)=1 then
   --insert into oracle_insert_dul_dml_tbl_005(c_id,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data1,c_data2,c_data3,c_data4,c_data5,c_data6,c_data7,c_data8,c_clob,c_blob) select i,i,i,'is'||j||'cmRDs','OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate+i,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate+i,lpad('aaa',5000,'bbb'),lpad('aaa',5000,'bbb'),lpad('aaa',5000,'bbb'),lpad('aaa',5000,'bbb'),lpad('aaa',5000,'bbb'),lpad('aaa',5000,'bbb'),lpad('aaa',5000,'bbb'),lpad('aaa',5000,'bbb'),lpad('aaa',3000,'bbb'),lpad('111',3000,'222') from dual;
  --else
   insert into oracle_insert_dul_dml_tbl_005(c_id,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data1,c_data2,c_data3,c_data4,c_data5,c_data6,c_data7,c_data8,c_clob,c_blob) select i,i,i,'is'||j||'cmRDs','OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate+i,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate+i,lpad('aaa',5,'bbb'),lpad('aaa',5,'bbb'),lpad('aaa',5,'bbb'),lpad('aaa',5,'bbb'),lpad('aaa',5,'bbb'),lpad('aaa',5,'bbb'),lpad('aaa',5,'bbb'),lpad('aaa',5,'bbb'),lpad('aaa',5,'bbb'),lpad('111',5,'222') from dual;
  --end if;
  END LOOP;
END;
/
call oracle_insert_dul_dml_tbl_005_proc(1,100);
commit;
alter table oracle_insert_dul_dml_tbl_005 add constraint oracle_insert_dul_dml_tbl_003_con_1 primary key(c_id,c_first,c_end);
insert into oracle_insert_dul_dml_tbl_005(c_id,c_first,c_end,c_data1,c_data2,c_data3,c_data4,c_data5,c_data6,c_data7,c_data8,c_clob,c_blob) values(1,'is1cmRDs',to_date('2018-01-01 12:00:00','yyyy-mm-dd hh24:mi:ss'),lpad('data1',5,'data1'),lpad('data2',5,'data2'),lpad('data3',5,'data3'),lpad('data4',5,'data4'),lpad('data5',5,'data5'),lpad('data6',5,'data6'),lpad('data7',5,'data7'),lpad('data8',5,'data8'),lpad('clob',5,'clob'),lpad('b12345',5,'b12345')) on duplicate key update c_id=c_id+1000,c_first=c_first||c_id,c_end=c_end-1000,c_data1=lpad('data1',10,'data1'),c_data2=lpad('data2',10,'data2'),c_data3=lpad('data3',10,'data3'),c_data4=lpad('data4',10,'data4'),c_data5=lpad('data5',10,'data5'),c_data6=lpad('data6',10,'data6'),c_data7=lpad('data7',10,'data7'),c_data8=lpad('data8',10,'data8'),c_clob=lpad('clob',4000,'clob'),c_blob=lpad('111',10,'b');
insert into oracle_insert_dul_dml_tbl_005(c_id,c_first,c_end,c_data1,c_data2,c_data3,c_data4,c_data5,c_data6,c_data7,c_data8,c_clob,c_blob) values(1,'is1cmRDs',to_date('2018-01-01 12:00:00','yyyy-mm-dd hh24:mi:ss'),lpad('data1',5,'data1'),lpad('data2',5,'data2'),lpad('data3',5,'data3'),lpad('data4',5,'data4'),lpad('data5',5,'data5'),lpad('data6',5,'data6'),lpad('data7',5,'data7'),lpad('data8',5,'data8'),lpad('clob',5,'clob'),lpad('b12345',5,'b12345')) on duplicate key update c_id=c_id+1000,c_first=c_first||c_id,c_end=c_end-1000,c_data1=lpad('data1',10,'data1'),c_data2=lpad('data2',10,'data2'),c_data3=lpad('data3',10,'data3'),c_data4=lpad('data4',10,'data4'),c_data5=lpad('data5',10,'data5'),c_data6=lpad('data6',10,'data6'),c_data7=lpad('data7',10,'data7'),c_data8=lpad('data8',10,'data8'),c_clob=lpad('clob',4000,'clob'),c_blob=lpad('111',10,'b');
update oracle_insert_dul_dml_tbl_005 set c_id=c_id+1000,c_first=c_first||c_id,c_end=c_end-1000,c_data1=lpad('data1',10,'data1'),c_data2=lpad('data2',10,'data2'),c_data3=lpad('data3',10,'data3'),c_data4=lpad('data4',10,'data4'),c_data5=lpad('data5',10,'data5'),c_data6=lpad('data6',10,'data6'),c_data7=lpad('data7',10,'data7'),c_data8=lpad('data8',10,'data8'),c_clob=lpad('clob',10,'clob'),c_blob=lpad('111',10,'b');

--test temp table batch update of primary key 
drop table if exists test_temp_pk;
create global temporary table test_temp_pk(id int primary key, val varchar(10)) on commit preserve rows;
insert into test_temp_pk values(1, 'a'), (2, 'b'), (6, 'c'), (10, 'd'), (50, 'e');
commit;
update test_temp_pk set id = id+1 where id<3;
update test_temp_pk set id = id+1 where id<10;
select * from test_temp_pk order by id;
update test_temp_pk set id = id - 1 where id > 3;
update test_temp_pk set id = id - 1;
update test_temp_pk set id = id - 1;
select * from test_temp_pk order by id;
rollback;
drop table test_temp_pk;

drop table if exists test_temp_pk;
create global temporary table test_temp_pk(id int, val varchar(10));
create unique index idx_test_pk on test_temp_pk(id) crmode row;
insert into test_temp_pk values(1, 'a'), (2, 'b'), (3, 'c'), (4, 'd'), (5, 'e');
update test_temp_pk set id = id+1 where id<3;
update test_temp_pk set id = id+1 where id<10;
select * from test_temp_pk order by id;
update test_temp_pk set id = id - 1 where id > 3;
update test_temp_pk set id = id - 1;
update test_temp_pk set id = id - 1;
select * from test_temp_pk order by id;
rollback;
drop table test_temp_pk;

alter system set local_temporary_table_enabled=true;
create temporary table if not exists #tmp (id int primary key);
insert into #tmp values (1), (2), (3), (4);
update #tmp set id = id+1 where id<3;
update #tmp set id = id+1 where id<10;
select * from #tmp order by id;
update #tmp set id = id - 1 where id > 3;
update #tmp set id = id - 1;
update #tmp set id = id - 1;
select * from #tmp order by id;
drop table #tmp;
alter system set local_temporary_table_enabled=false;

drop table if exists t1;
create global temporary table t1(id int auto_increment primary key, name varchar(32)) on commit preserve rows;
select * from t1;
insert into t1(name) values ('aa');
insert into t1(name) values ('bb');
insert into t1(name) values ('cc');
select * from t1;
truncate table t1;
insert into t1(name) values ('aa');
insert into t1(name) values ('bb');
insert into t1(name) values ('cc');
select * from t1;
drop table if exists t2;
create global temporary table t2(id int auto_increment primary key, name varchar(32));
insert into t2(name) values ('aa');
insert into t2(name) values ('bb');
select * from t2;
truncate table t2;
insert into t2(name) values ('aa');
insert into t2(name) values ('bb');
select * from t2;
drop table if exists t3;
create global temporary table t3(id int primary key, name varchar(32)) on commit preserve rows;
insert into t3 values (1,'aa');
insert into t3 values (2,'bb');
ALTER TABLE T3 MODIFY ID AUTO_INCREMENT;
delete from t3;
ALTER TABLE T3 MODIFY ID BIGINT;
truncate table t3;
insert into t3(name) values ('aa');
insert into t3(name) values ('bb');
insert into t3(name) values ('cc');
select * from t3;
drop table t1;
drop table t2;
drop table t3;
drop table if exists META_ENUM1;
CREATE global TEMPORARY TABLE META_ENUM1
(
 ID1 int AUTO_INCREMENT,
 ID2 int NOT NULL,
 PRIMARY KEY (ID1)
)AUTO_INCREMENT=100;
insert into META_ENUM1(id2) values(1);
insert into META_ENUM1(id2) values(1);
select * from meta_enum1;
truncate table meta_enum1;
insert into META_ENUM1(id2) values(1);
insert into META_ENUM1(id2) values(1);
select * from meta_enum1;
DROP TABLE IF EXISTS META_ENUM;
CREATE global TEMPORARY TABLE IF NOT EXISTS META_ENUM
(
 ID int NOT NULL AUTO_INCREMENT,
 NAME VARCHAR(60) NOT NULL,
 PRIMARY KEY (ID,NAME)
)AUTO_INCREMENT=1000;

insert into META_ENUM(ID,NAME) values(10,1);
insert into META_ENUM(NAME) values(2);
insert into META_ENUM(NAME) values(3);
insert into META_ENUM(ID,NAME) values(4,4);
insert into META_ENUM(NAME) values(5);
select * from META_ENUM order by name;
drop table META_ENUM1;
drop table META_ENUM;
drop table if exists tmp_t11;
create global temporary table tmp_t11(id int, name varchar(32)) on commit preserve rows;
insert into tmp_t11 values (1,'aaaaaaaa');
insert into tmp_t11 values (2,'bbbbbbbb');
insert into tmp_t11 values (3,'ccccccccc');
insert into tmp_t11 values (4,'ddddddd');
insert into tmp_t11 values (5,'eeeeeeeee');
select * from tmp_t11 where rowid in (select rowid from tmp_t11 limit 2);
select * from tmp_t11 where rowid='000099999900000000';
--select * from tmp_t11 where rowid='000000000199999999';
drop table tmp_t11;

drop table if exists  PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010;
create GLOBAL TEMPORARY table PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_unsig tinyint unsigned,c_big bigint,c_vchar varchar2(8000),c_data long,c_text blob,c_clob clob,c_image image,c_binary binary(1000),c_varbinary varbinary(1000),c_raw raw(1000),primary key(c_id,c_d_id,c_w_id)) ON COMMIT DELETE rows;

CREATE or replace procedure PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PRO_010(startall int,endall int) as
i INT;
m int;
f_start timestamp;
f_end timestamp;
f_interval INTERVAL DAY(7) TO SECOND(6);
BEGIN
    delete from PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010;

    FOR a in 1..120 LOOP
        insert into PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010 select 1,1,1,'AA'||'is1cmvls','OE','AA'||'BAR1BARBAR','bkili'||'1'||'fcxcle'||'1','pmbwo'||'1'||'vhvpaj'||'1','dyf'||'1'||'rya'||'1','uq',4800||'1',940||'1'||205||'1','1800-01-01 10:51:47','GC',50000.0,0.4361328,-10.0,10.0,1,true,'1800-01-01 10:51:47',1,1,lpad('1234ABCDRFGHopqrstuvwxyz8',1500,'ABfgCDefgh'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbxxbm',200,'yxcfgdsgtcjxrbxxbm'),lpad('124324543256546324554354325',200,'7687389015'),lpad('sbfacwjpbvpgthpyxcpmnutcjdfaxrbxxbm',200,'yxcpmnutcjxrbxxbm'),lpad('123dSHGGefasdy',200,'678ASVDFopqrst9234'),lpad('12345abcdegf',200,'adbede1fghij1kLMHG3FFHUK'),lpad('ede1fghij1kLMHG3',200,'xcp2345abcdepmnu'),lpad('1234567890abcdfe',200,'abc1d2fe123895ab456cdef');

       select count(*) into m from (select distinct c_id from PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010);

     dbe_output.print_line(m);

        select sysdate into f_start from dual;

        FOR i IN startall..endall LOOP
            insert into PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010 select c_id+i,c_d_id+i,c_w_id+i,'AA'||'is'||i||'cmvls',c_middle,'AA'||'BAR'||i||'ddBARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,'940'||i||'205'||i,c_since+i,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end+i,c_unsig+i,c_big+100000*i,c_vchar,c_data,c_text,c_clob,c_image,lpad('12345abcdegf',200,'adbede1fghij'||i||'kLMHG3FFHUK'),lpad('ede1fghij1kLMHG3',200,'xcp23'||i||'45abcdepmnu'),lpad('1234567890abcdfe',200,'abc1d2fe123'||i||'895ab456cdef') from PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010 where c_id=1;
        END LOOP;
     update PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010 set c_first='qwertyuityuiopasdfghjkl',c_street_1='qwertyuityu',c_last='qwertyuityuiopasdfghjklwertyuityuiopasdfg' where rowid>10;

       select count(*) into m from (select c_id from PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010);
     dbe_output.print_line(m);

     update PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010 set c_first='qwert',c_street_1='qwerty',c_last='qwertyuityuio' where rowid>10000;

     delete from PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010;

  select sysdate into f_end from dual;

 -- dbe_output.print_line(f_end - f_start);
  END LOOP;
END;
/
SET serveroutput ON;

select count(*) c_id from PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010;

call PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PRO_010(1,1);

call PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PRO_010(1,10);

call PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PRO_010(1,100);

drop table PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_010;

drop table if exists delete_left_join_temptb_001;
drop table if exists delete_left_join_temptb_006;
create table delete_left_join_temptb_001(i int not null,j int,k varchar(15));
create GLOBAL TEMPORARY table delete_left_join_temptb_006(i int,j int,k varchar(15));
insert into delete_left_join_temptb_001 values(1,1,'abc');
insert into delete_left_join_temptb_001 values(1,1,'abc');
insert into delete_left_join_temptb_001 values(1,1,'abc');
insert into delete_left_join_temptb_001 values(1,1,'abcdefg');
insert into delete_left_join_temptb_001 values(1,1,'abcdefg');
insert into delete_left_join_temptb_001 values(1,1,'abcdefg lmn');
insert into delete_left_join_temptb_001 values(1,1,'abcdefg lmn');
insert into delete_left_join_temptb_001 values(10,16,'abcdefg');
insert into delete_left_join_temptb_001 values(11,17,'abcdefg');
insert into delete_left_join_temptb_001 values(12,18,'abcdefg');
insert into delete_left_join_temptb_006 values(1,1,'abc');
insert into delete_left_join_temptb_006 values(1,1,'abc');
insert into delete_left_join_temptb_006 values(1,1,'abc');
insert into delete_left_join_temptb_006 values(1,1,'abcdefg');
insert into delete_left_join_temptb_006 values(1,2,'abcdefg');
insert into delete_left_join_temptb_006 values(1,1,'abc hijk');
insert into delete_left_join_temptb_006 values(1,1,'abcdefg hijk');
insert into delete_left_join_temptb_006 values(8,14,'abcdefg');
insert into delete_left_join_temptb_006 values(9,15,'abc23');
delete a from delete_left_join_temptb_001 a left join delete_left_join_temptb_006 b on (a.i=b.i or a.j=b.j ) and a.k=b.k;
drop table if exists delete_left_join_temptb_001;
drop table if exists delete_left_join_temptb_006;

drop table if exists rm_temp_table;
create global temporary table rm_temp_table (id int);

drop sequence if exists rm_temp_seq;
create sequence rm_temp_seq start with 1 maxvalue 20 increment by 1 cycle cache 5;

insert into rm_temp_table values(rm_temp_seq.nextval);
insert into rm_temp_table values(rm_temp_seq.nextval);
insert into rm_temp_table values(rm_temp_seq.nextval);
insert into rm_temp_table values(rm_temp_seq.nextval);
insert into rm_temp_table values(rm_temp_seq.nextval);
insert into rm_temp_table values(rm_temp_seq.nextval);
insert into rm_temp_table values(rm_temp_seq.nextval);
insert into rm_temp_table values(rm_temp_seq.nextval);
insert into rm_temp_table values(rm_temp_seq.nextval);
insert into rm_temp_table values(rm_temp_seq.nextval);

select * from rm_temp_table;
commit;
select * from rm_temp_table;

drop table if exists rm_temp_table;
drop sequence if exists rm_temp_seq;

drop table if  exists test_auto_increment;
create global temporary table test_auto_increment(a int primary key auto_increment);
alter table test_auto_increment auto_increment=2;
drop table if  exists test_auto_increment;

drop table if exists test_desc_order;
drop index if exists idx on test_desc_order;
create global temporary table test_desc_order(a char(3000));
create index idx on test_desc_order(a);

declare
    i int := 0;
begin
    for i in 1..50 loop
        insert into test_desc_order values (i);
    end loop;
end;
/

select * from test_desc_order where a = 50 order by a desc;
drop index if exists idx on test_desc_order;
drop table if exists test_desc_order;

drop table if exists test_create_as_tt1;
drop table if exists test_create_as_tt2;
create table test_create_as_tt1(a int);
insert into test_create_as_tt1 values (10);
create table test_create_as_tt2(a int);
insert into test_create_as_tt2 values (20);
create table test_create_as_tt2 as select * from test_create_as_tt1;
create table if not exists test_create_as_tt2 as select * from test_create_as_tt1;
select * from test_create_as_tt2;
alter system set LOCAL_TEMPORARY_TABLE_ENABLED=true;
drop table if exists #test_create_as_tt1;
drop table if exists #test_create_as_tt2;
create temporary table #test_create_as_tt1(a int);
insert into #test_create_as_tt1 values (10);
create temporary table #test_create_as_tt2(a int);
insert into #test_create_as_tt2 values (20);
create temporary table #test_create_as_tt2 as select * from test_create_as_tt1;
create temporary table if not exists #test_create_as_tt2 as select * from #test_create_as_tt1;
select * from #test_create_as_tt2;

connect sys/Huawei@123@127.0.0.1:1611
drop user if exists liu_temp_1 cascade;
drop user if exists liu_temp_2 cascade;
create user liu_temp_1 identified by Lh00420062;
create user liu_temp_2 identified by Lh00420062;
grant dba to liu_temp_1;
grant dba to liu_temp_2;
alter system set LOCAL_TEMPORARY_TABLE_ENABLED=true;
create temporary table liu_temp_1.#tmp(a int, b varchar(100));
insert into liu_temp_1.#tmp values(10001,'var101sql');
alter system set LOCAL_TEMPORARY_TABLE_ENABLED=false;
connect liu_temp_2/Lh00420062@127.0.0.1:1611
insert into liu_temp_1.#tmp values(10001,'var101sql');
connect sys/Huawei@123@127.0.0.1:1611
drop user if exists liu_temp_1 cascade;
drop user if exists liu_temp_2 cascade;drop table if exists test_desc_order;

drop table if exists temp_num;
create GLOBAL TEMPORARY table temp_num(id decimal primary key);
insert into temp_num values(1000805);
select id from temp_num where id=1000805;
drop table temp_num;

alter database datafile 1 autoextend on maxsize 1G;
select DISK_EXTENTS from dv_temp_pools;


create tablespace nologging_spc datafile ' nologging_extent_dynamic' size 128M nologging;
CREATE TABLESPACE spc_encrypt DATAFILE 'spc_encrypt_1' size 128M nologging encryption;
drop table if exists temp_table;
create global temporary table temp_table (i int) tablespace temp2;
create global temporary table temp_table (i int) tablespace nologging_spc;
create global temporary table temp_table (i int) tablespace spc_encrypt;
create global temporary table temp_table (i int) tablespace temp;
create index idx_tmp on temp_table(i) tablespace temp;
drop index idx_tmp on temp_table;
create index idx_tmp on temp_table(i) tablespace nologging_spc;
create index idx_tmp on temp_table(i) tablespace spc_encrypt;
create index idx_tmp on temp_table(i) tablespace temp2;
create index idx_tmp on temp_table(i) tablespace temp;
alter index idx_tmp on temp_table rebuild tablespace temp2;
alter index idx_tmp on temp_table rebuild tablespace nologging_spc;
alter index idx_tmp on temp_table rebuild tablespace temp;
alter index idx_tmp on temp_table rebuild tablespace spc_encrypt;
drop table temp_table;
drop tablespace nologging_spc;
drop tablespace spc_encrypt;