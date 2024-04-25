set hist on;
conn sys/Huawei@123@127.0.0.1:1611
show parameter long
show long
show parameter long long
show parameterr
show parametersr
show ctsql_ssl
--DTS2019030904033
drop user if exists FVT_Security_Penetration_Testing_021_11;
create user  FVT_Security_Penetration_Testing_021_11  identified by '*Cantian234';
grant create session to FVT_Security_Penetration_Testing_021_11;
conn FVT_Security_Penetration_Testing_021_11/*Cantian234@127.0.0.1:1611
select * from dual;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists FVT_Security_Penetration_Testing_021_11;
set hist off;

--DTS2018092805103
drop user if exists fenglang cascade;
create user fenglang identified by Cantian_123;
grant create table to fenglang;
conn fenglang/Cantian_123@127.0.0.1:1611
desc all_tables;
select * from dual;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists fenglang cascade;

drop table if exists t_ctsql1;
drop table if exists t_ctsql2;
drop table if exists t_ctsql3;
drop table if exists t_ctsql4;
create table t_ctsql1(f1 number, f2 varchar(100));
insert into t_ctsql1 values(123456789012345678901234, 'abcdef123123');
insert into t_ctsql1 values(1233453452123443444, 'aabb');
insert into t_ctsql1 values(55662223445534234234, '1234asdfg');
insert into t_ctsql1 values(2347678790000455462344, '567567fgfg');
insert into t_ctsql1 values(1122334455773, '4443333');
insert into t_ctsql1 values(4365465466, '88888899999');
insert into t_ctsql1 values(2342343767980, 'qwertyuiiiiiiiiiiiiiiiiiiiiiiiiiii12345678');
insert into t_ctsql1 values(105, 'abcdef123123');
insert into t_ctsql1 values(999999999999999, 'abcdef123123');
insert into t_ctsql1 values(1111111111111, 'abcdef123123');
insert into t_ctsql1 values(4365465466E110, 'abcdef123123');
commit;

-- set heading on|off; show heading
show he;
show headingx;
show hea;
show head;
show headi;
show headin;
show heading;
select * from dual;
set hea off;
set headingx off;
set head offx;
set head off;
set headi off;
set headin off;

set heading off;
show heading;
select * from dual;

set heading on;

-- set serveroutput
show serverou;
show serveroutputx;
show serverout;
show serveroutp;
show serveroutpu;
show serveroutput;
set serverou on;
set serveroutputx on;
set serveroutput onx;
set serverout on;
set serveroutp on;
set serveroutpu on;
set serveroutput on;

show serveroutput;
set serveroutput off;

-- set trimspool
show trim;
show trims;
show trimsp;
show trimspo;
show trimspoo;
show trimspool;
show trimspoolx;
set trim on;
set trimspoolx on;
set trimspool on;
set trimspool onx;
set trims on;
set trimsp on;
set trimspo on;
set trimspoo on;
set trimspool on;

show trimspool;
set trimspool off;
show trimspool;

-- set linesize
show li;
show linesizex;
show lin;
show line;
show lines;
show linesi;
show linesiz;
show linesize;
set lin 0;
set linesizex 0;
set linesize 1.2;
set line 0;
set lines 0;
set linesi 0;
set linesiz 0;
set linesize 0;

select '12345678901234567890' as f1, '12345678901234567890' as f2 from dual;
set linesize 1;
select '12345678901234567890' as f1, '12345678901234567890' as f2 from dual;
set linesize 2;
select '12345678901234567890' as f1, '12345678901234567890' as f2 from dual;
set linesize 10;
select '12345678901234567890' as f1, '12345678901234567890' as f2 from dual;
set linesize 40;
select '12345678901234567890' as f1, '12345678901234567890' as f2 from dual;
set linesize 0;
select '12345678901234567890' as f1, '12345678901234567890' as f2 from dual;

-- set numwidth
show nu;
show numwidthx;
show num;
show numw;
show numwi;
show numwid;
show numwidt;
show numwidth;
set nu 10;
set numwidthx 10;
set num 10;
set numw 10;
set numwi 10;
set numwid 10;
set numwidt 10;
set numwidth 10;
show numwidth;
set numwidth 1.2;
set numwidth 5;
set numwidth 41;

set numwidth 10;
select f1, f2 from t_ctsql1 order by f1, f2;
set numwidth 6;
select f1, f2 from t_ctsql1 order by f1, f2;

set numwidth 40;

-- set pagesize
show page;
show pagesizex;
show pages;
show pagesi;
show pagesiz;
show pagesize;
set page 0;
set pagesizex 0;
set pages 0;
set pagesi 0;
set pagesiz 0;
set pagesize 0;
set pagesize -1;
set pagesize 1.2;
set pagesize 3;

set pagesize 4;
select f1, f2 from t_ctsql1 order by f1, f2;
set pagesize 6;
select f1, f2 from t_ctsql1 order by f1, f2;
set pagesize 10;
select f1, f2 from t_ctsql1 order by f1, f2;
set pagesize 0;
select f1, f2 from t_ctsql1 order by f1, f2;

-- set timing on|off; show timing
show ti;
show timingx;
show tim;
show timi;
show timin;
show timing;
select * from dual;
set ti on;
set timing1 on;
set timing onx;

set tim on;
set timi on;
set timin on;
set timing on;
show timing;

set timing off;

-- set feedback on|off|rows; show feedback
show fee;
show feedbackx;
show feed;
show feedb;
show feedba;
show feedbac;
show feedback;
set fee;
set feedbackx;
set feedback offx;
set feed off;
set feedb off;
set feedba off;
set feedbac off;
set feedback off;

select 1 from dual;
insert into t_ctsql1 values(4365465466, '88888899999');
create table t_ctsql2(f1 number, f2 varchar(100));
drop table t_ctsql2;

set feedback on;
show feedback;

select 1 from dual;
insert into t_ctsql1 values(4365465466, '88888899999');
create table t_ctsql2(f1 number, f2 varchar(100));
drop table t_ctsql2;

-- col clear | column_name on|off|format
col;
col ;
col clear;
col clearxx;
col f1 on;
col f1 off;
col f1 formatx;
col f1 for;
col f1 for b;
col f1 for a;
col f1 for aa;
col f1 for a0;
col f1 for a100 100;
col f1 for a1.2;
col f1 off;
col f1 on;
col clear;

col f1 for a11;
select f1, f2 from t_ctsql1 order by f1, f2;
col f1 for a2;
col f2 for a120;
select f1, f2 from t_ctsql1 order by f1, f2;
set linesize 15
select f1, f2 from t_ctsql1 order by f1, f2;
set linesize 150
select f1, f2 from t_ctsql1 order by f1, f2;
set linesize 0
col f1 for a1;
select f1, f2 from t_ctsql1 order by f1, f2;
col f1 off;
select f1, f2 from t_ctsql1 order by f1, f2;
col f1 on;
select f1, f2 from t_ctsql1 order by f1, f2;
col clear;

select f1,/*test ;comment*/ f2 from t_ctsql1 order by f1, f2;
select f1,/*--test comment*/ f2 from t_ctsql1 order by f1, f2;
select f1, f2 from /*test; comment*/ t_ctsql1 order by f1, f2;
select f1, f2 from /*--test comment*/ t_ctsql1 order by f1, f2;
select f1, f2 from t_ctsql1 where /*test ;comment*/ f1>0  order by f1, f2;
select f1, f2 from t_ctsql1 where /*--test comment*/ f1>0  order by f1, f2;
select f1, f2 from t_ctsql1 where  f1>0  order by /*test; comment*/ f1, f2;
select f1, f2 from t_ctsql1 where  f1>0  order by /*--test comment*/ f1, f2;
select f1, f2 from t_ctsql1 order by f1, f2 /*test; comment*/;
select f1, f2 from t_ctsql1 order by f1, f2 /*--test comment*/;
select /*--test/* comment*/ f1, f2 from t_ctsql1 order by f1, f2 ;
select /*--
test/* comment*/ f1, f2 from t_ctsql1 order by f1, f2 ;
select /*--
test/* comment --
test comment */ 
f1, f2 from t_ctsql1 order by f1, f2 ;

