create tablespace  partrange_tablespace1 datafile 'tablespace_partrange_001' size 32M AUTOEXTEND on next 16M extent autoallocate;
create tablespace  partrange_tablespace2 datafile 'tablespace_partrange_002' size 32M AUTOEXTEND on next 16M extent autoallocate;
alter tablespace partrange_tablespace1 autopurge off;
alter tablespace partrange_tablespace2 autopurge off;
purge recyclebin;
drop user if exists nebula cascade;
create user nebula identified by Cantian_234;
drop table if exists NEBULA.STRG_RANGE_DML_MUL_TBL_000;
CREATE TABLE NEBULA.STRG_RANGE_DML_MUL_TBL_000(C_ID INT,
C_D_ID INT NOT NULL,
C_W_ID INT NOT NULL,
C_FIRST VARCHAR(64) NOT NULL,
C_MIDDLE CHAR(3),
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
C_TEXT BLOB);

drop table if exists NEBULA.STRG_RANGE_DML_MUL_TBL_ASSIST;
CREATE TABLE NEBULA.STRG_RANGE_DML_MUL_TBL_ASSIST(id int, c char);
INSERT INTO NEBULA.STRG_RANGE_DML_MUL_TBL_ASSIST VALUES(0, 'A');
INSERT INTO NEBULA.STRG_RANGE_DML_MUL_TBL_ASSIST VALUES(1, 'B');
INSERT INTO NEBULA.STRG_RANGE_DML_MUL_TBL_ASSIST VALUES(2, 'C');
INSERT INTO NEBULA.STRG_RANGE_DML_MUL_TBL_ASSIST VALUES(3, 'D');
INSERT INTO NEBULA.STRG_RANGE_DML_MUL_TBL_ASSIST VALUES(4, 'E');
INSERT INTO NEBULA.STRG_RANGE_DML_MUL_TBL_ASSIST VALUES(5, 'F');
INSERT INTO NEBULA.STRG_RANGE_DML_MUL_TBL_ASSIST VALUES(6, 'G');
INSERT INTO NEBULA.STRG_RANGE_DML_MUL_TBL_ASSIST VALUES(7, 'H');
INSERT INTO NEBULA.STRG_RANGE_DML_MUL_TBL_ASSIST VALUES(8, 'I');
INSERT INTO NEBULA.STRG_RANGE_DML_MUL_TBL_ASSIST VALUES(9, 'J');
COMMIT;
CREATE or replace procedure nebula_ddl_range_func_001(PART_NO int, SUBPART_NO int)  as 
i INT;
j INT;
c_part CHAR;
c_subpart CHAR;
BEGIN
  FOR i IN 1..40 LOOP
    j := part_no * 200 + subpart_no * 40 + i;
    select c into c_part from NEBULA.STRG_RANGE_DML_MUL_TBL_ASSIST where id = part_no;
	select c into c_subpart from NEBULA.STRG_RANGE_DML_MUL_TBL_ASSIST where id = subpart_no;
	insert into NEBULA.STRG_RANGE_DML_MUL_TBL_000 values(j, j, j, c_part || j ||'Cabdg', c_subpart || 'OE', 'CantianDB' || subpart_no ||'Bdbed','bki'|| part_no ||'fdger','pwo'|| j ||'vedef', c_part || j ||'Yed3f','uq',4801|| j ,940|| j ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| j ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| j ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');
	commit;
  END LOOP;
END;
/

call nebula_ddl_range_func_001(0, 0);
call nebula_ddl_range_func_001(0, 1);
call nebula_ddl_range_func_001(0, 2);
call nebula_ddl_range_func_001(0, 3);
call nebula_ddl_range_func_001(0, 4);
call nebula_ddl_range_func_001(1, 0);
call nebula_ddl_range_func_001(1, 1);
call nebula_ddl_range_func_001(1, 2);
call nebula_ddl_range_func_001(1, 3);
call nebula_ddl_range_func_001(1, 4);
call nebula_ddl_range_func_001(2, 0);
call nebula_ddl_range_func_001(2, 1);
call nebula_ddl_range_func_001(2, 2);
call nebula_ddl_range_func_001(2, 3);
call nebula_ddl_range_func_001(2, 4);
call nebula_ddl_range_func_001(3, 0);
call nebula_ddl_range_func_001(3, 1);
call nebula_ddl_range_func_001(3, 2);
call nebula_ddl_range_func_001(3, 3);
call nebula_ddl_range_func_001(3, 4);
call nebula_ddl_range_func_001(4, 0);
call nebula_ddl_range_func_001(4, 1);
call nebula_ddl_range_func_001(4, 2);
call nebula_ddl_range_func_001(4, 3);
call nebula_ddl_range_func_001(4, 4);
call nebula_ddl_range_func_001(5, 0);
call nebula_ddl_range_func_001(5, 1);
call nebula_ddl_range_func_001(5, 2);
call nebula_ddl_range_func_001(5, 3);
call nebula_ddl_range_func_001(5, 4);
call nebula_ddl_range_func_001(6, 0);
call nebula_ddl_range_func_001(6, 1);
call nebula_ddl_range_func_001(6, 2);
call nebula_ddl_range_func_001(6, 3);
call nebula_ddl_range_func_001(6, 4);
call nebula_ddl_range_func_001(7, 0);
call nebula_ddl_range_func_001(7, 1);
call nebula_ddl_range_func_001(7, 2);
call nebula_ddl_range_func_001(7, 3);
call nebula_ddl_range_func_001(7, 4);
call nebula_ddl_range_func_001(8, 0);
call nebula_ddl_range_func_001(8, 1);
call nebula_ddl_range_func_001(8, 2);
call nebula_ddl_range_func_001(8, 3);
call nebula_ddl_range_func_001(8, 4);
call nebula_ddl_range_func_001(9, 0);
call nebula_ddl_range_func_001(9, 1);
call nebula_ddl_range_func_001(9, 2);
call nebula_ddl_range_func_001(9, 3);
call nebula_ddl_range_func_001(9, 4);
commit;

--list-range
drop table if exists NEBULA.STRG_RANGE_DDL_MUL_TBL_001;
CREATE TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_ID INT,C_D_ID INT NOT NULL,C_W_ID INT NOT NULL,C_FIRST VARCHAR(64) NOT NULL,C_MIDDLE CHAR(3),C_LAST VARCHAR(64) NOT NULL,C_STREET_1 VARCHAR(20) NOT NULL,C_STREET_2 VARCHAR(20),C_CITY VARCHAR(64) NOT NULL,C_STATE CHAR(2) NOT NULL,C_ZIP CHAR(9) NOT NULL,C_PHONE CHAR(16) NOT NULL,C_SINCE TIMESTAMP,C_CREDIT CHAR(2) NOT NULL,C_CREDIT_LIM NUMERIC(12,2),C_DISCOUNT NUMERIC(4,4),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL NOT NULL,C_PAYMENT_CNT NUMBER NOT NULL,C_DELIVERY_CNT BOOLEAN NOT NULL,C_END DATE NOT NULL,C_VCHAR VARCHAR(1000),C_DATA CLOB,C_TEXT BLOB ) PARTITION BY list(C_STREET_1) SUBPARTITION BY RANGE(C_D_ID, C_MIDDLE) (
PARTITION PART_1 VALUES('bki0fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_11 VALUES LESS THAN(41, 'B'),
 SUBPARTITION PART_12 VALUES LESS THAN(81, 'C'),
 SUBPARTITION PART_13 VALUES LESS THAN(121, 'D'),
 SUBPARTITION PART_14 VALUES LESS THAN(161, 'E'),
 SUBPARTITION PART_15 VALUES LESS THAN(201, 'F')
),
PARTITION PART_2 VALUES('bki1fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_21 VALUES LESS THAN(241, 'B'),
 SUBPARTITION PART_22 VALUES LESS THAN(281, 'C'),
 SUBPARTITION PART_23 VALUES LESS THAN(321, 'D'),
 SUBPARTITION PART_24 VALUES LESS THAN(361, 'E'),
 SUBPARTITION PART_25 VALUES LESS THAN(401, 'F')
),
PARTITION PART_3 VALUES('bki2fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_31 VALUES LESS THAN(441, 'B'),
 SUBPARTITION PART_32 VALUES LESS THAN(481, 'C'),
 SUBPARTITION PART_33 VALUES LESS THAN(521, 'D'),
 SUBPARTITION PART_34 VALUES LESS THAN(561, 'E'),
 SUBPARTITION PART_35 VALUES LESS THAN(601, 'F')
),
PARTITION PART_4 VALUES('bki3fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_41 VALUES LESS THAN(641, 'B'),
 SUBPARTITION PART_42 VALUES LESS THAN(681, 'C'),
 SUBPARTITION PART_43 VALUES LESS THAN(721, 'D'),
 SUBPARTITION PART_44 VALUES LESS THAN(761, 'E'),
 SUBPARTITION PART_45 VALUES LESS THAN(801, 'F')
),
PARTITION PART_5 VALUES('bki4fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_51 VALUES LESS THAN(841, 'B'),
 SUBPARTITION PART_52 VALUES LESS THAN(881, 'C'),
 SUBPARTITION PART_53 VALUES LESS THAN(921, 'D'),
 SUBPARTITION PART_54 VALUES LESS THAN(961, 'E'),
 SUBPARTITION PART_55 VALUES LESS THAN(1001, 'F')
),
PARTITION PART_6 VALUES('bki5fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_61 VALUES LESS THAN(1041, 'B'),
 SUBPARTITION PART_62 VALUES LESS THAN(1081, 'C'),
 SUBPARTITION PART_63 VALUES LESS THAN(1121, 'D'),
 SUBPARTITION PART_64 VALUES LESS THAN(1161, 'E'),
 SUBPARTITION PART_65 VALUES LESS THAN(1201, 'F')
),
PARTITION PART_7 VALUES('bki6fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_71 VALUES LESS THAN(1241, 'B'),
 SUBPARTITION PART_72 VALUES LESS THAN(1281, 'C'),
 SUBPARTITION PART_73 VALUES LESS THAN(1321, 'D'),
 SUBPARTITION PART_74 VALUES LESS THAN(1361, 'E'),
 SUBPARTITION PART_75 VALUES LESS THAN(1401, 'F')
),
PARTITION PART_8 VALUES('bki7fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_81 VALUES LESS THAN(1441, 'B'),
 SUBPARTITION PART_82 VALUES LESS THAN(1481, 'C'),
 SUBPARTITION PART_83 VALUES LESS THAN(1521, 'D'),
 SUBPARTITION PART_84 VALUES LESS THAN(1561, 'E'),
 SUBPARTITION PART_85 VALUES LESS THAN(1601, 'F')
),
PARTITION PART_9 VALUES('bki8fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_91 VALUES LESS THAN(1641, 'B'),
 SUBPARTITION PART_92 VALUES LESS THAN(1681, 'C'),
 SUBPARTITION PART_93 VALUES LESS THAN(1721, 'D'),
 SUBPARTITION PART_94 VALUES LESS THAN(1761, 'E'),
 SUBPARTITION PART_95 VALUES LESS THAN(1801, 'F')
),
PARTITION PART_10 VALUES(DEFAULT) tablespace partrange_tablespace1);
CREATE  UNIQUE INDEX  NEBULA.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_ID,C_CITY,C_FIRST,C_LAST) parallel 4 tablespace partrange_tablespace2;
CREATE UNIQUE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_CITY,C_LAST,C_STREET_2) parallel 5 tablespace partrange_tablespace2;
CREATE UNIQUE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_STREET_2,C_D_ID) parallel 7 tablespace partrange_tablespace2;
CREATE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_CITY,C_FIRST) parallel 15 LOCAL tablespace partrange_tablespace2;
CREATE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_STREET_1,C_W_ID) parallel 18 LOCAL tablespace partrange_tablespace2;
INSERT INTO NEBULA.STRG_RANGE_DDL_MUL_TBL_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000;
COMMIT;

