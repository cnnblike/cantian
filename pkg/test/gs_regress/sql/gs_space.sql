SET SERVEROUTPUT ON;

--create tablespace
create tablespace spc_test_1;                                                                                                   --error datafile expected 
create tablespace longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglongname  datafile 'spc_file_11' size 32M;    --error space name length excceed max
create tablespace spc_test_1 datafile 'spc_file_11';                                                                            --error datafile size expected 
create tablespace spc_test_1 datafile 'spc_file_11' size 32M, 'spc_file_12' size 1M, 'spc_file_13' size 31M;                   --succeed
create tablespace spc_test_1 datafile 'spc_file_14' size 32M, 'spc_file_15' size 1M, 'spc_file_16' size 31M;                   --error duplicate creation of space
create tablespace spc_test_2 datafile 'spc_file_21' size 100B;                                                                   --error file size less than least
create tablespace spc_test_2 datafile 'spc_file_21' size 9T;                                                                    --error file size more than max
create tablespace spc_test_2 datafile 'spc_file_21' size 32M autoextend on next 16M maxsize 9T;                                 --error autoextend_maxsize more than max
create tablespace spc_test_2 datafile 'spc_file_21' size 32M autoextend on next 128M maxsize 64M;                               --error autoextend_maxsize less than autoextend_size
create tablespace spc_test_2 datafile 'spc_file_21' size 32M autoextend off;                                                    --succeed
create tablespace spc_test_3 datafile 'spc_file_31' size 32M autoextend on maxsize 31G;                                         --succeed
create tablespace spc_test_4 datafile 'spc_file_41' size 32M autoextend on next 16M maxsize 31G;                                --succeed
create tablespace spc_test_5 datafile 'spc_file_51' size 32M autoextend off, 'spc_file_52' size 32M autoextend on next 16M maxsize 31G;  --succeed
create tablespace spc_test_6 datafile 'spc_file_61' size 32M all in memory;                                                     --error all in memory not support yet
create tablespace spc_test_6 datafile 'spc_file_61' size 100M reuse autoextend on next 20M maxsize 30G;                         --succeed
create tablespace spc_test_7 datafile 'spc_file_71' size 100M autoextend on next maxsize;                                       --autoextend synatx error
create tablespace spc_test_7 datafile 'spc_file_71' size 100M autoextend off maxsize 30G;                                       --autoextend synatx error
create tablespace spc_test_7 datafile 'spc_file_71' size 32M autoextend on next 20M maxsize 30G reuse;                          --autoextend synatx error
create tablespace spc_test_7 datafile 'spc_file_71' reuse size 32M autoextend on next 20M maxsize 30G;                          --autoextend synatx error
create tablespace spc_test_7 datafile 'spc_file_71' size 100M autoextend off maxsize 30G;                                       --autoextend synatx error
create tablespace spc_test_7 datafile 'spc_file_71' size 32M autoextend on next maxsize 30G;                                    --autoextend synatx error
select NAME, STATUS, AUTO_PURGE, EXTENT_SIZE, FILE_COUNT from v$tablespace where name like 'SPC_TEST%';
select substr(FILE_NAME,-11), BYTES, AUTO_EXTEND, AUTO_EXTEND_SIZE, MAX_SIZE from v$datafile where file_name like '%spc_file%';

--use table on tablespace
create table spc_test_table (id int) tablespace spc_test_1;                                                                     --succeed
insert into spc_test_table values(1);                                                                                           --succeed
insert into spc_test_table values(2);                                                                                           --succeed
select * from spc_test_table;                                                                                                   --tow rows    

--tablespace autopurge
purge tablespace spc_test_1;                                                                                                    --succeed
alter tablespace spc_test_1 autopurge off;                                                                                      --succeed    
alter tablespace spc_test_1 autopurge on;                                                                                       --succeed
alter tablespace spc_test_1 autopurge abc;                                                                                      --synatx error
alter tablespace spc_test_1 autopurge;                                                                                          --synatx error
select NAME, STATUS, AUTO_PURGE, EXTENT_SIZE, FILE_COUNT from v$tablespace where name like 'SPC_TEST%';

--rename tablespace
alter tablespace spc_test_0 rename to spc_test_7;                                                                              --error space not exists
alter tablespace spc_test_1 rename to spc_test_2;                                                                              --error duplicate name
alter tablespace spc_test_1 rename;                                                                                             --synatx error 
alter tablespace spc_test_1 rename to;                                                                                          --synatx error
alter tablespace spc_test_1 rename to longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglongname                  --error space name length excceed max
alter tablespace spc_test_1 rename to spc_test_20;                                                                              --succeed
select NAME, STATUS, AUTO_PURGE, EXTENT_SIZE, FILE_COUNT from v$tablespace where name like 'SPC_TEST%';

--add datafile
alter tablespace spc_test_8 add datafile 'spc_file_81' size 32M autoextend on next 16M;                                         --error space not exists 
alter tablespace spc_test_2 add datafile 'spc_file_21' size 32M autoextend off, 'SPC_FILE_21' size 32M autoextend off;          --error duplicate datafile
alter tablespace spc_test_2 add ;                                                                                               --synatx error
alter tablespace spc_test_2 add datafile;                                                                                       --synatx error
alter tablespace spc_test_2 add datafile 'spc_file_22';                                                                         --synatx error
alter tablespace spc_test_2 add datafile 'spc_file_22' size 32M autoextend on next 16M, 'spc_file_23' size 32M autoextend off;  --succedd
select substr(FILE_NAME,-11), BYTES, AUTO_EXTEND, AUTO_EXTEND_SIZE, MAX_SIZE from v$datafile where file_name like '%spc_file%';

