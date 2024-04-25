-- parallel full scan
drop table if exists tbl_full_scan;
create table tbl_full_scan(a int, b varchar(256), c double, d clob, e bool, f number(8,6), g timestamp(6));
create or replace PROCEDURE GEN_DATA_TBL_FULL_SCAN(min_b IN INTEGER, max_b IN  INTEGER)
as
    i  INTEGER := 0;
begin
    FOR i IN min_b..max_b LOOP
	BEGIN
		IF (i % 10 = 0) THEN
		  insert into tbl_full_scan values(i, 'abc', 32.22228938, 'XXXXXXXXXXXXXXXXXXXXXXXXXYYYYYYYYYYYYYYYYYYYYYYYYY', true,  1.023, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 1) THEN
		  insert into tbl_full_scan values(i, 'abcabcabcabc', 32.22228938, 'AAAAAAAAAAAAAAAAAA', false, 2.289, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 2) THEN
		  insert into tbl_full_scan values(i, 'abcabcabcabcabcabcabc', 32.22228938, 'DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD', true,  3.998, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 3) THEN
		  insert into tbl_full_scan values(i, 'abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc', 32.22228938, 'ABC', false, 4.231, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 4) THEN
		  insert into tbl_full_scan values(i, 'abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc', 32.22228938, 'ABCDEFGH', true,  5.2332, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 5) THEN
		  insert into tbl_full_scan values(i, 'abcabcabc', 32.22228938, 'DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD', false, 5.111, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 6) THEN
		  insert into tbl_full_scan values(i, 'abc', 32.22228938, 'aaaaaaaaaaaaaaaaaaaaaaaaaaa......aaaaaaaaaaaaaaaaaaa', true,  6.2222, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 7) THEN
		  insert into tbl_full_scan values(i, 'abcabcabc', 32.22228938, '33392739472946296439163946192346912364', false, 7.298982, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 8) THEN
		  insert into tbl_full_scan values(i, 'abcabcabcabcabc', 32.22228938, '7942739847982374982374927394690547akshdfohwioehofiqhiowehfoiashdf', true,  9.298, '2019-03-10 12:02:32.02832');
		ELSIF (i % 10 = 9) THEN
		  insert into tbl_full_scan values(i, 'abcabcabcabc', 32.22228938, 'asdhfoasdihfoashdfoihasdoipfhaoisdpfaiposdhfioash', false, 0.2324, '2019-03-10 12:02:32.02832');
		ELSE
		  insert into tbl_full_scan values(i, 'abcabcabc', 32.22228938, 'A', true,  1.2342342, '2019-03-10 12:02:32.02832');
		END IF;
	END;
    END LOOP;
    commit;
    RETURN;
END ;
/

CALL gen_data_tbl_full_scan(1, 200);

select                  * from tbl_full_scan where a >= 100 and a < 101;
select /*+parallel(4)*/ * from tbl_full_scan where a >= 100 and a < 101;

select /*+parallel(4)*/ * from tbl_full_scan where a = 1 limit 1;


-- parallel partition full scan
drop table if exists tbl_full_scan;
CREATE TABLE tbl_full_scan(a int, b varchar(256), c double, d clob, e bool, f number(8,6), g timestamp(6))
PARTITION BY RANGE(a)
(
PARTITION training1 VALUES LESS than(100),
PARTITION training2 VALUES LESS than(200),
PARTITION training3 VALUES LESS than(300),
PARTITION training4 VALUES LESS than(MAXVALUE)
);

CALL gen_data_tbl_full_scan(1, 400);

select                  * from tbl_full_scan where a >= 201 and a <= 201;
select /*+parallel(4)*/ * from tbl_full_scan where a >= 201 and a <= 201;

drop table if exists tbl_full_scan;

