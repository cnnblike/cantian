set serveroutput on;

select dbe_debug.get_version() as debug_version from dual;

-- plsql debug tool test
-- test prepare start
drop table if exists target_session_id_t;
create table target_session_id_t(id int);

declare
se_id int;
begin
  se_id := dbe_debug.init(10000);
  insert into target_session_id_t values(se_id);
end;
/

commit;

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

begin
  for i in 1..10000000 loop
    if is_debug_session_attaching() then
	  exit;
	end if;
  end loop;
end;
/
-- test prepare end

-- test step1 start
drop table if exists test_department_t;
create table test_department_t(id int, name varchar(20), province varchar(20), register_time date);
insert into test_department_t values(1, 'zyc', 'hunan', '2014-01-01 00:00:00');
insert into test_department_t values(2, 'whf', 'fujian', '2010-01-01 00:00:00');
insert into test_department_t values(3, 'pfa', 'sichuan', '2018-01-01 00:00:00');
insert into test_department_t values(4, 'fc', 'jiangsu', '2015-01-01 00:00:00');
insert into test_department_t values(4, 'hsf', 'fujian', '2018-01-01 00:00:00');

create or replace function test_lv2_func1(p1 int) return int is
v1 int;
begin
  <<test_lv2_func1_for>>
  for i in 1..1 loop
    v1 := p1 * 2;
  end loop;
  return v1;
end;
/

create or replace function test_lv1_func1(p1 int, p2 number) return int is
begin
  return test_lv2_func1(p1) + p2;
end;
/

CREATE OR REPLACE PROCEDURE test_lv2_proc1(p1 varchar, resultSet out sys_refcursor) is
begin
  open resultSet for select * from test_department_t where province = p1;
end;
/

CREATE OR REPLACE function test_lv1_func2(p1 varchar) return boolean is
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

create or replace trigger test_lvx_trigger1 before insert on test_department_t FOR EACH ROW is
v1 int;
begin
  select count(*) into v1 from test_department_t;
  :new.id := v1;
end;
/

CREATE OR REPLACE PROCEDURE test_lv1_proc1(p1 varchar) is
begin
  insert into test_department_t values(0, p1, 'fujian', '2019-01-01 00:00:00');
end;
/

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
drop table if exists target_session_id_t;
drop table if exists test_department_t;
-- test step1 end

-- test step2 start
CREATE OR REPLACE PROCEDURE test_lv2_debug(p1 in out varchar, p2 int) is
v1 int := 1;
begin
  v1 := v1 / p2;
  p1 := p1 || ' debug coming...';
exception
  when others then
    p1 := p1 || ' debug came!!!';
end;
/

CREATE OR REPLACE PROCEDURE test_lv2_world(p1 in out varchar) is
begin
  p1 := p1 || ' world';
  test_lv2_debug(p1, 0);
end;
/

CREATE OR REPLACE PROCEDURE test_lv1_hello is
v1 varchar(100);
begin
  v1 := 'hello';
  test_lv2_world(v1);
end;
/

call test_lv1_hello();
-- test step2 end

-- test step3 start
CREATE OR REPLACE PROCEDURE test_record_var() is
type record_type is record(
  r_int int,
  r_num number(20,5),
  r_varc varchar(20),
  r_c char(20),
  r_date date,
  r_doub double);
v1_record record_type;
begin
  dbe_output.print_line('v1_record.r_int: ' || v1_record.r_int);
  dbe_output.print_line('v1_record.r_num: ' || v1_record.r_num);
  dbe_output.print_line('v1_record.r_varc: ' || v1_record.r_varc);
  dbe_output.print_line('v1_record.r_c: ' || v1_record.r_c);
  dbe_output.print_line('v1_record.r_date: ' || v1_record.r_date);
  dbe_output.print_line('v1_record.r_doub: ' || v1_record.r_doub);
end;
/

