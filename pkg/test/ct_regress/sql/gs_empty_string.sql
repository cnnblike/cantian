--if there has err, make sure mofity synchronized with ctsql_test:sql_empty_string.sql
--mysql empty string is not null;
alter system set empty_string_as_null = false;
drop table if exists tbl_nelicTask;
CREATE TABLE tbl_nelicTask ( a VARCHAR(255) null, b CLOB NULL, c varchar(10) default 'abc');
select * from USER_tab_columns where TABLE_NAME=upper('tbl_nelicTask') AND DATA_DEFAULT IS NULL order by COLUMN_NAME;
select * from USER_tab_columns where TABLE_NAME=upper('tbl_nelicTask') AND DATA_DEFAULT = ''  order by COLUMN_NAME;
ALTER TABLE tbl_nelicTask ADD d varchar(10) default '';
alter table tbl_nelicTask modify c default 'aasdfasd';
select * from USER_tab_columns where TABLE_NAME=upper('tbl_nelicTask') AND DATA_DEFAULT IS NULL  order by COLUMN_NAME;
select * from USER_tab_columns where TABLE_NAME=upper('tbl_nelicTask') AND DATA_DEFAULT = ''''''  order by COLUMN_NAME;
drop table tbl_nelicTask;
--20200113
select substr(dummy,null) from sys_dummy group by substr(dummy,'');
select substr(dummy,lpad(null,1)) from sys_dummy group by substr(dummy,'');
select substr(dummy,lpad(null,1)) from sys_dummy group by substr(dummy,lpad('a',1));
-- insert select clob which is empty string
drop table if exists t_empty_str_clob1;
drop table if exists t_empty_str_clob2;
create table t_empty_str_clob1(f1 clob);
insert into t_empty_str_clob1 values('');
select f1, lengthb(f1) from t_empty_str_clob1;
commit;
create table t_empty_str_clob2 as select * from t_empty_str_clob1;
select f1, lengthb(f1) from t_empty_str_clob2;
drop table t_empty_str_clob1;
drop table t_empty_str_clob2;

drop table if exists t_empty_str_str1;
drop table if exists t_empty_str_str2;
drop table if exists t_empty_str_clob;
create table t_empty_str_str1(f1 varchar(10));
create table t_empty_str_str2(f1 varchar(10));
insert into t_empty_str_str2 values('');
create table t_empty_str_clob(f1 clob);
insert into t_empty_str_clob values('');
insert into t_empty_str_str1 select * from t_empty_str_str2;
insert into t_empty_str_str1 select * from t_empty_str_clob;
select f1, lengthb(f1) from t_empty_str_str1;
drop table t_empty_str_str1;
drop table t_empty_str_str2;
drop table t_empty_str_clob;

select to_number(10.1234,   '') from dual;

drop table if exists emptyStr;
--insert
create table emptyStr(c varchar(5));
insert into emptyStr values(''),('');
insert into emptyStr values('abc');
select c,length(c) from emptyStr where c is null;
select c,length(c) from emptyStr where c = '';
select c,length(c),count(c) from emptyStr group by c order by c;

--like
select * from emptyStr where c like '' order by c;
select * from emptyStr where c like '%' order by c;
select * from emptyStr where c like 'a%' order by c;
select * from emptyStr where c like '_%_' order by c;
select * from emptyStr where c like '%c' order by c;
select * from emptyStr where c like '_' order by c;

select * from emptyStr where c like '' escape '_' order by c;
select * from emptyStr where c like '%' escape '_' order by c;
select * from emptyStr where c like 'a%' escape '_' order by c;
select * from emptyStr where c like '_%_' escape '_' order by c;
select * from emptyStr where c like '%c' escape '_' order by c;

select * from dual where '' like '%';
select * from dual where '' like '';

