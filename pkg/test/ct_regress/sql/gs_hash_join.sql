--DTS2019012409416
create table hash_join_t1(f1 int,f2 int, f3 int);
create table hash_join_t2(f1 int,f2 int);
create index ind_hash_join_t2 on hash_join_t2(f1);
insert into hash_join_t1 values(1,3,3);
insert into hash_join_t2 values(1,2);
select 1 from hash_join_t1 where f1 in
(
    select f1 from hash_join_t2 where f2 in
    (
        select 3 from hash_join_t1 t3 where hash_join_t1.f3 = t3.f3  and exists (select 1 from dual)
    )
);
drop table hash_join_t1;
drop table hash_join_t2;
drop table if exists zsharding_tbl_p1;
create table zsharding_tbl_p1(
c_id int, c_int int, c_integer integer, c_bool bool, c_boolean boolean, c_bigint bigint,
c_real real, c_double double,
c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
c_date date, c_datetime datetime, c_timestamp timestamp,c_float float default null
);
INSERT INTO zsharding_tbl_p1 VALUES ( 20, 0, 10, 1, 0, -1088618496, 500000, 1000, 9, 5, 8, 'a', 'def', '2003-02-28', TO_DATE('2002-03-18', 'YYYY-MM-DD'), TO_DATE('2003-11-25', 'YYYY-MM-DD'), TO_TIMESTAMP('2004-08-19 21:38:09', 'YYYY-MM-DD HH24:Mi:SS') ,-1.79E+308);
INSERT INTO zsharding_tbl_p1 VALUES ( 21, 30000, 20000, 0, 1, 30000, 294453248, 0, 2, -110231552, 9, 'ghi', '2004-05-24', 'kbvumx', TO_DATE('2010-08-08', 'YYYY-MM-DD'), TO_DATE('1995-08-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2018-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS'),1.79E+308 );
INSERT INTO zsharding_tbl_p1 VALUES ( 22, 12, 20000, 1, 1, 0, 1, 10, 3000, 13, 0, 'ekb', 'eekbvumxm', 'd', TO_DATE('1995-08-08', 'YYYY-MM-DD'), TO_DATE('2009-11-25', 'YYYY-MM-DD'), TO_TIMESTAMP('1885-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') ,'');
INSERT INTO zsharding_tbl_p1 VALUES ( 23, -1294729216, -1349124096, 1, 1, 1421737984, 10, 20000, 2, 3000, 3000, 'b', '%b%', '2004-06-20 20:20:31', TO_DATE('1880-08-08', 'YYYY-MM-DD'), TO_DATE('2009-11-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2002-05-28 01:05:16', 'YYYY-MM-DD HH24:Mi:SS'),9999999999.123456789 );
INSERT INTO zsharding_tbl_p1 VALUES ( 24, -1485242368, -480182272, 1, 0, 3000, 1000, 0, 12, 11, 1000, '2005-09-02', 'q', '2001-08-18 14:31:12', TO_DATE('2002-05-09', 'YYYY-MM-DD'), TO_DATE('2005-08-06', 'YYYY-MM-DD'), TO_TIMESTAMP('2012-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS'),'' );
INSERT INTO zsharding_tbl_p1 VALUES ( 25, 1000, 0, 1, 0, 4, 20000, 3000, -1371799552, -1394540544, 3, 'def', 'abc', '%b%', TO_DATE('2009-02-10', 'YYYY-MM-DD'), TO_DATE('2001-05-14', 'YYYY-MM-DD'), TO_TIMESTAMP('2001-02-18 14:25:33', 'YYYY-MM-DD HH24:Mi:SS'),''  );
INSERT INTO zsharding_tbl_p1 VALUES ( 26, 1, 10, 1, 0, 1971322880, 11, 30000, 0, 1088159744, 9, 'abc', '_a_%', 'abe', TO_DATE('2002-12-07', 'YYYY-MM-DD'), TO_DATE('2000-07-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2000-01-01 01:01:01', 'YYYY-MM-DD HH24:Mi:SS') ,'' );
INSERT INTO zsharding_tbl_p1 VALUES ( 27, 1199702016, 10, 0, 1, 500000, -1063911424, 12, 0, 11, 5, 'abcdef', 'a', 'c', TO_DATE('2009-04-08', 'YYYY-MM-DD'), TO_DATE('2010-08-08', 'YYYY-MM-DD'), TO_TIMESTAMP('1880-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') ,'' );
INSERT INTO zsharding_tbl_p1 VALUES ( 28, 5, 30000, 1, 1, 14, 500000, 5, 292421632, 5, 13, 'c', 'mab', 'b', TO_DATE('2006-02-08', 'YYYY-MM-DD'), TO_DATE('2000-08-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2011-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS'),''  );
INSERT INTO zsharding_tbl_p1 VALUES ( 29, 1000, 500000, 1, 0, 1221525504, 20000, 2077491200, 13, 12, 40000, '', '2003-07-06 21:08:14', '2004-05-15', TO_DATE('2000-04-20', 'YYYY-MM-DD'), TO_DATE('2008-01-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2011-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') ,'' );
INSERT INTO zsharding_tbl_p1 VALUES ( 30, 1000, 500000, 1, 0, 1221525504, 20000, 2077491200, 13, 12, 40000, 'abcdefgaaaaaaaaa', '2003-07-06 21:08:14', '2004-05-15', TO_DATE('2000-04-20', 'YYYY-MM-DD'), TO_DATE('2008-01-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2011-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS'),''  );
INSERT INTO zsharding_tbl_p1 VALUES ( 31, 1000, 500000, 1, 0, 1221525504, 20000, 2077491200, 13, 12, 40000, null, '2003-07-06 21:08:14', '2004-05-15', TO_DATE('2000-04-20', 'YYYY-MM-DD'), TO_DATE('2008-01-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2011-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') ,'' );

CREATE OR REPLACE PROCEDURE P1 IS A BOOLEAN ;
 TYPE CURTY IS REF CURSOR ;
 CURSOR1 SYS_REFCURSOR;
 CURSOR2 CURTY ;
 BEGIN
 OPEN CURSOR2 FOR SELECT C_BOOLEAN FROM ZSHARDING_TBL_P1 C WHERE C_BOOLEAN IN (SELECT C_BOOLEAN FROM ZSHARDING_TBL_P1 WHERE C_BOOL!=C_BOOLEAN ) ORDER BY C_CHAR , C_VARCHAR , C_VARCHAR2 , C_INT , C_INTEGER , C_BIGINT , C_DECIMAL , C_NUMBER , C_NUMERIC , C_BOOL , C_BOOLEAN , C_TIMESTAMP, C_DATE, C_DATETIME,C_FLOAT ;
 CURSOR1 := CURSOR2 ;
 DBE_SQL.RETURN_CURSOR(CURSOR1);
 END P1;
 /
 BEGIN
 P1();
 END;
 /
 DROP PROCEDURE P1;
 
 
drop table if exists hj_t1;
drop table if exists hj_t2;
drop table if exists hj_t3;
create table hj_t1(f1 int, f2 int, f3 varchar(100), constraint pk_t1_f1 primary key (f1));
create table hj_t2(f1 int, f2 int, f3 varchar(100), constraint pk_t2_f1 primary key (f1));
create table hj_t3(f1 int, f2 int, f3 varchar(100), constraint pk_t3_f1 primary key (f1));

insert into hj_t1 values(1,1,'a');
insert into hj_t1 values(2,2,'b');
insert into hj_t1 values(4,4,'c');
insert into hj_t1 values(5,2,'c');
insert into hj_t2 values(1,2,'b');
insert into hj_t2 values(2,3,'b');
insert into hj_t2 values(3,null,null);
insert into hj_t3 values(1,1,'c');
insert into hj_t3 values(2,2,'c');
insert into hj_t3 values(4,4,'c');
commit;

explain select hj_t1.f1,hj_t1.f2,hj_t2.f2 from hj_t1 left join hj_t2 on abs(hj_t1.f1) = abs(hj_t2.f1);

explain select hj_t1.f1,hj_t1.f2,hj_t2.f2 from hj_t1 left join hj_t2 on abs(hj_t1.f1) + 2 = abs(hj_t2.f1) * 10;

explain select hj_t1.f1,hj_t1.f2,hj_t2.f2 from hj_t1 left join hj_t2 on abs(hj_t1.f1) + hj_t1.f2 = abs(hj_t2.f1) * 10;

explain select hj_t1.f1,hj_t1.f2,hj_t2.f2 from hj_t1 left join hj_t2 on abs(hj_t1.f1) + hj_t2.f2 = abs(hj_t2.f1) * 10;

explain select hj_t1.f1,hj_t1.f2,hj_t2.f2 from hj_t1 left join hj_t2 on hj_t2.f3||'' = hj_t1.f3;

explain select a.f1, b.f1 from hj_t1 a left join hj_t2 b on (a.f2 = b.f2 or a.f3 = b.f2) and a.f2 = b.f2;

explain select a.f1, b.f1 from hj_t1 a left join hj_t2 b on a.f1 = b.f1 or a.f2 = b.f2;

explain SELECT f1,f2 FROM hj_t1 WHERE f2 IN ((SELECT f2 FROM hj_t2 WHERE hj_t2.f2=2),(SELECT f2 FROM hj_t2 WHERE hj_t2.f2=3));

explain SELECT f1,f2 FROM hj_t1 WHERE f2 IN (SELECT f2 FROM hj_t2 WHERE hj_t2.f2=2);

explain SELECT f1,f2 FROM hj_t1 WHERE f2 IN (SELECT f2 FROM hj_t2 WHERE 1 = 1 and hj_t2.f2 in (select f2 from hj_t2 where hj_t2.f3 = 'a'));

explain SELECT f1,f2 FROM hj_t1 WHERE f2 IN (SELECT f2 FROM hj_t2 WHERE hj_t2.f2=hj_t1.f2);

explain SELECT f1,f2 FROM hj_t1 WHERE f2 NOT IN (SELECT f2 FROM hj_t2 WHERE hj_t2.f3 = 'a');

explain SELECT f1,f2 FROM hj_t1 WHERE f2 NOT IN (SELECT f2 FROM hj_t2 WHERE hj_t2.f3 = 'a') and f2 > 2;

explain SELECT f1,f2 FROM hj_t1 WHERE exists (SELECT * FROM hj_t2 WHERE hj_t2.f2 = hj_t1.f2);

explain SELECT f1,f2 FROM hj_t1 WHERE NOT EXISTS (SELECT * FROM hj_t2 WHERE hj_t1.f2=hj_t2.f2);

explain SELECT f1,f2 FROM hj_t1 WHERE NOT EXISTS (SELECT * FROM hj_t2 WHERE hj_t1.f2=hj_t2.f2 and hj_t1.f3=hj_t2.f3);

explain SELECT * FROM hj_t1 t1, hj_t2 t2 WHERE t1.f2 IN (SELECT f2 FROM hj_t2 WHERE 1 = 1 ) 
and t1.f3 in (SELECT f3 FROM hj_t3 WHERE 1 = 1 );

explain SELECT * FROM hj_t1 t1, hj_t2 t2 WHERE t1.f2 IN (SELECT f2 FROM hj_t2 WHERE 1 = 1 ) 
and t2.f3 in (SELECT f3 FROM hj_t3 WHERE 1 = 1 );

explain SELECT * FROM hj_t1 t1 left join hj_t2 t2 on t1.f1=t2.f1+0 WHERE t1.f2 IN (SELECT f2 FROM hj_t2 WHERE 1 = 1 ) 
and t1.f3 in (SELECT f3 FROM hj_t3 WHERE 1 = 1 );

explain SELECT * FROM hj_t1 t1 right join hj_t2 t2 on t1.f1=t2.f1+0 WHERE t1.f2 IN (SELECT f2 FROM hj_t2 WHERE 1 = 1 ) 
and t2.f3 in (SELECT f3 FROM hj_t3 WHERE 1 = 1 );

explain delete from hj_t1 where rowid in (
select a.rowid from hj_t1 a where a.f1 = 1 and a.f2 = 1 
and not exists (select 1 from hj_t2 where f1 = a.f1 and f2 = a.f2 and (f3=a.f3 or (f3 is null and a.f3 is null))));
delete from hj_t1 where rowid in (
select a.rowid from hj_t1 a where a.f1 = 1 and a.f2 = 1 
and not exists (select 1 from hj_t2 where f1 = a.f1 and f2 = a.f2 and (f3=a.f3 or (f3 is null and a.f3 is null))));
rollback;

-----------------------------------------------------------------------------------------------------------------------
explain select avg(f1) from hj_t1 where f2 in (select f2 from hj_t2) and exists(select f2 from hj_t3);

explain select avg(f1) from hj_t1 where exists (select f2 from hj_t2) and exists(select f2 from hj_t3);

explain SELECT f1,f2 FROM hj_t1 WHERE exists (SELECT * FROM hj_t2 WHERE hj_t1.f2 > 2);

explain SELECT f1,f2 FROM hj_t1 WHERE exists (SELECT * FROM hj_t2 WHERE hj_t2.f2 = hj_t1.f2 and hj_t1.f1 > 2 and hj_t2.f1 > 1);

explain SELECT f1,f2 FROM hj_t1 WHERE NOT EXISTS (SELECT * FROM hj_t2 WHERE hj_t1.f2=hj_t2.f2);

explain SELECT f1,f2 FROM hj_t1 WHERE NOT EXISTS (SELECT * FROM hj_t2 WHERE hj_t1.f2=hj_t2.f2 and hj_t1.f3 = hj_t2.f3);

explain SELECT * FROM hj_t1 t1, hj_t2 t2 WHERE EXISTS (SELECT * FROM hj_t3 t3 WHERE t1.f2=t3.f2 and t1.f1 >= 1);

explain SELECT * FROM hj_t1 t1, hj_t2 t2 WHERE EXISTS (SELECT * FROM hj_t3 t3 WHERE t1.f2=t3.f2 and t1.f2 >= 1);

explain SELECT * FROM hj_t1 t1, hj_t2 t2 WHERE NOT EXISTS (SELECT * FROM hj_t3 t3 WHERE t1.f2=t3.f2 and t1.f1 >= 1);

explain SELECT * FROM hj_t1 t1, hj_t2 t2 WHERE EXISTS (SELECT * FROM hj_t3 t3 WHERE t1.f2=t3.f2 and t1.f1 = t2.f1);

explain SELECT * FROM hj_t1 t1 inner join hj_t2 t2 on t1.f1=t2.f1 WHERE NOT EXISTS (SELECT * FROM hj_t3 t3 WHERE t1.f2=t3.f2 and t2.f2 = t3.f2);

explain SELECT * FROM hj_t1 t1 inner join hj_t2 t2 on t1.f1=t2.f1 
WHERE NOT EXISTS (SELECT * FROM hj_t3 t3 WHERE t1.f2=t3.f2 and t2.f2 = t3.f2 and t3.f1=1);

explain SELECT * FROM hj_t1 t1 inner join hj_t2 t2 on t1.f1=t2.f1 
WHERE NOT EXISTS (SELECT * FROM hj_t3 t3 inner join hj_t3 t4 on t3.f1=t4.f1 WHERE t1.f2=t3.f2 and t2.f2 = t3.f2 and t3.f1=1);

explain SELECT * FROM hj_t1 t1 WHERE EXISTS (SELECT * FROM hj_t2 t2,hj_t3 t3 WHERE t1.f2=t3.f2 and t2.f1 = t3.f1);

explain SELECT * FROM hj_t1 t1 WHERE EXISTS (SELECT * FROM hj_t2 t2 inner join hj_t3 t3 on t1.f2=t3.f2 and t2.f1 = t3.f1 );

explain SELECT * FROM hj_t1 t1 WHERE EXISTS (SELECT distinct f2 from hj_t2 t2 where t1.f2=t2.f2);

--never change the following plan unless you known what it means
explain SELECT * FROM hj_t1 t1 WHERE t1.f1 IN (select t2.f1 from hj_t2 t2 join hj_t3 t3 on t2.f2=t3.f2 and t3.f1 = 1);

explain select count(*) as numwait from hj_t1 t1, hj_t2 t2, hj_t3 t3 where t1.f1 = t2.f1 and t3.f1 = t2.f1 and t2.f2 > t2.f1 
and exists (select * from hj_t2 l2 where l2.f1 = t2.f1 and l2.f2 <> t2.f2);

