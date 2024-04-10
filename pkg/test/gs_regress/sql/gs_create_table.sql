conn / as  sysdba hello
conn / as  sysdba
drop table if exists f_timestamp;
create table f_timestamp(f_id INT NOT NULL, f_var VARCHAR(64), f_time TIMESTAMP(10));
conn / as  sysdba 
drop table if exists testcao;
create table testcao(col nvarchar2(5) default '中国中国中');
insert into testcao values('中国中国人');
insert into testcao values('中国中国中中');
drop table if exists testcao;
conn / as  sysdba
drop table if exists lob4;
drop table lib$;
conn / as sysdba 
create view v_ct_sub_094(c1, c2.int.int.abc) as select 'abc' c1,2+3 c2 from dual;
create view v_ct_sub_095(c1, c1) as select 'abc' c1,2+3 c2 from dual;
create table yyyyyyy44( id int, ii.ee.rr.tt int);
conn / as  sysdba
drop table if exists flash_back_query_view2;
drop view if exists flash_back_query_view2;
create table flash_back_query_view2 as select 2 id,3 c_int from dual; 
create or replace view flash_back_query_view2 as select 2 id,3 c_int from dual; 
drop table if exists flash_back_query_view2;
drop view if exists flash_back_query_view2;
create table t_default_check_006(c_clob clob default max(2) over(partition by 1));
create user test_user1111 identified by cao102_cao;
alter user test_user1111 identified by '';
alter system set LOCAL_TEMPORARY_TABLE_ENABLED=TRUE;
create temporary table #t10(id int , name varchar(32));
insert into #t10 values (10,'cao');
insert into #t10 values (20,'jie');
select * from #t10;
drop temporary  table #t10;
select * from #t10;
create global temporary table t10(id int , name varchar(32));
insert into t10 values (10,'cao');
insert into t10 values (20,'jie');
select * from t10;
drop temporary  table t10;
select * from t10;
--DTS2018121910986
desc ALL_TAB_MODIFICATIONS;
drop table if exists t_not_null_base_001;
drop table if exists t_not_null_base_002;
drop table if exists t_not_null_test_004;
drop table if exists t_not_null_test_006;
create table t_not_null_base_001(id int,c_int int not null,c_char char(10) not null,c_vchar varchar(100) not null,c_date date,c_clob clob not null);
create table t_not_null_base_002(id int,c_int int not null,c_char char(10) not null,c_vchar varchar(100) not null,c_date date,c_clob clob not null);
create table t_not_null_test_004 as select t1.c_int c1,t2.c_int c2,t3.c_int c3 from t_not_null_base_001 t1 left join t_not_null_base_002 t2 on t1.id=t2.id right join t_not_null_base_001 t3 on t3.id=t1.id;
desc t_not_null_test_004;
create table t_not_null_test_006 as select t1.c_int c1,t2.c_int c2,t3.c_int c3 from t_not_null_base_001 t1 left join t_not_null_base_002 t2 on t1.id=t2.id full join t_not_null_base_001 t3 on t3.id=t1.id;
desc t_not_null_test_006;
drop table if exists t_not_null_base_001;
drop table if exists t_not_null_base_002;
drop table if exists t_not_null_test_004;
drop table if exists t_not_null_test_006;
drop table if exists base_001;
drop table if exists base_002;
drop table if exists test_1;
drop table if exists test_2;
drop table if exists test_3;
drop table if exists test_4;
drop table if exists test_5;
drop view  if exists view_base_002;
create table base_001(id int ,c_int int not null);
create table base_002(id int ,c_int int not null);
create view view_base_002 as select * from base_002;
insert into base_001 values (10,200);
insert into base_001 values (20,300);
insert into base_001 values (30,400);
insert into base_002 values (10,100);
create table test_1 as select t1.c_int c1,t2.c_int c2, t3.c_int c3 from (base_001 t1 left join base_002 t2 on t1.id=t2.id) right join base_001 t3 on t3.id=t1.id ;
create table test_2 as select t1.c_int c1,t2.c_int c2, t3.c_int c3 from (base_001 t1 left join (select id ,c_int from base_002) t2 on t1.id=t2.id) right join base_001 t3 on t3.id=t1.id ;
create table test_3 as select t1.c_int c1,t2.c_int c2, t3.c_int c3 from (base_001 t1 left join view_base_002 t2 on t1.id=t2.id) right join base_001 t3 on t3.id=t1.id ;
create table test_4 as select t1.c_int c1,t2.c_int c2 from base_001 t1 left join base_002 t2 on t1.id=t2.id;
create table test_5 as select t1.c_int c1,t2.c_int c2 from base_001 t1 right join base_002 t2 on t1.id=t2.id;
desc test_1;
desc test_2;
desc test_3;
desc test_4;
desc test_5;
drop table if exists base_001;
drop table if exists base_002;
drop table if exists test_1;
drop table if exists test_2;
drop table if exists test_3;
drop table if exists test_4;
drop table if exists test_5;
drop view  if exists view_base_002;
--DTS2019012901334
drop table if exists acid2;
create table acid2(a number(25,3));
create index acid2_idx on acid2(a);
delete from acid2 where rowid in (select rowid from acid2 order by rowscn limit 3);
drop table if exists acid2;
DROP TABLE IF EXISTS T_CREATE_TAB_AS_SELECT_1;
CREATE TABLE T_CREATE_TAB_AS_SELECT_1
(
    sn           NUMBER(38),
    operation    VARCHAR2(516)  not null,
    logLevel     VARCHAR2(7)    not null constraint CHK_T_CREATE_TAB_AS_SELECT_SEC_LEVEL1 check(logLevel in ('WARNING','MINOR','RISK')),
    userId       VARCHAR2(512)  not null,
    datetime     NUMBER(38)     not null,
    source       VARCHAR2(300)  not null,
    terminal     VARCHAR2(60)   not null,
    targetObj    VARCHAR2(765)  not null,
    result       VARCHAR2(10)   not null constraint CHK_T_CREATE_TAB_AS_SELECT_RESULT1 check(result in ('SUCCESSFUL','FAILURE','POK')),
    detail       VARCHAR2(3072) not null,
    addInfo      VARCHAR2(2400),
    PRIMARY KEY ( sn ) using index tablespace users
)tablespace users;
INSERT INTO T_CREATE_TAB_AS_SELECT_1 VALUES(1, 'NEW', 'MINOR', '000001', 1, 'SOURCE 1', 'TERMINAL 1', 'TARGET 1', 'POK', 'NO MORE DETAIL', 'NO MORE ADDITION INFO');
INSERT INTO T_CREATE_TAB_AS_SELECT_1 VALUES(2, 'NEW', 'MINOR', '000002', 2, 'SOURCE 1', 'TERMINAL 1', 'TARGET 1', 'POK', 'NO MORE DETAIL', 'NO MORE ADDITION INFO');
INSERT INTO T_CREATE_TAB_AS_SELECT_1 VALUES(3, 'NEW', 'MINOR', '000003', 3, 'SOURCE 1', 'TERMINAL 1', 'TARGET 1', 'POK', 'NO MORE DETAIL', 'NO MORE ADDITION INFO');
INSERT INTO T_CREATE_TAB_AS_SELECT_1 VALUES(4, 'NEW', 'MINOR', '000004', 4, 'SOURCE 1', 'TERMINAL 1', 'TARGET 1', 'POK', 'NO MORE DETAIL', 'NO MORE ADDITION INFO');
SELECT CONS_TYPE, COLS, COL_LIST, COND_TEXT FROM SYS_CONSTRAINT_DEFS WHERE USER#=0 AND  TABLE# = (SELECT ID  FROM SYS_TABLES WHERE  NAME = 'T_CREATE_TAB_AS_SELECT_1') ORDER BY CONS_TYPE,COLS,COL_LIST;
col sn format a10;
col operation format a10;
col logLevel format a10;
col userId format a10;
col datetime format a10;
col source format a10;
col terminal format a10;
col targetObj format a10;
col result format a10;
col detail format a10;
col addInfo format a10;


