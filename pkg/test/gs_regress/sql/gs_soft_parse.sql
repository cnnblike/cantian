--dml语句中的存储过程对象，如果出现了一个解析位置更靠前的，那么该dml的cache立即失效
--在table定义中存储过程对象，例如在default表达式中，如果出现了一个解析位置更靠前的，表不感知，还是按照CREATE TABLE时解析的存储过程对象处理
--test soft parse
--1.one word
conn / as sysdba
drop function if exists f1;
drop user if exists user1 cascade;
drop user if exists user2 cascade;
create user user1 identified by Cantian_234;
create user user2 identified by Cantian_234;
grant dba to user2;
create or replace function user1.f1(c1 int) return int is
begin
 return 1123213;
end;
/
create or replace public synonym f1 for user1.f1;
--expect 1123213
select f1(1) from sys_dummy; 

drop table if exists t1;
create table t1(c1 int,c2 int default f1(1));
insert into t1(c1) values(1);
commit;
--expect 1123213
select * from t1 order by c1;

create or replace function f1(c1 int) return int is
begin
 return 1;
end;
/
--为了性能，目前对一个标识符没有做检查
--expect 1123213
select f1(1) from sys_dummy;

--expect 1
Select f1(1) from sys_dummy;

insert into t1(c1) values(2);
commit;
--expect 1123213
select * from t1 order by c1;

drop table if exists t1;
create table t1(c1 int,c2 int default f1(1));
insert into t1(c1) values(1);
commit;
--expect 1
select * from t1 order by c1;

drop function f1;
--expect 1123213
select f1(1) from sys_dummy;
select F1(1) from sys_dummy;

--为了性能，目前对一个标识符没有做检查
--expect success
create or replace function f1(c1 int,c2 int) return int is
 a int;
begin
 select f1(1) into a from sys_dummy;
 return 1;
end;
/
--expect fail
create or replace function f1(c1 int,c2 int) return int is
 a int;
begin
 select f1(2) into a from sys_dummy;
 return 1;
end;
/

--2.two word
conn user2/Cantian_234@127.0.0.1:1611
--expect 1123213
select USER1.F1(1);

create or replace package USER1 is
 function F1(c1 int) return int;
end;
/

create or replace package body USER1 is
 function F1(c1 int) return int is
 begin
  return 235235;
 end;
end;
/

--expect 1123213
select USER1.F1(1);

--expect 235235
select USER1.F1(2);
drop package USER1;

--expect 1123213
select USER1.F1(1);

conn / as sysdba
drop function if exists f1;
drop table if exists t1;
drop user if exists user1 cascade;
drop user if exists user2 cascade;
