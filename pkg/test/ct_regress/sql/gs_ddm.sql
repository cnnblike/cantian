--date
-- view
-- distinct   
-- col expr
-- common col
-- winsort group
-- where col
-- order
-- group
-- subselect
conn / as sysdba
drop user if exists DDMUSER cascade;
drop user if exists DDMUSER1 cascade;
drop user if exists DDMUSER2 cascade;
drop user if exists DDMUSER3 cascade;
create user DDMUSER identified by CANTIAN_234;
create user DDMUSER1 identified by CANTIAN_234;
create user DDMUSER2 identified by CANTIAN_234;
grant connect , resource  to DDMUSER;
grant create table to DDMUSER;
grant create view to DDMUSER;
grant execute on DBE_MASK_DATA to DDMUSER;
grant unlimited tablespace to DDMUSER;
grant connect , resource  to DDMUSER1;
grant create table to DDMUSER1;
grant EXEMPT REDACTION POLICY  to DDMUSER1;
grant unlimited tablespace to DDMUSER1;
grant connect , resource  to DDMUSER2;
grant dba to DDMUSER2;
grant unlimited tablespace to DDMUSER2;
conn DDMUSER/CANTIAN_234@127.0.0.1:1611
drop table if exists najinschool;
create table najinschool(gradeid int, classid int, groupid int, stdid int, stdsco int);
insert into najinschool values(1,1,1,1,1000);
insert into najinschool values(1,1,1,2,1200);
insert into najinschool values(1,1,1,3,1300);
insert into najinschool values(1,1,1,4,1400);
insert into najinschool values(1,1,1,5,1500);
insert into najinschool values(1,1,1,6,16000);
insert into najinschool values(1,1,1,7,1700);
insert into najinschool values(1,1,1,8,1800);
insert into najinschool values(1,1,1,9,1900);
insert into najinschool values(1,1,1,10,2000);
insert into najinschool values(1,1,2,1,20);
insert into najinschool values(1,1,2,2,22);
insert into najinschool values(1,1,2,3,23);
insert into najinschool values(1,1,2,4,24);
insert into najinschool values(1,1,2,5,25);
insert into najinschool values(1,1,2,6,260);
insert into najinschool values(1,1,2,7,27);
insert into najinschool values(1,1,2,8,28);
insert into najinschool values(1,1,2,9,29);
insert into najinschool values(1,1,2,10,30);
insert into najinschool values(1,2,1,1,100);
insert into najinschool values(1,2,1,2,120);
insert into najinschool values(1,2,1,3,130);
insert into najinschool values(1,2,1,4,140);
insert into najinschool values(1,2,1,5,150);
insert into najinschool values(1,2,1,6,160);
insert into najinschool values(1,2,1,7,1700);
insert into najinschool values(1,2,1,8,180);
insert into najinschool values(1,2,1,9,190);
insert into najinschool values(1,2,1,10,200);
insert into najinschool values(1,2,2,1,200);
insert into najinschool values(1,2,2,2,220);
insert into najinschool values(1,2,2,3,230);
insert into najinschool values(1,2,2,4,240);
insert into najinschool values(1,2,2,5,250);
insert into najinschool values(1,2,2,6,260);
insert into najinschool values(1,2,2,7,270);
insert into najinschool values(1,2,2,8,280);
insert into najinschool values(1,2,2,9,290);
insert into najinschool values(1,2,2,10,300);
commit;
create table najinschool1(gradeid int, classid int, groupid int, stdid int, stdsco int);
insert into najinschool1 values(1,1,1,1,1000);
insert into najinschool1 values(1,1,1,2,1200);
insert into najinschool1 values(1,1,1,3,1300);
insert into najinschool1 values(1,1,1,4,1400);
insert into najinschool1 values(1,1,1,5,1500);
insert into najinschool1 values(1,1,1,6,16000);
insert into najinschool1 values(1,1,1,7,1700);
insert into najinschool1 values(1,1,1,8,1800);
insert into najinschool1 values(1,1,1,9,1900);
insert into najinschool1 values(1,1,1,10,2000);
insert into najinschool1 values(2,1,1,1,1000);
insert into najinschool1 values(2,1,1,2,1200);
insert into najinschool1 values(2,1,1,3,1300);
insert into najinschool1 values(2,1,1,4,1400);
insert into najinschool1 values(2,1,1,5,1500);
insert into najinschool1 values(2,1,1,6,16000);
insert into najinschool1 values(2,1,1,7,1700);
insert into najinschool1 values(2,1,1,8,1800);
insert into najinschool1 values(2,1,1,9,1900);
insert into najinschool1 values(2,1,1,10,2000);

