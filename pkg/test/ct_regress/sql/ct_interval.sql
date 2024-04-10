--- DDL tese cases
-- 1.1 ISO8601 format for YM_INTERVAL
select cast('P123Y999999M' as interval year to month) from dual;
select cast('-P0Y123M' as interval year to month) from dual;
select cast('-P0123M' as interval year to month) from dual;
select cast('P123Y999999M' as interval year to month) from dual;
select cast('-P0Y123M' as interval year to month) from dual;
select cast('-P0123M23D' as interval year to month) from dual;
select cast('   +P0Y123M' as interval year to month) from dual;
select cast('-P0Y0M' as interval year to month) from dual;
select cast('-P0Y0D' as interval year to month) from dual;
select cast('-P0YT0S' as interval year to month) from dual;
select cast('-P12M' as interval year to month) from dual;
select cast('-P9999Y' as interval year to month) from dual;
select cast('-P99999M' as interval year to month) from dual;
select cast('P9999Y999999M123213D' as interval year to month) from dual;
select cast('-P9999Y11M' as interval year to month) from dual;
select cast('P9999Y11M' as interval year to month) from dual;

-- 1.2 invalid cases
select cast('-P19999Y' as interval year to month) from dual;
select cast('-P1000000M' as interval year to month) from dual;
select cast('P123Y9999999900000000' as interval year to month) from dual;
select cast('-P0Y123m' as interval year to month) from dual;
select cast('-P99999M' as interval year to month) from dual;
select cast('-P9999Y999999M' as interval year to month) from dual;
select cast('P9999Y999999M' as interval year to month) from dual;
select cast('-PP0Y123m' as interval year to month) from dual;
select cast('-P10000Y123M' as interval year to month) from dual;
select cast('-P9999Y12M' as interval year to month) from dual;
select cast('-P100Y9999999999M' as interval year to month) from dual;
select cast('' as interval year to month) from dual;
select cast('-' as interval year to month) from dual;
select cast('-P012.3M23D' as interval year to month) from dual;
select cast('-P012.M28D' as interval year to month) from dual;
select cast('-P012M28DT21.H' as interval year to month) from dual;
select cast('-P012M28DT21.123H' as interval year to month) from dual;
select cast('-P012M28DT21H213.S' as interval year to month) from dual;
select cast('-   P0Y123M' as interval year to month) from dual;
select cast('  P0Y123M' as interval year to month) from dual;
select cast(' + P0Y123M' as interval year to month) from dual;
select cast('-P1' as interval year to month) from dual;
select cast('-P12' as interval year to month) from dual;
select cast('-PY' as interval year to month) from dual;
select cast('-PYM' as interval year to month) from dual;
select cast('-P0Y0' as interval year to month) from dual;
select cast('-P0Y0T' as interval year to month) from dual;
select cast('-P0Y0S' as interval year to month) from dual;
select cast('-P0YT0' as interval year to month) from dual;
select cast('-P0YT00' as interval year to month) from dual;
select cast('-P0YT00M' as interval year to month) from dual;
select cast('-P   12M' as interval year to month) from dual;
select cast('-P12M12Y' as interval year to month) from dual;
select cast('-PT12M12H' as interval year to month) from dual;
select cast('-PT12M12H' as interval day to second) from dual;
select cast('-P12M100000.12S' as interval year to month) from dual;
select cast('-P12M10000012S' as interval year to month) from dual;
select cast('-P1.2M100000D' as interval year to month) from dual;
select cast('P9999Y999999MT123213D' as interval year to month) from dual;

-- 2.1 SQL format  for YM_INTERVAL
select cast('-  1233 -  2' as interval year to month) from dual;
select cast('1233-0' as interval year to month) from dual;
select cast('-  1233 -  2' as interval year to month) from dual;
select cast('1233-00000000000000003' as interval year to month) from dual;
select cast('-0000000001233-00000000000000003' as interval year to month) from dual;
select cast('-     0000000001233-00000000000000003' as interval year to month) from dual;
select cast('     -     0000000001233-00000000000000003' as interval year to month) from dual;
select cast('        22		-3' as interval year to month) from dual;
select cast('        +0-0000003' as interval year to month) from dual;
select cast('+ 9999 - 11' as interval year to month) from dual;
select cast('+ 9990 - 000000000000000000000000000000000000000' as interval year to month) from dual;

