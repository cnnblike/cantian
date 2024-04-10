DROP TABLE IF EXISTS SUB_SEL_T1;
CREATE TABLE SUB_SEL_T1(id DECIMAL(5,2));
INSERT INTO SUB_SEL_T1 VALUES(2.00);
INSERT INTO SUB_SEL_T1 VALUES(2.00);
INSERT INTO SUB_SEL_T1 VALUES(3.00);
INSERT INTO SUB_SEL_T1 VALUES(4.00);
COMMIT;
SELECT ROWID, newtest.* FROM (SELECT ROWNUM xuhao, POWER(id, 2) FROM SUB_SEL_T1) newtest WHERE newtest.xuhao >= 2 AND xuhao <= 3;

DROP TABLE IF EXISTS SUB_SEL_T2;
CREATE TABLE SUB_SEL_T2(id INT,numb DECIMAL(5,2));
INSERT INTO SUB_SEL_T2 VALUES(6,10);
INSERT INTO SUB_SEL_T2 VALUES(7,2);
INSERT INTO SUB_SEL_T2 VALUES(8,6);
INSERT INTO SUB_SEL_T2 VALUES(9,2);
SELECT ((SELECT numb a FROM SUB_SEL_T2 WHERE id=6)+(SELECT numb a FROM SUB_SEL_T2 WHERE id=7));
SELECT ((SELECT numb a FROM SUB_SEL_T2 WHERE id=6)-(SELECT numb a FROM SUB_SEL_T2 WHERE id=7));
SELECT ((SELECT numb a FROM SUB_SEL_T2 WHERE id=6)*(SELECT numb a FROM SUB_SEL_T2 WHERE id=7));
SELECT ((SELECT numb a FROM SUB_SEL_T2 WHERE id=6)/(SELECT numb a FROM SUB_SEL_T2 WHERE id=7));

DROP TABLE IF EXISTS SUB_SEL_T3;
CREATE TABLE SUB_SEL_T3(id INT, val number(25,2), f3 int, f4 int, f5 int);
INSERT INTO SUB_SEL_T3 VALUES(1, 100.33,6,6,6);
INSERT INTO SUB_SEL_T3 VALUES(2, 2.44,7,7,7);
INSERT INTO SUB_SEL_T3 VALUES(3, 3.555,8,8,8);
INSERT INTO SUB_SEL_T3 VALUES(4, 4.555,9,9,9);
COMMIT;

select * from SUB_SEL_T3 where rowid in (select ss3.rowid from SUB_SEL_T3 ss3 where ss3.id < 3);
select * from SUB_SEL_T3 t3 where t3.f5 in (with tmp1 as (select id,numb from SUB_SEL_T2 where id=6) select id from tmp1 where id=t3.f5);

--NOK: T2.ID invalid identifier
select * from SUB_SEL_T2 t2, (select f3 from SUB_SEL_T3 where f3=t2.id) tmp where t2.id=tmp.f3;
--OK
select * from SUB_SEL_T2 t2 where exists(select * from SUB_SEL_T2 t2, (select f3 from SUB_SEL_T3 where f3=t2.id) tmp where t2.id=tmp.f3);

drop table if exists SUB_SEL_T4;
CREATE TABLE SUB_SEL_T4(id2 INT, val2 number(25,2), f3 int, f4 int, f6 int);
--NOK
select * from SUB_SEL_T4, (select f3 from SUB_SEL_T3 where f3=id2) tmp where id2=tmp.f3;
--OK
select * from SUB_SEL_T4 where exists(select * from SUB_SEL_T2 t2, (select f3 from SUB_SEL_T3 where f3=id2) tmp where id2=tmp.f3);

DROP TABLE IF EXISTS SUB_SEL_T1;
DROP TABLE IF EXISTS SUB_SEL_T2;
DROP TABLE IF EXISTS SUB_SEL_T3;
DROP TABLE IF EXISTS SUB_SEL_T4;

--DTS2019011100908
drop table if exists t_join_base_001;
drop table if exists t_join_base_101;
drop table if exists t_join_base_102;
drop table if exists t_join_base_105;

create table t_join_base_001(
id int,
c_int int,
c_real real,
c_float float,
c_decimal decimal,
c_number number,
c_char char(10),
c_vchar varchar(10),
c_vchar2 varchar2(100),
c_clob clob,
c_long clob,
c_blob blob,
c_raw raw(100),
c_date date,
c_timestamp timestamp);
insert into t_join_base_001 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_join_base_001 values(0,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
commit;

create table t_join_base_101 as select * from t_join_base_001;    
create table t_join_base_102 as select * from t_join_base_001;  
create table t_join_base_105 as select * from t_join_base_001;     

CREATE or replace procedure hj_proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
        sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_real+'||i||',c_float+'||i||',c_decimal+'||i||',c_number+'||i||',c_char'||',c_vchar||'||i||',c_vchar2||'||i||',c_clob||'||i||',c_long||'||i||',c_blob'||',c_raw,c_date,c_timestamp from '||tname|| ' where id=1';
        dbe_output.print_line(sqlst);
        execute immediate sqlst;
  END LOOP;
END;
/

exec hj_proc_insert('t_join_base_001',1,100);
exec hj_proc_insert('t_join_base_101',1,10);
exec hj_proc_insert('t_join_base_102',5,15);
exec hj_proc_insert('t_join_base_105',20,30);
commit;

select /*+rule+*/ count(*) from t_join_base_001 t1 join t_join_base_101 t2 on t1.id=t2.id join t_join_base_102 t3 on t1.id=t2.id where exists (select * from (select count(t2.id) from t_join_base_105));

drop table t_join_base_001;
drop table t_join_base_101;
drop table t_join_base_102;
drop table t_join_base_105;

drop table if exists hj_all_datatype_tbl;
create table hj_all_datatype_tbl( c_integer integer, c_varchar varchar(50) );
insert into hj_all_datatype_tbl values(1,'aaaaa');
commit;
update hj_all_datatype_tbl t1 set (c_integer,c_varchar) = (select distinct c1,c2 from (select c_integer c1,c_varchar c2 from hj_all_datatype_tbl union select c_integer c1,c_varchar c2 from hj_all_datatype_tbl where t1.c_integer=c_integer) where rownum=1);
select * from hj_all_datatype_tbl order by 1;
drop table hj_all_datatype_tbl;

--DTS2018110100685
select 1 from dual where 
(
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) 
)
;
select 1 from dual where 
(
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) 
)
;

create table DTS2018110100685 (f1 int);
insert into DTS2018110100685 select 1 from dual where 
(
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) 
)
;
insert into DTS2018110100685 select 1 from dual where 
(
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) 
)
;
drop table DTS2018110100685;
create or replace procedure DTS2018110100685()
as
temp int;
begin
select 1 into temp from dual where 
(
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) 
);
end;
/
create or replace procedure DTS2018110100685()
as
temp int;
begin
select 1 into temp from dual where 
(
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) or
((select 1 from dual) = 1) 
);
end;
/
drop procedure DTS2018110100685;

--DTS2018110711033
drop table if exists tt_DTS2018110711033;
create table tt_DTS2018110711033(f1 varchar(10),f2 varchar(10));
insert into tt_DTS2018110711033(f2) values(123);
insert into tt_DTS2018110711033(f2) values('t');

select 
 1
from(
 select
   f2
 from
   tt_DTS2018110711033
  ) c
where case when 1 = 2 then '1' else c.f2 end like '%t%';

--test stack
drop table if exists t_in_sub_pd1;
drop table if exists t_in_sub_pd2;
create table t_in_sub_pd1(c_varchar varchar(10) not null,c_number number,c_char char(5) not null);
create table t_in_sub_pd2(c_varchar varchar(10) not null,c_number number,c_char char(5) not null);
insert into t_in_sub_pd1 values(1,2,'abc');
insert into t_in_sub_pd2 values(1,2,'abc');
commit;
select * from t_in_sub_pd1 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in 
(select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar 
in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2 where c_varchar in (select c_varchar from t_in_sub_pd2
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
drop table if exists t_in_sub_pd1;
drop table if exists t_in_sub_pd2;

select count(*) from dual where exists(select * from (select * from (select * from (select * from (select * from 
(select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from 
(select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from 
(select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from 
(select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from 
(select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from 
(select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from 
(select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from 
(select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from 
(select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from 
(select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from 
(select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from 
(select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from 
(select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from (select * from 
(select * from (select * from (select * from (select * from (select * from dual))))))))))))))))))))))))))))))))))))))
)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
DROP TABLE IF EXISTS SUB_SEL_T1;
DROP TABLE IF EXISTS SUB_SEL_T2;
DROP TABLE IF EXISTS SUB_SEL_T3;
create table SUB_SEL_T1(f1 int, f2 double, f3 varchar(64), f4 int);
create table SUB_SEL_T2(f1 int, f2 double, f3 varchar(64), f4 int);
create table SUB_SEL_T3(f1 int, f2 double, f3 varchar(64), f4 int);
create index idx_t3_1 on SUB_SEL_T3(f3);
alter system set _OPTIM_HASH_MATERIALIZE = false;
alter system set _OPTIM_HASH_MATERIALIZE = true;
create index idx_t2_1 on SUB_SEL_T2(f3);
DROP TABLE IF EXISTS abcx;
DROP TABLE IF EXISTS temp;
create table abcx(id int, val number, val2 number);
insert into abcx select rownum, sin(rownum), cos(rownum) from dual connect by rownum <= 10;
create table temp (id int, va number, x number);
insert into temp select rownum, sin(rownum), cos(rownum) from dual connect by rownum <= 10;
select * from abcx A where (select nvl(sum(va), 0) from temp B where A.id = B.id and A.val=B.x) <= 5;


drop table if exists cxz_chash_join_local_tbl_001;
drop table if exists cxz_hash_join_interval_tbl_001_1;
drop table if exists cxz_chash_join_local_tbl_001_2;
create table cxz_chash_join_local_tbl_001(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL);
create table cxz_hash_join_interval_tbl_001_1(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL);
create table cxz_chash_join_local_tbl_001_2(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL);

DROP TABLE IF EXISTS "T_CASE_WHEN_BASE_001" CASCADE CONSTRAINTS;
CREATE TABLE "T_CASE_WHEN_BASE_001"
(
  "C_ID" BINARY_INTEGER NOT NULL,
  "C_NUM" NUMBER(12, 2) NOT NULL,
  "C_VCHAR_B" VARCHAR(32 BYTE) NOT NULL,
  "C_VCHAR_C" VARCHAR(3000 CHAR) NOT NULL,
  "C_TS" TIMESTAMP(6) NOT NULL,
  "C_BLOB" BLOB,
  "C_CLOB" CLOB,
  PRIMARY KEY("C_ID")
);
INSERT INTO "T_CASE_WHEN_BASE_001" ("C_ID","C_NUM","C_VCHAR_B","C_VCHAR_C","C_TS","C_BLOB","C_CLOB") values
  (1,1000.56,'AABAR1BARBAR','abc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb41234567890abcdfe','1800-01-01 10:51:47.000000','ABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCA123ABC','abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde12345abcde');
INSERT INTO "T_CASE_WHEN_BASE_001" ("C_ID","C_NUM","C_VCHAR_B","C_VCHAR_C","C_TS","C_BLOB","C_CLOB") values
  (2,1001.56,'AABAR1BARBAR1','abc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb41234567890abcdfe1','1800-01-01 10:51:47.000000','ABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCA123ABC','abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde12345abcde1');
INSERT INTO "T_CASE_WHEN_BASE_001" ("C_ID","C_NUM","C_VCHAR_B","C_VCHAR_C","C_TS","C_BLOB","C_CLOB") values
  (3,1002.56,'AABAR1BARBAR2','abc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb41234567890abcdfe2','1800-01-01 10:51:47.000000','ABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCA123ABC','abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde12345abcde2');
INSERT INTO "T_CASE_WHEN_BASE_001" ("C_ID","C_NUM","C_VCHAR_B","C_VCHAR_C","C_TS","C_BLOB","C_CLOB") values
  (4,1003.56,'AABAR1BARBAR3','abc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb41234567890abcdfe3','1800-01-01 10:51:47.000000','ABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCA123ABC','abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde12345abcde3');
INSERT INTO "T_CASE_WHEN_BASE_001" ("C_ID","C_NUM","C_VCHAR_B","C_VCHAR_C","C_TS","C_BLOB","C_CLOB") values
  (5,1004.56,'AABAR1BARBAR4','abc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb41234567890abcdfe4','1800-01-01 10:51:47.000000','ABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCA123ABC','abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde12345abcde4');
INSERT INTO "T_CASE_WHEN_BASE_001" ("C_ID","C_NUM","C_VCHAR_B","C_VCHAR_C","C_TS","C_BLOB","C_CLOB") values
  (6,1005.56,'AABAR1BARBAR5','abc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb41234567890abcdfe5','1800-01-01 10:51:47.000000','ABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCA123ABC','abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde12345abcde5');
INSERT INTO "T_CASE_WHEN_BASE_001" ("C_ID","C_NUM","C_VCHAR_B","C_VCHAR_C","C_TS","C_BLOB","C_CLOB") values
  (9,1008.56,'AABAR1BARBAR8','abc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb41234567890abcdfe8','1800-01-01 10:51:47.000000','ABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCA123ABC','abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde12345abcde8');
INSERT INTO "T_CASE_WHEN_BASE_001" ("C_ID","C_NUM","C_VCHAR_B","C_VCHAR_C","C_TS","C_BLOB","C_CLOB") values
  (10,1009.56,'AABAR1BARBAR9','abc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb41234567890abcdfe9','1800-01-01 10:51:47.000000','ABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCA123ABC','abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde12345abcde9');
INSERT INTO "T_CASE_WHEN_BASE_001" ("C_ID","C_NUM","C_VCHAR_B","C_VCHAR_C","C_TS","C_BLOB","C_CLOB") values
  (8,1007.56,'AABAR1BARBAR7','abc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb41234567890abcdfe7','1800-01-01 10:51:47.000000','ABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCA123ABC','abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde12345abcde7');
INSERT INTO "T_CASE_WHEN_BASE_001" ("C_ID","C_NUM","C_VCHAR_B","C_VCHAR_C","C_TS","C_BLOB","C_CLOB") values
  (7,1006.56,'AABAR1BARBAR6','abc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb456cdefabc1d2fb41234567890abcdfe6','1800-01-01 10:51:47.000000','ABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCA123ABC','abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde12345abcde6');

select 1, c_id
  from t_case_when_base_001 t1
 group by c_id
having c_id < 100 and (not exists (select 5 c_id
                                     from (select 5 c_id
                                             from t_case_when_base_001,
                                                  t_case_when_base_001) t2
                                    where (t2.c_id = case
                                            when t1.c_id <= 5 then
                                             c_id
                                          end)));
										  
-- subquery rewrite
drop table if exists t_in_sub_pd1;
drop table if exists t_in_sub_pd2;
drop table if exists t_in_sub_pd3;
CREATE TABLE t_in_sub_pd1
(
  C_VARCHAR VARCHAR(10 BYTE) NOT NULL,
  C_NUMBER NUMBER,
  C_CHAR CHAR(5 BYTE) NOT NULL
);
CREATE TABLE t_in_sub_pd2
(
  C_VARCHAR VARCHAR(10 BYTE) NOT NULL,
  C_NUMBER NUMBER,
  C_CHAR CHAR(5 BYTE) NOT NULL
);
CREATE TABLE t_in_sub_pd3
(
  C_VARCHAR VARCHAR(10 BYTE) NOT NULL,
  C_NUMBER NUMBER,
  C_CHAR CHAR(5 BYTE) NOT NULL
);
INSERT INTO T_IN_SUB_PD1 (C_VARCHAR,C_NUMBER,C_CHAR) values  ('1',2,'abc  ');
INSERT INTO T_IN_SUB_PD1 (C_VARCHAR,C_NUMBER,C_CHAR) values  ('2',2,'abc  ');
INSERT INTO T_IN_SUB_PD1 (C_VARCHAR,C_NUMBER,C_CHAR) values  ('3',2,'abc  ');
INSERT INTO T_IN_SUB_PD1 (C_VARCHAR,C_NUMBER,C_CHAR) values  ('4',2,'abc  ');
INSERT INTO T_IN_SUB_PD1 (C_VARCHAR,C_NUMBER,C_CHAR) values  ('5',2,'abc  ');
INSERT INTO T_IN_SUB_PD1 (C_VARCHAR,C_NUMBER,C_CHAR) values  ('6',2,'abc  ');
INSERT INTO T_IN_SUB_PD1 (C_VARCHAR,C_NUMBER,C_CHAR) values  ('7',2,'abc  ');
INSERT INTO T_IN_SUB_PD1 (C_VARCHAR,C_NUMBER,C_CHAR) values  ('8',2,'abc  ');
INSERT INTO T_IN_SUB_PD1 (C_VARCHAR,C_NUMBER,C_CHAR) values  ('9',2,'abc  ');
INSERT INTO T_IN_SUB_PD2 (C_VARCHAR,C_NUMBER,C_CHAR) values  ('1',2,'abc  ');
INSERT INTO T_IN_SUB_PD2 (C_VARCHAR,C_NUMBER,C_CHAR) values  ('2',2,'abc  ');
INSERT INTO T_IN_SUB_PD2 (C_VARCHAR,C_NUMBER,C_CHAR) values  ('3',2,'abc  ');
INSERT INTO T_IN_SUB_PD3 (C_VARCHAR,C_NUMBER,C_CHAR) values  ('4',2,'abc  ');
INSERT INTO T_IN_SUB_PD3 (C_VARCHAR,C_NUMBER,C_CHAR) values  ('5',2,'abc  ');
INSERT INTO T_IN_SUB_PD3 (C_VARCHAR,C_NUMBER,C_CHAR) values  ('6',2,'abc  ');
COMMIT;
select * from t_in_sub_pd1 where (
c_varchar,c_varchar,c_varchar,c_varchar,c_varchar,c_varchar,c_varchar,c_varchar,c_varchar||c_varchar) 
in (
	(
	select c_varchar,c_varchar,c_varchar,c_varchar,c_varchar,c_varchar,c_varchar,c_varchar,c_varchar from t_in_sub_pd3 
	  where 
    c_varchar in (select c_varchar from t_in_sub_pd2) and length(c_varchar)>0
	)
) order by 1;
drop table t_in_sub_pd1;
drop table t_in_sub_pd2;
drop table t_in_sub_pd3;

drop table if exists test_stack_t1;
create table test_stack_t1(CATEGORY varchar(32), ALARMID varchar(32),ALARMGROUPID varchar(32) , ID int);
select * from test_stack_t1 
WHERE 
(ALARMID=':p2' AND ALARMGROUPID=':p3') OR 
(ALARMID=':p4' AND ALARMGROUPID=':p5') OR
(ALARMID=':p6' AND ALARMGROUPID=':p7') OR
(ALARMID=':p8' AND ALARMGROUPID=':p9') OR
(ALARMID=':p10' AND ALARMGROUPID=':p11') OR
(ALARMID=':p12' AND ALARMGROUPID=':p13') OR
(ALARMID=':p14' AND ALARMGROUPID=':p15') OR
(ALARMID=':p16' AND ALARMGROUPID=':p17') OR
(ALARMID=':p18' AND ALARMGROUPID=':p19') OR
(ALARMID=':p20' AND ALARMGROUPID=':p21') OR
(ALARMID=':p22' AND ALARMGROUPID=':p23') OR
(ALARMID=':p24' AND ALARMGROUPID=':p25') OR
(ALARMID=':p26' AND ALARMGROUPID=':p27') OR
(ALARMID=':p28' AND ALARMGROUPID=':p29') OR
(ALARMID=':p30' AND ALARMGROUPID=':p31') OR
(ALARMID=':p32' AND ALARMGROUPID=':p33') OR
(ALARMID=':p34' AND ALARMGROUPID=':p35') OR
(ALARMID=':p36' AND ALARMGROUPID=':p37') OR
(ALARMID=':p38' AND ALARMGROUPID=':p39') OR
(ALARMID=':p40' AND ALARMGROUPID=':p41') OR
(ALARMID=':p42' AND ALARMGROUPID=':p43') OR
(ALARMID=':p44' AND ALARMGROUPID=':p45') OR
(ALARMID=':p46' AND ALARMGROUPID=':p47') OR
(ALARMID=':p48' AND ALARMGROUPID=':p49') OR
(ALARMID=':p50' AND ALARMGROUPID=':p51') OR
(ALARMID=':p52' AND ALARMGROUPID=':p53') OR
(ALARMID=':p54' AND ALARMGROUPID=':p55') OR
(ALARMID=':p56' AND ALARMGROUPID=':p57') OR
(ALARMID=':p58' AND ALARMGROUPID=':p59') OR
(ALARMID=':p60' AND ALARMGROUPID=':p61') OR
(ALARMID=':p62' AND ALARMGROUPID=':p63') OR
(ALARMID=':p64' AND ALARMGROUPID=':p65') OR
(ALARMID=':p66' AND ALARMGROUPID=':p67') OR
(ALARMID=':p68' AND ALARMGROUPID=':p69') OR
(ALARMID=':p70' AND ALARMGROUPID=':p71') OR
(ALARMID=':p72' AND ALARMGROUPID=':p73') OR
(ALARMID=':p74' AND ALARMGROUPID=':p75') OR
(ALARMID=':p76' AND ALARMGROUPID=':p77') OR
(ALARMID=':p78' AND ALARMGROUPID=':p79') OR
(ALARMID=':p80' AND ALARMGROUPID=':p81') OR
(ALARMID=':p82' AND ALARMGROUPID=':p83') OR
(ALARMID=':p84' AND ALARMGROUPID=':p85') OR
(ALARMID=':p86' AND ALARMGROUPID=':p87') OR
(ALARMID=':p88' AND ALARMGROUPID=':p89') OR
(ALARMID=':p90' AND ALARMGROUPID=':p91') OR
(ALARMID=':p92' AND ALARMGROUPID=':p93') OR
(ALARMID=':p94' AND ALARMGROUPID=':p95') OR
(ALARMID=':p96' AND ALARMGROUPID=':p97') OR
(ALARMID=':p98' AND ALARMGROUPID=':p99') OR
(ALARMID=':p100' AND ALARMGROUPID=':p101') OR
(ALARMID=':p102' AND ALARMGROUPID=':p103') OR
(ALARMID=':p104' AND ALARMGROUPID=':p105') OR
(ALARMID=':p106' AND ALARMGROUPID=':p107') OR
(ALARMID=':p108' AND ALARMGROUPID=':p109') OR
(ALARMID=':p110' AND ALARMGROUPID=':p111') OR
(ALARMID=':p112' AND ALARMGROUPID=':p113') OR
(ALARMID=':p114' AND ALARMGROUPID=':p115') OR
(ALARMID=':p116' AND ALARMGROUPID=':p117') OR
(ALARMID=':p118' AND ALARMGROUPID=':p119') OR
(ALARMID=':p120' AND ALARMGROUPID=':p121') OR
(ALARMID=':p122' AND ALARMGROUPID=':p123') OR
(ALARMID=':p124' AND ALARMGROUPID=':p125') OR
(ALARMID=':p126' AND ALARMGROUPID=':p127') OR
(ALARMID=':p128' AND ALARMGROUPID=':p129') OR
(ALARMID=':p130' AND ALARMGROUPID=':p131') OR
(ALARMID=':p132' AND ALARMGROUPID=':p133') OR
(ALARMID=':p134' AND ALARMGROUPID=':p135') OR
(ALARMID=':p136' AND ALARMGROUPID=':p137') OR
(ALARMID=':p138' AND ALARMGROUPID=':p139') OR
(ALARMID=':p140' AND ALARMGROUPID=':p141') OR
(ALARMID=':p142' AND ALARMGROUPID=':p143') OR
(ALARMID=':p144' AND ALARMGROUPID=':p145') OR
(ALARMID=':p146' AND ALARMGROUPID=':p147') OR
(ALARMID=':p148' AND ALARMGROUPID=':p149') OR
(ALARMID=':p150' AND ALARMGROUPID=':p151') OR
(ALARMID=':p152' AND ALARMGROUPID=':p153') OR
(ALARMID=':p154' AND ALARMGROUPID=':p155') OR
(ALARMID=':p156' AND ALARMGROUPID=':p157') OR
(ALARMID=':p158' AND ALARMGROUPID=':p159') OR
(ALARMID=':p160' AND ALARMGROUPID=':p161') OR
(ALARMID=':p162' AND ALARMGROUPID=':p163') OR
(ALARMID=':p164' AND ALARMGROUPID=':p165') OR
(ALARMID=':p166' AND ALARMGROUPID=':p167') OR
(ALARMID=':p168' AND ALARMGROUPID=':p169') OR
(ALARMID=':p170' AND ALARMGROUPID=':p171') OR
(ALARMID=':p172' AND ALARMGROUPID=':p173') OR
(ALARMID=':p174' AND ALARMGROUPID=':p175') OR
(ALARMID=':p176' AND ALARMGROUPID=':p177') OR
(ALARMID=':p178' AND ALARMGROUPID=':p179') OR
(ALARMID=':p180' AND ALARMGROUPID=':p181') OR
(ALARMID=':p182' AND ALARMGROUPID=':p183') OR
(ALARMID=':p184' AND ALARMGROUPID=':p185') OR
(ALARMID=':p186' AND ALARMGROUPID=':p187') OR
(ALARMID=':p188' AND ALARMGROUPID=':p189') OR
(ALARMID=':p190' AND ALARMGROUPID=':p191') OR
(ALARMID=':p192' AND ALARMGROUPID=':p193') OR
(ALARMID=':p194' AND ALARMGROUPID=':p195') OR
(ALARMID=':p196' AND ALARMGROUPID=':p197') OR
(ALARMID=':p198' AND ALARMGROUPID=':p199') OR
(ALARMID=':p200' AND ALARMGROUPID=':p201') OR
(ALARMID=':p202' AND ALARMGROUPID=':p203') OR
(ALARMID=':p204' AND ALARMGROUPID=':p205') OR
(ALARMID=':p206' AND ALARMGROUPID=':p207') OR
(ALARMID=':p208' AND ALARMGROUPID=':p209') OR
(ALARMID=':p210' AND ALARMGROUPID=':p211') OR
(ALARMID=':p212' AND ALARMGROUPID=':p213') OR
(ALARMID=':p214' AND ALARMGROUPID=':p215') OR
(ALARMID=':p216' AND ALARMGROUPID=':p217') OR
(ALARMID=':p218' AND ALARMGROUPID=':p219') OR
(ALARMID=':p220' AND ALARMGROUPID=':p221') OR
(ALARMID=':p222' AND ALARMGROUPID=':p223') OR
(ALARMID=':p224' AND ALARMGROUPID=':p225') OR
(ALARMID=':p226' AND ALARMGROUPID=':p227') OR
(ALARMID=':p228' AND ALARMGROUPID=':p229') OR
(ALARMID=':p230' AND ALARMGROUPID=':p231') OR
(ALARMID=':p232' AND ALARMGROUPID=':p233') OR
(ALARMID=':p234' AND ALARMGROUPID=':p235') OR
(ALARMID=':p236' AND ALARMGROUPID=':p237') OR
(ALARMID=':p238' AND ALARMGROUPID=':p239') OR
(ALARMID=':p240' AND ALARMGROUPID=':p241') OR
(ALARMID=':p242' AND ALARMGROUPID=':p243') OR
(ALARMID=':p244' AND ALARMGROUPID=':p245') OR
(ALARMID=':p246' AND ALARMGROUPID=':p247') OR
(ALARMID=':p248' AND ALARMGROUPID=':p249') OR
(ALARMID=':p250' AND ALARMGROUPID=':p251') OR
(ALARMID=':p252' AND ALARMGROUPID=':p253') OR
(ALARMID=':p254' AND ALARMGROUPID=':p255') OR
(ALARMID=':p256' AND ALARMGROUPID=':p257') OR
(ALARMID=':p258' AND ALARMGROUPID=':p259') OR
(ALARMID=':p260' AND ALARMGROUPID=':p261') OR
(ALARMID=':p262' AND ALARMGROUPID=':p263') OR
(ALARMID=':p264' AND ALARMGROUPID=':p265') OR
(ALARMID=':p266' AND ALARMGROUPID=':p267') OR
(ALARMID=':p268' AND ALARMGROUPID=':p269') OR
(ALARMID=':p270' AND ALARMGROUPID=':p271') OR
(ALARMID=':p272' AND ALARMGROUPID=':p273') OR
(ALARMID=':p274' AND ALARMGROUPID=':p275') OR
(ALARMID=':p276' AND ALARMGROUPID=':p277') OR
(ALARMID=':p278' AND ALARMGROUPID=':p279') OR
(ALARMID=':p280' AND ALARMGROUPID=':p281') OR
(ALARMID=':p282' AND ALARMGROUPID=':p283') OR
(ALARMID=':p284' AND ALARMGROUPID=':p285') OR
(ALARMID=':p286' AND ALARMGROUPID=':p287') OR
(ALARMID=':p288' AND ALARMGROUPID=':p289') OR
(ALARMID=':p290' AND ALARMGROUPID=':p291') OR
(ALARMID=':p292' AND ALARMGROUPID=':p293') OR
(ALARMID=':p294' AND ALARMGROUPID=':p295') OR
(ALARMID=':p296' AND ALARMGROUPID=':p297') OR
(ALARMID=':p298' AND ALARMGROUPID=':p299') OR
(ALARMID=':p300' AND ALARMGROUPID=':p301') OR
(ALARMID=':p302' AND ALARMGROUPID=':p303') OR
(ALARMID=':p304' AND ALARMGROUPID=':p305') OR
(ALARMID=':p306' AND ALARMGROUPID=':p307') OR
(ALARMID=':p308' AND ALARMGROUPID=':p309') OR
(ALARMID=':p310' AND ALARMGROUPID=':p311') OR
(ALARMID=':p312' AND ALARMGROUPID=':p313') OR
(ALARMID=':p314' AND ALARMGROUPID=':p315') OR
(ALARMID=':p316' AND ALARMGROUPID=':p317') OR
(ALARMID=':p318' AND ALARMGROUPID=':p319') OR
(ALARMID=':p320' AND ALARMGROUPID=':p321') OR
(ALARMID=':p322' AND ALARMGROUPID=':p323') OR
(ALARMID=':p324' AND ALARMGROUPID=':p325') OR
(ALARMID=':p326' AND ALARMGROUPID=':p327') OR
(ALARMID=':p328' AND ALARMGROUPID=':p329') OR
(ALARMID=':p330' AND ALARMGROUPID=':p331') OR
(ALARMID=':p332' AND ALARMGROUPID=':p333') OR
(ALARMID=':p334' AND ALARMGROUPID=':p335') OR
(ALARMID=':p336' AND ALARMGROUPID=':p337') OR
(ALARMID=':p338' AND ALARMGROUPID=':p339') OR
(ALARMID=':p340' AND ALARMGROUPID=':p341') OR
(ALARMID=':p342' AND ALARMGROUPID=':p343') OR
(ALARMID=':p344' AND ALARMGROUPID=':p345') OR
(ALARMID=':p346' AND ALARMGROUPID=':p347') OR
(ALARMID=':p348' AND ALARMGROUPID=':p349') OR
(ALARMID=':p350' AND ALARMGROUPID=':p351') OR
(ALARMID=':p352' AND ALARMGROUPID=':p353') OR
(ALARMID=':p354' AND ALARMGROUPID=':p355') OR
(ALARMID=':p356' AND ALARMGROUPID=':p357') OR
(ALARMID=':p358' AND ALARMGROUPID=':p359') OR
(ALARMID=':p360' AND ALARMGROUPID=':p361') OR
(ALARMID=':p362' AND ALARMGROUPID=':p363') OR
(ALARMID=':p364' AND ALARMGROUPID=':p365') OR
(ALARMID=':p366' AND ALARMGROUPID=':p367') OR
(ALARMID=':p368' AND ALARMGROUPID=':p369') OR
(ALARMID=':p370' AND ALARMGROUPID=':p371') OR
(ALARMID=':p372' AND ALARMGROUPID=':p373') OR
(ALARMID=':p374' AND ALARMGROUPID=':p375') OR
(ALARMID=':p376' AND ALARMGROUPID=':p377') OR
(ALARMID=':p378' AND ALARMGROUPID=':p379') OR
(ALARMID=':p380' AND ALARMGROUPID=':p381') OR
(ALARMID=':p382' AND ALARMGROUPID=':p383') OR
(ALARMID=':p384' AND ALARMGROUPID=':p385') OR
(ALARMID=':p386' AND ALARMGROUPID=':p387') OR
(ALARMID=':p388' AND ALARMGROUPID=':p389') OR
(ALARMID=':p390' AND ALARMGROUPID=':p391') OR
(ALARMID=':p392' AND ALARMGROUPID=':p393') OR
(ALARMID=':p394' AND ALARMGROUPID=':p395') OR
(ALARMID=':p396' AND ALARMGROUPID=':p397') OR
(ALARMID=':p398' AND ALARMGROUPID=':p399') OR
(ALARMID=':p400' AND ALARMGROUPID=':p401') OR
(ALARMID=':p402' AND ALARMGROUPID=':p403') OR
(ALARMID=':p404' AND ALARMGROUPID=':p405') OR
(ALARMID=':p406' AND ALARMGROUPID=':p407') OR
(ALARMID=':p408' AND ALARMGROUPID=':p409') OR
(ALARMID=':p410' AND ALARMGROUPID=':p411') OR
(ALARMID=':p412' AND ALARMGROUPID=':p413') OR
(ALARMID=':p414' AND ALARMGROUPID=':p415') OR
(ALARMID=':p416' AND ALARMGROUPID=':p417') OR
(ALARMID=':p418' AND ALARMGROUPID=':p419') OR
(ALARMID=':p420' AND ALARMGROUPID=':p421') OR
(ALARMID=':p422' AND ALARMGROUPID=':p423') OR
(ALARMID=':p424' AND ALARMGROUPID=':p425') OR
(ALARMID=':p426' AND ALARMGROUPID=':p427') OR
(ALARMID=':p428' AND ALARMGROUPID=':p429') OR
(ALARMID=':p430' AND ALARMGROUPID=':p431') OR
(ALARMID=':p432' AND ALARMGROUPID=':p433') OR
(ALARMID=':p434' AND ALARMGROUPID=':p435') OR
(ALARMID=':p436' AND ALARMGROUPID=':p437') OR
(ALARMID=':p438' AND ALARMGROUPID=':p439') OR
(ALARMID=':p440' AND ALARMGROUPID=':p441') OR
(ALARMID=':p442' AND ALARMGROUPID=':p443') OR
(ALARMID=':p444' AND ALARMGROUPID=':p445') OR
(ALARMID=':p446' AND ALARMGROUPID=':p447') OR
(ALARMID=':p448' AND ALARMGROUPID=':p449') OR
(ALARMID=':p450' AND ALARMGROUPID=':p451') OR
(ALARMID=':p452' AND ALARMGROUPID=':p453') OR
(ALARMID=':p454' AND ALARMGROUPID=':p455') OR
(ALARMID=':p456' AND ALARMGROUPID=':p457') OR
(ALARMID=':p458' AND ALARMGROUPID=':p459') OR
(ALARMID=':p460' AND ALARMGROUPID=':p461') OR
(ALARMID=':p462' AND ALARMGROUPID=':p463') OR
(ALARMID=':p464' AND ALARMGROUPID=':p465') OR
(ALARMID=':p466' AND ALARMGROUPID=':p467') OR
(ALARMID=':p468' AND ALARMGROUPID=':p469') OR
(ALARMID=':p470' AND ALARMGROUPID=':p471') OR
(ALARMID=':p472' AND ALARMGROUPID=':p473') OR
(ALARMID=':p474' AND ALARMGROUPID=':p475') OR
(ALARMID=':p476' AND ALARMGROUPID=':p477') OR
(ALARMID=':p478' AND ALARMGROUPID=':p479') OR
(ALARMID=':p480' AND ALARMGROUPID=':p481') OR
(ALARMID=':p482' AND ALARMGROUPID=':p483') OR
(ALARMID=':p484' AND ALARMGROUPID=':p485') OR
(ALARMID=':p486' AND ALARMGROUPID=':p487') OR
(ALARMID=':p488' AND ALARMGROUPID=':p489') OR
(ALARMID=':p490' AND ALARMGROUPID=':p491') OR
(ALARMID=':p492' AND ALARMGROUPID=':p493') OR
(ALARMID=':p494' AND ALARMGROUPID=':p495') OR
(ALARMID=':p496' AND ALARMGROUPID=':p497') OR
(ALARMID=':p498' AND ALARMGROUPID=':p499') OR
(ALARMID=':p500' AND ALARMGROUPID=':p501') OR
(ALARMID=':p502' AND ALARMGROUPID=':p503') OR
(ALARMID=':p504' AND ALARMGROUPID=':p505') OR
(ALARMID=':p506' AND ALARMGROUPID=':p507') OR
(ALARMID=':p508' AND ALARMGROUPID=':p509') OR
(ALARMID=':p510' AND ALARMGROUPID=':p511') OR
(ALARMID=':p512' AND ALARMGROUPID=':p513') OR
(ALARMID=':p514' AND ALARMGROUPID=':p515') OR
(ALARMID=':p516' AND ALARMGROUPID=':p517') OR
(ALARMID=':p518' AND ALARMGROUPID=':p519') OR
(ALARMID=':p520' AND ALARMGROUPID=':p521') OR
(ALARMID=':p522' AND ALARMGROUPID=':p523') OR
(ALARMID=':p524' AND ALARMGROUPID=':p525') OR
(ALARMID=':p526' AND ALARMGROUPID=':p527') OR
(ALARMID=':p528' AND ALARMGROUPID=':p529') OR
(ALARMID=':p530' AND ALARMGROUPID=':p531') OR
(ALARMID=':p532' AND ALARMGROUPID=':p533') OR
(ALARMID=':p534' AND ALARMGROUPID=':p535') OR
(ALARMID=':p536' AND ALARMGROUPID=':p537') OR
(ALARMID=':p538' AND ALARMGROUPID=':p539') OR
(ALARMID=':p540' AND ALARMGROUPID=':p541') OR
(ALARMID=':p542' AND ALARMGROUPID=':p543') OR
(ALARMID=':p544' AND ALARMGROUPID=':p545') OR
(ALARMID=':p546' AND ALARMGROUPID=':p547') OR
(ALARMID=':p548' AND ALARMGROUPID=':p549') OR
(ALARMID=':p550' AND ALARMGROUPID=':p551') OR
(ALARMID=':p552' AND ALARMGROUPID=':p553') OR
(ALARMID=':p554' AND ALARMGROUPID=':p555') OR
(ALARMID=':p556' AND ALARMGROUPID=':p557') OR
(ALARMID=':p558' AND ALARMGROUPID=':p559') OR
(ALARMID=':p560' AND ALARMGROUPID=':p561') OR
(ALARMID=':p562' AND ALARMGROUPID=':p563') OR
(ALARMID=':p564' AND ALARMGROUPID=':p565') OR
(ALARMID=':p566' AND ALARMGROUPID=':p567') OR
(ALARMID=':p568' AND ALARMGROUPID=':p569') OR
(ALARMID=':p570' AND ALARMGROUPID=':p571') OR
(ALARMID=':p572' AND ALARMGROUPID=':p573') OR
(ALARMID=':p574' AND ALARMGROUPID=':p575') OR
(ALARMID=':p576' AND ALARMGROUPID=':p577') OR
(ALARMID=':p578' AND ALARMGROUPID=':p579') OR
(ALARMID=':p580' AND ALARMGROUPID=':p581') OR
(ALARMID=':p582' AND ALARMGROUPID=':p583') OR
(ALARMID=':p584' AND ALARMGROUPID=':p585') OR
(ALARMID=':p586' AND ALARMGROUPID=':p587') OR
(ALARMID=':p588' AND ALARMGROUPID=':p589') OR
(ALARMID=':p590' AND ALARMGROUPID=':p591') OR
(ALARMID=':p592' AND ALARMGROUPID=':p593') OR
(ALARMID=':p594' AND ALARMGROUPID=':p595') OR
(ALARMID=':p596' AND ALARMGROUPID=':p597') OR
(ALARMID=':p598' AND ALARMGROUPID=':p599') OR
(ALARMID=':p600' AND ALARMGROUPID=':p601') OR
(ALARMID=':p602' AND ALARMGROUPID=':p603') OR
(ALARMID=':p604' AND ALARMGROUPID=':p605') OR
(ALARMID=':p606' AND ALARMGROUPID=':p607') OR
(ALARMID=':p608' AND ALARMGROUPID=':p609') OR
(ALARMID=':p610' AND ALARMGROUPID=':p611') OR
(ALARMID=':p612' AND ALARMGROUPID=':p613') OR
(ALARMID=':p614' AND ALARMGROUPID=':p615') OR
(ALARMID=':p616' AND ALARMGROUPID=':p617') OR
(ALARMID=':p618' AND ALARMGROUPID=':p619') OR
(ALARMID=':p620' AND ALARMGROUPID=':p621') OR
(ALARMID=':p622' AND ALARMGROUPID=':p623') OR
(ALARMID=':p624' AND ALARMGROUPID=':p625') OR
(ALARMID=':p626' AND ALARMGROUPID=':p627') OR
(ALARMID=':p628' AND ALARMGROUPID=':p629') OR
(ALARMID=':p630' AND ALARMGROUPID=':p631') OR
(ALARMID=':p632' AND ALARMGROUPID=':p633') OR
(ALARMID=':p634' AND ALARMGROUPID=':p635') OR
(ALARMID=':p636' AND ALARMGROUPID=':p637') OR
(ALARMID=':p638' AND ALARMGROUPID=':p639') OR
(ALARMID=':p640' AND ALARMGROUPID=':p641') OR
(ALARMID=':p642' AND ALARMGROUPID=':p643') OR
(ALARMID=':p644' AND ALARMGROUPID=':p645') OR
(ALARMID=':p646' AND ALARMGROUPID=':p647') OR
(ALARMID=':p648' AND ALARMGROUPID=':p649') OR
(ALARMID=':p650' AND ALARMGROUPID=':p651') OR
(ALARMID=':p652' AND ALARMGROUPID=':p653') OR
(ALARMID=':p654' AND ALARMGROUPID=':p655') OR
(ALARMID=':p656' AND ALARMGROUPID=':p657') OR
(ALARMID=':p658' AND ALARMGROUPID=':p659') OR
(ALARMID=':p660' AND ALARMGROUPID=':p661') OR
(ALARMID=':p662' AND ALARMGROUPID=':p663') OR
(ALARMID=':p664' AND ALARMGROUPID=':p665') OR
(ALARMID=':p666' AND ALARMGROUPID=':p667') OR
(ALARMID=':p668' AND ALARMGROUPID=':p669') OR
(ALARMID=':p670' AND ALARMGROUPID=':p671') OR
(ALARMID=':p672' AND ALARMGROUPID=':p673') OR
(ALARMID=':p674' AND ALARMGROUPID=':p675') OR
(ALARMID=':p676' AND ALARMGROUPID=':p677') OR
(ALARMID=':p678' AND ALARMGROUPID=':p679') OR
(ALARMID=':p680' AND ALARMGROUPID=':p681') OR
(ALARMID=':p682' AND ALARMGROUPID=':p683') OR
(ALARMID=':p684' AND ALARMGROUPID=':p685') OR
(ALARMID=':p686' AND ALARMGROUPID=':p687') OR
(ALARMID=':p688' AND ALARMGROUPID=':p689') OR
(ALARMID=':p690' AND ALARMGROUPID=':p691') OR
(ALARMID=':p692' AND ALARMGROUPID=':p693') OR
(ALARMID=':p694' AND ALARMGROUPID=':p695') OR
(ALARMID=':p696' AND ALARMGROUPID=':p697') OR
(ALARMID=':p698' AND ALARMGROUPID=':p699') OR
(ALARMID=':p700' AND ALARMGROUPID=':p701') OR
(ALARMID=':p702' AND ALARMGROUPID=':p703') OR
(ALARMID=':p704' AND ALARMGROUPID=':p705') OR
(ALARMID=':p706' AND ALARMGROUPID=':p707') OR
(ALARMID=':p708' AND ALARMGROUPID=':p709') OR
(ALARMID=':p710' AND ALARMGROUPID=':p711') OR
(ALARMID=':p712' AND ALARMGROUPID=':p713') OR
(ALARMID=':p714' AND ALARMGROUPID=':p715') OR
(ALARMID=':p716' AND ALARMGROUPID=':p717') OR
(ALARMID=':p718' AND ALARMGROUPID=':p719') OR
(ALARMID=':p720' AND ALARMGROUPID=':p721') OR
(ALARMID=':p722' AND ALARMGROUPID=':p723') OR
(ALARMID=':p724' AND ALARMGROUPID=':p725') OR
(ALARMID=':p726' AND ALARMGROUPID=':p727') OR
(ALARMID=':p728' AND ALARMGROUPID=':p729') OR
(ALARMID=':p730' AND ALARMGROUPID=':p731') OR
(ALARMID=':p732' AND ALARMGROUPID=':p733') OR
(ALARMID=':p734' AND ALARMGROUPID=':p735') OR
(ALARMID=':p736' AND ALARMGROUPID=':p737') OR
(ALARMID=':p738' AND ALARMGROUPID=':p739') OR
(ALARMID=':p740' AND ALARMGROUPID=':p741') OR
(ALARMID=':p742' AND ALARMGROUPID=':p743') OR
(ALARMID=':p744' AND ALARMGROUPID=':p745') OR
(ALARMID=':p746' AND ALARMGROUPID=':p747') OR
(ALARMID=':p748' AND ALARMGROUPID=':p749') OR
(ALARMID=':p750' AND ALARMGROUPID=':p751') OR
(ALARMID=':p752' AND ALARMGROUPID=':p753') OR
(ALARMID=':p754' AND ALARMGROUPID=':p755') OR
(ALARMID=':p756' AND ALARMGROUPID=':p757') OR
(ALARMID=':p758' AND ALARMGROUPID=':p759') OR
(ALARMID=':p760' AND ALARMGROUPID=':p761') OR
(ALARMID=':p762' AND ALARMGROUPID=':p763') OR
(ALARMID=':p764' AND ALARMGROUPID=':p765') OR
(ALARMID=':p766' AND ALARMGROUPID=':p767') OR
(ALARMID=':p768' AND ALARMGROUPID=':p769') OR
(ALARMID=':p770' AND ALARMGROUPID=':p771') OR
(ALARMID=':p772' AND ALARMGROUPID=':p773') OR
(ALARMID=':p774' AND ALARMGROUPID=':p775') OR
(ALARMID=':p776' AND ALARMGROUPID=':p777') OR
(ALARMID=':p778' AND ALARMGROUPID=':p779') OR
(ALARMID=':p780' AND ALARMGROUPID=':p781') OR
(ALARMID=':p782' AND ALARMGROUPID=':p783') OR
(ALARMID=':p784' AND ALARMGROUPID=':p785') OR
(ALARMID=':p786' AND ALARMGROUPID=':p787') OR
(ALARMID=':p788' AND ALARMGROUPID=':p789') OR
(ALARMID=':p790' AND ALARMGROUPID=':p791') OR
(ALARMID=':p792' AND ALARMGROUPID=':p793') OR
(ALARMID=':p794' AND ALARMGROUPID=':p795') OR
(ALARMID=':p796' AND ALARMGROUPID=':p797') OR
(ALARMID=':p798' AND ALARMGROUPID=':p799') OR
(ALARMID=':p800' AND ALARMGROUPID=':p801') OR
(ALARMID=':p802' AND ALARMGROUPID=':p803') OR
(ALARMID=':p804' AND ALARMGROUPID=':p805') OR
(ALARMID=':p806' AND ALARMGROUPID=':p807') OR
(ALARMID=':p808' AND ALARMGROUPID=':p809') OR
(ALARMID=':p810' AND ALARMGROUPID=':p811') OR
(ALARMID=':p812' AND ALARMGROUPID=':p813') OR
(ALARMID=':p814' AND ALARMGROUPID=':p815') OR
(ALARMID=':p816' AND ALARMGROUPID=':p817') OR
(ALARMID=':p818' AND ALARMGROUPID=':p819') OR
(ALARMID=':p820' AND ALARMGROUPID=':p821') OR
(ALARMID=':p822' AND ALARMGROUPID=':p823') OR
(ALARMID=':p824' AND ALARMGROUPID=':p825') OR
(ALARMID=':p826' AND ALARMGROUPID=':p827') OR
(ALARMID=':p828' AND ALARMGROUPID=':p829') OR
(ALARMID=':p830' AND ALARMGROUPID=':p831') OR
(ALARMID=':p832' AND ALARMGROUPID=':p833') OR
(ALARMID=':p834' AND ALARMGROUPID=':p835') OR
(ALARMID=':p836' AND ALARMGROUPID=':p837') OR
(ALARMID=':p838' AND ALARMGROUPID=':p839') OR
(ALARMID=':p840' AND ALARMGROUPID=':p841') OR
(ALARMID=':p842' AND ALARMGROUPID=':p843') OR
(ALARMID=':p844' AND ALARMGROUPID=':p845') OR
(ALARMID=':p846' AND ALARMGROUPID=':p847') OR
(ALARMID=':p848' AND ALARMGROUPID=':p849') OR
(ALARMID=':p850' AND ALARMGROUPID=':p851') OR
(ALARMID=':p852' AND ALARMGROUPID=':p853') OR
(ALARMID=':p854' AND ALARMGROUPID=':p855') OR
(ALARMID=':p856' AND ALARMGROUPID=':p857') OR
(ALARMID=':p858' AND ALARMGROUPID=':p859') OR
(ALARMID=':p860' AND ALARMGROUPID=':p861') OR
(ALARMID=':p862' AND ALARMGROUPID=':p863') OR
(ALARMID=':p864' AND ALARMGROUPID=':p865') OR
(ALARMID=':p866' AND ALARMGROUPID=':p867') OR
(ALARMID=':p868' AND ALARMGROUPID=':p869') OR
(ALARMID=':p870' AND ALARMGROUPID=':p871') OR
(ALARMID=':p872' AND ALARMGROUPID=':p873') OR
(ALARMID=':p874' AND ALARMGROUPID=':p875') OR
(ALARMID=':p876' AND ALARMGROUPID=':p877') OR
(ALARMID=':p878' AND ALARMGROUPID=':p879') OR
(ALARMID=':p880' AND ALARMGROUPID=':p881') OR
(ALARMID=':p882' AND ALARMGROUPID=':p883') OR
(ALARMID=':p884' AND ALARMGROUPID=':p885') OR
(ALARMID=':p886' AND ALARMGROUPID=':p887') OR
(ALARMID=':p888' AND ALARMGROUPID=':p889') OR
(ALARMID=':p890' AND ALARMGROUPID=':p891') OR
(ALARMID=':p892' AND ALARMGROUPID=':p893') OR
(ALARMID=':p894' AND ALARMGROUPID=':p895') OR
(ALARMID=':p896' AND ALARMGROUPID=':p897') OR
(ALARMID=':p898' AND ALARMGROUPID=':p899') OR
(ALARMID=':p900' AND ALARMGROUPID=':p901') OR
(ALARMID=':p902' AND ALARMGROUPID=':p903') OR
(ALARMID=':p904' AND ALARMGROUPID=':p905') OR
(ALARMID=':p906' AND ALARMGROUPID=':p907') OR
(ALARMID=':p908' AND ALARMGROUPID=':p909') OR
(ALARMID=':p910' AND ALARMGROUPID=':p911') OR
(ALARMID=':p912' AND ALARMGROUPID=':p913') OR
(ALARMID=':p914' AND ALARMGROUPID=':p915') OR
(ALARMID=':p916' AND ALARMGROUPID=':p917') OR
(ALARMID=':p918' AND ALARMGROUPID=':p919') OR
(ALARMID=':p920' AND ALARMGROUPID=':p921') OR
(ALARMID=':p922' AND ALARMGROUPID=':p923') OR
(ALARMID=':p924' AND ALARMGROUPID=':p925') OR
(ALARMID=':p926' AND ALARMGROUPID=':p927') OR
(ALARMID=':p928' AND ALARMGROUPID=':p929') OR
(ALARMID=':p930' AND ALARMGROUPID=':p931') OR
(ALARMID=':p932' AND ALARMGROUPID=':p933') OR
(ALARMID=':p934' AND ALARMGROUPID=':p935') OR
(ALARMID=':p936' AND ALARMGROUPID=':p937') OR
(ALARMID=':p938' AND ALARMGROUPID=':p939') OR
(ALARMID=':p940' AND ALARMGROUPID=':p941') OR
(ALARMID=':p942' AND ALARMGROUPID=':p943') OR
(ALARMID=':p944' AND ALARMGROUPID=':p945') OR
(ALARMID=':p946' AND ALARMGROUPID=':p947') OR
(ALARMID=':p948' AND ALARMGROUPID=':p949') OR
(ALARMID=':p950' AND ALARMGROUPID=':p951') OR
(ALARMID=':p952' AND ALARMGROUPID=':p953') OR
(ALARMID=':p954' AND ALARMGROUPID=':p955') OR
(ALARMID=':p956' AND ALARMGROUPID=':p957') OR
(ALARMID=':p958' AND ALARMGROUPID=':p959') OR
(ALARMID=':p960' AND ALARMGROUPID=':p961') OR
(ALARMID=':p962' AND ALARMGROUPID=':p963') OR
(ALARMID=':p964' AND ALARMGROUPID=':p965') OR
(ALARMID=':p966' AND ALARMGROUPID=':p967') OR
(ALARMID=':p968' AND ALARMGROUPID=':p969') OR
(ALARMID=':p970' AND ALARMGROUPID=':p971') OR
(ALARMID=':p972' AND ALARMGROUPID=':p973') OR
(ALARMID=':p974' AND ALARMGROUPID=':p975') OR
(ALARMID=':p976' AND ALARMGROUPID=':p977') OR
(ALARMID=':p978' AND ALARMGROUPID=':p979') OR
(ALARMID=':p980' AND ALARMGROUPID=':p981') OR
(ALARMID=':p982' AND ALARMGROUPID=':p983') OR
(ALARMID=':p984' AND ALARMGROUPID=':p985') OR
(ALARMID=':p986' AND ALARMGROUPID=':p987') OR
(ALARMID=':p988' AND ALARMGROUPID=':p989') OR
(ALARMID=':p990' AND ALARMGROUPID=':p991') OR
(ALARMID=':p992' AND ALARMGROUPID=':p993') OR
(ALARMID=':p994' AND ALARMGROUPID=':p995') OR
(ALARMID=':p996' AND ALARMGROUPID=':p997') OR
(ALARMID=':p998' AND ALARMGROUPID=':p999') OR
(ALARMID=':p1000' AND ALARMGROUPID=':p1001') OR
(ALARMID=':p1002' AND ALARMGROUPID=':p1003') OR
(ALARMID=':p1004' AND ALARMGROUPID=':p1005') OR
(ALARMID=':p1006' AND ALARMGROUPID=':p1007') OR
(ALARMID=':p1008' AND ALARMGROUPID=':p1009') OR
(ALARMID=':p1010' AND ALARMGROUPID=':p1011') OR
(ALARMID=':p1012' AND ALARMGROUPID=':p1013') OR
(ALARMID=':p1014' AND ALARMGROUPID=':p1015') OR
(ALARMID=':p1016' AND ALARMGROUPID=':p1017') OR
(ALARMID=':p1018' AND ALARMGROUPID=':p1019') OR
(ALARMID=':p1020' AND ALARMGROUPID=':p1021') OR
(ALARMID=':p1022' AND ALARMGROUPID=':p1023') OR
(ALARMID=':p1024' AND ALARMGROUPID=':p1025') OR
(ALARMID=':p1026' AND ALARMGROUPID=':p1027') OR
(ALARMID=':p1028' AND ALARMGROUPID=':p1029') OR
(ALARMID=':p1030' AND ALARMGROUPID=':p1031') OR
(ALARMID=':p1032' AND ALARMGROUPID=':p1033') OR
(ALARMID=':p1034' AND ALARMGROUPID=':p1035') OR
(ALARMID=':p1036' AND ALARMGROUPID=':p1037') OR
(ALARMID=':p1038' AND ALARMGROUPID=':p1039') OR
(ALARMID=':p1040' AND ALARMGROUPID=':p1041') OR
(ALARMID=':p1042' AND ALARMGROUPID=':p1043') OR
(ALARMID=':p1044' AND ALARMGROUPID=':p1045') OR
(ALARMID=':p1046' AND ALARMGROUPID=':p1047') OR
(ALARMID=':p1048' AND ALARMGROUPID=':p1049') OR
(ALARMID=':p1050' AND ALARMGROUPID=':p1051') OR
(ALARMID=':p1052' AND ALARMGROUPID=':p1053') OR
(ALARMID=':p1054' AND ALARMGROUPID=':p1055') OR
(ALARMID=':p1056' AND ALARMGROUPID=':p1057') OR
(ALARMID=':p1058' AND ALARMGROUPID=':p1059') OR
(ALARMID=':p1060' AND ALARMGROUPID=':p1061') OR
(ALARMID=':p1062' AND ALARMGROUPID=':p1063') OR
(ALARMID=':p1064' AND ALARMGROUPID=':p1065') OR
(ALARMID=':p1066' AND ALARMGROUPID=':p1067') OR
(ALARMID=':p1068' AND ALARMGROUPID=':p1069') OR
(ALARMID=':p1070' AND ALARMGROUPID=':p1071') OR
(ALARMID=':p1072' AND ALARMGROUPID=':p1073') OR
(ALARMID=':p1074' AND ALARMGROUPID=':p1075') OR
(ALARMID=':p1076' AND ALARMGROUPID=':p1077') OR
(ALARMID=':p1078' AND ALARMGROUPID=':p1079') OR
(ALARMID=':p1080' AND ALARMGROUPID=':p1081') OR
(ALARMID=':p1082' AND ALARMGROUPID=':p1083') OR
(ALARMID=':p1084' AND ALARMGROUPID=':p1085') OR
(ALARMID=':p1086' AND ALARMGROUPID=':p1087') OR
(ALARMID=':p1088' AND ALARMGROUPID=':p1089') OR
(ALARMID=':p1090' AND ALARMGROUPID=':p1091') OR
(ALARMID=':p1092' AND ALARMGROUPID=':p1093') OR
(ALARMID=':p1094' AND ALARMGROUPID=':p1095') OR
(ALARMID=':p1096' AND ALARMGROUPID=':p1097') OR
(ALARMID=':p1098' AND ALARMGROUPID=':p1099') OR
(ALARMID=':p1100' AND ALARMGROUPID=':p1101') OR
(ALARMID=':p1102' AND ALARMGROUPID=':p1103') OR
(ALARMID=':p1104' AND ALARMGROUPID=':p1105') OR
(ALARMID=':p1106' AND ALARMGROUPID=':p1107') OR
(ALARMID=':p1108' AND ALARMGROUPID=':p1109') OR
(ALARMID=':p1110' AND ALARMGROUPID=':p1111') OR
(ALARMID=':p1112' AND ALARMGROUPID=':p1113') OR
(ALARMID=':p1114' AND ALARMGROUPID=':p1115') OR
(ALARMID=':p1116' AND ALARMGROUPID=':p1117') OR
(ALARMID=':p1118' AND ALARMGROUPID=':p1119') OR
(ALARMID=':p1120' AND ALARMGROUPID=':p1121') OR
(ALARMID=':p1122' AND ALARMGROUPID=':p1123') OR
(ALARMID=':p1124' AND ALARMGROUPID=':p1125') OR
(ALARMID=':p1126' AND ALARMGROUPID=':p1127') OR
(ALARMID=':p1128' AND ALARMGROUPID=':p1129') OR
(ALARMID=':p1130' AND ALARMGROUPID=':p1131') OR
(ALARMID=':p1132' AND ALARMGROUPID=':p1133') OR
(ALARMID=':p1134' AND ALARMGROUPID=':p1135') OR
(ALARMID=':p1136' AND ALARMGROUPID=':p1137') OR
(ALARMID=':p1138' AND ALARMGROUPID=':p1139') OR
(ALARMID=':p1140' AND ALARMGROUPID=':p1141') OR
(ALARMID=':p1142' AND ALARMGROUPID=':p1143') OR
(ALARMID=':p1144' AND ALARMGROUPID=':p1145') OR
(ALARMID=':p1146' AND ALARMGROUPID=':p1147') OR
(ALARMID=':p1148' AND ALARMGROUPID=':p1149') OR
(ALARMID=':p1150' AND ALARMGROUPID=':p1151') OR
(ALARMID=':p1152' AND ALARMGROUPID=':p1153') OR
(ALARMID=':p1154' AND ALARMGROUPID=':p1155') OR
(ALARMID=':p1156' AND ALARMGROUPID=':p1157') OR
(ALARMID=':p1158' AND ALARMGROUPID=':p1159') OR
(ALARMID=':p1160' AND ALARMGROUPID=':p1161') OR
(ALARMID=':p1162' AND ALARMGROUPID=':p1163') OR
(ALARMID=':p1164' AND ALARMGROUPID=':p1165') OR
(ALARMID=':p1166' AND ALARMGROUPID=':p1167') OR
(ALARMID=':p1168' AND ALARMGROUPID=':p1169') OR
(ALARMID=':p1170' AND ALARMGROUPID=':p1171') OR
(ALARMID=':p1172' AND ALARMGROUPID=':p1173') OR
(ALARMID=':p1174' AND ALARMGROUPID=':p1175') OR
(ALARMID=':p1176' AND ALARMGROUPID=':p1177') OR
(ALARMID=':p1178' AND ALARMGROUPID=':p1179') OR
(ALARMID=':p1180' AND ALARMGROUPID=':p1181') OR
(ALARMID=':p1182' AND ALARMGROUPID=':p1183') OR
(ALARMID=':p1184' AND ALARMGROUPID=':p1185') OR
(ALARMID=':p1186' AND ALARMGROUPID=':p1187') OR
(ALARMID=':p1188' AND ALARMGROUPID=':p1189') OR
(ALARMID=':p1190' AND ALARMGROUPID=':p1191') OR
(ALARMID=':p1192' AND ALARMGROUPID=':p1193') OR
(ALARMID=':p1194' AND ALARMGROUPID=':p1195') OR
(ALARMID=':p1196' AND ALARMGROUPID=':p1197') OR
(ALARMID=':p1198' AND ALARMGROUPID=':p1199') OR
(ALARMID=':p1200' AND ALARMGROUPID=':p1201') OR
(ALARMID=':p1202' AND ALARMGROUPID=':p1203') OR
(ALARMID=':p1204' AND ALARMGROUPID=':p1205') OR
(ALARMID=':p1206' AND ALARMGROUPID=':p1207') OR
(ALARMID=':p1208' AND ALARMGROUPID=':p1209') OR
(ALARMID=':p1210' AND ALARMGROUPID=':p1211') OR
(ALARMID=':p1212' AND ALARMGROUPID=':p1213') OR
(ALARMID=':p1214' AND ALARMGROUPID=':p1215') OR
(ALARMID=':p1216' AND ALARMGROUPID=':p1217') OR
(ALARMID=':p1218' AND ALARMGROUPID=':p1219') OR
(ALARMID=':p1220' AND ALARMGROUPID=':p1221') OR
(ALARMID=':p1222' AND ALARMGROUPID=':p1223') OR
(ALARMID=':p1224' AND ALARMGROUPID=':p1225') OR
(ALARMID=':p1226' AND ALARMGROUPID=':p1227') OR
(ALARMID=':p1228' AND ALARMGROUPID=':p1229') OR
(ALARMID=':p1230' AND ALARMGROUPID=':p1231') OR
(ALARMID=':p1232' AND ALARMGROUPID=':p1233') OR
(ALARMID=':p1234' AND ALARMGROUPID=':p1235') OR
(ALARMID=':p1236' AND ALARMGROUPID=':p1237') OR
(ALARMID=':p1238' AND ALARMGROUPID=':p1239') OR
(ALARMID=':p1240' AND ALARMGROUPID=':p1241') OR
(ALARMID=':p1242' AND ALARMGROUPID=':p1243') OR
(ALARMID=':p1244' AND ALARMGROUPID=':p1245') OR
(ALARMID=':p1246' AND ALARMGROUPID=':p1247') OR
(ALARMID=':p1248' AND ALARMGROUPID=':p1249') OR
(ALARMID=':p1250' AND ALARMGROUPID=':p1251') OR
(ALARMID=':p1252' AND ALARMGROUPID=':p1253') OR
(ALARMID=':p1254' AND ALARMGROUPID=':p1255') OR
(ALARMID=':p1256' AND ALARMGROUPID=':p1257') OR
(ALARMID=':p1258' AND ALARMGROUPID=':p1259') OR
(ALARMID=':p1260' AND ALARMGROUPID=':p1261') OR
(ALARMID=':p1262' AND ALARMGROUPID=':p1263') OR
(ALARMID=':p1264' AND ALARMGROUPID=':p1265') OR
(ALARMID=':p1266' AND ALARMGROUPID=':p1267') OR
(ALARMID=':p1268' AND ALARMGROUPID=':p1269') OR
(ALARMID=':p1270' AND ALARMGROUPID=':p1271') OR
(ALARMID=':p1272' AND ALARMGROUPID=':p1273') OR
(ALARMID=':p1274' AND ALARMGROUPID=':p1275') OR
(ALARMID=':p1276' AND ALARMGROUPID=':p1277') OR
(ALARMID=':p1278' AND ALARMGROUPID=':p1279') OR
(ALARMID=':p1280' AND ALARMGROUPID=':p1281') OR
(ALARMID=':p1282' AND ALARMGROUPID=':p1283') OR
(ALARMID=':p1284' AND ALARMGROUPID=':p1285') OR
(ALARMID=':p1286' AND ALARMGROUPID=':p1287') OR
(ALARMID=':p1288' AND ALARMGROUPID=':p1289') OR
(ALARMID=':p1290' AND ALARMGROUPID=':p1291') OR
(ALARMID=':p1292' AND ALARMGROUPID=':p1293') OR
(ALARMID=':p1294' AND ALARMGROUPID=':p1295') OR
(ALARMID=':p1296' AND ALARMGROUPID=':p1297') OR
(ALARMID=':p1298' AND ALARMGROUPID=':p1299') OR
(ALARMID=':p1300' AND ALARMGROUPID=':p1301') OR
(ALARMID=':p1302' AND ALARMGROUPID=':p1303') OR
(ALARMID=':p1304' AND ALARMGROUPID=':p1305') OR
(ALARMID=':p1306' AND ALARMGROUPID=':p1307') OR
(ALARMID=':p1308' AND ALARMGROUPID=':p1309') OR
(ALARMID=':p1310' AND ALARMGROUPID=':p1311') OR
(ALARMID=':p1312' AND ALARMGROUPID=':p1313') OR
(ALARMID=':p1314' AND ALARMGROUPID=':p1315') OR
(ALARMID=':p1316' AND ALARMGROUPID=':p1317') OR
(ALARMID=':p1318' AND ALARMGROUPID=':p1319') OR
(ALARMID=':p1320' AND ALARMGROUPID=':p1321') OR
(ALARMID=':p1322' AND ALARMGROUPID=':p1323') OR
(ALARMID=':p1324' AND ALARMGROUPID=':p1325') OR
(ALARMID=':p1326' AND ALARMGROUPID=':p1327') OR
(ALARMID=':p1328' AND ALARMGROUPID=':p1329') OR
(ALARMID=':p1330' AND ALARMGROUPID=':p1331') OR
(ALARMID=':p1332' AND ALARMGROUPID=':p1333') OR
(ALARMID=':p1334' AND ALARMGROUPID=':p1335') OR
(ALARMID=':p1336' AND ALARMGROUPID=':p1337') OR
(ALARMID=':p1338' AND ALARMGROUPID=':p1339') OR
(ALARMID=':p1340' AND ALARMGROUPID=':p1341') OR
(ALARMID=':p1342' AND ALARMGROUPID=':p1343') OR
(ALARMID=':p1344' AND ALARMGROUPID=':p1345') OR
(ALARMID=':p1346' AND ALARMGROUPID=':p1347') OR
(ALARMID=':p1348' AND ALARMGROUPID=':p1349') OR
(ALARMID=':p1350' AND ALARMGROUPID=':p1351') OR
(ALARMID=':p1352' AND ALARMGROUPID=':p1353') OR
(ALARMID=':p1354' AND ALARMGROUPID=':p1355') OR
(ALARMID=':p1356' AND ALARMGROUPID=':p1357') OR
(ALARMID=':p1358' AND ALARMGROUPID=':p1359') OR
(ALARMID=':p1360' AND ALARMGROUPID=':p1361') OR
(ALARMID=':p1362' AND ALARMGROUPID=':p1363') OR
(ALARMID=':p1364' AND ALARMGROUPID=':p1365') OR
(ALARMID=':p1366' AND ALARMGROUPID=':p1367') OR
(ALARMID=':p1368' AND ALARMGROUPID=':p1369') OR
(ALARMID=':p1370' AND ALARMGROUPID=':p1371') OR
(ALARMID=':p1372' AND ALARMGROUPID=':p1373') OR
(ALARMID=':p1374' AND ALARMGROUPID=':p1375') OR
(ALARMID=':p1376' AND ALARMGROUPID=':p1377') OR
(ALARMID=':p1378' AND ALARMGROUPID=':p1379') OR
(ALARMID=':p1380' AND ALARMGROUPID=':p1381') OR
(ALARMID=':p1382' AND ALARMGROUPID=':p1383') OR
(ALARMID=':p1384' AND ALARMGROUPID=':p1385') OR
(ALARMID=':p1386' AND ALARMGROUPID=':p1387') OR
(ALARMID=':p1388' AND ALARMGROUPID=':p1389') OR
(ALARMID=':p1390' AND ALARMGROUPID=':p1391') OR
(ALARMID=':p1392' AND ALARMGROUPID=':p1393') OR
(ALARMID=':p1394' AND ALARMGROUPID=':p1395') OR
(ALARMID=':p1396' AND ALARMGROUPID=':p1397') OR
(ALARMID=':p1398' AND ALARMGROUPID=':p1399') OR
(ALARMID=':p1400' AND ALARMGROUPID=':p1401') OR
(ALARMID=':p1402' AND ALARMGROUPID=':p1403') OR
(ALARMID=':p1404' AND ALARMGROUPID=':p1405') OR
(ALARMID=':p1406' AND ALARMGROUPID=':p1407') OR
(ALARMID=':p1408' AND ALARMGROUPID=':p1409') OR
(ALARMID=':p1410' AND ALARMGROUPID=':p1411') OR
(ALARMID=':p1412' AND ALARMGROUPID=':p1413') OR
(ALARMID=':p1414' AND ALARMGROUPID=':p1415') OR
(ALARMID=':p1416' AND ALARMGROUPID=':p1417') OR
(ALARMID=':p1418' AND ALARMGROUPID=':p1419') OR
(ALARMID=':p1420' AND ALARMGROUPID=':p1421') OR
(ALARMID=':p1422' AND ALARMGROUPID=':p1423') OR
(ALARMID=':p1424' AND ALARMGROUPID=':p1425') OR
(ALARMID=':p1426' AND ALARMGROUPID=':p1427') OR
(ALARMID=':p1428' AND ALARMGROUPID=':p1429') OR
(ALARMID=':p1430' AND ALARMGROUPID=':p1431') OR
(ALARMID=':p1432' AND ALARMGROUPID=':p1433') OR
(ALARMID=':p1434' AND ALARMGROUPID=':p1435') OR
(ALARMID=':p1436' AND ALARMGROUPID=':p1437') OR
(ALARMID=':p1438' AND ALARMGROUPID=':p1439') OR
(ALARMID=':p1440' AND ALARMGROUPID=':p1441') OR
(ALARMID=':p1442' AND ALARMGROUPID=':p1443') OR
(ALARMID=':p1444' AND ALARMGROUPID=':p1445') OR
(ALARMID=':p1446' AND ALARMGROUPID=':p1447') OR
(ALARMID=':p1448' AND ALARMGROUPID=':p1449') OR
(ALARMID=':p1450' AND ALARMGROUPID=':p1451') OR
(ALARMID=':p1452' AND ALARMGROUPID=':p1453') OR
(ALARMID=':p1454' AND ALARMGROUPID=':p1455') OR
(ALARMID=':p1456' AND ALARMGROUPID=':p1457') OR
(ALARMID=':p1458' AND ALARMGROUPID=':p1459') OR
(ALARMID=':p1460' AND ALARMGROUPID=':p1461') OR
(ALARMID=':p1462' AND ALARMGROUPID=':p1463') OR
(ALARMID=':p1464' AND ALARMGROUPID=':p1465') OR
(ALARMID=':p1466' AND ALARMGROUPID=':p1467') OR
(ALARMID=':p1468' AND ALARMGROUPID=':p1469') OR
(ALARMID=':p1470' AND ALARMGROUPID=':p1471') OR
(ALARMID=':p1472' AND ALARMGROUPID=':p1473') OR
(ALARMID=':p1474' AND ALARMGROUPID=':p1475') OR
(ALARMID=':p1476' AND ALARMGROUPID=':p1477') OR
(ALARMID=':p1478' AND ALARMGROUPID=':p1479') OR
(ALARMID=':p1480' AND ALARMGROUPID=':p1481') OR
(ALARMID=':p1482' AND ALARMGROUPID=':p1483') OR
(ALARMID=':p1484' AND ALARMGROUPID=':p1485') OR
(ALARMID=':p1486' AND ALARMGROUPID=':p1487') OR
(ALARMID=':p1488' AND ALARMGROUPID=':p1489') OR
(ALARMID=':p1490' AND ALARMGROUPID=':p1491') OR
(ALARMID=':p1492' AND ALARMGROUPID=':p1493') OR
(ALARMID=':p1494' AND ALARMGROUPID=':p1495') OR
(ALARMID=':p1496' AND ALARMGROUPID=':p1497') OR
(ALARMID=':p1498' AND ALARMGROUPID=':p1499') OR
(ALARMID=':p1500' AND ALARMGROUPID=':p1501') OR
(ALARMID=':p1502' AND ALARMGROUPID=':p1503') OR
(ALARMID=':p1504' AND ALARMGROUPID=':p1505') OR
(ALARMID=':p1506' AND ALARMGROUPID=':p1507') OR
(ALARMID=':p1508' AND ALARMGROUPID=':p1509') OR
(ALARMID=':p1510' AND ALARMGROUPID=':p1511') OR
(ALARMID=':p1512' AND ALARMGROUPID=':p1513') OR
(ALARMID=':p1514' AND ALARMGROUPID=':p1515') OR
(ALARMID=':p1516' AND ALARMGROUPID=':p1517') OR
(ALARMID=':p1518' AND ALARMGROUPID=':p1519') OR
(ALARMID=':p1520' AND ALARMGROUPID=':p1521') OR
(ALARMID=':p1522' AND ALARMGROUPID=':p1523') OR
(ALARMID=':p1524' AND ALARMGROUPID=':p1525') OR
(ALARMID=':p1526' AND ALARMGROUPID=':p1527') OR
(ALARMID=':p1528' AND ALARMGROUPID=':p1529') OR
(ALARMID=':p1530' AND ALARMGROUPID=':p1531') OR
(ALARMID=':p1532' AND ALARMGROUPID=':p1533') OR
(ALARMID=':p1534' AND ALARMGROUPID=':p1535') OR
(ALARMID=':p1536' AND ALARMGROUPID=':p1537') OR
(ALARMID=':p1538' AND ALARMGROUPID=':p1539') OR
(ALARMID=':p1540' AND ALARMGROUPID=':p1541') OR
(ALARMID=':p1542' AND ALARMGROUPID=':p1543') OR
(ALARMID=':p1544' AND ALARMGROUPID=':p1545') OR
(ALARMID=':p1546' AND ALARMGROUPID=':p1547') OR
(ALARMID=':p1548' AND ALARMGROUPID=':p1549') OR
(ALARMID=':p1550' AND ALARMGROUPID=':p1551') OR
(ALARMID=':p1552' AND ALARMGROUPID=':p1553') OR
(ALARMID=':p1554' AND ALARMGROUPID=':p1555') OR
(ALARMID=':p1556' AND ALARMGROUPID=':p1557') OR
(ALARMID=':p1558' AND ALARMGROUPID=':p1559') OR
(ALARMID=':p1560' AND ALARMGROUPID=':p1561') OR
(ALARMID=':p1562' AND ALARMGROUPID=':p1563') OR
(ALARMID=':p1564' AND ALARMGROUPID=':p1565') OR
(ALARMID=':p1566' AND ALARMGROUPID=':p1567') OR
(ALARMID=':p1568' AND ALARMGROUPID=':p1569') OR
(ALARMID=':p1570' AND ALARMGROUPID=':p1571') OR
(ALARMID=':p1572' AND ALARMGROUPID=':p1573') OR
(ALARMID=':p1574' AND ALARMGROUPID=':p1575') OR
(ALARMID=':p1576' AND ALARMGROUPID=':p1577') OR
(ALARMID=':p1578' AND ALARMGROUPID=':p1579') OR
(ALARMID=':p1580' AND ALARMGROUPID=':p1581') OR
(ALARMID=':p1582' AND ALARMGROUPID=':p1583') OR
(ALARMID=':p1584' AND ALARMGROUPID=':p1585') OR
(ALARMID=':p1586' AND ALARMGROUPID=':p1587') OR
(ALARMID=':p1588' AND ALARMGROUPID=':p1589') OR
(ALARMID=':p1590' AND ALARMGROUPID=':p1591') OR
(ALARMID=':p1592' AND ALARMGROUPID=':p1593') OR
(ALARMID=':p1594' AND ALARMGROUPID=':p1595') OR
(ALARMID=':p1596' AND ALARMGROUPID=':p1597') OR
(ALARMID=':p1598' AND ALARMGROUPID=':p1599') OR
(ALARMID=':p1600' AND ALARMGROUPID=':p1601') OR
(ALARMID=':p1602' AND ALARMGROUPID=':p1603') OR
(ALARMID=':p1604' AND ALARMGROUPID=':p1605') OR
(ALARMID=':p1606' AND ALARMGROUPID=':p1607') OR
(ALARMID=':p1608' AND ALARMGROUPID=':p1609') OR
(ALARMID=':p1610' AND ALARMGROUPID=':p1611') OR
(ALARMID=':p1612' AND ALARMGROUPID=':p1613') OR
(ALARMID=':p1614' AND ALARMGROUPID=':p1615') OR
(ALARMID=':p1616' AND ALARMGROUPID=':p1617') OR
(ALARMID=':p1618' AND ALARMGROUPID=':p1619') OR
(ALARMID=':p1620' AND ALARMGROUPID=':p1621') OR
(ALARMID=':p1622' AND ALARMGROUPID=':p1623') OR
(ALARMID=':p1624' AND ALARMGROUPID=':p1625') OR
(ALARMID=':p1626' AND ALARMGROUPID=':p1627') OR
(ALARMID=':p1628' AND ALARMGROUPID=':p1629') OR
(ALARMID=':p1630' AND ALARMGROUPID=':p1631') OR
(ALARMID=':p1632' AND ALARMGROUPID=':p1633') OR
(ALARMID=':p1634' AND ALARMGROUPID=':p1635') OR
(ALARMID=':p1636' AND ALARMGROUPID=':p1637') OR
(ALARMID=':p1638' AND ALARMGROUPID=':p1639') OR
(ALARMID=':p1640' AND ALARMGROUPID=':p1641') OR
(ALARMID=':p1642' AND ALARMGROUPID=':p1643') OR
(ALARMID=':p1644' AND ALARMGROUPID=':p1645') OR
(ALARMID=':p1646' AND ALARMGROUPID=':p1647') OR
(ALARMID=':p1648' AND ALARMGROUPID=':p1649') OR
(ALARMID=':p1650' AND ALARMGROUPID=':p1651') OR
(ALARMID=':p1652' AND ALARMGROUPID=':p1653') OR
(ALARMID=':p1654' AND ALARMGROUPID=':p1655') OR
(ALARMID=':p1656' AND ALARMGROUPID=':p1657') OR
(ALARMID=':p1658' AND ALARMGROUPID=':p1659') OR
(ALARMID=':p1660' AND ALARMGROUPID=':p1661') OR
(ALARMID=':p1662' AND ALARMGROUPID=':p1663') OR
(ALARMID=':p1664' AND ALARMGROUPID=':p1665') OR
(ALARMID=':p1666' AND ALARMGROUPID=':p1667') OR
(ALARMID=':p1668' AND ALARMGROUPID=':p1669') OR
(ALARMID=':p1670' AND ALARMGROUPID=':p1671') OR
(ALARMID=':p1672' AND ALARMGROUPID=':p1673') OR
(ALARMID=':p1674' AND ALARMGROUPID=':p1675') OR
(ALARMID=':p1676' AND ALARMGROUPID=':p1677') OR
(ALARMID=':p1678' AND ALARMGROUPID=':p1679') OR
(ALARMID=':p1680' AND ALARMGROUPID=':p1681') OR
(ALARMID=':p1682' AND ALARMGROUPID=':p1683') OR
(ALARMID=':p1684' AND ALARMGROUPID=':p1685') OR
(ALARMID=':p1686' AND ALARMGROUPID=':p1687') OR
(ALARMID=':p1688' AND ALARMGROUPID=':p1689') OR
(ALARMID=':p1690' AND ALARMGROUPID=':p1691') OR
(ALARMID=':p1692' AND ALARMGROUPID=':p1693') OR
(ALARMID=':p1694' AND ALARMGROUPID=':p1695') OR
(ALARMID=':p1696' AND ALARMGROUPID=':p1697') OR
(ALARMID=':p1698' AND ALARMGROUPID=':p1699') OR
(ALARMID=':p1700' AND ALARMGROUPID=':p1701') OR
(ALARMID=':p1702' AND ALARMGROUPID=':p1703') OR
(ALARMID=':p1704' AND ALARMGROUPID=':p1705') OR
(ALARMID=':p1706' AND ALARMGROUPID=':p1707') OR
(ALARMID=':p1708' AND ALARMGROUPID=':p1709') OR
(ALARMID=':p1710' AND ALARMGROUPID=':p1711') OR
(ALARMID=':p1712' AND ALARMGROUPID=':p1713') OR
(ALARMID=':p1714' AND ALARMGROUPID=':p1715') OR
(ALARMID=':p1716' AND ALARMGROUPID=':p1717') OR
(ALARMID=':p1718' AND ALARMGROUPID=':p1719') OR
(ALARMID=':p1720' AND ALARMGROUPID=':p1721') OR
(ALARMID=':p1722' AND ALARMGROUPID=':p1723') OR
(ALARMID=':p1724' AND ALARMGROUPID=':p1725') OR
(ALARMID=':p1726' AND ALARMGROUPID=':p1727') OR
(ALARMID=':p1728' AND ALARMGROUPID=':p1729') OR
(ALARMID=':p1730' AND ALARMGROUPID=':p1731') OR
(ALARMID=':p1732' AND ALARMGROUPID=':p1733') OR
(ALARMID=':p1734' AND ALARMGROUPID=':p1735') OR
(ALARMID=':p1736' AND ALARMGROUPID=':p1737') OR
(ALARMID=':p1738' AND ALARMGROUPID=':p1739') OR
(ALARMID=':p1740' AND ALARMGROUPID=':p1741') OR
(ALARMID=':p1742' AND ALARMGROUPID=':p1743') OR
(ALARMID=':p1744' AND ALARMGROUPID=':p1745') OR
(ALARMID=':p1746' AND ALARMGROUPID=':p1747') OR
(ALARMID=':p1748' AND ALARMGROUPID=':p1749') OR
(ALARMID=':p1750' AND ALARMGROUPID=':p1751') OR
(ALARMID=':p1752' AND ALARMGROUPID=':p1753') OR
(ALARMID=':p1754' AND ALARMGROUPID=':p1755') OR
(ALARMID=':p1756' AND ALARMGROUPID=':p1757') OR
(ALARMID=':p1758' AND ALARMGROUPID=':p1759') OR
(ALARMID=':p1760' AND ALARMGROUPID=':p1761') OR
(ALARMID=':p1762' AND ALARMGROUPID=':p1763') OR
(ALARMID=':p1764' AND ALARMGROUPID=':p1765') OR
(ALARMID=':p1766' AND ALARMGROUPID=':p1767') OR
(ALARMID=':p1768' AND ALARMGROUPID=':p1769') OR
(ALARMID=':p1770' AND ALARMGROUPID=':p1771') OR
(ALARMID=':p1772' AND ALARMGROUPID=':p1773') OR
(ALARMID=':p1774' AND ALARMGROUPID=':p1775') OR
(ALARMID=':p1776' AND ALARMGROUPID=':p1777') OR
(ALARMID=':p1778' AND ALARMGROUPID=':p1779') OR
(ALARMID=':p1780' AND ALARMGROUPID=':p1781') OR
(ALARMID=':p1782' AND ALARMGROUPID=':p1783') OR
(ALARMID=':p1784' AND ALARMGROUPID=':p1785') OR
(ALARMID=':p1786' AND ALARMGROUPID=':p1787') OR
(ALARMID=':p1788' AND ALARMGROUPID=':p1789') OR
(ALARMID=':p1790' AND ALARMGROUPID=':p1791') OR
(ALARMID=':p1792' AND ALARMGROUPID=':p1793') OR
(ALARMID=':p1794' AND ALARMGROUPID=':p1795') OR
(ALARMID=':p1796' AND ALARMGROUPID=':p1797') OR
(ALARMID=':p1798' AND ALARMGROUPID=':p1799') OR
(ALARMID=':p1800' AND ALARMGROUPID=':p1801') OR
(ALARMID=':p1802' AND ALARMGROUPID=':p1803') OR
(ALARMID=':p1804' AND ALARMGROUPID=':p1805') OR
(ALARMID=':p1806' AND ALARMGROUPID=':p1807') OR
(ALARMID=':p1808' AND ALARMGROUPID=':p1809') OR
(ALARMID=':p1810' AND ALARMGROUPID=':p1811') OR
(ALARMID=':p1812' AND ALARMGROUPID=':p1813') OR
(ALARMID=':p1814' AND ALARMGROUPID=':p1815') OR
(ALARMID=':p1816' AND ALARMGROUPID=':p1817') OR
(ALARMID=':p1818' AND ALARMGROUPID=':p1819') OR
(ALARMID=':p1820' AND ALARMGROUPID=':p1821') OR
(ALARMID=':p1822' AND ALARMGROUPID=':p1823') OR
(ALARMID=':p1824' AND ALARMGROUPID=':p1825') OR
(ALARMID=':p1826' AND ALARMGROUPID=':p1827') OR
(ALARMID=':p1828' AND ALARMGROUPID=':p1829') OR
(ALARMID=':p1830' AND ALARMGROUPID=':p1831') OR
(ALARMID=':p1832' AND ALARMGROUPID=':p1833') OR
(ALARMID=':p1834' AND ALARMGROUPID=':p1835') OR
(ALARMID=':p1836' AND ALARMGROUPID=':p1837') OR
(ALARMID=':p1838' AND ALARMGROUPID=':p1839') OR
(ALARMID=':p1840' AND ALARMGROUPID=':p1841') OR
(ALARMID=':p1842' AND ALARMGROUPID=':p1843') OR
(ALARMID=':p1844' AND ALARMGROUPID=':p1845') OR
(ALARMID=':p1846' AND ALARMGROUPID=':p1847') OR
(ALARMID=':p1848' AND ALARMGROUPID=':p1849') OR
(ALARMID=':p1850' AND ALARMGROUPID=':p1851') OR
(ALARMID=':p1852' AND ALARMGROUPID=':p1853') OR
(ALARMID=':p1854' AND ALARMGROUPID=':p1855') OR
(ALARMID=':p1856' AND ALARMGROUPID=':p1857') OR
(ALARMID=':p1858' AND ALARMGROUPID=':p1859') OR
(ALARMID=':p1860' AND ALARMGROUPID=':p1861') OR
(ALARMID=':p1862' AND ALARMGROUPID=':p1863') OR
(ALARMID=':p1864' AND ALARMGROUPID=':p1865') OR
(ALARMID=':p1866' AND ALARMGROUPID=':p1867') OR
(ALARMID=':p1868' AND ALARMGROUPID=':p1869') OR
(ALARMID=':p1870' AND ALARMGROUPID=':p1871') OR
(ALARMID=':p1872' AND ALARMGROUPID=':p1873') OR
(ALARMID=':p1874' AND ALARMGROUPID=':p1875') OR
(ALARMID=':p1876' AND ALARMGROUPID=':p1877') OR
(ALARMID=':p1878' AND ALARMGROUPID=':p1879') OR
(ALARMID=':p1880' AND ALARMGROUPID=':p1881') OR
(ALARMID=':p1882' AND ALARMGROUPID=':p1883') OR
(ALARMID=':p1884' AND ALARMGROUPID=':p1885') OR
(ALARMID=':p1886' AND ALARMGROUPID=':p1887') OR
(ALARMID=':p1888' AND ALARMGROUPID=':p1889') OR
(ALARMID=':p1890' AND ALARMGROUPID=':p1891') OR
(ALARMID=':p1892' AND ALARMGROUPID=':p1893') OR
(ALARMID=':p1894' AND ALARMGROUPID=':p1895') OR
(ALARMID=':p1896' AND ALARMGROUPID=':p1897') OR
(ALARMID=':p1898' AND ALARMGROUPID=':p1899') OR
(ALARMID=':p1900' AND ALARMGROUPID=':p1901') OR
(ALARMID=':p1902' AND ALARMGROUPID=':p1903') OR
(ALARMID=':p1904' AND ALARMGROUPID=':p1905') OR
(ALARMID=':p1906' AND ALARMGROUPID=':p1907') OR
(ALARMID=':p1908' AND ALARMGROUPID=':p1909') OR
(ALARMID=':p1910' AND ALARMGROUPID=':p1911') OR
(ALARMID=':p1912' AND ALARMGROUPID=':p1913') OR
(ALARMID=':p1914' AND ALARMGROUPID=':p1915') OR
(ALARMID=':p1916' AND ALARMGROUPID=':p1917') OR
(ALARMID=':p1918' AND ALARMGROUPID=':p1919') OR
(ALARMID=':p1920' AND ALARMGROUPID=':p1921') OR
(ALARMID=':p1922' AND ALARMGROUPID=':p1923') OR
(ALARMID=':p1924' AND ALARMGROUPID=':p1925') OR
(ALARMID=':p1926' AND ALARMGROUPID=':p1927') OR
(ALARMID=':p1928' AND ALARMGROUPID=':p1929') OR
(ALARMID=':p1930' AND ALARMGROUPID=':p1931') OR
(ALARMID=':p1932' AND ALARMGROUPID=':p1933') OR
(ALARMID=':p1934' AND ALARMGROUPID=':p1935') OR
(ALARMID=':p1936' AND ALARMGROUPID=':p1937') OR
(ALARMID=':p1938' AND ALARMGROUPID=':p1939') OR
(ALARMID=':p1940' AND ALARMGROUPID=':p1941') OR
(ALARMID=':p1942' AND ALARMGROUPID=':p1943') OR
(ALARMID=':p1944' AND ALARMGROUPID=':p1945') OR
(ALARMID=':p1946' AND ALARMGROUPID=':p1947') OR
(ALARMID=':p1948' AND ALARMGROUPID=':p1949') OR
(ALARMID=':p1950' AND ALARMGROUPID=':p1951') OR
(ALARMID=':p1952' AND ALARMGROUPID=':p1953') OR
(ALARMID=':p1954' AND ALARMGROUPID=':p1955') OR
(ALARMID=':p1956' AND ALARMGROUPID=':p1957') OR
(ALARMID=':p1958' AND ALARMGROUPID=':p1959') OR
(ALARMID=':p1960' AND ALARMGROUPID=':p1961') OR
(ALARMID=':p1962' AND ALARMGROUPID=':p1963') OR
(ALARMID=':p1964' AND ALARMGROUPID=':p1965') OR
(ALARMID=':p1966' AND ALARMGROUPID=':p1967') OR
(ALARMID=':p1968' AND ALARMGROUPID=':p1969') OR
(ALARMID=':p1970' AND ALARMGROUPID=':p1971') OR
(ALARMID=':p1972' AND ALARMGROUPID=':p1973') OR
(ALARMID=':p1974' AND ALARMGROUPID=':p1975') OR
(ALARMID=':p1976' AND ALARMGROUPID=':p1977') OR
(ALARMID=':p1978' AND ALARMGROUPID=':p1979') OR
(ALARMID=':p1980' AND ALARMGROUPID=':p1981') OR
(ALARMID=':p1982' AND ALARMGROUPID=':p1983') OR
(ALARMID=':p1984' AND ALARMGROUPID=':p1985') OR
(ALARMID=':p1986' AND ALARMGROUPID=':p1987') OR
(ALARMID=':p1988' AND ALARMGROUPID=':p1989') OR
(ALARMID=':p1990' AND ALARMGROUPID=':p1991') OR
(ALARMID=':p1992' AND ALARMGROUPID=':p1993') OR
(ALARMID=':p1994' AND ALARMGROUPID=':p1995') OR
(ALARMID=':p1996' AND ALARMGROUPID=':p1997') OR
(ALARMID=':p1998' AND ALARMGROUPID=':p1999') OR
(ALARMID=':p2000' AND ALARMGROUPID=':p2001') OR
(ALARMID=':p2002' AND ALARMGROUPID=':p2003') OR
(ALARMID=':p2004' AND ALARMGROUPID=':p2005') OR
(ALARMID=':p2006' AND ALARMGROUPID=':p2007') OR
(ALARMID=':p2008' AND ALARMGROUPID=':p2009') OR
(ALARMID=':p2010' AND ALARMGROUPID=':p2011') OR
(ALARMID=':p2012' AND ALARMGROUPID=':p2013') OR
(ALARMID=':p2014' AND ALARMGROUPID=':p2015') OR
(ALARMID=':p2016' AND ALARMGROUPID=':p2017') OR
(ALARMID=':p2018' AND ALARMGROUPID=':p2019') OR
(ALARMID=':p2020' AND ALARMGROUPID=':p2021') OR
(ALARMID=':p2022' AND ALARMGROUPID=':p2023') OR
(ALARMID=':p2024' AND ALARMGROUPID=':p2025') OR
(ALARMID=':p2026' AND ALARMGROUPID=':p2027') OR
(ALARMID=':p2028' AND ALARMGROUPID=':p2029') OR
(ALARMID=':p2030' AND ALARMGROUPID=':p2031') OR
(ALARMID=':p2032' AND ALARMGROUPID=':p2033') OR
(ALARMID=':p2034' AND ALARMGROUPID=':p2035') OR
(ALARMID=':p2036' AND ALARMGROUPID=':p2037') OR
(ALARMID=':p2038' AND ALARMGROUPID=':p2039') OR
(ALARMID=':p2040' AND ALARMGROUPID=':p2041') OR
(ALARMID=':p2042' AND ALARMGROUPID=':p2043') OR
(ALARMID=':p2044' AND ALARMGROUPID=':p2045') OR
(ALARMID=':p2046' AND ALARMGROUPID=':p2047') OR
(ALARMID=':p2048' AND ALARMGROUPID=':p2049') OR
(ALARMID=':p2050' AND ALARMGROUPID=':p2051') OR
(ALARMID=':p2052' AND ALARMGROUPID=':p2053') OR
(ALARMID=':p2054' AND ALARMGROUPID=':p2055') OR
(ALARMID=':p2056' AND ALARMGROUPID=':p2057') OR
(ALARMID=':p2058' AND ALARMGROUPID=':p2059') OR
(ALARMID=':p2060' AND ALARMGROUPID=':p2061') OR
(ALARMID=':p2062' AND ALARMGROUPID=':p2063') OR
(ALARMID=':p2064' AND ALARMGROUPID=':p2065') OR
(ALARMID=':p2066' AND ALARMGROUPID=':p2067') OR
(ALARMID=':p2068' AND ALARMGROUPID=':p2069') OR
(ALARMID=':p2070' AND ALARMGROUPID=':p2071') OR
(ALARMID=':p2072' AND ALARMGROUPID=':p2073') OR
(ALARMID=':p2074' AND ALARMGROUPID=':p2075') OR
(ALARMID=':p2076' AND ALARMGROUPID=':p2077') OR
(ALARMID=':p2078' AND ALARMGROUPID=':p2079') OR
(ALARMID=':p2080' AND ALARMGROUPID=':p2081') OR
(ALARMID=':p2082' AND ALARMGROUPID=':p2083') OR
(ALARMID=':p2084' AND ALARMGROUPID=':p2085') OR
(ALARMID=':p2086' AND ALARMGROUPID=':p2087') OR
(ALARMID=':p2088' AND ALARMGROUPID=':p2089') OR
(ALARMID=':p2090' AND ALARMGROUPID=':p2091') OR
(ALARMID=':p2092' AND ALARMGROUPID=':p2093') OR
(ALARMID=':p2094' AND ALARMGROUPID=':p2095') OR
(ALARMID=':p2096' AND ALARMGROUPID=':p2097') OR
(ALARMID=':p2098' AND ALARMGROUPID=':p2099') OR
(ALARMID=':p2100' AND ALARMGROUPID=':p2101') OR
(ALARMID=':p2102' AND ALARMGROUPID=':p2103') OR
(ALARMID=':p2104' AND ALARMGROUPID=':p2105') OR
(ALARMID=':p2106' AND ALARMGROUPID=':p2107') OR
(ALARMID=':p2108' AND ALARMGROUPID=':p2109') OR
(ALARMID=':p2110' AND ALARMGROUPID=':p2111') OR
(ALARMID=':p2112' AND ALARMGROUPID=':p2113') OR
(ALARMID=':p2114' AND ALARMGROUPID=':p2115') OR
(ALARMID=':p2116' AND ALARMGROUPID=':p2117') OR
(ALARMID=':p2118' AND ALARMGROUPID=':p2119') OR
(ALARMID=':p2120' AND ALARMGROUPID=':p2121') OR
(ALARMID=':p2122' AND ALARMGROUPID=':p2123') OR
(ALARMID=':p2124' AND ALARMGROUPID=':p2125') OR
(ALARMID=':p2126' AND ALARMGROUPID=':p2127') OR
(ALARMID=':p2128' AND ALARMGROUPID=':p2129') OR
(ALARMID=':p2130' AND ALARMGROUPID=':p2131') OR
(ALARMID=':p2132' AND ALARMGROUPID=':p2133') OR
(ALARMID=':p2134' AND ALARMGROUPID=':p2135') OR
(ALARMID=':p2136' AND ALARMGROUPID=':p2137') OR
(ALARMID=':p2138' AND ALARMGROUPID=':p2139') OR
(ALARMID=':p2140' AND ALARMGROUPID=':p2141') OR
(ALARMID=':p2142' AND ALARMGROUPID=':p2143') OR
(ALARMID=':p2144' AND ALARMGROUPID=':p2145') OR
(ALARMID=':p2146' AND ALARMGROUPID=':p2147') OR
(ALARMID=':p2148' AND ALARMGROUPID=':p2149') OR
(ALARMID=':p2150' AND ALARMGROUPID=':p2151') OR
(ALARMID=':p2152' AND ALARMGROUPID=':p2153') OR
(ALARMID=':p2154' AND ALARMGROUPID=':p2155') OR
(ALARMID=':p2156' AND ALARMGROUPID=':p2157') OR
(ALARMID=':p2158' AND ALARMGROUPID=':p2159') OR
(ALARMID=':p2160' AND ALARMGROUPID=':p2161') OR
(ALARMID=':p2162' AND ALARMGROUPID=':p2163') OR
(ALARMID=':p2164' AND ALARMGROUPID=':p2165') OR
(ALARMID=':p2166' AND ALARMGROUPID=':p2167') OR
(ALARMID=':p2168' AND ALARMGROUPID=':p2169') OR
(ALARMID=':p2170' AND ALARMGROUPID=':p2171') OR
(ALARMID=':p2172' AND ALARMGROUPID=':p2173') OR
(ALARMID=':p2174' AND ALARMGROUPID=':p2175') OR
(ALARMID=':p2176' AND ALARMGROUPID=':p2177') OR
(ALARMID=':p2178' AND ALARMGROUPID=':p2179') OR
(ALARMID=':p2180' AND ALARMGROUPID=':p2181') OR
(ALARMID=':p2182' AND ALARMGROUPID=':p2183') OR
(ALARMID=':p2184' AND ALARMGROUPID=':p2185') OR
(ALARMID=':p2186' AND ALARMGROUPID=':p2187') OR
(ALARMID=':p2188' AND ALARMGROUPID=':p2189') OR
(ALARMID=':p2190' AND ALARMGROUPID=':p2191') OR
(ALARMID=':p2192' AND ALARMGROUPID=':p2193') OR
(ALARMID=':p2194' AND ALARMGROUPID=':p2195') OR
(ALARMID=':p2196' AND ALARMGROUPID=':p2197') OR
(ALARMID=':p2198' AND ALARMGROUPID=':p2199') OR
(ALARMID=':p2200' AND ALARMGROUPID=':p2201') OR
(ALARMID=':p2202' AND ALARMGROUPID=':p2203') OR
(ALARMID=':p2204' AND ALARMGROUPID=':p2205') OR
(ALARMID=':p2206' AND ALARMGROUPID=':p2207') OR
(ALARMID=':p2208' AND ALARMGROUPID=':p2209') OR
(ALARMID=':p2210' AND ALARMGROUPID=':p2211') OR
(ALARMID=':p2212' AND ALARMGROUPID=':p2213') OR
(ALARMID=':p2214' AND ALARMGROUPID=':p2215') OR
(ALARMID=':p2216' AND ALARMGROUPID=':p2217') OR
(ALARMID=':p2218' AND ALARMGROUPID=':p2219') OR
(ALARMID=':p2220' AND ALARMGROUPID=':p2221') OR
(ALARMID=':p2222' AND ALARMGROUPID=':p2223') OR
(ALARMID=':p2224' AND ALARMGROUPID=':p2225') OR
(ALARMID=':p2226' AND ALARMGROUPID=':p2227') OR
(ALARMID=':p2228' AND ALARMGROUPID=':p2229') OR
(ALARMID=':p2230' AND ALARMGROUPID=':p2231') OR
(ALARMID=':p2232' AND ALARMGROUPID=':p2233') OR
(ALARMID=':p2234' AND ALARMGROUPID=':p2235') OR
(ALARMID=':p2236' AND ALARMGROUPID=':p2237') OR
(ALARMID=':p2238' AND ALARMGROUPID=':p2239') OR
(ALARMID=':p2240' AND ALARMGROUPID=':p2241') OR
(ALARMID=':p2242' AND ALARMGROUPID=':p2243') OR
(ALARMID=':p2244' AND ALARMGROUPID=':p2245') OR
(ALARMID=':p2246' AND ALARMGROUPID=':p2247') OR
(ALARMID=':p2248' AND ALARMGROUPID=':p2249') OR
(ALARMID=':p2250' AND ALARMGROUPID=':p2251') OR
(ALARMID=':p2252' AND ALARMGROUPID=':p2253') OR
(ALARMID=':p2254' AND ALARMGROUPID=':p2255') OR
(ALARMID=':p2256' AND ALARMGROUPID=':p2257') OR
(ALARMID=':p2258' AND ALARMGROUPID=':p2259') OR
(ALARMID=':p2260' AND ALARMGROUPID=':p2261') OR
(ALARMID=':p2262' AND ALARMGROUPID=':p2263') OR
(ALARMID=':p2264' AND ALARMGROUPID=':p2265') OR
(ALARMID=':p2266' AND ALARMGROUPID=':p2267') OR
(ALARMID=':p2268' AND ALARMGROUPID=':p2269') OR
(ALARMID=':p2270' AND ALARMGROUPID=':p2271') OR
(ALARMID=':p2272' AND ALARMGROUPID=':p2273') OR
(ALARMID=':p2274' AND ALARMGROUPID=':p2275') OR
(ALARMID=':p2276' AND ALARMGROUPID=':p2277') OR
(ALARMID=':p2278' AND ALARMGROUPID=':p2279') OR
(ALARMID=':p2280' AND ALARMGROUPID=':p2281') OR
(ALARMID=':p2282' AND ALARMGROUPID=':p2283') OR
(ALARMID=':p2284' AND ALARMGROUPID=':p2285') OR
(ALARMID=':p2286' AND ALARMGROUPID=':p2287') OR
(ALARMID=':p2288' AND ALARMGROUPID=':p2289') OR
(ALARMID=':p2290' AND ALARMGROUPID=':p2291') OR
(ALARMID=':p2292' AND ALARMGROUPID=':p2293') OR
(ALARMID=':p2294' AND ALARMGROUPID=':p2295') OR
(ALARMID=':p2296' AND ALARMGROUPID=':p2297') OR
(ALARMID=':p2298' AND ALARMGROUPID=':p2299') OR
(ALARMID=':p2300' AND ALARMGROUPID=':p2301') OR
(ALARMID=':p2302' AND ALARMGROUPID=':p2303') OR
(ALARMID=':p2304' AND ALARMGROUPID=':p2305') OR
(ALARMID=':p2306' AND ALARMGROUPID=':p2307') OR
(ALARMID=':p2308' AND ALARMGROUPID=':p2309') OR
(ALARMID=':p2310' AND ALARMGROUPID=':p2311') OR
(ALARMID=':p2312' AND ALARMGROUPID=':p2313') OR
(ALARMID=':p2314' AND ALARMGROUPID=':p2315') OR
(ALARMID=':p2316' AND ALARMGROUPID=':p2317') OR
(ALARMID=':p2318' AND ALARMGROUPID=':p2319') OR
(ALARMID=':p2320' AND ALARMGROUPID=':p2321') OR
(ALARMID=':p2322' AND ALARMGROUPID=':p2323') OR
(ALARMID=':p2324' AND ALARMGROUPID=':p2325') OR
(ALARMID=':p2326' AND ALARMGROUPID=':p2327') OR
(ALARMID=':p2328' AND ALARMGROUPID=':p2329') OR
(ALARMID=':p2330' AND ALARMGROUPID=':p2331') OR
(ALARMID=':p2332' AND ALARMGROUPID=':p2333') OR
(ALARMID=':p2334' AND ALARMGROUPID=':p2335') OR
(ALARMID=':p2336' AND ALARMGROUPID=':p2337') OR
(ALARMID=':p2338' AND ALARMGROUPID=':p2339') OR
(ALARMID=':p2340' AND ALARMGROUPID=':p2341') OR
(ALARMID=':p2342' AND ALARMGROUPID=':p2343') OR
(ALARMID=':p2344' AND ALARMGROUPID=':p2345') OR
(ALARMID=':p2346' AND ALARMGROUPID=':p2347') OR
(ALARMID=':p2348' AND ALARMGROUPID=':p2349') OR
(ALARMID=':p2350' AND ALARMGROUPID=':p2351') OR
(ALARMID=':p2352' AND ALARMGROUPID=':p2353') OR
(ALARMID=':p2354' AND ALARMGROUPID=':p2355') OR
(ALARMID=':p2356' AND ALARMGROUPID=':p2357') OR
(ALARMID=':p2358' AND ALARMGROUPID=':p2359') OR
(ALARMID=':p2360' AND ALARMGROUPID=':p2361') OR
(ALARMID=':p2362' AND ALARMGROUPID=':p2363') OR
(ALARMID=':p2364' AND ALARMGROUPID=':p2365') OR
(ALARMID=':p2366' AND ALARMGROUPID=':p2367') OR
(ALARMID=':p2368' AND ALARMGROUPID=':p2369') OR
(ALARMID=':p2370' AND ALARMGROUPID=':p2371') OR
(ALARMID=':p2372' AND ALARMGROUPID=':p2373') OR
(ALARMID=':p2374' AND ALARMGROUPID=':p2375') OR
(ALARMID=':p2376' AND ALARMGROUPID=':p2377') OR
(ALARMID=':p2378' AND ALARMGROUPID=':p2379') OR
(ALARMID=':p2380' AND ALARMGROUPID=':p2381') OR
(ALARMID=':p2382' AND ALARMGROUPID=':p2383') OR
(ALARMID=':p2384' AND ALARMGROUPID=':p2385') OR
(ALARMID=':p2386' AND ALARMGROUPID=':p2387') OR
(ALARMID=':p2388' AND ALARMGROUPID=':p2389') OR
(ALARMID=':p2390' AND ALARMGROUPID=':p2391') OR
(ALARMID=':p2392' AND ALARMGROUPID=':p2393') OR
(ALARMID=':p2394' AND ALARMGROUPID=':p2395') OR
(ALARMID=':p2396' AND ALARMGROUPID=':p2397') OR
(ALARMID=':p2398' AND ALARMGROUPID=':p2399') OR
(ALARMID=':p2400' AND ALARMGROUPID=':p2401') OR
(ALARMID=':p2402' AND ALARMGROUPID=':p2403') OR
(ALARMID=':p2404' AND ALARMGROUPID=':p2405') OR
(ALARMID=':p2406' AND ALARMGROUPID=':p2407') OR
(ALARMID=':p2408' AND ALARMGROUPID=':p2409') OR
(ALARMID=':p2410' AND ALARMGROUPID=':p2411') OR
(ALARMID=':p2412' AND ALARMGROUPID=':p2413') OR
(ALARMID=':p2414' AND ALARMGROUPID=':p2415') OR
(ALARMID=':p2416' AND ALARMGROUPID=':p2417') OR
(ALARMID=':p2418' AND ALARMGROUPID=':p2419') OR
(ALARMID=':p2420' AND ALARMGROUPID=':p2421') OR
(ALARMID=':p2422' AND ALARMGROUPID=':p2423') OR
(ALARMID=':p2424' AND ALARMGROUPID=':p2425') OR
(ALARMID=':p2426' AND ALARMGROUPID=':p2427') OR
(ALARMID=':p2428' AND ALARMGROUPID=':p2429') OR
(ALARMID=':p2430' AND ALARMGROUPID=':p2431') OR
(ALARMID=':p2432' AND ALARMGROUPID=':p2433') OR
(ALARMID=':p2434' AND ALARMGROUPID=':p2435') OR
(ALARMID=':p2436' AND ALARMGROUPID=':p2437') OR
(ALARMID=':p2438' AND ALARMGROUPID=':p2439') OR
(ALARMID=':p2440' AND ALARMGROUPID=':p2441') OR
(ALARMID=':p2442' AND ALARMGROUPID=':p2443') OR
(ALARMID=':p2444' AND ALARMGROUPID=':p2445') OR
(ALARMID=':p2446' AND ALARMGROUPID=':p2447') OR
(ALARMID=':p2448' AND ALARMGROUPID=':p2449') OR
(ALARMID=':p2450' AND ALARMGROUPID=':p2451') OR
(ALARMID=':p2452' AND ALARMGROUPID=':p2453') OR
(ALARMID=':p2454' AND ALARMGROUPID=':p2455') OR
(ALARMID=':p2456' AND ALARMGROUPID=':p2457') OR
(ALARMID=':p2458' AND ALARMGROUPID=':p2459') OR
(ALARMID=':p2460' AND ALARMGROUPID=':p2461') OR
(ALARMID=':p2462' AND ALARMGROUPID=':p2463') OR
(ALARMID=':p2464' AND ALARMGROUPID=':p2465') OR
(ALARMID=':p2466' AND ALARMGROUPID=':p2467') OR
(ALARMID=':p2468' AND ALARMGROUPID=':p2469') OR
(ALARMID=':p2470' AND ALARMGROUPID=':p2471') OR
(ALARMID=':p2472' AND ALARMGROUPID=':p2473') OR
(ALARMID=':p2474' AND ALARMGROUPID=':p2475') OR
(ALARMID=':p2476' AND ALARMGROUPID=':p2477') OR
(ALARMID=':p2478' AND ALARMGROUPID=':p2479') OR
(ALARMID=':p2480' AND ALARMGROUPID=':p2481') OR
(ALARMID=':p2482' AND ALARMGROUPID=':p2483') OR
(ALARMID=':p2484' AND ALARMGROUPID=':p2485') OR
(ALARMID=':p2486' AND ALARMGROUPID=':p2487') OR
(ALARMID=':p2488' AND ALARMGROUPID=':p2489') OR
(ALARMID=':p2490' AND ALARMGROUPID=':p2491') OR
(ALARMID=':p2492' AND ALARMGROUPID=':p2493') OR
(ALARMID=':p2494' AND ALARMGROUPID=':p2495') OR
(ALARMID=':p2496' AND ALARMGROUPID=':p2497') OR
(ALARMID=':p2498' AND ALARMGROUPID=':p2499') OR
(ALARMID=':p2500' AND ALARMGROUPID=':p2501') OR
(ALARMID=':p2502' AND ALARMGROUPID=':p2503') OR
(ALARMID=':p2504' AND ALARMGROUPID=':p2505') OR
(ALARMID=':p2506' AND ALARMGROUPID=':p2507') OR
(ALARMID=':p2508' AND ALARMGROUPID=':p2509') OR
(ALARMID=':p2510' AND ALARMGROUPID=':p2511') OR
(ALARMID=':p2512' AND ALARMGROUPID=':p2513') OR
(ALARMID=':p2514' AND ALARMGROUPID=':p2515') OR
(ALARMID=':p2516' AND ALARMGROUPID=':p2517') OR
(ALARMID=':p2518' AND ALARMGROUPID=':p2519') OR
(ALARMID=':p2520' AND ALARMGROUPID=':p2521') OR
(ALARMID=':p2522' AND ALARMGROUPID=':p2523') OR
(ALARMID=':p2524' AND ALARMGROUPID=':p2525') OR
(ALARMID=':p2526' AND ALARMGROUPID=':p2527') OR
(ALARMID=':p2528' AND ALARMGROUPID=':p2529') OR
(ALARMID=':p2530' AND ALARMGROUPID=':p2531') OR
(ALARMID=':p2532' AND ALARMGROUPID=':p2533') OR
(ALARMID=':p2534' AND ALARMGROUPID=':p2535') OR
(ALARMID=':p2536' AND ALARMGROUPID=':p2537') OR
(ALARMID=':p2538' AND ALARMGROUPID=':p2539') OR
(ALARMID=':p2540' AND ALARMGROUPID=':p2541') OR
(ALARMID=':p2542' AND ALARMGROUPID=':p2543') OR
(ALARMID=':p2544' AND ALARMGROUPID=':p2545') OR
(ALARMID=':p2546' AND ALARMGROUPID=':p2547') OR
(ALARMID=':p2548' AND ALARMGROUPID=':p2549') OR
(ALARMID=':p2550' AND ALARMGROUPID=':p2551') OR
(ALARMID=':p2552' AND ALARMGROUPID=':p2553') OR
(ALARMID=':p2554' AND ALARMGROUPID=':p2555') OR
(ALARMID=':p2556' AND ALARMGROUPID=':p2557') OR
(ALARMID=':p2558' AND ALARMGROUPID=':p2559') OR
(ALARMID=':p2560' AND ALARMGROUPID=':p2561') OR
(ALARMID=':p2562' AND ALARMGROUPID=':p2563') OR
(ALARMID=':p2564' AND ALARMGROUPID=':p2565') OR
(ALARMID=':p2566' AND ALARMGROUPID=':p2567') OR
(ALARMID=':p2568' AND ALARMGROUPID=':p2569') OR
(ALARMID=':p2570' AND ALARMGROUPID=':p2571') OR
(ALARMID=':p2572' AND ALARMGROUPID=':p2573') OR
(ALARMID=':p2574' AND ALARMGROUPID=':p2575') OR
(ALARMID=':p2576' AND ALARMGROUPID=':p2577') OR
(ALARMID=':p2578' AND ALARMGROUPID=':p2579') OR
(ALARMID=':p2580' AND ALARMGROUPID=':p2581') OR
(ALARMID=':p2582' AND ALARMGROUPID=':p2583') OR
(ALARMID=':p2584' AND ALARMGROUPID=':p2585') OR
(ALARMID=':p2586' AND ALARMGROUPID=':p2587') OR
(ALARMID=':p2588' AND ALARMGROUPID=':p2589') OR
(ALARMID=':p2590' AND ALARMGROUPID=':p2591') OR
(ALARMID=':p2592' AND ALARMGROUPID=':p2593') OR
(ALARMID=':p2594' AND ALARMGROUPID=':p2595') OR
(ALARMID=':p2596' AND ALARMGROUPID=':p2597') OR
(ALARMID=':p2598' AND ALARMGROUPID=':p2599') OR
(ALARMID=':p2600' AND ALARMGROUPID=':p2601') OR
(ALARMID=':p2602' AND ALARMGROUPID=':p2603') OR
(ALARMID=':p2604' AND ALARMGROUPID=':p2605') OR
(ALARMID=':p2606' AND ALARMGROUPID=':p2607') OR
(ALARMID=':p2608' AND ALARMGROUPID=':p2609') OR
(ALARMID=':p2610' AND ALARMGROUPID=':p2611') OR
(ALARMID=':p2612' AND ALARMGROUPID=':p2613') OR
(ALARMID=':p2614' AND ALARMGROUPID=':p2615') OR
(ALARMID=':p2616' AND ALARMGROUPID=':p2617') OR
(ALARMID=':p2618' AND ALARMGROUPID=':p2619') OR
(ALARMID=':p2620' AND ALARMGROUPID=':p2621') OR
(ALARMID=':p2622' AND ALARMGROUPID=':p2623') OR
(ALARMID=':p2624' AND ALARMGROUPID=':p2625') OR
(ALARMID=':p2626' AND ALARMGROUPID=':p2627') OR
(ALARMID=':p2628' AND ALARMGROUPID=':p2629') OR
(ALARMID=':p2630' AND ALARMGROUPID=':p2631') OR
(ALARMID=':p2632' AND ALARMGROUPID=':p2633') OR
(ALARMID=':p2634' AND ALARMGROUPID=':p2635') OR
(ALARMID=':p2636' AND ALARMGROUPID=':p2637') OR
(ALARMID=':p2638' AND ALARMGROUPID=':p2639') OR
(ALARMID=':p2640' AND ALARMGROUPID=':p2641') OR
(ALARMID=':p2642' AND ALARMGROUPID=':p2643') OR
(ALARMID=':p2644' AND ALARMGROUPID=':p2645') OR
(ALARMID=':p2646' AND ALARMGROUPID=':p2647') OR
(ALARMID=':p2648' AND ALARMGROUPID=':p2649') OR
(ALARMID=':p2650' AND ALARMGROUPID=':p2651') OR
(ALARMID=':p2652' AND ALARMGROUPID=':p2653') OR
(ALARMID=':p2654' AND ALARMGROUPID=':p2655') OR
(ALARMID=':p2656' AND ALARMGROUPID=':p2657') OR
(ALARMID=':p2658' AND ALARMGROUPID=':p2659') OR
(ALARMID=':p2660' AND ALARMGROUPID=':p2661') OR
(ALARMID=':p2662' AND ALARMGROUPID=':p2663') OR
(ALARMID=':p2664' AND ALARMGROUPID=':p2665') OR
(ALARMID=':p2666' AND ALARMGROUPID=':p2667') OR
(ALARMID=':p2668' AND ALARMGROUPID=':p2669') OR
(ALARMID=':p2670' AND ALARMGROUPID=':p2671') OR
(ALARMID=':p2672' AND ALARMGROUPID=':p2673') OR
(ALARMID=':p2674' AND ALARMGROUPID=':p2675') OR
(ALARMID=':p2676' AND ALARMGROUPID=':p2677') OR
(ALARMID=':p2678' AND ALARMGROUPID=':p2679') OR
(ALARMID=':p2680' AND ALARMGROUPID=':p2681') OR
(ALARMID=':p2682' AND ALARMGROUPID=':p2683') OR
(ALARMID=':p2684' AND ALARMGROUPID=':p2685') OR
(ALARMID=':p2686' AND ALARMGROUPID=':p2687') OR
(ALARMID=':p2688' AND ALARMGROUPID=':p2689') OR
(ALARMID=':p2690' AND ALARMGROUPID=':p2691') OR
(ALARMID=':p2692' AND ALARMGROUPID=':p2693') OR
(ALARMID=':p2694' AND ALARMGROUPID=':p2695') OR
(ALARMID=':p2696' AND ALARMGROUPID=':p2697') OR
(ALARMID=':p2698' AND ALARMGROUPID=':p2699') OR
(ALARMID=':p2700' AND ALARMGROUPID=':p2701') OR
(ALARMID=':p2702' AND ALARMGROUPID=':p2703') OR
(ALARMID=':p2704' AND ALARMGROUPID=':p2705') OR
(ALARMID=':p2706' AND ALARMGROUPID=':p2707') OR
(ALARMID=':p2708' AND ALARMGROUPID=':p2709') OR
(ALARMID=':p2710' AND ALARMGROUPID=':p2711') OR
(ALARMID=':p2712' AND ALARMGROUPID=':p2713') OR
(ALARMID=':p2714' AND ALARMGROUPID=':p2715') OR
(ALARMID=':p2716' AND ALARMGROUPID=':p2717') OR
(ALARMID=':p2718' AND ALARMGROUPID=':p2719') OR
(ALARMID=':p2720' AND ALARMGROUPID=':p2721') OR
(ALARMID=':p2722' AND ALARMGROUPID=':p2723') OR
(ALARMID=':p2724' AND ALARMGROUPID=':p2725') OR
(ALARMID=':p2726' AND ALARMGROUPID=':p2727') OR
(ALARMID=':p2728' AND ALARMGROUPID=':p2729') OR
(ALARMID=':p2730' AND ALARMGROUPID=':p2731') OR
(ALARMID=':p2732' AND ALARMGROUPID=':p2733') OR
(ALARMID=':p2734' AND ALARMGROUPID=':p2735') OR
(ALARMID=':p2736' AND ALARMGROUPID=':p2737') OR
(ALARMID=':p2738' AND ALARMGROUPID=':p2739') OR
(ALARMID=':p2740' AND ALARMGROUPID=':p2741') OR
(ALARMID=':p2742' AND ALARMGROUPID=':p2743') OR
(ALARMID=':p2744' AND ALARMGROUPID=':p2745') OR
(ALARMID=':p2746' AND ALARMGROUPID=':p2747') OR
(ALARMID=':p2748' AND ALARMGROUPID=':p2749') OR
(ALARMID=':p2750' AND ALARMGROUPID=':p2751') OR
(ALARMID=':p2752' AND ALARMGROUPID=':p2753') OR
(ALARMID=':p2754' AND ALARMGROUPID=':p2755') OR
(ALARMID=':p2756' AND ALARMGROUPID=':p2757') OR
(ALARMID=':p2758' AND ALARMGROUPID=':p2759') OR
(ALARMID=':p2760' AND ALARMGROUPID=':p2761') OR
(ALARMID=':p2762' AND ALARMGROUPID=':p2763') OR
(ALARMID=':p2764' AND ALARMGROUPID=':p2765') OR
(ALARMID=':p2766' AND ALARMGROUPID=':p2767') OR
(ALARMID=':p2768' AND ALARMGROUPID=':p2769') OR
(ALARMID=':p2770' AND ALARMGROUPID=':p2771') OR
(ALARMID=':p2772' AND ALARMGROUPID=':p2773') OR
(ALARMID=':p2774' AND ALARMGROUPID=':p2775') OR
(ALARMID=':p2776' AND ALARMGROUPID=':p2777') OR
(ALARMID=':p2778' AND ALARMGROUPID=':p2779') OR
(ALARMID=':p2780' AND ALARMGROUPID=':p2781') OR
(ALARMID=':p2782' AND ALARMGROUPID=':p2783') OR
(ALARMID=':p2784' AND ALARMGROUPID=':p2785') OR
(ALARMID=':p2786' AND ALARMGROUPID=':p2787') OR
(ALARMID=':p2788' AND ALARMGROUPID=':p2789') OR
(ALARMID=':p2790' AND ALARMGROUPID=':p2791') OR
(ALARMID=':p2792' AND ALARMGROUPID=':p2793') OR
(ALARMID=':p2794' AND ALARMGROUPID=':p2795') OR
(ALARMID=':p2796' AND ALARMGROUPID=':p2797') OR
(ALARMID=':p2798' AND ALARMGROUPID=':p2799') OR
(ALARMID=':p2800' AND ALARMGROUPID=':p2801') OR
(ALARMID=':p2802' AND ALARMGROUPID=':p2803') OR
(ALARMID=':p2804' AND ALARMGROUPID=':p2805') OR
(ALARMID=':p2806' AND ALARMGROUPID=':p2807') OR
(ALARMID=':p2808' AND ALARMGROUPID=':p2809') OR
(ALARMID=':p2810' AND ALARMGROUPID=':p2811') OR
(ALARMID=':p2812' AND ALARMGROUPID=':p2813') OR
(ALARMID=':p2814' AND ALARMGROUPID=':p2815') OR
(ALARMID=':p2816' AND ALARMGROUPID=':p2817') OR
(ALARMID=':p2818' AND ALARMGROUPID=':p2819') OR
(ALARMID=':p2820' AND ALARMGROUPID=':p2821') OR
(ALARMID=':p2822' AND ALARMGROUPID=':p2823') OR
(ALARMID=':p2824' AND ALARMGROUPID=':p2825') OR
(ALARMID=':p2826' AND ALARMGROUPID=':p2827') OR
(ALARMID=':p2828' AND ALARMGROUPID=':p2829') OR
(ALARMID=':p2830' AND ALARMGROUPID=':p2831') OR
(ALARMID=':p2832' AND ALARMGROUPID=':p2833') OR
(ALARMID=':p2834' AND ALARMGROUPID=':p2835') OR
(ALARMID=':p2836' AND ALARMGROUPID=':p2837') OR
(ALARMID=':p2838' AND ALARMGROUPID=':p2839') OR
(ALARMID=':p2840' AND ALARMGROUPID=':p2841') OR
(ALARMID=':p2842' AND ALARMGROUPID=':p2843') OR
(ALARMID=':p2844' AND ALARMGROUPID=':p2845') OR
(ALARMID=':p2846' AND ALARMGROUPID=':p2847') OR
(ALARMID=':p2848' AND ALARMGROUPID=':p2849') OR
(ALARMID=':p2850' AND ALARMGROUPID=':p2851') OR
(ALARMID=':p2852' AND ALARMGROUPID=':p2853') OR
(ALARMID=':p2854' AND ALARMGROUPID=':p2855') OR
(ALARMID=':p2856' AND ALARMGROUPID=':p2857') OR
(ALARMID=':p2858' AND ALARMGROUPID=':p2859') OR
(ALARMID=':p2860' AND ALARMGROUPID=':p2861') OR
(ALARMID=':p2862' AND ALARMGROUPID=':p2863') OR
(ALARMID=':p2864' AND ALARMGROUPID=':p2865') OR
(ALARMID=':p2866' AND ALARMGROUPID=':p2867') OR
(ALARMID=':p2868' AND ALARMGROUPID=':p2869') OR
(ALARMID=':p2870' AND ALARMGROUPID=':p2871') OR
(ALARMID=':p2872' AND ALARMGROUPID=':p2873') OR
(ALARMID=':p2874' AND ALARMGROUPID=':p2875') OR
(ALARMID=':p2876' AND ALARMGROUPID=':p2877') OR
(ALARMID=':p2878' AND ALARMGROUPID=':p2879') OR
(ALARMID=':p2880' AND ALARMGROUPID=':p2881') OR
(ALARMID=':p2882' AND ALARMGROUPID=':p2883') OR
(ALARMID=':p2884' AND ALARMGROUPID=':p2885') OR
(ALARMID=':p2886' AND ALARMGROUPID=':p2887') OR
(ALARMID=':p2888' AND ALARMGROUPID=':p2889') OR
(ALARMID=':p2890' AND ALARMGROUPID=':p2891') OR
(ALARMID=':p2892' AND ALARMGROUPID=':p2893') OR
(ALARMID=':p2894' AND ALARMGROUPID=':p2895') OR
(ALARMID=':p2896' AND ALARMGROUPID=':p2897') OR
(ALARMID=':p2898' AND ALARMGROUPID=':p2899') OR
(ALARMID=':p2900' AND ALARMGROUPID=':p2901') OR
(ALARMID=':p2902' AND ALARMGROUPID=':p2903') OR
(ALARMID=':p2904' AND ALARMGROUPID=':p2905') OR
(ALARMID=':p2906' AND ALARMGROUPID=':p2907') OR
(ALARMID=':p2908' AND ALARMGROUPID=':p2909') OR
(ALARMID=':p2910' AND ALARMGROUPID=':p2911') OR
(ALARMID=':p2912' AND ALARMGROUPID=':p2913') OR
(ALARMID=':p2914' AND ALARMGROUPID=':p2915') OR
(ALARMID=':p2916' AND ALARMGROUPID=':p2917') OR
(ALARMID=':p2918' AND ALARMGROUPID=':p2919') OR
(ALARMID=':p2920' AND ALARMGROUPID=':p2921') OR
(ALARMID=':p2922' AND ALARMGROUPID=':p2923') OR
(ALARMID=':p2924' AND ALARMGROUPID=':p2925') OR
(ALARMID=':p2926' AND ALARMGROUPID=':p2927') OR
(ALARMID=':p2928' AND ALARMGROUPID=':p2929') OR
(ALARMID=':p2930' AND ALARMGROUPID=':p2931') OR
(ALARMID=':p2932' AND ALARMGROUPID=':p2933') OR
(ALARMID=':p2934' AND ALARMGROUPID=':p2935') OR
(ALARMID=':p2936' AND ALARMGROUPID=':p2937') OR
(ALARMID=':p2938' AND ALARMGROUPID=':p2939') OR
(ALARMID=':p2940' AND ALARMGROUPID=':p2941') OR
(ALARMID=':p2942' AND ALARMGROUPID=':p2943') OR
(ALARMID=':p2944' AND ALARMGROUPID=':p2945') OR
(ALARMID=':p2946' AND ALARMGROUPID=':p2947') OR
(ALARMID=':p2948' AND ALARMGROUPID=':p2949') OR
(ALARMID=':p2950' AND ALARMGROUPID=':p2951') OR
(ALARMID=':p2952' AND ALARMGROUPID=':p2953') OR
(ALARMID=':p2954' AND ALARMGROUPID=':p2955') OR
(ALARMID=':p2956' AND ALARMGROUPID=':p2957') OR
(ALARMID=':p2958' AND ALARMGROUPID=':p2959') OR
(ALARMID=':p2960' AND ALARMGROUPID=':p2961') OR
(ALARMID=':p2962' AND ALARMGROUPID=':p2963') OR
(ALARMID=':p2964' AND ALARMGROUPID=':p2965') OR
(ALARMID=':p2966' AND ALARMGROUPID=':p2967') OR
(ALARMID=':p2968' AND ALARMGROUPID=':p2969') OR
(ALARMID=':p2970' AND ALARMGROUPID=':p2971') OR
(ALARMID=':p2972' AND ALARMGROUPID=':p2973') OR
(ALARMID=':p2974' AND ALARMGROUPID=':p2975') OR
(ALARMID=':p2976' AND ALARMGROUPID=':p2977') OR
(ALARMID=':p2978' AND ALARMGROUPID=':p2979') OR
(ALARMID=':p2980' AND ALARMGROUPID=':p2981') OR
(ALARMID=':p2982' AND ALARMGROUPID=':p2983') OR
(ALARMID=':p2984' AND ALARMGROUPID=':p2985') OR
(ALARMID=':p2986' AND ALARMGROUPID=':p2987') OR
(ALARMID=':p2988' AND ALARMGROUPID=':p2989') OR
(ALARMID=':p2990' AND ALARMGROUPID=':p2991') OR
(ALARMID=':p2992' AND ALARMGROUPID=':p2993') OR
(ALARMID=':p2994' AND ALARMGROUPID=':p2995') OR
(ALARMID=':p2996' AND ALARMGROUPID=':p2997') OR
(ALARMID=':p2998' AND ALARMGROUPID=':p2999') OR
(ALARMID=':p3000' AND ALARMGROUPID=':p3001') OR
(ALARMID=':p3002' AND ALARMGROUPID=':p3003') OR
(ALARMID=':p3004' AND ALARMGROUPID=':p3005') OR
(ALARMID=':p3006' AND ALARMGROUPID=':p3007') OR
(ALARMID=':p3008' AND ALARMGROUPID=':p3009') OR
(ALARMID=':p3010' AND ALARMGROUPID=':p3011') OR
(ALARMID=':p3012' AND ALARMGROUPID=':p3013') OR
(ALARMID=':p3014' AND ALARMGROUPID=':p3015') OR
(ALARMID=':p3016' AND ALARMGROUPID=':p3017') OR
(ALARMID=':p3018' AND ALARMGROUPID=':p3019') OR
(ALARMID=':p3020' AND ALARMGROUPID=':p3021') OR
(ALARMID=':p3022' AND ALARMGROUPID=':p3023') OR
(ALARMID=':p3024' AND ALARMGROUPID=':p3025') OR
(ALARMID=':p3026' AND ALARMGROUPID=':p3027') OR
(ALARMID=':p3028' AND ALARMGROUPID=':p3029') OR
(ALARMID=':p3030' AND ALARMGROUPID=':p3031') OR
(ALARMID=':p3032' AND ALARMGROUPID=':p3033') OR
(ALARMID=':p3034' AND ALARMGROUPID=':p3035') OR
(ALARMID=':p3036' AND ALARMGROUPID=':p3037') OR
(ALARMID=':p3038' AND ALARMGROUPID=':p3039') OR
(ALARMID=':p3040' AND ALARMGROUPID=':p3041') OR
(ALARMID=':p3042' AND ALARMGROUPID=':p3043') OR
(ALARMID=':p3044' AND ALARMGROUPID=':p3045') OR
(ALARMID=':p3046' AND ALARMGROUPID=':p3047') OR
(ALARMID=':p3048' AND ALARMGROUPID=':p3049') OR
(ALARMID=':p3050' AND ALARMGROUPID=':p3051') OR
(ALARMID=':p3052' AND ALARMGROUPID=':p3053') OR
(ALARMID=':p3054' AND ALARMGROUPID=':p3055') OR
(ALARMID=':p3056' AND ALARMGROUPID=':p3057') OR
(ALARMID=':p3058' AND ALARMGROUPID=':p3059') OR
(ALARMID=':p3060' AND ALARMGROUPID=':p3061') OR
(ALARMID=':p3062' AND ALARMGROUPID=':p3063') OR
(ALARMID=':p3064' AND ALARMGROUPID=':p3065') OR
(ALARMID=':p3066' AND ALARMGROUPID=':p3067') OR
(ALARMID=':p3068' AND ALARMGROUPID=':p3069') OR
(ALARMID=':p3070' AND ALARMGROUPID=':p3071') OR
(ALARMID=':p3072' AND ALARMGROUPID=':p3073') OR
(ALARMID=':p3074' AND ALARMGROUPID=':p3075') OR
(ALARMID=':p3076' AND ALARMGROUPID=':p3077') OR
(ALARMID=':p3078' AND ALARMGROUPID=':p3079') OR
(ALARMID=':p3080' AND ALARMGROUPID=':p3081') OR
(ALARMID=':p3082' AND ALARMGROUPID=':p3083') OR
(ALARMID=':p3084' AND ALARMGROUPID=':p3085') OR
(ALARMID=':p3086' AND ALARMGROUPID=':p3087') OR
(ALARMID=':p3088' AND ALARMGROUPID=':p3089') OR
(ALARMID=':p3090' AND ALARMGROUPID=':p3091') OR
(ALARMID=':p3092' AND ALARMGROUPID=':p3093') OR
(ALARMID=':p3094' AND ALARMGROUPID=':p3095') OR
(ALARMID=':p3096' AND ALARMGROUPID=':p3097') OR
(ALARMID=':p3098' AND ALARMGROUPID=':p3099') OR
(ALARMID=':p3100' AND ALARMGROUPID=':p3101') OR
(ALARMID=':p3102' AND ALARMGROUPID=':p3103') OR
(ALARMID=':p3104' AND ALARMGROUPID=':p3105') OR
(ALARMID=':p3106' AND ALARMGROUPID=':p3107') OR
(ALARMID=':p3108' AND ALARMGROUPID=':p3109') OR
(ALARMID=':p3110' AND ALARMGROUPID=':p3111') OR
(ALARMID=':p3112' AND ALARMGROUPID=':p3113') OR
(ALARMID=':p3114' AND ALARMGROUPID=':p3115') OR
(ALARMID=':p3116' AND ALARMGROUPID=':p3117') OR
(ALARMID=':p3118' AND ALARMGROUPID=':p3119') OR
(ALARMID=':p3120' AND ALARMGROUPID=':p3121') OR
(ALARMID=':p3122' AND ALARMGROUPID=':p3123') OR
(ALARMID=':p3124' AND ALARMGROUPID=':p3125') OR
(ALARMID=':p3126' AND ALARMGROUPID=':p3127') OR
(ALARMID=':p3128' AND ALARMGROUPID=':p3129') OR
(ALARMID=':p3130' AND ALARMGROUPID=':p3131') OR
(ALARMID=':p3132' AND ALARMGROUPID=':p3133') OR
(ALARMID=':p3134' AND ALARMGROUPID=':p3135') OR
(ALARMID=':p3136' AND ALARMGROUPID=':p3137') OR
(ALARMID=':p3138' AND ALARMGROUPID=':p3139') OR
(ALARMID=':p3140' AND ALARMGROUPID=':p3141') OR
(ALARMID=':p3142' AND ALARMGROUPID=':p3143') OR
(ALARMID=':p3144' AND ALARMGROUPID=':p3145') OR
(ALARMID=':p3146' AND ALARMGROUPID=':p3147') OR
(ALARMID=':p3148' AND ALARMGROUPID=':p3149') OR
(ALARMID=':p3150' AND ALARMGROUPID=':p3151') OR
(ALARMID=':p3152' AND ALARMGROUPID=':p3153') OR
(ALARMID=':p3154' AND ALARMGROUPID=':p3155') OR
(ALARMID=':p3156' AND ALARMGROUPID=':p3157') OR
(ALARMID=':p3158' AND ALARMGROUPID=':p3159') OR
(ALARMID=':p3160' AND ALARMGROUPID=':p3161') OR
(ALARMID=':p3162' AND ALARMGROUPID=':p3163') OR
(ALARMID=':p3164' AND ALARMGROUPID=':p3165') OR
(ALARMID=':p3166' AND ALARMGROUPID=':p3167') OR
(ALARMID=':p3168' AND ALARMGROUPID=':p3169') OR
(ALARMID=':p3170' AND ALARMGROUPID=':p3171') OR
(ALARMID=':p3172' AND ALARMGROUPID=':p3173') OR
(ALARMID=':p3174' AND ALARMGROUPID=':p3175') OR
(ALARMID=':p3176' AND ALARMGROUPID=':p3177') OR
(ALARMID=':p3178' AND ALARMGROUPID=':p3179') OR
(ALARMID=':p3180' AND ALARMGROUPID=':p3181') OR
(ALARMID=':p3182' AND ALARMGROUPID=':p3183') OR
(ALARMID=':p3184' AND ALARMGROUPID=':p3185') OR
(ALARMID=':p3186' AND ALARMGROUPID=':p3187') OR
(ALARMID=':p3188' AND ALARMGROUPID=':p3189') OR
(ALARMID=':p3190' AND ALARMGROUPID=':p3191') OR
(ALARMID=':p3192' AND ALARMGROUPID=':p3193') OR
(ALARMID=':p3194' AND ALARMGROUPID=':p3195') OR
(ALARMID=':p3196' AND ALARMGROUPID=':p3197') OR
(ALARMID=':p3198' AND ALARMGROUPID=':p3199') OR
(ALARMID=':p3200' AND ALARMGROUPID=':p3201') OR
(ALARMID=':p3202' AND ALARMGROUPID=':p3203') OR
(ALARMID=':p3204' AND ALARMGROUPID=':p3205') OR
(ALARMID=':p3206' AND ALARMGROUPID=':p3207') OR
(ALARMID=':p3208' AND ALARMGROUPID=':p3209') OR
(ALARMID=':p3210' AND ALARMGROUPID=':p3211') OR
(ALARMID=':p3212' AND ALARMGROUPID=':p3213') OR
(ALARMID=':p3214' AND ALARMGROUPID=':p3215') OR
(ALARMID=':p3216' AND ALARMGROUPID=':p3217') OR
(ALARMID=':p3218' AND ALARMGROUPID=':p3219') OR
(ALARMID=':p3220' AND ALARMGROUPID=':p3221') OR
(ALARMID=':p3222' AND ALARMGROUPID=':p3223') OR
(ALARMID=':p3224' AND ALARMGROUPID=':p3225') OR
(ALARMID=':p3226' AND ALARMGROUPID=':p3227') OR
(ALARMID=':p3228' AND ALARMGROUPID=':p3229') OR
(ALARMID=':p3230' AND ALARMGROUPID=':p3231') OR
(ALARMID=':p3232' AND ALARMGROUPID=':p3233') OR
(ALARMID=':p3234' AND ALARMGROUPID=':p3235') OR
(ALARMID=':p3236' AND ALARMGROUPID=':p3237') OR
(ALARMID=':p3238' AND ALARMGROUPID=':p3239') OR
(ALARMID=':p3240' AND ALARMGROUPID=':p3241') OR
(ALARMID=':p3242' AND ALARMGROUPID=':p3243') OR
(ALARMID=':p3244' AND ALARMGROUPID=':p3245') OR
(ALARMID=':p3246' AND ALARMGROUPID=':p3247') OR
(ALARMID=':p3248' AND ALARMGROUPID=':p3249') OR
(ALARMID=':p3250' AND ALARMGROUPID=':p3251') OR
(ALARMID=':p3252' AND ALARMGROUPID=':p3253') OR
(ALARMID=':p3254' AND ALARMGROUPID=':p3255') OR
(ALARMID=':p3256' AND ALARMGROUPID=':p3257') OR
(ALARMID=':p3258' AND ALARMGROUPID=':p3259') OR
(ALARMID=':p3260' AND ALARMGROUPID=':p3261') OR
(ALARMID=':p3262' AND ALARMGROUPID=':p3263') OR
(ALARMID=':p3264' AND ALARMGROUPID=':p3265') OR
(ALARMID=':p3266' AND ALARMGROUPID=':p3267') OR
(ALARMID=':p3268' AND ALARMGROUPID=':p3269') OR
(ALARMID=':p3270' AND ALARMGROUPID=':p3271') OR
(ALARMID=':p3272' AND ALARMGROUPID=':p3273') OR
(ALARMID=':p3274' AND ALARMGROUPID=':p3275') OR
(ALARMID=':p3276' AND ALARMGROUPID=':p3277') OR
(ALARMID=':p3278' AND ALARMGROUPID=':p3279') OR
(ALARMID=':p3280' AND ALARMGROUPID=':p3281') OR
(ALARMID=':p3282' AND ALARMGROUPID=':p3283') OR
(ALARMID=':p3284' AND ALARMGROUPID=':p3285') OR
(ALARMID=':p3286' AND ALARMGROUPID=':p3287') OR
(ALARMID=':p3288' AND ALARMGROUPID=':p3289') OR
(ALARMID=':p3290' AND ALARMGROUPID=':p3291') OR
(ALARMID=':p3292' AND ALARMGROUPID=':p3293') OR
(ALARMID=':p3294' AND ALARMGROUPID=':p3295') OR
(ALARMID=':p3296' AND ALARMGROUPID=':p3297') OR
(ALARMID=':p3298' AND ALARMGROUPID=':p3299') OR
(ALARMID=':p3300' AND ALARMGROUPID=':p3301') OR
(ALARMID=':p3302' AND ALARMGROUPID=':p3303') OR
(ALARMID=':p3304' AND ALARMGROUPID=':p3305') OR
(ALARMID=':p3306' AND ALARMGROUPID=':p3307') OR
(ALARMID=':p3308' AND ALARMGROUPID=':p3309') OR
(ALARMID=':p3310' AND ALARMGROUPID=':p3311') OR
(ALARMID=':p3312' AND ALARMGROUPID=':p3313') OR
(ALARMID=':p3314' AND ALARMGROUPID=':p3315') OR
(ALARMID=':p3316' AND ALARMGROUPID=':p3317') OR
(ALARMID=':p3318' AND ALARMGROUPID=':p3319') OR
(ALARMID=':p3320' AND ALARMGROUPID=':p3321') OR
(ALARMID=':p3322' AND ALARMGROUPID=':p3323') OR
(ALARMID=':p3324' AND ALARMGROUPID=':p3325') OR
(ALARMID=':p3326' AND ALARMGROUPID=':p3327') OR
(ALARMID=':p3328' AND ALARMGROUPID=':p3329') OR
(ALARMID=':p3330' AND ALARMGROUPID=':p3331') OR
(ALARMID=':p3332' AND ALARMGROUPID=':p3333') OR
(ALARMID=':p3334' AND ALARMGROUPID=':p3335') OR
(ALARMID=':p3336' AND ALARMGROUPID=':p3337') OR
(ALARMID=':p3338' AND ALARMGROUPID=':p3339') OR
(ALARMID=':p3340' AND ALARMGROUPID=':p3341') OR
(ALARMID=':p3342' AND ALARMGROUPID=':p3343') OR
(ALARMID=':p3344' AND ALARMGROUPID=':p3345') OR
(ALARMID=':p3346' AND ALARMGROUPID=':p3347') OR
(ALARMID=':p3348' AND ALARMGROUPID=':p3349') OR
(ALARMID=':p3350' AND ALARMGROUPID=':p3351') OR
(ALARMID=':p3352' AND ALARMGROUPID=':p3353') OR
(ALARMID=':p3354' AND ALARMGROUPID=':p3355') OR
(ALARMID=':p3356' AND ALARMGROUPID=':p3357') OR
(ALARMID=':p3358' AND ALARMGROUPID=':p3359') OR
(ALARMID=':p3360' AND ALARMGROUPID=':p3361') OR
(ALARMID=':p3362' AND ALARMGROUPID=':p3363') OR
(ALARMID=':p3364' AND ALARMGROUPID=':p3365') OR
(ALARMID=':p3366' AND ALARMGROUPID=':p3367') OR
(ALARMID=':p3368' AND ALARMGROUPID=':p3369') OR
(ALARMID=':p3370' AND ALARMGROUPID=':p3371') OR
(ALARMID=':p3372' AND ALARMGROUPID=':p3373') OR
(ALARMID=':p3374' AND ALARMGROUPID=':p3375') OR
(ALARMID=':p3376' AND ALARMGROUPID=':p3377') OR
(ALARMID=':p3378' AND ALARMGROUPID=':p3379') OR
(ALARMID=':p3380' AND ALARMGROUPID=':p3381') OR
(ALARMID=':p3382' AND ALARMGROUPID=':p3383') OR
(ALARMID=':p3384' AND ALARMGROUPID=':p3385') OR
(ALARMID=':p3386' AND ALARMGROUPID=':p3387') OR
(ALARMID=':p3388' AND ALARMGROUPID=':p3389') OR
(ALARMID=':p3390' AND ALARMGROUPID=':p3391') OR
(ALARMID=':p3392' AND ALARMGROUPID=':p3393') OR
(ALARMID=':p3394' AND ALARMGROUPID=':p3395') OR
(ALARMID=':p3396' AND ALARMGROUPID=':p3397') OR
(ALARMID=':p3398' AND ALARMGROUPID=':p3399') OR
(ALARMID=':p3400' AND ALARMGROUPID=':p3401') OR
(ALARMID=':p3402' AND ALARMGROUPID=':p3403') OR
(ALARMID=':p3404' AND ALARMGROUPID=':p3405') OR
(ALARMID=':p3406' AND ALARMGROUPID=':p3407') OR
(ALARMID=':p3408' AND ALARMGROUPID=':p3409') OR
(ALARMID=':p3410' AND ALARMGROUPID=':p3411') OR
(ALARMID=':p3412' AND ALARMGROUPID=':p3413') OR
(ALARMID=':p3414' AND ALARMGROUPID=':p3415') OR
(ALARMID=':p3416' AND ALARMGROUPID=':p3417') OR
(ALARMID=':p3418' AND ALARMGROUPID=':p3419') OR
(ALARMID=':p3420' AND ALARMGROUPID=':p3421') OR
(ALARMID=':p3422' AND ALARMGROUPID=':p3423') OR
(ALARMID=':p3424' AND ALARMGROUPID=':p3425') OR
(ALARMID=':p3426' AND ALARMGROUPID=':p3427') OR
(ALARMID=':p3428' AND ALARMGROUPID=':p3429') OR
(ALARMID=':p3430' AND ALARMGROUPID=':p3431') OR
(ALARMID=':p3432' AND ALARMGROUPID=':p3433') OR
(ALARMID=':p3434' AND ALARMGROUPID=':p3435') OR
(ALARMID=':p3436' AND ALARMGROUPID=':p3437') OR
(ALARMID=':p3438' AND ALARMGROUPID=':p3439') OR
(ALARMID=':p3440' AND ALARMGROUPID=':p3441') OR
(ALARMID=':p3442' AND ALARMGROUPID=':p3443') OR
(ALARMID=':p3444' AND ALARMGROUPID=':p3445') OR
(ALARMID=':p3446' AND ALARMGROUPID=':p3447') OR
(ALARMID=':p3448' AND ALARMGROUPID=':p3449') OR
(ALARMID=':p3450' AND ALARMGROUPID=':p3451') OR
(ALARMID=':p3452' AND ALARMGROUPID=':p3453') OR
(ALARMID=':p3454' AND ALARMGROUPID=':p3455') OR
(ALARMID=':p3456' AND ALARMGROUPID=':p3457') OR
(ALARMID=':p3458' AND ALARMGROUPID=':p3459') OR
(ALARMID=':p3460' AND ALARMGROUPID=':p3461') OR
(ALARMID=':p3462' AND ALARMGROUPID=':p3463') OR
(ALARMID=':p3464' AND ALARMGROUPID=':p3465') OR
(ALARMID=':p2' AND ALARMGROUPID=':p3') OR
(ALARMID=':p4' AND ALARMGROUPID=':p5') OR
(ALARMID=':p6' AND ALARMGROUPID=':p7') OR
(ALARMID=':p8' AND ALARMGROUPID=':p9') OR
(ALARMID=':p10' AND ALARMGROUPID=':p11') OR
(ALARMID=':p12' AND ALARMGROUPID=':p13') OR
(ALARMID=':p14' AND ALARMGROUPID=':p15') OR
(ALARMID=':p16' AND ALARMGROUPID=':p17') OR
(ALARMID=':p18' AND ALARMGROUPID=':p19') OR
(ALARMID=':p20' AND ALARMGROUPID=':p21') OR
(ALARMID=':p22' AND ALARMGROUPID=':p23') OR
(ALARMID=':p24' AND ALARMGROUPID=':p25') OR
(ALARMID=':p26' AND ALARMGROUPID=':p27') OR
(ALARMID=':p28' AND ALARMGROUPID=':p29') OR
(ALARMID=':p30' AND ALARMGROUPID=':p31') OR
(ALARMID=':p32' AND ALARMGROUPID=':p33') OR
(ALARMID=':p34' AND ALARMGROUPID=':p35') OR
(ALARMID=':p36' AND ALARMGROUPID=':p37') OR
(ALARMID=':p38' AND ALARMGROUPID=':p39') OR
(ALARMID=':p40' AND ALARMGROUPID=':p41') OR
(ALARMID=':p42' AND ALARMGROUPID=':p43') OR
(ALARMID=':p44' AND ALARMGROUPID=':p45') OR
(ALARMID=':p46' AND ALARMGROUPID=':p47') OR
(ALARMID=':p48' AND ALARMGROUPID=':p49') OR
(ALARMID=':p50' AND ALARMGROUPID=':p51') OR
(ALARMID=':p52' AND ALARMGROUPID=':p53') OR
(ALARMID=':p54' AND ALARMGROUPID=':p55') OR
(ALARMID=':p56' AND ALARMGROUPID=':p57') OR
(ALARMID=':p58' AND ALARMGROUPID=':p59') OR
(ALARMID=':p60' AND ALARMGROUPID=':p61') OR
(ALARMID=':p62' AND ALARMGROUPID=':p63') OR
(ALARMID=':p64' AND ALARMGROUPID=':p65') OR
(ALARMID=':p66' AND ALARMGROUPID=':p67') OR
(ALARMID=':p68' AND ALARMGROUPID=':p69') OR
(ALARMID=':p70' AND ALARMGROUPID=':p71') OR
(ALARMID=':p72' AND ALARMGROUPID=':p73') OR
(ALARMID=':p74' AND ALARMGROUPID=':p75') OR
(ALARMID=':p76' AND ALARMGROUPID=':p77') OR
(ALARMID=':p78' AND ALARMGROUPID=':p79') OR
(ALARMID=':p80' AND ALARMGROUPID=':p81') OR
(ALARMID=':p82' AND ALARMGROUPID=':p83') OR
(ALARMID=':p84' AND ALARMGROUPID=':p85') OR
(ALARMID=':p86' AND ALARMGROUPID=':p87') OR
(ALARMID=':p88' AND ALARMGROUPID=':p89') OR
(ALARMID=':p90' AND ALARMGROUPID=':p91') OR
(ALARMID=':p92' AND ALARMGROUPID=':p93') OR
(ALARMID=':p94' AND ALARMGROUPID=':p95') OR
(ALARMID=':p96' AND ALARMGROUPID=':p97') OR
(ALARMID=':p98' AND ALARMGROUPID=':p99') OR
(ALARMID=':p100' AND ALARMGROUPID=':p101') OR
(ALARMID=':p102' AND ALARMGROUPID=':p103') OR
(ALARMID=':p104' AND ALARMGROUPID=':p105') OR
(ALARMID=':p106' AND ALARMGROUPID=':p107') OR
(ALARMID=':p108' AND ALARMGROUPID=':p109') OR
(ALARMID=':p110' AND ALARMGROUPID=':p111') OR
(ALARMID=':p112' AND ALARMGROUPID=':p113') OR
(ALARMID=':p114' AND ALARMGROUPID=':p115') OR
(ALARMID=':p116' AND ALARMGROUPID=':p117') OR
(ALARMID=':p118' AND ALARMGROUPID=':p119') OR
(ALARMID=':p120' AND ALARMGROUPID=':p121') OR
(ALARMID=':p122' AND ALARMGROUPID=':p123') OR
(ALARMID=':p124' AND ALARMGROUPID=':p125') OR
(ALARMID=':p126' AND ALARMGROUPID=':p127') OR
(ALARMID=':p128' AND ALARMGROUPID=':p129') OR
(ALARMID=':p130' AND ALARMGROUPID=':p131') OR
(ALARMID=':p132' AND ALARMGROUPID=':p133') OR
(ALARMID=':p134' AND ALARMGROUPID=':p135') OR
(ALARMID=':p136' AND ALARMGROUPID=':p137') OR
(ALARMID=':p138' AND ALARMGROUPID=':p139') OR
(ALARMID=':p140' AND ALARMGROUPID=':p141') OR
(ALARMID=':p142' AND ALARMGROUPID=':p143') OR
(ALARMID=':p144' AND ALARMGROUPID=':p145') OR
(ALARMID=':p146' AND ALARMGROUPID=':p147') OR
(ALARMID=':p148' AND ALARMGROUPID=':p149') OR
(ALARMID=':p150' AND ALARMGROUPID=':p151') OR
(ALARMID=':p152' AND ALARMGROUPID=':p153') OR
(ALARMID=':p154' AND ALARMGROUPID=':p155') OR
(ALARMID=':p156' AND ALARMGROUPID=':p157') OR
(ALARMID=':p158' AND ALARMGROUPID=':p159') OR
(ALARMID=':p160' AND ALARMGROUPID=':p161') OR
(ALARMID=':p162' AND ALARMGROUPID=':p163') OR
(ALARMID=':p164' AND ALARMGROUPID=':p165') OR
(ALARMID=':p166' AND ALARMGROUPID=':p167') OR
(ALARMID=':p168' AND ALARMGROUPID=':p169') OR
(ALARMID=':p170' AND ALARMGROUPID=':p171') OR
(ALARMID=':p172' AND ALARMGROUPID=':p173') OR
(ALARMID=':p174' AND ALARMGROUPID=':p175') OR
(ALARMID=':p176' AND ALARMGROUPID=':p177') OR
(ALARMID=':p178' AND ALARMGROUPID=':p179') OR
(ALARMID=':p180' AND ALARMGROUPID=':p181') OR
(ALARMID=':p182' AND ALARMGROUPID=':p183') OR
(ALARMID=':p184' AND ALARMGROUPID=':p185') OR
(ALARMID=':p186' AND ALARMGROUPID=':p187') OR
(ALARMID=':p188' AND ALARMGROUPID=':p189') OR
(ALARMID=':p190' AND ALARMGROUPID=':p191') OR
(ALARMID=':p192' AND ALARMGROUPID=':p193') OR
(ALARMID=':p194' AND ALARMGROUPID=':p195') OR
(ALARMID=':p196' AND ALARMGROUPID=':p197') OR
(ALARMID=':p198' AND ALARMGROUPID=':p199') OR
(ALARMID=':p200' AND ALARMGROUPID=':p201') OR
(ALARMID=':p202' AND ALARMGROUPID=':p203') OR
(ALARMID=':p204' AND ALARMGROUPID=':p205') OR
(ALARMID=':p206' AND ALARMGROUPID=':p207') OR
(ALARMID=':p208' AND ALARMGROUPID=':p209') OR
(ALARMID=':p210' AND ALARMGROUPID=':p211') OR
(ALARMID=':p212' AND ALARMGROUPID=':p213') OR
(ALARMID=':p214' AND ALARMGROUPID=':p215') OR
(ALARMID=':p216' AND ALARMGROUPID=':p217') OR
(ALARMID=':p218' AND ALARMGROUPID=':p219') OR
(ALARMID=':p220' AND ALARMGROUPID=':p221') OR
(ALARMID=':p222' AND ALARMGROUPID=':p223') OR
(ALARMID=':p224' AND ALARMGROUPID=':p225') OR
(ALARMID=':p226' AND ALARMGROUPID=':p227') OR
(ALARMID=':p228' AND ALARMGROUPID=':p229') OR
(ALARMID=':p230' AND ALARMGROUPID=':p231') OR
(ALARMID=':p232' AND ALARMGROUPID=':p233') OR
(ALARMID=':p234' AND ALARMGROUPID=':p235') OR
(ALARMID=':p236' AND ALARMGROUPID=':p237') OR
(ALARMID=':p238' AND ALARMGROUPID=':p239') OR
(ALARMID=':p240' AND ALARMGROUPID=':p241') OR
(ALARMID=':p242' AND ALARMGROUPID=':p243') OR
(ALARMID=':p244' AND ALARMGROUPID=':p245') OR
(ALARMID=':p246' AND ALARMGROUPID=':p247') OR
(ALARMID=':p248' AND ALARMGROUPID=':p249') OR
(ALARMID=':p250' AND ALARMGROUPID=':p251') OR
(ALARMID=':p252' AND ALARMGROUPID=':p253') OR
(ALARMID=':p254' AND ALARMGROUPID=':p255') OR
(ALARMID=':p256' AND ALARMGROUPID=':p257') OR
(ALARMID=':p258' AND ALARMGROUPID=':p259') OR
(ALARMID=':p260' AND ALARMGROUPID=':p261') OR
(ALARMID=':p262' AND ALARMGROUPID=':p263') OR
(ALARMID=':p264' AND ALARMGROUPID=':p265') OR
(ALARMID=':p266' AND ALARMGROUPID=':p267') OR
(ALARMID=':p268' AND ALARMGROUPID=':p269') OR
(ALARMID=':p270' AND ALARMGROUPID=':p271') OR
(ALARMID=':p272' AND ALARMGROUPID=':p273') OR
(ALARMID=':p274' AND ALARMGROUPID=':p275') OR
(ALARMID=':p276' AND ALARMGROUPID=':p277') OR
(ALARMID=':p278' AND ALARMGROUPID=':p279') OR
(ALARMID=':p280' AND ALARMGROUPID=':p281') OR
(ALARMID=':p282' AND ALARMGROUPID=':p283') OR
(ALARMID=':p284' AND ALARMGROUPID=':p285') OR
(ALARMID=':p286' AND ALARMGROUPID=':p287') OR
(ALARMID=':p288' AND ALARMGROUPID=':p289') OR
(ALARMID=':p290' AND ALARMGROUPID=':p291') OR
(ALARMID=':p292' AND ALARMGROUPID=':p293') OR
(ALARMID=':p294' AND ALARMGROUPID=':p295') OR
(ALARMID=':p296' AND ALARMGROUPID=':p297') OR
(ALARMID=':p298' AND ALARMGROUPID=':p299') OR
(ALARMID=':p300' AND ALARMGROUPID=':p301') OR
(ALARMID=':p302' AND ALARMGROUPID=':p303') OR
(ALARMID=':p304' AND ALARMGROUPID=':p305') OR
(ALARMID=':p306' AND ALARMGROUPID=':p307') OR
(ALARMID=':p308' AND ALARMGROUPID=':p309') OR
(ALARMID=':p310' AND ALARMGROUPID=':p311') OR
(ALARMID=':p312' AND ALARMGROUPID=':p313') OR
(ALARMID=':p314' AND ALARMGROUPID=':p315') OR
(ALARMID=':p316' AND ALARMGROUPID=':p317') OR
(ALARMID=':p318' AND ALARMGROUPID=':p319') OR
(ALARMID=':p320' AND ALARMGROUPID=':p321') OR
(ALARMID=':p322' AND ALARMGROUPID=':p323') OR
(ALARMID=':p324' AND ALARMGROUPID=':p325') OR
(ALARMID=':p326' AND ALARMGROUPID=':p327') OR
(ALARMID=':p328' AND ALARMGROUPID=':p329') OR
(ALARMID=':p330' AND ALARMGROUPID=':p331') OR
(ALARMID=':p332' AND ALARMGROUPID=':p333') OR
(ALARMID=':p334' AND ALARMGROUPID=':p335') OR
(ALARMID=':p336' AND ALARMGROUPID=':p337') OR
(ALARMID=':p338' AND ALARMGROUPID=':p339') OR
(ALARMID=':p340' AND ALARMGROUPID=':p341') OR
(ALARMID=':p342' AND ALARMGROUPID=':p343') OR
(ALARMID=':p344' AND ALARMGROUPID=':p345') OR
(ALARMID=':p346' AND ALARMGROUPID=':p347') OR
(ALARMID=':p348' AND ALARMGROUPID=':p349') OR
(ALARMID=':p350' AND ALARMGROUPID=':p351') OR
(ALARMID=':p352' AND ALARMGROUPID=':p353') OR
(ALARMID=':p354' AND ALARMGROUPID=':p355') OR
(ALARMID=':p356' AND ALARMGROUPID=':p357') OR
(ALARMID=':p358' AND ALARMGROUPID=':p359') OR
(ALARMID=':p360' AND ALARMGROUPID=':p361') OR
(ALARMID=':p362' AND ALARMGROUPID=':p363') OR
(ALARMID=':p364' AND ALARMGROUPID=':p365') OR
(ALARMID=':p366' AND ALARMGROUPID=':p367') OR
(ALARMID=':p368' AND ALARMGROUPID=':p369') OR
(ALARMID=':p370' AND ALARMGROUPID=':p371') OR
(ALARMID=':p372' AND ALARMGROUPID=':p373') OR
(ALARMID=':p374' AND ALARMGROUPID=':p375') OR
(ALARMID=':p376' AND ALARMGROUPID=':p377') OR
(ALARMID=':p378' AND ALARMGROUPID=':p379') OR
(ALARMID=':p380' AND ALARMGROUPID=':p381') OR
(ALARMID=':p382' AND ALARMGROUPID=':p383') OR
(ALARMID=':p384' AND ALARMGROUPID=':p385') OR
(ALARMID=':p386' AND ALARMGROUPID=':p387') OR
(ALARMID=':p388' AND ALARMGROUPID=':p389') OR
(ALARMID=':p390' AND ALARMGROUPID=':p391') OR
(ALARMID=':p392' AND ALARMGROUPID=':p393') OR
(ALARMID=':p394' AND ALARMGROUPID=':p395') OR
(ALARMID=':p396' AND ALARMGROUPID=':p397') OR
(ALARMID=':p398' AND ALARMGROUPID=':p399') OR
(ALARMID=':p400' AND ALARMGROUPID=':p401') OR
(ALARMID=':p402' AND ALARMGROUPID=':p403') OR
(ALARMID=':p404' AND ALARMGROUPID=':p405') OR
(ALARMID=':p406' AND ALARMGROUPID=':p407') OR
(ALARMID=':p408' AND ALARMGROUPID=':p409') OR
(ALARMID=':p410' AND ALARMGROUPID=':p411') OR
(ALARMID=':p412' AND ALARMGROUPID=':p413') OR
(ALARMID=':p414' AND ALARMGROUPID=':p415') OR
(ALARMID=':p416' AND ALARMGROUPID=':p417') OR
(ALARMID=':p418' AND ALARMGROUPID=':p419') OR
(ALARMID=':p420' AND ALARMGROUPID=':p421') OR
(ALARMID=':p422' AND ALARMGROUPID=':p423') OR
(ALARMID=':p424' AND ALARMGROUPID=':p425') OR
(ALARMID=':p426' AND ALARMGROUPID=':p427') OR
(ALARMID=':p428' AND ALARMGROUPID=':p429') OR
(ALARMID=':p430' AND ALARMGROUPID=':p431') OR
(ALARMID=':p432' AND ALARMGROUPID=':p433') OR
(ALARMID=':p434' AND ALARMGROUPID=':p435') OR
(ALARMID=':p436' AND ALARMGROUPID=':p437') OR
(ALARMID=':p438' AND ALARMGROUPID=':p439') OR
(ALARMID=':p440' AND ALARMGROUPID=':p441') OR
(ALARMID=':p442' AND ALARMGROUPID=':p443') OR
(ALARMID=':p444' AND ALARMGROUPID=':p445') OR
(ALARMID=':p446' AND ALARMGROUPID=':p447') OR
(ALARMID=':p448' AND ALARMGROUPID=':p449') OR
(ALARMID=':p450' AND ALARMGROUPID=':p451') OR
(ALARMID=':p452' AND ALARMGROUPID=':p453') OR
(ALARMID=':p454' AND ALARMGROUPID=':p455') OR
(ALARMID=':p456' AND ALARMGROUPID=':p457') OR
(ALARMID=':p458' AND ALARMGROUPID=':p459') OR
(ALARMID=':p460' AND ALARMGROUPID=':p461') OR
(ALARMID=':p462' AND ALARMGROUPID=':p463') OR
(ALARMID=':p464' AND ALARMGROUPID=':p465') OR
(ALARMID=':p466' AND ALARMGROUPID=':p467') OR
(ALARMID=':p468' AND ALARMGROUPID=':p469') OR
(ALARMID=':p470' AND ALARMGROUPID=':p471') OR
(ALARMID=':p472' AND ALARMGROUPID=':p473') OR
(ALARMID=':p474' AND ALARMGROUPID=':p475') OR
(ALARMID=':p476' AND ALARMGROUPID=':p477') OR
(ALARMID=':p478' AND ALARMGROUPID=':p479') OR
(ALARMID=':p480' AND ALARMGROUPID=':p481') OR
(ALARMID=':p482' AND ALARMGROUPID=':p483') OR
(ALARMID=':p484' AND ALARMGROUPID=':p485') OR
(ALARMID=':p486' AND ALARMGROUPID=':p487') OR
(ALARMID=':p488' AND ALARMGROUPID=':p489') OR
(ALARMID=':p490' AND ALARMGROUPID=':p491') OR
(ALARMID=':p492' AND ALARMGROUPID=':p493') OR
(ALARMID=':p494' AND ALARMGROUPID=':p495') OR
(ALARMID=':p496' AND ALARMGROUPID=':p497') OR
(ALARMID=':p498' AND ALARMGROUPID=':p499') OR
(ALARMID=':p500' AND ALARMGROUPID=':p501') OR
(ALARMID=':p502' AND ALARMGROUPID=':p503') OR
(ALARMID=':p504' AND ALARMGROUPID=':p505') OR
(ALARMID=':p506' AND ALARMGROUPID=':p507') OR
(ALARMID=':p508' AND ALARMGROUPID=':p509') OR
(ALARMID=':p510' AND ALARMGROUPID=':p511') OR
(ALARMID=':p512' AND ALARMGROUPID=':p513') OR
(ALARMID=':p514' AND ALARMGROUPID=':p515') OR
(ALARMID=':p516' AND ALARMGROUPID=':p517') OR
(ALARMID=':p518' AND ALARMGROUPID=':p519') OR
(ALARMID=':p520' AND ALARMGROUPID=':p521') OR
(ALARMID=':p522' AND ALARMGROUPID=':p523') OR
(ALARMID=':p524' AND ALARMGROUPID=':p525') OR
(ALARMID=':p526' AND ALARMGROUPID=':p527') OR
(ALARMID=':p528' AND ALARMGROUPID=':p529') OR
(ALARMID=':p530' AND ALARMGROUPID=':p531') OR
(ALARMID=':p532' AND ALARMGROUPID=':p533') OR
(ALARMID=':p534' AND ALARMGROUPID=':p535') OR
(ALARMID=':p536' AND ALARMGROUPID=':p537') OR
(ALARMID=':p538' AND ALARMGROUPID=':p539') OR
(ALARMID=':p540' AND ALARMGROUPID=':p541') OR
(ALARMID=':p542' AND ALARMGROUPID=':p543') OR
(ALARMID=':p544' AND ALARMGROUPID=':p545') OR
(ALARMID=':p546' AND ALARMGROUPID=':p547') OR
(ALARMID=':p548' AND ALARMGROUPID=':p549') OR
(ALARMID=':p550' AND ALARMGROUPID=':p551') OR
(ALARMID=':p552' AND ALARMGROUPID=':p553') OR
(ALARMID=':p554' AND ALARMGROUPID=':p555') OR
(ALARMID=':p556' AND ALARMGROUPID=':p557') OR
(ALARMID=':p558' AND ALARMGROUPID=':p559') OR
(ALARMID=':p560' AND ALARMGROUPID=':p561') OR
(ALARMID=':p562' AND ALARMGROUPID=':p563') OR
(ALARMID=':p564' AND ALARMGROUPID=':p565') OR
(ALARMID=':p566' AND ALARMGROUPID=':p567') OR
(ALARMID=':p568' AND ALARMGROUPID=':p569') OR
(ALARMID=':p570' AND ALARMGROUPID=':p571') OR
(ALARMID=':p572' AND ALARMGROUPID=':p573') OR
(ALARMID=':p574' AND ALARMGROUPID=':p575') OR
(ALARMID=':p576' AND ALARMGROUPID=':p577') OR
(ALARMID=':p578' AND ALARMGROUPID=':p579') OR
(ALARMID=':p580' AND ALARMGROUPID=':p581') OR
(ALARMID=':p582' AND ALARMGROUPID=':p583') OR
(ALARMID=':p584' AND ALARMGROUPID=':p585') OR
(ALARMID=':p586' AND ALARMGROUPID=':p587') OR
(ALARMID=':p588' AND ALARMGROUPID=':p589') OR
(ALARMID=':p590' AND ALARMGROUPID=':p591') OR
(ALARMID=':p592' AND ALARMGROUPID=':p593') OR
(ALARMID=':p594' AND ALARMGROUPID=':p595') OR
(ALARMID=':p596' AND ALARMGROUPID=':p597') OR
(ALARMID=':p598' AND ALARMGROUPID=':p599') OR
(ALARMID=':p600' AND ALARMGROUPID=':p601') OR
(ALARMID=':p602' AND ALARMGROUPID=':p603') OR
(ALARMID=':p604' AND ALARMGROUPID=':p605') OR
(ALARMID=':p606' AND ALARMGROUPID=':p607') OR
(ALARMID=':p608' AND ALARMGROUPID=':p609') OR
(ALARMID=':p610' AND ALARMGROUPID=':p611') OR
(ALARMID=':p612' AND ALARMGROUPID=':p613') OR
(ALARMID=':p614' AND ALARMGROUPID=':p615') OR
(ALARMID=':p616' AND ALARMGROUPID=':p617') OR
(ALARMID=':p618' AND ALARMGROUPID=':p619') OR
(ALARMID=':p620' AND ALARMGROUPID=':p621') OR
(ALARMID=':p622' AND ALARMGROUPID=':p623') OR
(ALARMID=':p624' AND ALARMGROUPID=':p625') OR
(ALARMID=':p626' AND ALARMGROUPID=':p627') OR
(ALARMID=':p628' AND ALARMGROUPID=':p629') OR
(ALARMID=':p630' AND ALARMGROUPID=':p631') OR
(ALARMID=':p632' AND ALARMGROUPID=':p633') OR
(ALARMID=':p634' AND ALARMGROUPID=':p635') OR
(ALARMID=':p636' AND ALARMGROUPID=':p637') OR
(ALARMID=':p638' AND ALARMGROUPID=':p639') OR
(ALARMID=':p640' AND ALARMGROUPID=':p641') OR
(ALARMID=':p642' AND ALARMGROUPID=':p643') OR
(ALARMID=':p644' AND ALARMGROUPID=':p645') OR
(ALARMID=':p646' AND ALARMGROUPID=':p647') OR
(ALARMID=':p648' AND ALARMGROUPID=':p649') OR
(ALARMID=':p650' AND ALARMGROUPID=':p651') OR
(ALARMID=':p652' AND ALARMGROUPID=':p653') OR
(ALARMID=':p654' AND ALARMGROUPID=':p655') OR
(ALARMID=':p656' AND ALARMGROUPID=':p657') OR
(ALARMID=':p658' AND ALARMGROUPID=':p659') OR
(ALARMID=':p660' AND ALARMGROUPID=':p661') OR
(ALARMID=':p662' AND ALARMGROUPID=':p663') OR
(ALARMID=':p664' AND ALARMGROUPID=':p665') OR
(ALARMID=':p666' AND ALARMGROUPID=':p667') OR
(ALARMID=':p668' AND ALARMGROUPID=':p669') OR
(ALARMID=':p670' AND ALARMGROUPID=':p671') OR
(ALARMID=':p672' AND ALARMGROUPID=':p673') OR
(ALARMID=':p674' AND ALARMGROUPID=':p675') OR
(ALARMID=':p676' AND ALARMGROUPID=':p677') OR
(ALARMID=':p678' AND ALARMGROUPID=':p679') OR
(ALARMID=':p680' AND ALARMGROUPID=':p681') OR
(ALARMID=':p682' AND ALARMGROUPID=':p683') OR
(ALARMID=':p684' AND ALARMGROUPID=':p685') OR
(ALARMID=':p686' AND ALARMGROUPID=':p687') OR
(ALARMID=':p688' AND ALARMGROUPID=':p689') OR
(ALARMID=':p690' AND ALARMGROUPID=':p691') OR
(ALARMID=':p692' AND ALARMGROUPID=':p693') OR
(ALARMID=':p694' AND ALARMGROUPID=':p695') OR
(ALARMID=':p696' AND ALARMGROUPID=':p697') OR
(ALARMID=':p698' AND ALARMGROUPID=':p699') OR
(ALARMID=':p700' AND ALARMGROUPID=':p701') OR
(ALARMID=':p702' AND ALARMGROUPID=':p703') OR
(ALARMID=':p704' AND ALARMGROUPID=':p705') OR
(ALARMID=':p706' AND ALARMGROUPID=':p707') OR
(ALARMID=':p708' AND ALARMGROUPID=':p709') OR
(ALARMID=':p710' AND ALARMGROUPID=':p711') OR
(ALARMID=':p712' AND ALARMGROUPID=':p713') OR
(ALARMID=':p714' AND ALARMGROUPID=':p715') OR
(ALARMID=':p716' AND ALARMGROUPID=':p717') OR
(ALARMID=':p718' AND ALARMGROUPID=':p719') OR
(ALARMID=':p720' AND ALARMGROUPID=':p721') OR
(ALARMID=':p722' AND ALARMGROUPID=':p723') OR
(ALARMID=':p724' AND ALARMGROUPID=':p725') OR
(ALARMID=':p726' AND ALARMGROUPID=':p727') OR
(ALARMID=':p728' AND ALARMGROUPID=':p729') OR
(ALARMID=':p730' AND ALARMGROUPID=':p731') OR
(ALARMID=':p732' AND ALARMGROUPID=':p733') OR
(ALARMID=':p734' AND ALARMGROUPID=':p735') OR
(ALARMID=':p736' AND ALARMGROUPID=':p737') OR
(ALARMID=':p738' AND ALARMGROUPID=':p739') OR
(ALARMID=':p740' AND ALARMGROUPID=':p741') OR
(ALARMID=':p742' AND ALARMGROUPID=':p743') OR
(ALARMID=':p744' AND ALARMGROUPID=':p745') OR
(ALARMID=':p746' AND ALARMGROUPID=':p747') OR
(ALARMID=':p748' AND ALARMGROUPID=':p749') OR
(ALARMID=':p750' AND ALARMGROUPID=':p751') OR
(ALARMID=':p752' AND ALARMGROUPID=':p753') OR
(ALARMID=':p754' AND ALARMGROUPID=':p755') OR
(ALARMID=':p756' AND ALARMGROUPID=':p757') OR
(ALARMID=':p758' AND ALARMGROUPID=':p759') OR
(ALARMID=':p760' AND ALARMGROUPID=':p761') OR
(ALARMID=':p762' AND ALARMGROUPID=':p763') OR
(ALARMID=':p764' AND ALARMGROUPID=':p765') OR
(ALARMID=':p766' AND ALARMGROUPID=':p767') OR
(ALARMID=':p768' AND ALARMGROUPID=':p769') OR
(ALARMID=':p770' AND ALARMGROUPID=':p771') OR
(ALARMID=':p772' AND ALARMGROUPID=':p773') OR
(ALARMID=':p774' AND ALARMGROUPID=':p775') OR
(ALARMID=':p776' AND ALARMGROUPID=':p777') OR
(ALARMID=':p778' AND ALARMGROUPID=':p779') OR
(ALARMID=':p780' AND ALARMGROUPID=':p781') OR
(ALARMID=':p782' AND ALARMGROUPID=':p783') OR
(ALARMID=':p784' AND ALARMGROUPID=':p785') OR
(ALARMID=':p786' AND ALARMGROUPID=':p787') OR
(ALARMID=':p788' AND ALARMGROUPID=':p789') OR
(ALARMID=':p790' AND ALARMGROUPID=':p791') OR
(ALARMID=':p792' AND ALARMGROUPID=':p793') OR
(ALARMID=':p794' AND ALARMGROUPID=':p795') OR
(ALARMID=':p796' AND ALARMGROUPID=':p797') OR
(ALARMID=':p798' AND ALARMGROUPID=':p799') OR
(ALARMID=':p800' AND ALARMGROUPID=':p801') OR
(ALARMID=':p802' AND ALARMGROUPID=':p803') OR
(ALARMID=':p804' AND ALARMGROUPID=':p805') OR
(ALARMID=':p806' AND ALARMGROUPID=':p807') OR
(ALARMID=':p808' AND ALARMGROUPID=':p809') OR
(ALARMID=':p810' AND ALARMGROUPID=':p811') OR
(ALARMID=':p812' AND ALARMGROUPID=':p813') OR
(ALARMID=':p814' AND ALARMGROUPID=':p815') OR
(ALARMID=':p816' AND ALARMGROUPID=':p817') OR
(ALARMID=':p818' AND ALARMGROUPID=':p819') OR
(ALARMID=':p820' AND ALARMGROUPID=':p821') OR
(ALARMID=':p822' AND ALARMGROUPID=':p823') OR
(ALARMID=':p824' AND ALARMGROUPID=':p825') OR
(ALARMID=':p826' AND ALARMGROUPID=':p827') OR
(ALARMID=':p828' AND ALARMGROUPID=':p829') OR
(ALARMID=':p830' AND ALARMGROUPID=':p831') OR
(ALARMID=':p832' AND ALARMGROUPID=':p833') OR
(ALARMID=':p834' AND ALARMGROUPID=':p835') OR
(ALARMID=':p836' AND ALARMGROUPID=':p837') OR
(ALARMID=':p838' AND ALARMGROUPID=':p839') OR
(ALARMID=':p840' AND ALARMGROUPID=':p841') OR
(ALARMID=':p842' AND ALARMGROUPID=':p843') OR
(ALARMID=':p844' AND ALARMGROUPID=':p845') OR
(ALARMID=':p846' AND ALARMGROUPID=':p847') OR
(ALARMID=':p848' AND ALARMGROUPID=':p849') OR
(ALARMID=':p850' AND ALARMGROUPID=':p851') OR
(ALARMID=':p852' AND ALARMGROUPID=':p853') OR
(ALARMID=':p854' AND ALARMGROUPID=':p855') OR
(ALARMID=':p856' AND ALARMGROUPID=':p857') OR
(ALARMID=':p858' AND ALARMGROUPID=':p859') OR
(ALARMID=':p860' AND ALARMGROUPID=':p861') OR
(ALARMID=':p862' AND ALARMGROUPID=':p863') OR
(ALARMID=':p864' AND ALARMGROUPID=':p865') OR
(ALARMID=':p866' AND ALARMGROUPID=':p867') OR
(ALARMID=':p868' AND ALARMGROUPID=':p869') OR
(ALARMID=':p870' AND ALARMGROUPID=':p871') OR
(ALARMID=':p872' AND ALARMGROUPID=':p873') OR
(ALARMID=':p874' AND ALARMGROUPID=':p875') OR
(ALARMID=':p876' AND ALARMGROUPID=':p877') OR
(ALARMID=':p878' AND ALARMGROUPID=':p879') OR
(ALARMID=':p880' AND ALARMGROUPID=':p881') OR
(ALARMID=':p882' AND ALARMGROUPID=':p883') OR
(ALARMID=':p884' AND ALARMGROUPID=':p885') OR
(ALARMID=':p886' AND ALARMGROUPID=':p887') OR
(ALARMID=':p888' AND ALARMGROUPID=':p889') OR
(ALARMID=':p890' AND ALARMGROUPID=':p891') OR
(ALARMID=':p892' AND ALARMGROUPID=':p893') OR
(ALARMID=':p894' AND ALARMGROUPID=':p895') OR
(ALARMID=':p896' AND ALARMGROUPID=':p897') OR
(ALARMID=':p898' AND ALARMGROUPID=':p899') OR
(ALARMID=':p900' AND ALARMGROUPID=':p901') OR
(ALARMID=':p902' AND ALARMGROUPID=':p903') OR
(ALARMID=':p904' AND ALARMGROUPID=':p905') OR
(ALARMID=':p906' AND ALARMGROUPID=':p907') OR
(ALARMID=':p908' AND ALARMGROUPID=':p909') OR
(ALARMID=':p910' AND ALARMGROUPID=':p911') OR
(ALARMID=':p912' AND ALARMGROUPID=':p913') OR
(ALARMID=':p914' AND ALARMGROUPID=':p915') OR
(ALARMID=':p916' AND ALARMGROUPID=':p917') OR
(ALARMID=':p918' AND ALARMGROUPID=':p919') OR
(ALARMID=':p920' AND ALARMGROUPID=':p921') OR
(ALARMID=':p922' AND ALARMGROUPID=':p923') OR
(ALARMID=':p924' AND ALARMGROUPID=':p925') OR
(ALARMID=':p926' AND ALARMGROUPID=':p927') OR
(ALARMID=':p928' AND ALARMGROUPID=':p929') OR
(ALARMID=':p930' AND ALARMGROUPID=':p931') OR
(ALARMID=':p932' AND ALARMGROUPID=':p933') OR
(ALARMID=':p934' AND ALARMGROUPID=':p935') OR
(ALARMID=':p936' AND ALARMGROUPID=':p937') OR
(ALARMID=':p938' AND ALARMGROUPID=':p939') OR
(ALARMID=':p940' AND ALARMGROUPID=':p941') OR
(ALARMID=':p942' AND ALARMGROUPID=':p943') OR
(ALARMID=':p944' AND ALARMGROUPID=':p945') OR
(ALARMID=':p946' AND ALARMGROUPID=':p947') OR
(ALARMID=':p948' AND ALARMGROUPID=':p949') OR
(ALARMID=':p950' AND ALARMGROUPID=':p951') OR
(ALARMID=':p952' AND ALARMGROUPID=':p953') OR
(ALARMID=':p954' AND ALARMGROUPID=':p955') OR
(ALARMID=':p956' AND ALARMGROUPID=':p957') OR
(ALARMID=':p958' AND ALARMGROUPID=':p959') OR
(ALARMID=':p960' AND ALARMGROUPID=':p961') OR
(ALARMID=':p962' AND ALARMGROUPID=':p963') OR
(ALARMID=':p964' AND ALARMGROUPID=':p965') OR
(ALARMID=':p966' AND ALARMGROUPID=':p967') OR
(ALARMID=':p968' AND ALARMGROUPID=':p969') OR
(ALARMID=':p970' AND ALARMGROUPID=':p971') OR
(ALARMID=':p972' AND ALARMGROUPID=':p973') OR
(ALARMID=':p974' AND ALARMGROUPID=':p975') OR
(ALARMID=':p976' AND ALARMGROUPID=':p977') OR
(ALARMID=':p978' AND ALARMGROUPID=':p979') OR
(ALARMID=':p980' AND ALARMGROUPID=':p981') OR
(ALARMID=':p982' AND ALARMGROUPID=':p983') OR
(ALARMID=':p984' AND ALARMGROUPID=':p985') OR
(ALARMID=':p986' AND ALARMGROUPID=':p987') OR
(ALARMID=':p988' AND ALARMGROUPID=':p989') OR
(ALARMID=':p990' AND ALARMGROUPID=':p991') OR
(ALARMID=':p992' AND ALARMGROUPID=':p993') OR
(ALARMID=':p994' AND ALARMGROUPID=':p995') OR
(ALARMID=':p996' AND ALARMGROUPID=':p997') OR
(ALARMID=':p998' AND ALARMGROUPID=':p999') OR
(ALARMID=':p1000' AND ALARMGROUPID=':p1001') OR
(ALARMID=':p1002' AND ALARMGROUPID=':p1003') OR
(ALARMID=':p1004' AND ALARMGROUPID=':p1005') OR
(ALARMID=':p1006' AND ALARMGROUPID=':p1007') OR
(ALARMID=':p1008' AND ALARMGROUPID=':p1009') OR
(ALARMID=':p1010' AND ALARMGROUPID=':p1011') OR
(ALARMID=':p1012' AND ALARMGROUPID=':p1013') OR
(ALARMID=':p1014' AND ALARMGROUPID=':p1015') OR
(ALARMID=':p1016' AND ALARMGROUPID=':p1017') OR
(ALARMID=':p1018' AND ALARMGROUPID=':p1019') OR
(ALARMID=':p1020' AND ALARMGROUPID=':p1021') OR
(ALARMID=':p1022' AND ALARMGROUPID=':p1023') OR
(ALARMID=':p1024' AND ALARMGROUPID=':p1025') OR
(ALARMID=':p1026' AND ALARMGROUPID=':p1027') OR
(ALARMID=':p1028' AND ALARMGROUPID=':p1029') OR
(ALARMID=':p1030' AND ALARMGROUPID=':p1031') OR
(ALARMID=':p1032' AND ALARMGROUPID=':p1033') OR
(ALARMID=':p1034' AND ALARMGROUPID=':p1035') OR
(ALARMID=':p1036' AND ALARMGROUPID=':p1037') OR
(ALARMID=':p1038' AND ALARMGROUPID=':p1039') OR
(ALARMID=':p1040' AND ALARMGROUPID=':p1041') OR
(ALARMID=':p1042' AND ALARMGROUPID=':p1043') OR
(ALARMID=':p1044' AND ALARMGROUPID=':p1045') OR
(ALARMID=':p1046' AND ALARMGROUPID=':p1047') OR
(ALARMID=':p1048' AND ALARMGROUPID=':p1049') OR
(ALARMID=':p1050' AND ALARMGROUPID=':p1051') OR
(ALARMID=':p1052' AND ALARMGROUPID=':p1053') OR
(ALARMID=':p1054' AND ALARMGROUPID=':p1055') OR
(ALARMID=':p1056' AND ALARMGROUPID=':p1057') OR
(ALARMID=':p1058' AND ALARMGROUPID=':p1059') OR
(ALARMID=':p1060' AND ALARMGROUPID=':p1061') OR
(ALARMID=':p1062' AND ALARMGROUPID=':p1063') OR
(ALARMID=':p1064' AND ALARMGROUPID=':p1065') OR
(ALARMID=':p1066' AND ALARMGROUPID=':p1067') OR
(ALARMID=':p1068' AND ALARMGROUPID=':p1069') OR
(ALARMID=':p1070' AND ALARMGROUPID=':p1071') OR
(ALARMID=':p1072' AND ALARMGROUPID=':p1073') OR
(ALARMID=':p1074' AND ALARMGROUPID=':p1075') OR
(ALARMID=':p1076' AND ALARMGROUPID=':p1077') OR
(ALARMID=':p1078' AND ALARMGROUPID=':p1079') OR
(ALARMID=':p1080' AND ALARMGROUPID=':p1081') OR
(ALARMID=':p1082' AND ALARMGROUPID=':p1083') OR
(ALARMID=':p1084' AND ALARMGROUPID=':p1085') OR
(ALARMID=':p1086' AND ALARMGROUPID=':p1087') OR
(ALARMID=':p1088' AND ALARMGROUPID=':p1089') OR
(ALARMID=':p1090' AND ALARMGROUPID=':p1091') OR
(ALARMID=':p1092' AND ALARMGROUPID=':p1093') OR
(ALARMID=':p1094' AND ALARMGROUPID=':p1095') OR
(ALARMID=':p1096' AND ALARMGROUPID=':p1097') OR
(ALARMID=':p1098' AND ALARMGROUPID=':p1099') OR
(ALARMID=':p1100' AND ALARMGROUPID=':p1101') OR
(ALARMID=':p1102' AND ALARMGROUPID=':p1103') OR
(ALARMID=':p1104' AND ALARMGROUPID=':p1105') OR
(ALARMID=':p1106' AND ALARMGROUPID=':p1107') OR
(ALARMID=':p1108' AND ALARMGROUPID=':p1109') OR
(ALARMID=':p1110' AND ALARMGROUPID=':p1111') OR
(ALARMID=':p1112' AND ALARMGROUPID=':p1113') OR
(ALARMID=':p1114' AND ALARMGROUPID=':p1115') OR
(ALARMID=':p1116' AND ALARMGROUPID=':p1117') OR
(ALARMID=':p1118' AND ALARMGROUPID=':p1119') OR
(ALARMID=':p1120' AND ALARMGROUPID=':p1121') OR
(ALARMID=':p1122' AND ALARMGROUPID=':p1123') OR
(ALARMID=':p1124' AND ALARMGROUPID=':p1125') OR
(ALARMID=':p1126' AND ALARMGROUPID=':p1127') OR
(ALARMID=':p1128' AND ALARMGROUPID=':p1129') OR
(ALARMID=':p1130' AND ALARMGROUPID=':p1131') OR
(ALARMID=':p1132' AND ALARMGROUPID=':p1133') OR
(ALARMID=':p1134' AND ALARMGROUPID=':p1135') OR
(ALARMID=':p1136' AND ALARMGROUPID=':p1137') OR
(ALARMID=':p1138' AND ALARMGROUPID=':p1139') OR
(ALARMID=':p1140' AND ALARMGROUPID=':p1141') OR
(ALARMID=':p1142' AND ALARMGROUPID=':p1143') OR
(ALARMID=':p1144' AND ALARMGROUPID=':p1145') OR
(ALARMID=':p1146' AND ALARMGROUPID=':p1147') OR
(ALARMID=':p1148' AND ALARMGROUPID=':p1149') OR
(ALARMID=':p1150' AND ALARMGROUPID=':p1151') OR
(ALARMID=':p1152' AND ALARMGROUPID=':p1153') OR
(ALARMID=':p1154' AND ALARMGROUPID=':p1155') OR
(ALARMID=':p1156' AND ALARMGROUPID=':p1157') OR
(ALARMID=':p1158' AND ALARMGROUPID=':p1159') OR
(ALARMID=':p1160' AND ALARMGROUPID=':p1161') OR
(ALARMID=':p1162' AND ALARMGROUPID=':p1163') OR
(ALARMID=':p1164' AND ALARMGROUPID=':p1165') OR
(ALARMID=':p1166' AND ALARMGROUPID=':p1167') OR
(ALARMID=':p1168' AND ALARMGROUPID=':p1169') OR
(ALARMID=':p1170' AND ALARMGROUPID=':p1171') OR
(ALARMID=':p1172' AND ALARMGROUPID=':p1173') OR
(ALARMID=':p1174' AND ALARMGROUPID=':p1175') OR
(ALARMID=':p1176' AND ALARMGROUPID=':p1177') OR
(ALARMID=':p1178' AND ALARMGROUPID=':p1179') OR
(ALARMID=':p1180' AND ALARMGROUPID=':p1181') OR
(ALARMID=':p1182' AND ALARMGROUPID=':p1183') OR
(ALARMID=':p1184' AND ALARMGROUPID=':p1185') OR
(ALARMID=':p1186' AND ALARMGROUPID=':p1187') OR
(ALARMID=':p1188' AND ALARMGROUPID=':p1189') OR
(ALARMID=':p1190' AND ALARMGROUPID=':p1191') OR
(ALARMID=':p1192' AND ALARMGROUPID=':p1193') OR
(ALARMID=':p1194' AND ALARMGROUPID=':p1195') OR
(ALARMID=':p1196' AND ALARMGROUPID=':p1197') OR
(ALARMID=':p1198' AND ALARMGROUPID=':p1199') OR
(ALARMID=':p1200' AND ALARMGROUPID=':p1201') OR
(ALARMID=':p1202' AND ALARMGROUPID=':p1203') OR
(ALARMID=':p1204' AND ALARMGROUPID=':p1205') OR
(ALARMID=':p1206' AND ALARMGROUPID=':p1207') OR
(ALARMID=':p1208' AND ALARMGROUPID=':p1209') OR
(ALARMID=':p1210' AND ALARMGROUPID=':p1211') OR
(ALARMID=':p1212' AND ALARMGROUPID=':p1213') OR
(ALARMID=':p1214' AND ALARMGROUPID=':p1215') OR
(ALARMID=':p1216' AND ALARMGROUPID=':p1217') OR
(ALARMID=':p1218' AND ALARMGROUPID=':p1219') OR
(ALARMID=':p1220' AND ALARMGROUPID=':p1221') OR
(ALARMID=':p1222' AND ALARMGROUPID=':p1223') OR
(ALARMID=':p1224' AND ALARMGROUPID=':p1225') OR
(ALARMID=':p1226' AND ALARMGROUPID=':p1227') OR
(ALARMID=':p1228' AND ALARMGROUPID=':p1229') OR
(ALARMID=':p1230' AND ALARMGROUPID=':p1231') OR
(ALARMID=':p1232' AND ALARMGROUPID=':p1233') OR
(ALARMID=':p1234' AND ALARMGROUPID=':p1235') OR
(ALARMID=':p1236' AND ALARMGROUPID=':p1237') OR
(ALARMID=':p1238' AND ALARMGROUPID=':p1239') OR
(ALARMID=':p1240' AND ALARMGROUPID=':p1241') OR
(ALARMID=':p1242' AND ALARMGROUPID=':p1243') OR
(ALARMID=':p1244' AND ALARMGROUPID=':p1245') OR
(ALARMID=':p1246' AND ALARMGROUPID=':p1247') OR
(ALARMID=':p1248' AND ALARMGROUPID=':p1249') OR
(ALARMID=':p1250' AND ALARMGROUPID=':p1251') OR
(ALARMID=':p1252' AND ALARMGROUPID=':p1253') OR
(ALARMID=':p1254' AND ALARMGROUPID=':p1255') OR
(ALARMID=':p1256' AND ALARMGROUPID=':p1257') OR
(ALARMID=':p1258' AND ALARMGROUPID=':p1259') OR
(ALARMID=':p1260' AND ALARMGROUPID=':p1261') OR
(ALARMID=':p1262' AND ALARMGROUPID=':p1263') OR
(ALARMID=':p1264' AND ALARMGROUPID=':p1265') OR
(ALARMID=':p1266' AND ALARMGROUPID=':p1267') OR
(ALARMID=':p1268' AND ALARMGROUPID=':p1269') OR
(ALARMID=':p1270' AND ALARMGROUPID=':p1271') OR
(ALARMID=':p1272' AND ALARMGROUPID=':p1273') OR
(ALARMID=':p1274' AND ALARMGROUPID=':p1275') OR
(ALARMID=':p1276' AND ALARMGROUPID=':p1277') OR
(ALARMID=':p1278' AND ALARMGROUPID=':p1279') OR
(ALARMID=':p1280' AND ALARMGROUPID=':p1281') OR
(ALARMID=':p1282' AND ALARMGROUPID=':p1283') OR
(ALARMID=':p1284' AND ALARMGROUPID=':p1285') OR
(ALARMID=':p1286' AND ALARMGROUPID=':p1287') OR
(ALARMID=':p1288' AND ALARMGROUPID=':p1289') OR
(ALARMID=':p1290' AND ALARMGROUPID=':p1291') OR
(ALARMID=':p1292' AND ALARMGROUPID=':p1293') OR
(ALARMID=':p1294' AND ALARMGROUPID=':p1295') OR
(ALARMID=':p1296' AND ALARMGROUPID=':p1297') OR
(ALARMID=':p1298' AND ALARMGROUPID=':p1299') OR
(ALARMID=':p1300' AND ALARMGROUPID=':p1301') OR
(ALARMID=':p1302' AND ALARMGROUPID=':p1303') OR
(ALARMID=':p1304' AND ALARMGROUPID=':p1305') OR
(ALARMID=':p1306' AND ALARMGROUPID=':p1307') OR
(ALARMID=':p1308' AND ALARMGROUPID=':p1309') OR
(ALARMID=':p1310' AND ALARMGROUPID=':p1311') OR
(ALARMID=':p1312' AND ALARMGROUPID=':p1313') OR
(ALARMID=':p1314' AND ALARMGROUPID=':p1315') OR
(ALARMID=':p1316' AND ALARMGROUPID=':p1317') OR
(ALARMID=':p1318' AND ALARMGROUPID=':p1319') OR
(ALARMID=':p1320' AND ALARMGROUPID=':p1321') OR
(ALARMID=':p1322' AND ALARMGROUPID=':p1323') OR
(ALARMID=':p1324' AND ALARMGROUPID=':p1325') OR
(ALARMID=':p1326' AND ALARMGROUPID=':p1327') OR
(ALARMID=':p1328' AND ALARMGROUPID=':p1329') OR
(ALARMID=':p1330' AND ALARMGROUPID=':p1331') OR
(ALARMID=':p1332' AND ALARMGROUPID=':p1333') OR
(ALARMID=':p1334' AND ALARMGROUPID=':p1335') OR
(ALARMID=':p1336' AND ALARMGROUPID=':p1337') OR
(ALARMID=':p1338' AND ALARMGROUPID=':p1339') OR
(ALARMID=':p1340' AND ALARMGROUPID=':p1341') OR
(ALARMID=':p1342' AND ALARMGROUPID=':p1343') OR
(ALARMID=':p1344' AND ALARMGROUPID=':p1345') OR
(ALARMID=':p1346' AND ALARMGROUPID=':p1347') OR
(ALARMID=':p1348' AND ALARMGROUPID=':p1349') OR
(ALARMID=':p1350' AND ALARMGROUPID=':p1351') OR
(ALARMID=':p1352' AND ALARMGROUPID=':p1353') OR
(ALARMID=':p1354' AND ALARMGROUPID=':p1355') OR
(ALARMID=':p1356' AND ALARMGROUPID=':p1357') OR
(ALARMID=':p1358' AND ALARMGROUPID=':p1359') OR
(ALARMID=':p1360' AND ALARMGROUPID=':p1361') OR
(ALARMID=':p1362' AND ALARMGROUPID=':p1363') OR
(ALARMID=':p1364' AND ALARMGROUPID=':p1365') OR
(ALARMID=':p1366' AND ALARMGROUPID=':p1367') OR
(ALARMID=':p1368' AND ALARMGROUPID=':p1369') OR
(ALARMID=':p1370' AND ALARMGROUPID=':p1371') OR
(ALARMID=':p1372' AND ALARMGROUPID=':p1373') OR
(ALARMID=':p1374' AND ALARMGROUPID=':p1375') OR
(ALARMID=':p1376' AND ALARMGROUPID=':p1377') OR
(ALARMID=':p1378' AND ALARMGROUPID=':p1379') OR
(ALARMID=':p1380' AND ALARMGROUPID=':p1381') OR
(ALARMID=':p1382' AND ALARMGROUPID=':p1383') OR
(ALARMID=':p1384' AND ALARMGROUPID=':p1385') OR
(ALARMID=':p1386' AND ALARMGROUPID=':p1387') OR
(ALARMID=':p1388' AND ALARMGROUPID=':p1389') OR
(ALARMID=':p1390' AND ALARMGROUPID=':p1391') OR
(ALARMID=':p1392' AND ALARMGROUPID=':p1393') OR
(ALARMID=':p1394' AND ALARMGROUPID=':p1395') OR
(ALARMID=':p1396' AND ALARMGROUPID=':p1397') OR
(ALARMID=':p1398' AND ALARMGROUPID=':p1399') OR
(ALARMID=':p1400' AND ALARMGROUPID=':p1401') OR
(ALARMID=':p1402' AND ALARMGROUPID=':p1403') OR
(ALARMID=':p1404' AND ALARMGROUPID=':p1405') OR
(ALARMID=':p1406' AND ALARMGROUPID=':p1407') OR
(ALARMID=':p1408' AND ALARMGROUPID=':p1409') OR
(ALARMID=':p1410' AND ALARMGROUPID=':p1411') OR
(ALARMID=':p1412' AND ALARMGROUPID=':p1413') OR
(ALARMID=':p1414' AND ALARMGROUPID=':p1415') OR
(ALARMID=':p1416' AND ALARMGROUPID=':p1417') OR
(ALARMID=':p1418' AND ALARMGROUPID=':p1419') OR
(ALARMID=':p1420' AND ALARMGROUPID=':p1421') OR
(ALARMID=':p1422' AND ALARMGROUPID=':p1423') OR
(ALARMID=':p1424' AND ALARMGROUPID=':p1425') OR
(ALARMID=':p1426' AND ALARMGROUPID=':p1427') OR
(ALARMID=':p1428' AND ALARMGROUPID=':p1429') OR
(ALARMID=':p1430' AND ALARMGROUPID=':p1431') OR
(ALARMID=':p1432' AND ALARMGROUPID=':p1433') OR
(ALARMID=':p1434' AND ALARMGROUPID=':p1435') OR
(ALARMID=':p1436' AND ALARMGROUPID=':p1437') OR
(ALARMID=':p1438' AND ALARMGROUPID=':p1439') OR
(ALARMID=':p1440' AND ALARMGROUPID=':p1441') OR
(ALARMID=':p1442' AND ALARMGROUPID=':p1443') OR
(ALARMID=':p1444' AND ALARMGROUPID=':p1445') OR
(ALARMID=':p1446' AND ALARMGROUPID=':p1447') OR
(ALARMID=':p1448' AND ALARMGROUPID=':p1449') OR
(ALARMID=':p1450' AND ALARMGROUPID=':p1451') OR
(ALARMID=':p1452' AND ALARMGROUPID=':p1453') OR
(ALARMID=':p1454' AND ALARMGROUPID=':p1455') OR
(ALARMID=':p1456' AND ALARMGROUPID=':p1457') OR
(ALARMID=':p1458' AND ALARMGROUPID=':p1459') OR
(ALARMID=':p1460' AND ALARMGROUPID=':p1461') OR
(ALARMID=':p1462' AND ALARMGROUPID=':p1463') OR
(ALARMID=':p1464' AND ALARMGROUPID=':p1465') OR
(ALARMID=':p1466' AND ALARMGROUPID=':p1467') OR
(ALARMID=':p1468' AND ALARMGROUPID=':p1469') OR
(ALARMID=':p1470' AND ALARMGROUPID=':p1471') OR
(ALARMID=':p1472' AND ALARMGROUPID=':p1473') OR
(ALARMID=':p1474' AND ALARMGROUPID=':p1475') OR
(ALARMID=':p1476' AND ALARMGROUPID=':p1477') OR
(ALARMID=':p1478' AND ALARMGROUPID=':p1479') OR
(ALARMID=':p1480' AND ALARMGROUPID=':p1481') OR
(ALARMID=':p1482' AND ALARMGROUPID=':p1483') OR
(ALARMID=':p1484' AND ALARMGROUPID=':p1485') OR
(ALARMID=':p1486' AND ALARMGROUPID=':p1487') OR
(ALARMID=':p1488' AND ALARMGROUPID=':p1489') OR
(ALARMID=':p1490' AND ALARMGROUPID=':p1491') OR
(ALARMID=':p1492' AND ALARMGROUPID=':p1493') OR
(ALARMID=':p1494' AND ALARMGROUPID=':p1495') OR
(ALARMID=':p1496' AND ALARMGROUPID=':p1497') OR
(ALARMID=':p1498' AND ALARMGROUPID=':p1499') OR
(ALARMID=':p1500' AND ALARMGROUPID=':p1501') OR
(ALARMID=':p1502' AND ALARMGROUPID=':p1503') OR
(ALARMID=':p1504' AND ALARMGROUPID=':p1505') OR
(ALARMID=':p1506' AND ALARMGROUPID=':p1507') OR
(ALARMID=':p1508' AND ALARMGROUPID=':p1509') OR
(ALARMID=':p1510' AND ALARMGROUPID=':p1511') OR
(ALARMID=':p1512' AND ALARMGROUPID=':p1513') OR
(ALARMID=':p1514' AND ALARMGROUPID=':p1515') OR
(ALARMID=':p1516' AND ALARMGROUPID=':p1517') OR
(ALARMID=':p1518' AND ALARMGROUPID=':p1519') OR
(ALARMID=':p1520' AND ALARMGROUPID=':p1521') OR
(ALARMID=':p1522' AND ALARMGROUPID=':p1523') OR
(ALARMID=':p1524' AND ALARMGROUPID=':p1525') OR
(ALARMID=':p1526' AND ALARMGROUPID=':p1527') OR
(ALARMID=':p1528' AND ALARMGROUPID=':p1529') OR
(ALARMID=':p1530' AND ALARMGROUPID=':p1531') OR
(ALARMID=':p1532' AND ALARMGROUPID=':p1533') OR
(ALARMID=':p1534' AND ALARMGROUPID=':p1535') OR
(ALARMID=':p1536' AND ALARMGROUPID=':p1537') OR
(ALARMID=':p1538' AND ALARMGROUPID=':p1539') OR
(ALARMID=':p1540' AND ALARMGROUPID=':p1541') OR
(ALARMID=':p1542' AND ALARMGROUPID=':p1543') OR
(ALARMID=':p1544' AND ALARMGROUPID=':p1545') OR
(ALARMID=':p1546' AND ALARMGROUPID=':p1547') OR
(ALARMID=':p1548' AND ALARMGROUPID=':p1549') OR
(ALARMID=':p1550' AND ALARMGROUPID=':p1551') OR
(ALARMID=':p1552' AND ALARMGROUPID=':p1553') OR
(ALARMID=':p1554' AND ALARMGROUPID=':p1555') OR
(ALARMID=':p1556' AND ALARMGROUPID=':p1557') OR
(ALARMID=':p1558' AND ALARMGROUPID=':p1559') OR
(ALARMID=':p1560' AND ALARMGROUPID=':p1561') OR
(ALARMID=':p1562' AND ALARMGROUPID=':p1563') OR
(ALARMID=':p1564' AND ALARMGROUPID=':p1565') OR
(ALARMID=':p1566' AND ALARMGROUPID=':p1567') OR
(ALARMID=':p1568' AND ALARMGROUPID=':p1569') OR
(ALARMID=':p1570' AND ALARMGROUPID=':p1571') OR
(ALARMID=':p1572' AND ALARMGROUPID=':p1573') OR
(ALARMID=':p1574' AND ALARMGROUPID=':p1575') OR
(ALARMID=':p1576' AND ALARMGROUPID=':p1577') OR
(ALARMID=':p1578' AND ALARMGROUPID=':p1579') OR
(ALARMID=':p1580' AND ALARMGROUPID=':p1581') OR
(ALARMID=':p1582' AND ALARMGROUPID=':p1583') OR
(ALARMID=':p1584' AND ALARMGROUPID=':p1585') OR
(ALARMID=':p1586' AND ALARMGROUPID=':p1587') OR
(ALARMID=':p1588' AND ALARMGROUPID=':p1589') OR
(ALARMID=':p1590' AND ALARMGROUPID=':p1591') OR
(ALARMID=':p1592' AND ALARMGROUPID=':p1593') OR
(ALARMID=':p1594' AND ALARMGROUPID=':p1595') OR
(ALARMID=':p1596' AND ALARMGROUPID=':p1597') OR
(ALARMID=':p1598' AND ALARMGROUPID=':p1599') OR
(ALARMID=':p1600' AND ALARMGROUPID=':p1601') OR
(ALARMID=':p1602' AND ALARMGROUPID=':p1603') OR
(ALARMID=':p1604' AND ALARMGROUPID=':p1605') OR
(ALARMID=':p1606' AND ALARMGROUPID=':p1607') OR
(ALARMID=':p1608' AND ALARMGROUPID=':p1609') OR
(ALARMID=':p1610' AND ALARMGROUPID=':p1611') OR
(ALARMID=':p1612' AND ALARMGROUPID=':p1613') OR
(ALARMID=':p1614' AND ALARMGROUPID=':p1615') OR
(ALARMID=':p1616' AND ALARMGROUPID=':p1617') OR
(ALARMID=':p1618' AND ALARMGROUPID=':p1619') OR
(ALARMID=':p1620' AND ALARMGROUPID=':p1621') OR
(ALARMID=':p1622' AND ALARMGROUPID=':p1623') OR
(ALARMID=':p1624' AND ALARMGROUPID=':p1625') OR
(ALARMID=':p1626' AND ALARMGROUPID=':p1627') OR
(ALARMID=':p1628' AND ALARMGROUPID=':p1629') OR
(ALARMID=':p1630' AND ALARMGROUPID=':p1631') OR
(ALARMID=':p1632' AND ALARMGROUPID=':p1633') OR
(ALARMID=':p1634' AND ALARMGROUPID=':p1635') OR
(ALARMID=':p1636' AND ALARMGROUPID=':p1637') OR
(ALARMID=':p1638' AND ALARMGROUPID=':p1639') OR
(ALARMID=':p1640' AND ALARMGROUPID=':p1641') OR
(ALARMID=':p1642' AND ALARMGROUPID=':p1643') OR
(ALARMID=':p1644' AND ALARMGROUPID=':p1645') OR
(ALARMID=':p1646' AND ALARMGROUPID=':p1647') OR
(ALARMID=':p1648' AND ALARMGROUPID=':p1649') OR
(ALARMID=':p1650' AND ALARMGROUPID=':p1651') OR
(ALARMID=':p1652' AND ALARMGROUPID=':p1653') OR
(ALARMID=':p1654' AND ALARMGROUPID=':p1655') OR
(ALARMID=':p1656' AND ALARMGROUPID=':p1657') OR
(ALARMID=':p1658' AND ALARMGROUPID=':p1659') OR
(ALARMID=':p1660' AND ALARMGROUPID=':p1661') OR
(ALARMID=':p1662' AND ALARMGROUPID=':p1663') OR
(ALARMID=':p1664' AND ALARMGROUPID=':p1665') OR
(ALARMID=':p1666' AND ALARMGROUPID=':p1667') OR
(ALARMID=':p1668' AND ALARMGROUPID=':p1669') OR
(ALARMID=':p1670' AND ALARMGROUPID=':p1671') OR
(ALARMID=':p1672' AND ALARMGROUPID=':p1673') OR
(ALARMID=':p1674' AND ALARMGROUPID=':p1675') OR
(ALARMID=':p1676' AND ALARMGROUPID=':p1677') OR
(ALARMID=':p1678' AND ALARMGROUPID=':p1679') OR
(ALARMID=':p1680' AND ALARMGROUPID=':p1681') OR
(ALARMID=':p1682' AND ALARMGROUPID=':p1683') OR
(ALARMID=':p1684' AND ALARMGROUPID=':p1685') OR
(ALARMID=':p1686' AND ALARMGROUPID=':p1687') OR
(ALARMID=':p1688' AND ALARMGROUPID=':p1689') OR
(ALARMID=':p1690' AND ALARMGROUPID=':p1691') OR
(ALARMID=':p1692' AND ALARMGROUPID=':p1693') OR
(ALARMID=':p1694' AND ALARMGROUPID=':p1695') OR
(ALARMID=':p1696' AND ALARMGROUPID=':p1697') OR
(ALARMID=':p1698' AND ALARMGROUPID=':p1699') OR
(ALARMID=':p1700' AND ALARMGROUPID=':p1701') OR
(ALARMID=':p1702' AND ALARMGROUPID=':p1703') OR
(ALARMID=':p1704' AND ALARMGROUPID=':p1705') OR
(ALARMID=':p1706' AND ALARMGROUPID=':p1707') OR
(ALARMID=':p1708' AND ALARMGROUPID=':p1709') OR
(ALARMID=':p1710' AND ALARMGROUPID=':p1711') OR
(ALARMID=':p1712' AND ALARMGROUPID=':p1713') OR
(ALARMID=':p1714' AND ALARMGROUPID=':p1715') OR
(ALARMID=':p1716' AND ALARMGROUPID=':p1717') OR
(ALARMID=':p1718' AND ALARMGROUPID=':p1719') OR
(ALARMID=':p1720' AND ALARMGROUPID=':p1721') OR
(ALARMID=':p1722' AND ALARMGROUPID=':p1723') OR
(ALARMID=':p1724' AND ALARMGROUPID=':p1725') OR
(ALARMID=':p1726' AND ALARMGROUPID=':p1727') OR
(ALARMID=':p1728' AND ALARMGROUPID=':p1729') OR
(ALARMID=':p1730' AND ALARMGROUPID=':p1731') OR
(ALARMID=':p1732' AND ALARMGROUPID=':p1733') OR
(ALARMID=':p1734' AND ALARMGROUPID=':p1735') OR
(ALARMID=':p1736' AND ALARMGROUPID=':p1737') OR
(ALARMID=':p1738' AND ALARMGROUPID=':p1739') OR
(ALARMID=':p1740' AND ALARMGROUPID=':p1741') OR
(ALARMID=':p1742' AND ALARMGROUPID=':p1743') OR
(ALARMID=':p1744' AND ALARMGROUPID=':p1745') OR
(ALARMID=':p1746' AND ALARMGROUPID=':p1747') OR
(ALARMID=':p1748' AND ALARMGROUPID=':p1749') OR
(ALARMID=':p1750' AND ALARMGROUPID=':p1751') OR
(ALARMID=':p1752' AND ALARMGROUPID=':p1753') OR
(ALARMID=':p1754' AND ALARMGROUPID=':p1755') OR
(ALARMID=':p1756' AND ALARMGROUPID=':p1757') OR
(ALARMID=':p1758' AND ALARMGROUPID=':p1759') OR
(ALARMID=':p1760' AND ALARMGROUPID=':p1761') OR
(ALARMID=':p1762' AND ALARMGROUPID=':p1763') OR
(ALARMID=':p1764' AND ALARMGROUPID=':p1765') OR
(ALARMID=':p1766' AND ALARMGROUPID=':p1767') OR
(ALARMID=':p1768' AND ALARMGROUPID=':p1769') OR
(ALARMID=':p1770' AND ALARMGROUPID=':p1771') OR
(ALARMID=':p1772' AND ALARMGROUPID=':p1773') OR
(ALARMID=':p1774' AND ALARMGROUPID=':p1775') OR
(ALARMID=':p1776' AND ALARMGROUPID=':p1777') OR
(ALARMID=':p1778' AND ALARMGROUPID=':p1779') OR
(ALARMID=':p1780' AND ALARMGROUPID=':p1781') OR
(ALARMID=':p1782' AND ALARMGROUPID=':p1783') OR
(ALARMID=':p1784' AND ALARMGROUPID=':p1785') OR
(ALARMID=':p1786' AND ALARMGROUPID=':p1787') OR
(ALARMID=':p1788' AND ALARMGROUPID=':p1789') OR
(ALARMID=':p1790' AND ALARMGROUPID=':p1791') OR
(ALARMID=':p1792' AND ALARMGROUPID=':p1793') OR
(ALARMID=':p1794' AND ALARMGROUPID=':p1795') OR
(ALARMID=':p1796' AND ALARMGROUPID=':p1797') OR
(ALARMID=':p1798' AND ALARMGROUPID=':p1799') OR
(ALARMID=':p1800' AND ALARMGROUPID=':p1801') OR
(ALARMID=':p1802' AND ALARMGROUPID=':p1803') OR
(ALARMID=':p1804' AND ALARMGROUPID=':p1805') OR
(ALARMID=':p1806' AND ALARMGROUPID=':p1807') OR
(ALARMID=':p1808' AND ALARMGROUPID=':p1809') OR
(ALARMID=':p1810' AND ALARMGROUPID=':p1811') OR
(ALARMID=':p1812' AND ALARMGROUPID=':p1813') OR
(ALARMID=':p1814' AND ALARMGROUPID=':p1815') OR
(ALARMID=':p1816' AND ALARMGROUPID=':p1817') OR
(ALARMID=':p1818' AND ALARMGROUPID=':p1819') OR
(ALARMID=':p1820' AND ALARMGROUPID=':p1821') OR
(ALARMID=':p1822' AND ALARMGROUPID=':p1823') OR
(ALARMID=':p1824' AND ALARMGROUPID=':p1825') OR
(ALARMID=':p1826' AND ALARMGROUPID=':p1827') OR
(ALARMID=':p1828' AND ALARMGROUPID=':p1829') OR
(ALARMID=':p1830' AND ALARMGROUPID=':p1831') OR
(ALARMID=':p1832' AND ALARMGROUPID=':p1833') OR
(ALARMID=':p1834' AND ALARMGROUPID=':p1835') OR
(ALARMID=':p1836' AND ALARMGROUPID=':p1837') OR
(ALARMID=':p1838' AND ALARMGROUPID=':p1839') OR
(ALARMID=':p1840' AND ALARMGROUPID=':p1841') OR
(ALARMID=':p1842' AND ALARMGROUPID=':p1843') OR
(ALARMID=':p1844' AND ALARMGROUPID=':p1845') OR
(ALARMID=':p1846' AND ALARMGROUPID=':p1847') OR
(ALARMID=':p1848' AND ALARMGROUPID=':p1849') OR
(ALARMID=':p1850' AND ALARMGROUPID=':p1851') OR
(ALARMID=':p1852' AND ALARMGROUPID=':p1853') OR
(ALARMID=':p1854' AND ALARMGROUPID=':p1855') OR
(ALARMID=':p1856' AND ALARMGROUPID=':p1857') OR
(ALARMID=':p1858' AND ALARMGROUPID=':p1859') OR
(ALARMID=':p1860' AND ALARMGROUPID=':p1861') OR
(ALARMID=':p1862' AND ALARMGROUPID=':p1863') OR
(ALARMID=':p1864' AND ALARMGROUPID=':p1865') OR
(ALARMID=':p1866' AND ALARMGROUPID=':p1867') OR
(ALARMID=':p1868' AND ALARMGROUPID=':p1869') OR
(ALARMID=':p1870' AND ALARMGROUPID=':p1871') OR
(ALARMID=':p1872' AND ALARMGROUPID=':p1873') OR
(ALARMID=':p1874' AND ALARMGROUPID=':p1875') OR
(ALARMID=':p1876' AND ALARMGROUPID=':p1877') OR
(ALARMID=':p1878' AND ALARMGROUPID=':p1879') OR
(ALARMID=':p1880' AND ALARMGROUPID=':p1881') OR
(ALARMID=':p1882' AND ALARMGROUPID=':p1883') OR
(ALARMID=':p1884' AND ALARMGROUPID=':p1885') OR
(ALARMID=':p1886' AND ALARMGROUPID=':p1887') OR
(ALARMID=':p1888' AND ALARMGROUPID=':p1889') OR
(ALARMID=':p1890' AND ALARMGROUPID=':p1891') OR
(ALARMID=':p1892' AND ALARMGROUPID=':p1893') OR
(ALARMID=':p1894' AND ALARMGROUPID=':p1895') OR
(ALARMID=':p1896' AND ALARMGROUPID=':p1897') OR
(ALARMID=':p1898' AND ALARMGROUPID=':p1899') OR
(ALARMID=':p1900' AND ALARMGROUPID=':p1901') OR
(ALARMID=':p1902' AND ALARMGROUPID=':p1903') OR
(ALARMID=':p1904' AND ALARMGROUPID=':p1905') OR
(ALARMID=':p1906' AND ALARMGROUPID=':p1907') OR
(ALARMID=':p1908' AND ALARMGROUPID=':p1909') OR
(ALARMID=':p1910' AND ALARMGROUPID=':p1911') OR
(ALARMID=':p1912' AND ALARMGROUPID=':p1913') OR
(ALARMID=':p1914' AND ALARMGROUPID=':p1915') OR
(ALARMID=':p1916' AND ALARMGROUPID=':p1917') OR
(ALARMID=':p1918' AND ALARMGROUPID=':p1919') OR
(ALARMID=':p1920' AND ALARMGROUPID=':p1921') OR
(ALARMID=':p1922' AND ALARMGROUPID=':p1923') OR
(ALARMID=':p1924' AND ALARMGROUPID=':p1925') OR
(ALARMID=':p1926' AND ALARMGROUPID=':p1927') OR
(ALARMID=':p1928' AND ALARMGROUPID=':p1929') OR
(ALARMID=':p1930' AND ALARMGROUPID=':p1931') OR
(ALARMID=':p1932' AND ALARMGROUPID=':p1933') OR
(ALARMID=':p1934' AND ALARMGROUPID=':p1935') OR
(ALARMID=':p1936' AND ALARMGROUPID=':p1937') OR
(ALARMID=':p1938' AND ALARMGROUPID=':p1939') OR
(ALARMID=':p1940' AND ALARMGROUPID=':p1941') OR
(ALARMID=':p1942' AND ALARMGROUPID=':p1943') OR
(ALARMID=':p1944' AND ALARMGROUPID=':p1945') OR
(ALARMID=':p1946' AND ALARMGROUPID=':p1947') OR
(ALARMID=':p1948' AND ALARMGROUPID=':p1949') OR
(ALARMID=':p1950' AND ALARMGROUPID=':p1951') OR
(ALARMID=':p1952' AND ALARMGROUPID=':p1953') OR
(ALARMID=':p1954' AND ALARMGROUPID=':p1955') OR
(ALARMID=':p1956' AND ALARMGROUPID=':p1957') OR
(ALARMID=':p1958' AND ALARMGROUPID=':p1959') OR
(ALARMID=':p1960' AND ALARMGROUPID=':p1961') OR
(ALARMID=':p1962' AND ALARMGROUPID=':p1963') OR
(ALARMID=':p1964' AND ALARMGROUPID=':p1965') OR
(ALARMID=':p1966' AND ALARMGROUPID=':p1967') OR
(ALARMID=':p1968' AND ALARMGROUPID=':p1969') OR
(ALARMID=':p1970' AND ALARMGROUPID=':p1971') OR
(ALARMID=':p1972' AND ALARMGROUPID=':p1973') OR
(ALARMID=':p1974' AND ALARMGROUPID=':p1975') OR
(ALARMID=':p1976' AND ALARMGROUPID=':p1977') OR
(ALARMID=':p1978' AND ALARMGROUPID=':p1979') OR
(ALARMID=':p1980' AND ALARMGROUPID=':p1981') OR
(ALARMID=':p1982' AND ALARMGROUPID=':p1983') OR
(ALARMID=':p1984' AND ALARMGROUPID=':p1985') OR
(ALARMID=':p1986' AND ALARMGROUPID=':p1987') OR
(ALARMID=':p1988' AND ALARMGROUPID=':p1989') OR
(ALARMID=':p1990' AND ALARMGROUPID=':p1991') OR
(ALARMID=':p1992' AND ALARMGROUPID=':p1993') OR
(ALARMID=':p1994' AND ALARMGROUPID=':p1995') OR
(ALARMID=':p1996' AND ALARMGROUPID=':p1997') OR
(ALARMID=':p1998' AND ALARMGROUPID=':p1999') OR
(ALARMID=':p2000' AND ALARMGROUPID=':p2001') OR
(ALARMID=':p2002' AND ALARMGROUPID=':p2003') OR
(ALARMID=':p2004' AND ALARMGROUPID=':p2005') OR
(ALARMID=':p2006' AND ALARMGROUPID=':p2007') OR
(ALARMID=':p2008' AND ALARMGROUPID=':p2009') OR
(ALARMID=':p2010' AND ALARMGROUPID=':p2011') OR
(ALARMID=':p2012' AND ALARMGROUPID=':p2013') OR
(ALARMID=':p2014' AND ALARMGROUPID=':p2015') OR
(ALARMID=':p2016' AND ALARMGROUPID=':p2017') OR
(ALARMID=':p2018' AND ALARMGROUPID=':p2019') OR
(ALARMID=':p2020' AND ALARMGROUPID=':p2021') OR
(ALARMID=':p2022' AND ALARMGROUPID=':p2023') OR
(ALARMID=':p2024' AND ALARMGROUPID=':p2025') OR
(ALARMID=':p2026' AND ALARMGROUPID=':p2027') OR
(ALARMID=':p2028' AND ALARMGROUPID=':p2029') OR
(ALARMID=':p2030' AND ALARMGROUPID=':p2031') OR
(ALARMID=':p2032' AND ALARMGROUPID=':p2033') OR
(ALARMID=':p2034' AND ALARMGROUPID=':p2035') OR
(ALARMID=':p2036' AND ALARMGROUPID=':p2037') OR
(ALARMID=':p2038' AND ALARMGROUPID=':p2039') OR
(ALARMID=':p2040' AND ALARMGROUPID=':p2041') OR
(ALARMID=':p2042' AND ALARMGROUPID=':p2043') OR
(ALARMID=':p2044' AND ALARMGROUPID=':p2045') OR
(ALARMID=':p2046' AND ALARMGROUPID=':p2047') OR
(ALARMID=':p2048' AND ALARMGROUPID=':p2049') OR
(ALARMID=':p2050' AND ALARMGROUPID=':p2051') OR
(ALARMID=':p2052' AND ALARMGROUPID=':p2053') OR
(ALARMID=':p2054' AND ALARMGROUPID=':p2055') OR
(ALARMID=':p2056' AND ALARMGROUPID=':p2057') OR
(ALARMID=':p2058' AND ALARMGROUPID=':p2059') OR
(ALARMID=':p2060' AND ALARMGROUPID=':p2061') OR
(ALARMID=':p2062' AND ALARMGROUPID=':p2063') OR
(ALARMID=':p2064' AND ALARMGROUPID=':p2065') OR
(ALARMID=':p2066' AND ALARMGROUPID=':p2067') OR
(ALARMID=':p2068' AND ALARMGROUPID=':p2069') OR
(ALARMID=':p2070' AND ALARMGROUPID=':p2071') OR
(ALARMID=':p2072' AND ALARMGROUPID=':p2073') OR
(ALARMID=':p2074' AND ALARMGROUPID=':p2075') OR
(ALARMID=':p2076' AND ALARMGROUPID=':p2077') OR
(ALARMID=':p2078' AND ALARMGROUPID=':p2079') OR
(ALARMID=':p2080' AND ALARMGROUPID=':p2081') OR
(ALARMID=':p2082' AND ALARMGROUPID=':p2083') OR
(ALARMID=':p2084' AND ALARMGROUPID=':p2085') OR
(ALARMID=':p2086' AND ALARMGROUPID=':p2087') OR
(ALARMID=':p2088' AND ALARMGROUPID=':p2089') OR
(ALARMID=':p2090' AND ALARMGROUPID=':p2091') OR
(ALARMID=':p2092' AND ALARMGROUPID=':p2093') OR
(ALARMID=':p2094' AND ALARMGROUPID=':p2095') OR
(ALARMID=':p2096' AND ALARMGROUPID=':p2097') OR
(ALARMID=':p2098' AND ALARMGROUPID=':p2099') OR
(ALARMID=':p2100' AND ALARMGROUPID=':p2101') OR
(ALARMID=':p2102' AND ALARMGROUPID=':p2103') OR
(ALARMID=':p2104' AND ALARMGROUPID=':p2105') OR
(ALARMID=':p2106' AND ALARMGROUPID=':p2107') OR
(ALARMID=':p2108' AND ALARMGROUPID=':p2109') OR
(ALARMID=':p2110' AND ALARMGROUPID=':p2111') OR
(ALARMID=':p2112' AND ALARMGROUPID=':p2113') OR
(ALARMID=':p2114' AND ALARMGROUPID=':p2115') OR
(ALARMID=':p2116' AND ALARMGROUPID=':p2117') OR
(ALARMID=':p2118' AND ALARMGROUPID=':p2119') OR
(ALARMID=':p2120' AND ALARMGROUPID=':p2121') OR
(ALARMID=':p2122' AND ALARMGROUPID=':p2123') OR
(ALARMID=':p2124' AND ALARMGROUPID=':p2125') OR
(ALARMID=':p2126' AND ALARMGROUPID=':p2127') OR
(ALARMID=':p2128' AND ALARMGROUPID=':p2129') OR
(ALARMID=':p2130' AND ALARMGROUPID=':p2131') OR
(ALARMID=':p2132' AND ALARMGROUPID=':p2133') OR
(ALARMID=':p2134' AND ALARMGROUPID=':p2135') OR
(ALARMID=':p2136' AND ALARMGROUPID=':p2137') OR
(ALARMID=':p2138' AND ALARMGROUPID=':p2139') OR
(ALARMID=':p2140' AND ALARMGROUPID=':p2141') OR
(ALARMID=':p2142' AND ALARMGROUPID=':p2143') OR
(ALARMID=':p2144' AND ALARMGROUPID=':p2145') OR
(ALARMID=':p2146' AND ALARMGROUPID=':p2147') OR
(ALARMID=':p2148' AND ALARMGROUPID=':p2149') OR
(ALARMID=':p2150' AND ALARMGROUPID=':p2151') OR
(ALARMID=':p2152' AND ALARMGROUPID=':p2153') OR
(ALARMID=':p2154' AND ALARMGROUPID=':p2155') OR
(ALARMID=':p2156' AND ALARMGROUPID=':p2157') OR
(ALARMID=':p2158' AND ALARMGROUPID=':p2159') OR
(ALARMID=':p2160' AND ALARMGROUPID=':p2161') OR
(ALARMID=':p2162' AND ALARMGROUPID=':p2163') OR
(ALARMID=':p2164' AND ALARMGROUPID=':p2165') OR
(ALARMID=':p2166' AND ALARMGROUPID=':p2167') OR
(ALARMID=':p2168' AND ALARMGROUPID=':p2169') OR
(ALARMID=':p2170' AND ALARMGROUPID=':p2171') OR
(ALARMID=':p2172' AND ALARMGROUPID=':p2173') OR
(ALARMID=':p2174' AND ALARMGROUPID=':p2175') OR
(ALARMID=':p2176' AND ALARMGROUPID=':p2177') OR
(ALARMID=':p2178' AND ALARMGROUPID=':p2179') OR
(ALARMID=':p2180' AND ALARMGROUPID=':p2181') OR
(ALARMID=':p2182' AND ALARMGROUPID=':p2183') OR
(ALARMID=':p2184' AND ALARMGROUPID=':p2185') OR
(ALARMID=':p2186' AND ALARMGROUPID=':p2187') OR
(ALARMID=':p2188' AND ALARMGROUPID=':p2189') OR
(ALARMID=':p2190' AND ALARMGROUPID=':p2191') OR
(ALARMID=':p2192' AND ALARMGROUPID=':p2193') OR
(ALARMID=':p2194' AND ALARMGROUPID=':p2195') OR
(ALARMID=':p2196' AND ALARMGROUPID=':p2197') OR
(ALARMID=':p2198' AND ALARMGROUPID=':p2199') OR
(ALARMID=':p2200' AND ALARMGROUPID=':p2201') OR
(ALARMID=':p2202' AND ALARMGROUPID=':p2203') OR
(ALARMID=':p2204' AND ALARMGROUPID=':p2205') OR
(ALARMID=':p2206' AND ALARMGROUPID=':p2207') OR
(ALARMID=':p2208' AND ALARMGROUPID=':p2209') OR
(ALARMID=':p2210' AND ALARMGROUPID=':p2211') OR
(ALARMID=':p2212' AND ALARMGROUPID=':p2213') OR
(ALARMID=':p2214' AND ALARMGROUPID=':p2215') OR
(ALARMID=':p2216' AND ALARMGROUPID=':p2217') OR
(ALARMID=':p2218' AND ALARMGROUPID=':p2219') OR
(ALARMID=':p2220' AND ALARMGROUPID=':p2221') OR
(ALARMID=':p2222' AND ALARMGROUPID=':p2223') OR
(ALARMID=':p2224' AND ALARMGROUPID=':p2225') OR
(ALARMID=':p2226' AND ALARMGROUPID=':p2227') OR
(ALARMID=':p2228' AND ALARMGROUPID=':p2229') OR
(ALARMID=':p2230' AND ALARMGROUPID=':p2231') OR
(ALARMID=':p2232' AND ALARMGROUPID=':p2233') OR
(ALARMID=':p2234' AND ALARMGROUPID=':p2235') OR
(ALARMID=':p2236' AND ALARMGROUPID=':p2237') OR
(ALARMID=':p2238' AND ALARMGROUPID=':p2239') OR
(ALARMID=':p2240' AND ALARMGROUPID=':p2241') OR
(ALARMID=':p2242' AND ALARMGROUPID=':p2243') OR
(ALARMID=':p2244' AND ALARMGROUPID=':p2245') OR
(ALARMID=':p2246' AND ALARMGROUPID=':p2247') OR
(ALARMID=':p2248' AND ALARMGROUPID=':p2249') OR
(ALARMID=':p2250' AND ALARMGROUPID=':p2251') OR
(ALARMID=':p2252' AND ALARMGROUPID=':p2253') OR
(ALARMID=':p2254' AND ALARMGROUPID=':p2255') OR
(ALARMID=':p2256' AND ALARMGROUPID=':p2257') OR
(ALARMID=':p2258' AND ALARMGROUPID=':p2259') OR
(ALARMID=':p2260' AND ALARMGROUPID=':p2261') OR
(ALARMID=':p2262' AND ALARMGROUPID=':p2263') OR
(ALARMID=':p2264' AND ALARMGROUPID=':p2265') OR
(ALARMID=':p2266' AND ALARMGROUPID=':p2267') OR
(ALARMID=':p2268' AND ALARMGROUPID=':p2269') OR
(ALARMID=':p2270' AND ALARMGROUPID=':p2271') OR
(ALARMID=':p2272' AND ALARMGROUPID=':p2273') OR
(ALARMID=':p2274' AND ALARMGROUPID=':p2275') OR
(ALARMID=':p2276' AND ALARMGROUPID=':p2277') OR
(ALARMID=':p2278' AND ALARMGROUPID=':p2279') OR
(ALARMID=':p2280' AND ALARMGROUPID=':p2281') OR
(ALARMID=':p2282' AND ALARMGROUPID=':p2283') OR
(ALARMID=':p2284' AND ALARMGROUPID=':p2285') OR
(ALARMID=':p2286' AND ALARMGROUPID=':p2287') OR
(ALARMID=':p2288' AND ALARMGROUPID=':p2289') OR
(ALARMID=':p2290' AND ALARMGROUPID=':p2291') OR
(ALARMID=':p2292' AND ALARMGROUPID=':p2293') OR
(ALARMID=':p2294' AND ALARMGROUPID=':p2295') OR
(ALARMID=':p2296' AND ALARMGROUPID=':p2297') OR
(ALARMID=':p2298' AND ALARMGROUPID=':p2299') OR
(ALARMID=':p2300' AND ALARMGROUPID=':p2301') OR
(ALARMID=':p2302' AND ALARMGROUPID=':p2303') OR
(ALARMID=':p2304' AND ALARMGROUPID=':p2305') OR
(ALARMID=':p2306' AND ALARMGROUPID=':p2307') OR
(ALARMID=':p2308' AND ALARMGROUPID=':p2309') OR
(ALARMID=':p2310' AND ALARMGROUPID=':p2311') OR
(ALARMID=':p2312' AND ALARMGROUPID=':p2313') OR
(ALARMID=':p2314' AND ALARMGROUPID=':p2315') OR
(ALARMID=':p2316' AND ALARMGROUPID=':p2317') OR
(ALARMID=':p2318' AND ALARMGROUPID=':p2319') OR
(ALARMID=':p2320' AND ALARMGROUPID=':p2321') OR
(ALARMID=':p2322' AND ALARMGROUPID=':p2323') OR
(ALARMID=':p2324' AND ALARMGROUPID=':p2325') OR
(ALARMID=':p2326' AND ALARMGROUPID=':p2327') OR
(ALARMID=':p2328' AND ALARMGROUPID=':p2329') OR
(ALARMID=':p2330' AND ALARMGROUPID=':p2331') OR
(ALARMID=':p2332' AND ALARMGROUPID=':p2333') OR
(ALARMID=':p2334' AND ALARMGROUPID=':p2335') OR
(ALARMID=':p2336' AND ALARMGROUPID=':p2337') OR
(ALARMID=':p2338' AND ALARMGROUPID=':p2339') OR
(ALARMID=':p2340' AND ALARMGROUPID=':p2341') OR
(ALARMID=':p2342' AND ALARMGROUPID=':p2343') OR
(ALARMID=':p2344' AND ALARMGROUPID=':p2345') OR
(ALARMID=':p2346' AND ALARMGROUPID=':p2347') OR
(ALARMID=':p2348' AND ALARMGROUPID=':p2349') OR
(ALARMID=':p2350' AND ALARMGROUPID=':p2351') OR
(ALARMID=':p2352' AND ALARMGROUPID=':p2353') OR
(ALARMID=':p2354' AND ALARMGROUPID=':p2355') OR
(ALARMID=':p2356' AND ALARMGROUPID=':p2357') OR
(ALARMID=':p2358' AND ALARMGROUPID=':p2359') OR
(ALARMID=':p2360' AND ALARMGROUPID=':p2361') OR
(ALARMID=':p2362' AND ALARMGROUPID=':p2363') OR
(ALARMID=':p2364' AND ALARMGROUPID=':p2365') OR
(ALARMID=':p2366' AND ALARMGROUPID=':p2367') OR
(ALARMID=':p2368' AND ALARMGROUPID=':p2369') OR
(ALARMID=':p2370' AND ALARMGROUPID=':p2371') OR
(ALARMID=':p2372' AND ALARMGROUPID=':p2373') OR
(ALARMID=':p2374' AND ALARMGROUPID=':p2375') OR
(ALARMID=':p2376' AND ALARMGROUPID=':p2377') OR
(ALARMID=':p2378' AND ALARMGROUPID=':p2379') OR
(ALARMID=':p2380' AND ALARMGROUPID=':p2381') OR
(ALARMID=':p2382' AND ALARMGROUPID=':p2383') OR
(ALARMID=':p2384' AND ALARMGROUPID=':p2385') OR
(ALARMID=':p2386' AND ALARMGROUPID=':p2387') OR
(ALARMID=':p2388' AND ALARMGROUPID=':p2389') OR
(ALARMID=':p2390' AND ALARMGROUPID=':p2391') OR
(ALARMID=':p2392' AND ALARMGROUPID=':p2393') OR
(ALARMID=':p2394' AND ALARMGROUPID=':p2395') OR
(ALARMID=':p2396' AND ALARMGROUPID=':p2397') OR
(ALARMID=':p2398' AND ALARMGROUPID=':p2399') OR
(ALARMID=':p2400' AND ALARMGROUPID=':p2401') OR
(ALARMID=':p2402' AND ALARMGROUPID=':p2403') OR
(ALARMID=':p2404' AND ALARMGROUPID=':p2405') OR
(ALARMID=':p2406' AND ALARMGROUPID=':p2407') OR
(ALARMID=':p2408' AND ALARMGROUPID=':p2409') OR
(ALARMID=':p2410' AND ALARMGROUPID=':p2411') OR
(ALARMID=':p2412' AND ALARMGROUPID=':p2413') OR
(ALARMID=':p2414' AND ALARMGROUPID=':p2415') OR
(ALARMID=':p2416' AND ALARMGROUPID=':p2417') OR
(ALARMID=':p2418' AND ALARMGROUPID=':p2419') OR
(ALARMID=':p2420' AND ALARMGROUPID=':p2421') OR
(ALARMID=':p2422' AND ALARMGROUPID=':p2423') OR
(ALARMID=':p2424' AND ALARMGROUPID=':p2425') OR
(ALARMID=':p2426' AND ALARMGROUPID=':p2427') OR
(ALARMID=':p2428' AND ALARMGROUPID=':p2429') OR
(ALARMID=':p2430' AND ALARMGROUPID=':p2431') OR
(ALARMID=':p2432' AND ALARMGROUPID=':p2433') OR
(ALARMID=':p2434' AND ALARMGROUPID=':p2435') OR
(ALARMID=':p2436' AND ALARMGROUPID=':p2437') OR
(ALARMID=':p2438' AND ALARMGROUPID=':p2439') OR
(ALARMID=':p2440' AND ALARMGROUPID=':p2441') OR
(ALARMID=':p2442' AND ALARMGROUPID=':p2443') OR
(ALARMID=':p2444' AND ALARMGROUPID=':p2445') OR
(ALARMID=':p2446' AND ALARMGROUPID=':p2447') OR
(ALARMID=':p2448' AND ALARMGROUPID=':p2449') OR
(ALARMID=':p2450' AND ALARMGROUPID=':p2451') OR
(ALARMID=':p2452' AND ALARMGROUPID=':p2453') OR
(ALARMID=':p2454' AND ALARMGROUPID=':p2455') OR
(ALARMID=':p2456' AND ALARMGROUPID=':p2457') OR
(ALARMID=':p2458' AND ALARMGROUPID=':p2459') OR
(ALARMID=':p2460' AND ALARMGROUPID=':p2461') OR
(ALARMID=':p2462' AND ALARMGROUPID=':p2463') OR
(ALARMID=':p2464' AND ALARMGROUPID=':p2465') OR
(ALARMID=':p2466' AND ALARMGROUPID=':p2467') OR
(ALARMID=':p2468' AND ALARMGROUPID=':p2469') OR
(ALARMID=':p2470' AND ALARMGROUPID=':p2471') OR
(ALARMID=':p2472' AND ALARMGROUPID=':p2473') OR
(ALARMID=':p2474' AND ALARMGROUPID=':p2475') OR
(ALARMID=':p2476' AND ALARMGROUPID=':p2477') OR
(ALARMID=':p2478' AND ALARMGROUPID=':p2479') OR
(ALARMID=':p2480' AND ALARMGROUPID=':p2481') OR
(ALARMID=':p2482' AND ALARMGROUPID=':p2483') OR
(ALARMID=':p2484' AND ALARMGROUPID=':p2485') OR
(ALARMID=':p2486' AND ALARMGROUPID=':p2487') OR
(ALARMID=':p2488' AND ALARMGROUPID=':p2489') OR
(ALARMID=':p2490' AND ALARMGROUPID=':p2491') OR
(ALARMID=':p2492' AND ALARMGROUPID=':p2493') OR
(ALARMID=':p2494' AND ALARMGROUPID=':p2495') OR
(ALARMID=':p2496' AND ALARMGROUPID=':p2497') OR
(ALARMID=':p2498' AND ALARMGROUPID=':p2499') OR
(ALARMID=':p2500' AND ALARMGROUPID=':p2501') OR
(ALARMID=':p2502' AND ALARMGROUPID=':p2503') OR
(ALARMID=':p2504' AND ALARMGROUPID=':p2505') OR
(ALARMID=':p2506' AND ALARMGROUPID=':p2507') OR
(ALARMID=':p2508' AND ALARMGROUPID=':p2509') OR
(ALARMID=':p2510' AND ALARMGROUPID=':p2511') OR
(ALARMID=':p2512' AND ALARMGROUPID=':p2513') OR
(ALARMID=':p2514' AND ALARMGROUPID=':p2515') OR
(ALARMID=':p2516' AND ALARMGROUPID=':p2517') OR
(ALARMID=':p2518' AND ALARMGROUPID=':p2519') OR
(ALARMID=':p2520' AND ALARMGROUPID=':p2521') OR
(ALARMID=':p2522' AND ALARMGROUPID=':p2523') OR
(ALARMID=':p2524' AND ALARMGROUPID=':p2525') OR
(ALARMID=':p2526' AND ALARMGROUPID=':p2527') OR
(ALARMID=':p2528' AND ALARMGROUPID=':p2529') OR
(ALARMID=':p2530' AND ALARMGROUPID=':p2531') OR
(ALARMID=':p2532' AND ALARMGROUPID=':p2533') OR
(ALARMID=':p2534' AND ALARMGROUPID=':p2535') OR
(ALARMID=':p2536' AND ALARMGROUPID=':p2537') OR
(ALARMID=':p2538' AND ALARMGROUPID=':p2539') OR
(ALARMID=':p2540' AND ALARMGROUPID=':p2541') OR
(ALARMID=':p2542' AND ALARMGROUPID=':p2543') OR
(ALARMID=':p2544' AND ALARMGROUPID=':p2545') OR
(ALARMID=':p2546' AND ALARMGROUPID=':p2547') OR
(ALARMID=':p2548' AND ALARMGROUPID=':p2549') OR
(ALARMID=':p2550' AND ALARMGROUPID=':p2551') OR
(ALARMID=':p2552' AND ALARMGROUPID=':p2553') OR
(ALARMID=':p2554' AND ALARMGROUPID=':p2555') OR
(ALARMID=':p2556' AND ALARMGROUPID=':p2557') OR
(ALARMID=':p2558' AND ALARMGROUPID=':p2559') OR
(ALARMID=':p2560' AND ALARMGROUPID=':p2561') OR
(ALARMID=':p2562' AND ALARMGROUPID=':p2563') OR
(ALARMID=':p2564' AND ALARMGROUPID=':p2565') OR
(ALARMID=':p2566' AND ALARMGROUPID=':p2567') OR
(ALARMID=':p2568' AND ALARMGROUPID=':p2569') OR
(ALARMID=':p2570' AND ALARMGROUPID=':p2571') OR
(ALARMID=':p2572' AND ALARMGROUPID=':p2573') OR
(ALARMID=':p2574' AND ALARMGROUPID=':p2575') OR
(ALARMID=':p2576' AND ALARMGROUPID=':p2577') OR
(ALARMID=':p2578' AND ALARMGROUPID=':p2579') OR
(ALARMID=':p2580' AND ALARMGROUPID=':p2581') OR
(ALARMID=':p2582' AND ALARMGROUPID=':p2583') OR
(ALARMID=':p2584' AND ALARMGROUPID=':p2585') OR
(ALARMID=':p2586' AND ALARMGROUPID=':p2587') OR
(ALARMID=':p2588' AND ALARMGROUPID=':p2589') OR
(ALARMID=':p2590' AND ALARMGROUPID=':p2591') OR
(ALARMID=':p2592' AND ALARMGROUPID=':p2593') OR
(ALARMID=':p2594' AND ALARMGROUPID=':p2595') OR
(ALARMID=':p2596' AND ALARMGROUPID=':p2597') OR
(ALARMID=':p2598' AND ALARMGROUPID=':p2599') OR
(ALARMID=':p2600' AND ALARMGROUPID=':p2601') OR
(ALARMID=':p2602' AND ALARMGROUPID=':p2603') OR
(ALARMID=':p2604' AND ALARMGROUPID=':p2605') OR
(ALARMID=':p2606' AND ALARMGROUPID=':p2607') OR
(ALARMID=':p2608' AND ALARMGROUPID=':p2609') OR
(ALARMID=':p2610' AND ALARMGROUPID=':p2611') OR
(ALARMID=':p2612' AND ALARMGROUPID=':p2613') OR
(ALARMID=':p2614' AND ALARMGROUPID=':p2615') OR
(ALARMID=':p2616' AND ALARMGROUPID=':p2617') OR
(ALARMID=':p2618' AND ALARMGROUPID=':p2619') OR
(ALARMID=':p2620' AND ALARMGROUPID=':p2621') OR
(ALARMID=':p2622' AND ALARMGROUPID=':p2623') OR
(ALARMID=':p2624' AND ALARMGROUPID=':p2625') OR
(ALARMID=':p2626' AND ALARMGROUPID=':p2627') OR
(ALARMID=':p2628' AND ALARMGROUPID=':p2629') OR
(ALARMID=':p2630' AND ALARMGROUPID=':p2631') OR
(ALARMID=':p2632' AND ALARMGROUPID=':p2633') OR
(ALARMID=':p2634' AND ALARMGROUPID=':p2635') OR
(ALARMID=':p2636' AND ALARMGROUPID=':p2637') OR
(ALARMID=':p2638' AND ALARMGROUPID=':p2639') OR
(ALARMID=':p2640' AND ALARMGROUPID=':p2641') OR
(ALARMID=':p2642' AND ALARMGROUPID=':p2643') OR
(ALARMID=':p2644' AND ALARMGROUPID=':p2645') OR
(ALARMID=':p2646' AND ALARMGROUPID=':p2647') OR
(ALARMID=':p2648' AND ALARMGROUPID=':p2649') OR
(ALARMID=':p2650' AND ALARMGROUPID=':p2651') OR
(ALARMID=':p2652' AND ALARMGROUPID=':p2653') OR
(ALARMID=':p2654' AND ALARMGROUPID=':p2655') OR
(ALARMID=':p2656' AND ALARMGROUPID=':p2657') OR
(ALARMID=':p2658' AND ALARMGROUPID=':p2659') OR
(ALARMID=':p2660' AND ALARMGROUPID=':p2661') OR
(ALARMID=':p2662' AND ALARMGROUPID=':p2663') OR
(ALARMID=':p2664' AND ALARMGROUPID=':p2665') OR
(ALARMID=':p2666' AND ALARMGROUPID=':p2667') OR
(ALARMID=':p2668' AND ALARMGROUPID=':p2669') OR
(ALARMID=':p2670' AND ALARMGROUPID=':p2671') OR
(ALARMID=':p2672' AND ALARMGROUPID=':p2673') OR
(ALARMID=':p2674' AND ALARMGROUPID=':p2675') OR
(ALARMID=':p2676' AND ALARMGROUPID=':p2677') OR
(ALARMID=':p2678' AND ALARMGROUPID=':p2679') OR
(ALARMID=':p2680' AND ALARMGROUPID=':p2681') OR
(ALARMID=':p2682' AND ALARMGROUPID=':p2683') OR
(ALARMID=':p2684' AND ALARMGROUPID=':p2685') OR
(ALARMID=':p2686' AND ALARMGROUPID=':p2687') OR
(ALARMID=':p2688' AND ALARMGROUPID=':p2689') OR
(ALARMID=':p2690' AND ALARMGROUPID=':p2691') OR
(ALARMID=':p2692' AND ALARMGROUPID=':p2693') OR
(ALARMID=':p2694' AND ALARMGROUPID=':p2695') OR
(ALARMID=':p2696' AND ALARMGROUPID=':p2697') OR
(ALARMID=':p2698' AND ALARMGROUPID=':p2699') OR
(ALARMID=':p2700' AND ALARMGROUPID=':p2701') OR
(ALARMID=':p2702' AND ALARMGROUPID=':p2703') OR
(ALARMID=':p2704' AND ALARMGROUPID=':p2705') OR
(ALARMID=':p2706' AND ALARMGROUPID=':p2707') OR
(ALARMID=':p2708' AND ALARMGROUPID=':p2709') OR
(ALARMID=':p2710' AND ALARMGROUPID=':p2711') OR
(ALARMID=':p2712' AND ALARMGROUPID=':p2713') OR
(ALARMID=':p2714' AND ALARMGROUPID=':p2715') OR
(ALARMID=':p2716' AND ALARMGROUPID=':p2717') OR
(ALARMID=':p2718' AND ALARMGROUPID=':p2719') OR
(ALARMID=':p2720' AND ALARMGROUPID=':p2721') OR
(ALARMID=':p2722' AND ALARMGROUPID=':p2723') OR
(ALARMID=':p2724' AND ALARMGROUPID=':p2725') OR
(ALARMID=':p2726' AND ALARMGROUPID=':p2727') OR
(ALARMID=':p2728' AND ALARMGROUPID=':p2729') OR
(ALARMID=':p2730' AND ALARMGROUPID=':p2731') OR
(ALARMID=':p2732' AND ALARMGROUPID=':p2733') OR
(ALARMID=':p2734' AND ALARMGROUPID=':p2735') OR
(ALARMID=':p2736' AND ALARMGROUPID=':p2737') OR
(ALARMID=':p2738' AND ALARMGROUPID=':p2739') OR
(ALARMID=':p2740' AND ALARMGROUPID=':p2741') OR
(ALARMID=':p2742' AND ALARMGROUPID=':p2743') OR
(ALARMID=':p2744' AND ALARMGROUPID=':p2745') OR
(ALARMID=':p2746' AND ALARMGROUPID=':p2747') OR
(ALARMID=':p2748' AND ALARMGROUPID=':p2749') OR
(ALARMID=':p2750' AND ALARMGROUPID=':p2751') OR
(ALARMID=':p2752' AND ALARMGROUPID=':p2753') OR
(ALARMID=':p2754' AND ALARMGROUPID=':p2755') OR
(ALARMID=':p2756' AND ALARMGROUPID=':p2757') OR
(ALARMID=':p2758' AND ALARMGROUPID=':p2759') OR
(ALARMID=':p2760' AND ALARMGROUPID=':p2761') OR
(ALARMID=':p2762' AND ALARMGROUPID=':p2763') OR
(ALARMID=':p2764' AND ALARMGROUPID=':p2765') OR
(ALARMID=':p2766' AND ALARMGROUPID=':p2767') OR
(ALARMID=':p2768' AND ALARMGROUPID=':p2769') OR
(ALARMID=':p2770' AND ALARMGROUPID=':p2771') OR
(ALARMID=':p2772' AND ALARMGROUPID=':p2773') OR
(ALARMID=':p2774' AND ALARMGROUPID=':p2775') OR
(ALARMID=':p2776' AND ALARMGROUPID=':p2777') OR
(ALARMID=':p2778' AND ALARMGROUPID=':p2779') OR
(ALARMID=':p2780' AND ALARMGROUPID=':p2781') OR
(ALARMID=':p2782' AND ALARMGROUPID=':p2783') OR
(ALARMID=':p2784' AND ALARMGROUPID=':p2785') OR
(ALARMID=':p2786' AND ALARMGROUPID=':p2787') OR
(ALARMID=':p2788' AND ALARMGROUPID=':p2789') OR
(ALARMID=':p2790' AND ALARMGROUPID=':p2791') OR
(ALARMID=':p2792' AND ALARMGROUPID=':p2793') OR
(ALARMID=':p2794' AND ALARMGROUPID=':p2795') OR
(ALARMID=':p2796' AND ALARMGROUPID=':p2797') OR
(ALARMID=':p2798' AND ALARMGROUPID=':p2799') OR
(ALARMID=':p2800' AND ALARMGROUPID=':p2801') OR
(ALARMID=':p2802' AND ALARMGROUPID=':p2803') OR
(ALARMID=':p2804' AND ALARMGROUPID=':p2805') OR
(ALARMID=':p2806' AND ALARMGROUPID=':p2807') OR
(ALARMID=':p2808' AND ALARMGROUPID=':p2809') OR
(ALARMID=':p2810' AND ALARMGROUPID=':p2811') OR
(ALARMID=':p2812' AND ALARMGROUPID=':p2813') OR
(ALARMID=':p2814' AND ALARMGROUPID=':p2815') OR
(ALARMID=':p2816' AND ALARMGROUPID=':p2817') OR
(ALARMID=':p2818' AND ALARMGROUPID=':p2819') OR
(ALARMID=':p2820' AND ALARMGROUPID=':p2821') OR
(ALARMID=':p2822' AND ALARMGROUPID=':p2823') OR
(ALARMID=':p2824' AND ALARMGROUPID=':p2825') OR
(ALARMID=':p2826' AND ALARMGROUPID=':p2827') OR
(ALARMID=':p2828' AND ALARMGROUPID=':p2829') OR
(ALARMID=':p2830' AND ALARMGROUPID=':p2831') OR
(ALARMID=':p2832' AND ALARMGROUPID=':p2833') OR
(ALARMID=':p2834' AND ALARMGROUPID=':p2835') OR
(ALARMID=':p2836' AND ALARMGROUPID=':p2837') OR
(ALARMID=':p2838' AND ALARMGROUPID=':p2839') OR
(ALARMID=':p2840' AND ALARMGROUPID=':p2841') OR
(ALARMID=':p2842' AND ALARMGROUPID=':p2843') OR
(ALARMID=':p2844' AND ALARMGROUPID=':p2845') OR
(ALARMID=':p2846' AND ALARMGROUPID=':p2847') OR
(ALARMID=':p2848' AND ALARMGROUPID=':p2849') OR
(ALARMID=':p2850' AND ALARMGROUPID=':p2851') OR
(ALARMID=':p2852' AND ALARMGROUPID=':p2853') OR
(ALARMID=':p2854' AND ALARMGROUPID=':p2855') OR
(ALARMID=':p2856' AND ALARMGROUPID=':p2857') OR
(ALARMID=':p2858' AND ALARMGROUPID=':p2859') OR
(ALARMID=':p2860' AND ALARMGROUPID=':p2861') OR
(ALARMID=':p2862' AND ALARMGROUPID=':p2863') OR
(ALARMID=':p2864' AND ALARMGROUPID=':p2865') OR
(ALARMID=':p2866' AND ALARMGROUPID=':p2867') OR
(ALARMID=':p2868' AND ALARMGROUPID=':p2869') OR
(ALARMID=':p2870' AND ALARMGROUPID=':p2871') OR
(ALARMID=':p2872' AND ALARMGROUPID=':p2873') OR
(ALARMID=':p2874' AND ALARMGROUPID=':p2875') OR
(ALARMID=':p2876' AND ALARMGROUPID=':p2877') OR
(ALARMID=':p2878' AND ALARMGROUPID=':p2879') OR
(ALARMID=':p2880' AND ALARMGROUPID=':p2881') OR
(ALARMID=':p2882' AND ALARMGROUPID=':p2883') OR
(ALARMID=':p2884' AND ALARMGROUPID=':p2885') OR
(ALARMID=':p2886' AND ALARMGROUPID=':p2887') OR
(ALARMID=':p2888' AND ALARMGROUPID=':p2889') OR
(ALARMID=':p2890' AND ALARMGROUPID=':p2891') OR
(ALARMID=':p2892' AND ALARMGROUPID=':p2893') OR
(ALARMID=':p2894' AND ALARMGROUPID=':p2895') OR
(ALARMID=':p2896' AND ALARMGROUPID=':p2897') OR
(ALARMID=':p2898' AND ALARMGROUPID=':p2899') OR
(ALARMID=':p2900' AND ALARMGROUPID=':p2901') OR
(ALARMID=':p2902' AND ALARMGROUPID=':p2903') OR
(ALARMID=':p2904' AND ALARMGROUPID=':p2905') OR
(ALARMID=':p2906' AND ALARMGROUPID=':p2907') OR
(ALARMID=':p2908' AND ALARMGROUPID=':p2909') OR
(ALARMID=':p2910' AND ALARMGROUPID=':p2911') OR
(ALARMID=':p2912' AND ALARMGROUPID=':p2913') OR
(ALARMID=':p2914' AND ALARMGROUPID=':p2915') OR
(ALARMID=':p2916' AND ALARMGROUPID=':p2917') OR
(ALARMID=':p2918' AND ALARMGROUPID=':p2919') OR
(ALARMID=':p2920' AND ALARMGROUPID=':p2921') OR
(ALARMID=':p2922' AND ALARMGROUPID=':p2923') OR
(ALARMID=':p2924' AND ALARMGROUPID=':p2925') OR
(ALARMID=':p2926' AND ALARMGROUPID=':p2927') OR
(ALARMID=':p2928' AND ALARMGROUPID=':p2929') OR
(ALARMID=':p2930' AND ALARMGROUPID=':p2931') OR
(ALARMID=':p2932' AND ALARMGROUPID=':p2933') OR
(ALARMID=':p2934' AND ALARMGROUPID=':p2935') OR
(ALARMID=':p2936' AND ALARMGROUPID=':p2937') OR
(ALARMID=':p2938' AND ALARMGROUPID=':p2939') OR
(ALARMID=':p2940' AND ALARMGROUPID=':p2941') OR
(ALARMID=':p2942' AND ALARMGROUPID=':p2943') OR
(ALARMID=':p2944' AND ALARMGROUPID=':p2945') OR
(ALARMID=':p2946' AND ALARMGROUPID=':p2947') OR
(ALARMID=':p2948' AND ALARMGROUPID=':p2949') OR
(ALARMID=':p2950' AND ALARMGROUPID=':p2951') OR
(ALARMID=':p2952' AND ALARMGROUPID=':p2953') OR
(ALARMID=':p2954' AND ALARMGROUPID=':p2955') OR
(ALARMID=':p2956' AND ALARMGROUPID=':p2957') OR
(ALARMID=':p2958' AND ALARMGROUPID=':p2959') OR
(ALARMID=':p2960' AND ALARMGROUPID=':p2961') OR
(ALARMID=':p2962' AND ALARMGROUPID=':p2963') OR
(ALARMID=':p2964' AND ALARMGROUPID=':p2965') OR
(ALARMID=':p2966' AND ALARMGROUPID=':p2967') OR
(ALARMID=':p2968' AND ALARMGROUPID=':p2969') OR
(ALARMID=':p2970' AND ALARMGROUPID=':p2971') OR
(ALARMID=':p2972' AND ALARMGROUPID=':p2973') OR
(ALARMID=':p2974' AND ALARMGROUPID=':p2975') OR
(ALARMID=':p2976' AND ALARMGROUPID=':p2977') OR
(ALARMID=':p2978' AND ALARMGROUPID=':p2979') OR
(ALARMID=':p2980' AND ALARMGROUPID=':p2981') OR
(ALARMID=':p2982' AND ALARMGROUPID=':p2983') OR
(ALARMID=':p2984' AND ALARMGROUPID=':p2985') OR
(ALARMID=':p2986' AND ALARMGROUPID=':p2987') OR
(ALARMID=':p2988' AND ALARMGROUPID=':p2989') OR
(ALARMID=':p2990' AND ALARMGROUPID=':p2991') OR
(ALARMID=':p2992' AND ALARMGROUPID=':p2993') OR
(ALARMID=':p2994' AND ALARMGROUPID=':p2995') OR
(ALARMID=':p2996' AND ALARMGROUPID=':p2997') OR
(ALARMID=':p2998' AND ALARMGROUPID=':p2999') OR
(ALARMID=':p3000' AND ALARMGROUPID=':p3001') OR
(ALARMID=':p3002' AND ALARMGROUPID=':p3003') OR
(ALARMID=':p3004' AND ALARMGROUPID=':p3005') OR
(ALARMID=':p3006' AND ALARMGROUPID=':p3007') OR
(ALARMID=':p3008' AND ALARMGROUPID=':p3009') OR
(ALARMID=':p3010' AND ALARMGROUPID=':p3011') OR
(ALARMID=':p3012' AND ALARMGROUPID=':p3013') OR
(ALARMID=':p3014' AND ALARMGROUPID=':p3015') OR
(ALARMID=':p3016' AND ALARMGROUPID=':p3017') OR
(ALARMID=':p3018' AND ALARMGROUPID=':p3019') OR
(ALARMID=':p3020' AND ALARMGROUPID=':p3021') OR
(ALARMID=':p3022' AND ALARMGROUPID=':p3023') OR
(ALARMID=':p3024' AND ALARMGROUPID=':p3025') OR
(ALARMID=':p3026' AND ALARMGROUPID=':p3027') OR
(ALARMID=':p3028' AND ALARMGROUPID=':p3029') OR
(ALARMID=':p3030' AND ALARMGROUPID=':p3031') OR
(ALARMID=':p3032' AND ALARMGROUPID=':p3033') OR
(ALARMID=':p3034' AND ALARMGROUPID=':p3035') OR
(ALARMID=':p3036' AND ALARMGROUPID=':p3037') OR
(ALARMID=':p3038' AND ALARMGROUPID=':p3039') OR
(ALARMID=':p3040' AND ALARMGROUPID=':p3041') OR
(ALARMID=':p3042' AND ALARMGROUPID=':p3043') OR
(ALARMID=':p3044' AND ALARMGROUPID=':p3045') OR
(ALARMID=':p3046' AND ALARMGROUPID=':p3047') OR
(ALARMID=':p3048' AND ALARMGROUPID=':p3049') OR
(ALARMID=':p3050' AND ALARMGROUPID=':p3051') OR
(ALARMID=':p3052' AND ALARMGROUPID=':p3053') OR
(ALARMID=':p3054' AND ALARMGROUPID=':p3055') OR
(ALARMID=':p3056' AND ALARMGROUPID=':p3057') OR
(ALARMID=':p3058' AND ALARMGROUPID=':p3059') OR
(ALARMID=':p3060' AND ALARMGROUPID=':p3061') OR
(ALARMID=':p3062' AND ALARMGROUPID=':p3063') OR
(ALARMID=':p3064' AND ALARMGROUPID=':p3065') OR
(ALARMID=':p3066' AND ALARMGROUPID=':p3067') OR
(ALARMID=':p3068' AND ALARMGROUPID=':p3069') OR
(ALARMID=':p3070' AND ALARMGROUPID=':p3071') OR
(ALARMID=':p3072' AND ALARMGROUPID=':p3073') OR
(ALARMID=':p3074' AND ALARMGROUPID=':p3075') OR
(ALARMID=':p3076' AND ALARMGROUPID=':p3077') OR
(ALARMID=':p3078' AND ALARMGROUPID=':p3079') OR
(ALARMID=':p3080' AND ALARMGROUPID=':p3081') OR
(ALARMID=':p3082' AND ALARMGROUPID=':p3083') OR
(ALARMID=':p3084' AND ALARMGROUPID=':p3085') OR
(ALARMID=':p3086' AND ALARMGROUPID=':p3087') OR
(ALARMID=':p3088' AND ALARMGROUPID=':p3089') OR
(ALARMID=':p3090' AND ALARMGROUPID=':p3091') OR
(ALARMID=':p3092' AND ALARMGROUPID=':p3093') OR
(ALARMID=':p3094' AND ALARMGROUPID=':p3095') OR
(ALARMID=':p3096' AND ALARMGROUPID=':p3097') OR
(ALARMID=':p3098' AND ALARMGROUPID=':p3099') OR
(ALARMID=':p3100' AND ALARMGROUPID=':p3101') OR
(ALARMID=':p3102' AND ALARMGROUPID=':p3103') OR
(ALARMID=':p3104' AND ALARMGROUPID=':p3105') OR
(ALARMID=':p3106' AND ALARMGROUPID=':p3107') OR
(ALARMID=':p3108' AND ALARMGROUPID=':p3109') OR
(ALARMID=':p3110' AND ALARMGROUPID=':p3111') OR
(ALARMID=':p3112' AND ALARMGROUPID=':p3113') OR
(ALARMID=':p3114' AND ALARMGROUPID=':p3115') OR
(ALARMID=':p3116' AND ALARMGROUPID=':p3117') OR
(ALARMID=':p3118' AND ALARMGROUPID=':p3119') OR
(ALARMID=':p3120' AND ALARMGROUPID=':p3121') OR
(ALARMID=':p3122' AND ALARMGROUPID=':p3123') OR
(ALARMID=':p3124' AND ALARMGROUPID=':p3125') OR
(ALARMID=':p3126' AND ALARMGROUPID=':p3127') OR
(ALARMID=':p3128' AND ALARMGROUPID=':p3129') OR
(ALARMID=':p3130' AND ALARMGROUPID=':p3131') OR
(ALARMID=':p3132' AND ALARMGROUPID=':p3133') OR
(ALARMID=':p3134' AND ALARMGROUPID=':p3135') OR
(ALARMID=':p3136' AND ALARMGROUPID=':p3137') OR
(ALARMID=':p3138' AND ALARMGROUPID=':p3139') OR
(ALARMID=':p3140' AND ALARMGROUPID=':p3141') OR
(ALARMID=':p3142' AND ALARMGROUPID=':p3143') OR
(ALARMID=':p3144' AND ALARMGROUPID=':p3145') OR
(ALARMID=':p3146' AND ALARMGROUPID=':p3147') OR
(ALARMID=':p3148' AND ALARMGROUPID=':p3149') OR
(ALARMID=':p3150' AND ALARMGROUPID=':p3151') OR
(ALARMID=':p3152' AND ALARMGROUPID=':p3153') OR
(ALARMID=':p3154' AND ALARMGROUPID=':p3155') OR
(ALARMID=':p3156' AND ALARMGROUPID=':p3157') OR
(ALARMID=':p3158' AND ALARMGROUPID=':p3159') OR
(ALARMID=':p3160' AND ALARMGROUPID=':p3161') OR
(ALARMID=':p3162' AND ALARMGROUPID=':p3163') OR
(ALARMID=':p3164' AND ALARMGROUPID=':p3165') OR
(ALARMID=':p3166' AND ALARMGROUPID=':p3167') OR
(ALARMID=':p3168' AND ALARMGROUPID=':p3169') OR
(ALARMID=':p3170' AND ALARMGROUPID=':p3171') OR
(ALARMID=':p3172' AND ALARMGROUPID=':p3173') OR
(ALARMID=':p3174' AND ALARMGROUPID=':p3175') OR
(ALARMID=':p3176' AND ALARMGROUPID=':p3177') OR
(ALARMID=':p3178' AND ALARMGROUPID=':p3179') OR
(ALARMID=':p3180' AND ALARMGROUPID=':p3181') OR
(ALARMID=':p3182' AND ALARMGROUPID=':p3183') OR
(ALARMID=':p3184' AND ALARMGROUPID=':p3185') OR
(ALARMID=':p3186' AND ALARMGROUPID=':p3187') OR
(ALARMID=':p3188' AND ALARMGROUPID=':p3189') OR
(ALARMID=':p3190' AND ALARMGROUPID=':p3191') OR
(ALARMID=':p3192' AND ALARMGROUPID=':p3193') OR
(ALARMID=':p3194' AND ALARMGROUPID=':p3195') OR
(ALARMID=':p3196' AND ALARMGROUPID=':p3197') OR
(ALARMID=':p3198' AND ALARMGROUPID=':p3199') OR
(ALARMID=':p3200' AND ALARMGROUPID=':p3201') OR
(ALARMID=':p3202' AND ALARMGROUPID=':p3203') OR
(ALARMID=':p3204' AND ALARMGROUPID=':p3205') OR
(ALARMID=':p3206' AND ALARMGROUPID=':p3207') OR
(ALARMID=':p3208' AND ALARMGROUPID=':p3209') OR
(ALARMID=':p3210' AND ALARMGROUPID=':p3211') OR
(ALARMID=':p3212' AND ALARMGROUPID=':p3213') OR
(ALARMID=':p3214' AND ALARMGROUPID=':p3215') OR
(ALARMID=':p3216' AND ALARMGROUPID=':p3217') OR
(ALARMID=':p3218' AND ALARMGROUPID=':p3219') OR
(ALARMID=':p3220' AND ALARMGROUPID=':p3221') OR
(ALARMID=':p3222' AND ALARMGROUPID=':p3223') OR
(ALARMID=':p3224' AND ALARMGROUPID=':p3225') OR
(ALARMID=':p3226' AND ALARMGROUPID=':p3227') OR
(ALARMID=':p3228' AND ALARMGROUPID=':p3229') OR
(ALARMID=':p3230' AND ALARMGROUPID=':p3231') OR
(ALARMID=':p3232' AND ALARMGROUPID=':p3233') OR
(ALARMID=':p3234' AND ALARMGROUPID=':p3235') OR
(ALARMID=':p3236' AND ALARMGROUPID=':p3237') OR
(ALARMID=':p3238' AND ALARMGROUPID=':p3239') OR
(ALARMID=':p3240' AND ALARMGROUPID=':p3241') OR
(ALARMID=':p3242' AND ALARMGROUPID=':p3243') OR
(ALARMID=':p3244' AND ALARMGROUPID=':p3245') OR
(ALARMID=':p3246' AND ALARMGROUPID=':p3247') OR
(ALARMID=':p3248' AND ALARMGROUPID=':p3249') OR
(ALARMID=':p3250' AND ALARMGROUPID=':p3251') OR
(ALARMID=':p3252' AND ALARMGROUPID=':p3253') OR
(ALARMID=':p3254' AND ALARMGROUPID=':p3255') OR
(ALARMID=':p3256' AND ALARMGROUPID=':p3257') OR
(ALARMID=':p3258' AND ALARMGROUPID=':p3259') OR
(ALARMID=':p3260' AND ALARMGROUPID=':p3261') OR
(ALARMID=':p3262' AND ALARMGROUPID=':p3263') OR
(ALARMID=':p3264' AND ALARMGROUPID=':p3265') OR
(ALARMID=':p3266' AND ALARMGROUPID=':p3267') OR
(ALARMID=':p3268' AND ALARMGROUPID=':p3269') OR
(ALARMID=':p3270' AND ALARMGROUPID=':p3271') OR
(ALARMID=':p3272' AND ALARMGROUPID=':p3273') OR
(ALARMID=':p3274' AND ALARMGROUPID=':p3275') OR
(ALARMID=':p3276' AND ALARMGROUPID=':p3277') OR
(ALARMID=':p3278' AND ALARMGROUPID=':p3279') OR
(ALARMID=':p3280' AND ALARMGROUPID=':p3281') OR
(ALARMID=':p3282' AND ALARMGROUPID=':p3283') OR
(ALARMID=':p3284' AND ALARMGROUPID=':p3285') OR
(ALARMID=':p3286' AND ALARMGROUPID=':p3287') OR
(ALARMID=':p3288' AND ALARMGROUPID=':p3289') OR
(ALARMID=':p3290' AND ALARMGROUPID=':p3291') OR
(ALARMID=':p3292' AND ALARMGROUPID=':p3293') OR
(ALARMID=':p3294' AND ALARMGROUPID=':p3295') OR
(ALARMID=':p3296' AND ALARMGROUPID=':p3297') OR
(ALARMID=':p3298' AND ALARMGROUPID=':p3299') OR
(ALARMID=':p3300' AND ALARMGROUPID=':p3301') OR
(ALARMID=':p3302' AND ALARMGROUPID=':p3303') OR
(ALARMID=':p3304' AND ALARMGROUPID=':p3305') OR
(ALARMID=':p3306' AND ALARMGROUPID=':p3307') OR
(ALARMID=':p3308' AND ALARMGROUPID=':p3309') OR
(ALARMID=':p3310' AND ALARMGROUPID=':p3311') OR
(ALARMID=':p3312' AND ALARMGROUPID=':p3313') OR
(ALARMID=':p3314' AND ALARMGROUPID=':p3315') OR
(ALARMID=':p3316' AND ALARMGROUPID=':p3317') OR
(ALARMID=':p3318' AND ALARMGROUPID=':p3319') OR
(ALARMID=':p3320' AND ALARMGROUPID=':p3321') OR
(ALARMID=':p3322' AND ALARMGROUPID=':p3323') OR
(ALARMID=':p3324' AND ALARMGROUPID=':p3325') OR
(ALARMID=':p3326' AND ALARMGROUPID=':p3327') OR
(ALARMID=':p3328' AND ALARMGROUPID=':p3329') OR
(ALARMID=':p3330' AND ALARMGROUPID=':p3331') OR
(ALARMID=':p3332' AND ALARMGROUPID=':p3333') OR
(ALARMID=':p3334' AND ALARMGROUPID=':p3335') OR
(ALARMID=':p3336' AND ALARMGROUPID=':p3337') OR
(ALARMID=':p3338' AND ALARMGROUPID=':p3339') OR
(ALARMID=':p3340' AND ALARMGROUPID=':p3341') OR
(ALARMID=':p3342' AND ALARMGROUPID=':p3343') OR
(ALARMID=':p3344' AND ALARMGROUPID=':p3345') OR
(ALARMID=':p3346' AND ALARMGROUPID=':p3347') OR
(ALARMID=':p3348' AND ALARMGROUPID=':p3349') OR
(ALARMID=':p3350' AND ALARMGROUPID=':p3351') OR
(ALARMID=':p3352' AND ALARMGROUPID=':p3353') OR
(ALARMID=':p3354' AND ALARMGROUPID=':p3355') OR
(ALARMID=':p3356' AND ALARMGROUPID=':p3357') OR
(ALARMID=':p3358' AND ALARMGROUPID=':p3359') OR
(ALARMID=':p3360' AND ALARMGROUPID=':p3361') OR
(ALARMID=':p3362' AND ALARMGROUPID=':p3363') OR
(ALARMID=':p3364' AND ALARMGROUPID=':p3365') OR
(ALARMID=':p3366' AND ALARMGROUPID=':p3367') OR
(ALARMID=':p3368' AND ALARMGROUPID=':p3369') OR
(ALARMID=':p3370' AND ALARMGROUPID=':p3371') OR
(ALARMID=':p3372' AND ALARMGROUPID=':p3373') OR
(ALARMID=':p3374' AND ALARMGROUPID=':p3375') OR
(ALARMID=':p3376' AND ALARMGROUPID=':p3377') OR
(ALARMID=':p3378' AND ALARMGROUPID=':p3379') OR
(ALARMID=':p3380' AND ALARMGROUPID=':p3381') OR
(ALARMID=':p3382' AND ALARMGROUPID=':p3383') OR
(ALARMID=':p3384' AND ALARMGROUPID=':p3385') OR
(ALARMID=':p3386' AND ALARMGROUPID=':p3387') OR
(ALARMID=':p3388' AND ALARMGROUPID=':p3389') OR
(ALARMID=':p3390' AND ALARMGROUPID=':p3391') OR
(ALARMID=':p3392' AND ALARMGROUPID=':p3393') OR
(ALARMID=':p3394' AND ALARMGROUPID=':p3395') OR
(ALARMID=':p3396' AND ALARMGROUPID=':p3397') OR
(ALARMID=':p3398' AND ALARMGROUPID=':p3399') OR
(ALARMID=':p3400' AND ALARMGROUPID=':p3401') OR
(ALARMID=':p3402' AND ALARMGROUPID=':p3403') OR
(ALARMID=':p3404' AND ALARMGROUPID=':p3405') OR
(ALARMID=':p3406' AND ALARMGROUPID=':p3407') OR
(ALARMID=':p3408' AND ALARMGROUPID=':p3409') OR
(ALARMID=':p3410' AND ALARMGROUPID=':p3411') OR
(ALARMID=':p3412' AND ALARMGROUPID=':p3413') OR
(ALARMID=':p3414' AND ALARMGROUPID=':p3415') OR
(ALARMID=':p3416' AND ALARMGROUPID=':p3417') OR
(ALARMID=':p3418' AND ALARMGROUPID=':p3419') OR
(ALARMID=':p3420' AND ALARMGROUPID=':p3421') OR
(ALARMID=':p3422' AND ALARMGROUPID=':p3423') OR
(ALARMID=':p3424' AND ALARMGROUPID=':p3425') OR
(ALARMID=':p3426' AND ALARMGROUPID=':p3427') OR
(ALARMID=':p3428' AND ALARMGROUPID=':p3429') OR
(ALARMID=':p3430' AND ALARMGROUPID=':p3431') OR
(ALARMID=':p3432' AND ALARMGROUPID=':p3433') OR
(ALARMID=':p3434' AND ALARMGROUPID=':p3435') OR
(ALARMID=':p3436' AND ALARMGROUPID=':p3437') OR
(ALARMID=':p3438' AND ALARMGROUPID=':p3439') OR
(ALARMID=':p3440' AND ALARMGROUPID=':p3441') OR
(ALARMID=':p3442' AND ALARMGROUPID=':p3443') OR
(ALARMID=':p3444' AND ALARMGROUPID=':p3445') OR
(ALARMID=':p3446' AND ALARMGROUPID=':p3447') OR
(ALARMID=':p3448' AND ALARMGROUPID=':p3449') OR
(ALARMID=':p3450' AND ALARMGROUPID=':p3451') OR
(ALARMID=':p3452' AND ALARMGROUPID=':p3453') OR
(ALARMID=':p3454' AND ALARMGROUPID=':p3455') OR
(ALARMID=':p3456' AND ALARMGROUPID=':p3457') OR
(ALARMID=':p3458' AND ALARMGROUPID=':p3459') OR
(ALARMID=':p3460' AND ALARMGROUPID=':p3461') OR
(ALARMID=':p3462' AND ALARMGROUPID=':p3463') OR
(ALARMID=':p3464' AND ALARMGROUPID=':p3465') OR
(ALARMID=':p2' AND ALARMGROUPID=':p3') OR 
(ALARMID=':p4' AND ALARMGROUPID=':p5') OR
(ALARMID=':p6' AND ALARMGROUPID=':p7') OR
(ALARMID=':p8' AND ALARMGROUPID=':p9') OR
(ALARMID=':p10' AND ALARMGROUPID=':p11') OR
(ALARMID=':p12' AND ALARMGROUPID=':p13') OR
(ALARMID=':p14' AND ALARMGROUPID=':p15') OR
(ALARMID=':p16' AND ALARMGROUPID=':p17') OR
(ALARMID=':p18' AND ALARMGROUPID=':p19') OR
(ALARMID=':p20' AND ALARMGROUPID=':p21') OR
(ALARMID=':p22' AND ALARMGROUPID=':p23') OR
(ALARMID=':p24' AND ALARMGROUPID=':p25') OR
(ALARMID=':p26' AND ALARMGROUPID=':p27') OR
(ALARMID=':p28' AND ALARMGROUPID=':p29') OR
(ALARMID=':p30' AND ALARMGROUPID=':p31') OR
(ALARMID=':p32' AND ALARMGROUPID=':p33') OR
(ALARMID=':p34' AND ALARMGROUPID=':p35') OR
(ALARMID=':p36' AND ALARMGROUPID=':p37') OR
(ALARMID=':p38' AND ALARMGROUPID=':p39') OR
(ALARMID=':p40' AND ALARMGROUPID=':p41') OR
(ALARMID=':p42' AND ALARMGROUPID=':p43') OR
(ALARMID=':p44' AND ALARMGROUPID=':p45') OR
(ALARMID=':p46' AND ALARMGROUPID=':p47') OR
(ALARMID=':p48' AND ALARMGROUPID=':p49') OR
(ALARMID=':p50' AND ALARMGROUPID=':p51') OR
(ALARMID=':p52' AND ALARMGROUPID=':p53') OR
(ALARMID=':p54' AND ALARMGROUPID=':p55') OR
(ALARMID=':p56' AND ALARMGROUPID=':p57') OR
(ALARMID=':p58' AND ALARMGROUPID=':p59') OR
(ALARMID=':p60' AND ALARMGROUPID=':p61') OR
(ALARMID=':p62' AND ALARMGROUPID=':p63') OR
(ALARMID=':p64' AND ALARMGROUPID=':p65') OR
(ALARMID=':p66' AND ALARMGROUPID=':p67') OR
(ALARMID=':p68' AND ALARMGROUPID=':p69') OR
(ALARMID=':p70' AND ALARMGROUPID=':p71') OR
(ALARMID=':p72' AND ALARMGROUPID=':p73') OR
(ALARMID=':p74' AND ALARMGROUPID=':p75') OR
(ALARMID=':p76' AND ALARMGROUPID=':p77') OR
(ALARMID=':p78' AND ALARMGROUPID=':p79') OR
(ALARMID=':p80' AND ALARMGROUPID=':p81') OR
(ALARMID=':p82' AND ALARMGROUPID=':p83') OR
(ALARMID=':p84' AND ALARMGROUPID=':p85') OR
(ALARMID=':p86' AND ALARMGROUPID=':p87') OR
(ALARMID=':p88' AND ALARMGROUPID=':p89') OR
(ALARMID=':p90' AND ALARMGROUPID=':p91') OR
(ALARMID=':p92' AND ALARMGROUPID=':p93') OR
(ALARMID=':p94' AND ALARMGROUPID=':p95') OR
(ALARMID=':p96' AND ALARMGROUPID=':p97') OR
(ALARMID=':p98' AND ALARMGROUPID=':p99') OR
(ALARMID=':p100' AND ALARMGROUPID=':p101') OR
(ALARMID=':p102' AND ALARMGROUPID=':p103') OR
(ALARMID=':p104' AND ALARMGROUPID=':p105') OR
(ALARMID=':p106' AND ALARMGROUPID=':p107') OR
(ALARMID=':p108' AND ALARMGROUPID=':p109') OR
(ALARMID=':p110' AND ALARMGROUPID=':p111') OR
(ALARMID=':p112' AND ALARMGROUPID=':p113') OR
(ALARMID=':p114' AND ALARMGROUPID=':p115') OR
(ALARMID=':p116' AND ALARMGROUPID=':p117') OR
(ALARMID=':p118' AND ALARMGROUPID=':p119') OR
(ALARMID=':p120' AND ALARMGROUPID=':p121') OR
(ALARMID=':p122' AND ALARMGROUPID=':p123') OR
(ALARMID=':p124' AND ALARMGROUPID=':p125') OR
(ALARMID=':p126' AND ALARMGROUPID=':p127') OR
(ALARMID=':p128' AND ALARMGROUPID=':p129') OR
(ALARMID=':p130' AND ALARMGROUPID=':p131') OR
(ALARMID=':p132' AND ALARMGROUPID=':p133') OR
(ALARMID=':p134' AND ALARMGROUPID=':p135') OR
(ALARMID=':p136' AND ALARMGROUPID=':p137') OR
(ALARMID=':p138' AND ALARMGROUPID=':p139') OR
(ALARMID=':p140' AND ALARMGROUPID=':p141') OR
(ALARMID=':p142' AND ALARMGROUPID=':p143') OR
(ALARMID=':p144' AND ALARMGROUPID=':p145') OR
(ALARMID=':p146' AND ALARMGROUPID=':p147') OR
(ALARMID=':p148' AND ALARMGROUPID=':p149') OR
(ALARMID=':p150' AND ALARMGROUPID=':p151') OR
(ALARMID=':p152' AND ALARMGROUPID=':p153') OR
(ALARMID=':p154' AND ALARMGROUPID=':p155') OR
(ALARMID=':p156' AND ALARMGROUPID=':p157') OR
(ALARMID=':p158' AND ALARMGROUPID=':p159') OR
(ALARMID=':p160' AND ALARMGROUPID=':p161') OR
(ALARMID=':p162' AND ALARMGROUPID=':p163') OR
(ALARMID=':p164' AND ALARMGROUPID=':p165') OR
(ALARMID=':p166' AND ALARMGROUPID=':p167') OR
(ALARMID=':p168' AND ALARMGROUPID=':p169') OR
(ALARMID=':p170' AND ALARMGROUPID=':p171') OR
(ALARMID=':p172' AND ALARMGROUPID=':p173') OR
(ALARMID=':p174' AND ALARMGROUPID=':p175') OR
(ALARMID=':p176' AND ALARMGROUPID=':p177') OR
(ALARMID=':p178' AND ALARMGROUPID=':p179') OR
(ALARMID=':p180' AND ALARMGROUPID=':p181') OR
(ALARMID=':p182' AND ALARMGROUPID=':p183') OR
(ALARMID=':p184' AND ALARMGROUPID=':p185') OR
(ALARMID=':p186' AND ALARMGROUPID=':p187') OR
(ALARMID=':p188' AND ALARMGROUPID=':p189') OR
(ALARMID=':p190' AND ALARMGROUPID=':p191') OR
(ALARMID=':p192' AND ALARMGROUPID=':p193') OR
(ALARMID=':p194' AND ALARMGROUPID=':p195') OR
(ALARMID=':p196' AND ALARMGROUPID=':p197') OR
(ALARMID=':p198' AND ALARMGROUPID=':p199') OR
(ALARMID=':p200' AND ALARMGROUPID=':p201') OR
(ALARMID=':p202' AND ALARMGROUPID=':p203') OR
(ALARMID=':p204' AND ALARMGROUPID=':p205') OR
(ALARMID=':p206' AND ALARMGROUPID=':p207') OR
(ALARMID=':p208' AND ALARMGROUPID=':p209') OR
(ALARMID=':p210' AND ALARMGROUPID=':p211') OR
(ALARMID=':p212' AND ALARMGROUPID=':p213') OR
(ALARMID=':p214' AND ALARMGROUPID=':p215') OR
(ALARMID=':p216' AND ALARMGROUPID=':p217') OR
(ALARMID=':p218' AND ALARMGROUPID=':p219') OR
(ALARMID=':p220' AND ALARMGROUPID=':p221') OR
(ALARMID=':p222' AND ALARMGROUPID=':p223') OR
(ALARMID=':p224' AND ALARMGROUPID=':p225') OR
(ALARMID=':p226' AND ALARMGROUPID=':p227') OR
(ALARMID=':p228' AND ALARMGROUPID=':p229') OR
(ALARMID=':p230' AND ALARMGROUPID=':p231') OR
(ALARMID=':p232' AND ALARMGROUPID=':p233') OR
(ALARMID=':p234' AND ALARMGROUPID=':p235') OR
(ALARMID=':p236' AND ALARMGROUPID=':p237') OR
(ALARMID=':p238' AND ALARMGROUPID=':p239') OR
(ALARMID=':p240' AND ALARMGROUPID=':p241') OR
(ALARMID=':p242' AND ALARMGROUPID=':p243') OR
(ALARMID=':p244' AND ALARMGROUPID=':p245') OR
(ALARMID=':p246' AND ALARMGROUPID=':p247') OR
(ALARMID=':p248' AND ALARMGROUPID=':p249') OR
(ALARMID=':p250' AND ALARMGROUPID=':p251') OR
(ALARMID=':p252' AND ALARMGROUPID=':p253') OR
(ALARMID=':p254' AND ALARMGROUPID=':p255') OR
(ALARMID=':p256' AND ALARMGROUPID=':p257') OR
(ALARMID=':p258' AND ALARMGROUPID=':p259') OR
(ALARMID=':p260' AND ALARMGROUPID=':p261') OR
(ALARMID=':p262' AND ALARMGROUPID=':p263') OR
(ALARMID=':p264' AND ALARMGROUPID=':p265') OR
(ALARMID=':p266' AND ALARMGROUPID=':p267') OR
(ALARMID=':p268' AND ALARMGROUPID=':p269') OR
(ALARMID=':p270' AND ALARMGROUPID=':p271') OR
(ALARMID=':p272' AND ALARMGROUPID=':p273') OR
(ALARMID=':p274' AND ALARMGROUPID=':p275') OR
(ALARMID=':p276' AND ALARMGROUPID=':p277') OR
(ALARMID=':p278' AND ALARMGROUPID=':p279') OR
(ALARMID=':p280' AND ALARMGROUPID=':p281') OR
(ALARMID=':p282' AND ALARMGROUPID=':p283') OR
(ALARMID=':p284' AND ALARMGROUPID=':p285') OR
(ALARMID=':p286' AND ALARMGROUPID=':p287') OR
(ALARMID=':p288' AND ALARMGROUPID=':p289') OR
(ALARMID=':p290' AND ALARMGROUPID=':p291') OR
(ALARMID=':p292' AND ALARMGROUPID=':p293') OR
(ALARMID=':p294' AND ALARMGROUPID=':p295') OR
(ALARMID=':p296' AND ALARMGROUPID=':p297') OR
(ALARMID=':p298' AND ALARMGROUPID=':p299') OR
(ALARMID=':p300' AND ALARMGROUPID=':p301') OR
(ALARMID=':p302' AND ALARMGROUPID=':p303') OR
(ALARMID=':p304' AND ALARMGROUPID=':p305') OR
(ALARMID=':p306' AND ALARMGROUPID=':p307') OR
(ALARMID=':p308' AND ALARMGROUPID=':p309') OR
(ALARMID=':p310' AND ALARMGROUPID=':p311') OR
(ALARMID=':p312' AND ALARMGROUPID=':p313') OR
(ALARMID=':p314' AND ALARMGROUPID=':p315') OR
(ALARMID=':p316' AND ALARMGROUPID=':p317') OR
(ALARMID=':p318' AND ALARMGROUPID=':p319') OR
(ALARMID=':p320' AND ALARMGROUPID=':p321') OR
(ALARMID=':p322' AND ALARMGROUPID=':p323') OR
(ALARMID=':p324' AND ALARMGROUPID=':p325') OR
(ALARMID=':p326' AND ALARMGROUPID=':p327') OR
(ALARMID=':p328' AND ALARMGROUPID=':p329') OR
(ALARMID=':p330' AND ALARMGROUPID=':p331') OR
(ALARMID=':p332' AND ALARMGROUPID=':p333') OR
(ALARMID=':p334' AND ALARMGROUPID=':p335') OR
(ALARMID=':p336' AND ALARMGROUPID=':p337') OR
(ALARMID=':p338' AND ALARMGROUPID=':p339') OR
(ALARMID=':p340' AND ALARMGROUPID=':p341') OR
(ALARMID=':p342' AND ALARMGROUPID=':p343') OR
(ALARMID=':p344' AND ALARMGROUPID=':p345') OR
(ALARMID=':p346' AND ALARMGROUPID=':p347') OR
(ALARMID=':p348' AND ALARMGROUPID=':p349') OR
(ALARMID=':p350' AND ALARMGROUPID=':p351') OR
(ALARMID=':p352' AND ALARMGROUPID=':p353') OR
(ALARMID=':p354' AND ALARMGROUPID=':p355') OR
(ALARMID=':p356' AND ALARMGROUPID=':p357') OR
(ALARMID=':p358' AND ALARMGROUPID=':p359') OR
(ALARMID=':p360' AND ALARMGROUPID=':p361') OR
(ALARMID=':p362' AND ALARMGROUPID=':p363') OR
(ALARMID=':p364' AND ALARMGROUPID=':p365') OR
(ALARMID=':p366' AND ALARMGROUPID=':p367') OR
(ALARMID=':p368' AND ALARMGROUPID=':p369') OR
(ALARMID=':p370' AND ALARMGROUPID=':p371') OR
(ALARMID=':p372' AND ALARMGROUPID=':p373') OR
(ALARMID=':p374' AND ALARMGROUPID=':p375') OR
(ALARMID=':p376' AND ALARMGROUPID=':p377') OR
(ALARMID=':p378' AND ALARMGROUPID=':p379') OR
(ALARMID=':p380' AND ALARMGROUPID=':p381') OR
(ALARMID=':p382' AND ALARMGROUPID=':p383') OR
(ALARMID=':p384' AND ALARMGROUPID=':p385') OR
(ALARMID=':p386' AND ALARMGROUPID=':p387') OR
(ALARMID=':p388' AND ALARMGROUPID=':p389') OR
(ALARMID=':p390' AND ALARMGROUPID=':p391') OR
(ALARMID=':p392' AND ALARMGROUPID=':p393') OR
(ALARMID=':p394' AND ALARMGROUPID=':p395') OR
(ALARMID=':p396' AND ALARMGROUPID=':p397') OR
(ALARMID=':p398' AND ALARMGROUPID=':p399') OR
(ALARMID=':p400' AND ALARMGROUPID=':p401') OR
(ALARMID=':p402' AND ALARMGROUPID=':p403') OR
(ALARMID=':p404' AND ALARMGROUPID=':p405') OR
(ALARMID=':p406' AND ALARMGROUPID=':p407') OR
(ALARMID=':p408' AND ALARMGROUPID=':p409') OR
(ALARMID=':p410' AND ALARMGROUPID=':p411') OR
(ALARMID=':p412' AND ALARMGROUPID=':p413') OR
(ALARMID=':p414' AND ALARMGROUPID=':p415') OR
(ALARMID=':p416' AND ALARMGROUPID=':p417') OR
(ALARMID=':p418' AND ALARMGROUPID=':p419') OR
(ALARMID=':p420' AND ALARMGROUPID=':p421') OR
(ALARMID=':p422' AND ALARMGROUPID=':p423') OR
(ALARMID=':p424' AND ALARMGROUPID=':p425') OR
(ALARMID=':p426' AND ALARMGROUPID=':p427') OR
(ALARMID=':p428' AND ALARMGROUPID=':p429') OR
(ALARMID=':p430' AND ALARMGROUPID=':p431') OR
(ALARMID=':p432' AND ALARMGROUPID=':p433') OR
(ALARMID=':p434' AND ALARMGROUPID=':p435') OR
(ALARMID=':p436' AND ALARMGROUPID=':p437') OR
(ALARMID=':p438' AND ALARMGROUPID=':p439') OR
(ALARMID=':p440' AND ALARMGROUPID=':p441') OR
(ALARMID=':p442' AND ALARMGROUPID=':p443') OR
(ALARMID=':p444' AND ALARMGROUPID=':p445') OR
(ALARMID=':p446' AND ALARMGROUPID=':p447') OR
(ALARMID=':p448' AND ALARMGROUPID=':p449') OR
(ALARMID=':p450' AND ALARMGROUPID=':p451') OR
(ALARMID=':p452' AND ALARMGROUPID=':p453') OR
(ALARMID=':p454' AND ALARMGROUPID=':p455') OR
(ALARMID=':p456' AND ALARMGROUPID=':p457') OR
(ALARMID=':p458' AND ALARMGROUPID=':p459') OR
(ALARMID=':p460' AND ALARMGROUPID=':p461') OR
(ALARMID=':p462' AND ALARMGROUPID=':p463') OR
(ALARMID=':p464' AND ALARMGROUPID=':p465') OR
(ALARMID=':p466' AND ALARMGROUPID=':p467') OR
(ALARMID=':p468' AND ALARMGROUPID=':p469') OR
(ALARMID=':p470' AND ALARMGROUPID=':p471') OR
(ALARMID=':p472' AND ALARMGROUPID=':p473') OR
(ALARMID=':p474' AND ALARMGROUPID=':p475') OR
(ALARMID=':p476' AND ALARMGROUPID=':p477') OR
(ALARMID=':p478' AND ALARMGROUPID=':p479') OR
(ALARMID=':p480' AND ALARMGROUPID=':p481') OR
(ALARMID=':p482' AND ALARMGROUPID=':p483') OR
(ALARMID=':p484' AND ALARMGROUPID=':p485') OR
(ALARMID=':p486' AND ALARMGROUPID=':p487') OR
(ALARMID=':p488' AND ALARMGROUPID=':p489') OR
(ALARMID=':p490' AND ALARMGROUPID=':p491') OR
(ALARMID=':p492' AND ALARMGROUPID=':p493') OR
(ALARMID=':p494' AND ALARMGROUPID=':p495') OR
(ALARMID=':p496' AND ALARMGROUPID=':p497') OR
(ALARMID=':p498' AND ALARMGROUPID=':p499') OR
(ALARMID=':p500' AND ALARMGROUPID=':p501') OR
(ALARMID=':p502' AND ALARMGROUPID=':p503') OR
(ALARMID=':p504' AND ALARMGROUPID=':p505') OR
(ALARMID=':p506' AND ALARMGROUPID=':p507') OR
(ALARMID=':p508' AND ALARMGROUPID=':p509') OR
(ALARMID=':p510' AND ALARMGROUPID=':p511') OR
(ALARMID=':p512' AND ALARMGROUPID=':p513') OR
(ALARMID=':p514' AND ALARMGROUPID=':p515') OR
(ALARMID=':p516' AND ALARMGROUPID=':p517') OR
(ALARMID=':p518' AND ALARMGROUPID=':p519') OR
(ALARMID=':p520' AND ALARMGROUPID=':p521') OR
(ALARMID=':p522' AND ALARMGROUPID=':p523') OR
(ALARMID=':p524' AND ALARMGROUPID=':p525') OR
(ALARMID=':p526' AND ALARMGROUPID=':p527') OR
(ALARMID=':p528' AND ALARMGROUPID=':p529') OR
(ALARMID=':p530' AND ALARMGROUPID=':p531') OR
(ALARMID=':p532' AND ALARMGROUPID=':p533') OR
(ALARMID=':p534' AND ALARMGROUPID=':p535') OR
(ALARMID=':p536' AND ALARMGROUPID=':p537') OR
(ALARMID=':p538' AND ALARMGROUPID=':p539') OR
(ALARMID=':p540' AND ALARMGROUPID=':p541') OR
(ALARMID=':p542' AND ALARMGROUPID=':p543') OR
(ALARMID=':p544' AND ALARMGROUPID=':p545') OR
(ALARMID=':p546' AND ALARMGROUPID=':p547') OR
(ALARMID=':p548' AND ALARMGROUPID=':p549') OR
(ALARMID=':p550' AND ALARMGROUPID=':p551') OR
(ALARMID=':p552' AND ALARMGROUPID=':p553') OR
(ALARMID=':p554' AND ALARMGROUPID=':p555') OR
(ALARMID=':p556' AND ALARMGROUPID=':p557') OR
(ALARMID=':p558' AND ALARMGROUPID=':p559') OR
(ALARMID=':p560' AND ALARMGROUPID=':p561') OR
(ALARMID=':p562' AND ALARMGROUPID=':p563') OR
(ALARMID=':p564' AND ALARMGROUPID=':p565') OR
(ALARMID=':p566' AND ALARMGROUPID=':p567') OR
(ALARMID=':p568' AND ALARMGROUPID=':p569') OR
(ALARMID=':p570' AND ALARMGROUPID=':p571') OR
(ALARMID=':p572' AND ALARMGROUPID=':p573') OR
(ALARMID=':p574' AND ALARMGROUPID=':p575') OR
(ALARMID=':p576' AND ALARMGROUPID=':p577') OR
(ALARMID=':p578' AND ALARMGROUPID=':p579') OR
(ALARMID=':p580' AND ALARMGROUPID=':p581') OR
(ALARMID=':p582' AND ALARMGROUPID=':p583') OR
(ALARMID=':p584' AND ALARMGROUPID=':p585') OR
(ALARMID=':p586' AND ALARMGROUPID=':p587') OR
(ALARMID=':p588' AND ALARMGROUPID=':p589') OR
(ALARMID=':p590' AND ALARMGROUPID=':p591') OR
(ALARMID=':p592' AND ALARMGROUPID=':p593') OR
(ALARMID=':p594' AND ALARMGROUPID=':p595') OR
(ALARMID=':p596' AND ALARMGROUPID=':p597') OR
(ALARMID=':p598' AND ALARMGROUPID=':p599') OR
(ALARMID=':p600' AND ALARMGROUPID=':p601') OR
(ALARMID=':p602' AND ALARMGROUPID=':p603') OR
(ALARMID=':p604' AND ALARMGROUPID=':p605') OR
(ALARMID=':p606' AND ALARMGROUPID=':p607') OR
(ALARMID=':p608' AND ALARMGROUPID=':p609') OR
(ALARMID=':p610' AND ALARMGROUPID=':p611') OR
(ALARMID=':p612' AND ALARMGROUPID=':p613') OR
(ALARMID=':p614' AND ALARMGROUPID=':p615') OR
(ALARMID=':p616' AND ALARMGROUPID=':p617') OR
(ALARMID=':p618' AND ALARMGROUPID=':p619') OR
(ALARMID=':p620' AND ALARMGROUPID=':p621') OR
(ALARMID=':p622' AND ALARMGROUPID=':p623') OR
(ALARMID=':p624' AND ALARMGROUPID=':p625') OR
(ALARMID=':p626' AND ALARMGROUPID=':p627') OR
(ALARMID=':p628' AND ALARMGROUPID=':p629') OR
(ALARMID=':p630' AND ALARMGROUPID=':p631') OR
(ALARMID=':p632' AND ALARMGROUPID=':p633') OR
(ALARMID=':p634' AND ALARMGROUPID=':p635') OR
(ALARMID=':p636' AND ALARMGROUPID=':p637') OR
(ALARMID=':p638' AND ALARMGROUPID=':p639') OR
(ALARMID=':p640' AND ALARMGROUPID=':p641') OR
(ALARMID=':p642' AND ALARMGROUPID=':p643') OR
(ALARMID=':p644' AND ALARMGROUPID=':p645') OR
(ALARMID=':p646' AND ALARMGROUPID=':p647') OR
(ALARMID=':p648' AND ALARMGROUPID=':p649') OR
(ALARMID=':p650' AND ALARMGROUPID=':p651') OR
(ALARMID=':p652' AND ALARMGROUPID=':p653') OR
(ALARMID=':p654' AND ALARMGROUPID=':p655') OR
(ALARMID=':p656' AND ALARMGROUPID=':p657') OR
(ALARMID=':p658' AND ALARMGROUPID=':p659') OR
(ALARMID=':p660' AND ALARMGROUPID=':p661') OR
(ALARMID=':p662' AND ALARMGROUPID=':p663') OR
(ALARMID=':p664' AND ALARMGROUPID=':p665') OR
(ALARMID=':p666' AND ALARMGROUPID=':p667') OR
(ALARMID=':p668' AND ALARMGROUPID=':p669') OR
(ALARMID=':p670' AND ALARMGROUPID=':p671') OR
(ALARMID=':p672' AND ALARMGROUPID=':p673') OR
(ALARMID=':p674' AND ALARMGROUPID=':p675') OR
(ALARMID=':p676' AND ALARMGROUPID=':p677') OR
(ALARMID=':p678' AND ALARMGROUPID=':p679') OR
(ALARMID=':p680' AND ALARMGROUPID=':p681') OR
(ALARMID=':p682' AND ALARMGROUPID=':p683') OR
(ALARMID=':p684' AND ALARMGROUPID=':p685') OR
(ALARMID=':p686' AND ALARMGROUPID=':p687') OR
(ALARMID=':p688' AND ALARMGROUPID=':p689') OR
(ALARMID=':p690' AND ALARMGROUPID=':p691') OR
(ALARMID=':p692' AND ALARMGROUPID=':p693') OR
(ALARMID=':p694' AND ALARMGROUPID=':p695') OR
(ALARMID=':p696' AND ALARMGROUPID=':p697') OR
(ALARMID=':p698' AND ALARMGROUPID=':p699') OR
(ALARMID=':p700' AND ALARMGROUPID=':p701') OR
(ALARMID=':p702' AND ALARMGROUPID=':p703') OR
(ALARMID=':p704' AND ALARMGROUPID=':p705') OR
(ALARMID=':p706' AND ALARMGROUPID=':p707') OR
(ALARMID=':p708' AND ALARMGROUPID=':p709') OR
(ALARMID=':p710' AND ALARMGROUPID=':p711') OR
(ALARMID=':p712' AND ALARMGROUPID=':p713') OR
(ALARMID=':p714' AND ALARMGROUPID=':p715') OR
(ALARMID=':p716' AND ALARMGROUPID=':p717') OR
(ALARMID=':p718' AND ALARMGROUPID=':p719') OR
(ALARMID=':p720' AND ALARMGROUPID=':p721') OR
(ALARMID=':p722' AND ALARMGROUPID=':p723') OR
(ALARMID=':p724' AND ALARMGROUPID=':p725') OR
(ALARMID=':p726' AND ALARMGROUPID=':p727') OR
(ALARMID=':p728' AND ALARMGROUPID=':p729') OR
(ALARMID=':p730' AND ALARMGROUPID=':p731') OR
(ALARMID=':p732' AND ALARMGROUPID=':p733') OR
(ALARMID=':p734' AND ALARMGROUPID=':p735') OR
(ALARMID=':p736' AND ALARMGROUPID=':p737') OR
(ALARMID=':p738' AND ALARMGROUPID=':p739') OR
(ALARMID=':p740' AND ALARMGROUPID=':p741') OR
(ALARMID=':p742' AND ALARMGROUPID=':p743') OR
(ALARMID=':p744' AND ALARMGROUPID=':p745') OR
(ALARMID=':p746' AND ALARMGROUPID=':p747') OR
(ALARMID=':p748' AND ALARMGROUPID=':p749') OR
(ALARMID=':p750' AND ALARMGROUPID=':p751') OR
(ALARMID=':p752' AND ALARMGROUPID=':p753') OR
(ALARMID=':p754' AND ALARMGROUPID=':p755') OR
(ALARMID=':p756' AND ALARMGROUPID=':p757') OR
(ALARMID=':p758' AND ALARMGROUPID=':p759') OR
(ALARMID=':p760' AND ALARMGROUPID=':p761') OR
(ALARMID=':p762' AND ALARMGROUPID=':p763') OR
(ALARMID=':p764' AND ALARMGROUPID=':p765') OR
(ALARMID=':p766' AND ALARMGROUPID=':p767') OR
(ALARMID=':p768' AND ALARMGROUPID=':p769') OR
(ALARMID=':p770' AND ALARMGROUPID=':p771') OR
(ALARMID=':p772' AND ALARMGROUPID=':p773') OR
(ALARMID=':p774' AND ALARMGROUPID=':p775') OR
(ALARMID=':p776' AND ALARMGROUPID=':p777') OR
(ALARMID=':p778' AND ALARMGROUPID=':p779') OR
(ALARMID=':p780' AND ALARMGROUPID=':p781') OR
(ALARMID=':p782' AND ALARMGROUPID=':p783') OR
(ALARMID=':p784' AND ALARMGROUPID=':p785') OR
(ALARMID=':p786' AND ALARMGROUPID=':p787') OR
(ALARMID=':p788' AND ALARMGROUPID=':p789') OR
(ALARMID=':p790' AND ALARMGROUPID=':p791') OR
(ALARMID=':p792' AND ALARMGROUPID=':p793') OR
(ALARMID=':p794' AND ALARMGROUPID=':p795') OR
(ALARMID=':p796' AND ALARMGROUPID=':p797') OR
(ALARMID=':p798' AND ALARMGROUPID=':p799') OR
(ALARMID=':p800' AND ALARMGROUPID=':p801') OR
(ALARMID=':p802' AND ALARMGROUPID=':p803') OR
(ALARMID=':p804' AND ALARMGROUPID=':p805') OR
(ALARMID=':p806' AND ALARMGROUPID=':p807') OR
(ALARMID=':p808' AND ALARMGROUPID=':p809') OR
(ALARMID=':p810' AND ALARMGROUPID=':p811') OR
(ALARMID=':p812' AND ALARMGROUPID=':p813') OR
(ALARMID=':p814' AND ALARMGROUPID=':p815') OR
(ALARMID=':p816' AND ALARMGROUPID=':p817') OR
(ALARMID=':p818' AND ALARMGROUPID=':p819') OR
(ALARMID=':p820' AND ALARMGROUPID=':p821') OR
(ALARMID=':p822' AND ALARMGROUPID=':p823') OR
(ALARMID=':p824' AND ALARMGROUPID=':p825') OR
(ALARMID=':p826' AND ALARMGROUPID=':p827') OR
(ALARMID=':p828' AND ALARMGROUPID=':p829') OR
(ALARMID=':p830' AND ALARMGROUPID=':p831') OR
(ALARMID=':p832' AND ALARMGROUPID=':p833') OR
(ALARMID=':p834' AND ALARMGROUPID=':p835') OR
(ALARMID=':p836' AND ALARMGROUPID=':p837') OR
(ALARMID=':p838' AND ALARMGROUPID=':p839') OR
(ALARMID=':p840' AND ALARMGROUPID=':p841') OR
(ALARMID=':p842' AND ALARMGROUPID=':p843') OR
(ALARMID=':p844' AND ALARMGROUPID=':p845') OR
(ALARMID=':p846' AND ALARMGROUPID=':p847') OR
(ALARMID=':p848' AND ALARMGROUPID=':p849') OR
(ALARMID=':p850' AND ALARMGROUPID=':p851') OR
(ALARMID=':p852' AND ALARMGROUPID=':p853') OR
(ALARMID=':p854' AND ALARMGROUPID=':p855') OR
(ALARMID=':p856' AND ALARMGROUPID=':p857') OR
(ALARMID=':p858' AND ALARMGROUPID=':p859') OR
(ALARMID=':p860' AND ALARMGROUPID=':p861') OR
(ALARMID=':p862' AND ALARMGROUPID=':p863') OR
(ALARMID=':p864' AND ALARMGROUPID=':p865') OR
(ALARMID=':p866' AND ALARMGROUPID=':p867') OR
(ALARMID=':p868' AND ALARMGROUPID=':p869') OR
(ALARMID=':p870' AND ALARMGROUPID=':p871') OR
(ALARMID=':p872' AND ALARMGROUPID=':p873') OR
(ALARMID=':p874' AND ALARMGROUPID=':p875') OR
(ALARMID=':p876' AND ALARMGROUPID=':p877') OR
(ALARMID=':p878' AND ALARMGROUPID=':p879') OR
(ALARMID=':p880' AND ALARMGROUPID=':p881') OR
(ALARMID=':p882' AND ALARMGROUPID=':p883') OR
(ALARMID=':p884' AND ALARMGROUPID=':p885') OR
(ALARMID=':p886' AND ALARMGROUPID=':p887') OR
(ALARMID=':p888' AND ALARMGROUPID=':p889') OR
(ALARMID=':p890' AND ALARMGROUPID=':p891') OR
(ALARMID=':p892' AND ALARMGROUPID=':p893') OR
(ALARMID=':p894' AND ALARMGROUPID=':p895') OR
(ALARMID=':p896' AND ALARMGROUPID=':p897') OR
(ALARMID=':p898' AND ALARMGROUPID=':p899') OR
(ALARMID=':p900' AND ALARMGROUPID=':p901') OR
(ALARMID=':p902' AND ALARMGROUPID=':p903') OR
(ALARMID=':p904' AND ALARMGROUPID=':p905') OR
(ALARMID=':p906' AND ALARMGROUPID=':p907') OR
(ALARMID=':p908' AND ALARMGROUPID=':p909') OR
(ALARMID=':p910' AND ALARMGROUPID=':p911') OR
(ALARMID=':p912' AND ALARMGROUPID=':p913') OR
(ALARMID=':p914' AND ALARMGROUPID=':p915') OR
(ALARMID=':p916' AND ALARMGROUPID=':p917') OR
(ALARMID=':p918' AND ALARMGROUPID=':p919') OR
(ALARMID=':p920' AND ALARMGROUPID=':p921') OR
(ALARMID=':p922' AND ALARMGROUPID=':p923') OR
(ALARMID=':p924' AND ALARMGROUPID=':p925') OR
(ALARMID=':p926' AND ALARMGROUPID=':p927') OR
(ALARMID=':p928' AND ALARMGROUPID=':p929') OR
(ALARMID=':p930' AND ALARMGROUPID=':p931') OR
(ALARMID=':p932' AND ALARMGROUPID=':p933') OR
(ALARMID=':p934' AND ALARMGROUPID=':p935') OR
(ALARMID=':p936' AND ALARMGROUPID=':p937') OR
(ALARMID=':p938' AND ALARMGROUPID=':p939') OR
(ALARMID=':p940' AND ALARMGROUPID=':p941') OR
(ALARMID=':p942' AND ALARMGROUPID=':p943') OR
(ALARMID=':p944' AND ALARMGROUPID=':p945') OR
(ALARMID=':p946' AND ALARMGROUPID=':p947') OR
(ALARMID=':p948' AND ALARMGROUPID=':p949') OR
(ALARMID=':p950' AND ALARMGROUPID=':p951') OR
(ALARMID=':p952' AND ALARMGROUPID=':p953') OR
(ALARMID=':p954' AND ALARMGROUPID=':p955') OR
(ALARMID=':p956' AND ALARMGROUPID=':p957') OR
(ALARMID=':p958' AND ALARMGROUPID=':p959') OR
(ALARMID=':p960' AND ALARMGROUPID=':p961') OR
(ALARMID=':p962' AND ALARMGROUPID=':p963') OR
(ALARMID=':p964' AND ALARMGROUPID=':p965') OR
(ALARMID=':p966' AND ALARMGROUPID=':p967') OR
(ALARMID=':p968' AND ALARMGROUPID=':p969') OR
(ALARMID=':p970' AND ALARMGROUPID=':p971') OR
(ALARMID=':p972' AND ALARMGROUPID=':p973') OR
(ALARMID=':p974' AND ALARMGROUPID=':p975') OR
(ALARMID=':p976' AND ALARMGROUPID=':p977') OR
(ALARMID=':p978' AND ALARMGROUPID=':p979') OR
(ALARMID=':p980' AND ALARMGROUPID=':p981') OR
(ALARMID=':p982' AND ALARMGROUPID=':p983') OR
(ALARMID=':p984' AND ALARMGROUPID=':p985') OR
(ALARMID=':p986' AND ALARMGROUPID=':p987') OR
(ALARMID=':p988' AND ALARMGROUPID=':p989') OR
(ALARMID=':p990' AND ALARMGROUPID=':p991') OR
(ALARMID=':p992' AND ALARMGROUPID=':p993') OR
(ALARMID=':p994' AND ALARMGROUPID=':p995') OR
(ALARMID=':p996' AND ALARMGROUPID=':p997') OR
(ALARMID=':p998' AND ALARMGROUPID=':p999') OR
(ALARMID=':p1000' AND ALARMGROUPID=':p1001') OR
(ALARMID=':p1002' AND ALARMGROUPID=':p1003') OR
(ALARMID=':p1004' AND ALARMGROUPID=':p1005') OR
(ALARMID=':p1006' AND ALARMGROUPID=':p1007') OR
(ALARMID=':p1008' AND ALARMGROUPID=':p1009') OR
(ALARMID=':p1010' AND ALARMGROUPID=':p1011') OR
(ALARMID=':p1012' AND ALARMGROUPID=':p1013') OR
(ALARMID=':p1014' AND ALARMGROUPID=':p1015') OR
(ALARMID=':p1016' AND ALARMGROUPID=':p1017') OR
(ALARMID=':p1018' AND ALARMGROUPID=':p1019') OR
(ALARMID=':p1020' AND ALARMGROUPID=':p1021') OR
(ALARMID=':p1022' AND ALARMGROUPID=':p1023') OR
(ALARMID=':p1024' AND ALARMGROUPID=':p1025') OR
(ALARMID=':p1026' AND ALARMGROUPID=':p1027') OR
(ALARMID=':p1028' AND ALARMGROUPID=':p1029') OR
(ALARMID=':p1030' AND ALARMGROUPID=':p1031') OR
(ALARMID=':p1032' AND ALARMGROUPID=':p1033') OR
(ALARMID=':p1034' AND ALARMGROUPID=':p1035') OR
(ALARMID=':p1036' AND ALARMGROUPID=':p1037') OR
(ALARMID=':p1038' AND ALARMGROUPID=':p1039') OR
(ALARMID=':p1040' AND ALARMGROUPID=':p1041') OR
(ALARMID=':p1042' AND ALARMGROUPID=':p1043') OR
(ALARMID=':p1044' AND ALARMGROUPID=':p1045') OR
(ALARMID=':p1046' AND ALARMGROUPID=':p1047') OR
(ALARMID=':p1048' AND ALARMGROUPID=':p1049') OR
(ALARMID=':p1050' AND ALARMGROUPID=':p1051') OR
(ALARMID=':p1052' AND ALARMGROUPID=':p1053') OR
(ALARMID=':p1054' AND ALARMGROUPID=':p1055') OR
(ALARMID=':p1056' AND ALARMGROUPID=':p1057') OR
(ALARMID=':p1058' AND ALARMGROUPID=':p1059') OR
(ALARMID=':p1060' AND ALARMGROUPID=':p1061') OR
(ALARMID=':p1062' AND ALARMGROUPID=':p1063') OR
(ALARMID=':p1064' AND ALARMGROUPID=':p1065') OR
(ALARMID=':p1066' AND ALARMGROUPID=':p1067') OR
(ALARMID=':p1068' AND ALARMGROUPID=':p1069') OR
(ALARMID=':p1070' AND ALARMGROUPID=':p1071') OR
(ALARMID=':p1072' AND ALARMGROUPID=':p1073') OR
(ALARMID=':p1074' AND ALARMGROUPID=':p1075') OR
(ALARMID=':p1076' AND ALARMGROUPID=':p1077') OR
(ALARMID=':p1078' AND ALARMGROUPID=':p1079') OR
(ALARMID=':p1080' AND ALARMGROUPID=':p1081') OR
(ALARMID=':p1082' AND ALARMGROUPID=':p1083') OR
(ALARMID=':p1084' AND ALARMGROUPID=':p1085') OR
(ALARMID=':p1086' AND ALARMGROUPID=':p1087') OR
(ALARMID=':p1088' AND ALARMGROUPID=':p1089') OR
(ALARMID=':p1090' AND ALARMGROUPID=':p1091') OR
(ALARMID=':p1092' AND ALARMGROUPID=':p1093') OR
(ALARMID=':p1094' AND ALARMGROUPID=':p1095') OR
(ALARMID=':p1096' AND ALARMGROUPID=':p1097') OR
(ALARMID=':p1098' AND ALARMGROUPID=':p1099') OR
(ALARMID=':p1100' AND ALARMGROUPID=':p1101') OR
(ALARMID=':p1102' AND ALARMGROUPID=':p1103') OR
(ALARMID=':p1104' AND ALARMGROUPID=':p1105') OR
(ALARMID=':p1106' AND ALARMGROUPID=':p1107') OR
(ALARMID=':p1108' AND ALARMGROUPID=':p1109') OR
(ALARMID=':p1110' AND ALARMGROUPID=':p1111') OR
(ALARMID=':p1112' AND ALARMGROUPID=':p1113') OR
(ALARMID=':p1114' AND ALARMGROUPID=':p1115') OR
(ALARMID=':p1116' AND ALARMGROUPID=':p1117') OR
(ALARMID=':p1118' AND ALARMGROUPID=':p1119') OR
(ALARMID=':p1120' AND ALARMGROUPID=':p1121') OR
(ALARMID=':p1122' AND ALARMGROUPID=':p1123') OR
(ALARMID=':p1124' AND ALARMGROUPID=':p1125') OR
(ALARMID=':p1126' AND ALARMGROUPID=':p1127') OR
(ALARMID=':p1128' AND ALARMGROUPID=':p1129') OR
(ALARMID=':p1130' AND ALARMGROUPID=':p1131') OR
(ALARMID=':p1132' AND ALARMGROUPID=':p1133') OR
(ALARMID=':p1134' AND ALARMGROUPID=':p1135') OR
(ALARMID=':p1136' AND ALARMGROUPID=':p1137') OR
(ALARMID=':p1138' AND ALARMGROUPID=':p1139') OR
(ALARMID=':p1140' AND ALARMGROUPID=':p1141') OR
(ALARMID=':p1142' AND ALARMGROUPID=':p1143') OR
(ALARMID=':p1144' AND ALARMGROUPID=':p1145') OR
(ALARMID=':p1146' AND ALARMGROUPID=':p1147') OR
(ALARMID=':p1148' AND ALARMGROUPID=':p1149') OR
(ALARMID=':p1150' AND ALARMGROUPID=':p1151') OR
(ALARMID=':p1152' AND ALARMGROUPID=':p1153') OR
(ALARMID=':p1154' AND ALARMGROUPID=':p1155') OR
(ALARMID=':p1156' AND ALARMGROUPID=':p1157') OR
(ALARMID=':p1158' AND ALARMGROUPID=':p1159') OR
(ALARMID=':p1160' AND ALARMGROUPID=':p1161') OR
(ALARMID=':p1162' AND ALARMGROUPID=':p1163') OR
(ALARMID=':p1164' AND ALARMGROUPID=':p1165') OR
(ALARMID=':p1166' AND ALARMGROUPID=':p1167') OR
(ALARMID=':p1168' AND ALARMGROUPID=':p1169') OR
(ALARMID=':p1170' AND ALARMGROUPID=':p1171') OR
(ALARMID=':p1172' AND ALARMGROUPID=':p1173') OR
(ALARMID=':p1174' AND ALARMGROUPID=':p1175') OR
(ALARMID=':p1176' AND ALARMGROUPID=':p1177') OR
(ALARMID=':p1178' AND ALARMGROUPID=':p1179') OR
(ALARMID=':p1180' AND ALARMGROUPID=':p1181') OR
(ALARMID=':p1182' AND ALARMGROUPID=':p1183') OR
(ALARMID=':p1184' AND ALARMGROUPID=':p1185') OR
(ALARMID=':p1186' AND ALARMGROUPID=':p1187') OR
(ALARMID=':p1188' AND ALARMGROUPID=':p1189') OR
(ALARMID=':p1190' AND ALARMGROUPID=':p1191') OR
(ALARMID=':p1192' AND ALARMGROUPID=':p1193') OR
(ALARMID=':p1194' AND ALARMGROUPID=':p1195') OR
(ALARMID=':p1196' AND ALARMGROUPID=':p1197') OR
(ALARMID=':p1198' AND ALARMGROUPID=':p1199') OR
(ALARMID=':p1200' AND ALARMGROUPID=':p1201') OR
(ALARMID=':p1202' AND ALARMGROUPID=':p1203') OR
(ALARMID=':p1204' AND ALARMGROUPID=':p1205') OR
(ALARMID=':p1206' AND ALARMGROUPID=':p1207') OR
(ALARMID=':p1208' AND ALARMGROUPID=':p1209') OR
(ALARMID=':p1210' AND ALARMGROUPID=':p1211') OR
(ALARMID=':p1212' AND ALARMGROUPID=':p1213') OR
(ALARMID=':p1214' AND ALARMGROUPID=':p1215') OR
(ALARMID=':p1216' AND ALARMGROUPID=':p1217') OR
(ALARMID=':p1218' AND ALARMGROUPID=':p1219') OR
(ALARMID=':p1220' AND ALARMGROUPID=':p1221') OR
(ALARMID=':p1222' AND ALARMGROUPID=':p1223') OR
(ALARMID=':p1224' AND ALARMGROUPID=':p1225') OR
(ALARMID=':p1226' AND ALARMGROUPID=':p1227') OR
(ALARMID=':p1228' AND ALARMGROUPID=':p1229') OR
(ALARMID=':p1230' AND ALARMGROUPID=':p1231') OR
(ALARMID=':p1232' AND ALARMGROUPID=':p1233') OR
(ALARMID=':p1234' AND ALARMGROUPID=':p1235') OR
(ALARMID=':p1236' AND ALARMGROUPID=':p1237') OR
(ALARMID=':p1238' AND ALARMGROUPID=':p1239') OR
(ALARMID=':p1240' AND ALARMGROUPID=':p1241') OR
(ALARMID=':p1242' AND ALARMGROUPID=':p1243') OR
(ALARMID=':p1244' AND ALARMGROUPID=':p1245') OR
(ALARMID=':p1246' AND ALARMGROUPID=':p1247') OR
(ALARMID=':p1248' AND ALARMGROUPID=':p1249') OR
(ALARMID=':p1250' AND ALARMGROUPID=':p1251') OR
(ALARMID=':p1252' AND ALARMGROUPID=':p1253') OR
(ALARMID=':p1254' AND ALARMGROUPID=':p1255') OR
(ALARMID=':p1256' AND ALARMGROUPID=':p1257') OR
(ALARMID=':p1258' AND ALARMGROUPID=':p1259') OR
(ALARMID=':p1260' AND ALARMGROUPID=':p1261') OR
(ALARMID=':p1262' AND ALARMGROUPID=':p1263') OR
(ALARMID=':p1264' AND ALARMGROUPID=':p1265') OR
(ALARMID=':p1266' AND ALARMGROUPID=':p1267') OR
(ALARMID=':p1268' AND ALARMGROUPID=':p1269') OR
(ALARMID=':p1270' AND ALARMGROUPID=':p1271') OR
(ALARMID=':p1272' AND ALARMGROUPID=':p1273') OR
(ALARMID=':p1274' AND ALARMGROUPID=':p1275') OR
(ALARMID=':p1276' AND ALARMGROUPID=':p1277') OR
(ALARMID=':p1278' AND ALARMGROUPID=':p1279') OR
(ALARMID=':p1280' AND ALARMGROUPID=':p1281') OR
(ALARMID=':p1282' AND ALARMGROUPID=':p1283') OR
(ALARMID=':p1284' AND ALARMGROUPID=':p1285') OR
(ALARMID=':p1286' AND ALARMGROUPID=':p1287') OR
(ALARMID=':p1288' AND ALARMGROUPID=':p1289') OR
(ALARMID=':p1290' AND ALARMGROUPID=':p1291') OR
(ALARMID=':p1292' AND ALARMGROUPID=':p1293') OR
(ALARMID=':p1294' AND ALARMGROUPID=':p1295') OR
(ALARMID=':p1296' AND ALARMGROUPID=':p1297') OR
(ALARMID=':p1298' AND ALARMGROUPID=':p1299') OR
(ALARMID=':p1300' AND ALARMGROUPID=':p1301') OR
(ALARMID=':p1302' AND ALARMGROUPID=':p1303') OR
(ALARMID=':p1304' AND ALARMGROUPID=':p1305') OR
(ALARMID=':p1306' AND ALARMGROUPID=':p1307') OR
(ALARMID=':p1308' AND ALARMGROUPID=':p1309') OR
(ALARMID=':p1310' AND ALARMGROUPID=':p1311') OR
(ALARMID=':p1312' AND ALARMGROUPID=':p1313') OR
(ALARMID=':p1314' AND ALARMGROUPID=':p1315') OR
(ALARMID=':p1316' AND ALARMGROUPID=':p1317') OR
(ALARMID=':p1318' AND ALARMGROUPID=':p1319') OR
(ALARMID=':p1320' AND ALARMGROUPID=':p1321') OR
(ALARMID=':p1322' AND ALARMGROUPID=':p1323') OR
(ALARMID=':p1324' AND ALARMGROUPID=':p1325') OR
(ALARMID=':p1326' AND ALARMGROUPID=':p1327') OR
(ALARMID=':p1328' AND ALARMGROUPID=':p1329') OR
(ALARMID=':p1330' AND ALARMGROUPID=':p1331') OR
(ALARMID=':p1332' AND ALARMGROUPID=':p1333') OR
(ALARMID=':p1334' AND ALARMGROUPID=':p1335') OR
(ALARMID=':p1336' AND ALARMGROUPID=':p1337') OR
(ALARMID=':p1338' AND ALARMGROUPID=':p1339') OR
(ALARMID=':p1340' AND ALARMGROUPID=':p1341') OR
(ALARMID=':p1342' AND ALARMGROUPID=':p1343') OR
(ALARMID=':p1344' AND ALARMGROUPID=':p1345') OR
(ALARMID=':p1346' AND ALARMGROUPID=':p1347') OR
(ALARMID=':p1348' AND ALARMGROUPID=':p1349') OR
(ALARMID=':p1350' AND ALARMGROUPID=':p1351') OR
(ALARMID=':p1352' AND ALARMGROUPID=':p1353') OR
(ALARMID=':p1354' AND ALARMGROUPID=':p1355') OR
(ALARMID=':p1356' AND ALARMGROUPID=':p1357') OR
(ALARMID=':p1358' AND ALARMGROUPID=':p1359') OR
(ALARMID=':p1360' AND ALARMGROUPID=':p1361') OR
(ALARMID=':p1362' AND ALARMGROUPID=':p1363') OR
(ALARMID=':p1364' AND ALARMGROUPID=':p1365') OR
(ALARMID=':p1366' AND ALARMGROUPID=':p1367') OR
(ALARMID=':p1368' AND ALARMGROUPID=':p1369') OR
(ALARMID=':p1370' AND ALARMGROUPID=':p1371') OR
(ALARMID=':p1372' AND ALARMGROUPID=':p1373') OR
(ALARMID=':p1374' AND ALARMGROUPID=':p1375') OR
(ALARMID=':p1376' AND ALARMGROUPID=':p1377') OR
(ALARMID=':p1378' AND ALARMGROUPID=':p1379') OR
(ALARMID=':p1380' AND ALARMGROUPID=':p1381') OR
(ALARMID=':p1382' AND ALARMGROUPID=':p1383') OR
(ALARMID=':p1384' AND ALARMGROUPID=':p1385') OR
(ALARMID=':p1386' AND ALARMGROUPID=':p1387') OR
(ALARMID=':p1388' AND ALARMGROUPID=':p1389') OR
(ALARMID=':p1390' AND ALARMGROUPID=':p1391') OR
(ALARMID=':p1392' AND ALARMGROUPID=':p1393') OR
(ALARMID=':p1394' AND ALARMGROUPID=':p1395') OR
(ALARMID=':p1396' AND ALARMGROUPID=':p1397') OR
(ALARMID=':p1398' AND ALARMGROUPID=':p1399') OR
(ALARMID=':p1400' AND ALARMGROUPID=':p1401') OR
(ALARMID=':p1402' AND ALARMGROUPID=':p1403') OR
(ALARMID=':p1404' AND ALARMGROUPID=':p1405') OR
(ALARMID=':p1406' AND ALARMGROUPID=':p1407') OR
(ALARMID=':p1408' AND ALARMGROUPID=':p1409') OR
(ALARMID=':p1410' AND ALARMGROUPID=':p1411') OR
(ALARMID=':p1412' AND ALARMGROUPID=':p1413') OR
(ALARMID=':p1414' AND ALARMGROUPID=':p1415') OR
(ALARMID=':p1416' AND ALARMGROUPID=':p1417') OR
(ALARMID=':p1418' AND ALARMGROUPID=':p1419') OR
(ALARMID=':p1420' AND ALARMGROUPID=':p1421') OR
(ALARMID=':p1422' AND ALARMGROUPID=':p1423') OR
(ALARMID=':p1424' AND ALARMGROUPID=':p1425') OR
(ALARMID=':p1426' AND ALARMGROUPID=':p1427') OR
(ALARMID=':p1428' AND ALARMGROUPID=':p1429') OR
(ALARMID=':p1430' AND ALARMGROUPID=':p1431') OR
(ALARMID=':p1432' AND ALARMGROUPID=':p1433') OR
(ALARMID=':p1434' AND ALARMGROUPID=':p1435') OR
(ALARMID=':p1436' AND ALARMGROUPID=':p1437') OR
(ALARMID=':p1438' AND ALARMGROUPID=':p1439') OR
(ALARMID=':p1440' AND ALARMGROUPID=':p1441') OR
(ALARMID=':p1442' AND ALARMGROUPID=':p1443') OR
(ALARMID=':p1444' AND ALARMGROUPID=':p1445') OR
(ALARMID=':p1446' AND ALARMGROUPID=':p1447') OR
(ALARMID=':p1448' AND ALARMGROUPID=':p1449') OR
(ALARMID=':p1450' AND ALARMGROUPID=':p1451') OR
(ALARMID=':p1452' AND ALARMGROUPID=':p1453') OR
(ALARMID=':p1454' AND ALARMGROUPID=':p1455') OR
(ALARMID=':p1456' AND ALARMGROUPID=':p1457') OR
(ALARMID=':p1458' AND ALARMGROUPID=':p1459') OR
(ALARMID=':p1460' AND ALARMGROUPID=':p1461') OR
(ALARMID=':p1462' AND ALARMGROUPID=':p1463') OR
(ALARMID=':p1464' AND ALARMGROUPID=':p1465') OR
(ALARMID=':p1466' AND ALARMGROUPID=':p1467') OR
(ALARMID=':p1468' AND ALARMGROUPID=':p1469') OR
(ALARMID=':p1470' AND ALARMGROUPID=':p1471') OR
(ALARMID=':p1472' AND ALARMGROUPID=':p1473') OR
(ALARMID=':p1474' AND ALARMGROUPID=':p1475') OR
(ALARMID=':p1476' AND ALARMGROUPID=':p1477') OR
(ALARMID=':p1478' AND ALARMGROUPID=':p1479') OR
(ALARMID=':p1480' AND ALARMGROUPID=':p1481') OR
(ALARMID=':p1482' AND ALARMGROUPID=':p1483') OR
(ALARMID=':p1484' AND ALARMGROUPID=':p1485') OR
(ALARMID=':p1486' AND ALARMGROUPID=':p1487') OR
(ALARMID=':p1488' AND ALARMGROUPID=':p1489') OR
(ALARMID=':p1490' AND ALARMGROUPID=':p1491') OR
(ALARMID=':p1492' AND ALARMGROUPID=':p1493') OR
(ALARMID=':p1494' AND ALARMGROUPID=':p1495') OR
(ALARMID=':p1496' AND ALARMGROUPID=':p1497') OR
(ALARMID=':p1498' AND ALARMGROUPID=':p1499') OR
(ALARMID=':p1500' AND ALARMGROUPID=':p1501') OR
(ALARMID=':p1502' AND ALARMGROUPID=':p1503') OR
(ALARMID=':p1504' AND ALARMGROUPID=':p1505') OR
(ALARMID=':p1506' AND ALARMGROUPID=':p1507') OR
(ALARMID=':p1508' AND ALARMGROUPID=':p1509') OR
(ALARMID=':p1510' AND ALARMGROUPID=':p1511') OR
(ALARMID=':p1512' AND ALARMGROUPID=':p1513') OR
(ALARMID=':p1514' AND ALARMGROUPID=':p1515') OR
(ALARMID=':p1516' AND ALARMGROUPID=':p1517') OR
(ALARMID=':p1518' AND ALARMGROUPID=':p1519') OR
(ALARMID=':p1520' AND ALARMGROUPID=':p1521') OR
(ALARMID=':p1522' AND ALARMGROUPID=':p1523') OR
(ALARMID=':p1524' AND ALARMGROUPID=':p1525') OR
(ALARMID=':p1526' AND ALARMGROUPID=':p1527') OR
(ALARMID=':p1528' AND ALARMGROUPID=':p1529') OR
(ALARMID=':p1530' AND ALARMGROUPID=':p1531') OR
(ALARMID=':p1532' AND ALARMGROUPID=':p1533') OR
(ALARMID=':p1534' AND ALARMGROUPID=':p1535') OR
(ALARMID=':p1536' AND ALARMGROUPID=':p1537') OR
(ALARMID=':p1538' AND ALARMGROUPID=':p1539') OR
(ALARMID=':p1540' AND ALARMGROUPID=':p1541') OR
(ALARMID=':p1542' AND ALARMGROUPID=':p1543') OR
(ALARMID=':p1544' AND ALARMGROUPID=':p1545') OR
(ALARMID=':p1546' AND ALARMGROUPID=':p1547') OR
(ALARMID=':p1548' AND ALARMGROUPID=':p1549') OR
(ALARMID=':p1550' AND ALARMGROUPID=':p1551') OR
(ALARMID=':p1552' AND ALARMGROUPID=':p1553') OR
(ALARMID=':p1554' AND ALARMGROUPID=':p1555') OR
(ALARMID=':p1556' AND ALARMGROUPID=':p1557') OR
(ALARMID=':p1558' AND ALARMGROUPID=':p1559') OR
(ALARMID=':p1560' AND ALARMGROUPID=':p1561') OR
(ALARMID=':p1562' AND ALARMGROUPID=':p1563') OR
(ALARMID=':p1564' AND ALARMGROUPID=':p1565') OR
(ALARMID=':p1566' AND ALARMGROUPID=':p1567') OR
(ALARMID=':p1568' AND ALARMGROUPID=':p1569') OR
(ALARMID=':p1570' AND ALARMGROUPID=':p1571') OR
(ALARMID=':p1572' AND ALARMGROUPID=':p1573') OR
(ALARMID=':p1574' AND ALARMGROUPID=':p1575') OR
(ALARMID=':p1576' AND ALARMGROUPID=':p1577') OR
(ALARMID=':p1578' AND ALARMGROUPID=':p1579') OR
(ALARMID=':p1580' AND ALARMGROUPID=':p1581') OR
(ALARMID=':p1582' AND ALARMGROUPID=':p1583') OR
(ALARMID=':p1584' AND ALARMGROUPID=':p1585') OR
(ALARMID=':p1586' AND ALARMGROUPID=':p1587') OR
(ALARMID=':p1588' AND ALARMGROUPID=':p1589') OR
(ALARMID=':p1590' AND ALARMGROUPID=':p1591') OR
(ALARMID=':p1592' AND ALARMGROUPID=':p1593') OR
(ALARMID=':p1594' AND ALARMGROUPID=':p1595') OR
(ALARMID=':p1596' AND ALARMGROUPID=':p1597') OR
(ALARMID=':p1598' AND ALARMGROUPID=':p1599') OR
(ALARMID=':p1600' AND ALARMGROUPID=':p1601') OR
(ALARMID=':p1602' AND ALARMGROUPID=':p1603') OR
(ALARMID=':p1604' AND ALARMGROUPID=':p1605') OR
(ALARMID=':p1606' AND ALARMGROUPID=':p1607') OR
(ALARMID=':p1608' AND ALARMGROUPID=':p1609') OR
(ALARMID=':p1610' AND ALARMGROUPID=':p1611') OR
(ALARMID=':p1612' AND ALARMGROUPID=':p1613') OR
(ALARMID=':p1614' AND ALARMGROUPID=':p1615') OR
(ALARMID=':p1616' AND ALARMGROUPID=':p1617') OR
(ALARMID=':p1618' AND ALARMGROUPID=':p1619') OR
(ALARMID=':p1620' AND ALARMGROUPID=':p1621') OR
(ALARMID=':p1622' AND ALARMGROUPID=':p1623') OR
(ALARMID=':p1624' AND ALARMGROUPID=':p1625') OR
(ALARMID=':p1626' AND ALARMGROUPID=':p1627') OR
(ALARMID=':p1628' AND ALARMGROUPID=':p1629') OR
(ALARMID=':p1630' AND ALARMGROUPID=':p1631') OR
(ALARMID=':p1632' AND ALARMGROUPID=':p1633') OR
(ALARMID=':p1634' AND ALARMGROUPID=':p1635') OR
(ALARMID=':p1636' AND ALARMGROUPID=':p1637') OR
(ALARMID=':p1638' AND ALARMGROUPID=':p1639') OR
(ALARMID=':p1640' AND ALARMGROUPID=':p1641') OR
(ALARMID=':p1642' AND ALARMGROUPID=':p1643') OR
(ALARMID=':p1644' AND ALARMGROUPID=':p1645') OR
(ALARMID=':p1646' AND ALARMGROUPID=':p1647') OR
(ALARMID=':p1648' AND ALARMGROUPID=':p1649') OR
(ALARMID=':p1650' AND ALARMGROUPID=':p1651') OR
(ALARMID=':p1652' AND ALARMGROUPID=':p1653') OR
(ALARMID=':p1654' AND ALARMGROUPID=':p1655') OR
(ALARMID=':p1656' AND ALARMGROUPID=':p1657') OR
(ALARMID=':p1658' AND ALARMGROUPID=':p1659') OR
(ALARMID=':p1660' AND ALARMGROUPID=':p1661') OR
(ALARMID=':p1662' AND ALARMGROUPID=':p1663') OR
(ALARMID=':p1664' AND ALARMGROUPID=':p1665') OR
(ALARMID=':p1666' AND ALARMGROUPID=':p1667') OR
(ALARMID=':p1668' AND ALARMGROUPID=':p1669') OR
(ALARMID=':p1670' AND ALARMGROUPID=':p1671') OR
(ALARMID=':p1672' AND ALARMGROUPID=':p1673') OR
(ALARMID=':p1674' AND ALARMGROUPID=':p1675') OR
(ALARMID=':p1676' AND ALARMGROUPID=':p1677') OR
(ALARMID=':p1678' AND ALARMGROUPID=':p1679') OR
(ALARMID=':p1680' AND ALARMGROUPID=':p1681') OR
(ALARMID=':p1682' AND ALARMGROUPID=':p1683') OR
(ALARMID=':p1684' AND ALARMGROUPID=':p1685') OR
(ALARMID=':p1686' AND ALARMGROUPID=':p1687') OR
(ALARMID=':p1688' AND ALARMGROUPID=':p1689') OR
(ALARMID=':p1690' AND ALARMGROUPID=':p1691') OR
(ALARMID=':p1692' AND ALARMGROUPID=':p1693') OR
(ALARMID=':p1694' AND ALARMGROUPID=':p1695') OR
(ALARMID=':p1696' AND ALARMGROUPID=':p1697') OR
(ALARMID=':p1698' AND ALARMGROUPID=':p1699') OR
(ALARMID=':p1700' AND ALARMGROUPID=':p1701') OR
(ALARMID=':p1702' AND ALARMGROUPID=':p1703') OR
(ALARMID=':p1704' AND ALARMGROUPID=':p1705') OR
(ALARMID=':p1706' AND ALARMGROUPID=':p1707') OR
(ALARMID=':p1708' AND ALARMGROUPID=':p1709') OR
(ALARMID=':p1710' AND ALARMGROUPID=':p1711') OR
(ALARMID=':p1712' AND ALARMGROUPID=':p1713') OR
(ALARMID=':p1714' AND ALARMGROUPID=':p1715') OR
(ALARMID=':p1716' AND ALARMGROUPID=':p1717') OR
(ALARMID=':p1718' AND ALARMGROUPID=':p1719') OR
(ALARMID=':p1720' AND ALARMGROUPID=':p1721') OR
(ALARMID=':p1722' AND ALARMGROUPID=':p1723') OR
(ALARMID=':p1724' AND ALARMGROUPID=':p1725') OR
(ALARMID=':p1726' AND ALARMGROUPID=':p1727') OR
(ALARMID=':p1728' AND ALARMGROUPID=':p1729') OR
(ALARMID=':p1730' AND ALARMGROUPID=':p1731') OR
(ALARMID=':p1732' AND ALARMGROUPID=':p1733') OR
(ALARMID=':p1734' AND ALARMGROUPID=':p1735') OR
(ALARMID=':p1736' AND ALARMGROUPID=':p1737') OR
(ALARMID=':p1738' AND ALARMGROUPID=':p1739') OR
(ALARMID=':p1740' AND ALARMGROUPID=':p1741') OR
(ALARMID=':p1742' AND ALARMGROUPID=':p1743') OR
(ALARMID=':p1744' AND ALARMGROUPID=':p1745') OR
(ALARMID=':p1746' AND ALARMGROUPID=':p1747') OR
(ALARMID=':p1748' AND ALARMGROUPID=':p1749') OR
(ALARMID=':p1750' AND ALARMGROUPID=':p1751') OR
(ALARMID=':p1752' AND ALARMGROUPID=':p1753') OR
(ALARMID=':p1754' AND ALARMGROUPID=':p1755') OR
(ALARMID=':p1756' AND ALARMGROUPID=':p1757') OR
(ALARMID=':p1758' AND ALARMGROUPID=':p1759') OR
(ALARMID=':p1760' AND ALARMGROUPID=':p1761') OR
(ALARMID=':p1762' AND ALARMGROUPID=':p1763') OR
(ALARMID=':p1764' AND ALARMGROUPID=':p1765') OR
(ALARMID=':p1766' AND ALARMGROUPID=':p1767') OR
(ALARMID=':p1768' AND ALARMGROUPID=':p1769') OR
(ALARMID=':p1770' AND ALARMGROUPID=':p1771') OR
(ALARMID=':p1772' AND ALARMGROUPID=':p1773') OR
(ALARMID=':p1774' AND ALARMGROUPID=':p1775') OR
(ALARMID=':p1776' AND ALARMGROUPID=':p1777') OR
(ALARMID=':p1778' AND ALARMGROUPID=':p1779') OR
(ALARMID=':p1780' AND ALARMGROUPID=':p1781') OR
(ALARMID=':p1782' AND ALARMGROUPID=':p1783') OR
(ALARMID=':p1784' AND ALARMGROUPID=':p1785') OR
(ALARMID=':p1786' AND ALARMGROUPID=':p1787') OR
(ALARMID=':p1788' AND ALARMGROUPID=':p1789') OR
(ALARMID=':p1790' AND ALARMGROUPID=':p1791') OR
(ALARMID=':p1792' AND ALARMGROUPID=':p1793') OR
(ALARMID=':p1794' AND ALARMGROUPID=':p1795') OR
(ALARMID=':p1796' AND ALARMGROUPID=':p1797') OR
(ALARMID=':p1798' AND ALARMGROUPID=':p1799') OR
(ALARMID=':p1800' AND ALARMGROUPID=':p1801') OR
(ALARMID=':p1802' AND ALARMGROUPID=':p1803') OR
(ALARMID=':p1804' AND ALARMGROUPID=':p1805') OR
(ALARMID=':p1806' AND ALARMGROUPID=':p1807') OR
(ALARMID=':p1808' AND ALARMGROUPID=':p1809') OR
(ALARMID=':p1810' AND ALARMGROUPID=':p1811') OR
(ALARMID=':p1812' AND ALARMGROUPID=':p1813') OR
(ALARMID=':p1814' AND ALARMGROUPID=':p1815') OR
(ALARMID=':p1816' AND ALARMGROUPID=':p1817') OR
(ALARMID=':p1818' AND ALARMGROUPID=':p1819') OR
(ALARMID=':p1820' AND ALARMGROUPID=':p1821') OR
(ALARMID=':p1822' AND ALARMGROUPID=':p1823') OR
(ALARMID=':p1824' AND ALARMGROUPID=':p1825') OR
(ALARMID=':p1826' AND ALARMGROUPID=':p1827') OR
(ALARMID=':p1828' AND ALARMGROUPID=':p1829') OR
(ALARMID=':p1830' AND ALARMGROUPID=':p1831') OR
(ALARMID=':p1832' AND ALARMGROUPID=':p1833') OR
(ALARMID=':p1834' AND ALARMGROUPID=':p1835') OR
(ALARMID=':p1836' AND ALARMGROUPID=':p1837') OR
(ALARMID=':p1838' AND ALARMGROUPID=':p1839') OR
(ALARMID=':p1840' AND ALARMGROUPID=':p1841') OR
(ALARMID=':p1842' AND ALARMGROUPID=':p1843') OR
(ALARMID=':p1844' AND ALARMGROUPID=':p1845') OR
(ALARMID=':p1846' AND ALARMGROUPID=':p1847') OR
(ALARMID=':p1848' AND ALARMGROUPID=':p1849') OR
(ALARMID=':p1850' AND ALARMGROUPID=':p1851') OR
(ALARMID=':p1852' AND ALARMGROUPID=':p1853') OR
(ALARMID=':p1854' AND ALARMGROUPID=':p1855') OR
(ALARMID=':p1856' AND ALARMGROUPID=':p1857') OR
(ALARMID=':p1858' AND ALARMGROUPID=':p1859') OR
(ALARMID=':p1860' AND ALARMGROUPID=':p1861') OR
(ALARMID=':p1862' AND ALARMGROUPID=':p1863') OR
(ALARMID=':p1864' AND ALARMGROUPID=':p1865') OR
(ALARMID=':p1866' AND ALARMGROUPID=':p1867') OR
(ALARMID=':p1868' AND ALARMGROUPID=':p1869') OR
(ALARMID=':p1870' AND ALARMGROUPID=':p1871') OR
(ALARMID=':p1872' AND ALARMGROUPID=':p1873') OR
(ALARMID=':p1874' AND ALARMGROUPID=':p1875') OR
(ALARMID=':p1876' AND ALARMGROUPID=':p1877') OR
(ALARMID=':p1878' AND ALARMGROUPID=':p1879') OR
(ALARMID=':p1880' AND ALARMGROUPID=':p1881') OR
(ALARMID=':p1882' AND ALARMGROUPID=':p1883') OR
(ALARMID=':p1884' AND ALARMGROUPID=':p1885') OR
(ALARMID=':p1886' AND ALARMGROUPID=':p1887') OR
(ALARMID=':p1888' AND ALARMGROUPID=':p1889') OR
(ALARMID=':p1890' AND ALARMGROUPID=':p1891') OR
(ALARMID=':p1892' AND ALARMGROUPID=':p1893') OR
(ALARMID=':p1894' AND ALARMGROUPID=':p1895') OR
(ALARMID=':p1896' AND ALARMGROUPID=':p1897') OR
(ALARMID=':p1898' AND ALARMGROUPID=':p1899') OR
(ALARMID=':p1900' AND ALARMGROUPID=':p1901') OR
(ALARMID=':p1902' AND ALARMGROUPID=':p1903') OR
(ALARMID=':p1904' AND ALARMGROUPID=':p1905') OR
(ALARMID=':p1906' AND ALARMGROUPID=':p1907') OR
(ALARMID=':p1908' AND ALARMGROUPID=':p1909') OR
(ALARMID=':p1910' AND ALARMGROUPID=':p1911') OR
(ALARMID=':p1912' AND ALARMGROUPID=':p1913') OR
(ALARMID=':p1914' AND ALARMGROUPID=':p1915') OR
(ALARMID=':p1916' AND ALARMGROUPID=':p1917') OR
(ALARMID=':p1918' AND ALARMGROUPID=':p1919') OR
(ALARMID=':p1920' AND ALARMGROUPID=':p1921') OR
(ALARMID=':p1922' AND ALARMGROUPID=':p1923') OR
(ALARMID=':p1924' AND ALARMGROUPID=':p1925') OR
(ALARMID=':p1926' AND ALARMGROUPID=':p1927') OR
(ALARMID=':p1928' AND ALARMGROUPID=':p1929') OR
(ALARMID=':p1930' AND ALARMGROUPID=':p1931') OR
(ALARMID=':p1932' AND ALARMGROUPID=':p1933') OR
(ALARMID=':p1934' AND ALARMGROUPID=':p1935') OR
(ALARMID=':p1936' AND ALARMGROUPID=':p1937') OR
(ALARMID=':p1938' AND ALARMGROUPID=':p1939') OR
(ALARMID=':p1940' AND ALARMGROUPID=':p1941') OR
(ALARMID=':p1942' AND ALARMGROUPID=':p1943') OR
(ALARMID=':p1944' AND ALARMGROUPID=':p1945') OR
(ALARMID=':p1946' AND ALARMGROUPID=':p1947') OR
(ALARMID=':p1948' AND ALARMGROUPID=':p1949') OR
(ALARMID=':p1950' AND ALARMGROUPID=':p1951') OR
(ALARMID=':p1952' AND ALARMGROUPID=':p1953') OR
(ALARMID=':p1954' AND ALARMGROUPID=':p1955') OR
(ALARMID=':p1956' AND ALARMGROUPID=':p1957') OR
(ALARMID=':p1958' AND ALARMGROUPID=':p1959') OR
(ALARMID=':p1960' AND ALARMGROUPID=':p1961') OR
(ALARMID=':p1962' AND ALARMGROUPID=':p1963') OR
(ALARMID=':p1964' AND ALARMGROUPID=':p1965') OR
(ALARMID=':p1966' AND ALARMGROUPID=':p1967') OR
(ALARMID=':p1968' AND ALARMGROUPID=':p1969') OR
(ALARMID=':p1970' AND ALARMGROUPID=':p1971') OR
(ALARMID=':p1972' AND ALARMGROUPID=':p1973') OR
(ALARMID=':p1974' AND ALARMGROUPID=':p1975') OR
(ALARMID=':p1976' AND ALARMGROUPID=':p1977') OR
(ALARMID=':p1978' AND ALARMGROUPID=':p1979') OR
(ALARMID=':p1980' AND ALARMGROUPID=':p1981') OR
(ALARMID=':p1982' AND ALARMGROUPID=':p1983') OR
(ALARMID=':p1984' AND ALARMGROUPID=':p1985') OR
(ALARMID=':p1986' AND ALARMGROUPID=':p1987') OR
(ALARMID=':p1988' AND ALARMGROUPID=':p1989') OR
(ALARMID=':p1990' AND ALARMGROUPID=':p1991') OR
(ALARMID=':p1992' AND ALARMGROUPID=':p1993') OR
(ALARMID=':p1994' AND ALARMGROUPID=':p1995') OR
(ALARMID=':p1996' AND ALARMGROUPID=':p1997') OR
(ALARMID=':p1998' AND ALARMGROUPID=':p1999') OR
(ALARMID=':p2000' AND ALARMGROUPID=':p2001') OR
(ALARMID=':p2002' AND ALARMGROUPID=':p2003') OR
(ALARMID=':p2004' AND ALARMGROUPID=':p2005') OR
(ALARMID=':p2006' AND ALARMGROUPID=':p2007') OR
(ALARMID=':p2008' AND ALARMGROUPID=':p2009') OR
(ALARMID=':p2010' AND ALARMGROUPID=':p2011') OR
(ALARMID=':p2012' AND ALARMGROUPID=':p2013') OR
(ALARMID=':p2014' AND ALARMGROUPID=':p2015') OR
(ALARMID=':p2016' AND ALARMGROUPID=':p2017') OR
(ALARMID=':p2018' AND ALARMGROUPID=':p2019') OR
(ALARMID=':p2020' AND ALARMGROUPID=':p2021') OR
(ALARMID=':p2022' AND ALARMGROUPID=':p2023') OR
(ALARMID=':p2024' AND ALARMGROUPID=':p2025') OR
(ALARMID=':p2026' AND ALARMGROUPID=':p2027') OR
(ALARMID=':p2028' AND ALARMGROUPID=':p2029') OR
(ALARMID=':p2030' AND ALARMGROUPID=':p2031') OR
(ALARMID=':p2032' AND ALARMGROUPID=':p2033') OR
(ALARMID=':p2034' AND ALARMGROUPID=':p2035') OR
(ALARMID=':p2036' AND ALARMGROUPID=':p2037') OR
(ALARMID=':p2038' AND ALARMGROUPID=':p2039') OR
(ALARMID=':p2040' AND ALARMGROUPID=':p2041') OR
(ALARMID=':p2042' AND ALARMGROUPID=':p2043') OR
(ALARMID=':p2044' AND ALARMGROUPID=':p2045') OR
(ALARMID=':p2046' AND ALARMGROUPID=':p2047') OR
(ALARMID=':p2048' AND ALARMGROUPID=':p2049') OR
(ALARMID=':p2050' AND ALARMGROUPID=':p2051') OR
(ALARMID=':p2052' AND ALARMGROUPID=':p2053') OR
(ALARMID=':p2054' AND ALARMGROUPID=':p2055') OR
(ALARMID=':p2056' AND ALARMGROUPID=':p2057') OR
(ALARMID=':p2058' AND ALARMGROUPID=':p2059') OR
(ALARMID=':p2060' AND ALARMGROUPID=':p2061') OR
(ALARMID=':p2062' AND ALARMGROUPID=':p2063') OR
(ALARMID=':p2064' AND ALARMGROUPID=':p2065') OR
(ALARMID=':p2066' AND ALARMGROUPID=':p2067') OR
(ALARMID=':p2068' AND ALARMGROUPID=':p2069') OR
(ALARMID=':p2070' AND ALARMGROUPID=':p2071') OR
(ALARMID=':p2072' AND ALARMGROUPID=':p2073') OR
(ALARMID=':p2074' AND ALARMGROUPID=':p2075') OR
(ALARMID=':p2076' AND ALARMGROUPID=':p2077') OR
(ALARMID=':p2078' AND ALARMGROUPID=':p2079') OR
(ALARMID=':p2080' AND ALARMGROUPID=':p2081') OR
(ALARMID=':p2082' AND ALARMGROUPID=':p2083') OR
(ALARMID=':p2084' AND ALARMGROUPID=':p2085') OR
(ALARMID=':p2086' AND ALARMGROUPID=':p2087') OR
(ALARMID=':p2088' AND ALARMGROUPID=':p2089') OR
(ALARMID=':p2090' AND ALARMGROUPID=':p2091') OR
(ALARMID=':p2092' AND ALARMGROUPID=':p2093') OR
(ALARMID=':p2094' AND ALARMGROUPID=':p2095') OR
(ALARMID=':p2096' AND ALARMGROUPID=':p2097') OR
(ALARMID=':p2098' AND ALARMGROUPID=':p2099') OR
(ALARMID=':p2100' AND ALARMGROUPID=':p2101') OR
(ALARMID=':p2102' AND ALARMGROUPID=':p2103') OR
(ALARMID=':p2104' AND ALARMGROUPID=':p2105') OR
(ALARMID=':p2106' AND ALARMGROUPID=':p2107') OR
(ALARMID=':p2108' AND ALARMGROUPID=':p2109') OR
(ALARMID=':p2110' AND ALARMGROUPID=':p2111') OR
(ALARMID=':p2112' AND ALARMGROUPID=':p2113') OR
(ALARMID=':p2114' AND ALARMGROUPID=':p2115') OR
(ALARMID=':p2116' AND ALARMGROUPID=':p2117') OR
(ALARMID=':p2118' AND ALARMGROUPID=':p2119') OR
(ALARMID=':p2120' AND ALARMGROUPID=':p2121') OR
(ALARMID=':p2122' AND ALARMGROUPID=':p2123') OR
(ALARMID=':p2124' AND ALARMGROUPID=':p2125') OR
(ALARMID=':p2126' AND ALARMGROUPID=':p2127') OR
(ALARMID=':p2128' AND ALARMGROUPID=':p2129') OR
(ALARMID=':p2130' AND ALARMGROUPID=':p2131') OR
(ALARMID=':p2132' AND ALARMGROUPID=':p2133') OR
(ALARMID=':p2134' AND ALARMGROUPID=':p2135') OR
(ALARMID=':p2136' AND ALARMGROUPID=':p2137') OR
(ALARMID=':p2138' AND ALARMGROUPID=':p2139') OR
(ALARMID=':p2140' AND ALARMGROUPID=':p2141') OR
(ALARMID=':p2142' AND ALARMGROUPID=':p2143') OR
(ALARMID=':p2144' AND ALARMGROUPID=':p2145') OR
(ALARMID=':p2146' AND ALARMGROUPID=':p2147') OR
(ALARMID=':p2148' AND ALARMGROUPID=':p2149') OR
(ALARMID=':p2150' AND ALARMGROUPID=':p2151') OR
(ALARMID=':p2152' AND ALARMGROUPID=':p2153') OR
(ALARMID=':p2154' AND ALARMGROUPID=':p2155') OR
(ALARMID=':p2156' AND ALARMGROUPID=':p2157') OR
(ALARMID=':p2158' AND ALARMGROUPID=':p2159') OR
(ALARMID=':p2160' AND ALARMGROUPID=':p2161') OR
(ALARMID=':p2162' AND ALARMGROUPID=':p2163') OR
(ALARMID=':p2164' AND ALARMGROUPID=':p2165') OR
(ALARMID=':p2166' AND ALARMGROUPID=':p2167') OR
(ALARMID=':p2168' AND ALARMGROUPID=':p2169') OR
(ALARMID=':p2170' AND ALARMGROUPID=':p2171') OR
(ALARMID=':p2172' AND ALARMGROUPID=':p2173') OR
(ALARMID=':p2174' AND ALARMGROUPID=':p2175') OR
(ALARMID=':p2176' AND ALARMGROUPID=':p2177') OR
(ALARMID=':p2178' AND ALARMGROUPID=':p2179') OR
(ALARMID=':p2180' AND ALARMGROUPID=':p2181') OR
(ALARMID=':p2182' AND ALARMGROUPID=':p2183') OR
(ALARMID=':p2184' AND ALARMGROUPID=':p2185') OR
(ALARMID=':p2186' AND ALARMGROUPID=':p2187') OR
(ALARMID=':p2188' AND ALARMGROUPID=':p2189') OR
(ALARMID=':p2190' AND ALARMGROUPID=':p2191') OR
(ALARMID=':p2192' AND ALARMGROUPID=':p2193') OR
(ALARMID=':p2194' AND ALARMGROUPID=':p2195') OR
(ALARMID=':p2196' AND ALARMGROUPID=':p2197') OR
(ALARMID=':p2198' AND ALARMGROUPID=':p2199') OR
(ALARMID=':p2200' AND ALARMGROUPID=':p2201') OR
(ALARMID=':p2202' AND ALARMGROUPID=':p2203') OR
(ALARMID=':p2204' AND ALARMGROUPID=':p2205') OR
(ALARMID=':p2206' AND ALARMGROUPID=':p2207') OR
(ALARMID=':p2208' AND ALARMGROUPID=':p2209') OR
(ALARMID=':p2210' AND ALARMGROUPID=':p2211') OR
(ALARMID=':p2212' AND ALARMGROUPID=':p2213') OR
(ALARMID=':p2214' AND ALARMGROUPID=':p2215') OR
(ALARMID=':p2216' AND ALARMGROUPID=':p2217') OR
(ALARMID=':p2218' AND ALARMGROUPID=':p2219') OR
(ALARMID=':p2220' AND ALARMGROUPID=':p2221') OR
(ALARMID=':p2222' AND ALARMGROUPID=':p2223') OR
(ALARMID=':p2224' AND ALARMGROUPID=':p2225') OR
(ALARMID=':p2226' AND ALARMGROUPID=':p2227') OR
(ALARMID=':p2228' AND ALARMGROUPID=':p2229') OR
(ALARMID=':p2230' AND ALARMGROUPID=':p2231') OR
(ALARMID=':p2232' AND ALARMGROUPID=':p2233') OR
(ALARMID=':p2234' AND ALARMGROUPID=':p2235') OR
(ALARMID=':p2236' AND ALARMGROUPID=':p2237') OR
(ALARMID=':p2238' AND ALARMGROUPID=':p2239') OR
(ALARMID=':p2240' AND ALARMGROUPID=':p2241') OR
(ALARMID=':p2242' AND ALARMGROUPID=':p2243') OR
(ALARMID=':p2244' AND ALARMGROUPID=':p2245') OR
(ALARMID=':p2246' AND ALARMGROUPID=':p2247') OR
(ALARMID=':p2248' AND ALARMGROUPID=':p2249') OR
(ALARMID=':p2250' AND ALARMGROUPID=':p2251') OR
(ALARMID=':p2252' AND ALARMGROUPID=':p2253') OR
(ALARMID=':p2254' AND ALARMGROUPID=':p2255') OR
(ALARMID=':p2256' AND ALARMGROUPID=':p2257') OR
(ALARMID=':p2258' AND ALARMGROUPID=':p2259') OR
(ALARMID=':p2260' AND ALARMGROUPID=':p2261') OR
(ALARMID=':p2262' AND ALARMGROUPID=':p2263') OR
(ALARMID=':p2264' AND ALARMGROUPID=':p2265') OR
(ALARMID=':p2266' AND ALARMGROUPID=':p2267') OR
(ALARMID=':p2268' AND ALARMGROUPID=':p2269') OR
(ALARMID=':p2270' AND ALARMGROUPID=':p2271') OR
(ALARMID=':p2272' AND ALARMGROUPID=':p2273') OR
(ALARMID=':p2274' AND ALARMGROUPID=':p2275') OR
(ALARMID=':p2276' AND ALARMGROUPID=':p2277') OR
(ALARMID=':p2278' AND ALARMGROUPID=':p2279') OR
(ALARMID=':p2280' AND ALARMGROUPID=':p2281') OR
(ALARMID=':p2282' AND ALARMGROUPID=':p2283') OR
(ALARMID=':p2284' AND ALARMGROUPID=':p2285') OR
(ALARMID=':p2286' AND ALARMGROUPID=':p2287') OR
(ALARMID=':p2288' AND ALARMGROUPID=':p2289') OR
(ALARMID=':p2290' AND ALARMGROUPID=':p2291') OR
(ALARMID=':p2292' AND ALARMGROUPID=':p2293') OR
(ALARMID=':p2294' AND ALARMGROUPID=':p2295') OR
(ALARMID=':p2296' AND ALARMGROUPID=':p2297') OR
(ALARMID=':p2298' AND ALARMGROUPID=':p2299') OR
(ALARMID=':p2300' AND ALARMGROUPID=':p2301') OR
(ALARMID=':p2302' AND ALARMGROUPID=':p2303') OR
(ALARMID=':p2304' AND ALARMGROUPID=':p2305') OR
(ALARMID=':p2306' AND ALARMGROUPID=':p2307') OR
(ALARMID=':p2308' AND ALARMGROUPID=':p2309') OR
(ALARMID=':p2310' AND ALARMGROUPID=':p2311') OR
(ALARMID=':p2312' AND ALARMGROUPID=':p2313') OR
(ALARMID=':p2314' AND ALARMGROUPID=':p2315') OR
(ALARMID=':p2316' AND ALARMGROUPID=':p2317') OR
(ALARMID=':p2318' AND ALARMGROUPID=':p2319') OR
(ALARMID=':p2320' AND ALARMGROUPID=':p2321') OR
(ALARMID=':p2322' AND ALARMGROUPID=':p2323') OR
(ALARMID=':p2324' AND ALARMGROUPID=':p2325') OR
(ALARMID=':p2326' AND ALARMGROUPID=':p2327') OR
(ALARMID=':p2328' AND ALARMGROUPID=':p2329') OR
(ALARMID=':p2330' AND ALARMGROUPID=':p2331') OR
(ALARMID=':p2332' AND ALARMGROUPID=':p2333') OR
(ALARMID=':p2334' AND ALARMGROUPID=':p2335') OR
(ALARMID=':p2336' AND ALARMGROUPID=':p2337') OR
(ALARMID=':p2338' AND ALARMGROUPID=':p2339') OR
(ALARMID=':p2340' AND ALARMGROUPID=':p2341') OR
(ALARMID=':p2342' AND ALARMGROUPID=':p2343') OR
(ALARMID=':p2344' AND ALARMGROUPID=':p2345') OR
(ALARMID=':p2346' AND ALARMGROUPID=':p2347') OR
(ALARMID=':p2348' AND ALARMGROUPID=':p2349') OR
(ALARMID=':p2350' AND ALARMGROUPID=':p2351') OR
(ALARMID=':p2352' AND ALARMGROUPID=':p2353') OR
(ALARMID=':p2354' AND ALARMGROUPID=':p2355') OR
(ALARMID=':p2356' AND ALARMGROUPID=':p2357') OR
(ALARMID=':p2358' AND ALARMGROUPID=':p2359') OR
(ALARMID=':p2360' AND ALARMGROUPID=':p2361') OR
(ALARMID=':p2362' AND ALARMGROUPID=':p2363') OR
(ALARMID=':p2364' AND ALARMGROUPID=':p2365') OR
(ALARMID=':p2366' AND ALARMGROUPID=':p2367') OR
(ALARMID=':p2368' AND ALARMGROUPID=':p2369') OR
(ALARMID=':p2370' AND ALARMGROUPID=':p2371') OR
(ALARMID=':p2372' AND ALARMGROUPID=':p2373') OR
(ALARMID=':p2374' AND ALARMGROUPID=':p2375') OR
(ALARMID=':p2376' AND ALARMGROUPID=':p2377') OR
(ALARMID=':p2378' AND ALARMGROUPID=':p2379') OR
(ALARMID=':p2380' AND ALARMGROUPID=':p2381') OR
(ALARMID=':p2382' AND ALARMGROUPID=':p2383') OR
(ALARMID=':p2384' AND ALARMGROUPID=':p2385') OR
(ALARMID=':p2386' AND ALARMGROUPID=':p2387') OR
(ALARMID=':p2388' AND ALARMGROUPID=':p2389') OR
(ALARMID=':p2390' AND ALARMGROUPID=':p2391') OR
(ALARMID=':p2392' AND ALARMGROUPID=':p2393') OR
(ALARMID=':p2394' AND ALARMGROUPID=':p2395') OR
(ALARMID=':p2396' AND ALARMGROUPID=':p2397') OR
(ALARMID=':p2398' AND ALARMGROUPID=':p2399') OR
(ALARMID=':p2400' AND ALARMGROUPID=':p2401') OR
(ALARMID=':p2402' AND ALARMGROUPID=':p2403') OR
(ALARMID=':p2404' AND ALARMGROUPID=':p2405') OR
(ALARMID=':p2406' AND ALARMGROUPID=':p2407') OR
(ALARMID=':p2408' AND ALARMGROUPID=':p2409') OR
(ALARMID=':p2410' AND ALARMGROUPID=':p2411') OR
(ALARMID=':p2412' AND ALARMGROUPID=':p2413') OR
(ALARMID=':p2414' AND ALARMGROUPID=':p2415') OR
(ALARMID=':p2416' AND ALARMGROUPID=':p2417') OR
(ALARMID=':p2418' AND ALARMGROUPID=':p2419') OR
(ALARMID=':p2420' AND ALARMGROUPID=':p2421') OR
(ALARMID=':p2422' AND ALARMGROUPID=':p2423') OR
(ALARMID=':p2424' AND ALARMGROUPID=':p2425') OR
(ALARMID=':p2426' AND ALARMGROUPID=':p2427') OR
(ALARMID=':p2428' AND ALARMGROUPID=':p2429') OR
(ALARMID=':p2430' AND ALARMGROUPID=':p2431') OR
(ALARMID=':p2432' AND ALARMGROUPID=':p2433') OR
(ALARMID=':p2434' AND ALARMGROUPID=':p2435') OR
(ALARMID=':p2436' AND ALARMGROUPID=':p2437') OR
(ALARMID=':p2438' AND ALARMGROUPID=':p2439') OR
(ALARMID=':p2440' AND ALARMGROUPID=':p2441') OR
(ALARMID=':p2442' AND ALARMGROUPID=':p2443') OR
(ALARMID=':p2444' AND ALARMGROUPID=':p2445') OR
(ALARMID=':p2446' AND ALARMGROUPID=':p2447') OR
(ALARMID=':p2448' AND ALARMGROUPID=':p2449') OR
(ALARMID=':p2450' AND ALARMGROUPID=':p2451') OR
(ALARMID=':p2452' AND ALARMGROUPID=':p2453') OR
(ALARMID=':p2454' AND ALARMGROUPID=':p2455') OR
(ALARMID=':p2456' AND ALARMGROUPID=':p2457') OR
(ALARMID=':p2458' AND ALARMGROUPID=':p2459') OR
(ALARMID=':p2460' AND ALARMGROUPID=':p2461') OR
(ALARMID=':p2462' AND ALARMGROUPID=':p2463') OR
(ALARMID=':p2464' AND ALARMGROUPID=':p2465') OR
(ALARMID=':p2466' AND ALARMGROUPID=':p2467') OR
(ALARMID=':p2468' AND ALARMGROUPID=':p2469') OR
(ALARMID=':p2470' AND ALARMGROUPID=':p2471') OR
(ALARMID=':p2472' AND ALARMGROUPID=':p2473') OR
(ALARMID=':p2474' AND ALARMGROUPID=':p2475') OR
(ALARMID=':p2476' AND ALARMGROUPID=':p2477') OR
(ALARMID=':p2478' AND ALARMGROUPID=':p2479') OR
(ALARMID=':p2480' AND ALARMGROUPID=':p2481') OR
(ALARMID=':p2482' AND ALARMGROUPID=':p2483') OR
(ALARMID=':p2484' AND ALARMGROUPID=':p2485') OR
(ALARMID=':p2486' AND ALARMGROUPID=':p2487') OR
(ALARMID=':p2488' AND ALARMGROUPID=':p2489') OR
(ALARMID=':p2490' AND ALARMGROUPID=':p2491') OR
(ALARMID=':p2492' AND ALARMGROUPID=':p2493') OR
(ALARMID=':p2494' AND ALARMGROUPID=':p2495') OR
(ALARMID=':p2496' AND ALARMGROUPID=':p2497') OR
(ALARMID=':p2498' AND ALARMGROUPID=':p2499') OR
(ALARMID=':p2500' AND ALARMGROUPID=':p2501') OR
(ALARMID=':p2502' AND ALARMGROUPID=':p2503') OR
(ALARMID=':p2504' AND ALARMGROUPID=':p2505') OR
(ALARMID=':p2506' AND ALARMGROUPID=':p2507') OR
(ALARMID=':p2508' AND ALARMGROUPID=':p2509') OR
(ALARMID=':p2510' AND ALARMGROUPID=':p2511') OR
(ALARMID=':p2512' AND ALARMGROUPID=':p2513') OR
(ALARMID=':p2514' AND ALARMGROUPID=':p2515') OR
(ALARMID=':p2516' AND ALARMGROUPID=':p2517') OR
(ALARMID=':p2518' AND ALARMGROUPID=':p2519') OR
(ALARMID=':p2520' AND ALARMGROUPID=':p2521') OR
(ALARMID=':p2522' AND ALARMGROUPID=':p2523') OR
(ALARMID=':p2524' AND ALARMGROUPID=':p2525') OR
(ALARMID=':p2526' AND ALARMGROUPID=':p2527') OR
(ALARMID=':p2528' AND ALARMGROUPID=':p2529') OR
(ALARMID=':p2530' AND ALARMGROUPID=':p2531') OR
(ALARMID=':p2532' AND ALARMGROUPID=':p2533') OR
(ALARMID=':p2534' AND ALARMGROUPID=':p2535') OR
(ALARMID=':p2536' AND ALARMGROUPID=':p2537') OR
(ALARMID=':p2538' AND ALARMGROUPID=':p2539') OR
(ALARMID=':p2540' AND ALARMGROUPID=':p2541') OR
(ALARMID=':p2542' AND ALARMGROUPID=':p2543') OR
(ALARMID=':p2544' AND ALARMGROUPID=':p2545') OR
(ALARMID=':p2546' AND ALARMGROUPID=':p2547') OR
(ALARMID=':p2548' AND ALARMGROUPID=':p2549') OR
(ALARMID=':p2550' AND ALARMGROUPID=':p2551') OR
(ALARMID=':p2552' AND ALARMGROUPID=':p2553') OR
(ALARMID=':p2554' AND ALARMGROUPID=':p2555') OR
(ALARMID=':p2556' AND ALARMGROUPID=':p2557') OR
(ALARMID=':p2558' AND ALARMGROUPID=':p2559') OR
(ALARMID=':p2560' AND ALARMGROUPID=':p2561') OR
(ALARMID=':p2562' AND ALARMGROUPID=':p2563') OR
(ALARMID=':p2564' AND ALARMGROUPID=':p2565') OR
(ALARMID=':p2566' AND ALARMGROUPID=':p2567') OR
(ALARMID=':p2568' AND ALARMGROUPID=':p2569') OR
(ALARMID=':p2570' AND ALARMGROUPID=':p2571') OR
(ALARMID=':p2572' AND ALARMGROUPID=':p2573') OR
(ALARMID=':p2574' AND ALARMGROUPID=':p2575') OR
(ALARMID=':p2576' AND ALARMGROUPID=':p2577') OR
(ALARMID=':p2578' AND ALARMGROUPID=':p2579') OR
(ALARMID=':p2580' AND ALARMGROUPID=':p2581') OR
(ALARMID=':p2582' AND ALARMGROUPID=':p2583') OR
(ALARMID=':p2584' AND ALARMGROUPID=':p2585') OR
(ALARMID=':p2586' AND ALARMGROUPID=':p2587') OR
(ALARMID=':p2588' AND ALARMGROUPID=':p2589') OR
(ALARMID=':p2590' AND ALARMGROUPID=':p2591') OR
(ALARMID=':p2592' AND ALARMGROUPID=':p2593') OR
(ALARMID=':p2594' AND ALARMGROUPID=':p2595') OR
(ALARMID=':p2596' AND ALARMGROUPID=':p2597') OR
(ALARMID=':p2598' AND ALARMGROUPID=':p2599') OR
(ALARMID=':p2600' AND ALARMGROUPID=':p2601') OR
(ALARMID=':p2602' AND ALARMGROUPID=':p2603') OR
(ALARMID=':p2604' AND ALARMGROUPID=':p2605') OR
(ALARMID=':p2606' AND ALARMGROUPID=':p2607') OR
(ALARMID=':p2608' AND ALARMGROUPID=':p2609') OR
(ALARMID=':p2610' AND ALARMGROUPID=':p2611') OR
(ALARMID=':p2612' AND ALARMGROUPID=':p2613') OR
(ALARMID=':p2614' AND ALARMGROUPID=':p2615') OR
(ALARMID=':p2616' AND ALARMGROUPID=':p2617') OR
(ALARMID=':p2618' AND ALARMGROUPID=':p2619') OR
(ALARMID=':p2620' AND ALARMGROUPID=':p2621') OR
(ALARMID=':p2622' AND ALARMGROUPID=':p2623') OR
(ALARMID=':p2624' AND ALARMGROUPID=':p2625') OR
(ALARMID=':p2626' AND ALARMGROUPID=':p2627') OR
(ALARMID=':p2628' AND ALARMGROUPID=':p2629') OR
(ALARMID=':p2630' AND ALARMGROUPID=':p2631') OR
(ALARMID=':p2632' AND ALARMGROUPID=':p2633') OR
(ALARMID=':p2634' AND ALARMGROUPID=':p2635') OR
(ALARMID=':p2636' AND ALARMGROUPID=':p2637') OR
(ALARMID=':p2638' AND ALARMGROUPID=':p2639') OR
(ALARMID=':p2640' AND ALARMGROUPID=':p2641') OR
(ALARMID=':p2642' AND ALARMGROUPID=':p2643') OR
(ALARMID=':p2644' AND ALARMGROUPID=':p2645') OR
(ALARMID=':p2646' AND ALARMGROUPID=':p2647') OR
(ALARMID=':p2648' AND ALARMGROUPID=':p2649') OR
(ALARMID=':p2650' AND ALARMGROUPID=':p2651') OR
(ALARMID=':p2652' AND ALARMGROUPID=':p2653') OR
(ALARMID=':p2654' AND ALARMGROUPID=':p2655') OR
(ALARMID=':p2656' AND ALARMGROUPID=':p2657') OR
(ALARMID=':p2658' AND ALARMGROUPID=':p2659') OR
(ALARMID=':p2660' AND ALARMGROUPID=':p2661') OR
(ALARMID=':p2662' AND ALARMGROUPID=':p2663') OR
(ALARMID=':p2664' AND ALARMGROUPID=':p2665') OR
(ALARMID=':p2666' AND ALARMGROUPID=':p2667') OR
(ALARMID=':p2668' AND ALARMGROUPID=':p2669') OR
(ALARMID=':p2670' AND ALARMGROUPID=':p2671') OR
(ALARMID=':p2672' AND ALARMGROUPID=':p2673') OR
(ALARMID=':p2674' AND ALARMGROUPID=':p2675') OR
(ALARMID=':p2676' AND ALARMGROUPID=':p2677') OR
(ALARMID=':p2678' AND ALARMGROUPID=':p2679') OR
(ALARMID=':p2680' AND ALARMGROUPID=':p2681') OR
(ALARMID=':p2682' AND ALARMGROUPID=':p2683') OR
(ALARMID=':p2684' AND ALARMGROUPID=':p2685') OR
(ALARMID=':p2686' AND ALARMGROUPID=':p2687') OR
(ALARMID=':p2688' AND ALARMGROUPID=':p2689') OR
(ALARMID=':p2690' AND ALARMGROUPID=':p2691') OR
(ALARMID=':p2692' AND ALARMGROUPID=':p2693') OR
(ALARMID=':p2694' AND ALARMGROUPID=':p2695') OR
(ALARMID=':p2696' AND ALARMGROUPID=':p2697') OR
(ALARMID=':p2698' AND ALARMGROUPID=':p2699') OR
(ALARMID=':p2700' AND ALARMGROUPID=':p2701') OR
(ALARMID=':p2702' AND ALARMGROUPID=':p2703') OR
(ALARMID=':p2704' AND ALARMGROUPID=':p2705') OR
(ALARMID=':p2706' AND ALARMGROUPID=':p2707') OR
(ALARMID=':p2708' AND ALARMGROUPID=':p2709') OR
(ALARMID=':p2710' AND ALARMGROUPID=':p2711') OR
(ALARMID=':p2712' AND ALARMGROUPID=':p2713') OR
(ALARMID=':p2714' AND ALARMGROUPID=':p2715') OR
(ALARMID=':p2716' AND ALARMGROUPID=':p2717') OR
(ALARMID=':p2718' AND ALARMGROUPID=':p2719') OR
(ALARMID=':p2720' AND ALARMGROUPID=':p2721') OR
(ALARMID=':p2722' AND ALARMGROUPID=':p2723') OR
(ALARMID=':p2724' AND ALARMGROUPID=':p2725') OR
(ALARMID=':p2726' AND ALARMGROUPID=':p2727') OR
(ALARMID=':p2728' AND ALARMGROUPID=':p2729') OR
(ALARMID=':p2730' AND ALARMGROUPID=':p2731') OR
(ALARMID=':p2732' AND ALARMGROUPID=':p2733') OR
(ALARMID=':p2734' AND ALARMGROUPID=':p2735') OR
(ALARMID=':p2736' AND ALARMGROUPID=':p2737') OR
(ALARMID=':p2738' AND ALARMGROUPID=':p2739') OR
(ALARMID=':p2740' AND ALARMGROUPID=':p2741') OR
(ALARMID=':p2742' AND ALARMGROUPID=':p2743') OR
(ALARMID=':p2744' AND ALARMGROUPID=':p2745') OR
(ALARMID=':p2746' AND ALARMGROUPID=':p2747') OR
(ALARMID=':p2748' AND ALARMGROUPID=':p2749') OR
(ALARMID=':p2750' AND ALARMGROUPID=':p2751') OR
(ALARMID=':p2752' AND ALARMGROUPID=':p2753') OR
(ALARMID=':p2754' AND ALARMGROUPID=':p2755') OR
(ALARMID=':p2756' AND ALARMGROUPID=':p2757') OR
(ALARMID=':p2758' AND ALARMGROUPID=':p2759') OR
(ALARMID=':p2760' AND ALARMGROUPID=':p2761') OR
(ALARMID=':p2762' AND ALARMGROUPID=':p2763') OR
(ALARMID=':p2764' AND ALARMGROUPID=':p2765') OR
(ALARMID=':p2766' AND ALARMGROUPID=':p2767') OR
(ALARMID=':p2768' AND ALARMGROUPID=':p2769') OR
(ALARMID=':p2770' AND ALARMGROUPID=':p2771') OR
(ALARMID=':p2772' AND ALARMGROUPID=':p2773') OR
(ALARMID=':p2774' AND ALARMGROUPID=':p2775') OR
(ALARMID=':p2776' AND ALARMGROUPID=':p2777') OR
(ALARMID=':p2778' AND ALARMGROUPID=':p2779') OR
(ALARMID=':p2780' AND ALARMGROUPID=':p2781') OR
(ALARMID=':p2782' AND ALARMGROUPID=':p2783') OR
(ALARMID=':p2784' AND ALARMGROUPID=':p2785') OR
(ALARMID=':p2786' AND ALARMGROUPID=':p2787') OR
(ALARMID=':p2788' AND ALARMGROUPID=':p2789') OR
(ALARMID=':p2790' AND ALARMGROUPID=':p2791') OR
(ALARMID=':p2792' AND ALARMGROUPID=':p2793') OR
(ALARMID=':p2794' AND ALARMGROUPID=':p2795') OR
(ALARMID=':p2796' AND ALARMGROUPID=':p2797') OR
(ALARMID=':p2798' AND ALARMGROUPID=':p2799') OR
(ALARMID=':p2800' AND ALARMGROUPID=':p2801') OR
(ALARMID=':p2802' AND ALARMGROUPID=':p2803') OR
(ALARMID=':p2804' AND ALARMGROUPID=':p2805') OR
(ALARMID=':p2806' AND ALARMGROUPID=':p2807') OR
(ALARMID=':p2808' AND ALARMGROUPID=':p2809') OR
(ALARMID=':p2810' AND ALARMGROUPID=':p2811') OR
(ALARMID=':p2812' AND ALARMGROUPID=':p2813') OR
(ALARMID=':p2814' AND ALARMGROUPID=':p2815') OR
(ALARMID=':p2816' AND ALARMGROUPID=':p2817') OR
(ALARMID=':p2818' AND ALARMGROUPID=':p2819') OR
(ALARMID=':p2820' AND ALARMGROUPID=':p2821') OR
(ALARMID=':p2822' AND ALARMGROUPID=':p2823') OR
(ALARMID=':p2824' AND ALARMGROUPID=':p2825') OR
(ALARMID=':p2826' AND ALARMGROUPID=':p2827') OR
(ALARMID=':p2828' AND ALARMGROUPID=':p2829') OR
(ALARMID=':p2830' AND ALARMGROUPID=':p2831') OR
(ALARMID=':p2832' AND ALARMGROUPID=':p2833') OR
(ALARMID=':p2834' AND ALARMGROUPID=':p2835') OR
(ALARMID=':p2836' AND ALARMGROUPID=':p2837') OR
(ALARMID=':p2838' AND ALARMGROUPID=':p2839') OR
(ALARMID=':p2840' AND ALARMGROUPID=':p2841') OR
(ALARMID=':p2842' AND ALARMGROUPID=':p2843') OR
(ALARMID=':p2844' AND ALARMGROUPID=':p2845') OR
(ALARMID=':p2846' AND ALARMGROUPID=':p2847') OR
(ALARMID=':p2848' AND ALARMGROUPID=':p2849') OR
(ALARMID=':p2850' AND ALARMGROUPID=':p2851') OR
(ALARMID=':p2852' AND ALARMGROUPID=':p2853') OR
(ALARMID=':p2854' AND ALARMGROUPID=':p2855') OR
(ALARMID=':p2856' AND ALARMGROUPID=':p2857') OR
(ALARMID=':p2858' AND ALARMGROUPID=':p2859') OR
(ALARMID=':p2860' AND ALARMGROUPID=':p2861') OR
(ALARMID=':p2862' AND ALARMGROUPID=':p2863') OR
(ALARMID=':p2864' AND ALARMGROUPID=':p2865') OR
(ALARMID=':p2866' AND ALARMGROUPID=':p2867') OR
(ALARMID=':p2868' AND ALARMGROUPID=':p2869') OR
(ALARMID=':p2870' AND ALARMGROUPID=':p2871') OR
(ALARMID=':p2872' AND ALARMGROUPID=':p2873') OR
(ALARMID=':p2874' AND ALARMGROUPID=':p2875') OR
(ALARMID=':p2876' AND ALARMGROUPID=':p2877') OR
(ALARMID=':p2878' AND ALARMGROUPID=':p2879') OR
(ALARMID=':p2880' AND ALARMGROUPID=':p2881') OR
(ALARMID=':p2882' AND ALARMGROUPID=':p2883') OR
(ALARMID=':p2884' AND ALARMGROUPID=':p2885') OR
(ALARMID=':p2886' AND ALARMGROUPID=':p2887') OR
(ALARMID=':p2888' AND ALARMGROUPID=':p2889') OR
(ALARMID=':p2890' AND ALARMGROUPID=':p2891') OR
(ALARMID=':p2892' AND ALARMGROUPID=':p2893') OR
(ALARMID=':p2894' AND ALARMGROUPID=':p2895') OR
(ALARMID=':p2896' AND ALARMGROUPID=':p2897') OR
(ALARMID=':p2898' AND ALARMGROUPID=':p2899') OR
(ALARMID=':p2900' AND ALARMGROUPID=':p2901') OR
(ALARMID=':p2902' AND ALARMGROUPID=':p2903') OR
(ALARMID=':p2904' AND ALARMGROUPID=':p2905') OR
(ALARMID=':p2906' AND ALARMGROUPID=':p2907') OR
(ALARMID=':p2908' AND ALARMGROUPID=':p2909') OR
(ALARMID=':p2910' AND ALARMGROUPID=':p2911') OR
(ALARMID=':p2912' AND ALARMGROUPID=':p2913') OR
(ALARMID=':p2914' AND ALARMGROUPID=':p2915') OR
(ALARMID=':p2916' AND ALARMGROUPID=':p2917') OR
(ALARMID=':p2918' AND ALARMGROUPID=':p2919') OR
(ALARMID=':p2920' AND ALARMGROUPID=':p2921') OR
(ALARMID=':p2922' AND ALARMGROUPID=':p2923') OR
(ALARMID=':p2924' AND ALARMGROUPID=':p2925') OR
(ALARMID=':p2926' AND ALARMGROUPID=':p2927') OR
(ALARMID=':p2928' AND ALARMGROUPID=':p2929') OR
(ALARMID=':p2930' AND ALARMGROUPID=':p2931') OR
(ALARMID=':p2932' AND ALARMGROUPID=':p2933') OR
(ALARMID=':p2934' AND ALARMGROUPID=':p2935') OR
(ALARMID=':p2936' AND ALARMGROUPID=':p2937') OR
(ALARMID=':p2938' AND ALARMGROUPID=':p2939') OR
(ALARMID=':p2940' AND ALARMGROUPID=':p2941') OR
(ALARMID=':p2942' AND ALARMGROUPID=':p2943') OR
(ALARMID=':p2944' AND ALARMGROUPID=':p2945') OR
(ALARMID=':p2946' AND ALARMGROUPID=':p2947') OR
(ALARMID=':p2948' AND ALARMGROUPID=':p2949') OR
(ALARMID=':p2950' AND ALARMGROUPID=':p2951') OR
(ALARMID=':p2952' AND ALARMGROUPID=':p2953') OR
(ALARMID=':p2954' AND ALARMGROUPID=':p2955') OR
(ALARMID=':p2956' AND ALARMGROUPID=':p2957') OR
(ALARMID=':p2958' AND ALARMGROUPID=':p2959') OR
(ALARMID=':p2960' AND ALARMGROUPID=':p2961') OR
(ALARMID=':p2962' AND ALARMGROUPID=':p2963') OR
(ALARMID=':p2964' AND ALARMGROUPID=':p2965') OR
(ALARMID=':p2966' AND ALARMGROUPID=':p2967') OR
(ALARMID=':p2968' AND ALARMGROUPID=':p2969') OR
(ALARMID=':p2970' AND ALARMGROUPID=':p2971') OR
(ALARMID=':p2972' AND ALARMGROUPID=':p2973') OR
(ALARMID=':p2974' AND ALARMGROUPID=':p2975') OR
(ALARMID=':p2976' AND ALARMGROUPID=':p2977') OR
(ALARMID=':p2978' AND ALARMGROUPID=':p2979') OR
(ALARMID=':p2980' AND ALARMGROUPID=':p2981') OR
(ALARMID=':p2982' AND ALARMGROUPID=':p2983') OR
(ALARMID=':p2984' AND ALARMGROUPID=':p2985') OR
(ALARMID=':p2986' AND ALARMGROUPID=':p2987') OR
(ALARMID=':p2988' AND ALARMGROUPID=':p2989') OR
(ALARMID=':p2990' AND ALARMGROUPID=':p2991') OR
(ALARMID=':p2992' AND ALARMGROUPID=':p2993') OR
(ALARMID=':p2994' AND ALARMGROUPID=':p2995') OR
(ALARMID=':p2996' AND ALARMGROUPID=':p2997') OR
(ALARMID=':p2998' AND ALARMGROUPID=':p2999') OR
(ALARMID=':p3000' AND ALARMGROUPID=':p3001') OR
(ALARMID=':p3002' AND ALARMGROUPID=':p3003') OR
(ALARMID=':p3004' AND ALARMGROUPID=':p3005') OR
(ALARMID=':p3006' AND ALARMGROUPID=':p3007') OR
(ALARMID=':p3008' AND ALARMGROUPID=':p3009') OR
(ALARMID=':p3010' AND ALARMGROUPID=':p3011') OR
(ALARMID=':p3012' AND ALARMGROUPID=':p3013') OR
(ALARMID=':p3014' AND ALARMGROUPID=':p3015') OR
(ALARMID=':p3016' AND ALARMGROUPID=':p3017') OR
(ALARMID=':p3018' AND ALARMGROUPID=':p3019') OR
(ALARMID=':p3020' AND ALARMGROUPID=':p3021') OR
(ALARMID=':p3022' AND ALARMGROUPID=':p3023') OR
(ALARMID=':p3024' AND ALARMGROUPID=':p3025') OR
(ALARMID=':p3026' AND ALARMGROUPID=':p3027') OR
(ALARMID=':p3028' AND ALARMGROUPID=':p3029') OR
(ALARMID=':p3030' AND ALARMGROUPID=':p3031') OR
(ALARMID=':p3032' AND ALARMGROUPID=':p3033') OR
(ALARMID=':p3034' AND ALARMGROUPID=':p3035') OR
(ALARMID=':p3036' AND ALARMGROUPID=':p3037') OR
(ALARMID=':p3038' AND ALARMGROUPID=':p3039') OR
(ALARMID=':p3040' AND ALARMGROUPID=':p3041') OR
(ALARMID=':p3042' AND ALARMGROUPID=':p3043') OR
(ALARMID=':p3044' AND ALARMGROUPID=':p3045') OR
(ALARMID=':p3046' AND ALARMGROUPID=':p3047') OR
(ALARMID=':p3048' AND ALARMGROUPID=':p3049') OR
(ALARMID=':p3050' AND ALARMGROUPID=':p3051') OR
(ALARMID=':p3052' AND ALARMGROUPID=':p3053') OR
(ALARMID=':p3054' AND ALARMGROUPID=':p3055') OR
(ALARMID=':p3056' AND ALARMGROUPID=':p3057') OR
(ALARMID=':p3058' AND ALARMGROUPID=':p3059') OR
(ALARMID=':p3060' AND ALARMGROUPID=':p3061') OR
(ALARMID=':p3062' AND ALARMGROUPID=':p3063') OR
(ALARMID=':p3064' AND ALARMGROUPID=':p3065') OR
(ALARMID=':p3066' AND ALARMGROUPID=':p3067') OR
(ALARMID=':p3068' AND ALARMGROUPID=':p3069') OR
(ALARMID=':p3070' AND ALARMGROUPID=':p3071') OR
(ALARMID=':p3072' AND ALARMGROUPID=':p3073') OR
(ALARMID=':p3074' AND ALARMGROUPID=':p3075') OR
(ALARMID=':p3076' AND ALARMGROUPID=':p3077') OR
(ALARMID=':p3078' AND ALARMGROUPID=':p3079') OR
(ALARMID=':p3080' AND ALARMGROUPID=':p3081') OR
(ALARMID=':p3082' AND ALARMGROUPID=':p3083') OR
(ALARMID=':p3084' AND ALARMGROUPID=':p3085') OR
(ALARMID=':p3086' AND ALARMGROUPID=':p3087') OR
(ALARMID=':p3088' AND ALARMGROUPID=':p3089') OR
(ALARMID=':p3090' AND ALARMGROUPID=':p3091') OR
(ALARMID=':p3092' AND ALARMGROUPID=':p3093') OR
(ALARMID=':p3094' AND ALARMGROUPID=':p3095') OR
(ALARMID=':p3096' AND ALARMGROUPID=':p3097') OR
(ALARMID=':p3098' AND ALARMGROUPID=':p3099') OR
(ALARMID=':p3100' AND ALARMGROUPID=':p3101') OR
(ALARMID=':p3102' AND ALARMGROUPID=':p3103') OR
(ALARMID=':p3104' AND ALARMGROUPID=':p3105') OR
(ALARMID=':p3106' AND ALARMGROUPID=':p3107') OR
(ALARMID=':p3108' AND ALARMGROUPID=':p3109') OR
(ALARMID=':p3110' AND ALARMGROUPID=':p3111') OR
(ALARMID=':p3112' AND ALARMGROUPID=':p3113') OR
(ALARMID=':p3114' AND ALARMGROUPID=':p3115') OR
(ALARMID=':p3116' AND ALARMGROUPID=':p3117') OR
(ALARMID=':p3118' AND ALARMGROUPID=':p3119') OR
(ALARMID=':p3120' AND ALARMGROUPID=':p3121') OR
(ALARMID=':p3122' AND ALARMGROUPID=':p3123') OR
(ALARMID=':p3124' AND ALARMGROUPID=':p3125') OR
(ALARMID=':p3126' AND ALARMGROUPID=':p3127') OR
(ALARMID=':p3128' AND ALARMGROUPID=':p3129') OR
(ALARMID=':p3130' AND ALARMGROUPID=':p3131') OR
(ALARMID=':p3132' AND ALARMGROUPID=':p3133') OR
(ALARMID=':p3134' AND ALARMGROUPID=':p3135') OR
(ALARMID=':p3136' AND ALARMGROUPID=':p3137') OR
(ALARMID=':p3138' AND ALARMGROUPID=':p3139') OR
(ALARMID=':p3140' AND ALARMGROUPID=':p3141') OR
(ALARMID=':p3142' AND ALARMGROUPID=':p3143') OR
(ALARMID=':p3144' AND ALARMGROUPID=':p3145') OR
(ALARMID=':p3146' AND ALARMGROUPID=':p3147') OR
(ALARMID=':p3148' AND ALARMGROUPID=':p3149') OR
(ALARMID=':p3150' AND ALARMGROUPID=':p3151') OR
(ALARMID=':p3152' AND ALARMGROUPID=':p3153') OR
(ALARMID=':p3154' AND ALARMGROUPID=':p3155') OR
(ALARMID=':p3156' AND ALARMGROUPID=':p3157') OR
(ALARMID=':p3158' AND ALARMGROUPID=':p3159') OR
(ALARMID=':p3160' AND ALARMGROUPID=':p3161') OR
(ALARMID=':p3162' AND ALARMGROUPID=':p3163') OR
(ALARMID=':p3164' AND ALARMGROUPID=':p3165') OR
(ALARMID=':p3166' AND ALARMGROUPID=':p3167') OR
(ALARMID=':p3168' AND ALARMGROUPID=':p3169') OR
(ALARMID=':p3170' AND ALARMGROUPID=':p3171') OR
(ALARMID=':p3172' AND ALARMGROUPID=':p3173') OR
(ALARMID=':p3174' AND ALARMGROUPID=':p3175') OR
(ALARMID=':p3176' AND ALARMGROUPID=':p3177') OR
(ALARMID=':p3178' AND ALARMGROUPID=':p3179') OR
(ALARMID=':p3180' AND ALARMGROUPID=':p3181') OR
(ALARMID=':p3182' AND ALARMGROUPID=':p3183') OR
(ALARMID=':p3184' AND ALARMGROUPID=':p3185') OR
(ALARMID=':p3186' AND ALARMGROUPID=':p3187') OR
(ALARMID=':p3188' AND ALARMGROUPID=':p3189') OR
(ALARMID=':p3190' AND ALARMGROUPID=':p3191') OR
(ALARMID=':p3192' AND ALARMGROUPID=':p3193') OR
(ALARMID=':p3194' AND ALARMGROUPID=':p3195') OR
(ALARMID=':p3196' AND ALARMGROUPID=':p3197') OR
(ALARMID=':p3198' AND ALARMGROUPID=':p3199') OR
(ALARMID=':p3200' AND ALARMGROUPID=':p3201') OR
(ALARMID=':p3202' AND ALARMGROUPID=':p3203') OR
(ALARMID=':p3204' AND ALARMGROUPID=':p3205') OR
(ALARMID=':p3206' AND ALARMGROUPID=':p3207') OR
(ALARMID=':p3208' AND ALARMGROUPID=':p3209') OR
(ALARMID=':p3210' AND ALARMGROUPID=':p3211') OR
(ALARMID=':p3212' AND ALARMGROUPID=':p3213') OR
(ALARMID=':p3214' AND ALARMGROUPID=':p3215') OR
(ALARMID=':p3216' AND ALARMGROUPID=':p3217') OR
(ALARMID=':p3218' AND ALARMGROUPID=':p3219') OR
(ALARMID=':p3220' AND ALARMGROUPID=':p3221') OR
(ALARMID=':p3222' AND ALARMGROUPID=':p3223') OR
(ALARMID=':p3224' AND ALARMGROUPID=':p3225') OR
(ALARMID=':p3226' AND ALARMGROUPID=':p3227') OR
(ALARMID=':p3228' AND ALARMGROUPID=':p3229') OR
(ALARMID=':p3230' AND ALARMGROUPID=':p3231') OR
(ALARMID=':p3232' AND ALARMGROUPID=':p3233') OR
(ALARMID=':p3234' AND ALARMGROUPID=':p3235') OR
(ALARMID=':p3236' AND ALARMGROUPID=':p3237') OR
(ALARMID=':p3238' AND ALARMGROUPID=':p3239') OR
(ALARMID=':p3240' AND ALARMGROUPID=':p3241') OR
(ALARMID=':p3242' AND ALARMGROUPID=':p3243') OR
(ALARMID=':p3244' AND ALARMGROUPID=':p3245') OR
(ALARMID=':p3246' AND ALARMGROUPID=':p3247') OR
(ALARMID=':p3248' AND ALARMGROUPID=':p3249') OR
(ALARMID=':p3250' AND ALARMGROUPID=':p3251') OR
(ALARMID=':p3252' AND ALARMGROUPID=':p3253') OR
(ALARMID=':p3254' AND ALARMGROUPID=':p3255') OR
(ALARMID=':p3256' AND ALARMGROUPID=':p3257') OR
(ALARMID=':p3258' AND ALARMGROUPID=':p3259') OR
(ALARMID=':p3260' AND ALARMGROUPID=':p3261') OR
(ALARMID=':p3262' AND ALARMGROUPID=':p3263') OR
(ALARMID=':p3264' AND ALARMGROUPID=':p3265') OR
(ALARMID=':p3266' AND ALARMGROUPID=':p3267') OR
(ALARMID=':p3268' AND ALARMGROUPID=':p3269') OR
(ALARMID=':p3270' AND ALARMGROUPID=':p3271') OR
(ALARMID=':p3272' AND ALARMGROUPID=':p3273') OR
(ALARMID=':p3274' AND ALARMGROUPID=':p3275') OR
(ALARMID=':p3276' AND ALARMGROUPID=':p3277') OR
(ALARMID=':p3278' AND ALARMGROUPID=':p3279') OR
(ALARMID=':p3280' AND ALARMGROUPID=':p3281') OR
(ALARMID=':p3282' AND ALARMGROUPID=':p3283') OR
(ALARMID=':p3284' AND ALARMGROUPID=':p3285') OR
(ALARMID=':p3286' AND ALARMGROUPID=':p3287') OR
(ALARMID=':p3288' AND ALARMGROUPID=':p3289') OR
(ALARMID=':p3290' AND ALARMGROUPID=':p3291') OR
(ALARMID=':p3292' AND ALARMGROUPID=':p3293') OR
(ALARMID=':p3294' AND ALARMGROUPID=':p3295') OR
(ALARMID=':p3296' AND ALARMGROUPID=':p3297') OR
(ALARMID=':p3298' AND ALARMGROUPID=':p3299') OR
(ALARMID=':p3300' AND ALARMGROUPID=':p3301') OR
(ALARMID=':p3302' AND ALARMGROUPID=':p3303') OR
(ALARMID=':p3304' AND ALARMGROUPID=':p3305') OR
(ALARMID=':p3306' AND ALARMGROUPID=':p3307') OR
(ALARMID=':p3308' AND ALARMGROUPID=':p3309') OR
(ALARMID=':p3310' AND ALARMGROUPID=':p3311') OR
(ALARMID=':p3312' AND ALARMGROUPID=':p3313') OR
(ALARMID=':p3314' AND ALARMGROUPID=':p3315') OR
(ALARMID=':p3316' AND ALARMGROUPID=':p3317') OR
(ALARMID=':p3318' AND ALARMGROUPID=':p3319') OR
(ALARMID=':p3320' AND ALARMGROUPID=':p3321') OR
(ALARMID=':p3322' AND ALARMGROUPID=':p3323') OR
(ALARMID=':p3324' AND ALARMGROUPID=':p3325') OR
(ALARMID=':p3326' AND ALARMGROUPID=':p3327') OR
(ALARMID=':p3328' AND ALARMGROUPID=':p3329') OR
(ALARMID=':p3330' AND ALARMGROUPID=':p3331') OR
(ALARMID=':p3332' AND ALARMGROUPID=':p3333') OR
(ALARMID=':p3334' AND ALARMGROUPID=':p3335') OR
(ALARMID=':p3336' AND ALARMGROUPID=':p3337') OR
(ALARMID=':p3338' AND ALARMGROUPID=':p3339') OR
(ALARMID=':p3340' AND ALARMGROUPID=':p3341') OR
(ALARMID=':p3342' AND ALARMGROUPID=':p3343') OR
(ALARMID=':p3344' AND ALARMGROUPID=':p3345') OR
(ALARMID=':p3346' AND ALARMGROUPID=':p3347') OR
(ALARMID=':p3348' AND ALARMGROUPID=':p3349') OR
(ALARMID=':p3350' AND ALARMGROUPID=':p3351') OR
(ALARMID=':p3352' AND ALARMGROUPID=':p3353') OR
(ALARMID=':p3354' AND ALARMGROUPID=':p3355') OR
(ALARMID=':p3356' AND ALARMGROUPID=':p3357') OR
(ALARMID=':p3358' AND ALARMGROUPID=':p3359') OR
(ALARMID=':p3360' AND ALARMGROUPID=':p3361') OR
(ALARMID=':p3362' AND ALARMGROUPID=':p3363') OR
(ALARMID=':p3364' AND ALARMGROUPID=':p3365') OR
(ALARMID=':p3366' AND ALARMGROUPID=':p3367') OR
(ALARMID=':p3368' AND ALARMGROUPID=':p3369') OR
(ALARMID=':p3370' AND ALARMGROUPID=':p3371') OR
(ALARMID=':p3372' AND ALARMGROUPID=':p3373') OR
(ALARMID=':p3374' AND ALARMGROUPID=':p3375') OR
(ALARMID=':p3376' AND ALARMGROUPID=':p3377') OR
(ALARMID=':p3378' AND ALARMGROUPID=':p3379') OR
(ALARMID=':p3380' AND ALARMGROUPID=':p3381') OR
(ALARMID=':p3382' AND ALARMGROUPID=':p3383') OR
(ALARMID=':p3384' AND ALARMGROUPID=':p3385') OR
(ALARMID=':p3386' AND ALARMGROUPID=':p3387') OR
(ALARMID=':p3388' AND ALARMGROUPID=':p3389') OR
(ALARMID=':p3390' AND ALARMGROUPID=':p3391') OR
(ALARMID=':p3392' AND ALARMGROUPID=':p3393') OR
(ALARMID=':p3394' AND ALARMGROUPID=':p3395') OR
(ALARMID=':p3396' AND ALARMGROUPID=':p3397') OR
(ALARMID=':p3398' AND ALARMGROUPID=':p3399') OR
(ALARMID=':p3400' AND ALARMGROUPID=':p3401') OR
(ALARMID=':p3402' AND ALARMGROUPID=':p3403') OR
(ALARMID=':p3404' AND ALARMGROUPID=':p3405') OR
(ALARMID=':p3406' AND ALARMGROUPID=':p3407') OR
(ALARMID=':p3408' AND ALARMGROUPID=':p3409') OR
(ALARMID=':p3410' AND ALARMGROUPID=':p3411') OR
(ALARMID=':p3412' AND ALARMGROUPID=':p3413') OR
(ALARMID=':p3414' AND ALARMGROUPID=':p3415') OR
(ALARMID=':p3416' AND ALARMGROUPID=':p3417') OR
(ALARMID=':p3418' AND ALARMGROUPID=':p3419') OR
(ALARMID=':p3420' AND ALARMGROUPID=':p3421') OR
(ALARMID=':p3422' AND ALARMGROUPID=':p3423') OR
(ALARMID=':p3424' AND ALARMGROUPID=':p3425') OR
(ALARMID=':p3426' AND ALARMGROUPID=':p3427') OR
(ALARMID=':p3428' AND ALARMGROUPID=':p3429') OR
(ALARMID=':p3430' AND ALARMGROUPID=':p3431') OR
(ALARMID=':p3432' AND ALARMGROUPID=':p3433') OR
(ALARMID=':p3434' AND ALARMGROUPID=':p3435') OR
(ALARMID=':p3436' AND ALARMGROUPID=':p3437') OR
(ALARMID=':p3438' AND ALARMGROUPID=':p3439') OR
(ALARMID=':p3440' AND ALARMGROUPID=':p3441') OR
(ALARMID=':p3442' AND ALARMGROUPID=':p3443') OR
(ALARMID=':p3444' AND ALARMGROUPID=':p3445') OR
(ALARMID=':p3446' AND ALARMGROUPID=':p3447') OR
(ALARMID=':p3448' AND ALARMGROUPID=':p3449') OR
(ALARMID=':p3450' AND ALARMGROUPID=':p3451') OR
(ALARMID=':p3452' AND ALARMGROUPID=':p3453') OR
(ALARMID=':p3454' AND ALARMGROUPID=':p3455') OR
(ALARMID=':p3456' AND ALARMGROUPID=':p3457') OR
(ALARMID=':p3458' AND ALARMGROUPID=':p3459') OR
(ALARMID=':p3460' AND ALARMGROUPID=':p3461') OR
(ALARMID=':p3462' AND ALARMGROUPID=':p3463') OR
(ALARMID=':p3464' AND ALARMGROUPID=':p3465') OR
(ALARMID=':p2' AND ALARMGROUPID=':p3') OR
(ALARMID=':p4' AND ALARMGROUPID=':p5') OR
(ALARMID=':p6' AND ALARMGROUPID=':p7') OR
(ALARMID=':p8' AND ALARMGROUPID=':p9') OR
(ALARMID=':p10' AND ALARMGROUPID=':p11') OR
(ALARMID=':p12' AND ALARMGROUPID=':p13') OR
(ALARMID=':p14' AND ALARMGROUPID=':p15') OR
(ALARMID=':p16' AND ALARMGROUPID=':p17') OR
(ALARMID=':p18' AND ALARMGROUPID=':p19') OR
(ALARMID=':p20' AND ALARMGROUPID=':p21') OR
(ALARMID=':p22' AND ALARMGROUPID=':p23') OR
(ALARMID=':p24' AND ALARMGROUPID=':p25') OR
(ALARMID=':p26' AND ALARMGROUPID=':p27') OR
(ALARMID=':p28' AND ALARMGROUPID=':p29') OR
(ALARMID=':p30' AND ALARMGROUPID=':p31') OR
(ALARMID=':p32' AND ALARMGROUPID=':p33') OR
(ALARMID=':p34' AND ALARMGROUPID=':p35') OR
(ALARMID=':p36' AND ALARMGROUPID=':p37') OR
(ALARMID=':p38' AND ALARMGROUPID=':p39') OR
(ALARMID=':p40' AND ALARMGROUPID=':p41') OR
(ALARMID=':p42' AND ALARMGROUPID=':p43') OR
(ALARMID=':p44' AND ALARMGROUPID=':p45') OR
(ALARMID=':p46' AND ALARMGROUPID=':p47') OR
(ALARMID=':p48' AND ALARMGROUPID=':p49') OR
(ALARMID=':p50' AND ALARMGROUPID=':p51') OR
(ALARMID=':p52' AND ALARMGROUPID=':p53') OR
(ALARMID=':p54' AND ALARMGROUPID=':p55') OR
(ALARMID=':p56' AND ALARMGROUPID=':p57') OR
(ALARMID=':p58' AND ALARMGROUPID=':p59') OR
(ALARMID=':p60' AND ALARMGROUPID=':p61') OR
(ALARMID=':p62' AND ALARMGROUPID=':p63') OR
(ALARMID=':p64' AND ALARMGROUPID=':p65') OR
(ALARMID=':p66' AND ALARMGROUPID=':p67') OR
(ALARMID=':p68' AND ALARMGROUPID=':p69') OR
(ALARMID=':p70' AND ALARMGROUPID=':p71') OR
(ALARMID=':p72' AND ALARMGROUPID=':p73') OR
(ALARMID=':p74' AND ALARMGROUPID=':p75') OR
(ALARMID=':p76' AND ALARMGROUPID=':p77') OR
(ALARMID=':p78' AND ALARMGROUPID=':p79') OR
(ALARMID=':p80' AND ALARMGROUPID=':p81') OR
(ALARMID=':p82' AND ALARMGROUPID=':p83') OR
(ALARMID=':p84' AND ALARMGROUPID=':p85') OR
(ALARMID=':p86' AND ALARMGROUPID=':p87') OR
(ALARMID=':p88' AND ALARMGROUPID=':p89') OR
(ALARMID=':p90' AND ALARMGROUPID=':p91') OR
(ALARMID=':p92' AND ALARMGROUPID=':p93') OR
(ALARMID=':p94' AND ALARMGROUPID=':p95') OR
(ALARMID=':p96' AND ALARMGROUPID=':p97') OR
(ALARMID=':p98' AND ALARMGROUPID=':p99') OR
(ALARMID=':p100' AND ALARMGROUPID=':p101') OR
(ALARMID=':p102' AND ALARMGROUPID=':p103') OR
(ALARMID=':p104' AND ALARMGROUPID=':p105') OR
(ALARMID=':p106' AND ALARMGROUPID=':p107') OR
(ALARMID=':p108' AND ALARMGROUPID=':p109') OR
(ALARMID=':p110' AND ALARMGROUPID=':p111') OR
(ALARMID=':p112' AND ALARMGROUPID=':p113') OR
(ALARMID=':p114' AND ALARMGROUPID=':p115') OR
(ALARMID=':p116' AND ALARMGROUPID=':p117') OR
(ALARMID=':p118' AND ALARMGROUPID=':p119') OR
(ALARMID=':p120' AND ALARMGROUPID=':p121') OR
(ALARMID=':p122' AND ALARMGROUPID=':p123') OR
(ALARMID=':p124' AND ALARMGROUPID=':p125') OR
(ALARMID=':p126' AND ALARMGROUPID=':p127') OR
(ALARMID=':p128' AND ALARMGROUPID=':p129') OR
(ALARMID=':p130' AND ALARMGROUPID=':p131') OR
(ALARMID=':p132' AND ALARMGROUPID=':p133') OR
(ALARMID=':p134' AND ALARMGROUPID=':p135') OR
(ALARMID=':p136' AND ALARMGROUPID=':p137') OR
(ALARMID=':p138' AND ALARMGROUPID=':p139') OR
(ALARMID=':p140' AND ALARMGROUPID=':p141') OR
(ALARMID=':p142' AND ALARMGROUPID=':p143') OR
(ALARMID=':p144' AND ALARMGROUPID=':p145') OR
(ALARMID=':p146' AND ALARMGROUPID=':p147') OR
(ALARMID=':p148' AND ALARMGROUPID=':p149') OR
(ALARMID=':p150' AND ALARMGROUPID=':p151') OR
(ALARMID=':p152' AND ALARMGROUPID=':p153') OR
(ALARMID=':p154' AND ALARMGROUPID=':p155') OR
(ALARMID=':p156' AND ALARMGROUPID=':p157') OR
(ALARMID=':p158' AND ALARMGROUPID=':p159') OR
(ALARMID=':p160' AND ALARMGROUPID=':p161') OR
(ALARMID=':p162' AND ALARMGROUPID=':p163') OR
(ALARMID=':p164' AND ALARMGROUPID=':p165') OR
(ALARMID=':p166' AND ALARMGROUPID=':p167') OR
(ALARMID=':p168' AND ALARMGROUPID=':p169') OR
(ALARMID=':p170' AND ALARMGROUPID=':p171') OR
(ALARMID=':p172' AND ALARMGROUPID=':p173') OR
(ALARMID=':p174' AND ALARMGROUPID=':p175') OR
(ALARMID=':p176' AND ALARMGROUPID=':p177') OR
(ALARMID=':p178' AND ALARMGROUPID=':p179') OR
(ALARMID=':p180' AND ALARMGROUPID=':p181') OR
(ALARMID=':p182' AND ALARMGROUPID=':p183') OR
(ALARMID=':p184' AND ALARMGROUPID=':p185') OR
(ALARMID=':p186' AND ALARMGROUPID=':p187') OR
(ALARMID=':p188' AND ALARMGROUPID=':p189') OR
(ALARMID=':p190' AND ALARMGROUPID=':p191') OR
(ALARMID=':p192' AND ALARMGROUPID=':p193') OR
(ALARMID=':p194' AND ALARMGROUPID=':p195') OR
(ALARMID=':p196' AND ALARMGROUPID=':p197') OR
(ALARMID=':p198' AND ALARMGROUPID=':p199') OR
(ALARMID=':p200' AND ALARMGROUPID=':p201') OR
(ALARMID=':p202' AND ALARMGROUPID=':p203') OR
(ALARMID=':p204' AND ALARMGROUPID=':p205') OR
(ALARMID=':p206' AND ALARMGROUPID=':p207') OR
(ALARMID=':p208' AND ALARMGROUPID=':p209') OR
(ALARMID=':p210' AND ALARMGROUPID=':p211') OR
(ALARMID=':p212' AND ALARMGROUPID=':p213') OR
(ALARMID=':p214' AND ALARMGROUPID=':p215') OR
(ALARMID=':p216' AND ALARMGROUPID=':p217') OR
(ALARMID=':p218' AND ALARMGROUPID=':p219') OR
(ALARMID=':p220' AND ALARMGROUPID=':p221') OR
(ALARMID=':p222' AND ALARMGROUPID=':p223') OR
(ALARMID=':p224' AND ALARMGROUPID=':p225') OR
(ALARMID=':p226' AND ALARMGROUPID=':p227') OR
(ALARMID=':p228' AND ALARMGROUPID=':p229') OR
(ALARMID=':p230' AND ALARMGROUPID=':p231') OR
(ALARMID=':p232' AND ALARMGROUPID=':p233') OR
(ALARMID=':p234' AND ALARMGROUPID=':p235') OR
(ALARMID=':p236' AND ALARMGROUPID=':p237') OR
(ALARMID=':p238' AND ALARMGROUPID=':p239') OR
(ALARMID=':p240' AND ALARMGROUPID=':p241') OR
(ALARMID=':p242' AND ALARMGROUPID=':p243') OR
(ALARMID=':p244' AND ALARMGROUPID=':p245') OR
(ALARMID=':p246' AND ALARMGROUPID=':p247') OR
(ALARMID=':p248' AND ALARMGROUPID=':p249') OR
(ALARMID=':p250' AND ALARMGROUPID=':p251') OR
(ALARMID=':p252' AND ALARMGROUPID=':p253') OR
(ALARMID=':p254' AND ALARMGROUPID=':p255') OR
(ALARMID=':p256' AND ALARMGROUPID=':p257') OR
(ALARMID=':p258' AND ALARMGROUPID=':p259') OR
(ALARMID=':p260' AND ALARMGROUPID=':p261') OR
(ALARMID=':p262' AND ALARMGROUPID=':p263') OR
(ALARMID=':p264' AND ALARMGROUPID=':p265') OR
(ALARMID=':p266' AND ALARMGROUPID=':p267') OR
(ALARMID=':p268' AND ALARMGROUPID=':p269') OR
(ALARMID=':p270' AND ALARMGROUPID=':p271') OR
(ALARMID=':p272' AND ALARMGROUPID=':p273') OR
(ALARMID=':p274' AND ALARMGROUPID=':p275') OR
(ALARMID=':p276' AND ALARMGROUPID=':p277') OR
(ALARMID=':p278' AND ALARMGROUPID=':p279') OR
(ALARMID=':p280' AND ALARMGROUPID=':p281') OR
(ALARMID=':p282' AND ALARMGROUPID=':p283') OR
(ALARMID=':p284' AND ALARMGROUPID=':p285') OR
(ALARMID=':p286' AND ALARMGROUPID=':p287') OR
(ALARMID=':p288' AND ALARMGROUPID=':p289') OR
(ALARMID=':p290' AND ALARMGROUPID=':p291') OR
(ALARMID=':p292' AND ALARMGROUPID=':p293') OR
(ALARMID=':p294' AND ALARMGROUPID=':p295') OR
(ALARMID=':p296' AND ALARMGROUPID=':p297') OR
(ALARMID=':p298' AND ALARMGROUPID=':p299') OR
(ALARMID=':p300' AND ALARMGROUPID=':p301') OR
(ALARMID=':p302' AND ALARMGROUPID=':p303') OR
(ALARMID=':p304' AND ALARMGROUPID=':p305') OR
(ALARMID=':p306' AND ALARMGROUPID=':p307') OR
(ALARMID=':p308' AND ALARMGROUPID=':p309') OR
(ALARMID=':p310' AND ALARMGROUPID=':p311') OR
(ALARMID=':p312' AND ALARMGROUPID=':p313') OR
(ALARMID=':p314' AND ALARMGROUPID=':p315') OR
(ALARMID=':p316' AND ALARMGROUPID=':p317') OR
(ALARMID=':p318' AND ALARMGROUPID=':p319') OR
(ALARMID=':p320' AND ALARMGROUPID=':p321') OR
(ALARMID=':p322' AND ALARMGROUPID=':p323') OR
(ALARMID=':p324' AND ALARMGROUPID=':p325') OR
(ALARMID=':p326' AND ALARMGROUPID=':p327') OR
(ALARMID=':p328' AND ALARMGROUPID=':p329') OR
(ALARMID=':p330' AND ALARMGROUPID=':p331') OR
(ALARMID=':p332' AND ALARMGROUPID=':p333') OR
(ALARMID=':p334' AND ALARMGROUPID=':p335') OR
(ALARMID=':p336' AND ALARMGROUPID=':p337') OR
(ALARMID=':p338' AND ALARMGROUPID=':p339') OR
(ALARMID=':p340' AND ALARMGROUPID=':p341') OR
(ALARMID=':p342' AND ALARMGROUPID=':p343') OR
(ALARMID=':p344' AND ALARMGROUPID=':p345') OR
(ALARMID=':p346' AND ALARMGROUPID=':p347') OR
(ALARMID=':p348' AND ALARMGROUPID=':p349') OR
(ALARMID=':p350' AND ALARMGROUPID=':p351') OR
(ALARMID=':p352' AND ALARMGROUPID=':p353') OR
(ALARMID=':p354' AND ALARMGROUPID=':p355') OR
(ALARMID=':p356' AND ALARMGROUPID=':p357') OR
(ALARMID=':p358' AND ALARMGROUPID=':p359') OR
(ALARMID=':p360' AND ALARMGROUPID=':p361') OR
(ALARMID=':p362' AND ALARMGROUPID=':p363') OR
(ALARMID=':p364' AND ALARMGROUPID=':p365') OR
(ALARMID=':p366' AND ALARMGROUPID=':p367') OR
(ALARMID=':p368' AND ALARMGROUPID=':p369') OR
(ALARMID=':p370' AND ALARMGROUPID=':p371') OR
(ALARMID=':p372' AND ALARMGROUPID=':p373') OR
(ALARMID=':p374' AND ALARMGROUPID=':p375') OR
(ALARMID=':p376' AND ALARMGROUPID=':p377') OR
(ALARMID=':p378' AND ALARMGROUPID=':p379') OR
(ALARMID=':p380' AND ALARMGROUPID=':p381') OR
(ALARMID=':p382' AND ALARMGROUPID=':p383') OR
(ALARMID=':p384' AND ALARMGROUPID=':p385') OR
(ALARMID=':p386' AND ALARMGROUPID=':p387') OR
(ALARMID=':p388' AND ALARMGROUPID=':p389') OR
(ALARMID=':p390' AND ALARMGROUPID=':p391') OR
(ALARMID=':p392' AND ALARMGROUPID=':p393') OR
(ALARMID=':p394' AND ALARMGROUPID=':p395') OR
(ALARMID=':p396' AND ALARMGROUPID=':p397') OR
(ALARMID=':p398' AND ALARMGROUPID=':p399') OR
(ALARMID=':p400' AND ALARMGROUPID=':p401') OR
(ALARMID=':p402' AND ALARMGROUPID=':p403') OR
(ALARMID=':p404' AND ALARMGROUPID=':p405') OR
(ALARMID=':p406' AND ALARMGROUPID=':p407') OR
(ALARMID=':p408' AND ALARMGROUPID=':p409') OR
(ALARMID=':p410' AND ALARMGROUPID=':p411') OR
(ALARMID=':p412' AND ALARMGROUPID=':p413') OR
(ALARMID=':p414' AND ALARMGROUPID=':p415') OR
(ALARMID=':p416' AND ALARMGROUPID=':p417') OR
(ALARMID=':p418' AND ALARMGROUPID=':p419') OR
(ALARMID=':p420' AND ALARMGROUPID=':p421') OR
(ALARMID=':p422' AND ALARMGROUPID=':p423') OR
(ALARMID=':p424' AND ALARMGROUPID=':p425') OR
(ALARMID=':p426' AND ALARMGROUPID=':p427') OR
(ALARMID=':p428' AND ALARMGROUPID=':p429') OR
(ALARMID=':p430' AND ALARMGROUPID=':p431') OR
(ALARMID=':p432' AND ALARMGROUPID=':p433') OR
(ALARMID=':p434' AND ALARMGROUPID=':p435') OR
(ALARMID=':p436' AND ALARMGROUPID=':p437') OR
(ALARMID=':p438' AND ALARMGROUPID=':p439') OR
(ALARMID=':p440' AND ALARMGROUPID=':p441') OR
(ALARMID=':p442' AND ALARMGROUPID=':p443') OR
(ALARMID=':p444' AND ALARMGROUPID=':p445') OR
(ALARMID=':p446' AND ALARMGROUPID=':p447') OR
(ALARMID=':p448' AND ALARMGROUPID=':p449') OR
(ALARMID=':p450' AND ALARMGROUPID=':p451') OR
(ALARMID=':p452' AND ALARMGROUPID=':p453') OR
(ALARMID=':p454' AND ALARMGROUPID=':p455') OR
(ALARMID=':p456' AND ALARMGROUPID=':p457') OR
(ALARMID=':p458' AND ALARMGROUPID=':p459') OR
(ALARMID=':p460' AND ALARMGROUPID=':p461') OR
(ALARMID=':p462' AND ALARMGROUPID=':p463') OR
(ALARMID=':p464' AND ALARMGROUPID=':p465') OR
(ALARMID=':p466' AND ALARMGROUPID=':p467') OR
(ALARMID=':p468' AND ALARMGROUPID=':p469') OR
(ALARMID=':p470' AND ALARMGROUPID=':p471') OR
(ALARMID=':p472' AND ALARMGROUPID=':p473') OR
(ALARMID=':p474' AND ALARMGROUPID=':p475') OR
(ALARMID=':p476' AND ALARMGROUPID=':p477') OR
(ALARMID=':p478' AND ALARMGROUPID=':p479') OR
(ALARMID=':p480' AND ALARMGROUPID=':p481') OR
(ALARMID=':p482' AND ALARMGROUPID=':p483') OR
(ALARMID=':p484' AND ALARMGROUPID=':p485') OR
(ALARMID=':p486' AND ALARMGROUPID=':p487') OR
(ALARMID=':p488' AND ALARMGROUPID=':p489') OR
(ALARMID=':p490' AND ALARMGROUPID=':p491') OR
(ALARMID=':p492' AND ALARMGROUPID=':p493') OR
(ALARMID=':p494' AND ALARMGROUPID=':p495') OR
(ALARMID=':p496' AND ALARMGROUPID=':p497') OR
(ALARMID=':p498' AND ALARMGROUPID=':p499') OR
(ALARMID=':p500' AND ALARMGROUPID=':p501') OR
(ALARMID=':p502' AND ALARMGROUPID=':p503') OR
(ALARMID=':p504' AND ALARMGROUPID=':p505') OR
(ALARMID=':p506' AND ALARMGROUPID=':p507') OR
(ALARMID=':p508' AND ALARMGROUPID=':p509') OR
(ALARMID=':p510' AND ALARMGROUPID=':p511') OR
(ALARMID=':p512' AND ALARMGROUPID=':p513') OR
(ALARMID=':p514' AND ALARMGROUPID=':p515') OR
(ALARMID=':p516' AND ALARMGROUPID=':p517') OR
(ALARMID=':p518' AND ALARMGROUPID=':p519') OR
(ALARMID=':p520' AND ALARMGROUPID=':p521') OR
(ALARMID=':p522' AND ALARMGROUPID=':p523') OR
(ALARMID=':p524' AND ALARMGROUPID=':p525') OR
(ALARMID=':p526' AND ALARMGROUPID=':p527') OR
(ALARMID=':p528' AND ALARMGROUPID=':p529') OR
(ALARMID=':p530' AND ALARMGROUPID=':p531') OR
(ALARMID=':p532' AND ALARMGROUPID=':p533') OR
(ALARMID=':p534' AND ALARMGROUPID=':p535') OR
(ALARMID=':p536' AND ALARMGROUPID=':p537') OR
(ALARMID=':p538' AND ALARMGROUPID=':p539') OR
(ALARMID=':p540' AND ALARMGROUPID=':p541') OR
(ALARMID=':p542' AND ALARMGROUPID=':p543') OR
(ALARMID=':p544' AND ALARMGROUPID=':p545') OR
(ALARMID=':p546' AND ALARMGROUPID=':p547') OR
(ALARMID=':p548' AND ALARMGROUPID=':p549') OR
(ALARMID=':p550' AND ALARMGROUPID=':p551') OR
(ALARMID=':p552' AND ALARMGROUPID=':p553') OR
(ALARMID=':p554' AND ALARMGROUPID=':p555') OR
(ALARMID=':p556' AND ALARMGROUPID=':p557') OR
(ALARMID=':p558' AND ALARMGROUPID=':p559') OR
(ALARMID=':p560' AND ALARMGROUPID=':p561') OR
(ALARMID=':p562' AND ALARMGROUPID=':p563') OR
(ALARMID=':p564' AND ALARMGROUPID=':p565') OR
(ALARMID=':p566' AND ALARMGROUPID=':p567') OR
(ALARMID=':p568' AND ALARMGROUPID=':p569') OR
(ALARMID=':p570' AND ALARMGROUPID=':p571') OR
(ALARMID=':p572' AND ALARMGROUPID=':p573') OR
(ALARMID=':p574' AND ALARMGROUPID=':p575') OR
(ALARMID=':p576' AND ALARMGROUPID=':p577') OR
(ALARMID=':p578' AND ALARMGROUPID=':p579') OR
(ALARMID=':p580' AND ALARMGROUPID=':p581') OR
(ALARMID=':p582' AND ALARMGROUPID=':p583') OR
(ALARMID=':p584' AND ALARMGROUPID=':p585') OR
(ALARMID=':p586' AND ALARMGROUPID=':p587') OR
(ALARMID=':p588' AND ALARMGROUPID=':p589') OR
(ALARMID=':p590' AND ALARMGROUPID=':p591') OR
(ALARMID=':p592' AND ALARMGROUPID=':p593') OR
(ALARMID=':p594' AND ALARMGROUPID=':p595') OR
(ALARMID=':p596' AND ALARMGROUPID=':p597') OR
(ALARMID=':p598' AND ALARMGROUPID=':p599') OR
(ALARMID=':p600' AND ALARMGROUPID=':p601') OR
(ALARMID=':p602' AND ALARMGROUPID=':p603') OR
(ALARMID=':p604' AND ALARMGROUPID=':p605') OR
(ALARMID=':p606' AND ALARMGROUPID=':p607') OR
(ALARMID=':p608' AND ALARMGROUPID=':p609') OR
(ALARMID=':p610' AND ALARMGROUPID=':p611') OR
(ALARMID=':p612' AND ALARMGROUPID=':p613') OR
(ALARMID=':p614' AND ALARMGROUPID=':p615') OR
(ALARMID=':p616' AND ALARMGROUPID=':p617') OR
(ALARMID=':p618' AND ALARMGROUPID=':p619') OR
(ALARMID=':p620' AND ALARMGROUPID=':p621') OR
(ALARMID=':p622' AND ALARMGROUPID=':p623') OR
(ALARMID=':p624' AND ALARMGROUPID=':p625') OR
(ALARMID=':p626' AND ALARMGROUPID=':p627') OR
(ALARMID=':p628' AND ALARMGROUPID=':p629') OR
(ALARMID=':p630' AND ALARMGROUPID=':p631') OR
(ALARMID=':p632' AND ALARMGROUPID=':p633') OR
(ALARMID=':p634' AND ALARMGROUPID=':p635') OR
(ALARMID=':p636' AND ALARMGROUPID=':p637') OR
(ALARMID=':p638' AND ALARMGROUPID=':p639') OR
(ALARMID=':p640' AND ALARMGROUPID=':p641') OR
(ALARMID=':p642' AND ALARMGROUPID=':p643') OR
(ALARMID=':p644' AND ALARMGROUPID=':p645') OR
(ALARMID=':p646' AND ALARMGROUPID=':p647') OR
(ALARMID=':p648' AND ALARMGROUPID=':p649') OR
(ALARMID=':p650' AND ALARMGROUPID=':p651') OR
(ALARMID=':p652' AND ALARMGROUPID=':p653') OR
(ALARMID=':p654' AND ALARMGROUPID=':p655') OR
(ALARMID=':p656' AND ALARMGROUPID=':p657') OR
(ALARMID=':p658' AND ALARMGROUPID=':p659') OR
(ALARMID=':p660' AND ALARMGROUPID=':p661') OR
(ALARMID=':p662' AND ALARMGROUPID=':p663') OR
(ALARMID=':p664' AND ALARMGROUPID=':p665') OR
(ALARMID=':p666' AND ALARMGROUPID=':p667') OR
(ALARMID=':p668' AND ALARMGROUPID=':p669') OR
(ALARMID=':p670' AND ALARMGROUPID=':p671') OR
(ALARMID=':p672' AND ALARMGROUPID=':p673') OR
(ALARMID=':p674' AND ALARMGROUPID=':p675') OR
(ALARMID=':p676' AND ALARMGROUPID=':p677') OR
(ALARMID=':p678' AND ALARMGROUPID=':p679') OR
(ALARMID=':p680' AND ALARMGROUPID=':p681') OR
(ALARMID=':p682' AND ALARMGROUPID=':p683') OR
(ALARMID=':p684' AND ALARMGROUPID=':p685') OR
(ALARMID=':p686' AND ALARMGROUPID=':p687') OR
(ALARMID=':p688' AND ALARMGROUPID=':p689') OR
(ALARMID=':p690' AND ALARMGROUPID=':p691') OR
(ALARMID=':p692' AND ALARMGROUPID=':p693') OR
(ALARMID=':p694' AND ALARMGROUPID=':p695') OR
(ALARMID=':p696' AND ALARMGROUPID=':p697') OR
(ALARMID=':p698' AND ALARMGROUPID=':p699') OR
(ALARMID=':p700' AND ALARMGROUPID=':p701') OR
(ALARMID=':p702' AND ALARMGROUPID=':p703') OR
(ALARMID=':p704' AND ALARMGROUPID=':p705') OR
(ALARMID=':p706' AND ALARMGROUPID=':p707') OR
(ALARMID=':p708' AND ALARMGROUPID=':p709') OR
(ALARMID=':p710' AND ALARMGROUPID=':p711') OR
(ALARMID=':p712' AND ALARMGROUPID=':p713') OR
(ALARMID=':p714' AND ALARMGROUPID=':p715') OR
(ALARMID=':p716' AND ALARMGROUPID=':p717') OR
(ALARMID=':p718' AND ALARMGROUPID=':p719') OR
(ALARMID=':p720' AND ALARMGROUPID=':p721') OR
(ALARMID=':p722' AND ALARMGROUPID=':p723') OR
(ALARMID=':p724' AND ALARMGROUPID=':p725') OR
(ALARMID=':p726' AND ALARMGROUPID=':p727') OR
(ALARMID=':p728' AND ALARMGROUPID=':p729') OR
(ALARMID=':p730' AND ALARMGROUPID=':p731') OR
(ALARMID=':p732' AND ALARMGROUPID=':p733') OR
(ALARMID=':p734' AND ALARMGROUPID=':p735') OR
(ALARMID=':p736' AND ALARMGROUPID=':p737') OR
(ALARMID=':p738' AND ALARMGROUPID=':p739') OR
(ALARMID=':p740' AND ALARMGROUPID=':p741') OR
(ALARMID=':p742' AND ALARMGROUPID=':p743') OR
(ALARMID=':p744' AND ALARMGROUPID=':p745') OR
(ALARMID=':p746' AND ALARMGROUPID=':p747') OR
(ALARMID=':p748' AND ALARMGROUPID=':p749') OR
(ALARMID=':p750' AND ALARMGROUPID=':p751') OR
(ALARMID=':p752' AND ALARMGROUPID=':p753') OR
(ALARMID=':p754' AND ALARMGROUPID=':p755') OR
(ALARMID=':p756' AND ALARMGROUPID=':p757') OR
(ALARMID=':p758' AND ALARMGROUPID=':p759') OR
(ALARMID=':p760' AND ALARMGROUPID=':p761') OR
(ALARMID=':p762' AND ALARMGROUPID=':p763') OR
(ALARMID=':p764' AND ALARMGROUPID=':p765') OR
(ALARMID=':p766' AND ALARMGROUPID=':p767') OR
(ALARMID=':p768' AND ALARMGROUPID=':p769') OR
(ALARMID=':p770' AND ALARMGROUPID=':p771') OR
(ALARMID=':p772' AND ALARMGROUPID=':p773') OR
(ALARMID=':p774' AND ALARMGROUPID=':p775') OR
(ALARMID=':p776' AND ALARMGROUPID=':p777') OR
(ALARMID=':p778' AND ALARMGROUPID=':p779') OR
(ALARMID=':p780' AND ALARMGROUPID=':p781') OR
(ALARMID=':p782' AND ALARMGROUPID=':p783') OR
(ALARMID=':p784' AND ALARMGROUPID=':p785') OR
(ALARMID=':p786' AND ALARMGROUPID=':p787') OR
(ALARMID=':p788' AND ALARMGROUPID=':p789') OR
(ALARMID=':p790' AND ALARMGROUPID=':p791') OR
(ALARMID=':p792' AND ALARMGROUPID=':p793') OR
(ALARMID=':p794' AND ALARMGROUPID=':p795') OR
(ALARMID=':p796' AND ALARMGROUPID=':p797') OR
(ALARMID=':p798' AND ALARMGROUPID=':p799') OR
(ALARMID=':p800' AND ALARMGROUPID=':p801') OR
(ALARMID=':p802' AND ALARMGROUPID=':p803') OR
(ALARMID=':p804' AND ALARMGROUPID=':p805') OR
(ALARMID=':p806' AND ALARMGROUPID=':p807') OR
(ALARMID=':p808' AND ALARMGROUPID=':p809') OR
(ALARMID=':p810' AND ALARMGROUPID=':p811') OR
(ALARMID=':p812' AND ALARMGROUPID=':p813') OR
(ALARMID=':p814' AND ALARMGROUPID=':p815') OR
(ALARMID=':p816' AND ALARMGROUPID=':p817') OR
(ALARMID=':p818' AND ALARMGROUPID=':p819') OR
(ALARMID=':p820' AND ALARMGROUPID=':p821') OR
(ALARMID=':p822' AND ALARMGROUPID=':p823') OR
(ALARMID=':p824' AND ALARMGROUPID=':p825') OR
(ALARMID=':p826' AND ALARMGROUPID=':p827') OR
(ALARMID=':p828' AND ALARMGROUPID=':p829') OR
(ALARMID=':p830' AND ALARMGROUPID=':p831') OR
(ALARMID=':p832' AND ALARMGROUPID=':p833') OR
(ALARMID=':p834' AND ALARMGROUPID=':p835') OR
(ALARMID=':p836' AND ALARMGROUPID=':p837') OR
(ALARMID=':p838' AND ALARMGROUPID=':p839') OR
(ALARMID=':p840' AND ALARMGROUPID=':p841') OR
(ALARMID=':p842' AND ALARMGROUPID=':p843') OR
(ALARMID=':p844' AND ALARMGROUPID=':p845') OR
(ALARMID=':p846' AND ALARMGROUPID=':p847') OR
(ALARMID=':p848' AND ALARMGROUPID=':p849') OR
(ALARMID=':p850' AND ALARMGROUPID=':p851') OR
(ALARMID=':p852' AND ALARMGROUPID=':p853') OR
(ALARMID=':p854' AND ALARMGROUPID=':p855') OR
(ALARMID=':p856' AND ALARMGROUPID=':p857') OR
(ALARMID=':p858' AND ALARMGROUPID=':p859') OR
(ALARMID=':p860' AND ALARMGROUPID=':p861') OR
(ALARMID=':p862' AND ALARMGROUPID=':p863') OR
(ALARMID=':p864' AND ALARMGROUPID=':p865') OR
(ALARMID=':p866' AND ALARMGROUPID=':p867') OR
(ALARMID=':p868' AND ALARMGROUPID=':p869') OR
(ALARMID=':p870' AND ALARMGROUPID=':p871') OR
(ALARMID=':p872' AND ALARMGROUPID=':p873') OR
(ALARMID=':p874' AND ALARMGROUPID=':p875') OR
(ALARMID=':p876' AND ALARMGROUPID=':p877') OR
(ALARMID=':p878' AND ALARMGROUPID=':p879') OR
(ALARMID=':p880' AND ALARMGROUPID=':p881') OR
(ALARMID=':p882' AND ALARMGROUPID=':p883') OR
(ALARMID=':p884' AND ALARMGROUPID=':p885') OR
(ALARMID=':p886' AND ALARMGROUPID=':p887') OR
(ALARMID=':p888' AND ALARMGROUPID=':p889') OR
(ALARMID=':p890' AND ALARMGROUPID=':p891') OR
(ALARMID=':p892' AND ALARMGROUPID=':p893') OR
(ALARMID=':p894' AND ALARMGROUPID=':p895') OR
(ALARMID=':p896' AND ALARMGROUPID=':p897') OR
(ALARMID=':p898' AND ALARMGROUPID=':p899') OR
(ALARMID=':p900' AND ALARMGROUPID=':p901') OR
(ALARMID=':p902' AND ALARMGROUPID=':p903') OR
(ALARMID=':p904' AND ALARMGROUPID=':p905') OR
(ALARMID=':p906' AND ALARMGROUPID=':p907') OR
(ALARMID=':p908' AND ALARMGROUPID=':p909') OR
(ALARMID=':p910' AND ALARMGROUPID=':p911') OR
(ALARMID=':p912' AND ALARMGROUPID=':p913') OR
(ALARMID=':p914' AND ALARMGROUPID=':p915') OR
(ALARMID=':p916' AND ALARMGROUPID=':p917') OR
(ALARMID=':p918' AND ALARMGROUPID=':p919') OR
(ALARMID=':p920' AND ALARMGROUPID=':p921') OR
(ALARMID=':p922' AND ALARMGROUPID=':p923') OR
(ALARMID=':p924' AND ALARMGROUPID=':p925') OR
(ALARMID=':p926' AND ALARMGROUPID=':p927') OR
(ALARMID=':p928' AND ALARMGROUPID=':p929') OR
(ALARMID=':p930' AND ALARMGROUPID=':p931') OR
(ALARMID=':p932' AND ALARMGROUPID=':p933') OR
(ALARMID=':p934' AND ALARMGROUPID=':p935') OR
(ALARMID=':p936' AND ALARMGROUPID=':p937') OR
(ALARMID=':p938' AND ALARMGROUPID=':p939') OR
(ALARMID=':p940' AND ALARMGROUPID=':p941') OR
(ALARMID=':p942' AND ALARMGROUPID=':p943') OR
(ALARMID=':p944' AND ALARMGROUPID=':p945') OR
(ALARMID=':p946' AND ALARMGROUPID=':p947') OR
(ALARMID=':p948' AND ALARMGROUPID=':p949') OR
(ALARMID=':p950' AND ALARMGROUPID=':p951') OR
(ALARMID=':p952' AND ALARMGROUPID=':p953') OR
(ALARMID=':p954' AND ALARMGROUPID=':p955') OR
(ALARMID=':p956' AND ALARMGROUPID=':p957') OR
(ALARMID=':p958' AND ALARMGROUPID=':p959') OR
(ALARMID=':p960' AND ALARMGROUPID=':p961') OR
(ALARMID=':p962' AND ALARMGROUPID=':p963') OR
(ALARMID=':p964' AND ALARMGROUPID=':p965') OR
(ALARMID=':p966' AND ALARMGROUPID=':p967') OR
(ALARMID=':p968' AND ALARMGROUPID=':p969') OR
(ALARMID=':p970' AND ALARMGROUPID=':p971') OR
(ALARMID=':p972' AND ALARMGROUPID=':p973') OR
(ALARMID=':p974' AND ALARMGROUPID=':p975') OR
(ALARMID=':p976' AND ALARMGROUPID=':p977') OR
(ALARMID=':p978' AND ALARMGROUPID=':p979') OR
(ALARMID=':p980' AND ALARMGROUPID=':p981') OR
(ALARMID=':p982' AND ALARMGROUPID=':p983') OR
(ALARMID=':p984' AND ALARMGROUPID=':p985') OR
(ALARMID=':p986' AND ALARMGROUPID=':p987') OR
(ALARMID=':p988' AND ALARMGROUPID=':p989') OR
(ALARMID=':p990' AND ALARMGROUPID=':p991') OR
(ALARMID=':p992' AND ALARMGROUPID=':p993') OR
(ALARMID=':p994' AND ALARMGROUPID=':p995') OR
(ALARMID=':p996' AND ALARMGROUPID=':p997') OR
(ALARMID=':p998' AND ALARMGROUPID=':p999') OR
(ALARMID=':p1000' AND ALARMGROUPID=':p1001') OR
(ALARMID=':p1002' AND ALARMGROUPID=':p1003') OR
(ALARMID=':p1004' AND ALARMGROUPID=':p1005') OR
(ALARMID=':p1006' AND ALARMGROUPID=':p1007') OR
(ALARMID=':p1008' AND ALARMGROUPID=':p1009') OR
(ALARMID=':p1010' AND ALARMGROUPID=':p1011') OR
(ALARMID=':p1012' AND ALARMGROUPID=':p1013') OR
(ALARMID=':p1014' AND ALARMGROUPID=':p1015') OR
(ALARMID=':p1016' AND ALARMGROUPID=':p1017') OR
(ALARMID=':p1018' AND ALARMGROUPID=':p1019') OR
(ALARMID=':p1020' AND ALARMGROUPID=':p1021') OR
(ALARMID=':p1022' AND ALARMGROUPID=':p1023') OR
(ALARMID=':p1024' AND ALARMGROUPID=':p1025') OR
(ALARMID=':p1026' AND ALARMGROUPID=':p1027') OR
(ALARMID=':p1028' AND ALARMGROUPID=':p1029') OR
(ALARMID=':p1030' AND ALARMGROUPID=':p1031') OR
(ALARMID=':p1032' AND ALARMGROUPID=':p1033') OR
(ALARMID=':p1034' AND ALARMGROUPID=':p1035') OR
(ALARMID=':p1036' AND ALARMGROUPID=':p1037') OR
(ALARMID=':p1038' AND ALARMGROUPID=':p1039') OR
(ALARMID=':p1040' AND ALARMGROUPID=':p1041') OR
(ALARMID=':p1042' AND ALARMGROUPID=':p1043') OR
(ALARMID=':p1044' AND ALARMGROUPID=':p1045') OR
(ALARMID=':p1046' AND ALARMGROUPID=':p1047') OR
(ALARMID=':p1048' AND ALARMGROUPID=':p1049') OR
(ALARMID=':p1050' AND ALARMGROUPID=':p1051') OR
(ALARMID=':p1052' AND ALARMGROUPID=':p1053') OR
(ALARMID=':p1054' AND ALARMGROUPID=':p1055') OR
(ALARMID=':p1056' AND ALARMGROUPID=':p1057') OR
(ALARMID=':p1058' AND ALARMGROUPID=':p1059') OR
(ALARMID=':p1060' AND ALARMGROUPID=':p1061') OR
(ALARMID=':p1062' AND ALARMGROUPID=':p1063') OR
(ALARMID=':p1064' AND ALARMGROUPID=':p1065') OR
(ALARMID=':p1066' AND ALARMGROUPID=':p1067') OR
(ALARMID=':p1068' AND ALARMGROUPID=':p1069') OR
(ALARMID=':p1070' AND ALARMGROUPID=':p1071') OR
(ALARMID=':p1072' AND ALARMGROUPID=':p1073') OR
(ALARMID=':p1074' AND ALARMGROUPID=':p1075') OR
(ALARMID=':p1076' AND ALARMGROUPID=':p1077') OR
(ALARMID=':p1078' AND ALARMGROUPID=':p1079') OR
(ALARMID=':p1080' AND ALARMGROUPID=':p1081') OR
(ALARMID=':p1082' AND ALARMGROUPID=':p1083') OR
(ALARMID=':p1084' AND ALARMGROUPID=':p1085') OR
(ALARMID=':p1086' AND ALARMGROUPID=':p1087') OR
(ALARMID=':p1088' AND ALARMGROUPID=':p1089') OR
(ALARMID=':p1090' AND ALARMGROUPID=':p1091') OR
(ALARMID=':p1092' AND ALARMGROUPID=':p1093') OR
(ALARMID=':p1094' AND ALARMGROUPID=':p1095') OR
(ALARMID=':p1096' AND ALARMGROUPID=':p1097') OR
(ALARMID=':p1098' AND ALARMGROUPID=':p1099') OR
(ALARMID=':p1100' AND ALARMGROUPID=':p1101') OR
(ALARMID=':p1102' AND ALARMGROUPID=':p1103') OR
(ALARMID=':p1104' AND ALARMGROUPID=':p1105') OR
(ALARMID=':p1106' AND ALARMGROUPID=':p1107') OR
(ALARMID=':p1108' AND ALARMGROUPID=':p1109') OR
(ALARMID=':p1110' AND ALARMGROUPID=':p1111') OR
(ALARMID=':p1112' AND ALARMGROUPID=':p1113') OR
(ALARMID=':p1114' AND ALARMGROUPID=':p1115') OR
(ALARMID=':p1116' AND ALARMGROUPID=':p1117') OR
(ALARMID=':p1118' AND ALARMGROUPID=':p1119') OR
(ALARMID=':p1120' AND ALARMGROUPID=':p1121') OR
(ALARMID=':p1122' AND ALARMGROUPID=':p1123') OR
(ALARMID=':p1124' AND ALARMGROUPID=':p1125') OR
(ALARMID=':p1126' AND ALARMGROUPID=':p1127') OR
(ALARMID=':p1128' AND ALARMGROUPID=':p1129') OR
(ALARMID=':p1130' AND ALARMGROUPID=':p1131') OR
(ALARMID=':p1132' AND ALARMGROUPID=':p1133') OR
(ALARMID=':p1134' AND ALARMGROUPID=':p1135') OR
(ALARMID=':p1136' AND ALARMGROUPID=':p1137') OR
(ALARMID=':p1138' AND ALARMGROUPID=':p1139') OR
(ALARMID=':p1140' AND ALARMGROUPID=':p1141') OR
(ALARMID=':p1142' AND ALARMGROUPID=':p1143') OR
(ALARMID=':p1144' AND ALARMGROUPID=':p1145') OR
(ALARMID=':p1146' AND ALARMGROUPID=':p1147') OR
(ALARMID=':p1148' AND ALARMGROUPID=':p1149') OR
(ALARMID=':p1150' AND ALARMGROUPID=':p1151') OR
(ALARMID=':p1152' AND ALARMGROUPID=':p1153') OR
(ALARMID=':p1154' AND ALARMGROUPID=':p1155') OR
(ALARMID=':p1156' AND ALARMGROUPID=':p1157') OR
(ALARMID=':p1158' AND ALARMGROUPID=':p1159') OR
(ALARMID=':p1160' AND ALARMGROUPID=':p1161') OR
(ALARMID=':p1162' AND ALARMGROUPID=':p1163') OR
(ALARMID=':p1164' AND ALARMGROUPID=':p1165') OR
(ALARMID=':p1166' AND ALARMGROUPID=':p1167') OR
(ALARMID=':p1168' AND ALARMGROUPID=':p1169') OR
(ALARMID=':p1170' AND ALARMGROUPID=':p1171') OR
(ALARMID=':p1172' AND ALARMGROUPID=':p1173') OR
(ALARMID=':p1174' AND ALARMGROUPID=':p1175') OR
(ALARMID=':p1176' AND ALARMGROUPID=':p1177') OR
(ALARMID=':p1178' AND ALARMGROUPID=':p1179') OR
(ALARMID=':p1180' AND ALARMGROUPID=':p1181') OR
(ALARMID=':p1182' AND ALARMGROUPID=':p1183') OR
(ALARMID=':p1184' AND ALARMGROUPID=':p1185') OR
(ALARMID=':p1186' AND ALARMGROUPID=':p1187') OR
(ALARMID=':p1188' AND ALARMGROUPID=':p1189') OR
(ALARMID=':p1190' AND ALARMGROUPID=':p1191') OR
(ALARMID=':p1192' AND ALARMGROUPID=':p1193') OR
(ALARMID=':p1194' AND ALARMGROUPID=':p1195') OR
(ALARMID=':p1196' AND ALARMGROUPID=':p1197') OR
(ALARMID=':p1198' AND ALARMGROUPID=':p1199') OR
(ALARMID=':p1200' AND ALARMGROUPID=':p1201') OR
(ALARMID=':p1202' AND ALARMGROUPID=':p1203') OR
(ALARMID=':p1204' AND ALARMGROUPID=':p1205') OR
(ALARMID=':p1206' AND ALARMGROUPID=':p1207') OR
(ALARMID=':p1208' AND ALARMGROUPID=':p1209') OR
(ALARMID=':p1210' AND ALARMGROUPID=':p1211') OR
(ALARMID=':p1212' AND ALARMGROUPID=':p1213') OR
(ALARMID=':p1214' AND ALARMGROUPID=':p1215') OR
(ALARMID=':p1216' AND ALARMGROUPID=':p1217') OR
(ALARMID=':p1218' AND ALARMGROUPID=':p1219') OR
(ALARMID=':p1220' AND ALARMGROUPID=':p1221') OR
(ALARMID=':p1222' AND ALARMGROUPID=':p1223') OR
(ALARMID=':p1224' AND ALARMGROUPID=':p1225') OR
(ALARMID=':p1226' AND ALARMGROUPID=':p1227') OR
(ALARMID=':p1228' AND ALARMGROUPID=':p1229') OR
(ALARMID=':p1230' AND ALARMGROUPID=':p1231') OR
(ALARMID=':p1232' AND ALARMGROUPID=':p1233') OR
(ALARMID=':p1234' AND ALARMGROUPID=':p1235') OR
(ALARMID=':p1236' AND ALARMGROUPID=':p1237') OR
(ALARMID=':p1238' AND ALARMGROUPID=':p1239') OR
(ALARMID=':p1240' AND ALARMGROUPID=':p1241') OR
(ALARMID=':p1242' AND ALARMGROUPID=':p1243') OR
(ALARMID=':p1244' AND ALARMGROUPID=':p1245') OR
(ALARMID=':p1246' AND ALARMGROUPID=':p1247') OR
(ALARMID=':p1248' AND ALARMGROUPID=':p1249') OR
(ALARMID=':p1250' AND ALARMGROUPID=':p1251') OR
(ALARMID=':p1252' AND ALARMGROUPID=':p1253') OR
(ALARMID=':p1254' AND ALARMGROUPID=':p1255') OR
(ALARMID=':p1256' AND ALARMGROUPID=':p1257') OR
(ALARMID=':p1258' AND ALARMGROUPID=':p1259') OR
(ALARMID=':p1260' AND ALARMGROUPID=':p1261') OR
(ALARMID=':p1262' AND ALARMGROUPID=':p1263') OR
(ALARMID=':p1264' AND ALARMGROUPID=':p1265') OR
(ALARMID=':p1266' AND ALARMGROUPID=':p1267') OR
(ALARMID=':p1268' AND ALARMGROUPID=':p1269') OR
(ALARMID=':p1270' AND ALARMGROUPID=':p1271') OR
(ALARMID=':p1272' AND ALARMGROUPID=':p1273') OR
(ALARMID=':p1274' AND ALARMGROUPID=':p1275') OR
(ALARMID=':p1276' AND ALARMGROUPID=':p1277') OR
(ALARMID=':p1278' AND ALARMGROUPID=':p1279') OR
(ALARMID=':p1280' AND ALARMGROUPID=':p1281') OR
(ALARMID=':p1282' AND ALARMGROUPID=':p1283') OR
(ALARMID=':p1284' AND ALARMGROUPID=':p1285') OR
(ALARMID=':p1286' AND ALARMGROUPID=':p1287') OR
(ALARMID=':p1288' AND ALARMGROUPID=':p1289') OR
(ALARMID=':p1290' AND ALARMGROUPID=':p1291') OR
(ALARMID=':p1292' AND ALARMGROUPID=':p1293') OR
(ALARMID=':p1294' AND ALARMGROUPID=':p1295') OR
(ALARMID=':p1296' AND ALARMGROUPID=':p1297') OR
(ALARMID=':p1298' AND ALARMGROUPID=':p1299') OR
(ALARMID=':p1300' AND ALARMGROUPID=':p1301') OR
(ALARMID=':p1302' AND ALARMGROUPID=':p1303') OR
(ALARMID=':p1304' AND ALARMGROUPID=':p1305') OR
(ALARMID=':p1306' AND ALARMGROUPID=':p1307') OR
(ALARMID=':p1308' AND ALARMGROUPID=':p1309') OR
(ALARMID=':p1310' AND ALARMGROUPID=':p1311') OR
(ALARMID=':p1312' AND ALARMGROUPID=':p1313') OR
(ALARMID=':p1314' AND ALARMGROUPID=':p1315') OR
(ALARMID=':p1316' AND ALARMGROUPID=':p1317') OR
(ALARMID=':p1318' AND ALARMGROUPID=':p1319') OR
(ALARMID=':p1320' AND ALARMGROUPID=':p1321') OR
(ALARMID=':p1322' AND ALARMGROUPID=':p1323') OR
(ALARMID=':p1324' AND ALARMGROUPID=':p1325') OR
(ALARMID=':p1326' AND ALARMGROUPID=':p1327') OR
(ALARMID=':p1328' AND ALARMGROUPID=':p1329') OR
(ALARMID=':p1330' AND ALARMGROUPID=':p1331') OR
(ALARMID=':p1332' AND ALARMGROUPID=':p1333') OR
(ALARMID=':p1334' AND ALARMGROUPID=':p1335') OR
(ALARMID=':p1336' AND ALARMGROUPID=':p1337') OR
(ALARMID=':p1338' AND ALARMGROUPID=':p1339') OR
(ALARMID=':p1340' AND ALARMGROUPID=':p1341') OR
(ALARMID=':p1342' AND ALARMGROUPID=':p1343') OR
(ALARMID=':p1344' AND ALARMGROUPID=':p1345') OR
(ALARMID=':p1346' AND ALARMGROUPID=':p1347') OR
(ALARMID=':p1348' AND ALARMGROUPID=':p1349') OR
(ALARMID=':p1350' AND ALARMGROUPID=':p1351') OR
(ALARMID=':p1352' AND ALARMGROUPID=':p1353') OR
(ALARMID=':p1354' AND ALARMGROUPID=':p1355') OR
(ALARMID=':p1356' AND ALARMGROUPID=':p1357') OR
(ALARMID=':p1358' AND ALARMGROUPID=':p1359') OR
(ALARMID=':p1360' AND ALARMGROUPID=':p1361') OR
(ALARMID=':p1362' AND ALARMGROUPID=':p1363') OR
(ALARMID=':p1364' AND ALARMGROUPID=':p1365') OR
(ALARMID=':p1366' AND ALARMGROUPID=':p1367') OR
(ALARMID=':p1368' AND ALARMGROUPID=':p1369') OR
(ALARMID=':p1370' AND ALARMGROUPID=':p1371') OR
(ALARMID=':p1372' AND ALARMGROUPID=':p1373') OR
(ALARMID=':p1374' AND ALARMGROUPID=':p1375') OR
(ALARMID=':p1376' AND ALARMGROUPID=':p1377') OR
(ALARMID=':p1378' AND ALARMGROUPID=':p1379') OR
(ALARMID=':p1380' AND ALARMGROUPID=':p1381') OR
(ALARMID=':p1382' AND ALARMGROUPID=':p1383') OR
(ALARMID=':p1384' AND ALARMGROUPID=':p1385') OR
(ALARMID=':p1386' AND ALARMGROUPID=':p1387') OR
(ALARMID=':p1388' AND ALARMGROUPID=':p1389') OR
(ALARMID=':p1390' AND ALARMGROUPID=':p1391') OR
(ALARMID=':p1392' AND ALARMGROUPID=':p1393') OR
(ALARMID=':p1394' AND ALARMGROUPID=':p1395') OR
(ALARMID=':p1396' AND ALARMGROUPID=':p1397') OR
(ALARMID=':p1398' AND ALARMGROUPID=':p1399') OR
(ALARMID=':p1400' AND ALARMGROUPID=':p1401') OR
(ALARMID=':p1402' AND ALARMGROUPID=':p1403') OR
(ALARMID=':p1404' AND ALARMGROUPID=':p1405') OR
(ALARMID=':p1406' AND ALARMGROUPID=':p1407') OR
(ALARMID=':p1408' AND ALARMGROUPID=':p1409') OR
(ALARMID=':p1410' AND ALARMGROUPID=':p1411') OR
(ALARMID=':p1412' AND ALARMGROUPID=':p1413') OR
(ALARMID=':p1414' AND ALARMGROUPID=':p1415') OR
(ALARMID=':p1416' AND ALARMGROUPID=':p1417') OR
(ALARMID=':p1418' AND ALARMGROUPID=':p1419') OR
(ALARMID=':p1420' AND ALARMGROUPID=':p1421') OR
(ALARMID=':p1422' AND ALARMGROUPID=':p1423') OR
(ALARMID=':p1424' AND ALARMGROUPID=':p1425') OR
(ALARMID=':p1426' AND ALARMGROUPID=':p1427') OR
(ALARMID=':p1428' AND ALARMGROUPID=':p1429') OR
(ALARMID=':p1430' AND ALARMGROUPID=':p1431') OR
(ALARMID=':p1432' AND ALARMGROUPID=':p1433') OR
(ALARMID=':p1434' AND ALARMGROUPID=':p1435') OR
(ALARMID=':p1436' AND ALARMGROUPID=':p1437') OR
(ALARMID=':p1438' AND ALARMGROUPID=':p1439') OR
(ALARMID=':p1440' AND ALARMGROUPID=':p1441') OR
(ALARMID=':p1442' AND ALARMGROUPID=':p1443') OR
(ALARMID=':p1444' AND ALARMGROUPID=':p1445') OR
(ALARMID=':p1446' AND ALARMGROUPID=':p1447') OR
(ALARMID=':p1448' AND ALARMGROUPID=':p1449') OR
(ALARMID=':p1450' AND ALARMGROUPID=':p1451') OR
(ALARMID=':p1452' AND ALARMGROUPID=':p1453') OR
(ALARMID=':p1454' AND ALARMGROUPID=':p1455') OR
(ALARMID=':p1456' AND ALARMGROUPID=':p1457') OR
(ALARMID=':p1458' AND ALARMGROUPID=':p1459') OR
(ALARMID=':p1460' AND ALARMGROUPID=':p1461') OR
(ALARMID=':p1462' AND ALARMGROUPID=':p1463') OR
(ALARMID=':p1464' AND ALARMGROUPID=':p1465') OR
(ALARMID=':p1466' AND ALARMGROUPID=':p1467') OR
(ALARMID=':p1468' AND ALARMGROUPID=':p1469') OR
(ALARMID=':p1470' AND ALARMGROUPID=':p1471') OR
(ALARMID=':p1472' AND ALARMGROUPID=':p1473') OR
(ALARMID=':p1474' AND ALARMGROUPID=':p1475') OR
(ALARMID=':p1476' AND ALARMGROUPID=':p1477') OR
(ALARMID=':p1478' AND ALARMGROUPID=':p1479') OR
(ALARMID=':p1480' AND ALARMGROUPID=':p1481') OR
(ALARMID=':p1482' AND ALARMGROUPID=':p1483') OR
(ALARMID=':p1484' AND ALARMGROUPID=':p1485') OR
(ALARMID=':p1486' AND ALARMGROUPID=':p1487') OR
(ALARMID=':p1488' AND ALARMGROUPID=':p1489') OR
(ALARMID=':p1490' AND ALARMGROUPID=':p1491') OR
(ALARMID=':p1492' AND ALARMGROUPID=':p1493') OR
(ALARMID=':p1494' AND ALARMGROUPID=':p1495') OR
(ALARMID=':p1496' AND ALARMGROUPID=':p1497') OR
(ALARMID=':p1498' AND ALARMGROUPID=':p1499') OR
(ALARMID=':p1500' AND ALARMGROUPID=':p1501') OR
(ALARMID=':p1502' AND ALARMGROUPID=':p1503') OR
(ALARMID=':p1504' AND ALARMGROUPID=':p1505') OR
(ALARMID=':p1506' AND ALARMGROUPID=':p1507') OR
(ALARMID=':p1508' AND ALARMGROUPID=':p1509') OR
(ALARMID=':p1510' AND ALARMGROUPID=':p1511') OR
(ALARMID=':p1512' AND ALARMGROUPID=':p1513') OR
(ALARMID=':p1514' AND ALARMGROUPID=':p1515') OR
(ALARMID=':p1516' AND ALARMGROUPID=':p1517') OR
(ALARMID=':p1518' AND ALARMGROUPID=':p1519') OR
(ALARMID=':p1520' AND ALARMGROUPID=':p1521') OR
(ALARMID=':p1522' AND ALARMGROUPID=':p1523') OR
(ALARMID=':p1524' AND ALARMGROUPID=':p1525') OR
(ALARMID=':p1526' AND ALARMGROUPID=':p1527') OR
(ALARMID=':p1528' AND ALARMGROUPID=':p1529') OR
(ALARMID=':p1530' AND ALARMGROUPID=':p1531') OR
(ALARMID=':p1532' AND ALARMGROUPID=':p1533') OR
(ALARMID=':p1534' AND ALARMGROUPID=':p1535') OR
(ALARMID=':p1536' AND ALARMGROUPID=':p1537') OR
(ALARMID=':p1538' AND ALARMGROUPID=':p1539') OR
(ALARMID=':p1540' AND ALARMGROUPID=':p1541') OR
(ALARMID=':p1542' AND ALARMGROUPID=':p1543') OR
(ALARMID=':p1544' AND ALARMGROUPID=':p1545') OR
(ALARMID=':p1546' AND ALARMGROUPID=':p1547') OR
(ALARMID=':p1548' AND ALARMGROUPID=':p1549') OR
(ALARMID=':p1550' AND ALARMGROUPID=':p1551') OR
(ALARMID=':p1552' AND ALARMGROUPID=':p1553') OR
(ALARMID=':p1554' AND ALARMGROUPID=':p1555') OR
(ALARMID=':p1556' AND ALARMGROUPID=':p1557') OR
(ALARMID=':p1558' AND ALARMGROUPID=':p1559') OR
(ALARMID=':p1560' AND ALARMGROUPID=':p1561') OR
(ALARMID=':p1562' AND ALARMGROUPID=':p1563') OR
(ALARMID=':p1564' AND ALARMGROUPID=':p1565') OR
(ALARMID=':p1566' AND ALARMGROUPID=':p1567') OR
(ALARMID=':p1568' AND ALARMGROUPID=':p1569') OR
(ALARMID=':p1570' AND ALARMGROUPID=':p1571') OR
(ALARMID=':p1572' AND ALARMGROUPID=':p1573') OR
(ALARMID=':p1574' AND ALARMGROUPID=':p1575') OR
(ALARMID=':p1576' AND ALARMGROUPID=':p1577') OR
(ALARMID=':p1578' AND ALARMGROUPID=':p1579') OR
(ALARMID=':p1580' AND ALARMGROUPID=':p1581') OR
(ALARMID=':p1582' AND ALARMGROUPID=':p1583') OR
(ALARMID=':p1584' AND ALARMGROUPID=':p1585') OR
(ALARMID=':p1586' AND ALARMGROUPID=':p1587') OR
(ALARMID=':p1588' AND ALARMGROUPID=':p1589') OR
(ALARMID=':p1590' AND ALARMGROUPID=':p1591') OR
(ALARMID=':p1592' AND ALARMGROUPID=':p1593') OR
(ALARMID=':p1594' AND ALARMGROUPID=':p1595') OR
(ALARMID=':p1596' AND ALARMGROUPID=':p1597') OR
(ALARMID=':p1598' AND ALARMGROUPID=':p1599') OR
(ALARMID=':p1600' AND ALARMGROUPID=':p1601') OR
(ALARMID=':p1602' AND ALARMGROUPID=':p1603') OR
(ALARMID=':p1604' AND ALARMGROUPID=':p1605') OR
(ALARMID=':p1606' AND ALARMGROUPID=':p1607') OR
(ALARMID=':p1608' AND ALARMGROUPID=':p1609') OR
(ALARMID=':p1610' AND ALARMGROUPID=':p1611') OR
(ALARMID=':p1612' AND ALARMGROUPID=':p1613') OR
(ALARMID=':p1614' AND ALARMGROUPID=':p1615') OR
(ALARMID=':p1616' AND ALARMGROUPID=':p1617') OR
(ALARMID=':p1618' AND ALARMGROUPID=':p1619') OR
(ALARMID=':p1620' AND ALARMGROUPID=':p1621') OR
(ALARMID=':p1622' AND ALARMGROUPID=':p1623') OR
(ALARMID=':p1624' AND ALARMGROUPID=':p1625') OR
(ALARMID=':p1626' AND ALARMGROUPID=':p1627') OR
(ALARMID=':p1628' AND ALARMGROUPID=':p1629') OR
(ALARMID=':p1630' AND ALARMGROUPID=':p1631') OR
(ALARMID=':p1632' AND ALARMGROUPID=':p1633') OR
(ALARMID=':p1634' AND ALARMGROUPID=':p1635') OR
(ALARMID=':p1636' AND ALARMGROUPID=':p1637') OR
(ALARMID=':p1638' AND ALARMGROUPID=':p1639') OR
(ALARMID=':p1640' AND ALARMGROUPID=':p1641') OR
(ALARMID=':p1642' AND ALARMGROUPID=':p1643') OR
(ALARMID=':p1644' AND ALARMGROUPID=':p1645') OR
(ALARMID=':p1646' AND ALARMGROUPID=':p1647') OR
(ALARMID=':p1648' AND ALARMGROUPID=':p1649') OR
(ALARMID=':p1650' AND ALARMGROUPID=':p1651') OR
(ALARMID=':p1652' AND ALARMGROUPID=':p1653') OR
(ALARMID=':p1654' AND ALARMGROUPID=':p1655') OR
(ALARMID=':p1656' AND ALARMGROUPID=':p1657') OR
(ALARMID=':p1658' AND ALARMGROUPID=':p1659') OR
(ALARMID=':p1660' AND ALARMGROUPID=':p1661') ;

-- any subselect
drop table if exists t_any_sub1;
drop table if exists t_any_sub2;
create table t_any_sub1(f1 int, f2 int);
create table t_any_sub2(f1 int, f2 int);
insert into t_any_sub1 values(1, 1);
insert into t_any_sub2 values(2, 2);
insert into t_any_sub2 values(1, 1);
insert into t_any_sub1 values(2, 2);
select f1 from t_any_sub1 where f2 < any(select distinct f1 from t_any_sub2 where f2 > 0 order by 1) group by f1 order by 1;
select f1 from t_any_sub1 where f2 > any(select distinct f1 from t_any_sub2 where f2 > 0 order by 1 limit 1000) group by f1 order by 1;
drop table t_any_sub1;
drop table t_any_sub2;

select TABLESPACE_NAME from dba_tables where owner='SYS' and table_id=(select table_id from dba_tables where table_name ='SYS_DUMMY');

--DTS2019082007045
DROP TABLE IF EXISTS "DAP_DAPSYSTEM" CASCADE CONSTRAINTS;
DROP TABLE IF EXISTS "BD_BILLTYPE" CASCADE CONSTRAINTS;
DROP TABLE IF EXISTS "TEMP_PLAT_1T1" CASCADE CONSTRAINTS;

CREATE TABLE "DAP_DAPSYSTEM"
(
  "APPSCOPE" NUMBER,
  "DEF1" VARCHAR(99 BYTE) DEFAULT '~',
  "DEF2" VARCHAR(99 BYTE) DEFAULT '~',
  "DEF3" VARCHAR(99 BYTE) DEFAULT '~',
  "DEVMODULE" VARCHAR(50 BYTE),
  "DR" NUMBER DEFAULT 0,
  "ISACCOUNT" CHAR(1 BYTE),
  "ISITEM" CHAR(1 BYTE),
  "ISLIGHTMODULE" CHAR(1 BYTE) DEFAULT 'N',
  "ISNCINNERMODULE" CHAR(1 BYTE),
  "ISRELATEDEV" VARCHAR(50 BYTE),
  "MODULEID" VARCHAR(50 BYTE) NOT NULL,
  "NODEORDER" NUMBER,
  "ORGTYPECODE" VARCHAR(50 BYTE),
  "PARENTCODE" VARCHAR(20 BYTE) DEFAULT '~',
  "PRODUCTSCOPE" NUMBER,
  "RESID" VARCHAR(30 BYTE),
  "SUPPORTCLOSEACCBOOK" CHAR(1 BYTE),
  "SYSTYPECODE" VARCHAR(50 BYTE) NOT NULL,
  "SYSTYPENAME" VARCHAR(75 BYTE),
  "TS" CHAR(19 BYTE) DEFAULT to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')
);
ALTER TABLE "DAP_DAPSYSTEM" ADD CONSTRAINT "PK_DAP_DAPSYSTEM" PRIMARY KEY("MODULEID");

CREATE TABLE "BD_BILLTYPE"
(
  "ACCOUNTCLASS" VARCHAR(50 BYTE),
  "BILLCODERULE" VARCHAR(20 BYTE),
  "BILLSTYLE" NUMBER,
  "BILLTYPENAME" VARCHAR(120 BYTE),
  "BILLTYPENAME2" VARCHAR(120 BYTE),
  "BILLTYPENAME3" VARCHAR(120 BYTE),
  "BILLTYPENAME4" VARCHAR(120 BYTE),
  "BILLTYPENAME5" VARCHAR(120 BYTE),
  "BILLTYPENAME6" VARCHAR(120 BYTE),
  "CANEXTENDTRANSACTION" CHAR(1 BYTE),
  "CHECKCLASSNAME" VARCHAR(50 BYTE),
  "CLASSNAME" VARCHAR(50 BYTE),
  "COMP" VARCHAR(50 BYTE),
  "COMPONENT" VARCHAR(128 BYTE),
  "DATAFINDERCLZ" VARCHAR(50 BYTE),
  "DEF1" VARCHAR(50 BYTE),
  "DEF2" VARCHAR(50 BYTE),
  "DEF3" VARCHAR(50 BYTE),
  "DR" NUMBER DEFAULT 0,
  "EMENDENUMCLASS" VARCHAR(50 BYTE),
  "FORWARDBILLTYPE" VARCHAR(128 BYTE),
  "ISACCOUNT" CHAR(1 BYTE),
  "ISAPPROVEBILL" CHAR(1 BYTE),
  "ISBIZFLOWBILL" CHAR(1 BYTE),
  "ISEDITABLEPROPERTY" CHAR(1 BYTE),
  "ISENABLEBUTTON" CHAR(1 BYTE),
  "ISENABLETRANSTYPEBCR" CHAR(1 BYTE),
  "ISLIGHTBILL" CHAR(1 BYTE) DEFAULT 'N',
  "ISLOCK" CHAR(1 BYTE),
  "ISREJECTUNEDITABLEPROPERTY" CHAR(1 BYTE) DEFAULT 'N',
  "ISROOT" CHAR(1 BYTE),
  "ISSUPPORTMOBILE" CHAR(1 BYTE) DEFAULT 'Y',
  "ISTRANSACTION" CHAR(1 BYTE) DEFAULT 'N',
  "ISWORKFLOWCANAUTOAPPROVE" CHAR(1 BYTE) DEFAULT 'N',
  "NCBRCODE" VARCHAR(20 BYTE),
  "NODECODE" VARCHAR(20 BYTE),
  "PARENTBILLTYPE" VARCHAR(20 BYTE),
  "PK_BILLTYPECODE" VARCHAR(20 BYTE),
  "PK_BILLTYPEID" VARCHAR(20 BYTE) NOT NULL,
  "PK_GROUP" VARCHAR(20 BYTE) DEFAULT '~',
  "PK_ORG" VARCHAR(20 BYTE) DEFAULT '~',
  "REFERCLASSNAME" VARCHAR(50 BYTE),
  "SYSTEMCODE" VARCHAR(20 BYTE),
  "TRANSTYPE_CLASS" VARCHAR(100 BYTE),
  "TS" CHAR(19 BYTE) DEFAULT to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),
  "WEBNODECODE" VARCHAR(20 BYTE),
  "WHERESTRING" VARCHAR(256 BYTE)
);

CREATE INDEX "I_BD_BILLTYPE" ON "BD_BILLTYPE"("SYSTEMCODE");
CREATE INDEX "I_BD_BILLTYPE_1" ON "BD_BILLTYPE"("PARENTBILLTYPE");
ALTER TABLE "BD_BILLTYPE" ADD CONSTRAINT "PK_BD_BILLTYPE" PRIMARY KEY("PK_BILLTYPEID");

CREATE GLOBAL TEMPORARY TABLE "TEMP_PLAT_1T1"
(
  "ID1" VARCHAR(120 BYTE),
  "TS" CHAR(19 BYTE)
)ON COMMIT DELETE ROWS;
CREATE INDEX "I_TEMP_PLAT_1T1_0" ON "TEMP_PLAT_1T1"("ID1");


DROP TABLE IF EXISTS "DAP_DAPSYSTEM" CASCADE CONSTRAINTS;
DROP TABLE IF EXISTS "BD_BILLTYPE" CASCADE CONSTRAINTS;
DROP TABLE IF EXISTS "TEMP_PLAT_1T1" CASCADE CONSTRAINTS;

--DTS2019102210331
DROP TABLE IF EXISTS "DEVICE" CASCADE CONSTRAINTS;
CREATE TABLE "DEVICE"
(
  "ID" VARCHAR(255 BYTE),
  "CATEGORY" VARCHAR(255 BYTE) DEFAULT '',
  "SERIAL_NUMBER" VARCHAR(255 BYTE) DEFAULT '',
  "ASSET_ID" VARCHAR(255 BYTE) DEFAULT '',
  "IPV4" VARCHAR(255 BYTE) DEFAULT '',
  "IPV6" VARCHAR(255 BYTE) DEFAULT '',
  "MANUFACTURE" VARCHAR(255 BYTE) DEFAULT '',
  "DATACENTER_ID" VARCHAR(255 BYTE) DEFAULT '',
  "MODEL" VARCHAR(255 BYTE) DEFAULT '',
  "DEVLOCATION" VARCHAR(255 BYTE) DEFAULT '',
  "UHEIGHT" BINARY_INTEGER,
  "ADDED_TIME" VARCHAR(255 BYTE) DEFAULT '',
  "OCCUR_TIME" BINARY_INTEGER,
  "ASSET_STATUS" VARCHAR(255 BYTE) DEFAULT '',
  "MANAGE_STATE" VARCHAR(255 BYTE),
  "MANAGE_REASON" VARCHAR(255 BYTE),
  "PARENT_ID" VARCHAR(255 BYTE) DEFAULT '',
  "DESCRIPTION" VARCHAR(255 BYTE) DEFAULT '',
  "PROPERTIES" VARCHAR(2048 BYTE) DEFAULT '{}',
  "LABEL_PROPERTIES" VARCHAR(2048 BYTE) DEFAULT '{}'
);
DROP TABLE IF EXISTS "SEARCH_DATA_LOG" CASCADE CONSTRAINTS;
CREATE TABLE "SEARCH_DATA_LOG"
(
  "ID" BINARY_BIGINT NOT NULL,
  "DATA_MODEL" VARCHAR(255 BYTE) NOT NULL,
  "DOC_KEY" VARCHAR(255 BYTE) NOT NULL,
  "CHANGE_TYPE" VARCHAR(255 BYTE) NOT NULL,
  "SYNC_STATE" VARCHAR(255 BYTE) NOT NULL,
  "CHANGE_TIME" BINARY_BIGINT
);
DROP TABLE IF EXISTS "DEVICE" CASCADE CONSTRAINTS;
DROP TABLE IF EXISTS "SEARCH_DATA_LOG" CASCADE CONSTRAINTS;

--DTS2019120912997
drop table if exists t_elimate_select;
create table t_elimate_select (a int,b int,c int);
select t.a  b,t.c d from (select b as a,(select 1||1 from dual) as c from t_elimate_select) t;
drop table if exists t_elimate_select;

--DTS2020022723512
DROP TABLE IF EXISTS "PBIRENAMEHISTORY" CASCADE CONSTRAINTS;
DROP TABLE IF EXISTS "PBI_ORGANIZATION" CASCADE CONSTRAINTS;
DROP TABLE IF EXISTS "PBI_OFFERING" CASCADE CONSTRAINTS;
CREATE TABLE "PBIRENAMEHISTORY"
(
  "IDA2A2" NUMBER NOT NULL,
  "OBJECTID" VARCHAR(600 BYTE),
  "NEWNAME" VARCHAR(600 BYTE),
  "CATEGORY" VARCHAR(600 BYTE),
  "CREATED_BY" VARCHAR(600 BYTE),
  "CREATION_DATE" DATE,
  "LAST_UPDATED_BY" VARCHAR(600 BYTE),
  "LAST_UPDATE_DATE" DATE
);
CREATE TABLE "PBI_ORGANIZATION"
(
  "ORG_ID" NUMBER(20) NOT NULL,
  "PARENT_ID" NUMBER(20),
  "NO" VARCHAR(30 BYTE) NOT NULL,
  "STATUS" NUMBER(1) NOT NULL,
  "CATEGORY" VARCHAR(30 BYTE) NOT NULL,
  "CREATED_BY" VARCHAR(512 BYTE),
  "CREATION_DATE" DATE,
  "LAST_UPDATED_BY" VARCHAR(512 BYTE),
  "LAST_UPDATE_DATE" DATE
);
CREATE TABLE "PBI_OFFERING"
(
  "OFFERING_ID" NUMBER(20) NOT NULL,
  "ORG_ID" NUMBER(20) NOT NULL,
  "NO" VARCHAR(30 BYTE) NOT NULL,
  "NAME" VARCHAR(256 BYTE) NOT NULL,
  "STATUS" NUMBER(1) NOT NULL,
  "CATEGORY" VARCHAR(20 BYTE) NOT NULL,
  "PRODUCT_BRAND" VARCHAR(100 BYTE),
  "CREATED_BY" VARCHAR(512 BYTE),
  "CREATION_DATE" DATE,
  "LAST_UPDATED_BY" VARCHAR(512 BYTE),
  "LAST_UPDATE_DATE" DATE
);
CREATE INDEX "IDX_OBJECTID" ON "PBIRENAMEHISTORY"("OBJECTID");
ALTER TABLE "PBI_OFFERING" ADD CONSTRAINT "PK_PBI_OFFERING" PRIMARY KEY("OFFERING_ID");
ALTER TABLE "PBI_ORGANIZATION" ADD CONSTRAINT "PK_PBI_ORGANIZATION" PRIMARY KEY("ORG_ID"); 

DROP TABLE "PBIRENAMEHISTORY" CASCADE CONSTRAINTS;
DROP TABLE "PBI_ORGANIZATION" CASCADE CONSTRAINTS;
DROP TABLE "PBI_OFFERING" CASCADE CONSTRAINTS;

drop table if exists sub_in_cond_1;
drop table if exists sub_in_cond_2;
create table sub_in_cond_1(a int not null, b int , c varchar(10));
create table sub_in_cond_2(a int not null, b int , c varchar(10));
insert into sub_in_cond_1 values(1, 1, 'aa');
insert into sub_in_cond_1 values(2, null, 'bbb');
insert into sub_in_cond_2 values(1, 1, 'aa');
insert into sub_in_cond_2 values(2, null, 'bbb');
commit;
select * from sub_in_cond_1 t where (a,rownum) in (select a, b from sub_in_cond_1 t1 );
select * from sub_in_cond_1 t where (a,rowscn) in (select a, b from sub_in_cond_2 t1 );
select * from sub_in_cond_1 t where a + ROWNUM in (select a from sub_in_cond_2 t1 );
drop table sub_in_cond_1;
drop table sub_in_cond_2;

drop table if exists clone_expr_parent_ref;
create table clone_expr_parent_ref(id int, GRANTOR int);
insert into clone_expr_parent_ref values (1,1);
insert into clone_expr_parent_ref values (0,1);
insert into clone_expr_parent_ref values (1,0);
insert into clone_expr_parent_ref values (0,0);
select count(*) from (
select  
  count(cast(ref_0.GRANTOR as BINARY_INTEGER)) over (partition by ref_0.GRANTOR order by subq_0.c0) as c7
from 
  (clone_expr_parent_ref as ref_0)
    right join (((select  
            ref_1.GRANTOR as c0
          from 
            (clone_expr_parent_ref as ref_1)
              inner join (clone_expr_parent_ref as ref_2)
              on (ref_1.GRANTOR = ref_2.id )
          where false) as subq_0)
      right join (clone_expr_parent_ref as ref_3)
      on (subq_0.c0 = ref_3.id ))
    on (true)
where EXISTS (
  select   
      subq_1.c2 as c5
    from 
      ((select  
              ref_0.id as c2
            from 
              (clone_expr_parent_ref as ref_28)
                inner join (clone_expr_parent_ref as ref_29)
                on (ref_28.GRANTOR = ref_29.id )
            where true
            limit 76) as subq_1)
        inner join ((clone_expr_parent_ref as ref_30)
          right join (((clone_expr_parent_ref as ref_31)
              inner join (clone_expr_parent_ref as ref_32)
              on (true))
            inner join (((clone_expr_parent_ref as ref_33)
                inner join (clone_expr_parent_ref as ref_34)
                on (true))
              right join (clone_expr_parent_ref as ref_37)
              on (((true) 
                    and (ref_37.GRANTOR is NULL)) 
                  and (ref_37.GRANTOR is not NULL)))
            on (EXISTS (
                select  
                    ref_31.GRANTOR as c0
                  from 
                    clone_expr_parent_ref as ref_38
                  where (true) 
                    or ((EXISTS (
                        select  
                            ref_33.GRANTOR as c0
                          from 
                            clone_expr_parent_ref as ref_39
                          where EXISTS (
                            select 
                                ref_34.GRANTOR as c4
                              from 
                                clone_expr_parent_ref as ref_40
                              where false
							union 
							select ref_33.GRANTOR as c0
								from clone_expr_parent_ref as ref_40
                              where false
								)
                          )) 
                      and (false)))))
          on ((EXISTS (
                select 
                    ref_41.GRANTOR as c15
                  from 
                    clone_expr_parent_ref as ref_41
                  where EXISTS (
                    select  
                        ref_41.GRANTOR as c4
                      from 
                        clone_expr_parent_ref as ref_42
                      where (ref_42.GRANTOR is NULL))))))
        on (true)));


select count(*) from (
select  
  count(cast(ref_0.GRANTOR as BINARY_INTEGER)) over (partition by ref_0.GRANTOR order by subq_0.c0) as c7
from 
  (clone_expr_parent_ref as ref_0)
    right join (((select  
            ref_1.GRANTOR as c0
          from 
            (clone_expr_parent_ref as ref_1)
              inner join (clone_expr_parent_ref as ref_2)
              on (ref_1.GRANTOR = ref_2.id )
          where false) as subq_0)
      right join (clone_expr_parent_ref as ref_3)
      on (subq_0.c0 = ref_3.id ))
    on (true)
where EXISTS (
  select   
      subq_1.c2 as c5
    from 
      ((select  
              ref_0.id as c2
            from 
              (clone_expr_parent_ref as ref_28)
                inner join (clone_expr_parent_ref as ref_29)
                on (ref_28.GRANTOR = ref_29.id )
            where true
            limit 76) as subq_1)
        inner join ((clone_expr_parent_ref as ref_30)
          right join (((clone_expr_parent_ref as ref_31)
              inner join (clone_expr_parent_ref as ref_32)
              on (true))
            inner join (((clone_expr_parent_ref as ref_33)
                inner join (clone_expr_parent_ref as ref_34)
                on (true))
              right join (clone_expr_parent_ref as ref_37)
              on (((true) 
                    and (ref_37.GRANTOR is NULL)) 
                  and (ref_37.GRANTOR is not NULL)))
            on (EXISTS (
                select  
                    ref_31.GRANTOR as c0
                  from 
                    clone_expr_parent_ref as ref_38
                  where (true) 
                    or ((EXISTS (
                        select  
                            ref_33.GRANTOR as c0
                          from 
                            clone_expr_parent_ref as ref_39
                          where EXISTS (
                            select 
                                ref_34.GRANTOR as c4
                              from 
                                clone_expr_parent_ref as ref_40
                              where false
								)
                          )) 
                      and (false)))))
          on ((EXISTS (
                select 
                    ref_41.GRANTOR as c15
                  from 
                    clone_expr_parent_ref as ref_41
                  where EXISTS (
                    select  
                        ref_41.GRANTOR as c4
                      from 
                        clone_expr_parent_ref as ref_42
                      where (ref_42.GRANTOR is NULL))))))
        on (true)));
drop table if exists clone_expr_parent_ref;

-- DTS20200818064HT8P0F00
drop table if exists predicate_push_down_t;
create table predicate_push_down_t
(
    UID integer not null,
    GRANTOR integer not null,
    GRANTEE integer not null,
    PRIVILEGE integer not null
);
create unique index predicate_push_down_t_index on predicate_push_down_t(UID, GRANTEE, PRIVILEGE);

insert into predicate_push_down_t values(0,0,1,0);
insert into predicate_push_down_t values(2,2,1,0);
commit;

select  
    subq_1.c7 as c0
from
    (select  
        subq_0.c1 as c0, 
        subq_0.c2 as c1, 
        subq_0.c0 as c2, 
        subq_0.c1 as c3, 
        subq_0.c3 as c4, 
        subq_0.c1 as c5, 
        subq_0.c2 as c6, 
        subq_0.c0 as c7
     from
        (select  
              ref_0.UID as c0, 
              ref_0.GRANTOR as c1, 
              ref_0.GRANTOR as c2, 
              ref_0.GRANTOR as c3
         from 
              predicate_push_down_t as ref_0
         where ref_0.GRANTOR is not NULL
         limit 26) as subq_0
     limit 108) as subq_1
where EXISTS (
    select
        subq_2.c2 as c0, 
        subq_1.c2 as c1
    from 
        (select  
            ref_2.GRANTOR as c0, 
            ref_1.GRANTOR as c1, 
            subq_1.c7 as c2
         from 
            (predicate_push_down_t as ref_1)
              inner join (predicate_push_down_t as ref_2)
              on (EXISTS (
                        select  
                            subq_1.c6 as c0,
                            ref_1.GRANTOR as c1, 
                            ref_2.UID as c2, 
                            ref_3.GRANTOR as c3
                        from 
                            predicate_push_down_t as ref_3))
         where ref_2.GRANTOR is not NULL) as subq_2
    where case when (EXISTS (
            select  
                ref_4.GRANTOR as c1
            from 
                (predicate_push_down_t as ref_4)
                  right join (predicate_push_down_t as ref_5)
                  on (ref_4.GRANTOR = ref_5.UID )
            where (false))) 
          or (subq_1.c2 is not NULL) then subq_2.c0 else subq_2.c0 end
         is not NULL);

-- the sql needs to be executed twice
select  
    subq_1.c7 as c0
from
    (select  
        subq_0.c1 as c0, 
        subq_0.c2 as c1, 
        subq_0.c0 as c2, 
        subq_0.c1 as c3, 
        subq_0.c3 as c4, 
        subq_0.c1 as c5, 
        subq_0.c2 as c6, 
        subq_0.c0 as c7
     from
        (select  
              ref_0.UID as c0, 
              ref_0.GRANTOR as c1, 
              ref_0.GRANTOR as c2, 
              ref_0.GRANTOR as c3
         from 
              predicate_push_down_t as ref_0
         where ref_0.GRANTOR is not NULL
         limit 26) as subq_0
     limit 108) as subq_1
where EXISTS (
    select
        subq_2.c2 as c0, 
        subq_1.c2 as c1
    from 
        (select  
            ref_2.GRANTOR as c0, 
            ref_1.GRANTOR as c1, 
            subq_1.c7 as c2
         from 
            (predicate_push_down_t as ref_1)
              inner join (predicate_push_down_t as ref_2)
              on (EXISTS (
                        select  
                            subq_1.c6 as c0,
                            ref_1.GRANTOR as c1, 
                            ref_2.UID as c2, 
                            ref_3.GRANTOR as c3
                        from 
                            predicate_push_down_t as ref_3))
         where ref_2.GRANTOR is not NULL) as subq_2
    where case when (EXISTS (
            select  
                ref_4.GRANTOR as c1
            from 
                (predicate_push_down_t as ref_4)
                  right join (predicate_push_down_t as ref_5)
                  on (ref_4.GRANTOR = ref_5.UID )
            where (false))) 
          or (subq_1.c2 is not NULL) then subq_2.c0 else subq_2.c0 end
         is not NULL);
		 
		 
--push down join cond
select  
    subq_1.c7 as c0
from
    (select  
        subq_0.c1 as c0, 
        subq_0.c2 as c1, 
        subq_0.c0 as c2, 
        subq_0.c1 as c3, 
        subq_0.c3 as c4, 
        subq_0.c1 as c5, 
        subq_0.c2 as c6, 
        subq_0.c0 as c7
     from
        (select  
              ref_0.UID as c0, 
              ref_0.GRANTOR as c1, 
              ref_0.GRANTOR as c2, 
              ref_0.GRANTOR as c3
         from 
              predicate_push_down_t as ref_0
         where ref_0.GRANTOR is not NULL
         limit 26) as subq_0
     limit 108) as subq_1
where EXISTS (
    select
        subq_2.c2 as c0, 
        subq_1.c2 as c1
    from 
        (select  
            ref_2.GRANTOR as c0, 
            ref_1.GRANTOR as c1, 
            subq_1.c7 as c2
         from 
            (predicate_push_down_t as ref_1)
              inner join (predicate_push_down_t as ref_2)
              on (EXISTS (
                        select  
                            subq_1.c6 as c0,
                            ref_1.GRANTOR as c1, 
                            ref_2.UID as c2, 
                            ref_3.GRANTOR as c3
                        from 
                            predicate_push_down_t as ref_3))
         where ref_2.GRANTOR is not NULL) as subq_2
		 INNER JOIN (predicate_push_down_t AS REF_4)
    ON (REF_4.GRANTOR LIKE '%')
    where (SUBQ_2.C2 = (SELECT MIN(UID) FROM predicate_push_down_t)
      ) 
  OR (CASE WHEN REF_4.GRANTOR LIKE '%' THEN SUBQ_2.C1 ELSE SUBQ_2.C1 END
       > SUBQ_2.C0) limit 1);

--no error is reported for the second time.	   
select  
    subq_1.c7 as c0
from
    (select  
        subq_0.c1 as c0, 
        subq_0.c2 as c1, 
        subq_0.c0 as c2, 
        subq_0.c1 as c3, 
        subq_0.c3 as c4, 
        subq_0.c1 as c5, 
        subq_0.c2 as c6, 
        subq_0.c0 as c7
     from
        (select  
              ref_0.UID as c0, 
              ref_0.GRANTOR as c1, 
              ref_0.GRANTOR as c2, 
              ref_0.GRANTOR as c3
         from 
              predicate_push_down_t as ref_0
         where ref_0.GRANTOR is not NULL
         limit 26) as subq_0
     limit 108) as subq_1
where EXISTS (
    select
        subq_2.c2 as c0, 
        subq_1.c2 as c1
    from 
        (select  
            ref_2.GRANTOR as c0, 
            ref_1.GRANTOR as c1, 
            subq_1.c7 as c2
         from 
            (predicate_push_down_t as ref_1)
              inner join (predicate_push_down_t as ref_2)
              on (EXISTS (
                        select  
                            subq_1.c6 as c0,
                            ref_1.GRANTOR as c1, 
                            ref_2.UID as c2, 
                            ref_3.GRANTOR as c3
                        from 
                            predicate_push_down_t as ref_3))
         where ref_2.GRANTOR is not NULL) as subq_2
		 INNER JOIN (predicate_push_down_t AS REF_4)
    ON (REF_4.GRANTOR LIKE '%')
    where (SUBQ_2.C2 = (SELECT MIN(UID) FROM predicate_push_down_t)
      ) 
  OR (CASE WHEN REF_4.GRANTOR LIKE '%' THEN SUBQ_2.C1 ELSE SUBQ_2.C1 END
       > SUBQ_2.C0) limit 1);

drop table predicate_push_down_t;

-- DTS202010190K97FWP1J00
drop table if exists subqry_rewrite_t1;
drop table if exists subqry_rewrite_t2;
drop table if exists subqry_rewrite_t3;

create table subqry_rewrite_t1(id number(8) not null, c_num number(8), c_str varchar(20));
create table subqry_rewrite_t2(c_str1 varchar(20), c_str2 varchar(20));
create table subqry_rewrite_t3(c_num number(8),c_str varchar(20));

insert into subqry_rewrite_t1 values(1, 100, 't1_str1');
insert into subqry_rewrite_t2 values('t2_str1', 't2_str2');
insert into subqry_rewrite_t3 values(200, 't3_str1');
commit;

select  
  ref_0.c_num as c0,
  ref_0.c_str as c2
from 
  subqry_rewrite_t1 as ref_0
where exists (
    select distinct 
        ref_0.id as c0, 
        ref_2.c_str1 as c1
    from 
        subqry_rewrite_t2 as ref_2
    where case when not ref_2.c_str2 like '%' 
          then (select c_num from subqry_rewrite_t3 limit 1)
          else (select c_num from subqry_rewrite_t3 limit 1) end = 
          case when ref_0.c_num < any(
              select  
                  c_num as c1
              from 
                  subqry_rewrite_t3 as ref_3
              where ref_3.c_str is not null) 
          then '0' else '0' end
    );

--20210302
create or replace type cast_type_target_210302 is table of varchar(128);
/
select  
  ref_0.c_num as c0,
  ref_0.c_str as c2
from 
  subqry_rewrite_t1  ref_0
where exists (
    select distinct 
        ref_0.id as c0
    from 
        table(cast((select array[1,2] from dual) as  cast_type_target_210302))  ref_2
    where case when not ref_2.column_value = 1
          then (select c_num from subqry_rewrite_t3 limit 1)
          else (select c_num from subqry_rewrite_t3 limit 1) end = 
          case when ref_0.c_num < any(
              select  
                  c_num as c1
              from 
                  subqry_rewrite_t3  ref_3
              where ref_3.c_str is not null) 
          then '0' else '0' end
);
drop table subqry_rewrite_t1;
drop table subqry_rewrite_t2;
drop table subqry_rewrite_t3;

drop table if exists subqry_use_ancestor_t;
create table subqry_use_ancestor_t
(
  c_id binary_integer,
  c_w_id binary_integer,
  c_first varchar(16 byte),
  c_state char(2 byte),
  c_phone char(16 byte),
  c_credit_lim number(12, 2),
  c_balance number(12, 2),
  c_ytd_payment number(12, 2)
);

drop table subqry_use_ancestor_t;

drop table if exists in_union_all_t1;
drop table if exists in_union_all_t2;
create table in_union_all_t1(c1 int, c2 int, c3 int);
create table in_union_all_t2(c1 int);

insert into in_union_all_t1 values(1,1,1);
insert into in_union_all_t1 values(2,2,2);
insert into in_union_all_t2 values(1);
insert into in_union_all_t2 values(3);

select
    c1
from
    in_union_all_t1 as ref_0 
where 3 in (
    (select c3 from in_union_all_t1 as ref_1)
    union all 
    (select c1 from (select c1 from in_union_all_t2 limit 10) as ref_2)
);
drop table in_union_all_t1;
drop table in_union_all_t2;
DROP TABLE IF EXISTS t_0621 CASCADE CONSTRAINTS;
CREATE TABLE t_0621
(
  id int CONSTRAINT pk_id_0621 PRIMARY KEY,
  c_varchar varchar(10)
);
DROP TABLE t_0621;