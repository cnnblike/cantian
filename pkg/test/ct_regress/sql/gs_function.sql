--code coverage
conn / as sysdba 
select DBE_UTIL.GET_ERROR_BACKTRACE();
select DBE_UTIL.GET_ERROR_BACKTRACE(1);
drop table if exists tt3;
create table TT3 (id DOUBLE, id2 DOUBLE, id3 DOUBLE, id4 DOUBLE, id5 DOUBLE, id6 DOUBLE);
exec DBE_MASK_DATA.ADD_POLICY('SYS', 'TT3', 'ID2','RULE', 'FULL','0.5');
exec DBE_MASK_DATA.ADD_POLICY('SYS', 'TT3', 'ID2','RULE', 'FULL1','0.5');
drop table if exists tt3;
exec DBE_MASK_DATA.ADD_POLICY('TT3', 'ID2','', 'FULL','0.5');
exec DBE_MASK_DATA.ADD_POLICY(1, 1, 1,'', 1,'0.5');
conn / as sysdba
drop user if exists DDMUSER cascade;
create user DDMUSER identified by CANTIAN_234;
grant connect , resource  to DDMUSER;
grant create table to DDMUSER;
grant create view to DDMUSER;
grant execute on DBE_MASK_DATA to DDMUSER;
grant unlimited tablespace to DDMUSER;
conn DDMUSER/CANTIAN_234@127.0.0.1:1611
drop table if exists najinschool;
create table najinschool(gradeid int, classid int, groupid int, stdid int, stdsco int);
create global temporary table temp_tab(gradeid int, classid int, groupid int, stdid int, stdsco int);
insert into najinschool values(1,1,1,1,1000);
commit;
exec SYS.DBE_MASK_DATA.ADD_POLICY('DDMUSER', 'najinschool', 'rowid', 'RULE1', 'FULL', '7');
exec SYS.DBE_MASK_DATA.ADD_POLICY('DDMUSER', 'temp_tab', 'stdsco', 'RULE1', 'FULL', '7');
exec SYS.DBE_MASK_DATA.ADD_POLICY('DDMUSER', 'najinschool', 'stdsco1', 'RULE1', 'FULL', '7');
exec SYS.DBE_MASK_DATA.ADD_POLICY('DDMUSER', 'najinschool', 'stdsco', 'RULE1', 'FULL', 'a');
exec SYS.DBE_MASK_DATA.ADD_POLICY('DDMUSER', 'najinschool', 'stdsco', 'RULE1', 'FULL', 'sin(groupid)');
conn / as sysdba
drop user if exists DDMUSER cascade;
conn / as sysdba
SELECT DBE_DIAGNOSE.DBA_TABLE_NAME(0, 2);
SELECT DBE_DIAGNOSE.DBA_LISTCOLS('SYS','SYS_TABLES','0,1');
SELECT DBE_DIAGNOSE.DBA_LISTCOLS('SYS','SYS_TABLES','');
SELECT DBE_DIAGNOSE.DBA_LISTCOLS('SYS','SYS_TABLES','1,a');
SELECT DBE_DIAGNOSE.DBA_LISTCOLS('SYS','SYS_TABLES','1,200');
SELECT DBE_DIAGNOSE.has_obj_privs('SYS', 'SYS', '', 'TABLE');
SELECT DBE_DIAGNOSE.has_obj_privs('SYS', 'SYS', 'SYS_TABLES', 'TABLE');
SELECT DBE_DIAGNOSE.has_obj_privs('SYS', 'SYS', 'SYS_TABLES', 'SQUENCE');
SELECT DBE_DIAGNOSE.has_obj_privs('SYS', 'SYS', 'SYS_TABLES', 'SEQUENCE');
SELECT DBE_DIAGNOSE.has_obj_privs('SYS', 'SYS', 'SYS_TABLES', 'TABLE');
conn / as  sysdba
drop user if exists c##core_user cascade;
create user c##core_user identified by Cantian_234;
grant connect ,create table , create view to c##core_user;
drop table if exists test_stats_1;
create table test_stats_1 (a int);
insert into test_stats_1 values(1);
insert into test_stats_1 (a) select a + 1 from test_stats_1;
insert into test_stats_1 (a) select a + 2 from test_stats_1;
insert into test_stats_1 (a) select a + 4 from test_stats_1;
insert into test_stats_1 (a) select a + 8 from test_stats_1;
insert into test_stats_1 (a) select a + 16 from test_stats_1;
insert into test_stats_1 (a) select a + 32 from test_stats_1;
insert into test_stats_1 (a) select a + 64 from test_stats_1;
commit;
create index index1_test_stats_1 on test_stats_1(a);
analyze table test_stats_1 compute statistics;
grant execute on DBE_STATS to c##core_user;
grant dba to c##core_user;
conn  c##core_user/Cantian_234@127.0.0.1:1611
EXEC DBE_STATS.MODIFY_TABLE_STATS('sys','TEST_STATS_1', row_nums=>2000, blk_nums=>2000, avgr_len=>100);
EXEC DBE_STATS.MODIFY_COLUMN_STATS('sys','TEST_STATS_1', 'a', dist_nums=>300, density=>0.0075, null_cnt=>10);
EXEC DBE_STATS.MODIFY_INDEX_STATS('sys');
conn / as sysdba 
revoke dba from c##core_user;
conn  c##core_user/Cantian_234@127.0.0.1:1611
EXEC DBE_STATS.MODIFY_TABLE_STATS('sys','TEST_STATS_1', row_nums=>2000, blk_nums=>2000, avgr_len=>100);
EXEC DBE_STATS.MODIFY_COLUMN_STATS('sys','TEST_STATS_1', 'a', dist_nums=>300, density=>0.0075, null_cnt=>10);
EXEC DBE_STATS.UNLOCK_TABLE_STATS('sys','TEST_STATS_1');
EXEC DBE_STATS.MODIFY_COLUMN_STATS('sys');
EXEC DBE_STATS.MODIFY_INDEX_STATS('sys');
EXEC DBE_STATS.MODIFY_TABLE_STATS('sys');
EXEC DBE_STATS.UNLOCK_TABLE_STATS('sys');
conn / as  sysdba
drop user if exists c##core_user cascade;
drop table if exists test_cume_dist;
create table test_cume_dist(c1 int ,c2 int ,c3 char(10),c4 varchar(20),c5 blob);
insert into test_cume_dist values(5,23,'a3','adf','ad123');
insert into test_cume_dist values(7,25,'12','asdfa','aaa');
insert into test_cume_dist values(7,35,'cad','asdf','a1111');
select cume_dist(6, '3.365') WITHIN GROUP (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM test_cume_dist order by c1 asc, c2 asc, c3 asc;  562 581 551 552 658 607
select cume_dist('adf', 'sdf') WITHIN GROUP (ORDER BY c1 asc, c2 asc) as "cume_dist_col"  FROM test_cume_dist order by c1 asc, c2 asc, c3 asc; 562 575 581 582 551 552
select cume_dist(c4, 'sdf') WITHIN GROUP (ORDER BY c1 asc, c4 asc) as "cume_dist_col"  FROM test_cume_dist order by c1 asc, c2 asc, c3 asc,c4 asc; 576
select cume_dist(8, 'bb') WITHIN GROUP (ORDER BY c1 asc, c3 asc) as "cume_dist_col"  FROM test_cume_dist group by c1 order by c1 asc;
drop table if exists test_cume_dist;
select md5('dsaf','ad') from dual;
drop table if exists t_md5_test;
create table t_md5_test(f1 int,f2 float,f3 image,f4 clob,f5 varchar(10),f6 TINYINT);
insert into t_md5_test values(214748,1.2,'a100111111','15*ad','aabb12',0);
select md5(f1),md5(f2),md5(f3),md5(f4),md5(f5),md5(f6) from t_md5_test;
select FROM_TZ(TIMESTAMP '2019-07-13 02:00:00', '21:00',10) from dual;
select FROM_TZ(TIMESTAMP '2019-07-13 02:00:00', 10) from dual;
select FROM_TZ('', '') from dual;
select FROM_TZ(TIMESTAMP '2019-07-13 02:00:00', 'adfc') from dual;
select numtoyminterval('sd2','year');
SELECT MONTHS_BETWEEN(TO_DATE('10-31-2018','MM-DD-YYYY'),'ADFASD') FROM DUAL;	
SELECT MONTHS_BETWEEN('AD',TO_DATE('06-30-2018','MM-DD-YYYY') ) FROM DUAL; 
SELECT MONTHS_BETWEEN(123,TO_DATE('06-30-2018','MM-DD-YYYY')) FROM DUAL;
SELECT MONTHS_BETWEEN(TO_DATE('10-12-2018','MM-DD-YYYY'),45) FROM DUAL;
select timestampadd(month,123,'2018');
select timestampdiff("day",'123', '2017-03-22 00:00:00');
select timestampdiff("day",'2017-03-22 00:00:00', 'ad');
select try_get_lock(5) from dual;
select group_concat;
select hash;
select hash('adf');
select ct_hash(empty_clob()) from dual;
drop table if exists test_hex_real;
create table test_hex_real(c1 real);
insert into test_hex_real values(15.61);
select hex(c1) from test_hex_real;
drop table if exists test_hex_real;
select unhex(empty_clob()) from dual;
select left('',3) from dual;
select left('sdf','asf') from dual;
drop table if exists test_left;
create table test_left(c1 clob);
insert into test_left values('aaa');
select left(c1,3) from test_left;
select left('adfd','ad') from test_left;	
drop table if exists test_left;
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_LOBSIZE(0,'CANTIANDB','TEST_PART_cv123');
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_LOBSIZE(-5,'CANTIANDB','dual');
SELECT DBE_DIAGNOSE.DBA_PARTITIONED_LOBSIZE('','CANTIANDB','dual');
drop table if exists test_if;
create table test_if(c1 int,c2 boolean,c3 raw(10),c4 binary(10),c5 clob);
insert into test_if values(23,0,'aaa','adfjksd','adf1');
select c3 ,if(c1>24,c1,c3) newif from test_if;
select if(c1>24,c1,c4) from test_if;
select object_id('dual','');
select ln(TO_DATE('10-12-2018','MM-DD-YYYY')) from dual;
select lpad(empty_blob(),5,123) from dual;
select lpad('12',5,empty_blob()) from dual;
select asciistr(empty_blob()) from dual;
select exp('1as23') from dual;
select exp(to_date('10-12-2018','MM-DD-YYYY')) from dual;
select asin(to_date('10-12-2018','MM-DD-YYYY')) from dual;
select serial_lastval(to_date('08-12-2019','MM-DD-YYYY'),'') from dual;
select serial_lastval('SYS',to_date('08-12-2019','MM-DD-YYYY')) from dual;
select greatest(1,1,'156a') from dual;
drop table if exists test_try_get_xact_lock;
create table test_try_get_xact_lock(c1 int);
insert into test_try_get_xact_lock values(10);
select try_get_xact_lock(c1) from test_try_get_xact_lock;
select translate('三a个a字a节','三a','b') a from dual;
select translate('sdsfad','f','及b') df1sd from dual;
alter system add lsnr_addr '1.0.0.1';
alter system delete lsnr_addr '1.0.0.1';

--LNNVL
drop table if exists lnnvl_table;
create table lnnvl_table(name varchar2(30),year int);
insert into lnnvl_table values('test2001',2001);
insert into lnnvl_table values('test2002',2002);
insert into lnnvl_table values('test2003',2003);
insert into lnnvl_table values('test2004',null);
insert into lnnvl_table values('test2005',2005);
insert into lnnvl_table values('test2006',2006);
insert into lnnvl_table values('test2007',2007);
insert into lnnvl_table values('test2008',null);
insert into lnnvl_table values('test2009',2009);
insert into lnnvl_table values('test2010',2010);
insert into lnnvl_table values('test2011',2011);
insert into lnnvl_table values(null,2012);

select * from lnnvl_table where lnnvl(not year>2005);
select * from lnnvl_table where lnnvl(not exists(select * from lnnvl_table));
select * from lnnvl_table where lnnvl(not regexp_like(name,'test[[:digit:]]{3}1$'));
select * from lnnvl_table where lnnvl(year is json);
select * from lnnvl_table where lnnvl(name regexp '1$');
select * from lnnvl_table where lnnvl(name not regexp '1$');
select * from lnnvl_table where lnnvl(true);
select * from lnnvl_table where lnnvl(false);
select * from lnnvl_table where lnnvl(null);
select * from lnnvl_table where lnnvl(2005);
select * from lnnvl_table where lnnvl(0=false);
select * from lnnvl_table where lnnvl(0.0=false);
select * from lnnvl_table where lnnvl(1=true);
select * from lnnvl_table where lnnvl(1.0=true);
select * from lnnvl_table where lnnvl(2=true);
select * from lnnvl_table where lnnvl(2=false);
select * from lnnvl_table where lnnvl(if(year>2005,1,0));
select * from lnnvl_table where lnnvl(if(year>2005,true,false));
select * from lnnvl_table where lnnvl(1=if(year>2005,1,0));

select lnnvl(year>2005) from lnnvl_table;

drop table lnnvl_table;

drop table if exists winsort_lnnvl_t;
create table winsort_lnnvl_t(f0 int);
insert into winsort_lnnvl_t(f0) values(10);
insert into winsort_lnnvl_t(f0) values(null);
insert into winsort_lnnvl_t(f0) values(5);
insert into winsort_lnnvl_t(f0) values(15);
commit;
select max(case when lnnvl(f0 is not null) then f0 else 1 end) over (partition by f0 order by f0) as c1 from winsort_lnnvl_t where f0 is not null;
drop table winsort_lnnvl_t;

drop table if exists cond_arg_func_t1;
drop table if exists cond_arg_func_t2;
drop table if exists cond_arg_func_t3;
create table cond_arg_func_t1(id int, c_int int not null, c_bool boolean);
create table cond_arg_func_t2(id int, c_int int not null, c_bool boolean);
create table cond_arg_func_t3(id int, c_int int not null, c_bool boolean);
create index idx_cond_arg_func_t1_1 on cond_arg_func_t1(c_int);
create index idx_cond_arg_func_t2_1 on cond_arg_func_t2(c_int);
create index idx_cond_arg_func_t3_1 on cond_arg_func_t3(c_int);
insert into cond_arg_func_t1 values(1,1000,true);
insert into cond_arg_func_t2 values(1,1000,true);
insert into cond_arg_func_t3 values(1,1000,true);
commit;
select count(*) from cond_arg_func_t1 t1, (cond_arg_func_t2 t2 left join cond_arg_func_t3 t3 on t2.c_int = t3.c_int) 
where if(t2.id is not null, t2.c_bool, t2.c_bool) = lnnvl(t1.id is not null);

select count(*) from cond_arg_func_t1 t1, (cond_arg_func_t2 t2 left join cond_arg_func_t3 t3 on t2.c_int = t3.c_int) 
where lnnvl(t1.id is not null) = if(t2.id is not null, t1.c_bool, t1.c_bool);

drop table cond_arg_func_t1;
drop table cond_arg_func_t2;
drop table cond_arg_func_t3;

--DTS2019090613640
drop table if exists lnnvl_table;
create table lnnvl_table
(
c1 boolean default lnnvl(1),
c2 boolean default lnnvl(0)
);
insert into lnnvl_table values(default,default);

drop table if exists lnnvl_table;
create table lnnvl_table
(
c1 boolean check(c1!=lnnvl(1)),
c2 boolean check(c2=lnnvl(1))
);
insert into lnnvl_table values(false,true);

drop table if exists lnnvl_table;
create table lnnvl_table(c1 boolean,c2 boolean);

insert into lnnvl_table values(false, true);
insert into lnnvl_table values(false, false);

delete from lnnvl_table where c1=lnnvl(c1!=c2);

--DTS2020011412401
select lnnvl(*) from sys_dummy;

--functiono to_blob
select to_blob(123212) from dual;
select to_blob('asd12') from dual;

drop table if exists IREQ02350169CUI;
create table IREQ02350169CUI(c1 raw(20),c2 blob,c3 char(20),c4 varchar(20),c5 integer,c6 real,c7 number,c8 date,c9 timestamp,c10 varbinary(20),c11 binary_uint32,c12 bigint,c13 image,c14 clob,c15 boolean);
insert into IREQ02350169CUI values('a111','b22','c33','d44',55,6,77,to_date('2015-7-18 11:42:56','yyyy-mm-dd hh24:mi:ss'), to_date('2019-7-18 11:42:56','yyyy-mm-dd hh24:mi:ss'),'a10',32,12,'a13','c14',0);
select to_blob(c1) from IREQ02350169CUI;
select to_blob(c2) from IREQ02350169CUI;
select to_blob(c3) from IREQ02350169CUI;
select to_blob(c4) from IREQ02350169CUI;
select to_blob(c5) from IREQ02350169CUI;
select to_blob(c6) from IREQ02350169CUI;
select to_blob(c7) from IREQ02350169CUI;
select to_blob(c8) from IREQ02350169CUI;
select to_blob(c9) from IREQ02350169CUI;
select to_blob(c10) from IREQ02350169CUI;
select to_blob(c11) from IREQ02350169CUI;
select to_blob(c12) from IREQ02350169CUI;
select to_blob(c13) from IREQ02350169CUI;
select to_blob(c14) from IREQ02350169CUI;
select to_blob(c15) from IREQ02350169CUI;
drop table if exists IREQ02350169CUI;

--DTS2019071501106
drop table if exists test_DTS2019071501106;
create table test_DTS2019071501106(l date);
insert into test_DTS2019071501106 values('2018-10-10 00:00:00');
select * from test_DTS2019071501106;
commit;
SELECT TO_CHAR(NVL(l, ''), 'yyyy-mm-dd hh24:mi') as dynamicDate
FROM test_DTS2019071501106
where rownum < 10;
drop table if exists test_DTS2019071501106;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists cao_2 cascade;
create user cao_2 identified by Cantian_234;
grant create session,create table to cao_2;
grant EXECUTE on DBE_DIAGNOSE to cao_2;
conn cao_2/Cantian_234@127.0.0.1:1611
drop table if exists t_1;
create table t_1(id1 int,id2 int);
select DBE_DIAGNOSE.DBA_LISTCOLS('CAO_2','T_1','0,4');
select DBE_DIAGNOSE.DBA_LISTCOLS('CAO_2','T_1','0,1');
conn sys/Huawei@123@127.0.0.1:1611
drop user cao_2 cascade;
drop table if exists t_function_1;
drop table if exists t_function_2;
drop table if exists t_function_3;
drop table if exists t_function_4;
drop table if exists t_function_5;
drop table if exists t_function_6;
create table t_function_1(f0 bigint, f1 int, f2 double, f3 char(10), f4 varchar(10), f5 number(10,6), f6 date, f7 timestamp);
create table t_function_2(f0 bigint, f1 int, f2 double, f3 char(10), f4 varchar(10), f5 number(10,6), f6 date, f7 timestamp);
create table t_function_4(f0 blob, f1 clob, f2 binary(100), f3 raw(100));
create table t_function_5(f1 varchar(100));
create table t_function_6(f1 CHAR(32), f2 VARCHAR(32), leading VARCHAR(32), f3 clob);
insert into t_function_1(f0, f1, f2, f3, f4, f5, f6, f7) values(1, 1, 3.333, '4', '5asdf', 6.666666666, '2018-01-16 12:13:14', '2017-03-30 12:13:14.456');
insert into t_function_1(f0, f1, f2, f3, f4, f5, f6, f7) values(null, null, 2.22, '5', 'test', 87.223, null, '2018-02-28 12:13:14.456');
insert into t_function_1(f0, f1, f2, f3, f4, f5, f6, f7) values(1, 2, 1.112233, '3', 'nebulaisok', 998.22222, '2018-01-31 12:13:14', null);
insert into t_function_2(f0) values(1);
insert into t_function_4 values('abc', '1122', '12345', '23456');
insert into t_function_4 values('eefff', '3344', null, '5678');
insert into t_function_5 values('abcdefg');
insert into t_function_5 values(null);
insert into t_function_6 values('MMMMMMMMMMMMMMZenithMMMMMMMMMMMM', 'aa             Zenitha', '   Zenith aaa', '                                    Zenith                                        ');
commit;

---nvl/nvl2
select nvl() from dual;
select nvl(1) from dual;
select nvl2() from dual;
select nvl2(1) from dual;
select nvl2(1, 2) from dual;
select nvl2(1, 2, 3, 4) from dual;
select f0,f1 from t_function_1 where f1 = nvl(2, (select min(f0) from t_function_1));
select f0,f1 from t_function_1 where f1 = nvl(null, (select min(f0) from t_function_1));
select f1, nvl(f1, 'nvl') from t_function_5 order by f1;
select f1, nvl2(f1, 'nvl2', 'nvl3') from t_function_5 order by f1;

select nvl(x, 2011-2011+2/3*4) from (select cast(null as binary_integer) x from dual union select 1/2.3333 from dual);

select nvl(123+null, systimestamp) from dual;
select nvl(123+null, 1/3.1415926) from dual;
select nvl(123+null/3+4-7|2+3-1/2*3, 1/3.1415926) from dual;
select nvl(null|6622, 1/0.1415926) from dual;
select nvl(null + 1 + 3, 1/3.1415926) from dual;
select nvl(null + null, systimestamp) from dual;
select nvl(null*2+1-2/3, 2011-2011+2/3*4) as f from dual;
select nvl('', to_timestamp('2012-12-12 12:12:12.121212', 'yyyy-mm-dd hh24:mi:ss.ff')) + 1 from dual;

select timestampdiff(month, sysdate);
select timestampdiff(month1, sysdate, systimestamp);
select timestampdiff();
select timestampdiff(month, dummy) from dual;
select timestampadd(month, sysdate);
select timestampadd(year to month, sysdate, systimestamp);
select timestampadd();
select timestampadd(month, dummy) from dual;
select timestampadd(month, dummy) from dual;
select timestampadd(month, 1, '19900101') from dual;

--- part 1
--- abs
select abs() from dual;
select abs(1,2) from dual;
select abs(-a) from dual;
select abs('a') from dual;
select abs(f2) from t_function_1 order by f3;
create table test_abs_1 as select abs(9999999999999999999999999999999999999999) c from dual;
create table test_abs_2 as select abs(-99) c from dual;
create table test_abs_3 as select abs('-99.99') c from dual;
desc test_abs_1;
desc test_abs_2;
desc test_abs_3;
drop table test_abs_1;
drop table test_abs_2;
drop table test_abs_3;

--- ceil
select ceil(#) from dual;
select ceil(true) from dual;
select ceil(FALSE) from dual;

--- add_months
select add_months() from dual;
select add_months(1) from dual;
select add_months(1, 2, 3) from dual;
select add_months(1, 2) from dual;
select add_months('2018-03-31 11:12:13', 1) from dual;
select add_months(to_date('2018-03-30 11:12:13','yyyy-mm-dd hh24:mi:ss'), 1000000) from dual;
select add_months(to_date('2018-02-29 11:12:13','yyyy-mm-dd hh24:mi:ss'), 1) from dual;
select add_months(to_date('2018-02-29 11:12:13','yyyy-mm-dd hh24:mi:ss'), 0.33 + 1) from dual;
select add_months(to_date('2018-03-30 11:12:13','yyyy-mm-dd hh24:mi:ss'), systimestamp) from dual;
select add_months(to_date('2018-03-30 11:12:13','yyyy-mm-dd hh24:mi:ss'), 'abc') from dual;

--- bin2hex
select bin2hex() from dual;
select bin2hex(1,2) from dual;
select bin2hex(TYPE_ID2NAME('a')) from dual;
select bin2hex(1) from dual;
select bin2hex(f2) from t_function_4 order by f2;

--- bitand
select bitand() from dual;
select bitand(1) from dual;
select bitand(1,2,3) from dual;
select bitand(9223372036854775808, 2) from dual;
select bitand(1, -9223372036854775809) from dual;
select bitand('a', 2) from dual;
select bitand(1, 'b') from dual;

--- bitor
select bitor() from dual;
select bitor(1) from dual;
select bitor(1,2,3) from dual;
select bitor(null,2), bitor(1,null) from dual;
select bitor(9223372036854775808, 2) from dual;
select bitor(1, -9223372036854775809) from dual;
select bitor(9223372036854775807, 2) from dual;
select bitor(1, -9223372036854775808) from dual;
select bitor('a', 2) from dual;
select bitor(1, 'b') from dual;
select bitor(1, 2), bitor(1, -2), bitor(-1, 2), bitor(-1, -2) from dual;
select bitor(2,-2), bitor(2,2.999), bitor(2,-2.999), bitor(2,2.4), bitor(2,-2.4) from dual;

--- bitxor
select bitxor() from dual;
select bitxor(1) from dual;
select bitxor(1,2,3) from dual;
select bitxor(null,2), bitxor(1,null) from dual;
select bitxor(9223372036854775808, 2) from dual;
select bitxor(1, -9223372036854775809) from dual;
select bitxor(9223372036854775807, 2) from dual;
select bitxor(1, -9223372036854775808) from dual;
select bitxor('a', 2) from dual;
select bitxor(1, 'b') from dual;
select bitxor(1, 2), bitxor(1, -2), bitxor(-1, 2), bitxor(-1, -2) from dual;
select bitxor(2,-2), bitxor(2,2.999), bitxor(2,-2.999), bitxor(2,2.4), bitxor(2,-2.4) from dual;

--- chr
select chr() from dual;
select chr(1,2) from dual;
select chr(9223372036854775808) from dual;
select chr(-1) from dual;
select chr(128) from dual;

--- sin
select sin(0) from dual;
select sin(1) from dual;
select sin(2) from dual;
select sin(4) from dual;
select sin(5) from dual;
select sin(3.1415926) from dual;
select sin(3.1415926535897932384626433832795028841) from dual;
select sin(3.14159265358979323846264338327950288419) from dual;
select sin(-1) from dual;
select sin(-3.1415926) from dual;
select sin(-10) from dual;
select sin(-20) from dual;

--- cos
select cos(1) from dual;
select cos(2) from dual;
select cos(4) from dual;
select cos(5) from dual;
select cos(3.1415926) from dual;
select cos(3.1415926535897932384626433832795028841) from dual;
select cos(3.14159265358979323846264338327950288419) from dual;
select cos(-1) from dual;
select cos(-3.1415926) from dual;
select cos(-10) from dual;
select cos(-20) from dual;

--- asin
select asin(-1.01) from dual;
select asin(-1) from dual;
select asin(-0.7523472893457) from dual;
select asin(-0.5) from dual;
select asin(-0.1237832751932847) from dual;
select asin(0.3) from dual;
select asin(0.7523472893457) from dual;
select asin(1) from dual;
select asin(1.000000000000000000001) from dual;
select asin(-1.00000000000000000000001) from dual;
select asin(2) from dual;

--- acos
select acos(-1.01) from dual;
select acos(1.000000000000000000001) from dual;
select acos(-1.00000000000000000000001) from dual;
select acos(2) from dual;

-- sign
select sign('-12ddd334') from dual;
select sign('12ddd334') from dual;

--- current_timestamp
select current_timestamp('a') from dual;
select current_timestamp(-1) from dual;
select current_timestamp(7) from dual;
select current_timestamp(f1) from t_function_1;

--- SYSTIMESTAMP
select SYSTIMESTAMP('a') from dual;
select SYSTIMESTAMP(-1) from dual;
select SYSTIMESTAMP(7) from dual;

--- now
select now('a') from dual;
select now(-1) from dual;
select now(7) from dual;
select now(f1) from t_function_1;

--- decode
select decode(1,2) from dual;
select decode(1,'a','a') from dual;

drop table if exists t_decode1;
create table t_decode1(f1 bigint);
insert into t_decode1 values(460799988736);
commit;
select decode(f1, 0, 0, 888888888888) from t_decode1;

drop table if exists t_decode2;
create table t_decode2(f1 real, f2 number, f3 decimal);
insert into t_decode2 values(2.0e+128, 123.456, 456.78);
commit;
select decode(f1, 0, 123.456, 3.0e+128) from t_decode2;
select decode(f1, 0, 456.78, 3.0e+128) from t_decode2;

drop table if exists test_array;
create table test_array(f1 int[], f2 bigint[], f3 real[], f4 number[], f5 decimal[]);
insert into test_array values(array[1, 2], array[111111111111111111, 22222222222222222], array[2.0e+128, 3.0e+128], array[111.111, 222.222], array[11.11, 22.22]);
commit;
select decode(f2[1], 0, array[1,2], array[11111111111111111, 2222222222222222]) from test_array;
select decode(f3[1], 0, array[111.111, 222.222], array[2.0e+129, 3.0e+129]) from test_array;
select decode(f3[1], 0, array[11.11, 22.22], array[2.0e+129, 3.0e+129]) from test_array;

--- test type:
desc -q select decode(f1,0,0,888888888888) from t_decode1;
desc -q select decode(f1, 0, 123.456, 3.0e+128) from t_decode2;
desc -q select decode(f1, 0, 456.78, 3.0e+128) from t_decode2;
drop table if exists t_decode1;
drop table if exists t_decode2;

desc -q select decode(f2[1], 0, array[1,2], array[11111111111111111, 2222222222222222]) from test_array;
desc -q select decode(f3[1], 0, array[111.111, 222.222], array[2.0e+129, 3.0e+129]) from test_array;
desc -q select decode(f3[1], 0, array[11.11, 22.22], array[2.0e+129, 3.0e+129]) from test_array;
drop table if exists test_array;

desc -q select decode(1,2) from dual;
desc -q select decode(null,1,2) a, decode(1,null,1) b, decode(1,null,2,3) c, decode(1,null,2,null) d from dual;
desc -q select decode(1,1,1),decode(1,2,2),decode(1,2,2,3),decode(1,2,2,3,4) from dual;
desc -q select decode(1,'a','a') from dual;
desc -q select decode(1,2, 321, 3, 123) a, decode(1,2, 'abc', 3, 123) b, decode(1,2, 123, 3, 'abc') c, decode(1,2, sysdate, 3, to_date('2222-11-11', 'yyyy-MM-dd')) d, decode(1, 2, hextoraw('123'), 1, '321') e from dual;   --oracle:number,varchar,number,date,raw(2)
--- error
desc -q select decode(1,2, to_date('1111-11-11', 'yyyy-MM-dd'), 3, 123) a from dual;
desc -q select decode(1,2, 123, 3, to_date('1111-11-11', 'yyyy-MM-dd')) a from dual;
--- DTS:DTS2018110209708
drop table if exists t_abs ;
create table t_abs (c1 varbinary(12));
insert into t_abs values ('abccdddddddd');
commit;
desc -q select DECODE(c1,'abccdddddddd',21346532346562535424546573214235672134653234656253542454657321423567,1) from t_abs order by 1;
select DECODE(c1,'abccdddddddd',21346532346562535424546573214235672134653234656253542454657321423567,1) from t_abs order by 1;
select DECODE(cast(c1 as varbinary(256)),'abccdddddddd',21346532346562535424546573214235672134653234656253542454657321423567,1) from t_abs order by 1;
--- DTS:DTS2019011710060
drop table if exists decode_ts;
create table decode_ts (f1 timestamp);
insert into decode_ts values ('2019-01-25 17:34:25.123456');
commit;
select DECODE(f1,f1,f1), f1 from decode_ts;
desc -q select DECODE(1,1,f1) from decode_ts;
desc -q select f1 from decode_ts;
desc -q select decode(6, 1, systimestamp(1), 6,  systimestamp(3), 2, systimestamp(5), 3, NULL, NULL) X from dual;
desc -q select decode(3, 1, systimestamp(1), 6,  systimestamp(3), 2, systimestamp(5), 3, NULL, NULL) X from dual;
desc -q select decode(2, 1, NULL, 6,  systimestamp(3), 2, systimestamp(5), 3, systimestamp(1), NULL) X from dual;

drop table if exists diff_type_t;
create table diff_type_t(c_int int, c_uint32 binary_uint32, c_bigint bigint, c_bool boolean, c_number number(12), c_decimal decimal(10,3), c_real real, c_float float, 
                         c_char char(15), c_varchar varchar(10), c_binary binary(10), c_varbinary varbinary(10), c_raw raw(10), c_clob clob, c_blob blob, c_image image,
                         c_date date, c_timestamp timestamp(6), c_timestamp_tz timestamp(6) with time zone, c_timestamp_ltz timestamp(6) with local time zone, 
                         c_interval_ds interval day(7) to second, c_interval_ym interval year(4) to month, c_int_array int[], c_str_array varchar(20)[]);
insert into diff_type_t values(1,1,100000,true,12,20.333,5.6,6.6,'1111','2222','100','101','102','103','104','105', '1999-09-27','2000-01-01 12:59:59.999999',
'2021-04-08 07:00:00.000000 +04:00', '2021-04-08 14:36:25.046731', '123 9:20:27', '2020-10', array[1,2,3], array['1','a','b']);
insert into diff_type_t values(2,2,200000,false,22,40.666,7.8,8.8,'aaaa','bbbb','200','201','202','203','204','205', '2000-09-27','2001-01-01 12:59:59.999999',
'2022-04-08 07:00:00.000000 +04:00', '2022-04-08 14:36:25.046731', '234 9:20:27', '2020-11', array[4,5,6], array['2','c','d']);

desc -q select decode(c_int, 1, c_int, 2, '123.456') as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_int, 2, c_varchar) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_char, 2, c_varchar) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_char, 2, cast('www' as char(5))) as c1 from diff_type_t;

