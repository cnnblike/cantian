set serveroutput on;

-- test prepare start
drop user if exists gs_plsql_debug cascade;
create user gs_plsql_debug identified by Abc123456;
grant dba to gs_plsql_debug;
drop user if exists gs_plsql_debug2 cascade;
create user gs_plsql_debug2 identified by Abc123456;
grant create session to gs_plsql_debug2;

create or replace function is_debug_create_session_id_table() return boolean is
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
    if is_debug_create_session_id_table() then
	  exit;
    end if;
  end loop;
end;
/

create or replace function is_target_session_init(id out int) return boolean is
begin
  execute immediate 'select id from target_session_id_t where id != -1' into id;
  return true;
exception
  when others then
    return false;
end;
/

create or replace PROCEDURE get_target_waiting() is
begin
  for i in 1..1000000000 loop
    if dbe_debug.get_status() = 2 then
	  exit;
    end if;
  end loop;
end;
/

create or replace PROCEDURE get_target_waiting_or_idle() is
begin
  for i in 1..1000000000 loop
    if dbe_debug.get_status() = 2 then
	  exit;
    end if;
    if dbe_debug.get_status() = 0 then
	  exit;
    end if;
  end loop;
end;
/

create or replace PROCEDURE get_target_executing() is
begin
  for i in 1..1000000000 loop
    if dbe_debug.get_status() = 1 then
	  exit;
    end if;
  end loop;
end;
/

GRANT EXECUTE ON is_target_session_init TO gs_plsql_debug;
GRANT EXECUTE ON get_target_waiting TO gs_plsql_debug;
GRANT EXECUTE ON get_target_waiting_or_idle TO gs_plsql_debug;
GRANT EXECUTE ON get_target_executing TO gs_plsql_debug;
GRANT select on target_session_id_t to gs_plsql_debug;
GRANT insert on target_session_id_t to gs_plsql_debug;
GRANT EXECUTE ON is_target_session_init TO gs_plsql_debug2;
GRANT EXECUTE ON get_target_waiting TO gs_plsql_debug2;
GRANT EXECUTE ON get_target_waiting_or_idle TO gs_plsql_debug2;
GRANT EXECUTE ON get_target_executing TO gs_plsql_debug2;
GRANT select on target_session_id_t to gs_plsql_debug2;
GRANT insert on target_session_id_t to gs_plsql_debug2;

conn gs_plsql_debug2/Abc123456@127.0.0.1:1611

declare
se_id int;
begin
  for i in 1..100000 loop
    if sys.is_target_session_init(se_id) then
      dbe_debug.attach(se_id, 9);
	  execute immediate 'insert into sys.target_session_id_t values(0)';
	  exit;
    end if;
  end loop;
end;
/

conn gs_plsql_debug/Abc123456@127.0.0.1:1611

declare
se_id int;
begin
  for i in 1..100000 loop
    if sys.is_target_session_init(se_id) then
      dbe_debug.attach(se_id, 9);
	  execute immediate 'insert into sys.target_session_id_t values(0)';
	  execute immediate 'select id from sys.target_session_id_t where id = 0' into se_id;
	  dbe_output.print_line(se_id);
	  commit;
	  exit;
    end if;
  end loop;
end;
/

call sys.get_target_waiting();
call dbe_debug.resume(4, 0);
-- test prepare end

-- test step1 start
call sys.get_target_waiting();
select dbe_debug.add_break('SYS', 'TEST_LV1_FUNC2', 'FUNCTION', 12, 0, '') as break_id from dual;
select dbe_debug.add_break('SYS', 'TEST_LV1_FUNC2', 'FUNCTION', 24, 0, '') as break_id from dual;
select dbe_debug.add_break('SYS', 'TEST_LVX_TRIGGER1', 'TRIGGER', 3, 0, '') as break_id from dual;
call dbe_debug.delete_break_by_name('SYS','TEST_LVX_TRIGGER1', 'TRIGGER');
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--1
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0.2));
select * from table(dbg_show_values(0));
select dbe_debug.get_value(2,0,0,0) from dual;
select dbe_debug.get_value(1,1,0,0) from dual;
select dbe_debug.get_value(1,0,6,0) from dual;
select dbe_debug.get_value(1,0,5,1) from dual;
select * from table(dbg_show_values(0.4));
call dbe_debug.resume(1, 100);
--2
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
declare
stack_id int := 0;
begin
	execute immediate 'select * from table(dbg_proc_callstack(:1))' using stack_id;
end;
/
select * from table(dbg_show_values(0));
declare
stack_id int := 0;
begin
	execute immediate 'select * from table(dbg_show_values(:1))' using stack_id;
end;
/
call dbe_debug.resume(1, 100);
--3
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--4
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--5
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--6
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--7
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--8
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--9
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--10
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--11
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--12
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
select dbe_debug.get_value(2,0,5,0) from dual;
begin
	execute immediate 'select dbe_debug.get_value(2,0,:1,0) from dual' using 5;
end;
/
call dbe_debug.set_value(2,0,5,0,'123');
begin
	execute immediate 'call dbe_debug.set_value(2,:1,5,0,''123'')' using 0;
end;
/
call dbe_debug.resume(1, 100);
--13
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--13
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--14
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--15
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--16
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
select dbe_debug.get_value(2,0,2,0) from dual;
call dbe_debug.set_value(2,0,2,0,'123');
call dbe_debug.resume(1, 100);
--17
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--18
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--19
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--20
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--21
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--22
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--23
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--24
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
--25
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(6, 0);
-- test step1 end

