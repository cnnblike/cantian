--
-- gs_plsql_exception
-- testing track exception
--

set serveroutput on;
drop user if exists gs_plsql_exception_0114 cascade;
create user gs_plsql_exception_0114 identified by Lh00420062;
grant dba to gs_plsql_exception_0114;
conn gs_plsql_exception_0114/Lh00420062@127.0.0.1:1611

--test process exception
--add 2018/7/2
drop procedure if exists test_pl_excpt1;
drop procedure if exists test_pl_excpt2;
drop procedure if exists test_pl_excpt3;
drop procedure if exists test_pl_excpt4;
drop procedure if exists test_pl_excpt5;
drop procedure if exists test_pl_excpt6;

create or replace procedure test_pl_excpt1
as
v_age integer;
v_name varchar(30);
begin 
v_age:=89;
v_age:= v_age/0;
dbe_output.print_line('correct');
exception
 when Zero_divide then 
 SYS.dbe_output.print_line('Zero divide');
 SYS.dbe_output.print_line(SQL_ERR_CODE || 'error ' || SQL_ERR_MSG);
 when value_error then 
 SYS.dbe_output.print_line('value error');
 SYS.dbe_output.print_line(SQL_ERR_CODE || 'error ' || SQL_ERR_MSG);
 when others then
 SYS.dbe_output.print_line('other error');
 SYS.dbe_output.print_line(SQL_ERR_CODE||'error'||SQL_ERR_MSG);
 end;
/

exec test_pl_excpt1();

create or replace procedure test_pl_excpt2
as
v_age integer;
v_name varchar(30);
begin 
v_age:=89;
v_age:= v_age/0;
dbe_output.print_line('correct');
exception
 when value_error then 
 SYS.dbe_output.print_line('value error');
 SYS.dbe_output.print_line(SQL_ERR_CODE || ' error ' || SQL_ERR_MSG);
 when others then
 SYS.dbe_output.print_line('other error');
 SYS.dbe_output.print_line(SQL_ERR_CODE||' error '||SQL_ERR_MSG);
 end;
/

exec test_pl_excpt2();

create or replace procedure test_pl_excpt3
as
v_age integer;
v_name varchar(30);
SQL_ERR_CODE int :=1;
SQL_ERR_MSG varchar(40):='test';
begin 
v_age:=89;
v_age:=v_age/0;
dbe_output.print_line('correct');
exception
 when Zero_divide then 
 SYS.dbe_output.print_line('Zero divide');
 SYS.dbe_output.print_line(SQL_ERR_CODE||' error '||SQL_ERR_MSG);
 when others then
 SYS.dbe_output.print_line('other error');
 SYS.dbe_output.print_line(SQL_ERR_CODE||' error '||SQL_ERR_MSG);
 end;
/

exec test_pl_excpt3();

create or replace procedure test_pl_excpt4
as
v_age integer;
v_name varchar(30);
SQL_ERR_CODE int;
SQL_ERR_MSG varchar(40);
begin 
v_age:=89;
v_age:=v_age/0;
dbe_output.print_line('correct');
exception
 when Zero_divide then 
 SYS.dbe_output.print_line('Zero divide');
 SYS.dbe_output.print_line(SQL_ERR_CODE||' error '||SQL_ERR_MSG);
 when others then
 SYS.dbe_output.print_line('other error');
 SYS.dbe_output.print_line(SQL_ERR_CODE||' error '||SQL_ERR_MSG);
 end;
/

exec test_pl_excpt4();

create or replace procedure test_pl_excpt5
as
v_age integer;
v_name varchar(30);
begin 
v_age:=89;
dbe_output.print_line('correct');
exception
 when Zero_divide then 
 SYS.dbe_output.print_line('Zero divide');
 SYS.dbe_output.print_line(SQL_ERR_CODE || 'error ' || SQL_ERR_MSG);
 when value_error then 
 SYS.dbe_output.print_line('value error');
 SYS.dbe_output.print_line(SQL_ERR_CODE || 'error ' || SQL_ERR_MSG);
 when others then
 SYS.dbe_output.print_line('other error');
 SYS.dbe_output.print_line(SQL_ERR_CODE||'error'||SQL_ERR_MSG);
 end;
/

exec test_pl_excpt5();

create or replace procedure test_pl_excpt6
as
v_age integer;
v_name varchar(30);
SQL_ERR_CODE int := 600;
SQL_ERR_MSG varchar(40):= 'test';
begin 
v_age:=89;
v_age:=v_age/0;
dbe_output.print_line('correct');
exception
 when Zero_divide then 
 SYS.dbe_output.print_line('Zero divide');
 SYS.dbe_output.print_line(SQL_ERR_CODE||' error '||SQL_ERR_MSG);
 when others then
 SYS.dbe_output.print_line('other error');
 SYS.dbe_output.print_line(SQL_ERR_CODE||' error '||SQL_ERR_MSG);
 end;
/

exec test_pl_excpt6();


drop procedure if exists test_pl_excpt1;
drop procedure if exists test_pl_excpt2;
drop procedure if exists test_pl_excpt3;
drop procedure if exists test_pl_excpt4;
drop procedure if exists test_pl_excpt5;
drop procedure if exists test_pl_excpt6;

declare
  v_ename varchar2(20);
  n_value int;
begin
  n_value := 1;
  n_value := n_value/0;
  exception
   when others then  
  v_ename := ' test block';                              
  dbe_output.print_line(SQL_ERR_CODE|| '-------' || SQL_ERR_MSG || v_ename);
end;
/

declare
  v_ename varchar2(20);
  n_value int;
begin
  n_value := 1;
  n_value := n_value/0;
  exception
   when others then  
  v_ename := ' test block';                              
  dbe_output.print_line(SQL_ERR_CODE()|| '-------' || SQL_ERR_MSG() || v_ename);
end;
/

declare
  v_ename varchar2(20);
  n_value int;
begin
  n_value := 1;
  n_value := n_value/0;
  exception
   when Zero_divide then 
 SYS.dbe_output.print_line('Zero divide');
 SYS.dbe_output.print_line(SQL_ERR_CODE||' error '||SQL_ERR_MSG);
   when others then  
  v_ename := ' test block';                              
  dbe_output.print_line(SQL_ERR_CODE || '-------' || SQL_ERR_MSG || v_ename);
end;
/

declare
  v_ename varchar2(20);
  n_value int;
begin
  n_value := 1;
  n_value := n_value/0;
  exception
   when Dup_val_on_index then                              
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when Timeout_on_resource then                             
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when Invalid_CURSOR then                              
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when Not_logged_on then                              
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when Login_denied then                              
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when No_data_found then                              
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when Too_many_rows then                              
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when Zero_divide then                              
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when Invalid_NUMBER then                              
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when Storage_error then                              
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when Program_error then                              
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE)); 
   when Value_error then                              
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when Rowtype_mismatch then                             
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when CURSOR_already_OPEN then                          
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when Access_INTO_null then                             
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when Collection_is_null then                            
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when Subscript_outside_limit then                     
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when Subscript_beyond_count then                       
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when CASE_NOT_FOUND then                              
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when NO_DATA_NEEDED then                              
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when SELF_IS_NULL then                              
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when SYS_INVALID_ROWID then                             
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
   when others then                             
  dbe_output.print_line(SQL_ERR_CODE || '---' || SQL_ERR_MSG ||'---'||SQL_ERR_MSG(SQL_ERR_CODE));
end;
/

select SQL_ERR_CODE() from dual;
select SQL_ERR_MSG(0) from dual;
select SQL_ERR_MSG(50000) from dual;
select SQL_ERR_MSG(901) from dual;

DECLARE
  stock_price   NUMBER := 9.73;
  net_earnings  NUMBER := 0;
  pe_ratio      NUMBER;
BEGIN
  pe_ratio := stock_price / net_earnings;  -- raises ZERO_DIVIDE exception
  dbe_output.print_line('Price/earnings ratio = ' || pe_ratio);
EXCEPTION
  WHEN ZERO_DIVIDE THEN
    dbe_output.print_line('Company had zero earnings.');
    pe_ratio := NULL;
END;
/

--test or at defined exception
--expect  ok.
declare
  v_ename varchar2(20);
  n_value int;
begin
  n_value := 1;
  n_value := n_value/0;
  exception
   when Dup_val_on_index or Timeout_on_resource or Invalid_CURSOR or Zero_divide then                              
  dbe_output.print_line(SQL_ERR_CODE || '-------' || SQL_ERR_MSG );
   when others then                             
  dbe_output.print_line(SQL_ERR_CODE || '---other---' || SQL_ERR_MSG );
end;
/

DECLARE
  stock_price   NUMBER := 9.73;
  net_earnings  NUMBER := 0;
  pe_ratio      NUMBER;