-- 2.2 invalid cases
select cast('12332-12' as interval year to month) from dual;
select cast('1233-12' as interval year to month) from dual;
select cast('1233-00000000000000003.2' as interval year to month) from dual;
select cast('- +1233-00000000000000003' as interval year to month) from dual;
select cast('+  000-0000000000000.000' as interval year to month) from dual;
select cast('1233-00000000000000003h' as interval year to month) from dual;
select cast('1s33-00000000000000003h' as interval year to month) from dual;
select cast('h' as interval year to month) from dual;
select cast('        ' as interval year to month) from dual;
select cast('        -2' as interval year to month) from dual;
select cast('        22' as interval year to month) from dual;
select cast('        223' as interval year to month) from dual;
select cast('        -223' as interval year to month) from dual;
select cast('        22' as interval year to month) from dual;
select cast('        22-12' as interval year to month) from dual;
select cast('        22+12' as interval year to month) from dual;
select cast('        22--0' as interval year to month) from dual;
select cast('        22-' as interval year to month) from dual;
select cast('        -220-' as interval year to month) from dual;
select cast('        22            ' as interval year to month) from dual;
select cast('        22 - 123123123123           ' as interval year to month) from dual;
select cast('+ 9999 - 12' as interval year to month) from dual;
select cast('+ 99990 - 11' as interval year to month) from dual;
select cast('+ 9999.0 - 11' as interval year to month) from dual;
select cast('+ 9990 - 0.11' as interval year to month) from dual;

-- 3.1 ISO8601 for DS_INTERVAL
select cast('-PT23H23M23S' as interval day to second) from dual;
select cast('-PT23H23M23.003333S' as interval day to second) from dual;
select cast('-PT23H23M23.003333999S' as interval day to second) from dual;
select cast('-PT23H23M23.00333999S' as interval day to second) from dual;
select cast('-PT23H23M23.00333999S' as interval day to second) from dual;
select cast('PT999999M' as interval day to second) from dual;
select cast('PT123123S' as interval day to second) from dual;
select cast('PT12312.3S' as interval day to second) from dual;
select cast('PT12312.999999999999S' as interval day to second) from dual;
select cast('PT12H312.999999999999S' as interval day to second) from dual;
select cast('PT12H312.999S      ' as interval day to second) from dual;

-- 3.2 invalid cases
select cast('-P012M28DT21H213.00B' as interval day to second) from dual;
select cast('-P012M28DT21H213.00SB' as interval day to second) from dual;
select cast('-P012M28DT21H213.02.130SB' as interval day to second) from dual;
select cast('P999999M' as interval day to second) from dual;
select cast('P999999DTT' as interval day to second) from dual;
select cast('P999999DTT123123' as interval day to second) from dual;
select cast('T123123' as interval day to second) from dual;
select cast('PT123123' as interval day to second) from dual;
select cast('PT123123M123H' as interval day to second) from dual;
select cast('PT12.3H312.999999999999S' as interval day to second) from dual;
select cast('P12YT12.3H312.999999999999S' as interval day to second) from dual;
select cast('P12TT12.3H312.999S' as interval day to second) from dual;
select cast('PT12H312.999ST' as interval day to second) from dual;
select cast('PT12H312.999S   T' as interval day to second) from dual;

-- 4.1 SQL format  for ds_INTERVAL
select cast('12 12:12:12           ' as interval day to secOND) from dual;
select cast('-0 0:0:0' as interval day to secOND) from dual;
select cast('9999999 23:59:59.999999' as interval day to secOND) from dual;
select cast('  -     00012    0012   :  00012 : 000000000000012           ' as interval day to secOND) from dual; 
select cast('+     00012    0012   :  00012 : 000000000000012           ' as interval day to secOND) from dual;
select cast('+     0    0   :  0 : 0           ' as interval day to secOND) from dual;
select cast('009999999 0023:0059:0059.999999000123' as interval day to secOND) from dual;
select cast('009999999 0022:0059:0059.999999800123' as interval day to secOND) from dual;
select cast('+00123 12:019:59.00' as interval day to secOND) from dual;
select cast('+00123 12:019:59.000012888' as interval day to secOND) from dual;
select cast('+00123 12:019:0.00' as interval day to secOND) from dual;
select cast('+00123 12:019:0.999999999' as interval day to secOND) from dual;
select cast('+00123 12:019:0.000999999999' as interval day to secOND) from dual;
select cast('+00123 12:00000000000000000000000000000000000000000000000000000000000019:0.000999999999' as interval day to secOND) from dual;
select cast('00999999 0023:0059:0059.9999995000123' as interval day to secOND) from dual;