commit;
BEGIN
 SYS.DBE_MASK_DATA.ADD_POLICY(
   object_schema    => 'DDMUSER',
   object_name      => 'najinschool',
   column_name      => 'stdsco',
   policy_name      => 'RULE1',
   policy_type    => 'FULL',
   mask_value => '7');
END;
/
conn DDMUSER/CANTIAN_234@127.0.0.1:1611
create view view1 as select * from najinschool;
create table najinschoolas as select * from najinschool;
select * from view1;
select stdsco+1 from najinschool;
select gradeid , classid, groupid, stdid, stdsco from najinschool;
select *  from najinschool where stdsco = 16000;
select sum(groupid), stdsco from najinschool group by stdsco;
select distinct stdsco from najinschool;
select groupid, plus0 from (select groupid, stdsco+10 plus0 from najinschool);
select * from (select stdsco+10 from najinschool) ;
with t_tmp1 as (select * from najinschool) select * from t_tmp1;
select sum(stdsco) from najinschool;
select sco from (select gradeid , classid, groupid, stdid, stdsco+1 sco  from najinschool);
select sumg, plus10 from (select sum(groupid) as sumg,  stdsco+10 as plus10 from najinschool group by stdsco);
select
sum(stdsco) over() sumsco,
sum(stdsco) over (partition by groupid) groupsum,
sum(stdsco) over (order by groupid) ordsum,
sum(stdsco) over (partition by groupid order by groupid) gosum from najinschool;
select *  from najinschool order by stdsco, classid;
select sum(stdsco) from najinschool group by groupid;
select sum(groupid), stdsco from (select * from najinschool) group by stdsco;
select na.groupid, na.stdsco  from najinschool na,najinschool1 where na.stdsco =najinschool1.stdsco;
select groupid, stdsco from DDMUSER.najinschool minus select groupid, stdsco  from DDMUSER.najinschool1 order by 1;
select groupid, stdsco from DDMUSER.najinschool union select groupid, stdsco  from DDMUSER.najinschool1;
select groupid, stdsco from DDMUSER.najinschool1 union select groupid, stdsco  from DDMUSER.najinschool;
create table najinschoolas as select * from DDMUSER.najinschool;
create table najinschoolas as select stdsco+1 plus1 from DDMUSER.najinschool;
EXEC DBE_MASK_DATA.DROP_POLICY('DDMUSER','NAJINSCHOOL','RULE1' );
conn / as sysdba
drop user if exists DDMUSER cascade;
drop user if exists DDMUSER1 cascade;
drop user if exists DDMUSER2 cascade;
drop user if exists DDMUSER3 cascade;
CONN / as  sysdba
drop user if exists DDMUSER cascade;
create user DDMUSER identified by cao102_cao; 
grant connect , resource  to DDMUSER;
grant create table to DDMUSER;
grant execute on DBE_MASK_DATA to DDMUSER;
grant select on sys_ddm to DDMUSER;
conn DDMUSER/cao102_cao@127.0.0.1:1611
create table TT3 (id DOUBLE, id2 DOUBLE, id3 DOUBLE, id4 DOUBLE, id5 DOUBLE, id6 DOUBLE);
exec DBE_MASK_DATA.ADD_POLICY('DDMUSER', 'TT3', 'ID2','', 'FULL','0.5');
insert into tt3 (id2) values ('0.5');
exec DBE_MASK_DATA.ADD_POLICY('DDMUSER', 'TT3', 'ID3','rulecccccccccccccccccccccccccCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC00002', 'FULL','1.000006');
insert into tt3 (id3) values ('1.000006');
exec DBE_MASK_DATA.ADD_POLICY('DDMUSER', 'TT3', 'ID4','rulecccccccccccccccccccccccccCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC00003', 'FULL','2.6');
select* from my_redaction_policies order by RULE_NAME;
exec DBE_MASK_DATA.DROP_POLICY('DDMUSER', 'TT3', 'rulecccccccccccccccccccccccccCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC00003');
exec DBE_MASK_DATA.DROP_POLICY('DDMUSER', 'TT3', 'rulecccccccccccccccccccccccccCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC00002');
select* from my_redaction_policies order by RULE_NAME;
CONN / as  sysdba
drop user if exists DDMUSER cascade;
conn / as sysdba 
drop user if exists DDMUSER cascade;
drop user if exists DDMUSER3 cascade;
create user DDMUSER identified by cao102_cao; 
create user DDMUSER3 identified by cao102_cao; 
grant connect , resource  to DDMUSER;
grant create table to DDMUSER;
grant execute on DBE_MASK_DATA to DDMUSER;
grant unlimited tablespace to DDMUSER;
grant dba to DDMUSER3;
conn DDMUSER/cao102_cao@127.0.0.1:1611
create table TT3 (id DOUBLE, id2 DOUBLE, id3 DOUBLE, id4 DOUBLE, id5 DOUBLE, id6 DOUBLE);
exec DBE_MASK_DATA.ADD_POLICY('DDMUSER', 'TT3', 'ID2','rule1', 'FULL','0.5');
insert into TT3 values ('1','1','1.0506','1.0506','1.0506','1.0506');
insert into TT3 values ('2','2','1.0506','1.0506','1.0506','1.0506');
insert into TT3 values ('3','3','1.0506','1.0506','1.0506','1.0506');
create table TT1 (id DOUBLE, id2 DOUBLE, id3 DOUBLE, id4 DOUBLE, id5 DOUBLE, id6 DOUBLE);
exec DBE_MASK_DATA.ADD_POLICY('DDMUSER', 'TT1', 'ID2','rule1', 'FULL','0.5');
insert into TT1 values ('1','5','1.0506','1.0506','1.0506','1.0506');
insert into TT1 values ('2','2','1.0506','1.0506','1.0506','1.0506');
insert into TT1 values ('3','6','1.0506','1.0506','1.0506','1.0506');
commit;
conn DDMUSER/cao102_cao@127.0.0.1:1611
select * from DDMUSER.TT3 where id2 in (1,2,3);
select * from DDMUSER.TT3 where id2 = 1 or id2 = 2 or id2 = 3;
select DDMUSER.TT1.ID2, DDMUSER.TT3.ID2 from DDMUSER.TT1 left join  DDMUSER.TT3 on DDMUSER.TT1.ID2=DDMUSER.TT3.ID2;
conn DDMUSER3/cao102_cao@127.0.0.1:1611
select * from DDMUSER.TT3 where id2 in (1,2,3);
conn DDMUSER/cao102_cao@127.0.0.1:1611
exec DBE_MASK_DATA.drop_POLICY('DDMUSER', 'TT1', 'rule1');
exec DBE_MASK_DATA.drop_POLICY('DDMUSER', 'TT3', 'rule1');
conn / as sysdba 
drop user if exists DDMUSER cascade;
drop user if exists DDMUSER3 cascade;
conn / as sysdba 
drop user if exists C##DDMUSER11 cascade;
create user C##DDMUSER11 identified by cao102_cao;  
grant connect , resource  to C##DDMUSER11;
grant create any table to C##DDMUSER11;
grant execute on DBE_MASK_DATA to C##DDMUSER11;
conn C##DDMUSER11/cao102_cao@127.0.0.1:1611
create table TT3 (id DOUBLE, id2 DOUBLE);
create table TT2 (id DOUBLE, id2 DOUBLE);
create table TT1 (id DOUBLE, id2 DOUBLE);
create table TT0 (id DOUBLE, id2 DOUBLE);
exec DBE_MASK_DATA.ADD_POLICY('C##DDMUSER11', 'TT3', 'ID2','rule1', 'FULL','0');
exec DBE_MASK_DATA.ADD_POLICY('C##DDMUSER11', 'TT2', 'ID2','rule1', 'FULL','0');
exec DBE_MASK_DATA.ADD_POLICY('C##DDMUSER11', 'TT1', 'ID2','rule1', 'FULL','0');
exec DBE_MASK_DATA.ADD_POLICY('C##DDMUSER11', 'TT0', 'ID2','rule1', 'FULL','0');
select count(*) from my_redaction_policies where USER_NAME = 'C##DDMUSER11';
drop table TT0 purge;
exec DBE_MASK_DATA.drop_POLICY('C##DDMUSER11', 'TT0','rule1');
drop table TT0 purge;
select count(*) from my_redaction_policies where USER_NAME = 'C##DDMUSER11';
drop table TT3;
exec DBE_MASK_DATA.drop_POLICY('C##DDMUSER11', 'TT3','rule1');
drop table TT3;
select count(*) from my_redaction_policies where USER_NAME = 'C##DDMUSER11';
alter table TT2 drop column ID2;
exec DBE_MASK_DATA.drop_POLICY('C##DDMUSER11', 'TT2','rule1');
alter table TT2 drop column ID2;
select count(*) from my_redaction_policies where USER_NAME = 'C##DDMUSER11';
conn / as sysdba
drop user C##DDMUSER11 cascade;
exec DBE_MASK_DATA.drop_POLICY('C##DDMUSER11', 'TT1','rule1');
drop user C##DDMUSER11 cascade;
select count(*) from adm_redaction_policies where USER_NAME = 'C##DDMUSER11';
conn / as sysdba
drop user if exists u_tc_sec_trigger_002 cascade;
create user u_tc_sec_trigger_002 identified by Changeme123;
grant create session,create table,create trigger to u_tc_sec_trigger_002;
create table u_tc_sec_trigger_002.t_tc_sec_trigger_002(c1 int, c2 varchar(1000));
insert into u_tc_sec_trigger_002.t_tc_sec_trigger_002 values(1,'zhangsan'),(2,'lisi'),(3,'wangwu'),(4,'zhaoliu');
--添加脱敏规则
BEGIN DBE_MASK_DATA.ADD_POLICY(   
object_schema    => 'u_tc_sec_trigger_002',   
object_name      => 't_tc_sec_trigger_002',  
column_name      => 'c1',  
policy_name      => 'rule1',   
policy_type    => 'FULL',   
mask_value=> '0');
END;
/
conn u_tc_sec_trigger_002/Changeme123@127.0.0.1:1611
select * from t_tc_sec_trigger_002 order by c2;
create table t_tc_sec_trigger_002_2(c1 int, c2 varchar(1000));
create table t_tc(c1 int, c2 varchar(1000)) as select * from t_tc_sec_trigger_002;
insert into t_tc_sec_trigger_002_2 select * from t_tc_sec_trigger_002;
insert into t_tc_sec_trigger_002_2 select c1+1, c2 from t_tc_sec_trigger_002;
select * from t_tc_sec_trigger_002_2 order by c1, c2;
conn / as sysdba 
grant EXEMPT REDACTION POLICY to u_tc_sec_trigger_002;
conn u_tc_sec_trigger_002/Changeme123@127.0.0.1:1611
insert into t_tc_sec_trigger_002_2 select * from t_tc_sec_trigger_002;
insert into t_tc_sec_trigger_002_2 select c1+10, c2 from t_tc_sec_trigger_002;
select * from t_tc_sec_trigger_002_2 order by c1;
conn / as sysdba 
BEGIN DBE_MASK_DATA.DROP_POLICY(   
object_schema    => 'u_tc_sec_trigger_002',   
object_name      => 't_tc_sec_trigger_002',    
policy_name      => 'rule1');
END;
/
drop user if exists u_tc_sec_trigger_002 cascade;

