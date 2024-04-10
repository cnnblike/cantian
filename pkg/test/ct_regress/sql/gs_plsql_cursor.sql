conn sys/Huawei@123@127.0.0.1:1611

drop user if exists gs_plsql_cursor cascade;
create user gs_plsql_cursor identified by Cantian_234;
grant all privileges to gs_plsql_cursor;
conn gs_plsql_cursor/Cantian_234@127.0.0.1:1611
set serveroutput on;

drop table if exists test2;
create table test2(a int primary key, b int,c int);
insert into test2 values(1,2,3);
insert into test2 values(3,4,5);
commit;

--test ref cursor leak 1
alter system set OPEN_CURSORS=100;
create or replace procedure liuhangmyp() 
is
cur1 sys_refcursor;
begin
    open cur1 for select 1 from sys_dummy; 
    close cur1;
end;
/

declare 
begin
for i in 1..101 loop
    liuhangmyp;
end loop;
end;
/

--test ref cursor leak 2
create or replace procedure liuhangmyp() 
is
cur1 sys_refcursor;
cur2 sys_refcursor;
begin
    open cur1 for select 1 from sys_dummy;
    cur2 := cur1;
    close cur1;
end;
/

declare 
begin
for i in 1..101 loop
    liuhangmyp;
end loop;
end;
/

--test ref cursor leak 3
--expect error
create or replace procedure liuhangmyp(cur in out sys_refcursor)
is
begin
null;
end;
/

create or replace procedure liuhangmyp(cur out sys_refcursor)
is
begin
    open cur for select 1 from sys_dummy;
end;
/

declare
cur sys_refcursor;
begin
for i in 1..101 loop
    liuhangmyp(cur);
end loop;
end;
/

create or replace procedure liuhangmyp(cur out sys_refcursor)
is
begin
    open cur for select 1 from sys_dummy;
    close cur;
end;
/

declare
cur sys_refcursor;
begin
for i in 1..101 loop
    liuhangmyp(cur);
end loop;
end;
/


create or replace procedure liuhangmyp(cur out sys_refcursor)
is
cur1 sys_refcursor;
cur2 sys_refcursor;
begin
    open cur1 for select 1 from sys_dummy;
    cur2 := cur1;
    cur := cur2;
    close cur1;
end;
/

declare
cur sys_refcursor;
begin
for i in 1..101 loop
    liuhangmyp(cur);
end loop;
end;
/

--test ref cursor leak 4
create or replace procedure liuhangmyp(cur out sys_refcursor)
is
cur1 sys_refcursor;
cur2 sys_refcursor;
begin
    open cur1 for select 1 from sys_dummy;
    cur2 := cur1;
    cur := cur2;
end;
/

declare
cur sys_refcursor;
tmp int := 0;
begin
for i in 1..101 loop
    liuhangmyp(cur);
    if(cur%isopen) then
        tmp :=tmp+1;
    end if;
end loop;
dbe_output.print(tmp);
end;
/

--test ref cursor leak 5
create or replace procedure liuhangmyp(cur out sys_refcursor)
is
cur1 sys_refcursor;
cur2 sys_refcursor;
begin
    open cur1 for select 1 from sys_dummy;
    cur2 := cur1;
    cur := cur2;
    close cur1;
end;
/

declare
cur sys_refcursor;
tmp int := 0;
begin
for i in 1..101 loop
    liuhangmyp(cur);
    if(cur%isopen) then
        tmp :=tmp+1;
    end if;
end loop;
dbe_output.print(tmp);
end;
/

--test ref cursor leak 6
create or replace function liuhangmyf() return sys_refcursor
is
cur1 sys_refcursor;
cur2 sys_refcursor;
begin
    open cur1 for select 1 from sys_dummy;
    cur2 := cur1;
    return cur2;
end;
/

declare
cur sys_refcursor;
tmp int := 0;
begin
for i in 1..101 loop
    select liuhangmyf() into cur from sys_dummy;
    if(cur%isopen) then
        tmp :=tmp+1;
    end if;
end loop;
dbe_output.print(tmp);
end;
/

declare
cur sys_refcursor;
tmp int := 0;
begin
for i in 1..101 loop
    cur := liuhangmyf();
    if(cur%isopen) then
        tmp :=tmp+1;
    end if;
end loop;
dbe_output.print(tmp);
end;
/

begin
liuhangmyf;
end;
/


--test ref cursor leak 7
create or replace function liuhangmyf() return sys_refcursor
is
cur1 sys_refcursor;
cur2 sys_refcursor;
begin
    open cur1 for select 1 from sys_dummy;
    cur2 := cur1;
    close cur1;
    return cur2;
end;
/


declare
cur sys_refcursor;
tmp int := 0;
begin
for i in 1..101 loop
    select liuhangmyf() into cur from sys_dummy;
    if(cur%isopen) then
        tmp :=tmp+1;
    end if;
end loop;
dbe_output.print(tmp);
end;
/

declare
cur sys_refcursor;
tmp int := 0;
begin
for i in 1..101 loop
    cur := liuhangmyf();
    if(cur%isopen) then
        tmp :=tmp+1;
    end if;
end loop;
dbe_output.print(tmp);
end;
/

--test ref cursor leak 8, not support, expect error
declare
cur sys_refcursor;
tmp int := 0;
begin
for i in 1..101 loop
execute immediate'
begin
open :1 from select a from test2;
end;
' using out cur;
if (cur%isopen) then
tmp :=tmp+1;
end if;
end loop;
dbe_output.print(tmp);
end;
/

