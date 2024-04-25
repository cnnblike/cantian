--������default group��ѯDV_RSRC_MONITOR����core
call DBE_RSRC_MGR.create_plan('tnt_plan', 'plan for tenant', 1);
alter system set resource_plan = 'tnt_plan';
SELECT TENANT_NAME, SESSIONS FROM DV_RSRC_MONITOR;

--�⻧������ʱ����������ѯDV_RSRC_MONITOR�������Ǳ����⻧������
call DBE_RSRC_MGR.CREATE_CONTROL_GROUP('tnt_group1', 'tenant group1 description');
call DBE_RSRC_MGR.CREATE_CONTROL_GROUP('tnt_group2', 'tenant group2 description');
call DBE_RSRC_MGR.add_tenant_to_control_group('tnt1', 'tnt_group1');
call DBE_RSRC_MGR.add_tenant_to_control_group('tnt2', 'tnt_group2');
call DBE_RSRC_MGR.CREATE_PLAN_RULE('tnt_plan', 'tnt_group1', 'plan for tnt_group1', 40, 200, 200, 120, 1000, NULL, NULL, NULL);
call DBE_RSRC_MGR.CREATE_PLAN_RULE('tnt_plan', 'tnt_group2', 'plan for tnt_group2', 10, 20, 20, 10, 100, NULL, NULL, NULL);
alter system set resource_plan = 'tnt_plan';
SELECT TENANT_NAME, SESSIONS FROM DV_RSRC_MONITOR;

--�����⻧���⻧�е��û�ֻ�ܲ�ѯ��ǰ�⻧�ļ��
create tenant tnt1 tablespaces(users);
alter session set tenant=tnt1;
create user user1 identified by Hust4400;
grant dba to user1;
conn user1/Hust4400@127.0.0.1:1611/tnt1
SELECT TENANT_NAME, SESSIONS FROM DV_RSRC_MONITOR;

--������
conn / as  sysdba 
alter system set resource_plan = '';
call DBE_RSRC_MGR.DELETE_PLAN('tnt_plan');
call DBE_RSRC_MGR.DELETE_CONTROL_GROUP('tnt_group1');
call DBE_RSRC_MGR.DELETE_CONTROL_GROUP('tnt_group2');
SELECT TENANT_NAME, SESSIONS FROM DV_RSRC_MONITOR;
drop tenant if exists tnt1 cascade;

conn sys/Huawei@123@127.0.0.1:1611/a12345678901234567890123456789012
conn sys/Huawei@123@127.0.0.1:1611/a1234567890123456789012345678901
conn / as  sysdba 
drop TENANT  if exists TNT058 cascade;
CREATE TENANT TNT058 TABLESPACES (users);
ALTER SESSION SET TENANT=TNT058;
drop user if exists tenant_user_058 cascade;
create user tenant_user_058 identified by Cantian_234;
grant dba to tenant_user_058;
conn tenant_user_058/Cantian_234@127.0.0.1:1611/TNT058
select count(*) from GADM_TABLES;
select count(*) from GADM_TABLESPACES;
select count(*) from GADM_TAB_MODIFICATIONS;
select count(*) from GDV_BUFFER_POOLS;
select count(*) from GDV_DATA_FILES;
select count(*) from GDV_GLOBAL_TRANSACTIONS;
select count(*) from GDV_GMA_STATS;
select count(*) from GDV_HA_SYNC_INFO;
select count(*) from GDV_LOG_FILES;
select count(*) from GDV_PARAMETERS;
select count(*) from GDV_SYS_STATS;
select count(*) from GDV_TABLESPACES;
select count(*) from GMY_INDEXES;
select count(*) from GMY_TABLES;
select count(*) from GMY_TAB_MODIFICATIONS;
select count(*) from GSYS_PENDING_DIST_TRANS;
select count(*) from GSYS_PENDING_TRANS;
conn / as  sysdba 
drop TENANT  if exists TNT058 cascade;
conn / as sysdba
drop tenant if exists tnt1 cascade;
create tenant tnt1 tablespaces (users);
alter session set tenant = tnt1;
create user u1 identified by Changeme_123;
grant connect,create table to u1;
create user u2 identified by Changeme_123;
grant connect,create table to u2;
conn u1/Changeme_123@127.0.0.1:1611/tnt1
create table t1(id int);
insert into t1 values(1),(2);
commit;
grant all on t1 to public;
conn u2/Changeme_123@127.0.0.1:1611/tnt1
select * from u1.t1;
conn / as sysdba
drop tenant if exists tnt1 cascade;
conn / as sysdba 
drop tenant if exists tn1 cascade;
create role tenatrole1;
create tenant tn1 tablespaces(users);
alter session set tenant = tn1;
create user u1 identified by Cantian_234;
grant connect, create table to u1;
conn u1/Cantian_234@127.0.0.1:1611/tn1
create table t1(id int);
grant select on t1 to tenatrole1;
conn / as sysdba 
drop tenant if exists tn1 cascade;
drop role tenatrole1;
--0.�����ڵ�tenant
CONN tnt4_user/Root1234@127.0.0.1:1611/TNTat3456

--DTS2020060805DCOPP0I00
CONN / AS SYSDBA
SELECT USERNAME,USER_ID FROM MY_USERS;

--DTS20200609039IHIP0F00 
CONN u_tnt_sec_tenant_ctsql_1xxxxxxxxx/Changeme_123@127.0.0.1:1611/tnt2tnt2tnt2tnt2tnt2tnt2tnt2tnt2
CONN / AS SYSDBA

--USERS��Ϊ�Ǹ��⻧�Ŀ��ñ�ռ�
create tenant tnt1 tablespaces (users) default tablespace users;
alter session set tenant=tnt1;
create user tnt1_user identified by Root1234;
grant dba to tnt1_user;
conn tnt1_user/Root1234@127.0.0.1:1611/tnt1
select USER_NAME from dv_me;
select USERNAME,DEFAULT_TABLESPACE from my_users;
create table t1(c1 int);
select OWNER,TABLE_NAME,TABLESPACE_NAME from db_tables;
CONN / AS SYSDBA
DROP TENANT tnt1 CASCADE;

--����tablespace����
create tablespace tnt_space1 datafile 'tnt_space1.dbf' size 128m;
create tablespace tnt_space2 datafile 'tnt_space2.dbf' size 128m;
create tablespace tnt_space3 datafile 'tnt_space3.dbf' size 128m;
create tablespace tnt_space4 datafile 'tnt_space4.dbf' size 128m;

--1.�������� ����/��ѯ/�޸�/ɾ�� tenant ��ͼ
drop tenant if exists tnt1;
create tenant tnt1 tablespaces (tnt_space1,tnt_space2) default tablespace tnt_space2;
select TENANT_ID,NAME,SPACE_NUM,OPTIONS from sys_tenants order by tenant_id;
select TENANT_ID,NAME,DEFAULT_TABLESPACE,SPACE_NUM from adm_tenants order by TENANT_ID;
alter tenant tnt1 add tablespaces (tnt_space3, tnt_space4);
select TENANT_ID,NAME,SPACE_NUM,OPTIONS from sys_tenants order by tenant_id;
select TENANT_ID,NAME,DEFAULT_TABLESPACE,SPACE_NUM from adm_tenants order by TENANT_ID;
alter tenant tnt1 default tablespace tnt_space1;
select TENANT_ID,NAME,SPACE_NUM,OPTIONS from sys_tenants order by tenant_id;
select TENANT_ID,NAME,DEFAULT_TABLESPACE,SPACE_NUM from adm_tenants order by TENANT_ID;
drop tenant tnt1;
select TENANT_ID,NAME,SPACE_NUM,OPTIONS from sys_tenants order by tenant_id;
select TENANT_ID,NAME,DEFAULT_TABLESPACE,SPACE_NUM from adm_tenants order by TENANT_ID;

--2.�߽���� ���֧��255��tenant ����/�޸�tenant������֧��1024��tablespace
declare
  str varchar(100);
begin
  for i in 1..255 loop
    str := 'create tenant tnt'||to_char(i)||' tablespaces (tnt_space1,tnt_space2) default tablespace tnt_space2';
    execute immediate str;
  end loop;
end;
/
select TENANT_ID,NAME,SPACE_NUM,OPTIONS from sys_tenants order by tenant_id;
create tenant tnt256 tablespaces (tnt_space1,tnt_space2) default tablespace tnt_space2;--CT-00686, Maximum number of tenants (256) exceeded

declare--CT-00601, Sql syntax error: exclude spaces number out of max spaces number
  str varchar(20000);
begin
	str := 'create tenant tenant_1024ts tablespaces (tnt_space1';
	for i in 2..1025 loop
	 str := str || ',tnt_space'||to_char(i);
	end loop;
	str := str || ')';
	execute immediate str;
end;
/

declare--CT-00601, Sql syntax error: exclude spaces number out of max spaces number
  str varchar(20000);
begin
	str := 'alter tenant tnt1 add tablespaces (tnt_space1';
	for i in 2..1025 loop
	 str := str || ',tnt_space'||to_char(i);
	end loop;
	str := str || ')';
	execute immediate str;
end;
/

--3.�ظ����� �ظ����/ɾ��
create or replace procedure tnt_create()
as
  str varchar(100);
begin
  for i in 1..255 loop
    str := 'create tenant tnt'||to_char(i)||' tablespaces (tnt_space1,tnt_space2)';
    execute immediate str;
  end loop;
end;
/

create or replace procedure tnt_drop()
as
  str varchar(100);
begin
  for i in 1..255 loop
    str := 'drop tenant tnt'||to_char(i);
    execute immediate str;
  end loop;
end;
/

