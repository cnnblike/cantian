---- The following cases have been debugged and passed by pufuan, p00421579

--- The cases for sysdate, systimestamp
-- select sysdate, systimestamp from dual;
-- select SYSDATE, SYSTIMESTAMP from dual;

--- The cases for date expression
select to_date('2017-08-11', 'YYYY-MM-DD') from dual;
select to_date('2017-08-11', 'YYYY-MM-DD') + 1 from dual;
select 1 + to_date('2017-08-11', 'YYYY-MM-DD') from dual;
select to_date('2017-08-11', 'YYYY-MM-DD') - 1 from dual;
select 1 - to_date('2017-08-11', 'YYYY-MM-DD') from dual;
select to_date('2017-08-11', 'YYYY-MM-DD') * 1 from dual;
select 1 * to_date('2017-08-11', 'YYYY-MM-DD') from dual;
select to_date('2017-08-11', 'YYYY-MM-DD') || ' <---' from dual;
select to_date('2017-08-11', 'YYYY-MM-DD') || to_date('2018-08-11', 'YYYY-MM-DD') from dual;
select to_date('2017-08-11', 'YYYY-MM-DD') from dual;
select to_date('2017-08-11 13:24:55', 'YYYY-MM-DD HH24:MI:SS') from dual;
select to_timestamp('2017-08-11 13:24:55', 'YYYY-MM-DD HH24:MI:SS') from dual;
select to_timestamp('2017-09-11 23:45:59.44', 'YYYY-MM-DD HH24:MI:SS.FF3') + 1 from dual;


--- The cases for datetime format
select to_date('2017-08-11 12:12:12', 'YYYY-MM-DD HH24:MI:SS') from dual;
select to_date('2017-08-11 12:12:12', 'YYYY-MM-DD') from dual;
select to_date('2017-08-11 12:12:12', 'YYYY-MM-DD HH:MI:SS') from dual;
select to_date('2017-08-11 12:12', 'YYYY-MM-DD HH24:MI') from dual;
select to_date('2017-08-11 12', 'YYYY-MM-DD HH24') from dual;

-- format /
select to_date('2017/08/11', 'YYYY/MM/DD') from dual;
select to_date('08/11/2012', 'MM/DD/YYYY') from dual;
select to_date('08:11:2012', 'MM:DD:YYYY') from dual;
select to_date('2017.08.11 12', 'YYYY.MM.DD HH24') from dual;

select to_timestamp('2017-09-11 23:45:59.44', 'YYYY-MM-DD HH24:MI:SS.FF3') from dual;
select to_timestamp('2017-09-11 23:45:59.44', 'YYYY-MM-DD HH24:MI:SS.FF6') + 1 from dual;
select to_timestamp('2017-09-11 23:45:59.44', 'YYYY-MM-DD HH24:MI:SS.FF') + 1 from dual;
select to_timestamp('2017-09-11 23:45:59.44444', 'YYYY-MM-DD HH24:MI:SS.FF') + 1 from dual;


--- DATETIME subtraction is expected to obtain the days, but it is not supported
select to_date('2017-08-11', 'YYYY-MM-DD')-to_date('2018-09-24', 'YYYY-MM-DD') from dual;
select to_date('2017-08-11', 'YYYY-MM-DD')-to_date('2018-08-11', 'YYYY-MM-DD') from dual;
select to_timestamp('2017-08-11 13:24:55', 'YYYY-MM-DD HH24:MI:SS') - to_timestamp('2018-08-11 13:24:54', 'YYYY-MM-DD HH24:MI:SS') from dual;


--- DATETIME operation overflow & underflow
-- underflow cases
select to_date('2290-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS') from dual;
select to_date('2291-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS') from dual;
select to_date('2290-09-12', 'YYYY-MM-DD')+500 from dual;
select to_timestamp('2290-12-31 23:59:59.999999', 'YYYY-MM-DD HH24:MI:SS.FF') from dual;
select to_timestamp('2291-01-01 00:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF') from dual;
select to_timestamp('2290-09-12', 'YYYY-MM-DD')+500 from dual;
select to_timestamp('0001-01-01', 'YYYY-MM-DD') from dual;
select to_timestamp('0001-01-01', 'YYYY-MM-DD') - 1 from dual;
select to_timestamp('0001-01-01', 'YYYY-MM-DD') - 2 from dual;
select -2 + to_timestamp('0001-01-01', 'YYYY-MM-DD') from dual;
select to_timestamp('0001-01-01', 'YYYY-MM-DD') - 1.0 / 86400 from dual;
select to_timestamp('0001-01-01', 'YYYY-MM-DD') - 0.0001 / 86400 from dual;
select to_timestamp('0001-01-01 00:00:00.0', 'YYYY-MM-DD HH24:MI:SS.FF') - 1.0 / 86400 from dual;
select to_timestamp('0001-01-01 00:00:00.0', 'YYYY-MM-DD HH24:MI:SS.FF') - 0.00001 / 86400 from dual;

-- overflow
select to_date('1710-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS') from dual;
select to_date('1709-12-31 00:00:00', 'YYYY-MM-DD HH24:MI:SS') from dual;
select to_date('1710-05-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')-500.3333333333333333333 from dual;
select to_timestamp('1710-01-01 00:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF') from dual;
select to_timestamp('1709-12-31 00:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF') from dual;
select to_timestamp('1710-05-01 00:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF')-500.3333333333333333333 from dual;
select to_timestamp('9999-12-31', 'YYYY-MM-DD') from dual;
select to_timestamp('9999-12-31', 'YYYY-MM-DD') + 1 from dual;
select to_timestamp('9999-12-31', 'YYYY-MM-DD') + 2 from dual;
select -2 + to_timestamp('9999-12-31', 'YYYY-MM-DD') from dual;
-- the default time is 12:00:00
select to_timestamp('9999-12-31', 'YYYY-MM-DD') + 1.0 / 86400 from dual;
select to_timestamp('9999-12-31 23:59:59.999999', 'YYYY-MM-DD HH24:MI:SS.FF6') + 1.0 / 86400 from dual;
select to_timestamp('9999-12-31 23:59:59.999999', 'YYYY-MM-DD HH24:MI:SS.FF6') + 0.000001 / 86400 from dual;