DROP TABLE IF EXISTS T_CREATE_TAB_AS_SELECT_2;
CREATE TABLE T_CREATE_TAB_AS_SELECT_2 AS SELECT * FROM T_CREATE_TAB_AS_SELECT_1;
SELECT CONS_TYPE, COLS, COL_LIST, COND_TEXT FROM SYS_CONSTRAINT_DEFS WHERE USER#=0 AND  TABLE# = (SELECT ID  FROM SYS_TABLES WHERE  NAME = 'T_CREATE_TAB_AS_SELECT_2') ORDER BY CONS_TYPE,COLS,COL_LIST;
select * from T_CREATE_TAB_AS_SELECT_2 ORDER BY SN;

DROP TABLE IF EXISTS T_CREATE_TAB_AS_SELECT_3;
CREATE TABLE T_CREATE_TAB_AS_SELECT_3(sn, operation, loglevel, userid, datetime, source, terminal, targetobj, result, detail, addinfo)
AS SELECT * FROM T_CREATE_TAB_AS_SELECT_1;
SELECT CONS_TYPE, COLS, COL_LIST, COND_TEXT FROM SYS_CONSTRAINT_DEFS WHERE USER#=0 AND  TABLE# = (SELECT ID  FROM SYS_TABLES WHERE  NAME = 'T_CREATE_TAB_AS_SELECT_3') ORDER BY CONS_TYPE,COLS,COL_LIST;
select * from T_CREATE_TAB_AS_SELECT_3 ORDER BY SN;

DROP TABLE IF EXISTS T_CREATE_TAB_AS_SELECT_4;
CREATE TABLE T_CREATE_TAB_AS_SELECT_4
(
    sn, 
    operation not null, 
    loglevel  not null constraint CHK_T_CREATE_TAB_AS_SELECT_SEC_LEVEL4 check(logLevel in ('WARNING','MINOR','RISK')), 
    userid    not null, 
    datetime  not null, 
    source    not null, 
    terminal  not null, 
    targetobj not null, 
    result    not null constraint CHK_T_CREATE_TAB_AS_SELECT_RESULT4 check(result in ('SUCCESSFUL','FAILURE','POK')), 
    detail    not null, 
    addinfo,
    PRIMARY KEY ( sn ) using index tablespace users
)tablespace users AS SELECT * FROM T_CREATE_TAB_AS_SELECT_1;
SELECT CONS_TYPE, COLS, COL_LIST, COND_TEXT FROM SYS_CONSTRAINT_DEFS WHERE USER#=0 AND  TABLE# = (SELECT ID  FROM SYS_TABLES WHERE  NAME = 'T_CREATE_TAB_AS_SELECT_4') ORDER BY CONS_TYPE,COLS,COL_LIST;
select * from T_CREATE_TAB_AS_SELECT_4 ORDER BY SN;

DROP TABLE IF EXISTS T_CREATE_TAB_AS_SELECT_5;
CREATE TABLE T_CREATE_TAB_AS_SELECT_5 tablespace users AS SELECT sn + 1, operation, loglevel, userid, datetime, source, terminal, targetobj, result, detail, addinfo FROM T_CREATE_TAB_AS_SELECT_1;
select * from T_CREATE_TAB_AS_SELECT_5 ORDER BY SN;

--DTS2018070909827
create table unique_t (c_char unique);
create table not_null_t (c_char not null);

-- extend
drop table if exists t_create_as1;
drop table if exists t_create_as2;
create table t_create_as1(f1 int not null, f2 number(10,0));
insert into t_create_as1 values(1,11),(2,22),(3,33),(4,44),(1,11),(2,22);
commit;
desc t_create_as1;
select * from t_create_as1 order by f1, f2;

create table t_create_as2 as select distinct f1, f2 from t_create_as1;
desc t_create_as2;
select * from t_create_as2 order by f1, f2;
drop table t_create_as2;

create table t_create_as2 as select f1, f2 from t_create_as1 group by f1, f2;
desc t_create_as2;
select * from t_create_as2 order by f1, f2;
drop table t_create_as2;

create table t_create_as2 as select * from (select * from t_create_as1);
desc t_create_as2;
select * from t_create_as2 order by f1, f2;
drop table t_create_as2;

create table t_create_as2 as select * from t_create_as1 union select * from t_create_as1;
desc t_create_as2;
select * from t_create_as2 order by f1, f2;
drop table t_create_as2;

create table t_create_as2 as select * from t_create_as1 union all select * from t_create_as1;
desc t_create_as2;
select * from t_create_as2 order by f1, f2;
drop table t_create_as2;

create table t_create_as2 as select * from t_create_as1 minus select * from t_create_as1;
desc t_create_as2;
select * from t_create_as2 order by f1, f2;
drop table t_create_as2;

create table t_create_as2 as select f1+1 as f1, f2+1 as f2 from t_create_as1;
desc t_create_as2;
select * from t_create_as2 order by f1, f2;
drop table t_create_as2;

drop table if exists t_create_tinyint;
create table t_create_tinyint(x tinyint, y tinyint unsigned);
desc t_create_tinyint;

drop table if exists t_create_double;
create table t_create_double(x tinyint, y double unsigned);
create table t_create_double(x tinyint, y char(100) unsigned);
create table t_create_double(x tinyint, y number unsigned);

--check column size when create table
DROP TABLE IF EXISTS max_row_len;
CREATE TABLE max_row_len(c1 INTEGER, c2 VARCHAR(4000), c3 VARCHAR(4000),c4 VARCHAR(4000), c5 VARCHAR(4000),c6 VARCHAR(4000), c7 VARCHAR(4000),c8 VARCHAR(4000), c9 VARCHAR(4000));
CREATE TABLE max_row_len(c1 CLOB, c2 VARCHAR(4000), c3 VARCHAR(4000),c4 VARCHAR(4000), c5 VARCHAR(4000),c6 VARCHAR(4000), c7 VARCHAR(4000),c8 VARCHAR(4000), c9 VARCHAR(4000));
CREATE TABLE max_row_len(c1 INTEGER, c2 VARCHAR(4000), c3 VARCHAR(4000),c4 VARCHAR(4000), c5 VARCHAR(4000),c6 VARCHAR(4000), c7 VARCHAR(4000),c8 VARCHAR(4000));
DROP TABLE max_row_len;