CALL tnt_create();
select TENANT_ID,NAME,SPACE_NUM,OPTIONS from sys_tenants order by tenant_id;
CALL tnt_drop();
select TENANT_ID,NAME,SPACE_NUM,OPTIONS from sys_tenants order by tenant_id;
begin
 for i in 1..10 loop
  tnt_create();
  tnt_drop();
 end loop;
end;
/
select TENANT_ID,NAME,SPACE_NUM,OPTIONS from sys_tenants order by tenant_id;
drop procedure tnt_create;
drop procedure tnt_drop;

--4.������� ����/�޸�ROOT/ts�����ڵȴ������
drop tenant if exists tnt1;
drop tenant if exists tnt2;
--tenant����
create tenant tnt1 tablespaces (tnt_space1,tnt_space2);
create tenant tnt1 tablespaces (tnt_space1);--CT-00753, The object tenant TNT1 already exists.
select TENANT_ID,NAME,SPACE_NUM,OPTIONS from sys_tenants order by tenant_id;
--ts�ظ�
alter tenant tnt1 add tablespaces (tnt_space1);--CT-01394, Tablespace TNT_SPACE1 is already usable in current tenant
create tenant tnt2 tablespaces (tnt_space1,tnt_space1);--CT-00601, Sql syntax error: tablespace tnt_space1 is already exists
--ts������
create tenant tnt2 tablespaces (tnt_space5, tnt_space4);--CT-00780, The tablespace TNT_SPACE5 does not exist.
create tenant tnt2 tablespaces (tnt_space4, tnt_space5);--CT-00780, The tablespace TNT_SPACE5 does not exist.
alter tenant tnt1 add tablespaces (tnt_space4, tnt_space5);--CT-00780, The tablespace TNT_SPACE5 does not exist.
alter tenant tnt1 add tablespaces (tnt_space5, tnt_space4);--CT-00780, The tablespace TNT_SPACE5 does not exist.
alter tenant tnt1 default tablespace tnt_space3;--CT-01391, Tablespace TNT_SPACE3 is disabled in current tenant
alter tenant tnt1 default tablespace tnt_space5;--CT-00780, The tablespace TNT_SPACE5 does not exist.
--�޸�root
create tenant tenant$root tablespaces (tnt_space1);--CT-00601, [1:15]Sql syntax error: invalid variant/object name was found
alter tenant tenant$root add tablespaces (tnt_space1);--CT-00601, [1:14]Sql syntax error: invalid variant/object name was found
alter tenant tenant$root default tablespace tnt_space2;--CT-00601, [1:14]Sql syntax error: invalid variant/object name was found
select TENANT_ID,NAME,SPACE_NUM,OPTIONS from sys_tenants order by tenant_id;
drop tenant if exists tnt1;

--5.��Դ��������Դ��ظ���
drop tenant if exists tnt1;
drop tenant if exists tnt2;
drop tenant if exists tnt3;
drop tenant if exists tnt4;
--����tenant
create tenant tnt1 tablespaces (tnt_space1);
create tenant tnt2 tablespaces (tnt_space2);
create tenant tnt3 tablespaces (tnt_space3);
create tenant tnt4 tablespaces (tnt_space4);
--����user
alter session set tenant=tnt1;
create user tnt1_user identified by Root1234;
grant dba to tnt1_user;
alter session set tenant=tnt2;
create user tnt2_user identified by Root1234;
grant dba to tnt2_user;
alter session set tenant=tnt3;
create user tnt3_user identified by Root1234;
grant dba to tnt3_user;
alter session set tenant=tnt4;
create user tnt4_user identified by Root1234;
grant dba to tnt4_user;
--������Դ����
alter session set tenant=tenant$root;
alter session set current_schema=sys;
call DBE_RSRC_MGR.CREATE_PLAN('tnt_plan', 'plan for tenant', 1);
call DBE_RSRC_MGR.CREATE_CONTROL_GROUP('tnt_group1', 'tenant group1 description');
call DBE_RSRC_MGR.CREATE_CONTROL_GROUP('tnt_group2', 'tenant group2 description');
call DBE_RSRC_MGR.add_tenant_to_control_group('tnt1', 'tnt_group1');
call DBE_RSRC_MGR.add_tenant_to_control_group('tnt2', 'tnt_group2');
call DBE_RSRC_MGR.add_tenant_to_control_group('tnt3', 'tnt_group2');
call DBE_RSRC_MGR.CREATE_PLAN_RULE('tnt_plan', 'tnt_group1', 'plan for tnt_group1', 40, 200, 200, 120, 1000, NULL, NULL, NULL);
call DBE_RSRC_MGR.CREATE_PLAN_RULE('tnt_plan', 'tnt_group2', 'plan for tnt_group2', 10, 20, 20, 10, 100, NULL, NULL, NULL);
alter system set resource_plan = 'tnt_plan';
--��ѯ���
select PLAN,NUM_PLAN_RULES,COMMENTS,TYPE# from ADM_RSRC_PLANS order by PLAN;
select CONTROL_GROUP,COMMENTS from ADM_RSRC_CONTROL_GROUPS order by CONTROL_GROUP;
select * from ADM_RSRC_GROUP_MAPPINGS order by VALUE;
select TENANT_NAME, SESSIONS, SESSION_LIMIT_HIT, ACTIVE_SESSIONS from DV_RSRC_MONITOR ORDER BY TENANT_NAME;
select * from DV_TENANT_TABLESPACES;
--��¼TNT1��tnt1_user��ѯ���
CONN tnt1_user/Root1234@127.0.0.1:1611/TNT1
select PLAN,NUM_PLAN_RULES,COMMENTS,TYPE# from ADM_RSRC_PLANS order by PLAN;
select CONTROL_GROUP,COMMENTS from ADM_RSRC_CONTROL_GROUPS order by CONTROL_GROUP;
select * from ADM_RSRC_GROUP_MAPPINGS order by VALUE;
select TENANT_NAME, SESSIONS, SESSION_LIMIT_HIT, ACTIVE_SESSIONS from DV_RSRC_MONITOR ORDER BY TENANT_NAME;
select * from DV_TENANT_TABLESPACES;
--��¼TNT2��tnt2_user��ѯ���
CONN tnt2_user/Root1234@127.0.0.1:1611/TNT2
select PLAN,NUM_PLAN_RULES,COMMENTS,TYPE# from ADM_RSRC_PLANS order by PLAN;
select CONTROL_GROUP,COMMENTS from ADM_RSRC_CONTROL_GROUPS order by CONTROL_GROUP;
select * from ADM_RSRC_GROUP_MAPPINGS order by VALUE;
select TENANT_NAME, SESSIONS, SESSION_LIMIT_HIT, ACTIVE_SESSIONS from DV_RSRC_MONITOR ORDER BY TENANT_NAME;
select * from DV_TENANT_TABLESPACES;
--��¼TNT3��tnt3_user��ѯ���
CONN tnt3_user/Root1234@127.0.0.1:1611/TNT3
select PLAN,NUM_PLAN_RULES,COMMENTS,TYPE# from ADM_RSRC_PLANS order by PLAN;
select CONTROL_GROUP,COMMENTS from ADM_RSRC_CONTROL_GROUPS order by CONTROL_GROUP;
select * from ADM_RSRC_GROUP_MAPPINGS order by VALUE;
select TENANT_NAME, SESSIONS, SESSION_LIMIT_HIT, ACTIVE_SESSIONS from DV_RSRC_MONITOR ORDER BY TENANT_NAME;
select * from DV_TENANT_TABLESPACES;
--��¼TNT4��tnt4_user��ѯ���
CONN tnt4_user/Root1234@127.0.0.1:1611/TNT4
select PLAN,NUM_PLAN_RULES,COMMENTS,TYPE# from ADM_RSRC_PLANS order by PLAN;
select CONTROL_GROUP,COMMENTS from ADM_RSRC_CONTROL_GROUPS order by CONTROL_GROUP;
select * from ADM_RSRC_GROUP_MAPPINGS order by VALUE;
select TENANT_NAME, SESSIONS, SESSION_LIMIT_HIT, ACTIVE_SESSIONS from DV_RSRC_MONITOR ORDER BY TENANT_NAME;
select * from DV_TENANT_TABLESPACES;
--��¼sys��ѯ���
CONN / AS SYSDBA
select PLAN,NUM_PLAN_RULES,COMMENTS,TYPE# from ADM_RSRC_PLANS order by PLAN;
select CONTROL_GROUP,COMMENTS from ADM_RSRC_CONTROL_GROUPS order by CONTROL_GROUP;
select * from ADM_RSRC_GROUP_MAPPINGS order by VALUE;
select TENANT_NAME, SESSIONS, SESSION_LIMIT_HIT, ACTIVE_SESSIONS from DV_RSRC_MONITOR ORDER BY TENANT_NAME;
select * from DV_TENANT_TABLESPACES ORDER BY TENANT_NAME;

--default group���⻧��ϸ�����
CONN / AS SYSDBA
select CONTROL_GROUP,COMMENTS from ADM_RSRC_CONTROL_GROUPS order by CONTROL_GROUP;
select TENANT_NAME, SESSIONS, SESSION_LIMIT_HIT, ACTIVE_SESSIONS from DV_RSRC_MONITOR ORDER BY TENANT_NAME;
call DBE_RSRC_MGR.add_tenant_to_control_group('tenant$root', 'tnt_group1');
alter system set resource_plan = 'tnt_plan';
CONN / AS SYSDBA
select CONTROL_GROUP,COMMENTS from ADM_RSRC_CONTROL_GROUPS order by CONTROL_GROUP;
select TENANT_NAME, SESSIONS, SESSION_LIMIT_HIT, ACTIVE_SESSIONS from DV_RSRC_MONITOR ORDER BY TENANT_NAME;
call DBE_RSRC_MGR.add_tenant_to_control_group('tenant$root', '');
alter system set resource_plan = 'tnt_plan';
CONN / AS SYSDBA
select CONTROL_GROUP,COMMENTS from ADM_RSRC_CONTROL_GROUPS order by CONTROL_GROUP;
select TENANT_NAME, SESSIONS, SESSION_LIMIT_HIT, ACTIVE_SESSIONS from DV_RSRC_MONITOR ORDER BY TENANT_NAME;


