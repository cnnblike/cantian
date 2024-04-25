drop table if exists gs_tbl_as_test;
create table gs_tbl_as_test(a int, b int);
select * from table(dba_analyze_table('SYS','GS_TBL_AS_TEST'));
explain select * from table(dba_analyze_table('SYS','GS_TBL_AS_TEST'));
explain select * from table(get_tab_parallel('GS_TBL_AS_TEST', 10));
explain select * from table(get_tab_rows('GS_TBL_AS_TEST', -1, 'NULL', 12345667, 12234, 12236));
explain select * from table(parallel_scan('GS_TBL_AS_TEST',2243199784128513, -3689573981838376956, 4393751543808, 18153656));

select * from table(dba_analyze_table('SYS',(select 'GS_TBL_AS_TEST' from dual)));
explain select * from table(dba_analyze_table('SYS',(select 'GS_TBL_AS_TEST' from dual)));
select STAT_ITEM from table(dba_analyze_table('SYS','GS_TBL_AS_TEST'));
explain select STAT_ITEM from table(dba_analyze_table('SYS','GS_TBL_AS_TEST'));
select f1.STAT_ITEM from table(dba_analyze_table('SYS','GS_TBL_AS_TEST')) f1;
explain select f1.STAT_ITEM from table(dba_analyze_table('SYS','GS_TBL_AS_TEST')) f1;
insert into gs_tbl_as_test values(1,2);
select stat_item from table(dba_analyze_table('SYS','GS_TBL_AS_TEST'));
select stat_item from table(dba_analyze_table('SYS',(select 'GS_TBL_AS_TEST' from dual)));
select * from table(dba_analyze_table('SYS','GS_TBL_AS_TEST')) where value = 0;
select * from table(dba_analyze_table('SYS','GS_TBL_AS_TEST')) a,table(dba_analyze_table('SYS','GS_TBL_AS_TEST')) b where a.value = 0 and b.value = 0 order by 1,2;
select * from gs_tbl_as_test;
select * from table(dba_analyze_table('SYS','GS_TBL_AS_TEST'));
drop table gs_tbl_as_test;
select * from table(dba_analyze_table('SYS','ALL_TABLES'));

select ID, ADD_COL2, IS_DEFAULT from table(get_tab_rows('ALL_TABLES', -1, 25779234820097, 'NULL'));
select * from table(get_tab_rows('ALL_TABLES', -1, (SELECT CURRENT_SCN FROM V$DATABASE), 'NULL'));

create or replace procedure tbl_func_p1
as
begin
null;
end;
/
select * from table(dba_proc_line('SYS','TBL_FUNC_P1'));
explain select * from table(dba_proc_line('SYS','TBL_FUNC_P1'));
select * from table(dba_proc_decode('SYS', 'TBL_FUNC_P1', 'PROCEDURE'));
explain select * from table(dba_proc_decode('SYS', 'TBL_FUNC_P1', 'PROCEDURE'));
select * from table(get_tab_parallel('', 4));
select * from table(dba_analyze_table('','t_usert_table'));

create or replace procedure procedure_sys_FVT_Security_User_privilege_248  is
v_SCN number;
v_BEG number;
v_END number;
v_result number;
v_sql varchar(1023);
begin
  select ORG_SCN into v_SCN from SYS_TABLES where name='SYS_ROLES';
  select BEG into v_BEG from table(get_tab_parallel('SYS_ROLES',4));
  select END into v_END from table(get_tab_parallel('SYS_ROLES',4));
--dbe_output.print_line('v_SCN: '||v_SCN||'.');
--dbe_output.print_line('v_BEG: '||v_BEG||'.');
--dbe_output.print_line('v_END: '||v_END||'.');
  v_sql :='select count(*) from table(parallel_scan(''SYS_ROLES'',''||v_SCN||'',''||v_BEG||'',''||v_END||'',-1))';
  execute immediate v_sql;
end;
/

exec procedure_sys_FVT_Security_User_privilege_248;

select * from table(dba_proc_decode('bucunzaideyonghuming','bucunzai','PROCEDURE'));
select DBE_DIAGNOSE.dba_user_name(14000);

