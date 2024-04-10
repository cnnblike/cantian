drop table if exists test_values_t1;
create table test_values_t1(a int primary key, b int ,c int);
begin
    for i in 1 .. 2000 loop
        insert into test_values_t1 values(i,i,i);
    end loop;
    commit;
end;
/
drop table if exists test_values_t2;
create table test_values_t2(a int primary key, b int ,c int);
insert into test_values_t2 select a, b * 2, c * 2 from test_values_t1;
commit;

select * from test_values_t1 order by a limit 10;

insert into test_values_t1 select * from test_values_t2 on duplicate key update b = values(b), c = values(b) + c;
commit;
select * from test_values_t1 order by a limit 10;

insert into test_values_t1 select a, count(b) as xxx ,max(c) from test_values_t2 group by a on duplicate key update b = values(b), c = values(b) + c;
commit;
select * from test_values_t1 order by a limit 10;

insert into test_values_t1 select a, count(b) as xxx ,max(c) from test_values_t2 group by a on duplicate key update b = values(b), c = values(b) + values(c);
commit;
select * from test_values_t1 order by a limit 10;

update test_values_t1 set b = values(b) where a = 1;
commit;
select * from test_values_t1 order by a limit 10;

insert into test_values_t1 values (1,2,3) on duplicate key update b = values(d) ;


select values(1);
select values(a) from test_values_t1  order by a limit 10;
select values(to_char(a)) from test_values_t1;
drop table if exists test_values_t2;
drop table if exists test_values_t1;

drop table if exists test_values_t3;
create table test_values_t3(a int primary key , b clob);
insert into test_values_t3 values (1,'aaac');
insert into test_values_t3 values (1, 'dfass') on duplicate key update b = values(b);

drop table if exists test_values_t4;
create table test_values_t4(a int primary key , b clob);
insert into test_values_t4 values (1,'aaac');
insert into test_values_t4 values (1, '123445') on duplicate key update b = values(b);

drop table if exists test_values_t5;
create table test_values_t5(a int primary key , b varchar(100));
insert into test_values_t5 values (1,'aaac');
insert into test_values_t5 select * from test_values_t3 on duplicate key update b = values(b);
insert into test_values_t3 select * from test_values_t5 on duplicate key update b = values(b);

drop table if exists test_values_t6;
create table test_values_t6(a int primary key , b image);
insert into test_values_t6 values (1,'aaac');
insert into test_values_t6 values (1, 'dfass') on duplicate key update b = values(b);

drop table  if exists test_values_t6;
drop table  if exists test_values_t5;
drop table  if exists test_values_t3;
drop table  if exists test_values_t4;

drop table if exists test_values_t7;
create table test_values_t7(a int primary key ,b bigint, c varchar(100), d date, e timestamp, f varbinary(100), g bool);
begin
    for i in 1 .. 2000 loop
        insert into test_values_t7 values(i,i,'aaaaa','1990-10-25', '1990-10-25 10:01:02', '1234567890', 1);
    end loop;
    commit;
end;
/
drop table if exists test_values_t8;
create table test_values_t8(a int primary key ,b bigint, c varchar(100), d date, e timestamp, f varbinary(100), g bool);
begin
    for i in 1 .. 2000 loop
        insert into test_values_t8 values(i ,i * 2,'bbbbb','2019-11-22', '2011-11-11 11:11:11', 'abcdef', 0);
    end loop;
    commit;
end;
/

insert into test_values_t7 select * from test_values_t8 on duplicate key update b = values(b), c = values(c), d = values(d), e = values(e), f = values(f), g = values(g);
commit;
select * from test_values_t7 order by a limit 10;
select * from test_values_t7 order by a desc limit 10;
drop table if exists test_values_t7;
drop table if exists test_values_t8;