--������
alter system set resource_plan = '';
call DBE_RSRC_MGR.DELETE_PLAN('tnt_plan');
call DBE_RSRC_MGR.DELETE_CONTROL_GROUP('tnt_group1');
call DBE_RSRC_MGR.DELETE_CONTROL_GROUP('tnt_group2');
select PLAN,NUM_PLAN_RULES,COMMENTS,TYPE# from ADM_RSRC_PLANS order by PLAN;
select CONTROL_GROUP,COMMENTS from ADM_RSRC_CONTROL_GROUPS order by CONTROL_GROUP;
drop tenant if exists tnt1;
drop tenant if exists tnt2;
drop tenant if exists tnt3;
drop tenant if exists tnt4;
drop tenant if exists tnt1 cascade;
drop tenant if exists tnt2 cascade;
drop tenant if exists tnt3 cascade;
drop tenant if exists tnt4 cascade;

--6.���ʸ���
drop tenant if exists tnt1;
drop tenant if exists tnt2;
--����2��tenant
CONN / AS SYSDBA
create tenant tnt1 tablespaces (tnt_space1);
create tenant tnt2 tablespaces (tnt_space2);
alter session set tenant=tnt1;
create user tnt1_user1 identified by Root1234;
grant dba to tnt1_user1;
conn tnt1_user1/Root1234@127.0.0.1:1611/tnt1
--��tnt1��tnt1_user1�´�������ͬʱ���Է������

drop SEQUENCE if exists t1u1_seq1;
create SEQUENCE t1u1_seq1;
select t1u1_seq1.nextval;
select tnt1_user1.t1u1_seq1.nextval;
select tnt1$tnt1_user1.t1u1_seq1.nextval;
drop SEQUENCE t1u1_seq1;
create SEQUENCE tnt1_user1.t1u1_seq1;
select t1u1_seq1.nextval;
select tnt1_user1.t1u1_seq1.nextval;
select tnt1$tnt1_user1.t1u1_seq1.nextval;
drop SEQUENCE t1u1_seq1;
create SEQUENCE tnt1$tnt1_user1.t1u1_seq1;
select t1u1_seq1.nextval;
select tnt1_user1.t1u1_seq1.nextval;
select tnt1$tnt1_user1.t1u1_seq1.nextval;
drop table if exists t1u1_table1 cascade CONSTRAINTS;
create table t1u1_table1(c1 int);
insert into t1u1_table1 values(1);
insert into tnt1_user1.t1u1_table1 values(2);
insert into tnt1$tnt1_user1.t1u1_table1 values(3);
drop table if exists tnt1_user1.t1u1_table1 cascade CONSTRAINTS;
create table tnt1_user1.t1u1_table1(c1 int);
insert into t1u1_table1 values(1);
insert into tnt1_user1.t1u1_table1 values(2);
insert into tnt1$tnt1_user1.t1u1_table1 values(3);
drop table if exists tnt1$tnt1_user1.t1u1_table1 cascade CONSTRAINTS;
create table tnt1$tnt1_user1.t1u1_table1(c1 int);
insert into t1u1_table1 values(1);
insert into tnt1_user1.t1u1_table1 values(2);
insert into tnt1$tnt1_user1.t1u1_table1 values(3);
select * from t1u1_table1;
select * from tnt1_user1.t1u1_table1;
select * from tnt1$tnt1_user1.t1u1_table1;
update t1u1_table1 set t1u1_table1.c1=10 where c1=1;
update tnt1_user1.t1u1_table1 set tnt1_user1.t1u1_table1.c1=20 where c1=2;
update tnt1$tnt1_user1.t1u1_table1 set tnt1$tnt1_user1.t1u1_table1.c1=30 where c1=3;
select * from t1u1_table1;
select * from tnt1_user1.t1u1_table1;
select * from tnt1$tnt1_user1.t1u1_table1;
delete from t1u1_table1;
delete from tnt1_user1.t1u1_table1;
delete from tnt1$tnt1_user1.t1u1_table1;
insert into t1u1_table1 values(1);
drop view if exists t1u1_view1 cascade CONSTRAINTS;
create view t1u1_view1 as select * from t1u1_table1;
drop view if exists tnt1_user1.t1u1_view1 cascade CONSTRAINTS;
create view tnt1_user1.t1u1_view1 as select * from t1u1_table1;
drop view if exists tnt1$tnt1_user1.t1u1_view1 cascade CONSTRAINTS;
create view tnt1$tnt1_user1.t1u1_view1 as select * from t1u1_table1;
select * from t1u1_view1;
select * from tnt1_user1.t1u1_view1;
select * from tnt1$tnt1_user1.t1u1_view1;
create or replace synonym t1u1_synonym1 for t1u1_view1;
create or replace synonym tnt1_user1.t1u1_synonym1 for t1u1_view1;
create or replace synonym tnt1$tnt1_user1.t1u1_synonym1 for t1u1_view1;
select * from t1u1_synonym1;
select * from tnt1_user1.t1u1_synonym1;
select * from tnt1$tnt1_user1.t1u1_synonym1;
create or replace public synonym t1u1_synonym2 for t1u1_table1;
select * from t1u1_synonym2;
delete from t1u1_table1;
create or replace procedure t1u1_procedure1()
as
 begin
  insert into t1u1_table1 values(11);
  commit;
 end;
/
call t1u1_procedure1();
call tnt1_user1.t1u1_procedure1();
call tnt1$tnt1_user1.t1u1_procedure1();
select * from t1u1_table1;
delete from t1u1_table1;
create or replace procedure tnt1_user1.t1u1_procedure1()
as
 begin
  insert into t1u1_table1 values(22);
  commit;
 end;
/
call t1u1_procedure1();
call tnt1_user1.t1u1_procedure1();
call tnt1$tnt1_user1.t1u1_procedure1();
select * from t1u1_table1;
delete from t1u1_table1;
create or replace procedure tnt1$tnt1_user1.t1u1_procedure1()
as
 begin
  insert into t1u1_table1 values(33);
  commit;
 end;
/
call t1u1_procedure1();
call tnt1_user1.t1u1_procedure1();
call tnt1$tnt1_user1.t1u1_procedure1();
select * from t1u1_table1;
create or replace function t1u1_function1(val int) return int
as
 begin
  return val;
 end;
/
select t1u1_function1(147) from SYS_DUMMY;
select tnt1_user1.t1u1_function1(258) from SYS_DUMMY;
select tnt1$tnt1_user1.t1u1_function1(369) from SYS_DUMMY;
create or replace function tnt1_user1.t1u1_function1(val int) return int
as
 begin
  return val + 1;
 end;
/
select t1u1_function1(147) from SYS_DUMMY;
select tnt1_user1.t1u1_function1(258) from SYS_DUMMY;
select tnt1$tnt1_user1.t1u1_function1(369) from SYS_DUMMY;
create or replace function tnt1$tnt1_user1.t1u1_function1(val int) return int
as
 begin
  return val + 2;
 end;
/
select t1u1_function1(147) from SYS_DUMMY;
select tnt1_user1.t1u1_function1(258) from SYS_DUMMY;
select tnt1$tnt1_user1.t1u1_function1(369) from SYS_DUMMY;
delete from t1u1_table1;
create or replace trigger t1u1_trigger1 after insert on t1u1_table1
 begin
 	update t1u1_table1 set c1 = 5555;
 end;
/
call t1u1_procedure1();
select * from t1u1_table1;
delete from t1u1_table1;
create or replace trigger tnt1_user1.t1u1_trigger1 after insert on tnt1_user1.t1u1_table1
 begin
 	update tnt1_user1.t1u1_table1 set c1 = 6666;
 end;
/
call t1u1_procedure1();
select * from t1u1_table1;
delete from t1u1_table1;
create or replace trigger tnt1$tnt1_user1.t1u1_trigger1 after insert on tnt1$tnt1_user1.t1u1_table1
 begin
 	update tnt1$tnt1_user1.t1u1_table1 set c1 = 7777;
 end;
/
call t1u1_procedure1();
select * from t1u1_table1;
create or replace package t1u1_package1 
as
 FUNCTION f1 return int;
end;
/
create or replace package body t1u1_package1
as
 FUNCTION f1 return int
 as
  v1 int := 88888;
  begin
   return v1;
  end;
 end;
/
select t1u1_package1.f1() FROM SYS_DUMMY;
select tnt1_user1.t1u1_package1.f1() FROM SYS_DUMMY;
select tnt1$tnt1_user1.t1u1_package1.f1() FROM SYS_DUMMY;
create or replace package tnt1_user1.t1u1_package1 
as
 FUNCTION f1 return int;
end;
/
create or replace package body tnt1_user1.t1u1_package1
as
 FUNCTION f1 return int
 as
  v1 int := 99999;
  begin
   return v1;
  end;
 end;
/
select t1u1_package1.f1() FROM SYS_DUMMY;
select tnt1_user1.t1u1_package1.f1() FROM SYS_DUMMY;
select tnt1$tnt1_user1.t1u1_package1.f1() FROM SYS_DUMMY;
create or replace package tnt1$tnt1_user1.t1u1_package1 
as
 FUNCTION f1 return int;
end;
/
create or replace package body tnt1$tnt1_user1.t1u1_package1
as
 FUNCTION f1 return int
 as
  v1 int := 10101010;
  begin
   return v1;
  end;
 end;
