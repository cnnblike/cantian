spool ./results/gs_plsql_param.out
set serveroutput on
--Add some testcases in order to test bind param
--test bind param in SQL clause
drop table if exists plsql_param_tr1;
create table plsql_param_tr1(f1 int, f2 int);

declare
   a int := 1;
   p int;
begin
   insert into plsql_param_tr1 values(a,?);
   select f2 into p from plsql_param_tr1;
   dbe_output.print_line(p);
end;
/
in
int
7

--cann't use bind param after using
DECLARE
a INT;
b CHAR(16);
c VARCHAR(16);
BEGIN
a := 10;
b := 'abc';
c := 'efc';
EXECUTE IMMEDIATE 'BEGIN 
:x := 11; :y := ''aaa''; :z := ''bbb'';
dbe_output.print_line(''a=''||:x);dbe_output.print_line(''b=''||:y);dbe_output.print_line(''c=''||:z);
END;'
--USING OUT a, OUT b,OUT c;
USING :x,:y,:z;
dbe_output.print_line('a='||a);
dbe_output.print_line('b='||b);
dbe_output.print_line('c='||c);
END;
/
in
int
7
in
string
'efg'
in
string
'opq'

--test bind param in left value
declare
   a int := 1;
   p int;
begin
   :1 := a + 1;
   p := :1 + a;
   dbe_output.print_line(p || ' null');
end;
/
out
int
1
in
int
2000

declare
   a int := 1;
   p int;
begin
   :1 := a + 1;
   p := :2 + a;
   dbe_output.print_line(p || ' null');
end;
/
out
int
1
in
int
2000

declare
   a int := 1;
   p int;
begin
   :1 := a + 1;
   p := :1 + a;
   dbe_output.print_line(p || ' null');
end;
/
in out
int
1
in
int
2000

--test bind param in cond expr
declare
   a int := 1;
begin
    a := :1 + 1;
    if (:1 > 2) then
         a := :1 + 2;
    end if;
 dbe_output.print_line('a = ' || a);
end;
/
in
int
7
in
int
70
in
int
700

--test bind param in select into clause
declare
   a int := 1;
begin
    select 1 into a from dual;
    select 1 into :1 from dual;
end;
/
--error

--test bind param in proc real param
create or replace procedure proc_tt(a int, b int) is
  p int := a;
  q int := b;
begin
  dbe_output.print_line('p = ' || p);
  dbe_output.print_line('q = ' || q);
end;
/

declare
 a int := 1;
begin
 proc_tt(:1, a+2);
end;
/
in
int
7

--test bind param in cursor clause
declare
   a sys_refcursor;
   b int := 1;
   c int;
begin
   open a for select b from dual;
   open a for select b + :1 from dual;
   fetch a into c;
   dbe_output.print_line('c = ' || c);
end;
/
in
int
7

declare
   a sys_refcursor;
   b int := 1;
   c int;
begin
   open a for select b from dual;
   open a for select b + :1 from dual;
   dbe_sql.return_cursor(a);
end;
/
in
int
7

--test bind param in fetch into clause
declare
   a sys_refcursor;
   b int := 1;
   c int;
begin
   open a for select b from dual;
   fetch a into :1;
   c := :1;
   dbe_output.print_line('c = ' || c);
end;
/
--error

--test bind param in dynamic sql 
declare
   a int := 1;
begin
	 execute immediate 'delete from plsql_param_tr1';
   execute immediate 'insert into plsql_param_tr1 values(:1,:2)' using a, :1;
end;
/
in
int
7

select * from plsql_param_tr1;

declare
   a int := 1;
   p int;
begin
	execute immediate 'delete from plsql_param_tr1';
  execute immediate 'begin insert into plsql_param_tr1 values(:1,:2); end;' using a, :1;
  select f1 into p from plsql_param_tr1;
  dbe_output.print_line('p = ' || p);
end;
/
in
int
7

create or replace procedure proc_pp(a out number, b in number) 
is
begin
	dbe_output.print_line('test in');
end;
/
declare
  a int := 1;
begin
   proc_pp(:1,a+2);
end;
/
in
number
100

create or replace procedure proc_pp(a out number, b in number) 
is
begin
	a := 1.2;
end;
/
declare
  a int := 1;
begin
  proc_pp(:1,a+2);
end;
/
out
number
100    

create or replace procedure proc_pp(a out number, b in number) 
is
begin
	a := 1.2 * b;