--测试基础DML操作
savepoint aa;
delete from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 where mod(c_id, 2) = 1;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set c_w_id = c_w_id + 100 where c_id < 41;
select c_w_id from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 where c_id < 41;
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set c_d_id = c_d_id - 80 where c_d_id >= 41 and c_d_id < 81;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_12);
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set c_street_1 = 'bki0fdger', c_d_id = c_d_id - 300 where c_id >= 201 and c_id < 241;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_21);
rollback to savepoint aa;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_12);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_21);

ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop subpartition part_91;
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_91 to before drop;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 modify partition part_9 add subpartition part_91 values less than(1641, 'B');
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
INSERT INTO NEBULA.STRG_RANGE_DDL_MUL_TBL_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000 where c_id >= 1601 and c_id < 1641;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop PARTITION PART_10;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'J' || 2000 ||'Bdbed','bki'|| 10 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');

--测试两种添加分区的方案，一种指定子分区定义;一种不指定，按照默认子分区
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 ADD PARTITION P11 VALUES('bki10fdger') tablespace partrange_tablespace1;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'J' || 2000 ||'Bdbed','bki'|| 10 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');
SELECT count(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 PARTITION(P11);
COMMIT;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 DROP PARTITION P11;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 ADD PARTITION P11 VALUES('bki10fdger') tablespace partrange_tablespace1
(
 SUBPARTITION P11_1 VALUES LESS THAN(1841, 'B') tablespace partrange_tablespace1,
 SUBPARTITION P11_2 VALUES LESS THAN(1881, 'C') tablespace partrange_tablespace2,
 SUBPARTITION P11_3 VALUES LESS THAN(1921, 'D') tablespace partrange_tablespace1,
 SUBPARTITION P11_4 VALUES LESS THAN(1961, 'E') tablespace partrange_tablespace2,
 SUBPARTITION P11_5 VALUES LESS THAN(2001, 'F') tablespace partrange_tablespace1
);
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'J' || 2000 ||'Bdbed','bki'|| 10 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');
SELECT count(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 PARTITION(P11);
COMMIT;

--测试truncate以及闪回操作
select count(*) from nebula.strg_range_ddl_mul_tbl_001;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
alter table nebula.strg_range_ddl_mul_tbl_001 truncate subpartition part_92;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_92 to before truncate;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
alter table nebula.strg_range_ddl_mul_tbl_001 truncate subpartition part_92;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into nebula.strg_range_ddl_mul_tbl_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000 where c_id > 1640 and c_id <= 1660;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_92 to before truncate;
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_92 to before truncate force;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_92 to before truncate force;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
purge recyclebin;
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_92 to before truncate;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);

alter table nebula.strg_range_ddl_mul_tbl_001 truncate partition part_9;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
flashback table nebula.strg_range_ddl_mul_tbl_001 partition part_9 to before truncate;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
alter table nebula.strg_range_ddl_mul_tbl_001 truncate partition part_9;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into nebula.strg_range_ddl_mul_tbl_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000 where c_id > 1600 and c_id <= 1800;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
flashback table nebula.strg_range_ddl_mul_tbl_001 partition part_9 to before truncate;
flashback table nebula.strg_range_ddl_mul_tbl_001 partition part_9 to before truncate force;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
purge recyclebin;
commit;

--测试分区的split
alter table nebula.strg_range_ddl_mul_tbl_001 split subpartition part_93 at(1700, 'D') into (subpartition part_931 tablespace partrange_tablespace1, subpartition part_932 tablespace partrange_tablespace2);
select count(*) from nebula.strg_range_ddl_mul_tbl_001 subpartition(part_931);
select count(*) from nebula.strg_range_ddl_mul_tbl_001 subpartition(part_932);
select name, dbe_diagnose.dba_segsize(0, entry) from sys_sub_table_parts where name = 'PART_931';
select name, dbe_diagnose.dba_segsize(0, entry) from sys_sub_table_parts where name = 'PART_932';
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
delete from nebula.strg_range_ddl_mul_tbl_001 where c_id >= 1681 and c_id < 1721;
insert into nebula.strg_range_ddl_mul_tbl_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000 where c_id >= 1681 and c_id < 1721;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 subpartition(part_931);
select count(*) from nebula.strg_range_ddl_mul_tbl_001 subpartition(part_932);

alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 add column_add1 varchar(40);
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set column_add1=C_FIRST;
SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;

SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;
--add constraint-非分区键部分索引;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 add constraint PK_RANGE_DDL_MUL_TBL_001 primary key(C_W_ID);
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 add constraint UK_RANGE_DDL_MUL_TBL_001 unique(C_ID,C_W_ID);
SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 modify C_STREET_1 varchar(100);
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 modify C_W_ID float;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column C_LAST;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column C_STREET_2;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column C_D_ID;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column C_STREET_1;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column C_PHONE;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column column_add1;
SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;

--truncate不连续多分区;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 TRUNCATE PARTITION PART_1 reuse storage;
truncate table NEBULA.STRG_RANGE_DDL_MUL_TBL_001;
DELETE FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 WHERE (C_ID - 5*(FLOOR(C_ID/5)))=3;
SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 DROP PARTITION P11;
SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop constraint UK_RANGE_DDL_MUL_TBL_001;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop constraint PK_RANGE_DDL_MUL_TBL_001;
drop table NEBULA.STRG_RANGE_DDL_MUL_TBL_001;
purge recyclebin;

--list-list
drop table if exists NEBULA.STRG_RANGE_DDL_MUL_TBL_001;
CREATE TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_ID INT,C_D_ID INT NOT NULL,C_W_ID INT NOT NULL,C_FIRST VARCHAR(64) NOT NULL,C_MIDDLE CHAR(3),C_LAST VARCHAR(64) NOT NULL,C_STREET_1 VARCHAR(20) NOT NULL,C_STREET_2 VARCHAR(20),C_CITY VARCHAR(64) NOT NULL,C_STATE CHAR(2) NOT NULL,C_ZIP CHAR(9) NOT NULL,C_PHONE CHAR(16) NOT NULL,C_SINCE TIMESTAMP,C_CREDIT CHAR(2) NOT NULL,C_CREDIT_LIM NUMERIC(12,2),C_DISCOUNT NUMERIC(4,4),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL NOT NULL,C_PAYMENT_CNT NUMBER NOT NULL,C_DELIVERY_CNT BOOLEAN NOT NULL,C_END DATE NOT NULL,C_VCHAR VARCHAR(1000),C_DATA CLOB,C_TEXT BLOB ) PARTITION BY list(C_STREET_1) SUBPARTITION BY LIST(C_LAST) (
PARTITION PART_1 VALUES('bki0fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_11 VALUES('CantianDB0Bdbed'),
 SUBPARTITION PART_12 VALUES('CantianDB1Bdbed'),
 SUBPARTITION PART_13 VALUES('CantianDB2Bdbed'),
 SUBPARTITION PART_14 VALUES('CantianDB3Bdbed'),
 SUBPARTITION PART_15 VALUES('CantianDB4Bdbed')
),
PARTITION PART_2 VALUES('bki1fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_21 VALUES('CantianDB0Bdbed'),
 SUBPARTITION PART_22 VALUES('CantianDB1Bdbed'),
 SUBPARTITION PART_23 VALUES('CantianDB2Bdbed'),
 SUBPARTITION PART_24 VALUES('CantianDB3Bdbed'),
 SUBPARTITION PART_25 VALUES('CantianDB4Bdbed')
),
PARTITION PART_3 VALUES('bki2fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_31 VALUES('CantianDB0Bdbed'),
 SUBPARTITION PART_32 VALUES('CantianDB1Bdbed'),
 SUBPARTITION PART_33 VALUES('CantianDB2Bdbed'),
 SUBPARTITION PART_34 VALUES('CantianDB3Bdbed'),
 SUBPARTITION PART_35 VALUES('CantianDB4Bdbed')
),
PARTITION PART_4 VALUES('bki3fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_41 VALUES('CantianDB0Bdbed'),
 SUBPARTITION PART_42 VALUES('CantianDB1Bdbed'),
 SUBPARTITION PART_43 VALUES('CantianDB2Bdbed'),
 SUBPARTITION PART_44 VALUES('CantianDB3Bdbed'),
 SUBPARTITION PART_45 VALUES('CantianDB4Bdbed')
),
PARTITION PART_5 VALUES('bki4fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_51 VALUES('CantianDB0Bdbed'),
 SUBPARTITION PART_52 VALUES('CantianDB1Bdbed'),
 SUBPARTITION PART_53 VALUES('CantianDB2Bdbed'),
 SUBPARTITION PART_54 VALUES('CantianDB3Bdbed'),
 SUBPARTITION PART_55 VALUES('CantianDB4Bdbed')
),
PARTITION PART_6 VALUES('bki5fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_61 VALUES('CantianDB0Bdbed'),
 SUBPARTITION PART_62 VALUES('CantianDB1Bdbed'),
 SUBPARTITION PART_63 VALUES('CantianDB2Bdbed'),
 SUBPARTITION PART_64 VALUES('CantianDB3Bdbed'),
 SUBPARTITION PART_65 VALUES('CantianDB4Bdbed')
),
PARTITION PART_7 VALUES('bki6fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_71 VALUES('CantianDB0Bdbed'),
 SUBPARTITION PART_72 VALUES('CantianDB1Bdbed'),
 SUBPARTITION PART_73 VALUES('CantianDB2Bdbed'),
 SUBPARTITION PART_74 VALUES('CantianDB3Bdbed'),
 SUBPARTITION PART_75 VALUES('CantianDB4Bdbed')
),
PARTITION PART_8 VALUES('bki7fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_81 VALUES('CantianDB0Bdbed'),
 SUBPARTITION PART_82 VALUES('CantianDB1Bdbed'),
 SUBPARTITION PART_83 VALUES('CantianDB2Bdbed'),
 SUBPARTITION PART_84 VALUES('CantianDB3Bdbed'),
 SUBPARTITION PART_85 VALUES('CantianDB4Bdbed')
),
PARTITION PART_9 VALUES('bki8fdger')tablespace partrange_tablespace1
(
 SUBPARTITION PART_91 VALUES('CantianDB0Bdbed'),
 SUBPARTITION PART_92 VALUES('CantianDB1Bdbed'),
 SUBPARTITION PART_93 VALUES('CantianDB2Bdbed'),
 SUBPARTITION PART_94 VALUES('CantianDB3Bdbed'),
 SUBPARTITION PART_95 VALUES('CantianDB4Bdbed')
),
PARTITION PART_10 VALUES(DEFAULT) tablespace partrange_tablespace1);
CREATE  UNIQUE INDEX  NEBULA.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_ID,C_CITY,C_FIRST,C_LAST) parallel 6  tablespace partrange_tablespace2;
CREATE UNIQUE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_CITY,C_LAST,C_STREET_2) parallel 8 tablespace partrange_tablespace2;
CREATE UNIQUE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_STREET_2,C_D_ID) parallel 11 tablespace partrange_tablespace2;
CREATE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_CITY,C_FIRST) parallel 2 LOCAL tablespace partrange_tablespace2;
CREATE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_STREET_1,C_W_ID) parallel 10  LOCAL tablespace partrange_tablespace2;
INSERT INTO NEBULA.STRG_RANGE_DDL_MUL_TBL_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000;
COMMIT;