--delete/update using NL (with index)
explain  delete from t1, t2 using hj_t1 t1, hj_t2 t2 where t1.f1 = t2.f1 and t1.f1 = 1;
explain delete from t1, t2 using hj_t1 t1 left join hj_t2 t2 on t1.f1 = t2.f1 where t1.f1 = 1;
explain delete from hj_t1 t1 where t1.f1 in (select f1 from hj_t2 t2 where t2.f2 = 1);
explain delete from hj_t1 t1 where exists (select 1 from hj_t2 t2 where t2.f1 = t1.f1 and t2.f2 = 1);
explain delete from t1,t2,t3 using hj_t1 t1 left join hj_t2 t2 on t1.f1=t2.f1 join hj_t3 t3 on t2.f1=t3.f1; 
explain update hj_t1 t1, hj_t2 t2 set t1.f3 = 'aaa', t2.f3 = 'bbb' where t1.f1=t2.f1 and t1.f1 = 1;  
explain update hj_t1 t1 join hj_t2 t2 on t1.f1=t2.f1 set t1.f3 = 'aaa', t2.f3 = 'bbb' where t1.f1 = 1;
explain update hj_t1 t1, hj_t2 t2, hj_t3 t3 set t1.f3 = 'aaa', t2.f3 = 'bbb', t3.f3 = t2.f3 where t1.f1=t2.f1 and t2.f2=t3.f2; 
explain update hj_t1 t1 left join hj_t2 t2 on t1.f1=t2.f1 join hj_t3 t3 on t2.f1=t3.f1 set t1.f3 = 'aaa', t2.f3 = 'bbb', t3.f3 = t2.f3 where t1.f1=1;

--subselect_as_table optimz
explain update hj_t1 t1 set f2 = 111 where exists(select 1 from (select distinct f1,f2 from hj_t2 where exists(select 1 from hj_t1)) s2 where s2.f1=t1.f1 and(s2.f2 != t1.f2 or t1.f2 is null) AND exists(select 1 from hj_t2));
update hj_t1 t1 set f2 = 111 where exists(select 1 from (select distinct f1,f2 from hj_t2 where exists(select 1 from hj_t1)) s2 where s2.f1=t1.f1 and(s2.f2 != t1.f2 or t1.f2 is null) AND exists(select 1 from hj_t2));
select * from hj_t1 order by f1;
rollback;

drop table hj_t1;
drop table hj_t2;
drop table hj_t3;

drop table if exists hash_join_table;
create table hash_join_table(id int not null,c_intger integer,c_char char(10));
insert into hash_join_table values(1,1000,1000);
insert into hash_join_table values(2,2000,1000);
insert into hash_join_table values(3,2001,null);
insert into hash_join_table values(4,2002,'a');
commit;

select count(*) from hash_join_table t1 right join hash_join_table t2 on t1.id=t2.id
inner join hash_join_table t3 on t1.id=t3.id
right join hash_join_table t4 on t1.id=t4.id
left join hash_join_table t5 on t1.id=t5.id
inner join hash_join_table t6 on t1.id=t6.id
left join hash_join_table t7 on t1.id=t7.id
full outer join hash_join_table t8 on t1.id=t8.id
full join hash_join_table t9 on t1.id=t9.id
full outer join hash_join_table t10 on t1.id=t10.id
right join hash_join_table t11 on t1.id=t11.id
full outer join hash_join_table t12 on t1.id=t12.id
full outer join hash_join_table t13 on t1.id=t13.id
right join hash_join_table t14 on t1.id=t14.id
right join hash_join_table t15 on t1.id=t15.id
right join hash_join_table t16 on t1.id=t16.id
full outer join hash_join_table t17 on t1.id=t17.id
left join hash_join_table t18 on t1.id=t18.id
left join hash_join_table t19 on t1.id=t19.id
right join hash_join_table t20 on t1.id=t20.id
full outer join hash_join_table t21 on t1.id=t21.id
right join hash_join_table t22 on t1.id=t22.id
full outer join hash_join_table t23 on t1.id=t23.id
left join hash_join_table t24 on t1.id=t24.id
inner join hash_join_table t25 on t1.id=t25.id;

drop table hash_join_table;

drop table if exists all_datatype_table;
create table all_datatype_table(id int not null,c_intger integer,c_char char(10))
PARTITION BY RANGE (c_intger)
(
partition P_20180121 values less than (2018),
partition P_20190122 values less than (2019),
partition P_20200123 values less than (2020),
partition P_max values less than (2050)
);
insert into all_datatype_table values(1,1000,1000);
insert into all_datatype_table values(2,2000,1000);
insert into all_datatype_table values(3,2001,null);
insert into all_datatype_table values(4,2002,'a');
commit;

explain select * from all_datatype_table t1 join all_datatype_table t2 on t1.c_intger=t2.c_char order by 1,2,3,4,5,6;
drop table all_datatype_table;

----for choose hash table by table extent pages -------------------------------------------------------------
drop table if exists hash_join_tbl_000;
drop table if exists hash_join_com_tbl_001;
drop table if exists hash_join_com_tbl_001_1;
create table hash_join_tbl_000(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt real NOT NULL,c_end date NOT NULL,c_unsig int,c_big number(20,0),c_vchar varchar2(2000),c_data varchar2(1500),c_text blob,c_clob clob,c_image clob,c_binary varchar2(3000),c_varbinary varchar2(1000),c_raw raw(1000),primary key(c_id,c_d_id,c_w_id));

