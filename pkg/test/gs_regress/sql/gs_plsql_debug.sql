set serveroutput on;

create or replace function test_for_loop_f return boolean is
  FunctionResult boolean;
  test_num       NUMBER;
  /*
  abc
  */
begin
  test_num := 0;
  <<loop_label>>
  FOR i IN 1..10 LOOP
  /*
  abc
  */
    test_num := test_num + 1;
    CONTINUE loop_label when i > 7;
    test_num := test_num + 1;
    CONTINUE;
    test_num := test_num + 1;
  END LOOP;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
  /*
  abc
  */
  return(FunctionResult);
exception
  when others then
  /*
  abc
  */
    SYS.dbe_output.print_line('other error');
    return(FunctionResult);
end;
/

create or replace procedure test_for_loop_p is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 0;
  FOR i IN 1..10 LOOP
    test_num := test_num + 1;
    CONTINUE when i > 7;
    test_num := test_num + 1;
    CONTINUE;
    test_num := test_num + 1;
  END LOOP;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
exception
  when others then
    SYS.dbe_output.print_line('other error');
end;
/

create or replace function test_while_loop_f return boolean is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 5;
  WHILE test_num > 1 LOOP
    test_num := test_num - 1;
    test_num := test_num - 1;
    CONTINUE;
    test_num := test_num - 1;
  END LOOP;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
  return(FunctionResult);
exception
  when others then
    SYS.dbe_output.print_line('other error');
    return(FunctionResult);
end;
/

create or replace procedure test_while_loop_p is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 5;
  WHILE test_num = 0 LOOP
    test_num := test_num - 1;
    test_num := test_num - 1;
    CONTINUE;
    test_num := test_num - 1;
  END LOOP;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
exception
  when others then
    SYS.dbe_output.print_line('other error');
end;
/

create or replace function test_loop_f return boolean is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 5;
  LOOP
    EXIT;
	test_num := 7;
  END LOOP;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
  return(FunctionResult);
exception
  when others then
    SYS.dbe_output.print_line('other error');
    return(FunctionResult);
end;
/

create or replace procedure test_loop_p is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 5;
  LOOP
    GOTO goto_label;
	test_num := 7;
  END LOOP;
  dbe_output.print_line(test_num);
  <<goto_label>>
  FunctionResult := TRUE;
exception
  when others then
    SYS.dbe_output.print_line('other error');
end;
/

create or replace function test_if_else_f return boolean is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 18;
  IF test_num = 17 THEN
    FunctionResult := TRUE;
  ELSIF test_num = 18 THEN
    FunctionResult := FALSE;
  ELSE
    FunctionResult := FALSE;
  END IF;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
  return(FunctionResult);
exception
  when others then
    SYS.dbe_output.print_line('other error');
    return(FunctionResult);
end;
/

create or replace procedure test_if_else_p is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 19;
  IF test_num = 17 THEN
    FunctionResult := TRUE;
  ELSIF test_num = 18 THEN
    FunctionResult := FALSE;
  ELSE
    FunctionResult := FALSE;
  END IF;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
exception
  when others then
    SYS.dbe_output.print_line('other error');
end;
/

create or replace function test_case_f return boolean is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 19;
  CASE test_num
  WHEN 19 THEN
    FunctionResult := FALSE;
  WHEN 20 THEN
    FunctionResult := FALSE;
  END CASE;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
  return(FunctionResult);
exception
  when others then
    SYS.dbe_output.print_line('other error');
    return(FunctionResult);
end;
/

create or replace procedure test_case_p is
  FunctionResult boolean;
  test_num       NUMBER;
begin
  test_num := 20;
  CASE test_num
  WHEN 19 THEN
    FunctionResult := FALSE;
  WHEN 20 THEN
    FunctionResult := FALSE;
  END CASE;
  dbe_output.print_line(test_num);
  FunctionResult := TRUE;
exception
  when others then
    SYS.dbe_output.print_line('other error');
end;
/

create or replace procedure test_level_3_p is
v1 int;
begin
  v1 := 1;
end;
/

create or replace procedure test_level_2_p is
begin
  test_level_3_p();
end;
/

create or replace procedure test_level_1_p is
begin
  test_level_2_p();
end;
/