--drop datafile
alter tablespace spc_test_7 drop datafile 'spc_file_11';                                                                        --error datafile has been used
alter tablespace spc_test_2 drop datafile 'spc_file_22', 'spc_file_31', 'spc_file_41';                                          --synatx
alter tablespace spc_test_2 drop datafile 'spc_file_22';                                                                        --succeed
select substr(FILE_NAME,-11), BYTES, AUTO_EXTEND, AUTO_EXTEND_SIZE, MAX_SIZE from v$datafile where file_name like '%spc_file%';

--rename or offline datafile
alter tablespace spc_test_5 rename datafile 'spc_file_51' to 'spc_file_81';                                                     --error must be mounted EXCLUSIVE 
alter tablespace spc_test_5 offline datafile 'spc_file_51';                                                                     --error must be mounted EXCLUSIVE
select substr(FILE_NAME,-11), BYTES, AUTO_EXTEND, AUTO_EXTEND_SIZE, MAX_SIZE from v$datafile where file_name like '%spc_file%';

--tablespace autoextend
alter tablespace spc_test_6 autoextend;                                                                                         --synatx error
alter tablespace spc_test_6 autoextend off;                                                                                     --succeed 
alter tablespace spc_test_6 autoextend on next 32M maxsize 16M;                                                                 --error next size more than maxsize
alter tablespace spc_test_6 autoextend on next 32M maxsize 9T;                                                                  --error maxsize excceed max

--alter database datafile
alter database datafile;                                                                                                         --synatx error
alter database datafile abc;                                                                                                     --synatx error
alter database datafile 'spc_file_81' offline;                                                                                   --synatx error
alter database datafile 'spc_file_81' autoextend;                                                                                --error datafile not exists
alter database datafile 'spc_file_31' autoextend;                                                                                --synatx error
alter database datafile 'spc_file_31' autoextend off;                                                                            --succeed
alter database datafile 'spc_file_31' autoextend on next 32M maxsize 16M;                                                        --error next size more than maxsize
alter database datafile 'spc_file_31' autoextend on maxsize 9T;                                                                  --error maxsize excceed max
alter database datafile 'spc_file_31' autoextend on next 9T maxsize 9T;                                                          --error next size excceed max
alter database datafile 'spc_file_31' autoextend on;                                                                             --succeed
alter database datafile 'spc_file_31' autoextend on next 32M maxsize 32G;                                                        --succeed
select substr(FILE_NAME,-11), BYTES, AUTO_EXTEND, AUTO_EXTEND_SIZE, MAX_SIZE from v$datafile where file_name like '%spc_file%';

--issue #24222
create tablespace tablespace_test_01 datafile 'datafile_extend_01' size 32M autoextend on next 4M maxsize 100M;
create tablespace tablespace_test_02 datafile 'datafile_extend_02' size 32M autoextend on next 4M; 
alter database datafile 'datafile_extend_01' autoextend off;
alter tablespace tablespace_test_02 autoextend off;
select substr(FILE_NAME,-18), BYTES, AUTO_EXTEND, AUTO_EXTEND_SIZE, MAX_SIZE from v$datafile where file_name like '%datafile_extend%';


--online drop tablespace
create tablespace tsp1 datafile  'tsp_11.dbf' size 32M autoextend on next 32M, 'tsp_12.dbf' size 32M autoextend on next 32M;
create tablespace tsp2 datafile  'tsp_21.dbf' size 32M autoextend on next 32M, 'tsp_22.dbf' size 32M autoextend on next 32M;
create tablespace tsp3 datafile  'tsp_31.dbf' size 32M autoextend on next 32M, 'tsp_32.dbf' size 32M autoextend on next 32M;
create table tbsp_t1(f1 int,f2 char(30))
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10) tablespace tsp1,
 PARTITION p2 values less than(MAXVALUE) tablespace tsp2
) tablespace tsp2;
insert into tbsp_t1 values (1,'aa');
insert into tbsp_t1 values (21,'bb');
commit;
create table tbsp_t2(id int, name clob)  lob (name) store as( tablespace tsp1);
drop tablespace tsp1;
--drop tablespace tsp1 including contents;
drop tablespace tsp2;
drop tablespace tsp2 including contents;
--drop tablespace tsp1 including contents;
drop table tbsp_t2;
drop tablespace tsp1 including contents;

--online drop tablepsace : check index
create tablespace spc_test_10 datafile 'spc_10_file' size 32M;
create tablespace spc_test_11 datafile 'spc_11_file' size 32M;
create table spc_test_10_table (a int) tablespace spc_test_10;
create index spc_test_10_table_index on spc_test_10_table(a) tablespace spc_test_11;
drop tablespace spc_test_11 including contents; 

--online drop tablespace: check lob
create table spc_test_11_table(id int, name clob)  lob (name) store as( tablespace spc_test_10) tablespace spc_test_11;
drop tablespace spc_test_10 including contents;

--online drop tablespace: check table partition 
create table spc_test_12_table(f1 int,f2 char(30), f3 clob)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10) tablespace spc_test_10,
 PARTITION p2 values less than(MAXVALUE) tablespace spc_test_11
) tablespace spc_test_11;
drop tablespace spc_test_10 including contents;

