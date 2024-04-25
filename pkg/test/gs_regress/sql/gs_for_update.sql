CREATE TABLE T_FORUPDATE_1 (F_INT1 INT, F_INT2 INT, F_CHAR CHAR(16), F_DATE DATE);

SELECT * FROM (SELECT * FROM T_FORUPDATE_1 FOR UPDATE) TT;
SELECT * FROM T_FORUPDATE_1 WHERE F_INT1 IN (SELECT F_INT1 FROM T_FORUPDATE_1 FOR UPDATE);
SELECT * FROM T_FORUPDATE_1 WHERE F_INT1 = (SELECT F_INT1 FROM T_FORUPDATE_1 FOR UPDATE);
SELECT F_INT1 FROM T_FORUPDATE_1 FOR UPDATE UNION ALL SELECT F_INT1 FROM T_FORUPDATE_1;
SELECT F_INT1 FROM T_FORUPDATE_1 FOR UPDATE LIMIT 1;

INSERT INTO T_FORUPDATE_1 VALUES(1,2,'A','2017-12-11 14:08:00');
INSERT INTO T_FORUPDATE_1 VALUES(3,4,'C','2017-12-12 16:08:00');

SELECT F_INT1 FROM T_FORUPDATE_1 UNION ALL SELECT F_INT1 FROM T_FORUPDATE_1 ORDER BY F_INT1 DESC FOR UPDATE;
SELECT F_INT1 FROM T_FORUPDATE_1 ORDER BY F_INT1 DESC FOR UPDATE;
SELECT F_INT1 FROM T_FORUPDATE_1 GROUP BY F_INT1 ORDER BY F_INT1 FOR UPDATE;
SELECT F_INT1 FROM T_FORUPDATE_1 GROUP BY F_INT1 ORDER BY F_INT1 DESC LIMIT 1 FOR UPDATE;

DROP TABLE T_FORUPDATE_1;

--for update sql stmt test in single session
drop table if exists test_for_update_tb1;
drop table if exists test_for_update_tb2;
create table test_for_update_tb1 (id int);
create table test_for_update_tb2 (id int);
insert into test_for_update_tb1 values(2),(3),(4);
insert into test_for_update_tb2 values(2),(3),(4),(5);

--test for update
select id from test_for_update_tb1 where id > 0 limit 1 for update;
select id from test_for_update_tb1 where id > 0 limit 1 for update nowait;
select id from test_for_update_tb1 where id > 0 limit 1 for update wait 0;
select id from test_for_update_tb1 where id > 0 limit 1 for update wait 666;
select id from test_for_update_tb1 where id > 0 limit 1 for update wait 4294967295;
select id from test_for_update_tb1 where id > 0 limit 1 for update skip locked;

--syntax error cases
select id from test_for_update_tb1 where id > 0 limit 1 for update nowait kk;
select id from test_for_update_tb1 where id > 0 limit 1 for update wait -1;
select id from test_for_update_tb1 where id > 0 limit 1 for update wait 4294967296;
select id from test_for_update_tb1 where id > 0 limit 1 for update wait gg;
select id from test_for_update_tb1 where id > 0 limit 1 for update skip;
select id from test_for_update_tb1 where id > 0 limit 1 for update skip fff;
select id from test_for_update_tb1 where id > 0 limit 1 for update asdf;
select id from test_for_update_tb1 where id > 0 limit 1 for update 123;

--test update
update test_for_update_tb1 set id = 2 where id = 7;
commit;
update test_for_update_tb1 set id = 7 where id = 2;

select * from test_for_update_tb1 join test_for_update_tb2 on test_for_update_tb1.id = test_for_update_tb2.id limit 1 for update skip locked;

--test for update in procedure
create or replace procedure test_for_update_proc1()
as
  dynamic_atest_for_update_tb2_column_sql nvarchar(512);
  cnt number;
