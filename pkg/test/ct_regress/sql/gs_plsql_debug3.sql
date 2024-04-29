set serveroutput on;

-- test prepare start
create or replace function is_target_user_create(id out int) return boolean is
begin
  execute immediate 'select id from target_user_id_t where id = 0' into id;
  return true;
exception
  when others then
    return false;
end;
/

declare
se_id int;
begin
  for i in 1..100000 loop
    if is_target_user_create(se_id) then
	  execute immediate 'insert into target_user_id_t values(1)';
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

GRANT EXECUTE ON is_target_session_init TO gs_plsql_target;
GRANT EXECUTE ON get_target_waiting TO gs_plsql_target;
GRANT EXECUTE ON get_target_waiting_or_idle TO gs_plsql_target;
GRANT EXECUTE ON get_target_executing TO gs_plsql_target;

conn gs_plsql_target/Abc123456@127.0.0.1:1611

declare
se_id int;
begin
  for i in 1..100000 loop
    if sys.is_target_session_init(se_id) then
      dbe_debug.attach(se_id, 9);
	  execute immediate 'insert into sys.target_session_id_t values(0)';
	  execute immediate 'select id from sys.target_session_id_t where id = 0' into se_id;
	  dbe_output.print_line(se_id);
	  for item in 1..10000 loop
	    execute immediate 'insert into gs_plsql_target.waste_time_t values(:1)' using item;
	  end loop;
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
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(6, 10);
-- test step1 end

conn sys/Huawei@123@127.0.0.1:1611

set serveroutput off;