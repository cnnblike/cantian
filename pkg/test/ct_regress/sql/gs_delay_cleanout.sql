alter system set delay_cleanout = true;
drop table if exists delay_clean_test_table;
create table delay_clean_test_table(c_id int , c_char varchar2(8000), c_char1 varchar2(8000),c_char2 varchar2(8000), c_char3 varchar2(8000));
declare
i integer;
varchar2_str varchar(8000);
sql_str varchar(9000);
begin
varchar2_str := lpad(' ', 7000, 'a');
sql_str := 'insert into delay_clean_test_table values(2,'''||varchar2_str||''', null, null, null)';
for i in 1 .. 16000 loop
execute immediate sql_str;
end loop;
commit;
end;
/
commit;
SELECT * FROM DBA_SEGMENTS WHERE SEGMENT_TYPE='TABLE' AND SEGMENT_NAME ='DELAY_CLEAN_TEST_TABLE';
delete from delay_clean_test_table;
commit;
SELECT * FROM DBA_SEGMENTS WHERE SEGMENT_TYPE='TABLE' AND SEGMENT_NAME ='DELAY_CLEAN_TEST_TABLE';
declare
i integer;
varchar2_str varchar(8000);
sql_str varchar(9000);
begin
varchar2_str := lpad(' ', 7000, 'a');
sql_str := 'insert into delay_clean_test_table values(2,'''||varchar2_str||''', null, null, null)';
for i in 1 .. 8000 loop
execute immediate sql_str;
end loop;
commit;
end;
/
commit;
SELECT * FROM DBA_SEGMENTS WHERE SEGMENT_TYPE='TABLE' AND SEGMENT_NAME ='DELAY_CLEAN_TEST_TABLE';
alter system set delay_cleanout = false;
delete from delay_clean_test_table;
SELECT * FROM DBA_SEGMENTS WHERE SEGMENT_TYPE='TABLE' AND SEGMENT_NAME ='DELAY_CLEAN_TEST_TABLE';
declare
i integer;
varchar2_str varchar(8000);
sql_str varchar(9000);
begin
varchar2_str := lpad(' ', 7000, 'a');
sql_str := 'insert into delay_clean_test_table values(2,'''||varchar2_str||''', null, null, null)';
for i in 1 .. 8000 loop
execute immediate sql_str;
end loop;
commit;
end;
/
commit;
SELECT * FROM DBA_SEGMENTS WHERE SEGMENT_TYPE='TABLE' AND SEGMENT_NAME ='DELAY_CLEAN_TEST_TABLE';
declare
i integer;
varchar2_str varchar(8000);
sql_str varchar(9000);
begin
varchar2_str := lpad(' ', 7000, 'a');
sql_str := 'insert into delay_clean_test_table values(2,'''||varchar2_str||''', null, null, null)';
for i in 1 .. 8000 loop
execute immediate sql_str;
end loop;
commit;
end;
/
commit;
SELECT * FROM DBA_SEGMENTS WHERE SEGMENT_TYPE='TABLE' AND SEGMENT_NAME ='DELAY_CLEAN_TEST_TABLE';
declare
i integer;
varchar2_str varchar(8000);
sql_str varchar(9000);
begin
varchar2_str := lpad(' ', 7000, 'a');
sql_str := 'insert into delay_clean_test_table values(2,'''||varchar2_str||''', null, null, null)';
for i in 1 .. 8000 loop
execute immediate sql_str;
end loop;
commit;
end;
/
commit;
SELECT * FROM DBA_SEGMENTS WHERE SEGMENT_TYPE='TABLE' AND SEGMENT_NAME ='DELAY_CLEAN_TEST_TABLE';
drop table if exists delay_clean_test_table;
alter system set delay_cleanout = true;