insert into hash_join_tbl_000 values(1,1,1,'AA'||'is1cmvls','OE','AA'||'BAR1BARBAR','bkili'||'1'||'fcxcle'||'1','pmbwo'||'1'||'vhvpaj'||'1','dyf'||'1'||'rya'||'1','uq',4800||'1',940||'1'||205||'1',to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,10.0,to_date(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),1,1,lpad('1234ABCDRFGHopqrstuvwxyz8',1500,'ABfgCDefgh'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbxxbm',200,'yxcfgdsgtcjxrbxxbm'),lpad('124324543256546324554354325',200,'7687389015'),lpad('sbfacwjpbvpgthpyxcpmnutcjdfaxrbxxbm',200,'yxcpmnutcjxrbxxbm'),lpad('123dSHGGefasdy',200,'678ASVDFopqrst9234'),lpad('12345abcdegf',200,'adbede1fghij1kLMHG3FFHUK'),lpad('ede1fghij1kLMHG3',200,'xcp2345abcdepmnu'),lpad('1234567890abcdfe',200,'abc1d2fe123895ab456cdef'));

CREATE or replace procedure hash_join_proc_001(startall int,endall int) as
i INT;
BEGIN
 if startall < endall then
  FOR i IN startall..endall LOOP
        insert into hash_join_tbl_000 select c_id+i,c_d_id+i,c_w_id+i,'AA'||'is'||i||'cmvls',c_middle,'AA'||'BAR'||i||'ddBARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,'940205',c_since+i,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end+i,c_unsig+i,c_big+100000*i,c_vchar,lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbxxbm',200,'yxcfgdsgtcjxrbxxbm'),c_text,c_clob,c_image,lpad('12345abcdegf',200,'adbede1fghij'||i||'kLMHG3FFHUK'),lpad('ede1fghij1kLMHG3',200,'xcp23'||i||'45abcdepmnu'),lpad('1234567890abcdfe',200,'abc1d2fe123'||i||'895ab456cdef') from hash_join_tbl_000 where c_id=1;
  END LOOP;
 end if;
END;
/

call hash_join_proc_001(1,1999);

create table hash_join_com_tbl_001(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt real NOT NULL,c_end date NOT NULL,c_unsig int,c_big number(20,0),c_vchar varchar2(2000),c_data varchar2(1500),c_text blob,c_clob clob,c_image clob,c_binary varchar2(3000),c_varbinary varchar2(1000),c_raw raw(1000));

create unique index primary_key on hash_join_com_tbl_001(c_id,c_d_id,c_w_id);

create unique index hash_join_indx_001_1 ON hash_join_com_tbl_001(c_id,c_d_id);

create index hash_join_indx_001_2 ON hash_join_com_tbl_001(c_id);

create unique index hash_join_indx_001_3 ON hash_join_com_tbl_001(c_big);

create index hash_join_indx_001_4 ON hash_join_com_tbl_001(c_first,c_binary);

create index hash_join_indx_001_5 ON hash_join_com_tbl_001(c_id,c_d_id,c_varbinary);

create index hash_join_indx_001_6 ON hash_join_com_tbl_001(c_id,c_d_id,c_street_1,c_raw);


create table hash_join_com_tbl_001_1(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt real NOT NULL,c_end date NOT NULL,c_unsig int,c_big number(20,0),c_vchar varchar2(2000),c_data varchar2(1500),c_text blob,c_clob clob,c_image clob,c_binary varchar2(3000),c_varbinary varchar2(1000),c_raw raw(1000));

insert into hash_join_com_tbl_001 select * from hash_join_tbl_000 where mod(c_id,2)=1;

select count(*) from hash_join_com_tbl_001;

insert into hash_join_com_tbl_001_1 select * from hash_join_tbl_000 where mod(c_id,5)=1;

select count(*) from hash_join_com_tbl_001_1;

explain select count(1) from hash_join_com_tbl_001_1 t1 inner join hash_join_com_tbl_001 t2 on t1.c_id=t2.c_id+0;
explain select count(1) from hash_join_com_tbl_001 t1 inner join hash_join_com_tbl_001_1 t2 on t1.c_id=t2.c_id+0;

drop table hash_join_tbl_000;
drop table hash_join_com_tbl_001;
drop table hash_join_com_tbl_001_1;

drop table if exists t_hash_join_plan;
create table t_hash_join_plan(
        c_id int, c_int int, c_integer integer, c_bool int, c_boolean int, c_bigint integer, 
        c_real real, c_double real, 
        c_decimal decimal(38), c_number number(38), c_numeric numeric(38), 
        c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
        c_date date, c_datetime date, c_timestamp timestamp
) 
PARTITION BY RANGE (c_integer)
(
        partition P_20180121 values less than (0),
        partition P_20190122 values less than (50000),
        partition P_20200123 values less than (100000),
        partition P_max values less than (maxvalue)
);
INSERT INTO t_hash_join_plan VALUES ( 20, 0, 10, 1, 0, -1088618496, 500000, 1000, 9, 5, 8, 'a', 'def', '2003-02-28', TO_DATE('2002-03-18', 'YYYY-MM-DD'), TO_DATE('2003-11-25', 'YYYY-MM-DD'), TO_TIMESTAMP('2004-08-19 21:38:09', 'YYYY-MM-DD HH24:Mi:SS') );
INSERT INTO t_hash_join_plan VALUES ( 21, 30000, 20000, 0, 1, 30000, 294453248, 0, 2, -110231552, 9, 'ghi', '2004-05-24', 'kbvumx', TO_DATE('2010-08-08', 'YYYY-MM-DD'), TO_DATE('1995-08-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2018-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') );
INSERT INTO t_hash_join_plan VALUES ( 22, 12, 20000, 1, 1, 0, 1, 10, 3000, 13, 0, 'ekb', 'eekbvumxm', 'd', TO_DATE('1995-08-08', 'YYYY-MM-DD'), TO_DATE('2009-11-25', 'YYYY-MM-DD'), TO_TIMESTAMP('1885-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') );
INSERT INTO t_hash_join_plan VALUES ( 23, -1294729216, -1349124096, 1, 1, 1421737984, 10, 20000, 2, 3000, 3000, 'b', '%b%', '2004-06-20 20:20:31', TO_DATE('1880-08-08', 'YYYY-MM-DD'), TO_DATE('2009-11-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2002-05-28 01:05:16', 'YYYY-MM-DD HH24:Mi:SS') );
INSERT INTO t_hash_join_plan VALUES ( 24, -1485242368, -480182272, 1, 0, 3000, 1000, 0, 12, 11, 1000, '2005-09-02', 'q', '2001-08-18 14:31:12', TO_DATE('2002-05-09', 'YYYY-MM-DD'), TO_DATE('2005-08-06', 'YYYY-MM-DD'), TO_TIMESTAMP('2012-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') );
INSERT INTO t_hash_join_plan VALUES ( 25, 1000, 0, 1, 0, 4, 20000, 3000, -1371799552, -1394540544, 3, 'def', 'abc', '%b%', TO_DATE('2009-02-10', 'YYYY-MM-DD'), TO_DATE('2001-05-14', 'YYYY-MM-DD'), TO_TIMESTAMP('2001-02-18 14:25:33', 'YYYY-MM-DD HH24:Mi:SS') );
INSERT INTO t_hash_join_plan VALUES ( 26, 1, 10, 1, 0, 1971322880, 11, 30000, 0, 1088159744, 9, 'abc', '_a_%', 'abe', TO_DATE('2002-12-07', 'YYYY-MM-DD'), TO_DATE('2000-07-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2000-01-01 01:01:01', 'YYYY-MM-DD HH24:Mi:SS') );
INSERT INTO t_hash_join_plan VALUES ( 27, 1199702016, 10, 0, 1, 500000, -1063911424, 12, 0, 11, 5, 'abcdef', 'a', 'c', TO_DATE('2009-04-08', 'YYYY-MM-DD'), TO_DATE('2010-08-08', 'YYYY-MM-DD'), TO_TIMESTAMP('1880-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') );
INSERT INTO t_hash_join_plan VALUES ( 28, 5, 30000, 1, 1, 14, 500000, 5, 292421632, 5, 13, 'c', 'mab', 'b', TO_DATE('2006-02-08', 'YYYY-MM-DD'), TO_DATE('2000-08-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2011-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') );
INSERT INTO t_hash_join_plan VALUES ( 29, 1000, 500000, 1, 0, 1221525504, 20000, 2077491200, 13, 12, 40000, '', '2003-07-06 21:08:14', '2004-05-15', TO_DATE('2000-04-20', 'YYYY-MM-DD'), TO_DATE('2008-01-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2011-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') );
INSERT INTO t_hash_join_plan VALUES ( 30, 1000, 500000, 1, 0, 1221525504, 20000, 2077491200, 13, 12, 40000, 'abcdefgaaaaaaaaa', '2003-07-06 21:08:14', '2004-05-15', TO_DATE('2000-04-20', 'YYYY-MM-DD'), TO_DATE('2008-01-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2011-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') );
INSERT INTO t_hash_join_plan VALUES ( 31, 1000, 500000, 1, 0, 1221525504, 20000, 2077491200, 13, 12, 40000, null, '2003-07-06 21:08:14', '2004-05-15', TO_DATE('2000-04-20', 'YYYY-MM-DD'), TO_DATE('2008-01-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2011-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') );
create index t_hash_join_plan_idx1 on t_hash_join_plan(c_id);
create index t_hash_join_plan_idx2 on t_hash_join_plan(c_integer);
create index t_hash_join_plan_idx3 on t_hash_join_plan(c_varchar);
create index t_hash_join_plan_idx4 on t_hash_join_plan(c_char);
create index t_hash_join_plan_idx5 on t_hash_join_plan(c_timestamp);
create index t_hash_join_plan_idx6 on t_hash_join_plan(c_id,c_integer,c_number);
create index t_hash_join_plan_idx7 on t_hash_join_plan(c_id,c_varchar,c_char,c_timestamp);
commit;
explain SELECT t1.c_id,t1.c_varchar FROM t_hash_join_plan t1 where t1.c_varchar = any (select c_varchar from t_hash_join_plan where rowid not in (select rowid from t_hash_join_plan where c_id<25));
explain SELECT t1.c_id,t1.c_varchar FROM t_hash_join_plan t1 where t1.c_varchar = any (select c_varchar from t_hash_join_plan where rowid in (select rowid from t_hash_join_plan where c_id<25));
explain select c_id from t_hash_join_plan where rowid not in (select rowid from t_hash_join_plan where c_id=25);
explain select c_id from t_hash_join_plan where rowid in (select rowid from t_hash_join_plan where c_id=25);
drop table t_hash_join_plan;

DROP TABLE if exists hj_t1;
DROP TABLE if exists hj_t2;
DROP TABLE if exists hj_t3;
DROP TABLE if exists hj_t4;

--hash join should not have index
create table hj_t1(f1 int, f2 int, f3 varchar(100));
create table hj_t2(f1 int, f2 int, f3 varchar(100));
create table hj_t3(f1 int, f2 int, f3 varchar(100));
create table hj_t4(f1 int, f2 int, f3 varchar(100));

insert into hj_t1 values(1,1,'a');
insert into hj_t1 values(2,2,'a');
insert into hj_t1 values(4,4,'a');
insert into hj_t1 values(5,2,'c');
insert into hj_t2 values(1,2,'a');
insert into hj_t2 values(2,3,'a');
insert into hj_t2 values(3,null,'a');
insert into hj_t3 values(1,1,'a');
insert into hj_t3 values(2,2,'b');
insert into hj_t3 values(4,4,'c');
insert into hj_t4 values(1,1,'c');
insert into hj_t4 values(3,3,'b');
insert into hj_t4 values(4,4,'a');
commit;

EXPLAIN SELECT * FROM hj_t1 t1,hj_t2 t2 WHERE EXISTS(SELECT 1 FROM hj_t3 t3 where t3.f1=t1.f1 and t3.f2=t2.f2) order by t1.f1,t2.f1;
EXPLAIN SELECT * FROM hj_t1 t1,hj_t2 t2 WHERE NOT EXISTS(SELECT 1 FROM hj_t3 t3 where t3.f1=t1.f1 and t3.f2=t2.f2) order by t1.f1,t2.f1;
EXPLAIN SELECT * FROM hj_t1 t1 WHERE EXISTS(SELECT 1 FROM hj_t2 t2 WHERE t2.f1=t1.f1 AND ROWNUM < 2) order by t1.f1;
EXPLAIN SELECT * FROM hj_t1 t1 WHERE NOT EXISTS(SELECT 1 FROM hj_t2 t2 WHERE t2.f1=t1.f1 AND ROWNUM < 2) order by t1.f1;
EXPLAIN SELECT * FROM hj_t1 t1, (SELECT * FROM hj_t2 order by f2) t2 WHERE EXISTS(SELECT 1 FROM hj_t3 t3 where t3.f1=t1.f1 and t3.f2=t2.f2) order by t1.f1,t2.f1;

--not exists has OR cond
EXPLAIN SELECT * FROM hj_t1 t1 WHERE NOT EXISTS(SELECT 1 FROM hj_t2 t2 WHERE t2.f1=t1.f1 AND (t1.f1 is null or t2.f1 is null));
EXPLAIN SELECT * FROM hj_t1 t1 WHERE NOT EXISTS(SELECT 1 FROM hj_t2 t2 WHERE t2.f1=t1.f1 AND (t2.f2 is null or t2.f2 = 0));

--sql cannot use semi or anti join
EXPLAIN SELECT * FROM hj_t1 t1 WHERE EXISTS(SELECT 1 FROM hj_t2 t2 WHERE t2.f1=t1.f1 AND ROWNUM < 2) order by t1.f1;
EXPLAIN SELECT * FROM hj_t1 t1 WHERE NOT EXISTS(SELECT 1 FROM hj_t2 t2 WHERE t2.f1=t1.f1 AND ROWNUM < 2) order by t1.f1;
EXPLAIN SELECT * FROM hj_t1 t1 WHERE t1.f1 IN (SELECT t2.f1 FROM hj_t2 t2 WHERE ROWNUM < 2 ) order by t1.f1;
EXPLAIN SELECT * FROM hj_t1 t1 WHERE t1.f1 NOT IN (SELECT t2.f1 FROM hj_t2 t2 WHERE ROWNUM < 2 ) order by t1.f1;
EXPLAIN SELECT * FROM hj_t1 t1 WHERE EXISTS(SELECT 1 FROM hj_t2 t2 LEFT JOIN hj_t3 t3 ON t2.f2=t3.f2 where t3.f1=t1.f1) order by t1.f1;
EXPLAIN SELECT * FROM hj_t1 t1 WHERE EXISTS(SELECT 1 FROM hj_t2 t2 LEFT JOIN hj_t3 t3 ON t2.f2=t3.f2 and t3.f1=t1.f1 where t2.f1 = t1.f1) order by t1.f1;
EXPLAIN SELECT * FROM hj_t1 t1 WHERE NOT EXISTS(SELECT 1 FROM hj_t2 t2 LEFT JOIN hj_t3 t3 ON t2.f2=t3.f2 where t3.f1=t1.f1) order by t1.f1;
EXPLAIN SELECT * FROM hj_t1 t1 WHERE NOT EXISTS(SELECT 1 FROM hj_t2 t2 LEFT JOIN hj_t3 t3 ON t2.f2=t3.f2 and t3.f1=t1.f1 where t2.f1 = t1.f1) order by t1.f1;
EXPLAIN SELECT * FROM hj_t1 t1 WHERE EXISTS(SELECT f1 FROM hj_t2 t2 where t2.f1 = t1.f1 group by f1) order by t1.f1;
EXPLAIN SELECT * FROM hj_t1 t1 WHERE NOT EXISTS(SELECT f1 FROM hj_t2 t2 where t2.f1=t1.f1 group by f1) order by t1.f1;

--sql that can use semi or hash join, but not implemented
EXPLAIN SELECT * FROM hj_t1 t1 WHERE t1.f1 IN(SELECT t2.f1 FROM hj_t2 t2 WHERE t2.f2=t1.f2) order by t1.f1;
EXPLAIN SELECT * FROM hj_t1 t1 WHERE t1.f1 NOT IN(SELECT t2.f1 FROM hj_t2 t2 WHERE t2.f2=t1.f2) order by t1.f1;

--delete/update using hash join
explain  delete from t1, t2 using hj_t1 t1, hj_t2 t2 where t1.f1 = t2.f1 and t1.f1 = 1;
explain delete from t1, t2 using hj_t1 t1 left join hj_t2 t2 on t1.f1 = t2.f1 where t1.f1 = 1;
explain delete from hj_t1 t1 where t1.f1 in (select f1 from hj_t2 t2 where t2.f2 = 1);
explain delete from hj_t1 t1 where exists (select 1 from hj_t2 t2 where t2.f1 = t1.f1 and t2.f2 = 1);
explain update hj_t1 t1, hj_t2 t2 set t1.f3 = 'aaa', t2.f3 = 'bbb' where t1.f1=t2.f1 and t1.f1 = 1;  
explain update hj_t1 t1 join hj_t2 t2 on t1.f1=t2.f1 set t1.f3 = 'aaa', t2.f3 = 'bbb' where t1.f1 = 1;
--delete/update subselect using hash join
explain delete from hj_t1 where f1 in (select f1 from hj_t2);
explain delete from hj_t1 where f1 not in(select f1 from hj_t2);
explain delete from hj_t1 where exists (select 1 from hj_t3 t3 where t3.f1 = hj_t1.f1); 
explain delete from hj_t1 where not exists (select 1 from hj_t2 t2 where t2.f1 = hj_t1.f1); 
explain UPDATE hj_t1 t1 SET t1.f3 = 'aaa' where t1.f1 in (select f1 from hj_t2);
explain UPDATE hj_t1 t1 SET t1.f3 = 'bbb' where t1.f1 not in (select f1 from hj_t2);
explain UPDATE hj_t1 t1 SET t1.f3 = 'ccc' where exists (select 1 from hj_t2 t2 where t2.f1 = t1.f1);
explain UPDATE hj_t1 t1 SET t1.f3 = 'ddd' where not exists (select 1 from hj_t2 t2 where t2.f1 = t1.f1); 

--delete cannot rewrite
explain delete from hj_t1 where rowid in (
select a.rowid from hj_t1 a where a.f1 = 1 and a.f2 = 1 
and not exists (select 1 from hj_t2 where f1 = a.f1 and f2 = a.f2 and (f3=a.f3 or (f3 is null and a.f3 is null))));
delete from hj_t1 where rowid in (
select a.rowid from hj_t1 a where a.f1 = 1 and a.f2 = 1 
and not exists (select 1 from hj_t2 where f1 = a.f1 and f2 = a.f2 and (f3=a.f3 or (f3 is null and a.f3 is null))));

--in to exist with rowid
explain delete from hj_t1 where rowid in (select t1.rowid from hj_t1 t1 where t1.f1 >1 );
explain delete from hj_t1 where rowid in (select hj_t1.rowid from hj_t2 t1, hj_t3 t2 where t1.f1 = t2.f1 and 
not exists (select 1 from hj_t1 c where c.f1 = t1.f1 and c.f1 = 1));
explain delete from hj_t1 where rowid in (select hj_t1.rowid from hj_t2 t1, hj_t3 t2 where hj_t1.f1 = t1.f1 and t1.f1 = t2.f1 and 
not exists (select 1 from hj_t1 c where c.f1 = t1.f1 and c.f1 = 1));
explain delete from hj_t1 where rowid in (select hj_t1.rowid from hj_t2 t1, hj_t3 t2 where hj_t1.f1 = t1.f1 and t1.f1 = t2.f1 and 
not exists (select 1 from hj_t1 c where c.f1 = t1.f1 and c.f1 = 1));

--or cond with no ancestor 
explain select * from hj_t1 t1 where exists (select 1 from hj_t2 t2, hj_t3 t3 where t2.f1 = t1.f1 and t2.f2=t3.f2 and (t2.f1=1 or t2.f1 = 0));

--DTS2018122802240
delete from hj_t1;
delete from hj_t2;
delete from hj_t3;
insert into hj_t1 values(1,1,'a');
insert into hj_t1 values(2,2,'a');
insert into hj_t1 values(4,4,'a');
insert into hj_t1 values(5,2,'c');
insert into hj_t2 values(1,2,'a');
insert into hj_t2 values(2,3,'a');
insert into hj_t2 values(3,null,'a');
insert into hj_t3 values(1,1,'a');
insert into hj_t3 values(2,2,'b');
insert into hj_t3 values(4,4,'c');
commit;
update hj_t1 join hj_t2 on hj_t1.f1=hj_t2.f2 set hj_t1.f3 = 'aaaa' where hj_t2.f2 in (select f2 from hj_t3);
select hj_t1.* from hj_t1 join hj_t2 on hj_t1.f1=hj_t2.f2 where hj_t2.f2 in (select f2 from hj_t3) order by 1;
UPDATE hj_t1 set f3 = 'aaa' where f1 = (select MIN(F1) from hj_t2);
DELETE FROM hj_t1 where f1 = (select MIN(F2) from hj_t2);
INSERT INTO hj_t3(f1, f2, f3) SELECT * from hj_t1 where not exists (select 1 from hj_t2 where hj_t2.f1 = hj_t1.f1);
SELECT * FROM HJ_T1 ORDER BY F1;
SELECT * FROM HJ_T3 ORDER BY F1, F2, F3;

explain update hj_t1 t1 set t1.f3 = (select concat(t2.f3,t3.f3) from hj_t2 t2 join hj_t3 t3 on t2.f1=t3.f1 where t2.f1=t1.f1) where exists(select 1 from hj_t2 t2 join hj_t3 t3 on t2.f1=t3.f1 where t2.f1=t1.f1);
explain update hj_t1 t1 set t1.f3 = (select concat(t2.f3,t3.f3) from hj_t2 t2 join hj_t3 t3 on t2.f1=t3.f1 where t2.f1=1) where exists (select 1 from hj_t2 t2 join hj_t3 t3 on t2.f1=t3.f1 where t2.f1=1);
explain update hj_t1 t1 set f3 = (select t2.f3||t3.f3 from hj_t2 t2 join hj_t3 t3 on t2.f1=t3.f1 where t1.f1=t2.f1 union select t3.f3||t4.f3 from hj_t3 t3 join hj_t4 t4 on t3.f1=t4.f1 where exists(select 1 from hj_t1 t1 where t1.f1=t3.f1)) where exists (select 1 from hj_t2 t2 join hj_t3 t3 on t2.f1=t3.f1 where t1.f1=t2.f1 union select 1 from hj_t3 t3 join hj_t4 t4 on t3.f1=t4.f1 where exists(select 1 from hj_t1 t1 where t1.f1=t3.f1));


--Bugfix: in hash optimz coredump--
CREATE or replace procedure sp_Init_RXUBPSupport_A4() is
i int := 1;
cunt INT := 0;
BEGIN
  if i IN (1,2,3,4,5,6,7,8,9,10) then
    insert into hj_t1(f1,f2) select f1,f2 from hj_t2 where f1 in(1,2,3,4,5,6,7,8,9,10);
    select count(*) INTO cunt from hj_t1 where f1 in(1,2,3,4,5,6,7,8,9,10);
    dbe_output.print_line(cunt);
  end if;
END;
/
set serveroutput on;
call sp_Init_RXUBPSupport_A4();
set serveroutput off;
drop procedure sp_Init_RXUBPSupport_A4;

--any optimizer
--f1=any => in
--f1>any => f1>min
--f1<>any => exists
explain select * from hj_t1 where f1 = any(select f1 from hj_t2);
explain select * from hj_t1 where f1 > any(select f1 from hj_t2);
explain select * from hj_t1 where f1 <> any(select f1 from hj_t2);

DROP TABLE hj_t1;
DROP TABLE hj_t2;
DROP TABLE hj_t3;
DROP TABLE hj_t4;

DROP TABLE IF EXISTS LINEITEM;
CREATE TABLE LINEITEM ( L_ORDERKEY    INTEGER NOT NULL,			
                             L_PARTKEY     INTEGER NOT NULL,			
                             L_SUPPKEY     INTEGER NOT NULL,			
                             L_LINENUMBER  INTEGER NOT NULL,			
                             L_QUANTITY    DECIMAL(15,2) NOT NULL,			
                             L_EXTENDEDPRICE  DECIMAL(15,2) NOT NULL,			
                             L_DISCOUNT    DECIMAL(15,2) NOT NULL,			
                             L_TAX         DECIMAL(15,2) NOT NULL,			
                             L_RETURNFLAG  CHAR(1) NOT NULL,			
                             L_LINESTATUS  CHAR(1) NOT NULL,			
                             L_SHIPDATE    DATE NOT NULL,			
                             L_COMMITDATE  DATE NOT NULL,			
                             L_RECEIPTDATE DATE NOT NULL,			
                             L_SHIPINSTRUCT CHAR(25) NOT NULL,			
                             L_SHIPMODE     CHAR(10) NOT NULL,			
                             L_COMMENT      VARCHAR(44) NOT NULL);			

ALTER TABLE LINEITEM ADD CONSTRAINT PK_LINEITEM PRIMARY KEY (L_ORDERKEY,L_LINENUMBER);

DROP TABLE IF EXISTS PART;
CREATE TABLE PART  ( P_PARTKEY     INTEGER NOT NULL,			
                          P_NAME        VARCHAR(55) NOT NULL,			
                          P_MFGR        CHAR(25) NOT NULL,			
                          P_BRAND       CHAR(10) NOT NULL,			
                          P_TYPE        VARCHAR(25) NOT NULL,			
                          P_SIZE        INTEGER NOT NULL,			
                          P_CONTAINER   CHAR(10) NOT NULL,			
                          P_RETAILPRICE DECIMAL(15,2) NOT NULL,			
                          P_COMMENT     VARCHAR(23) NOT NULL );			
			
ALTER TABLE PART ADD CONSTRAINT PK_PART PRIMARY KEY (P_PARTKEY);	

explain plan for select
 sum(l_extendedprice* (1 - l_discount)) as revenue
from
 lineitem,
 part
where
 (
  p_partkey  =  l_partkey
  and p_brand = 'Brand#43'
  and p_container in ('SM CASE', 'SM BOX', 'SM PACK', 'SM PKG')
  and l_quantity >= 9 and l_quantity <= 9 + 10
  and p_size between 1 and 5
  and l_shipmode in ('AIR', 'AIR REG')
  and l_shipinstruct = 'DELIVER IN PERSON'
 )
 or
 (
  p_partkey  =  l_partkey
  and p_brand = 'Brand#34'
  and p_container in ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK')
  and l_quantity >= 10 and l_quantity <= 10 + 10
  and p_size between 1 and 10
  and l_shipmode in ('AIR', 'AIR REG')
  and l_shipinstruct = 'DELIVER IN PERSON'
 )
 or
 (
  p_partkey  =  l_partkey
  and p_brand = 'Brand#14'
  and p_container in ('LG CASE', 'LG BOX', 'LG PACK', 'LG PKG')
  and l_quantity >= 23 and l_quantity <= 23 + 10
  and p_size between 1 and 15
  and l_shipmode in ('AIR', 'AIR REG')
  and l_shipinstruct = 'DELIVER IN PERSON'
 );

drop table if exists offers_20050701;
create table offers_20050701
(
    PROMO_ID VARCHAR(10) NOT NULL ,
    PARTY_ID VARCHAR(10) NULL,
    LOCATION_ID number(17,0) NULL ,
    PARTY_FIRSTNAME VARCHAR(20) NULL ,
    PARTY_LASTNAME VARCHAR(20) NULL ,
    VISITS number(38,20) NULL ,
    CLUB_LEVEL CHAR(7) NULL 
);
create unique index index_007 on offers_20050701(promo_id,LOCATION_ID,club_level);

drop table if exists all_divisions;
create table all_divisions
(
    all_divisions_cd varchar(50) not null ,
    all_divisions_name varchar(100) null
);
create unique index index_008 on all_divisions(all_divisions_cd);

explain SELECT Table_005.all_divisions_cd   Column_005,
       Table_005.all_divisions_name Column_006
  FROM offers_20050701 Table_007, all_divisions Table_005
 RIGHT OUTER JOIN all_divisions
    ON Table_005.all_divisions_cd <> Table_005.all_divisions_cd
   AND Table_005.all_divisions_name = Table_005.all_divisions_name
 ORDER BY 1, 2 DESC LIMIT 8;

drop table if exists offers_20050701;
drop table if exists all_divisions;

drop table if exists t_join_base_001;
drop table if exists t_join_base_101;
drop table if exists t_join_base_102;
drop table if exists t_join_base_103;
drop table if exists t_join_base_104;
drop table if exists t_join_base_105;

create table t_join_base_001(id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,c_char char(10),c_vchar varchar(10),c_vchar2 varchar2(100),c_clob clob,c_long clob,c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp);
insert into t_join_base_001 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_join_base_001 values(0,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
 
create table t_join_base_101 as select * from t_join_base_001;    
create table t_join_base_102 as select * from t_join_base_001;  
create table t_join_base_103 as select * from t_join_base_001; 
create table t_join_base_104 as select * from t_join_base_001; 
create table t_join_base_105 as select * from t_join_base_001; 

explain select count(*) from t_join_base_001 t1 join t_join_base_101 t2 on t1.id=t2.id join t_join_base_102 t3 on t1.id=t2.id where exists (select * from (select t2.id from t_join_base_105));
explain delete from t1 using t_join_base_001 t1 join t_join_base_101 t2 on t1.id=t2.id join t_join_base_102 t3 on t1.id=t2.id where exists (select * from (select t2.id from t_join_base_105));
explain update t_join_base_001 t1 join t_join_base_101 t2 on t1.id=t2.id join t_join_base_102 t3 on t1.id=t2.id set t1.c_vchar = 'aaaaaa' where exists (select * from (select t2.id from t_join_base_105));
select count(*) from t_join_base_001 t1 join t_join_base_101 t2 on t1.id=t2.id join t_join_base_102 t3 on t1.id=t2.id where exists (select * from (select t2.id from t_join_base_105));

drop table if exists t_join_base_001;
drop table if exists t_join_base_101;
drop table if exists t_join_base_102;
drop table if exists t_join_base_103;
drop table if exists t_join_base_104;
drop table if exists t_join_base_105;

--SELECT_AS_TABLE optimizer
DROP TABLE IF EXISTS "T_P_EUTRANINTRAFREQNCELL_A1FC" CASCADE CONSTRAINTS;
CREATE TABLE "T_P_EUTRANINTRAFREQNCELL_A1FC"
(
  "PLANID" BINARY_INTEGER NOT NULL,
  "PHYID" BINARY_INTEGER NOT NULL,
  "CMENEID" BINARY_INTEGER NOT NULL,
  "ENTITYMOOPID" BINARY_INTEGER,
  "OBJECTID" BINARY_INTEGER NOT NULL,
  "ANRFLAG" BINARY_INTEGER,
  "ATTACHCELLSWITCH" BINARY_INTEGER,
  "CELLID" BINARY_INTEGER NOT NULL,
  "CELLINDIVIDUALOFFSET" BINARY_INTEGER,
  "CELLMEASPRIORITY" BINARY_INTEGER,
  "CELLQOFFSET" BINARY_INTEGER,
  "CELLRANGEEXPANSION" BINARY_INTEGER,
  "CTRLMODE" BINARY_INTEGER,
  "ENODEBID" BINARY_INTEGER NOT NULL,
  "HIGHSPEEDCELLINDOFFSET" BINARY_INTEGER,
  "LOCALCELLID" BINARY_INTEGER NOT NULL,
  "LOCALCELLNAME" VARCHAR(256 BYTE),
  "MCC" VARCHAR(256 BYTE) NOT NULL,
  "MNC" VARCHAR(256 BYTE) NOT NULL,
  "NCELLADDITIONTIME" DATE,
  "NCELLCLASSLABEL" BINARY_INTEGER,
  "NEIGHBOURCELLNAME" VARCHAR(256 BYTE),
  "NOHOFLAG" BINARY_INTEGER,
  "NORMVFLAG" BINARY_INTEGER,
  "VECTORCELLFLAG" BINARY_INTEGER
);

DROP TABLE IF EXISTS "USRMODP_LCELLCHGINFO" CASCADE CONSTRAINTS;
CREATE TABLE "USRMODP_LCELLCHGINFO"
(
  "PLANID" BINARY_INTEGER,
  "CMENEID" BINARY_INTEGER NOT NULL,
  "OLDLOCALCELLID" BINARY_INTEGER NOT NULL,
  "NEWLOCALCELLID" BINARY_INTEGER,
  "NEWCELLID" BINARY_INTEGER,
  "NEWCELLNAME" VARCHAR(255 BYTE),
  "NEWSECTORNO" BINARY_INTEGER,
  "OLDENODEBID" BINARY_INTEGER,
  "OLDSECTORNO" BINARY_INTEGER,
  "OLDCELLID" BINARY_INTEGER,
  "OLDCELLNAME" VARCHAR(255 BYTE)
);

CREATE INDEX "IDX2#_P_472_01234_A1FC" ON "T_P_EUTRANINTRAFREQNCELL_A1FC"("PLANID", "PHYID", "LOCALCELLID", "MCC", "MNC", "ENODEBID", "CELLID");
CREATE INDEX "IDX2#_P_472_50515253_A1FC" ON "T_P_EUTRANINTRAFREQNCELL_A1FC"("PLANID", "MCC", "MNC", "ENODEBID", "CELLID");
ALTER TABLE "T_P_EUTRANINTRAFREQNCELL_A1FC" ADD CONSTRAINT "PK#_P_472_A1FC" PRIMARY KEY("PLANID", "OBJECTID");
CREATE INDEX "IDX_LCELLCHGINFO_USRMODP" ON "USRMODP_LCELLCHGINFO"("PLANID", "CMENEID", "OLDLOCALCELLID");


EXPLAIN UPDATE t_P_EUTRANINTRAFREQNCELL_A1FC
   SET (LOCALCELLNAME) =
       (SELECT s2.LOCALCELLNAME
          FROM t_P_EUTRANINTRAFREQNCELL_A1FC s1
          JOIN (SELECT DISTINCT A.OLDLOCALCELLID,
                               A.NEWCELLNAME AS LOCALCELLNAME,
                               A.CMENEID
                 FROM UsrModP_LCELLCHGINFO A
                WHERE (A.OLDCELLNAME != A.NEWCELLNAME)
                  AND (A.PlanID = 1)) s2
            ON (s1.CMENEID = s2.CMENEID)
           AND (s1.LOCALCELLID = s2.OLDLOCALCELLID)
           AND ((s1.LOCALCELLNAME != s2.LOCALCELLNAME) OR
               ((s1.LOCALCELLNAME IS NULL) AND
               (s2.LOCALCELLNAME IS NOT NULL)) OR
               ((s1.LOCALCELLNAME IS NOT NULL) AND
               (s2.LOCALCELLNAME IS NULL)))
         WHERE (t_P_EUTRANINTRAFREQNCELL_A1FC.PlanID = s1.PlanID)
           AND (t_P_EUTRANINTRAFREQNCELL_A1FC.CMENEID = s1.CMENEID)
           AND (t_P_EUTRANINTRAFREQNCELL_A1FC.objectId = s1.objectId)
           AND (s1.PlanID = 1))
 WHERE (t_P_EUTRANINTRAFREQNCELL_A1FC.PlanID = 1)
   AND (EXISTS (SELECT 1
                  FROM (SELECT DISTINCT A.OLDLOCALCELLID,
                                        A.NEWCELLNAME AS LOCALCELLNAME,
                                        A.CMENEID
                          FROM UsrModP_LCELLCHGINFO A
                         WHERE (A.OLDCELLNAME != A.NEWCELLNAME)
                           AND (A.PlanID = 1)) s3
                 WHERE (t_P_EUTRANINTRAFREQNCELL_A1FC.CMENEID = s3.CMENEID)
                   AND (t_P_EUTRANINTRAFREQNCELL_A1FC.LOCALCELLID =  s3.OLDLOCALCELLID)
                   AND ((t_P_EUTRANINTRAFREQNCELL_A1FC.LOCALCELLNAME != s3.LOCALCELLNAME) OR 
                        ((t_P_EUTRANINTRAFREQNCELL_A1FC.LOCALCELLNAME IS NULL) AND (s3.LOCALCELLNAME IS NOT NULL)) OR
                        ((t_P_EUTRANINTRAFREQNCELL_A1FC.LOCALCELLNAME IS NOT NULL) AND (s3.LOCALCELLNAME IS NULL))
                       )
                  )
        );
DROP TABLE T_P_EUTRANINTRAFREQNCELL_A1FC;
DROP TABLE USRMODP_LCELLCHGINFO;

--DTS2019012802625 
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

insert into t_join_base_001 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_join_base_101 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_join_base_102 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
commit;

select count(*) from (select * from t_join_base_001) t1 inner join (select * from (select * from t_join_base_101)) t2 on t1.c_vchar=t2.c_vchar inner join (select * from t_join_base_102) t3 on t1.c_int<>t2.c_int and t1.c_int is not null where exists(select * from (select * from t_join_base_001) t4 where t1.c_int=t4.c_int or t2.c_int=t4.c_int or t3.c_vchar>t4.c_vchar or t1.c_int>t2.c_int or t2.c_int<=t3.c_int and t1.c_int is null or t2.c_int between 20 and 1000 or t3.c_vchar in (select c_vchar from (select * from (select * from t_join_base_101))) and exists(select * from (select * from t_join_base_102) t5 where t1.c_vchar!=t5.c_vchar ) or 1=2 or 1=3 );

drop table t_join_base_001;
drop table t_join_base_101;
drop table t_join_base_102;

--support (f1,f2) in (select f1,f2 from t2) to hash join
drop table if exists customer;
create table customer
(
    c_customer_sk             integer               not null,
    c_customer_id             char(16)              not null,
    c_current_cdemo_sk        integer                       ,
    c_current_hdemo_sk        integer                       ,
    c_current_addr_sk         integer                       ,
    c_first_shipto_date_sk    integer                       ,
    c_first_sales_date_sk     integer                       ,
    c_salutation              char(10)                      ,
    c_first_name              char(20)                      ,
    c_last_name               char(30)                      ,
    c_preferred_cust_flag     char(1)                       ,
    c_birth_day               integer                       ,
    c_birth_month             integer                       ,
    c_birth_year              integer                       ,
    c_birth_country           varchar(20)                   ,
    c_login                   char(13)                      ,
    c_email_address           char(50)                      ,
    c_last_review_date        char(10)
);
create index customer_index on customer(c_customer_sk);

drop table if exists inventory;
create table inventory
(
    inv_date_sk               integer               not null,
    inv_item_sk               integer               not null,
    inv_warehouse_sk          integer               not null,
    inv_quantity_on_hand      integer
)
partition by range(inv_date_sk)
(
        partition p1 values less than(2451179),
        partition p2 values less than(2451544),
        partition p3 values less than(2451910),
        partition p4 values less than(2452275),
        partition p5 values less than(2452640),
        partition p6 values less than(2453005),
        partition p7 values less than(maxvalue)
);

explain select c_first_name, max(c_last_name), min(c_preferred_cust_flag), 'ABC'
  from customer
 where (c_birth_day, c_birth_month) in
       (select c_birth_day, c_birth_month
          from customer
         where c_birth_year < 2000)
and c_birth_country like '%J%'
 group by c_first_name
 having max(c_last_name) like '%n%' and min(c_preferred_cust_flag)='Y'
 order by 1, 2, 3;

explain select count(distinct(inv_date_sk)), max(inv_warehouse_sk)
  from inventory
 where (inv_item_sk, inv_date_sk, inv_warehouse_sk) not in
       (select inv_warehouse_sk, inv_date_sk, inv_item_sk
          from inventory
         where inv_quantity_on_hand > 20 
         and inv_date_sk < 2451544);

drop table customer;
drop table inventory;

drop table if exists catalog_returns;
create table catalog_returns
(
    cr_returned_date_sk       integer                       ,
    cr_returned_time_sk       integer                       ,
    cr_item_sk                integer               not null,
    cr_refunded_customer_sk   integer                       ,
    cr_refunded_cdemo_sk      integer                       ,
    cr_refunded_hdemo_sk      integer                       ,
    cr_refunded_addr_sk       integer                       ,
    cr_returning_customer_sk  integer                       ,
    cr_returning_cdemo_sk     integer                       ,
    cr_returning_hdemo_sk     integer                       ,
    cr_returning_addr_sk      integer                       ,
    cr_call_center_sk         integer                       ,
    cr_catalog_page_sk        integer                       ,
    cr_ship_mode_sk           integer                       ,
    cr_warehouse_sk           integer                       ,
    cr_reason_sk              integer                       ,
    cr_order_number           bigint                not null,
    cr_return_quantity        integer                       ,
    cr_return_amount          decimal(7,2)                  ,
    cr_return_tax             decimal(7,2)                  ,
    cr_return_amt_inc_tax     decimal(7,2)                  ,
    cr_fee                    decimal(7,2)                  ,
    cr_return_ship_cost       decimal(7,2)                  ,
    cr_refunded_cash          decimal(7,2)                  ,
    cr_reversed_charge        decimal(7,2)                  ,
    cr_store_credit           decimal(7,2)                  ,
    cr_net_loss               decimal(7,2)
);
create index catalog_returns_index on catalog_returns(cr_item_sk, cr_order_number);

drop table if exists catalog_page;
create table catalog_page
(
    cp_catalog_page_sk        integer               not null,
    cp_catalog_page_id        char(16)              not null,
    cp_start_date_sk          integer                       ,
    cp_end_date_sk            integer                       ,
    cp_department             varchar(50)                   ,
    cp_catalog_number         integer                       ,
    cp_catalog_page_number    integer                       ,
    cp_description            varchar(100)                  ,
    cp_type                   varchar(100)
);
create index catalog_page_index on catalog_page (cp_catalog_page_sk);
 
DROP TABLE IF EXISTS web_returns CASCADE CONSTRAINTS;
CREATE TABLE web_returns
(
    WR_RETURNED_DATE_SK      BINARY_INTEGER,
    WR_RETURNED_TIME_SK      BINARY_INTEGER,
    WR_ITEM_SK               BINARY_INTEGER NOT NULL,
    WR_REFUNDED_CUSTOMER_SK  BINARY_INTEGER,
    WR_REFUNDED_CDEMO_SK     BINARY_INTEGER,
    WR_REFUNDED_HDEMO_SK     BINARY_INTEGER,
    WR_REFUNDED_ADDR_SK      BINARY_INTEGER,
    WR_RETURNING_CUSTOMER_SK BINARY_INTEGER,
    WR_RETURNING_CDEMO_SK    BINARY_INTEGER,
    WR_RETURNING_HDEMO_SK    BINARY_INTEGER,
    WR_RETURNING_ADDR_SK     BINARY_INTEGER,
    WR_WEB_PAGE_SK           BINARY_INTEGER,
    WR_REASON_SK             BINARY_INTEGER,
    WR_ORDER_NUMBER          BINARY_BIGINT NOT NULL,
    WR_RETURN_QUANTITY       BINARY_INTEGER,
    WR_RETURN_AMT            NUMBER(7, 2),
    WR_RETURN_TAX            NUMBER(7, 2),
    WR_RETURN_AMT_INC_TAX    NUMBER(7, 2),
    WR_FEE                   NUMBER(7, 2),
    WR_RETURN_SHIP_COST      NUMBER(7, 2),
    WR_REFUNDED_CASH         NUMBER(7, 2),
    WR_REVERSED_CHARGE       NUMBER(7, 2),
    WR_ACCOUNT_CREDIT        NUMBER(7, 2),
    WR_NET_LOSS              NUMBER(7, 2)
);

explain select cr_return_quantity,max(cr_return_amt_inc_tax)+cr_fee
  from catalog_returns
 where (cr_returned_date_sk, cr_returned_time_sk) in
       (select wr_returned_date_sk,
               (select cr_returned_time_sk
                  from catalog_returns
                 where cr_refunded_customer_sk< 100
     and cr_returned_time_sk -1 not in
                       (select cr_returned_date_sk
                          from catalog_returns
                         where cr_return_quantity > 10
                           and not exists (select cp_start_date_sk
                                   from catalog_page
                                   where cp_type like '%as%'))
        order by 1 limit 1)
          from web_returns
         where wr_return_quantity / 10 > 5)
group by cr_return_quantity, cr_fee order by 1,2;

drop table catalog_returns;
drop table catalog_page;
drop table web_returns;

--DTS2019030110040
drop table if exists hash_join_compare_tbl_000;
create table hash_join_compare_tbl_000(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt real NOT NULL,c_end date NOT NULL,c_unsig int,c_big number(20,0),c_vchar varchar2(2000),c_data varchar2(1500),c_text blob,c_clob clob,c_image clob,c_binary varchar2(3000),c_varbinary varchar2(1000),c_raw raw(1000));
ALTER TABLE hash_join_compare_tbl_000 ADD CONSTRAINT pk_hj_com_tbl_000 primary key(c_id,c_d_id,c_w_id);

drop table if exists hash_join_com_tbl_140;
create table hash_join_com_tbl_140(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt real NOT NULL,c_end date NOT NULL,c_unsig int,c_big number(20,0),c_vchar varchar2(2000),c_data varchar2(1500),c_text blob,c_clob clob,c_image clob,c_binary varchar2(3000),c_varbinary varchar2(1000),c_raw raw(1000));
ALTER TABLE hash_join_com_tbl_140 ADD CONSTRAINT pk_hj_com_tbl_140 primary key(c_id,c_d_id,c_w_id);

create unique index hash_join_indx_140_1 ON hash_join_com_tbl_140(c_id,c_d_id);
create index hash_join_indx_140_2 ON hash_join_com_tbl_140(c_id);
create unique index hash_join_indx_140_3 ON hash_join_com_tbl_140(c_big);
create index hash_join_indx_140_4 ON hash_join_com_tbl_140(c_first,c_binary);
create index hash_join_indx_140_5 ON hash_join_com_tbl_140(c_id,c_d_id,c_varbinary);
create index hash_join_indx_140_6 ON hash_join_com_tbl_140(c_id,c_d_id,c_street_1,c_raw);

drop table if exists hash_join_tbl_global_140_1;
create table hash_join_tbl_global_140_1(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt real NOT NULL,c_end date NOT NULL,c_unsig int,c_big number(20,0),c_vchar varchar2(2000),c_data varchar2(1500),c_text blob,c_clob clob,c_image clob,c_binary varchar2(3000),c_varbinary varchar2(1000),c_raw raw(1000));

drop table if exists hash_join_com_tbl_140_2;
create table hash_join_com_tbl_140_2(c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(50) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt real NOT NULL,c_end date NOT NULL,c_unsig int,c_big number(20,0),c_vchar varchar2(2000),c_data varchar2(1500),c_text blob,c_clob clob,c_image clob,c_binary varchar2(3000),c_varbinary varchar2(1000),c_raw raw(1000));

explain select distinct a.c_first, sum(b.c_id)
  from hash_join_com_tbl_140 a
 inner join (select a.c_id, a.c_first
               from hash_join_tbl_global_140_1 a
              inner join hash_join_com_tbl_140_2 b
                 on a.c_last = b.c_last
                and (a.c_w_id + 10 = b.c_w_id or
                    mod(a.c_id, 2) = a.c_id * 2 + 10)
              where a.c_w_id not in (select c_w_id
                                       from hash_join_com_tbl_140
                                      where c_w_id > 1000)) b
    on a.c_id = b.c_id
   and (a.c_id + 10 < 1000 or mod(b.c_id, 2) = 1)   
   inner join hash_join_com_tbl_140_2 c
      on a.c_id = c.c_id
 where c.c_id not in
       (select a.c_id
          from hash_join_com_tbl_140 a
         inner join hash_join_tbl_global_140_1 b
            on a.c_id * 2 + 1 = b.c_id + 10
           and (a.c_first like 'AAis8%' or a.c_first like 'AAis7%')
         where a.c_id < 800)
   and a.c_first like 'AAis8%'
 group by a.c_first, b.c_id
 order by 1, 2;

explain select distinct a.c_id, b.c_id
  from hash_join_com_tbl_140_2 a
 inner join hash_join_tbl_global_140_1 b
    on a.c_id + a.c_d_id + 10 = b.c_id * 2
   and (a.c_id < 900 or a.c_id > 1000)
 inner join hash_join_tbl_global_140_1 c
    on a.c_id + 5 = c.c_id
 where a.c_id < 1000
   and b.c_first not in
       (select a.c_first
          from hash_join_com_tbl_140_2 a
         inner join hash_join_tbl_global_140_1 b
            on a.c_id = b.c_id + 10
           and (length(a.c_first || 'b') = length(b.c_first) or
               b.c_id is not null)
         where a.c_id not in (select c_id
                                from hash_join_com_tbl_140_2
                               where c_id > 1000)
           and a.c_first in
               (select a.c_first
                  from hash_join_com_tbl_140_2 a
                 inner join hash_join_tbl_global_140_1 b
                    on a.c_first = b.c_first
                   and (a.c_id * 2 / 3 = b.c_id + 1 or a.c_first = b.c_first)
                 where a.c_first not in
                       (select c_first
                          from hash_join_com_tbl_140_2
                         where c_first > 'AAis8')))
 group by a.c_id, b.c_id
 order by 1, 2;

drop table hash_join_compare_tbl_000;
drop table hash_join_com_tbl_140;
drop table hash_join_tbl_global_140_1;
drop table hash_join_com_tbl_140_2;

--dts
drop table if exists RQG_LIST_DATATYPE_034;
CREATE TABLE RQG_LIST_DATATYPE_034(C_INT INT ,C_INTEGER INTEGER NOT NULL ,C_BIGINT BIGINT ,C_NUMBER NUMBER DEFAULT 0.2332,C_DOUBLE DOUBLE,C_DECIMAL DECIMAL,C_REAL REAL ,C_CHAR CHAR(100)  ,C_VARCHAR VARCHAR(100) ,C_VARCHAR2 VARCHAR2(4000),C_NUMERIC NUMERIC,C_DATETIME DATETIME  ,C_TIMESTAMP TIMESTAMP default '9999-12-31 23:59:59.999999',C_TIMESTAMP1 TIMESTAMP(6),C_BOOL BOOL);
insert into RQG_LIST_DATATYPE_034 values(629080064,1147338752,5169287947291197440,21342134134.324,347676.34356,21342134134.324,347676.34356,'12.34','12.34','12.34',2134217676.324,'2002-10-28 07:54:49','2018-04-05 10:23:45.999999','2018-04-05 10:23:45.999999',1);
insert into RQG_LIST_DATATYPE_034 values(2057961472,-1604452352,-5301018236391784448,21342134134.324,347676.34356,21342134134.324,347676.34356,'12.34','12.34','12.34',2134217676.324,'2003-07-12 05:49:07','2018-04-05 10:23:45.999999','2018-04-05 10:23:45.999999',FALSE);
insert into RQG_LIST_DATATYPE_034 values(-1130758144,-98959360,-1732478481654087680,21342134134.324,347676.34356,21342134134.324,347676.34356,'12.34','12.34','12.34',2134217676.324,'2002-10-13 01:09:24','2018-04-05 10:23:45.999999','2018-04-05 10:23:45.999999',true);
insert into RQG_LIST_DATATYPE_034 values(1880293376,-1145569280,6243677933395771392,21342134134.324,347676.34356,21342134134.324,347676.34356,'12.34','12.34','12.34',2134217676.324,'2007-05-28 17:02:24','2018-04-05 10:23:45.999999','2018-04-05 10:23:45.999999',0);
insert into RQG_LIST_DATATYPE_034 values(1550123008,1695547392,8818892495321563136,21342134134.324,347676.34356,21342134134.324,347676.34356,'12.34','12.34','12.34',2134217676.324,'2003-05-17 18:46:00','2018-04-05 10:23:45.999999','2018-04-05 10:23:45.999999',FALSE);
commit;

select C_INT from RQG_LIST_DATATYPE_034 where C_TIMESTAMP IN (select C_REAL from RQG_LIST_DATATYPE_034) order by c_int,c_number,c_real limit 5;
select C_INT,C_BOOL,C_BIGINT from RQG_LIST_DATATYPE_034 where C_BOOL IN (select C_BIGINT from RQG_LIST_DATATYPE_034) order by c_int,c_number,c_real;
select C_INT,C_BOOL,C_BIGINT from RQG_LIST_DATATYPE_034 where C_BOOL IN (2,3,4,5,6,'true','false',5169287947291197440,true,false) order by c_int,c_number,c_real;
drop table RQG_LIST_DATATYPE_034;

--  DTS2019090404766
drop table if exists table_emp_lob_017 ;
create table table_emp_lob_017(f1 int,f2 blob not null,f3 clob default EMPTY_CLOB);
insert into table_emp_lob_017 values(1,EMPTY_BLOB,'');
insert into table_emp_lob_017 values(2,'001001001',EMPTY_CLOB);
insert into table_emp_lob_017 values(3,'001001001','EMPTY_LOB');
insert into table_emp_lob_017 values(5,'001001001','EMPTY_CLOB');
commit;

drop table if exists table_emp_lob_017_01 ;
create table table_emp_lob_017_01(f1 int,f2 blob not null,f3 clob default EMPTY_CLOB);
insert into table_emp_lob_017_01 values(1,EMPTY_BLOB,'EMPTY');
insert into table_emp_lob_017_01 values(2,EMPTY_BLOB,EMPTY_CLOB);
insert into table_emp_lob_017_01 values(4,EMPTY_BLOB,EMPTY_CLOB);
insert into table_emp_lob_017_01 values(6,'01001',EMPTY_CLOB);
commit;
select t1.f1,t1.f2,length(t1.f2),t1.f3,length(t1.f3) from table_emp_lob_017 t1 inner join table_emp_lob_017_01 t2 on t1.f2 = t2.f2;
select t1.f1,t1.f2,length(t1.f2),t1.f3,length(t1.f3) from table_emp_lob_017 t1 inner join table_emp_lob_017_01 t2 on t1.f3 = t2.f3;

select * from table_emp_lob_017 t1 where f1 < 0 or t1.f3 in (select f3 from table_emp_lob_017_01 t2);
select * from table_emp_lob_017 t1 where t1.f3 in (select f3 from table_emp_lob_017_01 t2);
drop table table_emp_lob_017 ;
drop table table_emp_lob_017_01 ;

--DTS2019090614302
drop table if exists item;
drop table if exists customer;
drop table if exists web_site;
drop table if exists web_page;

create table item
(
    i_item_sk                 integer               not null,
    i_item_id                 char(16)              not null,
    i_rec_start_date          date                          ,
    i_rec_end_date            date                          ,
    i_item_desc               varchar(200)                  ,
    i_current_price           decimal(7,2)                  ,
    i_wholesale_cost          decimal(7,2)                  ,
    i_brand_id                integer                       ,
    i_brand                   char(50)                      ,
    i_class_id                integer                       ,
    i_class                   char(50)                      ,
    i_category_id             integer                       ,
    i_category                char(50)                      ,
    i_manufact_id             integer                       ,
    i_manufact                char(50)                      ,
    i_size                    char(20)                      ,
    i_formulation             char(20)                      ,
    i_color                   char(20)                      ,
    i_units                   char(10)                      ,
    i_container               char(10)                      ,
    i_manager_id              integer                       ,
    i_product_name            char(50)                      ,
    constraint pk_item_sk primary key (i_item_sk)
);

create table customer
(
    c_customer_sk             integer               not null,
    c_customer_id             char(16)              not null,
    c_current_cdemo_sk        integer                       ,
    c_current_hdemo_sk        integer                       ,
    c_current_addr_sk         integer                       ,
    c_first_shipto_date_sk    integer                       ,
    c_first_sales_date_sk     integer                       ,
    c_salutation              char(10)                      ,
    c_first_name              char(20)                      ,
    c_last_name               char(30)                      ,
    c_preferred_cust_flag     char(1)                       ,
    c_birth_day               integer                       ,
    c_birth_month             integer                       ,
    c_birth_year              integer                       ,
    c_birth_country           varchar(20)                   ,
    c_login                   char(13)                      ,
    c_email_address           char(50)                      ,
    c_last_review_date        char(10)                      ,
    constraint pk_customer_sk primary key (c_customer_sk)
);

create table web_site
(
    web_site_sk               integer               not null,
    web_site_id               char(16)              not null,
    web_rec_start_date        date                          ,
    web_rec_end_date          date                          ,
    web_name                  varchar(50)                   ,
    web_open_date_sk          integer                       ,
    web_close_date_sk         integer                       ,
    web_class                 varchar(50)                   ,
    web_manager               varchar(40)                   ,
    web_mkt_id                integer                       ,
    web_mkt_class             varchar(50)                   ,
    web_mkt_desc              varchar(100)                  ,
    web_market_manager        varchar(40)                   ,
    web_company_id            integer                       ,
    web_company_name          char(50)                      ,
    web_street_number         char(10)                      ,
    web_street_name           varchar(60)                   ,
    web_street_type           char(15)                      ,
    web_suite_number          char(10)                      ,
    web_city                  varchar(60)                   ,
    web_county                varchar(30)                   ,
    web_state                 char(2)                       ,
    web_zip                   char(10)                      ,
    web_country               varchar(20)                   ,
    web_gmt_offset            decimal(5,2)                  ,
    web_tax_percentage        decimal(5,2)                  ,
    constraint pk_web_site_sk primary key (web_site_sk)
);

create table web_page
(
    wp_web_page_sk            integer               not null,
    wp_web_page_id            char(16)              not null,
    wp_rec_start_date         date                          ,
    wp_rec_end_date           date                          ,
    wp_creation_date_sk       integer                       ,
    wp_access_date_sk         integer                       ,
    wp_autogen_flag           char(1)                       ,
    wp_customer_sk            integer                       ,
    wp_url                    varchar(100)                  ,
    wp_type                   char(50)                      ,
    wp_char_count             integer                       ,
    wp_link_count             integer                       ,
    wp_image_count            integer                       ,
    wp_max_ad_count           integer                       ,
    constraint pk_web_page_sk primary key (wp_web_page_sk)
);

explain select web_mkt_id, wp_rec_start_date
  from web_site
  right join web_page
    on web_site_sk = wp_web_page_sk
   and web_mkt_id =
       (select min(c_birth_day)
          from customer, item
         where c_birth_country like '%J%'
           and c_birth_month = extract(month from web_rec_start_date)
           and i_category_id = web_mkt_id)
 where wp_rec_start_date is not null
 group by web_mkt_id, wp_rec_start_date
 order by 1,2;
 
explain select c_birth_month,i_category_id, min(c_birth_day), max(i_wholesale_cost)
  from customer, item
  where c_birth_country like '%J%'
  group by c_birth_month,i_category_id;
 
drop table if exists item;
drop table if exists customer;
drop table if exists web_site;
drop table if exists web_page;


drop table if exists hj_t1;
drop table if exists hj_t2;
drop table if exists hj_t3;
create table hj_t1(f1 int, f2 int);
create table hj_t2(f1 int, f2 int);
create table hj_t3(f1 int);
insert into hj_t1 values(1,1),(2,2);
insert into hj_t2 values(1,1),(2,2);
insert into hj_t3 values(1);
commit;

explain select t1.* from (
    select T0.* FROM (
        SELECT t1.f1, t2.f2 from hj_t1 t1, hj_t2 t2 where t1.f1=t2.f1
    )   T0 WHERE t0.f1 in (select f1 from hj_t3)
)t1;
select t1.* from (
    select T0.* FROM (
        SELECT t1.f1, t2.f2 from hj_t1 t1, hj_t2 t2 where t1.f1=t2.f1
    )   T0 WHERE t0.f1 in (select f1 from hj_t3)
)t1;
drop table if exists hj_t1;
drop table if exists hj_t2;
drop table if exists hj_t3;

drop table if exists oss_t1;
drop table if exists oss_t2;
create table oss_t1(id int not null, k int, c varchar(20), pad varchar(200));
create table oss_t2(groupid int not null, resid int, staff varchar(200));
create unique index oss_t1_pk on oss_t1(id);
create unique index oss_t2_pk on oss_t2(groupid, resid);
create index oss_t2_idx on oss_t2(resid);
explain select * from oss_t1 where id in (select resid from oss_t2 where groupid in (1,2,3,4,5,6,7,8,9,10) and staff='abc');
explain select * from oss_t1 where id in (select resid from oss_t2 where groupid in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20) and staff = 'abc');
explain select * from oss_t1 where id in (select resid from oss_t2 where groupid in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,38,40) and staff='abc');