/
select t1u1_package1.f1() FROM SYS_DUMMY;
select tnt1_user1.t1u1_package1.f1() FROM SYS_DUMMY;
select tnt1$tnt1_user1.t1u1_package1.f1() FROM SYS_DUMMY;
--��root����һ���û�sys_user1�����Է��ʸ���
conn / as sysdba
create user sys_user1 identified by Root1234;
grant dba to sys_user1;
--��¼sys_user1
conn sys_user1/Root1234@127.0.0.1:1611
select sys_context('USERENV', 'TENANT_NAME');
select t1u1_seq1.nextval;
select tnt1_user1.t1u1_seq1.nextval;
select tnt1$tnt1_user1.t1u1_seq1.nextval;
delete from t1u1_table1;--CT-00843, [1:13]The table or view SYS_USER1.T1U1_TABLE1 does not exist.
delete from tnt1_user1.t1u1_table1;--CT-00781, [1:13]The user TNT1_USER1 does not exist.
delete from tnt1$tnt1_user1.t1u1_table1;
insert into t1u1_table1 values(1);--CT-00843, [1:13]The table or view SYS_USER1.T1U1_TABLE1 does not exist.
insert into tnt1_user1.t1u1_table1 values(2);--CT-00781, [1:13]The user TNT1_USER1 does not exist.
insert into tnt1$tnt1_user1.t1u1_table1 values(3);
select * from t1u1_table1;--CT-00843, [1:15]The table or view SYS_USER1.T1U1_TABLE1 does not exist.
select * from tnt1_user1.t1u1_table1;--CT-00781, [1:15]The user TNT1_USER1 does not exist.
select * from tnt1$tnt1_user1.t1u1_table1;
select * from t1u1_view1;--CT-00843, [1:15]The table or view SYS_USER1.T1U1_VIEW1 does not exist.
select * from tnt1_user1.t1u1_view1;--CT-00781, [1:15]The user TNT1_USER1 does not exist.
select * from tnt1$tnt1_user1.t1u1_view1;
select * from t1u1_synonym1;--CT-00843, [1:15]The table or view SYS_USER1.T1U1_SYNONYM1 does not exist.
select * from tnt1_user1.t1u1_synonym1;--CT-00781, [1:15]The user TNT1_USER1 does not exist.
select * from tnt1$tnt1_user1.t1u1_synonym1;
select * from t1u1_synonym2;
call t1u1_procedure1();--[1:2] PLC-00828 procedure SYS_USER1.T1U1_PROCEDURE1 does not exist
call tnt1_user1.t1u1_procedure1();--[1:2] PLC-00828 procedure TNT1_USER1.T1U1_PROCEDURE1 does not exist
call tnt1$tnt1_user1.t1u1_procedure1();
select t1u1_function1(147) from SYS_DUMMY;--CT-00828, [1:8]function SYS_USER1.T1U1_FUNCTION1 does not exist
select tnt1_user1.t1u1_function1(258) from SYS_DUMMY;--CT-00828, [1:8]function TNT1_USER1.T1U1_FUNCTION1 does not exist
select tnt1$tnt1_user1.t1u1_function1(369) from SYS_DUMMY;
select t1u1_package1.f1() FROM SYS_DUMMY;--CT-00828, [1:8]function T1U1_PACKAGE1.F1 does not exist
select tnt1_user1.t1u1_package1.f1() FROM SYS_DUMMY;--CT-00828, [1:8]function TNT1_USER1.T1U1_PACKAGE1.F1 does not exist
select tnt1$tnt1_user1.t1u1_package1.f1() FROM SYS_DUMMY;
--tenant�л���tnt1��schema�л���tnt1_user2
alter session set tenant=tnt1;
create user tnt1_user2 identified by Root1234;
grant dba to tnt1_user2;
alter session set current_schema=tnt1_user2;
select sys_context('USERENV', 'TENANT_NAME');
select sys_context('USERENV', 'CURRENT_SCHEMA');
select t1u1_seq1.nextval;
select tnt1_user1.t1u1_seq1.nextval;
select tnt1$tnt1_user1.t1u1_seq1.nextval;
delete from t1u1_table1;--CT-00843, [1:13]The table or view TNT1$TNT1_USER2.T1U1_TABLE1 does not exist.
delete from tnt1_user1.t1u1_table1;
delete from tnt1$tnt1_user1.t1u1_table1;
insert into t1u1_table1 values(1);--CT-00843, [1:13]The table or view TNT1$TNT1_USER2.T1U1_TABLE1 does not exist.
insert into tnt1_user1.t1u1_table1 values(2);
insert into tnt1$tnt1_user1.t1u1_table1 values(3);
select * from t1u1_table1;--CT-00843, [1:15]The table or view TNT1$TNT1_USER2.T1U1_TABLE1 does not exist.
select * from tnt1_user1.t1u1_table1;
select * from tnt1$tnt1_user1.t1u1_table1;
select * from t1u1_view1;--CT-00843, [1:15]The table or view TNT1$TNT1_USER2.T1U1_VIEW1 does not exist.
select * from tnt1_user1.t1u1_view1;
select * from tnt1$tnt1_user1.t1u1_view1;
select * from t1u1_synonym1;--CT-00843, [1:15]The table or view TNT1$TNT1_USER2.T1U1_SYNONYM1 does not exist.
select * from tnt1_user1.t1u1_synonym1;
select * from tnt1$tnt1_user1.t1u1_synonym1;
select * from t1u1_synonym2;
call t1u1_procedure1();--[1:2] PLC-00828 procedure TNT1$TNT1_USER2.T1U1_PROCEDURE1 does not exist
call tnt1_user1.t1u1_procedure1();
call tnt1$tnt1_user1.t1u1_procedure1();
select t1u1_function1(147) from SYS_DUMMY;--CT-00828, [1:8]function TNT1$TNT1_USER2.T1U1_FUNCTION1 does not exist
select tnt1_user1.t1u1_function1(258) from SYS_DUMMY;
select tnt1$tnt1_user1.t1u1_function1(369) from SYS_DUMMY;
select t1u1_package1.f1() FROM SYS_DUMMY;--CT-00828, [1:8]function TNT1$T1U1_PACKAGE1.F1 does not exist
select tnt1_user1.t1u1_package1.f1() FROM SYS_DUMMY;
select tnt1$tnt1_user1.t1u1_package1.f1() FROM SYS_DUMMY;
--schema�л���tnt1_user1
alter session set current_schema=tnt1_user1;
select sys_context('USERENV', 'TENANT_NAME');
select sys_context('USERENV', 'CURRENT_SCHEMA');
select t1u1_seq1.nextval;
select tnt1_user1.t1u1_seq1.nextval;
select tnt1$tnt1_user1.t1u1_seq1.nextval;
delete from t1u1_table1;
delete from tnt1_user1.t1u1_table1;
delete from tnt1$tnt1_user1.t1u1_table1;
insert into t1u1_table1 values(1);
insert into tnt1_user1.t1u1_table1 values(2);
insert into tnt1$tnt1_user1.t1u1_table1 values(3);
select * from t1u1_table1;
select * from tnt1_user1.t1u1_table1;
select * from tnt1$tnt1_user1.t1u1_table1;
select * from t1u1_view1;
select * from tnt1_user1.t1u1_view1;
select * from tnt1$tnt1_user1.t1u1_view1;
select * from t1u1_synonym1;
select * from tnt1_user1.t1u1_synonym1;
select * from tnt1$tnt1_user1.t1u1_synonym1;
select * from t1u1_synonym2;
call t1u1_procedure1();
call tnt1_user1.t1u1_procedure1();
call tnt1$tnt1_user1.t1u1_procedure1();
select t1u1_function1(147) from SYS_DUMMY;
select tnt1_user1.t1u1_function1(258) from SYS_DUMMY;
select tnt1$tnt1_user1.t1u1_function1(369) from SYS_DUMMY;
select t1u1_package1.f1() FROM SYS_DUMMY;
select tnt1_user1.t1u1_package1.f1() FROM SYS_DUMMY;
select tnt1$tnt1_user1.t1u1_package1.f1() FROM SYS_DUMMY;
--��tnt2�����û�tnt2_user1
conn / as sysdba
alter session set tenant=tnt2;
create user tnt2_user1 identified by Root1234;
grant dba to tnt2_user1;
--��¼tnt2��tnt2_user1�����Է���tnt1_user1�µĶ���
conn tnt2_user1/Root1234@127.0.0.1:1611/tnt2
select sys_context('USERENV', 'TENANT_NAME');
select sys_context('USERENV', 'CURRENT_SCHEMA');
select t1u1_seq1.nextval;
select tnt1_user1.t1u1_seq1.nextval;
select tnt1$tnt1_user1.t1u1_seq1.nextval;
delete from t1u1_table1;--CT-00843, [1:13]The table or view TNT2$TNT2_USER1.T1U1_TABLE1 does not exist.
delete from tnt1_user1.t1u1_table1;--CT-00781, [1:13]The user TNT2$TNT1_USER1 does not exist.
delete from tnt1$tnt1_user1.t1u1_table1;--CT-01001, Permissions were insufficient
insert into t1u1_table1 values(1);--CT-00843, [1:13]The table or view TNT2$TNT2_USER1.T1U1_TABLE1 does not exist.
insert into tnt1_user1.t1u1_table1 values(2);--CT-00781, [1:13]The user TNT2$TNT1_USER1 does not exist.
insert into tnt1$tnt1_user1.t1u1_table1 values(3);--CT-01001, [1:13]Permissions were insufficient
select * from t1u1_table1;--CT-00843, [1:15]The table or view TNT2$TNT2_USER1.T1U1_TABLE1 does not exist.
select * from tnt1_user1.t1u1_table1;--CT-00781, [1:15]The user TNT2$TNT1_USER1 does not exist.
select * from tnt1$tnt1_user1.t1u1_table1;--CT-01001, [1:15]Permissions were insufficient
select * from t1u1_view1;--CT-00843, [1:15]The table or view TNT2$TNT2_USER1.T1U1_VIEW1 does not exist.
select * from tnt1_user1.t1u1_view1;--CT-00781, [1:15]The user TNT2$TNT1_USER1 does not exist.
select * from tnt1$tnt1_user1.t1u1_view1;--CT-01001, [1:15]Permissions were insufficient
select * from t1u1_synonym1;--CT-00843, [1:15]The table or view TNT2$TNT2_USER1.T1U1_SYNONYM1 does not exist.
select * from tnt1_user1.t1u1_synonym1;--CT-00781, [1:15]The user TNT2$TNT1_USER1 does not exist.
select * from tnt1$tnt1_user1.t1u1_synonym1;--CT-01001, [1:15]Permissions were insufficient
delete from t1u1_synonym2;
insert into t1u1_synonym2 values(11);
select * from t1u1_synonym2;
update t1u1_synonym2 set c1=66666;
select * from t1u1_synonym2;
call t1u1_procedure1();--[1:2] PLC-00828 procedure TNT2$TNT2_USER1.T1U1_PROCEDURE1 does not exist
call tnt1_user1.t1u1_procedure1();--[1:2] PLC-00828 procedure TNT2$TNT1_USER1.T1U1_PROCEDURE1 does not exist
call tnt1$tnt1_user1.t1u1_procedure1();--CT-01001, Permissions were insufficient
select t1u1_function1(147) from SYS_DUMMY;--CT-00828, [1:8]function TNT2$TNT2_USER1.T1U1_FUNCTION1 does not exist
select tnt1_user1.t1u1_function1(258) from SYS_DUMMY;--CT-00828, [1:8]function TNT2$TNT1_USER1.T1U1_FUNCTION1 does not exist
select tnt1$tnt1_user1.t1u1_function1(369) from SYS_DUMMY;--CT-01001, Permissions were insufficient
select t1u1_package1.f1() FROM SYS_DUMMY;--CT-00828, [1:8]function TNT2$T1U1_PACKAGE1.F1 does not exist
select tnt1_user1.t1u1_package1.f1() FROM SYS_DUMMY;--CT-00828, [1:8]function TNT2$TNT1_USER1.T1U1_PACKAGE1.F1 does not exist
select tnt1$tnt1_user1.t1u1_package1.f1() FROM SYS_DUMMY;--CT-01001, Permissions were insufficient