desc -q select decode(c_int, 1, c_number, 2, c_real) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_bigint, 2, c_real) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_real, 2, c_int) as c1 from diff_type_t;

desc -q select decode(c_int, 1, c_date, 2, c_timestamp) as c1 from diff_type_t;
-- truncate c_timestamp
select decode(c_int, 1, c_date, 2, c_timestamp) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_timestamp, 2, c_date) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_timestamp_tz, 2, c_timestamp) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_timestamp, 2, c_timestamp_tz) as c1 from diff_type_t;
-- truncate c_timestamp_tz
select decode(c_int, 1, c_timestamp, 2, c_timestamp_tz) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_timestamp_tz, 2, c_timestamp_ltz) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_timestamp_ltz, 2, c_timestamp_tz) as c1 from diff_type_t;
select decode(c_int, 1, c_timestamp_ltz, 2, c_timestamp_tz) as c1 from diff_type_t;

desc -q select decode(c_int, 1, c_interval_ds, 2, c_varchar) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_interval_ds, 2, '123 11:11:11') as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_varchar, 2, c_interval_ds) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_interval_ds, 2, '123 11:11:11') as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_interval_ym, 2, c_varchar) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_interval_ym, 2, '10-11') as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_varchar, 2, c_interval_ym) as c1 from diff_type_t;

desc -q select decode(c_int, 1, c_clob, 2, c_int) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_int, 2, c_clob) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_clob, 2, c_char) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_char, 2, c_clob) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_image, 2, c_clob) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_clob, 2, c_image) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_clob, 2, c_raw) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_clob, 2, c_blob) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_raw, 2, c_blob) as c1 from diff_type_t;

desc -q select decode(c_int, 1, c_binary, 2, c_varbinary) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_binary, 2, cast('1112' as binary(5))) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_bool, 2, c_int) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_int, 2, c_bool) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_varchar, 2, c_bool) as c1 from diff_type_t;

desc -q select decode(c_int, 1, c_int_array, 2, c_int) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_int_array[1], 2, c_int) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_int_array, 2, array['1', '2']) as c1 from diff_type_t;
desc -q select decode(c_int, 1, c_int_array, 2, c_str_array[2]) as c1 from diff_type_t;

drop table diff_type_t;

--- floor
select floor() from dual;
select floor(1, 2) from dual;
select floor('a') from dual;

--- hex2bin/hex2raw
select hex2bin() from dual;
select hex2bin(1, 2) from dual;
select hex2bin(1) from dual;
select hex2bin('0') from dual;
select hex2bin('0x') from dual;
select hex2bin('0x1') from dual;
select hex2bin('0x112233') from dual;
select hextoraw() from dual;
select hextoraw(1, 2) from dual;
select hextoraw('0x112233') from dual;

--DTS2018091305216
SELECT BIN2HEX(HEX2BIN('06937110C9AD368DA2190581887C58A7')) FROM DUAL;  --invalid argument
SELECT BIN2HEX(HEX2BIN('0X6937110C9AD368DA2190581887C58A7')) FROM DUAL;
SELECT BIN2HEX(HEXTORAW('06937110C9AD368DA2190581887C58A7')) FROM DUAL;

--- rawtohew
select rawtohex() from dual;
select rawtohex(1, 2) from dual;
select rawtohex(f3) from t_function_4;

