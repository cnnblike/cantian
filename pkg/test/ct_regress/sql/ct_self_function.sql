drop user if exists self_func_tst CASCADE;
create user self_func_tst identified by 'Cantian_234';
grant dba to self_func_tst;

conn self_func_tst/Cantian_234@127.0.0.1:1611

create or replace function abs( id int)
return int
as
begin
    return 10086;
end;
/

select abs(-1) from dual;

create or replace function EXTRACT( id int)
return int
as
begin
    return 10087;
end;
/

select EXTRACT(-1) from dual;

-- test PROCEDURE
CREATE OR REPLACE PROCEDURE decode()
IS
tmp varchar2(20) :='12345678';
begin
dbe_output.print_line('OUT PUT RESULT:'||tmp);
end decode;
/

-- call self function
set serveroutput on;
call decode();
set serveroutput off;

-- select as "func_name"
create or replace function "abs"( id int)
return int
as
begin
    return 10088;
end;
/

select "abs"(-1) from dual;
