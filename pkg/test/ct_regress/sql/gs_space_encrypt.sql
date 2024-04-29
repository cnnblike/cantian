CREATE TABLESPACE spc_encrypt DATAFILE '?/data/spc_encrypt_1' size 50M encryption;
alter tablespace spc_encrypt autoextend on;
--simple heap encrypt test--
DROP TABLE IF EXISTS enc_t1;
create table enc_t1(id int, name varchar(32)) tablespace spc_encrypt;

declare
i int:=0;
begin
  loop
    i:=i+1;
 insert into enc_t1 values(100000,'abcd');
 exit when i=1000;
  end loop;
  commit;
  dbe_output.print_line('111');
end;
/

alter system checkpoint;
alter system flush buffer;
select * from enc_t1;

declare
i int:=0;
begin
  loop
    i:=i+1;
 update enc_t1 set name='new2' where id=i;
 exit when i=10;
  end loop;
  commit;
  dbe_output.print_line('111');
end;
/

alter system checkpoint;
alter system flush buffer;
alter database update masterkey;
select * from enc_t1;

--simple lob encrypt test--
DROP TABLE IF EXISTS enc_t2;
create table enc_t2(id int, c clob) tablespace spc_encrypt;

declare
i int:=0;
begin
  loop
    i:=i+1;
 insert into enc_t2 values(2,LPAD('a',7500,'a'));
 exit when i=10;
  end loop;
  commit;
  dbe_output.print_line('111');
end;
/

alter system checkpoint;
alter system flush buffer;
select * from enc_t2;

declare
i int:=0;
begin
  loop
    i:=i+1;
 insert into enc_t2 values(2,LPAD('a',8000,'a'));
 exit when i=10;
  end loop;
  dbe_output.print_line('111');
end;
/

alter system checkpoint;
alter system flush buffer;
select * from enc_t2;

--simple index encrypt test--
CREATE INDEX index_id ON enc_t1(id ASC);
alter system checkpoint;
alter system flush buffer;
select * from enc_t1 where id=100000;

-- table with crmode row and index with different crmode
create table crmode_tb1 (a int, b int, c int, d int, e int , f int) crmode row tablespace spc_encrypt;
create index crmode_idx1 on crmode_tb1(a);
create index crmode_idx2 on crmode_tb1(b) crmode row;
create index crmode_idx3 on crmode_tb1(c) crmode page;

alter system checkpoint;
alter system flush buffer;
select cr_mode from all_tables where table_name = 'CRMODE_TB1';
alter system checkpoint;
alter system flush buffer;
select cr_mode from all_indexes where index_name = 'CRMODE_IDX1';
alter system checkpoint;
alter system flush buffer;
select cr_mode from all_indexes where index_name = 'CRMODE_IDX2';
alter system checkpoint;
alter system flush buffer;
select cr_mode from all_indexes where index_name = 'CRMODE_IDX3';

insert into crmode_tb1 values(1,1,1,1,1,1);
insert into crmode_tb1 values(2,2,2,2,2,2);
insert into crmode_tb1 values(3,3,3,3,3,3);

alter system checkpoint;
alter system flush buffer;
select * from crmode_tb1 where a = 1;
alter system checkpoint;
alter system flush buffer;
select * from crmode_tb1 where b = 2;
alter system checkpoint;
alter system flush buffer;
select * from crmode_tb1 where c = 3;

create index crmode_idx4 on crmode_tb1(d);
create index crmode_idx5 on crmode_tb1(e) crmode row;
create index crmode_idx6 on crmode_tb1(f) crmode page;

-- table with crmode page and index with different crmode
create table crmode_tb2 (a int, b int, c int, d int, e int ,f int) crmode page tablespace spc_encrypt;
create index crmode_idx7 on crmode_tb2(a);
create index crmode_idx8 on crmode_tb2(b) crmode row;
create index crmode_idx9 on crmode_tb2(c) crmode page;

alter system checkpoint;
alter system flush buffer;
select cr_mode from all_tables where table_name = 'CRMODE_TB2';
alter system checkpoint;
alter system flush buffer;
select cr_mode from all_indexes where index_name = 'CRMODE_IDX4';
alter system checkpoint;
alter system flush buffer;
select cr_mode from all_indexes where index_name = 'CRMODE_IDX5';
alter system checkpoint;
alter system flush buffer;
select cr_mode from all_indexes where index_name = 'CRMODE_IDX6';

insert into crmode_tb2 values(1,1,1,1,1,1);
insert into crmode_tb2 values(2,2,2,2,2,2);
insert into crmode_tb2 values(3,3,3,3,3,3);

alter system checkpoint;
alter system flush buffer;
select * from crmode_tb2 where a = 1;
alter system checkpoint;
alter system flush buffer;
select * from crmode_tb2 where b = 2;
alter system checkpoint;
alter system flush buffer;
select * from crmode_tb2 where c = 3;