-- 4.2 invalid cases  -- SQL format  for ds_INTERVAL
select cast('+00123' as interval day to secOND) from dual;
select cast('009999999 0023:0059:0059.999999800123' as interval day to secOND) from dual;
select cast('0019999999 0022:0059:0059.999999800123' as interval day to secOND) from dual;
select cast('00 0025:0059:0059.999999800123' as interval day to secOND) from dual;
select cast('00 00:0159:0059.999999800123' as interval day to secOND) from dual;
select cast('00 00:019:959.999999800123' as interval day to secOND) from dual;
select cast('0.0 00:019:959.999999800123' as interval day to secOND) from dual;
select cast('+00123 12.3:019:959.999999800123' as interval day to secOND) from dual;
select cast('+00123 12 019:959.999999800123' as interval day to secOND) from dual;
select cast('+00123 12:59' as interval day to secOND) from dual;
select cast('+00123 12:019:59.' as interval day to secOND) from dual;
select cast('+00123 12:019:59.7o' as interval day to secOND) from dual;
select cast('+00123 12:019:59.000000000c' as interval day to secOND) from dual;
select cast('+00123 12::019:59.00' as interval day to secOND) from dual;
select cast('+00123 12:019:.00' as interval day to secOND) from dual;
select cast('009999999 0023:0059:0059.9999995000123' as interval day to secOND) from dual;

--- 5. function TO_YMINTERVAL & TO_DSINTERVAL
select to_dsinterval('9999999 12:21:12.2323999999');
select to_yminterval('9-10');

-- 5.2 invalid cases
select to_yminterval('9999999 12:21:12.2323999999');
select to_dsinterval('9-10');
select to_dsinterval(''::bool);
-- merely string is allowed
select to_dsinterval(123);
select to_dsinterval(sysdate);
select to_dsinterval(TRUE);
select to_yminterval(123);
select to_yminterval(sysdate);
select to_yminterval(FALSE);

--- 6.5 interval column
-- 6.5.1 yminterval test
drop table if exists PFA_YMITVL;
create table PFA_YMITVL(id int, ymval interval year(4) to month);
insert into  PFA_YMITVL values(1, '1231-2');
insert into  PFA_YMITVL values(2, 'P12Y');
insert into  PFA_YMITVL values(3, 'P12YT12H');
insert into  PFA_YMITVL values(4, 'P1Y55MT12H');
insert into  PFA_YMITVL values(5, '-P1Y55MT12H');
insert into  PFA_YMITVL values(6, '-100-11');
-- Error cases
insert into  PFA_YMITVL values(7, 123123);
insert into  PFA_YMITVL values(8, '123-123');
insert into  PFA_YMITVL values(9, '1231-23');

select * from PFA_YMITVL order by id;
select * from PFA_YMITVL order by ymval;
select * from PFA_YMITVL where ymval = '-P100Y11Md';
select * from PFA_YMITVL where ymval = '-P100Y11M';
select * from PFA_YMITVL where ymval > 'P100Y11M';
select * from PFA_YMITVL where ymval < 123;
select sum(ymval) from PFA_YMITVL;
select count(ymval) from PFA_YMITVL;
select min(ymval), max(ymval) from PFA_YMITVL;

update PFA_YMITVL set ymval = '111-11' where ymval < '-0-0';
select * from PFA_YMITVL order by id;
delete PFA_YMITVL where ymval < 'P111Y11M';
select * from PFA_YMITVL order by id;

-- index test
delete from PFA_YMITVL;
CREATE INDEX Idx_PFA_YMITVL_ymval ON PFA_YMITVL(ymval);
insert into  PFA_YMITVL values(1, '1231-2');
insert into  PFA_YMITVL values(2, 'P12Y');
insert into  PFA_YMITVL values(3, 'P1Y55MT12H');
insert into  PFA_YMITVL values(4, '-P1Y55MT12H');
insert into  PFA_YMITVL values(5, '-100-11');
select * from PFA_YMITVL where ymval > to_yminterval('P100Y11M');
select * from PFA_YMITVL where ymval > to_dsinterval('P100Y11M');

-- 6.5.2 dsinterval test
drop table if exists PFA_dsitvl;
create table PFA_dsitvl(id int, dsval interval day(7) to second);
insert into  PFA_dsitvl values(1, '1231 12:3:4.1234');
insert into  PFA_dsitvl values(2, 'P1231DT16H3.3333333S');
insert into  PFA_dsitvl values(3, 'PT12H');
insert into  PFA_dsitvl values(4, '-P99DT655M999.99999S');
insert into  PFA_dsitvl values(5, '-0 00:19:7.7777777777');
insert into  PFA_dsitvl values(6, '-1234 0:0:0.0004');
-- Error cases
insert into  PFA_dsitvl values(7, 123123);
insert into  PFA_dsitvl values(8, '123 123:123:12');
insert into  PFA_dsitvl values(9, '1231-23');