--online drop tablespace: check index partition 
create tablespace spc_test_13 datafile 'spc_13_file' size 32M;
create tablespace spc_test_14 datafile 'spc_14_file' size 32M;
create index spc_test_13_index on spc_test_12_table(f1) local
(
partition p3 tablespace spc_test_13, 
partition p4 tablespace spc_test_14
);
drop tablespace spc_test_13 including contents;

--online drop tablespace: check index partition 
create tablespace spc_test_15 datafile 'spc_15_file' size 32M;
create tablespace spc_test_16 datafile 'spc_16_file' size 32M;
create table spc_test_15_table(f1 int,f2 char(30), f3 CLOB)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10) tablespace spc_test_15,
 PARTITION p2 values less than(MAXVALUE) tablespace spc_test_16
) tablespace spc_test_15;
drop tablespace spc_test_16 including contents;

--online drop tablespace: check part store
create tablespace spc_test_17 datafile 'spc_file_17' size 32M;
create tablespace spc_test_18 datafile 'spc_file_18' size 32M;
create table spc_test_17_table(f1 int, f2 int, f3 CLOB)
PARTITION BY RANGE(f2)
INTERVAL(10)
STORE IN(tablespace spc_test_17,tablespace spc_test_18)
(
 PARTITION spc_test_17 values less than(10),
 PARTITION spc_test_18 values less than(20),
);
drop tablespace spc_test_17 including contents;

create table tbsp_t3(id int, dep_id int, name varchar(32));
create table dep(id int primary key, dep_name varchar(32)) tablespace tsp3;
insert into dep values (1,'aa');
insert into dep values (2,'bb');
insert into dep values (3,'cc');
truncate table dep;
insert into dep values (4,'ee');
insert into dep values (5,'ff');
alter table tbsp_t3 add foreign key (dep_id) references dep(id) on delete cascade;
create user testwei identified by 'Cantian_234' default tablespace tsp3;
create table testwei.tbsp_t1(id int);

create table tb1_tsp3(id int) tablespace tsp3;
create table tb2_tsp3(id int) tablespace tsp3;
insert into tb1_tsp3 values (1);
drop table tb1_tsp3;
drop table tb2_tsp3;

drop tablespace tsp3;
drop tablespace tsp3 including contents;
drop table testwei.tbsp_t1 purge;
drop user testwei;

drop tablespace tsp3 including contents;
drop tablespace tsp3 including contents cascade constraints;

--bitmap tablespace
create tablespace normal_spc datafile 'normal_spc' size 1M;
create tablespace normal_spc_128 extents 128 datafile 'normal_spc_128' size 1M;
create tablespace bitmap_spc datafile 'bitmap_spc' size 1M extent autoallocate;

drop tablespace normal_spc including contents and datafiles;
drop tablespace normal_spc_128 including contents and datafiles;
drop tablespace bitmap_spc including contents and datafiles;

--DTS2018072411394
alter tablespace omspm3 add datafile 'omspm3_2.dbf' size 32M autoextend on maxsize 64M, 'omspm4_2.dbf' size 32M autoextend on next 16M maxsize 31M;         --syntax error
SELECT COUNT(ID) FROM V$DATAFILE WHERE FILE_NAME LIKE '%omspm3_2%';                                                                                         --count: 0
alter tablespace omspm3 add datafile 'omspm3_2.dbf' size 32M autoextend on next 16M;
SELECT COUNT(ID) FROM V$DATAFILE WHERE FILE_NAME LIKE '%omspm3_2%';                                                                                         --count: 1
alter tablespace omspm3 add datafile 'omspm4_2.dbf' size 32M autoextend off, 'omspm4_3.dbf' size 32M autoextend off, 'OMspm4_2.dbf' size 32M autoextend off;--syntax error
SELECT COUNT(ID) FROM V$DATAFILE WHERE FILE_NAME LIKE '%omspm4_2%';                                                                                         --count: 0
alter tablespace omspm3 add datafile 'omspm4_2.dbf' size 32M autoextend off;
SELECT COUNT(ID) FROM V$DATAFILE WHERE FILE_NAME LIKE '%omspm4_2%';                                                                                         --count: 1
alter tablespace omspm3 add datafile 'omspm4_2.dbf' size 32M autoextend on next 128M maxsize 64M;                                                           --syntax error
create tablespace omspm5 datafile 'omspm5.dbf' size 32M autoextend on maxsize 9T;                                                                           --syntax error (maxsize too large)
create tablespace omspm5 datafile 'omspm5.dbf' size 32M autoextend on maxsize 32M, 'omspm6.dbf' size 32M autoextend on maxsize 31M;                         --syntax error
SELECT COUNT(ID) FROM V$DATAFILE WHERE FILE_NAME LIKE '%omspm5%';                                                                                           --count: 0
create tablespace omspm5 datafile 'omspm5_1.dbf' size 32M autoextend on next 8M, 'omspm5_2.dbf' size 32M autoextend off;
SELECT COUNT(ID) FROM V$DATAFILE WHERE FILE_NAME LIKE '%omspm5%.dbf';                                                                                       --count: 2

