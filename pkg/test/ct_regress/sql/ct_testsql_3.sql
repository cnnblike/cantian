--set echo on
set feedback off
set serveroutput on
conn sys/Huawei@123@127.0.0.1:1611
execute dbe_output.print_line('$Start processing script.');
--** The script is dumped by *CTSQL/EXP* tool, Zenith@Huawei Cantian Dept.
--** Dumped time: 2018-09-14 16:08:53.320

-- EXPORT TYPE = TABLE
-- EXPORT OBJECTS = T_TEST_WG
-- FILE TYPE = TXT
-- DUMP FILE = g:\1.sql
-- LOG FILE = 
-- QUERY = ""
-- COMPRESS = N
-- CONTENT_MODE = ALL
-- SKIP_COMMENTS = N
-- FORCE = N
-- SKIP_ADD_DROP_TABLE = N
-- SKIP_TRIGGERS = N
-- QUOTE_NAMES = N
-- COMMIT_BATCH = 1000
-- INSERT_BATCH = 1
-- FEEDBACK = 500
-- PARALLEL = 0

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF TZH:TZM';
ALTER SESSION SET NLS_TIME_FORMAT = 'HH:MI:SS.FF AM';
ALTER SESSION SET NLS_TIME_TZ_FORMAT = 'HH:MI:SS.FF AM TZR';

DROP TABLE if exists T_TEST_WG;
CREATE TABLE T_TEST_WG
(
  ID INTEGER,
  NAME VARCHAR(100 BYTE)
)
TABLESPACE USERS
INITRANS 2
MAXTRANS 255
PCTFREE 8;
INSERT INTO T_TEST_WG (ID,NAME) values(335,'aaaaaaaaaaaa');
INSERT INTO T_TEST_WG (ID,NAME) values(336,'aaaaaaaaaaaa');
INSERT INTO T_TEST_WG (ID,NAME) values(337,'aaaaaaaaaaaa');
INSERT INTO T_TEST_WG (ID,NAME) values(338,'aaaaaaaaaaaa');
INSERT INTO T_TEST_WG (ID,NAME) values(339,'aaaaaaaaaaaa');
INSERT INTO T_TEST_WG (ID,NAME) values(340,'aaaaaaaaaaaa');
INSERT INTO T_TEST_WG (ID,NAME) values(341,'aaaaaaaaaaaa');
COMMIT;
execute dbe_output.print_line('$Finish processing script.');

select count(*) from dual;
set echo on
set feedback on
select count(*) from dual;
set echo off
set serveroutput off


-- end of exp: 2018-09-14 16:08:56.862