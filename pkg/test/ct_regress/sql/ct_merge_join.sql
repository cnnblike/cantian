DROP TABLE if exists RQG_SELECT_DIS_TBL;
DROP TABLE if exists RQG_SELECT_DIS_TBL2;
CREATE TABLE RQG_SELECT_DIS_TBL(C_INTEGER INTEGER, C_BIGINT BIGINT, C_DOUBLE DOUBLE, C_NUMBER NUMBER, C_CHAR CHAR(100), C_VARCHAR VARCHAR(2000), C_VARCHAR2 VARCHAR(2000), C_TIMESTAMP TIMESTAMP, C_TEXT TEXT, C_BOOL BOOL); 
CREATE TABLE RQG_SELECT_DIS_TBL2(C_INTEGER INTEGER, C_BIGINT BIGINT, C_DOUBLE DOUBLE, C_NUMBER NUMBER, C_CHAR CHAR(100), C_VARCHAR VARCHAR(2000), C_VARCHAR2 VARCHAR(2000), C_TIMESTAMP TIMESTAMP, C_TEXT TEXT, C_BOOL BOOL); 

INSERT INTO RQG_SELECT_DIS_TBL VALUES( 1, NULL, NULL, NULL, -474021888, NULL, NULL, NULL, 'mpdxvhqvf', NULL);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 3, NULL, NULL, NULL, 1488257024, '"', NULL, to_timestamp('2007-02-01 19:11:52', 'yyyy-mm-dd hh24:mi:ss'), NULL, NULL);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 4, NULL, 4214806301265362944, NULL, 257818624, '|', '%', to_timestamp('2008-05-18 05:43:36', 'yyyy-mm-dd hh24:mi:ss'), 'qif', TRUE);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 5, NULL, NULL, NULL, NULL, '*', '[]', NULL, 'hqifmpdx', TRUE);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 7, NULL, -1844786997361639424, NULL, NULL, '\\', 'ethqi', NULL, '=+', TRUE);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 8, NULL, NULL, NULL, 434044928, NULL, ',', NULL, 't', NULL);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 10, NULL, NULL, NULL, -654311424, 'ljteth', 'aljtet', NULL, NULL, NULL);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 12, 303431680, -2225059690897735680, NULL, 2024996864, 'ialjtethqi', '<>', to_timestamp('2004-02-21 08:56:50', 'yyyy-mm-dd hh24:mi:ss'), 't', FALSE);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 14, NULL, -8050184333924761600, NULL, -322109440, 'himtialjt', NULL, NULL, '~', FALSE);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 16, NULL, -3823556083637551104, NULL, NULL, ',', NULL, to_timestamp('2000-12-21 15:20:30', 'yyyy-mm-dd hh24:mi:ss'), 'ghimtialj', NULL);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 17, NULL, NULL, NULL, NULL, 'sg', 'gsg', NULL, '; ', NULL);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 20, -1960706048, NULL, NULL, 1235812352, NULL, '@', NULL, 'sblvgs', NULL);
INSERT INTO RQG_SELECT_DIS_TBL VALUES( 21, 109969408, NULL, NULL, -1079181312, NULL, NULL, to_timestamp('2007-07-16 04:44:07', 'yyyy-mm-dd hh24:mi:ss'), 'lsblvgsgh', TRUE);
INSERT INTO RQG_SELECT_DIS_TBL2 VALUES( 14, NULL, -8050184333924761600, NULL, -322109440, 'himtialjt', NULL, NULL, '~', FALSE);
INSERT INTO RQG_SELECT_DIS_TBL2 VALUES( 16, NULL, -3823556083637551104, NULL, NULL, ',', NULL, to_timestamp('2000-12-21 15:20:30', 'yyyy-mm-dd hh24:mi:ss'), 'ghimtialj', NULL);
INSERT INTO RQG_SELECT_DIS_TBL2 VALUES( 17, NULL, NULL, NULL, NULL, 'sg', 'gsg', NULL, '; ', NULL);
INSERT INTO RQG_SELECT_DIS_TBL2 VALUES( 20, -1960706048, NULL, NULL, 1235812352, NULL, '@', NULL, 'sblvgs', NULL);
INSERT INTO RQG_SELECT_DIS_TBL2 VALUES( 21, 109969408, NULL, NULL, -1079181312, NULL, NULL, to_timestamp('2007-07-16 04:44:07', 'yyyy-mm-dd hh24:mi:ss'), 'lsblvgsgh', TRUE);
INSERT INTO RQG_SELECT_DIS_TBL2 VALUES( 24, NULL, -1716715882958290944, NULL, -1117650944, '*', 'edp', to_timestamp('2003-11-09 14:49:25', 'yyyy-mm-dd hh24:mi:ss'), '{}', NULL);
INSERT INTO RQG_SELECT_DIS_TBL2 VALUES( 28, NULL, NULL, NULL, NULL, NULL, NULL, to_timestamp('2002-04-03 12:06:51', 'yyyy-mm-dd hh24:mi:ss'), '/', TRUE);
INSERT INTO RQG_SELECT_DIS_TBL2 VALUES( 29, NULL, -5827094967864000512, NULL, NULL, NULL, '$', to_timestamp('2007-09-02 05:48:23', 'yyyy-mm-dd hh24:mi:ss'), '<>', NULL);
INSERT INTO RQG_SELECT_DIS_TBL2 VALUES( 30, -1121583104, -2060678304498712576, NULL, NULL, 'dyxedp', 'jdyxedpls', NULL, 'ajdyxedpls', NULL);
INSERT INTO RQG_SELECT_DIS_TBL2 VALUES( 31, 1747648512, NULL, NULL, 170262528, NULL, '$', to_timestamp('2009-09-25 09:29:29', 'yyyy-mm-dd hh24:mi:ss'), '.', FALSE);
INSERT INTO RQG_SELECT_DIS_TBL2 VALUES( 32, -2093481984, NULL, NULL, NULL, '_', 'ka', NULL, 'm', NULL);
INSERT INTO RQG_SELECT_DIS_TBL2 VALUES( 33, NULL, 6624232101908578304, NULL, 1138688000, 'hmkajdy', NULL, NULL, 'fhmkajdyxe', NULL);
INSERT INTO RQG_SELECT_DIS_TBL2 VALUES( 34, 1534328832, 7043911292184166400, NULL, NULL, '[]', 'jfhmka', to_timestamp('2008-04-18 06:51:17', 'yyyy-mm-dd hh24:mi:ss'), 'hjfhmka', FALSE);
SELECT l.a_1, l.a_2, l.a_3, l.a_4, l.a_5, l.a_6, l.a_7, l.a_8, l.a_9, l.a_10, r.a_1, r.a_2, r.a_3, r.a_4, r.a_5, r.a_6, r.a_7, r.a_8, r.a_9, r.a_10 FROM (SELECT x.c_integer, x.c_bigint, x.c_double, x.c_number, x.c_char, x.c_varchar, x.c_varchar2, x.c_timestamp, x.c_text, x.c_bool FROM  rqg_select_dis_tbl x WHERE true) l(a_1, a_2, a_3, a_4, a_5, a_6, a_7, a_8, a_9, a_10) JOIN (SELECT y.c_integer, y.c_bigint, y.c_double, y.c_number, y.c_char, y.c_varchar, y.c_varchar2, y.c_timestamp, y.c_text, y.c_bool FROM  rqg_select_dis_tbl2 y WHERE true) r(a_1, a_2, a_3, a_4, a_5, a_6, a_7, a_8, a_9, a_10) ON true WHERE l.a_8 <= r.a_8 AND l.a_1 = r.a_1;
drop table if exists zsharding_tbl;
create table zsharding_tbl(
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
INSERT INTO zsharding_tbl VALUES ( 20, 0, 10, 1, 0, -1088618496, 500000, 1000, 9, 5, 8, 'a', 'def', '2003-02-28', TO_DATE('2002-03-18', 'YYYY-MM-DD'), TO_DATE('2003-11-25', 'YYYY-MM-DD'), TO_TIMESTAMP('2004-08-19 21:38:09', 'YYYY-MM-DD HH24:Mi:SS') );
SELECT * FROM zsharding_tbl where c_integer<(select avg(c_integer) from zsharding_tbl) and c_varchar in (select c_varchar from zsharding_tbl) and c_varchar = any (select c_varchar from zsharding_tbl) and exists(select c_varchar from zsharding_tbl) order by 1;
drop table if exists zsharding_tbl;

--DTS2018070600759
drop table if exists zsharding_tbl;
drop table if exists t1;
drop table if exists t2;
create table zsharding_tbl(
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
create table t1(a int);
create table t2(a int);
INSERT INTO zsharding_tbl VALUES ( 20, 0, 10, 1, 0, -1088618496, 500000, 1000, 9, 5, 8, 'a', 'def', '2003-02-28', TO_DATE('2002-03-18', 'YYYY-MM-DD'), TO_DATE('2003-11-25', 'YYYY-MM-DD'), TO_TIMESTAMP('2004-08-19 21:38:09', 'YYYY-MM-DD HH24:Mi:SS') );
INSERT INTO zsharding_tbl VALUES ( 21, 30000, 20000, 0, 1, 30000, 294453248, 0, 2, -110231552, 9, 'ghi', '2004-05-24', 'kbvumx', TO_DATE('2010-08-08', 'YYYY-MM-DD'), TO_DATE('1995-08-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2018-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') );
SELECT t1.c_id,t1.c_varchar FROM zsharding_tbl t1 where t1.c_varchar = any (select c_varchar from zsharding_tbl where t1.c_date in (select c_date from zsharding_tbl )) ;
select t2.* from t1;
select * from t1 where a in (select t1.* from t2);
select * from t1 where a in (select t1.a from t2);
drop table if exists zsharding_tbl;
drop table if exists t1;
drop table if exists t2;
--DTS2018082408042
set serveroutput on;
drop table if exists t_IUB_RADIOMO;
drop table if exists temp_update_table_B4;
drop view if exists sysobjects;
create table t_IUB_RADIOMO(              
     Version  varchar2(23) not null ,     
     MO  varchar2(113) not null ,         
     ImportOrder  number(10, 0) not null ,
     Flag  number(10, 0) not null ,       
      primary key  ( Version, MO )        
);
create table temp_update_table_B4 (moc varchar(383) not null);
create or replace view sysobjects as                                                                    
select object_name as name, object_name as id, CREATED as crdate, owner,                                
case object_type when 'TABLE' then 'U'                                                                  
                 when 'VIEW' then 'V'                                                                   
                 when 'TRIGGER' then 'TR'                                                               
                 when 'PROCEDURE' then 'P'                                                              
                 else 'D' end as type                                                                   
from all_objects where instr(',SEQUENCE,PROCEDURE,TRIGGER,TABLE,VIEW,FUNCTION,',','||object_type||',')>0
/ 
insert into t_IUB_RADIOMO values('2018-08-25', 'MO', 100, 100);
insert into t_IUB_RADIOMO values('2018-08-26', 'NO', 1000, 1000);
insert into temp_update_table_B4 values('MO'),('NO');

declare
    v_Temp_1 NUMBER(10, 0);
    v_Temp_2 varchar2(8000);
begin
    merge into t_IUB_RADIOMO 
    using ( select a.rowid as row_id, 2 as field0
     from t_IUB_RADIOMO a, temp_update_table_B4 b 
    where a.MO = b.moc and a.Flag = 0 and a.Version = 'B4') src 
    on(t_IUB_RADIOMO.rowid = src.row_id) 
    when matched then update set 
    Flag = src.field0
    ;
    select  count(*)  into v_Temp_1 from sysobjects where ((name) =  UPPER('temp_update_table_B4')) AND (sysobjects.OWNER)= UPPER(user);
    if  v_Temp_1  > 0  then

        v_Temp_2 := ' drop table temp_update_table_B4 cascade constraints purge';
        execute immediate v_Temp_2;
    end if;
end; 
/
drop table if exists t_IUB_RADIOMO;
drop table if exists temp_update_table_B4;
drop view if exists sysobjects;

drop table if exists join_test1;
drop table if exists join_test2;
drop table if exists join_test3;
create table join_test1
(
PLANID       INTEGER,
CMENEID      INTEGER,
CELLID       INTEGER,
LNCELLLIMIT  INTEGER
);
insert into join_test1 values(1,1,1,1);
insert into join_test1 values(2,2,2,2);

create table join_test2
(
PLANID         INTEGER,
CMENEID        INTEGER,
SRCLTENCELLID  INTEGER
);
insert into join_test2 values(1,1,1);
insert into join_test2 values(2,2,2);

create table join_test3
(
PLANID         INTEGER,
CMENEID        INTEGER,
CELLID         INTEGER,
C              INTEGER
);
insert into join_test3 values(1,1,1,1);
insert into join_test3 values(2,2,2,2);
select a.PlanID, a.CMENEID, a.CELLID, a.LNCELLLIMIT 
    from join_test1 a
        where exists
        (select  1
            from join_test2 b join join_test3 c on b.PlanID = c.PlanID and b.CMENEID = c.CMENEID and b.SRCLTENCELLID = a.CELLID group by b.PlanID, b.CMENEID);

drop table if exists t_join_base_001;
drop table if exists t_join_base_101;
drop table if exists t_join_base_102;
drop table if exists t_join_base_201;
drop view if exists v_t_join_base_101;
drop view if exists v_t_join_base_102;
drop view if exists v_t_join_base_201;

--大表
create table t_join_base_001(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date);
--小表
create table t_join_base_101(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date);
create table t_join_base_102(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date);
--空表
create table t_join_base_201(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date);

create index idx_join_base_001_1 on t_join_base_001(c_int);
create index idx_join_base_001_2 on t_join_base_001(c_int,c_vchar);
create index idx_join_base_001_3 on t_join_base_001(c_int,c_vchar,c_date);

create index idx_join_base_101_1 on t_join_base_101(c_int);
create index idx_join_base_101_2 on t_join_base_101(c_int,c_vchar);
create index idx_join_base_101_3 on t_join_base_101(c_int,c_vchar,c_date);

create index idx_join_base_102_1 on t_join_base_102(c_int);
create index idx_join_base_102_2 on t_join_base_102(c_int,c_vchar);
create index idx_join_base_102_3 on t_join_base_102(c_int,c_vchar,c_date);

create index idx_join_base_201_1 on t_join_base_201(c_int);
create index idx_join_base_201_2 on t_join_base_201(c_int,c_vchar);
create index idx_join_base_201_3 on t_join_base_201(c_int,c_vchar,c_date);

insert into t_join_base_001 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_join_base_101 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_join_base_102 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));

CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
                sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_vchar||'||i||',c_clob||'||i||',c_blob'||',c_date from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/
exec proc_insert('t_join_base_001',1,10000);
exec proc_insert('t_join_base_101',1,100);
exec proc_insert('t_join_base_102',1,10);
commit;


create view v_t_join_base_101 as select * from t_join_base_101 where id<90;
create view v_t_join_base_102 as select * from t_join_base_102 where id<9;
create view v_t_join_base_201 as select * from t_join_base_201;

drop table if exists t_join_base_001;
drop table if exists t_join_base_101;
drop table if exists t_join_base_102;
drop table if exists t_join_base_201;
drop view if exists v_t_join_base_101;
drop view if exists v_t_join_base_102;
drop view if exists v_t_join_base_201;

--DTS202009110K9VPCP0F00
DROP TABLE IF EXISTS "SK_EMPLOYMENTS" CASCADE CONSTRAINTS;
CREATE TABLE "SK_EMPLOYMENTS"( "EMPLOYMENT_ID" VARCHAR(10 BYTE) NOT NULL, "EMPLOYMENT_TITLE" VARCHAR(35 BYTE), "MIN_SALARY" NUMBER(6), "MAX_SALARY" NUMBER(6));
INSERT INTO "SK_EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values ('AD_PRES','President',20000,40000);
INSERT INTO "SK_EMPLOYMENTS" ("EMPLOYMENT_ID","EMPLOYMENT_TITLE","MIN_SALARY","MAX_SALARY") values ('AD_VP','Administration Vice President',15000,30000);
COMMIT;
DROP TABLE IF EXISTS "SK_DEPT_EMP" CASCADE CONSTRAINTS;
CREATE TABLE "SK_DEPT_EMP"("EMP_NO" BINARY_INTEGER NOT NULL,"DEPT_NO" CHAR(30 BYTE) NOT NULL, "FROM_DATE" DATE NOT NULL,  "TO_DATE" DATE NOT NULL );
INSERT INTO "SK_DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10001,'d005                          ','1986-06-26 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SK_DEPT_EMP" ("EMP_NO","DEPT_NO","FROM_DATE","TO_DATE") values (10002,'d007                          ','1996-08-03 00:00:00','9999-01-01 00:00:00');
COMMIT;
ALTER TABLE "SK_DEPT_EMP" ADD PRIMARY KEY("EMP_NO", "DEPT_NO");

