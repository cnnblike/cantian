set serveroutput on;

-- plsql debug tool test
-- test prepare start
drop user if exists gs_plsql_target cascade;
create user gs_plsql_target identified by Abc123456;
grant create session to gs_plsql_target;
drop user if exists gs_plsql_target2 cascade;
create user gs_plsql_target2 identified by Abc123456;
grant create session to gs_plsql_target2;
drop table if exists target_user_id_t;
create table target_user_id_t(id int);
insert into target_user_id_t values(0);
drop table if exists target_session_id_t;
create table target_session_id_t(id int);
commit;
GRANT select on target_session_id_t to gs_plsql_target;
GRANT insert on target_session_id_t to gs_plsql_target;
grant create table to gs_plsql_target;

create or replace function is_debug_session_attaching() return boolean is
v1_id int;
begin
  select id into v1_id from target_session_id_t where id = 0;
  return true;
exception
  when others then
    return false;
end;
/

drop table if exists gs_plsql_target.test_department_t;
create table gs_plsql_target.test_department_t(id int, name varchar(20), province varchar(20), register_time date);
insert into gs_plsql_target.test_department_t values(1, 'zyc', 'hunan', '2014-01-01 00:00:00');
insert into gs_plsql_target.test_department_t values(2, 'whf', 'fujian', '2010-01-01 00:00:00');
insert into gs_plsql_target.test_department_t values(3, 'pfa', 'sichuan', '2018-01-01 00:00:00');
insert into gs_plsql_target.test_department_t values(4, 'fc', 'jiangsu', '2015-01-01 00:00:00');
insert into gs_plsql_target.test_department_t values(4, 'hsf', 'fujian', '2018-01-01 00:00:00');

create or replace function gs_plsql_target2.test_lv2_func1(p1 int) return int is
v1 int;
begin
  <<test_lv2_func1_for>>
  for i in 1..1 loop
    v1 := p1 * 2;
  end loop;
  return v1;
end;
/
GRANT EXECUTE ON gs_plsql_target2.test_lv2_func1 TO gs_plsql_target;

create or replace function gs_plsql_target.test_lv1_func1(p1 int, p2 number) return int is
begin
  return gs_plsql_target2.test_lv2_func1(p1) + p2;
end;
/

CREATE OR REPLACE PROCEDURE gs_plsql_target.test_lv2_proc1(p1 varchar, resultSet out sys_refcursor) is
begin
  open resultSet for select * from test_department_t where province = p1;
end;
/

CREATE OR REPLACE function gs_plsql_target.test_lv1_func2(p1 varchar) return boolean is
v1_cur sys_refcursor;
type place is record(
  province varchar(20),
  city varchar(20));
type employee is record(
  id int,
  name varchar(20),
  home place,
  register_time date);
v2_record employee;
begin
  for item in (select * from test_department_t where province = p1) 
  loop
    if (item.name = p1) then
      return true;
    end if;
  end loop;
  test_lv2_proc1('fujian', v1_cur);
  fetch v1_cur into v2_record.id, v2_record.name, v2_record.home.province, v2_record.register_time;
  v2_record.home.city := 'fuzhou';
  return false;
exception
  when others then
    return false;
end;
/

create or replace trigger gs_plsql_target.test_lvx_trigger1 before insert on gs_plsql_target.test_department_t FOR EACH ROW is
v1 int;
begin
  select count(*) into v1 from test_department_t;
  :new.id := v1;
end;
/

CREATE OR REPLACE PROCEDURE gs_plsql_target.test_lv1_proc1(p1 varchar) is
begin
  insert into test_department_t values(0, p1, 'fujian', '2019-01-01 00:00:00');
end;
/

GRANT EXECUTE ON is_debug_session_attaching TO gs_plsql_target;
GRANT select on target_session_id_t to gs_plsql_target;
GRANT insert on target_session_id_t to gs_plsql_target;

conn gs_plsql_target/Abc123456@127.0.0.1:1611

drop table if exists waste_time_t;
create table waste_time_t(id int);

declare
se_id int;
begin
  se_id := dbe_debug.init(10000);
  insert into sys.target_session_id_t values(se_id);
end;
/

commit;

declare
a int;
begin
  for i in 1..10000000 loop
    if sys.is_debug_session_attaching() then
	  exit;
	end if;
  end loop;
end;
/

-- test prepare end

-- test step1 start

<<test_step1_begin>>
declare
v1_int int;
v2_num number(20,5);
v3_varc varchar(20);
v4_c char(20);
v5_date date;
v6_doub double;
begin
  v2_num := 6.7;
  v1_int := test_lv1_func1(3, v2_num);
  v3_varc := 'pfa';
  if test_lv1_func2(v3_varc) then
    return;
  end if;
  test_lv1_proc1(v3_varc);
end;
/

drop trigger test_lvx_trigger1;
drop table if exists test_department_t;
-- test step1 end

delete waste_time_t;
drop table waste_time_t;

conn sys/Huawei@123@127.0.0.1:1611
drop table if exists target_user_id_t;
drop table if exists target_session_id_t;
drop user if exists gs_plsql_target cascade;
drop user if exists gs_plsql_target2 cascade;

set serveroutput off;