--function
--substr
select substr('123',1,3) from dual;
select c,length(c),substr(c,1,3) from emptyStr order by c;
select 1 from dual where substr('123',1,-10) = '';
select 1 from dual where substr('123',1,-10) is null;
select 1 from dual where substr('123',5,2) = '';
select 1 from dual where substr('123',5,2) is null;
select 1 from dual where substr('',1,2) is null;
select 1 from dual where substr('',1,2) = '';
select 1 from dual where substr(null,1,2) is null;
select 1 from dual where substr(null,1,2) = '';
--concat
select concat('123','a') from dual;
select c,length(c),concat('123','a') from emptyStr order by c;
select 1 from dual where concat('123','') = '';
select 1 from dual where concat('123','') is null;
select 1 from dual where concat('','123') = '';
select 1 from dual where concat('','123') is null;
select 1 from dual where concat('','') is null;
select 1 from dual where concat('','') = '';
select 1 from dual where concat(null,'') is null;
select 1 from dual where concat(null,'') = '';
select 1 from dual where concat('',null) is null;
select 1 from dual where concat('',null) = '';
select 1 from dual where concat(null,null) is null;
select 1 from dual where concat(null,null) = '';
--concat_ws
select concat_ws('123','a') from dual;
select c,length(c),concat_ws('123','a') from emptyStr order by c;
select 1 from dual where concat_ws('123','') = '';
select 1 from dual where concat_ws('123','') is null;
select 1 from dual where concat_ws('','123') = '';
select 1 from dual where concat_ws('','123') is null;
select 1 from dual where concat_ws('','') is null;
select 1 from dual where concat_ws('','') = '';
select 1 from dual where concat_ws(null,'') is null;
select 1 from dual where concat_ws(null,'') = '';
select 1 from dual where concat_ws('',null) is null;
select 1 from dual where concat_ws('',null) = '';
select 1 from dual where concat_ws(null,null) is null;
select 1 from dual where concat_ws(null,null) = '';
--left
select left('123',1) from dual;
select c,length(c),left(c,1) from emptyStr order by c;
select 1 from dual where left('123',0) = '';
select 1 from dual where left('123',0) is null;
select 1 from dual where left('123',5) = '';
select 1 from dual where left('123',5) is null;
select 1 from dual where left('',1) is null;
select 1 from dual where left('',1) = '';
select 1 from dual where left(null,1) is null;
select 1 from dual where left(null,1) = '';
--right
select right('123',1) from dual;
select c,length(c),right(c,1) from emptyStr order by c;
select 1 from dual where right('123',0) = '';
select 1 from dual where right('123',0) is null;
select 1 from dual where right('123',5) = '';
select 1 from dual where right('123',5) is null;
select 1 from dual where right('',1) is null;
select 1 from dual where right('',1) = '';
select 1 from dual where right(null,1) is null;
select 1 from dual where right(null,1) = '';
--lpad
select lpad('123',4, '*') from dual;
select c,length(c),lpad('123',4, '*') from emptyStr order by c;
select 1 from dual where lpad('', 4, '*') = '';
select 1 from dual where lpad('', 4, '*') is null;
select 1 from dual where lpad(null, 4, '*') = '';
select 1 from dual where lpad(null, 4, '*') is null;
select 1 from dual where lpad('123', 0, '*') = '';
select 1 from dual where lpad('123', 0, '*') is null;
select 1 from dual where lpad('123', -1, '*') = '';
select 1 from dual where lpad('123', -1, '*') is null;
select 1 from dual where lpad('123', 4, '') = '';
select 1 from dual where lpad('123', 4, '') is null;
select 1 from dual where lpad('123', 4, null) = '';
select 1 from dual where lpad('123', 4, null) is null;
--rpad
select rpad('123',4, '*') from dual;
select c,length(c),rpad('123',4, '*') from emptyStr order by c;
select 1 from dual where rpad('', 4, '*') = '';
select 1 from dual where rpad('', 4, '*') is null;
select 1 from dual where rpad(null, 4, '*') = '';
select 1 from dual where rpad(null, 4, '*') is null;
select 1 from dual where rpad('123', 0, '*') = '';
select 1 from dual where rpad('123', 0, '*') is null;
select 1 from dual where rpad('123', -1, '*') = '';
select 1 from dual where rpad('123', -1, '*') is null;
select 1 from dual where rpad('123', 4, '') = '';
select 1 from dual where rpad('123', 4, '') is null;
select 1 from dual where rpad('123', 4, null) = '';
select 1 from dual where rpad('123', 4, null) is null;
--DBE_LOB.SUBSTR/DBE_LOB.get_length
select DBE_LOB.get_length('123') from dual;
select 1 from dual where DBE_LOB.get_length('') is null;
select 1 from dual where DBE_LOB.get_length('') = 0;
select 1 from dual where DBE_LOB.get_length(null) is null;
select 1 from dual where DBE_LOB.get_length(null) = 0;
select DBE_LOB.SUBSTR('123',1,3) from dual;
select c,length(c),DBE_LOB.SUBSTR(c,1,3) from emptyStr order by c;
select 1 from sys_dummy where DBE_LOB.SUBSTR('123',-10,1) = '';
select 1 from sys_dummy where DBE_LOB.SUBSTR('123',-10,1) is null;
select 1 from sys_dummy where DBE_LOB.SUBSTR('123',2,-1) = '';
select 1 from sys_dummy where DBE_LOB.SUBSTR('123',2,-1) is null;
select 1 from sys_dummy where DBE_LOB.SUBSTR('',1,3) is null;
select 1 from sys_dummy where DBE_LOB.SUBSTR('',1,3) = '';
select 1 from sys_dummy where DBE_LOB.SUBSTR(null,1,3) is null;
select 1 from sys_dummy where DBE_LOB.SUBSTR(null,1,3) = '';
--replacefunc
select 1 from dual where replace('abcc', 'abcc', '') = '';
select 1 from dual where replace('', 'abcc', 'xxx') = '';
--substring_index
select 1 from dual where substring_index('','',0) = '';
select 1 from dual where substring_index('asdas','a',0) = '';
select 1 from dual where substring_index('asdasd','',1) ='';
select 1 from dual where substring_index('','a',1) ='';
--space
select 1 from sys_dummy where space(0) = '';
--translate
select 1 from sys_dummy where translate('abc123','cba123','') = '';
select 1 from sys_dummy where translate('abc123','cba123',null) is null;
select 1 from sys_dummy where translate('abc123','','123') = '';
select 1 from sys_dummy where translate('abc123',null,'123') is null;
select 1 from sys_dummy where translate('','cba123','123') = '';
select 1 from sys_dummy where translate(null,'cba123','123') is null;