create index crmode_idx10 on crmode_tb2(d);
create index crmode_idx11 on crmode_tb2(e) crmode row;
create index crmode_idx12 on crmode_tb2(f) crmode page;
-- verify crmode of primary key 
create table crmode_tb3 (id int primary key) crmode row tablespace spc_encrypt;
create table crmode_tb4 (id int primary key) crmode page tablespace spc_encrypt;

-- verify add contraints 
create table crmode_tb5 (a int) crmode page tablespace spc_encrypt;
alter table crmode_tb5 add constraint crmode_cons unique(a) using index(create unique index crmode_idx13 on crmode_tb5(a) crmode page);

drop table crmode_tb1;
drop table crmode_tb2;
drop table crmode_tb3;
drop table crmode_tb4;
drop table crmode_tb5;

--gs_row_chain_test start
DROP TABLE IF EXISTS ROW_CHAIN_TABLE;
CREATE TABLE ROW_CHAIN_TABLE(ID INT,A VARCHAR(7744),B VARCHAR(7744),C VARCHAR(7744),D VARCHAR(7744)) tablespace spc_encrypt;
--TEST1:UNDO_HEAP_UPDATE_FULL + UPDATE_INPLACE(CHAIN->CHAIN)
INSERT INTO ROW_CHAIN_TABLE VALUES(1,LPAD('A',7744,'A'),LPAD('B',7744,'B'),LPAD('C',7744,'C'),'D');
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=1;

UPDATE ROW_CHAIN_TABLE SET ID=1,A=LPAD('U',7744,'U'),B=LPAD('V',7744,'V'),C=LPAD('W',7744,'W'),D='X' WHERE ID=1;
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=1;

--TEST2:UNDO_HEAP_UPDATE_FULL + UPDATE_INPAGE(CHAIN->CHAIN)
UPDATE ROW_CHAIN_TABLE SET ID=2,A=LPAD('U',3000,'U'),B=LPAD('V',2000,'V'),C=LPAD('W',3000,'W'),D='X' WHERE ID=1;
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=2;

--TEST3:UNDO_HEAP_UPDATE_FULL + UPDATE_MIGR(CHAIN->CHAIN)
INSERT INTO ROW_CHAIN_TABLE VALUES(3,LPAD('A',7744,'A'),'B','C',LPAD('D',7744,'D'));
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=3;

UPDATE ROW_CHAIN_TABLE SET ID=3,A=LPAD('U',7744,'U'),B=LPAD('V',7744,'V'),C=LPAD('W',7744,'W'),D=LPAD('X',7744,'X') WHERE ID=3;
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=3;

--TEST4:UNDO_HEAP_UPDATE_FULL + UPDATE_MIGR(NORMAL->CHAIN)
INSERT INTO ROW_CHAIN_TABLE VALUES(4,'A','B','C','D');
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=4;

UPDATE ROW_CHAIN_TABLE SET ID=4,A=LPAD('U',7744,'U'),B=LPAD('V',7744,'V'),C=LPAD('W',7744,'W'),D=LPAD('X',7744,'X') WHERE ID=4;
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=4;

--TEST5:UNDO_HEAP_UPDATE_FULL + UPDATE_INPAGE(CHAIN->NORMAL)
INSERT INTO ROW_CHAIN_TABLE VALUES(5,LPAD('A',7744,'A'),'B','C',LPAD('D',7744,'D'));
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=5;

UPDATE ROW_CHAIN_TABLE SET ID=5,A='A',B='B',C='C',D='D' WHERE ID=5;
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=5;

alter system checkpoint;
alter system flush buffer;
SELECT COUNT(*) FROM ROW_CHAIN_TABLE;
DELETE FROM ROW_CHAIN_TABLE WHERE ID=1;
DELETE FROM ROW_CHAIN_TABLE WHERE ID=2;
DELETE FROM ROW_CHAIN_TABLE WHERE ID=3;
DELETE FROM ROW_CHAIN_TABLE WHERE ID=4;
DELETE FROM ROW_CHAIN_TABLE WHERE ID=5;
alter system checkpoint;
alter system flush buffer;
SELECT COUNT(*) FROM ROW_CHAIN_TABLE;
ROLLBACK;
alter system checkpoint;
alter system flush buffer;
SELECT COUNT(*) FROM ROW_CHAIN_TABLE;

--TEST6:UNDO_HEAP_UPDATE + UPDATE_INPLACE(CHAIN->CHAIN)
INSERT INTO ROW_CHAIN_TABLE VALUES(6,LPAD('A',7744,'A'),LPAD('B',3000,'B'),LPAD('C',7744,'C'),'D');
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=6;