begin
  dynamic_atest_for_update_tb2_column_sql:= 'update test_for_update_tb1 set id = 2 where id = 7';
  execute immediate dynamic_atest_for_update_tb2_column_sql;
  dynamic_atest_for_update_tb2_column_sql:= 'commit';
  execute immediate dynamic_atest_for_update_tb2_column_sql;
  dynamic_atest_for_update_tb2_column_sql:= 'update test_for_update_tb1 set id = 7 where id = 2';
  execute immediate dynamic_atest_for_update_tb2_column_sql;
  dynamic_atest_for_update_tb2_column_sql:= 'select * from test_for_update_tb1 join test_for_update_tb2 on test_for_update_tb1.id = test_for_update_tb2.id limit 1 for update skip locked';
  execute immediate dynamic_atest_for_update_tb2_column_sql;
  dynamic_atest_for_update_tb2_column_sql:= 'select * from test_for_update_tb1 join test_for_update_tb2 on test_for_update_tb1.id = test_for_update_tb2.id limit 1 for update nowait';
  execute immediate dynamic_atest_for_update_tb2_column_sql;
  dynamic_atest_for_update_tb2_column_sql:= 'select * from test_for_update_tb1 join test_for_update_tb2 on test_for_update_tb1.id = test_for_update_tb2.id limit 1 for update';
  execute immediate dynamic_atest_for_update_tb2_column_sql;
  dynamic_atest_for_update_tb2_column_sql:= 'select * from test_for_update_tb1 join test_for_update_tb2 on test_for_update_tb1.id = test_for_update_tb2.id limit 1 for update wait 2';
  execute immediate dynamic_atest_for_update_tb2_column_sql;
end test_for_update_proc1;
/

call test_for_update_proc1();

--end
drop procedure if exists test_for_update_proc1;
drop table if exists test_for_update_tb1;
drop table if exists test_for_update_tb2;
commit;

drop table if exists test_for_update_t1;
drop table if exists test_for_update_t2;
drop table if exists test_for_update_t3;

create table test_for_update_t1(f1 int, f2 int);
create table test_for_update_t2(f1 int, f2 int);
create table test_for_update_t3(f1 int, f2 int);
INSERT INTO test_for_update_t1 VALUES(1,11);
INSERT INTO test_for_update_t2 VALUES(1,11);
INSERT INTO test_for_update_t3 VALUES(1,11);
commit;
create view test_for_update_v1 as select * from test_for_update_t1;

select * from test_for_update_t1 for update of f1;
select * from test_for_update_v1 for update of f1 nowait;
select * from test_for_update_t1 for update of f1+1 nowait;
select * from test_for_update_t1 for update of f3 nowait;
select * from test_for_update_t1 union (select * from test_for_update_t2) for update;
select * from (select distinct f1,f2 from test_for_update_t2) t2 for update of t2.f1;
select * from (select 1 f1 from test_for_update_t2) t2 for update;
select * from (select 1 f1 from test_for_update_t2) t2 for update of t2.f1;
select * from (select f1+f2 AS F1 from test_for_update_t2) t2 for update of t2.f1;
select * from (select f1, sum(f2) from test_for_update_t2 group by f1) t2 for update of t2.f1;
select * from (select count(f1) F1 from test_for_update_t2) t2 for update of t2.f1;
select * from (select F1,F2 from test_for_update_t2 WHERE ROWNUM < 10) t2 for update of t2.f1;
select * from (select F1,F2 from test_for_update_t2 LIMIT 10) t2 for update of t2.f1;
select * from (select F1,F2 from (SELECT t1.f1,t2.f2 FROM test_for_update_t1 t1, test_for_update_t2 t2)) t2 for update of t2.f1;
SELECT t1.f1,t2.f2 FROM test_for_update_t1 t1, test_for_update_t2 t2 for update of t2.f1;

drop view test_for_update_v1;
drop table test_for_update_t1;
drop table test_for_update_t2;
drop table test_for_update_t3;

drop table if exists t_siblings_base;
create table t_siblings_base(EMPNO NUMBER(4),ENAME VARCHAR2(10),MGR NUMBER(4));

insert into t_siblings_base values (1,'M',NULL);
insert into t_siblings_base values (2,'N',NULL);
insert into t_siblings_base values (3,'A',NULL);
insert into t_siblings_base values (4,'C',3);
insert into t_siblings_base values (null,'C',3);
insert into t_siblings_base values (5,'B',3);
insert into t_siblings_base values (6,'F',4);
insert into t_siblings_base values (7,'E',4);
insert into t_siblings_base values (8,'D',5);
insert into t_siblings_base values (9,'G',5);
commit;
select /*+ FULL +*/ level,case when ENAME='E' then null else ename end c ,PRIOR ENAME PRIORENAME,EMPNO,PRIOR EMPNO PRIOREMPNO,MGR from t_siblings_base as of timestamp current_timestamp start with MGR is null connect by PRIOR empno = mgr order siblings by c nulls last limit 5 offset 2 for update;
drop table t_siblings_base;