--��ϵͳ��ͼ�ķ��ʸ���
conn / as sysdba
--tenant�л���tnt1��schema�л���tnt1_user1
alter session set tenant=tnt1;
alter session set current_schema=tnt1_user1;
select USERNAME,DEFAULT_TABLESPACE,TEMPORARY_TABLESPACE,INITIAL_RSRC_CONSUMER_GROUP from adm_users where USERNAME like 'TNT%' order by USERNAME;
--tenant�л���tnt2��schema�л���tnt2_user1
alter session set tenant=tnt2;
alter session set current_schema=tnt2_user1;
select USERNAME,DEFAULT_TABLESPACE,TEMPORARY_TABLESPACE,INITIAL_RSRC_CONSUMER_GROUP from adm_users where USERNAME like 'TNT%' order by USERNAME;
--tenant�л���tenant$root��schema�л���sys
alter session set tenant=tenant$root;
alter session set current_schema=sys;
select USERNAME,DEFAULT_TABLESPACE,TEMPORARY_TABLESPACE,INITIAL_RSRC_CONSUMER_GROUP from adm_users where USERNAME like 'TNT%' order by USERNAME;

conn / as sysdba
select USERNAME,DEFAULT_TABLESPACE,TEMPORARY_TABLESPACE,INITIAL_RSRC_CONSUMER_GROUP from adm_users where USERNAME like 'TNT%' order by USERNAME;
conn tnt1_user1/Root1234@127.0.0.1:1611/tnt1
select USERNAME,DEFAULT_TABLESPACE,TEMPORARY_TABLESPACE,INITIAL_RSRC_CONSUMER_GROUP from adm_users where USERNAME like 'TNT%' order by USERNAME;
conn tnt2_user1/Root1234@127.0.0.1:1611/tnt2
select USERNAME,DEFAULT_TABLESPACE,TEMPORARY_TABLESPACE,INITIAL_RSRC_CONSUMER_GROUP from adm_users where USERNAME like 'TNT%' order by USERNAME;

--7.Ȩ��
--alter session
conn tnt1_user1/Root1234@127.0.0.1:1611/tnt1
alter session set tenant=tnt1;--CT-01001, Permissions were insufficient
alter session set tenant=tnt2;--CT-01001, Permissions were insufficient
alter session set tenant=tenant$root;--CT-01001, Permissions were insufficient
conn / as sysdba
alter session set tenant=tnt1;
select sys_context('USERENV', 'TENANT_NAME');
select sys_context('USERENV', 'CURRENT_SCHEMA');
alter session set current_schema=tnt1_user1;
select sys_context('USERENV', 'TENANT_NAME');
select sys_context('USERENV', 'CURRENT_SCHEMA');
alter session set current_schema=tnt1_user2;
select sys_context('USERENV', 'TENANT_NAME');
select sys_context('USERENV', 'CURRENT_SCHEMA');
alter session set tenant=tnt2;
select sys_context('USERENV', 'TENANT_NAME');
select sys_context('USERENV', 'CURRENT_SCHEMA');
alter session set tenant=tenant$root;
select sys_context('USERENV', 'TENANT_NAME');
select sys_context('USERENV', 'CURRENT_SCHEMA');
--ALTER CURRENT_SCHEMA
conn tnt1_user1/Root1234@127.0.0.1:1611/tnt1
select sys_context('USERENV', 'TENANT_NAME');
select sys_context('USERENV', 'CURRENT_SCHEMA');
alter session set current_schema=tnt1_user1;
select sys_context('USERENV', 'TENANT_NAME');
select sys_context('USERENV', 'CURRENT_SCHEMA');
alter session set current_schema=tnt1_user2;
select sys_context('USERENV', 'TENANT_NAME');
select sys_context('USERENV', 'CURRENT_SCHEMA');

--create/alter/drop tenant
conn tnt1_user1/Root1234@127.0.0.1:1611/tnt1
create tenant tnt3 tablespaces (tnt_space1);--CT-01001, Permissions were insufficient
alter tenant tnt1 add tablespaces (tnt_space2);--CT-01001, Permissions were insufficient
alter tenant tnt2 add tablespaces (tnt_space3);--CT-01001, Permissions were insufficient
alter tenant tnt3 add tablespaces (tnt_space4);--CT-01001, Permissions were insufficient
alter tenant tnt1 default tablespace tnt_space1;--CT-01001, Permissions were insufficient
alter tenant tnt2 default tablespace tnt_space2;--CT-01001, Permissions were insufficient
alter tenant tnt3 default tablespace tnt_space3;--CT-01001, Permissions were insufficient
drop tenant tnt1;--CT-01001, Permissions were insufficient
drop tenant tnt2;--CT-01001, Permissions were insufficient
drop tenant tnt3;--CT-01001, Permissions were insufficient
drop tenant tnt1 cascade;--CT-01001, Permissions were insufficient
drop tenant tnt2 cascade;--CT-01001, Permissions were insufficient
drop tenant tnt3 cascade;--CT-01001, Permissions were insufficient
--CREATE/ALTER/DROPֻ�ܶԵ�ǰtenant�е�USER���в���
alter user tnt1_user1 default tablespace tnt_space2;
alter user tnt1_user2 default tablespace tnt_space1;
alter user sys_user1 default tablespace tnt_space2;
alter user tnt2$tnt2_user1 default tablespace tnt_space1;
drop user sys_user1 cascade;
drop user tnt1_user2 cascade;
drop user tnt2$tnt2_user1 cascade;
conn / as sysdba
drop user sys_user1 cascade;
drop user tnt2$tnt2_user1 cascade;
alter session set tenant=tnt1;
drop user tnt1_user1 cascade;
alter session set tenant=tnt2;
drop user tnt2_user1 cascade;