UPDATE ROW_CHAIN_TABLE SET ID=6,A=LPAD('U',7744,'U'),C=LPAD('W',7744,'W'),D='X' WHERE ID=6;
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=6;

--TEST7:UNDO_HEAP_UPDATE + UPDATE_INPAGE(CHAIN->CHAIN)
UPDATE ROW_CHAIN_TABLE SET ID=7,A=LPAD('U',3000,'U'),B=LPAD('V',2000,'V'),D='X' WHERE ID=6;
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=7;

--TEST8:UNDO_HEAP_UPDATE + UPDATE_MIGR(CHAIN->CHAIN)
INSERT INTO ROW_CHAIN_TABLE VALUES(8,LPAD('A',7744,'A'),'B','C',LPAD('D',7744,'D'));
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=8;

UPDATE ROW_CHAIN_TABLE SET ID=8,B=LPAD('V',7744,'V'),C=LPAD('W',7744,'W') WHERE ID=8;
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=8;

--TEST9:UNDO_HEAP_UPDATE + UPDATE_MIGR(NORMAL->CHAIN)
INSERT INTO ROW_CHAIN_TABLE VALUES(9,'A','B','C','D');
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=9;

UPDATE ROW_CHAIN_TABLE SET ID=9,B=LPAD('V',7744,'V'),C=LPAD('W',7744,'W') WHERE ID=9;
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=9;

--TEST10:UNDO_HEAP_UPDATE + UPDATE_MIGR(CHAIN->NORMAL)
INSERT INTO ROW_CHAIN_TABLE VALUES(10,LPAD('A',7744,'A'),'B','C',LPAD('D',7744,'D'));
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=10;

UPDATE ROW_CHAIN_TABLE SET ID=10,A='A',B='B',C='C',D='D' WHERE ID=10;
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE WHERE ID=10;

alter system checkpoint;
alter system flush buffer;
SELECT COUNT(*) FROM ROW_CHAIN_TABLE;
DELETE FROM ROW_CHAIN_TABLE WHERE ID=6;
DELETE FROM ROW_CHAIN_TABLE WHERE ID=7;
DELETE FROM ROW_CHAIN_TABLE WHERE ID=8;
DELETE FROM ROW_CHAIN_TABLE WHERE ID=9;
DELETE FROM ROW_CHAIN_TABLE WHERE ID=10;
alter system checkpoint;
alter system flush buffer;
SELECT COUNT(*) FROM ROW_CHAIN_TABLE;
ROLLBACK;
alter system checkpoint;
alter system flush buffer;
SELECT COUNT(*) FROM ROW_CHAIN_TABLE;

--TEST11:ADD COLUMN
INSERT INTO ROW_CHAIN_TABLE VALUES(11,LPAD('A',7744,'A'),'B','C',LPAD('D',7744,'D'));
ALTER TABLE ROW_CHAIN_TABLE ADD COLUMN E VARCHAR(7744);
UPDATE ROW_CHAIN_TABLE SET E=LPAD('E',7744,'E') WHERE ID=11;
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE;
DELETE FROM ROW_CHAIN_TABLE WHERE ID=11;
alter system checkpoint;
alter system flush buffer;
SELECT COUNT(*) FROM ROW_CHAIN_TABLE;
ROLLBACK;
alter system checkpoint;
alter system flush buffer;
SELECT COUNT(*) FROM ROW_CHAIN_TABLE;

--TEST12:COLUMN > 12
DROP TABLE IF EXISTS ROW_CHAIN_TABLE;
CREATE TABLE ROW_CHAIN_TABLE(
ID INT,
C_SERIAL INT,
C_DOUBLE INT,
C_FLOAT FLOAT,
C_INT INT,
C_INTEGER INTEGER, C_BIGINT INT, C_REAL REAL, C_NUMERIC INT, C_NUMERIC_PARM INT, C_NUMBER INT,  C_NUMBER_PARM INT, C_DECIMAL DECIMAL, C_DECIMAL_PARM DECIMAL(5,2), C_BOOL CHAR(1),
C_CLOB VARCHAR(20), C_BLOB VARCHAR(20),
C_CHAR CHAR, C_CHAR1 CHAR(1), C_CHAR20 CHAR(20), C_CHAR4000 CHAR(4000),
C_VARCHAR VARCHAR(4000), C_VARCHAR1 VARCHAR(1), C_VARCHAR20 VARCHAR(20), C_VARCHAR4000 VARCHAR(4000),
C_VARCHAR2 VARCHAR(20), C_VARCHAR21 VARCHAR(1), C_VARCHAR220 VARCHAR(20), C_VARCHAR24000 VARCHAR(4000),
C_RAW VARCHAR(20), C_RAW1 VARCHAR(1), C_RAW20 VARCHAR(20), C_RAW4000 VARCHAR(4000),
C_BINARY VARCHAR(20), C_BINARY1 VARCHAR(1), C_BINARY20 VARCHAR(20), C_BINARY4000 VARCHAR(4000),
C_VARBINARY VARCHAR(20), C_VARBINARY1 VARCHAR(1), C_VARBINARY20 VARCHAR(20), C_VARBINARY4000 VARCHAR(4000),
C_DATE DATE, C_DATETIME DATE,
C_TIMESTAMP TIMESTAMP, C_TIMESTAMP3 TIMESTAMP(3), C_TIMESTAMP6 TIMESTAMP(6),
C_TIMESTAMP_WTZ TIMESTAMP WITH TIME ZONE, C_TIMESTAMP_WTZ3 TIMESTAMP(3) WITH TIME ZONE, C_TIMESTAMP_WTZ6 TIMESTAMP(6) WITH TIME ZONE,
C_INTERVAL VARCHAR(20),
C_BYTEA VARCHAR(20)
) tablespace spc_encrypt;