--- to_char
select to_char() from dual;
select to_char(1,2,3) from dual;
select to_char(1, f1) from t_function_4;
select to_char(sysdate, 'abc') from dual;
select to_char(f1),to_char(f2),to_char(f3),to_char(f4),to_char(f5),to_char(f6),to_char(f7) from t_function_1 order by f3;
select to_char(date '1990-01-01', 'RM') FROM DUAL;
select to_char(date '1990-02-01', 'RM') FROM DUAL;
select to_char(date '1990-03-01', 'RM') FROM DUAL;
select to_char(date '1990-04-01', 'RM') FROM DUAL;
select to_char(date '1990-05-01', 'RM') FROM DUAL;
select to_char(date '1990-06-01', 'RM') FROM DUAL;
select to_char(date '1990-07-01', 'RM') FROM DUAL;
select to_char(date '1990-08-01', 'RM') FROM DUAL;
select to_char(date '1990-09-01', 'RM') FROM DUAL;
select to_char(date '1990-10-01', 'RM') FROM DUAL;
select to_char(date '1990-11-01', 'RM') FROM DUAL;
select to_char(date '1990-12-01', 'RM') FROM DUAL;
select to_char(TIMESTAMP '1990-02-01 01:01:01', 'rm') FROM DUAL;
select to_char(array[convert('1', uint), convert('2', uint)]) from sys_dummy;
select to_char(array[true,false]) from sys_dummy;
select to_char(array[to_bigint('1245'), to_bigint('5678')]) from sys_dummy;
select to_char(array[convert('123.456', real), convert('456.789', real)]) from sys_dummy;
select to_char(array[to_number('123.500', '000.0000'), to_number('00FFFFFF', '0000000X')]) from sys_dummy;
select to_char(array[to_date('2018-06-28 13:14:15', 'YYYY-MM-DD HH24:MI:SS:FF'), to_date('2020-09-21 13:14:15', 'YYYY-MM-DD HH24:MI:SS:FF')]) from sys_dummy;
select to_char(array[to_timestamp('2017-09-11 23:45:59.44', 'YYYY-MM-DD HH24:MI:SSXFF6'), to_timestamp('2020-09-21 23:45:59.44', 'YYYY-MM-DD HH24:MI:SSXFF6')]) from sys_dummy;
select to_char(array[cast('2020-09-21 17:24:37.444569 +08:00' as timestamp with time zone)]) from sys_dummy;
select to_char(array[cast('2020-09-21 17:24:37.444569' as timestamp with local time zone)]) from sys_dummy;
select to_char(array[numtodsinterval(3.1425926535897932384626, 'DAY'), numtodsinterval(3.1425926535897932384626, 'MINUTE')]) from sys_dummy;
select to_char(array[numtoyminterval(9999.9, 'year'), numtoyminterval(99999.9, 'month')]) from sys_dummy;