-- show parameters
show parameter INTERACTIVE_TIMEOUTEX;
show parameter INTERACTIVE_TIMEOUT

-- whenever sqlerror {continue|exit [commit|rollback]}
whenever;
whenever xxx;
whenever sqlerror;
whenever sqlerror xxx;
whenever sqlerror continue;
whenever sqlerror exit;
whenever sqlerror continue xxx;
whenever sqlerror exit xxx;
whenever sqlerror continue rollback;
whenever sqlerror exit rollback;
whenever sqlerror continue rollback xxx;
whenever sqlerror exit rollback xxx;
whenever sqlerror continue rollback;
insert into t_ctsql1 values(4365465466, '88888899999');
insert into t_ctsql1 values(4365465466);
select f1, f2 from t_ctsql1 order by f1, f2;

create table t_ctsql3(f1 char(100 char), f2 char(100 byte), f3 char(100), f4 varchar(100 char), f5 varchar(100 byte), f6 varchar(100));
desc t_ctsql3;
alter table t_ctsql3 modify (f1 char(255 char));
alter table t_ctsql3 modify (f5 char(255 char));
create table t_ctsql4 as select * from t_ctsql3;
desc t_ctsql4;

drop table if exists t_ctsql1;
drop table if exists t_ctsql2;
drop table if exists t_ctsql3;
drop table if exists t_ctsql4;

