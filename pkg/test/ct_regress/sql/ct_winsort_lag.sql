alter system set cbo = on;
drop table if exists t_aggr_lag_1;
create table t_aggr_lag_1(f0 int, f1 bigint, f2 double, f3 number(20,10), f4 date, f5 timestamp, f6 char(100), f7 varchar(100), f8 binary(100), f9 clob, f10 blob);

insert into t_aggr_lag_1(f0) values(10);
insert into t_aggr_lag_1(f0) values(10);
insert into t_aggr_lag_1(f0) values(5);
insert into t_aggr_lag_1(f0) values(5);
insert into t_aggr_lag_1(f0) values(20);
insert into t_aggr_lag_1(f0) values(20);
insert into t_aggr_lag_1(f0) values(15);
insert into t_aggr_lag_1(f0) values(15);
insert into t_aggr_lag_1(f0) values(15);
insert into t_aggr_lag_1(f0) values(5);
insert into t_aggr_lag_1(f0) values(10);
insert into t_aggr_lag_1(f0) values(20);
insert into t_aggr_lag_1(f0) values(null);
insert into t_aggr_lag_1(f0) values(null);
insert into t_aggr_lag_1(f0) values(null);
insert into t_aggr_lag_1(f0) values(1);
insert into t_aggr_lag_1(f0) values(1);
insert into t_aggr_lag_1(f0) values(1);
insert into t_aggr_lag_1(f1) values(2147483648);
insert into t_aggr_lag_1(f1) values(null);
insert into t_aggr_lag_1(f1) values(2147483650);
insert into t_aggr_lag_1(f2) values(null);
insert into t_aggr_lag_1(f3) values(null);
insert into t_aggr_lag_1(f4) values('2018-02-23 13:18:23');
insert into t_aggr_lag_1(f4) values(null);
insert into t_aggr_lag_1(f4) values('2018-02-23 13:18:25');
insert into t_aggr_lag_1(f4) values('2018-02-23 13:18:24');
insert into t_aggr_lag_1(f5) values('2018-02-23 13:18:23.345');
insert into t_aggr_lag_1(f5) values(null);
insert into t_aggr_lag_1(f5) values('2018-02-23 13:18:23.347');
insert into t_aggr_lag_1(f5) values('2018-02-23 13:18:23.346');
insert into t_aggr_lag_1(f6) values(null);
insert into t_aggr_lag_1(f6) values('a');
insert into t_aggr_lag_1(f6) values('a');
insert into t_aggr_lag_1(f6) values('b');
insert into t_aggr_lag_1(f6) values('b');
insert into t_aggr_lag_1(f6) values('c');
insert into t_aggr_lag_1(f6) values('c');
insert into t_aggr_lag_1(f6) values('aaaaa');
insert into t_aggr_lag_1(f6) values('bbbbb');
insert into t_aggr_lag_1(f6) values('ccccc');
insert into t_aggr_lag_1(f7) values('2018-02-23 13:18:23.345');
insert into t_aggr_lag_1(f7) values(null);
insert into t_aggr_lag_1(f7) values('2018-02-23 13:18:23.347');
insert into t_aggr_lag_1(f7) values('2018-02-23 13:18:23.346');
insert into t_aggr_lag_1(f8, f9, f10) values('1D', '222', '3133');
insert into t_aggr_lag_1(f8, f9, f10) values('1F', '222', '3323');
insert into t_aggr_lag_1(f8, f9, f10) values('1E', '222', '3333');
commit;