DROP INDEX oss_t2_idx on oss_t2;
explain select * from oss_t1 where id in (select resid from oss_t2 where groupid in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,38,40) and staff='abc');
drop table if exists oss_t1;
drop table if exists oss_t2;



drop table if exists test_hash_join;
create table test_hash_join(id int, grantor int);
insert into test_hash_join values(0,0);
insert into test_hash_join values(2,2);
insert into test_hash_join values(3,3);
insert into test_hash_join values(4,4);

insert into test_hash_join values(5,5);
insert into test_hash_join values(6,6);
insert into test_hash_join values(7,7);
insert into test_hash_join values(8,8);
insert into test_hash_join values(9,9);
commit;

explain select  
  74 as c15
from 
  (((((((test_hash_join as ref_10)
                inner join ((test_hash_join as ref_11)
                  inner join (test_hash_join as ref_12)
                  on (false))
                on (((false) 
                      or (false)) 
                    or (ref_10.GRANTOR is not NULL)))
              inner join ((test_hash_join as ref_13)
                left join (test_hash_join as ref_14)
                on (true))
              on (true))
            inner join ((test_hash_join as ref_15)
              right join ((test_hash_join as ref_16)
                left join (test_hash_join as ref_17)
                on (ref_16.ID = ref_17.ID ))
              on (false))
            on (((ref_11.GRANTOR is NULL) 
                  or (((ref_15.ID is NULL)) 
                    and (true)))))
          inner join (((((test_hash_join as ref_19)
                  right join (test_hash_join as ref_20)
                  on (ref_19.ID = ref_20.ID ))
                inner join (test_hash_join as ref_21)
                on (ref_19.GRANTOR is not NULL))
              left join (test_hash_join as ref_22)
              on ((true) 
                  or ((false) 
                    and (false))))
            left join (test_hash_join as ref_23)
            on ((select ID from test_hash_join limit 1 offset 1)
                   is not NULL))
          on (ref_16.ID = ref_20.ID ))
        ));
		
