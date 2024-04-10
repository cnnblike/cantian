conn / as sysdba
truncate table sys_audit;
alter system set AUDIT_TRAIL_MODE = DB;
create user hello identified by password;
create role rolewww identified by hello123;
alter user sys identified by password replace hello123;
select SQLTEXT from sys_audit where SQLTEXT like '%user%' or SQLTEXT like '%role%' order by SQLTEXT;
conn / as sysdba 
truncate table sys_audit;
drop user if exists test_audit_user cascade;
create user test_audit_user identified by Cantian_234;
grant connect, create table to test_audit_user;
alter system set AUDIT_LEVEL = 0;
alter system set _log_LEVEL = 0;
alter system set AUDIT_TRAIL_MODE = DB;
conn test_audit_user/Cantian_234@127.0.0.1:1611
create table t1(id int);
conn / as sysdba
select count(*) from sys_audit where USERNAME = 'TEST_AUDIT_USER' and ACTION = 'LOGIN';
alter system set AUDIT_LEVEL = 3;
conn test_audit_user/Cantian_234@127.0.0.1:1611
create table t2(id int);
conn / as sysdba
select count(*) from sys_audit where USERNAME = 'TEST_AUDIT_USER' and ACTION = 'LOGIN';
truncate table sys_audit;
alter system set AUDIT_LEVEL = 0;
alter system set _log_LEVEL = 7;
conn test_audit_user/Cantian_234@127.0.0.1:1611
create table t3(id int);
conn / as sysdba
select count(*) from sys_audit where USERNAME = 'TEST_AUDIT_USER' and ACTION = 'LOGIN';
alter system set AUDIT_LEVEL = 3;
alter system set _log_LEVEL = 7;
conn test_audit_user/Cantian_234@127.0.0.1:1611
create table t4(id int);
conn / as sysdba
select count(*) from sys_audit where USERNAME = 'TEST_AUDIT_USER' and ACTION = 'LOGIN';
alter system set AUDIT_TRAIL_MODE = FILE;
drop user test_audit_user cascade;
truncate table sys_audit;
conn / as sysdba 
alter system switch jjj;
alter system switch;
drop user if exists nebula;
create user nebula identified by cao102_cao;
create table nebula.nebula_ddl_hash_012_1 (id int);
alter table nebula.nebula_ddl_hash_012_1 rename to nebula.nebula_ddl_hash_012_3;
alter table nebula.nebula_ddl_hash_012_3 rename to nebulb.nebula_ddl_hash_012_4;
alter table nebula.nebula_ddl_hash_012_3 rename to nebula_ddl_hash_012_4;
alter system reload hba config hhh;
alter system refresh sysdba privilege hhh;
drop user nebula cascade;
CONN / AS SYSDBA
DROP TABLE SYS.SYS_AUDIT;
INSERT INTO  SYS.SYS_AUDIT (CTIME) VALUES (11);
UPDATE SYS.SYS_AUDIT SET CTIME = '999';
DELETE FROM SYS.SYS_AUDIT; 
TRUNCATE TABLE SYS.SYS_AUDIT;
CREATE USER CAOTT1 IDENTIFIED BY CAO102_CAO;
GRANT  CONNECT ,DROP ANY TABLE ,SELECT ANY TABLE ,INSERT ANY TABLE ,UPDATE ANY TABLE TO CAOTT1;
CONN CAOTT1/CAO102_CAO@127.0.0.1:1611
DROP TABLE SYS.SYS_AUDIT;
INSERT INTO  SYS.SYS_AUDIT (CTIME) VALUES (11);
UPDATE SYS.SYS_AUDIT SET CTIME = '999';
DELETE FROM SYS.SYS_AUDIT; 
CONN / AS SYSDBA
DROP USER CAOTT1;
SELECT NAME FROM DV_PARAMETERS WHERE NAME = 'AUDIT_TRAIL_MODE';
ALTER SYSTEM SET AUDIT_TRAIL_MODE = ALL;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = 'ALL';
ALTER SYSTEM SET AUDIT_TRAIL_MODE = "ALL";
ALTER SYSTEM SET AUDIT_TRAIL_MODE = DB;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = 'DB';
ALTER SYSTEM SET AUDIT_TRAIL_MODE = "DB";
ALTER SYSTEM SET AUDIT_TRAIL_MODE = FILE;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = 'FILE';
ALTER SYSTEM SET AUDIT_TRAIL_MODE = "FILE";
ALTER SYSTEM SET AUDIT_TRAIL_MODE = NONE;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = 'NONE';
ALTER SYSTEM SET AUDIT_TRAIL_MODE = "NONE";
ALTER SYSTEM SET AUDIT_TRAIL_MODE = A;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = D;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = ALLAH;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = ALL$;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = DB A;
ALTER SYSTEM SET AUDIT_LEVEL = 1;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = ALL;
TRUNCATE TABLE SYS.SYS_AUDIT;
CREATE TABLE HELLOT1(ID INT);
INSERT INTO HELLOT1 VALUES(1);
SELECT ID FROM HELLOT1;
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'CREATE TABLE HELLOT1(ID INT)';
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'SELECT ID FROM HELLOT1';
DROP TABLE HELLOT1;
DROP USER IF EXISTS USER1;
CREATE USER USER1 IDENTIFIED BY ZHANGZHICAI_123;
ALTER SYSTEM SET AUDIT_LEVEL = 3;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = ALL;
TRUNCATE TABLE SYS.SYS_AUDIT;
CREATE TABLE HELLOT1(ID INT);
INSERT INTO HELLOT1 VALUES(1);
GRANT CONNECT TO USER1;
SELECT ID FROM HELLOT1;
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'CREATE TABLE HELLOT1(ID INT)';
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'GRANT CONNECT TO USER1';
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'SELECT ID FROM HELLOT1';
DROP TABLE HELLOT1;
DROP USER IF EXISTS USER1;
CREATE USER USER1 IDENTIFIED BY ZHANGZHICAI_123;
ALTER SYSTEM SET AUDIT_LEVEL = 7;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = ALL;
TRUNCATE TABLE SYS.SYS_AUDIT;
CREATE TABLE HELLOT1(ID INT);
GRANT CONNECT TO USER1;
INSERT INTO HELLOT1 VALUES(1);
SELECT ID FROM HELLOT1;
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'CREATE TABLE HELLOT1(ID INT)';
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'GRANT CONNECT TO USER1';
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'SELECT ID FROM HELLOT1';
DROP TABLE HELLOT1;
DROP USER IF EXISTS USER1;
CREATE USER USER1 IDENTIFIED BY ZHANGZHICAI_123;
ALTER SYSTEM SET AUDIT_LEVEL = 7;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = DB;
TRUNCATE TABLE SYS.SYS_AUDIT;
CREATE TABLE HELLOT1(ID INT);
GRANT CONNECT TO USER1;
INSERT INTO HELLOT1 VALUES(1);
SELECT ID FROM HELLOT1;
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'CREATE TABLE HELLOT1(ID INT)';
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'GRANT CONNECT TO USER1';
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'SELECT ID FROM HELLOT1';
DROP TABLE HELLOT1;
DROP USER IF EXISTS USER1;
CREATE USER USER1 IDENTIFIED BY ZHANGZHICAI_123;
ALTER SYSTEM SET AUDIT_LEVEL = 7;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = FILE;
TRUNCATE TABLE SYS.SYS_AUDIT;
CREATE TABLE HELLOT1(ID INT);
GRANT CONNECT TO USER1;
INSERT INTO HELLOT1 VALUES(1);
SELECT ID FROM HELLOT1;
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'CREATE TABLE HELLOT1(ID INT)';
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'GRANT CONNECT TO USER1';
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'SELECT ID FROM HELLOT1';
DROP TABLE HELLOT1;
DROP USER IF EXISTS USER1;
CREATE USER USER1 IDENTIFIED BY ZHANGZHICAI_123;
ALTER SYSTEM SET AUDIT_LEVEL = 7;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = NONE;
TRUNCATE TABLE SYS.SYS_AUDIT;
CREATE TABLE HELLOT1(ID INT);
GRANT CONNECT TO USER1;
INSERT INTO HELLOT1 VALUES(1);
SELECT ID FROM HELLOT1;
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'CREATE TABLE HELLOT1(ID INT)';
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'GRANT CONNECT TO USER1';
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'SELECT ID FROM HELLOT1';
DROP TABLE HELLOT1;
DROP USER IF EXISTS USER1;
ALTER SYSTEM SET AUDIT_LEVEL = 3;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = FILE;
ALTER SYSTEM SET AUDIT_LEVEL = 0;
ALTER SYSTEM SET AUDIT_TRAIL_MODE = DB;
TRUNCATE TABLE SYS.SYS_AUDIT;
ALTER SYSTEM SET AUDIT_LEVEL=0;
SELECT SQLTEXT FROM SYS_AUDIT where SQLTEXT = 'ALTER SYSTEM SET AUDIT_LEVEL=0';
ALTER SYSTEM SET AUDIT_TRAIL_MODE = FILE;
--_PAGE_CACHE_COUNT
alter system set _PAGE_CACHE_COUNT=0;
alter system set _PAGE_CACHE_COUNT=17;
select * from v$parameter where name = '_PAGE_CACHE_COUNT';

