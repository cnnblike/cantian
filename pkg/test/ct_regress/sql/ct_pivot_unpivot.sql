--pivot plan
DROP TABLE IF EXISTS T_FOR_PIVOT_1;
CREATE TABLE T_FOR_PIVOT_1 (EMPNO INT, ENAME VARCHAR(20), JOB VARCHAR(20), MGR INT, SAL INT, DEPTNO INT);
INSERT INTO T_FOR_PIVOT_1 VALUES (7369, 'SMITH', 'CLERK', 7902, 800, 20);
DROP TABLE T_FOR_PIVOT_1;
--unpivot plan
drop table IF EXISTS for_unpivot_1;
create table for_unpivot_1 (f1 int,f2 int, f3 int, f4 int, f5 int,f6 int);
insert into for_unpivot_1 values(1,1,3,4,5,6);
drop table for_unpivot_1;
--DTS2019091400983
drop table if exists PIVOT_T001;
CREATE TABLE  PIVOT_T001(
     COL_1 int,
     COL_2 integer, 
     COL_3 bigint,
     COL_4 real,
     COL_5 double,
     COL_6 float,
     COL_7 decimal(12,6),
     COL_8 number,
     COL_9 numeric,
     COL_10 char(30),
     COL_11 varchar(30),
     COL_12 varchar2(30),
     COL_13 image,
     COL_14 date,
     COL_15 datetime,
     COL_16 timestamp,
     COL_17 timestamp with time zone,
     COL_18 timestamp with local time zone,
     COL_19 bool,
     COL_20 boolean,
     COL_21 interval year to month,
     COL_22 interval day to second
);
create sequence pivot_seq increment by 1 start with 10;
begin
    for i in 1..10 loop
      insert into PIVOT_T001 values(     
      i,
      i+1,      
      pivot_seq.nextval,
      i+3.1415926,
      i+445.255,
      3.1415926-i*2,
      98*0.99*i, 
      99*1.01*i,
      -98*0.99*i,
      lpad('abc','10','@'), 
      lpad('abc','10','b'),
      rpad('abc','10','e'),
      '1111111111',
      TIMESTAMPADD(SECOND,i,'2018-11-03 14:14:12'),
      TIMESTAMPADD(MINUTE,i,'2019-01-03 14:14:12'),
      to_timestamp('2019-01-03 14:58:54.000000','YYYY-MM-DD HH24:MI:SS.FFFFFF'),    
      TIMESTAMPADD(HOUR,i,'2019-01-03 14:14:12'),
      TIMESTAMPADD(DAY,i,'2019-08-17 15:36:00'),
      true,
      false,
      (INTERVAL '99-02' YEAR TO MONTH),
      (INTERVAL '4 5:12:10.222' DAY TO SECOND(3))
      );
      commit;
    end loop;
end;
/

