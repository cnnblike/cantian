conn / as sysdba

-------------------- VPD ---------------------
drop user if exists user1 cascade;
drop user if exists user2 cascade;
drop user if exists user3 cascade;
create user user1 identified by Cantian_234;
create user user2 identified by Cantian_234;
create user user3 identified by Cantian_234;
grant connect,select any table,create procedure to user2;
grant dba to user3;
grant connect,create table, create view,select any table,create procedure,create synonym to user1;

conn user1/Cantian_234@127.0.0.1:1611
create table test (id int, tel varchar(20));
insert into test values(1, '15256566565');
insert into test values(2, '15856524324');
insert into test values(3, '13556568977');
insert into test values(4, '13556568900');
commit;

conn user2/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE function Fn_GetPolicy(P_Schema in varchar2,P_Object in varchar2) return varchar2
as
begin
return 'id>2';
end Fn_GetPolicy;
/

CREATE OR REPLACE function function_test(P_Schema in varchar2,P_Object in varchar2) return varchar2
as
begin
return 'id>1';
end function_test;
/

SET serveroutput ON

conn user3/Cantian_234@127.0.0.1:1611
create table t2(id int);
insert into t2 values(2);
commit;
select * from user1.test where id in (select id from t2);
select * from user1.test where id > 1;
select * from user1.test;
select user2.Fn_GetPolicy('aaa','table');

conn / as sysdba

-------------dbe_ac_row.add_policy
select OBJECT_OWNER,OBJECT_NAME,POLICY_NAME,PF_OWNER,FUNCTION,SEL,INS,UPD,DEL,ENABLE from adm_policies order by POLICY_NAME;
grant execute on user2.Fn_GetPolicy to user1;
grant execute on user2.function_test to user1;

-- DTS2020020701431  sys table policy is forbidden
create table test_sys (id int, tel varchar(2));
call dbe_ac_row.add_policy('sys','test_sys','policy_sys','user2','Fn_GetPolicy','select',TRUE);
drop table test_sys;

declare
Begin
	dbe_ac_row.add_policy('user1','test','policy_test','user2','Fn_GetPolicy', 'select',true);
end;
/

declare
Begin
	dbe_ac_row.add_policy('user1','test','policy_test23','user2','function_test', 'Select',true);
end;
/

-- 不存在的用户
declare
Begin
	dbe_ac_row.add_policy('aser3','table_test','policy_test','user2','function_test', 'Select',false);
end;
/

-- 该用户不存在表table_test1234
declare
Begin
	dbe_ac_row.add_policy('user1','table_test1234','policy_test_tmp','user2','function_test', 'Select',false);
end;
/

-- 重复策略
declare
Begin
	dbe_ac_row.add_policy('user1','test','policy_test','user2','Fn_GetPolicy', 'select',false);
end;
/

-- 函数不存在
declare
Begin
	dbe_ac_row.add_policy('user1','test','policy_test2','user2','function_test00', 'Select',false);
end;
/

-------------DBE_AC_ROW.DROP_POLICY
conn / as sysdba
select OBJECT_OWNER,OBJECT_NAME,POLICY_NAME,PF_OWNER,FUNCTION,SEL,INS,UPD,DEL,ENABLE from adm_policies order by POLICY_NAME;

-- 参数过多
declare
Begin
	DBE_AC_ROW.DROP_POLICY('user1','test','policy_test2','user2','function_test','aser3', 'Select',false,false);
end;
/

-- 不存在的用户
declare
Begin
	DBE_AC_ROW.DROP_POLICY('user123','table_test','policy_test');
end;
/

-- 该用户不存在表table_test1234
declare
Begin
	DBE_AC_ROW.DROP_POLICY('user1','table_test1234','policy_test');
end;
/

-- 不存在该策略
declare
Begin
	DBE_AC_ROW.DROP_POLICY('user1','test','policy_test123');
end;
/

-------------DBE_AC_ROW.enable_policy

conn / as sysdba
select OBJECT_OWNER,OBJECT_NAME,POLICY_NAME,PF_OWNER,FUNCTION,SEL,INS,UPD,DEL,ENABLE from adm_policies order by POLICY_NAME;