select * from PFA_dsitvl order by id;
select * from PFA_dsitvl order by dsval;
select * from PFA_dsitvl where dsval = '0000 12:0000:0.000000';
select * from PFA_dsitvl where dsval = '0000 12:0000:0.000000S';
select * from PFA_dsitvl where dsval > 'P0000DT00000012H0000M0.0000S';
select * from PFA_dsitvl where dsval < 123;
select sum(dsval) from PFA_dsitvl;
select count(dsval) from PFA_dsitvl;
select min(dsval), max(dsval) from PFA_dsitvl;

update PFA_dsitvl set dsval = 'P999999D' where dsval < '-0 0:0:0';
select * from PFA_dsitvl order by id;
delete PFA_dsitvl where dsval > 'P999998DT59.99999S';
select * from PFA_dsitvl order by id;

-- index test
delete from PFA_dsitvl;
CREATE INDEX Idx_PFA_dsitvl_dsval ON PFA_dsitvl(dsval);
insert into  PFA_dsitvl values(1, '111111 11:11:11.111111111');
insert into  PFA_dsitvl values(2, '222222 22:22:22.222222222');
insert into  PFA_dsitvl values(3, 'P333333DT33M33.333333S');
insert into  PFA_dsitvl values(4, '-P4444DT44M44.44444444S');
insert into  PFA_dsitvl values(5, '000 0000000:0:000000.0000');
select * from PFA_dsitvl where dsval > to_dsinterval('P123456D');
select * from PFA_dsitvl where dsval < to_dsinterval('-000000000 0:0:0000000000000000000000.00000000000');
select * from PFA_dsitvl where dsval > to_yminterval('P123456D');
select * from PFA_dsitvl where dsval > to_yminterval('ABCDEFGHIJKLMN');

-- default values
drop table if exists PFA_dsitvl_def;
create table PFA_dsitvl_def(id int, dsval interval day to second default 'P0D'||'T'||'0H0M0S');
insert into  PFA_dsitvl_def values(1, default);
select * from PFA_dsitvl_def;

drop table if exists PFA_YMITVL_DEF;
create table PFA_YMITVL_DEF(id int, ymval interval year to month default '0-0');
insert into  PFA_YMITVL_DEF values(1, default);
select * from PFA_YMITVL_DEF;

--- 7. function NUMTOYMINTERVAL & NUMTODSINTERVAL
-- test cases for NUMTOYMINTERVAL
select numtoyminterval(9999.9, '    year') from dual;
select numtoyminterval(9999.999999999999, 'year') from dual;
select numtoyminterval(9999.9999999999999, 'year') from dual;
select numtoyminterval(9999.9, '    month') from dual;
select numtoyminterval(12 + sysdate, '    month') from dual;
select numtoyminterval('123', 'month') from dual;
select numtoyminterval('123', 3.2) from dual;
select numtoyminterval('123', systimestamp) from dual;
select numtoyminterval('123', 'systimestamp') from dual;
select numtoyminterval('123', 'systimestamp' + 3.2) from dual;
select numtoyminterval(99999.9, 'month') from dual;
select numtoyminterval(99999.9999999999, 'month') from dual;
select numtoyminterval(99999.99999999999, 'month') from dual;
select numtoyminterval(99999.999999999999, 'month') from dual;
select numtoyminterval(-99999.9999999999, 'month') from dual;
select numtoyminterval(-'123', 'month') from dual;
select numtoyminterval(-'-123', 'year') from dual;
select numtoyminterval(+3.1425926535897932384626, 'year') from dual;
select numtoyminterval(+3.1425926535897932384626, -'year') from dual;
select numtoyminterval(-3.1425926535897932384626, 'month') from dual;
select numtoyminterval(9999.95, 'year') from dual;
select numtoyminterval(9999.96, 'year') from dual;
select numtoyminterval(-9999.95, 'year') from dual;
select numtoyminterval(-9999.96, 'year') from dual;

-- test cases for NUMTODSINTERVAL
select numtodsinterval(3.1425926535897932384626, 'DAY') from dual;
select numtodsinterval(3.1425926535897932384626, 'HOUR') from dual;
select numtodsinterval(3.1425926535897932384626, 'MINUTE') from dual;
select numtodsinterval(3.1425926535897932384626, 'SECOND') from dual;
select numtodsinterval(999999, 'DAY') from dual;
select numtodsinterval(-10000000, 'DAY') from dual;
select numtodsinterval(9999999.000000001, 'DAY') from dual;
select numtodsinterval(9999999.00000001, 'DAY') from dual;
select numtodsinterval(9999999.000001, 'DAY') from dual;
select numtodsinterval(9999999.000001, 'hoUr') from dual;
select numtodsinterval(999999999, 'Hour') from dual;
select numtodsinterval(99999999, 'Hour') from dual;
select numtodsinterval(99999999.9999999999, 'Hour') from dual;
select numtodsinterval(99999999.99999, 'Hour') from dual;
select numtodsinterval(99999999.9999, 'Hour') from dual;
select numtodsinterval(99999999.999, 'Hour') from dual;
select numtodsinterval(999999999.99, 'minute') from dual;
select numtodsinterval(999999999.999999, 'minute') from dual;
select numtodsinterval(999999999.99999, 'minute') from dual;
select numtodsinterval(999999999.99999, 'second') from dual;
select numtodsinterval(1999999999.99999, 'second') from dual;
select numtodsinterval(1999999999.99999, 'year') from dual;
select numtodsinterval(1999999999.99999, 1234.23) from dual;
select numtodsinterval(1999999999.99999, systimestamp) from dual;
select numtodsinterval(sysdate, 'second') from dual;