BEGIN
  pe_ratio :=
    CASE net_earnings
      WHEN 0 THEN NULL
      ELSE stock_price / net_earnings
    END;
END;
/

DROP TABLE if exists test_pl_excpt7;
CREATE TABLE test_pl_excpt7 (c NUMBER);
DECLARE
  default_number NUMBER := 0;
BEGIN
  INSERT INTO test_pl_excpt7 VALUES(TO_NUMBER('100.00', '9G999'));
EXCEPTION
  WHEN INVALID_NUMBER THEN
    dbe_output.print_line('Substituting default value for invalid number.');
    INSERT INTO test_pl_excpt7 VALUES(default_number);
END;
/

select * from test_pl_excpt7;

--test THROW_EXCEPTION
--add 2018-07-03
drop PROCEDURE if exists account_status;
CREATE PROCEDURE account_status (
  due_date DATE,
  today    DATE
) 
--AUTHID DEFINER
IS
BEGIN
  IF due_date < today THEN                   -- explicitly raise exception
    THROW_EXCEPTION(-20000, 'Account past due.');
  END IF;
END;
/
 
DECLARE
  a int := 1;
BEGIN
  account_status ('1-JUL-10', '9-JUL-10');   -- invoke procedure
EXCEPTION
  WHEN others THEN                         -- handle exception
    dbe_output.print_line(SQL_ERR_CODE || SQL_ERR_MSG);
END;
/

DECLARE
  a int := 1;
BEGIN
  account_status ('2017-06-28', '2017-06-29');   -- invoke procedure
EXCEPTION
  WHEN others THEN                         -- handle exception
    dbe_output.print_line(SQL_ERR_CODE || SQL_ERR_MSG);
END;
/

--ERRORCODE cannot be null
CREATE OR REPLACE PROCEDURE account_status (
  due_date DATE,
  today    DATE
) 
IS
BEGIN
  IF due_date < today THEN                   -- explicitly raise exception
    THROW_EXCEPTION(null, 'Account past due.');
  END IF;
END;
/


BEGIN
  account_status ('2017-06-28', '2017-06-29');  
EXCEPTION
  WHEN others THEN                         
    dbe_output.print_line(SQL_ERR_CODE || SQL_ERR_MSG);
END;
/

--ERRORMESSAGE cannot be null
CREATE OR REPLACE PROCEDURE account_status (
  due_date DATE,
  today    DATE
) 
IS
BEGIN
  IF due_date < today THEN                   -- explicitly raise exception
    THROW_EXCEPTION(-20000, NULL);
  END IF;
END;
/


BEGIN
  account_status ('2017-06-28', '2017-06-29');  
EXCEPTION
  WHEN others THEN                         
    dbe_output.print_line(SQL_ERR_CODE || SQL_ERR_MSG);
END;
/

--end

--test process exception
--begin
declare
  v_ename varchar2(20);
  n_value int;
begin
  n_value := 1;
  n_value := n_value/0;
  exception
  n_value := 3;
   when Zero_divide then 
 SYS.dbe_output.print_line('Zero divide');
 SYS.dbe_output.print_line(SQL_ERR_CODE||' error '||SQL_ERR_MSG);
   when others then  
  v_ename := ' test block';                              
  dbe_output.print_line(SQL_ERR_CODE || '-------' || SQL_ERR_MSG || v_ename);
end;
/

declare
  v_int int;
begin
    select -21 into v_int from dual;
 dbe_output.print_line('result: '||v_int);
end;
/
declare
  v_bool boolean;
begin    
    v_bool:=true;
 if(v_bool=true)
 then
     dbe_output.print_line('The condition 1 is true');
 elsif(v_bool=false)
 then
        dbe_output.print_line('The condition TRUE is true');
 end if;
end;
/
declare
  v_int int;
  v_bool boolean;
begin
    v_bool:=true;
    if(v_bool)
 then
     dbe_output.print_line('The condition is true');
 end if;
end;
/
declare
  v_char char(20);
begin
    select '99999999999999999999999999999999999999999999999999999999999999999999999999999' into v_char from dual;
 dbe_output.print_line('result: '||v_char);
end;
/
declare
  v_char char(20);
begin
    select 99999999999999999999999999999999999999999999999999999999999999999999999999999 into v_char from dual;
 dbe_output.print_line('result: '||v_char);
end;
/
drop table if exists t_casewhen;
create table t_casewhen(id int,year int,month int,day int);
insert into t_casewhen values (1,2018,6,30);
declare
    v_int int;
begin
    select (select case id when 1 then '1530331200' end from t_casewhen) into v_int from dual;
    dbe_output.print_line('result: '||v_int);
end;
/
declare
  v_real real;
begin
    select 7.7898765+1 into v_real from dual;
 dbe_output.print_line('result: '||v_real);
end;
/
declare
  v_sysdate number(12,2);
begin
    select 123456.7898765 into v_sysdate from dual;
 dbe_output.print_line('result: '||v_sysdate);
end;
/


create or replace procedure test_DATEADD 
is
  v_sql varchar2(1000);
  v_datepart varchar2(30);
  v_ms varchar2(13);
  a int;
  b number;