--- Invalid datatime input
select to_timestamp('2017-09-31 23:45:59.44444', 'YYYY-MM-DD HH24:MI:SS.FF')  from dual;
select to_timestamp('2017-13-01 23:45:59.4444', 'YYYY-MM-DD HH24:MI:SS.FF')  from dual;
select to_timestamp('207-11-01 23:45:59.44444', 'YYYY-MM-DD HH24:MI:SS.FF')  from dual;
select to_timestamp('2017-02-30 23:45:59.444454', 'YYYY-MM-DD HH24:MI:SS.FF')  from dual;
select to_date('2017-00-11', 'YYYY-MM-DD') from dual;
select to_date('2017-01-00', 'YYYY-MM-DD') from dual;
select to_date('2017-01-00', 'YYYY-MM-DD') from dual;
select to_timestamp('2017-02-22 25:45:59.444444', 'YYYY-MM-DD HH24:MI:SS.FF')  from dual;
select to_timestamp('2017-02-22 -12:45:59.444444', 'YYYY-MM-DD HH24:MI:SS.FF')  from dual;
select to_timestamp('2017-02-22 00:87:59.444444', 'YYYY-MM-DD HH24:MI:SS.FF')  from dual;
select to_timestamp('2017-02-22 00:23:23.444444', 'YYYY-MM-DD HH24:MI:SS.FF')  from dual;
select to_timestamp('2017-02-22 00:23:23.444444', 'YYYY-MM-DD HH24:MI:SS.FF3')  from dual;
select to_timestamp('2017-02-22 00:23:23.444444', 'YYYY-MM-DD HH24:MI:SS.FF6')  from dual;
select to_timestamp('2017-2-22 00:23:23.444444', 'YYYY-MM-DD HH24:MI:SS.FF')  from dual;
select to_date('2017-01-12', 'YYYY-MM-DD HH24:MI:SS') from dual;
select to_date('2017-01-2', 'YYYY-MM-DD') from dual;

--- Instert into table
DROP TABLE IF EXISTS ts_tbl_1;
create table ts_tbl_1(c1 int, c3 datetime, c2 timestamp);
insert into ts_tbl_1 values(1, to_date('2017-09-22 12:34:56', 'YYYY-MM-DD HH24:MI:SS'), to_timestamp('2017-09-22 23:45:00.112233', 'YYYY-MM-DD HH24:MI:SS.FF'));
insert into ts_tbl_1 values(2, to_date('2017-09-22 12:34:56', 'YYYY-MM-DD HH24:MI:SS')+1, to_timestamp('2017-09-22 23:45:00.11223', 'YYYY-MM-DD HH24:MI:SS.FF')+1);
insert into ts_tbl_1 values(3, to_date('2017-09-22 12:34:56', 'YYYY-MM-DD HH24:MI:SS')+2, to_timestamp('2017-09-22 23:45:00.112233', 'YYYY-MM-DD HH24:MI:SS.FF')+2);
insert into ts_tbl_1 values(4, to_date('2017-09-22 12:34:56', 'YYYY-MM-DD HH24:MI:SS')+3, to_timestamp('2017-09-22 23:45:00.1122', 'YYYY-MM-DD HH24:MI:SS.FF')+3);
select * from ts_tbl_1 order by c1;
select * from ts_tbl_1 order by c2;

--- timestamp with precision, do not support
DROP TABLE IF EXISTS ts_tbl_2;
create table ts_tbl_2(c1 int, c2 timestamp(6));
insert into ts_tbl_2 values(1, to_timestamp('2017-09-22 23:45:00.1122', 'YYYY-MM-DD HH24:MI:SS.FF6'));
insert into ts_tbl_2 values(2, to_timestamp('2017-09-22 23:45:00.1122', 'YYYY-MM-DD HH24:MI:SS.FF6')+1);
insert into ts_tbl_2 values(3, 2+to_timestamp('2017-09-22 23:45:00.1122', 'YYYY-MM-DD HH24:MI:SS.FF6'));
select * from ts_tbl_2 order by c1;
select * from ts_tbl_2 order by c2;

DROP TABLE IF EXISTS ts_tbl_2;
create table ts_tbl_2(id int, c_date date);
insert into ts_tbl_2(id,c_date) values(1,to_timestamp('2017-09-22 23:45:00.1122', 'YYYY-MM-DD HH24:MI:SS.FF6'));
insert into ts_tbl_2(id,c_date) values(2,to_timestamp('2017-09-22 23:46:01.1122', 'YYYY-MM-DD HH24:MI:SS.FF6'));
insert into ts_tbl_2(id,c_date) values(3,to_timestamp('2017-09-22 23:45:00.1122', 'YYYY-MM-DD HH24:MI:SS.FF6'));
select * from ts_tbl_2 order by id;
select * from ts_tbl_2 where c_date = to_date('2017-09-22 23:45:00','yyyy-mm-dd hh24:mi:ss') order by id;
select * from ts_tbl_2 where c_date = to_date('2017-09-22 23:46:01','yyyy-mm-dd hh24:mi:ss') order by id;

-- timestamp DDL test
DROP TABLE IF EXISTS TS_TBL_180130_1;
CREATE TABLE TS_TBL_180130_1(X TIMESTAMP(1) WITH LOCAL TIME ZONE);
desc TS_TBL_180130_1

DROP TABLE IF EXISTS TS_TBL_180130_2;
CREATE TABLE TS_TBL_180130_2(X TIMESTAMP(2) WITH TIME ZONE);
desc TS_TBL_180130_2

DROP TABLE IF EXISTS TS_TBL_180130_3;
create table TS_TBL_180130_3(s timestamp(3) /*213*/ with /*asdasd*/ local /*time*/ time /*xx*/ zone);
desc TS_TBL_180130_3

DROP TABLE IF EXISTS TS_TBL_180130_4;
create table TS_TBL_180130_4(s/*ssdgf*/ timestamp(4) /*213*/ with /*asdasd*/ local /*time*/ time /*xx*/ zone);
desc TS_TBL_180130_4

drop table if exists PGS_ddl_1;
create table PGS_ddl_1(r1 double, r2 double precision);
desc PGS_ddl_1

drop table if exists PGS_ddl_2;
create table PGS_ddl_2(c1 character(10), r2 character varying(12));
desc PGS_ddl_2

-- DTS2018011610974
drop table if exists t_datatime_1;
create table t_datatime_1(f1 int, f2 TIMESTAMP with time zone NOT NULL default current_timestamp);
insert into t_datatime_1(f1) values(1);
commit;
select f1 from t_datatime_1;
drop table t_datatime_1;

select '2010-10-10 12:10:333'::timestamp;
select '2010-10-10 12:8'::timestamp;
select '2010-10-10 12:18'::timestamp;
select '12342'::timestamp;
select '2010-22'::timestamp;
select '2010'::timestamp;
select ''::timestamp;
select '1234-12'::timestamp;
select '234-12'::timestamp;
select '1234-12-11 1'::timestamp;
select '1234-12-11 11:21'::timestamp;
select '1234-12-11 11:23:21'::timestamp;
select '1234-12-11 11:23:1'::timestamp;
select '1234-12-11 11:3:21'::timestamp;

DROP TABLE IF EXISTS ADD__TBL_20015;
CREATE TABLE ADD__TBL_20015 (COL INTEGER); ALTER TABLE ADD__TBL_20015 ADD COL_1 TIMESTAMP DEFAULT '2010-10-10' ; -- ; -- , ADD COL_2 NUMBER NOT NULL ;
insert into ADD__TBL_20015 values(1, default);
insert into ADD__TBL_20015 values(2, default);
insert into ADD__TBL_20015 values(3, default+1);
select * from ADD__TBL_20015;