-- to_number
select to_number(-'000133', '000xXX') from dual;
select to_number(-'000Eff', '000xXX') from dual;
select to_number('l000133', '000xXX') from dual;
select to_number('133', '000xXX') from dual;
select to_number('133', '00000') from dual;
select to_number('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFfffffFFFFF', 'xxxxxXXXXXxxXXXXXxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') from dual;
select to_number('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFfffffFFFFFEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE', 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXxxxxxXXXXXxxXXXXXxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxXxxx') from dual;
 
--select * from dual where rowid in (to_char('000863846400000'), to_char('000863641700000'), to_char('000863641700000'), to_char('000863641700000'), to_char('000863846400000'), to_char('000863641800000'), to_char('000863642700000'));
--select rowid from dual where rowid = to_char('000863846400000') or rowid = to_char('000863641800000');
select rowid from dual where rowid = to_char('000863846400000') or rowid = to_char('000863641800000') or 1=0;
--- to_date
select to_date() from dual;
select to_date(1, 2, 3) from dual;
--select to_date(1, 'YYYY-MM-DD') from dual;
select to_date('2018-01-20', 2) from dual;
select to_date('2018-01-20') from dual;
select to_date('2018-01-20 12:13:14') from dual;

--- to_timestamp
select to_timestamp() from dual;
select to_timestamp(1,2,3) from dual;
select to_timestamp(1, 'YYYY-MM-DD') from dual;
select to_timestamp('2018-01-20', 2) from dual;
select to_timestamp('2290-09-12', 'YYYY-MM-DD') from dual;
select to_timestamp('2290-09-12', 'YYYY-MM-DD') from dual;
select to_timestamp('2018-01-20') from dual;
select to_timestamp('2018-01-20 12:13:14.123456') from dual;

--- avg count max min sum
select count() from dual;
select count(1, 2) from dual;
select count(dual.*) from dual;
select sum(1) from dual;
select avg(f0), avg(f1), avg(f2), avg(f5) from t_function_1;
select avg(f0+f1+f2) from t_function_1;
select avg(f0,f1) from t_function_1;
select avg(f3) from t_function_1;
select avg(f4) from t_function_1;
select sum(f0), min(f1), count(f2), avg(f5), max(f1) from t_function_1;
select sum(f0+f1+f2) from t_function_1;
select sum(f0,f1) from t_function_1;
select sum(f3) from t_function_1;
select sum(f4) from t_function_1;
select sum(*) from t_function_1;
select avg(*) from t_function_1;
select min(*) from t_function_1;
select max(*) from t_function_1;
select max(f1) from t_function_1;
select sum(f0), min(f1), count(f2), avg(f5), max(f1) from t_function_1;
select avg(f0), avg(f1), avg(f2), avg(f5) from t_function_1;
select avg(f0) from t_function_4;

--- instr/instrb
select instr() from dual;
select instr(1) from dual;
select instr(1,2,3,4,5) from dual;

select instr(f1, 2, 3, 4) from t_function_2;
select instr(1, f1, 3, 4) from t_function_2;
select instr('', 2, 3, 4) from dual;
select instr(1, '', 3, 4) from dual;

select instr(1, 2, f1, 4) from t_function_2;
select instr(1, 2, 'a', 4) from dual;
select instr(1, 2, 3, f1) from t_function_2;
select instr(1, 2, 3, 'a') from dual;
select instr(1, 2, 3, 0) from dual;
select instr(1, 2, 3, -1) from dual;

--- length/lengthb
select length() from dual;
select length(1, 2) from dual;
select * from t_function_1 order by f3;
select f3, length(f0),length(f1),length(f2),length(f3),length(f4),length(f5) from t_function_1 order by f3;
select f3, lengthb(f0),lengthb(f1),lengthb(f2),lengthb(f3),lengthb(f4),lengthb(f5) from t_function_1 order by f3;
select f2, length(f0), length(f1), length(f2), lengthb(f0), lengthb(f1), lengthb(f2) from t_function_4 order by f2;
select length('华') from dual;
select length(substrb('华',1,1)) from dual;
select length(substrb('华',1,2)) from dual;

--- scn2date
select scn2date() from dual;
select scn2date(1, 2) from dual;

--- substr/substrb
select substr() from dual;
select substr(1) from dual;
select substr(1,2,3,4) from dual;

select substr(f1, 2) from t_function_2;
select substr('', 2) from dual;
select substr('0abc12abc34abc567890', f1) as substr from t_function_2;
select substr('0abc12abc34abc567890', 'a') as substr from dual;
select substr('0abc12abc34abc567890', 2, f1) as substr from t_function_2;
select substr('0abc12abc34abc567890', 2, 'a') as substr from t_function_2;
select substr('0abc12abc34abc567890', 2, 0) as substr1, substr('0abc12abc34abc567890', 2, -1) as substr2 from t_function_2;

select substr('0abc12abc34abc567890', 21) as substr1, substr('0abc12abc34abc567890', -21) as substr2 from dual;

select substr('0abc12abc34abc567890', 0) as substr, substrb('0abc12abc34abc567890', 0) as substrb from dual;
select substr('0abc12abc34abc567890', 1) as substr, substrb('0abc12abc34abc567890', -1) as substrb from dual;
select substr('0abc12abc34abc567890', 10) as substr, substrb('0abc12abc34abc567890', -10) as substrb from dual;
select substr('0abc12abc34abc567890', 20) as substr, substrb('0abc12abc34abc567890', -20) as substrb from dual;

select substr('0abc12abc34abc567890', 7, 10) as substr, substrb('0abc12abc34abc567890', 7, 10) as substrb from dual;
select substr('0abc12abc34abc567890', 7, 13) as substr, substrb('0abc12abc34abc567890', 7, 13) as substrb from dual;
select substr('0abc12abc34abc567890', 7, 14) as substr, substrb('0abc12abc34abc567890', 7, 14) as substrb from dual;
select substr('0abc12abc34abc567890', 7, 15) as substr, substrb('0abc12abc34abc567890', 7, 15) as substrb from dual;
select substr('0abc12abc34abc567890', -7, 4) as substr, substrb('0abc12abc34abc567890', -7, 4) as substrb from dual;
select substr('0abc12abc34abc567890', -7, 6) as substr, substrb('0abc12abc34abc567890', -7, 6) as substrb from dual;
select substr('0abc12abc34abc567890', -7, 7) as substr, substrb('0abc12abc34abc567890', -7, 7) as substrb from dual;
select substr('0abc12abc34abc567890', -7, 8) as substr, substrb('0abc12abc34abc567890', -7, 8) as substrb from dual;

select substring('高斯DB数据库', -5, -4) from dual;
select substring('高斯DB数据库', -8, 1) from dual;
select substring('高斯DB数据库', -8, 7) from dual;
select substring('高斯DB数据库', -8, 8) from dual;
select substring('高斯DB数据库', -8) from dual;
select substring('高斯DB数据库', 8, 2) from dual;
select substring('高斯DB数据库', 8) from dual;

select substrb('abcdefg', 3) from dual;
select substrb('abcdefg', 2) from dual;
select substrb('abcdefg', 2.99) from dual;
select substrb('abcdefg', 1.99) from dual;
select substrb('abcdefg', 1) from dual;

-- left/right
select left('abcdefg', 0) from dual;
select left('abcdefg', -1) from dual;
select left('abcdefg', -123456789012345) from dual;
select right('abcdefg', 0) from dual;
select right('abcdefg', -1) from dual;
select right('abcdefg', -123456789012345) from dual;
select left('abcde', -1234567890123456789012345) from dual;
select right('abcdefg', '-1.1') from dual;
select right('abcdefg', '0.01') from dual;
select left('高斯DB数据库', 0) from dual;
select left('高斯DB数据库', -1) from dual;
select right('高斯DB数据库', 0) from dual;
select right('高斯DB数据库', -1) from dual;
select left(lpad('badbadfa',10,'dfafda'),5000) from dual;
select right(lpad('badbadfa',10,'dfafda'),5000) from dual;

-- ltrim/rtrim
select ltrim() from dual;
select ltrim(1, 2, 3) from dual;
select ltrim(TYPE_ID2NAME('a')) from dual;

drop table if exists lob_test;
create table lob_test (temp clob, temp_1 blob);
insert into lob_test values ('==abcdeftasdasdggadasdad==','0xffba2345721cdab');
select ltrim(temp,'=') from lob_test;
select rtrim(temp,'=') from lob_test;

-- trim
SELECT f1, TRIM('M' FROM f1) AS NEW_F1, f2, TRIM(CHR(32) FROM TRIM('a' FROM f2)) AS NEW_F2 FROM t_function_6;
SELECT LENGTH(f1) AS LENGTH1, LENGTH(TRIM('M' FROM f1)) AS TLENGTH1, LENGTH(f2) AS LENGTH2, LENGTH(TRIM(TRIM('a' FROM f2))) AS TLENGTH2 FROM t_function_6;
SELECT TRIM(NULL FROM f1) FROM t_function_6;
SELECT f2, LTRIM(TRIM(f2, 'a')) AS "LTRIM(TRIM)" FROM t_function_6;
SELECT TRIM(f2, 'a', LEADING) FROM t_function_6;
SELECT TRIM(LEADING, 'a') FROM t_function_6;
SELECT f2, TRIM(LEADING FROM TRIM(f2, 'a')) AS "LTRIM(TRIM)" FROM t_function_6;
SELECT f2, TRIM('a ' FROM f2) AS "NEW_F2" FROM t_function_6;
SELECT f2, TRIM(CHR(20) FROM TRIM('b' FROM f2)) AS "F2 NOT TRIM" FROM t_function_6;
SELECT f2, TRIM(BOTH CHR(20) FROM TRIM('b' FROM f2)) AS "F2 NOT TRIM" FROM t_function_6;
SELECT count(f1) FROM t_function_6 WHERE TRIM(BOTH FROM TRIM(f2, 'a'))='Zenith';
SELECT TRIM(TRIM(LEADING 'M' FROM f1), 'M') FROM t_function_6 WHERE TRIM(BOTH FROM TRIM(f2, 'a'))='Zenith';

SELECT f2, TRIM(LEADING CHR(32) FROM TRIM('a' FROM f2)) AS "LTRIM(TRIM)" FROM t_function_6;
SELECT f2, TRIM(TRAILING CHR(32) FROM TRIM('a' FROM f2)) AS "LTRIM(TRIM)" FROM t_function_6;
SELECT f2, TRIM(BOTH CHR(32) FROM TRIM('a' FROM f2)) AS "LTRIM(TRIM)" FROM t_function_6;

select trim() from dual;
select trim(BOTH 'a' From NULL 'aaZenitha') from dual;
select trim(BOTH From NULL 'aaZenitha') from dual;
select trim(BOTH From From 'aaZenitha') from dual;
select trim(BOTH 'a' from 'aaZenitha', 'Z') from dual;
select trim('aaZenitha', 'a', 1);
select trim('aaZenitha', 'a', LEADING);
select trim(1, 2, 3, 4) from dual;

--connection_id
SELECT count(connection_id()) FROM DUAL;
SELECT COUNT(f1) FROM t_function_6 WHERE CAST(CONNECTION_ID() AS CHAR(30))>0;  --check if the expression "CAST(CONNECTION_ID() AS CHAR(30))" is OK
SELECT connection_id(1) FROM DUAL;
SELECT connection_id(f1) FROM t_function_6;

-- sleep
select sleep() from dual;
select sleep(1, 2) from dual;
select sleep(TYPE_ID2NAME('a')) from dual;
select sleep(null) from dual;
select sleep('a') from dual;
select sleep(1) from dual;

-- upper/lower
select upper() from dual;
select upper(1, 2) from dual;
select lower() from dual;
select lower(1, 2) from dual;
create table t_function_3 (f1 varchar(20));
create index t_function_3_index1 on t_function_3 (f1);
insert into t_function_3 values ('abc');
select * from t_function_3;
update t_function_3 set f1 = upper(f1);
select * from t_function_3;
update t_function_3 set f1 = lower(f1);
select * from t_function_3;
commit;

-- utf-8
select substr('abc中国abc', 3, 2), substrb('abc中国abc', 2, 1) from dual;
select substr('abc中国abc', 4, 3), substrb('abc中国abc', 4, 3) from dual;
select instr('abc中国abc', 'ab', 4, 1), instrb('abc中国abc', 'ab', 4, 1) from dual;

--- _to_col_type
select _to_col_type(-1) from dual;
select _to_col_type(20000) from dual;
select _to_col_type(20001) from dual;
select _to_col_type(20002) from dual;
select _to_col_type(20003) from dual;
select _to_col_type(20004) from dual;
select _to_col_type(20005) from dual;
select _to_col_type(20006) from dual;
select _to_col_type(20007) from dual;
select _to_col_type(20008) from dual;
select _to_col_type(20009) from dual;
select _to_col_type(20010) from dual;
select _to_col_type(20011) from dual;
select _to_col_type(20012) from dual;
select _to_col_type(20013) from dual;
select _to_col_type(20014) from dual;
select _to_col_type(20015) from dual;
select _to_col_type(20016) from dual;
select _to_col_type(20017) from dual;
select _to_col_type(20018) from dual;
select _to_col_type(20019) from dual;
select _to_col_type(20020) from dual;
select _to_col_type(20021) from dual;
select _to_tab_type(-1) from dual;
select _to_tab_type(0) from dual;
select _to_tab_type(1) from dual;
select _to_tab_type(2) from dual;
select _to_tab_type(3) from dual;
select _to_tab_type(4) from dual;
select _to_tab_type(5) from dual;

--- DBE_DIAGNOSE.DBA_LISTCOLS/DBE_DIAGNOSE.DBA_SEGSIZE/DBE_DIAGNOSE.DBA_SPCSIZE/DBE_DIAGNOSE.DBA_TABTYPE/TYPE_ID2NAME
select DBE_DIAGNOSE.DBA_LISTCOLS() from dual;
select DBE_DIAGNOSE.DBA_LISTCOLS(1) from dual;
select DBE_DIAGNOSE.DBA_LISTCOLS(1, 2) from dual;
select DBE_DIAGNOSE.DBA_LISTCOLS(1, 2, 3, 4) from dual;
select DBE_DIAGNOSE.DBA_LISTCOLS(1, 'TABLE_NAME', 'COLUMN_LIST') from dual;
select DBE_DIAGNOSE.DBA_LISTCOLS('USER_NAME', 2, 'COLUMN_LIST') from dual;
select DBE_DIAGNOSE.DBA_LISTCOLS('USER_NAME', 'TABLE_NAME', 3) from dual;
select DBE_DIAGNOSE.DBA_LISTCOLS('SYS', 'SYS_TABLES', col_list) from SYS_INDEXES where user#=0 and table#=0 order by col_list;

select DBE_DIAGNOSE.DBA_SEGSIZE() from dual;
select DBE_DIAGNOSE.DBA_SEGSIZE(1) from dual;
select DBE_DIAGNOSE.DBA_SEGSIZE(1, 2, 3) from dual;
select DBE_DIAGNOSE.DBA_SEGSIZE('a', 2) from dual;
select DBE_DIAGNOSE.DBA_SEGSIZE(1, 'a') from dual;
select DBE_DIAGNOSE.DBA_SEGSIZE(1, -1) from dual;
select DBE_DIAGNOSE.DBA_SEGSIZE(1234, 5678) from dual;

select DBE_DIAGNOSE.DBA_SPCSIZE() from dual;
select DBE_DIAGNOSE.DBA_SPCSIZE(1) from dual;
select DBE_DIAGNOSE.DBA_SPCSIZE(1, 2, 3) from dual;
select DBE_DIAGNOSE.DBA_SPCSIZE('a', 'PAGE') from v$tablespace where name='SYSTEM';
select DBE_DIAGNOSE.DBA_SPCSIZE(id, 2) from v$tablespace where name='SYSTEM';
select DBE_DIAGNOSE.DBA_SPCSIZE(id, 'PAGE-TOTAL-USED') from v$tablespace where name='SYSTEM';
select count(1) from (select DBE_DIAGNOSE.DBA_SPCSIZE(id, 'PAGE'), DBE_DIAGNOSE.DBA_SPCSIZE(id, 'TOTAL'), DBE_DIAGNOSE.DBA_SPCSIZE(id, 'USED') from v$tablespace where name='SYSTEM');
select * from v$tablespace where name='SYSTEM' and (DBE_DIAGNOSE.DBA_SPCSIZE(id, 'PAGE') < 0 or DBE_DIAGNOSE.DBA_SPCSIZE(id, 'TOTAL')<0 or DBE_DIAGNOSE.DBA_SPCSIZE(id, 'USED')<0);

select DBE_DIAGNOSE.DBA_TABTYPE() from dual;
select DBE_DIAGNOSE.DBA_TABTYPE(1, 2) from dual;
select DBE_DIAGNOSE.DBA_TABTYPE('a') from dual;
select DBE_DIAGNOSE.DBA_TABTYPE(-1), DBE_DIAGNOSE.DBA_TABTYPE(0), DBE_DIAGNOSE.DBA_TABTYPE(1), DBE_DIAGNOSE.DBA_TABTYPE(2), DBE_DIAGNOSE.DBA_TABTYPE(3), DBE_DIAGNOSE.DBA_TABTYPE(4) from dual;

select TYPE_ID2NAME() from dual;
select TYPE_ID2NAME(1, 2) from dual;
select TYPE_ID2NAME('a') from dual;
select TYPE_ID2NAME(null) from dual;
select TYPE_ID2NAME(datatype) from SYS_COLUMNS where table#=0 and name='USER#';

-- Function test add
select DBE_DIAGNOSE.dba_space_name(-1);
select DBE_DIAGNOSE.dba_space_name(0);
select DBE_DIAGNOSE.dba_space_name(1);
select DBE_DIAGNOSE.dba_space_name(100);
select DBE_DIAGNOSE.dba_space_name('2');
select DBE_DIAGNOSE.dba_space_name('-2');
select DBE_DIAGNOSE.dba_space_name('');
select DBE_DIAGNOSE.dba_space_name();

select  DBE_DIAGNOSE.dba_user_name(-1);
select  DBE_DIAGNOSE.dba_user_name(0);
select  DBE_DIAGNOSE.dba_user_name(1);
select  DBE_DIAGNOSE.dba_user_name(10000);
select  DBE_DIAGNOSE.dba_user_name(',');
select  DBE_DIAGNOSE.dba_user_name(' ');

CREATE TABLE TEST_SEG(A INT, B INT);
INSERT INTO SYS.TEST_SEG VALUES(100, 200);
SELECT DBE_DIAGNOSE.DBA_SEGSIZE(0, T.ENTRY) FROM SYS.SYS_TABLES T WHERE T.NAME = 'TEST_SEG';
SELECT DBE_DIAGNOSE.DBA_SEGSIZE(1, T.ENTRY) FROM SYS.SYS_TABLES T WHERE T.NAME = 'TEST_SEG';
SELECT DBE_DIAGNOSE.DBA_SEGSIZE(2, T.ENTRY) FROM SYS.SYS_TABLES T WHERE T.NAME = 'TEST_SEG';
SELECT DBE_DIAGNOSE.DBA_SEGSIZE(200000000000000000000000000000000000000, T.ENTRY) FROM SYS.SYS_TABLES T WHERE T.NAME = 'TEST_SEG';
DROP TABLE TEST_SEG;

--- invalid function
select abr(1) from dual;
select abt(1) from dual;

--- part 2
--- function in expression
select 1 + to_date('2290-09-12', 'YYYY-MM-DD') from dual;

--- any
delete from t_function_1;
delete from t_function_2;
insert into t_function_1(f0, f1, f4) values(1, 2, 'A');
insert into t_function_1(f0, f1, f4) values(2, 3, 'B');
insert into t_function_1(f0, f1, f4) values(3, 4, 'C');
insert into t_function_1(f0, f1, f4) values(4, 5, 'D');
insert into t_function_1(f0, f1, f4) values(2, 3, 'B');
insert into t_function_1(f0, f1, f4) values(3, 4, 'C');
commit;

select f0, f1, f4 from t_function_1 where f0 = any(2,4,3) + 1;
select f0, f1, f4 from t_function_1 where f0 = 1 + any(2,4,3);
select f0, f1, f4 from t_function_1 where f0 > any(2,4,3) + 1;
select f0, f1, f4 from t_function_1 where f0 < 1 + any(2,4,3);
select f0, f1, f4 from t_function_1 where any(2,4,3) < f0;

select f0, f1, f4 from t_function_1 where f0 = any(2,4,3) order by f0 desc;
select f0, f1, f4 from t_function_1 where f0 <> any(2,4,3) order by f0 desc;
select f0, f1, f4 from t_function_1 where f0 > any(2,4,3) order by f0 desc;
select f0, f1, f4 from t_function_1 where f0 < any(2,4,3) order by f0 desc;
select f0, f1, f4 from t_function_1 where f0 >= any(3,4,2) order by f0 desc;
select f0, f1, f4 from t_function_1 where f0 <= any(1,3,2) order by f0 desc;

CREATE INDEX index_t_function_1 ON t_function_1(f0);

select f0, f1, f4 from t_function_1 where f0 = any(2,4,3) order by f0 desc;
select f0, f1, f4 from t_function_1 where f0 != any(2,4,3) order by f0 desc;
select f0, f1, f4 from t_function_1 where f0 > any(2,4,3) order by f0 desc;
select f0, f1, f4 from t_function_1 where f0 < any(2,4,3) order by f0 desc;
select f0, f1, f4 from t_function_1 where f0 >= any(3,4,2) order by f0 desc;
select f0, f1, f4 from t_function_1 where f0 <= any(1,3,2) order by f0 desc;


insert into t_function_2(f0, f1) values(2, 3);
insert into t_function_2(f0, f1) values(3, 4);
insert into t_function_2(f0, f1) values(4, 5);
select f0, f1, f4 from t_function_1 where f0 = any(select f0 from t_function_2) order by f0 desc;
select f0, f1, f4 from t_function_1 where f0 > any(select f0 from t_function_2) order by f0 desc;
select f0, f1, f4 from t_function_1 where f0 < any(select f0 from t_function_2) order by f0 desc;
select f0, f1, f4 from t_function_1 where f0 >= any(select f0 from t_function_2) order by f0 desc;

delete from t_function_2;
insert into t_function_2(f0, f1, f4) values(1, 3, 'D');
insert into t_function_2(f0, f1, f4) values(2, 4, 'B');
insert into t_function_2(f0, f1, f4) values(3, 5, 'C');
commit;

select f0, f1, f4 from t_function_1 where f0 <= any(select f0 from t_function_2) order by f0 desc;
select f0, f1, f4 from t_function_1 where f4 >= any(substr('A',0,1),substr('B',0,1),substr('C',0, 1)) order by f0 desc;
select f0, f1, f4 from t_function_1 where f4 >= any(substr('B',0,1),substr('C',0, 1)) order by f0 desc;
select f0, f1, f4 from t_function_1 where f4 >= any(select substr(f4,0,1) from t_function_2) order by f0 desc;

--- mod
select mod() from dual;
select mod(1) from dual;
select mod(1,2,3) from dual;

select mod('a', 2) from dual;
select mod(1, 'b') from dual;

delete from t_function_1;
insert into t_function_1(f0, f1, f2, f5) values(5, -5, 2.5, -2.5);
commit;
select mod(f0, f0), mod(f1, f1), mod(f2, f2), mod(f5, f5) from t_function_1;
select mod(5, 1.5), mod(5, -1.5) from dual;
select mod(512312312393912312311115, 1.512123), mod(512312312393912312311115, -1.512123) from dual;

--- power
select power() from dual;
select power(1) from dual;
select power(1,2,3) from dual;

select power('a', 2) from dual;
select power(1, 'b') from dual;
select power(0, -0.1) from dual;
select power(-0.1, 1.1) from dual;
select power(4, 5), power(4, 5.4), power(4, 5.9), power(4, 6) from dual;

--- log
select log() from dual;
select log(1,2,3) from dual;
select log('a') from dual;
select log(-0.1) from dual;
select log(0) from dual;
select log(0.5) from dual;

select ln(4.94065645841246E-324) from dual;
select log(1.79769313486231E+308) from dual;

select ln('4.94065645841246E-324') from dual;
select log('1.79769313486231E+308') from dual;

select log('1.79769313486231E+300') from dual;

--- ln
select ln() from dual;
select ln(1,2) from dual;
select ln('a') from dual;
select ln(-0.1) from dual;
select ln(0) from dual;
select ln(0.1), ln(0.9), ln(1), ln(9999999999) from dual;

--- lpad
select lpad() from dual;
select lpad(1) from dual;
select lpad(1,2,3,4) from dual;

select rpad() from dual;
select rpad(1) from dual;
select rpad(1,2,3,4) from dual;

--- round trunc
select round() from dual;
select round(1, 2, 3) from dual;
select trunc() from dual;
select trunc(1, 2, 3) from dual;

select round('a') from dual;

select trunc('a') from dual;

select round(to_date('2018-06-13 12:12:12', 'yyyy-mm-dd hh24:mi:ss'), 'invalid') as round from dual;
select round(to_date('2018-06-13 12:12:12', 'yyyy-mm-dd hh24:mi:ss'), 'hh1234') as round from dual;
select round(to_date('2018-06-13 12:12:12', 'yyyy-mm-dd hh24:mi:ss'), 'ss') as round from dual;

select trunc(to_date('2018-06-13 12:12:12', 'yyyy-mm-dd hh24:mi:ss'), 'invalid') as trunc from dual;
select trunc(to_date('2018-06-13 12:12:12', 'yyyy-mm-dd hh24:mi:ss'), 'hh1234') as trunc from dual;
select trunc(to_date('2018-06-13 12:12:12', 'yyyy-mm-dd hh24:mi:ss'), 'ss') as trunc from dual;

delete from t_function_1;
insert into t_function_1(f0) values(1);
insert into t_function_1(f0) values(2);
commit;
select min(decode(f0, 1, 'abc', 12.34)) from t_function_1;

--uuid()
SELECT UUID(1) FROM DUAL;    --syntax error
SELECT UUID(NULL) FROM DUAL;    --syntax error
SELECT LENGTHB(UUID()) FROM DUAL;  --call directly

DROP TABLE IF EXISTS t_temp_guid;
CREATE TABLE t_temp_guid (col1 INTEGER NOT NULL, col2 VARCHAR(32) DEFAULT UUID());  --uuid() as default
INSERT INTO t_temp_guid(col1) VALUES (1);
INSERT INTO t_temp_guid(col1, col2) VALUES (1, UUID());
SELECT COUNT(col1) FROM t_temp_guid;
DROP TABLE t_temp_guid;

--object_id()
DROP VIEW IF EXISTS v_objectid;
DROP TABLE IF EXISTS t_objectid;
DROP TABLE IF EXISTS t_temp_objectid;
CREATE TABLE t_objectid (col1 INTEGER NOT NULL, col2 VARCHAR(32));
CREATE TABLE t_temp_objectid (col1 INTEGER NOT NULL, col2 VARCHAR(32));
CREATE USER tempuser IDENTIFIED BY Asdf1234;
CREATE VIEW v_objectid AS SELECT col1 FROM t_objectid;

INSERT INTO t_temp_objectid VALUES (1, 't_objectid');
COMMIT;

SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('t_objectid') AND OBJECT_TYPE='TABLE';  --1 row found
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID IN (SELECT OBJECT_ID(col2, 'table') AS id FROM t_temp_objectid WHERE col2 = 't_objectid') AND OBJECT_TYPE='TABLE'; --1 row found
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('SYS_TABLES','TABLE') AND OBJECT_TYPE='TABLE';  --1 row found
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('SYS_TABLES','TABLE', 'tempuser') AND OBJECT_TYPE='TABLE';  --0 row found
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('t_temp_objectid') AND OBJECT_TYPE='TABLE'; --1 row found
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('v_objectid') AND OBJECT_TYPE='VIEW';  --0 row found
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('v_objectid', 'view') AND OBJECT_TYPE='VIEW'; --1 row found
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('v_objectid', 'view', 'tempuser') AND OBJECT_TYPE='VIEW';  --0 row found
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID(TRIM('  t_objectid  '), 'TABLE') AND OBJECT_TYPE='TABLE';  --1 row found
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID IN (SELECT OBJECT_ID(TRIM(col2), 'TABLE', 'sys') FROM t_temp_objectid WHERE col1=1) AND OBJECT_TYPE='TABLE';  --1 row found
SELECT OBJECT_NAME FROM DB_OBJECTS WHERE OBJECT_ID=OBJECT_ID('DV_DATABASE', 'DYNAMIC VIEW') AND OBJECT_TYPE='DYNAMIC VIEW';  --1 row found
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('DV_DATABASE', 'DYNAMIC VIEW', 'tempuser') AND OBJECT_TYPE='DYNAMIC VIEW';  --0 row found

CREATE OR REPLACE TRIGGER trig_objectid
BEFORE INSERT OR UPDATE OF col1 OR DELETE ON t_objectid
BEGIN
  INSERT INTO t_temp_objectid VALUES(100,'triggered');
END;
/

CREATE PROCEDURE proc_objectid(param1 out varchar2)
IS
    tmp varchar2(20) :='12345678';
begin
 param1:=param1||tmp;
end proc_objectid;
/

CREATE FUNCTION func_objectid(A varchar)
RETURN varchar
AS
BEGIN
   if (func_objectid(A) = 'ab') then
   	return A;
   else
   	return func_objectid(A);
   end if; 
END;
/

SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('trig_objectid', 'trigger') AND OBJECT_TYPE='TRIGGER'; --1 row found
SELECT NAME FROM SYS_PROCS WHERE OBJ# = OBJECT_ID('trig_objectid', 'trigger') AND SCN2DATE(ORG_SCN) IN (SELECT CREATED FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('trig_objectid', 'trigger') AND OBJECT_TYPE='TRIGGER');
SELECT NAME FROM SYS_PROCS WHERE OBJ# = OBJECT_ID('trig_objectid', 'trigger') AND SCN2DATE(ORG_SCN) IN (SELECT CREATED FROM ALL_OBJECTS WHERE OBJECT_ID=OBJECT_ID('trig_objectid', 'trigger') AND OBJECT_TYPE='TRIGGER');
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('proc_objectid', 'procedure') AND OBJECT_TYPE='PROCEDURE'; --1 row found
SELECT NAME FROM SYS_PROCS WHERE OBJ# = OBJECT_ID('proc_objectid', 'procedure') AND SCN2DATE(ORG_SCN) IN (SELECT CREATED FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('proc_objectid', 'procedure') AND OBJECT_TYPE='PROCEDURE');
SELECT NAME FROM SYS_PROCS WHERE OBJ# = OBJECT_ID('proc_objectid', 'procedure') AND SCN2DATE(ORG_SCN) IN (SELECT CREATED FROM ALL_OBJECTS WHERE OBJECT_ID=OBJECT_ID('proc_objectid', 'procedure') AND OBJECT_TYPE='PROCEDURE');
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('func_objectid', 'function') AND OBJECT_TYPE='FUNCTION'; --1 row found
SELECT NAME FROM SYS_PROCS WHERE OBJ# = OBJECT_ID('func_objectid', 'function') AND SCN2DATE(ORG_SCN) IN (SELECT CREATED FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('func_objectid', 'function') AND OBJECT_TYPE='FUNCTION');
SELECT NAME FROM SYS_PROCS WHERE OBJ# = OBJECT_ID('func_objectid', 'function') AND SCN2DATE(ORG_SCN) IN (SELECT CREATED FROM ALL_OBJECTS WHERE OBJECT_ID=OBJECT_ID('func_objectid', 'function') AND OBJECT_TYPE='FUNCTION');

SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('v_objectid', 'index');  --syntax error(not supported type)
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_ID=OBJECT_ID('v_objectid', 'view', 'tempuser1'); --user not existed
SELECT OBJECT_ID(123, 'view') FROM DUAL;  --syntax error, incorret datatype for object name
SELECT OBJECT_ID(NULL) FROM DUAL;  --syntax error
SELECT OBJECT_ID() FROM DUAL;  --syntax error, incorrect argument number
SELECT OBJECT_ID(TRIM('  t_objectid  '), 'TABLE', 'SYS', 'VIEW') FROM DUAL;  --syntax error, incorrect argument number
SELECT OBJECT_ID(TRIM('  t_objectid  '), 'TABLE', 'S'||dummy) FROM DUAL;  --syntax error, only const allowed in 3nd argument
SELECT OBJECT_ID('abcd', 'ANONYMOUS BLOCK') FROM DUAL;  -- unsupported type

DROP TRIGGER trig_objectid;
DROP PROCEDURE proc_objectid;
DROP FUNCTION func_objectid;
DROP USER tempuser CASCADE;
DROP TABLE t_temp_objectid;
DROP VIEW v_objectid;
DROP TABLE t_objectid;

--sys_context() & userenv
DROP TABLE IF EXISTS t_myenv;
CREATE TABLE t_myenv(option VARCHAR(32) NOT NULL, oplen INTEGER);

INSERT INTO t_myenv VALUES('sid', 11);
INSERT INTO t_myenv VALUES('terminal', 4000);
INSERT INTO t_myenv VALUES('terminal', 1);
COMMIT;

SELECT COUNT(user_name) FROM V$ME WHERE SID IN (SELECT SYS_CONTEXT('USERENV', 'SID') FROM DUAL);
SELECT COUNT(user_name) FROM V$ME WHERE SID IN (SELECT CAST(SYS_CONTEXT('USERENV', option, (8 - 9)) AS INTEGER) FROM t_myenv WHERE option='sid');
SELECT COUNT(user_name) FROM V$ME WHERE SID IN (SELECT USERENV('SID') FROM DUAL);
SELECT COUNT(user_name) FROM V$ME WHERE SID IN (SELECT CAST(USERENV(option) AS INTEGER) FROM t_myenv WHERE option='sid');
SELECT COUNT(user_name) FROM V$ME WHERE OS_HOST IN (SELECT SYS_CONTEXT('USER'|| 'ENV', TRIM('TERMINAL'))) LIMIT 1;
SELECT COUNT(user_name) FROM V$ME WHERE OS_HOST IN (SELECT SYS_CONTEXT('USER'|| 'ENV', TRIM(BOTH FROM option)) FROM t_myenv WHERE option='terminal') LIMIT 1;
SELECT COUNT(user_name) FROM V$ME WHERE OS_HOST IN (SELECT SYS_CONTEXT('USER'|| 'ENV', TRIM(BOTH FROM option), oplen) FROM t_myenv WHERE option='terminal' AND oplen=1);   -- 0 row found, too short buffer
SELECT COUNT(user_name) FROM V$ME WHERE OS_HOST IN (SELECT SYS_CONTEXT('USER'|| 'ENV', TRIM(BOTH FROM option), oplen) FROM t_myenv WHERE option='terminal');
SELECT COUNT(user_name) FROM V$ME WHERE OS_HOST IN (SELECT USERENV(TRIM(BOTH FROM option)) FROM t_myenv WHERE option='terminal') LIMIT 1;
SELECT COUNT(user_name) FROM V$ME WHERE OS_HOST IN (SELECT USERENV('TERMINAL') FROM DUAL);
SELECT COUNT(user_name) FROM V$ME WHERE OS_HOST IN (SELECT SYS_CONTEXT('USER'|| 'ENV', TRIM('TERMINAL'), NULL)); --NULL can be implictly converted to INTEGER, so 1 row found
SELECT COUNT(user_name) FROM V$ME WHERE OS_HOST IN (SELECT SYS_CONTEXT('USER'|| 'ENV', TRIM('TERMINAL'), ABS(8 - 9)));  -- 0 row found, too short buffer
select COUNT(sid) from  v$session where sid=userenv('sid');
SELECT COUNT(user_name) FROM V$ME WHERE CURR_SCHEMA IN (SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') FROM DUAL);
SELECT COUNT(user_name) FROM V$ME WHERE USER_ID IN (SELECT SYS_CONTEXT('USER'||'ENV', 'CURRENT_SCHEMAID') FROM DUAL);
SELECT COUNT(DBID) FROM V$DATABASE WHERE NAME IN (SELECT SYS_CONTEXT('USERENV', 'DB_NAME') FROM DUAL);
SELECT COUNT(user_name) FROM V$ME WHERE OS_USER IN (SELECT SYS_CONTEXT('USERENV', 'OS_USER') FROM DUAL);
SELECT COUNT(user_name) FROM V$ME WHERE CURR_SCHEMA IN (SELECT USERENV('CURRENT_SCHEMA') FROM DUAL);
SELECT COUNT(user_name) FROM V$ME WHERE USER_ID IN (SELECT USERENV('CURRENT_SCHEMAID') FROM DUAL);
SELECT COUNT(DBID) FROM V$DATABASE WHERE NAME IN (SELECT USERENV('DB_NAME') FROM DUAL);
SELECT COUNT(user_name) FROM V$ME WHERE OS_USER IN (SELECT USERENV('OS_USER') FROM DUAL);

SELECT SYS_CONTEXT('USER_ENV', 'SID') FROM DUAL; --namespace error
SELECT SYS_CONTEXT('USERENV', 'UID') FROM DUAL; --option error
SELECT SYS_CONTEXT(NULL, 'SID') FROM DUAL; --namespace error
SELECT SYS_CONTEXT('USERENV', NULL) FROM DUAL; --option error
SELECT SYS_CONTEXT('USERENV', 32) FROM DUAL; --option error
SELECT SYS_CONTEXT('USERENV', 'SID', 'AAA') FROM DUAL; --length error
SELECT SYS_CONTEXT('USERENV', 'SID', 32, 1) FROM DUAL; --invalid parameter
SELECT SYS_CONTEXT('USERENV') FROM DUAL; --invalid parameter
SELECT USERENV('LANG') FROM DUAL; --option error
SELECT USERENV('LANGUAGE') FROM DUAL; --option error
SELECT USERENV('ISDBA') FROM DUAL; --option error
SELECT USERENV('ENTRYID') FROM DUAL; --option error
SELECT USERENV('CLIENT_INFO') FROM DUAL; --option error
SELECT USERENV('SESSIONID') FROM DUAL; --option error
SELECT USERENV() FROM DUAL; --invalid parameter
SELECT USERENV('SID',32) FROM DUAL; --invalid parameter

DROP TABLE t_myenv;

select convert(1234.456, number(10, 2)) from dual;
select convert('1234.456', number(10, 2)) from dual;
select convert(1234.456, signed int) from dual;
select convert('1970-01-01 00:00:00.000', timestamp) from dual;
select convert('1970-01-01 00:00:00', datetime) from dual;
select reverse('asdf');
select reverse(cast('asdf' as varchar(4)));
select reverse(12345);
select reverse(cast('2018-07-18' as datetime));

--sql_verify_round_trunc error
select round(f0) from t_function_4;
select trunc(f0) from t_function_4;
select round(sysdate, sysdate) from t_function_4;
select trunc(12345678, sysdate) from t_function_4;
select round(1234.5678, sysdate) from t_function_4;
select trunc('1234.5678', sysdate) from t_function_4;

--get_lock() & release_lock(): basic functionality
DROP TABLE IF EXISTS t_shared_locks;
CREATE TABLE t_shared_locks(name VARCHAR(128) NOT NULL, timeout INTEGER);

INSERT INTO t_shared_locks VALUES('a001', 3);
INSERT INTO t_shared_locks VALUES('b002', -32);
INSERT INTO t_shared_locks VALUES('c003', 10);
INSERT INTO t_shared_locks VALUES('d004', 0);
INSERT INTO t_shared_locks VALUES('e005', 10);
INSERT INTO t_shared_locks VALUES('f006', 10);
INSERT INTO t_shared_locks VALUES('g007', 10);
INSERT INTO t_shared_locks VALUES('h008', 10);
INSERT INTO t_shared_locks VALUES('i009', 10);
INSERT INTO t_shared_locks VALUES('j010', 10);
INSERT INTO t_shared_locks VALUES('k011', 10);
INSERT INTO t_shared_locks VALUES('l012', 10);
INSERT INTO t_shared_locks VALUES('m013', 10);
INSERT INTO t_shared_locks VALUES('n014', 10);
INSERT INTO t_shared_locks VALUES('o015', 10);
INSERT INTO t_shared_locks VALUES('p016', 10);
INSERT INTO t_shared_locks VALUES('p016', 3);    --duplicate
INSERT INTO t_shared_locks VALUES('p016', -32767);  --duplicate
INSERT INTO t_shared_locks VALUES('q017', 10);
INSERT INTO t_shared_locks VALUES('r018', 10);
INSERT INTO t_shared_locks VALUES('s019', 10);
INSERT INTO t_shared_locks VALUES('t020', 10);
INSERT INTO t_shared_locks VALUES('u021', 10);
INSERT INTO t_shared_locks VALUES('v022', 10);
INSERT INTO t_shared_locks VALUES('w023', 10);
INSERT INTO t_shared_locks VALUES('x024', 10);
INSERT INTO t_shared_locks VALUES('y025', 10);
INSERT INTO t_shared_locks VALUES('z026', 10);
INSERT INTO t_shared_locks VALUES('asdfqwerasdfqwerasdfqwerasdfqwerasdfqwerasdfqwerasdfqwerasdfqwer', 100);
INSERT INTO t_shared_locks VALUES('qwer1234', 1);
INSERT INTO t_shared_locks VALUES('a001', 1); --duplicate
INSERT INTO t_shared_locks VALUES('a0001', 1);
INSERT INTO t_shared_locks VALUES('b0002', 1);
INSERT INTO t_shared_locks VALUES('c0003', 3);
INSERT INTO t_shared_locks VALUES('d0004', 3);
COMMIT;

SELECT GET_LOCK(name, timeout) FROM t_shared_locks;
SELECT LOCK_NAME, LOCK_TIMES FROM V$USER_ADVISORY_LOCKS WHERE SID=CONNECTION_ID() ORDER BY LOCK_NAME;

INSERT INTO t_shared_locks VALUES('e0005', 12);
COMMIT;
SELECT GET_LOCK(name, timeout) FROM t_shared_locks WHERE name='e005';
SELECT COUNT(LOCK_NAME) FROM V$USER_ADVISORY_LOCKS WHERE SID=CONNECTION_ID();  --32
SELECT RELEASE_LOCK(name) FROM t_shared_locks;  --mixed with 35 number '1' and a NULL

DELETE FROM t_shared_locks;
INSERT INTO t_shared_locks VALUES('asdfqwerasdfqwerasdfqwerasdfqwerasdfqwerasdfqwerasdfqwerasdfqwerX', 3);
COMMIT;
SELECT GET_LOCK(name, timeout) FROM t_shared_locks;
SELECT COUNT(LOCK_NAME) FROM V$USER_ADVISORY_LOCKS WHERE SID=CONNECTION_ID();  --0 rows

SELECT GET_LOCK('32767', 'a') FROM DUAL;  -- timeout invalid
SELECT GET_LOCK() FROM DUAL;  -- invalid parameter count
SELECT GET_LOCK('32767', 'a', 33) FROM DUAL;  -- invalid parameter count
SELECT RELEASE_LOCK() FROM DUAL;  -- invalid parameter count
SELECT RELEASE_LOCK('32767', 3) FROM DUAL;  -- invalid parameter count 

DROP TABLE t_shared_locks;

--found_rows()

DROP TABLE IF EXISTS foobar;
DROP TABLE IF EXISTS footemp;
CREATE TABLE foobar (col1 INTEGER NOT NULL, col2 VARCHAR(32));
CREATE TABLE footemp (col1 INTEGER NOT NULL, col2 VARCHAR(32));

INSERT INTO foobar VALUES (1, 'aaa');
INSERT INTO foobar VALUES (2, 'b');
INSERT INTO foobar VALUES (3, 'cc');
INSERT INTO foobar VALUES (4, 'ddd');
INSERT INTO foobar VALUES (5, 'eeee');
INSERT INTO foobar VALUES (6, 'aaa');
INSERT INTO foobar VALUES (7, 'bbb');
INSERT INTO foobar VALUES (8, 'b');
INSERT INTO foobar VALUES (9, 'cc');
INSERT INTO foobar VALUES (10, 'dddd');
INSERT INTO foobar VALUES (11, 'aaa');
INSERT INTO foobar VALUES (12, 'f'); 
INSERT INTO foobar VALUES (4, 'aaa');
INSERT INTO foobar VALUES (6, 'bb');
INSERT INTO foobar VALUES (7, 'ccc');
INSERT INTO foobar VALUES (9, 'ddd');
INSERT INTO foobar VALUES (12, 'ee');
INSERT INTO foobar VALUES (1, 'eeee');
INSERT INTO foobar VALUES (3, 'b');
INSERT INTO foobar VALUES (7, 'ff');

COMMIT;

INSERT INTO footemp VALUES (1, 'aaa');
INSERT INTO footemp VALUES (2, 'b');
INSERT INTO footemp VALUES (3, 'cc');
INSERT INTO footemp VALUES (4, 'ddd');
INSERT INTO footemp VALUES (5, 'eeee');
INSERT INTO footemp VALUES (6, 'aaa');
INSERT INTO footemp VALUES (7, 'bbb');
INSERT INTO footemp VALUES (8, 'b');

COMMIT;

--in the documentation of mysql, the usage with the absense of "SQL_CALC_FOUND_ROWS", 
--the description of this usage is:
--"In the absence of the SQL_CALC_FOUND_ROWS option in the most recent successful SELECT statement, 
--FOUND_ROWS() returns the number of rows in the result set returned by that statement"
--
--HOWEVER, mysql did not implement it completely according to its own description,
--so we have to test this kind of usage by comparing the result set
SELECT * FROM foobar ORDER BY col1, col2;
SELECT FOUND_ROWS();

SELECT * FROM foobar ORDER BY col1, col2 LIMIT 5, 3;
SELECT FOUND_ROWS();

SELECT * FROM foobar WHERE col1 >11 ORDER BY col1, col2 LIMIT 5, 3;
SELECT FOUND_ROWS();

SELECT col1, col2 FROM foobar WHERE col1 > 10 UNION ALL SELECT col1, col2 FROM footemp ORDER BY col1, col2;
SELECT FOUND_ROWS();

(SELECT col1, col2 FROM foobar WHERE col1 > 10 ORDER BY col1, col2 LIMIT 2) UNION ALL SELECT col1, col2 FROM footemp ORDER BY col1 DESC, col2;
SELECT FOUND_ROWS();

(SELECT col1, col2 FROM foobar WHERE col1 > 10 ORDER BY col1, col2 LIMIT 2) UNION ALL SELECT col1, col2 FROM footemp ORDER BY col2, col1 LIMIT 3;
SELECT FOUND_ROWS();

(SELECT col1, col2 FROM foobar WHERE col1 > 10) UNION ALL (SELECT col1, col2 FROM footemp ORDER BY col1, col2 LIMIT 2) ORDER BY col2, col1 LIMIT 3;
SELECT FOUND_ROWS();

SELECT col1, col2 FROM foobar WHERE col1 < 10 UNION SELECT col1, col2 FROM footemp ORDER BY col1, col2 LIMIT 2;
SELECT FOUND_ROWS();

SELECT col1, col2 FROM ((SELECT col1, col2 FROM foobar WHERE col1 > 5) UNION (SELECT col1, col2 FROM footemp ORDER BY col1, col2 LIMIT 2)) temp ORDER BY col2, col1 LIMIT 2, 3;
SELECT FOUND_ROWS();

SELECT col1, col2 FROM (SELECT f1.col1 as col1, f1.col2 as col2 FROM foobar f1 JOIN footemp f2 ON f1.col1 = f2.col1 ORDER BY f1.col1, f1.col2 LIMIT 5) temp ORDER BY col2, col1 LIMIT 2, 3;
SELECT FOUND_ROWS();

SELECT col1, col2 FROM foobar WHERE col1 in (SELECT col1 FROM footemp) ORDER BY col1, col2 LIMIT 5, 4;
SELECT FOUND_ROWS();

SELECT SQL_CALC_FOUND_ROWS * FROM foobar MINUS SELECT * FROM footemp ORDER BY col1, col2 LIMIT 5, 3;
SELECT 1 FROM DUAL WHERE FOUND_ROWS() = (SELECT COUNT(col1) FROM (SELECT * FROM foobar MINUS SELECT * FROM footemp ORDER BY col1, col2) temp);  --expect: 1 row fetched
SELECT * FROM foobar MINUS SELECT * FROM footemp ORDER BY col1, col2 LIMIT 5, 3;
SELECT 1 FROM DUAL WHERE FOUND_ROWS() = (SELECT COUNT(col1) FROM (SELECT * FROM foobar MINUS SELECT * FROM footemp ORDER BY col1, col2) temp);  --expect: 0 row fetched

--query a dynamic view (no table entity at all)
SELECT SQL_CALC_FOUND_ROWS ID FROM V$DATAFILE LIMIT 100, 2;  --no row retrived due to limit's offset
SELECT 1 FROM DUAL WHERE FOUND_ROWS() = (SELECT COUNT(ID) FROM V$DATAFILE);  -- expect: 1 row fetched
SELECT ID FROM V$DATAFILE LIMIT 100, 2;
SELECT 1 FROM DUAL WHERE FOUND_ROWS() = (SELECT COUNT(ID) FROM V$DATAFILE);  -- expect: 0 row fetched

--syntax check
SELECT col1, col2 FROM (SELECT SQL_CALC_FOUND_ROWS f1.col1 as col1, f1.col2 as col2 FROM foobar f1 JOIN footemp f2 ON f1.col1 = f2.col1 ORDER BY f1.col1, f1.col2 LIMIT 5) temp ORDER BY col2, col1 LIMIT 2, 3;
SELECT col1, col2 FROM foobar WHERE col1 > 10 UNION ALL SELECT SQL_CALC_FOUND_ROWS col1, col2 FROM footemp ORDER BY col1, col2;
SELECT col1, col2 FROM foobar WHERE col1 in (SELECT SQL_CALC_FOUND_ROWS col1 FROM footemp) ORDER BY col1, col2 LIMIT 5, 4;
SELECT SQL_CALC_FOUND_ROWS col1, col2 FROM foobar WHERE col1 > 10 UNION ALL SELECT SQL_CALC_FOUND_ROWS col1, col2 FROM footemp ORDER BY col1, col2;

SELECT * FROM foobar ORDER BY col1, col2 LIMIT 0 offset 2;
SELECT FOUND_ROWS();
SELECT * FROM foobar union all SELECT * FROM foobar ORDER BY col1, col2 LIMIT 0 offset 3;
SELECT FOUND_ROWS();

DROP TABLE foobar;
DROP TABLE footemp;

--sha1()
SELECT SHA1() FROM DUAL;  --syntax error
SELECT SHA1(123, 456) FROM DUAL;  --syntax error
SELECT LENGTH(SHA1('')) AS L, SHA1('') AS SHA FROM DUAL;  --zenith's empty string is NULL
SELECT LENGTH(SHA1(HEX2BIN('0x112233'))) AS L, SHA1(HEX2BIN('0x112233')) AS SHA FROM DUAL;

drop table t_function_1;
drop table t_function_2;
drop table t_function_3;
drop table t_function_4;
drop table t_function_5;
drop table t_function_6;

select nvl(null, 'abc') from dual;
select nvl(null, to_timestamp('2012-12-12 12:12:12.121212')) from dual;
select nvl(null, to_timestamp('2012-12-12 12:12:12.121212')) + 1 from dual;
select nvl('', to_timestamp('2012-12-12 12:12:12.121212')) + 1 from dual;
select cast((select 1234 from dual) as varchar(20)) as abc from dual;

------------------------ substring_index ------------------------
select substring_index ();
select substring_index ('abc');
select substring_index ('abc', 'abc');
select substring_index ('abc', 'abc', 1, 1);
select substring_index ('abc', 'abc', 'a');
select substring_index ('1aaaaaaaa2', 'aa', 2147483648);
select substring_index ('1aaaaaaaa2', 'aa', -2147483649);
select 1 from dual where substring_index ('1aaaaaaaa2', 'aa', 0) is null;
select substring_index ('1aaaaaaaa2', 'aaaaaaaa', 0);
select substring_index ('1aaaaaaaa2', '1aaaaaaaa2', 0);
select substring_index ('1aaaaaaaa2', '1aaaaaaaa2', 1);
select substring_index('aaaaaaaaa1','a',1);
select substring_index('aaaaaaaaa1','aa',1);
select substring_index('aaaaaaaaa1','aaa',1);
select substring_index('aaaaaaaaa1','aaaa',1);
select substring_index('www.tcx.se','',3);
select 1 from dual where substring_index ('1aaaaaaaa2', 'aa', 0) is null;

drop table if exists t1;
create table t1 (c varchar(40));
insert into t1 values ('y,abc'),('y,abc');
select c, substring_index(lower(c), ',', -1) as res from t1;
drop table t1;

CREATE TABLE t (i INT NOT NULL, c CHAR(255) NOT NULL);
INSERT INTO t VALUES (0,'.www.mysql.com'),(1,'.wwwmysqlcom');
SELECT i, SUBSTRING_INDEX(c, '.', -2) FROM t WHERE i = 1;
SELECT i, SUBSTRING_INDEX(c, '.', -2) FROM t;
drop table t;

-- test utf8
select substring_index ('分隔F华为分隔F技术分隔F有限分隔F公司分隔F', '分隔F', 0); 
select substring_index ('分隔F华为分隔F技术分隔F有限分隔F公司分隔F', '分隔F', 1); 
select substring_index ('分隔F华为分隔F技术分隔F有限分隔F公司分隔F', '分隔F', 2); 
select substring_index ('分隔F华为分隔F技术分隔F有限分隔F公司分隔F', '分隔F', 3); 
select substring_index ('分隔F华为分隔F技术分隔F有限分隔F公司分隔F', '分隔F', 4); 
select substring_index ('分隔F华为分隔F技术分隔F有限分隔F公司分隔F', '分隔F', 5); 
select substring_index ('分隔F华为分隔F技术分隔F有限分隔F公司分隔F', '分隔F', 6);
select substring_index ('分隔F华为分隔F技术分隔F有限分隔F公司分隔F', '分隔F', 7);
select substring_index ('分隔F华为分隔F技术分隔F有限分隔F公司分隔F', '分隔F', -1); 
select substring_index ('分隔F华为分隔F技术分隔F有限分隔F公司分隔F', '分隔F', -2); 
select substring_index ('分隔F华为分隔F技术分隔F有限分隔F公司分隔F', '分隔F', -3); 
select substring_index ('分隔F华为分隔F技术分隔F有限分隔F公司分隔F', '分隔F', -4); 
select substring_index ('分隔F华为分隔F技术分隔F有限分隔F公司分隔F', '分隔F', -5); 
select substring_index ('分隔F华为分隔F技术分隔F有限分隔F公司分隔F', '分隔F', -6);
select substring_index ('1华华华华华2', '华华', 0);
select substring_index ('1华华华华华2', '华华', 1);
select substring_index ('1华华华华华2', '华华', 2);
select substring_index ('1华华华华华2', '华华', 3);
select substring_index ('1华华华华华2', '华华', -1);
select substring_index ('1华华华华华2', '华华', -2);
select substring_index ('1华华华华华2', '华华', -3);
select substring_index ('1华华华华华2', '1华华华华华2', 1);
select substring_index ('1华华华华华2', '1华华华华华华2', 1);
select substring_index ('1华华2', SUBSTRB('华', 1, 1), 1);
select substring_index ('1华华2', unhex('E58'), 1);

------------------------ COALESCE ------------------------
select COALESCE();
select COALESCE(1, 1.0, sysdate);

CREATE TABLE t1 (EMPNUM INT);
CREATE TABLE t2 (EMPNUM DECIMAL (4, 2));
INSERT INTO t1 VALUES (0), (2);
INSERT INTO t2 VALUES (0.0), (9.0);
SELECT COALESCE(t2.EMPNUM,t1.EMPNUM) AS CEMPNUM, t1.EMPNUM AS EMPMUM1, t2.EMPNUM AS EMPNUM2 FROM t1 LEFT JOIN t2 ON t1.EMPNUM=t2.EMPNUM;
DROP TABLE t1;
DROP TABLE t2;

CREATE TABLE CASE_TBL ( i integer, f double precision);
CREATE TABLE CASE2_TBL ( i integer, j integer);
INSERT INTO CASE_TBL VALUES (1, 10.1);
INSERT INTO CASE_TBL VALUES (2, 20.2);
INSERT INTO CASE_TBL VALUES (3, -30.3);
INSERT INTO CASE_TBL VALUES (4, NULL);
INSERT INTO CASE2_TBL VALUES (1, -1);
INSERT INTO CASE2_TBL VALUES (2, -2);
INSERT INTO CASE2_TBL VALUES (3, -3);
INSERT INTO CASE2_TBL VALUES (2, -4);
INSERT INTO CASE2_TBL VALUES (1, NULL);
INSERT INTO CASE2_TBL VALUES (NULL, -6);
SELECT * FROM CASE_TBL WHERE COALESCE(f,i) = 4;
SELECT COALESCE(a.f, b.i, b.j) FROM CASE_TBL a, CASE2_TBL b;
SELECT * FROM CASE_TBL a, CASE2_TBL b WHERE COALESCE(a.f, b.i, b.j) = 2;
SELECT * FROM CASE_TBL a, CASE2_TBL b WHERE COALESCE(f, b.i) = 2;
DROP TABLE CASE_TBL;
DROP TABLE CASE2_TBL;

create or replace procedure f(op varchar, n int)
as
    v_order number;
begin
    for i in 1..n
    loop
        if op = 'CREATE' then
            execute immediate 'CREATE TABLE t_' || i || ' (c1 INT)';
            execute immediate 'INSERT INTO t_' || i || ' VALUES (' || i || ')';
        else
            execute immediate 'DROP TABLE t_' || i;
        end if;
    end loop;
end;
/

exec f ('CREATE', 129);
select 1 from t_1, t_2, t_3, t_4, t_5, t_6, t_7, t_8, t_9, t_10, t_11, t_12, t_13, t_14, t_15, t_16, t_17, t_18, t_19, t_20, t_21, t_22, t_23, t_24, t_25, t_26, t_27, t_28, t_29, t_30, t_31, t_32;

select 1 from t_1, t_2, t_3, t_4, t_5, t_6, t_7, t_8, t_9, t_10, t_11, t_12, t_13, t_14, t_15, t_16, t_17, t_18, t_19, t_20, t_21, t_22, t_23, t_24, t_25, t_26, t_27, t_28, t_29, t_30, t_31, t_32, t_33;

select 1 from t_1, t_2, t_3, t_4, t_5, t_6, t_7, t_8, t_9, t_10, t_11, t_12, t_13, t_14, t_15, t_16, t_17, t_18, t_19, t_20, t_21, t_22, t_23, t_24, t_25, t_26, t_27, t_28, t_29, t_30, t_31, t_32, t_33, t_34, t_35, t_36, t_37, t_38, t_39, t_40, t_41, t_42, t_43, t_44, t_45, t_46, t_47, t_48, t_49, t_50, t_51, t_52, t_53, t_54, t_55, t_56, t_57, t_58, t_59, t_60, t_61, t_62, t_63, t_64, t_65, t_66, t_67, t_68, t_69, t_70, t_71, t_72, t_73, t_74, t_75, t_76, t_77, t_78, t_79, t_80, t_81, t_82, t_83, t_84, t_85, t_86, t_87, t_88, t_89, t_90, t_91, t_92, t_93, t_94, t_95, t_96, t_97, t_98, t_99, t_100, t_101, t_102, t_103, t_104, t_105, t_106, t_107, t_108, t_109, t_110, t_111, t_112, t_113, t_114, t_115, t_116, t_117, t_118, t_119, t_120, t_121, t_122, t_123, t_124, t_125, t_126, t_127, t_128;

select 1 from t_1, t_2, t_3, t_4, t_5, t_6, t_7, t_8, t_9, t_10, t_11, t_12, t_13, t_14, t_15, t_16, t_17, t_18, t_19, t_20, t_21, t_22, t_23, t_24, t_25, t_26, t_27, t_28, t_29, t_30, t_31, t_32, t_33, t_34, t_35, t_36, t_37, t_38, t_39, t_40, t_41, t_42, t_43, t_44, t_45, t_46, t_47, t_48, t_49, t_50, t_51, t_52, t_53, t_54, t_55, t_56, t_57, t_58, t_59, t_60, t_61, t_62, t_63, t_64, t_65, t_66, t_67, t_68, t_69, t_70, t_71, t_72, t_73, t_74, t_75, t_76, t_77, t_78, t_79, t_80, t_81, t_82, t_83, t_84, t_85, t_86, t_87, t_88, t_89, t_90, t_91, t_92, t_93, t_94, t_95, t_96, t_97, t_98, t_99, t_100, t_101, t_102, t_103, t_104, t_105, t_106, t_107, t_108, t_109, t_110, t_111, t_112, t_113, t_114, t_115, t_116, t_117, t_118, t_119, t_120, t_121, t_122, t_123, t_124, t_125, t_126, t_127, t_128, t_129;
exec f ('DROP', 129);
drop procedure f;

------------------------ INET_ATON/INET_ATON ------------------------
SELECT INET_ATON();
SELECT INET_ATON('192.168.0.1', '192.168.0.1');

SELECT INET_NTOA();
SELECT INET_NTOA(3232235777, 3232235777);
SELECT INET_ATON('192.168.0.1', '192.168.0.1');

create table t (c1 varchar(32), c2 bigint);
insert into t(c1) values ('0.0.0.0'), ('255.255.255.255'), ('192'), ('192.168'), ('192.168.1'), ('192.168.1.1');
update t set c2 = INET_ATON(c1);
select c1, INET_NTOA(INET_ATON(c1)), INET_NTOA(c2) from t;
drop table t;

-- exp function
select exp(1) from dual;
select exp(1.0000001) from dual;
select exp(1.0002001) from dual;

set numwidth 52

-- 999999999762152445725379529943075819906419806989267740414730640455962
select exp(294.730891903) from dual;
-- overflow
select exp(294.74) from dual;

select exp(sin(1)) from dual;
select exp(1/(exp(1))) from dual;
select exp(-200) from dual;
-- 3710173544167487172.12828418891805441346872282187877122211
select exp(exp(exp(1.323234))) from dual;

-- ln function
select ln(1.234234423412342134E-1) from dual;
select ln(9.999999999999999999E-127) from dual;
select exp(ln(123)) from dual;
select ln(exp(123)) from dual;
select ln(exp(123.12312333452134214213421344)) from dual;
select ln(9.999999999999999999E-128) from dual;
select ln(9.999999999999999999E-129) from dual;
select ln(9.999999999999999999E128) from dual;

-- power(dec, dec) function
select power(235423542354.123 0.2134) from dual;
select power(12, -2) from dual;
select power(12, -3) from dual;
select power(exp(1), exp(1)) from dual;
select power(1.23234213412342134234234E-10, 0.2343434234E-5) from dual;
select power(1.23234213412342134234234, 1000.82354) from dual;
select power(9999999999999995,1.11111111) from dual;

-- Oracle on this case return error result
select mod(2.71828182845904523536028747135266249776E100, 2.1235) from dual;
select mod(9.999999999999999999999999999999999e+100,9223372036854775807) from dual;

-- DTS2018073002746
select ceil(0.099990000000000000000000000000000000001) from dual;
select ceil(99.009) from dual;
select ceil(-99.009) from dual;

-- DTS2018073005956
select convert('1970-1-1 00:00:00.000', DATETIME) from dual;
select convert('1970-1-1 00:00:00.000', timestamp) from dual;
select convert('1970-1-1 00:00:00.000', timestamp(1)) from dual;

------------------------------------ modular operator ----------------------------------
---- RETURN TYPE & mixed cacl ----
create table t1 (
    id int,
    c_int int, 
    c_bigint bigint,
    c_real real,
    c_number number,
    c_decimal decimal,
    c_char char(32),
    c_varchar varchar(32)
);
insert into t1 values (1, 2147483647,  9223372036854775807, 1234567890123.123456, 999999999999999999.9999999999999999999, 123456789, '79213473294793249.8793', '29834739287.298332');
insert into t1 values (2, -2147483648, -9223372036854775808, -1234567890123.123456, -999999999999999999.9999999999999999999, -123456789, '-79213473294793249.8793', '-29834739287.298332');
insert into t1 values (3, 2147483647,  -9223372036854775807, 1234567890123.123456, -999999999999999999.9999999999999999999, 123456789, '-79213473294793249.8793', '29834739287.298332');
insert into t1 values (4, -2147483648, 9223372036854775807, -1234567890123.123456, 999999999999999999.9999999999999999999, -123456789, '79213473294793249.8793', '-29834739287.298332');

create table t as
select
    id,
    c_int % c_int      AS i4_i4,
    c_int % c_bigint   AS i4_i8,
    c_int % c_real     AS i4_real,
    c_int % c_number   AS i4_number,
    c_int % c_decimal  AS i4_decimal, 
    c_int % c_char     AS i4_char,
    c_int % c_varchar  AS i4_varchar
from t1;
desc t;
select * from t order by id;
drop table t;

create table t as
select 
    id,
    c_bigint % c_int      AS i8_i4,
    c_bigint % c_bigint   AS i8_i8,
    c_bigint % c_real     AS i8_real,
    c_bigint % c_number   AS i8_number,
    c_bigint % c_decimal  AS i8_decimal, 
    c_bigint % c_char     AS i8_char,
    c_bigint % c_varchar  AS i8_varchar
from t1;
desc t;
select * from t order by id;
drop table t;

create table t as
select 
    id,
    c_real % c_int      AS real_i4,
    c_real % c_bigint   AS real_i8,
    c_real % c_real     AS real_real,
    c_real % c_number   AS real_number,
    c_real % c_decimal  AS real_decimal, 
    c_real % c_char     AS real_char,
    c_real % c_varchar  AS real_varchar
from t1;
desc t;
select * from t order by id;
drop table t;

create table t as
select 
    id,
    c_number % c_int      AS number_i4,
    c_number % c_bigint   AS number_i8,
    c_number % c_real     AS number_real,
    c_number % c_number   AS number_number,
    c_number % c_decimal  AS number_decimal, 
    c_number % c_char     AS number_char,
    c_number % c_varchar  AS number_varchar
from t1;
desc t;
select * from t order by id;
drop table t;

create table t as
select 
    id,
    c_decimal % c_int      AS decimal_i4,
    c_decimal % c_bigint   AS decimal_i8,
    c_decimal % c_real     AS decimal_real,
    c_decimal % c_number   AS decimal_number,
    c_decimal % c_decimal  AS decimal_decimal, 
    c_decimal % c_char     AS decimal_char,
    c_decimal % c_varchar  AS decimal_varchar
from t1;
desc t;
select * from t order by id;
drop table t;

create table t as
select 
    id,
    c_char % c_int      AS char_i4,
    c_char % c_bigint   AS char_i8,
    c_char % c_real     AS char_real,
    c_char % c_number   AS char_number,
    c_char % c_decimal  AS char_decimal, 
    c_char % c_char     AS char_char,
    c_char % c_varchar  AS char_varchar
from t1;
desc t;
select * from t order by id;
drop table t;

create table t as
select 
    id,
    c_varchar % c_int      AS varchar_i4,
    c_varchar % c_bigint   AS varchar_i8,
    c_varchar % c_real     AS varchar_real,
    c_varchar % c_number   AS varchar_number,
    c_varchar % c_decimal  AS varchar_decimal, 
    c_varchar % c_char     AS varchar_char,
    c_varchar % c_varchar  AS varchar_varchar
from t1;
desc t;
select * from t order by id;
drop table t;
drop table t1;
drop table t2;

---- unsupported type ----
SELECT CAST(NULL AS CLOB) % 1;
SELECT CAST(NULL AS BLOB) % 1;
SELECT CAST(NULL AS BOOL) % 1;
SELECT CAST(NULL AS DATETIME) % 1;
SELECT CAST(NULL AS TIMESTAMP) % 1;
SELECT CAST(NULL AS TIMESTAMP WITH TIME ZONE) % 1;
SELECT CAST(NULL AS TIMESTAMP WITH LOCAL TIME ZONE) % 1;
SELECT CAST(NULL AS INTERVAL DAY(1) TO SECOND) % 1;
SELECT CAST(NULL AS INTERVAL YEAR(1) TO MONTH) % 1;

---- test wrong string ----
select 'a' % 1;
select 1 % 'a';
select 1 % '2';

---- test null ----
select null % null;
select null % 1;
select 1 % null;

---- test zero ----
select cast(0 AS signed int) % 10;
select 10 % cast(0 AS signed int);

create table t (c_int int, c_bigint int);
insert into t values (10, 10);
select 0 % c_int, c_int % 0, 0 % c_bigint, c_bigint % 0 from t;
drop table t;

-- Zenith REAL = MySQL REAL = Oracle BINARY_DOUBLE, CT_REAL_PRECISION: (double)0.000000000000001
create table t (id int, v_real REAL, v_real2 REAL, v_real3 REAL);
insert into t values (1, 0.000000000000001,  10, 0.000000000000017);
insert into t values (1, 0.000000000000007,  10, 0.000000000000017);
insert into t values (1, 0.0000000000000001, 10, 0.000000000000017); 
select v_real2 % v_real, v_real3 % v_real from t;
-- select mod(v_real2, v_real), mod(v_real3, v_real) from t;
drop table t;

create table t (id int, v_decimal decimal(38, 1));
insert into t values (1, 1234567890123456789012345678901234567.8);
-- select mod(v_decimal, cast(0.000001 as decimal(15, 10))) from t;
-- select mod(v_decimal, cast(0.000007 as decimal(15, 10))) from t;
-- select mod(v_decimal, cast(0.0000000007 as decimal(15, 10))) from t;
select v_decimal%cast(0.000001 as decimal(15, 10)) from t;
select v_decimal%cast(0.000007 as decimal(15, 10)) from t;
select v_decimal%cast(0.0000000007 as decimal(15, 10)) from t;
drop table t;

--regexp_instr
drop table if exists test_regexp_instr;
create table test_regexp_instr as select regexp_instr('abceabceffabcabc','abc',5.3) as c from dual;
select * from test_regexp_instr;
desc test_regexp_instr;

---- text conflict with pl attr %type/rowtype/found/notfound/rowcount ----
-- TODO: 
-- 1. Disallowed pl attr used in non-PL SQL and PL dynamic statement.
-- 2. Priority to parse pl attr in PL over modulus operator.
create table t (
    sql real,
    isopen real,
    found real,
    notfound real,
    rowcount real,
    type real,
    rowtype real
);

insert into t values (452.1245, 123.4578, 23.457, 433.124, 234.789, 1238.145, 12.4578);
select sql%sql from t;
select sql%abc from t;
select sql%(isopen) from t;
select sql%(found) from t;
select sql%(notfound) from t;
select sql%(rowcount) from t;
select sql%(type) from t;
select sql%(rowtype) from t;

select (sql)%isopen from t;
select (sql)%found from t;
select (sql)%notfound from t;
select (sql)%rowcount from t;
select (sql)%type from t;
select (sql)%rowtype from t;

select sql%isopen from t;
select sql%found from t;
select sql%notfound from t;
select sql%rowcount from t;
select sql%type from t;
select sql%rowtype from t;

select abc%isopen from t;
select abc%found from t;
select abc%notfound from t;
select abc%rowcount from t;
select abc%type from t;
select abc%rowtype from t;

SET SERVEROUTPUT ON
declare
    abc real;
begin
    select sql%(rowcount) into abc from t;
    dbe_output.print_line(abc);
end;
/

declare
    abc real;
begin
    select sql%rowcount into abc from t;
    dbe_output.print_line(abc);
end;
/

alter table t add column mycursor real default 45145.158;
declare
    cursor mycursor is select 1.123 from dual;
    abc real;
begin
    for a in mycursor
    loop
        dbe_output.print_line(mycursor%rowcount);
        select mycursor%rowcount into abc from t;
    end loop;
end;
/

declare
    cursor mycursor is select 1.123 from dual;
    abc real;
begin
    for a in mycursor
    loop
        dbe_output.print_line(mycursor%rowcount);
        select (mycursor)%rowcount into abc from t;
        dbe_output.print_line(abc);
    end loop;
end;
/

declare
    cursor mycursor is select 1.123 from dual;
    abc real;
begin
    for a in mycursor
    loop
        execute IMMEDIATE 'select mycursor%rowcount from t' into abc;
        dbe_output.print_line(abc);
        execute IMMEDIATE 'select (mycursor)%rowcount from t' into abc;
        dbe_output.print_line(abc);
        execute IMMEDIATE 'select mycursor%(rowcount) from t' into abc;
        dbe_output.print_line(abc);
    end loop;
end;
/

drop table t;
SET SERVEROUTPUT OFF

select case substr(version(),7,19) when 'Cantian100-OLTP' then 1 when 'NONE' then 0 else 1 end as version from dual;

SELECT FROM_UNIXTIME('1534252132 ', '%Y %D %M %h:%i:%s') from dual;
SELECT FROM_UNIXTIME(1534252132, '%Y %D %M %h:%i:%s');
SELECT FROM_UNIXTIME(1534252132, '%Y %D %M %h:%i:%s %x');
SELECT FROM_UNIXTIME('1534252132') from dual;
SELECT FROM_UNIXTIME(1534252132, '%Y %D %M %h:%i:%s');
SELECT FROM_UNIXTIME('1534753762.233');
SELECT FROM_UNIXTIME(1534753762.233);
SELECT FROM_UNIXTIME(180980890);
SELECT FROM_UNIXTIME('1809808900','%Y %D %M %h:%i:%s %x');
SELECT FROM_UNIXTIME(18098089000);
SELECT FROM_UNIXTIME(-180980890);
SELECT FROM_UNIXTIME('-1809808900','%Y %D %M %h:%i:%s %x');
SELECT FROM_UNIXTIME(-18098089000);
SELECT FROM_UNIXTIME(9223372036854775807);
SELECT FROM_UNIXTIME(-9223372036854775807);
SELECT FROM_UNIXTIME(9223372036854775809);
SELECT FROM_UNIXTIME(-9223372036854775809);
SELECT FROM_UNIXTIME();
SELECT FROM_UNIXTIME(1534252132, '%Y %D %M %h:%i:%s %x', 'xxxxxx');

--extract
select extract(hour from to_date('1995-01-01 11:22:33','yyyy-mm-dd hh24:mi:ss')) from dual;
select extract(minute from to_date('1995-01-01 11:22:33','yyyy-mm-dd hh24:mi:ss')) from dual;
select extract(second from to_date('1995-01-01 11:22:33','yyyy-mm-dd hh24:mi:ss')) from dual;
select extract(microsecond from to_date('1995-01-01 11:22:33','yyyy-mm-dd hh24:mi:ss')) from dual;
select extract(year from interval '-1 11:22:33.456' day to second) from dual;
select extract(month from interval '-1 11:22:33.456' day to second) from dual;
select extract(day from interval '-1-11' year to month) from dual;
select extract(year from '1990') from dual;
select extract(year from '') from dual;
select extract(year from '1990-01-01');
select extract(hour from '1990-01-01 11:22:33');
select extract(year from '19900102');
select extract(second from '19900101000001.123');

--date & timestamp
select datetime '1995-01-01' from dual;
select datetime ' 1995 - 01 - 01 ' from dual;
select date '1995-01-01 00:00:00' from dual;
select date '0000-01-01' from dual;
select date '' from dual;
select date '1990' from dual;
select date '1990-01' from dual;
select date '1990-00-01' from dual;
select date '1990-13-01' from dual;
select date '1990-01-00' from dual;
select date '1990-02-30' from dual;
select date '00:00:00' from dual;
select timestamp '1995-01-01' from dual;
select timestamp '1995-01-01 00:00:00' from dual;
select timestamp '1995-01-01  00:00:00 ' from dual;
select timestamp '1995-01-01  00:00:00.0' from dual;
select timestamp '1995-01-01 00:00:00.123' + 1 from dual;
select timestamp '1995-01-01  00:00:00 . 0' from dual;
select timestamp '1995-01-01 00:00:00.123456' from dual;
select timestamp '1995-01-01 00:00:00.1234567' from dual;
select timestamp '1995-01-01 ' + 1 from dual;
select to_date('2008-02-01','yyyy-mm-dd') - timestamp '1995-01-01 11:22:33.123' from dual;

--vsize
DROP TABLE IF EXISTS t_func_alltypes;
CREATE TABLE t_func_alltypes 
(  
        f_int1            integer default 0 not null,  
        f_int2            integer,  
        f_int3            integer, 
        f_bigint1        bigint,  
        f_bigint2        bigint,  
        f_bigint3        bigint,  
        f_bool1            integer,  
        f_bool2            integer,  
        f_num1            number(38, 0),  
        f_num2            number(38, 0),  
        f_dec1            DECIMAL(38, 0), 
        f_dec2            DECIMAL(38, 0),  
        f_num10            number(38, 10),  
        f_dec10            decimal(38, 10),  
        f_float            float,  
        f_double        double,  
        f_real            real,  
        f_char1            char(128),  
        f_char2            char(128),  
        f_varchar1        varchar(512),  
        f_varchar2        varchar2(512),  
        f_date1            date,  
        f_date2            date,  
        f_time            date, 
        f_timestamp        timestamp,  
        f_tp_tz            timestamp with time zone,  
        f_tp_ltz        timestamp with local time zone,  
        f_binary        binary(200),  
        f_varbinary        varbinary(200),  
        f_blob            blob,  
        f_clob            clob  
);
INSERT INTO t_func_alltypes(f_int1, f_bigint1, f_dec1, f_num10, f_float, f_double, f_real, f_char1, f_varchar1, f_date1, f_timestamp, f_clob) VALUES (1234, 1234, 1234567890123456, 1234567890123456.7890, 123.45, 12345678901234.5678, 12345678901234.5678, 'aaa','abcdefghijklmn', SYSDATE, CURRENT_TIMESTAMP, 'aaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbvvvvvvvvvvvvvvvvvvvvvvvvvv');

SELECT VSIZE(f_int1), VSIZE(f_bigint1), VSIZE(f_dec1), VSIZE(f_num10), VSIZE(f_float), VSIZE(f_double), VSIZE(f_real), VSIZE(f_char1), VSIZE(f_varchar1), VSIZE(f_date1), VSIZE(f_timestamp) FROM t_func_alltypes;
SELECT VSIZE(f_int1 + f_bigint1) FROM t_func_alltypes;

--syntax error
SELECT VSIZE(f_int1), VSIZE(f_bigint1), VSIZE(f_dec1), VSIZE(f_num10), VSIZE(f_float), VSIZE(f_double), VSIZE(f_real), VSIZE(f_char1), VSIZE(f_varchar1), VSIZE(f_date1), VSIZE(f_timestamp), VSIZE(f_clob) FROM t_func_alltypes;
SELECT VSIZE(f_int1, 3) FROM t_func_alltypes;
SELECT VSIZE() FROM DUAL;

DROP TABLE t_func_alltypes;

SELECT VSIZE(TRUE) FROM DUAL;
SELECT VSIZE('TRUE') FROM DUAL;
SELECT VSIZE(FALSE) FROM DUAL;
SELECT VSIZE('FALSE') FROM DUAL;

--if()
SELECT IF('TRUE', 'T', 'F') FROM DUAL;
SELECT IF('FALSE', 'T', 'F') FROM DUAL;
SELECT IF(1.1, 'T', 'F') FROM DUAL;
SELECT IF(CURRENT_TIMESTAMP, 'T', 'F') FROM DUAL;
SELECT IF(SYSDATE, 'T', 'F') FROM DUAL;
select if(1=1,null,123), if(1=1, 123,null), if(1=1, null,null) from dual; --null 123 null
--TYPE
desc -q SELECT IF('TRUE', 'T', 'F') a,IF('FALSE', 'T', 'F') b, if(1=1,123,123) c, if(1=1,123,'abc') d, if(1=1,'abc',123), if(1=1,123, cast('1111-11-11' as date)) FROM DUAL;  --varchar(1),varchar(1) ,int(3) ,varchar(3) ,varchar(3) ,varchar(10)
desc -q select if(1=1,null,123), if(1=1, 123,null), if(1=1, null,null) from dual; --int int binary (we not support this)

drop table if exists t1;
create table t1 (c1 varbinary(16), c2 int);
insert into t1 values (UNHEX('11e8d02e03be82a684df0242d307b2a0'), 0);
commit;
select if( lengthb(c1) + c2 = 16, 0 , 1) RES from t1 group by c1;
select c2,lengthb(c2), if(lengthb(c2)=1, 0 ,1) from t1 group by c2;
drop table t1;
--DTS:DTS2018110209708
drop table if exists t_abs ;
create table t_abs (c1 varbinary(4));
insert into t_abs values ('abcd');
commit;
desc -q select IF(c1='abcd',100000000000000006666666666666666666666666666666666666666666666666666666600000000,111111111111111111111111) from t_abs order by 1;
select IF(c1='abcd',100000000000000006666666666666666666666666666666666666666666666666666666600000000,111111111111111111111111) from t_abs order by 1;

--space
select space(0),space(1),space(-1);
select space(null);
select space();
select space(1,2);
select space(4001);
select space('aaa');
--FIND_IN_SET
select find_in_set('','');
select find_in_set('','ac,baa,aa,a,aad');
select find_in_set('',',ac,baa,aa,a,aad');
select find_in_set('','ac,,,baa,aa,a,aad');
select find_in_set('','ac,');

--DTS2018110507183
drop table if exists t_func_hex ;
create table t_func_hex (c1 varbinary(4));
insert into t_func_hex values ('abcc');
commit;
desc -q select lpad(c1,8001,'a'), rpad(c1,8001,'a'), insert(c1,2,2,'3267564'), SHA1(c1) from t_func_hex order by 1;
select length(lpad(c1,8001,'a')), length(rpad(c1,8001,'a')), length(insert(c1,2,2,'3267564')), length(SHA1(c1)) from t_func_hex order by 1;

drop table if exists t_func_hex ;
create table t_func_hex (c1 varbinary(10));
insert into t_func_hex values ('');
commit;
desc -q select NVL(c1,10000000000000), NVL2(c1,'10000000000000','222222222222222') from t_func_hex order by 1;
select length(NVL(c1,10000000000000)), length(NVL2(c1,'10000000000000','222222222222222')) from t_func_hex order by 1;

drop table if exists t_func_hex;
create table t_func_hex (c1 clob);
declare
    i varchar(32767);
begin
    i:='';
    for j in 1..16000 loop
        i:=i||'a';
    end loop;
    insert into t_func_hex values (i);
    commit;
end;
/
desc -q select lower(c1), upper(c1), hex(c1) from t_func_hex;
select length(lower(c1)), length(upper(c1)), length(hex(c1)) from t_func_hex;

drop table t_func_hex;


--DTS2018120614216
--insert func 超过8000截断
drop table if exists t_func_insert;
create table t_func_insert(c1 char(8000));
declare
    i varchar(32767);
begin
    i:='';
    for j in 1..8000 loop
        i:=i||'a';
    end loop;
    insert into t_func_insert values (i);
    commit;
end;
/
desc -q select insert(c1,1,2,'3432456') from t_func_insert;
select insert(c1,1,2,'3432456') from t_func_insert;
select length(insert(c1,1,2,'3432456')) from t_func_insert;

--if null 参数存在number不带精度的时候，返回类型也不带精度
drop table if exists t_func_ifnull ;
create table t_func_ifnull (c1 int, c2 number);
insert into t_func_ifnull values ('','');
commit;
desc -q select IFNULL(c1,1000000000000111111111111111111111111000000000000), ifnull(c2, cast(123 as number(10))), ifnull(c1, cast(123 as number(10))) from t_func_ifnull order by 1;
select IFNULL(c1,1000000000000111111111111111111111111000000000000), ifnull(c2, cast(123 as number(10))), ifnull(c1, cast(123 as number(10))) from t_func_ifnull order by 1;

--image 类型在函数中的长度最大为64k
drop table if exists t_image_in_func;
create table t_image_in_func (c1 image);
declare
    i varchar(32767);
begin
    i:='';
    for j in 1..16000 loop
        i:=i||'a';
    end loop;
    insert into t_image_in_func values (i);
    commit;
end;
/
desc -q select hex(c1) from t_image_in_func;
--select hex(c1) from t_image_in_func;
select length(hex(c1)) from t_image_in_func;

desc -q select lower(c1) from t_image_in_func;
--select lower(c1) from t_image_in_func;
select length(lower(c1)) from t_image_in_func;

desc -q select rtrim(c1) from t_image_in_func;
--select rtrim(c1) from t_image_in_func;
select length(rtrim(c1)) from t_image_in_func;

desc -q select SUBSTRING(c1,1) from t_image_in_func;
--select SUBSTRING(c1,1) from t_image_in_func;
select length(SUBSTRING(c1,1)) from t_image_in_func;

desc -q select SUBSTR(c1,1) from t_image_in_func;
--select SUBSTR(c1,1) from t_image_in_func;
select length(SUBSTR(c1,1)) from t_image_in_func;

--DTS2018121900740
drop table if exists function_aa;
create table function_aa (i varchar(100),j varchar(100));
insert into function_aa select lpad('aa',7000,'bb'),lpad('aa',8000,'bb') from dual;

-- thread stack depth limit exceeded
select abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(i)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) union abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(abs(i)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))) from function_aa;