--DTS2019091110247
drop table  t_count_base_005;
CREATE table t_count_base_005("ID" INT NOT NULL, "CHR_FIELD" VARCHAR(30), "VALUE" NUMBER);
insert into t_count_base_005 select rownum, decode(mod(rownum, 2), 0, NULL, rpad('CHR_', 10, chr(rownum + 64))), decode(mod(rownum, 3), 0, NULL, rownum * 10000) from dual connect by rownum < 6;
insert into t_count_base_005 select rownum + 10, decode(mod(rownum, 2), 0, NULL, rpad('CHR_', 10, chr(rownum + 64))), decode(mod(rownum, 3), 1, NULL, rownum * 10000) from dual connect by rownum < 6;
insert into t_count_base_005 select rownum + 15, decode(mod(rownum, 2), 0, NULL, rpad('CHR_', 10, chr(rownum + 64))), decode(mod(rownum, 3), 2, '', rownum * 10) from dual connect by rownum < 6;
insert into t_count_base_005 select rownum + 15, decode(mod(rownum, 2), 0, NULL, rpad('CHR_', 10, chr(rownum + 64))), decode(mod(rownum, 3), 2, '', rownum * 10) from dual connect by rownum < 6;
commit;
create table test_table_func_join1 as select * from table(dba_analyze_table('SYS', 'T_COUNT_BASE_005'));
select t1.STAT_ITEM,t2.STAT_ITEM from table(dba_analyze_table('SYS', 'T_COUNT_BASE_005')) t1 join table(dba_analyze_table('SYS', 'T_COUNT_BASE_005')) t2 on t1.STAT_ITEM=t2.STAT_ITEM;
select t1.STAT_ITEM,t2.STAT_ITEM from test_table_func_join1 t1 join table(dba_analyze_table('SYS', 'T_COUNT_BASE_005')) t2 on t1.STAT_ITEM=t2.STAT_ITEM;
select t1.STAT_ITEM,t2.STAT_ITEM from table(dba_analyze_table('SYS', 'T_COUNT_BASE_005')) t1 join test_table_func_join1 t2 on t1.STAT_ITEM=t2.STAT_ITEM;
select t1.STAT_ITEM,t2.STAT_ITEM from table(dba_analyze_table('SYS', 'T_COUNT_BASE_005')) t1 left join table(dba_analyze_table('SYS', 'T_COUNT_BASE_005')) t2 on t1.STAT_ITEM=t2.STAT_ITEM;
select t1.STAT_ITEM,t2.STAT_ITEM from table(dba_analyze_table('SYS', 'T_COUNT_BASE_005')) t1 right join table(dba_analyze_table('SYS', 'T_COUNT_BASE_005')) t2 on t1.STAT_ITEM=t2.STAT_ITEM;
drop table t_count_base_005;
drop table test_table_func_join1;
--DTS2019092604539
drop table if exists get_tab_rows_tab;
create table get_tab_rows_tab
(
a int,
b varchar(1024)
);

begin
        for i in 1..100 loop
                insert into get_tab_rows_tab values(i,i||i);
        end loop;
end;
/
commit;
set serveroutput on;
declare
beg_id number;
end_id number;
scn_id number;
d int;
e varchar(1024);
begin
    --获取 起始pageid  和 结束pageid
    select BEG,END into beg_id,end_id from table(get_tab_parallel('get_tab_rows_tab', 1));
    --获取scn号
    select current_scn into scn_id from v$database;
    --直接获取存储引擎原始row记录。
    select * into d,e from table(get_tab_rows('get_tab_rows_tab', -1, null,scn_id, beg_id,end_id)) limit 1;
    dbe_output.print_line(d||'-'||e);
end;
/
drop table if exists get_tab_rows_tab;

-- test for dba_page_corruption, normal
select FILE_ID, INFO_TYPE, CORRUPT_NUM from table(dba_page_corruption('DATABASE')) where FILE_ID=0;
select FILE_ID, INFO_TYPE, CORRUPT_NUM from table(dba_page_corruption('DATABASE')) where FILE_ID=2;
select FILE_ID, INFO_TYPE, CORRUPT_NUM from table(dba_page_corruption('DATABASE')) where FILE_ID=3;
select FILE_ID, INFO_TYPE, CORRUPT_NUM from table(dba_page_corruption('DATABASE')) where FILE_ID=4;
select FILE_ID, INFO_TYPE, CORRUPT_NUM from table(dba_page_corruption('DATABASE')) where FILE_ID=5;
select FILE_ID, INFO_TYPE, CORRUPT_NUM from table(dba_page_corruption('DATABASE')) where FILE_ID=6;
select FILE_ID, INFO_TYPE, CORRUPT_NUM from table(dba_page_corruption('TABLESPACE',0));
select FILE_ID, INFO_TYPE, CORRUPT_NUM from table(dba_page_corruption('TABLESPACE',3));
select FILE_ID, INFO_TYPE, CORRUPT_NUM from table(dba_page_corruption('DATAFILE',4));
select FILE_ID, INFO_TYPE, CORRUPT_NUM from table(dba_page_corruption('PAGE',0,1));