alter tablespace omspm3 autoextend on maxsize 9T;                                                                                                           --syntax error (maxsize too large)
alter tablespace omspm3 add datafile 'omspm3_2.dbf' size 32M autoextend on maxsize 9T, 'omspm4_2.dbf' size 32M autoextend on maxsize 8G;                    --syntax error (maxsize too large)
alter tablespace undo add datafile 'undo2.dbf' size 128M autoextend on next 32M;
SELECT COUNT(ID) FROM V$DATAFILE WHERE FILE_NAME LIKE '%undo2.dbf%';    i                                                                                   -- count: 1
alter tablespace TMP_TBLSPC_001 autoextend on next;
alter tablespace TMP_TBLSPC_001 autoextend on MAXSIZE;
alter tablespace TMP_TBLSPC_001 autoextend on MAXSIZE 20G;

create tablespace tablespace_maxsize_002 datafile 'tablespace_maxsize_002_1' size 32M autoextend on next 1 maxsize 31M;                                     --syntax error. maxsize less than size
alter tablespace tablespace_maxsize_002 add datafile 'tablespace_maxsize_002_2' size 32M autoextend on  maxsize 16M;                                        --syntax error. maxsize less than size
create tablespace tablespace_maxsize_002 datafile 'tablespace_maxsize_002_1' size 40M autoextend on next 1 maxsize 80M;
alter tablespace tablespace_maxsize_002 add datafile 'tablespace_maxsize_002_2' size 50M autoextend on  maxsize 90M;
alter tablespace tablespace_maxsize_002 autoextend on maxsize 45M;                                                                           --syntax error. the new maxsize less than existing size
DECLARE
  undosql VARCHAR(256);
  BEGIN
  undosql := 'CREATE TABLESPACE tablespace_maxsize_003 DATAFILE ''tablespace_maxsize_003_1'' SIZE 40M AUTOEXTEND ON NEXT 1 MAXSIZE 80M';
  EXECUTE IMMEDIATE undosql;
  undosql := 'ALTER TABLESPACE tablespace_maxsize_003 ADD DATAFILE ''tablespace_maxsize_003_2'' SIZE 50M AUTOEXTEND ON MAXSIZE 90M';
  EXECUTE IMMEDIATE undosql;
  undosql := 'ALTER DATABASE DATAFILE ''tablespace_maxsize_003_1'', ''tablespace_maxsize_003_2'' AUTOEXTEND ON NEXT 40M MAXSIZE 45M';
  EXECUTE IMMEDIATE undosql;
  EXCEPTION
  WHEN OTHERS THEN    
  dbe_output.print_line(undosql || ' FAILED, error code: ' || SQL_ERR_CODE );
  END;
/
--DTS2018072308772
--use the procedure to test the error DDL so that the fullpath of the datafile would not be printed.
  BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLESPACE undo ADD DATAFILE ''undo3.dbf'' SIZE 128M AUTOEXTEND ON MAXSIZE 36G';
  EXCEPTION
  WHEN OTHERS THEN
  dbe_output.print_line('ALTER TABLESPACE failed, error code: ' || SQL_ERR_CODE );
  END;
  /
SELECT COUNT(ID) FROM V$DATAFILE WHERE FILE_NAME LIKE '%undo3.dbf%';      -- count: 0
  BEGIN
  EXECUTE IMMEDIATE 'ALTER DATABASE DATAFILE ''undo'' AUTOEXTEND ON MAXSIZE 36G';
  EXCEPTION
  WHEN OTHERS THEN
  dbe_output.print_line('ALTER DATABASE DATAFILE failed, error code: ' || SQL_ERR_CODE );
  END;
/

-- test create/alter user's default table space & temporary table space
create user user_test_space identified by Root1234 default tablespace temp; -- failed;
create user user_test_space identified by Root1234 temporary tablespace users; -- failed;

create user user_test_space identified by Root1234;
select username, default_tablespace, temporary_tablespace from dba_users where username=upper('user_test_space');

alter user user_test_space default tablespace system temporary tablespace TEMP;
-- test if the operation takes effect
select username, default_tablespace, temporary_tablespace from dba_users where username=upper('user_test_space');

-- create objects in space
create table user_test_space.tab_test_001 (f1 int);
create index user_test_space.ix_tab_test_001 on user_test_space.tab_test_001 (f1);
select owner, table_name, tablespace_name from dba_tables where owner=upper('user_test_space') and table_name=upper('tab_test_001');
select owner, index_name, tablespace_name from dba_indexes where owner=upper('user_test_space') and index_name=upper('ix_tab_test_001');

-- set error space
alter user user_test_space default tablespace TEMP; -- failed
alter user user_test_space temporary tablespace SYSTEM; -- failed

drop user user_test_space cascade;

-- try to permanent object in temporary space
drop table if exists test_tb;
create table test_tb(id int) partition by range(id)
(
partition p1 values less than(50) tablespace system,
partition p2 values less than(100) tablespace temp
);

drop table if exists test_tb;
create table test_tb(id int);
create index test_index on test_tb(id) tablespace temp;

drop table if exists test_tb;
create table test_tb(id int, video clob) lob(video) store as lob_segment tablespace temp;

drop table if exists test_tb;

-- DTS2018120508581---

create tablespace space_free_size_test datafile 'space_free_size_test_file' size 32M;
CREATE TABLE ROW_CHAIN_TABLE_2(ID INT,A VARCHAR(8000),B VARCHAR(8000),C CLOB,D CLOB) tablespace space_free_size_test;
INSERT INTO ROW_CHAIN_TABLE_2 VALUES(0,LPAD('A',8000,'A'),LPAD('B',8000,'B'),LPAD('C',8000,'C'),'D');
commit;
truncate table ROW_CHAIN_TABLE_2;
purge recyclebin;
select tablespace_name, sum(bytes) bytes from dba_free_space group by tablespace_name having tablespace_name='SPACE_FREE_SIZE_TEST';
select tablespace_name, total_size-used_size bytes from dba_tablespaces where tablespace_name='SPACE_FREE_SIZE_TEST';

