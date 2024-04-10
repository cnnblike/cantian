drop table if exists explain_predicate_t1;
create table explain_predicate_t1
(
    id int,
    int_c1 int,
    int_c2 int,
    int_c3 int,
    str_c1 varchar(50),
    f1 integer,
    f2 binary_uint32,
    f3 bigint,
    f4 binary_double,
    f5 double,
    f6 float,
    f7 real,
    f8 number(12,3),
    f9 decimal(20,5),
    f10 char(30),
    f11 nchar(30),
    f12 varchar(30),
    f13 varchar2(30),
    f14 nvarchar(30),
    f15 date,
    f16 datetime,
    f17 timestamp,
    f18 timestamp(3) with time zone,
    f19 timestamp(3) with local time zone,
    f20 boolean,
    f21 interval year(4) to month,
    f22 interval day(7) to second(6),
    f23 int[],
    f24 binary(20),
    f25 varbinary(20),
    f26 raw(100),
    f27 clob
);
alter table explain_predicate_t1 add constraint "PK_EXPLAIN_PREDICATE_T1" primary key(id);
create index idx_explain_pred_t1_1 on explain_predicate_t1(int_c1);
create index idx_explain_pred_t1_2 on explain_predicate_t1(int_c2, int_c3);
create index idx_explain_pred_t1_3 on explain_predicate_t1(upper(str_c1));

drop table if exists explain_predicate_t2;
create table explain_predicate_t2
(
    id int,
    int_c1 int,
    str_c1 varchar(50),
    f1 integer,
    f2 binary_uint32,
    f3 bigint,
    f4 binary_double,
    f5 double
);
alter table explain_predicate_t2 add constraint "PK_EXPLAIN_PREDICATE_T2" primary key(id);
create index idx_explain_pred_t2_1 on explain_predicate_t2(int_c1);

drop table if exists explain_predicate_t3;
create table explain_predicate_t3
(
    id int,
    int_c1 int,
    str_c1 varchar(50)
)
partition by range(int_c1)
(
partition p1 values less than (100),
partition p2 values less than (200),
partition p3 values less than (300)
);
alter table explain_predicate_t3 add constraint "PK_EXPLAIN_PREDICATE_T3" primary key(id);


-- CT_TYPE_INTEGER
explain plan for select * from explain_predicate_t1 where f1 = 1;
-- CT_TYPE_UINT32
explain plan for select * from explain_predicate_t1 where f2 = cast(1 as binary_uint32);
-- CT_TYPE_BIGINT
explain plan for select * from explain_predicate_t1 where f3 = cast(1 as bigint);
-- CT_TYPE_NUMBER
explain plan for select * from explain_predicate_t1 where f4 = 4.5;
-- CT_TYPE_REAL
explain plan for select * from explain_predicate_t1 where f7 = cast(4.5 as real);
-- CT_TYPE_BOOLEAN
explain plan for select * from explain_predicate_t1 where f20 = cast('true' as boolean);
-- CT_TYPE_TYPMODE
explain plan for select * from explain_predicate_t1 where f23 = cast('[1,2,3]' as int[]);
-- CT_TYPE_CHAR
explain plan for select * from explain_predicate_t1 where f10 = 'a';
-- CT_TYPE_VARCHAR
explain plan for select * from explain_predicate_t1 where f12 = cast(123 as varchar(30));
-- CT_TYPE_BINARY
explain plan for select * from explain_predicate_t1 where f24 = cast('123' as binary(20));
-- CT_TYPE_VARBINARY
explain plan for select * from explain_predicate_t1 where f25 = cast('123' as varbinary(20));
-- CT_TYPE_RAW
explain plan for select * from explain_predicate_t1 where f26 = cast('123' as raw(100));
-- CT_TYPE_DATE
explain plan for select * from explain_predicate_t1 where f15 = to_date('02-MAY-2020', 'DD-MON-YYYY');
-- CT_TYPE_TIMESTAMP
explain plan for select * from explain_predicate_t1 where f17 = to_timestamp('2020-05-01 00', 'YYYY-MM-DD HH24');
-- CT_TYPE_TIMESTAMP_TZ
explain plan for select * from explain_predicate_t1 where f18 = cast(to_timestamp('2020-05-01 00', 'YYYY-MM-DD HH24') as timestamp with time zone);
-- CT_TYPE_TIMESTAMP_LTZ
explain plan for select * from explain_predicate_t1 where f19 = cast(to_timestamp('2020-05-01 00', 'YYYY-MM-DD HH24') as timestamp with local time zone);
-- CT_TYPE_INTERVAL_YM
explain plan for select * from explain_predicate_t1 where f21 = cast('50-0' as interval year(4) to month);
-- CT_TYPE_INTERVAL_DS
explain plan for select * from explain_predicate_t1 where f22 = cast('1231 12:3:4.1234' as interval day(7) to second(6));
-- CT_TYPE_ITVL_UNIT
explain plan for select * from explain_predicate_t1 where f1 = extract(second from sysdate);
explain plan for select * from explain_predicate_t1 where f1 = extract(minute from sysdate);
explain plan for select * from explain_predicate_t1 where f1 = extract(hour from sysdate);
explain plan for select * from explain_predicate_t1 where f1 = extract(day from sysdate);
explain plan for select * from explain_predicate_t1 where f1 = extract(month from sysdate);
explain plan for select * from explain_predicate_t1 where f1 = extract(year from sysdate);

-- comparators && or/and conditon
explain plan for select * from explain_predicate_t1 where f1 + 1 > 1 and f1 - 1 < 10;
explain plan for select * from explain_predicate_t1 where f1 * 2 >= 100 or f1 / 2 <= 20;
explain plan for select * from explain_predicate_t1 where f1 % 2 != 100;
explain plan for select * from explain_predicate_t1 where f1 ^ 2 = any(81,100);
explain plan for select * from explain_predicate_t1 where f1 | 2 = 10;
explain plan for select * from explain_predicate_t1 where (f1 >> 2,f2) in ((20,30),(40,50));
explain plan for select * from explain_predicate_t1 where f1 << 2 != any(64, 100) and -f1 not in (-5, -7) and f10 is null and f11 is not null and 
f12 || 'test' like '%test' and f12 not like '%string';
explain plan for select * from explain_predicate_t1 where f10 regexp '1$' or f10 not regexp '2$' or f3 between 10 and 20 or f4 not between 20.333 and 33.333 or 
regexp_like(f11,'test_[[:digit:]]{3}1$') or not regexp_like(f13,'test_[[:digit:]]{3}1$');
explain plan for select * from explain_predicate_t1 where str_c1 like '12_%' escape '_';
explain plan for select * from explain_predicate_t1 where str_c1 not like '12_%' escape '_';
explain plan for select * from explain_predicate_t1 where f1 >= any(10,20,30);
explain plan for select * from explain_predicate_t1 where f1 > any(10,20,30);
explain plan for select * from explain_predicate_t1 where f1 < any(10,20,30);
explain plan for select * from explain_predicate_t1 where f1 <= any(10,20,30);
explain plan for select * from explain_predicate_t1 where f1 = all(10,20,30);
explain plan for select * from explain_predicate_t1 where f1 != all(10,20,30);
explain plan for select * from explain_predicate_t1 where f1 >= all(10,20,30);
explain plan for select * from explain_predicate_t1 where f1 > all(10,20,30);
explain plan for select * from explain_predicate_t1 where f1 < all(10,20,30);
explain plan for select * from explain_predicate_t1 where f1 <= all(10,20,30);
explain plan for select * from explain_predicate_t1 where f10 is json or f11 is not json;