select  lag(f0,-1,0) over(order by f0) from t_aggr_lag_1;
select  lag(f0,0,0) over (order by f0) from t_aggr_lag_1;
select  lag(f0,1,0) over (order by f0) from t_aggr_lag_1;
select  lag(f0,2,0) over (order by f0) from t_aggr_lag_1;
select  lag(f0,3,0) over (order by f0) from t_aggr_lag_1;
select  lag(f0,30,0) over (order by f0) from t_aggr_lag_1;
select  lag(f0,30,'#') over (order by f0) from t_aggr_lag_1;
select  cume_dist() over(order by f0)||lag(f0,30,'#') over (order by f0) from t_aggr_lag_1;
select  lag(f0,30) over (order by f0) from t_aggr_lag_1;
select  lag(f0,30,NULL) over (order by f0) from t_aggr_lag_1;
select  lag(f6,1,'default') over (order by f6) from t_aggr_lag_1;
select  lag(f6,2,'default') over (order by f6) from t_aggr_lag_1;
select  lag(f6,3,'default') over (order by f6) from t_aggr_lag_1;
select  lag(f6,5,'default') over (order by f0) from t_aggr_lag_1;
select  lag(f6,6,'default') over (order by f6) from t_aggr_lag_1 order by f0, 1;
select  lag(f6,6,0) over (order by f6) from t_aggr_lag_1 order by f6;
select  lag(f6,null,'default') over (order by f6) from t_aggr_lag_1 order by f0;
select  lag(f6,'default') over (order by f6) from t_aggr_lag_1 order by f0;
select  lag(null,1) over (order by f6) from t_aggr_lag_1 order by f0;
select  lag(null,null) over (order by f6) from t_aggr_lag_1 order by f0;
select f0, f6 , lag(f0,2,0) over(order by f0), lag(f6,3,'default') over (order by f0) from t_aggr_lag_1;
select f0, f6 , lag(f0,2,0) over(order by f0), lag(f6,3,'default') over (order by f0) from t_aggr_lag_1;
select f0, f6 , lag(f5,1,f5) over(order by f0), lag(f7, 2, f7) over (order by f0) from t_aggr_lag_1;

update (select f0,f1,f2,f3 from t_aggr_lag_1) t set f0=2 where f0=10;

drop table if exists test_lag_func_001;
create table test_lag_func_001( 
COL_1 bigint, 
COL_2 TIMESTAMP WITHOUT TIME ZONE, 
COL_3 bool,
COL_4 decimal,
COL_5 text,
COL_6 smallint,
COL_7 char(30),
COL_8 double precision,
COL_9 longtext,
COL_10 character varying(30),
COL_11 bool ,
COL_12 bytea ,
COL_13 real ,
COL_14 numeric ,
COL_15 blob ,
COL_16 integer ,
COL_17 int ,
COL_18 TIMESTAMP WITH TIME ZONE ,
COL_19 binary_integer ,
COL_20 interval day to second ,
COL_21 boolean, 
COL_22 nchar(30),
COL_23 binary_bigint,
COL_24 nchar(100),
COL_25 character(1000), 
COL_26 text,
COL_27 float,
COL_28 double,
COL_29 bigint,
COL_30 TIMESTAMP WITH LOCAL TIME ZONE ,
COL_31 TIMESTAMP,
COL_32 image,
COL_33 interval year to month,
COL_34 character(30),
COL_35 smallint,
COL_36 blob,
COL_37 char(300),
COL_38 float,
COL_39 raw(100),
COL_40 clob ,
COL_41 binary_double,
COL_42 number(6,2),
COL_43 decimal(6,2),
COL_44 varchar2(50),
COL_45 varchar(30),
COL_46 nvarchar2(100),
COL_47 numeric(12,6),
COL_48 nvarchar(30),
COL_49 date,
COL_50 image ,
COL_51 integer,
COL_52 binary_double,
COL_53 decimal(12,6),
COL_54 raw(8000),
COL_55 clob,
COL_56 varchar2(8000),
COL_57 datetime,
COL_58 number(12,6),
COL_59 nvarchar2(4000),
COL_60 varbinary(2000) ,
COL_61 binary(200),
COL_62 datetime,
COL_63 binary(100),
COL_64 varchar(1000),
COL_65 date,
constraint pk_lag_fun_id primary key(COL_1)
);

drop sequence if exists V_lag_func_seq;
create sequence V_lag_func_seq increment by 1 start with 100000;

