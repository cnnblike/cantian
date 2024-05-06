--- test  interval normal error
drop table if exists interval_t1;
create table interval_t1(f1 int, f2 int, f3 char(30))
PARTITION BY RANGE(f2)
INTERVAL(null)
(
 PARTITION interval_t1p1 values less than(10),
 PARTITION interval_t1p2 values less than(20),
 PARTITION interval_t1p3 values less than(30)
);
--- test  interval normal create
create table interval_t1(f1 int, f2 int, f3 char(30))
PARTITION BY RANGE(f2)
INTERVAL(10)
(
 PARTITION interval_t1p1 values less than(10),
 PARTITION interval_t1p2 values less than(20),
 PARTITION interval_t1p3 values less than(30)
);
--- test  interval normal insert order
insert into interval_t1 values(1,5,'hzy');
insert into interval_t1 values(2,15,'hzy');
insert into interval_t1 values(3,25,'hzy');
insert into interval_t1 values(4,35,'hzy');
insert into interval_t1 values(5,45,'hzy');
insert into interval_t1 values(6,55,'hzy');
insert into interval_t1 values(7,65,'hzy');
insert into interval_t1 values(8,75,'hzy');
insert into interval_t1 values(9,85,'hzy');
insert into interval_t1 values(10,95,'hzy');
insert into interval_t1 values(11,105,'hzy');
insert into interval_t1 values(12,115,'hzy');
commit;
--- test  interval normal select
select * from interval_t1 order by f1;
select * from interval_t1 where f2 < 30 order by f1;
select * from interval_t1 where f2 > 30 and f2 < 100 order by f1;
--- test  interval normal update normal
update interval_t1 set f2 = 69 where f2 = 65;
update interval_t1 set f2 = 79 where f2 = 75;
select * from interval_t1 order by f1;
commit;
--- test  interval normal update different partition
update interval_t1 set f2 = 69 where f2 = 55;
update interval_t1 set f2 = 79 where f2 = 105;
select * from interval_t1 order by f1;
commit;
--- test  interval normal delete
delete from interval_t1 where f2 < 30 order by f1;
delete from interval_t1 where f2 < 90 and f2 > 30 order by f1;
select * from interval_t1 order by f1;
commit;
--- test  interval normal delete all
delete from interval_t1;
select * from interval_t1 order by f1;
commit;
--- test  interval normal drop
drop table interval_t1;

--- test  interval normal insert no order
drop table if exists interval_t1;
create table interval_t1(f1 int, f2 int, f3 char(30))
PARTITION BY RANGE(f2)
INTERVAL(10)
(
 PARTITION interval_t1p1 values less than(10),
 PARTITION interval_t1p2 values less than(20),
 PARTITION interval_t1p3 values less than(30)
);
insert into interval_t1 values(1,5,'hzy');
insert into interval_t1 values(2,15,'hzy');
insert into interval_t1 values(3,25,'hzy');
insert into interval_t1 values(4,35,'hzy');
insert into interval_t1 values(5,115,'hzy');
insert into interval_t1 values(6,55,'hzy');
insert into interval_t1 values(7,65,'hzy');
insert into interval_t1 values(8,75,'hzy');
insert into interval_t1 values(9,85,'hzy');
insert into interval_t1 values(10,95,'hzy');
insert into interval_t1 values(11,105,'hzy');
insert into interval_t1 values(12,45,'hzy');
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_T1') ORDER BY PART#;

--- test  interval contain lob
drop table if exists interval_t2;
create table interval_t2(f1 int, f2 int, f3 clob)
PARTITION BY RANGE(f2)
INTERVAL(10)
(
 PARTITION interval_t2p1 values less than(10),
 PARTITION interval_t2p2 values less than(20),
 PARTITION interval_t2p3 values less than(30)
);
--- test  interval lob insert order
insert into interval_t2 values(1,5, 'hzy1');
insert into interval_t2 values(2,15,'hzy2');
insert into interval_t2 values(3,25,'hzy3');
insert into interval_t2 values(4,35,'hzy44');
insert into interval_t2 values(5,45,'hzy55');
insert into interval_t2 values(6,55,'hzy66');
insert into interval_t2 values(7,65,'hzy77');
insert into interval_t2 values(8,75,'hzy88');
insert into interval_t2 values(9,85,'hzy99');
insert into interval_t2 values(10,95,'hzy100');
insert into interval_t2 values(11,105,'hzy111');
insert into interval_t2 values(12,115,'hzy112');
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_T2') ORDER BY PART#;
select PART# from SYS_LOB_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_T2') ORDER BY PART#;

--- test  interval lob update normal
update interval_t2 set f2 = 69 where f2 = 65;
update interval_t2 set f2 = 79 where f2 = 75;
select * from interval_t2 order by f1 ;
commit;
--- test  interval lob update different partition
update interval_t2 set f2 = 69 where f2 = 55;
update interval_t2 set f2 = 79 where f2 = 105;
select * from interval_t2 order by f1;
commit;
--- test  interval lob delete
delete from interval_t2 where f2 < 30; 
delete from interval_t2 where f2 < 90 and f2 > 30;
select * from interval_t2 order by f1;
commit;
--- test  interval lob delete all
delete from interval_t2;
select * from interval_t2 order by f1;
commit;
drop table if exists interval_t2;


--- test  interval normal create index
drop table if exists interval_t1;
create table interval_t1(f1 int, f2 int, f3 char(30))
PARTITION BY RANGE(f2)
INTERVAL(10)
(
 PARTITION interval_t1p1 values less than(10),
 PARTITION interval_t1p2 values less than(20),
 PARTITION interval_t1p3 values less than(30)
);

--- test  interval normal create global index 
create index interval_t1_gidx1 on interval_t1(f1);
--- test  interval normal create local index 
create index interval_t1_lidx2 on interval_t1(f2) local;
insert into interval_t1 values(1,5,'hzy');
insert into interval_t1 values(2,15,'hzy');
insert into interval_t1 values(3,25,'hzy');
insert into interval_t1 values(4,35,'hzy');
insert into interval_t1 values(5,45,'hzy');
insert into interval_t1 values(6,55,'hzy');
insert into interval_t1 values(7,65,'hzy');
insert into interval_t1 values(8,75,'hzy');
insert into interval_t1 values(9,85,'hzy');
insert into interval_t1 values(10,95,'hzy');
insert into interval_t1 values(11,105,'hzy');
insert into interval_t1 values(12,115,'hzy');
commit;
--- test  interval index select
select * from interval_t1 order by f1;
select * from interval_t1 where f2 < 30 order by f1 ;
select * from interval_t1 where f2 > 30 and f2 < 100 order by f1;
--- test  interval index update normal
update interval_t1 set f2 = 69 where f2 = 65;
update interval_t1 set f2 = 79 where f2 = 75;
select * from interval_t1 order by f1;
commit;
--- test  interval index update different partition
update interval_t1 set f2 = 69 where f2 = 55;
update interval_t1 set f2 = 79 where f2 = 105;
select * from interval_t1 order by f1;
commit;
--- test  interval index delete
delete from interval_t1 where f2 < 30;
delete from interval_t1 where f2 < 90 and f2 > 30;
select * from interval_t1 order by f1;
commit;
--- test  interval index delete all
delete from interval_t1;select * from interval_t1 order by f1;
commit;
--- test  interval index drop
drop table interval_t1;

--- test interval partition ddl add/drop partition
drop table if exists interval_t1;
create table interval_t1(f1 int, f2 int, f3 char(30))
PARTITION BY RANGE(f2)
INTERVAL(10)
(
 PARTITION interval_t1p1 values less than(10),
 PARTITION interval_t1p2 values less than(20),
 PARTITION interval_t1p3 values less than(30),
 PARTITION interval_t1p4 values less than(50)
);

insert into interval_t1 values(1,5,'hzy');
insert into interval_t1 values(2,15,'hzy');
insert into interval_t1 values(3,25,'hzy');
insert into interval_t1 values(4,35,'hzy');
insert into interval_t1 values(5,45,'hzy');
insert into interval_t1 values(6,55,'hzy');
insert into interval_t1 values(7,65,'hzy');
insert into interval_t1 values(8,75,'hzy');
insert into interval_t1 values(9,85,'hzy');
insert into interval_t1 values(10,95,'hzy');
insert into interval_t1 values(11,105,'hzy');
insert into interval_t1 values(12,115,'hzy');
insert into interval_t1 values(13,145,'hzy');
insert into interval_t1 values(14,125,'hzy');
insert into interval_t1 values(15,195,'hzy');
alter table interval_t1 add partition p4 values less than(200);
alter table interval_t1 drop partition interval_t1p2;
alter table interval_t1 drop partition interval_t1p3;
alter table interval_t1 drop partition interval_t1p4;
alter table interval_t1 drop partition interval_t1p1;
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_T1') ORDER BY PART#;
select * from interval_t1 order by f1;
drop table interval_t1;