DROP TABLE IF EXISTS "TM_FMBASEPACKAGE";
CREATE TABLE "TM_FMBASEPACKAGE" ( "MOID" NUMBER(19) NOT NULL , "PACKAGENAME" VARCHAR2(255) NULL , "PACKAGEPATH" VARCHAR2(255) NULL , "PACKAGEDESC" VARCHAR2(512) NULL , "PACKAGESIZE" NUMBER(19) NULL , "PACKAGETYPE" NUMBER(10) NULL , "UPDATEPOLICY" NUMBER(10) NULL , "PACKAGEDATE" VARCHAR2(255) NULL , "PACKAGESTATUS" VARCHAR2(255) NULL , "UPDATESTATE" NUMBER(10) NULL ) LOGGING COMPRESS FOR ALL1 NOCACHE ;
CREATE TABLE "TM_FMBASEPACKAGE" ( "MOID" NUMBER(19) NOT NULL , "PACKAGENAME" VARCHAR2(255) NULL , "PACKAGEPATH" VARCHAR2(255) NULL , "PACKAGEDESC" VARCHAR2(512) NULL , "PACKAGESIZE" NUMBER(19) NULL , "PACKAGETYPE" NUMBER(10) NULL , "UPDATEPOLICY" NUMBER(10) NULL , "PACKAGEDATE" VARCHAR2(255) NULL , "PACKAGESTATUS" VARCHAR2(255) NULL , "UPDATESTATE" NUMBER(10) NULL ) LOGGING NOCOMPRESS NOCACHE ;
drop table TM_FMBASEPACKAGE;
CREATE TABLE "TM_FMBASEPACKAGE" ( "MOID" NUMBER(19) NOT NULL , "PACKAGENAME" VARCHAR2(255) NULL , "PACKAGEPATH" VARCHAR2(255) NULL , "PACKAGEDESC" VARCHAR2(512) NULL , "PACKAGESIZE" NUMBER(19) NULL , "PACKAGETYPE" NUMBER(10) NULL , "UPDATEPOLICY" NUMBER(10) NULL , "PACKAGEDATE" VARCHAR2(255) NULL , "PACKAGESTATUS" VARCHAR2(255) NULL , "UPDATESTATE" NUMBER(10) NULL ) LOGGING COMPRESS NOCACHE ;
drop table TM_FMBASEPACKAGE;
CREATE TABLE "TM_FMBASEPACKAGE" ( "MOID" NUMBER(19) NOT NULL , "PACKAGENAME" VARCHAR2(255) NULL , "PACKAGEPATH" VARCHAR2(255) NULL , "PACKAGEDESC" VARCHAR2(512) NULL , "PACKAGESIZE" NUMBER(19) NULL , "PACKAGETYPE" NUMBER(10) NULL , "UPDATEPOLICY" NUMBER(10) NULL , "PACKAGEDATE" VARCHAR2(255) NULL , "PACKAGESTATUS" VARCHAR2(255) NULL , "UPDATESTATE" NUMBER(10) NULL ) LOGGING COMPRESS FOR ALL OPERATIONS  NOCACHE ;
drop table TM_FMBASEPACKAGE;
CREATE TABLE "TM_FMBASEPACKAGE" ( "MOID" NUMBER(19) NOT NULL , "PACKAGENAME" VARCHAR2(255) NULL , "PACKAGEPATH" VARCHAR2(255) NULL , "PACKAGEDESC" VARCHAR2(512) NULL , "PACKAGESIZE" NUMBER(19) NULL , "PACKAGETYPE" NUMBER(10) NULL , "UPDATEPOLICY" NUMBER(10) NULL , "PACKAGEDATE" VARCHAR2(255) NULL , "PACKAGESTATUS" VARCHAR2(255) NULL , "UPDATESTATE" NUMBER(10) NULL ) LOGGING COMPRESS FOR DIRECT_LOAD OPERATIONS  NOCACHE ;
drop table TM_FMBASEPACKAGE;

drop table if exists tbl1;
create table tbl1 as select substring('abcABC 123456 !@#$%^&',1,2) c from dual;
desc tbl1;
drop table if exists tbl1;
create table tbl1 as select substring('abcABC 123456 !@#$%^&',1,100) c from dual;
desc tbl1;
drop table if exists tbl1;
create table tbl1 as select substring('abcABC 123456 !@#$%^&',5,10) c from dual;
desc tbl1;
drop table if exists tbl1;
create table tbl1 as select substring('abcABC 123456 !@#$%^&',-5,4) c from dual;
desc tbl1;

drop table if exists tbl2;
create table tbl2 (str varchar(10), f1 int, f2 int, f3 number(10), f4 number(8,2));
drop table if exists tbl1;
create table tbl1 as select substring('abcABC 123456 !@#$%^&',f1,4) c from tbl2;
desc tbl1;
drop table if exists tbl1;
create table tbl1 as select substring(str,1,4) c from tbl2;
desc tbl1;
drop table if exists tbl1;
create table tbl1 as select substring(str,f1,f2) c from tbl2;
desc tbl1;
drop table if exists tbl1;
create table tbl1 as select case when reverse('abc')='cba' then 'a' else 'b' end c from dual;
desc tbl1;
drop table if exists tbl1;
create table tbl1 as select case when reverse('abc')='cba' then 'a' else 7 end c from dual;

drop table if exists tbl1;
create table tbl1 as select case when reverse('abc')='cba' then '1231a' else 'ab' end c from dual;
desc tbl1;
drop table if exists tbl1;
create table tbl1 as select case when reverse('abc')='cba' then f1 else str end c from tbl2;

drop table if exists tbl1;
create table tbl1 as select case when reverse(str)='cfa' then null else f4 end c from tbl2;
desc tbl1;
drop table if exists tbl1;
create table tbl1 as select case when reverse(str)='cfa' then f3 else null end c from tbl2;
desc tbl1;
drop table if exists tbl1;
create table tbl1 as select case when reverse(str)='cfa' then f3 else f4 end c from tbl2;
desc tbl1;
drop table if exists tbl1;
drop table if exists tbl2;

desc -q select case when 1 != 2 then cast(123123.123 as number(38)) else cast(1231231.123 as number(20, 10)) end as B from dual;
desc -q select case when 1 != 2 then cast(123123.123 as number(38)) end as B from dual;
desc -q select case when 1 != 2 then cast(123123.123 as number(38,2)) else cast(1231231.123 as number(38, 2)) end as B from dual;
desc -q select case when 1 != 2 then cast(123123.123 as number(38,2)) else cast(1231231.123 as number(38, 3)) end as B from dual;

create table null_col_table as select null as b from dual;

drop table if exists aa;
create table aa(i int);
alter table aa add add_column varchar(3900) default (select lpad('bbbbb',395,'aaaaa') from dual);
drop FUNCTION if exists func_aa;
CREATE FUNCTION func_aa(A varchar, B int)
RETURN varchar
AS
BEGIN
   return lpad(A,B,'aaaaa');
END;
/
alter table aa add add_column varchar(3900) default func_aa('bbbbb', 10);
insert into aa values (1,default);
select * from aa;
drop table aa;


drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select cast(null as number(30,10)) as b from dual;
desc GCT_TAB_TEST1;
select * from GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select cast(null as varchar(200)) as b from dual;
desc GCT_TAB_TEST1;
select * from GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select cast(null as binary_integer) as b from dual;
desc GCT_TAB_TEST1;
select * from GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select cast(null as number) || '' as b from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select cast(null as double) || ''  as b from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select cast(null as double) || systimestamp  as b from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select systimestamp  as b from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select systimestamp(4)  as b from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select cast(systimestamp(1) as timestamp(5))  as b from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as  select cast(1 as number(30, 2)) + cast(2 as  number(30,2)) XX from dual;
desc GCT_TAB_TEST1;
select * from GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select systimestamp - sysdate  as b from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
drop view if exists GCT_VIEW_TEST1;
create table GCT_TAB_TEST1(x number(10));
create view GCT_VIEW_TEST1 as select case when x != 100 then x end as id from GCT_TAB_TEST1;
desc GCT_VIEW_TEST1

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select cast(null as varchar(300)) || null as C from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select null + dummy as b from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select 1 + dummy as b from dual;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select  1 + null + '2' as b from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select  1 + null + '2asdfa' as b from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select  null + '2asdfa' as b from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select  '2asdfa'+null as b from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select  1 + 2 + systimestamp +null as b from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select  1 + 2 + null as b from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select  1 + true + null as b from dual;
desc GCT_TAB_TEST1;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select  '' + 2 as b from dual;
desc GCT_TAB_TEST1;