--8.SPACE����
conn / as sysdba
drop user if exists sys_user1;
drop tenant if exists tnt1 cascade;
drop tenant if exists tnt2 cascade;
CREATE TENANT TNT1 TABLESPACES (tnt_space1,tnt_space3);
CREATE TENANT TNT2 TABLESPACES (tnt_space2);
--��ͼDV_TABLESPACES/DV_TENANT_TABLESPACES
SELECT NAME FROM DV_TABLESPACES WHERE ID <=6 OR NAME LIKE 'TNT%' ORDER BY NAME;
SELECT * FROM DV_TENANT_TABLESPACES ORDER BY TABLESPACE_NAME;
ALTER SESSION SET TENANT=TNT1;
CREATE USER TNT1_USER1 IDENTIFIED BY Root1234;
GRANT DBA TO TNT1_USER1;
CONN TNT1_USER1/Root1234@127.0.0.1:1611/TNT1
--��ͼDV_TABLESPACES/DV_TENANT_TABLESPACES
SELECT NAME FROM DV_TABLESPACES WHERE ID <=6 OR NAME LIKE 'TNT%' ORDER BY NAME;
SELECT * FROM DV_TENANT_TABLESPACES ORDER BY TABLESPACE_NAME;
--��ͨ��
CREATE TABLE T01(C1 INT, C2 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C2) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T02(C1 INT, C2 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space2) TABLESPACE tnt_space1 LOB(C2) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T03(C1 INT, C2 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) TABLESPACE tnt_space2 LOB(C2) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T04(C1 INT, C2 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C2) STORE AS (TABLESPACE tnt_space2);
--RANGE������
CREATE TABLE T11(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY RANGE(C2) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T12(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space2) PARTITION BY RANGE(C2) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T13(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY RANGE(C2) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space2, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T14(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY RANGE(C2) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space2) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T15(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY RANGE(C2) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space2) TABLESPACE tnt_space2 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T16(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY RANGE(C2) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space2) TABLESPACE tnt_space2 LOB(C3) STORE AS (TABLESPACE tnt_space2);
--RANGE������using index LOCAL
CREATE TABLE T21(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index LOCAL (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1)) PARTITION BY RANGE(C1) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T22(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index LOCAL (PARTITION P1 TABLESPACE tnt_space2, PARTITION P2 TABLESPACE tnt_space1)) PARTITION BY RANGE(C1) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T23(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index LOCAL (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space2)) PARTITION BY RANGE(C1) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T24(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index LOCAL (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1)) PARTITION BY RANGE(C1) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space2, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T25(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index LOCAL (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1)) PARTITION BY RANGE(C1) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space2) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T26(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index LOCAL (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1)) PARTITION BY RANGE(C1) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space1) TABLESPACE tnt_space2 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T27(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index LOCAL (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1)) PARTITION BY RANGE(C1) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space2);
--LIST������
CREATE TABLE T31(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY LIST(C2) (PARTITION P1 VALUES (100) TABLESPACE tnt_space1, PARTITION P2 VALUES (200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T32(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space2) PARTITION BY LIST(C2) (PARTITION P1 VALUES (100) TABLESPACE tnt_space1, PARTITION P2 VALUES (200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T33(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY LIST(C2) (PARTITION P1 VALUES (100) TABLESPACE tnt_space2, PARTITION P2 VALUES (200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T34(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY LIST(C2) (PARTITION P1 VALUES (100) TABLESPACE tnt_space1, PARTITION P2 VALUES (200) TABLESPACE tnt_space2) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T35(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY LIST(C2) (PARTITION P1 VALUES (100) TABLESPACE tnt_space1, PARTITION P2 VALUES (200) TABLESPACE tnt_space1) TABLESPACE tnt_space2 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T36(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY LIST(C2) (PARTITION P1 VALUES (100) TABLESPACE tnt_space1, PARTITION P2 VALUES (200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space2);
--LIST������using index LOCAL
CREATE TABLE T41(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index LOCAL (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1)) PARTITION BY LIST(C1) (PARTITION P1 VALUES (100) TABLESPACE tnt_space1, PARTITION P2 VALUES (200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T42(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index LOCAL (PARTITION P1 TABLESPACE tnt_space2, PARTITION P2 TABLESPACE tnt_space1)) PARTITION BY LIST(C1) (PARTITION P1 VALUES (100) TABLESPACE tnt_space1, PARTITION P2 VALUES (200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T43(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index LOCAL (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space2)) PARTITION BY LIST(C1) (PARTITION P1 VALUES (100) TABLESPACE tnt_space1, PARTITION P2 VALUES (200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T44(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index LOCAL (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1)) PARTITION BY LIST(C1) (PARTITION P1 VALUES (100) TABLESPACE tnt_space2, PARTITION P2 VALUES (200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T45(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index LOCAL (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1)) PARTITION BY LIST(C1) (PARTITION P1 VALUES (100) TABLESPACE tnt_space1, PARTITION P2 VALUES (200) TABLESPACE tnt_space2) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T46(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index LOCAL (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1)) PARTITION BY LIST(C1) (PARTITION P1 VALUES (100) TABLESPACE tnt_space1, PARTITION P2 VALUES (200) TABLESPACE tnt_space1) TABLESPACE tnt_space2 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T47(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index LOCAL (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1)) PARTITION BY LIST(C1) (PARTITION P1 VALUES (100) TABLESPACE tnt_space1, PARTITION P2 VALUES (200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space2);
--HASH������
CREATE TABLE T51(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY HASH(C2) (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T52(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space2) PARTITION BY HASH(C2) (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T53(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY HASH(C2) (PARTITION P1 TABLESPACE tnt_space2, PARTITION P2 TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T54(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY HASH(C2) (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space2) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T55(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY HASH(C2) (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1) TABLESPACE tnt_space2 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T56(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY HASH(C2) (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space2);
--HASH������PARTITIONS
CREATE TABLE T61(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY HASH(C2) PARTITIONS 10 STORE IN (tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T62(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space2) PARTITION BY HASH(C2) PARTITIONS 10 STORE IN (tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T63(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY HASH(C2) PARTITIONS 10 STORE IN (tnt_space2) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T64(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY HASH(C2) PARTITIONS 10 STORE IN (tnt_space1) TABLESPACE tnt_space2 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T65(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY HASH(C2) PARTITIONS 10 STORE IN (tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space2);
--RANGE������INTERVAL
CREATE TABLE T71(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY RANGE(C2) INTERVAL(100) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T72(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space2) PARTITION BY RANGE(C2) INTERVAL(100) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T73(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY RANGE(C2) INTERVAL(100) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space2, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T74(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY RANGE(C2) INTERVAL(100) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space2) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T75(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY RANGE(C2) INTERVAL(100) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space1) TABLESPACE tnt_space2 LOB(C3) STORE AS (TABLESPACE tnt_space1);
CREATE TABLE T76(C1 INT, C2 INT, C3 CLOB, PRIMARY KEY (C1) using index TABLESPACE tnt_space1) PARTITION BY RANGE(C2) INTERVAL(100) (PARTITION P1 VALUES LESS THAN(100) TABLESPACE tnt_space1, PARTITION P2 VALUES LESS THAN(200) TABLESPACE tnt_space1) TABLESPACE tnt_space1 LOB(C3) STORE AS (TABLESPACE tnt_space2);
--CREATE/ALTER USER
CREATE USER TNT1_USER2 IDENTIFIED BY Root1234 DEFAULT TABLESPACE tnt_space2;
CREATE USER TNT1_USER3 IDENTIFIED BY Root1234 DEFAULT TABLESPACE tnt_space1;
ALTER USER TNT1_USER3 DEFAULT TABLESPACE tnt_space2;
ALTER USER TNT1_USER3 DEFAULT TABLESPACE tnt_space3;
--NORMAL TABLE INDEX/ALTER TABLE ADD CONSTRAINT
CREATE TABLE T81(C1 INT, C2 INT);
CREATE INDEX I81 ON T81(C1) TABLESPACE tnt_space1;
CREATE INDEX I82 ON T81(C2) TABLESPACE tnt_space2;
ALTER TABLE T81 ADD CONSTRAINT CONS UNIQUE(C2) USING INDEX TABLESPACE tnt_space2;
ALTER TABLE T81 ADD CONSTRAINT CONS UNIQUE(C2) USING INDEX TABLESPACE tnt_space1;
--PARTITION TABLE INDEX/ALTER TABLE ADD PARTITION
CREATE TABLE T91(C1 INT, C2 INT, C3 INT, C4 INT) PARTITION BY RANGE(C1) (PARTITION P1 VALUES LESS THAN(100), PARTITION P2 VALUES LESS THAN(200));
CREATE INDEX I91 ON T91(C1) TABLESPACE tnt_space1 LOCAL (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1);
CREATE INDEX I92 ON T91(C2) TABLESPACE tnt_space2 LOCAL (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space1);
CREATE INDEX I93 ON T91(C3) TABLESPACE tnt_space1 LOCAL (PARTITION P1 TABLESPACE tnt_space2, PARTITION P2 TABLESPACE tnt_space1);
CREATE INDEX I94 ON T91(C4) TABLESPACE tnt_space1 LOCAL (PARTITION P1 TABLESPACE tnt_space1, PARTITION P2 TABLESPACE tnt_space2);
ALTER TABLE T91 ADD PARTITION P3 VALUES LESS THAN(300) TABLESPACE tnt_space2;
ALTER TABLE T91 ADD PARTITION P3 VALUES LESS THAN(300) TABLESPACE tnt_space1;
--PUEGE TABLESPACE
PURGE TABLESPACE tnt_space1;
PURGE TABLESPACE tnt_space2;

--������
conn / as sysdba
DROP TENANT IF EXISTS TNT1 CASCADE;
DROP TENANT IF EXISTS TNT2 CASCADE;
DROP TABLESPACE TNT_SPACE1;
DROP TABLESPACE TNT_SPACE2;
DROP TABLESPACE TNT_SPACE3;
DROP TABLESPACE TNT_SPACE4;

--DTS202006090RCU19P0J00 �ڸ��⻧�п��������л�schema���ڷǸ��⻧���л��������⻧schema������Ч�Ĳ���
conn / AS SYSDBA
create tenant tnt1 tablespaces (users);
alter session set tenant=tnt1;
create user tnt1_user identified by Root1234;
grant dba to tnt1_user;

conn / AS SYSDBA
create tenant tnt2 tablespaces (users);
alter session set tenant=tnt2;
create user tnt2_user identified by Root1234;
grant dba to tnt2_user;


conn tnt1_user/Root1234@127.0.0.1:1611/tnt1
alter session set tenant=tnt1;
alter session set current_schema=tnt1$tnt1_user;
alter session set current_schema=tnt1_user;
alter session set current_schema=sys;
alter session set current_schema=tnt2$tnt2_user;

conn / as sysdba
alter session set tenant=tnt1;
alter session set current_schema=tnt1$tnt1_user;
alter session set current_schema=tnt1_user;
alter session set current_schema=sys;
alter session set current_schema=tnt2$tnt2_user;
alter session set tenant=TENANT$ROOT;
alter session set current_schema=sys;
DROP TENANT tnt1 CASCADE;
DROP TENANT tnt2 CASCADE;

--DTS20200611032MWWP0H00 
CONN / AS SYSDBA
DROP TENANT IF EXISTS TNT1 CASCADE;
create tenant tnt1 tablespaces (USERS);
alter session set tenant=tnt1;
create user tnt1_user identified by Root1234;
grant dba to tnt1_user;
CONN tnt1_user/Root1234@127.0.0.1:1611/TNT1
CREATE TABLE T1(C1 INT);
exec dbe_stats.collect_table_stats('tnt1_user', 'T1',null, 100, true,null);
exec dbe_stats.collect_table_stats('TNT1$tnt1_user', 'T1',null, 100, true,null);
exec dbe_stats.collect_table_stats('tnt2_user', 'T1',null, 100, true,null);
CONN / AS SYSDBA
DROP TENANT TNT1 CASCADE;

--DTS202006150G9T5AP1400
CONN / AS SYSDBA
call DBE_RSRC_MGR.CREATE_PLAN('tnt_plan', 'plan for tenant', 1);
call DBE_RSRC_MGR.CREATE_CONTROL_GROUP('tnt_group1', 'tenant group1 description');
call DBE_RSRC_MGR.CREATE_CONTROL_GROUP('tnt_group2', 'tenant group2 description');
call DBE_RSRC_MGR.add_tenant_to_control_group('tnt1', 'tnt_group1');
call DBE_RSRC_MGR.add_tenant_to_control_group('tnt2', 'tnt_group2');
call DBE_RSRC_MGR.add_user_to_control_group('user1', 'tnt_group1');
call DBE_RSRC_MGR.add_user_to_control_group('user2', 'tnt_group2');
select *from sys_rsrc_group_mappings order by VALUE;
call DBE_RSRC_MGR.add_tenant_to_control_group('tnt1', 'tnt_group2');
call DBE_RSRC_MGR.add_tenant_to_control_group('tnt2', 'tnt_group1');
call DBE_RSRC_MGR.add_user_to_control_group('user1', 'tnt_group2');
call DBE_RSRC_MGR.add_user_to_control_group('user2', 'tnt_group1');
select *from sys_rsrc_group_mappings order by VALUE;
call DBE_RSRC_MGR.add_tenant_to_control_group('tnt1', '');
call DBE_RSRC_MGR.add_tenant_to_control_group('tnt2', null);
call DBE_RSRC_MGR.add_user_to_control_group('user1', '');
call DBE_RSRC_MGR.add_user_to_control_group('user2', null);
select *from sys_rsrc_group_mappings order by VALUE;
call DBE_RSRC_MGR.add_tenant_to_control_group('tnt1', '');
call DBE_RSRC_MGR.add_tenant_to_control_group('tnt2', null);
call DBE_RSRC_MGR.add_user_to_control_group('user1', '');
call DBE_RSRC_MGR.add_user_to_control_group('user2', null);
select *from sys_rsrc_group_mappings order by VALUE;
call DBE_RSRC_MGR.DELETE_PLAN('tnt_plan');
call DBE_RSRC_MGR.DELETE_CONTROL_GROUP('tnt_group1');
call DBE_RSRC_MGR.DELETE_CONTROL_GROUP('tnt_group2');

--DTS202006160HTXSNP1400
CONN / AS SYSDBA
DROP TENANT IF EXISTS TNT1 CASCADE;
DROP TENANT IF EXISTS TNT2 CASCADE;
create tenant tnt1 tablespaces (USERS);
create tenant tnt2 tablespaces (USERS);
alter session set tenant=tnt1;
create user tnt1_user1 identified by Root1234;
grant dba to tnt1_user1;
create user tnt1_user2 identified by Root1234;
grant dba to tnt1_user2;
alter session set tenant=tnt2;
create user tnt2_user1 identified by Root1234;
grant dba to tnt2_user1;
CONN tnt1_user1/Root1234@127.0.0.1:1611/TNT1
CREATE TABLE T1U1_T1(C1 INT);
CREATE VIEW T1U1_V1 AS SELECT * FROM T1U1_T1;
CREATE VIEW T1U1_V2 AS SELECT * FROM T1U1_V1;
SELECT * FROM DB_DEPENDENCIES ORDER BY NAME;
SELECT * FROM ADM_DEPENDENCIES ORDER BY NAME;
SELECT * FROM DB_VIEW_DEPENDENCIES ORDER BY NAME;
CONN tnt1_user2/Root1234@127.0.0.1:1611/TNT1
CREATE TABLE T1U2_T1(C1 INT);
CREATE VIEW T1U2_V1 AS SELECT * FROM T1U2_T1;
CREATE VIEW T1U2_V2 AS SELECT * FROM T1U2_V1;
SELECT * FROM DB_DEPENDENCIES ORDER BY NAME;
SELECT * FROM ADM_DEPENDENCIES ORDER BY NAME;
SELECT * FROM DB_VIEW_DEPENDENCIES ORDER BY NAME;
CONN tnt2_user1/Root1234@127.0.0.1:1611/TNT2
CREATE TABLE T2U1_T1(C1 INT);
CREATE VIEW T2U1_V1 AS SELECT * FROM T2U1_T1;
CREATE VIEW T2U1_V2 AS SELECT * FROM T2U1_V1;
SELECT * FROM DB_DEPENDENCIES ORDER BY NAME;
SELECT * FROM ADM_DEPENDENCIES ORDER BY NAME;
SELECT * FROM DB_VIEW_DEPENDENCIES ORDER BY NAME;
CONN / AS SYSDBA
alter session set tenant=tnt1;
alter session set current_schema=tnt1_user1;
SELECT * FROM DB_DEPENDENCIES ORDER BY NAME;
SELECT * FROM ADM_DEPENDENCIES ORDER BY NAME;
SELECT * FROM DB_VIEW_DEPENDENCIES ORDER BY NAME;
alter session set tenant=tnt2;
alter session set current_schema=tnt2_user1;
SELECT * FROM DB_DEPENDENCIES ORDER BY NAME;
SELECT * FROM ADM_DEPENDENCIES ORDER BY NAME;
SELECT * FROM DB_VIEW_DEPENDENCIES ORDER BY NAME;
DROP TENANT IF EXISTS TNT1 CASCADE;
DROP TENANT IF EXISTS TNT2 CASCADE;

--DBE_MASK_DATA
conn / as sysdba
drop TENANT if exists tenant_management_018_01 cascade;
CREATE TENANT tenant_management_018_01 TABLESPACES (users) DEFAULT TABLESPACE users;
ALTER SESSION SET TENANT=tenant_management_018_01;
drop user if exists tenant_management_dba cascade;
create user tenant_management_dba identified by Cantian_234;
grant dba to tenant_management_dba;
ALTER SESSION SET current_schema='tenant_management_dba';
create table tenant_management_dba_table(name varchar(1024));
BEGIN DBE_MASK_DATA.ADD_POLICY(
object_schema => 'tenant_management_dba',
object_name => 'tenant_management_dba_table',
column_name => 'name',
policy_name => 'RULE1',
policy_type => 'FULL',
mask_value=> '7');
END;
/
BEGIN DBE_MASK_DATA.DROP_POLICY(
object_schema => 'tenant_management_dba',
object_name => 'tenant_management_dba_table',
policy_name => 'RULE1');
END;
/
drop TENANT if exists tenant_management_018_01 cascade;

--exp show create table
CONN / AS SYSDBA
drop table if exists root_t1;
create table root_t1(c1 int) TABLESPACE USERS INITRANS 2 MAXTRANS 255 PCTFREE 8;
show create table root_t1;
drop tenant if exists tnt1 cascade;
create tenant tnt1 tablespaces (USERS);
alter session set tenant=tnt1;
create user tnt1_user1 identified by Root1234;
grant dba to tnt1_user1;
CONN tnt1_user1/Root1234@127.0.0.1:1611/TNT1
create table tnt1_t1(c1 int) TABLESPACE USERS INITRANS 2 MAXTRANS 255 PCTFREE 8;
show create table tnt1_t1;
CONN / AS SYSDBA
drop tenant if exists tnt1 cascade;
drop table if exists root_t1;

--TENANT TABLESPACE PRIV
CONN / AS SYSDBA
DROP USER IF EXISTS TNT_USER1 CASCADE;
CREATE TABLESPACE TNT_TS1 DATAFILE 'TNT_TS1.DBF' SIZE 32M;
create user TNT_USER1 identified by Root1234;
GRANT CONNECT TO TNT_USER1;
DROP TENANT IF EXISTS TNT1 CASCADE;
CREATE TENANT TNT1 TABLESPACES(USERS);
alter session set tenant=TNT1;
create user TNT1_USER1 identified by Root1234;
grant CONNECT to TNT1_USER1;
CONN TNT1_USER1/Root1234@127.0.0.1:1611/TNT1
CREATE TENANT TNT2 TABLESPACES(USERS);
ALTER TENANT TNT2 ADD TABLESPACES(TNT_TS1);
DROP TENANT TNT2 CASCADE;
CREATE TABLESPACE TNT_TS2 DATAFILE 'TNT_TS2.DBF' SIZE 32M;
ALTER TABLESPACE TNT_TS2 ADD DATAFILE 'TNT_TS2_1.DBF' SIZE 32M;
DROP TABLESPACE TNT_TS2;
CREATE OR REPLACE PROFILE TNT_PRO LIMIT PASSWORD_GRACE_TIME 10;
ALTER PROFILE TNT_PRO LIMIT PASSWORD_GRACE_TIME 11;
DROP PROFILE TNT_PRO;
CONN TNT_USER1/Root1234@127.0.0.1:1611
CREATE TENANT TNT2 TABLESPACES(USERS);
ALTER TENANT TNT2 ADD TABLESPACES(TNT_TS1);
DROP TENANT TNT2 CASCADE;
CREATE TABLESPACE TNT_TS2 DATAFILE 'TNT_TS2.DBF' SIZE 32M;
ALTER TABLESPACE TNT_TS2 ADD DATAFILE 'TNT_TS2_1.DBF' SIZE 32M;
DROP TABLESPACE TNT_TS2;
CREATE OR REPLACE PROFILE TNT_PRO LIMIT PASSWORD_GRACE_TIME 10;
ALTER PROFILE TNT_PRO LIMIT PASSWORD_GRACE_TIME 11;
DROP PROFILE TNT_PRO;
CONN / AS SYSDBA
GRANT CREATE TENANT,ALTER TENANT,DROP TENANT,CREATE TABLESPACE,ALTER TABLESPACE,DROP TABLESPACE,CREATE PROFILE,ALTER PROFILE,DROP PROFILE TO TNT_USER1,TNT1$TNT1_USER1;
CONN TNT1_USER1/Root1234@127.0.0.1:1611/TNT1
CREATE TENANT TNT2 TABLESPACES(USERS);
ALTER TENANT TNT2 ADD TABLESPACES(TNT_TS1);
DROP TENANT TNT2 CASCADE;
CREATE TABLESPACE TNT_TS2 DATAFILE 'TNT_TS2.DBF' SIZE 32M;
ALTER TABLESPACE TNT_TS2 ADD DATAFILE 'TNT_TS2_1.DBF' SIZE 32M;
DROP TABLESPACE TNT_TS2;
CREATE OR REPLACE PROFILE TNT_PRO LIMIT PASSWORD_GRACE_TIME 10;
ALTER PROFILE TNT_PRO LIMIT PASSWORD_GRACE_TIME 11;
DROP PROFILE TNT_PRO;
CONN TNT_USER1/Root1234@127.0.0.1:1611
CREATE TENANT TNT2 TABLESPACES(USERS);
ALTER TENANT TNT2 ADD TABLESPACES(TNT_TS1);
DROP TENANT TNT2 CASCADE;
CREATE TABLESPACE TNT_TS2 DATAFILE 'TNT_TS2.DBF' SIZE 32M;
ALTER TABLESPACE TNT_TS2 ADD DATAFILE 'TNT_TS2_1.DBF' SIZE 32M;
DROP TABLESPACE TNT_TS2;
CREATE OR REPLACE PROFILE TNT_PRO LIMIT PASSWORD_GRACE_TIME 10;
ALTER PROFILE TNT_PRO LIMIT PASSWORD_GRACE_TIME 11;
DROP PROFILE TNT_PRO;
CONN / AS SYSDBA
REVOKE CREATE TENANT,ALTER TENANT,DROP TENANT,CREATE TABLESPACE,ALTER TABLESPACE,DROP TABLESPACE,CREATE PROFILE,ALTER PROFILE,DROP PROFILE FROM TNT_USER1,TNT1$TNT1_USER1;
CONN TNT1_USER1/Root1234@127.0.0.1:1611/TNT1
CREATE TENANT TNT2 TABLESPACES(USERS);
ALTER TENANT TNT2 ADD TABLESPACES(TNT_TS1);
DROP TENANT TNT2 CASCADE;
CREATE TABLESPACE TNT_TS2 DATAFILE 'TNT_TS2.DBF' SIZE 32M;
ALTER TABLESPACE TNT_TS2 ADD DATAFILE 'TNT_TS2_1.DBF' SIZE 32M;
DROP TABLESPACE TNT_TS2;
CREATE OR REPLACE PROFILE TNT_PRO LIMIT PASSWORD_GRACE_TIME 10;
ALTER PROFILE TNT_PRO LIMIT PASSWORD_GRACE_TIME 11;
DROP PROFILE TNT_PRO;
CONN TNT_USER1/Root1234@127.0.0.1:1611
CREATE TENANT TNT2 TABLESPACES(USERS);
ALTER TENANT TNT2 ADD TABLESPACES(TNT_TS1);
DROP TENANT TNT2 CASCADE;
CREATE TABLESPACE TNT_TS2 DATAFILE 'TNT_TS2.DBF' SIZE 32M;
ALTER TABLESPACE TNT_TS2 ADD DATAFILE 'TNT_TS2_1.DBF' SIZE 32M;
DROP TABLESPACE TNT_TS2;
CREATE OR REPLACE PROFILE TNT_PRO LIMIT PASSWORD_GRACE_TIME 10;
ALTER PROFILE TNT_PRO LIMIT PASSWORD_GRACE_TIME 11;
DROP PROFILE TNT_PRO;
CONN / AS SYSDBA
DROP USER IF EXISTS TNT_USER1 CASCADE;
DROP TENANT IF EXISTS TNT1 CASCADE;
DROP TABLESPACE TNT_TS1;

--test DBE_RSRC_MGR/ALTER SYSTEM/��ʽָ��SYS
CONN / AS SYSDBA
DROP TENANT IF EXISTS TNT1 CASCADE;
CREATE TENANT TNT1 TABLESPACES(USERS);
alter session set tenant=TNT1;
create user TNT1_USER1 identified by Root1234;
grant dba to TNT1_USER1;
CONN TNT1_USER1/Root1234@127.0.0.1:1611/TNT1
call DBE_RSRC_MGR.CREATE_PLAN('tnt_plan', 'plan for tenant', 1);
call DBE_RSRC_MGR.CREATE_CONTROL_GROUP('tnt_group1', 'tenant group1 description');
call DBE_RSRC_MGR.add_tenant_to_control_group('tnt1', 'tnt_group1');
call DBE_RSRC_MGR.add_user_to_control_group('tnt1', 'tnt_group1');
call DBE_RSRC_MGR.CREATE_PLAN_RULE('tnt_plan', 'tnt_group1', 'plan for tnt_group1', 40, 200, 200, 120, 1000, NULL, NULL, NULL);
alter system set resource_plan = 'tnt_plan';
SELECT ID,NAME FROM SYS.SYS_USERS WHERE NAME='SYS' ORDER BY NAME;
ALTER SESSION SET CURRENT_SCHEMA=SYS;
SHUTDOWN;
CONN / AS SYSDBA
alter session set tenant=TNT1;
call DBE_RSRC_MGR.CREATE_PLAN('tnt_plan', 'plan for tenant', 1);
call DBE_RSRC_MGR.DELETE_PLAN('tnt_plan');
alter system set resource_plan = '';
SELECT ID,NAME FROM SYS.SYS_USERS WHERE NAME='SYS' ORDER BY NAME;
ALTER SESSION SET CURRENT_SCHEMA=SYS;
SELECT ID,NAME FROM SYS_USERS WHERE NAME='SYS' ORDER BY NAME;
DROP TENANT IF EXISTS TNT1 CASCADE;

--DTS2020081305MSADP1400 ��̬������ͼ��¼���⻧ID���룬��ȡdc_userʧ��ʱ����Ӱ�������߼�
CONN / AS SYSDBA
DROP USER IF EXISTS ROOT_USER1 CASCADE;
DROP USER IF EXISTS ROOT_USER2 CASCADE;
DROP TENANT IF EXISTS TNT1 CASCADE;
create user ROOT_USER1 identified by Root1234;
create user ROOT_USER2 identified by Root1234;
grant dba to ROOT_USER1, ROOT_USER2;
CREATE TENANT TNT1 TABLESPACES(USERS);
alter session set tenant=TNT1;
create user TNT1_USER1 identified by Root1234;
grant dba to TNT1_USER1;
create user TNT1_USER2 identified by Root1234;
grant dba to TNT1_USER2;
CONN ROOT_USER1/Root1234@127.0.0.1:1611
CREATE TABLE T1(C1 INT);
INSERT INTO T1 VALUES(1);
COMMIT;
CONN ROOT_USER2/Root1234@127.0.0.1:1611
CREATE TABLE T1(C1 INT);
INSERT INTO T1 VALUES(1);
COMMIT;
CONN TNT1_USER1/Root1234@127.0.0.1:1611/TNT1
CREATE TABLE T1(C1 INT);
INSERT INTO T1 VALUES(1);
COMMIT;
CONN TNT1_USER2/Root1234@127.0.0.1:1611/TNT1
CREATE TABLE T1(C1 INT);
INSERT INTO T1 VALUES(1);
COMMIT;
CONN / AS SYSDBA
SELECT U.USERNAME, D.SQL_ID, D.SQL_TYPE, D.REF_COUNT, D.VALID FROM DV_SQL_POOL D LEFT JOIN ADM_USERS U ON D.UID=U.USER_ID WHERE SQL_ID=2005423363 ORDER BY U.USERNAME;
DROP USER IF EXISTS ROOT_USER1 CASCADE;
alter session set tenant=TNT1;
DROP USER IF EXISTS TNT1_USER1 CASCADE;
CONN / AS SYSDBA
SELECT U.USERNAME, D.SQL_ID, D.SQL_TYPE, D.REF_COUNT, D.VALID FROM DV_SQL_POOL D LEFT JOIN ADM_USERS U ON D.UID=U.USER_ID WHERE SQL_ID=2005423363 ORDER BY U.USERNAME;
CONN TNT1_USER2/Root1234@127.0.0.1:1611/TNT1
SELECT U.USERNAME, D.SQL_ID, D.SQL_TYPE, D.REF_COUNT, D.VALID FROM DV_SQL_POOL D LEFT JOIN ADM_USERS U ON D.UID=U.USER_ID WHERE SQL_ID=2005423363 ORDER BY U.USERNAME;
CONN / AS SYSDBA
DROP USER IF EXISTS ROOT_USER1 CASCADE;
DROP USER IF EXISTS ROOT_USER2 CASCADE;
DROP TENANT IF EXISTS TNT1 CASCADE;