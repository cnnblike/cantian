set serveroutput on;

-- plsql debug tool test
-- test prepare start
create or replace function is_target_create_session_id_table() return boolean is
begin
  execute immediate 'create table if not exists target_session_id_t(id int)';
  return true;
exception
  when others then
    return false;
end;
/

begin
  for i in 1..100000 loop
    if is_target_create_session_id_table() then
      execute immediate 'delete target_session_id_t';
	  commit;
	  exit;
    end if;
  end loop;
end;
/

declare
se_id int;
begin
se_id := dbe_debug.init(10000);
dbe_debug.uninit();
end;
/

declare
se_id int;
begin
  se_id := dbe_debug.init(10000);
  insert into target_session_id_t values(se_id);
end;
/
select * from table(dbg_control_info());

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

drop table target_session_id_t;
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
drop table if exists test_department_t;
-- test step1 end

-- test step2 start
create or replace procedure dbe_debug_006_PROC(a int,b int)
is
c int;
begin
for i in 1..4
loop
dbe_output.print_line('i='||i);  
c:=b+a+i;
end loop;
end;
/

call dbe_debug_006_PROC(3,5);

call dbe_debug_006_PROC(3,5);

call dbe_debug_006_PROC(3,8);

-- test step2 end

-- test step3 start
create or replace function FVT_FUN2_002 return int is 
a int;
begin
select count(*) into a from dual;
return a ;
end;
/

drop table if exists FVT_FUN1_02;
CREATE TABLE FVT_FUN1_02 (ID INT);

create or replace function FVT_FUN_01_b(a int) return INT  
is
m int :=0;
e int :=100;
s int :=-1;
c int ;
begin
c :=a;
if c = 0 then 

SELECT  ID  INTO  m  FROM FVT_FUN1_02 WHERE ID=0;
  return m;
else 
execute immediate ' select FVT_FUN2_002() from dual ';
return s;
end if ;
exception
  when others then return e;
end;
/

declare
a int;
begin
  a := FVT_FUN_01_b(0);
  dbe_output.print_line(a);
end;
/

drop table if exists FVT_FUN1_02;
-- test step3 end

-- test step4 start
create or replace procedure SET_DELETE_BREAK_PROC()
is
a int;
b int;
c int;
d int;
begin
a := 0;
b := 1;
c := 2;
d := 3;
end;
/

begin
  SET_DELETE_BREAK_PROC();
end;
/

create or replace procedure SET_DELETE_BREAK_PROC()
is
a int;
b int;
c int;
begin
a := 0;
b := 1;
c := 2;
end;
/

declare
a int;
begin
  a := 0;
end;
/
-- test step4 end

-- test step5 start
create or replace function dbe_debug_010_FUN return sys_refcursor
is
cursorv1 sys_refcursor;
begin
open cursorv1 for select 1, 2, 3 from dual;
return cursorv1;
end;
/

select dbe_debug_010_FUN() from dual;
-- test step5 end

-- test step6 start
call dbe_debug.uninit();
-- test step6 end

-- test step7 start
declare
a int;
begin
  a := 0;
end;
/
-- test step7 end

set serveroutput off;