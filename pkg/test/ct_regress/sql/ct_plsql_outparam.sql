conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_plsql_outparam cascade;
create user gs_plsql_outparam identified by Lh00420062;
grant dba to gs_plsql_outparam;

conn gs_plsql_outparam/Lh00420062@127.0.0.1:1611
set serveroutput on;


create or replace function myf(v1 in int default 9, v2 in out int, v3 out int,v4 out int, v5 out int) return int
is
begin
dbe_output.print(v1||v2||v3||v4||v5);
v2:=v1;
v3:=v2;
v4:=v3;
v5:=v4;
dbe_output.print(v1||v2||v3||v4||v5);
return v5;
end;
/

--expect right
declare
b1 int :=10;
b2 int :=20;
b3 int;
b4 int;
b5 int;
begin
--not use default
dbe_output.print(myf(v1=>b1,v2=>b2,v3=>b3,v4=>b4,v5=>b5));
dbe_output.print(myf(v5=>b5,v4=>b4,v3=>b3,v2=>b2,v1=>b1));
dbe_output.print(myf(v5=>b5,v1=>b1,v4=>b4,v3=>b3,v2=>b2));
dbe_output.print(myf(v4=>b4,v5=>b5,v1=>b1,v3=>b3,v2=>b2));
--use default
dbe_output.print(myf(v2=>b2,v3=>b3,v4=>b4,v5=>b5));
dbe_output.print(myf(v5=>b5,v4=>b4,v3=>b3,v2=>b2));
end;
/


--expect right
declare
b1 int :=10;
b2 int :=20;
b3 int;
b4 int;
b5 int;
begin
--not use default
dbe_output.print(myf(b1,v2=>b2,v3=>b3,v4=>b4,v5=>b5));
dbe_output.print(myf(b1,b2,v3=>b3,v4=>b4,v5=>b5));
dbe_output.print(myf(b1,b2,b3,v4=>b4,v5=>b5));
dbe_output.print(myf(b1,b2,b3,b4,v5=>b5));
dbe_output.print(myf(b1,b2,b3,b4,b5));
--use default
dbe_output.print(myf(v2=>b2,v3=>b3,v4=>b4,v5=>b5));
end;
/

--expect wrong
declare
b1 int :=10;
begin
b1 := myf(v1=>b1);
end;
/

--expect wrong
declare
b2 int :=10;
begin
b2 := myf(v2=>b2);
end;
/

--expect wrong
declare
b3 int :=10;
begin
b3 := myf(v3=>b3);
end;
/

--expect wrong
declare
b1 int :=10;
b2 int :=20;
b3 int;
b4 int;
b5 int;
begin
dbe_output.print(myf(b2,v3=>b3,v4=>b4,v5=>b5));
dbe_output.print(myf(b2,b3,v4=>b4,v5=>b5));
dbe_output.print(myf(b2,b3,b4,v5=>b5));
dbe_output.print(myf(b2,b3,b4,b5));
end;
/

--expect wrong
declare
b1 int :=10;
b2 int :=20;
b3 int;
b4 int;
b5 int;
begin
dbe_output.print(myf(v1=>b1,v2=>b2,v3=>b3,v4=>b4,v4=>b5));
end;
/

--expect right
declare
b1 int :=10;
b2 int :=20;
b3 int;
b4 int;
b5 int;
begin
dbe_output.print(myf(v1=>b1,v2=>b2,v3=>b3,v4=>b5,v5=>b5));
end;
/

set serveroutput off;
conn / as sysdba
drop user gs_plsql_outparam cascade;