--测试基础DML操作
savepoint aa;
delete from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 where mod(c_id, 2) = 1;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set c_w_id = c_w_id + 100 where c_id < 41;
select c_w_id from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 where c_id < 41;
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set c_last = 'CantianDB0Bdbed' where c_last = 'CantianDB1Bdbed';
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_12);
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set c_last = 'CantianDB0Bdbed', c_street_1 = 'bki0fdger' where c_street_1 = 'bki1fdger' and c_last = 'CantianDB0Bdbed';
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_21);
rollback to savepoint aa;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_12);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_21);

ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop subpartition part_91;
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_91 to before drop;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 modify partition part_9 add subpartition part_91 VALUES('CantianDB0Bdbed');
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
INSERT INTO NEBULA.STRG_RANGE_DDL_MUL_TBL_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000 where c_id >= 1601 and c_id < 1641;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_91);
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop PARTITION PART_10;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'CantianDB' || 1 ||'Bdbed','bki'|| 9 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');

--测试两种添加分区的方案，一种指定子分区定义;一种不指定，按照默认子分区
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 ADD PARTITION P11 VALUES('bki9fdger') tablespace partrange_tablespace1;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'CantianDB' || 1 ||'Bdbed','bki'|| 9 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');
SELECT count(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 PARTITION(P11);
COMMIT;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 DROP PARTITION P11;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 ADD PARTITION P11 VALUES('bki9fdger') tablespace partrange_tablespace1
(
 SUBPARTITION P11_1 VALUES('CantianDB0Bdbed'),
 SUBPARTITION P11_2 VALUES('CantianDB1Bdbed'),
 SUBPARTITION P11_3 VALUES('CantianDB2Bdbed'),
 SUBPARTITION P11_4 VALUES('CantianDB3Bdbed'),
 SUBPARTITION P11_5 VALUES('CantianDB4Bdbed')
);
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'CantianDB' || 1 ||'Bdbed','bki'|| 9 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 partition(P11);
COMMIT;

--测试truncate以及闪回操作
select count(*) from nebula.strg_range_ddl_mul_tbl_001;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
alter table nebula.strg_range_ddl_mul_tbl_001 truncate subpartition part_92;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_92 to before truncate;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
alter table nebula.strg_range_ddl_mul_tbl_001 truncate subpartition part_92;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into nebula.strg_range_ddl_mul_tbl_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000 where c_id > 1640 and c_id <= 1660;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_92 to before truncate;
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_92 to before truncate force;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_92 to before truncate force;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
purge recyclebin;
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_92 to before truncate;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);