INSERT INTO ROW_CHAIN_TABLE VALUES( 12, -1727922176, 1494155264, 1.1, -1644429312, 733741056, 1650917376, -1717305344, -1141374976, 1827471360, -357040128, -1113063424, 7.7, 8.8, 'W', 'MTVYCNFQDRSKGB', 'IMTVYC', 'B', 'N', 'BIMTVYCNFQ', LPAD('EBIMTVYCNF',4000,'EBIMTVYCNF'), LPAD('EBIMTVYCNF',4000,'EBIMTVYCNF'), 'P', 'LUEBIMTV', LPAD('EBIMTVYCNF',2000,'EBIMTVYCNF'),
'SDLUEBIMTVYCN', 'K', 'TSDL', LPAD('EBIMTVYCNF',3000,'EBIMTVYCNF'),'ZZTSDLUEBIMTVYCNFQD', 'K', 'BZZTS', LPAD('EBIMTVYCNF',3000,'EBIMTVYCNF'), 'Z', 'D', 'XZFBZ', LPAD('EBIMTVYCNF',4000,'EBIMTVYCNF'), 'A', 'I', 'MAJXZFBZZTSDLUEBIMTV', LPAD('EBIMTVYCNF',4000,'EBIMTVYCNF'),NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'MD', 'FMDMAJXZFB' );
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE;

UPDATE ROW_CHAIN_TABLE SET ID=12,C_CHAR4000='A',C_BINARY4000='B' WHERE ID=12;
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE;
ROLLBACK;
alter system checkpoint;
alter system flush buffer;
SELECT * FROM ROW_CHAIN_TABLE;

--LINK ROW
drop table if exists linkrow_test_00422311;
create table linkrow_test_00422311(a int, b varchar(4000), c varchar(4000)) TABLESPACE spc_encrypt;

insert into linkrow_test_00422311 values(100,
'bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]',
'abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]');

insert into linkrow_test_00422311 values(100,
'bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]',
'abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]');

commit;

alter system checkpoint;
alter system flush buffer;
select * from linkrow_test_00422311;

update linkrow_test_00422311 set b='bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]abcdefghijklmnopqrstuvwxyz1234567890,.[]bcdefghijklmnopqrstuvwxyz1234567890,.[]';
rollback;
alter system checkpoint;
alter system flush buffer;
select count(*) from linkrow_test_00422311;

delete from linkrow_test_00422311;
alter system checkpoint;
alter system flush buffer;
select count(*) from linkrow_test_00422311;

--lob test start
drop table if exists t_lob_1;
drop table if exists t_lob_2;
drop table if exists t_lob_3;
create table t_lob_1(f1 clob, f2 blob ,id int) tablespace spc_encrypt;
create table t_lob_2(f1 clob, f2 text, f3 blob, f4 bytea, id int) tablespace spc_encrypt;
create table t_lob_3(f1 clob, f2 blob default '11223344') tablespace spc_encrypt;

-- clob/blob
insert into t_lob_1 values('clob1234567890987654321clob', '11111111112222222222', 1);
insert into t_lob_1 values('clob88721837182611clob123', '6677' , 2);
insert into t_lob_1 values('clob1234567890987654321clob', '1111111113312222222222' , 3);
insert into t_lob_1 values('clob88721837182611clob123', '6677' ,4);
insert into t_lob_1 values('hello', '6677',5);
insert into t_lob_1 values('world', '6677' , 6);
insert into t_lob_1(f1, f2 , id) values('hshhjd7891239123a~!@#$%^&*()_+|"::;;.,', '22222223312222222222' , 7);
commit;
alter system checkpoint;
alter system flush buffer;
select * from t_lob_1 order by id;
alter system checkpoint;
alter system flush buffer;
select dbe_lob.get_length(id) from t_lob_1;
alter system checkpoint;
alter system flush buffer;
select dbe_lob.substr(id,1,1) from t_lob_1;
alter system checkpoint;
alter system flush buffer;
select dbe_lob.get_length(f1) from t_lob_1;
alter system checkpoint;
alter system flush buffer;
select dbe_lob.substr(f1,1,1) from t_lob_1;
alter system checkpoint;
alter system flush buffer;
select dbe_lob.get_length(f2) from t_lob_1;
alter system checkpoint;
alter system flush buffer;
select dbe_lob.substr(f2,1,1) from t_lob_1;