-- reserved words
explain plan for select * from explain_predicate_t1 where connect_by_iscycle = 1 start with id < 10 connect by nocycle int_c1 = 10;
explain plan for select * from explain_predicate_t1 where connect_by_isleaf = 1 start with id < 10 connect by nocycle int_c1 = 10;
explain plan for select * from explain_predicate_t1 where level = 1 start with id < 10 connect by nocycle int_c1 = 10;
explain plan for select * from explain_predicate_t1 where default < 10;
explain plan for select * from explain_predicate_t1 where nullif(TRUE,FALSE);
explain plan for select * from explain_predicate_t1 where f10 = null;
explain plan for select * from explain_predicate_t1 where rownum < 10;
explain plan for select * from explain_predicate_t1 where rowid < 10;
explain plan for select * from explain_predicate_t1 where rowscn < 10;
explain plan for select * from sys_dummy where sessiontimezone = dbtimezone;
explain plan for select * from sys_dummy where sysdate = current_date;
explain plan for select * from sys_dummy where systimestamp = current_timestamp;
explain plan for select * from sys_dummy where localtimestamp = utc_timestamp;
explain plan for select * from sys_dummy where user = dummy;

-- expression type
-- EXPR_NODE_COLUMN
explain plan for select * from explain_predicate_t1 where f23[1] = 5;
explain plan for select * from explain_predicate_t1 t1 where sys.t1.f1 = 5;
explain plan for select * from explain_predicate_t1 where sys.explain_predicate_t1.f1 = 5;
-- EXPR_NODE_GROUP
explain plan for select * from explain_predicate_t1 t1 where exists(select f1, max(f2) from explain_predicate_t2 where id < 20 group by f1 having f1 < 1000 order by f1);
-- EXPR_NODE_PARAM
explain plan for select * from explain_predicate_t1 where f1 = ?;
-- EXPR_NODE_STAR + EXPR_NODE_AGGR
explain plan for select * from explain_predicate_t1 where f1 = (select count(*) from explain_predicate_t2);
-- EXPR_NODE_CASE
explain plan for select * from explain_predicate_t1 where (case when id > 500 then 1 else 0 end) = 1;
explain plan for select * from explain_predicate_t1 where (case id when 500 then 1 when 600 then 2 else 3 end) = 2;
-- EXPR_NODE_FUNC
explain plan for select * from explain_predicate_t1 where lnnvl(int_c1 > 1500);
explain plan for select * from explain_predicate_t1 where if(id > 5,true,false);
explain plan for select f1, group_concat(f12, ?) from explain_predicate_t1 group by f1 having group_concat(f12 order by f1) like '%a';
explain plan for select * from explain_predicate_t1 where trim(f12, 'A') like 'test%' and f13 ::numeric * f13 is not null;
-- EXPR_NODE_USER_FUNC
drop package if exists sys.predicate_pack;
create or replace package sys.predicate_pack
is 
  function predicate_func(v_id int) return int;
end;
/

create or replace package body sys.predicate_pack
is
  function predicate_func(v_id int) return int
is
  v_num int;
  begin
    v_num := v_id + 2;
    return v_num;
  end;
end;
/

explain plan for select * from explain_predicate_t1 t1 where sys.predicate_pack.predicate_func(t1.id) = 10;
drop package sys.predicate_pack;
-- EXPR_NODE_SELECT
explain plan for select * from explain_predicate_t1 t1 where 
exists(select f1, max(f2) from explain_predicate_t2 where id < 20 group by f1 having f1 < 1000 limit 10 offset 2) or int_c1 < 100;

explain plan for select * from explain_predicate_t1 t1 where 
exists(select f1, max(f2) from explain_predicate_t2 where id < 20 group by f1, null having f1 < 1000 limit 10 offset 2) or int_c1 < 100;

explain plan for select * from explain_predicate_t1 t1 where 
exists(select f1, f2 from sys.explain_predicate_t2 t2 where id < 20 order by f1, f2 desc limit 10 offset ?) or int_c1 < 100;

explain plan for select * from explain_predicate_t1 t1 where 
exists(select * from explain_predicate_t3 partition(p1) where id < 20 order by f1 limit ? offset 1 + ?) or int_c1 < 100;

explain plan for select * from explain_predicate_t1 t1 where 
exists(select f1, f3, max(f2) from explain_predicate_t2 where id < 20 group by grouping sets(f1,f3, NULL) having f1 < 1000 order by f1) or int_c1 < 100;

explain plan for select * from explain_predicate_t1 t1 where t1.f1 = (select f2 from explain_predicate_t2 t2 where t1.f3 = t2.f3);
explain plan for select * from explain_predicate_t1 t1 where (t1.f1, t1.f2) in (select count(*) as count, f2 from explain_predicate_t2 t2 where t1.f3 = t2.f3 group by f2);