alter table nebula.strg_range_ddl_mul_tbl_001 truncate partition part_9;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
flashback table nebula.strg_range_ddl_mul_tbl_001 partition part_9 to before truncate;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
alter table nebula.strg_range_ddl_mul_tbl_001 truncate partition part_9;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into nebula.strg_range_ddl_mul_tbl_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000 where c_id > 1640 and c_id <= 1800;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
flashback table nebula.strg_range_ddl_mul_tbl_001 partition part_9 to before truncate;
flashback table nebula.strg_range_ddl_mul_tbl_001 partition part_9 to before truncate force;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
purge recyclebin;
commit;

--测试分区的split
alter table nebula.strg_range_ddl_mul_tbl_001 split subpartition part_93 at(1700, 'D') into (subpartition part_931 tablespace partrange_tablespace1, subpartition part_932 tablespace partrange_tablespace2);

alter table nebula.strg_range_ddl_mul_tbl_001 split partition part_8 at(1500, 'J', 'J', 'J') into (partition part_10 tablespace partrange_tablespace1 storage(initial 2m maxsize 8m),partition part_12 tablespace partrange_tablespace2 storage(initial 2m maxsize 8m));

alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 add column_add1 varchar(40);
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set column_add1=C_FIRST;
SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;

SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;
--add constraint-非分区键部分索引;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 add constraint PK_RANGE_DDL_MUL_TBL_001 primary key(C_W_ID);
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 add constraint UK_RANGE_DDL_MUL_TBL_001 unique(C_ID,C_W_ID);
SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 modify C_STREET_1 varchar(100);
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 modify C_W_ID float;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column C_LAST;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column C_STREET_2;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column C_D_ID;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column C_STREET_1;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column C_PHONE;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column column_add1;
SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;

