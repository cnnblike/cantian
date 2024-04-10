-- DDL thread throws error
drop user if exists ddl_thread_throws_error cascade ;
create user ddl_thread_throws_error identified by Test_123456;
grant create session to ddl_thread_throws_error;
grant SELECT ANY TABLE to ddl_thread_throws_error;
grant SELECT ANY DICTIONARY to ddl_thread_throws_error;
grant create table to ddl_thread_throws_error;
conn ddl_thread_throws_error/Test_123456@127.0.0.1:1611
create table test1(results varchar(1024));
insert into test1 values('haha');
commit;

conn sys/Huawei@123@127.0.0.1:1611
revoke create table from ddl_thread_throws_error;

conn ddl_thread_throws_error/Test_123456@127.0.0.1:1611
exp users=ddl_thread_throws_error file="./data/ddl_thread_throws_error.dmp" filetype=bin;
imp users=ddl_thread_throws_error file="./data/ddl_thread_throws_error.dmp" filetype=bin;