begin
	for i in 1..9000 loop
      insert into test_lag_func_001 values(
	  V_lag_func_seq.nextval,
	  TIMESTAMPADD(HOUR,i,'2019-01-03 14:14:12'),
	  true,
	  3.1415926+V_lag_func_seq.nextval,
	  'abc',
	  i,
	  'abc',
	  i+1.456789445455,
	  'abc',
	  'abc',
	  false,
	  '10',
	  3.1415926+V_lag_func_seq.nextval,
	  i/4,
	  '10',
	  i,
	  i,
	  TIMESTAMPADD(DAY,i,'2019-01-03 14:14:12'),
	  '1',
	  (INTERVAL '4 5:12:10.222' DAY TO SECOND(3)),
	  0,
	  'abc',
	  V_lag_func_seq.nextval,
	  'abc',
	  'abc',
	  'abc',
	  i/4,
	  V_lag_func_seq.nextval-99,
	  i*3.1415,
	  TIMESTAMPADD(MINUTE,i,'2019-01-03 14:14:12'),
	  to_timestamp('2019-01-03 14:58:54.000000','YYYY-MM-DD HH24:MI:SS.FFFFFF'),
	  'abc',
	  (INTERVAL '12' YEAR),
	  'abc',
	  i,
	  '10',
	  'abc',
	  i/2.15,
	  '0F',
	  'abc',
	  1.0E+100,
	  3.14+i,
	  i+445.255,
	  'abc',
	  'abc',
	  'abc',
	  125563.141592,
	  'abc',
	  TIMESTAMPADD(DAY,i,'2019-01-03 14:14:12'),
	  'abc',
	  V_lag_func_seq.nextval+2,
	  -1.79E+100,
	  98*0.99,
	  '10',
	  'abc',
	  'abc',
	  TIMESTAMPADD(SECOND,i,'2019-01-03 14:14:12'),
	  25563.1415,
	  'abc',
	  '10',
	  '10',
	  TIMESTAMPADD(MONTH,i/100,'2019-01-03 14:14:12'),
	  '010101111111100000000000000',
	  'abc',
	  TIMESTAMPADD(SECOND,i,'2019-01-03 15:19:00')
	  );
      commit;
    end loop;
end;
/

select COL_17,COL_63,lag(COL_63,8600,'1010101111111111111111111111111111111111111111') over (order by COL_17) from test_lag_func_001 order by COL_17,COL_63 limit 1 offset 8500;
alter system set cbo = off;
drop table t_aggr_lag_1;
drop sequence V_lag_func_seq;
drop table test_lag_func_001;

drop table if exists lead_t1;
create table lead_t1(a varchar(90), b int, c varchar(20) not null);
insert into lead_t1 values(1,11,'a1');
insert into lead_t1 values(2,12,'a4');
insert into lead_t1 values(3,13,'a7');
insert into lead_t1 values(null,14,'a10');
commit;

select a, b, lead(c,1,current_timestamp) over (order by a asc)  as "LEAD_LAG" from lead_t1 order by a asc, b desc;
select a, b, lead(c,1,a) over (order by a asc)  as "LEAD_LAG" from lead_t1 order by a asc, b desc;
select a, b, lead(c,1,'dsdddddddddddddddddddddd') over (order by a asc)  as "LEAD_LAG" from lead_t1 order by a asc, b desc;
select a, b, lead(c,case when a >0 then 1 else 2 end,null) over (order by a asc)  as "LEAD_LAG" from lead_t1 order by a asc, b desc;
select a, b, NVL(lead(c,1) over (order by a asc),0)  as "LEAD_LAG" from lead_t1 order by a asc, b desc;
drop table if exists lead_t1;