declare
Begin
	DBE_AC_ROW.ENABLE_POLICY('user1','test','policy_test23',false );
end;
/

declare
Begin
	DBE_AC_ROW.ENABLE_POLICY('user1','test','POLICY_TEST',false);
end;
/

-- 参数过多
declare
Begin
	DBE_AC_ROW.ENABLE_POLICY('user1','test','policy_test2','user2','function_test','aser3', 'Select',false,false);
end;
/

-- 不存在的用户
declare
Begin
	DBE_AC_ROW.ENABLE_POLICY('user123','table_test','policy_test',true);
end;
/

-- 该用户不存在表table_test1234
declare
Begin
	DBE_AC_ROW.ENABLE_POLICY('user1','table_test1234','policy_test',true);
end;
/

-- 不存在该策略
declare
Begin
	DBE_AC_ROW.ENABLE_POLICY('user1','test','policy_test123',true);
end;
/


--------------------------------- 测试行级访问控制(VPD) --------------------------------
select OBJECT_OWNER,OBJECT_NAME,POLICY_NAME,PF_OWNER,FUNCTION,SEL,INS,UPD,DEL,ENABLE from adm_policies order by POLICY_NAME;

conn user1/Cantian_234@127.0.0.1:1611
-- 策略enable=0，不生效
select * from test;

-- 设置策略为enable=true
conn / as sysdba
declare
Begin
	DBE_AC_ROW.ENABLE_POLICY('user1','test','POLICY_TEST23',true);
end;
/

conn / as sysdba
declare
Begin
	DBE_AC_ROW.ENABLE_POLICY('user1','test','POLICY_TEST',true);
end;
/

select OBJECT_OWNER,OBJECT_NAME,POLICY_NAME,PF_OWNER,FUNCTION,SEL,INS,UPD,DEL,ENABLE from adm_policies order by POLICY_NAME;
conn user1/Cantian_234@127.0.0.1:1611
-- 策略enable=1，生效（id>1 and id >2）
select * from test;

-- DTS2020020705588  权限收回和重新赋权，测试软解析
select * from user1.test;

conn / as sysdba
revoke execute on user2.Fn_GetPolicy from user1;
revoke execute on user2.function_test from user1;
grant create session to user1;
conn user1/Cantian_234@127.0.0.1:1611
select * from test;
select * from user1.test;

conn / as sysdba
grant execute on user2.Fn_GetPolicy to user1;
grant execute on user2.function_test to user1;
grant create session to user1;
conn user1/Cantian_234@127.0.0.1:1611
select * from test;
select * from user1.test;

create table tt2 as select * from test;
create or replace view t1_view as select * from test;
select * from tt2;
select * from t1_view;
drop table tt2;
drop view t1_view;
create table test_11 (id int, tel varchar(20));
insert into test_11(id, tel) select * from test;
drop table test_11;

conn / as sysdba
-- 删除user1.test的策略
declare
Begin
	DBE_AC_ROW.DROP_POLICY('user1','test','policy_test23');
end;
/

declare
Begin
	DBE_AC_ROW.DROP_POLICY('user1','test','policy_test');
end;
/

-- 增加user1.test策略，包含select、delete和update策略（update_check暂不支持）
declare
Begin
	dbe_ac_row.add_policy('user1','test','policy_test23','user2','function_test', 'select,delete,update',true);
end;
/

conn user1/Cantian_234@127.0.0.1:1611
select * from test;
-- 对于delete和update，并非全部行生效，只有策略函数条件内的会生效
update test set TEL='18888888888';
commit;
select * from test;
delete from test;
commit;

-- 设置user1.test策略为enable=false
conn / as sysdba
declare
Begin
	DBE_AC_ROW.ENABLE_POLICY('user1','test','POLICY_TEST23',false);
end;
/

conn user1/Cantian_234@127.0.0.1:1611
-- 策略外的行数据依然存在
select * from test;

conn user2/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE function function_test(P_Schema in varchar2) return varchar2
as
begin
return 'id<3';
end function_test;
/

