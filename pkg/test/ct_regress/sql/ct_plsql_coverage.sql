set serveroutput on;

create or replace function test_for_loop_f return boolean is
  FunctionResult boolean;
  test_num       NUMBER;
  /*
  abc
  */
begin
  test_num := 0;
  <<loop_label>>
  FOR i IN 1..10 LOOP
  /*
  abc
  */
    test_num := test_num + 1;
    CONTINUE loop_label when i > 7;
    test_num := test_num + 1;
    CONTINUE;
    test_num := test_num + 1;
  END LOOP;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
  /*
  abc
  */
  return(FunctionResult);
exception
  when others then
  /*
  abc
  */
    SYS.dbe_output.print_line('other error');
    return(FunctionResult);
end;
/

create or replace procedure test_for_loop_p is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 0;
  FOR i IN 1..10 LOOP
    test_num := test_num + 1;
    CONTINUE when i > 7;
    test_num := test_num + 1;
    CONTINUE;
    test_num := test_num + 1;
  END LOOP;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
exception
  when others then
    SYS.dbe_output.print_line('other error');
end;
/

create or replace function test_while_loop_f return boolean is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 5;
  WHILE test_num > 1 LOOP
    test_num := test_num - 1;
    test_num := test_num - 1;
    CONTINUE;
    test_num := test_num - 1;
  END LOOP;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
  return(FunctionResult);
exception
  when others then
    SYS.dbe_output.print_line('other error');
    return(FunctionResult);
end;
/

create or replace procedure test_while_loop_p is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 5;
  WHILE test_num = 0 LOOP
    test_num := test_num - 1;
    test_num := test_num - 1;
    CONTINUE;
    test_num := test_num - 1;
  END LOOP;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
exception
  when others then
    SYS.dbe_output.print_line('other error');
end;
/

create or replace function test_loop_f return boolean is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 5;
  LOOP
    EXIT;
	test_num := 7;
  END LOOP;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
  return(FunctionResult);
exception
  when others then
    SYS.dbe_output.print_line('other error');
    return(FunctionResult);
end;
/

create or replace procedure test_loop_p is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 5;
  LOOP
    GOTO goto_label;
	test_num := 7;
  END LOOP;
  dbe_output.print_line(test_num);
  <<goto_label>>
  FunctionResult := TRUE;
exception
  when others then
    SYS.dbe_output.print_line('other error');
end;
/

create or replace function test_if_else_f return boolean is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 18;
  IF test_num = 17 THEN
    FunctionResult := TRUE;
  ELSIF test_num = 18 THEN
    FunctionResult := FALSE;
  ELSE
    FunctionResult := FALSE;
  END IF;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
  return(FunctionResult);
exception
  when others then
    SYS.dbe_output.print_line('other error');
    return(FunctionResult);
end;
/

create or replace procedure test_if_else_p is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 19;
  IF test_num = 17 THEN
    FunctionResult := TRUE;
  ELSIF test_num = 18 THEN
    FunctionResult := FALSE;
  ELSE
    FunctionResult := FALSE;
  END IF;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
exception
  when others then
    SYS.dbe_output.print_line('other error');
end;
/

create or replace function test_case_f return boolean is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 19;
  CASE test_num
  WHEN 19 THEN
    FunctionResult := FALSE;
  WHEN 20 THEN
    FunctionResult := FALSE;
  END CASE;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
  return(FunctionResult);
exception
  when others then
    SYS.dbe_output.print_line('other error');
    return(FunctionResult);
end;
/

create or replace procedure test_case_p is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 20;
  CASE test_num
  WHEN 19 THEN
    FunctionResult := FALSE;
  WHEN 20 THEN
    FunctionResult := FALSE;
  END CASE;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
exception
  when others then
    SYS.dbe_output.print_line('other error');
end;
/

create or replace procedure test_level_3_p is
v1 int;
begin
  v1 := 1;
end;
/

create or replace procedure test_level_2_p is
begin
  test_level_3_p();
end;
/

create or replace procedure test_level_1_p is
begin
  test_level_2_p();
end;
/

drop user if exists gs_plsql_cover cascade;
create user gs_plsql_cover identified by Abc123456;
grant dba to gs_plsql_cover;
grant EXECUTE on test_for_loop_f to gs_plsql_cover;
grant EXECUTE on test_for_loop_p to gs_plsql_cover;
grant EXECUTE on test_while_loop_f to gs_plsql_cover;
grant EXECUTE on test_while_loop_p to gs_plsql_cover;
grant EXECUTE on test_loop_f to gs_plsql_cover;
grant EXECUTE on test_loop_p to gs_plsql_cover;
grant EXECUTE on test_if_else_f to gs_plsql_cover;
grant EXECUTE on test_if_else_p to gs_plsql_cover;
grant EXECUTE on test_case_f to gs_plsql_cover;
grant EXECUTE on test_case_p to gs_plsql_cover;
grant EXECUTE on test_level_1_p to gs_plsql_cover;
grant EXECUTE on test_level_2_p to gs_plsql_cover;
grant EXECUTE on test_level_3_p to gs_plsql_cover;

alter system set COVERAGE_ENABLE = FALSE;
drop table if exists COVERAGE$;
alter system set COVERAGE_ENABLE = TRUE;
conn gs_plsql_cover/Abc123456@127.0.0.1:1611

alter system set COVERAGE_ENABLE = TRUE;

drop table if exists test_sql_t;
create table test_sql_t(a int, b number(2), c varchar(20));
create or replace procedure test_sql_p is
sql_str varchar(80);
v1 int;
begin
  delete test_sql_t;
  insert into test_sql_t(a,b,c)
    values(1, 2, '3');
  sql_str := 'insert into test_sql_t(a,b,c) values(4, 15, ''16'')';
  execute immediate sql_str;
  select a into v1 
  from test_sql_t 
  where b = 5;
