-- test export exclude option
drop user if exists test;
create user test identified by Test_123456;
grant dba to test;
conn test/Test_123456@127.0.0.1:1611
create table t1(c int);
create table t2(c int);
create table st1(c int);
create table st2(c int);
exp users=test exclude=table"='T1'";
exp users=test exclude=table:T1;
exp users=test exclude=table:"='T1'",table:"='T2'";
exp users=test exclude=tab:"='T1'";
exp users=test exclude=table:"='T1'",user:"='T2'";
exp users=test exclude=table:"='T1'";
exp users=test exclude=table:"like 'T%'";
exp users=test exclude=table:"in ('T1','ST1')";
exp users=test exclude=table:"in ('T1','ST1')" filetype=bin;

-- table exclude triggers also where use 'exp users=xx'
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists test1;
create user test1 identified by Test_123456;
grant dba to test1;
conn test1/Test_123456@127.0.0.1:1611
create table t1(c int);
create table t2(c int);
create or replace trigger trig_t1 
BEFORE INSERT ON t1
BEGIN
        dbe_output.print_line('BEFORE t1');
END;
/
create or replace trigger trig_t2 
BEFORE INSERT ON t2
BEGIN
        dbe_output.print_line('BEFORE t1');
END;
/
create or replace function trig_t1(a varchar)
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
exp users=test1 file="./data/test1.dmp" filetype=txt exclude=table:"='T1'";
drop trigger trig_t1;
drop table t1;
drop function trig_t1;
imp users=test1 file="./data/test1.dmp" filetype=txt ;
select * from t1;
select trig_t1('ab');

-- table exclude triggers also where use 'exp tables=%'
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists test2;
create user test2 identified by Test_123456;
grant dba to test2;
conn test2/Test_123456@127.0.0.1:1611
create table t1(c int);
create table t2(c int);
create or replace trigger trig_t1 
BEFORE INSERT ON t1
BEGIN
        dbe_output.print_line('BEFORE t1');
END;
/
create or replace trigger trig_t2 
BEFORE INSERT ON t2
BEGIN
        dbe_output.print_line('BEFORE t1');
END;
/
exp tables=% file="./data/test2.dmp" filetype=txt exclude=table:"='T1'";
drop trigger trig_t1;
drop table t1;
drop trigger trig_t2;
drop table t2;
imp tables=% file="./data/test2.dmp" filetype=txt;
select * from t1;
select * from t2;