conn / as sysdba
declare
Begin
	DBE_AC_ROW.ENABLE_POLICY('user1','test','POLICY_TEST23',true);
end;
/

-- 策略函数入参只有一个不合要求，报错
conn user1/Cantian_234@127.0.0.1:1611
select * from test;

conn user2/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE function function_test(P_Schema in varchar2, P_Object in varchar2) return varchar2
as
begin
return 'id is where';
end function_test;
/
-- 策略函数返回的谓词语法不合要求，报错
conn user1/Cantian_234@127.0.0.1:1611
select * from test;

conn user2/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE function function_test(P_Schema in varchar2, P_Object in varchar2) return varchar2
as
begin
return 'id > 1';
end function_test;
/

-- 权限收回，不能跨用户，执行策略函数失败
conn / as sysdba
revoke execute on user2.Fn_GetPolicy from user1;
revoke execute on user2.function_test from user1;
grant create session to user1;
conn user1/Cantian_234@127.0.0.1:1611
select * from test;

-- 策略增加到2条：id>1 和 id < 4
conn / as sysdba
grant execute on user2.Fn_GetPolicy to user1;
grant execute on user2.function_test to user1;
conn user1/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE function Fn_GetPolicy(P_Schema in varchar2,P_Object in varchar2) return varchar2
as
begin
return 'id>1';
end Fn_GetPolicy;
/

conn user2/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE function function_test(P_Schema in varchar2, P_Object in varchar2) return varchar2
as
begin
return 'id < 4';
end function_test;
/

conn / as sysdba
declare
Begin
	DBE_AC_ROW.DROP_POLICY('user1','test','policy_test23');
end;
/

select OBJECT_OWNER,OBJECT_NAME,POLICY_NAME,PF_OWNER,FUNCTION,SEL,INS,UPD,DEL,ENABLE from adm_policies order by POLICY_NAME;

-- 重新建表user1.test
conn user1/Cantian_234@127.0.0.1:1611
drop table test;
create table test (id int, tel varchar(20));
insert into test values(1, '15256566565');
insert into test values(2, '15856524324');
insert into test values(3, '13556568977');
insert into test values(4, '13556568900');
commit;
select * from test;

--  新增策略（select、delete类型），当前一共两条策略生效
conn / as sysdba
declare
Begin
	dbe_ac_row.add_policy('user1','test','policy_test','user2','function_test', 'select,delete',true);
end;
/

declare
Begin
	dbe_ac_row.add_policy('user1','test','policy_test_user1','user1','Fn_GetPolicy', 'select,delete',true);
end;
/

--  select现在有两条策略生效（id > 1 and id < 4）
conn user1/Cantian_234@127.0.0.1:1611
select * from test;
-- update类型不在策略里，所有记录都生效
update test set TEL='1888888000';
commit;
--  delete和select一样，有两条策略生效（id > 1 and id < 4）
delete from test;


--  grant 权限测试
conn / as sysdba
grant execute on dbe_ac_row to user1;
conn user1/Cantian_234@127.0.0.1:1611
declare
Begin
	DBE_AC_ROW.DROP_POLICY('user1','test','POLICY_TEST_USER1');
end;
/

conn / as sysdba
revoke execute on dbe_ac_row from user1;
conn user1/Cantian_234@127.0.0.1:1611
declare
Begin
	DBE_AC_ROW.DROP_POLICY('user1','test','policy_test');
end;
/

-------------  新增exempt policy access权限，授予后不受策略限制 DTS2020011604427------
-- 策略增加到2条：id>1 和 id < 4
conn / as sysdba
CREATE OR REPLACE function Fn_GetTest(P_Schema in varchar2,P_Object in varchar2) return varchar2
as
begin
return 'AA>10';
end Fn_GetTest;
/

grant execute on user2.Fn_GetPolicy to user1;
grant execute on user2.function_test to user1;
grant EXEMPT ACCESS POLICY to user1;
conn user1/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE function Fn_GetPolicy(P_Schema in varchar2,P_Object in varchar2) return varchar2
as
begin
return 'id>1';
end Fn_GetPolicy;
/