-- extent 128
create tablespace spc1 extents 128 datafile 'spc_1_file' size 32M;
select name, extent_size, SEGMENT_COUNT, FILE_COUNT from v$tablespace where name='SPC1';
drop table if exists t1;
create table t1(id int, name varchar(8000)) tablespace spc1;
select SEGMENT_NAME, TABLESPACE_NAME, BYTES, PAGES, EXTENTS from user_segments where segment_name='T1';

CREATE or replace function space_func1(startall int,endall int) RETURN boolean as
i INT;
BEGIN
 if startall > endall then
  return false;
 else
  FOR i IN startall..endall LOOP
        insert into t1 values (i, lpad('0',8000,'0'));
  END LOOP;
  return true;
 end if;
END;
/
select space_func1(1,130);
select SEGMENT_NAME, TABLESPACE_NAME, BYTES, PAGES, EXTENTS from user_segments where segment_name='T1';
drop  tablespace spc1 including contents;
create tablespace spc1  datafile 'spc_1_file' size 32M;
select name, extent_size, SEGMENT_COUNT, FILE_COUNT from v$tablespace where name='SPC1';
drop  tablespace spc1 including contents;
alter system set default_extents=64;
create tablespace spc1  datafile 'spc_1_file' size 32M;
select name, extent_size, SEGMENT_COUNT, FILE_COUNT from v$tablespace where name='SPC1';
drop  tablespace spc1 including contents;
alter system set default_extents=1;
alter system set default_extents=30;
alter system set default_extents=32;

--DTS2019012504729 --
drop table if exists false_2;
create table false_2(A int,b int,g int,h int,d date);
create index index_false_1 on false_2(b,g);
CREATE TABLESPACE human_subsidies_2018 DATAFILE 'subsidies2018' SIZE 32M;
alter index index_false_1 on false_2 REBUILD online TABLESPACE human_subsidies_2018;
drop tablespace human_subsidies_2018 including contents and datafiles;

-- tablespace usage threshold --
alter system set TABLESPACE_USAGE_ALARM_THRESHOLD = 0;
alter system set TABLESPACE_USAGE_ALARM_THRESHOLD = 101;
alter system set TABLESPACE_USAGE_ALARM_THRESHOLD = 100;

-- DTS2019043001699 ----
create tablespace path_not_exists datafile '/path_not_exists/file' size 1M;
alter database datafile '/path_not_exists/file' autoextend on;

-- llt --
create tablespace set_tablespace_autooffline_on datafile 'autooffline' size 1M;
alter tablespace set_tablespace_autooffline_on autooffline on;
drop tablespace set_tablespace_autooffline_on including contents and datafiles;

-- DTS2019072612142
create tablespace nologging_extent_dynamic datafile ' nologging_extent_dynamic' size 1M extent autoallocate nologging;

-- DTS2019102212003
alter tablespace system rename to test_rename;
alter tablespace undo rename to test_rename;

-- DTS2019101001056
alter tablespace sysaux autooffline on;
alter tablespace system autooffline on;

CREATE undo TABLESPACE undo_2 DATAFILE 'undo_3' SIZE 2M REUSE AUTOEXTEND ON nologging;
CREATE undo TABLESPACE undo_3 DATAFILE 'undo_4' SIZE 2M EXTENT AUTOALLOCATE;
CREATE undo TABLESPACE undo_4 DATAFILE 'undo_4' SIZE 2M ENCRYPTION;
CREATE undo TABLESPACE undo_5 EXTENTS 8 DATAFILE 'undo_4' SIZE 2M;
CREATE undo TABLESPACE undo_2 EXTENTS 8 DATAFILE 'undo_3' SIZE 2M REUSE AUTOEXTEND ON nologging;

--DTS2020031607219
conn / as sysdba
DROP USER IF EXISTS CHAN;
create user chan identified by Cantian_234 PROFILE "DEFAULT" DEFAULT TABLESPACE system;

conn / as sysdba
CREATE TABLESPACE TABLESPACEE_1 DATAFILE 'dfile_tbs_1' SIZE 32M AUTOEXTEND ON NEXT 10M;
ALTER USER SYS DEFAULT TABLESPACE TABLESPACEE_1;
ALTER USER SYS DEFAULT TABLESPACE system;
DROP TABLESPACE TABLESPACEE_1 INCLUDING CONTENTS AND DATAFILES;

--DTS202008060HVUXFP0D00
create undo tablespace undo_new1 datafile 'undo_new1_1' size 128M, 'undo_new1_2' size 128M;
select STATUS,TYPE,BYTES,AUTO_EXTEND,AUTO_EXTEND_SIZE,MAX_SIZE,HIGH_WATER_MARK from dv_data_files where FILE_NAME like '%undo_new1%';
alter tablespace undo_new1 autoextend on maxsize 256M;
select STATUS,TYPE,BYTES,AUTO_EXTEND,AUTO_EXTEND_SIZE,MAX_SIZE,HIGH_WATER_MARK from dv_data_files where FILE_NAME like '%undo_new1%';
alter tablespace undo_new1 autoextend on next 5M;
select STATUS,TYPE,BYTES,AUTO_EXTEND,AUTO_EXTEND_SIZE,MAX_SIZE,HIGH_WATER_MARK from dv_data_files where FILE_NAME like '%undo_new1%';