select  
  74 as c15
from 
  (((((((test_hash_join as ref_10)
                inner join ((test_hash_join as ref_11)
                  inner join (test_hash_join as ref_12)
                  on (false))
                on (((false) 
                      or (false)) 
                    or (ref_10.GRANTOR is not NULL)))
              inner join ((test_hash_join as ref_13)
                left join (test_hash_join as ref_14)
                on (true))
              on (true))
            inner join ((test_hash_join as ref_15)
              right join ((test_hash_join as ref_16)
                left join (test_hash_join as ref_17)
                on (ref_16.ID = ref_17.ID ))
              on (false))
            on (((ref_11.GRANTOR is NULL) 
                  or (((ref_15.ID is NULL)) 
                    and (true)))))
          inner join (((((test_hash_join as ref_19)
                  right join (test_hash_join as ref_20)
                  on (ref_19.ID = ref_20.ID ))
                inner join (test_hash_join as ref_21)
                on (ref_19.GRANTOR is not NULL))
              left join (test_hash_join as ref_22)
              on ((true) 
                  or ((false) 
                    and (false))))
            left join (test_hash_join as ref_23)
            on ((select ID from test_hash_join limit 1 offset 1)
                   is not NULL))
          on (ref_16.ID = ref_20.ID ))
        ));
	