-- test export empty string/clob
create user exp_empty_str identified by Cantian_234;
grant dba to exp_empty_str;
create table exp_empty_str.exp_Haliluya(id int, c_lob clob, im image, bb blob, vchr varchar(200), ch char(30));
insert into exp_empty_str.exp_Haliluya values(1, null, null, null, null, null);
insert into exp_empty_str.exp_Haliluya values(2, '', '', '', '', '');
commit;

DROP TABLE IF EXISTS TBL_TASKRESULTINFO;
CREATE TABLE "TBL_TASKRESULTINFO"
(
  "TASKID" BINARY_INTEGER NOT NULL,
  "OPERATIONID" VARCHAR(255 BYTE) NOT NULL,
  "DEVID" BINARY_INTEGER NOT NULL,
  "FDN" VARCHAR(255 BYTE) NOT NULL DEFAULT '',
  "FRAMEID" BINARY_INTEGER NOT NULL,
  "SLOTID" BINARY_INTEGER NOT NULL,
  "ISUBSLOTID" BINARY_INTEGER NOT NULL,
  "STARTTIME" VARCHAR(21 BYTE),
  "ENDTIME" VARCHAR(21 BYTE),
  "FAILUREINFO" CLOB,
  "ERRORCODE" BINARY_DOUBLE,
  "RESULT" BINARY_INTEGER,
  "STATUS" BINARY_INTEGER,
  "OPERATIONSEQUENCE" BINARY_INTEGER,
  "STACKID" BINARY_INTEGER NOT NULL,
  "ERRORDETAIL" CLOB,
  "COMPARERESULT" BINARY_INTEGER,
  "ERROREXTDETAILS" CLOB,
  "IDETAILTYPE" BINARY_INTEGER,
  PRIMARY KEY("DEVID", "FDN", "FRAMEID", "ISUBSLOTID", "OPERATIONID", "SLOTID", "STACKID", "TASKID")
);
INSERT INTO "TBL_TASKRESULTINFO" ("TASKID","OPERATIONID","DEVID","FDN","FRAMEID","SLOTID","ISUBSLOTID","STARTTIME","ENDTIME","FAILUREINFO","ERRORCODE","RESULT","STATUS","OPERATIONSEQUENCE","STACKID","ERRORDETAIL","COMPARERESULT","ERROREXTDETAILS","IDETAILTYPE") VALUES
  (1550723093,'INSPECTOPTICALMODULEINFO',167772252,'',-1,-1,-1,'','','',-1,3,0,1,-1,NULL,NULL,NULL,NULL);