create user test_ddm_p1 identified by Changeme_123;
grant create session,create table to test_ddm_p1;
grant create procedure to test_ddm_p1;
GRANT EXECUTE ON DBE_AC_ROW TO test_ddm_p1;
GRANT EXECUTE ON DBE_MASK_DATA TO test_ddm_p1;
create user test_ddm_p2 identified by Changeme_123;
grant create session,SELECT ANY TABLE to test_ddm_p2;
grant create table to test_ddm_p2;
grant create procedure to test_ddm_p2;
GRANT EXECUTE ON DBE_AC_ROW TO test_ddm_p2;
GRANT EXECUTE ON DBE_MASK_DATA TO test_ddm_p2;
conn test_ddm_p1/Changeme_123@127.0.0.1:1611
create table P_TEST(id int,data CHAR(8) NOT NULL);
insert into P_TEST values (1,'pite');
insert into P_TEST values (2,'p1');
insert into P_TEST values (3,'p2');
insert into P_TEST values (4,'p3');
commit;

CREATE OR REPLACE FUNCTION Fn_GetPolicy(P_Schema in varchar2,P_Object in varchar2) return varchar2
           AS
           BEGIN
                   RETURN 'ID>2';
          END Fn_GetPolicy;
           /
DECLARE
  BEGIN
       DBE_AC_ROW.ADD_POLICY('test_ddm_p1','P_TEST','policy_testabxihjf','test_ddm_p1','Fn_GetPolicy', 'SELECT',TRUE);
   END;
   /