conn user2/Cantian_234@127.0.0.1:1611
CREATE OR REPLACE function function_test(P_Schema in varchar2, P_Object in varchar2) return varchar2
as
begin
return 'id < 4';
end function_test;
/

conn / as sysdba
call DBE_AC_ROW.DROP_POLICY('user1','test','policy_test');
call DBE_AC_ROW.DROP_POLICY('user1','test','policy_test_user1');
select OBJECT_OWNER,OBJECT_NAME,POLICY_NAME,PF_OWNER,FUNCTION,SEL,INS,UPD,DEL,ENABLE from adm_policies order by POLICY_NAME;

-- 重新建表user1.test
conn user1/Cantian_234@127.0.0.1:1611
drop table test;
create table test (id int, tel varchar(20));
insert into test values(1, '15256566565');
insert into test values(2, '15856524324');
insert into test values(3, '13556568977');
insert into test values(4, '13556568900');
commit;
select * from test;

conn / as sysdba
declare
Begin
	dbe_ac_row.add_policy('user1','test','policy_test','user2','function_test', 'select,delete',true);
end;
/

declare
Begin
	dbe_ac_row.add_policy('user1','test','policy_test_user1','user1','Fn_GetPolicy', 'select,delete',true);
end;
/

select * from adm_policies order by POLICY_NAME;

--  select现在策略都不生效
conn user1/Cantian_234@127.0.0.1:1611
select * from test;
--  update现在策略都不生效，所有记录都更新
update test set TEL='1888888000';
commit;
--  delete和select一样，现在策略都不生效
delete from test;


------------------- 同名词的策略禁止添加 ---------------------
create synonym test_syn for test;
conn / as sysdba
declare
Begin
	dbe_ac_row.add_policy('user1','test_syn','policy_test11','user2','function_test', 'select,delete',true);
end;
/

-- DTS2020011315701/	DTS2020011315626
conn / as sysdba
CREATE OR REPLACE FUNCTION Fn_GetPolicy_000(P_Schema in varchar2,P_Object in varchar2) return varchar2
   AS
BEGIN
RETURN 'ID>2';
END Fn_GetPolicy_000;
/

drop table if exists t1 ;
create table t1(a int) nologging;
call dbe_ac_row.add_policy('sys','t1','policy_001','sys','Fn_GetPolicy_000','select',TRUE);

drop table if exists t1;
create table t1(a int);
create or replace view t1_view as select * from t1;
call dbe_ac_row.add_policy('sys','t1_view','policy_001','sys','Fn_GetPolicy_000','select',TRUE);

drop table t1;
create GLOBAL TEMPORARY  table t1(i int);
call dbe_ac_row.add_policy('sys','t1','policy_001','sys','Fn_GetPolicy_000','select',TRUE);

drop table t1 ;
create table t1(i int)
    partition by range (i)
(partition part_1 values less than (1),partition part_2 values less than (maxvalue));
call dbe_ac_row.add_policy('sys','t1','policy_001','sys','Fn_GetPolicy_000','select',TRUE);

call dbe_ac_row.add_policy('sys','SYS_TALES','policy_001','sys','Fn_GetPolicy_000','select',TRUE);

drop FUNCTION Fn_GetPolicy_000;

-------------------  VPD: 删除测试数据 ------------------------
conn / as sysdba
select OBJECT_OWNER,OBJECT_NAME,POLICY_NAME,PF_OWNER,FUNCTION,SEL,INS,UPD,DEL,ENABLE from adm_policies order by POLICY_NAME;
declare
Begin
	DBE_AC_ROW.DROP_POLICY('user1','test','policy_test');
end;
/
declare
Begin
	DBE_AC_ROW.DROP_POLICY('user1','test','POLICY_TEST_USER1');
end;
/

--  DTS2020020606286
--  reach the policy count limit:32
DECLARE
idx INTEGER;
  SQL_STR VARCHAR(30);
BEGIN
FOR idx IN 0..32 LOOP
    SQL_STR := 'policy_limit_test'||idx;
	dbe_ac_row.add_policy('user1','test',''||SQL_STR||'','user2','Fn_GetPolicy', 'select',true);
