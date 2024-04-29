
drop table if exists mult_update_t1;
drop table if exists mult_update_t2;

create table mult_update_t1(c1 int,c2 int,c3 int) crmode row;
create table mult_update_t2(c1 int,c2 int,c3 int) crmode row;

create index mult_update_t1_x1 on mult_update_t1(c2,c3);
create index mult_update_t2_x1 on mult_update_t2(c2,c3);

insert into mult_update_t1 values(1,1,1);
insert into mult_update_t1 values(2,2,2);
insert into mult_update_t1 values(3,3,3);


insert into mult_update_t2 values(1,1,1);
insert into mult_update_t2 values(2,2,2);
insert into mult_update_t2 values(3,3,3);
commit;

update mult_update_t1 set c2=0,c3=0;
update mult_update_t1,mult_update_t2 set mult_update_t1.c2=100,mult_update_t1.c3=100,mult_update_t2.c2=200,mult_update_t2.c3=200;
update mult_update_t1,mult_update_t2 set mult_update_t1.c2=100,mult_update_t1.c3=300,mult_update_t2.c2=200,mult_update_t2.c3=400;
rollback;


drop table if exists mult_update_t1;
drop table if exists mult_update_t2;


drop table if exists mult_update_t3;
drop table if exists mult_update_t4;

create table mult_update_t3(c1 int,c2 int,c3 int) crmode page;
create table mult_update_t4(c1 int,c2 int,c3 int) crmode page;

create index mult_update_t3_x1 on mult_update_t3(c2,c3);
create index mult_update_t4_x1 on mult_update_t4(c2,c3);

insert into mult_update_t3 values(1,1,1);
insert into mult_update_t3 values(2,2,2);
insert into mult_update_t3 values(3,3,3);


insert into mult_update_t4 values(1,1,1);
insert into mult_update_t4 values(2,2,2);
insert into mult_update_t4 values(3,3,3);
commit;

update mult_update_t3 set c2=0,c3=0;
update mult_update_t3,mult_update_t4 set mult_update_t3.c2=100,mult_update_t3.c3=100,mult_update_t4.c2=200,mult_update_t4.c3=200;
update mult_update_t3,mult_update_t4 set mult_update_t3.c2=100,mult_update_t3.c3=300,mult_update_t4.c2=200,mult_update_t4.c3=400;
rollback;


drop table if exists mult_update_t3;
drop table if exists mult_update_t4;

drop table if exists mult_update_tt;
CREATE TABLE mult_update_tt (c_id int, c_first varchar(8000), c_first2 varchar(8000), c_first3 varchar(8000));
insert into mult_update_tt values(1, lpad(' ', 1000, 'a'), lpad(' ', 2000, 'a'), lpad(' ', 8000, 'a'));
commit;
update mult_update_tt t1,mult_update_tt t2 set t1.c_first2 = lpad(' ', 8000, 'a'), t2.c_first2 = lpad(' ', 7000, 'a');
drop table if exists mult_update_tt;

--bugfix: update rewrite error with global TEMPORARY table
alter system set cbo = on;
DROP TABLE if exists t_update_unnest3;
DROP TABLE if exists t_update_unnest4;

CREATE or replace procedure proc_mul_upd_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
        sqlst := 'insert into ' || tname ||' select id+'||i||',c_js||'||i||',c_vchar||'||i||',c_int+'||i||',c_num+'||i||',c_date from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/

CREATE TABLE t_update_unnest3(id INT,c_js varchar(150),c_vchar varchar(10),c_int int,c_num number,c_date date)
partition by range(id) interval(5) 
subpartition by hash(c_js)
(partition p1 values less than(10)
(subpartition p11, subpartition p12,subpartition p13),
partition p2 values less than(20)
(subpartition p21,subpartition p22,subpartition p23)
);
insert into t_update_unnest3 values(1,lpad('123abc',100,'abc'),'11',1,1.23,to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
call proc_mul_upd_insert('t_update_unnest3',1,18);
commit;

CREATE GLOBAL TEMPORARY TABLE t_update_unnest4(id INT,c_js varchar(150),c_vchar varchar(10),c_int int,c_num number,c_date date) ON COMMIT PRESERVE ROWS;
insert into t_update_unnest4 values(1,lpad('123abc',100,'abc'),'11',1,1.23,to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
call proc_mul_upd_insert('t_update_unnest4',1,18);
commit;

alter system set _OPTIM_UNNEST_SET_SUBQUERY = false; 
ALTER SYSTEM FLUSH SQLPOOL;
UPDATE t_update_unnest4 t1 SET t1.id = (SELECT t2.id FROM t_update_unnest3 partition(p2) t2,t_update_unnest3 t3 WHERE t2.id=t1.id);
alter system set _OPTIM_UNNEST_SET_SUBQUERY = true; 
ALTER SYSTEM FLUSH SQLPOOL;
UPDATE t_update_unnest4 t1 SET t1.id = (SELECT t2.id FROM t_update_unnest3 partition(p2) t2,t_update_unnest3 t3 WHERE t2.id=t1.id);
rollback;

drop table t_update_unnest3;
drop table t_update_unnest4;
alter system set cbo = off;
