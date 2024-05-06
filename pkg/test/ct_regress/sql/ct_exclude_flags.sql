drop table if exists test_exclude_flags_1;
drop table if exists test_exclude_flags_2;
create table test_exclude_flags_1(f1 int, f2 int);
create table test_exclude_flags_2(f1 int, f2 int);
insert into test_exclude_flags_1(f1,f2) values(1,11);
insert into test_exclude_flags_2(f1,f2) values(1,11);
commit;
create sequence t_sequence;

--- select
select distinct rownum, rowid from test_exclude_flags_1 where f1=rownum group by rownum having rownum < 10 order by rownum;
select distinct rownum, case rowid when null then 1 else 2 end from test_exclude_flags_1 where f1=rownum group by rownum, rowid having rownum < 10 order by rownum;
select distinct f1, max(f1) from test_exclude_flags_1 where f1=(select f1 from test_exclude_flags_2) group by f1 having f1 < 10;
-- where
select f1 from test_exclude_flags_1 where f1=max(1);
select f1 from test_exclude_flags_1 where max(1)=f1;
select f1 from test_exclude_flags_1 where f1=*;
select f1 from test_exclude_flags_1 where *=*;
select f1 from test_exclude_flags_1 where f1=t_sequence.nextval;
-- group by
select f1 from test_exclude_flags_1 group by *;
select f1 from test_exclude_flags_1 group by t_sequence.nextval;
select f1 from test_exclude_flags_1 group by (select 1 from dual);
-- having
select f1 from test_exclude_flags_1 group by f1 having f1=*;
select f1 from test_exclude_flags_1 group by f1 having f1=t_sequence.nextval;
select f1 from test_exclude_flags_1 group by f1 having f1=(select 1 from dual);
-- join cond
select t1.f1 from test_exclude_flags_1 t1 join test_exclude_flags_2 t2 on t1.f1=max(1);
select t1.f1 from test_exclude_flags_1 t1 join test_exclude_flags_2 t2 on t1.f1=*;
select t1.f1 from test_exclude_flags_1 t1 join test_exclude_flags_2 t2 on t1.f1=t_sequence.nextval;
-- order by
select f1 from test_exclude_flags_1 order by *;
select f1 from test_exclude_flags_1 order by t_sequence.nextval;
--- insert
insert into test_exclude_flags_1(f1, f2) values((select f1 from test_exclude_flags_2), (select f2 from test_exclude_flags_2));
insert into test_exclude_flags_1 select * from test_exclude_flags_2;
-- column=value
insert into test_exclude_flags_1(*) values(1);
insert into test_exclude_flags_1(f1) values(avg(1));
insert into test_exclude_flags_1(f1) values(f2);
insert into test_exclude_flags_1(f1) values(*);
insert into test_exclude_flags_1(f1) values(rownum);
insert into test_exclude_flags_1(f1) values(rowid);

--- delete
delete from test_exclude_flags_1 where f1=rownum and f2=rowid;
delete from test_exclude_flags_1 where f1=(select f1 from test_exclude_flags_2);
-- where
delete from test_exclude_flags_1 where f1=max(1);
delete from test_exclude_flags_1 where max(1)=f1;
delete from test_exclude_flags_1 where f1=*;
delete from test_exclude_flags_1 where *=*;
delete from test_exclude_flags_1 where f1=t_sequence.nextval;

--- update
update test_exclude_flags_1 set f1=t_sequence.nextval, f2=(select f2 from test_exclude_flags_2) where f1=rownum;
update test_exclude_flags_1 set f1=rownum, f2=(select f2 from test_exclude_flags_2) where f1=(select f1 from test_exclude_flags_2);
-- set(column=value)
update test_exclude_flags_1 set *=1;
update test_exclude_flags_1 set f1=avg(1);
update test_exclude_flags_1 set f1=*;
update test_exclude_flags_1 set f1=rowid;

commit;
drop table test_exclude_flags_1;
drop table test_exclude_flags_2;
drop sequence t_sequence;