drop tablespace undo_new1 INCLUDING CONTENTS AND DATAFILES;
create undo tablespace undo_new1 datafile 'undo_new1_1' size 128M, 'undo_new1_2' size 128M;
select STATUS,TYPE,BYTES,AUTO_EXTEND,AUTO_EXTEND_SIZE,MAX_SIZE,HIGH_WATER_MARK from dv_data_files where FILE_NAME like '%undo_new1%';
drop tablespace undo_new1 INCLUDING CONTENTS AND DATAFILES;

--DTS202009010PYVZDP0H00
create tablespace DTS202009010PYVZDP0H00 datafile 'DTS202009010PYVZDP0H00' size 20M EXTENT AUTOALLOCATE;
select TABLESPACE_NAME,TOTAL_SIZE/1024/1024,USED_SIZE/1024/1024 from adm_tablespaces where TABLESPACE_NAME='DTS202009010PYVZDP0H00';

set serveroutput on;
CREATE or replace procedure calc_free_space_DTS202009010PYVZDP0H00 () is
tid INT;
free int;
used int;
totle int;
result_size int;
BEGIN
SELECT ID INTO tid FROM dv_tablespaces where NAME='DTS202009010PYVZDP0H00';
SELECT TOTAL_SIZE, USED_SIZE INTO totle, used FROM adm_tablespaces where TABLESPACE_NAME='DTS202009010PYVZDP0H00';
select sum(BYTES) into free from table(dba_free_space(tid));
DBE_OUTPUT.PRINT_LINE('expected free is ' || (totle-used));
DBE_OUTPUT.PRINT_LINE('calc result is ' || (totle-free-used));
DBE_OUTPUT.PRINT_LINE('free szie is ' || free);
end;
/

create table dts_reuse(a int)tablespace DTS202009010PYVZDP0H00;
insert into dts_reuse values(1);
insert into dts_reuse select * from dts_reuse;
insert into dts_reuse select * from dts_reuse;
insert into dts_reuse select * from dts_reuse;
insert into dts_reuse select * from dts_reuse;
insert into dts_reuse select * from dts_reuse;
insert into dts_reuse select * from dts_reuse;
insert into dts_reuse select * from dts_reuse;
insert into dts_reuse select * from dts_reuse;
insert into dts_reuse select * from dts_reuse;
insert into dts_reuse select * from dts_reuse;
insert into dts_reuse select * from dts_reuse;
insert into dts_reuse select * from dts_reuse;
insert into dts_reuse select * from dts_reuse;
truncate table dts_reuse reuse storage;
call calc_free_space_DTS202009010PYVZDP0H00();
create table func_free_space tablespace DTS202009010PYVZDP0H00 as select * from dts_reuse;
insert into dts_reuse values(1);
insert into dts_reuse select * from dts_reuse;
insert into dts_reuse select * from dts_reuse;
insert into dts_reuse select * from dts_reuse;
insert into dts_reuse select * from dts_reuse;
drop table dts_reuse purge;
select sleep(2);

call calc_free_space_DTS202009010PYVZDP0H00();
select TABLESPACE_NAME,TOTAL_SIZE/1024/1024,USED_SIZE/1024/1024 from adm_tablespaces where TABLESPACE_NAME='DTS202009010PYVZDP0H00';
drop tablespace DTS202009010PYVZDP0H00 INCLUDING CONTENTS AND DATAFILES;

--func dba_free_space
select TABLESPACE_NAME,FILE_ID from table(dba_free_space(0)) limit 1;
select TABLESPACE_NAME,FILE_ID from table(dba_free_space(1)) limit 1;
select TABLESPACE_NAME,FILE_ID from table(dba_free_space(2)) limit 1;
select TABLESPACE_NAME,FILE_ID from table(dba_free_space(3)) limit 1;
select TABLESPACE_NAME,FILE_ID from table(dba_free_space(4)) limit 1;
select TABLESPACE_NAME,FILE_ID from table(dba_free_space(5)) limit 1;
select TABLESPACE_NAME,FILE_ID from table(dba_free_space(6)) limit 1;

-- normal
create tablespace FUNC_FREE_SPACE datafile 'func_free_space' size 1040k;
create table t_free_space(a int, b varchar(30), c varchar(30)) tablespace FUNC_FREE_SPACE;

CREATE or replace procedure insert_t_free_space(num int) is
i int;
begin
  for i in 1 .. num loop
    insert into t_free_space values(i, 'jjjjjjjjjjjjjjjjjjjjjjjjjjjjjj', 'jjjjjjjjjjjjjjjjjjjjjjjjjjjjjj');
  end loop;
end;
/

CREATE or replace procedure calc_free_space_FUNC_FREE_SPACE () is
tid INT;
free int;
used int;
totle int;
result_size int;
BEGIN
SELECT ID INTO tid FROM dv_tablespaces where NAME='FUNC_FREE_SPACE';
SELECT TOTAL_SIZE, USED_SIZE INTO totle, used FROM adm_tablespaces where TABLESPACE_NAME='FUNC_FREE_SPACE';
select sum(BYTES) into free from table(dba_free_space(tid));
DBE_OUTPUT.PRINT_LINE('expected free is ' || (totle-used));
DBE_OUTPUT.PRINT_LINE('calc result is ' || (totle-free-used));
DBE_OUTPUT.PRINT_LINE('free size is ' || free);
end;
/

