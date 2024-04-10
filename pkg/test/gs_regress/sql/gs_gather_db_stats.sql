--run this example in user 'SYS' !!!

conn sys/sys@127.0.0.1:1611

--test subpartition modification, epxect stats of one-level part in SYS_DML_STATS include the sum of it's child subpartition
drop table if exists test_subpart;
create table test_subpart(id int, c_id int, d date default sysdate) partition by range(id) interval(50) subpartition by range(c_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100),
subpartition p13 values less than(maxvalue)
),
partition p2 values less than(100)
(
subpartition p21 values less than(50),
subpartition p22 values less than(100),
subpartition p23 values less than(maxvalue)
)
);
begin
for i in 1..100 loop
    for j in 1..200 loop
        insert into test_subpart values(i,j,sysdate);
     end loop;
end loop;
end;
/
call DBE_STATS.FLUSH_DB_STATS_INFO();
select INSERTS,updates,deletes from SYS_DML_STATS where USER#=0 and table# in (select id from sys_tables where user#=0 and name=upper('test_subpart')) order by 1,2,3;

delete from test_subpart where id=1 and c_id=1;
call DBE_STATS.FLUSH_DB_STATS_INFO();
select INSERTS,updates,deletes from SYS_DML_STATS where USER#=0 and table# in (select id from sys_tables where user#=0 and name=upper('test_subpart')) order by 1,2,3;

--test cacl tale segments by sum all part segment
create or replace function DBA_CACL_TABLE_SIZE(in_owner varchar, in_table_name varchar) return bigint
is
res bigint;
is_part int;
begin
select count(*) into is_part from adm_part_tables where owner=upper(in_owner) and table_name=upper(in_table_name);
if(is_part) then
select sum(DBE_DIAGNOSE.DBA_SEGSIZE(0, TP.ENTRY)) into res from sys_tables t, sys_users u,sys_table_parts tp 
where t.user# = u.id and tp.user# = u.id and
u.name = upper(in_owner) and t.name = upper(in_table_name) and tp.table# = t.id;
else
select DBE_DIAGNOSE.DBA_SEGSIZE(0, T.ENTRY) into res from sys_tables t, sys_users u where t.user#=u.id and u.name=upper(in_owner) and t.name=upper(in_table_name);
end if;
return res;
end;
/
--only support one-level partition table
create or replace function DBA_CACL_TABLE_PARTSIZE(owner varchar, table_name varchar, partname varchar) return bigint
is
res bigint;
begin
select DBE_DIAGNOSE.DBA_SEGSIZE(0, TP.ENTRY) into res from sys_tables t, sys_users u,sys_table_parts tp 
where t.user# = u.id and tp.user# = u.id and u.name = upper(owner) and t.name = upper(table_name) and tp.table# = t.id and tp.name=upper(partname);
return res;
end;
/

--test normal table
drop table if exists myt;
create table myt(a int,b varchar(2000),c bigint default 1000000000000, d date default sysdate, e clob default 'abc', e2 blob default 'abcd',f number(20,10) default 1.1, g decimal default 111.111);
declare
sql1 clob;
begin
for i in 1..100 loop
insert into myt(a,b) values(i, i||'abcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl;dsj;kl');
end loop;
end;
/
select dbe_diagnose.dba_table_size(0,user,'myt') - DBA_CACL_TABLE_SIZE(user,'myt');

--test part table
drop table if exists myt_part;
create table myt_part(a int,b varchar(2000),c bigint default 1000000000000, d date default sysdate, e clob default 'abc', e2 blob default 'abcd',f number(20,10) default 1.1, g decimal default 111.111)
partition by range(a)
(
partition p1 values less than(50),
partition p2 values less than(100),
partition p3 values less than(maxvalue)
);
declare
sql1 clob;
begin
for i in 1..100 loop
insert into myt_part(a,b) values(i, i||'abcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl;dsj;kl');
end loop;
end;
/
select dbe_diagnose.dba_table_size(0,user,'myt_part')-DBA_CACL_TABLE_SIZE(user,'myt_part');

--### test normal ability ###
--normal partition
begin
execute immediate 'delete from sys_stats_log';
commit;
end;
/

