--DTS202007170FKPH8P1100
--second session
conn / as sysdba
drop procedure if exists lock_proc1;

create or replace function is_target_proc(id out int) return boolean is
begin
  execute immediate 'select OBJ# from sys_procs where name = ''LOCK_PROC1''' into id;
  return true;
exception
  when others then
    return false;
end;
/

create or replace function is_target_plsql(id out int) return boolean is
begin
  execute immediate 'select count(*) from dv_plsql_shared_locks where OBJECT = ''LOCK_PROC1''' into id;
  if id > 0 then
    return true;
  else
    return false;
  end if;
exception
  when others then
    return false;
end;
/

declare
oid int default 0;
begin
  for i in 1..100000 loop
    if is_target_proc(oid) then
      execute immediate 'delete from lock_test1 where rownum <= 5';
      exit;
    end if;
  end loop;
end;
/

declare
sid int default 0;
begin
  for i in 1..100 loop
    if is_target_plsql(sid) then
      execute immediate '
      create or replace procedure lock_proc1 is
          pragma autonomous_transaction;
          begin
              insert into lock_test2 select * from lock_test2 limit 10;
              update lock_test2 set id = 0 where rownum <= 10;
          commit;
          end;
      ';
      exit;
    end if;
  end loop;
end;
/

select sleep(1);
drop function if exists is_target_proc;
drop function if exists is_target_plsql;
drop function if exists is_target_object;
drop procedure if exists lock_proc1;
drop table if exists lock_test2;
drop table if exists lock_test1;