-- timestamp with precision
select to_char(to_timestamp('2017-01-02 03:04:05.888888', 'YYYY-MM-DD HH24:MI:SS.FF6')) from dual;
select to_char(to_timestamp('2017-01-02 03:04:05.888888', 'YYYY-MM-DD HH24:MI:SS.FF6'), 'FF1') from dual;
select to_char(to_timestamp('2017-01-02 03:04:05.888888', 'YYYY-MM-DD HH24:MI:SS.FF6'), 'FF2') from dual;
select to_char(to_timestamp('2017-01-02 03:04:05.888888', 'YYYY-MM-DD HH24:MI:SS.FF6'), 'FF3') from dual;
select to_char(to_timestamp('2017-01-02 03:04:05.888888', 'YYYY-MM-DD HH24:MI:SS.FF6'), 'FF4') from dual;
select to_char(to_timestamp('2017-01-02 03:04:05.888888', 'YYYY-MM-DD HH24:MI:SS.FF6'), 'FF5') from dual;
select to_char(to_timestamp('2017-01-02 03:04:05.888888', 'YYYY-MM-DD HH24:MI:SS.FF6'), 'FF6') from dual;


drop table if exists TS_TBL_180201_1;
create table TS_TBL_180201_1(
c0 timestamp,
c1 timestamp(1),
c2 timestamp(2),
c3 timestamp(3),
c4 timestamp(4),
c5 timestamp(5),
c6 timestamp(6)
);
insert into TS_TBL_180201_1 values('2017-01-01 12:34:56.789012','2017-01-01 12:34:56.789012','2017-01-01 12:34:56.789012','2017-01-01 12:34:56.789012','2017-01-01 12:34:56.789012','2017-01-01 12:34:56.789012','2017-01-01 12:34:56.789012');
insert into TS_TBL_180201_1 values('2017-01-01 12:34:56.000000','2017-01-01 12:34:56.000000','2017-01-01 12:34:56.000000','2017-01-01 12:34:56.000000','2017-01-01 12:34:56.000000','2017-01-01 12:34:56.000000','2017-01-01 12:34:56.000000');

select * from TS_TBL_180201_1;