END LOOP;
END;
/

select COUNT(1) from sys_policies where PNAME like 'POLICY_LIMIT_TEST%';

DECLARE
idx INTEGER;
  SQL_STR VARCHAR(30);
BEGIN
FOR idx IN 0..31 LOOP
    SQL_STR := 'policy_limit_test'||idx;
	DBE_AC_ROW.DROP_POLICY('user1','test',''||SQL_STR||'');
END LOOP;
END;
/

drop user if exists user1 cascade;
drop user if exists user2 cascade;
drop user if exists user3 cascade;

--  DTS2020012100830
conn / as sysdba
drop user if exists cf1 cascade;
create user cf1 identified by Cantian_234;
grant create session to  cf1;
create table cf1.t1(id int);
insert into cf1.t1 values(1),(2),(3),(4);
commit;
select * from cf1.t1;
CREATE OR REPLACE FUNCTION Fn_GetPolicy_000(P_Schema in varchar2,P_Object in varchar2) return varchar2
   AS
BEGIN
RETURN 'id>2';
END Fn_GetPolicy_000;
/

call dbe_ac_row.add_policy('cf1','t1','policy_cf_1','sys','Fn_GetPolicy_000','select',TRUE);
select * from cf1.t1;
grant EXECUTE on Fn_GetPolicy_000 to cf1;
conn cf1/Cantian_234@127.0.0.1:1611

update t1 set id = 3;
delete from t1;

--  DTS2020012103832 delete policy before drop
drop table t1;

conn / as sysdba
call DBE_AC_ROW.DROP_POLICY('cf1','t1','policy_cf_1');

drop table t1;
drop user cf1 cascade;

--  DTS2020012100481
drop user if exists cf1 cascade;
create user cf1 identified by Cantian_234;
grant create session to  cf1;
create table cf1.t1(id int);
insert into cf1.t1 values(1),(2),(3),(4);
commit;
select * from cf1.t1;
CREATE OR REPLACE FUNCTION Fn_GetPolicy_000(P_Schema in varchar2,P_Object in varchar2) return varchar2
   AS
BEGIN
RETURN 'id>2';
END Fn_GetPolicy_000;
/

call dbe_ac_row.add_policy('cf1','t1','policy_cf_1','sys','Fn_GetPolicy_000','select',TRUE);
select * from cf1.t1;
grant EXECUTE on   Fn_GetPolicy_000 to cf1;
conn cf1/Cantian_234@127.0.0.1:1611
select * from cf1.t1;
--  增加EXEMPT，豁免
conn / as sysdba
grant EXEMPT ACCESS POLICY to cf1;

conn cf1/Cantian_234@127.0.0.1:1611
select * from t1;
select * from cf1.t1;

--  去掉EXEMPT 策略生效
conn / as sysdba
revoke EXEMPT ACCESS POLICY from cf1;

conn cf1/Cantian_234@127.0.0.1:1611
select * from t1;
select * from cf1.t1;

--  DTS2020012103832
alter table t1 rename to test33;
select * from t1;
select * from test33;
select * from cf1.test33;

conn / as sysdba
call DBE_AC_ROW.DROP_POLICY('cf1','t1','policy_cf_1');
select OBJECT_OWNER,OBJECT_NAME,POLICY_NAME,PF_OWNER,FUNCTION,SEL,INS,UPD,DEL,ENABLE from adm_policies order by POLICY_NAME;
call DBE_AC_ROW.DROP_POLICY('cf1','test33','policy_cf_1');

conn cf1/Cantian_234@127.0.0.1:1611
select * from test33;

conn / as sysdba
drop user cf1 cascade;

--
drop user if exists DBE_AC_ROW_DML_0 cascade;
create user DBE_AC_ROW_DML_0 identified by Cantian_234;
grant create table,create session to DBE_AC_ROW_DML_0;
grant create PROCEDURE to DBE_AC_ROW_DML_0;
grant EXECUTE on dbe_ac_row to DBE_AC_ROW_DML_0;
conn DBE_AC_ROW_DML_0/Cantian_234@127.0.0.1:1611
drop table if exists dbe_ac_row_DML_table_000;
create table DBE_AC_ROW_DML_table_000 (id int);
insert into DBE_AC_ROW_DML_table_000 values(1),(2),(3),(4);
commit;
CREATE OR REPLACE FUNCTION Fn_DML_G00(P_Schema in varchar2,P_Object in varchar2) return varchar2
   AS