--truncate不连续多分区;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 TRUNCATE PARTITION PART_1 reuse storage;
truncate table NEBULA.STRG_RANGE_DDL_MUL_TBL_001;
DELETE FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 WHERE (C_ID - 5*(FLOOR(C_ID/5)))=3;
SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 DROP PARTITION P11;
SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop constraint UK_RANGE_DDL_MUL_TBL_001;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop constraint PK_RANGE_DDL_MUL_TBL_001;
drop table NEBULA.STRG_RANGE_DDL_MUL_TBL_001;
purge recyclebin;

--list-hash
drop table if exists NEBULA.STRG_RANGE_DDL_MUL_TBL_001;
CREATE TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_ID INT,C_D_ID INT NOT NULL,C_W_ID INT NOT NULL,C_FIRST VARCHAR(64) NOT NULL,C_MIDDLE CHAR(3),C_LAST VARCHAR(64) NOT NULL,C_STREET_1 VARCHAR(20) NOT NULL,C_STREET_2 VARCHAR(20),C_CITY VARCHAR(64) NOT NULL,C_STATE CHAR(2) NOT NULL,C_ZIP CHAR(9) NOT NULL,C_PHONE CHAR(16) NOT NULL,C_SINCE TIMESTAMP,C_CREDIT CHAR(2) NOT NULL,C_CREDIT_LIM NUMERIC(12,2),C_DISCOUNT NUMERIC(4,4),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL NOT NULL,C_PAYMENT_CNT NUMBER NOT NULL,C_DELIVERY_CNT BOOLEAN NOT NULL,C_END DATE NOT NULL,C_VCHAR VARCHAR(1000),C_DATA CLOB,C_TEXT BLOB ) PARTITION BY list(c_street_1) SUBPARTITION BY HASH(C_LAST, C_STREET_2) (
PARTITION PART_1 VALUES('bki0fdger') tablespace partrange_tablespace1
(
 SUBPARTITION PART_11,
 SUBPARTITION PART_12,
 SUBPARTITION PART_13,
 SUBPARTITION PART_14
),
PARTITION PART_2 VALUES('bki1fdger') tablespace partrange_tablespace1
(
 SUBPARTITION PART_21,
 SUBPARTITION PART_22,
 SUBPARTITION PART_23,
 SUBPARTITION PART_24
),
PARTITION PART_3 VALUES('bki2fdger') tablespace partrange_tablespace1
(
 SUBPARTITION PART_31,
 SUBPARTITION PART_32,
 SUBPARTITION PART_33,
 SUBPARTITION PART_34
),
PARTITION PART_4 VALUES('bki3fdger') tablespace partrange_tablespace1
(
 SUBPARTITION PART_41,
 SUBPARTITION PART_42,
 SUBPARTITION PART_43,
 SUBPARTITION PART_44
),
PARTITION PART_5 VALUES('bki4fdger') tablespace partrange_tablespace1
(
 SUBPARTITION PART_51,
 SUBPARTITION PART_52,
 SUBPARTITION PART_53,
 SUBPARTITION PART_54
),
PARTITION PART_6 VALUES('bki5fdger') tablespace partrange_tablespace1
(
 SUBPARTITION PART_61,
 SUBPARTITION PART_62,
 SUBPARTITION PART_63,
 SUBPARTITION PART_64
),
PARTITION PART_7 VALUES('bki6fdger') tablespace partrange_tablespace1
(
 SUBPARTITION PART_71,
 SUBPARTITION PART_72,
 SUBPARTITION PART_73,
 SUBPARTITION PART_74
),
PARTITION PART_8 VALUES('bki7fdger') tablespace partrange_tablespace1
(
 SUBPARTITION PART_81,
 SUBPARTITION PART_82,
 SUBPARTITION PART_83,
 SUBPARTITION PART_84
),
PARTITION PART_9 VALUES('bki8fdger') tablespace partrange_tablespace1
(
 SUBPARTITION PART_91,
 SUBPARTITION PART_92,
 SUBPARTITION PART_93,
 SUBPARTITION PART_94
),
PARTITION PART_10 VALUES(default) tablespace partrange_tablespace1);
CREATE  UNIQUE INDEX  NEBULA.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_ID,C_CITY,C_FIRST,C_LAST)   tablespace partrange_tablespace2;
CREATE UNIQUE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_CITY,C_LAST,C_STREET_2)  tablespace partrange_tablespace2;
CREATE UNIQUE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_STREET_2,C_D_ID)  tablespace partrange_tablespace2;
CREATE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_CITY,C_FIRST)  LOCAL tablespace partrange_tablespace2;
CREATE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_STREET_1,C_W_ID)  LOCAL tablespace partrange_tablespace2;
INSERT INTO NEBULA.STRG_RANGE_DDL_MUL_TBL_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000;
COMMIT;

