drop table if exists t_res_sysdate;
create table t_res_sysdate(curdate date, current_date date, current_timestamp timestamp, systimestamp timestamp);
insert into t_res_sysdate values(curdate, current_date, current_timestamp, systimestamp+1);
select sleep(1);
select curdate, current_date, current_timestamp, systimestamp from t_res_sysdate where curdate=sysdate;
--select curdate-current_date, current_timestamp-systimestamp from t_res_sysdate where curdate=current_date;
update t_res_sysdate set curdate = sysdate,current_date=sysdate;

drop table if exists t_res_bool;
create table t_res_bool(true bool, false bool);
insert into t_res_bool values(true,false),(0,1);
select true,false from t_res_bool where true=0;
select true,false from t_res_bool where false=0;

drop table if exists t_res_unit;
create table t_res_unit(year int, month int, day int, hour int, minute int, second int, microsecond int, quarter int, week int);
insert into t_res_unit values(2018,8,24,11,22,33,444440,3,7);
select year,month,day,hour,minute,second from t_res_unit;

drop table if exists t_res_dml;
create table t_res_dml(inserting int, deleting int, updating int);
insert into t_res_dml values(1,2,3);
select inserting,deleting,updating from t_res_dml;

drop table if exists t_res_connby;
create table t_res_connby(connect_by_iscycle int, connect_by_isleaf int);
insert into t_res_connby values(1,2),(3,4);
select connect_by_iscycle, connect_by_isleaf from t_res_connby order by connect_by_iscycle;


drop table if exists t_res_rowscn;
drop table if exists t_res_rowscn2;
create table t_res_rowscn(i bigint) crmode row;
insert into t_res_rowscn values(1),(2);
commit;
insert into t_res_rowscn values(3),(4),(5);
commit;
insert into t_res_rowscn values(6);
insert into t_res_rowscn values(7);
insert into t_res_rowscn values(8);
insert into t_res_rowscn values(9);
commit;
select count(*) from t_res_rowscn group by rowscn order by rowscn;
update t_res_rowscn set i=10 where rowscn = 1;
--error:
insert into t_res_rowscn values(rowscn);
select * from t_res_rowscn limit rowscn;
--support update
update t_res_rowscn set rowscn = 1;
--change scn
update t_res_rowscn set i=10 where rowscn in (select rowscn from t_res_rowscn where i < 4);
commit;
select i,count(*) from t_res_rowscn group by rowscn, i order by rowscn, i;
update t_res_rowscn set i = rowscn;
select count(*) from t_res_rowscn group by i order by i;
create table t_res_rowscn2 as select rowscn,i from t_res_rowscn;
create table t_res_rowscn2 as select rowscn r,i from t_res_rowscn;