begin
  v_datepart := 'abc';
  THROW_EXCEPTION(-20001, ''''||v_datepart||''' is not a recognized dateadd option.' );
exception 
   when Zero_divide then 
 SYS.dbe_output.print_line('Zero divide');
 SYS.dbe_output.print_line(SQL_ERR_CODE||' error '||SQL_ERR_MSG);
   when others then                               
  dbe_output.print_line(SQL_ERR_CODE || '-------' || SQL_ERR_MSG );

end test_DATEADD;
/

exec test_DATEADD;
drop procedure if exists test_DATEADD;

--test dts DTS2018070304658
create or replace function DATEADD( datepart  varchar2, num number, indate date ) return date is
  Result date;
  v_sql varchar2(1000);
  v_datepart varchar2(30);
  v_ms varchar2(13);
begin
  v_datepart := lower(datepart);
  case
    when v_datepart in ('year','yy','y') then
      v_sql := 'select :1 + interval '''||num||''' year from dual';
    when v_datepart in ('quarter','qq','q') then
      v_sql := 'select :1 + (interval ''3'' month) * '||num||' from dual';
    when v_datepart in ('month','mm','m') then
      v_sql := 'select :1 + interval '''||num||''' month from dual';
    when v_datepart in ('week','wk','w') then
      v_sql := 'select :1 + (interval ''7'' day) * '||num||' from dual';
    when v_datepart in ('day','dd','d', 'dayofyear', 'dy', 'weekday', 'dw') then
      v_sql := 'select :1 + interval '''||num||''' day from dual';
    when v_datepart in ('hour','hh') then
      v_sql := 'select :1 + interval '''||num||''' hour from dual';
    when v_datepart in ('minute','mi','n') then
      v_sql := 'select :1 + interval '''||num||''' minute from dual';
    when v_datepart in ('second','ss','s') then
      v_sql := 'select :1 + interval '''||num||''' second from dual';
    when v_datepart in ('millisecond','ms') then
      v_ms := to_char(num/1000,'fm999999990.000');
      v_sql := 'select :1 + interval '''||v_ms||''' second(9,3) from dual';
    else
      THROW_EXCEPTION(-20001, ''''||datepart||''' is not a recognized dateadd option.' );
  end case;

  execute immediate v_sql into Result using indate;

  return(Result);

end DATEADD;
/

--test nesting anonymous block
--add 2018/07/04
declare 
    v_time varchar2(113) ;
    a      int := 1;
begin
    begin
        select 'TIMETAG=' into v_time from dual where rownum <= 1;
    exception
        when no_data_found then                                                                                                                                                                         
            null;
    end;
    dbe_output.print_line(v_time);
    dbe_output.print_line('****************begin to run: ..\Sybase\CMECommon\DBSettings.sql********************');
    a := a/0;
exception
    when no_data_found then                                                                                                                                                                         
        null;   
        when others then
    dbe_output.print_line(a||SQL_ERR_CODE||'******'||SQL_ERR_MSG);     
end;
/


declare 
    v_time varchar2(113) ;
    a      int := 1;
begin
    begin
        select 'TIMETAG=' into v_time from dual where rownum <= 1;
        a := a/0;
    exception
        when no_data_found then                                                                                                                                                                         
            null;
    end;
    dbe_output.print_line(v_time);
    dbe_output.print_line('****************begin to run: ..\Sybase\CMECommon\DBSettings.sql********************');
    a := a/0;
exception
    when no_data_found then                                                                                                                                                                         
        null;   
        when others then
    dbe_output.print_line(SQL_ERR_CODE||'******'||SQL_ERR_MSG);     
end;
/

declare 
    v_time varchar2(113) ;
    a      int := 1;
    SQL_ERR_CODE int;
    SQL_ERR_MSG varchar2(20);
begin
	declare
	a int := 2;
    begin
        select 'TIMETAG=' into v_time from dual where rownum <= 1;
    		a := a/0;
    exception
        when no_data_found then                                                                                                                                                                         
            null;
        when others then
    dbe_output.print_line(a||SQL_ERR_CODE||'==='||SQL_ERR_MSG);  
    end;
    dbe_output.print_line(v_time);
    dbe_output.print_line('****************begin to run: ..\Sybase\CMECommon\DBSettings.sql********************');
    a := a/0;
exception
    when no_data_found then                                                                                                                                                                         
        null;   
        when others then
    dbe_output.print_line(a||SQL_ERR_CODE||'******'||SQL_ERR_MSG);     
end;
/


declare 
    v_time varchar2(113) ;
    a      int := 1;
begin
    begin
        select 'TIMETAG=' into v_time from dual where rownum <= 1;
    		a := a/0;
    exception
        when no_data_found then                                                                                                                                                                         
            null;
        when others then
    dbe_output.print_line(a||SQL_ERR_CODE||'==='||SQL_ERR_MSG);  
    end;
    dbe_output.print_line(v_time);
    dbe_output.print_line('****************begin to run: ..\Sybase\CMECommon\DBSettings.sql********************');
    a := a/0;
exception
    when no_data_found then                                                                                                                                                                         
        null;   
        when others then
    dbe_output.print_line(a||SQL_ERR_CODE||'******'||SQL_ERR_MSG);     
end;
/


--test exception track in exception
drop table if exists T_TRIG_1;
CREATE TABLE T_TRIG_1 (F_INT1 INT, F_INT2 INT, F_CHAR1 CHAR(16));
                     
drop TRIGGER if exists TEST_TRIG;					 
CREATE OR REPLACE TRIGGER TEST_TRIG                                         
AFTER INSERT ON T_TRIG_1                                                    
FOR EACH ROW                                                                
BEGIN                                                                       
    execute immediate 'begin INSERT INTO T_TRIG_1 VALUES(1,2,''A'');end;';    
END;                                                                        
/                                                                           
                                     
--expect error									 
INSERT INTO T_TRIG_1 VALUES(1,2,'A');    
--end

--
--test
drop table if exists test1;
create table test1(a int);

declare
f1 int:= 1;
begin

insert into test1(a) values(f1);
f1 := 2;

begin
insert into test1(a) values(f1);
f1 := f1/0;
exception
when others then
rollback;
end;
f1 := 3;
insert into test1(a) values(f1);
exception
when others then
dbe_output.print_line('others');

end;
/

--expect 3
select * from test1 order by a;

delete from test1;
declare
f1 int:= 1;
begin

insert into test1(a) values(f1);
f1 := 2;

begin
insert into test1(a) values(f1);
f1 := f1/0;
end;
f1 := 3;
insert into test1(a) values(f1);
exception
when others then
dbe_output.print_line('others');

end;
/

--expect 1,2
select * from test1 order by a;
--end

--test Exception Raised
--add 2018/07/27
--Example 11-18 Exception Raised in Exception Handler is Not Handled
CREATE or REPLACE PROCEDURE print_reciprocal (n NUMBER) IS
BEGIN
dbe_output.print_line(1/n); -- handled
EXCEPTION
WHEN ZERO_DIVIDE THEN
dbe_output.print_line('Error:');
dbe_output.print_line(1/n || ' is undefined'); -- not handled
END;
/

BEGIN -- invoking block
print_reciprocal(0);
END;
/

--Example 11-19 Exception Raised in Exception Handler is Handled by Invoker
CREATE OR REPLACE PROCEDURE print_reciprocal (n NUMBER)  IS
BEGIN
  dbe_output.print_line(1/n);
EXCEPTION
  WHEN ZERO_DIVIDE THEN
    dbe_output.print_line('Error:');
    dbe_output.print_line(1/n || ' is undefined');
END;
/
 
BEGIN  -- invoking block
  print_reciprocal(0);
EXCEPTION
  WHEN ZERO_DIVIDE THEN  -- handles exception raised in exception handler
    dbe_output.print_line('1/0 is undefined.');
END;
/

--Example 11-20 Exception Raised in Exception Handler is Handled by Enclosing Block
CREATE OR REPLACE PROCEDURE print_reciprocal (n NUMBER) IS
BEGIN
 
  BEGIN
    dbe_output.print_line(1/n);
  EXCEPTION
    WHEN ZERO_DIVIDE THEN
      dbe_output.print_line('Error in inner block:');
      dbe_output.print_line(1/n || ' is undefined.');
  END;
 
EXCEPTION
  WHEN ZERO_DIVIDE THEN  -- handles exception raised in exception handler
    dbe_output.print('Error in outer block: ');
    dbe_output.print_line('1/0 is undefined.');
END;
/
 
BEGIN
  print_reciprocal(0);
END;
/
--end

--test clean the error info when after track exception
--begin
drop table if exists CME_MML_COMMAND;
create table CME_MML_COMMAND(
    Version  varchar2(113) not null ,
    MMLIndex  number(10, 0) not null ,
    MMLID  number(10, 0) not null ,
    MMLString  clob not null ,
    MMLOrder  number(10, 0) not null ,
    MMLName  varchar2(113) not null ,
    MainDisplay  varchar2(575) null,
    iMode  number(3, 0) default 2 not null,
     primary key  ( Version, MMLIndex, iMode )
);

declare
    v_MMLIndex number(10, 0) ;
begin
    begin
        select  max(MMLIndex) + 1 into v_MMLIndex from CME_MML_COMMAND where Version = 'B4' and iMode = 1 and MMLIndex < 200000;
    exception
        when no_data_found then
            dbe_output.print_line('1');
    end;
    insert into CME_MML_COMMAND (Version,MMLIndex,MMLID,MMLString,MMLOrder,MMLName,MainDisplay,iMode) 
        values ('B4', v_MMLIndex, 18160, 'MOV UCELL: @1, @2, @3, @4, @5, @6;', 2, 'MOV UCELL', '100111', 1);

end; 
/
--end


--test raise exception
--begin
--2018/07/31
CREATE OR REPLACE PROCEDURE p_test_raise AS
    past_due     EXCEPTION;
    due_date     DATE := trunc(SYSDATE) - 1;
    todays_date  DATE := trunc(SYSDATE);
  BEGIN
    IF due_date < todays_date THEN
      RAISE past_due;
    ELSE
      RAISE INVALID_NUMBER;
    END IF;
EXCEPTION
  WHEN OTHERS THEN    
    RAISE;
END;
/

exec p_test_raise;

--Example 11-9 Declaring, Raising, and Handling User-Defined Exception
CREATE OR REPLACE PROCEDURE account_status (
  due_date DATE,
  today    DATE
)
IS
  past_due  EXCEPTION;  -- declare exception
BEGIN
  IF due_date < today THEN
    RAISE past_due;  -- explicitly raise exception
  END IF;
EXCEPTION
  WHEN past_due THEN  -- handle exception
    dbe_output.print_line ('Account past due.');
END;
/
 
BEGIN
  account_status (to_date('2010-01-01','yyyy-mm-dd'), to_date('2010-01-09','yyyy-mm-dd'));
END;
/

--Example 11-10 Explicitly Raising Predefined Exception
DROP TABLE if exists t;
CREATE TABLE t (c NUMBER);
 
CREATE OR REPLACE PROCEDURE p (n NUMBER) IS
  default_number NUMBER := 0;
BEGIN
  IF n < 0 THEN
    RAISE INVALID_NUMBER;  -- raise explicitly
  ELSE
    INSERT INTO t VALUES(TO_NUMBER('100.00', '9G999'));  -- raise implicitly
  END IF;
EXCEPTION
  WHEN INVALID_NUMBER THEN
    dbe_output.print_line('Substituting default value for invalid number.');
    INSERT INTO t VALUES(default_number);
END;
/
 
BEGIN
  p(-1);
END;
/
 
--Example 11-11 Reraising Exception
DECLARE
  salary_too_high   EXCEPTION;
  current_salary    NUMBER := 20000;
  max_salary        NUMBER := 10000;
  erroneous_salary  NUMBER;
BEGIN

  BEGIN
    IF current_salary > max_salary THEN
      RAISE salary_too_high;   -- raise exception
    END IF;
  EXCEPTION
    WHEN salary_too_high THEN  -- start handling exception
      erroneous_salary := current_salary;
      dbe_output.print_line('Salary ' || erroneous_salary ||' is out of range.');
      dbe_output.print_line ('Maximum salary is ' || max_salary || '.');
      RAISE;  -- reraise current exception (exception name is optional)
  END;

EXCEPTION
  WHEN salary_too_high THEN    -- finish handling exception
    current_salary := max_salary;

    dbe_output.print_line (
      'Revising salary from ' || erroneous_salary ||
      ' to ' || current_salary || '.'
    );
END;
/

--Example 11-12 Raising User-Defined Exception with THROW_EXCEPTION
--expect ORA-20000: Account past due.
CREATE OR REPLACE PROCEDURE account_status (
  due_date DATE,
  today    DATE
) 
IS
BEGIN
  IF due_date < today THEN                   -- explicitly raise exception
    THROW_EXCEPTION(-20000, 'Account past due.');
  END IF;
END;
/

DECLARE
  past_due  EXCEPTION;                       -- declare exception
  PRAGMA EXCEPTION_INIT (past_due, -200.00);  -- assign error code to exception
BEGIN
  account_status (to_date('2010-01-01','yyyy-mm-dd'), to_date('2010-01-09','yyyy-mm-dd'));   -- invoke procedure
EXCEPTION
  WHEN past_due THEN                         -- handle exception
    dbe_output.print_line(TO_CHAR(SQL_ERR_MSG(-20000)));
END;
/

DECLARE
  past_due  EXCEPTION;                       -- declare exception
  PRAGMA EXCEPTION_INIT (past_due, -200000000);  -- assign error code to exception
BEGIN
  account_status (to_date('2010-01-01','yyyy-mm-dd'), to_date('2010-01-09','yyyy-mm-dd'));   -- invoke procedure
EXCEPTION
  WHEN past_due THEN                         -- handle exception
    dbe_output.print_line(TO_CHAR(SQL_ERR_MSG(-20000)));
END;
/
 
DECLARE
  past_due  EXCEPTION;                       -- declare exception
  PRAGMA EXCEPTION_INIT (past_due, -20000);  -- assign error code to exception
BEGIN
  account_status (to_date('2010-01-01','yyyy-mm-dd'), to_date('2010-01-09','yyyy-mm-dd'));   -- invoke procedure
EXCEPTION
  WHEN past_due THEN                         -- handle exception
    dbe_output.print_line(TO_CHAR(SQL_ERR_MSG(-20000)));
END;
/

DECLARE
  past_due  EXCEPTION;                       -- declare exception
  PRAGMA EXCEPTION_INIT (past_due, -20000);  -- assign error code to exception
BEGIN
  account_status (to_date('2010-01-01','yyyy-mm-dd'), to_date('2010-01-09','yyyy-mm-dd'));   -- invoke procedure
EXCEPTION
  WHEN past_due THEN                         -- handle exception
    dbe_output.print_line(TO_CHAR(SQL_ERR_MSG(-20001)));
END;
/

--Example 11-13 Exception that Propagates Beyond Scope is Handled
CREATE OR REPLACE PROCEDURE p AS
BEGIN
  DECLARE
    past_due     EXCEPTION;
    due_date     DATE := trunc(SYSDATE) - 1;
    todays_date  DATE := trunc(SYSDATE);
  BEGIN
    IF due_date < todays_date THEN
      RAISE past_due;
    END IF;
  END;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
/

exec p;

--Example 11-14 Exception that Propagates Beyond Scope is Not Handled
BEGIN
  DECLARE
    past_due     EXCEPTION;
    due_date     DATE := trunc(SYSDATE) - 1;
    todays_date  DATE := trunc(SYSDATE);
  BEGIN
    IF due_date < todays_date THEN
      RAISE past_due;
    END IF;
  END;

END;
/

--Example 11-15 Exception Raised in Declaration is Not Handled
DECLARE
  credit_limit NUMBER(3) := 5000;  -- Maximum value is 999
BEGIN
  NULL;
EXCEPTION
  WHEN VALUE_ERROR THEN
    dbe_output.print_line('Exception raised in declaration.');
  WHEN OTHERS THEN
    dbe_output.print_line('Exception trackle.');
END;
/

--Example 11-16 Exception Raised in Declaration is Handled by Enclosing Block
--expect Exception raised in declaration.
BEGIN
   DECLARE
    credit_limit NUMBER(3) := 5000;
  BEGIN
    NULL;
  END; 
EXCEPTION
  WHEN VALUE_ERROR THEN
    dbe_output.print_line('Exception raised in declaration.');
  WHEN OTHERS THEN
    dbe_output.print_line('Exception trackle.');
END;
/

--Example 11-17 Exception Raised in Exception Handler is Not Handled
CREATE OR REPLACE PROCEDURE print_reciprocal (n NUMBER)  IS
BEGIN
  dbe_output.print_line(1/n);  -- handled
EXCEPTION
  WHEN ZERO_DIVIDE THEN
    dbe_output.print_line('Error:');
    dbe_output.print_line(1/n || ' is undefined');  -- not handled
END;
/
 
BEGIN  -- invoking block
  print_reciprocal(0);
END;
/

--test raise without exception name should in a exception block
--expect error
declare
a number;
b number;
begin
a := dbe_util.get_date_time();
raise;
b := dbe_util.get_date_time();
dbe_output.print_line(b-a);
end;
/

--test
declare
    past_due     EXCEPTION;
    past_due1     EXCEPTION;
    due_date     DATE := trunc(SYSDATE) - 1;
    todays_date  DATE := trunc(SYSDATE);
    a int:= 99;
    --PRAGMA EXCEPTION_INIT (past_due, 99);
BEGIN
  BEGIN
    IF due_date < todays_date and 1 < 2 THEN
      RAISE past_due1;
    ELSE
      RAISE INVALID_NUMBER;
    END IF;
  EXCEPTION
    WHEN past_due1 THEN    
    dbe_output.print_line('past_due1-'||SQL_ERR_CODE||SQL_ERR_MSG);
    RAISE past_due;
  WHEN past_due THEN    
    dbe_output.print_line('past_due-'||SQL_ERR_CODE||SQL_ERR_MSG);
  WHEN OTHERS THEN    
    dbe_output.print_line(SQL_ERR_CODE||SQL_ERR_MSG);
  END;
EXCEPTION
  WHEN past_due1 THEN    
    dbe_output.print_line('past_due1:'||SQL_ERR_CODE||SQL_ERR_MSG);
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);	
  WHEN INVALID_NUMBER OR PROGRAM_ERROR THEN    
    dbe_output.print_line('SYS ERROR:'||SQL_ERR_CODE||SQL_ERR_MSG);
  WHEN OTHERS THEN    
    dbe_output.print_line('other:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/

--expect : predefined:636invalid number
declare
    past_due     EXCEPTION;
    past_due1     EXCEPTION;
    --PRAGMA EXCEPTION_INIT (past_due, -01722);
BEGIN
    IF 1 > 2 THEN
      RAISE past_due;
    ELSE
      RAISE INVALID_NUMBER;
    END IF;
EXCEPTION
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
  WHEN INVALID_NUMBER OR NO_DATA_FOUND THEN    
    dbe_output.print_line('predefined:'||SQL_ERR_CODE||SQL_ERR_MSG);
  WHEN OTHERS THEN    
    dbe_output.print_line(SQL_ERR_CODE||SQL_ERR_MSG);
END;
/

--expect:past_due:90000001User Defined Exception
declare
    past_due     EXCEPTION;
    past_due1     EXCEPTION;
    --PRAGMA EXCEPTION_INIT (past_due, -01722);
BEGIN
    IF 1 < 2 THEN
      RAISE past_due;
    ELSE
      RAISE INVALID_NUMBER;
    END IF;
EXCEPTION
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
  WHEN INVALID_NUMBER OR NO_DATA_FOUND THEN    
    dbe_output.print_line('predefined:'||SQL_ERR_CODE||SQL_ERR_MSG);
  WHEN OTHERS THEN    
    dbe_output.print_line(SQL_ERR_CODE||SQL_ERR_MSG);
END;
/

--support PRAGMA EXCEPTION_INIT
declare
    past_due     EXCEPTION;
    past_due1     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due1, -20000);