SELECT * FROM V$PARAMETER WHERE NAME = '_ENCRYPTION_ALG';
SELECT * FROM V$PARAMETER WHERE NAME = 'SESSIONS';
SELECT * FROM V$PARAMETER WHERE NAME = 'LSNR_PORT';
--UNDO_RETENTION_TIME
alter system set UNDO_RETENTION_TIME=0;
alter system set UNDO_RETENTION_TIME=112147483647;
alter system set UNDO_RETENTION_TIME=200;
show parameter UNDO_RETENTION_TIME;
select RETENTION_TIME from v$undo_segment limit 1;
--DTS2019010400342
alter system set LSNR_PORT='1611';
--DBWR_PROCESSES
alter system set DBWR_PROCESSES=0;
alter system set DBWR_PROCESSES=36;
alter system set DBWR_PROCESSES=37;

--RAFT_NODE_ID
select * from v$parameter where name ='RAFT_NODE_ID';

--MAX_TEMP_TABLES
alter system set MAX_TEMP_TABLES=63;

--BUF_POOL_NUM
select * from v$parameter where name ='BUF_POOL_NUM';

--_PREFETCH_ROWS
alter system set _PREFETCH_ROWS='0';

--VMA
select * from DV_GMA where name='variant memory area';
select * from DV_GMA where name='large variant memory area';
select * from DV_GMA_STATS where area='variant memory area' and name='page size';
select * from DV_GMA_STATS where area='variant memory area' and name='page count';
select * from DV_GMA_STATS where area='large variant memory area' and name='page size';
select * from DV_GMA_STATS where area='large variant memory area' and name='page count';
select name, value, default_value, range from v$parameter where name ='VARIANT_MEMORY_AREA_SIZE';
alter system set VARIANT_MEMORY_AREA_SIZE=64M;
select name, value, default_value, range from v$parameter where name ='VARIANT_MEMORY_AREA_SIZE';
select name, value, default_value, range from v$parameter where name ='LARGE_VARIANT_MEMORY_AREA_SIZE';
alter system set LARGE_VARIANT_MEMORY_AREA_SIZE=64M;
select name, value, default_value, range from v$parameter where name ='LARGE_VARIANT_MEMORY_AREA_SIZE';
select name, value, default_value, range from v$parameter where name ='_VMP_CACHES_EACH_SESSION';
alter system set _VMP_CACHES_EACH_SESSION=10;
select name, value, default_value, range from v$parameter where name ='_VMP_CACHES_EACH_SESSION';

--DTS2018122000433 DTS2018122000225
alter system set KNL_AUTONOMOUS_SESSIONS=0;
alter system set AUTONOMOUS_SESSIONS=0;
alter system set STATISTICS_SAMPLE_SIZE=1000M;
alter system set STATISTICS_SAMPLE_SIZE=31M;
--DTS2018122707970
alter system set _LOG_MAX_FILE_SIZE=1;
alter system set _LOG_MAX_FILE_SIZE=9;
alter system set _LOG_MAX_FILE_SIZE=10k;
show parameter _LOG_MAX_FILE_SIZE
alter system set _LOG_MAX_FILE_SIZE=1M;
show parameter _LOG_MAX_FILE_SIZE
alter system set _LOG_MAX_FILE_SIZE=1024k;
show parameter _LOG_MAX_FILE_SIZE
alter system set _LOG_MAX_FILE_SIZE=3G;
show parameter _LOG_MAX_FILE_SIZE
alter system set _LOG_MAX_FILE_SIZE=5G;
show parameter _LOG_MAX_FILE_SIZE
--DTS2018093006735 DTS2018093005949
alter system set SESSIONS = 200;
alter system set SUPER_USER_RESERVED_SESSIONS = 5;
alter system set SUPER_USER_RESERVED_SESSIONS = 0;
alter system set SUPER_USER_RESERVED_SESSIONS = 1;
alter system set SUPER_USER_RESERVED_SESSIONS = 3;
alter system set SESSIONS = 150;
alter system set SUPER_USER_RESERVED_SESSIONS = 33;
alter system set SUPER_USER_RESERVED_SESSIONS = 32;
alter system set SESSIONS = 200;
alter system set SESSIONS = 1000;
alter system set SESSIONS = 1000 SCOPE=PFILE;
alter system set SESSIONS = 200;
alter system set SUPER_USER_RESERVED_SESSIONS = 33;
alter system set SUPER_USER_RESERVED_SESSIONS = 32;
alter system set SUPER_USER_RESERVED_SESSIONS = 5;

--DON'T SUPPORT DROP DATABASE
DROP DATABASE REGRESSION;

--LSNR_ADDR
alter system set LSNR_ADDR=127.0.0.1;
alter system set LSNR_ADDR='-1.0.0.1';
alter system set LSNR_ADDR='0.0.0.0,0.0.0.256';
alter system set LSNR_ADDR='127.0.0.1,';
alter system set LSNR_ADDR='';
alter system set LSNR_ADDR='1.1.1.1,2.2.2.2,3.3.3.3,4.4.4.4,5.5.5.5,6.6.6.6,7.7.7.7,8.8.8.8,9.9.9.9';
alter system set LSNR_ADDR='1.1.1.1,2.2.2.2,3.3.3.3,4.4.4.4,5.5.5.5,6.6.6.6,7.7.7.7,8.8.8.8,9.9.9.9,10.10.10.10';
alter system set LSNR_ADDR='1.1.1.1,2.2.2.256,3.3.3.3,4.4.4.4,5.5.5.5,6.6.6.6,7.7.7.7,8.8.8.8,9.9.9.9,10.10.10.10';

--LSNR_PORT
alter system set LSNR_PORT=65536;
alter system set LSNR_PORT=65535;
alter system set LSNR_PORT=-1;
alter system set LSNR_PORT=0;
alter system set LSNR_PORT=1611;

--WORK_THREADS
alter system set WORKER_THREADS='abc';

--REACTOR_THREADS
alter system set REACTOR_THREADS='abc';

--DATA_BUFFER_SIZE
alter system set DATA_BUFFER_SIZE=XXXX;
alter system set DATA_BUFFER_SIZE=1M;
alter system set DATA_BUFFER_SIZE=63M;
select RANGE from v$parameter where name = 'DATA_BUFFER_SIZE';

--CR_POOL_SIZE
alter system set CR_POOL_SIZE=XXXX;
alter system set CR_POOL_SIZE=1M;
alter system set CR_POOL_SIZE=63M;
select RANGE from v$parameter where name = 'CR_POOL_SIZE';

--CR_POOL_COUNT
alter system set CR_POOL_COUNT=XXXX;
alter system set CR_POOL_COUNT=512;

--SHARED_POOL_SIZE
alter system set SHARED_POOL_SIZE=XXXX;
alter system set SHARED_POOL_SIZE=70M;
alter system set SHARED_POOL_SIZE=81M;
select RANGE from v$parameter where name = 'SHARED_POOL_SIZE';

--SQL_POOL_FACTOR
alter system set _SQL_POOL_FACTOR=XXXX;
alter system set _SQL_POOL_FACTOR=0.50001;
select value from v$parameter where name = '_SQL_POOL_FACTOR';

--LARGE_POOL_SIZE
alter system set LARGE_POOL_SIZE=XXXX;
alter system set LARGE_POOL_SIZE=1M;
--DTS2019021600003:SIZE_T is GB size
alter system set LARGE_POOL_SIZE=33T;
alter system set TEMP_BUFFER_SIZE=22T;

