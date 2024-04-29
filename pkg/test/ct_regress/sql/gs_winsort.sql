conn / as sysdba
drop table if exists t_par_tab_idx_0001;
CREATE TABLE t_par_tab_idx_0001
(c_vchar varchar(2000))
PARTITION BY LIST (c_vchar)
(
partition t_par_tab_idx_0001_P_50 values ('1+2+1.1' ||max(2) over(partition by 1)),  
partition t_par_tab_idx_0001_P_100 values (upper('abc'))
);
drop table if exists t_par_tab_idx_0001;
drop table if exists t_par_tab_idx_0002;
CREATE TABLE t_par_tab_idx_0002
(c_vchar varchar(2000))
PARTITION BY LIST (c_vchar)
(
partition t_par_tab_idx_0002_P_50 values ('1+2+1.1'),
partition t_par_tab_idx_0002_P_100 values (upper('abc'))
);
insert into t_par_tab_idx_0002 values('1+2+1.1'||max(2) over(partition by 1));   
update t_par_tab_idx_0002 set c_vchar = max(2) over(partition by 1); 
REPLACE INTO t_par_tab_idx_0002(c_vchar) VALUES(max(2) over(partition by 1));
drop table if exists TEST;
create table TEST (ID INTEGER,VALUE VARCHAR2(255) );
MERGE INTO  TEST T1
USING (SELECT '2' as ID, 'newtest2' as VALUE FROM dual) T2 on (T1.ID=T2.ID)
WHEN MATCHED THEN UPDATE SET T1.VALUE=max(2) over(partition by 1)
WHEN NOT MATCHED THEN  INSERT (T1.VALUE) VALUES (max(2) over(partition by 1));
insert into TEST values (2, 'test2');
MERGE INTO  TEST T1
USING (SELECT '2' as ID, 'newtest2' as VALUE FROM dual) T2 on (T1.ID=T2.ID)
WHEN MATCHED THEN UPDATE SET T1.VALUE=max(2) over(partition by 1)
WHEN NOT MATCHED THEN  INSERT (T1.VALUE) VALUES (max(2) over(partition by 1));
drop table TEST;
create table TEST_INTREVAL_ALL_PART_STORE
(HIREDATE DATE)
PARTITION BY RANGE (HIREDATE)
INTERVAL (NUMTODSINTERVAL(max(2) over(partition by 1),'DAY'))
STORE IN(tablespace users, tablespace system)
(PARTITION ALL_PART_STORE_PART01
VALUES LESS THAN (TO_DATE ('02/02/1981', 'MM/DD/YYYY')),
PARTITION ALL_PART_STORE_PART02
VALUES LESS THAN (TO_DATE ('03/02/1981', 'MM/DD/YYYY'))
);
create table TEST_INTREVAL_ALL_PART_STORE
( HIREDATE DATE)
PARTITION BY RANGE (HIREDATE)
INTERVAL (NUMTODSINTERVAL(1,'DAY'))
STORE IN(tablespace users, tablespace system)
(PARTITION ALL_PART_STORE_PART01
VALUES LESS THAN (max(2) over(partition by 1)),
PARTITION ALL_PART_STORE_PART02
VALUES LESS THAN (TO_DATE ('03/02/1981', 'MM/DD/YYYY'))
);
create table TEST_INTREVAL_ALL_PART_STORE
( HIREDATE DATE)
PARTITION BY RANGE (HIREDATE)
(PARTITION ALL_PART_STORE_PART01
VALUES LESS THAN (TO_DATE ('03/02/1980', 'MM/DD/YYYY')),
PARTITION ALL_PART_STORE_PART02
VALUES LESS THAN (TO_DATE ('03/02/1981', 'MM/DD/YYYY'))
);
alter table TEST_INTREVAL_ALL_PART_STORE set INTERVAL (NUMTODSINTERVAL(max(2) over(partition by 1),'DAY'));
drop table if exists cao_tt2;
create table cao_tt2(id int check (id > max(2) over(partition by 1)));
create table cao_tt2(id int );
alter table cao_tt2 add constraint ck_error check (id > max(2) over(partition by 1));
drop table if exists cao_tt2;
CREATE TABLE bonus_2018(staff_id INT NOT NULL, staff_name CHAR(50), job VARCHAR(30), bonus NUMBER);
FLASHBACK TABLE bonus_2018 TO TIMESTAMP max(2) over(partition by 1);
drop table if exists bonus_2018;
select * from dual limit 1+max(2) over(partition by 1);
create or replace procedure testProcWithAllTypeInputOut(datetime_type IN datetime,timestamp_type IN TIMESTAMP)
as
SWC_Current_1 SYS_REFCURSOR;
begin
    if (datetime_type > 1+max(2) over(partition by 1))
    then
    open SWC_Current_1 for select datetime_type as datetime1,timestamp_type as timestamp_type1 from dual;
    dbe_sql.return_cursor(SWC_Current_1);
    end if;
end;
/
drop table if exists t_aggr_1;
create table t_aggr_1(f0 int, f1 bigint, f2 double, f3 number(20,10), f4 date, f5 timestamp, f6 char(100), f7 varchar(100), f8 binary(100), f9 clob, f10 blob);

-- int/bigint/real/decimal/date/timestamp
insert into t_aggr_1(f0) values(10);
insert into t_aggr_1(f0) values(null);
insert into t_aggr_1(f0) values(5);
insert into t_aggr_1(f0) values(15);
insert into t_aggr_1(f1) values(2147483648);
insert into t_aggr_1(f1) values(null);
insert into t_aggr_1(f1) values(2147483650);
insert into t_aggr_1(f1) values(2147483649);
insert into t_aggr_1(f2) values(12334.997);
insert into t_aggr_1(f2) values(null);
insert into t_aggr_1(f2) values(12334.999);
insert into t_aggr_1(f2) values(12334.998);
insert into t_aggr_1(f3) values(9912334.997);
insert into t_aggr_1(f3) values(null);
insert into t_aggr_1(f3) values(9912334.999);
insert into t_aggr_1(f3) values(9912334.998);
insert into t_aggr_1(f4) values('2018-02-23 13:18:23');
insert into t_aggr_1(f4) values(null);
insert into t_aggr_1(f4) values('2018-02-23 13:18:25');
insert into t_aggr_1(f4) values('2018-02-23 13:18:24');
insert into t_aggr_1(f5) values('2018-02-23 13:18:23.345');
insert into t_aggr_1(f5) values(null);
insert into t_aggr_1(f5) values('2018-02-23 13:18:23.347');
insert into t_aggr_1(f5) values('2018-02-23 13:18:23.346');
insert into t_aggr_1(f6) values('2018-02-23 13:18:23.345');
insert into t_aggr_1(f6) values(null);
insert into t_aggr_1(f6) values('2018-02-23 13:18:23.347');
insert into t_aggr_1(f6) values('2018-02-23 13:18:23.346');
insert into t_aggr_1(f7) values('2018-02-23 13:18:23.345');
insert into t_aggr_1(f7) values(null);
insert into t_aggr_1(f7) values('2018-02-23 13:18:23.347');
insert into t_aggr_1(f7) values('2018-02-23 13:18:23.346');
insert into t_aggr_1(f8, f9, f10) values('1D', '222', '3133');
insert into t_aggr_1(f8, f9, f10) values('1F', '222', '3323');
insert into t_aggr_1(f8, f9, f10) values('1E', '222', '3333');
commit;

select max(f0 + 1) over (partition by f0 order by f0) from t_aggr_1 where f0 is not null;
select max(-f0) over (partition by f0 order by f0) from t_aggr_1 where f0 is not null;
select max(if(f0 is not null, f0, 1)) over (partition by f0 order by f0) from t_aggr_1 where f0 is not null;
select max(if(f0 > 0, f0, 1)) over (partition by f0 order by f0) from t_aggr_1 where f0 is not null;
select max(if(not f0 > 0, f0, 1)) over (partition by f0 order by f0) from t_aggr_1 where f0 is not null;
select max(if(f0 is not null and f1 is null, f0, 1)) over (partition by f0 order by f0) from t_aggr_1 where f0 is not null;

select count(f0), sum(f0), max(f0), min(f0), avg(f0), row_number() over (partition by f0 order by f0) from t_aggr_1;
select count(f0), sum(f0), max(f0), min(f0), avg(f0), row_number() over (partition by f0 order by f0) from t_aggr_1;
select distinct sum(f0), row_number() over (partition by f0 order by f0) from t_aggr_1;
select row_number() over (partition by f0 order by f0) from t_aggr_1 group by f0;
explain plan for select row_number() over (partition by f0 order by f0) from t_aggr_1 group by f0;
explain plan for select row_number() over (partition by f0 order by f0), row_number() over (partition by f1 order by f1) from t_aggr_1;

select row_number() over from t_aggr_1;
select row_number() over () from t_aggr_1;
select row_number() over (partition by f0) from t_aggr_1;
select row_number() over (aa) from t_aggr_1;

select * from t_aggr_1 where row_number() over (partition by f0 order by f0) = 1;

select count(f1) over (partition by f0) from t_aggr_1;
select count(*) over (partition by f0) from t_aggr_1;
drop table if exists tbl_range;
create table tbl_range(
col_int int AUTO_INCREMENT primary key,
col_bigint bigint not null default '3',
col_integer integer,
col_varchar_200 varchar(200),
col_varchar2_1000 varchar2(1000)
);

explain SELECT col_int,
       (case
         when col_varchar_200 is not null then
          col_varchar_200
         else
          'NO'
       end) as c1,
       Row_Number() OVER(partition by(case
         when col_varchar_200 is not null then
          col_varchar_200
         else
          'NO'
       end),(case
         when col_varchar2_1000 >= col_varchar_200 then
          col_varchar2_1000
         else
          col_varchar_200
       end) ORDER BY col_int desc) as c3
  FROM tbl_range;
  
--DTS2019011706076 
drop table if exists t_winsort_001;
drop table if exists t_winsort_101;

create table t_winsort_001(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10),c_vchar2 varchar2(100),c_clob clob,
c_long clob,c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp)
PARTITION BY RANGE(id)
(
PARTITION id1 VALUES LESS than(10),
PARTITION id2 VALUES LESS than(100),
PARTITION id3 VALUES LESS than(1000),
PARTITION id4 VALUES LESS than(MAXVALUE)
);
insert into t_winsort_001 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-01-01 10:51:47.123456'),'yyyy-mm-dd hh24:mi:ss.FF6'));
insert into t_winsort_001 values(0,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
   
create table t_winsort_101 as select * from t_winsort_001;    

select count(*) from t_winsort_001 t1 where exists (select max(t11.c_int) over(partition by max(t11.c_int) over(partition by 100000)) from t_winsort_101 t11 where t11.c_number=t1.c_number);

drop table t_winsort_001;
drop table t_winsort_101;


drop table if exists t_winsort_002;
create table t_winsort_002(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10),c_vchar2 varchar2(100),c_clob clob,
c_long clob,c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp)
PARTITION BY RANGE(id)
(
PARTITION id1 VALUES LESS than(10),
PARTITION id2 VALUES LESS than(100),
PARTITION id3 VALUES LESS than(1000),
PARTITION id4 VALUES LESS than(MAXVALUE)
);
insert into t_winsort_002 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-01-01 10:51:47.123456'),'yyyy-mm-dd hh24:mi:ss.FF6'));

select case when max(id) over( partition by (c_int+c_real)) then id end from t_winsort_002;
drop table t_winsort_002;

drop table if exists cume_dist_t1;
create table cume_dist_t1(c1 int , c2 int, c3 varchar(10));
insert into cume_dist_t1 values(1,3,'a1'),(1,2,'a2'),(1,1,'a3'),(1,3,'a4'),(1,2,'a5');
insert into cume_dist_t1 values(2,1,'a6'),(2,3,'a7'),(2,2,'a8'),(2,1,'a9');
insert into cume_dist_t1 values(3,1,'a10'),(3,3,'a11'),(3,2,'a12'),(3,1,'a13'),(3,5,'a14'),(3,5,'a15'),(3,7,'a16');
insert into cume_dist_t1 values(4,1,'a17');
commit;