BEGIN
  BEGIN
    IF 1 < 2 THEN
      RAISE past_due1;
    ELSE
      RAISE INVALID_NUMBER;
    END IF;
  EXCEPTION
    WHEN past_due1 THEN    
    dbe_output.print_line('past_due1:'||SQL_ERR_CODE);
    RAISE past_due;
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
  WHEN OTHERS THEN    
    dbe_output.print_line(SQL_ERR_CODE||SQL_ERR_MSG);
  END;
EXCEPTION
  WHEN past_due1 THEN    
    dbe_output.print_line('past_due1:'||SQL_ERR_CODE||SQL_ERR_MSG);
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
  WHEN OTHERS THEN    
    dbe_output.print_line(SQL_ERR_CODE||SQL_ERR_MSG);
END;
/


--expect error
declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due1, -20000);
BEGIN
    IF 1 < 2 THEN
      RAISE past_due;
    END IF;
  EXCEPTION
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/

--expect error ERR_ERRNO_BASE -1
declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, -1);
BEGIN
    IF 1 < 2 THEN
      RAISE past_due;
    END IF;
  EXCEPTION
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/

--expect success ERR_ERRNO_BASE 
declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, 0);
BEGIN
    IF 1 < 2 THEN
      RAISE past_due;
    END IF;
  EXCEPTION
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/

