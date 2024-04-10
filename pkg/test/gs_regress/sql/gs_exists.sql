drop table if exists exists_t_001;

create table exists_t_001(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10),c_vchar2 varchar2(100),c_clob clob,
c_long clob,c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp);

insert into exists_t_001 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-01-01 10:51:47.123456'),'yyyy-mm-dd hh24:mi:ss.FF6'));
insert into exists_t_001 values(0,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
 
CREATE or replace procedure exists_proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
        
sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_real+'||i||',c_float+'||i||',c_decimal+'||i||',c_number+'||i||',c_char'||',c_vchar||'||i||',c_vchar2||'||i||',c_clob||'||i||',c_long||'||i||',c_blob'||',c_raw,c_date+TO_DSINTERVAL('''||i|| ' 00:00:00'''||'),c_timestamp+TO_DSINTERVAL('''||i|| ' 00:00:00'''||') from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/
 
call exists_proc_insert('exists_t_001',1, 10);
commit;

explain 
 select t1.c_int  from exists_t_001 t1 where exists (select t1.c_int from exists_t_001 t11 join exists_t_001 t12 on t11.c_int<t12.c_int order by t1.c_int) order by 1;
select t1.c_int  from exists_t_001 t1 where exists (select t1.c_int from exists_t_001 t11 join exists_t_001 t12 on t11.c_int<t12.c_int order by t1.c_int) order by 1;

explain 
 select t1.c_int  from exists_t_001 t1 where exists (select t1.c_int from exists_t_001 t11 join exists_t_001 t12 on t11.c_int<t12.c_int order by t1.c_int limit 0) order by 1; 
 select t1.c_int  from exists_t_001 t1 where exists (select t1.c_int from exists_t_001 t11 join exists_t_001 t12 on t11.c_int<t12.c_int order by t1.c_int limit 0) order by 1;

explain 
 select t1.c_int  from exists_t_001 t1 where exists (select t1.c_int from exists_t_001 t11 join exists_t_001 t12 on t11.c_int<t12.c_int order by t1.c_int limit 1) order by 1;
 select t1.c_int  from exists_t_001 t1 where exists (select t1.c_int from exists_t_001 t11 join exists_t_001 t12 on t11.c_int<t12.c_int order by t1.c_int limit 1) order by 1;

explain 
 select t1.c_int  from exists_t_001 t1 where exists (select distinct t1.c_int from exists_t_001 t11 join exists_t_001 t12 on t11.c_int<t12.c_int order by t1.c_int) order by 1;
select t1.c_int  from exists_t_001 t1 where exists (select distinct t1.c_int from exists_t_001 t11 join exists_t_001 t12 on t11.c_int<t12.c_int order by t1.c_int) order by 1;

select t1.c_int  from exists_t_001 t1 where exists (select distinct t1.c_int+1, t12.c_int from exists_t_001 t11 join exists_t_001 t12 on t11.c_int<t12.c_int order by t1.c_int) order by 1;
select t1.c_int  from exists_t_001 t1 where exists (select distinct t1.c_int+1, t11.c_int from exists_t_001 t11 join exists_t_001 t12 on t11.c_int<t12.c_int order by t1.c_int) order by 1;
select t1.c_int  from exists_t_001 t1 where exists (select t11.c_int from exists_t_001 t11 join exists_t_001 t12 on t11.c_int<t12.c_int group by t11.c_int order by t1.c_int) order by 1;

drop table exists_t_001;
drop procedure exists_proc_insert;
drop table if exists t_not_in_1;
drop table if exists t_not_in_2;

create table t_not_in_1(a int not null, b int);
create table t_not_in_2(a int not null, b int);
explain select * from t_not_in_1 t1 where t1.b not in (select t2.b from t_not_in_2 t2 where t2.a=t1.a);
explain select * from t_not_in_1 t1 where t1.a not in (select t2.b from t_not_in_2 t2 where t2.a=t1.b);
explain select * from t_not_in_1 t1 where t1.b not in (select t2.a from t_not_in_2 t2 where t2.b=t1.a);
explain select * from t_not_in_1 t1 where t1.a not in (select t2.b+1 from t_not_in_2 t2 where t2.b=t1.a);
explain select * from t_not_in_1 t1 where t1.a not in (select t2.a+t1.b from t_not_in_2 t2 where t2.b=t1.a);
explain select * from t_not_in_1 t1 where t1.a not in (select t2.a from t_not_in_2 t2 where t2.b=t1.b);
explain select * from t_not_in_1 t1 where t1.a not in (select t1.a from t_not_in_2 t2 where t2.b=t1.b);
explain select * from t_not_in_1 t1 where t1.a not in (select t1.a from t_not_in_2 t2);
explain select * from t_not_in_1 t1 where t1.b not in (select t1.b from t_not_in_2 t2);
drop table t_not_in_1;
drop table t_not_in_2;

drop table if exists t_join_base_001;
drop table if exists t_join_base_101;
drop table if exists t_join_base_102;
create table t_join_base_001(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date) ;
create table t_join_base_101(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date) ;
create table t_join_base_102(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date) ;
create index idx_join_base_001_1 on t_join_base_001(c_int);
create index idx_join_base_001_2 on t_join_base_001(c_int,c_vchar);
create index idx_join_base_001_3 on t_join_base_001(c_int,c_vchar,c_date);
create index idx_join_base_101_1 on t_join_base_101(c_int);
create index idx_join_base_101_2 on t_join_base_101(c_int,c_vchar);
create index idx_join_base_101_3 on t_join_base_101(c_int,c_vchar,c_date);
create index idx_join_base_102_1 on t_join_base_102(c_int);
create index idx_join_base_102_2 on t_join_base_102(c_int,c_vchar);
create index idx_join_base_102_3 on t_join_base_102(c_int,c_vchar,c_date);
explain plan for select count(*) from (select * from t_join_base_001) t1 inner join (select * from (select * from t_join_base_101)) t2 on t1.c_vchar=t2.c_vchar inner join (select * from t_join_base_102) t3 on t1.c_int<>t2.c_int and t1.c_int is not null where t1.c_vchar not in (select c_vchar from (select * from t_join_base_102) t4 where t1.c_int=t4.c_int or t2.c_int=t4.c_int );

explain SELECT * FROM t_join_base_001 T1 WHERE (t1.id,t1.c_int) not in(select id, c_int from t_join_base_001) AND T1.c_vchar LIKE '%ANBCD' AND t1.id < 11 and t1.id > 11;
alter system set _OPTIM_PRED_REORDER=false;
explain SELECT * FROM t_join_base_001 T1 WHERE (t1.id,t1.c_int) not in(select id, c_int from t_join_base_001) AND T1.c_vchar LIKE '%ANBCD' AND t1.id < 11 and t1.id > 11   ;
alter system set _OPTIM_PRED_REORDER=true;

explain SELECT
  REF_0.id AS C0,
  REF_0.c_int AS C1,
  REF_0.c_vchar AS C2
FROM
  t_join_base_001 AS REF_0
WHERE (SELECT ID FROM t_join_base_101 LIMIT 1 OFFSET 29)
   > ANY(
  SELECT
      REF_2.ID AS C1
    FROM
      (t_join_base_102 AS REF_1)
        INNER JOIN (t_join_base_001 AS REF_2)
        ON (REF_1.c_vchar LIKE '%'));
alter system set  _OPTIM_ANY_TRANSFORM = false;
explain SELECT
  REF_0.id AS C0,
  REF_0.c_int AS C1,
  REF_0.c_vchar AS C2
FROM
  t_join_base_001 AS REF_0
WHERE (SELECT ID FROM t_join_base_101 LIMIT 1 OFFSET 29)
   > ANY(
  SELECT
      REF_2.ID AS C1
    FROM
      (t_join_base_102 AS REF_1)
        INNER JOIN (t_join_base_001 AS REF_2)
        ON (REF_1.c_vchar LIKE '%'))   ;
alter system set  _OPTIM_ANY_TRANSFORM = true;

explain SELECT
  REF_0.id AS C0,
  REF_0.c_int AS C1,
  REF_0.c_vchar AS C2
FROM
  t_join_base_001 AS REF_0
WHERE (SELECT ID FROM t_join_base_101 LIMIT 1 OFFSET 29)
   > all(
  SELECT
      REF_2.ID AS C1
    FROM
      (t_join_base_102 AS REF_1)
        INNER JOIN (t_join_base_001 AS REF_2)
        ON (REF_1.c_vchar LIKE '%'));
alter system set  _OPTIM_ALL_TRANSFORM = false;
explain SELECT
  REF_0.id AS C0,
  REF_0.c_int AS C1,
  REF_0.c_vchar AS C2
FROM
  t_join_base_001 AS REF_0
WHERE (SELECT ID FROM t_join_base_101 LIMIT 1 OFFSET 29)
   > all(
  SELECT
      REF_2.ID AS C1
    FROM
      (t_join_base_102 AS REF_1)
        INNER JOIN (t_join_base_001 AS REF_2)
        ON (REF_1.c_vchar LIKE '%'))   ;
alter system set  _OPTIM_ALL_TRANSFORM = true;		

insert into t_join_base_001 (id, c_int, c_vchar, c_clob, c_blob) values(1, 100, 'a', 'abc' , 'abc' );
insert into t_join_base_001 (id, c_int, c_vchar, c_clob, c_blob) values(2, 100, 'b', 'abc' , 'abc' );
insert into t_join_base_001 (id, c_int, c_vchar, c_clob, c_blob) values(3, 100, 'c', 'abc' , 'abc' );
insert into t_join_base_101 (id, c_int, c_vchar, c_clob, c_blob) values(1, 100, 'd', 'abc' , 'abc' );
insert into t_join_base_101 (id, c_int, c_vchar, c_clob, c_blob) values(2, 100, '3', 'abc' , 'abc' );
insert into t_join_base_101 (id, c_int, c_vchar, c_clob, c_blob) values(3, 100, 't', 'abc' , 'abc' );
insert into t_join_base_102 (id, c_int, c_vchar, c_clob, c_blob) values(1, 100, 'p', 'abc' , 'abc' );
insert into t_join_base_102 (id, c_int, c_vchar, c_clob, c_blob) values(2, 100, 'y', 'abc' , 'abc' );
insert into t_join_base_102 (id, c_int, c_vchar, c_clob, c_blob) values(3, 100, 'z', 'abc' , 'abc' );
alter system set  _OPTIM_ANY_TRANSFORM = FALSE;	
EXPLAIN SELECT * FROM t_join_base_001 T1 WHERE T1.ID = ANY(SELECT T2.ID FROM t_join_base_001 T2) ORDER BY 1;
SELECT * FROM t_join_base_001 T1 WHERE T1.ID = ANY(SELECT T2.ID FROM t_join_base_001 T2) ORDER BY 1;
alter system set  _OPTIM_ANY_TRANSFORM = TRUE;	
explain select ref_0.id from t_join_base_001 as ref_0 where EXISTS (
          select  
              ref_7.id as c3
            from 
              t_join_base_101 as ref_6
                right join t_join_base_001 as ref_7
                on ((ref_7.c_int is not NULL) )
            where (
			     EXISTS ( select  
                            ref_8.id as c0, 
                            ref_6.id as c1
                          from 
                            t_join_base_102 as ref_8
                          where (ref_7.c_vchar is NULL))
						) 
                or (ref_0.c_int is not NULL));
				
select ref_0.id from t_join_base_001 as ref_0 where EXISTS (
          select  
              ref_7.id as c3
            from 
              t_join_base_101 as ref_6
                right join t_join_base_001 as ref_7
                on ((ref_7.c_int is not NULL) )
            where (
			     EXISTS ( select  
                            ref_8.id as c0, 
                            ref_6.id as c1
                          from 
                            t_join_base_102 as ref_8
                          where (ref_7.c_vchar is NULL))
						) 
                or (ref_0.c_int is not NULL));
				
explain select /*+rule*/ 
  subq_0.c2 as c0, 
  subq_0.c0 as c3,  
  subq_0.c0 as c5
from 
  (select  
        6 as c0, 
        ref_2.c_int as c2
      from 
        (t_join_base_001 as ref_0)
          inner join ((
		  ((t_join_base_001 as ref_1)
                left join (t_join_base_001 as ref_2)
                on (true))
			  )
            right join (t_join_base_001 as ref_9)
            on (ref_2.c_int = ref_9.c_int ))
          on ((true))
				
      where 
	    (EXISTS 
			(
				select  
					ref_1.id as c0
				from 
					(t_join_base_101 as ref_17)
					inner join (t_join_base_001 as ref_18)
					on ((ref_1.c_int is not NULL))
				where ((true) or (ref_9.c_int is not NULL) )			
			)				
		)
         ) as subq_0;		
				
select /*+rule*/ 
  subq_0.c2 as c0, 
  subq_0.c0 as c3,  
  subq_0.c0 as c5
from 
  (select  
        6 as c0, 
        ref_2.c_int as c2
      from 
        (t_join_base_001 as ref_0)
          inner join ((
		  ((t_join_base_001 as ref_1)
                left join (t_join_base_001 as ref_2)
                on (true))
			  )
            right join (t_join_base_001 as ref_9)
            on (ref_2.c_int = ref_9.c_int ))
          on ((true))
				
      where 
	    (EXISTS 
			(
				select  
					ref_1.id as c0
				from 
					(t_join_base_101 as ref_17)
					inner join (t_join_base_001 as ref_18)
					on ((ref_1.c_int is not NULL))
				where ((true) or (ref_9.c_int is not NULL) )			
			)				
		)
		limit 5
         ) as subq_0;

		 
explain SELECT
  1
FROM
  (SELECT DISTINCT
        REF_0.c_vchar AS C4,
        DECODE(
          REF_0.c_vchar,
          REF_0.c_int,
          REF_0.c_vchar,
          REF_0.c_date) AS C5
      FROM
        t_join_base_001 AS REF_0
      WHERE (EXISTS (
          SELECT
              REF_1.c_vchar AS C0,
              REF_1.c_vchar AS C1
            FROM
              t_join_base_001 AS REF_1
            ))
        OR ((EXISTS (
            SELECT
                REF_0.c_vchar AS C0,
				REF_2.c_vchar AS C1
              FROM
                t_join_base_001 AS REF_2)))) AS SUBQ_0
WHERE DECODE(
    SUBQ_0.C4 ,
    SUBQ_0.C5 ,
    'll,Uz<1g}}Nkf~uy,;JOv0BjPNSsn8-7xRLR4OG4.ci o?M-:1',
    SUBQ_0.C4) <> SUBQ_0.C4
LIMIT 108;

alter system set _OPTIM_OR_EXPANSION = false;

explain SELECT
  1
FROM
  (SELECT DISTINCT
        REF_0.c_vchar AS C4,
        DECODE(
          REF_0.c_vchar,
          REF_0.c_int,
          REF_0.c_vchar,
          REF_0.c_date) AS C5
      FROM
        t_join_base_001 AS REF_0
      WHERE (EXISTS (
          SELECT
              REF_1.c_vchar AS C0,
              REF_1.c_vchar AS C1
            FROM
              t_join_base_001 AS REF_1
            ))
        OR ((EXISTS (
            SELECT
                REF_0.c_vchar AS C0,
				REF_2.c_vchar AS C1
              FROM
                t_join_base_001 AS REF_2)))) AS SUBQ_0
WHERE DECODE(
    SUBQ_0.C4 ,
    SUBQ_0.C5 ,
    'll,Uz<1g}}Nkf~uy,;JOv0BjPNSsn8-7xRLR4OG4.ci o?M-:1',
    SUBQ_0.C4) <> SUBQ_0.C4
LIMIT 108    ;

alter system set _OPTIM_OR_EXPANSION = true;

drop table t_join_base_001;
drop table t_join_base_101;
drop table t_join_base_102;
--20200618
drop table if exists user_history_temp;
drop index if exists idx_user_history_temp on user_history_temp;
create table user_history_temp (USER# int NOT NULL,PASSWORD varchar(512),PASSWORD_DATE DATE);
create index idx_user_history_temp on user_history_temp (USER#, PASSWORD_DATE);
insert into user_history_temp values (0,'dsabfdsf',to_date(to_char('2000-01-01'),'yyyy-mm-dd'));
commit;
select  
  subq_0.PASSWORD as c1
from user_history_temp  as subq_0
where EXISTS (
  select  
      ref_7.PASSWORD as c3
    from 
      user_history_temp as ref_7
    where (case when subq_0.PASSWORD is NULL then (select PASSWORD from user_history_temp limit 1 offset 5)
             else (select PASSWORD from user_history_temp limit 1 offset 5)
             end is NULL) 
      or ((select PASSWORD from user_history_temp limit 1 offset 4) is not NULL));
select  
  subq_0.c0 as c0, 
  subq_0.c1 as c1, 
  (select USER# from user_history_temp limit 1 offset 19)
     as c2, 
  (select PASSWORD from user_history_temp limit 1 offset 2)
     as c3, 
  
    max(
      cast(cast(null as BINARY_UINT32) as BINARY_UINT32)) over (partition by subq_0.c3 order by subq_0.c0) as c4
from 
  (select  
        98 as c0, 
        ref_0.PASSWORD as c1, 
        ref_1.USER# as c2, 
        ref_2.PASSWORD as c3, 
        
          stddev(
            cast(cast(null as BINARY_DOUBLE) as BINARY_DOUBLE)) over (partition by ref_0.USER# order by ref_2.PASSWORD) as c4
      from 
        (user_history_temp as ref_0)
          inner join ((((user_history_temp as ref_1)
                inner join (user_history_temp as ref_2)
                on (((false) 
                      and (((true) 
                          or ((false) 
                            and (ref_1.USER# is not NULL))) 
                        and (false))) 
                    or ((((((ref_2.PASSWORD is not NULL) 
                              and (true)) 
                            or ((true) 
                              and (false))) 
                          or (((true) 
                              or ((ref_1.PASSWORD is not NULL) 
                                and ((((true) 
                                      or (false)) 
                                    or ((EXISTS (
                                        select  
                                            (select PASSWORD from user_history_temp limit 1 offset 4)
                                               as c0, 
                                            ref_1.PASSWORD as c1, 
                                            ref_2.USER# as c2, 
                                            ref_3.PASSWORD as c3, 
                                            ref_2.PASSWORD as c4, 
                                            ref_1.PASSWORD as c5, 
                                            ref_1.PASSWORD as c6, 
                                            ref_1.USER# as c7, 
                                            (select USER# from user_history_temp limit 1 offset 5)
                                               as c8, 
                                            ref_3.PASSWORD as c9, 
                                            ref_2.PASSWORD as c10
                                          from 
                                            user_history_temp as ref_3
                                          where false)) 
                                      or (true))) 
                                  or (false)))) 
                            and ((EXISTS (
                                select  
                                    ref_2.PASSWORD as c0, 
                                    ref_4.STMTID as c1, 
                                    (select USER# from user_history_temp limit 1 offset 6)
                                       as c2, 
                                    56 as c3, 
                                    ref_1.USER# as c4, 
                                    ref_1.USER# as c5, 
                                    ref_2.USER# as c6, 
                                    ref_4.STMTID as c7, 
                                    ref_4.STMTID as c8, 
                                    ref_2.PASSWORD as c9, 
                                    ref_2.PASSWORD as c10, 
                                    ref_1.PASSWORD as c11, 
                                    ref_2.PASSWORD as c12, 
                                    ref_2.USER# as c13, 
                                    ref_4.SESSIONID as c14, 
                                    ref_2.PASSWORD as c15, 
                                    ref_1.USER# as c16
                                  from 
                                    SYS.SYS_AUDIT as ref_4
                                  where (select PASSWORD from user_history_temp limit 1 offset 97)
                                       is NULL
                                  limit 132)) 
                              and (ref_1.USER# is not NULL)))) 
                        or (true)) 
                      or (ref_2.PASSWORD is NULL))))
              left join (user_history_temp as ref_5)
              on (true))
            inner join (user_history_temp as ref_6)
            on (true))
          on (ref_0.PASSWORD = ref_5.PASSWORD )
      where ref_2.USER# is not NULL
      limit 76) as subq_0
where EXISTS (
  select  
      ref_7.PASSWORD as c0, 
      ref_7.PASSWORD as c1, 
      ref_7.PASSWORD as c2, 
      ref_7.PASSWORD as c3
    from 
      user_history_temp as ref_7
    where (case when subq_0.c1 is NULL then (select PASSWORD from user_history_temp limit 1 offset 5)
             else (select PASSWORD from user_history_temp limit 1 offset 5)
             end
           is NULL) 
      or ((select PASSWORD from user_history_temp limit 1 offset 4)
           is not NULL))
limit 71;
drop table user_history_temp;

DROP TABLE IF EXISTS "SALARIES";
CREATE TABLE "SALARIES"
(
  "EMP_NO" BINARY_INTEGER NOT NULL,
  "SALARY" BINARY_INTEGER NOT NULL,
  "FROM_DATE" DATE NOT NULL,
  "TO_DATE" DATE NOT NULL
);
INSERT INTO "SALARIES" values(10001,5000,'1986-06-26 00:00:00','9999-01-01 00:00:00');
SELECT 
   1
   FROM 
	  SALARIES AS SUBQ_0
   WHERE (SUBQ_0.EMP_NO, SUBQ_0.EMP_NO) not IN (
      SELECT 
         SUBQ_0.EMP_NO AS C2, 
         SUBQ_0.EMP_NO AS C3
         FROM 
            SALARIES AS REF_3
         ORDER BY 
            REF_3.TO_DATE);
DROP TABLE "SALARIES";

drop table if exists sub_in_cond_1;
drop table if exists sub_in_cond_2;
create table sub_in_cond_1(a int, b int , c varchar(10));
create table sub_in_cond_2(a int, b int , c varchar(10));
insert into sub_in_cond_1 values(1, 1, 'aa');
insert into sub_in_cond_1 values(2, null, 'bbb');
insert into sub_in_cond_1 values(3, 2, 'aaa');
insert into sub_in_cond_1 values(null, 5, 'b');
insert into sub_in_cond_1 values(5, 5, 'aa');
insert into sub_in_cond_2 values(1, 1, 'aa');
insert into sub_in_cond_2 values(2, null, 'bbb');
insert into sub_in_cond_2 values(3, 2, 'aaa');
insert into sub_in_cond_2 values(4, 1, 'b');
insert into sub_in_cond_2 values(null, 3, 'aa');
commit;

select * from sub_in_cond_1 t where exists (select distinct b, count(a) from sub_in_cond_1 group  by b order by count(a));
select * from sub_in_cond_1 t where exists (select t.b from sub_in_cond_1 where t.b = 1 group  by t.b order by count(t.b));
select * from sub_in_cond_1 t where exists (select t.b, count(t.a) from sub_in_cond_1 order by count(t.b));
select * from sub_in_cond_1 t where exists (select count(t.a) from sub_in_cond_1 having count(t.a) = 1 order by count(t.a))   ;
select * from sub_in_cond_1 t where exists(select array[b] from sub_in_cond_1 t1 start with a = 1 connect by nocycle prior a = b order siblings by a);
select * from sub_in_cond_1 t where exists (select (select t1.b from sub_in_cond_2 where rownum < 1 ) from sub_in_cond_1 t1 LEFT join sub_in_cond_2 t2 on t1.a = t2.a order by (select t1.b from sub_in_cond_2 where rownum < 1 ));
select * from sub_in_cond_1 t where exists(select distinct a from sub_in_cond_1 t1 start with a = 1 connect by nocycle prior a = b order siblings by a);
select * from sub_in_cond_1 t where exists (select count(t.b), t.b, sum(a+t.b) from sub_in_cond_1 where t.b = 1 group  by t.b, a having count(t.b) = 1 and sum(t.b +10) > 0 order by count(t.b), count(a), count(t.b+1),count(t.b+a));
select * from sub_in_cond_1 t where exists (select distinct count(t.b), t.b, sum(a+t.b) from sub_in_cond_1 where t.b = 1 group  by t.b, a having count(t.b) = 1 and sum(t.b +10) > 0 order by count(t.b));
select * from sub_in_cond_1 t where exists(select * from sub_in_cond_1 t1 left join sub_in_cond_2 t2 on  t1.a = t2.a 
connect by prior t1.a = t2.b order by sys_connect_by_path(t1.a,'/'));
select count(*) from sub_in_cond_2 t1 where (a,b) in (select t1.a,b  from sub_in_cond_1 t2 order by t1.a);
select a from sub_in_cond_1 t where exists(
	select distinct listagg(((select rownum rn from sub_in_cond_1 where rownum < 2 and t.a = 1))) within group(order by b) over(partition by b) 
	from sub_in_cond_1 t1
	where rowid in (select rowid from sub_in_cond_1 where t.a = t1.a) 
	order by (select count(rowid) from sub_in_cond_1 where t.a = a)) group by a order by a;
SELECT
  1
FROM
  sub_in_cond_1 PIVOT(CORR(
      CAST(NULL AS BINARY_INTEGER),
      CAST(sub_in_cond_1.a AS BINARY_INTEGER)) AS AGGR_0
     FOR (c)
    IN (('王五') AS PEXPR_0))  REF_0
WHERE EXISTS (
  SELECT
      CAST('4863-1' AS INTERVAL YEAR(4) TO MONTH) AS C0
    FROM
      (SELECT
            REF_0.b AS C0
          FROM
            sub_in_cond_2 AS REF_1
        ) AS SUBQ_0
    WHERE NVL2(
        CAST(NULL AS DATE),
        CAST(19 AS BINARY_INTEGER),
        CAST(72 AS BINARY_INTEGER)) IS NULL
    START WITH EXISTS (
        SELECT
            SUBQ_0.C0 AS C6
          FROM
            sub_in_cond_2 AS REF_2
          WHERE (0.01 BETWEEN
              NULL AND
              REF_0.PEXPR_0_AGGR_0))
      CONNECT BY SUBQ_0.C0 LIKE '%');
drop table sub_in_cond_1;
drop table sub_in_cond_2;