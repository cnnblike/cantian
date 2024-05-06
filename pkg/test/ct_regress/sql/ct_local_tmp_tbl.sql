set autocommit off;

alter system set local_temporary_table_enabled=false;
create global temporary table #tmp (f1 int);
create table #tmp (f1 int);
create temporary table #tmp (f1 int);


alter system set local_temporary_table_enabled=true;
create temporary table if not exists #tmp (f1 int);
truncate table #tmp;
insert into #tmp values (100);
insert into #tmp values (1);
update #tmp set f1 = 99 where f1=100;
delete from #tmp where f1 = 1;
select * from #tmp;


truncate table #tmp;
insert into #tmp values (100);
insert into #tmp values (1);
update #tmp set f1 = 99 where f1=100;
delete from #tmp where f1 = 1;
select * from #tmp;
select * from `#TMP`;
select * from "#TMP";

drop table #tmp;
drop table if exists #tmp;

--test create table with primary key
create temporary table `#ltt_t1` (f1 int constraint key001 primary key, f2 varchar(100));
insert into `#ltt_t1` values (1, 'a');
insert into `#ltt_t1` values (2, 'b');
commit;
select * from `#ltt_t1` where f1 = 2;
truncate table `#ltt_t1`;
select count(*) from `#ltt_t1`;
insert into `#ltt_t1` values (1, 'a');
insert into `#ltt_t1` values (1, 'b');
select * from `#ltt_t1`;

drop table `#ltt_t1`;
select * from `#ltt_t1`;


-- test create index, drop index
create temporary table #ltt_tmp (f1 int, f2 varchar(100));
insert into #ltt_tmp values (1, 'a');
insert into #ltt_tmp values (2, 'b');
insert into #ltt_tmp values (3, 'c');

create index index001 on #ltt_tmp (f1);
create index index002 on #ltt_tmp (f2);

select * from #ltt_tmp where f1 = 1;
select * from #ltt_tmp where f2 = 'c';

drop index index001 on #ltt_tmp;

select * from #ltt_tmp where f1 = 1;
select * from #ltt_tmp where f2 = 'c';
insert into #ltt_tmp values (4, 'd');
select * from #ltt_tmp where f2 = 'd';
select * from #ltt_tmp where f1 = 4;
select * from #ltt_tmp order by f1;

drop table if exists #ltt_tmp;


-- test create unique index
create temporary table #ltt_tmp (f1 int, f2 varchar(100));
create temporary table if not exists #ltt_tmp (f1 int, f2 varchar(100));

set autocommit off;
insert into #ltt_tmp values (1, 'a');
insert into #ltt_tmp values (2, 'b');
commit;

create unique index index001 on #ltt_tmp (f1);
select * from #ltt_tmp where f1 = 1;

drop index index001 on #ltt_tmp;
select * from #ltt_tmp where f1 = 1;

update #ltt_tmp set f1 = 1 where f2 = 'b';
select * from #ltt_tmp order by f2 desc;
commit;

-- error, f1=1 has 2 records! unique constraint (INDEX001) violated
create unique index index001 on #ltt_tmp (f1);

drop table #ltt_tmp;
drop table if exists #ltt_tmp;
-- error
select * from #ltt_tmp;


-- ltt dml: insert, update, delete, select, merge, join

create temporary table #ltt_t1 (f1 int, f2 varchar(100));
create temporary table #ltt_t2 (f1 int, f2 varchar(100));
create temporary table #ltt_t3 (f1 int, f2 varchar(100));

insert into #ltt_t1 values (1, 'a'), (2, 'b'), (3, 'c'), (4, 'd');
insert into #ltt_t2 values (2, 'bb'), (4, 'dd'), (5, 'ee');
insert into #ltt_t3 values (3, 'ccc'), (10, 't');

create index index001 on #ltt_t1 (f2);

select t1.f1, t1.f2, t2.f1, t2.f2 from #ltt_t1 t1 join #ltt_t2 t2 on t1.f1 = t2.f1 order by t1.f1, t1.f2, t2.f1, t2.f2;

insert into #ltt_t1 values (100, 'ltt');
select * from #ltt_t1 order by f1;
update #ltt_t1 set f1 = 99 where f2 = 'ltt';
select * from #ltt_t1 order by f1;
delete from #ltt_t1 where f1 = 99;
select * from #ltt_t1 order by f1;
commit;

select * from #ltt_t3;
--merge into
merge into #ltt_t1 t1 using #ltt_t3 t3 on (t1.f1 = t3.f1) 
when matched then update set t1.f2=t3.f2 
when not matched then insert values (t3.f1, t3.f2);

select * from #ltt_t1 order by f1;
rollback;
select * from #ltt_t1 order by f1;