explain select  
  subq_0.c0 as c0, 
  ref_23.GRANTOR as c1, 
  subq_2.c2 as c3, 
  13 as c4
from 
  ((((test_hash_join as ref_0)
          left join ((select  
                ref_1.GRANTOR as c0
              from 
                test_hash_join as ref_1
              limit 80) as subq_0)
          on (ref_0.ID = subq_0.c0 ))
        right join ((test_hash_join as ref_9)
                inner join ((test_hash_join as ref_10))
                on false)
        on ((ref_10.GRANTOR is not NULL) 
            and (EXISTS (
              select  
                  subq_0.c0 as c0
                from 
                  test_hash_join as ref_15
                where ((ref_9.GRANTOR is NULL)) 
                  or (ref_10.GRANTOR is not NULL)
                limit 53))))
      inner join ((select  
            1
          from 
            test_hash_join as ref_16) as subq_1)
      on false)
    inner join (((select   
            ref_17.GRANTOR as c2, 
            ref_17.GRANTOR as c3
          from 
            test_hash_join as ref_17
          where (false) 
          limit 175) as subq_2)
      inner join (((((test_hash_join as ref_23)
              left join (test_hash_join as ref_24)
              on (((ref_23.ID is NULL) or (ref_23.ID is not NULL) ) or (true)))
            inner join (test_hash_join as ref_26)
            on ( (70 is not NULL)))
          left join (test_hash_join as ref_29)
          on (true))
        inner join (((test_hash_join as ref_30)
            right join (test_hash_join as ref_31)
            on (ref_30.GRANTOR is NULL))
          )
        on ((ref_29.GRANTOR is not NULL) 
            or (( (EXISTS (
                  select  
                      ref_31.GRANTOR as c0
                    from 
                      SYS_AUDIT as ref_43
                    where false))))))
      on (subq_2.c3 = ref_26.id ))
    on ((subq_2.c3 is NULL 
                    or ref_23.GRANTOR is NULL) 
          or (subq_2.c3 is not NULL))
limit 88;

select  
  subq_0.c0 as c0, 
  ref_23.GRANTOR as c1, 
  subq_2.c2 as c3, 
  13 as c4
from 
  ((((test_hash_join as ref_0)
          left join ((select  
                ref_1.GRANTOR as c0
              from 
                test_hash_join as ref_1
              limit 80) as subq_0)
          on (ref_0.ID = subq_0.c0 ))
        right join ((test_hash_join as ref_9)
                inner join ((test_hash_join as ref_10))
                on false)
        on ((ref_10.GRANTOR is not NULL) 
            and (EXISTS (
              select  
                  subq_0.c0 as c0
                from 
                  test_hash_join as ref_15
                where ((ref_9.GRANTOR is NULL)) 
                  or (ref_10.GRANTOR is not NULL)
                limit 53))))
      inner join ((select  
            1
          from 
            test_hash_join as ref_16) as subq_1)
      on false)
    inner join (((select   
            ref_17.GRANTOR as c2, 
            ref_17.GRANTOR as c3
          from 
            test_hash_join as ref_17
          where (false) 
          limit 175) as subq_2)
      inner join (((((test_hash_join as ref_23)
              left join (test_hash_join as ref_24)
              on (((ref_23.ID is NULL) or (ref_23.ID is not NULL) ) or (true)))
            inner join (test_hash_join as ref_26)
            on ( (70 is not NULL)))
          left join (test_hash_join as ref_29)
          on (true))
        inner join (((test_hash_join as ref_30)
            right join (test_hash_join as ref_31)
            on (ref_30.GRANTOR is NULL))
          )
        on ((ref_29.GRANTOR is not NULL) 
            or (( (EXISTS (
                  select  
                      ref_31.GRANTOR as c0
                    from 
                      SYS_AUDIT as ref_43
                    where false))))))
      on (subq_2.c3 = ref_26.id ))
    on ((subq_2.c3 is NULL 
                    or ref_23.GRANTOR is NULL) 
          or (subq_2.c3 is not NULL))
limit 88;

select   
  count(*)
from 
  ((test_hash_join as ref_0)
      inner join (((select 
              ref_1.ID as c1
            from 
              test_hash_join as ref_1
            limit 171) as subq_0)
        right join (((test_hash_join as ref_2)
            left join (test_hash_join as ref_3)
            on false)
          inner join (select  
                ref_5.GRANTOR as c0, 
                ref_4.GRANTOR as c1
              from 
                (test_hash_join as ref_4)
                  left join (test_hash_join as ref_5)
                  on (ref_4.ID = ref_5.ID))
          on (75 is not NULL))
        on (subq_0.c1 = ref_3.ID ))
      on subq_0.c1 is NULL)
where ((ref_3.ID is NULL)
    or (subq_0.c1 is not NULL));
	
select   
  count(*)
from 
  ((test_hash_join as ref_0)
      inner join (((select 
              ref_1.ID as c1
            from 
              test_hash_join as ref_1
            limit 171) as subq_0)
        full join (((test_hash_join as ref_2)
            left join (test_hash_join as ref_3)
            on false)
          inner join (select  
                ref_5.GRANTOR as c0, 
                ref_4.GRANTOR as c1
              from 
                (test_hash_join as ref_4)
                  left join (test_hash_join as ref_5)
                  on (ref_4.ID = ref_5.ID))
          on (75 is not NULL))
        on (subq_0.c1 = ref_3.ID ))
      on subq_0.c1 is NULL)
where ((ref_3.ID is NULL)
    or (subq_0.c1 is not NULL));
drop table if exists test_hash_join;

--    NL -T4.OWNER IS NULL
--   /  \
--  T1 NLFULL
--     /    \
--   HJ(L)  NL
--   / \   / \
--  T2 T4 T5 T6
-- Cannot match condition (T4.OWNER IS NULL) while fetching from T5, if T2 is EOF.
SELECT 1
FROM
  ((SYS.SYS_PART_OBJECTS AS T1))
    CROSS JOIN (((SYS.MY_SUBPART_KEY_COLUMNS AS T2)
        INNER JOIN ((SYS.DB_VIEW_DEPENDENCIES AS T4))
        ON (T2.COLUMN_NAME = T4.OWNER ))
      FULL OUTER JOIN (((SYS.MY_TAB_MODIFICATIONS AS T5)
          CROSS JOIN (SYS.ADM_ARGUMENTS AS T6)))
      ON (true))
WHERE T4.OWNER IS NULL limit 1;

--hash_cursor is null while fetching hash join
DROP TABLE IF EXISTS "SK_MY_EMPLOYEES" ;
CREATE TABLE "SK_MY_EMPLOYEES"
(
  "ID" BINARY_INTEGER,
  "DD" CLOB,
  "FLAG" CHAR(1 BYTE),
  "BB" BOOLEAN,
  "DBL" BINARY_DOUBLE
);
INSERT INTO "SK_MY_EMPLOYEES" ("ID","DD","FLAG","BB","DBL") values (0,'dddddddddddddddddddddddd','m',TRUE,301415902);
INSERT INTO "SK_MY_EMPLOYEES" ("ID","DD","FLAG","BB","DBL") values (111,'ssssssssssssssssssssss','f',FALSE,0.1415902);
COMMIT;
DROP TABLE IF EXISTS "SK_STATES" ;
CREATE TABLE "SK_STATES"
(
  "STATE_ID" CHAR(2 BYTE) NOT NULL,
  "STATE_NAME" VARCHAR(40 BYTE),
  "AREA_ID" NUMBER
);
INSERT INTO "SK_STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('AR','Argentina',2);
INSERT INTO "SK_STATES" ("STATE_ID","STATE_NAME","AREA_ID") values
  ('AU','Australia',3);
COMMIT;
ALTER TABLE "SK_STATES" ADD CONSTRAINT "SK_STATE_C_ID_PK" PRIMARY KEY("STATE_ID");

DROP TABLE IF EXISTS "SK_STAFFS" ;
CREATE TABLE "SK_STAFFS"
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
);
INSERT INTO "SK_STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values (198,'Donald','OConnell','DOCONNEL','650.507.9833','1999-06-21 00:00:00','SH_CLERK',2600,null,124,50,null);
INSERT INTO "SK_STAFFS" ("STAFF_ID","FIRST_NAME","LAST_NAME","EMAIL","PHONE_NUMBER","HIRE_DATE","EMPLOYMENT_ID","SALARY","COMMISSION_PCT","MANAGER_ID","SECTION_ID","GRADUATED_NAME") values (199,'Douglas','Grant','DGRANT','650.507.9844','2000-01-13 00:00:00','SH_CLERK',2600,null,124,50,null);
COMMIT;

DROP TABLE IF EXISTS "SK_SCORE" ;
CREATE TABLE "SK_SCORE"
(
  "ID" BINARY_INTEGER NOT NULL,
  "STU_ID" BINARY_INTEGER NOT NULL,
  "C_NAME" VARCHAR(50 BYTE),
  "GRADE" BINARY_INTEGER
);
INSERT INTO "SK_SCORE" ("ID","STU_ID","C_NAME","GRADE") values (1,901,'计算机',98);
INSERT INTO "SK_SCORE" ("ID","STU_ID","C_NAME","GRADE") values (2,901,'英语',80);
COMMIT;
ALTER TABLE "SK_SCORE" ADD CONSTRAINT "SK_SCORE_ID_PK" PRIMARY KEY("ID");

DROP TABLE IF EXISTS "SK_FVT_OBJ_DEFINE_TABLE_FRE1" ;
CREATE TABLE "SK_FVT_OBJ_DEFINE_TABLE_FRE1"
(
  "COL_3" BOOLEAN,
  "COL_6" BINARY_INTEGER,
  "COL_13" BOOLEAN,
  "COL_14" BOOLEAN,
  "COL_49" BOOLEAN,
  "COL_119" BOOLEAN,
  "COL_182" DATE
);

SELECT
  ref_0.DD AS C10
FROM
  (SK_MY_EMPLOYEES AS ref_0)
    CROSS JOIN ((SK_STATES AS ref_1)
      FULL JOIN ((((SK_STAFFS AS ref_7)
            INNER JOIN (SK_SCORE AS ref_10)
            ON ((SELECT COL_3 FROM SK_FVT_OBJ_DEFINE_TABLE_FRE1 LIMIT 1)
                   < (SELECT COL_3 FROM SK_FVT_OBJ_DEFINE_TABLE_FRE1 LIMIT 1 OFFSET 6)))
          INNER JOIN (SK_FVT_OBJ_DEFINE_TABLE_FRE1 AS ref_11)
          ON (ref_10.STU_ID = ref_11.COL_6 )))
      ON (ref_11.COL_119 >= ref_11.COL_49))
WHERE ref_11.COL_3 >= ref_0.BB;

SELECT
  ref_0.DD AS C10
FROM
  ((SK_MY_EMPLOYEES AS ref_0)
        FULL OUTER JOIN ((SK_FVT_OBJ_DEFINE_TABLE_FRE1 AS ref_1)
          CROSS JOIN ((SK_STAFFS AS ref_2)
            INNER JOIN ((SK_SCORE AS ref_3)
              LEFT JOIN (SK_STATES AS ref_4)
              ON (ref_3.STU_ID = ref_4.AREA_ID ))
            ON (ref_3.ID <> ref_3.ID)))
        ON (ref_1.COL_3 >= ref_1.COL_3))
      INNER JOIN ((SELECT
              *
            FROM
              SK_STATES AS ref_5
            LIMIT 136) AS subq_0)
      ON (subq_0.STATE_ID <= ref_1.COL_119)
;

SELECT
  ref_0.DD AS C10
FROM
  ((SK_MY_EMPLOYEES AS ref_0)
        FULL OUTER JOIN ((SK_FVT_OBJ_DEFINE_TABLE_FRE1 AS ref_1)
          CROSS JOIN ((SK_STAFFS AS ref_2)
            INNER JOIN ((SK_SCORE AS ref_3)
              FULL OUTER JOIN (SK_STATES AS ref_4)
              ON (ref_3.STU_ID = ref_4.AREA_ID))
            ON (true)))
        ON (ref_1.COL_3 >= ref_1.COL_3))
      INNER JOIN ((SELECT
              *
            FROM
              SK_STATES AS ref_5
            LIMIT 136) AS subq_0)
      ON (subq_0.STATE_ID <= ref_1.COL_119)