declare
v1_int int;
v2_num number(20,5);
v3_varc varchar(20);
v4_c char(20);
v5_date date;
v6_doub double;
begin
  dbe_output.print_line('v1_int: ' || v1_int);
  dbe_output.print_line('v2_num: ' || v2_num);
  dbe_output.print_line('v3_varc: ' || v3_varc);
  dbe_output.print_line('v4_c: ' || v4_c);
  dbe_output.print_line('v5_date: ' || v5_date);
  dbe_output.print_line('v6_doub: ' || v6_doub);
  test_record_var();
end;
/
-- test step3 end

-- test step4 start
drop table if exists  test_breakpoint_t;
create table test_breakpoint_t(id int, name varchar(20), place varchar(20), register_time date);
insert into test_breakpoint_t values(1, 'zyc', 'hunan', '2014-01-01 00:00:00');
insert into test_breakpoint_t values(2, 'whf', 'fujian', '2010-01-01 00:00:00');
insert into test_breakpoint_t values(3, 'pfa', 'sichuan', '2018-01-01 00:00:00');
insert into test_breakpoint_t values(4, 'fc', 'jiangsu', '2015-01-01 00:00:00');
insert into test_breakpoint_t values(4, 'hsf', 'fujian', '2018-01-01 00:00:00');
commit;


create or replace function TEST_BREAK_LV3_FUNC1(p1 int) return int is
v1 int;
begin
  v1 := p1 * 2;
  SYS.dbe_output.print_line('v1 = ' || v1);
  return v1;
end;
/

create or replace function TEST_BREAK_LV2_FUNC1(p1 int) return int is
v1 int;
begin
  v1 := TEST_BREAK_LV3_FUNC1(p1) * 2;
  SYS.dbe_output.print_line('v1 = ' || v1);
  return v1;
end;
/

create or replace function TEST_BREAK_LV1_FUNC1(p1 int, p2 number) return int is
begin
  SYS.dbe_output.print_line('execute test_break_lv1_func1');
  return TEST_BREAK_LV2_FUNC1(p1) + p2;
end;
/

CREATE OR REPLACE PROCEDURE test_break_lv2_proc1(p1 varchar, resultSet out sys_refcursor) is
begin
  open resultSet for select * from test_breakpoint_t where place = p1;
end;
/

CREATE OR REPLACE function test_break_lv1_func2(p1 varchar) return boolean is
v1_cur sys_refcursor;
type employee is record(
  id int,
  name varchar(20),
  place varchar(20),
  register_time date);
v2_record employee;
begin
  for item in (select * from test_breakpoint_t where place = p1) 
  loop
    if (item.name = p1) then
      return true;
    end if;
  end loop;
  test_break_lv2_proc1('fujian', v1_cur);
  fetch v1_cur into v2_record;
  return false;
exception
  when others then
    return false;
end;
/

CREATE OR REPLACE PROCEDURE test_break_lv1_proc1(p1 varchar) is
begin
  insert into test_breakpoint_t values(0, p1, 'fujian', '2019-01-01 00:00:00');
end;
/

create or replace trigger test_break_lvx_trigger1 before insert on test_breakpoint_t FOR EACH ROW is
v1 int;
begin
  select count(*) into v1 from test_breakpoint_t;
  :new.id := v1;
end;
/

declare
v1_int int;
v2_num number(20,5);
v3_varc varchar(20);
v4_c char(20);
v5_date date;
v6_doub double;
begin
  v2_num := 6.7;
  v1_int := TEST_BREAK_LV1_FUNC1(3, v2_num);
  v3_varc := 'pfa';
  if test_break_lv1_func2(v3_varc) then
    return;
  end if;
  test_break_lv1_proc1(v3_varc);
end;
/


drop trigger if exists test_lvx_trigger1;
drop trigger if exists test_break_lvx_trigger1;
drop table if exists target_session_id_t;
drop table if exists test_department_t;
drop table if exists test_breakpoint_t;
-- test step4 end

set serveroutput off;