-- clob/text/blob/bytea
insert into t_lob_2 values('clob12345678111114321clob', 'clo11', '22221111', '33445511111111112222222222' , 1);
insert into t_lob_2 values('clob	tab  space  123', '~!@#$%^&*()_+|`-=\{}[]:;"<>?,./', '0123456789', '3344552222222222' , 2);
insert into t_lob_2 values('hello', '~!@#$%^&*()_+|`-=\{}[]:;"<>?,./', '0123456789', '3344552222222222' , 3 );
insert into t_lob_2(f1, f2, f3, f4 ,id) values('clob	tab  space  123', '~!@#$%^&*()_+|`-=\{}[]:;"<>?,./', '0123456789', '773344552222222222' , 4);
commit;
select * from t_lob_2 order by id;

DROP TABLESPACE spc_encrypt INCLUDING CONTENTS AND DATAFILES;

--dts1: rollback error
create user nebula identified by Cantian_234;
grant dba to nebula;
create table nebula.tablespace_datafile_000(c_id int,
c_d_id int NOT NULL,
c_w_id int NOT NULL,
c_first varchar(32) NOT NULL,
c_middle char(2),
c_last varchar(32) NOT NULL,
c_street_1 varchar(20) NOT NULL,
c_street_2 varchar(20),
c_city varchar(20) NOT NULL,
c_state char(2) NOT NULL,
c_zip char(9) NOT NULL,
c_phone char(16) NOT NULL,
c_since timestamp,
c_credit char(2) NOT NULL,
c_credit_lim numeric(12,2),
c_discount numeric(4,4),
c_balance numeric(12,2),
c_ytd_payment real NOT NULL,
c_payment_cnt number NOT NULL,
c_delivery_cnt bool NOT NULL,
c_end date NOT NULL,
c_vchar varchar(1000),
c_data clob,
c_text blob );
insert into  nebula.tablespace_datafile_000 select 1,1,1,'AA'||'is1cmvls','OE','AA'||'BAR1BARBAR','bkili'||'1'||'fcxcle'||'1','pmbwo'||'1'||'vhvpaj'||'1','dyf'||'1'||'rya'||'1','uq',4801||'1',940||'1'||215||'1',to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSF'||'1','QVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSF1','1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323';
insert into nebula.tablespace_datafile_000 select       c_id+1,c_d_id+1,c_w_id+1,'AA'||'is2cmvls',c_middle,'AA'||'BAR2BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+2,c_d_id+2,c_w_id+2,'AA'||'is3cmvls',c_middle,'AA'||'BAR3BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+3,c_d_id+3,c_w_id+3,'AA'||'is4cmvls',c_middle,'AA'||'BAR4BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+4,c_d_id+4,c_w_id+4,'AA'||'is5cmvls',c_middle,'AA'||'BAR5BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+5,c_d_id+5,c_w_id+5,'AA'||'is6cmvls',c_middle,'AA'||'BAR6BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+6,c_d_id+6,c_w_id+6,'AA'||'is7cmvls',c_middle,'AA'||'BAR7BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+7,c_d_id+7,c_w_id+7,'AA'||'is8cmvls',c_middle,'AA'||'BAR8BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+8,c_d_id+8,c_w_id+8,'AA'||'is9cmvls',c_middle,'AA'||'BAR9BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+9,c_d_id+9,c_w_id+9,'AA'||'is10cmvls',c_middle,'AA'||'BAR10BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+10,c_d_id+10,c_w_id+10,'AA'||'is11cmvls',c_middle,'AA'||'BAR11BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+11,c_d_id+11,c_w_id+11,'AA'||'is12cmvls',c_middle,'AA'||'BAR12BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+12,c_d_id+12,c_w_id+12,'AA'||'is13cmvls',c_middle,'AA'||'BAR13BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+13,c_d_id+13,c_w_id+13,'AA'||'is14cmvls',c_middle,'AA'||'BAR14BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+14,c_d_id+14,c_w_id+14,'AA'||'is15cmvls',c_middle,'AA'||'BAR15BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+15,c_d_id+15,c_w_id+15,'AA'||'is16cmvls',c_middle,'AA'||'BAR16BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+16,c_d_id+16,c_w_id+16,'AA'||'is17cmvls',c_middle,'AA'||'BAR17BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+17,c_d_id+17,c_w_id+17,'AA'||'is18cmvls',c_middle,'AA'||'BAR18BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+18,c_d_id+18,c_w_id+18,'AA'||'is19cmvls',c_middle,'AA'||'BAR19BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+19,c_d_id+19,c_w_id+19,'AA'||'is20cmvls',c_middle,'AA'||'BAR20BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+20,c_d_id+20,c_w_id+20,'AA'||'is21cmvls',c_middle,'AA'||'BAR21BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+21,c_d_id+21,c_w_id+21,'AA'||'is22cmvls',c_middle,'AA'||'BAR22BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
commit;