drop user if exists gs_plsql_cover cascade;
create user gs_plsql_cover identified by Abc123456;
grant dba to gs_plsql_cover;
drop user if exists gs_plsql_cover2 cascade;
create user gs_plsql_cover2 identified by Abc123456;
grant dba to gs_plsql_cover2;
drop user if exists gs_plsql_cover3 cascade;
create user gs_plsql_cover3 identified by Abc123456;
grant create session to gs_plsql_cover3;
grant EXECUTE on test_for_loop_f to gs_plsql_cover;
grant EXECUTE on test_for_loop_p to gs_plsql_cover;
grant EXECUTE on test_while_loop_f to gs_plsql_cover;
grant EXECUTE on test_while_loop_p to gs_plsql_cover;
grant EXECUTE on test_loop_f to gs_plsql_cover;
grant EXECUTE on test_loop_p to gs_plsql_cover;
grant EXECUTE on test_if_else_f to gs_plsql_cover;
grant EXECUTE on test_if_else_p to gs_plsql_cover;
grant EXECUTE on test_case_f to gs_plsql_cover;
grant EXECUTE on test_case_p to gs_plsql_cover;
grant EXECUTE on test_level_1_p to gs_plsql_cover;
grant EXECUTE on test_level_2_p to gs_plsql_cover;
grant EXECUTE on test_level_3_p to gs_plsql_cover;
conn gs_plsql_cover/Abc123456@127.0.0.1:1611


drop table if exists test_sql_t;
create table test_sql_t(a int, b number(2), c varchar(20));
create or replace procedure test_sql_p is
sql_str varchar(80);
v1 int;
begin
  delete test_sql_t;
  insert into test_sql_t(a,b,c)
    values(1, 2, '3');
  sql_str := 'insert into test_sql_t(a,b,c) values(4, 15, ''16'')';
  execute immediate sql_str;
  select a into v1 
  from test_sql_t 
  where b = 5;
exception
  when no_data_found then
    SYS.dbe_output.print_line('not found error');
  when others then
    SYS.dbe_output.print_line('other error');
end;
/

create or replace trigger test_trigger after delete on test_sql_t
begin
  insert into test_sql_t(a,b,c) values(9, 20, '30');
  return;
  insert into test_sql_t(a,b,c) values(10, 30, '100');
end;
/

drop table if exists test_func_in_dml_t;
create table test_func_in_dml_t(a int);
insert into test_func_in_dml_t(a) values(10);
commit;
create or replace function test_func_in_dml_f(p1 int) return int is
begin
  return p1;
end;
/

select * from table(dba_proc_line('SYS', 'TEST_FOR_LOOP_F'));
select * from table(dba_proc_decode('SYS', 'TEST_FOR_LOOP_F', 'FUNCTION'));
select * from table(dba_proc_line('SYS', 'TEST_FOR_LOOP_P'));
select * from table(dba_proc_decode('SYS', 'TEST_FOR_LOOP_P', 'PROCEDURE'));
select * from table(dba_proc_line('SYS', 'TEST_WHILE_LOOP_F'));
select * from table(dba_proc_decode('SYS', 'TEST_WHILE_LOOP_F', 'FUNCTION'));
select * from table(dba_proc_line('SYS', 'TEST_WHILE_LOOP_P'));
select * from table(dba_proc_decode('SYS', 'TEST_WHILE_LOOP_P', 'PROCEDURE'));
select * from table(dba_proc_line('SYS', 'TEST_LOOP_F'));
select * from table(dba_proc_decode('SYS', 'TEST_LOOP_F', 'FUNCTION'));
select * from table(dba_proc_line('SYS', 'TEST_LOOP_P'));
select * from table(dba_proc_decode('SYS', 'TEST_LOOP_P', 'PROCEDURE'));
select * from table(dba_proc_line('SYS', 'TEST_IF_ELSE_F'));
select * from table(dba_proc_decode('SYS', 'TEST_IF_ELSE_F', 'FUNCTION'));
select * from table(dba_proc_line('SYS', 'TEST_IF_ELSE_P'));
select * from table(dba_proc_decode('SYS', 'TEST_IF_ELSE_P', 'PROCEDURE'));
select * from table(dba_proc_line('SYS', 'TEST_CASE_F'));
select * from table(dba_proc_decode('SYS', 'TEST_CASE_F', 'FUNCTION'));
select * from table(dba_proc_line('SYS', 'TEST_CASE_P'));
select * from table(dba_proc_decode('SYS', 'TEST_CASE_P', 'PROCEDURE'));
select * from table(dba_proc_line('GS_PLSQL_COVER', 'TEST_SQL_P'));
select * from table(dba_proc_decode('GS_PLSQL_COVER', 'TEST_SQL_P', 'PROCEDURE'));
select * from table(dba_proc_line('SYS', 'TEST_LEVEL_1_P'));
select * from table(dba_proc_decode('SYS', 'TEST_LEVEL_1_P', 'PROCEDURE'));
select * from table(dba_proc_line('GS_PLSQL_COVER', 'TEST_TRIGGER'));
select * from table(dba_proc_decode('GS_PLSQL_COVER', 'TEST_TRIGGER', 'TRIGGER'));
select * from table(dba_proc_line('GS_PLSQL_COVER', 'TEST_FUNC_IN_DML_F'));
select * from table(dba_proc_decode('GS_PLSQL_COVER', 'TEST_FUNC_IN_DML_F', 'FUNCTION'));

