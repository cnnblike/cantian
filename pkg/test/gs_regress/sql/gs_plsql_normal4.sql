set serveroutput on;

-- plsql debug tool test
-- test step1 start
create or replace function is_drop_exec_func_stop() return boolean is
begin
  execute immediate 'select id from gs_plsql_debug.drop_exec_func_id_t where id = 0';
  return true;
exception
  when others then
    return false;
end;
/

begin
  for i in 1..100000 loop
    if sys.is_drop_exec_func_stop() then
	  exit;
    end if;
  end loop;
end;
/
drop function drop_exec_func;
-- test step1 end

set serveroutput off;