INSERT INTO "TBL_TASKRESULTINFO" ("TASKID","OPERATIONID","DEVID","FDN","FRAMEID","SLOTID","ISUBSLOTID","STARTTIME","ENDTIME","FAILUREINFO","ERRORCODE","RESULT","STATUS","OPERATIONSEQUENCE","STACKID","ERRORDETAIL","COMPARERESULT","ERROREXTDETAILS","IDETAILTYPE") VALUES
  (1550723093,'LOADOPTICALMODULESOFTWARE',167772252,'',-1,-1,-1,'','','',-1,3,0,2,-1,NULL,NULL,NULL,NULL);
INSERT INTO "TBL_TASKRESULTINFO" ("TASKID","OPERATIONID","DEVID","FDN","FRAMEID","SLOTID","ISUBSLOTID","STARTTIME","ENDTIME","FAILUREINFO","ERRORCODE","RESULT","STATUS","OPERATIONSEQUENCE","STACKID","ERRORDETAIL","COMPARERESULT","ERROREXTDETAILS","IDETAILTYPE") VALUES
  (1550723093,'UPGRADEOPTICALMODULESOFTWARE',167772252,'',-1,-1,-1,'','','',-1,3,0,3,-1,NULL,NULL,NULL,NULL);
select taskid, devid, fdn from tbl_TaskresultInfo where taskid=1550723093 and devid=167772252 and fdn ='';
DROP TABLE IF EXISTS TBL_TASKRESULTINFO;

-- export exp_Haliluya with empty_string_as_null = false;
exp users=exp_empty_str file="stdout";

--DTS2019052504272
drop table if exists t_inline_lob;
create table t_inline_lob(f1 int, f2 clob);
insert into t_inline_lob values(1, lpad('q',1976, 'q'));
insert into t_inline_lob values(2, lpad('q',1976, 'q'));
insert into t_inline_lob values(3, lpad('q',1976, 'q'));
insert into t_inline_lob values(4, lpad('q',1976, 'q'));
insert into t_inline_lob values(5, lpad('q',144, 'q'));
insert into t_inline_lob values(6, '');
commit;
select f2 from t_inline_lob order by f1;
drop table t_inline_lob;

--empty_string_as_null = false, test empty string in array 
drop table if exists t_empty_str_array;
create table t_empty_str_array(id int, name varchar(128)[]);
insert into t_empty_str_array values(1, array['', 'ss']);
insert into t_empty_str_array values(2, array[NULL, 'ss']);
commit;
select * from t_empty_str_array order by id;
drop table t_empty_str_array;

-- DTS202106070DRBROP0H00
select ascii(empty_clob()) from dual;

--oracle empty string is null;
alter system set empty_string_as_null = true;

select to_number(10.12342311, '') from dual;

-- export exp_Haliluya with empty_string_as_null = true;
exp users=exp_empty_str file="stdout";
drop user EXP_EMPTY_STR cascade;

--ignore
drop table if exists emptyStr;
--insert
create table emptyStr(c varchar(5));
insert into emptyStr values('');
insert into emptyStr values('');
insert into emptyStr values('abc');
select c,length(c) from emptyStr where c is null;
select c,length(c) from emptyStr where c = '';
select c,length(c),count(c) from emptyStr group by c order by c;

--like
select * from emptyStr where c LIKE '' order by c;
select * from emptyStr where c LIKE '%' order by c;
select * from emptyStr where c LIKE 'a%' order by c;
select * from emptyStr where c LIKE '_%_' order by c;
select * from emptyStr where c LIKE '%c' order by c;
select * from emptyStr where c LIKE '_' order by c;