select * from table(dba_analyze_table('GS_PLSQL_COVER', 'TEST_FUNC_IN_DML_T'));
select * from table(dba_analyze_table('GS_PLSQL_COVER', ''));

select * from table(DBA_PROC_LINE('SYS','procedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzz'));

select * from table(DBA_PROC_LINE('SYS','procedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzzprocedure_for_fuzz'));

conn gs_plsql_cover2/Abc123456@127.0.0.1:1611
select * from table(dba_analyze_table('GS_PLSQL_COVER', 'TEST_FUNC_IN_DML_T'));
conn gs_plsql_cover3/Abc123456@127.0.0.1:1611
select * from table(dba_analyze_table('GS_PLSQL_COVER', 'TEST_FUNC_IN_DML_T'));


conn sys/Huawei@123@127.0.0.1:1611

select * from table(dba_proc_line('SYS', 'TEST_FOR_LOOP_F'));
select * from table(dba_proc_decode('SYS', 'TEST_FOR_LOOP_F', 'FUNCTION'));
select * from table(dba_proc_line('SYS', 'TEST_FOR_LOOP_P'));
select * from table(dba_proc_decode('SYS', 'TEST_FOR_LOOP_P', 'PROCEDURE'));
select * from table(dba_proc_line('SYS', 'TEST_WHILE_LOOP_F'));
select * from table(dba_proc_decode('SYS', 'TEST_WHILE_LOOP_F', 'FUNCTION'));
select * from table(dba_proc_line('SYS', 'TEST_WHILE_LOOP_P'));
select * from table(dba_proc_decode('SYS', 'TEST_WHILE_LOOP_P', 'PROCEDURE'));
select * from table(dba_proc_line('SYS', 'TEST_LOOP_F'));
select * from table(dba_proc_decode('SYS', 'TEST_LOOP_F', 'FUNCTION'));
select * from table(dba_proc_line('SYS', 'TEST_LOOP_P'));
select * from table(dba_proc_decode('SYS', 'TEST_LOOP_P', 'PROCEDURE'));
select * from table(dba_proc_line('SYS', 'TEST_IF_ELSE_F'));
select * from table(dba_proc_decode('SYS', 'TEST_IF_ELSE_F', 'FUNCTION'));
select * from table(dba_proc_line('SYS', 'TEST_IF_ELSE_P'));
select * from table(dba_proc_decode('SYS', 'TEST_IF_ELSE_P', 'PROCEDURE'));
select * from table(dba_proc_line('SYS', 'TEST_CASE_F'));
select * from table(dba_proc_decode('SYS', 'TEST_CASE_F', 'FUNCTION'));
select * from table(dba_proc_line('SYS', 'TEST_CASE_P'));
select * from table(dba_proc_decode('SYS', 'TEST_CASE_P', 'PROCEDURE'));
select * from table(dba_proc_line('GS_PLSQL_COVER', 'TEST_SQL_P'));
select * from table(dba_proc_decode('GS_PLSQL_COVER', 'TEST_SQL_P', 'PROCEDURE'));
select * from table(dba_proc_line('SYS', 'TEST_LEVEL_1_P'));
select * from table(dba_proc_decode('SYS', 'TEST_LEVEL_1_P', 'PROCEDURE'));
select * from table(dba_proc_line('GS_PLSQL_COVER', 'TEST_TRIGGER'));
select * from table(dba_proc_decode('GS_PLSQL_COVER', 'TEST_TRIGGER', 'TRIGGER'));
select * from table(dba_proc_line('GS_PLSQL_COVER', 'TEST_FUNC_IN_DML_F'));
select * from table(dba_proc_decode('GS_PLSQL_COVER', 'TEST_FUNC_IN_DML_F', 'FUNCTION'));