--- test interval partition ddl add/drop partition
drop table if exists interval_t1;
create table interval_t1(f1 int, f2 int, f3 char(30))
PARTITION BY RANGE(f2)
interval(10)
(
 PARTITION interval_t1p1 values less than(10),
 PARTITION interval_t1p2 values less than(20),
 PARTITION interval_t1p3 values less than(30),
 PARTITION interval_t1p4 values less than(50)
);

insert into interval_t1 values(1,5,'hzy');
insert into interval_t1 values(2,15,'hzy');
insert into interval_t1 values(3,25,'hzy');
insert into interval_t1 values(4,35,'hzy');
insert into interval_t1 values(5,45,'hzy');
insert into interval_t1 values(6,55,'hzy');
insert into interval_t1 values(7,65,'hzy');
insert into interval_t1 values(8,75,'hzy');
insert into interval_t1 values(9,85,'hzy');
insert into interval_t1 values(10,95,'hzy');
insert into interval_t1 values(11,105,'hzy');
insert into interval_t1 values(12,115,'hzy');
insert into interval_t1 values(13,145,'hzy');
insert into interval_t1 values(14,125,'hzy');
insert into interval_t1 values(15,195,'hzy');
insert into interval_t1 values(16,45,'hzy');
insert into interval_t1 values(17,165,'hzy');
insert into interval_t1 values(18,75,'hzy');
insert into interval_t1 values(20,135,'hzy');
select * from interval_t1 order by f1;
alter table interval_t1 truncate partition interval_t1p2;
alter table interval_t1 truncate partition interval_t1p3;
alter table interval_t1 truncate partition interval_t1p4;
alter table interval_t1 truncate partition interval_t1p1;
select * from interval_t1 order by f1;
truncate table interval_t1;
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_T1') ORDER BY PART#;
drop table interval_t1;

--- test interval partition ddl flashback
CREATE USER hzy IDENTIFIED BY Hzy12345;
DROP TABLE IF EXISTS hzy.FB_INTERVAL_T1;
CREATE TABLE hzy.FB_INTERVAL_T1 (ID INT)
PARTITION BY RANGE (ID)
interval(10)
(
PARTITION P1 VALUES LESS THAN (10),
PARTITION P2 VALUES LESS THAN (20)
);
INSERT INTO hzy.FB_INTERVAL_T1 VALUES(1);
INSERT INTO hzy.FB_INTERVAL_T1 VALUES(11);
INSERT INTO hzy.FB_INTERVAL_T1 VALUES(35);
INSERT INTO hzy.FB_INTERVAL_T1 VALUES(45);
INSERT INTO hzy.FB_INTERVAL_T1 VALUES(67);
INSERT INTO hzy.FB_INTERVAL_T1 VALUES(100);
COMMIT;
SELECT SLEEP(2);
UPDATE hzy.FB_INTERVAL_T1 SET ID = 2 WHERE ID = 1;
UPDATE hzy.FB_INTERVAL_T1 SET ID = 68 WHERE ID = 67;
COMMIT;
SELECT * FROM hzy.FB_INTERVAL_T1;
FLASHBACK TABLE hzy.FB_INTERVAL_T1 TO TIMESTAMP SYSTIMESTAMP - 1/(24*60*60);
SELECT * FROM hzy.FB_INTERVAL_T1;
DROP TABLE hzy.FB_INTERVAL_T1;

--- test interval partition ddl flashback drop
CREATE USER hzy IDENTIFIED BY Hzy12345;
DROP TABLE IF EXISTS hzy.FB_INTERVAL_T1;
CREATE TABLE hzy.FB_INTERVAL_T1 (ID INT)
PARTITION BY RANGE (ID)
interval(10)
(
PARTITION P1 VALUES LESS THAN (10),
PARTITION P2 VALUES LESS THAN (20)
);
INSERT INTO hzy.FB_INTERVAL_T1 VALUES(1);
INSERT INTO hzy.FB_INTERVAL_T1 VALUES(11);
INSERT INTO hzy.FB_INTERVAL_T1 VALUES(35);
INSERT INTO hzy.FB_INTERVAL_T1 VALUES(45);
INSERT INTO hzy.FB_INTERVAL_T1 VALUES(67);
INSERT INTO hzy.FB_INTERVAL_T1 VALUES(100);
COMMIT;
SELECT SLEEP(2);
DROP TABLE hzy.FB_INTERVAL_T1;
COMMIT;
SELECT * FROM hzy.FB_INTERVAL_T1;
FLASHBACK TABLE hzy.FB_INTERVAL_T1 TO BEFORE DROP;
SELECT * FROM hzy.FB_INTERVAL_T1;
DROP TABLE hzy.FB_INTERVAL_T1;

--- test PARTITION PRUNE TEST
DROP TABLE IF EXISTS hzy.PR_INTERVAL_T1;
CREATE TABLE hzy.PR_INTERVAL_T1 (ID1 INT, ID2 INT)
PARTITION BY RANGE (ID1)
INTERVAL(10)
(
PARTITION P1 VALUES LESS THAN (10),                 
PARTITION P2 VALUES LESS THAN (20),                
PARTITION P3 VALUES LESS THAN (30),                 
PARTITION P4 VALUES LESS THAN (40),                 
PARTITION P5 VALUES LESS THAN (50)                  
);


insert into hzy.PR_INTERVAL_T1 values(70,89);
insert into hzy.PR_INTERVAL_T1 values(100,89);
DROP TABLE hzy.PR_INTERVAL_T1;


-- test interval convert to range
-- tesinterval_t1 no auto-extend interval partition
create table hzy.CON_INTERVAL_T1(f1 int, f2 int, f3 clob)
PARTITION BY RANGE(f2)
interval(10)
(
 PARTITION interval_t1p1 values less than(10),
 PARTITION interval_t1p2 values less than(20),
 PARTITION interval_t1p3 values less than(30)
);

create index hzy.CON_INTERVAL_T1_idx on hzy.CON_INTERVAL_T1(f1,f2) local;
create index hzy.CON_INTERVAL_T2_idx on hzy.CON_INTERVAL_T1(f1);
select PARTTYPE,PARTCNT#,PARTKEYS#,FLAGS,INTERVAL,hex(BINTERVAL) from SYS_PART_OBJECTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1');
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_INDEX_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
select PART# from SYS_LOB_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;

alter table hzy.CON_INTERVAL_T1 set interval(20);
alter table hzy.CON_INTERVAL_T1 set interval();
select PARTTYPE,PARTCNT#,PARTKEYS#,FLAGS,INTERVAL,hex(BINTERVAL) from SYS_PART_OBJECTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1');
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_INDEX_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
select PART# from SYS_LOB_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;