-- select node type
explain plan for select * from explain_predicate_t1 t1 where exists(select id from explain_predicate_t1 union select id from explain_predicate_t2) or int_c1 < 100;
explain plan for select * from explain_predicate_t1 t1 where exists(select id from explain_predicate_t1 union all select id from explain_predicate_t2) or int_c1 < 100;
explain plan for select * from explain_predicate_t1 t1 where exists(select id from explain_predicate_t1 minus select id from explain_predicate_t2) or int_c1 < 100;
explain plan for select * from explain_predicate_t1 t1 where exists(select id from explain_predicate_t1 intersect select id from explain_predicate_t2) or int_c1 < 100;
explain plan for select * from explain_predicate_t1 t1 where exists(select id from explain_predicate_t1 intersect all select id from explain_predicate_t2) or int_c1 < 100;
explain plan for select * from explain_predicate_t1 t1 where exists(select id from explain_predicate_t1 except select id from explain_predicate_t2) or int_c1 < 100;
explain plan for select * from explain_predicate_t1 t1 where exists(select id from explain_predicate_t1 except all select id from explain_predicate_t2) or int_c1 < 100;
-- subselect table + distinct
explain plan for select * from explain_predicate_t1 t1 where t1.f1 = (select f2 from (select distinct f1, f2, f3 from explain_predicate_t2 t2 where t1.f2 = t2.f2) t3 where t1.f3 = t3.f3);
-- from multiple tables
explain plan for select * from explain_predicate_t1 t1 where t1.f1 = (select t2.f2 from explain_predicate_t2 t2, explain_predicate_t3 t3 where t2.int_c1 = t3.int_c1);
explain plan for select * from explain_predicate_t1 t1 where t1.f1 = (select t2.f2 from explain_predicate_t2 t2 join explain_predicate_t3 t3 where t2.int_c1 = t3.int_c1);
explain plan for select * from explain_predicate_t1 t1 where t1.f1 = (select t2.f2 from explain_predicate_t2 t2 left join explain_predicate_t3 t3 on t2.int_c1 = t3.int_c1);
explain plan for select * from explain_predicate_t1 t1 where t1.f1 = (select t2.f2 from explain_predicate_t2 t2 right join explain_predicate_t3 t3 on t2.int_c1 = t3.int_c1);
explain plan for select * from explain_predicate_t1 t1 where t1.f1 = (select t2.f2 from explain_predicate_t2 t2 full join explain_predicate_t3 t3 on t2.int_c1 = t3.int_c1);
explain plan for select * from explain_predicate_t1 t1 where t1.f1 = (select t2.f2 from explain_predicate_t2 t2 left join explain_predicate_t3 t3 on t2.id = t3.id where t2.int_c1 < 100);

explain plan for select * from explain_predicate_t1 t1 where t1.f1 = (select t2.f2 from explain_predicate_t2 t2 right join explain_predicate_t1 t3 on t2.id = t3.id
inner join explain_predicate_t1 t4 on t1.id != t4.id left join explain_predicate_t1 t5 on t1.id < t5.id);

-- EXPR_NODE_PRIOR
explain plan for select * from explain_predicate_t1 connect by nocycle prior id <10;
-- EXPR_NODE_OVER
explain plan for select * from explain_predicate_t1 where f1 in (select min(f2) over(partition by f3 order by f1 DESC NULLS LAST, f2 ASC NULLS FIRST) from explain_predicate_t1);
-- EXPR_NODE_ARRAY
explain plan for select * from explain_predicate_t1 where f23[1:4] is null;
explain plan for select * from explain_predicate_t1 where array[1,2,3] is null;

-- EXPR_NODE_SEQUENCE
drop sequence if exists explain_predicate_seq;
create sequence explain_predicate_seq increment by 2 start with 1 maxvalue 200 nocycle nocache;
select explain_predicate_seq.nextval from dual;
explain plan for select * from explain_predicate_t1 where int_c1 = (select explain_predicate_seq.currval from dual);
explain plan for select * from explain_predicate_t1 where int_c1 = (select explain_predicate_seq.nextval from dual);
drop sequence explain_predicate_seq;


-- func_as_table
explain plan for select FILE_ID, INFO_TYPE, CORRUPT_NUM from table(dba_page_corruption('DATABASE')) where FILE_ID=0 and INFO_TYPE = 1;

-- or condition is rownum on both sides
explain plan for select * from explain_predicate_t1 where rownum < 5 or rownum > 20;

-- function index
explain plan for select * from explain_predicate_t1 where upper(str_c1) = 'TEST';

explain plan for
merge into explain_predicate_t2 t2
using (select * from explain_predicate_t1 where int_c1 < 20) t1
on (t1.f1 = t2.f1 and t1.f2 = t2.f2 and t1.f3 = t2.f3 and t1.f4 = t2.f4 and t1.f5 = t2.f5 and t1.str_c1 = t2.str_c1)
when matched then
update set str_c1 = 'abc'
when not matched then
insert values(1, 2, 'test', 3, 4, 5, 6.1, 6.2);

explain plan for
merge into explain_predicate_t2 t2
using (select * from explain_predicate_t1 where int_c1 < 20) t1
on (t1.f1 = t2.f1)
when matched then
update set str_c1 = 'abc' where t1.f2 = t2.f2
when not matched then
insert values(1, 2, 'test', 3, 4, 5, 6.1, 6.2) where t1.str_c1 is not null;

explain plan for select * from explain_predicate_t1 where f1 in (select (select f2 from explain_predicate_t2 where rownum < 1) from explain_predicate_t1);
explain plan for select * from explain_predicate_t1 having 1 < 0;

-- DTS2019122500420
drop procedure if exists explain_predicate_pro;
create or replace procedure explain_predicate_pro as
begin
execute immediate'explain select * from explain_predicate_t1 where id < 10';
end;
/

call explain_predicate_pro;
drop procedure explain_predicate_pro;

explain plan for select sum(id), int_c1 from explain_predicate_t1 t1 
where exists 
(
    select * from explain_predicate_t2 t2, explain_predicate_t3 t3 where t2.int_c1 = t3.int_c1
    union all
    select * from explain_predicate_t2 t4, explain_predicate_t3 t5 where t4.id < 10
    union all
    select * from explain_predicate_t2 t6, explain_predicate_t3 t7 where t6.id < 10
    union all
    select * from explain_predicate_t2 t8, explain_predicate_t3 t9 where t8.id < 10
    union all
    select * from explain_predicate_t2 t10, explain_predicate_t3 t11 where t10.id < 10
    union all
    select * from explain_predicate_t2 t12, explain_predicate_t3 t13 where t12.id < 10
    union all
    select * from explain_predicate_t2 t14, explain_predicate_t3 t15 where t14.id < 10
    union all
    select * from explain_predicate_t2 t16, explain_predicate_t3 t17 where t16.id < 10
    union all
    select * from explain_predicate_t2 t18, explain_predicate_t3 t19 where t18.id < 10
    union all
    select * from explain_predicate_t2 t20, explain_predicate_t3 t21 where t20.id < 10
    union all
    select * from explain_predicate_t2 t22, explain_predicate_t3 t23 where t22.id < 10
    union all
    select * from explain_predicate_t2 t24, explain_predicate_t3 t25 where t24.id < 10
    union all
    select * from explain_predicate_t2 t26, explain_predicate_t3 t27 where t26.id < 10
    union all
    select * from explain_predicate_t2 t28, explain_predicate_t3 t29 where t28.id < 10
    union all
    select * from explain_predicate_t2 t30, explain_predicate_t3 t31 where t30.id < 10
    union all
    select * from explain_predicate_t2 t32, explain_predicate_t3 t33 where t32.id < 10
    union all
    select * from explain_predicate_t2 t34, explain_predicate_t3 t35 where t34.id < 10
    union all
    select * from explain_predicate_t2 t36, explain_predicate_t3 t37 where t36.id < 10
    union all
    select * from explain_predicate_t2 t38, explain_predicate_t3 t39 where t38.id < 10
    union all
    select * from explain_predicate_t2 t40, explain_predicate_t3 t41 where t40.id < 10
    union all
    select * from explain_predicate_t2 t42, explain_predicate_t3 t43 where t42.id < 10
    union all
    select * from explain_predicate_t2 t44, explain_predicate_t3 t45 where t44.id < 10
) group by int_c1 order by 1 limit 1;