exception
  when no_data_found then
    SYS.dbe_output.print_line('not found error');
  when others then
    SYS.dbe_output.print_line('other error');
end;
/

create or replace trigger test_trigger after delete on test_sql_t
begin
  insert into test_sql_t(a,b,c) values(9, 20, '30');
  return;
  insert into test_sql_t(a,b,c) values(10, 30, '100');
end;
/

drop table if exists test_func_in_dml_t;
create table test_func_in_dml_t(a int);
insert into test_func_in_dml_t(a) values(10);
create or replace function test_func_in_dml_f(p1 int) return int is
begin
  return p1;
end;
/

create or replace procedure test_out_param_p(p1 out int) is
  v1 int;
begin
  p1 := 1;
end;
/

declare
  v1 int;
begin
  test_out_param_p(v1);
end;
/

select sys.test_for_loop_f() from dual;
call sys.test_for_loop_p();
select sys.test_while_loop_f() from dual;
call sys.test_while_loop_p();
select sys.test_loop_f() from dual;
call sys.test_loop_p();
select sys.test_if_else_f() from dual;
call sys.test_if_else_p();
select sys.test_case_f() from dual;
call sys.test_case_p();
call test_sql_p();
call sys.test_level_1_p();
update test_func_in_dml_t set a = test_func_in_dml_f(2) where a = 10;

conn sys/Huawei@123@127.0.0.1:1611

select count(*) from user_indexes where INDEX_NAME = 'IX_COVERAGE';

select OWNER,OBJ_NAME,COVER_INFO from COVERAGE$ where OWNER != 'COVERAGE' and OBJ_NAME like 'TEST_%';

create or replace function test_loop_func(p1 int) return int is
begin
  return p1;
end;
/

declare
v1 int;
begin
  for i in 1..50 loop
    v1 := test_loop_func(i);
  end loop;
end;
/

select count(*) from COVERAGE$ where OBJ_NAME = 'TEST_LOOP_FUNC';

alter system set COVERAGE_ENABLE = FALSE;
drop table if exists COVERAGE$;
drop user gs_plsql_cover cascade;

-- test can not core
alter system set COVERAGE_ENABLE = TRUE;
DROP TABLE IF EXISTS FVT_TRIGGER_TABLE_yf_095;
create table FVT_TRIGGER_TABLE_yf_095 (id number,name varchar2(20),sal number);
insert into FVT_TRIGGER_TABLE_yf_095 values(35,'yueming',8000);
insert into FVT_TRIGGER_TABLE_yf_095 values(5,'yueming',3000);
insert into FVT_TRIGGER_TABLE_yf_095 values(3,'yueming',5000);

drop table if exists FVT_TRIGGER_TABLE_yf_100;
create table FVT_TRIGGER_TABLE_yf_100(id number,name varchar2(20),sal number);

create or replace view YF_view_1 as select  * from FVT_TRIGGER_TABLE_yf_095;
create or replace trigger del_YF_00
before delete or update or insert on FVT_TRIGGER_TABLE_yf_095 for each
row begin
insert into FVT_TRIGGER_TABLE_yf_100
values( 1,'test',1);
end;
/
delete from FVT_TRIGGER_TABLE_yf_095 where id =35;

drop trigger del_YF_00;
drop view YF_view_1;
drop table FVT_TRIGGER_TABLE_yf_100;
DROP TABLE FVT_TRIGGER_TABLE_yf_095;
alter system set COVERAGE_ENABLE = FALSE;
drop table if exists COVERAGE$;

--DTS2020011400868
alter system set UPPER_CASE_TABLE_NAMES= false;
drop table if exists t_vlan_mapping;

CREATE TABLE t_vlan_mapping(
devID INT not null,
vrID INT NOT NULL,
ifName varchar(63) not null,
mappingVid int NOT null,
transVlans  varchar(1948) not null,
deployStatus int not null,
transVlansBitMap varchar(1948) not null
);

insert into t_vlan_mapping values(1,1,'ddd',1,'fdff',1,'22222');

create or replace function func_getMappingVlan111(v_DevID   IN NUMBER ,v_vrID   IN NUMBER,v_ifName  IN VARCHAR2)
RETURN VARCHAR2
   as
   v_str VARCHAR2(1024);
begin
    v_str := '';
    for param in (select mappingVid,transVlans from t_vlan_mapping where devID = v_DevID and vrID = v_vrID and ifName = v_ifName) loop
        if param.transVlans is null or param.transVlans = '--' then
            v_str := v_str||'{"vlan":null,"mapping-vlan":';
        else
            v_str := v_str||'{"vlan":"'||param.transVlans||'","mapping-vlan":';
        end if;
        
        if param.mappingVid is null then
            v_str := v_str||'null},';
        else 
            v_str := v_str||'"'||param.mappingVid||'"'||'},';
        end if;
    end loop;
    if instr(v_str,',') > 0 then
        v_str := SUBSTR(v_str,0,LENGTH(v_str)-1);
    end if;
    if length(v_str) > 0 then
        v_str := '['||v_str|| ']';
    else
        v_str := null;
    end if;
   return(v_str);
end;
/

select func_getMappingVlan111(1,1,'ddd') from dual;
drop function func_getMappingVlan111;
drop TABLE t_vlan_mapping;
alter system set UPPER_CASE_TABLE_NAMES= true;

select * from GADM_TABLES;
alter system set UPPER_CASE_TABLE_NAMES=FALSE;
select * from sys.GADM_TABLES;
alter system set UPPER_CASE_TABLE_NAMES=TRUE;


set serveroutput off;
