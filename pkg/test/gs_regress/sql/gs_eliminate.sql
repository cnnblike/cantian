--distinct eliminate
drop table if exists t1_for_eliminate;
create table t1_for_eliminate(a int, b int, c int);
alter table t1_for_eliminate add constraint pk_t1_for_eliminate primary key(a, b);
insert into t1_for_eliminate values(1, 2, 3);
commit;
explain select distinct a, b, c from t1_for_eliminate;
alter system set _OPTIM_DISTINCT_ELIMINATION=false;
explain select distinct a, b, c from t1_for_eliminate   ;
alter system set _OPTIM_DISTINCT_ELIMINATION=true;
explain select distinct a, b from t1_for_eliminate;
explain select distinct a, c from t1_for_eliminate;
alter table t1_for_eliminate drop constraint pk_t1_for_eliminate;
create unique index uni_idx_001_t1_for_eliminate on t1_for_eliminate(a, b);
explain select distinct a, b, c from t1_for_eliminate;
explain select distinct a, b from t1_for_eliminate;
explain select distinct a, c from t1_for_eliminate;
explain select distinct (select c from dual),a,b from t1_for_eliminate;
explain select distinct (select c from dual limit 1),a,b from t1_for_eliminate;
explain select distinct (select max(c) from dual),a,b from t1_for_eliminate;
explain select distinct (select max(c) from dual),a,b from t1_for_eliminate order by 2;
explain select (select distinct (select max(t1.c) from dual) from t1_for_eliminate limit 1) from t1_for_eliminate t1;
explain select (select distinct (select max(t1.c) + t1.c from dual) from t1_for_eliminate limit 1) from t1_for_eliminate t1;
explain select (select count(*) from (select distinct t1.a,t1.b from dual) limit 1) from t1_for_eliminate t1;
explain select (select count(*) from (select distinct a,b from t1_for_eliminate) limit 1) from t1_for_eliminate t1;
explain select distinct a, b from t1_for_eliminate t1 where exists(select a from t1_for_eliminate where a = t1.a);
explain select distinct a, b from t1_for_eliminate t1 where exists(select (select t1.a from t1_for_eliminate) from t1_for_eliminate t2 where t2.a = t1.a);
explain select distinct a, b from t1_for_eliminate t1 where exists(select (select a||dummy from t1_for_eliminate,dual where a = t1.a) from t1_for_eliminate t2 where t2.a = t1.a);
explain select distinct a, b from t1_for_eliminate t1 where a in (select (select a from t1_for_eliminate,dual where a = t1.a) from t1_for_eliminate t2 where t2.a = t1.a);
explain select distinct a,b from t1_for_eliminate connect by prior a + 1 = a;
explain select distinct prior a,b from t1_for_eliminate connect by prior a + 1 = a;
explain select distinct a, b, c from t1_for_eliminate union all select a, b, c from t1_for_eliminate;
explain select distinct a, b, c from t1_for_eliminate order by 1,2,3;
explain select distinct a, b from t1_for_eliminate order by 1,2;
drop table t1_for_eliminate;
--group eliminate
drop table if exists t1_for_eliminate;
create table t1_for_eliminate(a int, b int, c int);
alter table t1_for_eliminate add constraint pk_t1_for_eliminate primary key(a, b);
insert into t1_for_eliminate values(1, 2, 3);
commit;
explain select * from t1_for_eliminate group by a, b, c;
alter system set _OPTIM_GROUP_BY_ELIMINATION=false;
explain select * from t1_for_eliminate group by a, b, c   ;
alter system set _OPTIM_GROUP_BY_ELIMINATION=TRUE;
explain select a,b from t1_for_eliminate group by a, b, c;
explain select min(a) from t1_for_eliminate group by a, b, c;
explain select count(*) from t1_for_eliminate group by a, b, c;
explain select * from t1_for_eliminate group by a, c;
explain select a,b from t1_for_eliminate group by a, c;
explain select min(a) from t1_for_eliminate group by a, c;
explain select count(*) from t1_for_eliminate group by a, c;
alter table t1_for_eliminate drop constraint pk_t1_for_eliminate;
create unique index uni_idx_001_t1_for_eliminate on t1_for_eliminate(a, b);
explain select * from t1_for_eliminate group by a, b, c;
explain select a,b from t1_for_eliminate group by a, b, c;
explain select min(a) from t1_for_eliminate group by a, b, c;
explain select count(*) from t1_for_eliminate group by a, b, c;
explain select * from t1_for_eliminate group by a, c;
explain select a,b from t1_for_eliminate group by a, c;
explain select min(a) from t1_for_eliminate group by a, c;
explain select count(*) from t1_for_eliminate group by a, c;
explain select * from t1_for_eliminate group by cube(a, b, c);
explain select * from t1_for_eliminate group by cube(a, c);
explain select min(a) from t1_for_eliminate group by cube(a, b, c);
explain select min(a) from t1_for_eliminate group by cube(a, c);
explain select (select a||dummy from dual) from t1_for_eliminate group by a,b,c;
explain select (select a from dual) from t1_for_eliminate group by a,b,c;
explain select a,b from t1_for_eliminate where a in (select count(*) from dual) group by a,b,c;
explain select a,b from t1_for_eliminate where exists (select a from dual) group by a,b,c;
explain select a,b from t1_for_eliminate where exists (select a from dual) group by a,b,c union all select distinct a, b from t1_for_eliminate;
explain select a,b from t1_for_eliminate group by a,b,c order by 1,2;
explain select a f1,b f2 from t1_for_eliminate group by a,b,c order by f1,f2;
explain select a,b from t1_for_eliminate connect by prior a + 1 = a group by a,b,c;
explain select prior a,b from t1_for_eliminate connect by prior a + 1 = a group by prior a,b,c;
alter table t1_for_eliminate modify a int null;
alter table t1_for_eliminate modify b int null;
explain select min(a) from t1_for_eliminate group by a, b, c;
explain select count(*) from t1_for_eliminate group by a, b, c;
alter table t1_for_eliminate modify b int not null;
explain select count(*) from t1_for_eliminate group by a, b, c;
drop table t1_for_eliminate;
--distinct column eliminate
drop table if exists t1_for_eliminate;
create table t1_for_eliminate(a int, b int, c int);
insert into t1_for_eliminate values(1, 2, 3);
explain select distinct * from (select distinct a, b, 1, null from t1_for_eliminate),dual;
alter system set _OPTIM_DISTINCT_ELIMINATION=false;
explain select distinct * from (select distinct a, b, 1, null from t1_for_eliminate),dual   ;
alter system set _OPTIM_DISTINCT_ELIMINATION=true;
explain select * from (select distinct a, b, 1, null from t1_for_eliminate),dual;
explain select distinct * from (select a, b, 1, null from t1_for_eliminate),dual;
explain select * from t1_for_eliminate t1 where a in (select distinct a from (select distinct a, b, 1, null from t1_for_eliminate),dual);
explain select * from t1_for_eliminate t1 where a in (select distinct a from (select distinct a, b, 1, null from t1_for_eliminate),dual where a = t1.a);
explain select * from t1_for_eliminate t1 where exists (select distinct a from (select distinct a, b, 1, null from t1_for_eliminate),dual where a = t1.a);
explain select * from t1_for_eliminate t1 where exists (select a from (select distinct a, b, 1, null from t1_for_eliminate),dual where a = t1.a);
explain select distinct * from (select distinct (select a from dual), b, 1, null from t1_for_eliminate),dual;
explain select distinct * from (select distinct (select a from dual), b, 1, null from t1_for_eliminate order by 2),dual;
explain select distinct * from (select distinct a, b, 1, null from t1_for_eliminate where exists(select dummy from dual where rownum = a)),dual;
explain select distinct * from (select distinct a, 1, null from t1_for_eliminate where exists(select dummy from dual where rownum = a)),dual;
explain select distinct * from (select distinct a, 1, null from t1_for_eliminate where a in (select count(dummy) from dual where rownum = a)),dual;
explain select distinct * from (select distinct a, 1, null from t1_for_eliminate where a in (select count(dummy) from dual where rownum = a)),dual union all select distinct * from (select distinct (select a from dual), 1, null from t1_for_eliminate),dual;
explain select distinct * from (select distinct (select a from dual), b, c f3, null from t1_for_eliminate),dual order by 2,f3;
explain select distinct * from (select distinct (select a from dual), b,c, 1, null from t1_for_eliminate),dual connect by prior b = c;
drop table t1_for_eliminate;
--project column eliminate
drop table if exists t1_for_eliminate;
create table t1_for_eliminate(a int, b int, c int);
insert into t1_for_eliminate values(1, 2, 3);
create index idx_1_t1_for_eliminate on t1_for_eliminate(a);
create index idx_2_t1_for_eliminate on t1_for_eliminate(a, b);
create index idx_3_t1_for_eliminate on t1_for_eliminate(a, b, c);
explain select a from (select a, b, c from t1_for_eliminate), dual;
alter system set _OPTIM_PROJECT_LIST_PRUNING = false;
explain select a from (select a, b, c from t1_for_eliminate), dual   ;
alter system set _OPTIM_PROJECT_LIST_PRUNING = true;
explain select a from (select a, b, c from t1_for_eliminate where b > 0), dual;
explain select a from (select a, b, c, rowid from t1_for_eliminate), dual;
explain select a from (select a, max(a) from t1_for_eliminate group by a), dual;
explain select a from (select a, b, c from t1_for_eliminate union all select a, b, c from t1_for_eliminate), dual;
explain select a from (select a, b, c from t1_for_eliminate minus select a, b, c from t1_for_eliminate), dual;
explain select * from t1_for_eliminate where exists (select a, b, c from t1_for_eliminate);
explain select * from t1_for_eliminate where a in (select a from t1_for_eliminate);
drop table t1_for_eliminate;
--sub-select table eliminate
drop table if exists t1_for_eliminate;
create table t1_for_eliminate(a int, b int, c int);
insert into t1_for_eliminate values(1, 2, 3);
explain select a, b from (select a, b, c from t1_for_eliminate), dual;
alter system set _OPTIM_SUBQUERY_ELIMINATION = false;
explain select a, b from (select a, b, c from t1_for_eliminate), dual   ;
alter system set _OPTIM_SUBQUERY_ELIMINATION = true;
explain select a, b from (select a, b, rownum c from t1_for_eliminate), dual;
explain select a, b from (select a, b, c from t1_for_eliminate), dual connect by prior a = a;
explain select a, b from (select : a, b, c from t1_for_eliminate), dual;
drop view if exists v1_for_eliminate;
create view v1_for_eliminate as select a, b, c from t1_for_eliminate;
explain select a, b from v1_for_eliminate, dual;
explain select * from  dual where exists (select a, b, c from t1_for_eliminate);
explain select max(a) over (partition by b), b from (select a, b, c from t1_for_eliminate), dual;
explain select max(a) , b from (select a, b, c from t1_for_eliminate), dual group by a,b;
explain select a, b from (select a, b, c from t1_for_eliminate where a > 0), dual connect by prior a = a;
explain select a, b from (select a, b, c from t1_for_eliminate,dual), dual;
explain select * from V$PL_MANAGER,dual;
explain select * from (select * from dual), dual;
explain select a, b,c from (select a, b, rownum c from t1_for_eliminate), dual;
drop table t1_for_eliminate;
drop view v1_for_eliminate;
drop table if exists t1_for_eliminate;
create table t1_for_eliminate(a int, b int, c int);
insert into t1_for_eliminate values(1, 2, 3);
explain select a, b from (select * from t1_for_eliminate, dual);
explain select a, b from (select * from t1_for_eliminate where 1 != 0) connect by prior a + 1 = b;
explain select a, b from (select a, b from t1_for_eliminate) where a <= 1;
explain select a, b from (select * from t1_for_eliminate, dual order by a);
explain select a, b from (select * from t1_for_eliminate, dual) order by a;
explain select a, b from (select distinct * from t1_for_eliminate, dual);
explain select a, b from (select  max(a) a, b from t1_for_eliminate, dual group by a, b);
explain select max(a) from (select * from t1_for_eliminate, dual);
explain select a from (select * from t1_for_eliminate, dual) group by a;
explain select a, b from (select  max(a) over(partition by b) a, b from t1_for_eliminate, dual);
explain select max(a) over(partition by a order by b), b from (select * from t1_for_eliminate, dual);
explain select a, b from (select * from t1_for_eliminate connect by prior a + 1 = b);
explain select a, b from (select * from t1_for_eliminate where a < 1000) connect by prior a + 1 = b;
explain select a, b from (select rownum a, b from t1_for_eliminate) where rownum <= 1;
explain select a, case when b > 0 then 1 else 0 end  b from (select * from t1_for_eliminate, dual);
explain select a, b from (select * from t1_for_eliminate, dual) where rownum <= 1;
explain select * from V$PL_MANAGER;
drop table t1_for_eliminate;