end;
/
declare
  a int := 1;
begin
   proc_pp(:1,a);
end;
/
out
number
1000

-- DTS2019062812368 start
BEGIN
EXECUTE IMMEDIATE 'declare a int; b int; c int; BEGIN 
 a := :x; b := :y; c := :x;
dbe_output.print_line(a);dbe_output.print_line(b);dbe_output.print_line(c);
END;'
USING 1,2;
END;
/

declare 
a int; 
b int; 
c int; 
BEGIN 
 a := :x; 
 b := :x;
 c := :y; 
dbe_output.print_line(a);
dbe_output.print_line(b);
dbe_output.print_line(c);
END;
/
in
int
1
in
int
2
in
int
3

declare 
a int; 
b int; 
c int; 
BEGIN 
 select :x into a from dual;
 select :x into b from dual;
 select :y into c from dual;
dbe_output.print_line(a);
dbe_output.print_line(b);
dbe_output.print_line(c);
END;
/
in
int
1
in
int
2
in
int
3

BEGIN
EXECUTE IMMEDIATE 'declare 
a int; 
b int; 
c int; 
BEGIN 
 select :x into a from dual;
 select :x into b from dual;
 select :y into c from dual;
dbe_output.print_line(a);
dbe_output.print_line(b);
dbe_output.print_line(c);
END;'
USING 1,2;
END;
/
-- DTS2019062812368 end

-- DTS2019092705246
declare
b varchar(100) := 'abc';
begin
  for lll in (select :1 as b from dual) loop
    b := lll.b;
  end loop;
  dbe_output.print_line(b);
end;
/
in
string
abcdefg
-- DTS2019092705246 end

drop table if exists t_table;
create table t_table(a clob default 'qq', b int);
insert into t_table(b) values(1);
insert into t_table(b) values(2);
commit;
select * from t_table order by b;
DECLARE
  TYPE aaaa IS table of clob;
  target aaaa;
BEGIN
select ? bulk collect into target from t_table;
  dbe_output.print_line ('2: ' || target(1));
END;
/
in
clob
ahhdfvbkbvfbviufhvhrohvhvhfhvsohvhs
drop table if exists t_table;

--DTS2020061105T5A7P0G00
declare
cursor1 sys_refcursor;
type  XX is record
(
Rec_1  int,
Rec_2  bigint,
Rec_3  number(10,2),
Rec_4  decimal(10,2),
Rec_5  float,
Rec_6  double,
Rec_7  real,
Rec_8  char(10),
Rec_9  varchar(100),
Rec_10  varchar2(100),
Rec_11  bool,
Rec_12  boolean,
Rec_13  date,
Rec_14  timestamp,
Rec_15  binary(10),
Rec_16  varbinary(20),
Rec_17  clob,
Rec_18  blob,
Rec_19  DATETIME, 
Rec_20  NVARCHAR(100)
);
v_rec XX;
begin
v_rec.Rec_1     :=:p1    ;
v_rec.Rec_2     :=:p2    ;
v_rec.Rec_3     :=:p3    ;
v_rec.Rec_4     :=:p4    ;
v_rec.Rec_5     :=:p5    ;
v_rec.Rec_6     :=:p6    ;
v_rec.Rec_7     :=:p7    ;
v_rec.Rec_8     :=:p8    ;
v_rec.Rec_9     :=:p9    ;
v_rec.Rec_10    :=:p10   ;
v_rec.Rec_11    :=:p11   ;
v_rec.Rec_12    :=:p12   ;
v_rec.Rec_13    :=:p13   ;
v_rec.Rec_14    :=:p14   ;
v_rec.Rec_15    :=:p15   ;
v_rec.Rec_16    :=:p16   ;
v_rec.Rec_17    :=:p17   ;
v_rec.Rec_18    :=:p18   ;
v_rec.Rec_19    :=:p19   ;
v_rec.Rec_20    :=:p20   ;
open  cursor1 for select
v_rec.Rec_1      ,
v_rec.Rec_2      ,
v_rec.Rec_3      ,
v_rec.Rec_4      ,
v_rec.Rec_5      ,
v_rec.Rec_6      ,
v_rec.Rec_7      ,
v_rec.Rec_8      ,
v_rec.Rec_9      ,
v_rec.Rec_10     ,
v_rec.Rec_11     ,
v_rec.Rec_12     ,
v_rec.Rec_13     ,
v_rec.Rec_14     ,
v_rec.Rec_15     ,
v_rec.Rec_16     ,
v_rec.Rec_17     ,
v_rec.Rec_18     ,
v_rec.Rec_19     ,
v_rec.Rec_20
 from  sys_dummy   ;