alter system set lsnr_addr = '0.0.0.0,127.0.0.1';
show parameter lsnr_addr;
conn / as sysdba
alter system set lsnr_addr = '0.0.0.0';

drop table if exists  ctsql_dhj_t1;
create table ctsql_dhj_t1(a int);
insert into  ctsql_dhj_t1 values (NULL);
alter table  ctsql_dhj_t1 modify a int1 not null;
drop table if exists  ctsql_dhj_t1;

drop table if exists  ctsql_dhj_t2;
create table ctsql_dhj_t2(a int not null);
insert into  ctsql_dhj_t2 values (1);
alter table  ctsql_dhj_t2 modify a int null;
drop table if exists  ctsql_dhj_t2;

drop table if exists  ctsql_dhj_t3;
create table ctsql_dhj_t3(a int);
insert into  ctsql_dhj_t3 values (NULL);
alter table  ctsql_dhj_t3 modify a  not null;
drop table if exists  ctsql_dhj_t3;

drop table if exists  ctsql_dhj_t4;
create table ctsql_dhj_t4(a int not null);
insert into  ctsql_dhj_t4 values (1);
alter table  ctsql_dhj_t4 modify a  null;
drop table if exists  ctsql_dhj_t4;

drop table if exists  ctsql_dhj_t5;
create table ctsql_dhj_t5(a clob not null);
insert into  ctsql_dhj_t5 values ('1');
alter table  ctsql_dhj_t5 modify a  null;
drop table if exists  ctsql_dhj_t5;

drop table if exists  ctsql_dhj_t6;
create table ctsql_dhj_t6(a clob null);
insert into  ctsql_dhj_t6 values (NULL);
alter table  ctsql_dhj_t6 modify a not null;
drop table if exists  ctsql_dhj_t6;

drop table if exists  ctsql_dhj_t7;
create table ctsql_dhj_t7(a int ,b int );
insert into  ctsql_dhj_t7 (a) values (1);
alter table  ctsql_dhj_t7 modify a not null;
alter table  ctsql_dhj_t7 modify b not null;
drop table if exists  ctsql_dhj_t7;

drop table if exists  ctsql_dhj_t8;
create table ctsql_dhj_t8(a int ,b int );
insert into  ctsql_dhj_t8 (a) values (1);
alter table  ctsql_dhj_t8 modify a not null;
alter table  ctsql_dhj_t8 modify b not null;
drop table if exists  ctsql_dhj_t8;

drop table if exists  ctsql_dhj_t9;
create table ctsql_dhj_t9( a int);
alter table  ctsql_dhj_t9 modify a number(5);
alter table  ctsql_dhj_t9 modify a int;
insert into  ctsql_dhj_t9 values (1);
alter table  ctsql_dhj_t9 modify a number(5);
alter table  ctsql_dhj_t9 modify a int;
alter table  ctsql_dhj_t9 modify a char;
alter table  ctsql_dhj_t9 modify a int;
drop table if exists  ctsql_dhj_t9;

