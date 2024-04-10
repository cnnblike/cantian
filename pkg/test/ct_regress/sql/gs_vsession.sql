SELECT S.USERNAME, M.USER_NAME FROM V$ME M, V$SESSION S WHERE M.SID=S.SID AND M.SPID=S.SPID; --1 row expected


set serveroutput on;
drop table if exists fvt_pragma_table_06;
create table fvt_pragma_table_06 (c_int int,c_number number,c_varchar varchar(80),c_date date);
insert into fvt_pragma_table_06 values(1,1.25,'abcd','2015-5-5');
insert into fvt_pragma_table_06 values(2,2.25,'你好','2016-6-6');
DROP TABLE IF EXISTS fvt_pragma_table_6;
create global temporary table fvt_pragma_table_6
(
c_int int,
c_number number,
c_varchar varchar(80),
c_date date
)ON COMMIT PRESERVE ROWS;
insert into fvt_pragma_table_6 values
(1,1.25,'xiao','0001-1-1');
insert into fvt_pragma_table_6 values
(2,2.25,'小胡','2019-1-1');
insert into fvt_pragma_table_6 values
(3,3.25,' 小兰','2178-12-31');

create or replace procedure fvt_pragma_proc_06 is
pragma autonomous_transaction;
begin
update fvt_pragma_table_06 set c_int = 100 where c_int < 10;
rollback;
for i in 1..10
loop
insert into fvt_pragma_table_06 values(i,3.25,'交通法则','2018-8-8');
end loop;
execute immediate 'replace into fvt_pragma_table_06 values(1,3.25,''交通法则'',''2018-8-8'')';
execute immediate 'commit';
end;
/

declare
pragma autonomous_transaction;
b_number number := 0;
c varchar(100) := 'abc';

begin
fvt_pragma_proc_06;
merge into fvt_pragma_table_06 a using fvt_pragma_table_6 b1 on (a.c_int = b1.c_int) when matched then update set a.c_varchar = b1.c_varchar
when not matched then insert (c_int,c_number,c_varchar,c_date) values(b1.c_int,b1.c_number,b1.c_varchar,b1.c_date);
commit;
execute immediate 'alter table fvt_pragma_table_06 rename column c_int to c_id';
delete from fvt_pragma_table_06 where c_varchar = '交通法则';
insert into fvt_pragma_table_06 values(100,3.25,'$#@','2019-6-19');

begin
insert into fvt_pragma_table_06 values (1,1.25,'abcd','2015-5-5');
select c_number into b_number from fvt_pragma_table_06 where c_varchar ='abcd';
dbe_output.print(b_number);
EXCEPTION
WHEN too_many_rows THEN SYS.dbe_output.print_line('too_many_rows');
SYS.dbe_output.print_line(SQL_ERR_CODE || 'too_many_rows' || SQL_ERR_MSG);
WHEN OTHERS THEN SYS.dbe_output.print_line('other error');
SYS.dbe_output.print_line(SQL_ERR_CODE||'error'||SQL_ERR_MSG);
end;
rollback;
end;
/

select * from fvt_pragma_table_06 order by 1,2,3,4;
drop table if exists fvt_pragma_table_06;


drop user if exists nebula cascade;
alter system set db_block_checksum=typical;
create user nebula identified by Cantian_234;
GRANT CREATE SESSION TO nebula;
grant create table to nebula;
grant dba to nebula;
drop table if exists nebula.strg_indx_collected_interval_tbl_002;alter tablespace users autopurge off;purge recyclebin;