--expect error
declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, -19999);
BEGIN
    IF 1 < 2 THEN
      RAISE past_due;
    END IF;
  EXCEPTION
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/

--expect success ERR_MAX_USER_DEFINE_ERROR
declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, -20000);
BEGIN
    IF 1 < 2 THEN
      RAISE past_due;
    END IF;
  EXCEPTION
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/

--expect error ERR_MIN_USER_DEFINE_ERROR-1
declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, -21000);
BEGIN
    IF 1 < 2 THEN
      RAISE past_due;
    END IF;
  EXCEPTION
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/

--expect success ERR_MIN_USER_DEFINE_ERROR
declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, -20999);
BEGIN
    IF 1 < 2 THEN
      RAISE past_due;
    END IF;
  EXCEPTION
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/

--expect error: ERR_CODE_CEIL
declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, 100000);
BEGIN
    IF 1 < 2 THEN
      RAISE past_due;
    END IF;
  EXCEPTION
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/

--expect success: ERR_CODE_CEIL
declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, 99999);
BEGIN
    IF 1 < 2 THEN
      RAISE past_due;
    END IF;
  EXCEPTION
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/
--end

--test exception
--begin
--VALUE_ERROR 
BEGIN
  DECLARE
    credit_limit NUMBER(3) := 5000;
  BEGIN
    NULL;
  END;
EXCEPTION
  WHEN VALUE_ERROR THEN
    dbe_output.print_line('Exception raised in declaration.');
 dbe_output.print_line(SQL_ERR_CODE||' SQL_ERR_MSG is:'||SQL_ERR_MSG);
  WHEN INVALID_NUMBER THEN
    dbe_output.print_line('Exception raised in declaration111.');
 dbe_output.print_line(SQL_ERR_CODE||' SQL_ERR_MSG is:'||SQL_ERR_MSG);
END;
/

--VALUE_ERROR 
BEGIN 
  DECLARE
    credit_limit VARCHAR(3) := '5000';
  BEGIN
    NULL;
  END;
EXCEPTION
  WHEN VALUE_ERROR THEN
    dbe_output.print_line('Exception raised in declaration.');
 dbe_output.print_line(SQL_ERR_CODE||' SQL_ERR_MSG is: '||SQL_ERR_MSG); 
  WHEN INVALID_NUMBER THEN
    dbe_output.print_line('Exception raised in declaration111.');
 dbe_output.print_line(SQL_ERR_CODE||' SQL_ERR_MSG is: '||SQL_ERR_MSG);  
END;
/
--end

--test defined exception
--test ROWTYPE_MISMATCH
--add 2018/11/23
drop table if exists PRE_EXCEPTION_009_T_01;
drop table if exists PRE_EXCEPTION_009_T_02;
create table PRE_EXCEPTION_009_T_01(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into PRE_EXCEPTION_009_T_01 values(1,'zhangsan','doctor1',10000);
insert into PRE_EXCEPTION_009_T_01 values(2,'zhangsan2','doctor2',10000);
insert into PRE_EXCEPTION_009_T_01 values(123,'zhangsan3','doctor3',10000);
create table PRE_EXCEPTION_009_T_02(empno int,ename varchar(10),job varchar(10) );

CREATE OR REPLACE PROCEDURE PRE_EXCEPTION_009_Proc_01
IS
C1 SYS_REFCURSOR;
var1 PRE_EXCEPTION_009_T_02%rowtype;
BEGIN
OPEN C1 FOR
    SELECT *  FROM PRE_EXCEPTION_009_T_01  where empno=1 ORDER BY empno,ename;
fetch C1 into var1; 
EXCEPTION
  WHEN ROWTYPE_MISMATCH THEN
  begin
  dbe_output.print_line( '-------------------------------------' );
  dbe_output.print_line('TOO_MANY_ROWS exception:'||SQL_ERR_CODE||'SQL_ERR_MSG is:'||SQL_ERR_MSG);
  end;
END;
/

--expect success
exec PRE_EXCEPTION_009_Proc_01();

drop table if exists PRE_EXCEPTION_009_T_01;
drop table if exists PRE_EXCEPTION_009_T_02;

--test ROWTYPE_MISMATCH
--add 2018/11/23
drop table if exists TB_USER_1;
CREATE TABLE TB_USER_1
(
    ID INTEGER NOT NULL,
    USER_NAME VARCHAR2(20) NOT NULL,
    USER_AGE INTEGER NOT NULL
);

insert into TB_USER_1(ID,USER_NAME,USER_AGE)values(20,'zz',80);
insert into TB_USER_1(ID,USER_NAME,USER_AGE)values(30,'zz',90);
commit;

--expect success
DECLARE
V_AGE TB_USER_1.USER_AGE%TYPE;
V_NAME TB_USER_1.USER_NAME%TYPE;
CURSOR USER_CURSOR IS SELECT USER_NAME, USER_AGE FROM TB_USER_1;
BEGIN
  OPEN USER_CURSOR;
  FOR USER_RECORD IN USER_CURSOR LOOP
    dbe_output.print_line(USER_RECORD.USER_NAME || ', ' || USER_RECORD.USER_AGE);
  END LOOP;
  EXCEPTION
    WHEN CURSOR_ALREADY_OPEN THEN
      dbe_output.print_line('cursor already open');
END;
/
drop table if exists TB_USER_1;
--end

declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, 922);
BEGIN
  
    if 1 < 2 then
    raise past_due;
    end if;
END;
/

--test control statement in exception
--test return
CREATE or replace procedure test_exception_1(a int)
is
    past_due     EXCEPTION;
BEGIN
    IF 1 < 2 THEN
      RAISE no_data_found;
    END IF;
  EXCEPTION
  WHEN no_data_found THEN
    return;
END;
/

declare
    a int;
BEGIN
    test_exception_1(1);
    a := 'sss';
END;
/

--test goto and jump line not in same exception
CREATE or replace procedure test_exception_1(a int)
is
    past_due     EXCEPTION;
BEGIN    
	BEGIN
	    IF 1 < 2 THEN
	      RAISE no_data_found;
	    END IF;
	  EXCEPTION
	  WHEN no_data_found THEN
	    goto update_row;
	END;
	
	<<update_row>>
      dbe_output.print_line (SQL_ERR_MSG);  
END;
/

declare
    a int;
BEGIN
    test_exception_1(1);
    a := 'sss';
END;
/


--test exit
CREATE or replace procedure test_exception_1(a int)
is
    past_due     EXCEPTION;
BEGIN    
	BEGIN
	    IF 1 < 2 THEN
	      RAISE no_data_found;
	    END IF;
	  EXCEPTION
	  WHEN no_data_found THEN
	    FOR j IN 1..10 LOOP
	    if j > 0 then
	    exit;
	    end if;
    END LOOP;
	END;  
 
END;
/

declare
    a int;
BEGIN
    test_exception_1(1);
    a := 'sss';
END;
/

--test exit-when
CREATE or replace procedure test_exception_1(a int)
is
    past_due     EXCEPTION;
    x number := 0;
BEGIN    
	BEGIN
	    IF 1 < 2 THEN
	      RAISE no_data_found;
	    END IF;
	  EXCEPTION
	  WHEN no_data_found THEN
	    LOOP
	    x := x+1;
	    EXIT WHEN x > 0;
  		END LOOP;
	END;  
 
END;
/

declare
    a int;
BEGIN
    test_exception_1(1);
    a := 'sss';
END;
/

--end

--test PRAGMA EXCEPTION_INIT
--DTS2018120309074
--begin
--expect success
declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, 1);
BEGIN  
    if 1 < 2 then
    raise past_due;
    end if;
END;
/
declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, -20999);
BEGIN  
    if 1 < 2 then
    raise past_due;
    end if;
END;
/
declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, -20000);
BEGIN  
    if 1 < 2 then
    raise past_due;
    end if;
END;
/
--expect error
declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, 0);
BEGIN  
    if 1 < 2 then
    raise past_due;
    end if;
END;
/

declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, -21000);
BEGIN  
    if 1 < 2 then
    raise past_due;
    end if;
