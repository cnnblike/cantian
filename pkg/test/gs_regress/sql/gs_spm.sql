--privilege testcases
conn / as sysdba

DROP TABLE IF EXISTS T_SPM_TEST_001;
CREATE TABLE T_SPM_TEST_001(
ID INT,C_INT INT,C_REAL REAL,C_FLOAT FLOAT,C_DECIMAL DECIMAL,C_NUMBER NUMBER,
C_CHAR CHAR(10),C_VCHAR VARCHAR(10) NOT NULL,C_VCHAR2 VARCHAR2(100),C_CLOB CLOB,
C_LONG VARCHAR(200),C_BLOB BLOB,C_RAW RAW(100),C_DATE DATE,C_TIMESTAMP TIMESTAMP);

create user spm_test identified by Cantian_234;
grant DBA to spm_test;
CONN spm_test/Cantian_234@127.0.0.1:1611

DROP TABLE IF EXISTS T_SPM_TEST_001;
CREATE TABLE T_SPM_TEST_001(
ID INT,C_INT INT,C_REAL REAL,C_FLOAT FLOAT,C_DECIMAL DECIMAL,C_NUMBER NUMBER,
C_CHAR CHAR(10),C_VCHAR VARCHAR(10) NOT NULL,C_VCHAR2 VARCHAR2(100),C_CLOB CLOB,
C_LONG VARCHAR(200),C_BLOB BLOB,C_RAW RAW(100),C_DATE DATE,C_TIMESTAMP TIMESTAMP);

conn / as sysdba
create user spm_public identified by Cantian_234;
grant create session to spm_public;
grant create table to spm_public;
CONN spm_public/Cantian_234@127.0.0.1:1611

DROP TABLE IF EXISTS T_SPM_TEST_001;
CREATE TABLE T_SPM_TEST_001(
ID INT,C_INT INT,C_REAL REAL,C_FLOAT FLOAT,C_DECIMAL DECIMAL,C_NUMBER NUMBER,
C_CHAR CHAR(10),C_VCHAR VARCHAR(10) NOT NULL,C_VCHAR2 VARCHAR2(100),C_CLOB CLOB,
C_LONG VARCHAR(200),C_BLOB BLOB,C_RAW RAW(100),C_DATE DATE,C_TIMESTAMP TIMESTAMP);

conn / as sysdba
CREATE TENANT SPM_TNT TABLESPACES (USERS) DEFAULT TABLESPACE USERS;
CREATE TABLESPACE SPM_TNT_SPACE1 DATAFILE 'SPM_TNT_SPACE1' SIZE 128M;
ALTER TENANT SPM_TNT ADD TABLESPACES(SPM_TNT_SPACE1);
ALTER TENANT SPM_TNT DEFAULT TABLESPACE SPM_TNT_SPACE1;
alter session set tenant=SPM_TNT;
create user user1 identified by Cantian_234;
grant dba to user1;
CONN user1/Cantian_234@127.0.0.1:1611/SPM_TNT

DROP TABLE IF EXISTS T_SPM_TEST_001;
CREATE TABLE T_SPM_TEST_001(
ID INT,C_INT INT,C_REAL REAL,C_FLOAT FLOAT,C_DECIMAL DECIMAL,C_NUMBER NUMBER,
C_CHAR CHAR(10),C_VCHAR VARCHAR(10) NOT NULL,C_VCHAR2 VARCHAR2(100),C_CLOB CLOB,
C_LONG VARCHAR(200),C_BLOB BLOB,C_RAW RAW(100),C_DATE DATE,C_TIMESTAMP TIMESTAMP);