drop table function_aa;

select 123 from sys.dba_tables where trim(tablespace_name) is not null limit 1;
select 456 from sys.dba_tables where trim(leading 'x' from concat('x', tablespace_name)) = tablespace_name limit 1;

--DTS2019021605200
drop table if exists t_func_sleep ;
create table t_func_sleep(a number(5,1));
insert into t_func_sleep (a) values (1.234);
select sleep(a) from t_func_sleep;
select sleep(1.234);
select sleep(-1);
select sleep(-1.23);
select sleep(99999999999999);
drop table t_func_sleep;

--sha\sha1
SELECT SHA('abcdefghijklmnopqrstuvwxyz');
SELECT SHA1('abcdefghijklmnopqrstuvwxyz');

drop table if exists t_length_range;
create table t_length_range (c1 clob);
declare
 i varchar(32767);
begin
 i:='';
 for j in 1..32767 loop
  i:=i||'a';
 end loop;
 insert into t_length_range values (i);
 commit;
end;
/
select length(c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1||c1) from t_length_range;

-- test group_concat
drop table if exists test_gc;
create table test_gc(id int, name varchar(8000));
insert into test_gc values (1, lpad('a',8000,'a'));
insert into test_gc values (2, lpad('b',8000,'b'));
insert into test_gc values (3, lpad('c',8000,'c'));
insert into test_gc values (4, lpad('d',8000,'d'));
insert into test_gc values (5, lpad('e',8000,'e'));
insert into test_gc values (6, lpad('f',8000,'f'));
insert into test_gc values (7, lpad('g',8000,'g'));
insert into test_gc values (8, lpad('h',8000,'h'));
insert into test_gc values (9, lpad('i',8000,'i'));
create index idx_gc on test_gc(id);
commit;
SELECT group_concat(DISTINCT name ORDER BY name ASC) AS tempname,id FROM test_gc GROUP BY id order by 1;
--isnumeric
SELECT ISNUMERIC(cast('1' as integer)) from dual;
SELECT ISNUMERIC('a' || '1') from dual;
SELECT ISNUMERIC(null) from dual;
SELECT ISNUMERIC('null') from dual;
SELECT ISNUMERIC('1' + 0) from dual;
SELECT ISNUMERIC(1.2e+10) from dual;
SELECT ISNUMERIC(1.2E+10) from dual;
SELECT ISNUMERIC(-1.2e+10) from dual;
SELECT ISNUMERIC(-1.2e-10) from dual;
SELECT ISNUMERIC(-1.2e110) from dual;
SELECT ISNUMERIC(-1.2e+10^5) from dual;
SELECT ISNUMERIC(200E) from dual;
SELECT ISNUMERIC(200E+100) from dual;
SELECT ISNUMERIC(200E100) from dual;
SELECT ISNUMERIC(1.2E100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000) from dual;
SELECT ISNUMERIC('200M') from dual;
SELECT ISNUMERIC('200E') from dual;
SELECT ISNUMERIC('200E+100') from dual;
SELECT ISNUMERIC(ISNUMERIC(ISNUMERIC(ISNUMERIC(ISNUMERIC(ISNUMERIC(ISNUMERIC(ISNUMERIC(ISNUMERIC(ISNUMERIC(ISNUMERIC(1))))))))))) from dual;
SELECT isnumeric('122222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222') from dual ;

