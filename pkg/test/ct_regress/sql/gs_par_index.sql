drop table if exists tbl_index_scan;
drop table if exists refer;
create table tbl_index_scan(a int, b varchar(256), c double, d clob, e bool, f number(8,6), g timestamp(6));
create index tbl_full_scan_idx_a_b on tbl_index_scan(a,b);

create table refer(a int, b varchar(256));
insert into refer values(1,'abc');
insert into refer values(2,'bbc');
insert into refer values(3,'abcd');
insert into refer values(4,'abe');
insert into refer select * from refer;
insert into refer select * from refer;
insert into refer select * from refer;
insert into refer select * from refer;

create or replace PROCEDURE GEN_DATA_TBL_INDEX_SCAN(min_b IN INTEGER, max_b IN  INTEGER)
as
    i  INTEGER := 0;
begin
    FOR i IN min_b..max_b LOOP
	BEGIN
		IF (i % 10 = 0) THEN
		  insert into tbl_index_scan values(i, 'abc', 32.22228938, 'XXXXXXXXXXXXXXXXXXXXXXXXXYYYYYYYYYYYYYYYYYYYYYYYYY', true,  1.023, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 1) THEN
		  insert into tbl_index_scan values(i, 'abcabcabcabc', 32.22228939, 'AAAAAAAAAAAAAAAAAA', false, 2.289, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 2) THEN
		  insert into tbl_index_scan values(i, 'abcabcabcabcabcabcabc', 32.22228948, 'DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD', true,  3.998, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 3) THEN
		  insert into tbl_index_scan values(i, 'abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc', 32.2222858, 'ABC', false, 4.231, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 4) THEN
		  insert into tbl_index_scan values(i, 'abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc', 32.2224938, 'ABCDEFGH', true,  5.2332, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 5) THEN
		  insert into tbl_index_scan values(i, 'abcabcabc', 32.22228938, 'DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD', false, 5.111, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 6) THEN
		  insert into tbl_index_scan values(i, 'abc', 32.22228938, 'aaaaaaaaaaaaaaaaaaaaaaaaaaa......aaaaaaaaaaaaaaaaaaa', true,  6.2222, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 7) THEN
		  insert into tbl_index_scan values(i, 'abcabcabc', 32.22228938, '33392739472946296439163946192346912364', false, 7.298982, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 8) THEN
		  insert into tbl_index_scan values(i, 'abcabcabcabcabc', 32.22228938, '7942739847982374982374927394690547akshdfohwioehofiqhiowehfoiashdf', true,  9.298, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 9) THEN
		  insert into tbl_index_scan values(i, 'abcabcabcabc', 32.22228938, 'asdhfoasdihfoashdfoihasdoipfhaoisdpfaiposdhfioash', false, 0.2324, '2019-03-10 12:02:32.02832');
		ELSE
		  insert into tbl_index_scan values(i, 'abcabcabc', 32.22228938, 'A', true,  1.2342342, '2019-03-10 12:02:32.02832');
		END IF;
	END;
    END LOOP;
    commit;
    RETURN;
END ;
/
CALL gen_data_tbl_index_scan(1, 2000);
select a from tbl_index_scan where a > 100 and a < 10001 order by a limit 2;
select /*+parallel(4)*/ a from tbl_index_scan where a > 100 and a < 10001 order by a limit 2;
select a,c from tbl_index_scan where a > 100 and a < 10001 order by c limit 2;
select /*+parallel(4)*/ a,c from tbl_index_scan where a > 100 and a < 10001 order by c limit 2;
select * from tbl_index_scan where a > 100 and a < 10001 and f < 1 order by a,b,c limit 10;
select /*+parallel(4)*/ * from tbl_index_scan where a > 100 and a < 10001 and f < 1 order by a,b,c limit 10;

select max(a) from tbl_index_scan;
select /*+parallel(4)*/ max(a) from tbl_index_scan;
select count(a),min(b) from tbl_index_scan;
select /*+parallel(4)*/ count(a),min(b) from tbl_index_scan;
-- no index scan
select count(a),CAST(avg(c) AS DECIMAL(10,3)) from tbl_index_scan;
select /*+parallel(4)*/ count(a),CAST(avg(c) AS DECIMAL(10,3)) from tbl_index_scan;
select CAST(avg(c) AS DECIMAL(10,3)) from tbl_index_scan;
select /*+parallel(4)*/ CAST(avg(c) AS DECIMAL(10,3)) from tbl_index_scan;