call calc_free_space_FUNC_FREE_SPACE();
call insert_t_free_space(10000);
call calc_free_space_FUNC_FREE_SPACE();
call insert_t_free_space(1200);
call calc_free_space_FUNC_FREE_SPACE();

alter tablespace FUNC_FREE_SPACE add datafile 'func_free_space2' size 1032k;
call calc_free_space_FUNC_FREE_SPACE();
call insert_t_free_space(10000);
call calc_free_space_FUNC_FREE_SPACE();
drop tablespace FUNC_FREE_SPACE INCLUDING CONTENTS AND DATAFILES;

-- bitmap
create tablespace FUNC_FREE_SPACE datafile 'func_free_space' size 2M, 'func_free_space2' size 3M EXTENT AUTOALLOCATE;
create table t_free_space(a int, b varchar(30), c varchar(30)) tablespace FUNC_FREE_SPACE;

call calc_free_space_FUNC_FREE_SPACE();
call insert_t_free_space(20000);
call calc_free_space_FUNC_FREE_SPACE();
call insert_t_free_space(10000);
call calc_free_space_FUNC_FREE_SPACE();
call calc_free_space_FUNC_FREE_SPACE();
alter tablespace FUNC_FREE_SPACE add datafile 'func_free_space3' size 2M;
call insert_t_free_space(10000);
call calc_free_space_FUNC_FREE_SPACE();

drop tablespace FUNC_FREE_SPACE INCLUDING CONTENTS AND DATAFILES;

-- resize datafile
alter database datafile 'system' resize 127M;
alter database datafile 'sysaux' resize 127M;
alter database datafile 'undo' resize 127M;

-- shrink space
alter tablespace system shrink space keep 127M;
alter tablespace sysaux shrink space keep 127M;
alter tablespace undo shrink space keep 127M;

-- add datafile
alter tablespace system add datafile 'system2' size 127M;
alter tablespace sysaux add datafile 'sysaux2' size 127M;
alter tablespace undo add datafile 'undo2' size 127M;

-- create space
create undo tablespace undo2 datafile 'undo2_1' size 127M;

---punch space
alter tablespace undo punch;
create tablespace PUNCH_SPACE datafile 'p_space' size 32M, 'p_space2' size 32M AUTOEXTEND ON NEXT 10M;
alter tablespace PUNCH_SPACE punch;
drop tablespace PUNCH_SPACE INCLUDING CONTENTS AND DATAFILES;
create tablespace PUNCH_SPACE datafile 'p_space' size 32M, 'p_space2' size 32M AUTOEXTEND ON NEXT 10M EXTENT AUTOALLOCATE;
alter tablespace PUNCH_SPACE punch 1s;
alter tablespace PUNCH_SPACE punch size;
alter tablespace PUNCH_SPACE punch size 10g;
drop tablespace PUNCH_SPACE INCLUDING CONTENTS AND DATAFILES;

--DTS202105210JDNJ0P0J00
SELECT DBE_DIAGNOSE.DBA_SPCSIZE(600,'PAGE');

conn / as sysdba
drop user if exists test_space cascade;
create user test_space identified by Cantian_234;
grant resource, connect to test_space;
conn test_space/Cantian_234@127.0.0.1:1611
-- create table
create table sys_tab_t1(id int, score int) tablespace system;
create table sys_tab_t2(id int, score int) tablespace sysaux;

CREATE TABLE T_CHECK_FAILED_2
(
    sn     NUMBER(38),   
    num    int,
    PRIMARY KEY ( sn ) using index tablespace system
);

CREATE TABLE T01(C1 INT, C2 CLOB) LOB(C2) STORE AS (TABLESPACE system);

-- create part table
CREATE TABLE test_sys_part(ID INT, C1 INT)
PARTITION BY RANGE (ID)
(
PARTITION P1 VALUES LESS THAN (10),
PARTITION P2 VALUES LESS THAN (maxvalue)
) TABLESPACE system;

-- hash part
drop table if exists test_hash_tab;
create table test_hash_tab (
c1 char(20) primary key,
c2 number(8) not null
)
partition by hash(c1)
(
partition part_01,
partition part_02 tablespace sysaux,
partition part_03 tablespace system
);

-- range part
DROP TABLE IF EXISTS TEST_INTREVAL_ALL_PART_STORE;
create table TEST_INTREVAL_ALL_PART_STORE
( EMPNO VARCHAR2(20) NOT NULL,
EMPNAME VARCHAR2(20),
JOB VARCHAR2(20),
MGR NUMBER(38),
HIREDATE DATE,
SALARY NUMBER(38),
DEPTNO NUMBER(38))
PARTITION BY RANGE (HIREDATE)
INTERVAL (NUMTODSINTERVAL(1,'DAY'))
STORE IN(tablespace users, tablespace system)
(PARTITION ALL_PART_STORE_PART01
VALUES LESS THAN (TO_DATE ('02/02/1981', 'MM/DD/YYYY')),
PARTITION ALL_PART_STORE_PART02
VALUES LESS THAN (TO_DATE ('03/02/1981', 'MM/DD/YYYY'))
);

-- subpart
drop table if exists test_subpart_space;
create table test_subpart_space(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50) tablespace system,
subpartition p12 values less than(100) tablespace system
),
partition p2 values less than(100) 
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
),
partition p3 values less than(150)
(
subpartition p31 values less than(50),
subpartition p32 values less than(100)
)
);