END;
/
declare
    past_due     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, -19999);
BEGIN  
    if 1 < 2 then
    raise past_due;
    end if;
END;
/

--end

--test check error position of exception DTS2018121103000
--begin
--expect error
DECLARE
  stock_price   NUMBER := 9.73;
  net_earnings  NUMBER := 0;
  pe_ratio      NUMBER;
BEGIN
  for i in 1..100 loop
    pe_ratio := stock_price / net_earnings; 
  dbe_output.print_line('Price/earnings ratio = ' || pe_ratio);
EXCEPTION
  WHEN ZERO_DIVIDE THEN
    dbe_output.print_line('Company had zero earnings;SQL_ERR_CODE is:'||SQL_ERR_CODE||'SQL_ERR_MSG is:'||SQL_ERR_MSG||'i='||i);
    pe_ratio := NULL;
 end loop;
END;
/
--end

--test exception without begin
--DTS2018120309074
--begin
--expect error
DECLARE
  my_except EXCEPTION;
  my_except2 EXCEPTION;
  PRAGMA EXCEPTION_INIT(my_except, -20999);
  pragma exception_init(my_except2,-20000);
BEGIN
  raise my_except;
EXCEPTION
  WHEN my_except THEN    
    dbe_output.print_line ('my_except:'||SQL_ERR_CODE||'='||SQL_ERR_MSG );
 raise my_except2;
 exception 
    when my_except2 then
       dbe_output.print_line ('my_except2:'||SQL_ERR_CODE||'='||SQL_ERR_MSG );
 
  WHEN OTHERS THEN
        dbe_output.print_line ('low_income:');
END;
/

DECLARE
  my_except EXCEPTION;
  my_except2 EXCEPTION;
  PRAGMA EXCEPTION_INIT(my_except, 1);
  pragma exception_init(my_except2,99999);
BEGIN
  raise my_except;
EXCEPTION
    when my_except2 then
       dbe_output.print_line ('my_except2:'||SQL_ERR_CODE||'='||SQL_ERR_MSG );
  WHEN OTHERS THEN
        dbe_output.print_line ('low_income:');
END;
/

--end

--test error message overlying when ERR_ALLOC_MEMORY/ERR_PL_ENTRY_LOCK
--begin
--ERR_ALLOC_MEMORY
--ERR_PL_ENTRY_LOCK
declare
    past_due     EXCEPTION;
     PRAGMA EXCEPTION_INIT (past_due, 963);
BEGIN
    IF 1 < 2 THEN
      RAISE past_due;
    END IF;
END;
/  
--end
--test return without value
create or replace function PRE_EXCEPTION_025_Fun_RETURN(a int,b out int) return int is

BEGIN
b := a;
END;
/

declare
d int;
e int;
BEGIN
d :=  PRE_EXCEPTION_025_Fun_RETURN(2,e) ;
exception
 when RETURN_WITHOUT_VALUE then

 SYS.dbe_output.print_line('exception return without res');
END;
/
--end return without value

--begin
drop table if exists TB_USER_1;
CREATE TABLE TB_USER_1
(
    ID INTEGER NOT NULL,
    USER_NAME VARCHAR2(20) NOT NULL,
    USER_AGE INTEGER NOT NULL
);

insert into TB_USER_1(ID,USER_NAME,USER_AGE)values(20,'zz',80);
insert into TB_USER_1(ID,USER_NAME,USER_AGE)values(30,'zz',90);
commit;

--expect success
DECLARE
V_AGE TB_USER_1.USER_AGE%TYPE;
V_NAME TB_USER_1.USER_NAME%TYPE;
CURSOR USER_CURSOR IS SELECT USER_NAME, USER_AGE FROM TB_USER_1;
BEGIN
  OPEN USER_CURSOR; 
  FOR USER_RECORD IN USER_CURSOR LOOP
    dbe_output.print_line(USER_RECORD.USER_NAME || ', ' || USER_RECORD.USER_AGE);
  END LOOP;
  EXCEPTION
    WHEN CURSOR_ALREADY_OPEN THEN
     close USER_CURSOR;
    FOR USER_RECORD IN USER_CURSOR LOOP
       dbe_output.print_line(USER_RECORD.USER_NAME || ', ' || USER_RECORD.USER_AGE);
   END LOOP;
end;
/

--expect success
DECLARE
V_AGE TB_USER_1.USER_AGE%TYPE;
V_NAME TB_USER_1.USER_NAME%TYPE;
CURSOR USER_CURSOR IS SELECT USER_NAME, USER_AGE FROM TB_USER_1;
BEGIN
  FOR USER_RECORD IN USER_CURSOR LOOP
    dbe_output.print_line(USER_RECORD.USER_NAME || ', ' || USER_RECORD.USER_AGE);
  END LOOP;
  EXCEPTION
    WHEN CURSOR_ALREADY_OPEN THEN
     close USER_CURSOR;
    FOR USER_RECORD IN USER_CURSOR LOOP
       dbe_output.print_line(USER_RECORD.USER_NAME || ', ' || USER_RECORD.USER_AGE);
   END LOOP;
end;
/
--end
drop table if exists FVT_FUNCTION_DDL_008_T;
create table FVT_FUNCTION_DDL_008_T(id int,name varchar2(100));
insert into FVT_FUNCTION_DDL_008_T values(30,'commit');
insert into FVT_FUNCTION_DDL_008_T values(30,'commit2');
create or replace function  FVT_FUNCTION_DDL_008_Fun return int
is 
a int := 0;
b int:= 20;
c  varchar2(100) ;
cursor mycursor(p1 int) is select name from FVT_FUNCTION_DDL_008_T where id > p1 order by id;
begin
open mycursor(b);
fetch mycursor into c;
a := a+1;
return a;
end;
/

create or replace function  CHK_FUNCTION_GROUP(a varchar, b int) return int
is 
begin
   return 1;
end;
/

drop table if exists CHK_T1;
create table CHK_T1(x varchar(10));
insert into CHK_T1 values('1234');

declare
  a varchar(10) := '1234';
  b int := 999;
begin
  select CHK_FUNCTION_GROUP(x,a) into b from CHK_T1 group by CHK_FUNCTION_GROUP(x,a);
  dbe_output.print_line(b);
end;
/


--changhong
drop table if exists trigger8_bingfa_Tab_001;
drop table if exists trigger8_bingfa_Tab_002;
drop table if exists trigger8_bingfa_Tab_003;
create table trigger8_bingfa_Tab_001(id int primary key,sal number(10,2),name varchar(100),text clob default 'test',c_time date,m_time datetime);
create table trigger8_bingfa_Tab_002(id int ,sal number(10,2),name varchar(100),text clob default 'test',c_time date,m_time datetime);
create table trigger8_bingfa_Tab_003(id int ,sal number(10,2),name varchar(100),text clob default 'test',c_time date,m_time date,flag int,status int );
drop sequence if exists trigger8_bingfa_Seq_01;
drop sequence if exists trigger8_bingfa_Seq_02;
create sequence trigger8_bingfa_Seq_01 start  with 1 increment by 1;
create sequence trigger8_bingfa_Seq_02 start  with 1 increment by 1;

create or replace trigger  trigger8_bingfa_07 after delete or insert or  update on 
trigger8_bingfa_Tab_001 for each row
declare
v_status int;
v_flag int;
begin
if inserting then
insert into trigger8_bingfa_Tab_002(id,c_time,text) values (trigger8_bingfa_Seq_01.nextval,sysdate,'after delete or  insert or update on trigger8_bingfa_Tab_001 ');
select 1,1 into v_flag,v_status from dual;
insert into trigger8_bingfa_Tab_003 values(:Old.id,:OLD.sal,:OLD.name,:old.text,:old.c_time,:old.m_time,v_flag,v_status);

elsif  updating then
  begin
  select flag+1,1 into v_flag,v_status from trigger8_bingfa_Tab_003;
  update trigger8_bingfa_Tab_003 set m_time = :new.m_time, flag = v_flag,status=v_status where id = :new.id ;
  exception 
    when too_many_rows then
     begin
     select flag+1,1 into v_flag,v_status from trigger8_bingfa_Tab_003 where id = :new.id limit 1;
     update trigger8_bingfa_Tab_003 set m_time = :new.m_time, flag = v_flag,status=v_status where id = :new.id ;
     end;
  end;
  
elsif deleting then 
select 0,-1 into v_flag,v_status from dual;
update trigger8_bingfa_Tab_003 set flag = v_flag, status=v_status where id = :old.id ;
end if;
end;
/