-- overlong const string
explain plan for 
select * from explain_predicate_t1 where f27>to_clob('111111111911111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111');

explain plan for select * from explain_predicate_t1 where f24 = cast('123' as binary(513));

explain plan for select * from explain_predicate_t1 where cast('123' as binary(500)) = some(select f2 from explain_predicate_t2 limit 10);

explain plan for select * from explain_predicate_t1 
where
    case when
        case when
            case when id > 100 then f1 else f2 end > 10
        then
            case when f1 > 20 then f2 else f3 end
        else
            case when f2 > 80 then f3 else f4 end
        end < 100
    then
        case when
            case when int_c1 < 888 then f4 else f5 end < 99.99
        then 
            case when f4 > 22.22 then f5 else f6 end
        else
            case when f5 < 66.66 then f6 else f7 end
        end
    else
        case when
            case when int_c2 between 99 and 199 then f8 else f9 end > 99.999
        then
            case when f8 = 66.66 then f11 else f12 end
        else
            case when f9 < 10 then f12 else f13 end
        end
    end is not null;

explain plan for select * from explain_predicate_t1 
where (case id 
       when 100 then 0 when 101 then 1 when 102 then 2 when 103 then 3 when 104 then 4 when 105 then 5 when 106 then 6 when 107 then 7 when 108 then 8 when 109 then 9
       when 110 then 10 when 111 then 11 when 112 then 12 when 113 then 13 when 114 then 14 when 115 then 15 when 116 then 16 when 117 then 17 when 118 then 18 when 118 then 18
       when 119 then 19 when 120 then 20 when 121 then 21 when 122 then 22 when 123 then 23 when 124 then 24 when 125 then 25 when 126 then 26 when 127 then 27 when 128 then 28
       when 129 then 29 when 130 then 30 when 131 then 31 when 132 then 32 when 133 then 33 when 134 then 34 when 135 then 35 when 136 then 36 when 137 then 37 when 138 then 38
       when 139 then 39 when 140 then 40 when 141 then 41 when 142 then 42 when 143 then 43 when 144 then 44 when 145 then 45 when 146 then 46 when 147 then 47 when 148 then 48
       when 149 then 49 when 150 then 50 when 151 then 51 when 152 then 52 when 153 then 53 when 154 then 54 when 155 then 55 when 156 then 56 when 157 then 57 when 158 then 58
       when 159 then 59 when 160 then 60 when 161 then 61 when 162 then 62 when 163 then 63 when 164 then 64 when 165 then 65 when 166 then 66 when 167 then 67 when 168 then 68
       when 169 then 69 when 170 then 70 when 171 then 71 when 172 then 72 when 173 then 73 when 174 then 74 when 175 then 75 when 176 then 76 when 177 then 77 when 178 then 78
       when 179 then 79 when 180 then 80 else 100 end) > 33;

-- exists func_as_table
explain
select * from explain_predicate_t1 t 
where exists (select STAT_ITEM from table(dba_analyze_table(t.f12, t.f13)) where STAT_ITEM = t.f12);

-- with as table do not display details
explain
with jennifer_1 as
(select
    ref_1.int_c1 as c8
 from
    (explain_predicate_t3 as ref_0) right join 
    (explain_predicate_t2 pivot(
        min(case when 0.0 = any(select null as c1 from explain_predicate_t3 as ref_2
                                where explain_predicate_t2.f5 > 0)
            then 1 else 2 end ) as aggr_0
        for (str_c1)
        in (('test') as pexpr_0)) as ref_1)
    on (ref_0.id = ref_1.id )
)
select
    null as c0,
    ref_3.id as c1
from
    explain_predicate_t3 as ref_3
where exists (
    select 
        ref_3.int_c1 as c2
    from jennifer_1 as ref_4
    group by ref_3.int_c1
);

explain
select
    null as c0,
    ref_3.id as c1
from
    explain_predicate_t3 as ref_3
where exists (
    select 
        ref_3.int_c1 as c2
    from (select ref_1.int_c1 as c8
          from (explain_predicate_t3 as ref_0) right join 
               (explain_predicate_t2 pivot(
                    min(case when 0.0 = any(select null as c1 from explain_predicate_t3 as ref_2
                                            where explain_predicate_t2.f5 > 0)
                        then 1 else 2 end ) as aggr_0
                    for (str_c1)
                    in (('test') as pexpr_0)) as ref_1)
                on (ref_0.id = ref_1.id )
        ) as ref_4
    group by ref_3.int_c1
);

-- miss rs_col name
explain select * from explain_predicate_t1 t1 
where t1.id in (select t2.int_c2 from explain_predicate_t1 t2 inner join explain_predicate_t1 t3 where t2.id = t3.id or t2.int_c1 = t3.int_c1);

select t1.f8 from explain_predicate_t1 t1, explain_predicate_t2 t2
where t1.f1 = t2.f1 and t1.int_c2 in (select int_c2 from explain_predicate_t1 t3 where int_c3 = 100) and t2.f2 = 100 and t1.f1 = 101 and t1.f2 = 102;
select plan_text from dv_sql_plan where sql_id = '4030947501';
explain select t1.f8 from explain_predicate_t1 t1, explain_predicate_t2 t2
where t1.f1 = t2.f1 and t1.int_c2 in (select int_c2 from explain_predicate_t1 t3 where int_c3 = 100) and t2.f2 = 100 and t1.f1 = 101  and  t1.f2 = 102;

drop table explain_predicate_t1;
drop table explain_predicate_t2;
drop table explain_predicate_t3;