----SYS
--ROOT sys
conn / as sysdba
call DBE_SPM.imp_sql_profile(schema=>'spm_test', sql=>'select count(*) from t_spm_test_001 t1, t_spm_test_001 t3 inner join t_spm_test_001 t4 on t3.id = t4.id where t1.id > t3.id', profile=>'adjust index cost', prof_name=>'prof_SPM_TEST_privs_test_1');
call DBE_SPM.imp_sql_profile(schema=>'SPM_TNT$USER1', sql=>'select count(*) from t_spm_test_001 t1, t_spm_test_001 t3 inner join t_spm_test_001 t4 on t3.id = t4.id where t1.id > t3.id', profile=>'adjust index cost', prof_name=>'prof_SPM_TNTUSER1_privs_test_1');
--TENANT sys
alter session set tenant=SPM_TNT;
call DBE_SPM.alter_sql_profile(prof_name=>'prof_SPM_TEST_privs_test_1', profile=>'alter adjust index cost');
call DBE_SPM.alter_sql_profile(prof_name=>'prof_SPM_TNTUSER1_privs_test_1', profile=>'alter adjust index cost');
----DBE_SPM
--ROOT DBE_SPM
CONN spm_test/Cantian_234@127.0.0.1:1611
call DBE_SPM.imp_sql_profile(schema=>'SYS', sql=>'select count(*) from t_spm_test_001 t1, t_spm_test_001 t3 inner join t_spm_test_001 t4 on t3.id = t4.id where t1.id > t3.id', profile=>'adjust index cost', prof_name=>'prof_SYS_privs_test_1');
call DBE_SPM.imp_sql_profile(schema=>'spm_public', sql=>'select count(*) from t_spm_test_001 t1, t_spm_test_001 t3 inner join t_spm_test_001 t4 on t3.id = t4.id where t1.id > t3.id', profile=>'adjust index cost', prof_name=>'prof_spm_public_privs_test_1');
call DBE_SPM.alter_sql_profile(prof_name=>'prof_spm_public_privs_test_1', profile=>'alter adjust index cost');
call DBE_SPM.imp_sql_profile(schema=>'SPM_TNT$USER1', sql=>'select count(*) from t_spm_test_001 t1, t_spm_test_001 t3 inner join t_spm_test_001 t4 on t3.id = t4.id where t1.id > t3.id', profile=>'adjust index cost', prof_name=>'prof_SPM_TNTUSER1_privs_test_2');
select SCHEMA,SQL_ID,SQL_SIGN,SIGNATURE,STATUS,LAST_STATUS,PROF_NAME,PROFILE,OUTLINE,SQL_TEXT from adm_spm order by PROF_NAME;
select SCHEMA,SQL_ID,SQL_SIGN,SIGNATURE,STATUS,LAST_STATUS,PROF_NAME,PROFILE,OUTLINE,SQL_TEXT from db_spm order by PROF_NAME;
select SCHEMA,SQL_ID,SQL_SIGN,SIGNATURE,STATUS,LAST_STATUS,PROF_NAME,PROFILE,OUTLINE,SQL_TEXT from my_spm order by PROF_NAME;
--TENANT DBA
CONN user1/Cantian_234@127.0.0.1:1611/SPM_TNT
call DBE_SPM.imp_sql_profile(schema=>'SYS', sql=>'select count(*) from t_spm_test_001 t1, t_spm_test_001 t3 inner join t_spm_test_001 t4 on t3.id = t4.id where t1.id > t3.id', profile=>'adjust index cost', prof_name=>'prof_SYS_privs_test_1');
call DBE_SPM.imp_sql_profile(schema=>'TENANT$ROOT$spm_public', sql=>'select count(*) from t_spm_test_001 t1, t_spm_test_001 t3 inner join t_spm_test_001 t4 on t3.id = t4.id where t1.id > t3.id', profile=>'adjust index cost', prof_name=>'prof_spm_public_privs_test_2');
call DBE_SPM.alter_sql_profile(prof_name=>'prof_SPM_TNTUSER1_privs_test_2', profile=>'alter adjust index cost');
select SCHEMA,SQL_ID,SQL_SIGN,SIGNATURE,STATUS,LAST_STATUS,PROF_NAME,PROFILE,OUTLINE,SQL_TEXT from adm_spm order by PROF_NAME;
select SCHEMA,SQL_ID,SQL_SIGN,SIGNATURE,STATUS,LAST_STATUS,PROF_NAME,PROFILE,OUTLINE,SQL_TEXT from db_spm order by PROF_NAME;
select SCHEMA,SQL_ID,SQL_SIGN,SIGNATURE,STATUS,LAST_STATUS,PROF_NAME,PROFILE,OUTLINE,SQL_TEXT from my_spm order by PROF_NAME;
----PUBLIC
--ROOT
CONN spm_public/Cantian_234@127.0.0.1:1611
call DBE_SPM.imp_sql_profile(schema=>'SYS', sql=>'select count(*) from t_spm_test_001 t1, t_spm_test_001 t3 inner join t_spm_test_001 t4 on t3.id = t4.id where t1.id > t3.id', profile=>'adjust index cost', prof_name=>'prof_SYS_privs_test_1');

call DBE_SPM.imp_sql_profile(schema=>'spm_public', sql=>'select count(*) from t_spm_test_001 t1, t_spm_test_001 t3 inner join t_spm_test_001 t4 on t3.id = t4.id where t1.id > t3.id', profile=>'adjust index cost', prof_name=>'prof_spm_public_privs_test_2');

