--remove group by
drop table if exists t_remove_group_by;
drop table if exists t1_remove_group_by;
drop table if exists t2_remove_group_by;
drop table if exists t3_remove_group_by;
-- primary key
--primary  key
create table t_remove_group_by (a int constraint cons1_remove_group_by primary key,b int,c int);
insert into t_remove_group_by values(1,1,1);
insert into t_remove_group_by values(2,2,1);
insert into t_remove_group_by values(3,3,1);
insert into t_remove_group_by values(4,1,1);
insert into t_remove_group_by values(5,3,4);
insert into t_remove_group_by values(6,2,1);
insert into t_remove_group_by values(7,3,3);
-- unique index
create table t1_remove_group_by(a int not null,b int not null,c int);
create unique index index_remove_group on t1_remove_group_by(a,b);
insert into t1_remove_group_by values(1,1,1);
insert into t1_remove_group_by values(1,2,1);
insert into t1_remove_group_by values(1,3,1);
insert into t1_remove_group_by values(2,1,1);
insert into t1_remove_group_by values(2,3,4);
insert into t1_remove_group_by values(2,2,1);
insert into t1_remove_group_by values(3,3,3);
-- subselect
create table t2_remove_group_by(a int,b int,c int);
insert into t2_remove_group_by values(1,1,1);
insert into t2_remove_group_by values(1,4,1);
insert into t2_remove_group_by values(1,2,1);
insert into t2_remove_group_by values(2,1,1);
insert into t2_remove_group_by values(2,2,3);
--unique index nullable
create table t3_remove_group_by(a int,b int,c int);
create unique index index_remove_group_2 on t3_remove_group_by(a,b);


--DTS2019112505152
alter table t_remove_group_by add column d bool;
insert into t_remove_group_by values(8,3,null,true);
select group_concat(d) from t_remove_group_by group by a;
--DTS2019112614950
select COVAR_POP(b,c),group_concat(2) from t_remove_group_by group by a;
select rank(2) within group(order by a) from t_remove_group_by group by a;

--DTS2019121906665
drop view if exists v_remove_group_by;
create view v_remove_group_by as select * from t_remove_group_by;
drop view v_remove_group_by;

drop table t_remove_group_by;
drop table t1_remove_group_by;
drop table t2_remove_group_by;
drop table t3_remove_group_by;