drop table if exists  ctsql_dhj_t10;
create table ctsql_dhj_t10 (a int);
insert into  ctsql_dhj_t10 values (1);
alter table  ctsql_dhj_t10 modify a not null;
drop table if exists  ctsql_dhj_t10;

drop table if exists  ctsql_dhj_t11;
create table ctsql_dhj_t11 (a varchar(10));
insert into  ctsql_dhj_t11 values ('1');
alter table  ctsql_dhj_t11 modify a not null;
alter table  ctsql_dhj_t11 modify a varchar(2);
alter table  ctsql_dhj_t11 modify a varchar(12);
drop table if exists  ctsql_dhj_t11;

drop table if exists  ctsql_dhj_t12;
create table ctsql_dhj_t12 (a number(10,2));
insert into  ctsql_dhj_t12 values (1.2);
alter table  ctsql_dhj_t12 modify a not null;
alter table  ctsql_dhj_t12 modify a number(9);
alter table  ctsql_dhj_t12 modify a number(14,2);
drop table if exists  ctsql_dhj_t12;

drop table if exists  ctsql_dhj_t13;
create table ctsql_dhj_t13 (a binary(10));
insert into  ctsql_dhj_t13 values ('123');
alter table  ctsql_dhj_t13 modify a not null;
alter table  ctsql_dhj_t13 modify a binary(9);
alter table  ctsql_dhj_t13 modify a binary(14);
drop table if exists  ctsql_dhj_t13;

drop table if exists  ctsql_dhj_t14;
create table ctsql_dhj_t14 (a char(10));
insert into  ctsql_dhj_t14 values ('123');
alter table  ctsql_dhj_t14 modify a not null;
alter table  ctsql_dhj_t14 modify a char(9);
alter table  ctsql_dhj_t14 modify a char(14);
drop table if exists  ctsql_dhj_t14;

drop table if exists  ctsql_dhj_t15;
create table ctsql_dhj_t15 (a char(10));
insert into  ctsql_dhj_t15 values ('123');
alter table  ctsql_dhj_t15 modify a not null;
alter table  ctsql_dhj_t15 modify a varchar(9);
alter table  ctsql_dhj_t15 modify a varchar(14);
drop table if exists  ctsql_dhj_t15;

drop table if exists  ctsql_dhj_t16;
create table ctsql_dhj_t16 (a varchar(10));
insert into  ctsql_dhj_t16 values ('123');
alter table  ctsql_dhj_t16 modify a not null;
alter table  ctsql_dhj_t16 modify a char(9);
alter table  ctsql_dhj_t16 modify a char(14);
drop table if exists  ctsql_dhj_t16;

set ctsql_ssl_mode=required;
set ctsql_ssl_mode= disabled;
set ctsql_ssl_mode = verify_ca;
set ctsql_ssl_mode =verify_full;
set ctsql_ssl_mode=preferred;
set ctsql_ssl_ca = ca.pem;
set ctsql_ssl_cert = client-cert.pem;
set ctsql_ssl_key = client-key.pem;
set ctsql_ssl_crl = server-crl.pem;
set ctsql_ssl_key_passwd = 'xhBu28RNQO0NRpczQOTgCP5YFh8ORZTdxA1TvhWKu1U=';
set ctsql_ssl_cipher = 'DHE-RSA-AES256-SHA256';

--DTS2018100906322
start
start;
start   
start   ;
@
@;
@   
@   ;
@@
@@;
@@   
@@   ;

-- column_def->size=max(uint16)
drop table if exists t1;
create table t1(f1 varchar(8000));
desc -q select f1 || f1 || f1 || f1 || f1 || f1 || f1 || f1 || f1 || f1 as ff from t1;
desc -q select concat(f1,f1,f1,f1,f1,f1,f1,f1,f1,f1) as ff from t1;
desc -q select concat_ws(f1,f1,f1,f1,f1,f1,f1,f1,f1,f1) as ff from t1;