-- DTS2020021110110
drop table if exists T_AUTOTRACE_1;
CREATE TABLE "T_AUTOTRACE_1"("ID" BINARY_INTEGER, "C_INT" BINARY_INTEGER NOT NULL, "C_VCHAR" VARCHAR(100 BYTE) NOT NULL);
CREATE INDEX "TRACE_IDX_1" ON "T_AUTOTRACE_1"("ID");

drop table if exists T_AUTOTRACE_2;
CREATE TABLE "T_AUTOTRACE_2"("ID" BINARY_INTEGER, "C_INT" BINARY_INTEGER NOT NULL, "C_VCHAR" VARCHAR(100 BYTE) NOT NULL);
CREATE INDEX "TRACE_IDX_2" ON "T_AUTOTRACE_2"("ID");

drop table if exists T_AUTOTRACE_3;
CREATE TABLE "T_AUTOTRACE_3"("ID" BINARY_INTEGER, "C_INT" BINARY_INTEGER, "C_VCHAR" VARCHAR(100 BYTE) NOT NULL);

explain plan for
select rownum, t1.id, t2.c_int, t3.c_vchar from
    T_AUTOTRACE_1 t1 left join T_AUTOTRACE_2 t2 on t1.id = t2.id
        full join T_AUTOTRACE_3 t3 on t2.c_int < t3.c_int
        where exists(
            select * from T_AUTOTRACE_1 t11
                    where (select t11.id+1 from dual)< t1.c_int ) order by 1,2,3,4 limit 5;
                    
-- test show_explain_predicate
-- DTS2020021407615
drop table if exists explain_plan;
create table explain_plan(id number(8) not null, int_f1 int, int_f2 int);
-- error
alter system set show_explain_predicate=false;
alter system set _show_explain_predicate=off;
alter session set show_explain_predicat=false;
alter session set _show_explain_predicate=off;

alter system set _show_explain_predicate=false;
explain plan for select * from explain_plan where id < 10;
alter system set _show_explain_predicate=true;
explain plan for select * from explain_plan where id < 10;

-- DTS2020032415881
alter system set _prefetch_rows = 6;
explain select * from explain_plan where id < ?;
alter system set _prefetch_rows = 100;
drop table explain_plan;

-- DTS2020031810176
drop table if exists t_join_base_001;
drop table if exists t_join_base_002;
drop table if exists t_join_base_003;
drop table if exists t_join_base_004;

create table t_join_base_001(
id int,
c_int int,
c_real real);
create table t_join_base_002 as select * from t_join_base_001;
create table t_join_base_003 as select * from t_join_base_001;
create table t_join_base_004 as select * from t_join_base_001;

create index idx_join_base_001_1 on t_join_base_001(c_int);

explain plan for select t1.c_int,t2.c_int from t_join_base_001 t1 join t_join_base_002 t2 on t1.id=t2.id join t_join_base_002 t3 on t1.id=t3.id 
where exists ( select t3.c_int from t_join_base_003 t3 
where t3.c_int<(select t1.c_int from t_join_base_004 where exists(select t2.c_int from t_join_base_004)) and t1.c_int=t2.c_int ) order by 1;

drop table t_join_base_001;
drop table t_join_base_002;
drop table t_join_base_003;
drop table t_join_base_004;

-- DTS2020052906GQ14P0F00
drop table if exists with_as_table_explain_t1;
create table with_as_table_explain_t1
(
  org_id number not null,
  category_id number,
  delete_flag varchar(2 byte),
  org_year varchar(4 byte)
);
alter table with_as_table_explain_t1 add constraint "PK_WITH_AS_TABLE_EXPLAIN_T1" primary key(org_id);

drop table if exists with_as_table_explain_t2;
create table with_as_table_explain_t2
(
  category_org_id number not null,
  category_id number,
  org_id number
);
alter table with_as_table_explain_t2 add constraint "PK_WITH_AS_TABLE_EXPLAIN_T2" primary key(category_org_id);

drop table if exists with_as_table_explain_t3;
create table with_as_table_explain_t3
(
  org_user_id number not null,
  org_id number
);
create index "WITH_AS_TABLE_EXPLAIN_T3_ORGID" on with_as_table_explain_t3(org_id);
alter table with_as_table_explain_t3 add constraint "PK_WITH_AS_TABLE_EXPLAIN_T3" primary key(org_user_id);

explain
with table1 as(
  select org_id from with_as_table_explain_t1
  where org_year = '2020'
),
table2 as(
  select
    decode((select count(*) from table1 where org_id=t1.org_id ),0,'N','Y') isWeightTeam
  from with_as_table_explain_t2 t2 
    left join with_as_table_explain_t1 t1 on t2.org_id=t1.org_id
    left join (select org_id from with_as_table_explain_t3) t3 on t3.org_id = t1.org_id
  where t1.delete_flag = 'N' and t2.category_id in (2801,2806)
)
select isWeightTeam from table2;

-- DTS202006080EUHXYP1300
explain
with
    table1 as (select org_id from with_as_table_explain_t1 where delete_flag = 'Y'),
    table2 as (
        select /*+leading(t1) use_hash(t2,t1)*/
            t1.category_id,
            t1.org_id
        from 
            with_as_table_explain_t1 t1
            join table1 t2
            on t1.org_id = t2.org_id
    ),
    table3 as (
        select *
        from table2
        where 
            exists
            (
             SELECT 1
             FROM with_as_table_explain_t3 t3
             WHERE
                table2.org_id = t3.org_id
            )
    ) 
select /*+leading(t2) use_nl(t2, t3)*/
    t2.category_org_id,
    t2.org_id,
    (
     select 1 
     from table3
     where t2.category_id = table3.category_id
    ) col3
from 
    with_as_table_explain_t2 t2
    left join with_as_table_explain_t3 t3
    on t2.org_id = t3.org_id;

drop table with_as_table_explain_t1;
drop table with_as_table_explain_t2;
drop table with_as_table_explain_t3;