drop user gs_plsql_cover cascade;
drop user gs_plsql_cover2 cascade;
drop user gs_plsql_cover3 cascade;

drop user if exists gs_plsql_cover cascade;
create user gs_plsql_cover identified by Abc123456;
grant dba to gs_plsql_cover;
drop user if exists gs_plsql_cover2 cascade;
create user gs_plsql_cover2 identified by Abc123456;
grant dba to gs_plsql_cover2;
drop user if exists gs_plsql_cover3 cascade;
create user gs_plsql_cover3 identified by Abc123456;
grant create session to gs_plsql_cover3;
conn gs_plsql_cover2/Abc123456@127.0.0.1:1611
create or replace procedure gs_plsql_cover2_p is
  test_num       NUMBER;
begin
  test_num := 5;
end;
/
conn gs_plsql_cover/Abc123456@127.0.0.1:1611
select * from table(dba_proc_line(upper('gs_plsql_cover2'), upper('gs_plsql_cover2_p')));
select * from table(dba_proc_decode(upper('gs_plsql_cover2'), upper('gs_plsql_cover2_p'), 'PROCEDURE'));
conn gs_plsql_cover2/Abc123456@127.0.0.1:1611
select * from table(dba_proc_line(upper('gs_plsql_cover2'), upper('gs_plsql_cover2_p')));
select * from table(dba_proc_decode(upper('gs_plsql_cover2'), upper('gs_plsql_cover2_p'), 'PROCEDURE'));
conn gs_plsql_cover3/Abc123456@127.0.0.1:1611
select * from table(dba_proc_line(upper('gs_plsql_cover2'), upper('gs_plsql_cover2_p')));
select * from table(dba_proc_decode(upper('gs_plsql_cover2'), upper('gs_plsql_cover2_p'), 'PROCEDURE'));
conn sys/Huawei@123@127.0.0.1:1611
select * from table(dba_proc_line(upper('gs_plsql_cover2'), upper('gs_plsql_cover2_p')));
select * from table(dba_proc_decode(upper('gs_plsql_cover2'), upper('gs_plsql_cover2_p'), 'PROCEDURE'));

drop user gs_plsql_cover cascade;
drop user gs_plsql_cover2 cascade;
drop user gs_plsql_cover3 cascade;

-- test prepare start
create or replace function is_target_session_init(id out int) return boolean is
begin
  execute immediate 'select id from target_session_id_t where id != -1' into id;
  return true;
exception
  when others then
    return false;
end;
/

declare
se_id int;
begin
  for i in 1..100000 loop
    if is_target_session_init(se_id) then
      dbe_debug.attach(se_id, 9);
	  execute immediate 'insert into target_session_id_t values(0)';
	  exit;
    end if;
  end loop;
end;
/

begin
  dbe_debug.attach(64, 9);
exception
  when others then
    dbe_output.print_line(SQL_ERR_CODE || ' error ');
end;
/

create or replace PROCEDURE get_target_waiting() is
begin
  for i in 1..1000000000 loop
    if dbe_debug.get_status() = 2 then
	  exit;
    end if;
  end loop;
end;
/

create or replace PROCEDURE get_target_waiting_or_idle() is
begin
  for i in 1..1000000000 loop
    if dbe_debug.get_status() = 2 then
	  exit;
    end if;
    if dbe_debug.get_status() = 0 then
	  exit;
    end if;
  end loop;
end;
/

create or replace PROCEDURE get_target_executing() is
begin
  for i in 1..1000000000 loop
    if dbe_debug.get_status() = 1 then
	  exit;
    end if;
  end loop;
end;
/

