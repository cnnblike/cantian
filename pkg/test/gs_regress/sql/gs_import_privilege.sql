-- import other user need dba role
-- create user
drop user if exists test_common cascade;
create user test_common identified by Test_123456;
grant create session to test_common;
grant create table to test_common;
grant insert any table to test_common;
grant select any table to test_common;

drop user if exists test_dba cascade;
create user test_dba identified by Test_123456;
grant dba to test_dba;

drop user if exists test_all_privilege cascade;
create user test_all_privilege identified by Test_123456;
grant all to test_all_privilege;

-- create table
conn test_common/Test_123456@127.0.0.1:1611
create table test_common_table(c int);
insert into test_common_table values(1),(2);
select * from test_common_table order by c asc;
commit;

-- exp users : test_common
conn sys/Huawei@123@127.0.0.1:1611
exp users=test_common file="./data/test_common_bin.dmp" filetype=bin;
exp users=test_common file="./data/test_common_txt.dmp" filetype=txt;

-- dba user imp users : test_common
conn test_dba/Test_123456@127.0.0.1:1611
select USER_NAME from v$me;
imp users=test_common file="./data/test_common_bin.dmp" filetype=bin;
imp users=test_common file="./data/test_common_txt.dmp" filetype=txt;

-- common user imp users : test_common
conn test_all_privilege/Test_123456@127.0.0.1:1611
select USER_NAME from v$me;
imp users=test_common file="./data/test_common_bin.dmp" filetype=bin;
imp users=test_common file="./data/test_common_txt.dmp" filetype=txt;

-- imp users self : test_common
conn test_common/Test_123456@127.0.0.1:1611
select USER_NAME from v$me;
imp users=TEST_COMMON file="./data/test_common_bin.dmp" filetype=bin;
imp users=TEST_COMMON file="./data/test_common_txt.dmp" filetype=txt;