--- 8. interval expr
select to_date('2018-05-14', 'YYYY-MM-DD') + numtodsinterval(1, 'DAY') from dual;
select numtodsinterval(1, 'DAY') + to_date('2018-05-14', 'YYYY-MM-DD') from dual;
select to_date('2018-05-14', 'YYYY-MM-DD') - numtodsinterval(1, 'DAY') from dual;

select to_timestamp('2018-05-14', 'YYYY-MM-DD') + numtodsinterval(1, 'DAY') from dual;
select numtodsinterval(1, 'DAY') + to_timestamp('2018-05-14', 'YYYY-MM-DD') from dual;
select to_timestamp('2018-05-14', 'YYYY-MM-DD') - numtodsinterval(1, 'DAY') from dual;
select to_date('2018-05-14', 'YYYY-MM-DD') + numtodsinterval(9999999, 'DAY') from dual;
select to_timestamp('2018-05-14', 'YYYY-MM-DD') - numtodsinterval(999999, 'DAY') from dual;

select numtodsinterval(1, 'DAY') - numtodsinterval(999999, 'DAY') from dual;
select numtodsinterval(1, 'DAY') - numtoyminterval(999, 'year') from dual;
select numtodsinterval(-1, 'DAY') - numtodsinterval(9999999, 'DAY') from dual;
select numtodsinterval(-1, 'DAY') + numtodsinterval(9999999, 'DAY') from dual;
select numtodsinterval(22, 'HOUR') + numtodsinterval(9999999, 'DAY') from dual;
select numtodsinterval(24, 'HOUR') + numtodsinterval(9999999, 'DAY') from dual;
select numtoyminterval(24, 'month') + numtoyminterval(9, 'month') from dual;
select numtoyminterval(24, 'month') - numtoyminterval(9, 'month') from dual;
select numtoyminterval(24, 'month') + numtoyminterval(9998, 'year') from dual;
select numtoyminterval(8888, 'month') - numtoyminterval(987.99, 'month') from dual;

select numtodsinterval(1, 'DAY') / 2::integer from dual;
select numtodsinterval(1, 'DAY') / 5::bigint from dual;
select numtodsinterval(1, 'DAY') / 1.33::real from dual;
select numtodsinterval(1, 'DAY') / 1.33::number from dual;
select numtodsinterval(1, 'DAY') / 1.33::real from dual;
select numtodsinterval(1, 'DAY') / 0::real from dual;
select numtodsinterval(1, 'DAY') / 1E-20::real from dual;
select numtodsinterval(1, 'DAY') / 1E-10 from dual;
select numtodsinterval(1, 'DAY') / 1E-300::number from dual;
select numtodsinterval(1, 'DAY') / 1E-125 from dual;
select 30/numtodsinterval(1, 'DAY') from dual;
select numtodsinterval(1, 'DAY') / sysdate from dual;
select numtodsinterval(1, 'DAY') / 1.0E-5 from dual;
select numtodsinterval(1, 'DAY') / '1.0E-5' from dual;
select numtodsinterval(1, 'DAY') / '1.0E-5.' from dual;
select numtodsinterval(1, 'D'||'A'||'Y') / 1.33::real from dual;
 
select numtoyminterval(1, 'year') / 2::integer from dual;
select numtoyminterval(1, 'year') / 5::bigint from dual;
select numtoyminterval(1, 'year') / 7 from dual;
select numtoyminterval(1, 'year') / 1.33::real from dual;
select numtoyminterval(1, 'year') / 1.33::number from dual;
select numtoyminterval(1, 'year') / 1.33::real from dual;
select numtoyminterval(1, 'year') / 0::real from dual;
select numtoyminterval(1, 'year') / 1E-20::real from dual;
select numtoyminterval(1, 'year') / 1E-10 from dual;
select numtoyminterval(1, 'year') / 1.0E-5 from dual;
select numtoyminterval(1, 'year') / 1E-300::number from dual;
select numtoyminterval(1, 'year') / 1E-125 from dual;
select 30/numtoyminterval(1, 'year') from dual;
select numtoyminterval(1, 'year') / sysdate from dual;
select numtoyminterval(1, 'year') / '1.0E-5.' from dual;
select numtoyminterval(1, 'year') / '1.0E-5' from dual;
select numtoyminterval(1, 'year') / '1.0E-2' from dual;