--DTS2018110809249
conn sys/Huawei@123@
conn sys/Huawei@123@127.0.0.1:1611

--DTS2019022009241
drop table if exists t_DTS2019022009241;
create table t_DTS2019022009241(c clob);
insert into t_DTS2019022009241 values(
'Parent Alarm: 1522_MGW Out of Service
Child Alarm: 2371_Number of trunk group''s fault circuits exceed threshold
Action: Set alarm 2371 to correlated alarm
'
);
select * from t_DTS2019022009241;

@multiplesql.sql

--DTS2019012911717
@testlongsql.sql

--DTS2018120307199
create user test_nopasswd identified by ;

--DTS2018121912655, verify client SSL file path
SET CTSQL_SSL_CERT = ./userCert/11111111111111111111/22222222222222222222/00000000000000000000/44444444444444444444/55555555555555555555/66666666666666666666/77777777777777777777/88888888888888888888/999999999999999/11111111111111111111/22222222222222222222/000000000000000255/aaaaaaaaaaa/Client.pem

SET CTSQL_SSL_KEY = ./userCert/11111111111111111111/22222222222222222222/00000000000000000000/44444444444444444444/55555555555555555555/66666666666666666666/77777777777777777777/88888888888888888888/999999999999999/11111111111111111111/22222222222222222222/000000000000000255/aaaaaaaaaaa/Client.key

SET CTSQL_SSL_CA = ./userCert/11111111111111111111/22222222222222222222/00000000000000000000/44444444444444444444/55555555555555555555/66666666666666666666/77777777777777777777/88888888888888888888/999999999999999/11111111111111111111/22222222222222222222/000000000000000255/aaaaaaaaaaa/RootCA0.pem

SET ctsql_ssl_crl = ./userCert/11111111111111111111/22222222222222222222/00000000000000000000/44444444444444444444/55555555555555555555/66666666666666666666/77777777777777777777/88888888888888888888/999999999999999/11111111111111111111/22222222222222222222/000000000000000255/aaaaaaaaaaa/Server.crl

set ctsql_ssl_key_passwd = 'dsTvRl5oVO4bG6ULJ8GCT2iFtdYE2qNu2Mx2Eb8TPVDxJOQeoQ2jViKyYJ2JMI2V63Eyf1bWaR7Wl67/fSsPVdFZmvWpeWETpuFDF01Yq7cD3hGLGN/9CsIdV4+Brr+c';

set ctsql_ssl_key_passwd = 'dsTvRl5oVO4bG6ULJ8GCT2iFtdYE2qNu2Mx2Eb8TPVDxJOQeoQ2jViKyYJ2JMI2V63Eyf1bWaR7Wl67/fSsPVdFZmvWpeWETpuFDF01Yq7cD3hGLGN/9CsIdV4+Brr+ce';

-- DTS2019020203957 (and condition should do left node first)
drop table if exists ts_and_cond;
create table ts_and_cond(c int,c1 int);
insert into ts_and_cond values(1,1);
insert into ts_and_cond values(-1294729216,3000);
commit;
select power(c,c1) from ts_and_cond where c = 1 and power(c,c1) = 1;
select power(c,c1) from ts_and_cond;

drop table if exists "你好tb;drop ''table l01";
create table "你好tb;drop ''table l01" ( name varchar(100));
insert into "你好tb;drop ''table l01"  values('zhangsan'),('lisi'),('wangwu');
select * from "你好tb;drop ''table l01" order by name;
DUMP TABLE "你好tb;drop ''table l01" INTO FILE './dump_776.txt';
desc "你好tb;drop ''table l01" ;
drop table if exists "你好tb;drop ''table l01";

-- ctsql shell core
\! rm -rf test_shell
\!mkdir test_shell;
\!rm -rf test_shell
\!mkdir test_shell;;
\!rm -rf test_shell
\!mkdir test_shell;\!mkdir test_shell1;
\!rm -rf test_shell \!rm -rf test_shell1

