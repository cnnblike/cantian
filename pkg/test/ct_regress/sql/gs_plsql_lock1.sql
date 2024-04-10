--DTS202007170FKPH8P1100
--first session
conn / as sysdba
drop table if exists lock_test1;
drop table if exists lock_test2;
drop procedure if exists lock_proc1;
create table lock_test1(id int, name varchar(15));
create table lock_test2(id int, name varchar(15));

declare
i int;
begin
for i in 1..1000 loop
insert into lock_test1 values(i, 'a'||i);
end loop;
commit;
end;
/

declare
i int;
begin
for i in 1..20 loop
insert into lock_test2 values(i, 'b'||i);
end loop;
commit;
end;
/

create or replace procedure lock_proc1 is
pragma autonomous_transaction;
begin
insert into lock_test1 select * from lock_test1 limit 10;
update lock_test1 set  id = 0 where rownum <= 10;
commit;
end;
/
create or replace function is_target_object(id out int) return boolean is
begin
  execute immediate 'select SESSION_ID from dv_locked_objects where OBJECT_NAME = ''LOCK_TEST1''' into id;
  return true;
exception
  when others then
    return false;
end;
/

declare
sid int default 0;
begin
  for i in 1..50 loop
    if is_target_object(sid) then
      execute immediate 'call lock_proc1';
      exit;
    end if;
  end loop;
end;
/