drop table if exists md5_test_t;
create table md5_test_t(f1 date,f2 bool);
insert into md5_test_t values('2019-04-11 12:00:00',true);
insert into md5_test_t values('2019-04-11',false);
select md5(f1),md5(f2) from md5_test_t;

SELECT GET_SHARED_LOCK('LOCK1') FROM DUAL;
SELECT GET_SHARED_LOCK('LOCK2',5) FROM DUAL;
SELECT TRY_GET_SHARED_LOCK('LOCK3') FROM DUAL;
SELECT RELEASE_SHARED_LOCK('LOCK1') FROM DUAL;
SELECT RELEASE_SHARED_LOCK('LOCK2') FROM DUAL;
SELECT RELEASE_SHARED_LOCK('LOCK3') FROM DUAL;

SELECT GET_XACT_SHARED_LOCK('TEST_LOCK1') FROM DUAL;
SELECT GET_XACT_SHARED_LOCK('TEST_LOCK2',10) FROM DUAL;
SELECT TRY_GET_XACT_SHARED_LOCK('TEST_LOCK3') FROM DUAL;
SELECT LOCK_NAME,TOTAL_LOCKED_TIMES FROM DV_XACT_SHARED_LOCKS order by LOCK_NAME;
COMMIT;
SELECT LOCK_NAME,TOTAL_LOCKED_TIMES FROM DV_XACT_SHARED_LOCKS;