--DTS2019121913100
drop table if exists t_left_join_base_001;
drop table if exists t_left_join_base_002;
create table t_left_join_base_001(i int not null,j int,k varchar(15));
create table t_left_join_base_002(i int,j int,k varchar(15)) ;

insert into t_left_join_base_001 values(1,1,'abc');
insert into t_left_join_base_001 values(1,1,'abc');
insert into t_left_join_base_001 values(1,1,'abc');
insert into t_left_join_base_001 values(1,1,'abcdefg');
insert into t_left_join_base_001 values(1,1,'abcdefg');
insert into t_left_join_base_001 values(1,1,'abcdefg lmn');
insert into t_left_join_base_001 values(1,1,'abcdefg lmn');
insert into t_left_join_base_001 values(10,16,'abcdefg');
insert into t_left_join_base_001 values(11,17,'abcdefg');
insert into t_left_join_base_001 values(12,18,'abcdefg');
insert into t_left_join_base_002 values(1,1,'abc');
insert into t_left_join_base_002 values(1,1,'abc');
insert into t_left_join_base_002 values(1,1,'abc');
insert into t_left_join_base_002 values(1,1,'abcdefg');
insert into t_left_join_base_002 values(1,1,'abcdefg');
insert into t_left_join_base_002 values(1,1,'abcdefg hijk');
insert into t_left_join_base_002 values(1,1,'abcdefg hijk');
insert into t_left_join_base_002 values(8,14,'abcdefg');
insert into t_left_join_base_002 values(9,15,'abc23');
select * from t_left_join_base_001 a left join t_left_join_base_002 b on a.i=b.i and a.i in(1,10,100) order by 1,2,3,4 offset 49;
select * from t_left_join_base_001 a left join t_left_join_base_002 b on a.i=b.i and a.i in(1,10,100) order by 1,2,3,4 offset 49 for update;

--DTS2020011402670
drop table if exists  t_all_base_001;
--大表
create table t_all_base_001(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date);
drop index if exists idx_join_base_001_1 on t_all_base_001;
drop index if exists idx_join_base_001_2 on t_all_base_001;
drop index if exists idx_join_base_001_3 on t_all_base_001;
create index idx_join_base_001_1 on t_all_base_001(c_int);
create index idx_join_base_001_2 on t_all_base_001(c_int,c_vchar);
create index idx_join_base_001_3 on t_all_base_001(c_int,c_vchar,c_date);
insert into t_all_base_001 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
                sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_vchar||'||i||',c_clob||'||i||',c_blob'||',c_date from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/
exec proc_insert('t_all_base_001',1,20);
commit;
select count(*) from t_all_base_001 t11 left join t_all_base_001 t12 on 1=1
where t11.c_int = any(
  with tmp as(select id+c_int as c from t_all_base_001 where id<21)
select case when c>0 then c end from tmp connect by c=0) for update;

drop table t_all_base_001;

drop table if exists  for_update_table_002;
create table for_update_table_002(i int,j int,k varchar(15)) ;
insert into for_update_table_002 values(1,1,'abc');
insert into for_update_table_002 values(2,1,'abc');
insert into for_update_table_002 values(3,1,'abc');
insert into for_update_table_002 values(4,1,'abcdefg');
insert into for_update_table_002 values(5,1,'abcdefg');
insert into for_update_table_002 values(1,1,'abcdefg hijk');
insert into for_update_table_002 values(1,1,'abcdefg hijk');
insert into for_update_table_002 values(8,14,'abcdefg');
insert into for_update_table_002 values(9,15,'abc23');
select rownum,t1.i from (select * from for_update_table_002) t1 join for_update_table_002 t2 on rownum <=1 for update;
drop table if exists  for_update_table_002;

drop table if exists t_null_select_001;
create table t_null_select_001(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10) not null,c_vchar2 varchar2(100),c_clob clob,
c_long varchar(200),c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp);
insert into t_null_select_001 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_null_select_001 values(-1,null,null,null,null,null,null,'M',null,null,null,null,null,null,null);
commit;
	 
SELECT MIN(t2.c_int) AS c_int FROM t_null_select_001 t1, t_null_select_001 t2 order by 1 for update of t2.c_number;
drop table t_null_select_001;