-- join elimination
drop table if exists t1_for_eliminate;
create table t1_for_eliminate(a int, b int, c int);
CREATE UNIQUE INDEX INDEX_JOIN_ELIMINATE ON t1_for_eliminate(A);
EXPLAIN SELECT COUNT(*) FROM t1_for_eliminate T0 LEFT JOIN t1_for_eliminate T1  ON T1.A = T0.A; 
ALTER SYSTEM SET _OPTIM_JOIN_ELIMINATION = FALSE;
EXPLAIN SELECT COUNT(*) FROM t1_for_eliminate T0 LEFT JOIN t1_for_eliminate T1  ON T1.A = T0.A  ; 
ALTER SYSTEM SET _OPTIM_JOIN_ELIMINATION = TRUE;

--order by elimination
EXPLAIN SELECT * FROM (select DISTINCT t1.B  AS A from t1_for_eliminate t1 order by t1.B) t2 inner join t1_for_eliminate t3 on t3.a = t2.a order by t3.a;
ALTER SYSTEM SET _OPTIM_ORDER_BY_ELIMINATION = FALSE;
EXPLAIN SELECT * FROM (select DISTINCT t1.B  AS A from t1_for_eliminate t1 order by t1.B) t2 inner join t1_for_eliminate t3 on t3.a = t2.a order by t3.a  ;
ALTER SYSTEM SET _OPTIM_ORDER_BY_ELIMINATION = TRUE;
drop table t1_for_eliminate;
--20200529
select  
  subq_1.c1 as c0, 
  subq_1.c1 as c1, 
  subq_1.c0 as c2, 
  subq_1.c0 as c3, 
  subq_1.c3 as c4, 
  subq_1.c3 as c5, 
  subq_1.c1 as c6, 
  subq_1.c1 as c7, 
  subq_1.c0 as c8, 
  subq_1.c1 as c9, 
  subq_1.c0 as c10, 
  subq_1.c0 as c11