-- zero-length columns is not allowed
drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select substr(null, 0, 100)  as b from dual;
create table GCT_TAB_TEST1 as select '' as b from dual;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select null as b from dual;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select default as b from dual;

drop table if exists GCT_TAB_TEST1;
create table GCT_TAB_TEST1 as select null + 1.333 as b from dual;
create table GCT_TAB_TEST1 as select null * systimestamp as b from dual;
create table GCT_TAB_TEST1 as select null & 100 as b from dual;
create table GCT_TAB_TEST1 as select null >> 100 as b from dual;
create table GCT_TAB_TEST1 as select null % 100 as b from dual;
create table GCT_TAB_TEST1 as select null || null as C from dual;

-- create view: do not verify zero-length column
drop view if exists GCT_VIEW_TEST1;
create view GCT_VIEW_TEST1 as select substr(null, 0, 100)  as b from dual;
desc GCT_VIEW_TEST1;

drop view if exists GCT_VIEW_TEST1;
create view GCT_VIEW_TEST1 as select null as b from dual;
desc GCT_VIEW_TEST1;

drop view if exists GCT_VIEW_TEST1;
create view GCT_VIEW_TEST1 as select '' as b from dual;
desc GCT_VIEW_TEST1;

drop view if exists GCT_VIEW_TEST1;
create view GCT_VIEW_TEST1 as select default as b from dual;
desc GCT_VIEW_TEST1;

drop view if exists GCT_VIEW_TEST1;
create view GCT_VIEW_TEST1 as select null * null as b from dual;
desc GCT_VIEW_TEST1;
desc -q select null | null as b from dual;
desc -q select null || null as b from dual;
desc -q select '' || '' as b from dual;

drop view if exists GCT_VIEW_TEST1;
create view GCT_VIEW_TEST1 as select NULL as haha from dual;
select * from GCT_VIEW_TEST1 union select 12313 from dual;
desc -q select * from GCT_VIEW_TEST1 union select 12313 from dual;

desc -q select * from GCT_VIEW_TEST1 union all select systimestamp from dual;
desc -q select * from GCT_VIEW_TEST1 union all select '1' from dual;
desc -q select * from GCT_VIEW_TEST1 union all select '' from dual;
desc -q select * from GCT_VIEW_TEST1 union all select 1313.3333 from dual;
desc -q select * from GCT_VIEW_TEST1 union all select NULL::number(30) from dual;
desc -q select NULL::number(30) ABC from dual union select * from GCT_VIEW_TEST1;
desc -q select NULL BBC from dual union select * from GCT_VIEW_TEST1;
desc -q select NULL::varchar(300) ABC from dual union select * from GCT_VIEW_TEST1;

drop view if exists GCT_VIEW_TEST1;
drop table if exists GCT_TAB_TEST1;

--DTS2018111503396
drop table if exists t_not_null_base_001;
drop table if exists t_not_null_base_002;
create table t_not_null_base_001(id int,c_int int not null,c_char char(10) not null,c_vchar varchar(100) not null,c_date date,c_clob clob not null);
create table t_not_null_base_002(id int,c_int int not null,c_char char(10) not null,c_vchar varchar(100) not null,c_date date,c_clob clob not null);

drop table if exists t_not_null_test_121;
create table t_not_null_test_121(c1,c2,c3 default 'aaa') as select t1.c_clob c1,t2.c_date c2,t3.c_vchar||t3.c_vchar c3 from t_not_null_base_001 t1 right join t_not_null_base_002 t2 on t1.id=t2.id right join t_not_null_base_001 t3 on t3.id=t1.id;

--extend 
drop table if exists t_default_test_extend1;
create table t_default_test_extend1(c1 default 'charsizemorethan10') as select c_char from t_not_null_base_001;--error

drop table if exists t_default_test_extend2;
create table t_default_test_extend2(c1 int ,c2  default 'aaa'); --error

drop table if exists t_default_test_extend3;
create table t_default_test_extend3(c1 varchar(100) default 'charsizemorethan10') as select c_char from t_not_null_base_001;--error

--clean test data
drop table if exists  t_not_null_base_001;
drop table if exists  t_not_null_base_002;
drop table if exists  t_not_null_test_121;
drop table if exists  t_default_test_extend1;
drop table if exists  t_default_test_extend2;
drop table if exists  t_default_test_extend3;

--create table t2(f1 default XXX on update XXX) as select XXX;
drop table if exists default_update_t1;
drop table if exists default_update_t2;
create table default_update_t1 (t1_f1 int,t1_f2 timestamp(3) default to_timestamp('2018-01-25','yyyy-mm-dd'));
create table default_update_t2 (t2_f1 , t1_f2 default to_timestamp('2018-01-27','yyyy-mm-dd') ON UPDATE to_timestamp('2018-01-28','yyyy-mm-dd')) as  select t1_f1,t1_f2 from default_update_t1;

drop table if exists default_update_t2;
create table default_update_t2 (t2_f1 , t1_f2 timestamp(3) default to_timestamp('2018-01-27','yyyy-mm-dd') ON UPDATE to_timestamp('2018-01-28','yyyy-mm-dd')) as  
select t1_f1,t1_f2 from default_update_t1;--error

drop table if exists default_update_t1;
drop table if exists default_update_t2;

drop table if exists DTS2018121110247;
create table DTS2018121110247 (c1 bigint unsigned);
drop table if exists DTS2018121110247;
create table DTS2018121110247 (c1 int unsigned);

create table tx (c1 int default ge_000S%  );
--DTS2018122113240
drop table if exists create_table_nvarchar;
create table create_table_nvarchar (id int ,name nvarchar(10));
desc create_table_nvarchar
alter table create_table_nvarchar modify name default 'abc';
desc create_table_nvarchar
insert into create_table_nvarchar (id) values (5);
select * from create_table_nvarchar;

--DTS2019011713884
CREATE USER REUSE_ENTRY_USER IDENTIFIED BY Cantian_234;
GRANT DBA TO REUSE_ENTRY_USER;
SET SERVEROUT ON;
DECLARE
    ID1 BIGINT;
    ID2 BIGINT;
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE REUSE_ENTRY_USER.REUSE_ENTRY_TEST(I INT)';
    SELECT ID INTO ID1 FROM SYS_TABLES WHERE NAME='REUSE_ENTRY_TEST';
    EXECUTE IMMEDIATE 'DROP TABLE REUSE_ENTRY_USER.REUSE_ENTRY_TEST PURGE';
    EXECUTE IMMEDIATE 'CREATE TABLE REUSE_ENTRY_USER.REUSE_ENTRY_TEST(I INT)';
    SELECT ID INTO ID2 FROM SYS_TABLES WHERE NAME='REUSE_ENTRY_TEST';
    IF ID1=ID2 THEN
        dbe_output.print_line('REUSE ENTRY!');
    ELSE
         dbe_output.print_line(ID1);
         dbe_output.print_line(ID2);
    END IF; 
END;
/
DROP TABLE REUSE_ENTRY_USER.REUSE_ENTRY_TEST PURGE;

--test max table count for userId
create or replace procedure test_table_limit() as 
    i int;
begin	
	for i in 0 ..16777216
	loop
	execute immediate 'create table table_limit_'||i||'(id int)';
	end loop;
end;
/