CREATE OR REPLACE PROCEDURE TRANS_LOCKS()
IS
A BOOLEAN;
BEGIN
	FOR I IN 1..2 LOOP
		IF MOD(I,2)=1 THEN
			SELECT GET_XACT_LOCK('LOCK_COMMIT') INTO A FROM DUAL;
			COMMIT;
		ELSE
            SELECT GET_XACT_LOCK('LOCKROLLBACK') INTO A FROM DUAL;
			ROLLBACK;
			SELECT GET_XACT_LOCK('LOCK_SAVED') INTO A FROM DUAL;
		END IF;
	END LOOP;			
END;
/
CALL TRANS_LOCKS;
SELECT LOCK_NAME,LOCK_TIMES FROM V$XACT_LOCK;
COMMIT;
DROP PROCEDURE IF EXISTS TRANS_LOCKS;
SELECT DBE_DIAGNOSE.DBA_IND_POS('-9223372036854775808,9223372036854775807','9223372036854775807') from SYS_DUMMY;
SELECT DBE_DIAGNOSE.DBA_IND_POS('-9223372036854775809,-9223372036854775808,9223372036854775808','-9223372036854775808') from SYS_DUMMY;
SELECT DBE_DIAGNOSE.DBA_IND_POS('-9223372036854775808,9223372036854775807','9223372036854775807') from SYS_DUMMY;