--subquery and multi table, not supported
select /*+ parallel(4) */ count(1) from (select count(*) from tbl_index_scan);
select /*+ parallel(4) */ count(1) from (select * from tbl_index_scan);
select /*+ parallel(4) */ count(1) from (select * from tbl_index_scan where a > 100 and a < 10001);
select /*+ parallel(4) */ count(*) from tbl_index_scan t inner join refer r on t.a = r.a;
select /*+ parallel(4) */ a,(select count(*) from tbl_index_scan) from refer order by a limit 10;
select /*+ parallel(4) */ avg(a) from tbl_index_scan where a in (select a from refer);
select /*+ parallel(4) */ avg(a) from refer where a in (select a from tbl_index_scan);
select /*+ parallel(4) */ avg(a) from refer where (a,b) in (select a,b from tbl_index_scan);
(select /*+ parallel(4) */ count(a) from tbl_index_scan) union all
(select avg(a) from tbl_index_scan) order by 1;

-- parallel partition full scan
drop table if exists tbl_index_scan;
CREATE TABLE tbl_index_scan(a int, b varchar(256), c double, d clob, e bool, f number(8,6), g timestamp(6))
PARTITION BY RANGE(a)
(
PARTITION training1 VALUES LESS than(100),
PARTITION training2 VALUES LESS than(200),
PARTITION training3 VALUES LESS than(300),
PARTITION training4 VALUES LESS than(MAXVALUE)
);

CALL gen_data_tbl_index_scan(1, 2000);

select a from tbl_index_scan where a > 100 and a < 10001 order by a limit 2;
select /*+parallel(4)*/ a from tbl_index_scan where a > 100 and a < 10001 order by a limit 2;
select a,c from tbl_index_scan where a > 100 and a < 10001 order by c limit 2;
select /*+parallel(4)*/ a,c from tbl_index_scan where a > 100 and a < 10001 order by c limit 2;
select * from tbl_index_scan where a > 100 and a < 10001 and f < 1 order by a,b,c limit 10;
select /*+parallel(4)*/ * from tbl_index_scan where a > 100 and a < 10001 and f < 1 order by a,b,c limit 10;

select max(a) from tbl_index_scan;
select /*+parallel(4)*/ max(a) from tbl_index_scan;
select count(a),min(b) from tbl_index_scan;
select /*+parallel(4)*/ count(a),min(b) from tbl_index_scan;
-- no index scan
select count(a),CAST(avg(c) AS DECIMAL(10,3)) from tbl_index_scan;
select /*+parallel(4)*/ count(a),CAST(avg(c) AS DECIMAL(10,3)) from tbl_index_scan;
select CAST(avg(c) AS DECIMAL(10,3)) from tbl_index_scan;
select /*+parallel(4)*/ CAST(avg(c) AS DECIMAL(10,3)) from tbl_index_scan;

--subquery and multi table, not supported
select /*+ parallel(4) */ count(1) from (select count(*) from tbl_index_scan);
select /*+ parallel(4) */ count(1) from (select * from tbl_index_scan);
select /*+ parallel(4) */ count(1) from (select * from tbl_index_scan where a > 100 and a < 10001);
select /*+ parallel(4) */ count(*) from tbl_index_scan t inner join refer r on t.a = r.a;
select /*+ parallel(4) */ a,(select count(*) from tbl_index_scan) from refer order by a limit 10;
select /*+ parallel(4) */ avg(a) from tbl_index_scan where a in (select a from refer);
select /*+ parallel(4) */ avg(a) from refer where a in (select a from tbl_index_scan);
select /*+ parallel(4) */ avg(a) from refer where (a,b) in (select a,b from tbl_index_scan);
(select /*+ parallel(4) */ count(a) from tbl_index_scan) union all
(select avg(a) from tbl_index_scan) order by 1;

-- group by(not supported)
drop table if exists tbl_group;
create table tbl_group(a int, b int, c double);
create index tbl_group_idx_a_b on tbl_group(a,b);
create or replace PROCEDURE gen_data_tbl_group(a IN  INTEGER, min_b IN INTEGER, max_b IN  INTEGER)
as
    i  INTEGER := 0;
    j  INTEGER := 0;
begin
    FOR i IN min_b..max_b LOOP
            BEGIN
                FOR j IN 0..3 LOOP
                    BEGIN
                        insert into tbl_group values((a+i) % 10, (i+j+1) % 4, (a+i)*1.2);
                    END;
                END LOOP;
            END;
    END LOOP;
    commit;
    RETURN;