insert into trigger8_bingfa_Tab_001 values(3,9000,'test','',sysdate,sysdate);
insert into trigger8_bingfa_Tab_001 values(4,9000,'test','',sysdate,sysdate);
update trigger8_bingfa_Tab_001 set text='update'  where id < 10;
drop table if exists trigger8_bingfa_Tab_001;
drop table if exists trigger8_bingfa_Tab_002;
drop table if exists trigger8_bingfa_Tab_003;
drop sequence if exists trigger8_bingfa_Seq_01;
drop sequence if exists trigger8_bingfa_Seq_02;

--test nested exception
drop table if exists t1_test_nested_exception;
create table t1_test_nested_exception(id int, description nvarchar2(20));
drop procedure if exists  p1_test_nested_exception;
create or replace procedure p1_test_nested_exception()
is 
tmp int;
begin
select id into tmp from t1_test_nested_exception;
dbe_output.print_line(tmp);

exception
   when no_data_found then 
    dbe_output.print_line('error:no_data_found');
    dbe_output.print_line(SQL_ERR_CODE || ' error ' || SQL_ERR_MSG); --no data
    declare
    begin
      insert into t1_test_nested_exception values(1,'dqqa');
      select id into tmp from t1_test_nested_exception;
      dbe_output.print_line(tmp);
      tmp := tmp/0;
    exception
    when zero_divide then 
      dbe_output.print_line('zero divide');
      dbe_output.print_line(SQL_ERR_CODE||' error '||SQL_ERR_MSG);
    end;
    dbe_output.print_line(SQL_ERR_CODE||' error '||SQL_ERR_MSG);
end p1_test_nested_exception;
/
call p1_test_nested_exception();

drop table if exists t1_test_nested_exception;
drop procedure p1_test_nested_exception;
--DTS2019010206723 
alter system set LOCAL_TEMPORARY_TABLE_ENABLED=true;
create  user PROC_FOR_LOOP_JOIN_1_DML_USER_015_1 IDENTIFIED BY DATABASE_123 PASSWORD EXPIRE;
create  user PROC_FOR_LOOP_JOIN_1_DML_USER_015_2 IDENTIFIED BY DATABASE_123 PASSWORD EXPIRE;
create  user PROC_FOR_LOOP_JOIN_1_DML_USER_015_3 IDENTIFIED BY DATABASE_123 PASSWORD EXPIRE;
create  user PROC_FOR_LOOP_JOIN_1_DML_USER_015_4 IDENTIFIED BY DATABASE_123 PASSWORD EXPIRE;
CONN / AS SYSDBA
GRANT SELECT ON sys.SYS_TABLES TO PROC_FOR_LOOP_JOIN_1_DML_USER_015_1;
conn gs_plsql_exception_0114/Lh00420062@127.0.0.1:1611

drop table if exists PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015;
drop table if exists PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_2;
drop table if exists PROC_FOR_LOOP_JOIN_1_DML_USER_015_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_3;


create table PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015 
(
c_int int,
c_number number,
c_varchar varchar(4000),
c_date date
);
insert into PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015 values
(1,1.25,'abcd','2015-5-5');
insert into PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015 values
(2,2.25,'你好','2016-6-6');
insert into PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015 values
(2,2.25,lpad('ab',75,'c'),'2017-7-7');

create table PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_2 
(
c_int int,
c_number number,
c_varchar varchar(4000),
c_date date
)
partition by range (c_number)
(
partition p1 values less than (3),
partition p2 values less than (10)
);
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_2 values
(1,1.12345,'aaa','2015-5-5');
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_2 values
(2,2.12345,'shengming','2016-6-6');
insert into  PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_2 values
(2,2.25,lpad('ab',78,'c'),'2017-7-7');

GRANT SELECT ON PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_2 TO PROC_FOR_LOOP_JOIN_1_DML_USER_015_1;
drop PROCEDURE if exists PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_1;
CREATE OR REPLACE PROCEDURE PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_1()
IS
--declare
b_bigint bigint:=0;
c_cur1 date :='2016-6-6';
v_refcur1 sys_refcursor;
b_varchar varchar(15):='df';
b_date date :='2000-1-1';
b_temp int :=15;
b_sql varchar(2000);
BEGIN  
 for i in 
 (  select a.c_int from PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015 as a  join  PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_2 as b  where a.c_int =b.c_int and a.c_int<=3 )
  loop
    b_sql := 'drop table if exists PROC_FOR_LOOP_JOIN_1_DML_USER_015_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_3';
    execute immediate b_sql;
    b_sql :=' create global temporary table PROC_FOR_LOOP_JOIN_1_DML_USER_015_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_3 
(
c_int int,
c_number number,
c_varchar varchar(4000),
c_date date
)' ;
    execute immediate b_sql;
    select name  into b_sql from  sys.SYS_TABLES where name ='PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_3';
    dbe_output.print_line(b_sql);
    open v_refcur1 for select c_date from PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015 where c_date=c_cur1;
    dbe_sql.return_cursor(v_refcur1);
 end loop;
END;
/

call PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_1();
insert into PROC_FOR_LOOP_JOIN_1_DML_USER_015_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_3 values(2,2.25,lpad('ab',3995,'c'),'2017-7-7');
drop PROCEDURE if exists  PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_2;
GRANT EXECUTE ON PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_1 TO PROC_FOR_LOOP_JOIN_1_DML_USER_015_2;
CREATE OR REPLACE PROCEDURE  PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_2()
IS
b_temp int :=1;
BEGIN  
 for i in 1..2
  loop
  -- loop
   PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_1();
   b_temp :=b_temp-1;
   exit when b_temp =0;
  --end loop;
 end loop;
END;
/
call PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_2();

GRANT EXECUTE ON PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_2 TO PROC_FOR_LOOP_JOIN_1_DML_USER_015_3;
CREATE OR REPLACE PROCEDURE  PROC_FOR_LOOP_JOIN_1_DML_USER_015_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_3()
IS
b_temp int :=1;
BEGIN  
 for i in 1..2
  loop
   PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_2();
 end loop;
END;
/
exec PROC_FOR_LOOP_JOIN_1_DML_USER_015_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_3();

GRANT EXECUTE ON PROC_FOR_LOOP_JOIN_1_DML_USER_015_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_3 TO PROC_FOR_LOOP_JOIN_1_DML_USER_015_4;
GRANT INSERT ON PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015 TO PROC_FOR_LOOP_JOIN_1_DML_USER_015_4;
GRANT INSERT ON PROC_FOR_LOOP_JOIN_1_DML_USER_015_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_3 TO PROC_FOR_LOOP_JOIN_1_DML_USER_015_4;
GRANT INSERT ON PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_2 TO PROC_FOR_LOOP_JOIN_1_DML_USER_015_4;
GRANT UPDATE ON PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015 TO PROC_FOR_LOOP_JOIN_1_DML_USER_015_4;
GRANT UPDATE ON PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_2 TO PROC_FOR_LOOP_JOIN_1_DML_USER_015_4;
GRANT UPDATE ON PROC_FOR_LOOP_JOIN_1_DML_USER_015_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_3 TO PROC_FOR_LOOP_JOIN_1_DML_USER_015_4;
CREATE OR REPLACE PROCEDURE  PROC_FOR_LOOP_JOIN_1_DML_USER_015_4.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_4()
IS
b_length int :=2;
sql1 varchar(4000):='';
BEGIN  
 for i in 1..2
  loop
   PROC_FOR_LOOP_JOIN_1_DML_USER_015_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_3();  
 end loop;
 
 insert into PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015 values(220,2.25,lpad('ab',75,'c'),'2017-7-7');
 insert into PROC_FOR_LOOP_JOIN_1_DML_USER_015_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_3 values(210,2.25,lpad('ab',3995,'c'),'2017-7-7');
 insert into  PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_2 values(210,2.25,lpad('ab',78,'c'),'2017-7-7');
 update  PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015 set c_varchar =rpad('ab',3999,'c');
 update  PROC_FOR_LOOP_JOIN_1_DML_USER_015_2.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_2 set c_varchar =rpad('ab',3998,'c');
 update  PROC_FOR_LOOP_JOIN_1_DML_USER_015_3.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015_3 set c_varchar =rpad('ab',3998,'c');
 
 sql1 :='truncate table  PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015 drop storage';
 execute immediate sql1;
 
END;
/

select * from PROC_FOR_LOOP_JOIN_1_DML_USER_015_1.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_TAB_015;
exec PROC_FOR_LOOP_JOIN_1_DML_USER_015_4.PROC_FOR_LOOP_JOIN_1_DML_TRUNCATE_PROC_011_4();
drop user PROC_FOR_LOOP_JOIN_1_DML_USER_015_1 cascade;
drop user PROC_FOR_LOOP_JOIN_1_DML_USER_015_2 cascade;
drop user PROC_FOR_LOOP_JOIN_1_DML_USER_015_3 cascade;
drop user PROC_FOR_LOOP_JOIN_1_DML_USER_015_4 cascade;