-- test in gsql_test
-- select t1.f1, t1.f2, t2.f1, t2.f2 from #ltt_t1 t1 join #ltt_t2 t2 on t1.f1 = t2.f1;
-- select t1.*, t2.* from #ltt_t1 t1 left join #ltt_t2 t2 on t1.f1 = t2.f1;
-- select t1.*, t2.* from #ltt_t1 t1 right join #ltt_t2 t2 on t1.f1 = t2.f1;
-- select t1.*, t2.* from #ltt_t1 t1 left join #ltt_t2 t2 on t1.f2 = t2.f2;
-- select t1.*, t2.* from #ltt_t1 t1 right join #ltt_t2 t2 on t1.f2 = t2.f2;
-- select t1.*, t2.* from #ltt_t1 t1, #ltt_t2 t2;
-- select t1.*, t2.* from #ltt_t1 t1 full join #ltt_t2 t2 on t1.f1 = t2.f1;


drop table if exists #ltt_tmp;
create temporary table #ltt_tmp (f1 int);
insert into #ltt_tmp values (1),(2),(3);

drop table if exists ltt_test1;
create table ltt_test1 (f1 int);
insert into ltt_test1 (f1) values (1),(2),(3),(4);

select #ltt_tmp.f1 from #ltt_tmp right join ltt_test1 on #ltt_tmp.f1 = ltt_test1.f1 order by #ltt_tmp.f1;

set serveroutput on
create temporary table if not exists #tmp (f1 int);

declare
l_f1 int;
begin
select * into l_f1 from #tmp;
dbe_output.print_line(l_f1);
end;
/

begin
insert into #tmp values(1);
end;
/

declare
l_f1 int;
begin
select * into l_f1 from #tmp;
dbe_output.print_line(l_f1);
end;
/

declare
l_f1 int;
begin
select * into l_f1 from #tmp;
dbe_output.print_line(l_f1);
end;
/

begin
update #tmp set f1 = 2 where f1 = 1;
end;
/

declare
l_f1 int;
begin
select * into l_f1 from #tmp;
dbe_output.print_line(l_f1);
end;
/

begin
delete from #tmp;
insert into #tmp values(1);
end;
/

declare
l_f1 int;
begin
select * into l_f1 from #tmp;
dbe_output.print_line(l_f1);
end;
/

declare
cursor c1 is select * from #tmp;
begin
for i in c1 loop
dbe_output.print_line(i.f1);
end loop;
end;
/

insert into #tmp values(1);

create or replace procedure xxx(a int)
as
cursor c1 is select * from #tmp;
begin
for i in c1 loop
dbe_output.print_line(i.f1);
end loop;
end;
/

call xxx(1);
call xxx(1);

create or replace procedure xxx(a int)
is
c1 sys_refcursor;
begin
open c1 for select * from #tmp;
DBE_SQL.RETURN_CURSOR(c1);
end;
/

call xxx(1);
call xxx(1);

create or replace procedure xxx(a int)
as
begin
for i in (select * from #tmp) loop
dbe_output.print_line(i.f1);
end loop;
end;
/

call xxx(1);
call xxx(1);

--DTS2018092003400 
drop table if exists gs_local_test;
create table gs_local_test(id  int,name varchar(100),ctime date);
insert into gs_local_test values (1,'test','2018-09-17 16:10:28');
create temporary table #abc as select * from gs_local_test;
create or replace procedure gs_local_p1 is 
begin
insert into #abc values(1,'test','2018-09-17 16:10:28');
end;
/
call gs_local_p1;
select * from gs_local_test;


--USE_NAVATIVE_DATATYPE=FALSE, create table as select failed
alter system set USE_NATIVE_DATATYPE=FALSE;
drop table if exists #ltt_t1;
drop table if exists #ltt_t2;
create temporary table #ltt_t1 (f1 int);
insert into #ltt_t1 values (1);
commit;
create temporary table #ltt_t2 as select * from #ltt_t1;
select * from #ltt_t2;
alter system set use_native_datatype=true;
set serveroutput off

drop table if exists #ltt;
create temporary table #ltt (f1 int not null auto_increment, f2 varchar(100) , primary key (f1));

drop table if exists #ltt;
create temporary table #ltt (f1 int) on commit preserve rows;
drop table if exists #ltt;
create temporary table #ltt (f1 int) on commit delete rows;
drop table if exists t4;
create temporary table #t4(id int auto_increment primary key, name varchar(32));

drop table if exists #ltt;
create temporary table #ltt (f1 int, f2 int, f3 int);
create index #ltt_idx1 on #ltt (f1);
create index #ltt_idx2 on #ltt (f1);
create index #ltt_idx1 on #ltt (f1);
create index #ltt_idx2 on #ltt (f1, f2);

drop table if exists #ltt;
create temporary table #ltt (f1 int not null, f2 int)
 partition by range (f1)
 (
   partition p1 values less than (100),
   partition p2 values less than (maxvalue)
 );
 
drop table if exists gtt;
create global temporary table gtt (f1 int not null, f2 int)
 partition by range (f1)
 (
   partition p1 values less than (100),
   partition p2 values less than (maxvalue)
 );



alter system set local_temporary_table_enabled=false;