BEGIN
RETURN 'ID<2';
END Fn_DML_G00;
/
call DBE_AC_ROW.add_policy('DBE_AC_ROW_DML_0','DBE_AC_ROW_DML_table_000','DBE_AC_ROW_dml_000','DBE_AC_ROW_DML_0','Fn_DmL_G00','select');
conn DBE_AC_ROW_DML_0/Cantian_234@127.0.0.1:1611
call DBE_AC_ROW.ENABLE_POLICY('DBE_AC_ROW_DML_0','DBE_AC_ROW_DML_table_000','DBE_AC_ROW_dml_000',true);
CREATE or replace procedure DBE_AC_ROW_proc_1()  as
i INT;
BEGIN
insert into DBE_AC_ROW_DML_table_000 select * from DBE_AC_ROW_DML_table_000 commit;
END;
/
call DBE_AC_ROW_proc_1() ;
select * from DBE_AC_ROW_DML_table_000;
call DBE_AC_ROW.ENABLE_POLICY('DBE_AC_ROW_DML_0','DBE_AC_ROW_DML_table_000','DBE_AC_ROW_dml_000',false);
call DBE_AC_ROW_proc_1() ;
select * from DBE_AC_ROW_DML_table_000;
-- 清理环境
call dbe_ac_row.enable_policy('DBE_AC_ROW_DML_0','DBE_AC_ROW_DML_table_000','DBE_AC_ROW_DML_000',true);
delete from DBE_AC_ROW_DML_table_000;
insert into DBE_AC_ROW_DML_table_000 values (1),(2),(3),(4);
commit;

-- 问题相关操作
conn / as sysdba
drop user if exists DBE_AC_ROW_DML_0 cascade;
conn DBE_AC_ROW_DML_0/Cantian_234@127.0.0.1:1611
drop table if exists DBE_AC_ROW_DML_table_000;
call dbe_ac_row.drop_policy('DBE_AC_ROW_DML_0','DBE_AC_ROW_DML_table_000','DBE_AC_ROW_DML_000');

conn / as sysdba
drop user if exists DBE_AC_ROW_DML_0 cascade;

-- DTS2020032409512
drop user if exists dbe_ac_row_fun_0 cascade;
create user dbe_ac_row_fun_0 identified by Cantian_234;
grant create table,create session to dbe_ac_row_fun_0;
grant create PROCEDURE to dbe_ac_row_fun_0;
grant EXECUTE on dbe_ac_row to dbe_ac_row_fun_0;
conn dbe_ac_row_fun_0/Cantian_234@127.0.0.1:1611
drop table if exists dbe_ac_row_fun_table_000;
create table dbe_ac_row_fun_table_000 (id int);
insert into dbe_ac_row_fun_table_000 values(1),(2),(3),(4);
create table dbe_ac_row_fun_table_001 (id int);
insert into dbe_ac_row_fun_table_001 values(1);
commit;

CREATE OR REPLACE FUNCTION Fn_fun_G00(P_Schema in varchar2,P_Object in varchar2) return varchar2
AS
fun_G00 VARCHAR(128);
BEGIN
select id into fun_G00 from dbe_ac_row_fun_table_001;
if fun_G00>0 then
    RETURN 'ID>0';
else
    RETURN 'ID=3';
end if;
END Fn_fun_G00;
/
call dbe_ac_row.add_policy('dbe_ac_row_fun_0','dbe_ac_row_fun_table_000','dbe_ac_row_fun_000','dbe_ac_row_fun_0','Fn_fun_G00','select');

select * from dbe_ac_row_fun_table_000;
update dbe_ac_row_fun_table_001 set id=-1;---修改策略函数的如参值，查询对象
select * from dbe_ac_row_fun_table_000;---查询结果改变，通过关闭软解析实现