END ;
/
call gen_data_tbl_group(1,1,500);
select a, max(b) from tbl_group group by a;
select /*+parallel(4)*/ a, max(b) from tbl_group group by a;
select a,b, max(c) from tbl_group group by a,b order by a,b;
select /*+parallel(4)*/ a,b, max(c) from tbl_group group by a,b order by a,b;
--other situations
select /*+ parallel(4) */ count(1) from (select count(*) from tbl_group group by a);
select /*+ parallel(4) */ count(1) from (select * from tbl_group) group by a order by 1;
select /*+ parallel(4) */ count(*) from tbl_group t inner join refer r on t.a = r.a group by t.a order by 1;
select /*+ parallel(4) */ count(a),(select count(a) from tbl_group group by a limit 1) from refer group by a order by 1,2;
select /*+ parallel(4) */ avg(a) from tbl_group where a in (select a from refer) group by a order by 1;
select /*+ parallel(4) */ avg(a) from refer where not exists (select a,b,count(b) from tbl_group group by a,b);
(select /*+ parallel(4) */ count(a) from tbl_group group by a) union all
(select avg(b) from tbl_group group by a) order by 1;
drop table if exists tbl_index_scan;
drop table if exists refer;
drop table if exists tbl_group;
drop table if exists tbl_index_scan;

-- create index parallel
drop table if exists tbl_paral;
CREATE TABLE tbl_paral(id int, b int);
drop table if exists test_paral_part;
create table test_paral_part(f1 int, f2 real, f3 number)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(40)
);
drop table if exists test_paral_subpart;
create table test_paral_subpart(f1 int, f2 real, f3 number) partition BY HASH(f1) SUBPARTITION BY hash(f2) PARTITIONS 4 subpartitions 4;

declare
    i integer;
begin
    for i in 1 .. 6000 loop
        execute immediate 'insert into tbl_paral values(1, ' || i || ')';
    end loop;
    commit;
end;
/

insert into test_paral_part values (1, 9.1, 0.2);
insert into test_paral_part values (12, 9.1, 0.2);
insert into test_paral_part values (22, 9.1, 0.2);
insert into test_paral_part values (32, 9.1, 0.2);
declare
    i integer;
begin
    for i in 1 .. 10 loop
        execute immediate 'insert into test_paral_part select * from test_paral_part';
    end loop;
    commit;
end;
/

insert into test_paral_subpart select * from test_paral_part;
commit;

create index idx_paral_1 on tbl_paral(b) parallel 0;
create index idx_paral_2 on tbl_paral(b) parallel 32;
create index idx_paral_2 on tbl_paral(upper(b)) parallel 13;
create index idx_paral_1 on tbl_paral(id) parallel 4 crmode row;
create index idx_paral_3 on tbl_paral(case when b>100 then b else trunc(b) end);
drop index if exists idx_paral_1 on tbl_paral;
create index idx_paral_1 on tbl_paral(id) parallel 4 crmode page;

create index idx_part_paral_1 on test_paral_part(f1) local parallel 0;
create index idx_part_paral_1 on test_paral_part(f1) local parallel 64;
create index idx_part_paral_1 on test_paral_part(f2, f1) local parallel 26 crmode row;
drop index if exists idx_part_paral_1 on test_paral_part;
create index idx_part_paral_1 on test_paral_part(f1, f3) local parallel 3 crmode page;
create index idx_part_paral_2 on test_paral_part(f1, f3) parallel 1 crmode page;

create index idx_subpart_paral_1 on test_paral_subpart(f2, f1) local parallel 14 crmode row;
drop index if exists idx_subpart_paral_1 on test_paral_subpart;
create index idx_subpart_paral_1 on test_paral_subpart(f1, f3) local parallel 6 crmode page;
create index idx_subpart_paral_2 on test_paral_subpart(f1) parallel 2 crmode page;

alter index idx_paral_3 on tbl_paral rebuild parallel 38;
alter index idx_subpart_paral_1 on test_paral_subpart rebuild parallel 64;
alter index idx_subpart_paral_2 on test_paral_subpart rebuild parallel 68;
-- AR.20210330161103.001
alter index idx_part_paral_1 on test_paral_part rebuild partition p1,p2,p3;
alter index idx_part_paral_1 on test_paral_part rebuild partition p1;
alter index idx_part_paral_1 on test_paral_part rebuild partition p2,p3,p4;
alter index idx_part_paral_1 on test_paral_part rebuild partition p2,p3,p4,p2,p3,p4,p2,p3,p4,p2,p3,p4,p2,p3,p4,p2,p3,p4,p2,p3,p4,p2,p3,p4,p2,p3,p4,p2,p3,p4,p2,p3,p4,p2,p3,p4;
 