-- test for dba_page_corruption, more or less parms
select * from table(dba_page_corruption('DATABASE',0));
select * from table(dba_page_corruption('DATABASE',0,1));
select * from table(dba_page_corruption('TABLESPACE',0,1));
select * from table(dba_page_corruption('TABLESPACE'));
select * from table(dba_page_corruption('DATAFILE',0,1));
select * from table(dba_page_corruption('DATAFILE'));
select * from table(dba_page_corruption('PAGE',1));

-- test for dba_page_corruption, wrong parm
select * from table(dba_page_corruption('TABLESPACE',-1));
select * from table(dba_page_corruption('DATAFILE','aaa'));

-- test for dba_page_corruption, over range
select * from table(dba_page_corruption('TABLESPACE',2000));
select * from table(dba_page_corruption('DATAFILE',2000));
select * from table(dba_page_corruption('PAGE',3, 1073741823));
select * from table(dba_page_corruption('TABLESPACE',1024));
select * from table(dba_page_corruption('DATAFILE',1023));
select * from table(dba_page_corruption('PAGE',3, 1073741824));
select * from table(dba_page_corruption('PAGE',1023, 1));
select * from table(dba_page_corruption('PAGE',1023, 1073741824));

-- test for dba_page_corruption
drop table if exists page_corrupt_test;
create table page_corrupt_test(i int,j int) partition by range(i) (partition part_1 values less than(201),partition part_2 values less than(401),partition part_3 values less than(maxvalue));

declare
 
i integer;
begin
for i in 1 .. 1000 loop
insert into page_corrupt_test values(i, i);
end loop;
commit;
end;
/

select * from table(dba_table_corruption('SYS', 'page_corrupt_test'));

drop table if exists page_corrupt_test;
create table page_corrupt_test(i int,j int);

declare

i integer;
begin
for i in 1 .. 1000 loop
insert into page_corrupt_test values(i, i);
end loop;
commit;
end;
/

select * from table(dba_table_corruption('SYS', 'page_corrupt_test'));

drop table if exists page_corrupt_test;
create table page_corrupt_test(f_lob BLOB);
declare

i integer;
begin
for i in 1 .. 10 loop
INSERT INTO page_corrupt_test VALUES(lpad('a',10000,'a'));
end loop;
commit;
end;
/

select * from table(dba_table_corruption('sys','page_corrupt_test'));

drop table if exists page_corrupt_test;
create table page_corrupt_test(id int, f_lob clob)
partition by range(id)
(
partition p1 values less than (100),
partition p2 values less than (maxvalue)
);

declare

i integer;
begin
for i in 1 .. 1000 loop
INSERT INTO page_corrupt_test VALUES(i, lpad('a',10000,'a'));
end loop;
commit;
end;
/

select * from table(dba_table_corruption('SYS', 'page_corrupt_test'));

-- test for dba_index_corruption
drop table if exists index_corrupt_test;
create table index_corrupt_test(i int,j int) partition by range(i) (partition part_1 values less than(201),partition part_2 values less than(401),partition part_3 values less than(maxvalue));
create index idx_ctest_local on index_corrupt_test(i) local;
create index idx_ctest_global on index_corrupt_test(j);

declare 
i integer;
begin
for i in 1 .. 1000 loop
insert into index_corrupt_test values(i, i);
end loop;
commit;
end;
/

select * from table(dba_index_corruption('SYS', 'IDX_CTEST_LOCAL'));
select * from table(dba_index_corruption('SYS', 'IDX_CTEST_GLOBAL'));

drop table if exists index_corrupt_test;
create table index_corrupt_test(i int,j int);
create index idx_ctest on index_corrupt_test(i);

declare 
i integer;
begin
for i in 1 .. 1000 loop
insert into index_corrupt_test values(i, i);
end loop;
commit;
end;
/