call get_target_waiting();
call dbe_debug.resume(4, 0);
-- test prepare end

-- test step1 start
call get_target_waiting();
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
select dbe_debug.get_value(1,0,0,0) from dual;
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(3));
select * from table(dbg_show_values(2));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(2));
select * from table(dbg_show_values(10));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(6, 0);
-- test step1 end

-- test step2 start
call get_target_waiting();
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(4, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(5, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(2, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(3, 100);

select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(6, 0);
-- test step2 end

-- test step3 start
call get_target_waiting();
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);

select * from table(dbg_show_values(0));
call dbe_debug.set_value(1,0,0,0,'a');
call dbe_debug.set_value(1,0,0,0,'2019-2');
call dbe_debug.set_value(1,0,0,0,'1.0');
select dbe_debug.get_value(1,0,0,0) from dual;
call dbe_debug.set_value(1,0,1,0,'0xff');
call dbe_debug.set_value(1,0,1,0,'2.85');
select dbe_debug.get_value(1,0,1,0) from dual;
call dbe_debug.set_value(1,0,2,0,'abcdefghijk');
select dbe_debug.get_value(1,0,2,0) from dual;
call dbe_debug.set_value(1,0,3,0,'debug');
select dbe_debug.get_value(1,0,3,0) from dual;
call dbe_debug.set_value(1,0,4,0,'2019-01-01 00:00:00');
select dbe_debug.get_value(1,0,4,0) from dual;
call dbe_debug.set_value(1,0,5,0,'36.9');
select dbe_debug.get_value(1,0,5,0) from dual;
call dbe_debug.resume(0, 100);
select * from table(dbg_show_values(0));
call dbe_debug.resume(1, 100);
call dbe_debug.resume(1, 100);
call dbe_debug.resume(1, 100);
call dbe_debug.resume(1, 100);
call dbe_debug.resume(1, 100);
call dbe_debug.resume(1, 100);
call dbe_debug.set_value(2,0,1,1,'2');
select dbe_debug.get_value(2,0,1,1) from dual;
call dbe_debug.set_value(2,0,1,2,'2.5');
select dbe_debug.get_value(2,0,1,2) from dual;
call dbe_debug.set_value(2,0,1,3,'0xabcd');
select dbe_debug.get_value(2,0,1,3) from dual;
call dbe_debug.set_value(2,0,1,4,'kssss');
select dbe_debug.get_value(2,0,1,4) from dual;
call dbe_debug.set_value(2,0,1,5,'2019-01-01 00:00:00');
select dbe_debug.get_value(2,0,1,5) from dual;
call dbe_debug.set_value(2,0,1,6,'36.9');
select dbe_debug.get_value(2,0,1,6) from dual;
call dbe_debug.resume(4, 0);
-- test step3 end

-- test step4 start
call get_target_waiting();

select * from table(dba_proc_decode('SYS', 'TEST_BREAK_LV3_FUNC1', 'FUNCTION'));
select * from table(dba_proc_decode('SYS', 'TEST_BREAK_LV2_FUNC1', 'FUNCTION'));
select * from table(dba_proc_decode('SYS', 'TEST_BREAK_LV1_FUNC1', 'FUNCTION'));
select * from table(dba_proc_decode('SYS', 'TEST_BREAK_LVX_TRIGGER1', 'TRIGGER'));
select * from table(dba_proc_decode('SYS', 'TEST_BREAK_LV1_PROC1', 'PROCEDURE'));


select dbe_debug.add_break('SYS','TEST_BREAK_LV3_FUNC1','FUNCTION',4,0,'ef') as break_id from dual;   --break point 1
select dbe_debug.add_break('SYS','TEST_BREAK_LV2_FUNC1','FUNCTION',4,0,'ef') as break_id from dual;   --break point 2
select dbe_debug.add_break('SYS','TEST_BREAK_LV2_FUNC1','FUNCTION',5,0,'ef') as break_id from dual;   --break point 3
 --test delete break
select dbe_debug.add_break('SYS','TEST_BREAK_LV2_FUNC1','FUNCTION',6,0,'ef') as break_id from dual;  
call dbe_debug.delete_break(4);   --test delete break
--expect return error start
select dbe_debug.add_break('SYS','TEST_BREAK_LV2_FUNC1','FUNCTION',5,0) as break_id from dual;
select dbe_debug.add_break('SYS','TEST_BREAK_LV2_FUNC1','FUNCTION',6.5,0,'ef') as break_id from dual;
select dbe_debug.add_break('SYS','TEST_BREAK_LV2_FUNC1','FUNCTION','6',0,'ef') as break_id from dual;
select dbe_debug.add_break('SYS','TEST_BREAK_LV2_FUNC1','FUNCTION',5,NULL,'ef') as break_id from dual;
select dbe_debug.add_break('SYS','TEST_BREAK_LV2_FUNC1','FUNCTION',5,0,"ef") as break_id from dual;
select dbe_debug.add_break('SYS','TEST_BREAK_LV2_FUNC11','FUNCTION',5,0,'ef') as break_id from dual;
select dbe_debug.add_break('fc','TEST_BREAK_LV2_FUNC1','FUNCTION',5,0,'ef') as break_id from dual;
select dbe_debug.add_break('SYS','TEST_BREAK_LV2_FUNC1','FUNCTION',-1,0,'ef') as break_id from dual;
select dbe_debug.add_break('SYS','TEST_BREAK_LV2_FUNC1','FUNCTION',10,0,'ef') as break_id from dual;

call dbe_debug.delete_break();
call dbe_debug.delete_break('5');
call dbe_debug.delete_break(-5);
call dbe_debug.delete_break(NULL);
call dbe_debug.delete_break(10);
call dbe_debug.delete_break(7);

call dbe_debug.set_curr_count();
call dbe_debug.set_curr_count(10);
call dbe_debug.set_curr_count(10,1);
call dbe_debug.set_curr_count('10');
call dbe_debug.set_curr_count(NULL);
call dbe_debug.set_curr_count(-1);
call dbe_debug.set_curr_count(0);

call dbe_debug.set_break(9);
call dbe_debug.set_break('9', 0);
call dbe_debug.set_break(-9, 0);
call dbe_debug.set_break(9, 2);
call dbe_debug.set_break(9, -1);
call dbe_debug.set_break(9, '0');
call dbe_debug.set_break(9, NULL);
call dbe_debug.set_break(100, 0);
call dbe_debug.set_break(9.2, 0);
call dbe_debug.set_break(7, 0);
call dbe_debug.update_break(7, 3);
--expect return error end

select dbe_debug.add_break('SYS','TEST_BREAK_LV1_FUNC1','FUNCTION',3,0,'ef') as break_id from dual;   --break point 4
select dbe_debug.add_break('SYS','TEST_BREAK_LVX_TRIGGER1','TRIGGER',4,0,'ef') as break_id from dual;   --break point 5
select dbe_debug.add_break('SYS','TEST_BREAK_LVX_TRIGGER1','TRIGGER',5,0,'ef') as break_id from dual;   --break point 6
select dbe_debug.add_break('SYS','TEST_BREAK_LV1_PROC1','PROCEDURE',3,0,'ef') as break_id from dual;   --break point 7
select dbe_debug.add_break('SYS','TEST_BREAK_LV1_PROC1','PROCEDURE',4,0,'ef') as break_id from dual;   --break point 8
--test set_break
call dbe_debug.set_break(8, 0);


select * from table(dbg_break_info(1));
select * from table(dbg_break_info(2));
select * from table(dbg_break_info(3));
select * from table(dbg_break_info(4));
select * from table(dbg_break_info(5));
select * from table(dbg_break_info(6));
select * from table(dbg_break_info(7));
select * from table(dbg_break_info(8));

call dbe_debug.resume(5, 0);

call get_target_waiting();
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(5, 0);

call get_target_waiting();
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(5, 0);

call get_target_waiting();
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));

