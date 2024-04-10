conn sys/Huawei@123@127.0.0.1:1611
drop user if exists plsql_package_error_backtrace cascade;
create user plsql_package_error_backtrace identified by Lh00420062;
grant dba to plsql_package_error_backtrace;

conn plsql_package_error_backtrace/Lh00420062@127.0.0.1:1611
set serveroutput on;

--normal test
select DBE_UTIL.GET_ERROR_BACKTRACE from dual;
select DBE_UTIL.GET_ERROR_BACKTRACE() from dual;
select DBE_UTIL.GET_ERROR_BACKTRACE(1) from dual;
select DBE_UTIL.GET_ERROR_BACKTRACE('') from dual;
select DBE_UTIL.GET_ERROR_BACKTRACE('a','b') from dual;

--basic test
begin
dbe_output.print_line(DBE_UTIL.GET_ERROR_BACKTRACE);
end;
/

declare 
sqla varchar(100);
begin
sqla := DBE_UTIL.GET_ERROR_BACKTRACE;
dbe_output.print_line(sqla);
end;
/

declare
tmp int :=1;
begin
tmp := tmp/0;
exception
when others then
dbe_output.print_line(DBE_UTIL.GET_ERROR_BACKTRACE);
end;
/

--nested test 
create or replace procedure p1_test_nested_exception
is 
tmp int :=0;
begin
tmp := tmp+'1oo';
exception
   when others then 
    begin
        dbe_output.print_line('Second: '||DBE_UTIL.GET_ERROR_BACKTRACE);
        tmp := tmp/0;
    exception
        when others then
            dbe_output.print_line('Third: '||DBE_UTIL.GET_ERROR_BACKTRACE);
            begin
                begin
                    begin
                        dbe_output.print_line('Third: '||DBE_UTIL.GET_ERROR_BACKTRACE);
                    end;
                end;
            end;
    end;
end;
/
call p1_test_nested_exception();
begin
p1_test_nested_exception();
exception
when others then
dbe_output.print_line(DBE_UTIL.GET_ERROR_BACKTRACE);
end;
/

create or replace procedure exec_a
is
past_due     EXCEPTION;
tmp int :=1;
begin
    raise past_due;
end ;
/
create or replace procedure exec_b
is
begin
    exec_a();
end ;
/
create or replace procedure exec_c
is
begin
    exec_b();
end ;
/

begin
exec_c();
exception
when others then
dbe_output.print_line(DBE_UTIL.GET_ERROR_BACKTRACE);
end;
/

create or replace function func_aa return int
is
tmp int :=1;
begin
    tmp := tmp+'1oo';
    return 10;
end ;
/

declare
a int;
begin
a := func_aa();
exception
    when others then
    dbe_output.print_line('First: '||DBE_UTIL.GET_ERROR_BACKTRACE);
end;
/

create or replace procedure p1_test_nested_exception
is 
tmp int :=0;
begin
tmp := tmp+'1oo';
exception
   when others then 
       dbe_output.print_line('One trace: '||DBE_UTIL.GET_ERROR_BACKTRACE);
       begin
       exec_c();
       exception
       when others then
            dbe_output.print_line('The other trace: '||DBE_UTIL.GET_ERROR_BACKTRACE);
       end;
end;
/

exec p1_test_nested_exception();

create or replace procedure c
is
begin
 dbe_output.print_line('In procedure c');
 RAISE NO_DATA_FOUND;
end c;
/

 
create or replace procedure b
is
begin
 dbe_output.print_line('In procedure b');
 c();
end b;
/
 

create or replace procedure a
is
begin
 dbe_output.print_line('In procedure a');
 b();
exception
 when no_data_found then
 dbe_output.print_line(DBE_UTIL.GET_ERROR_BACKTRACE);
end a;
/

call a();

create or replace procedure proc_nested_loop_temp(myinput int)
is
begin
RAISE NO_DATA_FOUND;
end;
/

create or replace procedure proc_nested_loop(myloop int)
is
temp_loop int;
begin
temp_loop := myloop-1;
if (myloop > 0) then
    proc_nested_loop(temp_loop);
else
    proc_nested_loop_temp(myloop);
end if;
dbe_output.print_line('Current: '|| myloop);
end;
/

begin
proc_nested_loop(5);
exception
    when others then
    dbe_output.print_line(DBE_UTIL.GET_ERROR_BACKTRACE);
end;
/

begin
proc_nested_loop(20);
exception
    when others then
    dbe_output.print_line(DBE_UTIL.GET_ERROR_BACKTRACE);
end;
/

--dynamic sql
declare
dy_sql varchar(100);
begin
dy_sql := 'declare
 a int :=1; 
 begin 
 a:=a/0; 
 end;';
execute immediate dy_sql;
exception
    when others then
    begin
    dy_sql := DBE_UTIL.GET_ERROR_BACKTRACE;
    dbe_output.print_line(dy_sql);
    end;
end;
/

declare
dy_sql varchar(100);
begin
dy_sql := 'begin
 proc_nested_loop(5);
 end;';
execute immediate dy_sql;
exception
    when others then
    begin
    dbe_output.print_line(DBE_UTIL.GET_ERROR_BACKTRACE);
    end;
end;
/

create or replace procedure a_ret2(b OUT sys_refcursor)
is
a sys_refcursor;
begin
open a for select 2 from dual;
dbe_sql.return_cursor(a);
b := a;
end;
/

declare
a sys_refcursor;
begin
open a for select 10 from dual;
a_ret2(a);
dbe_sql.return_cursor(a);
exception
    when others then
    dbe_output.print_line(DBE_UTIL.GET_ERROR_BACKTRACE);
end;
/

create or replace procedure testa()
as
begin
DBE_UTIL.GET_ERROR_BACKTRACE;
end;
/


create or replace procedure testa()
as
begin
DBE_UTIL.GET_ERROR_BACKTRACE();
end;
/

conn sys/Huawei@123@127.0.0.1:1611
drop user plsql_package_error_backtrace cascade;
set serveroutput off;