drop table if exists tb_test;
create table tb_test
(
c_id int,
CAOC clob default '123456789',
CAOB blob default '123456789'
) 
partition by range(c_id)
(partition part_1 values less than(10),
partition part_2 values less than(30),
partition part_3 values less than(maxvalue));

insert into tb_test(c_id) values(5);
insert into tb_test(c_id) values(20);
commit;
select dbe_diagnose.dba_table_partsize(0,user,'tb_test','part_1');
select dbe_diagnose.dba_table_partsize(1,user,'tb_test','part_1');
select dbe_diagnose.dba_table_partsize(2,user,'tb_test','part_1');
select dbe_diagnose.dba_table_partsize(-1,user,'tb_test','part_1'); --expect error
select dbe_diagnose.dba_table_partsize(3,user,'tb_test','part_1'); --expect error

--sub partition
drop table if exists test_subpart;
create table test_subpart(id int, c_id int, d date default sysdate) partition by range(id) interval(50) subpartition by range(c_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100),
subpartition p13 values less than(maxvalue)
),
partition p2 values less than(100)
(
subpartition p21 values less than(50),
subpartition p22 values less than(100),
subpartition p23 values less than(maxvalue)
)
);
insert into test_subpart(id,c_id) values(10,20),(10,60);
commit;
select dbe_diagnose.dba_table_partsize(0,user,'test_subpart','p1');
select dbe_diagnose.dba_table_partsize(1,user,'test_subpart','p1');
select dbe_diagnose.dba_table_partsize(2,user,'test_subpart','p1');

--normal table
drop table if exists plsql_tabsize;
create table plsql_tabsize(a int,b int);
select dbe_diagnose.dba_table_size(0,user,'plsql_tabsize');
select dbe_diagnose.dba_table_size(1,user,'plsql_tabsize');
select dbe_diagnose.dba_table_size(2,user,'plsql_tabsize');
select dbe_diagnose.dba_table_size(-1,user,'plsql_tabsize'); --expect error
select dbe_diagnose.dba_table_size(3,user,'plsql_tabsize'); --expect error

--test GATHER_DB_STATS_EX
begin
execute immediate 'delete from sys_stats_log';
commit;
end;
/
call GATHER_DB_STATS_EX(force=>true, max_size=>1024*1024);
select count(*) from sys_stats_log where status='FIN' and start_time+1/24/6>=sysdate and end_time+1/24/60>=sysdate and owner=user and table_name in  ('TB_TEST','TEST_SUBPART','PLSQL_TABSIZE');
select TABLE_NAME from MY_TABLES where TABLE_NAME in  ('TB_TEST','TEST_SUBPART','PLSQL_TABSIZE') and LAST_ANALYZED is not null order by 1;
select TABLE_NAME, PARTITION_NAME from MY_TAB_PARTITIONS where TABLE_NAME in  ('TB_TEST','TEST_SUBPART','PLSQL_TABSIZE') and LAST_ANALYZED is not null order by 1,2;
drop table if exists tb_test;
drop table if exists tb_subpart;
drop table if exists plsql_tabsize;


--#### test part flag ####
--normal partition
drop table if exists tb_test;
create table tb_test
(
c_id int,
CAOC clob default '123456789',
CAOB blob default '123456789'
) 
partition by range(c_id)
(partition part_1 values less than(10),
partition part_2 values less than(30),
partition part_3 values less than(maxvalue));

insert into tb_test(c_id) values(5);
insert into tb_test(c_id) values(20);
commit;

--sub partition
drop table if exists test_subpart;
create table test_subpart(id int, c_id int, d date default sysdate) partition by range(id) interval(50) subpartition by range(c_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100),
subpartition p13 values less than(maxvalue)
),
partition p2 values less than(100)
(
subpartition p21 values less than(50),
subpartition p22 values less than(100),
subpartition p23 values less than(maxvalue)
)
);
insert into test_subpart(id,c_id) values(10,20),(10,60);
commit;

begin
execute immediate 'delete from sys_stats_log';
commit;
end;
/
call GATHER_DB_STATS_EX(force=>true, part_flag=>false, max_size=>1024*1024);
select table_name,part_name from sys_stats_log where status='FIN' and start_time+1/24/6>=sysdate and end_time+1/24/60>=sysdate and owner=user and table_name in  ('TB_TEST','TEST_SUBPART') order by 1,2;
select TABLE_NAME from MY_TABLES where TABLE_NAME in ('TB_TEST','TEST_SUBPART') and LAST_ANALYZED is not null order by 1;
select TABLE_NAME, PARTITION_NAME from MY_TAB_PARTITIONS where TABLE_NAME in  ('TB_TEST','TEST_SUBPART') and LAST_ANALYZED is not null order by 1,2;
drop table if exists tb_test;
drop table if exists tb_subpart;

