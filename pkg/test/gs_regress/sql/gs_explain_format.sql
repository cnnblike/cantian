drop table if exists test_display_format;
create table test_display_format(c1 int);

------------ system ------------
-- error
alter system set plan_display_format = ;
alter system set plan_display_format = basic,;
alter system set plan_display_format = bacic;
alter system set plan_display_format = basic, ;
alter system set plan_display_format = basic, , predicate;
alter system set plan_display_format = "basic";
alter system set plan_display_format = '"basic"';
alter system set plan_display_format = ''basic'';
alter system set plan_display_format = basic, 123;
alter system set plan_display_format = basic, typical;
alter system set plan_display_format = typical, all;
alter system set plan_display_format = basic, all, typical;

-- defalut
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

-- basic
alter system set plan_display_format = basic;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

-- basic + predicate = typical
alter system set plan_display_format = basic,predicate;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

alter system set plan_display_format = typical;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

-- basic + predicate + query_block = typical + query_block
alter system set plan_display_format = basic,predicate,query_block;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

alter system set plan_display_format = typical,query_block;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

-- basic + predicate + query_block + outline = typical + query_block + outline = all
alter system set plan_display_format = basic,predicate,query_block,outline;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

alter system set plan_display_format = typical,query_block,outline;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

alter system set plan_display_format = all;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

-- duplicate format
alter system set plan_display_format = basic,basic;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

alter system set plan_display_format = typical,typical;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

alter system set plan_display_format = all,all;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

-- duplicate option
alter system set plan_display_format = basic, predicate, predicate;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

alter system set plan_display_format = typical, typical, query_block, query_block;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

alter system set plan_display_format = typical, outline, outline;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

-- only option, then defalut format is basic
alter system set plan_display_format = predicate;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

alter system set plan_display_format = query_block;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

alter system set plan_display_format = outline;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

-- with scope
-- error
alter system set plan_display_format = typical,scope scope=memory;
alter system set plan_display_format = 'typical,scope' scope=memory;

alter system set plan_display_format = typical scope=memory;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

alter system set plan_display_format = 'typical,query_block' scope=memory;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

-- _SHOW_EXPLAIN_PREDICATE
alter system set plan_display_format = typical;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='_SHOW_EXPLAIN_PREDICATE';
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;
alter system set _show_explain_predicate=false;
select name, value, runtime_value, default_value from DV_PARAMETERS where name='_SHOW_EXPLAIN_PREDICATE';
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

-- reset
alter system set _show_explain_predicate=true;
alter system set plan_display_format = typical;
------------ session ------------
-- error, the same as system value
alter session set plan_display_format = basic, ;
alter session set plan_display_format = basic, typical;

-- current system value
select name, value, runtime_value, default_value from DV_PARAMETERS where name='PLAN_DISPLAY_FORMAT';
explain select * from test_display_format where c1 < 1;

alter session set plan_display_format = basic;
explain select * from test_display_format where c1 < 1;

alter session set plan_display_format = basic , predicate;
explain select * from test_display_format where c1 < 1;

alter session set plan_display_format = typical;
explain select * from test_display_format where c1 < 1;

alter session set plan_display_format = basic, predicate, query_block;
explain select * from test_display_format where c1 < 1;

alter session set plan_display_format = typical, query_block;
explain select * from test_display_format where c1 < 1;

alter session set plan_display_format = basic, query_block, predicate, outline;
explain select * from test_display_format where c1 < 1;

alter session set plan_display_format = typical, predicate, outline;
explain select * from test_display_format where c1 < 1;

alter session set plan_display_format = all;
explain select * from test_display_format where c1 < 1;

------------ test prefetch rows ------------
alter system set _prefetch_rows = 5;

alter session set plan_display_format = basic;
explain select * from test_display_format where c1 < ?;

alter session set plan_display_format = typical;
explain select * from test_display_format where c1 < ?;

alter session set plan_display_format = basic,query_block;
explain select * from test_display_format where c1 < ?;

alter session set plan_display_format = typical,query_block;
explain select * from test_display_format where c1 < ?;

alter session set plan_display_format = basic,outline;
explain select * from test_display_format where c1 < ?;

alter session set plan_display_format = typical,outline;
explain select * from test_display_format where c1 < ?;

alter session set plan_display_format = basic,query_block,outline;
explain select * from test_display_format where c1 < ?;

alter session set plan_display_format = all;
explain select * from test_display_format where c1 < ?;

--NOTE
alter system set _prefetch_rows = 5;
call DBE_SPM.create_sql_outline(schema=>user, dst_sql=>'select * from test_display_format where c1 < 1', sql_id=>'1491693019', signature=>'52891C32F69938F15360555694C7EF4E');
alter session set plan_display_format = basic , predicate;
explain select * from test_display_format where c1 < 1;

alter session set plan_display_format = typical;
explain select * from test_display_format where c1 < 1;

alter session set plan_display_format = basic, predicate, query_block;
explain select * from test_display_format where c1 < 1;

alter session set plan_display_format = typical, query_block;
explain select * from test_display_format where c1 < 1;

alter session set plan_display_format = basic, query_block, predicate, outline;
explain select * from test_display_format where c1 < 1;

alter session set plan_display_format = typical, predicate, outline;
explain select * from test_display_format where c1 < 1;

alter system set _prefetch_rows = 1;
explain select * from test_display_format where c1 < ?;

alter system set _prefetch_rows = 100;

-- _SHOW_EXPLAIN_PREDICATE
alter session set plan_display_format = basic;
explain select * from test_display_format where c1 < ?;
alter session set _show_explain_predicate = true;
explain select * from test_display_format where c1 < ?;

alter session set _show_explain_predicate = false;
explain select * from test_display_format where c1 < ?;

-- reset
alter session set _show_explain_predicate = true;
alter session set plan_display_format = typical;
drop table test_display_format;