-- test step2 start
call sys.get_target_waiting();
select dbe_debug.add_break('SYS','dbe_debug_006_PROC','PROCEDURE',7,3,'') as break_id from dual;
select * from table(dbg_break_info(0));
call dbe_debug.resume(7, 100);
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(7, 0);

call sys.get_target_waiting();
call dbe_debug.update_break(1, 4);
select * from table(dbg_break_info(0));
call dbe_debug.resume(7, 0);

call sys.get_target_waiting();
call dbe_debug.update_break(1, 2);
select * from table(dbg_break_info(0));
call dbe_debug.resume(7, 100);
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(7, 0);
-- test step2 end

-- test step3 start
call sys.get_target_waiting();
call dbe_debug.resume(5,100);
begin
	execute immediate 'call dbe_debug.resume(:1, 0)' using 7;
end;
/
-- test step3 end

-- test step4 start
declare
id_line_8 int;
id_line_9 int;
id_line_10 int;
id_line_11 int;
begin
sys.get_target_waiting();
id_line_8 := dbe_debug.add_break('SYS','SET_DELETE_BREAK_PROC','PROCEDURE',8,0,'');
id_line_9 := dbe_debug.add_break('SYS','SET_DELETE_BREAK_PROC','PROCEDURE',9,0,'');
id_line_10 := dbe_debug.add_break('SYS','SET_DELETE_BREAK_PROC','PROCEDURE',10,0,'');
id_line_11 := dbe_debug.add_break('SYS','SET_DELETE_BREAK_PROC','PROCEDURE',11,0,'');
dbe_debug.set_break(id_line_10, 0);
dbe_debug.resume(7, 100);
dbe_debug.set_break(id_line_9, 0);
dbe_debug.set_break(id_line_10, 1);
dbe_debug.resume(7, 100);
dbe_debug.delete_break(id_line_11);
end;
/
select * from table(dbg_break_info(0));
select * from table(dbg_break_info(5.6));
select * from table(dbg_break_info(7));
begin
	execute immediate 'call dbe_debug.delete_break(:1)' using 0;
end;
/
select * from table(dbg_break_info(0));
declare
break_id int := 0;
begin
	execute immediate 'select * from table(dbg_break_info(:1))' using break_id;
end;
/
declare
line int := 8;
begin
	execute immediate 'select dbe_debug.add_break(''SYS'', ''SET_DELETE_BREAK_PROC'', ''PROCEDURE'', :1, 0, '''') from dual' using line;
end;
/
select dbe_debug.add_break('SYS','SET_DELETE_BREAK_PROC','PROCEDURE',9,0,'') as break_id from dual;
select dbe_debug.add_break('SYS','SET_DELETE_BREAK_PROC','PROCEDURE',10,0,'') as break_id from dual;
select dbe_debug.add_break('SYS','SET_DELETE_BREAK_PROC','PROCEDURE',11,0,'') as break_id from dual;
call dbe_debug.delete_break_by_name('SYS','SET_DELETE_BREAK_PROC', 'PROCEDURE');
select * from table(dbg_break_info(0));
select dbe_debug.add_break('SYS','SET_DELETE_BREAK_PROC','PROCEDURE',9,0,'') as break_id from dual;
select dbe_debug.add_break('SYS','SET_DELETE_BREAK_PROC','PROCEDURE',10,0,'') as break_id from dual;
select dbe_debug.add_break('SYS','SET_DELETE_BREAK_PROC','PROCEDURE',11,0,'') as break_id from dual;
call dbe_debug.resume(6, 0);
call sys.get_target_waiting();
select * from table(dbg_break_info(0));
call dbe_debug.delete_break_by_name('SYS','SET_DELETE_BREAK_PROC','PROCEDURE');
call dbe_debug.resume(7, 0);
-- test step4 end

-- test step5 start
call sys.get_target_waiting();
call dbe_debug.resume(1, 100);
select dbe_debug.get_value(1,0,0,0);
select dbe_debug.get_value(1,0,1,0);
call dbe_debug.resume(7, 0);
-- test step5 end

-- test step6 start
call sys.get_target_waiting();
call dbe_debug.resume(7,0);
-- test step6 end

-- test step7 start
call sys.get_target_waiting();
drop table if exists TEST_TABLE_FOR_VALID_BREAK;
create table TEST_TABLE_FOR_VALID_BREAK(id int,name varchar(100),email varchar(100));
create or replace procedure TEST_PROC_FOR_VALID_BREAK is
begin
	insert into TEST_TABLE_FOR_VALID_BREAK values(1,'hello'||1,'hello'||1||'@126.com');
	insert into TEST_TABLE_FOR_VALID_BREAK values(2,'hello'||2,'hello'||2||'@126.com');
end;
/
call dbe_debug.delete_break(0);
select dbe_debug.add_break('GS_PLSQL_DEBUG','TEST_PROC_FOR_VALID_BREAK','procedure',4,0,'') from SYS_DUMMY;
select * from table(dbg_break_info(0));
alter table TEST_TABLE_FOR_VALID_BREAK add sex char(2);
select * from table(dbg_break_info(0));
call dbe_debug.resume(7,0);
-- test step7 end

conn sys/Huawei@123@127.0.0.1:1611
drop table if exists target_session_id_t;
drop user if exists gs_plsql_debug cascade;
drop user if exists gs_plsql_debug2 cascade;

set serveroutput off;