alter system set cbo = on;
drop table if exists test_dy_1;
create table test_dy_1 (f1 int, f2 integer, f3 bigint, f4 number);
BEGIN
  FOR i IN 1..10000 LOOP
        insert into test_dy_1 values(i % 200, i % 300, i % 400,  i % 500);
  END LOOP;
END;
/
commit;

drop table if exists test_dy;
create table test_dy as select * from test_dy_1 where 1=0;
insert into test_dy select * from test_dy_1 order by f1;
commit;
create index idx_test_dy_1 on test_dy (f1);
create index idx_test_dy_2 on test_dy (f2);
create index idx_test_dy_3 on test_dy (f1, f2);

set serveroutput on;

-- the purpose of the procedure: whether dynamic sampling is triggered before and after the execution of the sql statement
-- the first parameter:      sql statement
-- the second parameter:     statistics view of the table
-- the third parameter:      statistics view of the index in the table
-- the fourth parameter:     statistics view of the fields in the table
-- description of the printing result:
	-- the normal table only has the results of 0 and 1, where 0 means that the statistical information is not modified, and 1 means that the statistical information is modified.
	-- in the partition table, 0 means that the statistics are not modified, and greater than 0 means that the statistics of several partitions have been modified.
create or replace procedure test_stats(v_sql in varchar2, view1 in varchar2, view2 in varchar2, view3 in varchar2) is
	a int;
	s VARCHAR(200);
begin
	EXECUTE IMMEDIATE 'drop table if exists tab_stats';
	EXECUTE IMMEDIATE 'create table tab_stats as select num_rows,blocks,empty_blocks,avg_row_len,sample_size from '||view1||' where table_name = ''TEST_DY''';
	for i in 1..4 loop
		EXECUTE IMMEDIATE 'drop table if exists src_idx_stats_' || i;
		s := 'IDX_TEST_DY_' || i;
		EXECUTE IMMEDIATE 'create table src_idx_stats_' || i || ' as select * from '||view2 ||' where index_name=' || '''' || s || '''';
	end loop;
	for i in 1..4 loop
		EXECUTE IMMEDIATE 'drop table if exists src_col_stats_' || i;
		s := 'F' || i;
		EXECUTE IMMEDIATE 'create table src_col_stats_'|| i || ' as select * from '||view3||' where table_name = ''TEST_DY'' and column_name = '|| '''' || s || '''';
	end loop;
	EXECUTE IMMEDIATE v_sql;
	EXECUTE IMMEDIATE 'select count(*) from (select num_rows,blocks,empty_blocks,avg_row_len,sample_size from '||view1||' where table_name = ''TEST_DY'' except all select * from tab_stats)' into a;
    DBE_OUTPUT.PRINT_LINE('tab_stats diff: ' || a);
	EXECUTE IMMEDIATE 'drop table if exists tab_stats';
	for i in 1..4 loop
		EXECUTE IMMEDIATE 'drop table if exists dst_idx_stats_' || i;
		s := 'IDX_TEST_DY_' || i;
		EXECUTE IMMEDIATE 'create table dst_idx_stats_' || i || ' as select * from '||view2 ||' where index_name=' || '''' || s || '''';
	    EXECUTE IMMEDIATE 'select count(*) from (select * from dst_idx_stats_' || i || ' except all select * from src_idx_stats_'|| i || ')' into a; 
	    DBE_OUTPUT.PRINT_LINE('idx_test_dy_' || i ||' diff: ' || a);
		EXECUTE IMMEDIATE 'drop table if exists src_idx_stats_' || i;
		EXECUTE IMMEDIATE 'drop table if exists dst_idx_stats_' || i;
	end loop;
	for i in 1..4 loop
		EXECUTE IMMEDIATE 'drop table if exists dst_col_stats_' || i;
		s := 'F' || i;
		EXECUTE IMMEDIATE 'create table dst_col_stats_'|| i || ' as select * from '||view3||' where table_name = ''TEST_DY'' and column_name = ' || '''' || s || '''';
	    EXECUTE IMMEDIATE 'select count(*) from (select * from dst_col_stats_' || i || ' except all select * from src_col_stats_' || i || ')' into a;
	    DBE_OUTPUT.PRINT_LINE('f' || i ||' diff: ' || a);
		EXECUTE IMMEDIATE 'drop table if exists src_col_stats_' || i;
		EXECUTE IMMEDIATE 'drop table if exists dst_col_stats_' || i;
	end loop;