-- add part
drop table if exists test_hash_tab;
create table test_hash_tab (
c1 char(20) primary key,
c2 number(8) not null
)
partition by hash(c1)
(
partition part_01,
partition part_02,
partition part_03
);

alter table test_hash_tab add partition part_04 tablespace SYSTEM;

-- add subpart
drop table if exists test_add_subpart;
create table test_add_subpart(id int) PARTITION BY RANGE(ID) INTERVAL(50) SUBPARTITION BY RANGE(id)
(
PARTITION P1 VALUES LESS THAN(50)
(
SUBPARTITION p11 VALUES LESS THAN (2),
SUBPARTITION p12 VALUES LESS THAN (4),
SUBPARTITION P13 VALUES LESS THAN (6)
)
);

alter table test_add_subpart modify partition p1 add subpartition p14 values less than(8) tablespace SYSTEM;

-- index
drop table if exists T81;
CREATE TABLE T81(C1 INT, C2 INT);
CREATE INDEX I81 ON T81(C1) TABLESPACE system;
CREATE INDEX I82 ON T81(C2) TABLESPACE sysaux;
ALTER TABLE T81 ADD CONSTRAINT CONS UNIQUE(C2) USING INDEX TABLESPACE system;

conn / as sysdba
drop user if exists test_space cascade;
create user test_space identified by Cantian_234;
grant resource, connect to test_space;
grant use any tablespace to test_space;
conn test_space/Cantian_234@127.0.0.1:1611
-- create table
create table sys_tab_t1(id int, score int) tablespace system;
create table sys_tab_t2(id int, score int) tablespace sysaux;

CREATE TABLE T_CHECK_FAILED_2
(
    sn     NUMBER(38),   
    num    int,
    PRIMARY KEY ( sn ) using index tablespace system
);

CREATE TABLE T01(C1 INT, C2 CLOB) LOB(C2) STORE AS (TABLESPACE system);

-- create part table
CREATE TABLE test_sys_part(ID INT, C1 INT)
PARTITION BY RANGE (ID)
(
PARTITION P1 VALUES LESS THAN (10),
PARTITION P2 VALUES LESS THAN (maxvalue)
) TABLESPACE system;

-- hash part
drop table if exists test_hash_tab;
create table test_hash_tab (
c1 char(20) primary key,
c2 number(8) not null
)
partition by hash(c1)
(
partition part_01,
partition part_02 tablespace sysaux,
partition part_03 tablespace system
);

-- range part
DROP TABLE IF EXISTS TEST_INTREVAL_ALL_PART_STORE;
create table TEST_INTREVAL_ALL_PART_STORE
( EMPNO VARCHAR2(20) NOT NULL,
EMPNAME VARCHAR2(20),
JOB VARCHAR2(20),
MGR NUMBER(38),
HIREDATE DATE,
SALARY NUMBER(38),
DEPTNO NUMBER(38))
PARTITION BY RANGE (HIREDATE)
INTERVAL (NUMTODSINTERVAL(1,'DAY'))
STORE IN(tablespace users, tablespace system)
(PARTITION ALL_PART_STORE_PART01
VALUES LESS THAN (TO_DATE ('02/02/1981', 'MM/DD/YYYY')),
PARTITION ALL_PART_STORE_PART02
VALUES LESS THAN (TO_DATE ('03/02/1981', 'MM/DD/YYYY'))
);

-- subpart
drop table if exists test_subpart_space;
create table test_subpart_space(id int, c_id int, name varchar(20)) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50) tablespace system,
subpartition p12 values less than(100) tablespace system
),
partition p2 values less than(100) 
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
),
partition p3 values less than(150)
(
subpartition p31 values less than(50),
subpartition p32 values less than(100)
)
);


-- add part
drop table if exists test_hash_tab;
create table test_hash_tab (
c1 char(20) primary key,
c2 number(8) not null
)
partition by hash(c1)
(
partition part_01,
partition part_02,
partition part_03
);

alter table test_hash_tab add partition part_04 tablespace SYSTEM;

-- add subpart
drop table if exists test_add_subpart;
create table test_add_subpart(id int) PARTITION BY RANGE(ID) INTERVAL(50) SUBPARTITION BY RANGE(id)
(
PARTITION P1 VALUES LESS THAN(50)
(
SUBPARTITION p11 VALUES LESS THAN (2),
SUBPARTITION p12 VALUES LESS THAN (4),
SUBPARTITION P13 VALUES LESS THAN (6)
)
);

alter table test_add_subpart modify partition p1 add subpartition p14 values less than(8) tablespace SYSTEM;

-- index
drop table if exists T81;
CREATE TABLE T81(C1 INT, C2 INT);
CREATE INDEX I81 ON T81(C1) TABLESPACE system;
CREATE INDEX I82 ON T81(C2) TABLESPACE sysaux;
ALTER TABLE T81 ADD CONSTRAINT CONS UNIQUE(C2) USING INDEX TABLESPACE system;
conn / as sysdba
drop user if exists test_space cascade;

-- datafile_count
create tablespace datafile_count_space datafile 'datafile_count_1' size 32M;
alter tablespace datafile_count_space add datafile 'datafile_count_2' size 32M;
select name, file_count from dv_tablespaces where name = 'DATAFILE_COUNT_SPACE';
alter tablespace datafile_count_space drop datafile 'datafile_count_2';
select name, file_count from dv_tablespaces where name = 'DATAFILE_COUNT_SPACE';