--测试用例
create tablespace spc_encrypt_026_1 datafile 'dataspc_encrypt_026_1' size 50M autoextend on encryption;

--I2.创建用户和表
create user nebula_026 identified by Cantian_234 default tablespace spc_encrypt_026_1;
create table nebula_026.storage_tsp_encrypt_026 (c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(32) NOT NULL,c_street_1 varchar(1000) NOT NULL,c_street_2 varchar(1000),c_city varchar(20) NOT NULL,c_state char(500) NOT NULL,c_zip char(9) NOT NULL,c_phone char(56) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_vchar varchar(1000),c_data clob,c_text blob) partition by range(c_id)(partition part_1 values less than(101),partition part_2 values less than(201),partition part_3 values less than(301),partition part_4 values less than(401),partition part_5 values less than(501),partition part_6 values less than(601),partition part_7 values less than(701),partition part_8 values less than(801),partition part_9 values less than(901),partition part_10 values less than(maxvalue)) tablespace spc_encrypt_026_1;

--I3.创建索引指定加密表空间
create unique index storage_tsp_encrypt_index_026_1 on nebula_026.storage_tsp_encrypt_026(c_d_id) tablespace spc_encrypt_026_1;
create unique index storage_tsp_encrypt_index_026_2 on nebula_026.storage_tsp_encrypt_026(c_id,c_w_id,c_first) tablespace spc_encrypt_026_1;
create unique index storage_tsp_encrypt_index_026_3 on nebula_026.storage_tsp_encrypt_026(c_id) local tablespace spc_encrypt_026_1;
create index storage_tsp_encrypt_index_026_4 on nebula_026.storage_tsp_encrypt_026(c_city) tablespace spc_encrypt_026_1;
create index storage_tsp_encrypt_index_026_5 on nebula_026.storage_tsp_encrypt_026(c_last,c_street_1,c_phone) tablespace spc_encrypt_026_1;
create index storage_tsp_encrypt_index_026_6 on nebula_026.storage_tsp_encrypt_026(c_first) local tablespace spc_encrypt_026_1;
create index storage_tsp_encrypt_index_026_7 on nebula_026.storage_tsp_encrypt_026(c_d_id,c_street_2,c_state) local tablespace spc_encrypt_026_1;
insert into nebula_026.storage_tsp_encrypt_026 select * from nebula.tablespace_datafile_000;commit;

--I4.update使索引字段变长->commit->delete->commit
select distinct substr(c_first,1,2),substr(c_last,1,2),c_city,sum(c_id),sum(c_d_id),count(*) from nebula_026.storage_tsp_encrypt_026 group by substr(c_first,1,2),substr(c_last,1,2),c_city order by 1,2,3;
update nebula_026.storage_tsp_encrypt_026 set c_w_id=c_w_id+floor(c_w_id/3),c_first='a1'||c_first,c_last='Aa'||c_last,c_city=upper(c_city),c_vchar='asbfacwjpbvpgthpyxcpmnutcjxrbxxbmrmwwxcepwiixvvleyajautcesljhrsfsasbfacwjpbvpgthpyxcpmnutcjxrbxxbmrmwwxcepwiixvvleyajautcesljhrsfsdegdgffgfhhtujhgjhjj' where mod(c_id,5)=1;
commit;
select distinct substr(c_first,1,2),substr(c_last,1,2),c_city,sum(c_id),sum(c_d_id),count(*) from nebula_026.storage_tsp_encrypt_026 group by substr(c_first,1,2),substr(c_last,1,2),c_city order by 1,2,3;