select * from (select col_1,col_2,col_3,col_4,col_5,col_6,col_7,col_8,col_9 from pivot_t001) pivot(count(col_6) for col_6 in (1.1415926,-0.8584074)) order by col_1;
select * from (select col_1,col_18,col_19,col_20,col_21,col_22 from pivot_t001) pivot(count(col_19) for col_19 in (FALSE)) order by col_1;
select * from (select col_1,col_18,col_19,col_20,col_21,col_22 from pivot_t001) pivot(count(col_19) for col_19 in (true,FALSE)) order by col_1;
select * from (select col_1,col_18,col_19,col_20,col_21,col_22 from pivot_t001) pivot(count(col_19) for col_19 in (0)) order by col_1;
select * from (select col_1,col_18,col_19,col_20,col_21,col_22 from pivot_t001) pivot(count(col_19) for col_19 in (1)) order by col_1;
select * from (select col_1,col_18,col_19,col_20,col_21,col_22 from pivot_t001) pivot(count(col_19) for col_19 in (0,1)) order by col_1;
select * from (select col_1,col_18,col_19,col_20,col_21,col_22 from pivot_t001) pivot(count(col_19) for col_19 in (FALSE,1)) order by col_1;
select * from (select col_1,col_18,col_19,col_20,col_21,col_22 from pivot_t001) pivot(count(col_19) for col_19 in (true, 0)) order by col_1;
select * from (select col_1,col_18,col_19,col_20,col_21,col_22 from pivot_t001) pivot(count(col_20) for col_20 in (FALSE)) order by col_1;
select * from (select col_1,col_18,col_19,col_20,col_21,col_22 from pivot_t001) pivot(count(col_20) for col_20 in (true,FALSE)) order by col_1;
select * from (select col_1,col_18,col_19,col_20,col_21,col_22 from pivot_t001) pivot(count(col_20) for col_20 in (0)) order by col_1;
select * from (select col_1,col_18,col_19,col_20,col_21,col_22 from pivot_t001) pivot(count(col_20) for col_20 in (1)) order by col_1;
select * from (select col_1,col_18,col_19,col_20,col_21,col_22 from pivot_t001) pivot(count(col_20) for col_20 in (0,1)) order by col_1;
select * from (select col_1,col_18,col_19,col_20,col_21,col_22 from pivot_t001) pivot(count(col_20) for col_20 in (FALSE,1)) order by col_1;
select * from (select col_1,col_18,col_19,col_20,col_21,col_22 from pivot_t001) pivot(count(col_20) for col_20 in (true, 0)) order by col_1;
drop table PIVOT_T001;
drop table if exists pivot_002;
create table pivot_002 (id int, c_blob blob, c_clob clob);
insert into pivot_002 values(1,lpad('10','12','01010'),rpad('abc','9','a@123&^%djgk'));
select * from (select id, c_blob from pivot_002) pivot (max(id) for id in (1));
select * from (select id, c_clob from pivot_002) pivot (max(id) for id in (1));
drop table pivot_002;
drop table if exists partition_test_8429_pivot2;
create table partition_test_8429_pivot2(id int not null,c_int int,c_vchar varchar(20) not null,c_vchar2 varchar(50) not null,c_date date,constraint partition_test_8429_con2 primary key(c_vchar2))
PARTITION BY RANGE(id) interval(10)
(
PARTITION p1 VALUES LESS THAN(100),
PARTITION p2 VALUES LESS THAN(200),
PARTITION p3 VALUES LESS THAN(300)
);
insert into partition_test_8429_pivot2 values(1,100,'abc123',lpad('123abc',10,'abc'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into partition_test_8429_pivot2 values(1,200,'abc456',lpad('123abc',11,'abc'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into partition_test_8429_pivot2 values(2,201,'abc789',lpad('123abc',12,'abc'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into partition_test_8429_pivot2 values(101,107,'abc123',lpad('123abc',15,'abc'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into partition_test_8429_pivot2 values(101,202,'abc456',lpad('123abc',16,'abc'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into partition_test_8429_pivot2 values(102,203,'abc789',lpad('123abc',17,'abc'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into partition_test_8429_pivot2 values(201,104,'abc123',lpad('123abc',19,'abc'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into partition_test_8429_pivot2 values(201,205,'abc456',lpad('123abc',20,'abc'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into partition_test_8429_pivot2 values(202,206,'abc789',lpad('123abc',30,'abc'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
commit;
select * from ((partition_test_8429_pivot2) partition(p1) pivot (sum(c_int) for c_vchar in ('abc123','abc456','abc789'))) order by c_vchar2;
select * from ((partition_test_8429_pivot2) partition pivot (sum(c_int) for c_vchar in ('abc123','abc456','abc789')) aaa) order by c_vchar2;
select * from ((partition_test_8429_pivot2) partition(p1) pivot (sum(c_int) for c_vchar in ('abc123','abc456','abc789'))) bbb order by c_vchar2;
drop table if exists partition_test_8429_pivot2;

DROP TABLE IF EXISTS T_FOR_UNPIVOT;
CREATE TABLE T_FOR_UNPIVOT (CITY VARCHAR(10), MONDAY INT, TUESDAY INT);
INSERT INTO T_FOR_UNPIVOT VALUES('BJ', '30', '32');
SELECT * FROM DUAL JOIN T_FOR_UNPIVOT ON DUMMY != CITY UNPIVOT(TEMPERATURE FOR DAY_1 IN (MONDAY, TUESDAY));
DROP TABLE T_FOR_UNPIVOT;

-- DTS202011190HGVG9P1N00
-- the len of pivot set alias larger than 64
drop table if exists pivot_long_set_alias;
create table pivot_long_set_alias
(
  emp_no number(8) not null,
  dept_no char(30 byte) not null,
  from_date date not null,
  to_date date not null
);
insert into pivot_long_set_alias values(10001,'d005                          ','1986-06-26 00:00:00','9999-01-01 00:00:00');
insert into pivot_long_set_alias values(10002,'d008                          ','1996-08-03 00:00:00','2000-06-26 00:00:00');
insert into pivot_long_set_alias values(10003,'d006                          ','1995-12-03 00:00:00','1996-11-09 00:00:00');
commit;
      
select *
from 
  (pivot_long_set_alias pivot(max(emp_no) as aggr_0
      for (from_date, emp_no, dept_no, to_date)
      in (('1996-08-03 00:00:00', 10002, 'd008                          ', '2000-06-26 00:00:00') as pexpr_0, 
          ('1995-12-03 00:00:00', 10003, 'd006                          ', '1996-11-09 00:00:00') as pexpr_1
         )) as ref_0);

select *
from 
  (pivot_long_set_alias pivot(max(emp_no) as aggr_0
      for (from_date, emp_no, dept_no, to_date)
      in (('1996-08-03 00:00:00', 10002, 'd008                          ', '2000-06-26 00:00:00'), 
          ('1995-12-03 00:00:00', 10003, 'd006                          ', '1996-11-09 00:00:00') as pexpr_1
         )) as ref_0);

select *
from 
  (pivot_long_set_alias pivot(max(emp_no) as aggr_0
      for (from_date, emp_no, dept_no, to_date)
      in (('1996-08-03 00:00:00', 10002, 'd008                                 ', '2000-06-26 00:00:00') as pexpr_0, 
          ('1995-12-03 00:00:00', 10003, 'd006                                 ', '1996-11-09 00:00:00') as pexpr_1
         )) as ref_0);

drop table pivot_long_set_alias;

-- DTS20201124080CE8P1100
drop table if exists unpivot_merge_into_t1;
drop table if exists unpivot_merge_into_t2;

create table unpivot_merge_into_t1(id number(8), name varchar(30), grade number(5));
insert into unpivot_merge_into_t1 values(1, 'Tom', 100);
insert into unpivot_merge_into_t1 values(2, 'Tim', 88);
commit;

create table unpivot_merge_into_t2(id number(8), stu_id number(8), c_name varchar(30), grade number(5));
insert into unpivot_merge_into_t2 values(1, 10001, 'Tom', 99);
insert into unpivot_merge_into_t2 values(2, 10002, 'Bob', 66);
commit;

merge into unpivot_merge_into_t1 target_0
using (unpivot_merge_into_t2 unpivot include nulls ((newcol_0, newcol_1)
       for (forcol_0)
       in ((c_name, stu_id) as ('unpivot_value_0'), 
           (c_name, grade), 
           (c_name, stu_id) as ('unpivot_value_0'), 
           (c_name, id) as ('unpivot_value_0'), 
           (c_name, id) as ('unpivot_value_0')
           )) ref_6)
on (target_0.name = ref_6.forcol_0)
when matched then update set grade = 99
when not matched then insert values (3, 'John', 88);
drop table unpivot_merge_into_t1;
drop table unpivot_merge_into_t2;

DROP TABLE IF EXISTS "WINFUNC_TAB_HASH4077";
CREATE TABLE "WINFUNC_TAB_HASH4077"
(
  "C_ID" BINARY_INTEGER,
  "C_D_ID" BINARY_INTEGER,
  "C_W_ID" BINARY_INTEGER,
  "C_FIRST" VARCHAR(16 BYTE),
  "C_MIDDLE" CHAR(2 BYTE),
  "C_LAST" VARCHAR(16 BYTE),
  "C_STREET_1" VARCHAR(20 BYTE),
  "C_STREET_2" VARCHAR(20 BYTE),
  "C_CITY" VARCHAR(20 BYTE),
  "C_STATE" CHAR(2 BYTE),
  "C_ZIP" CHAR(9 BYTE),
  "C_PHONE" CHAR(16 BYTE),
  "C_SINCE" TIMESTAMP(6),
  "C_CREDIT" CHAR(2 BYTE),
  "C_CREDIT_LIM" NUMBER(12, 2),
  "C_DISCOUNT" NUMBER(4, 4),
  "C_BALANCE" NUMBER(12, 2),
  "C_YTD_PAYMENT" NUMBER(12, 2),
  "C_PAYMENT_CNT" BINARY_INTEGER,
  "C_DELIVERY_CNT" BINARY_INTEGER,
  "C_DATA" VARCHAR(500 BYTE)
);
INSERT INTO "WINFUNC_TAB_HASH4077" ("C_ID","C_D_ID","C_W_ID","C_FIRST","C_MIDDLE","C_LAST","C_STREET_1","C_STREET_2","C_CITY","C_STATE","C_ZIP","C_PHONE","C_SINCE","C_CREDIT","C_CREDIT_LIM","C_DISCOUNT","C_BALANCE","C_YTD_PAYMENT","C_PAYMENT_CNT","C_DELIVERY_CNT","C_DATA") values
  (1,1,1,'iscmvlstpn','OE','BARBARBAR','bkilipzfcxcle','pmbwodmpvhvpafbj','dyfaoptppzjcgjrvyqa','uq','480211111','9400872216162535','2013-01-04 11:26:41.000000','GC',50000,.4361,-10,10,1,0,'qvldetanrbrburbmzqujshoqnggsmnteccipriirdhirwiynpfzcsykxxyscdsfqafhatdokmjogfgslucunvwbtbfsqzjeclbacpjqdhjchvgbnrkjrgjrycsgppsocnevautzfeosviaxbvobffnjuqhlvnwuqhtgjqsbfacwjpbvpgthpyxcpmnutcjxrbxxbmrmwwxcepwiixvvleyajautcesljhrsfsmsnmzjcxvcuxdwmyijbwywiirsgocwktedbbokhynznceaesuifkgoaafagugetfhbcylksrjukvbufqcvbffaxnzssyquidvwefktknrchyxfphunqktwnipnsrvqswsymocnoexbabwnpmnxsvshdsjhazcauvqjgvqjfkjjgqrceyjmbumkapmcbxeashybpgekjkfezthnjbhfqiwbutbxtkjkndyylrvrhsazhijvmkmhdgvuyvyayiavdmypqomgobo');
INSERT INTO "WINFUNC_TAB_HASH4077" ("C_ID","C_D_ID","C_W_ID","C_FIRST","C_MIDDLE","C_LAST","C_STREET_1","C_STREET_2","C_CITY","C_STATE","C_ZIP","C_PHONE","C_SINCE","C_CREDIT","C_CREDIT_LIM","C_DISCOUNT","C_BALANCE","C_YTD_PAYMENT","C_PAYMENT_CNT","C_DELIVERY_CNT","C_DATA") values
  (1,1,2,'gjgqcmfix','OE','BARBARBAR','ggfjukmdjw','iujitnapyeuiqsxqyyew','xkojyrcmqrf','ak','845411111','9488565345835462','2013-01-04 11:26:52.000000','GC',50000,.3627,-10,10,1,0,'hqdllnjpwmoblfghkrykuzgxtmcozjrixdigcqiuqhaajltawxbwcfyhqodvajsdrpwprkfwunstamgubmoaoqxrzxjemfcgoxxvekigdqnxrjskrvzljcdnqdkzbrximjjyrhpliahpprfikyntzirtoztlmmzzqrrenmfadffaoefttzgfmlttkribbefxdzamrzawhvpoetdhllvitjezoxwkegyaajuwwwcloykiiddlekoxqfkfqoklcdbmciskiijwmjjazecdquivygmmageiyelyecofrivbqwyyetmelrlommimlvnszcz');
COMMIT;

SELECT
  REF_0.PEXPR_0_AGGR_0 AS C0,
  CURRENT_TIMESTAMP() AS C1,
  REF_0.PEXPR_0_AGGR_0 AS C2
FROM
  WINFUNC_TAB_HASH4077 PIVOT(MIN(
      CAST(WINFUNC_TAB_HASH4077.C_CREDIT AS CHAR(2))) AS AGGR_0
     FOR (C_PHONE)
    IN (('9488565345835462') AS PEXPR_0)) AS REF_0
WHERE REGEXP_LIKE(REF_0.PEXPR_0_AGGR_0,'.*')
CONNECT BY 0 IS NOT NULL;

DROP TABLE "WINFUNC_TAB_HASH4077";
--20210902
DROP TABLE IF EXISTS "OM_TRADECONTACT_INFO";
CREATE TABLE "OM_TRADECONTACT_INFO"
(
  "CONTACT_INFO_ID" NUMBER(20) NOT NULL,
  "ORDER_ID" NUMBER(20),
  "FIRST_NAME" VARCHAR(128 BYTE),
  "MIDDLE_NAME" VARCHAR(128 BYTE),
  "LAST_NAME" VARCHAR(128 BYTE),
  "HOME_PHONE" VARCHAR(32 BYTE),
  "MOBILE_PHONE" VARCHAR(32 BYTE),
  "EMAIL" VARCHAR(512 BYTE),
  "BE_ID" NUMBER(10) NOT NULL,
  "PARTITION_ID" NUMBER(8) NOT NULL,
  "CREATE_TIME" DATE NOT NULL,
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
  "EX_FIELD11" VARCHAR(32 BYTE),
  "EX_FIELD12" VARCHAR(32 BYTE),
  "EX_FIELD13" VARCHAR(32 BYTE),
  "EX_FIELD14" VARCHAR(32 BYTE),
  "EX_FIELD15" VARCHAR(32 BYTE),
  "EX_FIELD16" VARCHAR(32 BYTE),
  "EX_FIELD17" VARCHAR(32 BYTE),
  "EX_FIELD18" VARCHAR(32 BYTE),
  "EX_FIELD19" VARCHAR(32 BYTE),
  "EX_FIELD20" VARCHAR(32 BYTE),
  "HIS_DATE" DATE,
  "TENANT_ID" NUMBER(20),
  "C_EX_FIELD1" VARCHAR(32 BYTE),
  "C_EX_FIELD2" VARCHAR(32 BYTE),
  "C_EX_FIELD3" VARCHAR(32 BYTE),
  "C_EX_FIELD4" VARCHAR(32 BYTE),
  "C_EX_FIELD5" VARCHAR(32 BYTE),
  "C_EX_FIELD6" VARCHAR(32 BYTE),
  "C_EX_FIELD7" VARCHAR(32 BYTE),
  "C_EX_FIELD8" VARCHAR(32 BYTE),
  "C_EX_FIELD9" VARCHAR(32 BYTE),
  "C_EX_FIELD10" VARCHAR(32 BYTE),
  "C_EX_FIELD11" VARCHAR(32 BYTE),
  "C_EX_FIELD12" VARCHAR(32 BYTE),
  "C_EX_FIELD13" VARCHAR(32 BYTE),
  "C_EX_FIELD14" VARCHAR(32 BYTE),
  "C_EX_FIELD15" VARCHAR(32 BYTE),
  "C_EX_FIELD16" VARCHAR(32 BYTE),
  "C_EX_FIELD17" VARCHAR(32 BYTE),
  "C_EX_FIELD18" VARCHAR(32 BYTE),
  "C_EX_FIELD19" VARCHAR(32 BYTE),
  "C_EX_FIELD20" VARCHAR(32 BYTE),
  "REF_CONTACT_INFO_ID" NUMBER(20),
  "OP_CODE" VARCHAR(1 BYTE),
  "TITLE" VARCHAR(32 BYTE),
  "OFFICE_PHONE" VARCHAR(32 BYTE),
  "FAX" VARCHAR(32 BYTE)
);
INSERT INTO "OM_TRADECONTACT_INFO" ("CONTACT_INFO_ID","ORDER_ID","FIRST_NAME","MIDDLE_NAME","LAST_NAME","HOME_PHONE","MOBILE_PHONE","EMAIL","BE_ID","PARTITION_ID","CREATE_TIME","EX_FIELD1","EX_FIELD2","EX_FIELD3","EX_FIELD4","EX_FIELD5","EX_FIELD6","EX_FIELD7","EX_FIELD8","EX_FIELD9","EX_FIELD10","EX_FIELD11","EX_FIELD12","EX_FIELD13","EX_FIELD14","EX_FIELD15","EX_FIELD16","EX_FIELD17","EX_FIELD18","EX_FIELD19","EX_FIELD20","HIS_DATE","TENANT_ID","C_EX_FIELD1","C_EX_FIELD2","C_EX_FIELD3","C_EX_FIELD4","C_EX_FIELD5","C_EX_FIELD6","C_EX_FIELD7","C_EX_FIELD8","C_EX_FIELD9","C_EX_FIELD10","C_EX_FIELD11","C_EX_FIELD12","C_EX_FIELD13","C_EX_FIELD14","C_EX_FIELD15","C_EX_FIELD16","C_EX_FIELD17","C_EX_FIELD18","C_EX_FIELD19","C_EX_FIELD20","REF_CONTACT_INFO_ID","OP_CODE","TITLE","OFFICE_PHONE","FAX") values
  (100100000000005005,100100000000054414,'eer',null,'erreerre',null,'1588888',null,101,0,'2020-07-15 03:07:35',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,999999,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,'1',null,null);
COMMIT;
CREATE UNIQUE INDEX "IDX_OM_TRADECONTACT_INFO" ON "OM_TRADECONTACT_INFO"("CONTACT_INFO_ID", "CREATE_TIME", "BE_ID") ;
CREATE INDEX "IDX_OM_TRADECONTACT_INFO_CO" ON "OM_TRADECONTACT_INFO"("ORDER_ID") ;
SELECT    REF_0.PEXPR_2_AGGR_1 AS C0 FROM    OM_TRADECONTACT_INFO PIVOT(APPROX_COUNT_DISTINCT(CAST(OM_TRADECONTACT_INFO.ORDER_ID AS NUMBER(20,0))) AS AGGR_0, STDDEV_SAMP(       CAST(1 AS NUMBER(20,0))) AS AGGR_1, MAX(       CAST(OM_TRADECONTACT_INFO.HIS_DATE AS DATE)) AS AGGR_2      FOR (FIRST_NAME)     IN (('ee') AS PEXPR_0, ('AutoTestName') AS PEXPR_1, ('z') AS PEXPR_2, ('GLSmKT') AS PEXPR_3, ('eLbCcP') AS PEXPR_4, ('tang') AS PEXPR_5, ('ge') AS PEXPR_6, ('11') AS PEXPR_7)) AS REF_0 ;
DROP TABLE IF EXISTS T_FOR_PIVOT;
CREATE TABLE T_FOR_PIVOT (CITY VARCHAR(10),DAY_1 VARCHAR(20),TEMPERATURE INT);
INSERT INTO T_FOR_PIVOT VALUES('BJ','MONDAY','30');
INSERT INTO T_FOR_PIVOT VALUES('BJ','TUESDAY','32');
COMMIT;
SELECT * FROM T_FOR_PIVOT PIVOT(APPROX_COUNT_DISTINCT(TEMPERATURE) FOR DAY_1  IN ('MONDAY','TUESDAY'));