--LOG_BUFFER_SIZE
alter system set LOG_BUFFER_SIZE=XXXX;
alter system set LOG_BUFFER_SIZE=64M;

--LOG_BUFFER_COUNT
alter system set LOG_BUFFER_COUNT=XXXX;
alter system set LOG_BUFFER_COUNT=100;

--USE_LARGE_PAGES
alter system set USE_LARGE_PAGES=XXXX;
alter system set USE_LARGE_PAGES=FALSE;
select value from v$parameter where name = 'USE_LARGE_PAGES';
alter system set USE_LARGE_PAGES=TRUE;
select value from v$parameter where name = 'USE_LARGE_PAGES';

--USE_NATIVE_DATATYPE
alter system set USE_NATIVE_DATATYPE=XXXX;

--_SPIN_COUNT
alter system set _SPIN_COUNT=XXXX;

--_ENABLE_QOS
alter system set _ENABLE_QOS=XXXX;

--_QOS_SLEEP_TIME
alter system set _QOS_SLEEP_TIME=XXXX;

--_QOS_RANDOM_RANGE
alter system set _QOS_RANDOM_RANGE=XXXX;

--_INDEX_BUFFER_SIZE
alter system set _INDEX_BUFFER_SIZE=XXXX;
alter system set _INDEX_BUFFER_SIZE=1K;

--_DOUBLEWRITE
alter system set _DOUBLEWRITE=XXXX;

--_THREAD_STACK_SIZE
alter system set _THREAD_STACK_SIZE=XXXX;
alter system set _THREAD_STACK_SIZE=32K;
select name, default_value, range from v$parameter where name ='_THREAD_STACK_SIZE';
alter system set _THREAD_STACK_SIZE=64K;
alter system set _THREAD_STACK_SIZE=256K;
select name, value, default_value, range from v$parameter where name ='_THREAD_STACK_SIZE';


--_BLACKBOX_STACK_DEPTH
alter system set _BLACKBOX_STACK_DEPTH=XXXX;
alter system set _BLACKBOX_STACK_DEPTH=41;

--_AGENT_STACK_SIZE
alter system set _AGENT_STACK_SIZE=XXXX;
alter system set _AGENT_STACK_SIZE=256;

--_VARIANT_AREA_SIZE
alter system set _VARIANT_AREA_SIZE=XXXX;

--_INIT_CURSORS
alter system set _INIT_CURSORS=XXXX;

--_DISABLE_SOFT_PARSE
alter system set _DISABLE_SOFT_PARSE=XXXX;

--SESSIONS
alter system set SESSIONS=XXXX;
alter system set SESSIONS=16321;
alter system set SESSIONS=8191;

--AUTONOMOUS_SESSIONS
alter system set AUTONOMOUS_SESSIONS=XXXX;
alter system set AUTONOMOUS_SESSIONS=512;

--OPEN_CURSORS
alter system set OPEN_CURSORS=XXXX;
select * from v$parameter where name = 'OPEN_CURSORS';

--_PREFETCH_ROWS
alter system set _PREFETCH_ROWS=XXXX;

--PAGE_SIZE
alter system set PAGE_SIZE=4K;

--COMMIT_LOGGING
alter system set COMMIT_LOGGING=XXXX;
select * from v$parameter where name = 'COMMIT_LOGGING';

--COMMIT_WAIT
alter system set COMMIT_WAIT=XXXX;
select * from v$parameter where name = 'COMMIT_WAIT';

--LOG_ARCHIVE_CONFIG
alter system set LOG_ARCHIVE_CONFIG=XXXX;
alter system set LOG_ARCHIVE_CONFIG='SEND,XXXX';
alter system set LOG_ARCHIVE_CONFIG='RECEIVE,XXXX';
alter system set LOG_ARCHIVE_CONFIG='NODG_CONFIG,XXXX';
alter system set LOG_ARCHIVE_CONFIG='DG_CONFIG=(remote_db_unique_name1,remote_db_unique_name2)';
alter system set LOG_ARCHIVE_CONFIG='NODG_CONFIG,RECEIVE,SEND';
alter system set LOG_ARCHIVE_CONFIG='SEND,RECEIVE,NODG_CONFIG';


--LOG_ARCHIVE_DEST_STATE_1
alter system set LOG_ARCHIVE_DEST_STATE_1=XXXX;

--LOG_ARCHIVE_MAX_PROCESSES
alter system set LOG_ARCHIVE_MAX_PROCESSES=XXXX;
alter system set LOG_ARCHIVE_MAX_PROCESSES=-1;

--LOG_ARCHIVE_MIN_SUCCEED_DEST
alter system set LOG_ARCHIVE_MIN_SUCCEED_DEST=XXXX;
alter system set LOG_ARCHIVE_MIN_SUCCEED_DEST=-1;

--LOG_ARCHIVE_TRACE
alter system set LOG_ARCHIVE_TRACE=XXXX;

--CHECKPOINT_TIMEOUT/CHECKPOINT_PERIOD
alter system set CHECKPOINT_TIMEOUT=XXXX;
alter system set CHECKPOINT_TIMEOUT=0;
alter system set CHECKPOINT_PERIOD=400; 
show parameter CHECKPOINT_PERIOD;
alter system set CHECKPOINT_PERIOD=300;
show parameter CHECKPOINT_PERIOD;

--CHECKPOINT_INTERVAL/CHECKPOINT_PAGES
alter system set CHECKPOINT_INTERVAL=XXXX;
alter system set CHECKPOINT_INTERVAL=0;
alter system set CHECKPOINT_PAGES=50000; 
show parameter CHECKPOINT_PAGES;
alter system set CHECKPOINT_PAGES=100000;
show parameter CHECKPOINT_PAGES;

--CHECKPOINT_IO_CAPACITY
alter system set CHECKPOINT_IO_CAPACITY=XXXX;
alter system set CHECKPOINT_IO_CAPACITY=0;

--_CHECKPOINT_MERGE_IO
alter system set _CHECKPOINT_MERGE_IO=FALSE;
SELECT * FROM V$PARAMETER WHERE NAME = '_CHECKPOINT_MERGE_IO';

--TIMED_STATISTICS
alter system set TIMED_STATISTICS=XXXX;

--STATISTICS_LEVEL
alter system set STATISTICS_LEVEL=XXXX;
select * from v$parameter where name = 'STATISTICS_LEVEL';

--DBWR_PROCESSES
alter system set DBWR_PROCESSES=XXXX;
alter system set DBWR_PROCESSES=0;

--SQL_STAT
alter system set SQL_STAT=XXXX;

--REPL_ADDR
alter system set REPL_ADDR=127.0.0.1;
alter system set REPL_ADDR='127.0.0.1';
alter system set REPL_ADDR=127;
alter system set REPL_ADDR='127';
alter system set REPL_ADDR=',127.0.0.1';
alter system set REPL_ADDR=', 127.0.0.1';
alter system set REPL_ADDR='-1.0.0.1';
alter system set REPL_ADDR='0.0.0.0,0.0.0.256';
alter system set REPL_ADDR='127.0.0.1,';
alter system set REPL_ADDR='127.0.0.1, ';
alter system set REPL_ADDR='127.0.0.1,255';
alter system set REPL_ADDR='';
alter system set REPL_ADDR='1.1.1.1,,2.2.2.2';
alter system set REPL_ADDR='1.1.1.2, ,2.2.2.3';
alter system set REPL_ADDR='1.1.1.1,2.2.2.2,3.3.3.3,4.4.4.4,5.5.5.5,6.6.6.6,7.7.7.7,8.8.8.8,9.9.9.9';
alter system set REPL_ADDR='1.1.1.1,2.2.2.2,3.3.3.3,4.4.4.4,5.5.5.5,6.6.6.6,7.7.7.7,8.8.8.8,9.9.9.9,10.10.10.10';
alter system set REPL_ADDR='1.1.1.1,2.2.2.2,3.3.3.3,4.4.4.4,5.5.5.5,6.6.6.6,7.7.7.7,8.8.8.8,9.9.9.9,10.10.10.101';

--REPL_PORT
alter system set REPL_PORT=XXXX;
alter system set REPL_PORT=65536;
alter system set REPL_PORT=1023;
alter system set REPL_PORT=0;
select * from v$parameter where name = 'REPL_PORT';