end;
/

-- f4 column stats null, trigger column dynamic sampling. only modify the statistics of f4.
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 < 200 and t0.f4 = t1.f1 limit 1', 'my_tables', 'my_indexes', 'my_tab_cols');

-- f3, f4 column stats null, trigger column dynamic sampling. only modify the statistics of f3.
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for columns f1, f2');
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 < 50 and t0.f3 = t1.f1 limit 1', 'my_tables', 'my_indexes', 'my_tab_cols');

-- collect statistics after delete, and then trigger dynamic sampling
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 < 50 and t0.f3 = t1.F4 limit 1', 'my_tables', 'my_indexes', 'my_tab_cols');

-- table stats null, trigger all dynamic sampling. table, indexes, and columns statistics are all modified
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 = t1.f2 and t0.f1 < 20 and t1.f2 = 30 limit 1', 'my_tables', 'my_indexes', 'my_tab_cols');

-- delete insert proportion 100%, trigger all dynamic sampling. table, indexes, and columns statistics are all modified
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
delete test_dy;
insert into test_dy select * from test_dy_1 order by f1;
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 = t1.f2 and t0.f1 = 20 and t1.f2 > 30 limit 1', 'my_tables', 'my_indexes', 'my_tab_cols');


-- delete insert proportion 100% and f4 column stats null, trigger all dynamic sampling. table, indexes, and columns statistics are all modified
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
delete test_dy;
insert into test_dy select * from test_dy_1 order by f1;
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 = t1.f2 and t0.f4 = 20 and t1.f2 > 30 limit 1', 'my_tables', 'my_indexes', 'my_tab_cols');

-- add index, f1, f2 in cond, trigger index dynamic sampling. only modify the statistics of IDX_TEST_DY_4
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
drop index if exists IDX_TEST_DY_4 on test_dy;
create index IDX_TEST_DY_4 on test_dy(f1, f2, f4);
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 = t1.f2 and t0.f1 < 20 and t1.f2 < 30 limit 1', 'my_tables', 'my_indexes', 'my_tab_cols');
drop index if exists IDX_TEST_DY_4 on test_dy;

-- add function index, f1 in cond, trigger index dynamic sampling. only modify the statistics of IDX_TEST_DY_4
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
drop index if exists IDX_TEST_DY_4 on test_dy;
create index IDX_TEST_DY_4 on test_dy(to_number(f1));
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 = t1.f2 and t0.f1 < 50 and t1.f2 < 30 limit 1', 'my_tables', 'my_indexes', 'my_tab_cols');
drop index if exists IDX_TEST_DY_4 on test_dy;

-- add index, f4 not in cond, not trigger dynamic sampling. all statistics must not be modified
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
drop index if exists IDX_TEST_DY_4 on test_dy;
create index IDX_TEST_DY_4 on test_dy(f4);
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 = t1.f2 and t0.f1 < 50 and t1.f2 < 30 limit 1', 'my_tables', 'my_indexes', 'my_tab_cols');
drop index if exists IDX_TEST_DY_4 on test_dy;

-- add function index, f4 not in cond, but trigger index dynamic sampling. only modify the statistics of IDX_TEST_DY_4
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
drop index if exists IDX_TEST_DY_4 on test_dy;
create index IDX_TEST_DY_4 on test_dy(to_number(f4));
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 = t1.f2 and t0.f1 < 50 and t1.f2 < 30 limit 1', 'my_tables', 'my_indexes', 'my_tab_cols');
drop index if exists IDX_TEST_DY_4 on test_dy;

drop table if exists test_dy;
--partition table
create table test_dy (f1 int, f2 integer, f3 bigint, f4 number)
PARTITION BY RANGE (f1)
(
    PARTITION P_0 VALUES LESS THAN (50),
	PARTITION P_1 VALUES LESS THAN (100),
	PARTITION P_2 VALUES LESS THAN (150),
	PARTITION P_3 VALUES LESS THAN (250)
);
insert into test_dy select * from test_dy_1 order by f1;
commit;
create index idx_test_dy_1 on test_dy (f1) local;
create index idx_test_dy_2 on test_dy (f2) local;
create index idx_test_dy_3 on test_dy (f1, f2) local;