select dbe_debug.add_break('SYS','TEST_BREAK_LV3_FUNC1','FUNCTION',5,0,'ef') as break_id from dual;   --break point 9
--test break point exceed the max count of break points  max count is 9
select dbe_debug.add_break('SYS','TEST_BREAK_LV1_PROC1','PROCEDURE',4,0,'ef') as break_id from dual;   --break point 10
select * from table(dbg_break_info(9));

call dbe_debug.resume(5, 0);

call get_target_waiting();
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(5, 0);

call get_target_waiting();
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(5, 0);

call get_target_waiting();
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(5, 0);

call get_target_waiting();
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(5, 0);

call get_target_waiting();
select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
select * from table(dbg_show_values(0));
call dbe_debug.resume(5, 0);
-- test step4 end

call get_target_waiting_or_idle();
--test param of detach is not 1 or 0,expect throw error
call dbe_debug.detach(2); 
call dbe_debug.detach(1);

--test debug function when it is called by normal session  expect return error
declare
  break_num integer;
begin
  select dbe_debug.add_break('SYS','TEST_BREAK_LV3_FUNC1','FUNCTION',4,0,'ef') into break_num from dual;
  dbe_output.print_line('can call add_break when session type is normal session');
exception
  when others then
    dbe_output.print_line('can not call add_break when session type is normal session');