savepoint aa;
update nebula_026.storage_tsp_encrypt_026 set c_id=c_id+100000,c_w_id=c_w_id+100000,c_d_id=c_id+100000,c_first=c_first||lower(c_first),c_last=c_last||lower(c_last),c_city=upper(c_city)||lower(c_city),c_phone='CHINE ID CARD NUMBER',c_street_1=lpad('yxcpmnutcjxrbxxbmrmwwxcepwiixvvleyajautcesljhrsf',500,'nanihello'),c_street_2=lpad('refdgbvjhyarhhrgrdfhhhgstygfdggdf',500,'wohewodezuguoyikeyebunengfenge'),c_state=lpad('najinchangjiangdaqiao',200,'beijinhuanyingni'),c_vchar='dkjflskjadlfsfdjklsionvfdobfhrqvfgdyiovbhkiuowerfdbjkboifuevbfuigtrgbkdfk' where mod(c_id,4)=1;
select distinct substr(c_first,1,2),substr(c_last,1,2),c_city,sum(c_id),sum(c_d_id),count(*) from nebula_026.storage_tsp_encrypt_026 group by substr(c_first,1,2),substr(c_last,1,2),c_city order by 1,2,3;

savepoint aa;
update nebula_026.storage_tsp_encrypt_026 set c_id=c_id+200000,c_w_id=c_w_id+200000,c_d_id=c_id+200000,c_first=c_first||'XIAN'||upper(c_first),c_last='GAOXINCHANYEYUAN'||upper(c_last),c_city=upper(c_city)||lower(c_city),c_phone='WHAT IS YOUR ID',c_street_1=lpad('yxcpmnutcjxrbxxbmrmwwxcepwiixvvleyajautcesljhrsf',600,'nanihello'),c_street_2=lpad('refdgbvjhyarhhrgrdfhhhgstygfdggdf',600,'wohewodezuguoyikeyebunengfenge'),c_state=lpad('najinchangjiangdaqiao',100,'beijinhuanyingni'),c_vchar='dkjflskjadlfsfdjklsionvfdobfhrqvfgdyiovbhkiuowerfdbjkboifuevbfuigtrgbkdfk' where mod(c_id,4)=2;
select distinct substr(c_first,1,2),substr(c_last,1,2),c_city,sum(c_id),sum(c_d_id),count(*) from nebula_026.storage_tsp_encrypt_026 group by substr(c_first,1,2),substr(c_last,1,2),c_city order by 1,2,3;
rollback to savepoint aa;
select distinct substr(c_first,1,2),substr(c_last,1,2),c_city,sum(c_id),sum(c_d_id),count(*) from nebula_026.storage_tsp_encrypt_026 group by substr(c_first,1,2),substr(c_last,1,2),c_city order by 1,2,3;

--delete core了
delete from nebula_026.storage_tsp_encrypt_026 where mod(c_id,6)=5;
commit;
select distinct substr(c_first,1,2),substr(c_last,1,2),c_city,sum(c_id),sum(c_d_id),count(*) from nebula_026.storage_tsp_encrypt_026 group by substr(c_first,1,2),substr(c_last,1,2),c_city order by 1,2,3;

--I5.删除表
drop table nebula_026.storage_tsp_encrypt_026;
drop table nebula.tablespace_datafile_000;
drop user nebula cascade;
drop user nebula_026 cascade;
drop tablespace spc_encrypt_026_1 including contents and datafiles;