create table nebula.strg_indx_collected_interval_tbl_002(C_ID INT,C_D_ID BIGINT not null,C_W_ID TINYINT UNSIGNED not null,C_FIRST VARCHAR(16) not null,C_MIDDLE VARCHAR(10),C_LAST VARCHAR(16) not null,C_STREET_1 VARCHAR(20) not null,C_STREET_2 VARCHAR(20),C_CITY VARCHAR(20) not null,C_STATE CHAR(2) not null,C_ZIP CHAR(9) not null,C_PHONE CHAR(16) not null,C_SINCE TIMESTAMP,C_CREDIT CHAR(2) not null,C_CREDIT_LIM NUMERIC(12,2),C_DISCOUNT NUMERIC(4,4),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL not null,C_PAYMENT_CNT NUMBER not null,C_DELIVERY_CNT BOOL not null,C_END DATE not null,C_DATA1 VARCHAR(3000),C_DATA2 VARCHAR(8000),C_CLOB CLOB,C_BLOB BLOB)PARTITION BY RANGE(C_SINCE)INTERVAL(NUMTOYMINTERVAL(1,'YEAR'))(PARTITION PART_1 VALUES LESS THAN (TO_DATE('2019-10-18','YYYY-MM-DD')),PARTITION PART_2 VALUES LESS THAN (TO_DATE('2020-05-05','YYYY-MM-DD')),PARTITION PART_3 VALUES LESS THAN (TO_DATE('2020-11-21','YYYY-MM-DD')),PARTITION PART_4 VALUES LESS THAN (TO_DATE('2021-06-09','YYYY-MM-DD')),PARTITION PART_5 VALUES LESS THAN (TO_DATE('2021-12-26','YYYY-MM-DD')),PARTITION PART_6 VALUES LESS THAN (TO_DATE('2022-07-14','YYYY-MM-DD')),PARTITION PART_7 VALUES LESS THAN (TO_DATE('2023-01-30','YYYY-MM-DD')),PARTITION PART_8 VALUES LESS THAN (TO_DATE('2023-08-18','YYYY-MM-DD')),PARTITION PART_9 VALUES LESS THAN (TO_DATE('2024-03-05','YYYY-MM-DD')),PARTITION PART_10 VALUES LESS THAN (TO_DATE('2024-07-01','YYYY-MM-DD')));

create unique index nebula.strg_indx_collected_interval_tbl_002_indx_001 on nebula.strg_indx_collected_interval_tbl_002(C_PHONE);
create index nebula.strg_indx_collected_interval_tbl_002_indx_002 on nebula.strg_indx_collected_interval_tbl_002(C_PAYMENT_CNT);

alter table nebula.strg_indx_collected_interval_tbl_002 drop partition PART_5;
alter table nebula.strg_indx_collected_interval_tbl_002 drop partition PART_6;


create tablespace tablespace_interval_statistics_22 datafile 'tablespace_interval_statistics_22' size 32m autoextend on maxsize 500m;
alter index nebula.strg_indx_collected_interval_tbl_002_indx_001 on nebula.strg_indx_collected_interval_tbl_002 rebuild tablespace tablespace_interval_statistics_22;
alter index nebula.strg_indx_collected_interval_tbl_002_indx_002 on nebula.strg_indx_collected_interval_tbl_002 rebuild tablespace tablespace_interval_statistics_22;

insert into nebula.strg_indx_collected_interval_tbl_002 select 0,0,0,'is','oa','barbar','bkilifcrrgf','pmbwovhsdgj','dyfrda','uq','4801','940215',to_date('2019-04-01','yyyy-mm-dd'),'gc',10000.0,0.4361328,-10.0,10.0,1,true,sysdate,lpad('qvbuflchoqnvmgfvdpfzsf',200,'qvldfschoqgfvmpfzdsf'),lpad('qvbuflchoqnvmgfvdpfzsf',200,'qvldfschoqgfvmpfzdsf'),lpad('qvbuflchoqnvmgfvdpfzsf',200,'qvldfschoqgfvmpfzdsf'),lpad('12314315487569809',400,'1435764abc7890abcdef') from dual;

drop user if exists nebula cascade;
drop tablespace tablespace_interval_statistics_22 INCLUDING CONTENTS AND DATAFILES;

create tablespace t1 DATAFILE 'nolog' SIZE 32M NOLOGGING;
create tablespace t2 DATAFILE 'normal' SIZE 32M ;
DROP table IF EXISTS test;
CREATE TABLE test
(
id NUMBER(6) NOT NULL,
name VARCHAR2(20),
email VARCHAR2(25)
)
TABLESPACE t1;

drop index IF EXISTS IX_test_001 ON test;
CREATE INDEX IX_test_001 ON test(name) TABLESPACE t1;

insert into test values(1,'a','a');

alter index IX_test_001 ON test rebuild tablespace t2;

DROP TABLESPACE t1 INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE t2 INCLUDING CONTENTS AND DATAFILES;