--### test max size ###
drop table if exists myt;
create table myt(a int,b varchar(2000),c bigint default 1000000000000, d date default sysdate, e clob default 'abc', e2 blob default 'abcd',f number(20,10) default 1.1, g decimal default 111.111);
insert into myt(a,b) values(10, '312adsfdsabcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl;dsj;kl');
declare
begin
for i in 1..17 loop
insert into myt select * from myt;
end loop;
end;
/

drop table if exists myt_part;
create table myt_part(a int,b varchar(2000),c bigint default 1000000000000, d date default sysdate, e clob default 'abc', e2 blob default 'abcd',f number(20,10) default 1.1, g decimal default 111.111)
partition by range(a)
(partition part_1 values less than(10),
partition part_2 values less than(maxvalue));
insert into myt_part(a,b) values(1, '312adsfdsabcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl;dsj;kl');
declare
begin
for i in 1..17 loop
insert into myt_part select * from myt_part;
end loop;
end;
/
insert into myt_part(a,b) values(100, '312adsfdsabcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl;dsj;kl');
declare
begin
for i in 1..17 loop
insert into myt_part select * from myt_part where a = 100;
end loop;
end;
/

drop table if exists myt_subpart;
create table myt_subpart(a int,b varchar(2000),c bigint default 1000000000000, d date default sysdate, e clob default 'abc', e2 blob default 'abcd',f number(20,10) default 1.1, g decimal default 111.111)
partition by range(a) subpartition by range(c)
(partition part_1 values less than(10)
(
    subpartition part_11 values less than(100),
    subpartition part_12 values less than(maxvalue)
),
partition part_2 values less than(maxvalue)
(
    subpartition part_21 values less than(100),
    subpartition part_22 values less than(maxvalue)
)
);
insert into myt_subpart(a,b) values(1, '312adsfdsabcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl;dsj;kl');
declare
begin
for i in 1..17 loop
insert into myt_subpart select * from myt_subpart;
end loop;
end;
/
insert into myt_subpart(a,b) values(100, '312adsfdsabcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl;dsj;kl');
declare
begin
for i in 1..17 loop
insert into myt_subpart select * from myt_subpart where a=100;
end loop;
end;
/
insert into myt_subpart(a,b,c) values(1, '312adsfdsabcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl;dsj;kl',1);
declare
begin
for i in 1..17 loop
insert into myt_subpart select * from myt_subpart where a=1 and c=1;
end loop;
end;
/
insert into myt_subpart(a,b,c) values(100, '312adsfdsabcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl;dsj;kl',1);
declare
begin
for i in 1..17 loop
insert into myt_subpart select * from myt_subpart where a=100 and c=1;
end loop;
end;
/

select 1 from sys_dummy where dbe_diagnose.dba_table_size(0,user,'myt')/1024/1024 > 10;
select 2 from sys_dummy where dbe_diagnose.dba_table_size(0,user,'myt_part')/1024/1024 > 20;
select 3 from sys_dummy where dbe_diagnose.dba_table_size(0,user,'myt_subpart')/1024/1024 > 40;

begin
execute immediate 'delete from sys_stats_log';
commit;
end;
/
call GATHER_DB_STATS_EX(force=>true, max_size=>1024*1024); --the sample of percent of table/part with size>10M whill change
select table_name, part_name from sys_stats_log where percent < 10 and table_name in ('MYT','MYT_PART','MYT_SUBPART') order by 1,2;
select TABLE_NAME from MY_TABLES where TABLE_NAME in  ('MYT','MYT_PART','MYT_SUBPART') and LAST_ANALYZED is not null order by 1;
select TABLE_NAME, PARTITION_NAME from MY_TAB_PARTITIONS where TABLE_NAME in  ('MYT','MYT_PART','MYT_SUBPART') and LAST_ANALYZED is not null order by 1,2;
drop table if exists myt;
drop table if exists myt_part;
drop table if exists myt_subpart;