-- DTS20200710077WZAP0F00
drop table if exists explain_predicate_multiple_cols;
create table explain_predicate_multiple_cols
(
    very_long_name_column_01 int,
    very_long_name_column_02 int,
    very_long_name_column_03 int,
    very_long_name_column_04 int,
    very_long_name_column_05 int,
    very_long_name_column_06 int,
    very_long_name_column_07 int,
    very_long_name_column_08 int,
    very_long_name_column_09 int,
    very_long_name_column_10 int,
    very_long_name_column_11 int,
    very_long_name_column_12 int,
    very_long_name_column_13 int,
    very_long_name_column_14 int,
    very_long_name_column_15 int,
    very_long_name_column_16 int,
    very_long_name_column_17 int,
    very_long_name_column_18 int,
    very_long_name_column_19 int,
    very_long_name_column_20 int,
    very_long_name_column_21 int,
    very_long_name_column_22 int,
    very_long_name_column_23 int,
    very_long_name_column_24 int,
    very_long_name_column_25 int,
    very_long_name_column_26 int,
    very_long_name_column_27 int,
    very_long_name_column_28 int,
    very_long_name_column_29 int,
    very_long_name_column_30 int,
    very_long_name_column_31 int,
    very_long_name_column_32 int,
    very_long_name_column_33 int,
    very_long_name_column_34 int,
    very_long_name_column_35 int,
    very_long_name_column_36 int,
    very_long_name_column_37 int,
    very_long_name_column_38 int,
    very_long_name_column_39 int,
    very_long_name_column_40 int,
    very_long_name_column_41 int,
    very_long_name_column_42 int,
    very_long_name_column_43 int,
    very_long_name_column_44 int,
    very_long_name_column_45 int,
    very_long_name_column_46 int,
    very_long_name_column_47 int,
    very_long_name_column_48 int,
    very_long_name_column_49 int,
    very_long_name_column_50 int
);

explain select count(*) from explain_predicate_multiple_cols 
where very_long_name_column_50 < 
(select count(*) from explain_predicate_multiple_cols where very_long_name_column_49 < 40 and not exists 
  (select 1 from(
    (select distinct very_long_name_column_01, very_long_name_column_02, very_long_name_column_03, very_long_name_column_04, very_long_name_column_05,
                     very_long_name_column_06, very_long_name_column_07, very_long_name_column_08, very_long_name_column_09, very_long_name_column_10,
                     very_long_name_column_11, very_long_name_column_12, very_long_name_column_13, very_long_name_column_14, very_long_name_column_15,
                     very_long_name_column_16, very_long_name_column_17, very_long_name_column_18, very_long_name_column_19, very_long_name_column_20,
                     very_long_name_column_21, very_long_name_column_22, very_long_name_column_23, very_long_name_column_24, very_long_name_column_25,
                     very_long_name_column_26, very_long_name_column_27, very_long_name_column_28, very_long_name_column_29, very_long_name_column_30,
                     very_long_name_column_31, very_long_name_column_32, very_long_name_column_33, very_long_name_column_34, very_long_name_column_35,
                     very_long_name_column_36, very_long_name_column_37, very_long_name_column_38, very_long_name_column_39, very_long_name_column_40,
                     very_long_name_column_41, very_long_name_column_42, very_long_name_column_43, very_long_name_column_44, very_long_name_column_45 from explain_predicate_multiple_cols) union all
    (select distinct very_long_name_column_01, very_long_name_column_02, very_long_name_column_03, very_long_name_column_04, very_long_name_column_05,
                     very_long_name_column_06, very_long_name_column_07, very_long_name_column_08, very_long_name_column_09, very_long_name_column_10,
                     very_long_name_column_11, very_long_name_column_12, very_long_name_column_13, very_long_name_column_14, very_long_name_column_15,
                     very_long_name_column_16, very_long_name_column_17, very_long_name_column_18, very_long_name_column_19, very_long_name_column_20,
                     very_long_name_column_21, very_long_name_column_22, very_long_name_column_23, very_long_name_column_24, very_long_name_column_25,
                     very_long_name_column_26, very_long_name_column_27, very_long_name_column_28, very_long_name_column_29, very_long_name_column_30,
                     very_long_name_column_31, very_long_name_column_32, very_long_name_column_33, very_long_name_column_34, very_long_name_column_35,
                     very_long_name_column_36, very_long_name_column_37, very_long_name_column_38, very_long_name_column_39, very_long_name_column_40,
                     very_long_name_column_41, very_long_name_column_42, very_long_name_column_43, very_long_name_column_44, very_long_name_column_45 from explain_predicate_multiple_cols)
   )
  )
);

explain plan for select * from explain_predicate_multiple_cols t1  
where decode(very_long_name_column_01, 1, very_long_name_column_02, 2, very_long_name_column_03, 3, very_long_name_column_04, 4, 
             very_long_name_column_05, 5, very_long_name_column_06, 6, very_long_name_column_07, 7, very_long_name_column_08, 8,
             very_long_name_column_09, 9, very_long_name_column_10, 10, very_long_name_column_11, 11, very_long_name_column_12, 12,
             very_long_name_column_13, 13, very_long_name_column_14, 14, very_long_name_column_15, 15, very_long_name_column_16, 16,
             very_long_name_column_17, 17, very_long_name_column_18, 18, very_long_name_column_19, 19, very_long_name_column_20, 20,
             very_long_name_column_21, 21, very_long_name_column_22, 22, very_long_name_column_23, 23, very_long_name_column_24, 24, 
             very_long_name_column_25, 25, very_long_name_column_26, 26, very_long_name_column_27, 27, very_long_name_column_28, 28,
             very_long_name_column_29, 29, very_long_name_column_30, 30, very_long_name_column_31, 31, very_long_name_column_32, 32,
             very_long_name_column_33, 33, very_long_name_column_34, 34, very_long_name_column_35, 35, very_long_name_column_36, 36,
             very_long_name_column_37, 37, very_long_name_column_38, 38, very_long_name_column_39, 39, very_long_name_column_40, 40) is not null;

explain plan for select * from explain_predicate_multiple_cols
where very_long_name_column_01 + very_long_name_column_02 + very_long_name_column_03 + very_long_name_column_04 + very_long_name_column_05 + very_long_name_column_06 +
      very_long_name_column_07 + very_long_name_column_08 + very_long_name_column_09 + very_long_name_column_10 + very_long_name_column_11 + very_long_name_column_12 +
      very_long_name_column_13 + very_long_name_column_14 + very_long_name_column_15 + very_long_name_column_16 + very_long_name_column_17 + very_long_name_column_18 +
      very_long_name_column_19 + very_long_name_column_20 + very_long_name_column_21 + very_long_name_column_22 + very_long_name_column_23 + very_long_name_column_24 +
      very_long_name_column_25 + very_long_name_column_26 + very_long_name_column_27 + very_long_name_column_28 + very_long_name_column_29 + very_long_name_column_30 +
      very_long_name_column_31 + very_long_name_column_32 + very_long_name_column_33 + very_long_name_column_34 + very_long_name_column_35 + very_long_name_column_36 +
      very_long_name_column_37 + very_long_name_column_38 + very_long_name_column_39 + very_long_name_column_40 + very_long_name_column_41 + very_long_name_column_42 +
      very_long_name_column_43 + very_long_name_column_44 + very_long_name_column_45 + very_long_name_column_46 + very_long_name_column_47 + very_long_name_column_48;

