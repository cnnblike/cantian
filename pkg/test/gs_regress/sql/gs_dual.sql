conn / as sysdba

select * from dual;
select 1 from dual;
select * from dual where 1 != 2;
select * from dual where 1 = 2;
select * from dual where dummy = 'x';
select * from dual where dummy = 'X';
select 1 + 2 from dual;
select * from dual where rowid::decimal < 123E100;
select rowid from dual;
select rowscn from dual;
select * from dual where rowid = to_char('000000000002440000');
select * from dual where rowid=to_char('000000000002440001');

drop user if exists test_dual cascade;
create user test_dual identified by Lh00420062;
grant dba to test_dual;
conn test_dual/Lh00420062@127.0.0.1:1611

select 1;
select 1 from dual;
select 1 from sys.dual;
select 1 from sys_dummy;
select 1 from sys.sys_dummy;

create table dual(a int, c char);
insert into dual values(1,'a');
select * from dual;
select * from sys.dual;
select * from sys_dummy;
select * from sys.sys_dummy;
drop table dual;

create table sys_dummy(a int, c char);
insert into sys_dummy values(1,'a');
select * from dual;
select * from sys.dual;
select * from sys_dummy;
select * from sys.sys_dummy;
drop table sys_dummy;

conn sys/Huawei@123@127.0.0.1:1611
drop user test_dual cascade;

conn err_user/sd2332@127.0.0.1:1611
conn sys/Huawei@123@127.0.0.1:1611
select 10 / 
5 from dual;

select 10 / 
5 from dual
/

ddsfsf/
/

select 1 
from dual
/

select 2 from dual
   /   

select 3 from dual
/*sdfsfsdf*/
/
   
select 4 from dual
/*sdfsfsdf*// 
/

select 5 from dual
//*sdfsfsdf*/
/

declare
var int;
begin
var := var /*fdsaf*/;
end;
/


declare
var varchar(10);
begin
var := '
/
';
end;/*fds
af*/
/

declare
var int;
begin
var := var/*fdsaf*/
/
/*fdsaf*/1;
end;/*fds
af*/
/

CREATE OR REPLACE PROCEDURE test_pro(param1 IN VARCHAR2,param2 IN VARCHAR2)
IS
BEGIN
dbe_output.print_line('Hello Zenith:'||param1||','||param2);
END test_pro;
/

--DTS202008070MW6TEP0K00
@comment_at_first.sql;select 2 + 3;

