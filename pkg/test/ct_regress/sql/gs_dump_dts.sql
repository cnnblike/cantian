conn sys/Huawei@123@127.0.0.1:1611
-- DTS202102020GQ0NOP0F00
drop table if exists dump_file;
create table dump_file
(
    f1 int not null, 
    f2 real, 
    f3 number, 
    f4 TIMESTAMP WITH LOCAL TIME ZONE,
    f5 TIMESTAMP WITH TIME ZONE,
    f6 date, 
    f7 timestamp
) 
PARTITION BY RANGE(f1)
(
    PARTITION part1 values less than(10),
    PARTITION part2 values less than(20),
    PARTITION part3 values less than(30),
    PARTITION part4 values less than(MAXVALUE)
);

LOAD DATA INFILE './data/dump_file_33M.DAT'  INTO TABLE dump_file;
select count(*) from dump_file;
dump TABLE dump_file into file 'dump.DAT' FILE SIZE '8b';
dump TABLE dump_file into file 'dump.DAT' FILE SIZE '-3';
dump TABLE dump_file into file 'dump_14M.DAT' FILE SIZE ' 14M ';
truncate table dump_file;
LOAD DATA INFILE 'dump_14M.DAT'  INTO TABLE dump_file;
LOAD DATA INFILE 'dump_14M.DAT_1'  INTO TABLE dump_file;
LOAD DATA INFILE 'dump_14M.DAT_2'  INTO TABLE dump_file;
select count(*) from dump_file;
dump TABLE dump_file into file 'dump_16M.DAT' FILE SIZE '16M';
truncate table dump_file;
LOAD DATA INFILE 'dump_16M.DAT'  INTO TABLE dump_file;
LOAD DATA INFILE 'dump_16M.DAT_1'  INTO TABLE dump_file;
LOAD DATA INFILE 'dump_16M.DAT_2'  INTO TABLE dump_file;
select count(*) from dump_file;
dump TABLE dump_file into file 'dump_16.3M.DAT' FILE SIZE '16.3M';
truncate table dump_file;
LOAD DATA INFILE 'dump_16.3M.DAT'  INTO TABLE dump_file;
LOAD DATA INFILE 'dump_16.3M.DAT_1'  INTO TABLE dump_file;
LOAD DATA INFILE 'dump_16.3M.DAT_2'  INTO TABLE dump_file;
select count(*) from dump_file;
drop table if exists dump_file;

drop table if exists test_table;
drop table if exists "test_table_new";
create table test_table (a int ,b varchar(10));
insert into  test_table values(1,'cantian1');
insert into  test_table values(2,'cantian2');
insert into  test_table values(3,'cantian3');
insert into  test_table values(4,'cantian4');
insert into  test_table values(5,'cantian5');
insert into  test_table values(6,'cantian6');
insert into  test_table values(7,'cantian7');
insert into  test_table values(8,'cantian8');
insert into  test_table values(9,'cantian9');
insert into  test_table values(10,'cantian10');
commit;
dump table test_table INTO FILE "case_tbl_hash";
create table "test_table_new" ("a" int ,"b" varchar(10),"c" varchar(10));

load data infile "case_tbl_hash" into table "test_table_new" trailing columns(a,b) SET c ='good';
load data infile "case_tbl_hash" into table "test_table_new" trailing columns("a","b") SET c ='good';
load data infile "case_tbl_hash" into table "test_table_new" trailing columns("a","b") SET "c" ='good';
select count(*) from "test_table_new";
drop table if exists test_table;
drop table if exists "case_tbl_hash";
