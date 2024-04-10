-- CAST test
select cast(100 as timestamp) from dual;
select cast('100' as timestamp) from dual;
select cast(21E10 as timestamp) from dual;
select cast('21E10' as timestamp) from dual;
select cast(4294967296 as timestamp) from dual;
select cast('4294967296' as timestamp) from dual;
select cast(4294967296e200 as timestamp) from dual;
select cast('4294967296e200' as timestamp) from dual;
select cast(100 as raw(100)) from dual;
select cast(1.00 as raw(100)) from dual;
select cast('1.00' as raw(100)) from dual;
select cast(100E200 as raw(100)) from dual;
select cast('100E20' as raw(100)) from dual;

select cast(sysdate as int) from dual;
select cast(sysdate as bigint) from dual;
select cast(sysdate as real) from dual;
select cast(sysdate as decimal) from dual;
select cast(sysdate as raw(100)) from dual;

select cast(systimestamp as int) from dual;
select cast(systimestamp as bigint) from dual;
select cast(systimestamp as real) from dual;
select cast(systimestamp as decimal) from dual;
select cast(systimestamp as raw(100)) from dual;

select cast(null as int) from dual;
select cast(null as bigint) from dual;
select cast(null as real) from dual;
select cast(null as number) from dual;
select cast(null as datetime) from dual;
select cast(null as timestamp) from dual;
select cast(null as varchar(100)) from dual;
select cast(null as raw(20)) from dual;
select cast(cast('123' as bigint) as number) from dual;
select cast(null::timestamp as int);
select 123123::decimal::varchar(10)::timestamp;
select 123123::decimal::varchar(10)::timestamp::int;
SELECT * FROM DUAL WHERE NULL::VARCHAR(10) IS NULL;

--- Problematic test cases
select cast(cast(null as bigint) as number) from dual;
select cast(cast(null as varchar(100)) as number) from dual;
select null::timestamp::varchar(100)::int::bigint::decimal;
select null::timestamp::varchar(100)::int::bigint::decimal::varchar(40)::timestamp;
 
--- WHERE test
select * from dual where sysdate > 10;
select * from dual where sysdate > '10';
select * from dual where 10 = systimestamp;
select * from dual where '10' >= systimestamp;
select * from dual where 1.0 <> systimestamp;
select * from dual where 100E200 > systimestamp;
select * from dual where 100E200 > sysdate;
select * from dual where '123' + 123 > sysdate;
select * from dual where sysdate > '123' + 123;
select * from dual where '123' + 123 > sysdate;
select * from dual where cast('7777' as raw(10)) > '123' + 123;
select * from dual where 123 > cast('7777' as raw(10));
select * from dual where sysdate > cast('7777' as raw(10));
select * from dual where cast('7777' as raw(10)) <= systimestamp;
-- WHERE test IN clause
select * from dual where sysdate in (sysdate, 100);
select * from dual where sysdate in (sysdate - 1, systimestamp + 1);
select * from dual where sysdate in (sysdate, systimestamp, 100);
select * from dual where 2 in (sysdate, systimestamp, 100);
select * from dual where (2, 1) in ((2, 1), (3, 2));
select * from dual where (2, 1) in ((2, '123'), (3, 2));
select * from dual where (2, 1) in ((2, sysdate), (3, 2));
select * from dual where ((2, sysdate) in ((5, 5), (3, 2));
select * from dual where 2 in (select sysdate from dual);
select * from dual where sysdate in (select sysdate - 1 from dual);
select * from dual where sysdate in (select 2 from dual);
select * from dual where (sysdate, 2) in (select 2, 2 from dual);
select * from dual where sysdate between (select sysdate - 1 from dual) and (select sysdate + 1 from dual);
select * from dual where sysdate between (select sysdate - 1 from dual) and (select 1000000 from dual);
select * from dual where sysdate between (select sysdate - 1 from dual) and (select '1000000' from dual);

-- WHERE test BETWWEEN clause
select * from dual where sysdate between 3 and 2;
select * from dual where sysdate between '3' and '2';


--- WHERE clause for datatype deduction 
DROP TABLE IF EXISTS PFA_20180120;
Create table PFA_20180120(
    c_int        int,
	c_bigint     BIGINT,
	c_real       real,
	c_number     number,
	c_raw        raw(100),
	c_vchar      varchar(100),
	c_ts         timestamp,
    c_date       date
);

update PFA_20180120 set c_ts = 100;
update PFA_20180120 set c_ts = '100';
update PFA_20180120 set c_date = 100;
update PFA_20180120 set c_date = '100';
update PFA_20180120 set c_date = '100';
update PFA_20180120 set c_date = c_int;
update PFA_20180120 set c_date = c_real;
update PFA_20180120 set c_real = c_ts;
update PFA_20180120 set c_real = c_raw;
update PFA_20180120 set c_real = c_vchar;
update PFA_20180120 set c_ts = c_raw;
update PFA_20180120 set c_date = c_int + c_ts;
update PFA_20180120 set c_date = c_ts + c_int;
update PFA_20180120 set c_date = c_ts + c_vchar;
update PFA_20180120 set c_date = c_number + c_vchar;
update PFA_20180120 set c_date = c_vchar + c_number;
-- update PFA_20180120 set c_date = c_ts + c_date;  -- support latter
INSERT into PFA_20180120(ts) values(100);
INSERT into PFA_20180120(ts) values('200');
INSERT into PFA_20180120(ts) values(2131.3);
INSERT into PFA_20180120(ts) values(2131.3E200);