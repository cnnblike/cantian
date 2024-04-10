drop table if exists wg.wg_table;
drop synonym if exists wg.wg_synonym;
drop user if exists wg CASCADE;
create user wg identified by 'test1234!T';
grant dba to wg;
create table wg.wg_table(f1 int);
create or replace synonym wg.wg_synonym for wg.wg_table;
select synonym_name,flags from sys.SYS_SYNONYMS where synonym_name = upper('wg_synonym') and TABLE_OWNER = 'WG';
SELECT * FROM ALL_DEPENDENCIES WHERE NAME = upper('wg_synonym');
drop table if exists wg.wg_table;
drop synonym if exists wg.wg_synonym;
drop user if exists wg CASCADE;

drop table if exists wg_table;
drop synonym if exists wg_synonym;
create table wg_table(f1 int);
create or replace synonym wg_synonym for wg_table;
select synonym_name,flags from sys.SYS_SYNONYMS where synonym_name = upper('wg_synonym');

drop function if exists wg_func1;
drop function if exists wg_func2;
drop view if exists wg_dual_view;
drop view if exists wg_haha_view;
drop table if exists wg_tab1;
drop sequence if exists wg_seq1;

CREATE OR REPLACE function wg_func1 (
t_column in VARCHAR2,
t_name in VARCHAR2
)
return number
IS
temp VARCHAR2(30);
BEGIN
temp := t_column;
return 1;
END;
/

CREATE OR REPLACE function wg_func2 (
t_column in VARCHAR2,
t_name in VARCHAR2
)
return number
IS
temp VARCHAR2(30);
BEGIN
temp := t_column;
return 1;
END;
/

create or replace view wg_dual_view
as
select sin(1) X from dual;

create table wg_tab1(a int);

create sequence wg_seq1 start with 1 increment by 1 nomaxvalue nocycle nocache;

create or replace view wg_haha_view
as
select * from wg_dual_view
union
select wg_func1('a','a') from dual
union
select wg_func2('a','a') from dual
union
select * from wg_tab1;


SELECT * FROM ALL_DEPENDENCIES WHERE NAME = 'WG_HAHA_VIEW' order by referenced_name;
select OBJECT_NAME,OBJECT_TYPE,STATUS from all_objects where object_name = 'WG_HAHA_VIEW';

--1 test drop function reference
drop function if exists wg_func1;

SELECT * FROM ALL_DEPENDENCIES WHERE NAME = 'WG_HAHA_VIEW' order by referenced_name;
select OBJECT_NAME,OBJECT_TYPE,STATUS from all_objects where object_name = 'WG_HAHA_VIEW';

CREATE OR REPLACE function wg_func1 (
t_column in VARCHAR2,
t_name in VARCHAR2
)
return number
IS
temp VARCHAR2(30);
BEGIN
temp := t_column;
return 1;
END;
/

create or replace view wg_haha_view
as
select * from wg_dual_view
union
select wg_func1('a','a') from dual
union
select wg_func2('a','a') from dual
union
select * from wg_tab1;

SELECT * FROM ALL_DEPENDENCIES WHERE NAME = 'WG_HAHA_VIEW' order by referenced_name;
select OBJECT_NAME,OBJECT_TYPE,STATUS from all_objects where object_name = 'WG_HAHA_VIEW';

--1 test drop view reference
drop view if exists wg_dual_view;
SELECT * FROM ALL_DEPENDENCIES WHERE NAME = 'WG_HAHA_VIEW' order by referenced_name;
select OBJECT_NAME,OBJECT_TYPE,STATUS from all_objects where object_name = 'WG_HAHA_VIEW';

create or replace view wg_dual_view
as
select sin(1) X from dual;

create or replace view wg_haha_view
as
select * from wg_dual_view
union
select wg_func1('a','a') from dual
union
select wg_func2('a','a') from dual
union
select * from wg_tab1;

SELECT * FROM ALL_DEPENDENCIES WHERE NAME = 'WG_HAHA_VIEW' order by referenced_name;
select OBJECT_NAME,OBJECT_TYPE,STATUS from all_objects where object_name = 'WG_HAHA_VIEW';

--2 test drop table reference
drop table if exists wg_tab1;
SELECT * FROM ALL_DEPENDENCIES WHERE NAME = 'WG_HAHA_VIEW' order by referenced_name;
select OBJECT_NAME,OBJECT_TYPE,STATUS from all_objects where object_name = 'WG_HAHA_VIEW';

create table wg_tab1(a int);

create or replace view wg_haha_view
as
select * from wg_dual_view
union
select wg_func1('a','a') from dual
union
select wg_func2('a','a') from dual
union
select * from wg_tab1;

SELECT * FROM ALL_DEPENDENCIES WHERE NAME = 'WG_HAHA_VIEW' order by referenced_name;
select OBJECT_NAME,OBJECT_TYPE,STATUS from all_objects where object_name = 'WG_HAHA_VIEW';

--3 test drop sequence reference
drop sequence if exists wg_seq1;
SELECT * FROM ALL_DEPENDENCIES WHERE NAME = 'WG_HAHA_VIEW' order by referenced_name;
select OBJECT_NAME,OBJECT_TYPE,STATUS from all_objects where object_name = 'WG_HAHA_VIEW';

create sequence wg_seq1 start with 1 increment by 1 nomaxvalue nocycle nocache;

create or replace view wg_haha_view
as
select * from wg_dual_view
union
select wg_func1('a','a') from dual
union
select wg_func2('a','a') from dual
union
select * from wg_tab1;

SELECT * FROM ALL_DEPENDENCIES WHERE NAME = 'WG_HAHA_VIEW' order by referenced_name;
select OBJECT_NAME,OBJECT_TYPE,STATUS from all_objects where object_name = 'WG_HAHA_VIEW';

drop function if exists wg_func1;
drop function if exists wg_func2;
drop view if exists wg_dual_view;
drop view if exists wg_haha_view;
drop table if exists wg_tab1;
drop sequence if exists wg_seq1;