explain select * from explain_predicate_multiple_cols t 
where exists(
		select very_long_name_column_01  from explain_predicate_multiple_cols 
		GROUP BY
		  very_long_name_column_01,
          CAST('43599 2:58:26' AS INTERVAL DAY TO SECOND),
          CAST('972356 11:5:7' AS INTERVAL DAY(7) TO SECOND),
          CAST('9197-10' AS INTERVAL YEAR(4) TO MONTH),
          CAST('691341 9:20:27' AS INTERVAL DAY(7) TO SECOND),
          CUBE(
            t.very_long_name_column_01,
            t.very_long_name_column_02,
            t.very_long_name_column_03) limit 1) ;	
			
explain select * from explain_predicate_multiple_cols t 
where exists(
		select very_long_name_column_01  from explain_predicate_multiple_cols 
		order by 
		t.very_long_name_column_01,
		'11111111111111111111111111111111111111111111111111111111111111111111111111',
		'222222222222222222222222222222222222222222222222222222222222222222222222222',
		'333333333333333333333333333333333333333333333333333333333333333333333333333',
		'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
		'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
		'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww',
		'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
		'11111111111111111111111111111111111111111111111111111111111111111111111111',
		'222222222222222222222222222222222222222222222222222222222222222222222222222',
		'333333333333333333333333333333333333333333333333333333333333333333333333333',
		'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
		'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
		'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww' limit 1) ;
		
explain select * from explain_predicate_multiple_cols t 
where exists(
		select *  from (select t1.very_long_name_column_01, t2.very_long_name_column_02 
		from explain_predicate_multiple_cols t1 
		left join explain_predicate_multiple_cols t2 on t1.very_long_name_column_04 = t2.very_long_name_column_04 
		inner join explain_predicate_multiple_cols t3 on t3.very_long_name_column_04 = t2.very_long_name_column_04
		left join explain_predicate_multiple_cols t4 on t3.very_long_name_column_04 = t4.very_long_name_column_01 
		left join explain_predicate_multiple_cols t5 on t5.very_long_name_column_02 = t4.very_long_name_column_03
		left join explain_predicate_multiple_cols t6 on t6.very_long_name_column_04 = t3.very_long_name_column_01
		full join explain_predicate_multiple_cols t7 on t6.very_long_name_column_04 = t7.very_long_name_column_05
		right join explain_predicate_multiple_cols t8 on t8.very_long_name_column_07 = t8.very_long_name_column_01
		left join explain_predicate_multiple_cols t9 on t9.very_long_name_column_04 = t4.very_long_name_column_01 
		left join explain_predicate_multiple_cols t10 on t10.very_long_name_column_02 = t4.very_long_name_column_03
		left join explain_predicate_multiple_cols t11 on t11.very_long_name_column_04 = t3.very_long_name_column_01
		full join explain_predicate_multiple_cols t12 on t12.very_long_name_column_04 = t7.very_long_name_column_05
		right join explain_predicate_multiple_cols t13 on t13.very_long_name_column_07 = t8.very_long_name_column_01
		)order by t.very_long_name_column_01 limit 1) ;	
drop table explain_predicate_multiple_cols;

-- DTS202009030F6CK0P0K00
explain plan for
SELECT GROUP_ID FROM SYS.GSYS_PENDING_DIST_TRANS as ref_1 WHERE ref_1.NEED_CLEAN IS NOT NULL;

explain SELECT 
    CASE WHEN EXISTS (
         SELECT
			ref_0.DIST_INFO AS C0
		 FROM(
		    SELECT
	           ref_6.GROUP_ID AS C0
			FROM
	           SYS.GSYS_PENDING_DIST_TRANS AS ref_6 
	        WHERE (ref_0.DIST_INFO IS NOT NULL)  ) AS subq_2)
	THEN 1 ELSE null END AS C1,
	MIN(null) over () AS C2 
FROM  SYS.MY_TAB_DISTRIBUTE AS ref_0;

-- DTS202011270GOUF5P1300
-- deparse pivot/unpivot table
drop table if exists deparse_pivot_t1;
drop table if exists deparse_pivot_t2;
drop table if exists deparse_pivot_t3;
drop table if exists deparse_pivot_t4;
create table deparse_pivot_t1(id number(8), c_int number(10), c_num number(10));
create table deparse_pivot_t2(id number(8), c_int number(10), c_num number(10));
create table deparse_pivot_t3 (empno int, ename varchar(20), job varchar(20), mgr int, sal int, deptno int);
create table deparse_pivot_t4 (f1 int, f2 varchar(20), f3 int, f4 int);

-- pivot
explain plan for
select id
from deparse_pivot_t1
where c_int = all(
    select c_int
    from deparse_pivot_t2 pivot(
    MIN(c_int) as aggr_0
    for (id) in ((0) as pexpr_0, (1) as pexpr_1)) ref_1
);

explain plan for
select id
from deparse_pivot_t1
where c_int = all(
    select c_int
    from deparse_pivot_t2 pivot(
    min(c_num) as aggr_0
    for (id) in ((0) as pexpr_0, (1) as pexpr_1)) ref_1
    where ref_1.pexpr_0_aggr_0 > ref_1.pexpr_1_aggr_0
);

explain plan for
select id
from deparse_pivot_t1
where c_int = all(
    select c_int
    from deparse_pivot_t2 pivot(
    min(c_num) as aggr_0
    for (id) in ((0) as pexpr_0, (1) as pexpr_1)) ref_1
    left join
    deparse_pivot_t4 ref_2
    on ref_1.pexpr_1_aggr_0 > ref_2.f1
);

explain plan for
select id
from deparse_pivot_t1
where c_int = all(
    select c_int
    from deparse_pivot_t2 pivot(
    MIN(c_int) as aggr_0,
    MAX(c_num),
    AVG(c_num) as aggr_1
    for (id, id, id) in ((0, 0, 0) as pexpr_0, (1, 1, 1), (2, 2, 2) as pexpr_1)) ref_1
);

-- unpivot
explain plan for
select id
from deparse_pivot_t1
where c_int = all(
    select c_int
    from deparse_pivot_t2 unpivot(
    c1 for c2 in (c_int,c_num)) ref_1
);

explain plan for
select id
from deparse_pivot_t1
where c_int = all(
    select id
    from deparse_pivot_t2 unpivot include nulls(
    (c1,c2) for (c3,c4) in ((c_int,c_num), (c_num, c_int))) ref_1
);