drop table if exists SK_TBL_LIST;
CREATE TABLE SK_TBL_LIST(id BINARY_INTEGER not null,c_timestamp_localzone timestamp with local time zone,c_bool bool);
insert into SK_TBL_LIST(id,c_bool) values(1,TRUE);
COMMIT;
drop table if exists SK_TBL_RANGE_1;
CREATE TABLE SK_TBL_RANGE_1(id BINARY_INTEGER not null,c_varchar2 varchar2(100) default 1,c_date datetime,c_timestamp_localzone_arry timestamp with local time zone[],c_bool bool);
drop table if exists SK_TBL_RANGE2_2;
CREATE TABLE SK_TBL_RANGE2_2(
id BINARY_INTEGER not null,
c_short short,
c_uint uint,
c_bigint bigint,
c_number number,
c_numeric numeric(20,10),
c_decimal decimal,
c_double double,
c_real real,
c_varchar varchar(8000) default 'varchar',
c_char char(1000) default 'char' on update '111goodesmen',
c_varchar2 varchar2(100) default 1,
c_date datetime,
c_timestamp timestamp default '2019-11-19 17:41:00',
c_timestamp_zone timestamp with time zone,
c_timestamp_localzone timestamp with local time zone,
c_yeartomonth interval year to month,
c_daytosecond interval day(7) to second(6),
c_clob clob,
c_blob blob,
c_binary VARBINARY(8000),
c_raw raw(200),
c_image image,
c_bool bool
);
create or replace procedure proc_insert_range_2(tablename varchar,num int)
is
str varchar(8000);
begin
for j in 1..10*num loop
	str := 'insert into ' || tablename || '(id,c_short,c_uint,c_bigint,c_number,c_numeric,c_decimal,c_double,c_real,c_varchar,c_char,c_varchar2,c_date,c_timestamp,c_timestamp_zone ,c_timestamp_localzone,c_yeartomonth,c_daytosecond ,c_clob,c_blob,c_binary,c_raw,c_image,c_bool) values (' || j || ',' || (j*100) || ',' || j || ',' || (j*10000) || ',' || ((j-1)*0.25) || ',case when ' || (j*0.25%2) || ' =0 then null else ' || (j*0.25) || ' end,' || j || ',' || (j*2.345) || ',' || (j*0.5) || ',lpad(''qw'',' || (j*0.1) || ',''fgdf''),lpad(''good'',' || (j*0.01) || ',' ||'''dsfd''),rpad(''ff'',50,''23w'')||' || j || ',sysdate' || ',' || 'systimestamp' || ',' || '''1900-01-01 10:23:45.5666'',' || 'to_timestamp(''1900-01-01 09:23:30.455'',''YYYY-MM-DD HH24:MI:SS.FF'')+' || (j*0.01) ||  ',' || 'numtoyminterval(' || (j%11) || ',''month'' ),' || 'numtodsinterval(' || j || ', ''second'' )' || ',' || 'lpad(''dscdsad'',8000,''cdfgh'')||rpad(''45gty'',' || (j*0.1) || ',''sofa''),' || 'lpad(''1010101'',' || j || ',''11001''),' || 'lpad(''10'',' || (j*0.1) || ',''101''),' || 'lpad(''101'','|| (j*0.01) || ',''1101'')' || ',lpad(''10'',' || ((j+1)*0.1) || ',''11'')' || ',' || (j-100) || ')';
	execute immediate str;
