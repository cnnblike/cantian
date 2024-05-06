conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_trigger_coredump cascade;
create user gs_trigger_coredump identified by Cantian_234;
grant dba to gs_trigger_coredump;
grant execute on DBE_AC_ROW to gs_trigger_coredump;
conn gs_trigger_coredump/Cantian_234@127.0.0.1:1611
set serveroutput on;

drop table if exists trig_tab1;
create table trig_tab1(f1 int);

insert into trig_tab1 values(5);
insert into trig_tab1 values(10);
insert into trig_tab1 values(15);
insert into trig_tab1 values(20);

drop table if exists trig_tab2;  
  
create table trig_tab2(f1 varchar(100), f2 int);

insert into trig_tab2 values('a',5);
insert into trig_tab2 values('b',10);
insert into trig_tab2 values('c',15);
insert into trig_tab2 values('d',20);
              
drop table if exists trig_tab3; 

create table trig_tab3(f1 varchar(100), f2 int);

insert into trig_tab3 values('a',5);
insert into trig_tab3 values('b',10);
insert into trig_tab3 values('c',15);
insert into trig_tab3 values('d',20);  

CREATE OR REPLACE TRIGGER trig_1 BEFORE UPDATE ON trig_tab1
FOR EACH ROW
BEGIN
  update trig_tab2 set f2=f2+1, f1 = f1||lpad('aaa',4,'bbb');
END;
/

CREATE OR REPLACE TRIGGER trig_2 BEFORE UPDATE ON trig_tab2
FOR EACH ROW
BEGIN
  update trig_tab3 set f2=f2+1, f1 = f1||lpad('aaa',4,'bbb');
END;
/

update trig_tab1 set f1=f1+1;

drop table if exists add_policy_table_001;
create table add_policy_table_001(id int);

CREATE OR REPLACE FUNCTION f_add_policy(P_Schema in varchar2,P_Object in varchar2) return varchar2
AS
BEGIN
   RETURN 'ID<2';
END f_add_policy;
/

drop trigger if exists add_policy_t001;
create or  replace trigger add_policy_t001 after insert on add_policy_table_001
begin
  DBE_AC_ROW.add_policy(object_schema => user, object_name => 'add_policy_table_002',policy_name => 'DBMS_RLS_001',function_schema => user,policy_function => 'f_add_policy', types => 'select',enable => TRUE);
end;
/
insert into add_policy_table_001 values(1);
commit;


drop table if exists tt1;
create table tt1(a int not null,b int not null, c varchar(8000) default lpad('a',8000)) crmode row;
CREATE UNIQUE INDEX idx1 on tt1(a);
begin
for i in 1..3 loop
insert into tt1(a,b) values(i,i*10); 
end loop;
end;
/
commit;

create or replace procedure pro_auto()
is
PRAGMA AUTONOMOUS_TRANSACTION;
begin
execute immediate 'create table '||dbe_random.get_string('l',10)||'(a int)';
end;
/

create or replace trigger trig_tt1 before insert on tt1
begin
  pro_auto();
  update tt1 set a=a+1; 
END;
/

update tt1 set a=a+1;
replace into tt1 select a+1,b,c from tt1;
select a,b from tt1 order by 1,2;

drop table if exists test_replace_trigger_aa;
create table test_replace_trigger_aa(f int);
CREATE OR REPLACE TRIGGER "test_replace_AA_BEFORE_INSERT"
before insert on test_replace_trigger_aa 
for each row 
begin 
if :new.f is null then 
select 66 into :new.f from sys_dummy; 
end if; 
end; 
/
replace into test_replace_trigger_aa set f = null;
select * from test_replace_trigger_aa;
drop table if exists test_replace_trigger_aa;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_trigger_coredump cascade;