create table PRE_EXCEPTION_017_T_0110(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into PRE_EXCEPTION_017_T_0110 values(1,'zhangsan','doctor1',10000);
DECLARE
var_tmp varchar(10);
BEGIN
execute immediate 'select empno,ename from PRE_EXCEPTION_017_T_0110' into var_tmp ;
exception
   when PROGRAM_ERROR then
   dbe_output.print_line('PROGRAM_ERROR SQL_ERR_CODE:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/


--New add 1 test nested exception 
declare
tmp int :=1;
begin --stack[0]
raise ACCESS_INTO_NULL;
exception --stack[1]
   when others then
    dbe_output.print_line(SQL_ERR_CODE || ' error ' || SQL_ERR_MSG); --no data 
    begin  ----stack[2]
    tmp := tmp/0;
    exception --stack[3]
        when zero_divide then 
        dbe_output.print_line(SQL_ERR_CODE||' **error0** '||SQL_ERR_MSG);
        begin  --stack[4]
            begin  --stack[5] 
               raise invalid_number;
            exception 
                when others then
                    dbe_output.print_line(SQL_ERR_CODE||' ** error other **'||SQL_ERR_MSG);
                    raise;  
            end;
        exception --stack[5]
        when others then
            dbe_output.print_line(SQL_ERR_CODE||' ** error other 3 **'||SQL_ERR_MSG);
            raise;
        end;
        dbe_output.print_line(SQL_ERR_CODE||' ** error3 **'||SQL_ERR_MSG);
    end;
    dbe_output.print_line(SQL_ERR_CODE || '** error4 **' || SQL_ERR_MSG);
end;
/

--New add 2 test nested exception 
declare
    past_due     EXCEPTION;
    past_due1     EXCEPTION;
    PRAGMA EXCEPTION_INIT (past_due, 99);
    PRAGMA EXCEPTION_INIT (past_due1, 98);
BEGIN
  BEGIN
  begin
  begin
    RAISE past_due1;
    EXCEPTION
        WHEN past_due1 THEN    
            dbe_output.print_line('past_due1-'||SQL_ERR_CODE||SQL_ERR_MSG);
             raise;
        WHEN past_due THEN    
            dbe_output.print_line('past_due-'||SQL_ERR_CODE||SQL_ERR_MSG);
        WHEN OTHERS THEN    
            dbe_output.print_line(SQL_ERR_CODE||SQL_ERR_MSG);
  END;
  end;
  end;
EXCEPTION
  WHEN past_due1 THEN    
    dbe_output.print_line('past_due1:'||SQL_ERR_CODE||SQL_ERR_MSG);
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);	
  WHEN OTHERS THEN    
    dbe_output.print_line('other:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/


--New add 3 test nested exception 
declare
    past_due     EXCEPTION;
    past_due1     EXCEPTION;
BEGIN
  BEGIN
  begin
  begin
    RAISE past_due1;
    EXCEPTION
        WHEN past_due1 THEN    
            dbe_output.print_line('past_due1-'||SQL_ERR_CODE||SQL_ERR_MSG);
            RAISE past_due;
        WHEN past_due THEN    
            dbe_output.print_line('past_due-'||SQL_ERR_CODE||SQL_ERR_MSG);
        WHEN OTHERS THEN    
            dbe_output.print_line(SQL_ERR_CODE||SQL_ERR_MSG);
  END;
  end;
  end;
EXCEPTION
  WHEN past_due1 THEN    
    dbe_output.print_line('past_due1:'||SQL_ERR_CODE||SQL_ERR_MSG);
  WHEN past_due THEN    
    dbe_output.print_line('past_due:'||SQL_ERR_CODE||SQL_ERR_MSG);	
  WHEN OTHERS THEN    
    dbe_output.print_line('other:'||SQL_ERR_CODE||SQL_ERR_MSG);
END;
/

--New add 4 test label 
CREATE or replace procedure test_exception_1(a int)
is
    past_due     EXCEPTION;
BEGIN    
    BEGIN
        IF 1 < 2 THEN
        RAISE no_data_found;
        END IF;
    EXCEPTION
    WHEN no_data_found THEN
        goto update_row;
    END;
    <<update_row>>
      dbe_output.print_line (SQL_ERR_CODE || ' AND '||SQL_ERR_MSG);  
END;
/
declare
    a int;
BEGIN
    test_exception_1(1);
END;
/

--New add 5 test nested exception 
CREATE OR REPLACE PROCEDURE p_user_handle AS
BEGIN
  DECLARE
    past_due     EXCEPTION;
    due_date     DATE := trunc(SYSDATE) - 1;
    todays_date  DATE := trunc(SYSDATE);
  BEGIN
    IF due_date < todays_date THEN
      dbe_output.print_line('here excuete');
      RAISE past_due;
    END IF;
  END;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
/

exec p_user_handle;

--New add 6 test nested exception 
create or replace procedure p1_test_nested_exception()
is 
tmp int :=0;
begin
tmp := tmp+'1oo';
exception
   when invalid_number then 
    begin
        tmp := tmp/0;
    exception
        when zero_divide then 
            dbe_output.print_line(SQL_ERR_CODE||' error '||SQL_ERR_MSG);
            raise;
    end;
    dbe_output.print_line(SQL_ERR_CODE||' error '||SQL_ERR_MSG);
end;
/
call p1_test_nested_exception();

--New add 7 test THROW_EXCEPTION
drop table if exists ww;
drop table if exists wt;
create table ww (id int,name varchar(50),age int);
insert into ww values(1,'xi',20);
insert into ww values(2,'xw',22);
create table wt as select * from ww;
create or replace trigger f before update on ww  for each row as
wrong_error exception;
errno  number;
errmsg varchar2(30);
begin
    BEGIN
    if updating('name') then
        errno  := '-20030';
        errmsg := 'cannot update this column';
        raise wrong_error;
    end if;
    exception
        when wrong_error then
            THROW_EXCEPTION(errno,errmsg);
    END;
 exception 
 when others then
    dbe_output.print_line(SQL_ERR_CODE||' error '||SQL_ERR_MSG);
 end;
 /
 update ww set name='ss' where id =1;
 
 --New add 8 test cannotmatch builtin exception
declare
  tmp int :=1;
begin
    begin
        begin
        tmp := tmp/0;
        exception --stack[1]
        when invalid_number then
            dbe_output.print_line(SQL_ERR_CODE||' ** error1 **'||SQL_ERR_MSG);
        end;
    end;
exception
    when others then
    dbe_output.print_line('past_due  '||SQL_ERR_CODE||' ** error2 **'||SQL_ERR_MSG);
end;
/

 --New add 9 test cannnot match user define exception
 declare
    past_due     EXCEPTION;
    tmp int :=1;
begin
    begin
        begin
        raise past_due;
        exception --stack[1]
        when invalid_number then
            dbe_output.print_line(SQL_ERR_CODE||' ** error1 **'||SQL_ERR_MSG);
        end;
    end;
exception
    when past_due then
    dbe_output.print_line('past_due  '||SQL_ERR_CODE||' ** error2 **'||SQL_ERR_MSG);
end;
/

--New add 10 test SQL_ERR_CODE nested in sql statement
declare
    o_var  varchar(100);
    o_int  int;
    tmp int := 0;
begin
    tmp := tmp/0;
exception
    when others then 
    select SQL_ERR_CODE() into o_int from dual;
    select SQL_ERR_MSG() into o_var from dual;
    dbe_output.print_line('error_code='||o_int||' ,error_message='||o_var);
end;
/

--test exception cannnot be used in loop
--begin
--expect error
create or replace procedure proc_exception_in_loop1()
is
a int  := 1;
b int  := 0;
c int  := 1;
begin
    LOOP     
		 c := c +1;
      a := a/b;
     exit when c > 3;
         
     EXCEPTION 
        WHEN OTHERS THEN 
            null;
     END LOOP; 
END;
/

--expect error
create or replace procedure proc_exception_in_loop2()
is
a int  := 1;
b int  := 0;
c int  := 1;
begin  
  begin
    LOOP
		 c := c +1;
      a := a/b;
     exit when c > 3;
         
     EXCEPTION 
        WHEN OTHERS THEN 
            null;
     END LOOP; 
EXCEPTION 
	WHEN OTHERS THEN 
    null;   
END;
/
--end

begin 
DBE_TASK.SUSPEND(1006,true%%sysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatedatesyssdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatedatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatessdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatedatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatessdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatedatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesyatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesystesysdaysdatesyatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesystesysdasyatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesystesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesdatesysdatesystesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdateatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesystesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesysdatesystesysdatesysdatesysdate); 
end;
/

set serveroutput off;