select numtodsinterval(1, 'day') * 2::integer from dual;
select numtodsinterval(1, 'day') * 5::bigint from dual;
select numtodsinterval(1, 'day') * 7 from dual;
select numtodsinterval(1, 'day') * 1.33::real from dual;
select numtodsinterval(1, 'day') * 1.33::number from dual;
select numtodsinterval(1, 'day') * 0::real from dual;
select numtodsinterval(1, 'day') * -99999999::real from dual;
select numtodsinterval(1, 'day') * sysdate from dual;
select numtodsinterval(1, 'day') * '1.0E-5.' from dual;
select numtodsinterval(1000, 'day') * '1.0E-5' from dual;
select numtodsinterval(1000, 'day') * '1.0E-2' from dual;
select numtodsinterval(0.0000001, 'day') * 1.0E10 from dual;
select numtodsinterval(0.01, 'day') * 1.0E10::real from dual;
select numtodsinterval(0.0000000001, 'day') * 1.0E10 from dual;
select numtodsinterval(0.1, 'day') * 1.0E10::real from dual;
select numtodsinterval(500, 'day') * 300000 from dual;

select numtoyminterval(1, 'year') * 2::integer from dual;
select numtoyminterval(1, 'year') * 5::bigint from dual;
select numtoyminterval(1, 'year') * 7 from dual;
select numtoyminterval(1, 'year') * 1.33::real from dual;
select numtoyminterval(1, 'year') * 1.33::number from dual;
select numtoyminterval(1, 'year') * 0::real from dual;
select numtoyminterval(1, 'year') * -99999::real from dual;
select numtoyminterval(1, 'year') * sysdate from dual;
select numtoyminterval(1, 'year') * '1.0E-5.' from dual;
select numtoyminterval(1000, 'year') * '1.0E-5' from dual;
select numtoyminterval(1000, 'year') * '1.0E-2' from dual;
select numtoyminterval(0.01, 'year') * 1.0E10 from dual;
select numtoyminterval(0.01, 'year') * 1.0E10::real from dual;
select numtoyminterval(0.1, 'year') * 1.0E10::real from dual;
select numtoyminterval(500, 'year') * 300 from dual;

select 123::int * numtodsinterval(1, 'day') from dual;
select 123::bigint * numtodsinterval(1, 'day') from dual;
select 123::real * numtodsinterval(1, 'day') from dual;
select 123::decimal * numtodsinterval(1, 'day') from dual;
select '123' * numtodsinterval(1, 'day') from dual;
select '123 * 100' * numtodsinterval(1, 'day') from dual;
select 123E5 * numtodsinterval(1, 'day') from dual;
select 0.00003 * numtodsinterval(1, 'day') from dual;
select 99999999 * numtodsinterval(1, 'day') from dual;
select systimestamp * numtodsinterval(1, 'day') from dual;
select numtoyminterval(0.1, 'year') * numtodsinterval(1, 'day') from dual;

select 123::int * numtoyminterval(1, 'year') from dual;
select 123::bigint * numtoyminterval(1, 'year') from dual;
select 123::real * numtoyminterval(1, 'year') from dual;
select 123::decimal * numtoyminterval(1, 'year') from dual;
select '123' * numtoyminterval(1, 'year') from dual;
select '123 * 100' * numtoyminterval(1, 'year') from dual;
select 123E2 * numtoyminterval(1, 'year') from dual;
select 0.3 * numtoyminterval(1, 'year') from dual;
select 9999 * numtoyminterval(1.1, 'year') from dual;
select 99999 * numtoyminterval(0.5, 'year') from dual;