select * from P_TEST;
conn / as sysdba
grant execute on test_ddm_p1.Fn_GetPolicy to test_ddm_p2;
conn test_ddm_p2/Changeme_123@127.0.0.1:1611
select * from test_ddm_p1.P_TEST;
create table P_TEST_merge (id int,data CHAR(8) NOT NULL);
MERGE INTO test_ddm_p2.P_TEST_merge p using test_ddm_p1.P_TEST np on (p.id = np.id) when matched then update set p.data = np.data when not matched then insert values (np.id,np.data);
commit;
select * from P_TEST_merge order by id;
create table P_TEST_3 (id int,data CHAR(8) NOT NULL);
replace into test_ddm_p2.P_TEST_3 select * from test_ddm_p1.P_TEST;
select * from test_ddm_p2.P_TEST_3;

conn test_ddm_p1/Changeme_123@127.0.0.1:1611
DECLARE
  BEGIN
       DBE_AC_ROW.drop_POLICY('test_ddm_p1','P_TEST','policy_testabxihjf');
   END;
   /
drop  FUNCTION Fn_GetPolicy;
select * from P_TEST;
BEGIN 
DBE_MASK_DATA.ADD_POLICY(   
object_schema    => 'test_ddm_p1',   
object_name      => 'P_TEST',  
column_name      => 'data',  
policy_name      => 'RULE_TEST_PO1',   
policy_type    => 'FULL',   
mask_value   => 'xx');
END;
/
select * from P_TEST;
conn test_ddm_p2/Changeme_123@127.0.0.1:1611
delete from test_ddm_p2.P_TEST_merge;
MERGE INTO test_ddm_p2.P_TEST_merge p using test_ddm_p1.P_TEST np on (p.id = np.id) when matched then update set p.data = np.data when not matched then insert values (np.id,np.data);
insert into test_ddm_p2.P_TEST_merge values (1,'x');
update test_ddm_p2.P_TEST_merge p,test_ddm_p1.P_TEST np set p.data=np.data where p.id=np.id;
replace into P_TEST_merge select * from test_ddm_p1.P_TEST;
conn test_ddm_p1/Changeme_123@127.0.0.1:1611
DECLARE
  BEGIN
       DBE_MASK_DATA.drop_POLICY('TEST_DDM_P1','P_TEST','RULE_TEST_PO1');
   END;
   /
