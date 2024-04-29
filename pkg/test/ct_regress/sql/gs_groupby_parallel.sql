-- group by
drop table if exists tbl_group1;
create table tbl_group1(a int, b int, c double);
insert into tbl_group1 values(1, 1, 1.1), (1, 2, 2.1), (2, 3, 3.1), (2, 4, 4.1), (2, 5, 5.1), (1, 6, 6.12);

insert into tbl_group1 select * from tbl_group1;
commit;

-- parallel group by
drop table if exists tbl_group;
create table tbl_group(a int, b int, c double);

create or replace PROCEDURE gen_data_tbl_group(a IN  INTEGER, min_b IN INTEGER, max_b IN  INTEGER)
as
    i  INTEGER := 0;
begin
    FOR i IN min_b..max_b LOOP
            BEGIN
                insert into tbl_group values((a+i) % 10, i, (a+i)*1.2);
            END;
    END LOOP;
    commit;
    RETURN;
END ;
/


call gen_data_tbl_group(1,1,50000);

select a, max(b) from tbl_group group by a order by 1,2;
select /*+ parallel(4) */ a, max(b) from tbl_group group by a order by 1,2;

select a, min(b) from tbl_group group by a order by 1,2;
select /*+ parallel(4) */ a, min(b) from tbl_group group by a order by 1,2;

select a, avg(b) from tbl_group group by a order by 1,2;
select /*+ parallel(4) */ a, avg(b) from tbl_group group by a order by 1,2;

select a, count(b) from tbl_group group by a order by 1,2;
select /*+ parallel(4) */ a, count(b) from tbl_group group by a order by 1,2;

select a, avg(b), sum(b), count(b), sum(b)/count(b) from tbl_group group by a order by 1,2,3;
select /*+ parallel(4) */ a, avg(b), sum(b)/count(b) from tbl_group group by a order by 1,2,3;

select /*+ parallel(4) */ a, max(b) from tbl_group group by a order by 1,2;

--not supportted
--select /*+ parallel(2) */ a, group_concat(b) from tbl_group where a=10 group by a;

--not support having, go to normal process(not parallel)
select /*+ parallel(4) */ a, max(b) from tbl_group group by a having a < 100 order by 1,2;
--not support subquery and join, go to normal process(not parallel)
select /*+ parallel(4) */ count(1) from (select a from tbl_group group by a);
select /*+ parallel(4) */ a, count(1) from (select a from tbl_group) group by a order by 1,2;
select /*+ parallel(4) */ distinct a, max(b) from tbl_group group by a order by 1,2;
select /*+ parallel(4) */ a,(select max(b) from tbl_group1 where a = 2) as max_b from tbl_group group by a order by 1;
select /*+ parallel(4) */ a,max(b) from tbl_group where a in (select a from tbl_group1) group by a order by 1;
select /*+ parallel(4) */ t2.a,max(t1.a),min(t2.b) from tbl_group1 t1 join tbl_group t2 on t1.a = t2.a group by t2.a order by 1,2,3;
(select /*+ parallel(4) */ a,max(b) from tbl_group1 group by a order by 1,2 limit 2) union all
(select a,max(b) from tbl_group group by a order by 1,2 limit 2) order by 1,2;
-------------------------test multi group exprs-----------------------------------
truncate table tbl_group;
create or replace PROCEDURE gen_data_tbl_group1(a IN  INTEGER, min_b IN INTEGER, max_b IN  INTEGER)
as
    i  INTEGER := 0;
    j  INTEGER := 0;
begin
    FOR i IN min_b..max_b LOOP
            BEGIN
                FOR j IN 0..3 LOOP
                    BEGIN
                        insert into tbl_group values((a+i) % 10, (i+j+1) % 4, (a+i)*1.2);
                    END;
                END LOOP;
            END;
    END LOOP;
    commit;
    RETURN;
END ;
/

call gen_data_tbl_group1(1,1,50000);

select a,b,max(c) from tbl_group group by a,b order by a,b;
select /*+ parallel(4) */ a, b, max(c) from tbl_group group by a,b order by a,b desc;
select /*+ parallel(4) */ a, b, max(c) from tbl_group group by a,b order by a,b;
select /*+ parallel(4) */ distinct a, b, max(c) from tbl_group group by a,b order by a,b;
drop table tbl_group;

--plan_node_query_sort_par
drop table if exists tbl_group;
create table tbl_group(a int, b int, c double);
create or replace PROCEDURE gen_data_tbl_group(a IN  INTEGER, min_b IN INTEGER, max_b IN  INTEGER)
as
    i  INTEGER := 0;