end;
/

declare
  cursor_ret SYS_REFCURSOR;
begin
  OPEN cursor_ret for select * from table(dbg_break_info(1));
  dbe_output.print_line('can call dbg_break_info when session type is normal session');
exception
  when others then
    dbe_output.print_line('can not call dbg_break_info when session type is normal session');
end;
/

declare
begin
  execute immediate 'call dbe_debug.delete_break(5)';
  dbe_output.print_line('can call delete_break when session type is normal session');
exception
  when others then
    dbe_output.print_line('can not call delete_break when session type is normal session');
end;
/

declare
begin
  execute immediate 'call dbe_debug.set_break(9, 0)';
  dbe_output.print_line('can call set_break when session type is normal session');
exception
  when others then
    dbe_output.print_line('can not call set_break when session type is normal session');
end;
/

declare
begin
  execute immediate 'call dbe_debug.resume(5, 0)';
  dbe_output.print_line('can call resume when session type is normal session');
exception
  when others then
    dbe_output.print_line('can not call resume when session type is normal session');
end;
/

declare
  cursor_ret SYS_REFCURSOR;
begin
  OPEN cursor_ret for select STACK_ID,OWNER,OBJECT,LOC_LINE,LINE_TYPE from table(dbg_proc_callstack(0));
  dbe_output.print_line('can call dbg_proc_callstack when session type is normal session');
exception
  when others then
    dbe_output.print_line('can not call dbg_proc_callstack when session type is normal session');
end;
/

declare
  cursor_ret SYS_REFCURSOR;
begin
  OPEN cursor_ret for select * from table(dbg_show_values(0));
  dbe_output.print_line('can call dbg_show_values when session type is normal session');
exception
  when others then
    dbe_output.print_line('can not call dbg_show_values when session type is normal session');
end;
/

declare
begin
  execute immediate 'call dbe_debug.detach(1)';
  dbe_output.print_line('can call detach when session type is normal session');
exception
  when others then
    dbe_output.print_line('can not call detach when session type is normal session');
end;
/

declare
begin
  execute immediate 'call dbe_debug.terminate()';
  dbe_output.print_line('can call terminate when session type is normal session');
exception
  when others then
    dbe_output.print_line('can not call terminate when session type is normal session');
end;
/

declare
begin
  execute immediate 'call dbe_debug.pause()';
  dbe_output.print_line('can call pause when session type is normal session');
exception
  when others then
    dbe_output.print_line('can not call pause when session type is normal session');
end;
/

declare
  status integer;
begin
  select dbe_debug.get_status() into status from dual;
  dbe_output.print_line('can call get_status when session type is normal session');
exception
  when others then
    dbe_output.print_line('can not call get_status when session type is normal session');
end;
/

-----plsql int->char ------
drop table if exists table1;
create table table1 (c1 char(30));
create or replace procedure p1(f1 char)
as
begin 
insert into table1(c1) values(f1);
end;
/

exec p1(1);

exec p1(true);

exec p1(TO_TIMESTAMP('2018-06-28 13:14:15', 'YYYY-MM-DD HH24:MI:SS:FF'));

exec p1(1111111111111111111111111111111111111111111);

select * from table1;

create or replace function test_out_param_func(p1 in out char) return char
is
begin
  dbe_output.print_line(length(p1));
  return p1;
end;
/

DECLARE
  v1 int := 321;
  v2 int := 4563;
BEGIN
  dbe_output.print_line(test_out_param_func(v1) || test_out_param_func(v2));
END;
/

set serveroutput off;