end loop;
commit;
end;
/
exec proc_insert_range_2('SK_TBL_RANGE2_2',1);
drop table if exists SK_TBL_RANGE_3;
CREATE TABLE SK_TBL_RANGE_3(id BINARY_INTEGER not null,c_number number,c_bool bool);

SELECT
  ref_3.C_TIMESTAMP_LOCALZONE_ARRY AS C0,
  ref_1.C_TIMESTAMP_LOCALZONE AS C1
FROM
  (((SK_TBL_LIST as ref_0)
        FULL OUTER JOIN ((SK_TBL_LIST as ref_1)
          INNER JOIN (((SK_TBL_RANGE_3 as ref_2)
              LEFT OUTER JOIN (((SK_TBL_RANGE_1 as ref_3)
                  RIGHT JOIN ((SK_TBL_RANGE_3 as ref_4))
                  ON (false))
                LEFT JOIN (SK_TBL_RANGE_3 as ref_6)
                ON (ref_3.C_BOOL <> ref_4.C_BOOL))
              ON (ref_3.C_VARCHAR2 IS NOT NULL))
            RIGHT OUTER JOIN ((SK_EMPLOYMENTS as ref_7)
              INNER JOIN (SK_DEPT_EMP as ref_8)
              ON ((SELECT C_BOOL FROM SK_TBL_RANGE_3 LIMIT 1 OFFSET 1) <> (SELECT MIN(C_BOOL) FROM SK_TBL_RANGE_3)))
            ON (ref_6.C_NUMBER = ref_7.MIN_SALARY ))
          ON (ref_2.C_BOOL >= ref_4.C_BOOL))
        ON ((ref_3.C_DATE IS NOT NULL)))
      CROSS JOIN (SK_TBL_RANGE2_2 as ref_10))
    FULL JOIN (SK_TBL_RANGE_3 as ref_11)
    ON (ref_0.C_BOOL > ref_6.C_BOOL)