conn dbe_ac_row_fun_0/Cantian_234@127.0.0.1:1611
call dbe_ac_row.drop_policy('dbe_ac_row_fun_0','dbe_ac_row_fun_table_000','dbe_ac_row_fun_000');
drop table dbe_ac_row_fun_table_000;
drop table dbe_ac_row_fun_table_001;
conn / as sysdba
drop user if exists dbe_ac_row_fun_0 cascade;
drop user if exists dbe_ac_row_fun_0_1 cascade;
commit;

--  1. SYS用户登录，创建用户USER1，并授权
conn / as sysdba
DROP USER IF EXISTS USER_TS CASCADE;
CREATE USER USER_TS IDENTIFIED BY CANTIAN_234;
GRANT CREATE SESSION, CONNECT, RESOURCE TO USER_TS;
GRANT EXECUTE ON SYS.dbe_ac_row TO USER_TS WITH GRANT OPTION;

--  2. 切换到USER1用户，建表并插入数据
conn USER_TS/CANTIAN_234@127.0.0.1:1611
DROP TABLE IF EXISTS TEST;
CREATE TABLE TEST (ID INT, TEL VARCHAR(20));
INSERT INTO TEST VALUES(1, '15256566565');
INSERT INTO TEST VALUES(2, '15856524324');
INSERT INTO TEST VALUES(3, '13556568977');
INSERT INTO TEST VALUES(4, '13556568900');
COMMIT;

--  3. 创建策略函数Fn_GetPolicy0。
CREATE OR REPLACE FUNCTION FN_GETPOLICY0(P_SCHEMA IN VARCHAR2,P_OBJECT IN VARCHAR2) RETURN VARCHAR2
AS
BEGIN
RETURN 'ID>2';
END FN_GETPOLICY0;
/

--  4. 添加安全策略。
SET SERVEROUTPUT ON
CALL dbe_ac_row.add_policy('USER_TS','TEST','POLICY_TEST','USER_TS','FN_GETPOLICY0', 'SELECT',TRUE);

--  5. 修复解析报错问题
select * from test a, test b;

DROP TABLE IF EXISTS T2;
CREATE TABLE T2 (ID INT, C2 INT);
INSERT INTO T2 VALUES (3, 1);
COMMIT;

--  6. 修复绕过策略的问题
select a.* from test a, t2 test;

--  7. 清理测试数据
DROP FUNCTION FN_GETPOLICY0;
CALL dbe_ac_row.drop_policy('USER_TS','TEST','POLICY_TEST');

DROP TABLE IF EXISTS TEST;
DROP TABLE IF EXISTS T2;
COMMIT;

drop table if exists dbe_ac_row_fun_table_006;
create table dbe_ac_row_fun_table_006 (id int);
insert into dbe_ac_row_fun_table_006 values(1),(2),(3),(4);
commit;

CREATE OR REPLACE FUNCTION Fn_fun_G06(P_Schema in varchar2,P_Object in varchar2) return varchar2
   AS
   fun_G00 VARCHAR(128);
BEGIN

return 'id>3';
END Fn_fun_G06;
/
call dbe_ac_row.add_policy('USER_TS','dbe_ac_row_fun_table_006','dbe_ac_row_fun_006','USER_TS','Fn_fun_G06','select');

select * from dbe_ac_row_fun_table_006;
select ENABLE from my_policies;

CREATE OR REPLACE FUNCTION Fn_fun_G06(P_Schema in varchar2,P_Object in varchar2) return varchar2
   AS
   fun_G00 VARCHAR(128);
BEGIN
      dbe_ac_row.enable_policy('USER_TS','dbe_ac_row_fun_table_006','dbe_ac_row_fun_006',false);

return 'id>3';
END Fn_fun_G06;
/

select ENABLE from my_policies;
select * from dbe_ac_row_fun_table_006;
select ENABLE from my_policies;
call dbe_ac_row.drop_policy('USER_TS','dbe_ac_row_fun_table_006','dbe_ac_row_fun_006');

conn / as sysdba
DROP USER USER_TS CASCADE;
COMMIT;