select to_char(to_timestamp('1600-01-01 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'YYYY-MM-DD HH24:MI:SS DAY') from dual;
select to_char(to_timestamp('1800-01-01 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'YYYY-MM-DD HH24:MI:SS DAY') from dual;
select to_char(to_timestamp('1900-01-01 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'YYYY-MM-DD HH24:MI:SS DAY') from dual;
select to_char(to_timestamp('2000-01-01 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'YYYY-MM-DD HH24:MI:SS DAY') from dual;
select to_char(to_timestamp('2018-04-20 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'YYYY-MM-DD HH24:MI:SS DAY') from dual;

-- HH is the default, and equal to HH12
select to_char(to_timestamp('2001-01-01 20:20:20.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'AM-PM-DAY-DY HH12 - HH24 - HH') from dual;
select to_char(to_timestamp('2018-01-01 10:10:10.121', 'YYYY-MM-DD HH24:MI:SS.FF'), 'AM-PM-DAY-DY HH12 - HH24 - HH') from dual;

select to_char(to_timestamp('2018-01-20 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'MM-MON-MONTH') from dual;
select to_char(to_timestamp('2018-02-02 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'MM-MON-MONTH') from dual;
select to_char(to_timestamp('2018-03-20 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'MM-MON-MONTH') from dual;
select to_char(to_timestamp('2018-04-02 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'MM-MON-MONTH') from dual;
select to_char(to_timestamp('2018-05-20 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'MM-MON-MONTH') from dual;
select to_char(to_timestamp('2018-06-02 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'MM-MON-MONTH') from dual;
select to_char(to_timestamp('2018-07-20 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'MM-MON-MONTH') from dual;
select to_char(to_timestamp('2018-08-02 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'MM-MON-MONTH') from dual;
select to_char(to_timestamp('2018-09-20 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'MM-MON-MONTH') from dual;
select to_char(to_timestamp('2018-10-02 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'MM-MON-MONTH') from dual;
select to_char(to_timestamp('2018-11-02 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'MM-MON-MONTH') from dual;
select to_char(to_timestamp('2018-12-02 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'MM-MON-MONTH') from dual;

select to_char(to_timestamp('2018-04-20 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'YYYY-YYY-YY-Y') from dual;
select to_char(to_timestamp('1000-11-11 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'YYYY-YYY-YY-Y') from dual;

select to_char(to_timestamp('2018-04-20 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'CC') from dual;
select to_char(to_timestamp('2000-01-01 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'CC') from dual;
select to_char(to_timestamp('1999-12-31 23:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'CC') from dual;
select to_char(to_timestamp('1000-11-11 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'CC') from dual;
select to_char(to_timestamp('0001-11-11 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'CC') from dual;

select to_char(to_timestamp('1000-11-11 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'WW/W') from dual;
select to_char(to_timestamp('2018-04-11 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'WW/W') from dual;
select to_char(to_timestamp('2018-01-11 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'WW/W') from dual;
select to_char(to_timestamp('2018-12-31 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'WW/W') from dual;

select to_char(to_timestamp('2000-04-11 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'DDD - DD - D - DY') from dual;
select to_char(to_timestamp('2000-01-11 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'DDD - DD - D - DY') from dual;
select to_char(to_timestamp('2018-12-31 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'DDD - DD - D - DY') from dual;
-- The following cases are differnt from Oracle's results. The reason may be that Oracle has differnt count befor 1200 year
select to_char(to_timestamp('1000-11-11 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'DDD - DD - D - DY') from dual;
select to_char(to_timestamp('0400-01-01 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'DDD - DD - D - DY') from dual;
select to_char(to_timestamp('0400-11-11 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'DDD - DD - D - DY') from dual;

select to_timestamp('2012-DEC-31', 'YYYY-MON-DD') from dual;
select to_timestamp('2012-XPG-31', 'YYYY-MON-DD') from dual; 
select to_timestamp('2012-DE-31', 'YYYY-MON-DD') from dual;
select to_timestamp('2012-MAY-12', 'YYYY-MON-MM') from dual;
select to_timestamp('2012-25-DEC', 'YYYY-DD-MON') from dual;
select to_timestamp('2012-25-DE', 'YYYY-DD-MON') from dual;
select to_timestamp('2018-SEP-31-MAY', 'YYYY-MON-DD-MONTH') from dual;

select to_timestamp('2018-SEPTEMBER-31', 'YYYY-MONTH-DD') from dual;
select to_timestamp('2018-SEPTEMBER-31-MAY', 'YYYY-MONTH-DD-MON') from dual;
select to_timestamp('2018-18-DE', 'YYYY-DD-MONTH') from dual;
select to_timestamp('2018-SEXXXXXXX-31', 'YYYY-MONTH-DD') from dual;
select to_timestamp('2018-SEPTEMBER-10', 'YYYY-MONTH-DD') from dual;
select to_timestamp('2018-SEPTEMBER-10', 'YYYY-MONTH-MM') from dual;
select to_timestamp('2000-04-11 12:12:12.12a2', 'YYYY-MM-DD HH24:MI:SS.FF') from dual;
select to_timestamp('2000-04-11 12:12:12.123.123', 'YYYY-MM-DD HH24:MI:SS.FF3.FF3') from dual;
select to_timestamp('2000-04-11 12:12:12.12345678', 'YYYY-MM-DD HH24:MI:SS.FF') from dual;
select to_timestamp('2000-04-11 12:12:12.123-123', 'YYYY-MM-DD HH24:MI:SS.FF3-FF') from dual;
select to_timestamp('18-04-11 12:12:12.123', 'YY-MM-DD HH24:MI:SS.FF3') from dual;
select to_timestamp('18-04-11 12:12:12.123', 'XPG-MM-DD HH24:MI:SS.FF3') from dual;

select to_char(to_timestamp('2018-01-01 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Q') from dual;
select to_char(to_timestamp('2000-03-31 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Q') from dual;
select to_char(to_timestamp('2000-04-01 12:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Q') from dual;
select to_char(to_timestamp('0999-08-31 23:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Q') from dual;
select to_char(to_timestamp('1999-12-31 23:12:12.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Q') from dual;

select to_char(to_timestamp('2018-01-01 00:00:00.0', 'YYYY-MM-DD HH24:MI:SS.FF'), 'SS - SSSSS') as "SS - SSSSS" from dual;
select to_char(to_timestamp('2000-03-31 00:00:00.999999', 'YYYY-MM-DD HH24:MI:SS.FF'), 'SS - SSSSS') as "SS - SSSSS" from dual;
select to_char(to_timestamp('2000-04-01 00:00:01.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'SS - SSSSS') as "SS - SSSSS" from dual;
select to_char(to_timestamp('0999-08-31 00:01:00.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'SS - SSSSS') as "SS - SSSSS" from dual;
select to_char(to_timestamp('1999-12-31 01:00:00.121212', 'YYYY-MM-DD HH24:MI:SS.FF'), 'SS - SSSSS') as "SS - SSSSS" from dual;
select to_char(to_timestamp('2999-12-31 23:59:59.999999', 'YYYY-MM-DD HH24:MI:SS.FF'), 'SS - SSSSS') as "SS - SSSSS" from dual;

select to_char(to_timestamp('2018-01-01 12:12:12.0', 'YYYY-MM-DD HH24:MI:SS.FF'),      'FF - FF1 - FF2 - FF3 - FF4 - FF5 - FF6') as "FFi Test" from dual;
select to_char(to_timestamp('2000-03-31 12:12:12.000001', 'YYYY-MM-DD HH24:MI:SS.FF'), 'FF - FF1 - FF2 - FF3 - FF4 - FF5 - FF6') as "FFi Test" from dual;
select to_char(to_timestamp('2000-04-01 12:12:12.000010', 'YYYY-MM-DD HH24:MI:SS.FF'), 'FF - FF1 - FF2 - FF3 - FF4 - FF5 - FF6') as "FFi Test" from dual;
select to_char(to_timestamp('0999-08-31 23:12:12.001000', 'YYYY-MM-DD HH24:MI:SS.FF'), 'FF - FF1 - FF2 - FF3 - FF4 - FF5 - FF6') as "FFi Test" from dual;
select to_char(to_timestamp('1999-12-31 23:12:12.099',    'YYYY-MM-DD HH24:MI:SS.FF'), 'FF - FF1 - FF2 - FF3 - FF4 - FF5 - FF6') as "FFi Test" from dual;
select to_char(to_timestamp('1999-12-31 23:12:12.099999', 'YYYY-MM-DD HH24:MI:SS.FF'), 'FF - FF1 - FF2 - FF3 - FF4 - FF5 - FF6') as "FFi Test" from dual;
select to_char(to_timestamp('1999-12-31 23:12:12.999999', 'YYYY-MM-DD HH24:MI:SS.FF'), 'FF - FF1 - FF2 - FF3 - FF4 - FF5 - FF6') as "FFi Test" from dual;

select to_char(to_timestamp('2018-01-01 12:12:12.0', 'YYYY-MM-DD HH24:MI:SS.FF'),      'FF0') as "FFi Test" from dual;
-- FF7, 8, 9 are not supported by Zenith now, but supported by Oracle 
select to_char(to_timestamp('2018-01-01 12:12:12.0', 'YYYY-MM-DD HH24:MI:SS.FF'),      'FF7') as "FFi Test" from dual;
select cast(to_timestamp('9999-12-31 23:59:59.999999', 'YYYY-MM-DD HH24:MI:SS.FF') as timestamp(9)) from dual;

-- adjust_timestamp
select cast(to_timestamp('2018-01-01 12:12:12.123456', 'YYYY-MM-DD HH24:MI:SS.FF') as timestamp(3)) from dual;
select cast(to_timestamp('2018-01-01 12:12:12.45678', 'YYYY-MM-DD HH24:MI:SS.FF') as timestamp(4)) from dual;
select cast(to_timestamp('2018-01-01 00:00:00.999999', 'YYYY-MM-DD HH24:MI:SS.FF') as timestamp(5)) from dual;
select cast(to_timestamp('2018-01-01 23:59:59.999999', 'YYYY-MM-DD HH24:MI:SS.FF') as timestamp(6)) from dual;
select cast(to_timestamp('2012-02-28 23:59:59.999999', 'YYYY-MM-DD HH24:MI:SS.FF') as timestamp(5)) from dual;
select cast(to_timestamp('2018-03-31 23:59:59.999999', 'YYYY-MM-DD HH24:MI:SS.FF') as timestamp(5)) from dual;
select cast(to_timestamp('1970-03-31 23:59:59.999999', 'YYYY-MM-DD HH24:MI:SS.FF') as timestamp(2)) from dual;
select cast(to_timestamp('1900-02-28 23:59:59.999999', 'YYYY-MM-DD HH24:MI:SS.FF') as timestamp(1)) from dual;
select cast(to_timestamp('9999-12-31 23:59:59.999999', 'YYYY-MM-DD HH24:MI:SS.FF') as timestamp(1)) from dual;
select cast(to_timestamp('9999-12-31 23:59:59.222222', 'YYYY-MM-DD HH24:MI:SS.FF') as timestamp(0)) from dual;

--timestampadd
SELECT TIMESTAMPADD(MONTH,10000000,'2003-01-02') FROM DUAL;
SELECT TIMESTAMPADD(MONTH,4294967296,'2003-01-02') FROM DUAL;

select 1 from dual where to_char(scn2date('252455615999999999'), 'YYYY') > 1000;
--select to_char(scn2date('2524556159999999998'), 'YYYY') from dual;
select 1 from dual where to_char(scn2date('25245561599999999945'), 'YYYY') > 1000;

select 1 from dual where unix_timestamp() > (sysdate - 1 - to_date('01-JAN-1970 00:00:00','DD-MON-YYYY HH24:MI:SS')) * (86400);

select unix_timestamp(to_timestamp('1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')) from dual;

SELECT UNIX_TIMESTAMP('') from dual;
SELECT UNIX_TIMESTAMP(null) from dual;
select unix_timestamp('2000-01-01 00:00:00') from dual;
select unix_timestamp('2018-06-23 09:30:34') from dual;
select unix_timestamp('1971-01-01 00:00:00') from dual;
SELECT UNIX_TIMESTAMP('2007-11-30 10:30:19') from dual;

-- invalid cases
SELECT UNIX_TIMESTAMP(1) from dual;
SELECT UNIX_TIMESTAMP('123') from dual;
SELECT UNIX_TIMESTAMP('') from dual;

select ADD_MONTHS('2005-08-01',1) from dual;
select ADD_MONTHS(to_date('2005-08-01'),1) from dual;
alter session set nls_date_format='YYYY-MM';
select ADD_MONTHS(to_date('2005-08'),1) from dual;
select ADD_MONTHS('2005-08',1) from dual;
select ADD_MONTHS('2005-08-01',1) from dual;

-- SESSIONTIMEZONE
ALTER SESSION SET TIME_ZONE='';
ALTER SESSION SET TIME_ZONE='    ';
ALTER SESSION SET TIME_ZONE='-';
ALTER SESSION SET TIME_ZONE='-+12:00';
ALTER SESSION SET TIME_ZONE='-12';
ALTER SESSION SET TIME_ZONE='-12:00:30';
ALTER SESSION SET TIME_ZONE='-12+00';
ALTER SESSION SET TIME_ZONE='14:01';
ALTER SESSION SET TIME_ZONE='-12:01';
ALTER SESSION SET TIME_ZONE='+12345:00';
ALTER SESSION SET TIME_ZONE='+11:60';
ALTER SESSION SET SESSIONTIMEZONE='+08:00';

ALTER SESSION SET TIME_ZONE='-12:00';
SELECT SESSIONTIMEZONE FROM DUAL;

ALTER SESSION SET TIME_ZONE='+14:00';
SELECT SESSIONTIMEZONE FROM DUAL;

ALTER SESSION SET TIME_ZONE='-9:5';
SELECT SESSIONTIMEZONE FROM DUAL;

ALTER SESSION SET TIME_ZONE='9:00';
SELECT SESSIONTIMEZONE FROM DUAL;

ALTER SESSION SET TIME_ZONE='+009:059';
SELECT SESSIONTIMEZONE FROM DUAL;

--DTS2018092509761 
select min(sysdate)-max(sysdate) date_diff, min(current_timestamp)-max(current_timestamp) timestamp_diff from all_objects a, all_objects b where rownum <= 50000;

--DTS2019013102954
select cast(to_yminterval('12-02') as varchar(200)) from dual;
select cast(to_dsinterval('P12DT0.332S') as varchar(200)) from dual;

--begin test tz
--time zone type length
select length(current_timestamp) as test;
select length(systimestamp) as test;

ALTER SESSION SET TIME_ZONE='+08:00';
SELECT SESSIONTIMEZONE FROM DUAL;

drop table if exists TIMETESTTABLE;
drop index if exists TIMETESTTABLE_INDEX on TIMETESTTABLE;
create table TIMETESTTABLE(id timestamp with time zone default current_timestamp, cc int default 666);
desc TIMETESTTABLE;

insert into TIMETESTTABLE(id, cc) values('2018-12-21 11:41:54.335265 +06:00',22);
insert into TIMETESTTABLE(id, cc) values('2018-12-21 11:41:54.335265 -06:00',22);
insert into TIMETESTTABLE(id, cc) values('2018-12-21 11:41:54.335265 +08:22',23);
insert into TIMETESTTABLE(id, cc) values('2018-12-21 11:41:54.335265 +08:00',24);
insert into TIMETESTTABLE(id, cc) values('2018-12-21 11:41:54.335265 +00:00',25);
insert into TIMETESTTABLE(id, cc) values ('2018-8-7 17:20:23.551220 -2',71);
insert into TIMETESTTABLE(id, cc) values ('2018-8-7 17:20:23.551222 -2',72);
insert into TIMETESTTABLE(id, cc) values ('2018-8-7 17:20:23.551221 -4',73);
insert into TIMETESTTABLE(id, cc) values ('2018-8-7 17:20:23.551221 -3',74);
insert into TIMETESTTABLE(id, cc) values ('2018-8-7 19:20:23.551221 -6',75);
insert into TIMETESTTABLE(id, cc) values (to_timestamp('2018-8-7 19:20:23.551221','YYYY-MM-DD HH24:MI:SS.FF'),66);
insert into TIMETESTTABLE(id, cc) values ('2018-8-7 19:20:23.551221 +03:00',77);
insert into TIMETESTTABLE(id, cc) values ('2018-8-7 19:20:23.551221 -3',76);
insert into TIMETESTTABLE(id, cc) values ('2018-8-7 19:20:23.551221 8',77);
insert into TIMETESTTABLE(id, cc) values ('2018-8-7 19:20:23.551221 9:3',77);
insert into TIMETESTTABLE(id, cc) values ('2018-9-7 19:20:23.698541 9:3',77);
select id from TIMETESTTABLE order by id;

--create index on tz column
create index TIMETESTTABLE_INDEX on TIMETESTTABLE(id);

drop table if exists TIMETESTTABLE;
drop index if exists TIMETESTTABLE_INDEX on TIMETESTTABLE;

--right calculation
select cast('2018-12-19 21:09:52.586081' as timestamp with time zone) - cast('2018-12-19 20:09:51.586080' as  timestamp with time zone) as test;
select cast('2018-12-19 20:09:51.586080 +08:00' as timestamp with time zone) - cast('2018-12-19 20:09:51.586080 +05:00' as  timestamp with time zone);
select cast('2018-12-19 20:09:51.586080 +08:00' as timestamp with time zone) - cast('2018-12-19 18:09:51.586080 +06:00' as  timestamp with time zone);
select to_timestamp(cast(cast(cast('2018-12-12 16:38:09.454903 +06:00' as timestamp with time zone) as timestamp) as varchar(26))) - cast('2018-12-18 19:09:50.586080 +08:00' as timestamp with time zone);

select cast('2018-12-12 16:38:09.454903 +06:00' as timestamp with time zone) + 1;
select 3 + cast('2018-12-12 16:38:09.454903 +06:00' as timestamp with time zone) + 1;
select cast('2018-12-12 16:38:09.454903 +06:00' as timestamp with time zone) - 5;

--error cases
select 5 - cast('2018-12-12 16:38:09.454903 +06:00' as timestamp with time zone);
select 5 * cast('2018-12-12 16:38:09.454903 +06:00' as timestamp with time zone);
select 5 / cast('2018-12-12 16:38:09.454903 +06:00' as timestamp with time zone);
--end

--begin test ltz
drop table if exists date_tab;
CREATE TABLE date_tab (tsltz_col   TIMESTAMP WITH LOCAL TIME ZONE);
   
INSERT INTO date_tab VALUES ('1999-12-01 10:00:00');
INSERT INTO date_tab VALUES ('1999-12-01 10:00:00.123456');
INSERT INTO date_tab VALUES (cast('2018-12-19 9:38:09.454903' as timestamp with local time zone));

--ltz to xxx
select tsltz_col from date_tab;
select cast(tsltz_col as date) from date_tab;
select cast(tsltz_col as timestamp) from date_tab;
select cast(tsltz_col as timestamp with time zone) from date_tab;
select cast(tsltz_col as timestamp with local time zone) from date_tab;

alter session set NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
alter session set NLS_TIMESTAMP_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';
alter session set NLS_TIMESTAMP_TZ_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF TZH:TZM';

-- xxx to date
select cast(cast('2018-12-19 9:38:09.454903 +06:00' as timestamp with time zone) as timestamp with local time zone) from dual;
select cast(cast(cast('2018-12-19 9:38:09.454903 +06:00' as timestamp with time zone) as timestamp with local time zone) as date) from dual;

select cast(cast('2018-12-19 9:38:09.454903 +06:00' as timestamp with time zone) as timestamp) from dual;
select cast(cast(cast('2018-12-19 9:38:09.454903 +06:00' as timestamp with time zone) as timestamp) as date) from dual;

select cast(cast('2018-12-19 9:38:09.454903 +06:00' as timestamp with time zone) as date) from dual;
select cast(cast(cast('2018-12-19 9:38:09.454903 +06:00' as timestamp with time zone) as date) as timestamp with time zone) from dual;

-- xxx to ltz
select cast('2018-12-19 9:38:09.454903' as timestamp with local time zone) from dual;
select cast('2018-12-19 9:38:09.454903' as timestamp with time zone) from dual;
select cast('2018-12-19 9:38:09.454903 +06:00' as timestamp with time zone) from dual;
select cast(cast('2018-12-19 9:38:09.454903' as timestamp with local time zone) as timestamp with local time zone) from dual;

select cast(cast('2018-12-19 9:38:09' as date) as timestamp with local time zone) from dual;
select cast(cast('2018-12-19 9:38:09.454903' as timestamp) as timestamp with local time zone) from dual;
select cast(cast('2018-12-19 9:38:09.454903' as timestamp with time zone) as timestamp with local time zone) from dual;

select cast(cast('2018-12-19 9:38:09.454903 +06:00' as timestamp with time zone) as timestamp with local time zone) from dual;

-- xxx to ts
select cast(cast('2018-12-19 9:38:09.454903 +06:00' as timestamp with time zone) as timestamp) from dual;
select cast(cast(cast('2018-12-19 9:38:09.454903 +06:00' as timestamp with time zone) as timestamp) as timestamp with time zone) from dual;
select cast(cast(cast('2018-12-19 9:38:09.454903 +06:00' as timestamp with time zone) as timestamp with local time zone) as timestamp with time zone) from dual;
select cast(cast(cast(cast('2018-12-19 9:38:09.454903 +06:00' as timestamp with time zone) as timestamp) as timestamp with local time zone) as timestamp with time zone) from dual;
select cast(cast('2018-12-19 9:38:09.454903 +06:00' as timestamp with time zone) as timestamp) - cast(cast('2018-12-19 9:38:09.454903 +06:00' as timestamp with time zone) as timestamp with local time zone) from dual;

select cast('2019-03-31 11:26:53.2088 +08:34' as timestamp(4) with time zone);
select cast('2019-03-31 11:26:53.2088              +06:00' as timestamp(4) with time zone);
select cast('2019-03-31 11:26:53.2088 +01:00' as timestamp with time zone) from dual;
select cast('2019-04-15 23:05:45.844402 8:20' as timestamp(4) with time zone);
select cast('2019-03-31 11:26:53.2088 -8:00' as timestamp(2) with time zone);
select cast('2019-03-31 11:26:53.20 +08:00' as timestamp with time zone) from dual;
select cast('2019-04-15 23:05:45.844402 +08:50' as timestamp(3) with time zone);
select cast(cast('2019-04-15 23:05:45.844402 -1:00' as timestamp(3) with time zone) as timestamp(4) with time zone);

drop procedure if exists tstz_type_test
/
create or replace procedure tstz_type_test()
as
    sqlstr  varchar2(200);
begin
    sqlstr:='drop table if exists tstz_type_test_tbl';
    execute immediate sqlstr;
	
    sqlstr:='create table tstz_type_test_tbl(c1 timestamp with time zone , c2 int)';
    execute immediate sqlstr;
end;
/

call tstz_type_test()
/

DECLARE
BEGIN
	INSERT INTO tstz_type_test_tbl VALUES('2018-08-07 19:20:23.551221 +03:00',32);
	INSERT INTO tstz_type_test_tbl VALUES('2018-08-08 19:20:23.551221 +04:00',32);
	INSERT INTO tstz_type_test_tbl VALUES('2018-08-09 19:20:23.551221 +05:00',32);
END;
/

select cast(c1 as timestamp(4) with time zone) from tstz_type_test_tbl;
drop table tstz_type_test_tbl;

select cast('0001-01-01 00:00:00.000000 +14:00' as timestamp with time zone) from dual;
select cast('9999-12-31 23:59:59.999999 -12:00' as timestamp with time zone) from dual;
select cast('2018-12-19 9:38:09.4549 +4:34' as timestamp with  time zone);
select to_char(cast('2018-12-19 9:38:09.4549 +4:34' as timestamp with time zone), 'YYYY')   from dual;
select to_char(cast('2018-12-19 9:38:09.4549 +4:34' as timestamp with time zone), 'MM')   from dual;
select to_char(cast('2018-12-19 9:38:09.4549 +4:34' as timestamp with time zone), 'DD')   from dual;
select to_char(cast('2018-12-19 9:38:09.4549 +4:34' as timestamp with time zone), 'HH24')   from dual;
select to_char(cast('2018-12-19 9:38:09.4549 +4:34' as timestamp with time zone), 'FF')   from dual;
select to_char(cast('2018-12-19 9:38:09.4549 +4:34' as timestamp with time zone), 'FF4' )   from dual;
select to_char(cast('2018-12-19 9:38:09.4549 +4:34' as timestamp(3) with time zone), 'FF4' )   from dual;
select to_char(cast('2018-12-19 9:38:09.4549 +4:34' as timestamp with time zone), 'TZH:TZM')   from dual;

--executed twice, the result should be the same
SELECT TIMESTAMPADD(SECOND,1000000000,'2008-02-28 23:59:00');
SELECT TIMESTAMPADD(SECOND,1000000000,'2008-02-28 23:59:00');

--to_char
drop table if exists tstz_type_test_tbl;
create table tstz_type_test_tbl(a int, b timestamp with local time zone default localtimestamp);
insert into tstz_type_test_tbl values(1,'2019-04-24 14:36:25.046731');
insert into tstz_type_test_tbl values(2,'2019-04-24 14:36:25.048023');
insert into tstz_type_test_tbl values(3,'2019-04-24 14:36:25.048802');

select to_char(b) from tstz_type_test_tbl;
select cast(to_char(b) as timestamp with local time zone) from tstz_type_test_tbl;
select to_char(cast(to_char(b) as timestamp with local time zone)) from tstz_type_test_tbl;
select cast(to_char(cast(to_char(b) as timestamp with local time zone)) as timestamp with local time zone) from tstz_type_test_tbl;
select to_char(cast(to_char(cast(to_char(b) as timestamp with local time zone)) as timestamp with local time zone)) from tstz_type_test_tbl;
select cast(to_char(cast(to_char(cast(to_char(b) as timestamp with local time zone)) as timestamp with local time zone)) as timestamp with local time zone) from tstz_type_test_tbl;
select to_char(cast(to_char(cast(to_char(cast(to_char(b) as timestamp with local time zone)) as timestamp with local time zone)) as timestamp with local time zone)) from tstz_type_test_tbl;
select to_char(b, 'HH24') from tstz_type_test_tbl;

--ltz cmp
drop table if exists tstz_type_test_tbl;
create table tstz_type_test_tbl(c_zone timestamp with local time zone);
insert into tstz_type_test_tbl values(to_timestamp('2010-08-01 00:00:00.000000','YYYY-MM-DD HH24:MI:SS.FF'));
select * from tstz_type_test_tbl where c_zone='2010-08-01 00:00:00.000000';
select * from tstz_type_test_tbl where c_zone=cast(to_timestamp('2010-08-01 00:00:00.000000','YYYY-MM-DD HH24:MI:SS.FF') as timestamp with local time zone);

drop table if exists tstz_type_test_tbl;
create table tstz_type_test_tbl(c1 timestamp with time zone,c2 timestamp with local time zone);
insert into tstz_type_test_tbl values(to_date('2019-01-01','YYYY-MM-DD HH24:MI:SS'),to_date('2019-01-01','YYYY-MM-DD HH24:MI:SS'));
select * from tstz_type_test_tbl where c1=c2;
drop table if exists tstz_type_test_tbl;

--default sessiontimezone
ALTER SESSION SET TIME_ZONE='+02:00';
select cast('2019-04-24 14:36:25.046731' as timestamp with time zone) from dual;
ALTER SESSION SET TIME_ZONE='+05:00';
select cast('2019-04-24 14:36:25.046731' as timestamp with time zone) from dual;
ALTER SESSION SET TIME_ZONE='+08:00';
select cast('2019-04-24 14:36:25.046731' as timestamp with time zone) from dual;

--var as string
select cast(cast('2019-04-24 14:36:25.046731' as timestamp with local time zone) as varchar(100)) from dual;

--tz order
drop table if exists tz_test_tbl;
create table tz_test_tbl(staff_id timestamp with time zone , b int);
insert into tz_test_tbl values('2019-04-28 16:17:03.853738 +00:00', 1);
insert into tz_test_tbl values('2019-04-28 16:16:55.836670 +00:00', 3);
insert into tz_test_tbl values('2019-04-28 16:16:58.844263 +00:00', 2);
insert into tz_test_tbl values('2019-04-28 16:16:55.801212 +00:00', 4);
select * from tz_test_tbl order by b,staff_id;
select * from tz_test_tbl order by staff_id,b;
drop table if exists tz_test_tbl;

--trunc return date when input type is datetimetype
select trunc(to_date('2010-08-01 07:00:00')) from dual;
select trunc(to_timestamp('2010-08-01 07:00:00.000000')) from dual;
select trunc(cast('2010-08-01 07:00:00.000000' as timestamp with time zone)) from dual;
select trunc(cast('2010-08-01 07:00:00.000000 +04:00' as timestamp with time zone)) from dual;

alter session set time_zone= '+01:00';
select trunc(cast('2010-09-01 07:00:00.000000 +04:00' as timestamp with time zone),'yy') from dual;
select trunc(cast('2010-09-01 07:00:00.000000 +04:00' as timestamp with time zone),'MM') from dual;
select trunc(cast('2010-09-01 07:00:00.000000 +04:00' as timestamp with time zone),'DD') from dual;

alter session set time_zone= '+08:00';
select trunc(cast('2010-10-01 07:00:00.000000 +04:00' as timestamp with time zone),'yy') from dual;
select trunc(cast('2010-10-01 07:00:00.000000 +04:00' as timestamp with time zone),'MM') from dual;
select trunc(cast('2010-10-01 07:00:00.000000 +04:00' as timestamp with time zone),'DD') from dual;

desc -q select trunc(cast('2010-10-01 07:00:00.000000 +04:00' as timestamp with time zone),'DD') a from dual;

--union tz
select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual union select cast('0001-01-01 01:01:01.123456 +12:00' as timestamp with time zone) from dual;

set serveroutput on;
CREATE OR REPLACE PROCEDURE plsql_Zenith_Test_current_timestamp()
IS
    c1 number;
    c2 number;
    c3 number;
    sqlstr varchar2(200);
begin
    sqlstr := 'alter session set time_zone=' || '''' || '+08:00' || '''';
    execute immediate sqlstr;
    sqlstr := 'select cast(to_char(current_timestamp(),' || '''' || 'HH24' || '''' ||') as number) from dual';
    execute immediate sqlstr into c1;

    sqlstr := 'alter session set time_zone=' || '''' || '+09:00' || '''';
    execute immediate sqlstr;
    sqlstr := 'select cast(to_char(current_timestamp(),' || '''' || 'HH24' || '''' ||') as number) from dual';
    execute immediate sqlstr into c2;

    sqlstr := 'alter session set time_zone=' || '''' || '+10:00' || '''';
    execute immediate sqlstr;
    sqlstr := 'select cast(to_char(current_timestamp(),' || '''' || 'HH24' || '''' ||') as number) from dual';
    execute immediate sqlstr into c3;

    IF c3 < c1 THEN
        c3 := c3 + 24;
    END IF;

    IF c2 < c1 THEN
        c2 := c2 + 24;
    END IF;

    IF (c3-c2)>=1 THEN
        dbe_output.print_line (TO_CHAR('ok!'));
    ELSE
        dbe_output.print_line (TO_CHAR('error!'));
    END IF;

    IF (c3-c2)<=2 THEN
        dbe_output.print_line (TO_CHAR('ok!'));
    ELSE
        dbe_output.print_line (TO_CHAR('error!'));
    END IF;

    IF (c2-c1)>=1 THEN
        dbe_output.print_line (TO_CHAR('ok!'));
    ELSE
        dbe_output.print_line (TO_CHAR('error!'));
    END IF;

    IF (c2-c1)<=2 THEN
        dbe_output.print_line (TO_CHAR('ok!'));
    ELSE
        dbe_output.print_line (TO_CHAR('error!'));
    END IF;

end;
/

call plsql_Zenith_Test_current_timestamp()
/

alter session set time_zone='+08:00';
set serveroutput off;
drop PROCEDURE plsql_Zenith_Test_current_timestamp;

--DTS2019070309413
drop table if exists test_int_add_timeltz;
CREATE TABLE test_int_add_timeltz 
(
  "COL_INT_UNSIGNED" NUMBER(38) NOT NULL,
  "COL_TIMESTAMP4" TIMESTAMP(6) WITH LOCAL TIME ZONE
);
INSERT INTO test_int_add_timeltz ("COL_INT_UNSIGNED","COL_TIMESTAMP4") values (1,'2008-08-01 00:00:00.000000');
select col_int_unsigned+col_timestamp4,col_timestamp4  from test_int_add_timeltz;
drop table test_int_add_timeltz;

--DTS2019072400696
drop table if exists t_DTS2019072400696_tab;
drop sequence if exists t_DTS2019072400696_seq;
create table t_DTS2019072400696_tab(se int, t bigint);
create sequence t_DTS2019072400696_seq;
begin
for i in 1..10000 loop
insert into t_DTS2019072400696_tab values(t_DTS2019072400696_seq.nextval, cast(UNIX_TIMESTAMP() || to_char(current_timestamp(),'ff3') as number));
end loop;
end;
/

select * from t_DTS2019072400696_tab a, t_DTS2019072400696_tab b where a.se = b.se-1 and a.t > b.t;
drop table t_DTS2019072400696_tab;
drop sequence t_DTS2019072400696_seq;
--localtimestamp Bracket
select current_timestamp()-localtimestamp() time from dual;
--FROM_TZ
--range
select FROM_TZ(TIMESTAMP '2019-07-13 02:00:00', '21:00') from dual;
select FROM_TZ(TIMESTAMP '0000-00-00 02:00:00', '9:00') from dual;
select FROM_TZ(TIMESTAMP '2019-02-29 02:00:00', '9:00') from dual;
select FROM_TZ(TIMESTAMP '2019-07-13 02:00:00', '-12:00') from dual;
--format
select FROM_TZ(TIMESTAMP '2019-07-13 02:00:00', '9') from dual;
select FROM_TZ(TIMESTAMP '2019-07-13 02:00:00', '9:00') from dual;
select FROM_TZ(TIMESTAMP '2019-07-13 02:00:00', '9:00:00') from dual; 
select FROM_TZ(TIMESTAMP '2019-07-13 02:00', '9:00') from dual;
select FROM_TZ(TIMESTAMP '2019-07-13 2', '9:00') from dual;
--parameter 
select FROM_TZ(TIMESTAMP '2019-07-13 02:00:00', 9) from dual;
select FROM_TZ('2019-07-13' '02:00:00', '9:00') from dual;
select FROM_TZ(DATE '2019-07-13 02:00:00', '9:00') from dual;
select FROM_TZ(DATE '2019-07-13', '9:00') from dual;
select FROM_TZ(current_timestamp, '9:00') from dual;
select FROM_TZ(to_timestamp('2019-07-13'), '9:00') from dual;
select from_tz(sysdate, '09:00') from dual;
select from_tz(null, '09:00') from dual;
select FROM_TZ(TIMESTAMP '2019-07-13 02:00:00', null) from dual;
drop table if exists fromtzt1;
create table fromtzt1 (a clob);
insert into fromtzt1 values('hujkl7jtyhpj0909');
select from_tz(timestamp'1999-9-8 9:00:00', a) from fromtzt1;
select from_tz(a,'9:00') from fromtzt1;
--NEXT_DAY
select next_day("9999-12-31",'mon') from dual; 

--DTS2019090201769
create table const_to_datetime(c1 int, c2 timestamp with local time zone);

declare
i int;
begin
i := 1;
Loop
insert into const_to_datetime values(i,to_timestamp('2019-12-01 23:11:11.123','yyyy-mm-dd hh24:mi:ss.ff'));
insert into const_to_datetime values(i,to_timestamp('2019-06-01 23:11:11.123','yyyy-mm-dd hh24:mi:ss.ff'));
insert into const_to_datetime values(i,to_timestamp('2019-03-01 23:11:11.123','yyyy-mm-dd hh24:mi:ss.ff'));
insert into const_to_datetime values(i,to_timestamp('2019-01-01 23:11:11.123','yyyy-mm-dd hh24:mi:ss.ff'));
i := i+1;
exit when i>5000;
end loop;
commit;
end;
/

select count(*) from const_to_datetime where c2 > '2019-03-21 11:38:34.263000';
drop table const_to_datetime;

-- case when from datetype
drop table if exists test_date;
create table test_date(f1 int, f2 date, f3 timestamp, f4 timestamp with time zone, f5 timestamp with local time zone);
insert into test_date values(1, to_date('2020-10-17 17:18:23', 'yyyy-mm-dd hh24:mi:ss'), to_timestamp('2020-10-18 12:23:34.362237', 'yyyy-mm-dd hh24:mi:ss.ff'), '2020-10-19 20:58:21.637186 +08:00', '2020-10-20 8:12:42.123456');
insert into test_date values(2, to_date('2020-10-11 17:18:23', 'yyyy-mm-dd hh24:mi:ss'), to_timestamp('2020-10-12 12:23:34.362237', 'yyyy-mm-dd hh24:mi:ss.ff'), '2020-10-13 20:58:21.637186 +08:00', '2020-10-14 8:12:42.123456');
commit;

select case when f1 < 0 then f2 else f3 end from test_date;
desc -q select case when f1 < 0 then f2 else f3 end from test_date;

select case when f1 < 0 then f2 else f4 end from test_date;
desc -q select case when f1 < 0 then f2 else f4 end from test_date;

select case when f1 < 0 then f2 else f5 end from test_date;
desc -q select case when f1 < 0 then f2 else f5 end from test_date;

select case when f1 < 0 then f3 else f4 end from test_date;
desc -q select case when f1 < 0 then f3 else f4 end from test_date;

select case when f1 < 0 then f3 else f5 end from test_date;
desc -q select case when f1 < 0 then f3 else f5 end from test_date;

select case when f1 < 0 then f4 else f5 end from test_date;
desc -q select case when f1 < 0 then f4 else f5 end from test_date;
drop table if exists test_date;

drop table if exists test_date2;
create table test_date2(f1 int[], f2 date[], f3 timestamp[], f4 timestamp with time zone[], f5 timestamp with local time zone[]);
insert into test_date2 values(array[1,2], array['2020-10-17 17:18:23', '2020-10-17 17:22:23'], array['2020-10-17 17:18:23.123456', '2020-10-17 17:22:23.123456'], array['2020-10-19 20:58:21.637186 +08:00', '2020-10-19 20:12:21.637186 +08:00'], array['2020-10-20 8:12:42.123456', '2020-10-20 18:12:42.123456']);
commit;

select case when f1[1] < 0 then f2 else f3 end from test_date2;
desc -q select case when f1[1] < 0 then f2 else f3 end from test_date2;

select case when f1[1] < 0 then f2 else f4 end from test_date2;
desc -q select case when f1[1] < 0 then f2 else f4 end from test_date2;

select case when f1[1] < 0 then f2 else f5 end from test_date2;
desc -q select case when f1[1] < 0 then f2 else f5 end from test_date2;

select case when f1[1] < 0 then f3 else f4 end from test_date2;
desc -q select case when f1[1] < 0 then f3 else f4 end from test_date2;

select case when f1[1] < 0 then f3 else f5 end from test_date2;
desc -q select case when f1[1] < 0 then f3 else f5 end from test_date2;

select case when f1[1] < 0 then f4 else f5 end from test_date2;
desc -q select case when f1[1] < 0 then f4 else f5 end from test_date2;
drop table if exists test_date2;