select * from dual where '' LIKE '%';
select * from dual where '' LIKE '';

--function
--substr
select substr('123',1,3) from dual;
select 2 from dual where substr('123',1,-10) = '';
select 2 from dual where substr('123',1,-10) is null;
select 2 from dual where substr('123',5,2) = '';
select 2 from dual where substr('123',5,2) is null;
select 2 from dual where substr('',1,2) is null;
select 2 from dual where substr('',1,2) = '';
select 2 from dual where substr(null,1,2) is null;
select 2 from dual where substr(null,1,2) = '';
--concat
select concat('123','a') from dual;
select 2 from dual where concat('123','') = '';
select 2 from dual where concat('123','') is null;
select 2 from dual where concat('','123') = '';
select 2 from dual where concat('','123') is null;
select 2 from dual where concat('','') is null;
select 2 from dual where concat('','') = '';
select 2 from dual where concat(null,'') is null;
select 2 from dual where concat(null,'') = '';
select 2 from dual where concat('',null) is null;
select 2 from dual where concat('',null) = '';
select 2 from dual where concat(null,null) is null;
select 2 from dual where concat(null,null) = '';
--regexp_substr
select regexp_substr('abc', '[^b]+', 1, 1) from dual;
select c,length(c),regexp_substr(c, '[^b]+', 1, 1) r from emptyStr order by c;
select 1 from dual where regexp_substr('', '[^b]+', 1, 1) is null;
select 1 from dual where regexp_substr('', '[^b]+', 1, 1) = '';
select 1 from dual where regexp_substr('abc', '', 1, 1) is null;
select 1 from dual where regexp_substr('abc', '', 1, 1) = '';
select 1 from dual where regexp_substr('abc', '[^b]+', 5, 1) is null;
select 1 from dual where regexp_substr('abc', '[^b]+', 5, 1) = '';
select 1 from dual where regexp_substr('abc', '[^b]+', 1, 5) is null;
select 1 from dual where regexp_substr('abc', '[^b]+', 1, 5) = '';
select 1 from dual where regexp_substr(null, '[^b]+', 1, 1) is null;
select 1 from dual where regexp_substr(null, '[^b]+', 1, 1) = '';
select 1 from dual where regexp_substr('abc', null, 1, 1) is null;
select 1 from dual where regexp_substr('abc', null, 1, 1) = '';

--lpad
select lpad('123',4, '*') from dual;
select c,length(c),lpad('123',4, '*') from emptyStr order by c;
select 2 from dual where lpad('', 4, '*') = '';
select 2 from dual where lpad('', 4, '*') is null;
select 2 from dual where lpad(null, 4, '*') = '';
select 2 from dual where lpad(null, 4, '*') is null;
select 2 from dual where lpad('123', 0, '*') = '';
select 2 from dual where lpad('123', 0, '*') is null;
select 2 from dual where lpad('123', -1, '*') = '';
select 2 from dual where lpad('123', -1, '*') is null;
select 2 from dual where lpad('123', 4, '') = '';
select 2 from dual where lpad('123', 4, '') is null;
select 2 from dual where lpad('123', 4, null) = '';
select 2 from dual where lpad('123', 4, null) is null;
--rpad
select rpad('123',4, '*') from dual;
select c,length(c),rpad('123',4, '*') from emptyStr order by c;
select 2 from dual where rpad('', 4, '*') = '';
select 2 from dual where rpad('', 4, '*') is null;
select 2 from dual where rpad(null, 4, '*') = '';
select 2 from dual where rpad(null, 4, '*') is null;
select 2 from dual where rpad('123', 0, '*') = '';
select 2 from dual where rpad('123', 0, '*') is null;
select 2 from dual where rpad('123', -1, '*') = '';
select 2 from dual where rpad('123', -1, '*') is null;
select 2 from dual where rpad('123', 4, '') = '';
select 2 from dual where rpad('123', 4, '') is null;
select 2 from dual where rpad('123', 4, null) = '';
select 2 from dual where rpad('123', 4, null) is null;
--DBE_LOB.SUBSTR/DBE_LOB.get_length
select DBE_LOB.get_length('123') from dual;
select 2 from dual where DBE_LOB.get_length('') is null;
select 2 from dual where DBE_LOB.get_length('') = 0;
select 2 from dual where DBE_LOB.get_length(null) is null;
select 2 from dual where DBE_LOB.get_length(null) = 0;
select DBE_LOB.SUBSTR('123',1,3) from dual;
select c,length(c),DBE_LOB.SUBSTR(c,1,3) from emptyStr order by c;
select 2 from dual where DBE_LOB.SUBSTR('123',-10,1) = '';
select 2 from dual where DBE_LOB.SUBSTR('123',-10,1) is null;
select 2 from dual where DBE_LOB.SUBSTR('123',2,5) = '';
select 2 from dual where DBE_LOB.SUBSTR('123',2,5) is null;
select 2 from dual where DBE_LOB.SUBSTR('',1,3) is null;
select 2 from dual where DBE_LOB.SUBSTR('',1,3) = '';
select 2 from dual where DBE_LOB.SUBSTR(null,1,3) is null;
select 2 from dual where DBE_LOB.SUBSTR(null,1,3) = '';
--replacefunc
select 2 from dual where replace('abcc', 'abcc', '') is null;
select 2 from dual where replace('', 'abcc', 'xxx') is null;
--substring_index
select 2 from dual where substring_index('','',0) is null;
select 2 from dual where substring_index('asdas','a',0) is null;
select 2 from dual where substring_index('asdasd','',1) is null;
select 2 from dual where substring_index('','a',1) is null;