;
--DTS2020101004TWWHP0K00
DROP TABLE IF EXISTS "SK_PLACES" CASCADE CONSTRAINTS;
CREATE TABLE "SK_PLACES"
(
  "PLACE_ID" NUMBER(4) NOT NULL,
  "STREET_ADDRESS" VARCHAR(40 BYTE),
  "POSTAL_CODE" VARCHAR(12 BYTE),
  "CITY" VARCHAR(30 BYTE),
  "STATE_PROVINCE" VARCHAR(25 BYTE),
  "STATE_ID" CHAR(2 BYTE)
);
INSERT INTO "SK_PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values (1000,'1297 Via Cola di Rie','00989','Roma',null,'IT');
INSERT INTO "SK_PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values (1100,'93091 Calle della Testa','10934','Venice',null,'IT');
INSERT INTO "SK_PLACES" ("PLACE_ID","STREET_ADDRESS","POSTAL_CODE","CITY","STATE_PROVINCE","STATE_ID") values (1200,'2017 Shinjuku-ku','1689','Tokyo','Tokyo Prefecture','JP');

DROP TABLE IF EXISTS "SK_COLLEGE" CASCADE CONSTRAINTS;
CREATE TABLE "SK_COLLEGE"
(
  "SK_COLLEGE_ID" NUMBER,
  "SK_COLLEGE_NAME" VARCHAR(40 BYTE)
);
INSERT INTO "SK_COLLEGE" ("SK_COLLEGE_ID","SK_COLLEGE_NAME") values (1001,'The University of Melbourne');
INSERT INTO "SK_COLLEGE" ("SK_COLLEGE_ID","SK_COLLEGE_NAME") values (1002,'Duke University');
INSERT INTO "SK_COLLEGE" ("SK_COLLEGE_ID","SK_COLLEGE_NAME") values(1003,'New York University');

DROP TABLE IF EXISTS "SK_SECTIONS" CASCADE CONSTRAINTS;
CREATE TABLE "SK_SECTIONS"
(
  "SECTION_ID" NUMBER(4) NOT NULL,
  "SECTION_NAME" VARCHAR(30 BYTE),
  "MANAGER_ID" NUMBER(6),
  "PLACE_ID" NUMBER(4)
);
INSERT INTO "SK_SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values (10,'Administration',200,1700);
INSERT INTO "SK_SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values (20,'Marketing',201,1800);
INSERT INTO "SK_SECTIONS" ("SECTION_ID","SECTION_NAME","MANAGER_ID","PLACE_ID") values (30,'Purchasing',114,1700);

DROP TABLE IF EXISTS "SK_DEPT_MANAGER" CASCADE CONSTRAINTS;
CREATE TABLE "SK_DEPT_MANAGER"
(
  "EMP_NO" BINARY_INTEGER NOT NULL,
  "DEPT_NO" CHAR(30 BYTE) NOT NULL,
  "FROM_DATE" DATE NOT NULL,
  "TO_DATE" DATE NOT NULL
);
INSERT INTO "SK_DEPT_MANAGER" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10017,'d001                          ','1985-01-01 00:00:00','1991-10-01 00:00:00');
INSERT INTO "SK_DEPT_MANAGER" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10020,'d002                          ','1991-10-01 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SK_DEPT_MANAGER" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10013,'d003                          ','1985-01-01 00:00:00','1989-12-17 00:00:00');
COMMIT;
ALTER TABLE "SK_DEPT_MANAGER" ADD CONSTRAINT "SK_DEPT_MANAGER_PK" PRIMARY KEY("EMP_NO", "DEPT_NO");

SELECT
  1
FROM
  (SK_FVT_OBJ_DEFINE_TABLE_FRE1 AS ref_3)
    RIGHT OUTER JOIN (((SK_PLACES AS ref_6)
        FULL OUTER JOIN (SK_COLLEGE AS ref_7)
        ON (ref_6.STREET_ADDRESS = ref_7.SK_COLLEGE_NAME ))
      INNER JOIN (((SK_DEPT_MANAGER AS ref_9))
        FULL JOIN ((SELECT
              ref_14.COL_49 AS C0
            FROM
			(SK_FVT_OBJ_DEFINE_TABLE_FRE1 AS ref_14)
            WHERE ref_14.COL_3 <= ref_14.COL_14) AS subq_2)
        ON (false))
      ON (NOT EXISTS (
          SELECT
              ref_6.CITY AS C0
            FROM
              SK_SECTIONS AS ref_15
            WHERE (subq_2.C0 < subq_2.C0))))
    ON (ref_3.COL_182 = ref_9.FROM_DATE )
WHERE CAST(nullif(subq_2.C0, ref_3.COL_13) AS BOOLEAN) >= ref_3.COL_14;

drop table if exists SK_TBL_RANGE26;
CREATE TABLE SK_TBL_RANGE26(
id BINARY_INTEGER not null,
c_double double,
c_varchar2 varchar2(100) default 1,
c_timestamp_zone timestamp with time zone,
c_yeartomonth interval year to month,
c_bool bool
);
SELECT
  1
FROM
  ((((((( SK_TBL_RANGE26 AS ref_0)
                CROSS JOIN ( SK_TBL_RANGE26 AS ref_1))
              FULL JOIN ( SK_TBL_RANGE26 AS ref_2)
              ON (ref_0.ID = ref_2.ID ))
            CROSS JOIN ( SK_DEPT_MANAGER AS ref_3))
          FULL JOIN ( SK_COLLEGE AS ref_4)
          ON (ref_1.C_BOOL > ref_0.C_BOOL)))
      INNER JOIN (( SK_TBL_RANGE26 AS ref_10))
      ON (ref_3.EMP_NO = ref_10.ID ))
    LEFT OUTER JOIN ((SK_SECTIONS AS ref_11)
      FULL OUTER JOIN (((( SK_SECTIONS AS ref_12)
            RIGHT JOIN (( SK_TBL_RANGE26 AS ref_15))
            ON (ref_12.SECTION_ID = ref_15.ID ))
          CROSS JOIN (((( SK_TBL_RANGE26 AS ref_16)
                FULL JOIN ( SK_PLACES AS ref_17)
                ON (ref_16.C_VARCHAR2 IS NULL))
              FULL OUTER JOIN (( SK_TBL_RANGE26 AS ref_18)
                LEFT OUTER JOIN ( SK_TBL_RANGE26 AS ref_19)
                ON (ref_19.C_DOUBLE IS NOT NULL))
              ON (ref_16.C_YEARTOMONTH = ref_18.C_YEARTOMONTH ))
            LEFT JOIN ( SK_TBL_RANGE26 AS ref_20)
            ON (true)))
        LEFT JOIN ( SK_TBL_RANGE26 AS ref_21)
        ON (true))
      ON (ref_15.C_BOOL >= ref_20.C_BOOL))
    ON ((true)
        OR ((ref_19.C_TIMESTAMP_ZONE IS NULL)
          AND (ref_0.C_BOOL >= ref_15.C_BOOL)))
WHERE ref_16.C_BOOL >= ref_1.C_BOOL;
SELECT
  1
FROM
  ((((((( SK_TBL_RANGE26 AS ref_0)
                CROSS JOIN ( SK_TBL_RANGE26 AS ref_1))
              FULL JOIN ( SK_TBL_RANGE26 AS ref_2)
              ON (ref_0.ID = ref_2.ID ))
            CROSS JOIN ( SK_DEPT_MANAGER AS ref_3))
          FULL JOIN ( SK_COLLEGE AS ref_4)
          ON (ref_1.C_BOOL > ref_0.C_BOOL)))
      INNER JOIN (( SK_TBL_RANGE26 AS ref_10))
      ON (ref_3.EMP_NO = ref_10.ID ))
    LEFT OUTER JOIN ((SK_SECTIONS AS ref_11)
      FULL OUTER JOIN (((( SK_SECTIONS AS ref_12)
            INNER JOIN (( SK_TBL_RANGE26 AS ref_15))
            ON (ref_12.SECTION_ID = ref_15.ID ))
          CROSS JOIN (((( SK_TBL_RANGE26 AS ref_16)
                FULL JOIN ( SK_PLACES AS ref_17)
                ON (ref_16.C_VARCHAR2 IS NULL))
              FULL OUTER JOIN (( SK_TBL_RANGE26 AS ref_18)
                LEFT OUTER JOIN ( SK_TBL_RANGE26 AS ref_19)
                ON (ref_19.C_DOUBLE IS NOT NULL))
              ON (ref_16.C_YEARTOMONTH = ref_18.C_YEARTOMONTH ))
            LEFT JOIN ( SK_TBL_RANGE26 AS ref_20)
            ON (true)))
        LEFT JOIN ( SK_TBL_RANGE26 AS ref_21)
        ON (true))
      ON (ref_15.C_BOOL >= ref_20.C_BOOL))
    ON ((true)
        OR ((ref_19.C_TIMESTAMP_ZONE IS NULL)
          AND (ref_0.C_BOOL >= ref_15.C_BOOL)))