--FILESYSTEMIO_OPTIONS
alter system set FILESYSTEMIO_OPTIONS=XXXX;
alter system set FILESYSTEMIO_OPTIONS=DIRECTIO;
alter system set FILESYSTEMIO_OPTIONS=FULLDIRECTIO;
alter system set FILESYSTEMIO_OPTIONS=ASYNCH;
alter system set FILESYSTEMIO_OPTIONS=SETALL;
alter system set FILESYSTEMIO_OPTIONS=NONE;

--_ENCRYPTION_ALG
alter system set _ENCRYPTION_ALG=XXXX;
alter system set _ENCRYPTION_ALG=HMAC_SHA256;
alter system set _ENCRYPTION_ALG=PBKDF2;
alter system set _ENCRYPTION_ALG=SCRAM_SHA256;
alter system set _ENCRYPTION_ITERATION=XXX;
alter system set _ENCRYPTION_ITERATION=999;
alter system set _ENCRYPTION_ITERATION=10000001;
alter system set _ENCRYPTION_ITERATION=2000;

--_SYS_PASSWORD
ALTER SYSTEM SET _SYS_PASSWORD='';
ALTER SYSTEM SET _SYS_PASSWORD='XXX';
ALTER SYSTEM SET _SYS_PASSWORD='aKLPCRgGSV65x2YJQPWgwDbLao+M4QB2X8BSG2khVRFavF4hdgPuCPSjYHmL/BNi';
ALTER SYSTEM SET _SYS_PASSWORD='thuMmQYA0AcykVYBVtuBJRxecJ3in8XVsZb2sHORAgOqnCrPOTvm7VYtv3RoPbWMKRduMKrHZ3dlCVih0o0at1KvH7t8VZHLGpa+n1kJlTP6iLrYGRNBXA==';
ALTER SYSTEM SET _SYS_PASSWORD = 'pkAqfAUA0AdWc/O/W13ODhC9+5o+V1fWhXHm1kGv7z79S/GQyydsJFnLix8jBrY43bdNMsPJmYfwziCSpxgASC3Hi+3eq+C4lsCxy5dDimVWGWTGNfwpfA==';

--AUDIT_LEVEL
alter system set AUDIT_LEVEL=XXXX;

--_LOG_BACKUP_FILE_COUNT
alter system set _LOG_BACKUP_FILE_COUNT=XXXX;
alter system set _LOG_BACKUP_FILE_COUNT=1027;

--_LOG_MAX_FILE_SIZE
alter system set _LOG_MAX_FILE_SIZE=XXXX;

--_LOG_LEVEL
alter system set _LOG_LEVEL=XXXX;
--max _log_level=887
alter system set _LOG_LEVEL=888;


--_LOG_FILE_PERMISSIONS
alter system set _LOG_FILE_PERMISSIONS=XXXX;
alter system set _LOG_FILE_PERMISSIONS=65536;
alter system set _LOG_FILE_PERMISSIONS=687;

--_LOG_PATH_PERMISSIONS
alter system set _LOG_PATH_PERMISSIONS=XXXX;
alter system set _LOG_PATH_PERMISSIONS=65536;
alter system set _LOG_PATH_PERMISSIONS=789;

-UNDO_RETENTION_TIME
alter system set UNDO_RETENTION_TIME=XXXX;

--_UNDO_SEGMENTS
alter system set _UNDO_SEGMENTS=XXXX;

--REPL_WAIT_TIMEOUT
alter system set REPL_WAIT_TIMEOUT=XXXX;
alter system set REPL_WAIT_TIMEOUT=2;

--COMMIT_ON_DISCONNECT
alter system set COMMIT_ON_DISCONNECT=XXXX;

--_MAX_CONNECT_BY_LEVEL
alter system set _MAX_CONNECT_BY_LEVEL=XXXX;

--TCP_VALID_NODE_CHECKING
alter system set TCP_VALID_NODE_CHECKING=XXXX;

--_MAX_VM_FUNC_STACK_COUNT
ALTER SYSTEM SET _MAX_VM_FUNC_STACK_COUNT = 10000;
SHOW PARAMETER _MAX_VM_FUNC_STACK_COUNT;

--AUDIT_LEVEL
ALTER SYSTEM SET AUDIT_LEVEL = 2+2;
SELECT NAME, VALUE, RUNTIME_VALUE FROM V$PARAMETER WHERE NAME = 'AUDIT_LEVEL';
ALTER SYSTEM SET AUDIT_LEVEL = 255;
SELECT * FROM V$PARAMETER WHERE NAME = 'AUDIT_LEVEL';

--_LOG_LEVEL
ALTER SYSTEM SET _LOG_LEVEL = 255;
SELECT * FROM V$PARAMETER WHERE NAME = '_LOG_LEVEL';

--_LOG_MAX_FILE_SIZE
ALTER SYSTEM SET _LOG_MAX_FILE_SIZE = 100;
ALTER SYSTEM SET _LOG_MAX_FILE_SIZE = 3G;
SELECT * FROM V$PARAMETER WHERE NAME = '_LOG_MAX_FILE_SIZE';

--_LOG_BACKUP_FILE_COUNT
ALTER SYSTEM SET _LOG_BACKUP_FILE_COUNT = 2;
SELECT * FROM V$PARAMETER WHERE NAME = '_LOG_BACKUP_FILE_COUNT';

--_LOG_FILE_PERMISSIONS
ALTER SYSTEM SET _LOG_FILE_PERMISSIONS = 640;
SELECT * FROM V$PARAMETER WHERE NAME = '_LOG_FILE_PERMISSIONS';

--_LOG_PATH_PERMISSIONS
ALTER SYSTEM SET _LOG_PATH_PERMISSIONS = 750;
SELECT * FROM V$PARAMETER WHERE NAME = '_LOG_PATH_PERMISSIONS';

--_MAX_CONNECT_BY_LEVEL
ALTER SYSTEM SET _MAX_CONNECT_BY_LEVEL = 256;
SELECT * FROM V$PARAMETER WHERE NAME = '_MAX_CONNECT_BY_LEVEL';

--_ENABLE_QOS
alter system set _ENABLE_QOS = TRUE;
SELECT * FROM V$PARAMETER WHERE NAME = '_ENABLE_QOS';
alter system set _ENABLE_QOS = FALSE;
SELECT * FROM V$PARAMETER WHERE NAME = '_ENABLE_QOS';

--USE_NATIVE_DATATYPE
alter system set USE_NATIVE_DATATYPE = FALSE;
SELECT * FROM V$PARAMETER WHERE NAME = 'USE_NATIVE_DATATYPE';
alter system set USE_NATIVE_DATATYPE = TRUE;
SELECT * FROM V$PARAMETER WHERE NAME = 'USE_NATIVE_DATATYPE';

--_QOS_CTRL_FACTOR
ALTER SYSTEM SET _QOS_CTRL_FACTOR = 0.8;
SELECT * FROM V$PARAMETER WHERE NAME = '_QOS_CTRL_FACTOR';
ALTER SYSTEM SET _QOS_CTRL_FACTOR = 0.75;
SELECT * FROM V$PARAMETER WHERE NAME = '_QOS_CTRL_FACTOR';

--_QOS_SLEEP_TIME
ALTER SYSTEM SET _QOS_SLEEP_TIME = 25;
SELECT * FROM V$PARAMETER WHERE NAME = '_QOS_SLEEP_TIME';
ALTER SYSTEM SET _QOS_SLEEP_TIME = 20;
SELECT * FROM V$PARAMETER WHERE NAME = '_QOS_SLEEP_TIME';

--_QOS_RANDOM_RANGE
ALTER SYSTEM SET _QOS_RANDOM_RANGE = 64;
SELECT * FROM V$PARAMETER WHERE NAME = '_QOS_RANDOM_RANGE';

--_DISABLE_SOFT_PARSE
ALTER SYSTEM SET _DISABLE_SOFT_PARSE = TRUE;
SELECT * FROM V$PARAMETER WHERE NAME = '_DISABLE_SOFT_PARSE';
--
begin
null;
end;
/
ALTER SYSTEM SET _DISABLE_SOFT_PARSE = FALSE;
SELECT * FROM V$PARAMETER WHERE NAME = '_DISABLE_SOFT_PARSE';

--LOG_ARCHIVE_DEST_1
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1 = 'LOCATION=CTDB_HOME/archive_log/archive_log/archive_log/archive_log/archive_log/archive_log/archive_log/archive_log/archive_log/archive_log';
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1 = 'LOCATION=CTDB_HOME/archive_log!';
show parameter ARCHIVE_DEST_10;

