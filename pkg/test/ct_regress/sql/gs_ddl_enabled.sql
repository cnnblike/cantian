drop table if exists test;
create table test(id int, str varchar(96));
insert into test values (0, 'this is a very very long string.this is a very very long string.this is a very very long string.');
insert into test (id, str) select id + 1, str from test;
insert into test (id, str) select id + 2, str from test;
insert into test (id, str) select id + 4, str from test;
insert into test (id, str) select id + 8, str from test;
insert into test (id, str) select id + 16, str from test;
insert into test (id, str) select id + 32, str from test;
insert into test (id, str) select id + 64, str from test;
insert into test (id, str) select id + 128, str from test;
insert into test (id, str) select id + 256, str from test;
insert into test (id, str) select id + 512, str from test;
insert into test (id, str) select id + 1024, str from test;
insert into test (id, str) select id + 2048, str from test;
insert into test (id, str) select id + 4096, str from test;
insert into test (id, str) select id + 8192, str from test;
insert into test (id, str) select id + 16384, str from test;
insert into test (id, str) select id + 32768, str from test;
insert into test (id, str) select id + 65536, str from test;
insert into test (id, str) select id + 131072, str from test;
insert into test (id, str) select id + 262144, str from test;
insert into test (id, str) select id + 524288, str from test;
insert into test (id, str) select id + 1048576, str from test;
insert into test (id, str) select id + 2097152, str from test;
commit;

drop table if exists ddlt1;
drop table if exists ddlt2;
--expect error
create table ddlt1(a int, b varchar2(8001));
--expect error
create table ddlt1(a int, b varchar2(4000) default lpad('*',4001));
--expect error
create table ddlt1(a int, b varchar2(4000) default rpad('*',4001));
--expect right
drop table if exists ddlt1;
create table ddlt1(a int, b varchar2(8000) default lpad('*',8001));
--expect right
drop table if exists ddlt1;
create table ddlt1(a int, b varchar2(8000) default rpad('*',8001));
--expect right
drop table if exists ddlt1;
create table ddlt1(a int, b1 varchar2(8000) default lpad('*',8000));
--expect right
drop table if exists ddlt1;
create table ddlt1(a int, b1 varchar2(8000) default rpad('*',8000));
--expect right
create table ddlt2(a int,
b1 varchar2(8000) default lpad('*',8000),
b2 varchar2(8000) default lpad('*',8000),
b3 varchar2(8000) default lpad('*',8000),
b4 varchar2(8000) default lpad('*',8000),
b5 varchar2(8000) default lpad('*',8000),
b6 varchar2(8000) default lpad('*',8000),
b7 varchar2(8000) default lpad('*',8000),
b8 varchar2(8000) default lpad('*',8000),
b9 varchar2(8000) default lpad('*',8000),
b10 varchar2(8000) default lpad('*',8000));
drop table if exists ddlt1;
drop table if exists ddlt2;

drop table if exists ddl_t;
drop user if exists ddl_u;
drop index if exists ddl_llt_idx on #ltt_tmp;
drop view if exists ddl_v;
drop view if exists ddl_r_v;
drop sequence if exists ddl_seq;
drop table if exists #ltt_tmp;
drop synonym syn_ddl_t;
drop table if exists test1;

create table test1(id int, str varchar(96));
insert into test1 select * from test;

create table ddl_t(id int);
analyze table ddl_t compute statistics;
create view ddl_v as select * from ddl_t;
create or replace view ddl_r_v as select id from ddl_t;
create user ddl_u identified by Abc123456;
create role ddl_r identified by Abc123456;
create sequence ddl_seq;
alter system set local_temporary_table_enabled=true;
create temporary table #ltt_tmp (f1 int, f2 varchar(100));
create index ddl_llt_idx on #ltt_tmp (f1);
drop index ddl_llt_idx on #ltt_tmp;
drop table #ltt_tmp;
create synonym syn_ddl_t for ddl_t;
drop table ddl_t;