conn / as sysdba
drop user if exists test_ddm_p1 cascade;
drop user if exists test_ddm_p2 cascade;

DROP USER IF EXISTS DDMUSER CASCADE;
DROP TABLE IF EXISTS TEST_S_DBE_MASK_DATA;
CREATE USER DDMUSER IDENTIFIED BY Cantian_234;
GRANT CONNECT,RESOURCE TO DDMUSER;
GRANT CREATE TABLE TO DDMUSER;
GRANT EXECUTE ON DBE_MASK_DATA TO DDMUSER;
conn DDMUSER/Cantian_234@127.0.0.1:1611
DROP TABLE IF EXISTS TEST_S_DBE_MASK_DATA CASCADE;
CREATE TABLE TEST_S_DBE_MASK_DATA(gradeid int, classid int, groupid int, stdid int, stdsco int);
conn / as sysdba 
CREATE OR REPLACE function f2_S_DBE_MASK_DATA() return int
as
BEGIN
       SYS.DBE_MASK_DATA.ADD_POLICY(
       object_schema    => 'DDMUSER',
       object_name      => 'TEST_S_DBE_MASK_DATA',
       column_name      => 'stdsco',
       policy_name      => 'RULE1',
       policy_type      => 'FULL',
       mask_value       => '7');
       return 1;
END;
/
select f2_S_DBE_MASK_DATA();
EXEC DBE_MASK_DATA.DROP_POLICY('DDMUSER','TEST_S_DBE_MASK_DATA','RULE1' );
drop user DDMUSER cascade;