from 
  (select  
        subq_0.c0 as c0, 
        subq_0.c0 as c1, 
        subq_0.c0 as c2, 
        case when false then subq_0.c0 else subq_0.c0 end
           as c3
      from 
        (select  
              ref_0.PASSWORD as c0
            from 
              SYS.SYS_USER_HISTORY as ref_0
            where ref_0.USER# is NULL
              and (ref_0.PASSWORD is not NULL)) as subq_0
      where 40 is NULL
      limit 99) as subq_1
where subq_1.c0 is not NULL;

-- DTS202012030I6K2BP0H00
create or replace type str_split_table is table of varchar2 (4000);
/

create or replace function fn_split(in_str       in varchar2,
                                    in_delimiter in varchar2)
  return str_split_table as
  v_result_table str_split_table := str_split_table();
  v_length number := length(in_str);
  v_val varchar2(4000);
  v_start  number := 1;
  v_index  number;
  v_idx number := 0;
begin
  while (v_start <= v_length) loop
    v_index := instr(in_str, in_delimiter, v_start);

    if v_index = 0 then
      v_val := substr(in_str, v_start);
      v_start := v_length + 1;
    else
      v_val := substr(in_str, v_start, v_index - v_start);
      v_start := v_index + 1;
    end if;
    v_idx := v_idx + 1;

    v_result_table.extend;
    v_result_table(v_idx) := v_val;
  end loop;

  return v_result_table;
