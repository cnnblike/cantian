drop user if exists quote_test;
drop table if exists t1;
drop table if exists "t1";
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;
drop table if exists "table";
drop view if exists v1;
drop view if exists "v1";
drop view if exists v2;
drop table if exists "quote_test"."drop";
drop table if exists "QUOTE_TEST"."Drop";

create user quote_test identified by 'Huawei123';
grant dba to quote_test;

create table t1(a int, b int);
create table "t1"(f1 int, f2 int);
create table t2(a int, "a" int, b int, "b" int);
create table t3(f1 int,f2 int, f3 int)
partition by list(f1)
(
partition p1   values (1,2,3,4,5),
partition "p1" values (default)
);
create table t4(f1 int, f2 int, f3 int)
PARTITION BY RANGE(f1)
(
 PARTITION p2   values less than(10),
 PARTITION "p2" values less than(MAXVALUE)
);
create table table(index int);
create table "table"("index" int);
create index QUOTA_idx_t1__1 on t2(a);
create index "QUOTA_idx_t1__1" on t2("a");
create index idx_t1_2 on t2(b, "b");
create view v1 as select * from t1;
create view "v1" as select * from "t1";
create view v2(f1,"f1") as select * from t1;
insert into table values(1);
insert into "table" values(1);
insert into "table"(index) values(10);
insert into "table"("index") values(10);
insert into "table"("index") values(20);
insert into t2 values(1,1,1,1);
insert into t2 values(10,1,5,1);
select * from t1;
select * from "t1";
select * from table;
select index from table;
select "index" from "table";
select "index" from "table" where "index" = 10;
select "index" from "table" where "index" > 10 group by index;
select "index" from "table" where "index" >= 10 group by "index" order by 1;
select "index" from "table" where "index" >= 10 group by "index" order by index;
select "index" from "table" where "index" >= 10 group by "index" order by "index";
update "table" set "index" = 5 where "index"=1;
delete from "table" where "index"=5;
merge into "table" using dual on (1=1) when not matched then insert ("index") values(100);
create table "quote_test"."drop"("Table" int, "inDex" int);
create table "QUOTE_TEST"."Drop"("Table" int, "inDex" int);
select * from "quote_test"."drop";
select * from v1;
select * from "v1";
select * from v2;
select * from t2 where "a"=1;

alter table "quote_test"."drop" add a4 varchar(10) default 'abcd';
alter table "QUOTE_TEST"."Drop" modify "inDex" varchar(10);
alter table "QUOTE_TEST"."Drop" rename column "inDex" to dddd;
alter table "QUOTE_TEST"."Drop" drop column dddd;
select * from "quote_test"."drop";
select * from "QUOTE_TEST"."Drop";
select * from `QUOTE_TesT`.`Drop`;

drop user if exists quote_test;
drop table if exists t1;
drop table if exists "t1";
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;
drop table if exists "table";
drop view if exists v1;
drop view if exists "v1";
drop view if exists v2;
drop table if exists "quote_test"."drop";
drop table if exists "QUOTE_TEST"."Drop";