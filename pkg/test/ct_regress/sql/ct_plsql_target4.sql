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
create or replace function drop_exec_func(p1 int) return int
is
a int;
begin
	a := p1 + 1;
	return a; 
end;
/

declare
a int;
begin
	a := 5;
	a := drop_exec_func(a);
end;
/
-- test step1 end

-- test2 start
declare
type xxx is varray(20) of varchar2(10);
v1 xxx := xxx('1','1','1');
begin
dbe_output.print_line(v1(2));
end;
/
-- test2 end

-- test3 start
CREATE OR REPLACE PACKAGE PAKtest
IS
 FUNCTION fun1 RETURN int;
 PROCEDURE pro1;
END;
/
CREATE OR REPLACE PACKAGE BODY PAKtest
IS
 FUNCTION fun1 RETURN int
IS
 var1 int;
 BEGIN
  var1 := 1;
  return var1;
 END;
PROCEDURE pro1 IS
 V1 INT;
 BEGIN
  V1:= fun1;
  dbe_output.print_line(V1);
 END;
END;
/
CALL PAKtest.pro1;
drop package if exists PAKtest;
-- test3 end

-- test4 start
create or replace type tab01 FORCE is table of varchar2(10);
/
create or replace type obj01 FORCE AS OBJECT(
oa int,
ob varchar(100),
oc number) not final;
/
declare
w obj01:= obj01(1, 'a', 0);
p tab01:=tab01('r', 't');
TYPE record1 IS RECORD(
re int,
rw int,
rt number
);
TYPE record_test IS RECORD(
x record1,
y tab01,
z obj01 default w,
q int,
d varchar(10) default 's',
e tab01 default p
);
v1 record_test;
begin
dbe_output.print_line(v1.q);
dbe_output.print_line(v1.d);
dbe_output.print_line(v1.x.re);
dbe_output.print_line(v1.z.ob);
end;
/
-- test4 end
-- test5 start
declare
v1 obj01 := obj01(1 ,2, 3);
begin
dbe_output.print_line(v1.oa);
dbe_output.print_line(v1.ob);
dbe_output.print_line(v1.oc);
end;
/
-- test5 end
-- test6 start
declare
v1 obj01;
begin
dbe_output.print_line(v1.oa);
end;
/
drop type if exists tab01 force;
drop type if exists obj01 force;
-- test6 end

set serveroutput off;