select to_date('2018-01-31', 'YYYY-MM-DD') + numtoyminterval(1, 'year') from dual;
select numtoyminterval(1, 'year') + to_date('2018-01-31', 'YYYY-MM-DD') from dual;
select to_date('2018-01-31', 'YYYY-MM-DD') + numtoyminterval(1, 'month') from dual;
select to_date('2018-01-31', 'YYYY-MM-DD') + numtoyminterval(8888, 'year') from dual;
select to_date('2018-01-31', 'YYYY-MM-DD') - numtoyminterval(8888, 'year') from dual;
select to_date('2018-01-31', 'YYYY-MM-DD') + numtoyminterval(-1, 'year') from dual;
select to_date('2016-02-29', 'YYYY-MM-DD') + to_yminterval('P1Y')  from dual;
select to_date('2016-07-31', 'YYYY-MM-DD') + to_yminterval('P1M')  from dual;
select to_date('2016-07-31', 'YYYY-MM-DD') + to_yminterval('P2M')  from dual;
select to_timestamp('2017-07-31 23:12:11.12313', 'YYYY-MM-DD HH24:MI:SS.FF') + to_yminterval('P1M')  from dual;
select to_timestamp('2017-07-31 23:12:11.12313', 'YYYY-MM-DD HH24:MI:SS.FF') + to_yminterval('P2M')  from dual;
select to_yminterval('P3M') - sysdate from dual;

select to_date('9999-05-23 11', 'YYYY-MM-DD HH24') - to_date('2018-01-01 00', 'YYYY-MM-DD HH24') from dual;
select to_char(to_date('9999-05-23 11', 'YYYY-MM-DD HH24') - to_date('2018-01-01 00', 'YYYY-MM-DD HH24')) from dual;
select to_date('9999-05-23 11', 'YYYY-MM-DD HH24') - to_timestamp('2018-01-01 00', 'YYYY-MM-DD HH24') from dual;
select to_timestamp('9999-05-23 11', 'YYYY-MM-DD HH24') - to_timestamp('2018-01-01 00', 'YYYY-MM-DD HH24') from dual;
select to_timestamp('9999-05-23 11', 'YYYY-MM-DD HH24') - to_date('2018-01-01 00', 'YYYY-MM-DD HH24') from dual;

select * from dual where sysdate - systimestamp < '0 0:0:30';
select * from dual where sysdate - sysdate < '0 0:0:30';
select * from dual where systimestamp - systimestamp < '0 0:0:30';
select * from dual where sysdate - sysdate < 0.1;

-- 7. limit the interval to the specified precisions
drop table if exists PFA_YMINTERVAL_02;
create table PFA_YMINTERVAL_02(id int, ymval interval year(1) to mon);
create table PFA_YMINTERVAL_02(id int, ymval interval year(123) to month);
create table PFA_YMINTERVAL_02(id int, ymval interval year(2) to month);
insert into PFA_YMINTERVAL_02 values(1, '21-11');
insert into PFA_YMINTERVAL_02 values(2, '121-11');
insert into PFA_YMINTERVAL_02 values(3, 'P1200M');
insert into PFA_YMINTERVAL_02 values(4, '-P1200M');
insert into PFA_YMINTERVAL_02 values(5, '-P1199M');
select * from PFA_YMINTERVAL_02 order by id;

drop table if exists PFA_YMINTERVAL_03;
create table PFA_YMINTERVAL_03(id int, ymval interval year(0) to month);
insert into PFA_YMINTERVAL_03 values(1, '21-11');
insert into PFA_YMINTERVAL_03 values(2, '0-11');
insert into PFA_YMINTERVAL_03 values(3, '-1-11');
insert into PFA_YMINTERVAL_03 values(4, '-0-11');
select * from PFA_YMINTERVAL_03 order by id;

drop table if exists PFA_DSINTERVAL_02;
create table PFA_DSINTERVAL_02(id int, dsval interval day(30) to second);
create table PFA_DSINTERVAL_02(id int, dsval interval day(3) to second(30));
create table PFA_DSINTERVAL_02(id int, dsval interval day(3) to second(4));
insert into  PFA_DSINTERVAL_02 values(1, '000 0000000:0:000000.213456');
insert into  PFA_DSINTERVAL_02 values(2, '999 0000000:0:000000.75769999999');
insert into  PFA_DSINTERVAL_02 values(3, '1000 0000000:0:000000.1239');
insert into  PFA_DSINTERVAL_02 values(3, '999 23:59:59.79999');
insert into  PFA_DSINTERVAL_02 values(4, '999 23:59:59.99999');
insert into  PFA_DSINTERVAL_02 values(5, '-11233 23:59:59.99999');
select * from PFA_DSINTERVAL_02 order by id;

drop table if exists PFA_DSINTERVAL_03;
create table PFA_DSINTERVAL_03(id int, dsval interval day(0) to second(0));
insert into  PFA_DSINTERVAL_03 values(1, '000 0000000:0:000000.213456');
insert into  PFA_DSINTERVAL_03 values(2, '0 23:0:000000.1239');
insert into  PFA_DSINTERVAL_03 values(3, 'PT24H');
insert into  PFA_DSINTERVAL_03 values(4, '-1 23:0:000000.1239');
insert into  PFA_DSINTERVAL_03 values(5, '-00 23:59:59.123765');
insert into  PFA_DSINTERVAL_03 values(6, '-00 23:59:59.523765');
select * from PFA_DSINTERVAL_03 order by id;

