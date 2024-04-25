conn sys/sys@127.0.0.1:1611
drop user if exists test_view_depend;
create user test_view_depend identified by Test_123456;
grant dba to test_view_depend;
conn test_view_depend/Test_123456@127.0.0.1:1611

DROP TABLE IF EXISTS TEST_T1;
create or replace force view test_view1 as select * from TEST_T1;
create or replace force view test_view1(f1,f2) as select * from TEST_T1;
create or replace force view test_view1(f1,f2) as select f1,f2 from TEST_T1;
select FLAGS from sys.sys_views  where name='TEST_VIEW1';
select OWNER,VIEW_NAME,COLUMN_COUNT,TEXT from db_views where view_name='TEST_VIEW1';
SELECT * FROM test_view1;
CREATE TABLE TEST_T1 (F1 INT, F2 INT, F3 VARCHAR(10));
SELECT * FROM test_view1;
exec dbe_util.compile_schema(user,false);
select FLAGS from sys.sys_views  where name='TEST_VIEW1';

drop table IF EXISTS TEST_T2;
create table TEST_T2(c int);
insert into TEST_T2 values(10086);
DROP synonym IF EXISTS st2;
create synonym st2 for TEST_T2;
create table tt1 as select * from st2;

create or replace view vv as select * from st2;
DROP synonym IF EXISTS vv_sy;
create synonym vv_sy for vv;


exp users=test_view_depend filetype=bin file='./data/test_type_bin.dmp';
drop SYNONYM ST2;
imp users=test_view_depend filetype=bin file='./data/test_type_bin.dmp';

create or replace view test_view2 as select 1 from sys_dummy;

create or replace function test_func(a varchar)
RETURN varchar
AS
b varchar(100);
BEGIN
   select 1 into b from test_view2 ;
   if (a = 'ab') then
        return a;
   else
        return b;
   end if;
END;
/

create or replace view test_view3 as select test_func('ab');
create or replace view test_view4 as select * from test_view3;

exp users = test_view_depend file="./data/test_view_depend.dmp";
drop view test_view2;
drop view test_view3;
drop view test_view4;
drop function test_func;
imp users = test_view_depend file="./data/test_view_depend.dmp";
select * from test_view2;
select * from test_view3;
select * from test_view4;

exp users = test_view_depend file="./data/test_view_depend.dmp" consistent = y;
drop view test_view2;
drop view test_view3;
drop view test_view4;
drop function test_func;
imp users = test_view_depend file="./data/test_view_depend.dmp";
select * from test_view2;
select * from test_view3;
select * from test_view4;

conn sys/sys@127.0.0.1:1611
drop user if exists test_view_depend cascade;