alter index idx_part_paral_1 on test_paral_part rebuild partition p1,p2,p3 parallel 32;
alter index idx_part_paral_1 on test_paral_part rebuild partition p1 parallel 6;
alter index idx_part_paral_1 on test_paral_part rebuild partition p2,p3,p4 parallel 1;

CREATE TABLE test_paral_subpart2(NUM INT,C_ID INT) PARTITION BY RANGE(NUM) SUBPARTITION BY HASH(C_ID) (PARTITION P1 VALUES LESS THAN (5) (SUBPARTITION P11,SUBPARTITION P12),PARTITION P2 VALUES LESS THAN (11) (SUBPARTITION P21,SUBPARTITION P22));
create index idx_subpart_paral_3 on test_paral_subpart2(NUM, C_ID) local parallel 14;
alter index idx_subpart_paral_3 on test_paral_subpart2 rebuild partition p1;
alter index idx_subpart_paral_3 on test_paral_subpart2 rebuild partition p2,p3 parallel 2;

alter table tbl_paral add primary key (b) parallel 10;
delete from tbl_paral;
delete from test_paral_part;
delete from test_paral_subpart;
delete from test_paral_subpart2;
rollback;

drop index if exists idx_part_paral_1 on test_paral_part;
drop index if exists idx_part_paral_2 on test_paral_part;
create indexcluster (index idx_part_paral_1 on test_paral_part(f1) local parallel 2, index idx_part_paral_2 on test_paral_part(f2, f1) local parallel 2);
delete from test_paral_part;
rollback;
drop index if exists idx_part_paral_1 on test_paral_part;
drop index if exists idx_part_paral_2 on test_paral_part;
create indexcluster (index idx_part_paral_1 on test_paral_part(f1) local parallel 0, index idx_part_paral_2 on test_paral_part(f2, f1) local parallel 2);
create indexcluster (index idx_part_paral_1 on test_paral_part(f1) local parallel 2, index idx_part_paral_2 on test_paral_part(f2, f1) local parallel 22);
drop index if exists idx_subpart_paral_1 on test_paral_subpart;
drop index if exists idx_subpart_paral_2 on test_paral_subpart;
create indexcluster (index idx_subpart_paral_1 on test_paral_subpart(f1) local parallel 8, index idx_subpart_paral_2 on test_paral_subpart(f2, f1) local parallel 8);
create indexcluster (index idx_subpart_paral_31 on test_paral_subpart(f1, f3) parallel 8, index idx_subpart_paral_41 on test_paral_subpart(f3) parallel 8);
delete from test_paral_subpart;
rollback;
drop index if exists idx_subpart_paral_1 on test_paral_subpart;
drop index if exists idx_subpart_paral_2 on test_paral_subpart;
create indexcluster (index idx_subpart_paral_1 on test_paral_subpart(f1) local parallel 8, index idx_part_paral_1 on test_paral_part(f1) local parallel 8);
delete from test_paral_part;
delete from test_paral_subpart;
rollback;
alter table test_paral_part truncate partition p1;
alter table test_paral_part truncate partition p2;
create indexcluster (index idx_part_paral_1 on test_paral_part(f1) local parallel 6, index idx_part_paral_2 on test_paral_part(f2, f1) local parallel 6, index idx_part_paral_3 on test_paral_part(f3) local parallel 6);
drop index if exists idx_part_paral_1 on test_paral_part;
drop index if exists idx_part_paral_2 on test_paral_part;
drop index if exists idx_part_paral_3 on test_paral_part;
delete from test_paral_part;
commit;
create indexcluster (index idx_part_paral_1 on test_paral_part(upper(f1)) local parallel 6, index idx_part_paral_2 on test_paral_part(to_char(f2), f1) local parallel 6, index idx_part_paral_3 on test_paral_part(f3)  parallel 6);
create indexcluster (index idx_part_paral_1 on test_paral_part(f1) local, index idx_part_paral_2 on test_paral_part(f2, f1) local, index idx_part_paral_3 on test_paral_part(f3));
create indexcluster (index idx_part_paral_1 on test_paral_part(f1) local parallel 6, index idx_part_paral_2 on test_paral_part(f2, f1) local, index idx_part_paral_3 on test_paral_part(f3));
create indexcluster (index idx_part_paral_1 on test_paral_part(f1) local parallel 6, index idx_part_paral_2 on test_paral_part(f2, f1) local parallel 6, index idx_part_paral_3 on test_paral_part(f3)  parallel 6);
create indexcluster (index idx_part_paral_1 on test_paral_part(f1) local parallel 6, index idx_part_paral_2 on test_paral_part(f2, f1) local parallel 6, index idx_part_paral_3 on test_paral_part(f3) local parallel 6);
delete from test_paral_subpart;
commit;
create indexcluster (index idx_subpart_paral_1 on test_paral_subpart(f1) local parallel 8, index idx_subpart_paral_2 on test_paral_subpart(f2, f1) local parallel 8);
drop table if exists tbl_paral;
drop table if exists test_paral_part;
drop table if exists test_paral_subpart;
drop table if exists test_paral_subpart2;