WHERE (ref_4.C_BOOL < false)
  AND (ref_0.C_BOOL > ref_10.C_BOOL);
SELECT
  ref_3.C_TIMESTAMP_LOCALZONE_ARRY AS C0,
  ref_1.C_TIMESTAMP_LOCALZONE AS C1
FROM
  (((SK_TBL_LIST as ref_0)
        FULL OUTER JOIN ((SK_TBL_LIST as ref_1)
          INNER JOIN (((SK_TBL_RANGE_3 as ref_2)
              LEFT OUTER JOIN (((SK_TBL_RANGE_1 as ref_3)
                  RIGHT JOIN ((SK_TBL_RANGE_3 as ref_4))
                  ON (false))
                LEFT JOIN (SK_TBL_RANGE_3 as ref_6)
                ON (ref_3.C_BOOL <> ref_4.C_BOOL))
              ON (ref_3.C_VARCHAR2 IS NOT NULL))
            RIGHT OUTER JOIN ((SK_EMPLOYMENTS as ref_7))
            ON (ref_6.C_NUMBER = ref_7.MIN_SALARY ))
          ON (ref_2.C_BOOL >= ref_4.C_BOOL))
        ON ((ref_3.C_DATE IS NOT NULL)))
      CROSS JOIN (SK_TBL_RANGE2_2 as ref_10))
    FULL JOIN (SK_TBL_RANGE_3 as ref_11)
    ON (ref_0.C_BOOL > ref_6.C_BOOL)
WHERE (ref_4.C_BOOL < false)
  AND (ref_0.C_BOOL > ref_10.C_BOOL);