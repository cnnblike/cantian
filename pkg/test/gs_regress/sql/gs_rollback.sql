drop table if exists test_tb1;
create table test_tb1(f1 int, f2 int);
drop table if exists test_tb2;
create table test_tb2(f1 int, f2 int);
drop table if exists test_tb3;
create table test_tb3(f1 int, f2 int);

insert into test_tb1(f1,f2) values(1,11);
insert into test_tb1(f1,f2) values(2,22);
insert into test_tb2(f1,f2) values(1,11);
insert into test_tb2(f1,f2) values(2,22);
insert into test_tb3(f1,f2) values(1,11);
insert into test_tb3(f1,f2) values(2,22);
commit;

update test_tb1 set f1 = 3 where f2 = 22;
savepoint sp1;
update test_tb2 set f1 = 3 where f2 = 22;
savepoint sp2;
update test_tb3 set f1 = 3 where f2 = 22;
savepoint sp3;
rollback to savepoint sp3;
rollback to savepoint sp2;
select TYPE, LMODE from V$LOCK where SID in (select SID from V$ME) order by TYPE;
rollback to savepoint sp1;
select TYPE, LMODE from V$LOCK where SID in (select SID from V$ME) order by TYPE;
rollback;

savepoint sp0;
insert into test_tb1(f1,f2) select * from test_tb2;
insert into test_tb1(f1,f2) select * from test_tb3;
savepoint sp4;
insert into test_tb3(f1,f2) values(1,11);
insert into test_tb3(f1,f2) values(2,22);
savepoint sp5;
rollback to savepoint sp4;
select TYPE, LMODE from V$LOCK where SID in (select SID from V$ME) order by TYPE;
rollback to savepoint sp0;
select TYPE, LMODE from V$LOCK where SID in (select SID from V$ME) order by TYPE;
rollback;

drop table if exists test_tb4;
create table test_tb4(f1 int, f2 int);
insert into test_tb4(f1,f2) values(1,11);
insert into test_tb4(f1,f2) values(2,22);
savepoint sp1;
insert into test_tb4(f1,f2) values(3,33);
insert into test_tb4(f1,f2) values(4,44);
savepoint sp2;
insert into test_tb4(f1,f2) values(5,55);
insert into test_tb4(f1,f2) values(6,66);
savepoint sp3;
insert into test_tb4(f1,f2) values(7,77);
insert into test_tb4(f1,f2) values(8,88);
savepoint sp4;
insert into test_tb4(f1,f2) values(9,99);
release savepoint sp4;
rollback to savepoint sp4;
release savepoint sp2;
rollback to savepoint sp2;
rollback to savepoint sp3;
rollback to savepoint sp6;
release savepoint sp1;
rollback to savepoint sp1;
savepoint sp1;
release savepoint sp1;
savepoint sp1;
insert into test_tb4(f1,f2) values(11,99);
savepoint sp1;
release savepoint sp1;
release savepoint sp1;

drop table if exists test_tb1;
drop table if exists test_tb2;
drop table if exists test_tb3;
drop table if exists test_tb4;

--DTS2019052601209
drop table if exists svpt_t1;
drop table if exists svpt_t2;
create table svpt_t1 (id int, name varchar(4000));
create table svpt_t2 (id int, name varchar(4000));
create index id_svpt_t1 on svpt_t1(id);

insert into svpt_t1 values (1, lpad('A', 4000, 'A'));
insert into svpt_t2 values (2, lpad('B', 4000, 'B'));
commit;

update svpt_t1 set id = 1, name = lpad('a', 4000, 'a');
update svpt_t1 set id = 1, name = lpad('a', 4000, 'a');
update svpt_t1 set id = 1, name = lpad('a', 4000, 'a');
update svpt_t1 set id = 1, name = lpad('a', 4000, 'a');
update svpt_t2 set id = 2, name = lpad('b', 4000, 'b');

savepoint test_svpt;

update svpt_t1 set id = 1, name = lpad('a', 4000, 'a');
update svpt_t2 set id = 2, name = lpad('b', 4000, 'b');
update svpt_t2 set id = 2, name = lpad('b', 4000, 'b');
update svpt_t2 set id = 2, name = lpad('b', 4000, 'b');
update svpt_t2 set id = 2, name = lpad('b', 4000, 'b');

rollback to savepoint test_svpt;

update svpt_t2 set id = 2, name = lpad('b', 4000, 'b');
commit;

drop table if exists svpt_t1;
drop table if exists svpt_t2;