--测试基础DML操作
savepoint aa;
delete from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 where mod(c_id, 2) = 1;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set c_w_id = c_w_id + 100 where c_id < 41;
select c_w_id from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 where c_id < 41;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_12);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_13);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_14);
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set c_last = 'CantianDB' where c_street_1 = 'bki0fdger';
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_12);
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set c_id = c_id - 240, c_street_1 = 'bki0fdger' where c_street_1 = 'bki1fdger';
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_12);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_13);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_14);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 partition(part_2);
rollback to savepoint aa;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_12);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_13);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_14);

ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop subpartition part_91;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_91);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_92);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_93);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_94);
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 modify partition part_9 coalesce subpartition;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_91);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_92);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_93);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_94);
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 modify partition part_9 add subpartition part_94;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop PARTITION PART_10;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'J' || 2000 ||'Bdbed','bki'|| 9 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');

--测试两种添加分区的方案，一种指定子分区定义;一种不指定，按照默认子分区
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 ADD PARTITION P11 VALUES('bki9fdger') tablespace partrange_tablespace1;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'J' || 2000 ||'Bdbed','bki'|| 9 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');
SELECT count(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 PARTITION(P11);
COMMIT;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 DROP PARTITION P11;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 ADD PARTITION P11 VALUES('bki9fdger') tablespace partrange_tablespace1
(
 SUBPARTITION P11_1 tablespace partrange_tablespace1,
 SUBPARTITION P11_2 tablespace partrange_tablespace2,
 SUBPARTITION P11_3 tablespace partrange_tablespace1,
 SUBPARTITION P11_4 tablespace partrange_tablespace2
);
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'J' || 2000 ||'Bdbed','bki'|| 9 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');
SELECT count(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 PARTITION(P11);
COMMIT;

--测试truncate以及闪回操作
select count(*) from nebula.strg_range_ddl_mul_tbl_001;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
alter table nebula.strg_range_ddl_mul_tbl_001 truncate subpartition part_92;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_92 to before truncate;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
alter table nebula.strg_range_ddl_mul_tbl_001 truncate subpartition part_92;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into nebula.strg_range_ddl_mul_tbl_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000 where c_id > 1640 and c_id <= 1660;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_92 to before truncate;
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_92 to before truncate force;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_92 to before truncate force;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
purge recyclebin;
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_92 to before truncate;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);

alter table nebula.strg_range_ddl_mul_tbl_001 truncate partition part_9;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
flashback table nebula.strg_range_ddl_mul_tbl_001 partition part_9 to before truncate;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
alter table nebula.strg_range_ddl_mul_tbl_001 truncate partition part_9;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into nebula.strg_range_ddl_mul_tbl_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000 where c_id > 1640 and c_id <= 1800;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
flashback table nebula.strg_range_ddl_mul_tbl_001 partition part_9 to before truncate;
flashback table nebula.strg_range_ddl_mul_tbl_001 partition part_9 to before truncate force;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_9);
purge recyclebin;
commit;