dbe_sql.return_cursor(cursor1);
dbe_output.print_line(v_rec.Rec_1);
dbe_output.print_line(v_rec.Rec_2 );
dbe_output.print_line(v_rec.Rec_3 );
dbe_output.print_line(v_rec.Rec_4 );
dbe_output.print_line(v_rec.Rec_5 );
dbe_output.print_line(v_rec.Rec_6 );
dbe_output.print_line(v_rec.Rec_7 );
dbe_output.print_line(v_rec.Rec_8 );
dbe_output.print_line(v_rec.Rec_9 );
dbe_output.print_line(v_rec.Rec_10);
dbe_output.print_line(v_rec.Rec_11);
dbe_output.print_line(v_rec.Rec_12);
dbe_output.print_line(v_rec.Rec_13);
dbe_output.print_line(v_rec.Rec_14);
dbe_output.print_line(v_rec.Rec_15);
dbe_output.print_line(v_rec.Rec_16);
dbe_output.print_line(v_rec.Rec_17);
dbe_output.print_line(v_rec.Rec_18);
dbe_output.print_line(v_rec.Rec_19);
dbe_output.print_line(v_rec.Rec_20);
end;
/
in
int
1334
in
bigint
8301034833292722247
in
number
3.14
in
decimal
16777215.52
in
number
4.61512051684126
in
double
2.07944154167984
in
real
65.8201500331442
in
char
gsdb1234
in
varchar
123456,7this is a test str
in
varchar
414243likeFF
in
bool
1
in
boolean
0
in
date
2019-07-02 12:04:21
in
timestamp
2019-06-10 00:00:00.000000
in
string
C8
in
string
AAAB0181fG
in
clob
clobtest%QWERASGSDTRERE
in
blob
30313233343536373839616263646566682332333132232524234024
in
date
2018-06-28 13:14:15
in
VARCHAR
ABFDSF#$@
DROP TABLE IF EXISTS T_TRIG_1;
DROP TABLE IF EXISTS T_TRIG_2;
CREATE TABLE T_TRIG_1 (F_INT1 INT, F_INT2 INT, F_CHAR1 CHAR(16), F_DATE DATE);
CREATE TABLE T_TRIG_2 (F_INT1 INT, F_INT2 INT, F_CHAR1 CHAR(16), F_DATE DATE);

INSERT INTO T_TRIG_1 VALUES(1,2,'A','2017-12-11 14:08:00');
INSERT INTO T_TRIG_1 VALUES(3,4,'C','2017-12-12 16:08:00');
INSERT INTO T_TRIG_1 VALUES(1,3,'A','2017-12-11 14:18:00');
INSERT INTO T_TRIG_1 VALUES(2,3,'B','2017-12-11 16:08:00');
commit;


CREATE OR REPLACE TRIGGER TRIG_BEFORE_EACH_ROW BEFORE INSERT OR UPDATE OF F_INT1 OR DELETE ON T_TRIG_1
FOR EACH ROW
BEGIN
  INSERT INTO T_TRIG_2 VALUES(:OLD.F_INT2, :NEW.f_int1, :OLD."F_CHAR1", :NEW.`F_DATE`);
  INSERT INTO T_TRIG_2 select :NEW.f_int2, :NEW.f_int1, :NEW."F_CHAR1", :NEW.`F_DATE` from sys_dummy 
  where not exists(select 1 from T_TRIG_1 where T_TRIG_1.f_int1 = :NEW.F_INT1);
END;
/

CREATE OR REPLACE TRIGGER TRIG_BEFORE_EACH_ROW_UPDATE BEFORE UPDATE OF F_INT2 OR DELETE ON T_TRIG_1
FOR EACH ROW
BEGIN
  UPDATE T_TRIG_2 SET F_CHAR1= 'B'
  where not exists(select 1 from T_TRIG_1 where T_TRIG_1.F_CHAR1 = :NEW.F_CHAR1);
END;
/

analyze table T_TRIG_1 compute statistics;

INSERT INTO T_TRIG_1 VALUES(2,:p1,'C','2017-12-11 16:08:00');
in
int
10

spool off