--test ref cursor leak 9, not support
declare
cur sys_refcursor;
tmp int := 0;
begin
for i in 1..101 loop
open cur for select * from test2;
execute immediate'
declare
cur sys_refcursor;
begin
cur := :1;
if(cur%isopen) then
:2 := 1;
else
:2 := 2;
end if;
close cur;
end;
' using in cur,out tmp;
end loop;
dbe_output.print(tmp);
end;
/


--test ref cursor assignment 1
declare
cur1 sys_refcursor;
cur2 sys_refcursor;
val int;
begin
open cur1 for select a from test2;
cur2 := cur1;
close cur1;
close cur2; --expect error
end;
/


--test ref cursor assignment 2
declare
cur1 sys_refcursor;
cur2 sys_refcursor;
val int;
begin
open cur1 for select a from test2;
cur2 := cur1;
close cur2;
close cur1; --exepect error
end;
/

--test ref cursor assignment 3
create or replace function myfunction return sys_refcursor
is
cur1 sys_refcursor;
cur2 sys_refcursor;
val int;
begin
open cur1 for select a from test2;
cur2 := cur1;
close cur1;
return cur2;
end;
/
select myfunction() from sys_dummy; --expect error

--test ref cursor assignment 4
create or replace function myfunction return sys_refcursor
is
cur1 sys_refcursor;
cur2 sys_refcursor;
val int;
begin
open cur1 for select a from test2 order by 1;
cur2 := cur1;
return cur2;
end;
/
select myfunction() from sys_dummy; 

--test ref cursor assignment 5
create or replace procedure myp return sys_refcursor
is
cur1 sys_refcursor;
cur2 sys_refcursor;
val int;
begin
open cur1 for select a from test2;
cur2 := cur1;
dbe_sql.return_cursor(cur2); --expect error
return cur1;
end;
/

--test ref cursor assignment 7
declare
cur1 sys_refcursor;
cur2 sys_refcursor;
val int;
begin
open cur1 for select a from test2 order by 1;
cur2 := cur1;
fetch cur2 into val;
dbe_output.print(val);
fetch cur1 into val;
dbe_output.print(val);
close cur1;
end;
/

--test ref cursor assignment 8
declare
cur1 sys_refcursor; 
cur2 sys_refcursor;
val int;
begin
open cur1 for select a from test2 order by 1;
cur2 := cur1;
loop
fetch cur2 into val;
exit when cur2%notfound;
dbe_output.print(val);
end loop;
dbe_output.print(cur1%isopen);
dbe_output.print(cur1%found);
dbe_output.print(cur2%isopen);
dbe_output.print(cur2%found);
close cur1;
dbe_output.print(cur1%isopen);
dbe_output.print(cur2%isopen);
end;
/

--test ref cursor assignment 8

set serveroutput on;
drop table if exists IN_CURSOR_TABLE15;
create table IN_CURSOR_TABLE15(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into IN_CURSOR_TABLE15 values(1,'zhangsan','doctor1',10000);
insert into IN_CURSOR_TABLE15 values(2,'zhangsan2','doctor2',10000);
insert into IN_CURSOR_TABLE15 values(123,'zhangsan3','doctor3',10000);
insert into IN_CURSOR_TABLE15 values(11,'zhansi','doctor1',10000);
insert into IN_CURSOR_TABLE15 values(22,'lisiabc','doctor2',10000);
insert into IN_CURSOR_TABLE15 values(33,'zhangwu123','doctor3',10000);
insert into IN_CURSOR_TABLE15 values(10,'abc','worker',9000);
insert into IN_CURSOR_TABLE15 values(716,'ZHANGSAN','leader',20000);
commit;
create or replace procedure show_cur20(p1 varchar2, p2 number,p3 int, P_job varchar2,P_max_sal number,P_factor int)  
is 
cursor mycursor(job_real varchar2 ,max_sal in number := 9000, factor int ) is  select empno, sal, sal*factor exp_sal  from IN_CURSOR_TABLE15 where job=job_real and sal> max_sal  order by sal;
c_empno IN_CURSOR_TABLE15.empno%type;
b  int;
c int;
begin
   begin
   open mycursor(p1,factor=>p3);
   loop
   fetch mycursor into c_empno,b,c;
   if  mycursor%found  then 
   dbe_output.print_line('c_empno is emp:'||c_empno||' sal'||b||' ep_sal'||c);
   dbe_output.print_line(mycursor%rowcount);
   else 
     exit;
   end if;
   end loop;
   close mycursor;
   end;
   begin
   open mycursor(P_job,P_max_sal,P_factor);
   loop
   fetch mycursor into c_empno,b,c;
   exit when mycursor%notfound;
   dbe_output.print_line('doctor2 c_empno is :'||c_empno||' sal'||b||' ep_sal'||c);
   dbe_output.print_line(mycursor%rowcount);
   end loop;
   close mycursor;
   end;
end;
/

exec show_cur20('doctor1',9000,p3=>2,P_job=>'doctor2',P_max_sal=>8000,P_factor=>3);
exec show_cur20('doctor1',9000,2,'doctor2',8000,3);

conn sys/Huawei@123@127.0.0.1:1611
drop user gs_plsql_cursor cascade;
alter system set OPEN_CURSORS=2000;

