--oracle cat result cannot be too long
declare
  pad_str varchar(8000);
begin
  pad_str := 'sdhsjhdjafndskdjskfjndmfdjfkdgnfdsldfkjdkfdsngfdksfjdsifnvdmfbdksfhjdksfghjsfndjdffsgsfdsfdvdfsdfvdccsdfgfhgfjyjggfdghhsfddsgfhfgdfgfdgsdferweytruyiuiuhtehgfdfsfdewrtweytjhfg';
  pad_str := pad_str || pad_str || pad_str || pad_str;
  pad_str := pad_str || pad_str || pad_str || pad_str;
  execute immediate 'SELECT * FROM JSON_TABLE(''{"type" : "1", "number" : "2"}'', ''$'' default 1 on error COLUMNS (type varchar2 PATH ''$.' || pad_str || pad_str || pad_str || pad_str || pad_str || pad_str || '''))';
end;
/
drop table if exists temp_json_table_long;
create table temp_json_table_long(f1 int, f2 clob);
insert into temp_json_table_long values(1, '''{"type" : "1' || lpad('100',16385,'a') || '", "number" : "2"}''');
commit;
select * from temp_json_table_long a, json_table (a.f2 , '$' error on error columns (type varchar2 PATH '$.type'));
delete from temp_json_table_long;
insert into temp_json_table_long values(1, '{"type" : "1' || lpad('100',16385,'a') || '", "number" : "2"}');
commit;
select * from temp_json_table_long a, json_table (a.f2 , '$' error on error columns (type varchar2 PATH '$.type'));
delete from temp_json_table_long;
insert into temp_json_table_long values(1, '{"type" : "1' || lpad('100',8000,'a') || lpad('100',8000,'a') || '", "number" : "2"}');
commit;
select * from temp_json_table_long a, json_table (a.f2 , '$' error on error columns (type varchar2 PATH '$.type'));
delete from temp_json_table_long;
insert into temp_json_table_long values(1, '{"type" : "1' || lpad('100',7000,'a') || '", "number" : "2"}');
commit;
select a.f1,length(b.type) from temp_json_table_long a, json_table (a.f2 , '$' error on error columns (type varchar2(8000) PATH '$.type')) b;
select a.f1,length(b.type) from temp_json_table_long a, json_table (a.f2 , '$' error on error columns (type varchar2 PATH '$.type')) b;
delete from temp_json_table_long;
insert into temp_json_table_long values(1, to_clob('{"type" : "1' || lpad('100',7000,'a') || lpad('100',7000,'a') || lpad('100',7000,'a')) || to_clob(lpad('100',7000,'a') || lpad('100',4751,'a') || '", "number" :  "2"}'));
commit;
select a.f1,length(b.type) from temp_json_table_long a, json_table (a.f2 , '$' error on error columns (type varchar2 PATH '$.number')) b;
delete from temp_json_table_long;
insert into temp_json_table_long values(1, to_clob('{"type" : "1' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') ) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')|| lpad('100',8000,'a')) || to_clob(lpad('100',7000,'a') || lpad('100',4751,'a') || '", "number" :  "2"}'));
commit;
select a.f1,length(b.type) from temp_json_table_long a, json_table (a.f2 , '$' error on error columns (type varchar2 PATH '$.number')) b;
delete from temp_json_table_long;
insert into temp_json_table_long values(1, to_clob('{"a": "' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || lpad('100',8000,'a')) || to_clob('", "b":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') ) || '"}');
commit;
select a.f1,length(b.type) from temp_json_table_long a, json_table (a.f2 , '$' error on error columns (type varchar2 PATH '$.b')) b;
select a.f1,length(b.type) from temp_json_table_long a, json_table (a.f2 , '$' error on error columns (type clob PATH '$.b')) b;
delete from temp_json_table_long;
insert into temp_json_table_long values(1, to_clob('{"a": "' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || lpad('100',8000,'a')) || to_clob('", "b":"' || lpad('100',8000,'a') || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "c":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "d":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "e":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "rf":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "f":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "j":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "u":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "j":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "m":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "i":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "l":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "g":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "n":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "g":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "q":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "t":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "o":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "v":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "p":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "w":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "r":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "af":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "s":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "ae":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "z":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "ad":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "y":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "ah":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "x":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "ag":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "aa":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "ai":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "ab":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "ac":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || '}');
commit;
select a.f1,length(b.type) from temp_json_table_long a, json_table (a.f2 , '$' error on error columns (type varchar2 PATH '$.b')) b;
select a.f1,length(b.type) from temp_json_table_long a, json_table (a.f2 , '$' error on error columns (type clob PATH '$.b')) b;
select a.f1,length(b.type) from temp_json_table_long a, json_table (a.f2 , '$' error on error columns (type clob PATH '$.ai')) b;
delete from temp_json_table_long;
insert into temp_json_table_long values(1, to_clob('[{"a": "' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || lpad('100',8000,'a')) || to_clob('", "b":"' || lpad('100',8000,'a') || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "c":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "d":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "e":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "rf":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "f":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "j":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "u":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "j":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "m":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "i":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "l":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "g":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "n":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "g":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "q":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "t":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "o":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "v":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "p":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "w":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "r":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "af":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "s":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "ae":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "z":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "ad":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "y":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "ah":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "x":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "ag":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "aa":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "ai":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "ab":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || to_clob(', "ac":"' || lpad('100',8000,'a')  || lpad('100',8000,'a')  || lpad('100',8000,'a') || '"') || '}]');
commit;
insert into temp_json_table_long select * from temp_json_table_long;
select a.f1,length(b.type) from temp_json_table_long a, json_table (a.f2 , '$' error on error columns (type clob format json PATH '$')) b;
--not supported
delete from JSON_TABLE('{"type" : "Office", "number" : "909-555-7307"}', '$' COLUMNS (type varchar2(10) exists PATH '$.type' false on error));
drop table JSON_TABLE('{"type" : "Office", "number" : "909-555-7307"}', '$' COLUMNS (type varchar2(10) exists PATH '$.type' false on error));
insert into JSON_TABLE('{"type" : "Office", "number" : "909-555-7307"}', '$' COLUMNS (type varchar2(10) exists PATH '$.type' false on error)) values ('1');
update JSON_TABLE('{"type" : "Office", "number" : "909-555-7307"}', '$' COLUMNS (type varchar2(10) exists PATH '$.type' false on error)) set type ='qqq';
create index temp001001 on JSON_TABLE('{"type" : "Office", "number" : "909-555-7307"}', '$' COLUMNS (type varchar2(10) exists PATH '$.type' false on error))( type);
--(+)
drop table if exists test_json_table;
create table test_json_table (f1 varchar(100), f2 varchar(200));
insert into test_json_table values(1, '[{"Phone" : [{"type" : "a", "number" : "909-555-7307"}, {"type" : "b", "number" : "415-555-1234"}]}, {"Phone" : [{"type" : "c", "number" : "909-555-7307"}, {"type" : "d", "number" : "415-555-1234"}]}]');
insert into test_json_table values(2, '[{"Phone" : [{"type" : "e", "number" : "909-555-7307"}, {"type" : "f", "number" : "415-555-1234"}]}, {"Phone" : [{"type" : "g", "number" : "909-555-7307"}, {"type" : "h", "number" : "415-555-1234"}]}]');
insert into test_json_table values(3, '[{"Phone" : [{"type" : "3", "number" : "909-555-7307"}, {"type" : "b", "number" : "415-555-1234"}]}, {"Phone" : [{"type" : "3", "number" : "909-555-7307"}, {"type" : "d", "number" : "415-555-1234"}]}]');
insert into test_json_table values(4, '[{"Phone" : [{"type" : "4", "number" : "909-555-7307"}, {"type" : "4", "number" : "415-555-1234"}]}, {"Phone" : [{"type" : "g", "number" : "909-555-7307"}, {"type" : "h", "number" : "415-555-1234"}]}]');
drop table if exists test_json_table2;
create table test_json_table2 (f1 varchar(100), f2 varchar(200));
insert into test_json_table2 values(1, '[{"Phone" : [{"type" : "a", "number" : "909-555-7307"}, {"type" : "b", "number" : "415-555-1234"}]}, {"Phone" : [{"type" : "c", "number" : "909-555-7307"}, {"type" : "d", "number" : "415-555-1234"}]}]');
insert into test_json_table2 values(2, null);
commit;
select a.f1 a1,b.f1 a3,type a5 from test_json_table2 a right join test_json_table2 b on a.f1=b.f1-1 join json_table(case when a.f2 is null then b.f2 else a.f2 end,'$[*].Phone[*]' error on error COLUMNS (type VARChAR2(100) PATH '$.type', num2 for ordinality )) c on b.f1(+)=c.num2;
select a.f1 a1,b.f1 a3,type a5 from test_json_table2 a right join test_json_table2 b on a.f1=b.f1-1 join json_table(case when a.f2 is null then b.f2 else a.f2 end,'$[*].Phone[*]' error on error COLUMNS (type VARChAR2(100) PATH '$.type', num2 for ordinality )) c on b.f1=c.num2(+);
select a.f1 a1,b.f1 a3 from test_json_table2 a  join test_json_table2 b on a.f1(+)=b.f1;
select a.f1 a1,b.f1 a3 from test_json_table2 a  join test_json_table2 b on a.f1=b.f1(+);
select a.f1,b.* from test_json_table a, json_table(a.f2,'$[*].Phone[*]' error on error COLUMNS (type VARChAR2(100) PATH '$.type' )) b where  a.f1(+) = b.type;
select a.f1,b.* from test_json_table c left join test_json_table a on true, json_table(a.f2,'$[*].Phone[*]' error on error COLUMNS (type VARChAR2(100) PATH '$.type' )) b where  a.f1(+) = b.type;
select a.f1,b.* from test_json_table c , test_json_table a , json_table(a.f2,'$[*].Phone[*]' error on error COLUMNS (type VARChAR2(100) PATH '$.type' )) b where a.f1(+)=c.f1 and a.f1(+) = b.type;
select a.f1,b.* from test_json_table c , test_json_table a , json_table(a.f2,'$[*].Phone[*]' error on error COLUMNS (type VARChAR2(100) PATH '$.type' )) b where a.f1=c.f1(+) and a.f1(+) = b.type;
--different with oracle
SELECT * FROM JSON_TABLE('{"type" : "1", number : "2"}', '$' default '1' on error COLUMNS (type varchar2 PATH '$.type', number2 varchar2 PATH '$.number'));
SELECT * FROM JSON_TABLE('{"type" : "Office", "number" : "909-555-7307"}', '$.type[1]' error on error COLUMNS (type varchar2(10) PATH '$' ));
SELECT * FROM JSON_TABLE('{"type" : "Office", "number" : "909-555-7307"}', '$.type[1]' null on error COLUMNS (type varchar2(10) PATH '$' ));
SELECT * FROM JSON_TABLE('{"type" : "Office", "number" : "909-555-7307"}', '$[1].type[0]' error on error COLUMNS (type varchar2(10) PATH '$' ));
SELECT type,1 FROM JSON_TABLE('{"aaa" : {"type" : "Office", "type" : "aaa"}}', '$.aaa[0].type' error on error COLUMNS (type varchar2(10) PATH '$' ));
SELECT type,1 FROM JSON_TABLE('{"aaa" : {"type" : "Office", "type" : "aaa"}}', '$.aaa[0].type' COLUMNS (type varchar2(10) PATH '$' ));
SELECT * FROM JSON_TABLE('{"aa" :  {"aaa" : 300, "aaa" : 400}}',  '$.aa.aaa' error on error COLUMNS (aaa varchar2(100) PATH '$' ));
select * from json_table('{"aa" : [{"aaa" : 300, "aaa" : 400}]}', '$.aa.aaa' error on error columns (aaa varchar2(100) path '$'));
--not supported yet
SELECT * FROM JSON_TABLE('{"name"   : "Alexis Bull", "Phone"  : [{"type" : "Office", "number" : "909-555-7307"}, {"type" : "Mobile", "number" : "415-555-1234"}]}', '$' COLUMNS (name    varchar2(20) PATH '$.name', nested path '$.Phone[*]' columns (type     varchar2(20) path '$.type', number2  varchar2(20) path '$.number', rows2 for ordinality)));
SELECT * FROM JSON_TABLE('{"type" : "Office", "number" : "909-555-7307"}', '$' COLUMNS (type varchar2(10) exists PATH '$.type' true on error,type varchar2(10) exists PATH '$.type' false on error));
SELECT * FROM JSON_TABLE('{"type" : "Office", "number" : "909-555-7307"}', '$' COLUMNS (type varchar2(10) exists PATH '$.type' true on error,type varchar2(10) exists PATH '$.type' false on error));--select * from (select dummy a, dummy a from dual);
select * from json_table('[{"a" : {"aa" : [{"aaa" : 100, "aaa" : 200}]}}, {"a" : {"aa" : [{"aaa" : 300, "aaa" : 400}]}}]', '$.a.aa.aaa' error on error columns (aaa varchar2(100) path '$'));
SELECT type,1 FROM JSON_TABLE('{"aaa" : [{"type" : "Office", "type" : "aaa"}]}', '$.aaa[0].type' COLUMNS (type varchar2(10) PATH '$' ));
SELECT type,1 FROM JSON_TABLE('{"aaa" : [{"type" : "Office", "type" : "aaa"}]}', '$.aaa.type' COLUMNS (type varchar2(10) PATH '$' ));
SELECT * FROM JSON_TABLE('{"type" : "Office", "number" : "909-555-7307", "type" : "aaa"}', '$[0]' COLUMNS (type varchar2(10) PATH '$.type' ));
SELECT * FROM JSON_TABLE('{"type" : "Office", "number" : "909-555-7307", "type" : "aaa"}', '$.type' COLUMNS (type varchar2(10) PATH '$' ));
SELECT * FROM JSON_TABLE('{"aaa" : {"type" : "Office", "number" : "909-555-7307", "type" : "aaa"}}', '$.aaa.type' COLUMNS (type varchar2(10) PATH '$' ));
SELECT * FROM JSON_TABLE('{"type" : "Office", "number" : "909-555-7307", "type" : "aaa"}', '$[*]' error on error COLUMNS (type varchar2(10) PATH '$.type' ));
SELECT * FROM JSON_TABLE('{"type" : "Office", "number" : "909-555-7307", "type" : "aaa"}', '$[*]' COLUMNS (type varchar2(10) PATH '$.type' ));
--jv_object same name
select * from json_table('[{"a" : {"aa" : {"aaa" : 100, "aaa" : 200}}}, {"a" : {"aa" : [{"aaa" : 300, "aaa" : 400}]}}]', '$.a.aa.aaa' error on error columns (aaa varchar2(100) path '$'));
select * from json_table('[{"a" : {"aa" : {"aaa" : 100, "aaa" : 200}}}, {"a" : {"aa" : [{"aaa" : 300, "aaa" : 400}]}}]', '$.a.aa' error on error columns (aaa varchar2(100) path '$.aaa'));
select * from json_table('[{"a" : {"aa" : {"aaa" : 100, "aab" : 200}}}, {"a" : {"aa" : [{"aaa" : 300, "aaa" : 400}]}}]', '$.a.aa.aaa' error on error columns (aaa varchar2(100) path '$'));
--select
select /*+rule*/ * from test_json_table a, json_table(a.f2,'$[*].Phone[*]' error on error COLUMNS (type VARChAR2(100) PATH '$.type' )) b  pivot(count(b.type) for (f1) in (1,2,3,4));
select  * from test_json_table a, json_table(a.f2,'$[*].Phone[*]' error on error COLUMNS (type VARChAR2(100) PATH '$.type' )) b limit 2;
select  * from test_json_table a, json_table(a.f2,'$[*].Phone[*]' error on error COLUMNS (type VARChAR2(100) PATH '$.type' )) b limit 0,2;
select  * from test_json_table a, json_table(a.f2,'$[*].Phone[*]' error on error COLUMNS (type VARChAR2(100) PATH '$.type' )) b limit 2 offset 2;
--transform
drop view if exists t_subselect_rs_005;
drop view if exists t_subselect_rs_006;
create view t_subselect_rs_005 as select * from  json_table('[{"Phone" : [{"number" : "909-555-7307"}]}, {"Phone" : [{"type" : "c", "number" : "909-555-7307"}, {"type" : "d", "number" : "415-555-1234"}]}]', '$[*].Phone[*]' null on error COLUMNS (t5_f1 varchar2(1000) PATH '$.type' ));
create view t_subselect_rs_006 as select * from  json_table('[{"Phone" : [{"number" : "909-555-7307"}]}, {"Phone" : [{"type" : "c", "number" : "909-555-7307"}, {"type" : "d", "number" : "415-555-1234"}]}]', '$[*].Phone[*]' null on error COLUMNS (t6_f1 varchar2(1000) PATH '$.type', t6_f2 varchar2(1000) PATH '$.number'));
select distinct t6_f1,aaa from (select distinct t6_f1, (select t5_f1 from t_subselect_rs_005 where t5_f1 > t6_f1 order by t5_f1 desc) aaa from t_subselect_rs_006 order by t6_f1 desc);
select distinct t6_f1,aaa from (select distinct t6_f1, (select t5_f1 from t_subselect_rs_005 where t5_f1 > b.t6_f1 order by t5_f1 desc) aaa from t_subselect_rs_006 b order by t6_f1 desc);
select distinct t6_f1,aaa,rownum from (select distinct t6_f1, (select t5_f1 from t_subselect_rs_005 where t5_f1 > t6_f1 ) aaa from t_subselect_rs_006 order by t6_f1%7 desc);
select (select t5_f1 from t_subselect_rs_005 where t5_f1 > t6_f1  limit 1) aaa from (select distinct t6_f1 from (select distinct t6_f1 from t_subselect_rs_006 )) t6 left join t_subselect_rs_005 t4 on t6.t6_f1 = t4.t5_f1  order by t6_f1%7 desc;
select (select t5_f1 from t_subselect_rs_005 where t5_f1 > t6_f1  limit 1) aaa from (select distinct t6_f1 from (select distinct t6_f1 from t_subselect_rs_006 )) t6 left join t_subselect_rs_005 t4 on t6.t6_f1 = t4.t5_f1;
select (select t5_f1 from t_subselect_rs_005 where t5_f1<t6_f1  and rownum=1) from t_subselect_rs_006 where t6_f1 in (select t5_f1 from t_subselect_rs_005) order by t6_f2 asc ;
SELECT * FROM t_subselect_rs_005 T4 WHERE EXISTS( SELECT t6.t6_f1, t5.t5_f1 FROM t_subselect_rs_006 t6, t_subselect_rs_005 t5
WHERE t6.t6_f2 = t5.t5_f1 AND t5.t5_f1 = t4.t5_f1 AND t6.t6_f2 < (SELECT sum(t6.t6_f2) FROM t_subselect_rs_006 t6 WHERE to_char(t6.t6_f2) = t5.t5_f1)) ;
select (select t5_f1 from t_subselect_rs_005 where t5_f1 = t5.t5_f1) from (SELECT t6.t6_f1, t6.t6_f2,t5.t5_f1
 FROM t_subselect_rs_006 t6, t_subselect_rs_005 t5
WHERE t6.t6_f1 = t5.t5_f1 AND t6.t6_f2 > (SELECT max(t6.t6_f2) FROM t_subselect_rs_006 t6 WHERE t6.t6_f1 = t5.t5_f1)) t5 inner join t_subselect_rs_005;
select (select t5_f1 from t_subselect_rs_005 where t5_f1 = t5.t5_f1) from (SELECT t6.t6_f1, t6.t6_f2,t5.t5_f1
 FROM t_subselect_rs_006 t6, t_subselect_rs_005 t5
WHERE t6.t6_f1 = t5.t5_f1 AND t6.t6_f2 < (SELECT max(t6.t6_f2) FROM t_subselect_rs_006 t6 WHERE t6.t6_f1 = t5.t5_f1)) t5 inner join t_subselect_rs_005;
--transform in to exist
select (select t5_f1 from t_subselect_rs_005 where t5_f1<t6_f1  and rownum=1) from t_subselect_rs_006 where t6_f1 in (select t5_f1 from t_subselect_rs_005) order by t6_f2 asc ;
select distinct t6_f1,aaa from (select distinct t6_f1, (select t5_f1 from t_subselect_rs_005 where t5_f1 = t6_f1) aaa from t_subselect_rs_006 order by 1);
select distinct t6_f1,aaa from (select distinct t6_f1, (select t5_f1 from t_subselect_rs_005 where t5_f1 > b.t6_f1) aaa from t_subselect_rs_006 b order by t6_f1 desc);
select distinct t6_f1,aaa,rownum from (select distinct t6_f1, (select t5_f1 from t_subselect_rs_005 where t5_f1 > t6_f1 ) aaa from t_subselect_rs_006);
--pl
create or replace procedure test_json_table_object(src_table_name in varchar)
as
    table_id int;
    sql_str varchar(2000);
    mycursor1 sys_refcursor ;
    col_name varchar(100);
    col_type varchar(30);
    datatype int;
	type_str varchar(1000) := '';
	column_str varchar(1000) := '1';
	result_str varchar(2000) := '''{';
	dst_table_name varchar(100) := 'json_' || src_table_name;
	view_str varchar(8000) := 'create view ' || src_table_name || ' as select b.* from ' || dst_table_name || ' a,json_table(a.f1 ,''$'' columns (';
begin
    --create new table
	sql_str := 'drop view if exists ' || src_table_name;
	execute immediate sql_str;
	sql_str := 'drop table if exists ' || dst_table_name;
	execute immediate sql_str;
	sql_str := 'create table ' || dst_table_name || '(f1 clob)';
	execute immediate sql_str;
    --get table id
    sql_str := 'select table_id from my_tables where table_name=upper(''' || src_table_name || ''')';
    execute immediate sql_str into table_id;
    --get column name and type
	sql_str := 'select decode(:1, 20001, ''int'', 20009, ''varchar2(8000)'', ''varchar2(8000)'') from sys_dummy';
    open mycursor1 for 'select name, datatype from sys.sys_columns where table# = :1 order by id' using table_id;
    loop
        fetch mycursor1 into col_name, datatype;
        if mycursor1%found
        then
	        execute immediate sql_str into col_type using datatype;
			type_str := type_str || col_name || ' ' || col_type || ';';
			if column_str != '1'
			then
			    column_str := column_str || ',';
				result_str := result_str || ',';
				view_str := view_str || ',';
			else
				column_str := '';
			end if;
	        column_str := column_str || col_name;
            result_str := result_str || '"' || col_name || '" : "' || ''' || ' ;
            result_str := result_str || col_name || ' || ''"';
			view_str := view_str || col_name || ' varchar2(1000) path ''$.' || col_name || '''';
        else 
            exit;
        end if;    
    end loop;
	result_str := result_str || '}''';
	view_str := view_str || ')) b';
	sql_str := 'DECLARE
    mycursor2 sys_refcursor ;
	sql_str varchar(5000);
	' || type_str || '
    BEGIN
    open mycursor2 for ''SELECT ' || column_str || ' FROM ' || src_table_name || ''';
    loop
        fetch mycursor2 into ' || column_str ||';
        if mycursor2%found
        then
		    sql_str := ''insert into ' || dst_table_name || ' values (''' || result_str || ''')'';
	        execute immediate sql_str;
        else 
            exit;
        end if;    
    end loop;
    END;
    /';
	execute immediate sql_str;
	dbe_output.print_line(sql_str);
	sql_str := 'drop table ' || src_table_name;
	execute immediate sql_str;
	execute immediate view_str;
	dbe_output.print_line(view_str);
end;
/
drop table if exists temp2;
drop view if exists temp2;
create table temp2(aaa int, bbb varchar(20));
insert into temp2 values(1,'1');
call test_json_table_object('temp2');
select * from temp2;
drop view if exists temp2;
drop view t_subselect_rs_005;
drop view t_subselect_rs_006;
drop table temp_json_table_long;
drop table test_json_table2;
drop table test_json_table;
--20210218
DROP TABLE if exists t_json_table_0218_2;
CREATE TABLE t_json_table_0218_2(id INT,c_js varchar(150),c_vchar varchar(10),c_int int,c_num number,c_date date,check(c_js is json));
insert into t_json_table_0218_2 values(1,'{"ctry":{"pro1":"a0001", "pro2":{"city1":"a0001","city2":"b0001"}, "pro3":["a0001","b0001","c0001"]}}','ctry1',1,1,ADD_MONTHS(to_timestamp('1000-01-01 10:10:10','yyyy-mm-dd hh24:mi:ss'),MOD(1,10000)));
insert into t_json_table_0218_2 values(2,'{"ctry":{"pro1":"a0002", "pro2":{"city1":"a0002","city2":"b0002"}, "pro3":["a0002","b0002","c0002"]}}','ctry2',2,2,ADD_MONTHS(to_timestamp('1000-01-01 10:10:10','yyyy-mm-dd hh24:mi:ss'),MOD(2,10000)));
insert into t_json_table_0218_2 values(3,'{"ctry":{"pro1":"a0003", "pro2":{"city1":"a0003","city2":"b0003"}, "pro3":["a0003","b0003","c0003"]}}','ctry3',3,3,ADD_MONTHS(to_timestamp('1000-01-01 10:10:10','yyyy-mm-dd hh24:mi:ss'),MOD(3,10000)));
insert into t_json_table_0218_2 values(4,'{"ctry":{"pro1":"a0004", "pro2":{"city1":"a0004","city2":"b0004"}, "pro3":["a0004","b0004","c0004"]}}','ctry4',4,4,ADD_MONTHS(to_timestamp('1000-01-01 10:10:10','yyyy-mm-dd hh24:mi:ss'),MOD(4,10000)));
insert into t_json_table_0218_2 values(5,'{"ctry":{"pro1":"a0005", "pro2":{"city1":"a0005","city2":"b0005"}, "pro3":["a0005","b0005","c0005"]}}','ctry5',5,5,ADD_MONTHS(to_timestamp('1000-01-01 10:10:10','yyyy-mm-dd hh24:mi:ss'),MOD(5,10000)));
insert into t_json_table_0218_2 values(6,'{"ctry":{"pro1":"a0006", "pro2":{"city1":"a0006","city2":"b0006"}, "pro3":["a0006","b0006","c0006"]}}','ctry6',6,6,ADD_MONTHS(to_timestamp('1000-01-01 10:10:10','yyyy-mm-dd hh24:mi:ss'),MOD(6,10000)));
insert into t_json_table_0218_2 values(7,'{"ctry":{"pro1":"a0007", "pro2":{"city1":"a0007","city2":"b0007"}, "pro3":["a0007","b0007","c0007"]}}','ctry7',7,7,ADD_MONTHS(to_timestamp('1000-01-01 10:10:10','yyyy-mm-dd hh24:mi:ss'),MOD(7,10000)));
insert into t_json_table_0218_2 values(8,'{"ctry":{"pro1":"a0008", "pro2":{"city1":"a0008","city2":"b0008"}, "pro3":["a0008","b0008","c0008"]}}','ctry8',8,8,ADD_MONTHS(to_timestamp('1000-01-01 10:10:10','yyyy-mm-dd hh24:mi:ss'),MOD(8,10000)));
insert into t_json_table_0218_2 values(9,'{"ctry":{"pro1":"a0009", "pro2":{"city1":"a0009","city2":"b0009"}, "pro3":["a0009","b0009","c0009"]}}','ctry9',9,9,ADD_MONTHS(to_timestamp('1000-01-01 10:10:10','yyyy-mm-dd hh24:mi:ss'),MOD(9,10000)));
insert into t_json_table_0218_2 values(10,'{"ctry":{"pro1":"a00010", "pro2":{"city1":"a00010","city2":"b00010"}, "pro3":["a00010","b00010","c00010"]}}','ctry10',10,10,ADD_MONTHS(to_timestamp('1000-01-01 10:10:10','yyyy-mm-dd hh24:mi:ss'),MOD(10,10000)));
commit;
select count(*) from t_json_table_0218_2 t1, json_table(t1.c_js, '$[*]' default '1' on error columns (f1 varchar2(15) path '$.ctry.pro12', f4 for ordinality)) connect by prior t1.id >= t1.id;
select distinct t1.f1 from (select distinct c_js from t_json_table_0218_2 where id=1) , json_table(c_js, '$[*]' error on error columns (f1 varchar2(15) path '$.ctry.pro1', f4 for ordinality)) t1;
select * from (select * from t_json_table_0218_2 where id=1) t1 where exists(select * from json_table(c_js, '$[*]' error on error columns (f1 varchar2(15) path '$.ctry.pro1', f4 for ordinality)) t2 where t2.f4 = t1.id);
select count(*) from t_json_table_0218_2 t1, t_json_table_0218_2 t2 join json_table(t1.c_js, '$[*]' columns (f1 varchar2(15) path '$.ctry.pro1', f4 for ordinality));
DROP TABLE t_json_table_0218_2;
select * from json_table('[{"a":"a1","b":{"bb":"ds"},"c":"c3"},{"a":"a2","b":{"bb":"ds"},"c":"c6"}]','$[*]' columns (f1 varchar2(15) path '$.a', f2 clob format json path '$.b', f4 for ordinality, f3 varchar2(10000) exists path '$.c')) t2;
drop table if exists t_json_table_200_0219_2;
create table t_json_table_200_0219_2 as select * from json_table('[{"a":"a1","b":{"bb":"ds"},"c":"c3"},{"a":"a2","b":{"bb":"ds"},"c":"c6"}]','$[*]' columns (f1 varchar2(15) path '$.a', f2 varchar2(3) format json path '$.b', f4 for ordinality, f3 varchar2(10000) exists path '$.c')) t1 union select * from json_table('[{"a":"a1","b":{"bb":"ds"},"c":"c3"},{"a":"a2","b":{"bb":"ds"},"c":"c6"}]','$[*]' columns (f1 varchar2(15) path '$.a', f2 clob format json path '$.b', f4 for ordinality, f3 varchar2(10000) exists path '$.c')) t2;
--20210401
DROP TABLE if exists t_unnest2_0401;
CREATE TABLE t_unnest2_0401(id INT,c_js varchar(150),c_vchar varchar(10),c_int int,c_num number,c_date date);  
insert into t_unnest2_0401 values(1,lpad('123abc',100,'abc'),'11',1,1.23,to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_unnest2_0401 values(2,'{"ctry":{"pro1":"a00010", "pro2":{"city1":"a00010","city2":"b00010"}, "pro3":["a00010","b00010","c00010"]}}','11',1,1.23,to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
		sqlst := 'insert into ' || tname ||' select id+'||i||',c_js||'||i||',c_vchar||'||i||',c_int+'||i||',c_num+'||i||',c_date from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/
call proc_insert('t_unnest2_0401',1,10);
commit;
select id from t_unnest2_0401 a,json_table(rowid,'$' columns (f4 for ordinality)) ;
select id from t_unnest2_0401,json_table(prior c_js,'$' columns (f4 for ordinality)) connect by id + 1= prior id ;
select (select f1 from json_table(a.c_js,'$' columns (f1 for ordinality))) b from t_unnest2_0401 a order by 1;
select id from t_unnest2_0401,json_table(CONNECT_BY_ROOT c_js,'$' columns (f4 for ordinality)) connect by id + 1= prior id ;
select * from json_table(array[1,2],'$' columns (f4 for ordinality));
select * from json_table(cast(rownodeid as varchar(100)),'$' columns (f4 for ordinality));
DROP TABLE t_unnest2_0401;
SELECT * FROM JSON_TABLE('{"type" : ["Office", "Office2"], "number" : "909-555-7307", "type" : "Office2"}', '$.number[1]' error on error COLUMNS (type varchar2(10) PATH '$' ));