drop table if exists default_update_t3;
drop sequence if exists seq_001;
drop sequence if exists seq_002;
create sequence seq_001 start with 0 maxvalue 1 minvalue 0 CYCLE nocache; 
create sequence seq_002 start with 0 maxvalue 4 minvalue 0 INCREMENT BY 2 CYCLE nocache; 
create table default_update_t3 (
fd_int0 int, 
fd_int1 int default case seq_001.NEXTVAL when 0 then seq_001.currval else 1 end  on update case when seq_002.NEXTVAL >= 2 then (case seq_002.currval when 2  then 2 else 4 end)  else 0 end, 
fd_varchar1 varchar(100) default TRIM(LEADING 'a' FROM TRIM(TRAILING 'b' FROM 'aaaaaaccccccbbbbb')), 
fd_varchar2 varchar(100) default IF('TRUE', IF (0, 'no', 'yes'), 'no'));
insert into default_update_t3 (fd_int0) values(0);
insert into default_update_t3 (fd_int0) values(1);
insert into default_update_t3 (fd_int0) values(2);
insert into default_update_t3 (fd_int0) values(3);
insert into default_update_t3 (fd_int0) values(4);
select * from default_update_t3 order by fd_int0;
update default_update_t3 set fd_varchar1 = 'ddddddd' where fd_int0 = 0;
update default_update_t3 set fd_varchar1 = 'ddddddd' where fd_int0 = 1;
update default_update_t3 set fd_varchar1 = 'ddddddd' where fd_int0 = 2;
update default_update_t3 set fd_varchar1 = 'ddddddd' where fd_int0 = 3;
update default_update_t3 set fd_varchar1 = 'ddddddd' where fd_int0 = 4;
select * from default_update_t3 order by fd_int0;
drop table default_update_t3;
drop sequence seq_002;
drop sequence seq_001;


drop table t_join_table_base;
CREATE TABLE t_join_table_base(id int, c_dsval interval day(7) to second(5));
delete from t_join_table_base;
INSERT INTO t_join_table_base VALUES(5, '-1234 0:0:0.0004');
INSERT INTO t_join_table_base VALUES(5, null);
INSERT INTO t_join_table_base VALUES(5, null);
commit;
create table aa100 as select t1.c_dsval,null c from t_join_table_base t1 union select null,t1.c_dsval from t_join_table_base t1;
select count(*) from aa100;
drop table aa100;
drop table t_join_table_base;

--tablename has special char
CREATE TABLE "hgqioh"gqeri"(f1 int);
CREATE TABLE "hgqioh""gqeri"(f1 int);
CREATE TABLE "hgqioh\"\"gqeri"(f1 int);

drop table if exists t_create_table1;
create table t_create_table1(f1 int);
alter table t_create_table1 rename to "hgqioh""gqeri";
alter table t_create_table1 rename column f1 xxx f2;
alter table t_create_table1 rename column f1 to f2;
desc t_create_table1;
drop table t_create_table1;

--external table error test
drop table if exists t_create_table1;
create table afatest6 (
    test1    int unique auto_increment,-- primary key auto_increment not null, 
    test2    int, --unique auto_increment,
    text    varchar(10)
)
organization external(
  type loader
  directory '.'
  access parameters (
    records delimited by newline
    fields terminated by ','
  )
  location 'error_test'
);

