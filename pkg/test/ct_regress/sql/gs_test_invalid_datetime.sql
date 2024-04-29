drop table if exists test_invalid_datetime;
create table test_invalid_datetime(COL datetime);
select COL from test_invalid_datetime;
insert into test_invalid_datetime values ('0000-00-00 00:00:00');
select * from test_invalid_datetime;
select to_char(to_date('0000-00-00','YYYY-MM-DD'),'D') from test_invalid_datetime;
select to_char(to_date('0000-00-00','YYYY-MM-DD'),'MONTH,MON') from test_invalid_datetime;
select to_char(to_date('0000-00-00','YYYY-MM-DD'),'DAY') from test_invalid_datetime;
insert into test_invalid_datetime values ('0001-00-01 00:00:00');