-- ctsql supports execute shell command
\!ctsql / as sysdba -q -c "drop table if exists t_shell; drop table if exists t_shell; drop table if exists t_shell; drop table if exists t_shell; drop table if exists t_shell; drop table if exists t_shell; drop table if exists t_shell; create table t_shell(f1 int);insert into t_shell values(123);"
desc t_shell
\!ctsql / as sysdba -q -c "create or replace PROCEDURE bits_sp_deldev(v_iDevID IN INT) as begin update t_shell set f1=321; commit; end; /"
\!ctsql / as sysdba -q -c "select * from t_shell; drop table t_shell"

-- ctsql support connect timeout
\!ctsql / as sysdba -q -w
show connect
\!ctsql / as sysdba -q -w -2
show connect
\!ctsql / as sysdba -q -w -2.1
show connect
\!ctsql / as sysdba -q -w 'aaa'
show connect
\!ctsql / as sysdba -q -w "321.3"
show connect

-- ctsql support socket timeout
\!ctsql / as sysdba -q -w
show socket
\!ctsql / as sysdba -q -w -2
show socket
\!ctsql / as sysdba -q -w -2.1
show socket
\!ctsql / as sysdba -q -w 'aaa'
show socket
\!ctsql / as sysdba -q -w "321.3"
show socket
--DTS2019031202504 
set ctsql_ssl_mode=''


--uds
show UDS_SERVER_PATH
SET UDS_SERVER_PATH=
SET UDS_SERVER_PATH=NULL
SET UDS_SERVER_PATH='/HOME/REGRESS/ABCDEFGHIJKLMNASDKLFJASLKDJFALKSDJFALKSJDFLKASJDFLKAJSDFLAJSLDKJFALKSJDFALSJDFKALSDJFALKSDJFALKSDJFALKSJDFLKASJDFAJS'
show UDS_SERVER_PATH
SET UDS_CLIENT_PATH=
SET UDS_CLIENT_PATH=NULL
show UDS_CLIENT_PATH
SET UDS_CLIENT_PATH='/HOME/REGRESS/ABCDEFGHIJKLMNASDKLFJASLKDJFALKSDJFALKSJDFLKASJDFLKAJSDFLAJSLDKJFALKSJDFALSJDFKALSDJFALKSDJFALKSDJFALKSJDFLKASJDFAJS'
show UDS_CLIENT_PATH
connect sys/Huawei@123@uds
select MAX_SESSIONS,SERVICE_COUNT + IDLE_SESSIONS AS TOTAL_COUNT from DV_EMERG_POOL;

-- 	DTS2019072801698
@comment_at_first.sql

-- DTS2019121309516 show create table supports tables under sys schema including sys tables
conn sys/Huawei@123@127.0.0.1:1611
drop table if exists t1; 
create table t1(id int);
show create table t1;
show create table SYS_DISTRIBUTE_STRATEGIES;
show create table WSR_DBA_SEGMENTS;
show create table SYS_SHADOW_INDEX_PARTS;
show create table SYS_PENDING_DIST_TRANS;
drop user if exists test_hello cascade;
create user test_hello identified by Cantian_234;
grant dba to test_hello;
conn test_hello/Cantian_234@uds
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists test_hello cascade;

DROP USER IF EXISTS USER1TEST CASCADE;
CREATE USER USER1TEST identified by Root1234;
grant connect to USER1TEST;
CONN USER1TEST/Root1234@127.0.0.1:1612
CONN USER1TEST/Root1234@127.0.0.1:1611
CONN USER1TEST/Root1234@127.0.0.1:1611

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists usertest123;
create user usertest123 identified by "cantian--234";
grant dba to usertest123;
conn usertest123/cantian--234@127.0.0.1:1611
conn usertest123/cantian--234@127.0.0.1:1611--123
conn usertest123/cantian--234@127.0.0.1:1611 --123
conn / as sysdba--123
conn / as sysdba --123
conn sys/Huawei@123@127.0.0.1:1611--123
conn sys/Huawei@123@127.0.0.1:1611 --123
drop user if exists "test--123";
create user "test--123" identified by "cantian--234";
grant dba to "test--123";
conn "test--123"/cantian--234@127.0.0.1:1611
conn test--123/cantian--234@127.0.0.1:1611