--LOG_ARCHIVE_DEST_2
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2 = '';
SELECT * FROM V$PARAMETER WHERE NAME = 'LOG_ARCHIVE_DEST_2';

--LOG_ARCHIVE_DEST_STATE_2
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2 = DEFER;
SELECT * FROM V$PARAMETER WHERE NAME = 'LOG_ARCHIVE_DEST_STATE_2';
SELECT SLEEP(1);
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2 = ALTERNATE;
SELECT * FROM V$PARAMETER WHERE NAME = 'LOG_ARCHIVE_DEST_STATE_2';
SELECT SLEEP(1);
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2 = ENABLE;
SELECT * FROM V$PARAMETER WHERE NAME = 'LOG_ARCHIVE_DEST_STATE_2';

--LOG_ARCHIVE_FORMAT
ALTER SYSTEM SET LOG_ARCHIVE_FORMAT = 'ARCH_%T_%S_%R.ARC';
SELECT * FROM V$PARAMETER WHERE NAME = 'LOG_ARCHIVE_FORMAT';
alter system set LOG_ARCHIVE_FORMAT = 'cantiandb_archive_log_cantiandb_archive_log_cantiandb_archive_log_cantiandb_archive_log_archive_%r_%s.arc';
alter system set LOG_ARCHIVE_FORMAT = 'arch_%r_%s_%s.arc';
alter system set LOG_ARCHIVE_FORMAT = 'arch_%r_%s_%t_%t.arc';
alter system set LOG_ARCHIVE_FORMAT = 'arch_%r_%s_%r.arc';
alter system set LOG_ARCHIVE_FORMAT = 'arch_%r_%s_%m.arc';
alter system set LOG_ARCHIVE_FORMAT = 'arch_%r.arc';

--LOG_ARCHIVE_MAX_PROCESSES
ALTER SYSTEM SET LOG_ARCHIVE_MAX_PROCESSES = 2;
SELECT * FROM V$PARAMETER WHERE NAME = 'LOG_ARCHIVE_MAX_PROCESSES';

--LOG_ARCHIVE_MIN_SUCCEED_DEST
ALTER SYSTEM SET LOG_ARCHIVE_MIN_SUCCEED_DEST = 1;
SELECT * FROM V$PARAMETER WHERE NAME = 'LOG_ARCHIVE_MIN_SUCCEED_DEST';

--LOG_ARCHIVE_TRACE
ALTER SYSTEM SET LOG_ARCHIVE_TRACE = 0;
SELECT * FROM V$PARAMETER WHERE NAME = 'LOG_ARCHIVE_TRACE';

--TIMED_STATISTICS
ALTER SYSTEM SET TIMED_STATISTICS = FALSE;
SELECT * FROM V$PARAMETER WHERE NAME = 'TIMED_STATISTICS';
ALTER SYSTEM SET TIMED_STATISTICS = TRUE;
SELECT * FROM V$PARAMETER WHERE NAME = 'TIMED_STATISTICS';

--COMMIT_ON_DISCONNECT
ALTER SYSTEM SET COMMIT_ON_DISCONNECT = TRUE;
SELECT * FROM V$PARAMETER WHERE NAME = 'COMMIT_ON_DISCONNECT';
ALTER SYSTEM SET COMMIT_ON_DISCONNECT = FALSE;
SELECT * FROM V$PARAMETER WHERE NAME = 'COMMIT_ON_DISCONNECT';

--LONGSQL_TIMEOUT
ALTER SYSTEM SET LONGSQL_TIMEOUT = 0.001;
SELECT * FROM V$PARAMETER WHERE NAME = 'LONGSQL_TIMEOUT';

alter system kill session '0,1';
alter system kill session '0,   1';
alter system kill session '';
alter system kill session ',';
alter system kill session '+,';
alter system kill session '+0,';
alter system kill session '+0,-';
alter system kill session '+0,-1';
alter system kill session '+0,+1,';
alter system dump datafile 0 page 1 xxx;
ALTER SYSTEM SET AUDIT_LEVEL = 255 scope = memory;
ALTER SYSTEM SET AUDIT_LEVEL = 255 scope = pfile;
ALTER SYSTEM SET AUDIT_LEVEL = 255 scope = both;
alter system reset statistic;

--dts DTS2018051405550
create user hzy identified by '123#adsfaea';
drop table if exists hzy.ttt;
create table hzy.ttt (a int);
alter system load dictionary for hzy.ttt;
drop table if exists hzy.ttt;
purge recyclebin;
drop user hzy;

--max_allowed_packet [96K, 64M]
alter system set max_allowed_packet=64K;
alter system set max_allowed_packet=96K;
alter system set max_allowed_packet=1M;
alter system set max_allowed_packet=64M;
alter system set max_allowed_packet=65M;
alter system set max_allowed_packet=1M;

--max_arch_files_size (0,-)
alter system set MAX_ARCH_FILES_SIZE = 0;
SELECT * FROM V$PARAMETER WHERE NAME = 'MAX_ARCH_FILES_SIZE';
alter system set MAX_ARCH_FILES_SIZE = 16K;
SELECT * FROM V$PARAMETER WHERE NAME = 'MAX_ARCH_FILES_SIZE';
alter system set MAX_ARCH_FILES_SIZE = 50G;
SELECT * FROM V$PARAMETER WHERE NAME = 'MAX_ARCH_FILES_SIZE';
alter system set MAX_ARCH_FILES_SIZE = 16M;
SELECT * FROM V$PARAMETER WHERE NAME = 'MAX_ARCH_FILES_SIZE';
alter system set MAX_ARCH_FILES_SIZE = 32M;
SELECT * FROM V$PARAMETER WHERE NAME = 'MAX_ARCH_FILES_SIZE';
alter system set MAX_ARCH_FILES_SIZE = 1K;
SELECT * FROM V$PARAMETER WHERE NAME = 'MAX_ARCH_FILES_SIZE';

--checkpoint
alter system checkpoint;
alter system checkpoint local;
alter system checkpoint global;

alter system checkpoint ssss;

--local_key
alter system set local_key = 'WUoTN4Y2a5jSdgBy3MHKUA==';
--SELECT * FROM V$PARAMETER WHERE NAME = 'LOCAL_KEY';

--invalid folder path
ALTER SYSTEM SET ALARM_LOG_DIR = '';
ALTER SYSTEM SET LOG_HOME = '';
ALTER SYSTEM SET LOG_HOME = '/home/database/log/111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';

--sql_stat
alter system set sql_stat = false scope = pfile;
alter system set sql_stat = true scope = pfile;

--ssl file
alter system set ssl_ca = 'ca.pem' scope = both;
alter system set ssl_cert = 'server-cert.pem';
--log_level
alter system set ENABLE_IDX_CONFS_NAME_DUPL = true;
SELECT VALUE,DEFAULT_VALUE FROM V$PARAMETER WHERE NAME = 'ENABLE_IDX_CONFS_NAME_DUPL';
alter system set ENABLE_IDX_CONFS_NAME_DUPL = false;
SELECT  VALUE,DEFAULT_VALUE FROM V$PARAMETER WHERE NAME = 'ENABLE_IDX_CONFS_NAME_DUPL';


--DTS2018122005821  DTS2018122000332  DTS2018122007550
alter system set  _BLACKBOX_STACK_DEPTH =0;
alter system set AUDIT_LEVEL=80000;
alter system set AUDIT_LEVEL=15;
alter system set AUDIT_LEVEL=0;
alter system set LOG_BUFFER_COUNT=0;
alter system set LOG_BUFFER_COUNT=1;
alter system set LOG_BUFFER_COUNT=16;
alter system set MERGE_SORT_BATCH_SIZE=0;
alter system set MERGE_SORT_BATCH_SIZE=100000;
alter system set _QOS_CTRL_FACTOR=0;
alter system set _QOS_CTRL_FACTOR=6;
alter system set _QOS_CTRL_FACTOR=-1;
alter system set _QOS_SLEEP_TIME=0;
alter system set _QOS_RANDOM_RANGE=0;

