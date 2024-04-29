-- prepare user for SPC100 import
drop user if exists test_compatible_none_data cascade;
create user test_compatible_none_data identified by Test_123456; 
grant dba to test_compatible_none_data;

drop user if exists test_compatible_with_data cascade;
create user test_compatible_with_data identified by Test_123456; 
grant dba to test_compatible_with_data;

-- this test case is for import compatible 
-- SPC100 version compatible test
imp users=test_compatible_none_data filetype=bin file="./data/compatible_data/spc100/compatible_none_data/exp_bin.dmp";
imp users=test_compatible_with_data filetype=bin file="./data/compatible_data/spc100/compatible_with_data/exp_bin.dmp";


-- prepare user for SPC200 import
drop user if exists test_compatible_none_data cascade;
create user test_compatible_none_data identified by Test_123456; 
grant dba to test_compatible_none_data;

drop user if exists test_compatible_with_data cascade;
create user test_compatible_with_data identified by Test_123456; 
grant dba to test_compatible_with_data;

-- SPC200 version compatible test
-- 1. none data test
exp users=test_compatible_none_data filetype=bin file="./data/compatible_data/spc200/compatible_none_data/exp_bin.dmp";
-- 2. with data test
conn test_compatible_with_data/Test_123456@127.0.0.1:1611
-- 2.1 create sequence
DROP SEQUENCE IF EXISTS seq_test_1;
create sequence seq_test_1 start with 100 increment by 2 cache 99999;
-- 2.2 create tablespace 
create tablespace test_compatible_with_data_tablespace datafile 'test_compatible_with_data' size 32m autoextend on;
-- 2.3 create table
drop table if exists test1 CASCADE CONSTRAINTS;
create table test1 (
col_int int , 
col_int1 int,
col_varchar varchar(8000), 
col_nvarchar1 nvarchar(1000),
col_nvarchar2 nvarchar(4000),
col_clob clob,
primary key (col_int));
-- 2.4 construct table data
insert into test1 values (1, 6, '', '', '', '');
insert into test1 values (2, 6, 'this is a large record', 'this is a large record', 'this is a large record', 'this is a large record');
insert into test1 values (3, 6, 'this is a small record', 'this is a small record', 'this is a small record', 'this is a small record');
insert into test1 values (4, 6, 'this is a large record', 'this is a large record', 'this is a large record', 'this is a large record');
-- 2.5 create a procedure and make record 2,4 larger
create or replace procedure make_test1_data2_larger_col_nvarchar2(size_col_nvarchar2 in int, size_col_clob in int )
as
begin 
    for i in 1..size_col_nvarchar2 loop
        update test1 set col_nvarchar2=col_nvarchar2||col_nvarchar2 where col_int = 2 or col_int = 4;
    end loop;
    for i in 1..size_col_clob loop
        update test1 set col_clob=col_clob||col_clob where col_int = 2 or col_int = 4;
    end loop;
end;
/

call make_test1_data2_larger_col_nvarchar2(6,10);

-- 2.6 create index
create index test1_index on test1 ( col_int, col_int1);

-- 2.7 create foreign key 
drop table if exists test2 CASCADE CONSTRAINTS;
create table test2 ( col_int1 int, col_int2 int);
alter table test2 add constraint test2_foreign_key foreign key (col_int1) references test1 (col_int);

-- 2.8 create view
create or replace view view_test2 as select * from test2;

-- 2.9 create function
create or replace function func_test1(a varchar)
RETURN varchar
AS
BEGIN
   if (a = 'ab') then
        return a;
   else
        return 'abc';
   end if;
END;
/

-- 2.10 create trigger
create or replace trigger trig_test1 
BEFORE INSERT ON test1
BEGIN
        dbe_output.print_line('BEFORE test1');
END;
/

-- 2.11 export and import information 
conn sys/Huawei@123@127.0.0.1:1611
exp users=test_compatible_with_data filetype=bin file="./data/compatible_data/spc200/compatible_with_data/exp_bin.dmp";

imp users=test_compatible_none_data filetype=bin file="./data/compatible_data/spc200/compatible_none_data/exp_bin.dmp";
imp users=test_compatible_with_data filetype=bin file="./data/compatible_data/spc200/compatible_with_data/exp_bin.dmp";

-- clear tablespace
drop user test_compatible_with_data cascade;
drop tablespace test_compatible_with_data_tablespace including contents and datafiles;