--测试分区的split
alter table nebula.strg_range_ddl_mul_tbl_001 split subpartition part_93 at(1700, 'D') into (subpartition part_931 tablespace partrange_tablespace1, subpartition part_932 tablespace partrange_tablespace2);

alter table nebula.strg_range_ddl_mul_tbl_001 split partition part_8 at(1500, 'J', 'J', 'J') into (partition part_10 tablespace partrange_tablespace1 storage(initial 2m maxsize 8m),partition part_12 tablespace partrange_tablespace2 storage(initial 2m maxsize 8m));

--hash子分区的收缩添加
select count(*) from nebula.strg_range_ddl_mul_tbl_001 subpartition(part_72);
select count(*) from nebula.strg_range_ddl_mul_tbl_001 subpartition(part_74);
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter table nebula.strg_range_ddl_mul_tbl_001 modify partition part_7 coalesce subpartition;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 subpartition(part_72);
alter table nebula.strg_range_ddl_mul_tbl_001 modify partition part_7 add subpartition part_74;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 subpartition(part_72);
select count(*) from nebula.strg_range_ddl_mul_tbl_001 subpartition(part_74);

alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 add column_add1 varchar(40);
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set column_add1=C_FIRST;
SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;

SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;
--add constraint-非分区键部分索引;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 add constraint PK_RANGE_DDL_MUL_TBL_001 primary key(C_W_ID);
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 add constraint UK_RANGE_DDL_MUL_TBL_001 unique(C_ID,C_W_ID);
SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 modify C_STREET_1 varchar(100);
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 modify C_W_ID float;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column C_LAST;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column C_STREET_2;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column C_D_ID;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column C_STREET_1;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column C_PHONE;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop column column_add1;
SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;

--truncate不连续多分区;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 TRUNCATE PARTITION PART_1 reuse storage;
truncate table NEBULA.STRG_RANGE_DDL_MUL_TBL_001;
DELETE FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 WHERE (C_ID - 5*(FLOOR(C_ID/5)))=3;
SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 DROP PARTITION P11;
SELECT DISTINCT FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1),COUNT(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 GROUP BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) ORDER BY FLOOR(C_ID/100),substr(C_FIRST,1,1),substr(C_LAST,1,1),substr(C_CITY,1,1) DESC;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop constraint UK_RANGE_DDL_MUL_TBL_001;
alter table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop constraint PK_RANGE_DDL_MUL_TBL_001;
drop table NEBULA.STRG_RANGE_DDL_MUL_TBL_001;
purge recyclebin;
drop tablespace partrange_tablespace1 including contents and datafiles;
drop tablespace partrange_tablespace2 including contents and datafiles;
drop user if exists nebula cascade;