-- pivot join
explain plan for
select id
from deparse_pivot_t1 t1
where c_int = all(
    select mgr 
    from 
        deparse_pivot_t3 pivot(max(sal) for deptno in (10,20)) t1 join 
        deparse_pivot_t2 pivot(count(*) for id in (1,2,3)) t2 
        on t1.mgr != t2.c_int pivot (max(empno) for job in('CLERK','ANALYST')) where mgr < 10 order by mgr
);

explain plan for
select id
from deparse_pivot_t1 t1
where c_int = all(
    select mgr 
    from 
        deparse_pivot_t3 pivot(max(sal) for deptno in (10,20)) t1 left join 
        deparse_pivot_t2 pivot(count(*) for id in (1,2,3)) t2 
        on t1.mgr != t2.c_int pivot (max(empno) for job in('CLERK','ANALYST')) where mgr < 10 order by mgr
);

explain plan for
select id
from deparse_pivot_t1 t1
where c_int = all(
    select mgr 
    from 
        deparse_pivot_t3 pivot(max(sal) for deptno in (10,20)) t1 left join 
        deparse_pivot_t2 pivot(count(*) for id in (1,2,3)) t2 
        on t1.mgr != t2.c_int inner join 
        deparse_pivot_t4 pivot(count(*) for f2 in ('TEST1','TEST2')) t3
        on t1.mgr != t3.f3
        pivot (max(empno) for job in('CLERK','ANALYST')) where mgr < 10 order by mgr
);

-- unpivot join
explain plan for
select id
from deparse_pivot_t1 t1
where c_int = all(
    select mgr 
    from 
        deparse_pivot_t3 pivot(max(sal) for deptno in (10,20)) t1 join 
        deparse_pivot_t2 pivot(count(*) for id in (1,2,3)) t2 
        on t1.mgr != t2.c_int unpivot exclude nulls(aaa for bbb in(ename,job)) where mgr < 10 order by mgr
);

-- forbidden transform <>any to exists when there is a pivot/unpivot
explain
select ref_0.id as c0
from deparse_pivot_t1 as ref_0
where exists (
    select ref_0.id as c4
    from
      deparse_pivot_t2 pivot(
        max(case when ref_0.c_int != some(select null as c1 from deparse_pivot_t3 as ref_2) then ref_0.c_num else ref_0.c_num end) as aggr_2
        for (id, c_int) in ((4, 6) as pexpr_0)) as ref_3
);

-- forbidden predicate push down when there is a pivot/unpivot
explain 
select   
    ref_0.id as c0,   
    case when  
        ref_0.id  <> any(
        select null as c1 
        from (deparse_pivot_t1 ref_1) cross join 
             (deparse_pivot_t3 unpivot include nulls (
                (newcol_0, newcol_1, newcol_2) 
                for (forcol_0, forcol_1) 
                in ((mgr, ename, job) as ('unpivot_value_0', 'unpivot_value_1'))) as ref_2)
        where ref_1.id between ref_2.empno and ref_0.id 
        limit 84 offset 2)    
    then ref_0.c_int 
    else ref_0.c_int 
    end as c1,   
    min(cast('147722 6:36:19' as interval day to second(6))) over (partition by ref_0.id order by ref_0.id desc) as c2
from deparse_pivot_t2 as ref_0 
group by ref_0.c_int, ref_0.id;

drop table deparse_pivot_t1;
drop table deparse_pivot_t2;
drop table deparse_pivot_t3;
drop table deparse_pivot_t4;
--DTS202102070JWXR4P1D00
--origen_ref needs to be cloned while predicate push down and pull up
DROP TABLE IF EXISTS "T_BPM_HIST_EVENT_PRIM_DATA";
CREATE TABLE "T_BPM_HIST_EVENT_PRIM_DATA"
(
  "DATASETID" VARCHAR(100 BYTE),
  "NAME" VARCHAR(256 BYTE),
  "VALUE" VARCHAR(2000 BYTE),
  "EICREATETIME" DATE,
  "DATATYPE" VARCHAR(256 BYTE),
  "L2_PARTITION_KEY" VARCHAR(100 BYTE),
  "TENANT_ID" NUMBER(20) NOT NULL
);
explain 
SELECT 
    STDDEV_POP(CAST(NULL AS NUMBER)) OVER () AS C3,
    CASE WHEN '0' != ALL (
        SELECT '0' AS C1
        FROM  T_BPM_HIST_EVENT_PRIM_DATA  AS REF_2
        WHERE REF_1.TENANT_ID <> ANY (
                SELECT REF_2.TENANT_ID AS C1  
                FROM T_BPM_HIST_EVENT_PRIM_DATA AS REF_3  
                WHERE REF_1.NAME LIKE '%'
            )
        )
	THEN NULL ELSE NULL END AS C16
FROM ( T_BPM_HIST_EVENT_PRIM_DATA AS REF_0) RIGHT OUTER JOIN 
     ( T_BPM_HIST_EVENT_PRIM_DATA AS REF_1) ON (NOT NULL = NULL)
WHERE (REGEXP_LIKE(REF_0.NAME, '.*'))
GROUP BY 
    REF_1.NAME,
    REF_1.TENANT_ID;

EXPLAIN
SELECT SUBQ_4.C1 AS C0
    ,SUBQ_4.C0 AS C1
    ,COVAR_SAMP(CAST(SUBQ_4.C0 AS BINARY_INTEGER), CAST(SUBQ_4.C0 AS BINARY_INTEGER)) AS C7
    ,CASE WHEN
    'mkF(iCDF7X9xt)F<@!J&R K}MW96Nv>YOwLt%z|e6rzp/*3uj9' < 
    SOME(
        SELECT DISTINCT REF_21.NAME AS C1
        FROM (select /* +rule */ NAME,TENANT_ID FROM T_BPM_HIST_EVENT_PRIM_DATA 
        union all select /* +rule */ NAME,TENANT_ID FROM T_BPM_HIST_EVENT_PRIM_DATA ) REF_21
        WHERE REF_21.TENANT_ID = SUBQ_4.C0)
    THEN
     1
    ELSE
     2
    END AS C11
    ,MAX(CAST(SUBQ_4.C1 AS TIMESTAMP WITH LOCAL TIME ZONE)) OVER (
        PARTITION BY SUBQ_4.C0 ORDER BY SUBQ_4.C1
        ) AS C17
FROM (
    SELECT NULL AS C0
        ,MIN(REF_20.EICREATETIME) AS C1
    FROM T_BPM_HIST_EVENT_PRIM_DATA REF_20
    ) SUBQ_4
GROUP BY SUBQ_4.C1
    ,SUBQ_4.C0 LIMIT 1;