WHERE ref_16.C_BOOL >= ref_1.C_BOOL;
--20201016
drop table if exists tbl_sqlkiller_39_2;
drop table if exists tbl_sqlkiller_39_6;
drop table if exists tbl_subpartition_range2_34;
drop table if exists tbl_subpartition_range2_15;
drop table if exists tbl_sqlkiller_45;
drop table if exists FVT_OBJ_DEFINE_TABLE_FRE1;
CREATE TABLE "FVT_OBJ_DEFINE_TABLE_FRE1"
(
  "COL_1" BINARY_BIGINT,  "COL_2" TIMESTAMP(6),  "COL_3" BOOLEAN,  "COL_4" NUMBER,  "COL_5" CLOB,  "COL_6" BINARY_INTEGER,  "COL_7" CHAR(30 BYTE),
  "COL_8" BINARY_DOUBLE,  "COL_9" CLOB,  "COL_10" CLOB,  "COL_11" VARCHAR(30 BYTE),  "COL_12" BINARY_DOUBLE,  "COL_13" BOOLEAN,  "COL_14" BOOLEAN,
  "COL_15" BLOB,  "COL_16" BINARY_DOUBLE,  "COL_17" VARCHAR(30 BYTE),  "COL_18" VARCHAR(30 BYTE),  "COL_19" TIMESTAMP(6) WITH TIME ZONE,  "COL_20" CHAR(30 BYTE),
  "COL_21" BLOB,  "COL_22" NUMBER,  "COL_23" BLOB,  "COL_24" CHAR(30 BYTE),  "COL_25" BINARY_INTEGER,
  "COL_26" BINARY_DOUBLE,  "COL_27" NUMBER,  "COL_28" NUMBER,  "COL_29" BINARY_INTEGER,  "COL_30" BLOB,  "COL_31" BINARY_DOUBLE,  "COL_32" BLOB,  "COL_33" NUMBER,
  "COL_34" CHAR(30 BYTE),  "COL_35" BINARY_DOUBLE,  "COL_36" CHAR(30 BYTE),  "COL_37" NUMBER,  "COL_38" TIMESTAMP(6),  "COL_39" BINARY_BIGINT,  "COL_40" BINARY_DOUBLE,
  "COL_41" BLOB,  "COL_42" BINARY_INTEGER,  "COL_43" BINARY_DOUBLE,  "COL_44" BINARY_INTEGER,  "COL_45" TIMESTAMP(6),  "COL_46" CLOB,  "COL_47" CHAR(30 BYTE),  "COL_48" NUMBER,
  "COL_49" BOOLEAN,  "COL_50" BINARY_INTEGER,  "COL_51" TIMESTAMP(6) WITH TIME ZONE,  "COL_52" BLOB,  "COL_53" BINARY_INTEGER,  "COL_54" BINARY_INTEGER,  "COL_55" NUMBER,
  "COL_56" BINARY_INTEGER,  "COL_57" BLOB,  "COL_58" TIMESTAMP(6) WITH TIME ZONE,  "COL_59" NUMBER,  "COL_60" BINARY_DOUBLE,  "COL_61" INTERVAL DAY(2) TO SECOND(6),
  "COL_62" BINARY_DOUBLE,  "COL_63" CLOB,  "COL_64" TIMESTAMP(6) WITH TIME ZONE,  "COL_65" TIMESTAMP(6) WITH TIME ZONE,  "COL_66" VARCHAR(30 BYTE),  "COL_67" BOOLEAN,
  "COL_68" CHAR(30 CHAR),  "COL_69" BINARY_DOUBLE,  "COL_70" BINARY_DOUBLE,  "COL_71" CHAR(30 BYTE),  "COL_72" VARCHAR(30 BYTE),  "COL_73" BINARY_INTEGER,  "COL_74" BINARY_BIGINT,
  "COL_75" BINARY_INTEGER,  "COL_76" CHAR(100 CHAR),  "COL_77" TIMESTAMP(6) WITH TIME ZONE,  "COL_78" NUMBER,  "COL_79" VARCHAR(30 BYTE),  "COL_80" CHAR(30 BYTE),  "COL_81" BLOB,
  "COL_82" CLOB,  "COL_83" NUMBER,  "COL_84" BINARY_DOUBLE,  "COL_85" BINARY_INTEGER,  "COL_86" CHAR(30 BYTE),  "COL_87" TIMESTAMP(6) WITH TIME ZONE,  "COL_88" NUMBER,  "COL_89" BINARY_BIGINT,
  "COL_90" BLOB,  "COL_91" BLOB,  "COL_92" BINARY_DOUBLE,  "COL_93" BINARY_DOUBLE,  "COL_94" BINARY_INTEGER,  "COL_95" CHAR(30 BYTE),  "COL_96" BINARY_BIGINT,  "COL_97" BINARY_DOUBLE,
  "COL_98" BINARY_INTEGER,  "COL_99" CHAR(30 BYTE),  "COL_100" VARCHAR(30 BYTE),  "COL_101" BINARY_BIGINT,  "COL_102" CLOB,  "COL_103" TIMESTAMP(6) WITH LOCAL TIME ZONE,  "COL_104" TIMESTAMP(6),
  "COL_105" NUMBER,  "COL_106" NUMBER,  "COL_107" NUMBER,  "COL_108" IMAGE,  "COL_109" BOOLEAN,  "COL_110" BINARY_DOUBLE,  "COL_111" CHAR(30 BYTE),  "COL_112" VARCHAR(30 BYTE),
  "COL_113" NUMBER,  "COL_114" BINARY_INTEGER,  "COL_115" VARCHAR(30 BYTE),  "COL_116" NUMBER,  "COL_117" BINARY_BIGINT,  "COL_118" INTERVAL YEAR(2) TO MONTH,  "COL_119" BOOLEAN,  "COL_120" NUMBER,
  "COL_121" BLOB,  "COL_122" BINARY_DOUBLE,  "COL_123" BINARY_DOUBLE,  "COL_124" BINARY_INTEGER,  "COL_125" BINARY_INTEGER,  "COL_126" BINARY_INTEGER,  "COL_127" TIMESTAMP(6),  "COL_128" BINARY_INTEGER,
  "COL_129" TIMESTAMP(6) WITH TIME ZONE,  "COL_130" CHAR(30 BYTE),  "COL_131" BLOB,  "COL_132" CHAR(30 BYTE),  "COL_133" BINARY_BIGINT,  "COL_134" TIMESTAMP(6) WITH TIME ZONE,  "COL_135" BINARY_INTEGER,
  "COL_136" NUMBER,  "COL_137" NUMBER,  "COL_138" INTERVAL YEAR(2) TO MONTH,  "COL_139" BLOB,  "COL_140" CHAR(30 BYTE),  "COL_141" NUMBER,  "COL_142" BINARY_DOUBLE,  "COL_143" BINARY_DOUBLE,
  "COL_144" CLOB,  "COL_145" BOOLEAN,  "COL_146" BINARY_INTEGER,  "COL_147" BINARY_BIGINT,  "COL_148" CHAR(30 BYTE),  "COL_149" VARCHAR(30 BYTE),  "COL_150" BLOB,  "COL_151" BINARY_DOUBLE,
  "COL_152" CHAR(30 BYTE),  "COL_153" BINARY_DOUBLE,  "COL_154" CLOB,  "COL_155" BINARY_BIGINT,  "COL_156" BINARY_INTEGER,  "COL_157" NUMBER,  "COL_158" INTERVAL YEAR(2) TO MONTH,  "COL_159" TIMESTAMP(6) WITH TIME ZONE,
  "COL_160" BLOB,  "COL_161" NUMBER,  "COL_162" BINARY_INTEGER,  "COL_163" RAW(100),  "COL_164" NUMBER(6, 2),  "COL_165" BINARY_INTEGER,  "COL_166" CLOB,  "COL_167" BINARY_DOUBLE,  "COL_168" NUMBER(6, 2),
  "COL_169" NUMBER(6, 2),  "COL_170" NUMBER(6, 2),  "COL_171" RAW(100),  "COL_172" BINARY_INTEGER,  "COL_173" CLOB,  "COL_174" VARCHAR(50 BYTE),  "COL_175" VARCHAR(30 BYTE),  "COL_176" BINARY_DOUBLE,
  "COL_177" TIMESTAMP(6) WITH TIME ZONE,  "COL_178" NUMBER(6, 2),  "COL_179" NUMBER(6, 2),  "COL_180" VARCHAR(100 CHAR),  "COL_181" NUMBER(6, 2),  "COL_182" DATE,  "COL_183" NUMBER(12, 6),
  "COL_184" NUMBER(6, 2),  "COL_185" VARCHAR(30 CHAR),  "COL_186" BINARY_INTEGER,  "COL_187" NUMBER(6, 2),  "COL_188" DATE,  "COL_189" DATE,  "COL_190" NUMBER(6, 2),  "COL_191" NUMBER(6, 2),
  "COL_192" VARCHAR(30 BYTE),  "COL_193" TIMESTAMP(6),  "COL_194" BINARY_DOUBLE,  "COL_195" IMAGE,  "COL_196" NUMBER(6, 2),  "COL_197" NUMBER(6, 2),  "COL_198" NUMBER(6, 2),  "COL_199" CLOB,
  "COL_200" VARCHAR(55 CHAR),  "COL_201" BINARY_DOUBLE,  "COL_202" INTERVAL DAY(2) TO SECOND(6),  "COL_203" NUMBER(6, 2),  "COL_204" VARCHAR(30 BYTE),  "COL_205" NUMBER(6, 2),  "COL_206" NUMBER(6, 2),
  "COL_207" VARCHAR(30 BYTE),  "COL_208" RAW(200),  "COL_209" NUMBER(6, 2),  "COL_210" NUMBER(6, 2),  "COL_211" BINARY_DOUBLE,  "COL_212" BINARY_DOUBLE,  "COL_213" NUMBER(6, 2),  "COL_214" VARCHAR(30 BYTE),
  "COL_215" CLOB,  "COL_216" BINARY_INTEGER,  "COL_217" NUMBER(6, 2),  "COL_218" NUMBER(6, 2),  "COL_219" CLOB,  "COL_220" VARCHAR(30 BYTE),  "COL_221" BINARY_INTEGER,  "COL_222" NUMBER(6, 2),
  "COL_223" TIMESTAMP(6),  "COL_224" VARCHAR(30 BYTE),  "COL_225" DATE,  "COL_226" NUMBER(16, 2),  "COL_227" VARCHAR(100 BYTE),  "COL_228" DATE,  "COL_229" CLOB,  "COL_230" NUMBER(12, 6),  "COL_231" DATE,
  "COL_232" NUMBER(6, 2),  "COL_233" BINARY_INTEGER,  "COL_234" DATE,  "COL_235" VARCHAR(200 CHAR),  "COL_236" NUMBER(6, 2),  "COL_237" CLOB,  "COL_238" VARCHAR(300 BYTE),  "COL_239" NUMBER(6, 2),
  "COL_240" CLOB,  "COL_241" VARCHAR(30 BYTE),  "COL_242" NUMBER(6, 2),  "COL_243" NUMBER(6, 2),  "COL_244" BINARY_DOUBLE,  "COL_245" VARCHAR(60 BYTE),  "COL_246" BINARY_INTEGER,  "COL_247" VARBINARY(200),
  "COL_248" VARCHAR(30 BYTE),  "COL_249" BINARY(200),  "COL_250" NUMBER(6, 2),  "COL_251" RAW(100),  "COL_252" BINARY_DOUBLE,  "COL_253" NUMBER(6, 2),  "COL_254" BINARY_DOUBLE,  "COL_255" DATE,  "COL_256" NUMBER(6, 2),
  "COL_257" BINARY_INTEGER,  "COL_258" NUMBER(6, 2),  "COL_259" BINARY(100),  "COL_260" RAW(100),  "COL_261" VARCHAR(60 BYTE),  "COL_262" VARCHAR(30 BYTE),  "COL_263" NUMBER(6, 2),  "COL_264" CLOB,
  "COL_265" NUMBER(6, 2),  "COL_266" CLOB,  "COL_267" VARCHAR(30 BYTE),  "COL_268" NUMBER(6, 2),  "COL_269" NUMBER(6, 2),  "COL_270" INTERVAL YEAR(2) TO MONTH,  "COL_271" VARCHAR(60 BYTE),  "COL_272" NUMBER(6, 2),
  "COL_273" NUMBER(6, 2),  "COL_274" DATE,  "COL_275" BINARY_DOUBLE
);
CREATE global TEMPORARY TABLE tbl_sqlkiller_45(
id BINARY_INTEGER primary key,
c_short short,c_int int default 0 on update 100,c_uint BINARY_UINT32,c_unsigned INTEGER UNSIGNED not null,
c_bigint BINARY_BIGINT,c_number number,c_decimal decimal,c_double BINARY_DOUBLE,c_real real,
c_varchar varchar(100) default 'varchar',c_char char(50) default 'char' on update '111goodesmen',c_varchar2 varchar2(120) default 1,
c_varchar1 varchar(100) default '{""key1"":""good""}',c_date date ,c_datetime datetime not null,
c_timestamp timestamp(4) default '2019-11-19 17:41:00',c_timestamp1 timestamp,c_timestamp_zone timestamp with time zone,
c_timestamp_localzone timestamp with local time zone,c_yeartomonth interval year to month,c_daytosecond interval day to second,
c_clob clob,c_blob blob,c_varbinary VARBINARY(100),c_binary BINARY(100) default '1000',c_raw raw(100),
c_bytea BYTEA,c_image image,c_bool boolean
);
CREATE TABLE tbl_subpartition_range2_15(
id BINARY_INTEGER not null,c_short short,c_uint uint,c_bigint bigint,c_number number,c_numeric numeric(20,10),
c_decimal decimal,c_double double,c_real real,c_varchar varchar(8000) default 'varchar',c_char char(1000) default 'char' on update '111goodesmen',
c_varchar2 varchar2(100) default 1,c_date datetime,c_timestamp timestamp default '2019-11-19 17:41:00',c_timestamp_zone timestamp with time zone,
c_timestamp_localzone timestamp with local time zone,c_yeartomonth interval year to month,c_daytosecond interval day(7) to second(6),
c_clob clob,c_blob blob,c_binary VARBINARY(8000),c_raw raw(200),c_image image,c_bool bool
)partition by range(c_bigint)
subpartition by range(c_char)
(partition p1 values less than(50000000)
(       subpartition p11 values less than (lpad('good',50,'cdf')), subpartition p12 values less than (lpad('good',50,'ffg')), subpartition p13 values less than (lpad('good',50,'jjh')), subpartition p14 values less than (lpad('good',50,'mng')),subpartition p15 values less than (lpad('good',50,'opd')), subpartition p16 values less than (maxvalue)
),partition p2 values less than(100000001)(  subpartition p21 values less than (lpad('good',50,'rrr')), subpartition p22 values less than (lpad('good',50,'tttkkk')), subpartition p23 values less than (maxvalue)));
CREATE TABLE tbl_subpartition_range2_34(
id BINARY_INTEGER not null,c_short short,c_int int default 0 on update 100,c_uint uint,
c_unsigned INTEGER UNSIGNED not null,c_bigint bigint,c_number number,c_numeric numeric(20,10),
c_decimal decimal,c_double double,c_real real,c_varchar varchar(8000) default 'varchar',
c_char char(1000) default 'char' on update '111goodesmen',c_varchar2 varchar2(100) default 1,
c_varchar1 varchar(1000) default '{""key1"":""good""}' check(c_varchar1 is json),
c_date date ,c_datetime datetime not null,c_timestamp timestamp(4) default '2019-11-19 17:41:00',
c_timestamp1 timestamp,c_timestamp_zone timestamp with time zone,c_timestamp_localzone timestamp with local time zone,
c_yeartomonth interval year to month,c_daytosecond interval day(7) to second(6),c_clob clob,
c_blob blob,c_varbinary VARBINARY(8000),c_binary BINARY(100) default '1000',c_raw raw(200),
c_bytea BYTEA,c_image image,c_bool bool
)partition by hash(c_bigint,c_decimal,c_raw) subpartition by list(c_short,c_varchar2,c_timestamp1)
(partition p1 (    subpartition p11 values ((1000,'gfgfhgffg','1990-10-10 12:30:23.5456')), subpartition p12 values ((2000,'jjjjjjjjjjjjj','1995-10-10 12:30:23.5456')),
 subpartition p13 values (default)),partition p2 (   
    subpartition p21 values((4000,'gfhthteghregreg','2000-10-10 12:30:23.5456'),(5000,'retregdgdvdv','2005-10-10 12:30:23.5456')),
 subpartition p22 values(default)
),partition p3  (       subpartition p31 values((6000,'regrehfbdf!@!333','2006-10-10 12:30:23.5456'),(7000,'@#&#^&$%#$','2007-10-10 12:30:23.5456')),
 subpartition p33 values(default)),
partition p4 (       subpartition p41 values((9000,88657454.6576576567,'2008-10-10 12:30:23.5456')), subpartition p42 values(default)));
create or replace procedure proc_create_table_39(tbl_name varchar,snum int,enum int)
is 
str varchar(8000);
str1 varchar(1000);
str2 clob;
str_sum clob;
begin
    str :='create table ' || tbl_name || '(';
for i in snum..enum loop
    str1 :='c_' || i || ' number(' || (i%20) || ',' || (i%10) || ')';
	str2 :=str2 || ',' || str1;
end loop;
    str_sum := str || substr(str2,2,length(str2)) || ')';
	str_sum := replace(str_sum,'number(0,0)','number');
	execute immediate str_sum ;
end;
/
exec proc_create_table_39('tbl_sqlkiller_39_2',441,840);
exec proc_create_table_39('tbl_sqlkiller_39_6',2001,2400);
SELECT  
  DECODE(
    CAST(CASE WHEN (          MIN(            CAST((SELECT MAX(C_DATE) FROM TBL_SUBPARTITION_RANGE2_34)               AS TIMESTAMP(6) WITH TIME ZONE)) over (partition by REF_0.C_2272 ORDER BY REF_0.C_2099,REF_0.C_2264) < CURRENT_TIMESTAMP()) 
        AND (FALSE) THEN         MIN(          CAST('m' AS VARCHAR(1))) over (partition by REF_0.C_2068,REF_0.C_2091 ORDER BY REF_0.C_2109) ELSE 
        MIN(          CAST('m' AS VARCHAR(1))) over (partition by REF_0.C_2068,REF_0.C_2091 ORDER BY REF_0.C_2109) END
       AS CHAR(100)),    CAST(CURRENT_TIMESTAMP() AS DATE),
    CAST(CASE WHEN EXISTS (        SELECT              REF_0.C_2104 AS C0          FROM             TBL_SQLKILLER_39_2 AS REF_1
          WHERE REF_1.C_585 IS NULL          LIMIT 151) THEN CAST(coalesce(NULL,
        NULL) AS VARCHAR(8000)) ELSE CAST(coalesce(NULL,
        NULL) AS VARCHAR(8000)) END
       AS VARCHAR(8000)),
    CAST((SELECT MAX(C_VARCHAR) FROM TBL_SUBPARTITION_RANGE2_15)
       AS VARCHAR(100))) AS C0, 
  CURRENT_TIMESTAMP() AS C1, 
  0 AS C2, 
  REF_0.C_2283 AS C3, 
  REF_0.C_2188 AS C4, 
  CURRENT_TIMESTAMP() AS C5
FROM 
  TBL_SQLKILLER_39_6 AS REF_0
WHERE CURRENT_TIMESTAMP() < (SELECT MIN(C_DATE) FROM TBL_SQLKILLER_45)
LIMIT 99;
SELECT  
  DECODE(
    CAST(CASE WHEN (          MIN(            CAST((SELECT MAX(C_DATE) FROM TBL_SUBPARTITION_RANGE2_34)               AS TIMESTAMP(6) WITH TIME ZONE)) over (partition by REF_0.C_2272 ORDER BY REF_0.C_2099,REF_0.C_2264) < SOME(
          (SELECT MAX(COL_2) FROM FVT_OBJ_DEFINE_TABLE_FRE1)            ))         AND (FALSE) THEN         MIN(          CAST('m' AS VARCHAR(1))) over (partition by REF_0.C_2068,REF_0.C_2091 ORDER BY REF_0.C_2109) ELSE 
        MIN(          CAST('m' AS VARCHAR(1))) over (partition by REF_0.C_2068,REF_0.C_2091 ORDER BY REF_0.C_2109) END       AS CHAR(100)),
    CAST(CURRENT_TIMESTAMP() AS DATE),
    CAST(CASE WHEN EXISTS (        SELECT              REF_0.C_2104 AS C0          FROM             TBL_SQLKILLER_39_2 AS REF_1          WHERE REF_1.C_585 IS NULL
          LIMIT 151) THEN CAST(coalesce(NULL,
        NULL) AS VARCHAR(8000)) ELSE CAST(coalesce(NULL,
        NULL) AS VARCHAR(8000)) END
       AS VARCHAR(8000)),
    CAST((SELECT MAX(C_VARCHAR) FROM TBL_SUBPARTITION_RANGE2_15)
       AS VARCHAR(100))) AS C0, 
  CURRENT_TIMESTAMP() AS C1, 
  0 AS C2, 
  REF_0.C_2283 AS C3, 
  REF_0.C_2188 AS C4, 
  CURRENT_TIMESTAMP() AS C5
FROM 
  TBL_SQLKILLER_39_6 AS REF_0
WHERE CURRENT_TIMESTAMP() < (SELECT MIN(C_DATE) FROM TBL_SQLKILLER_45)
LIMIT 99;
SELECT 1 FROM
  (SELECT
        REF_1.C_VARCHAR AS C0,
        REF_3.C_609 AS C1,
        REF_1.C_DATE AS C2,
        REF_0.C_DOUBLE AS C3
      FROM
        ((TBL_SUBPARTITION_RANGE2_15 AS REF_0)
            INNER JOIN (tbl_subpartition_range2_34 AS REF_1)
            ON (REF_1.C_VARCHAR1 < SOME(
                SELECT DISTINCT REF_2.C_CHAR AS C1 FROM
                    TBL_SUBPARTITION_RANGE2_15 AS REF_2
                  WHERE REF_1.C_BLOB IS NOT NULL)))
          INNER JOIN (TBL_SQLKILLER_39_2 AS REF_3)
          ON (REF_1.C_VARCHAR1 LIKE '%')
      WHERE (REF_3.C_547 = SOME(
          SELECT
              REF_3.C_455 AS C1
            FROM
              TBL_SUBPARTITION_RANGE2_34 AS REF_4
            WHERE REF_4.C_REAL IS NULL))
        AND (EXISTS (
          SELECT
              REF_0.C_TIMESTAMP_LOCALZONE AS C0,
              REF_1.C_BOOL AS C2
            FROM
              TBL_SQLKILLER_39_2 AS REF_5
            WHERE REF_0.C_VARCHAR2 LIKE '%'
            OFFSET 41))) AS SUBQ_0
WHERE SUBQ_0.C0 IS NOT NULL
LIMIT 47 OFFSET 93;

drop table if exists  t_subselect_dept_index;
drop table if exists  t_subselect_emp_index;
create table t_subselect_dept_index(
       deptno int,
       dname varchar(30),
       loc varchar(30),
	   mgr varchar(30)
);
create table t_subselect_emp_index(
       empno int,
       ename varchar(30),
       job varchar(30),
       mgr varchar(30),
       hiredate int,
       sal int,
       comm int,
       deptno int
);
create index t_subselect_emp_index_001 on t_subselect_emp_index(deptno);
explain plan for select a.deptno,a.dname,a.loc,b.job,b.sal
from t_subselect_dept_index a inner join t_subselect_emp_index b on a.deptno=b.deptno 
where ascii(b.sal) = (select ascii(min(c.sal)) from t_subselect_emp_index c inner join t_subselect_dept_index d on d.mgr=c.mgr  
                      where a.deptno=c.deptno and c.sal >=2000) order by a.deptno,a.dname,a.loc,b.job,b.sal;
drop table t_subselect_dept_index;
drop table t_subselect_emp_index;					  