--DTS2019062512807 
select max(round('0002324')) from sys_dummy;
select min(round('0002324')) from sys_dummy;
select round('123123.adads') from sys_dummy; ---error

--DTS2019080112819
select * from table(dba_analyze_table(null, 'FUNCTION_TAB_001'));
select * from table(dba_analyze_table('', 'FUNCTION_TAB_001'));

--DTS2019080304144
drop table if exists not_if_table;
create table not_if_table (f1 int);
select if from not_if_table; --error

drop table if exists if_table;
create table if_table (if int);
insert into if_table values(1);
select if from if_table;

drop table not_if_table;
drop table if_table;

--test gs_hash
drop table if exists test_gs_hash;
create table test_gs_hash(id int, name varchar(20)) partition by hash(name)
(
partition p1,
partition p2,
partition p3,
partition p4
);
insert into test_gs_hash values(10, 'zhangsan');
insert into test_gs_hash values(20, 'lisi');
insert into test_gs_hash values(30, 'wangwu');
insert into test_gs_hash values(40, 'zhaoliu');
commit;
select * from test_gs_hash partition(p1);
select * from test_gs_hash partition(p2);
select * from test_gs_hash partition(p3);
select * from test_gs_hash partition(p4);
select ct_hash('zhangsan', 4) from dual;
select ct_hash('lisi', 4) from dual;
select ct_hash('wangwu', 4) from dual;
select ct_hash('zhaoliu', 4) from dual;
drop table test_gs_hash;

--DTS2019080911544
select HEXTORAW(empty_clob()) from SYS_DUMMY;
select ASCII(empty_clob()) from SYS_DUMMY;

drop table if exists for_variant_precision_convert;
create table for_variant_precision_convert(
	a interval year(4) to month,
	b interval year(3) to month,
	c interval day(6) to second(3),
	d interval day(3) to second(6),
	e interval day(3) to second(6),
	f timestamp(6),
	g timestamp(3)
);
insert into for_variant_precision_convert values('994-07', '994-07', '1001 12:3:4', '101 12:3:4', '101 12:3:4', timestamp'2000-10-12 12:12:12.123', timestamp'2019-12-12 12:12:12.123');
select a,find_in_set('+994-07',a) from for_variant_precision_convert;
select a,find_in_set('+0994-07',a) from for_variant_precision_convert;
select b,find_in_set('+0994-07',b) from for_variant_precision_convert;
select b,find_in_set('+994-07',b) from for_variant_precision_convert;
select c,find_in_set('+1001 12:3:4',c) from for_variant_precision_convert;
select c,find_in_set('+001001 12:03:04.000',c) from for_variant_precision_convert;
select d,find_in_set('+101 12:3:4',d) from for_variant_precision_convert;
select d,find_in_set('+101 12:03:04.000000',d) from for_variant_precision_convert;
select e,find_in_set('+101 12:3:4',e) from for_variant_precision_convert;
select e,find_in_set('+101 12:03:04.000000',e) from for_variant_precision_convert;
select f,find_in_set('2000-10-12 12:12:12.123',f) from for_variant_precision_convert;
select f,find_in_set('2000-10-12 12:12:12.123000',f) from for_variant_precision_convert;
select g,find_in_set('2019-12-12 12:12:12.123',g) from for_variant_precision_convert;
select f,replace(f,'0','a') from for_variant_precision_convert;
select g,replace(g,'0','a') from for_variant_precision_convert;
select f,translate(f,'0','a') from for_variant_precision_convert;
select g,translate(g,'0','a') from for_variant_precision_convert;
drop table for_variant_precision_convert;


drop table if exists case_t1;
create table case_t1(a varchar(5), b int, c int);
insert into case_t1 values(null, 1,1);
SELECT 
    MAX(
        CASE
            WHEN abs(case_t1.a) > 0 THEN
                case_t1.a
            ELSE
                0
        END
    ) OVER(
        PARTITION BY case_t1.b
    )  onway
FROM case_t1;
drop table case_t1;

drop table if exists case_t2;
create table case_t2(a varchar(5), b int, c int);
insert into case_t2 values ('123',1,1);
insert into case_t2 values ('23',1,1);
insert into case_t2 values ('3',1,1);
SELECT 
    MAX(
        CASE
            WHEN abs(case_t2.b) = 1 THEN
                to_number(case_t2.a)
            ELSE
                0
        END
    ) OVER(
        PARTITION BY case_t2.c
    )  onway
FROM case_t2;

SELECT 
    MAX(
        CASE
            WHEN abs(case_t2.b) = 1 THEN
                case_t2.a
            ELSE
                0
        END
    ) OVER(
        PARTITION BY case_t2.c
    )  onway
FROM case_t2;

drop table case_t2;

--DTS2019090301787
select REPLACE(CONCAT( -1000.245 , 100.123 , -1000.245 , '11 JKLHGOSIJO JLASJ ' , '11 JKLHGOSIJO JLASJ ' , NULL , -1000.245 , '11 JKLHGOSIJO JLASJ ' , NULL ), CONCAT( 100.123 , -1000.245 ) , REVERSE('') ) from dual;
drop table if exists tc;
create table tc(c clob default 'abcdefg' || lpad('你好', 80000, '中国'));
insert into tc values(default);
select length(c) from tc;
select lengthb(c) from tc;
select length(lpad(c, '9000', '你好')) from tc;
select lengthb(lpad(c, '9000', '你好')) from tc;

drop table if exists test_gs_hash_number;
create table test_gs_hash_number(id number(38)) partition by hash(id)
(
partition p1,
partition p2,
partition p3,
partition p4
);
insert into test_gs_hash_number values(1540075);
select gs_hash(id, 4) from test_gs_hash_number;
drop table test_gs_hash_number;

-- DTS2020011600302
drop table if exists em_fetch2_oxnjedml_006;
set serveroutput on;
create table em_fetch2_oxnjedml_006
(
--em_fetch2_oxnjedml_006no int primary key,
em_fetch2_oxnjedml_006no int,
ename varchar(80),
job varchar(80),
sal number,
primary key (em_fetch2_oxnjedml_006no)
);
insert into em_fetch2_oxnjedml_006 values(1,'ddzhangsanyy','teacher',9800);
insert into em_fetch2_oxnjedml_006 values(2,'xiaowang','doctor',7900);
insert into em_fetch2_oxnjedml_006 values(3,'杨戬 ','artist',8200);
insert into em_fetch2_oxnjedml_006 values(4,' 杨依依','engineer',5600);
commit;
BEGIN
for i in 1..2
loop
if i<=1 then
FOR a IN(SELECT * FROM em_fetch2_oxnjedml_006 WHERE ename LIKE '%zhangsan%' AND sal > 9000 ORDER BY em_fetch2_oxnjedml_006no;)
LOOP
dbe_output.print_line('a is em_fetch2_oxnjedml_006:'||a.em_fetch2_oxnjedml_006no||' name:'||a.ename||' job:'||a.job||' sal:'||a.sal);
END LOOP;
else
FOR a IN(SELECT * FROM em_fetch2_oxnjedml_006 WHERE ename LIKE '% 杨依依%' AND sal < 9000 ORDER BY em_fetch2_oxnjedml_006no)
LOOP
dbe_output.print_line(LTRIM(a.ename));
END LOOP;
end if;
end loop;
END;
/

SELECT REPLACE( TRIM( TRIM( ' abc' from ' abcdefghijklmnopqrs3211111122222333344444455555566667777788889999900000 ' ) from INSERT('12345678909876543211111122222333344444455555566667777788889999900000abcdefghijklmnopqrstuvwxyzaaaaaqabbbbbbbccccccc' , 3 , 6 , 'ltrvxxqpposmwvkgfrbgodlzmcunzdlpwwtn' ) ) , CONCAT( '11 JKLHGOSIJO JLASJ ')) FROM dual;

--DTS2020020300260
create table dts_tin(i int not null primary key,j varchar(10));
select dts_tin.*from dts_tin left join dts_tin t1 on dts_tin.i=t1.i where dts_tin.i in (666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,854,855,856,857,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,898,899,900,901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,938,939,940,941,942,943,944,945,946,947,948,949,950,951,952,953,954,955,956,957,958,959,960,961,962,963,964,965,966,967,968,969,970,971,972,973,974,975,976,977,978,979,980,981,982,983,984,985,986,987,988,989,990,991,992,993,994,995,996,997,998,999,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1044,1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1093,1094,1095,1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116,1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129,1130,1131,1132,1133,1134,1135,1136,1137,1138,1139,1140,1141,1142,1143,1144,1145,1146,1147,1148,1149,1150,1151,1152,1153,1154,1155,1156,1157,1158,1159,1160,1161,1162,1163,1164,1165,1166) and dts_tin.i = to_char(1);
drop table dts_tin;

-- test raw asciistr
drop table if exists asciistr001;
create table asciistr001( 
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
COL_20 interval day to second  ,
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
COL_50 image,
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
constraint fun_cst_id primary key(COL_1)
);

-- 创建序列
drop sequence if exists fun_seq;
create sequence fun_seq increment by 1 start with 100000;
--清空数据
truncate table asciistr001;

--插入数据
begin
      for i in 1..1000 loop
      insert into asciistr001 values(
          fun_seq.nextval,
          TIMESTAMPADD(HOUR,i,'2019-01-03 14:14:12'),
          true,
          3.1415926+fun_seq.nextval,
          lpad('abc','5000','a@123&^%djgk'),
          i,
          lpad('abc','30','@'),
          i+1.456789445455,
          lpad('abc','5000','a@123&^%djgk'),
          lpad('abc','30','b'),
          false,
          lpad('10','5000','0101'),
          3.1415926+fun_seq.nextval,
          i/4,
          lpad('10','8000','01010'),
          i,
          i,
          TIMESTAMPADD(DAY,i,'2019-01-03 14:14:12'),
          '1',
          (INTERVAL '4 5:12:10.222' DAY TO SECOND(3)),
          0,
          rpad('abc','30','e'),
          fun_seq.nextval,
          rpad('abc','100','exc'),
          lpad('abc','1000','a@123&^%djgk'),
          lpad('abc','5000','a@123&^%djgk'),
          i/4,
          fun_seq.nextval-99,
          i*3.1415,
          TIMESTAMPADD(MINUTE,i,'2019-01-03 14:14:12'),
          to_timestamp('2019-01-03 14:58:54.000000','YYYY-MM-DD HH24:MI:SS.FFFFFF'),
		  lpad('abc','5000','a@123&^%djgk'),
          (INTERVAL '12' YEAR),
          rpad('abc','30','&'),
          i,
          lpad('10',5000,'01010'),
          rpad('abc','300','exc'),
          i/2.15,
          rpad('0F',100,'AADB9'),
          lpad('abc','5000','a@123&^%djgk'),
          1.0E+100,
          3.14+i,
          i+445.255,
          rpad('abc','30','&'),
          lpad('abc','30','&'),
          rpad('abc','100','&GDsh'),
          125563.141592,
          rpad('abc','30','e'),
          TIMESTAMPADD(DAY,i,'2019-01-03 14:14:12'),
          lpad('abc','5000','a@123汉字&^%djgk'),
          fun_seq.nextval+2,
          -1.79E+100,98*0.99,
          lpad('10','8000','01010'),
          lpad('abc','5000','a@123&^%djgk'),
          rpad('abc','8000','a@123&^%djgk'),
          TIMESTAMPADD(SECOND,i,'2019-01-03 14:14:12'),
          25563.1415,
          lpad('abc','3000','a字符串@123&^%djgk'),
          lpad('10',2000,'01010'),
          lpad('10','200','01010'),
          TIMESTAMPADD(MONTH,i/100,'2019-01-03 14:14:12'),
          '010101111111100000000000000',
          rpad('abc','1000','&GDsh'),
          TIMESTAMPADD(SECOND,i,'2019-01-03 15:19:00')
          );
      commit;
    end loop;
end;
/

select distinct asciistr(COL_54),asciistr(COL_60),asciistr(COL_61),asciistr(COL_63) from asciistr001 where lengthb(COL_13)>=lengthb(COL_58) order by 1 limit 10;

drop sequence if exists fun_seq;

select regexp_replace('012345678901234567890012345678901234567890012345678901234567890012345678901234567890012345678901234567890012345678901234567890','[0-9]','*############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################') as new_str from dual;
-- regexp_like DTS2020031702725
drop table if exists zsharding_tbl1;
create table zsharding_tbl1(c_id int, c_char char(55), c_varchar varchar(100));
insert into zsharding_tbl1 values(1,'Fluffy','Fluffy');
insert into zsharding_tbl1 values(2,'Buffy','Buffy');
insert into zsharding_tbl1 values(3,'fluffy','fluffy');
insert into zsharding_tbl1 values(4,'buffy','buffy');
insert into zsharding_tbl1 values(5,'桂林山水abc高山流水','桂林山水abc高山流水');
insert into zsharding_tbl1 values(6,'aa abc zzzz','aa abc zzzz');
insert into zsharding_tbl1 values(7,'我的的的的 abcabcabcabcabcabcabcabcabcabcabcabc','我的的的的 abcabcabcabcabcabcabcabcabcabcabcabc');
insert into zsharding_tbl1 values(8,'abcbvbnb
efgh
ijjkkkkkkk','abcbvbnb
efgh
ijjkkkkkkk123');
insert into zsharding_tbl1 values(9,'abc efg','hgj khln');
insert into zsharding_tbl1 values(10,'abc\efg','hgj(khln');
insert into zsharding_tbl1 values(11,null,null);
insert into zsharding_tbl1 values(12,'\*+?|^$[](){}.','\*+?|^$[](){}.');
commit;
SELECT * FROM zsharding_tbl1 WHERE regexp_like('',c_varchar) ORDER BY 1;

drop table if exists tbl_uuid;
create table tbl_uuid(f_id int, f_uuid varchar(50));
CREATE or replace procedure proc_uuid(startnum int,endall int) is
i INT :=1;
BEGIN
  FOR i IN startnum..endall LOOP
    insert into tbl_uuid values(i, uuid());
  END LOOP;
END;
/
call proc_uuid(1,100000);
commit;
select f_uuid, count(*) from tbl_uuid group by f_uuid having count(*)>1;
drop table if exists tbl_uuid;
--20200724
drop table if exists test_concat;
create table test_concat(f1 bool);
insert into test_concat values(false);
select concat(f1) from test_concat;
drop table test_concat;
--pending排查
drop table if exists t_pending_1;
drop table if exists t_pending_2;
create table t_pending_1(a int, b varchar(10));
create table t_pending_2(a int, b varchar(10));
insert into t_pending_1 values(1, 'u');
insert into t_pending_2 values(1, 'u');
commit;

SELECT * from t_pending_1 a join t_pending_2 b where DBE_RANDOM.GET_VALUE(b.a,b.a) is not null;
SELECT * from t_pending_1 a join t_pending_2 b where DBE_RANDOM.GET_STRING(b.b,b.a) is not null;
SELECT * from t_pending_1 a join t_pending_2 b where sha1(b.b) is not null;
SELECT * from t_pending_1 a join t_pending_2 b where get_lock(b.b, b.a) is not null;
SELECT * from t_pending_1 a join t_pending_2 b where try_get_lock(b.b) is not null ;
SELECT * from t_pending_1 a join t_pending_2 b where b.a is json;
SELECT * from t_pending_1 a join t_pending_2 b where JSON_MERGEPATCH(b.a, '{"A":{"D":332}}')  is not null ;
SELECT * from t_pending_1 a join t_pending_2 b where JSON_ARRAY(b.a) is not null;
SELECT * from t_pending_1 a join t_pending_2 b where JSON_ARRAY_LENGTH(b.a) is not null;
SELECT * from t_pending_1 a join t_pending_2 b where JSON_OBJECT(KEY 'u' is b.b ) is not null  ;
SELECT * from t_pending_1 a join t_pending_2 b where JSON_EXISTS('{"COUNTRY":0,"CITIES":["SUZHOU","SHANGHAI"],"CODES":{"SUZHOU":0,"SHANGHAI":0}}', b.b) is not null;
SELECT * from t_pending_1 a join t_pending_2 b where JSON_VALUE(b.b,'$.A') is not null;
SELECT * from t_pending_1 a join t_pending_2 b where JSON_VALUE('{"A":1234}',b.b) is not null;
delete from t_pending_2;
insert into t_pending_2 values(1, 'a');
SELECT * from t_pending_1 a join t_pending_2 b where HEXTORAW(b.b) = 'a'  ;
drop table t_pending_1;
drop table t_pending_2;
--20201112
drop table if exists temp_20201111_2;
drop table if exists temp_20201111_1;
create table temp_20201111_2(f1 varchar(32 byte));
create table temp_20201111_1(f1 varchar(32 byte));
insert into temp_20201111_2 values(0xffffffffffffffffffffffffffffffff);
commit;
select hex(f1) from temp_20201111_2;
insert into temp_20201111_1 select ltrim(rtrim(f1)) from temp_20201111_2;
alter system set enable_permissive_unicode=true;
insert into temp_20201111_1 select ltrim(rtrim(f1)) from temp_20201111_2;
alter system set enable_permissive_unicode=false;
drop table if exists temp_20201111_2;
drop table if exists temp_20201111_1;