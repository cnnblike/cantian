drop table if exists test_windowing;
create table test_windowing  
(  
	f_int1			integer default 0 not null,  
	f_int2			integer,  
	f_int3			integer, 	
	f_dec1			DECIMAL(38, 0), 
	f_timestamp		timestamp 
);
create index idx_test_windowing_1 on test_windowing(f_int1);

insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(0,100,14000.00,1);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(1,110,12000.00,2);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(1,NULL,12000.00,2);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(1,111,12000.00,3);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(1,111,13000.00,4);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(1,111,12000.00,5);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(2,5,12000.00,6);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(2,6,12000.00,7);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(2,7,12000.00,8);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(2,9,12000.00,9);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(2,9,12000.00,10);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(2,10,12000.00,11);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(2,10,12000.00,NULL);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(2,10,13000.00,12);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(2,10,12000.00,13);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(2,11,12000.00,14);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(2,11,12000.00,15);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(3,99,13000.00,16);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(3,101,12000.00,17);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(3,101,13000.00,18);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(3,101,12000.00,19);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(1,NULL,12000.00,2);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3) values(1,NULL,12000.00,2);

insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(0,100,14000.00,1,  to_timestamp('2021-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(1,110,12000.00,2,  to_timestamp('2021-01-01 01:00:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(1,NULL,12000.00,2, to_timestamp('2021-01-01 01:00:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(1,111,12000.00,3,  NULL);
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(1,111,13000.00,4,  to_timestamp('2021-01-01 01:20:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(1,111,12000.00,5,  to_timestamp('2021-01-01 01:20:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(2,5,12000.00,6,    to_timestamp('2021-01-01 00:30:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(2,6,12000.00,7,    to_timestamp('2021-01-01 00:02:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(2,7,12000.00,8,    to_timestamp('2021-01-01 00:03:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(2,9,12000.00,9,    to_timestamp('2021-01-01 00:05:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(2,9,12000.00,10,   to_timestamp('2021-01-01 00:05:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(2,10,12000.00,11,  to_timestamp('2021-01-01 00:10:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(2,10,12000.00,NULL,to_timestamp('2021-01-01 00:10:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(2,10,13000.00,12,  to_timestamp('2021-01-01 00:30:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(2,10,12000.00,13,  to_timestamp('2021-01-01 00:30:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(2,11,12000.00,14,  to_timestamp('2021-01-01 00:50:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(2,11,12000.00,15,  to_timestamp('2021-01-01 00:50:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(3,99,13000.00,16,  to_timestamp('2021-01-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(3,101,12000.00,17, to_timestamp('2021-01-01 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(3,101,13000.00,18, to_timestamp('2021-01-01 11:00:01', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(3,101,12000.00,19, to_timestamp('2021-01-01 11:10:00', 'YYYY-MM-DD HH24:MI:SS'));
insert into test_windowing(f_int1, f_int2, f_dec1, f_int3, f_timestamp) values(4,120,12000.00,19, to_timestamp('2021-01-01 11:10:00', 'YYYY-MM-DD HH24:MI:SS'));
commit;
-- result different oracle
select f_int1, f_int2, sum(f_int1) over(partition by f_int1 order by f_int1 rows between UNBOUNDED preceding and 3.999999999999999999999999999999999999999 following) from test_windowing;
select f_int1, f_int2, sum(f_int1) over(partition by f_int1 order by f_int1 rows between UNBOUNDED preceding and 5000000000 following) from test_windowing; --uint32
select f_int1, f_int2, sum(f_int1) over(partition by f_int1 order by f_int1 rows between UNBOUNDED preceding and 28446744073709551615 following) from test_windowing;  --uint64
-- parse error
select f_int1, sum(f_int1) over(partition by f_int1 order by f_int1 rows 3 following) from test_windowing;
select f_int1, sum(f_int1) over(partition by f_int1 order by f_int1 rows between 3 following) from test_windowing;
select f_int1, sum(f_int1) over(partition by f_int1 order by f_int1 rows between 3 following 2 following) from test_windowing;
-- not support
select f_int1, cume_dist() over(partition by f_int1 order by f_int1 rows between UNBOUNDED preceding and UNBOUNDED following) from test_windowing;
select f_int1, dense_rank() over(partition by f_int1 order by f_int1 rows between UNBOUNDED preceding and UNBOUNDED following) from test_windowing;
select f_int1, lag(f_int1) over(partition by f_int1 order by f_int1 rows between UNBOUNDED preceding and UNBOUNDED following) from test_windowing;
select f_int1, lead(f_int1) over(partition by f_int1 order by f_int1 rows between UNBOUNDED preceding and UNBOUNDED following) from test_windowing;
select f_int1, listagg(f_int1) within group(order by f_int1 rows between UNBOUNDED preceding and UNBOUNDED following) over(partition by f_int1 ) from test_windowing;
select f_int1, ntile(f_int1) over(partition by f_int1 order by f_int1 rows between UNBOUNDED preceding and UNBOUNDED following) from test_windowing;
select f_int1, rank() over(partition by f_int1 order by f_int1 rows between UNBOUNDED preceding and UNBOUNDED following) from test_windowing;
select f_int1, row_number(f_int1) over(partition by f_int1 order by f_int1 rows between UNBOUNDED preceding and UNBOUNDED following) from test_windowing;
drop table if exists test_windowing;