--DTS2019010302673 DTS2019010302830 
alter system set MAX_ARCH_FILES_SIZE=9007199254740992k;
alter system set _LOG_MAX_FILE_SIZE =9007199254740992k;
alter system set MAX_ARCH_FILES_SIZE=8796093022208m;
alter system set _LOG_MAX_FILE_SIZE =8796093022208m;
alter system set MAX_ARCH_FILES_SIZE=8589934592g;
alter system set _LOG_MAX_FILE_SIZE =8589934592g;
alter system set MAX_ARCH_FILES_SIZE=8388608t;
alter system set _LOG_MAX_FILE_SIZE =8388608t;
alter system set MAX_ARCH_FILES_SIZE=8192p;
alter system set _LOG_MAX_FILE_SIZE =8192p;
alter system set MAX_ARCH_FILES_SIZE=8e;
alter system set _LOG_MAX_FILE_SIZE =8e;
alter system set MAX_ARCH_FILES_SIZE=9223372036854775808;
alter system set _LOG_MAX_FILE_SIZE =9223372036854775808;


--security checkout for ip white list function
--init ip white list  config  
alter system set TCP_VALID_NODE_CHECKING = false;
alter system set TCP_INVITED_NODES = '';
alter system set TCP_EXCLUDED_NODES = '';

---error
alter system set TCP_VALID_NODE_CHECKING = true;

---success
alter system set TCP_INVITED_NODES = '192.168.222.222';
alter system set TCP_VALID_NODE_CHECKING = true;

---error
alter system set TCP_INVITED_NODES = '';

---success
alter system set TCP_VALID_NODE_CHECKING = false;
alter system set TCP_INVITED_NODES = '';
alter system set TCP_EXCLUDED_NODES = '192.168.222.222';
alter system set TCP_VALID_NODE_CHECKING = true;

---error
alter system set TCP_EXCLUDED_NODES = '';

---success
alter system set TCP_VALID_NODE_CHECKING = false;
alter system set TCP_EXCLUDED_NODES = '';

ALTER system set STATISTICS_SAMPLE_SIZE = 1M;
ALTER system set STATISTICS_SAMPLE_SIZE = 1K;
ALTER system set STATISTICS_SAMPLE_SIZE = 23M;
ALTER system set STATISTICS_SAMPLE_SIZE = 512M;
ALTER system set STATISTICS_SAMPLE_SIZE = 1G;
select * from v$parameter where name = 'STATISTICS_SAMPLE_SIZE';

ALTER system set _SQL_CURSORS_EACH_SESSION = 301;
ALTER system set _RESERVED_SQL_CURSORS = 1001;
ALTER system set _RESERVED_SQL_CURSORS = 79;

--DTS2019013108399 --DTS2019090307501
ALTER system set REACTOR_THREADS = 10000;
ALTER system set REACTOR_THREADS = 10001;
ALTER system set REACTOR_THREADS = 1;
ALTER system set OPTIMIZED_WORKER_THREADS = 10000;
ALTER system set OPTIMIZED_WORKER_THREADS = 10001;
ALTER system set OPTIMIZED_WORKER_THREADS = 100;
select * from v$parameter where name = 'REACTOR_THREADS';
select * from v$parameter where name = 'OPTIMIZED_WORKER_THREADS';
select * from v$parameter where name = 'MAX_WORKER_THREADS';

--DTS2019102809305
--error
ALTER system set MAX_WORKER_THREADS = 99;
ALTER system set OPTIMIZED_WORKER_THREADS = 101;
ALTER system set MAX_WORKER_THREADS = 10001;
--ok
ALTER system set MAX_WORKER_THREADS = 10000;
ALTER system set OPTIMIZED_WORKER_THREADS = 10000;
select * from v$parameter where name = 'OPTIMIZED_WORKER_THREADS';
select * from v$parameter where name = 'MAX_WORKER_THREADS';
ALTER system set MAX_WORKER_THREADS = 100;
ALTER system set OPTIMIZED_WORKER_THREADS = 100;
ALTER system set MAX_WORKER_THREADS = 100;

--_AUTO_INDEX_RECYCLE
alter system set _AUTO_INDEX_RECYCLE = OFF;
select * from v$parameter where name = '_AUTO_INDEX_RECYCLE';
alter system set _AUTO_INDEX_RECYCLE = ON;
select * from v$parameter where name = '_AUTO_INDEX_RECYCLE';

--_LNS_WAIT_TIME
alter system set _LNS_WAIT_TIME = -1;
alter system set _LNS_WAIT_TIME = 0;
alter system set _LNS_WAIT_TIME = 1000;
alter system set _LNS_WAIT_TIME = 3;

--_TX_ROLLBACK_PROC_NUM
alter system set _TX_ROLLBACK_PROC_NUM = 0;
alter system set _TX_ROLLBACK_PROC_NUM = 3;
--log_replay_processes
alter system set LOG_REPLAY_PROCESSES = 0;
alter system set LOG_REPLAY_PROCESSES = 129;
alter system set LOG_REPLAY_PROCESSES = 8;
select * from v$parameter where name = '_PRIVATE_KEY_LOCKS';
select * from v$parameter where name = '_PRIVATE_ROW_LOCKS';
ALTER system set _PRIVATE_ROW_LOCKS = 128;
ALTER system set _PRIVATE_KEY_LOCKS = 128;
ALTER system set _PRIVATE_ROW_LOCKS = 300;
ALTER system set _PRIVATE_KEY_LOCKS = 300;
select * from v$parameter where name = '_PRIVATE_KEY_LOCKS';
select * from v$parameter where name = '_PRIVATE_ROW_LOCKS';
ALTER system set _PRIVATE_ROW_LOCKS = 8;
ALTER system set _PRIVATE_KEY_LOCKS = 8;

--RAFT_PRIORITY_LEVEL
alter system set RAFT_PRIORITY_LEVEL = '+000';
select value from v$parameter where name = 'RAFT_PRIORITY_LEVEL';

--RAFT_PENDING_CMDS_BUFFER_SIZE
alter system set RAFT_PENDING_CMDS_BUFFER_SIZE = '0';
select * from v$parameter where name = 'RAFT_PENDING_CMDS_BUFFER_SIZE';
alter system set RAFT_PENDING_CMDS_BUFFER_SIZE = '+01000';
select value from v$parameter where name = 'RAFT_PENDING_CMDS_BUFFER_SIZE';

--RAFT_SEND_BUFFER_SIZE
alter system set RAFT_SEND_BUFFER_SIZE = '0';
alter system set RAFT_SEND_BUFFER_SIZE = '10001';
select * from v$parameter where name = 'RAFT_SEND_BUFFER_SIZE';
alter system set RAFT_SEND_BUFFER_SIZE = '+0100';
select value from v$parameter where name = 'RAFT_SEND_BUFFER_SIZE';

--RAFT_RECEIVE_BUFFER_SIZE
alter system set RAFT_RECEIVE_BUFFER_SIZE = '0';
alter system set RAFT_RECEIVE_BUFFER_SIZE = '10001';
select * from v$parameter where name = 'RAFT_RECEIVE_BUFFER_SIZE';
alter system set RAFT_RECEIVE_BUFFER_SIZE = '+0100';
select value from v$parameter where name = 'RAFT_RECEIVE_BUFFER_SIZE';

--RAFT_RAFT_ENTRY_CACHE_MEMORY_SIZE
alter system set RAFT_RAFT_ENTRY_CACHE_MEMORY_SIZE = '0';
select * from v$parameter where name = 'RAFT_RAFT_ENTRY_CACHE_MEMORY_SIZE';
alter system set RAFT_RAFT_ENTRY_CACHE_MEMORY_SIZE = 4G;
select value from v$parameter where name = 'RAFT_RAFT_ENTRY_CACHE_MEMORY_SIZE';

--RAFT_MAX_SIZE_PER_MSG
alter system set RAFT_MAX_SIZE_PER_MSG = '67108863';
select * from v$parameter where name = 'RAFT_MAX_SIZE_PER_MSG';
alter system set RAFT_MAX_SIZE_PER_MSG = 256M;
select value from v$parameter where name = 'RAFT_MAX_SIZE_PER_MSG';

--RAFT_FAILOVER_LIB_TIMEOUT
alter system set RAFT_FAILOVER_LIB_TIMEOUT = 4;
alter system set RAFT_FAILOVER_LIB_TIMEOUT = 4294967296;
alter system set RAFT_FAILOVER_LIB_TIMEOUT = 15;
select * from dv_parameters where name = 'RAFT_FAILOVER_LIB_TIMEOUT';
alter system set RAFT_FAILOVER_LIB_TIMEOUT = 10;
select * from dv_parameters where name = 'RAFT_FAILOVER_LIB_TIMEOUT';
alter system set RAFT_FAILOVER_LIB_TIMEOUT = 600;

