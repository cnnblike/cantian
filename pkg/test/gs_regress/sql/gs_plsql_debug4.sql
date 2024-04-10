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
select dbe_debug.add_break('SYS','DROP_EXEC_FUNC','FUNCTION',5,0,'') from dual;
call dbe_debug.resume(7, 100);
select * from SYS.DV_PLSQL_SHARED_LOCKS l where l.OBJECT='DROP_EXEC_FUNC';
drop table if exists drop_exec_func_id_t;
create table drop_exec_func_id_t(id int);
insert into drop_exec_func_id_t values(0);
commit;
call sleep(3);
select dbe_debug.add_break('SYS','DROP_EXEC_FUNC','FUNCTION',5,0,'') from dual;
select * from table(dbg_break_info(0));
select * from SYS.DV_PLSQL_SHARED_LOCKS l where l.OBJECT='DROP_EXEC_FUNC';
call dbe_debug.resume(7, 0);
drop table if exists drop_exec_func_id_t;
-- test step1 end

-- test2 start
call sys.get_target_waiting();
call dbe_debug.resume(1, 100);
select dbe_debug.get_value(1,0,1,0) from dual;
call dbe_debug.resume(7, 0);
-- test2 end

-- test3 start
call sys.get_target_waiting();
call dbe_debug.resume(1, 100);
call dbe_debug.resume(1, 100);
select * from table(dbg_proc_callstack(0));
call dbe_debug.resume(7, 0);
-- test3 end

-- test4 start
call sys.get_target_waiting();
call dbe_debug.resume(1, 100);
select NAME, TYPE, PARENT, VID_ID, VID_OFFSET, VALUE from table(dbg_show_values(0));
select dbe_debug.get_value(1,0,4,2) from dual;
select dbe_debug.set_value(1,0,4,2,'7') from dual;
select dbe_debug.get_value(1,0,4,2) from dual;
select dbe_debug.get_value(1,0,4,5) from dual;
select dbe_debug.get_value(1,0,4,8) from dual;
select dbe_debug.set_value(1,0,4,8,'u') from dual;
select dbe_debug.get_value(1,0,4,8) from dual;
select dbe_debug.get_value(1,0,4,11) from dual;
select dbe_debug.get_value(1,0,4,12) from dual;
select NAME, TYPE, PARENT, VID_ID, VID_OFFSET, VALUE from table(dbg_show_values(0)) where VID_ID = 4;
call dbe_debug.resume(7, 0);
-- test4 end

-- test5 start
call sys.get_target_waiting();
call dbe_debug.resume(1, 100);
select NAME, TYPE, PARENT, VID_ID, VID_OFFSET, VALUE from table(dbg_show_values(0));
select dbe_debug.get_value(1,0,0,1) from dual;
select dbe_debug.set_value(1,0,0,1,'5') from dual;
select dbe_debug.get_value(1,0,0,1) from dual;
select dbe_debug.get_value(1,0,0,4) from dual;
call dbe_debug.resume(7, 0);
-- test5 end

-- test6 start
call sys.get_target_waiting();
call dbe_debug.resume(1, 100);
select NAME, TYPE, PARENT, VID_ID, VID_OFFSET, VALUE from table(dbg_show_values(0));
select dbe_debug.get_value(1,0,0,0) from dual;
select dbe_debug.set_value(1,0,0,1, '1') from dual;
call dbe_debug.resume(7, 0);
-- test6 end

conn sys/Huawei@123@127.0.0.1:1611
drop table if exists target_session_id_t;
drop user if exists gs_plsql_debug cascade;
drop user if exists gs_plsql_debug2 cascade;

set serveroutput off;