create table Student12  --current not suppport the symbol of Unicode
(
StudentSex nvarchar(2) CHECK(StudentSex=N'男' or StudentSex=N'女') 
);
drop table if exists t_sub_query_001;
drop table if exists t_ct_sub_137;
drop table if exists t_ct_sub_138;
drop table if exists t_ct_sub_139;
create table t_sub_query_001(id int,c_int int not null,c_vchar varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date)
partition by range (c_int)
(partition t001_1 values less than (1000),
partition t001_2 values less than (2000),partition t001_3 values less than (4000),
partition t001_4 values less than (maxvalue)
);
insert into t_sub_query_001 values(1,1000,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
FOR i IN startall..endall LOOP
sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_vchar||'||i||',c_clob||'||i||',c_blob'||',c_date from '||tname|| ' where id=1';
execute immediate sqlst;
END LOOP;
END;
/
exec proc_insert('t_sub_query_001',1,5);
commit;
create table t_ct_sub_137 as select stddev_pop((select c_int from t_sub_query_001 t2 where t1.id=t2.id)) over(PARTITION BY id order by 1) c from t_sub_query_001 t1; 
create table t_ct_sub_138 as select row_number((select c_int from t_sub_query_001 t2 where t1.id=t2.id)) over(PARTITION BY id order by 1) c from t_sub_query_001 t1; 
create table t_ct_sub_139 as select *,row_number() over(PARTITION BY id order by c_int) num  from t_sub_query_001;
drop table if exists t_sub_query_001;
drop table if exists t_ct_sub_137;
drop table if exists t_ct_sub_138;
drop table if exists t_ct_sub_139;
drop table if exists t_order_base_000;
drop table if exists t_ct_sub_062;
CREATE TABLE t_order_base_000("ID" INT NOT NULL, "CHR_FIELD" VARCHAR(30), "VALUE" NUMBER);
insert into t_order_base_000 select rownum, decode(mod(rownum, 2), 0, NULL, rpad('CHR_', 10, chr(rownum + 64))), decode(mod(rownum, 3), 0, NULL, rownum * 10000) from dual connect by rownum < 6;
commit;
create table t_ct_sub_062(c1 default 'aaa' constraint t_ct_sub_062con check(c1 is not null) unique) as select distinct CHR_FIELD c1 from t_order_base_000 where CHR_FIELD is not null order by c1 desc nulls last;
select distinct CHR_FIELD c1 from t_order_base_000 where CHR_FIELD is not null order by c1 desc nulls last;
select * from t_ct_sub_062;
drop table if exists t_order_base_000;
drop table if exists t_ct_sub_062;
drop table if exists  t_ct_sub_06o;
create table t_ct_sub_06o(c1 int default 5 constraint t_ct_sub_062con primary key constraint t_ct_sub_062con1 primary key, age int);
select CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME from all_constraints where TABLE_NAME like  'T_CT_SUB_06O' order by CONSTRAINT_NAME asc;
drop table if exists  t_ct_sub_06o;
create table t_ct_sub_06o(c1 int default 5 constraint t_ct_sub_062con check(c1 > 2) constraint t_ct_sub_062con1 check(c1 > 3));   
select CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME from all_constraints where TABLE_NAME like  'T_CT_SUB_06O' order by CONSTRAINT_NAME asc;
drop table if exists  t_ct_sub_06o;                    
create table t_ct_sub_06o(c1 varchar(10) default 'aaa' constraint t_ct_sub_062con check(c1 is not null) constraint t_ct_sub_062con1 unique); 
select CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME from all_constraints where TABLE_NAME like  'T_CT_SUB_06O' order by CONSTRAINT_NAME asc;
drop table if exists  t_ct_sub_06o;
drop table if exists caojiebao_059_1;
drop table if exists caojiebao_059_2;
drop table if exists t_cao;
create table caojiebao_059_1(c1 varchar(10),c2 int,constraint caojiebao_059_1con primary key(c1));
create table caojiebao_059_2(c1 varchar(10),c2 int,constraint caojiebao_059_2con unique(c1));
insert into caojiebao_059_1 values('a',2);
insert into caojiebao_059_2 values('a',2);
create table caojiebao_059_2_for(c1 varchar(10) constraint caojiebao_059_2con_for  references caojiebao_059_2(c1) ON DELETE SET NULL,c2 int);
select CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME from all_constraints where TABLE_NAME = 'CAOJIEBAO_059_2_FOR';
drop table if exists caojiebao_059_2_for;
create table caojiebao_059_2_for(c1 varchar(10) constraint caojiebao_059_2con_for  references caojiebao_059_2(c1) ON DELETE SET NULL,c2 int, constraint caojiebao_059_2con_for_1  foreign  key (c1) references caojiebao_059_2(c1) ON DELETE SET NULL);
select CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME from all_constraints where TABLE_NAME = 'CAOJIEBAO_059_2_FOR';
drop table if exists caojiebao_059_2_for;
create table caojiebao_059_2_for(c1 varchar(10) constraint caojiebao_059_2con_for  references caojiebao_059_2(c1) ON DELETE SET NULL,c2 int, constraint caojiebao_059_2con_for_1  foreign  key (c1) references caojiebao_059_1(c1) ON DELETE SET NULL);
select CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME from all_constraints where TABLE_NAME = 'CAOJIEBAO_059_2_FOR' order by CONSTRAINT_NAME;
drop table if exists caojiebao_059_2_for;
drop table if exists t_ct_sub_059_1;
create table t_ct_sub_059_1(c1 varchar(10),c2 int,constraint t_ct_sub_059_1con primary key(c1));
insert into t_ct_sub_059_1 values('a',2);
drop table if exists t_ct_sub_059;
create table t_ct_sub_059(c1 constraint t_ct_sub_059con references t_ct_sub_059_1(c1) ON DELETE SET NULL,c2 constraint t_ct_sub_059con2 references t_ct_sub_059_1(c1) ON DELETE SET NULL) as select * from t_ct_sub_059_1;
drop table if exists t_ct_sub_059_1;
drop table if exists caojiebao_059_1;
drop table if exists caojiebao_059_2;
create table cao025(c2 int) PARTITION BY RANGE (c2) INTERVAL(10) (partition p11 values less than (10), partition p12 values less than (1000), partition p13 values less than (maxvalue)) ;
create global temporary table gt_ct_sub_0032(c int) ON COMMIT DELETE ROWS ON COMMIT PRESERVE ROWS;
drop table if exists t_ct_sub_155;
CREATE TABLE t_ct_sub_155( 
C_INTEGER INTEGER,
C_CLOB CLOB, 
C_BLOB BLOB
) PCTFREE 10 INITRANS 10 
LOB(C_BLOB) STORE AS(ENABLE STORAGE IN ROW)
LOB(C_BLOB) STORE AS(ENABLE STORAGE IN ROW)
LOB(C_CLOB) STORE AS(ENABLE STORAGE IN ROW);
drop table if exists t_order_base_000;
drop table if exists t_ct_sub_034;
CREATE TABLE t_order_base_000("ID" INT NOT NULL, "CHR_FIELD" VARCHAR(30), "VALUE" int);
insert into t_order_base_000 values(1,'abc',10);
create table t_ct_sub_034(c2 primary key AUTO_INCREMENT) as select CHR_FIELD  from t_order_base_000; 
create table t_ct_sub_034(c1 default 'aaa',c2 primary key AUTO_INCREMENT) as select CHR_FIELD c1,value c2 from t_order_base_000; 
select AUTO_INCREMENT from  ADM_TAB_COLUMNS where table_name='T_CT_SUB_034' order by AUTO_INCREMENT asc;
drop table if exists t_order_base_000;
drop table if exists t_ct_sub_034;

-- union rs_columns
drop table if exists t_createas_1;
drop table if exists t_createas_2;
drop table if exists t_createas_3;
create table t_createas_1(f1 number(10), f2 decimal(10), f3 decimal(10));
create table t_createas_2(f1 number(10), f2 decimal(10), f3 decimal(10));
create table t_createas_3(f1 decimal(15), f2 number(15), f3 number);
desc -q select * from t_createas_1 union select * from t_createas_2;
desc -q select * from t_createas_1 union select * from t_createas_3;
drop table t_createas_1;
drop table t_createas_2;
drop table t_createas_3;

drop table if exists SYS_CTRL_PARAM_DEF;
drop table if exists SYS_CTRL_PARAM_CFG;
drop view if exists SYS_CTRL_PARAM;
create table SYS_CTRL_PARAM_DEF
(
   GROUP_CODE                   VARCHAR2(63) NOT NULL,
   PARAM_CODE                   VARCHAR2(63) NOT NULL,
   BE_ID                        NUMBER(10) NOT NULL,
   BE_CODE                      VARCHAR2(256),
   EDIT_METHOD                  VARCHAR2(1),
   DATA_TYPE                    VARCHAR2(1),
   VALUE                        VARCHAR2(127),
   NAME                         VARCHAR2(63),
   NOTE                         VARCHAR2(256),
   EXTEND_ITEM_ID               NUMBER(10),
   CONF_FLAG                    VARCHAR2(1),
   DATA_VALIDATOR               VARCHAR2(256),
   FEATURE_NAME                 VARCHAR2(256)
);
create table SYS_CTRL_PARAM_CFG
(
   GROUP_CODE                   VARCHAR2(63) NOT NULL,
   PARAM_CODE                   VARCHAR2(63) NOT NULL,
   BE_ID                        NUMBER(10) NOT NULL,
   BE_CODE                      VARCHAR2(256),
   EDIT_METHOD                  VARCHAR2(1),
   DATA_TYPE                    VARCHAR2(1),
   VALUE                        VARCHAR2(127),
   NAME                         VARCHAR2(63),
   NOTE                         VARCHAR2(256),
   EXTEND_ITEM_ID               NUMBER(10),
   CONF_FLAG                    VARCHAR2(1),
   DATA_VALIDATOR               VARCHAR2(256),
   FEATURE_NAME                 VARCHAR2(256)
);
create view SYS_CTRL_PARAM(GROUP_CODE,PARAM_CODE,BE_ID,BE_CODE,EDIT_METHOD,DATA_TYPE,VALUE,NAME,NOTE,EXTEND_ITEM_ID,CONF_FLAG,FEATURE_NAME) AS SELECT B.GROUP_CODE,B.PARAM_CODE,B.BE_ID,B.BE_CODE,B.EDIT_METHOD,B.DATA_TYPE,B.VALUE,B.NAME,B.NOTE,B.EXTEND_ITEM_ID,B.CONF_FLAG,B.FEATURE_NAME FROM SYS_CTRL_PARAM_CFG B UNION SELECT A.GROUP_CODE,A.PARAM_CODE,A.BE_ID,A.BE_CODE,A.EDIT_METHOD,A.DATA_TYPE,A.VALUE,A.NAME,A.NOTE,A.EXTEND_ITEM_ID,A.CONF_FLAG,A.FEATURE_NAME FROM SYS_CTRL_PARAM_DEF A where (A.GROUP_CODE,A.PARAM_CODE) NOT IN (select B.GROUP_CODE,B.PARAM_CODE from SYS_CTRL_PARAM_CFG B);
desc SYS_CTRL_PARAM;
drop table SYS_CTRL_PARAM_DEF;
drop table SYS_CTRL_PARAM_CFG;
drop view SYS_CTRL_PARAM;
--DTS2019070207776
drop table if exists origin;
create table origin(id int, name char(10) not null, read int);
insert into origin values(1, 'fhd', 1520);
insert into origin values(3, 'fer', 45848);
drop table if exists tabnew;
create table tabnew(id_new, name_new,read_new) as select * from origin;
insert into tabnew values(5, null, 526);

drop table if exists t_not_null_t1;
drop table if exists t_not_null_t2;
create table t_not_null_t1(c_char char(10));
create table t_not_null_t2(c3 not null) as select c_char||c_char c3 from t_not_null_t1;
desc t_not_null_t2;

drop temporary table if exists #ma_temp;
alter system set  LOCAL_TEMPORARY_TABLE_ENABLED =true;
create temporary table #ma_temp(id int, name char(10) not null, read int);
create public synonym table_origin for #ma_temp;
drop temporary table #ma_temp;
alter system set  LOCAL_TEMPORARY_TABLE_ENABLED =false;

create table test_tb_PROC_006(c_int int,
c_number number,
c_varchar varchar(80),
c_date date);


CREATE OR REPLACE PROCEDURE  PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_006()
IS
b_sql varchar2(3000) ;
BEGIN
 for i in 1..2
 loop
     b_sql :='drop table if exists test_tb_PROC_006';
  execute immediate b_sql;

  b_sql :='drop index if exists test1_inx on test_tb_PROC_006';
  execute immediate b_sql;

  b_sql :='create table test_tb_PROC_006(c_int int,
c_number number,
c_varchar varchar(80),
c_date date)';
  execute immediate b_sql;

  b_sql:='create index test1_inx on test_tb_PROC_006(c_date) ';
  execute immediate b_sql;

  b_sql :='drop table if exists test_tb_PROC_006';
  execute immediate b_sql;

  b_sql :='drop index if exists test1_inx on test_tb_PROC_006';
  execute immediate b_sql;
 end loop;