--auto block repair
ALTER SYSTEM SET BLOCK_REPAIR_ENABLE = FALSE;
ALTER SYSTEM SET BLOCK_REPAIR_ENABLE = TRUE;

ALTER SYSTEM SET BLOCK_REPAIR_TIMEOUT = 0;
ALTER SYSTEM SET BLOCK_REPAIR_TIMEOUT = -1;
ALTER SYSTEM SET BLOCK_REPAIR_TIMEOUT = 3601;
ALTER SYSTEM SET BLOCK_REPAIR_TIMEOUT = 3600;
ALTER SYSTEM SET BLOCK_REPAIR_TIMEOUT = 1;
ALTER SYSTEM SET BLOCK_REPAIR_TIMEOUT = 60;

--quorum any n
ALTER SYSTEM SET QUORUM_ANY = -1;
ALTER SYSTEM SET QUORUM_ANY = 0;
ALTER SYSTEM SET QUORUM_ANY = 1;

--test empty string
ALTER SYSTEM SET _LNS_WAIT_TIME = ' ';
ALTER SYSTEM SET _LNS_WAIT_TIME = '  ';
ALTER SYSTEM SET _LNS_WAIT_TIME = " ";
ALTER SYSTEM SET _LNS_WAIT_TIME = "  ";
ALTER SYSTEM SET _LNS_WAIT_TIME = ` `;
ALTER SYSTEM SET _LNS_WAIT_TIME = `  `;

--alter system add/delete lsnr_addr
alter system add lsnr_addr 1.1.1.1;
alter system delete lsnr_addr 1.1.1.1;
alter system add lsnr_addr 100;
alter system delete lsnr_addr 100;
alter system add lsnr_addr "127.0.0.255";
alter system delete lsnr_addr "127.0.0.255";
alter system add lsnr_addr ::1;
alter system delete lsnr_addr ::1;
alter system add lsnr_addr '::1';
conn sys/Huawei@123@::1:1611
select OS_HOST,client_ip from DV_ME;
alter system delete lsnr_addr '::1';

CONNECT sys/Huawei@123@127.0.0.1:1611
alter system set OPEN_CURSORS = 0;
alter system set OPEN_CURSORS = 16385;
alter  system set _FACTOR_KEY = "dc4hoQWGQs7/Uv3AiherFw==";
alter system set ARCHIVE_DEST_1 = 'all_roles';
alter system set ARCHIVE_DEST_1 = 'noaffirm';
alter system set ARCHIVE_DEST_1 = 'arch';
alter system set ARCHIVE_DEST_1 = 'async';
alter  system set LOCAL_KEY = "UTiYlBoTC71MvTyBvWhVDodc0VAop1GMe135ZCov8Pv4xsnlEHn9Bs/pjRo7ZNM1BXq8Z4XuyRjfaNpY/7McEQ==";
alter  system set LOCAL_KEY = "UTiYlBoTC71MvTyBvWhVDodc0VAop1GMe135ZCov8Pv4xsnlEHn9Bs/pjRo7ZNM1BXq8Z4XuyRjfaNpY/7McEQ=y";

--alter sysem dump datafile DTS2019052313948(core if row >500)
create tablespace DTS2019052313948 datafile 'DTS2019052313948' size 16m autoextend on next 16M;
create table DTS2019052313948(a int)tablespace DTS2019052313948; 
insert into DTS2019052313948 values(123456789);
insert into DTS2019052313948 values(987654321);
insert into DTS2019052313948 select * from DTS2019052313948; 
insert into DTS2019052313948 select * from DTS2019052313948; 
insert into DTS2019052313948 select * from DTS2019052313948; 
insert into DTS2019052313948 select * from DTS2019052313948; 
insert into DTS2019052313948 select * from DTS2019052313948; 
insert into DTS2019052313948 select * from DTS2019052313948; 
insert into DTS2019052313948 select * from DTS2019052313948; 
insert into DTS2019052313948 select * from DTS2019052313948; 
insert into DTS2019052313948 select * from DTS2019052313948; 
insert into DTS2019052313948 select * from DTS2019052313948; 

CREATE OR REPLACE PROCEDURE P_DUMP_DATAFIEL()
AS
    FILE_ID INT;
BEGIN
    SELECT ID INTO FILE_ID FROM DV_DATA_FILES WHERE FILE_NAME LIKE '%DTS2019052313948';
    EXECUTE IMMEDIATE 'ALTER SYSTEM DUMP DATAFILE '||FILE_ID||' PAGE 4';
END;
/

CALL P_DUMP_DATAFIEL;
DROP TABLESPACE DTS2019052313948 INCLUDING CONTENTS AND DATAFILES;
DROP PROCEDURE P_DUMP_DATAFIEL;

--alter system flush redo
ALTER SYSTEM FLUSH REDO TO shsnc_standby;

CONNECT sys/Huawei@123@UDS
--ALTER UDS_FILE_PATH
ALTER SYSTEM SET UDS_FILE_PATH = '/proc/sys/kernel/core_pattern';
ALTER SYSTEM SET UDS_FILE_PATH = '/proc/sys/kernel/core_pattern_123476klasjdgflksjdglksdjflkgjsdlkfjglksdjfglksdjfgklsdjfglksdjfglksjdfgklasdfasdf';
SELECT * FROM V$PARAMETER where name = 'UDS_FILE_PATH';

--ALTER UDS_FILE_PERMISSIONS
ALTER SYSTEM SET UDS_FILE_PERMISSIONS = XXXX;
ALTER SYSTEM SET UDS_FILE_PERMISSIONS = 65536;
alter system set UDS_FILE_PERMISSIONS=687;
alter system set UDS_FILE_PERMISSIONS=600;
SELECT * FROM V$PARAMETER where name = 'UDS_FILE_PERMISSIONS';

CONNECT sys/Huawei@123@127.0.0.1:1611

--ALTER _SGA_CORE_DUMP_CONFIG
ALTER SYSTEM SET _SGA_CORE_DUMP_CONFIG = 16383;--REMOVE ALL SGA 
ALTER SYSTEM SET _SGA_CORE_DUMP_CONFIG = 1; --REMOVE DATA BUFFER
ALTER SYSTEM SET _SGA_CORE_DUMP_CONFIG = 0; --CLOSE CORE_DUMP CONFIG 
--DTS2019070202150--DTS2019070311925
set UDS_SERVER_PATH=/home/pr/a/
set UDS_SERVER_PATH=/home/pr/a!b
set UDS_SERVER_PATH=/home/pr/a/b
alter system set UDS_FILE_PATH='/temp/w/';
alter system set UDS_FILE_PATH='/temp/w/a';
alter system set UDS_FILE_PATH='/temp/w/a;b';
alter system set UDS_FILE_PATH='/proc/sys/kernel/con';

--ALTER SYSTEM SET XA_FORMAT_ID
show parameter XA_FORMAT_ID
ALTER SYSTEM SET XA_FORMAT_ID = 1024;

--ALTER SHARD_SERIAL_EXECUTION
alter system set SHARD_SERIAL_EXECUTION=TRUE;
select value from v$parameter where name = 'SHARD_SERIAL_EXECUTION';
show parameter SHARD_SERIAL_EXECUTION;
alter system set SHARD_SERIAL_EXECUTION=FALSE;
select * from v$parameter where name = 'SHARD_SERIAL_EXECUTION';
show parameter SHARD_SERIAL_EXECUTION;
alter system set SHARD_SERIAL_EXECUTION=XXX;

--ALTER SHARD_CHECK_UNIQUE
alter system set SHARD_CHECK_UNIQUE=TRUE;
select value from v$parameter where name = 'SHARD_CHECK_UNIQUE';
show parameter SHARD_CHECK_UNIQUE;
alter system set SHARD_CHECK_UNIQUE=FALSE;
select * from v$parameter where name = 'SHARD_CHECK_UNIQUE';
show parameter SHARD_CHECK_UNIQUE;
alter system set SHARD_CHECK_UNIQUE=XXX;

alter system set UDS_FILE_PATH='/home/ ';
alter system set UDS_FILE_PATH='/home/ c';
alter system set UDS_FILE_PATH='      ';
alter system set UDS_FILE_PATH='/ ';