INSERT INTO hzy.CON_INTERVAL_T1 VALUES(1,1,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(2,11,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(3,24,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(4,35,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(6,67,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(7,100,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(8,47,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(9,50,'hzy');

select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_INDEX_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
select PART# from SYS_LOB_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;

drop table hzy.CON_INTERVAL_T1;

-- tesinterval_t2 auto-extend interval partition
create table hzy.CON_INTERVAL_T1(f1 int, f2 int, f3 clob)
PARTITION BY RANGE(f2)
interval(10)
(
 PARTITION interval_t1p1 values less than(10),
 PARTITION interval_t1p2 values less than(20),
 PARTITION interval_t1p3 values less than(30)
);

create index hzy.CON_INTERVAL_T1_idx on hzy.CON_INTERVAL_T1(f1,f2) local;
create index hzy.CON_INTERVAL_T2_idx on hzy.CON_INTERVAL_T1(f1);
select PARTTYPE,PARTCNT#,PARTKEYS#,FLAGS,INTERVAL,hex(BINTERVAL) from SYS_PART_OBJECTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1');
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_INDEX_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
select PART# from SYS_LOB_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;

INSERT INTO hzy.CON_INTERVAL_T1 VALUES(1,1,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(2,11,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(3,24,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(4,35,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(6,67,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(7,100,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(8,47,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(9,50,'hzy');

alter table hzy.CON_INTERVAL_T1 set interval();
select PARTTYPE,PARTCNT#,PARTKEYS#,FLAGS,INTERVAL,hex(BINTERVAL) from SYS_PART_OBJECTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1');
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_INDEX_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
select PART# from SYS_LOB_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;

alter table hzy.CON_INTERVAL_T1 set interval(20);
select PARTTYPE,PARTCNT#,PARTKEYS#,FLAGS,INTERVAL,hex(BINTERVAL) from SYS_PART_OBJECTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1');
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_INDEX_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
select PART# from SYS_LOB_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(10,112,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(11,130,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(12,140,'hzy');
INSERT INTO hzy.CON_INTERVAL_T1 VALUES(13,155,'hzy');
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
select PART#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_INDEX_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
select PART# from SYS_LOB_PARTS where TABLE# = (select id from SYS_TABLES where name = 'CON_INTERVAL_T1') ORDER BY PART#;
drop table hzy.CON_INTERVAL_T1;

--- test  interval storage in spc
create tablespace INTER_SPC1 datafile 'interval_spc1' size 32M;
create tablespace INTER_SPC2 datafile 'interval_spc2' size 32M;
create tablespace INTER_SPC3 datafile 'interval_spc3' size 32M;

select TABLESPACE_NAME, BYTES, BLOCKS, STATUS, AUTOEXTENSIBLE, MAXBYTES, MAXBLOCKS, INCREMENT_BY, USER_BYTES, USER_BLOCKS, ONLINE_STATUS from dba_data_files where TABLESPACE_NAME = 'INTER_SPC1' order by file_id;
select TABLESPACE_NAME, BYTES, BLOCKS, STATUS, AUTOEXTENSIBLE, MAXBYTES, MAXBLOCKS, INCREMENT_BY, USER_BYTES, USER_BLOCKS, ONLINE_STATUS from dba_data_files where TABLESPACE_NAME = 'INTER_SPC2' order by file_id;
select TABLESPACE_NAME, BYTES, BLOCKS, STATUS, AUTOEXTENSIBLE, MAXBYTES, MAXBLOCKS, INCREMENT_BY, USER_BYTES, USER_BLOCKS, ONLINE_STATUS from dba_data_files  where TABLESPACE_NAME = 'INTER_SPC3' order by file_id;

DROP TABLE IF EXISTS interval_spc_t1;
create table interval_spc_t1(f1 int, f2 int, f3 CLOB)
PARTITION BY RANGE(f2)
INTERVAL(10)
STORE IN(tablespace INTER_SPC1,tablespace INTER_SPC2,tablespace INTER_SPC3)
(
 PARTITION interval_spc_t1p1 values less than(10),
 PARTITION interval_spc_t1p2 values less than(20),
 PARTITION interval_spc_t1p3 values less than(30)
);

select PART#, SPACE#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_SPC_T1') ORDER BY PART#;
select PART#, SPACE#,HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_INDEX_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_SPC_T1') ORDER BY PART#;
select PART#, SPACE# from SYS_LOB_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_SPC_T1') ORDER BY PART#;

--- test  interval normal insert order
insert into interval_spc_t1 values(1,5,'hzy');
insert into interval_spc_t1 values(2,15,'hzy');
insert into interval_spc_t1 values(3,25,'hzy');
insert into interval_spc_t1 values(4,35,'hzy');
insert into interval_spc_t1 values(5,45,'hzy');
insert into interval_spc_t1 values(6,55,'hzy');
insert into interval_spc_t1 values(7,65,'hzy');
insert into interval_spc_t1 values(8,75,'hzy');
insert into interval_spc_t1 values(9,85,'hzy');
insert into interval_spc_t1 values(10,95,'hzy');
insert into interval_spc_t1 values(11,105,'hzy');
insert into interval_spc_t1 values(12,115,'hzy');
insert into interval_spc_t1 values(13,125,'hzy');
insert into interval_spc_t1 values(14,135,'hzy');
insert into interval_spc_t1 values(15,145,'hzy');
insert into interval_spc_t1 values(16,155,'hzy');
insert into interval_spc_t1 values(17,165,'hzy');
insert into interval_spc_t1 values(18,175,'hzy');
insert into interval_spc_t1 values(19,185,'hzy');
insert into interval_spc_t1 values(20,195,'hzy');
insert into interval_spc_t1 values(21,205,'hzy');
insert into interval_spc_t1 values(22,215,'hzy');
insert into interval_spc_t1 values(23,225,'hzy');
insert into interval_spc_t1 values(24,235,'hzy');
commit;

select PART#, HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_SPC_T1') ORDER BY PART#;
select PART#, HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_INDEX_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_SPC_T1') ORDER BY PART#;
select PART# from SYS_LOB_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_SPC_T1') ORDER BY PART#;

--- test  interval normal select
select * from interval_spc_t1 ORDER BY F1;
select * from interval_spc_t1 where f2 < 30 ORDER BY F1;
select * from interval_spc_t1 where f2 > 30 and f2 < 100 ORDER BY F1;
--- test  interval normal update normal
update interval_spc_t1 set f2 = 69 where f2 = 65;
update interval_spc_t1 set f2 = 79 where f2 = 75;
select * from interval_spc_t1 ORDER BY F1;
commit;


DROP TABLE IF EXISTS interval_max_t1;
create table interval_max_t1(f1 int, f2 int, f3 clob)
PARTITION BY RANGE(f2)
interval(10)
(
 PARTITION interval_t11 values less than(10),
 PARTITION interval_t12 values less than(20),
 PARTITION interval_t13 values less than(30)
);

create index int_idx_t1 on  interval_max_t1(f1) local;
create index int_idx_t2 on  interval_max_t1(f2);
insert into interval_max_t1 values(1,5,'hzy');
insert into interval_max_t1 values(2,15,'hzy');
insert into interval_max_t1 values(3,25,'hzy');
select PART#, HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_MAX_T1') ORDER BY PART#;
select PART#, HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_INDEX_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_MAX_T1') ORDER BY PART#;
select PART# from SYS_LOB_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_MAX_T1') ORDER BY PART#;
insert into interval_max_t1 values(4,10225,'hzy');
insert into interval_max_t1 values(5,20165,'hzy');
insert into interval_max_t1 values(6,55,'hzy');
insert into interval_max_t1 values(7,65,'hzy');
insert into interval_max_t1 values(8,75,'hzy');
insert into interval_max_t1 values(9,85,'hzy');
insert into interval_max_t1 values(10,295,'hzy');
insert into interval_max_t1 values(11,105,'hzy');
insert into interval_max_t1 values(12,115,'hzy');
insert into interval_max_t1 values(13,125,'hzy');
insert into interval_max_t1 values(14,40035,'hzy');
insert into interval_max_t1 values(15,145,'hzy');
insert into interval_max_t1 values(16,30055,'hzy');
insert into interval_max_t1 values(17,165,'hzy');
insert into interval_max_t1 values(18,175,'hzy');
insert into interval_max_t1 values(19,185,'hzy');
insert into interval_max_t1 values(20,195,'hzy');
insert into interval_max_t1 values(21,205,'hzy');
insert into interval_max_t1 values(22,215,'hzy');
insert into interval_max_t1 values(23,225,'hzy');
insert into interval_max_t1 values(24,20045,'hzy');
select PART#, HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_MAX_T1') ORDER BY PART#;
select PART#, HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_INDEX_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_MAX_T1') ORDER BY PART#;
select PART# from SYS_LOB_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_MAX_T1') ORDER BY PART#;
select * from interval_max_t1 ORDER BY F1;
select * from interval_max_t1 ORDER BY F2;
commit;
drop table if exists MS_BIGTABLE_LOG;
--test date error
create table MS_BIGTABLE_LOG
(
  record_date DATE,
  col_1       VARCHAR2(2000)
)
PARTITION BY RANGE (record_date)
INTERVAL (10)
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-1', 'YYYY-MM-DD'))
);
  
create table MS_BIGTABLE_LOG
(
  record_date DATE,
  col_1       VARCHAR2(2000)
)
PARTITION BY RANGE (record_date)
INTERVAL (numtodsinterval(1,'day'))
(
  PARTITION P1 VALUES LESS THAN (10)
);

--test date normal
create table MS_BIGTABLE_LOG
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtodsinterval(1,'day'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-1', 'YYYY-MM-DD'))
);

create index idx_mx1 on MS_BIGTABLE_LOG(record_date);
create index idx_mx2 on MS_BIGTABLE_LOG(col_1) local;

insert into MS_BIGTABLE_LOG values(TO_DATE('2013-1-1', 'YYYY-MM-DD'),'hzy');
insert into MS_BIGTABLE_LOG values(TO_DATE('2014-1-2', 'YYYY-MM-DD'),'hzy');
insert into MS_BIGTABLE_LOG values(TO_DATE('2014-1-3', 'YYYY-MM-DD'),'hzy');
insert into MS_BIGTABLE_LOG values(TO_DATE('2014-1-4', 'YYYY-MM-DD'),'hzy');
insert into MS_BIGTABLE_LOG values(TO_DATE('2014-1-5', 'YYYY-MM-DD'),'hzy');
insert into MS_BIGTABLE_LOG values(TO_DATE('2014-1-6', 'YYYY-MM-DD'),'hzy');
insert into MS_BIGTABLE_LOG values(TO_DATE('2014-1-7', 'YYYY-MM-DD'),'hzy');
insert into MS_BIGTABLE_LOG values(TO_DATE('2014-2-1', 'YYYY-MM-DD'),'hzy');
insert into MS_BIGTABLE_LOG values(TO_DATE('2014-3-1', 'YYYY-MM-DD'),'hzy');
insert into MS_BIGTABLE_LOG values(TO_DATE('2014-4-1', 'YYYY-MM-DD'),'hzy');
insert into MS_BIGTABLE_LOG values(TO_DATE('2014-5-1', 'YYYY-MM-DD'),'hzy');
insert into MS_BIGTABLE_LOG values(TO_DATE('2015-5-1', 'YYYY-MM-DD'),'hzy');

select * from MS_BIGTABLE_LOG order by record_date;

drop table if exists interval_spc_t1;
--test number error
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f9)
INTERVAL(10)
(
 PARTITION interval_spc_t1p1 values less than(10)
);

create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f8)
INTERVAL(10)
(
 PARTITION interval_spc_t1p1 values less than(10)
);

create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f1)
INTERVAL('abc')
(
 PARTITION interval_spc_t1p1 values less than(10)
);

create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f1)
INTERVAL(-10.5)
(
 PARTITION interval_spc_t1p1 values less than(10)
);

create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f1)
INTERVAL('-10.5')
(
 PARTITION interval_spc_t1p1 values less than(10)
);

create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f1)
INTERVAL('10.5')
(
 PARTITION interval_spc_t1p1 values less than(20),
 PARTITION interval_spc_t1p2 values less than(10)
);

create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f1)
INTERVAL('10.5')
(
 PARTITION interval_spc_t1p1 values less than(20),
 PARTITION interval_spc_t1p2 values less than(MAXVALUE)
);

create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f1,f2)
INTERVAL('10.5')
(
 PARTITION interval_spc_t1p1 values less than(10,20)
);

create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f1)
INTERVAL(10,20)
(
 PARTITION interval_spc_t1p1 values less than(10,20)
);

--test number normal
drop table if exists interval_spc_t1;
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f7)
INTERVAL(10)
(
 PARTITION interval_spc_t1p1 values less than(10)
);

insert into interval_spc_t1 values(1, 200000000, 5.5, 5.555, 5.5555, 5.5556, 5.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(2, 200000000, 5.5, 5.555, 5.5555, 5.5556, 15.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(3, 200000000, 5.5, 5.555, 5.5555, 5.5556, 25.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(4, 200000000, 5.5, 5.555, 5.5555, 5.5556, 35.96, 'hzy', 'hzy');
insert into interval_spc_t1 values(5, 200000000, 5.5, 5.555, 5.5555, 5.5556, 45.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(6, 200000000, 5.5, 5.555, 5.5555, 5.5556, 55.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(7, 200000000, 5.5, 5.555, 5.5555, 5.5556, 105.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(8, 200000000, 5.5, 5.555, 5.5555, 5.5556, 85.576, 'hzy', 'hzy');
insert into interval_spc_t1 values(9, 200000000, 5.5, 5.555, 5.5555, 5.5556, 75.776, 'hzy', 'hzy');
insert into interval_spc_t1 values(10, 200000000, 5.5, 5.555, 5.5555, 5.5556, 135.176, 'hzy', 'hzy');

select * from interval_spc_t1 order by f1;


drop table if exists interval_spc_t1;
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f6)
INTERVAL(10)
(
 PARTITION interval_spc_t1p1 values less than(10)
);

insert into interval_spc_t1 values(1, 200000000, 5.5, 5.555, 5.5555, 5.5556, 5.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(2, 200000000, 5.5, 5.555, 5.5555, 15.5556, 15.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(3, 200000000, 5.5, 5.555, 5.5555, 25.5556, 25.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(4, 200000000, 5.5, 5.555, 5.5555, 35.5556, 35.96, 'hzy', 'hzy');
insert into interval_spc_t1 values(5, 200000000, 5.5, 5.555, 5.5555, 45.5556, 45.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(6, 200000000, 5.5, 5.555, 5.5555, 55.5556, 55.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(7, 200000000, 5.5, 5.555, 5.5555, 65.5556, 105.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(8, 200000000, 5.5, 5.555, 5.5555, 75.5556, 85.576, 'hzy', 'hzy');
insert into interval_spc_t1 values(9, 200000000, 5.5, 5.555, 5.5555, 135.5556, 75.776, 'hzy', 'hzy');
insert into interval_spc_t1 values(10, 200000000, 5.5, 5.555, 5.5555, 85.5556, 135.176, 'hzy', 'hzy');

select * from interval_spc_t1 order by f1;

drop table if exists interval_spc_t1;
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f5)
INTERVAL(10)
(
 PARTITION interval_spc_t1p1 values less than(10)
);

insert into interval_spc_t1 values(1, 200000000, 5.5, 5.555, 15.5555, 5.5556, 5.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(2, 200000000, 5.5, 5.555, 25.5555, 5.5556, 15.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(3, 200000000, 5.5, 5.555, 45.5555, 5.5556, 25.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(4, 200000000, 5.5, 5.555, 75.5555, 5.5556, 35.96, 'hzy', 'hzy');
insert into interval_spc_t1 values(5, 200000000, 5.5, 5.555, 85.5555, 5.5556, 45.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(6, 200000000, 5.5, 5.555, 115.5555, 5.5556, 55.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(7, 200000000, 5.5, 5.555, 65.5555, 5.5556, 105.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(8, 200000000, 5.5, 5.555, 95.5555, 5.5556, 85.576, 'hzy', 'hzy');
insert into interval_spc_t1 values(9, 200000000, 5.5, 5.555, 45.5555, 5.5556, 75.776, 'hzy', 'hzy');
insert into interval_spc_t1 values(10, 200000000, 5.5, 5.555, 55.5555, 5.5556, 135.176, 'hzy', 'hzy');

select * from interval_spc_t1 order by f1;

drop table if exists interval_spc_t1;
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f4)
INTERVAL(10)
(
 PARTITION interval_spc_t1p1 values less than(10)
);

drop table if exists interval_spc_t1;
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f3)
INTERVAL(10)
(
 PARTITION interval_spc_t1p1 values less than(10)
);

drop table if exists interval_spc_t1;
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f2)
INTERVAL(10)
(
 PARTITION interval_spc_t1p1 values less than(10)
);

drop table if exists interval_spc_t1;
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f1)
INTERVAL(10)
(
 PARTITION interval_spc_t1p1 values less than(10)
);

drop table if exists interval_spc_t1;
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f1)
INTERVAL(10.5)
(
 PARTITION interval_spc_t1p1 values less than(10)
);

drop table if exists interval_spc_t1;
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f1)
INTERVAL('10.5')
(
 PARTITION interval_spc_t1p1 values less than(10)
);

drop table if exists interval_spc_t1;
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 2), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f3)
INTERVAL(0.5)
(
 PARTITION interval_spc_t1p1 values less than(10)
);
create index int_idx1 on interval_spc_t1(f3);
insert into interval_spc_t1 values(1, 200000000, 5.5, 5.555, 5.5555, 5.5556, 5.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(2, 200000000, 15.5, 5.555, 5.5555, 5.5556, 15.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(3, 200000000, 16.35, 5.555, 5.5555, 5.5556, 25.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(4, 200000000, 16.4, 5.555, 5.5555, 5.5556, 35.96, 'hzy', 'hzy');
insert into interval_spc_t1 values(5, 200000000, 12.5, 5.555, 5.5555, 5.5556, 45.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(6, 200000000, 12.05, 5.555, 5.5555, 5.5556, 55.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(7, 200000000, 10.0, 5.555, 5.5555, 5.5556, 105.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(8, 200000000, 10.5, 5.555, 5.5555, 5.5556, 85.576, 'hzy', 'hzy');
insert into interval_spc_t1 values(9, 200000000, 11.5, 5.555, 5.5555, 5.5556, 75.776, 'hzy', 'hzy');
insert into interval_spc_t1 values(10, 200000000,15.5, 5.555, 5.5555, 5.5556, 135.176, 'hzy', 'hzy');

select * from interval_spc_t1 order by f1;

drop table if exists MS_BIGTABLE_LOG;
drop table if exists interval_spc_t1;
drop table if exists hash_tbl_001;
create table hash_tbl_001(c_id int,c_d_id number(10,4)) partition by hash(c_id)
(
partition p1,
partition p2,
partition p3,
partition p4
);
insert into hash_tbl_001 values(1,1);
insert into hash_tbl_001 values(2,2);
set serveroutput on;
declare
v_sum int;
v_max int;
cursor hashcursor is select c_id,c_d_id from hash_tbl_001 partition(p3) order by 1,2 asc;
begin
  open hashcursor;
  fetch hashcursor into v_sum,v_max;
  while hashcursor%found loop
  dbe_output.print_line('sum(c_id)'||'   '||'max(c_big)');
  dbe_output.print_line(v_sum||'      '||v_max);
  fetch hashcursor into v_sum,v_max;
  end loop;
  close hashcursor;
end;
/
drop table if exists hash_tbl_001;

create user hzy_dts identified by Cantian_234;
create tablespace  partinterval_tablespace1 datafile 'partinterval_acid_001' size 32M AUTOEXTEND on next 100M;
create tablespace  partinterval_tablespace2 datafile 'partinterval_acid_002' size 32M AUTOEXTEND on next 100M;
drop table if exists HZY_DTS.ACID_INTERVAL_DML_TBL_000;
CREATE TABLE HZY_DTS.ACID_INTERVAL_DML_TBL_000(C_ID INT,
C_D_ID INT NOT NULL,
C_W_ID INT NOT NULL,
C_FIRST VARCHAR(64) NOT NULL,
C_MIDDLE CHAR(2),
C_LAST VARCHAR(64) NOT NULL,
C_STREET_1 VARCHAR(20) NOT NULL,
C_STREET_2 VARCHAR(20),
C_CITY VARCHAR(20) NOT NULL,
C_STATE CHAR(2) NOT NULL,
C_ZIP CHAR(9) NOT NULL,
C_PHONE CHAR(16) NOT NULL,
C_SINCE TIMESTAMP,
C_CREDIT CHAR(2) NOT NULL,
C_CREDIT_LIM NUMERIC(12,2),
C_DISCOUNT NUMERIC(4,4),
C_BALANCE NUMERIC(12,2),
C_YTD_PAYMENT REAL NOT NULL,
C_PAYMENT_CNT NUMBER NOT NULL,
C_DELIVERY_CNT BOOL NOT NULL,
C_END DATE NOT NULL,
C_VCHAR VARCHAR(1000),
C_DATA CLOB,
C_TEXT BLOB,
C_CLOB CLOB,
primary key (c_id,c_d_id,c_w_id));
insert into  HZY_DTS.ACID_INTERVAL_DML_TBL_000 select 0,0,0,'AA'||'is0cmvls','OE','AA'||'BAR0BARBAR','bkili'||'0'||'fcxcle'||'0','pmbwo'||'0'||'vhvpaj'||'0','dyf'||'0'||'rya'||'0','uq',4800||'0',940||'0'||205||'0','2017-12-31 10:51:47','GC',50000.0,0.4361328,-10.0,10.0,1,true,'2017-12-31 10:51:47','QVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSF'||'0','QVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSF1','1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323','QVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSF1CLOB';
commit;
CREATE or replace procedure hzy_dts_dml_interval_proc_001(startall int,endall int) as
i INT;
BEGIN
 if startall <= endall then
  FOR i IN startall..endall LOOP
        insert into HZY_DTS.ACID_INTERVAL_DML_TBL_000 select c_id+i,c_d_id+i,c_w_id+i,'AA'||'iscmvls',c_middle,'AA'||'BAR'||i||'ddBARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since+i,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end+i,c_vchar,c_data,c_text,c_clob from HZY_DTS.ACID_INTERVAL_DML_TBL_000 where c_id=0;commit;
  END LOOP;
 end if;
END;
/
call hzy_dts_dml_interval_proc_001(1,1000);
delete from HZY_DTS.ACID_INTERVAL_DML_TBL_000 where c_id=0;
commit;

drop table HZY_DTS.ACID_INTERVAL_DML_TBL_001 purge;
CREATE TABLE HZY_DTS.ACID_INTERVAL_DML_TBL_001(C_ID INT,C_D_ID INT NOT NULL,C_W_ID INT NOT NULL,C_FIRST VARCHAR(64) NOT NULL,C_MIDDLE CHAR(2),C_LAST VARCHAR(64) NOT NULL,C_STREET_1 VARCHAR(20) NOT NULL,C_STREET_2 VARCHAR(20),C_CITY VARCHAR(20) NOT NULL,C_STATE CHAR(2) NOT NULL,C_ZIP CHAR(9) NOT NULL,C_PHONE CHAR(16) NOT NULL,C_SINCE TIMESTAMP,C_CREDIT CHAR(2) NOT NULL,C_CREDIT_LIM NUMERIC(12,2),C_DISCOUNT NUMERIC(4,4),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL NOT NULL,C_PAYMENT_CNT NUMBER NOT NULL,C_DELIVERY_CNT BOOL NOT NULL,C_END DATE NOT NULL,C_VCHAR VARCHAR(1000),C_DATA CLOB,C_TEXT BLOB,C_CLOB CLOB)PARTITION BY RANGE(C_ID)INTERVAL(100)(PARTITION PART_1 VALUES LESS THAN (201),PARTITION PART_2 VALUES LESS THAN (401),PARTITION PART_3 VALUES LESS THAN (601),PARTITION PART_4 VALUES LESS THAN (801),PARTITION PART_5 VALUES LESS THAN (1001),PARTITION PART_6 VALUES LESS THAN (1201),PARTITION PART_7 VALUES LESS THAN (1401),PARTITION PART_8 VALUES LESS THAN (1601),PARTITION PART_9 VALUES LESS THAN (1801));

CREATE INDEX HZY_DTS.ACID_INTERVAL_DML_IDX_001_1 ON HZY_DTS.ACID_INTERVAL_DML_TBL_001(C_ID) LOCAL;
CREATE INDEX HZY_DTS.ACID_INTERVAL_DML_IDX_001_0 ON HZY_DTS.ACID_INTERVAL_DML_TBL_001(C_FIRST) ;
insert into HZY_DTS.ACID_INTERVAL_DML_TBL_001 select * from HZY_DTS.ACID_INTERVAL_DML_TBL_000;
delete from HZY_DTS.ACID_INTERVAL_DML_TBL_001 where mod(c_id,2)=0;
update HZY_DTS.ACID_INTERVAL_DML_TBL_001 set c_first='aaaaaaaaaaaaaaa',c_vchar=upper(c_vchar),c_last=lower(c_last),c_data='qvldetanrbrburbmzqujshoqnggsmnteccipriirdhirwiynpfzcsykxxyscdsfqafhatdokmjogfgslucunvwb',c_text=lpad('1243245324554354325',50,'1232343'),c_clob='qvldetanrbrburbmzqujshoqnggsmnteccipriirdhirwiyn';
update HZY_DTS.ACID_INTERVAL_DML_TBL_001 set c_id=c_id+1,c_data='QVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQAFHATDOKMJOGFGSLUCUNVWBTBFSQZJECLBACPJQDHJCHVGBNRKJRGJRYCSGPPSOCNEVAUTZFEOSVIAXBVOBFFNJUQHLVNWUQHTGJQSBFACWJPBVPGTHPYXCPMNUTCJXRBXXBMRMWWXCEPWIIXVVLEYAJAUTCESLJHRSFSMSNMZJCXVCUXDWMYIJBWYWIIRSGOCWKTEDBBOKHYNZNCEAESUIFKGOAAFAGUGETFHBCYLKSRJUKVBUFQCVBFFAXNZSSYQUIDVWEFKTKNRCHYXFPHUNQKTWNIPNSRVQSWSYMOCNOEXBABWNPMNXSVSHDSJHAZCAUVQJGVQJFKJJGQRCEYJMBUMKAPMCBXEASHYBPGEKJKFEZTHNJBHFQIWBUTBXTKJKNDYYHJCHVGBNRKJRGJRYCSGPPSOCNEVAUTZFEOSVIAXBVOBF',c_text=lpad('124324543256546324554354325',500,'7687389015'),c_clob='QVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQAFHATDOKMJOGFGSLUCUNVWBTBFSQZJECLBACPJQDHJCHVGBNRKJRGJRYCSGPPSOCNEVAUTZFEOSVIAXBVOBFFNJUQHLVNWUQHTGJQSBFACWJPBVPGTHDAFFDAFDAFDAFDASFDBMRMWWXCEPWIIXVVLEYAJAUTCESLJHRSFSMSNMZJCXVCUXDWMYIJBWYWIIRSGOCWKTEDBBOKHYNZNCEAESUIFKGOAAFAGUGETFHBCYLKSRJUKVBUFQCVBFFAXNZSSYQUIDVWEFKTKNRCHYXFPHUNQKTWNIPNSRVQSWSYMOCNOEXBABWNPMNXSVSHDSJHAZCAUVQJGVQJFKJJGQRCEYJMBUMKAPMCBXEASHYBPGEKJKFEZTHNJBHFQIWBUTBXTKJKNDYYHJCHVGBNRKJRGJRYCSGPPSOCNEVAUTZFSDFEOSVIAX' where mod(c_id,2)=0;
select distinct c_first,count(*) from HZY_DTS.ACID_INTERVAL_DML_TBL_001 group by c_first order by 1;
select distinct c_first,count(*) from HZY_DTS.ACID_INTERVAL_DML_TBL_001 where c_id  <5000 group by c_first order by 1;
select distinct c_first,count(*) from HZY_DTS.ACID_INTERVAL_DML_TBL_001 where c_end <'2018-08-01 10:51:47' group by c_first order by 1;
select distinct c_first,count(*) from HZY_DTS.ACID_INTERVAL_DML_TBL_001 where c_id  >5000 and c_first like 'AA%' and c_since >'2018-08-01 10:51:47' and c_end >'2018-08-01 10:51:47' group by c_first order by 1;
select distinct c_first,count(*) from HZY_DTS.ACID_INTERVAL_DML_TBL_001 where c_d_id  <5000 and (c_last like 'c%' or c_last like 'AA%')group by c_first order by 1;
select distinct c_first,count(*) from HZY_DTS.ACID_INTERVAL_DML_TBL_001 where c_first  like 'AA%' group by c_first order by 1;
select distinct c_first,count(*) from HZY_DTS.ACID_INTERVAL_DML_TBL_001 where c_first like 'AA%' and (c_last like 'c%' or c_last like 'AA%') and (c_vchar like 'c_varchar%' or c_vchar like 'QVLDETANRBR%')  group by c_first order by 1;
truncate table HZY_DTS.ACID_INTERVAL_DML_TBL_001;
select distinct c_first,count(*) from HZY_DTS.ACID_INTERVAL_DML_TBL_001 group by c_first order by 1;
select distinct c_first,count(*) from HZY_DTS.ACID_INTERVAL_DML_TBL_001 where c_id  <5000 group by c_first order by 1;
select distinct c_first,count(*) from HZY_DTS.ACID_INTERVAL_DML_TBL_001 where c_end <'2018-08-01 10:51:47' group by c_first order by 1;
select distinct c_first,count(*) from HZY_DTS.ACID_INTERVAL_DML_TBL_001 where c_id  >5000 and c_first like 'AA%' and c_since >'2018-08-01 10:51:47' and c_end >'2018-08-01 10:51:47' group by c_first order by 1;
select distinct c_first,count(*) from HZY_DTS.ACID_INTERVAL_DML_TBL_001 where c_d_id  <5000 and (c_last like 'c%' or c_last like 'AA%')group by c_first order by 1;
select distinct c_first,count(*) from HZY_DTS.ACID_INTERVAL_DML_TBL_001 where c_first  like 'AA%' group by c_first order by 1;
select distinct c_first,count(*) from HZY_DTS.ACID_INTERVAL_DML_TBL_001 where c_first like 'AA%' and (c_last like 'c%' or c_last like 'AA%') and (c_vchar like 'c_varchar%' or c_vchar like 'QVLDETANRBR%')  group by c_first order by 1;
drop table HZY_DTS.ACID_INTERVAL_DML_TBL_001;

drop table if exists HZY_DTS.ACID_INTERVAL_DML_TBL_001;
CREATE TABLE HZY_DTS.ACID_INTERVAL_DML_TBL_001(C_ID INT,C_D_ID INT NOT NULL,C_W_ID INT NOT NULL,C_FIRST VARCHAR(64) NOT NULL,C_MIDDLE CHAR(2),C_LAST VARCHAR(64) NOT NULL,C_STREET_1 VARCHAR(20) NOT NULL,C_STREET_2 VARCHAR(20),C_CITY VARCHAR(20) NOT NULL,C_STATE CHAR(2) NOT NULL,C_ZIP CHAR(9) NOT NULL,C_PHONE CHAR(16) NOT NULL,C_SINCE TIMESTAMP,C_CREDIT CHAR(2) NOT NULL,C_CREDIT_LIM NUMERIC(12,2),C_DISCOUNT NUMERIC(4,4),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL NOT NULL,C_PAYMENT_CNT NUMBER NOT NULL,C_DELIVERY_CNT BOOL NOT NULL,C_END DATE NOT NULL,C_VCHAR VARCHAR(1000),C_DATA CLOB,C_TEXT BLOB,C_CLOB CLOB)PARTITION BY RANGE(C_ID)INTERVAL(100)(PARTITION PART_1 VALUES LESS THAN (201),PARTITION PART_2 VALUES LESS THAN (401),PARTITION PART_3 VALUES LESS THAN (601),PARTITION PART_4 VALUES LESS THAN (801),PARTITION PART_5 VALUES LESS THAN (1001),PARTITION PART_6 VALUES LESS THAN (1201),PARTITION PART_7 VALUES LESS THAN (1401),PARTITION PART_8 VALUES LESS THAN (1601),PARTITION PART_9 VALUES LESS THAN (1801));
insert into HZY_DTS.ACID_INTERVAL_DML_TBL_001 select * from HZY_DTS.ACID_INTERVAL_DML_TBL_000;
commit;
truncate table HZY_DTS.ACID_INTERVAL_DML_TBL_001;
drop table HZY_DTS.ACID_INTERVAL_DML_TBL_001 purge;

---dts2
drop table if exists HZY_DTS.ACID_INTERVAL_DML_TBL_000;
CREATE TABLE HZY_DTS.ACID_INTERVAL_DML_TBL_000(C_ID INT,
C_D_ID INT NOT NULL,
C_W_ID INT NOT NULL,
C_FIRST VARCHAR(64) NOT NULL,
C_MIDDLE CHAR(2),
C_LAST VARCHAR(64) NOT NULL,
C_STREET_1 VARCHAR(20) NOT NULL,
C_STREET_2 VARCHAR(20),
C_CITY VARCHAR(20) NOT NULL,
C_STATE CHAR(2) NOT NULL,
C_ZIP CHAR(9) NOT NULL,
C_PHONE CHAR(16) NOT NULL,
C_SINCE TIMESTAMP,
C_CREDIT CHAR(2) NOT NULL,
C_CREDIT_LIM NUMERIC(12,2),
C_DISCOUNT NUMERIC(4,4),
C_BALANCE NUMERIC(12,2),
C_YTD_PAYMENT REAL NOT NULL,
C_PAYMENT_CNT NUMBER NOT NULL,
C_DELIVERY_CNT BOOL NOT NULL,
C_END DATE NOT NULL,
C_VCHAR VARCHAR(1000),
C_DATA CLOB,
C_TEXT BLOB,
C_CLOB CLOB,
primary key (c_id,c_d_id,c_w_id));
insert into  HZY_DTS.ACID_INTERVAL_DML_TBL_000 select 0,0,0,'AA'||'is0cmvls','OE','AA'||'BAR0BARBAR','bkili'||'0'||'fcxcle'||'0','pmbwo'||'0'||'vhvpaj'||'0','dyf'||'0'||'rya'||'0','uq',4800||'0',940||'0'||205||'0','2017-12-31 10:51:47','GC',50000.0,0.4361328,-10.0,10.0,1,true,'2017-12-31 10:51:47','QVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECC348493214893542NPFZCSYKXXYSCDSF'||'0','QVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSF1','1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323','QVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSFQVLDETANRBRBURBMZQUJSHOQNGGSMNTECCIPRIIRDHIRWIYNPFZCSYKXXYSCDSF1CLOB';
commit;
CREATE or replace procedure hzy_dts_dml_interval_proc_001(startall int,endall int) as
i INT;
BEGIN
 if startall <= endall then
  FOR i IN startall..endall LOOP
        insert into HZY_DTS.ACID_INTERVAL_DML_TBL_000 select c_id+i,c_d_id+i,c_w_id+i,'AA'||'iscmvls',c_middle,'AA'||'BAR'||i||'ddBARBAR',c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since+i,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end+i,c_vchar,c_data,c_text,c_clob from HZY_DTS.ACID_INTERVAL_DML_TBL_000 where c_id=0;commit;
  END LOOP;
 end if;
END;
/
call hzy_dts_dml_interval_proc_001(1,2000);
delete from HZY_DTS.ACID_INTERVAL_DML_TBL_000 where c_id=0;
commit;
drop table if exists HZY_DTS.ACID_INTERVAL_DML_TBL_001;
CREATE TABLE HZY_DTS.ACID_INTERVAL_DML_TBL_001(C_ID INT,C_D_ID INT NOT NULL,C_W_ID INT NOT NULL,C_FIRST VARCHAR(64) NOT NULL,C_MIDDLE CHAR(2),C_LAST VARCHAR(64) NOT NULL,C_STREET_1 VARCHAR(20) NOT NULL,C_STREET_2 VARCHAR(20),C_CITY VARCHAR(20) NOT NULL,C_STATE CHAR(2) NOT NULL,C_ZIP CHAR(9) NOT NULL,C_PHONE CHAR(16) NOT NULL,C_SINCE TIMESTAMP,C_CREDIT CHAR(2) NOT NULL,C_CREDIT_LIM NUMERIC(12,2),C_DISCOUNT NUMERIC(4,4),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL NOT NULL,C_PAYMENT_CNT NUMBER NOT NULL,C_DELIVERY_CNT BOOL NOT NULL,C_END DATE NOT NULL,C_VCHAR VARCHAR(1000),C_DATA CLOB,C_TEXT BLOB,C_CLOB CLOB)PARTITION BY RANGE(C_ID)INTERVAL(100)(PARTITION PART_1 VALUES LESS THAN (201),PARTITION PART_2 VALUES LESS THAN (401),PARTITION PART_3 VALUES LESS THAN (601),PARTITION PART_4 VALUES LESS THAN (801),PARTITION PART_5 VALUES LESS THAN (1001),PARTITION PART_6 VALUES LESS THAN (1201),PARTITION PART_7 VALUES LESS THAN (1401),PARTITION PART_8 VALUES LESS THAN (1601),PARTITION PART_9 VALUES LESS THAN (1801));
insert into HZY_DTS.ACID_INTERVAL_DML_TBL_001 select * from hzy_dts.acid_interval_dml_tbl_000;
alter table HZY_DTS.ACID_INTERVAL_DML_TBL_001  drop partition PART_8;
alter table HZY_DTS.ACID_INTERVAL_DML_TBL_001 set interval();
drop table HZY_DTS.ACID_INTERVAL_DML_TBL_001 purge;
drop table HZY_DTS.ACID_INTERVAL_DML_TBL_000 purge;

drop table if exists inter_ym_type;
create table inter_ym_type
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtoyminterval(1,'month'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-29', 'YYYY-MM-DD'))
);

drop table if exists inter_ym_type;
create table inter_ym_type
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtoyminterval(1,'month'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-30', 'YYYY-MM-DD'))
);

drop table if exists inter_ym_type;
create table inter_ym_type
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtoyminterval(1,'month'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-31', 'YYYY-MM-DD'))
);

drop table if exists inter_ym_type;
create table inter_ym_type
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtoyminterval(1,'month'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-9', 'YYYY-MM-DD'))
);

insert into inter_ym_type values(TO_DATE('2014-2-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-3-8', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-3-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-4-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-6-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-7-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-8-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-11-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-12-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2015-8-9', 'YYYY-MM-DD'), 'day');

select * from inter_ym_type order by record_date;
select PART#, HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTER_YM_TYPE') ORDER BY PART#;

drop table if exists inter_ym_type;


drop table if exists inter_ym_type;
create table inter_ym_type
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtoyminterval(12,'month'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-9', 'YYYY-MM-DD'))
);

insert into inter_ym_type values(TO_DATE('2014-2-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-3-8', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-3-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-4-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-6-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-7-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-8-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-11-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-12-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2015-1-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2015-12-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2016-1-9', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2018-1-9', 'YYYY-MM-DD'), 'day');

select * from inter_ym_type order by record_date;
select PART#, HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTER_YM_TYPE') ORDER BY PART#;
drop table if exists inter_ym_type;

create table inter_ym_type
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtoyminterval(0,'month'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-9', 'YYYY-MM-DD'))
);

create table inter_ym_type
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtoyminterval(0.2,'month'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-9', 'YYYY-MM-DD'))
);

create table inter_ym_type
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtodsinterval(0,'day'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-9', 'YYYY-MM-DD'))
);


drop table if exists interval_spc_t1;
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f3)
INTERVAL(0)
(
 PARTITION interval_spc_t1p1 values less than(10)
);

drop table if exists inter_ym_type;
create table inter_ym_type
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtodsinterval(30,'day'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-29', 'YYYY-MM-DD'))
);

create table inter_ym_type
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtodsinterval(30,'day'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-30', 'YYYY-MM-DD'))
);

create table inter_ym_type
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtodsinterval(30,'day'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-31', 'YYYY-MM-DD'))
);

drop table if exists inter_ym_type;

create table inter_ym_type
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtodsinterval(-1,'day'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-9', 'YYYY-MM-DD'))
);

drop table if exists inter_ym_type;

create table inter_ym_type
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtoyminterval(-1,'month'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-9', 'YYYY-MM-DD'))
);

drop table if exists inter_ym_type;

--- test convert range to interval
drop table if exists inter_ym_type;
create table inter_ym_type
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-9', 'YYYY-MM-DD'))
);
alter table inter_ym_type set interval();
alter table inter_ym_type set interval(null);
alter table inter_ym_type set interval(numtoyminterval(0.1,'month'));
alter table inter_ym_type set interval(numtoyminterval(-1,'month'));
alter table inter_ym_type set interval(123);
alter table inter_ym_type set interval(numtodsinterval(0,'day'));
alter table inter_ym_type set interval(numtodsinterval(-1,'day'));
alter table inter_ym_type set interval(numtodsinterval(1,'day'));
insert into inter_ym_type values(TO_DATE('2014-1-10', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-1-11', 'YYYY-MM-DD'), 'day');
insert into inter_ym_type values(TO_DATE('2014-1-12', 'YYYY-MM-DD'), 'day');
select * from inter_ym_type order by record_date;
select PART#, HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTER_YM_TYPE') ORDER BY PART#;
--- test convert interval to interval
alter table inter_ym_type set interval(numtoyminterval(1,'month'));
select PART#, HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTER_YM_TYPE') ORDER BY PART#;
insert into inter_ym_type values(TO_DATE('2014-2-12', 'YYYY-MM-DD'), 'month');
insert into inter_ym_type values(TO_DATE('2014-3-12', 'YYYY-MM-DD'), 'month');
insert into inter_ym_type values(TO_DATE('2014-4-12', 'YYYY-MM-DD'), 'month');
select * from inter_ym_type order by record_date;
select PART#, HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTER_YM_TYPE') ORDER BY PART#;
drop table if exists inter_ym_type;

--- test convert range to interval
drop table if exists interval_spc_t1;
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 2), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f3)
(
 PARTITION interval_spc_t1p1 values less than(MAXVALUE)
);
alter table interval_spc_t1 set interval();
alter table interval_spc_t1 set interval(NULL);
alter table interval_spc_t1 set interval(-1);
alter table interval_spc_t1 set interval(0.5);

drop table if exists interval_spc_t1;
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 2), f4 DECIMAL(38, 0), f5 float, f6 double, f7 real, f8 char(10), f9 varchar(10))
PARTITION BY RANGE(f3)
(
 PARTITION interval_spc_t1p1 values less than(5)
);
alter table interval_spc_t1 set interval();
alter table interval_spc_t1 set interval(NULL);
alter table interval_spc_t1 set interval(-1);
alter table interval_spc_t1 set interval(0.5);

insert into interval_spc_t1 values(1, 200000000, 5.5, 5.555, 5.5555, 5.5556, 5.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(2, 200000000, 15.5, 5.555, 5.5555, 5.5556, 15.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(3, 200000000, 16.35, 5.555, 5.5555, 5.5556, 25.76, 'hzy', 'hzy');
alter table interval_spc_t1 set interval();
select PART#, HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_SPC_T1') ORDER BY PART#;
alter table interval_spc_t1 set interval(0.5);
insert into interval_spc_t1 values(4, 200000000, 16.4, 5.555, 5.5555, 5.5556, 35.96, 'hzy', 'hzy');
insert into interval_spc_t1 values(5, 200000000, 12.5, 5.555, 5.5555, 5.5556, 45.76, 'hzy', 'hzy');
alter table interval_spc_t1 set interval(1);
insert into interval_spc_t1 values(6, 200000000, 17.05, 5.555, 5.5555, 5.5556, 55.76, 'hzy', 'hzy');
insert into interval_spc_t1 values(8, 200000000, 18.5, 5.555, 5.5555, 5.5556, 85.576, 'hzy', 'hzy');
insert into interval_spc_t1 values(9, 200000000, 19.5, 5.555, 5.5555, 5.5556, 75.776, 'hzy', 'hzy');
select PART#, HIBOUNDLEN,HIBOUNDVAL,INITRANS,PCTFREE,FLAGS,hex(BHIBOUNDVAL) from SYS_TABLE_PARTS where TABLE# = (select id from SYS_TABLES where name = 'INTERVAL_SPC_T1') ORDER BY PART#;
drop table if exists interval_spc_t1;

drop table if exists "T_TESTNODEB";
drop user if exists cmedb;
create user cmedb identified by Huawei12#$;
grant connect,resource to cmedb;
create tablespace cmedb datafile 'cmedb.dat' size 100M;

CREATE TABLE "T_TESTNODEB"
(
  "PLANID" BINARY_INTEGER NOT NULL,
  "NODEBID" BINARY_INTEGER NOT NULL,
  PRIMARY KEY("PLANID", "NODEBID")
)
PARTITION BY RANGE ("PLANID")
INTERVAL(1)
(
    PARTITION P_0 VALUES LESS THAN (1) TABLESPACE "CMEDB" INITRANS 2 PCTFREE 8
)
TABLESPACE "CMEDB"
INITRANS 2
MAXTRANS 255
PCTFREE 8;
INSERT INTO "T_TESTNODEB" ("PLANID","NODEBID") values
  (1,1);
INSERT INTO "T_TESTNODEB" ("PLANID","NODEBID") values
  (2,1);
INSERT INTO "T_TESTNODEB" ("PLANID","NODEBID") values
  (4,1);
INSERT INTO "T_TESTNODEB" ("PLANID","NODEBID") values
  (5,1);
COMMIT;
CREATE INDEX "IDX_T_TESTNODEB2" ON "T_TESTNODEB"("NODEBID")
TABLESPACE "CMEDB"
INITRANS 2
PCTFREE 8;

exp users=cmedb PARALLEL=4 filetype=bin file="partition_cme4.dmp";
drop table if exists "T_TESTNODEB";
drop user if exists cmedb;
drop tablespace cmedb including contents and datafiles;
drop table if exists test_interval_number;
CREATE TABLE test_interval_number(C_ID INT,C_D_ID bigint NOT NULL,C_W_ID tinyint unsigned NOT NULL)
PARTITION BY RANGE(C_ID)INTERVAL(100)STORE IN(tablespace users,tablespace users)
(PARTITION PART_1 VALUES LESS THAN (201),PARTITION PART_2 VALUES LESS THAN (401),PARTITION PART_3 VALUES LESS THAN (601),
PARTITION PART_4 VALUES LESS THAN (801),PARTITION PART_5 VALUES LESS THAN (1001),PARTITION PART_6 VALUES LESS THAN (1201),
PARTITION PART_7 VALUES LESS THAN (1401),PARTITION PART_8 VALUES LESS THAN (1601),PARTITION PART_9 VALUES LESS THAN (1801));
insert into test_interval_number values(1803,1903,1903);
insert into test_interval_number values(1903,1903,1903);
insert into test_interval_number values(2000,1903,1903);

select partcnt# from SYS_PART_OBJECTS where TABLE# = (select id from SYS_TABLES where name = upper('test_interval_number'));
drop table test_interval_number;

drop table if exists no_commit_acid_imme_tbl_025;
create table no_commit_acid_imme_tbl_025(c_id int,c_since timestamp,c_end date) partition by range(c_end) interval(numtoyminterval (1,'MONTH')) (partition p1 values less than (to_date('2015-01-29','yyyy-mm-dd')));
insert into no_commit_acid_imme_tbl_025 values(1, TO_DATE('2014-4-12', 'YYYY-MM-DD'),TO_DATE('2014-5-12', 'YYYY-MM-DD'));
insert into no_commit_acid_imme_tbl_025 values(1, TO_DATE('2014-4-12', 'YYYY-MM-DD'),TO_DATE('2015-5-29', 'YYYY-MM-DD'));
alter table no_commit_acid_imme_tbl_025 set interval(numtodsinterval (2,'DAY'));

drop table if exists no_commit_acid_imme_tbl_025;
create table no_commit_acid_imme_tbl_025(c_id int,c_since timestamp,c_end date) partition by range(c_end) interval(numtodsinterval (1,'DAY')) (partition p1 values less than (to_date('2015-01-28','yyyy-mm-dd')));
insert into no_commit_acid_imme_tbl_025 values(1, TO_DATE('2014-4-12', 'YYYY-MM-DD'),TO_DATE('2015-1-29', 'YYYY-MM-DD'));
insert into no_commit_acid_imme_tbl_025 values(1, TO_DATE('2014-4-12', 'YYYY-MM-DD'),TO_DATE('2015-1-30', 'YYYY-MM-DD'));
alter table no_commit_acid_imme_tbl_025 set interval(numtoyminterval (1,'MONTH'));

drop table if exists inter_ym_type;
create table inter_ym_type
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtoyminterval(1,'month'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-9', 'YYYY-MM-DD'))
);

insert into inter_ym_type values(TO_DATE('2014-2-9', 'YYYY-MM-DD'), 'month');
drop table inter_ym_type;

drop table if exists interval_spc_t1;
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0))
PARTITION BY RANGE(f3)
INTERVAL(10)
(
 PARTITION interval_spc_t1p1 values less than(10)
);
create index idx_interval_1 on interval_spc_t1(f3) local;
create index idx_interval_2 on interval_spc_t1(f1) local;
insert into interval_spc_t1 values(1,2,3,444);
insert into interval_spc_t1 values(1,2,33,444);
insert into interval_spc_t1 values(1,2,333,444);
commit;

alter index idx_interval_1 on interval_spc_t1 rebuild;

alter index idx_interval_2 on interval_spc_t1 rebuild;

alter table interval_spc_t1 set interval(20);
alter table interval_spc_t1 drop partition interval_spc_t1p1;
drop index idx_interval_2 on interval_spc_t1;
drop table interval_spc_t1;

drop table if exists interval_spc_t1;
create table interval_spc_t1(f1 int, f2 bigint, f3 number(38, 0), f4 DECIMAL(38, 0))
PARTITION BY RANGE(f3)
INTERVAL(10)
(
 PARTITION interval_spc_t1p1 values less than(10),
 PARTITION interval_spc_t1p2 values less than(20)
);
create index idx_interval_1 on interval_spc_t1(f3) local;
create index idx_interval_2 on interval_spc_t1(f4) local;
insert into interval_spc_t1 values(1,2,32,444);
commit;

alter table interval_spc_t1 set interval(12);
alter table interval_spc_t1 drop partition interval_spc_t1p2;
drop index idx_interval_2 on interval_spc_t1;
drop table interval_spc_t1;

drop table if exists test_pno;
create table test_pno(c1 int, c2 int) partition by range(c1) interval(1)
(
 partition p1 values less than(10),
 partition p2 values less than(20), 
 partition p3 values less than(40)
 );
 insert into test_pno values(41, 41);
 select USER#, PART#, NAME, HIBOUNDLEN, HIBOUNDVAL from tablepart$ where table#=(select id from table$ where name = 'TEST_PNO') order by PART#;
 alter table test_pno drop partition p1;
 insert into test_pno values(42,42);
 select USER#, PART#, NAME, HIBOUNDLEN, HIBOUNDVAL from tablepart$ where table#=(select id from table$ where name = 'TEST_PNO') order by PART#;
 drop table test_pno;

--- test interval dictionary cache optimization
drop table if exists interval_table;
create table interval_table (id int, grade int, name varchar(8000), descp varchar(8000)) partition by range(id) interval(10)
(
 partition p1 values less than(10),
 partition p2 values less than(20),
 partition p3 values less than(30)
);
insert into interval_table values (10, 60, lpad('aaa', 20, 'bbb'), lpad('bbb', 20, 'aaa'));
insert into interval_table values (41943039, 60, lpad('aaa', 20, 'bbb'), lpad('bbb', 20, 'aaa'));
insert into interval_table values (419430, 60, lpad('aaa', 8000, 'bbb'), lpad('bbb', 8000, 'aaa'));
insert into interval_table values (4194, 60, lpad('aaa', 8000, 'bbb'), lpad('bbb', 8000, 'aaa'));
insert into interval_table values (419, 60, lpad('aaa', 8000, 'bbb'), lpad('bbb', 8000, 'aaa'));
select count(*) from interval_table;
drop table if exists interval_table;
 