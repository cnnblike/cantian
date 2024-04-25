drop user if exists wanggang cascade;
create user wanggang identified by 'Changeme_123';
grant dba to wanggang;
conn wanggang/Changeme_123@127.0.0.1:1611

drop table if exists test_a;
create table test_a(f1 int[]);
insert into test_a values('{1,2,3}');
commit;
select SEGMENT_NAME,SEGMENT_TYPE,BYTES,PAGES,EXTENTS from my_segments where SEGMENT_NAME like '%TEST_A%' order by SEGMENT_NAME; -- actual size is 16 + 3 * 16 + 3 * 4 = 76byte, occupy 192k in lob space before enable ARRAY_STORAGE_OPTIMIZATION  

alter system set ARRAY_STORAGE_OPTIMIZATION = FALSE;
show parameter ARRAY_STORAGE_OPTIMIZATION
alter system set ARRAY_STORAGE_OPTIMIZATION = false;
show parameter ARRAY_STORAGE_OPTIMIZATION
alter system set ARRAY_STORAGE_OPTIMIZATION = TRUE;
show parameter ARRAY_STORAGE_OPTIMIZATION
alter system set ARRAY_STORAGE_OPTIMIZATION = true;
show parameter ARRAY_STORAGE_OPTIMIZATION
alter system set ARRAY_STORAGE_OPTIMIZATION = false;
show parameter ARRAY_STORAGE_OPTIMIZATION
alter system set ARRAY_STORAGE_OPTIMIZATION = FALSE;
show parameter ARRAY_STORAGE_OPTIMIZATION
alter system set ARRAY_STORAGE_OPTIMIZATION = 0;

drop table if exists test_b;
create table test_b as select * from test_a;
drop table if exists test_c;
create table test_c(f1 int[]);
insert into test_c (select * from test_a);
commit;

select SEGMENT_NAME,SEGMENT_TYPE,BYTES,PAGES,EXTENTS from my_segments where SEGMENT_NAME like '%TEST_%' order by SEGMENT_NAME; -- actual size is 16 + 3 * 16 + 3 * 4 = 76byte, occupy 0 in lob space after enable ARRAY_STORAGE_OPTIMIZATION
select * from test_a;
select * from test_b;
select * from test_c;

drop table if exists t_arr1;
drop table if exists t_arr1_bk;
create table t_arr1(f1 int[]);
insert into t_arr1 values(array[1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0]);
select SEGMENT_NAME,SEGMENT_TYPE,BYTES,PAGES,EXTENTS from my_segments where SEGMENT_NAME like '%T_ARR1%' order by SEGMENT_NAME; -- actual size is 16 + 100 * 16 + 100 * 4 = 2016 < 4K , inline lob
update t_arr1 set f1[101:200] = f1[1:100];
update t_arr1 set f1[201:400] = f1[1:200];
update t_arr1 set f1[401:800] = f1[1:400];
update t_arr1 set f1[801:1600] = f1[1:800];
update t_arr1 set f1[1601:3200] = f1[1:1600];
update t_arr1 set f1[3201:6400] = f1[1:3200];
update t_arr1 set f1[6401:8100] = f1[1:1700];
select f1[8099] from (select f1 from t_arr1); -- trig memmove_s in sql_mv_arr_ele_between_two_vm
update t_arr1 set f1[8101:8190] = f1[1:90];
update t_arr1 set f1[8191:8191] = f1[1:1];
update t_arr1 set f1[8192:8192] = f1[2:2];
update t_arr1 set f1[8193:16382] = f1[3:8192];
update t_arr1 set f1[16383:16383] = f1[3:3];
update t_arr1 set f1[16384:16390] = f1[4:10];
update t_arr1 set f1[16391:26390] = f1[1:10000];
commit;
create table t_arr1_bk as select * from t_arr1;

drop table if exists t_arr2;
drop table if exists t_arr2_bk;
create table t_arr2(f1 varchar(8000)[]);
insert into t_arr2 values(array['1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890','1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890','1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890','1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890','1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890','1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890','1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890','1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890','1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890','1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890']);
update t_arr2 set f1[11:20] = f1[1:10];
update t_arr2 set f1[21:40] = f1[1:20];
update t_arr2 set f1[41:80] = f1[1:40];
select SEGMENT_NAME,SEGMENT_TYPE,BYTES,PAGES,EXTENTS from my_segments where SEGMENT_NAME like '%T_ARR2%' order by SEGMENT_NAME; -- actual size is 16 + 80 * 16 + 100 * 80 = 9296 > 4K , outline lob
update t_arr2 set f1[81:160] = f1[1:80];
update t_arr2 set f1[161:320] = f1[1:160];
update t_arr2 set f1[321:640] = f1[1:320];
update t_arr2 set f1[641:1200] = f1[1:560];
update t_arr2 set f1[1201:2400] = f1[1:1200];
update t_arr2 set f1[2401:4000] = f1[1:1600];
commit;
create table t_arr2_bk as select * from t_arr2;

drop table if exists t_arr_null;
drop table if exists t_arr_null_bk;
create  table t_arr_null(f1 int[]);
insert into t_arr_null values(array[NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL]);
update t_arr_null set f1[101:200] = f1[1:100];
update t_arr_null set f1[201:400] = f1[1:200];
update t_arr_null set f1[401:800] = f1[1:400];
update t_arr_null set f1[801:1600] = f1[1:800];
update t_arr_null set f1[1601:3200] = f1[1:1600];
commit;