--special char
alter system set UDS_FILE_PATH='	';
alter system set UDS_FILE_PATH='%';
alter system set UDS_FILE_PATH='.';
alter system set UDS_FILE_PATH='a.txt';
alter system set UDS_FILE_PATH='b	';
alter system set UDS_FILE_PATH='b%';
alter system set UDS_FILE_PATH='	b';
alter system set UDS_FILE_PATH='%b';
alter system set UDS_FILE_PATH='/';
set UDS_CLIENT_PATH=.
set UDS_SERVER_PATH=.
set UDS_CLIENT_PATH=b.
set UDS_SERVER_PATH=b.
set UDS_CLIENT_PATH=.b
set UDS_SERVER_PATH=.b

-- hba config
alter system add hba entry ;
alter system add hba ss 'sd';
alter system add lsnr;
alter system add lsnr_addr ;
alter system add lsnr_addr 'sfsf';
alter system delete lsnr_addr 'sfsf';
alter system delete lsnr 'sfsf';

--DTS2019082308685
alter system set MAX_COLUMN_COUNT=1024;

--Users outside sys cannot modify the following parameters
conn / as sysdba
create user user_test_alter_system identified by Cantian_234;
grant create session,alter system to user_test_alter_system;
conn user_test_alter_system/Cantian_234@127.0.0.1:1611
alter system set ENABLE_ACCESS_DC=false scope=pfile;
alter system set ENABLE_SYSDBA_LOGIN=true scope=pfile;
alter system set ENABLE_SYSDBA_REMOTE_LOGIN=false scope=pfile;
alter system set ENABLE_SYS_REMOTE_LOGIN=false scope=pfile;
conn / as sysdba
drop user user_test_alter_system;

--ddl_lock_timeout
alter system set DDL_LOCK_TIMEOUT = 0;
alter system set DDL_LOCK_TIMEOUT = -1;
alter system set DDL_LOCK_TIMEOUT = 1000000;
alter system set DDL_LOCK_TIMEOUT = 1000001;
alter system set DDL_LOCK_TIMEOUT = XXX;
alter system set DDL_LOCK_TIMEOUT = 30;
select * from v$parameter where name = 'DDL_LOCK_TIMEOUT';

--replication
ALTER SYSTEM SET REPLICATION ON '127.0.0.1:13579';
ALTER SYSTEM SET REPLICATION OFF;

ALTER SYSTEM SET INI_TRANS = 0;
ALTER SYSTEM SET INI_TRANS = 256;

--init lock pool pages
alter system set INIT_LOCK_POOL_PAGES=127;
alter system set INIT_LOCK_POOL_PAGES=128;
alter system set INIT_LOCK_POOL_PAGES=32768;
alter system set INIT_LOCK_POOL_PAGES=32769;
alter system recycle;
alter system recycle sharedpool;
alter system recycle sharedpool force;

-- test audit_syslog_level 
alter system set audit_syslog_level = LOCAL0.DEBUG;
alter system set audit_syslog_level = 'LOCAL0.DEBUG';
alter system set audit_syslog_level = 'LOCAL34.DEBUG';
alter system set audit_syslog_level = 'LOCAL0.DEBYG5';
alter system set audit_syslog_level = 'LOCAL5.NOTICE';
alter system set audit_syslog_level = 'LOCAL0.DEBUG';

--test alter uds_file_path
alter system set UDS_FILE_PATH = '' scope=PFILE;
alter system set UDS_FILE_PATH = 'afdasfasdfasfaesdgsgdsagdsfdsfadfadfafadfadfadfaFSDFADSFASDFadfjdfakhdafsjkdasfhasdfhkjfdsahdsahdasfhfhlafsd' scope=PFILE;

--nbu_backup_timeout
alter system set NBU_BACKUP_TIMEOUT = -1;
alter system set NBU_BACKUP_TIMEOUT = 0;
alter system set NBU_BACKUP_TIMEOUT = 60;
show parameter NBU_BACKUP_TIMEOUT;
alter system set NBU_BACKUP_TIMEOUT = 90;

alter system set segment_pages_hold = 128;
drop table if exists seg_cache;
create table seg_cache(a int, b int);
insert into seg_cache values(1, 3);
select * from seg_cache t1 join seg_cache t2 on t1.a = t2.a;
explain select * from seg_cache t1 join seg_cache t2 on t1.a = t2.a;
alter system set segment_pages_hold = 0;
drop table seg_cache;
--20210316
ALTER SYSTEM LOAD DICTIONARY FOR education sadsads;
ALTER SYSTEM INIT DICTIONARY sdsds;
alter system recycle sharedpool sadsdf;

select name,VALUE,RANGE,DATATYPE from DV_PARAMETERS where name in ('GLOBAL_SEQUENCE_CACHE_SIZE','_PENDING_TRANS_CLEAN_INTERVAL','_VMP_CACHES_EACH_SESSION','_PREFETCH_ROWS','_MAX_CONNECT_BY_LEVEL','_MAX_VM_FUNC_STACK_COUNT','MERGE_SORT_BATCH_SIZE','INTERACTIVE_TIMEOUT','UNAUTH_SESSION_EXPIRE_TIME','MAX_SQL_MAP_PER_USER') order by name;
select name,VALUE,RANGE,DATATYPE from DV_PARAMETERS where name in ('BUFFER_PAGE_CLEAN_PERIOD','_SPIN_COUNT','_QOS_SLEEP_TIME','_QOS_RANDOM_RANGE','CHECKPOINT_PERIOD','CHECKPOINT_TIMEOUT','CHECKPOINT_PAGES','CHECKPOINT_INTERVAL','TC_LEVEL','UNDO_RETENTION_TIME','NBU_BACKUP_TIMEOUT','LOCK_WAIT_TIMEOUT','_LNS_WAIT_TIME','STATS_COST_LIMIT','STATS_COST_DELAY','MASTER_SLAVE_DIFFTIME');

--DTS202103230NE19PP1H00
alter system set _LOG_LEVEL_MODE=FATAL;
select name, value from dv_parameters where name= '_LOG_LEVEL';
alter system set _LOG_LEVEL_MODE=DEBUG;
select name, value from dv_parameters where name= '_LOG_LEVEL';

--DTS202105180FMVV1P1400
alter system set _TABLE_COMPRESS_BUFFER_SIZE = 16M;
alter system set _TABLE_COMPRESS_BUFFER_SIZE = 256M;
alter system set _TABLE_COMPRESS_BUFFER_SIZE = 512M;
alter system set _TABLE_COMPRESS_BUFFER_SIZE = 1G;
alter system set _TABLE_COMPRESS_BUFFER_SIZE = 15M;
alter system set _TABLE_COMPRESS_BUFFER_SIZE = 2G;

--ARCH_CLEAN_UPPER_LIMIT,ARCH_CLEAN_LOWER_LIMIT
alter system set ARCH_CLEAN_UPPER_LIMIT = 0;
alter system set ARCH_CLEAN_UPPER_LIMIT = 101;
alter system set ARCH_CLEAN_LOWER_LIMIT = -1;
alter system set ARCH_CLEAN_LOWER_LIMIT = 101;
alter system set ARCH_CLEAN_LOWER_LIMIT = 0;
alter system set ARCH_CLEAN_UPPER_LIMIT = 1;
alter system set ARCH_CLEAN_LOWER_LIMIT = 15;
alter system set ARCH_CLEAN_UPPER_LIMIT = 100;
alter system set ARCH_CLEAN_LOWER_LIMIT = 100;
alter system set ARCH_CLEAN_UPPER_LIMIT = 85;
alter system set ARCH_CLEAN_LOWER_LIMIT = 15;
show parameter ARCH_CLEAN_LOWER_LIMIT;
alter system set ARCH_CLEAN_UPPER_LIMIT = 85;
show parameter ARCH_CLEAN_UPPER_LIMIT;

show parameter SSL_PERIOD_DETECTION
alter system set SSL_PERIOD_DETECTION = 0;
alter system set SSL_PERIOD_DETECTION = 181;
alter system set SSL_PERIOD_DETECTION = 1;
alter system set SSL_PERIOD_DETECTION = 1.5;
alter system set SSL_PERIOD_DETECTION = 180;
alter system set SSL_PERIOD_DETECTION = 7;
show parameter SSL_PERIOD_DETECTION