drop table if exists test_paral_part;
create table test_paral_part(f1 int, f2 real, f3 number, f4 int, f5 int, f6 int)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(40)
);
create indexcluster (index idx_part_paral_1 on test_paral_part(f1) local parallel 6, index idx_part_paral_2 on test_paral_part(f2) local parallel 6, index idx_part_paral_3 on test_paral_part(f3) local parallel 6, index idx_part_paral_4 on test_paral_part(f4) local parallel 6, index idx_part_paral_5 on test_paral_part(f5) local parallel 6, index idx_part_paral_6 on test_paral_part(f6) local parallel 6, index idx_part_paral_7 on test_paral_part(f1, f2) local parallel 6, index idx_part_paral_8 on test_paral_part(f1, f3) local parallel 6, index idx_part_paral_9 on test_paral_part(f1, f5) local parallel 6);

create indexcluster (index idx_part_paral_1 on test_paral_part(f1) local parallel 6, index idx_part_paral_2 on test_paral_part(f2) local parallel 6, index idx_part_paral_3 on test_paral_part(f3) local parallel 6, index idx_part_paral_4 on test_paral_part(f4) local parallel 6, index idx_part_paral_5 on test_paral_part(f5) local parallel 6, index idx_part_paral_6 on test_paral_part(f6) local parallel 6, index idx_part_paral_7 on test_paral_part(f1, f2) local parallel 6, index idx_part_paral_8 on test_paral_part(f1, f3) local parallel 6);

drop index idx_part_paral_1 on test_paral_part;drop index idx_part_paral_2 on test_paral_part;drop index idx_part_paral_3 on test_paral_part;drop index idx_part_paral_4 on test_paral_part;
drop index idx_part_paral_5 on test_paral_part;drop index idx_part_paral_6 on test_paral_part;drop index idx_part_paral_7 on test_paral_part;drop index idx_part_paral_8 on test_paral_part;
insert into test_paral_part values (1, 9.1, 0.2,1,1,1);
insert into test_paral_part values (12, 9.1, 0.2,1,1,1);
insert into test_paral_part values (22, 9.1, 0.2,1,1,1);
insert into test_paral_part values (32, 9.1, 0.2,1,1,1);
declare
    i integer;
begin
    for i in 1 .. 10 loop
        execute immediate 'insert into test_paral_part select * from test_paral_part';
    end loop;
    commit;
end;
/
commit;

create indexcluster (index idx_part_paral_1 on test_paral_part(f1)  parallel 6, index idx_part_paral_2 on test_paral_part(f2)  parallel 6, index idx_part_paral_3 on test_paral_part(f3)  parallel 6, index idx_part_paral_4 on test_paral_part(f4)  parallel 6, index idx_part_paral_5 on test_paral_part(f5)  parallel 6, index idx_part_paral_6 on test_paral_part(f6)  parallel 6, index idx_part_paral_7 on test_paral_part(f1, f2)  parallel 6, index idx_part_paral_8 on test_paral_part(f1, f3)  parallel 6);
delete from test_paral_part;
drop table if exists test_paral_part;
create table test_paral_part(f1 int, f2 real, f3 number, f4 int, f5 int, f6 int)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(40)
);
create indexcluster (index idx_part_paral_1 on test_paral_part(f1)  parallel 6, index idx_part_paral_2 on test_paral_part(f2)  parallel 6, index idx_part_paral_3 on test_paral_part(f3)  parallel 6, index idx_part_paral_4 on test_paral_part(f4)  parallel 6, index idx_part_paral_5 on test_paral_part(f5)  parallel 6, index idx_part_paral_6 on test_paral_part(f6)  parallel 6, index idx_part_paral_7 on test_paral_part(f1, f2)  parallel 6, index idx_part_paral_8 on test_paral_part(f1, f3)  parallel 6);
delete from test_paral_part;
drop table if exists test_paral_part;