end;
/

drop table if exists func_as_table_rewrite_t1;
drop table if exists func_as_table_rewrite_t2;
create table func_as_table_rewrite_t1(
  owner varchar(400 byte)
);
insert into func_as_table_rewrite_t1 values('abc;def');

create table func_as_table_rewrite_t2(
  full_name varchar(400 byte) 
);
insert into func_as_table_rewrite_t2 values('myname');

select 
    t.owner as owner_uuid, 
    (select x.full_name from func_as_table_rewrite_t2 x, (select column_value from table(cast(fn_split(t.owner,';') as str_split_table))) st where rownum=1) 
from func_as_table_rewrite_t1 t;

-- DTS2020120804AHKTP0G00
select * from func_as_table_rewrite_t1 t 
where exists (select column_value from table(cast(fn_split(t.owner,';') as str_split_table)) where column_value = t.owner);

explain 
select * from func_as_table_rewrite_t1 t 
where exists (select column_value from table(cast(fn_split(t.owner,';') as str_split_table)) where column_value = t.owner);
insert into func_as_table_rewrite_t1 values('ccc;def');
select (select max(column_value) from table(cast(fn_split(t1.owner ,',') as str_split_table)) where column_value = t1.owner) as max from func_as_table_rewrite_t1 t1;
drop table func_as_table_rewrite_t1;
drop table func_as_table_rewrite_t2;
drop function fn_split;
drop type str_split_table;