conn sys/Huawei@123@127.0.0.1:1611
drop user if exists plsql_cursor2 cascade;
create user plsql_cursor2 identified by Cantian_234;
grant dba to plsql_cursor2;
drop user if exists DBMS_SQL_TEST cascade;
create user DBMS_SQL_TEST identified by Cantian_234;
grant dba to DBMS_SQL_TEST;
conn plsql_cursor2/Cantian_234@127.0.0.1:1611

set serveroutput on;
drop table if exists myt;
create table myt(a int,b varchar(2000),c bigint default 1000000000000, d date default sysdate, e clob default 'abc', e2 blob default 'abcd',f number(20,10) default 1.1, g decimal default 111.111);
declare
sql1 clob;
begin
for i in 1..100 loop
insert into myt(a,b) values(i, i||'abcahsdfjalkdsfjkhasdhjlkasdfsadfasdfadsfadsffdsakljhfhkjldafsjjkl;dsj;kl');
end loop;
commit;
end;
/

--test in out
create or replace procedure p_test_inout(v1 in int, v2 out int, v3 in out int)
is
begin
dbe_output.print(v1);
dbe_output.print(v2);
dbe_output.print(v3);
v2 := 10;
v3 :=v2;
end;
/

declare
v1 int :=1;
v2 int;
v3 int;
begin
p_test_inout(v1,v2,v3);
dbe_output.print(v1);
dbe_output.print(v2);
dbe_output.print(v3);
end;
/

--basic func
create or replace procedure show_cur(v_cur in sys_refcursor)
is
a int;
b varchar(100);
begin
loop
fetch v_cur into a,b;
exit when v_cur%notfound;
dbe_output.print(a||' '||b);
end loop;
end;
/

--expect error
create or replace procedure p_cur2(v_cur in sys_refcursor)
is
a int;
b varchar(100);
begin
open v_cur for select a,b from myt;
end;
/

--test cursor assignment
create or replace procedure p_cur2(v_cur in sys_refcursor)
is
cur sys_refcursor;
begin
cur := v_cur;
show_cur(cur);
end;
/

--expect error
declare
cursor cur1 is select a,b from myt where a=1;
begin
p_cur2(cur1);
end;
/

--expect error
declare
cur1 sys_refcursor;
begin
p_cur2(cur1);
end;
/

declare
cur1 sys_refcursor;
begin
open cur1 for select a,b from myt where a=1;
p_cur2(cur1);
end;
/

--test out direction
create or replace procedure p_cur2(cur1 out sys_refcursor)
is
begin
dbe_output.print(cur1%isopen);
end;
/

declare
cur1 sys_refcursor;
begin
open cur1 for select a,b from myt where a=1;
p_cur2(cur1); --expect not open
end;
/

--test out direction
create or replace procedure p_cur2(cur1 out sys_refcursor)
is
begin
open cur1 for select a,b from myt where a=2;
end;
/

declare
cur1 sys_refcursor;
begin
open cur1 for select a,b from myt where a=1;
p_cur2(cur1);
show_cur(cur1);
end;
/

create or replace procedure p_cur2(v_cur in out sys_refcursor)
is
begin
show_cur(v_cur);
open v_cur for select a,b from myt where a=2;
show_cur(v_cur);
open v_cur for select a,b from myt where a=3;
show_cur(v_cur);
end;
/

--expect error
declare
cursor cur1 is select a,b from myt where a=1;
begin
p_cur2(cur1);
end;
/

--expect error
declare
cursor cur1 is select a,b from myt where a=1;
begin
for item in cur1 loop
p_cur2(item);
end loop;
end;
/

--expect error
declare
begin
for item in (select a,b from myt where a=1) loop
p_cur2(item);
end loop;
end;
/

--expect error
declare
begin
for item in (select a,b from myt where a=1) loop
p_cur2(item);
end loop;
end;
/

--expect error
declare
cur1 sys_refcursor;
begin
for item in cur1 loop
p_cur2(item);
end loop;
end;
/

--expect error
declare
cur1 sys_refcursor;
begin
open cur1 for select a,b from myt where a=1;
close cur1;
p_cur2(cur1); --has closed
end;
/

--right
declare
va int;
vb varchar(100);
cur1 sys_refcursor;
begin
open cur1 for select a,b from myt where a=1;
fetch cur1 into va,vb;
p_cur2(cur1);
end;
/

create or replace procedure show_cur3(v_cur in sys_refcursor)
is
a int;
b int;
c int;
begin
fetch v_cur into a,b,c;
dbe_output.print(a||' '||b||' '||c);
end;
/

--expect error
declare
cur1 sys_refcursor;
begin
open cur1 for select a,a+1 from myt where a=1;
show_cur3(cur1);
end;
/

--expect error
declare
va int;
vb varchar(100);
cur1 sys_refcursor;
begin
open cur1 for select a,b,c from myt where a=1;
show_cur3(cur1);
end;
/

--expect error
create or replace procedure p_cur4(cur in sys_refcursor)
is
a cur%rowtype;
begin
null;
end;
/

create or replace procedure p_cur4(cur in sys_refcursor)
is
begin
dbe_output.print(cur%isopen);
dbe_output.print(cur%found);
dbe_output.print(cur%notfound);
dbe_output.print(cur%rowcount);
end;
/

declare
va int;
vb varchar(100);
cur1 sys_refcursor;
begin
p_cur4(cur1);
end;
/

declare
va int;
vb varchar(100);
cur1 sys_refcursor;
begin
open cur1 for select a,b from myt where a=1;
close cur1;
p_cur4(cur1);
end;
/

declare
va int;
vb varchar(100);
cur1 sys_refcursor;
begin
open cur1 for select a,b from myt where a=1;
p_cur4(cur1);
fetch cur1 into va,vb;
p_cur4(cur1);
fetch cur1 into va,vb;
p_cur4(cur1);
close cur1;
end;
/

create or replace procedure p_reopen(cur in out sys_refcursor)
is
begin
show_cur(cur);
open cur for select a,b from myt where a=2;
end;
/

declare
va int;
vb varchar(100);
cur1 sys_refcursor;
begin
open cur1 for select a,b from myt where a=1;
p_reopen(cur1);
fetch cur1 into va,vb;
dbe_output.print(va||' '||vb);
end;
/

--test return result
create or replace procedure DBMS_SQL_TEST.return_results(cur in sys_refcursor)
is
begin
dbe_sql.return_cursor(cur);
end;
/

declare
cur1 sys_refcursor;
begin
open cur1 for select a,b,c from myt where a<3 order by a;
DBMS_SQL_TEST.return_results(cur1);
end;
/

--test cur leak
alter system set OPEN_CURSORS=20;
create or replace procedure p_recur(cur in out sys_refcursor,idx int)
is
begin
if(idx=1)then
open cur for select a,b from myt where a=1;
show_cur(cur);
else
p_recur(cur,idx-1);
end if;
end;
/

declare
cur1 sys_refcursor;
begin
p_recur(cur1,30);
end;
/

begin
for i in 1..31 loop
execute immediate '
declare
cur1 sys_refcursor;
begin
p_recur(cur1,30);
end;';
end loop;
end;
/
alter system set OPEN_CURSORS=2000;

--test is open
declare
cursor cur is select a from myt where a=1;
begin
dbe_output.print(cur%isopen);
end;
/

declare
cur sys_refcursor;
begin
dbe_output.print(cur%isopen);
end;
/


conn sys/Huawei@123@127.0.0.1:1611
drop user if exists plsql_cursor2 cascade;
drop user if exists DBMS_SQL_TEST cascade;