--ok
select c1, c2, c3, CUME_DIST() OVER (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select c1, c2, c3, CUME_DIST() OVER (ORDER BY c1 desc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select c1, c2, c3, CUME_DIST() OVER (ORDER BY c1 asc, c2 desc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select c1, c2, c3, CUME_DIST() OVER (ORDER BY c1 desc, c2 desc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select c1, c2, c3, CUME_DIST() OVER (partition by c1 ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select c1, c2, c3, CUME_DIST() OVER (partition by c1 ORDER BY c1 desc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select c1, c2, c3, CUME_DIST() OVER (partition by c1 ORDER BY c1 asc, c2 desc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select c1, c2, c3, CUME_DIST() OVER (partition by c1 ORDER BY c1 desc, c2 desc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select c1, c2, c3, cast(CUME_DIST() OVER (partition by c1 ORDER BY c1 asc, c2 asc) as double) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;

--error
select c1, c2, c3, CUME_DIST(23) OVER (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
drop table if exists cume_dist_t1;

-- CUME_DIST as aggr func
drop table if exists cume_dist_t1;
create table cume_dist_t1(c1 int , c2 int, c3 varchar(10));
insert into cume_dist_t1 values(6,3,'a1');
insert into cume_dist_t1 values(6,2,'a2');
insert into cume_dist_t1 values(6,1,'a3');
insert into cume_dist_t1 values(7,1,'a3');
commit;

select CUME_DIST(6, '3.365') WITHIN GROUP (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(6, 3) WITHIN GROUP (ORDER BY c1 asc, c3 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(6, '3') WITHIN GROUP (ORDER BY c1 asc, c3 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(6, 'a1') WITHIN GROUP (ORDER BY c1 asc, c3 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(6, 'a2') WITHIN GROUP (ORDER BY c1 asc, c3 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(6, 'a3') WITHIN GROUP (ORDER BY c1 asc, c3 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(6, 'a5') WITHIN GROUP (ORDER BY c1 asc, c3 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(8, 'a5') WITHIN GROUP (ORDER BY c1 asc, c3 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;

select CUME_DIST(2, 2) WITHIN GROUP (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(2, '2') WITHIN GROUP (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(6, '2') WITHIN GROUP (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(6, ' 1 ') WITHIN GROUP (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(2, 'ew') WITHIN GROUP (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(2, ' 34rfd') WITHIN GROUP (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(2, '00gfdtr') WITHIN GROUP (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(2) WITHIN GROUP (ORDER BY c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc;
select c1, CUME_DIST(2) WITHIN GROUP (ORDER BY c2 asc) as "cume_dist_col"  FROM cume_dist_t1 group by c1 order by c1 asc;

select CUME_DIST('2', '2') WITHIN GROUP (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST('2aaa', '2') WITHIN GROUP (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;

select CUME_DIST(6) WITHIN GROUP (ORDER BY c1 asc, c3 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(6, 'a1') WITHIN GROUP (ORDER BY c1 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(c1) WITHIN GROUP (ORDER BY c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc;
select CUME_DIST(c1, c2) WITHIN GROUP (ORDER BY c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc;
select CUME_DIST('cdsfdsvfd', 2) WITHIN GROUP (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(5, 'dscvdscvsd') WITHIN GROUP (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;
select CUME_DIST(current_timestamp(), 2) WITHIN GROUP (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM cume_dist_t1 order by c1 asc, c2 asc, c3 asc;

select CUME_DIST(3, 3) WITHIN GROUP (ORDER BY c1 asc, c3 asc) as "cume_dist_col"  FROM cume_dist_t1 group by c1 order by c1 asc;
select CUME_DIST(3, '3') WITHIN GROUP (ORDER BY c1 asc, c3 asc) as "cume_dist_col"  FROM cume_dist_t1 group by c1 order by c1 asc;
select CUME_DIST(3, 'a1') WITHIN GROUP (ORDER BY c1 asc, c3 asc) as "cume_dist_col"  FROM cume_dist_t1 group by c1 order by c1 asc;

select CUME_DIST(8, 3) WITHIN GROUP (ORDER BY c1 asc, c3 asc) as "cume_dist_col"  FROM cume_dist_t1 group by c1 order by c1 asc;
select CUME_DIST(8, '3d') WITHIN GROUP (ORDER BY c1 asc, c3 asc) as "cume_dist_col"  FROM cume_dist_t1 group by c1 order by c1 asc;
select CUME_DIST(8, 'bb') WITHIN GROUP (ORDER BY c1 asc, c3 asc) as "cume_dist_col"  FROM cume_dist_t1 group by c1 order by c1 asc;
drop table if exists cume_dist_t1;
select dummy from dual order by row_number() over(partition by dummy);
select dummy from dual order by row_number() over(order by dummy);

--DENSE_RANK()
drop table if exists tb_win_emp;
create table tb_win_emp(ename char(10), Hiredate date, sal int);
insert into tb_win_emp values('smith', to_date('1980-12-17', 'yyyy-mm-dd'), 800);
insert into tb_win_emp values('allen', to_date('1981-2-20', 'yyyy-mm-dd'), 1600);
insert into tb_win_emp values('ward', to_date('1981-2-22', 'yyyy-mm-dd'), 1250);
insert into tb_win_emp values('turner', to_date('1980-12-17', 'yyyy-mm-dd'), 1500);
insert into tb_win_emp values('king', to_date('1981-2-20', 'yyyy-mm-dd'), 5000);
insert into tb_win_emp values('ford', to_date('1980-12-17', 'yyyy-mm-dd'), 950);
insert into tb_win_emp values('rum', to_date('1980-12-17', 'yyyy-mm-dd'), 1500);
insert into tb_win_emp values('tom', to_date('1981-2-20', 'yyyy-mm-dd'), 2975);
insert into tb_win_emp values('zoe', to_date('1981-2-22', 'yyyy-mm-dd'), 1250);
insert into tb_win_emp values('abd', to_date('1980-12-17', 'yyyy-mm-dd'), null);
insert into tb_win_emp values('eae', to_date('1981-2-20', 'yyyy-mm-dd'), null);
insert into tb_win_emp values('wer', to_date('1981-2-22', 'yyyy-mm-dd'), null);
insert into tb_win_emp values('ward', to_date('1981-2-22', 'yyyy-mm-dd'), 1250);
insert into tb_win_emp values('ward', to_date('1981-2-22', 'yyyy-mm-dd'), 900);
insert into tb_win_emp values('turner', to_date('1980-12-17', 'yyyy-mm-dd'), 1550);
commit;
select sal, dense_rank() over (order by sal) as dense_rank from tb_win_emp;
select hiredate, sal, dense_rank() over (partition by hiredate order by sal) as dense_rank from tb_win_emp;
select hiredate, sal, ename, dense_rank() over (partition by hiredate order by sal desc nulls last, ename asc nulls first) as dense_rank from tb_win_emp;
select hiredate, sal, dense_rank() over (partition by hiredate) as dense_rank from tb_win_emp;
select hiredate, sal, dense_rank(sal) over (partition by hiredate order by sal) as dense_rank from tb_win_emp;
select dense_rank() over (order by sal) as dense_rank from tb_win_emp group by hiredate;
--rank
select sal, rank() over (order by sal) as rank from tb_win_emp;
select hiredate, sal, rank() over (partition by hiredate order by sal) as rank from tb_win_emp;
select hiredate, sal, ename, rank() over (partition by hiredate order by sal desc nulls last, ename asc nulls first) as rank from tb_win_emp;
select hiredate, sal, rank() over (partition by hiredate) as rank from tb_win_emp;
select hiredate, sal, rank(sal) over (partition by hiredate order by sal) as rank from tb_win_emp;
select rank() over (order by sal) as rank from tb_win_emp group by hiredate;
drop table tb_win_emp;

drop table if exists t_winsort_push;
create table t_winsort_push(f_varchar1 varchar(32), f_int1 int, f_int2 int);
create index idx_t_winsort_push_1 on t_winsort_push(f_int1);
create index idx_t_winsort_push_2 on t_winsort_push(f_int2);
explain select * from (select f_int1,f_int2,sum(f_int2)over(partition by f_int1 order by f_int2) mm from t_winsort_push) where mm = 95;
explain select * from (select f_int1,f_int2,sum(f_int2)over(partition by f_int1 order by f_int2) mm from t_winsort_push) where f_int2 = 95;
explain select * from (select f_int1,f_int2,sum(f_int2)over(partition by f_int1 order by f_int2) mm from t_winsort_push) where f_int1 = 3;
explain SELECT TABLE_NAME  FROM USER_TAB_PARTITIONS WHERE TABLE_NAME ='TBL_RESULT_1526726743_1' AND ROWNUM <= 1;
drop table if exists t_winsort_push;

--array
drop table if exists t_rank_over_datatype;
create table t_rank_over_datatype(id int,deptno int,name varchar(20),sal int,col_16 int[],b_boolean boolean,f_floor decimal(10,2));
insert into t_rank_over_datatype values(1,1,'1aa',120,'{1,2,3}',true,10.2);
insert into t_rank_over_datatype values(2,1,'2aa',300,'{1,3,3}',false,100.2);
insert into t_rank_over_datatype values(3,1,'3aa',100,'{1,2,3}',true,99.2);
insert into t_rank_over_datatype values(4,1,'4aa',99,'{1,2,3}',true,67.2);
insert into t_rank_over_datatype values(5,1,'5aa',90,'{1,3,3}',false,67.2);
insert into t_rank_over_datatype values(6,2,'6aa',87,'{1,2,3}',true,10.2);
insert into t_rank_over_datatype values(7,2,'7aa',500,'{1,2,3}',false,99.2);
insert into t_rank_over_datatype values(8,2,'8aa',200,'{2,3,3}',true,10.2);
insert into t_rank_over_datatype values(9,2,'9aa',20,'{1,3,3}',false,99.5);
insert into t_rank_over_datatype values(10,2,'10aa',30,'{2,3,3}',true,99.5);
insert into t_rank_over_datatype values(null,2,'10aa',30,'{2,3,3}',false,10.2);
insert into t_rank_over_datatype values(12,2,'10aa',null,'{2,3,3}',true,10.2);
commit;
select col_16,nvl(id,sal),rank() over(partition by col_16[2] order by nvl(id,sal)) from t_rank_over_datatype order by 2,3;
select col_16[2],col_16,nvl(id,sal),rank() over(partition by col_16[2] order by nvl(id,sal)) from t_rank_over_datatype order by 3,4;
select col_16[2],col_16[1],col_16[1:2],col_16,nvl(id,sal),rank() over(partition by col_16[2] order by nvl(id,sal)) from t_rank_over_datatype order by 5,6;
drop table t_rank_over_datatype;

drop table if exists for_ntile;
create table for_ntile(f1 int, f2 int ,f3 int);
insert into for_ntile values(1,1,10);
insert into for_ntile values(2,1,15);
insert into for_ntile values(3,2,10);
insert into for_ntile values(4,2,15);
insert into for_ntile values(5,1,20);
insert into for_ntile values(6,1,12);
insert into for_ntile values(7,1,22);
insert into for_ntile values(8,1,12);
insert into for_ntile values(9,1,22);
insert into for_ntile values(10,1,15);
commit;
SELECT NTILE(1+1) OVER(PARTITION BY F2 ORDER BY F3) FROM FOR_NTILE;
select f1,f2,f3,f4 from (select f1,f2,f3,ntile(2) over(partition by f2 order by f3) f4 from for_ntile);
select case when ntile(4) over (partition by f2 order by f1,f2) in (1,2) then f2 end a from for_ntile;
drop table for_ntile;
drop table if exists salary;
create table salary(stuff_id INT, month INT, salary INT);
insert into salary values(1, 1, 800);
insert into salary values(1, 2, 900);
insert into salary values(2, 2, 900);
insert into salary values(2, 3, 950);
insert into salary values(3, 4, 880);
insert into salary values(3, 5, 930);
commit;
select stuff_id, month, salary, FIRST_VALUE(salary) over (PARTITION BY stuff_id) first_month_salary from salary;
drop table salary;

--DTS2020021006768
drop table if exists t_DTS2020021006768;
create table t_DTS2020021006768(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10) not null,c_vchar2 varchar2(100),c_clob clob,
c_long varchar(200),c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp);
insert into t_DTS2020021006768 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_DTS2020021006768 values(-1,null,null,null,null,null,null,'M',null,null,null,null,null,null,null);
CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
                sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_real+'||i||',c_float+'||i||',c_decimal+'||i||',c_number+'||i||',c_char'||',c_vchar||'||i||',c_vchar2||'||i||',c_clob||'||i||',c_long||'||i||',c_blob'||',c_raw,ADD_MONTHS(c_date,'||i||'),ADD_MONTHS(c_timestamp,'||i||') from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/
exec proc_insert('t_DTS2020021006768',1,6);
commit;
select prior count(id) over(order by t1.id) c from t_DTS2020021006768 t1 connect by nocycle prior t1.id=t1.id+1;
drop table t_DTS2020021006768;
--20200514
DROP TABLE if exists "FVT_OBJ_DEFINE_TABLE_FRE1";
DROP TABLE if exists "STUDENT";
DROP TABLE if exists "SCORE";
DROP TABLE if exists "EMPLOYEES";
DROP TABLE if exists "DEPARTMENTS";
DROP TABLE if exists "DEPT_MANAGER";
DROP TABLE if exists "DEPT_EMP";
DROP TABLE if exists "SALARIES";
DROP TABLE if exists "TEST";
DROP TABLE if exists "MY_EMPLOYEES";
CREATE TABLE "FVT_OBJ_DEFINE_TABLE_FRE1"
(
  "COL_1" BINARY_BIGINT,
  "COL_2" TIMESTAMP(6),
  "COL_3" BOOLEAN,
  "COL_4" NUMBER,
  "COL_5" CLOB,
  "COL_6" BINARY_INTEGER,
  "COL_7" CHAR(30 BYTE),
  "COL_8" BINARY_DOUBLE,
  "COL_9" CLOB,
  "COL_10" CLOB,
  "COL_11" VARCHAR(30 BYTE),
  "COL_12" BINARY_DOUBLE,
  "COL_13" BOOLEAN,
  "COL_14" BOOLEAN,
  "COL_15" BLOB,
  "COL_16" BINARY_DOUBLE,
  "COL_17" VARCHAR(30 BYTE),
  "COL_18" VARCHAR(30 BYTE),
  "COL_19" TIMESTAMP(6) WITH TIME ZONE,
  "COL_20" CHAR(30 BYTE),
  "COL_21" BLOB,
  "COL_22" NUMBER,
  "COL_23" BLOB,
  "COL_24" CHAR(30 BYTE),
  "COL_25" BINARY_INTEGER,
  "COL_26" BINARY_DOUBLE,
  "COL_27" NUMBER,
  "COL_28" NUMBER,
  "COL_29" BINARY_INTEGER,
  "COL_30" BLOB,
  "COL_31" BINARY_DOUBLE,
  "COL_32" BLOB,
  "COL_33" NUMBER,
  "COL_34" CHAR(30 BYTE),
  "COL_35" BINARY_DOUBLE,
  "COL_36" CHAR(30 BYTE),
  "COL_37" NUMBER,
  "COL_38" TIMESTAMP(6),
  "COL_39" BINARY_BIGINT,
  "COL_40" BINARY_DOUBLE,
  "COL_41" BLOB,
  "COL_42" BINARY_INTEGER,
  "COL_43" BINARY_DOUBLE,
  "COL_44" BINARY_INTEGER,
  "COL_45" TIMESTAMP(6),
  "COL_46" CLOB,
  "COL_47" CHAR(30 BYTE),
  "COL_48" NUMBER,
  "COL_49" BOOLEAN,
  "COL_50" BINARY_INTEGER,
  "COL_51" TIMESTAMP(6) WITH TIME ZONE,
  "COL_52" BLOB,
  "COL_53" BINARY_INTEGER,
  "COL_54" BINARY_INTEGER,
  "COL_55" NUMBER,
  "COL_56" BINARY_INTEGER,
  "COL_57" BLOB,
  "COL_58" TIMESTAMP(6) WITH TIME ZONE,
  "COL_59" NUMBER,
  "COL_60" BINARY_DOUBLE,
  "COL_61" INTERVAL DAY(2) TO SECOND(6),
  "COL_62" BINARY_DOUBLE,
  "COL_63" CLOB,
  "COL_64" TIMESTAMP(6) WITH TIME ZONE,
  "COL_65" TIMESTAMP(6) WITH TIME ZONE,
  "COL_66" VARCHAR(30 BYTE),
  "COL_67" BOOLEAN,
  "COL_68" CHAR(30 CHAR),
  "COL_69" BINARY_DOUBLE,
  "COL_70" BINARY_DOUBLE,
  "COL_71" CHAR(30 BYTE),
  "COL_72" VARCHAR(30 BYTE),
  "COL_73" BINARY_INTEGER,
  "COL_74" BINARY_BIGINT,
  "COL_75" BINARY_INTEGER,
  "COL_76" CHAR(100 CHAR),
  "COL_77" TIMESTAMP(6) WITH TIME ZONE,
  "COL_78" NUMBER,
  "COL_79" VARCHAR(30 BYTE),
  "COL_80" CHAR(30 BYTE),
  "COL_81" BLOB,
  "COL_82" CLOB,
  "COL_83" NUMBER,
  "COL_84" BINARY_DOUBLE,
  "COL_85" BINARY_INTEGER,
  "COL_86" CHAR(30 BYTE),
  "COL_87" TIMESTAMP(6) WITH TIME ZONE,
  "COL_88" NUMBER,
  "COL_89" BINARY_BIGINT,
  "COL_90" BLOB,
  "COL_91" BLOB,
  "COL_92" BINARY_DOUBLE,
  "COL_93" BINARY_DOUBLE,
  "COL_94" BINARY_INTEGER,
  "COL_95" CHAR(30 BYTE),
  "COL_96" BINARY_BIGINT,
  "COL_97" BINARY_DOUBLE,
  "COL_98" BINARY_INTEGER,
  "COL_99" CHAR(30 BYTE),
  "COL_100" VARCHAR(30 BYTE),
  "COL_101" BINARY_BIGINT,
  "COL_102" CLOB,
  "COL_103" TIMESTAMP(6) WITH LOCAL TIME ZONE,
  "COL_104" TIMESTAMP(6),
  "COL_105" NUMBER,
  "COL_106" NUMBER,
  "COL_107" NUMBER,
  "COL_108" IMAGE,
  "COL_109" BOOLEAN,
  "COL_110" BINARY_DOUBLE,
  "COL_111" CHAR(30 BYTE),
  "COL_112" VARCHAR(30 BYTE),
  "COL_113" NUMBER,
  "COL_114" BINARY_INTEGER,
  "COL_115" VARCHAR(30 BYTE),
  "COL_116" NUMBER,
  "COL_117" BINARY_BIGINT,
  "COL_118" INTERVAL YEAR(2) TO MONTH,
  "COL_119" BOOLEAN,
  "COL_120" NUMBER,
  "COL_121" BLOB,
  "COL_122" BINARY_DOUBLE,
  "COL_123" BINARY_DOUBLE,
  "COL_124" BINARY_INTEGER,
  "COL_125" BINARY_INTEGER,
  "COL_126" BINARY_INTEGER,
  "COL_127" TIMESTAMP(6),
  "COL_128" BINARY_INTEGER,
  "COL_129" TIMESTAMP(6) WITH TIME ZONE,
  "COL_130" CHAR(30 BYTE),
  "COL_131" BLOB,
  "COL_132" CHAR(30 BYTE),
  "COL_133" BINARY_BIGINT,
  "COL_134" TIMESTAMP(6) WITH TIME ZONE,
  "COL_135" BINARY_INTEGER,
  "COL_136" NUMBER,
  "COL_137" NUMBER,
  "COL_138" INTERVAL YEAR(2) TO MONTH,
  "COL_139" BLOB,
  "COL_140" CHAR(30 BYTE),
  "COL_141" NUMBER,
  "COL_142" BINARY_DOUBLE,
  "COL_143" BINARY_DOUBLE,
  "COL_144" CLOB,
  "COL_145" BOOLEAN,
  "COL_146" BINARY_INTEGER,
  "COL_147" BINARY_BIGINT,
  "COL_148" CHAR(30 BYTE),
  "COL_149" VARCHAR(30 BYTE),
  "COL_150" BLOB,
  "COL_151" BINARY_DOUBLE,
  "COL_152" CHAR(30 BYTE),
  "COL_153" BINARY_DOUBLE,
  "COL_154" CLOB,
  "COL_155" BINARY_BIGINT,
  "COL_156" BINARY_INTEGER,
  "COL_157" NUMBER,
  "COL_158" INTERVAL YEAR(2) TO MONTH,
  "COL_159" TIMESTAMP(6) WITH TIME ZONE,
  "COL_160" BLOB,
  "COL_161" NUMBER,
  "COL_162" BINARY_INTEGER,
  "COL_163" RAW(100),
  "COL_164" NUMBER(6, 2),
  "COL_165" BINARY_INTEGER,
  "COL_166" CLOB,
  "COL_167" BINARY_DOUBLE,
  "COL_168" NUMBER(6, 2),
  "COL_169" NUMBER(6, 2),
  "COL_170" NUMBER(6, 2),
  "COL_171" RAW(100),
  "COL_172" BINARY_INTEGER,
  "COL_173" CLOB,
  "COL_174" VARCHAR(50 BYTE),
  "COL_175" VARCHAR(30 BYTE),
  "COL_176" BINARY_DOUBLE,
  "COL_177" TIMESTAMP(6) WITH TIME ZONE,
  "COL_178" NUMBER(6, 2),
  "COL_179" NUMBER(6, 2),
  "COL_180" VARCHAR(100 CHAR),
  "COL_181" NUMBER(6, 2),
  "COL_182" DATE,
  "COL_183" NUMBER(12, 6),
  "COL_184" NUMBER(6, 2),
  "COL_185" VARCHAR(30 CHAR),
  "COL_186" BINARY_INTEGER,
  "COL_187" NUMBER(6, 2),
  "COL_188" DATE,
  "COL_189" DATE,
  "COL_190" NUMBER(6, 2),
  "COL_191" NUMBER(6, 2),
  "COL_192" VARCHAR(30 BYTE),
  "COL_193" TIMESTAMP(6),
  "COL_194" BINARY_DOUBLE,
  "COL_195" IMAGE,
  "COL_196" NUMBER(6, 2),
  "COL_197" NUMBER(6, 2),
  "COL_198" NUMBER(6, 2),
  "COL_199" CLOB,
  "COL_200" VARCHAR(55 CHAR),
  "COL_201" BINARY_DOUBLE,
  "COL_202" INTERVAL DAY(2) TO SECOND(6),
  "COL_203" NUMBER(6, 2),
  "COL_204" VARCHAR(30 BYTE),
  "COL_205" NUMBER(6, 2),
  "COL_206" NUMBER(6, 2),
  "COL_207" VARCHAR(30 BYTE),
  "COL_208" RAW(200),
  "COL_209" NUMBER(6, 2),
  "COL_210" NUMBER(6, 2),
  "COL_211" BINARY_DOUBLE,
  "COL_212" BINARY_DOUBLE,
  "COL_213" NUMBER(6, 2),
  "COL_214" VARCHAR(30 BYTE),
  "COL_215" CLOB,
  "COL_216" BINARY_INTEGER,
  "COL_217" NUMBER(6, 2),
  "COL_218" NUMBER(6, 2),
  "COL_219" CLOB,
  "COL_220" VARCHAR(30 BYTE),
  "COL_221" BINARY_INTEGER,
  "COL_222" NUMBER(6, 2),
  "COL_223" TIMESTAMP(6),
  "COL_224" VARCHAR(30 BYTE),
  "COL_225" DATE,
  "COL_226" NUMBER(16, 2),
  "COL_227" VARCHAR(100 BYTE),
  "COL_228" DATE,
  "COL_229" CLOB,
  "COL_230" NUMBER(12, 6),
  "COL_231" DATE,
  "COL_232" NUMBER(6, 2),
  "COL_233" BINARY_INTEGER,
  "COL_234" DATE,
  "COL_235" VARCHAR(200 CHAR),
  "COL_236" NUMBER(6, 2),
  "COL_237" CLOB,
  "COL_238" VARCHAR(300 BYTE),
  "COL_239" NUMBER(6, 2),
  "COL_240" CLOB,
  "COL_241" VARCHAR(30 BYTE),
  "COL_242" NUMBER(6, 2),
  "COL_243" NUMBER(6, 2),
  "COL_244" BINARY_DOUBLE,
  "COL_245" VARCHAR(60 BYTE),
  "COL_246" BINARY_INTEGER,
  "COL_247" VARBINARY(200),
  "COL_248" VARCHAR(30 BYTE),
  "COL_249" BINARY(200),
  "COL_250" NUMBER(6, 2),
  "COL_251" RAW(100),
  "COL_252" BINARY_DOUBLE,
  "COL_253" NUMBER(6, 2),
  "COL_254" BINARY_DOUBLE,
  "COL_255" DATE,
  "COL_256" NUMBER(6, 2),
  "COL_257" BINARY_INTEGER,
  "COL_258" NUMBER(6, 2),
  "COL_259" BINARY(100),
  "COL_260" RAW(100),
  "COL_261" VARCHAR(60 BYTE),
  "COL_262" VARCHAR(30 BYTE),
  "COL_263" NUMBER(6, 2),
  "COL_264" CLOB,
  "COL_265" NUMBER(6, 2),
  "COL_266" CLOB,
  "COL_267" VARCHAR(30 BYTE),
  "COL_268" NUMBER(6, 2),
  "COL_269" NUMBER(6, 2),
  "COL_270" INTERVAL YEAR(2) TO MONTH,
  "COL_271" VARCHAR(60 BYTE),
  "COL_272" NUMBER(6, 2),
  "COL_273" NUMBER(6, 2),
  "COL_274" DATE,
  "COL_275" BINARY_DOUBLE
);

CREATE TABLE "STUDENT"
(
  "ID" BINARY_INTEGER NOT NULL,
  "NAME" VARCHAR(50 BYTE) NOT NULL,
  "SEX" VARCHAR(50 BYTE),
  "BIRTH" DATE,
  "DEPARTMENT" VARCHAR(50 BYTE),
  "ADDRESS" VARCHAR(50 BYTE)
);
INSERT INTO "STUDENT" ("ID","NAME","SEX","BIRTH","DEPARTMENT","ADDRESS") values (901,'张老大','男','1985-01-01 00:00:00','计算机系','北京市海淀区');
INSERT INTO "STUDENT" ("ID","NAME","SEX","BIRTH","DEPARTMENT","ADDRESS") values (902,'张老二','男','1986-01-01 00:00:00','中文系','北京市昌平区');
INSERT INTO "STUDENT" ("ID","NAME","SEX","BIRTH","DEPARTMENT","ADDRESS") values (903,'张三','女','1990-01-01 00:00:00','中文系','湖南省永州市');
INSERT INTO "STUDENT" ("ID","NAME","SEX","BIRTH","DEPARTMENT","ADDRESS") values (904,'李四','男','1990-01-01 00:00:00','英语系','辽宁省阜新市');
INSERT INTO "STUDENT" ("ID","NAME","SEX","BIRTH","DEPARTMENT","ADDRESS") values (905,'王五','女','1991-01-01 00:00:00','英语系','福建省厦门市');
INSERT INTO "STUDENT" ("ID","NAME","SEX","BIRTH","DEPARTMENT","ADDRESS") values (906,'王六','男','1988-01-01 00:00:00','计算机系','湖南省衡阳市');
COMMIT;
ALTER TABLE "STUDENT" ADD PRIMARY KEY("ID");

CREATE TABLE "SCORE"
(
  "ID" BINARY_INTEGER NOT NULL,
  "STU_ID" BINARY_INTEGER NOT NULL,
  "C_NAME" VARCHAR(50 BYTE),
  "GRADE" BINARY_INTEGER
);
INSERT INTO "SCORE" ("ID","STU_ID","C_NAME","GRADE") values (1,901,'计算机',98);
INSERT INTO "SCORE" ("ID","STU_ID","C_NAME","GRADE") values (2,901,'英语',80);
INSERT INTO "SCORE" ("ID","STU_ID","C_NAME","GRADE") values (3,902,'计算机',65);
INSERT INTO "SCORE" ("ID","STU_ID","C_NAME","GRADE") values (4,902,'中文',88);
INSERT INTO "SCORE" ("ID","STU_ID","C_NAME","GRADE") values (5,903,'中文',95);
INSERT INTO "SCORE" ("ID","STU_ID","C_NAME","GRADE") values (6,904,'计算机',70);
INSERT INTO "SCORE" ("ID","STU_ID","C_NAME","GRADE") values (7,904,'英语',92);
INSERT INTO "SCORE" ("ID","STU_ID","C_NAME","GRADE") values (8,905,'英语',94);
INSERT INTO "SCORE" ("ID","STU_ID","C_NAME","GRADE") values (9,906,'计算机',90);
INSERT INTO "SCORE" ("ID","STU_ID","C_NAME","GRADE") values (10,906,'英语',85);
COMMIT;
ALTER TABLE "SCORE" ADD PRIMARY KEY("ID");
ALTER TABLE "SCORE" MODIFY "ID" AUTO_INCREMENT;
ALTER TABLE "SCORE" AUTO_INCREMENT = 101;

CREATE TABLE "EMPLOYEES"
(
  "EMP_NO" BINARY_INTEGER NOT NULL,
  "BIRTH_DATE" DATE NOT NULL,
  "FIRST_NAME" VARCHAR(50 BYTE) NOT NULL,
  "LAST_NAME" VARCHAR(50 BYTE) NOT NULL,
  "GENDER" CHAR(1 BYTE) NOT NULL,
  "HIRE_DATE" DATE NOT NULL
);
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10001,'1953-09-02 00:00:00','Georgi','Facello','M','1986-06-26 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10002,'1964-06-02 00:00:00','Bezalel','Simmel','F','1985-11-21 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10003,'1959-12-03 00:00:00','Parto','Bamford','M','1986-08-28 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10004,'1954-05-01 00:00:00','Chirstian','Koblick','M','1986-12-01 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10005,'1955-01-21 00:00:00','Kyoichi','Maliniak','M','1989-09-12 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10006,'1953-04-20 00:00:00','Anneke','Preusig','F','1989-06-02 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10007,'1957-05-23 00:00:00','Tzvetan','Zielinski','F','1989-02-10 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10008,'1958-02-19 00:00:00','Saniya','Kalloufi','M','1994-09-15 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10009,'1952-04-19 00:00:00','Sumant','Peac','F','1985-02-18 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10010,'1963-06-01 00:00:00','Duangkaew','Piveteau','F','1989-08-24 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10011,'1953-11-07 00:00:00','Mary','Sluis','F','1990-01-22 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10012,'1960-10-04 00:00:00','Patricio','Bridgland','M','1992-12-18 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10013,'1963-06-07 00:00:00','Eberhardt','Terkki','M','1985-10-20 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10014,'1956-02-12 00:00:00','Berni','Genin','M','1987-03-11 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10015,'1959-08-19 00:00:00','Guoxiang','Nooteboom','M','1987-07-02 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10016,'1961-05-02 00:00:00','Kazuhito','Cappelletti','M','1995-01-27 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10017,'1958-07-06 00:00:00','Cristinel','Bouloucos','F','1993-08-03 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10018,'1954-06-19 00:00:00','Kazuhide','Peha','F','1987-04-03 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10019,'1953-01-23 00:00:00','Lillian','Haddadi','M','1999-04-30 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10020,'1952-12-24 00:00:00','Mayuko','Warwick','M','1991-01-26 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10021,'1960-02-20 00:00:00','Ramzi','Erde','M','1988-02-10 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10022,'1952-07-08 00:00:00','Shahaf','Famili','M','1995-08-22 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10023,'1953-09-29 00:00:00','Bojan','Montemayor','F','1989-12-17 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10024,'1958-09-05 00:00:00','Suzette','Pettey','F','1997-05-19 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10025,'1958-10-31 00:00:00','Prasadram','Heyers','M','1987-08-17 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10026,'1953-04-03 00:00:00','Yongqiao','Berztiss','M','1995-03-20 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10027,'1962-07-10 00:00:00','Divier','Reistad','F','1989-07-07 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10028,'1963-11-26 00:00:00','Domenick','Tempesti','M','1991-10-22 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10029,'1956-12-13 00:00:00','Otmar','Herbst','M','1985-11-20 00:00:00');
INSERT INTO "EMPLOYEES" ("EMP_NO","BIRTH_DATE","FIRST_NAME","LAST_NAME","GENDER","HIRE_DATE") values (10030,'1958-07-14 00:00:00','Elvis','Demeyer','M','1994-02-17 00:00:00');
COMMIT;
ALTER TABLE "EMPLOYEES" ADD PRIMARY KEY("EMP_NO");

CREATE TABLE "DEPARTMENTS"
(
  "DEPT_NO" CHAR(30 BYTE) NOT NULL,
  "DEPT_NAME" VARCHAR(50 BYTE) NOT NULL
);
INSERT INTO "DEPARTMENTS" ("DEPT_NO","DEPT_NAME") values ('d001                          ','市场部');
INSERT INTO "DEPARTMENTS" ("DEPT_NO","DEPT_NAME") values ('d002                          ','财务部');
INSERT INTO "DEPARTMENTS" ("DEPT_NO","DEPT_NAME") values ('d003                          ','人事部');
INSERT INTO "DEPARTMENTS" ("DEPT_NO","DEPT_NAME") values ('d004                          ','生产部');
INSERT INTO "DEPARTMENTS" ("DEPT_NO","DEPT_NAME") values ('d005                          ','研发部');
INSERT INTO "DEPARTMENTS" ("DEPT_NO","DEPT_NAME") values ('d006                          ','质量部');
INSERT INTO "DEPARTMENTS" ("DEPT_NO","DEPT_NAME") values ('d007                          ','销售部');
INSERT INTO "DEPARTMENTS" ("DEPT_NO","DEPT_NAME") values ('d008                          ','销售服务部');
COMMIT;
ALTER TABLE "DEPARTMENTS" ADD PRIMARY KEY("DEPT_NO");
ALTER TABLE "DEPARTMENTS" ADD UNIQUE("DEPT_NAME");

CREATE TABLE "DEPT_MANAGER"
(
  "EMP_NO" BINARY_INTEGER NOT NULL,
  "DEPT_NO" CHAR(30 BYTE) NOT NULL,
  "FROM_DATE" DATE NOT NULL,
  "TO_DATE" DATE NOT NULL
);
INSERT INTO "DEPT_MANAGER" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10017,'d001                          ','1985-01-01 00:00:00','1991-10-01 00:00:00');
INSERT INTO "DEPT_MANAGER" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10020,'d002                          ','1991-10-01 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_MANAGER" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10013,'d003                          ','1985-01-01 00:00:00','1989-12-17 00:00:00');
INSERT INTO "DEPT_MANAGER" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10018,'d004                          ','1989-12-17 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_MANAGER" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10018,'d005                          ','1985-01-01 00:00:00','1992-03-21 00:00:00');
INSERT INTO "DEPT_MANAGER" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10029,'d006                          ','1992-03-21 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_MANAGER" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10016,'d007                          ','1985-01-01 00:00:00','1988-09-09 00:00:00');
INSERT INTO "DEPT_MANAGER" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10007,'d008                          ','1988-09-09 00:00:00','1992-08-02 00:00:00');
COMMIT;
ALTER TABLE "DEPT_MANAGER" ADD PRIMARY KEY("EMP_NO", "DEPT_NO");

CREATE TABLE "DEPT_EMP"
(
  "EMP_NO" BINARY_INTEGER NOT NULL,
  "DEPT_NO" CHAR(30 BYTE) NOT NULL,
  "FROM_DATE" DATE NOT NULL,
  "TO_DATE" DATE NOT NULL
);
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10001,'d005                          ','1986-06-26 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10002,'d007                          ','1996-08-03 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10003,'d004                          ','1995-12-03 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10004,'d004                          ','1986-12-01 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10005,'d003                          ','1989-09-12 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10006,'d005                          ','1990-08-05 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10007,'d008                          ','1989-02-10 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10008,'d005                          ','1998-03-11 00:00:00','2000-07-31 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10009,'d006                          ','1985-02-18 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10010,'d004                          ','1996-11-24 00:00:00','2000-06-26 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10010,'d006                          ','2000-06-26 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10011,'d007                          ','1990-01-22 00:00:00','1996-11-09 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10012,'d005                          ','1992-12-18 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10013,'d003                          ','1985-10-20 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10014,'d005                          ','1993-12-29 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10015,'d008                          ','1992-09-19 00:00:00','1993-08-22 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10016,'d007                          ','1998-02-11 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10017,'d001                          ','1993-08-03 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10018,'d004                          ','1992-07-29 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10018,'d005                          ','1987-04-03 00:00:00','1992-07-29 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10019,'d008                          ','1999-04-30 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10020,'d002                          ','1997-12-30 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10021,'d005                          ','1988-02-10 00:00:00','2002-07-15 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10022,'d005                          ','1999-09-03 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10023,'d005                          ','1999-09-27 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10024,'d004                          ','1998-06-14 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10025,'d005                          ','1987-08-17 00:00:00','1997-10-15 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10026,'d004                          ','1995-03-20 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10027,'d005                          ','1995-04-02 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10028,'d005                          ','1991-10-22 00:00:00','1998-04-06 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10029,'d004                          ','1991-09-18 00:00:00','1999-07-08 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10029,'d006                          ','1999-07-08 00:00:00','9999-01-01 00:00:00');
INSERT INTO "DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10030,'d004                          ','1994-02-17 00:00:00','9999-01-01 00:00:00');
COMMIT;
ALTER TABLE "DEPT_EMP" ADD PRIMARY KEY("EMP_NO", "DEPT_NO");

CREATE TABLE "SALARIES"
(
  "EMP_NO" BINARY_INTEGER NOT NULL,
  "SALARY" BINARY_INTEGER NOT NULL,
  "FROM_DATE" DATE NOT NULL,
  "TO_DATE" DATE NOT NULL
);
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10001,5000,'1986-06-26 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10002,5100,'1996-08-03 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10003,5200,'1995-12-03 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10004,5300,'1986-12-01 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10005,5400,'1989-09-12 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10006,5500,'1990-08-05 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10007,5600,'1989-02-10 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10008,5700,'1998-03-11 00:00:00','2000-07-31 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10009,5800,'1985-02-18 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10010,5900,'1996-11-24 00:00:00','2000-06-26 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10010,6000,'2000-06-26 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10011,6100,'1990-01-22 00:00:00','1996-11-09 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10012,5000,'1992-12-18 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10013,5100,'1985-10-20 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10014,5200,'1993-12-29 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10015,5300,'1992-09-19 00:00:00','1993-08-22 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10016,5400,'1998-02-11 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10017,5500,'1993-08-03 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10018,5600,'1992-07-29 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10018,5700,'1987-04-03 00:00:00','1992-07-29 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10019,5800,'1999-04-30 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10020,5900,'1997-12-30 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10021,6000,'1988-02-10 00:00:00','2002-07-15 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10022,6100,'1999-09-03 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10023,5000,'1999-09-27 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10024,5100,'1998-06-14 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10025,5200,'1987-08-17 00:00:00','1997-10-15 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10026,5300,'1995-03-20 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10027,5400,'1995-04-02 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10028,5500,'1991-10-22 00:00:00','1998-04-06 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10029,5600,'1991-09-18 00:00:00','1999-07-08 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10029,5700,'1999-07-08 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES" ("EMP_NO","SALARY","FROM_DATE","TO_DATE") values (10030,5800,'1994-02-17 00:00:00','9999-01-01 00:00:00');
COMMIT;
ALTER TABLE "SALARIES" ADD PRIMARY KEY("EMP_NO", "FROM_DATE");

CREATE TABLE "TEST"
(
  "ID" BINARY_INTEGER,
  "NAME" VARCHAR(30 BYTE)
);
INSERT INTO "TEST" ("ID","NAME") values (1,'dgd');
INSERT INTO "TEST" ("ID","NAME") values (2,'ssn');
INSERT INTO "TEST" ("ID","NAME") values (3,'ddd');
INSERT INTO "TEST" ("ID","NAME") values (11,'aaaa');
INSERT INTO "TEST" ("ID","NAME") values (4,'dgd');
COMMIT;
CREATE TABLE "MY_EMPLOYEES"
(
  "ID" BINARY_INTEGER,
  "DD" CLOB,
  "FLAG" CHAR(1 BYTE),
  "BB" BOOLEAN,
  "DBL" BINARY_DOUBLE
);
INSERT INTO "MY_EMPLOYEES" ("ID","DD","FLAG","BB","DBL") values (0,'dddddddddddddddddddddddd','m',TRUE,301415902);
INSERT INTO "MY_EMPLOYEES" ("ID","DD","FLAG","BB","DBL") values (111,'ssssssssssssssssssssss','f',FALSE,0.1415902);
COMMIT;
ALTER TABLE "DEPT_MANAGER" ADD FOREIGN KEY("EMP_NO") REFERENCES "EMPLOYEES"("EMP_NO");
ALTER TABLE "DEPT_MANAGER" ADD FOREIGN KEY("DEPT_NO") REFERENCES "DEPARTMENTS"("DEPT_NO");
ALTER TABLE "DEPT_EMP" ADD FOREIGN KEY("DEPT_NO") REFERENCES "DEPARTMENTS"("DEPT_NO");
ALTER TABLE "DEPT_EMP" ADD FOREIGN KEY("EMP_NO") REFERENCES "EMPLOYEES"("EMP_NO");
ALTER TABLE "SALARIES" ADD FOREIGN KEY("EMP_NO") REFERENCES "EMPLOYEES"("EMP_NO");
select distinct 
  subq_0.c16 as c0, 
    STDDEV_SAMP(
      cast(EXP(
        cast((select max(COL_8) from FVT_OBJ_DEFINE_TABLE_FRE1)
           as BINARY_DOUBLE)) as BINARY_DOUBLE)) over (partition by subq_0.c1,subq_0.c7 order by subq_0.c0) as c1, 
    sum(
      cast(subq_0.c4 as BINARY_INTEGER)) over (partition by subq_0.c14 order by subq_0.c3) as c2
from 
  (select distinct 
          STDDEV(
            cast(ref_0.EMP_NO as BINARY_INTEGER)) over (partition by ref_0.BIRTH_DATE order by ref_0.GENDER,ref_0.BIRTH_DATE,ref_0.LAST_NAME,ref_0.EMP_NO) as c0, 
        ref_0.LAST_NAME as c1, 
        ref_0.GENDER as c2, 
        ref_0.HIRE_DATE as c3, 
        ref_0.EMP_NO as c4, 
          STDDEV_POP(
            cast(ref_0.EMP_NO as BINARY_INTEGER)) over (partition by ref_0.GENDER order by ref_0.HIRE_DATE,ref_0.EMP_NO) as c5, 
          sum(
            cast(ref_0.EMP_NO as BINARY_INTEGER)) over (partition by ref_0.LAST_NAME order by ref_0.LAST_NAME,ref_0.BIRTH_DATE,ref_0.HIRE_DATE) as c6, 
        ref_0.EMP_NO as c7, 
        ref_0.HIRE_DATE as c8, 
        (select FIRST_NAME from EMPLOYEES limit 1 offset 3)
           as c9, 
        ref_0.EMP_NO as c10, 
        ref_0.FIRST_NAME as c11, 
        ref_0.HIRE_DATE as c12, 
        ref_0.FIRST_NAME as c13, 
        (select ID from TEST limit 1 offset 1)
           as c14, 
        34 as c15, 
        ref_0.BIRTH_DATE as c16, 
        MIN(cast(ref_0.EMP_NO as BINARY_INTEGER)) over (partition by ref_0.GENDER,ref_0.HIRE_DATE,ref_0.LAST_NAME order by ref_0.EMP_NO,ref_0.FIRST_NAME,ref_0.BIRTH_DATE,ref_0.HIRE_DATE) as c17,
		case when (EXISTS (select distinct 
                  ref_1.COL_85 as c0, 
                  ref_0.BIRTH_DATE as c1, 
                  ref_1.COL_226 as c2, 
                  50 as c3, 
                  ref_1.COL_22 as c4
                from 
                  FVT_OBJ_DEFINE_TABLE_FRE1 as ref_1
                where EXISTS (
                  select distinct 
                      ref_0.HIRE_DATE as c0, 
                      ref_2.EMP_NO as c1, 
                      ref_0.EMP_NO as c2, 
                      ref_0.EMP_NO as c3, 
                      ref_0.BIRTH_DATE as c4, 
                      ref_0.BIRTH_DATE as c5, 
                      ref_0.HIRE_DATE as c6, 
                      ref_0.EMP_NO as c7, 
                      ref_0.HIRE_DATE as c8, 
                      ref_0.EMP_NO as c9, 
                      ref_0.EMP_NO as c10, 
                      ref_0.LAST_NAME as c11, 
                      ref_0.FIRST_NAME as c12, 
                      ref_2.EMP_NO as c13
                    from 
                      SALARIES as ref_2
                    where (ref_2.TO_DATE is NULL) 
                      and (((ref_2.SALARY is NULL) 
                          or ((ref_2.EMP_NO is not NULL) 
                            or (true))) 
                        and (true))
                    limit 105)
                limit 124)) 
            and (ref_0.HIRE_DATE is not NULL) then ref_0.FIRST_NAME else ref_0.FIRST_NAME end
           as c18, 
        ref_0.HIRE_DATE as c19
      from 
        EMPLOYEES as ref_0
      where ref_0.EMP_NO is not NULL) as subq_0
where subq_0.c11 is NULL
limit 106;
select distinct 
  ref_0.DEPT_NO as c0, 
  
    count(
      cast(ref_0.EMP_NO as BINARY_INTEGER)) over (partition by ref_1.HIRE_DATE,ref_0.EMP_NO order by ref_1.BIRTH_DATE) as c1, 
  
    STDDEV(
      cast(cast(nullif((select DBL from MY_EMPLOYEES limit 1 offset 1)
          ,
        (select COL_8 from FVT_OBJ_DEFINE_TABLE_FRE1 limit 1 offset 3)
          ) as BINARY_DOUBLE) as BINARY_DOUBLE)) over (partition by ref_0.EMP_NO,ref_1.LAST_NAME order by ref_0.DEPT_NO,ref_1.GENDER) as c2, 
  
    STDDEV_SAMP(
      cast((select COL_8 from FVT_OBJ_DEFINE_TABLE_FRE1 limit 1 offset 6)
         as BINARY_DOUBLE)) over (partition by ref_1.BIRTH_DATE order by ref_0.TO_DATE) as c3, 
  
    STDDEV(
      cast(ref_0.EMP_NO as BINARY_INTEGER)) over (partition by ref_0.DEPT_NO order by ref_1.GENDER,ref_0.FROM_DATE) as c4
from 
  DEPT_MANAGER as ref_0
    left join EMPLOYEES as ref_1
    on (ref_1.FIRST_NAME is not NULL)
where ((ref_0.EMP_NO is not NULL) 
    or (cast(nullif(case when ((false) 
              or (true)) 
            or (ref_0.TO_DATE is NULL) then case when ref_0.EMP_NO is NULL then ref_1.EMP_NO else ref_1.EMP_NO end
             else case when ref_0.EMP_NO is NULL then ref_1.EMP_NO else ref_1.EMP_NO end
             end
          ,
        ref_0.EMP_NO) as BINARY_INTEGER) is NULL)) 
  or ((ref_0.EMP_NO is not NULL) 
    or (EXISTS (
      select distinct 
          ref_0.FROM_DATE as c0, 
          ref_1.BIRTH_DATE as c1, 
          ref_0.EMP_NO as c2, 
          ref_1.BIRTH_DATE as c3, 
          ref_0.TO_DATE as c4
        from 
          DEPT_EMP as ref_2
        where ref_1.HIRE_DATE is NULL)));
select distinct 
  
    count(
      cast(subq_1.c0 as BINARY_DOUBLE)) over (partition by subq_1.c0 order by subq_1.c2) as c0, 
  subq_1.c2 as c1, 
  
    STDDEV_POP(
      cast(subq_1.c0 as BINARY_DOUBLE)) over (partition by subq_1.c0 order by subq_1.c0,subq_1.c2) as c2, 
  
    sum(
      cast((select STDDEV_POP(COL_8) from FVT_OBJ_DEFINE_TABLE_FRE1)
         as BINARY_DOUBLE)) over (partition by subq_1.c2 order by subq_1.c2) as c3
from 
  (select distinct 
        
          avg(
            cast(ref_0.COL_12 as BINARY_DOUBLE)) over (partition by ref_0.COL_107 order by ref_1.BIRTH_DATE) as c0, 
        ref_0.COL_159 as c1, 
        cast(coalesce(case when EXISTS (
              select distinct 
                  41 as c0
                from 
                  EMPLOYEES as ref_2,
                  (select distinct 
                        (select FROM_DATE from DEPT_EMP limit 1 offset 3)
                           as c0, 
                        (select sum(EMP_NO) from DEPT_EMP)
                           as c1, 
                        ref_0.COL_145 as c2, 
                        ref_1.BIRTH_DATE as c3, 
                        ref_3.HIRE_DATE as c4, 
                        (select ID from TEST limit 1 offset 2)
                           as c5, 
                        ref_3.HIRE_DATE as c6, 
                        ref_1.FIRST_NAME as c7, 
                        ref_1.BIRTH_DATE as c8, 
                        ref_1.BIRTH_DATE as c9, 
                        ref_3.LAST_NAME as c10, 
                        ref_3.EMP_NO as c11, 
                        (select FROM_DATE from DEPT_MANAGER limit 1 offset 4)
                           as c12, 
                        ref_0.COL_136 as c13
                      from 
                        EMPLOYEES as ref_3
                      where true
                      limit 99) as subq_0
                where (true) 
                  and (false)) then ref_0.COL_148 else ref_0.COL_148 end
            ,
          ref_0.COL_111) as CHAR) as c2
      from 
        FVT_OBJ_DEFINE_TABLE_FRE1 as ref_0
          right join EMPLOYEES as ref_1
          on (22 is not NULL)
      where (ref_1.LAST_NAME is NULL) 
        or ((((true) 
              and (ref_0.COL_142 is NULL)) 
            or ((ref_0.COL_204 is NULL) 
              and ((ref_1.GENDER is not NULL) 
                and ((ref_1.GENDER is NULL) 
                  or (true))))) 
          or ((false) 
            or ((true) 
              and (false))))
      limit 43) as subq_1
where subq_1.c0 is NULL
limit 58;
select distinct 
  
    STDDEV_SAMP(
      cast((select avg(ID) from STUDENT)
         as BINARY_INTEGER)) over (partition by ref_0.DEPT_NO,ref_0.EMP_NO order by ref_0.TO_DATE) as c0, 
  
    STDDEV_POP(
      cast((select ID from SCORE limit 1 offset 6)
         as BINARY_INTEGER)) over (partition by ref_0.TO_DATE order by ref_0.DEPT_NO) as c1, 
  
    STDDEV(
      cast(ref_0.EMP_NO as BINARY_INTEGER)) over (partition by ref_0.TO_DATE,ref_0.FROM_DATE order by ref_0.TO_DATE,ref_0.EMP_NO) as c2, 
  
    avg(
      cast(case when true then (select DBL from MY_EMPLOYEES limit 1 offset 2)
           else (select DBL from MY_EMPLOYEES limit 1 offset 2)
           end
         as BINARY_DOUBLE)) over (partition by ref_0.TO_DATE order by ref_0.DEPT_NO,ref_0.DEPT_NO) as c3
from 
  DEPT_EMP as ref_0
where ref_0.TO_DATE is not NULL
limit 181;
select  
    MIN(
      cast((select max(DBL) from MY_EMPLOYEES)
         as BINARY_DOUBLE)) over (partition by subq_0.c4 order by subq_0.c1) as c0, 
    max(
      cast(subq_0.c1 as BINARY_INTEGER)) over (partition by ref_4.NAME,ref_4.ID order by subq_0.c6) as c1, 
    sum(
      cast(ref_4.ID as BINARY_INTEGER)) over (partition by subq_0.c6,ref_4.ID,ref_4.ID order by ref_4.ID) as c2, 
  subq_0.c2 as c3, 
    max(
      cast((select sum(DBL) from MY_EMPLOYEES)
         as BINARY_DOUBLE)) over (partition by subq_0.c6 order by ref_4.NAME) as c4, 
    STDDEV(
      cast(SIN(
        cast((select DBL from MY_EMPLOYEES limit 1 offset 4)
           as BINARY_DOUBLE)) as BINARY_DOUBLE)) over (partition by ref_4.NAME order by ref_4.ID) as c5
from 
  (select  
          ref_0.SEX as c0, 
          ref_1.SALARY as c1, 
          (select SALARY from SALARIES limit 1 offset 5)
             as c2, 
          ref_0.BIRTH as c3, 
            sum(
              cast(ref_1.SALARY as BINARY_INTEGER)) over (partition by ref_1.EMP_NO order by ref_1.TO_DATE) as c4, 
          ref_1.SALARY as c5, 
          ref_1.TO_DATE as c6, 
          ref_1.SALARY as c7
        from 
          STUDENT as ref_0
            inner join SALARIES as ref_1
            on (EXISTS (
                select  
                    8 as c0, 
                    ref_0.ADDRESS as c1, 
                    ref_1.FROM_DATE as c2, 
                    ref_0.SEX as c3
                  from 
                    SCORE as ref_2
                  where EXISTS (
                    select  
                        ref_3.DEPT_NAME as c0, 
                        ref_0.ADDRESS as c1, 
                        ref_3.DEPT_NAME as c2, 
                        ref_1.FROM_DATE as c3, 
                        ref_1.FROM_DATE as c4, 
                        ref_3.DEPT_NO as c5, 
                        ref_0.SEX as c6, 
                        ref_3.DEPT_NO as c7, 
                        (select avg(COL_8) from FVT_OBJ_DEFINE_TABLE_FRE1)
                           as c8, 
                        ref_1.TO_DATE as c9
                      from 
                        DEPARTMENTS as ref_3
                      where ref_3.DEPT_NAME is not NULL)
                  limit 39))
        where (ref_0.BIRTH is not NULL) 
          and ((false) 
            or (true))) as subq_0
    inner join TEST as ref_4
    on (trim(
          cast(version() as VARCHAR(50)),
          cast(case when (73 is NULL) 
              and ((ref_4.NAME is NULL) 
                or (((ref_4.NAME is NULL) 
                    and ((((select SALARY from SALARIES limit 1 offset 2)
                             is not NULL) 
                        or ((((true) 
                              and ((EXISTS (
                                  select  
                                      ref_4.NAME as c0, 
                                      ref_4.ID as c1, 
                                      ref_4.NAME as c2, 
                                      ref_4.ID as c3, 
                                      ref_5.GENDER as c4, 
                                      63 as c5, 
                                      subq_0.c7 as c6
                                    from 
                                      EMPLOYEES as ref_5
                                    where ((subq_0.c6 is NULL) 
                                        or ((subq_0.c6 is not NULL) 
                                          or (false))) 
                                      or (ref_4.ID is NULL)
                                    limit 83)) 
                                or (EXISTS (
                                  select  
                                      (select C_NAME from SCORE limit 1 offset 2)
                                         as c0
                                    from 
                                      DEPT_MANAGER as ref_6
                                    where EXISTS (
                                      select  
                                          ref_4.ID as c0, 
                                          ref_4.NAME as c1, 
                                          (select ADDRESS from STUDENT limit 1 offset 98)
                                             as c2, 
                                          (select DEPT_NO from DEPARTMENTS limit 1 offset 2)
                                             as c3
                                        from 
                                          EMPLOYEES as ref_7
                                        where true
                                        limit 126)
                                    limit 26)))) 
                            and (subq_0.c5 is not NULL)) 
                          or (EXISTS (
                            select  
                                ref_4.NAME as c0, 
                                ref_4.ID as c1, 
                                ref_8.NAME as c2, 
                                ref_4.NAME as c3, 
                                ref_8.NAME as c4
                              from 
                                TEST as ref_8
                              where (true) 
                                or (EXISTS (
                                  select  
                                      ref_8.ID as c0, 
                                      ref_4.NAME as c1, 
                                      24 as c2, 
                                      subq_0.c5 as c3, 
                                      ref_4.ID as c4, 
                                      ref_9.EMP_NO as c5
                                    from 
                                      EMPLOYEES as ref_9
                                    where true
                                    limit 68)))))) 
                      and (subq_0.c4 is NULL))) 
                  and ((false) 
                    or (ref_4.NAME is not NULL)))) then ref_4.NAME else ref_4.NAME end
             as VARCHAR(50))) is NULL)
where EXISTS (
  select  
      
        sum(
          cast(subq_0.c1 as BINARY_INTEGER)) over (partition by ref_10.NAME,ref_4.ID order by subq_0.c6) as c0, 
      case when false then ref_10.ID else ref_10.ID end
         as c1
    from 
      TEST as ref_10
    where false);

drop table if exists winsort_parent_ref;
create table winsort_parent_ref
(
  col_1 int primary key,
  col_2 int,
  col_3 varchar(20)
);

insert into winsort_parent_ref values(1, 20, 'text1');
insert into winsort_parent_ref values(2, 30, 'text2');
insert into winsort_parent_ref values(3, 40, 'text3');
insert into winsort_parent_ref values(4, 50, 'text4');

select
  subq_1.c3 as c0
from 
(
 select  
    subq_0.c1 as c1, 
    case when 
        EXISTS (
            select 
                ref_0.col_3 as c1, 
                subq_0.c0 as c2
            from 
                winsort_parent_ref as ref_3
            where EXISTS (select subq_0.c1 as c2 from winsort_parent_ref as ref_4)
        ) 
    then ref_0.col_2 else ref_0.col_2 end as c2, 
    min(cast(ref_0.col_2 as BINARY_INTEGER)) over (partition by subq_0.c0 order by ref_0.col_3) as c3
 from
      (winsort_parent_ref as ref_0) 
      inner join 
      (winsort_parent_ref as ref_1)
      inner join 
      (
       (select  
            ref_2.col_3 as c0,
            ref_2.col_3 as c1
        from 
            winsort_parent_ref as ref_2
        ) as subq_0
      )
) as subq_1
where EXISTS (
        select subq_1.c1 as c6
        from winsort_parent_ref as ref_5
        where subq_1.c2 is NULL
        );

select
  subq_1.c3 as c0
from 
(
 select  
    subq_0.c1 as c1, 
    case when 
        EXISTS (
            select 
                ref_0.col_3 as c1, 
                subq_0.rowid as c2
            from 
                winsort_parent_ref as ref_3
            where EXISTS (select subq_0.rowid as c2, ref_0.rowid from winsort_parent_ref as ref_4)
        ) 
    then ref_0.col_2 else ref_0.col_2 end as c2, 
    min(cast(ref_0.col_2 as BINARY_INTEGER)) over (partition by subq_0.c0 order by ref_0.col_3) as c3
 from
      (winsort_parent_ref as ref_0) 
      inner join 
      (winsort_parent_ref as ref_1)
      inner join 
      (
       (select  
            ref_2.col_3 as c0,
            ref_2.col_3 as c1
        from 
            winsort_parent_ref as ref_2
        ) as subq_0
      )
) as subq_1
where (EXISTS (
        select subq_1.c1 as c6
        from winsort_parent_ref as ref_5
        where subq_1.c2 is NULL
        )
      );

drop table winsort_parent_ref;
--20200723
DROP TABLE IF EXISTS "STATES" CASCADE CONSTRAINTS;
CREATE TABLE "STATES"
(
  "STATE_ID" CHAR(2 BYTE) NOT NULL,
  "STATE_NAME" VARCHAR(40 BYTE),
  "AREA_ID" NUMBER
)
TABLESPACE "USERS"
INITRANS 2
MAXTRANS 255
PCTFREE 8;
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('AR','Argentina',2);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('AU','Australia',3);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('BE','Belgium',1);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('BR','Brazil',2);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('CA','Canada',2);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('CH','Switzerland',1);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('CN','China',3);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('DE','Germany',1);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('DK','Denmark',1);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('EG','Egypt',4);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('FR','France',1);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('HK','HongKong',3);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('IL','Israel',4);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('IN','India',3);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('IT','Italy',1);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('JP','Japan',3);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('KW','Kuwait',4);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('MX','Mexico',2);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('NG','Nigeria',4);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('NL','Netherlands',1);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('SG','Singapore',3);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('UK','United Kingdom',1);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('US','United States of America',2);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('ZM','Zambia',4);
INSERT INTO "STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('ZW','Zimbabwe',4);
COMMIT;
ALTER TABLE "STATES" ADD CONSTRAINT "STATE_C_ID_PK" PRIMARY KEY("STATE_ID");

DROP TABLE IF EXISTS "SECTIONS" CASCADE CONSTRAINTS;
CREATE TABLE "SECTIONS"
(
  "SECTION_ID" NUMBER(4) NOT NULL,
  "SECTION_NAME" VARCHAR(30 BYTE),
  "MANAGER_ID" NUMBER(6),
  "PLACE_ID" NUMBER(4)
)
TABLESPACE "USERS"
INITRANS 2
MAXTRANS 255
PCTFREE 8;
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (10,'Administration',200,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (20,'Marketing',201,1800);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (30,'Purchasing',114,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (40,'Human Resources',203,2400);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (50,'Shipping',121,1500);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (60,'IT',103,1400);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (70,'Public Relations',204,2700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (80,'Sales',145,2500);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (90,'Executive',100,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (100,'Finance',108,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (110,'Accounting',205,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (120,'Treasury',null,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (130,'Corporate Tax',null,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (140,'Control And Credit',null,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (150,'Shareholder Services',null,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (160,'Benefits',null,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (170,'Manufacturing',null,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (180,'Construction',null,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (190,'Contracting',null,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (200,'Operations',null,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (210,'IT Support',null,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (220,'NOC',null,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (230,'IT Helpdesk',null,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (240,'Government Sales',null,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (250,'Retail Sales',null,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (260,'Recruiting',null,1700);
INSERT INTO "SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values
  (270,'Payroll',null,1700);
COMMIT;

DROP TABLE IF EXISTS "PLACES" CASCADE CONSTRAINTS;
CREATE TABLE "PLACES"
(
  "PLACE_ID" NUMBER(4) NOT NULL,
  "STREET_ADDRESS" VARCHAR(40 BYTE),
  "POSTAL_CODE" VARCHAR(12 BYTE),
  "CITY" VARCHAR(30 BYTE),
  "STATE_PROVINCE" VARCHAR(25 BYTE),
  "STATE_ID" CHAR(2 BYTE)
)
TABLESPACE "USERS"
INITRANS 2
MAXTRANS 255
PCTFREE 8;
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (1000,'1297 Via Cola di Rie','00989','Roma',null,'IT');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (1100,'93091 Calle della Testa','10934','Venice',null,'IT');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (1200,'2017 Shinjuku-ku','1689','Tokyo','Tokyo Prefecture','JP');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (1300,'9450 Kamiya-cho','6823','Hiroshima',null,'JP');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (1400,'2014 Jabberwocky Rd','26192','Southlake','Texas','US');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (1500,'2011 Interiors Blvd','99236','South San Francisco','California','US');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (1600,'2007 Zagora St','50090','South Brunswick','New Jersey','US');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (1700,'2004 Charade Rd','98199','Seattle','Washington','US');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (1800,'147 Spadina Ave','M5V 2L7','Toronto','Ontario','CA');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (1900,'6092 Boxwood St','YSW 9T2','Whitehorse','Yukon','CA');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (2000,'40-5-12 Laogianggen','190518','Beijing',null,'CN');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (2100,'1298 Vileparle (E)','490231','Bombay','Maharashtra','IN');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (2200,'12-98 Victoria Street','2901','Sydney','New South Wales','AU');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (2300,'198 Clementi North','540198','Singapore',null,'SG');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (2400,'8204 Arthur St',null,'London',null,'UK');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (2500,'Magdalen Centre, The Oxford Science Park','OX9 9ZB','Oxford','Oxford','UK');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (2600,'9702 Chester Road','09629850293','Stretford','Manchester','UK');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (2700,'Schwanthalerstr. 7031','80925','Munich','Bavaria','DE');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (2800,'Rua Frei Caneca 1360 ','01307-002','Sao Paulo','Sao Paulo','BR');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (2900,'20 Rue des Corps-Saints','1730','Geneva','Geneve','CH');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (3000,'Murtenstrasse 921','3095','Bern','BE','CH');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (3100,'Pieter Breughelstraat 837','3029SK','Utrecht','Utrecht','NL');
INSERT INTO "PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values
  (3200,'Mariano Escobedo 9991','11932','Mexico City','Distrito Federal,','MX');
COMMIT;

DROP TABLE IF EXISTS "EMPLOYMENT_HISTORY" CASCADE CONSTRAINTS;
CREATE TABLE "EMPLOYMENT_HISTORY"
(
  "STAFF_ID" NUMBER(6),
  "START_DATE" DATE,
  "END_DATE" DATE,
  "EMPLOYMENT_ID" VARCHAR(10 BYTE),
  "SECTION_ID" NUMBER(4)
)
TABLESPACE "USERS"
INITRANS 2
MAXTRANS 255
PCTFREE 8;
INSERT INTO "EMPLOYMENT_HISTORY" ("STAFF_ID","START_DATE","END_DATE","EMPLOYMENT_ID","SECTION_ID") values
  (102,'1993-01-13 00:00:00','1998-07-24 00:00:00','IT_PROG',60);
INSERT INTO "EMPLOYMENT_HISTORY" ("STAFF_ID","START_DATE","END_DATE","EMPLOYMENT_ID","SECTION_ID") values
  (101,'1989-09-21 00:00:00','1993-10-27 00:00:00','AC_ACCOUNT',110);
INSERT INTO "EMPLOYMENT_HISTORY" ("STAFF_ID","START_DATE","END_DATE","EMPLOYMENT_ID","SECTION_ID") values
  (101,'1993-10-28 00:00:00','1997-03-15 00:00:00','AC_MGR',110);
INSERT INTO "EMPLOYMENT_HISTORY" ("STAFF_ID","START_DATE","END_DATE","EMPLOYMENT_ID","SECTION_ID") values
  (201,'1996-02-17 00:00:00','1999-12-19 00:00:00','MK_REP',20);
INSERT INTO "EMPLOYMENT_HISTORY" ("STAFF_ID","START_DATE","END_DATE","EMPLOYMENT_ID","SECTION_ID") values
  (114,'1998-03-24 00:00:00','1999-12-31 00:00:00','ST_CLERK',50);
INSERT INTO "EMPLOYMENT_HISTORY" ("STAFF_ID","START_DATE","END_DATE","EMPLOYMENT_ID","SECTION_ID") values
  (122,'1999-01-01 00:00:00','1999-12-31 00:00:00','ST_CLERK',50);
INSERT INTO "EMPLOYMENT_HISTORY" ("STAFF_ID","START_DATE","END_DATE","EMPLOYMENT_ID","SECTION_ID") values
  (200,'1987-09-17 00:00:00','1993-06-17 00:00:00','AD_ASST',90);
INSERT INTO "EMPLOYMENT_HISTORY" ("STAFF_ID","START_DATE","END_DATE","EMPLOYMENT_ID","SECTION_ID") values
  (176,'1998-03-24 00:00:00','1998-12-31 00:00:00','SA_REP',80);
INSERT INTO "EMPLOYMENT_HISTORY" ("STAFF_ID","START_DATE","END_DATE","EMPLOYMENT_ID","SECTION_ID") values
  (176,'1999-01-01 00:00:00','1999-12-31 00:00:00','SA_MAN',80);
INSERT INTO "EMPLOYMENT_HISTORY" ("STAFF_ID","START_DATE","END_DATE","EMPLOYMENT_ID","SECTION_ID") values
  (200,'1994-07-01 00:00:00','1998-12-31 00:00:00','AC_ACCOUNT',90);
COMMIT;

DROP TABLE IF EXISTS "EMPLOYMENTS" CASCADE CONSTRAINTS;
CREATE TABLE "EMPLOYMENTS"
(
  "EMPLOYMENT_ID" VARCHAR(10 BYTE) NOT NULL,
  "EMPLOYMENT_TITLE" VARCHAR(35 BYTE),
  "MIN_SALARY" NUMBER(6),
  "MAX_SALARY" NUMBER(6)
)
TABLESPACE "USERS"
INITRANS 2
MAXTRANS 255
PCTFREE 8;
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('AD_PRES','President',20000,40000);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('AD_VP','Administration Vice President',15000,30000);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('AD_ASST','Administration Assistant',3000,6000);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('FI_MGR','Finance Manager',8200,16000);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('FI_ACCOUNT','Accountant',4200,9000);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('AC_MGR','Accounting Manager',8200,16000);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('AC_ACCOUNT','Public Accountant',4200,9000);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('SA_MAN','Sales Manager',10000,20000);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('SA_REP','Sales Representative',6000,12000);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('PU_MAN','Purchasing Manager',8000,15000);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('PU_CLERK','Purchasing Clerk',2500,5500);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('ST_MAN','Stock Manager',5500,8500);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('ST_CLERK','Stock Clerk',2000,5000);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('SH_CLERK','Shipping Clerk',2500,5500);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('IT_PROG','Programmer',4000,10000);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('MK_MAN','Marketing Manager',9000,15000);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('MK_REP','Marketing Representative',4000,9000);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('HR_REP','Human Resources Representative',4000,9000);
INSERT INTO "EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values
  ('PR_REP','Public Relations Representative',4500,10500);
COMMIT;

DROP TABLE IF EXISTS "COLLEGE" CASCADE CONSTRAINTS;
CREATE TABLE "COLLEGE"
(
  "COLLEGE_ID" NUMBER,
  "COLLEGE_NAME" VARCHAR(40 BYTE)
)
TABLESPACE "USERS"
INITRANS 2
MAXTRANS 255
PCTFREE 8;
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1001,'The University of Melbourne');
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1002,'Duke University');
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1003,'New York University');
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1004,'Kings College London');
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1005,'Tsinghua University');
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1006,'University of Zurich');
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1007,'Rice University');
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1008,'Boston University');
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1009,'Peking University');
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1010,'Monash University');
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1011,'KU Leuven');
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1012,'University of Basel');
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1013,'Leiden University');
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1014,'Erasmus University');
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1015,'Ghent University');
INSERT INTO "COLLEGE" ("COLLEGE_ID","COLLEGE_NAME") values
  (1016,'Aarhus University');
COMMIT;

DROP TABLE IF EXISTS "AREAS" CASCADE CONSTRAINTS;
CREATE TABLE "AREAS"
(
  "AREA_ID" NUMBER,
  "AREA_NAME" VARCHAR(25 BYTE)
)
TABLESPACE "USERS"
INITRANS 2
MAXTRANS 255
PCTFREE 8;
INSERT INTO "AREAS" ("AREA_ID","AREA_NAME") values
  (1,'Europe');
INSERT INTO "AREAS" ("AREA_ID","AREA_NAME") values
  (2,'Americas');
INSERT INTO "AREAS" ("AREA_ID","AREA_NAME") values
  (3,'Asia');
INSERT INTO "AREAS" ("AREA_ID","AREA_NAME") values
  (4,'Middle East and Africa');
COMMIT;

DROP TABLE IF EXISTS "STAFFS" CASCADE CONSTRAINTS;
CREATE TABLE "STAFFS"
(
  "STAFF_ID" NUMBER(6) NOT NULL,
  "FIRST_NAME" VARCHAR(20 BYTE),
  "LAST_NAME" VARCHAR(25 BYTE),
  "EMAIL" VARCHAR(25 BYTE),
  "PHONE_NUMBER" VARCHAR(20 BYTE),
  "HIRE_DATE" DATE,
  "EMPLOYMENT_ID" VARCHAR(10 BYTE),
  "SALARY" NUMBER(8, 2),
  "COMMISSION_PCT" NUMBER(2, 2),
  "MANAGER_ID" NUMBER(6),
  "SECTION_ID" NUMBER(4),
  "GRADUATED_NAME" VARCHAR(60 BYTE)
)
TABLESPACE "USERS"
INITRANS 2
MAXTRANS 255
PCTFREE 8;
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (198,'Donald','OConnell','DOCONNEL','650.507.9833','1999-06-21 00:00:00','SH_CLERK',2600,null,124,50,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (199,'Douglas','Grant','DGRANT','650.507.9844','2000-01-13 00:00:00','SH_CLERK',2600,null,124,50,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (200,'Jennifer','Whalen','JWHALEN','515.123.4444','1987-09-17 00:00:00','AD_ASST',4400,null,101,10,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (201,'Michael','Hartstein','MHARTSTE','515.123.5555','1996-02-17 00:00:00','MK_MAN',13000,null,100,20,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (202,'Pat','Fay','PFAY','603.123.6666','1997-08-17 00:00:00','MK_REP',6000,null,201,20,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (203,'Susan','Mavris','SMAVRIS','515.123.7777','1994-06-07 00:00:00','HR_REP',6500,null,101,40,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (204,'Hermann','Baer','HBAER','515.123.8888','1994-06-07 00:00:00','PR_REP',10000,null,101,70,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (205,'Shelley','Higgins','SHIGGINS','515.123.8080','1994-06-07 00:00:00','AC_MGR',12000,null,101,110,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (206,'William','Gietz','WGIETZ','515.123.8181','1994-06-07 00:00:00','AC_ACCOUNT',8300,null,205,110,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (100,'Steven','King','SKING','515.123.4567','1987-06-17 00:00:00','AD_PRES',24000,null,null,90,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (101,'Neena','Kochhar','NKOCHHAR','515.123.4568','1989-09-21 00:00:00','AD_VP',17000,null,100,90,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (102,'Lex','De Haan','LDEHAAN','515.123.4569','1993-01-13 00:00:00','AD_VP',17000,null,100,90,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (103,'Alexander','Hunold','AHUNOLD','590.423.4567','1990-01-03 00:00:00','IT_PROG',9000,null,102,60,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (104,'Bruce','Ernst','BERNST','590.423.4568','1991-05-21 00:00:00','IT_PROG',6000,null,103,60,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (105,'David','Austin','DAUSTIN','590.423.4569','1997-06-25 00:00:00','IT_PROG',4800,null,103,60,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (106,'Valli','Pataballa','VPATABAL','590.423.4560','1998-02-05 00:00:00','IT_PROG',4800,null,103,60,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (107,'Diana','Lorentz','DLORENTZ','590.423.5567','1999-02-07 00:00:00','IT_PROG',4200,null,103,60,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (108,'Nancy','Greenberg','NGREENBE','515.124.4569','1994-08-17 00:00:00','FI_MGR',12000,null,101,100,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (109,'Daniel','Faviet','DFAVIET','515.124.4169','1994-08-16 00:00:00','FI_ACCOUNT',9000,null,108,100,null);
INSERT INTO "STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values
  (110,'John','Chen','JCHEN','515.124.4269','1997-09-28 00:00:00','FI_ACCOUNT',8200,null,108,100,null);
COMMIT;
select
  subq_0.c3 as c0,

    sum(
      cast(cast(nullif(TANH(
          cast(cast(null as BINARY_DOUBLE) as BINARY_DOUBLE)),
        case when false then case when false then cast(null as BINARY_DOUBLE) else cast(null as BINARY_DOUBLE) end
             else case when false then cast(null as BINARY_DOUBLE) else cast(null as BINARY_DOUBLE) end
             end
          ) as BINARY_DOUBLE) as BINARY_DOUBLE)) over (partition by subq_0.c0 order by subq_0.c0) as c3,

    STDDEV(
      cast(case when EXISTS (
          select
              subq_0.c1 as c0,

              subq_1.c0 as c1,

              subq_0.c0 as c2,

              subq_1.c2 as c3,

              subq_1.c5 as c4,

              subq_1.c4 as c5
            from

              STATES as ref_1,
              (select
 
                    2 as c0,

                    ref_2.EMPLOYMENT_TITLE as c1,

                    (select PLACE_ID from SECTIONS limit 1 offset 4)
                       as c2,

                    ref_2.MAX_SALARY as c3,

                    (select AREA_ID from AREAS limit 1 offset 2)
                       as c4,

                    subq_0.c1 as c5
                  from
                    EMPLOYMENTS as ref_2

                  where true and subq_0.c1 is not null) as subq_1
            where (subq_1.c5 is not NULL)

              and ((true)

                and (true))
            limit 105) then COS(
          cast(cast(null as BINARY_DOUBLE) as BINARY_DOUBLE)) else COS(
          cast(cast(null as BINARY_DOUBLE) as BINARY_DOUBLE)) end
         as BINARY_DOUBLE)) over (partition by subq_0.c2 order by subq_0.c4) as c6,

    avg(
      cast(subq_0.c0 as BINARY_INTEGER)) over (partition by subq_0.c0 order by subq_0.c4) as c7,

    STDDEV_SAMP(
      cast(subq_0.c0 as BINARY_INTEGER)) over (partition by subq_0.c3,subq_0.c3 order by subq_0.c0,subq_0.c3) as c8
from

  (select
 
        85 as c0,

        case when (true)

            or (89 is NULL) then (select AREA_ID from AREAS limit 1 offset 87)
             else (select AREA_ID from AREAS limit 1 offset 87)
             end
           as c1,

        (select PLACE_ID from SECTIONS limit 1 offset 2)
           as c2,

        last_insert_id() as c3,

        (select AREA_ID from AREAS limit 1 offset 1)
           as c4
      from
        STAFFS as ref_0
      where 84 is not NULL
      limit 97) as subq_0
where true;
select
    STDDEV_SAMP(
      cast(subq_0.c4 as BINARY_INTEGER)) over (partition by subq_0.c4,subq_0.c3,subq_0.c2 order by subq_0.c3) as c0,
    sum(
      cast(cast(null as BINARY_DOUBLE) as BINARY_DOUBLE)) over (partition by subq_0.c3 order by subq_0.c1) as c1,
    STDDEV_POP(
      cast(20 as BINARY_INTEGER)) over (partition by subq_0.c0,subq_0.c1 order by subq_0.c0,subq_0.c2,subq_0.c1,subq_0.c0,subq_0.c1) as c2,
    avg(
      cast(subq_0.c4 as BINARY_INTEGER)) over (partition by subq_0.c4,subq_0.c2 order by subq_0.c0,subq_0.c4) as c3,
    sum(
      cast(subq_0.c4 as BINARY_INTEGER)) over (partition by subq_0.c2 order by subq_0.c0) as c4,

  trim(
    cast(subq_0.c1 as VARCHAR(50)),
    cast((select AREA_NAME from AREAS limit 1 offset 6)
       as VARCHAR(50))) as c5,
    count(
      cast(case when EXISTS (
          select
 
              subq_1.c0 as c0
            from

              EMPLOYMENT_HISTORY as ref_1,
              (select
 
                    subq_0.c4 as c0,

                    subq_0.c2 as c1,

                    subq_0.c1 as c2
                  from
                    EMPLOYMENT_HISTORY as ref_2
                  where subq_0.c1 is NULL) as subq_1
            where subq_1.c1 is not NULL) then cast(null as BINARY_DOUBLE) else cast(null as BINARY_DOUBLE) end
         as BINARY_DOUBLE)) over (partition by subq_0.c1 order by subq_0.c3) as c6,
    STDDEV_POP(
      cast(subq_0.c4 as BINARY_INTEGER)) over (partition by subq_0.c0 order by subq_0.c2) as c7,

  subq_0.c4 as c8,

  subq_0.c4 as c9,

  EMPTY_CLOB() as c10,

  subq_0.c0 as c11
from

  (select
        cast(nullif(ref_0.SECTION_NAME,
          ref_0.SECTION_NAME) as VARCHAR(50)) as c0,

        ref_0.SECTION_NAME as c1,

        ref_0.MANAGER_ID as c2,

        ref_0.SECTION_ID as c3,
          avg(
            cast(69 as BINARY_INTEGER)) over (partition by ref_0.SECTION_NAME order by ref_0.SECTION_ID,ref_0.PLACE_ID,ref_0.PLACE_ID) as c4
      from

        SECTIONS as ref_0
      where ref_0.MANAGER_ID is NULL
      limit 67) as subq_0
where ((true)

    or (subq_0.c2 is NULL))

  or ((((subq_0.c1 is NULL)

        or (subq_0.c2 is NULL))

      or (true))

    and (case when EXISTS (
          select
 
              ref_5.MIN_SALARY as c0,

              ref_3.MAX_SALARY as c1,

              ref_3.MIN_SALARY as c2,

              ref_4.MAX_SALARY as c3
            from

              EMPLOYMENTS as ref_3
                  inner join EMPLOYMENTS as ref_4
                  on (ref_4.EMPLOYMENT_TITLE is NULL)
                right join EMPLOYMENTS as ref_5
                on (ref_3.MIN_SALARY = ref_5.MIN_SALARY )
            where (ref_4.EMPLOYMENT_ID is NULL)

              or (subq_0.c1 is not NULL)
            limit 51) then subq_0.c4 else subq_0.c4 end
         is not NULL))
limit 49;
select
  case when true then

      STDDEV(
        cast(LOG(
          cast(96 as BINARY_INTEGER),
          cast(case when ((EXISTS (
                  select
 
                      ref_0.COLLEGE_ID as c0,

                      ref_0.COLLEGE_NAME as c1,

                      ref_0.COLLEGE_NAME as c2,

                      ref_0.COLLEGE_ID as c3,

                      ref_0.COLLEGE_NAME as c4
                    from

                      STATES as ref_1,
                      (select
 
                            ref_0.COLLEGE_ID as c0,

                            ref_0.COLLEGE_ID as c1,

                            ref_0.COLLEGE_ID as c2,

                            ref_0.COLLEGE_ID as c3,

                            (select SECTION_NAME from SECTIONS limit 1 offset 4)
                               as c4,

                            ref_0.COLLEGE_NAME as c5,

                            ref_0.COLLEGE_NAME as c6
                          from

                            PLACES as ref_2
                          where true) as subq_0
                    where subq_0.c6 is not NULL
                    limit 33))

                and ((ref_0.COLLEGE_ID is NULL)

                  and (ref_0.COLLEGE_NAME is NULL)))

              and (ref_0.COLLEGE_NAME is not NULL) then 52 else 52 end
             as BINARY_INTEGER)) as BINARY_INTEGER)) over (partition by ref_0.COLLEGE_ID order by ref_0.COLLEGE_NAME) else

      STDDEV(
        cast(LOG(
          cast(96 as BINARY_INTEGER),
          cast(case when ((EXISTS (
                  select
 
                      ref_0.COLLEGE_ID as c0,

                      ref_0.COLLEGE_NAME as c1,

                      ref_0.COLLEGE_NAME as c2,

                      ref_0.COLLEGE_ID as c3,
                      ref_0.COLLEGE_NAME as c4
                    from
                      STATES as ref_1,
                      (select
                            ref_0.COLLEGE_ID as c0,
                            ref_0.COLLEGE_ID as c1,
                            ref_0.COLLEGE_ID as c2,
                            ref_0.COLLEGE_ID as c3,
                            (select SECTION_NAME from SECTIONS limit 1 offset 4)
                               as c4,
                            ref_0.COLLEGE_NAME as c5,
                            ref_0.COLLEGE_NAME as c6
                          from
                            PLACES as ref_2
                          where true) as subq_0
                    where subq_0.c6 is not NULL
                    limit 33))
                and ((ref_0.COLLEGE_ID is NULL)
                  and (ref_0.COLLEGE_NAME is NULL)))
              and (ref_0.COLLEGE_NAME is not NULL) then 52 else 52 end
             as BINARY_INTEGER)) as BINARY_INTEGER)) over (partition by ref_0.COLLEGE_ID order by ref_0.COLLEGE_NAME) end
     as c0,
    MIN(
      cast(cast(null as BINARY_DOUBLE) as BINARY_DOUBLE)) over (partition by ref_0.COLLEGE_NAME order by ref_0.COLLEGE_NAME) as c1,
    STDDEV(
      cast(27 as BINARY_INTEGER)) over (partition by ref_0.COLLEGE_ID order by ref_0.COLLEGE_ID) as c2,
    max(
      cast(case when (ref_0.COLLEGE_ID is NULL)
          or (EXISTS (
            select
                ref_3.MANAGER_ID as c0,
                ref_0.COLLEGE_ID as c1
              from
                SECTIONS as ref_3
              where EXISTS (
                select
                    ref_0.COLLEGE_ID as c0
                  from
                    EMPLOYMENT_HISTORY as ref_4
                  where false
                  limit 63)
              limit 48)) then case when (((true)
                or (ref_0.COLLEGE_ID is not NULL))
              and (EXISTS (
                select
                    ref_5.EMPLOYMENT_ID as c0,
                    ref_0.COLLEGE_ID as c1,
                    ref_0.COLLEGE_ID as c2,
                    ref_0.COLLEGE_ID as c3
                  from
                    EMPLOYMENTS as ref_5
                  where ref_0.COLLEGE_NAME is not NULL)))
            and ((false)
              and (true)) then cast(null as BINARY_DOUBLE) else cast(null as BINARY_DOUBLE) end
           else case when (((true)
                or (ref_0.COLLEGE_ID is not NULL))
              and (EXISTS (
                select
                    ref_5.EMPLOYMENT_ID as c0,
                    ref_0.COLLEGE_ID as c1,
                    ref_0.COLLEGE_ID as c2,
                    ref_0.COLLEGE_ID as c3
                  from
                    EMPLOYMENTS as ref_5
                  where ref_0.COLLEGE_NAME is not NULL)))

            and ((false)

              and (true)) then cast(null as BINARY_DOUBLE) else cast(null as BINARY_DOUBLE) end
           end
         as BINARY_DOUBLE)) over (partition by ref_0.COLLEGE_NAME order by ref_0.COLLEGE_NAME) as c4,
    STDDEV_SAMP(
      cast(last_insert_id() as BINARY_INTEGER)) over (partition by ref_0.COLLEGE_ID,ref_0.COLLEGE_NAME order by ref_0.COLLEGE_ID) as c5,
    max(
      cast(case when false then case when ref_0.COLLEGE_NAME is NULL then 16 else 16 end
           else case when ref_0.COLLEGE_NAME is NULL then 16 else 16 end
           end
         as BINARY_INTEGER)) over (partition by ref_0.COLLEGE_ID,ref_0.COLLEGE_NAME,ref_0.COLLEGE_ID,ref_0.COLLEGE_ID,ref_0.COLLEGE_NAME order by ref_0.COLLEGE_ID) as c6
from

  COLLEGE as ref_0
where ref_0.COLLEGE_ID is not NULL
limit 77;
select
  subq_0.c3 as c0,
    STDDEV(
      cast(subq_0.c3 as BINARY_INTEGER)) over (partition by subq_0.c2 order by subq_0.c3) as c1,
    STDDEV_POP(
      cast(subq_0.c3 as BINARY_INTEGER)) over (partition by subq_0.c1 order by subq_0.c2,subq_0.c0) as c2,
    sum(
      cast(cast(nullif(TANH(
          cast(cast(null as BINARY_DOUBLE) as BINARY_DOUBLE)),
        case when false then case when false then cast(null as BINARY_DOUBLE) else cast(null as BINARY_DOUBLE) end
             else case when false then cast(null as BINARY_DOUBLE) else cast(null as BINARY_DOUBLE) end
             end
          ) as BINARY_DOUBLE) as BINARY_DOUBLE)) over (partition by subq_0.c0 order by subq_0.c0) as c3,
    avg(
      cast(subq_0.c3 as BINARY_INTEGER)) over (partition by subq_0.c0,subq_0.c0,subq_0.c0 order by subq_0.c1,subq_0.c4) as c4,
    STDDEV_POP(
      cast(subq_0.c0 as BINARY_INTEGER)) over (partition by subq_0.c0 order by subq_0.c0) as c5,
    STDDEV(
      cast(case when EXISTS (
          select
              subq_0.c1 as c0,
              subq_1.c0 as c1,
              subq_0.c0 as c2,
              subq_1.c2 as c3,
              subq_1.c5 as c4,
              subq_1.c4 as c5
            from
              STATES as ref_1,
              (select
                    2 as c0,
                    ref_2.EMPLOYMENT_TITLE as c1,
                    (select PLACE_ID from SECTIONS limit 1 offset 4)
                       as c2,
                    ref_2.MAX_SALARY as c3,
                    (select AREA_ID from AREAS limit 1 offset 2)
                       as c4,
                    subq_0.c1 as c5
                  from
                    EMPLOYMENTS as ref_2
                  where true) as subq_1
            where (subq_1.c5 is not NULL)
              and ((true)
                and (true))
            limit 105) then COS(
          cast(cast(null as BINARY_DOUBLE) as BINARY_DOUBLE)) else COS(
          cast(cast(null as BINARY_DOUBLE) as BINARY_DOUBLE)) end
         as BINARY_DOUBLE)) over (partition by subq_0.c2 order by subq_0.c4) as c6,
    avg(
      cast(subq_0.c0 as BINARY_INTEGER)) over (partition by subq_0.c0 order by subq_0.c4) as c7,
    STDDEV_SAMP(
      cast(subq_0.c0 as BINARY_INTEGER)) over (partition by subq_0.c3,subq_0.c3 order by subq_0.c0,subq_0.c3) as c8
from
  (select
        85 as c0,
        case when (true)

            or (89 is NULL) then (select AREA_ID from AREAS limit 1 offset 87)
             else (select AREA_ID from AREAS limit 1 offset 87)
             end
           as c1,
        (select PLACE_ID from SECTIONS limit 1 offset 2)
           as c2,
        last_insert_id() as c3,
        (select AREA_ID from AREAS limit 1 offset 1)
           as c4
      from
        STAFFS as ref_0
      where 84 is not NULL
      limit 97) as subq_0
where true
limit 122;
MERGE INTO EMPLOYMENTS target_0
USING (select  
      ref_0.COLLEGE_NAME as c0, 
        count(
          cast(cast(null as BINARY_DOUBLE) as BINARY_DOUBLE)) over (partition by ref_0.COLLEGE_ID order by ref_0.COLLEGE_ID) as c1, 
        avg(
          cast(cast(null as BINARY_DOUBLE) as BINARY_DOUBLE)) over (partition by ref_0.COLLEGE_ID order by ref_0.COLLEGE_NAME,ref_0.COLLEGE_NAME) as c2, 
      ref_0.COLLEGE_NAME as c3, 
        sum(
          cast(BITAND(
            cast(13 as BINARY_INTEGER),
            cast(68 as BINARY_INTEGER)) as BINARY_INTEGER)) over (partition by ref_0.COLLEGE_NAME,ref_0.COLLEGE_ID order by ref_0.COLLEGE_NAME) as c4, 
      ref_0.COLLEGE_ID as c5, 
      
        count(
          cast(case when EXISTS (
              select  
                  ref_0.COLLEGE_ID as c0, 
                  subq_0.c2 as c1, 
                  ref_0.COLLEGE_ID as c2, 
                  subq_0.c1 as c3, 
                  ref_0.COLLEGE_ID as c4, 
                  ref_0.COLLEGE_ID as c5, 
                  97 as c6, 
                  subq_0.c0 as c7, 
                  subq_0.c2 as c8, 
                  (select EMPLOYMENT_TITLE from EMPLOYMENTS limit 1 offset 1)
                     as c9, 
                  ref_0.COLLEGE_NAME as c10, 
                  ref_0.COLLEGE_ID as c11
                from 
                  PLACES as ref_1,
                  (select  
                        ref_0.COLLEGE_NAME as c0, 
                        ref_0.COLLEGE_NAME as c1, 
                        ref_0.COLLEGE_NAME as c2
                      from 
                        STATES as ref_2
                      where false) as subq_0
                where (EXISTS (
                    select  
                        subq_0.c2 as c0
                      from 
                        EMPLOYMENTS as ref_3
                      where (ref_3.MIN_SALARY is NULL) 
                        or (false))) 
                  and (subq_0.c2 is NULL)
                limit 61) then cast(null as BINARY_DOUBLE) else cast(null as BINARY_DOUBLE) end
             as BINARY_DOUBLE)) over (partition by ref_0.COLLEGE_ID,ref_0.COLLEGE_NAME order by ref_0.COLLEGE_NAME) as c6, 
      ref_0.COLLEGE_ID as c7, 
      last_insert_id() as c8
    from 
      COLLEGE as ref_0
    where case when (false) 
          or (false) then ref_0.COLLEGE_ID else ref_0.COLLEGE_ID end
         is not NULL) as subq_1
ON (target_0.MIN_SALARY = subq_1.c5 ) 
WHEN NOT MATCHED 
   THEN INSERT VALUES ( cast(null as VARCHAR(50)), cast(null as VARCHAR(50)), cast(null as NUMBER), cast(null as NUMBER))
WHEN MATCHED 
   THEN UPDATE  set 
    EMPLOYMENT_ID = target_0.EMPLOYMENT_ID, 
MAX_SALARY = target_0.MIN_SALARY;
--20210907
SELECT 
  SUBQ_0.C0 AS C1
FROM
  ((((SELECT
            REF_1.PEXPR_1_AGGR_0 AS C0,
            REF_1.PEXPR_0_AGGR_0 AS C1
          FROM
            SALARIES PIVOT(COVAR_SAMP(
                CAST(SALARIES.SALARY AS BINARY_INTEGER),
                CAST(SALARIES.SALARY AS BINARY_INTEGER)) AS AGGR_0
               FOR (EMP_NO, TO_DATE, SALARY, FROM_DATE)
              IN ((10007, '1993-08-22 00:00:00', 5400, '1996-08-03 00:00:00') AS PEXPR_0, (10008, '1992-07-29 00:00:00', 5500, '1995-12-03 00:00:00') AS PEXPR_1, (10009, '2002-07-15 00:00:00', 5600, '1986-12-01 00:00:00') AS PEXPR_2)) AS REF_1
          WHERE 1 = 1)
          EXCEPT  (
          SELECT
            REF_2.SECTION_ID AS C2,
            REF_2.MANAGER_ID AS C3
          FROM
            SECTIONS AS REF_2
          WHERE REF_2.SECTION_NAME REGEXP '.*'
          LIMIT 94, 40)
        ) AS SUBQ_0)
      RIGHT OUTER JOIN (EMPLOYMENTS UNPIVOT EXCLUDE NULLS ((NEWCOL_0)
         FOR (FORCOL_0, FORCOL_1)
        IN ((EMPLOYMENT_TITLE), (EMPLOYMENT_TITLE) AS ('UNPIVOT_VALUE_0', 'UNPIVOT_VALUE_1'), (EMPLOYMENT_TITLE) AS ('UNPIVOT_VALUE_0', 'UNPIVOT_VALUE_1'), (EMPLOYMENT_TITLE) AS ('UNPIVOT_VALUE_0', 'UNPIVOT_VALUE_1'), (EMPLOYMENT_TITLE), (EMPLOYMENT_TITLE) AS ('UNPIVOT_VALUE_0', 'UNPIVOT_VALUE_1'))) AS REF_3)
      ON (SUBQ_0.C1 = REF_3.MIN_SALARY ))
    full OUTER JOIN (DEPT_EMP AS REF_4)
    ON (REGEXP_LIKE(REF_3.FORCOL_1,'.*'))
WHERE '2021-09-07 12:44:03' >= CAST('2021-09-07 12:44:03' AS TIMESTAMP(6)) limit 1;
--20201201
SELECT
    CORR(
      CAST((SELECT 1 FROM sys_dummy) AS NUMBER(6,0)),
      CAST(0.0 AS NUMBER)) OVER (PARTITION BY SUBQ_0.C9,SUBQ_0.C6 ORDER BY SUBQ_0.C10 DESC NULLS LAST) AS C0
FROM
  (SELECT
        REF_0.STU_ID AS C0,
        REF_0.ID AS C1,
        CAST('2020-11-24 00:44:37' AS TIMESTAMP(6) WITH TIME ZONE) AS C5,
        REF_0.GRADE AS C6,
        NULL AS C9,
        CAST('201066 11:13:26' AS INTERVAL DAY TO SECOND) AS C10,
        '0' AS C11,
        FALSE AS C12
      FROM
        SCORE  REF_0
      WHERE NULL < ALL(
        SELECT
            NULL AS C1
          FROM
            PLACES  REF_1
          WHERE (REF_0.STU_ID IN (
              SELECT
                  NULL AS C1
                FROM
                  COLLEGE PIVOT(COVAR_POP(
                      CAST(77 AS BINARY_INTEGER),
                      CAST(NULL AS BINARY_DOUBLE)) AS AGGR_0, STDDEV(
                      CAST(13 AS BINARY_UINT32)) AS AGGR_1
                     FOR (COLLEGE_ID, COLLEGE_NAME)
                    IN ((1005, 'Tsinghua University') AS PEXPR_0, (1006, 'University of Zurich') AS PEXPR_1)) REF_2
                WHERE REF_1.STREET_ADDRESS REGEXP '.*'))
          OFFSET 83 LIMIT 80)
    ) AS SUBQ_0
LIMIT 63;
--20201016
SELECT
  SUBQ_0.C35 AS C4,
  SUBQ_0.C1 AS C5
FROM
  (SELECT DISTINCT
        REF_0.ID AS C1,
        REF_0.ID AS C18,
        MIN(CAST(REF_0.PASSWORD AS VARCHAR(256))) over (partition by REF_0.ID,REF_0.ID,REF_0.PASSWORD ORDER BY REF_0.NAME,REF_0.NAME) AS C35,
        REF_0.PASSWORD AS C36,
        REF_0.NAME AS C37
    FROM
        SYS.SYS_ROLES AS REF_0
    WHERE CAST('7A894DBD2F669064' AS RAW(4096)) != CASE WHEN NULL >= CAST('EB3FA299E34C78A7' AS BINARY(100)) THEN CAST('73DA76081F985663' AS RAW(4096)) ELSE CAST('73DA76081F985663' AS RAW(4096)) END
  ) AS SUBQ_0;
--20201226
SELECT 
  1
FROM 
  EMPLOYMENT_HISTORY PIVOT(COVAR_SAMP(
      CAST(EMPLOYMENT_HISTORY.STAFF_ID AS NUMBER(6,0)),
      CAST(EMPLOYMENT_HISTORY.SECTION_ID AS NUMBER(4,0))) AS AGGR_0
     FOR (STAFF_ID, SECTION_ID, EMPLOYMENT_ID, END_DATE)
    IN ((176, 90, 'AD_ASST', '1999-12-31 00:00:00') AS PEXPR_0)) AS REF_0
WHERE NVL2(
  CAST(REF_0.PEXPR_0_AGGR_0 AS NUMBER),
  CAST(CURRENT_TIMESTAMP() AS DATE),
  CAST(CAST('2020-12-17 17:06:44' AS DATE) AS DATE)) <> ALL(
  (SELECT 
      NULL AS C1
    FROM 
      EMPLOYMENT_HISTORY PIVOT(CORR(
          CAST(EMPLOYMENT_HISTORY.SECTION_ID AS NUMBER(4,0)),
          CAST(EMPLOYMENT_HISTORY.STAFF_ID AS NUMBER(6,0))) AS AGGR_0
         FOR (START_DATE, EMPLOYMENT_ID, END_DATE)
        IN (('1998-03-24 00:00:00', 'AD_ASST', '1999-12-31 00:00:00') AS PEXPR_0)) AS REF_3
    WHERE REF_0.PEXPR_0_AGGR_0 <> ANY(
      SELECT 
          REF_3.PEXPR_0_AGGR_0 AS C1
        FROM 
          EMPLOYEES  AS REF_4))
    INTERSECT (
    (SELECT 
      1 AS C1
    FROM 
      FVT_OBJ_DEFINE_TABLE_FRE1 AS REF_5)));
--20200924
drop table if exists temp_0924;
CREATE TABLE temp_0924(ID INT, NAME VARCHAR(20)) PARTITION BY RANGE(ID) INTERVAL(50) SUBPARTITION BY HASH(NAME) (
PARTITION P1 VALUES LESS THAN(50) (SUBPARTITION P11,SUBPARTITION P12),PARTITION P2 VALUES LESS THAN(100) (SUBPARTITION P21,SUBPARTITION P22));
create index temp_0924_index_003 on temp_0924(id) local;
create index temp_0924_index_004 on temp_0924(name) local;
create index temp_0924_index_002 on temp_0924(id,name) local;
declare
v_name varchar(20);
v_id int;
begin
for i in 1..1000 loop
v_id :=i;
v_name := 'OSS3:NE=forver' || to_char(i);
insert into temp_0924 values (v_id,v_name);
end loop;
commit;
end;
/
SELECT
  CASE WHEN (
          MIN(
            CAST(false as BOOLEAN)) over (partition by ref_0.ID ORDER BY ref_0.NAME,ref_0.NAME) <> false)
      AND (false <> false) THEN ref_0.ID ELSE ref_0.ID END
     AS C0,
  ref_0.NAME AS C1,
  CASE WHEN false THEN 82 ELSE 82 END
     AS C2
FROM
  temp_0924 as ref_0
WHERE true > CASE WHEN CASE WHEN CAST(coalesce(true,
            true) AS BOOLEAN) < true THEN false ELSE false END
         >= true THEN CAST(nullif(false,
      true) AS BOOLEAN) ELSE CAST(nullif(false,
      true) AS BOOLEAN) END limit 10;
explain SELECT
  CASE WHEN (
          MIN(
            CAST(false as BOOLEAN)) over (partition by ref_0.ID ORDER BY ref_0.NAME,ref_0.NAME) <> false)
      AND (false <> false) THEN ref_0.ID ELSE ref_0.ID END
     AS C0,
  ref_0.NAME AS C1,
  CASE WHEN false THEN 82 ELSE 82 END
     AS C2
FROM
  temp_0924 as ref_0
WHERE true > CASE WHEN CASE WHEN CAST(coalesce(true,
            true) AS BOOLEAN) < true THEN false ELSE false END
         >= true THEN CAST(nullif(false,
      true) AS BOOLEAN) ELSE CAST(nullif(false,
      true) AS BOOLEAN) END limit 10;
drop table temp_0924;
--20201022
DROP TABLE IF EXISTS "INF_PROD_PROP" CASCADE CONSTRAINTS;
CREATE TABLE "INF_PROD_PROP"
(
  "PROP_INST_ID" NUMBER(20) NOT NULL,
  "PROD_INST_ID" NUMBER(20) NOT NULL,
  "PROP_ID" NUMBER(20) NOT NULL,
  "PROP_CODE" VARCHAR(32 BYTE) NOT NULL,
  "COMPLEX_FLAG" VARCHAR(1 BYTE) NOT NULL,
  "PROP_VALUE" VARCHAR(4000 BYTE),
  "P_PROP_INST_ID" NUMBER(20),
  "OFFERING_INST_ID" NUMBER(20),
  "OWNER_ENTITY_TYPE" VARCHAR(4 BYTE),
  "OWNER_ENTITY_ID" NUMBER(20),
  "MODIFY_CHANNEL_TYPE" VARCHAR(4 BYTE),
  "ENTITY_ROUTE" VARCHAR(1024 BYTE),
  "EFF_DATE" DATE NOT NULL,
  "EXP_DATE" DATE NOT NULL,
  "CREATE_ORDER_ID" NUMBER(20),
  "LAST_MOD_ORDER_ID" NUMBER(20),
  "CREATE_PROLE_TYPE" VARCHAR(4 BYTE),
  "CREATE_PROLE_ID" NUMBER(20),
  "CREATE_DEPT_ID" NUMBER(20),
  "CREATE_TIME" DATE,
  "MODIFY_PROLE_TYPE" VARCHAR(4 BYTE),
  "MODIFY_PROLE_ID" NUMBER(20),
  "MODIFY_DEPT_ID" NUMBER(20),
  "MODIFY_TIME" DATE,
  "PARTITION_ID" NUMBER(8),
  "EX_FIELD1" VARCHAR(32 BYTE),
  "EX_FIELD2" VARCHAR(32 BYTE),
  "EX_FIELD3" VARCHAR(32 BYTE),
  "EX_FIELD4" VARCHAR(32 BYTE),
  "EX_FIELD5" VARCHAR(32 BYTE),
  "EX_FIELD6" VARCHAR(32 BYTE),
  "EX_FIELD7" VARCHAR(32 BYTE),
  "EX_FIELD8" VARCHAR(32 BYTE),
  "EX_FIELD9" VARCHAR(32 BYTE),
  "EX_FIELD10" VARCHAR(32 BYTE),
  "BE_ID" NUMBER(10),
  "PREVIOUS_DATA_VERSION" DATE,
  "DATA_VERSION" DATE,
  "TENANT_ID" NUMBER(20) NOT NULL
);
INSERT INTO "INF_PROD_PROP" ("PROP_INST_ID","PROD_INST_ID","PROP_ID","PROP_CODE","COMPLEX_FLAG","PROP_VALUE","P_PROP_INST_ID","OFFERING_INST_ID","OWNER_ENTITY_TYPE","OWNER_ENTITY_ID","MODIFY_CHANNEL_TYPE","ENTITY_ROUTE","EFF_DATE","EXP_DATE","CREATE_ORDER_ID","LAST_MOD_ORDER_ID","CREATE_PROLE_TYPE","CREATE_PROLE_ID","CREATE_DEPT_ID","CREATE_TIME","MODIFY_PROLE_TYPE","MODIFY_PROLE_ID","MODIFY_DEPT_ID","MODIFY_TIME","PARTITION_ID","EX_FIELD1","EX_FIELD2","EX_FIELD3","EX_FIELD4","EX_FIELD5","EX_FIELD6","EX_FIELD7","EX_FIELD8","EX_FIELD9","EX_FIELD10","BE_ID","PREVIOUS_DATA_VERSION","DATA_VERSION","TENANT_ID") values
  (8511000000000426,8511000000000573,1532350213422020129,'C_SMS','N','0',null,8511000000000288,'S',8511000000000073,'601','O2018082307.P1042','2020-07-13 04:16:40','2099-12-31 23:59:59',850100000000000250,850100000000000250,'E',66010001,4865183546,'2020-07-13 04:16:51',null,null,null,'2020-07-13 04:16:51',null,null,null,null,null,null,null,null,null,null,null,101,null,'2020-07-13 04:16:51',999999);
INSERT INTO "INF_PROD_PROP" ("PROP_INST_ID","PROD_INST_ID","PROP_ID","PROP_CODE","COMPLEX_FLAG","PROP_VALUE","P_PROP_INST_ID","OFFERING_INST_ID","OWNER_ENTITY_TYPE","OWNER_ENTITY_ID","MODIFY_CHANNEL_TYPE","ENTITY_ROUTE","EFF_DATE","EXP_DATE","CREATE_ORDER_ID","LAST_MOD_ORDER_ID","CREATE_PROLE_TYPE","CREATE_PROLE_ID","CREATE_DEPT_ID","CREATE_TIME","MODIFY_PROLE_TYPE","MODIFY_PROLE_ID","MODIFY_DEPT_ID","MODIFY_TIME","PARTITION_ID","EX_FIELD1","EX_FIELD2","EX_FIELD3","EX_FIELD4","EX_FIELD5","EX_FIELD6","EX_FIELD7","EX_FIELD8","EX_FIELD9","EX_FIELD10","BE_ID","PREVIOUS_DATA_VERSION","DATA_VERSION","TENANT_ID") values
  (7911000000000456,7911000000000612,1478848289073239599,'PM_DELIVERY_LIMIT_AD','N','0',null,7911000000000306,'S',7911000000001087,'601','O2018082306.P1053','2020-07-13 04:16:43','2099-12-31 23:59:59',790100000000000265,790100000000000265,'E',66010001,4865183546,'2020-07-13 04:16:53',null,null,null,'2020-07-13 04:16:53',null,null,null,null,null,null,null,null,null,null,null,101,null,'2020-07-13 04:16:53',999999);
INSERT INTO "INF_PROD_PROP" ("PROP_INST_ID","PROD_INST_ID","PROP_ID","PROP_CODE","COMPLEX_FLAG","PROP_VALUE","P_PROP_INST_ID","OFFERING_INST_ID","OWNER_ENTITY_TYPE","OWNER_ENTITY_ID","MODIFY_CHANNEL_TYPE","ENTITY_ROUTE","EFF_DATE","EXP_DATE","CREATE_ORDER_ID","LAST_MOD_ORDER_ID","CREATE_PROLE_TYPE","CREATE_PROLE_ID","CREATE_DEPT_ID","CREATE_TIME","MODIFY_PROLE_TYPE","MODIFY_PROLE_ID","MODIFY_DEPT_ID","MODIFY_TIME","PARTITION_ID","EX_FIELD1","EX_FIELD2","EX_FIELD3","EX_FIELD4","EX_FIELD5","EX_FIELD6","EX_FIELD7","EX_FIELD8","EX_FIELD9","EX_FIELD10","BE_ID","PREVIOUS_DATA_VERSION","DATA_VERSION","TENANT_ID") values
  (9111000000001475,9111000000001618,1478848289073239599,'PM_DELIVERY_LIMIT_AD','N','0',null,9111000000001308,'S',9111000000000082,'601','O2018082307.P1053','2020-07-13 04:16:45','2099-12-31 23:59:59',910100000000001266,910100000000001266,'E',66010001,4865183546,'2020-07-13 04:16:58',null,null,null,'2020-07-13 04:16:58',null,null,null,null,null,null,null,null,null,null,null,101,null,'2020-07-13 04:16:58',999999);
INSERT INTO "INF_PROD_PROP" ("PROP_INST_ID","PROD_INST_ID","PROP_ID","PROP_CODE","COMPLEX_FLAG","PROP_VALUE","P_PROP_INST_ID","OFFERING_INST_ID","OWNER_ENTITY_TYPE","OWNER_ENTITY_ID","MODIFY_CHANNEL_TYPE","ENTITY_ROUTE","EFF_DATE","EXP_DATE","CREATE_ORDER_ID","LAST_MOD_ORDER_ID","CREATE_PROLE_TYPE","CREATE_PROLE_ID","CREATE_DEPT_ID","CREATE_TIME","MODIFY_PROLE_TYPE","MODIFY_PROLE_ID","MODIFY_DEPT_ID","MODIFY_TIME","PARTITION_ID","EX_FIELD1","EX_FIELD2","EX_FIELD3","EX_FIELD4","EX_FIELD5","EX_FIELD6","EX_FIELD7","EX_FIELD8","EX_FIELD9","EX_FIELD10","BE_ID","PREVIOUS_DATA_VERSION","DATA_VERSION","TENANT_ID") values
  (811000000001523,811000000001680,1478848289073239599,'PM_DELIVERY_LIMIT_AD','N','0',null,811000000001348,'S',811000000001098,'601','O2019003027.P1053','2020-07-13 04:17:00','2099-12-31 23:59:59',80100000000001297,80100000000001297,'E',66010001,4865183546,'2020-07-13 04:17:10',null,null,null,'2020-07-13 04:17:10',null,null,null,null,null,null,null,null,null,null,null,101,null,'2020-07-13 04:17:10',999999);
INSERT INTO "INF_PROD_PROP" ("PROP_INST_ID","PROD_INST_ID","PROP_ID","PROP_CODE","COMPLEX_FLAG","PROP_VALUE","P_PROP_INST_ID","OFFERING_INST_ID","OWNER_ENTITY_TYPE","OWNER_ENTITY_ID","MODIFY_CHANNEL_TYPE","ENTITY_ROUTE","EFF_DATE","EXP_DATE","CREATE_ORDER_ID","LAST_MOD_ORDER_ID","CREATE_PROLE_TYPE","CREATE_PROLE_ID","CREATE_DEPT_ID","CREATE_TIME","MODIFY_PROLE_TYPE","MODIFY_PROLE_ID","MODIFY_DEPT_ID","MODIFY_TIME","PARTITION_ID","EX_FIELD1","EX_FIELD2","EX_FIELD3","EX_FIELD4","EX_FIELD5","EX_FIELD6","EX_FIELD7","EX_FIELD8","EX_FIELD9","EX_FIELD10","BE_ID","PREVIOUS_DATA_VERSION","DATA_VERSION","TENANT_ID") values
  (2111000000001548,2111000000001714,1478848289073239599,'PM_DELIVERY_LIMIT_AD','N','0',null,2111000000001365,'S',2111000000000093,'601','O2018082307.P1053','2020-07-13 04:17:05','2099-12-31 23:59:59',210100000000001310,210100000000001310,'E',66010001,4865183546,'2020-07-13 04:17:17',null,null,null,'2020-07-13 04:17:17',null,null,null,null,null,null,null,null,null,null,null,101,null,'2020-07-13 04:17:17',999999);
INSERT INTO "INF_PROD_PROP" ("PROP_INST_ID","PROD_INST_ID","PROP_ID","PROP_CODE","COMPLEX_FLAG","PROP_VALUE","P_PROP_INST_ID","OFFERING_INST_ID","OWNER_ENTITY_TYPE","OWNER_ENTITY_ID","MODIFY_CHANNEL_TYPE","ENTITY_ROUTE","EFF_DATE","EXP_DATE","CREATE_ORDER_ID","LAST_MOD_ORDER_ID","CREATE_PROLE_TYPE","CREATE_PROLE_ID","CREATE_DEPT_ID","CREATE_TIME","MODIFY_PROLE_TYPE","MODIFY_PROLE_ID","MODIFY_DEPT_ID","MODIFY_TIME","PARTITION_ID","EX_FIELD1","EX_FIELD2","EX_FIELD3","EX_FIELD4","EX_FIELD5","EX_FIELD6","EX_FIELD7","EX_FIELD8","EX_FIELD9","EX_FIELD10","BE_ID","PREVIOUS_DATA_VERSION","DATA_VERSION","TENANT_ID") values
  (4211000000000916,4211000000006247,1532350213422020129,'C_SMS','N','0',null,4211000000000620,'S',4211000000001170,'601','O2018082306.P1042','2020-07-13 04:18:35','2099-12-31 23:59:59',420100000000000537,420100000000000537,'E',66010001,4865183546,'2020-07-13 04:18:46',null,null,null,'2020-07-13 04:18:46',null,null,null,null,null,null,null,null,null,null,null,101,null,'2020-07-13 04:18:46',999999);
commit;
DROP TABLE IF EXISTS "MKM_T_DASHBOARD" CASCADE CONSTRAINTS;
CREATE TABLE "MKM_T_DASHBOARD"
(
  "OBJECTID" VARCHAR(40 BYTE) NOT NULL,
  "USERID" VARCHAR(40 BYTE) NOT NULL,
  "VISUALIZEID" VARCHAR(40 BYTE) NOT NULL,
  "DSPLAYNO" NUMBER(5) NOT NULL,
  "EXTENSIONINFO" VARCHAR(4000 BYTE),
  "TENANT_ID" NUMBER(20) NOT NULL
);
INSERT INTO "MKM_T_DASHBOARD" ("OBJECTID","USERID","VISUALIZEID","DSPLAYNO","EXTENSIONINFO","TENANT_ID") values
  ('9100000001000','66000027','9100000002000',1,null,999999);
INSERT INTO "MKM_T_DASHBOARD" ("OBJECTID","USERID","VISUALIZEID","DSPLAYNO","EXTENSIONINFO","TENANT_ID") values
  ('9100000001001','66000027','9100000002001',2,null,999999);
INSERT INTO "MKM_T_DASHBOARD" ("OBJECTID","USERID","VISUALIZEID","DSPLAYNO","EXTENSIONINFO","TENANT_ID") values
  ('9100000000000','101','9100000000000',1,null,999999);
INSERT INTO "MKM_T_DASHBOARD" ("OBJECTID","USERID","VISUALIZEID","DSPLAYNO","EXTENSIONINFO","TENANT_ID") values
  ('9100000000001','101','9100000001000',2,null,999999);
COMMIT;
ALTER TABLE "MKM_T_DASHBOARD" ADD CONSTRAINT "PK_MKM_T_MKM_T_DASHBOARD" PRIMARY KEY("OBJECTID");
SELECT
  CASE WHEN EXISTS (
      SELECT DISTINCT
          REF_1.USERID AS C0,
          SUBQ_0.C3 AS C1,
          SUBQ_0.C1 AS C2,
          NULL AS C3,
          SUBQ_0.C7 AS C4,
          SUBQ_0.C1 AS C5,
          REF_1.USERID AS C6,
          SUBQ_0.C7 AS C7
        FROM
          MKM_T_DASHBOARD  REF_1
        ORDER BY   SUBQ_0.C3 ASC NULLS FIRST, SUBQ_0.C7 DESC) THEN SUBQ_0.C3 ELSE SUBQ_0.C3 END
     AS C7,
    STDDEV(
      CAST(SUBQ_0.C6 AS NUMBER(20,0))) OVER (PARTITION BY SUBQ_0.C7 ORDER BY SUBQ_0.C1) AS C8
FROM
  (SELECT
        REF_0.EX_FIELD9 AS C0,
        CAST(nullif(REF_0.EX_FIELD3,
          REF_0.PROP_CODE) AS VARCHAR(32)) AS C1,
        REF_0.COMPLEX_FLAG AS C2,
        REF_0.MODIFY_PROLE_TYPE AS C3,
        REF_0.BE_ID AS C4,
        REF_0.LAST_MOD_ORDER_ID AS C6,
        REF_0.DATA_VERSION AS C7
      FROM
        INF_PROD_PROP AS REF_0
      WHERE REF_0.CREATE_PROLE_TYPE LIKE '%')  SUBQ_0
;

SELECT 
    CORR(0,REF_0.BE_ID) OVER () AS C0, 
   (SELECT 
          1
        FROM 
          MKM_T_DASHBOARD AS REF_1
        GROUP BY GROUPING SETS( CUBE('9590-11')), REF_0.BE_ID 
		limit 1) as c1
FROM 
  INF_PROD_PROP AS REF_0;
  
  
SELECT  DISTINCT 
    avg(-2.7) OVER (PARTITION BY ref_1.ADDRESS ORDER BY ref_1.ADDRESS) as c0
from
    STUDENT as ref_1
WHERE 
    EXISTS (SELECT DISTINCT ref_1.SEX as c0 from  SCORE as ref_2) or 
    EXISTS (SELECT DISTINCT ref_1.ADDRESS as c2 from SECTIONS as ref_3 LIMIT 82);

DROP TABLE "INF_PROD_PROP" CASCADE CONSTRAINTS;
DROP TABLE "MKM_T_DASHBOARD" CASCADE CONSTRAINTS;
DROP TABLE "FVT_OBJ_DEFINE_TABLE_FRE1";
DROP TABLE "STUDENT";
DROP TABLE "SCORE";
DROP TABLE "DEPT_MANAGER";
DROP TABLE "DEPT_EMP";
DROP TABLE "SALARIES";
DROP TABLE "TEST";
DROP TABLE "MY_EMPLOYEES";
DROP TABLE "EMPLOYEES";
DROP TABLE "DEPARTMENTS";
--DTS202103220IO2P0P0K00
drop table if exists first_value_t001;
CREATE TABLE  first_value_t001(COL_1 BINARY_BIGINT, COL_19 BINARY(20), COL_20 VARBINARY(20), COL_23 RAW(20));
insert into first_value_t001 values( 1, 1001, 100001, '10000001' );
insert into first_value_t001 values( 2, 1002, 100002, '10000002' );
insert into first_value_t001 values( 3, 1003, 100003, '10000003' );
commit;
SELECT COL_1,COL_19,FIRST_VALUE(COL_19) OVER(partition by COL_1 ORDER BY COL_1) a FROM first_value_t001;
SELECT COL_1,COL_20,FIRST_VALUE(COL_20) OVER(partition by COL_1 ORDER BY COL_1) a FROM first_value_t001;
SELECT COL_1,COL_23,FIRST_VALUE(COL_23) OVER(partition by COL_1 ORDER BY COL_1) a FROM first_value_t001;
drop table if exists first_value_t001;
drop table if exists t_subquery_order_001;
create table t_subquery_order_001(c_int int not null) ;
begin
    for i in 1..500 loop
        insert into t_subquery_order_001 values(i);
    end loop;
end;
/
commit;
select count(1) from ( select max(c_int) over() a1 from t_subquery_order_001  order by a1 desc limit 300);
drop table t_subquery_order_001;