--DAYTOSECOND INTERVAL
select INTERVAL '4 5:12:10.222' DAY TO SECOND from dual;
select INTERVAL '4 5:12' DAY TO MINUTE from dual;
select INTERVAL '400 5' DAY(3) TO HOUR from dual;
select interval '400' DAY(3) from dual;
select INTERVAL '11:12:10.222222' HOUR TO SECOND from dual;
select INTERVAL '11:20' HOUR TO MINUTE from dual;
SELECT INTERVAL '10' MINUTE FROM DUAL;
SELECT INTERVAL '4' DAY	FROM DUAL;
SELECT INTERVAL '25' HOUR FROM DUAL;
SELECT INTERVAL '120' HOUR(3) FROM DUAL;
SELECT INTERVAL '12:12' HOUR FROM DUAL;
select interval '400 5' DAY(3) from dual;

--YEARTOMONTH INTERVAL
select INTERVAL '123-2' YEAR(3) TO MONTH from dual;
select INTERVAL '123-1' YEAR(3) from dual;
select INTERVAL '300' MONTH(3) from dual;
SELECT INTERVAL '4' YEAR FROM DUAL;
SELECT INTERVAL '50' MONTH FROM DUAL;

--interval calc
SELECT INTERVAL '3-11' YEAR TO MONTH + 1 FROM DUAL;
SELECT INTERVAL '3-11' YEAR TO MONTH + TO_DATE('2017-01-01','YYYY-MM-DD') FROM DUAL;
SELECT INTERVAL '3-11' YEAR TO MONTH + INTERVAL '10' SECOND FROM DUAL;
SELECT INTERVAL '3' YEAR + INTERVAL '12' MONTH FROM DUAL;
SELECT INTERVAL '3 23:59:59' DAY TO SECOND + INTERVAL '0.9994' SECOND(2,3) FROM DUAL;
SELECT INTERVAL '3 23:59:59' DAY TO SECOND + INTERVAL '0.9995' SECOND(2,3) FROM DUAL;
SELECT 1 FROM DUAL WHERE (INTERVAL '1' DAY + INTERVAL '11:11:11.1111' HOUR TO SECOND(3)) = TO_DSINTERVAL('1 11:11:11.111');

SELECT INTERVAL '400' DAY(3) TO DAY FROM DUAL;
SELECT INTERVAL '200' YEAR(3) TO YEAR FROM DUAL;
SELECT INTERVAL '200 - 12' YEAR(3) TO MONTH FROM DUAL;
SELECT INTERVAL '400' DAY(3) TO SECOND FROM DUAL;
SELECT INTERVAL '1 24:00:00' DAY TO SECOND FROM DUAL;
SELECT INTERVAL '1 23:60:00' DAY TO SECOND FROM DUAL;
SELECT INTERVAL '1 23:59:60' DAY TO SECOND FROM DUAL;

SELECT INTERVAL '200' year(5) FROM DUAL;
SELECT INTERVAL '200' SECOND(9,2) FROM DUAL;
SELECT INTERVAL '24:00:00' HOUR TO SECOND FROM DUAL;
SELECT INTERVAL '60:20' MINUTE TO SECOND FROM DUAL;
SELECT INTERVAL '200' SECOND FROM DUAL;
SELECT TO_DSINTERVAL('-1 0023:59:59.003333791')/-10 from dual; 
SELECT TO_YMINTERVAL('-3-2')/-10 from dual; 

select to_date('2020-02-29', 'YYYY-MM-DD') - interval '1' year from dual;
select to_date('2020-02-29', 'YYYY-MM-DD') - interval '12' month from dual;
select to_date('2020-02-29', 'YYYY-MM-DD') - NUMTOYMINTERVAL(1, 'year') from dual;
select to_date('2020-02-29', 'YYYY-MM-DD') - NUMTOYMINTERVAL(12, 'month') from dual;
select to_date('2020-02-29', 'YYYY-MM-DD') - TO_YMINTERVAL('01-00') from dual;

select to_date('2020-3-31', 'YYYY-MM-DD') + interval '1' month from dual;
select to_date('2020-4-30', 'YYYY-MM-DD') - interval '2' month from dual;

select to_date('2020-2-29', 'YYYY-MM-DD') - NUMTODSINTERVAL(366, 'day') from dual;
select to_date('2020-2-29', 'YYYY-MM-DD') + NUMTODSINTERVAL(365, 'day') from dual;
select INTERVAL '123' MONTH(3.4) from dual;
select INTERVAL '1' year(2.5) from dual;