call DBE_SPM.imp_sql_profile(schema=>'SPM_TNT$USER1', sql=>'select count(*) from t_spm_test_001 t1, t_spm_test_001 t3 inner join t_spm_test_001 t4 on t3.id = t4.id where t1.id > t3.id', profile=>'adjust index cost', prof_name=>'prof_SPM_TNTUSER1_privs_test_3');
select SCHEMA,SQL_ID,SQL_SIGN,SIGNATURE,STATUS,LAST_STATUS,PROF_NAME,PROFILE,OUTLINE,SQL_TEXT from adm_spm order by PROF_NAME;
select SCHEMA,SQL_ID,SQL_SIGN,SIGNATURE,STATUS,LAST_STATUS,PROF_NAME,PROFILE,OUTLINE,SQL_TEXT from db_spm order by PROF_NAME;
select SCHEMA,SQL_ID,SQL_SIGN,SIGNATURE,STATUS,LAST_STATUS,PROF_NAME,PROFILE,OUTLINE,SQL_TEXT from my_spm order by PROF_NAME;
conn / as sysdba
select SCHEMA,SQL_ID,SQL_SIGN,SIGNATURE,STATUS,LAST_STATUS,PROF_NAME,PROFILE,OUTLINE from sys_spm order by PROF_NAME;
select SCHEMA,SQL_ID,SQL_SIGN,SQL_TEXT from sys_spm_sqls order by SCHEMA,SQL_ID;

--different user same sql
--sys
explain SELECT /*+use_nl(t2) leading(t1)*/ T2.ID FROM t_spm_test_001 T1 JOIN t_spm_test_001 T2 ON T1.C_CHAR = T2.C_CHAR WHERE T1.C_CHAR = 'TEST-1';
select distinct pt.sql_id,pt.signature,pt.version,pt.plan_text from dv_sql_plan pt join dv_sqls st on st.sql_id = pt.sql_id where pt.sql_id = '2651504305';
call DBE_SPM.create_sql_outline(schema=>user, dst_sql=>'SELECT  T2.ID FROM t_spm_test_001 T1 JOIN t_spm_test_001 T2 ON T1.C_CHAR = T2.C_CHAR WHERE T1.C_CHAR = ''TEST-1''', sql_id=>'2651504305', signature=>'AFE209FE0160B5236D7B293506FEC20E');
explain SELECT  T2.ID FROM t_spm_test_001 T1 JOIN t_spm_test_001 T2 ON T1.C_CHAR = T2.C_CHAR WHERE T1.C_CHAR = 'TEST-1';
--spm_test
CONN spm_test/Cantian_234@127.0.0.1:1611
explain SELECT /*+use_nl(t2) leading(t1)*/ T2.ID FROM t_spm_test_001 T1 JOIN t_spm_test_001 T2 ON T1.C_CHAR = T2.C_CHAR WHERE T1.C_CHAR = 'TEST-1';
select distinct pt.sql_id,pt.signature,pt.version,pt.plan_text from dv_sql_plan pt join dv_sqls st on st.sql_id = pt.sql_id where pt.sql_id = '2651504305' and pt.signature = '79030DF7EF8386CFBB0FD94757F3E317';
call DBE_SPM.create_sql_outline(schema=>user, dst_sql=>'SELECT  T2.ID FROM t_spm_test_001 T1 JOIN t_spm_test_001 T2 ON T1.C_CHAR = T2.C_CHAR WHERE T1.C_CHAR = ''TEST-1''', sql_id=>'2651504305', signature=>'79030DF7EF8386CFBB0FD94757F3E317');
explain SELECT  T2.ID FROM t_spm_test_001 T1 JOIN t_spm_test_001 T2 ON T1.C_CHAR = T2.C_CHAR WHERE T1.C_CHAR = 'TEST-1';

--end
conn / as sysdba
call dbe_spm.clean_spm(schema=>user);
drop user spm_public cascade;
drop user spm_test cascade;
drop tenant SPM_TNT cascade;
drop TABLESPACE SPM_TNT_SPACE1;
select SCHEMA,SQL_ID,SQL_SIGN,SIGNATURE,STATUS,LAST_STATUS,PROF_NAME,PROFILE,OUTLINE from sys_spm;
select SCHEMA,SQL_ID,SQL_SIGN,SQL_TEXT from sys_spm_sqls;