END;
/

call PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_006();

--DTS2019091803372
alter system set LOCAL_TEMPORARY_TABLE_ENABLED = true;
DROP TABLE IF EXISTS #ZSCREATE_B003;
CREATE TEMPORARY TABLE #ZSCREATE_B003 (COL_14 BINARY_DOUBLE DEFAULT 1846345728 / (6 + 1) ON UPDATE NULL ,COL_15 UINT DEFAULT 1e1 ON UPDATE 11) LOB (COL_14,COL_15) STORE AS (TABLESPACE zs_tablespace3) APPENDONLY ON CRMODE ROW;
CREATE TEMPORARY TABLE #ZSCREATE_B003 (COL_26 TIMESTAMP(1) DEFAULT TO_TIMESTAMP('2008-08-27 09:39:03', 'YYYY-MM-DD HH24:Mi:SS') ON UPDATE TO_TIMESTAMP('2011-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') );
DROP TABLE IF EXISTS #ZSCREATE_B003;
CONN / AS SYSDBA
DROP USER IF EXISTS LINSHI1;
DROP USER IF EXISTS LINSHI2;
DROP TABLE IF EXISTS TT1;
DROP TABLE IF EXISTS TT2;
CREATE USER LINSHI1 IDENTIFIED BY CANTIAN_234;
CREATE USER LINSHI2 IDENTIFIED BY CANTIAN_234;
CREATE TABLE TT1(ID INT);
CREATE TABLE TT2(ID INT);
INSERT INTO TT1 VALUES(1);
INSERT INTO TT2 VALUES(2);
CREATE TEMPORARY TABLE LINSHI1.#LOCAL_TEMP_TBL_012 AS SELECT * FROM TT1;
CREATE TEMPORARY TABLE LINSHI2.#LOCAL_TEMP_TBL_012 AS SELECT * FROM TT2;
SELECT * FROM LINSHI1.#LOCAL_TEMP_TBL_012;
SELECT * FROM LINSHI2.#LOCAL_TEMP_TBL_012;
DROP USER IF EXISTS LINSHI1;
DROP USER IF EXISTS LINSHI2;
DROP TABLE IF EXISTS TT1;
DROP TABLE IF EXISTS TT2;
alter system set LOCAL_TEMPORARY_TABLE_ENABLED = false;

--DTS2019091603759
DROP TABLE IF EXISTS test_blob_default; 
CREATE TABLE test_blob_default (COL_14 blob DEFAULT ' 0 ');
CREATE TABLE test_blob_default (COL_14 blob DEFAULT '0');
desc test_blob_default;
DROP TABLE IF EXISTS test_blob_default; 
CREATE TABLE test_blob_default (COL_14 blob DEFAULT '0',id int);
insert into test_blob_default(id) values(3);
commit;
select * from test_blob_default;
DROP TABLE IF EXISTS test_blob_default; 

--DTS2019081004379
drop table if exists t_avg_base_001;
drop table if exists t_avg_101;
create table t_avg_base_001(id number,deptno number,name varchar2(20),sal number);
insert into t_avg_base_001 values(1,1,'1aa',120);
insert into t_avg_base_001 values(2,1,'2aa',300);
insert into t_avg_base_001 values(3,1,'3aa',100);
insert into t_avg_base_001 values(4,1,'4aa',99);
insert into t_avg_base_001 values(5,1,'5aa',90);
insert into t_avg_base_001 values(6,2,'6aa',87);
insert into t_avg_base_001 values(7,2,'7aa',500);
insert into t_avg_base_001 values(8,2,'8aa',200);
insert into t_avg_base_001 values(9,2,'9aa',20);
insert into t_avg_base_001 values(10,2,'10aa',30);
insert into t_avg_base_001 values(null,2,'10aa',30);
insert into t_avg_base_001 values(12,2,'10aa',null);
commit;
create table t_avg_101 as select id,avg(sal) over(partition by deptno order by id) c from t_avg_base_001 t1 group by id,sal,deptno ;
select  * from t_avg_101  order by id;
drop table t_avg_base_001;
drop table t_avg_101;

--DTS2019092502068
drop table if exists nchar_test;
create table nchar_test(col nchar(20 byte));
create table nchar_test(col nchar(20 char));
create table nchar_test(col nchar(20));
desc nchar_test;
alter table nchar_test modify col NCHAR(20 byte);
alter table nchar_test modify col NCHAR(20 char);
drop table if exists nchar_test;
drop table if exists nvarchar_test;
create table nvarchar_test(col nvarchar(20 byte));
create table nvarchar_test(col nvarchar(20 char));
create table nvarchar_test(col nvarchar(20));
alter table nvarchar_test modify col nvarchar(20 byte);
alter table nvarchar_test modify col nvarchar(20 char);
desc nvarchar_test;
drop table if exists nvarchar_test;

--DTS2019091206375
CREATE TABLE T_TEST_LOB_STORE (COL_1 DATE,COL_2 blob) LOB(COL_2,COL_2) STORE AS (DISABLE STORAGE IN ROW) ;
CREATE TABLE T_TEST_LOB_STORE (COL_1 DATE,COL_2 blob) LOB(COL_1/COL_1) STORE AS (DISABLE STORAGE IN ROW) ;
CREATE TABLE T_TEST_LOB_STORE (COL_1 DATE,COL_2 blob) LOB(COL_1,COL_4) STORE AS (DISABLE STORAGE IN ROW) ;
CREATE TABLE T_TEST_LOB_STORE (COL_1 DATE,COL_2 blob) LOB(COL_2,COL_4) STORE AS (DISABLE STORAGE IN ROW) ;

drop table if exists test_table;
CREATE TABLE test_table(c1 int, c2 varchar(32), c3 bigint) pctfree 0;
select pctfree from sys_tables where name = 'TEST_TABLE';
drop table if exists test_table;
--DTS2019111503041
drop table if exists t_sql_cancel_001_001;
drop table if exists t_sql_cancel_102_001;
drop table if exists t_sql_cancel_106_001;
create table t_sql_cancel_001_001(id int not null,c_int int,c_vchar varchar(55) not null,c_vchar2 varchar(55) not null,c_blob blob not null,c_date date)
PARTITION BY RANGE(id) interval(10)
(
PARTITION p1 VALUES LESS THAN(100),
PARTITION p2 VALUES LESS THAN(200),
PARTITION p3 VALUES LESS THAN(300)
);
 