-- f4 column stats null, trigger column dynamic sampling. only modify the statistics of the single partition f4.
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 < 200 and t0.f4 = t1.f1 limit 1', 'my_tab_partitions', 'my_ind_statistics', 'my_part_col_statistics');

-- f3, f4 column stats null, trigger column dynamic sampling. only modify the statistics of the single partition f3.
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for columns f1, f2');
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 < 50 and t0.f3 = t1.f1 limit 1', 'my_tab_partitions', 'my_ind_statistics', 'my_part_col_statistics');


-- table stats null, trigger all dynamic sampling. modify statistics of all partitions of tables, indexes, and columns
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 = t1.f2 and t0.f1 < 20 and t1.f2 = 30 limit 1', 'my_tab_partitions', 'my_ind_statistics', 'my_part_col_statistics');

-- delete insert proportion 100%, trigger all dynamic sampling. modify statistics of single partitions of tables, indexes, and columns
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
delete test_dy;
insert into test_dy select * from test_dy_1 order by f1;
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 = t1.f2 and t0.f1 = 20 and t1.f2 > 30 limit 1', 'my_tab_partitions', 'my_ind_statistics', 'my_part_col_statistics');


-- delete insert proportion 100% and f4 column stats null, trigger all dynamic sampling. modify statistics of all partitions of tables, indexes, and columns
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
delete test_dy;
insert into test_dy select * from test_dy_1 order by f1;
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 = t1.f2 and t0.f4 = 20 and t1.f2 > 30 limit 1', 'my_tab_partitions', 'my_ind_statistics', 'my_part_col_statistics');

-- add index, f1, f2 in cond, trigger index dynamic sampling. only modify the statistics of all partitions of IDX_TEST_DY_4.
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
drop index if exists IDX_TEST_DY_4 on test_dy;
create index IDX_TEST_DY_4 on test_dy(f1, f2, f4) local;
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 = t1.f2 and t0.f1 < 20 and t1.f2 < 30 limit 1', 'my_tab_partitions', 'my_ind_statistics', 'my_part_col_statistics');
drop index if exists IDX_TEST_DY_4 on test_dy;

-- add function index, f1 in cond, trigger index dynamic sampling. only modify the statistics of all partitions of IDX_TEST_DY_4.
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
drop index if exists IDX_TEST_DY_4 on test_dy;
create index IDX_TEST_DY_4 on test_dy(to_number(f1)) local;
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 = t1.f2 and t0.f1 < 50 and t1.f2 < 30 limit 1', 'my_tab_partitions', 'my_ind_statistics', 'my_part_col_statistics');
drop index if exists IDX_TEST_DY_4 on test_dy;

-- add index, f4 not in cond, not trigger dynamic sampling. all statistics must not be modified
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
drop index if exists IDX_TEST_DY_4 on test_dy;
create index IDX_TEST_DY_4 on test_dy(f4);
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 = t1.f2 and t0.f1 < 50 and t1.f2 < 30 limit 1', 'my_tab_partitions', 'my_ind_statistics', 'my_part_col_statistics');
drop index if exists IDX_TEST_DY_4 on test_dy;

-- add function index, f4 not in cond, but trigger index dynamic sampling. only modify the statistics of all partitions of IDX_TEST_DY_4.
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
drop index if exists IDX_TEST_DY_4 on test_dy;
create index IDX_TEST_DY_4 on test_dy(to_number(f4));
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 = t1.f2 and t0.f1 < 50 and t1.f2 < 30 limit 1', 'my_tab_partitions', 'my_ind_statistics', 'my_part_col_statistics');
drop index if exists IDX_TEST_DY_4 on test_dy;

-- add partition, not trigger dynamic sampling. all statistics must not be modified
call  dbe_stats.delete_table_stats(schema=>user, name=>'test_dy');
call  dbe_stats.collect_table_stats(schema=>user, name=>'test_dy', sample_ratio => 100, method_opt=>'for all indexed columns');
alter table test_dy add partition p_5 values less than (300);
call test_stats('select t0.f1 from test_dy t0, test_dy t1 where t0.f1 = t1.f2 and t0.f1 < 50 and t1.f2 < 30 limit 1', 'my_tab_partitions', 'my_ind_statistics', 'my_part_col_statistics');

drop table if exists test_dy;
alter system set cbo = off;