--dts2 nologging
create user nebula identified by Cantian_234;
grant dba to nebula;
create table nebula.tablespace_datafile_000(c_id int,
c_d_id int NOT NULL,
c_w_id int NOT NULL,
c_first varchar(32) NOT NULL,
c_middle char(2),
c_last varchar(32) NOT NULL,
c_street_1 varchar(20) NOT NULL,
c_street_2 varchar(20),
c_city varchar(20) NOT NULL,
c_state char(2) NOT NULL,
c_zip char(9) NOT NULL,
c_phone char(16) NOT NULL,
c_since timestamp,
c_credit char(2) NOT NULL,
c_credit_lim numeric(12,2),
c_discount numeric(4,4),
c_balance numeric(12,2),
c_ytd_payment real NOT NULL,
c_payment_cnt number NOT NULL,
c_delivery_cnt bool NOT NULL,
c_end date NOT NULL,
c_vchar varchar(1000),
c_data clob,
c_text blob );
insert into  nebula.tablespace_datafile_000 select 1,1,1,'AA'||'is1cmvls','OE','AA'||'BAR1BARBAR','bkili'||'1'||'fcxcle'||'1','pmbwo'||'1'||'vhvpaj'||'1','dyf'||'1'||'rya'||'1','uq',4801||'1',940||'1'||215||'1',to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSF'||'1','QVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSF1','1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323';
insert into nebula.tablespace_datafile_000 select       c_id+1,c_d_id+1,c_w_id+1,'AA'||'is2cmvls',c_middle,'AA'||'BAR2BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+2,c_d_id+2,c_w_id+2,'AA'||'is3cmvls',c_middle,'AA'||'BAR3BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+3,c_d_id+3,c_w_id+3,'AA'||'is4cmvls',c_middle,'AA'||'BAR4BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+4,c_d_id+4,c_w_id+4,'AA'||'is5cmvls',c_middle,'AA'||'BAR5BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+5,c_d_id+5,c_w_id+5,'AA'||'is6cmvls',c_middle,'AA'||'BAR6BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+6,c_d_id+6,c_w_id+6,'AA'||'is7cmvls',c_middle,'AA'||'BAR7BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+7,c_d_id+7,c_w_id+7,'AA'||'is8cmvls',c_middle,'AA'||'BAR8BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+8,c_d_id+8,c_w_id+8,'AA'||'is9cmvls',c_middle,'AA'||'BAR9BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+9,c_d_id+9,c_w_id+9,'AA'||'is10cmvls',c_middle,'AA'||'BAR10BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+10,c_d_id+10,c_w_id+10,'AA'||'is11cmvls',c_middle,'AA'||'BAR11BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+11,c_d_id+11,c_w_id+11,'AA'||'is12cmvls',c_middle,'AA'||'BAR12BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+12,c_d_id+12,c_w_id+12,'AA'||'is13cmvls',c_middle,'AA'||'BAR13BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+13,c_d_id+13,c_w_id+13,'AA'||'is14cmvls',c_middle,'AA'||'BAR14BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+14,c_d_id+14,c_w_id+14,'AA'||'is15cmvls',c_middle,'AA'||'BAR15BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+15,c_d_id+15,c_w_id+15,'AA'||'is16cmvls',c_middle,'AA'||'BAR16BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+16,c_d_id+16,c_w_id+16,'AA'||'is17cmvls',c_middle,'AA'||'BAR17BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+17,c_d_id+17,c_w_id+17,'AA'||'is18cmvls',c_middle,'AA'||'BAR18BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+18,c_d_id+18,c_w_id+18,'AA'||'is19cmvls',c_middle,'AA'||'BAR19BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+19,c_d_id+19,c_w_id+19,'AA'||'is20cmvls',c_middle,'AA'||'BAR20BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+20,c_d_id+20,c_w_id+20,'AA'||'is21cmvls',c_middle,'AA'||'BAR21BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
insert into nebula.tablespace_datafile_000 select       c_id+21,c_d_id+21,c_w_id+21,'AA'||'is22cmvls',c_middle,'AA'||'BAR22BARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_vchar,c_data,c_text from nebula.tablespace_datafile_000 where c_id=1;
commit;


--测试用例

create tablespace spc_encrypt_038_1 datafile 'dataspc_encrypt_038_1' size 50M encryption nologging;

--I2.创建用户和表
create user nebula_038 identified by Cantian_234 default tablespace spc_encrypt_038_1;
create table nebula_038.storage_tsp_encrypt_038 (c_id int,c_d_id int NOT NULL,c_w_id int NOT NULL,c_first varchar(32) NOT NULL,c_middle char(2),c_last varchar(32) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_vchar varchar(1000),c_data clob,c_text blob) partition by range(c_id)(partition part_1 values less than(101),partition part_2 values less than(201),partition part_3 values less than(301),partition part_4 values less than(401),partition part_5 values less than(501),partition part_6 values less than(601),partition part_7 values less than(701),partition part_8 values less than(801),partition part_9 values less than(901),partition part_10 values less than(1001)) tablespace spc_encrypt_038_1;

--I3.创建索引指定加密表空间
create unique index storage_tsp_encrypt_index_038_1 on nebula_038.storage_tsp_encrypt_038(c_d_id) tablespace spc_encrypt_038_1;
create unique index storage_tsp_encrypt_index_038_2 on nebula_038.storage_tsp_encrypt_038(c_id,c_w_id,c_first) tablespace spc_encrypt_038_1;
create unique index storage_tsp_encrypt_index_038_3 on nebula_038.storage_tsp_encrypt_038(c_id) local tablespace spc_encrypt_038_1;
create index storage_tsp_encrypt_index_038_4 on nebula_038.storage_tsp_encrypt_038(c_city) tablespace spc_encrypt_038_1;
create index storage_tsp_encrypt_index_038_5 on nebula_038.storage_tsp_encrypt_038(c_last,c_street_1,c_phone) tablespace spc_encrypt_038_1;
create index storage_tsp_encrypt_index_038_6 on nebula_038.storage_tsp_encrypt_038(c_first) local tablespace spc_encrypt_038_1;
create index storage_tsp_encrypt_index_038_7 on nebula_038.storage_tsp_encrypt_038(c_d_id,c_street_2,c_state) local tablespace spc_encrypt_038_1;
insert into nebula_038.storage_tsp_encrypt_038 select * from nebula.tablespace_datafile_000;commit;

drop table nebula.tablespace_datafile_000;
drop table nebula_038.storage_tsp_encrypt_038;
drop user nebula cascade;
drop user nebula_038 cascade;
drop tablespace spc_encrypt_038_1 including contents and datafiles;