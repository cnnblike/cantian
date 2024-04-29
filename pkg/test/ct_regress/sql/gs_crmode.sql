-- table with crmode row and index with different crmode
create table crmode_tb1 (a int, b int, c int, d int, e int , f int) crmode row;
create index crmode_idx1 on crmode_tb1(a);
create index crmode_idx2 on crmode_tb1(b) crmode row;
create index crmode_idx3 on crmode_tb1(c) crmode page;

select cr_mode from all_tables where table_name = 'CRMODE_TB1';
select cr_mode from all_indexes where index_name = 'CRMODE_IDX1';
select cr_mode from all_indexes where index_name = 'CRMODE_IDX2';
select cr_mode from all_indexes where index_name = 'CRMODE_IDX3';

insert into crmode_tb1 values(1,1,1,1,1,1);
insert into crmode_tb1 values(2,2,2,2,2,2);
insert into crmode_tb1 values(3,3,3,3,3,3);

select * from crmode_tb1 where a = 1;
select * from crmode_tb1 where b = 2;
select * from crmode_tb1 where c = 3;

create index crmode_idx4 on crmode_tb1(d);
create index crmode_idx5 on crmode_tb1(e) crmode row;
create index crmode_idx6 on crmode_tb1(f) crmode page;

-- table with crmode page and index with different crmode
create table crmode_tb2 (a int, b int, c int, d int, e int ,f int) crmode page;
create index crmode_idx7 on crmode_tb2(a);
create index crmode_idx8 on crmode_tb2(b) crmode row;
create index crmode_idx9 on crmode_tb2(c) crmode page;

select cr_mode from all_tables where table_name = 'CRMODE_TB2';
select cr_mode from all_indexes where index_name = 'CRMODE_IDX4';
select cr_mode from all_indexes where index_name = 'CRMODE_IDX5';
select cr_mode from all_indexes where index_name = 'CRMODE_IDX6';

insert into crmode_tb2 values(1,1,1,1,1,1);
insert into crmode_tb2 values(2,2,2,2,2,2);
insert into crmode_tb2 values(3,3,3,3,3,3);

select * from crmode_tb2 where a = 1;
select * from crmode_tb2 where b = 2;
select * from crmode_tb2 where c = 3;

create index crmode_idx10 on crmode_tb2(d);
create index crmode_idx11 on crmode_tb2(e) crmode row;
create index crmode_idx12 on crmode_tb2(f) crmode page;
-- verify crmode of primary key 
create table crmode_tb3 (id int primary key) crmode row;
create table crmode_tb4 (id int primary key) crmode page;

-- verify add contraints 
create table crmode_tb5 (a int) crmode page;
alter table crmode_tb5 add constraint crmode_cons unique(a) using index(create unique index crmode_idx13 on crmode_tb5(a) crmode page);

drop table crmode_tb1;
drop table crmode_tb2;
drop table crmode_tb3;
drop table crmode_tb4;
drop table crmode_tb5;