select * from table(dba_index_corruption('SYS', 'IDX_CTEST'));
select * from table(dba_index_corruption('', 'IDX_CTEST'));
select * from table(dba_index_corruption('SYS', ''));
select * from table(dba_index_corruption('sys', 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'));
select * from table(dba_index_corruption('sys', 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'));

-- rowid/rowscn/rownodeid in func_as_table
select column_value from table(cast(rowid as int));
select column_value from table(cast(rowscn as int));
select column_value from table(cast(rownodeid as int));

drop table if exists get_tab_parallel_error_t;
create table get_tab_parallel_error_t(id int);
select * from table(get_tab_parallel('tab11111111111111111111111111111111111111111111111111111111111111111111', 1, ''));
select * from table(get_tab_parallel('get_tab_parallel_error_t', 4, 'This is a very long string, the length of the string is larger than CT_MAX_NAME_LEN + 1'));
drop table get_tab_parallel_error_t;

--DTS202104230KVGROP0K00
drop user if exists test_func_tb1 cascade;
drop user if exists test_func_tb2 cascade;
create user test_func_tb1 identified by cantiandb_123;
grant dba to test_func_tb1;
create table test_func_tb1.table1(f1 int);
insert into test_func_tb1.table1 values(1);
commit;
create user test_func_tb2 identified by Cantian_234;

grant connect to test_func_tb2;
conn test_func_tb2/Cantian_234@127.0.0.1:1611
select * from table(parallel_scan('test_func_tb1.table1', 1641400608411649, 12884903244,4393751543808,-1));
select * from table(parallel_scan('test_func_tb1.tab1', 1641400608411649, 12884903244,4393751543808,-1));
conn / as sysdba
drop user if exists test_func_tb1 cascade;
drop user if exists test_func_tb2 cascade;

-- dba_analyze_table/dba_table_corruption/dba_index_corruption support more table types
drop table if exists dc_type_t;
create table dc_type_t(c1 int, c2 int);
declare 
    i integer;
begin
    for i in 1 .. 1000 loop
        insert into dc_type_t values(i, i);
    end loop;
    commit;
end;
/

-- transaction temp table
drop table if exists global_tx_temp_t;
create global temporary table global_tx_temp_t(c1 int, c2 int) on commit delete rows;
create index global_tx_temp_t_idx on global_tx_temp_t(c1);

select * from table(dba_analyze_table('SYS','GLOBAL_TX_TEMP_T'));
select * from table(dba_table_corruption('SYS','GLOBAL_TX_TEMP_T'));
select * from table(dba_index_corruption('SYS', 'GLOBAL_TX_TEMP_T_IDX'));

drop table global_tx_temp_t;
-- session temp table
drop table if exists global_session_temp_t;
create global temporary table global_session_temp_t(c1 int, c2 int) on commit preserve rows;
insert into global_session_temp_t select * from dc_type_t;
create index global_session_temp_t_idx on global_session_temp_t(c1);

select * from table(dba_analyze_table('SYS','GLOBAL_SESSION_TEMP_T'));
select * from table(dba_table_corruption('SYS','GLOBAL_SESSION_TEMP_T'));
select * from table(dba_index_corruption('SYS', 'GLOBAL_SESSION_TEMP_T_IDX'));

drop table global_session_temp_t;

-- local temp table
alter system set local_temporary_table_enabled=true;
drop table if exists #session_temp_t;
create temporary table #session_temp_t on commit preserve rows as select * from dc_type_t;
create index session_temp_t_idx on #session_temp_t(c1);

select * from table(dba_analyze_table('SYS','#SESSION_TEMP_T'));
select * from table(dba_table_corruption('SYS', '#SESSION_TEMP_T'));
select * from table(dba_index_corruption('SYS', 'SESSION_TEMP_T_IDX'));

drop table #session_temp_t;
alter system set local_temporary_table_enabled=false;
-- nologging table
drop table if exists nologging_t;
create table nologging_t(c1 int, c2 int) nologging;
insert into nologging_t select * from dc_type_t;
create index nologging_t_idx on nologging_t(c1);

select * from table(dba_analyze_table('SYS','NOLOGGING_T'));
select * from table(dba_table_corruption('SYS', 'NOLOGGING_T'));
select * from table(dba_index_corruption('SYS', 'NOLOGGING_T_IDX'));

drop table nologging_t;

-- external table
create or replace directory test_dir as './data';
drop table if exists external_t;
create table external_t(c1 int, c2 float, c3 decimal, c4 real, c5 varchar(32), c6 datetime, c7 timestamp) 
organization external
(
	type loader
	directory test_dir
	access parameters(
	    records delimited by newline
	    fields terminated by ',')
    location 'external_1.data'
);

select * from table(dba_analyze_table('SYS','EXTERNAL_T'));
select * from table(dba_table_corruption('SYS', 'EXTERNAL_T'));

drop table external_t;
drop directory test_dir;

-- view
drop view if exists dc_type_v;
create view dc_type_v as select * from dc_type_t;
select * from table(dba_analyze_table('SYS','DC_TYPE_V'));
select * from table(dba_table_corruption('SYS','DC_TYPE_V'));
drop view dc_type_v;

-- dynamic view
select * from table(dba_analyze_table('SYS','DV_SQL_PLAN'));
select * from table(dba_table_corruption('SYS','DV_SQL_PLAN'));

drop table dc_type_t;