insert into t_sql_cancel_001_001 values(1,100,'abc123',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
 
CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
        sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_vchar||'||i||',c_vchar2||'||i||',c_blob'||',c_date from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/
exec proc_insert('t_sql_cancel_001_001',1,50);
exec proc_insert('t_sql_cancel_001_001',10,30);
commit;

create table t_sql_cancel_102_001 as SELECT t0.* from (select * from (select c_vchar,c_int from t_sql_cancel_001_001) PIVOT(MAX(length(c_vchar)) FOR c_vchar IN ('abc1233' c1,'abc12333' c2))) t0;
desc t_sql_cancel_102_001;
create table t_sql_cancel_106_001 as select t0.* from (select * from t_sql_cancel_102_001 unpivot(bbb for aaa in (c1 as 'abc',c2 as 'def'))) t0;
desc t_sql_cancel_106_001;
drop table t_sql_cancel_001_001;
drop table t_sql_cancel_102_001;
drop table t_sql_cancel_106_001;

CREATE TABLE TEST_STORAGE(c_id int) STORAGE(INITIAL  120K);
SELECT INITIAL_PAGES FROM SYS_STORAGE WHERE ORG_SCN = (SELECT ORG_SCN FROM SYS_TABLES WHERE NAME ='TEST_STORAGE');
INSERT INTO TEST_STORAGE VALUES(1);
SELECT PAGES FROM DBA_SEGMENTS WHERE SEGMENT_TYPE='TABLE' AND SEGMENT_NAME ='TEST_STORAGE';
DROP TABLE TEST_STORAGE;
SELECT INITIAL_PAGES FROM SYS_STORAGE;

drop table if exists test_storage;
create table test_storage(c1 int, c2 int) storage(initial 120K) partition by hash(c1,c2) partitions 16;
drop table if exists test_storage;

drop table if exists test_storage;
create table test_storage(c_id int) storage(initial  120k) nologging;
drop table if exists test_storage;

drop table if exists test_storage;
create global temporary table test_storage(c1 int) storage(initial 120k);
drop table if exists test_storage;

alter system set LOCAL_TEMPORARY_TABLE_ENABLED=true;
drop table if exists #test_storage;
create temporary table #test_storage(c1 int) storage( initial 120K);
drop table if exists #test_storage;
alter system set LOCAL_TEMPORARY_TABLE_ENABLED=false;

DROP TABLE IF EXISTS tbl_base;
CREATE TABLE tbl_base (id INT);
INSERT INTO tbl_base VALUES (1);
COMMIT;
DROP TABLE IF EXISTS tbl_base1;
CREATE TABLE tbl_base1 AS SELECT SQL_CALC_FOUND_ROWS  * FROM tbl_base;

--test INI_TRANS
ALTER SYSTEM SET INI_TRANS = 3;
DROP TABLE IF EXISTS TEST_INITRANS3;
DROP TABLE IF EXISTS TEST_INITRANS4;
DROP USER IF EXISTS user_initrans CASCADE;

CREATE USER user_initrans IDENTIFIED BY Cantian_234;
CREATE TABLE user_initrans.TEST_INITRANS(post_id CHAR(2) NOT NULL, post_name CHAR(6));
CREATE TABLE user_initrans.TEST_INITRANS2(post_id CHAR(2) NOT NULL, post_name CHAR(6)) INITRANS 4;
CREATE INDEX IDX_TEST_INITRANS ON user_initrans.TEST_INITRANS(post_id ASC);
CREATE INDEX IDX_TEST_INITRANS2 ON user_initrans.TEST_INITRANS2(post_id ASC) INITRANS 5;

CREATE TABLE TEST_INITRANS3(post_id CHAR(2) NOT NULL, post_name CHAR(6));
CREATE TABLE TEST_INITRANS4(post_id CHAR(2) NOT NULL, post_name CHAR(6)) INITRANS 4;
CREATE INDEX IDX_TEST_INITRANS3 ON TEST_INITRANS3(post_id ASC);
CREATE INDEX IDX_TEST_INITRANS4 ON TEST_INITRANS4(post_id ASC) INITRANS 5;

select NAME, INITRANS from SYS_TABLES where NAME = 'TEST_INITRANS';
select NAME, INITRANS from SYS_TABLES where NAME = 'TEST_INITRANS2';
select NAME, INITRANS from SYS_TABLES where NAME = 'TEST_INITRANS3';
select NAME, INITRANS from SYS_TABLES where NAME = 'TEST_INITRANS4';
select NAME, INITRANS from SYS_INDEXES where NAME = 'IDX_TEST_INITRANS';
select NAME, INITRANS from SYS_INDEXES where NAME = 'IDX_TEST_INITRANS2';
select NAME, INITRANS from SYS_INDEXES where NAME = 'IDX_TEST_INITRANS3';
select NAME, INITRANS from SYS_INDEXES where NAME = 'IDX_TEST_INITRANS4';

ALTER SYSTEM SET INI_TRANS = 2;
DROP TABLE IF EXISTS TEST_INITRANS3;
DROP TABLE IF EXISTS TEST_INITRANS4;
DROP USER IF EXISTS user_initrans CASCADE;
--DTS202009090JWVQGP1F00
drop table if exists t_default_check_015;
create table t_default_check_015(id int,c_int int default array_length(array[1,2]));
insert into t_default_check_015 (id) values(1);
select * from t_default_check_015;
drop table if exists t_default_check_015;
create table t_default_check_015(id int,c_int int default array_length(array['abc', 'def']));
insert into t_default_check_015 (id) values(1);
select * from t_default_check_015;
drop table if exists t_default_check_015;
create table t_default_check_015(id int,c_char varchar(8) default array_length(array['abc', 'def']));
insert into t_default_check_015 (id) values(1);
select * from t_default_check_015;
drop table if exists t_default_check_015;
create table t_default_check_015(id int,c_int int default array_length('{ghi, ddd}'));
insert into t_default_check_015 (id) values(1);
select * from t_default_check_015;
drop table if exists t_default_check_015;
create table t_default_check_015(id int,c_int int default length('{ghi, ddd}'));
insert into t_default_check_015 (id) values(1);
select * from t_default_check_015;

drop table if exists t_default_check_015;
create table t_default_check_015(id int,c_int int default array[1,2]);
create table t_default_check_015(id int,c_char varchar(8) default array['abc', 'def']);
create table t_default_check_015(id int,c_char varchar(16)[] default '{ghi, ddd}');
create table t_default_check_015(id int,c_int int default length(array[1,2]));

drop table if exists t_connect_base_001;
create table t_connect_base_001(
    emp_id number(18),
    lead_id number(18),
    emp_name varchar2(200),
    salary number(10,2),
    dept_no varchar2(8)
);
insert into t_connect_base_001 values(3,1,'arise',60000.00,'003');
insert into t_connect_base_001 values(4,2,'scott',30000.00,'002');
insert into t_connect_base_001 values(1,0,'king',1000000.00,'001');
insert into t_connect_base_001 values(2,1,'jack',50500.00,'002');
insert into t_connect_base_001 values(5,2,'tiger',25000.00,'002');
commit;
drop table if exists t_connect_base_101;
create table t_connect_base_101 as select sys_connect_by_path(lpad('abc',1,'1'),'/') c from t_connect_base_001 start with emp_id=1 connect by prior emp_id = lead_id+3 order by 1;
drop table t_connect_base_001;
drop table t_connect_base_101;

drop table if exists default_lnnvl_t;
create table default_lnnvl_t(c1 int,c2 boolean default lnnvl('TRUE'));
insert into default_lnnvl_t(c1) values(1);
select * from default_lnnvl_t;
drop table default_lnnvl_t;