--default_expr_len DTS202107190G5W8AP1300
DROP TABLE if exists T_LEAD_OVER_DATA;
CREATE TABLE T_LEAD_OVER_DATA(
        ID INT,
        NAME VARCHAR(20),
        DEPT VARCHAR(20),
        LEADER_ID INT,
        SALARY INT,
        CREATE_DATE DATE,
        work_num decimal(10,2)
);
INSERT INTO T_LEAD_OVER_DATA VALUES (1,'AA4',5,999,1851,to_date('2019-10-15 10:18:12','YYYY-MM-DD HH24:mi:ss'),8346.96556923);
INSERT INTO T_LEAD_OVER_DATA VALUES (2,'AA6',6,333,3973,to_date('2007-08-11 10:18:12','YYYY-MM-DD HH24:mi:ss'),7790.93363579);
INSERT INTO T_LEAD_OVER_DATA VALUES (3,'AA9',8,777,0,to_date('2007-08-11 10:18:12','YYYY-MM-DD HH24:mi:ss'),NULL);
INSERT INTO T_LEAD_OVER_DATA VALUES (4,'AA9',5,888,NULL,to_date('2015-11-11 10:18:12','YYYY-MM-DD HH24:mi:ss'),0);
INSERT INTO T_LEAD_OVER_DATA VALUES (5,'AA8',9,555,NULL,to_date('2006-09-15 10:18:12','YYYY-MM-DD HH24:mi:ss'),8586.13426323);
INSERT INTO T_LEAD_OVER_DATA VALUES (6,'AA9',3,111,7771,to_date('2019-10-15 10:18:12','YYYY-MM-DD HH24:mi:ss'),4781.87355446);
INSERT INTO T_LEAD_OVER_DATA VALUES (7,'AA7',1,777,NULL,to_date('2018-05-15 10:18:12','YYYY-MM-DD HH24:mi:ss'),NULL);
INSERT INTO T_LEAD_OVER_DATA VALUES (8,'AA10',7,888,2308,to_date('2015-11-11 10:18:12','YYYY-MM-DD HH24:mi:ss'),NULL);
INSERT INTO T_LEAD_OVER_DATA VALUES (9,'AA1',3,555,0,to_date('2007-08-11 10:18:12','YYYY-MM-DD HH24:mi:ss'),NULL);
INSERT INTO T_LEAD_OVER_DATA VALUES (10,'AA9',10,444,3611,NULL,NULL);
INSERT INTO T_LEAD_OVER_DATA VALUES (11,'AA4',8,333,0,to_date('2015-11-25 10:18:12','YYYY-MM-DD HH24:mi:ss'),3197.3310937);
INSERT INTO T_LEAD_OVER_DATA VALUES (12,'AA7',5,333,NULL,to_date('2007-08-11 10:18:12','YYYY-MM-DD HH24:mi:ss'),4714.66120179);
INSERT INTO T_LEAD_OVER_DATA VALUES (13,'AA9',4,333,7756,to_date('2007-08-11 10:18:12','YYYY-MM-DD HH24:mi:ss'),8819.58623779);
INSERT INTO T_LEAD_OVER_DATA VALUES (14,'AA2',8,777,6923,to_date('2016-10-25 10:18:12','YYYY-MM-DD HH24:mi:ss'),2938.55854802);
INSERT INTO T_LEAD_OVER_DATA VALUES (15,'AA10',9,111,8047,to_date('2015-11-11 10:18:12','YYYY-MM-DD HH24:mi:ss'),5032.75518094);
INSERT INTO T_LEAD_OVER_DATA VALUES (16,'AA9',10,999,4857,to_date('2025-07-11 10:18:12','YYYY-MM-DD HH24:mi:ss'),0);
commit;
SELECT id,name,LEAD(NAME,1,id) OVER(partition by name,work_num order by id) as lead FROM T_LEAD_OVER_DATA ORDER BY 1,2,3;
SELECT id,name,LEAD('+++',1,id) OVER(partition by CREATE_DATE,name,dept order by id,DEPT) as lead FROM T_LEAD_OVER_DATA ORDER BY 1,2,3;
SELECT id,name,LEAD('+++',1,id+100000) OVER(partition by CREATE_DATE,name,dept order by id,DEPT) as lead FROM T_LEAD_OVER_DATA ORDER BY 1,2,3;
SELECT id,name,LEAD('$%$%$^%&%^*^&%',abs(1),id*10) OVER(partition by name,work_num order by id) as lead FROM T_LEAD_OVER_DATA ORDER BY 1,2,3;
SELECT id,name,LEAD('$%$%$^%&%^*^&%',abs(1),-2147483648) OVER(partition by name,work_num order by id) as lead FROM T_LEAD_OVER_DATA ORDER BY 1,2,3;
SELECT id,name,LEAD('rsresegge',1,floor(id+id*id-id/id)) OVER(partition by name,DEPT,CREATE_DATE order by id,LEADER_ID) as lead FROM T_LEAD_OVER_DATA ORDER BY 1,2,3;
DROP TABLE T_LEAD_OVER_DATA;