begin
    FOR i IN min_b..max_b LOOP
            BEGIN
                insert into tbl_group values((a+i) % 10, i, (a+i)*1.2);
            END;
    END LOOP;
    commit;
    RETURN;
END ;
/
call gen_data_tbl_group(1,1,2000);
select /*+ parallel(4) */ a from tbl_group where a = 1 order by a;
drop table tbl_group;

drop table if exists t_par_group_1;
drop table if exists t_par_group_2;
create table t_par_group_1(a int, b int, c varchar(10), d number, e blob);
create table t_par_group_2(a int, b int, c varchar(10), d number);
insert into t_par_group_1 values(1, 2, 'abc', 1.23, 'aaaaaaa');
insert into t_par_group_2 values(1, 2, 'abc', 1.23);
CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
		sqlst := 'insert into ' || tname ||' select a+'||i||', b+'||i||', c||'||i||', d+'||i||', e from '||tname|| ' where a=1';
        execute immediate sqlst;
		execute immediate sqlst;
  END LOOP;
END;
/
CREATE or replace procedure proc_insert1(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
		sqlst := 'insert into ' || tname ||' select a+'||i||', b+'||i||', c||'||i||', d+'||i||' from '||tname|| ' where a=1';
        execute immediate sqlst;
		execute immediate sqlst;
  END LOOP;
END;
/
call proc_insert('t_par_group_1',1,10);
call proc_insert1('t_par_group_2',1,5);
commit;

select /*+parallel(2)*/ a, sum(b), avg(d),  max(c), stddev(b), stddev_samp(d), stddev_pop(a), var_pop(a), var_samp(distinct a) from t_par_group_2 group by a order by sum(b);
select /*+parallel(2)*/ array_agg(c), cume_dist(2)WITHIN GROUP (ORDER BY b asc) from t_par_group_2 group by a having CUME_DIST(2)WITHIN GROUP (ORDER BY B ASC) = 1;
select /*+parallel(8)*/ sum(a), count(a), avg(a), min(a), max(a), sum(b), count(b), avg(b), min(b), max(b), count(c), min(c), max(c),
 sum(d), count(d), avg(d), min(d), max(d), count(e) from t_par_group_1 group by a order by var_pop(a),sum(a) limit 2 offset 4;
select /*+parallel(8)*/ sum(t1.a), count(t1.a), avg(t1.a), min(t1.a), max(t1.a), sum(t1.b), count(t1.b), avg(t1.b), min(t1.b), max(t1.b), count(t1.c), min(t1.c), max(t1.c),
sum(t2.d), count(t2.d), avg(t2.d), min(t2.d), max(t2.d), count(t1.e),sum(t2.a+1), count(t2.a+1), avg(t2.a+1), min(t2.a+1), max(t2.a+1), sum(t2.b+1), count(t2.b+1), avg(t2.b+1), 
min(t2.b+1), max(t2.b+1),sum(t2.d+1), count(t2.d+1), avg(t2.d+1), min(t2.d+1), max(t2.d+1) from t_par_group_1 t1 left join t_par_group_2 t2 on t1.a = t2.a 
group by t1.a,t2.b,t1.c,t2.d order by 1,6,11 limit 6;
select  /*+parallel(8)*/ max(a || b || c || d)  from t_par_group_1 group by c order by 1;
SELECT /*+parallel(4)*/ distinct mod(hash(a),5), max(sysdate) - min(sysdate) FROM t_par_group_1 GROUP BY a order by 1;
select /*+parallel(5)*/ a, sum(distinct b) from t_par_group_2 group by (a),(c), ASCII(ASCII('='))  having sum(a) > 5 order by sum(distinct a);
select /*+parallel(5)*/ sum(distinct b) from t_par_group_2 group by hex(a) order by 1;
select /*+parallel(4)*/ d, group_concat(d) from t_par_group_2 pivot(AVG(a) for b in (1,3,5)) group by d having d > 6;
select /*+parallel(5)*/ avg(distinct b) from t_par_group_2 group by ROLLUP((a), (b, c)) order by 1;
select /*+parallel(5)*/ distinct avg(distinct t1.b) from t_par_group_2 t1,t_par_group_1 t2,t_par_group_2 t3 where t1.a > t3.a or t2.b < t3.b 
group by t1.a,t3.a,t2.b,t3.b order by 1 limit 5;
select /*+parallel(4)*/ d, group_concat(distinct a,d) from t_par_group_2 group by d order by group_concat(a,d);

drop table t_par_group_1;
drop table t_par_group_2;