drop table if exists tbl_nelicTask;
CREATE TABLE tbl_nelicTask ( a VARCHAR(255) null, b CLOB NULL, c varchar(10) default 'abc');
select * from USER_tab_columns where TABLE_NAME=upper('tbl_nelicTask') AND DATA_DEFAULT IS NULL order by COLUMN_NAME;
select * from USER_tab_columns where TABLE_NAME=upper('tbl_nelicTask') AND DATA_DEFAULT = ''''''  order by COLUMN_NAME;
ALTER TABLE tbl_nelicTask ADD d varchar(10) default '';
alter table tbl_nelicTask modify c default 'aasdfasd';
select * from USER_tab_columns where TABLE_NAME=upper('tbl_nelicTask') AND DATA_DEFAULT IS NULL  order by COLUMN_NAME;
select * from USER_tab_columns where TABLE_NAME=upper('tbl_nelicTask') AND DATA_DEFAULT = ''''''  order by COLUMN_NAME;
select * from USER_tab_columns where TABLE_NAME=upper('tbl_nelicTask') AND DATA_DEFAULT = '''aasdfasd'''  order by COLUMN_NAME;
drop table tbl_nelicTask;

drop table if exists CBB_GLOBAL_CFG;
CREATE TABLE CBB_GLOBAL_CFG (
NAME VARCHAR(255) NOT NULL  default '',
VALUE VARCHAR(255) NULL     default '',
DESCRIP VARCHAR(255) NULL   default '',PRIMARY KEY(NAME));

insert into CBB_GLOBAL_CFG(NAME,VALUE) values('com.huawei.utraffic.plugins.tunnel.data.globalcfg.COMFIRM_MODE','Manual');
insert into CBB_GLOBAL_CFG(NAME,VALUE) values('com.huawei.utraffic.plugins.tunnel.data.globalcfg.AUTO_ADJUST_MODE','Manual');
select 'true' from CBB_GLOBAL_CFG where name = 'com.huawei.utraffic.plugins.tunnel.data.globalcfg.COMFIRM_MODE' and DESCRIP is null;
commit;

ALTER TABLE CBB_GLOBAL_CFG MODIFY (NAME VARCHAR(255) NOT NULL default '',VALUE VARCHAR(255) NULL     default '',DESCRIP VARCHAR(255) NULL     default '');
select 'true' from CBB_GLOBAL_CFG where name = 'com.huawei.utraffic.plugins.tunnel.data.globalcfg.COMFIRM_MODE' and DESCRIP is null;
drop table CBB_GLOBAL_CFG;